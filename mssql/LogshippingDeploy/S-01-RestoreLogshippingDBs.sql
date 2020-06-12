SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[dba_RestoreLogshippingDBs]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[dba_RestoreLogshippingDBs] AS'
    END
GO

ALTER PROCEDURE [dbo].[dba_RestoreLogshippingDBs]
    @PrimaryServer varchar(64),
        @LogshippingSrcSharedDir varchar(64) = 'Logshipping',
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
              and lower(subdirectory) like lower(@Database + '[___]%');

        OPEN CUR_BackupFiles
        FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile

        WHILE @@FETCH_STATUS = 0
            BEGIN

                set @DBName = SUBSTRING(@BackupFile, 1, CHARINDEX('___', @BackupFile) - 1)

                if not exists(select name from sys.Databases where lower(name) = lower(@DBName))
                    begin
                        set @Standby = SUBSTRING(@BackupFile, CHARINDEX('___standby', @BackupFile) + 10, 1)
                        set @BackupFileFull = @BackupFileDir + '\' + @BackupFile
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
                        print @Command
                        exec (@Command)
                    end
                else
                    print 'Database[' + @DBName + '] already exists'

                FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile
            END
        CLOSE CUR_BackupFiles
        DEALLOCATE CUR_BackupFiles

    END
GO
