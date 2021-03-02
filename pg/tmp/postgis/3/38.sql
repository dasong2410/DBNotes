SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography)::int AS distance
FROM stores
WHERE city_id = '755' and ST_Distance(geop, 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography <-> geop limit 100;
