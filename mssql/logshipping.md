# Log Shipping

## 1. Shared directory structure

	D:\Logshipping\[database_name]

## 2. LSN check

```sql
-- primary server
--select d.name database_name, f.backup_lsn, f.*
--  from sys.master_files f, sys.databases d
-- where f.database_id=d.database_id
--   and f.type_desc='ROWS'
--   and f.backup_lsn is not null
-- order by database_name;
select database_name, backup_lsn from (select d.name database_name, f.backup_lsn, f.type_desc, ROW_NUMBER() over(partition by d.name order by backup_lsn desc) rn
  from sys.master_files f, sys.databases d
 where f.database_id=d.database_id
   and f.backup_lsn is not null) x
   where x.rn=1
 order by database_name;

-- secondary server
select d.name database_name, f.redo_start_lsn, f.*
  from sys.master_files f, sys.databases d
 where f.database_id=d.database_id
   and f.type_desc='ROWS'
   and f.redo_start_lsn is not null
 order by database_name;

-- restore lsn info from transaction log
RESTORE HEADERONLY FROM DISK = N'D:\LogShipping\Applecare_Arc\Applecare_Arc_20191203014000.trn';
```

## 3. Check recovery mode

```sql
SELECT secondary_database,
		restore_mode,
		disconnect_users,
		last_restored_file
   FROM msdb.dbo.log_shipping_secondary_databases;
```

## 4. Switch recovery mode

### 4.1 To norecovery mode

```sql
EXEC sp_change_log_shipping_secondary_database
	@secondary_database = 'TSecure',
	@restore_mode = 0,
	@disconnect_users = 0;
```

### 4.2 To standby/readonly mode

```sql
EXEC sp_change_log_shipping_secondary_database
	@secondary_database = 'Applecare_Prod',
	@restore_mode = 1,
	@disconnect_users = 1;
```

## 5. Check status

```sql
-- primary database
select * from msdb.dbo.log_shipping_primary_databases;
select * from msdb.dbo.log_shipping_primary_secondaries;
select * from msdb.dbo.log_shipping_monitor_primary;

-- secondary database
select * from msdb.dbo.log_shipping_secondary;
select * from msdb.dbo.log_shipping_monitor_secondary;
select secondary_database, last_copied_date, last_copied_file, last_restored_date, last_restored_file from msdb.dbo.log_shipping_monitor_secondary order by secondary_database;
select * from msdb.dbo.log_shipping_monitor_alert;
select * from msdb.dbo.log_shipping_monitor_error_detail order by log_time desc;
```

## 6. Switch over

```sql
-- on primary server
-- generate sql to run logshipping backup jobs
select 'exec msdb..sp_start_job @job_name=''' + name + ''';' from msdb..sysjobs where name like 'LSBackup_%';

-- on secondary server
-- generate sql to run logshipping copy jobs
select 'exec msdb..sp_start_job @job_name=''' + name + ''';' from msdb..sysjobs where name like 'LSCopy_%';

-- on secondary server
-- generate sql to run logshipping restore jobs
select 'exec msdb..sp_start_job @job_name=''' + name + ''';' from msdb..sysjobs where name like 'LSRestore_%';

-- on secondary server
-- generate sql to convert logshipping databases to read-write
-- select 'RESTORE LOG ' + name + ' WITH RECOVERY;' from sys.databases where database_id>4 and (state_desc='RESTORING' or is_in_standby=1);
select 'RESTORE LOG ' + secondary_database + ' WITH RECOVERY;' from msdb.dbo.log_shipping_monitor_secondary;
```

## 7. Trouble shooting

SQL Server Agent Job waiting for a worker thread

https://blog.sqlterritory.com/2018/09/25/sql-server-agent-job-waiting-for-a-worker-thread/

```sql
select * from msdb.dbo.syssubsystems
 where subsystem_id = 3;

UPDATE msdb.dbo.syssubsystems
SET max_worker_threads = 120
WHERE subsystem_id = 3;

UPDATE msdb.dbo.syssubsystems
SET max_worker_threads = 120
WHERE subsystem = N'CmdExec';
```
