#!/usr/bin/env perl
use strict;
use warnings;

use MIDI::Monitor ();

my $mm = MIDI::Monitor->new(
    verbose => 1,
);

$mm->select_port;
$mm->monitor;
