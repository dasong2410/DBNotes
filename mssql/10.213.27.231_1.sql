-----------------------------------------------------------------------------
-- Database Information: begin
-----------------------------------------------------------------------------
-- sql server info 
SELECT
     SERVERPROPERTY('MachineName') as Host,
     COALESCE(SERVERPROPERTY('InstanceName'), 'MSSQLSERVER') as Instance,
	 serverproperty('collation') server_collation,
	 --SERVERPROPERTY('ProductVersion') AS ProductVersion,
	 --serverproperty('InstanceDefaultLogPath') LogPath,
	 @@VERSION as VersionNumber,
	 SERVERPROPERTY('ProductLevel') as ProductLevel, /* RTM or SP1 etc*/
     SERVERPROPERTY('Edition') as Edition,
	 serverproperty('InstanceDefaultDataPath') DataPath,
	 CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
       WHEN 1 THEN 'Windows Authentication'   
       WHEN 0 THEN 'Windows and SQL Server Authentication'   
     END as [Authentication Mode];

-- listening port
EXEC xp_ReadErrorLog 0, 1, N'Server is listening on', N'any', NULL, NULL, 'DESC'
GO

select @@version;
select * from msdb.dbo.sysjobs;



-- memory
SELECT *
from sys.configurations
where name like '% server memory%';


sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'min server memory', 0;
GO
sp_configure 'max server memory', 2048;
GO
RECONFIGURE;
GO


-- feature installed
-- SQL Server Installation Center/Tools/Installed SQL Server features discovery report



-----------------------------------------------------------------------------
-- Database Information: end
-----------------------------------------------------------------------------

select name, database_id, recovery_model_desc, snapshot_isolation_state_desc, is_read_committed_snapshot_on from sys.databases;
select * from sys.database_files;

-- database info, file size
with a as(select name, database_id, recovery_model_desc, collation_name from sys.databases
--where lower(name) in('schwms_molexctu', 'schwms_molexinv')
),
b as(
select database_id, name, physical_name, sum(size) over(partition by database_id) db_size
from sys.master_files)
select a.name db_name, a.recovery_model_desc, collation_name, round(b.db_size*8/1024/1024, 2) [db_size(G)], b.name file_name, b.physical_name
from a, b where a.database_id=b.database_id;

-- specific database
--use schwms_molexinv;
use schwms_molexctu;
go
with a as(select name, database_id, recovery_model_desc, collation_name from sys.databases where database_id=db_id()),
b as(
select name, physical_name, size from sys.database_files)
select a.name db_name, a.recovery_model_desc, collation_name, cast(b.size*8/1024/1024.00 as numeric(16, 2)) [file_size(G)], b.name file_name, b.physical_name
from a, b;

--EXEC master.dbo.sp_MSforeachdb @command1 = 'select name, physical_name, size from sys.database_files';

select * from sys.databases where lower(name) in('schwms_molexinv', 'schwms_molexctu');
select * from msdb.dbo.backupset where lower(database_name) in('schwms_molexinv', 'schwms_molexctu');

select * from sys.databases where recovery_model_desc='FULL';
select * from msdb.dbo.backupset where database_name in(select name from sys.databases where recovery_model_desc='FULL');

-- error logs
EXEC sp_readerrorlog 0, 1, 'Error', null;
EXEC sp_readerrorlog 0, 2, 'Error', null;

-- error log
create table #error_log
(
LogDate DATETIME,
ProcessInfo VARCHAR(255),
Text VARCHAR(MAX)
);

insert into #error_log
EXEC sp_readerrorlog 0, 2, 'Error';

select * from #error_log where logdate>'2019-11-15' and text not like 'CHECKDB %' and ProcessInfo!='Logon' order by logdate;



select GETDATE();

select * from msdb.dbo.backupset;

-- job info
select * from msdb.dbo.sysjobs;
select * from msdb.dbo.sysjobhistory;
select * from msdb.dbo.sysjobsteps where lower(database_name) in('schwms_molexctu', 'schwms_molexinv') order by job_id, step_id;

select * from msdb.dbo.sysjobsteps order by lower(database_name), job_id, step_id;
select * from msdb.dbo.sysschedules;



-- backup set
select database_name, family_guid, backup_size, compressed_backup_size, backup_start_date, backup_finish_date, type from (
select database_name, family_guid, backup_size, compressed_backup_size, backup_start_date, backup_finish_date, type,
ROW_NUMBER() over(partition by database_name, family_guid, type order by backup_start_date desc) rn
from msdb.dbo.backupset) x1
where x1.rn<4
order by backup_start_date desc, family_guid, type;

select database_name, family_guid, backup_size, compressed_backup_size, backup_start_date, backup_finish_date, type from (
select database_name, family_guid, backup_size, compressed_backup_size, backup_start_date, backup_finish_date, type,
ROW_NUMBER() over(partition by database_name, family_guid, type order by backup_start_date desc) rn
from msdb.dbo.backupset) x1
where x1.rn<4
order by family_guid, type, backup_start_date;

-- last backup time
select * from (
select name, create_date, collation_name, state_desc, recovery_model_desc, log_reuse_wait_desc,
     LastFullBackUpTime=(SELECT MAX(bs.backup_finish_date)
     FROM msdb.dbo.backupset bs
     WHERE
bs.[database_name]=d.[name] AND bs.[type]='D'),
     LastDiffBackUpTime=(SELECT MAX(bs.backup_finish_date)
     FROM msdb.dbo.backupset bs
     WHERE
bs.[database_name]=d.[name] AND bs.[type]='I'),
     LastLogBackUpTime=(SELECT MAX(bs.backup_finish_date)
     FROM msdb.dbo.backupset bs
     WHERE
bs.[database_name]=d.[name] AND bs.[type]='L')
from sys.databases d) x
order by LastFullBackUpTime desc;

select * from sys.databases;


select name, database_id, recovery_model_desc from sys.databases where lower(name) in('schwms_molexctu', 'schwms_molexinv');

-- DBCC SQLPERF(logspace)
select * from sys.dm_db_log_space_usage;
EXEC master.dbo.sp_MSforeachdb @command1 = 'select name, physical_name, size from sys.database_files';

select * from sys.database_files;

select * from msdb.dbo.backupset;


SELECT l.name, l.denylogin, l.isntname, l.isntgroup, l.isntuser
FROM master.dbo.syslogins l
WHERE l.sysadmin = 1 OR l.securityadmin = 1;


select * from master.dbo.syslogins;


-- fragmentation%
-- schwms_molexctu, schwms_molexinv
USE schwms_molexinv;
GO
SELECT 
     --DB_NAME() AS database_name ,
     --s.[object_id] ,
     --o.name AS object_name ,
	 DB_NAME() + '.' + schema_name(o.schema_id) + '.' + o.name table_name,
	 i.name index_name,
     --index_type_desc ,
     ROUND(s.avg_fragmentation_in_percent, 2) avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(DB_NAME()), NULL, NULL, NULL, NULL) s
     JOIN sys.objects o ON o.object_id = s.object_id
	 join sys.indexes i on s.object_id = i.object_id and s.index_id=i.index_id
WHERE avg_fragmentation_in_percent > 30 and index_type_desc!='HEAP'
ORDER BY avg_fragmentation_in_percent DESC;



select count(1) from RECEIPT;
select * from sys.dm_db_index_physical_stats(DB_ID(DB_NAME()), NULL, NULL, NULL, NULL);
select * from sys.indexes where object_id in(562101043);

-- heap or clustered
SELECT object_schema_name(sys.tables.object_id)+'.'+object_name(sys.tables.object_id) tab_name,
CASE WHEN sys.indexes.OBJECT_ID IS null THEN 'Clustered' ELSE 'Heap' end heap_or_cluster
 FROM sys.tables
LEFT OUTER JOIN 
 sys.indexes
ON sys.indexes.object_ID=sys.tables.OBJECT_ID
and sys.indexes.type=0
where  object_schema_name(sys.tables.object_id) <>'sys'


select * from sys.dm_db_index_physical_stats(DB_ID(DB_NAME()), NULL, NULL, NULL, NULL);

select * from sys.objects where object_id in(946102411,
949578421);

select * from DropidDetail;
select * from TaskManagerReason;





select  princ.name
,       princ.type_desc
,       perm.permission_name
,       perm.state_desc
,       perm.class_desc
,       object_name(perm.major_id)
from    sys.database_principals princ
left join
        sys.database_permissions perm
on      perm.grantee_principal_id = princ.principal_id
where princ.name!='public';

select * from sys.database_permissions;

select * from msdb.dbo.sysjobs;

select * from msdb.dbo.sysjobs;



select * from sys.database_permissions;


-- login info
SELECT l.name, l.denylogin, l.isntname, l.isntgroup, l.isntuser, l.sysadmin, l.securityadmin
FROM master.dbo.syslogins l
WHERE l.sysadmin = 1 OR l.securityadmin = 1;

SELECT l.name, l.denylogin, l.isntname, l.isntgroup, l.isntuser, l.sysadmin, l.securityadmin
FROM master.dbo.syslogins l, sys.sql_logins sl
WHERE (l.sysadmin = 1 OR l.securityadmin = 1) and l.isntuser=0 and l.isntgroup=0
and l.sid=sl.sid and sl.is_disabled=0
order by l.sysadmin, l.name;

select * from sys.server_principals;
select * from sys.sql_logins;
select * from sys.database_principals;

use schwms_molexctu;
go
select * from sys.database_principals;

select * from sys.database_role_members;

select * from master.dbo.sysusers;


select * from master.dbo.syslogins l;

select * from schwms_molexctu.dbo.sysusers;
select * from schwms_molexinv.dbo.sysusers;


select db_name();

SELECT pr.principal_id, pr.name, pr.type_desc,   
    pr.authentication_type_desc, pe.state_desc, pe.permission_name  
FROM sys.database_principals AS pr  
JOIN sys.database_permissions AS pe  
    ON pe.grantee_principal_id = pr.principal_id
	order by principal_id;  

--use schwms_molexctu;
use schwms_molexinv;
go
select * from sys.database_permissions;
select * from sys.objects;

--------------------------------------------------------------------
-- user and role permissions: begin
--------------------------------------------------------------------
use schwms_molexctu;
--use schwms_molexinv;
go

select u.name user_name, u.principal_id user_id,
       schema_name(o.schema_id) schema_name, o.name object_name, /*o.object_id,*/ o.type_desc object_type,
       p.permission_name, p.state_desc
  from sys.database_permissions p join 
       sys.objects o on p.major_id=o.object_id join 
	   sys.database_principals u on p.grantee_principal_id=u.principal_id
 order by user_name, object_type, object_name;
--------------------------------------------------------------------
-- user and role permissions: end
--------------------------------------------------------------------

-- login, role, user dmv
select * from sys.database_principals;
select * from sys.database_role_members;
select * from sys.server_principals;
select * from sys.sql_logins;

--------------------------------------------------------------------
-- user and role mapping: begin
--------------------------------------------------------------------
use schwms_molexctu;
--use schwms_molexinv;
go

select u.name user_name, u.principal_id user_id, u.type_desc user_type,
       r.name role_name, r.principal_id role_id, r.type_desc role_type
  from sys.database_principals u,
       sys.database_principals r,
	   sys.database_role_members ur
 where u.principal_id=ur.member_principal_id
   and r.principal_id=ur.role_principal_id
 order by user_id;
--------------------------------------------------------------------
-- user and role mapping: begin
--------------------------------------------------------------------

--------------------------------------------------------------------
-- login and user mapping: begin
--------------------------------------------------------------------
use schwms_molexctu;
--use schwms_molexinv;
go

with u as(select * from sys.database_principals where type='S' and principal_id>4)
select l.name login_name, l.principal_id login_id, l.type_desc login_type,
       u.name user_name, u.principal_id user_id, u.type_desc user_type
  from sys.sql_logins l right join u
    on l.sid=u.sid;
--------------------------------------------------------------------
-- login and user mapping: end
--------------------------------------------------------------------

select * from schwms_molexctu.sys.database_principals

--use master
--go
--exec sp_msloginmappings 'sqlsa', 0;

--use master
--go
--exec sp_msloginmappings 'sa', 1;


-- view stored procedure source
use schwms_molexctu;
--use schwms_molexinv;
SELECT *  FROM sys.sql_modules where lower(definition) like '%execute as%';

USE schwms_molexctu;  
GO  
EXEC sp_helptext N'[dbo].[BAX_kwc_EdtNumeric]';  
SELECT OBJECT_DEFINITION (OBJECT_ID(N'[dbo].[BAX_kwc_EdtNumeric]'));  


select count(1) from sys.sql_logins;
select count(1) from sys.databases;

591 login
129 database



--snapshot_isolation_state, set by the ALLOW_SNAPSHOT_ISOLATION
--0 = Snapshot isolation state is OFF (default). Snapshot isolation is disallowed.
--1 = Snapshot isolation state ON. Snapshot isolation is allowed.
--2 = Snapshot isolation state is in transition to OFF state. All transactions have their modifications versioned. Cannot start new transactions using snapshot isolation. The database remains in the transition to OFF state until all transactions that were active when ALTER DATABASE was run can be completed.
--3 = Snapshot isolation state is in transition to ON state. New transactions have their modifications versioned. Transactions cannot use snapshot isolation until the snapshot isolation state becomes 1 (ON). The database remains in the transition to ON state until all update transactions that were active when ALTER DATABASE was run can be completed.

select name, database_id, snapshot_isolation_state, snapshot_isolation_state_desc, is_read_committed_snapshot_on from sys.databases;


select u.name                   user_name,
       u.principal_id           user_id,
       schema_name(o.schema_id) schema_name,
       o.name                   object_name, /*o.object_id,*/
       o.type_desc              object_type,
       p.permission_name,
       p.state_desc
from sys.database_permissions p
         left join
     sys.objects o on p.major_id = o.object_id
         join
     sys.database_principals u on p.grantee_principal_id = u.principal_id
order by user_name, object_type, object_name;

select * from sys.database_permissions;




SELECT 
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame
;


select * from sys.sysprocesses;

exec sp_who





select * from sys.sql_logins where master.dbo.fn_varbintohexstr(sid)='0x0C7E0D23C532E04B981C1067BC0C852F';




