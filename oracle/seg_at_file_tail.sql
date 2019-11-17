--缩小指定数据文件到指定大小，需要装超过指定大小的段移走
--DBF_DEST_SIZE_BYTE 数据文件的目标大小，单位byte
--f.file#      => file_id
--e.ktfbuebno  => block_id
select distinct owner, segment_name, partition_name, segment_type, tablespace_name, file_id
  from (select ds.owner, ds.segment_name, ds.partition_name, ds.segment_type,
               ds.tablespace_name,
               e.ktfbueextno extent_id, f.file# file_id, e.ktfbuebno block_id,
               e.ktfbueblks * ds.blocksize bytes, e.ktfbueblks blocks, e.ktfbuefno relative_fno
          from sys.sys_dba_segs ds, sys.x$ktfbue e, sys.file$ f
         where e.ktfbuesegfno = ds.relative_fno
           and e.ktfbuesegbno = ds.header_block
           and e.ktfbuesegtsn = ds.tablespace_id
           and ds.tablespace_id = f.ts#
           and e.ktfbuefno = f.relfile#
           and f.file#=5
           and e.ktfbuebno>&DBF_DEST_SIZE_BYTE/8192);
