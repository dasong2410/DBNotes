use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[dba_LogshippingClean]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[dba_LogshippingClean] AS'
    END
GO

ALTER PROCEDURE [dbo].[dba_LogshippingClean]
    @Database varchar(64) = '%'
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
