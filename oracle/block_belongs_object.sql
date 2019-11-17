--定位block属于哪个对象
--1.通过查询dba_extents会比较方便，但有时候会查很久不出结果
select owner, segment_name, segment_type, tablespace_name, partition_name
  from dba_extents
 where file_id = 5
   and 776 between block_id and block_id+blocks-1;

--2.通过查询dba_extents低层表，速度会比较快
--f.file#      => file_id
--e.ktfbuebno  => block_id
--e.ktfbueblks => blocks
select ds.owner, ds.segment_name, ds.segment_type,
       ds.tablespace_name, ds.partition_name
  from sys.sys_dba_segs ds, sys.x$ktfbue e, sys.file$ f
 where e.ktfbuesegfno = ds.relative_fno
   and e.ktfbuesegbno = ds.header_block
   and e.ktfbuesegtsn = ds.tablespace_id
   and ds.tablespace_id = f.ts#
   and e.ktfbuefno = f.relfile#
   and f.file# = 5
   and 776 between e.ktfbuebno and e.ktfbuebno+e.ktfbueblks-1;

--3.直接dump block信息到trc文件
alter system dump datafile file# block block#;
alter system dump datafile 5 block 776;
--trc文件名，在文件中搜索obj,objn,Objd可以block属于哪个对象
select value from v$diag_info where name='Default Trace File';
