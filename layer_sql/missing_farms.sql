select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'gård',
                      'herregård'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'building' IN ('farm')
                       OR p.tags -> 'historic' IN ('manor')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )

and not exists (select 1
                from osm_point p
		where (   p.tags -> 'building' IN ('farm')
                       OR p.tags -> 'historic' IN ('manor')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn OR p.tags -> 'addr:housename' = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 50 )
