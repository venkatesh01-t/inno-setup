#define MyAppName "Clinic Manager"
#define MyUpdaterExe "updater.exe"
#define MyLauncherIcon "lancher-removebg-preview.ico"

[Setup]
AppName={#MyAppName}
AppVersion=1.0
DefaultDirName=C:\programfile\ClinicManager
DefaultGroupName={#MyAppName}
OutputBaseFilename=ClinicManagerSetup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin

[Files]
Source: "{#MyUpdaterExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyLauncherIcon}"; DestDir: "{app}"; Flags: ignoreversion

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  PSFile: string;
  PSContent: string;
begin
  if CurStep = ssPostInstall then
  begin
    PSFile := ExpandConstant('{app}\launcher.ps1');

    PSContent :=
      '$updater = "' + ExpandConstant('{app}\updater.exe') + '"' + #13#10 +
      '$app = "' + ExpandConstant('{app}\app.exe') + '"' + #13#10 +
      '' + #13#10 +
      '# Run updater normally (NO admin bypass here)' + #13#10 +
      'Start-Process $updater -Wait' + #13#10 +
      '' + #13#10 +
      '# Run app normally after update' + #13#10 +
      'if (Test-Path $app) {' + #13#10 +
      '    Start-Process $app' + #13#10 +
      '}';

    SaveStringToFile(PSFile, PSContent, False);
  end;
end;

[Icons]
Name: "{commondesktop}\{#MyAppName}"; \
Filename: "powershell.exe"; \
Parameters: "-WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\launcher.ps1"""; \
IconFilename: "{app}\{#MyLauncherIcon}"

Name: "{group}\{#MyAppName}"; \
Filename: "powershell.exe"; \
Parameters: "-WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\launcher.ps1"""; \
IconFilename: "{app}\{#MyLauncherIcon}"

[Run]
Filename: "powershell.exe"; \
Parameters: "-WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\launcher.ps1"""; \
Flags: postinstall nowait skipifsilent