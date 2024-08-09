#!/usr/bin/env perl
use strict;
use warnings;

use MIDI::Monitor ();
my $mm = MIDI::Monitor->new(
    # port    => 20,
    verbose => 1,
);
# $mm->list;
$mm->select_port;
warn __PACKAGE__,' L',__LINE__,' ',$mm->port,"\n";
# print $mm->monitor;
