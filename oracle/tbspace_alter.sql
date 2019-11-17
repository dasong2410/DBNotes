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
