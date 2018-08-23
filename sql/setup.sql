CREATE OR REPLACE FUNCTION names2array (hstore)
  RETURNS text[]
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
  return [keys %$res];
$$  LANGUAGE plperl TRANSFORM FOR TYPE hstore;


CREATE TABLE osm_names (
  osm_id bigint,
  name text
);

CREATE INDEX idx_osm_names_full ON osm_names (osm_id, name);
