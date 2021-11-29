TRUNCATE TABLE stednavne_extranames;


INSERT INTO stednavne_extranames (gml_id, name)
  (SELECT gml_id, name FROM stednavne_names);


INSERT INTO stednavne_extranames (gml_id, name)
  ( SELECT sn.gml_id, REGEXP_REPLACE(sn.name, '( +(Trinbræt|Station))+ *$', '')
    FROM stednavne_names sn
    JOIN stednavne.jernbane s ON s.gml_id = sn.gml_id
    WHERE sn.name SIMILAR TO '%( Trinbræt| Station)+'
  );

INSERT INTO stednavne_extranames (gml_id, name)
  ( SELECT sn.gml_id, REGEXP_REPLACE(sn.name, '( +(Trinbræt|Station|Metro))+ *$', '')
    FROM stednavne_names sn
    JOIN stednavne.standsningssted s ON s.gml_id = sn.gml_id
    WHERE sn.name SIMILAR TO '%( Trinbræt| Station| Metro)+'
  );


INSERT INTO stednavne_extranames (gml_id, name)
  ( SELECT sn.gml_id, REGEXP_REPLACE(sn.name, ' +Fyr *$', '')
    FROM stednavne_names sn
    JOIN stednavne.navigationsanlaeg s ON s.gml_id = sn.gml_id
    WHERE sn.name LIKE '% Fyr'
  );

INSERT INTO stednavne_extranames (gml_id, name)
  ( SELECT sn.gml_id, sn.name || ' Fyr'
    FROM stednavne_names sn
    JOIN stednavne.navigationsanlaeg s ON s.gml_id = sn.gml_id
    WHERE sn.name NOT LIKE '% Fyr'
  );


INSERT INTO stednavne_extranames (gml_id, name)
  ( SELECT sn.gml_id, REGEXP_REPLACE(sn.name, ' +Vildtreservat *$', '')
    FROM stednavne_names sn
    JOIN stednavne.restriktionsareal s ON s.gml_id = sn.gml_id
    WHERE sn.name LIKE '% Vildtreservat'
  );


INSERT INTO stednavne_extranames (gml_id, name)
  ( SELECT sn.gml_id, sn.name || ' Flyveplads'
    FROM stednavne_names sn
    JOIN stednavne.lufthavn s ON s.gml_id = sn.gml_id
    WHERE sn.name NOT LIKE '% Flyveplads'
  );


INSERT INTO stednavne_extranames (gml_id, name)
  ( SELECT sn.gml_id, 'Motorvejskryds ' || sn.name
    FROM stednavne_names sn
    JOIN stednavne.andentopografipunkt s ON s.gml_id = sn.gml_id
    WHERE
         s.andentopografitype = 'motorvejskryds'
     AND sn.name NOT LIKE 'Motorvejskryds %'
  );
