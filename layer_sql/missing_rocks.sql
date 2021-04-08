select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
 'klippeIOverfladen',
 'overskylledeSten',
 'sten'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )

