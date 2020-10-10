#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

sub read_rom {
    my ($filename) = @_;
    defined $filename
      or die "Please specify filename\n";
    open(my $fh, '<', $filename)
      or die "open: $filename: $!\n";
    binmode($fh);
    local $/;
    my $data = <$fh>;
    close($fh);
    $data
}

my %simple_insn =
  (qw(
         00000000 nop
         00000010 outl_bus._a
         00000011 add_a._!=
         00000101 en_i
         00000111 dec_a
         00001000 ins_a._bus
         00001001 in_a._p1
         00001010 in_a._p2
         00001100 movd_a._p4
         00001101 movd_a._p5
         00001110 movd_a._p6
         00001111 movd_a._p7
         00010000 inc_@r0
         00010001 inc_@r1
         00010010 jb0_=
         00010011 addc_a._!=
         00010101 dis_i
         00010110 jtf_=
         00010111 inc_a
         00011000 inc_r0
         00011001 inc_r1
         00011010 inc_r2
         00011011 inc_r3
         00011100 inc_r4
         00011101 inc_r5
         00011110 inc_r6
         00011111 inc_r7
         00100000 xch_a._@r0
         00100001 xch_a._@r1
         00100011 mov_a._!=
         00100101 en_tcnti
         00100110 jnt0_=
         00100111 clr_a
         00101000 xch_a._r0
         00101001 xch_a._r1
         00101010 xch_a._r2
         00101011 xch_a._r3
         00101100 xch_a._r4
         00101101 xch_a._r5
         00101110 xch_a._r6
         00101111 xch_a._r7
         00110000 xchd_a._@r0
         00110001 xchd_a._@r1
         00110010 jb1_=
         00110101 dis_tcnti
         00110110 jt0_=
         00110111 cpl_a
         00111001 outl_p1._a
         00111010 outl_p2._a
         00111100 movd_p4._a
         00111101 movd_p5._a
         00111110 movd_p6._a
         00111111 movd_p7._a
         01000000 orl_a._@r0
         01000001 orl_a._@r1
         01000010 mov_a._t
         01000011 orl_a._!=
         01000101 strt_cnt
         01000110 jnt1_=
         01000111 swap_a
         01001000 orl_a._r0
         01001001 orl_a._r1
         01001010 orl_a._r2
         01001011 orl_a._r3
         01001100 orl_a._r4
         01001101 orl_a._r5
         01001110 orl_a._r6
         01001111 orl_a._r7
         01010000 anl_a._@r0
         01010001 anl_a._@r1
         01010010 jb2_=
         01010011 anl_a._!=
         01010101 strt_t
         01010110 jt1_=
         01010111 da_a
         01011000 anl_a._r0
         01011001 anl_a._r1
         01011010 anl_a._r2
         01011011 anl_a._r3
         01011100 anl_a._r4
         01011101 anl_a._r5
         01011110 anl_a._r6
         01011111 anl_a._r7
         01100000 add_a._@r0
         01100001 add_a._@r1
         01100010 mov_t._a
         01100101 stop_tcnt
         01100111 rrc_a
         01101000 add_a._r0
         01101001 add_a._r1
         01101010 add_a._r2
         01101011 add_a._r3
         01101100 add_a._r4
         01101101 add_a._r5
         01101110 add_a._r6
         01101111 add_a._r7
         01110000 addc_a._@r0
         01110001 addc_a._@r1
         01110010 jb3_=
         01110101 ent0_clk
         01110110 jf1_=
         01110111 rr_a
         01111000 addc_a._r0
         01111001 addc_a._r1
         01111010 addc_a._r2
         01111011 addc_a._r3
         01111100 addc_a._r4
         01111101 addc_a._r5
         01111110 addc_a._r6
         01111111 addc_a._r7
         10000000 movx_a._@r0
         10000001 movx_a._@r1
         10000011 ret
         10000110 jni_=
         10001000 orl_bus._!=
         10001001 orl_p1._!=
         10001010 orl_p2._!=
         10001100 orld_p4._a
         10001101 orld_p5._a
         10001110 orld_p6._a
         10001111 orld_p7._a
         10010000 movx_@r0._a
         10010001 movx_@r1._a
         10010010 jb4_=
         10010011 retr
         10010101 cpl_f0
         10010110 jnz_=
         10011000 anl_bus._!=
         10011001 anl_p1._!=
         10011010 anl_p2._!=
         10011100 anld_p4._a
         10011101 anld_p5._a
         10011110 anld_p6._a
         10011111 anld_p7._a
         10100000 mov_@r0._a
         10100001 mov_@r1._a
         10100011 movp_a._@a
         10101000 mov_r0._a
         10101001 mov_r1._a
         10101010 mov_r2._a
         10101011 mov_r3._a
         10101100 mov_r4._a
         10101101 mov_r5._a
         10101110 mov_r6._a
         10101111 mov_r7._a
         10110000 mov_@r0._!=
         10110001 mov_@r1._!=
         10110010 jb5_=
         10110011 jmpp_@a
         10110101 cpl_f1
         10110110 jf0_=
         10111000 mov_r0._!=
         10111001 mov_r1._!=
         10111010 mov_r2._!=
         10111011 mov_r3._!=
         10111100 mov_r4._!=
         10111101 mov_r5._!=
         10111110 mov_r6._!=
         10111111 mov_r7._!=
         11000101 sel_rb0
         11000110 jz_=
         11000111 mov_a._psw
         11001000 dec_r0
         11001001 dec_r1
         11001010 dec_r2
         11001011 dec_r3
         11001100 dec_r4
         11001101 dec_r5
         11001110 dec_r6
         11001111 dec_r7
         11010000 xrl_a._@r0
         11010001 xrl_a._@r1
         11010010 jb6_=
         11010011 xrl_a._!=
         11010101 sel_rb1
         11010111 mov_psw._a
         11011000 xrl_a._r0
         11011001 xrl_a._r1
         11011010 xrl_a._r2
         11011011 xrl_a._r3
         11011100 xrl_a._r4
         11011101 xrl_a._r5
         11011110 xrl_a._r6
         11011111 xrl_a._r7
         11100011 movp3_a._@a
         11100101 sel_mb0
         11100110 jnc_=
         11100111 rl_a
         11101000 djnz_r0._=
         11101001 djnz_r1._=
         11101010 djnz_r2._=
         11101011 djnz_r3._=
         11101100 djnz_r4._=
         11101101 djnz_r5._=
         11101110 djnz_r6._=
         11101111 djnz_r7._=
         11110000 mov_a._@r0
         11110001 mov_a._@r1
         11110010 jb7_=
         11110101 sel_mb1
         11110110 jc_=
         11110111 rlc_a
         11111000 mov_a._r0
         11111001 mov_a._r1
         11111010 mov_a._r2
         11111011 mov_a._r3
         11111100 mov_a._r4
         11111101 mov_a._r5
         11111110 mov_a._r6
         11111111 mov_a._r7


    ));

sub disassemble_insn {
    my ($rom, $addr, $out, $label, $reach) = @_;
    my $byte = substr $$rom, $$addr, 1;
    my $bits = unpack "B8", $byte;

    my $insn = sprintf("db 0%02xh", ord $byte);
    my $safebyte = $byte;
    $safebyte =~ s{[^ -~]}{.}g;
    my $comment = sprintf("; %04x %02x '%c'", $$addr, ord $byte, ord $safebyte);
    my $startaddr = $$addr;

    if ($bits eq '11111111') {
        my $remaining = substr($$rom, $$addr);
        $remaining =~ /^(\xff+)/;
        if (length($1) > 1) {
            $insn = sprintf("ds %d, 0%02xh", length $1, 255);
            $comment .= " ...";
            $$addr += length $1;
        } else {
            $insn = "mov a, r7";
            $reach->{$$addr}{$$addr+1} = 1;
            ++($$addr);
        }
    } elsif (exists $simple_insn{$bits}) {
        $insn = $simple_insn{$bits};
        $insn =~ tr/_.!/ ,#/;
        ++($$addr);
        if ($insn =~ /=/) {
            $byte = substr($$rom, $$addr, 1);
            if ($insn =~ /^(djnz|j)/) {
                my $targetaddr = ($$addr & 0x0700) | ord($byte);
                $label->{$targetaddr} ||= sprintf("l%04xh", $targetaddr);
                $insn =~ s{=}{$label->{$targetaddr}}eg;
                $reach->{$$addr-1}{$targetaddr} = 1;
            } else {
                die unless $insn =~ /#/; # assert that it's immediate
                $insn =~ s{=}{sprintf ("0%02xh", ord $byte)}eg;
            }
            ++($$addr);
            my $safebyte = $byte;
            $safebyte =~ s{[^ -~]}{.}g;
            $comment .= sprintf(" %02x '%c'", ord $byte, ord $safebyte);
            $reach->{$$addr-2}{$$addr} = 1;
            $reach->{$$addr-1}{$$addr} = 1;
        } else {
            $reach->{$$addr-1}{$$addr} = 1;
        }
    } elsif ($bits =~ /^(...)(.)0100$/) { 
        ++($$addr);
        $byte = substr $$rom, $$addr, 1;
        $bits = unpack ("B8", $byte);
        my $targetaddr = ord(pack("B8", "00000$1"))*256 + ord(pack("B8", $bits));
        my $target = sprintf("l%04xh", $targetaddr);
        $insn = sprintf ("%s %s", ($2 eq '1' ? 'call' : 'jmp'), $target);
        $label->{$targetaddr} ||= $target;
        my $safebyte = $byte;
        $safebyte =~ s{[^ -~]}{.}g;
        $comment .= sprintf(" %02x '%c'", ord $byte, ord $safebyte);
        ++($$addr);
        $reach->{$$addr-2}{$targetaddr} = 1;
        if ($insn =~ /^call/) {
            $reach->{$$addr-2}{$$addr} = 1;
        }
        $reach->{$$addr-1}{$$addr} = 1;
    } else {
#        my $safebyte = $byte;
#        $safebyte =~ s/[^!-~]/./;
#        $comment .= sprintf(" %8s '%c'", $bits, ord $safebyte);
        ++($$addr);
    }
    $insn =~ s/^(\w+)\s/$1 . ' 'x(5-length($1)) /e;
    push @{$out->{$startaddr}}, sprintf("        %-20s%s", $insn, $comment);
}

my $rom = read_rom(@ARGV);
my $addr = 0;
my %out;
my %label =
  (qw(
         0 resetvec
         3 intvec
         7 timervec
    ));
my %reach;

while ($addr < length($rom)) {
    disassemble_insn(\$rom, \$addr, \%out, \%label, \%reach);
}

my %reachable;
my @reachstack = (0, 3, 7);
while (scalar @reachstack) {
    my $addr = pop @reachstack;
    if (not $reachable{$addr}) {
        $reachable{$addr} = 1;
        push @reachstack, keys %{$reach{$addr}};
    }
}

for (sort {$a<=>$b} keys %label) {
    unshift @{$out{$_}}, "$label{$_}:";
    if (scalar @{$out{$_}} == 1) {
        $out{$_} = [sprintf ("%s: equ  0%04xh         ; bad target", $label{$_}, $_)];
    }
}
push @{$out{$addr}}, sprintf "        %-20s; %04x\n", 'end', $addr;

for (sort {$a<=>$b} keys %out) {
    for my $line (@{$out{$_}}) {
        if (not $reachable{$_}) {
            chomp $line;
            printf "%-50s ; unreachable\n", $line;
        } else {
            print "$line\n";
        }
    }
}
