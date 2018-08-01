select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'by',
                      'bydel',
                      'bebyggelse',
                      'spredtBebyggelse'
                     )
and not exists (select 1
                from osm_polygon p
		where p.tags -> 'place' in (
                                  'city',
                                  'borough',
                                  'suburb',
                                  'quarter',
                                  'neighborhood',
                                  'city_block',
                                  'town',
				  'village',
				  'hamlet',
				  'isolated_dwelling')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 1 )
and not exists (select 1
                from osm_point p
		where p.tags -> 'place' in (
                                  'city',
                                  'borough',
                                  'suburb',
                                  'quarter',
                                  'neighborhood',
                                  'city_block',
                                  'town',
				  'village',
				  'hamlet',
				  'isolated_dwelling')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 1 )
