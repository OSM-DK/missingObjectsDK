select way, ogc_fid, gml_id, objectid, navigationsanlaegstype, navn_1_skrivemaade as navn
from stednavne.navigationsanlaeg s
where
    not exists (select 1
                from stednavne_names sn, osm_polygon p
                LEFT JOIN osm_names n ON n.osm_id = p.osm_id
		
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR defined(p.tags, 'seamark:type')
                      )
		 AND (n.name = sn.name OR n.name || ' Fyr' = sn.name OR p.tags -> 'seamark:name' = sn.name OR p.tags -> 'seamark:name' || ' Fyr' = sn.name)
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from stednavne_names sn, osm_point p
                LEFT JOIN osm_names n ON n.osm_id = p.osm_id
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR defined(p.tags, 'seamark:type')
                      )
		 AND (n.name = sn.name OR n.name || ' Fyr' = sn.name OR p.tags -> 'seamark:name' = sn.name OR p.tags -> 'seamark:name' || ' Fyr' = sn.name)
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
