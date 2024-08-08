#!/usr/bin/env perl
use strict;
use warnings;

use MIDI::Monitor ();
my $mm = MIDI::Monitor->new(
    port    => 20,
    verbose => 1,
);
# print $mm->list;exit;
print $mm->monitor;
