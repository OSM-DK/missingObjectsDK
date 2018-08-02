select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'cykelbane',
                      'goKartbane',
                      'golfbane',
                      'hal',
                      'hestevæddeløbsbane',
                      'hundevæddeløbsbane',
                      'motocrossbane',
                      'motorbane',
                      'skydebane',
                      'stadion'
                     )
and not exists (select 1
                from osm_polygon p
		where (   (p.tags -> 'sport' IS NOT NULL AND p.tags -> 'sport' <> '')
                       OR p.tags -> 'building' = 'stadium'
                       or p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )

and not exists (select 1
                from osm_point p
		where (   (p.tags -> 'sport' IS NOT NULL AND p.tags -> 'sport' <> '')
                       OR p.tags -> 'building' = 'stadium'
                       or p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )
