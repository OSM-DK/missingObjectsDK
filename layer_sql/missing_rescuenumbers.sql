select way,
       ogc_fid,
       gml_id,
       id,
       strandnr,
       opdateretdatotid,
       objekttypeid,
       objekttypenavn as featuretype,
       etableret,
       bemaerkning,
       'redningsnummer' as featureclass
from redningsnumre s
where etableret > 0
  AND not exists (select 1
                from osm_point p
                LEFT JOIN osm_names n ON n.osm_id = p.osm_id
		where (   p.tags -> 'emergency' in ('access_point')
                       OR p.tags -> 'highway' in ('emergency_access_point' )
                      )
		 AND ( p.tags -> 'ref' = s.strandnr OR n.name = s.strandnr)
		 AND ST_Distance(p.geog, s.geog) < 300 )
