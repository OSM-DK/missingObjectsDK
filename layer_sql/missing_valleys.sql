select way, ogc_fid, gml_id status, landskabsformtype as featuretype, areal, navn_1_skrivemaade as navn, id_namespace, id_lokalid, 'landskabsform' as featureclass
from stednavne.landskabsform s
where landskabsformtype in (
 'dal',
 'kløft',
 'slugt',
 'lavning'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'valley'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality'
                                   )
                 )
                 AND n.osm_id = p.osm_id
 		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'valley'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )


and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'valley'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )
