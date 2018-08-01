select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'landsdel'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.place in ('pensinsula')
                       OR (p.boundary IS NOT NULL AND p.boundary <> '')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 100
               )
