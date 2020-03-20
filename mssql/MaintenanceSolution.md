# MaintenanceSolution

### Backup

	EXECUTE [dbo].[DatabaseBackup]
	@Databases = 'USER_DATABASES',
	@Directory = 'D:\MSSQL_BACKUP',
	@BackupType = 'FULL',
	@Verify = 'Y',
    @Compress = 'Y',
	@CleanupTime = 72,
	@CheckSum = 'Y',
	@LogToTable = 'Y'

	EXECUTE [dbo].[DatabaseBackup]
	@Databases = 'USER_DATABASES',
	@Directory = 'D:\MSSQL_BACKUP',
	@BackupType = 'LOG',
	@Verify = 'Y',
    @Compress = 'Y',
	@CleanupTime = 72,
	@CheckSum = 'Y',
	@LogToTable = 'Y'

### Index

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
