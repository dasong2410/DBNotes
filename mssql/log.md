# Transaction Log

## VLF details

- [Transaction Log Architecture](https://docs.microsoft.com/en-us/sql/relational-databases/sql-server-transaction-log-architecture-and-management-guide?view=sql-server-ver15#:~:text=Transaction%20Log%20Logical%20Architecture,a%20string%20of%20log%20records.&text=Log%20records%20for%20data%20modifications,images%20of%20the%20modified%20data.)

- [sys.dm_db_log_info](https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-log-info-transact-sql?view=sql-server-ver15)

```sql
-- dbcc loginfo
select * from sys.dm_db_log_info(default)
```

## Log reuse wait

- [The Transaction Log](https://docs.microsoft.com/en-us/sql/relational-databases/logs/the-transaction-log-sql-server?view=sql-server-ver15)

```sql
select name, log_reuse_wait_desc from sys.databases;
```

## Log usage 

```sql
DBCC SQLPERF(LOGSPACE);
GO

SELECT [Current LSN],[Operation] ,[Transaction ID],[Previous LSN] ,[AllocUnitName],[Previous Page LSN],
[Page ID],[XACT ID],[Begin Time],[End Time]
FROM sys.fn_dblog (NULL, NULL)
```

## Latest retored trans log

```sql

CREATE TABLE [dbo].[#TmpErrorLog]
(
    [LogDate]     DATETIME     NULL,
    [ProcessInfo] VARCHAR(20)  NULL,
    [Text]        VARCHAR(MAX) NULL
);

insert into [dbo].[#TmpErrorLog]([LogDate], [ProcessInfo], [Text])
    exec xp_readerrorlog 0, 1, N'Log was restored. Database: '

select db_name, trans_log_name latest_trans_log_name, text
from (
         select x1.*, ROW_NUMBER() over (partition by db_name order by logdate desc) rn
         from (
                  select substring(text, CHARINDEX(':', text) + 2,
                                   CHARINDEX(',', text) - CHARINDEX(':', text) - 2) db_name,
                         substring(text, CHARINDEX('{', text) + 2,
                                   CHARINDEX('}', text) - CHARINDEX('{', text) - 3) trans_log_name,
                         *
                  from [dbo].[#TmpErrorLog]) x1) x2
where rn = 1;

drop table [dbo].[#TmpErrorLog];
```