#! /usr/bin/perl

use strict;
use warnings;

sub get_data {
    open my $f, '<', 'Advantage Boot Rom.bin' or die "open: boot rom: $!\n";
    binmode $f;
    local $/;
    seek $f, 0x561, 0;
    my $data;
    my $result = read $f, $data, 95*7;
    if (not defined $result) {
        die "read: $!\n";
    } elsif ($result < 95*7) {
        die "incomplete read\n";
    }
    close $f;
    return $data;
}

sub emit_asm_char {
    my ($out, $index, $data) = @_;
    my $chardata = substr $data, 7*$index, 7;
    my $char = 32+$index;
    my $safe_char = chr($char);
    $safe_char =~ s{([^ -~]|['"\\])}{\\$1}gsm;
    $safe_char = "'$safe_char'";
    my $first = substr $chardata, 0, 1;
    my $flaginfo = "";
    my $val = ord $first;
    if (($val & 0xc0) == 0x80) {
        $flaginfo = " descender1";
    } elsif (($val & 0xc0) == 0xc0) {
        $flaginfo = " descender2";
    }
    printf $out "char_%02x:                        ; %4s%s\n",
      $char, $safe_char, $flaginfo;
    my $offset = 0x8561 + 7*$index;
    for (unpack "C7", $chardata) {
        printf $out "        db %08bb            ;%04x %02x\n",
          $_, $offset++, $_;
    }
    print $out "\n";
}

sub emit_bitmap {
    my ($out, $data) = @_;
    binmode $out;
    printf $out "P4 %d %d\n", 16*8, 6*9;
    my @bm;
    for my $char (0..94) {
        my $chardata = substr $data, 7*$char, 7;
        my $first = ord substr $chardata, 0, 1;
        my $y_offset = 0 + (($first & 0x80) > 0) + (($first & 0x40) > 0);
#        printf "%08b %d\n", $first, $y_offset;
        my $char_offset = $char % 16 + 16*9*($char >> 4);
        $char_offset += 16 * $y_offset;;
        $bm[$char_offset] = $first & 0x3f;
        for (unpack "C6", substr $chardata, 1) {
            $char_offset += 16;
            $bm[$char_offset] = $_;
        }
    }
    @bm = map {$_ ||= 0} @bm;
    print $out pack ("C864", @bm);
}

my $data = get_data();
open my $out, '>', 'Advantage Boot Font.asm'
  or die "open: output: $!\n";
for (0..94) {
    emit_asm_char($out, $_, $data);
}
close $out;
open my $pbm, '>', 'Advantage Boot Font.pbm'
  or die "open: pbm: $!\n";
emit_bitmap ($pbm, $data);
close $pbm;
