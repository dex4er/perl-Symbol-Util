#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 56;

use Symbol::Util 'delete_glob';

{
    package Symbol::Util::Test40;
    open FOO, __FILE__ or die $!;
    *FOO = sub { "code" };
    our $FOO = "scalar";
    our @FOO = ("array");
    our %FOO = ("hash" => 1);
};

foreach my $slot (qw{ SCALAR ARRAY HASH CODE IO }) {
    ok( defined *Symbol::Util::Test40::FOO{$slot}, "defined *Symbol::Util::Test40::FOO{$slot}" );
};
is( $Symbol::Util::Test40::FOO, "scalar", '$Symbol::Util::Test40::FOO is ok' );
is_deeply( \@Symbol::Util::Test40::FOO, ["array"], '@Symbol::Util::Test40::FOO is ok' );
is_deeply( \%Symbol::Util::Test40::FOO, {"hash"=>1}, '%Symbol::Util::Test40::FOO is ok' );
is( Symbol::Util::Test40::FOO(), 'code', 'Symbol::Util::Test40::FOO() is ok' );
ok( fileno Symbol::Util::Test40::FOO, '*Symbol::Util::Test40::FOO{IO} is ok' );

ok( defined delete_glob("Symbol::Util::Test40::FOO", "SCALAR"), 'delete_glob("Symbol::Util::Test40::FOO", "SCALAR")' );
ok( ! defined $Symbol::Util::Test40::FOO, '$Symbol::Util::Test40::FOO is ok' );
is_deeply( \@Symbol::Util::Test40::FOO, ["array"], '@Symbol::Util::Test40::FOO is ok' );
is_deeply( \%Symbol::Util::Test40::FOO, {"hash"=>1}, '%Symbol::Util::Test40::FOO is ok' );
is( Symbol::Util::Test40::FOO(), 'code', 'Symbol::Util::Test40::FOO() is ok' );
ok( fileno Symbol::Util::Test40::FOO, '*Symbol::Util::Test40::FOO{IO} is ok' );

ok( defined delete_glob("Symbol::Util::Test40::FOO", "ARRAY", "HASH"), 'delete_glob("Symbol::Util::Test40::FOO", "ARRAY", "HASH")' );
ok( ! defined $Symbol::Util::Test40::FOO, '$Symbol::Util::Test40::FOO is ok' );
ok( ! defined @Symbol::Util::Test40::FOO, '@Symbol::Util::Test40::FOO is ok' );
ok( ! defined %Symbol::Util::Test40::FOO, '%Symbol::Util::Test40::FOO is ok' );
is( Symbol::Util::Test40::FOO(), 'code', 'Symbol::Util::Test40::FOO() is ok' );
ok( fileno Symbol::Util::Test40::FOO, '*Symbol::Util::Test40::FOO{IO} is ok' );

ok( defined delete_glob("Symbol::Util::Test40::FOO", "CODE"), 'delete_glob("Symbol::Util::Test40::FOO", "CODE")' );
ok( ! defined $Symbol::Util::Test40::FOO, '$Symbol::Util::Test40::FOO is ok' );
ok( ! defined @Symbol::Util::Test40::FOO, '@Symbol::Util::Test40::FOO is ok' );
ok( ! defined %Symbol::Util::Test40::FOO, '%Symbol::Util::Test40::FOO is ok' );
ok( ! eval { Symbol::Util::Test40::FOO() }, 'Symbol::Util::Test40::FOO() is ok' );
ok( fileno Symbol::Util::Test40::FOO, '*Symbol::Util::Test40::FOO{IO} is ok' );

ok( defined delete_glob("Symbol::Util::Test40::FOO", "IO"), 'delete_glob("Symbol::Util::Test40::FOO", "IO")' );
ok( ! defined $Symbol::Util::Test40::FOO, '$Symbol::Util::Test40::FOO is ok' );
ok( ! defined @Symbol::Util::Test40::FOO, '@Symbol::Util::Test40::FOO is ok' );
ok( ! defined %Symbol::Util::Test40::FOO, '%Symbol::Util::Test40::FOO is ok' );
ok( ! eval { Symbol::Util::Test40::FOO() }, 'Symbol::Util::Test40::FOO() is ok' );
ok( ! fileno Symbol::Util::Test40::FOO, '*Symbol::Util::Test40::FOO{IO} is ok' );

{
    package Symbol::Util::Test40;
    open BAR, __FILE__ or die $!;
    *BAR = sub { "code" };
    our $BAR = "scalar";
    our @BAR = ("array");
    our %BAR = ("hash" => 1);
};

foreach my $slot (qw{ SCALAR ARRAY HASH CODE IO }) {
    ok( defined *Symbol::Util::Test40::BAR{$slot}, "defined *Symbol::Util::Test40::BAR{$slot}" );
};
is( $Symbol::Util::Test40::BAR, "scalar", '$Symbol::Util::Test40::BAR is ok' );
is_deeply( \@Symbol::Util::Test40::BAR, ["array"], '@Symbol::Util::Test40::BAR is ok' );
is_deeply( \%Symbol::Util::Test40::BAR, {"hash"=>1}, '%Symbol::Util::Test40::BAR is ok' );
is( Symbol::Util::Test40::BAR(), 'code', 'Symbol::Util::Test40::BAR() is ok' );
ok( fileno Symbol::Util::Test40::BAR, '*Symbol::Util::Test40::BAR{IO} is ok' );

ok( defined delete_glob("Symbol::Util::Test40::BAR", "IO"), 'delete_glob("Symbol::Util::Test40::BAR", "IO")' );
is( $Symbol::Util::Test40::BAR, "scalar", '$Symbol::Util::Test40::BAR is ok' );
is_deeply( \@Symbol::Util::Test40::BAR, ["array"], '@Symbol::Util::Test40::BAR is ok' );
is_deeply( \%Symbol::Util::Test40::BAR, {"hash"=>1}, '%Symbol::Util::Test40::BAR is ok' );
is( Symbol::Util::Test40::BAR(), 'code', 'Symbol::Util::Test40::BAR() is ok' );
ok( ! fileno Symbol::Util::Test40::BAR, '*Symbol::Util::Test40::BAR{IO} is ok' );

ok( ! defined delete_glob("Symbol::Util::Test40::BAR"), 'delete_glob("Symbol::Util::Test40::BAR")' );
ok( ! defined $Symbol::Util::Test40::BAR, '$Symbol::Util::Test40::BAR is ok' );
ok( ! defined @Symbol::Util::Test40::BAR, '@Symbol::Util::Test40::BAR is ok' );
ok( ! defined %Symbol::Util::Test40::BAR, '%Symbol::Util::Test40::BAR is ok' );
ok( ! eval { Symbol::Util::Test40::BAR() }, 'Symbol::Util::Test40::BAR() is ok' );
ok( ! fileno Symbol::Util::Test40::BAR, '*Symbol::Util::Test40::BAR{IO} is ok' );
