select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'brønd',
                      'dige',
                      'kraftvarmeværk',
                      'køretekniskAnlæg',
                      'observatorium',
                      'strandpost',
                      'søredningsstation',
                      'vandkraftværk',
                      'vandmølle',
                      'vejrmølle',
                      'vindmøllepark'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'man_made' in ('water_well', 'watermill', 'dyke', 'observatory', 'wind_mill')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'amenity' in ('driving_school', 'rescue_station')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )

and not exists (select 1
                from osm_point p
		where (   p.tags -> 'man_made' in ('water_well', 'watermill', 'dyke', 'observatory', 'wind_mill')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'amenity' in ('driving_school', 'rescue_station')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )

and not exists (select 1
                from osm_line p
		where (   p.tags -> 'man_made' in ('dyke')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )
