package Device::BlinkyTape;
use strict;
BEGIN {
    $Device::BlinkyTape::AUTHORITY = 'cpan:okko';
}
BEGIN {
    $Device::BlinkyTape::VERSION = '0.001';
}
use Moose;
use Device::SerialPort;
use Device::BlinkyTape::SimulationPort;
use Moose::Util::TypeConstraints;
use utf8;

subtype 'GammaInt',
    as 'Int',
    where { $_ >= 0 and $_ <= 255 },
    message { "Gamma number ($_) must be between 0..255" }
;

subtype 'DeviceSerialPort',
    as 'Device::SerialPort'
;

subtype 'SimulationPort',
    as 'Device::BlinkyTape::SimulationPort'
;

has 'dev' => (is => 'rw', isa => 'Str', default => '/dev/tty.usbmodem');
has 'port' => (is => 'rw', isa => 'DeviceSerialPort | SimulationPort');
has 'gamma' => (is => 'rw', isa => 'ArrayRef[GammaInt]', default => sub { [1,1,1] });

has 'led_count' => (is => 'rw', isa => 'Int', default => 60);

has 'simulate' => (is => 'rw', isa => 'Bool', default => 0);

sub BUILD {
    my $self = shift;
    # Initialize $self->port from $self->dev if one was not given in new
    if ($self->simulate) {
        $self->port(Device::BlinkyTape::SimulationPort->new(led_count => $self->led_count));
        warn 'simulation on.';
    }
    $self->port(Device::SerialPort->new($self->dev)) if (!$self->port);
    
    if ($self->port) {
        # Set default communication settings
        $self->port->baudrate(19200);
        $self->port->databits(8);
        $self->port->parity('none');
        $self->port->stopbits(1);
    }

    # $self->lookclear; # empty buffers
}

sub all_on {
    my $self = shift;
    for (my $a=0; $a<=$self->led_count-1; $a++) {
        $self->send_pixel(255,255,255);
    }
    $self->show();
}

sub all_off {
    my $self = shift;
    for (my $a=0; $a<=$self->led_count-1; $a++) {
        $self->send_pixel(0,0,0);
    }
    $self->show();
}

1;

=head1 Usage

use Device::BlinkyTape::WS2811; # BlinkyTape uses WS2811
my $bb = Device::BlinkyTape::WS2811->new(dev => '/dev/tty.usbmodem');
$bb->all_on();
$bb->all_off();
$bb->send_pixel(255,255,255);
$bb->send_pixel(5,5,5);
$bb->show(); # shows the sent pixel row

=head1 Usage on OS X without a BlinkyTape

Install X11 server from http://xquartz.macosforge.org/landing/

=head1 Reference reading
 * Communicating with the Arduino in Perl http://playground.arduino.cc/interfacing/PERL
 * Perl communication to Arduino over serial USB http://www.windmeadow.com/node/38

=head1 AUTHOR

Oskari Okko Ojala E<lt>okko@cpan.orgE<gt>

Based on https://github.com/blinkiverse/BlinkyTape/blob/db5311ac7498bae624be4b1b7deaadc2a291341c/examples/Blinkyboard.py by 
Max Henstell (mhenstell) and Marty McGuire (martymcguire).

=head1 COPYRIGHT AND LICENSE

Copyright (C) Oskari Okko Ojala 2013

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl you may have available.

=cut
