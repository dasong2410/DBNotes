-- Clean
Use master
go

DROP PROCEDURE IF EXISTS [dbo].[dba_CreateLogshippingDirs];
DROP PROCEDURE IF EXISTS [dbo].[dba_CreateDBInitBackups];
DROP PROCEDURE IF EXISTS [dbo].[dba_DeployLogshippingSub];
DROP PROCEDURE IF EXISTS [dbo].[dba_DeployLogshipping];
DROP PROCEDURE IF EXISTS [dbo].[dba_LogshippingClean];

DROP PROCEDURE IF EXISTS [dbo].[dba_RestoreLogshippingDBs];

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
    , @PrimaryServer = '10.213.20.18'
    , @PrimaryServerPort = '1433'
    , @SecondaryServer = '10.213.20.38'
    , @SecondaryServerPort = '1436'

exec dba_LogshippingClean
     @SecondaryServer = '10.213.20.38'
    , @SecondaryServerPort= '1436'

-- Secondary
exec dba_RestoreLogshippingDBs
     @PrimaryServer = '10.213.20.18'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @DatafileLocation = 'd:\database'
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\LogShipping'
    , @PrimaryServer = '10.213.20.18'
    , @LogshippingSrcSharedDir = 'Logshipping'
exec dba_DeployLogshipping
     @PrimaryServer = '10.213.20.18'
    , @PrimaryServerPort = '1433'
    , @SecondaryServer = '10.213.20.38'
    , @SecondaryServerPort = '1436'
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
    , @PrimaryServer = '10.213.20.18'
    , @PrimaryServerPort = '1433'
    , @SecondaryServer = '10.213.20.38'
    , @SecondaryServerPort = '1436'
    , @Database = 'test10'

exec dba_LogshippingClean
     @SecondaryServer = '10.213.20.38'
    , @Database = 'test10'

-- Secondary
exec dba_RestoreLogshippingDBs
     @PrimaryServer = '10.213.20.18'
    , @LogshippingSharedDir = 'Logshipping'
    , @DatafileLocation = 'd:\database'
    , @Database = 'test10'
exec dba_CreateLogshippingDirs
     @LogshippingRootDir = 'C:\Logshipping'
    , @PrimaryServer = '10.213.20.18'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @Database = 'test10'
exec dba_DeployLogshipping
     @PrimaryServer = '10.213.20.18'
    , @PrimaryServerPort = '1433'
    , @SecondaryServer = '10.213.20.38'
    , @SecondaryServerPort = '1436'
    , @LogshippingSrcSharedDir = 'Logshipping'
    , @LogshippingDestSharedDir = 'Logshipping'
    , @Database = 'test10'

exec dba_LogshippingClean
     @Database = 'test10'
