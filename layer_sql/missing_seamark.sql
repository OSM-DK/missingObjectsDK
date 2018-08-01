select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'båke',
                      'fyr',
                      'fyrtårn',
                      'røse'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR (p.tags -> 'seamark:type' IS NOT NULL AND p.tags -> 'seamark:type' <> '')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 1 )
and not exists (select 1
                from osm_point p
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR (p.tags -> 'seamark:type' IS NOT NULL AND p.tags -> 'seamark:type' <> '')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 1 )
