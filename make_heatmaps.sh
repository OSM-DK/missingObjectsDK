#!/usr/bin/env bash

# Script for making heatmap points
source config.sh

echo "Starting layers2points.sh $(date)" >> $LOGFILE

for layer in "$@"; do
    layerpath="layers/${layer}.geojson"
    outpath="layers/${layer}_heat.json"

    if [ -f $layerpath ]
    then
      echo "Making heatmap points for layer ${layer}" >> $LOGFILE
      rm "${outpath}" 2> /dev/null
      ./make_heatmap.js "${layerpath}" "${outpath}" >>$LOGFILE 2>&1
    else
      echo "File '$layerpath' does not exist" >&2
    fi
done

echo "Done - $(date)" >> $LOGFILE
