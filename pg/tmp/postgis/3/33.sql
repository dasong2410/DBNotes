SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography)::int AS distance
FROM stores
WHERE city_id = '532' and ST_Distance(geop, 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography <-> geop limit 100;
