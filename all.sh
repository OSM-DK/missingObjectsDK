#!/usr/bin/env bash

./getDK.sh && \
./make_layers.sh && \
./split_layer.js layers/missing_buildings.geojson 8 && \
./split_layer.js layers/missing_nature.geojson 6 && \
./split_layer.js layers/missing_landuse.geojson 8 && \
./split_layer.js layers/missing_dwellings.geojson 4 && \
./split_layer.js layers/missing_farms.geojson 8 && \
./split_layer.js layers/lost_addresses.geojson 4 && \
./copy_layers.sh
