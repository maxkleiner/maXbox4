//*** NetWork v1.00 - (c)1999, EFD Systems ***
//
//This source code is licensed for the private personal use of
//our clients and may not be re-distributed under any circumstances.
//
//THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
//ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//PARTICULAR PURPOSE.
//
//NOTE: For use with Win9X, RADMIN32.DLL and RLOCAL32.DLL must be installed in
//      the system directory.  These are avilable from www.microsoft.com as part
//      of NEXUS.EXE and on the NT Server CDROM.
//
//See WIN32.HLP for additional documentation.  Additonal network related functions
//are available in HyperString.

unit NetWork;

interface

uses Windows, SysUtils;

var
  hNETAPI:THandle=0;  //check for non-zero to verify runtime binding of DLLs succeeded.

function GetDomainName:AnsiString;
function GetDomainController(Domain:AnsiString):AnsiString;
function GetDomainUsers(Controller:AnsiString):AnsiString;
function GetDomainGroups(Controller:AnsiString):AnsiString;
function GetDateTime(Controller:AnsiString):TDateTime;  //local time
function GetFullName(Controller, UserID:AnsiString):AnsiString;

implementation

type
  WKSTA_INFO_100=record
    wki100_platform_id:Integer;
    wki100_computername:PWideChar;
    wki100_langroup:PWideChar;
    wki100_ver_major:Integer;
    wki100_ver_minor:Integer;
  end;

  WKSTA_USER_INFO_1=record
    wkui1_username:PChar;
    wkui1_logon_domain:PChar;
    wkui1_logon_server:PChar;
    wkui1_oth_domains:PChar;
  end;

  USER_INFO_1000 = record
    usri10_name : PWideChar;
    usri10_comment : PWideChar;
    usri10_usr_comment : PWideChar;
    usri10_full_name : PWideChar
  end;

  USER_INFO_10 = record
    usri10_name : PChar;
    usri10_comment : PChar;
    usri10_usr_comment : PChar;
    usri10_full_name : PChar
  end;

  TTimeofDayInfo = record
    tod_elapsedt: DWORD;
    tod_msecs: DWORD;
    tod_hours: DWORD;
    tod_mins: DWORD;
    tod_secs: DWORD;
    tod_hunds: DWORD;
    tod_timezone: Integer;
    tod_tinterval: DWORD;
    tod_day: DWord;
    tod_month: DWORD;
    tod_year: DWORD;
    tod_weekDay: DWORD;
  end;


  //Win9X ANSI prototypes from RADMIN32.DLL and RLOCAL32.DLL

  TWin95_NetWkstaUserGetInfo=function(Reserved:PChar; Level:Integer;
    var BufPtr:Pointer):Integer; stdcall;

  TWin95_NetApiBufferFree=function(BufPtr:Pointer):Integer; stdcall;

  TWin95_NetGetDCName=function(ServerName:PChar; domain:PChar;
    var BufPtr:Pointer):Integer; stdcall;

  TWin95_NetUserEnum=function(ServerName:PChar; Level,Filter:DWord;
    var BufPtr:Pointer; PrefMax:DWord; var Read,Total,Resume:DWord):Integer; stdcall;

  TWin95_NetLocalGroupEnum=function(ServerName:PChar; Level:DWord;
    var BufPtr:Pointer; PrefMax:DWord; var Read,Total,Resume:DWord):Integer; stdcall;

  TWin95_NetRemoteTOD=function(ServerName:PChar; var pTOD:Pointer):Integer; stdcall;

  TWin95_NetUserGetInfo=function(ServerName,UserName:PChar; Level:DWord; var BfrPtr:Pointer):Integer; stdcall;


  //WinNT UNICODE equivalents from NETAPI32.DLL

  TWinNT_NetWkstaGetInfo=function(ServerName:PWideChar; level:Integer;
    var BufPtr:Pointer):Integer; stdcall;

  TWinNT_NetApiBufferFree=function(BufPtr:Pointer):Integer; stdcall;

  TWinNT_NetGetAnyDCName=function(ServerName:PWideChar; domain:PWideChar;
    var BufPtr:PWideChar):Integer; stdcall;

  TWinNT_NetGetDCName=function(ServerName:PWideChar; domain:PWideChar;
    var BufPtr:PWideChar):Integer; stdcall;

  TWinNT_NetUserEnum=function(ServerName:PWideChar; Level,Filter:DWord;
    var BufPtr:Pointer; PrefMax:DWord; var Read,Total,Resume:DWord):Integer; stdcall;

  TWinNT_NetLocalGroupEnum=function(ServerName:PWideChar; Level:DWord;
    var BufPtr:Pointer; PrefMax:DWord; var Read,Total,Resume:DWord):Integer; stdcall;

  TWinNT_NetRemoteTOD=function(ServerName:PWideChar; var pTOD:Pointer):Integer; stdcall;

  TWinNT_NetUserGetInfo=function(ServerName,UserName:PWideChar; Level:DWord; var BfrPtr:Pointer):Integer; stdcall;

const
  MAX_STR=$FFFFFFFF;
  NERR_Success=0;
//  FILTER_TEMP_DUPLICATE_ACCOUNT       = $0001;
  FILTER_NORMAL_ACCOUNT               = $0002;
//  FILTER_PROXY_ACCOUNT                = $0004;
//  FILTER_INTERDOMAIN_TRUST_ACCOUNT    = $0008;
//  FILTER_WORKSTATION_TRUST_ACCOUNT    = $0010;
//  FILTER_SERVER_TRUST_ACCOUNT         = $0020;
var
  NTFlg:Boolean=False;
  Win95_NetApiBufferFree:    TWin95_NetApiBufferFree;
  Win95_NetWkstaUserGetInfo: TWin95_NetWkstaUserGetInfo;
  Win95_NetGetDCName:        TWin95_NetGetDCName;
  Win95_NetUserEnum:         TWin95_NetUserEnum;
  Win95_NetLocalGroupEnum:   TWin95_NetLocalGroupEnum;
  Win95_NetRemoteTOD:        TWin95_NetRemoteTOD;
  Win95_NetUserGetInfo:      TWin95_NetUserGetInfo;

  WinNT_NetApiBufferFree:    TWinNT_NetApiBufferFree;
  WinNT_NetWkstaGetInfo:     TWinNT_NetWkstaGetInfo;
  WinNT_NetGetDCName:        TWinNT_NetGetDCName;
  WinNT_NetGetAnyDCName:     TWinNT_NetGetAnyDCName;
  WinNT_NetUserEnum:         TWinNT_NetUserEnum;
  WinNT_NetLocalGroupEnum:   TWinNT_NetLocalGroupEnum;
  WinNT_NetRemoteTOD:        TWinNT_NetRemoteTOD;
  WinNT_NetUserGetInfo:      TWinNT_NetUserGetInfo;

function IsWinNT:Boolean;
  {Returns True if WinNT; otherwise, Win95.}
var
  VersionInfo: TOSVersionInfo;
begin
  VersionInfo.dwOSVersionInfoSize := Sizeof(TOSVersionInfo);
  Result:=GetVersionEx(VersionInfo);
  if Result then Result:=VersionInfo.dwPlatformID=VER_PLATFORM_WIN32_NT;
end;


function GetDomainName:AnsiString;
  {Retrieve name of logon domain.  Null string on error.}
var
  WSNT:^WKSTA_INFO_100;
  WS95:^WKSTA_USER_INFO_1;
  EC:DWord;
begin
  Result:='';
  if hNETAPI=0 then Exit;
  if NTFlg then begin
    EC:=WinNT_NetWkstaGetInfo(nil, 100,Pointer(WSNT));
    if EC=NERR_Success then begin
      Result:=WideCharToString(WSNT^.wki100_langroup);
      WinNT_NetApiBufferFree(Pointer(WSNT));
    end;
  end else begin
    EC:=Win95_NetWkstaUserGetInfo(nil, 1,Pointer(WS95));
    if EC=NERR_Success then begin
      Result:=WS95^.wkui1_logon_domain;
      Win95_NetApiBufferFree(Pointer(WS95));
    end;
  end;
end;


function GetDomainController(Domain:AnsiString):AnsiString;
  {Retrieve name for primary domain controller. Null string on error.}
var
  EC:DWord;
  PDefaultDomain:PChar;
  PWDomain:WideString;
  PWDefaultDomain:PWideChar;
begin
  Result:='';
  if hNETAPI=0 then Exit;
  if NTFlg then begin
    PWDomain:=Domain;
    EC:=WinNT_NetGetAnyDCName(nil, PWideChar(PWDomain), PWDefaultDomain);
    if EC=NERR_Success then begin
      Result:=WideCharToString(PWDefaultDomain);
      WinNT_NetApiBufferFree(Pointer(PWDefaultDomain));
    end else begin
      EC:=WinNT_NetGetDCName(nil, PWideChar(PWDomain), PWDefaultDomain);
      if EC=NERR_Success then begin
        Result:=WideCharToString(PWDefaultDomain);
        WinNT_NetApiBufferFree(Pointer(PWDefaultDomain));
      end
    end;
  end else begin
    EC:=Win95_NetGetDCName(nil, PChar(Domain), Pointer(PDefaultDomain));
    if EC=NERR_Success then begin
      Result:=PDefaultDomain;
      Win95_NetApiBufferFree(Pointer(PDefaultDomain));
    end;
  end;
end;


function GetDomainUsers(Controller:AnsiString):AnsiString;
  {Retrieve a comma delimited list of local domain users.  Null string on error.}
var
  WController:WideString;
  PWUser:^PWChar;
  PUser:^PChar;
  EC:Integer;
  I,Read,Total,Resume:DWord;
begin
  Result:='';
  if hNETAPI=0 then Exit;
  Resume:=0;
  Read:=1;
  if NTFlg then begin
    WController:=Controller;
    EC:=WinNT_NetUserEnum(PWideChar(Controller), 0, FILTER_NORMAL_ACCOUNT,
                          Pointer(PWUser),MAX_STR,Read,Total,Resume);
    if EC=NERR_Success then begin
      try
        for I:=0 to read-1 do begin
          if I>0 then Result:=Result+',';
          Result:=Result+WideCharToString(PWUser^);
          Inc(PWUser);
        end;
      finally
        WinNT_NetApiBufferFree(Pointer(PWUser));
      end;
    end;
  end else begin
    EC:=Win95_NetUserEnum(PChar(Controller), 0, FILTER_NORMAL_ACCOUNT,
                          Pointer(PUser),MAX_STR,Read,Total,Resume);
    if EC=NERR_Success then begin
      try
        for I:=0 to read-1 do begin
          if I>0 then Result:=Result+',';
          Result:=Result+PUser^;
          Inc(PUser);
        end;
      finally
        Win95_NetApiBufferFree(Pointer(PUser));
      end;
    end;
  end;
end;


function GetDomainGroups(Controller:AnsiString):AnsiString;
  {Retrieve a comma delimited list of local domain groups. Null string on error.}
var
  WController:WideString;
  PWUser:^PWChar;
  PUser:^PChar;
  EC,I,Read,Total,Resume:DWord;
begin
  Result:='';
  if hNETAPI=0 then Exit;
  Resume:=0;
  Read:=1;
  if NTFlg then begin
    WController:=Controller;
    EC:=WinNT_NetLocalGroupEnum(PWideChar(Controller), 0, Pointer(PWUser),
                                MAX_STR,Read,Total,Resume);
    if EC=NERR_Success then begin
      try
        for I:=0 to read-1 do begin
          if I>0 then Result:=Result+',';
          Result:=Result+WideCharToString(PWUser^);
          Inc(PWUser);
        end;
      finally
        WinNT_NetApiBufferFree(Pointer(PWUser));
      end;
    end;
  end else begin
    EC:=Win95_NetLocalGroupEnum(PChar(Controller), 0, Pointer(PUser),
                          MAX_STR,Read,Total,Resume);
    if EC=NERR_Success then begin
      try
        for I:=0 to read-1 do begin
          if I>0 then Result:=Result+',';
          Result:=Result+PUser^;
          Inc(PUser);
        end;
      finally
        Win95_NetApiBufferFree(Pointer(PUser));
      end;
    end;
  end;
end;


function GetDateTime(Controller:AnsiString):TDateTime;
  {Retrieve date/time (adjusted for time zone) from domain controller/server.
   Zero on error.}
var
  PTOD:^TTimeofDayInfo;
  WController:WideString;
  EC:DWord;
const
  Day=1440;

  function GetTDateTime:TDateTime;
  begin
    Result:=EncodeDate(PTOD^.tod_year, PTOD^.tod_month, PTOD^.tod_day) +
            EncodeTime(PTOd^.tod_hours, PTOD^.tod_mins, PTOD^.tod_secs, PTOD^.tod_hunds * 10)-
            (PTOD^.tod_timezone/Day);
  end;

begin
  Result:=0;
  if hNETAPI=0 then Exit;
  PTOD:=nil;
  if NTFlg then begin
    WController:=Controller;
    EC:=WinNT_NetRemoteTOD(PWideChar(Controller),Pointer(PTOD));
    if EC=NERR_Success then begin
      try
        Result:=GetTDateTime;
      finally
        WinNT_NetApiBufferFree(Pointer(PTOD));
      end;
    end;
  end else begin
    EC:=Win95_NetRemoteTOD(PChar(Controller),Pointer(PTOD));
    if EC=NERR_Success then begin
      try
        Result:=GetTDateTime;
      finally
        Win95_NetApiBufferFree(Pointer(PTOD));
      end;
    end;
  end;
end;


function GetFullName(Controller,UserID:AnsiString):AnsiString;
  {Retrieve user's full name and comment (if any).}
var
  UserNT:^USER_INFO_1000;
  User95:^USER_INFO_10;
  WController,WUserID:WideString;
  Tmp:AnsiString;
  EC:DWord;
begin
  Result:='';
  if hNETAPI=0 then Exit;
  if NTFlg then begin
    WController:=Controller;
    WUserID:=UserID;
    EC:=WinNT_NetUserGetInfo(PWideChar(WController), PWideChar(WUserID),10,Pointer(UserNT));
    if EC=NERR_Success then begin
      Result:=WideCharToString(UserNT^.usri10_full_name);
      Tmp:=WideCharToString(UserNT^.usri10_comment);
      if Length(Tmp)>0 then Result:=Result+','+Tmp;
      WinNT_NetApiBufferFree(Pointer(UserNT));
    end;
  end else begin
    EC:=Win95_NetUserGetInfo(PChar(Controller),PChar(UserID), 10,Pointer(User95));
    if EC=NERR_Success then begin
      Result:=User95^.usri10_full_name;
      Tmp:=User95^.Usri10_comment;
      if Length(Tmp)>0 then Result:=Result+','+Tmp;
      Win95_NetApiBufferFree(Pointer(User95));
    end;
  end;
end;




initialization
  //initialize procedural variables based on OS type
  NTFlg:=IsWinNT;
  if NTFlg then begin
    hNETAPI:=LoadLibrary('NETAPI32.DLL');
    if hNETAPI<>0 then begin
      @WinNT_NetWkstaGetInfo:=GetProcAddress(hNETAPI,'NetWkstaGetInfo');
      @WinNT_NetGetDCName:=GetProcAddress(hNETAPI,'NetGetDCName');
      @WinNT_NetGetAnyDCName:=GetProcAddress(hNETAPI,'NetGetAnyDCName');
      @WinNT_NetApiBufferFree:=GetProcAddress(hNETAPI,'NetApiBufferFree');
      @WinNT_NetUserEnum:=GetProcAddress(hNETAPI,'NetUserEnum');
      @WinNT_NetLocalGroupEnum:=GetProcAddress(hNETAPI,'NetLocalGroupEnum');
      @WinNT_NetRemoteTOD:=GetProcAddress(hNETAPI,'NetRemoteTOD');
      @WinNT_NetUserGetInfo:=GetProcAddress(hNETAPI,'NetUserGetInfo');
    end;
  end else begin
    hNETAPI:=LoadLibrary('RADMIN32.DLL');
    if hNETAPI<>0 then begin
      @Win95_NetGetDCName:=GetProcAddress(hNETAPI,'NetGetDCNameA');
      @Win95_NetApiBufferFree:=GetProcAddress(hNETAPI,'NetApiBufferFree');
      @Win95_NetWkstaUserGetInfo:=GetProcAddress(hNETAPI,'NetWkstaUserGetInfoA');
      @Win95_NetUserEnum:=GetProcAddress(hNETAPI,'NetUserEnumA');
      @Win95_NetLocalGroupEnum:=GetProcAddress(hNETAPI,'NetGroupEnumA');
      @Win95_NetRemoteTOD:=GetProcAddress(hNETAPI,'NetRemoteTODA');
      @Win95_NetUserGetInfo:=GetProcAddress(hNETAPI,'NetUserGetInfoA');
    end;
  end;

finalization
  if hNETAPI<>0 then FreeLibrary(hNETAPI);  //free the dynamically linked library
end.
