select way, ogc_fid, gml_id, objectid, begravelsespladstype, navn_1_skrivemaade as navn, areal
from stednavne.begravelsesplads s
where
    not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('grave_yard', 'place_of_worship')
                       OR p.tags -> 'landuse' in ('cemetery')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = sn.name OR n.name || 'gård' = sn.name)
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'religion')
                       OR p.tags -> 'amenity' in ('grave_yard', 'place_of_worship')
                       OR p.tags -> 'landuse' in ('cemetery')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = sn.name OR n.name || 'gård' = sn.name)
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
