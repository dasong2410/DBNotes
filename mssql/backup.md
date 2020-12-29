# SQL [Encrypted] Server Backup

<a name="Table of contents"></a>
## Table of contents

1. [Master key and certificate](#1-Master-key-and-certificate)
2. [Backup](#2-Backup)
3. [Copy backup to remote server](#3-Copy-backup-to-remote-server)
4. [Restore encrypted database backup](#4-Restore-encrypted-database-backup)

<a href="1-Master-key-and-certificate"></a>
## [1. Master key and certificate](#Table-of-contents)

### 1.1 Create master key and certificate

	USE master;  
	GO  
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123456';  
	GO  
	
	Use Master  
	GO  
	CREATE CERTIFICATE HRDBBackupEncryptCert  
	WITH SUBJECT = 'HRDB Backup Encryption Certificate';
	GO

### 1.2 Backup master key and certificate

	BACKUP MASTER KEY TO FILE = 'C:\MSSQL_BACKUP\HRDBBackupEncryptMasterKey' ENCRYPTION BY PASSWORD = '123456';
	BACKUP CERTIFICATE HRDBBackupEncryptCert TO FILE = 'C:\MSSQL_BACKUP\HRDBBackupEncryptCert'
	WITH PRIVATE KEY
	(
	  FILE ='C:\MSSQL_BACKUP\HRDBBackupEncryptCert.pvt',
	  ENCRYPTION BY PASSWORD ='123456'
	);

### 1.3 Drop master key and certificate

	DROP CERTIFICATE HRDBBackupEncryptCert;
	DROP MASTER KEY;

### 1.4 Restore master key and certificate

	RESTORE MASTER KEY FROM FILE = 'C:\MSSQL_BACKUP\HRDBBackupEncryptMasterKey'
	DECRYPTION BY PASSWORD = '123456'  
	ENCRYPTION BY PASSWORD = '123456';

	CREATE CERTIFICATE HRDBBackupEncryptCert FROM FILE = 'C:\MSSQL_BACKUP\HRDBBackupEncryptCert'
	WITH PRIVATE KEY
	(
	  FILE = 'C:\MSSQL_BACKUP\HRDBBackupEncryptCert.pvt',   
	  DECRYPTION BY PASSWORD = '123456'
	);

### 1.5 Open/Close master key

	OPEN MASTER KEY DECRYPTION BY PASSWORD = '123456';
	CLOSE MASTER KEY;

<a name="2-Backup"></a>
## [2. Backup](#Table-of-contents)

### 2.1 Backup without encryption

	EXECUTE [dbo].[DatabaseBackup]
	@Databases = 'USER_DATABASES',
	@Directory = 'D:\MSSQL_BACKUP',
	@BackupType = 'FULL',
	@Verify = 'Y',
    @Compress = 'Y',
	@CleanupTime = 72,
	@CheckSum = 'Y',
	@LogToTable = 'Y'

	EXECUTE [dbo].[DatabaseBackup]
	@Databases = 'USER_DATABASES',
	@Directory = 'D:\MSSQL_BACKUP',
	@BackupType = 'LOG',
	@Verify = 'Y',
    @Compress = 'Y',
	@CleanupTime = 72,
	@CheckSum = 'Y',
	@LogToTable = 'Y'

### 2.1 Backup with encryption

	<1>. Create master key if not exist
	<2>. Create certificate if not exist
	<3>. Backup database

		EXECUTE [dbo].[DatabaseBackup]
		@Databases = 'USER_DATABASES',
		@Directory = 'D:\MSSQL_BACKUP',
		@BackupType = 'FULL',
		@Verify = 'Y',
	    @Compress = 'Y',
		@CleanupTime = 72,
		@CheckSum = 'Y',
		@Encrypt = 'Y',
		@EncryptionAlgorithm = 'AES_256',
		@ServerCertificate = 'HRDBBackupEncryptCert',
		@LogToTable = 'Y'

<a name="3-Copy-backup-to-remote-server"></a>
## [3. Copy backup to remote server](#Table-of-contents)

Run the following python script in a SQL Server Job step after backup. This python script need a parameter(FULL or LOG) to decide backup database or log.

	D:\DBA\Apps\DBBackupCopy\venv\Scripts\python.exe D:\DBA\Apps\DBBackupCopy\DBBackupCopy.py [FULL|LOG] $(ESCAPE_SQUOTE(INST))
	
	SET EXITCODE = %ERRORLEVEL% 
	IF %EXITCODE% EQ 0 ( 
	   REM Database Backup copy is successful
	   EXIT 0
	)
	IF %EXITCODE% EQ 1 (
	   REM Database Backup copy is failed
	   EXIT 1
	)

<a name="4-Restore-encrypted-database-backup"></a>
## [4. Restore encrypted database backup](#Table-of-contents)

	<1>. Create master key if not exist
	<2>. Restore certificate
	<3>. Restore database
