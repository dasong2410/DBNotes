SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[RestoreLogshippingDBs]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RestoreLogshippingDBs] AS'
    END
GO

ALTER PROCEDURE [dbo].[RestoreLogshippingDBs]
    @PrimaryServer varchar(64)
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
        set @BackupFileDir = '\\' + @PrimaryServer + '\LogShipping\init'
        insert into @BackupFiles
            EXEC master..xp_dirtree @BackupFileDir, 10, 1

        DECLARE @BackupFile varchar(256)
        declare @BackupFileFull varchar(512)
        declare @DBName varchar(64)
        declare @Command varchar(1024)

        DECLARE CUR_BackupFiles CURSOR FAST_FORWARD FOR
            select subdirectory
            from @BackupFiles
            where isFile = 1;

        OPEN CUR_BackupFiles
        FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile

        WHILE @@FETCH_STATUS = 0
            BEGIN

                set @DBName = SUBSTRING(@BackupFile, 1, CHARINDEX('___', @BackupFile) - 1)
                set @BackupFileFull = @BackupFileDir + '\' + @BackupFile

                if not exists(select name from sys.databases where lower(name) = lower(@DBName))
                    begin
                        set @Command = 'restore database ' + @DBName + ' from disk=''' + @BackupFileFull +
                                       ''' with norecovery'
                        print @Command
--                         exec (@Command)
                    end
                else
                    print 'Database[' + @DBName + '] already exists'

                FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile
            END
        CLOSE CUR_BackupFiles
        DEALLOCATE CUR_BackupFiles

    END
GO
