#!/usr/bin/env bash

# Script for copying working layers to home page
source config.sh

echo "Starting copy_layers $(date)" >> $LOGFILE
for layerfile in $(ls layers/*.geojson); do
    layerpath="layers/${layerfile#*/}"

    ./validate_layer.js $layerpath
    validation_result=$?
    if [ $validation_result -eq 0 ]
    then
       cp "$layerpath" public/layers >> $LOGFILE
       echo "Copied ${layerpath}" >> $LOGFILE
    else
       echo "Skipped invalid file ${layerpath}" >> $LOGFILE
    fi
done

echo "Done - $(date)" >> $LOGFILE
