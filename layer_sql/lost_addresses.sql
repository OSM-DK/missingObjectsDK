select way, tags
from osm_point a
where defined(tags, 'addr:street')
and not exists (select 1
                from osm_line r
		where (r.name = a.tags -> 'addr:street') 
		AND ST_Distance(r.way::geography, a.way::geography) < 500 )
