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
    @SecondaryServer varchar(64),
        @SecondaryServerPort varchar(64),
        @Database varchar(64) = '%'
    AS
    BEGIN
        declare @Secondary varchar(64)
        DECLARE @DBName varchar(64)

        set @Secondary = @SecondaryServer + ',' + @SecondaryServerPort

        DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
            select name
            from logshipping_cfg
            where logshipping = 1
              and lower(name) like lower(@Database);

        OPEN CUR_DBNames
        FETCH NEXT FROM CUR_DBNames INTO @DBName

        WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC sp_delete_log_shipping_primary_secondary
                     @primary_database = @DBName
                    , @secondary_server = @Secondary
                    , @secondary_database = @DBName

                exec sp_delete_log_shipping_primary_database
                     @Database = @DBName

                FETCH NEXT FROM CUR_DBNames INTO @DBName
            END

        CLOSE CUR_DBNames
        DEALLOCATE CUR_DBNames

    END
GO