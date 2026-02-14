# Windows Privilege Escalation Enumeration Script

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "WINDOWS PRIVESC ENUMERATION SCRIPT" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Current User
Write-Host "`n[+] Current User Information:" -ForegroundColor Yellow
whoami
Write-Host "User Groups:" -ForegroundColor Yellow
whoami /groups

# System Info
Write-Host "`n[+] System Information:" -ForegroundColor Yellow
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer

# Installed Patches
Write-Host "`n[+] Installed Hotfixes:" -ForegroundColor Yellow
Get-HotFix | Select-Object HotFixID, InstalledOn | Sort-Object InstalledOn -Descending | Select-Object -First 10

# Environment Variables
Write-Host "`n[+] Interesting Environment Variables:" -ForegroundColor Yellow
Get-ChildItem Env: | Where-Object { $_.Name -match "PATH|TEMP|USER|APPDATA" }

# Running Processes
Write-Host "`n[+] Interesting Processes:" -ForegroundColor Yellow
Get-Process | Where-Object { $_.ProcessName -match "admin|backup|service|sql" } | Select-Object ProcessName, Id

# Services
Write-Host "`n[+] Non-standard Services:" -ForegroundColor Yellow
Get-WmiObject win32_service | Where-Object { $_.StartMode -eq "Auto" -and $_.State -eq "Running" } | 
    Select-Object Name, DisplayName, PathName | Select-Object -First 10

# Network
Write-Host "`n[+] Network Connections:" -ForegroundColor Yellow
netstat -an | Select-String "LISTENING" | Select-Object -First 10

# Scheduled Tasks
Write-Host "`n[+] Scheduled Tasks:" -ForegroundColor Yellow
Get-ScheduledTask | Where-Object { $_.State -eq "Ready" } | Select-Object TaskName, State | Select-Object -First 10

Write-Host "`n[+] Enumeration Complete!" -ForegroundColor Green