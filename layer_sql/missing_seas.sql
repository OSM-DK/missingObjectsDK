select way, ogc_fid, gml_id, objectid, farvandstype as featuretype, navn_1_skrivemaade as navn, 'farvand' as featureclass
from stednavne.farvand s
where farvandstype in (
 'hav'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'water',
                                    'bay'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality',
                                    'sea'
                                   )
                         OR defined(p.tags, 'seamark:sea_area:category')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_DWithin(p.simple_geog, s.simple_geog, 50)
               )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'water',
                                    'bay'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality',
                                    'sea'
                                   )
                         OR defined(p.tags, 'seamark:sea_area:category')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_DWithin(p.geog, s.simple_geog, 400)
                )
