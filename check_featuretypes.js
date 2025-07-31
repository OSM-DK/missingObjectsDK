#!/usr/bin/env node

// Script to check for new/unhandled feature types


'use strict';

const fs = require('fs');
const { Client } = require('pg');

const files = fs.readdirSync('layer_sql').filter( (f) => f.match(/.+\.sql$/) );

let data = '';

for (const file of files) {
  data += fs.readFileSync(`layer_sql/${file}`, 'utf8');
}

const queryTables = new Map();

const re = /from stednavne\.(?<table>\w+)\s+s\s+where\s+(?:(?<typecolumn>\w+type)\s+in\s*\(\s*(?<fields>[^)]+)\s*\)\s*and\s+)?(?:not\s+exists|s.navn_1_skrivemaade\s+not\s+in)/gi;

for (const match of data.matchAll(re)) {
    const table = { name: match.groups.table, fields: new Set()};
    if (match.groups.typecolumn) {
	table.total = false;
	const parts = match.groups.fields.split(/'(?:\s*,\s*')?/);
	table.fields = new Set(parts.filter(p => !(!p || p.match(/^\s*$/))));
	table.typecolumn = match.groups.typecolumn;
    } else {
	table.total = true;
    }

    if (queryTables.has(table.name)) {
	const existing = queryTables.get(table.name)
        existing.total = existing.total || table.total;
	existing.typecolumn = existing.typecolumn || table.typecolumn;

	for (const value of table.fields) {
	    existing.fields.add(value);
	}
    } else {
	queryTables.set(table.name, table);
    }
}

const missing = [];

const pg = new Client({
  database: 'osm',
  host: '/var/run/postgresql',
  port: '5432',
  password: null
  });

pg.connect()
    .then( () => pg.query(`SELECT table_name, column_name
			  FROM information_schema.columns
			  WHERE table_schema = 'stednavne'
			  AND column_name LIKE '%type'`) )
    .then( (res) => Promise.all( res.rows.map( (row) => {
	const tablePrefix = row.table_name.substring(0, 7);
	if (! row.column_name.match(new RegExp(`^${tablePrefix}.*type$`))) {
	    // skip
	    return Promise.resolve();
	}

	const tableInfo = queryTables.get(row.table_name);
	if (tableInfo && tableInfo.total) {
	    // All used
	    return Promise.resolve();
	}

	return pg.query(`SELECT DISTINCT ${row.column_name} FROM stednavne.${row.table_name}`).
	    then( (features) => {
		for (const feature of features.rows) {
		    const value = feature[row.column_name];
		    if (! tableInfo.fields.has(value)) {
			missing.push(`${tableInfo.name}.${value}`);
		    }	
		}
	    });
    })))
    .then( () => {
	if (missing.length == 0) {
	    console.log(`All features are handled`);
	} else {
	    console.log(`${missing.length} missing features:`);
	    for (const miss of missing.sort()) {
		console.log(`  ${miss}`);
	    }
	}
    })
    .catch( e => console.error(e) )
    .then( () => process.exit(0),
       () => process.exit(1)
    );
