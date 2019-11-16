-- backup set
select database_name, family_guid, backup_size, compressed_backup_size, backup_start_date, backup_finish_date, type
from (
         select database_name,
                family_guid,
                backup_size,
                compressed_backup_size,
                backup_start_date,
                backup_finish_date,
                type,
                ROW_NUMBER() over (partition by database_name, family_guid, type order by backup_start_date desc) rn
         from msdb.dbo.backupset) x1
where x1.rn < 4
order by family_guid, type, backup_start_date;

select database_name, family_guid, backup_size, compressed_backup_size, backup_start_date, backup_finish_date, type
from (
         select database_name,
                family_guid,
                backup_size,
                compressed_backup_size,
                backup_start_date,
                backup_finish_date,
                type,
                row_number() over (partition by database_name, family_guid, type order by backup_start_date desc) rn
         from msdb.dbo.backupset) x1
where x1.rn < 4
order by family_guid, type, backup_start_date;
