select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'fiskerihavn',
                      'lystbådehavn',
                      'trafikhavn'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.leisure in ('marina')
                       OR p.landuse in ('harbour', 'port')
                       OR p.tags -> 'industrial' IN ('port')
                       OR p.tags -> 'military' IN ('naval_base')
                       OR (p.tags -> 'harbour' IS NOT NULL AND p.tags -> 'harbour' <> '')
                       OR p.tags -> 'seamark:type' = 'harbour'
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 50
                )

and not exists (select 1
                from osm_point p
		where (   p.leisure in ('marina')
                       OR p.landuse in ('harbour', 'port')
                       OR p.tags -> 'industrial' IN ('port')
                       OR p.tags -> 'military' IN ('naval_base')
                       OR (p.tags -> 'harbour' IS NOT NULL AND p.tags -> 'harbour' <> '')
                       OR p.tags -> 'seamark:type' = 'harbour' 
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 50
               )


