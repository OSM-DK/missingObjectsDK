select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',

 båke
 fyr
 fyrtårn
 røse
 sluse


                     )
and not exists (select 1
                from osm_polygon p
		where p.place in ('island', 'islet', 'archipelago')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 1 )
