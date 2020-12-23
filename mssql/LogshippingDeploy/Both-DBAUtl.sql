use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_FileExist] @FilePath varchar(128),
                                      @isFile int = 0,
                                      @isDirectory int =0,
                                      @Exist int output
AS
BEGIN
    DECLARE @DirectoryInfo TABLE
                           (
                               FileExists            bit,
                               FileIsADirectory      bit,
                               ParentDirectoryExists bit
                           )

    delete from @DirectoryInfo
    INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
        EXECUTE [master].dbo.xp_fileexist @FilePath

    SELECT @Exist = count(1)
    FROM @DirectoryInfo
    WHERE FileExists = @isFile
      AND FileIsADirectory = @isDirectory
      AND ParentDirectoryExists = 1

    print @Exist
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_GetDefaultBackupDir] @DefaultBackupDir varchar(128) output
AS
BEGIN
    DECLARE @BackupDir TABLE
                       (
                           name  varchar(64),
                           value varchar(1024)
                       )

    delete from @BackupDir
    INSERT INTO @BackupDir (name, value)
        EXEC master.dbo.xp_instance_regread
             N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory'

    select top 1 @DefaultBackupDir = value from @BackupDir
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR
ALTER PROCEDURE [dbo].[dba_DeleteBackupFile] @LogshippingDBInitDir varchar(1024),
                                             @BackupFile varchar(128)
AS
BEGIN
    DECLARE @ReturnCode int
    declare @BackupFilePath varchar(256)
    declare @BackupFileRealName varchar(128)

    declare @BackupFiles table
                         (
                             subdirectory varchar(128),
                             depth        int,
                             isFile       int
                         )
    insert into @BackupFiles
        EXEC master..xp_dirtree @LogshippingDBInitDir, 10, 1

    DECLARE CUR_BackupFiles CURSOR FAST_FORWARD FOR
        select subdirectory
        from (select subdirectory, SUBSTRING(subdirectory, 1, CHARINDEX('___', subdirectory) - 1) dbname
              from @BackupFiles
              where isFile = 1) a
        where dbname = SUBSTRING(@BackupFile, 1, CHARINDEX('___', @BackupFile) - 1);

    OPEN CUR_BackupFiles
    FETCH NEXT FROM CUR_BackupFiles INTO @BackupFileRealName

    WHILE @@FETCH_STATUS = 0
        BEGIN

            set @BackupFilePath = @LogshippingDBInitDir + '\' + @BackupFileRealName

            print @BackupFilePath

            declare @Exist int
            exec dba_FileExist @BackupFilePath, @isFile=1, @Exist = @Exist output

            if @Exist = 1
                begin
                    exec @ReturnCode = [master].dbo.xp_delete_file 0, @BackupFilePath

                    IF @ReturnCode <> 0 RAISERROR ('Error deleting files.', 16, 1)
                end

            FETCH NEXT FROM CUR_BackupFiles INTO @BackupFile
        END
    CLOSE CUR_BackupFiles
    DEALLOCATE CUR_BackupFiles
END;
GO

