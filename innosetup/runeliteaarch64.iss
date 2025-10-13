[Setup]
AppName=LuzoxPK Launcher
AppPublisher=LuzoxPK
UninstallDisplayName=LuzoxPK
AppVersion=${project.version}
AppSupportURL=https://luzoxpk.com
DefaultDirName={localappdata}\LuzoxPK

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=arm64
PrivilegesRequired=lowest

WizardSmallImageFile=${project.projectDir}/innosetup/runelite_small.bmp
SetupIconFile=${project.projectDir}/innosetup/runelite.ico
UninstallDisplayIcon={app}\LuzoxPK.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${project.projectDir}
OutputBaseFilename=LuzoxPKSetupAArch64

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${project.projectDir}\build\win-aarch64\LuzoxPK.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-aarch64\LuzoxPK.jar"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-aarch64\launcher_aarch64.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-aarch64\config.json"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-aarch64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\LuzoxPK\LuzoxPK"; Filename: "{app}\LuzoxPK.exe"
Name: "{userprograms}\LuzoxPK\LuzoxPK (configure)"; Filename: "{app}\LuzoxPK.exe"; Parameters: "--configure"
Name: "{userprograms}\LuzoxPK\LuzoxPK (safe mode)"; Filename: "{app}\LuzoxPK.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\LuzoxPK"; Filename: "{app}\LuzoxPK.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\LuzoxPK.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\LuzoxPK.exe"; Description: "&Open LuzoxPK"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\LuzoxPK.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.LuzoxPK\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Registry]
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: ""; ValueData: "URL:runelite-jav Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\LuzoxPK.exe"" ""%1"""; Flags: uninsdeletekey

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"