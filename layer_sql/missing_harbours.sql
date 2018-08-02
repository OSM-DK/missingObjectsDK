select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'fiskerihavn',
                      'lystbådehavn',
                      'trafikhavn'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tags -> 'leisure' in ('marina')
                       OR p.tags -> 'landuse' in ('harbour', 'port')
                       OR p.tags -> 'industrial' IN ('port')
                       OR p.tags -> 'military' IN ('naval_base')
                       OR defined(p.tags, 'harbour')
                       OR p.tags -> 'seamark:type' = 'harbour'
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50
                )

and not exists (select 1
                from osm_point p
		where (   p.tags -> 'leisure' in ('marina')
                       OR p.tags -> 'landuse' in ('harbour', 'port')
                       OR p.tags -> 'industrial' IN ('port')
                       OR p.tags -> 'military' IN ('naval_base')
                       OR defined(p.tags, 'harbour')
                       OR p.tags -> 'seamark:type' = 'harbour' 
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 50
               )


