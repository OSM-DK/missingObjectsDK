ALTER TABLE redningsnumre ADD COLUMN geog geography;
UPDATE redningsnumre set geog = way::geography;

CREATE INDEX idx_redningsnumre_strandnr  ON redningsnumre (strandnr);
CREATE INDEX idx_redningsnumre_etableret ON redningsnumre (etableret);
CREATE INDEX idx_redningsnumre_geog      ON redningsnumre USING GIST(geog);
