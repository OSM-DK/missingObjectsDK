select way, ogc_fid, gml_id, objectid, campingpladstype as featuretype, navn_1_skrivemaade as navn, 'campingplads' as featureclass
from stednavne.campingplads s
where 
    not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' in ('camp_site', 'caravan_site', 'chalet', 'resort')
                       OR p.tags -> 'amenity' in ('resort', 'beach_resort')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' in ('camp_site', 'caravan_site', 'chalet', 'resort')
                       OR p.tags -> 'amenity' in ('resort', 'beach_resort')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
