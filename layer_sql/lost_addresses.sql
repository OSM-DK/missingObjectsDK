select way, osm_id, hstore_to_json(tags) as tags
from osm_point a
where "addr:street" is not null
and not exists (select 1
                from osm_line r
		where (r.name = a."addr:street") 
		AND ST_Distance(r.geog, a.geog) < 500 )
