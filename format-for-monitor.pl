#! /usr/bin/perl

# Turns a binary file into a sequence of commands for controlling the
# nsAdv mini-monitor for entry.

# Assumes the first byte selects the high-byte of the load address,
# e.g. 0xC0 means load at 0xC000.  Entry point is always at +10 bytes,
# so 0xC00A in this case.  This matches the assumptions of the nsAdv
# bootrom for floppy boot sectors (track 0, sector 4-7) or synchronous
# serial boot.

# throw an SIO board in slot3, then from LOAD SYSTEM, type
# ctrl-C J 8 0 8 D ctrl-C D 0 2 F D 0 0
# see bootrom.asm for explanation

# configure serial port for 9600 8n2 (yes 2 stop bits), use a null
# modem adapter if connecting direct to pc or something.  Or change
# baud rate e.g. to 19200 via O 7 F 3 8 (out (038h), 07fh)

# Writes must be limited to C000-FFFF; the minimonitor is running and
# requires 0000-BFFF for video and rom.  By default, ram bank 0 is
# mapped at C000; this tool does not issue port writes to bank switch,
# so you are limited to 16K max.

# Minimon will still draw to the screen while being controlled from
# serial port, which remains embarrassingly slow.  There's no scroll
# enabled; it clears and starts from line 1 once you reach the bottom.
# This is because the monitor's work-ram is in VRAM, and scrolling
# would erase that.  So: per-character is slow (because it has to draw
# 6+ characters, ten lines high to the frame buffer) and per-line is
# terribly slow as it (fairly unpredictably) needs to wipe vram and
# start from the top.  So: use pacing along the lines of 1ms per char,
# 999ms per line.  Much faster, and it will overrun.  Minicom can do
# this easily enough, via ascii-xfr.

# e.g.
# $ stty -F /dev/ttyUSB0 9600 cs8 -parenb cstopb raw crtscts cread -clocal
# $ ascii-xfr -snv -l 999 -c 1 lw.hex >/dev/ttyUSB0

# Yes, this is slow.  Use it to load something better ;)

# Example output (and what it sends to the monitor) looks like

# DC000C000000000000000
# DC0080000C30DC0F3DD21
# DC010DCC031FEFFE5218B
# DC018C0CD42C0FD21F1C0
# ...
# JC00A

# with CR as the line-terminator.

use warnings;
use strict;

sub slurp {
    my $filename = shift;
    open (my $file, '<', $filename) or die "open: $filename: $!\n";
    binmode $file;
    local $/;
    my $data = <$file>;
    close $file;
    $data
}

my $width = 8;
my $data = slurp (shift @ARGV);
my $address = ord(substr($data,0,1)) << 8;
my $start = $address;
warn sprintf ("Generating minimon loading hex for %d bytes at load address %05xh\n",
             length $data, $address);
while (length $data > 0) {
    my $linebytes = substr($data,0,$width,'');
    $linebytes .= "\x00" while length ($linebytes) < $width;
    printf 'D%04X' . ('%02X' x $width) . "\r", $address,
      unpack("C$width",$linebytes);

    $address += 8;
}
printf "J%04X\r", $start+10;
