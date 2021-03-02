CREATE TABLE public.compoundcurve (id INTEGER, description VARCHAR,
the_geom_2d GEOMETRY(COMPOUNDCURVE),
the_geom_3dm GEOMETRY(COMPOUNDCURVEM),
the_geom_3dz GEOMETRY(COMPOUNDCURVEZ),
the_geom_4d GEOMETRY(COMPOUNDCURVEZM)
);
select sn_create_distributed_table('public.compoundcurve', 'id', 'none');

INSERT INTO public.compoundcurve (
                id,
                description
              ) VALUES (
                2,
                'compoundcurve');
UPDATE public.compoundcurve
                SET the_geom_4d = ST_Geomfromewkt('COMPOUNDCURVE(CIRCULARSTRING(
                        0 0 0 0,
                        0.26794919243112270647255365849413 1 3 -2,
                        0.5857864376269049511983112757903 1.4142135623730950488016887242097 1 2),
                        (0.5857864376269049511983112757903 1.4142135623730950488016887242097 1 2,
                        2 0 0 0,
                        0 0 0 0))');
UPDATE public.compoundcurve
                SET the_geom_3dz = ST_Geomfromewkt('COMPOUNDCURVE(CIRCULARSTRING(
                        0 0 0,
                        0.26794919243112270647255365849413 1 3,
                        0.5857864376269049511983112757903 1.4142135623730950488016887242097 1),
                        (0.5857864376269049511983112757903 1.4142135623730950488016887242097 1,
                        2 0 0,
                        0 0 0))');
UPDATE public.compoundcurve
                SET the_geom_3dm = ST_Geomfromewkt('COMPOUNDCURVEM(CIRCULARSTRING(
                        0 0 0,
                        0.26794919243112270647255365849413 1 -2,
                        0.5857864376269049511983112757903 1.4142135623730950488016887242097 2),
                        (0.5857864376269049511983112757903 1.4142135623730950488016887242097 2,
                        2 0 0,
                        0 0 0))');
UPDATE public.compoundcurve
                SET the_geom_2d = ST_Geomfromewkt('COMPOUNDCURVE(CIRCULARSTRING(
                        0 0,
                        0.26794919243112270647255365849413 1,
                        0.5857864376269049511983112757903 1.4142135623730950488016887242097),
                        (0.5857864376269049511983112757903 1.4142135623730950488016887242097,
                        2 0,
                        0 0))');

SELECT 'astext01', ST_Astext(the_geom_2d) FROM public.compoundcurve;
SELECT 'astext02', ST_Astext(the_geom_3dm) FROM public.compoundcurve;
SELECT 'astext03', ST_Astext(the_geom_3dz) FROM public.compoundcurve;
SELECT 'astext04', ST_Astext(the_geom_4d) FROM public.compoundcurve;

SELECT 'asewkt01', ST_Asewkt(the_geom_2d) FROM public.compoundcurve;
SELECT 'asewkt02', ST_Asewkt(the_geom_3dm) FROM public.compoundcurve;
SELECT 'asewkt03', ST_Asewkt(the_geom_3dz) FROM public.compoundcurve;
SELECT 'asewkt04', ST_Asewkt(the_geom_4d) FROM public.compoundcurve;

SELECT 'asbinary01', encode(ST_AsBinary(the_geom_2d, 'ndr'), 'hex') FROM public.compoundcurve;
SELECT 'asbinary02', encode(ST_AsBinary(the_geom_3dm, 'ndr'), 'hex') FROM public.compoundcurve;
SELECT 'asbinary03', encode(ST_AsBinary(the_geom_3dz, 'ndr'), 'hex') FROM public.compoundcurve;
SELECT 'asbinary04', encode(ST_AsBinary(the_geom_4d, 'ndr'), 'hex') FROM public.compoundcurve;

SELECT 'asewkb01', encode(ST_AsEWKB(the_geom_2d, 'ndr'), 'hex') FROM public.compoundcurve;
SELECT 'asewkb02', encode(ST_AsEWKB(the_geom_3dm, 'ndr'), 'hex') FROM public.compoundcurve;
SELECT 'asewkb03', encode(ST_AsEWKB(the_geom_3dz, 'ndr'), 'hex') FROM public.compoundcurve;
SELECT 'asewkb04', encode(ST_AsEWKB(the_geom_4d, 'ndr'), 'hex') FROM public.compoundcurve;

SELECT 'ST_CurveToLine-201', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_2d, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine-202', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine-203', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine-204', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_4d, 2), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;

SELECT 'ST_CurveToLine-401', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_2d, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine-402', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine-403', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine-404', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_4d, 4), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;

SELECT 'ST_CurveToLine01', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_2d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine02', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_3dm), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine03', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_3dz), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'ST_CurveToLine04', ST_Asewkt(ST_SnapToGrid(ST_CurveToLine(the_geom_4d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;

SELECT 'isValid01', ST_IsValid(the_geom_2d) FROM public.compoundcurve;
SELECT 'isValid02', ST_IsValid(the_geom_3dm) FROM public.compoundcurve;
SELECT 'isValid03', ST_IsValid(the_geom_3dz) FROM public.compoundcurve;
SELECT 'isValid04', ST_IsValid(the_geom_4d) FROM public.compoundcurve;

SELECT 'dimension01', ST_dimension(the_geom_2d) FROM public.compoundcurve;
SELECT 'dimension02', ST_dimension(the_geom_3dm) FROM public.compoundcurve;
SELECT 'dimension03', ST_dimension(the_geom_3dz) FROM public.compoundcurve;
SELECT 'dimension04', ST_dimension(the_geom_4d) FROM public.compoundcurve;

SELECT 'SRID01', ST_SRID(the_geom_2d) FROM public.compoundcurve;
SELECT 'SRID02', ST_SRID(the_geom_3dm) FROM public.compoundcurve;
SELECT 'SRID03', ST_SRID(the_geom_3dz) FROM public.compoundcurve;
SELECT 'SRID04', ST_SRID(the_geom_4d) FROM public.compoundcurve;

SELECT 'accessor01', ST_IsEmpty(the_geom_2d), ST_IsSimple(the_geom_2d), ST_IsClosed(the_geom_2d), ST_IsRing(the_geom_2d) FROM public.compoundcurve;
SELECT 'accessor02', ST_IsEmpty(the_geom_3dm), ST_IsSimple(the_geom_3dm), ST_IsClosed(the_geom_3dm), ST_IsRing(the_geom_3dm) FROM public.compoundcurve;
SELECT 'accessor03', ST_IsEmpty(the_geom_3dz), ST_IsSimple(the_geom_3dz), ST_IsClosed(the_geom_3dz), ST_IsRing(the_geom_3dz) FROM public.compoundcurve;
SELECT 'accessor04', ST_IsEmpty(the_geom_4d), ST_IsSimple(the_geom_4d), ST_IsClosed(the_geom_4d), ST_IsRing(the_geom_4d) FROM public.compoundcurve;

SELECT 'envelope01', ST_asText(ST_snapToGrid(ST_envelope(the_geom_2d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'envelope02', ST_asText(ST_snapToGrid(ST_envelope(the_geom_3dm), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'envelope03', ST_asText(ST_snapToGrid(ST_envelope(the_geom_3dz), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;
SELECT 'envelope04', ST_asText(ST_snapToGrid(ST_envelope(the_geom_4d), 'POINT(0 0 0 0)'::geometry, 1e-8, 1e-8, 1e-8, 1e-8)) FROM public.compoundcurve;

DROP TABLE public.compoundcurve;
