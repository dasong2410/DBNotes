--单次物理读排序
select b.sql_fulltext, b.physical_read_bytes, a.*
  from v$session a, v$sql b
 where a.sql_id=b.sql_id
 order by b.physical_read_bytes/decode(b.executions, 0, 1, b.executions) desc;

--总物理读排序
select b.sql_fulltext, b.physical_read_bytes, a.*
  from v$session a, v$sql b
 where a.sql_id=b.sql_id
 order by b.physical_read_bytes desc;

--单次物理写排序
select b.sql_fulltext, b.physical_write_bytes, a.*
  from v$session a, v$sql b
 where a.sql_id=b.sql_id
 order by b.physical_write_bytes/decode(b.executions, 0, 1, b.executions) desc;

--总物理写排序
select b.sql_fulltext, b.physical_write_bytes, a.*
  from v$session a, v$sql b
 where a.sql_id=b.sql_id
 order by b.physical_write_bytes desc;
