select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in ('å', 'vandfald')
and not exists (select 1
                from osm_line p
		where p.waterway in ('river', 'stream', 'riverbank', 'canal', 'waterfall')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 100 )
