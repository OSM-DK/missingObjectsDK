select way, hstore_to_json(tags) as tags
from osm_line r
where name is not null
 and name <> ''
 and tags -> 'highway' in ('secondary', 'tertiary', 'unclassified', 'residential', 'living_street', 'pedestrian')
 and not defined(tags, 'bridge')
 and not exists (select 1
                 from osm_point a
  		 where (r.name = a.tags -> 'addr:street') 
		 and ST_Distance(r.geog, a.geog) < 500 )
