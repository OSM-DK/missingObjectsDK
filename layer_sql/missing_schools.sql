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
                from osm_polygon p
		where p.tags -> 'amenity' in (
                                    'college',
			 	    'school',
				    'music_school',
                                    'language_school',
                                    'university',
                                    'research_institute')
		 AND (p.name = s.navn OR p.tags -> 'alt_name' = s.navn or p.tags -> 'old_name' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 1 )
and not exists (select 1
                from osm_point p
		where p.tags -> 'amenity' in (
                                    'college',
			 	    'school',
				    'music_school',
                                    'language_school',
                                    'university',
                                    'research_institute')
		 AND (p.name = s.navn OR p.tags -> 'alt_name' = s.navn OR p.tags -> 'old_name' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 1 )
