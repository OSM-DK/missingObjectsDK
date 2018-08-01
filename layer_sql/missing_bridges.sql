select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'bro',
                      'vejbro'
                     )
and not exists (select 1
                from osm_polygon p
		where defined(p.tags, 'bridge')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 1 )

and not exists (select 1
                from osm_line p
		where defined(p.tags, 'bridge')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 50 )


UNION

select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'jernbanetunnel',
                      'vejtunnel'
                     )
and not exists (select 1
                from osm_polygon p
		where defined(p.tags, 'tunnel')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 1 )
and not exists (select 1
                from osm_line p
		where defined(p.tags, 'tunnel')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way::geography, s.way::geography) < 1 )


