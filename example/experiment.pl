#!/usr/bin/env perl
use lib '../lib';
use Device::BlinkyTape::WS2811; # BlinkyTape uses WS2811
use Time::HiRes (usleep);

my $bb = Device::BlinkyTape::WS2811->new(dev => '/dev/tty.usbmodem1411');

for (my $b=0; $b<=100000; $b++) {
    for (my $a=0; $a<=59; $a++) {
        $bb->send_pixel(int(rand(254)),int(rand(254)),int(rand(254)));
    }
    $bb->show(); # shows the sent pixel row. One should be enough, six works longer? :)
    $bb->show(); # shows the sent pixel row
    $bb->show(); # shows the sent pixel row
    $bb->show(); # shows the sent pixel row
    $bb->show(); # shows the sent pixel row
    $bb->show(); # shows the sent pixel row
    usleep(100000);
    print "$b\n";
}
sleep 2;
