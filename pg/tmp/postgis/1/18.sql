SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography)::int AS distance
 FROM stores
 WHERE city_id = '755'
  AND open_state = '1'
 ORDER BY 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography <-> geop limit 30 OFFSET 30;
