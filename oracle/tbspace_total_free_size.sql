select a.tablespace_name,
       trunc(a.bytes/1024/1024/1024, 2) "TOTAL(G)",
       trunc(b.bytes/1024/1024/1024, 2) "FREE(G)",
       trunc(b.bytes/a.bytes, 4)*100 "FREE(%)"
  from (select tablespace_name, sum(bytes) bytes from dba_data_files
         group by tablespace_name) a,
       (select tablespace_name, sum(bytes) bytes from dba_free_space
         group by tablespace_name) b
 where a.tablespace_name = b.tablespace_name
 order by a.bytes desc;
