select way, ogc_fid, gml_id, objectid, landskabsformtype, areal, navn_1_skrivemaade as navn
from stednavne.landskabsform s
where landskabsformtype in (
 'hage',
 'halvø',
 'odde',
 'pynt',
 'tange',
 'næs'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'sand',
                                    'cape',
                                    'isthmus',
                                    'peninsula',
                                    'reef'
                                   )
                         OR p.tags -> 'place' in (
                                    'peninsula', 'locality'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'sand',
                                    'cape',
                                    'isthmus',
                                    'peninsula',
                                    'reef'
                                   )
                         OR p.tags -> 'place' in (
                                    'peninsula', 'locality'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )


and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'sand',
                                    'cape',
                                    'isthmus',
                                    'peninsula',
                                    'reef'
                                   )
                         OR p.tags -> 'place' in (
                                    'peninsula', 'locality'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
