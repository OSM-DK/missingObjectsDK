select way, osm_id, hstore_to_json(tags) as tags
from osm_point a
where a."addr:street" IS NOT NULL
  and a."addr:housenumber" IS NOT NULL
  and a."addr:postcode" IS NOT NULL
  and a."addr:country" IS NOT NULL
  and exists (select 1
            from osm_point b
   	    where b."addr:street" = a."addr:street"
	      and b."addr:housenumber" = a."addr:housenumber"
	      and b."addr:postcode" = a."addr:postcode"
	      and b."addr:country" = a."addr:country"
	      and b.osm_id <> a.osm_id
	   )
