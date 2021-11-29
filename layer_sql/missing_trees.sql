select way, ogc_fid, gml_id, objectid, andentopografitype as featuretype, navn_1_skrivemaade as navn, 'andentopografipunkt' as featureclass
from stednavne.andentopografipunkt s
where andentopografitype in (
 'løvtræ',
 'nåletræ'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'tree',
                                    'tree_row'
                                   )
                       or p.tags -> 'landuse' in (
                                    'forest',
                                    'wood'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'tree',
                                    'tree_row'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'tree',
                                    'tree_row'
                                   )
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 1 )
