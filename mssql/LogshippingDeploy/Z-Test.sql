-- Clean
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


-- Multi databases
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
    , @DatafileLocation = 'D:\Database'
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

-- Single database
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
    , @DatafileLocation = 'D:\Database'
    , @Database = 'test10'
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = 'xx.xx.xx.xx'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @Database = 'test10'
exec dba_DeployLogshipping
     @PrimaryServer = 'xx.xx.xx.xx,1433'
    , @SecondaryServer = 'xx.xx.xx.xx,1436'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'
    , @Database = 'test10'

exec dba_LogshippingClean
     @Database = 'test10'
