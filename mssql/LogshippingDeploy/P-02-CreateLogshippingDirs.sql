SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[CreateLogshippingDirs]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CreateLogshippingDirs] AS'
    END
GO

ALTER PROCEDURE [dbo].[CreateLogshippingDirs]

    @LogshippingRootDir varchar(64)
    AS
    BEGIN
        set @LogshippingRootDir = LTRIM(RTRIM(@LogshippingRootDir))
        -- print 'debug: ' + @LogshippingRootDir
        if (@LogshippingRootDir is null or @LogshippingRootDir = '')
            begin
                RAISERROR ('%s',10,1,'Please input logshipping root dir.') WITH NOWAIT
                return
            end

        DECLARE @DBName varchar(64);
        declare @LogshippingDBDir varchar(128);
        declare @Command varchar(256);
        DECLARE @DirectoryInfo TABLE
                               (
                                   FileExists            bit,
                                   FileIsADirectory      bit,
                                   ParentDirectoryExists bit
                               );

        DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
            select name
            from logshipping_cfg
            where logshipping = 1
            union all
            select 'init' name;

        --set @LogshippingRootDir = 'C:\MSSQL_BACKUP2\Logshipping'

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
                        SET @Command =
                                    'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_create_subdir N''' +
                                    @LogshippingRootDir + '\' + @DBName +
                                    ''' IF @ReturnCode <> 0 RAISERROR(''Error creating directory.'', 16, 1)'
                        print @Command
                        execute (@Command)
                    END
                else
                    print 'Directory already exists: ' + @LogshippingDBDir

                FETCH NEXT FROM CUR_DBNames INTO @DBName
            END

        CLOSE CUR_DBNames
        DEALLOCATE CUR_DBNames

    END
GO