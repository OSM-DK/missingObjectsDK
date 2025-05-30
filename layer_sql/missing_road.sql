select way, ogc_fid, gml_id, objectid, vejtype as featuretype, navn_1_skrivemaade as navn, 'vej' as featureclass
from stednavne.vej s
where
    not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (    defined(p.tags, 'highway')
		        OR (defined(p.tags, 'tunnel') AND s.vejtype = 'vejtunnel')
		        OR ((defined(p.tags, 'bridge') OR p.tags -> 'man_made' = 'bridge') AND s.vejtype = 'vejbro')
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (    defined(p.tags, 'highway')
		        OR (defined(p.tags, 'tunnel') AND s.vejtype = 'vejtunnel')
		        OR ((defined(p.tags, 'bridge') OR p.tags -> 'man_made' = 'bridge') AND s.vejtype = 'vejbro')
                        OR defined(p.tags, 'route')
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (    defined(p.tags, 'highway')
		        OR (defined(p.tags, 'tunnel') AND s.vejtype = 'vejtunnel')
		        OR ((defined(p.tags, 'bridge') OR p.tags -> 'man_made' = 'bridge') AND s.vejtype = 'vejbro')
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 700 )

UNION

select way, ogc_fid, gml_id, objectid, andentopografitype as featuretype, navn_1_skrivemaade as navn, 'andentopografipunkt' as featureclass
from stednavne.andentopografipunkt s
where andentopografitype in (
                      'ledLåge',
                      'motorvejskryds',
                      'rastepladsMedService',
                      'rastepladsUdenService',
                      'vejkryds'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'highway')
		       OR (andentopografitype = 'ledLåge' AND
                             ( p.tags -> 'barrier' IN ('gate', 'entrance') OR p.tags -> 'building' = 'gatehouse')
                          )
                       OR p.tags -> 'amenity' = 'car_pooling'
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where (   defined(p.tags, 'highway')
		       OR (andentopografitype = 'ledLåge' AND p.tags -> 'barrier' IN ('gate', 'entrance'))
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 300 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_extranames sn
		where (   defined(p.tags, 'highway')
		       OR (andentopografitype = 'ledLåge' AND p.tags -> 'barrier' IN ('gate', 'entrance'))
                       OR p.tags -> 'amenity' = 'car_pooling'
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 700 )
