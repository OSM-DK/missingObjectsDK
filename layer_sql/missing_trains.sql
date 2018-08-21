select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'tog',
                      'veteranjernbane'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'railway' IN ('narrow_gauge', 'preserved', 'rail', 'subway', 'light_rail', 'disused', 'abandoned', 'station', 'halt')
                       OR p.tags -> 'building' IN ('station')
                       OR p.tags -> 'public_transport' IN ('station')
                      )
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_line p
		where p.tags -> 'railway' IN ('narrow_gauge', 'preserved', 'rail', 'subway', 'light_rail', 'disused', 'abandoned')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_point p
		where (   p.tags -> 'railway' IN ('halt', 'station')
                       OR p.tags -> 'public_transport' IN ('station')
                      )
		 AND (p.names ? s.navn OR s.navn = p.name || ' Station')
		 AND ST_Distance(p.geog, s.geog) < 500 )
