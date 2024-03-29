select way, ogc_fid, gml_id, objectid, urentfarvandtype as featuretype, navn_1_skrivemaade as navn, 'urentfarvand' as featureclass
from stednavne.urentfarvand s
where urentfarvandtype in (
 'tørtVedLavvande',
 'undersøiskGrund'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'shoal',
                                    'sand',
                                    'reef'
                                   )
                         OR defined(p.tags, 'tidal')
			 OR p.tags-> 'wetland' = 'tidalflat'
                 )
                 AND n.osm_id = p.osm_id
 		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_DWithin(p.geog, s.geog, 10)
	       )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'natural' in (
                                    'shoal',
                                    'sand',
                                    'reef'
                                   )
                         OR defined(p.tags, 'tidal')
 			 OR p.tags-> 'wetland' = 'tidalflat'
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_DWithin(p.geog, s.geog, 1)
		)


