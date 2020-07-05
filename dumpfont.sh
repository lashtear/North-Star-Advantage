#! /bin/sh

od -t x1 -w1 -Ax -v -j 0x561 -N 665 "Advantage Boot Rom.BIN" \
    |perl ./munge-font.pl \
          > "Advantage Boot Font.asm"

