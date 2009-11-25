#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 12;

use Symbol::Util 'export_glob';

sub deref_glob {
    return ref $_[0] eq 'GLOB' ? *{$_[0]} : $_[0];
};

{
    package Symbol::Util::Test70;
    no warnings 'once';
    sub FOO { "FOO" };
    our $FOO = "FOO";
};

no warnings 'once';

is( deref_glob(export_glob("Symbol::Util::Test70::Target1", "Symbol::Util::Test70::FOO")), '*Symbol::Util::Test70::Target1::FOO', 'export_glob("Symbol::Util::Test70::Target1", "Symbol::Util::Test70::FOO") is ok' );
is( Symbol::Util::Test70::Target1::FOO(), 'FOO', 'Symbol::Util::Test70::Target1::FOO() is ok' );
is( $Symbol::Util::Test70::Target1::FOO, 'FOO', '$Symbol::Util::Test70::Target1::FOO is ok' );

is( deref_glob(export_glob("Symbol::Util::Test70::Target2", "Symbol::Util::Test70::FOO", "CODE")), '*Symbol::Util::Test70::Target2::FOO', 'export_glob("Symbol::Util::Test70::Target2", "Symbol::Util::Test70::FOO", "SCALAR") is ok' );
is( Symbol::Util::Test70::Target2::FOO(), 'FOO', 'Symbol::Util::Test70::Target2::FOO() is ok' );
ok( ! defined $Symbol::Util::Test70::Target2::FOO, '$Symbol::Util::Test70::Target2::FOO is ok' );

is( deref_glob(export_glob("Symbol::Util::Test70::Target3", "Symbol::Util::Test70::FOO", "SCALAR")), '*Symbol::Util::Test70::Target3::FOO', 'export_glob("Symbol::Util::Test70::Target3", "Symbol::Util::Test70::FOO", "SCALAR") is ok' );
ok( ! defined eval { Symbol::Util::Test70::Target3::FOO() }, 'Symbol::Util::Test70::Target3::FOO() is ok' );
is( $Symbol::Util::Test70::Target3::FOO, 'FOO', '$Symbol::Util::Test70::Target3::FOO is ok' );

ok( ! defined deref_glob(export_glob("Symbol::Util::Test70::Target4", "Symbol::Util::Test70::BAR", "SCALAR")), 'export_glob("Symbol::Util::Test70::Target4", "Symbol::Util::Test70::BAR", "SCALAR") is ok' );
ok( ! defined eval { Symbol::Util::Test70::Target4::BAR() }, 'Symbol::Util::Test70::Target4::BAR() is ok' );
ok( ! defined $Symbol::Util::Test70::Target4::BAR, '$Symbol::Util::Test70::Target4::BAR is ok' );
