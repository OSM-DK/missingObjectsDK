#!/usr/bin/env bash

# Script for exporting GeoJSON layers for missing features in Denmark

for sqlfile in $(ls layer_sql/mis*.sql); do
    sqlfile=${sqlfile#*/}
    layer=${sqlfile%.sql}
    echo "Testing $layer"
    cat layer_sql/${sqlfile} sql/limit.sql | psql osm
done


echo "Done"

