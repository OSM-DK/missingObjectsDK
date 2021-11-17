select way, ogc_fid, gml_id, objectid, havnebassintype, navn_1_skrivemaade as navn
from stednavne.havnebassin s
where
not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'leisure' in ('marina')
                       OR p.tags -> 'landuse' in ('harbour', 'port')
                       OR p.tags -> 'industrial' IN ('port')
                       OR p.tags -> 'military' IN ('naval_base')
                       OR defined(p.tags, 'harbour')
                       OR p.tags -> 'seamark:type' = 'harbour'
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50
                )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'leisure' in ('marina')
                       OR p.tags -> 'landuse' in ('harbour', 'port')
                       OR p.tags -> 'industrial' IN ('port')
                       OR p.tags -> 'military' IN ('naval_base')
                       OR defined(p.tags, 'harbour')
                       OR p.tags -> 'seamark:type' = 'harbour' 
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50
               )
