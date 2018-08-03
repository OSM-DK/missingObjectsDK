#!/usr/bin/env bash

# Script for exporting GeoJSON layers for missing features in Denmark
source config.sh

echo "Starting make_layers - $(date)" >> $LOGFILE

rm layers/*.geojson >> $LOGFILE

for sqlfile in $(ls layer_sql/*.sql); do
    sqlfile=${sqlfile#*/}
    layer=${sqlfile%.sql}
    echo "Making layer $layer" >> $LOGFILE
    time PGPORT=5435 ogr2ogr -f GeoJSON layers/${layer}.geojson PG:"dbname=osm user=${POSTGIS_DBUSER}"  -sql '@layer_sql/'${layer}.sql -nln ${layer} -overwrite -t_srs WGS84 >> $LOGFILE
done


echo "Done - $(date)" >> $LOGFILE


