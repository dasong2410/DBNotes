SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography)::int AS distance
 FROM stores
 WHERE city_id = '316'
  AND open_state = '1'
 ORDER BY 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography <-> geop limit 30 OFFSET 30;
