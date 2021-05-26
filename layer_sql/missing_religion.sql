select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'andenReligion',
                      'jødisk',
                      'kirkeAndenKristen',
                      'kirkeProtestantisk',
                      'kristen',
                      'moske',
                      'muslimsk',
                      'synagoge'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('grave_yard', 'place_of_worship')
                       OR p.tags -> 'landuse' in ('cemetery')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = s.navn OR n.name || 'gård' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p, osm_names n
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('grave_yard', 'place_of_worship')
                       OR p.tags -> 'landuse' in ('cemetery')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = s.navn OR n.name || 'gård' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )
