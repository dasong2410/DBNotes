## MaintenanceSolution

https://ola.hallengren.com/

### 1. Install MaintenanceSolution.sql

- Run MaintenanceSolution.sql, it will not create jobs

### 2. Create jobs

- Run Jobs\Dest\A-WithLog.sql or Jobs\Dest\A-WithoutLog.sql to create jobs. 
- Full backup will be created every day 2:00AM. Trans log will be backed up per hour. 
- All backup files will be stored in E:\MSSQL_BACKUP

### 3. MaintenanceSolution examples

Full

```sql
EXECUTE [dbo].[DatabaseBackup]
@Databases = 'USER_DATABASES',
@Directory = 'D:\MSSQL_BACKUP',
@BackupType = 'FULL',
@Verify = 'Y',
@Compress = 'Y',
@CleanupTime = 72,
@CheckSum = 'Y',
@LogToTable = 'Y'
```

Log

```sql
EXECUTE [dbo].[DatabaseBackup]
@Databases = 'USER_DATABASES',
@Directory = 'D:\MSSQL_BACKUP',
@BackupType = 'LOG',
@Verify = 'Y',
@Compress = 'Y',
@CleanupTime = 72,
@CheckSum = 'Y',
@LogToTable = 'Y'
```

Index

```sql
EXECUTE dbo.IndexOptimize
@Databases = 'USER_DATABASES',
@FragmentationLow = NULL,
@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 = 5,
@FragmentationLevel2 = 30,
@UpdateStatistics = 'ALL',
@OnlyModifiedStatistics = 'Y',
@LogToTable = 'Y'
```
