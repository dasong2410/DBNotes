SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[LogshippingClean]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[LogshippingClean] AS'
    END
GO

ALTER PROCEDURE [dbo].[LogshippingClean]
    @SecondaryServer varchar(64)
    AS
    BEGIN

        DECLARE @DBName varchar(64);

        DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
            select name
            from logshipping_cfg
            where logshipping = 1;

        OPEN CUR_DBNames
        FETCH NEXT FROM CUR_DBNames INTO @DBName

        WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC sp_delete_log_shipping_primary_secondary
                     @primary_database = @DBName
                    , @secondary_server = @SecondaryServer
                    , @secondary_database = @DBName

                exec sp_delete_log_shipping_primary_database
                     @database = @DBName

                FETCH NEXT FROM CUR_DBNames INTO @DBName
            END

        CLOSE CUR_DBNames
        DEALLOCATE CUR_DBNames

    END
GO