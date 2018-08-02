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
                from osm_polygon p
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('grave_yard')
                       OR p.tags -> 'landuse' in ('cemetary')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )
and not exists (select 1
                from osm_point p
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('grave_yard')
                       OR p.tags -> 'landuse' in ('cemetary')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )
