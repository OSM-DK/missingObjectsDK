select way, ogc_fid, gml_id, objectid, andentopografitype, navn_1_skrivemaade as navn
from stednavne.andentopografipunkt s
where andentopografitype in (
                      'grænsestenGrænsepæl'
                     )
and not exists (select 1
                from osm_point p, stednavne_names sn
		where p.tags -> 'boundary' in ('marker')
		 AND ( p.tags -> 'name' = sn.name OR p.tags -> 'ref' = sn.name)
		 AND sn.gml_id = s.gml_id
		 AND ST_Distance(p.geog, s.geog) < 75 )
