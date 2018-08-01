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

CREATE INDEX idx_stednavne_navn ON stednavne (navn);
CREATE INDEX idx_stednavne_type ON stednavne (featuretype);

