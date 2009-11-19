#!/usr/bin/perl -c

package Symbol::Util;

=head1 NAME

Symbol::Util - Additional utils for Perl symbols manipulation

=head1 SYNOPSIS

  use Symbol::Util ':all';

  my $caller = caller;
  *{ fetch_glob("${caller}::foo") } = sub { "this is foo" };

  print join "\n", keys %{ Symbol::stash("main") };

  delete_glob("${caller}::foo", "CODE");

=head1 DESCRIPTION

This module provides a set of additional functions useful for Perl
symbols manipulation.

I.e. C<delete_glob> function allows to delete specific slot of
symbol name without deleting others.

=for readme stop

=cut


use 5.006;

use strict;
use warnings;

our $VERSION = '0.02';


# Export
use Exporter ();
BEGIN { *import = \&Exporter::import; };
our @EXPORT_OK = qw{ fetch_glob stash delete_glob delete_sub };
our %EXPORT_TAGS = (all => [ @EXPORT_OK ]);


## no critic (ProhibitSubroutinePrototypes)
## no critic (RequireArgUnpacking)

# Returns a reference to the glob
sub fetch_glob ($) {
    my ($name) = @_;

    if ($name !~ /::/) {
        $name = caller() . '::' . $name;
    };

    no strict 'refs';
    return \*{ $name };
};


# Returns a reference to the stash
sub stash ($) {
    no strict 'refs';
    return \%{ *{ $_[0] . '::' } };
};


# Deletes a symbol in symbol table
sub delete_glob ($;@) {
    my ($name, @slots) = @_;

    if ($name !~ /::/) {
        $name = caller() . '::' . $name;
    };

    (my $package = $name) =~ s/([^:]*)$//;
    my $subname = $1;

    no strict 'refs';
    my $stash = \%{ *{$package} };

    if (@slots) {
        my %delete = map { $_ => 1 } @slots;
        my %backup;

        $backup{SCALAR} = *{$name}{SCALAR}
            if not $delete{SCALAR} and defined ${ *{$name}{SCALAR} };
        foreach my $slot (qw{ ARRAY HASH CODE IO }) {
            $backup{$slot} = *{$name}{$slot}
                if not $delete{$slot} and defined *{$name}{$slot};
        };

        undef $stash->{$subname};

        foreach my $slot (qw{ SCALAR ARRAY HASH CODE IO }) {
            *{$name} = $backup{$slot}
                if exists $backup{$slot};
        };

        return \*{$name};
    }
    else {
        # delete all slots
        undef $stash->{$subname};
    };

    return;
};


# Deletes a sub in symbol table
sub delete_sub ($) {
    my ($name) = @_;

    if ($name !~ /::/) {
        $name = caller() . '::' . $name;
    };

    (my $package = $name) =~ s/([^:]*)$//;
    my $subname = $1;

    no strict 'refs';
    return if not defined *{$name}{CODE};

    my %backup;

    $backup{SCALAR} = *{$name}{SCALAR} if defined ${ *{$name}{SCALAR} };
    foreach my $slot (qw{ ARRAY HASH CODE IO }) {
        $backup{$slot} = *{$name}{$slot}
            if defined *{$name}{$slot};
    };
    undef *{$name};

    *{$name} = $backup{CODE};

    my $stash = \%{ *{$package} };
    delete $stash->{$subname};

    foreach my $slot (qw{ SCALAR ARRAY HASH IO }) {
        *{$name} = $backup{$slot}
            if exists $backup{$slot};
    };

    return 1;
};


1;


__END__

=begin umlwiki

= Class Diagram =

[                      <<utility>>
                       Symbol::Util
 -------------------------------------------------------
 -------------------------------------------------------
 fetch_glob( name : Str ) : GlobRef
 stash( name : Str ) : HashRef
 delete_glob( name : Str, slots : Array[Str] ) : GlobRef
 delete_sub( name : Str ) : GlobRef
                                                        ]

=end umlwiki

=head1 IMPORTS

By default, the class does not export its symbols.

=over

=item use Symbol::Util ':all';

Imports all available symbols.

=back

=head1 FUNCTIONS

=over

=item fetch_glob( I<name> : Str ) : GlobRef

Returns a reference to the glob for the specified symbol name.  If the
symbol does not already exists it will be created.  If the symbol name is
unqualified it will be looked up in the calling package.  It is safe to use
this function with C<use strict 'refs'>.

This function is taken from Kurila, a dialect of Perl.

  my $caller = caller;
  *{ fetch_glob("${caller}::foo") } = sub { "this is foo" };

=item stash( I<name> : Str ) : HashRef

Returns a refernce to the stash for the specified name.  If the stash does not
already exists it will be created.  The name of the stash does not include the
C<::> at the end.  It is safe to use this function with C<use strict 'refs'>.

This function is taken from Kurila, a dialect of Perl.

  print join "\n", keys %{ Symbol::stash("main") };

=item delete_glob( I<name> : Str, I<slots> : Array[Str] ) : Maybe[GlobRef]

Deletes the specified symbol name if I<slots> are not specified, or deletes
the specified slots in symbol name (could be one or more of following strings:
C<SCALAR>, C<ARRAY>, C<HASH>, C<CODE>, C<IO>, C<FORMAT>).

Function returns the glob reference if there are any slots defined.

  our $FOO = 1;
  sub FOO { "bar" };

  delete_glob("FOO", "CODE");

  print $FOO;  # prints "1"
  FOO();       # error: sub not found

=back

=head1 SEE ALSO

L<Symbol>.

=head1 BUGS

C<delete_glob> always deletes C<FORMAT> slot.

C<delete_glob> deletes C<SCALAR> slot if it exists and contains C<undef>
value.

If you find the bug, please report it.

=for readme continue

=head1 AUTHOR

Piotr Roszatycki <dexter@debian.org>

=head1 COPYRIGHT

Copyright (C) 2009 by Piotr Roszatycki E<lt>dexter@debian.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>
