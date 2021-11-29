select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as navn, 'bygning' as featureclass
from stednavne.bygning s
where bygningstype in (
 		      'daginstitution',
 		      'fængsel',
                      'hospital',
                      'kommunekontor',
                      'regionsgård',
                      'rådhus',
                      'skadestue'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'amenity' in ( 'prison',
                                                   'kindergarten',
                                                   'hospital',
				   	           'social_facility',
					           'townhall'
					          )
                       OR p.tags -> 'emergency' in ( 'emergency_ward_entrance' )
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'amenity' in ( 'prison',
                                                   'kindergarten',
                                                   'hospital',
				   	           'social_facility',
					           'townhall'
					          )
                       OR p.tags -> 'emergency' in ( 'emergency_ward_entrance' )
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )
