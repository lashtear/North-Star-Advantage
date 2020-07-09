resetvec:
        sel  rb0            ; 0000 c5 '.'
        dis  tcnti          ; 0001 35 '5'
        clr  a              ; 0002 27 '''
intvec:
        mov  r0, #03fh      ; 0003 b8 '.' 3f '?'
        jmp  l0009h         ; 0005 04 '.' 09 '.'
timervec:
        jmp  l023dh         ; 0007 44 'D' 3d '='
l0009h:
        mov  @r0, a         ; 0009 a0 '.'
        djnz r0, l0009h     ; 000a e8 '.' 09 '.'
        sel  rb1            ; 000c d5 '.'
        mov  r0, #030h      ; 000d b8 '.' 30 '0'
        mov  r5, #00eh      ; 000f bd '.' 0e '.'
        mov  a, r5          ; 0011 fd '.'
        movx @r0, a         ; 0012 90 '.'
        sel  rb0            ; 0013 c5 '.'
        mov  r0, #021h      ; 0014 b8 '.' 21 '!'
        mov  a, #0feh       ; 0016 23 '#' fe '.'
        outl p2, a          ; 0018 3a ':'
        mov  a, #05eh       ; 0019 23 '#' 5e '^'
        call l00e5h         ; 001b 14 '.' e5 '.'
        mov  a, #0f8h       ; 001d 23 '#' f8 '.'
        mov  t, a           ; 001f 62 'b'
        jtf  l0022h         ; 0020 16 '.' 22 '"'
l0022h:
        strt t              ; 0022 55 'U'
l0023h:
        dec  r0             ; 0023 c8 '.'
        mov  a, r0          ; 0024 f8 '.'
        xrl  a, #01fh       ; 0025 d3 '.' 1f '.'
        jnz  l002bh         ; 0027 96 '.' 2b '+'
        call l0130h         ; 0029 34 '4' 30 '0'
l002bh:
        call l00ddh         ; 002b 14 '.' dd '.'
        jz   l0023h         ; 002d c6 '.' 23 '#'
        mov  r3, a          ; 002f ab '.'
        mov  a, #00fh       ; 0030 23 '#' 0f '.'
        call l00e5h         ; 0032 14 '.' e5 '.'
        mov  r2, #032h      ; 0034 ba '.' 32 '2'
l0036h:
        djnz r2, l0036h     ; 0036 ea '.' 36 '6'
        call l00ddh         ; 0038 14 '.' dd '.'
        mov  r2, a          ; 003a aa '.'
        mov  a, #00eh       ; 003b 23 '#' 0e '.'
        call l00e5h         ; 003d 14 '.' e5 '.'
        mov  a, r2          ; 003f fa '.'
        anl  a, r3          ; 0040 5b '['
        jz   l0023h         ; 0041 c6 '.' 23 '#'
        mov  r3, a          ; 0043 ab '.'
        mov  r2, #008h      ; 0044 ba '.' 08 '.'
l0046h:
        mov  a, r3          ; 0046 fb '.'
        rr   a              ; 0047 77 'w'
        xch  a, @r0         ; 0048 20 ' '
        rr   a              ; 0049 77 'w'
        xch  a, @r0         ; 004a 20 ' '
l004bh:
        mov  r3, a          ; 004b ab '.'
        jb7  l0052h         ; 004c f2 '.' 52 'R'
l004eh:
        djnz r2, l0046h     ; 004e ea '.' 46 'F'
        jmp  l0023h         ; 0050 04 '.' 23 '#'
l0052h:
        mov  a, @r0         ; 0052 f0 '.'
        jb7  l00c3h         ; 0053 f2 '.' c3 '.'
        call l00efh         ; 0055 14 '.' ef '.'
        mov  r1, a          ; 0057 a9 '.'
        mov  a, r7          ; 0058 ff '.'
        dis  tcnti          ; 0059 35 '5'
        call l00ffh         ; 005a 14 '.' ff '.'
        sel  rb0            ; 005c c5 '.'
        call l02f2h         ; 005d 54 'T' f2 '.'
        mov  a, r0          ; 005f f8 '.'
        xrl  a, #020h       ; 0060 d3 '.' 20 ' '
        jz   l008fh         ; 0062 c6 '.' 8f '.'
        mov  a, r7          ; 0064 ff '.'
        mov  r4, a          ; 0065 ac '.'
        sel  rb1            ; 0066 d5 '.'
        mov  r3, #05ch      ; 0067 bb '.' 5c '\'
        sel  rb0            ; 0069 c5 '.'
        mov  a, r1          ; 006a f9 '.'
        jz   l008fh         ; 006b c6 '.' 8f '.'
        add  a, #0c8h       ; 006d 03 '.' c8 '.'
        jc   l0095h         ; 006f f6 '.' 95 '.'
        add  a, #00fh       ; 0071 03 '.' 0f '.'
        jc   l00a5h         ; 0073 f6 '.' a5 '.'
        add  a, #00ah       ; 0075 03 '.' 0a '.'
        jc   l00abh         ; 0077 f6 '.' ab '.'
        add  a, #009h       ; 0079 03 '.' 09 '.'
        jc   l00afh         ; 007b f6 '.' af '.'
        add  a, #015h       ; 007d 03 '.' 15 '.'
        rl   a              ; 007f e7 '.'
        rl   a              ; 0080 e7 '.'
        mov  r7, a          ; 0081 af '.'
        mov  a, r5          ; 0082 fd '.'
        mov  r1, #004h      ; 0083 b9 '.' 04 '.'
        call l022fh         ; 0085 54 'T' 2f '/'
        add  a, r7          ; 0087 6f 'o'
        add  a, #099h       ; 0088 03 '.' 99 '.'
l008ah:
        movp3a, @a          ; 008a e3 '.'
l008bh:
        call l015ah         ; 008b 34 '4' 5a 'Z'
        call l02f2h         ; 008d 54 'T' f2 '.'
l008fh:
        mov  a, @r0         ; 008f f0 '.'
        xrl  a, #080h       ; 0090 d3 '.' 80 '.'
        mov  @r0, a         ; 0092 a0 '.'
        jmp  l004eh         ; 0093 04 '.' 4e 'N'
l0095h:
        call l0229h         ; 0095 54 'T' 29 ')'
        jb2  l009fh         ; 0097 52 'R' 9f '.'
        jb0  l009fh         ; 0099 12 '.' 9f '.'
        mov  a, r5          ; 009b fd '.'
        anl  a, #001h       ; 009c 53 'S' 01 '.'
        add  a, r1          ; 009e 69 'i'
l009fh:
        add  a, #058h       ; 009f 03 '.' 58 'X'
l00a1h:
        movp3a, @a          ; 00a1 e3 '.'
        add  a, r7          ; 00a2 6f 'o'
        jmp  l008bh         ; 00a3 04 '.' 8b '.'
l00a5h:
        call l0229h         ; 00a5 54 'T' 29 ')'
        add  a, #05dh       ; 00a7 03 '.' 5d ']'
        jmp  l00a1h         ; 00a9 04 '.' a1 '.'
l00abh:
        add  a, #062h       ; 00ab 03 '.' 62 'b'
        jmp  l008ah         ; 00ad 04 '.' 8a '.'
l00afh:
        mov  r7, a          ; 00af af '.'
        rl   a              ; 00b0 e7 '.'
        rl   a              ; 00b1 e7 '.'
        add  a, r7          ; 00b2 6f 'o'
        call l0229h         ; 00b3 54 'T' 29 ')'
        jb2  l00beh         ; 00b5 52 'R' be '.'
        jb0  l00beh         ; 00b7 12 '.' be '.'
        add  a, r7          ; 00b9 6f 'o'
        mov  r7, a          ; 00ba af '.'
        mov  a, r6          ; 00bb fe '.'
        anl  a, #001h       ; 00bc 53 'S' 01 '.'
l00beh:
        add  a, r7          ; 00be 6f 'o'
        add  a, #06ch       ; 00bf 03 '.' 6c 'l'
        jmp  l008ah         ; 00c1 04 '.' 8a '.'
l00c3h:
        call l00efh         ; 00c3 14 '.' ef '.'
        mov  r1, #030h      ; 00c5 b9 '.' 30 '0'
l00c7h:
        mov  a, r7          ; 00c7 ff '.'
        xrl  a, @r1         ; 00c8 d1 '.'
        jz   l004eh         ; 00c9 c6 '.' 4e 'N'
        inc  r1             ; 00cb 19 '.'
        mov  a, r1          ; 00cc f9 '.'
        cpl  a              ; 00cd 37 '7'
        jb3  l00c7h         ; 00ce 72 'r' c7 '.'
        mov  a, r4          ; 00d0 fc '.'
        xrl  a, r7          ; 00d1 df '.'
        jnz  l008fh         ; 00d2 96 '.' 8f '.'
        sel  rb1            ; 00d4 d5 '.'
        mov  r3, a          ; 00d5 ab '.'
        mov  a, r5          ; 00d6 fd '.'
        anl  a, #0efh       ; 00d7 53 'S' ef '.'
        mov  r5, a          ; 00d9 ad '.'
        sel  rb0            ; 00da c5 '.'
        jmp  l008fh         ; 00db 04 '.' 8f '.'
l00ddh:
        mov  a, r0          ; 00dd f8 '.'
        anl  a, #00fh       ; 00de 53 'S' 0f '.'
        call l00e5h         ; 00e0 14 '.' e5 '.'
        xrl  a, @r0         ; 00e2 d0 '.'
        cpl  a              ; 00e3 37 '7'
        ret                 ; 00e4 83 '.'
l00e5h:
        outl p1, a          ; 00e5 39 '9'
        anl  p2, #07fh      ; 00e6 9a '.' 7f '.'
        orl  p1, #0ffh      ; 00e8 89 '.' ff '.'
        nop                 ; 00ea 00 '.'
        in   a, p1          ; 00eb 09 '.'
        orl  p2, #080h      ; 00ec 8a '.' 80 '.'
        ret                 ; 00ee 83 '.'
l00efh:
        mov  a, r0          ; 00ef f8 '.'
        dec  a              ; 00f0 07 '.'
        swap a              ; 00f1 47 'G'
        rr   a              ; 00f2 77 'w'
        anl  a, #078h       ; 00f3 53 'S' 78 'x'
        mov  r7, a          ; 00f5 af '.'
        mov  a, r2          ; 00f6 fa '.'
        cpl  a              ; 00f7 37 '7'
        inc  a              ; 00f8 17 '.'
        anl  a, #007h       ; 00f9 53 'S' 07 '.'
        orl  a, r7          ; 00fb 4f 'O'
        mov  r7, a          ; 00fc af '.'
        movp3a, @a          ; 00fd e3 '.'
        ret                 ; 00fe 83 '.'
l00ffh:
        sel  rb1            ; 00ff d5 '.'
        mov  @r0, a         ; 0100 a0 '.'
        inc  r0             ; 0101 18 '.'
        mov  a, r0          ; 0102 f8 '.'
        jb3  l0106h         ; 0103 72 'r' 06 '.'
        ret                 ; 0105 83 '.'
l0106h:
        mov  r0, #030h      ; 0106 b8 '.' 30 '0'
        ret                 ; 0108 83 '.'
l0109h:
        sel  rb1            ; 0109 d5 '.'
        mov  a, r6          ; 010a fe '.'
        mov  r1, a          ; 010b a9 '.'
        xrl  a, r7          ; 010c df '.'
        jnz  l0112h         ; 010d 96 '.' 12 '.'
        mov  r7, a          ; 010f af '.'
        jmp  l0119h         ; 0110 24 '$' 19 '.'
l0112h:
        mov  a, r7          ; 0112 ff '.'
        jz   l0119h         ; 0113 c6 '.' 19 '.'
        mov  a, r6          ; 0115 fe '.'
        call l017fh         ; 0116 34 '4' 7f '.'
        mov  r6, a          ; 0118 ae '.'
l0119h:
        mov  a, @r1         ; 0119 f1 '.'
        ret                 ; 011a 83 '.'
l011bh:
        mov  a, r7          ; 011b ff '.'
        jnz  l0124h         ; 011c 96 '.' 24 '$'
        mov  a, #039h       ; 011e 23 '#' 39 '9'
        mov  r6, a          ; 0120 ae '.'
        mov  r1, a          ; 0121 a9 '.'
        jmp  l012bh         ; 0122 24 '$' 2b '+'
l0124h:
        call l017fh         ; 0124 34 '4' 7f '.'
        mov  r1, a          ; 0126 a9 '.'
        xrl  a, r6          ; 0127 de '.'
        jnz  l012bh         ; 0128 96 '.' 2b '+'
        ret                 ; 012a 83 '.'
l012bh:
        mov  a, r4          ; 012b fc '.'
        mov  @r1, a         ; 012c a1 '.'
        mov  a, r1          ; 012d f9 '.'
        mov  r7, a          ; 012e af '.'
        ret                 ; 012f 83 '.'
l0130h:
        inc  r0             ; 0130 18 '.'
        mov  a, r5          ; 0131 fd '.'
        anl  a, #003h       ; 0132 53 'S' 03 '.'
l0134h:
        orl  a, @r0         ; 0134 40 '@'
l0135h:
        jb6  l0148h         ; 0135 d2 '.' 48 'H'
        anl  a, #0fdh       ; 0137 53 'S' fd '.'
l0139h:
        mov  r5, a          ; 0139 ad '.'
l013ah:
        jb4  l0151h         ; 013a 92 '.' 51 'Q'
        mov  a, r6          ; 013c fe '.'
        anl  a, #0fdh       ; 013d 53 'S' fd '.'
        mov  r6, a          ; 013f ae '.'
l0140h:
        dis  tcnti          ; 0140 35 '5'
        call l0186h         ; 0141 34 '4' 86 '.'
        call l02f2h         ; 0143 54 'T' f2 '.'
        mov  r0, #02bh      ; 0145 b8 '.' 2b '+'
        ret                 ; 0147 83 '.'
l0148h:
        jb1  l0139h         ; 0148 32 '2' 39 '9'
        orl  a, #002h       ; 014a 43 'C' 02 '.'
        call l0216h         ; 014c 54 'T' 16 '.'
        mov  a, r5          ; 014e fd '.'
        jmp  l013ah         ; 014f 24 '$' 3a ':'
l0151h:
        mov  a, r6          ; 0151 fe '.'
        jb1  l0140h         ; 0152 32 '2' 40 '@'
        orl  a, #002h       ; 0154 43 'C' 02 '.'
        call l0220h         ; 0156 54 'T' 20 ' '
        jmp  l0140h         ; 0158 24 '$' 40 '@'
l015ah:
        dis  tcnti          ; 015a 35 '5'
        sel  rb1            ; 015b d5 '.'
        mov  r4, a          ; 015c ac '.'
        call l011bh         ; 015d 34 '4' 1b '.'
        jnz  l0165h         ; 015f 96 '.' 65 'e'
        mov  a, #020h       ; 0161 23 '#' 20 ' '
        jmp  l0167h         ; 0163 24 '$' 67 'g'
l0165h:
        mov  a, #040h       ; 0165 23 '#' 40 '@'
l0167h:
        orl  a, r5          ; 0167 4d 'M'
        mov  r5, a          ; 0168 ad '.'
        mov  a, r4          ; 0169 fc '.'
        sel  rb0            ; 016a c5 '.'
        xrl  a, #07fh       ; 016b d3 '.' 7f '.'
        jnz  l0178h         ; 016d 96 '.' 78 'x'
        mov  a, r5          ; 016f fd '.'
        anl  a, #0fch       ; 0170 53 'S' fc '.'
        xrl  a, #0a8h       ; 0172 d3 '.' a8 '.'
        jnz  l0178h         ; 0174 96 '.' 78 'x'
        jmp  l0400h         ; 0176 84 '.' 00 '.'
l0178h:
        mov  a, r6          ; 0178 fe '.'
        cpl  a              ; 0179 37 '7'
        jb2  l017eh         ; 017a 52 'R' 7e '~'
        orl  p2, #001h      ; 017c 8a '.' 01 '.'
l017eh:
        ret                 ; 017e 83 '.'
l017fh:
        inc  a              ; 017f 17 '.'
        jb6  l0183h         ; 0180 d2 '.' 83 '.'
        ret                 ; 0182 83 '.'
l0183h:
        mov  a, #039h       ; 0183 23 '#' 39 '9'
        ret                 ; 0185 83 '.'
l0186h:
        call l01a1h         ; 0186 34 '4' a1 '.'
l0188h:
        mov  r0, #02ch      ; 0188 b8 '.' 2c ','
        xrl  a, @r0         ; 018a d0 '.'
        jz   l0199h         ; 018b c6 '.' 99 '.'
        call l01a1h         ; 018d 34 '4' a1 '.'
        sel  rb1            ; 018f d5 '.'
        xch  a, r5          ; 0190 2d '-'
        xrl  a, #080h       ; 0191 d3 '.' 80 '.'
        jmp  l0410h         ; 0193 84 '.' 10 '.'
l0195h:
        mov  @r0, a         ; 0195 a0 '.'
        add  a, #0aeh       ; 0196 03 '.' ae '.'
        jmpp @a             ; 0198 b3 '.'
l0199h:
        mov  a, r6          ; 0199 fe '.'
        jb3  l019fh         ; 019a 72 'r' 9f '.'
        sel  rb1            ; 019c d5 '.'
        mov  a, r5          ; 019d fd '.'
        movx @r0, a         ; 019e 90 '.'
l019fh:
        sel  rb0            ; 019f c5 '.'
        ret                 ; 01a0 83 '.'
l01a1h:
        in   a, p2          ; 01a1 0a '.'
        swap a              ; 01a2 47 'G'
        anl  a, #001h       ; 01a3 53 'S' 01 '.'
        jni  l01a9h         ; 01a5 86 '.' a9 '.'
        orl  a, #004h       ; 01a7 43 'C' 04 '.'
l01a9h:
        jnt1 l01adh         ; 01a9 46 'F' ad '.'
        orl  a, #002h       ; 01ab 43 'C' 02 '.'
l01adh:
        ret                 ; 01ad 83 '.'
        mov  r2, #0c3h      ; 01ae ba '.' c3 '.'
        sel  rb1            ; 01b0 d5 '.'
        jnc  l01edh         ; 01b1 e6 '.' ed '.'
        sel  mb1            ; 01b3 f5 '.'
        jf0  l01b8h         ; 01b4 b6 '.' b8 '.'
        jmp  l0206h         ; 01b6 44 'D' 06 '.'
l01b8h:
        jmp  l020eh         ; 01b8 44 'D' 0e '.'
l01bah:
        sel  rb1            ; 01ba d5 '.'
        mov  a, r5          ; 01bb fd '.'
        movx @r0, a         ; 01bc 90 '.'
        sel  rb0            ; 01bd c5 '.'
        mov  a, r6          ; 01be fe '.'
        anl  a, #0f7h       ; 01bf 53 'S' f7 '.'
        mov  r6, a          ; 01c1 ae '.'
        ret                 ; 01c2 83 '.'
        sel  rb1            ; 01c3 d5 '.'
        mov  a, r6          ; 01c4 fe '.'
        mov  r1, a          ; 01c5 a9 '.'
        mov  a, @r1         ; 01c6 f1 '.'
        anl  a, #00fh       ; 01c7 53 'S' 0f '.'
l01c9h:
        mov  r4, a          ; 01c9 ac '.'
l01cah:
        mov  a, r5          ; 01ca fd '.'
        anl  a, #0f0h       ; 01cb 53 'S' f0 '.'
        orl  a, r4          ; 01cd 4c 'L'
        movx @r0, a         ; 01ce 90 '.'
        sel  rb0            ; 01cf c5 '.'
        mov  a, r6          ; 01d0 fe '.'
        orl  a, #008h       ; 01d1 43 'C' 08 '.'
        mov  r6, a          ; 01d3 ae '.'
        ret                 ; 01d4 83 '.'
        call l0109h         ; 01d5 34 '4' 09 '.'
        anl  a, #0f0h       ; 01d7 53 'S' f0 '.'
        swap a              ; 01d9 47 'G'
        mov  r4, a          ; 01da ac '.'
        mov  a, r7          ; 01db ff '.'
        jnz  l01cah         ; 01dc 96 '.' ca '.'
        mov  a, r5          ; 01de fd '.'
        anl  a, #09fh       ; 01df 53 'S' 9f '.'
        mov  r5, a          ; 01e1 ad '.'
        anl  p2, #0feh      ; 01e2 9a '.' fe '.'
        jmp  l01cah         ; 01e4 24 '$' ca '.'
        mov  a, r6          ; 01e6 fe '.'          ; unreachable
        xrl  a, #004h       ; 01e7 d3 '.' 04 '.'   ; unreachable
        mov  r6, a          ; 01e9 ae '.'          ; unreachable
        jmp  l0430h         ; 01ea 84 '.' 30 '0'   ; unreachable
        nop                 ; 01ec 00 '.'          ; unreachable
l01edh:
        mov  a, r6          ; 01ed fe '.'
        call l0220h         ; 01ee 54 'T' 20 ' '
        mov  a, r6          ; 01f0 fe '.'
        anl  a, #001h       ; 01f1 53 'S' 01 '.'
        jmp  l03fch         ; 01f3 64 'd' fc '.'
        anl  p2, #0fdh      ; 01f5 9a '.' fd '.'   ; unreachable
        mov  r0, #02dh      ; 01f7 b8 '.' 2d '-'   ; unreachable
        mov  @r0, #0b8h     ; 01f9 b0 '.' b8 '.'   ; unreachable
        inc  r0             ; 01fb 18 '.'          ; unreachable
        mov  @r0, #00bh     ; 01fc b0 '.' 0b '.'   ; unreachable
        mov  a, r6          ; 01fe fe '.'          ; unreachable
        nop                 ; 01ff 00 '.'          ; unreachable
        nop                 ; 0200 00 '.'          ; unreachable
        orl  a, #010h       ; 0201 43 'C' 10 '.'   ; unreachable
        mov  r6, a          ; 0203 ae '.'          ; unreachable
        jmp  l01bah         ; 0204 24 '$' ba '.'   ; unreachable
l0206h:
        mov  a, r6          ; 0206 fe '.'
        orl  a, #080h       ; 0207 43 'C' 80 '.'
        mov  r6, a          ; 0209 ae '.'
        jmp  l042ah         ; 020a 84 '.' 2a '*'
        nop                 ; 020c 00 '.'          ; unreachable
        nop                 ; 020d 00 '.'          ; unreachable
l020eh:
        mov  a, r5          ; 020e fd '.'
        call l0216h         ; 020f 54 'T' 16 '.'
        mov  a, r5          ; 0211 fd '.'
        anl  a, #001h       ; 0212 53 'S' 01 '.'
        jmp  l03fch         ; 0214 64 'd' fc '.'
l0216h:
        xrl  a, #001h       ; 0216 d3 '.' 01 '.'
        mov  r5, a          ; 0218 ad '.'
        anl  a, #001h       ; 0219 53 'S' 01 '.'
        inc  a              ; 021b 17 '.'
        rr   a              ; 021c 77 'w'
        rr   a              ; 021d 77 'w'
        jmp  l00e5h         ; 021e 04 '.' e5 '.'
l0220h:
        xrl  a, #001h       ; 0220 d3 '.' 01 '.'
        mov  r6, a          ; 0222 ae '.'
        anl  a, #001h       ; 0223 53 'S' 01 '.'
        inc  a              ; 0225 17 '.'
        swap a              ; 0226 47 'G'
        jmp  l00e5h         ; 0227 04 '.' e5 '.'
l0229h:
        mov  r7, a          ; 0229 af '.'
        mov  a, r5          ; 022a fd '.'
        mov  r1, #004h      ; 022b b9 '.' 04 '.'
        jb5  l023bh         ; 022d b2 '.' 3b ';'
l022fh:
        jb7  l0236h         ; 022f f2 '.' 36 '6'
        jb3  l0236h         ; 0231 72 'r' 36 '6'
        jb2  l0239h         ; 0233 52 'R' 39 '9'
l0234h: equ  00234h         ; bad target           ; unreachable
        dec  r1             ; 0235 c9 '.'
l0236h:
        jb2  l023ah         ; 0236 52 'R' 3a ':'
        dec  r1             ; 0238 c9 '.'
l0239h:
        dec  r1             ; 0239 c9 '.'
l023ah:
        dec  r1             ; 023a c9 '.'
l023bh:
        mov  a, r1          ; 023b f9 '.'
        ret                 ; 023c 83 '.'
l023dh:
        sel  rb1            ; 023d d5 '.'
        mov  r2, a          ; 023e aa '.'
        jtf  l0241h         ; 023f 16 '.' 41 'A'
l0241h:
        mov  a, t           ; 0241 42 'B'
        add  a, #0f8h       ; 0242 03 '.' f8 '.'
        jb7  l0248h         ; 0244 f2 '.' 48 'H'
        mov  a, #0ffh       ; 0246 23 '#' ff '.'
l0248h:
        mov  t, a           ; 0248 62 'b'
        mov  a, r0          ; 0249 f8 '.'
        mov  r4, a          ; 024a ac '.'
        sel  rb0            ; 024b c5 '.'
        mov  a, r6          ; 024c fe '.'
        sel  rb1            ; 024d d5 '.'
        jb4  l0252h         ; 024e 92 '.' 52 'R'
        jmp  l02cah         ; 0250 44 'D' ca '.'
l0252h:
        mov  r0, #02dh      ; 0252 b8 '.' 2d '-'
        mov  a, @r0         ; 0254 f0 '.'
        dec  a              ; 0255 07 '.'
        mov  @r0, a         ; 0256 a0 '.'
        jnz  l0286h         ; 0257 96 '.' 86 '.'
        inc  r0             ; 0259 18 '.'
        mov  a, @r0         ; 025a f0 '.'
        dec  a              ; 025b 07 '.'
        mov  @r0, a         ; 025c a0 '.'
        jnz  l0286h         ; 025d 96 '.' 86 '.'
        mov  a, r5          ; 025f fd '.'
        anl  a, #0f0h       ; 0260 53 'S' f0 '.'
        orl  a, #00eh       ; 0262 43 'C' 0e '.'
        mov  r0, a          ; 0264 a8 '.'
        sel  rb0            ; 0265 c5 '.'
        xch  a, r6          ; 0266 2e '.'
        jb3  l0274h         ; 0267 72 'r' 74 't'
        xch  a, r6          ; 0269 2e '.'
        movx @r0, a         ; 026a 90 '.'
        call l01a1h         ; 026b 34 '4' a1 '.'
        call l01a1h         ; 026d 34 '4' a1 '.'
        xrl  a, #005h       ; 026f d3 '.' 05 '.'
        jz   l027eh         ; 0271 c6 '.' 7e '~'
l0273h:
        mov  a, r6          ; 0273 fe '.'
l0274h:
        anl  a, #0cfh       ; 0274 53 'S' cf '.'
        mov  r6, a          ; 0276 ae '.'
        orl  p2, #002h      ; 0277 8a '.' 02 '.'
        sel  rb1            ; 0279 d5 '.'
        mov  a, r0          ; 027a f8 '.'
        mov  r5, a          ; 027b ad '.'
        jmp  l02cah         ; 027c 44 'D' ca '.'
l027eh:
        sel  rb1            ; 027e d5 '.'
        mov  r1, #02ch      ; 027f b9 '.' 2c ','
        mov  a, @r1         ; 0281 f1 '.'
        xrl  a, #005h       ; 0282 d3 '.' 05 '.'
        jz   l0273h         ; 0284 c6 '.' 73 's'
l0286h:
        mov  r0, #02fh      ; 0286 b8 '.' 2f '/'
        jmp  l02fah         ; 0288 44 'D' fa '.'
l028ah:
        mov  @r0, a         ; 028a a0 '.'
        sel  rb0            ; 028b c5 '.'
        jt0  l029ch         ; 028c 36 '6' 9c '.'
        mov  a, r6          ; 028e fe '.'
        anl  a, #0dfh       ; 028f 53 'S' df '.'
        mov  r6, a          ; 0291 ae '.'
        sel  rb1            ; 0292 d5 '.'
        mov  a, @r0         ; 0293 f0 '.'
        jnz  l02cah         ; 0294 96 '.' ca '.'
        anl  p2, #0f7h      ; 0296 9a '.' f7 '.'
        orl  p2, #008h      ; 0298 8a '.' 08 '.'
        jmp  l02cah         ; 029a 44 'D' ca '.'
l029ch:
        anl  p2, #0fbh      ; 029c 9a '.' fb '.'
        nop                 ; 029e 00 '.'
        orl  p2, #004h      ; 029f 8a '.' 04 '.'
        mov  a, r6          ; 02a1 fe '.'
        jb5  l02cah         ; 02a2 b2 '.' ca '.'
        orl  a, #020h       ; 02a4 43 'C' 20 ' '
        mov  r6, a          ; 02a6 ae '.'
        sel  rb1            ; 02a7 d5 '.'
        mov  a, @r0         ; 02a8 f0 '.'
        jb7  l02b1h         ; 02a9 f2 '.' b1 '.'
        mov  a, r5          ; 02ab fd '.'
        orl  a, #00fh       ; 02ac 43 'C' 0f '.'
        mov  r5, a          ; 02ae ad '.'
        jmp  l02c3h         ; 02af 44 'D' c3 '.'
l02b1h:
        mov  a, r5          ; 02b1 fd '.'
        anl  a, #00fh       ; 02b2 53 'S' 0f '.'
        xrl  a, #00eh       ; 02b4 d3 '.' 0e '.'
        jz   l02c1h         ; 02b6 c6 '.' c1 '.'
        dec  a              ; 02b8 07 '.'
        jnz  l02c0h         ; 02b9 96 '.' c0 '.'
        mov  a, r5          ; 02bb fd '.'
        anl  a, #0f0h       ; 02bc 53 'S' f0 '.'
        mov  r5, a          ; 02be ad '.'
        dec  r5             ; 02bf cd '.'
l02c0h:
        inc  r5             ; 02c0 1d '.'
l02c1h:
        mov  @r0, #011h     ; 02c1 b0 '.' 11 '.'
l02c3h:
        sel  rb0            ; 02c3 c5 '.'
        mov  a, r6          ; 02c4 fe '.'
        jb3  l02cah         ; 02c5 72 'r' ca '.'
        sel  rb1            ; 02c7 d5 '.'
        mov  a, r5          ; 02c8 fd '.'
        movx @r0, a         ; 02c9 90 '.'
l02cah:
        sel  rb1            ; 02ca d5 '.'
        mov  a, r4          ; 02cb fc '.'
        mov  r0, a          ; 02cc a8 '.'
        mov  r1, #038h      ; 02cd b9 '.' 38 '8'
        mov  a, @r1         ; 02cf f1 '.'
        dec  a              ; 02d0 07 '.'
        mov  @r1, a         ; 02d1 a1 '.'
        jnz  l02edh         ; 02d2 96 '.' ed '.'
        mov  @r1, #00ah     ; 02d4 b1 '.' 0a '.'
        clr  a              ; 02d6 27 '''
        cpl  a              ; 02d7 37 '7'
        call l00ffh         ; 02d8 14 '.' ff '.'
        mov  a, r3          ; 02da fb '.'
        jz   l02edh         ; 02db c6 '.' ed '.'
        djnz r3, l02edh     ; 02dd eb '.' ed '.'
        inc  r3             ; 02df 1b '.'
        mov  a, r7          ; 02e0 ff '.'
        jnz  l02edh         ; 02e1 96 '.' ed '.'
        mov  a, r5          ; 02e3 fd '.'
        orl  a, #010h       ; 02e4 43 'C' 10 '.'
        mov  r5, a          ; 02e6 ad '.'
        mov  r3, #009h      ; 02e7 bb '.' 09 '.'
        mov  a, #0ffh       ; 02e9 23 '#' ff '.'
        call l015ah         ; 02eb 34 '4' 5a 'Z'
l02edh:
        sel  rb1            ; 02ed d5 '.'
        mov  a, r2          ; 02ee fa '.'
        jmp  l03edh         ; 02ef 64 'd' ed '.'
        retr                ; 02f1 93 '.'          ; unreachable
l02f2h:
        jmp  l03f4h         ; 02f2 64 'd' f4 '.'
        en   tcnti          ; 02f4 25 '%'          ; unreachable
        ret                 ; 02f5 83 '.'          ; unreachable
l02f6h:
        call l023dh         ; 02f6 54 'T' 3d '='
        en   tcnti          ; 02f8 25 '%'
        ret                 ; 02f9 83 '.'
l02fah:
        mov  a, @r0         ; 02fa f0 '.'
        jb7  l02feh         ; 02fb f2 '.' fe '.'
        dec  a              ; 02fd 07 '.'
l02feh:
        jmp  l028ah         ; 02fe 44 'D' 8a '.'
l0300h:                                            ; unreachable
        nop                 ; 0300 00 '.'          ; unreachable
        inc  r3             ; 0301 1b '.'          ; unreachable
        inc  r0             ; 0302 18 '.'          ; unreachable
        xch  a, r0          ; 0303 28 '('          ; unreachable
        en   tcnti          ; 0304 25 '%'          ; unreachable
l0305h:                                            ; unreachable
        nop                 ; 0305 00 '.'          ; unreachable
        inc  r6             ; 0306 1e '.'          ; unreachable
l0307h:                                            ; unreachable
        nop                 ; 0307 00 '.'          ; unreachable
        outl bus, a         ; 0308 02 '.'          ; unreachable
        inc  r1             ; 0309 19 '.'          ; unreachable
        db   022h           ; 030a 22 '"'          ; unreachable
        jtf  l0324h         ; 030b 16 '.' 24 '$'   ; unreachable
        inc  r4             ; 030d 1c '.'          ; unreachable
        xch  a, r2          ; 030e 2a '*'          ; unreachable
        nop                 ; 030f 00 '.'          ; unreachable
        inc  r5             ; 0310 1d '.'          ; unreachable
        inc  r2             ; 0311 1a '.'          ; unreachable
        inc  a              ; 0312 17 '.'          ; unreachable
        clr  a              ; 0313 27 '''          ; unreachable
        xch  a, r1          ; 0314 29 ')'          ; unreachable
        xch  a, @r0         ; 0315 20 ' '          ; unreachable
        db   001h           ; 0316 01 '.'          ; unreachable
        jnt0 l0307h         ; 0317 26 '&' 07 '.'   ; unreachable
        jnt1 l0342h         ; 0319 46 'F' 42 'B'   ; unreachable
        jmp  l0234h         ; 031b 44 'D' 34 '4'   ; unreachable
        movd a, p4          ; 031d 0c '.'          ; unreachable
l031eh:                                            ; unreachable
        xchd a, @r0         ; 031e 30 '0'          ; unreachable
        anl  a, @r1         ; 031f 51 'Q'          ; unreachable
        db   006h           ; 0320 06 '.'          ; unreachable
        movd p4, a          ; 0321 3c '<'          ; unreachable
        db   038h           ; 0322 38 '8'          ; unreachable
        orl  a, #02fh       ; 0323 43 'C' 2f '/'   ; unreachable
l0324h: equ  00324h         ; bad target           ; unreachable
        swap a              ; 0325 47 'G'          ; unreachable
        dis  tcnti          ; 0326 35 '5'          ; unreachable
        addc a, #004h       ; 0327 13 '.' 04 '.'   ; unreachable
        orl  a, r0          ; 0329 48 'H'          ; unreachable
        movd a, p7          ; 032a 0f '.'          ; unreachable
l032bh:                                            ; unreachable
        nop                 ; 032b 00 '.'          ; unreachable
        xch  a, r5          ; 032c 2d '-'          ; unreachable
        movd a, p6          ; 032d 0e '.'          ; unreachable
        cpl  a              ; 032e 37 '7'          ; unreachable
        nop                 ; 032f 00 '.'          ; unreachable
        movd a, p5          ; 0330 0d '.'          ; unreachable
        nop                 ; 0331 00 '.'          ; unreachable
        orl  a, r6          ; 0332 4e 'N'          ; unreachable
        inc  @r1            ; 0333 11 '.'          ; unreachable
        jt0  l0305h         ; 0334 36 '6' 05 '.'   ; unreachable
        xch  a, r6          ; 0336 2e '.'          ; unreachable
l0337h:                                            ; unreachable
        call l004bh         ; 0337 14 '.' 4b 'K'   ; unreachable
l0338h: equ  00338h         ; bad target           ; unreachable
        movd p5, a          ; 0339 3d '='          ; unreachable
        movd p6, a          ; 033a 3e '>'          ; unreachable
        outl p2, a          ; 033b 3a ':'          ; unreachable
        jb1  l0350h         ; 033c 32 '2' 50 'P'   ; unreachable
        in   a, p1          ; 033e 09 '.'          ; unreachable
        orl  a, r5          ; 033f 4d 'M'          ; unreachable
l0340h:                                            ; unreachable
        db   00bh           ; 0340 0b '.'          ; unreachable
        orl  a, r1          ; 0341 49 'I'          ; unreachable
l0342h:                                            ; unreachable
        orl  a, @r1         ; 0342 41 'A'          ; unreachable
        orl  a, r2          ; 0343 4a 'J'          ; unreachable
        xchd a, @r1         ; 0344 31 '1'          ; unreachable
        orl  a, @r0         ; 0345 40 '@'          ; unreachable
        ins  a, bus         ; 0346 08 '.'          ; unreachable
        strt cnt            ; 0347 45 'E'          ; unreachable
        orl  a, r4          ; 0348 4c 'L'          ; unreachable
        db   03bh           ; 0349 3b ';'          ; unreachable
        outl p1, a          ; 034a 39 '9'          ; unreachable
        orl  a, r7          ; 034b 4f 'O'          ; unreachable
        db   033h           ; 034c 33 '3'          ; unreachable
        movd p7, a          ; 034d 3f '?'          ; unreachable
        in   a, p2          ; 034e 0a '.'          ; unreachable
        mov  a, #01fh       ; 034f 23 '#' 1f '.'   ; unreachable
l0350h: equ  00350h         ; bad target           ; unreachable
        inc  @r0            ; 0351 10 '.'          ; unreachable
        xch  a, @r1         ; 0352 21 '!'          ; unreachable
        jb0  l032bh         ; 0353 12 '.' 2b '+'   ; unreachable
        add  a, #02ch       ; 0355 03 '.' 2c ','   ; unreachable
        dis  i              ; 0357 15 '.'          ; unreachable
        add  a, @r1         ; 0358 61 'a'          ; unreachable
        orl  a, @r1         ; 0359 41 'A'          ; unreachable
        db   001h           ; 035a 01 '.'          ; unreachable
        db   001h           ; 035b 01 '.'          ; unreachable
        db   0c1h           ; 035c c1 '.'          ; unreachable
        xrl  a, r3          ; 035d db '.'          ; unreachable
l035eh:                                            ; unreachable
        djnz r2, l03dbh     ; 035e ea '.' db '.'   ; unreachable
        djnz r2, l039bh     ; 0360 ea '.' 9b '.'   ; unreachable
        addc a, r7          ; 0362 7f '.'          ; unreachable
        inc  r3             ; 0363 1b '.'          ; unreachable
        in   a, p1          ; 0364 09 '.'          ; unreachable
        movd a, p5          ; 0365 0d '.'          ; unreachable
        xch  a, @r0         ; 0366 20 ' '          ; unreachable
        xch  a, r5          ; 0367 2d '-'          ; unreachable
        xch  a, r4          ; 0368 2c ','          ; unreachable
        xchd a, @r0         ; 0369 30 '0'          ; unreachable
        xch  a, r6          ; 036a 2e '.'          ; unreachable
        movd a, p5          ; 036b 0d '.'          ; unreachable
        xchd a, @r1         ; 036c 31 '1'          ; unreachable
        jmp  l04b1h         ; 036d 84 '.' b1 '.'   ; unreachable
        movx @r1, a         ; 036f 91 '.'          ; unreachable
        mov  a, r2          ; 0370 fa '.'          ; unreachable
        jb1  l038ah         ; 0371 32 '2' 8a '.'   ; unreachable
        jb5  l0392h         ; 0373 b2 '.' 92 '.'   ; unreachable
        mov  a, r3          ; 0375 fb '.'          ; unreachable
        db   033h           ; 0376 33 '3'          ; unreachable
        ret                 ; 0377 83 '.'          ; unreachable
        jmpp @a             ; 0378 b3 '.'          ; unreachable
        retr                ; 0379 93 '.'          ; unreachable
        mov  a, r4          ; 037a fc '.'          ; unreachable
        call l0188h         ; 037b 34 '4' 88 '.'   ; unreachable
        call l0594h         ; 037d b4 '.' 94 '.'   ; unreachable
        mov  a, r5          ; 037f fd '.'          ; unreachable
        dis  tcnti          ; 0380 35 '5'          ; unreachable
        db   085h           ; 0381 85 '.'          ; unreachable
        cpl  f1             ; 0382 b5 '.'          ; unreachable
        cpl  f0             ; 0383 95 '.'          ; unreachable
        mov  r2, #036h      ; 0384 ba '.' 36 '6'   ; unreachable
        jni  l03b6h         ; 0386 86 '.' b6 '.'   ; unreachable
        jnz  l03bbh         ; 0388 96 '.' bb '.'   ; unreachable
l038ah:                                            ; unreachable
        cpl  a              ; 038a 37 '7'          ; unreachable
        db   087h           ; 038b 87 '.'          ; unreachable
        db   0b7h           ; 038c b7 '.'          ; unreachable
        db   097h           ; 038d 97 '.'          ; unreachable
        mov  r4, #038h      ; 038e bc '.' 38 '8'   ; unreachable
        db   082h           ; 0390 82 '.'          ; unreachable
        mov  r0, #098h      ; 0391 b8 '.' 98 '.'   ; unreachable
l0392h: equ  00392h         ; bad target           ; unreachable
        mov  r5, #039h      ; 0393 bd '.' 39 '9'   ; unreachable
        orl  p1, #0b9h      ; 0395 89 '.' b9 '.'   ; unreachable
        anl  p1, #0beh      ; 0397 99 '.' be '.'   ; unreachable
        addc a, r4          ; 0399 7c '|'          ; unreachable
        add  a, @r0         ; 039a 60 '`'          ; unreachable
l039bh:                                            ; unreachable
        addc a, r4          ; 039b 7c '|'          ; unreachable
        add  a, @r0         ; 039c 60 '`'          ; unreachable
        addc a, r6          ; 039d 7e '~'          ; unreachable
        anl  a, r4          ; 039e 5c '\'          ; unreachable
        addc a, r6          ; 039f 7e '~'          ; unreachable
        inc  r4             ; 03a0 1c '.'          ; unreachable
        xchd a, @r1         ; 03a1 31 '1'          ; unreachable
        xch  a, @r1         ; 03a2 21 '!'          ; unreachable
        xchd a, @r1         ; 03a3 31 '1'          ; unreachable
        xch  a, @r1         ; 03a4 21 '!'          ; unreachable
        jb1  l0340h         ; 03a5 32 '2' 40 '@'   ; unreachable
        jb1  l0300h         ; 03a7 32 '2' 00 '.'   ; unreachable
        db   033h           ; 03a9 33 '3'          ; unreachable
        mov  a, #033h       ; 03aa 23 '#' 33 '3'   ; unreachable
        mov  a, #034h       ; 03ac 23 '#' 34 '4'   ; unreachable
        jmp  l0134h         ; 03ae 24 '$' 34 '4'   ; unreachable
        jmp  l0135h         ; 03b0 24 '$' 35 '5'   ; unreachable
        en   tcnti          ; 03b2 25 '%'          ; unreachable
        dis  tcnti          ; 03b3 35 '5'          ; unreachable
        en   tcnti          ; 03b4 25 '%'          ; unreachable
        jt0  l035eh         ; 03b5 36 '6' 5e '^'   ; unreachable
l03b6h: equ  003b6h         ; bad target           ; unreachable
        jt0  l031eh         ; 03b7 36 '6' 1e '.'   ; unreachable
        cpl  a              ; 03b9 37 '7'          ; unreachable
        jnt0 l0337h         ; 03ba 26 '&' 37 '7'   ; unreachable
l03bbh: equ  003bbh         ; bad target           ; unreachable
        jnt0 l0338h         ; 03bc 26 '&' 38 '8'   ; unreachable
        xch  a, r2          ; 03be 2a '*'          ; unreachable
        db   038h           ; 03bf 38 '8'          ; unreachable
        xch  a, r2          ; 03c0 2a '*'          ; unreachable
        outl p1, a          ; 03c1 39 '9'          ; unreachable
        xch  a, r0          ; 03c2 28 '('          ; unreachable
        outl p1, a          ; 03c3 39 '9'          ; unreachable
        xch  a, r0          ; 03c4 28 '('          ; unreachable
        xchd a, @r0         ; 03c5 30 '0'          ; unreachable
        xch  a, r1          ; 03c6 29 ')'          ; unreachable
        xchd a, @r0         ; 03c7 30 '0'          ; unreachable
        xch  a, r1          ; 03c8 29 ')'          ; unreachable
        xch  a, r5          ; 03c9 2d '-'          ; unreachable
        anl  a, r7          ; 03ca 5f '_'          ; unreachable
        xch  a, r5          ; 03cb 2d '-'          ; unreachable
        inc  r7             ; 03cc 1f '.'          ; unreachable
        movd p5, a          ; 03cd 3d '='          ; unreachable
        xch  a, r3          ; 03ce 2b '+'          ; unreachable
        movd p5, a          ; 03cf 3d '='          ; unreachable
        xch  a, r3          ; 03d0 2b '+'          ; unreachable
        anl  a, r3          ; 03d1 5b '['          ; unreachable
        addc a, r3          ; 03d2 7b '{'          ; unreachable
        inc  r3             ; 03d3 1b '.'          ; unreachable
        addc a, r3          ; 03d4 7b '{'          ; unreachable
        anl  a, r5          ; 03d5 5d ']'          ; unreachable
        addc a, r5          ; 03d6 7d '}'          ; unreachable
        inc  r5             ; 03d7 1d '.'          ; unreachable
        addc a, r5          ; 03d8 7d '}'          ; unreachable
        db   03bh           ; 03d9 3b ';'          ; unreachable
        outl p2, a          ; 03da 3a ':'          ; unreachable
l03dbh:                                            ; unreachable
        db   03bh           ; 03db 3b ';'          ; unreachable
        outl p2, a          ; 03dc 3a ':'          ; unreachable
        clr  a              ; 03dd 27 '''          ; unreachable
        db   022h           ; 03de 22 '"'          ; unreachable
        clr  a              ; 03df 27 '''          ; unreachable
        db   022h           ; 03e0 22 '"'          ; unreachable
        xch  a, r4          ; 03e1 2c ','          ; unreachable
        movd p4, a          ; 03e2 3c '<'          ; unreachable
        xch  a, r4          ; 03e3 2c ','          ; unreachable
        movd p4, a          ; 03e4 3c '<'          ; unreachable
        xch  a, r6          ; 03e5 2e '.'          ; unreachable
        movd p6, a          ; 03e6 3e '>'          ; unreachable
        xch  a, r6          ; 03e7 2e '.'          ; unreachable
        movd p6, a          ; 03e8 3e '>'          ; unreachable
        xch  a, r7          ; 03e9 2f '/'          ; unreachable
        movd p7, a          ; 03ea 3f '?'          ; unreachable
        xch  a, r7          ; 03eb 2f '/'          ; unreachable
        movd p7, a          ; 03ec 3f '?'          ; unreachable
l03edh:
        stop tcnt           ; 03ed 65 'e'
        strt t              ; 03ee 55 'U'
        jtf  l03f2h         ; 03ef 16 '.' f2 '.'
        retr                ; 03f1 93 '.'
l03f2h:
        jmp  l023dh         ; 03f2 44 'D' 3d '='
l03f4h:
        stop tcnt           ; 03f4 65 'e'
        strt t              ; 03f5 55 'U'
        jtf  l03fah         ; 03f6 16 '.' fa '.'
        en   tcnti          ; 03f8 25 '%'
        ret                 ; 03f9 83 '.'
l03fah:
        jmp  l02f6h         ; 03fa 44 'D' f6 '.'
l03fch:
        sel  rb1            ; 03fc d5 '.'
        jmp  l01c9h         ; 03fd 24 '$' c9 '.'
        orl  a, r7          ; 03ff 4f 'O'          ; unreachable
l0400h:
        mov  a, r6          ; 0400 fe '.'
        jb6  l0405h         ; 0401 d2 '.' 05 '.'
        anl  p2, #0bfh      ; 0403 9a '.' bf '.'
l0405h:
        jmp  l0178h         ; 0405 24 '$' 78 'x'
        ds   9, 0ffh        ; 0407 ff '.' ...      ; unreachable
l0410h:
        xch  a, r5          ; 0410 2d '-'
        sel  rb0            ; 0411 c5 '.'
        xch  a, r6          ; 0412 2e '.'
        jb7  l0417h         ; 0413 f2 '.' 17 '.'
        xch  a, r6          ; 0415 2e '.'
        jmp  l0195h         ; 0416 24 '$' 95 '.'
l0417h: equ  00417h         ; bad target
        anl  a, #07fh       ; 0418 53 'S' 7f '.'
        xch  a, r6          ; 041a 2e '.'
        mov  @r0, a         ; 041b a0 '.'
        xrl  a, #007h       ; 041c d3 '.' 07 '.'
        jz   l0422h         ; 041e c6 '.' 22 '"'
        jmp  l01bah         ; 0420 24 '$' ba '.'
l0422h:
        mov  a, r6          ; 0422 fe '.'
        xrl  a, #040h       ; 0423 d3 '.' 40 '@'
        mov  r6, a          ; 0425 ae '.'
        anl  a, #040h       ; 0426 53 'S' 40 '@'
        jz   l042ch         ; 0428 c6 '.' 2c ','
l042ah:
        mov  a, #001h       ; 042a 23 '#' 01 '.'
l042ch:
        jmp  l03fch         ; 042c 64 'd' fc '.'
        ds   2, 0ffh        ; 042e ff '.' ...      ; unreachable
l0430h:                                            ; unreachable
        anl  a, #004h       ; 0430 53 'S' 04 '.'   ; unreachable
        jnz  l042ah         ; 0432 96 '.' 2a '*'   ; unreachable
        anl  p2, #0feh      ; 0434 9a '.' fe '.'   ; unreachable
        jmp  l03fch         ; 0436 64 'd' fc '.'   ; unreachable
        ds   968, 0ffh      ; 0438 ff '.' ...      ; unreachable
l04b1h: equ  004b1h         ; bad target           ; unreachable
l0594h: equ  00594h         ; bad target           ; unreachable
        end                 ; 0800                 ; unreachable
