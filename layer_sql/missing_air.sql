select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'flyveplads',
                      'heliport',
                      'mindreLufthavn',
                      'størreLufthavn',
                      'svæveflyveplads',
                      'terminal',
                      'landingsplads'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'aeroway' in ('aerodrome', 'helipad', 'heliport', 'runway', 'terminal')
                       OR p.tags -> 'amenity' in ('ferry_terminal', 'bus_station')
                       OR p.tags -> 'public_transport' in ('station', 'stop_area')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn OR p.name = s.navn || ' Flyveplads')
		 AND ST_Distance(p.geog, s.geog) < 100 )
