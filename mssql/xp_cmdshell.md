

## Enable

```sql
EXECUTE sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  

EXECUTE sp_configure 'xp_cmdshell', 1;  
GO  
RECONFIGURE;  
GO  

EXECUTE sp_configure 'show advanced options', 0;  
GO  
RECONFIGURE;  
GO  
```


## Non-sysadmin user exec xp_cmdshell

1. Create an OS account, maybe need in adminstrators, depends on os policy

2. Run SSMS as adminstrator

    ```sql
    use master
    go

    -- os account, not db login
    EXEC sp_xp_cmdshell_proxy_account 'OS Account','Password';  

    -- EXEC sp_xp_cmdshell_proxy_account NULL;  
    -- GO  

    CREATE USER [db_admin] FOR LOGIN [db_admin] WITH DEFAULT_SCHEMA=[dbo]
    GO

    GRANT EXECUTE ON xp_cmdshell TO db_admin
    go

    -- if exec bcp to export data from db, may need to create a db login for os account
    CREATE LOGIN [OS Account] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
    GO
    ```

## Test

```sql
EXEC master..xp_cmdshell 'dir *.exe'
```
