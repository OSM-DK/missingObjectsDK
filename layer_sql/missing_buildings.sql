select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'andenBygning',
                      'bygning',
                      'hus',
                      'slot'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where defined(p.tags, 'building')
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 50 )
order by ST_XMin(s.way)
