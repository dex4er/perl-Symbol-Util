#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 1;

use Symbol::Util 'export_glob';

{
    package Symbol::Util::Test70;
    no warnings 'once';
    sub function { "function" };
    our $scalar = "scalar";
};

{
    my $ref = export_glob("Symbol::Util::Test70::Target", "Symbol::Util::Test70::function");
    is( ref $ref eq 'GLOB' ? *$ref : $ref, '*Symbol::Util::Test70::Target::function', 'export_glob("Symbol::Util::Test70::function") is *Symbol::Util::Test70::function' );
};
