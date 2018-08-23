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
                from osm_polygon p, osm_names n
		where defined(p.tags, 'highway')
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p, osm_names n
		where defined(p.tags, 'highway')
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_point p, osm_names n
		where defined(p.tags, 'highway')
                 AND n.osm_id = p.osm_id
		 AND ((n.name = s.navn) OR (n.name = 'Motorvejskryds ' || s.navn))
		 AND ST_Distance(p.geog, s.geog) < 700 )
