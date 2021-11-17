select way, ogc_fid, gml_id, objectid, friluftsbadtype, navn_1_skrivemaade as  navn
from stednavne.friluftsbad s
where
   not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'sport' = 'swimming'
                       OR p.tags -> 'leisure' IN ('sports_centre', 'swimming_pool')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'sport' = 'swimming'
                       OR p.tags -> 'leisure' IN ('sports_centre', 'swimming_pool', 'sports_hall')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'sport' = 'swimming'
                       OR p.tags -> 'leisure' IN ('sports_centre', 'swimming_pool', 'sports_hall')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )
