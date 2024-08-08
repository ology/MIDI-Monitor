#!/usr/bin/env perl
use strict;
use warnings;

use MIDI::Monitor ();
my $mm = MIDI::Monitor->new(
    port    => 20,
    # verbose => 1,
);
$mm->list;
# print join(', ', $mm->event_cmd->@*), "\n";exit;
# print $mm->monitor;
