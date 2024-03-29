ALTER TABLE osm_point   add column geog geography;
ALTER TABLE osm_line    add column geog geography;
ALTER TABLE osm_polygon add column geog geography;

ALTER TABLE osm_polygon add column simple_geog geography;

UPDATE osm_point   SET geog = way::geography;
UPDATE osm_line    SET geog = way::geography;
UPDATE osm_polygon SET geog = way::geography;

CREATE INDEX idx_osm_point_geog ON osm_point USING gist(geog);
CREATE INDEX idx_osm_line_geog ON osm_line USING gist(geog);
CREATE INDEX idx_osm_polygon_geog ON osm_polygon USING gist(geog);

CREATE INDEX idx_osm_point_way ON osm_point USING gist(way);
CREATE INDEX idx_osm_line_way ON osm_line USING gist(way);

CREATE INDEX idx_osm_point_osm_id   ON osm_point   (osm_id);
CREATE INDEX idx_osm_line_osm_id    ON osm_line    (osm_id);
CREATE INDEX idx_osm_polygon_osm_id ON osm_polygon (osm_id);

CREATE INDEX idx_osm_point_tags ON osm_point USING gist(tags);
CREATE INDEX idx_osm_polygon_tags ON osm_polygon USING gist(tags);
CREATE INDEX idx_osm_line_tags ON osm_line USING gist(tags);

CREATE INDEX idx_osm_line_name ON osm_line (name);
CREATE INDEX idx_osm_line_highway ON osm_line (highway);
CREATE INDEX idx_osm_line_bridge ON osm_line (bridge);

CREATE INDEX idx_osm_point_addr ON osm_point ("addr:housenumber", "addr:street", "addr:postcode", "addr:country");
CREATE INDEX idx_osm_point_street ON osm_point ("addr:street");


UPDATE osm_polygon
  SET simple_geog = ST_SimplifyPreserveTopology(way, 0.01)::geography
  WHERE defined(tags, 'natural')
     OR defined(tags, 'landuse')
     OR tags -> 'leisure' in (
                              'nature_reserve',
			      'garden',
			      'park'
                           )
     OR tags -> 'place' in (
                              'locality',
                              'sea'
                           )
     OR defined(tags, 'seamark:sea_area:category');

CREATE INDEX idx_osm_polygon_simple_geog ON osm_polygon USING gist(simple_geog);


TRUNCATE TABLE osm_names;

INSERT INTO osm_names (
  SELECT osm_id, unnest(names2array(tags))"name" FROM osm_point
);

INSERT INTO osm_names (
  SELECT osm_id, unnest(names2array(tags))"name" FROM osm_polygon
);

INSERT INTO osm_names (
  SELECT osm_id, unnest(names2array(tags))"name" FROM osm_line
);

