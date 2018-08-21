ALTER TABLE osm_point   add column geog geography, add column names hstore;
ALTER TABLE osm_line    add column geog geography, add column names hstore;
ALTER TABLE osm_polygon add column geog geography, add column names hstore;

UPDATE osm_point   SET geog = way::geography, names = names2hstore(tags);
UPDATE osm_line    SET geog = way::geography, names = names2hstore(tags);
UPDATE osm_polygon SET geog = way::geography, names = names2hstore(tags);

CREATE INDEX idx_osm_point_geog ON osm_point USING gist(geog);
CREATE INDEX idx_osm_line_geog ON osm_line USING gist(geog);
CREATE INDEX idx_osm_polygon_geog ON osm_polygon USING gist(geog);

CREATE INDEX idx_osm_point_tags ON osm_point USING gist(tags);
CREATE INDEX idx_osm_polygon_tags ON osm_polygon USING gist(tags);
CREATE INDEX idx_osm_line_tags ON osm_line USING gist(tags);

CREATE INDEX idx_osm_polygon_names ON osm_polygon USING gist(names);
CREATE INDEX idx_osm_point_names   ON osm_point   USING gist(names);
CREATE INDEX idx_osm_line_names    ON osm_line    USING gist(names);

CREATE INDEX idx_osm_line_name     ON osm_line (name);

