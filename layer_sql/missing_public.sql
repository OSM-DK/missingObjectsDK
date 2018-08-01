select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
 		      'daginstitution',
 		      'fængsel',
                      'hospital',
                      'kommunekontor',
                      'regionsgård',
                      'rådhus',
                      'skadestue'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'amenity' in ( 'prison',
                                                   'kindergarten',
                                                   'hospital',
				   	           'social_facility',
					           'townhall'
					          )
                       OR p.tags -> 'emergency' in ( 'emergency_ward_entrance' )
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )

and not exists (select 1
                from osm_point p
		where (   p.tags -> 'amenity' in ( 'prison',
                                                   'kindergarten',
                                                   'hospital',
				   	           'social_facility',
					           'townhall'
					          )
                       OR p.tags -> 'emergency' in ( 'emergency_ward_entrance' )
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 20 )
