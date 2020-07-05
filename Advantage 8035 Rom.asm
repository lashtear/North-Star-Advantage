	sel  rb0            ; 0000 c5
	dis  tcnti          ; 0001 35
	clr  a              ; 0002 27
	mov  r0, #03fh      ; 0003 b8 3f
	jmp  l0009h         ; 0005 04 09
	jmp  l023dh         ; 0007 44 3d
l0009h:
	mov  @r0, a         ; 0009 a0
	djnz r0, l0009h     ; 000a e8 09
	sel  rb1            ; 000c d5
	mov  r0, #030h      ; 000d b8 30
	mov  r5, #00eh      ; 000f bd 0e
	mov  a, r5          ; 0011 fd
	movx @r0, a         ; 0012 90
	sel  rb0            ; 0013 c5
	mov  r0, #021h      ; 0014 b8 21
	mov  a, #0feh       ; 0016 23 fe
	outl p2, a          ; 0018 3a
	mov  a, #05eh       ; 0019 23 5e
	call l00e5h         ; 001b 14 e5
	mov  a, #0f8h       ; 001d 23 f8
	mov  t, a           ; 001f 62
	jtf  l0022h         ; 0020 16 22
l0022h:
	strt t              ; 0022 55
l0023h:
	dec  r0             ; 0023 c8
	mov  a, r0          ; 0024 f8
	xrl  a, #01fh       ; 0025 d3 1f
	jnz  l002bh         ; 0027 96 2b
	call l0130h         ; 0029 34 30
l002bh:
	call l00ddh         ; 002b 14 dd
	jz   l0023h         ; 002d c6 23
	mov  r3, a          ; 002f ab
	mov  a, #00fh       ; 0030 23 0f
	call l00e5h         ; 0032 14 e5
	mov  r2, #032h      ; 0034 ba 32
l0036h:
	djnz r2, l0036h     ; 0036 ea 36
	call l00ddh         ; 0038 14 dd
	mov  r2, a          ; 003a aa
	mov  a, #00eh       ; 003b 23 0e
	call l00e5h         ; 003d 14 e5
	mov  a, r2          ; 003f fa
	anl  a, r3          ; 0040 5b
	jz   l0023h         ; 0041 c6 23
	mov  r3, a          ; 0043 ab
	mov  r2, #008h      ; 0044 ba 08
l0046h:
	mov  a, r3          ; 0046 fb
	rr   a              ; 0047 77
	xch  a, @r0         ; 0048 20
	rr   a              ; 0049 77
	xch  a, @r0         ; 004a 20
l004bh:
	mov  r3, a          ; 004b ab
	jb7  l0052h         ; 004c f2 52
l004eh:
	djnz r2, l0046h     ; 004e ea 46
	jmp  l0023h         ; 0050 04 23
l0052h:
	mov  a, @r0         ; 0052 f0
	jb7  l00c3h         ; 0053 f2 c3
	call l00efh         ; 0055 14 ef
	mov  r1, a          ; 0057 a9
	mov  a, r7          ; 0058 ff
	dis  tcnti          ; 0059 35
	call l00ffh         ; 005a 14 ff
	sel  rb0            ; 005c c5
	call l02f2h         ; 005d 54 f2
	mov  a, r0          ; 005f f8
	xrl  a, #020h       ; 0060 d3 20
	jz   l008fh         ; 0062 c6 8f
	mov  a, r7          ; 0064 ff
	mov  r4, a          ; 0065 ac
	sel  rb1            ; 0066 d5
	mov  r3, #05ch      ; 0067 bb 5c
	sel  rb0            ; 0069 c5
	mov  a, r1          ; 006a f9
	jz   l008fh         ; 006b c6 8f
	add  a, #0c8h       ; 006d 03 c8
	jc   l0095h         ; 006f f6 95
	add  a, #00fh       ; 0071 03 0f
	jc   l00a5h         ; 0073 f6 a5
	add  a, #00ah       ; 0075 03 0a
	jc   l00abh         ; 0077 f6 ab
	add  a, #009h       ; 0079 03 09
	jc   l00afh         ; 007b f6 af
	add  a, #015h       ; 007d 03 15
	rl   a              ; 007f e7
	rl   a              ; 0080 e7
	mov  r7, a          ; 0081 af
	mov  a, r5          ; 0082 fd
	mov  r1, #004h      ; 0083 b9 04
	call l022fh         ; 0085 54 2f
	add  a, r7          ; 0087 6f
	add  a, #099h       ; 0088 03 99
l008ah:
	movp3a, @a          ; 008a e3
l008bh:
	call l015ah         ; 008b 34 5a
	call l02f2h         ; 008d 54 f2
l008fh:
	mov  a, @r0         ; 008f f0
	xrl  a, #080h       ; 0090 d3 80
	mov  @r0, a         ; 0092 a0
	jmp  l004eh         ; 0093 04 4e
l0095h:
	call l0229h         ; 0095 54 29
	jb2  l009fh         ; 0097 52 9f
	jb0  l009fh         ; 0099 12 9f
	mov  a, r5          ; 009b fd
	anl  a, #001h       ; 009c 53 01
	add  a, r1          ; 009e 69
l009fh:
	add  a, #058h       ; 009f 03 58
l00a1h:
	movp3a, @a          ; 00a1 e3
	add  a, r7          ; 00a2 6f
	jmp  l008bh         ; 00a3 04 8b
l00a5h:
	call l0229h         ; 00a5 54 29
	add  a, #05dh       ; 00a7 03 5d
	jmp  l00a1h         ; 00a9 04 a1
l00abh:
	add  a, #062h       ; 00ab 03 62
	jmp  l008ah         ; 00ad 04 8a
l00afh:
	mov  r7, a          ; 00af af
	rl   a              ; 00b0 e7
	rl   a              ; 00b1 e7
	add  a, r7          ; 00b2 6f
	call l0229h         ; 00b3 54 29
	jb2  l00beh         ; 00b5 52 be
	jb0  l00beh         ; 00b7 12 be
	add  a, r7          ; 00b9 6f
	mov  r7, a          ; 00ba af
	mov  a, r6          ; 00bb fe
	anl  a, #001h       ; 00bc 53 01
l00beh:
	add  a, r7          ; 00be 6f
	add  a, #06ch       ; 00bf 03 6c
	jmp  l008ah         ; 00c1 04 8a
l00c3h:
	call l00efh         ; 00c3 14 ef
	mov  r1, #030h      ; 00c5 b9 30
l00c7h:
	mov  a, r7          ; 00c7 ff
	xrl  a, @r1         ; 00c8 d1
	jz   l004eh         ; 00c9 c6 4e
	inc  r1             ; 00cb 19
	mov  a, r1          ; 00cc f9
	cpl  a              ; 00cd 37
	jb3  l00c7h         ; 00ce 72 c7
	mov  a, r4          ; 00d0 fc
	xrl  a, r7          ; 00d1 df
	jnz  l008fh         ; 00d2 96 8f
	sel  rb1            ; 00d4 d5
	mov  r3, a          ; 00d5 ab
	mov  a, r5          ; 00d6 fd
	anl  a, #0efh       ; 00d7 53 ef
	mov  r5, a          ; 00d9 ad
	sel  rb0            ; 00da c5
	jmp  l008fh         ; 00db 04 8f
l00ddh:
	mov  a, r0          ; 00dd f8
	anl  a, #00fh       ; 00de 53 0f
	call l00e5h         ; 00e0 14 e5
	xrl  a, @r0         ; 00e2 d0
	cpl  a              ; 00e3 37
	ret                 ; 00e4 83
l00e5h:
	outl p1, a          ; 00e5 39
	anl  p2, #07fh      ; 00e6 9a 7f
	orl  p1, #0ffh      ; 00e8 89 ff
	nop                 ; 00ea 00
	in   a, p1          ; 00eb 09
	orl  p2, #080h      ; 00ec 8a 80
	ret                 ; 00ee 83
l00efh:
	mov  a, r0          ; 00ef f8
	dec  a              ; 00f0 07
	swap a              ; 00f1 47
	rr   a              ; 00f2 77
	anl  a, #078h       ; 00f3 53 78
	mov  r7, a          ; 00f5 af
	mov  a, r2          ; 00f6 fa
	cpl  a              ; 00f7 37
	inc  a              ; 00f8 17
	anl  a, #007h       ; 00f9 53 07
	orl  a, r7          ; 00fb 4f
	mov  r7, a          ; 00fc af
	movp3a, @a          ; 00fd e3
	ret                 ; 00fe 83
l00ffh:
	sel  rb1            ; 00ff d5
	mov  @r0, a         ; 0100 a0
	inc  r0             ; 0101 18
	mov  a, r0          ; 0102 f8
	jb3  l0106h         ; 0103 72 06
	ret                 ; 0105 83
l0106h:
	mov  r0, #030h      ; 0106 b8 30
	ret                 ; 0108 83
l0109h:
	sel  rb1            ; 0109 d5
	mov  a, r6          ; 010a fe
	mov  r1, a          ; 010b a9
	xrl  a, r7          ; 010c df
	jnz  l0112h         ; 010d 96 12
	mov  r7, a          ; 010f af
	jmp  l0119h         ; 0110 24 19
l0112h:
	mov  a, r7          ; 0112 ff
	jz   l0119h         ; 0113 c6 19
	mov  a, r6          ; 0115 fe
	call l017fh         ; 0116 34 7f
	mov  r6, a          ; 0118 ae
l0119h:
	mov  a, @r1         ; 0119 f1
	ret                 ; 011a 83
l011bh:
	mov  a, r7          ; 011b ff
	jnz  l0124h         ; 011c 96 24
	mov  a, #039h       ; 011e 23 39
	mov  r6, a          ; 0120 ae
	mov  r1, a          ; 0121 a9
	jmp  l012bh         ; 0122 24 2b
l0124h:
	call l017fh         ; 0124 34 7f
	mov  r1, a          ; 0126 a9
	xrl  a, r6          ; 0127 de
	jnz  l012bh         ; 0128 96 2b
	ret                 ; 012a 83
l012bh:
	mov  a, r4          ; 012b fc
	mov  @r1, a         ; 012c a1
	mov  a, r1          ; 012d f9
	mov  r7, a          ; 012e af
	ret                 ; 012f 83
l0130h:
	inc  r0             ; 0130 18
	mov  a, r5          ; 0131 fd
	anl  a, #003h       ; 0132 53 03
l0134h:
	orl  a, @r0         ; 0134 40
l0135h:
	jb6  l0148h         ; 0135 d2 48
	anl  a, #0fdh       ; 0137 53 fd
l0139h:
	mov  r5, a          ; 0139 ad
l013ah:
	jb4  l0151h         ; 013a 92 51
	mov  a, r6          ; 013c fe
	anl  a, #0fdh       ; 013d 53 fd
	mov  r6, a          ; 013f ae
l0140h:
	dis  tcnti          ; 0140 35
	call l0186h         ; 0141 34 86
	call l02f2h         ; 0143 54 f2
	mov  r0, #02bh      ; 0145 b8 2b
	ret                 ; 0147 83
l0148h:
	jb1  l0139h         ; 0148 32 39
	orl  a, #002h       ; 014a 43 02
	call l0216h         ; 014c 54 16
	mov  a, r5          ; 014e fd
	jmp  l013ah         ; 014f 24 3a
l0151h:
	mov  a, r6          ; 0151 fe
	jb1  l0140h         ; 0152 32 40
	orl  a, #002h       ; 0154 43 02
	call l0220h         ; 0156 54 20
	jmp  l0140h         ; 0158 24 40
l015ah:
	dis  tcnti          ; 015a 35
	sel  rb1            ; 015b d5
	mov  r4, a          ; 015c ac
	call l011bh         ; 015d 34 1b
	jnz  l0165h         ; 015f 96 65
	mov  a, #020h       ; 0161 23 20
	jmp  l0167h         ; 0163 24 67
l0165h:
	mov  a, #040h       ; 0165 23 40
l0167h:
	orl  a, r5          ; 0167 4d
	mov  r5, a          ; 0168 ad
	mov  a, r4          ; 0169 fc
	sel  rb0            ; 016a c5
	xrl  a, #07fh       ; 016b d3 7f
	jnz  l0178h         ; 016d 96 78
	mov  a, r5          ; 016f fd
	anl  a, #0fch       ; 0170 53 fc
	xrl  a, #0a8h       ; 0172 d3 a8
	jnz  l0178h         ; 0174 96 78
	jmp  l0400h         ; 0176 84 00
l0178h:
	mov  a, r6          ; 0178 fe
	cpl  a              ; 0179 37
	jb2  l017eh         ; 017a 52 7e
	orl  p2, #001h      ; 017c 8a 01
l017eh:
	ret                 ; 017e 83
l017fh:
	inc  a              ; 017f 17
	jb6  l0183h         ; 0180 d2 83
	ret                 ; 0182 83
l0183h:
	mov  a, #039h       ; 0183 23 39
	ret                 ; 0185 83
l0186h:
	call l01a1h         ; 0186 34 a1
l0188h:
	mov  r0, #02ch      ; 0188 b8 2c
	xrl  a, @r0         ; 018a d0
	jz   l0199h         ; 018b c6 99
	call l01a1h         ; 018d 34 a1
	sel  rb1            ; 018f d5
	xch  a, r5          ; 0190 2d
	xrl  a, #080h       ; 0191 d3 80
	jmp  l0410h         ; 0193 84 10
l0195h:
	mov  @r0, a         ; 0195 a0
	add  a, #0aeh       ; 0196 03 ae
	jmpp @a             ; 0198 b3
l0199h:
	mov  a, r6          ; 0199 fe
	jb3  l019fh         ; 019a 72 9f
	sel  rb1            ; 019c d5
	mov  a, r5          ; 019d fd
	movx @r0, a         ; 019e 90
l019fh:
	sel  rb0            ; 019f c5
	ret                 ; 01a0 83
l01a1h:
	in   a, p2          ; 01a1 0a
	swap a              ; 01a2 47
	anl  a, #001h       ; 01a3 53 01
	jni  l01a9h         ; 01a5 86 a9
	orl  a, #004h       ; 01a7 43 04
l01a9h:
	jnt1 l01adh         ; 01a9 46 ad
	orl  a, #002h       ; 01ab 43 02
l01adh:
	ret                 ; 01ad 83
	mov  r2, #0c3h      ; 01ae ba c3
	sel  rb1            ; 01b0 d5
	jnc  l01edh         ; 01b1 e6 ed
	sel  mb1            ; 01b3 f5
	jf0  l01b8h         ; 01b4 b6 b8
	jmp  l0206h         ; 01b6 44 06
l01b8h:
	jmp  l020eh         ; 01b8 44 0e
l01bah:
	sel  rb1            ; 01ba d5
	mov  a, r5          ; 01bb fd
	movx @r0, a         ; 01bc 90
	sel  rb0            ; 01bd c5
	mov  a, r6          ; 01be fe
	anl  a, #0f7h       ; 01bf 53 f7
	mov  r6, a          ; 01c1 ae
	ret                 ; 01c2 83
	sel  rb1            ; 01c3 d5
	mov  a, r6          ; 01c4 fe
	mov  r1, a          ; 01c5 a9
	mov  a, @r1         ; 01c6 f1
	anl  a, #00fh       ; 01c7 53 0f
l01c9h:
	mov  r4, a          ; 01c9 ac
l01cah:
	mov  a, r5          ; 01ca fd
	anl  a, #0f0h       ; 01cb 53 f0
	orl  a, r4          ; 01cd 4c
	movx @r0, a         ; 01ce 90
	sel  rb0            ; 01cf c5
	mov  a, r6          ; 01d0 fe
	orl  a, #008h       ; 01d1 43 08
	mov  r6, a          ; 01d3 ae
	ret                 ; 01d4 83
	call l0109h         ; 01d5 34 09
	anl  a, #0f0h       ; 01d7 53 f0
	swap a              ; 01d9 47
	mov  r4, a          ; 01da ac
	mov  a, r7          ; 01db ff
	jnz  l01cah         ; 01dc 96 ca
	mov  a, r5          ; 01de fd
	anl  a, #09fh       ; 01df 53 9f
	mov  r5, a          ; 01e1 ad
	anl  p2, #0feh      ; 01e2 9a fe
	jmp  l01cah         ; 01e4 24 ca
	mov  a, r6          ; 01e6 fe
	xrl  a, #004h       ; 01e7 d3 04
	mov  r6, a          ; 01e9 ae
	jmp  l0430h         ; 01ea 84 30
	nop                 ; 01ec 00
l01edh:
	mov  a, r6          ; 01ed fe
	call l0220h         ; 01ee 54 20
	mov  a, r6          ; 01f0 fe
	anl  a, #001h       ; 01f1 53 01
	jmp  l03fch         ; 01f3 64 fc
	anl  p2, #0fdh      ; 01f5 9a fd
	mov  r0, #02dh      ; 01f7 b8 2d
	mov  @r0, #0b8h     ; 01f9 b0 b8
	inc  r0             ; 01fb 18
	mov  @r0, #00bh     ; 01fc b0 0b
	mov  a, r6          ; 01fe fe
	nop                 ; 01ff 00
	nop                 ; 0200 00
	orl  a, #010h       ; 0201 43 10
	mov  r6, a          ; 0203 ae
	jmp  l01bah         ; 0204 24 ba
l0206h:
	mov  a, r6          ; 0206 fe
	orl  a, #080h       ; 0207 43 80
	mov  r6, a          ; 0209 ae
	jmp  l042ah         ; 020a 84 2a
	nop                 ; 020c 00
	nop                 ; 020d 00
l020eh:
	mov  a, r5          ; 020e fd
	call l0216h         ; 020f 54 16
	mov  a, r5          ; 0211 fd
	anl  a, #001h       ; 0212 53 01
	jmp  l03fch         ; 0214 64 fc
l0216h:
	xrl  a, #001h       ; 0216 d3 01
	mov  r5, a          ; 0218 ad
	anl  a, #001h       ; 0219 53 01
	inc  a              ; 021b 17
	rr   a              ; 021c 77
	rr   a              ; 021d 77
	jmp  l00e5h         ; 021e 04 e5
l0220h:
	xrl  a, #001h       ; 0220 d3 01
	mov  r6, a          ; 0222 ae
	anl  a, #001h       ; 0223 53 01
	inc  a              ; 0225 17
	swap a              ; 0226 47
	jmp  l00e5h         ; 0227 04 e5
l0229h:
	mov  r7, a          ; 0229 af
	mov  a, r5          ; 022a fd
	mov  r1, #004h      ; 022b b9 04
	jb5  l023bh         ; 022d b2 3b
l022fh:
	jb7  l0236h         ; 022f f2 36
	jb3  l0236h         ; 0231 72 36
	jb2  l0239h         ; 0233 52 39
l0234h: equ  00234h         ; probably bad target
	dec  r1             ; 0235 c9
l0236h:
	jb2  l023ah         ; 0236 52 3a
	dec  r1             ; 0238 c9
l0239h:
	dec  r1             ; 0239 c9
l023ah:
	dec  r1             ; 023a c9
l023bh:
	mov  a, r1          ; 023b f9
	ret                 ; 023c 83
l023dh:
	sel  rb1            ; 023d d5
	mov  r2, a          ; 023e aa
	jtf  l0241h         ; 023f 16 41
l0241h:
	mov  a, t           ; 0241 42
	add  a, #0f8h       ; 0242 03 f8
	jb7  l0248h         ; 0244 f2 48
	mov  a, #0ffh       ; 0246 23 ff
l0248h:
	mov  t, a           ; 0248 62
	mov  a, r0          ; 0249 f8
	mov  r4, a          ; 024a ac
	sel  rb0            ; 024b c5
	mov  a, r6          ; 024c fe
	sel  rb1            ; 024d d5
	jb4  l0252h         ; 024e 92 52
	jmp  l02cah         ; 0250 44 ca
l0252h:
	mov  r0, #02dh      ; 0252 b8 2d
	mov  a, @r0         ; 0254 f0
	dec  a              ; 0255 07
	mov  @r0, a         ; 0256 a0
	jnz  l0286h         ; 0257 96 86
	inc  r0             ; 0259 18
	mov  a, @r0         ; 025a f0
	dec  a              ; 025b 07
	mov  @r0, a         ; 025c a0
	jnz  l0286h         ; 025d 96 86
	mov  a, r5          ; 025f fd
	anl  a, #0f0h       ; 0260 53 f0
	orl  a, #00eh       ; 0262 43 0e
	mov  r0, a          ; 0264 a8
	sel  rb0            ; 0265 c5
	xch  a, r6          ; 0266 2e
	jb3  l0274h         ; 0267 72 74
	xch  a, r6          ; 0269 2e
	movx @r0, a         ; 026a 90
	call l01a1h         ; 026b 34 a1
	call l01a1h         ; 026d 34 a1
	xrl  a, #005h       ; 026f d3 05
	jz   l027eh         ; 0271 c6 7e
l0273h:
	mov  a, r6          ; 0273 fe
l0274h:
	anl  a, #0cfh       ; 0274 53 cf
	mov  r6, a          ; 0276 ae
	orl  p2, #002h      ; 0277 8a 02
	sel  rb1            ; 0279 d5
	mov  a, r0          ; 027a f8
	mov  r5, a          ; 027b ad
	jmp  l02cah         ; 027c 44 ca
l027eh:
	sel  rb1            ; 027e d5
	mov  r1, #02ch      ; 027f b9 2c
	mov  a, @r1         ; 0281 f1
	xrl  a, #005h       ; 0282 d3 05
	jz   l0273h         ; 0284 c6 73
l0286h:
	mov  r0, #02fh      ; 0286 b8 2f
	jmp  l02fah         ; 0288 44 fa
l028ah:
	mov  @r0, a         ; 028a a0
	sel  rb0            ; 028b c5
	jt0  l029ch         ; 028c 36 9c
	mov  a, r6          ; 028e fe
	anl  a, #0dfh       ; 028f 53 df
	mov  r6, a          ; 0291 ae
	sel  rb1            ; 0292 d5
	mov  a, @r0         ; 0293 f0
	jnz  l02cah         ; 0294 96 ca
	anl  p2, #0f7h      ; 0296 9a f7
	orl  p2, #008h      ; 0298 8a 08
	jmp  l02cah         ; 029a 44 ca
l029ch:
	anl  p2, #0fbh      ; 029c 9a fb
	nop                 ; 029e 00
	orl  p2, #004h      ; 029f 8a 04
	mov  a, r6          ; 02a1 fe
	jb5  l02cah         ; 02a2 b2 ca
	orl  a, #020h       ; 02a4 43 20
	mov  r6, a          ; 02a6 ae
	sel  rb1            ; 02a7 d5
	mov  a, @r0         ; 02a8 f0
	jb7  l02b1h         ; 02a9 f2 b1
	mov  a, r5          ; 02ab fd
	orl  a, #00fh       ; 02ac 43 0f
	mov  r5, a          ; 02ae ad
	jmp  l02c3h         ; 02af 44 c3
l02b1h:
	mov  a, r5          ; 02b1 fd
	anl  a, #00fh       ; 02b2 53 0f
	xrl  a, #00eh       ; 02b4 d3 0e
	jz   l02c1h         ; 02b6 c6 c1
	dec  a              ; 02b8 07
	jnz  l02c0h         ; 02b9 96 c0
	mov  a, r5          ; 02bb fd
	anl  a, #0f0h       ; 02bc 53 f0
	mov  r5, a          ; 02be ad
	dec  r5             ; 02bf cd
l02c0h:
	inc  r5             ; 02c0 1d
l02c1h:
	mov  @r0, #011h     ; 02c1 b0 11
l02c3h:
	sel  rb0            ; 02c3 c5
	mov  a, r6          ; 02c4 fe
	jb3  l02cah         ; 02c5 72 ca
	sel  rb1            ; 02c7 d5
	mov  a, r5          ; 02c8 fd
	movx @r0, a         ; 02c9 90
l02cah:
	sel  rb1            ; 02ca d5
	mov  a, r4          ; 02cb fc
	mov  r0, a          ; 02cc a8
	mov  r1, #038h      ; 02cd b9 38
	mov  a, @r1         ; 02cf f1
	dec  a              ; 02d0 07
	mov  @r1, a         ; 02d1 a1
	jnz  l02edh         ; 02d2 96 ed
	mov  @r1, #00ah     ; 02d4 b1 0a
	clr  a              ; 02d6 27
	cpl  a              ; 02d7 37
	call l00ffh         ; 02d8 14 ff
	mov  a, r3          ; 02da fb
	jz   l02edh         ; 02db c6 ed
	djnz r3, l02edh     ; 02dd eb ed
	inc  r3             ; 02df 1b
	mov  a, r7          ; 02e0 ff
	jnz  l02edh         ; 02e1 96 ed
	mov  a, r5          ; 02e3 fd
	orl  a, #010h       ; 02e4 43 10
	mov  r5, a          ; 02e6 ad
	mov  r3, #009h      ; 02e7 bb 09
	mov  a, #0ffh       ; 02e9 23 ff
	call l015ah         ; 02eb 34 5a
l02edh:
	sel  rb1            ; 02ed d5
	mov  a, r2          ; 02ee fa
	jmp  l03edh         ; 02ef 64 ed
	retr                ; 02f1 93
l02f2h:
	jmp  l03f4h         ; 02f2 64 f4
	en   tcnti          ; 02f4 25
	ret                 ; 02f5 83
l02f6h:
	call l023dh         ; 02f6 54 3d
	en   tcnti          ; 02f8 25
	ret                 ; 02f9 83
l02fah:
	mov  a, @r0         ; 02fa f0
	jb7  l02feh         ; 02fb f2 fe
	dec  a              ; 02fd 07
l02feh:
	jmp  l028ah         ; 02fe 44 8a
l0300h:
	nop                 ; 0300 00
	inc  r3             ; 0301 1b
	inc  r0             ; 0302 18
	xch  a, r0          ; 0303 28
	en   tcnti          ; 0304 25
l0305h:
	nop                 ; 0305 00
	inc  r6             ; 0306 1e
l0307h:
	nop                 ; 0307 00
	outl bus, a         ; 0308 02
	inc  r1             ; 0309 19
	db   022h           ; 030a 22 00100010 '"'
	jtf  l0324h         ; 030b 16 24
	inc  r4             ; 030d 1c
	xch  a, r2          ; 030e 2a
	nop                 ; 030f 00
	inc  r5             ; 0310 1d
	inc  r2             ; 0311 1a
	inc  a              ; 0312 17
	clr  a              ; 0313 27
	xch  a, r1          ; 0314 29
	xch  a, @r0         ; 0315 20
	db   001h           ; 0316 01 00000001 '.'
	jnt0 l0307h         ; 0317 26 07
	jnt1 l0342h         ; 0319 46 42
	jmp  l0234h         ; 031b 44 34
	movd a, p4          ; 031d 0c
l031eh:
	xchd a, @r0         ; 031e 30
	anl  a, @r1         ; 031f 51
	db   006h           ; 0320 06 00000110 '.'
	movd p4, a          ; 0321 3c
	db   038h           ; 0322 38 00111000 '8'
	orl  a, #02fh       ; 0323 43 2f
l0324h: equ  00324h         ; probably bad target
	swap a              ; 0325 47
	dis  tcnti          ; 0326 35
	addc a, #004h       ; 0327 13 04
	orl  a, r0          ; 0329 48
	movd a, p7          ; 032a 0f
l032bh:
	nop                 ; 032b 00
	xch  a, r5          ; 032c 2d
	movd a, p6          ; 032d 0e
	cpl  a              ; 032e 37
	nop                 ; 032f 00
	movd a, p5          ; 0330 0d
	nop                 ; 0331 00
	orl  a, r6          ; 0332 4e
	inc  @r1            ; 0333 11
	jt0  l0305h         ; 0334 36 05
	xch  a, r6          ; 0336 2e
l0337h:
	call l004bh         ; 0337 14 4b
l0338h: equ  00338h         ; probably bad target
	movd p5, a          ; 0339 3d
	movd p6, a          ; 033a 3e
	outl p2, a          ; 033b 3a
	jb1  l0350h         ; 033c 32 50
	in   a, p1          ; 033e 09
	orl  a, r5          ; 033f 4d
l0340h:
	db   00bh           ; 0340 0b 00001011 '.'
	orl  a, r1          ; 0341 49
l0342h:
	orl  a, @r1         ; 0342 41
	orl  a, r2          ; 0343 4a
	xchd a, @r1         ; 0344 31
	orl  a, @r0         ; 0345 40
	ins  a, bus         ; 0346 08
	strt cnt            ; 0347 45
	orl  a, r4          ; 0348 4c
	db   03bh           ; 0349 3b 00111011 ';'
	outl p1, a          ; 034a 39
	orl  a, r7          ; 034b 4f
	db   033h           ; 034c 33 00110011 '3'
	movd p7, a          ; 034d 3f
	in   a, p2          ; 034e 0a
	mov  a, #01fh       ; 034f 23 1f
l0350h: equ  00350h         ; probably bad target
	inc  @r0            ; 0351 10
	xch  a, @r1         ; 0352 21
	jb0  l032bh         ; 0353 12 2b
	add  a, #02ch       ; 0355 03 2c
	dis  i              ; 0357 15
	add  a, @r1         ; 0358 61
	orl  a, @r1         ; 0359 41
	db   001h           ; 035a 01 00000001 '.'
	db   001h           ; 035b 01 00000001 '.'
	db   0c1h           ; 035c c1 11000001 '.'
	xrl  a, r3          ; 035d db
l035eh:
	djnz r2, l03dbh     ; 035e ea db
	djnz r2, l039bh     ; 0360 ea 9b
	addc a, r7          ; 0362 7f
	inc  r3             ; 0363 1b
	in   a, p1          ; 0364 09
	movd a, p5          ; 0365 0d
	xch  a, @r0         ; 0366 20
	xch  a, r5          ; 0367 2d
	xch  a, r4          ; 0368 2c
	xchd a, @r0         ; 0369 30
	xch  a, r6          ; 036a 2e
	movd a, p5          ; 036b 0d
	xchd a, @r1         ; 036c 31
	jmp  l04b1h         ; 036d 84 b1
	movx @r1, a         ; 036f 91
	mov  a, r2          ; 0370 fa
	jb1  l038ah         ; 0371 32 8a
	jb5  l0392h         ; 0373 b2 92
	mov  a, r3          ; 0375 fb
	db   033h           ; 0376 33 00110011 '3'
	ret                 ; 0377 83
	jmpp @a             ; 0378 b3
	retr                ; 0379 93
	mov  a, r4          ; 037a fc
	call l0188h         ; 037b 34 88
	call l0594h         ; 037d b4 94
	mov  a, r5          ; 037f fd
	dis  tcnti          ; 0380 35
	db   085h           ; 0381 85 10000101 '.'
	cpl  f1             ; 0382 b5
	cpl  f0             ; 0383 95
	mov  r2, #036h      ; 0384 ba 36
	jni  l03b6h         ; 0386 86 b6
	jnz  l03bbh         ; 0388 96 bb
l038ah:
	cpl  a              ; 038a 37
	db   087h           ; 038b 87 10000111 '.'
	db   0b7h           ; 038c b7 10110111 '.'
	db   097h           ; 038d 97 10010111 '.'
	mov  r4, #038h      ; 038e bc 38
	db   082h           ; 0390 82 10000010 '.'
	mov  r0, #098h      ; 0391 b8 98
l0392h: equ  00392h         ; probably bad target
	mov  r5, #039h      ; 0393 bd 39
	orl  p1, #0b9h      ; 0395 89 b9
	anl  p1, #0beh      ; 0397 99 be
	addc a, r4          ; 0399 7c
	add  a, @r0         ; 039a 60
l039bh:
	addc a, r4          ; 039b 7c
	add  a, @r0         ; 039c 60
	addc a, r6          ; 039d 7e
	anl  a, r4          ; 039e 5c
	addc a, r6          ; 039f 7e
	inc  r4             ; 03a0 1c
	xchd a, @r1         ; 03a1 31
	xch  a, @r1         ; 03a2 21
	xchd a, @r1         ; 03a3 31
	xch  a, @r1         ; 03a4 21
	jb1  l0340h         ; 03a5 32 40
	jb1  l0300h         ; 03a7 32 00
	db   033h           ; 03a9 33 00110011 '3'
	mov  a, #033h       ; 03aa 23 33
	mov  a, #034h       ; 03ac 23 34
	jmp  l0134h         ; 03ae 24 34
	jmp  l0135h         ; 03b0 24 35
	en   tcnti          ; 03b2 25
	dis  tcnti          ; 03b3 35
	en   tcnti          ; 03b4 25
	jt0  l035eh         ; 03b5 36 5e
l03b6h: equ  003b6h         ; probably bad target
	jt0  l031eh         ; 03b7 36 1e
	cpl  a              ; 03b9 37
	jnt0 l0337h         ; 03ba 26 37
l03bbh: equ  003bbh         ; probably bad target
	jnt0 l0338h         ; 03bc 26 38
	xch  a, r2          ; 03be 2a
	db   038h           ; 03bf 38 00111000 '8'
	xch  a, r2          ; 03c0 2a
	outl p1, a          ; 03c1 39
	xch  a, r0          ; 03c2 28
	outl p1, a          ; 03c3 39
	xch  a, r0          ; 03c4 28
	xchd a, @r0         ; 03c5 30
	xch  a, r1          ; 03c6 29
	xchd a, @r0         ; 03c7 30
	xch  a, r1          ; 03c8 29
	xch  a, r5          ; 03c9 2d
	anl  a, r7          ; 03ca 5f
	xch  a, r5          ; 03cb 2d
	inc  r7             ; 03cc 1f
	movd p5, a          ; 03cd 3d
	xch  a, r3          ; 03ce 2b
	movd p5, a          ; 03cf 3d
	xch  a, r3          ; 03d0 2b
	anl  a, r3          ; 03d1 5b
	addc a, r3          ; 03d2 7b
	inc  r3             ; 03d3 1b
	addc a, r3          ; 03d4 7b
	anl  a, r5          ; 03d5 5d
	addc a, r5          ; 03d6 7d
	inc  r5             ; 03d7 1d
	addc a, r5          ; 03d8 7d
	db   03bh           ; 03d9 3b 00111011 ';'
	outl p2, a          ; 03da 3a
l03dbh:
	db   03bh           ; 03db 3b 00111011 ';'
	outl p2, a          ; 03dc 3a
	clr  a              ; 03dd 27
	db   022h           ; 03de 22 00100010 '"'
	clr  a              ; 03df 27
	db   022h           ; 03e0 22 00100010 '"'
	xch  a, r4          ; 03e1 2c
	movd p4, a          ; 03e2 3c
	xch  a, r4          ; 03e3 2c
	movd p4, a          ; 03e4 3c
	xch  a, r6          ; 03e5 2e
	movd p6, a          ; 03e6 3e
	xch  a, r6          ; 03e7 2e
	movd p6, a          ; 03e8 3e
	xch  a, r7          ; 03e9 2f
	movd p7, a          ; 03ea 3f
	xch  a, r7          ; 03eb 2f
	movd p7, a          ; 03ec 3f
l03edh:
	stop tcnt           ; 03ed 65
	strt t              ; 03ee 55
	jtf  l03f2h         ; 03ef 16 f2
	retr                ; 03f1 93
l03f2h:
	jmp  l023dh         ; 03f2 44 3d
l03f4h:
	stop tcnt           ; 03f4 65
	strt t              ; 03f5 55
	jtf  l03fah         ; 03f6 16 fa
	en   tcnti          ; 03f8 25
	ret                 ; 03f9 83
l03fah:
	jmp  l02f6h         ; 03fa 44 f6
l03fch:
	sel  rb1            ; 03fc d5
	jmp  l01c9h         ; 03fd 24 c9
	orl  a, r7          ; 03ff 4f
l0400h:
	mov  a, r6          ; 0400 fe
	jb6  l0405h         ; 0401 d2 05
	anl  p2, #0bfh      ; 0403 9a bf
l0405h:
	jmp  l0178h         ; 0405 24 78
	ds   9, 0ffh        ; 0407 ff ...
l0410h:
	xch  a, r5          ; 0410 2d
	sel  rb0            ; 0411 c5
	xch  a, r6          ; 0412 2e
	jb7  l0417h         ; 0413 f2 17
	xch  a, r6          ; 0415 2e
	jmp  l0195h         ; 0416 24 95
l0417h: equ  00417h         ; probably bad target
	anl  a, #07fh       ; 0418 53 7f
	xch  a, r6          ; 041a 2e
	mov  @r0, a         ; 041b a0
	xrl  a, #007h       ; 041c d3 07
	jz   l0422h         ; 041e c6 22
	jmp  l01bah         ; 0420 24 ba
l0422h:
	mov  a, r6          ; 0422 fe
	xrl  a, #040h       ; 0423 d3 40
	mov  r6, a          ; 0425 ae
	anl  a, #040h       ; 0426 53 40
	jz   l042ch         ; 0428 c6 2c
l042ah:
	mov  a, #001h       ; 042a 23 01
l042ch:
	jmp  l03fch         ; 042c 64 fc
	ds   2, 0ffh        ; 042e ff ...
l0430h:
	anl  a, #004h       ; 0430 53 04
	jnz  l042ah         ; 0432 96 2a
	anl  p2, #0feh      ; 0434 9a fe
	jmp  l03fch         ; 0436 64 fc
	ds   968, 0ffh      ; 0438 ff ...
l04b1h: equ  004b1h         ; probably bad target
l0594h: equ  00594h         ; probably bad target
	end                 ; 0800

