1.将本文件所在目录以oracle用户上传到/home/oracle目录下，上传后检查目录属组是不是 oracle:oinstall

2.归档状态检查（su - oracle）
[oracle@n2 ~]$ sqlplus / as sysdba

SQL*Plus: Release 11.2.0.4.0 Production on Fri Sep 15 09:34:18 2017

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            /oradataa/arch
Oldest online log sequence     41
Next log sequence to archive   43
Current log sequence           43
SQL> 

如果Database log mode一行显示 Archive Mode 则为归档模式；显示 No Archive Mode 则为非归档模式；

rman备份需要数据库处在 归档模式，如果是非归档模式则需要修改为归档模式，方法如下：
<1>.创建归档目录
mkdir /oradataa/arch

<2>.修改数据库参数、设置归档
sqlplus / as sysdba

alter system set log_archive_dest_1='location=/oradataa/arch';
alter system set log_archive_format='arch_%d_%r_%t_%s.log' scope=spfile;
alter system set db_block_checking=true;
--alter database disable block change tracking;
alter database enable block change tracking using file '/oradataa/change_tracking.f';

shutdown immediate
startup mount
alter database archivelog;
alter database open;

3.创建rman备份目录，并挂载远程盘（挂载好远程盘后再检查一下目录的属组是不是 oracle:oinstall）
mkdir /rmanbk
chown oracle:oinstall /rmanbk

4.rman参数配置
rman target /

configure retention policy to recovery window of 1 days;
configure controlfile autobackup on;
configure controlfile autobackup format for device type disk to '/rmanbk/cro_%F';

5.copy定时脚本，并修改权限
cp rman_daily /etc/cron.d
chmod 644 /etc/cron.d/rman_daily
