package Device::BlinkyTape::WS2811;
use strict;
use Moose;
use utf8;

extends 'Device::BlinkyTape';

=head1 NAME

Device::BlinkyTape:WS2811 - Control a WS2811-based BlinkyTape

=head1 SYNOPSIS

    use Device::BlinkyTape::WS2811;
    my $bb = Device::BlinkyTape::WS2811->new(dev => '/dev/tty.usbmodem');

See Device::BlinkyTape for documentation.

=cut

sub send_pixel {
    my $self = shift;
    my ($r, $g, $b) = (shift, shift, shift);
    $r = 254 if ($r == 255); # The 255 means end of led line and applies the colors. Drop that value by one. Blinkyboard.py does this.
    $g = 254 if ($g == 255);
    $b = 254 if ($b == 255);
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

=head1 AUTHOR

Oskari Okko Ojala E<lt>okko@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Oskari Okko Ojala 2013

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl you may have available.

=cut
