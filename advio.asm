;;; North Star Advantage io include file

;see table 3-6 on page 3-9
ldioctl:equ     0f8h           ; same as 0f0h, a0-a3 ignored
rdst1:  equ     0e0h
rdst2:  equ     0d0h

ionorm: equ     018h

;see table 3-4 on page 3-6
memparity:equ   060h

;see table 3-2 on page 3-4 and 3-3 on 3-5
memmap0:equ     0a0h
memmap1:equ     0a1h
memmap2:equ     0a2h
memmap3:equ     0a3h

;see 3-12 on 3-26
ldstsc: equ     090h          ; load start scan reg
clrdsf: equ     0b0h          ; clear display flag

;see 3-15 on 3-31,3-32
flpdata:equ     080h          ; floppy data
flpctl: equ     081h          ; sync input / drive control
flpdskrd:equ    082h          ; clear/set disk read flag
flpwrt: equ     083h          ; floppy write flag (write)
flpbeep:equ     083h          ; beep (same addr)

;see 3-20 on 3-52
idslt3: equ     073h          ; read slot 3 ID byte

;see 3-24 on 3-57
siodata:equ     030h          ; slot 3 serial io data
sioctl: equ     031h          ; slot 3 serial io control
siobaud:equ     038h          ; slot 3 serial io baud rate select
sioim:  equ     03ah          ; slot 3 serial io interrupt mask
                                ;   (not used in rom)

;see B-8
clearnmi:equ     0c0h          ; clear nmi state

;rom POI
romcout:equ    087fdh
romfont:equ    08561h


