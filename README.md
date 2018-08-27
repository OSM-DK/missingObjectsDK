# missingObjectsDK
Reporting tool for finding missing objects in OSM for Denmark

## Service details

This service is currently deployed at http://osm.elgaard.net and maintained by Jørgen Elgaard Larsen.


## Platform

This service assumes that you run on at Debian GNU/Linux system. It might run on other platforms, but that has not been tested.


## Preparation

Install PostgreSQL with PostGIS. You will also need osm2pgsql, GDAL, perl and bash.
```bash
apt-get install postgresql postgis osm2pgsql gdal perl bash
````

Create a new database, and configure it for this application:
```bash
sudo -u postgres createuser osm
sudo -u postgres createdb --encoding=UTF8 --owner=osm osm
psql osm < sql/setup.sql
```

Install node packages:
```bash
npm install
```

Then, copy `config.sh.example` to `config.sh` and edit the values:
* `POSTGIS_USER` should be a user with full permissions to the `osm` database.
* `KORTFORSYNINGEN_USER` and `KORTFORSYNINGEN_PW` should be the username and password for a user registered on download.kortforsyningen.dk
* `LOGFILE` should be set to a file path writable by the user running the scripts.

**NOTE!!!** In the file `public/map.php`, there is an access token for Mapbox. Please obtain your own and use that instead.



