# Token Abuse Checker

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "TOKEN ABUSE CHECKER" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Check if running with elevated privileges
$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isElevated) {
    Write-Host "`n[!] Running as ADMINISTRATOR!" -ForegroundColor Red
} else {
    Write-Host "`n[*] Running as standard user" -ForegroundColor Yellow
}

# Check for SeImpersonatePrivilege
Write-Host "`n[+] Checking privileges:" -ForegroundColor Yellow
whoami /priv | Select-String "SeImpersonatePrivilege|SeAssignPrimaryTokenPrivilege|SeTcbPrivilege|SeBackupPrivilege|SeRestorePrivilege|SeTakeOwnershipPrivilege|SeDebugPrivilege"

# Check for accessible tokens (simplified)
Write-Host "`n[+] Checking processes with high privileges:" -ForegroundColor Yellow
Get-Process | Where-Object { $_.ProcessName -match "lsass|winlogon|services|svchost" } | 
    Select-Object ProcessName, Id | ForEach-Object {
        Write-Host "  • $($_.ProcessName) (PID: $($_.Id))" -ForegroundColor Gray
    }

Write-Host "`n[+] Check complete!" -ForegroundColor Green