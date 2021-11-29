select way, ogc_fid, gml_id, objectid, idraetsanlaegstype as featuretype, navn_1_skrivemaade as  navn, 'idraetsanlaeg' as featureclass
from stednavne.idraetsanlaeg s
where
   not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'building' = 'stadium'
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool', 'sports_hall', 'golf_course')
                       OR p.tags -> 'highway' IN ('racetrack')
                       OR p.tags -> 'club' IN ('sport')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'building' = 'stadium'
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool', 'sports_hall', 'golf_course')
                       OR p.tags -> 'highway' IN ('racetrack')
                       OR p.tags -> 'club' IN ('sport')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool', 'sports_hall', 'golf_course')
                       OR p.tags -> 'highway' IN ('racetrack')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )
