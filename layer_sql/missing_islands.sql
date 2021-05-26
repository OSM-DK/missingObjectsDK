select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in ('ø', 'skær', 'øgruppe')
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'place' in ('island', 'islet', 'archipelago')
                       OR p.tags -> 'natural' in ('shoal', 'peninsula')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 40 )
