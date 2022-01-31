select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as navn, 'bygning' as featureclass
from stednavne.bygning s
where bygningstype in ('efterskoleUngdomsskole',
                      'fagskole',
                      'folkehøjskole',
                      'folkeskole',
                      'forskningscenter',
                      'gymnasium',
                      'kursuscenter',
                      'privatskoleFriskole',
                      'proffesionshøjskole',
                      'specialskole',
                      'uddannelsescenter',
                      'universitet')
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where p.tags -> 'amenity' in (
                                    'college',
			 	    'school',
				    'music_school',
                                    'language_school',
                                    'university',
                                    'research_institute')
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )
and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where p.tags -> 'amenity' in (
                                    'college',
			 	    'school',
				    'music_school',
                                    'language_school',
                                    'university',
                                    'research_institute')
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )
