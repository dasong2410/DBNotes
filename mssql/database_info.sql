-----------------------------------------------------------------------------
-- Database Information: begin
-----------------------------------------------------------------------------
-- sql server info
select serverproperty('MachineName')                           as host,
       coalesce(serverproperty('InstanceName'), 'MSSQLSERVER') as instance,
       --serverproperty('ProductVersion') AS ProductVersion,
       --serverproperty('InstanceDefaultLogPath') LogPath,
       @@version                                               as version_number,
       serverproperty('ProductLevel')                          as product_level, /* RTM or SP1 etc*/
       serverproperty('Edition')                               as edition,
       serverproperty('InstanceDefaultDataPath')                  data_path,
       case serverproperty('IsIntegratedSecurityOnly')
           when 1 then 'Windows Authentication'
           when 0 then 'Windows and SQL Server Authentication'
           end                                                 as authentication_mode;
-----------------------------------------------------------------------------
-- Database Information: begin
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- database info, file size: begin
-----------------------------------------------------------------------------
with a as (select name, database_id, recovery_model_desc, collation_name
           from sys.databases),
     b as (select database_id, name, physical_name, sum(size) over (partition by database_id) db_size
           from sys.master_files)
select a.name                                db_name,
       a.recovery_model_desc,
       collation_name,
       round(b.db_size * 8 / 1024 / 1024, 2) [db_size(G)],
       b.name                                file_name,
       b.physical_name
from a,
     b
where a.database_id = b.database_id;
-----------------------------------------------------------------------------
-- database info, file size: end
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- specific database info, file size: begin
-----------------------------------------------------------------------------
use [database_name];
go
with a as (select name, database_id, recovery_model_desc, collation_name
           from sys.databases
           where database_id = db_id()),
     b as (
         select name, physical_name, sum(size) over (partition by null) db_size
         from sys.database_files)
select a.name                                                 db_name,
       a.recovery_model_desc,
       collation_name,
       cast(b.db_size * 8 / 1024 / 1024.00 as numeric(16, 2)) [db_size(G)],
       b.name                                                 file_name,
       b.physical_name
from a,
     b;
-----------------------------------------------------------------------------
-- specific database info, file size: begin
-----------------------------------------------------------------------------
