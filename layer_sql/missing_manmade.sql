select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'brønd',
                      'dige',
                      'kraftvarmeværk',
                      'køretekniskAnlæg',
                      'observatorium',
                      'søredningsstation',
                      'vandkraftværk',
                      'vandmølle',
                      'vejrmølle',
                      'vindmøllepark'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'man_made' in ('water_well', 'watermill', 'dyke', 'observatory', 'wind_mill')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'amenity' in ('driving_school', 'rescue_station')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n
		where (   p.tags -> 'man_made' in ('water_well', 'watermill', 'dyke', 'observatory', 'wind_mill')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'amenity' in ('driving_school', 'rescue_station')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_line p, osm_names n
		where (   p.tags -> 'man_made' in ('dyke')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 20 )
