#!/usr/bin/env bash

# Script for getting official Danish placenames from SFDE Danske Stednavne, unzip it and importing to database

source config.sh

echo "Get stednavne" >> $LOGFILE
DATAFORDELER_DIR="files/datafordeler"
STEDNAVN_DIR="${DATAFORDELER_DIR}/unzipped"
(rm -r "${DATAFORDELER_DIR}"/* || true) >> $LOGFILE 2>&1
wget -r -nv -nd -P files/datafordeler -o - -N ftp://${DATAFORDELER_USER}:${DATAFORDELER_PW}@ftp3.datafordeler.dk/ >> $LOGFILE
if test -n "$(find $DATAFORDELER_DIR -iname 'DKstednavne*.zip' -cmin -300)"
then
   STEDNAVN_FILE="$(find $DATAFORDELER_DIR -iname 'DKstednavne*.zip' -cmin -3000 | xargs ls -t | head -n 1)"
   echo "Unzip stednavne" >> $LOGFILE
   mkdir "$STEDNAVN_DIR"
   unzip -j -o "$STEDNAVN_FILE" -d "$STEDNAVN_DIR" >> $LOGFILE

   echo "Clearout stednavne_names" >> $LOGFILE
   echo "TRUNCATE TABLE stednavne_names" | psql osm  >> $LOGFILE


   find "$STEDNAVN_DIR" -name '*.gml' -exec ./importGml.sh {} \;

   echo "Updating stednavne_extranames" >> $LOGFILE
   psql osm < sql/stednavne_extranames.sql >> $LOGFILE

   echo "Adding extra stednavne indexes" >> $LOGFILE
   psql osm < sql/stednavne_indexes.sql >> $LOGFILE

   echo "Done importing stednavne" >> $LOGFILE
else
   echo "No news from Datafordeler" >> $LOGFILE
fi
