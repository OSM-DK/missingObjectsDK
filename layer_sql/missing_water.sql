select way, ogc_fid, gml_id, objectid, andentopografitype, navn_1_skrivemaade as navn
from stednavne.andentopografipunkt s
where andentopografitype in ('vandfald', 'sluse')
and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'waterway' in ('waterfall', 'dam', 'lock_gate')
                       OR defined(p.tags, 'lock')
                       OR p.tags -> 'water' = 'lock'
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where p.waterway in ('waterfall', 'dam', 'lock_gate')
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )
