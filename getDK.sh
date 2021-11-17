#!/usr/bin/env bash

# Script for getting OSM file for Denmark
# and importing to database

source config.sh

echo "--------------------------------------------------" >> $LOGFILE
echo "Starting getDK.sh - $(date)" >> $LOGFILE

# Get OSM file
echo "Get OSM file" >> $LOGFILE
wget -nv -P files -o - -N "http://download.geofabrik.de/europe/denmark-latest.osm.pbf" >> $LOGFILE

# Import into database
if test $(find files/denmark-latest.osm.pbf -cmin -300)
then
  echo "Reading OSM file" >> $LOGFILE
  PGPORT=5435 osm2pgsql -s -G -K -j -c -l --unlogged --drop --prefix='osm' -S osmimport.style -U ${POSTGIS_DBUSER} -d osm files/denmark-latest.osm.pbf >> $LOGFILE 2>&1
  OSMRESULT=$?

  if [ $OSMRESULT -ne 0 ]; then
    >&2 echo "Could not import OSM file: exit code $OSMRESULT"
    exit $OSMRESULT
  fi

  # Create indexes
  echo "Create OSM indexes" >> $LOGFILE
  psql osm < sql/osm_indexes.sql >> $LOGFILE

else
  echo "No news from OSM" >> $LOGFILE
fi

./getStednavne.sh

echo "Get redningsnumre" >> $LOGFILE
wget -nv -O files/redningsnumre.gml -o -  'http://kort.strandnr.dk/geoserver/nobc/wfs?SERVICE=WFS&REQUEST=GetFeature&outputFormat=gml3&typeName=Redningsnummer' >> $LOGFILE
if test $(find files/redningsnumre.gml -cmin -300)
then

   # Import redningsnumre to PostGIS
   echo "Importing redningsnumre" >> $LOGFILE
   PGPORT=5435 ogr2ogr -f PostgreSQL -dim XY -nln redningsnumre -skipfailures -overwrite -t_srs WGS84 -lco GEOMETRY_NAME=way PG:"dbname=osm user=${POSTGIS_USER}" files/redningsnumre.gml

   echo "Creating redningsnumre indexes" >> $LOGFILE
   # Create indexes
   psql osm < sql/redningsnumre_indexes.sql >> $LOGFILE


else
   echo "No news from redningsnummer.dk" >> $LOGFILE
fi



echo "getDK.sh Done - $(date)"  >> $LOGFILE
