# Log Shipping Troubleshooting

## 1. Validate Log Shipping Status

### 1.1 Secondary database

The simplest way to check if log shipping work normally is to execute the following sql every 5 mins(log shipping backup/restore intervals are 5 min) on secondary database, and to see if the [redo_start_lsn] of the result grows. Growing means ok. If it doesn't grow, there may be something wrong with it.

	select d.name database_name, f.redo_start_lsn, f.database_id
	  from sys.master_files f, sys.databases d
	 where f.database_id=d.database_id 
	   and f.redo_start_lsn is not null;

## 2. Trouble Shooting

### 2.1 Primary database(check backup job)

Running following sql to see if last\_backup\_file exists, and last\_backup\_date is within 15mins(2~3 backup intervals)

	select * from msdb.dbo.log_shipping_monitor_primary;

![](Pics/Snipaste_2019-12-11_15-14-05.png)

if not, please check the backup job named starting with LSBACKUP_XXx running log to see if there are something errors.

![](Pics/Snipaste_2019-12-11_15-18-20.png)

### 2.2 Secondary database

Running following sqls to see if last\_copied\_date/last\_restored\_date are within 15mins(2~3 backup intervals)

	select * from msdb.dbo.log_shipping_monitor_secondary;
	select * from msdb.dbo.log_shipping_monitor_error_detail;


![](Pics/Snipaste_2019-12-11_15-11-46.png)

if not, please check the backup job named starting with LSCopy/LSRestore_XX running log to see if there are something errors.

![](Pics/Snipaste_2019-12-19_16-06-42.png)
