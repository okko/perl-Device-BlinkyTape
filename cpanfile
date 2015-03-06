if ($^O eq 'MSWin32') {
   requires 'Win32::SerialPort';
} else {
   requires 'Device::SerialPort';
}

requires 'ExtUtils::MakeMaker';
requires 'Moose';
requires 'Moose::Util::TypeConstraints';
requires 'Time::HiRes';

feature 'simulation', 'Simulation of a BlinkyTape with Tk' => sub {
    requires 'Tk';
};
