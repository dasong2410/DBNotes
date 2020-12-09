type Both-DBAUtl.sql P-01-Config.sql P-02-CreateLogshippingDirs.sql P-03-CreateDBInitBackup.sql P-04-DeployLogshipping.sql P-99-LogshippingClean.sql > Dest\P-All.sql

type Both-DBAUtl.sql S-01-RestoreLogshippingDBs.sql S-02-CreateLogshippingDirs.sql S-03-DeployLogshipping.sql S-99-LogshippingClean.sql > Dest\S-All.sql

pause
