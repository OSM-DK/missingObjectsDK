select way, ogc_fid, gml_id, objectid, terraenkonturtype as featuretype, navn_1_skrivemaade as navn, 'terraenkontur' as featureclass
from stednavne.terraenkontur s
where
    not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (    p.tags -> 'man_made' in ('dyke', 'embankment')
                        OR defined(p.tags, 'embankment')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (    p.tags -> 'man_made' in ('dyke', 'embankment')
                        OR defined(p.tags, 'embankment')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (    p.tags -> 'man_made' in ('dyke', 'embankment')
                        OR defined(p.tags, 'embankment')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )
