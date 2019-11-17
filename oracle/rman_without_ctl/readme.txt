丢失控制文件及其备份的情况，使用rman备份恢复数据库

--1.新建一个数据库，在rman中catalog旧数据库的备份文件，会得到旧库的dbid、dbname

--2.将数据库重启为read only
sqlplus / as sysdba
shutdown immediate;
startup open read only;

--3.执行change_dbid.sql，修改数据库dbid、dbname为旧库dbid、dbname

--4.如果新、旧dbname不一样，还要修改spfile中的db_name的值，重启数据库到open（可能需要resetlogs）

--5.在rman中catalog旧库备份文件

--6.刷入prc_backup_restore.sql存储过程

--6.恢复数据文件
set serveroutput on;

begin
  for f in(select distinct file# fno from v$backup_datafile where file#!=0 order by file#) loop
    prc_backup_restore(f.fno, '/oradataa');
  end loop;
end;
/

--7.重建控制文件，使包含所有的数据文件，并启动数据库（可能需要resetlogs）
