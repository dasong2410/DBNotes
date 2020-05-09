# User

<a name="Table-of-Contents"></a>
## Table of Contents

- [Create user](#Create-user)
- [Alter user](#Alter-user)
- [Permission](#Permission)
- [Activated users](#Activated-users)
- [Export login](#Export-login)

Query sid, name

```sql
select SUSER_SID('sa');
select SUSER_SNAME(0x01);
```


<a name="Create user"></a>
## [Create user](#Table-of-Contents)

### Windows authenticated user

```sql
USE [master]
GO

CREATE LOGIN [APLACSVR1KR\AppleKRadmin] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

# https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/server-level-roles?view=sql-server-ver15
ALTER SERVER ROLE [sysadmin] ADD MEMBER [APLACSVR1KR\AppleKRadmin]
GO
```

### SQL Server authenticated user

```sql
# create login
CREATE LOGIN shcooper   
  WITH PASSWORD = 'Baz1nga'
       DEFAULT_DATABASE = MyDatabase,
       DEFAULT_LANGUAGE = us_english
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
GO

# unlock login without changing password
ALTER LOGIN [shcooper] WITH CHECK_POLICY = OFF;
ALTER LOGIN [shcooper] UNLOCK;
ALTER LOGIN [shcooper] WITH CHECK_POLICY = ON;
GO
```

<a href="Permission"></a>
### [Permission](#Table-of-Contents)

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