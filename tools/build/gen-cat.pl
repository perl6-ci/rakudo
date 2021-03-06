#!/usr/bin/perl
# Copyright (C) 2008-2011, The Perl Foundation.

use strict;
use warnings;
use 5.008;

binmode STDOUT, ':utf8';

my ($backend, @files) = @ARGV;

print <<"END_HEAD";
# This file automatically generated by $0

END_HEAD

foreach my $file (@files) {
    print "# From $file\n\n";
    open(my $fh, "<:utf8",  $file) or die "$file: $!";
    my $in_cond = 0;
    my $in_omit = 0;
    while (<$fh>) {
        if (/^#\?if\s+(!)?\s*(\w+)\s*$/) {
            die "Nested conditionals not supported" if $in_cond;
            $in_cond = 1;
            $in_omit = $1 && $2 eq $backend || !$1 && $2 ne $backend;
        }
        elsif (/^#\?endif\s*$/) {
            $in_cond = 0;
            $in_omit = 0;
        }
        elsif (!$in_omit) {
            print unless m/^# vim:/;;
        }
    }
    close $fh;
}

print "\n# vim: set ft=perl6 nomodifiable :\n";
