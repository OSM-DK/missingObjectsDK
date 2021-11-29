select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as navn, 'bygning' as featureclass
from stednavne.bygning s
where bygningstype in (
                      'akvarium',
                      'friluftsgård',
                      'museumSamling',
                      'terrarium',
                      'turistbureau'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'amenity' IN ('planetarium')
                       OR p.tags -> 'tourism' IN ('aquarium',
                                                  'attraction',
                                                  'museum',
                                                  'information',
                                                  'zoo'
                                                 )
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'amenity' IN ('planetarium')
                       OR p.tags -> 'tourism' IN ('aquarium',
                                                  'attraction',
                                                  'museum',
                                                  'information',
                                                  'zoo'
                                                 )
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )


UNION

select way, ogc_fid, gml_id, objectid, sevaerdighedstype as featuretype, navn_1_skrivemaade as navn, 'sevaerdighed' as featureclass
from stednavne.sevaerdighed s
where sevaerdighedstype in (
                      'andenSeværdighed',
                      'arboret',
                      'blomsterpark',
                      'botaniskHave',
                      'dyrepark',
                      'frilandsmuseum',
                      'forlystelsespark',
                      'zoologiskHave'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'amenity' IN ('planetarium')
                       OR p.tags -> 'leisure' IN ('garden', 'park')
                       OR p.tags -> 'tourism' IN ('attraction',
                                                  'museum',
                                                  'theme_park',
                                                  'zoo'
                                                 )
                       OR p.tags -> 'building' IN ('conservatory', 'greenhouse')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'amenity' IN ('planetarium')
                       OR p.tags -> 'leisure' IN ('garden', 'park')
                       OR p.tags -> 'tourism' IN ('attraction',
                                                  'museum',
                                                  'theme_park',
                                                  'zoo'
                                                 )
                       OR p.tags -> 'building' IN ('conservatory', 'greenhouse')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )


UNION

select way, ogc_fid, gml_id, objectid, fortidsmindetype as featuretype, navn_1_skrivemaade as navn, 'fortidsminde' as featureclass
from stednavne.fortidsminde s
where fortidsmindetype in (
                      'batteri',
                      'bautasten',
                      'fæstningsanlæg',
                      'historiskMindeHistoriskAnlæg',
                      'skanse'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' IN ('attraction',
                                                  'museum'
                                                 )
                       OR p.tags -> 'historic' IN ('battlefield', 'canon', 'castle', 'fort', 'memorial', 'monument', 'pillory', 'rune_stone', 'citywalls', 'castle_wall')
                       OR p.tags -> 'man_made' IN ('obelisk')
                       OR p.tags -> 'barrier'  IN ('city_wall')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' IN ('attraction',
                                                  'museum'
                                                 )
                       OR p.tags -> 'historic' IN ('battlefield', 'canon', 'castle', 'fort', 'memorial', 'monument', 'pillory', 'rune_stone', 'citywalls', 'castle_wall')
                       OR p.tags -> 'man_made' IN ('obelisk')
                       OR p.tags -> 'barrier'  IN ('city_wall')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )


UNION

select way, ogc_fid, gml_id, objectid, andentopografitype as featuretype, navn_1_skrivemaade as navn, 'andentopografipunkt' as featureclass
from stednavne.andentopografipunkt s
where andentopografitype in (
		      'gravsted',
                      'mindesten',
                      'udsigtspunkt',
                      'udsigtstårn',
                      'varde'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' IN ('attraction',
                                                  'viewpoint'
                                                 )
                       OR p.tags -> 'historic' IN ('memorial', 'monument', 'pillory', 'rune_stone')
                       OR p.tags -> 'man_made' IN ('tower', 'obelisk')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' IN ('attraction',
                                                  'viewpoint'
                                                 )
                       OR p.tags -> 'historic' IN ('memorial', 'monument', 'pillory', 'rune_stone')
                       OR p.tags -> 'man_made' IN ('tower', 'obelisk')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 200 )
