select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in ('ø', 'skær', 'øgruppe')
and not exists (select 1
                from osm_polygon p
		where p.tags -> 'place' in ('island', 'islet', 'archipelago')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 40 )
