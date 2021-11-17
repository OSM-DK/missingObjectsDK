select way, ogc_fid, gml_id, objectid, bygningstype, navn_1_skrivemaade as navn
from stednavne.bygning s
where bygningstype in (
                      'terminal'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'aeroway' in ('terminal', 'aerodrome')
                       OR p.tags -> 'amenity' in ('ferry_terminal', 'bus_station')
                       OR p.tags -> 'public_transport' in ('station', 'stop_area')
                      )
		 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50
	       )


and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'aeroway' in ('terminal', 'aerodrome')
                       OR p.tags -> 'amenity' in ('ferry_terminal', 'bus_station')
                       OR p.tags -> 'public_transport' in ('station', 'stop_area')
                      )
		 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50
	       )
