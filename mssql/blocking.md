## Blocking

### Blocking tree

[https://blog.sqlauthority.com/2020/04/20/sql-server-blocking-tree-identifying-blocking-chain-using-sql-scripts/](https://blog.sqlauthority.com/2020/04/20/sql-server-blocking-tree-identifying-blocking-chain-using-sql-scripts/)

```sql
IF OBJECT_ID('tempdb..#Blocks') IS NOT NULL
    DROP TABLE #Blocks
SELECT   spid
        ,blocked
        ,REPLACE (REPLACE (st.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS batch
INTO     #Blocks
FROM     sys.sysprocesses spr
    CROSS APPLY sys.dm_exec_sql_text(spr.SQL_HANDLE) st
GO 
WITH BlockingTree (spid, blocking_spid, [level], batch)
AS
(
    SELECT   blc.spid
            ,blc.blocked
            ,CAST (REPLICATE ('0', 4-LEN (CAST (blc.spid AS VARCHAR))) + 
            CAST (blc.spid AS VARCHAR) AS VARCHAR (1000)) AS [level]
            ,blc.batch
    FROM    #Blocks blc
    WHERE   (blc.blocked = 0 OR blc.blocked = SPID) AND
            EXISTS (SELECT * FROM #Blocks blc2 WHERE blc2.BLOCKED = 
                    blc.SPID AND blc2.BLOCKED <> blc2.SPID)
    UNION ALL
    SELECT   blc.spid
            ,blc.blocked
            ,CAST(bt.[level] + RIGHT (CAST ((1000 + blc.SPID) AS VARCHAR (100)), 4) 
                        AS VARCHAR (1000)) AS [level]
            ,blc.batch
    FROM     #Blocks AS blc
        INNER JOIN BlockingTree bt 
            ON  blc.blocked = bt.SPID
    WHERE   blc.blocked > 0 AND
            blc.blocked <> blc.SPID
)
SELECT  N'' + ISNULL(REPLICATE (N'|         ', LEN (LEVEL)/4 - 2),'')
        + CASE WHEN (LEN(LEVEL)/4 - 1) = 0 THEN '' ELSE '|------  ' END
        + CAST (bt.SPID AS NVARCHAR (10)) AS BlockingTree
        ,spr.lastwaittype   AS [Type]
        ,spr.loginame       AS [Login Name]
        ,st.text            AS [SQL Text]
        ,IIF(cur.sql_handle IS NULL, '', (SELECT [TEXT] FROM
                    sys.dm_exec_sql_text (cur.sql_handle))) AS [Cursor SQL Text]
        ,DB_NAME(spr.dbid)  AS [Database]
        ,sli.rsc_objid AS [ObjectID]
        ,ISNULL(OBJECT_NAME(sli.rsc_objid),
                'USE '+DB_NAME(spr.dbid)+'; SELECT ' +
                        'OBJECT_SCHEMA_NAME('+CONVERT(varchar,sli.rsc_objid)+
                        ').OBJECT_NAME('+CONVERT(varchar,sli.rsc_objid)+')') 
                                    AS [TableName] 
        ,spr.cmd            AS [Command]
        ,spr.waitresource   AS [Wait Resource]
        ,spr.program_name   AS [Application]
        ,spr.hostname       AS [HostName]
        ,spr.last_batch     AS [Last Batch Time]
FROM BlockingTree bt
    LEFT OUTER JOIN sys.sysprocesses spr 
        ON  spr.spid = bt.spid
    CROSS APPLY sys.dm_exec_sql_text(spr.SQL_HANDLE) st
    LEFT JOIN sys.dm_exec_cursors(0) cur
        ON  cur.session_id = spr.spid AND
            cur.fetch_status != 0
    JOIN master.dbo.syslockinfo sli
        ON  sli.req_spid = spr.spid 
    JOIN master.dbo.spt_values spv
        ON  spv.[type] = 'LR' AND
            spv.[name] = 'TAB' AND
            spv.number = sli.rsc_type
ORDER BY LEVEL ASC
```

### Blocking sql

[https://www.cnblogs.com/xinzhyu/p/10794129.html](https://www.cnblogs.com/xinzhyu/p/10794129.html)

```sql
CREATE TABLE [dbo].[BlockLog]
    (
      Id INT IDENTITY(1, 1)
             NOT NULL
             PRIMARY KEY ,
      [BlockingSessesionId] [smallint] NULL ,
      [ProgramName] [nchar](128) NULL ,
      [HostName] [nchar](128) NULL ,
      [ClientIpAddress] [varchar](48) NULL ,
      [DatabaseName] [sysname] NOT NULL ,
      [WaitType] [nvarchar](60) NULL ,
      [BlockingStartTime] [datetime] NOT NULL ,
      [WaitDuration] [bigint] NULL ,
      [BlockedSessionId] [int] NULL ,
      [BlockedSQLText] [nvarchar](MAX) NULL ,
      [BlockingSQLText] [nvarchar](MAX) NULL ,
      [dt] [datetime] NOT NULL
    )
ON  [PRIMARY]
GO

SET NOCOUNT ON;
DECLARE @dt DATETIME= GETDATE();

IF OBJECT_ID('tempdb.dbo.#BlockLog') IS NOT NULL 
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

    INSERT  INTO test_full.dbo.BlockLog
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
  END;

	select * from test_full.dbo.BlockLog

SELECT  R.session_id AS BlockedSessionID ,  
        S.session_id AS BlockingSessionID ,  
        Q1.text AS BlockedSession_TSQL ,  
        Q2.text AS BlockingSession_TSQL ,  
        C1.most_recent_sql_handle AS BlockedSession_SQLHandle ,  
        C2.most_recent_sql_handle AS BlockingSession_SQLHandle ,  
        S.original_login_name AS BlockingSession_LoginName ,  
        S.program_name AS BlockingSession_ApplicationName ,  
        S.host_name AS BlockingSession_HostName  
FROM    sys.dm_exec_requests AS R  
        INNER JOIN sys.dm_exec_sessions AS S ON R.blocking_session_id = S.session_id  
        INNER JOIN sys.dm_exec_connections AS C1 ON R.session_id = C1.most_recent_session_id  
        INNER JOIN sys.dm_exec_connections AS C2 ON S.session_id = C2.most_recent_session_id  
        CROSS APPLY sys.dm_exec_sql_text(C1.most_recent_sql_handle) AS Q1  
        CROSS APPLY sys.dm_exec_sql_text(C2.most_recent_sql_handle) AS Q2
```
