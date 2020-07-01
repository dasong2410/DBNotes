## Tablespace

### Create tablespace

```sql
create bigfile tablespace dasong
datafile '/oracle/ora11g/oradata/dasong.dbf' size 1g
autoextend on next 1g;
```

### Alter tablesapce

```sql
--查询表空间、数据文件id、数据文件名
select tablespace_name, file_id, file_name from dba_data_files;

--修改表空间名
alter tablespace tablespace_name1 rename to tablespace_name2;

--修改分区表表空间属性
alter table table_name modify default attributes tablespace tablespace_name;

--bigfile
alter tablespace tablespace_name resize 100m;
alter tablespace tablespace_name autoextend on next 100m;

--smallfile
alter database datafile 5 resize 10m;
alter database datafile 5 autoextend on next 100m;
```

### Drop tablespace

```sql
drop tablespace dasong including contents and datafiles;
```

### Query tablesapce datafiles

```sql
select file#, name, trunc(bytes/1024/1024/1024, 2) "Size(G)" from v$datafile;

select file_id, file_name, trunc(bytes/1024/1024/1024, 2) "Size(G)", tablespace_name
    from dba_data_files
    order by file_id;
```

### Get tablespace ddl

```sql
--print every tablespace's ddl sentance
set serveroutput on;

begin
    for l_tbs in (select name from v$tablespace) loop
    dbms_output.put_line(dbms_metadata.get_ddl(object_type => 'TABLESPACE', name => l_tbs.name) || ';');
    end loop;
end;
/
```

### Tablespace size

```sql
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
```

### Temp tablespace usage

```sql
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
  from (select sql_id, sum(nvl(temp_space, 0)) temp_bytes
          from v$sql_plan 
         group by sql_id) a,
       v$sql b
 where a.sql_id=b.sql_id
 order by temp_bytes desc;

--历史执行计划中临时表空间
select a.*, b.sql_text
  from (select sql_id, sum(nvl(temp_space, 0)) temp_bytes
          from dba_hist_sql_plan
          group by sql_id) a,
       dba_hist_sqltext b
 where a.sql_id=b.sql_id
 order by temp_bytes desc;
```
