drop table if exists [dbo].[#TmpErrorLog];

CREATE TABLE [dbo].[#TmpErrorLog]
(
    [LogDate]     DATETIME     NULL,
    [ProcessInfo] VARCHAR(20)  NULL,
    [Text]        VARCHAR(MAX) NULL
);

insert into [dbo].[#TmpErrorLog]([LogDate], [ProcessInfo], [Text])
    exec xp_readerrorlog 0, 1, N'Log was restored. Database: ';

insert into [dbo].[#TmpErrorLog]([LogDate], [ProcessInfo], [Text])
    exec xp_readerrorlog 0, 1, N'Database was restored: Database: ';


with a as (select logdate,
                  processinfo,
                  replace(text, ' restored: ',
                          ' restored. ') text
           from [dbo].[#TmpErrorLog]),
     b as (select substring(text, CHARINDEX(':', text) + 2, CHARINDEX(',', text) - CHARINDEX(':', text) - 2) db_name,
                  substring(text, CHARINDEX('{', text) + 2, CHARINDEX('}', text) - CHARINDEX('{', text) - 3) file_name,
                  *
           from a),
     c as (select db_name, file_name latest_restored_file, text
           from (select *, ROW_NUMBER() over (partition by db_name order by logdate desc) rn from b) x2
           where rn = 1)
select c.db_name,
       x.recovery_model_desc,
       x.state_desc,
       reverse(substring(reverse(latest_restored_file), 1,
                         CHARINDEX('\', reverse(latest_restored_file)) - 1)) latest_restored_file,
       text
from c,
     sys.databases x
where c.db_name = x.name;

-- drop table [dbo].[#TmpErrorLog];
