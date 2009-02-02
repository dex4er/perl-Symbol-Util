#!/usr/bin/perl -c

package Symbol::Util;

=head1 NAME

Symbol::Util - Additional utils for Perl symbols manipulation

=head1 SYNOPSIS

  package Symbol::Util ':all';

  print ${ *{ fetch_glob("$class\::VERSION") } };
  *{ fetch_glob("foo") } = sub { "this is foo" };

  print join "\n", keys %{ Symbol::stash("main") };

=head1 DESCRIPTION

This module provides a set of additional functions useful for Perl
symbols manipulation.

=for readme stop

=cut


use 5.006;

use strict;
use warnings;

our $VERSION = 0.01;


use Symbol ();


# Export
use Exporter ();
*import = \&Exporter::import;
our @EXPORT_OK = qw{ fetch_glob stash };
our %EXPORT_TAGS = (all => [ @EXPORT_OK ]);


# Returns a reference to the glob
sub fetch_glob ($) {
    no strict 'refs';
    my $name = Symbol::qualify($_[0], caller);
    return \*{ $name };
};


# Returns a refernce to the stash
sub stash ($) {
    no strict 'refs';
    return \%{ *{ $_[0] . '::' } };
};


1;


__END__

=begin umlwiki

= Class Diagram =

[             <<utility>>
             Symbol::Util
 ----------------------------------
 ----------------------------------
 fetch_glob( name : Str ) : GlobRef
 stash( name : Str ) : HashRef     
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
unqualified it will be looked up in the calling package.

=item stash( I<name> : Str ) : HashRef

Returns a refernce to the stash for the specified name.  If the stash does not
already exists it will be created.  The name of the stash does not include the
C<::> at the end.

=back

=head1 SEE ALSO

L<Symbol>.

=head1 BUGS

If you find the bug, please report it.

=for readme continue

=head1 AUTHOR

Piotr Roszatycki <dexter@debian.org>

=head1 COPYRIGHT

Copyright (C) 2009 by Piotr Roszatycki E<lt>dexter@debian.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>
