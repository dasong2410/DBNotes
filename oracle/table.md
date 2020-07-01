## Table

### Create table

```sql
create table t_test
(
  c1 number,
  c2 varchar2(32)
);
```

### Drop table

```sql
drop table t_test[ purge];
```

### Rename table

```sql
alter table t_test rename to t_test1;
```

### Add column

```sql
alter table t_test add(c3 number);
```

### Drop column

```sql
alter table t_test drop(c3);
```

### Rename column

```sql
alter table table_name rename column column_name1 to column_name2;
```

### Get indexed columns

```sql
select table_name, index_name,
       listagg(column_name || ': ' || descend, ', ') within group(order by column_position) index_cols
  from user_ind_columns
 where table_name like upper('%%')
   and index_name like upper('%%')
 group by table_name, index_name
 order by table_name, index_name;
```

### Create external table

```sql
--创建directory，用来存储要加载的数据
create or replace directory dir_datapump as '/home/oracle/datapump';

--创建外部表
--drop table ext_wxrecord;
create table ext_wxrecord
(
  version     varchar2(20),
  type        varchar2(20),
  dtp         varchar2(255),
  charset1    varchar2(20),
  msgid       varchar2(255),
  groupid     varchar2(255),
  userid      varchar2(255),
  accountname varchar2(255),
  capturetime varchar2(255),
  msgtype     varchar2(255),
  content     clob,
  playlength  varchar2(255),
  length      varchar2(255),
  clientip    varchar2(255),
  mainfile    varchar2(255),
  filename    varchar2(255),
  codeid      varchar2(255)
)
organization external
(
  type oracle_loader
  default directory dir_datapump
  access parameters
  (
  records delimited by newline
  fields terminated by '\t'
  (
    version     char(20),
    type        char(20),
    dtp         char(255),
    charset1    char(20),
    msgid       char(255),
    groupid     char(255),
    userid      char(255),
    accountname char(255),
    capturetime char(255),
    msgtype     char(255),
    content     char(32767),
    playlength  char(255),
    length      char(255),
    clientip    char(255),
    mainfile    char(255),
    filename    char(255),
    codeid      char(255)
  )
  )
  location ('out_put_1000.txt', 'out_put_1001.txt')
);

--从外部表加载数据到普通表，现在的情况是有5台机器按groupid加载数据；
--ora_hash(groupid, 4)的值为0-4，每台机器选取一个值；
--创建的普通表按groupid建128个分区
--
--drop table wxrecord;
create table wxrecord nologging
partition by hash(groupid)
partitions 128
as
select /*+ append */ * from ext_wxrecord a where ora_hash(groupid, 4)=0;

--因为要过滤groupid，groupid又是散乱在每个文件中，所以每台机器上都要导所有的 文本数据 的文件；
--加载到普通的表的时候再过滤，数据不会复入
```

### Get table ddl

```sql
--获取表的ddl
set serveroutput on;

--当前用户下所有表
begin
  for l_tb in (select table_name from user_tables) loop
  dbms_output.put_line(dbms_metadata.get_ddl(object_type => 'TABLE', name => l_tb.table_name) || ';');
  end loop;
end;
/

--当前用户下指定表
begin
  dbms_output.put_line(dbms_metadata.get_ddl(object_type => 'TABLE', name => upper('&table_name')) || ';');
end;
/
```

### Get table size

```sql
select segment_name, trunc(sum(bytes)/1024/1024/1024, 2) "SIZE(G)"
  from user_segments
  where segment_type like '%TABLE%'
  group by segment_name
  order by sum(bytes) desc;

select segment_name, partition_name, trunc(sum(bytes)/1024/1024/1024, 2) "SIZE(G)"
  from user_segments
  where upper(segment_name)=('table_name')
  group by rollup(segment_name, partition_name);
```

### Get table partition info

```sql
with a as(select name, object_type, listagg(column_name, ', ') within group(order by column_position) part_cols from user_part_key_columns where object_type='TABLE' group by name, object_type),
    b as(select name, object_type, listagg(column_name, ', ') within group(order by column_position) subpart_cols from user_subpart_key_columns where object_type='TABLE' group by name, object_type),
    c as(select a.name, a.part_cols, b.subpart_cols from a,b where a.name=b.name(+) and a.object_type=b.object_type(+)),
    d as(select table_name, partitioning_type, subpartitioning_type, status, def_tablespace_name from user_part_tables)
select d.table_name, d.partitioning_type, c.part_cols, d.subpartitioning_type, c.subpart_cols, d.status, d.def_tablespace_name
  from c,d
  where c.name=d.table_name
  and d.table_name like upper('%%')
  order by d.table_name;
```

### Pivot table

```sql
--创建kv表
drop table t_test_kv;
create table t_test_kv
(
  name varchar2(34),
  subject varchar2(34),
  score number
);

insert into t_test_kv values('dasong1', '语文', 56);
insert into t_test_kv values('dasong1', '数学', 50);
insert into t_test_kv values('dasong1', '英语', 80);
insert into t_test_kv values('dasong2', '语文', 45);
insert into t_test_kv values('dasong2', '数学', 76);
insert into t_test_kv values('dasong2', '英语', 90);
commit;

--pivot，行转列
select * from t_test_kv;
select * from t_test_kv pivot(max(score) for subject in ('语文' as zh, '数学' as math, '英语' as en));

--创建列表
drop table t_test_col;
create table t_test_col
(
  name varchar2(34),
  zh   number,
  math number,
  en   number
);

insert into t_test_col values('dasong1', 56, 50, 80);
insert into t_test_col values('dasong2', 45, 76, 90);
commit;

select * from t_test_col;
select * from t_test_col unpivot(score for subject in (zh as '语文', math as '数学', en as '英语'));
```
