use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_FileExist] @FilePath varchar(128),
                                      @isFile int = 0,
                                      @isDirectory int =0,
                                      @Exist int output
AS
BEGIN
    DECLARE @DirectoryInfo TABLE
                           (
                               FileExists            bit,
                               FileIsADirectory      bit,
                               ParentDirectoryExists bit
                           )

    delete from @DirectoryInfo
    INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
        EXECUTE [master].dbo.xp_fileexist @FilePath

    SELECT @Exist = count(1)
    FROM @DirectoryInfo
    WHERE FileExists = @isFile
      AND FileIsADirectory = @isDirectory
      AND ParentDirectoryExists = 1

    print @Exist
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_GetDefaultBackupDir] @DefaultBackupDir varchar(128) output
AS
BEGIN
    DECLARE @BackupDir TABLE
                       (
                           name  varchar(64),
                           value varchar(1024)
                       )

    delete from @BackupDir
    INSERT INTO @BackupDir (name, value)
        EXEC master.dbo.xp_instance_regread
             N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory'

    select top 1 @DefaultBackupDir = value from @BackupDir
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_DeleteBackupFile] @LogshippingDBInitDir varchar(1024),
                                             @BackupFile varchar(128)
AS
BEGIN
    DECLARE @ReturnCode int
    declare @BackupFilePath varchar(256)
    declare @BackupFileRealName varchar(128)

    declare @BackupFiles table
                         (
                             subdirectory varchar(128),
                             depth        int,
                             isFile       int
                         )
    insert into @BackupFiles
        EXEC master..xp_dirtree @LogshippingDBInitDir, 10, 1

    DECLARE CUR_BackupFiles CURSOR FAST_FORWARD FOR
        select subdirectory
        from (select subdirectory, SUBSTRING(subdirectory, 1, CHARINDEX('___', subdirectory) - 1) dbname
              from @BackupFiles
              where isFile = 1) a
        where dbname = SUBSTRING(@BackupFile, 1, CHARINDEX('___', @BackupFile) - 1);

    OPEN CUR_BackupFiles
    FETCH NEXT FROM CUR_BackupFiles INTO @BackupFileRealName

    WHILE @@FETCH_STATUS = 0
        BEGIN

            set @BackupFilePath = @LogshippingDBInitDir + '\' + @BackupFileRealName

            print @BackupFilePath

            declare @Exist int
            exec dba_FileExist @BackupFilePath, @isFile=1, @Exist = @Exist output

            if @Exist = 1
                begin
                    exec @ReturnCode = [master].dbo.xp_delete_file 0, @BackupFilePath

                    IF @ReturnCode <> 0 RAISERROR ('Error deleting files.', 16, 1)
                end

            FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile
        END
    CLOSE CUR_BackupFiles
    DEALLOCATE CUR_BackupFiles
END;
GO

use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_RestoreLogshippingDBs] @PrimaryServer varchar(64),
                                                  @LogshippingSrcSharedDir varchar(64) = 'Logshipping',
                                                  @DatafileLocation varchar(1024) = null,
                                                  @Database varchar(64) = '%'
AS
BEGIN

    set @PrimaryServer = LTRIM(RTRIM(@PrimaryServer))
    -- print 'debug: ' + @LogshippingRootDir
    if (@PrimaryServer is null or @PrimaryServer = '')
        begin
            RAISERROR ('%s',10,1,'Please input PrimaryServer.') WITH NOWAIT
            return
        end

    declare @BackupFileDir varchar(128)
    declare @BackupFiles table
                         (
                             subdirectory varchar(128),
                             depth        int,
                             isFile       int
                         )
    set @BackupFileDir = '\\' + @PrimaryServer + '\' + @LogshippingSrcSharedDir + '\init'
    insert into @BackupFiles
        EXEC master..xp_dirtree @BackupFileDir, 10, 1

    -- backup file list of datafile and logfile
    declare @FileList table
                      (
                          LogicalName          nvarchar(128),
                          PhysicalName         nvarchar(260),
                          Type                 char(1),
                          FileGroupName        nvarchar(128),
                          Size                 numeric(20, 0),
                          MaxSize              numeric(20, 0),
                          FileID               bigint,
                          CreateLSN            numeric(25, 0),
                          DropLSN              numeric(25, 0),
                          UniqueID             uniqueidentifier,
                          ReadOnlyLSN          numeric(25, 0),
                          ReadWriteLSN         numeric(25, 0),
                          BackupSizeInBytes    bigint,
                          SourceBlockSize      int,
                          FileGroupID          int,
                          LogGroupGUID         uniqueidentifier,
                          DifferentialBaseLSN  numeric(25, 0),
                          DifferentialBaseGUID uniqueidentifier,
                          IsReadOnly           bit,
                          IsPresent            bit,
                          TDEThumbprint        varbinary(32),
                          SnapshotURL          nvarchar(360)
                      )

    declare @Standby varchar(2)
    declare @RecoveryMode varchar(512)
    DECLARE @BackupFile varchar(256)
    declare @BackupFileFull varchar(512)
    declare @DBName varchar(64)
    declare @Command varchar(1024)

    DECLARE CUR_BackupFiles CURSOR FAST_FORWARD FOR
        select subdirectory
        from @BackupFiles
        where isFile = 1
          and lower(subdirectory) like lower(@Database + '[___]%')

    declare @LogicalName varchar(128)
    declare @PhysicalName varchar(128)
    declare @DatafileName varchar(128)
    declare @DatafileSrcDir varchar(512)
    declare @DatafileLocationDB varchar(1024)
    DECLARE @ReturnCode int


    OPEN CUR_BackupFiles
    FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile

    WHILE @@FETCH_STATUS = 0
        BEGIN

            set @DBName = SUBSTRING(@BackupFile, 1, CHARINDEX('___', @BackupFile) - 1)

            if not exists(select name from sys.Databases where lower(name) = lower(@DBName))
                begin
                    set @Standby = SUBSTRING(@BackupFile, CHARINDEX('___standby', @BackupFile) + 10, 1)
                    set @BackupFileFull = @BackupFileDir + '\' + @BackupFile

                    set @Command = 'restore filelistonly from disk=''' + @BackupFileFull + ''''

                    declare CUR_FileList CURSOR FAST_FORWARD FOR
                        select LogicalName, PhysicalName from @FileList
                    insert into @FileList
                        exec (@Command)

                    if @Standby = '0'
                        set @RecoveryMode = 'norecovery'
                    else
                        begin
                            declare @DefaultBackupDir varchar(1024)
                            exec dba_GetDefaultBackupDir @DefaultBackupDir output
                            set @RecoveryMode = 'standby = ''' + @DefaultBackupDir + '\' + @DBName +
                                                '_RollbackUndo_' +
                                                FORMAT(getdate(), 'yyyy-MM-dd_HH-mm-ss') + '.bak'''
                        end

                    set @Command = 'restore database ' + @DBName + ' from disk=''' + @BackupFileFull +
                                   ''' with ' + @RecoveryMode

                    -- iterate file list
                    OPEN CUR_FileList
                    FETCH NEXT FROM CUR_FileList INTO @LogicalName, @PhysicalName
                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            if @DatafileLocation is not null
                                -- specify a new location to store datafile and logfile
                                begin
                                    set @DatafileLocationDB = @DatafileLocation + '\' + @DBName
                                    exec @ReturnCode = [master].dbo.xp_create_subdir @DatafileLocationDB
                                    IF @ReturnCode <> 0 RAISERROR ('Error creating directory.', 16, 1)

                                    set @DatafileName =
                                            right(@PhysicalName, charindex('\', reverse(@PhysicalName)) - 1)

                                    set @Command = @Command + ', move ''' + @LogicalName + ''' to ''' +
                                                   @DatafileLocationDB + '\' + @DatafileName + ''''
                                end
                            else
                                -- keep the location as source database
                                begin
                                    set @DatafileSrcDir = left(@PhysicalName,
                                                               len(@PhysicalName) - charindex('\', reverse(@PhysicalName) + '\'))
                                    exec @ReturnCode = [master].dbo.xp_create_subdir @DatafileSrcDir
                                    IF @ReturnCode <> 0 RAISERROR ('Error creating directory.', 16, 1)
                                end

                            FETCH NEXT FROM CUR_FileList INTO @LogicalName, @PhysicalName
                        end
                    CLOSE CUR_FileList
                    DEALLOCATE CUR_FileList

                    print @Command
                    exec (@Command)

                    delete from @FileList
                end
            else
                print 'Database[' + @DBName + '] already exists'

            FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile
        END
    CLOSE CUR_BackupFiles
    DEALLOCATE CUR_BackupFiles

END
GO

use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_CreateLogshippingDirs] @LogshippingRootDir varchar(64),
                                                  @PrimaryServer varchar(64),
                                                  @LogshippingSrcSharedDir varchar(64),
                                                  @database varchar(64) = '%'
AS
BEGIN
    set @LogshippingRootDir = LTRIM(RTRIM(@LogshippingRootDir))
    -- print 'debug: ' + @LogshippingRootDir
    if (@LogshippingRootDir is null or @LogshippingRootDir = '')
        begin
            RAISERROR ('%s',10,1,'Please input logshipping root dir.') WITH NOWAIT
            return
        end

    declare @BackupFileDir varchar(128)
    declare @BackupFiles table
                         (
                             subdirectory varchar(128),
                             depth        int,
                             isFile       int
                         )
    set @BackupFileDir = '\\' + @PrimaryServer + '\' + @LogshippingSrcSharedDir + '\init'
    insert into @BackupFiles
        EXEC master..xp_dirtree @BackupFileDir, 10, 1

    DECLARE @DBName varchar(64);
    declare @LogshippingDBDir varchar(128);
    DECLARE @ReturnCode int

    DECLARE @DirectoryInfo TABLE
                           (
                               FileExists            bit,
                               FileIsADirectory      bit,
                               ParentDirectoryExists bit
                           );

    DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
        select SUBSTRING(subdirectory, 1, CHARINDEX('___', subdirectory) - 1) dbname
        from @BackupFiles
        where isFile = 1
          and lower(subdirectory) like lower(@Database + '[___]%');

    OPEN CUR_DBNames
    FETCH NEXT FROM CUR_DBNames INTO @DBName

    WHILE @@FETCH_STATUS = 0
        BEGIN
            set @LogshippingDBDir = @LogshippingRootDir + '\' + @DBName

            delete from @DirectoryInfo
            INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
                EXECUTE [master].dbo.xp_fileexist @LogshippingDBDir

            IF NOT EXISTS(SELECT *
                          FROM @DirectoryInfo
                          WHERE FileExists = 0
                            AND FileIsADirectory = 1
                            AND ParentDirectoryExists = 1)
                BEGIN
                    exec @ReturnCode = [master].dbo.xp_create_subdir @LogshippingDBDir
                    IF @ReturnCode <> 0 RAISERROR ('Error creating directory.', 16, 1)
                END
            else
                print 'Directory already exists: ' + @LogshippingDBDir

            FETCH NEXT FROM CUR_DBNames INTO @DBName
        END

    CLOSE CUR_DBNames
    DEALLOCATE CUR_DBNames

END
GO

use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_DeployLogshippingSub] @DBName varchar(64),
                                                 @PrimaryServer varchar(64), -- ip,port
                                                 @SecondaryServer varchar(64), -- ip,port
                                                 @LogshippingSrcSharedDir varchar(64) = 'Logshipping',
                                                 @LogshippingDestSharedDir varchar(64) = 'Logshipping',
                                                 @restore_mode int = 0,
                                                 @disconnect_users int =0,
                                                 @Interval int = 5
AS
BEGIN
    declare @PrimaryServerHost varchar(64)
    declare @PrimaryServerPort varchar(64)
    declare @SecondaryServerHost varchar(64)
    declare @SecondaryServerPort varchar(64)
    declare @backup_source_directory varchar(64)
    declare @backup_destination_directory varchar(64)
    declare @copy_job_name varchar(64)
    declare @restore_job_name varchar(64)

    declare @restore_threshold int
    set @restore_threshold = @Interval * 5

    -- split primary server to host and port
    set @PrimaryServerHost = substring(@PrimaryServer, 1, charindex(',', @PrimaryServer) - 1)
    set @PrimaryServerPort = substring(@PrimaryServer, charindex(',', @PrimaryServer) + 1, len(@PrimaryServer))

    set @SecondaryServerHost = substring(@SecondaryServer, 1, charindex(',', @SecondaryServer) - 1)
    set @SecondaryServerPort = substring(@SecondaryServer, charindex(',', @SecondaryServer) + 1, len(@PrimaryServer))

    set @backup_source_directory = '\\' + @PrimaryServerHost + '\' + @LogshippingSrcSharedDir + '\' + @DBName
    set @backup_destination_directory = '\\' + @SecondaryServerHost + '\' + @LogshippingDestSharedDir + '\' + @DBName
    set @copy_job_name = 'LSCopy_' + @PrimaryServer + '_' + @DBName
    set @restore_job_name = 'LSRestore_' + @SecondaryServer + '_' + @DBName

    print @backup_source_directory
    print @backup_destination_directory
    print @copy_job_name
    print @restore_job_name

    -- Begin: Generated Script

    DECLARE @LS_Secondary__CopyJobId AS uniqueidentifier
    DECLARE @LS_Secondary__RestoreJobId AS uniqueidentifier
    DECLARE @LS_Secondary__SecondaryId AS uniqueidentifier
    DECLARE @LS_Add_RetCode As int


    EXEC @LS_Add_RetCode = master.dbo.sp_add_log_shipping_secondary_primary
                           @primary_server = @PrimaryServer
        , @primary_database = @DBName
        , @backup_source_directory = @backup_source_directory
        , @backup_destination_directory = @backup_destination_directory
        , @copy_job_name = @copy_job_name
        , @restore_job_name = @restore_job_name
        , @file_retention_period = 4320
        , @overwrite = 1
        , @copy_job_id = @LS_Secondary__CopyJobId OUTPUT
        , @restore_job_id = @LS_Secondary__RestoreJobId OUTPUT
        , @secondary_id = @LS_Secondary__SecondaryId OUTPUT

    IF (@@ERROR = 0 AND @LS_Add_RetCode = 0)
        BEGIN

            DECLARE @LS_SecondaryCopyJobScheduleUID As uniqueidentifier
            DECLARE @LS_SecondaryCopyJobScheduleID AS int


            EXEC msdb.dbo.sp_add_schedule
                 @schedule_name =N'DefaultCopyJobSchedule'
                , @enabled = 1
                , @freq_type = 4
                , @freq_interval = 1
                , @freq_subday_type = 4
                , @freq_subday_interval = @Interval
                , @freq_recurrence_factor = 0
                , @active_start_date = 20200608
                , @active_end_date = 99991231
                , @active_start_time = 100
                , @active_end_time = 59
                , @schedule_uid = @LS_SecondaryCopyJobScheduleUID OUTPUT
                , @schedule_id = @LS_SecondaryCopyJobScheduleID OUTPUT

            EXEC msdb.dbo.sp_attach_schedule
                 @job_id = @LS_Secondary__CopyJobId
                , @schedule_id = @LS_SecondaryCopyJobScheduleID

            DECLARE @LS_SecondaryRestoreJobScheduleUID As uniqueidentifier
            DECLARE @LS_SecondaryRestoreJobScheduleID AS int


            EXEC msdb.dbo.sp_add_schedule
                 @schedule_name =N'DefaultRestoreJobSchedule'
                , @enabled = 1
                , @freq_type = 4
                , @freq_interval = 1
                , @freq_subday_type = 4
                , @freq_subday_interval = @Interval
                , @freq_recurrence_factor = 0
                , @active_start_date = 20200608
                , @active_end_date = 99991231
                , @active_start_time = 200
                , @active_end_time = 159
                , @schedule_uid = @LS_SecondaryRestoreJobScheduleUID OUTPUT
                , @schedule_id = @LS_SecondaryRestoreJobScheduleID OUTPUT

            EXEC msdb.dbo.sp_attach_schedule
                 @job_id = @LS_Secondary__RestoreJobId
                , @schedule_id = @LS_SecondaryRestoreJobScheduleID


        END


    DECLARE @LS_Add_RetCode2 As int


    IF (@@ERROR = 0 AND @LS_Add_RetCode = 0)
        BEGIN

            EXEC @LS_Add_RetCode2 = master.dbo.sp_add_log_shipping_secondary_database
                                    @secondary_database = @DBName
                , @primary_server = @PrimaryServer
                , @primary_database = @DBName
                , @restore_delay = 0
                , @restore_mode = @restore_mode
                , @disconnect_users = @disconnect_users
                , @restore_threshold = @restore_threshold
                , @threshold_alert_enabled = 1
                , @history_retention_period = 5760
                , @overwrite = 1

        END


    IF (@@error = 0 AND @LS_Add_RetCode = 0)
        BEGIN

            EXEC msdb.dbo.sp_update_job
                 @job_id = @LS_Secondary__CopyJobId
                , @enabled = 1

            EXEC msdb.dbo.sp_update_job
                 @job_id = @LS_Secondary__RestoreJobId
                , @enabled = 1

        END


    -- End: Generated Script
END
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_DeployLogshipping] @PrimaryServer varchar(64), -- ip,port
                                              @SecondaryServer varchar(64), -- ip,port
                                              @LogshippingSrcSharedDir varchar(64) = 'Logshipping',
                                              @LogshippingDestSharedDir varchar(64) = 'Logshipping',
                                              @Database varchar(64) = '%',
                                              @Interval int = 5
AS
BEGIN
    DECLARE @DBName varchar(64)
    declare @Standby varchar(2)
    declare @restore_mode int
    declare @disconnect_users int
    declare @PrimaryServerHost varchar(64)
    declare @BackupFileDir varchar(128)
    declare @BackupFiles table
                         (
                             subdirectory varchar(128),
                             depth        int,
                             isFile       int
                         )

    set @PrimaryServerHost = substring(@PrimaryServer, 1, charindex(',', @PrimaryServer) - 1)
    set @BackupFileDir = '\\' + @PrimaryServerHost + '\' + @LogshippingSrcSharedDir + '\init'

    insert into @BackupFiles
        EXEC master..xp_dirtree @BackupFileDir, 10, 1

    DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
        select SUBSTRING(subdirectory, 1, CHARINDEX('___', subdirectory) - 1)         dbname,
               SUBSTRING(subdirectory, CHARINDEX('___standby', subdirectory) + 10, 1) standby
        from @BackupFiles
        where isFile = 1
          and lower(subdirectory) like lower(@Database + '[___]%');

    OPEN CUR_DBNames
    FETCH NEXT FROM CUR_DBNames INTO @DBName, @Standby

    WHILE @@FETCH_STATUS = 0
        BEGIN
            if @Standby = '0'
                begin
                    set @restore_mode = 0
                    set @disconnect_users = 0
                end
            else
                begin
                    set @restore_mode = 1
                    set @disconnect_users = 1
                end

            exec dba_DeployLogshippingSub
                 @DBName=@DBName
                , @PrimaryServer = @PrimaryServer
                , @SecondaryServer = @SecondaryServer
                , @LogshippingSrcSharedDir = @LogshippingSrcSharedDir
                , @LogshippingDestSharedDir = @LogshippingDestSharedDir
                , @restore_mode = @restore_mode
                , @disconnect_users = @disconnect_users
                , @Interval = @Interval

            FETCH NEXT FROM CUR_DBNames INTO @DBName, @Standby
        END

    CLOSE CUR_DBNames
    DEALLOCATE CUR_DBNames

END
GO

use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_LogshippingClean] @Database varchar(64) = '%'
AS
BEGIN

    DECLARE @DBName varchar(64);

    DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
        select primary_database
        from msdb.dbo.log_shipping_secondary
        where lower(primary_database) like lower(@database);

    OPEN CUR_DBNames
    FETCH NEXT FROM CUR_DBNames INTO @DBName

    WHILE @@FETCH_STATUS = 0
        BEGIN
            exec sp_delete_log_shipping_secondary_database
                 @secondary_database = @DBName

            FETCH NEXT FROM CUR_DBNames INTO @DBName
        END

    CLOSE CUR_DBNames
    DEALLOCATE CUR_DBNames
END
GO

