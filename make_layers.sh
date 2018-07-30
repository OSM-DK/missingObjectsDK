#!/usr/bin/env bash

# Script for exporting GeoJSON layers for missing features in Denmark


for sqlfile in $(ls layer_sql); do
    layer=${sqlfile%.sql}
    echo "Making layer $layer"
    PGPORT=5435 ogr2ogr -f GeoJSON layers/${layer}.geojson PG:"dbname=osm user=jel"  -sql '@sql/'${layer}.sql -nln missing_islands -overwrite -t_srs WGS84
done


echo "Done"

