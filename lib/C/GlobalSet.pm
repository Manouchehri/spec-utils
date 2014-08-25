package C::GlobalSet;
use Moose;

use Carp;

use C::Global;
use Local::C::Transformation qw(:RE);
use namespace::autoclean;

use re '/aa';

extends 'C::Set';
with    'C::Parse';

has '+set' => (
   isa => 'ArrayRef[C::Global]'
);


sub parse
{
   my $self = shift;
   my $area = $_[1];
   my %globals;
   my $name_re = qr/[a-zA-Z_]\w*+/;
   my $name = qr/(?<name>${name_re})/;

   while (${$_[0]} =~ m/extern${s}++([^;}{]+?)${name}\b${s}*+(?:\[[^\]]*+\])?${s}*+;
                        |
                        static${s}++struct${s}++${name_re}${s}++${name}${s}*+=${s}*+(?<sbody>\{(?:(?>[^\{\}]+)|(?&sbody))*\})${s}*+;
                     /gxp) {
      $globals{$+{name}} = ${^MATCH}
   }

   return $self->new(set => [ map {C::Global->new(name => $_, code => $globals{$_}, area => $area)} keys %globals ]);
}

__PACKAGE__->meta->make_immutable;

1;
