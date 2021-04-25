CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION HSTORE;
CREATE EXTENSION plperl;
CREATE EXTENSION hstore_plperl;


CREATE OR REPLACE FUNCTION names2array (hstore)
  RETURNS text[]
  AS $$
  use strict;

  my $tags = shift @_;
  my $res = {};
  foreach my $field ( qw(name alt_name int_name loc_name old_name lock_name seamark:name official_name name:da alt_name:da) ) {
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

CREATE INDEX idx_osm_names_name ON osm_names (name);
CREATE INDEX idx_osm_names_osm_id ON osm_names (osm_id);
