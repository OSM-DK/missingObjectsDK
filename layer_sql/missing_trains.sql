select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'tog',
                      'veteranjernbane'
                     )
and not exists (select 1
                from osm_polygon p
		where p.tags -> 'railway' IN ('narrow_gauge', 'preserved', 'rail', 'subway', 'light_rail', 'disused', 'abandoned')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )

and not exists (select 1
                from osm_line p
		where p.tags -> 'railway' IN ('narrow_gauge', 'preserved', 'rail', 'subway', 'light_rail', 'disused', 'abandoned')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )
