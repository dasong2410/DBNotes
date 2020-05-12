





-- feature installed
-- SQL Server Installation Center/Tools/Installed SQL Server features discovery report



-----------------------------------------------------------------------------
-- Database Information: end
-----------------------------------------------------------------------------

select name, database_id, recovery_model_desc from sys.databases;
select * from sys.database_files;





--EXEC master.dbo.sp_MSforeachdb @command1 = 'select name, physical_name, size from sys.database_files';



select * from msdb.dbo.backupset;



-- last backup time
select *
from (
         select name,
                create_date,
                collation_name,
                state_desc,
                recovery_model_desc,
                log_reuse_wait_desc,
                LastFullBackUpTime=(SELECT MAX(bs.backup_finish_date)
                                    FROM msdb.dbo.backupset bs
                                    WHERE bs.[database_name] = d.[name]
                                      AND bs.[type] = 'D'),
                LastDiffBackUpTime=(SELECT MAX(bs.backup_finish_date)
                                    FROM msdb.dbo.backupset bs
                                    WHERE bs.[database_name] = d.[name]
                                      AND bs.[type] = 'I'),
                LastLogBackUpTime=(SELECT MAX(bs.backup_finish_date)
                                   FROM msdb.dbo.backupset bs
                                   WHERE bs.[database_name] = d.[name]
                                     AND bs.[type] = 'L')
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


select * from sys.database_permissions;


-- schwms_molexctu, schwms_molexinv
use schwms_molexctu;
go
SELECT l.name, l.denylogin, l.isntname, l.isntgroup, l.isntuser, l.sysadmin, l.securityadmin
FROM master.dbo.syslogins l
WHERE l.sysadmin = 1 OR l.securityadmin = 1;

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
