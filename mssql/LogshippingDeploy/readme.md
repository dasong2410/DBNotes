# **Logshipping Deploy**

- [Deploy](#Deploy)
  - [Primary Server](#Primary-Server)
  - [Secondary Server](#Secondary-Server)
- [Clean all setups](#Clean-all-setups)
- [Examples](#Examples)
  - [Multiple databases](#Multiple-databases)
  - [Single databases](#Single-database)

#

- All the effort is made to make logshipping setup friend for multiple databases, like 40 databases
- All database objects created in master database

## [**Deploy**](#Logshipping-Deploy)

### [**Primary Server**](#Logshipping-Deploy)

#### 1. Create logshipping root dir and make it shared

    D:\Logshipping

#### 2. Configure logshipping metadata table and create procedures

Run following sql scripts

    Dest\P-All.sql

#### 3. Create dirs for logshipping

```sql
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
```

#### 4. Backup databases

```sql
exec dba_CreateDBInitBackups
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
```

#### 5. Configure databases

```sql
exec dba_DeployLogshipping
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
    , @PrimaryServer = 'PrimaryServer'          -- ip,port
    , @SecondaryServers = 'SecondaryServer'     -- ip,port;ip,port;ip,port
```

#### 6. Clean logshipping setups, if it needed

```sql
exec dba_LogshippingClean
     @SecondaryServers = 'SecondaryServer'      -- ip,port;ip,port;ip,port
```

### [**Secondary Server**](#Logshipping-Deploy)

#### 1. Create logshipping root dir and make it shared

    D:\Logshipping

#### 2. Create procedures

Run following sql scripts

    Dest\P-All.sql

#### 3. Restore databases

```sql
exec dba_RestoreLogshippingDBs
     @PrimaryServer = 'PrimaryServer'            -- ip
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @DatafileLocation = 'DatafileLocation'     -- D:\Database
```

#### 4. Create dirs for logshipping

```sql
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'LogshippingRootDir'  -- D:\Logshipping
    , @PrimaryServer = 'PrimaryServer'           -- ip
    , @LogshippingSrcSharedDir = 'Logshipping'
```

#### 5. Configure databases

```sql
exec dba_DeployLogshippingSecondary
     @PrimaryServer = 'PrimaryServer'            -- ip,port
    , @SecondaryServer = 'SecondaryServer'       -- ip,port
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'
```

#### 6. Clean logshipping setups, if it needed

```sql
exec dba_LogshippingClean
```

## [**Clean all setups**](#Logshipping-Deploy)

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

## [**Examples**](#Logshipping-Deploy)

### [**Multiple databases**](#Logshipping-Deploy)

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

### [**Single database**](#Logshipping-Deploy)

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
