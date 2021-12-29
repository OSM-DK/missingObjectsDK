
ALTER TABLE stednavne.farvand add column simple_geog geography;

UPDATE stednavne.farvand
  SET simple_geog = ST_SimplifyPreserveTopology(way, 0.01)::geography;

CREATE INDEX idx_stednavne_farvand_simple_geog ON stednavne.farvand USING gist(simple_geog);



ALTER TABLE stednavne.naturareal add column simple_geog geography;

UPDATE stednavne.naturareal
  SET simple_geog = ST_SimplifyPreserveTopology(way, 0.01)::geography;

CREATE INDEX idx_stednavne_naturareal_simple_geog ON stednavne.naturareal USING gist(simple_geog);

