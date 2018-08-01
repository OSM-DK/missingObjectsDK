select way, tags
from line r
where name is not null
 and name <> ''
 and defined(tags, 'highway')
 and tags -> 'highway' not in ('motorway', 'motorway_link', 'trunk_link', 'primary_link', 'secondary_link')
 and not exists (select 1
                 from osm_point a
  		 where (r.name = a.tags -> 'addr:street') 
		 and ST_Distance(r.way::geography, a.way::geography) < 500 )
