#!/usr/bin/env bash

# Script for getting OSM file for Denmark
# and importing to database


# Get OSM file
wget -nv -P files -N "http://download.geofabrik.de/europe/denmark-latest.osm.pbf"

# Import into database
PGPORT=5435 osm2pgsql -s -G -K -j -c -l --prefix='osm' -U jel -d osm files/denmark-latest.osm.pbf


# Get official Danish placenames from https://download.kortforsyningen.dk/content/stednavne and unzip it.
#### TODO: Automize!
echo "Get official Danish placenames from https://download.kortforsyningen.dk/content/stednavne and unzip it to files/KORT10.gml"

# Fix missing dimension and SRS definitions in the GML file:
perl -p -e 's/<gml:posList>/<gml:posList srsName="EPSG:25832" srsDimension="3">/g' files/KORT10.gml > files/stednavne.gml


# Import placenames to PostGIS
PGPORT=5435 ogr2ogr -f PostgreSQL -dim XY -nln stednavne -skipfailures -preserve_fid -overwrite -t_srs WGS84 -lco GEOMETRY_NAME=way PG:"dbname=osm user=jel" files/stednavne.gml

# Create indexes
psql osm < indexes.sql
