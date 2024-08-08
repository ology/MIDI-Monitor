#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use_ok 'MIDI::Monitor';

subtest defaults => sub {
    my $mm = new_ok 'MIDI::Monitor';
    ok !$mm->verbose, 'verbose';
    ok $mm->os, 'os';
    ok $mm->program, 'program';
    ok $mm->list_arg, 'list_arg';
    ok $mm->event_arg, 'event_arg';
    ok !$mm->port, 'port';
};

done_testing();
