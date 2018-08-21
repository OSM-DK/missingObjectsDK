select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'båke',
                      'fyr',
                      'fyrtårn',
                      'røse'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR defined(p.tags, 'seamark:type')
                      )
		 AND (p.names ? s.navn OR p.name || ' Fyr' = s.navn )
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p
		where (   p.tags -> 'man_made' in ('beacon', 'lighthouse')
                       OR defined(p.tags, 'seamark:type')
                      )
		 AND (p.names ? s.navn OR p.name || ' Fyr' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 100 )
