select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in ('å', 'vandfald', 'dæmning', 'sluse')
and not exists (select 1
                from osm_line p
		where (   p.tags -> 'waterway' in ('river', 'stream', 'riverbank', 'canal', 'waterfall', 'dam', 'lock_gate')
                       OR p.tags -> 'lock' = 'yes'
                       OR p.tags -> 'water' = 'lock'
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn OR p.tags -> 'lock_name' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )

and not exists (select 1
                from osm_point p
		where p.waterway in ('waterfall', 'dam', 'lock_gate')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )
