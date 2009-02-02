#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 1;

use Symbol::Util;

{
    package Symbol::Util::Test30;
    sub function { "function" };
    our $scalar = "scalar";
};

Test::More::is_deeply( [ sort keys %{Symbol::Util::stash("Symbol::Util::Test30")} ], [ qw{ function scalar } ], 'stash("Symbol::Util::Test30")' );
