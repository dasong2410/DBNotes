SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography)::int AS distance
FROM stores
WHERE city_id = '313' and ST_Distance(geop, 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography <-> geop limit 100;
