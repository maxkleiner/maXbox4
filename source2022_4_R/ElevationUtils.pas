// http://developersoven.blogspot.com/2007/02/leveraging-vistas-uac-with-delphi-part_3659.html

{$I '..\..\switches.inc'}

unit ElevationUtils;
{
#===============================================================================

# Name:        ElevationUtils.pas
# Author:      Aleksander Oven
# Created:     2007-03-01
# Last Change: 2007-03-01
# Version:     1.0

# Description:

  Windows Vista COM Elevation Moniker implementation.

  http://msdn2.microsoft.com/en-us/library/ms679687.aspx

# Warnings and/or special considerations:

  Source code in this file is subject to the license specified below.

#===============================================================================

  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in compliance
  with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
  the specific language governing rights and limitations under the License.

  The Original Code is 'ElevationUtils.pas'.

  The Initial Developer of the Original Code is 'Aleksander Oven'.

  Contributor(s): None.

#===============================================================================
}
interface

uses
  Windows;

function IsElevated: Boolean;

procedure CoCreateInstanceAsAdmin(
  aHWnd: HWND;           // parent for elevation prompt window
  const aClassID: TGUID; // COM class guid
  const aIID: TGUID;     // interface id implemented by class
  out aObj               // interface pointer
);

implementation

uses
  ActiveX, ComObj;

type
  // Vista SDK - extended BIND_OPTS2 struct
  BIND_OPTS3 = packed record
    cbStruct:            DWORD;
    grfFlags:            DWORD;
    grfMode:             DWORD;
    dwTickCountDeadline: DWORD;
    dwTrackFlags:        DWORD;
    dwClassContext:      DWORD;
    locale:              LCID;
    pServerInfo:         PCOSERVERINFO;
    hwnd:                HWND;
  end;
  PBIND_OPTS3 = ^BIND_OPTS3;

  // Vista SDK - extended TOKEN_INFORMATION_CLASS enum
  TOKEN_INFORMATION_CLASS = (
    TokenICPad, // dummy padding element
    TokenUser,
    TokenGroups,
    TokenPrivileges,
    TokenOwner,
    TokenPrimaryGroup,
    TokenDefaultDacl,
    TokenSource,
    TokenType,
    TokenImpersonationLevel,
    TokenStatistics,
    TokenRestrictedSids,
    TokenSessionId,
    TokenGroupsAndPrivileges,
    TokenSessionReference,
    TokenSandBoxInert,
    TokenAuditPolicy,
    TokenOrigin,
    TokenElevationType,
    TokenLinkedToken,
    TokenElevation,
    TokenHasRestrictions,
    TokenAccessInformation,
    TokenVirtualizationAllowed,
    TokenVirtualizationEnabled,
    TokenIntegrityLevel,
    TokenUIAccess,
	TokenMandatoryPolicy,
    TokenLogonSid,
    MaxTokenInfoClass  // MaxTokenInfoClass should always be the last enum
  );

  TOKEN_ELEVATION = packed record
    TokenIsElevated: DWORD;
  end;
  PTOKEN_ELEVATION = ^TOKEN_ELEVATION;

function CoGetObject(pszName: PWideChar; pBindOptions: PBIND_OPTS3;
  const iid: TIID; out ppv
): HResult; stdcall; external 'ole32.dll' name 'CoGetObject';

function GetTokenInformation(TokenHandle: THandle;
  TokenInformationClass: TOKEN_INFORMATION_CLASS; TokenInformation: Pointer;
  TokenInformationLength: DWORD; var ReturnLength: DWORD
): BOOL; stdcall; external advapi32 name 'GetTokenInformation';

function IsElevated: Boolean;
var
  Token: THandle;
  Elevation: TOKEN_ELEVATION;
  Dummy: Cardinal;
begin
  Result := False;
  
  if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, Token) then begin
    Dummy := 0;
    if GetTokenInformation(Token, TokenElevation, @Elevation,
      SizeOf(TOKEN_ELEVATION), Dummy)
    then
      Result := (Elevation.TokenIsElevated <> 0);

    CloseHandle(Token);
  end;
end;

procedure CoCreateInstanceAsAdmin(aHWnd: HWND; const aClassID, aIID: TGUID;
  out aObj);
var
  BO: BIND_OPTS3;
  MonikerName: WideString;
begin
  if (not IsElevated) then begin
    { Request elevated out-of-process instance. }
    MonikerName := 'Elevation:Administrator!new:' + GUIDToString(aClassID);

    FillChar(BO, SizeOf(BIND_OPTS3), 0);
    BO.cbStruct := SizeOf(BIND_OPTS3);
    BO.dwClassContext := CLSCTX_LOCAL_SERVER;
	BO.hwnd := aHWnd;

    OleCheck(CoGetObject(PWideChar(MonikerName), @BO, aIID, aObj));
  end else
    { Request normal in-process instance. }
    OleCheck(CoCreateInstance(aClassID, nil, CLSCTX_ALL, aIID, aObj));
end;

end.
