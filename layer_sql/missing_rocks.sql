select way, ogc_fid, gml_id, objectid, naturarealtype as featuretype, navn_1_skrivemaade as navn, 'naturareal' as featureclass
from stednavne.naturareal s
where naturarealtype in (
 'klippeIOverfladen'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )

UNION

select way, ogc_fid, gml_id, objectid, urentfarvandtype as featuretype, navn_1_skrivemaade as navn, 'urentfarvand' as featureclass
from stednavne.urentfarvand s
where urentfarvandtype in (
 'overskylledeSten'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


UNION

select way, ogc_fid, gml_id, objectid, andentopografitype as featuretype, navn_1_skrivemaade as navn, 'andentopografipunkt' as featureclass
from stednavne.andentopografipunkt s
where andentopografitype in (
 'sten'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'bare_rock',
                                    'rock',
                                    'stone',
                                    'cliff'
                                   )
                         OR p.tags -> 'place' in (
                                    'islet',
                                    'archipelago'
                                   )
                         OR p.tags -> 'seamark:type' = 'rock'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )

