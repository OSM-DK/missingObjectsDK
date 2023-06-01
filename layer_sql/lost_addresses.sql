select way, osm_id, hstore_to_json(tags) as tags
from osm_point a
where "addr:street" is not null
and not exists (select 1
                from osm_line r
                inner join osm_names n on n.osm_id = r.osm_id
		where (n.name = a."addr:street")
		AND ST_DWithin(r.geog, a.geog, 500)
	       )
