select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
 'bredning',
 'bugt',
 'fjord',
 'nor'
 )
and s.navn not in ('Limfjorden', 'Isefjord')
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'natural' in (
                                    'water',
                                    'bay',
                                    'strait'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality'
                                   )
                         OR defined(p.tags, 'seamark:sea_area:category')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n
		where (   p.tags -> 'natural' in (
                                    'water',
                                    'bay',
                                    'strait'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality'
                                   )
                         OR defined(p.tags, 'seamark:sea_area:category')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )

