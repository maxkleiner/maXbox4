{
  KLib Version = 2.0
  The Clear BSD License      - adapt to maXbox4
  TODO: fixedGetNamedSecurityInfo(    - fix

  Copyright (c) 2020 by Karol De Nery Ortiz LLave. All rights reserved.
  zitrokarol@gmail.com

  Redistribution and use in source and binary forms, with or without
  modification, are permitted (subject to the limitations in the disclaimer
  below) provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  * Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

  NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
  THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
}

unit KLibWindows;

interface

uses
  KLibTypes, KlibConstants,
  Windows, ShellApi, {Winapi.}AccCtrl, {Winapi.}ACLAPI,
  {System.}Classes;

procedure downloadFile(info: TDownloadInfo; forceOverwrite: boolean);
function getFirstPortAvaliable(defaultPort: integer; host: string = LOCALHOST_IP_ADDRESS): integer;
function checkIfPortIsAvaliable(host: string; port: Word): boolean;
function checkIfAddressIsLocalhost(address: string): boolean;
function getIPFromHostName(hostName: string): string; //if hostname is alredy an ip address, returns hostname
function getIP: string;

function checkIfRunUnderWine: boolean;
function checkIfWindowsArchitectureIsX64: boolean;

type
  TWindowsArchitecture = (WindowsX86, WindowsX64);
function getWindowsArchitecture: TWindowsArchitecture;
function checkIfUserIsAdmin: boolean;
function IsUserAnAdmin: boolean; external shell32; //KEPT THE SIGNATURE, NOT RENAME!!!

type
  TShowWindowType = (
    _SW_HIDE = Windows.SW_HIDE,
    _SW_SHOWNORMAL = Windows.SW_SHOWNORMAL,
    _SW_NORMAL = Windows.SW_NORMAL,
    _SW_SHOWMINIMIZED = Windows.SW_SHOWMINIMIZED,
    _SW_SHOWMAXIMIZED = Windows.SW_SHOWMAXIMIZED,
    _SW_MAXIMIZE = Windows.SW_MAXIMIZE,
    _SW_SHOWNOACTIVATE = Windows.SW_SHOWNOACTIVATE,
    _SW_SHOW = Windows.SW_SHOW,
    _SW_MINIMIZE = Windows.SW_MINIMIZE,
    _SW_SHOWMINNOACTIVE = Windows.SW_SHOWMINNOACTIVE,
    _SW_SHOWNA = Windows.SW_SHOWNA,
    _SW_RESTORE = Windows.SW_RESTORE,
    _SW_SHOWDEFAULT = Windows.SW_SHOWDEFAULT,
    //_SW_FORCEMINIMIZE = SW_FORCEMINIMIZE,
    _SW_MAX = Windows.SW_MAX
    );

procedure openWebPageWithDefaultBrowser(url: string);
function shellExecuteOpen(fileName: string; params: string = ''; directory: string = ''; showWindowType: TShowWindowType = _SW_NORMAL;
  exceptionIfFunctionFails: boolean = false): integer;

function shellExecuteExeAsAdmin(fileName: string; params: string = ''; showWindowType: TShowWindowType = _SW_HIDE;
  exceptionIfFunctionFails: boolean = false): integer;
function shellExecuteExe(fileName: string; params: string = ''; showWindowType: TShowWindowType = _SW_HIDE;
  exceptionIfFunctionFails: boolean = false; operation: string = 'open'): integer;
function myShellExecute(handle: integer; operation: string; fileName: string; params: string;
  directory: string; showWindowType: TShowWindowType; exceptionIfFunctionFails: boolean = false): integer;

function shellExecuteExCMDAndWait(params: string; runAsAdmin: boolean = false;
  showWindowType: TShowWindowType = _SW_HIDE; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;
function shellExecuteExAndWait(fileName: string; params: string = ''; runAsAdmin: boolean = false;
  showWindowType: TShowWindowType = _SW_HIDE; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;
function executeAndWaitExe(fileName: string; params: string = ''; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;

function netShare(targetDir: string; netName: string = ''; netPassw: string = '';
  grantAllPermissionToEveryoneGroup: boolean = false): string;
procedure addTCP_IN_FirewallException(ruleName: string; port: Word; description: string = ''; grouping: string = '';
  executable: string = '');
procedure deleteFirewallException(ruleName: string);

//#####################################################################################
type
  TExplicitAccess = EXPLICIT_ACCESS_A;
procedure grantAllPermissionsNetToTheObjectForTheEveryoneGroup(myObject: string);
procedure grantAllPermissionsNetToTheObjectForTheUsersGroup(myObject: string);
procedure grantAllPermissionNetToTheObject(windowsGroupOrUser: string; myObject: string);
//--------------------------------------------------------------------------------------
procedure grantAllPermissionsToTheObjectForTheEveryoneGroup(myObject: string);
procedure grantAllPermissionsToTheObjectForTheUsersGroup(myObject: string);
procedure grantAllPermissionsToTheObject(windowsGroupOrUser: string; myObject: string);
//--------------------------------------------------------------------------------------
procedure grantAllPermissionsToTheObjectForTheEveryoneGroup2(myObject: string);
procedure grantAllPermissionsToTheObjectForTheUsersGroup2(myObject: string);
procedure grantAllPermissionsToTheObject2(windowsGroupOrUser: string; myObject: string);
//#################################################################################

function checkIfWindowsGroupOrUserExists(windowsGroupOrUser: string): boolean;

procedure createDesktopLink(fileName: string; nameDesktopLink: string; description: string);
function getDesktopDirPath: string;

procedure copyDirIntoTargetDir(sourceDir: string; targetDir: string; forceOverwrite: boolean = false);
procedure copyDir(sourceDir: string; destinationDir: string; silent: boolean = true);
procedure createHideDir(dirName: string; forceDelete: boolean = false);
procedure deleteDirectoryIfExists(dirName: string; silent: boolean = true);

procedure myMoveFile(sourceFileName: string; targetFileName: string);

procedure createEmptyFileIfNotExists(filename: string);
procedure createEmptyFile(filename: string);

function checkIfIsWindowsSubDir(subDir: string; mainDir: string): boolean;
function getParentDir(source: string): string;
function getValidFullPathInWindowsStyle(path: string): string;
function getPathInWindowsStyle(path: string): string;

function getStringWithEnvVariablesReaded(source: string): string;
//-----------------------------------------------------------------
//TODO REFACTOR
function setProcessWindowToForeground(processName: string): boolean;
function getPIDOfCurrentUserByProcessName(nameProcess: string): DWORD;
function getWindowsUsername: string;
function checkUserOfProcess(userName: String; PID: DWORD): boolean;
function getPIDCredentials(PID: DWORD): TPIDCredentials;
function getPIDByProcessName(nameProcess: string): DWORD;
function getMainWindowHandleByPID(PID: DWORD): DWORD;
//------------------------------------------------------------------

procedure closeApplication(handle: THandle);
function sendMemoryStreamUsing_WM_COPYDATA(handle: THandle; data: TMemoryStream): integer;
function sendStringUsing_WM_COPYDATA(handle: THandle; data: string; msgIdentifier: integer = 0): integer;
procedure mySetForegroundWindow(handle: THandle);
function checkIfWindowExists(className: string = 'TMyForm'; captionForm: string = 'Caption of MyForm'): boolean;
function myFindWindow(className: string = 'TMyForm'; captionForm: string = 'Caption of MyForm'): THandle;

function checkIfExistsKeyIn_HKEY_LOCAL_MACHINE(key: string): boolean;

procedure waitForMultiple(processHandle: THandle; timeout: DWORD = INFINITE; modalMode: boolean = true);
procedure waitFor(processHandle: THandle; timeout: DWORD = INFINITE; modalMode: boolean = true);

procedure raiseLastSysErrorMessage;
function getLastSysErrorMessage: string;

function getLocaleDecimalSeparator: char;

procedure terminateCurrentProcess(exitCode: Cardinal = 0; raiseExceptionEnabled: boolean = false);
procedure myTerminateProcess(processHandle: THandle; exitCode: Cardinal = 0; raiseExceptionEnabled: boolean = false);

//################################################################################�
(*
function fixedGetNamedSecurityInfo(pObjectName: LPWSTR; ObjectType: SE_OBJECT_TYPE;
  SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID; ppDacl, ppSacl: PPACL;
  var ppSecurityDescriptor: PSECURITY_DESCRIPTOR): DWORD; stdcall;
  external 'ADVAPI32.DLL' name 'GetNamedSecurityInfoW';    *)

implementation

uses
  KLibUtils, //KLib.Validate, KLib.MyStringList,
  Forms,
  TLHelp32, ActiveX, Shlobj, Winsock, UrlMon, Messages,
  SysUtils, ComObj, Registry,
  IdTCPClient;


procedure validateMD5File(fileName: string; MD5: string; errMsg: string = 'MD5 check failed.');
var
  _errMsg: string;
begin
  if not checkMD5File(fileName, MD5) then
  begin
    _errMsg := getDoubleQuotedString(fileName) + ' : ' + errMsg;
    raise Exception.Create(_errMsg);
  end;
end;

procedure downloadFile(info: TDownloadInfo; forceOverwrite: boolean);
const
  ERR_MSG = 'Error downloading file.';
var
  _downloadSuccess: boolean;
  _links: TStringList;
  i: integer;
begin
  if forceOverwrite then
  begin
    deleteFileIfExists(info.fileName);
  end;

  _downloadSuccess := false;
  i := 0;
  _links := TStringList.Create;
  _links.Add(info.link);
  //_links.AddStrings(TStrings(info.alternative_links[0]));
   _links.AddStrings(TStrings(info.alternative_links));
  try
    while (not _downloadSuccess) and (i < _links.Count) do
    begin
      _downloadSuccess := URLDownloadToFile(nil, pChar(_links[i]), pchar(info.fileName), 0, nil) = S_OK;
      Inc(i);
    end;
  finally
    FreeAndNil(_links);
  end;

  if not _downloadSuccess then
  begin
    raise Exception.Create(ERR_MSG);
  end;
  if info.MD5 <> '' then
  begin
    validateMD5File(info.fileName, info.MD5, ERR_MSG);
  end;
end;

function getFirstPortAvaliable(defaultPort: integer; host: string = LOCALHOST_IP_ADDRESS): integer;
var
  port: integer;
begin
  port := defaultPort;
  while not checkIfPortIsAvaliable(host, port) do
  begin
    inc(port);
  end;

  Result := port;
end;

function checkIfPortIsAvaliable(host: string; port: Word): boolean;
var
  isPortAvaliable: boolean;

  _IdTCPClient: TIdTCPClient;
begin
  isPortAvaliable := True;
  try
    _IdTCPClient := TIdTCPClient.Create(nil);
    try
      _IdTCPClient.Host := host;
      _IdTCPClient.Port := port;
      _IdTCPClient.Connect;
      isPortAvaliable := False;
    finally
      _IdTCPClient.Free;
    end;
  except
    //Ignore exceptions
  end;

  Result := isPortAvaliable;
end;

function checkIfAddressIsLocalhost(address: string): boolean;
var
  addressIsLocalhost: boolean;

  _address: string;
  _localhostIP_address: string;
begin
  addressIsLocalhost := true;
  _address := getIPFromHostName(address);
  if _address <> LOCALHOST_IP_ADDRESS then
  begin
    _localhostIP_address := getIP;
    if _address <> _localhostIP_address then
    begin
      addressIsLocalhost := false;
    end;
  end;

  Result := addressIsLocalhost;
end;

function getIPFromHostName(hostName: string): string;
const
  ERR_WINSOCK_MSG = 'Winsock initialization error.';
  ERR_NO_IP_FOUND_WITH_HOSTBAME_MSG = 'No IP found with hostname: ';
var
  ip: string;

  _varTWSAData: TWSAData;
  _varPHostEnt: PHostEnt;
  _varTInAddr: TInAddr;
begin
  if WSAStartup($101, _varTWSAData) <> 0 then
  begin
    raise Exception.Create(ERR_WINSOCK_MSG);
  end
  else
  begin
    try
      _varPHostEnt := gethostbyname(PAnsiChar(AnsiString(hostName)));
      _varTInAddr := PInAddr(_varPHostEnt^.h_Addr_List^)^;
      ip := String(inet_ntoa(_varTInAddr));
    except
      on E: Exception do
      begin
        WSACleanup;
        raise Exception.Create(ERR_NO_IP_FOUND_WITH_HOSTBAME_MSG + hostName);
      end;
    end;
  end;
  WSACleanup;

  Result := ip;
end;

function getIP: string;
type
  pu_long = ^u_long;
const
  ERR_MSG = 'Winsock initialization error.';
var
  ip: string;

  _varTWSAData: TWSAData;
  _varPHostEnt: PHostEnt;
  _varTInAddr: TInAddr;
  _namebuf: Array [0 .. 255] of ansichar;
begin
  if WSAStartup($101, _varTWSAData) <> 0 then
  begin
    raise Exception.Create(ERR_MSG);
  end
  else
  begin
    getHostName(_nameBuf, sizeOf(_nameBuf));
    _varPHostEnt := gethostbyname(_nameBuf);
    _varTInAddr.S_addr := u_long(pu_long(_varPHostEnt^.h_addr_list^)^);
    ip := string(inet_ntoa(_varTInAddr));
  end;
  WSACleanup;

  Result := ip;
end;

function checkIfRunUnderWine: boolean;
const
  KEY_WINE = 'Software\Wine';
begin
  Result := checkIfExistsKeyIn_HKEY_LOCAL_MACHINE(KEY_WINE);
end;

function checkIfWindowsArchitectureIsX64: boolean;
var
  _windowsArchitecture: TWindowsArchitecture;
begin
  _windowsArchitecture := getWindowsArchitecture;

  Result := _windowsArchitecture = {TWindowsArchitecture.}WindowsX64;
end;

function getWindowsArchitecture: TWindowsArchitecture;
const
  ERR_MSG_PLATFORM = 'The OS. is not Windows.';
  ERR_MSG_ARCHITECTURE = 'Unknown OS architecture.';
var
  windowsArchitecture: TWindowsArchitecture;
begin
  {if TOSVersion.Platform <> pfWindows then
  begin
    raise Exception.Create(ERR_MSG_PLATFORM);
  end;
  case TOSVersion.Architecture of
    arIntelX86:
      windowsArchitecture := TWindowsArchitecture.WindowsX86;
    arIntelX64:
      windowsArchitecture := TWindowsArchitecture.WindowsX64;
  else
    begin
      raise Exception.Create(ERR_MSG_ARCHITECTURE);
    end;  }
  //end;

  Result := windowsArchitecture;
end;

function checkIfUserIsAdmin: boolean;
begin
  Result := IsUserAnAdmin;
end;

procedure openWebPageWithDefaultBrowser(url: string);
begin
  shellExecuteOpen(url);
end;

function shellExecuteOpen(fileName: string; params: string = ''; directory: string = ''; showWindowType: TShowWindowType = _SW_NORMAL;
  exceptionIfFunctionFails: boolean = false): integer;
var
  returnCode: integer;
begin
  returnCode := myShellExecute(0, 'open', fileName, params, directory, showWindowType, exceptionIfFunctionFails);

  Result := returnCode;
end;

function shellExecuteExeAsAdmin(fileName: string; params: string = ''; showWindowType: TShowWindowType = _SW_HIDE;
  exceptionIfFunctionFails: boolean = false): integer;
var
  returnCode: integer;
begin
  returnCode := shellExecuteExe(fileName, params, showWindowType, exceptionIfFunctionFails, 'runas');

  Result := returnCode;
end;

function shellExecuteExe(fileName: string; params: string = ''; showWindowType: TShowWindowType = _SW_HIDE;
  exceptionIfFunctionFails: boolean = false; operation: string = 'open'): integer;
var
  returnCode: integer;

  _directory: string;
begin
  _directory := ExtractFileDir(fileName);
  returnCode := myShellExecute(0, operation, getDoubleQuotedString(fileName), params, _directory, showWindowType, exceptionIfFunctionFails);

  Result := returnCode;
end;

function myShellExecute(handle: integer; operation: string; fileName: string; params: string;
  directory: string; showWindowType: TShowWindowType; exceptionIfFunctionFails: boolean = false): integer;
var
  returnCode: integer;

  errMsg: string;
begin
  returnCode := shellExecute(handle, pchar(operation), pchar(fileName), PCHAR(trim(params)),
    pchar(directory), integer(showWindowType));

  if exceptionIfFunctionFails then
  begin
    case returnCode of
      0:
        errMsg := 'The operating system is out of memory or resources.';
      2:
        errMsg := 'The specified file was not found';
      3:
        errMsg := 'The specified path was not found.';
      5:
        errMsg := 'Windows 95 only: The operating system denied access to the specified file';
      8:
        errMsg := 'Windows 95 only: There was not enough memory to complete the operation.';
      10:
        errMsg := 'Wrong Windows version';
      11:
        errMsg := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image)';
      12:
        errMsg := 'Application was designed for a different operating system';
      13:
        errMsg := 'Application was designed for MS-DOS 4.0';
      15:
        errMsg := 'Attempt to load a real-mode program';
      16:
        errMsg := 'Attempt to load a second instance of an application with non-readonly data segments.';
      19:
        errMsg := 'Attempt to load a compressed application file.';
      20:
        errMsg := 'Dynamic-link library (DLL) file failure.';
      26:
        errMsg := 'A sharing violation occurred.';
      27:
        errMsg := 'The filename association is incomplete or invalid.';
      28:
        errMsg := 'The DDE transaction could not be completed because the request timed out.';
      29:
        errMsg := 'The DDE transaction failed.';
      30:
        errMsg := 'The DDE transaction could not be completed because other DDE transactions were being processed.';
      31:
        errMsg := 'There is no application associated with the given extension.';
      32:
        errMsg := 'Windows 95 only: The specified dynamic-link library was not found.';
    else
      errMsg := '';
    end;

    if errMsg <> '' then
    begin
      raise Exception.Create(errMsg);
    end;
  end;

  Result := returnCode;
end;

function shellExecuteExCMDAndWait(params: string; runAsAdmin: boolean = false;
  showWindowType: TShowWindowType = _SW_HIDE; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;
begin
  Result := shellExecuteExAndWait(CMD_EXE_NAME, params, runAsAdmin, showWindowType, exceptionIfReturnCodeIsNot0);
end;

function shellExecuteExAndWait(fileName: string; params: string = ''; runAsAdmin: boolean = false;
  showWindowType: TShowWindowType = _SW_HIDE; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;
var
  returnCode: Longint;

  _shellExecuteInfo: TShellExecuteInfo;
begin
  returnCode := -1;

  FillChar(_shellExecuteInfo, SizeOf(_shellExecuteInfo), 0);
  with _shellExecuteInfo do
  begin
    cbSize := SizeOf(_shellExecuteInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    if (runAsAdmin) then
    begin
      _shellExecuteInfo.lpVerb := 'runas';
    end
    else
    begin
      _shellExecuteInfo.lpVerb := '';
    end;
    _shellExecuteInfo.lpParameters := PChar(trim(params));
    lpFile := PChar(FileName);
    nShow := integer(showWindowType);
  end;
  if not ShellExecuteEx(@_shellExecuteInfo) then
  begin
    raiseLastSysErrorMessage;
  end;

  //TODO CHECK
  waitForMultiple(_shellExecuteInfo.hProcess);
  //  waitFor(_shellExecuteInfo.hProcess);

  if not GetExitCodeProcess(_shellExecuteInfo.hProcess, dword(returnCode)) then //assign return code
  begin
    raiseLastSysErrorMessage;
  end;

  CloseHandle(_shellExecuteInfo.hProcess);

  if (exceptionIfReturnCodeIsNot0) and (returnCode <> 0) then
  begin
    raise Exception.Create(fileName + ' exit code: ' + IntToStr(returnCode));
  end;

  Result := returnCode;
end;

function executeAndWaitExe(fileName: string; params: string = ''; exceptionIfReturnCodeIsNot0: boolean = false): LongInt;
var
  returnCode: Longint;

  _commad: String;
  _startupInfo: TStartupInfo;
  _processInfo: TProcessInformation;
begin
  returnCode := -1;

  _commad := getDoubleQuotedString(fileName) + ' ' + trim(params);

  FillChar(_startupInfo, sizeOf(_startupInfo), 0);
  with _startupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := Windows.SW_HIDE;
  end;
  if not CreateProcess(nil, pchar(_commad), nil, nil, false,
    //   CREATE_NO_WINDOW,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, //TODO check if is ok
    nil, nil, _startupInfo, _processInfo) then
  begin
    raiseLastSysErrorMessage;
  end;

  //TODO CHECK
  waitForMultiple(_processInfo.hProcess);
  //  waitFor(_processInfo.hProcess);

  if not GetExitCodeProcess(_processInfo.hProcess, dword(returnCode)) then //assign return code
  begin
    raiseLastSysErrorMessage;
  end;

  CloseHandle(_processInfo.hProcess);
  CloseHandle(_processInfo.hThread);

  if (exceptionIfReturnCodeIsNot0) and (returnCode <> 0) then
  begin
    raise Exception.Create(fileName + ' exit code: ' + IntToStr(returnCode));
  end;

  Result := returnCode;
end;

type
  //----------------------------------
  SHARE_INFO_2 = record
    shi2_netname: pWideChar;
    shi2_type: DWORD;
    shi2_remark: pWideChar;
    shi2_permissions: DWORD;
    shi2_max_uses: DWORD;
    shi2_current_uses: DWORD;
    shi2_path: pWideChar;
    shi2_passwd: pWideChar;
  end;

  PSHARE_INFO_2 = ^SHARE_INFO_2;

function netShareAdd(servername: PWideChar; level: DWORD; buf: Pointer; parm_err: LPDWORD): DWORD; stdcall;
  external 'NetAPI32.dll' name 'NetShareAdd';

function netShare(targetDir: string; netName: string = ''; netPassw: string = '';
  grantAllPermissionToEveryoneGroup: boolean = false): string;
const
  NERR_SUCCESS = 0;
  STYPE_DISKTREE = 0;
  STYPE_PRINTQ = 1;
  STYPE_DEVICE = 2;
  STYPE_IPC = 3;
  ACCESS_READ = $01;
  ACCESS_WRITE = $02;
  ACCESS_CREATE = $04;
  ACCESS_EXEC = $08;
  ACCESS_DELETE = $10;
  ACCESS_ATRIB = $20;
  ACCESS_PERM = $40;
  ACCESS_ALL = ACCESS_READ or ACCESS_WRITE or ACCESS_CREATE or ACCESS_EXEC or ACCESS_DELETE or ACCESS_ATRIB or ACCESS_PERM;

  ERR_MSG = 'Unable to share folder :';
var
  pathSharedDir: string;

  _targetDir: string;
  _AShareInfo: PSHARE_INFO_2;
  _parmError: DWORD;
  _shareExistsAlready: boolean;
  _errMsg: string;
begin
  _shareExistsAlready := false;
  _targetDir := getValidFullPathInWindowsStyle(targetDir);
  _AShareInfo := New(PSHARE_INFO_2);
  try
    with _AShareInfo^ do
    begin
      if (netName = '') then
      begin
        shi2_netname := PWideChar(extractfilename(_targetDir));
      end
      else
      begin
        shi2_netname := PWideChar(netName);
      end;
      shi2_type := STYPE_DISKTREE;
      shi2_remark := nil;
      shi2_permissions := ACCESS_ALL;
      shi2_max_uses := DWORD(-1); // Maximum allowed
      shi2_current_uses := 0;
      shi2_path := PWideChar(_targetDir);
      if (netPassw = '') then
      begin
        shi2_passwd := nil;
      end
      else
      begin
        shi2_passwd := PWideChar(netPassw);
      end;
    end;

    if (netShareAdd(nil, 2, PBYTE(_AShareInfo), @_parmError) <> NERR_SUCCESS) then
    begin
      _shareExistsAlready := true;
    end;
    if not DirectoryExists(pathSharedDir) then
    begin
      _errMsg := ERR_MSG + getDoubleQuotedString(_targetDir);
      raise Exception.Create(_errMsg);
    end;
    pathSharedDir := '\\' + GetEnvironmentVariable('COMPUTERNAME') + '\' + _AShareInfo.shi2_netname;
    if not(_shareExistsAlready) and (grantAllPermissionToEveryoneGroup) then
    begin
      grantAllPermissionsNetToTheObjectForTheEveryoneGroup(pathSharedDir);
    end;
  finally
    FreeMem(_AShareInfo, SizeOf(PSHARE_INFO_2));
  end;

  Result := pathSharedDir;
end;

procedure addTCP_IN_FirewallException(ruleName: string; port: Word; description: string = ''; grouping: string = '';
  executable: String = '');
const
  NET_FW_PROFILE2_DOMAIN = 1;
  NET_FW_PROFILE2_PRIVATE = 2;
  NET_FW_PROFILE2_PUBLIC = 4;

  PROFILES = NET_FW_PROFILE2_PRIVATE OR NET_FW_PROFILE2_PUBLIC OR NET_FW_PROFILE2_DOMAIN;

  NET_FW_IP_PROTOCOL_TCP = 6;
  NET_FW_ACTION_ALLOW = 1;
  NET_FW_RULE_DIR_IN = 1;
  NET_FW_RULE_DIR_OUT = 2;
var
  FwPolicy2: OleVariant;
  rules: OleVariant;
  newFWRule: OleVariant;
begin
  CoInitialize(nil);

  newFWRule := CreateOleObject('HNetCfg.FWRule');
  newFWRule.Name := ruleName;
  if (description <> '') then
  begin
    newFWRule.Description := description;
  end
  else
  begin
    newFWRule.Description := ruleName;
  end;

  if (executable <> '') then
  begin
    newFWRule.Applicationname := executable;
  end;
  newFWRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
  newFWRule.LocalPorts := port;
  newFWRule.Direction := NET_FW_RULE_DIR_IN;
  newFWRule.Enabled := TRUE;
  if (grouping <> '') then
  begin
    newFWRule.Grouping := grouping;
  end;
  newFWRule.Profiles := PROFILES;
  newFWRule.Action := NET_FW_ACTION_ALLOW;
  FwPolicy2 := CreateOleObject('HNetCfg.FwPolicy2');
  rules := FwPolicy2.Rules;
  rules.Add(newFWRule);

  CoUninitialize;
end;

procedure deleteFirewallException(ruleName: string);
var
  FwPolicy2: OleVariant;
  rules: OleVariant;
begin
  CoInitialize(nil);

  FwPolicy2 := CreateOleObject('HNetCfg.FwPolicy2');
  rules := FwPolicy2.Rules;
  rules.Remove(ruleName);

  CoUninitialize;
end;

procedure grantAllPermissionsNetToTheObjectForTheEveryoneGroup(myObject: string);
begin
  grantAllPermissionNetToTheObject(EVERYONE_GROUP, myObject);
end;

procedure grantAllPermissionsNetToTheObjectForTheUsersGroup(myObject: string);
begin
  grantAllPermissionNetToTheObject(USERS_GROUP, myObject);
end;


procedure validateThatWindowsGroupOrUserExists(windowsGroupOrUser: string; errMsg: string = 'Not exists in Windows Groups/Users.');
var
  _errMsg: string;
begin
  if not checkIfWindowsGroupOrUserExists(windowsGroupOrUser) then
  begin
    _errMsg := getDoubleQuotedString(windowsGroupOrUser) + ' : ' + errMsg;
    raise Exception.Create(_errMsg);
  end;
end;

procedure grantAllPermissionNetToTheObject(windowsGroupOrUser: string; myObject: string);
var
  NewDacl, OldDacl: PACl;
  SD: PSECURITY_DESCRIPTOR;
  EA: TExplicitAccess;
begin
  validateThatWindowsGroupOrUserExists(windowsGroupOrUser);

  //fixedGetNamedSecurityInfo(PChar(myObject), SE_LMSHARE, DACL_SECURITY_INFORMATION, nil, nil, @OldDacl, nil, SD);
  BuildExplicitAccessWithName(@EA, PChar(windowsGroupOrUser), GENERIC_ALL, GRANT_ACCESS, SUB_CONTAINERS_AND_OBJECTS_INHERIT);
  SetEntriesInAcl(1, @EA, OldDacl, NewDacl);
  SetNamedSecurityInfo(PChar(myObject), SE_LMSHARE, DACL_SECURITY_INFORMATION, nil, nil, NewDacl, nil);
end;

procedure grantAllPermissionsToTheObjectForTheEveryoneGroup(myObject: string);
begin
  grantAllPermissionsToTheObject(EVERYONE_GROUP, myObject);
end;

procedure grantAllPermissionsToTheObjectForTheUsersGroup(myObject: string);
begin
  grantAllPermissionsToTheObject(USERS_GROUP, myObject);
end;

procedure grantAllPermissionsToTheObject(windowsGroupOrUser: string; myObject: string);
var
  newDACL: PACl;
  oldDACL: PACl;
  securityDescriptor: PSECURITY_DESCRIPTOR;
  explicitAccess: TExplicitAccess;
begin
  validateThatWindowsGroupOrUserExists(windowsGroupOrUser);

  //fixedGetNamedSecurityInfo(PChar(myObject), SE_FILE_OBJECT, DACL_SECURITY_INFORMATION, nil, nil, @oldDACL,
   // nil, securityDescriptor);
  BuildExplicitAccessWithName(@explicitAccess, PChar(windowsGroupOrUser), GENERIC_ALL, GRANT_ACCESS,
    SUB_CONTAINERS_AND_OBJECTS_INHERIT);
  SetEntriesInAcl(1, @explicitAccess, oldDACL, newDACL);
  SetNamedSecurityInfo(PChar(myObject), SE_FILE_OBJECT, DACL_SECURITY_INFORMATION, nil, nil, newDACL, nil);
end;

procedure grantAllPermissionsToTheObjectForTheEveryoneGroup2(myObject: string);
begin
  grantAllPermissionsToTheObject2(EVERYONE_GROUP, myObject);
end;

procedure grantAllPermissionsToTheObjectForTheUsersGroup2(myObject: string);
begin
  grantAllPermissionsToTheObject2(USERS_GROUP, myObject);
end;

procedure grantAllPermissionsToTheObject2(windowsGroupOrUser: string; myObject: string);
begin
  validateThatWindowsGroupOrUserExists(windowsGroupOrUser);

  shellExecuteExeAsAdmin('icacls', getDoubleQuotedString(myObject) + ' /grant ' + getDoubleQuotedString(windowsGroupOrUser) + ':(OI)(CI)F /T');
end;

function checkIfWindowsGroupOrUserExists(windowsGroupOrUser: string): boolean;
var
  windowsGroupOrUserExists: boolean;

  _newDACL: PACl;
  _explicitAccess: TExplicitAccess;
begin
  BuildExplicitAccessWithName(@_explicitAccess, PChar(windowsGroupOrUser), GENERIC_ALL, GRANT_ACCESS,
    SUB_CONTAINERS_AND_OBJECTS_INHERIT);
  SetEntriesInAcl(1, @_explicitAccess, nil, _newDACL);
  windowsGroupOrUserExists := Assigned(_newDACL);

  Result := windowsGroupOrUserExists;
end;

procedure createDesktopLink(fileName: string; nameDesktopLink: string; description: string);
const
  ERR_MSG = 'Error creating desktop icon.';
var
  iobject: iunknown;
  islink: ishelllink;
  ipfile: ipersistfile;
  pidl: pitemidlist;
  infolder: array [0 .. MAX_PATH] of char;
  targetName: string;
  linkname: string;
  _desktopDirPath: string;
begin
  targetname := getValidFullPathInWindowsStyle(fileName);
  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLink;
  IPFile := IObject as IPersistFile;

  with ISLink do
  begin
    SetDescription(PChar(description));
    SetPath(PChar(targetName));
    SetWorkingDirectory(PChar(ExtractFilePath(targetName)));
  end;

  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);
  SHGetPathFromIDList(PIDL, InFolder);

  _desktopDirPath := getDesktopDirPath;
  LinkName := IncludeTrailingPathDelimiter(_desktopDirPath);
  LinkName := LinkName + nameDesktopLink + '.lnk';

  if not IPFile.Save(PWideChar(LinkName), False) = S_OK then
  begin
    raise Exception.Create(ERR_MSG);
  end;
end;

function getDesktopDirPath: string;
var
  desktopDirPath: string;

  _PIDList: PItemIDList;
  _Buffer: array [0 .. MAX_PATH - 1] of Char;
begin
  desktopDirPath := '';
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOP, _PIDList);
  if Assigned(_PIDList) then
  begin
    if SHGetPathFromIDList(_PIDList, _Buffer) then
    begin
      desktopDirPath := _Buffer;
    end;
  end;

  Result := desktopDirPath;
end;

procedure validateThatDirNotExists(dirName: string; errMsg: string = 'Directory already exists.');
var
  _errMsg: string;
begin
  if DirectoryExists(dirName) then
  begin
    _errMsg := getDoubleQuotedString(dirName) + ' : ' + errMsg;
    raise Exception.Create(_errMsg);
  end;
end;

procedure copyDirIntoTargetDir(sourceDir: string; targetDir: string; forceOverwrite: boolean = false);
const
  ERR_MSG = 'Cannot rename: ';
var
  _parentDirTargetDir: string;
  _sourceDirName: string;
  _tempTargetDir: string;

  _err_msg: string;
begin
  if forceOverwrite then
  begin
    deleteDirectoryIfExists(targetDir);
  end
  else
  begin
    validateThatDirNotExists(targetDir);
  end;

  _parentDirTargetDir := getParentDir(targetDir);
  _sourceDirName := ExtractFileName(getValidFullPathInWindowsStyle(sourceDir));
  _tempTargetDir := getCombinedPath(_parentDirTargetDir, _sourceDirName);
  copyDir(sourceDir, _parentDirTargetDir);
  if not RenameFile(_tempTargetDir, targetDir) then
  begin
    _err_msg := ERR_MSG + getDoubleQuotedString(_tempTargetDir);
    raise Exception.Create(_err_msg);
  end;
end;

const
  SILENT_FLAGS: FILEOP_FLAGS = FOF_SILENT or FOF_NOCONFIRMATION;

procedure copyDir(sourceDir: string; destinationDir: string; silent: boolean = true);
var
  sHFileOpStruct: TSHFileOpStruct;
  shFileOperationResult: integer;
begin
  ZeroMemory(@sHFileOpStruct, SizeOf(sHFileOpStruct));
  with sHFileOpStruct do
  begin
    wFunc := FO_COPY;
    pFrom := PChar(sourceDir + #0);
    pTo := PChar(destinationDir);
    if silent then
    begin
      fFlags := FOF_FILESONLY or SILENT_FLAGS;
    end
    else
    begin
      fFlags := FOF_FILESONLY;
    end;
  end;
  shFileOperationResult := ShFileOperation(sHFileOpStruct);
  if shFileOperationResult <> 0 then
  begin
    raise Exception.Create('Unable to copy ' + sourceDir + ' to ' + destinationDir);
  end;
end;

procedure createHideDir(dirName: string; forceDelete: boolean = false);
const
  ERR_MSG = 'Error creating hide dir.';
begin
  if forceDelete then
  begin
    deleteDirectoryIfExists(dirName);
  end;

  if CreateDir(dirName) then
  begin
    SetFileAttributes(pchar(dirName), FILE_ATTRIBUTE_HIDDEN);
  end
  else
  begin
    raise Exception.Create(ERR_MSG);
  end;
end;

procedure deleteDirectoryIfExists(dirName: string; silent: boolean = true);
const
  ERR_MSG = 'Unable to delete :';
var
  sHFileOpStruct: TSHFileOpStruct;
  shFileOperationResult: integer;

  errMsg: string;
begin
  if DirectoryExists(dirName) then
  begin
    ZeroMemory(@sHFileOpStruct, SizeOf(sHFileOpStruct));
    with sHFileOpStruct do
    begin
      wFunc := FO_DELETE;
      pFrom := PChar(DirName + #0); //double zero-terminated
      if silent then
      begin
        fFlags := SILENT_FLAGS;
      end
    end;
    shFileOperationResult := SHFileOperation(sHFileOpStruct);
    if (shFileOperationResult <> 0) or (DirectoryExists(dirName)) then
    begin
      errMsg := ERR_MSG + dirName;
      raise Exception.Create(errMsg);
    end;
  end;
end;

procedure myMoveFile(sourceFileName: string; targetFileName: string);
var
  _result: boolean;
begin
  _result := MoveFile(pchar(sourceFileName), pchar(targetFileName));
  if not _result then
  begin
    raiseLastSysErrorMessage;
  end;
end;

procedure createEmptyFileIfNotExists(filename: string);
begin
  if not FileExists(filename) then
  begin
    createEmptyFile(filename);
  end;
end;

procedure createEmptyFile(filename: string);
var
  _handle: THandle;
begin
  _handle := FileCreate(fileName);
  if _handle = INVALID_HANDLE_VALUE then
  begin
    raise Exception.Create('Error creating file: ' + fileName);
  end
  else
  begin
    FileClose(_handle);
  end;
end;

function checkIfIsWindowsSubDir(subDir: string; mainDir: string): boolean;
var
  isSubDir: Boolean;

  _subDir: string;
  _mainDir: string;
begin
  _subDir := getPathInWindowsStyle(subDir);
  _mainDir := getPathInWindowsStyle(mainDir);
  isSubDir := checkIfIsSubDir(_subDir, _mainDir, WINDOWS_PATH_DELIMITER);

  Result := isSubDir
end;

function getParentDir(source: string): string;
var
  parentDir: string;
begin
  parentDir := getValidFullPathInWindowsStyle(source);
  parentDir := ExtractFilePath(parentDir);

  Result := parentDir;
end;

function getValidFullPathInWindowsStyle(path: string): string;
var
  validFullPathInWindowsStyle: string;
begin
  validFullPathInWindowsStyle := getValidFullPath(path);
  validFullPathInWindowsStyle := getPathInWindowsStyle(validFullPathInWindowsStyle);

  Result := validFullPathInWindowsStyle;
end;

function getPathInWindowsStyle(path: string): string;
var
  pathInWindowsStyl: string;
begin
  pathInWindowsStyl := StringReplace(path, '/', '\', [rfReplaceAll, rfIgnoreCase]);

  Result := pathInWindowsStyl;
end;

function getStringWithEnvVariablesReaded(source: string): string;
var
  stringWithEnvVariablesReaded: string;

  _stringDir: string;
  _stringPos: string;
  _posStart: integer;
  _posEnd: integer;
  _valueToReplace: string;
  _newValue: string;
begin
  _stringPos := source;
  _stringDir := source;
  stringWithEnvVariablesReaded := source;
  repeat
    _posStart := pos('%', _stringPos);
    _stringPos := copy(_stringPos, _posStart + 1, length(_stringPos));
    _posEnd := _posStart + pos('%', _stringPos);
    if (_posStart > 0) and (_posEnd > 1) then
    begin
      _valueToReplace := copy(_stringDir, _posStart, _posEnd - _posStart + 1);
      _newValue := GetEnvironmentVariable(copy(_valueToReplace, 2, length(_valueToReplace) - 2));
      if _newValue <> '' then
      begin
        stringWithEnvVariablesReaded := stringreplace(stringWithEnvVariablesReaded, _valueToReplace, _newValue, []);
      end;
    end
    else
    begin
      exit;
    end;
    _stringDir := copy(_stringDir, _posEnd + 1, length(_stringDir));
    _stringPos := _stringDir;
  until _posStart < 0;

  Result := stringWithEnvVariablesReaded;
end;

//----------------------------------------------------------------------
function setProcessWindowToForeground(processName: string): boolean;
var
  _result: boolean;

  _PIDProcess: DWORD;
  _windowHandle: THandle;
begin
  _PIDProcess := getPIDOfCurrentUserByProcessName(processName);
  _windowHandle := getMainWindowHandleByPID(_PIDProcess);

  if _windowHandle <> 0 then
  begin
    mySetForegroundWindow(_windowHandle);
    _result := true;
  end
  else
  begin
    _result := false;
  end;

  Result := _result;
end;

type
  TProcessCompare = record
    username: string;
    nameProcess: string;
  end;

  TFunctionProcessCompare = function(processEntry: TProcessEntry32; processCompare: TProcessCompare): boolean;

function getPID(nameProcess: string; fn: TFunctionProcessCompare; processCompare: TProcessCompare): DWORD; forward;
function checkProcessUserName(processEntry: TProcessEntry32; processCompare: TProcessCompare): boolean; forward;

function getPIDOfCurrentUserByProcessName(nameProcess: string): DWORD;
var
  processCompare: TProcessCompare;
begin
  processCompare.nameProcess := nameProcess;
  processCompare.username := getWindowsUsername();

  Result := getPID(nameProcess, checkProcessUserName, processCompare);
end;

function getWindowsUsername: string;
var
  windowsUsername: string;

  _userName: string;
  _userNameLen: DWORD;
begin
  _userNameLen := 256;
  SetLength(_userName, _userNameLen);
  if GetUserName(PChar(_userName), _userNameLen) then
  begin
    windowsUsername := Copy(_userName, 1, _userNameLen - 1);
  end
  else
  begin
    windowsUsername := '';
  end;

  Result := windowsUsername;
end;

function checkProcessName(processEntry: TProcessEntry32; processCompare: TProcessCompare): boolean; forward;

function checkProcessUserName(processEntry: TProcessEntry32; processCompare: TProcessCompare): boolean; // FUNZIONE PRIVATA
var
  _sameProcessName: boolean;
  _sameUserOfProcess: boolean;
begin
  _sameProcessName := checkProcessName(processEntry, processCompare);
  _sameUserOfProcess := checkUserOfProcess(processCompare.username, processEntry.th32ProcessID);

  Result := _sameProcessName and _sameUserOfProcess;
end;

//TODO: CREARE CLASSE PER RAGGUPPARE OGGETTI

function checkUserOfProcess(userName: String; PID: DWORD): boolean;
var
  sameUser: boolean;

  _PIDCredentials: TPIDCredentials;
begin
  _PIDCredentials := getPIDCredentials(PID);
  sameUser := _PIDCredentials.ownerUserName = userName;

  Result := sameUser;
end;

type
  _TOKEN_USER = record
    User: TSidAndAttributes;
  end;

  PTOKEN_USER = ^_TOKEN_USER;

function getPIDCredentials(PID: DWORD): TPIDCredentials;
var
  PIDCredentials: TPIDCredentials;

  _hToken: THandle;
  _cbBuf: Cardinal;
  _ptiUser: PTOKEN_USER;
  _snu: SID_NAME_USE;
  _processHandle: THandle;
  _userSize: DWORD;
  _domainSize: DWORD;
  _bSuccess: Boolean;
  _user: string;
  _domain: string;
begin
  _processHandle := OpenProcess(PROCESS_QUERY_INFORMATION, False, PID);
  if _processHandle <> 0 then
  begin
    if OpenProcessToken(_processHandle, TOKEN_QUERY, _hToken) then
    begin
      _bSuccess := GetTokenInformation(_hToken, TokenUser, nil, 0, _cbBuf);
      _ptiUser := nil;
      while (not _bSuccess) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) do
      begin
        ReallocMem(_ptiUser, _cbBuf);
        _bSuccess := GetTokenInformation(_hToken, TokenUser, _ptiUser, _cbBuf, _cbBuf);
      end;
      CloseHandle(_hToken);

      if not _bSuccess then
      begin
        Exit;
      end;

      _userSize := 0;
      _domainSize := 0;
      LookupAccountSid(nil, _ptiUser.User.Sid, nil, _userSize, nil, _domainSize, _snu);
      if (_userSize <> 0) and (_domainSize <> 0) then
      begin
        SetLength(_user, _userSize);
        SetLength(_domain, _domainSize);
        if LookupAccountSid(nil, _ptiUser.User.Sid, PChar(_user), _userSize,
          PChar(_domain), _domainSize, _snu) then
        begin
          PIDCredentials.ownerUserName := StrPas(PChar(_user));
          PIDCredentials.domain := StrPas(PChar(_domain));
        end;
      end;

      if _bSuccess then
      begin
        FreeMem(_ptiUser);
      end;
    end;
    CloseHandle(_processHandle);
  end;

  Result := PIDCredentials;
end;

function getPIDByProcessName(nameProcess: string): DWORD;
var
  _processCompare: TProcessCompare;
begin
  _processCompare.nameProcess := nameProcess;

  Result := getPID(nameProcess, checkProcessName, _processCompare);
end;

function checkProcessName(processEntry: TProcessEntry32; processCompare: TProcessCompare): boolean; // FUNZIONE PRIVATA
begin
  Result := processEntry.szExeFile = processCompare.nameProcess;
end;

function getPID(nameProcess: string; fn: TFunctionProcessCompare; processCompare: TProcessCompare): DWORD;
var
  processID: DWORD;

  _processEntry: TProcessEntry32;
  _snapHandle: THandle;
begin
  processID := 0;
  _snapHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  _processEntry.dwSize := sizeof(TProcessEntry32);
  Process32First(_snapHandle, _processEntry);
  repeat //loop over all process in snapshot
    with _processEntry do
    begin
      //execute processCompare
      if (fn(_processEntry, processCompare)) then
      begin
        processID := th32ProcessID;
        break;
      end;
    end;
  until (not(Process32Next(_snapHandle, _processEntry)));
  CloseHandle(_snapHandle);

  Result := processID;
end;

type
  TEnumInfo = record
    pid: DWORD;
    handle: THandle;
  end;

function enumWindowsProc(Wnd: THandle; Param: LPARAM): boolean; stdcall; forward;

function getMainWindowHandleByPID(PID: DWORD): DWORD;
var
  enumInfo: TEnumInfo;
begin
  enumInfo.pid := PID;
  enumInfo.handle := 0;
  EnumWindows(@enumWindowsProc, LPARAM(@enumInfo));

  Result := enumInfo.handle;
end;

type
  PEnumInfo = ^TEnumInfo;

function enumWindowsProc(Wnd: THandle; Param: LPARAM): boolean; stdcall;
var
  _result: boolean;

  PID: DWORD;
  PEI: PEnumInfo;
begin
  // Param matches the address of the param that is passed
  PEI := PEnumInfo(Param);
  GetWindowThreadProcessID(Wnd, @PID);

  _result := (PID <> PEI^.pid) or (not IsWindowVisible(WND)) or (not IsWindowEnabled(WND));

  if not _result then
  begin
    PEI^.handle := WND; //break on return FALSE
  end;

  Result := _result;
end;
//----------------------------------------------------------------------------------------

procedure closeApplication(handle: THandle);
begin
  SendMessage(handle, WM_CLOSE, Application.Handle, 0);
end;

//TODO CHECK IF THE LOOP IS NECCESARY
//procedure closeApplication(className: string; windowsName: string; handleSender: THandle = 0);
//var
//  receiverHandle: THandle;
//begin
//  receiverHandle := 1;
//  while (receiverHandle <> 0) do
//  begin
//    //classname (tclass) windows name (caption)
//    receiverHandle := FindWindow(PChar(className), PChar(windowsName));
//    if (receiverHandle <> 0) then
//    begin
//      SendMessage(receiverHandle, WM_CLOSE, Integer(handleSender), 0);
//    end;
//  end;
//end;

function sendMemoryStreamUsing_WM_COPYDATA(handle: THandle; data: TMemoryStream): integer;
var
  _result: integer;

  _copyDataStruct: TCopyDataStruct;
begin
  _copyDataStruct.dwData := integer(data.Memory);
  _copyDataStruct.cbData := data.size;
  _copyDataStruct.lpData := data.Memory;
  _result := SendMessage(handle, WM_COPYDATA, Integer(Application.Handle), Integer(@_copyDataStruct));

  Result := _result;
end;

function sendStringUsing_WM_COPYDATA(handle: THandle; data: string; msgIdentifier: integer = 0): integer;
var
  _result: integer;
  _copyDataStruct: TCopyDataStruct;
begin
  _copyDataStruct.cbData := 1 + Length(data);
  _copyDataStruct.lpData := pansichar(ansistring(data));
  _copyDataStruct.dwData := integer(msgIdentifier);

  _result := SendMessage(handle, WM_COPYDATA, integer(handle), integer(@_copyDataStruct));

  Result := _result;
end;

procedure mySetForegroundWindow(handle: THandle);
begin
  SetForegroundWindow(handle);
  postMessage(handle, WM_SYSCOMMAND, SC_RESTORE, 0);
end;

function checkIfWindowExists(className: string = 'TMyForm'; captionForm: string = 'Caption of MyForm'): boolean;
begin
  Result := myFindWindow(className, captionForm) <> 0;
end;

function myFindWindow(className: string = 'TMyForm'; captionForm: string = 'Caption of MyForm'): THandle;
begin
  Result := FindWindow(pchar(className), pchar(captionForm));
end;

function checkIfExistsKeyIn_HKEY_LOCAL_MACHINE(key: string): boolean;
var
  isOpenKey: boolean;

  _registry: TRegistry;
begin
  _registry := TRegistry.Create;
  try
    _registry.RootKey := HKEY_LOCAL_MACHINE;
    isOpenKey := _registry.OpenKeyReadOnly(key);
  finally
    _registry.Free;
  end;

  Result := isOpenKey;
end;

procedure waitForMultiple(processHandle: THandle; timeout: DWORD = INFINITE; modalMode: boolean = true);
const
  ERR_MSG_TIMEOUT = 'The timeout interval was elapsed.';
var
  _msg: TMsg;
  _return: DWORD;

  _exit: boolean;
begin
  _exit := false;
  while not _exit do
  begin
    _return := MsgWaitForMultipleObjects(1, { 1 handle to wait on }
      processHandle,
      False, { wake on any event }
      timeout,
      QS_PAINT or QS_SENDMESSAGE or QS_POSTMESSAGE //todo check
      //      QS_PAINT or QS_POSTMESSAGE or QS_SENDMESSAGE or QS_ALLPOSTMESSAGE { wake on paint messages or messages from other threads }
      );
    case _return of
      WAIT_OBJECT_0:
        _exit := true;
      WAIT_FAILED:
        raiseLastSysErrorMessage;
      WAIT_TIMEOUT:
        raise Exception.Create(ERR_MSG_TIMEOUT);
    else
      begin
        if modalMode then
        begin
          while PeekMessage(_msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) do
          begin
            DispatchMessage(_msg);
          end;
        end
        else
        begin
          Application.ProcessMessages;
        end;
      end;
    end;
  end;
end;

procedure waitFor(processHandle: THandle; timeout: DWORD = INFINITE; modalMode: boolean = true);
const
  ERR_MSG_TIMEOUT = 'The timeout interval was elapsed.';
var
  _msg: TMsg;
  _return: DWORD;

  _exit: boolean;
begin
  _exit := false;
  while not _exit do
  begin
    _return := WaitForSingleObject(processHandle, timeout);
    case _return of
      WAIT_OBJECT_0:
        _exit := true;
      WAIT_FAILED:
        raiseLastSysErrorMessage;
      WAIT_TIMEOUT:
        raise Exception.Create(ERR_MSG_TIMEOUT);
    else
      begin
        if modalMode then
        begin
          while PeekMessage(_msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) do
          begin
            DispatchMessage(_msg);
          end;
        end
        else
        begin
          Application.ProcessMessages;
        end;
      end;
    end;
  end;
end;

procedure raiseLastSysErrorMessage;
var
  sysErrMsg: string;
begin
  sysErrMsg := getLastSysErrorMessage;
  raise Exception.Create(sysErrMsg);
end;

function getLastSysErrorMessage: string;
var
  sysErrMsg: string;
  _errorCode: cardinal;
begin
  _errorCode := GetLastError;
  sysErrMsg := SysErrorMessage(_errorCode);

  Result := sysErrMsg;
end;

function getLocaleDecimalSeparator: char;
const
  LOCALE_NAME_SYSTEM_DEFAULT = '!x-sys-default-locale';
  LOCALE_CUSTOM_DEFAULT = $0C00;
var
  decimalSeparator: Char;

  _buffer: array [1 .. 10] of Char;
begin
  FillChar(_buffer, SizeOf(_buffer), 0);
{$warn SYMBOL_PLATFORM OFF}
  //Win32Check(GetLocaleInfoEx(LOCALE_NAME_SYSTEM_DEFAULT, LOCALE_SDECIMAL, @_buffer[1], SizeOf(_buffer)) <> 0);
    Win32Check(GetLocaleInfo(LOCALE_CUSTOM_DEFAULT, LOCALE_SDECIMAL, @_buffer[1], SizeOf(_buffer)) <> 0);

  {$warn SYMBOL_PLATFORM ON}
  decimalSeparator := _buffer[1];

  Result := decimalSeparator;
end;

procedure terminateCurrentProcess(exitCode: Cardinal = 0; raiseExceptionEnabled: boolean = false);
var
  _currentProcess: THandle;
begin
  _currentProcess := GetCurrentProcess;
  myTerminateProcess(_currentProcess, exitCode, raiseExceptionEnabled);
end;

procedure myTerminateProcess(processHandle: THandle; exitCode: Cardinal = 0; raiseExceptionEnabled: boolean = false);
var
  _success: LongBool;
begin
  _success := TerminateProcess(processHandle, exitCode);
  if not _success and raiseExceptionEnabled then
  begin
    raiseLastSysErrorMessage;
  end;
end;

end.
