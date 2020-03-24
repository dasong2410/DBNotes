# Windows Commands

### 1. Hardware info

	run -> msinfo32

### 2. show shared directories connections

	cmd -> net use

### 3. show shared directories

	cmd -> net share

### 4. wmi

	PowerShell -> Get-WmiObject -Query "Select * from win32_bios"

### 5. reboot remote server

	gwmi win32_operatingsystem -ComputerName xxxxxxxxxxxx | Invoke-WmiMethod -Name reboot
