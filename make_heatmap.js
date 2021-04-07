#!/usr/bin/env node

// Script to split a GeoJSON file into parts


'use strict';

const fs = require('fs');


function usage(msg) {
  if (msg) {
    console.error(msg);
  }
  console.error("Usage: make_heatmap.js layerfile outfile\n  e.g: make_heatmap.js my_layer.geojson my_layer.json");
}


if (process.argv.length != 4) {
  usage('Wrong number of arguments');
  process.exit(3);
}


const inFileName = process.argv[2];
const outFileName = process.argv[3];

if (! fs.existsSync(inFileName)) {
  usage(`File '${inFileName}' does not exist.`);
  process.exit(4);
}

if (! outFileName) {
  usage('No output file name given');
  process.exit(5);
}


var data;
try {
  data = JSON.parse(fs.readFileSync(inFileName));
} catch ( e ) {
  console.error("Could not read and parse GeoJSON file '${fileName}': ", e);
  process.exit(6);
}

if (!data.features || !Array.isArray(data.features)) {
  console.error('GeoJSON has no features');
  process.exit(7);
}

const flatten = (arr) => {
  const res = [];
  arr.forEach( (e) => {
   if (Array.isArray(e[0])) {
     res.push(...flatten(e));
   } else {
     res.push(e);
   }
  });
  return res;
};

const res = data.features.map( (f) => {
  if (f.geometry && f.geometry.coordinates) {
    let coords = flatten( [f.geometry.coordinates] );

    const start = coords.pop().reverse();
    if (!start || !Array.isArray(start)) {
      console.warn('Feature with empty coordinates:', f);
      return null;
    }
    return coords.reduce( (t, e) => [ (t[0] + e[1]) / 2, (t[1] + e[0]) / 2 ],
                          start);
  }
  console.warn('Feature without coordinates:', f);
  return null;
})
.filter( (x) => !!x );


try {
  fs.writeFileSync(outFileName, JSON.stringify(res));
} catch (e) {
  console.error(`Could not write file ${outFileName}`, e);
  process.exit(10);
}
