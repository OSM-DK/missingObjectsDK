select way, ogc_fid, gml_id, objectid, jernbanetype as featuretype, navn_1_skrivemaade as navn, 'jernbane' as featureclass
from stednavne.jernbane s
where
    not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'railway' IN ('narrow_gauge', 'preserved', 'rail', 'subway', 'light_rail', 'disused', 'abandoned', 'station', 'halt')
                       OR p.tags -> 'building' IN ('station')
                       OR p.tags -> 'public_transport' IN ('station', 'stop_area')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
 		 AND ST_DWithin(p.geog, s.geog, 100)
	        )

and not exists (select 1
                from osm_line p, osm_names n, stednavne_names sn
		where p.tags -> 'railway' IN ('narrow_gauge', 'preserved', 'rail', 'subway', 'light_rail', 'disused', 'abandoned', 'tram')
                 AND n.osm_id = p.osm_id
		 AND ((n.name = sn.name) OR (sn.name = p.tags -> 'operator'))
                 AND sn.gml_id = s.gml_id
		 AND ST_DWithin(p.geog, s.geog, 100)
	        )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_extranames sn
		where (   p.tags -> 'railway' IN ('halt', 'station', 'stop')
                       OR p.tags -> 'railway:historic' IN ('halt', 'station', 'station_site')
                       OR p.tags -> 'public_transport' IN ('station', 'stop_position')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_DWithin(p.geog, s.geog, 500)
	       )

UNION

select way, ogc_fid, gml_id, objectid, standsningsstedtype as featuretype, navn_1_skrivemaade as navn, 'standsningssted' as featureclass
from stednavne.standsningssted s
where standsningsstedtype in (
                      'tog'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_extranames sn
		where (   p.tags -> 'railway' IN ('preserved', 'disused', 'abandoned', 'station', 'halt')
                       OR p.tags -> 'building' IN ('station')
                       OR p.tags -> 'public_transport' IN ('station', 'stop_area')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
 		 AND ST_DWithin(p.geog, s.geog, 100)
	       )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_extranames sn
		where (   p.tags -> 'railway' IN ('halt', 'station', 'stop')
                       OR p.tags -> 'railway:historic' IN ('halt', 'station', 'station_site')
                       OR p.tags -> 'public_transport' IN ('station', 'stop_position')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_DWithin(p.geog, s.geog, 500)
		)
