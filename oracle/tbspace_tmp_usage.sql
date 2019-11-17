select tablespace_name, owner, sum(bytes) bytes
  from v$temp_extent_map
 group by tablespace_name, owner;

--正在被使用的临时表空间
select sql_id, tablespace, sum(nvl(blocks, 0)) blks_temp
  from v$tempseg_usage
 group by sql_id, tablespace
 order by sum(nvl(blocks, 0)) desc;

--当前执行计划中临时表空间
select a.*, b.sql_text
  from (select sql_id, sum(nvl(temp_space, 0)) temp_bytes from v$sql_plan group by sql_id) a,
       v$sql b
 where a.sql_id=b.sql_id
 order by temp_bytes desc;

--历史执行计划中临时表空间
select a.*, b.sql_text
  from (select sql_id, sum(nvl(temp_space, 0)) temp_bytes from dba_hist_sql_plan group by sql_id) a,
       dba_hist_sqltext b
 where a.sql_id=b.sql_id
 order by temp_bytes desc;
