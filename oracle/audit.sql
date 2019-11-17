--1. 每个操作记录一条记录，insert、update、delete
--2. 一般一个insert插入一条记录，所以insert可能会多一倍的数据，即可能不少于一倍的资源开销
--3. sqlldr导入的数据每提交一次记一条记录，要考滤sqlldr是否要修改导入参数，以确定一个大概的提交条数（或者考滤不记录入库表）
--4. 如果要开audit，要考audit数据的保存周期

show parameter audit

alter system flush buffer_cache;
alter system flush shared_pool;

--查询audit日志
truncate table sys.aud$;
select * from dba_audit_trail;
select * from sys.aud$;

--audit代码表
select * from audit_actions;

--设置audit or noaudit（所有表都会audit，产生的数据量比较大）
audit table by access;
audit insert table by access;
audit select table by access;
audit update table by access;
audit delete table by access;

noaudit table;
noaudit insert table;
noaudit select table;
noaudit update table;
noaudit delete table;

--设置单表audit or noaudit
audit insert on outside.t_audi_test;
audit select on outside.t_audi_test;
audit update on outside.t_audi_test;
audit delete on outside.t_audi_test;

noaudit insert on outside.t_audi_test;
noaudit select on outside.t_audi_test;
noaudit update on outside.t_audi_test;
noaudit delete on outside.t_audi_test;

--修改表数据
insert
select
update
delete
