#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 3;

use Symbol::Util 'list_glob_slots';

{
    package Symbol::Util::Test60;
    no warnings 'once';
    open FOO, __FILE__ or die $!;
    *FOO = sub { "code" };
    our $FOO = "scalar";
    our @FOO = ("array");
    our %FOO = ("hash" => 1);
};

is_deeply( [ sort( list_glob_slots("Symbol::Util::Test60::FOO") ) ], [ qw( ARRAY CODE HASH IO SCALAR ) ], 'list_glob_slots("Symbol::Util::Test60::FOO")' );

{
    package Symbol::Util::Test60;
    no warnings 'once';
    *BAR = sub { "code" };
};

is_deeply( [ sort( list_glob_slots("Symbol::Util::Test60::BAR") ) ], [ qw( CODE ) ], 'list_glob_slots("Symbol::Util::Test60::BAR")' );

is_deeply( [ sort( list_glob_slots("Symbol::Util::Test60::BAZ") ) ], [ qw( ) ], 'list_glob_slots("Symbol::Util::Test60::BAZ")' );