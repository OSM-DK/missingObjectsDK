select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'bro',
                      'vejbro'
                     )
and not exists (select 1
                from osm_polygon p
		where p.bridge is not null and p.bridge <> ''
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 1 )
and not exists (select 1
                from osm_roads p
		where p.bridge is not null and p.bridge <> ''
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 1 )


UNION

select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'jernbanetunnel',
                      'vejtunnel'
                     )
and not exists (select 1
                from osm_polygon p
		where p.tunnel is not null and p.tunnel <> ''
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 1 )
and not exists (select 1
                from osm_roads p
		where p.tunnel is not null and p.tunnel <> ''
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 1 )


