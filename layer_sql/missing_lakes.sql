select way, ogc_fid, gml_id, objectid, soetype as featuretype, areal, navn_1_skrivemaade as navn, 'soe' as featureclass
from stednavne.soe s

where not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'wetland',
                                    'water'
                                   )
                       OR p.tags -> 'landuse' in (
                                      'basin'
                                   )
                       OR defined(p.tags, 'tidal')
                       OR p.tags -> 'sport' = 'swimming'
                       OR p.tags -> 'amenity' = 'public_bath'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 10 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'wetland',
                                    'water'
                                   )
                       OR defined(p.tags, 'tidal')
                       OR p.tags -> 'sport' = 'swimming'
                       OR p.tags -> 'amenity' = 'public_bath'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 150 )


and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'wetland',
                                    'water'
                                   )
                       OR p.tags -> 'sport' = 'swimming'
                       OR p.tags -> 'amenity' = 'public_bath'
                       OR defined(p.tags, 'tidal')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )
