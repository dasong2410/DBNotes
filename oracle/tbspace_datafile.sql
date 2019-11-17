elect file#, name, trunc(bytes/1024/1024/1024, 2) "Size(G)" from v$datafile;

select file_id, file_name, trunc(bytes/1024/1024/1024, 2) "Size(G)", tablespace_name
  from dba_data_files
 order by file_id;
