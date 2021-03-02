SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography)::int AS distance
FROM stores
WHERE city_id = '021' and ST_Distance(geop, 'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography <-> geop limit 100;
