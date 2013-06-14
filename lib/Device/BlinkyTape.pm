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
use Moose::Util::TypeConstraints;
use utf8;

extends 'Plack::Middleware';

subtype 'GammaInt',
    as 'Int',
    where { $_ >= 0 and $_ <= 255 },
    message { "Gamma number ($_) must be between 0..255" }
;

has 'dev' => (is => 'rw', isa => 'String', default => '/dev/tty.usbmodem');
has 'port' => (is => 'rw', isa => 'Device::SerialPort');
has 'gamma' => (is => 'rw', isa => 'ArrayRef[GammaInt]', default => sub { [1,1,1] });

has 'led_count' => (is => 'rw', isa => 'Int', default => 60);

sub BUILD {
    my $self = shift;
    # Initialize $self->port from $self->dev if one was not given in new
    $self->port(Device::SerialPort->new($self->dev)) if (!$self->port);
    
    # Set default communication settings
    $self->port->baudrate(19200);
    $self->port->databits(8);
    $self->port->parity('none');
    $self->port->stopbits(1);

    $self->lookclear; # empty buffers
}

sub all_on {
    my $self = shift;
    for (my $a=0; $a<=$self->led_count; $a++) {
        $self->send_pixel(255,255,255);
    }
}

sub all_off {
    my $self = shift;
    for (my $a=0; $a<=$self->led_count; $a++) {
        $self->send_pixel(0,0,0);
    }
}

1;

=head1 Usage

use Device::BlinkyTape::WS2811; # BlinkyTape uses WS2811
my $bb = Device::BlinkyTape->new(dev => '/dev/tty.usbmodem');
$bb->all_on();
$bb->all_off();
$bb->send_pixel(255,255,255);
$b->send_pixel(5,5,5);

=head1 Reference reading
 * Communicating with the Arduino in Perl http://playground.arduino.cc/interfacing/PERL
 * Perl communication to Arduino over serial USB http://www.windmeadow.com/node/38

=head1 LICENCE

TODO

=head1 Copyright

TODO

=head1 AUTHORS

Based on https://github.com/blinkiverse/BlinkyTape/blob/db5311ac7498bae624be4b1b7deaadc2a291341c/examples/Blinkyboard.py by 
Max Henstell (mhenstell) and Marty McGuire (martymcguire).

=cut
