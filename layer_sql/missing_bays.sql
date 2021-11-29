select way, ogc_fid, gml_id, objectid, farvandstype as featuretype, navn_1_skrivemaade as navn, 'farvand' as featureclass
from stednavne.farvand s
where farvandstype in (
 'bredning',
 'bugt',
 'fjord',
 'nor'
 )
and s.navn_1_skrivemaade not in ('Limfjorden', 'Isefjord')
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'water',
                                    'bay',
                                    'strait'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality'
                                   )
                         OR defined(p.tags, 'seamark:sea_area:category')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'water',
                                    'bay',
                                    'strait'
                                   )
                         OR p.tags -> 'place' in (
                                    'locality'
                                   )
                         OR defined(p.tags, 'seamark:sea_area:category')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )

