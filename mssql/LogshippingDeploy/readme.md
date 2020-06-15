
# **Logshipping Deploy**

<a name="Table-of-Contents"></a>
## Table of Contents

- [Primary Server](#Primary-Server)
- [Secondary Server](#Secondary-Server)
- [Clean all setups](#Clean-all-setups)
  - [Multiple databases](#Multiple-databases)
  - [Single databases](#Single-database)
- [Examples](#Examples)

#

- All database objects created in master database

<a name="Primary Server"></a>
## [**Primary Server**](#Table-of-Contents)

### 1. Create logshipping root dir and make it shared on Primary Server

    D:\Logshipping

### 2. Config logshipping metadata table and create procedures

Run following sql scripts

    Both-DBAUtl.sql
    P-01-Config.sql
    P-02-CreateLogshippingDirs.sql
    P-03-CreateDBInitBackup.sql
    P-04-DeployLogshipping.sql
    P-99-LogshippingClean.sql

### 3. Create dirs for logshipping

```sql
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
```

### 4. Backup databases

```sql
exec dba_CreateDBInitBackups
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
```

### 5. Config databases

```sql
exec dba_DeployLogshipping
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
    , @PrimaryServer = 'PrimaryServer' -- ip,port
    , @SecondaryServers = 'SecondaryServer' --ip,port;ip,port;ip,port
```

### 6. Clean logshipping setups, if you need it

```sql
exec dba_LogshippingClean
     @SecondaryServers = 'SecondaryServer' -- ip,port;ip,port;ip,port
```

<a name="Secondary Server"></a>
## [**Secondary Server**](#Table-of-Contents)

### 1. Create logshipping root dir and make it shared on Secondary Server

    D:\Logshipping

### 2. Create procedures

Run following sql scripts

    Both-DBAUtl.sql
    S-01-RestoreLogshippingDBs.sql
    S-02-CreateLogshippingDirs.sql
    S-03-DeployLogshipping.sql
    S-99-LogshippingClean.sql

### 2. Restore databases

```sql
exec dba_RestoreLogshippingDBs
     @PrimaryServer = 'PrimaryServer' -- ip
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @DatafileLocation = 'DatafileLocation' -- D:\Database
```

### 3. Create dirs for logshipping

```sql
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
    , @PrimaryServer = 'PrimaryServer' -- ip
    , @LogshippingSrcSharedDir = 'Logshipping'
```

### 4. Config databases

```sql
exec dba_DeployLogshippingSecondary
     @PrimaryServer = 'PrimaryServer' -- ip,port
    , @SecondaryServer = 'SecondaryServer' -- ip,port
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'
```

### 5. Clean logshipping setups, if you need it

```sql
exec dba_LogshippingClean
```

<a name="Clean all setups"></a>
## [**Clean all setups**](#Table-of-Contents)

```sql
Use master
go

DROP PROCEDURE IF EXISTS [dbo].[dba_CreateLogshippingDirs];
DROP PROCEDURE IF EXISTS [dbo].[dba_CreateDBInitBackups];
DROP PROCEDURE IF EXISTS [dbo].[dba_DeployLogshipping];
DROP PROCEDURE IF EXISTS [dbo].[dba_DeployLogshippingAddPrimary];
DROP PROCEDURE IF EXISTS [dbo].[dba_DeployLogshippingAddSecondary];
DROP PROCEDURE IF EXISTS [dbo].[dba_LogshippingClean];

DROP PROCEDURE IF EXISTS [dbo].[dba_RestoreLogshippingDBs];
DROP PROCEDURE IF EXISTS [dbo].[dba_DeployLogshippingSub];

DROP PROCEDURE IF EXISTS [dbo].[dba_DeleteBackupFile];
DROP PROCEDURE IF EXISTS [dbo].[dba_FileExist];
DROP PROCEDURE IF EXISTS [dbo].[dba_GetDefaultBackupDir];

drop table if exists logshipping_cfg;
```

<a name="Examples"></a>
## [**Examples**](#Table-of-Contents)

<a name="Multiple databases"></a>
### [**Multiple databases**](#Table-of-Contents)

```sql
-- Primary
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
exec dba_CreateDBInitBackups
     @LogshippingRootDir = 'C:\Logshipping'
exec dba_DeployLogshipping
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = '10.213.20.18,1433'
    , @SecondaryServers = '10.213.20.38,1436'

exec dba_LogshippingClean
     @SecondaryServers = '10.213.20.38,1436'

-- Secondary
exec dba_RestoreLogshippingDBs
     @PrimaryServer = '10.213.20.18'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @DatafileLocation = 'd:\database'
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = '10.213.20.18'
    , @LogshippingSrcSharedDir = 'Logshipping'
exec dba_DeployLogshipping
     @PrimaryServer = '10.213.20.18,1433'
    , @SecondaryServer = '10.213.20.38,1436'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'

exec dba_LogshippingClean
```


### [**Single database**](#Table-of-Contents)

```sql
-- Primary
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
    , @Database = 'test10'
exec dba_CreateDBInitBackups
     @LogshippingRootDir = 'C:\Logshipping'
    , @Database = 'test10'
exec dba_DeployLogshipping
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = '10.213.20.18,1433'
    , @SecondaryServers = '10.213.20.38,1436'
    , @Database = 'test10'

exec dba_LogshippingClean
     @SecondaryServers = '10.213.20.38,1436'
    , @Database = 'test10'

-- Secondary
exec dba_RestoreLogshippingDBs
     @PrimaryServer = '10.213.20.18'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @DatafileLocation = 'd:\database'
    , @Database = 'test10'
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = '10.213.20.18'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @Database = 'test10'
exec dba_DeployLogshipping
     @PrimaryServer = '10.213.20.18,1433'
    , @SecondaryServer = '10.213.20.38,1436'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'
    , @Database = 'test10'

exec dba_LogshippingClean
     @Database = 'test10'
```
