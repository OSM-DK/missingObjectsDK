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
                      'sommerhusområdedel'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.landuse in ('farmland', 'farmyard', 'forest', 'meadow', 'industrial', 'allotments')
                       OR p.natural in ('moor', 'heath', 'grassland', 'wood')
                       OR p.leisure in ('nature_reserve')
                       OR p.boundary in ('national_park', 'protected_area')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 1 )
