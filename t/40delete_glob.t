#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 1;

use Symbol::Util 'delete_glob';

{
    package Symbol::Util::Test40;
    select select FOO;
    format FOO =
.
    sub FOO { "function" };
    our $FOO = "scalar";
    our @FOO = ("array");
    our %FOO = ("hash" => 1);
};

foreach my $slot (qw{ SCALAR ARRAY HASH CODE IO FORMAT }) {
    ok( defined *{Symbol::Util::Test40::FOO}{$slot}, "defined *{Symbol::Util::Test40::FOO}{$slot}" );
};

ok( defined delete_glob("Symbol::Util::Test40::FOO", "SCALAR"), 'delete_glob("Symbol::Util::Test40::FOO", "SCALAR")' );
foreach my $slot (qw{ SCALAR ARRAY HASH CODE IO FORMAT }) {
    ok( defined *{Symbol::Util::Test40::FOO}{$slot}, "defined *{Symbol::Util::Test40::FOO}{$slot}" );
};

ok( defined delete_glob("Symbol::Util::Test40::FOO", "ARRAY"), 'delete_glob("Symbol::Util::Test40::FOO", "ARRAY")' );
foreach my $slot (qw{ SCALAR ARRAY HASH CODE IO FORMAT }) {
    ok( defined *{Symbol::Util::Test40::FOO}{$slot}, "defined *{Symbol::Util::Test40::FOO}{$slot}" );
};
