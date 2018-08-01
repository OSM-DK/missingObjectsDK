CREATE INDEX idx_osm_point_tags ON osm_point USING gist(tags);
CREATE INDEX idx_osm_polygon_tags ON osm_polygon USING gist(tags);
CREATE INDEX idx_osm_line_tags ON osm_line USING gist(tags);
CREATE INDEX idx_osm_line_roads ON osm_roads USING gist(tags);

CREATE INDEX idx_osm_polygon_name ON osm_polygon (name);
CREATE INDEX idx_osm_polygon_place ON osm_polygon (place);
CREATE INDEX idx_osm_roads_name ON osm_roads (name);
CREATE INDEX idx_osm_roads_place ON osm_roads (place);
CREATE INDEX idx_osm_point_name ON osm_point (name);
CREATE INDEX idx_osm_point_place ON osm_point (place);
CREATE INDEX idx_osm_point_name ON osm_line (name);
CREATE INDEX idx_osm_point_place ON osm_line (place);

CREATE INDEX idx_osm_polygon_building ON osm_polygon (building);
CREATE INDEX idx_osm_point_building ON osm_point (building);
CREATE INDEX idx_osm_polygon_natural ON osm_polygon ("natural");
CREATE INDEX idx_osm_point_natural ON osm_point ("natural");

CREATE INDEX idx_osm_polygon_waterway ON osm_polygon (waterway);
CREATE INDEX idx_osm_line_waterway ON osm_line (waterway);
CREATE INDEX idx_osm_point_waterway ON osm_point (waterway);


CREATE INDEX idx_stednavne_navn ON stednavne (navn);
CREATE INDEX idx_stednavne_type ON stednavne (featuretype);

