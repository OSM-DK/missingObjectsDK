select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as navn, 'bygning' as featureclass
from stednavne.bygning s
where bygningstype in (
                      'gård',
                      'herregård'
                     )
and not exists (select 1
                from stednavne_names sn, osm_polygon p
                LEFT JOIN osm_names n ON n.osm_id = p.osm_id
		where (   p.tags -> 'building' IN ('farm', 'yes')
                       OR p.tags -> 'historic' IN ('manor')
                       OR p.tags -> 'landuse' IN ('farmyard')
                      )
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from stednavne_names sn, osm_point p
                LEFT JOIN osm_names n ON n.osm_id = p.osm_id
		where (    p.tags -> 'building' IN ('farm', 'yes')
                        OR p.tags -> 'historic' IN ('manor')
                      )
                 AND ( n.name = sn.name OR p.tags -> 'addr:housename' = sn.name )
                 AND sn.gml_id = s.gml_id
                 AND ST_Distance(p.geog, s.geog) < 50 )

