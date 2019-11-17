-- 注：
-- expdp、impdp用oracle用户执行
-- scp文件后，要检查一下文件的属组是不是oracle:oinstall，如果不是则需要修改
-- 传输表空间不会导出存储过程、函数、job、package等，需要手动处理

--1.新库新建用户
define db_user = outside
define db_passwd = outside
create user &&db_user identified by &&db_passwd default tablespace users;

grant resource to &&db_user;
grant create session to &&db_user;
grant connect to &&db_user;
grant create any table to &&db_user;
grant create any trigger to &&db_user;
grant create any view to &&db_user;
grant drop any table to &&db_user;
grant drop any view to &&db_user;
grant drop any trigger to &&db_user;
grant create any sequence to &&db_user;
grant drop any sequence to &&db_user;
grant create public database link to &&db_user;
grant drop public database link to &&db_user;
grant create database link to &&db_user;
grant all on dbms_lock to &&db_user;
grant scheduler_admin to &&db_user;
grant create any directory to &&db_user;
grant drop any directory to &&db_user;
grant create table to &&db_user;
grant create synonym to &&db_user;
grant manage scheduler to &&db_user;
grant select on sys.dba_data_files to &&db_user;
grant select on sys.dba_free_space to &&db_user;
grant select on sys.v_$session to &&db_user;
grant select on sys.v_$sqlarea to &&db_user;
grant alter system to &&db_user;
grant select any dictionary to &&db_user;
grant debug connect session to &&db_user;
grant debug any procedure to &&db_user;

--2.新、旧库 创建directory
create directory dir_datapump as '/home/oracle';

--3.旧库修改 表空间read only
alter tablespace outside read only;
alter tablespace outside_idx read only;

--4.旧库导出数据
expdp system directory=dir_datapump dumpfile=tts.dmp transport_tablespaces=outside,outside_idx

--5.copy文件
--scp 旧库的数据文件 到 新库 的相同目录
--scp /home/oracle/tts.dmp到新库相同目录，注意新文件的 用户属组 是不是 oracle:oinstall

--6.新库导入
impdp system directory=dir_datapump dumpfile=tts.dmp transport_datafiles='/oradataa/outside.dbf','/oradataa/outside_idx.dbf'

--7.新库修改用户默认表空间、修改表空间为read write
alter user outside default tablespace outside;
alter tablespace outside read write;
alter tablespace outside_idx read write;
