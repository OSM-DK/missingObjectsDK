#!/usr/bin/env bash

# Script for importing Stednavne GML into database

GMLFILE="$1"

source config.sh

if [ ! -f $GMLFILE ]; then
   >&2 echo "File $GMLFILE does not exist" 
   exit -1;
fi

LAYER="$(basename -s .gml "$GMLFILE")"

if [[ ! "$LAYER" =~ ^[0-9a-zA-Z_]+$ ]]
then
  echo "Layer $LAYER contains illegal characters - skipping file $GMLFILE!!!" >> $LOGFILE
  exit
fi

FIXEDDIR="$(dirname "$GMLFILE")_fixed";
FIXED="${FIXEDDIR}/$(basename $GMLFILE)";

TABLE="stednavne.${LAYER}"
IDX_PREFIX="idx_stednavne_${LAYER}"

if [[ ! -d "$FIXEDDIR" ]]
then
  mkdir -p "$FIXEDDIR"
fi

# Fix missing dimension and SRS definitions and surplus spaces in the GML file:
perl -p -e 's/<gml:posList>/<gml:posList srsName="EPSG:25832" srsDimension="3">/g' "$GMLFILE" > "$FIXED" 

# Import to to PostGIS
echo "Importing stednavne for $LAYER" >> $LOGFILE
ogr2ogr -f PostgreSQL -dim XY -nln "$TABLE" -skipfailures -overwrite -t_srs WGS84 -lco GEOMETRY_NAME=way PG:"dbname='osm' user='${POSTGIS_USER}' port=${PGPORT}" "$FIXED"

echo "Creating stednavne indexes and names for $LAYER" >> $LOGFILE

# Create indexes
SQL=$(cat <<ENDSQL 
UPDATE $TABLE SET way = ST_CurveToLine(way) where ST_GeometryType(way) = 'ST_CurvePolygon';

ALTER TABLE $TABLE ADD COLUMN geog geography;
UPDATE $TABLE set geog = way::geography;

CREATE INDEX ${IDX_PREFIX}_gml_id ON $TABLE (gml_id);
CREATE INDEX ${IDX_PREFIX}_geog ON $TABLE USING GIST(geog);
ENDSQL
)

echo $SQL | psql osm  >> $LOGFILE


# Insert into stednavne_names
for i in {1..5}
do
  if grep -q "<fme:navn_${i}_aktualitet>iAnvendelse" "$FIXED"
  then
    SQL=$(cat <<ENDINSERT
          INSERT INTO stednavne_names (name, gml_id, status, priority, sequence)
          SELECT navn_${i}_skrivemaade, gml_id, navn_${i}_navnestatus, navn_${i}_brugsprioritet, navn_${i}_navnefoelgenummer
          FROM $TABLE
          WHERE navn_${i}_skrivemaade IS NOT NULL
            AND navn_${i}_aktualitet IS NOT NULL
            AND navn_${i}_aktualitet = 'iAnvendelse';
ENDINSERT
)
    echo $SQL | psql osm  >> $LOGFILE
  fi
done
