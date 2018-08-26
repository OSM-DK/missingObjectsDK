select way,
       ogc_fid,
       gml_id,
       id,
       strandnr,
       opdateretdatotid,
       objekttypeid,
       objekttypenavn,
       etableret,
       bemaerkning
from redningsnumre s
where etableret > 0
  AND not exists (select 1
                from osm_point p, osm_names n
		where (   p.tags -> 'emergency' in ('access_point')
                       OR p.tags -> 'highway' in ('emergency_access_point' )
                      )
		 AND n.osm_id = p.osm_id
		 AND ( p.tags -> 'ref' = s.strandnr OR n.name = s.strandnr)
		 AND ST_Distance(p.geog, s.geog) < 300 )
