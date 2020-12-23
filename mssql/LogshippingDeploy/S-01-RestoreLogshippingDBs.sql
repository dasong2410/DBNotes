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

