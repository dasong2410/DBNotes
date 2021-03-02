SET client_min_messages TO warning;
\set VERBOSITY terse

CREATE SCHEMA tm;

-- Test construction of typed tables

CREATE TABLE tm.circularstring (id serial, g geometry(circularstring) );
select sn_create_distributed_table('tm.circularstring', 'id', 'none');

CREATE TABLE tm.circularstring0 (id serial, g geometry(circularstring, 0) );
select sn_create_distributed_table('tm.circularstring0', 'id', 'none');

CREATE TABLE tm.circularstring4326 (id serial, g geometry(circularstring, 4326) );
select sn_create_distributed_table('tm.circularstring4326', 'id', 'none');

CREATE TABLE tm.circularstringm (id serial, g geometry(circularstringm) );
select sn_create_distributed_table('tm.circularstringm', 'id', 'none');

CREATE TABLE tm.circularstringm0 (id serial, g geometry(circularstringm, 0) );
select sn_create_distributed_table('tm.circularstringm0', 'id', 'none');

CREATE TABLE tm.circularstringm4326 (id serial, g geometry(circularstringm, 4326) );
select sn_create_distributed_table('tm.circularstringm4326', 'id', 'none');

CREATE TABLE tm.circularstringz (id serial, g geometry(circularstringz) );
select sn_create_distributed_table('tm.circularstringz', 'id', 'none');

CREATE TABLE tm.circularstringz0 (id serial, g geometry(circularstringz, 0) );
select sn_create_distributed_table('tm.circularstringz0', 'id', 'none');

CREATE TABLE tm.circularstringz4326 (id serial, g geometry(circularstringz, 4326) );
select sn_create_distributed_table('tm.circularstringz4326', 'id', 'none');

CREATE TABLE tm.circularstringzm (id serial, g geometry(circularstringzm) );
select sn_create_distributed_table('tm.circularstringzm', 'id', 'none');

CREATE TABLE tm.circularstringzm0 (id serial, g geometry(circularstringzm, 0) );
select sn_create_distributed_table('tm.circularstringzm0', 'id', 'none');

CREATE TABLE tm.circularstringzm4326 (id serial, g geometry(circularstringzm, 4326) );
select sn_create_distributed_table('tm.circularstringzm4326', 'id', 'none');


CREATE TABLE tm.compoundcurve (id serial, g geometry(compoundcurve) );
select sn_create_distributed_table('tm.compoundcurve', 'id', 'none');

CREATE TABLE tm.compoundcurve0 (id serial, g geometry(compoundcurve, 0) );
select sn_create_distributed_table('tm.compoundcurve0', 'id', 'none');

CREATE TABLE tm.compoundcurve4326 (id serial, g geometry(compoundcurve, 4326) );
select sn_create_distributed_table('tm.compoundcurve4326', 'id', 'none');

CREATE TABLE tm.compoundcurvem (id serial, g geometry(compoundcurvem) );
select sn_create_distributed_table('tm.compoundcurvem', 'id', 'none');

CREATE TABLE tm.compoundcurvem0 (id serial, g geometry(compoundcurvem, 0) );
select sn_create_distributed_table('tm.compoundcurvem0', 'id', 'none');

CREATE TABLE tm.compoundcurvem4326 (id serial, g geometry(compoundcurvem, 4326) );
select sn_create_distributed_table('tm.compoundcurvem4326', 'id', 'none');

CREATE TABLE tm.compoundcurvez (id serial, g geometry(compoundcurvez) );
select sn_create_distributed_table('tm.compoundcurvez', 'id', 'none');

CREATE TABLE tm.compoundcurvez0 (id serial, g geometry(compoundcurvez, 0) );
select sn_create_distributed_table('tm.compoundcurvez0', 'id', 'none');

CREATE TABLE tm.compoundcurvez4326 (id serial, g geometry(compoundcurvez, 4326) );
select sn_create_distributed_table('tm.compoundcurvez4326', 'id', 'none');

CREATE TABLE tm.compoundcurvezm (id serial, g geometry(compoundcurvezm) );
select sn_create_distributed_table('tm.compoundcurvezm', 'id', 'none');

CREATE TABLE tm.compoundcurvezm0 (id serial, g geometry(compoundcurvezm, 0) );
select sn_create_distributed_table('tm.compoundcurvezm0', 'id', 'none');

CREATE TABLE tm.compoundcurvezm4326 (id serial, g geometry(compoundcurvezm, 4326) );
select sn_create_distributed_table('tm.compoundcurvezm4326', 'id', 'none');


CREATE TABLE tm.curvepolygon (id serial, g geometry(curvepolygon) );
select sn_create_distributed_table('tm.curvepolygon', 'id', 'none');

CREATE TABLE tm.curvepolygon0 (id serial, g geometry(curvepolygon, 0) );
select sn_create_distributed_table('tm.curvepolygon0', 'id', 'none');

CREATE TABLE tm.curvepolygon4326 (id serial, g geometry(curvepolygon, 4326) );
select sn_create_distributed_table('tm.curvepolygon4326', 'id', 'none');

CREATE TABLE tm.curvepolygonm (id serial, g geometry(curvepolygonm) );
select sn_create_distributed_table('tm.curvepolygonm', 'id', 'none');

CREATE TABLE tm.curvepolygonm0 (id serial, g geometry(curvepolygonm, 0) );
select sn_create_distributed_table('tm.curvepolygonm0', 'id', 'none');

CREATE TABLE tm.curvepolygonm4326 (id serial, g geometry(curvepolygonm, 4326) );
select sn_create_distributed_table('tm.curvepolygonm4326', 'id', 'none');

CREATE TABLE tm.curvepolygonz (id serial, g geometry(curvepolygonz) );
select sn_create_distributed_table('tm.curvepolygonz', 'id', 'none');

CREATE TABLE tm.curvepolygonz0 (id serial, g geometry(curvepolygonz, 0) );
select sn_create_distributed_table('tm.curvepolygonz0', 'id', 'none');

CREATE TABLE tm.curvepolygonz4326 (id serial, g geometry(curvepolygonz, 4326) );
select sn_create_distributed_table('tm.curvepolygonz4326', 'id', 'none');

CREATE TABLE tm.curvepolygonzm (id serial, g geometry(curvepolygonzm) );
select sn_create_distributed_table('tm.curvepolygonzm', 'id', 'none');

CREATE TABLE tm.curvepolygonzm0 (id serial, g geometry(curvepolygonzm, 0) );
select sn_create_distributed_table('tm.curvepolygonzm0', 'id', 'none');

CREATE TABLE tm.curvepolygonzm4326 (id serial, g geometry(curvepolygonzm, 4326) );
select sn_create_distributed_table('tm.curvepolygonzm4326', 'id', 'none');


CREATE TABLE tm.geometry (id serial, g geometry(geometry), gg geography(geometry) );
select sn_create_distributed_table('tm.geometry', 'id', 'none');

CREATE TABLE tm.geometry0 (id serial, g geometry(geometry, 0), gg geography(geometry, 0) );
select sn_create_distributed_table('tm.geometry0', 'id', 'none');

CREATE TABLE tm.geometry4326 (id serial, g geometry(geometry, 4326), gg geography(geometry, 4326) );
select sn_create_distributed_table('tm.geometry4326', 'id', 'none');

CREATE TABLE tm.geometrym (id serial, g geometry(geometrym), gg geography(geometrym) );
select sn_create_distributed_table('tm.geometrym', 'id', 'none');

CREATE TABLE tm.geometrym0 (id serial, g geometry(geometrym, 0), gg geography(geometrym, 0) );
select sn_create_distributed_table('tm.geometrym0', 'id', 'none');

CREATE TABLE tm.geometrym4326 (id serial, g geometry(geometrym, 4326), gg geography(geometrym, 4326) );
select sn_create_distributed_table('tm.geometrym4326', 'id', 'none');

CREATE TABLE tm.geometryz (id serial, g geometry(geometryz), gg geography(geometryz) );
select sn_create_distributed_table('tm.geometryz', 'id', 'none');

CREATE TABLE tm.geometryz0 (id serial, g geometry(geometryz, 0), gg geography(geometryz, 0) );
select sn_create_distributed_table('tm.geometryz0', 'id', 'none');

CREATE TABLE tm.geometryz4326 (id serial, g geometry(geometryz, 4326), gg geography(geometryz, 4326) );
select sn_create_distributed_table('tm.geometryz4326', 'id', 'none');

CREATE TABLE tm.geometryzm (id serial, g geometry(geometryzm), gg geography(geometryzm) );
select sn_create_distributed_table('tm.geometryzm', 'id', 'none');

CREATE TABLE tm.geometryzm0 (id serial, g geometry(geometryzm, 0), gg geography(geometryzm, 0) );
select sn_create_distributed_table('tm.geometryzm0', 'id', 'none');

CREATE TABLE tm.geometryzm4326 (id serial, g geometry(geometryzm, 4326), gg geography(geometryzm, 4326) );
select sn_create_distributed_table('tm.geometryzm4326', 'id', 'none');


CREATE TABLE tm.geometrycollection (id serial, g geometry(geometrycollection), gg geography(geometrycollection) );
select sn_create_distributed_table('tm.geometrycollection', 'id', 'none');

CREATE TABLE tm.geometrycollection0 (id serial, g geometry(geometrycollection, 0), gg geography(geometrycollection, 0) );
select sn_create_distributed_table('tm.geometrycollection0', 'id', 'none');

CREATE TABLE tm.geometrycollection4326 (id serial, g geometry(geometrycollection, 4326), gg geography(geometrycollection, 4326) );
select sn_create_distributed_table('tm.geometrycollection4326', 'id', 'none');

CREATE TABLE tm.geometrycollectionm (id serial, g geometry(geometrycollectionm), gg geography(geometrycollectionm) );
select sn_create_distributed_table('tm.geometrycollectionm', 'id', 'none');

CREATE TABLE tm.geometrycollectionm0 (id serial, g geometry(geometrycollectionm, 0), gg geography(geometrycollectionm, 0) );
select sn_create_distributed_table('tm.geometrycollectionm0', 'id', 'none');

CREATE TABLE tm.geometrycollectionm4326 (id serial, g geometry(geometrycollectionm, 4326), gg geography(geometrycollectionm, 4326) );
select sn_create_distributed_table('tm.geometrycollectionm4326', 'id', 'none');

CREATE TABLE tm.geometrycollectionz (id serial, g geometry(geometrycollectionz), gg geography(geometrycollectionz) );
select sn_create_distributed_table('tm.geometrycollectionz', 'id', 'none');

CREATE TABLE tm.geometrycollectionz0 (id serial, g geometry(geometrycollectionz, 0), gg geography(geometrycollectionz, 0) );
select sn_create_distributed_table('tm.geometrycollectionz0', 'id', 'none');

CREATE TABLE tm.geometrycollectionz4326 (id serial, g geometry(geometrycollectionz, 4326), gg geography(geometrycollectionz, 4326) );
select sn_create_distributed_table('tm.geometrycollectionz4326', 'id', 'none');

CREATE TABLE tm.geometrycollectionzm (id serial, g geometry(geometrycollectionzm), gg geography(geometrycollectionzm) );
select sn_create_distributed_table('tm.geometrycollectionzm', 'id', 'none');

CREATE TABLE tm.geometrycollectionzm0 (id serial, g geometry(geometrycollectionzm, 0), gg geography(geometrycollectionzm, 0) );
select sn_create_distributed_table('tm.geometrycollectionzm0', 'id', 'none');

CREATE TABLE tm.geometrycollectionzm4326 (id serial, g geometry(geometrycollectionzm, 4326), gg geography(geometrycollectionzm, 4326) );
select sn_create_distributed_table('tm.geometrycollectionzm4326', 'id', 'none');


CREATE TABLE tm.linestring (id serial, g geometry(linestring), gg geography(linestring) );
select sn_create_distributed_table('tm.linestring', 'id', 'none');

CREATE TABLE tm.linestring0 (id serial, g geometry(linestring, 0), gg geography(linestring, 0) );
select sn_create_distributed_table('tm.linestring0', 'id', 'none');

CREATE TABLE tm.linestring4326 (id serial, g geometry(linestring, 4326), gg geography(linestring, 4326) );
select sn_create_distributed_table('tm.linestring4326', 'id', 'none');

CREATE TABLE tm.linestringm (id serial, g geometry(linestringm), gg geography(linestringm) );
select sn_create_distributed_table('tm.linestringm', 'id', 'none');

CREATE TABLE tm.linestringm0 (id serial, g geometry(linestringm, 0), gg geography(linestringm, 0) );
select sn_create_distributed_table('tm.linestringm0', 'id', 'none');

CREATE TABLE tm.linestringm4326 (id serial, g geometry(linestringm, 4326), gg geography(linestringm, 4326) );
select sn_create_distributed_table('tm.linestringm4326', 'id', 'none');

CREATE TABLE tm.linestringz (id serial, g geometry(linestringz), gg geography(linestringz) );
select sn_create_distributed_table('tm.linestringz', 'id', 'none');

CREATE TABLE tm.linestringz0 (id serial, g geometry(linestringz, 0), gg geography(linestringz, 0) );
select sn_create_distributed_table('tm.linestringz0', 'id', 'none');

CREATE TABLE tm.linestringz4326 (id serial, g geometry(linestringz, 4326), gg geography(linestringz, 4326) );
select sn_create_distributed_table('tm.linestringz4326', 'id', 'none');

CREATE TABLE tm.linestringzm (id serial, g geometry(linestringzm), gg geography(linestringzm) );
select sn_create_distributed_table('tm.linestringzm', 'id', 'none');

CREATE TABLE tm.linestringzm0 (id serial, g geometry(linestringzm, 0), gg geography(linestringzm, 0) );
select sn_create_distributed_table('tm.linestringzm0', 'id', 'none');

CREATE TABLE tm.linestringzm4326 (id serial, g geometry(linestringzm, 4326), gg geography(linestringzm, 4326) );
select sn_create_distributed_table('tm.linestringzm4326', 'id', 'none');


CREATE TABLE tm.multicurve (id serial, g geometry(multicurve) );
select sn_create_distributed_table('tm.multicurve', 'id', 'none');

CREATE TABLE tm.multicurve0 (id serial, g geometry(multicurve, 0) );
select sn_create_distributed_table('tm.multicurve0', 'id', 'none');

CREATE TABLE tm.multicurve4326 (id serial, g geometry(multicurve, 4326) );
select sn_create_distributed_table('tm.multicurve4326', 'id', 'none');

CREATE TABLE tm.multicurvem (id serial, g geometry(multicurvem) );
select sn_create_distributed_table('tm.multicurvem', 'id', 'none');

CREATE TABLE tm.multicurvem0 (id serial, g geometry(multicurvem, 0) );
select sn_create_distributed_table('tm.multicurvem0', 'id', 'none');

CREATE TABLE tm.multicurvem4326 (id serial, g geometry(multicurvem, 4326) );
select sn_create_distributed_table('tm.multicurvem4326', 'id', 'none');

CREATE TABLE tm.multicurvez (id serial, g geometry(multicurvez) );
select sn_create_distributed_table('tm.multicurvez', 'id', 'none');

CREATE TABLE tm.multicurvez0 (id serial, g geometry(multicurvez, 0) );
select sn_create_distributed_table('tm.multicurvez0', 'id', 'none');

CREATE TABLE tm.multicurvez4326 (id serial, g geometry(multicurvez, 4326) );
select sn_create_distributed_table('tm.multicurvez4326', 'id', 'none');

CREATE TABLE tm.multicurvezm (id serial, g geometry(multicurvezm) );
select sn_create_distributed_table('tm.multicurvezm', 'id', 'none');

CREATE TABLE tm.multicurvezm0 (id serial, g geometry(multicurvezm, 0) );
select sn_create_distributed_table('tm.multicurvezm0', 'id', 'none');

CREATE TABLE tm.multicurvezm4326 (id serial, g geometry(multicurvezm, 4326) );
select sn_create_distributed_table('tm.multicurvezm4326', 'id', 'none');


CREATE TABLE tm.multilinestring (id serial, g geometry(multilinestring), gg geography(multilinestring) );
select sn_create_distributed_table('tm.multilinestring', 'id', 'none');

CREATE TABLE tm.multilinestring0 (id serial, g geometry(multilinestring, 0), gg geography(multilinestring, 0) );
select sn_create_distributed_table('tm.multilinestring0', 'id', 'none');

CREATE TABLE tm.multilinestring4326 (id serial, g geometry(multilinestring, 4326), gg geography(multilinestring, 4326) );
select sn_create_distributed_table('tm.multilinestring4326', 'id', 'none');

CREATE TABLE tm.multilinestringm (id serial, g geometry(multilinestringm), gg geography(multilinestringm) );
select sn_create_distributed_table('tm.multilinestringm', 'id', 'none');

CREATE TABLE tm.multilinestringm0 (id serial, g geometry(multilinestringm, 0), gg geography(multilinestringm, 0) );
select sn_create_distributed_table('tm.multilinestringm0', 'id', 'none');

CREATE TABLE tm.multilinestringm4326 (id serial, g geometry(multilinestringm, 4326), gg geography(multilinestringm, 4326) );
select sn_create_distributed_table('tm.multilinestringm4326', 'id', 'none');

CREATE TABLE tm.multilinestringz (id serial, g geometry(multilinestringz), gg geography(multilinestringz) );
select sn_create_distributed_table('tm.multilinestringz', 'id', 'none');

CREATE TABLE tm.multilinestringz0 (id serial, g geometry(multilinestringz, 0), gg geography(multilinestringz, 0) );
select sn_create_distributed_table('tm.multilinestringz0', 'id', 'none');

CREATE TABLE tm.multilinestringz4326 (id serial, g geometry(multilinestringz, 4326), gg geography(multilinestringz, 4326) );
select sn_create_distributed_table('tm.multilinestringz4326', 'id', 'none');

CREATE TABLE tm.multilinestringzm (id serial, g geometry(multilinestringzm), gg geography(multilinestringzm) );
select sn_create_distributed_table('tm.multilinestringzm', 'id', 'none');

CREATE TABLE tm.multilinestringzm0 (id serial, g geometry(multilinestringzm, 0), gg geography(multilinestringzm, 0) );
select sn_create_distributed_table('tm.multilinestringzm0', 'id', 'none');

CREATE TABLE tm.multilinestringzm4326 (id serial, g geometry(multilinestringzm, 4326), gg geography(multilinestringzm, 4326) );
select sn_create_distributed_table('tm.multilinestringzm4326', 'id', 'none');


CREATE TABLE tm.multipolygon (id serial, g geometry(multipolygon), gg geography(multipolygon) );
select sn_create_distributed_table('tm.multipolygon', 'id', 'none');

CREATE TABLE tm.multipolygon0 (id serial, g geometry(multipolygon, 0), gg geography(multipolygon, 0) );
select sn_create_distributed_table('tm.multipolygon0', 'id', 'none');

CREATE TABLE tm.multipolygon4326 (id serial, g geometry(multipolygon, 4326), gg geography(multipolygon, 4326) );
select sn_create_distributed_table('tm.multipolygon4326', 'id', 'none');

CREATE TABLE tm.multipolygonm (id serial, g geometry(multipolygonm), gg geography(multipolygonm) );
select sn_create_distributed_table('tm.multipolygonm', 'id', 'none');

CREATE TABLE tm.multipolygonm0 (id serial, g geometry(multipolygonm, 0), gg geography(multipolygonm, 0) );
select sn_create_distributed_table('tm.multipolygonm0', 'id', 'none');

CREATE TABLE tm.multipolygonm4326 (id serial, g geometry(multipolygonm, 4326), gg geography(multipolygonm, 4326) );
select sn_create_distributed_table('tm.multipolygonm4326', 'id', 'none');

CREATE TABLE tm.multipolygonz (id serial, g geometry(multipolygonz), gg geography(multipolygonz) );
select sn_create_distributed_table('tm.multipolygonz', 'id', 'none');

CREATE TABLE tm.multipolygonz0 (id serial, g geometry(multipolygonz, 0), gg geography(multipolygonz, 0) );
select sn_create_distributed_table('tm.multipolygonz0', 'id', 'none');

CREATE TABLE tm.multipolygonz4326 (id serial, g geometry(multipolygonz, 4326), gg geography(multipolygonz, 4326) );
select sn_create_distributed_table('tm.multipolygonz4326', 'id', 'none');

CREATE TABLE tm.multipolygonzm (id serial, g geometry(multipolygonzm), gg geography(multipolygonzm) );
select sn_create_distributed_table('tm.multipolygonzm', 'id', 'none');

CREATE TABLE tm.multipolygonzm0 (id serial, g geometry(multipolygonzm, 0), gg geography(multipolygonzm, 0) );
select sn_create_distributed_table('tm.multipolygonzm0', 'id', 'none');

CREATE TABLE tm.multipolygonzm4326 (id serial, g geometry(multipolygonzm, 4326), gg geography(multipolygonzm, 4326) );
select sn_create_distributed_table('tm.multipolygonzm4326', 'id', 'none');


CREATE TABLE tm.multipoint (id serial, g geometry(multipoint), gg geography(multipoint) );
select sn_create_distributed_table('tm.multipoint', 'id', 'none');

CREATE TABLE tm.multipoint0 (id serial, g geometry(multipoint, 0), gg geography(multipoint, 0) );
select sn_create_distributed_table('tm.multipoint0', 'id', 'none');

CREATE TABLE tm.multipoint4326 (id serial, g geometry(multipoint, 4326), gg geography(multipoint, 4326) );
select sn_create_distributed_table('tm.multipoint4326', 'id', 'none');

CREATE TABLE tm.multipointm (id serial, g geometry(multipointm), gg geography(multipointm) );
select sn_create_distributed_table('tm.multipointm', 'id', 'none');

CREATE TABLE tm.multipointm0 (id serial, g geometry(multipointm, 0), gg geography(multipointm, 0) );
select sn_create_distributed_table('tm.multipointm0', 'id', 'none');

CREATE TABLE tm.multipointm4326 (id serial, g geometry(multipointm, 4326), gg geography(multipointm, 4326) );
select sn_create_distributed_table('tm.multipointm4326', 'id', 'none');

CREATE TABLE tm.multipointz (id serial, g geometry(multipointz), gg geography(multipointz) );
select sn_create_distributed_table('tm.multipointz', 'id', 'none');

CREATE TABLE tm.multipointz0 (id serial, g geometry(multipointz, 0), gg geography(multipointz, 0) );
select sn_create_distributed_table('tm.multipointz0', 'id', 'none');

CREATE TABLE tm.multipointz4326 (id serial, g geometry(multipointz, 4326), gg geography(multipointz, 4326) );
select sn_create_distributed_table('tm.multipointz4326', 'id', 'none');

CREATE TABLE tm.multipointzm (id serial, g geometry(multipointzm), gg geography(multipointzm) );
select sn_create_distributed_table('tm.multipointzm', 'id', 'none');

CREATE TABLE tm.multipointzm0 (id serial, g geometry(multipointzm, 0), gg geography(multipointzm, 0) );
select sn_create_distributed_table('tm.multipointzm0', 'id', 'none');

CREATE TABLE tm.multipointzm4326 (id serial, g geometry(multipointzm, 4326), gg geography(multipointzm, 4326) );
select sn_create_distributed_table('tm.multipointzm4326', 'id', 'none');


CREATE TABLE tm.multisurface (id serial, g geometry(multisurface) );
select sn_create_distributed_table('tm.multisurface', 'id', 'none');

CREATE TABLE tm.multisurface0 (id serial, g geometry(multisurface, 0) );
select sn_create_distributed_table('tm.multisurface0', 'id', 'none');

CREATE TABLE tm.multisurface4326 (id serial, g geometry(multisurface, 4326) );
select sn_create_distributed_table('tm.multisurface4326', 'id', 'none');

CREATE TABLE tm.multisurfacem (id serial, g geometry(multisurfacem) );
select sn_create_distributed_table('tm.multisurfacem', 'id', 'none');

CREATE TABLE tm.multisurfacem0 (id serial, g geometry(multisurfacem, 0) );
select sn_create_distributed_table('tm.multisurfacem0', 'id', 'none');

CREATE TABLE tm.multisurfacem4326 (id serial, g geometry(multisurfacem, 4326) );
select sn_create_distributed_table('tm.multisurfacem4326', 'id', 'none');

CREATE TABLE tm.multisurfacez (id serial, g geometry(multisurfacez) );
select sn_create_distributed_table('tm.multisurfacez', 'id', 'none');

CREATE TABLE tm.multisurfacez0 (id serial, g geometry(multisurfacez, 0) );
select sn_create_distributed_table('tm.multisurfacez0', 'id', 'none');

CREATE TABLE tm.multisurfacez4326 (id serial, g geometry(multisurfacez, 4326) );
select sn_create_distributed_table('tm.multisurfacez4326', 'id', 'none');

CREATE TABLE tm.multisurfacezm (id serial, g geometry(multisurfacezm) );
select sn_create_distributed_table('tm.multisurfacezm', 'id', 'none');

CREATE TABLE tm.multisurfacezm0 (id serial, g geometry(multisurfacezm, 0) );
select sn_create_distributed_table('tm.multisurfacezm0', 'id', 'none');

CREATE TABLE tm.multisurfacezm4326 (id serial, g geometry(multisurfacezm, 4326) );
select sn_create_distributed_table('tm.multisurfacezm4326', 'id', 'none');


CREATE TABLE tm.point (id serial, g geometry(point), gg geography(point) );
select sn_create_distributed_table('tm.point', 'id', 'none');

CREATE TABLE tm.point0 (id serial, g geometry(point, 0), gg geography(point, 0) );
select sn_create_distributed_table('tm.point0', 'id', 'none');

CREATE TABLE tm.point4326 (id serial, g geometry(point, 4326), gg geography(point, 4326) );
select sn_create_distributed_table('tm.point4326', 'id', 'none');

CREATE TABLE tm.pointm (id serial, g geometry(pointm), gg geography(pointm) );
select sn_create_distributed_table('tm.pointm', 'id', 'none');

CREATE TABLE tm.pointm0 (id serial, g geometry(pointm, 0), gg geography(pointm, 0) );
select sn_create_distributed_table('tm.pointm0', 'id', 'none');

CREATE TABLE tm.pointm4326 (id serial, g geometry(pointm, 4326), gg geography(pointm, 4326) );
select sn_create_distributed_table('tm.pointm4326', 'id', 'none');

CREATE TABLE tm.pointz (id serial, g geometry(pointz), gg geography(pointz) );
select sn_create_distributed_table('tm.pointz', 'id', 'none');

CREATE TABLE tm.pointz0 (id serial, g geometry(pointz, 0), gg geography(pointz, 0) );
select sn_create_distributed_table('tm.pointz0', 'id', 'none');

CREATE TABLE tm.pointz4326 (id serial, g geometry(pointz, 4326), gg geography(pointz, 4326) );
select sn_create_distributed_table('tm.pointz4326', 'id', 'none');

CREATE TABLE tm.pointzm (id serial, g geometry(pointzm), gg geography(pointzm) );
select sn_create_distributed_table('tm.pointzm', 'id', 'none');

CREATE TABLE tm.pointzm0 (id serial, g geometry(pointzm, 0), gg geography(pointzm, 0) );
select sn_create_distributed_table('tm.pointzm0', 'id', 'none');

CREATE TABLE tm.pointzm4326 (id serial, g geometry(pointzm, 4326), gg geography(pointzm, 4326) );
select sn_create_distributed_table('tm.pointzm4326', 'id', 'none');


CREATE TABLE tm.polygon (id serial, g geometry(polygon), gg geography(polygon) );
select sn_create_distributed_table('tm.polygon', 'id', 'none');

CREATE TABLE tm.polygon0 (id serial, g geometry(polygon, 0), gg geography(polygon, 0) );
select sn_create_distributed_table('tm.polygon0', 'id', 'none');

CREATE TABLE tm.polygon4326 (id serial, g geometry(polygon, 4326), gg geography(polygon, 4326) );
select sn_create_distributed_table('tm.polygon4326', 'id', 'none');

CREATE TABLE tm.polygonm (id serial, g geometry(polygonm), gg geography(polygonm) );
select sn_create_distributed_table('tm.polygonm', 'id', 'none');

CREATE TABLE tm.polygonm0 (id serial, g geometry(polygonm, 0), gg geography(polygonm, 0) );
select sn_create_distributed_table('tm.polygonm0', 'id', 'none');

CREATE TABLE tm.polygonm4326 (id serial, g geometry(polygonm, 4326), gg geography(polygonm, 4326) );
select sn_create_distributed_table('tm.polygonm4326', 'id', 'none');

CREATE TABLE tm.polygonz (id serial, g geometry(polygonz), gg geography(polygonz) );
select sn_create_distributed_table('tm.polygonz', 'id', 'none');

CREATE TABLE tm.polygonz0 (id serial, g geometry(polygonz, 0), gg geography(polygonz, 0) );
select sn_create_distributed_table('tm.polygonz0', 'id', 'none');

CREATE TABLE tm.polygonz4326 (id serial, g geometry(polygonz, 4326), gg geography(polygonz, 4326) );
select sn_create_distributed_table('tm.polygonz4326', 'id', 'none');

CREATE TABLE tm.polygonzm (id serial, g geometry(polygonzm), gg geography(polygonzm) );
select sn_create_distributed_table('tm.polygonzm', 'id', 'none');

CREATE TABLE tm.polygonzm0 (id serial, g geometry(polygonzm, 0), gg geography(polygonzm, 0) );
select sn_create_distributed_table('tm.polygonzm0', 'id', 'none');

CREATE TABLE tm.polygonzm4326 (id serial, g geometry(polygonzm, 4326), gg geography(polygonzm, 4326) );
select sn_create_distributed_table('tm.polygonzm4326', 'id', 'none');


CREATE TABLE tm.polyhedralsurface (id serial, g geometry(polyhedralsurface) );
select sn_create_distributed_table('tm.polyhedralsurface', 'id', 'none');

CREATE TABLE tm.polyhedralsurface0 (id serial, g geometry(polyhedralsurface, 0) );
select sn_create_distributed_table('tm.polyhedralsurface0', 'id', 'none');

CREATE TABLE tm.polyhedralsurface4326 (id serial, g geometry(polyhedralsurface, 4326) );
select sn_create_distributed_table('tm.polyhedralsurface4326', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacem (id serial, g geometry(polyhedralsurfacem) );
select sn_create_distributed_table('tm.polyhedralsurfacem', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacem0 (id serial, g geometry(polyhedralsurfacem, 0) );
select sn_create_distributed_table('tm.polyhedralsurfacem0', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacem4326 (id serial, g geometry(polyhedralsurfacem, 4326) );
select sn_create_distributed_table('tm.polyhedralsurfacem4326', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacez (id serial, g geometry(polyhedralsurfacez) );
select sn_create_distributed_table('tm.polyhedralsurfacez', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacez0 (id serial, g geometry(polyhedralsurfacez, 0) );
select sn_create_distributed_table('tm.polyhedralsurfacez0', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacez4326 (id serial, g geometry(polyhedralsurfacez, 4326) );
select sn_create_distributed_table('tm.polyhedralsurfacez4326', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacezm (id serial, g geometry(polyhedralsurfacezm) );
select sn_create_distributed_table('tm.polyhedralsurfacezm', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacezm0 (id serial, g geometry(polyhedralsurfacezm, 0) );
select sn_create_distributed_table('tm.polyhedralsurfacezm0', 'id', 'none');

CREATE TABLE tm.polyhedralsurfacezm4326 (id serial, g geometry(polyhedralsurfacezm, 4326) );
select sn_create_distributed_table('tm.polyhedralsurfacezm4326', 'id', 'none');


CREATE TABLE tm.tin (id serial, g geometry(tin) );
select sn_create_distributed_table('tm.tin', 'id', 'none');

CREATE TABLE tm.tin0 (id serial, g geometry(tin, 0) );
select sn_create_distributed_table('tm.tin0', 'id', 'none');

CREATE TABLE tm.tin4326 (id serial, g geometry(tin, 4326) );
select sn_create_distributed_table('tm.tin4326', 'id', 'none');

CREATE TABLE tm.tinm (id serial, g geometry(tinm) );
select sn_create_distributed_table('tm.tinm', 'id', 'none');

CREATE TABLE tm.tinm0 (id serial, g geometry(tinm, 0) );
select sn_create_distributed_table('tm.tinm0', 'id', 'none');

CREATE TABLE tm.tinm4326 (id serial, g geometry(tinm, 4326) );
select sn_create_distributed_table('tm.tinm4326', 'id', 'none');

CREATE TABLE tm.tinz (id serial, g geometry(tinz) );
select sn_create_distributed_table('tm.tinz', 'id', 'none');

CREATE TABLE tm.tinz0 (id serial, g geometry(tinz, 0) );
select sn_create_distributed_table('tm.tinz0', 'id', 'none');

CREATE TABLE tm.tinz4326 (id serial, g geometry(tinz, 4326) );
select sn_create_distributed_table('tm.tinz4326', 'id', 'none');

CREATE TABLE tm.tinzm (id serial, g geometry(tinzm) );
select sn_create_distributed_table('tm.tinzm', 'id', 'none');

CREATE TABLE tm.tinzm0 (id serial, g geometry(tinzm, 0) );
select sn_create_distributed_table('tm.tinzm0', 'id', 'none');

CREATE TABLE tm.tinzm4326 (id serial, g geometry(tinzm, 4326) );
select sn_create_distributed_table('tm.tinzm4326', 'id', 'none');


CREATE TABLE tm.triangle (id serial, g geometry(triangle) );
select sn_create_distributed_table('tm.triangle', 'id', 'none');

CREATE TABLE tm.triangle0 (id serial, g geometry(triangle, 0) );
select sn_create_distributed_table('tm.triangle0', 'id', 'none');

CREATE TABLE tm.triangle4326 (id serial, g geometry(triangle, 4326) );
select sn_create_distributed_table('tm.triangle4326', 'id', 'none');

CREATE TABLE tm.trianglem (id serial, g geometry(trianglem) );
select sn_create_distributed_table('tm.trianglem', 'id', 'none');

CREATE TABLE tm.trianglem0 (id serial, g geometry(trianglem, 0) );
select sn_create_distributed_table('tm.trianglem0', 'id', 'none');

CREATE TABLE tm.trianglem4326 (id serial, g geometry(trianglem, 4326) );
select sn_create_distributed_table('tm.trianglem4326', 'id', 'none');

CREATE TABLE tm.trianglez (id serial, g geometry(trianglez) );
select sn_create_distributed_table('tm.trianglez', 'id', 'none');

CREATE TABLE tm.trianglez0 (id serial, g geometry(trianglez, 0) );
select sn_create_distributed_table('tm.trianglez0', 'id', 'none');

CREATE TABLE tm.trianglez4326 (id serial, g geometry(trianglez, 4326) );
select sn_create_distributed_table('tm.trianglez4326', 'id', 'none');

CREATE TABLE tm.trianglezm (id serial, g geometry(trianglezm) );
select sn_create_distributed_table('tm.trianglezm', 'id', 'none');

CREATE TABLE tm.trianglezm0 (id serial, g geometry(trianglezm, 0) );
select sn_create_distributed_table('tm.trianglezm0', 'id', 'none');

CREATE TABLE tm.trianglezm4326 (id serial, g geometry(trianglezm, 4326) );
select sn_create_distributed_table('tm.trianglezm4326', 'id', 'none');


SELECT 'g',
 f_table_name, f_geometry_column,
 coord_dimension, srid, type
from geometry_columns ORDER BY f_table_name;

SELECT 'gg',
 f_table_name, f_geography_column,
 coord_dimension, srid, type
from geography_columns ORDER BY f_table_name;

SELECT distinct 'catalog-schema', f_table_catalog = current_database(),f_table_schema FROM geometry_columns
UNION
SELECT distinct 'catalog-schema', f_table_catalog = current_database(),f_table_schema FROM geography_columns
;

CREATE TABLE tm.types (id serial, g geometry);
select sn_create_distributed_table('tm.types', 'id', 'none');

INSERT INTO tm.types(g) values ('POINT EMPTY');
INSERT INTO tm.types(g) values ('POINT(0 0)');
INSERT INTO tm.types(g) values ('LINESTRING EMPTY');
INSERT INTO tm.types(g) values ('POLYGON EMPTY');
INSERT INTO tm.types(g) values ('MULTIPOINT EMPTY');
INSERT INTO tm.types(g) values ('MULTIPOINT(0 0)');
INSERT INTO tm.types(g) values ('MULTILINESTRING EMPTY');
INSERT INTO tm.types(g) values ('MULTIPOLYGON EMPTY');
INSERT INTO tm.types(g) values ('GEOMETRYCOLLECTION EMPTY');
INSERT INTO tm.types(g) values ('CIRCULARSTRING EMPTY');
INSERT INTO tm.types(g) values ('COMPOUNDCURVE EMPTY');
INSERT INTO tm.types(g) values ('CURVEPOLYGON EMPTY');
INSERT INTO tm.types(g) values ('MULTICURVE EMPTY');
INSERT INTO tm.types(g) values ('MULTISURFACE EMPTY');
INSERT INTO tm.types(g) values ('POLYHEDRALSURFACE EMPTY');
INSERT INTO tm.types(g) values ('TRIANGLE EMPTY');
INSERT INTO tm.types(g) values ('TIN EMPTY');

-- all zm flags (17 is the number of base types)
INSERT INTO tm.types(id, g)
SELECT id, st_force3dz(g) FROM tm.types WHERE id <= 17 ORDER BY id;
INSERT INTO tm.types(id, g)
SELECT id, st_force3dm(g) FROM tm.types WHERE id <= 17 ORDER BY id;
INSERT INTO tm.types(id, g)
SELECT id, st_force4d(g) FROM tm.types WHERE id <= 17 ORDER BY id;

-- known srid
INSERT INTO tm.types(id, g)
SELECT id, st_setsrid(g,4326) FROM tm.types ORDER BY id;

-- Expected: 17 (base count) * 4 (zmflag combinations) * 2 (srids)
SELECT 'num_types', count(*) from tm.types;

-- Now try to insert each type into each table
CREATE FUNCTION tm.insert_all(tmpfile_prefix text)
RETURNS TABLE(out_where varchar, out_srid int, out_type varchar, out_flags varchar, out_status text)
AS
$$
DECLARE
	sql text;
	rec RECORD;
	rec2 RECORD;
	tmpfile text;
	cnt INT;
	hasgeog BOOL;
BEGIN

	tmpfile := tmpfile_prefix;

	FOR rec2 IN SELECT * from tm.types ORDER BY id
	LOOP
		tmpfile := tmpfile_prefix || rec2.id;
		sql := 'COPY ( SELECT g FROM tm.types WHERE id = ' || rec2.id || ') TO '
			|| quote_literal(tmpfile)
			|| ' WITH BINARY ';
		EXECUTE sql;
	END LOOP;

	FOR rec IN SELECT * from geometry_columns
		WHERE f_table_name != 'types' ORDER BY 3
	LOOP
		out_where := rec.f_table_name;

		hasgeog := rec.type NOT LIKE '%CURVE%'
  			AND rec.type NOT LIKE '%CIRCULAR%'
  			AND rec.type NOT LIKE '%SURFACE%'
  			AND rec.type NOT LIKE 'TRIANGLE%'
  			AND rec.type NOT LIKE 'TIN%';

		FOR rec2 IN SELECT * from tm.types ORDER BY id
		LOOP
			out_srid := ST_Srid(rec2.g);
			out_type := substr(ST_GeometryType(rec2.g), 4);
			IF NOT ST_IsEmpty(rec2.g) THEN
				out_type := out_type || 'NE';
			END IF;
			out_flags := ST_zmflag(rec2.g);
			BEGIN
				sql := 'INSERT INTO '
					|| quote_ident(rec.f_table_schema)
					|| '.' || quote_ident(rec.f_table_name)
					|| '(g) VALUES ('
					|| quote_literal(rec2.g::text)
					|| ');';
				EXECUTE sql;
				out_status := 'OK';
			EXCEPTION
			WHEN OTHERS THEN
				out_status := 'KO'; -- || SQLERRM;
			END;

			-- binary insertion {
			tmpfile := tmpfile_prefix || rec2.id;
			sql := 'COPY '
				|| quote_ident(rec.f_table_schema)
				|| '.' || quote_ident(rec.f_table_name)
				|| '(g) FROM '
				|| quote_literal(tmpfile) || ' WITH BINARY ';
			BEGIN
				EXECUTE sql;
				out_status := out_status || '-BOK';
			EXCEPTION
			WHEN OTHERS THEN
				out_status := out_status || '-BKO';
			END;
			-- }


			IF NOT hasgeog THEN
				RETURN NEXT;
				CONTINUE;
			END IF;

			BEGIN
				sql := 'INSERT INTO '
					|| quote_ident(rec.f_table_schema)
					|| '.' || quote_ident(rec.f_table_name)
					|| '(gg) VALUES ('
					|| quote_literal(rec2.g::text)
					|| ');';
				EXECUTE sql;
				out_status := out_status || '-GOK';
			EXCEPTION
			WHEN OTHERS THEN
				out_status := out_status || '-GKO';
			END;

			-- binary insertion (geography) {
			sql := 'COPY '
				|| quote_ident(rec.f_table_schema)
				|| '.' || quote_ident(rec.f_table_name)
				|| '(gg) FROM '
				|| quote_literal(tmpfile) || ' WITH BINARY ';
			BEGIN
				EXECUTE sql;
				out_status := out_status || '-BGOK';
			EXCEPTION
			WHEN OTHERS THEN
				out_status := out_status || '-BGKO'; -- || SQLERRM;
			END;
			-- }

			RETURN NEXT;
		END LOOP;

		-- Count number of geometries in the table
		sql := 'SELECT count(g) FROM '
			|| quote_ident(rec.f_table_schema)
			|| '.' || quote_ident(rec.f_table_name);
		EXECUTE sql INTO STRICT cnt;

		out_srid := NULL;
		out_type := 'COUNT';
		out_flags := cnt;
		out_status := NULL;
		RETURN NEXT;

		IF hasgeog THEN
			-- Count number of geographies in the table
			sql := 'SELECT count(gg) FROM '
				|| quote_ident(rec.f_table_schema)
				|| '.' || quote_ident(rec.f_table_name);
			EXECUTE sql INTO STRICT cnt;

			out_srid := NULL;
			out_type := 'GCOUNT';
			out_flags := cnt;
			out_status := NULL;
			RETURN NEXT;
		END IF;

	END LOOP;
END;
$$ LANGUAGE 'plpgsql';

-- SELECT * FROM tm.insert_all(:tmpfile);

DROP SCHEMA tm CASCADE;

