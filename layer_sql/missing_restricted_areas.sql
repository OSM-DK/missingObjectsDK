select way, ogc_fid, gml_id, objectid, restriktionsarealtype, navn_1_skrivemaade as navn, areal
from stednavne.restriktionsareal s
where
    not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'landuse' in ('military')
                       OR p.tags -> 'leisure' in ('nature_reserve')
                       OR p.tags -> 'boundary' in ('national_park', 'protected_area')
                      )
                 AND n.osm_id = p.osm_id
		 AND (  n.name = sn.name
		      OR sn.name = n.name || ' Vildtreservat')
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'landuse' in ('military')
                       OR p.tags -> 'leisure' in ('nature_reserve')
                       OR p.tags -> 'boundary' in ('national_park', 'protected_area')
                      )
                 AND n.osm_id = p.osm_id
		 AND (  n.name = sn.name
		      OR sn.name = n.name || ' Vildtreservat')
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )
