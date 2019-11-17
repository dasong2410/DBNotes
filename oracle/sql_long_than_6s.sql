select sql_id, sum(nvl(elapsed_seconds, 0)) elapsed_seconds
  from v$session_longops
 group by sql_id
 order by elapsed_seconds desc;

select b.*, a.sql_fulltext
  from v$sql a,
       (select sql_id, sum(nvl(elapsed_seconds, 0)) elapsed_seconds
          from v$session_longops
         group by sql_id) b
 where a.sql_id=b.sql_id
 order by b.elapsed_seconds desc;

select b.*, a.sql_text
  from dba_hist_sqltext a,
       (select sql_id, sum(nvl(elapsed_seconds, 0)) elapsed_seconds
          from v$session_longops
         group by sql_id) b
 where a.sql_id=b.sql_id
 order by b.elapsed_seconds desc;
