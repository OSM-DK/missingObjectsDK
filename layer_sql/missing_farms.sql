select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'gård',
                      'herregård'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.building IN ('farm')
                       OR p.historic IN ('manor')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 10 )

and not exists (select 1
                from osm_point p
		where (   p.building IN ('farm')
                       OR p.historic IN ('manor')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 10 )
