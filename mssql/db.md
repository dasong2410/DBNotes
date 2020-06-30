## Database Info

### sql server info

```sql
select serverproperty('MachineName')                           as host,
       coalesce(serverproperty('InstanceName'), 'MSSQLSERVER') as instance,
       --serverproperty('ProductVersion') AS ProductVersion,
       --serverproperty('InstanceDefaultLogPath') LogPath,
       @@version                                               as version_number,
       serverproperty('ProductLevel')                          as product_level, /* RTM or SP1 etc*/
       serverproperty('Edition')                               as edition,
       serverproperty('InstanceDefaultDataPath')                  data_path,
       case serverproperty('IsIntegratedSecurityOnly')
           when 1 then 'Windows Authentication'
           when 0 then 'Windows and SQL Server Authentication'
           end                                                 as authentication_mode;
```

### db info

```sql
with a as (select name, database_id, recovery_model_desc, collation_name
           from sys.databases),
     b as (select database_id, name, physical_name, sum(size) over (partition by database_id) db_size
           from sys.master_files)
select a.name                                db_name,
       a.recovery_model_desc,
       collation_name,
       cast(b.db_size * 8 / 1024 / 1024.0 as numeric(36, 2)) [db_size(G)],
       b.name                                file_name,
       b.physical_name
from a,
     b
where a.database_id = b.database_id;
```

### file size

```sql
select db_name(database_id) DatabaseName,
       name FileName,
       type_desc Type,
       cast(size*8/1024/1024.0 as numeric(36, 2)) "Size(G)",
       cast((sum(size) over(partition by database_id))*8/1024/1024.0 as numeric(36, 2)) "DB Size(G)",
       physical_name PhysicalName
  from sys.master_files;
```

### ADR

```sql
Accelerated Database Recovery (ADR)

ALTER DATABASE MyDatabase  
SET ALLOW_SNAPSHOT_ISOLATION ON  

ALTER DATABASE MyDatabase  
SET READ_COMMITTED_SNAPSHOT ON  
````

### Restore databases

```sql
1. DROP DATABASE Practice

2. RESTORE DATABASE Practice FROM DISK = 'D:/Practice.BAK' WITH NORECOVERY

3. RESTORE DATABASE Practice FROM DISK = 'D:/Practice1.TRN' WITH NORECOVERY

4. RESTORE DATABASE Practice FROM DISK = 'D:/Practice2.TRN' WITH NORECOVERY

5. RESTORE DATABASE Practice WITH RECOVERY
```

### Database mode

```sql
ALTER DATABASE MyDatabase
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

GO

ALTER DATABASE MyDatabase
SET multi_USER
WITH ROLLBACK IMMEDIATE;

GO
```

### Cycle error log

```sql
USE master
GO

EXEC sp_cycle_errorlog ;  
GO  
```

```sql
USE msdb ;  
GO  
  
EXEC dbo.sp_cycle_agent_errorlog ;  
GO  
```
