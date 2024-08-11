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
    ok !$mm->port, 'port';
};

subtest port => sub {
    my $mm = new_ok 'MIDI::Monitor' => [ port => 42 ];
    ok $mm->port, 'port';
    isa_ok $mm->event_cmd, 'ARRAY', 'event_cmd';
};

done_testing();
