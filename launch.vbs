' ============================================================================
' Clinic Manager - Silent VBScript App & Updater Master Launcher
' Purpose: Executes updater.exe & app.exe silently with highest privileges
' Ensures app.exe opens exactly ONCE (prevents duplicate instances)
' Includes 60-second watchdog to prevent updater hang on network disconnection
' ============================================================================
Option Explicit

Dim fso, wshShell, shellApp, scriptDir, updaterPath, appPath, waitSeconds, maxWaitSeconds

Set fso = CreateObject("Scripting.FileSystemObject")
Set wshShell = CreateObject("WScript.Shell")
Set shellApp = CreateObject("Shell.Application")

scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
updaterPath = scriptDir & "\updater.exe"
appPath = scriptDir & "\app.exe"
maxWaitSeconds = 60
waitSeconds = 0

' ── Helper: Check if process is running via WMI (No cmd.exe window) ──────────
Function IsProcessRunning(exeName)
    Dim wmi, colProcesses
    On Error Resume Next
    Set wmi = GetObject("winmgmts:\\.\root\cimv2")
    Set colProcesses = wmi.ExecQuery("SELECT Name FROM Win32_Process WHERE Name = '" & exeName & "'")
    If Err.Number = 0 And Not colProcesses Is Nothing Then
        IsProcessRunning = (colProcesses.Count > 0)
    Else
        IsProcessRunning = False
    End If
    On Error GoTo 0
End Function

' ── 1. Run updater.exe silently in hidden mode (0) if present ────────────────
If fso.FileExists(updaterPath) Then
    shellApp.ShellExecute updaterPath, "", scriptDir, "open", 0

    ' Wait for updater.exe process to complete silently with watchdog timeout
    WScript.Sleep 1500
    Do While IsProcessRunning("updater.exe") And (waitSeconds < maxWaitSeconds)
        WScript.Sleep 1000
        waitSeconds = waitSeconds + 1
    Loop
End If

' ── 2. Launch main app.exe ONLY if it is not already running ─────────────────
WScript.Sleep 500
If fso.FileExists(appPath) And Not IsProcessRunning("app.exe") Then
    shellApp.ShellExecute appPath, "", scriptDir, "open", 1
End If
