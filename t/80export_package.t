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
    *BAZ = sub { "BAZ" };
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

export_package("Symbol::Util::Test80::Target3", "Symbol::Util::Test80::Source1", {
    EXPORT => [ "FOO", "BAR" ],
}, '!BAR');
pass( 'export_package("Symbol::Util::Test80::Target3", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target3::FOO(), 'FOO', 'Symbol::Util::Test80::Target3::FOO() is ok [1]' );
is( Symbol::Util::Test80::Target3->FOO, 'FOO', 'Symbol::Util::Test80::Target3->FOO is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target3::FOO, '$Symbol::Util::Test80::Target3::FOO is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target3::BAR() }, 'Symbol::Util::Test80::Target3::BAR() is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target3->BAR }, 'Symbol::Util::Test80::Target3->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target3::BAZ, '$Symbol::Util::Test80::Target3::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target3", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target3", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target3::FOO(), 'FOO', 'Symbol::Util::Test80::Target3::FOO() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target3->FOO }, 'Symbol::Util::Test80::Target3->FOO is ok [2]' );
ok( ! defined $Symbol::Util::Test80::Target3::FOO, '$Symbol::Util::Test80::Target3::FOO is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target3::BAR() }, 'Symbol::Util::Test80::Target3::BAR() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target3->BAR }, 'Symbol::Util::Test80::Target3->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target3::BAZ, '$Symbol::Util::Test80::Target3::BAZ is ok [2]' );

export_package("Symbol::Util::Test80::Target4", "Symbol::Util::Test80::Source1", {
    EXPORT => [ "FOO", "BAR" ],
}, '/FOO/');
pass( 'export_package("Symbol::Util::Test80::Target4", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target4::FOO(), 'FOO', 'Symbol::Util::Test80::Target4::FOO() is ok [1]' );
is( Symbol::Util::Test80::Target4->FOO, 'FOO', 'Symbol::Util::Test80::Target4->FOO is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target4::FOO, '$Symbol::Util::Test80::Target4::FOO is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target4::BAR() }, 'Symbol::Util::Test80::Target4::BAR() is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target4->BAR }, 'Symbol::Util::Test80::Target4->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target4::BAZ, '$Symbol::Util::Test80::Target4::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target4", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target4", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target4::FOO(), 'FOO', 'Symbol::Util::Test80::Target4::FOO() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target4->FOO }, 'Symbol::Util::Test80::Target4->FOO is ok [2]' );
ok( ! defined $Symbol::Util::Test80::Target4::FOO, '$Symbol::Util::Test80::Target4::FOO is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target4::BAR() }, 'Symbol::Util::Test80::Target4::BAR() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target4->BAR }, 'Symbol::Util::Test80::Target4->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target4::BAZ, '$Symbol::Util::Test80::Target4::BAZ is ok [2]' );

export_package("Symbol::Util::Test80::Target5", "Symbol::Util::Test80::Source1", {
    EXPORT => [ "FOO", "BAR" ],
}, '!/BAR/');
pass( 'export_package("Symbol::Util::Test80::Target5", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target5::FOO(), 'FOO', 'Symbol::Util::Test80::Target5::FOO() is ok [1]' );
is( Symbol::Util::Test80::Target5->FOO, 'FOO', 'Symbol::Util::Test80::Target5->FOO is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target5::FOO, '$Symbol::Util::Test80::Target5::FOO is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target5::BAR() }, 'Symbol::Util::Test80::Target5::BAR() is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target5->BAR }, 'Symbol::Util::Test80::Target5->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target5::BAZ, '$Symbol::Util::Test80::Target5::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target5", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target5", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target5::FOO(), 'FOO', 'Symbol::Util::Test80::Target5::FOO() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target5->FOO }, 'Symbol::Util::Test80::Target5->FOO is ok [2]' );
ok( ! defined $Symbol::Util::Test80::Target5::FOO, '$Symbol::Util::Test80::Target5::FOO is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target5::BAR() }, 'Symbol::Util::Test80::Target5::BAR() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target5->BAR }, 'Symbol::Util::Test80::Target5->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target5::BAZ, '$Symbol::Util::Test80::Target5::BAZ is ok [2]' );

export_package("Symbol::Util::Test80::Target6", "Symbol::Util::Test80::Source1", {
    OK => [ "FOO" ],
    TAGS => { T => [ "FOO" ] },
}, ':T');
pass( 'export_package("Symbol::Util::Test80::Target6", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target6::FOO(), 'FOO', 'Symbol::Util::Test80::Target6::FOO() is ok [1]' );
is( Symbol::Util::Test80::Target6->FOO, 'FOO', 'Symbol::Util::Test80::Target6->FOO is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target6::FOO, '$Symbol::Util::Test80::Target6::FOO is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target6::BAR() }, 'Symbol::Util::Test80::Target6::BAR() is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target6->BAR }, 'Symbol::Util::Test80::Target6->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target6::BAZ, '$Symbol::Util::Test80::Target6::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target6", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target6", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target6::FOO(), 'FOO', 'Symbol::Util::Test80::Target6::FOO() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target6->FOO }, 'Symbol::Util::Test80::Target6->FOO is ok [2]' );
ok( ! defined $Symbol::Util::Test80::Target6::FOO, '$Symbol::Util::Test80::Target6::FOO is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target6::BAR() }, 'Symbol::Util::Test80::Target6::BAR() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target6->BAR }, 'Symbol::Util::Test80::Target6->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target6::BAZ, '$Symbol::Util::Test80::Target6::BAZ is ok [2]' );

export_package("Symbol::Util::Test80::Target7", "Symbol::Util::Test80::Source1", {
    EXPORT => [ "FOO", "BAR" ],
    TAGS => { T => [ "BAR" ] },
}, '!:T');
pass( 'export_package("Symbol::Util::Test80::Target7", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target7::FOO(), 'FOO', 'Symbol::Util::Test80::Target7::FOO() is ok [1]' );
is( Symbol::Util::Test80::Target7->FOO, 'FOO', 'Symbol::Util::Test80::Target7->FOO is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target7::FOO, '$Symbol::Util::Test80::Target7::FOO is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target7::BAR() }, 'Symbol::Util::Test80::Target7::BAR() is ok [1]' );
ok( ! defined eval { Symbol::Util::Test80::Target7->BAR }, 'Symbol::Util::Test80::Target7->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target7::BAZ, '$Symbol::Util::Test80::Target7::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target7", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target7", "Symbol::Util::Test80::Source1")' );

is( Symbol::Util::Test80::Target7::FOO(), 'FOO', 'Symbol::Util::Test80::Target7::FOO() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target7->FOO }, 'Symbol::Util::Test80::Target7->FOO is ok [2]' );
ok( ! defined $Symbol::Util::Test80::Target7::FOO, '$Symbol::Util::Test80::Target7::FOO is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target7::BAR() }, 'Symbol::Util::Test80::Target7::BAR() is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target7->BAR }, 'Symbol::Util::Test80::Target7->BAR is ok [1]' );
ok( ! defined $Symbol::Util::Test80::Target7::BAZ, '$Symbol::Util::Test80::Target7::BAZ is ok [2]' );

export_package("Symbol::Util::Test80::Target8", "Symbol::Util::Test80::Source1", {
    OK => [ '$BAZ', '&BAZ' ],
}, '$BAZ', '&BAZ');
pass( 'export_package("Symbol::Util::Test80::Target8", "Symbol::Util::Test80::Source1")' );

is( $Symbol::Util::Test80::Target8::BAZ, 'BAZ', '$Symbol::Util::Test80::Target8::BAZ is ok [1]' );
is( eval { Symbol::Util::Test80::Target8->BAZ }, 'BAZ', 'Symbol::Util::Test80::Target8->BAZ is ok [1]' );
is( eval { &Symbol::Util::Test80::Target8::BAZ }, 'BAZ', '&Symbol::Util::Test80::Target8::BAZ is ok [1]' );

unexport_package("Symbol::Util::Test80::Target8", "Symbol::Util::Test80::Source1");
pass( 'unexport_package("Symbol::Util::Test80::Target8", "Symbol::Util::Test80::Source1")' );

ok( ! defined $Symbol::Util::Test80::Target8::BAZ, '$Symbol::Util::Test80::Target8::BAZ is ok [2]' );
ok( ! defined eval { &Symbol::Util::Test80::Target8::BAZ }, '&Symbol::Util::Test80::Target8::BAZ is ok [2]' );
ok( ! defined eval { Symbol::Util::Test80::Target8->BAZ }, 'Symbol::Util::Test80::Target8->BAZ is ok [2]' );


# exported element have to be in EXPORT or EXPORT_OK
eval {
    export_package("Symbol::Util::Test80::Target0", "Symbol::Util::Test80::Source1", {
        EXPORT => [ "FOO" ],
    }, 'BAR');
};
like( $@, qr/^BAR is not exported/, 'export_package("Symbol::Util::Test80::Target0", "Symbol::Util::Test80::Source1")' );

# EXPORT_TAGS element have to be also in EXPORT or EXPORT_OK
eval {
    export_package("Symbol::Util::Test80::Target0", "Symbol::Util::Test80::Source1", {
        TAGS => { T => [ "FOO" ] },
    }, ':T');
};
like( $@, qr/^FOO is not exported/, 'export_package("Symbol::Util::Test80::Target0", "Symbol::Util::Test80::Source1")' );