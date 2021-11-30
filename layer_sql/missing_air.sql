select way, ogc_fid, gml_id, objectid, lufthavnstype as featuretype, navn_1_skrivemaade as navn, icaokode, iatakode,'lufthavn' as featureclass
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
                from osm_polygon p, osm_names n, stednavne_extranames sn
		where (   p.tags -> 'aeroway' in ('aerodrome', 'helipad', 'heliport', 'runway', 'terminal')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_extranames sn
		where (   p.tags -> 'aeroway' in ('aerodrome', 'helipad', 'heliport', 'runway', 'terminal')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )
