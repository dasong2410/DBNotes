select DB_NAME();
select USER_NAME();


create table tb_test_1
(
c1 int primary key,
c2 int
);

select * from test.dbo.tb_test_1;

SELECT SERVERPROPERTY('Collation');

use test;
use master;

create table tb_test_2
(
c1 int primary key,
c2 int
);

select * from tb_test_2;

select * from sys.endpoints;



select db_name();

create table tb_test_1
(
  c1 varchar(255)
);

insert into tb_test_1 values('xx' + char(13) +char(10) + 'yyyy');

select * from tb_test_1;



select [Database Version], SUBSTRING([Database Version], 3, 5) from dbo.AWBuildVersion;

select * from dbo.AWBuildVersion;

select cast(substring('AB1232', PATINDEX('%[0123456789]%', 'AB1232'), len('AB1232')) as int);



select * from msdb.dbo.backupfile;
select * from msdb.dbo.backupset;



select * from sysperfinfo;

select * from fn_helpcollations () where lower(name) like '%utf%';





SELECT
	migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) AS improvement_measure,
	'CREATE INDEX [missing_index_' + CONVERT (varchar, mig.index_group_handle) + '_' + CONVERT (varchar, mid.index_handle)
	+ '_' + LEFT (PARSENAME(mid.statement, 1), 32) + ']'
	+ ' ON ' + mid.statement
	+ ' (' + ISNULL (mid.equality_columns,'')
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END
    + ISNULL (mid.inequality_columns, '')
	+ ')'
	+ ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement,
	migs.*, mid.database_id, mid.[object_id]
FROM
	sys.dm_db_missing_index_groups mig
	INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
	INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE
	migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
ORDER BY
	migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC




	select @@SPID