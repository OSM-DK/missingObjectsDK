select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in ('å', 'vandfald', 'dæmning', 'sluse', 'vandløb')
and not exists (select 1
                from osm_line p, osm_names n
		where (   p.tags -> 'waterway' in ('river', 'stream', 'riverbank', 'canal', 'waterfall', 'dam', 'lock_gate')
                       OR p.tags -> 'lock' = 'yes'
                       OR p.tags -> 'water' = 'lock'
                       OR defined(p.tags, 'embankment')
                       OR p.tags -> 'man_made' IN ('embankment')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = s.navn OR p.tags -> 'lock_name' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )

and not exists (select 1
                from osm_point p, osm_names n
		where p.waterway in ('waterfall', 'dam', 'lock_gate')
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 50 )
