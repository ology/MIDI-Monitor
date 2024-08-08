#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use_ok 'MIDI::Monitor';

subtest defaults => sub {
    my $obj = new_ok 'MIDI::Monitor' => [
        verbose => 1,
    ];
    is $obj->verbose, 1, 'verbose';
    ok $obj->os, 'os';
    ok $obj->program, 'program';
    ok $obj->list_arg, 'list_arg';
    ok $obj->event_arg, 'event_arg';
    ok $obj->list, 'list';
    ok !$obj->port, 'port';
};

done_testing();
