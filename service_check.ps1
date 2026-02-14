# Windows Service Misconfiguration Checker

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "SERVICE MISCONFIGURATION CHECKER" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

$services = Get-WmiObject win32_service | Where-Object { $_.StartMode -eq "Auto" }

Write-Host "`n[+] Checking $($services.Count) services..." -ForegroundColor Yellow

foreach ($service in $services) {
    $vulnerable = $false
    $issues = @()
    
    # Check unquoted service paths
    if ($service.PathName -notmatch '^".*"' -and $service.PathName -match ' ') {
        $issues += "Unquoted service path"
        $vulnerable = $true
    }
    
    # Check weak permissions (simplified)
    if ($service.PathName -match 'ProgramData|Temp|Users') {
        $issues += "Potentially weak permissions"
        $vulnerable = $true
    }
    
    if ($vulnerable) {
        Write-Host "`n  [!] $($service.Name)" -ForegroundColor Red
        Write-Host "      Path: $($service.PathName)" -ForegroundColor Gray
        Write-Host "      Issues: $($issues -join ', ')" -ForegroundColor Yellow
    }
}

Write-Host "`n[+] Check complete!" -ForegroundColor Green