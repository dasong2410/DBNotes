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
    , @Database = 'db_name'                     -- default '%'
```

#### 4. Backup databases

```sql
exec dba_CreateDBInitBackups
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
    , @Database = 'db_name'                     -- default '%'
```

#### 5. Configure databases

```sql
exec dba_DeployLogshipping
     @LogshippingRootDir = 'LogshippingRootDir' -- D:\Logshipping
    , @PrimaryServer = 'PrimaryServer'          -- ip,port
    , @SecondaryServers = 'SecondaryServer'     -- ip,port;ip,port;ip,port
    , @LogshippingSharedDir = 'Logshipping'     -- shared folder for logshipping
    , @Interval = interval                      -- default 5
```

#### 6. Clean logshipping setups, if it needed

```sql
exec dba_LogshippingClean
     @SecondaryServers = 'SecondaryServer'      -- ip,port;ip,port;ip,port
    , @Database = 'db_name'                     -- default '%'
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
    , @LogshippingSrcSharedDir = 'Logshipping'   -- shared folder for logshipping
    , @DatafileLocation = 'DatafileLocation'     -- D:\Database
    , @Database = 'db_name'                      -- default '%'
```

#### 4. Create dirs for logshipping

```sql
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'LogshippingRootDir'  -- D:\Logshipping
    , @PrimaryServer = 'PrimaryServer'           -- ip
    , @LogshippingSrcSharedDir = 'Logshipping'   -- shared folder for logshipping
    , @Database = 'db_name'                      -- default '%'
```

#### 5. Configure databases

```sql
exec dba_DeployLogshippingSecondary
     @PrimaryServer = 'PrimaryServer'            -- ip,port
    , @SecondaryServer = 'SecondaryServer'       -- ip,port
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'
    , @Database = 'db_name'                      -- default '%'
    , @Interval = interval                       -- default 5
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
    , @PrimaryServer = 'xx.xx.xx.xx,1433'
    , @SecondaryServers = 'xx.xx.xx.xx,1433'
    , @LogshippingSharedDir = 'Logshipping'

exec dba_LogshippingClean
     @SecondaryServers = 'xx.xx.xx.xx,1433'

-- Secondary
exec dba_RestoreLogshippingDBs
     @PrimaryServer = 'xx.xx.xx.xx'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @DatafileLocation = 'd:\database'
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = 'xx.xx.xx.xx'
    , @LogshippingSrcSharedDir = 'Logshipping'
exec dba_DeployLogshipping
     @PrimaryServer = 'xx.xx.xx.xx,1433'
    , @SecondaryServer = 'xx.xx.xx.xx,1433'
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
    , @PrimaryServer = 'xx.xx.xx.xx,1433'
    , @SecondaryServers = 'xx.xx.xx.xx,1433'
    , @Database = 'test10'

exec dba_LogshippingClean
     @SecondaryServers = 'xx.xx.xx.xx,1433'
    , @Database = 'test10'

-- Secondary
exec dba_RestoreLogshippingDBs
     @PrimaryServer = 'xx.xx.xx.xx'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @DatafileLocation = 'd:\database'
    , @Database = 'test10'
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = 'xx.xx.xx.xx'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @Database = 'test10'
exec dba_DeployLogshipping
     @PrimaryServer = 'xx.xx.xx.xx,1433'
    , @SecondaryServer = 'xx.xx.xx.xx,1433'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'
    , @Database = 'test10'

exec dba_LogshippingClean
     @Database = 'test10'
```
