<a name="Replication"></a>
# Replication

- [Configure Publishing and Distribution](#Configure-Publishing-and-Distribution)
- [Query replication metadata](#Query-replication-metadata)
- [Remove db replication](#Remove-db-replication)

<a href="Configure-Publishing-and-Distribution"></a>
## [Configure Publishing and Distribution](#Replication)



```sql
-- https://docs.microsoft.com/en-us/sql/relational-databases/replication/configure-publishing-and-distribution?view=sql-server-ver15

-- 1. $(DistPubServer) = host name
-- 2. Login ssms with host name

-- This script uses sqlcmd scripting variables. They are in the form
-- $(MyVariable). For information about how to use scripting variables  
-- on the command line and in SQL Server Management Studio, see the 
-- "Executing Replication Scripts" section in the topic
-- "Programming Replication Using System Stored Procedures".

-- Install the Distributor and the distribution database.
DECLARE @distributor AS sysname;
DECLARE @distributionDB AS sysname;
DECLARE @publisher AS sysname;
DECLARE @directory AS nvarchar(500);
DECLARE @publicationDB AS sysname;
-- Specify the Distributor name.
SET @distributor = $(DistPubServer);
-- Specify the distribution database.
SET @distributionDB = N'distribution';
-- Specify the Publisher name.
SET @publisher = $(DistPubServer);
-- Specify the replication working directory.
SET @directory = N'\\' + $(DistPubServer) + '\repldata';
-- Specify the publication database.
SET @publicationDB = N'AdventureWorks2012'; 

-- Install the server MYDISTPUB as a Distributor using the defaults,
-- including autogenerating the distributor password.
USE master
EXEC sp_adddistributor @distributor = @distributor;

-- Create a new distribution database using the defaults, including
-- using Windows Authentication.
USE master
EXEC sp_adddistributiondb @database = @distributionDB, 
    @security_mode = 1;
GO

-- Create a Publisher and enable AdventureWorks2012 for replication.
-- Add MYDISTPUB as a publisher with MYDISTPUB as a local distributor
-- and use Windows Authentication.
DECLARE @distributionDB AS sysname;
DECLARE @publisher AS sysname;
-- Specify the distribution database.
SET @distributionDB = N'distribution';
-- Specify the Publisher name.
SET @publisher = $(DistPubServer);

USE [distribution]
EXEC sp_adddistpublisher @publisher=@publisher, 
    @distribution_db=@distributionDB, 
    @security_mode = 1;
GO
```

<a href="Query-replication-metadata"></a>
## [Query replication metadata](#Replication)

```sql
select * from distribution.dbo.MSlogreader_agents;
select * from distribution.dbo.MSlogreader_history;

select * from distribution.dbo.MSdistribution_agents;
select * from distribution.dbo.MSdistribution_history;

select distinct article from distribution.dbo.MSarticles;

select * from distribution.dbo.MSpublications;
select * from distribution.dbo.MSsubscriptions;
select * from distribution.dbo.MSarticles order by article;
select article from distribution.dbo.MSarticles where publication_id=xx order by article;

-- generate sql
select 'select count(1) cnt, ''' + article + ''' tab from ' + article + '(nolock) union all' from distribution.dbo.MSarticles where publication_id=2 order by article;


select * from sys.tables where name not like 'MS%' order by name;

use Applecare_Prod
exec sp_droppublication @publication= 'Applecare_Prod_Repl';
exec sp_subscription_cleanup @publication= 'Applecare_Prod_Repl';
```

<a href="Remove-db-replication"></a>
## [Remove db replication](#Replication)

```sql
USE Applecare_Prod
EXEC sp_removedbreplication @dbname=Applecare_Prod
GO
```
