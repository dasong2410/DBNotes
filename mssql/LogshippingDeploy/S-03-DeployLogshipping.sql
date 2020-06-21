use master
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[dba_DeployLogshipping]
    @PrimaryServer varchar(64), -- ip,port
        @SecondaryServer varchar(64), -- ip,port
        @LogshippingSrcSharedDir varchar(64) = 'Logshipping',
        @LogshippingDestSharedDir varchar(64) = 'Logshipping',
        @Database varchar(64) = '%'
    AS
    BEGIN
        DECLARE @DBName varchar(64);
        declare @PrimaryServerHost varchar(64)
        declare @BackupFileDir varchar(128)
        declare @BackupFiles table
                             (
                                 subdirectory varchar(128),
                                 depth        int,
                                 isFile       int
                             )

        set @PrimaryServerHost = substring(@PrimaryServer, 1, charindex(',', @PrimaryServer) - 1)
        set @BackupFileDir = '\\' + @PrimaryServerHost + '\' + @LogshippingSrcSharedDir + '\init'

        insert into @BackupFiles
            EXEC master..xp_dirtree @BackupFileDir, 10, 1

        DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
            select SUBSTRING(subdirectory, 1, CHARINDEX('___', subdirectory) - 1) dbname
            from @BackupFiles
            where isFile = 1
              and lower(subdirectory) like lower(@Database + '[___]%');

        OPEN CUR_DBNames
        FETCH NEXT FROM CUR_DBNames INTO @DBName

        WHILE @@FETCH_STATUS = 0
            BEGIN
                exec dba_DeployLogshippingSub
                     @DBName=@DBName
                    , @PrimaryServer = @PrimaryServer
                    , @SecondaryServer = @SecondaryServer
                    , @LogshippingSrcSharedDir = @LogshippingSrcSharedDir
                    , @LogshippingDestSharedDir = @LogshippingDestSharedDir

                FETCH NEXT FROM CUR_DBNames INTO @DBName
            END

        CLOSE CUR_DBNames
        DEALLOCATE CUR_DBNames

    END
GO


CREATE OR ALTER PROCEDURE [dbo].[dba_DeployLogshippingSub]
    @DBName varchar(64),
        @PrimaryServer varchar(64), -- ip,port
        @SecondaryServer varchar(64), -- ip,port
        @LogshippingSrcSharedDir varchar(64) = 'Logshipping',
        @LogshippingDestSharedDir varchar(64) = 'Logshipping'
    AS
    BEGIN
        declare @PrimaryServerHost varchar(64)
        declare @PrimaryServerPort varchar(64)
        declare @backup_source_directory varchar(64)
        declare @backup_destination_directory varchar(64)
        declare @copy_job_name varchar(64)
        declare @restore_job_name varchar(64)

        -- split primary server to host and port
        set @PrimaryServerHost = substring(@PrimaryServer, 1, charindex(',', @PrimaryServer) - 1)
        set @PrimaryServerPort = substring(@PrimaryServer, charindex(',', @PrimaryServer) + 1, len(@PrimaryServer))

        set @backup_source_directory = '\\' + @PrimaryServerHost + '\' + @LogshippingSrcSharedDir + '\' + @DBName
        set @backup_destination_directory = '\\' + @SecondaryServer + '\' + @LogshippingDestSharedDir + '\' + @DBName
        set @copy_job_name = 'LSCopy_' + @PrimaryServer + '_' + @DBName
        set @restore_job_name = 'LSRestore_' + @SecondaryServer + '_' + @DBName


        print @backup_source_directory
        print @backup_destination_directory
        print @copy_job_name
        print @restore_job_name

        -- Begin: Generated Script

        DECLARE @LS_Secondary__CopyJobId AS uniqueidentifier
        DECLARE @LS_Secondary__RestoreJobId AS uniqueidentifier
        DECLARE @LS_Secondary__SecondaryId AS uniqueidentifier
        DECLARE @LS_Add_RetCode As int


        EXEC @LS_Add_RetCode = master.dbo.sp_add_log_shipping_secondary_primary
                               @primary_server = @PrimaryServer
            , @primary_database = @DBName
            , @backup_source_directory = @backup_source_directory
            , @backup_destination_directory = @backup_destination_directory
            , @copy_job_name = @copy_job_name
            , @restore_job_name = @restore_job_name
            , @file_retention_period = 4320
            , @overwrite = 1
            , @copy_job_id = @LS_Secondary__CopyJobId OUTPUT
            , @restore_job_id = @LS_Secondary__RestoreJobId OUTPUT
            , @secondary_id = @LS_Secondary__SecondaryId OUTPUT

        IF (@@ERROR = 0 AND @LS_Add_RetCode = 0)
            BEGIN

                DECLARE @LS_SecondaryCopyJobScheduleUID As uniqueidentifier
                DECLARE @LS_SecondaryCopyJobScheduleID AS int


                EXEC msdb.dbo.sp_add_schedule
                     @schedule_name =N'DefaultCopyJobSchedule'
                    , @enabled = 1
                    , @freq_type = 4
                    , @freq_interval = 1
                    , @freq_subday_type = 4
                    , @freq_subday_interval = 5
                    , @freq_recurrence_factor = 0
                    , @active_start_date = 20200608
                    , @active_end_date = 99991231
                    , @active_start_time = 0
                    , @active_end_time = 235900
                    , @schedule_uid = @LS_SecondaryCopyJobScheduleUID OUTPUT
                    , @schedule_id = @LS_SecondaryCopyJobScheduleID OUTPUT

                EXEC msdb.dbo.sp_attach_schedule
                     @job_id = @LS_Secondary__CopyJobId
                    , @schedule_id = @LS_SecondaryCopyJobScheduleID

                DECLARE @LS_SecondaryRestoreJobScheduleUID As uniqueidentifier
                DECLARE @LS_SecondaryRestoreJobScheduleID AS int


                EXEC msdb.dbo.sp_add_schedule
                     @schedule_name =N'DefaultRestoreJobSchedule'
                    , @enabled = 1
                    , @freq_type = 4
                    , @freq_interval = 1
                    , @freq_subday_type = 4
                    , @freq_subday_interval = 5
                    , @freq_recurrence_factor = 0
                    , @active_start_date = 20200608
                    , @active_end_date = 99991231
                    , @active_start_time = 0
                    , @active_end_time = 235900
                    , @schedule_uid = @LS_SecondaryRestoreJobScheduleUID OUTPUT
                    , @schedule_id = @LS_SecondaryRestoreJobScheduleID OUTPUT

                EXEC msdb.dbo.sp_attach_schedule
                     @job_id = @LS_Secondary__RestoreJobId
                    , @schedule_id = @LS_SecondaryRestoreJobScheduleID


            END


        DECLARE @LS_Add_RetCode2 As int


        IF (@@ERROR = 0 AND @LS_Add_RetCode = 0)
            BEGIN

                EXEC @LS_Add_RetCode2 = master.dbo.sp_add_log_shipping_secondary_database
                                        @secondary_database = @DBName
                    , @primary_server = @PrimaryServer
                    , @primary_database = @DBName
                    , @restore_delay = 0
                    , @restore_mode = 0
                    , @disconnect_users = 0
                    , @restore_threshold = 45
                    , @threshold_alert_enabled = 1
                    , @history_retention_period = 5760
                    , @overwrite = 1

            END


        IF (@@error = 0 AND @LS_Add_RetCode = 0)
            BEGIN

                EXEC msdb.dbo.sp_update_job
                     @job_id = @LS_Secondary__CopyJobId
                    , @enabled = 1

                EXEC msdb.dbo.sp_update_job
                     @job_id = @LS_Secondary__RestoreJobId
                    , @enabled = 1

            END


        -- End: Generated Script
    END
GO
