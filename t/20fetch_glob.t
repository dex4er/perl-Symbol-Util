#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 6;

use Symbol::Util;

{
    package Symbol::Util::Test20;
    sub function { "function" };
    our $scalar = "scalar";
};

Test::More::is( *{Symbol::Util::fetch_glob("Symbol::Util::Test20::function")}, '*Symbol::Util::Test20::function', 'fetch_glob("Symbol::Util::Test20::function") is *Symbol::Util::Test20::function' );
Test::More::is( *{Symbol::Util::fetch_glob("Symbol::Util::Test20::scalar")}, '*Symbol::Util::Test20::scalar', 'fetch_glob("Symbol::Util::Test20::scalar") is *Symbol::Util::Test20::scalar' );

Test::More::is( *{Symbol::Util::fetch_glob("function")}, '*main::function', 'fetch_glob("function") is *main::function' );
Test::More::is( *{Symbol::Util::fetch_glob("scalar")}, '*main::scalar', 'fetch_glob("scalar") is *main::scalar' );

{
    package Symbol::Util::Test20;
    Test::More::is( *{Symbol::Util::fetch_glob("function")}, '*Symbol::Util::Test20::function', 'fetch_glob("function") is *Symbol::Util::Test20::function' );
    Test::More::is( *{Symbol::Util::fetch_glob("scalar")}, '*Symbol::Util::Test20::scalar', 'fetch_glob("scalar") is *Symbol::Util::Test20::scalar' );
};
