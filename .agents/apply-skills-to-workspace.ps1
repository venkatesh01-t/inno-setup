<#
.SYNOPSIS
    Links all 226+ Antigravity skills, REA reverse-engineering suite, and cognitive rules into any project or workspace folder.
.EXAMPLE
    .\apply-skills-to-workspace.ps1 -TargetDir "D:\MyProject"
#>
param(
    [string]$TargetDir = (Get-Location).Path
)

$GlobalConfig = "C:\Users\KING\.gemini\config"
$TargetAgents = Join-Path $TargetDir ".agents"

Write-Host "ðŸš€ Applying 226+ Antigravity skills & REA Suite to: $TargetDir" -ForegroundColor Cyan

if (Test-Path $TargetAgents) {
    Write-Host "âš ï¸ .agents folder already exists in $TargetDir. Refreshing junction..." -ForegroundColor Yellow
    cmd /c rmdir "$TargetAgents" 2>$null
}

cmd /c mklink /J "$TargetAgents" "$GlobalConfig"

if (Test-Path $TargetAgents) {
    $skillsCount = (Get-ChildItem (Join-Path $TargetAgents "skills") -Directory).Count
    Write-Host "âœ… SUCCESS! All $skillsCount skills, REA tools, and rules are now linked to $TargetDir\.agents" -ForegroundColor Green
} else {
    Write-Host "âŒ Failed to create link. Please run as Administrator if needed." -ForegroundColor Red
}
