unit wiwin32;

//{$mode delphi}   for mX4
// testdrive!!

interface

uses
  Classes, SysUtils,
windows,
//DSiWin32,
registry,
//unitImpersonator,
  //wiglob,
    //jwawinbase,
    //JwaWinnt,
      //JwaWindows,
  //LCLIntf,
         shellapi, Shlobj;

const
  SID_REVISION  = 1;
  FILENAME_ADVAPI32     = 'ADVAPI32.DLL';
  PROC_CONVERTSIDTOSTRINGSIDA   = 'ConvertSidToStringSidA';

type
  TConvertSidToStringSidA = function (Sid: PSID;
  var StringSid: LPSTR): BOOL; stdcall;

function GetDomainUserSidS(const domainName: String; const userName : String;
    var foundDomain : String) : String;
function GetLocalUserSidStr (const UserName : string) : string;
//function getPid4user(const domain : string; const user: string; var pid:dword) : boolean;
function Impersonate2User(const domain : string; const user: string): boolean;
function GetProcessUserBypid(pid: DWORD; var UserName, Domain: AnsiString): Boolean;
function KillProcessbyname(const exename : string;var found : integer): integer;
function getWinProcessList:TStringList;
//procedure myimpersontest;


implementation

uses
  //wifunc;
   tlhelp32;

// -------------------------------------------
// functions to retrieve the SID for a user






function WinGetSidStr (Sid : PSid) : string;
var
  SidToStr      : TConvertSidToStringSidA;
  h             : LongWord;
  Buf           : array [0..MAX_PATH - 1] of char;
  p             : PAnsiChar;
begin
  h := LoadLibrary (FILENAME_ADVAPI32);
  if h <> 0 then
  try
    @SidToStr := GetProcAddress (h, PROC_CONVERTSIDTOSTRINGSIDA);
    if @SidToStr <> nil then
    begin
      FillChar (Buf, SizeOf(Buf), 0);

      if SidToStr (Sid, p) then
        Result := '[' + string(p) + ']';

      LocalFree (LongWord(p));
    end;
  finally
    FreeLibrary (h);
  end;
end;

function GetSidStr (Sid : PSid) : string;
var
  Psia          : PSIDIdentifierAuthority;
  SubAuthCount  : LongWord;
  i             : LongWord;
begin
  if IsValidSid (Sid) then
  begin
    //
    // Win 2000+ contains ConvertSidToStringSidA() in advapi32.dll so we just
    // use it if we can
    //
    if (Win32Platform = VER_PLATFORM_WIN32_NT) and
      (Win32MajorVersion >= 5) then
      Result := WinGetSidStr (Sid)
    else
    begin
      Psia := GetSidIdentifierAuthority (Sid);
      SubAuthCount := GetSidSubAuthorityCount (Sid)^;
      Result := Format('[S-%u-', [SID_REVISION]);
      if ((Psia.Value[0] <> 0) or (Psia.Value[1] <> 0)) then
        Result := Result + Format ('%.2x%.2x%.2x%.2x%.2x%.2x', [Psia.Value[0],
          Psia.Value[1], Psia.Value[2], Psia.Value[3], Psia.Value[4],
          Psia.Value[5]])
      else
        Result := Result + Format ('%u', [LongWord(Psia.Value[5]) +
          LongWord(Psia.Value[4] shl 8) + LongWord(Psia.Value[3] shl 16) +
          LongWord(Psia.Value[2] shl 24)]);

      for i := 0 to SubAuthCount - 1 do
        Result := Result + Format ('-%u', [GetSidSubAuthority(Sid, i)^]);

      Result := Result + ']';
    end;
  end;
end;

function GetDomainUserSidS (const DomainName: string; const UserName : string;
  var foundDomain: String) : string;
var
  RefDomain     : array [0..MAX_PATH - 1] of char;      // enough
  RefDomainSize : LongWord;
  Snu           : SID_NAME_USE;
  Sid           : PSid;
  SidSize       : LongWord;

begin
  SidSize := 0;
  RefDomainSize := SizeOf(RefDomain);
  Sid := nil;
  FillChar (RefDomain, SizeOf(RefDomain), 0);
  if DomainName = ''
  then
    LookupAccountName (nil, PChar(UserName), Sid, SidSize, RefDomain, RefDomainSize, Snu)
  else
    LookupAccountName (PChar(DomainName), PChar(UserName), Sid, SidSize, RefDomain,
  RefDomainSize, Snu);
  Sid := AllocMem (SidSize);
  try
    RefDomainSize := SizeOf(RefDomain);
    if DomainName = ''
    then
    begin
      if LookupAccountName (nil, PChar(UserName), Sid, SidSize, RefDomain,
      RefDomainSize, Snu) then
      Result := GetSidStr (Sid);
    end
    else
    begin
      if LookupAccountName (PChar(DomainName), PChar(UserName), Sid, SidSize, RefDomain,
      RefDomainSize, Snu) then
      Result := GetSidStr (Sid);
    end;

    foundDomain := String(RefDomain);

  finally
    FreeMem (Sid, SidSize);
  end;
end;



function GetLocalUserSidStr (const UserName : string) : string;
var
  RefDomain     : array [0..MAX_PATH - 1] of char;      // enough
  RefDomainSize : LongWord;
  Snu           : SID_NAME_USE;
  Sid           : PSid;
  SidSize       : LongWord;
begin
  SidSize := 0;
  RefDomainSize := SizeOf(RefDomain);
  Sid := nil;
  FillChar (RefDomain, SizeOf(RefDomain), 0);
  LookupAccountName (nil, PChar(UserName), Sid, SidSize, RefDomain,
  RefDomainSize, Snu);
  Sid := AllocMem (SidSize);
  try
    RefDomainSize := SizeOf(RefDomain);
    if LookupAccountName (nil, PChar(UserName), Sid, SidSize, RefDomain,
      RefDomainSize, Snu) then
      Result := GetSidStr (Sid);
  finally
    FreeMem (Sid, SidSize);
  end;
end;

function Impersonate2loggedonUser: boolean;
 var
   dwProcessId: DWORD;
   h          : HWND;
   hProcess   : THandle;
   hToken     : THandle;
 begin
   Result := false;
   h := FindWindow('Progman', nil);// maybe use GetDesktopWindow
   if h = 0 then
     Exit;
   if GetWindowThreadProcessId(h, @dwProcessId) = 0 then
     Exit;
   hProcess := OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwProcessId);
   if hProcess = 0 then
     Exit;
   try
     if OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, hToken) then
     try
       if ImpersonateLoggedOnUser(hToken) then
         result := true;
     finally CloseHandle(hToken); end;
   finally CloseHandle(hProcess); end;
 end; { TDSiRegistry.DSiGetUserNameEx }

function Impersonate2User(const domain : string; const user: string): boolean;
 var
   dwProcessId: DWORD;
   h          : HWND;
   hProcess   : THandle;
   hToken     : THandle;
 begin
   Result := false;
   //if getPid4user(domain,user,dwProcessId) then
   begin
     hProcess := OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwProcessId);
     if hProcess = 0 then
       Exit;
     try
       if OpenProcessToken(hProcess, TOKEN_ALL_ACCESS, hToken) then
       try
         if ImpersonateLoggedOnUser(hToken) then
           result := true;
       finally CloseHandle(hToken); end;
     finally CloseHandle(hProcess); end;
   end
   //else //LogDatei.DependentAddError('Error: got no pid at Impersonate2User/getPid4user for user:'+user,LLError);
 end; { TDSiRegistry.DSiGetUserNameEx }

{procedure myimpersontest;
var
  regist : Tregistry;
  str : string;
  impersonator : TImpersonator;
begin
 regist:=Tregistry.Create;
 impersonator := TImpersonator.CreateLoggedOn;
  try
 //DSiImpersonateUser(edit1.Caption,edit2.Caption,edit3.Caption);
 //label5.Text := DSiReadRegistry('Software\opsi.org\test','myname','not-found').asstring;
 regist.RootKey:=HKEY_CURRENT_USER;
 if Regist.OpenKey('\Software\opsi.org\test',false) then
 begin
   str := regist.ReadString('myname');
   LogDatei.DependentAdd(str,LLEssential);
   //memo1.Append(str);
 end
 else  LogDatei.DependentAdd('failed',LLEssential);
 //memo1.Append('DSiGetUserNameEx :'+DSiGetUserNameEx);
 //RetrieveSIDInfo(
 //('Software\opsi.org\test','myname','not-found').asstring;
 //DSiExecute(edit4.Caption);
 //DSiStopImpersonatingUser;
 finally
    impersonator.Free  // Revert to the SYSTEM account
  end;
  LogDatei.DependentAdd('DSiGetUserNameEx :'+DSiGetUserNameEx,LLEssential);
  LogDatei.DependentAdd('DSiGetDomain :'+DSiGetDomain,LLEssential);
  LogDatei.DependentAdd('GetDomainUserSidS :'+GetDomainUserSidS(DSiGetDomain,DSiGetUserNameEx,str),LLEssential);
  LogDatei.DependentAdd('GetLocalUserSidStr :'+GetLocalUserSidStr(DSiGetUserNameEx),LLEssential);
  //DSiGetDomain
  //GetDomainUserSidS
  //GetLocalUserSidStr
  regist.RootKey:=HKEY_USERS;
  str := GetLocalUserSidStr(DSiGetUserNameEx);
  str := copy(str,2,length(str)-2);
  LogDatei.DependentAdd('sidStr :'+str,LLEssential);
 if Regist.OpenKey('\'+str+'\Software\opsi.org\test',false) then
 begin
   str := regist.ReadString('myname');
   LogDatei.DependentAdd('read from hkusers: '+str,LLEssential);
   //memo1.Append(str);
 end
 else  LogDatei.DependentAdd('openkey failed',LLEssential);
 if Impersonate2loggedonUser then
                LogDatei.DependentAdd('Desktop :'+DSiGetFolderLocation(CSIDL_DESKTOPDIRECTORY),LLEssential)
 else
    LogDatei.DependentAdd('impersonate failed :'+DSiGetFolderLocation(CSIDL_DESKTOPDIRECTORY),LLEssential);
 RevertToSelf;
    regist.Free;
end; }




// functions to retrieve the SID for a user
// -------------------------------------------

// Process list
//http://www.lazarus.freepascal.org/index.php?topic=3543.0

//http://www.delphigeist.com/2010/03/process-list.html

//http://www.delphi-library.de/topic_Prozessliste+erstellen_41114,0.html
//http://www.delphi-forum.de/viewtopic.php?p=563144&sid=db0be57e7b505dc7e7d0f4700653674f
function getWinProcessList:TStringList;
var
  ContinueLoop: boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  resultstring : string;
  UserName, Domain: AnsiString;
begin
  Result:=TStringList.Create;
  FSnapshotHandle := CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while ContinueLoop do
  begin
    resultstring := '';
    UserName := '';
    domain :='';

    //resultstring:= FProcessEntry32.szExeFile+';'+
      //                  inttostr(FProcessEntry32.th32ProcessID)+';';
    if  GetProcessUserBypid(FProcessEntry32.th32ProcessID,UserName, Domain) then
          resultstring :=  resultstring + Domain+'\'+UserName;
    Result.add(resultstring);
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;
(*
function getWinProcessList:TStringList;
var PrIDs : Array [0..1000] of DWORD;
      bia : DWORD;
  PrCount : Integer;
  ProzessHandle : HWND;
  Modulhandle : HWND;
  i : Integer;
  PrName : Array [0..255] of Char;
  resultstring : string;
  var UserName, Domain: AnsiString;
begin
Result:=TStringList.Create;
if EnumProcesses(@PrIDs, SizeOf(PrIDs), bia) then
 if bia < sizeof(PrIDs) then
  begin
   PrCount:=Bia div SizeOf(DWORD);
   for i:=0 to PrCount do
    begin
     resultstring := '';
     UserName := '';
     domain :='';
     ProzessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or
                                  PROCESS_VM_READ, false, PrIDS[i]);
     if ProzessHandle<>0 then
      begin
       EnumProcessModules(ProzessHandle, @ModulHandle, SizeOf(modulhandle), bia);
       //GetModuleFilenameEx(Prozesshandle, ModulHandle, PrName, SizeOf(PrName));
       GetModuleBaseName(Prozesshandle, ModulHandle, PrName, SizeOf(PrName));
       CloseHandle(ProzessHandle);
      end;
      resultstring := PrName+';'+IntToStr(PrIDS[i])+';';
      if  GetProcessUserBypid(PrIDS[i],UserName, Domain) then
          resultstring :=  resultstring + Domain+'\'+UserName;
      Result.add(resultstring);
    end;
  end else LogDatei.DependentAddError('Error: getting process list',LLError);
 //else //RaiseLastOSError(); //if enumprocesses...
end;
*)
function GetProcessUserBypid(pid: DWORD; var UserName, Domain: AnsiString): Boolean;
// from http://www.delphigeist.com/2010/03/process-list.html
var
  hToken: THandle;
  cbBuf: Cardinal;
  //tokUser: PTOKEN_USER;
  tokUser: PSID;

  sidNameUse: SID_NAME_USE;
  hProcess: THandle;
  UserSize, DomainSize: DWORD;
  bSuccess: Boolean;
begin
  Result := False;
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION, False, pid);
  if hProcess <> 0 then begin
    if OpenProcessToken(hProcess, TOKEN_QUERY, hToken) then begin
      bSuccess := GetTokenInformation(hToken, TokenUser, nil, 0, cbBuf);
      tokUser := nil;
      while (not bSuccess) and
          (GetLastError = ERROR_INSUFFICIENT_BUFFER) do begin
        ReallocMem(tokUser, cbBuf);
        bSuccess := GetTokenInformation(hToken, TokenUser, tokUser, cbBuf, cbBuf);
      end;// while (not bSuccess) and...
      CloseHandle(hToken);
      if not bSuccess then
        Exit;
      UserSize := 0;
      DomainSize := 0;
      LookupAccountSid(nil, tokUser{.User.Sid}, nil, UserSize, nil, DomainSize, sidNameUse);
      if (UserSize <> 0) and (DomainSize <> 0) then begin
        SetLength(UserName, UserSize);
        SetLength(Domain, DomainSize);
        if LookupAccountSid(nil, tokUser, PAnsiChar(UserName), UserSize,
            PAnsiChar(Domain), DomainSize, sidNameUse) then begin
          Result := True;
          UserName := StrPas(PAnsiChar(UserName));
          Domain := StrPas(PAnsiChar(Domain));
        end;// if LookupAccountSid(nil, tokUser.User.Sid, PAnsiChar(UserName), UserSize,
      end;// if (UserSize <> 0) and (DomainSize <> 0) then begin
      if bSuccess then
        FreeMem(tokUser);
    end;// if OpenProcessToken(hProcess, TOKEN_QUERY, hToken) then begin
    CloseHandle(hProcess);
  end;// if hProcess <> 0 then begin
end;// function TDGProcessList.GetProcessUserAndDomain(dwProcessID: DWORD;

(*function getPid4user(const domain : string; const user: string; var pid:dword) : boolean;
var PrIDs : Array [0..1000] of DWORD;
      bia : DWORD;
  PrCount, i : Integer;
  founduser, founddomain : string;
begin
  result := false;
  if EnumProcesses(@PrIDs, SizeOf(PrIDs), bia) then
    if bia < sizeof(PrIDs) then
     begin
      PrCount:=Bia div SizeOf(DWORD);
      for i:=0 to PrCount do
       begin
        if GetProcessUserByPid(PrIDS[i], founduser, founddomain) then
        begin
         if founduser = user then
         begin
          Result := true;
          pid := PrIDS[i];
          exit;
         end;
        end;
       end;
     end else LogDatei.DependentAddError('Error: getting process list',LLError)
    else RaiseLastOSError(); //if enumprocesses...
end;*)

//http://www.delphipraxis.net/156073-klasse-zum-beenden-eines-prozesses-4.html
(*
function EnablePrivilege(const Privilege: string;
  fEnable: Boolean; out PreviousState: Boolean): DWORD;
var
  Token: THandle;
  NewState: TTokenPrivileges;
  Luid: TLargeInteger;
  PrevState: TTokenPrivileges;
  Return: DWORD;
begin
  PreviousState := True;
  if (GetVersion() > $80000000) then
    // Win9x
    Result := ERROR_SUCCESS
  else
  begin
    // WinNT
    if not OpenProcessToken(GetCurrentProcess(), MAXIMUM_ALLOWED, Token) then
      Result := GetLastError()
    else
    try
      if not LookupPrivilegeValue(nil, PChar(Privilege), Luid) then
        Result := GetLastError()
      else
      begin
        NewState.PrivilegeCount := 1;
        NewState.Privileges[0].Luid := Luid;
        if fEnable then
          NewState.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
        else
          NewState.Privileges[0].Attributes := 0;
        if not AdjustTokenPrivileges(Token, False, NewState,
          SizeOf(TTokenPrivileges), PrevState, Return) then
          Result := GetLastError()
        else
        begin
          Result := ERROR_SUCCESS;
          PreviousState :=
            (PrevState.Privileges[0].Attributes and SE_PRIVILEGE_ENABLED <> 0);
        end;
      end;
    finally
      CloseHandle(Token);
    end;
  end;
end;
*)
(*function KillProcessbypid(pid: DWORD): Boolean;
var
  hProcess: THandle;
begin
  Result := False;
  if not DSiEnablePrivilege('SE_DEBUG_NAME') then
    LogDatei.DependentAddWarning('Warning: Could not get SE_DEBUG_NAME Privelege to kill process -> will try with out',LLWarning);
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, pid);
  if hProcess <> 0 then
  begin
    LogDatei.DependentAdd('Try to kill process with pid: '+IntToStr(pid),LLDebug);
    Result := TerminateProcess(hProcess, 0);
    LogDatei.DependentAdd('killed process with pid: '+IntToStr(pid),LLDebug);
    CloseHandle(hProcess)
  end;// if hProcess <> 0 then begin
end;// KillProcessbypid(pid: DWORD): Boolean;
  *)

function getpid4exe(const exename : string; var pid:dword) : boolean;
var PrIDs : Array [0..1000] of DWORD;
      bia : DWORD;
  PrCount, i : Integer;
  ProzessHandle,ModulHandle : HWND;
  PrName : Array [0..255] of Char;
  var
  ContinueLoop: boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := false;
  FSnapshotHandle := CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while ContinueLoop do
  begin
    if AnsiSameText(FProcessEntry32.szExeFile,exename) then
    begin
       pid := FProcessEntry32.th32ProcessID;
       ContinueLoop := false;
       result := true;
    end
    else
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function KillProcessbyname(const exename : string;var found : integer): integer;
var
  pid:dword;
  user,domain, myuser,mydomain, foundexe, domuser,winstuser,winstdom : Ansistring;
  h          : HWND;
  proclist : TStringlist;
  procdetails : TStringlist;
  i : integer;
begin
  Result := 0;
  found  := 0;
  myuser := '';
  mydomain := '';
  procdetails := TStringlist.Create;
  h := FindWindow('Progman', nil);
  if h <> 0 then
  begin
    if GetWindowThreadProcessId(h, @pid) <> 0 then
    begin
      //if not GetProcessUserBypid(pid,myuser,mydomain) then
        //LogDatei.DependentAdd('Could not get user for pid: '+IntToStr(pid),LLDebug)
    end
    //else LogDatei.DependentAdd('Could not get pid for current session',LLDebug);
  end
  else //LogDatei.DependentAdd('Could not get handle for current session: no user',LLDebug);
  //if not (myuser = GetUserNameEx) then
    //LogDatei.DependentAdd('Strange: different users found: '+myuser+' + '+DSiGetUserNameEx,LLDebug);
  //LogDatei.DependentAdd('Session owner found: '+mydomain+'\'+myuser,LLDebug);
  if getpid4exe('winst32.exe',pid) then
  begin
    if GetProcessUserBypid(pid,winstuser,winstdom) then
    begin
     //LogDatei.DependentAdd('winst owner found: '+winstdom+'\'+winstuser,LLDebug);
    end
    else //LogDatei.DependentAdd('Could not get owner for current winst32.exe',LLDebug);
  end
  else //LogDatei.DependentAdd('Could not get pid for current winst32.exe',LLDebug);

  //while getpid4exe(exename,pid) do
  proclist := getWinProcessList;
  for i := 0 to proclist.Count -1 do
  begin
    procdetails.Clear;
    //stringsplit(proclist.Strings[i],';', procdetails);
    //LogDatei.DependentAdd(proclist.Strings[i],LLDebug);
    //LogDatei.DependentAdd('analyze: exe: '+procdetails.Strings[0]+' pid: '+procdetails.Strings[1]+' from user: '+procdetails.Strings[2],LLDebug2);
    if procdetails.Strings[1] <> '' then
    begin
      try
        pid := StrToInt(procdetails.Strings[1]);
      except
        pid:=0;
      end;
      foundexe := procdetails.Strings[0];
      domuser := procdetails.Strings[2];
      if exename = foundexe then
      begin
        if (domuser = mydomain+'\'+myuser) or (domuser = winstdom+'\'+winstuser) or (domuser = '') then
        begin
          //LogDatei.DependentAdd('Will kill exe: '+exename+' pid: '+IntToStr(pid)+' from user: '+domuser,LLDebug);
          inc(found);
          //if //KillProcessbypid(pid) then
            //result := result+1;
        end
        //else //LogDatei.DependentAdd('Will not kill exe: '+exename+' pid: '+IntToStr(pid)+' from user: '+domuser,LLDebug);
      end;
      //else LogDatei.DependentAdd('No user found for exe: '+exename+' and pid: '+IntToStr(pid),LLDebug);
    end;
  end;
end;// KillProcessbyname(const exename : string;): Boolean;

end.



----code_cleared_checked_clean----