select way, ogc_fid, gml_id, objectid, bebyggelsestype, navn_1_skrivemaade as navn, areal, indbyggertal
from stednavne.bebyggelse s
where bebyggelsestype in (
                      'spredtBebyggelse'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where p.tags -> 'place' in (
                                  'town',
				  'village',
				  'hamlet',
                                  'locality',
				  'isolated_dwelling')
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )
and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where p.tags -> 'place' in (
                                  'town',
				  'village',
				  'hamlet',
                                  'locality',
				  'isolated_dwelling')
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 100 )

