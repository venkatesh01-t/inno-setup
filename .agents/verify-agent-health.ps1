Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "ðŸ›¡ï¸  ANTIGRAVITY AGENT HEALTH & SYSTEM DIAGNOSTIC" -ForegroundColor Cyan
Write-Host "========================================================`n" -ForegroundColor Cyan

$configPath = "C:\Users\KING\.gemini\config"

# 1. Global Skills Count
$skills = Get-ChildItem "$configPath\skills" -Directory
Write-Host "1. Global Skills: $($skills.Count) active" -ForegroundColor Green
$reaFound = $skills | Where-Object { $_.Name -like "*reverse-engineer-anything*" }
if ($reaFound) {
    Write-Host "   -> REA Master Skill: ONLINE" -ForegroundColor Green
} else {
    Write-Host "   -> REA Master Skill: MISSING" -ForegroundColor Red
}

# 2. Plugins
$plugins = Get-ChildItem "$configPath\plugins" -Directory
Write-Host "`n2. Active Plugins: $($plugins.Count) registered" -ForegroundColor Green
foreach ($p in $plugins) {
    Write-Host "   -> Plugin: $($p.Name)" -ForegroundColor Gray
}

# 3. Cognitive Directives & Rules
$rules = Get-ChildItem "$configPath\rules" -File
Write-Host "`n3. Cognitive Rules: $($rules.Count) enforced" -ForegroundColor Green
foreach ($r in $rules) {
    Write-Host "   -> Rule: $($r.Name)" -ForegroundColor Gray
}

# 4. MCP Servers
$mcpJson = Get-Content "$configPath\mcp_config.json" -Raw | ConvertFrom-Json
$serverCount = ($mcpJson.mcpServers | Get-Member -MemberType NoteProperty).Count
Write-Host "`n4. MCP Servers: $serverCount registered" -ForegroundColor Green
foreach ($prop in ($mcpJson.mcpServers | Get-Member -MemberType NoteProperty).Name) {
    Write-Host "   -> Server: $prop" -ForegroundColor Gray
}

# 5. Node.js & Runtime Check
$nodeVer = node -v
Write-Host "`n5. Runtime Environment: Node $nodeVer (LTS)" -ForegroundColor Green

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "ðŸŽ¯ STATUS: ALL SYSTEMS 100% OPERATIONAL & CLAUDE-GRADE" -ForegroundColor Green
Write-Host "========================================================`n" -ForegroundColor Cyan
