#!/usr/bin/env bash

# Script for copying working layers to home page


for layerfile in $(ls layers/*.geojson); do
	layerfile=${layerfile#*/}

	# TODO: Validate geojson file
	cp "layers/$layerfile" public/layers
done


echo "Done"

