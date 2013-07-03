requires 'Device::SerialPort';
requires 'ExtUtils::MakeMaker';
requires 'Moose';
requires 'Moose::Util::TypeConstraints';

feature 'simulation', 'Simulation of a BlinkyTape with Tk' => sub {
    requires 'Tk';
};
