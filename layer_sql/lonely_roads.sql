select way, osm_id, hstore_to_json(tags) as tags
from osm_line r
where r.name is not null
 and r.name <> ''
 and r.highway in ('secondary', 'tertiary', 'unclassified', 'residential', 'living_street', 'pedestrian')
 and r.bridge is null
 and not exists (select 1
                 from osm_point a, osm_names n
  		 where n.osm_id = r.osm_id
                 and (n.name = a."addr:street") 
		 and ST_DWithin(r.geog, a.geog, 500)
		)
