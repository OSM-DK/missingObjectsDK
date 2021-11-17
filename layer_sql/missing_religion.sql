select way, ogc_fid, gml_id, objectid, bygningstype, navn_1_skrivemaade as navn
from stednavne.bygning s
where bygningstype in (
                      'kirkeAndenKristen',
                      'kirkeProtestantisk',
                      'moske',
                      'synagoge'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('place_of_worship')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('place_of_worship')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
	         AND ST_Distance(p.geog, s.geog) < 100 )
