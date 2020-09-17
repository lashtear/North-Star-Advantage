; NorthStar Advantage Boot ROM
; originally disassembled by z80dasm 1.1.5
; command line: z80dasm -a -l -g 0x8000 -t "Advantage Boot Rom.BIN"

; monitor's video driver scratch area
; Yes this is in display ram when the monitor is running!
; eleven byte area as in table 3-14, cursor template is only two bytes
; example on page 3-30 with 10 bytes in ctemp is wrong; it's a pointer to ten...
mvcursx: equ     000f0h         ;00f0 cursor x coord
mvcursy: equ     000f1h         ;00f1 cursor y coord
mvpixel: equ     000f2h         ;00f2 pointer to font data
mvscrct: equ     000f4h         ;00f4 scroll count
mvstats: equ     000f5h         ;00f5 status
mvretfp: equ     000f6h         ;00f6 return pointer
mvctptr: equ     000f8h         ;00f8 cursor template pointer (point to 002f0h)
mvinvd:  equ     000fah         ;00fa inverse video flag

gthxhi:  equ     000fch         ;00fc-00ff gethex conversion buffer
gthxlo:  equ     000feh         ;00fc-00ff gethex conversion buffer

mvctemp: equ     002f0h         ;02f0 cursor template
serialfound:equ  002fdh         ;02fd set when serial card in slot 3
mmdaddr: equ     002feh         ;02fe minimon dump address reg
lastkey: equ     003ffh         ;03ff last key pressed (for repeat)

include "advio.asm"

        org      08000h

        ; On boot this sits at 0x0000, so yes this sets up stack and
        ; saves registers right on top of itself (ROM) -- but it also
        ; works as a usable save/restore after relocation

        ; setup stack
coldstart:
        ld sp,00017h            ;8000   31 17 00        1 . .
warmstart:
        ; save regs
        push af                 ;8003   f5      .
        push bc                 ;8004   c5      .
        push de                 ;8005   d5      .
        push hl                 ;8006   e5      .
        exx                     ;8007   d9      .
        ex af,af'               ;8008   08      .
        push af                 ;8009   f5      .
        push bc                 ;800a   c5      .
        push de                 ;800b   d5      .
        push hl                 ;800c   e5      .
        push ix                 ;800d   dd e5   . .
        push iy                 ;800f   fd e5   . .
        ld a,i                  ;8011   ed 57   . W
        push af                 ;8013   f5      .
        ld iy,00000h            ;8014   fd 21 00 00     . ! . .
        add iy,sp               ;8018   fd 39   . 9
        ; configure bank 0x8000-0xbfff as this boot rom
        ld a,0fch               ;801a   3e fc   > .
        out (memmap2),a         ;801c   d3 a2   . .
        ; jump to remapped copy
        jp postreloc            ;801e   c3 21 80        . ! .
postreloc:
        di                      ;8021   f3      .
resetloop:
        ; send 00101000: reset blank
        ld a,028h               ;8022   3e 28   > (
        out (ldioctl),a         ;8024   d3 f8   . .
        xor a                   ;8026   af      .
l8027h:
        ex (sp),hl              ;8027   e3      .
        djnz l8027h             ;8028   10 fd   . .
        dec a                   ;802a   3d      =
        jr nz,l8027h            ;802b   20 fa     .
        ld bc,00fa0h            ;802d   01 a0 0f        . . .
        ; send 00111111: compallcaps blank
        ld a,03fh               ;8030   3e 3f   > ?
        out (ldioctl),a         ;8032   d3 f8   . .
waitnmi:
        ; wait for NMI
        in a,(rdst1)            ;8034   db e0   . .
        and 008h                ;8036   e6 08   . .
interruptvec:
        jr nz,resetloop         ;8038   20 e8     .
        dec bc                  ;803a   0b      .
        ld a,b                  ;803b   78      x
        or c                    ;803c   b1      .
        jr nz,waitnmi           ;803d   20 f5     .
        out (clearnmi),a        ;803f   d3 c0   . .
        jr setlowmaps           ;8041   18 28   . (
strloadsystem:
        dm "LOAD SYSTEM"
        db 01fh
        ;;  this is serial pre-amble sent via otir
sertable:
        ;;  see 8251 2-13 fig 12, reset, mode 0c
        ;; hunt, hunt, reset
        db 080h                 ;804f   80
        db 080h                 ;8050   80
        db 040h                 ;8051   40

sertable2:
        ;; mode xsync|bits8, odd but no parity, 2char sync, syndet out
        db 00ch                 ;8052   0c
        db 010h                 ;8053   10 SYN sync char 1
        db 016h                 ;8054   16 DLE sync char 2
        ;; b7 as ctrl is hunt|rts|er|rxe|dtr|txe
        db 0b7h                 ;8055   b7

sertable3:
        ;; data for boot program request
        db 010h                 ;8056   10 SYN
        db 016h                 ;8057   16 DLE
        db 005h                 ;8058   05 ENQ
        db 0ffh                 ;8059   ff PAD
        db 010h                 ;805a   10 SYN
        db 016h                 ;805b   16 DLE
        db 004h                 ;805c   04 EOT
        db 001h                 ;805d   01 NUM (1 for adv)
        db 005h                 ;805e   05 ENQ
        db 0ffh                 ;805f   ff PAD

        nop                     ;8060   00      .
        nop                     ;8061   00      .
        nop                     ;8062   00      .

        nop                     ;8063   00      .
        nop                     ;8064   00      .
        nop                     ;8065   00      .
rebootornmi:
        ; see 3.13.1 on 3-78
        ; This is 0x0066 initially during NMI
        nop                     ;8066   00      .
        nop                     ;8067   00      .
        nop                     ;8068   00      .
        jr warmstart            ;8069   18 98   . .
setlowmaps:
        ; map vram to 0x0000-0x7fff
        ld a,0f8h               ;806b   3e f8   > .
        out (memmap0),a         ;806d   d3 a0   . .
        inc a                   ;806f   3c      <
        out (memmap1),a         ;8070   d3 a1   . .
l8072h:
        ld sp,00200h            ;8072   31 00 02        1 . .
        call sub_82bdh          ;8075   cd bd 82        . . .
        out (memmap3),a         ;8078   d3 a3   . .
        out (ldstsc),a          ;807a   d3 90   . .
        out (clrdsf),a          ;807c   d3 b0   . .

        ; send 00011000: (normal)
        ld a,018h               ;807e   3e 18   > .
        out (ldioctl),a         ;8080   d3 f8   . .

;;; examine slot 3's board id tag
;;; sio boards return F7
;;; if, instead, it is E8-EF, then set 002fdh to zero
;;; this enables minimon serial control via slot 3 at 9600 8N2 (yes 2!)
;;;
;;; so, from poweron, wait for LOAD SYSTEM
;;; hit ctrl-C to get into minimon
;;; J808D (which does the serial init as if it's an E8 style debug board)
;;; hit ctrl-C again
;;; D02FD00
;;; and now you can remotely control the minimon, for loading/dumping, etc
;;; bulk writes will need delay steps as it's polled and can't keep up
;;; especially if you go to 19200 via O7F38
        in a,(idslt3)           ;8082   db 73   . s
        and 0f8h                ;8084   e6 f8   . .
        sub 0e8h                ;8086   d6 e8   . .
        ld (serialfound),a      ;8088   32 fd 02        2 . .

        jr nz,printloadsystem   ;808b   20 11     .
        ;; reset serial, set baud to 9600
        ld a,07eh               ;808d   3e 7e   > ~
        call serialinit         ;808f   cd 74 82        . t .
        ;; mode ce is x16|bits8| no parity | stop2
        ld a,0ceh               ;8092   3e ce   > .
        out (sioctl),a          ;8094   d3 31   . 1
        ;; control 37 is rts|er|rxe|dtr|txe
        ld a,037h               ;8096   3e 37   > 7
        out (sioctl),a          ;8098   d3 31   . 1
        ;; clear 8251 poweron gubbish
        in a,(siodata)          ;809a   db 30   . 0
        in a,(siodata)          ;809c   db 30   . 0
printloadsystem:
        ld hl,strloadsystem     ;809e   21 43 80        ! C .
        ld c,00ch               ;80a1   0e 0c   . .
printlsloop:
        ld b,(hl)               ;80a3   46      F
        call dispchar           ;80a4   cd 6c 83        . l .
        inc hl                  ;80a7   23      #
        dec c                   ;80a8   0d      .
        jr nz,printlsloop       ;80a9   20 f8     .
        ld hl,setlowmaps        ;80ab   21 6b 80        ! k .
        push hl                 ;80ae   e5      .
        in a,(flpbeep)          ;80af   db 83   . .
        call getchar            ;80b1   cd 25 83        . % .
        cp 'D'                  ;80b4   fe 44   . D
        jr z,tryfloppyboot      ;80b6   28 0b   ( .
        cp 'S'                  ;80b8   fe 53   . S
        jp z,tryserialboot      ;80ba   ca e3 81        . . .
        sub 00dh                ;80bd   d6 0d   . .
        ret nz                  ;80bf   c0      .
        inc a                   ;80c0   3c      <
        jr l80dch               ;80c1   18 19   . .
tryfloppyboot:
        call getchar            ;80c3   cd 25 83        . % .
        cp '1'                  ;80c6   fe 31   . 1
        ret c                   ;80c8   d8      .
        cp '5'                  ;80c9   fe 35   . 5
        ret nc                  ;80cb   d0      .
        sub '0'                 ;80cc   d6 30   . 0
        ld b,a                  ;80ce   47      G
        xor a                   ;80cf   af      .
        scf                     ;80d0   37      7
l80d1h:
        rla                     ;80d1   17      .
        djnz l80d1h             ;80d2   10 fd   . .
        ld d,a                  ;80d4   57      W
        call getchar            ;80d5   cd 25 83        . % .
        cp 00dh                 ;80d8   fe 0d   . .
        ret nz                  ;80da   c0      .
        ld a,d                  ;80db   7a      z
l80dch:
        exx                     ;80dc   d9      .
        ld c,a                  ;80dd   4f      O
        exx                     ;80de   d9      .
        ;; Start drive motors!
        ld a,01dh               ;80df   3e 1d   > .
        out (ldioctl),a         ;80e1   d3 f8   . .
        ; clear parity errors, disable parity interrupt
        ld a,002h               ;80e3   3e 02   > .
        out (memparity),a       ;80e5   d3 60   . `

        ;; try seeking inward up to ten tracks ?
        ld b,00ah               ;80e7   06 0a   . .
step_inward:
        ;; step toward inner, side 0
        ld a,0a0h               ;80e9   3e a0   > .
        call step_track_arm     ;80eb   cd 8f 81        . . .
        ;; check for track0
        in a,(rdst1)            ;80ee   db e0   . .
        and 020h                ;80f0   e6 20   .
        jr z,l80f7h             ;80f2   28 03   ( .
        djnz step_inward        ;80f4   10 f3   . .
        ;; didn't find track0 ??
        ret                     ;80f6   c9      .
        ;; found track0...
        ;; try stepping outward 100 tracks
l80f7h:
        ld b,064h               ;80f7   06 64   . d
l80f9h:
        ;; step toward outer, side 0
        ld a,080h               ;80f9   3e 80   > .
        call step_track_arm     ;80fb   cd 8f 81        . . .
        in a,(rdst1)            ;80fe   db e0   . .
        and 020h                ;8100   e6 20   .
        jr nz,l8107h            ;8102   20 03     .
        djnz l80f9h             ;8104   10 f3   . .
        ;; didn't find track0...
        ret                     ;8106   c9      .
        ;; found track0...
l8107h:
        ld b,004h               ;8107   06 04   . .
separator_reset_loop:
        ;; power on initialization of floppy data separator
        ;; cf. sec 3.7.1 on 3-34.
        out (flpdskrd),a        ;8109   d3 82   . .
        ld a,07dh               ;810b   3e 7d   > }
        call delay              ;810d   cd 9e 81        . . .
        in a,(flpdskrd)         ;8110   db 82   . .
        ld a,07dh               ;8112   3e 7d   > }
        call delay              ;8114   cd 9e 81        . . .
        djnz separator_reset_loop ;8117   10 f0   . .
        exx                     ;8119   d9      .
        ld b,028h               ;811a   06 28   . (
        exx                     ;811c   d9      .
l811dh:
        ld hl,read_boot_sector  ;811d   21 4e 81        ! N .
        in a,(flpdskrd)         ;8120   db 82   . .
        exx                     ;8122   d9      .
        dec b                   ;8123   05      .
        exx                     ;8124   d9      .
        ret z                   ;8125   c8      .
        ld b,020h               ;8126   06 20   .
        ;; find sector loop
l8128h:
        dec bc                  ;8128   0b      .
        ld a,b                  ;8129   78      x
        or c                    ;812a   b1      .
        ret z                   ;812b   c8      .
        in a,(rdst1)            ;812c   db e0   . .
        and 040h                ;812e   e6 40   . @
        jr z,l8128h             ;8130   28 f6   ( .
        ld b,020h               ;8132   06 20   .
l8134h:
        dec bc                  ;8134   0b      .
        ld a,b                  ;8135   78      x
        or c                    ;8136   b1      .
        ret z                   ;8137   c8      .
        in a,(rdst1)            ;8138   db e0   . .
        and 040h                ;813a   e6 40   . @
        jr nz,l8134h            ;813c   20 f6     .
        ;; read sector number, looking for 3 (so there is time for 4)
        in a,(rdst2)            ;813e   db d0   . .
        and 00fh                ;8140   e6 0f   . .
        cp 003h                 ;8142   fe 03   . .
        jr nz,l8128h            ;8144   20 e2     .
        ld a,004h               ;8146   3e 04   > .
        ld e,000h               ;8148   1e 00   . .
        ld b,0ffh               ;814a   06 ff   . .
        jr find_next_sector               ;814c   18 59   . Y

        ;; return vector in HL
        ;; count of sectors in b?
read_boot_sector:
        ;; see 3-81
        ;; get first byte (load addr page)
        in a,(flpdata)          ;814e   db 80   . .
        ;; ensure it is 0c0h - 0f8h
        cp 0c0h                 ;8150   fe c0   . .
        ret c                   ;8152   d8      .
        cp 0f9h                 ;8153   fe f9   . .
        ret nc                  ;8155   d0      .
        ;; set DE to destination buffer addr
        ld d,a                  ;8156   57      W
        ;; write first byte
        ld (de),a               ;8157   12      .
        inc de                  ;8158   13      .
        ;; load c with crc
        rlca                    ;8159   07      .
        ld c,a                  ;815a   4f      O

        ld hl,bloop             ;815b   21 65 81        ! e .
        ;; get and store next byte
        in a,(flpdata)          ;815e   db 80   . .
        ld (de),a               ;8160   12      .
        inc de                  ;8161   13      .
        ;; update crc
        xor c                   ;8162   a9      .
        rlca                    ;8163   07      .
        ld c,a                  ;8164   4f      O
	;; get and store two bytes, updating crc
bloop:
        in a,(flpdata)          ;8165   db 80   . .
        ld (de),a               ;8167   12      .
        xor c                   ;8168   a9      .
        rlca                    ;8169   07      .
        ld c,a                  ;816a   4f      O
        inc de                  ;816b   13      .
        in a,(flpdata)          ;816c   db 80   . .
        ld (de),a               ;816e   12      .
        xor c                   ;816f   a9      .
        rlca                    ;8170   07      .
        ld c,a                  ;8171   4f      O
        inc de                  ;8172   13      .
        djnz bloop              ;8173   10 f0   . .
        ;; read crc byte
        in a,(flpdata)          ;8175   db 80   . .
        xor c                   ;8177   a9      .
	;; stop reading
        in a,(flpdskrd)         ;8178   db 82   . .
        jr nz,l811dh            ;817a   20 a1     .

        ex af,af'               ;817c   08      .
        dec a                   ;817d   3d      =
        jr nz,find_next_sector            ;817e   20 27     '
        ;; load HL with entry point??
        ld hl,0f80ah            ;8180   21 0a f8        ! . .
        ;; adjust with ??
        add hl,de               ;8183   19      .
        out (memmap0),a         ;8184   d3 a0   . .
        out (memmap1),a         ;8186   d3 a1   . .
        ;; verify it's a jump instruction
        ld a,(hl)               ;8188   7e      ~
        cp 0c3h                 ;8189   fe c3   . .
        ;; bail out if it isn't
        jp nz,setlowmaps        ;818b   c2 6b 80        . k .
        ;; jump into it if it is
        jp (hl)                 ;818e   e9      .

        ;; command in A; see table 3-16 on 3-33
        ;; 040h 0=side0, 1=side1
        ;; 020h 0=outward, 1=inward
        ;; drive select in C'?
step_track_arm:
        exx                     ;818f   d9      .
        or c                    ;8190   b1      .
        exx                     ;8191   d9      .
        out (flpctl),a          ;8192   d3 81   . .
        or 010h                 ;8194   f6 10   . .
        out (flpctl),a          ;8196   d3 81   . .
        xor 010h                ;8198   ee 10   . .
        out (flpctl),a          ;819a   d3 81   . .
        ld a,028h               ;819c   3e 28   > (

delay:
        ld c,0fah               ;819e   0e fa   . .
delayinner:
        dec c                   ;81a0   0d      .
        jr nz,delayinner        ;81a1   20 fd     .
        dec a                   ;81a3   3d      =
        jr nz,delay             ;81a4   20 f8     .
        ret                     ;81a6   c9      .

        ;; start read of next sector
find_next_sector:
        ex af,af'               ;81a7   08      .
        ;; wait sector mark
l81a8h:
        in a,(rdst1)            ;81a8   db e0   . .
        and 040h                ;81aa   e6 40   . @
        jr nz,l81a8h            ;81ac   20 fa     .
        ;; wait sector mark done
l81aeh:
        in a,(rdst1)            ;81ae   db e0   . .
        and 040h                ;81b0   e6 40   . @
        jr z,l81aeh             ;81b2   28 fa   ( .
        ;; wait a bit
        ld a,064h               ;81b4   3e 64   > d
wait64:
        dec a                   ;81b6   3d      =
        jr nz,wait64            ;81b7   20 fd     .
        ;; begin acquire, keep motors on
        ld a,015h               ;81b9   3e 15   > .
        out (ldioctl),a         ;81bb   d3 f8   . .
        ;; start sector read
        out (flpdskrd),a        ;81bd   d3 82   . .
        ;; wait a bit more
        ld a,018h               ;81bf   3e 18   > .
wait18:
        dec a                   ;81c1   3d      =
        jr nz,wait18            ;81c2   20 fd     .
        ;; end acquire, keep motors on
        ld a,01dh               ;81c4   3e 1d   > .
        out (ldioctl),a         ;81c6   d3 f8   . .

        ld a,b                  ;81c8   78      x

        ;; read from rdst1 waiting for sector preamble to end
        ld bc,064e0h            ;81c9   01 e0 64        . . d
l81cch:
        in f,(c)                ;81cc   ed 70
        jp m,l81d6h             ;81ce   fa d6 81        . . .
        djnz l81cch             ;81d1   10 f9   . .
        ;; no end to preamble after 100 steps...
        jp l811dh               ;81d3   c3 1d 81        . . .
        ;; end of preamble
l81d6h:
        ld b,a                  ;81d6   47      G
        ;; read sync byte
        in a,(flpctl)           ;81d7   db 81   . .
        cp 0fbh                 ;81d9   fe fb   . .
        jp nz,l811dh            ;81db   c2 1d 81        . . .
        ;; read second sync (sector id)
        in a,(flpdata)          ;81de   db 80   . .
        ld c,000h               ;81e0   0e 00   . .
        jp (hl)                 ;81e2   e9      .

tryserialboot:
        ; ask slot3 if it thinks its a serial card (id f0-f7)
        in a,(idslt3)           ;81e3   db 73   . s
        and 0f8h                ;81e5   e6 f8   . .
        cp 0f0h                 ;81e7   fe f0   . .
        ret nz                  ;81e9   c0      .
        ; check they hit return after the S
        call getchar            ;81ea   cd 25 83        . % .
        cp 00dh                 ;81ed   fe 0d   . .
        ret nz                  ;81ef   c0      .
        ld a,000h               ;81f0   3e 00   > .
        call serialinit         ;81f2   cd 74 82        . t .
        ;; hl set to sertable2
        ;; send 0c 10 16 b7 to 8251 ctl
        ;; SYN(sync1) DLE(sync2) mode(hunt reset-errors rts)
        ld b,004h               ;81f5   06 04   . .
        ;; save b, length of block
        ld d,b                  ;81f7   50      P
        otir                    ;81f8   ed b3   . .
        ;; dummy reads in case this was powerup
        in a,(siodata)          ;81fa   db 30   . 0
        in a,(siodata)          ;81fc   db 30   . 0
        ;; transmit b (00)
        call serial_write_char  ;81fe   cd 82 83        . . .
        ld c,b                  ;8201   48      H
        ;; bc now 0
serboot_outer_wait_loop:
        dec bc                  ;8202   0b      .
        ld a,b                  ;8203   78      x
        or c                    ;8204   b1      .
        jr nz,l820bh            ;8205   20 04     .
        ;; bc now zero again after delay
        ;; restore progress through sertable3 into a (see 8217)
        ld a,d                  ;8207   7a      z
        cp 003h                 ;8208   fe 03   . .
        ret nc                  ;820a   d0      .
l820bh:
        ;; wait for char
        in a,(sioctl)           ;820b   db 31   . 1
        and 002h                ;820d   e6 02   . .
        jr z,serboot_outer_wait_loop             ;820f   28 f1   ( .
        ;; read char
        in a,(siodata)          ;8211   db 30   . 0
        ;; try to match with message; HL points at sertable3
        cp (hl)                 ;8213   be      .
        jr nz,serboot_outer_wait_loop            ;8214   20 ec     .
        inc hl                  ;8216   23      #
        dec d                   ;8217   15      .
        jr nz,serboot_outer_wait_loop            ;8218   20 e8     .
        ld b,d                  ;821a   42      B
l821bh:
        djnz l821bh             ;821b   10 fe   . .
        dec d                   ;821d   15      .
        jr nz,l821bh            ;821e   20 fb     .
        ld c,006h               ;8220   0e 06   . .
l8222h:
        ld b,(hl)               ;8222   46      F
        call serial_write_char  ;8223   cd 82 83        . . .
        inc hl                  ;8226   23      #
        dec c                   ;8227   0d      .
        jr nz,l8222h            ;8228   20 f8     .
l822ah:
        ;; match STX
        call serial_read_char   ;822a   cd 6b 82        . k .
        cp 002h                 ;822d   fe 02   . .
        jr nz,l822ah            ;822f   20 f9     .
	;; read first byte of payload, should be page of start
        call serial_read_char   ;8231   cd 6b 82        . k .
        ;; set DE requested ram destination addr
        ld d,a                  ;8234   57      W
        ld e,000h               ;8235   1e 00   . .
        ld b,e                  ;8237   43      C
        ;; put entry point in IX
        ld ix,0000ah            ;8238   dd 21 0a 00     . ! . .
        add ix,de               ;823c   dd 19   . .
        ;; initialize checksum with 1
        ld hl,00001h            ;823e   21 01 00        ! . .
l8241h:
        ;; store byte
        ld (de),a               ;8241   12      .
        inc de                  ;8242   13      .
        ;; update checksum
        ld c,a                  ;8243   4f      O
        add hl,bc               ;8244   09      .
l8245h:
        ;; match SYN
        call serial_read_char   ;8245   cd 6b 82        . k .
        cp 010h                 ;8248   fe 10   . .
        jr nz,l8241h            ;824a   20 f5     .
        call serial_read_char   ;824c   cd 6b 82        . k .
        cp 016h                 ;824f   fe 16   . .
        jr z,l8245h             ;8251   28 f2   ( .
        cp 003h                 ;8253   fe 03   . .
        jr nz,l8241h            ;8255   20 ea     .
        call serial_read_char   ;8257   cd 6b 82        . k .
        cp l                    ;825a   bd      .
        ret nz                  ;825b   c0      .
        call serial_read_char   ;825c   cd 6b 82        . k .
        cp h                    ;825f   bc      .
        ret nz                  ;8260   c0      .
        call serial_read_char   ;8261   cd 6b 82        . k .
        ;; set bank 0 and 1 to point to ram 00000h
        xor a                   ;8264   af      .
        out (memmap0),a         ;8265   d3 a0   . .
        out (memmap1),a         ;8267   d3 a1   . .
        ;; jump into entry point
        jp (ix)                 ;8269   dd e9   . .

serial_read_char:
        ;; wait for char
        in a,(sioctl)           ;826b   db 31   . 1
        and 002h                ;826d   e6 02   . .
        jr z,serial_read_char   ;826f   28 fa   ( .
        ;; read char
        in a,(siodata)          ;8271   db 30   . 0
        ret                     ;8273   c9      .

serialinit:
        ;; send 80 80 40 to 8251 ctl to reset it
        ld hl,sertable          ;8274   21 4f 80        ! O .
        ld bc,00331h            ;8277   01 31 03        . 1 .
        otir                    ;827a   ed b3   . .
        ;; delay and set b := 0
delayb0:
        djnz delayb0            ;827c   10 fe   . .
        out (siobaud),a         ;827e   d3 38   . 8
        ret                     ;8280   c9      .
sub_8281h:
        ld a,(serialfound)      ;8281   3a fd 02        : . .
        or a                    ;8284   b7      .
        ret nz                  ;8285   c0      .
        jr l822ah               ;8286   18 a2   . .
minimon:
        ld b,'*'                ;8288   06 2a   . *
        call dispchar           ;828a   cd 6c 83        . l .
        call getchar            ;828d   cd 25 83        . % .
        cp 'D'                  ;8290   fe 44   . D
        jr z,minimoncmdd        ;8292   28 4f   ( O
        cp 'J'                  ;8294   fe 4a   . J
        jp z,minimoncmdj        ;8296   ca cb 83        . . .
        cp 'I'                  ;8299   fe 49   . I
        jr z,minimoncmdi        ;829b   28 7e   ( ~
        cp 'O'                  ;829d   fe 4f   . O
        jr z,minimoncmdo        ;829f   28 73   ( s
        cp 'Q'                  ;82a1   fe 51   . Q
        jp z,setlowmaps         ;82a3   ca 6b 80        . k .
        cp 'R'                  ;82a6   fe 52   . R
        call z,sub_8281h        ;82a8   cc 81 82        . . .
l82abh:
        ld sp,00200h            ;82ab   31 00 02        1 . .
        call sub_82b3h          ;82ae   cd b3 82        . . .
        jr minimon              ;82b1   18 d5   . .
sub_82b3h:
        ld a,(mvcursy)          ;82b3   3a f1 00        : . .
        cp 0e6h                 ;82b6   fe e6   . .
        ld b,01fh               ;82b8   06 1f   . .
        jp nz,dispchar          ;82ba   c2 6c 83        . l .
sub_82bdh:
        exx                     ;82bd   d9      .
        ; clear visible video memory
        xor a                   ;82be   af      .
        ld h,04fh               ;82bf   26 4f   & O
vidclearxloop:
        ld l,0f0h               ;82c1   2e f0   . .
vidclearyloop:
        dec l                   ;82c3   2d      -
        ld (hl),a               ;82c4   77      w
        jr nz,vidclearyloop     ;82c5   20 fc     .
        dec h                   ;82c7   25      %
        jr nz,vidclearxloop     ;82c8   20 f7     .

        ; wipe page 0 again, covering f0-ff?
l82cah:
        ld (hl),a               ;82ca   77      w
        dec l                   ;82cb   2d      -
        jr nz,l82cah            ;82cc   20 fc     .

        ; initialize video driver
        ld hl,fontdata          ;82ce   21 61 85        ! a .
        ld (mvpixel),hl         ;82d1   22 f2 00       \" . .
        ld hl,mvctemp           ;82d4   21 f0 02        ! . .
        ld (mvctptr),hl         ;82d7   22 f8 00       \" . .
        ld bc,00affh            ;82da   01 ff 0a        . . .
        ; fill mvctemp with ten 0ffh bytes
ctemploop:
        ld (hl),c               ;82dd   71      q
        inc l                   ;82de   2c      ,
        djnz ctemploop          ;82df   10 fc   . .
        exx                     ;82e1   d9      .
        ret                     ;82e2   c9      .
minimoncmdd:
        call gethexword         ;82e3   cd 91 83        . . .
        ld (mmdaddr),bc         ;82e6   ed 43 fe 02     . C . .
dumploop:
        ld hl,(mmdaddr)         ;82ea   2a fe 02        * . .
        ld b,(hl)               ;82ed   46      F
        inc hl                  ;82ee   23      #
        ld (mmdaddr),hl         ;82ef   22 fe 02       \" . .
        call sub_83d3h          ;82f2   cd d3 83        . . .
        ld b,'-'                ;82f5   06 2d   . -
        call dispchar           ;82f7   cd 6c 83        . l .
        call getchar            ;82fa   cd 25 83        . % .
        cp ' '                  ;82fd   fe 20   .
        jr nz,l8306h            ;82ff   20 05     .
        call dispchar           ;8301   cd 6c 83        . l .
        jr dumploop             ;8304   18 e4   . .
l8306h:
        ; return to minimon if they hit return
        cp 00dh                 ;8306   fe 0d   . .
        jr z,l82abh             ;8308   28 a1   ( .
        ; already got one nybble, now get the next
        call gethexnybble       ;830a   cd 9f 83        . . .
        ld hl,(mmdaddr)         ;830d   2a fe 02        * . .
        dec hl                  ;8310   2b      +
        ld (hl),c               ;8311   71      q
        jr dumploop             ;8312   18 d6   . .
minimoncmdo:
        call gethexword         ;8314   cd 91 83        . . .
        out (c),b               ;8317   ed 41   . A
        jr l82abh               ;8319   18 90   . .
minimoncmdi:
        call gethexbyte         ;831b   cd 9c 83        . . .
        in b,(c)                ;831e   ed 40   . @
        call sub_83d3h          ;8320   cd d3 83        . . .
        jr l82abh               ;8323   18 86   . .

        ;; get a character from keyboard or serial port 3
getchar:
        ld a,(serialfound)      ;8325   3a fd 02        : . .
        or a                    ;8328   b7      .
        jr z,l838ch             ;8329   28 61   ( a
l832bh:
        in a,(rdst2)            ;832b   db d0   . .
        bit 6,a                 ;832d   cb 77   . w
        jr z,l832bh             ;832f   28 fa   ( .
        ld b,a                  ;8331   47      G
        ld a,019h               ;8332   3e 19   > .
        out (ldioctl),a         ;8334   d3 f8   . .
l8336h:
        in a,(rdst2)            ;8336   db d0   . .
        xor b                   ;8338   a8      .
        jp p,l8336h             ;8339   f2 36 83        . 6 .
        in a,(rdst2)            ;833c   db d0   . .
        and 00fh                ;833e   e6 0f   . .
        ld c,a                  ;8340   4f      O
        ld a,01ah               ;8341   3e 1a   > .
        out (ldioctl),a         ;8343   d3 f8   . .
l8345h:
        in a,(rdst2)            ;8345   db d0   . .
        xor b                   ;8347   a8      .
        jp m,l8345h             ;8348   fa 45 83        . E .
        in a,(rdst2)            ;834b   db d0   . .
        add a,a                 ;834d   87      .
        add a,a                 ;834e   87      .
        add a,a                 ;834f   87      .
        add a,a                 ;8350   87      .
        add a,c                 ;8351   81      .
        ld bc,018f8h            ;8352   01 f8 18        . . .
        out (c),b               ;8355   ed 41   . A
l8357h:
        dec c                   ;8357   0d      .
        jr nz,l8357h            ;8358   20 fd     .
        djnz l8357h             ;835a   10 fb   . .
        cp 0ffh                 ;835c   fe ff   . .
        jr z,l8363h             ;835e   28 03   ( .
        ld (lastkey),a          ;8360   32 ff 03        2 . .
l8363h:
        ld a,(lastkey)          ;8363   3a ff 03        : . .
l8366h:
        ld b,a                  ;8366   47      G
        cp 003h                 ;8367   fe 03   . .
        jp z,l82abh             ;8369   ca ab 82        . . .
dispchar:
        ld a,b                  ;836c   78      x
        exx                     ;836d   d9      .
        ld ix,000f0h            ;836e   dd 21 f0 00     . ! . .
        ld hl,videoreturn       ;8372   21 7b 83        ! { .
        ld (mvretfp),hl         ;8375   22 f6 00       \" . .
        jp startvideo           ;8378   c3 83 84        . . .
videoreturn:
        exx                     ;837b   d9      .
        ld a,(serialfound)      ;837c   3a fd 02        : . .
        or a                    ;837f   b7      .
        ld a,b                  ;8380   78      x
        ret nz                  ;8381   c0      .

serial_write_char:
        ;; wait for TxRDY
        in a,(sioctl)           ;8382   db 31   . 1
        and 001h                ;8384   e6 01   . .
        jr z,serial_write_char  ;8386   28 fa   ( .
        ;; transmit b
        ld a,b                  ;8388   78      x
        out (siodata),a         ;8389   d3 30   . 0
        ret                     ;838b   c9      .

l838ch:
        call serial_read_char   ;838c   cd 6b 82        . k .
        jr l8366h               ;838f   18 d5   . .

gethexword:
        call getchar            ;8391   cd 25 83        . % .
        ld l,a                  ;8394   6f      o
        call getchar            ;8395   cd 25 83        . % .
        ld h,a                  ;8398   67      g
        ld (gthxhi),hl          ;8399   22 fc 00       \" . .
gethexbyte:
        call getchar            ;839c   cd 25 83        . % .
gethexnybble:
        ld l,a                  ;839f   6f      o
        call getchar            ;83a0   cd 25 83        . % .
        ld h,a                  ;83a3   67      g
        ld (gthxlo),hl          ;83a4   22 fe 00       \" . .

        ; convert 4 digits ascii->num
        ld hl,gthxhi            ;83a7   21 fc 00        ! . .
        ld b,004h               ;83aa   06 04   . .
l83ach:
        ld a,(hl)               ;83ac   7e      ~
        sub '0'                 ;83ad   d6 30   . 0
        ; subtract 7 if a-f
        cp 00ah                 ;83af   fe 0a   . .
        jr c,notaf              ;83b1   38 02   8 .
        sub 007h                ;83b3   d6 07   . .
notaf:
        bit 0,b                 ;83b5   cb 40   . @
        jr nz,l83c0h            ;83b7   20 07     .
        add a,a                 ;83b9   87      .
        add a,a                 ;83ba   87      .
        add a,a                 ;83bb   87      .
        add a,a                 ;83bc   87      .
        ld c,a                  ;83bd   4f      O
        jr l83c2h               ;83be   18 02   . .
l83c0h:
        add a,c                 ;83c0   81      .
        ld (hl),a               ;83c1   77      w
l83c2h:
        inc hl                  ;83c2   23      #
        djnz l83ach             ;83c3   10 e7   . .
        dec hl                  ;83c5   2b      +
        ld c,(hl)               ;83c6   4e      N
        dec hl                  ;83c7   2b      +
        dec hl                  ;83c8   2b      +
        ld b,(hl)               ;83c9   46      F
        ret                     ;83ca   c9      .
minimoncmdj:
        call gethexword         ;83cb   cd 91 83        . . .
        ld hl,l82abh            ;83ce   21 ab 82        ! . .
        push bc                 ;83d1   c5      .
        ret                     ;83d2   c9      .
sub_83d3h:
        ld a,(mvcursx)          ;83d3   3a f0 00        : . .
        cp 04bh                 ;83d6   fe 4b   . K
        ld c,b                  ;83d8   48      H
        jr c,l83f3h             ;83d9   38 18   8 .
        call sub_82b3h          ;83db   cd b3 82        . . .
        inc b                   ;83de   04      .
        call dispchar           ;83df   cd 6c 83        . l .
        call dispchar           ;83e2   cd 6c 83        . l .
        ld hl,(mmdaddr)         ;83e5   2a fe 02        * . .
        dec hl                  ;83e8   2b      +
        ld e,c                  ;83e9   59      Y
        ld c,h                  ;83ea   4c      L
        call sub_83f8h          ;83eb   cd f8 83        . . .
        ld c,l                  ;83ee   4d      M
        call sub_83f8h          ;83ef   cd f8 83        . . .
        ld c,e                  ;83f2   4b      K
l83f3h:
        ld b,020h               ;83f3   06 20   .
        call dispchar           ;83f5   cd 6c 83        . l .
sub_83f8h:
        ld d,002h               ;83f8   16 02   . .
        ld a,c                  ;83fa   79      y
        and 0f0h                ;83fb   e6 f0   . .
        rrca                    ;83fd   0f      .
        rrca                    ;83fe   0f      .
        rrca                    ;83ff   0f      .
        rrca                    ;8400   0f      .
l8401h:
        add a,030h              ;8401   c6 30   . 0
        cp 03ah                 ;8403   fe 3a   . :
        jr c,l8409h             ;8405   38 02   8 .
        add a,007h              ;8407   c6 07   . .
l8409h:
        ld b,a                  ;8409   47      G
        call dispchar           ;840a   cd 6c 83        . l .
        ld a,c                  ;840d   79      y
        and 00fh                ;840e   e6 0f   . .
        dec d                   ;8410   15      .
        jr nz,l8401h            ;8411   20 ee     .
        ret                     ;8413   c9      .

        ; load address of character in a from active font table
drawprintable:
        sub ' '                 ;8414   d6 20   .
        ld c,a                  ;8416   4f      O
        xor a                   ;8417   af      .
        ld b,a                  ;8418   47      G
        ld h,(ix+003h)          ;8419   dd 66 03        . f .
        ld l,(ix+002h)          ;841c   dd 6e 02        . n .
        ; hl <- hl + bc*7
        add hl,bc               ;841f   09      .
        add hl,bc               ;8420   09      .
        add hl,bc               ;8421   09      .
        add hl,bc               ;8422   09      .
        add hl,bc               ;8423   09      .
        add hl,bc               ;8424   09      .
        add hl,bc               ;8425   09      .
        ld d,(ix+000h)          ;8426   dd 56 00        . V .
        ld e,(ix+001h)          ;8429   dd 5e 01        . ^ .
        ld a,(ix+00ah)          ;842c   dd 7e 0a        . ~ .
        ld (de),a               ;842f   12      .
        inc e                   ;8430   1c      .
        ld bc,00702h            ;8431   01 02 07        . . .

        ; test for descender flag 1
        bit 7,(hl)              ;8434   cb 7e   . ~
        jr z,descenderloop      ;8436   28 0a   ( .
        ld (de),a               ;8438   12      .
        inc e                   ;8439   1c      .
        dec c                   ;843a   0d      .

        ; test for descender flag 2
        bit 6,(hl)              ;843b   cb 76   . v
        jr z,descenderloop      ;843d   28 03   ( .
        ld (de),a               ;843f   12      .
        inc e                   ;8440   1c      .
        dec c                   ;8441   0d      .

descenderloop:
        ; read first row of character
        ld a,(hl)               ;8442   7e      ~
        ; mask off descenders
        and 03fh                ;8443   e6 3f   . ?
        ; invert if requested
        xor (ix+00ah)           ;8445   dd ae 0a        . . .
        ; send to video mem
        ld (de),a               ;8448   12      .
        inc hl                  ;8449   23      #
        inc e                   ;844a   1c      .
        djnz descenderloop      ;844b   10 f5   . .
        ld a,(ix+00ah)          ;844d   dd 7e 0a        . ~ .
        ; do the rest of the rows (no mask)
l8450h:
        dec c                   ;8450   0d      .
        jp m,l8458h             ;8451   fa 58 84        . X .
        ld (de),a               ;8454   12      .
        inc e                   ;8455   1c      .
        jr l8450h               ;8456   18 f8   . .
l8458h:
        ld c,00ch               ;8458   0e 0c   . .
        jr nonprintable         ;845a   18 35   . 5
docleareos:
        ld a,l                  ;845c   7d      }
        sub e                   ;845d   93      .
        sub 010h                ;845e   d6 10   . .
        jr z,docleareol         ;8460   28 0e   ( .
        ld c,a                  ;8462   4f      O
        ld h,04fh               ;8463   26 4f   & O
l8465h:
        ld b,c                  ;8465   41      A
        xor a                   ;8466   af      .
        ld l,e                  ;8467   6b      k
l8468h:
        ld (hl),a               ;8468   77      w
        inc l                   ;8469   2c      ,
        djnz l8468h             ;846a   10 fc   . .
        dec h                   ;846c   25      %
        jp p,l8465h             ;846d   f2 65 84        . e .
docleareol:
        ex de,hl                ;8470   eb      .
        dec l                   ;8471   2d      -
        ld e,l                  ;8472   5d      ]
l8473h:
        ld b,00ah               ;8473   06 0a   . .
        xor a                   ;8475   af      .
        ld l,e                  ;8476   6b      k
l8477h:
        ld (hl),a               ;8477   77      w
        dec l                   ;8478   2d      -
        djnz l8477h             ;8479   10 fc   . .
        inc h                   ;847b   24      $
        ld a,h                  ;847c   7c      |
        cp 050h                 ;847d   fe 50   . P
        jr nz,l8473h            ;847f   20 f2     .
        jr botnoscroll          ;8481   18 73   . s

startvideo:
        and 07fh                ;8483   e6 7f   . 
        cp 07fh                 ;8485   fe 7f   . 
        jp z,exitvideo          ;8487   ca 1d 85        . . .
        cp 020h                 ;848a   fe 20   .
        jr nc,drawprintable     ;848c   30 86   0 .
        ld c,a                  ;848e   4f      O
        jr l84f8h               ;848f   18 67   . g

nonprintable:
        ld a,c                  ;8491   79      y
        ; load h with status, l with (scanline) scrollcount
        ld h,(ix+005h)          ;8492   dd 66 05        . f .
        ld l,(ix+004h)          ;8495   dd 6e 04        . n .
        cp 00dh                 ;8498   fe 0d   . .
        jr z,docr               ;849a   28 2b   ( +
        cp 00ah                 ;849c   fe 0a   . .
        jr z,dolf               ;849e   28 43   ( C
        cp 00ch                 ;84a0   fe 0c   . .
        jr z,doforward          ;84a2   28 2f   ( /
        cp 01fh                 ;84a4   fe 1f   . .
        jr z,donewline          ;84a6   28 35   ( 5
        cp 00eh                 ;84a8   fe 0e   . .
        jr z,docleareol         ;84aa   28 c4   ( .
        cp 00fh                 ;84ac   fe 0f   . .
        jr z,docleareos         ;84ae   28 ac   ( .
        cp 018h                 ;84b0   fe 18   . .
        jr z,docursoron         ;84b2   28 17   ( .
        cp 019h                 ;84b4   fe 19   . .
        jr z,docursoroff        ;84b6   28 17   ( .
        cp 008h                 ;84b8   fe 08   . .
        jr z,dobackspace        ;84ba   28 68   ( h
        cp 00bh                 ;84bc   fe 0b   . .
        jr z,dolineup           ;84be   28 71   ( q
        cp 01eh                 ;84c0   fe 1e   . .
        jr nz,botnoscroll       ;84c2   20 32     2
        ld (ix+001h),l          ;84c4   dd 75 01        . u .
docr:
        xor a                   ;84c7   af      .
charadv:
        inc c                   ;84c8   0c      .
        jr recordx              ;84c9   18 13   . .
docursoron:
        res 0,h                 ;84cb   cb 84   . .
        jr updatestats          ;84cd   18 24   . $
docursoroff:
        set 0,h                 ;84cf   cb c4   . .
        jr updatestats          ;84d1   18 20   .
doforward:
        ld a,d                  ;84d3   7a      z
        inc a                   ;84d4   3c      <
        cp 050h                 ;84d5   fe 50   . P
        jr nz,recordx           ;84d7   20 05     .
        bit 1,h                 ;84d9   cb 4c   . L
        jr nz,botnoscroll       ;84db   20 19     .
donewline:
        xor a                   ;84dd   af      .
recordx:
        ld (ix+000h),a          ;84de   dd 77 00        . w .
        jr nz,botnoscroll       ;84e1   20 13     .
dolf:
        ld (ix+001h),e          ;84e3   dd 73 01        . s .
        set 7,h                 ;84e6   cb fc   . .
        ld a,l                  ;84e8   7d      }
        ; add 10 to scrollcount for another line...
        add a,00ah              ;84e9   c6 0a   . .
        ld c,a                  ;84eb   4f      O
        add a,0e6h              ;84ec   c6 e6   . .
        sub e                   ;84ee   93      .
        jr nz,botnoscroll       ;84ef   20 05     .
        jr l8541h               ;84f1   18 4e   . N
updatestats:
        ld (ix+005h),h          ;84f3   dd 74 05        . t .
botnoscroll:
        set 7,c                 ;84f6   cb f9   . .
l84f8h:
        ld d,(ix+000h)          ;84f8   dd 56 00        . V .
        ld e,(ix+001h)          ;84fb   dd 5e 01        . ^ .
        ld b,00ah               ;84fe   06 0a   . .
        bit 0,(ix+005h)         ;8500   dd cb 05 46     . . . F
        jr z,drawcursor         ;8504   28 05   ( .
        ld a,e                  ;8506   7b      {
        add a,b                 ;8507   80      .
        ld e,a                  ;8508   5f      _
        jr l8518h               ;8509   18 0d   . .
drawcursor:
        ld h,(ix+009h)          ;850b   dd 66 09        . f .
        ld l,(ix+008h)          ;850e   dd 6e 08        . n .
cursorloop:
        ld a,(de)               ;8511   1a      .
        xor (hl)                ;8512   ae      .
        ld (de),a               ;8513   12      .
        inc hl                  ;8514   23      #
        inc e                   ;8515   1c      .
        djnz cursorloop         ;8516   10 f9   . .
l8518h:
        bit 7,c                 ;8518   cb 79   . y
        jp z,nonprintable       ;851a   ca 91 84        . . .

exitvideo:
        ld l,(ix+006h)          ;851d   dd 6e 06        . n .
        ld h,(ix+007h)          ;8520   dd 66 07        . f .
        jp (hl)                 ;8523   e9      .

dobackspace:
        ld a,d                  ;8524   7a      z
        dec a                   ;8525   3d      =
        ; If column is negative, advance to fix
        jp p,charadv            ;8526   f2 c8 84        . . .
        ; check for wraparound disable
        bit 1,h                 ;8529   cb 4c   . L
        jr nz,botnoscroll       ;852b   20 c9     .
        ld (ix+000h),04fh       ;852d   dd 36 00 4f     . 6 . O
dolineup:
        ld a,e                  ;8531   7b      {
        sub 014h                ;8532   d6 14   . .
        ld (ix+001h),a          ;8534   dd 77 01        . w .
        ld e,a                  ;8537   5f      _
        ld a,l                  ;8538   7d      }
        sub 00ah                ;8539   d6 0a   . .
        cp e                    ;853b   bb      .
        jr nz,botnoscroll       ;853c   20 b8     .
        set 6,h                 ;853e   cb f4   . .
        ld c,e                  ;8540   4b      K
l8541h:
        ld d,050h               ;8541   16 50   . P
        ld l,e                  ;8543   6b      k
l8544h:
        ld b,00ah               ;8544   06 0a   . .
        dec d                   ;8546   15      .
        xor a                   ;8547   af      .
l8548h:
        ld (de),a               ;8548   12      .
        inc e                   ;8549   1c      .
        djnz l8548h             ;854a   10 fc   . .
        ld e,l                  ;854c   5d      ]
        or d                    ;854d   b2      .
        jr nz,l8544h            ;854e   20 f4     .
        ld (ix+004h),c          ;8550   dd 71 04        . q .
        bit 2,h                 ;8553   cb 54   . T
        jr nz,updatestats       ;8555   20 9c     .
        ld a,c                  ;8557   79      y
        out (ldstsc),a          ;8558   d3 90   . .
        jr botnoscroll          ;855a   18 9a   . .

        ; gap so font fits at 08561h
        ds 5,0
fontdata:
include "Advantage Boot Font.asm"

        jp botnoscroll          ;87fa   c3 f6 84        . . .
        jp startvideo           ;87fd   c3 83 84        . . .
