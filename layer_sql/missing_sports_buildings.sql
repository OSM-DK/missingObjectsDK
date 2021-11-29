select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as  navn, 'bygning' as featureclass
from stednavne.bygning s
where
   bygningstype in (
                     'hal'
                    )
and
   not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'building' = 'stadium'
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool', 'sports_hall')
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
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool', 'sports_hall')
                       OR p.tags -> 'club' IN ('sport')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'sport')
                       OR p.tags -> 'leisure' IN ('stadium', 'pitch', 'sports_centre', 'track', 'swimming_pool', 'sports_hall')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )
