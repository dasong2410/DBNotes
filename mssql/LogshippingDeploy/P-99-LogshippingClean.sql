use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_LogshippingClean] @SecondaryServers varchar(64), -- ip,port;ip,port
                                             @Database varchar(64) = '%'
AS
BEGIN
    declare @SecondaryServer varchar(64)
    DECLARE @DBName varchar(64)


    DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
        select name
        from logshipping_cfg
        where logshipping = 1
          and lower(name) like lower(@Database);

    OPEN CUR_DBNames
    FETCH NEXT FROM CUR_DBNames INTO @DBName
    -- loop logshipping database
    WHILE @@FETCH_STATUS = 0
        begin
            DECLARE CUR_SecondaryServers CURSOR FAST_FORWARD FOR
                SELECT value FROM STRING_SPLIT(@SecondaryServers, ';')

            OPEN CUR_SecondaryServers
            FETCH NEXT FROM CUR_SecondaryServers INTO @SecondaryServer
            -- loop secondary server
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    EXEC sp_delete_log_shipping_primary_secondary
                         @primary_database = @DBName
                        , @secondary_server = @SecondaryServer
                        , @secondary_database = @DBName

                    exec sp_delete_log_shipping_primary_database
                         @Database = @DBName

                    FETCH NEXT FROM CUR_SecondaryServers INTO @SecondaryServer
                END

            CLOSE CUR_SecondaryServers
            DEALLOCATE CUR_SecondaryServers

            FETCH NEXT FROM CUR_DBNames INTO @DBName
        end

    CLOSE CUR_DBNames
    DEALLOCATE CUR_DBNames
END
GO

