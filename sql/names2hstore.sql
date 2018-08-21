CREATE OR REPLACE FUNCTION names2hstore (hstore)
  RETURNS hstore
  AS $$
  use strict;

  my $tags = shift @_;
  my $res = {};
  foreach my $field ( qw(name alt_name int_name loc_name old_name) ) {
    if ($tags->{$field}) {
      foreach my $val ( split(/;/, $tags->{$field}) ) {
        $val =~ s/(^\s+|\s+$)//g;
        $res->{$val} = '1';
      }
    }
  }
  return $res;
$$  LANGUAGE plperl TRANSFORM FOR TYPE hstore;
