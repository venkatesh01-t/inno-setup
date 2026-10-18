' ============================================================================
' Clinic Manager - High-Privilege Task Trigger & Fallback Runner
' Executes registered elevated Task Scheduler job with ZERO UAC prompt
' Falls back seamlessly to direct launch.vbs if task is unavailable
' ============================================================================
Option Explicit

Dim fso, wshShell, scriptDir, taskName, runCmd, exitCode, fallbackPath

Set fso = CreateObject("Scripting.FileSystemObject")
Set wshShell = CreateObject("WScript.Shell")

scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
taskName = "ClinicManagerElevatedTask"
fallbackPath = scriptDir & "\launch.vbs"

' Execute scheduled task via schtasks /run (0 = Hidden window, True = wait for exit code)
runCmd = "schtasks.exe /run /tn """ & taskName & """"
On Error Resume Next
exitCode = wshShell.Run(runCmd, 0, True)
On Error GoTo 0

' If task was triggered successfully (exit code 0), we are done!
' If it failed (e.g. task was deleted or service stopped), launch fallback
If exitCode <> 0 Then
    If fso.FileExists(fallbackPath) Then
        wshShell.Run "wscript.exe """ & fallbackPath & """", 0, False
    End If
End If
