package MIDI::Monitor;

# ABSTRACT: Monitor live MIDI events

our $VERSION = '0.0100';

use Moo;
use strictures 2;
use Capture::Tiny qw(capture);
use Carp qw(croak);
use namespace::clean;

=head1 SYNOPSIS

  use MIDI::Monitor ();
  my $mm = MIDI::Monitor->new(
      port    => 20,
      verbose => 1,
  );
  my $ports = $mm->list;
  $mm->monitor;

=head1 DESCRIPTION

C<MIDI::Monitor> shows the MIDI data received on a MIDI port. It is
a simple wrapper around the C<receivemidi> program for Macs and
Windows machines, or the C<aseqdump> program for Linux.

=head1 ATTRIBUTES

=head2 os

  $os = $mm->os;

The current operating system.

=cut

has os => (
    is      => 'ro',
    default => sub { $^O },
);

=head2 program

  $program = $mm->program;

The external program to use for MIDI monitoring, given the operating system.

=cut

has program => (
    is => 'lazy',
);

sub _build_program {
    my ($self) = @_;
    my $program = 'receivemidi';
    if ($self->os eq 'linux') {
        $program = 'aseqdump';
    }
    return $program;
}

=head2 list_arg

  $list_arg = $mm->list_arg;

The program flag to show the known MIDI ports.

=cut

has list_arg => (
    is => 'lazy',
);

sub _build_list_arg {
    my ($self) = @_;
    my $list_arg = 'list';
    if ($self->os eq 'linux') {
        $list_arg = '--list';
    }
    return $list_arg;
}

=head2 event_arg

  $event_arg = $mm->event_arg;

The program flag to show the live data of a triggered MIDI port.

=cut

has event_arg => (
    is => 'lazy',
);

sub _build_event_arg {
    my ($self) = @_;
    my $event_arg = 'dev';
    if ($self->os eq 'linux') {
        $event_arg = '--port';
    }
    return $event_arg;
}

=head2 port

  $port = $mm->port;

The selected MIDI port from the list of known port names and numbers.

=cut

has port => (
    is => 'ro',
);

=head2 event_cmd

  $event_cmd = $mm->event_cmd;

The shell command to execute to get MIDI events.

=cut

has event_cmd => (
    is => 'lazy',
);

sub _build_event_cmd {
    my ($self) = @_;
    return [ $self->program, $self->event_arg, "'" . $self->port . "'" ];
}

=head2 verbose

  $verbose = $mm->verbose;

Show progress.

=cut

has verbose => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a boolean" unless $_[0] =~ /^[01]$/ },
    default => sub { 0 },
);

=head1 METHODS

=head2 new

  $mm = MIDI::Monitor->new(%args);

Create a new C<MIDI::Monitor> object.

=head2 list

  $list = $mm->list;

List the known MIDI ports.

=cut

sub list {
    my ($self) = @_;
    my @cmd = ($self->program, $self->list_arg);
    my ($stdout, $stderr, $exit) = capture {
        system(@cmd);
    };
    print $stdout if $self->verbose;
    my @lines = split /\n/, $stdout;
    shift @lines if $self->os eq 'linux';
    my @parts = map { [ split /\s{2,}/, $_ ] } @lines;
    @parts    = map { [ grep { $_ } @$_ ] } @parts;
    for my $part (@parts) {
        for (@$part) {
            s/^\s*//;
            s/\s*$//;
        }
    }
    return \@parts;
}

=head2 monitor

  $mm->monitor;

Monitor the data on a MIDI port.

=cut

sub monitor {
    my ($self) = @_;
    my $cmd = join ' ', $self->event_cmd->@*;
    open my $fh, '-|', $cmd or die $!;
    while (my $line = readline($fh)) {
        print $line if $self->verbose;
        # TODO something cool
    }
}

=head1 SEE ALSO

L<Moo>

L<https://github.com/gbevin/ReceiveMIDI>

L<https://man.archlinux.org/man/extra/alsa-utils/aseqdump.1.en>

=cut

1;
__END__

> receivemidi list
IAC Driver IAC Bus 1
MPD218 Port A
USB MIDI Interface

> receivemidi dev "MPD218 Port A"
channel 10   note-on           C1   7
channel 10   note-off          C1   0
channel 10   note-on           C1  46
channel 10   note-off          C1   0
channel 10   note-on           C1 122
channel 10   note-off          C1   0
channel 10   note-on           C1 127
channel 10   note-off          C1   0
channel 10   note-on           C1  17
channel 10   note-off          C1   0
channel 10   note-on           C1  28
channel 10   note-off          C1   0
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5   127
channel  1   control-change     5     1
channel  1   control-change     5     1
channel  1   control-change     5     1
channel  1   control-change     5     1
channel  1   control-change     5     1
channel  1   control-change     6     1
channel  1   control-change     6     1
channel  1   control-change     6     1
channel  1   control-change     6     1
channel  1   control-change     6   127
channel  1   control-change     6   127
channel  1   control-change     6   127
channel  1   control-change     6   127
channel 10   note-on           E2  24
channel 10   note-off          E2   0
channel 10   note-on           F2  99
channel 10   note-off          F2   0
channel 10   note-on          G#3 109
channel 10   note-off         G#3   0
channel 10   note-on           A3 100
channel 10   note-off          A3   0
channel 10   note-on           C1   7
channel 10   note-off          C1   0
channel 10   note-on           C1  71
channel 10   note-off          C1   0
channel 10   note-on           C1  28
channel 10   note-off          C1   0
channel 10   note-on           C1  88
channel 10   note-off          C1   0
channel 10   note-on           C1   1
channel 10   note-off          C1   0
channel 10   note-on           C1 127
channel 10   note-off          C1   0
channel 10   note-on           E2 127
channel 10   note-off          E2   0
channel 10   note-on          G#3 127
channel 10   note-off         G#3   0

> aseqdump --list
 Port    Client name                      Port name
  0:0    System                           Timer
  0:1    System                           Announce
 14:0    Midi Through                     Midi Through Port-0
 20:0    MPD218                           MPD218 Port A

> aseqdump --port 20
Source  Event                  Ch  Data
 20:0   Control change          0, controller 1, value 1
 20:0   Control change          0, controller 1, value 1
 20:0   Control change          0, controller 1, value 1
 20:0   Control change          0, controller 1, value 127
 20:0   Control change          0, controller 1, value 127
 20:0   Control change          0, controller 1, value 127
 20:0   Control change          0, controller 2, value 1
 20:0   Control change          0, controller 2, value 1
 20:0   Control change          0, controller 2, value 1
 20:0   Control change          0, controller 2, value 1
 20:0   Control change          0, controller 2, value 127
 20:0   Control change          0, controller 2, value 127
 20:0   Control change          0, controller 2, value 127
 20:0   Control change          0, controller 3, value 1
 20:0   Control change          0, controller 3, value 1
 20:0   Control change          0, controller 3, value 1
 20:0   Control change          0, controller 3, value 1
 20:0   Control change          0, controller 3, value 127
 20:0   Control change          0, controller 3, value 127
 20:0   Note on                 9, note 36, velocity 56
 20:0   Note off                9, note 36, velocity 0
 20:0   Note on                 9, note 37, velocity 67
 20:0   Note off                9, note 37, velocity 0
 20:0   Note on                 9, note 38, velocity 111
 20:0   Note off                9, note 38, velocity 0
 20:0   Note on                 9, note 39, velocity 117
 20:0   Note off                9, note 39, velocity 0

