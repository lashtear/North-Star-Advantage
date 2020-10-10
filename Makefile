# -*- GNUmakefile -*-

sources = bootrom.asm hello.asm rxmodem.asm
deps = $(sources:.asm=.dep)
bins = $(sources:.asm=.bin)
hexes = rxmodem.hex
targets = $(bins) $(hexes) Advantage\ Boot\ Font.png
extras = $(sources:.asm=.list) $(sources:.asm=.label)

all: $(targets) check

.PHONY: all clean check

.PRECIOUS: Advantage\ Boot\ Rom.bin Advantage\ 8035\ Rom.bin

Advantage\ 8035\ Rom.asm: Advantage\ 8035\ Rom.bin de8035.pl Makefile
	@echo '  DE8035  ' $@
	de8035.pl $< > $@

Advantage\ Boot\ Font.asm Advantage\ Boot\ Font.pbm: dump-font.pl Advantage\ Boot\ Rom.bin Makefile
	@echo ' DUMPFONT '
	@perl dump-font.pl

Advantage\ Boot\ Font.png: Advantage\ Boot\ Font.pbm
	@echo ' PNMTOPNG '
	@pnmtopng "$<" > "$@"

check:
	md5sum -c sums.txt

clean:
	@echo '  CLEAN   '
	rm -f -- $(wildcard $(targets) $(extras) $(deps))

%.bin : %.asm
	@echo '  ASM     ' $@
	@z80asm --list=$*.list --label=$*.label $< -o $@

%.hex : %.bin
	@echo -ne '  HEX     ' $@ ': '
	@perl format-for-monitor.pl $< > $@

%.dep : %.asm
	@echo '  DEP     ' $@
	@perl asmdeps.pl $< > $@

$(deps) : asmdeps.pl
$(hexes) : format-for-monitor.pl
$(targets) $(deps): Makefile

ifneq ($(MAKECMDGOALS),clean)
-include $(deps)
endif
