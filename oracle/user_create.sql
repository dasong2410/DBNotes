--现有数据文件名及路径
select file#, name from v$datafile order by file#;

--创建表空间
create bigfile tablespace dasong
datafile '/oracle/oracle/oradata/orcl/dasong.dbf' size 100M
autoextend on next 10M;

--创建用户并赋常用权限
create user &&user_name identified by &&password
default tablespace dasong
temporary tablespace temp;

grant create session to &&user_name;
grant resource to &&user_name;
grant debug connect session to &&user_name;
grant debug any procedure to &&user_name;
grant select_catalog_role to &&user_name;
