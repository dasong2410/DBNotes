# User

<a name="Table-of-Contents"></a>
## Table of Contents

- [Create user](#Create-user)
- [Alter user](#Alter-user)
- [Query user](#Query-user)
- [Login&User mapping](#Login&User-mapping)
- [Permission](#Permission)
- [Activated users](#Activated-users)
- [Export login](#Export-login)

<a name="Create user"></a>
## [Create user](#Table-of-Contents)

### Windows authenticated user

```sql
USE [master]
GO

CREATE LOGIN [DESKTOP-S0V3U1D\Marcus] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

# https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/server-level-roles?view=sql-server-ver15
ALTER SERVER ROLE [sysadmin] ADD MEMBER [DESKTOP-S0V3U1D\Marcus]
GO
```

### SQL Server authenticated user

```sql
# create login
CREATE LOGIN shcooper
  WITH PASSWORD = 'Baz1nga',
       DEFAULT_DATABASE = MyDatabase,
       DEFAULT_LANGUAGE = us_english,
       CHECK_POLICY = ON,
       CHECK_EXPIRATION = OFF;
GO

# add to db_owner role
USE MyDatabase
GO

CREATE USER [shcooper] FOR LOGIN [shcooper] WITH DEFAULT_SCHEMA=[dbo]
GO

exec sp_addrolemember 'db_owner', 'shcooper' 
GO

# grant sql agent permission
USE msdb
GO

CREATE USER [shcooper] FOR LOGIN [shcooper] WITH DEFAULT_SCHEMA=[dbo]
GO

# https://docs.microsoft.com/en-us/sql/ssms/agent/sql-server-agent-fixed-database-roles?view=sql-server-ver15

# Agent role: SQLAgentUserRole, SQLAgentReaderRole, SQLAgentOperatorRole
exec sp_addrolemember 'SQLAgentUserRole', 'shcooper'
GO
```

<a href="Alter-user"></a>
### [Alter user](#Table-of-Contents)

https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-login-transact-sql?view=sql-server-ver15

```sql
# enable
ALTER LOGIN shcooper ENABLE;

# disable
ALTER LOGIN shcooper DISABLE;

# rename
ALTER LOGIN shcooper WITH NAME = shcooper1;

# check policy
alter login shcooper with check_policy = on;

# check expiration
alter login shcooper with CHECK_EXPIRATION = off;

# change default database
alter login shcooper with default_database = tempdb;

# change password
ALTER LOGIN shcooper WITH PASSWORD = 'Baz1nga@1024';

# Changing the password of a login when logged in as the login
ALTER LOGIN shcooper WITH PASSWORD = 'Baz1nga@1024' OLD_PASSWORD = 'Baz1nga';

# unlock login
ALTER LOGIN [shcooper] WITH PASSWORD = '****' UNLOCK ;

# unlock login without changing password
ALTER LOGIN [shcooper] WITH CHECK_POLICY = OFF;
ALTER LOGIN [shcooper] WITH CHECK_POLICY = ON;

alter user schooper with LOGIN = schooper;
```

<a href="Query-user"></a>
### [Query user](#Table-of-Contents)

```sql
# get user sid
select SUSER_SID('sa');

# get user name
select SUSER_SNAME(0x01);

select * from  sys.sql_logins where is_expiration_checked=1;

SELECT  name, LOGINPROPERTY(name, 'BadPasswordCount') AS 'BadPasswordCount'
,LOGINPROPERTY(name, 'BadPasswordTime') AS 'BadPasswordTime'
,LOGINPROPERTY(name, 'DaysUntilExpiration') AS 'DaysUntilExpiration'
,LOGINPROPERTY(name, 'DefaultDatabase') AS 'DefaultDatabase'
,LOGINPROPERTY(name, 'DefaultLanguage') AS 'DefaultLanguage'
,LOGINPROPERTY(name, 'HistoryLength') AS 'HistoryLength'
,LOGINPROPERTY(name, 'IsExpired') AS 'IsExpired'
,LOGINPROPERTY(name, 'IsLocked') AS 'IsLocked'
,LOGINPROPERTY(name, 'IsMustChange') AS 'IsMustChange'
,LOGINPROPERTY(name, 'LockoutTime') AS 'LockoutTime'
,LOGINPROPERTY(name, 'PasswordHash') AS 'PasswordHash'
,LOGINPROPERTY(name, 'PasswordLastSetTime') AS 'PasswordLastSetTime'
,LOGINPROPERTY(name, 'PasswordHashAlgorithm') AS 'PasswordHashAlgorithm'
,is_expiration_checked  As 'is_expiration_checked'
FROM    sys.sql_logins
WHERE   is_policy_checked = 1 and is_expiration_checked=1
```

<a href="Login&User-mapping"></a>
### [Login&User mapping](#Table-of-Contents)

- All logins and users mapping
```sql
# https://www.sqlserver-dba.com/2015/01/how-to-list-sql-logins-and-database-user-mappings.html

--Step 1 : Create temp tab;le
CREATE TABLE #tempMappings
(
    LoginName nvarchar(1000),
    DBname    nvarchar(1000),
    Username  nvarchar(1000),
    Alias     nvarchar(1000)
)

--Step 2:Insert the sp_msloginmappings into the temp table
INSERT INTO #tempMappings
    EXEC master..sp_msloginmappings

--Step 3 : List the results . Filter as required
SELECT *
FROM #tempMappings
ORDER BY DBname, username

--Step 4: Manage cleanup of temp table
DROP TABLE #tempMappings
```

- Specific login mapping
```sql
# @loginname: the login account name, If loginname is not specified, results are returned for the login accounts
# @Flags: value can be 0 and 1, by default 0. 0 means show mapping user in all databases. 1 indicates how mapping user in current database context.
exec sp_msloginmappings @Loginname , @Flags

# show mapping user in all databases
exec sp_msloginmappings 'sa', 0;

# show mapping user in current database
exec sp_msloginmappings 'sa', 1;
```


<a href="Permission"></a>
### [Permission](#Table-of-Contents)

```sql
-- all permissions of user: test1
select * from sys.database_permissions
 where grantee_principal_id=user_id('test1');
```

- [Permissions (Database Engine)](https://docs.microsoft.com/en-us/sql/relational-databases/security/permissions-database-engine?view=sql-server-ver15)

- [GRANT Database Permissions (Transact-SQL)](https://docs.microsoft.com/en-us/sql/t-sql/statements/grant-database-permissions-transact-sql?view=sql-server-ver15)

- [Determining Effective Database Engine Permissions](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/determining-effective-database-engine-permissions?view=sql-server-ver15)

- [REVERT (Transact-SQL)](https://docs.microsoft.com/en-us/sql/t-sql/statements/revert-transact-sql?view=sql-server-ver15)

- [Permissions Hierarchy (Database Engine)](https://docs.microsoft.com/en-us/sql/relational-databases/security/permissions-hierarchy-database-engine?view=sql-server-ver15)

```sql
# sys.server_principals
# sys.server_role_members
# sys.server_principals
#
# sys.database_principals
# sys.database_role_members
# sys.database_principals

# login, role relation
select u.name login_name, u.principal_id login_id,
       r.name role_name, r.principal_id role_id
  from sys.server_principals u, sys.server_role_members m, sys.server_principals r
 where u.principal_id=m.member_principal_id
   and m.role_principal_id = r.principal_id
   and r.type='R'
 order by login_name;

# user, role relation
select u.name user_name, u.principal_id user_id,
       r.name role_name, r.principal_id role_id
  from sys.database_principals u, sys.database_role_members m, sys.database_principals r
 where u.principal_id=m.member_principal_id
   and m.role_principal_id = r.principal_id
   and r.type='R'
 order by user_name;
```

```sql
# aimetl is a role
grant CONNECT to aimetl;
grant EXECUTE to aimetl;

# Server Permissions
SELECT pr.type_desc, pr.name, 
 isnull (pe.state_desc, 'No permission statements') AS state_desc, 
 isnull (pe.permission_name, 'No permission statements') AS permission_name 
 FROM sys.server_principals AS pr
 LEFT OUTER JOIN sys.server_permissions AS pe
   ON pr.principal_id = pe.grantee_principal_id
 WHERE is_fixed_role = 0 -- Remove for SQL Server 2008
 ORDER BY pr.name, type_desc;

# Database Permissions
SELECT distinct pr.type_desc, pr.name, 
 isnull (pe.state_desc, 'No permission statements') AS state_desc, 
 isnull (pe.permission_name, 'No permission statements') AS permission_name 
FROM sys.database_principals AS pr
LEFT OUTER JOIN sys.database_permissions AS pe
    ON pr.principal_id = pe.grantee_principal_id
WHERE pr.is_fixed_role = 0 
ORDER BY pr.name, type_desc;
```

- [Get SQL Server user permissions](http://dbadailystuff.com/2012/08/20/get-sql-server-user-permissions)

```sql
EXECUTE AS USER = 'Bob';

-- Server rights
SELECT * FROM fn_my_permissions(NULL, 'SERVER');

-- Database rights
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');

-- Specific per object rigths
SELECT T.TABLE_TYPE AS OBJECT_TYPE, T.TABLE_SCHEMA AS [SCHEMA_NAME], T.TABLE_NAME AS [OBJECT_NAME], P.PERMISSION_NAME 
    FROM INFORMATION_SCHEMA.TABLES T
    CROSS APPLY fn_my_permissions(T.TABLE_SCHEMA + '.' + T.TABLE_NAME, 'OBJECT') P
    WHERE P.subentity_name = ''
UNION
SELECT R.ROUTINE_TYPE AS OBJECT_TYPE, R.ROUTINE_SCHEMA AS [SCHEMA_NAME], R.ROUTINE_NAME AS [OBJECT_NAME], P.PERMISSION_NAME
    FROM INFORMATION_SCHEMA.ROUTINES R
    CROSS APPLY fn_my_permissions(R.ROUTINE_SCHEMA + '.' + R.ROUTINE_NAME, 'OBJECT') P
ORDER BY OBJECT_TYPE, [SCHEMA_NAME], [OBJECT_NAME], P.PERMISSION_NAME

REVERT;
GO
```

```sql
EXEC sp_addsrvrolemember 'Corporate\HelenS', 'sysadmin';
GO

EXEC sp_dropsrvrolemember 'JackO', 'sysadmin';
GO

USE AdventureWorks
GO
GRANT VIEW Definition TO PUBLIC;

USE master
GO
GRANT VIEW ANY DEFINITION TO User1;
```

<a href="Activated-users"></a>
### [Activated users](#Table-of-Contents)

```sql
select * from sys.sysprocesses;

SELECT DB_NAME(dbid) as DBName,
       COUNT(dbid) as NumberOfConnections,
       loginame as LoginName
  FROM sys.sysprocesses
 WHERE dbid > 0
 GROUP BY dbid, loginame;

sp_who
sp_who2
```

<a href="Export-login"></a>
### [Export login](#Table-of-Contents)

```sql
-- https://support.microsoft.com/en-us/help/918992/how-to-transfer-logins-and-passwords-between-instances-of-sql-server

USE master
GO
IF OBJECT_ID ('sp_hexadecimal') IS NOT NULL
  DROP PROCEDURE sp_hexadecimal
GO
CREATE PROCEDURE sp_hexadecimal
    @binvalue varbinary(256),
    @hexvalue varchar (514) OUTPUT
AS
DECLARE @charvalue varchar (514)
DECLARE @i int
DECLARE @length int
DECLARE @hexstring char(16)
SELECT @charvalue = '0x'
SELECT @i = 1
SELECT @length = DATALENGTH (@binvalue)
SELECT @hexstring = '0123456789ABCDEF'
WHILE (@i <= @length)
BEGIN
  DECLARE @tempint int
  DECLARE @firstint int
  DECLARE @secondint int
  SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
  SELECT @firstint = FLOOR(@tempint/16)
  SELECT @secondint = @tempint - (@firstint*16)
  SELECT @charvalue = @charvalue +
    SUBSTRING(@hexstring, @firstint+1, 1) +
    SUBSTRING(@hexstring, @secondint+1, 1)
  SELECT @i = @i + 1
END

SELECT @hexvalue = @charvalue
GO
 
IF OBJECT_ID ('sp_help_revlogin') IS NOT NULL
  DROP PROCEDURE sp_help_revlogin
GO
CREATE PROCEDURE sp_help_revlogin @login_name sysname = NULL AS
DECLARE @name sysname
DECLARE @type varchar (1)
DECLARE @hasaccess int
DECLARE @denylogin int
DECLARE @is_disabled int
DECLARE @PWD_varbinary  varbinary (256)
DECLARE @PWD_string  varchar (514)
DECLARE @SID_varbinary varbinary (85)
DECLARE @SID_string varchar (514)
DECLARE @tmpstr  varchar (1024)
DECLARE @is_policy_checked varchar (3)
DECLARE @is_expiration_checked varchar (3)

DECLARE @defaultdb sysname
 
IF (@login_name IS NULL)
  DECLARE login_curs CURSOR FOR

      SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin FROM 
sys.server_principals p LEFT JOIN sys.syslogins l
      ON ( l.name = p.name ) WHERE p.type IN ( 'S', 'G', 'U' ) AND p.name <> 'sa'
ELSE
  DECLARE login_curs CURSOR FOR


      SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin FROM 
sys.server_principals p LEFT JOIN sys.syslogins l
      ON ( l.name = p.name ) WHERE p.type IN ( 'S', 'G', 'U' ) AND p.name = @login_name
OPEN login_curs

FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin
IF (@@fetch_status = -1)
BEGIN
  PRINT 'No login(s) found.'
  CLOSE login_curs
  DEALLOCATE login_curs
  RETURN -1
END
SET @tmpstr = '/* sp_help_revlogin script '
PRINT @tmpstr
SET @tmpstr = '** Generated ' + CONVERT (varchar, GETDATE()) + ' on ' + @@SERVERNAME + ' */'
PRINT @tmpstr
PRINT ''
WHILE (@@fetch_status <> -1)
BEGIN
  IF (@@fetch_status <> -2)
  BEGIN
    PRINT ''
    SET @tmpstr = '-- Login: ' + @name
    PRINT @tmpstr
    IF (@type IN ( 'G', 'U'))
    BEGIN -- NT authenticated account/group

      SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' FROM WINDOWS WITH DEFAULT_DATABASE = [' + @defaultdb + ']'
    END
    ELSE BEGIN -- SQL Server authentication
        -- obtain password and sid
            SET @PWD_varbinary = CAST( LOGINPROPERTY( @name, 'PasswordHash' ) AS varbinary (256) )
        EXEC sp_hexadecimal @PWD_varbinary, @PWD_string OUT
        EXEC sp_hexadecimal @SID_varbinary,@SID_string OUT
 
        -- obtain password policy state
        SELECT @is_policy_checked = CASE is_policy_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name
        SELECT @is_expiration_checked = CASE is_expiration_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name
 
            SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' WITH PASSWORD = ' + @PWD_string + ' HASHED, SID = ' + @SID_string + ', DEFAULT_DATABASE = [' + @defaultdb + ']'

        IF ( @is_policy_checked IS NOT NULL )
        BEGIN
          SET @tmpstr = @tmpstr + ', CHECK_POLICY = ' + @is_policy_checked
        END
        IF ( @is_expiration_checked IS NOT NULL )
        BEGIN
          SET @tmpstr = @tmpstr + ', CHECK_EXPIRATION = ' + @is_expiration_checked
        END
    END
    IF (@denylogin = 1)
    BEGIN -- login is denied access
      SET @tmpstr = @tmpstr + '; DENY CONNECT SQL TO ' + QUOTENAME( @name )
    END
    ELSE IF (@hasaccess = 0)
    BEGIN -- login exists but does not have access
      SET @tmpstr = @tmpstr + '; REVOKE CONNECT SQL TO ' + QUOTENAME( @name )
    END
    IF (@is_disabled = 1)
    BEGIN -- login is disabled
      SET @tmpstr = @tmpstr + '; ALTER LOGIN ' + QUOTENAME( @name ) + ' DISABLE'
    END
    PRINT @tmpstr
  END

  FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin
   END
CLOSE login_curs
DEALLOCATE login_curs
RETURN 0
GO
```

```sql
exec sp_help_revlogin
```

### [Back to top](#Table-of-Contents)