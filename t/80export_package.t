#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 12;

use Symbol::Util 'export_package', 'unexport_package';

{
    package Symbol::Util::Test80::Source1;
    no warnings 'once';
    sub FOO { "FOO" };
    our $FOO = "FOO";
    sub BAR { "BAR" };
    our $BAZ = "BAZ";
    our @BAZ = ("BAZ");
    our %BAZ = (BAZ => 1);
    open BAZ, __FILE__ or die $!;
};

no warnings 'once';

export_package("Symbol::Util::Test80::Target1", "Symbol::Util::Test80::Source1", {
    EXPORT => [ "FOO", "BAR" ],
});
pass( 'export_package("Symbol::Util::Test80::Target1", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target1::FOO(), 'FOO', 'Symbol::Util::Test80::Target1::FOO() is ok [1]' );
is( Symbol::Util::Test80::Target1->FOO, 'FOO', 'Symbol::Util::Test80::Target1->FOO is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target1::FOO, '$Symbol::Util::Test80::Target1::FOO is ok [1]' );
is( Symbol::Util::Test80::Target1::BAR(), 'BAR', 'Symbol::Util::Test80::Target1::BAR() is ok [1]' );
is( Symbol::Util::Test80::Target1->BAR, 'BAR', 'Symbol::Util::Test80::Target1->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target1::BAZ, '$Symbol::Util::Test80::Target1::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target1", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target1", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target1::FOO(), 'FOO', 'Symbol::Util::Test80::Target1::FOO() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target1->FOO }, 'Symbol::Util::Test80::Target1->FOO is ok [2]' );
ok( ! defined $Symbol::Util::Test80::Target1::FOO, '$Symbol::Util::Test80::Target1::FOO is ok [2]' );
is( Symbol::Util::Test80::Target1::BAR(), 'BAR', 'Symbol::Util::Test80::Target1::BAR() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target1->BAR }, 'Symbol::Util::Test80::Target1->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target1::BAZ, '$Symbol::Util::Test80::Target1::BAZ is ok [2]' );

export_package("Symbol::Util::Test80::Target2", "Symbol::Util::Test80::Source1", {
    EXPORT => [ "FOO", "BAR" ],
}, 'FOO');
pass( 'export_package("Symbol::Util::Test80::Target2", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target2::FOO(), 'FOO', 'Symbol::Util::Test80::Target2::FOO() is ok [1]' );
is( Symbol::Util::Test80::Target2->FOO, 'FOO', 'Symbol::Util::Test80::Target2->FOO is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target2::FOO, '$Symbol::Util::Test80::Target2::FOO is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target2::BAR() }, 'Symbol::Util::Test80::Target2::BAR() is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target2->BAR }, 'Symbol::Util::Test80::Target2->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target2::BAZ, '$Symbol::Util::Test80::Target2::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target2", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target2", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target2::FOO(), 'FOO', 'Symbol::Util::Test80::Target2::FOO() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target2->FOO }, 'Symbol::Util::Test80::Target2->FOO is ok [2]' );
ok( ! defined $Symbol::Util::Test80::Target2::FOO, '$Symbol::Util::Test80::Target2::FOO is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target2::BAR() }, 'Symbol::Util::Test80::Target2::BAR() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target2->BAR }, 'Symbol::Util::Test80::Target2->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target2::BAZ, '$Symbol::Util::Test80::Target2::BAZ is ok [2]' );
