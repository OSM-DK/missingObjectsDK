select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'gård',
                      'herregård'
                     )
and not exists (select 1
                from osm_polygon p
                LEFT JOIN osm_names n ON n.osm_id = p.osm_id
		where (   p.tags -> 'building' IN ('farm')
                       OR p.tags -> 'historic' IN ('manor')
                      )
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p
                LEFT JOIN osm_names n ON n.osm_id = p.osm_id
		where (    p.tags -> 'building' IN ('farm')
                        OR p.tags -> 'historic' IN ('manor')
                      )
                 AND ( n.name = s.navn OR p.tags -> 'addr:housename' = s.navn )
                 AND ST_Distance(p.geog, s.geog) < 50 )
order by ST_XMin(s.way)

