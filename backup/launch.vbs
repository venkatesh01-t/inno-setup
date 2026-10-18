' ============================================================================
' Clinic Manager - Silent VBScript App & Updater Launcher
' Purpose: Executes updater.exe & app.exe silently with ZERO UAC prompts
' Ensures app.exe opens exactly ONCE (prevents duplicate instances)
' ============================================================================
Dim fso, wshShell, shellApp, scriptDir, updaterPath, appPath

Set fso = CreateObject("Scripting.FileSystemObject")
Set wshShell = CreateObject("WScript.Shell")
Set shellApp = CreateObject("Shell.Application")

scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
updaterPath = scriptDir & "\updater.exe"
appPath = scriptDir & "\app.exe"

' ── Helper: Check if process is running via WMI (No cmd.exe window) ──────────
Function IsProcessRunning(exeName)
    Dim wmi, colProcesses
    On Error Resume Next
    Set wmi = GetObject("winmgmts:\\.\root\cimv2")
    Set colProcesses = wmi.ExecQuery("SELECT Name FROM Win32_Process WHERE Name = '" & exeName & "'")
    IsProcessRunning = (colProcesses.Count > 0)
    On Error GoTo 0
End Function

' ── 1. Run updater.exe silently in hidden mode (0) if present ────────────────
If fso.FileExists(updaterPath) Then
    shellApp.ShellExecute updaterPath, "", scriptDir, "open", 0

    ' Wait for updater.exe process to complete silently
    WScript.Sleep 1500
    Do While IsProcessRunning("updater.exe")
        WScript.Sleep 1000
    Loop
End If

' ── 2. Launch main app.exe ONLY if it is not already running ─────────────────
WScript.Sleep 500
If fso.FileExists(appPath) And Not IsProcessRunning("app.exe") Then
    shellApp.ShellExecute appPath, "", scriptDir, "open", 1
End If
