select way, hstore_to_json(tags) as tags
from osm_point p
where defined(p.tags, 'ref')
 and p.tags -> 'emergency' = 'access_point'
 and exists (select 1
             from osm_point q
              where p.tags -> 'ref' = q.tags -> 'ref'
                and q.tags -> 'emergency' = 'access_point'
                and q.osm_id <> p.osm_id
             )
