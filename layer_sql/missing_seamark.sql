select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'båke',
                      'fyr',
                      'fyrtårn',
                      'røse'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR defined(p.tags, 'seamark:type')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = s.navn OR n.name || ' Fyr' = s.navn OR p.tags -> 'seamark:name' = s.navn OR p.tags -> 'seamark:name' || ' Fyr' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p, osm_names n
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR defined(p.tags, 'seamark:type')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = s.navn OR n.name || ' Fyr' = s.navn OR p.tags -> 'seamark:name' = s.navn OR p.tags -> 'seamark:name' || ' Fyr' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )
