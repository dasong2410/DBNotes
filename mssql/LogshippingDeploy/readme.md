
## **Logshipping Deploy**

## **Primary Server**

### 1. Create logshipping root dir and make it shared on Primary Server

    D:\Logshipping

### 2. Config logshipping metadata table

    Execute P-01-Config.sql, set up logshipping metadata

### 3. Create dirs for logshipping

```sql
exec master.dbo.CreateLogshippingDirs 'D:\Logshipping'
```

### 4. Backup databases

```sql
exec master.dbo.CreateDBInitBackups 'D:\Logshipping'
```

### 5. Config databases

```sql
exec master.dbo.DeployLogshipping 'D:\Logshipping', 'PrimaryServer', 'SecondaryServer'
```

## **Secondary Server**

### 1. Create logshipping root dir and make it shared on Secondary Server

    D:\Logshipping

### 2. Restore databases

```sql
exec RestoreLogshippingDBs 'PrimaryServer'
```

### 3. Create dirs for logshipping

```sql
exec CreateLogshippingDirs 'D:\LogShipping'
```

### 4. Config databases

```sql
exec DeployLogshippingSecondary 'PrimaryServer', 'SecondaryServer'
```
