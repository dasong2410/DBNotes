## Logshipping Issues

### 1. 用户权限

Log On As 的用户权限不对的话msdb.dbo.log\_shipping\_monitor\_error\_detail 中会出现以下错误，数据同步失败，最好使用安装sql server时用的os账号

	Could not delete old log backup files.	Microsoft.SqlServer.Management.LogShipping
	Access to the path '\\10.213.155.221\LogShipping\Applecare_Prod' is denied.	mscorlib
	Access to the path '\\10.213.155.221\LogShipping\Applecare_Prod' is denied.	Mscorlib


### 2. No backup of current database

You can't do logshipping on a database with simple recovery mode. Have to transfer it to full/bulk-logged mode first, and then do a full backup. Otherwise you'll get the following error:

	Message
	2019-12-10 16:05:00.41	Starting transaction log backup. Primary ID: '95568d0c-0dca-4e61-8236-eeca79c0fa51'
	2019-12-10 16:05:00.41	Retrieving backup settings. Primary ID: '95568d0c-0dca-4e61-8236-eeca79c0fa51'
	2019-12-10 16:05:00.41	Retrieved backup settings. Primary Database: 'TSecure', Backup Directory: 'D:\LogShipping\TSecure', Backup Retention Period: 4320 minute(s), Backup Compression: Enabled
	2019-12-10 16:05:00.43	Backing up transaction log. Primary Database: 'TSecure', Log Backup File: 'D:\LogShipping\TSecure\TSecure_20191210070500.trn'
	2019-12-10 16:05:00.44	First attempt to backup database 'TSecure' to file 'D:\LogShipping\TSecure\TSecure_20191210070500.trn' failed because BACKUP LOG cannot be performed because there is no current database backup.
	2019-12-10 16:05:00.44	Backup file 'D:\LogShipping\TSecure\TSecure_20191210070500.trn' does not exist
	2019-12-10 16:05:00.44	Retry backup database 'TSecure' to file 'D:\LogShipping\TSecure\TSecure_20191210070500.trn'
	2019-12-10 16:05:00.44	*** Error: Backup failed for Server 'APLACSVR1KR'. (Microsoft.SqlServer.SmoExtended) ***
	2019-12-10 16:05:00.44	*** Error: An exception occurred while executing a Transact-SQL statement or batch.(Microsoft.SqlServer.ConnectionInfo) ***
	2019-12-10 16:05:00.44	*** Error: BACKUP LOG cannot be performed because there is no current database backup.
	BACKUP LOG is terminating abnormally.(.Net SqlClient Data Provider) ***
	2019-12-10 16:05:00.46	----- END OF TRANSACTION LOG BACKUP   -----
	
	Exit Status: 1 (Error)
