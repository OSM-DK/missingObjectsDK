select way, ogc_fid, gml_id, objectid, landskabsformtype as featuretype, navn_1_skrivemaade as navn, 'landskabsform' as featureclass
from stednavne.landskabsform s
where landskabsformtype in (
 'hule'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'cave',
                                    'cave_entrance'
                                   )
                         OR p.tags -> 'historic' in (
                                    'mine'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'cave',
                                    'cave_entrance'
                                   )
                         OR p.tags -> 'historic' in (
                                    'mine'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'cave',
                                    'cave_entrance'
                                   )
                         OR p.tags -> 'historic' in (
                                    'mine'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )
