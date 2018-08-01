select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'akvarium',
                      'andenSeværdighed',
                      'arboret',
                      'batteri',
                      'bautasten',
                      'blomsterpark',
                      'botaniskHave',
                      'dyrepark',
                      'frilandsmuseum',
                      'friluftsgård',
                      'fæstningsanlæg',
                      'historiskMindeHistoriskAnlæg',
                      'mindesten',
                      'museumSamling',
                      'parkAnlæg',
                      'skanse',
                      'terrarium',
                      'udsigtspunkt',
                      'udsigtstårn',
                      'varde',
                      'forlystelsespark',
                      'turistbureau',
                      'zoologiskHave'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'amenity' IN ('planetarium')
                       OR p.tags -> 'leisure' IN ('garden', 'park')
                       OR p.tags -> 'tourism' IN ('aquarium',
                                                  'attraction',
                                                  'museum',
                                                  'information',
                                                  'theme_park',
                                                  'viewpoint',
                                                  'zoo'
                                                 )
                       OR p.tags -> 'historic' IN ('battlefield', 'canon', 'castle', 'fort', 'memorial', 'monument', 'pillory', 'rune_stone', 'citywalls', 'castle_wall'
                       OR p.tags -> 'man_made' IN ('tower', 'obelisk')
                       OR p.tags -> 'barrier'  IN ('city_wall')
                       OR p.tags -> 'building' IN ('conservatory', 'greenhouse')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )

and not exists (select 1
                from osm_point p
		where (   p.tags -> 'amenity' IN ('planetarium')
                       OR p.tags -> 'leisure' IN ('garden', 'park')
                       OR p.tags -> 'tourism' IN ('aquarium',
                                                  'attraction',
                                                  'museum',
                                                  'information',
                                                  'theme_park',
                                                  'viewpoint',
                                                  'zoo'
                                                 )
                       OR p.tags -> 'historic' IN ('battlefield', 'canon', 'castle', 'fort', 'memorial', 'monument', 'pillory', 'rune_stone', 'citywalls', 'castle_wall'
                       OR p.tags -> 'man_made' IN ('tower', 'obelisk')
                       OR p.tags -> 'barrier'  IN ('city_wall')
                       OR p.tags -> 'building' IN ('conservatory', 'greenhouse')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )
