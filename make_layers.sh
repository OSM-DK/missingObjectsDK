#!/usr/bin/env bash

# Script for exporing GeoJSON layers for missing features in Denmark


# Import placenames to PostGIS
echo "Finder manglende øer"
PGPORT=5435 ogr2ogr -f GeoJSON files/missing_islands.geojson PG:"dbname=osm user=jel"  -sql '@sql/missing_islands.sql' -nln missing_islands -overwrite -t_srs WGS84


echo "Done"

