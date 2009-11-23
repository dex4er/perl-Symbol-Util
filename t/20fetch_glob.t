#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 11;

use Symbol::Util;

{
    package Symbol::Util::Test20;
    no warnings 'once';
    sub function { "function" };
    our $scalar = "scalar";
};

is( *{Symbol::Util::fetch_glob("Symbol::Util::Test20::function")}, '*Symbol::Util::Test20::function', 'fetch_glob("Symbol::Util::Test20::function") is *Symbol::Util::Test20::function' );
is( ref Symbol::Util::fetch_glob("Symbol::Util::Test20::function", "CODE"), 'CODE', 'ref fetch_glob("Symbol::Util::Test20::function", "CODE") is CODE' );
ok( ! defined Symbol::Util::fetch_glob("Symbol::Util::Test20::function", "SCALAR"), 'not defined fetch_glob("Symbol::Util::Test20::function", "SCALAR")' );

is( *{Symbol::Util::fetch_glob("Symbol::Util::Test20::scalar")}, '*Symbol::Util::Test20::scalar', 'fetch_glob("Symbol::Util::Test20::scalar") is *Symbol::Util::Test20::scalar' );
is( ref Symbol::Util::fetch_glob("Symbol::Util::Test20::scalar", "SCALAR"), 'SCALAR', 'ref fetch_glob("Symbol::Util::Test20::scalar", "SCALAR") is SCALAR' );
ok( ! defined Symbol::Util::fetch_glob("Symbol::Util::Test20::scalar", "CODE"), 'not defined fetch_glob("Symbol::Util::Test20::scalar", "CODE")' );

is( *{Symbol::Util::fetch_glob("notexists")}, '*main::notexists', 'fetch_glob("notexists") is *main::notexists' );
ok( ! defined Symbol::Util::fetch_glob("notexists", "SCALAR"), 'not defined fetch_glob("notexists", "SCALAR")' );
ok( ! defined Symbol::Util::fetch_glob("notexists", "CODE"), 'not defined fetch_glob("notexists", "CODE")' );

{
    package Symbol::Util::Test20;
    Test::More::is( *{Symbol::Util::fetch_glob("function")}, '*Symbol::Util::Test20::function', 'fetch_glob("function") is *Symbol::Util::Test20::function' );
    Test::More::is( *{Symbol::Util::fetch_glob("scalar")}, '*Symbol::Util::Test20::scalar', 'fetch_glob("scalar") is *Symbol::Util::Test20::scalar' );
};
