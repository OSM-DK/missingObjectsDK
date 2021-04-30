#!/usr/bin/env bash

./getDK.sh && \
./make_layers.sh && \
./split_layers.sh missing_buildings:8 missing_landuse:8 missing_dwellings:4 missing_farms:8 lost_addresses:4 && \
./make_heatmaps.sh missing_dwellings missing_buildings missing_farms missing_landuse lost_addresses && \
./copy_layers.sh && \
./make_stats.js

