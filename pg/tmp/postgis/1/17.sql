SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(105.1380678636 32.3480110540)'::geography)::int AS distance
 FROM stores
 WHERE city_id = '839'
  AND open_state = '1'
 ORDER BY 'SRID=4326;POINT(105.1380678636 32.3480110540)'::geography <-> geop limit 30 OFFSET 30;
