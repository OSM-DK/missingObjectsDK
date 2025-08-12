select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as navn, 'bygning' as featureclass
from stednavne.bygning s
where bygningstype in (
                      'andenBygning',
                      'hus',
                      'slot'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where
		 (   defined(p.tags, 'building')
		  OR p.tags->'amenity' IN ('community_centre')
		  OR p.tags->'healthcare' IN ('centre')
		  OR p.tags->'landuse' IN ('farmyard')
		 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50
	       )
and not exists (select 1
                from stednavne_names sn, osm_point a
		LEFT OUTER JOIN osm_names n ON (n.osm_id = a.osm_id)
		where (  sn.name = a.tags-> 'addr:housename'
		       OR (    n.name = sn.name
		           AND (   defined(a.tags, 'building')
   		                OR a.tags->'amenity' IN ('community_centre')
		                OR a.tags->'healthcare' IN ('centre')
		                OR a.tags->'landuse' IN ('farmyard')
			       )
		          )
	              )

		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(a.geog, s.geog) < 50
	       )
