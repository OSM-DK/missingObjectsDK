#!/usr/bin/env bash

# Script for splitting layers
source config.sh

echo "Starting split_layers.sh $(date)" >> $LOGFILE
re='^[0-9]+$'

for pair in "$@"; do
    layer=${pair%:*}
    parts=${pair#*:}
    layerpath="layers/${layer}.geojson"

    if [[ $parts =~ $re ]]
    then
      if [ -f $layerpath ]
      then
        echo "Splitting layer ${layer} into ${parts} parts" >> $LOGFILE 
        rm "layers/${layer}_*.geojson" 2> /dev/null
        ./split_layer.js $layerpath $parts
      else
        echo "File '$layerpath' does not exist" >&2
      fi
    else
      echo "Invalid argument '${pair}': must be layername:path, e.g. missing_farms:8" >&2
    fi
done

echo "Done - $(date)" >> $LOGFILE
