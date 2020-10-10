#! /usr/bin/perl

use warnings;
use strict;

my %files = map {$_=>1} @ARGV;
my %nextfiles;
my %done;

sub safe {
    local $_ = shift;
    s/([^+-9@-z])/\\$1/g;
    return $_;
}

while (scalar keys %files or scalar keys %nextfiles) {
    while (my ($name) = each %nextfiles) {
        if (not exists $done{$name}) {
            $files{$name} = 1;
        }
        delete $nextfiles{$name};
    }
    while (my ($name) = each %files) {
        open (my $file, '<', $name) or die "$name: open: $!\n";
        my $dfilename = $name;
        $dfilename =~ s/\.asm$/.dep/i;
        my @deps;
        while (<$file>) {
            if ((my ($cmd, $q, $depname) 
                 = (/^inc(lude|bin)\s+(["'])(.+)\2\s*$/))) {
                print safe($name), ' ', safe($dfilename), ': ',
                  safe($depname), "\n";
                if ($cmd eq 'lude') {
                    $nextfiles{$depname} = 1;
                }
            }
            $done{$name} = 1;
            delete $files{$name};
        }
        close ($file);
    }
}
