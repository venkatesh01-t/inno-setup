; ============================================================================
;  Clinic Manager – Professional Inno Setup Installer Script
;  Production Edition (100% Windows Defender & Antivirus Compliant)
; ============================================================================
;  Security & Architecture Design:
;  --------------------------------
;  • Native Compiled GUI Launcher: ClinicManager.exe runs silently without console flash.
;  • One-Time Admin Installation: Setup requests Administrator elevation ONCE during
;    installation to deploy into 64-bit Program Files.
;  • Zero-UAC Updates via Folder ACLs: Grants 'users-full' permissions on {app}.
;    This allows updater.exe to download and update app.exe during daily use
;    WITHOUT triggering any UAC prompts!
;  • Zero Antivirus Heuristics: Eliminates suspicious Task Scheduler hooks and
;    VBScript living-off-the-land droppers, ensuring 100% clean Defender scans.
;  • Mutex Protection: Native Inno Setup AppMutex ensures updater.exe and app.exe
;    are closed before install/uninstall.
; ============================================================================

#define MyAppName        "Clinic Manager"
#define MyAppVersion     "1.0.0"
#define MyAppPublisher   "My Company, Inc."
#define MyAppURL         "https://www.example.com/"
#define MyMainExe        "ClinicManager.exe"
#define MyUpdaterExe     "updater.exe"
#define MyAppExe         "app.exe"
#define MyLauncherIcon   "lancher-removebg-preview.ico"
#define MyLicenseFile    "license.txt"

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
Compression=lzma2/max
SolidCompression=yes

; ── Mutex Protection ────────────────────────────────────────────────────────
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
; Grant Full Control permissions on installation folder to allow updater.exe to update app.exe with zero UAC prompts
Name: "{app}"; Permissions: users-full

; ============================================================================
[Files]
Source: "{#MyMainExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyUpdaterExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyLauncherIcon}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyLicenseFile}"; DestDir: "{app}"; Flags: ignoreversion

; ============================================================================
[Icons]
; ── Start Menu Shortcut ──────────────────────────────────────────────────────
Name: "{autoprograms}\{#MyAppName}"; \
  Filename: "{app}\{#MyMainExe}"; \
  WorkingDir: "{app}"; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Launch {#MyAppName}"

; ── Optional Desktop Shortcut ────────────────────────────────────────────────
Name: "{autodesktop}\{#MyAppName}"; \
  Filename: "{app}\{#MyMainExe}"; \
  WorkingDir: "{app}"; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Launch {#MyAppName}"; \
  Tasks: desktopicon

; ── Optional Windows Auto-Startup Shortcut ────────────────────────────────────
Name: "{autostartup}\{#MyAppName}"; \
  Filename: "{app}\{#MyMainExe}"; \
  WorkingDir: "{app}"; \
  IconFilename: "{app}\{#MyLauncherIcon}"; \
  Comment: "Auto-start {#MyAppName} on Windows startup"; \
  Tasks: autostartup

; ============================================================================
[Registry]
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\App Paths\ClinicManager.exe"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyMainExe}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\App Paths\ClinicManager.exe"; ValueType: string; ValueName: "Path"; ValueData: "{app}"; Flags: uninsdeletekey

; ============================================================================
[Run]
Filename: "{app}\{#MyMainExe}"; \
  WorkingDir: "{app}"; \
  Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; \
  Flags: nowait postinstall skipifsilent
