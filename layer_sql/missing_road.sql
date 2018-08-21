select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
		      'ebbevej',
                      'ledLåge',
                      'låningsvej',
                      'motorvejskryds',
                      'parkeringsplads',
                      'plads',
                      'rastepladsMedService',
                      'rastepladsUdenService',
                      'sti',
                      'vej',
                      'vejkryds',
                      'vejstrækning'
                     )
and not exists (select 1
                from osm_polygon p
		where defined(p.tags, 'highway')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p
		where defined(p.tags, 'highway')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_point p
		where defined(p.tags, 'highway')
		 AND (p.names ? s.navn)
		 AND ST_Distance(p.geog, s.geog) < 300 )
