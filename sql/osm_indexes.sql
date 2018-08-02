ALTER TABLE osm_point add column geog geography;
ALTER TABLE osm_line add column geog geography;
ALTER TABLE osm_polygon add column geog geography;

UPDATE osm_point SET geog = way::geography;
UPDATE osm_line SET geog = way::geography;
UPDATE osm_polygon SET geog = way::geography;

CREATE INDEX idx_osm_point_geog ON osm_point USING gist(geog);
CREATE INDEX idx_osm_line_geog ON osm_line USING gist(geog);
CREATE INDEX idx_osm_polygon_geog ON osm_polygon USING gist(geog);

CREATE INDEX idx_osm_point_tags ON osm_point USING gist(tags);
CREATE INDEX idx_osm_polygon_tags ON osm_polygon USING gist(tags);
CREATE INDEX idx_osm_line_tags ON osm_line USING gist(tags);
CREATE INDEX idx_osm_line_roads ON osm_roads USING gist(tags);

CREATE INDEX idx_osm_polygon_name ON osm_polygon (name);
CREATE INDEX idx_osm_polygon_name ON osm_polygon (alt_name);

CREATE INDEX idx_osm_roads_name ON osm_roads (name);
CREATE INDEX idx_osm_roads_name ON osm_roads (alt_name);

CREATE INDEX idx_osm_point_name ON osm_point (name);
CREATE INDEX idx_osm_point_name ON osm_point (alt_name);

CREATE INDEX idx_osm_point_name ON osm_line (name);
CREATE INDEX idx_osm_point_name ON osm_line (alt_name);

