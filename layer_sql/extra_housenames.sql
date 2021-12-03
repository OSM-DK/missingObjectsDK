select way, osm_id, hstore_to_json(p.tags) as tags, p.tags->'addr:housename' as override_display_name
 from osm_point p

where
     defined(p.tags, 'addr:housename')
     and not exists (select 1
                from stednavne.bygning s, stednavne_names sn
		where sn.gml_id = s.gml_id
                  and p.tags->'addr:housename' = sn.name
		  and ST_Distance(p.geog, s.geog) < 300 )

