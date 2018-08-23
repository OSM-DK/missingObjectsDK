select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'Campingplads',
                      'feriecenter',
                      'hotel',
                      'vandrerhjem'
                     )
and not exists (select 1
                from osm_polygon p, osm_names n
		where (   p.tags -> 'tourism' in ('camp_site', 'caravan_site', 'chalet', 'guest_house', 'hostel', 'hotel', 'motel', 'resort')
                       OR p.tags -> 'amenity' in ('resort', 'beach_resort')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 100 )

and not exists (select 1
                from osm_point p, osm_names n
		where (   p.tags -> 'tourism' in ('camp_site', 'caravan_site', 'chalet', 'guest_house', 'hostel', 'hotel', 'motel', 'resort')
                       OR p.tags -> 'amenity' in ('resort', 'beach_resort')
                      )
                 AND n.osm_id = p.osm_id
		 AND n.name = s.navn
		 AND ST_Distance(p.geog, s.geog) < 100 )
