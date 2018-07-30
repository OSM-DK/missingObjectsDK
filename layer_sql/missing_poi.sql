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


 akvarium
 andenSeværdighed
 arboret
 batteri
 bautasten
 blomsterpark
 botaniskHave
 dyrepark
 frilandsmuseum
 friluftsgård
 fæstningsanlæg
 historiskMindeHistoriskAnlæg
 mindesten
 museumSamling
 parkAnlæg
 skanse
 terrarium
 udsigtspunkt
 udsigtstårn
 varde
 forlystelsespark
 turistbureau
 zoologiskHave


                     )
and not exists (select 1
                from osm_polygon p
		where p.place in ('island', 'islet', 'archipelago')
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 1 )
