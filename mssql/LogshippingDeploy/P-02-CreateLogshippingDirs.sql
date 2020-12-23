use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_CreateLogshippingDirs] @LogshippingRootDir varchar(64),
                                                  @Database varchar(64) = '%'
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
    DECLARE @ReturnCode int

    DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
        select name
        from logshipping_cfg
        where logshipping = 1
          and lower(name) like lower(@Database)
        union all
        select 'init' name;

    OPEN CUR_DBNames
    FETCH NEXT FROM CUR_DBNames INTO @DBName

    WHILE @@FETCH_STATUS = 0
        BEGIN
            set @LogshippingDBDir = @LogshippingRootDir + '\' + @DBName

            -- if db dir exists
            declare @Exist int
            exec dba_FileExist @LogshippingDBDir, @isDirectory=1, @Exist = @Exist output

            -- create db dir if not exist
            IF @Exist = 0
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

