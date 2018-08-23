select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in ('boplads',
                      'dysse',
                      'fundsted',
                      'gravhøj',
                      'gravsted',
                      'hellekiste',
                      'helleristning',
                      'jættestue',
                      'krigergrav',
                      'køkkenmøding',
                      'langdysse',
                      'oldtidsager',
                      'oldtidsminde',
                      'oldtidsvej',
                      'ruin',
                      'runddysse',
                      'runesten',
                      'skibssætning',
                      'tomt',
                      'vikingeborg',
                      'voldVoldsted',
                      'slot'
                      )
and not exists (select 1
                from osm_polygon p, osm_names n
		where p.tags-> 'historic' in (
                                     'archaeological_site',
                                     'battlefield',
                                     'building',
                                     'castle',
                                     'memorial',
                                     'milestone',
                                     'ruins',
                                     'rune_stone',
                                     'tomb',
                                     'yes'
                     )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 100
                )

and not exists (select 1
                from osm_point p, osm_names n
		where p.tags-> 'historic' in (
                                     'archaeological_site',
                                     'battlefield',
                                     'building',
                                     'castle',
                                     'memorial',
                                     'milestone',
                                     'ruins',
                                     'rune_stone',
                                     'tomb',
                                     'yes'
                     )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 100
                )
