# missingObjectsDK
Reporting tool for finding missing objects in OSM for Denmark

## Service details

This service is currently deployed at http://osm.elgaard.net and maintained by Jørgen Elgaard Larsen.

## Preparation

Install PostgreSQL with PostGIS. You will also need osm2pgsql, GDAL, perl and bash.

```bash
apt-get install postgresql postgis osm2pgsql
````

Create a new database and enable PostGis on it:

```bash
sudo -u postgres createuser osm
sudo -u postgres createdb --encoding=UTF8 --owner=osm osm
echo "CREATE EXTENSION postgis;" | psql osm
echo "CREATE EXTENSION postgis_topology;" | psql osm
echo "CREATE EXTENSION HSTORE;" | psql osm
echo "CREATE EXTENSION plperl;" | psql osm
echo "CREATE EXTENSION hstore_plperl;" | psql osm
psql osm < sql/names2hstore.sql
```

Then, copy `config.sh.example` to `config.sh` and edit the values:
* `POSTGIS_USER` should be a user with full permissions to the `osm` database.
* `KORTFORSYNINGEN_USER` and `KORTFORSYNINGEN_PW` should be the username and password for a user registered on download.kortforsyningen.dk
* `LOGFILE` should be set to a file path writable by the user running the scripts.

**NOTE!!!** In the file `public/map.php`, there is an access token for Mapbox. Please obtain your own and use that instead.



