
## User

### Windows authenticated user

	USE [master]
	GO
	
	/****** Object:  Login [APLACSVR1KR\CISADMIN]    Script Date: 11/28/2019 12:16:59 PM ******/
	CREATE LOGIN [APLACSVR1KR\AppleKRadmin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
	GO
	
	ALTER SERVER ROLE [sysadmin] ADD MEMBER [APLACSVR1KR\AppleKRadmin]
	GO
	
### Activated users
	
	select * from sys.sysprocesses;
	
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
	
	
	
	sp_who
	sp_who2

### Permission

	alter login dbalogin with default_database = tempdb;
	alter login sa with check_policy=off;
	alter login sa with check_expiration=off;
	
	
	USE AdventureWorks 
	GO 
	GRANT VIEW Definition TO PUBLIC;
	
	USE master 
	GO 
	GRANT VIEW ANY DEFINITION TO User1;
	
	
	alter database test set online;


## Replication

	select distinct article from distribution.dbo.MSarticles;
	
	select * from distribution.dbo.MSpublications;
	select * from distribution.dbo.MSsubscriptions;
	select * from distribution.dbo.MSarticles order by article;
	select article from distribution.dbo.MSarticles where publication_id=xx order by article;
	
	select * from sys.tables where name not like 'MS%' order by name;

	use Applecare_Prod
	exec sp_droppublication @publication= 'Applecare_Prod_Repl';
	exec sp_subscription_cleanup @publication= 'Applecare_Prod_Repl';
	
	
	USE Applecare_Prod
	
	EXEC sp_removedbreplication @dbname=Applecare_Prod
	
	GO

## Auto start stored procedure

	select *
	from sys.procedures
	where is_auto_executed = 1;
	
	
	USE MASTER
	GO
	SELECT VALUE, VALUE_IN_USE, DESCRIPTION
	FROM SYS.CONFIGURATIONS
	WHERE NAME = 'scan for startup procs'
	
	
	
	sp_procoption
	
	
	select *
	from sys.procedures
	where is_auto_executed = 1;
	
	
	SELECT *
	FROM MASTER.INFORMATION_SCHEMA.ROUTINES
	WHERE OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME),'ExecIsStartup') = 1


## Jobs

### Show jobs

	USE msdb ;  
	GO  
	  
	EXEC dbo.sp_help_job ;  
	GO

## Misc



#
	Accelerated Database Recovery (ADR)
	
	ALTER DATABASE MyDatabase  
	SET ALLOW_SNAPSHOT_ISOLATION ON  
	  
	ALTER DATABASE MyDatabase  
	SET READ_COMMITTED_SNAPSHOT ON  
	
	
	
	4
	-- Let's dump out a specific Data Page.
	-- The record size is currently 2011 bytes (7 + 4 + 1000 + 1000).
	DBCC PAGE(RCSI_SideEffects, 1, 224, 1)
	GO

#
	net stop "SQL Server (MSSQLSERVER)"
	net stop "SQL Server Agent (MSSQLSERVER)"
	net stop "SQL Server Analysis Service (MSSQLSERVER)"
	
	net start "SQL Server (MSSQLSERVER)"
	net start "SQL Server Agent (MSSQLSERVER)"
	
	
	sc config "SQL Server (MSSQLSERVER)" start= DEMAND
	
	
	SC STOP "<nameservice>"
	
	SC CONFIG "<nameservice>" START= ( BOOT, or SYSTEM, or AUTO, or DEMAND, or DISABLED, or DELAYED-AUTO )
	
	
	
	1. DROP DATABASE Practice
	
	2. RESTORE DATABASE Practice FROM DISK = 'D:/Practice.BAK' WITH NORECOVERY
	
	3. RESTORE DATABASE Practice FROM DISK = 'D:/Practice1.TRN' WITH NORECOVERY
	
	4. RESTORE DATABASE Practice FROM DISK = 'D:/Practice2.TRN' WITH NORECOVERY
	
	5. RESTORE DATABASE Practice WITH RECOVERY
	
	
	sc config "SQL Server Agent (MSSQLSERVER)" start= DEMAND


#

	select * from tb_test1;
	
	insert into tb_test1 values(1, 1, 1);
	go 1000
	
	insert into tb_test1 values(2, 2, 2);
	go 1000
	
	insert into tb_test1 values(3, 3, 3);
	go 1000
	
	
	select backup_set_id, backup_set_uuid, name, first_lsn, last_lsn, checkpoint_lsn, database_backup_lsn,
	       database_name, differential_base_lsn, differential_base_guid
	  from msdb.dbo.backupset;
	
	select * from msdb.INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME like '%lsn%';
	
	select * from sys.database_files;

#

	--run_status
	--0 = Failed
	--1 = Succeeded
	--2 = Retry
	--3 = Canceled
	--4 = In Progress
	select job.job_id, job.name, jobh.step_name, jobh.run_status, jobh.message,
	       jobh.run_date, jobh.run_time, jobh.run_duration
	  from msdb.dbo.sysjobhistory jobh, 
	       msdb.dbo.sysjobs job
	 where jobh.job_id=job.job_id
	   and jobh.run_status!=1
	 order by run_date desc, run_time desc;
	
	select name, physical_name, cast(size*8/1024/1024.0 as numeric(36, 2)) "Size(G)",
	cast((sum(size) over())*8/1024/1024.0 as numeric(36, 2)) "DB Size(G)" from sys.database_files;


#


	ALTER DATABASE Applecare_Prod
	SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;
	
	GO
	
	use master;
	restore database Applecare_Prod with recovery;
	
	
	ALTER DATABASE Applecare_Prod
	SET multi_USER
	WITH ROLLBACK IMMEDIATE;
	
	GO
	
	DROP DATABASE Applecare_Prod;


#

Query running sql

	SELECT sqltext.TEXT,
	req.session_id,
	req.status,
	req.command,
	req.cpu_time,
	req.total_elapsed_time
	FROM sys.dm_exec_requests req
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext

#
Memory usage

	SELECT  
	(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,  
	(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
	(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,  
	process_physical_memory_low,  
	process_virtual_memory_low  
	FROM sys.dm_os_process_memory; 