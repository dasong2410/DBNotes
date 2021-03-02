SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography)::int AS distance
FROM stores
WHERE city_id = '757' and ST_Distance(geop, 'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography <-> geop limit 100;
