select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'agerMark',
                      'eng',
                      'hede',
                      'industiområde',
                      'kolonihave',
                      'nationalpark',
                      'naturareal',
                      'naturpark',
                      'reservat',
                      'skovPlantage',
                      'sommerhusområde',
                      'sommerhusområdedel',
                      'stenbrud'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'landuse' in ('farmland', 'farmyard', 'forest', 'meadow', 'industrial', 'allotments', 'quarry')
                       OR p.tags -> 'natural' in ('moor', 'heath', 'grassland', 'wood')
                       OR p.tags -> 'leisure' in ('nature_reserve')
                       OR p.tags -> 'boundary' in ('national_park', 'protected_area')
                      )
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p
		where (   p.tags -> 'landuse' in ('farmland', 'farmyard', 'forest', 'meadow', 'industrial', 'allotments', 'quarry')
                       OR p.tags -> 'natural' in ('moor', 'heath', 'grassland', 'wood')
                       OR p.tags -> 'leisure' in ('nature_reserve')
                       OR p.tags -> 'boundary' in ('national_park', 'protected_area')
                      )
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )
order by ST_XMin(s.way)

