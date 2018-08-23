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
                       OR p.tags -> 'amenity' in ('grave_yard')
                       OR p.tags -> 'landuse' in ('cemetary')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = s.navn OR n.name || 'gård' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )
and not exists (select 1
                from osm_point p, osm_names n
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('grave_yard')
                       OR p.tags -> 'landuse' in ('cemetary')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = s.navn OR n.name || 'gård' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )
