;;; CRC-16-CCITT
;;; for z80


poly:   equ     01021h

        ;; buffer in HL
        ;; size in BC
        ;; output sum in DE
crc16:
        push    af
        xor     a
        ld      d,a             ; DE := 0
        ld      e,a
.c16byte:
        ld      a,b             ; cmp bc
        or      c
        jr      z,.c16out
        dec     bc
        ld      a,(hl)
        inc     hl
        xor     d               ; clears carry
        ld      d,a
        push    bc
        ld      b,8
.c16bit:
        rl      e
        rl      d
        jr      nc,.c16skip
        ld      a,e
        xor     poly & 0ffh
        ld      e,a
        ld      a,d
        xor     poly >> 8       ; clears carry
        ld      d,a
.c16skip:
        djnz    .c16bit
        pop     bc
        jr      .c16byte
.c16out:
        pop     af
        ret
