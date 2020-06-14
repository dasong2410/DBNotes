# Log Shipping

## 1. Shared directory structure

	X:\Logshipping\[database_name]

## 2. LSN check

	select d.name database_name, f.redo_start_lsn, f.*
	  from sys.master_files f, sys.databases d
	 where f.database_id=d.database_id 
	   and f.redo_start_lsn is not null;

#
	-- restore lsn info from transaction log
	RESTORE HEADERONLY FROM DISK = N'D:\LogShipping\Applecare_Arc\Applecare_Arc_20191203014000.trn';

## 3. Check recovery mode

	SELECT secondary_database,
	       restore_mode,
	       disconnect_users,
	       last_restored_file
	  FROM msdb.dbo.log_shipping_secondary_databases;

## 4. Switch recovery mode

### 4.1 To norecovery mode
	EXEC sp_change_log_shipping_secondary_database
	  @secondary_database = 'TSecure',
	  @restore_mode = 0,
	  @disconnect_users = 0;
	
### 4.2 To standby/readonly mode

	EXEC sp_change_log_shipping_secondary_database
	  @secondary_database = 'Applecare_Prod',
	  @restore_mode = 1,
	  @disconnect_users = 1;

## 5. Check status

	-- primary database
	select * from msdb.dbo.log_shipping_primary_databases;
	select * from msdb.dbo.log_shipping_primary_secondaries;
	select * from msdb.dbo.log_shipping_monitor_primary;
	
	-- secondary database
	select * from msdb.dbo.log_shipping_secondary;
	select * from msdb.dbo.log_shipping_monitor_secondary;
	select * from msdb.dbo.log_shipping_monitor_alert;
	select * from msdb.dbo.log_shipping_monitor_error_detail order by log_time desc;
