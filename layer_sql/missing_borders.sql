select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'landsdel'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'place' in ('peninsula', 'locality')
                       OR defined(p.tags, 'boundary')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 100
               )
