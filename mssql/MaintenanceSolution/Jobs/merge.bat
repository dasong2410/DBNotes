type "CommandLog Cleanup.sql"                       > Dest\A-WithLog.sql
type "DatabaseBackup - USER_DATABASES - FULL.sql"  >> Dest\A-WithLog.sql
type "DatabaseBackup - USER_DATABASES - LOG.sql"   >> Dest\A-WithLog.sql
type "Output File Cleanup.sql"                     >> Dest\A-WithLog.sql
type "sp_delete_backuphistory.sql"                 >> Dest\A-WithLog.sql
type "sp_purge_jobhistory.sql"                     >> Dest\A-WithLog.sql

type "CommandLog Cleanup.sql"                       > Dest\A-WithoutLog.sql
type "DatabaseBackup - USER_DATABASES - FULL.sql"  >> Dest\A-WithoutLog.sql
type "Output File Cleanup.sql"                     >> Dest\A-WithoutLog.sql
type "sp_delete_backuphistory.sql"                 >> Dest\A-WithoutLog.sql
type "sp_purge_jobhistory.sql"                     >> Dest\A-WithoutLog.sql

pause
