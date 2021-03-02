SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography)::int AS distance
FROM stores
WHERE city_id = '316' and ST_Distance(geop, 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography <-> geop limit 100;
