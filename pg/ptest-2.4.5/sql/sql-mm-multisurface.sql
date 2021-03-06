CREATE TABLE public.multisurface (id INTEGER, description VARCHAR,
the_geom_2d GEOMETRY(MULTISURFACE),
the_geom_3dm GEOMETRY(MULTISURFACEM),
the_geom_3dz GEOMETRY(MULTISURFACEZ),
the_geom_4d GEOMETRY(MULTISURFACEZM));
select sn_create_distributed_table('public.multisurface', 'id', 'none');

INSERT INTO public.multisurface (
        id, description
      ) VALUES (
        1, 'multisurface');
UPDATE public.multisurface
        SET the_geom_4d = ST_geomfromewkt('MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(
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
                -1 0 1 2)),
                ((7 8 7 8,
                10 10 5 5,
                6 14 3 1,
                4 11 4 6,
                7 8 7 8)))')
        WHERE id = 1;
UPDATE public.multisurface
        SET the_geom_3dz = ST_geomfromewkt('MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(
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
                -1 0 1)),
                ((7 8 7,
                10 10 5,
                6 14 3,
                4 11 4,
                7 8 7)))')
        WHERE id = 1;
UPDATE public.multisurface
        SET the_geom_3dm = ST_geomfromewkt('MULTISURFACEM(CURVEPOLYGON(CIRCULARSTRING(
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
                -1 0 2)),
                ((7 8 8,
                10 10 5,
                6 14 1,
                4 11 6,
                7 8 8)))')
        WHERE id = 1;
UPDATE public.multisurface
        SET the_geom_2d = ST_geomfromewkt('MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(
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
                -1 0)),
                ((7 8,
                10 10,
                6 14,
                4 11,
                7 8)))')
        WHERE id = 1;

SELECT 'asbinary01', encode(ST_AsBinary(the_geom_2d, 'ndr'), 'hex') FROM public.multisurface;
SELECT 'asbinary02', encode(ST_AsBinary(the_geom_3dm, 'ndr'), 'hex') FROM public.multisurface;
SELECT 'asbinary03', encode(ST_AsBinary(the_geom_3dz, 'ndr'), 'hex') FROM public.multisurface;
SELECT 'asbinary04', encode(ST_AsBinary(the_geom_4d, 'ndr'), 'hex') FROM public.multisurface;

SELECT 'asewkb01', encode(ST_AsEWKB(the_geom_2d, 'ndr'), 'hex') FROM public.multisurface;
SELECT 'asewkb02', encode(ST_AsEWKB(the_geom_3dm, 'ndr'), 'hex') FROM public.multisurface;
SELECT 'asewkb03', encode(ST_AsEWKB(the_geom_3dz, 'ndr'), 'hex') FROM public.multisurface;
SELECT 'asewkb04', encode(ST_AsEWKB(the_geom_4d, 'ndr'), 'hex') FROM public.multisurface;

SELECT 'ST_CurveToLine-201', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_2d, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine-202', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine-203', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine-204', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_4d, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;

SELECT 'ST_CurveToLine-401', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_2d, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine-402', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine-403', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine-404', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_4d, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;

SELECT 'ST_CurveToLine01', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_2d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine02', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine03', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;
SELECT 'ST_CurveToLine04', ST_AsEWKT(ST_SnapToGrid(ST_CurveToLine(the_geom_4d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.multisurface;

-- Repeat tests with new function names.
SELECT 'astext01', ST_AsText(the_geom_2d) FROM public.multisurface;
SELECT 'astext02', ST_AsText(the_geom_3dm) FROM public.multisurface;
SELECT 'astext03', ST_AsText(the_geom_3dz) FROM public.multisurface;
SELECT 'astext04', ST_AsText(the_geom_4d) FROM public.multisurface;

SELECT 'asewkt01', ST_AsEWKT(the_geom_2d) FROM public.multisurface;
SELECT 'asewkt02', ST_AsEWKT(the_geom_3dm) FROM public.multisurface;
SELECT 'asewkt03', ST_AsEWKT(the_geom_3dz) FROM public.multisurface;
SELECT 'asewkt04', ST_AsEWKT(the_geom_4d) FROM public.multisurface;

SELECT 'box2d01', box2d(the_geom_2d) FROM public.multisurface;
SELECT 'box2d02', box2d(the_geom_3dm) FROM public.multisurface;
SELECT 'box2d03', box2d(the_geom_3dz) FROM public.multisurface;
SELECT 'box2d04', box2d(the_geom_4d) FROM public.multisurface;

SELECT 'box3d01', box3d(the_geom_2d) FROM public.multisurface;
SELECT 'box3d02', box3d(the_geom_3dm) FROM public.multisurface;
SELECT 'box3d03', box3d(the_geom_3dz) FROM public.multisurface;
SELECT 'box3d04', box3d(the_geom_4d) FROM public.multisurface;

SELECT 'isValid01', ST_IsValid(the_geom_2d) FROM public.multisurface;
SELECT 'isValid02', ST_IsValid(the_geom_3dm) FROM public.multisurface;
SELECT 'isValid03', ST_IsValid(the_geom_3dz) FROM public.multisurface;
SELECT 'isValid04', ST_IsValid(the_geom_4d) FROM public.multisurface;

SELECT 'dimension01', ST_Dimension(the_geom_2d) FROM public.multisurface;
SELECT 'dimension02', ST_Dimension(the_geom_3dm) FROM public.multisurface;
SELECT 'dimension03', ST_Dimension(the_geom_3dz) FROM public.multisurface;
SELECT 'dimension04', ST_Dimension(the_geom_4d) FROM public.multisurface;

SELECT 'numGeometries01', ST_NumGeometries(the_geom_2d) FROM public.multisurface;
SELECT 'numGeometries02', ST_NumGeometries(the_geom_3dm) FROM public.multisurface;
SELECT 'numGeometries03', ST_NumGeometries(the_geom_3dz) FROM public.multisurface;
SELECT 'numGeometries04', ST_NumGeometries(the_geom_4d) FROM public.multisurface;

SELECT 'geometryN-201', ST_AsEWKT(ST_geometryN(the_geom_2d, 2)) FROM public.multisurface;
SELECT 'geometryN-202', ST_AsEWKT(ST_geometryN(the_geom_3dm, 2)) FROM public.multisurface;
SELECT 'geometryN-203', ST_AsEWKT(ST_geometryN(the_geom_3dz, 2)) FROM public.multisurface;
SELECT 'geometryN-204', ST_AsEWKT(ST_geometryN(the_geom_4d, 2)) FROM public.multisurface;

SELECT 'geometryN-301', (ST_GeometryN(the_geom_2d, 3) is null) FROM public.multisurface;
SELECT 'geometryN-302', (ST_GeometryN(the_geom_3dm, 3) is null) FROM public.multisurface;
SELECT 'geometryN-303', (ST_GeometryN(the_geom_3dz, 3) is null) FROM public.multisurface;
SELECT 'geometryN-304', (ST_GeometryN(the_geom_4d, 3) is null) FROM public.multisurface;

DROP TABLE public.multisurface;

