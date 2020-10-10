include "advio.asm"

rsv:    macro   name size
name:   equ     $
        org     $+size
        endm

slot:   equ     3               ; can be 1-6
pbase:  equ     060h-(010h*slot)
pdata:  equ     pbase
pctrl:  equ     pbase+001h
pbaud:  equ     pbase+008h
pinmsk: equ     pbase+00ah
txrdy:  equ     001h
rxrdy:  equ     002h

;;; 8251 mode flags
xsync:  equ     00000000b
x1:     equ     00000001b
x16:    equ     00000010b
x64:    equ     00000011b

bits5:  equ     00000000b
bits6:  equ     00000100b
bits7:  equ     00001000b
bits8:  equ     00001100b

parnone:equ     00100000b
parodd: equ     00010000b
pareven:equ     00110000b

stop1:  equ     01000000b
stop15: equ     10000000b
stop2:  equ     11000000b

;;; 8251 command flags
txe:    equ     001h            ; transmit enable
dtr:    equ     002h            ; data terminal ready
rxe:    equ     004h            ; receive enable
sbrk:   equ     008h            ; 0:norm 1:sendbreak
er:     equ     010h            ; reset error flags
rts:    equ     020h            ; request to send
ir:     equ     040h            ; internal reset
hunt:   equ     080h            ; synchronous hunt

;;; These calculations assume the crystal is 7.9872MHz
;;; The actual crystals used are 8.0000 MHz
;;; But this gives cleaner rounding for same values

;;; 19200*13*2*16 = 7987200
;;; 19230.76923ish *13*2*16 = 8000000
;;; or 0.16% error, which is still within spec

;;; 'baudrate' equ sets desired baud rate
;;; baud1, baud16, baud64 are the counter register values to achieve
;;;     that under the given clock divider

baudrate:equ    38400
baud1:  equ     128-(307200/baudrate)
baud16: equ     128-(19200/baudrate)
baud64: equ     128-(4800/baudrate)

stacktop:equ    0fffeh
sentry: equ     0c00ah
        org     0c000h
sstart:
        db      $>>8

vidcall:
        jp      romcout
viddest:
        ret

        ds      sentry-$,0
entry:  jp      start
start:  di
        ld      sp,stacktop
        push    hl
        call    initvar

        ;; write message
        ld      ix,vidblock
        ld      hl,vidmap
        call    runioseq
        ld      hl,strinit
        call    putstr

        ;; relocate if needed
        ld      a,3
        out     (memmap0),a
        ld      hl,0c000h
        ld      de,0
        ld      bc,04000h
        ldir
        ld      hl,flatmap
        call    runioseq

        ;; wipe low ram
        ld      a,0
        ld      hl,0
        ld      de,1
        ld      (hl),a
        ld      bc,0bfffh
        ldir

        ld      hl,memio        ; enable memparity
        call    runioseq

        ld      hl,inthandler   ; build IDT
        ld      (intvec),hl
        ld      a,intvec>>8
        ld      i,a             ; load IDT (always ff on adv)
        im      2               ; interrupt mode 2

        xor     a
        out     (clrdsf),a      ; re-clear display flag
        ;; tell the devices to generate interrupts
        ;; kbd maskable interrupt can only be read and toggled
kbdmi:  ld      c,09bh          ; remove blanking, enable vid int, keyboard mi
        call    iocmd
        in      a,(rdst2)
        and     001h          ; yeah, redo to flip it back
                                ; on boot it's disabled so this is faster
        jr      z,kbdmi

        ld      c,098h          ; normal run + video interrupt
        call    iocmd

        call    resetserial

        ;; hopefully now ready to run!
        ei
        xor     a

newxmodem:
        ld      a,'C'           ; send C until they give us a packet
        ld      (pknak),a
        ld      a,1
        ld      (pkidx),a

nakpacket:
        ld      a,(pknak)
        ld      c,a
        call    serputch
getpacket:
        xor     a
        ld      (pktpos),a
        ld      hl,pkt
gploop:
        ld      bc,0
        call    sergetchwait
        cp      0
        jr      nz,notzero
        ld      a,b
        or      c
        jr      z,ptimeout
        xor     a
notzero:
        ld      (hl),a
        inc     hl
        ld      a,(pktpos)
        inc     a
        ld      (pktpos),a
        cp      133             ; 133 byte xmodem-crc packet?
        jr      nz,gploop
fullpacket:
        ld      hl,pkt
        ld      a,(hl)
        cp      1
        jr      nz,nakpacket
        inc     hl
        ld      a,(hl)
        ld      b,a
        ld      a,(pkidx)
        cp      b
        jr      nz,nakpacket
        inc     hl
        ld      a,(hl)
        cpl
        ld      b,a
        ld      a,(pkidx)
        cp      b
        jr      nz,nakpacket
        inc     hl
        ld      bc,128          ; 128 bytes data
        call    crc16
        ld      a,(hl)
        cp      b
        jr      nz,nakpacket
        inc     hl
        ld      a,(hl)
        cp      c
        jr      nz,nakpacket
goodpacket:
        ld      a,(dladdr)
        ld      e,a
        ld      a,(dladdr+1)
        ld      d,a
        ld      bc,128
        ld      hl,(pkt+3)
        ldir
        ld      a,e
        ld      (dladdr),a
        ld      a,d
        ld      (dladdr+1),a
        ld      a,(pkidx)
        inc     a
        ld      (pkidx),a
        ld      c,006h          ; ACK
        call    serputch
        ld      a,015h          ; use NAK from now on
        ld      (pknak),a
        jr      getpacket

ptimeout:
        ld      a,(pktpos)
        ld      hl,pkt
        ld      a,(hl)
        cp      004h            ; EOT
        jr      z,xmodemdone
        cp      018h            ; CAN
        jp      nz,nakpacket
        jp      newxmodem

xmodemdone:
        ld      c,006h
        call    serputch
        jp      0

resetserial:
        push    hl
        push    af
        ld      hl,ser_reset
        call    runioseq
        in      a,(pdata)       ; clear 8251 poweron gubbish
        in      a,(pdata)
        pop     af
        pop     hl
        ret

        ;; returns char in a
        ;; blocking
sergetch:
        in      a,(pctrl)
        and     rxrdy
        jr      z,sergetch
        in      a,(pdata)
        ret

        ;; returns char in a (or 0)
        ;; bc in is waittime; unit is 14usec @ 4MHz
        ;; bc0 (64k steps) gives roughly 917.504 ms
        ;; time left in bc
sergetchwait:
        in      a,(pctrl)       ; 3Mc 11Ts  \
        and     rxrdy           ; 2Mc  7Ts   > 8Mc 32Ts
        jr      z,trywait       ; 3Mc 12Ts  /
        in      a,(pdata)
        ret
trywait:
        dec     bc              ; 1Mc  6Ts  \
        ld      a,b             ; 1Mc  4Ts   > 6Mc 24Ts
        or      c               ; 1Mc  4Ts  /
        jr      nz,sergetchwait ; 3Mc 12Ts /
        xor     a
        ret

        ;; send char in c
        ;; blocking
serputch:
        push    af
        in      a,(pctrl)
        and     txrdy
        jr      z,serputch
        ld      a,c
        out     (pdata),a
        pop     af
        ret

        ;; display char in c
vidputch:
        push    bc
        push    de
        push    hl
        push    af
        ld      a,c
        jp      romcout
        pop     af
        pop     hl
        pop     de
        pop     bc
        ret

        ;; return key pressed in a
        ;; blocking
kbdgetch:
        in      a,(rdst2)
        bit     6,a
        jr      z,kbdgetch      ; wait for a keypress if needed
kbdgetcha:
        push    bc
        push    de
        ld      c,098h | 001h
        call    iocmd
        in      a,(rdst2)
        and     00fh
        ld      d,a
        ld      c,098h | 002h
        call    iocmd
        in      a,(rdst2)
        add     a,a
        add     a,a
        add     a,a
        add     a,a
        add     a,d
        pop     de
        pop     bc
        ret

;;; send sequences of data to various i/o ports
        ;; iopacket start in hl
        ;; format is count, port, data...
        ;; count zero ends the sequence
        ;; count 0ffh delays (le16 count of 6usec steps)
runioseq:
        push    bc
        push    af
runioloop:
        ld      a,(hl)
        inc     hl
        cp      0
        jr      z,runiodone
        cp      0ffh
        jr      z,riodelay
        ld      b,a
        ld      c,(hl)
        inc     hl
        otir
        jr      runioseq
riodelay:
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
        call    delay
        jr      runioseq
runiodone:
        pop     af
        pop     bc
        ret

;;; send a command to the 8035 for i/o, floppy, and kbd control
        ;; command in c
iocmd:
        push    bc
        push    af
        in      a,(rdst2)
        ld      b,a
        ld      a,c
        out     (ldioctl),a
iocloop:
        in      a,(rdst2)
        xor     b
        jp      p,iocloop
        pop     af
        pop     bc
        ret

;;; console print a stringz
        ;; stringz addr in HL
        ;; HL just past the zero byte afterward
        ;; assumes IX is already set to vidblock
putstr:
        push    bc
        push    de
        push    af
        push    iy
.psloop: ld      a,(hl)
        cp      000h
        jr      z,.putstrout
        push    hl
        call    vidcall
        pop     hl
        inc     hl
        jr      .psloop
.putstrout:
        inc     hl
        pop     iy
        pop     af
        pop     de
        pop     bc
        ret

        ;; stringz addr in HL
        ;; HL just past the zero byte afterward
serputstr:
        push    bc
        push    af
.spsloop:
        ld      a,(hl)
        inc     hl
        cp      000h
        jr      z,.serputstrout
        ld      c,a
.spswait:
        in      a,(pctrl)
        and     txrdy
        jr      z,.spswait
        ld      a,c
        out     (pdata),a
        jr      .spsloop
.serputstrout:
        pop     af
        pop     bc
        ret

        ;; delay by BC steps; step is 6usec
        ;; clobber BC AF
delay:
        ;; loop core is 6M / 24T after pipelining; 6usec @4MHz
        dec     bc              ; 1Mc  6Ts
        ld      a,b             ; 1Mc  4Ts
        or      c               ; 1Mc  4Ts
        jr      nz,delay        ; 3Mc 12Ts or
                                ; 2Mc  7Ts
        ret                     ; 3Mc 10Ts

kbdint:
        push    af
        in      a,(rdst2)
        bit     6,a
        jr      z,kbdintout
        call    kbdgetcha
        cp      003h            ; control-c?
        jr      nz,kbderr
        ;; they hit ctrl-c!
        ld      hl,ctrlcmsg
        push    hl
        call    serputstr
        pop     hl
        jp      abort
kbderr:
        ;; they hit something, but it wasn't control-c
        ;; so make a ruckus and then continue
        in      a,(flpbeep)
kbdintout:
        pop     af
        ret

ioint:
        push    af
        pop     af
        ret

dispint:
        push    af
        xor     a
        out     (clrdsf),a
        pop     af
        ret

nmiint:
        out     (clearnmi),a
        ld      hl,nmimsg
        jp      abort

memint:
        ld      hl,paritymsg
        jp      abort

        ;; message in HL
abort:
        push    hl
        ld      hl,vidmap
        call    runioseq
        pop     hl
        call    putstr
        ld      c,028h
        call    iocmd
        ld      c,018h
        call    iocmd
        xor     a
        out     (memparity),a   ; disable parity
        ld      a,(ix+0)        ; copy cursor pos to minimon vidblock
        ld      (000f0h),a
        ld      a,(ix+1)
        ld      (000f1h),a
        xor     a
        ld      (002fdh),a      ; stop debug flag so minimon uses serial
        ld      a,(flpbeep)
        jp      082abh          ; hard jump to minimon return point

inthandler:
        push    bc
        push    de
        push    hl
        push    af
        push    ix

        ;; maintain 32bit interrupt count
        ld      hl,intcount
        inc     (hl)
        jr      nz,intincdone
        inc     hl
        inc     (hl)
        jr      nz,intincdone
        inc     hl
        inc     (hl)
        jr      nz,intincdone
        inc     hl
        inc     (hl)
intincdone:

        ;; call handlers as needed
        in      a,(rdst1)
        rrca
        call    c,kbdint
        rrca
        call    c,ioint
        rrca
        call    c,dispint
        rrca
        call    c,nmiint
        ld      a,(memparity)
        and     001h
        jr      z,memint
        pop     ix
        pop     af
        pop     hl
        pop     de
        pop     bc
        ei
        reti

        ;; rommable copy of initial vidblock
initvb:
        db      0, 0
        dw      08561h
        db      0, 0
        dw      viddest
        dw      vcursor
        db      0
        ds      10, 0ffh
initvb_end:

initvar:
        ;; zero trailing ram
        xor     a
        ld      hl,endrom
        ld      (hl),a
        ld      de,endrom+1
        ld      bc,0ffffh-endrom
        ldir

        ;; set up the vidblock
        ld      ix,vidblock
        ld      de,vidblock
        ld      hl,initvb
        ld      bc,initvb_end-initvb
        ldir

        ;; leave all other vars zeroed
        ret

include 'crc16.asm'

strinit:
        db      019h, 01eh, 00fh
        dm      "XMODEM-CRC boot utility"
        db      01fh, 01fh
        dm      "Configuring slot3 SIO board for 38400 8N1"
        db      01fh, 01fh, 0

ctrlcmsg:
        dm      "ctrl-c hit, returning to minimon"
        db      01fh, 01fh, 0

nmimsg:
        dm      "NMI received, returning to minimon"
        db      01fh, 01fh, 0

paritymsg:
        dm      "Memory parity failure, returning to minimon"
        db      01fh, 01fh, 0

vidmap:
        db      1, memmap0, 080h ; 0000-3fff -> vram 0000-3fff (16k)
        db      1, memmap1, 081h ; 4000-7fff -> vram 4000-4fff (4k) x 4
        db      1, memmap2, 0ffh ; 8000-bfff -> rom  0000-0800 (2k) x 8
        ;; map3 unset!
        db      0

flatmap:
        db      1, memmap0, 0
        db      1, memmap1, 1
        db      1, memmap2, 2
        db      1, memmap3, 3
        db      0

memio:
        db      1, memparity, 003h ; enable memory parity / ints
        db      0

ser_reset:
        ;; see H-12, 8251 USART Programming
        ;; hunt does nothing in async, but potentially exits the
        ;;     double sync spec, so we can reset
        ;; ir enters mode select
        db      3, pctrl, hunt, hunt, ir

        db      0ffh
        dw      150000/6        ; delay 150ms

        ;; config serial clock for 38400, which needs x1
        db      1, pbaud, baud1

        db      0ffh
        dw      10000/6         ; delay 10ms

        ;; configure for Async 38400 8N1
        db      2, pctrl
        db      x1|bits8|parnone|stop1  ; mode
        db      rts|er|rxe|dtr|txe      ; command

        db      0ffh
        dw      10000/6         ; delay 10ms

        db      1, pinmsk, 0    ; run in polling mode for the moment
        db      0

        ;; reset to 9600 8n2 for monitor
monser:
        db      3, pctrl, hunt, hunt, ir
        db      0ffh
        dw      150000/6
        db      1, pbaud, 07eh  ; x16 9600
        db      0ffh
        dw      10000/6
        db      2, pctrl
        db      x16|bits8|parnone|stop2 ;mode
        db      rts|er|rxe|dtr|txe
        db      0ffh
        dw      10000/6
        db      1, pinmsk, 0
        db      0

endrom:

vidblock:
        rsv     vx 1            ; cursor column
        rsv     vy 1            ; cursor pixel row
        rsv     vfont 2         ; 08561h rom font
        rsv     vscrl 1         ; initial scroll count 0
        rsv     vstat 1         ; status
        rsv     vret 2          ; vidreturn address
        rsv     vctemp 2        ; cursor template address
        rsv     vinv 1          ; inverse flag
        rsv     vcursor 10      ; cursor template (0ffh x 10)
        rsv     intcount 4
        rsv     dladdr 2
        rsv     pkidx 1
        rsv     pktpos 1
        rsv     pknak 2

        org     $|0ffh          ; skip to end-of-page for IDT
        rsv     intvec 2        ; all (maskable) interrupts vector
        rsv     pkt 133         ; buffer for xmodem-crc packet
endram:
        end
