//------------------------------------------------------------------------------
// Ausgewählte Pascal-Äquivalente aus winnt.h
// Quelle Originaldatei: Microsoft Platform SDK
// Diese Übersetzung Copyright (c) 2007-2008 Jens Geyer und Toolbox-Verlag.
//------------------------------------------------------------------------------
unit WinNT;

interface

uses Windows;


type
  EXTENDED_NAME_FORMAT   = LongInt;


const
  NameUnknown            = EXTENDED_NAME_FORMAT(0);
  NameFullyQualifiedDN   = EXTENDED_NAME_FORMAT(1);
  NameSamCompatible      = EXTENDED_NAME_FORMAT(2);
  NameDisplay            = EXTENDED_NAME_FORMAT(3);
  NameUniqueId           = EXTENDED_NAME_FORMAT(6);
  NameCanonical          = EXTENDED_NAME_FORMAT(7);
  NameUserPrincipal      = EXTENDED_NAME_FORMAT(8);
  NameCanonicalEx        = EXTENDED_NAME_FORMAT(9);
  NameServicePrincipal   = EXTENDED_NAME_FORMAT(10);
  NameDnsDomain          = EXTENDED_NAME_FORMAT(12);

  // Logon-Vorgaben
  LOGON_WITH_PROFILE           = $00000001;
  LOGON_NETCREDENTIALS_ONLY    = $00000002;



// dieses stammt aus winnt.h, RtlSecureZeroMemory()
procedure SecureZeroMemory( var buf; aCount : Integer);

// OS-Version abrufen
function  GetOsVersionInfo( var info : TOSVersionInfo) : Boolean;


// Username abrufen (erweiterte Version)
function GetUserNameEx(  NameFomat : EXTENDED_NAME_FORMAT;
                         lpNameBuffer : PChar;
                         var nSize : ULONG) : BOOL;  stdcall;
function GetUserNameExA( NameFomat : EXTENDED_NAME_FORMAT;
                         lpNameBuffer : PAnsiChar;
                         var nSize : ULONG) : BOOL;  stdcall;
function GetUserNameExW( NameFomat : EXTENDED_NAME_FORMAT;
                         lpNameBuffer : PWideChar;
                         var nSize : ULONG) : BOOL;  stdcall;


function CreateProcessWithTokenW( hToken: THandle;
                                  dwLogonFlags : DWORD;
                                  lpApplicationName : PWideChar;
                                  lpCommandLine : PWideChar;
                                  dwCreationFlags : DWORD;
                                  lpEnvironment : Pointer;
                                  lpCurrentDirectory : PWideChar;
                                  const lpStartupInfo: TStartupInfo;
                                  var lpProcessInformation: TProcessInformation
                                  ): BOOL; stdcall;


function CreateProcessWithLogonW( lpUsername: PWideChar;
                                  lpDomain: PWideChar;
                                  lpPassword: PWideChar;
                                  dwLogonFlags: DWORD;
                                  lpApplicationName: PWideChar;
                                  lpCommandLine: PWideChar;
                                  dwCreationFlags: DWORD;
                                  lpEnvironment: Pointer;
                                  lpCurrentDirectory: PWideChar;
                                  var lpStartupInfo: TStartupInfo;
                                  var lpProcessInfo: TProcessInformation
                                ): BOOL; stdcall;


implementation

const
  SECUR32  = 'Secur32.dll';
  ADVAPI32 = 'advapi32.dll';

function GetUserNameEx;    stdcall;  external SECUR32 name 'GetUserNameExA';
function GetUserNameExA;   stdcall;  external SECUR32 name 'GetUserNameExA';
function GetUserNameExW;   stdcall;  external SECUR32 name 'GetUserNameExW';

function CreateProcessWithTokenW; stdcall; external ADVAPI32;
function CreateProcessWithLogonW; stdcall; external ADVAPI32;



{ MSDN : SecureZeroMemory:
  Many programming languages include syntax for initializing complex variables
  to zero. There can be differences between the results of these operations
  and the SecureZeroMemory function. Use SecureZeroMemory to clear a block of
  memory in any programming language.

  For example, the compiler could optimize the call because the szPassword
  buffer is not read from before it goes out of scope. The password would remain
  on the application stack where it could be captured in a crash dump or probed
  by a malicious application.
}

procedure SecureZeroMemory( var buf; aCount : Integer);
// Delphi-Variante des Makros RtlSecureZeroMemory()
var pThis : PByte;
begin
  pThis := @buf;
  while aCount > 0 do begin
    pThis^ := $00;
    Inc(pThis);
    Dec(aCount);
  end;
end;


function GetOsVersionInfo( var info : TOSVersionInfo) : Boolean;
// OS-Version abrufen
begin
  FillChar( info, SizeOf(info), 0);
  info.dwOSVersionInfoSize := SizeOf(info);
  result := GetVersionEx( info);
end;




end.



