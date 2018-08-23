select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
 'bakke',
 'bredning',
 'bugt',
 'dal',
 'fjord',
 'hage',
 'halvø',
 'hav',
 'hule',
 'højBanke',
 'højdedrag',
 'kilde',
 'klint',
 'klippeIOverfladen',
 'kløft',
 'landskabsform',
 'lavning',
 'løb',
 'løvtræ',
 'marsk',
 'moseSump',
 'nor',
 'næs',
 'nåletræ',
 'odde',
 'overskylledeSten',
 'pynt',
 'sandKlit',
 'sejlløb',
 'skræntNaturlig',
 'slugt',
 'sten',
 'strand',
 'sund',
 'sø',
 'tange',
 'tørtVedLavvande',
 'undersøiskGrund',
 'ås'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'natural' in (
                                    'peak',
                                    'ridge',
                                    'tree',
                                    'sand',
                                    'beach',
                                    'wetland',
                                    'tree_row',
                                    'cliff',
                                    'bare_rock',
                                    'water',
                                    'bay',
                                    'cape',
                                    'reef',
                                    'valley',
                                    'rock',
                                    'stone',
                                    'strait',
                                    'cave'
                                   )
                         OR p.tags -> 'place' in (
                                    'peninsula', 'locality'
                                   )
                         OR p.tags -> 'geological' = 'moraine'
                         OR defined(p.tags, 'tidal')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_point p, osm_names n
		where (   p.tags -> 'natural' in (
                                    'peak',
                                    'ridge',
                                    'tree',
                                    'sand',
                                    'beach',
                                    'wetland',
                                    'tree_row',
                                    'cliff',
                                    'bare_rock',
                                    'water',
                                    'bay',
                                    'cape',
                                    'reef',
                                    'valley',
                                    'rock',
                                    'stone',
                                    'strait',
                                    'cave'
                                   )
                         OR p.tags -> 'place' in (
                                    'peninsula', 'locality'
                                   )
                         OR p.tags -> 'geological' = 'moraine'
                         OR defined(p.tags, 'tidal')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )


and not exists (select 1
                from osm_line p, osm_names n
		where (   p.tags -> 'natural' in (
                                    'peak',
                                    'ridge',
                                    'tree',
                                    'sand',
                                    'beach',
                                    'wetland',
                                    'tree_row',
                                    'cliff',
                                    'bare_rock',
                                    'water',
                                    'bay',
                                    'cape',
                                    'reef',
                                    'valley',
                                    'rock',
                                    'stone',
                                    'strait',
                                    'cave'
                                   )
                         OR p.tags -> 'place' in (
                                    'peninsula', 'locality'
                                   )
                         OR p.tags -> 'geological' = 'moraine'
                         OR defined(p.tags, 'tidal')
                 )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 1 )
order by ST_XMin(s.way)
