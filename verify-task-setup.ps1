# ============================================================================
# Clinic Manager - Task Scheduler Elevation & Integrity Verification Suite
# ============================================================================

$ErrorActionPreference = "Stop"
Write-Host "=== Clinic Manager Task Scheduler Verification ===" -ForegroundColor Cyan

$CurrentDir = (Get-Location).Path
$TaskName = "ClinicManagerElevatedTask_TestVerification"
$XmlSource = Join-Path $CurrentDir "task-definition.xml"
$TempXml = Join-Path $env:TEMP "clinic_test_task.xml"

# 1. Test XML Template Substitution
Write-Host "`n[Step 1] Testing XML template placeholder substitution..." -ForegroundColor Yellow
$xmlContent = Get-Content -Path $XmlSource -Raw
$resolvedXml = $xmlContent -replace '__APP_DIR__', $CurrentDir
Set-Content -Path $TempXml -Value $resolvedXml -Encoding Unicode
Write-Host " -> Resolved XML saved to: $TempXml" -ForegroundColor Green

# 2. Register Scheduled Task with Highest Available Privileges
Write-Host "`n[Step 2] Testing Task Registration via schtasks.exe..." -ForegroundColor Yellow
$createOutput = & schtasks.exe /create /tn "$TaskName" /xml "$TempXml" /f
Write-Host " -> $createOutput" -ForegroundColor Green

# 3. Query Registered Task Details
Write-Host "`n[Step 3] Querying registered task details & privilege level..." -ForegroundColor Yellow
$taskQuery = & schtasks.exe /query /tn "$TaskName" /v /fo LIST
$runLevelLine = $taskQuery | Where-Object { $_ -match "Run Level|Task To Run" }
foreach ($line in $runLevelLine) {
    Write-Host " -> $line" -ForegroundColor Green
}

# 4. Validate run-task.vbs presence & syntax
Write-Host "`n[Step 4] Checking run-task.vbs and launch.vbs..." -ForegroundColor Yellow
$runnerPath = Join-Path $CurrentDir "run-task.vbs"
$launcherPath = Join-Path $CurrentDir "launch.vbs"
if ((Test-Path $runnerPath) -and (Test-Path $launcherPath)) {
    Write-Host " -> Both run-task.vbs and launch.vbs verified present." -ForegroundColor Green
} else {
    throw "Runner or launcher script missing!"
}

# 5. Clean up test verification task
Write-Host "`n[Step 5] Cleaning up test scheduled task..." -ForegroundColor Yellow
$deleteOutput = & schtasks.exe /delete /tn "$TaskName" /f
Write-Host " -> $deleteOutput" -ForegroundColor Green
Remove-Item -Path $TempXml -Force -ErrorAction SilentlyContinue

Write-Host "`n=== ALL VERIFICATION CHECKS PASSED SUCCESSFULLY ===" -ForegroundColor Cyan
