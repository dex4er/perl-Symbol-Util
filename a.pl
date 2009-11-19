  # delete constant from public API
  #
  package My::Class;

  use constant PI => 3.14159265;

  use lib 'lib';
  use Symbol::Util 'delete_sub';
  delete_sub "PI";

  sub area {
      my ($self, $r) = @_;
      return PI * $r ** 2
  }

  print My::Class->area(2);   # prints 12.5663706
  print My::Class->PI;        # error
