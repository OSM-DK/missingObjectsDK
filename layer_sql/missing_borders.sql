select way, ogc_fid, gml_id, objectid, andentopografitype, navn_1_skrivemaade as navn, areal
from stednavne.andentopografiflade s
where andentopografitype in (
                      'landsdel'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'place' in ('peninsula', 'locality', 'island')
                       OR defined(p.tags, 'boundary')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100
               )
