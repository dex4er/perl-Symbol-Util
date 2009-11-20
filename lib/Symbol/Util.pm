#!/usr/bin/perl -c

package Symbol::Util;

=head1 NAME

Symbol::Util - Additional utils for Perl symbols manipulation

=head1 SYNOPSIS

  use Symbol::Util ':all';

  my $caller = caller;
  *{ fetch_glob("${caller}::foo") } = sub { "this is foo" };
  *{ fetch_glob("${caller}::bar") } = fetch_glob("${caller}::foo", "CODE");
  sub baz { 42; }
  export_glob($caller, "baz");

  print join "\n", keys %{ stash("main") };

  delete_glob("${caller}::foo", "CODE");

  use constant PI => 3.14159265;
  delete_sub "PI";   # remove constant from public API

=head1 DESCRIPTION

This module provides a set of additional functions useful for Perl
symbols manipulation.

I.e. C<delete_glob> function allows to delete specific slot of
symbol name without deleting others.

C<delete_sub> removes the function from class API.  This function won't be
available as an object method.

=for readme stop

=cut


use 5.006;

use strict;
use warnings;

our $VERSION = '0.02';


# Export
my @EXPORT_OK = qw( delete_glob delete_sub export_glob fetch_glob stash );
my %EXPORT_TAGS = (all => [ @EXPORT_OK ]);
my %EXPORT_DONE;


## no critic (ProhibitSubroutinePrototypes)
## no critic (RequireArgUnpacking)

=head1 IMPORTS

By default, the class does not export its symbols.

=over

=item use Symbol::Util ':all';

Imports all available symbols.

=cut

sub import {
    my ($class, @args) = @_;

    my $caller = caller();

    my %exports;

    while (my $name = shift @args) {
        if ($name =~ /^:(.*)$/) {
            my $tag = $1;
            next unless defined $EXPORT_TAGS{$tag};
            $exports{$_} = 1 foreach @{ $EXPORT_TAGS{$tag} };
        }
        elsif (defined fetch_glob($name, 'CODE')) {
            $exports{$name} = 1;
        };
    };

    $EXPORT_DONE{$caller}{$_} = 1 foreach keys %exports;

    foreach my $name (keys %exports) {
        *{ fetch_glob("${caller}::$name") } = fetch_glob($name, "CODE");
    };
};


=item no Symbol::Util;

Deletes all imported symbols from caller name space.

=back

=cut

sub unimport {
    my ($class) = @_;

    my $caller = caller();

    foreach my $name (keys %{ $EXPORT_DONE{$caller} }) {
        delete_sub("${caller}::$name");
    };

    delete $EXPORT_DONE{$caller};
};


=head1 FUNCTIONS

=over

=item stash( I<name> : Str ) : HashRef

Returns a refernce to the stash for the specified name.  If the stash does not
already exists it will be created.  The name of the stash does not include the
C<::> at the end.  It is safe to use this function with C<use strict 'refs'>.

This function is taken from Kurila, a dialect of Perl.

  print join "\n", keys %{ Symbol::stash("main") };

=item delete_glob( I<name> : Str, I<slots> : Array[Str] ) : Maybe[GlobRef]

Deletes the specified symbol name if I<slots> are not specified, or deletes
the specified slots in symbol name (could be one or more of the following
strings: C<SCALAR>, C<ARRAY>, C<HASH>, C<CODE>, C<IO>, C<FORMAT>).

Function returns the glob reference if there are any slots defined.

  our $FOO = 1;
  sub FOO { "bar" };

  delete_glob("FOO", "CODE");

  print $FOO;  # prints "1"
  FOO();       # error: sub not found

=cut

sub stash ($) {
    no strict 'refs';
    return \%{ *{ $_[0] . '::' } };
};


=item fetch_glob( I<name> : Str ) : GlobRef

=item fetch_glob( I<name> : Str, I<slot> : Str ) : Ref

Returns a reference to the glob for the specified symbol name.  If the
symbol does not already exists it will be created.  If the symbol name is
unqualified it will be looked up in the calling package.  It is safe to use
this function with C<use strict 'refs'>.

If I<slot> is defined, reference to its value is returned.  The I<slot> can be
one of the following strings: C<SCALAR>, C<ARRAY>, C<HASH>, C<CODE>, C<IO>,
C<FORMAT>).

This function is taken from Kurila, a dialect of Perl.

  my $caller = caller;
  *{ fetch_glob("${caller}::foo") } = sub { "this is foo" };
  *{ fetch_glob("${caller}::bar") } = fetch_glob("${caller}::foo", "CODE");

=cut

sub fetch_glob ($;$) {
    my ($name, $slot) = @_;

    if ($name !~ /::/) {
        $name = caller() . '::' . $name;
    };

    no strict 'refs';
    return defined $slot ? *{ $name }{$slot} : \*{ $name };
};


=item export_glob( I<package>, I<name> : Str ) : GlobRef

=item export_glob( I<package>, I<name> : Str, I<slot> : Str ) : Ref

Exports a glob I<name> to the I<package>.  Optionaly exports only one slot
of the glob.

  sub my_function { ... };
  sub import {
      my $caller = caller;
      export_glob($caller, "my_function");
  }

=cut

sub export_glob ($$;$) {
    my ($package, $name, $slot) = @_;

    if ($name !~ /::/) {
        $name = caller() . '::' . $name;
    };

    (my $srcpackage = $name) =~ s/::([^:]*)$//;
    my $srcsubname = $1;

    my $dstname = $package . "::$srcsubname";

    no strict 'refs';

    return if defined $slot
              ? ! defined *{ $name }{$slot}
              : ! defined *{ $name } ;

    *{ $dstname } = defined $slot ? *{ $name }{$slot} : *{ $name };
    return \*{ $dstname };
};


=item delete_glob( I<name> : Str, I<slots> : Array[Str] ) : Maybe[GlobRef]

Deletes the specified symbol name if I<slots> are not specified, or deletes
the specified slots in the symbol name (could be one or more of the following
strings: C<SCALAR>, C<ARRAY>, C<HASH>, C<CODE>, C<IO>, C<FORMAT>).

Function returns the glob reference if there are any slots defined.

  our $FOO = 1;
  sub FOO { "bar" };

  delete_glob("FOO", "CODE");

  print $FOO;  # prints "1"
  FOO();       # error: sub not found

=cut

sub delete_glob ($;@) {
    my ($name, @slots) = @_;

    if ($name !~ /::/) {
        $name = caller() . '::' . $name;
    };

    (my $package = $name) =~ s/::([^:]*)$//;
    my $subname = $1;

    my $stash = stash($package);

    if (@slots) {
        my %delete = map { $_ => 1 } @slots;
        my %backup;

        $backup{SCALAR} = fetch_glob($name, 'SCALAR')
            if not $delete{SCALAR} and defined fetch_glob($name, 'SCALAR');
        foreach my $slot (qw{ ARRAY HASH CODE IO }) {
            $backup{$slot} = fetch_glob($name, $slot)
                if not $delete{$slot} and defined fetch_glob($name, $slot);
        };

        undef $stash->{$subname};

        foreach my $slot (qw{ SCALAR ARRAY HASH CODE IO }) {
            *{ fetch_glob($name) } = $backup{$slot}
                if exists $backup{$slot};
        };

        return fetch_glob($name);
    }
    else {
        # delete all slots
        undef $stash->{$subname};
    };

    return;
};


=item delete_sub( I<name> : Str ) : Maybe[GlobRef]

Deletes the specified subroutine name from class API.  It means that this
subroutine will be no longer available as the class method.

Function returns the glob reference if there are any other slots still defined
than <CODE> slot.

  package My::Class;

  use constant PI => 3.14159265;

  use Symbol::Util 'delete_sub';
  delete_sub "PI";   # remove constant from public API
  no Symbol::Util;   # remove also Symbol::Util::* from public API

  sub area {
      my ($self, $r) = @_;
      return PI * $r ** 2
  }

  print My::Class->area(2);   # prints 12.5663706
  print My::Class->PI;        # can't locate object method

=back

=cut

sub delete_sub ($) {
    my ($name) = @_;

    if ($name !~ /::/) {
        $name = caller() . '::' . $name;
    };

    (my $package = $name) =~ s/::([^:]*)$//;
    my $subname = $1;

    return if not defined fetch_glob($name, 'CODE');

    my $stash = stash($package);

    my %backup;

    $backup{SCALAR} = fetch_glob($name, 'SCALAR') if defined ${ fetch_glob($name, 'SCALAR') };
    foreach my $slot (qw{ ARRAY HASH CODE IO }) {
        $backup{$slot} = fetch_glob($name, $slot)
            if defined fetch_glob($name, $slot);
    };
    undef $stash->{$subname};

    *{ fetch_glob($name) } = $backup{CODE};
    delete $backup{CODE};

    delete $stash->{$subname};

    foreach my $slot (qw{ SCALAR ARRAY HASH IO }) {
        *{ fetch_glob($name) } = $backup{$slot}
            if exists $backup{$slot};
    };

    return %backup ? fetch_glob($name) : undef;
};


1;


__END__

=begin umlwiki

= Class Diagram =

[                      <<utility>>
                       Symbol::Util
 ------------------------------------------------------------------
 ------------------------------------------------------------------
 fetch_glob( name : Str ) : GlobRef
 fetch_glob( name : Str, slot : Str ) : Ref
 export_glob( package : Str, name : Str ) : GlobRef
 export_glob( package : Str, name : Str, slot : Str ) : GlobRef
 stash( name : Str ) : HashRef
 delete_glob( name : Str, slots : Array[Str] ) : GlobRef
 delete_sub( name : Str ) : GlobRef
                                                                   ]

=end umlwiki

=head1 SEE ALSO

L<Symbol>, L<Sub::Delete>.

=head1 BUGS

C<delete_glob> always deletes C<FORMAT> slot.

C<delete_glob> deletes C<SCALAR> slot if it exists and contains C<undef>
value.

If you find the bug, please report it.

=for readme continue

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 COPYRIGHT

Copyright (C) 2009 by Piotr Roszatycki <dexter@cpan.org>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>
