SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography)::int AS distance
FROM stores
WHERE city_id = '371' and ST_Distance(geop, 'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography <-> geop limit 100;
