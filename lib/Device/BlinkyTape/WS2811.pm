package Device::BlinkyTape::WS2811;
use strict;
use Moose;
use utf8;

extends 'Device::BlinkyTape';

sub sendPixel {
    my $self = shift;
    my ($r, $g, $b) = shift, shift, shift;
    $r = 254 if ($r = 255); # I have no idea what I'm doing but Blinkyboard.py does this
    $g = 254 if ($g = 255);
    $b = 254 if ($b = 255);
    $self->port->write(chr($r).chr($g).chr($b));
}

sub show {
    my $self = shift;
    $self->port->write(chr(255));
}

sub gamma {
    my $self = shift;
    my $input = shift;
    my $tweak = shift;
    return $input if not $self->gamma;
    return int(($input/256 ** $tweak) * 256);
}

1;
