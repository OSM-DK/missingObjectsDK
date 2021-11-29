select way, ogc_fid, gml_id, objectid, restriktionsarealtype as featuretype, navn_1_skrivemaade as navn, areal, 'restriktionsareal' as featureclass
from stednavne.restriktionsareal s
where
    not exists (select 1
                from osm_polygon p, osm_names n, stednavne_extranames sn
		where (   p.tags -> 'landuse' in ('military')
                       OR p.tags -> 'leisure' in ('nature_reserve')
                       OR p.tags -> 'boundary' in ('national_park', 'protected_area')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_extranames sn
		where (   p.tags -> 'landuse' in ('military')
                       OR p.tags -> 'leisure' in ('nature_reserve')
                       OR p.tags -> 'boundary' in ('national_park', 'protected_area')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )
