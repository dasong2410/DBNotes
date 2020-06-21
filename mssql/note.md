<a name="Table-of-Contents"></a>
# Table of Contents

- [Job](#Job)
- [Log](#Log)
- [Misc](#Misc)

<a name="Job"></a>
## [Job](#Table-of-Contents)

### Show jobs

```sql
USE msdb ;  
GO  

EXEC dbo.sp_help_job ;  
GO

EXEC dbo.sp_help_jobactivity;
GO
```

### Job step

```sql
select database_name, job.job_id, name, enabled, description, step_name, command, server
    from msdb.dbo.sysjobs job inner join
        msdb.dbo.sysjobsteps steps
    on job.job_id = steps.job_id;
```

### Job history

```sql
select a.job_id, a.name, a.enabled, b.run_status, b.step_id, step_name, run_duration, run_date, run_time
    from (select job_id, name, enabled from msdb.dbo.sysjobs) a join
        (select instance_id, job_id, step_id, step_name, message, run_status, run_duration, run_date, run_time
            from msdb.dbo.sysjobhistory
            where run_duration>10) b
    on a.job_id=b.job_id
    order by run_date desc;

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
```

<a name="Log"></a>
## [Log](#Table-of-Contents)

### Shrink log

```sql
-- shrink log
select db_name(database_id) database_name, name file_name, physical_name,
        cast(size*8/1024/1024.0 as numeric(36, 2)) "Size(G)",
        cast((sum(size) over())*8/1024/1024.0 as numeric(36, 2)) "DB Size(G)"
    from sys.master_files;

DBCC SQLPERF(LOGSPACE);  
GO

-- log files
select DB_NAME(database_id) database_name, name, physical_name, size*8/1024/1024.0 "Size(G)"
    from sys.master_files
    where type_desc='LOG';

-- shrink logs
-- choose "results to text"
select 'use [' + DB_NAME(database_id)+']' + char(10) +
        'go' + char(10) +
        'DBCC SHRINKFILE ([' + name + '], TRUNCATEONLY);' + char(10) +
        'go'
    from sys.master_files
    where type_desc='LOG';
```

### Query log

```sql
-- listening port
EXEC xp_ReadErrorLog 0, 1, N'Server is listening on', N'any', NULL, NULL, 'DESC'
GO

-- error logs
EXEC sp_readerrorlog 0, 1;
EXEC sp_readerrorlog 0, 2;
```

<a name="Misc"></a>
## [Misc](#Table-of-Contents)

### Deadlock trace

```sql
DBCC TRACEON(1222,-1)

DBCC TRACESTATUS(-1)
GO
```

### Server Memory

```sql
select *
from sys.configurations
where name like '% server memory%';
```

#

```sql
4
-- Let's dump out a specific Data Page.
-- The record size is currently 2011 bytes (7 + 4 + 1000 + 1000).
DBCC PAGE(RCSI_SideEffects, 1, 224, 1)
GO
```

#
```sql
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
```

#

Currently running sql

```sql
SELECT sqltext.TEXT,
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
```

#

Memory usage

```sql
SELECT  
(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,  
(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,  
process_physical_memory_low,  
process_virtual_memory_low  
FROM sys.dm_os_process_memory;
```

```sql
SELECT (CASE 
           WHEN ( [database_id] = 32767 ) THEN 'Resource Database' 
           ELSE Db_name (database_id) 
         END )  AS 'Database Name', 
       Sum(CASE 
             WHEN ( [is_modified] = 1 ) THEN 0 
             ELSE 1 
           END) AS 'Clean Page Count',
		Sum(CASE 
             WHEN ( [is_modified] = 1 ) THEN 1 
             ELSE 0 
           END) AS 'Dirty Page Count'
FROM   sys.dm_os_buffer_descriptors 
GROUP  BY database_id 
ORDER  BY DB_NAME(database_id);
```
