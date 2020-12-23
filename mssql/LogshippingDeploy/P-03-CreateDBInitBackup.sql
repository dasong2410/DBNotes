use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_CreateDBInitBackups] @LogshippingRootDir varchar(64),
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
    declare @Standby varchar(2)
    declare @LogshippingDBInitDir varchar(128);
    declare @BackupFile varchar(128);
    declare @BackupFilePath varchar(1024)
    declare @Command varchar(256);
    --declare @BackupDesc varchar(1024)

    DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
        select name, standby
        from logshipping_cfg
        where logshipping = 1
          and lower(name) like lower(@Database);

    OPEN CUR_DBNames
    FETCH NEXT FROM CUR_DBNames INTO @DBName, @Standby

    WHILE @@FETCH_STATUS = 0
        BEGIN
            set @LogshippingDBInitDir = @LogshippingRootDir + '\init'
            set @BackupFile =
                        @DBName + '___just_for_sure_nobody_using_this_name___flag___standby' + @Standby + '.bak'
            set @BackupFilePath = @LogshippingDBInitDir + '\' + @BackupFile
            --set @BackupDesc = 'standby:' + @Standby

            -- delete backup file first
            exec dba_DeleteBackupFile @LogshippingDBInitDir, @BackupFile

            -- backup database
            SET @Command = 'BACKUP DATABASE ' + @DBName + ' TO DISK = N''' + @BackupFilePath +
                           ''' WITH CHECKSUM, COMPRESSION'
            --SET @Command = 'BACKUP DATABASE ' + @DBName + ' TO DISK = N''' + @BackupFilePath +
            --               ''' WITH DESCRIPTION=''' + @BackupDesc + ''', CHECKSUM, COMPRESSION'

            print @Command
            execute (@Command)

            FETCH NEXT FROM CUR_DBNames INTO @DBName, @Standby
        END

    CLOSE CUR_DBNames
    DEALLOCATE CUR_DBNames

END
GO

