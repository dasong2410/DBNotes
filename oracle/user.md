## User

### Modify user

```sql
alter user dasong identified by dasong;
alter user dasong default tablespace dasong;
```

### Create user

```sql
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
```

### Drop user

```sql
accept usr_name varchar2(512) prompt '请输入要删除的用户名：'

set verify off
set feedback off
set serveroutput on

begin
	for l_sess in (select sid, serial# from v$session where username=upper('&&usr_name')) loop
	execute immediate 'alter system kill session ''' || l_sess.sid || ', ' || l_sess.serial# || '''';
	end loop;

	execute immediate 'drop user &&usr_name cascade';
exception
	when others then
	dbms_output.put_line(sqlerrm);
end;
/

set verify on
set feedback on
set serveroutput off
```

### Drop user objects

```sql
--删除用户下的对象
set serveroutput on;
begin
	if(user!='SYS' and user!='SYSTEM') then
	--删除表
	dbms_output.put_line('Drop table:');

	for l_tab in (select table_name from user_tables) loop
		begin
		execute immediate 'drop table ' || l_tab.table_name || ' purge';

		dbms_output.put_line('  Succ: ' || l_tab.table_name);
		exception
		when others then
			dbms_output.put_line('  Fail: ' || l_tab.table_name);
		end;
	end loop;

	--删除视图
	dbms_output.put_line(chr(10) || 'Drop view:');

	for l_view in (select view_name from user_views) loop
		begin
		execute immediate 'drop view ' || l_view.view_name;

		dbms_output.put_line('  Succ: ' || l_view.view_name);
		exception
		when others then
			dbms_output.put_line('  Fail: ' || l_view.view_name);
		end;
	end loop;

	--删除序列
	dbms_output.put_line(chr(10) || 'Drop sequence:');

	for l_seq in (select sequence_name from user_sequences) loop
		begin
		execute immediate 'drop sequence ' || l_seq.sequence_name;

		dbms_output.put_line('  Succ: ' || l_seq.sequence_name);
		exception
		when others then
			dbms_output.put_line('  Fail: ' || l_seq.sequence_name);
		end;
	end loop;

	--删除作业
	dbms_output.put_line(chr(10) || 'Drop job:');

	for l_job in (select job_name from user_scheduler_jobs) loop
		begin
		dbms_scheduler.drop_job(job_name=>l_job.job_name, force=>true);

		dbms_output.put_line('  Succ: ' || l_job.job_name);
		exception
		when others then
			dbms_output.put_line('  Fail: ' || l_job.job_name);
		end;
	end loop;
	else
	dbms_output.put_line('Caution: You can''t drop any object of a system user.');
	end if;
end;
/
```

### Drop user from $user

```sql
--删除用户（直接删除user$中的数据，用户中的数据等不会被删除，这种情况可能会由断电造成的数据字典中元数据的丢失，但是实际的数据还存在）
--select * from user$ where name='FOX';
delete from user$ where name='FOX';
commit;

--找出上一步删除的用户的user#
select * from seg$ where user# not in(select user# from user$);

--插入一条数据，新增用户
--（以下insert可以把user$中选一条普通用户的数据卖出，然后修改一下user#、name；
--用户名根据实际情况修改；
--password字段如果给null，则可以用之前的密码登录，所以此字段应该是可填可不填）
insert into user$ (user#,name,type#,password,datats#,tempts#,ctime,ptime,exptime,ltime,resource$,audit$,defrole,defgrp#,defgrp_seq#,astatus,lcount,defschclass,ext_username,spare1,spare2,spare3,spare4,spare5,spare6) values (233,'FOX',1,'352636B8F2EB9D65',16,3,to_date('2015-01-27 10:58:30','YYYY-MM-DD HH24:MI:SS'),to_date('2015-01-27 10:58:30','YYYY-MM-DD HH24:MI:SS'),null,null,0,null,1,null,null,0,0,'DEFAULT_CONSUMER_GROUP',null,0,null,null,'S:9A4467E8962B4C438A82769C76A42DD0B1B0D8226C25FF7B4886E19DF486',null,null);
commit;

--修改密码
alter system flush shared_pool;
alter system flush buffer_cache;
alter user fox identified by fox;

--使用新增加的用户登录数据，验证一下数据有没有丢失
--检查一下dba_users中默认表空间等是否正确，如果不正确根据实际情况修改
--alter user fox default tablespace fox;
```

### Rename user

```sql
--最好不要操作
update user$ set name='KEYWORD' where name='FHNSDB';
commit;

alter system flush shared_pool;
alter system flush buffer_cache;
alter user keyword identified by keyword;

--修复用户名可能会导致job失效
```
