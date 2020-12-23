type Both-DBAUtl.sql                   > Dest\P-All.sql
type P-01-Config.sql                  >> Dest\P-All.sql
type P-02-CreateLogshippingDirs.sql   >> Dest\P-All.sql
type P-03-CreateDBInitBackup.sql      >> Dest\P-All.sql
type P-04-DeployLogshipping.sql       >> Dest\P-All.sql
type P-99-LogshippingClean.sql        >> Dest\P-All.sql

type Both-DBAUtl.sql                   > Dest\S-All.sql
type S-01-RestoreLogshippingDBs.sql   >> Dest\S-All.sql
type S-02-CreateLogshippingDirs.sql   >> Dest\S-All.sql
type S-03-DeployLogshipping.sql       >> Dest\S-All.sql
type S-99-LogshippingClean.sql        >> Dest\S-All.sql

pause
