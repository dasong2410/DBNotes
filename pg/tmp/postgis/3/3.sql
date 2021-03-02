SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography)::int AS distance
FROM stores
WHERE city_id = '021' and ST_Distance(geop, 'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(121.3878945400 31.2704262881)'::geography <-> geop limit 100;

SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography)::int AS distance
FROM stores
WHERE city_id = '313' and ST_Distance(geop, 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(114.4113027420 40.6630658332)'::geography <-> geop limit 100;

SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography)::int AS distance
FROM stores
WHERE city_id = '532' and ST_Distance(geop, 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(120.8772138261 36.4634831714)'::geography <-> geop limit 100;

SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography)::int AS distance
FROM stores
WHERE city_id = '371' and ST_Distance(geop, 'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(113.6872483584 34.7983366388)'::geography <-> geop limit 100;

SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography)::int AS distance
FROM stores
WHERE city_id = '316' and ST_Distance(geop, 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(116.7702980545 39.9688657272)'::geography <-> geop limit 100;

SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography)::int AS distance
FROM stores
WHERE city_id = '757' and ST_Distance(geop, 'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(113.1402669742 23.1199294664)'::geography <-> geop limit 100;

SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(105.1380678636 32.3480110540)'::geography)::int AS distance
FROM stores
WHERE city_id = '839' and ST_Distance(geop, 'SRID=4326;POINT(105.1380678636 32.3480110540)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(105.1380678636 32.3480110540)'::geography <-> geop limit 100;

SELECT id, name, ST_Distance(geop, 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography)::int AS distance
FROM stores
WHERE city_id = '755' and ST_Distance(geop, 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography) < 5000
ORDER BY 'SRID=4326;POINT(114.4168102930 22.6340325106)'::geography <-> geop limit 100;

