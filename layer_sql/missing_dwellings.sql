select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'bebyggelse',
                      'spredtBebyggelse'
                     )
and not exists (select 1
                from osm_polygon p
		where p.tags -> 'place' in (
                                  'town',
				  'village',
				  'hamlet',
                                  'locality',
				  'isolated_dwelling')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p
		where p.tags -> 'place' in (
                                  'town',
				  'village',
				  'hamlet',
                                  'locality',
				  'isolated_dwelling')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )
order by ST_XMin(s.way)

