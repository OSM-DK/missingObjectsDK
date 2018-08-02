UPDATE stednavne SET way = ST_CurveToLine(way) where ST_GeometryType(way) = 'ST_CurvePolygon';

ALTER TABLE stednavne ADD COLUMN geog geography;
UPDATE stednavne set geog = way::geography;


CREATE INDEX idx_stednavne_navn ON stednavne (navn);
CREATE INDEX idx_stednavne_type ON stednavne (featuretype);
CREATE INDEX idx_stednavne_geog ON stednavne USING GIST(geog);
