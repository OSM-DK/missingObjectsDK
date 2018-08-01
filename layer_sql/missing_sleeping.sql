select way, ogc_fid, gml_id, featureid, featurecode, featuretype, snsorid, navn, stoerrelseareal, indbyggerantal
from stednavne s
where featuretype in (
                      'Campingplads',
                      'feriecenter',
                      'hotel',
                      'vandrerhjem'
                     )
and not exists (select 1
                from osm_polygon p
		where (   p.tourism in ('camp_site', 'caravan_site', 'chalet', 'guest_house', 'hostel', 'hotel', 'motel', 'resort')
                       OR p.amenity in ('resort', 'beach_resort')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 100 )

and not exists (select 1
                from osm_point p
		where (   p.tourism in ('camp_site', 'caravan_site', 'chalet', 'guest_house', 'hostel', 'hotel', 'motel', 'resort')
                       OR p.amenity in ('resort', 'beach_resort')
                      )
		 AND (p.name = s.navn OR p.alt_name = s.navn)
		 AND ST_Distance(p.way, s.way) < 100 )
