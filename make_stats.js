#!/usr/bin/env node

// Script to write statistics


'use strict';

const fs = require('fs');
const moment = require('moment');

const files = fs.readdirSync('layers').filter( (f) => f.match(/.+\.geojson/) );


const now = moment();

const filename = now.format('YYYYMMDD') + '.json';
const showdate = now.format('D. MMM YYYY');

const data = { showDate: showdate,
               stats: {},
               date: now
             };


for (const file of files) {
  const layerName = file.replace(/\.geojson$/, '');
  if (layerName.match(/_\d+$/)) {
    continue;
  }

  let content;
  try {
     content = JSON.parse(fs.readFileSync(`layers/${file}`, 'utf8'));
  } catch (e) {
    console.warn(`Could not read and parse layer file ${file}`, e);
    process.exit(7);
  }

  if (content && content.features) {
    data.stats[layerName] =  content.features.length;
  }
}


try {
  fs.writeFileSync(`public/stats/${filename}`, JSON.stringify(data));
} catch (e) {
  console.warn(`Could not save statistics to ${filename}`, e);
  process.exit(8);
}
