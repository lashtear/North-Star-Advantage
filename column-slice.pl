#! /usr/bin/perl

# quick tool for RLE compression of image bitmaps
# great on line drawings, terrible on dithered pictures

# transposes 8bit columns up to match nsAdv vram

use strict;
use warnings;

sub slurp {
    my $filename = shift;
    open (my $file, '<', $filename) or die "open: $filename: $!\n";
    binmode $file;
    local $/;
    my $data = <$file>;
    close $file;
    $data
}

my $data = slurp (shift @ARGV);
my $rows = int(length ($data) / 80);
binmode STDOUT;
for my $col (0..79) {
    my $colbits = '';
    for my $row (0..$rows-1) {
        my $bits = substr $data, $row*80+$col, 1;
        $colbits .= $bits;
    }
    $colbits =~ s[((.)(\2*))][pack('CC',length($1),ord($2))]gesm;
    print $colbits;
}
