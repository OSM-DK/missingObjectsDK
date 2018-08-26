#!/usr/bin/env bash

# Script for exporting GeoJSON layers for missing features in Denmark

for sqlfile in $(ls layer_sql/*.sql); do
    sqlfile=${sqlfile#*/}
    layer=${sqlfile%.sql}
    echo "Testing $layer"
    echo "EXPLAIN (COSTS) $(cat layer_sql/${sqlfile});" | psql osm > /dev/null
done


echo "Done"

