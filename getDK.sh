#!/usr/bin/env bash

# Script for getting OSM file for Denmark
# and importing to database

source config.sh

# Get OSM file
echo "Getting file"
wget -nv -P files -N "http://download.geofabrik.de/europe/denmark-latest.osm.pbf"

# Import into database
if test $(find files/denmark-latest.osm.pbf -cmin -300)
then
  PGPORT=5435 osm2pgsql -s -G -K -j -c -l --prefix='osm' -S osmimport.style -U ${POSTGIS_DBUSER} -d osm files/denmark-latest.osm.pbf

  echo "Creating OSM indeces"
  # Create indexes
  psql osm < sql/osm_indexes.sql


else
  echo "No news from OSM"
fi

# Get official Danish placenames from https://download.kortforsyningen.dk/content/stednavne and unzip it.
wget -nv -P files -N ftp://${KORTFORSYNINGEN_USER}:${KORTFORSYNINGEN_PW}@ftp.kortforsyningen.dk/stednavne/stednavne/GML/DK_GML_UTM32-EUREF89.zip
if test $(find files/DK_GML_UTML32-EUREF89.zip -cmin -300)
then
   unzip -j -o files/DK_GML_UTM32-EUREF89.zip KORT10/KORT10.gml -d files

   # Fix missing dimension and SRS definitions and surplus spaces in the GML file:
   perl -p -e 's/<gml:posList>/<gml:posList srsName="EPSG:25832" srsDimension="3">/g; s/\s+(<\/kort)/$1/gs' files/KORT10.gml > files/stednavne.gml

   # Import placenames to PostGIS
   echo "Importing stednavne"
   PGPORT=5435 ogr2ogr -f PostgreSQL -dim XY -nln stednavne -skipfailures -preserve_fid -overwrite -t_srs WGS84 -lco GEOMETRY_NAME=way PG:"dbname=osm user=${POSTGIS_USER}" files/stednavne.gml

   echo "Creating indeces"
   # Create indexes
   psql osm < sql/stednavne_indexes.sql


else
   echo "No news from Kortforsyningen"
fi



echo "Done"
