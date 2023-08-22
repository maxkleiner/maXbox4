//------------------------------------------------------------------------------
// Ausgewählte Pascal-Äquivalente aus wincred.h
// Quelle Originaldatei: Microsoft Platform SDK
// Diese Übersetzung Copyright (c) 2007-2008 Jens Geyer und Toolbox-Verlag.
//------------------------------------------------------------------------------
unit WinCred;

{$A8}

interface

uses Classes, Windows,
     WinNT,
     SysUtils;

const
  // Maximum length of the various credential string fields (in characters)
  CRED_MAX_STRING_LENGTH = 256;

  // Maximum length of the UserName field.  The worst case is <User>@<DnsDomain>
  CRED_MAX_USERNAME_LENGTH = (256+1+256);

  // Maximum length of the TargetName field for CRED_TYPE_GENERIC (in characters)
  CRED_MAX_GENERIC_TARGET_NAME_LENGTH = 32767;

  // Maximum length of the TargetName field for CRED_TYPE_DOMAIN_* (in characters)
  //      Largest one is <DfsRoot>\<DfsShare>
  CRED_MAX_DOMAIN_TARGET_NAME_LENGTH  = (256+1+80);

  // Maximum size of the Credential Attribute Value field (in bytes)
  CRED_MAX_VALUE_SIZE = 256;

  // Maximum number of attributes per credential
  CRED_MAX_ATTRIBUTES = 64;


  // Values of the Credential Flags field.
  CRED_FLAGS_PASSWORD_FOR_CERT    = $0001;
  CRED_FLAGS_PROMPT_NOW           = $0002;
  CRED_FLAGS_USERNAME_TARGET      = $0004;
  CRED_FLAGS_OWF_CRED_BLOB        = $0008;
  CRED_FLAGS_VALID_FLAGS          = $000F;  // Mask of all valid flags

  // Values of the Credential Type field.
  CRED_TYPE_GENERIC                 = 1;
  CRED_TYPE_DOMAIN_PASSWORD         = 2;
  CRED_TYPE_DOMAIN_CERTIFICATE      = 3;
  CRED_TYPE_DOMAIN_VISIBLE_PASSWORD = 4;
  CRED_TYPE_MAXIMUM                 = 5;       // Maximum supported cred type
  CRED_TYPE_MAXIMUM_EX  = (CRED_TYPE_MAXIMUM+1000);  // Allow new applications to run on old OSes

  // Maximum size of the CredBlob field (in bytes)
  CRED_MAX_CREDENTIAL_BLOB_SIZE     = 512;

  // Values of the Credential Persist field
  CRED_PERSIST_NONE               = 0;
  CRED_PERSIST_SESSION            = 1;
  CRED_PERSIST_LOCAL_MACHINE      = 2;
  CRED_PERSIST_ENTERPRISE         = 3;


  // String length limits:
  CREDUI_MAX_MESSAGE_LENGTH           = 32767;
  CREDUI_MAX_CAPTION_LENGTH           = 128;
  CREDUI_MAX_GENERIC_TARGET_LENGTH    = CRED_MAX_GENERIC_TARGET_NAME_LENGTH;
  CREDUI_MAX_DOMAIN_TARGET_LENGTH     = CRED_MAX_DOMAIN_TARGET_NAME_LENGTH;
  CREDUI_MAX_USERNAME_LENGTH          = CRED_MAX_USERNAME_LENGTH;
  CREDUI_MAX_PASSWORD_LENGTH          = CRED_MAX_CREDENTIAL_BLOB_SIZE div 2;

  // Flags for CredUIPromptForCredentials and/or CredUICmdLinePromptForCredentials
  CREDUI_FLAGS_INCORRECT_PASSWORD     = $00001;      // indicates the username is valid, but password is not
  CREDUI_FLAGS_DO_NOT_PERSIST         = $00002;      // Do not show "Save" checkbox, and do not persist credentials
  CREDUI_FLAGS_REQUEST_ADMINISTRATOR  = $00004;      // Populate list box with admin accounts
  CREDUI_FLAGS_EXCLUDE_CERTIFICATES   = $00008;      // do not include certificates in the drop list
  CREDUI_FLAGS_REQUIRE_CERTIFICATE    = $00010;
  CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX    = $00040;
  CREDUI_FLAGS_ALWAYS_SHOW_UI         = $00080;
  CREDUI_FLAGS_REQUIRE_SMARTCARD      = $00100;
  CREDUI_FLAGS_PASSWORD_ONLY_OK       = $00200;
  CREDUI_FLAGS_VALIDATE_USERNAME      = $00400;
  CREDUI_FLAGS_COMPLETE_USERNAME      = $00800;      //
  CREDUI_FLAGS_PERSIST                = $01000;      // Do not show "Save" checkbox, but persist credentials anyway
  CREDUI_FLAGS_SERVER_CREDENTIAL      = $04000;
  CREDUI_FLAGS_EXPECT_CONFIRMATION    = $20000;      // do not persist unless caller later confirms credential via CredUIConfirmCredential() api
  CREDUI_FLAGS_GENERIC_CREDENTIALS    = $40000;      // Credential is a generic credential
  CREDUI_FLAGS_USERNAME_TARGET_CREDENTIALS = $80000; // Credential has a username as the target
  CREDUI_FLAGS_KEEP_USERNAME          = $100000;     // don't allow the user to change the supplied username


  // Mask of flags valid for CredUIPromptForCredentials
  CREDUI_FLAGS_PROMPT_VALID = CREDUI_FLAGS_INCORRECT_PASSWORD
                           or CREDUI_FLAGS_DO_NOT_PERSIST
                           or CREDUI_FLAGS_REQUEST_ADMINISTRATOR
                           or CREDUI_FLAGS_EXCLUDE_CERTIFICATES
                           or CREDUI_FLAGS_REQUIRE_CERTIFICATE
                           or CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX
                           or CREDUI_FLAGS_ALWAYS_SHOW_UI
                           or CREDUI_FLAGS_REQUIRE_SMARTCARD
                           or CREDUI_FLAGS_PASSWORD_ONLY_OK
                           or CREDUI_FLAGS_VALIDATE_USERNAME
                           or CREDUI_FLAGS_COMPLETE_USERNAME
                           or CREDUI_FLAGS_PERSIST
                           or CREDUI_FLAGS_SERVER_CREDENTIAL
                           or CREDUI_FLAGS_EXPECT_CONFIRMATION
                           or CREDUI_FLAGS_GENERIC_CREDENTIALS
                           or CREDUI_FLAGS_USERNAME_TARGET_CREDENTIALS
                           or CREDUI_FLAGS_KEEP_USERNAME;




type
  _CREDUI_INFOA = record
    cbSize : DWORD;
    hwndParent : HWND;
    pszMessageText : PAnsiChar;
    pszCaptionText : PAnsiChar;
    hbmBanner : HBITMAP;
  end;
  CREDUI_INFOA  = _CREDUI_INFOA;
  PCREDUI_INFOA = ^CREDUI_INFOA;

  _CREDUI_INFOW = record
    cbSize : DWORD;
    hwndParent : HWND;
    pszMessageText : PWideChar;
    pszCaptionText : PWideChar;
    hbmBanner : HBITMAP;
  end;
  CREDUI_INFOW  = _CREDUI_INFOW;
  PCREDUI_INFOW = ^CREDUI_INFOW;

  CREDUI_INFO  = CREDUI_INFOA;
  PCREDUI_INFO = PCREDUI_INFOA;

  // dieser Parameter ist im MSDN als reserved ausgewiesen, Pointer reicht also
  PCtxtHandle = Pointer;


function CredUIParseUserName(  {in}  userName         : PAnsiChar;
                               {out} user             : PAnsiChar;
                               {in}  userBufferSize   : ULONG;
                               {out} domain           : PAnsiChar;
                               {in}  domainBufferSize : ULONG
                             ) : DWORD;  stdcall;

function CredUIParseUserNameA( {in}  userName         : PAnsiChar;
                               {out} user             : PAnsiChar;
                               {in}  userBufferSize   : ULONG;
                               {out} domain           : PAnsiChar;
                               {in}  domainBufferSize : ULONG
                             ) : DWORD;  stdcall;

function CredUIParseUserNameW( {in}  userName         : PWideChar;
                               {out} user             : PWideChar;
                               {in}  userBufferSize   : ULONG;
                               {out} domain           : PWideChar;
                               {in}  domainBufferSize : ULONG
                             ) : DWORD;  stdcall;



function CredUIPromptForCredentials(
                  {in}     pUiInfo              : PCREDUI_INFOA;  // optional
                  {in}     pszTargetName        : PChar;
                  {in}     _reserved_null       : PCtxtHandle;
                  {in}     dwAuthError          : DWORD;  // optional
                  {in,out} pszUserName          : PChar;
                  {in}     ulUserNameBufferSize : ULONG;
                  {in,out} pszPassword          : PChar;
                  {in}     ulPasswordBufferSize : ULONG;
                  {in,out} var save             : BOOL;
                  {in}     dwFlags              : DWORD
                 ) : DWORD;  stdcall;


function CredUIPromptForCredentialsA(
                  {in}     pUiInfo              : PCREDUI_INFOA;  // optional
                  {in}     pszTargetName        : PAnsiChar;
                  {in}     _reserved_null       : PCtxtHandle;
                  {in}     dwAuthError          : DWORD;  // optional
                  {in,out} pszUserName          : PAnsiChar;
                  {in}     ulUserNameBufferSize : ULONG;
                  {in,out} pszPassword          : PAnsiChar;
                  {in}     ulPasswordBufferSize : ULONG;
                  {in,out} var save             : BOOL;
                  {in}     dwFlags              : DWORD
                 ) : DWORD;  stdcall;

function CredUIPromptForCredentialsW(
                  {in}     pUiInfo              : PCREDUI_INFOA;  // optional
                  {in}     pszTargetName        : PWideChar;
                  {in}     _reserved_null       : PCtxtHandle;
                  {in}     dwAuthError          : DWORD;  // optional
                  {in,out} pszUserName          : PWideChar;
                  {in}     ulUserNameBufferSize : ULONG;
                  {in,out} pszPassword          : PWideChar;
                  {in}     ulPasswordBufferSize : ULONG;
                  {in,out} var save             : BOOL;
                  {in}     dwFlags              : DWORD
                 ) : DWORD;  stdcall;


type
  // eigene Datenstrukturen
  TUserAndPwdA = record
    acUser : array[0..CREDUI_MAX_USERNAME_LENGTH+1] of AnsiChar;
    acPwd  : array[0..CREDUI_MAX_PASSWORD_LENGTH+1] of AnsiChar;
  end;
  PUserAndPwdA = ^TUserAndPwdA;

  TUserAndPwdW = record
    acUser : array[0..CREDUI_MAX_USERNAME_LENGTH+1] of WideChar;
    acPwd  : array[0..CREDUI_MAX_PASSWORD_LENGTH+1] of WideChar;
  end;
  PUserAndPwdW = ^TUserAndPwdW;



// eigene Funktionen
function GetUserAndPwdW( hwndParent : HWND; const aMsg,aCapt,aTarget : WideString; var uap : TUserAndPwdW) : Boolean;

// UI verfügbar?
function  IsCredUIAvailable : Boolean;

implementation

const CREDUI_DLL = 'credui.dll';

type
  TCredUIPromptForCredentialsA = function(
                  {in}     pUiInfo              : PCREDUI_INFOA;  // optional
                  {in}     pszTargetName        : PAnsiChar;
                  {in}     _reserved_null       : PCtxtHandle;
                  {in}     dwAuthError          : DWORD;  // optional
                  {in,out} pszUserName          : PAnsiChar;
                  {in}     ulUserNameBufferSize : ULONG;
                  {in,out} pszPassword          : PAnsiChar;
                  {in}     ulPasswordBufferSize : ULONG;
                  {in,out} var save             : BOOL;
                  {in}     dwFlags              : DWORD
                 ) : DWORD;  stdcall;

  TCredUIPromptForCredentialsW = function(
                  {in}     pUiInfo              : PCREDUI_INFOA;  // optional
                  {in}     pszTargetName        : PWideChar;
                  {in}     _reserved_null       : PCtxtHandle;
                  {in}     dwAuthError          : DWORD;  // optional
                  {in,out} pszUserName          : PWideChar;
                  {in}     ulUserNameBufferSize : ULONG;
                  {in,out} pszPassword          : PWideChar;
                  {in}     ulPasswordBufferSize : ULONG;
                  {in,out} var save             : BOOL;
                  {in}     dwFlags              : DWORD
                 ) : DWORD;  stdcall;

  TCredUIParseUserNameA = function(
                  {in}  userName         : PAnsiChar;
                  {out} user             : PAnsiChar;
                  {in}  userBufferSize   : ULONG;
                  {out} domain           : PAnsiChar;
                  {in}  domainBufferSize : ULONG
                 ) : DWORD;  stdcall;

  TCredUIParseUserNameW = function(
                  {in}  userName         : PWideChar;
                  {out} user             : PWideChar;
                  {in}  userBufferSize   : ULONG;
                  {out} domain           : PWideChar;
                  {in}  domainBufferSize : ULONG
                 ) : DWORD;  stdcall;


var
  hCreduiDll : HMODULE = 0;
  lpfnCUPFCA : TCredUIPromptForCredentialsA = nil;
  lpfnCUPFCW : TCredUIPromptForCredentialsW = nil;
  lpfnCUPUNA : TCredUIParseUserNameA = nil;
  lpfnCUPUNW : TCredUIParseUserNameW = nil;


{ statische Bindung? dann funktioniert diese Unit nur ab XP!
function CredUIPromptForCredentials;  stdcall;
external CREDUI_DLL name 'CredUIPromptForCredentialsA';
function CredUIPromptForCredentialsA;  stdcall;
external CREDUI_DLL name 'CredUIPromptForCredentialsA';
}

function CredUIPromptForCredentials;
begin
  ASSERT( SizeOf(Char) = SizeOf(AnsiChar));  // wir leben hier unter ANSI
  result := CredUIPromptForCredentialsA( pUiInfo, pszTargetName, _reserved_null,
                                         dwAuthError, pszUserName, ulUserNameBufferSize,
                                         pszPassword, ulPasswordBufferSize, save, dwFlags);
end;


function CredUIPromptForCredentialsA;
begin
  if (hCreduiDll <> 0) and Assigned(lpfnCUPFCA)
  then result := lpfnCUPFCA( pUiInfo, pszTargetName, _reserved_null, dwAuthError,
                             pszUserName, ulUserNameBufferSize, pszPassword, ulPasswordBufferSize,
                             save, dwFlags)
  else result := ERROR_CALL_NOT_IMPLEMENTED;
end;


function CredUIPromptForCredentialsW;
begin
  if (hCreduiDll <> 0) and Assigned(lpfnCUPFCW)
  then result := lpfnCUPFCW( pUiInfo, pszTargetName, _reserved_null, dwAuthError,
                             pszUserName, ulUserNameBufferSize, pszPassword, ulPasswordBufferSize,
                             save, dwFlags)
  else result := ERROR_CALL_NOT_IMPLEMENTED;
end;



function CredUIParseUserName;
begin
  ASSERT( SizeOf(Char) = SizeOf(AnsiChar));  // wir leben hier unter ANSI
  result := CredUIParseUserNameA( userName, user, userBufferSize, domain, domainBufferSize);
end;


function CredUIParseUserNameA;
begin
  if (hCreduiDll <> 0) and Assigned(lpfnCUPUNA)
  then result := lpfnCUPUNA( userName, user, userBufferSize, domain, domainBufferSize)
  else result := ERROR_CALL_NOT_IMPLEMENTED;
end;


function CredUIParseUserNameW;
begin
  if (hCreduiDll <> 0) and Assigned(lpfnCUPUNW)
  then result := lpfnCUPUNW( userName, user, userBufferSize, domain, domainBufferSize)
  else result := ERROR_CALL_NOT_IMPLEMENTED;
end;



function IsCredUIAvailable : Boolean;
// Liefert TRUE ab WinXP, wenn die DLL geladen werden konnte
// In allen anderen Fällen wird FALSE zurückgegeben
var info : TOSVersionInfo;
begin
  // Plattform muß NT sein
  result := (Win32Platform = VER_PLATFORM_WIN32_NT);
  if not result then Exit;

  // OS-Version abrufen
  result := GetOsVersionInfo(info);
  if not result then Exit;

  // Requirements
  // - Client: Requires Windows Vista or Windows XP.
  // - Server: Requires Windows Server "Longhorn" or Windows Server 2003.
  case info.dwMajorVersion of
    0..4 :  result := FALSE;  // NT 4 oder noch älter
    5    :  result := (1 <= info.dwMinorVersion);   // 5.0=2000, 5.1=XP, 5.2=Server2003/XP64
  else
    ASSERT( info.dwMajorVersion >= 6);  // 6=Vista/Longhorn
    result := TRUE;
  end;
  if not result then Exit;

  // jetzt muß nur noch die CREDUI.DLL verfügbar sein
  result := (hCreduiDll <> 0) and Assigned(lpfnCUPFCA);
end;


//--- CredUI-Funktionen --------------------------------------------------------


function GetUserAndPwdW( hwndParent : HWND; const aMsg,aCapt,aTarget : WideString; var uap : TUserAndPwdW) : Boolean;
// Login-Dialog und Benutzeranmeldung
// Requirements
// - Client: Requires Windows Vista or Windows XP.
// - Server: Requires Windows Server "Longhorn" or Windows Server 2003.
var
  cui    : CREDUI_INFOW;
  bSave  : BOOL;
  dwErr, dwFlags  : DWORD;
  pcTarget : PWideChar;
  wsMessage,wsCaption : WideString;
const
  MY_CREDUI_FLAGS = CREDUI_FLAGS_GENERIC_CREDENTIALS or CREDUI_FLAGS_ALWAYS_SHOW_UI
                 or CREDUI_FLAGS_DO_NOT_PERSIST {or CREDUI_FLAGS_REQUEST_ADMINISTRATOR}
                 or CREDUI_FLAGS_VALIDATE_USERNAME;
  CONDITIONAL_ONLY = CREDUI_FLAGS_COMPLETE_USERNAME;
begin
  try
    //  Ensure that MessageText and CaptionText identify what credentials
    //  to use and which application requires them.
    wsMessage := Copy( aMsg, 1, CREDUI_MAX_MESSAGE_LENGTH);
    wsCaption := Copy( aCapt, 1, CREDUI_MAX_CAPTION_LENGTH);

    // Setup der Dialogdatenstruktur
    FillChar( cui, SizeOf(cui), 0);
    cui.cbSize         := sizeof(CREDUI_INFO);
    cui.hwndParent     := hwndParent;
    cui.pszMessageText := PWideChar( wsMessage);
    cui.pszCaptionText := PWideChar( wsCaption);
    cui.hbmBanner      := 0;  // default verwenden

    // Daten und Flags komplettieren
    pcTarget := nil;
    dwFlags  := MY_CREDUI_FLAGS and not CONDITIONAL_ONLY;
    if aTarget <> '' then begin
      dwFlags  := dwFlags or CREDUI_FLAGS_COMPLETE_USERNAME;
      pcTarget := PWideChar( aTarget);
    end;


    // Name, Passwort und Flag initialisieren
    bSave  := FALSE;
    //SecureZeroMemory( uap.acUser, SizeOf(uap.acUser));
    SecureZeroMemory( uap.acPwd,  SizeOf(uap.acPwd));

    // Dialog aufrufen
    dwErr := CredUIPromptForCredentialsW(
                     @cui,                    // Zeiger auf CREDUI_INFO
                     pcTarget,                // Ziel
                     nil,                     // Reserviert, NIL setzen
                     0,                       // Aufrufgrund, mögl. Werte siehe MSDN
                     uap.acUser, SizeOf(uap.acUser),  // Username
                     uap.acPwd,  SizeOf(uap.acPwd),   // Password
                     bSave,                   // [x] Speichern
                     dwFlags);

    result := (dwErr = 0);
    if not result then begin
      SetLastError(dwErr);
      // Passwort sicher vernichten
      SecureZeroMemory( uap.acUser, SizeOf(uap.acUser));
      SecureZeroMemory( uap.acPwd,  SizeOf(uap.acPwd));
      Exit;
    end;

  except
    // Passwort sicher vernichten
    SecureZeroMemory( uap.acUser, SizeOf(uap.acUser));
    SecureZeroMemory( uap.acPwd,  SizeOf(uap.acPwd));
    raise;
  end;
end;



//--- main ---------------------------------------------------------------------


procedure InitUnit;
// Initialisieren der Unit
begin
  try
    hCreduiDll := LoadLibraryEx( CREDUI_DLL, 0,0);
    if hCreduiDll <> 0 then begin
      lpfnCUPFCA := GetProcAddress( hCreduiDll, 'CredUIPromptForCredentialsA');
      lpfnCUPFCW := GetProcAddress( hCreduiDll, 'CredUIPromptForCredentialsW');
      lpfnCUPUNA := GetProcAddress( hCreduiDll, 'CredUIParseUserNameA');
      lpfnCUPUNW := GetProcAddress( hCreduiDll, 'CredUIParseUserNameW');
    end;

  except
    on e:Exception do OutputDebugString( PChar('WinCred Init'+e.message+#13#10));
  end;
end;


procedure DeInitUnit;
// Entladen der Unit
begin
  try
    if hCreduiDll <> 0 then begin
      lpfnCUPFCA := nil;
      lpfnCUPFCW := nil;
      lpfnCUPUNA := nil;
      lpfnCUPUNW := nil;

      FreeLibrary(hCreduiDll);
      hCreduiDll := 0;
    end;

  except
    on e:Exception do OutputDebugString( PChar('WinCred Init'+e.message+#13#10));
  end;
end;


initialization
  InitUnit;

finalization
  DeinitUnit;

end.
