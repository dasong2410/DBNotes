--冷迁移直接拷贝相关文件，以下是需要copy的数据文件，拷贝后注意文件的权限
select name file_name from v$datafile
 union all
select name from v$tempfile
 union all
select value from v$parameter where name='spfile'
 union all
select substr(value, 1, instr(value, '/', -1)) || 'orapw' || (select value from v$parameter where name='instance_name') from v$parameter where name in('spfile')
 union all
select value from v$parameter where name='control_files';
