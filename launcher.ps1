#Requires -Version 5.1
<#
.SYNOPSIS
    Launcher script for Clinic Manager.
    Runs updater.exe (waiting for it to finish) then launches app.exe.

.NOTES
    This script is invoked by the Windows Scheduled Task created during installation.
    The Scheduled Task is configured with RunLevel=HighestAvailable so it already
    runs with the highest available privileges for the current user - no extra UAC
    prompt appears and PowerShell inherits those privileges automatically.

    Execution flow
    --------------
    1. Run updater.exe and WAIT for it to complete.
       updater.exe is responsible for downloading app.exe on the first launch.
    2. After updater finishes, launch app.exe if it now exists.

    Both executables are expected to live in the same directory as this script.
#>

# -- Resolve paths relative to the script's own directory ---------------------
$scriptDir   = $PSScriptRoot
$updaterPath = Join-Path $scriptDir 'updater.exe'
$appPath     = Join-Path $scriptDir 'app.exe'

# -- Run updater and WAIT for completion before doing anything else -------------
# Start-Process -Wait correctly blocks until the child process exits.
# The script already runs elevated (via the Scheduled Task), so updater.exe
# inherits the same elevated token - no UAC prompt will appear.
if (Test-Path $updaterPath) {
    try {
        $proc = Start-Process -FilePath $updaterPath `
                              -WorkingDirectory $scriptDir `
                              -PassThru `
                              -Wait `
                              -ErrorAction Stop
    } catch {
        Write-Warning "Failed to start updater.exe: $_"
    }
} else {
    Write-Warning "updater.exe not found at: $updaterPath"
}

# -- Launch the main application (downloaded by updater) -----------------------
# app.exe may not have existed before; check again after updater has run.
if (Test-Path $appPath) {
    try {
        Start-Process -FilePath $appPath `
                      -WorkingDirectory $scriptDir `
                      -ErrorAction Stop
    } catch {
        Write-Warning "Failed to start app.exe: $_"
    }
} else {
    Write-Warning "app.exe not found at: $appPath - updater may have failed to download it."
}
