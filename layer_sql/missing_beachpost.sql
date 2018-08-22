select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'strandpost'
                     )
and not exists (select 1
                from osm_point p
		where (   p.tags -> 'emergency' in ('access_point')
                       OR p.tags -> 'highway' in ('emergency_access_point' )
                      )
		 AND ( p.tags -> 'ref' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 300 )
