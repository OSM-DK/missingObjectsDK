select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'grænsestenGrænsepæl'
                     )
and not exists (select 1
                from osm_point p
		where p.tags -> 'boundary' in ('marker')
		 AND ( p.tags -> 'name' = s.navn OR p.tags -> 'ref' = s.navn)
		 AND ST_Distance(p.geog, s.geog) < 75 )
