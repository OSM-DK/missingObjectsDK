#!/usr/bin/env bash

# Script for exporting GeoJSON layers for missing features in Denmark
export PGPORT=5435

source config.sh

echo "Starting make_layers - $(date)" >> $LOGFILE

GJ_LAYERS=$(ls layers/*.geojson)
SQL_LAYERS=$(ls layer_sql/*.sql)


if (($# > 0))
then
    GJ=("${@/#/layers/}")
    GJ=("${GJ[@]/%/.geojson}")
    GJ_LAYERS=$(ls "${GJ[@]}")
    
    SQL=("${@/#/layer_sql/}")
    SQL=("${SQL[@]/%/.sql}")
    SQL_LAYERS=$(ls "${SQL[@]}")
fi

rm $GJ_LAYERS >> $LOGFILE

for sqlfile in $SQL_LAYERS; do
    sqlfile=${sqlfile#*/}
    layer=${sqlfile%.sql}
    echo "Making layer $layer - $(date)" >> $LOGFILE
    START=$(date +%s)
    ogr2ogr -f GeoJSON layers/${layer}.geojson PG:"dbname=osm user=${POSTGIS_DBUSER}"  -sql '@layer_sql/'${layer}.sql -nln ${layer} -overwrite -t_srs WGS84 >> $LOGFILE
    STOP=$(date +%s)

    dT=$(echo "$STOP - $START" | bc)
    dH=$(echo "$dT/3600" | bc)
    dT=$(echo "$dT-3600*$dH" | bc)
    dM=$(echo "$dT/60" | bc)
    dS=$(echo "$dT-60*$dM" | bc)
    printf "%d:%02d:%02d for layer %s\n" $dH $dM $dS $layer >> $LOGFILE
done

echo "All layers done - $(date)" >> $LOGFILE


