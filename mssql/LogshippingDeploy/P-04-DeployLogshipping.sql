SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[dba_DeployLogshipping]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[dba_DeployLogshipping] AS'
    END
GO

IF NOT EXISTS(SELECT *
              FROM sys.objects
              WHERE object_id = OBJECT_ID(N'[dbo].[dba_DeployLogshippingSub]')
                AND type in (N'P', N'PC'))
    BEGIN
        EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[dba_DeployLogshippingSub] AS'
    END
GO

ALTER PROCEDURE [dbo].[dba_DeployLogshipping]
    @LogshippingRootDir varchar(64),
        @PrimaryServer varchar(64),
        @PrimaryServerPort varchar(64),
        @SecondaryServer varchar(64),
        @SecondaryServerPort varchar(64),
        @LogshippingSharedDir varchar(64) = 'Logshipping',
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

        DECLARE CUR_DBNames CURSOR FAST_FORWARD FOR
            select name
            from logshipping_cfg
            where logshipping = 1
              and lower(name) like lower(@Database);

        OPEN CUR_DBNames
        FETCH NEXT FROM CUR_DBNames INTO @DBName

        WHILE @@FETCH_STATUS = 0
            BEGIN
                exec dba_DeployLogshippingSub
                     @LogshippingRootDir = @LogshippingRootDir
                    , @DBName=@DBName
                    , @PrimaryServer = @PrimaryServer
                    , @PrimaryServerPort = @PrimaryServerPort
                    , @SecondaryServer = @SecondaryServer
                    , @SecondaryServerPort = @SecondaryServerPort
                    , @LogshippingSharedDir = @LogshippingSharedDir

                FETCH NEXT FROM CUR_DBNames INTO @DBName
            END

        CLOSE CUR_DBNames
        DEALLOCATE CUR_DBNames

    END
GO


ALTER PROCEDURE [dbo].[dba_DeployLogshippingSub]
    @LogshippingRootDir varchar(64),
        @DBName varchar(64),
        @PrimaryServer varchar(64),
        @PrimaryServerPort varchar(64),
        @SecondaryServer varchar(64),
        @SecondaryServerPort varchar(64),
        @LogshippingSharedDir varchar(64)
    AS
    BEGIN
        declare @Secondary varchar(64)
        declare @backup_directory varchar(64)
        declare @backup_share varchar(64)
        declare @backup_job_name varchar(64)
        declare @schedule_name varchar(64)

        set @Secondary = @SecondaryServer + ',' + @SecondaryServerPort
        set @backup_directory = @LogshippingRootDir + '\' + @DBName
        set @backup_share = '\\' + @PrimaryServer + '\' + @LogshippingSharedDir + '\' + @DBName
        set @backup_job_name = 'LSBackup_' + @DBName
        set @schedule_name = 'LSBackupSchedule_' + @DBName + ',' + @PrimaryServerPort

        print @backup_directory
        print @backup_share
        print @backup_job_name
        print @schedule_name

        -- Begin: Generated Script
        DECLARE @LS_BackupJobId AS uniqueidentifier
        DECLARE @LS_PrimaryId AS uniqueidentifier
        DECLARE @SP_Add_RetCode As int

        EXEC @SP_Add_RetCode = master.dbo.sp_add_log_shipping_primary_database
                               @Database = @DBName
            , @backup_directory = @backup_directory
            , @backup_share = @backup_share
            , @backup_job_name = @backup_job_name
            , @backup_retention_period = 4320
            , @backup_compression = 1
            , @backup_threshold = 25
            , @threshold_alert_enabled = 1
            , @history_retention_period = 5760
            , @backup_job_id = @LS_BackupJobId OUTPUT
            , @primary_id = @LS_PrimaryId OUTPUT
            , @overwrite = 1

        print @LS_BackupJobId
        print @LS_PrimaryId
        print @SP_Add_RetCode

        IF (@@ERROR = 0 AND @SP_Add_RetCode = 0)
            BEGIN

                DECLARE @LS_BackUpScheduleUID As uniqueidentifier
                DECLARE @LS_BackUpScheduleID AS int


                EXEC msdb.dbo.sp_add_schedule
                     @schedule_name = @schedule_name
                    , @enabled = 1
                    , @freq_type = 4
                    , @freq_interval = 1
                    , @freq_subday_type = 4
                    , @freq_subday_interval = 5
                    , @freq_recurrence_factor = 0
                    , @active_start_date = 20200526
                    , @active_end_date = 99991231
                    , @active_start_time = 0
                    , @active_end_time = 235900
                    , @schedule_uid = @LS_BackUpScheduleUID OUTPUT
                    , @schedule_id = @LS_BackUpScheduleID OUTPUT

                EXEC msdb.dbo.sp_attach_schedule
                     @job_id = @LS_BackupJobId
                    , @schedule_id = @LS_BackUpScheduleID

                EXEC msdb.dbo.sp_update_job
                     @job_id = @LS_BackupJobId
                    , @enabled = 1


            END


        EXEC master.dbo.sp_add_log_shipping_alert_job

        EXEC master.dbo.sp_add_log_shipping_primary_secondary
             @primary_database = @DBName
            , @secondary_server = @Secondary
            , @secondary_database = @DBName
            , @overwrite = 1


        -- End: Generated Script
    END
GO
