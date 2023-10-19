select way, ogc_fid, gml_id, objectid, bebyggelsestype as featuretype, navn_1_skrivemaade as navn, areal, indbyggertal, 'bebyggelse' as featureclass
from stednavne.bebyggelse s
where bebyggelsestype in (
                      'by',
                      'bydel'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (p.tags -> 'place' in (
                                  'city',
                                  'borough',
                                  'suburb',
                                  'quarter',
                                  'neighbourhood',
                                  'city_block',
                                  'town',
				  'village',
				  'hamlet'
                                  )
                      OR (p.tags -> 'place' = 'isolated_dwelling'
                          AND s.areal < 80000)
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (p.tags -> 'place' in (
                                  'city',
                                  'borough',
                                  'suburb',
                                  'quarter',
                                  'neighbourhood',
                                  'city_block',
                                  'town',
				  'village',
				  'hamlet'
                                 )
                     OR (p.tags -> 'place' = 'isolated_dwelling'
                          AND s.areal < 80000)
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 500 )
