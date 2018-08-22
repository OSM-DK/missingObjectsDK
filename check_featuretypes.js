#!/usr/bin/env node

// Script to check for new/unhandled feature types


'use strict';

const fs = require('fs');
const { Client } = require('pg');

const files = fs.readdirSync('layer_sql').filter( (f) => f.match(/.+\.sql/) );

let data = '';

for (const file of files) {
  data += fs.readFileSync(`layer_sql/${file}`, 'utf8');
}

const featureTypes = new Set();

const chunks = data.match(/where\s+featuretype\s+in\s*\(\s*[^)]+/gi);

for (const chunk of chunks) {
  const parts = chunk.split(/'/);
  for (let i = 1; i < parts.length; i += 2) {
    featureTypes.add(parts[i]);
  }
}

const list = [...featureTypes].map( (s) => `'${s}'` ).join(', ');
const pg = new Client({
  database: 'osm',
  host: '/var/run/postgresql',
  port: '5435',
  password: null
  });

pg.connect()
.then( () => pg.query(`select featuretype, count(1) as antal from stednavne where featuretype not in (${list}) group by featuretype`) )
.then( (res) => {
          for (const row of res.rows) {
            console.log(`Unhandled featuretype: ${row.featuretype} (${row.antal} objects)`);
          }
        }
     )
.catch( e => console.error(e) )
.then( () => process.exit(0),
       () => process.exit(1)
     );



