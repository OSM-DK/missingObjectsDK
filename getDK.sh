#!/usr/bin/env bash

# Script for getting OSM file for Denmark
# and importing to database

source config.sh

echo "--------------------------------------------------" >> $LOGFILE
echo "Starting getDK.sh - $(date)" >> $LOGFILE

# Get OSM file
echo "Get OSM file" >> $LOGFILE
wget -nv -P files -N "http://download.geofabrik.de/europe/denmark-latest.osm.pbf" >> $LOGFILE

# Import into database
if test $(find files/denmark-latest.osm.pbf -cmin -300)
then
  echo "Reading OSM file" >> $LOGFILE
  PGPORT=5435 osm2pgsql -s -G -K -j -c -l --prefix='osm' -S osmimport.style -U ${POSTGIS_DBUSER} -d osm files/denmark-latest.osm.pbf >> $LOGFILE

  # Create indexes
  echo "Create OSM indexes" >> $LOGFILE
  psql osm < sql/osm_indexes.sql >> $LOGFILE

else
  echo "No news from OSM" >> $LOGFILE
fi

# Get official Danish placenames from https://download.kortforsyningen.dk/content/stednavne and unzip it.
echo "Get stednavne" >> $LOGFILE
wget -nv -P files -N ftp://${KORTFORSYNINGEN_USER}:${KORTFORSYNINGEN_PW}@ftp.kortforsyningen.dk/stednavne/stednavne/GML/DK_GML_UTM32-EUREF89.zip >> $LOGFILE
if test $(find files/DK_GML_UTM32-EUREF89.zip -cmin -300)
then
   echo "Unzip stednavne" >> $LOGFILE
   unzip -j -o files/DK_GML_UTM32-EUREF89.zip KORT10/KORT10.gml -d files >> $LOGFILE

   # Fix missing dimension and SRS definitions and surplus spaces in the GML file:
   perl -p -e 's/<gml:posList>/<gml:posList srsName="EPSG:25832" srsDimension="3">/g; s/\s+(<\/kort)/$1/gs' files/KORT10.gml > files/stednavne.gml

   # Import placenames to PostGIS
   echo "Importing stednavne" >> $LOGFILE
   PGPORT=5435 ogr2ogr -f PostgreSQL -dim XY -nln stednavne -skipfailures -preserve_fid -overwrite -t_srs WGS84 -lco GEOMETRY_NAME=way PG:"dbname=osm user=${POSTGIS_USER}" files/stednavne.gml

   echo "Creating stednavne indexes" >> $LOGFILE
   # Create indexes
   psql osm < sql/stednavne_indexes.sql >> $LOGFILE


else
   echo "No news from Kortforsyningen" >> $LOGFILE
fi



echo "getDK.sh Done - $(date)"  >> $LOGFILE
