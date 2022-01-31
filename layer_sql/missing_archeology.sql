select way, ogc_fid, gml_id, objectid, fortidsmindetype as featuretype, navn_1_skrivemaade as navn, 'fortidsminde' as featureclass
from stednavne.fortidsminde s
where
 not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (     p.tags-> 'historic' in (
                                     'archaeological_site',
                                     'battlefield',
                                     'building',
				     'canon',
                                     'castle',
				     'caste_wall',
				     'citywalls',
				     'fort',
                                     'memorial',
				     'monument',
                                     'milestone',
				     'pillory',
                                     'ruins',
                                     'rune_stone',
                                     'tomb',
                                     'yes'
                                     )
		       OR  p.tags -> 'tourism' IN ('attraction',
                                                   'museum'
                                                  )
                       OR p.tags -> 'man_made' IN ('obelisk')
                       OR p.tags -> 'barrier'  IN ('city_wall')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100
                )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (     p.tags-> 'historic' in (
                                     'archaeological_site',
                                     'battlefield',
                                     'building',
				     'canon',
                                     'castle',
				     'caste_wall',
				     'citywalls',
				     'fort',
                                     'memorial',
				     'monument',
                                     'milestone',
				     'pillory',
                                     'ruins',
                                     'rune_stone',
                                     'tomb',
                                     'yes'
                                     )
		       OR  p.tags -> 'tourism' IN ('attraction',
                                                   'museum'
                                                  )
                       OR p.tags -> 'man_made' IN ('obelisk')
                       OR p.tags -> 'barrier'  IN ('city_wall')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100
                )
