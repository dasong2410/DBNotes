-- Primary
exec master.dbo.CreateLogshippingDirs 'C:\Logshipping'
exec master.dbo.CreateDBInitBackups 'C:\Logshipping'
exec master.dbo.DeployLogshipping 'C:\Logshipping', '10.213.20.18', '10.213.20.38'

exec LogshippingClean '10.213.20.38'

-- Secondary
exec RestoreLogshippingDBs '10.213.20.18'
exec CreateLogshippingDirs 'C:\LogShipping'
exec DeployLogshippingSecondary '10.213.20.18', '10.213.20.38'

exec LogshippingClean
