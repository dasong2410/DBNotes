use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_CreateLogshippingDirs] @LogshippingRootDir varchar(64),
                                                  @PrimaryServer varchar(64),
                                                  @LogshippingSrcSharedDir varchar(64),
                                                  @database varchar(64) = '%'
AS
BEGIN
    set @LogshippingRootDir = LTRIM(RTRIM(@LogshippingRootDir))
    -- print 'debug: ' + @LogshippingRootDir
    if (@LogshippingRootDir is null or @LogshippingRootDir = '')
        begin
            RAISERROR ('%s',10,1,'Please input logshipping root dir.') WITH NOWAIT
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

    DECLARE @DBName varchar(64);
    declare @LogshippingDBDir varchar(128);
    DECLARE @ReturnCode int

    DECLARE @DirectoryInfo TABLE
                           (
                               FileExists            bit,
                               FileIsADirectory      bit,
                               ParentDirectoryExists bit
                           );

    DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
        select SUBSTRING(subdirectory, 1, CHARINDEX('___', subdirectory) - 1) dbname
        from @BackupFiles
        where isFile = 1
          and lower(subdirectory) like lower(@Database + '[___]%');

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

