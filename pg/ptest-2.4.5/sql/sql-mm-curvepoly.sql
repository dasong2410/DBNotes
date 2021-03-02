CREATE TABLE public.curvepolygon (id INTEGER, description VARCHAR,
the_geom_2d GEOMETRY(CURVEPOLYGON),
the_geom_3dm GEOMETRY(CURVEPOLYGONM),
the_geom_3dz GEOMETRY(CURVEPOLYGONZ),
the_geom_4d GEOMETRY(CURVEPOLYGONZM));
select sn_create_distributed_table('public.curvepolygon', 'id', 'none');

INSERT INTO public.curvepolygon (
                id,
                description
              ) VALUES (
                1, 'curvepolygon');
UPDATE public.curvepolygon
        SET the_geom_4d = ST_Geomfromewkt('CURVEPOLYGON(CIRCULARSTRING(
                -2 0 0 0,
                -1 -1 1 2,
                0 0 2 4,
                1 -1 3 6,
                2 0 4 8,
                0 2 2 4,
                -2 0 0 0),
                (-1 0 1 2,
                0 0.5 2 4,
                1 0 3 6,
                0 1 3 4,
                -1 0 1 2))');
UPDATE public.curvepolygon
        SET the_geom_3dz = ST_Geomfromewkt('CURVEPOLYGON(CIRCULARSTRING(
                -2 0 0,
                -1 -1 1,
                0 0 2,
                1 -1 3,
                2 0 4,
                0 2 2,
                -2 0 0),
                (-1 0 1,
                0 0.5 2,
                1 0 3,
                0 1 3,
                -1 0 1))');
UPDATE public.curvepolygon
        SET the_geom_3dm = ST_Geomfromewkt('CURVEPOLYGONM(CIRCULARSTRING(
                -2 0 0,
                -1 -1 2,
                0 0 4,
                1 -1 6,
                2 0 8,
                0 2 4,
                -2 0 0),
                (-1 0 2,
                0 0.5 4,
                1 0 6,
                0 1 4,
                -1 0 2))');
UPDATE public.curvepolygon
        SET the_geom_2d = ST_Geomfromewkt('CURVEPOLYGON(CIRCULARSTRING(
                -2 0,
                -1 -1,
                0 0,
                1 -1,
                2 0,
                0 2,
                -2 0),
                (-1 0,
                0 0.5,
                1 0,
                0 1,
                -1 0))');

SELECT 'asbinary01', encode(ST_AsBinary(the_geom_2d, 'ndr'), 'hex') FROM public.curvepolygon;
SELECT 'asbinary02', encode(ST_AsBinary(the_geom_3dm, 'xdr'), 'hex') FROM public.curvepolygon;
SELECT 'asbinary03', encode(ST_AsBinary(the_geom_3dz, 'ndr'), 'hex') FROM public.curvepolygon;
SELECT 'asbinary04', encode(ST_AsBinary(the_geom_4d, 'xdr'), 'hex') FROM public.curvepolygon;

SELECT 'asewkb01', encode(ST_AsEWKB(the_geom_2d, 'xdr'), 'hex') FROM public.curvepolygon;
SELECT 'asewkb02', encode(ST_AsEWKB(the_geom_3dm, 'ndr'), 'hex') FROM public.curvepolygon;
SELECT 'asewkb03', encode(ST_AsEWKB(the_geom_3dz, 'xdr'), 'hex') FROM public.curvepolygon;
SELECT 'asewkb04', encode(ST_AsEWKB(the_geom_4d, 'ndr'), 'hex') FROM public.curvepolygon;

SELECT 'ST_CurveToLine-201',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_2d, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine-202',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine-203',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine-204',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_4d, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;

SELECT 'ST_CurveToLine-401',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_2d, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine-402',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine-403',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine-404',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_4d, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;

SELECT 'ST_CurveToLine01',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_2d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine02',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine03',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'ST_CurveToLine04',ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_4d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;

-- TODO: ST_SnapToGrid is required to remove platform dependent precision
-- issues.  Until ST_SnapToGrid is updated to work against curves, these
-- tests cannot be run.
--SELECT 'ST_LineToCurve01',ST_AsEWKT(ST_LineToCurve(ST_CurveToLine(the_geom_2d))) FROM public.curvepolygon;
--SELECT 'ST_LineToCurve02',ST_AsEWKT(ST_LineToCurve(ST_CurveToLine(the_geom_3dm))) FROM public.curvepolygon;
--SELECT 'ST_LineToCurve03',ST_AsEWKT(ST_LineToCurve(ST_CurveToLine(the_geom_3dz))) FROM public.curvepolygon;
--SELECT 'ST_LineToCurve04',ST_AsEWKT(ST_LineToCurve(ST_CurveToLine(the_geom_4d))) FROM public.curvepolygon;

-- Repeat tests with new function names.
SELECT 'astext01', ST_AsText(the_geom_2d) FROM public.curvepolygon;
SELECT 'astext02', ST_AsText(the_geom_3dm) FROM public.curvepolygon;
SELECT 'astext03', ST_AsText(the_geom_3dz) FROM public.curvepolygon;
SELECT 'astext04', ST_AsText(the_geom_4d) FROM public.curvepolygon;

SELECT 'asewkt01', ST_AsEWKT(the_geom_2d) FROM public.curvepolygon;
SELECT 'asewkt02', ST_AsEWKT(the_geom_3dm) FROM public.curvepolygon;
SELECT 'asewkt03', ST_AsEWKT(the_geom_3dz) FROM public.curvepolygon;
SELECT 'asewkt04', ST_AsEWKT(the_geom_4d) FROM public.curvepolygon;

SELECT 'isValid01', ST_IsValid(the_geom_2d) FROM public.curvepolygon;
SELECT 'isValid02', ST_IsValid(the_geom_3dm) FROM public.curvepolygon;
SELECT 'isValid03', ST_IsValid(the_geom_3dz) FROM public.curvepolygon;
SELECT 'isValid04', ST_IsValid(the_geom_4d) FROM public.curvepolygon;

SELECT 'dimension01', ST_dimension(the_geom_2d) FROM public.curvepolygon;
SELECT 'dimension02', ST_dimension(the_geom_3dm) FROM public.curvepolygon;
SELECT 'dimension03', ST_dimension(the_geom_3dz) FROM public.curvepolygon;
SELECT 'dimension04', ST_dimension(the_geom_4d) FROM public.curvepolygon;

SELECT 'SRID01', ST_SRID(the_geom_2d) FROM public.curvepolygon;
SELECT 'SRID02', ST_SRID(the_geom_3dm) FROM public.curvepolygon;
SELECT 'SRID03', ST_SRID(the_geom_3dz) FROM public.curvepolygon;
SELECT 'SRID04', ST_SRID(the_geom_4d) FROM public.curvepolygon;

SELECT 'envelope01', ST_AsText(ST_snapToGrid(ST_envelope(the_geom_2d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'envelope02', ST_AsText(ST_snapToGrid(ST_envelope(the_geom_3dm), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'envelope03', ST_AsText(ST_snapToGrid(ST_envelope(the_geom_3dz), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;
SELECT 'envelope04', ST_AsText(ST_snapToGrid(ST_envelope(the_geom_4d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.curvepolygon;

SELECT 'startPoint01', (ST_startPoint(the_geom_2d) is null) FROM public.curvepolygon;
SELECT 'startPoint02', (ST_startPoint(the_geom_3dm) is null) FROM public.curvepolygon;
SELECT 'startPoint03', (ST_startPoint(the_geom_3dz) is null) FROM public.curvepolygon;
SELECT 'startPoint04', (ST_startPoint(the_geom_4d) is null) FROM public.curvepolygon;

SELECT 'endPoint01', (ST_endPoint(the_geom_2d) is null) FROM public.curvepolygon;
SELECT 'endPoint02', (ST_endPoint(the_geom_3dm) is null) FROM public.curvepolygon;
SELECT 'endPoint03', (ST_endPoint(the_geom_3dz) is null) FROM public.curvepolygon;
SELECT 'endPoint04', (ST_endPoint(the_geom_4d) is null) FROM public.curvepolygon;

SELECT 'exteriorRing01', ST_AsEWKT(ST_exteriorRing(the_geom_2d)) FROM public.curvepolygon;
SELECT 'exteriorRing02', ST_AsEWKT(ST_exteriorRing(the_geom_3dm)) FROM public.curvepolygon;
SELECT 'exteriorRing03', ST_AsEWKT(ST_exteriorRing(the_geom_3dz)) FROM public.curvepolygon;
SELECT 'exteriorRing04', ST_AsEWKT(ST_exteriorRing(the_geom_4d)) FROM public.curvepolygon;

SELECT 'numInteriorRings01', ST_numInteriorRings(the_geom_2d) FROM public.curvepolygon;
SELECT 'numInteriorRings02', ST_numInteriorRings(the_geom_3dm) FROM public.curvepolygon;
SELECT 'numInteriorRings03', ST_numInteriorRings(the_geom_3dz) FROM public.curvepolygon;
SELECT 'numInteriorRings04', ST_numInteriorRings(the_geom_4d) FROM public.curvepolygon;

SELECT 'interiorRingN-101', ST_AsEWKT(ST_InteriorRingN(the_geom_2d, 1)) FROM public.curvepolygon;
SELECT 'interiorRingN-102', ST_AsEWKT(ST_InteriorRingN(the_geom_3dm, 1)) FROM public.curvepolygon;
SELECT 'interiorRingN-103', ST_AsEWKT(ST_InteriorRingN(the_geom_3dz, 1)) FROM public.curvepolygon;
SELECT 'interiorRingN-104', ST_AsEWKT(ST_InteriorRingN(the_geom_4d, 1)) FROM public.curvepolygon;

SELECT 'interiorRingN-201', ST_AsEWKT(ST_InteriorRingN(the_geom_2d, 2)) FROM public.curvepolygon;
SELECT 'interiorRingN-202', ST_AsEWKT(ST_InteriorRingN(the_geom_3dm, 2)) FROM public.curvepolygon;
SELECT 'interiorRingN-203', ST_AsEWKT(ST_InteriorRingN(the_geom_3dz, 2)) FROM public.curvepolygon;
SELECT 'interiorRingN-204', ST_AsEWKT(ST_InteriorRingN(the_geom_4d, 2)) FROM public.curvepolygon;

DROP TABLE public.curvepolygon;
