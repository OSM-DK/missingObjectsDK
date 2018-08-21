select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'bro',
                      'vejbro'
                     )
and not exists (select 1
                from osm_polygon p
		where defined(p.tags, 'bridge')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 1 )

and not exists (select 1
                from osm_line p
		where defined(p.tags, 'bridge')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50 )


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
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 1 )
and not exists (select 1
                from osm_line p
		where defined(p.tags, 'tunnel')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 1 )


