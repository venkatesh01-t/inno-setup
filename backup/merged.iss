; ============================================================================
;  Clinic Manager – Professional Inno Setup Installer Script
;  Standard Windows UAC Compliance Edition
; ============================================================================
;  Features & Security Architecture:
;  ---------------------------------
;  • Native UAC Elevation: Uses PrivilegesRequired=admin with standard Windows
;    UAC elevation prompts. No security bypass hacks or Task Scheduler tricks.
;  • Workflow Preserved: Installs launcher.ps1, updater.exe, and icon assets.
;    updater.exe manages app.exe download/updates upon launch.
;  • Prevent Running Installation: AppMutex & Pascal process detection verify
;    updater.exe and app.exe are closed before install/uninstall.
;  • Shortcuts: Start Menu & optional Desktop shortcuts launch PowerShell
;    in hidden window mode with ExecutionPolicy Bypass.
;  • Professional Features: Modern Wizard design, EULA License page, 64-bit mode,
;    LZMA2 ultra solid compression, setup event logging, silent install support,
;    App Paths registry integration, and uninstaller support.
; ============================================================================

; ── Preprocessor Definitions ────────────────────────────────────────────────
#define MyAppName        "Clinic Manager"
#define MyAppVersion     "1.0.0"
#define MyAppPublisher   "My Company, Inc."
#define MyAppURL         "https://www.example.com/"
#define MyUpdaterExe     "updater.exe"
#define MyAppExe         "app.exe"
#define MyLauncherIcon   "lancher-removebg-preview.ico"
#define MyLicenseFile    "license.txt"
#define MyVbsLauncher    "launch.vbs"

; ============================================================================
[Setup]
; ── Application Identity ────────────────────────────────────────────────────
AppId={{33DCA6E6-5869-4DB5-9478-3B6F03CCB7A7}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; ── Target Directory & Privileges ───────────────────────────────────────────
; Installs to standard Program Files folder for 64-bit Windows
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=commandline

; ── Architecture ─────────────────────────────────────────────────────────────
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; ── Modern Wizard Appearance & EULA License ─────────────────────────────────
WizardStyle=modern
SetupIconFile={#MyLauncherIcon}
LicenseFile={#MyLicenseFile}
UninstallDisplayIcon={app}\{#MyLauncherIcon}

; ── Output & Compression ─────────────────────────────────────────────────────
OutputBaseFilename=ClinicManager_Setup
OutputDir=Output
Compression=lzma2/ultra64
SolidCompression=yes

; ── Event Logging & Process Mutex Protection ─────────────────────────────────
SetupLogging=yes
AppMutex=ClinicManagerAppMutex,ClinicManagerUpdaterMutex

; ── Version Information Metadata ────────────────────────────────────────────
VersionInfoVersion=1.0.0.0
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} Setup
VersionInfoCopyright=Copyright (C) 2026 {#MyAppPublisher}
VersionInfoProductVersion=1.0.0.0

; ============================================================================
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; ============================================================================
[Tasks]
Name: "desktopicon"; \
  Description: "{cm:CreateDesktopIcon}"; \
  GroupDescription: "{cm:AdditionalIcons}"; \
  Flags: unchecked
Name: "autostartup"; \
  Description: "Automatically start {#MyAppName} on Windows startup"; \
  GroupDescription: "{cm:AdditionalIcons}"; \
  Flags: unchecked

; ============================================================================
[Dirs]
; Grant Full Control permissions on installation folder to allow updater.exe to manage app.exe
Name: "{app}"; Permissions: users-full

; ============================================================================
[Files]
Source: "{#MyUpdaterExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyLauncherIcon}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyLicenseFile}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyVbsLauncher}"; DestDir: "{app}"; Flags: ignoreversion

; ============================================================================
[Icons]
; ── Start Menu Shortcut (Silent launch via WScript with 0 console window flash) ──
Name: "{autoprograms}\{#MyAppName}"; \
  Filename: "{sys}\wscript.exe"; \
  Parameters: """{app}\{#MyVbsLauncher}"""; \
  WorkingDir: "{app}"; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Launch {#MyAppName}"

; ── Optional Desktop Shortcut ────────────────────────────────────────────────
Name: "{autodesktop}\{#MyAppName}"; \
  Filename: "{sys}\wscript.exe"; \
  Parameters: """{app}\{#MyVbsLauncher}"""; \
  WorkingDir: "{app}"; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Launch {#MyAppName}"; \
  Tasks: desktopicon

; ── Optional Windows Auto-Startup Shortcut ────────────────────────────────────
Name: "{autostartup}\{#MyAppName}"; \
  Filename: "{sys}\wscript.exe"; \
  Parameters: """{app}\{#MyVbsLauncher}"""; \
  WorkingDir: "{app}"; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Auto-start {#MyAppName} on Windows startup"; \
  Tasks: autostartup

; ============================================================================
[Registry]
; Standard App Paths registration for Windows Command Prompt / Run Dialog
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\App Paths\ClinicManager.exe"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyUpdaterExe}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\App Paths\ClinicManager.exe"; ValueType: string; ValueName: "Path"; ValueData: "{app}"; Flags: uninsdeletekey

; ============================================================================
[Run]
; Launch application option upon installation completion (0 console window flash)
Filename: "{sys}\wscript.exe"; \
  Parameters: """{app}\{#MyVbsLauncher}"""; \
  WorkingDir: "{app}"; \
  Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; \
  Flags: nowait postinstall skipifsilent

; ============================================================================
[Code]
// ── Helper: Check if a specific process is currently running ────────────────
function IsProcessRunning(const ExecutableName: string): Boolean;
var
  ResultCode: Integer;
  TempFile, CmdArgs: string;
  OutputLines: TArrayOfString;
begin
  Result := False;
  TempFile := ExpandConstant('{tmp}\proc_check_' + ExecutableName + '.txt');
  CmdArgs := '/C tasklist /FI "IMAGENAME eq ' + ExecutableName + '" /NH > "' + TempFile + '"';

  if Exec(ExpandConstant('{cmd}'), CmdArgs, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
  begin
    if LoadStringsFromFile(TempFile, OutputLines) then
    begin
      if (GetArrayLength(OutputLines) > 0) and (Pos(Lowercase(ExecutableName), Lowercase(OutputLines[0])) > 0) then
      begin
        Result := True;
      end;
    end;
    DeleteFile(TempFile);
  end;
end;

// ── Check processes before starting installation ────────────────────────────
function InitializeSetup(): Boolean;
begin
  Result := True;

  if IsProcessRunning('{#MyUpdaterExe}') or IsProcessRunning('{#MyAppExe}') then
  begin
    MsgBox('{#MyAppName} or its updater is currently running.' + #13#10 + #13#10 +
           'Please close all instances of {#MyAppName} before continuing with installation.',
           mbError, MB_OK);
    Result := False;
  end;
end;

// ── Check processes before uninstallation ───────────────────────────────────
function InitializeUninstall(): Boolean;
begin
  Result := True;

  if IsProcessRunning('{#MyUpdaterExe}') or IsProcessRunning('{#MyAppExe}') then
  begin
    MsgBox('{#MyAppName} or its updater is currently running.' + #13#10 + #13#10 +
           'Please close all instances of {#MyAppName} before proceeding with uninstallation.',
           mbError, MB_OK);
    Result := False;
  end;
end;
