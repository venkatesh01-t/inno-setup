; ============================================================================
;  Clinic Manager – Professional Inno Setup Script
;  Generated for Windows 10 / 11 (x64)
;
;  Key design points
;  ─────────────────
;  • PrivilegesRequired=admin  →  single UAC prompt at installer start.
;  • Only TWO files are shipped: updater.exe + the app icon.
;    app.exe is NOT bundled – updater.exe downloads it on first run.
;  • A Windows Scheduled Task (RunLevel=HighestAvailable) is created so
;    shortcuts invoke PowerShell with highest privileges, silently.
;    PowerShell runs an inline -Command (no .ps1 file needed on disk):
;      1. Start updater.exe and wait for it to finish.
;      2. Launch app.exe (now present after the update).
;  • The task is deleted automatically on uninstall.
; ============================================================================

; ── Preprocessor constants ───────────────────────────────────────────────────
#define MyAppName      "Clinic Manager"
#define MyAppVersion   "1.0"
#define MyAppPublisher "My Company, Inc."
#define MyAppURL       "https://www.example.com/"
#define MyTaskName     "ClinicManagerLauncher"
#define MyUpdaterExe   "updater.exe"
#define MyAppExe       "app.exe"
#define MyLauncherIcon "lancher-removebg-preview.ico"
#define MyLauncherScript "launcher.ps1"

; ============================================================================
[Setup]
; ── Identity ─────────────────────────────────────────────────────────────────
; IMPORTANT: Use Tools > Generate GUID to create a fresh GUID for new apps.
AppId={{33DCA6E6-5869-4DB5-9478-3B6F03CCB7A7}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; ── Directories ──────────────────────────────────────────────────────────────
; {autopf} resolves to the appropriate Program Files folder (32- or 64-bit).
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes

; ── Privileges ───────────────────────────────────────────────────────────────
; admin → triggers ONE UAC elevation at the very start of Setup.
; Everything that runs inside the installer already has admin rights.
PrivilegesRequired=admin

; ── Architecture ─────────────────────────────────────────────────────────────
; Require x64-compatible system (x64 or Windows 11 on Arm).
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; ── Appearance ───────────────────────────────────────────────────────────────
WizardStyle=modern

; ── Output ───────────────────────────────────────────────────────────────────
; The final installer will be Output\Setup.exe
OutputBaseFilename=Setup
OutputDir=Output

; ── Compression ──────────────────────────────────────────────────────────────
Compression=lzma2/ultra64
SolidCompression=yes

; ── Uninstall icon ───────────────────────────────────────────────────────────
UninstallDisplayIcon={app}\{#MyLauncherIcon}

; ============================================================================
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; ============================================================================
[Tasks]
; Optional desktop shortcut (unchecked by default – user must opt in).
Name: "desktopicon"; \
  Description: "{cm:CreateDesktopIcon}"; \
  GroupDescription: "{cm:AdditionalIcons}"; \
  Flags: unchecked
Name: "startup"; \
  Description: "Start {#MyAppName} automatically when Windows starts"; \
  GroupDescription: "{cm:AdditionalIcons}"; \
  Flags: unchecked

; ============================================================================
[Files]
; Only TWO files are installed – app.exe is NOT shipped here.
; updater.exe will download app.exe on first launch.
Source: "{#MyUpdaterExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyLauncherIcon}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyLauncherScript}"; DestDir: "{app}"; Flags: ignoreversion

; ============================================================================
[Icons]
; ── Start Menu shortcut ───────────────────────────────────────────────────────
; Runs the Scheduled Task (schtasks /Run) so the app starts silently,
; without showing a PowerShell window, and without another UAC prompt.
Name: "{autoprograms}\{#MyAppName}"; \
  Filename: "schtasks.exe"; \
  Parameters: "/Run /TN ""{#MyTaskName}"""; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Launch {#MyAppName}"

; ── Optional Desktop shortcut ────────────────────────────────────────────────
Name: "{autodesktop}\{#MyAppName}"; \
  Filename: "schtasks.exe"; \
  Parameters: "/Run /TN ""{#MyTaskName}"""; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Launch {#MyAppName}"; \
  Tasks: desktopicon

; ============================================================================
[Run]
; ── Post-install: launch the app once (optional, user can uncheck) ────────────
; We trigger the task rather than launching the script directly so the very
; first run is also hidden and privilege-safe.
Filename: "schtasks.exe"; \
  Parameters: "/Run /TN ""{#MyTaskName}"""; \
  Description: "Launch {#MyAppName} now"; \
  Flags: nowait postinstall skipifsilent

; ============================================================================
[UninstallRun]
; ── Uninstall: delete the Scheduled Task ─────────────────────────────────────
; /F = force delete without confirmation.
; runascurrentuser ensures we run in the uninstaller's already-elevated context.
Filename: "schtasks.exe"; \
  Parameters: "/Delete /TN ""{#MyTaskName}"" /F"; \
  Flags: runascurrentuser waituntilterminated; \
  RunOnceId: "DeleteClinicManagerTask"

; ============================================================================
[Code]
(*
  Pascal Script section
  ─────────────────────
  Handles Scheduled Task creation (post-install) and deletion (post-uninstall).

  Why XML-based creation?
    schtasks /Create /XML gives us full control over every task property,
    especially <Hidden>true</Hidden> and <RunLevel>HighestAvailable</RunLevel>,
    which cannot be set with the simpler schtasks command-line switches alone.
*)

// ── Helper: write a string to a temp file ────────────────────────────────────
function WriteStringToTempFile(const Content: string): string;
var
  TempPath: string;
  Lines: TArrayOfString;
begin
  TempPath := ExpandConstant('{tmp}\task_def.xml');
  SetArrayLength(Lines, 1);
  Lines[0] := Content;
  SaveStringsToFile(TempPath, Lines, False);
  Result := TempPath;
end;

// ── Build the Scheduled Task XML ─────────────────────────────────────────────
// The <Actions> block executes the installed launcher.ps1 script using PowerShell,
// running under the highest privileges available for the logged-on user.
function BuildTaskXml(const AppDir: string; const UseLogonTrigger: Boolean): string;
var
  ScriptPath, PSArguments, TriggersXml: string;
begin
  ScriptPath := AppDir + '\{#MyLauncherScript}';
  PSArguments := '-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + ScriptPath + '"';

  if UseLogonTrigger then
  begin
    TriggersXml :=
      '  <Triggers>'                                                           + #13#10 +
      '    <LogonTrigger>'                                                      + #13#10 +
      '      <Enabled>true</Enabled>'                                           + #13#10 +
      '    </LogonTrigger>'                                                     + #13#10 +
      '  </Triggers>';
  end
  else
  begin
    TriggersXml := '  <Triggers/>';
  end;

  // We use XML so we can set Hidden=true and RunLevel=HighestAvailable
  // exactly as Task Scheduler exposes them in the GUI.
  Result :=
    '<Task version="1.4" '                                                    +
      'xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">'        + #13#10 +

    '  <RegistrationInfo>'                                                    + #13#10 +
    '    <Description>{#MyAppName} launcher - managed by installer</Description>' + #13#10 +
    '    <Author>{#MyAppPublisher}</Author>'                                  + #13#10 +
    '  </RegistrationInfo>'                                                   + #13#10 +

    TriggersXml                                                               + #13#10 +

    '  <Principals>'                                                          + #13#10 +
    '    <Principal id="Author">'                                             + #13#10 +
    // GroupId S-1-5-32-545 = BUILTIN\Users. This allows any logged-on user
    // to run the task in their own session and see the application GUI.
    '      <GroupId>S-1-5-32-545</GroupId>'                                   + #13#10 +
    // HighestAvailable = run with highest available privileges (elevated admin token, no UAC)
    '      <RunLevel>HighestAvailable</RunLevel>'                             + #13#10 +
    '    </Principal>'                                                        + #13#10 +
    '  </Principals>'                                                         + #13#10 +

    '  <Settings>'                                                            + #13#10 +
    '    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>'        + #13#10 +
    '    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>'      + #13#10 +
    '    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>'             + #13#10 +
    '    <AllowHardTerminate>true</AllowHardTerminate>'                       + #13#10 +
    '    <StartWhenAvailable>false</StartWhenAvailable>'                      + #13#10 +
    '    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>'        + #13#10 +
    '    <IdleSettings>'                                                      + #13#10 +
    '      <StopOnIdleEnd>false</StopOnIdleEnd>'                             + #13#10 +
    '      <RestartOnIdle>false</RestartOnIdle>'                              + #13#10 +
    '    </IdleSettings>'                                                     + #13#10 +
    '    <AllowStartOnDemand>true</AllowStartOnDemand>'                      + #13#10 +
    // Hidden=true suppresses the console window when the task fires
    '    <Hidden>true</Hidden>'                                               + #13#10 +
    '    <RunOnlyIfIdle>false</RunOnlyIfIdle>'                                + #13#10 +
    '    <WakeToRun>false</WakeToRun>'                                        + #13#10 +
    '    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>'                       + #13#10 +
    '    <Priority>7</Priority>'                                              + #13#10 +
    '  </Settings>'                                                           + #13#10 +
    '  <Actions Context="Author">'                                            + #13#10 +
    '    <Exec>'                                                              + #13#10 +
    '      <Command>powershell.exe</Command>'                                 + #13#10 +
    '      <Arguments>' + PSArguments + '</Arguments>'                        + #13#10 +
    '    </Exec>'                                                             + #13#10 +
    '  </Actions>'                                                            + #13#10 +
    '</Task>';
end;

// ── Create or replace the Scheduled Task ─────────────────────────────────────
procedure CreateScheduledTask;
var
  AppDir, XmlFile, Params: string;
  ResultCode: Integer;
  UseLogonTrigger: Boolean;
begin
  AppDir  := ExpandConstant('{app}');
  UseLogonTrigger := WizardIsTaskSelected('startup');
  XmlFile := WriteStringToTempFile(BuildTaskXml(AppDir, UseLogonTrigger));

  // Run PowerShell to:
  // 1. Register the scheduled task using the native Register-ScheduledTask cmdlet.
  //    (Get-Content -Raw automatically handles and strips the UTF-8 BOM).
  // 2. Adjust the task's Security Descriptor (ACL) using COM Schedule.Service to grant Read & Execute
  //    permissions to all Authenticated Users (AU). This is required so standard users can invoke the task
  //    via schtasks.exe /Run without getting "Access is denied".
  Params := '-NoProfile -WindowStyle Hidden -Command "try { Register-ScheduledTask -TaskName ''{#MyTaskName}'' -Xml (Get-Content ''' + XmlFile + ''' -Raw -ErrorAction Stop) -Force -ErrorAction Stop; $s = New-Object -ComObject ''Schedule.Service''; $s.Connect(); $t = $s.GetFolder(''\'').GetTask(''{#MyTaskName}''); $sd = $t.GetSecurityDescriptor(0xF); if ($sd -notmatch ''A;;GRGX;;;AU'') { $t.SetSecurityDescriptor($sd + ''(A;;GRGX;;;AU)'', 0) } } catch { exit 1 }"';

  if not Exec(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'), Params, '', SW_HIDE,
              ewWaitUntilTerminated, ResultCode) then
  begin
    MsgBox('Warning: could not launch powershell.exe.'#13#10 +
           'The application shortcut may not work correctly.',
           mbInformation, MB_OK);
  end
  else if ResultCode <> 0 then
  begin
    MsgBox('Warning: Scheduled Task creation failed (exit code: ' +
           IntToStr(ResultCode) + ').'#13#10 +
           'The application shortcut may not work correctly.',
           mbInformation, MB_OK);
  end;

  // Clean up the temporary XML file
  DeleteFile(XmlFile);
end;

// ── Delete the Scheduled Task ─────────────────────────────────────────────────
procedure DeleteScheduledTask;
var
  ResultCode: Integer;
begin
  // /Delete – remove the task; /F – force (no confirmation prompt)
  // Ignore the result code: if the task does not exist that is fine.
  Exec(ExpandConstant('{sys}\schtasks.exe'),
       '/Delete /TN "{#MyTaskName}" /F',
       '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

// ── Install hook ─────────────────────────────────────────────────────────────
// Called at each major step of installation.  We act on ssPostInstall so that
// all files are guaranteed to be on disk before we create the task.
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    CreateScheduledTask;
end;

// ── Uninstall hook ────────────────────────────────────────────────────────────
// Called at each step of uninstallation.  usPostUninstall fires after the
// files have been removed but while we still have elevated rights.
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    DeleteScheduledTask;
end;
