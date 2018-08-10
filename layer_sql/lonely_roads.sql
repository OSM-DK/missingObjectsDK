select way, hstore_to_json(tags) as tags
from osm_line r
where name is not null
 and name <> ''
 and defined(tags, 'highway')
 and tags -> 'highway' not in ('motorway', 'motorway_link', 'trunk_link', 'primary_link', 'secondary_link', 'footway', 'path', 'cycleway', 'proposed', 'construction', 'track', 'primary')
 and not exists (select 1
                 from osm_point a
  		 where (r.name = a.tags -> 'addr:street') 
		 and ST_Distance(r.geog, a.geog) < 500 )
