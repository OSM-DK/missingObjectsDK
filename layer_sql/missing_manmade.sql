select way, ogc_fid, gml_id, objectid, andentopografitype as featuretype, navn_1_skrivemaade as navn, 'andentopografipunkt' as featureclass
from stednavne.andentopografipunkt s
where andentopografitype in (
                      'brønd'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'man_made' in ('water_well')
		      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'man_made' in ('water_well')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

UNION

select way, ogc_fid, gml_id, objectid, bygningstype as featuretype, navn_1_skrivemaade as navn, 'bygning' as featureclass
from stednavne.bygning s
where bygningstype in (
                      'kraftvarmeværk',
                      'observatorium',
                      'søredningsstation',
                      'vandkraftværk',
                      'vandmølle',
                      'vejrmølle'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'man_made' in ('watermill', 'observatory', 'wind_mill')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'amenity' in ('rescue_station')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'man_made' in ('watermill', 'observatory', 'wind_mill')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'amenity' in ('rescue_station')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

