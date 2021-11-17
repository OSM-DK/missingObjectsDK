select way, ogc_fid, gml_id, objectid, andentopografitype, navn_1_skrivemaade as navn, areal
from stednavne.andentopografiflade s
where andentopografitype in (
                      'stenbrud',
		      'køretekniskAnlæg',
		      'vindmøllepark'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'landuse' in ('quarry')
		       or p.tags -> 'amenity' in ('driving_school')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'type' in ('site')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'landuse' in ('quarry')
		       or p.tags -> 'amenity' in ('driving_school')
                       or p.tags -> 'power' in ('plant', 'generator')
                       or p.tags -> 'type' in ('site')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )

