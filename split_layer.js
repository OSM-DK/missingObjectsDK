#!/usr/bin/env node

// Script to split a GeoJSON file into parts


'use strict';

const fs = require('fs');


function usage(msg) {
  if (msg) {
    console.error(msg);
  }
  console.error("Usage: split_feature.js layerfile parts\n  e.g: split_feature.js my_layer.geojson 10");
}


if (process.argv.length != 4) {
  usage('Wrong number of arguments');
  process.exit(3);
}


const fileName = process.argv[2];
const partsArg = process.argv[3];

if (! fs.existsSync(fileName)) {
  usage(`File '${fileName}' does not exist.`);
  process.exit(4);
}


const parts = parseInt(partsArg);
if (isNaN(parts) || parts < 1 || !Number.isInteger(parts)) {
  usage(`Number of parts must be a positive integer, not '${partsArg}'`);
  process.exit(5);
}

var data;
try {
  data = JSON.parse(fs.readFileSync(fileName));
} catch ( e ) {
  console.error("Could not read GeoJSON file", e);
  process.exit(6);
}

const fileBase = fileName.replace(/\..+?$/, '');
const fileSuffix = fileName.match(/\..+?$/)[0] || '';

const features = data.features;
const featureCount = features.length;
const partLength = Math.ceil(featureCount/parts);

let idx = 0;

for (let start = 0; start <= featureCount; start += partLength) {
  data.features = features.slice(start, start + partLength);

  let file = `${fileBase}_${++idx}${fileSuffix}`;
  try {
    fs.writeFileSync(file, JSON.stringify(data));
  } catch (e) {
    console.error(`Could not wite file ${file}`, e);
    process.exit(10);
  }
}

