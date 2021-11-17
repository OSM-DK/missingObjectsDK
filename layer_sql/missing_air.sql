select way, ogc_fid, gml_id, objectid, lufthavnstype, navn_1_skrivemaade as navn
from stednavne.lufthavn s
where lufthavnstype in (
                      'flyveplads',
                      'heliport',
                      'mindreLufthavn',
                      'størreLufthavn',
                      'svæveflyveplads',
                      'landingsplads'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'aeroway' in ('aerodrome', 'helipad', 'heliport', 'runway', 'terminal')
                      )
                 AND n.osm_id = p.osm_id
		 AND (n.name = sn.name OR n.name = sn.name || ' Flyveplads')
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
