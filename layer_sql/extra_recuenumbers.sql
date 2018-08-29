select way, hstore_to_json(tags) as tags
from osm_point p
where (   p.tags -> 'emergency' in ('access_point')
       OR p.tags -> 'highway' in ('emergency_access_point' )
      )
  AND NOT EXISTS (select 1
                  from redningsnumre s
                  where etableret > 0
		  AND ( p.tags -> 'ref' = s.strandnr OR p.tags -> 'name' = s.strandnr)
		  AND ST_Distance(p.geog, s.geog) < 300
                 )
