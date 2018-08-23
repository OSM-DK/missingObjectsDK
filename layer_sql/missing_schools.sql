select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in ('efterskoleUngdomsskole',
                      'fagskole',
                      'folkehøjskole',
                      'folkeskole',
                      'forskningscenter',
                      'gymnasium',
                      'kursuscenter',
                      'privatskoleFriskole',
                      'proffesionshøjskole',
                      'specialskole',
                      'uddannelsescenter'
                      'universitet')
and not exists (select 1
                from osm_polygon p, osm_names n
		where p.tags -> 'amenity' in (
                                    'college',
			 	    'school',
				    'music_school',
                                    'language_school',
                                    'university',
                                    'research_institute')
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )
and not exists (select 1
                from osm_point p, osm_names n
		where p.tags -> 'amenity' in (
                                    'college',
			 	    'school',
				    'music_school',
                                    'language_school',
                                    'university',
                                    'research_institute')
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )
