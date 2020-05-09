
USE master
GO

/****** Object:  Table [dbo].[BlockLog]    Script Date: 4/29/2020 4:54:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BlockLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BlockingSessesionId] [smallint] NULL,
	[ProgramName] [nchar](128) NULL,
	[HostName] [nchar](128) NULL,
	[ClientIpAddress] [varchar](48) NULL,
	[DatabaseName] [sysname] NOT NULL,
	[WaitType] [nvarchar](60) NULL,
	[BlockingStartTime] [datetime] NOT NULL,
	[WaitDuration] [bigint] NULL,
	[BlockedSessionId] [int] NULL,
	[BlockedSQLText] [nvarchar](max) NULL,
	[BlockingSQLText] [nvarchar](max) NULL,
	[dt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

create index idx_BlockingStartTime on BlockLog(BlockingStartTime);
create index idx_dt on BlockLog(dt);



USE [msdb]
GO

/****** Object:  Job [MonitorBlocking]    Script Date: 4/29/2020 4:53:12 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 4/29/2020 4:53:12 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
declare @owner varchar(32) = SUSER_SNAME(0x01)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'MonitorBlocking', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=@owner, @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [execute blocking script]    Script Date: 4/29/2020 4:53:12 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'execute blocking script', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
SET NOCOUNT ON;
DECLARE @dt DATETIME= GETDATE();

IF OBJECT_ID(''tempdb.dbo.#BlockLog'') IS NOT NULL 
  DROP TABLE #BlockLog;   
  BEGIN  
    SELECT  wt.blocking_session_id AS BlockingSessesionId ,
        sp.program_name AS ProgramName ,
        COALESCE(sp.LOGINAME, sp.nt_username) AS HostName ,
        ec1.client_net_address AS ClientIpAddress ,
        db.name AS DatabaseName ,
        wt.wait_type AS WaitType ,
        ec1.connect_time AS BlockingStartTime ,
        wt.WAIT_DURATION_MS / 1000 AS WaitDuration ,
        ec1.session_id AS BlockedSessionId ,
        h1.TEXT AS BlockedSQLText ,
        h2.TEXT AS BlockingSQLText ,
        @dt dt
    INTO  #BlockLog
    FROM  sys.dm_tran_locks AS tl
        INNER JOIN sys.databases db ON db.database_id = tl.resource_database_id
        INNER JOIN sys.dm_os_waiting_tasks AS wt ON tl.lock_owner_address = wt.resource_address
        INNER JOIN sys.dm_exec_connections ec1 ON ec1.session_id = tl.request_session_id
        INNER JOIN sys.dm_exec_connections ec2 ON ec2.session_id = wt.blocking_session_id
        LEFT OUTER JOIN master.dbo.sysprocesses sp ON SP.spid = wt.blocking_session_id
        CROSS APPLY sys.dm_exec_sql_text(ec1.most_recent_sql_handle) AS h1
        CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2;     

    INSERT  INTO master.dbo.BlockLog
        ( BlockingSessesionId ,
          ProgramName ,
          HostName ,
          ClientIpAddress ,
          DatabaseName ,
          WaitType ,
          BlockingStartTime ,
          WaitDuration ,
          BlockedSessionId ,
          BlockedSQLText ,
          BlockingSQLText ,
          dt
        )
        SELECT  BlockingSessesionId ,
            ProgramName ,
            HostName ,
            ClientIpAddress ,
            DatabaseName ,
            WaitType ,
            BlockingStartTime ,
            WaitDuration ,
            BlockedSessionId ,
            BlockedSQLText ,
            BlockingSQLText ,
            dt
        FROM  #BlockLog;

    DROP TABLE #BlockLog;  
  END;', 
		@database_name=N'tempdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'ScheduleBlockingCheck', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20151015, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO



USE [msdb]
GO

/****** Object:  Job [MonitorBlocking - Clean]    Script Date: 2020-04-29 5:16:32 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2020-04-29 5:16:32 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
declare @owner varchar(32) = SUSER_SNAME(0x01)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'MonitorBlocking - Clean', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=@owner, @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [MonitorBlocking - Clean]    Script Date: 2020-04-29 5:16:33 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'MonitorBlocking - Clean', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'delete from master.dbo.BlockLog where dt < DATEADD(dd,-30,GETDATE())
', 
		@database_name=N'tempdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'MonitorBlocking - Clean', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20200429, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


