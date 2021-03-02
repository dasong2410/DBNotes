-- postgres
--- regression test for postGIS



--- assume datatypes already defined

---selection



--- TOAST testing

-- create a table with data that will be TOASTed (even after compression)
create table TEST(id int, a GEOMETRY, b GEOMETRY);
select sn_create_distributed_table('TEST', 'id', 'none');

\i sql/regress_biginsert.sql


---test basic ops on this

select '121',box3d(a) as box3d_a, box3d(b) as box3d_b from TEST;

select '122',a <<b from TEST;
select '123',a &<b from TEST;
select '124',a >>b from TEST;
select '125',a &>b from TEST;

select '126',a ~= b from TEST;
select '127',a @ b from TEST;
select '128',a ~ b from TEST;

-- ST_Mem_Size was deprecated in favor of ST_MemSize in 2.2.0
--  ST_Mem_Size will be removed in 2.4.0
select '129', ST_MemSize(PostGIS_DropBBOX(a)), ST_MemSize(PostGIS_DropBBOX(b)) from TEST;

-- Drop test table
DROP table test;
