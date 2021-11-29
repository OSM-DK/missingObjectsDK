select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as navn, 'bygning' as featureclass
from stednavne.bygning s
where bygningstype in (
                      'feriecenter',
                      'hotel',
                      'vandrerhjem'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' in ('camp_site', 'caravan_site', 'chalet', 'guest_house', 'hostel', 'hotel', 'motel', 'resort')
                       OR p.tags -> 'amenity' in ('resort', 'beach_resort')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'tourism' in ('camp_site', 'caravan_site', 'chalet', 'guest_house', 'hostel', 'hotel', 'motel', 'resort')
                       OR p.tags -> 'amenity' in ('resort', 'beach_resort')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
