select way, ogc_fid, gml_id, objectid, vandloebstype as featuretype, navn_1_skrivemaade as navn, 'vandloeb' as featureclass
from stednavne.vandloeb s
where
   not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'waterway' in ('river', 'stream', 'riverbank', 'canal')
                       OR defined(p.tags, 'embankment')
                       OR p.tags -> 'man_made' IN ('embankment')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )
