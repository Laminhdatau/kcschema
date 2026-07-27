; =====================================================================
; KYASCHEMA — Professional Inno Setup Script
; Developer: KYACODETECH SOLUTION
; Target Platform: Windows 10/11 64-bit (x64)
; =====================================================================

#define MyAppName "KYASCHEMA"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "KYACODETECH SOLUTION"
#define MyAppURL "https://kyacodetech.com"
#define MyAppExeName "kcschema.exe"
#define MyAppIcon "assets\icon\app_icon.ico"
#define MyBuildDir "build\windows\x64\runner\Release"

[Setup]
; Basic Setup Details
AppId={{D837714D-4D0C-49C1-BCBB-1C760C75C546}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} v{#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; Installation Target Folder (C:\Program Files\KYASCHEMA)
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes

; Icon & Branding
SetupIconFile={#MyAppIcon}
UninstallDisplayIcon={app}\{#MyAppExeName}
WizardStyle=modern
WizardSmallImageFile={#MyAppIcon}

; Compression & Output Settings
Compression=lzma2/ultra64
SolidCompression=yes
OutputDir=installer_output
OutputBaseFilename=KYASCHEMA_Setup_v1.0.0

; System Architecture Requirements
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; Privileges & Safety
PrivilegesRequired=admin
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "Buat Pintasan di Quick Launch Bar"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Primary Executable
Source: "{#MyBuildDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; Executable Dependencies (DLLs, flutter_assets, pdfium.dll, sqlite3.dll, data)
Source: "{#MyBuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "{#MyAppExeName}"

[Icons]
; Start Menu & Desktop Shortcuts
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"

[Run]
; Launch Application Option Post-Installation
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}\data"
Type: filesandordirs; Name: "{app}\logs"
