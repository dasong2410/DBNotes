-- #33 --
CREATE TABLE road_pg (ID INTEGER, NAME VARCHAR(32));
select sn_create_distributed_table('road_pg', 'id', 'none');

SELECT '#33', AddGeometryColumn( '', 'public', 'road_pg','roads_geom', 330000, 'POINT', 2 );
DROP TABLE road_pg;

-- #241 --
CREATE TABLE c (id serial, the_geom GEOMETRY);
select sn_create_distributed_table('c', 'id', 'none');

INSERT INTO c(the_geom) SELECT ST_MakeLine(ST_Point(-10,40),ST_Point(40,-10)) As the_geom;
INSERT INTO c(the_geom) SELECT ST_MakeLine(ST_Point(-10,40),ST_Point(40,-10)) As the_geom;
SELECT '#241', sum(ST_LineCrossingDirection(the_geom, ST_GeomFromText('LINESTRING(1 2,3 4)'))) FROM c;
DROP TABLE c;

CREATE OR REPLACE FUNCTION utmzone(geometry)
  RETURNS integer AS
$BODY$
DECLARE
    geomgeog geometry;
    zone int;
    pref int;

BEGIN
    geomgeog:= ST_Transform($1,4326);

    IF (ST_Y(geomgeog))>0 THEN
       pref:=32600;
    ELSE
       pref:=32700;
    END IF;

    zone:=floor((ST_X(geomgeog)+180)/6)+1;
    IF ( zone > 60 ) THEN zone := 60; END IF;

    RETURN zone+pref;
END;
$BODY$ LANGUAGE 'plpgsql' IMMUTABLE
  COST 100;

CREATE TABLE utm_dots ( the_geog geography, utm_srid integer);
select sn_create_distributed_table('utm_dots', 'utm_srid', 'none');

INSERT INTO utm_dots SELECT geography(ST_SetSRID(ST_Point(i*10,j*10),4326)) As the_geog, utmzone(ST_SetSRID(ST_Point(i*10,j*10),4326)) As utm_srid FROM generate_series(-17,17) As i CROSS JOIN generate_series(-8,8) As j;

SELECT ST_AsText(the_geog) as the_pt,
       utm_srid,
       ST_Area(ST_Buffer(the_geog,10)) As the_area,
       ST_Area(geography(ST_Transform(ST_Buffer(ST_Transform(geometry(the_geog),utm_srid),10),4326))) As geog_utm_area
FROM utm_dots
WHERE ST_Area(ST_Buffer(the_geog,10)) NOT between 307 and 315
LIMIT 10;

SELECT '#304.a', Count(*) FROM utm_dots WHERE ST_DWithin(the_geog, 'POINT(0 0)'::geography, 3000000);

CREATE INDEX utm_dots_gix ON utm_dots USING GIST (the_geog);
SELECT '#304.b', Count(*) FROM utm_dots WHERE ST_DWithin(the_geog, 'POINT(0 0)'::geography, 300000);

DROP FUNCTION utmzone(geometry);
DROP TABLE utm_dots;

-- #884 --
CREATE TABLE foo (id integer, the_geom geometry);
select sn_create_distributed_table('foo', 'id', 'none');

INSERT INTO foo VALUES (1, st_geomfromtext('MULTIPOLYGON(((-113.6 35.4,-113.6 35.8,-113.2 35.8,-113.2 35.4,-113.6 35.4),(-113.5 35.5,-113.3 35.5,-113.3 35.7,-113.5 35.7,-113.5 35.5)))'));
INSERT INTO foo VALUES (2, st_geomfromtext('MULTIPOLYGON(((-113.7 35.3,-113.7 35.9,-113.1 35.9,-113.1 35.3,-113.7 35.3),(-113.6 35.4,-113.2 35.4,-113.2 35.8,-113.6 35.8,-113.6 35.4)),((-113.5 35.5,-113.5 35.7,-113.3 35.7,-113.3 35.5,-113.5 35.5)))'));

select '#884', id, ST_Within(
ST_GeomFromText('POINT (-113.4 35.6)'), the_geom
) from foo;

select '#938', 'POLYGON EMPTY'::geometry::box2d;

DROP TABLE foo;

-- #1320
SELECT '<#1320>';
CREATE TABLE A (id serial, geom geometry(MultiPolygon, 4326),
                 geog geography(MultiPolygon, 4326) );
select sn_create_distributed_table('a', 'id', 'none');

-- Valid inserts
INSERT INTO a(geog) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geography);
INSERT INTO a(geom) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geometry);
SELECT '#1320.geog.1', geometrytype(geog::geometry), st_srid(geog::geometry) FROM a where geog is not null;
SELECT '#1320.geom.1', geometrytype(geom), st_srid(geom) FROM a where geom is not null;
-- Type mismatches is not allowed
INSERT INTO a(geog) VALUES('SRID=4326;POLYGON ((0 0, 10 0, 10 10, 0 0))'::geography);
INSERT INTO a(geom) VALUES('SRID=4326;POLYGON ((0 0, 10 0, 10 10, 0 0))'::geometry);
SELECT '#1320.geog.2', geometrytype(geog::geometry), st_srid(geog::geometry) FROM a where geog is not null;
SELECT '#1320.geom.2', geometrytype(geom), st_srid(geom) FROM a where geom is not null;
-- Even if it's a trigger changing the type
CREATE OR REPLACE FUNCTION triga() RETURNS trigger AS
$$ BEGIN
	NEW.geom = ST_GeometryN(New.geom,1);
	NEW.geog = ST_GeometryN(New.geog::geometry,1)::geography;
	RETURN NEW;
END; $$ language plpgsql VOLATILE;
CREATE TRIGGER triga_before
  BEFORE INSERT ON a FOR EACH ROW
  EXECUTE PROCEDURE triga();
INSERT INTO a(geog) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geography);
INSERT INTO a(geom) VALUES('SRID=4326;MULTIPOLYGON (((0 0, 10 0, 10 10, 0 0)))'::geometry);
SELECT '#1320.geog.3', geometrytype(geog::geometry), st_srid(geog::geometry) FROM a where geog is not null;
SELECT '#1320.geom.3', geometrytype(geom), st_srid(geom) FROM a where geom is not null;
DROP TABLE A;
DROP FUNCTION triga();
SELECT '</#1320>';

-- st_AsText POLYGON((0 0,10 0,10 10,0 0))

-- #852
CREATE TABLE cacheable (id int, g geometry);
select sn_create_distributed_table('cacheable', 'id', 'none');

COPY cacheable FROM STDIN;
1	POINT(0.5 0.5000000000001)
2	POINT(0.5 0.5000000000001)
\.
select '#852.1', id, -- first run is not cached, consequent are cached
  st_intersects(g, 'POLYGON((0 0, 10 10, 1 0, 0 0))'::geometry),
  st_intersects(g, 'POLYGON((0 0, 1 1, 1 0, 0 0))'::geometry) from cacheable;
UPDATE cacheable SET g = 'POINT(0.5 0.5)';
-- New select, new cache
select '#852.2', id, -- first run is not cached, consequent are cached
  st_intersects(g, 'POLYGON((0 0, 10 10, 1 0, 0 0))'::geometry),
  st_intersects(g, 'POLYGON((0 0, 1 1, 1 0, 0 0))'::geometry) from cacheable;
DROP TABLE cacheable;

-- #1596 --
CREATE TABLE road_pg (ID INTEGER, NAME VARCHAR(32));
select sn_create_distributed_table('road_pg', 'id', 'none');

SELECT '#1596.1', AddGeometryColumn( 'road_pg','roads_geom', 3395, 'POINT', 2 );
SELECT '#1596.2', UpdateGeometrySRID( 'road_pg','roads_geom', 330000);
SELECT '#1596.3', srid FROM geometry_columns
  WHERE f_table_name = 'road_pg' AND f_geometry_column = 'roads_geom';
SELECT '#1596.4', UpdateGeometrySRID( 'road_pg','roads_geom', 999000);
SELECT '#1596.5', srid FROM geometry_columns
  WHERE f_table_name = 'road_pg' AND f_geometry_column = 'roads_geom';
SELECT '#1596.6', UpdateGeometrySRID( 'road_pg','roads_geom', -1);
SELECT '#1596.7', srid FROM geometry_columns
  WHERE f_table_name = 'road_pg' AND f_geometry_column = 'roads_geom';
DROP TABLE road_pg;

-- #1697 --
CREATE TABLE eg(id serial, g geography, gm geometry);
select sn_create_distributed_table('eg', 'id', 'none');

CREATE INDEX egi on eg using gist (g);
CREATE INDEX egind on eg using gist (gm gist_geometry_ops_nd);
INSERT INTO eg (g, gm)
 select 'POINT EMPTY'::geography,
        'POINT EMPTY'::geometry
 from generate_series(1,1024);
SELECT '#1697.1', count(*) FROM eg WHERE g && 'POINT(0 0)'::geography;
SELECT '#1697.2', count(*) FROM eg WHERE gm && 'POINT(0 0)'::geometry;
SELECT '#1697.3', count(*) FROM eg WHERE gm ~= 'POINT EMPTY'::geometry;
DROP TABLE eg;

-- #1734 --
create table eg (id serial, g geography);
select sn_create_distributed_table('eg', 'id', 'none');

create index egi on eg using gist (g);
INSERT INTO eg(g) VALUES (NULL);
INSERT INTO eg (g) VALUES ('POINT(0 0)'::geography);
INSERT INTO eg (g) select 'POINT(0 0)'::geography
       FROM generate_series(1,1024);
SELECT '#1734.1', count(*) FROM eg;
DROP table eg;

-- Simple geographic table, with single point.
CREATE TABLE "city" (
    "id" integer,
    "name" varchar(30) NOT NULL,
    "point" geometry(POINT,4326) NOT NULL
);
select sn_create_distributed_table('city', 'id', 'none');

CREATE INDEX "city_point_id" ON "city" USING GIST ( "point" );

-- Initial data, with points around the world.
INSERT INTO "city" (id, name, point) VALUES (1, 'Houston', 'SRID=4326;POINT(-95.363151 29.763374)');
INSERT INTO "city" (id, name, point) VALUES (2, 'Dallas', 'SRID=4326;POINT(-95.363151 29.763374)');
INSERT INTO "city" (id, name, point) VALUES (3, 'Oklahoma City', 'SRID=4326;POINT(-97.521157 34.464642)');
INSERT INTO "city" (id, name, point) VALUES (4, 'Wellington', 'SRID=4326;POINT(174.783117 -41.315268)');
INSERT INTO "city" (id, name, point) VALUES (5, 'Pueblo', 'SRID=4326;POINT(-104.609252 38.255001)');
INSERT INTO "city" (id, name, point) VALUES (6, 'Lawrence', 'SRID=4326;POINT(-95.23506 38.971823)');
INSERT INTO "city" (id, name, point) VALUES (7, 'Chicago', 'SRID=4326;POINT(-87.650175 41.850385)');
INSERT INTO "city" (id, name, point) VALUES (8, 'Victoria', 'SRID=4326;POINT(-123.305196 48.462611)');

-- This query, or COUNT(*), does not return anything; should return 6 cities,
-- excluding Pueblo and Victoria.  The Polygon is a simple approximation of
-- Colorado.
SELECT '#2035a', Count(*) FROM "city"
  WHERE "city"."point" >> ST_GeomFromEWKT('SRID=4326;POLYGON ((-109.060253 36.992426, -109.060253 41.003444, -102.041524 41.003444, -102.041524 36.992426, -109.060253 36.992426))');

-- However, when a LIMIT is placed on statement, the query suddenly works.
SELECT '#2035b', Count(*) FROM "city"
  WHERE "city"."point" >> ST_GeomFromEWKT('SRID=4326;POLYGON ((-109.060253 36.992426, -109.060253 41.003444, -102.041524 41.003444, -102.041524 36.992426, -109.060253 36.992426))') LIMIT 6;

DROP TABLE "city";
-- #2035 END --------------------------------------------------------------

CREATE TABLE images (id integer, name varchar, extent geography(POLYGON,4326));
select sn_create_distributed_table('images', 'id', 'none');

INSERT INTO images VALUES (47409, 'TDX-1_2010-10-06T19_44_2375085', 'SRID=4326;POLYGON((-59.4139571913088 82.9486103943668,-57.3528882462655 83.1123152898828,-50.2302874208478 81.3740574826097,-51.977353304689 81.2431047148532,-59.4139571913088 82.9486103943668))'::geography);
INSERT INTO images VALUES (1, 'first_image', 'SRID=4326;POLYGON((-162.211667 88.046667,-151.190278 87.248889,-44.266389 74.887778,-40.793889 75.043333,-162.211667 88.046667))'::geography);
SELECT '#2556' AS ticket, id, round(ST_Distance(extent, 'SRID=4326;POLYGON((-46.625977 81.634149,-46.625977 81.348076,-48.999023 81.348076,-48.999023 81.634149,-46.625977 81.634149))'::geography)) from images;
DROP TABLE images;

-- #2965 --
CREATE TABLE test_analyze_crash (a integer not null, g geometry);
select sn_create_distributed_table('test_analyze_crash', 'a', 'none');

INSERT INTO test_analyze_crash values (1, '0102000020E6100000010000006D1092A47FF33440AD4ECD9B00334A40');
ANALYZE test_analyze_crash;
SELECT '#2965', ST_AsText(g) FROM test_analyze_crash;
DROP TABLE test_analyze_crash;
