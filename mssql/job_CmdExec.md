## Run non-syadmin's job step as CmdExec

https://dbtut.com/index.php/2018/10/10/run-your-jobs-with-a-proxy-account/

1. Create credential
2. Create Proxy
3. Ignore others in this web page
4. May need to exec following sql to grant proxy

    ```sql
    USE msdb ;  
    GO

    -- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-grant-login-to-proxy-transact-sql?view=sql-server-ver15
    EXEC dbo.sp_grant_login_to_proxy  
        @login_name = N'adventure-works\terrid',  
        @proxy_name = N'Catalog application proxy' ;  
    GO
    ```
