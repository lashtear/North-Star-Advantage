        ;; constants in the rom
romcout:equ     087fdh          ; draw-character routine
romfont:equ     08561h          ; built-in compressed 8x10 font

        ;; bootloader always jumps to loadaddr+10
bsent:  equ     0c00ah

        org     0c000h          ; start at 0c000h
        db      0c0h            ; tell bootloader to load at 0c000h
        ds      bsent-$         ; skip to the 0c00ah entry point
        jp      main            ; bootloader requires JP insn
main:
        ld      sp,0fffeh       ; initialize stack at top of ram
        push    hl              ; save boot monitor re-entry address
        ld      ix,vidblock     ; load address of our video terminal state
        ld      hl,msg          ; load hello message
        call    putstr          ; print it
        ret                     ; return to monitor

        ;; char in A, clobbers BC DE HL F
        ;; requires IX already set to vidblock
vidcall:
        jp      romcout
viddest:
        ret

        ;; stringz addr in HL
        ;; HL just past the zero byte afterward
        ;; assumes IX is already set to vidblock
putstr:
        push    bc
        push    de
        push    af
        push    iy
psloop: ld      a,(hl)
        cp      000h
        jr      z,putstrout
        push    hl
        call    vidcall
        pop     hl
        inc     hl
        jr      psloop
putstrout:
        inc     hl
        pop     iy
        pop     af
        pop     de
        pop     bc
        ret

;;; all code above, all data below

msg:
        dm      "Hello, world!"
        db      0

;;; all rommable data/code above, writable data below

vidblock:
vx:     db      0               ; byte column
vy:     db      0               ; scan row
vfont:  dw      romfont         ; font addr
vscrl:  db      0               ; vertical scroll offset
vstat:  db      0               ; video status
vret:   dw      viddest         ; return address
vctemp: dw      vcursor         ; address of cursor bitmap
vinv:   db      0               ; invert video flag
vcursor:
        ds      00ah, 0ffh      ; cursor bitmap buffer

;;; relative offsets for indirect addressing of vidblock to move
;;; cursor, etc
rx:     equ     0               ; offset equ for e.g. ld (iy+rx),..., etc
ry:     equ     1               ; same for scan row

;;; uninitialized data if we had any

;;; ...

;;; assembles to

;000000 c0 00 00 00 00 00 00 00 00 00 c3 0d c0 31 fe ff  >.............1..<
;000010 e5 dd 21 47 c0 21 39 c0 cd 20 c0 c9 c3 fd 87 c9  >..!G.!9.. ......<
;000020 c5 d5 f5 fd e5 7e fe 00 28 08 e5 cd 1c c0 e1 23  >.....~..(......#<
;000030 18 f3 23 fd e1 f1 d1 c1 c9 48 65 6c 6c 6f 2c 20  >..#......Hello, <
;000040 77 6f 72 6c 64 21 00 00 00 61 85 00 00 1f c0 52  >world!...a.....R<
;000050 c0 00 ff ff ff ff ff ff ff ff ff ff              >............<
;00005c

;;; suitable for writing onto track0, sector4 of a hardsectored 5 1/4" floppy
;;; to boot.
