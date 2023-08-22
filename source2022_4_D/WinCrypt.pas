//------------------------------------------------------------------------------
// Ausgewählte Pascal-Äquivalente aus wincrypt.h
// Quelle Originaldatei: Microsoft Platform SDK
// Diese Übersetzung Copyright (c) 2008 Jens Geyer und Toolbox-Verlag.
//------------------------------------------------------------------------------
unit WinCrypt;

interface

uses Windows, WinNT, SysUtils;


//+-------------------------------------------------------------------------
//  CRYPTOAPI BLOB definitions
//--------------------------------------------------------------------------
type
  _CRYPTOAPI_BLOB = record
      cbData : DWORD;   // size of data
      pbData : PBYTE;   // ptr to data
  end;
  CRYPT_INTEGER_BLOB   = _CRYPTOAPI_BLOB;
  CRYPT_UINT_BLOB      = _CRYPTOAPI_BLOB;
  CRYPT_OBJID_BLOB     = _CRYPTOAPI_BLOB;
  CERT_NAME_BLOB       = _CRYPTOAPI_BLOB;
  CERT_RDN_VALUE_BLOB  = _CRYPTOAPI_BLOB;
  CERT_BLOB            = _CRYPTOAPI_BLOB;
  CRL_BLOB             = _CRYPTOAPI_BLOB;
  DATA_BLOB            = _CRYPTOAPI_BLOB;
  CRYPT_DATA_BLOB      = _CRYPTOAPI_BLOB;
  CRYPT_HASH_BLOB      = _CRYPTOAPI_BLOB;
  CRYPT_DIGEST_BLOB    = _CRYPTOAPI_BLOB;
  CRYPT_DER_BLOB       = _CRYPTOAPI_BLOB;
  CRYPT_ATTR_BLOB      = _CRYPTOAPI_BLOB;
  PCRYPT_INTEGER_BLOB  = ^CRYPT_INTEGER_BLOB;
  PCRYPT_UINT_BLOB     = ^CRYPT_UINT_BLOB;
  PCRYPT_OBJID_BLOB    = ^CRYPT_OBJID_BLOB;
  PCERT_NAME_BLOB      = ^CERT_NAME_BLOB;
  PCERT_RDN_VALUE_BLOB = ^CERT_RDN_VALUE_BLOB;
  PCERT_BLOB           = ^CERT_BLOB;
  PCRL_BLOB            = ^CRL_BLOB;
  PDATA_BLOB           = ^DATA_BLOB;
  PCRYPT_DATA_BLOB     = ^CRYPT_DATA_BLOB;
  PCRYPT_HASH_BLOB     = ^CRYPT_HASH_BLOB;
  PCRYPT_DIGEST_BLOB   = ^CRYPT_DIGEST_BLOB;
  PCRYPT_DER_BLOB      = ^CRYPT_DER_BLOB;
  PCRYPT_ATTR_BLOB     = ^CRYPT_ATTR_BLOB;


//-------------------------------------------------------------------------
// Data Protection APIs
//-------------------------------------------------------------------------

type
  // The base provider provides protection based on the users' logon credentials.
  // The data secured with these APIs follow the same roaming characteristics as HKCU
  // i.e. if HKCU roams, the data protected by the base provider may roam as well.
  // This makes the API ideal for the munging of data stored in the registry.

  // Prompt struct -- what to tell users about the access
  _CRYPTPROTECT_PROMPTSTRUCT = record
      cbSize        : DWORD;
      dwPromptFlags : DWORD;   // CRYPTPROTECT_PROMPT - Flags
      hwndApp       : HWND;
      szPrompt      : LPCWSTR;
  end;
  CRYPTPROTECT_PROMPTSTRUCT  = _CRYPTPROTECT_PROMPTSTRUCT;
  PCryptProtect_PromptStruct = ^CRYPTPROTECT_PROMPTSTRUCT;
  TCryptProtect_PromptStruct = CRYPTPROTECT_PROMPTSTRUCT;


const
  // base provider action
  CRYPTPROTECT_DEFAULT_PROVIDER = '{df9d8cd0-1501-11d1-8c7a00c04fc297eb}';

  // CryptProtect PromptStruct dwPromptFlags
  CRYPTPROTECT_PROMPT_ON_UNPROTECT     = $01;
  CRYPTPROTECT_PROMPT_ON_PROTECT       = $02;
  CRYPTPROTECT_PROMPT_RESERVED         = $04;  // reserved, do not use.
  CRYPTPROTECT_PROMPT_STRONG           = $08;  // strong = als default setzen
  CRYPTPROTECT_PROMPT_REQUIRE_STRONG   = $10;  // strong = erforderlich machen


  // CryptProtectData and CryptUnprotectData dwFlags
  CRYPTPROTECT_UI_FORBIDDEN      = $01;  // UI angefordert? => ERROR_PASSWORD_RESTRICTION!
  CRYPTPROTECT_LOCAL_MACHINE     = $04;  // per Maschine verschlüsseln (nicht per User!)
  CRYPTPROTECT_CRED_SYNC         = $08;  // snchronisiert Credentials
  CRYPTPROTECT_AUDIT             = $10;  // Aufruf schreibt eine Audit-Message (siehe Eventlog)
  CRYPTPROTECT_NO_RECOVERY       = $20;  // Verschlüsselung mit nicht rekonstruierbarem Schlüssel
  CRYPTPROTECT_VERIFY_PROTECTION = $40;  // Verify the protection of a protected blob
  CRYPTPROTECT_CRED_REGENERATE   = $80;  // Regenerate the local machine protection
  // flags reserved for system use
  CRYPTPROTECT_FIRST_RESERVED_FLAGVAL    = $0FFFFFFF;
  CRYPTPROTECT_LAST_RESERVED_FLAGVAL     = $FFFFFFFF;


  // Größe der an Crypt[Un]ProtectMemory() übergebenen Buffer müssen Vielfaches davon sein
  CRYPTPROTECTMEMORY_BLOCK_SIZE          = 16;

  // CryptProtectMemory/CryptUnprotectMemory dwFlags
  CRYPTPROTECTMEMORY_SAME_PROCESS         = $00;   // entschlüsselbar nur innerhalb des Prozesses
  CRYPTPROTECTMEMORY_CROSS_PROCESS        = $01;   // ... auch in allen anderen Prozessen
  CRYPTPROTECTMEMORY_SAME_LOGON           = $02;   // ... in allen Prozessen des Users (LogonId)



function CryptProtectData( {IN}      const pDataIn : DATA_BLOB;
                           {IN}      szDataDescr : PWideChar;
                           {IN OPT}  const pOptionalEntropy : DATA_BLOB;
                           {IN}      pvReserved : Pointer;
                           {IN OPT}  pPromptStruct : PCRYPTPROTECT_PROMPTSTRUCT;
                           {IN}      dwFlags : DWORD;
                           {OUT}     var pDataOut : DATA_BLOB          // out encr blob
                         ) : BOOL; stdcall;

function CryptUnprotectData( {IN}      const pDataIn : DATA_BLOB;            // in encr blob
                             {OUT OPT} var ppszDataDescr : PWideChar;       // out, needs LocalFree()
                             {IN OPT}  const pOptionalEntropy : DATA_BLOB;
                             {IN}      pvReserved : Pointer;
                             {IN OPT}  pPromptStruct : PCRYPTPROTECT_PROMPTSTRUCT;
                             {IN}      dwFlags : DWORD;
                             {OUT}     var pDataOut : DATA_BLOB
                           ) : BOOL; stdcall;



function CryptProtectMemory( {IN OUT}  pDataIn  : Pointer;  // in out data to encrypt
                             {IN}      cbDataIn : DWORD;    // multiple of CRYPTPROTECTMEMORY_BLOCK_SIZE
                             {IN}      dwFlags  : DWORD
                           ) : BOOL;  stdcall;


function CryptUnprotectMemory( {IN OUT}  pDataIn  : Pointer; // in out data to decrypt
                               {IN}      cbDataIn : DWORD;   // multiple of CRYPTPROTECTMEMORY_BLOCK_SIZE
                               {IN}      dwFlags  : DWORD
                             ) : BOOL;  stdcall;


const
  // leeres DATA_BLOB
  EMPTY_DATA_BLOB : DATA_BLOB = (cbData: 0; pbData: nil);

// Tools
procedure FreeCryptBlob( var aBlob : DATA_BLOB);


implementation


//--- Tools --------------------------------------------------------------------


procedure FreeCryptBlob( var aBlob : DATA_BLOB);
// Gibt einen Crypt-Blob frei
begin
  if aBlob.pbData <> nil then begin
    SecureZeroMemory( aBlob.pbData^, aBlob.cbData);
    if LocalFree( Cardinal( aBlob.pbData)) <> 0
    then ASSERT(FALSE);   // falscher Speicherblock?
  end;
  aBlob := EMPTY_DATA_BLOB;
end;


//--- Imports ------------------------------------------------------------------


const CRYPT32_DLL = 'crypt32.dll';

function CryptProtectData;     stdcall; external  CRYPT32_DLL;
function CryptUnprotectData;   stdcall; external  CRYPT32_DLL;


//--- dynamische Bindung -------------------------------------------------------

// CryptProtectMemory ist erst ab Vista und Server 2003 verfügbar,
// deshalb dynamisch laden
type
  TCryptProtectMemory   = function( pDataIn : Pointer; cbDataIn, dwFlags : DWORD) : BOOL; stdcall;
  TCryptUnprotectMemory = TCryptProtectMemory;  // identische Signatur

var
  g_hCrypt32 : THandle               = 0;
  g_lpfnCPM  : TCryptProtectMemory   = nil;
  g_lpfnUPM  : TCryptUnprotectMemory = nil;


function CryptProtectMemory( pDataIn : Pointer; cbDataIn, dwFlags : DWORD) : BOOL; stdcall;
begin
  if (g_hCrypt32 <> 0) and Assigned(g_lpfnCPM)
  then result := g_lpfnCPM( pDataIn, cbDataIn, dwFlags)
  else begin
    SetLastError( ERROR_CALL_NOT_IMPLEMENTED);
    result := FALSE;
  end;
end;


function CryptUnprotectMemory( pDataIn : Pointer; cbDataIn, dwFlags : DWORD) : BOOL; stdcall;
begin
  if (g_hCrypt32 <> 0) and Assigned(g_lpfnUPM)
  then result := g_lpfnUPM( pDataIn, cbDataIn, dwFlags)
  else begin
    SetLastError( ERROR_CALL_NOT_IMPLEMENTED);
    result := FALSE;
  end;
end;



//--- main ---------------------------------------------------------------------

procedure InitUnit;
begin
  try
    g_hCrypt32 := LoadLibrary( CRYPT32_DLL);
    if g_hCrypt32 <> 0 then begin
      g_lpfnCPM  := GetProcAddress( g_hCrypt32, 'CryptProtectMemory');
      g_lpfnUPM  := GetProcAddress( g_hCrypt32, 'CryptUnprotectMemory');
    end;
  except
    on e:Exception do OutputDebugString( PChar('WinCrypt INIT: '+e.message));
  end;
end;


procedure DeInitUnit;
begin
  try
    if g_hCrypt32 <> 0 then begin
      g_lpfnCPM  := nil;
      g_lpfnUPM  := nil;

      FreeLibrary( g_hCrypt32);
      g_hCrypt32 := 0;
    end;
  except
    on e:Exception do OutputDebugString( PChar( 'WinCrypt DEINIT: '+e.message));
  end;
end;


initialization
  InitUnit;

finalization
  DeInitUnit;

end.

