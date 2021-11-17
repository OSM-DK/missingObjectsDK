select way, ogc_fid, gml_id, objectid, landskabsformtype, areal, navn_1_skrivemaade as navn
from stednavne.landskabsform s
where landskabsformtype in ('ø', 'skær', 'øgruppe')
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'place' in ('island', 'islet', 'archipelago')
                       OR p.tags -> 'natural' in ('shoal', 'peninsula', 'wetland')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 40 )
