SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[CreateDBInitBackups]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CreateDBInitBackups] AS'
    END
GO

ALTER PROCEDURE [dbo].[CreateDBInitBackups]
    @LogshippingRootDir varchar(64)
    AS
    BEGIN

        set @LogshippingRootDir = LTRIM(RTRIM(@LogshippingRootDir))
        -- print 'debug: ' + @LogshippingRootDir
        if(@LogshippingRootDir is null or @LogshippingRootDir = '')
            begin
                RAISERROR('%s',10,1,'Please input logshipping root dir.') WITH NOWAIT
                return
            end

        DECLARE @DBName varchar(64);
        declare @LogshippingDBInitDir varchar(128);
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
            where logshipping = 1;

        --set @LogshippingRootDir = 'C:\MSSQL_BACKUP2\Logshipping'

        OPEN CUR_DBNames
        FETCH NEXT FROM CUR_DBNames INTO @DBName

        WHILE @@FETCH_STATUS = 0
            BEGIN
                set @LogshippingDBInitDir = @LogshippingRootDir + '\init'

                SET @Command = 'BACKUP DATABASE ' + @DBName + ' TO DISK = N''' + @LogshippingDBInitDir + '\' + @DBName +
                               '___just_for_sure_nobody_using_this_name.bak'' WITH CHECKSUM, COMPRESSION'
                print @Command
                execute (@Command)
                FETCH NEXT FROM CUR_DBNames INTO @DBName
            END

        CLOSE CUR_DBNames
        DEALLOCATE CUR_DBNames

    END
GO