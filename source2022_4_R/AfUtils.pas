{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Common functions and classes used in AsyncFree                     |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.0 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is AsyncFree Library.                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Petr Vones (Czech Republic).   |
| Portions created by Petr Vones are Copyright (C) 1998, 1999.                 |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History:                                                                     |
|   see AfRegister.pas
advanced with A  advapi32  = 'advapi32.dll';   for mX4
                                                      |
|==============================================================================}

unit AfUtils;

{$I PVDEFINE.INC}

interface

uses
  Classes, Windows;

type
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;

  PKOLChar = PChar;

  procedure SafeCloseHandle(var Handle: THandle);

  procedure ExchangeInteger(X1, X2: Integer);

  procedure FillInteger(const Buffer; Size, Value: Integer);

  function LongMulDiv(Mult1, Mult2, Div1: Longint): Longint; stdcall;

{$IFDEF PV_D2}
  function CompareMem(P1, P2: Pointer; Length: Integer): Boolean;
{$ENDIF}


 function AbortSystemShutdown(lpMachineName: PKOLChar): BOOL; stdcall;
    function AccessCheckAndAuditAlarm(SubsystemName: PKOLChar;
      HandleId: Pointer; ObjectTypeName, ObjectName: PKOLChar;
      SecurityDescriptor: PSecurityDescriptor; DesiredAccess: DWORD;
      const GenericMapping: TGenericMapping;  ObjectCreation: BOOL;
      var GrantedAccess: DWORD; var AccessStatus, pfGenerateOnClose: BOOL): BOOL; stdcall;
    function AccessCheckByTypeAndAuditAlarm(SubsystemName: PKOLChar;
      HandleId: Pointer; ObjectTypeName, ObjectName: PKOLChar;
      SecurityDescriptor: PSecurityDescriptor; PrincipalSelfSid: PSID; DesiredAccess: DWORD;
      AuditType: AUDIT_EVENT_TYPE; Flags: DWORD; ObjectTypeList: PObjectTypeList;
      ObjectTypeListLength: DWORD; const GenericMapping: TGenericMapping;  ObjectCreation: BOOL;
      var GrantedAccess: DWORD; var AccessStatus, pfGenerateOnClose: BOOL): BOOL; stdcall;
    function AccessCheckByTypeResultListAndAuditAlarm(SubsystemName: PKOLChar;
      HandleId: Pointer; ObjectTypeName, ObjectName: PKOLChar;
      SecurityDescriptor: PSecurityDescriptor; PrincipalSelfSid: PSID; DesiredAccess: DWORD;
      AuditType: AUDIT_EVENT_TYPE; Flags: DWORD; ObjectTypeList: PObjectTypeList;
      ObjectTypeListLength: DWORD; const GenericMapping: TGenericMapping;  ObjectCreation: BOOL;
      var GrantedAccess: DWORD; var AccessStatusList: DWORD; var pfGenerateOnClose: BOOL): BOOL; stdcall;
    function BackupEventLog(hEventLog: THandle; lpBackupFileName: PKOLChar): BOOL; stdcall;
    function ClearEventLog(hEventLog: THandle; lpBackupFileName: PKOLChar): BOOL; stdcall;
    function CreateProcessAsUser(hToken: THandle; lpApplicationName: PKOLChar;
      lpCommandLine: PKOLChar; lpProcessAttributes: PSecurityAttributes;
      lpThreadAttributes: PSecurityAttributes; bInheritHandles: BOOL;
      dwCreationFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: PKOLChar;
      const lpStartupInfo: TStartupInfo; var lpProcessInformation: TProcessInformation): BOOL; stdcall;
    function GetCurrentHwProfile(var lpHwProfileInfo: THWProfileInfo): BOOL; stdcall;
    function GetFileSecurity(lpFileName: PKOLChar; RequestedInformation: SECURITY_INFORMATION;
      pSecurityDescriptor: PSecurityDescriptor; nLength: DWORD; var lpnLengthNeeded: DWORD): BOOL; stdcall;
    function GetUserName(lpBuffer: PKOLChar; var nSize: DWORD): BOOL; stdcall;
    function InitiateSystemShutdown(lpMachineName, lpMessage: PKOLChar;
      dwTimeout: DWORD; bForceAppsClosed, bRebootAfterShutdown: BOOL): BOOL; stdcall;
    function LogonUser(lpszUsername, lpszDomain, lpszPassword: PKOLChar;
      dwLogonType, dwLogonProvider: DWORD; var phToken: THandle): BOOL; stdcall;
    function LookupAccountName(lpSystemName, lpAccountName: PKOLChar;
      Sid: PSID; var cbSid: DWORD; ReferencedDomainName: PKOLChar;
      var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL; stdcall;
    function LookupAccountSid(lpSystemName: PKOLChar; Sid: PSID;
      Name: PKOLChar; var cbName: DWORD; ReferencedDomainName: PKOLChar;
      var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL; stdcall;
    function LookupPrivilegeDisplayName(lpSystemName, lpName: PKOLChar;
      lpDisplayName: PKOLChar; var cbDisplayName, lpLanguageId: DWORD): BOOL; stdcall;
    function LookupPrivilegeName(lpSystemName: PKOLChar;
      var lpLuid: TLargeInteger; lpName: PKOLChar; var cbName: DWORD): BOOL; stdcall;
    function LookupPrivilegeValue(lpSystemName, lpName: PKOLChar;
      var lpLuid: TLargeInteger): BOOL; stdcall;
    function ObjectCloseAuditAlarm(SubsystemName: PKOLChar;
      HandleId: Pointer; GenerateOnClose: BOOL): BOOL; stdcall;
    function ObjectDeleteAuditAlarm(SubsystemName: PKOLChar;
      HandleId: Pointer; GenerateOnClose: BOOL): BOOL; stdcall;
    function ObjectOpenAuditAlarm(SubsystemName: PKOLChar; HandleId: Pointer;
      ObjectTypeName: PKOLChar; ObjectName: PKOLChar; pSecurityDescriptor: PSecurityDescriptor;
      ClientToken: THandle; DesiredAccess, GrantedAccess: DWORD;
      var Privileges: TPrivilegeSet; ObjectCreation, AccessGranted: BOOL;
      var GenerateOnClose: BOOL): BOOL; stdcall;
    function ObjectPrivilegeAuditAlarm(SubsystemName: PKOLChar;
      HandleId: Pointer; ClientToken: THandle; DesiredAccess: DWORD;
      var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL; stdcall;
    function OpenBackupEventLog(lpUNCServerName, lpFileName: PKOLChar): THandle; stdcall;
    function OpenEventLog(lpUNCServerName, lpSourceName: PKOLChar): THandle; stdcall;
    function PrivilegedServiceAuditAlarm(SubsystemName, ServiceName: PKOLChar;
      ClientToken: THandle; var Privileges: TPrivilegeSet; AccessGranted: BOOL): BOOL; stdcall;
    function ReadEventLog(hEventLog: THandle; dwReadFlags, dwRecordOffset: DWORD;
      lpBuffer: Pointer; nNumberOfBytesToRead: DWORD;
      var pnBytesRead, pnMinNumberOfBytesNeeded: DWORD): BOOL; stdcall;
    function RegConnectRegistry(lpMachineName: PKOLChar; hKey: HKEY;
      var phkResult: HKEY): Longint; stdcall;
    function RegCreateKey(hKey: HKEY; lpSubKey: PKOLChar;
      var phkResult: HKEY): Longint; stdcall;
    function RegCreateKeyEx(hKey: HKEY; lpSubKey: PKOLChar;
      Reserved: DWORD; lpClass: PKOLChar; dwOptions: DWORD; samDesired: REGSAM;
      lpSecurityAttributes: PSecurityAttributes; var phkResult: HKEY;
      lpdwDisposition: PDWORD): Longint; stdcall;
    function RegDeleteKey(hKey: HKEY; lpSubKey: PKOLChar): Longint; stdcall;
    function RegDeleteValue(hKey: HKEY; lpValueName: PKOLChar): Longint; stdcall;
    function RegEnumKeyEx(hKey: HKEY; dwIndex: DWORD; lpName: PKOLChar;
      var lpcbName: DWORD; lpReserved: Pointer; lpClass: PKOLChar;
      lpcbClass: PDWORD; lpftLastWriteTime: PFileTime): Longint; stdcall;
    function RegEnumKey(hKey: HKEY; dwIndex: DWORD; lpName: PKOLChar; cbName: DWORD): Longint; stdcall;
    function RegEnumValue(hKey: HKEY; dwIndex: DWORD; lpValueName: PKOLChar;
      var lpcbValueName: DWORD; lpReserved: Pointer; lpType: PDWORD;
      lpData: PByte; lpcbData: PDWORD): Longint; stdcall;
    function RegLoadKey(hKey: HKEY; lpSubKey, lpFile: PKOLChar): Longint; stdcall;
    function RegOpenKey(hKey: HKEY; lpSubKey: PKOLChar; var phkResult: HKEY): Longint; stdcall;
    function RegCloseKey(hKey: HKEY): Longint; stdcall;
    function RegOpenKeyEx(hKey: HKEY; lpSubKey: PKOLChar;
      ulOptions: DWORD; samDesired: REGSAM; var phkResult: HKEY): Longint; stdcall;
    function RegQueryInfoKey(hKey: HKEY; lpClass: PKOLChar;
      lpcbClass: PDWORD; lpReserved: Pointer;
      lpcSubKeys, lpcbMaxSubKeyLen, lpcbMaxClassLen, lpcValues,
      lpcbMaxValueNameLen, lpcbMaxValueLen, lpcbSecurityDescriptor: PDWORD;
      lpftLastWriteTime: PFileTime): Longint; stdcall;
    function RegQueryMultipleValues(hKey: HKEY; var ValList;
      NumVals: DWORD; lpValueBuf: PKOLChar; var ldwTotsize: DWORD): Longint; stdcall;
    function RegQueryValue(hKey: HKEY; lpSubKey: PKOLChar;
      lpValue: PKOLChar; var lpcbValue: Longint): Longint; stdcall;
    function RegQueryValueEx(hKey: HKEY; lpValueName: PKOLChar;
      lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall;
    function RegReplaceKey(hKey: HKEY; lpSubKey: PKOLChar;
       lpNewFile: PKOLChar; lpOldFile: PKOLChar): Longint; stdcall;
    function RegRestoreKey(hKey: HKEY; lpFile: PKOLChar; dwFlags: DWORD): Longint; stdcall;
    function RegSaveKey(hKey: HKEY; lpFile: PKOLChar;
      lpSecurityAttributes: PSecurityAttributes): Longint; stdcall;
    function RegSetValue(hKey: HKEY; lpSubKey: PKOLChar;
      dwType: DWORD; lpData: PKOLChar; cbData: DWORD): Longint; stdcall;
    function RegSetValueEx(hKey: HKEY; lpValueName: PKOLChar;
      Reserved: DWORD; dwType: DWORD; lpData: Pointer; cbData: DWORD): Longint; stdcall;
    function RegUnLoadKey(hKey: HKEY; lpSubKey: PKOLChar): Longint; stdcall;
    function RegisterEventSource(lpUNCServerName, lpSourceName: PKOLChar): THandle; stdcall;
    function ReportEvent(hEventLog: THandle; wType, wCategory: Word;
      dwEventID: DWORD; lpUserSid: Pointer; wNumStrings: Word;
      dwDataSize: DWORD; lpStrings, lpRawData: Pointer): BOOL; stdcall;
    function SetFileSecurity(lpFileName: PKOLChar; SecurityInformation: SECURITY_INFORMATION;
      pSecurityDescriptor: PSecurityDescriptor): BOOL; stdcall;


implementation

procedure SafeCloseHandle(var Handle: THandle);
begin
  if (Handle <> INVALID_HANDLE_VALUE) and CloseHandle(Handle) then
    Handle := INVALID_HANDLE_VALUE;
end;

procedure ExchangeInteger(X1, X2: Integer); register; assembler;
asm
        XCHG EAX, EDX 
end;


procedure FillInteger(const Buffer; Size, Value: Integer); register; assembler;
asm
        PUSH EDI
        MOV  EDI, EAX
        XCHG ECX, EDX
        MOV  EAX, EDX
        REP  STOSD
        POP  EDI
end;

function LongMulDiv(Mult1, Mult2, Div1: Longint): Longint; stdcall;
  external 'kernel32.dll' name 'MulDiv';

  //type

    function AbortSystemShutdown; external advapi32 name 'AbortSystemShutdownW';
    function AccessCheckAndAuditAlarm; external advapi32 name 'AccessCheckAndAuditAlarmW';
    function AccessCheckByTypeAndAuditAlarm; external advapi32 name 'AccessCheckByTypeAndAuditAlarmW';
    function AccessCheckByTypeResultListAndAuditAlarm; external advapi32 name 'AccessCheckByTypeResultListAndAuditAlarmW';
    function BackupEventLog; external advapi32 name 'BackupEventLogW';
    function ClearEventLog; external advapi32 name 'ClearEventLogW';
    function CreateProcessAsUser; external advapi32 name 'CreateProcessAsUserW';
    function GetCurrentHwProfile; external advapi32 name 'GetCurrentHwProfileW';
    function GetFileSecurity; external advapi32 name 'GetFileSecurityW';
    function GetUserName; external advapi32 name 'GetUserNameW';
    function InitiateSystemShutdown; external advapi32 name 'InitiateSystemShutdownW';
    function LogonUser; external advapi32 name 'LogonUserW';
    function LookupAccountName; external advapi32 name 'LookupAccountNameW';
    function LookupAccountSid; external advapi32 name 'LookupAccountSidW';
    function LookupPrivilegeDisplayName; external advapi32 name 'LookupPrivilegeDisplayNameW';
    function LookupPrivilegeName; external advapi32 name 'LookupPrivilegeNameW';
    function LookupPrivilegeValue; external advapi32 name 'LookupPrivilegeValueW';
    function ObjectCloseAuditAlarm; external advapi32 name 'ObjectCloseAuditAlarmW';
    function ObjectDeleteAuditAlarm; external advapi32 name 'ObjectDeleteAuditAlarmW';
    function ObjectOpenAuditAlarm; external advapi32 name 'ObjectOpenAuditAlarmW';
    function ObjectPrivilegeAuditAlarm; external advapi32 name 'ObjectPrivilegeAuditAlarmW';
    function OpenBackupEventLog; external advapi32 name 'OpenBackupEventLogW';
    function OpenEventLog; external advapi32 name 'OpenEventLogW';
    function PrivilegedServiceAuditAlarm; external advapi32 name 'PrivilegedServiceAuditAlarmW';
    function ReadEventLog; external advapi32 name 'ReadEventLogW';
    function RegConnectRegistry; external advapi32 name 'RegConnectRegistryW';
    function RegCreateKey; external advapi32 name 'RegCreateKeyW';
    function RegCreateKeyEx; external advapi32 name 'RegCreateKeyExW';
    function RegDeleteKey; external advapi32 name 'RegDeleteKeyW';
    function RegDeleteValue; external advapi32 name 'RegDeleteValueW';
    function RegEnumKeyEx; external advapi32 name 'RegEnumKeyExW';
    function RegEnumKey; external advapi32 name 'RegEnumKeyW';
    function RegEnumValue; external advapi32 name 'RegEnumValueW';
    function RegLoadKey; external advapi32 name 'RegLoadKeyW';
    function RegOpenKey; external advapi32 name 'RegOpenKeyW';
    function RegCloseKey; external advapi32 name 'RegCloseKey';
    function RegOpenKeyEx; external advapi32 name 'RegOpenKeyExW';
    function RegQueryInfoKey; external advapi32 name 'RegQueryInfoKeyW';
    function RegQueryMultipleValues; external advapi32 name 'RegQueryMultipleValuesW';
    function RegQueryValue; external advapi32 name 'RegQueryValueW';
    function RegQueryValueEx; external advapi32 name 'RegQueryValueExW';
    function RegReplaceKey; external advapi32 name 'RegReplaceKeyW';
    function RegRestoreKey; external advapi32 name 'RegRestoreKeyW';
    function RegSaveKey; external advapi32 name 'RegSaveKeyW';
    function RegSetValue; external advapi32 name 'RegSetValueW';
    function RegSetValueEx; external advapi32 name 'RegSetValueExW';
    function RegUnLoadKey; external advapi32 name 'RegUnLoadKeyW';
    function RegisterEventSource; external advapi32 name 'RegisterEventSourceW';
    function ReportEvent; external advapi32 name 'ReportEventW';
    function SetFileSecurity; external advapi32 name 'SetFileSecurityW';


{$IFDEF PV_D2}
function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SHR     ECX,2
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
        POP     ESI
end;
{$ENDIF}

end.
