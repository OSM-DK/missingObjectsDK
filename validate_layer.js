#!/usr/bin/env node

// Script to validate a GeoJSON file


'use strict';

const fs = require('fs');
const GJV = require('geojson-validation');


function usage(msg) {
  if (msg) {
    console.error(msg);
  }
  console.error("Usage: validate_layer.js filename\n  e.g: validate_layer.js my_layer.geojson");
}


if (process.argv.length != 3) {
  usage('Wrong number of arguments');
  process.exit(3);
}


const fileName = process.argv[2];

if (! fs.existsSync(fileName)) {
  usage(`File '${fileName}' does not exist.`);
  process.exit(4);
}

const stats = fs.statSync(fileName);
if (!stats || stats.size < 1) {
  console.error(`File ${fileName} is only ${stats.size} bytes.`);
  process.exit(30);
}

var content;
try {
  content = fs.readFileSync(fileName);
} catch ( e ) {
  console.error(`Could not read GeoJSON file '${fileName}'`, e);
  process.exit(6);
}

var data;
try {
  data = JSON.parse(content);
} catch(e) {
  console.error(`Could not parse GeoJSON file ${fileName} as JSON`, e);
  process.exit(70);
}

if (!data || !data.features || data.features.length < 1) {
  console.error(`GeoJSON file ${fileName} has no features`);
  process.exit(71);
}


try {
  if (!GJV.valid(data)) {
    console.error(`File ${fileName} is not valid GeoJSON`);
    process.exit(50);
  }
} catch (e) {
  console.error(`Could not validate GeoJSON file ${fileName}`, e);
  process.exit(51);
}


// If we get here. everything is good
process.exit(0);
