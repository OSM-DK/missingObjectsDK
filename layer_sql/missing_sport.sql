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
                      'stadion',
                      'land'        -- Apparently, "land" means swimming pools "Friluftsbad"
                     )
and not exists (select 1
                from osm_polygon p
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'building' = 'stadium'
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool')
                       OR p.tags -> 'highway' IN ('racetrack')
                      )
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_point p
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'building' = 'stadium'
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool')
                       OR p.tags -> 'highway' IN ('racetrack')
                      )
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'leisure' IN ('pitch', 'track')
                       OR p.tags -> 'highway' IN ('racetrack')
                      )
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 300 )
