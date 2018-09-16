#!/usr/bin/env bash

./getDK.sh && \
./make_layers.sh && \
./split_layers.sh missing_buildings:8 missing_nature:6 missing_landuse:8 missing_dwellings:4 missing_farms:8 lost_addresses:4 && \
./copy_layers.sh && \
./make_stats.js

