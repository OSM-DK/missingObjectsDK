#!/usr/bin/env bash

./getDK.sh && \
./make_layers.sh && \
./make_heatmaps.sh missing_dwellings missing_buildings missing_farms missing_landuse lost_addresses && \
./copy_layers.sh && \
./make_stats.js

