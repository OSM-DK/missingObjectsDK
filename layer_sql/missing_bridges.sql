select way, ogc_fid, gml_id, objectid, andentopografitype, navn_1_skrivemaade as navn
from stednavne.andentopografipunkt s
where andentopografitype in (
                      'bro'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'bridge')
		       OR p.tags -> 'man_made' = 'bridge'
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'bridge')
		       OR p.tags -> 'man_made' = 'bridge'
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )


UNION

select way, ogc_fid, gml_id, objectid, jernbanetype, navn_1_skrivemaade as navn
from stednavne.jernbane s
where jernbanetype in (
                      'jernbanetunnel'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where defined(p.tags, 'tunnel')
                 AND n.osm_id = p.osm_id
		 AND (  n.name = sn.name
		      OR p.tags -> 'tunnel:name' = sn.name
		      OR p.tags -> 'tunnel:alt_name' = sn.name
		     )
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where defined(p.tags, 'tunnel')
                 AND n.osm_id = p.osm_id
		 AND (  n.name = sn.name
		      OR p.tags -> 'tunnel:name' = sn.name
		      OR p.tags -> 'tunnel:alt_name' = sn.name
		     )
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )


