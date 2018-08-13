select way, hstore_to_json(tags) as tags
from osm_point a
where defined(tags, 'addr:street')
and not exists (select 1
                from osm_line r
		where (r.name = a.tags -> 'addr:street') 
		AND ST_Distance(r.geog, a.geog) < 500 )
order by ST_XMin(a.geog)
