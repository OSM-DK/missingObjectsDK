select way, ogc_fid, gml_id, objectid, naturarealtype, navn_1_skrivemaade as navn, areal
from stednavne.naturareal s
where naturarealtype in (
                      'agerMark',
                      'eng',
                      'hede',
                      'parkAnlæg',
                      'skovPlantage'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n, stednavne_names sn
		where (   p.tags -> 'landuse' in ('farmland', 'farmyard', 'forest', 'meadow')
                       OR p.tags -> 'natural' in ('moor', 'heath', 'grassland', 'wood')
                       OR p.tags -> 'leisure' in ('nature_reserve', 'garden', 'park')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 20 )

and not exists (select 1
                from osm_point p, osm_names n, stednavne_names sn
		where (   p.tags -> 'landuse' in ('farmland', 'farmyard', 'forest', 'meadow')
                       OR p.tags -> 'natural' in ('moor', 'heath', 'grassland', 'wood')
                       OR p.tags -> 'leisure' IN ('garden', 'park')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = sn.name
                 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 50 )

