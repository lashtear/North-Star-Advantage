#! /usr/bin/perl

use strict;
use warnings;

sub get_data {
    open my $f, '<', 'Advantage Boot Rom.BIN' or die "open: boot rom: $!\n";
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

my $data = get_data();
open my $out, '>', 'Advantage Boot Font.asm'
  or die "open: output: $!\n";
for (0..94) {
    emit_asm_char($out, $_, $data);
}
close $out;

