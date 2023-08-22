unit uPSI_PsAPI;
{
   for process information  and compiler speed     , locs=3068, 3282     getnngsize
}
interface
 
uses
   SysUtils
  ,Classes, types, windows
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler, psAPI;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_PsAPI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_PsAPI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PsAPI_Routines(S: TPSExec);

//function getProcessAllMemory(ProcessID : longWORD): TProcessMemoryCounters;

function GetProcessMemoryInfoInt(Process: THandle; var MemoryCounters: TProcessMemoryCounters;
                                    cb: DWORD): BOOL; //stdcall;
  //   external 'psapi.dll' name 'GetProcessMemoryInfo';
// psapi.dll;

//function GetProcessMemoryInfo2(Process: THandle;var MemoryCounters:TProcessMemoryCounters;
  //                                  cb: DWORD): BOOL; //stdcall;;
    // external 'psapi.dll' name 'GetProcessMemoryInfo';

  //   External 'GetProcessMemoryInfo@psapi.dll stdcall';


procedure Register;

implementation

  uses forms, svcmgr, winsvc, servicemgr, ShlObj, ActiveX, idHTTP, ComObj, variants, ShellAPI, TlHelp32,
    Graphics, math, Extctrls, BDE, winsock, urlmon, registry, nb30, WinInet, messages, mmsystem;
//uses
   //Windows
  //,PsAPI      Classes,
  //ComObj,
  //Variants,
  //IdHTTP,
  //;

 type
 TGeoInfo   = record
  Status        : string;
  CountryCode   : string;
  CountryName   : string;
  RegionCode    : string;
  City          : string;
  ZipPostalCode : string;
  Latitude      : string;
  Longitude     : string;
  TimezoneName  : string;
  Gmtoffset     : string;
  Isdst         : string;
 end;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PsAPI]);
end;

function GetProcessMemoryInfoInt(Process: THandle; var MemoryCounters: TProcessMemoryCounters;
                                    cb: DWORD): BOOL; //stdcall;
begin
  result:= GetProcessMemoryInfo(Process,
                            //PPROCESS_MEMORY_COUNTERS(MemCounters),
                            //TProcessMemoryCounters(PPROCESS_MEMORY_COUNTERS((@memoryCounters))),
                            PsAPI.PPROCESS_MEMORY_COUNTERS(@memoryCounters),
                            //memoryCounters,
                            sizeof(MemoryCounters));
    //result:= true;//@memoryCounters;  //t
end;



function getProcessAllMemory(ProcessID : DWORD): TProcessMemoryCounters;
var ProcessHandle : THandle;
    MemCounters   : TProcessMemoryCounters;
    //ppsmemCounters: PPROCESS_MEMORY_COUNTERS;
    //MemCounters: PPROCESS_MEMORY_COUNTERS;
begin
  //Result:= NULL;
  ProcessHandle:= OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
                               false, ProcessID);
  try
    if GetProcessMemoryInfoInt(ProcessHandle,
                            //PPROCESS_MEMORY_COUNTERS(MemCounters),
                            memCounters,
                            sizeof(MemCounters))
    //then Result:= TProcessMemoryCounters(MemCounters^);
    then Result:= MemCounters;

  finally
    CloseHandle(ProcessHandle);
  end;
end;

function ConsoleCapture(const _dirName, _exeName, _cmdLine: string; amemo: TStringlist): Boolean;
var
  start: TStartupInfo;
  procInfo: TProcessInformation;
  tmpName: string;
  tmp: Windows.THandle;
  tmpSec: TSecurityAttributes;
  res: TStringList;
  return: Cardinal;
begin
  Result := False;
  try
    { Setze ein Temporäres File }
    { Set a temporary file }
    tmpName := 'Test.tmp';
    FillChar(tmpSec, SizeOf(tmpSec), #0);
    tmpSec.nLength := SizeOf(tmpSec);
    tmpSec.bInheritHandle := True;
    tmp := Windows.CreateFile(PChar(tmpName),
           Generic_Write, File_Share_Write,
           @tmpSec, Create_Always, File_Attribute_Normal, 0);
    try
      FillChar(start, SizeOf(start), #0);
      start.cb          := SizeOf(start);
      start.hStdOutput  := tmp;
      start.dwFlags     := StartF_UseStdHandles or StartF_UseShowWindow;
      start.wShowWindow := SW_Minimize;
      { Starte das Programm }
      { Start the program }
      if CreateProcess(nil, PChar(_exeName + ' ' + _cmdLine), nil, nil, True,
                       0, nil, PChar(_dirName), start, procInfo) then
      begin
        SetPriorityClass(procInfo.hProcess, Idle_Priority_Class);
        WaitForSingleObject(procInfo.hProcess, Infinite);
        GetExitCodeProcess(procInfo.hProcess, return);
        Result := (return = 0);
        CloseHandle(procInfo.hThread);
        CloseHandle(procInfo.hProcess);
        Windows.CloseHandle(tmp);
        { Die Ausgaben hinzufügen }
        { Add the output }
        //res := TStringList.Create;
        try
          //res.LoadFromFile(tmpName);
          amemo.LoadFromFile(tmpName);
                 //Memo1.Lines.AddStrings(res);
        finally
          //res.Free;
        end;
        Windows.DeleteFile(PChar(tmpName));
      end
      else
      begin
        {Application.}MessageBox(hinstance,PChar(SysErrorMessage(GetLastError())),
          'RunDOSCaptured Error', MB_OK);
      end;
    except
      Windows.CloseHandle(tmp);
      Windows.DeleteFile(PChar(tmpName));
      raise;
    end;
  finally
  end;
end;

function ConsoleCaptureDOS(const _dirName, _exeName, _cmdLine: string; amemo: TStrings): Boolean;
var
  start: TStartupInfo;
  procInfo: TProcessInformation;
  tmpName: string;
  tmp: Windows.THandle;
  tmpSec: TSecurityAttributes;
  res: TStringList;
  return: Cardinal;
begin
  Result:= False;
  try
    tmpName:= 'Test.tmp';
    FillChar(tmpSec, SizeOf(tmpSec), #0);
    tmpSec.nLength:= SizeOf(tmpSec);
    tmpSec.bInheritHandle:= True;
    tmp:= Windows.CreateFile(PChar(tmpName),
           Generic_Write, File_Share_Write,
           @tmpSec, Create_Always, File_Attribute_Normal, 0);
    try
      FillChar(start, SizeOf(start), #0);
      start.cb          := SizeOf(start);
      start.hStdOutput  := tmp;
      start.dwFlags     := StartF_UseStdHandles or StartF_UseShowWindow;
      start.wShowWindow := SW_Minimize;
      { Starte das Programm }
      { Start the program }
      if CreateProcess(nil, PChar(_exeName + ' ' + _cmdLine), nil, nil, True,
                       0, nil, PChar(_dirName), start, procInfo) then
      begin
        SetPriorityClass(procInfo.hProcess, Idle_Priority_Class);
        WaitForSingleObject(procInfo.hProcess, Infinite);
        GetExitCodeProcess(procInfo.hProcess, return);
        Result:= (return = 0);
        CloseHandle(procInfo.hThread);
        CloseHandle(procInfo.hProcess);
        Windows.CloseHandle(tmp);
         amemo.LoadFromFile(tmpName);
        Windows.DeleteFile(PChar(tmpName));
      end
      else
      begin
        {Application.}MessageBox(hinstance,PChar(SysErrorMessage(GetLastError())),
          'RunDOSCaptured2 Error', MB_OK);
      end;
    except
      Windows.CloseHandle(tmp);
      Windows.DeleteFile(PChar(tmpName));
      raise;
    end;
  finally
  end;
end;


procedure PerformanceDelayMS(ams: integer);
var
  hrRes, hrT1, hrT2, dif: Int64;
begin
  if QueryPerformanceFrequency(hrRes) then
  begin
    QueryPerformanceCounter(hrT1);
    repeat
      QueryPerformanceCounter(hrT2);
      dif := (hrT2 - hrT1) * 10000000 div hrRes;
    until dif > ams;
  end;
end;

function ExecuteProcess(FileName: string; Visibility: Integer; BitMask: Integer; Synch: Boolean): Longword;
//valori di Visibility:
{
Value                Meaning
SW_HIDE            :Hides the window and activates another window.
SW_MAXIMIZE        :Maximizes the specified window.
SW_MINIMIZE        :Minimizes the specified window and activates the next top-level window in the Z order.
SW_RESTORE        :Activates and displays the window. If the window is minimized or maximized,
                    Windows restores it to its original size and position. An application should
                    specify this flag when restoring a minimized window.
SW_SHOW                :Activates the window and displays it in its current size and position.
SW_SHOWDEFAULT        :Sets the show state based on the SW_ flag specified in the STARTUPINFO
                        structure passed to the CreateProcess function by the program that started the application.
SW_SHOWMAXIMIZED       :Activates the window and displays it as a maximized window.
SW_SHOWMINIMIZED       :Activates the window and displays it as a minimized window.
SW_SHOWMINNOACTIVE     :Displays the window as a minimized window. The active window remains active.
SW_SHOWNA              :Displays the window in its current state. The active window remains active.
SW_SHOWNOACTIVATE      :Displays a window in its most recent size and position. The active window remains active.
SW_SHOWNORMAL          :Activates and displays a window. If the window is minimized or maximized,
                      Windows restores it to its original size and position. An application should specify this
                      flag when displaying the window for the first time.
}
//FileName: the name of the program I want to launch
//Bitmask:   specifies the set of CPUs on wich I want to run the program
    //the BitMask is built in the following manner:
    //I have a bit sequence: every bit is associated to a CPU (from right to left)
    //I set the bit to 1 if I want to use the corrisponding CPU, 0 otherwise
    //for example: I have 4 processor and I want to run the specified process on the CPU 2 and 4:
    //the corresponding bitmask will be     1010 -->2^0 * 0 + 2^1 * 1 + 2^2 * 0 + 2^3 * 1 = 2 + 8 = 10
    //hence BitMask = 10
//Synch: Boolean --> True if I want a Synchronous Execution (I cannot close
//my application before the launched process is terminated)

var
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Closed: Boolean;
begin
  Closed := True;
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    //running the process on the set of CPUs specified by BitMask
    SetProcessAffinityMask(ProcessInfo.hProcess, BitMask);
    /////
    if (Synch = True) then //if I want a Synchronous execution (I cannot close my
    // application before this process is terminated)
      begin
        Closed:= False;
        repeat
          case WaitForSingleObject(
            ProcessInfo.hProcess, 100) of
              WAIT_OBJECT_0 : Closed:= True;
              WAIT_FAILED : RaiseLastWin32Error;
          end;
          forms.Application.ProcessMessages;
        until (Closed);
        GetExitCodeProcess(ProcessInfo.hProcess, Result);
        //exit code of the launched process (0 if the process returned no error  )
        CloseHandle(ProcessInfo.hProcess);
        CloseHandle(ProcessInfo.hThread);
      end
    else
      begin
        Result := 0;
      end;
  end;
end; {ExecuteProcess}

procedure StartServiceAfterInstall(aserv: TService);
var
  sm: TServiceManager;
begin
  sm:= TServiceManager.Create;
  try
    if sm.Connect then
      if sm.OpenServiceConnection(Pansichar(aserv.ServiceStartName)) then
        sm.StartService;
  finally
    sm.Free;
  end;
end;

type
  PDLLVerInfo=^TDLLVersionInfo;
  TDLLVersionInfo=Record
    cbSize,   // Size of the structure, in bytes.
    dwMajorVersion, // Major version of the DLL
    dwMinorVersion, // Minor version of the DLL
    dwBuildNumber, // Build number of the DLL
    dwPlatformID: DWord; // Identifies the platform for which the DLL was built
end;

var
  DllGetVersion: function(dvi: PDLLVerInfo): PDLLVerInfo; stdcall;

function GetDllVersion2(DllName: string; var DLLVersionInfo: TDLLVersionInfo): Boolean;
var
  hInstDll: THandle;
  p: pDLLVerInfo;
begin
  Result := False;
  // Get a handle to the DLL module.
  // das Handle zum DLL Modul ermitteln.
  hInstDll := LoadLibrary(PChar(DllName));
  if (hInstDll = 0) then Exit;
  // Return the address of the specified exported (DLL) function.
  // Adresse der Dll-Funktion ermitteln
  @DllGetVersion := GetProcAddress(hInstDll, 'DllGetVersion');
  // If the handle is not valid, clean up an exit.
  // Wenn das Handle ungültig ist, wird die Funktion verlassen
  if (@DllGetVersion) = nil then
  begin
    FreeLibrary(hInstDll);
    Exit;
  end;
   new(p);
  try
    ZeroMemory(p, SizeOf(p^));
    p^.cbSize := SizeOf(p^);
     // Call the DllGetVersion function
    // Die DllGetVersion() Funktion aufrufen
    DllGetVersion(p);
    DLLVersionInfo.dwMajorVersion := p^.dwMajorVersion;
    DLLVersionInfo.dwMinorVersion := p^.dwMinorVersion;

    @DllGetVersion := nil;
    Result := True;
  finally
    dispose(P);
  end;
 // Free the DLL module.
 // Dll wieder freigeben.
 FreeLibrary(hInstDll);
end;

procedure SendCopyMessage(amess, astation: string);
var
  aCopyData: TCopyDataStruct;
  hTargetWnd: HWND;
begin
  with aCopyData do
  begin
    dwData := 0;
    cbData := StrLen(PChar(amess)) + 1;
    lpData := PChar(amess)
  end;
  // Search window by the window title
  // Fenster anhand des Titelzeilentext suchen
  if astation = '' then
    hTargetWnd := FindWindowEx(0, 0, nil, PChar('TMaxForm1'))
    else
     hTargetWnd := FindWindowEx(0, 0, nil, PChar(astation));
  if hTargetWnd <> 0 then
    SendMessage(hTargetWnd, $004A, Longint(hinstance), Longint(@aCopyData))
  else
    MessageBox(hinstance,PChar(SysErrorMessage(GetLastError())),
          'No WMCopyData Recipient found! Error', MB_OK); //ShowMessage('No Recipient found!');
end;

function BrowseComputer2(DialogTitle: string; var CompName: string; bNewStyle: Boolean): Boolean;
  // bNewStyle: If True, this code will try to use the "new"
  // BrowseForFolders UI on Windows 2000/XP
const
  BIF_USENEWUI = 28;
var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ComputerName: array[0..MAX_PATH] of Char;
  Title: string;
  WindowList: Pointer;
  ShellMalloc: IMalloc;
begin
  if Failed(SHGetSpecialFolderLocation(forms.Application.Handle, CSIDL_NETWORK, ItemIDList)) then
    raise Exception.Create('Unable open browse computer dialog');
  try
    FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
    BrowseInfo.hwndOwner := Forms.Application.Handle;
    BrowseInfo.pidlRoot := ItemIDList;
    BrowseInfo.pszDisplayName := ComputerName;
    Title := DialogTitle;
    BrowseInfo.lpszTitle := PChar(Pointer(Title));
    if bNewStyle then
      BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER or BIF_USENEWUI
    else
      BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER;
    WindowList := DisableTaskWindows(0);
    try
      Result := SHBrowseForFolder(BrowseInfo) <> nil;
    finally
      EnableTaskWindows(WindowList);
    end;
    if Result then CompName := ComputerName;
  finally
    if Succeeded(SHGetMalloc(ShellMalloc)) then
      ShellMalloc.Free(ItemIDList);
  end;
end;


// Beispiel:
// Example:

(*procedure TForm1.Button1Click(Sender: TObject);
begin
  RunCaptured('C:\', 'cmd.exe', '/c dir');
end;*)

const
 UrlGeoLookupInfo  ='http://ipinfodb.com/ip_query.php?timezone=true&ip=%s';
 UrlGeoLookupInfo2 ='http://backup.ipinfodb.com/ip_query.php?timezone=true&ip=%s'; //backup

procedure GetGeoInfo(const IpAddress : string;var GeoInfo :TGeoInfo; const UrlGeoLookupInfo: string);
var
  lHTTP  : TIdHTTP;
  lStream: TStringStream;
  XMLDoc : OleVariant;
  ANode  : OleVariant;
begin
  lHTTP   := TIdHTTP.Create(nil);
  lStream := TStringStream.Create('');
  try
      try
        lHTTP.Get(Format(UrlGeoLookupInfo,[IpAddress]), lStream); //get the request
      except
        lHTTP.Get(Format(UrlGeoLookupInfo2,[IpAddress]), lStream); //if something is wrong try using the backup server.
      end;
      lStream.Seek(0,0);
      XMLDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
      XMLDoc.async := false;
      XMLDoc.LoadXML(lStream.ReadString(lStream.Size));
      XMLDoc.setProperty('SelectionLanguage','XPath');//use XPath to parse the xml result
      ANode:=XMLDoc.selectSingleNode('/Response/Status');
      if not VarIsNull(ANode) then GeoInfo.Status:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/CountryCode');
      if not VarIsNull(ANode) then GeoInfo.CountryCode:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/CountryName');
      if not VarIsNull(ANode) then GeoInfo.CountryName:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/RegionCode');
      if not VarIsNull(ANode) then GeoInfo.RegionCode:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/City');
      if not VarIsNull(ANode) then GeoInfo.City:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/ZipPostalCode');
      if not VarIsNull(ANode) then GeoInfo.ZipPostalCode:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Latitude');
      if not VarIsNull(ANode) then GeoInfo.Latitude:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Longitude');
      if not VarIsNull(ANode) then GeoInfo.Longitude:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/TimezoneName');
      if not VarIsNull(ANode) then GeoInfo.TimezoneName:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Gmtoffset');
      if not VarIsNull(ANode) then GeoInfo.Gmtoffset:=ANode.Text;
      ANode:=XMLDoc.selectSingleNode('/Response/Isdst');
      if not VarIsNull(ANode) then GeoInfo.Isdst:=ANode.Text;
  finally
    lHTTP.Free;
    lStream.Free;
  end;
end;

function getFormRes(classname: string): string;
var
  rs: TResourceStream;
  ms: TMemoryStream;
begin
  rs := TResourceStream.Create(HInstance, ClassName, RT_RCDATA);
  try
    ms := TMemoryStream.Create;
    try
      ObjectBinaryToText(rs, ms);
      ms.Seek(0, 0);
       if ms.Size > 0 then begin
        SetLength(result, ms.Size);
      Move(mS.Memory^, result[1], mS.Size);
    end;
    finally
      ms.Free;
    end;
    //QS_ALLINPUT
  finally
    rs.Free;
  end;
end;

function RoundTime(ADate: string; Rounding: Integer; bRound: Boolean): string;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  tmpDate: TDateTime;
  Res, Diff: string;
  M: integer;
begin
  tmpDate:= StrToDateTime(ADate);
  DecodeTime(tmpDate, Hour, Min, Sec, MSec);
  if (Rounding > 0) and (bRound = True) then
  begin
    if Min mod Rounding = 0 then
      Res:= IntToStr(Min)
    else
      Res:= IntToStr(Round(Min / Rounding) * Rounding);
    M:= StrToInt(Copy(ADate, Length(ADate) - 1, 2));
    Diff := IntToStr(StrToInt(Res) - M);
    if Copy(Diff, 1, 1) = '-' then  begin
      Diff:= Copy(Diff, 2, Length(Diff) - 1);
      Result:= FormatDateTime('dd.mm.yy hh:mm',(tmpDate-StrToTime('00:00'+ Diff)));
    end
    else
      Result:= FormatDateTime('dd.mm.yy hh:mm',(tmpDate+StrToTime('00:00'+ Diff)));
  end
  else
    Result:= ADate;
end;

type
  PNetResourceArray = ^TNetResourceArray;
  TNetResourceArray = array[0..100] of TNetResource;


function CreateNetResourceList(ResourceType: DWord;
                              NetResource: PNetResource;
                              out Entries: DWord;
                              out List: PNetResourceArray): Boolean;
var
  EnumHandle: THandle;
  BufSize: DWord;
  Res: DWord;
begin
  Result := False;
  List := Nil;
  Entries := 0;
  if WNetOpenEnum(RESOURCE_GLOBALNET,
                  ResourceType,
                  0,
                  NetResource,
                  EnumHandle) = NO_ERROR then begin
    try
      BufSize := $4000;  // 16 kByte
      GetMem(List, BufSize);
      try
        repeat
          Entries := DWord(-1);
          FillChar(List^, BufSize, 0);
          Res := WNetEnumResource(EnumHandle, Entries, List, BufSize);
          if Res = ERROR_MORE_DATA then
          begin
            ReAllocMem(List, BufSize);
          end;
        until Res <> ERROR_MORE_DATA;

        Result := Res = NO_ERROR;
        if not Result then
        begin
          FreeMem(List);
          List := Nil;
          Entries := 0;
        end;
      except
        FreeMem(List);
        raise;
      end;
    finally
      WNetCloseEnum(EnumHandle);
    end;
  end;
end;

procedure ScanNetworkResources(ResourceType, DisplayType: DWord; List: TStrings);

procedure ScanLevel(NetResource: PNetResource);
var
  Entries: DWord;
  NetResourceList: PNetResourceArray;
  i: Integer;
begin
  if CreateNetResourceList(ResourceType, NetResource, Entries, NetResourceList) then try
    for i := 0 to Integer(Entries) - 1 do
    begin
      if (DisplayType = RESOURCEDISPLAYTYPE_GENERIC) or
        (NetResourceList[i].dwDisplayType = DisplayType) then begin
        List.AddObject(NetResourceList[i].lpRemoteName,
                      Pointer(NetResourceList[i].dwDisplayType));
      end;
      if (NetResourceList[i].dwUsage and RESOURCEUSAGE_CONTAINER) <> 0 then
        ScanLevel(@NetResourceList[i]);
    end;
  finally
    FreeMem(NetResourceList);
  end;
end;

begin
  ScanLevel(Nil);
end;


// Converts String To Hexadecimal
// Maybe usefull for a hex-editor
// For example:
//     Input = 'ABCD'
//     Output = '41 42 43 44'

function StringtoHex(Data: string): string;
var
  i, i2: Integer;
  s: string;
begin
  i2 := 1;
  for i := 1 to Length(Data) do
  begin
    Inc(i2);
    if i2 = 2 then
    begin
      s  := s + ' ';
      i2 := 1;
    end;
    s := s + IntToHex(Ord(Data[i]), 2);
  end;
  Result := s;
end;


function GetAnsistringRefcount(const S: string): Cardinal;
asm
  or eax, eax
  jz @done
  sub eax, 8
  mov eax, dword ptr [eax]
@done:
end;

 {:Converts Unicode string to Ansi string using specified code page.
  @param   ws       Unicode string.
  @param   codePage Code page to be used in conversion.
  @returns Converted ansi string.
}

function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
begin
  if ws = '' then
    Result := ''
  else
  begin
    l := WideCharToMultiByte(codePage,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], - 1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage,
        WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], - 1, @Result[1], l - 1, nil, nil);
  end;
end; { WideStringToString }


{:Converts Ansi string to Unicode string using specified code page.
  @param   s        Ansi string.
  @param   codePage Code page to be used in conversion.
  @returns Converted wide string.
}
function StringToWideString(const s: AnsiString; codePage: Word): WideString;
var
  l: integer;
begin
  if s = '' then
    Result := ''
  else
  begin
    l := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PChar(@s[1]), - 1, nil, 0);
    SetLength(Result, l - 1);
    if l > 1 then
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PChar(@s[1]),
        - 1, PWideChar(@Result[1]), l - 1);
  end;
end; { StringToWideString }

const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;

function SecondToTime(const Seconds: Cardinal): Double;
var
  ms, ss, mm, hh, dd: Cardinal;
begin
  dd := Seconds div SecPerDay;
  hh := (Seconds mod SecPerDay) div SecPerHour;
  mm := ((Seconds mod SecPerDay) mod SecPerHour) div SecPerMinute;
  ss := ((Seconds mod SecPerDay) mod SecPerHour) mod SecPerMinute;
  ms := 0;
  Result := dd + EncodeTime(hh, mm, ss, ms);
end;

function CopyDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;


function MoveDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_MOVE;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

function DelDir(dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(dir + #0);
  end;
  Result := (0 = ShFileOperation(fos));
end;


type
  TRGBArray = array[0..64000] of TRGBTriple;
  PRGBArray = ^TRGBArray;

  TQuadArray = array[0..64000] of TRGBQuad;
  PQuadArray = ^TQuadArray;

 //scanline implementation of Stretchblt/Delete_Scans
  //about twice as fast
  //Stretches Src to Dest, rs is source rect, rd is dest. rect
  //The stretch is centered, i.e the center of rs is mapped to the center of rd.
  //Src, Dest are assumed to be bottom up

procedure DeleteScansRect(Src, Dest: TBitmap; rs, rd: TRect);
var
  xsteps, ysteps: array of Integer;
  intscale: Integer;
  i, x, y, x1, x2, bitspp, bytespp: Integer;
  ts, td: PByte;
  bs, bd, WS, hs, w, h: Integer;
  Rows, rowd: PByte;
  j, c: Integer;
  pf: TPixelFormat;
  xshift, yshift: Integer;
begin
  WS := rs.Right - rs.Left;
  hs := rs.Bottom - rs.Top;
  w  := rd.Right - rd.Left;
  h  := rd.Bottom - rd.Top;
  pf := Src.PixelFormat;
  if (pf <> pf32Bit) and (pf <> pf24bit) then
  begin
    pf := pf24bit;
    Src.PixelFormat := pf;
  end;
  Dest.PixelFormat := pf;
  if not (((w <= WS) and (h <= hs)) or ((w >= WS) and (h >= hs))) then
  //we do not handle a mix of up-and downscaling,
  //using threadsafe StretchBlt instead.
  begin
    Src.Canvas.Lock;
    Dest.Canvas.Lock;
    try
      SetStretchBltMode(Dest.Canvas.Handle, STRETCH_DELETESCANS);
      StretchBlt(Dest.Canvas.Handle, rd.Left, rd.Top, w, h,
        Src.Canvas.Handle, rs.Left, rs.Top, WS, hs, SRCCopy);
    finally
      Dest.Canvas.Unlock;
      Src.Canvas.Unlock;
    end;
    Exit;
  end;

  if pf = pf24bit then
  begin
    bitspp  := 24;
    bytespp := 3;
  end
  else
  begin
    bitspp  := 32;
    bytespp := 4;
  end;
  bs := (Src.Width * bitspp + 31) and not 31;
  bs := bs div 8; //BytesPerScanline Source
  bd := (Dest.Width * bitspp + 31) and not 31;
  bd := bd div 8; //BytesPerScanline Dest
  if w < WS then //downsample
  begin
    //first make arrays of the skipsteps
    SetLength(xsteps, w);
    SetLength(ysteps, h);
    intscale := round(WS / w * $10000);
    x1       := 0;
    x2       := (intscale + $7FFF) shr 16;
    c  := 0;
    for i := 0 to w - 1 do
    begin
      xsteps[i] := (x2 - x1) * bytespp;
      x1        := x2;
      x2        := ((i + 2) * intscale + $7FFF) shr 16;
      if i = w - 2 then
        c := x1;
    end;
    xshift   := min(max((WS - c) div 2, - rs.Left), Src.Width - rs.Right);
    intscale := round(hs / h * $10000);
    x1       := 0;
    x2       := (intscale + $7FFF) shr 16;
    c        := 0;
    for i := 0 to h - 1 do
    begin
      ysteps[i] := (x2 - x1) * bs;
      x1        := x2;
      x2        := ((i + 2) * intscale + $7FFF) shr 16;
      if i = h - 2 then
        c := x1;
    end;
    yshift := min(max((hs - c) div 2, - rs.Top), Src.Height - rs.Bottom);
    if pf = pf24bit then
    begin
      Rows := @PRGBArray(Src.Scanline[rs.Top + yshift])^[rs.Left + xshift];
      rowd := @PRGBArray(Dest.Scanline[rd.Top])^[rd.Left];
      for y := 0 to h - 1 do
      begin
        ts := Rows;
        td := rowd;
        for x := 0 to w - 1 do
        begin
          pRGBTriple(td)^ := pRGBTriple(ts)^;
          Inc(td, bytespp);
          Inc(ts, xsteps[x]);
        end;
        Dec(rowd, bd);
        Dec(Rows, ysteps[y]);
      end;
    end
    else
    begin
      Rows := @PQuadArray(Src.Scanline[rs.Top + yshift])^[rs.Left + xshift];
      rowd := @PQuadArray(Dest.Scanline[rd.Top])^[rd.Left];
      for y := 0 to h - 1 do
      begin
        ts := Rows;
        td := rowd;
        for x := 0 to w - 1 do
        begin
          pRGBQuad(td)^ := pRGBQuad(ts)^;
          Inc(td, bytespp);
          Inc(ts, xsteps[x]);
        end;
        Dec(rowd, bd);
        Dec(Rows, ysteps[y]);
      end;
    end;
  end
  else
  begin
    //first make arrays of the steps of uniform pixels
    SetLength(xsteps, WS);
    SetLength(ysteps, hs);
    intscale := round(w / WS * $10000);
    x1       := 0;
    x2       := (intscale + $7FFF) shr 16;
    c        := 0;
    for i := 0 to WS - 1 do
    begin
      xsteps[i] := x2 - x1;
      x1        := x2;
      x2        := ((i + 2) * intscale + $7FFF) shr 16;
      if x2 > w then
        x2 := w;
      if i = WS - 1 then
        c := x1;
    end;
    if c < w then //>is now not possible
    begin
      xshift         := (w - c) div 2;
      yshift         := w - c - xshift;
      xsteps[WS - 1] := xsteps[WS - 1] + xshift;
      xsteps[0]      := xsteps[0] + yshift;
    end;
    intscale := round(h / hs * $10000);
    x1       := 0;
    x2       := (intscale + $7FFF) shr 16;
    c        := 0;
    for i := 0 to hs - 1 do
    begin
      ysteps[i] := (x2 - x1);
      x1        := x2;
      x2        := ((i + 2) * intscale + $7FFF) shr 16;
      if x2 > h then
        x2 := h;
      if i = hs - 1 then
        c := x1;
    end;
    if c < h then
    begin
      yshift         := (h - c) div 2;
      ysteps[hs - 1] := ysteps[hs - 1] + yshift;
      yshift         := h - c - yshift;
      ysteps[0]      := ysteps[0] + yshift;
    end;
    if pf = pf24bit then
    begin
      Rows := @PRGBArray(Src.Scanline[rs.Top])^[rs.Left];
      rowd := @PRGBArray(Dest.Scanline[rd.Top])^[rd.Left];
      for y := 0 to hs - 1 do
      begin
        for j := 1 to ysteps[y] do
        begin
          ts := Rows;
          td := rowd;
          for x := 0 to WS - 1 do
          begin
            for i := 1 to xsteps[x] do
            begin
              pRGBTriple(td)^ := pRGBTriple(ts)^;
              Inc(td, bytespp);
            end;
            Inc(ts, bytespp);
          end;
          Dec(rowd, bd);
        end;
        Dec(Rows, bs);
      end;
    end
    else
    begin
      Rows := @PQuadArray(Src.Scanline[rs.Top])^[rs.Left];
      rowd := @PQuadArray(Dest.Scanline[rd.Top])^[rd.Left];
      for y := 0 to hs - 1 do
      begin
        for j := 1 to ysteps[y] do
        begin
          ts := Rows;
          td := rowd;
          for x := 0 to WS - 1 do
          begin
            for i := 1 to xsteps[x] do
            begin
              pRGBQuad(td)^ := pRGBQuad(ts)^;
              Inc(td, bytespp);
            end;
            Inc(ts, bytespp);
          end;
          Dec(rowd, bd);
        end;
        Dec(Rows, bs);
      end;
    end;
  end;
end;


type
  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..32767] of TRGBTriple;

procedure FadeIn(ImageFileName: TFileName; aForm1: TForm);
var
  Bitmap, BaseBitmap: TBitmap;
  Row, BaseRow: PRGBTripleArray;
  x, y, step: integer;
begin
  // Bitmaps vorbereiten / Preparing the Bitmap //
  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf32bit;  // oder pf24bit / or pf24bit //
    Bitmap.LoadFromFile(ImageFileName);
    BaseBitmap := TBitmap.Create;
    try
      BaseBitmap.PixelFormat := pf32bit;
      BaseBitmap.Assign(Bitmap);
      // Fading //
      for step := 0 to 32 do begin
        for y := 0 to (Bitmap.Height - 1) do begin
          BaseRow := BaseBitmap.Scanline[y];
          // Farben vom Endbild holen / Getting colors from final image //
          Row := Bitmap.Scanline[y];
          // Farben vom aktuellen Bild / Colors from the image as it is now //
          for x := 0 to (Bitmap.Width - 1) do begin
            Row[x].rgbtRed := (step * BaseRow[x].rgbtRed) shr 5;
            Row[x].rgbtGreen := (step * BaseRow[x].rgbtGreen) shr 5; // Fading //
            Row[x].rgbtBlue := (step * BaseRow[x].rgbtBlue) shr 5;
          end;
        end;
        aForm1.Canvas.Draw(0, 0, Bitmap);   // neues Bild ausgeben / Output new image //
        InvalidateRect(aForm1.Handle, nil, False);
        // Fenster neu zeichnen / Redraw window //
        RedrawWindow(aForm1.Handle, nil, 0, RDW_UPDATENOW);
      end;
    finally
      BaseBitmap.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;


procedure FadeOut(ImageFileName: TFileName; aForm1: TForm);
var
  Bitmap, BaseBitmap: TBitmap;
  Row, BaseRow: PRGBTripleArray;
  x, y, step: integer;
begin
  // Bitmaps vorbereiten / Preparing the Bitmap //
  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf32bit;  // oder pf24bit / or pf24bit //
    Bitmap.LoadFromFile(ImageFileName);
    BaseBitmap := TBitmap.Create;
    try
      BaseBitmap.PixelFormat := pf32bit;
      BaseBitmap.Assign(Bitmap);
      // Fading //
     for step := 32 downto 0 do begin
        for y := 0 to (Bitmap.Height - 1) do begin
          BaseRow := BaseBitmap.Scanline[y];
          // Farben vom Endbild holen / Getting colors from final image //
          Row := Bitmap.Scanline[y];
          // Farben vom aktuellen Bild / Colors from the image as it is now //
          for x := 0 to (Bitmap.Width - 1) do begin
            Row[x].rgbtRed := (step * BaseRow[x].rgbtRed) shr 5;
            Row[x].rgbtGreen := (step * BaseRow[x].rgbtGreen) shr 5; // Fading //
            Row[x].rgbtBlue := (step * BaseRow[x].rgbtBlue) shr 5;
          end;
        end;
        aForm1.Canvas.Draw(0, 0, Bitmap);   // neues Bild ausgeben / Output new image //
        InvalidateRect(aForm1.Handle, nil, False);
        // Fenster neu zeichnen / Redraw window //
        RedrawWindow(aForm1.Handle, nil, 0, RDW_UPDATENOW);
      end;
    finally
      BaseBitmap.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure FadeOut32(const Bmp: TImage; Pause: Integer);
var
  BytesPorScan, counter, w, h: Integer;
  p: pByteArray;
begin
  if not (Bmp.Picture.Bitmap.PixelFormat in [pf24Bit, pf32Bit]) then
    raise Exception.Create('Error, bitmap format is not supporting.');
  try
    BytesPorScan := Abs(Integer(Bmp.Picture.Bitmap.ScanLine[1]) -
      Integer(Bmp.Picture.Bitmap.ScanLine[0]));
  except
    raise Exception.Create('Error!!');
  end;

  for counter := 1 to 256 do begin
    for h := 0 to Bmp.Picture.Bitmap.Height - 1 do begin
      P := Bmp.Picture.Bitmap.ScanLine[h];
      for w := 0 to BytesPorScan - 1 do
        if P^[w] > 0 then P^[w] := P^[w] - 1;
    end;
    Sleep(Pause);
    Bmp.Refresh;
  end;
end;

function CheckBDEInstalled: Boolean;
begin
  Result := (dbiInit(nil) = DBIERR_NONE)
end;

// GlobalAllocString() - utility function to allocate global storage and
// put a string in it
// s - string to put in global storage
//
function GlobalAllocString(s: AnsiString): HGlobal;
var hgsz: HGlobal;
    p: PChar;
begin
   result:= 0;

   // allocate a block of storage large enough for string
   hgsz := GlobalAlloc(GMEM_MOVEABLE, Length(s) + 1);
   if (hgsz=0) then exit;

   // lock the storage and copy the string into it and then unlock the storage
   p := GlobalLock(hgsz);
   if (p=nil) then
   begin
      GlobalFree(hgsz);
      exit;
   end;

   lstrcpy(p, pchar(s));

   GlobalUnlock(hgsz);
   result:= hgsz;
end;

procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do Inc(I);
  Pos := I;
end;



function ScanNumber(const S: string; var Pos: Integer; var Number: Word): Boolean;
var
  I: Integer;
  N: Word;

  Function MonthStrToInt(s: string; var num: word): boolean;
  var i: integer;
  begin
     result:= False;
     for i:= 1 to 12 do begin
        if uppercase(s)=uppercase(ShortMonthNames[i]) then
        begin
           num:= i;
           result:= True;
           break;
        end
     end
  end;

begin
  Result := False;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (S[I] in ['0'..'9']) and (N < 1000) do
  begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then
  begin
    Pos := I;
    Number := N;
    Result := True;
  end;

  if (not Result) and MonthStrToInt(copy(s, i, 3), N) then
  begin
     Pos:= i+3;
     Number:= N;
     Result:= True;
  end
end;

function ScanString(const S: string; var Pos: Integer; const Symbol: string): Boolean;
begin
  Result := False;
  if Symbol <> '' then
  begin
    ScanBlanks(S, Pos);
    if AnsiCompareText(Symbol, Copy(S, Pos, Length(Symbol))) = 0 then
    begin
      Inc(Pos, Length(Symbol));
      Result := True;
    end;
  end;
end;

function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then
  begin
    Inc(Pos);
    Result := True;
  end;
end;


function LongMul(I, J: Word): Integer;
begin
  Result := I * J;
end;


function wwDoEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
begin
  Result := False;
  if (Hour < 24) and (Min < 60) and (Sec < 60) and (MSec < 1000) then
  begin
    Time := (LongMul(Hour * 60 + Min, 60000) + Sec * 1000 + MSec) / MSecsPerDay;
    Result := True;
  end;
end;



function ScanTime(const S: string; var Pos: Integer; var Time: TDateTime): Boolean;
var
  BaseHour: Integer;
  Hour, Min, Sec: Word;
begin
  Result := False;
  if not (ScanNumber(S, Pos, Hour) and ScanChar(S, Pos, TimeSeparator) and
    ScanNumber(S, Pos, Min)) then Exit;
  Sec := 0;
  if ScanChar(S, Pos, TimeSeparator) then
    if not ScanNumber(S, Pos, Sec) then Exit;
  BaseHour := -1;
  if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
    BaseHour := 0
  else
    if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
      BaseHour := 12;
  if BaseHour >= 0 then
  begin
    if (Hour = 0) or (Hour > 12) then Exit;
    if Hour = 12 then Hour := 0;
    Inc(Hour, BaseHour);
  end;
  ScanBlanks(S, Pos);
  Result := wwDoEncodeTime(Hour, Min, Sec, 0, Time);
end;

function IPToHostName(const IP: string): string;
var
  i: Integer;
  p: PHostEnt;
begin
  Result := '';
  i      := inet_addr(PChar(IP));
  if i <> u_long(INADDR_NONE) then
  begin
    p := GetHostByAddr(@i, SizeOf(Integer), PF_INET);
    if p <> nil then Result := p^.h_name;
  end
  else
    Result := 'Invalid IP address';
end;

 procedure GetZoneIcon(IconPath: string; var Icon: TIcon);
var
  FName, ImageName: string;
  h: hInst;
begin
  FName := Copy(IconPath, 1, Pos('#', IconPath) - 1);
  ImageName := Copy(IconPath, Pos('#', IconPath), Length(IconPath));
  h := LoadLibrary(Pchar(FName));
  try
    if h <> 0 then
    begin
      Icon.Handle := LoadImage(h, Pchar(ImageName), IMAGE_ICON, 16, 16, 0);
    end;
  finally
    FreeLibrary(h);
  end;
end;

function GetZoneAttributes(const URL: string): TZoneAttributes;
var
  pw: Pwidechar;
  dwZone: Cardinal;
  ZoneAttr: TZoneAttributes; //Defined in Urlmon.pas
var
  ZoneManager: IInternetZoneManager;
  SecManager: IInternetSecurityManager;
begin
  ZeroMemory(@ZoneAttr, SizeOf(TZoneAttributes));
  if CoInternetCreateSecuritymanager(nil, SecManager, 0) = S_OK then
    if CoInternetCreateZoneManager(nil, ZoneManager, 0)  = S_OK then
    begin
      SecManager.MapUrlToZone(PWideChar(WideString(URL)), dwZone, 0);
      ZoneManager.GetZoneAttributes(dwZone, Result);
    end;
end;

procedure CGITESTer;
var
   c,a,Name,Email:string;
   b:integer;
begin
     name    :='';
     email   :='';
     { "a" contains the commandline passed by the web server program. }
     a:=ParamStr(1);
     { parsing... }
     for b:=1 to length(a) do begin
         c:=copy(a,b,1);
         if (c='&') and (name='') then begin
             name:=copy(a,6,b-6);
             email:=copy(a,b+7,length(a)-(b+6));
             end;
         end;
     {The following codes sends HTML code to the hosts browser with the
      information you want them to see. You need to know HTML coding. }
     if (name='') or (email='') then begin
        writeln;
        writeln('<html> <head> <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
        writeln('<meta name="GENERATOR" content="The name of your COMPANY">');
        writeln('<title>Untitled Normal Page</title>');
        writeln('</head>');
        writeln('<body bgcolor="#000080" link="#FFFF00" vlink="#00FFFF" alink="#FFFFFF">');
        writeln('<p align="center"><font color="#FFFFFF" size="3" face="Arial"><strong><u>My Home');
        writeln('Inc.</u></strong></font></p>');
        writeln('<p align="center"><font color="#FFFFFF" size="3" face="Arial">Your');
        writeln('request to be placed onto our mailing list has been REJECTED</p>');
        writeln('This was due to your details not entered correctly</font></p>');
        writeln('    <p align="left"><a href="http://www.my-home.inc"><font');
        writeln('    color="#FFFFFF" size="3" face="Arial">[Return To My Home');
        writeln('    ]</font></a></p>');
        writeln('    <p align="left"><a href="http://www.my-home.inc/mail.htm"><font');
        writeln('    color="#FFFFFF" size="3" face="Arial">[Return and try');
        writeln('    again]</font></a></p>');
        writeln('</blockquote>');
        writeln('<p> </p>');
        writeln('</body>');
        writeln('</html>');
        //close();
        end
     Else Begin
        writeln;
        writeln('<html> <head> <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
        writeln('<meta name="GENERATOR" content="Microsoft FrontPage Express 2.0">');
        writeln('<title>Untitled Normal Page</title>');
        writeln('</head>');
        writeln('<body bgcolor="#000080" link="#FFFF00" vlink="#00FFFF" alink="#FFFFFF">');
        writeln('<p align="center"><font color="#FFFFFF" size="3" face="Arial"><strong><u>My Home');
        writeln(' Inc.</u></strong></font></p>');
        writeln('<p align="center"><font color="#FFFFFF" size="3" face="Arial">Your');
        writeln('request to be placed onto our mailing list has been accepted</font></p>');
        writeln('<blockquote>');
        writeln('    <p align="left"><font color="#FFFFFF" size="3" face="Arial">Your');
        writeln('    Details Are</font></p>');
        writeln('    <p align="left"><font color="#FFFFFF" size="3" face="Arial">Name:');
        writeln('    '+name+'<br>');
        writeln('    Email Address: '+email+'</font></p>');
        writeln('    <p align="left"><a href="http://www.my-home.inc"><font');
        writeln('    color="#FFFFFF" size="3" face="Arial">[Return To My Home Inc.');
        writeln('    ]</font></a></p>');
        writeln('</blockquote>');
        writeln('<p> </p>');
        writeln('</body>');
        writeln('</html>');
        //close;
        end;
End;


const
  nString = 'SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\NetworkCards';
  nEthernet = 'Ethernet';
  nEtherjet = 'Etherjet'; {if Hardware IBM PL300 with Chip 10/100}
  nTcpIp1 = 'SYSTEM\CurrentControlSet\Services\';
  nTcpIp2 = '\Parameters\Tcpip';

var
  reg: TRegistry;
  buffer1, buffer2, buffer3: array [1..32] of Char;
  i: Integer;
  ipaddress, subnetmask, DefaultGateway: string;
  Adapter, Adapter_Key: string;
  stringlist: TStrings;


function search_adapter_key_networkcard: string;
var
  astring, description, st: string;
  nPos: integer;
  ServiceName: string;
begin
  reg := TRegistry.Create;
  stringlist  := TStringList.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey(nString, False);
  reg.GetKeyNames(stringlist);    {search all subkeys
                                   such alle unterschlüssel}
  reg.CloseKey;

  for i := 0 to (stringlist.Count - 1) do
  begin
    st := stringlist[i];
    aString := nString + '\' + st;
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey(aString, False);
    description := reg.ReadString('Description');
    nPos:= AnsiPos(nEthernet, description); {search description for string Ethernet
                                             Beschreibung nach dem string Ethernet absuchen}
    if nPos > 0 then
    begin
      ServiceName := reg.ReadString('ServiceName');
      Adapter_Key := nTcpIp1 + ServiceName + nTcpIp2;
    end;
    nPos := AnsiPos(nEtherjet, description); {search description for string 'Etherjet
                                              if IBM PL300 with MotherboardChip}
    if nPos > 0 then
    begin
      ServiceName := reg.ReadString('ServiceName');
      Adapter_Key := nTcpIp1 + ServiceName + nTcpIp2;
    end;

    reg.CloseKey;
  end;
  Result := Adapter_Key;
end;


 //getmacaddress 1+2

{type
  TAdapterStatus = record
    adapter_address: array [0..5] of char;
    filler: array [1..4 * SizeOf(char) + 19 * SizeOf(Word) + 3 * SizeOf(DWORD)] of
    Byte;
  end;
 }

 type
  THostInfo = record
    username: PWideChar;
    logon_domain: PWideChar;
    oth_domains: PWideChar;
    logon_server: PWideChar;
  end;{record}


  {TNameBuffer= Packed record
name:Array[0..16 - 1] of Char;
name_num:Char;
name_flags:Char;
end;}


function CoCreateGuid(var guid: TGUID): HResult; stdcall; far external 'ole32.dll';

function Get_MACAddress: string;
var
g: TGUID;
i: Byte;
begin
Result := '';
CoCreateGUID(g);
for i := 2 to 7 do
  Result := Result + IntToHex(g.D4[i], 2);
end;



function IsNetConnect: Boolean;
begin
  if GetSystemMetrics(SM_NETWORK) and $01 = $01 then Result := True
  else
    Result := False;
end;{function}

function AdapterToString(Adapter: TAdapterStatus): string;
begin
  with Adapter do Result :=
      Format('%2.2x-%2.2x-%2.2x-%2.2x-%2.2x-%2.2x',
      [Integer(adapter_address[0]), Integer(adapter_address[1]),
      Integer(adapter_address[2]), Integer(adapter_address[3]),
      Integer(adapter_address[4]), Integer(adapter_address[5])]);
end;{function}


(*const
  NCBNAMSZ = 16;        // absolute length of a net name
  MAX_LANA = 254;       // lana's in range 0 to MAX_LANA inclusive
  NRC_GOODRET = $00;       // good return
  NCBASTAT = $33;       // NCB ADAPTER STATUS
  NCBRESET = $32;       // NCB RESET
  NCBENUM = $37;       // NCB ENUMERATE LANA NUMBERS
  *)

{type
  PNCB = ^TNCB;
  TNCBPostProc = procedure(P: PNCB);
  stdcall;
  TNCB = record
    ncb_command: Byte;
    ncb_retcode: Byte;
    ncb_lsn: Byte;
    ncb_num: Byte;
    ncb_buffer: PChar;
    ncb_length: Word;
    ncb_callname: array [0..16 - 1] of char;
    ncb_name: array [0..16 - 1] of char;
    ncb_rto: Byte;
    ncb_sto: Byte;
    ncb_post: TNCBPostProc;
    ncb_lana_num: Byte;
    ncb_cmd_cplt: Byte;
    ncb_reserve: array [0..9] of char;
    ncb_event: THandle;
  end;                              }

  type
    Netbiosfunc=function(P:PNCB):Char;stdcall;


  PLanaEnum = ^TLanaEnum;
  TLanaEnum = record
    Length: Byte;
    lana: array [0..254] of Byte;
  end;

  ASTAT = record
    adapt: TAdapterStatus;
    namebuf: array [0..29] of TNameBuffer;
  end;


function GetMacAddresses2(const Machine: string; const Addresses: TStrings): Integer;
var
  NCB: TNCB;
  Enum: TLanaEnum;
  I: integer;
  Adapter: ASTAT;
  MachineName: string;
begin
  Result := -1;
  Addresses.Clear;
  MachineName := UpperCase(Machine);
  if MachineName = '' then    MachineName := '*';
  FillChar(NCB, SizeOf(NCB), #0);
  NCB.ncb_command := char(NCBENUM);
  NCB.ncb_buffer  := Pointer(@Enum);
  NCB.ncb_length  := SizeOf(Enum);
  //if Word(NetBios(@NCB)) = NRC_GOODRET then
  if word(NetBios(@NCB)) = NRC_GOODRET then begin
    Result := Enum.Length;
    for I := 0 to Ord(Enum.Length) - 1 do
    begin
      FillChar(NCB, SizeOf(TNCB), #0);
      NCB.ncb_command  := char(NCBRESET);
      NCB.ncb_lana_num := char(Enum.lana[I]);
      if Word(NetBios(@NCB)) = NRC_GOODRET then
      begin
        FillChar(NCB, SizeOf(TNCB), #0);
        NCB.ncb_command  := char(NCBASTAT);
        NCB.ncb_lana_num := char(Enum.lana[i]);
        StrLCopy(NCB.ncb_callname, PChar(MachineName), NCBNAMSZ);
        StrPCopy(@NCB.ncb_callname[Length(MachineName)],
          StringOfChar(' ', NCBNAMSZ - Length(MachineName)));
        NCB.ncb_buffer := PChar(@Adapter);
        NCB.ncb_length := SizeOf(Adapter);
        if Word(NetBios(@NCB)) = NRC_GOODRET then
          Addresses.Add(AdapterToString(Adapter.adapt));
      end;
    end;
  end;
end;{function}

//type
 //PAdapterStatus=^TAdapterStatus;

function GetMACAdress: string;
var
  NCB: PNCB;
  Adapter: PAdapterStatus;

  URetCode: PChar;
  RetCode: char;
  I: integer;
  Lenum: PlanaEnum;
  _SystemID: string;
  TMPSTR: string;
begin
  Result    := '';
  _SystemID := '';
  Getmem(NCB, SizeOf(TNCB));
  Fillchar(NCB^, SizeOf(TNCB), 0);

  Getmem(Lenum, SizeOf(TLanaEnum));
  Fillchar(Lenum^, SizeOf(TLanaEnum), 0);

  Getmem(Adapter, SizeOf(TAdapterStatus));
  Fillchar(Adapter^, SizeOf(TAdapterStatus), 0);

  Lenum.Length    := byte(chr(0));
  NCB.ncb_command := (chr(NCBENUM));
  NCB.ncb_buffer  := Pointer(Lenum);
  NCB.ncb_length  := SizeOf(Lenum);
  //RetCode         := Netbiosfunc(NCB);

  i := 0;
  repeat
    Fillchar(NCB^, SizeOf(TNCB), 0);
    Ncb.ncb_command  := (chr(NCBRESET));
    //Ncb.ncb_lana_num := lenum.lana[I];
   // RetCode          := Netbiosfunc(Ncb);

    Fillchar(NCB^, SizeOf(TNCB), 0);
   // Ncb.ncb_command  := chr(NCBASTAT);
    //Ncb.ncb_lana_num := lenum.lana[I];
    // Must be 16
    Ncb.ncb_callname := '*               ';

    Ncb.ncb_buffer := Pointer(Adapter);

    Ncb.ncb_length := SizeOf(TAdapterStatus);
    //RetCode        := Netbios(Ncb);
    //---- calc _systemId from mac-address[2-5] XOR mac-address[1]...
    if (RetCode = chr(0)) or (RetCode = chr(6)) then
    begin
      _SystemId := IntToHex(Ord(Adapter.adapter_address[0]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[1]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[2]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[3]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[4]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[5]), 2);
    end;
    Inc(i);
  until (I >= Ord(Lenum.Length)) or (_SystemID <> '00-00-00-00-00-00');
  FreeMem(NCB);
  FreeMem(Adapter);
  FreeMem(Lenum);
  GetMacAdress := _SystemID;
end;


function GetMACAddress2: string;
var
  NCB: PNCB;
  Adapter: PAdapterStatus;

  URetCode: PChar;
  RetCode: char;
  I: integer;
  Lenum: PlanaEnum;
  _SystemID: string;
  TMPSTR: string;
begin
  Result    := '';
  _SystemID := '';
  Getmem(NCB, SizeOf(TNCB));
  Fillchar(NCB^, SizeOf(TNCB), 0);

  Getmem(Lenum, SizeOf(TLanaEnum));
  Fillchar(Lenum^, SizeOf(TLanaEnum), 0);

  Getmem(Adapter, SizeOf(TAdapterStatus));
  Fillchar(Adapter^, SizeOf(TAdapterStatus), 0);

  Lenum.Length    := byte(chr(0));
  NCB.ncb_command := (chr(NCBENUM));
  NCB.ncb_buffer  := Pointer(Lenum);
  NCB.ncb_length  := SizeOf(Lenum);
  RetCode         := Netbios(NCB);

  i := 0;
  repeat
    Fillchar(NCB^, SizeOf(TNCB), 0);
    Ncb.ncb_command  := chr(NCBRESET);
    Ncb.ncb_lana_num := char(lenum.lana[I]);
    RetCode          := Netbios(Ncb);

    Fillchar(NCB^, SizeOf(TNCB), 0);
    Ncb.ncb_command  := chr(NCBASTAT);
    Ncb.ncb_lana_num := char(lenum.lana[I]);
    // Must be 16
    Ncb.ncb_callname := '*               ';

    Ncb.ncb_buffer := Pointer(Adapter);

    Ncb.ncb_length := SizeOf(TAdapterStatus);
    RetCode        := Netbios(Ncb);
    //---- calc _systemId from mac-address[2-5] XOR mac-address[1]...
    if (RetCode = chr(0)) or (RetCode = chr(6)) then
    begin
      _SystemId := IntToHex(Ord(Adapter.adapter_address[0]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[1]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[2]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[3]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[4]), 2) + '-' +
        IntToHex(Ord(Adapter.adapter_address[5]), 2);
    end;
    Inc(i);
  until (I >= Ord(Lenum.Length)) or (_SystemID <> '00-00-00-00-00-00');
  FreeMem(NCB);
  FreeMem(Adapter);
  FreeMem(Lenum);
  GetMacAddress2:= _SystemID;
end;


function ConnectDrive(_drvLetter: string; _netPath: string; _showError: Boolean; _reconnect: Boolean): DWORD;
var
  nRes: TNetResource;
  errCode: DWORD;
  dwFlags: DWORD;
begin
  { Fill NetRessource with #0 to provide uninitialized values }
  { NetRessource mit #0 füllen => Keine unitialisierte Werte }
  FillChar(NRes, SizeOf(NRes), #0);
  nRes.dwType := RESOURCETYPE_DISK;
  { Set Driveletter and Networkpath }
  { Laufwerkbuchstabe und Netzwerkpfad setzen }
  nRes.lpLocalName  := PChar(_drvLetter);
  nRes.lpRemoteName := PChar(_netPath); { Example: \\Test\C }
  { Check if it should be saved for use after restart and set flags }
  { Überprüfung, ob gespeichert werden soll }
  if _reconnect then
    dwFlags := CONNECT_UPDATE_PROFILE and CONNECT_INTERACTIVE
  else
    dwFlags := CONNECT_INTERACTIVE;

  errCode := WNetAddConnection3(HInstance, nRes, nil, nil, dwFlags);
  { Show Errormessage, if flag is set }
  { Fehlernachricht aneigen }
  if (errCode <> NO_ERROR) and (_showError) then
  begin
    Forms.Application.MessageBox(PChar('An error occured while connecting:' + #13#10 +
      SysErrorMessage(GetLastError)),
      'Error while connecting!',
      MB_OK);
  end;
  Result := errCode; { NO_ERROR }
end;

function ConnectPrinterDevice(_lptPort: string; _netPath: string; _showError: Boolean; _reconnect: Boolean): DWORD;
var
  nRes: TNetResource;
  errCode: DWORD;
  dwFlags: DWORD;
begin
  { Fill NetRessource with #0 to provide uninitialized values }
  { NetRessource mit #0 füllen => Keine unitialisierte Werte }
  FillChar(NRes, SizeOf(NRes), #0);
  nRes.dwType := RESOURCETYPE_PRINT;
  { Set Printername and Networkpath }
  { Druckername und Netzwerkpfad setzen }
  nRes.lpLocalName  := PChar(_lptPort);
  nRes.lpRemoteName := PChar(_netPath); { Example: \\Test\Printer1 }
  { Check if it should be saved for use after restart and set flags }
  { Überprüfung, ob gespeichert werden soll }
  if _reconnect then
    dwFlags := CONNECT_UPDATE_PROFILE and CONNECT_INTERACTIVE
  else
    dwFlags := CONNECT_INTERACTIVE;

  errCode := WNetAddConnection3(Hinstance, nRes, nil, nil, dwFlags);
  { Show Errormessage, if flag is set }
  { Fehlernachricht aneigen }
  if (errCode <> NO_ERROR) and (_showError) then
  begin
    Forms.Application.MessageBox(PChar('An error occured while connecting:' + #13#10 +
      SysErrorMessage(GetLastError)),
      'Error while connecting!',
      MB_OK);
  end;
  Result := errCode; { NO_ERROR }
end;

function DisconnectNetDrive(_locDrive: string; _showError: Boolean; _force: Boolean; _save: Boolean): DWORD;
var
  dwFlags: DWORD;
  errCode: DWORD;
begin
  { Set dwFlags, if necessary }
  { Setze dwFlags auf gewünschten Wert }
  if _save then
    dwFlags := CONNECT_UPDATE_PROFILE
  else
    dwFlags := 0;
  { Cancel the connection see also at http://www.swissdelphicenter.ch/en/showcode.php?id=391 }
  { Siehe auch oben genannten Link (Netzlaufwerke anzeigen) }
  errCode := WNetCancelConnection2(PChar(_locDrive), dwFlags, _force);
  { Show Errormessage, if flag is set }
  { Fehlernachricht anzeigen }
  if (errCode <> NO_ERROR) and (_showError) then
  begin
    Forms.Application.MessageBox(PChar('An error occured while disconnecting:' + #13#10 +
      SysErrorMessage(GetLastError)),
      'Error while disconnecting',
      MB_OK);
  end;
  Result := errCode; { NO_ERROR }
end;

const
  MODEM = 1;
  LAN = 2;
  PROXY = 4;
  BUSY = 8;

function GetConnectionKind(var strKind: string): Boolean;
var
  flags: DWORD;
begin
  strKind := '';
  Result := InternetGetConnectedState(@flags, 0);
  if Result then
  begin
    if (flags and MODEM) = MODEM then strKind := 'Modem';
    if (flags and LAN) = LAN then strKind := 'LAN';
    if (flags and PROXY) = PROXY then strKind := 'Proxy';
    if (flags and BUSY) = BUSY then strKind := 'Modem Busy';
  end;
end;

function floattoint(value: double): Integer;
   begin
        //MyFunc:={Do some Math calcs with Value};
        result:= Round(value); //Round
   end;

   function SystemTimeToTzSpecificLocalTime(
  lpTimeZoneInformation: PTimeZoneInformation;
lpUniversalTime, lpLocalTime: PSystemTime): BOOL; stdcall; external 'kernel32.dll';

function TzSpecificLocalTimeToSystemTime(
  lpTimeZoneInformation: PTimeZoneInformation;
lpLocalTime, lpUniversalTime: PSystemTime): BOOL; stdcall; external 'kernel32.dll';

   function JavaToDelphiDateTime(const dt: int64): TDateTime;
var
  t: TSystemTime;
begin
  DateTimeToSystemTime(25569 + (dt / 86400000), t);
  SystemTimeToTzSpecificLocalTime(nil, @t, @t);
  Result := SystemTimeToDateTime(t);
end;

function DelphiToJavaDateTime(const dt: TDateTime): int64;
var
  t: TSystemTime;
begin
  DateTimeToSystemTime(dt, t);
  TzSpecificLocalTimeToSystemTime(nil, @t, @t);
  Result := Round((SystemTimeToDateTime(t) - 25569) * 86400000)
end;


function GetTimeBias: integer;
var
  tzi : TTimeZoneInformation;
begin
  case GetTimeZoneInformation(tzi) of
    TIME_ZONE_ID_UNKNOWN : Result := tzi.Bias;
    TIME_ZONE_ID_STANDARD: Result := tzi.Bias + tzi.StandardBias;
    TIME_ZONE_ID_DAYLIGHT: Result := tzi.Bias + tzi.DaylightBias;
  else
    Result := 0;
  end;
end;

function DelphiDateTimeToISO8601Date(dt: TDateTime): String;
const
  FMT_DATE = '%.4d-%.2d-%.2d';
  FMT_TIME = 'T%.2d:%.2d:%.2d.%.3d';
  FMT_ZONE = '%s%.2d:%.2d';
var
  year, month, day, hour, min, sec, msec: Word;
  tzh: SmallInt;
  tzm: Word;
  sign: Char;
  bias: Integer;
begin
  try
    DecodeDate(dt, year, month, day);
    DecodeTime(dt, hour, min, sec, msec);
    bias := GetTimeBias;
    tzh := Abs(bias) div 60;
    tzm := Abs(bias) - tzh * 60;
    if Bias > 0 then
      sign := '-' else
      sign := '+';
    Result := Format(FMT_DATE + FMT_TIME + FMT_ZONE,
      [year, month, day, hour, min, sec, msec, sign, tzh, tzm]);
  except
    if dt = 0 then
      raise
    else
      DelphiDateTimeToISO8601Date(0);
  end;
end;

CONST  Numeric: Set of Char = ['0'..'9'];
       Alpha  : Set of Char = ['A'..'Z', 'a'..'z'];
       AlphaN : Set of Char = ['0'..'9', 'A'..'Z', 'a'..'z'];

PROCEDURE WrapLines(VAR a, b: String; len: Integer);
{ =========================================================== }
VAR Temp: Array[0..514] of Char;
    i, j, k: Integer;

    PROCEDURE BreakLine(i: Integer);
    { ------------------------------------------------------- }
    VAR p: PChar;
    BEGIN{BreakLine}
        p := @Temp[i];
        b := StrPas(p);
        p^ := #0;
        a := StrPas(@Temp);
    END{BreakLine};

BEGIN{WrapLines}

    k := Length(a) + Length(b);
    If Len < k Then Begin

       StrPCopy(@Temp, a);
       StrPCopy(@Temp[Length(a)], b);
       i := Len;

       { locate Space before current word }
       While (i > 1) and (Temp[i] <> ' ') Do Dec(i);
       j := i;

       { locate space at end of previous word }
       While (i > 1) and (Temp[i] = ' ') Do Dec(i);

       If i > 1 Then Begin
          While (j <= k) and (Temp[j] = ' ') Do Inc(j);
          BreakLine(j)
       End Else Begin
          i := Len;

          { Before punctuation }
          While (i > 1) and NOT(Temp[i] in AlphaN) Do Dec(i);

          { Beginning of current word }
          While (i > 1) and (Temp[i] in AlphaN) Do Dec(i);

          If i > 1 Then
             BreakLine(i+1)
          Else BreakLine(Len);
       End;
    End Else Begin
       { combine & clear overflow if len <= combined length }
       a := a + b;
       b := '';
    End;

END{WrapLines};

type TUArrDW = array of DWord;

function SwapEndian(const Value: LongWord): LongWord;
begin
  Result := ((Value and $000000FF) shl 24)  or
            ((Value and $0000FF00) shl 8)   or
            ((Value and $00FF0000) shr 8)   or
            ((Value and $FF000000) shr 24);
end;

procedure UASwapEndian(var UC: TUArrDW);
var i: integer;
begin
  for i := 0 to High(UC) do UC[i] := SwapEndian(DWord(UC[i]));
end;

function SliceByteArray(const B: array of Byte; Start, Len: Integer): TBytes;
begin
  if Start < 0 then
    Start := 0;
  if Len < 0 then
    Len := 0
  else if Start >= Length(B) then
    Len := 0
  else if Start + Len > Length(B) then
    Len := Length(B) - Start;
  SetLength(Result, Len);
  if Len > 0 then
    Move(B[Start], Result[0], Len);
end;

function ShiftByteArray(var A: TBytes): Byte;
begin
  Assert(Length(A) > 0, 'A must be a non-empty array');
  Result := A[0];
  Move(A[1], A[0], Length(A) - 1);
  SetLength(A, Length(A) - 1);
end;

procedure PushByteArray(const B: Byte; var A: TBytes);
begin
  SetLength(A, Length(A) + 1);
  A[Pred(Length(A))] := B;
end;

function PopByteArray(var A: TBytes): Byte;
begin
  Assert(Length(A) > 0, 'A must be a non-empty array');
  Result := A[Pred(Length(A))];
  SetLength(A, Length(A) - 1);
end;

procedure AppendByteArray(var B1: TBytes; const B2: array of Byte);
var
  OldB1Len: Integer;
begin
  if Length(B2) = 0 then
    Exit;
  OldB1Len := Length(B1);
  SetLength(B1, OldB1Len + Length(B2));
  Move(B2[0], B1[OldB1Len], Length(B2));
end;

function CloneByteArray(const B: array of Byte): TBytes;
begin
  SetLength(Result, Length(B));
  if Length(B) > 0 then
    Move(B[0], Result[0], Length(B));
end;

function StrLeft(const S: AnsiString; Count: Integer): AnsiString;
begin
  Result := Copy(S, 1, Count);
end;


procedure StrToStrings(S, Sep: AnsiString; const List: TStrings; const AllowEmptyString: Boolean = True);
var
  I, L: Integer;
  Left: AnsiString;
begin
  Assert(List <> nil);
  List.Clear;
  L := Length(Sep);
  I := Pos(Sep, S);
  while (I > 0) do
  begin
    Left := StrLeft(S, I - 1);
    if (Left <> '') or AllowEmptyString then
      List.Add(Left);
    System.Delete(S, 1, I + L - 1);
    I := Pos(Sep, S);
  end;
  if S <> '' then
    List.Add(S);  // Ignore empty strings at the end.
end;


procedure TailOfFile(aFilename: string; aTailContainer: TStrings; MaxNumLines:integer=5);
const
  cBufferSize = 4096;
var
  theFileHandle: file of byte;
  theBuffer: array[0..cBufferSize] of byte;
  theReadChars: integer;
  s: string;
begin
  if Assigned(aTailContainer) and FileExists(aFilename) then
  begin
    aTailContainer.Clear;
    AssignFile(theFileHandle,aFilename);
    FileMode := 0;
    Reset(theFileHandle);
    if (FileSize(theFileHandle)>cBufferSize) then
      Seek(theFileHandle,FileSize(theFileHandle)-cBufferSize);
    BlockRead(theFileHandle,theBuffer,cBufferSize,theReadChars);
    CloseFile(theFileHandle);
    theBuffer[theReadChars] := 0;
    s := PChar(@theBuffer);
    aTailContainer.BeginUpdate;
    StrToStrings(s,#13#10,aTailContainer);
    while (aTailContainer.Count>MaxNumLines) do
      aTailContainer.Delete(0);
    aTailContainer.EndUpdate;
  end;//if
end;


procedure JumpToRegistryKey(Key: string);
var
  i, n: Integer;
  hWin: HWND;
  ExecInfo: ShellExecuteInfoA;
begin
  hWin := FindWindowA(PChar('RegEdit_RegEdit'), nil);
  if hWin = 0 then
  {if Regedit doesn't run then we launch it}
  begin
    FillChar(ExecInfo, 60, #0);
    with ExecInfo do
    begin
      cbSize := 60;
      fMask  := SEE_MASK_NOCLOSEPROCESS;
      lpVerb := PChar('open');
      lpFile := PChar('regedit.exe');
      nShow  := 1;
    end;
    ShellExecuteExA(@ExecInfo);
    WaitForInputIdle(ExecInfo.hProcess, 200);
    hWin := FindWindowA(PChar('RegEdit_RegEdit'), nil);
  end;
  ShowWindow(hWin, SW_SHOWNORMAL);
  hWin := FindWindowExA(hWin, 0, PChar('SysTreeView32'), nil);
  SetForegroundWindow(hWin);
  i := 30;
  repeat
    SendMessageA(hWin, WM_KEYDOWN, VK_LEFT, 0);
    Dec(i);
  until i = 0;
  Sleep(500);
  SendMessageA(hWin, WM_KEYDOWN, VK_RIGHT, 0);
  Sleep(500);
  i := 1;
  n := Length(Key);
  repeat
    if Key[i] = '\' then
    begin
      SendMessageA(hWin, WM_KEYDOWN, VK_RIGHT, 0);
      Sleep(500);
    end
    else
      SendMessageA(hWin, WM_CHAR, Integer(Key[i]), 0);
    i := i + 1;
  until i = n;
end;

procedure SetDecimalSeparator2(Ch: Char);
var
  DefLCID: LCID;
  Buffer: LPSTR;
begin
  Forms.Application.UpdateFormatSettings := True;
  StrPCopy(Buffer, Ch);
  DefLCID := GetThreadLocale;
  if SetLocaleInfo(DefLCID, LOCALE_SDecimal, Buffer) then
    DecimalSeparator := StrPas(Buffer)[1];
  Forms.Application.UpdateFormatSettings := False;
end;

procedure GetWaveOutDevices(DeviceNames: TStrings);
var
  DNum: Integer;
  i: Integer;
  Caps: TWaveOutCapsA;
begin
  DNum := waveOutGetNumDevs;  // Number of Devices
  for i := 0 to DNum - 1 do     // Query Devicenames
  begin
    waveOutGetDevCaps(i, @Caps, SizeOf(TWaveOutCapsA));
    DeviceNames.Add(string(Caps.szPname));
  end;
end;

procedure GetMIDIOutDevices(Devices: TStrings);
var
  i, DNum: Integer;
  Caps: TMIDIOUTCAPSA;
begin
  DNum := MIDIOutGetNumDevs;  // Number of Devices
  for i := 0 to DNum - 1 do     // Query Devicenames
  begin
    MIDIOutGetDevCaps(i, @Caps, SizeOf(TMIDIOutCapsA));
    Devices.Add(string(Caps.szPname));
  end;
end;

procedure ResizeBitmap(Bitmap: TBitmap; Width, Height: Integer; Background: TColor);
var
  R: TRect;
  B: TBitmap;
  X, Y: Integer;
begin
  if assigned(Bitmap) then begin   
    B:= TBitmap.Create;
    try
      if Bitmap.Width > Bitmap.Height then begin
        R.Right:= Width;
        R.Bottom:= ((Width * Bitmap.Height) div Bitmap.Width);    
        X:= 0;
        Y:= (Height div 2) - (R.Bottom div 2);
      end else begin
        R.Right:= ((Height * Bitmap.Width) div Bitmap.Height);
        R.Bottom:= Height;
        X:= (Width div 2) - (R.Right div 2);
        Y:= 0;
      end;           
      R.Left:= 0;
      R.Top:= 0;
      B.PixelFormat:= Bitmap.PixelFormat;
      B.Width:= Width;
      B.Height:= Height;
      B.Canvas.Brush.Color:= Background;
      B.Canvas.FillRect(B.Canvas.ClipRect);
      B.Canvas.StretchDraw(R, Bitmap);
      Bitmap.Width:= Width;
      Bitmap.Height:= Height;
      Bitmap.Canvas.Brush.Color:= Background;
      Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
      Bitmap.Canvas.Draw(X, Y, B);
    finally
      B.Free;
    end;
  end;
end;

function GetPNGSize2(const FileName: string): TSize;
var
  Fs: TFileStream;
  Tmp: Longint;
begin
  Result.Cx := -1;
  Result.Cy := -1;
  Fs := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    Fs.Seek($10, soFromBeginning);
    Fs.Read(Tmp, 4);
    asm
      MOV EAX,Tmp
      BSWAP EAX
      MOV Tmp,EAX
    end;
    Result.Cx := Tmp;

    Fs.Read(Tmp, 4);
    asm
      MOV EAX,Tmp
      BSWAP EAX
      MOV Tmp,EAX
    end;
    Result.Cy := Tmp;
  finally
    Fs.Free;
  end;
end;

function ProcessCount(const ExeName: String): Integer;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle:= CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize:= SizeOf(FProcessEntry32);
  ContinueLoop:= Process32First(FSnapshotHandle, FProcessEntry32);
  Result:= 0;
  while Integer(ContinueLoop) <> 0 do begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeName))) then Inc(Result);
    ContinueLoop:= Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;


function FindShellCmd(psExtension:string;psCmd:string): string;
  var r : TRegistry;
      sName : string;
  begin
     psExtension := Trim(psExtension);
     if psExtension = ''
     then begin
        Result := '';
        Exit;
     end;

     psCmd := Trim(psCmd);
     if psCmd = ''
     then
        psCmd := 'OPEN'
     else
        psCmd := UpperCase(psCmd);

     if psExtension[1] <> '.'
     then
        psExtension := '.' + psExtension;

     r := TRegistry.Create(KEY_READ);
     try
        r.RootKey := HKEY_LOCAL_MACHINE;
        r.OpenKeyReadOnly('software\classes\' + psExtension);
        sName := r.ReadString('');
        r.CloseKey();
        r.OpenKeyReadOnly('software\classes\' + sName + '\Shell\' + psCmd + '\Command');
        Result := r.ReadString('');
        r.CloseKey();
     finally
        FreeAndNil(r);
     end;
  end;
  function FindShellOpenCmd(psExtension:string):string;
  begin
     Result := FindShellCmd(psExtension,'OPEN');
  end;

  function FindShellPrintCmd(psExtension:string):string;
  begin
     Result := FindShellCmd(psExtension,'PRINT');
  end;


  function LocalExecute32(FileName:String; Wait:boolean; Visibility : integer;
                          lWaitFor:Cardinal=INFINITE):integer;
  var zAppName:array[0..512] of char;
      zCurDir:array[0..255] of char;
      WorkDir:String;
      StartupInfo:TStartupInfo;
      ProcessInfo:TProcessInformation;
  begin
     StrPCopy(zAppName,FileName);
     GetDir(0,WorkDir);
     StrPCopy(zCurDir,WorkDir);
     FillChar(StartupInfo,Sizeof(StartupInfo),#0);
     StartupInfo.cb := Sizeof(StartupInfo);
     StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
     StartupInfo.wShowWindow := Visibility;
     if not CreateProcess(nil,
        zAppName,                      { pointer to command line string }
        nil,                           { pointer to process security attributes }
        nil,                           { pointer to thread security attributes }
        false,                         { handle inheritance flag }
        CREATE_NEW_CONSOLE or          { creation flags }
        NORMAL_PRIORITY_CLASS,
        nil,                           { pointer to new environment block }
        nil,                           { pointer to current directory name }
        StartupInfo,                   { pointer to STARTUPINFO }
        ProcessInfo)                   { pointer to PROCESS_INF }
     then Result := -1
     else begin
        if Wait
        then begin
           Result := WaitforSingleObject(ProcessInfo.hProcess,lWaitFor);
           GetExitCodeProcess(ProcessInfo.hProcess,LongWord(Result));
        end;
     end;
  end;
  //{$endif}

   function Execute( psExeName:string):integer;
  begin
    // {$ifdef windows} result := LocalExecute(psExeName, false , SW_SHOW);   {$endif}
     (*{ifdef win32}*)  result := LocalExecute32(psExeName, false , SW_SHOW); //{$endif}
  end;


procedure PrintUsingShell( psFileName :string);
  var s : string;
      i : integer;
  begin
     if not FileExists(psFileName)
     then
        Exit;

     s := FindShellPrintCmd( ExtractFileExt(psFileName) );
     i := Pos('%1',s);
     if i > 0
     then begin
        System.Delete(s,i,2);
        System.Insert(psFileName,s,i);
        Execute(s);
     end;
  end;

 type
  TEXEVersionData = record
    CompanyName,
    FileDescription,
    FileVersion,
    InternalName,
    LegalCopyright,
    LegalTrademarks,
    OriginalFileName,
    ProductName,
    ProductVersion,
    Comments,
    PrivateBuild,
    SpecialBuild: string;
  end;

function GetEXEVersionData(const FileName: string): TEXEVersionData;
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
    wCodePage: word;
  end;
var
  dummy,
  len: cardinal;
  buf, pntr: pointer;
  lang: string;
begin
  len := GetFileVersionInfoSize(PChar(FileName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(FileName), 0, len, buf) then
      RaiseLastOSError;
     if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;
     lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);
     if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\CompanyName'), pntr, len){ and (@len <> nil)} then
      result.CompanyName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileDescription'), pntr, len){ and (@len <> nil)} then
      result.FileDescription := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, len){ and (@len <> nil)} then
      result.FileVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\InternalName'), pntr, len){ and (@len <> nil)} then
      result.InternalName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalCopyright'), pntr, len){ and (@len <> nil)} then
      result.LegalCopyright := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'), pntr, len){ and (@len <> nil)} then
      result.LegalTrademarks := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\OriginalFileName'), pntr, len){ and (@len <> nil)} then
      result.OriginalFileName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductName'), pntr, len){ and (@len <> nil)} then
      result.ProductName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductVersion'), pntr, len){ and (@len <> nil)} then
      result.ProductVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\Comments'), pntr, len){ and (@len <> nil)} then
      result.Comments := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\PrivateBuild'), pntr, len){ and (@len <> nil)} then
      result.PrivateBuild := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\SpecialBuild'), pntr, len){ and (@len <> nil)} then
      result.SpecialBuild := PChar(pntr);
  finally
    FreeMem(buf);
  end;
end;

function isAvxSupported: Boolean;
asm
{$IFDEF CPUX86}
    push ebx
{$ENDIF}
{$IFDEF CPUX64}
    mov r10, rbx
{$ENDIF}
    xor eax, eax
    cpuid
    cmp eax, 1
    jb @not_supported
    mov eax, 1
    cpuid
    and ecx, 018000000h
    cmp ecx, 018000000h
    jne @not_supported
    xor ecx, ecx
    db 0Fh, 01h, 0D0h //XGETBV
    and eax, 110b
    cmp eax, 110b
    jne @not_supported
    mov eax, 1
    jmp @done
@not_supported:
    xor eax, eax
@done:
{$IFDEF CPUX86}
    pop ebx
{$ENDIF}
{$IFDEF CPUX64}
    mov rbx, r10
{$ENDIF}
end;

function txtsearch(pat: string; text: string): integer;
var
  i, j, k, m, n: integer;
  skip: array [0..MAXCHAR] of integer;
  found: boolean;
begin
  found := FALSE;
  txtsearch := 0;
  m := length(pat);
  if m=0 then
  begin
    txtsearch := 1;
    found := TRUE;
  end;
  for k:=0 to MAXCHAR do
    skip[k] := m;   {*** Preprocessing ***}
  for k:= m-1 downto 1 do
    skip[ord(pat[k])] := m-k;
  k := m;
  n := length(text);            {*** Search ***}
  while not found and (k <= n) do
  begin
    i := k; j := m;
    while (j >= 1) do
    begin
      if text[i] <> pat[j] then
        j := -1
      else
      begin
        j := j-1;
        i := i-1;
      end;
      if j = 0 then
      begin
        txtsearch := i+1;
        found := TRUE;
      end;
      k := k + skip[ord(text[k])];
    end;
  end;
end;

const
IID_IOfficeAntiVirus : TGUID =    '{56FFCC30-D398-11d0-B2AE-00A0C908FA49}';
CATID_MSOfficeAntiVirus : TGUID = '{56FFCC30-D398-11d0-B2AE-00A0C908FA49}';

procedure GetRegisteredAntiviruses(ProgIDs: TStrings);
var
  CatInformation: ICatInformation;
  Enum: IEnumGUID;
  CLSID: TGUID;
  nFetched: Cardinal;
  CatId: TGUID;
begin
  CatInformation := CreateComObject(CLSID_StdComponentCategoryMgr)
    as ICatInformation;
  CatId := CATID_MSOfficeAntiVirus;
  OleCheck(CatInformation.EnumClassesOfCategories(1, @CatId, 0, nil, Enum));
  ProgIDs.BeginUpdate;
  try
    ProgIDs.Clear;
    while (Enum.Next(1, CLSID, nFetched) = S_OK) do begin
      ProgIDs.Add(GuidToString(clsid));
    end;
  finally
    ProgIDs.EndUpdate;
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_PsAPI(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PPointer', '^Pointer // will not work');
  CL.AddTypeS('_MODULEINFO', 'record lpBaseOfDll : ___Pointer; SizeOfImage : DWORD'
   +'; EntryPoint : ___Pointer; end');
  CL.AddTypeS('MODULEINFO', '_MODULEINFO');
  //CL.AddTypeS('LPMODULEINFO', '^_MODULEINFO // will not work');
  CL.AddTypeS('TModuleInfo', '_MODULEINFO');
 // CL.AddTypeS('PModuleInfo', 'LPMODULEINFO');
  //CL.AddTypeS('_PSAPI_WS_WATCH_INFORMATION', 'record FaultingPc : Pointer; Faul'
   //+'tingVa : Pointer; end');
  {CL.AddTypeS('PSAPI_WS_WATCH_INFORMATION', '_PSAPI_WS_WATCH_INFORMATION');
  CL.AddTypeS('TPSAPIWsWatchInformation', '_PSAPI_WS_WATCH_INFORMATION');
  CL.AddTypeS('PPSAPIWsWatchInformation', 'PPSAPI_WS_WATCH_INFORMATION');}
  CL.AddTypeS('_PROCESS_MEMORY_COUNTERS', 'record cb : DWORD; PageFaultCount : '
   +'DWORD; PeakWorkingSetSize : DWORD; WorkingSetSize : DWORD; QuotaPeakPagedP'
   +'oolUsage : DWORD; QuotaPagedPoolUsage : DWORD; QuotaPeakNonPagedPoolUsage '
   +': DWORD; QuotaNonPagedPoolUsage : DWORD; PagefileUsage : DWORD; PeakPagefileUsage : DWORD; end');
  CL.AddTypeS('PROCESS_MEMORY_COUNTERS', '_PROCESS_MEMORY_COUNTERS');
  CL.AddTypeS('TProcessMemoryCounters', '_PROCESS_MEMORY_COUNTERS');
  CL.AddTypeS('HCOLORSPACE', 'LongWord');
  CL.AddTypeS('TEXEVersionData', 'record CompanyName: string; FileDescription: '
   +'string; FileVersion: string; InternalName: string; LegalCopyright: string; LegalTrademarks: string; OriginalFileName '
   +': string; ProductName: string; ProductVersion: string; Comments:string; PrivateBuild:string; SpecialBuild:string; end');
   CL.AddTypeS('TUArrDW', 'array of DWord');

   CL.AddTypeS('TGeoInfo', 'record status: string; countrycode : '
   +'string; countryname : string; regioncode : string; city : string; zippostalcode : string; latitude '
   +': string; longitude : string; timezonename : string; gmtoffset: string; isdst: string; end');
   CL.AddTypeS('TUArrDW', 'array of DWord');

 CL.AddConstantN('UTF8BOM','string').SetString( #$EF#$BB#$BF);
 CL.AddConstantN('UTF16BEBOM','string').SetString( #$FE#$FF);
 CL.AddConstantN('UTF16LEBOM','string').SetString( #$FF#$FE);
 CL.AddConstantN('UTF32BEBOM','string').SetString( #$00#$00#$FE#$FF);
 CL.AddConstantN('UTF32LEBOM','string').SetString( #$FF#$FE#$00#$00);

  { TGeoInfo   = record
  Status        : string;
  CountryCode   : string;
  CountryName   : string;
  RegionCode    : string;
  City          : string;
  ZipPostalCode : string;
  Latitude      : string;
  Longitude     : string;
  TimezoneName  : string;
  Gmtoffset     : string;
  Isdst         : string;
 end; }

  CL.AddTypeS('MakeIntResourceA', 'PChar');
  //CL.AddTypeS('MakeIntResourceW', 'PWideChar');
  CL.AddTypeS('MakeIntResource', 'MakeIntResourceA');


  CL.AddConstantN('RT_CURSOR','LongInt').SetInt(( 1 ));
 CL.AddConstantN('RT_BITMAP','LongInt').SetInt(  ( 2 ));
 CL.AddConstantN('RT_ICON','LongInt').SetInt(  ( 3 ));
 CL.AddConstantN('RT_MENU','LongInt').SetInt(  ( 4 ));
 CL.AddConstantN('RT_DIALOG','LongInt').SetInt(  ( 5 ));
 CL.AddConstantN('RT_STRING','LongInt').SetInt(  ( 6 ));
 CL.AddConstantN('RT_FONTDIR','LongInt').SetInt(  ( 7 ));
 CL.AddConstantN('RT_FONT','LongInt').SetInt(  ( 8 ));
 CL.AddConstantN('RT_ACCELERATOR','LongInt').SetInt(  ( 9 ));
 CL.AddConstantN('RT_ACCELERATOR','LongInt').SetInt(  ( 9 ));
 CL.AddConstantN('RT_RCDATA','LongInt').SetInt(  ( 10 ));
// CL.AddConstantN('RT_MESSAGETABLE','LongInt').SetInt( MakeIntResource ( 11 ));

 CL.AddConstantN('RT_MESSAGETABLE','LongInt').SetInt(  ( 11 ));
 CL.AddConstantN('DIFFERENCE','LongInt').SetInt( 11);
 CL.AddConstantN('RT_VERSION','LongInt').SetInt(  ( 16 ));
 CL.AddConstantN('RT_DLGINCLUDE','LongInt').SetInt(  ( 17 ));
 CL.AddConstantN('RT_PLUGPLAY','LongInt').SetInt(  ( 19 ));
 CL.AddConstantN('RT_VXD','LongInt').SetInt(  ( 20 ));
 CL.AddConstantN('RT_ANICURSOR','LongInt').SetInt(  ( 21 ));
 CL.AddConstantN('RT_ANIICON','LongInt').SetInt(  ( 22 ));
  CL.AddConstantN('QS_KEY','LongWord').SetUInt( $0001);
 CL.AddConstantN('QS_MOUSEMOVE','LongWord').SetUInt( $0002);
 CL.AddConstantN('QS_MOUSEBUTTON','LongWord').SetUInt( $0004);
 CL.AddConstantN('QS_POSTMESSAGE','LongWord').SetUInt( $0008);
 CL.AddConstantN('QS_TIMER','LongWord').SetUInt( $0010);
 CL.AddConstantN('QS_PAINT','LongWord').SetUInt( $0020);
 CL.AddConstantN('QS_SENDMESSAGE','LongWord').SetUInt( $0040);
 CL.AddConstantN('QS_HOTKEY','LongWord').SetUInt( $0080);
 CL.AddConstantN('QS_ALLPOSTMESSAGE','LongWord').SetUInt( $0100);

 CL.AddConstantN('RESOURCE_CONNECTED','LongInt').SetInt( 1);
 CL.AddConstantN('RESOURCE_GLOBALNET','LongInt').SetInt( 2);
 CL.AddConstantN('RESOURCE_REMEMBERED','LongInt').SetInt( 3);
 CL.AddConstantN('RESOURCE_RECENT','LongInt').SetInt( 4);
 CL.AddConstantN('RESOURCE_CONTEXT','LongInt').SetInt( 5);
 CL.AddConstantN('RESOURCETYPE_ANY','LongInt').SetInt( 0);
 CL.AddConstantN('RESOURCETYPE_DISK','LongInt').SetInt( 1);
 CL.AddConstantN('RESOURCETYPE_PRINT','LongInt').SetInt( 2);
 CL.AddConstantN('RESOURCETYPE_RESERVED','LongInt').SetInt( 8);
 CL.AddConstantN('RESOURCETYPE_UNKNOWN','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('RESOURCEUSAGE_CONNECTABLE','LongInt').SetInt( 1);
 CL.AddConstantN('RESOURCEUSAGE_CONTAINER','LongInt').SetInt( 2);
 CL.AddConstantN('RESOURCEUSAGE_NOLOCALDEVICE','LongInt').SetInt( 4);
 CL.AddConstantN('RESOURCEUSAGE_SIBLING','LongInt').SetInt( 8);
 CL.AddConstantN('RESOURCEUSAGE_ATTACHED','LongWord').SetUInt( $00000010);
 CL.AddConstantN('RESOURCEUSAGE_RESERVED','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('RESOURCEDISPLAYTYPE_GENERIC','LongWord').SetUInt( $00000000);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_DOMAIN','LongWord').SetUInt( $00000001);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_SERVER','LongWord').SetUInt( $00000002);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_SHARE','LongWord').SetUInt( $00000003);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_FILE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_GROUP','LongWord').SetUInt( $00000005);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_NETWORK','LongWord').SetUInt( $00000006);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_ROOT','LongWord').SetUInt( $00000007);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_SHAREADMIN','LongWord').SetUInt( $00000008);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_DIRECTORY','LongWord').SetUInt( $00000009);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_TREE','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('RESOURCEDISPLAYTYPE_NDSCONTAINER','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('WAVE_FORMAT_PCM','LongInt').SetUInt(1);
  CL.AddConstantN('DRIVERVERSION','LongInt').SetInt( 0);
 CL.AddConstantN('TECHNOLOGY','LongInt').SetInt( 2);
 CL.AddConstantN('HORZSIZE','LongInt').SetInt( 4);
 CL.AddConstantN('VERTSIZE','LongInt').SetInt( 6);
 CL.AddConstantN('HORZRES','LongInt').SetInt( 8);
 CL.AddConstantN('VERTRES','LongInt').SetInt( 10);
 CL.AddConstantN('BITSPIXEL','LongInt').SetInt( 12);
 CL.AddConstantN('PLANES','LongInt').SetInt( 14);
 CL.AddConstantN('NUMBRUSHES','LongWord').SetUInt( $10);
 CL.AddConstantN('NUMPENS','LongInt').SetInt( 18);
 CL.AddConstantN('NUMMARKERS','LongInt').SetInt( 20);
 CL.AddConstantN('NUMFONTS','LongInt').SetInt( 22);
 CL.AddConstantN('NUMCOLORS','LongInt').SetInt( 24);
 CL.AddConstantN('PDEVICESIZE','LongInt').SetInt( 26);
 CL.AddConstantN('CURVECAPS','LongInt').SetInt( 28);
 CL.AddConstantN('LINECAPS','LongInt').SetInt( 30);
 CL.AddConstantN('PHYSICALWIDTH','LongInt').SetInt( 110);
 CL.AddConstantN('PHYSICALHEIGHT','LongInt').SetInt( 111);
 CL.AddConstantN('PHYSICALOFFSETX','LongInt').SetInt( 112);
 CL.AddConstantN('PHYSICALOFFSETY','LongInt').SetInt( 113);
 CL.AddConstantN('SCALINGFACTORX','LongInt').SetInt( 114);
 CL.AddConstantN('SCALINGFACTORY','LongInt').SetInt( 115);
 CL.AddConstantN('VREFRESH','LongInt').SetInt( 116);
 CL.AddConstantN('DESKTOPVERTRES','LongInt').SetInt( 117);
 CL.AddConstantN('DESKTOPHORZRES','LongInt').SetInt( 118);
 CL.AddConstantN('BLTALIGNMENT','LongInt').SetInt( 119);


  CL.AddTypeS('_devicemodeA', 'record dmDeviceName: array[0..32-1] of Char; dmSpecVersion : WORD; dmDriverVersion : WORD; dmSize: WORD; dmDriverExtra: WORD; dmFields: DWORD; dmOrientation: Short; dmPaperSize : Short;'
   +'dmPaperLength : Short; dmPaperWidth: Short; dmScale : Short; dmCopies : short; dmDefaultSource : short; dmPrintQuality : short; dmColor: short; dmDuplex : short; dmYResolution: short; dmTTOption: short;'
   +'dmCollate : short; dmFormName : array[0..32-1] of Char; dmLogPixels : WORD; dmBitsPerPel : DWORD; dmPelsWidth : DWORD; dmPelsHeight: DWORD; dmDisplayFlags: DWORD; dmDisplayFrequency : DWORD; dmICMMethod : DWORD; dmICMIntent: DWORD;'
   +' dmMediaType : DWORD; dmDitherType : DWORD; dmICCManufacturer : DWORD; dmICCModel : DWORD; dmPanningWidth : DWORD; dmPanningHeight: DWORD; end');

 (* CL.AddTypeS('_ZONEATTRIBUTES', 'record cbSize: ULONG; szDisplayName: array[0..260-1] of Char; dmSpecVersion : WORD; dmDriverVersion : WORD; dmSize: WORD; dmDriverExtra: WORD; dmFields: DWORD; dmOrientation: Short; dmPaperSize : Short;'
   +'dmPaperLength : Short; dmPaperWidth: Short; dmScale : Short; dmCopies : short; dmDefaultSource : short; dmPrintQuality : short; dmColor: short; dmDuplex : short; dmYResolution: short; dmTTOption: short;'

  _ZONEATTRIBUTES = packed record
    cbSize: ULONG;
    szDisplayName: array [0..260 - 1] of WideChar;
    szDescription: array [0..200 - 1] of WideChar;
    szIconPath: array [0..260 - 1] of WideChar;
    dwTemplateMinLevel: DWORD;
    dwTemplateRecommended: DWORD;
    dwTemplateCurrentLevel: DWORD;
    dwFlags: DWORD;
  end;     TZoneAttributes = _ZONEATTRIBUTES;*)

//CL.AddTypeS('TKeyBuffer', 'record Modified : Boolean; Exclusive : Boolean; Fi'
  // +'eldCount : Integer; Data : record end ; end');

 {_devicemodeA = record
    dmCollate: SHORT;
    //dmFormName: array[0..1] of Char;
    dmLogPixels: Word;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDisplayFlags: DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmICCManufacturer: DWORD;
    dmICCModel: DWORD;
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
  end;}

 CL.AddTypeS('_devicemode', '_devicemodeA');
 CL.AddTypeS('TDeviceModeA', '_devicemodeA');
  //CL.AddTypeS('TDeviceModeW', '_devicemodeW');
  CL.AddTypeS('TDeviceMode', 'TDeviceModeA');
  CL.AddTypeS('TDevMode', 'TDeviceMode');

   CL.AddTypeS('tagFILTERKEYS', 'record cbSize : UINT; dwFlags : DWORD; iWaitMSe'
   +'c : DWORD; iDelayMSec : DWORD; iRepeatMSec : DWORD; iBounceMSec : DWORD; end');
  CL.AddTypeS('TFilterKeys', 'tagFILTERKEYS');
  CL.AddTypeS('FILTERKEYS', 'tagFILTERKEYS');
 CL.AddConstantN('FKF_FILTERKEYSON','LongInt').SetInt( 1);
 CL.AddConstantN('FKF_AVAILABLE','LongInt').SetInt( 2);
 CL.AddConstantN('FKF_HOTKEYACTIVE','LongInt').SetInt( 4);
 CL.AddConstantN('FKF_CONFIRMHOTKEY','LongInt').SetInt( 8);
 CL.AddConstantN('FKF_HOTKEYSOUND','LongWord').SetUInt( $10);
 CL.AddConstantN('FKF_INDICATOR','LongWord').SetUInt( $20);
 CL.AddConstantN('FKF_CLICKON','LongWord').SetUInt( $40);
 CL.AddConstantN('NETPROPERTY_PERSISTENT','LongInt').SetInt( 1);
 CL.AddConstantN('CONNECT_UPDATE_PROFILE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('CONNECT_UPDATE_RECENT','LongWord').SetUInt( $00000002);
 CL.AddConstantN('CONNECT_TEMPORARY','LongWord').SetUInt( $00000004);
 CL.AddConstantN('CONNECT_INTERACTIVE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('CONNECT_PROMPT','LongWord').SetUInt( $00000010);
 CL.AddConstantN('CONNECT_NEED_DRIVE','LongWord').SetUInt( $00000020);
 CL.AddConstantN('CONNECT_REFCOUNT','LongWord').SetUInt( $00000040);
 CL.AddConstantN('CONNECT_REDIRECT','LongWord').SetUInt( $00000080);
 CL.AddConstantN('CONNECT_LOCALDRIVE','LongWord').SetUInt( $00000100);
 CL.AddConstantN('CONNECT_CURRENT_MEDIA','LongWord').SetUInt( $00000200);
 CL.AddConstantN('CONNECT_DEFERRED','LongWord').SetUInt( $00000400);
 CL.AddConstantN('CONNECT_RESERVED','LongWord').SetUInt( DWORD ( $FF000000 ));
   CL.AddTypeS('_NETCONNECTINFOSTRUCT', 'record cbStructure : DWORD; dwFlags : D'
   +'WORD; dwSpeed : DWORD; dwDelay : DWORD; dwOptDataSize : DWORD; end');
  CL.AddTypeS('TNetConnectInfoStruct', '_NETCONNECTINFOSTRUCT');
  CL.AddTypeS('NETCONNECTINFOSTRUCT', '_NETCONNECTINFOSTRUCT');
 CL.AddConstantN('WNCON_FORNETCARD','LongInt').SetInt( 1);
 CL.AddConstantN('WNCON_NOTROUTED','LongInt').SetInt( 2);
 CL.AddConstantN('WNCON_SLOWLINK','LongInt').SetInt( 4);
 CL.AddConstantN('WNCON_DYNAMIC','LongInt').SetInt( 8);

 CL.AddTypeS('tagALTTABINFO', 'record cbSize : DWORD; cItems : Integer; cColum'
   +'ns : Integer; cRows : Integer; iColFocus : Integer; iRowFocus : Integer; cxItem : Integer; cyItem : Integer; ptStart : TPoint; end');
  CL.AddTypeS('TAltTabInfo', 'tagALTTABINFO');

    CL.AddTypeS('TAclInformationClass', '( AclInfoPad, AclRevisionInformation, AclSizeInformation )');
  CL.AddTypeS('_ACL', 'record AclRevision : Byte; Sbz1 : Byte; AclSize : Word; '
   +'AceCount : Word; Sbz2 : Word; end');
  CL.AddTypeS('TACL', '_ACL');
  CL.AddTypeS('ACL', '_ACL');
   CL.AddTypeS('ACCESS_MASK', 'DWORD'); //second def
   CL.AddTypeS('_GENERIC_MAPPING', 'record GenericRead : ACCESS_MASK; GenericWri'
   +'te : ACCESS_MASK; GenericExecute : ACCESS_MASK; GenericAll : ACCESS_MASK; end');
  CL.AddTypeS('TGenericMapping', '_GENERIC_MAPPING');
  CL.AddTypeS('GENERIC_MAPPING', '_GENERIC_MAPPING');
    CL.AddTypeS('_IMAGE_FILE_HEADER', 'record Machine : Word; NumberOfSections : '
   +'Word; TimeDateStamp : DWORD; PointerToSymbolTable : DWORD; NumberOfSymbols'
   +' : DWORD; SizeOfOptionalHeader : Word; Characteristics : Word; end');
  CL.AddTypeS('TImageFileHeader', '_IMAGE_FILE_HEADER');
  CL.AddTypeS('IMAGE_FILE_HEADER', '_IMAGE_FILE_HEADER');

   CL.AddTypeS('_FIXED', 'record fract : Word; value : SHORT; end');
  CL.AddTypeS('TFixedWin', '_FIXED');
  CL.AddTypeS('FIXEDWin', '_FIXED');
  //CL.AddTypeS('PMat2', '^TMat2 // will not work');
  CL.AddTypeS('_MAT2', 'record eM11 : TFixedwin; eM12 : TFixedwin; eM21 : TFixedwin; eM22: TFixedwin; end');
  CL.AddTypeS('TMat2', '_MAT2');
  CL.AddTypeS('MAT2', '_MAT2');

   CL.AddTypeS('tagPOINTFX', 'record x : TFixedwin; y : TFixedwin; end');
  CL.AddTypeS('TPointfx', 'tagPOINTFX');
  CL.AddTypeS('POINTFX', 'tagPOINTFX');

   // CL.AddTypeS('PTTPolygonHeader', '^TTTPolygonHeader // will not work');
  CL.AddTypeS('tagTTPOLYGONHEADER', 'record cb : DWORD; dwType : DWORD; pfxStart : TPointFX; end');
  CL.AddTypeS('TTTPolygonHeader', 'tagTTPOLYGONHEADER');
  CL.AddTypeS('TTPOLYGONHEADER', 'tagTTPOLYGONHEADER');

  CL.AddDelphiFunction('Function GetKerningPairs( DC : HDC; Count : DWORD; var KerningPairs: dword) : DWORD');

  CL.AddTypeS('tagMSGBOXPARAMSA', 'record cbSize : UINT; hwndOwner : HWND; hIns'
   +'tance : HINST; lpszText : PChar; lpszCaption : PChar; dwStyle : DW'
   +'ORD; lpszIcon : PChar; dwContextHelpId : DWORD; lpfnMsgBoxCallback : TObject; dwLanguageId : DWORD; end');
  CL.AddTypeS('tagMSGBOXPARAMS', 'tagMSGBOXPARAMSA');
  CL.AddTypeS('TMsgBoxParamsA', 'tagMSGBOXPARAMSA');
  CL.AddTypeS('TMsgBoxParams', 'TMsgBoxParamsA');
  CL.AddTypeS('MSGBOXPARAMSA', 'tagMSGBOXPARAMSA');
  CL.AddTypeS('MSGBOXPARAMS', 'MSGBOXPARAMSA');
 CL.AddDelphiFunction('Function MessageBoxIndirect( const MsgBoxParams : TMsgBoxParams) : BOOL');

  {  TSecurityImpersonationLevel = (SecurityAnonymous,
    SecurityIdentification, SecurityImpersonation, SecurityDelegation);
   }
 CL.AddDelphiFunction('Function GetAltTabInfo( hwnd : HWND; iItem : Integer; var pati : TAltTabInfo; pszItemText : PChar; cchItemText : UINT) : BOOL');
 CL.AddDelphiFunction('Function GetListBoxInfo( hwnd : HWND) : DWORD');
 CL.AddDelphiFunction('Function LockWorkStation : BOOL');
 CL.AddDelphiFunction('Function UserHandleGrantAccess( hUserHandle, hJob : THandle) : BOOL');
 CL.AddDelphiFunction('Function IsValidLocale( Locale : LCID; dwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function ConvertDefaultLocale( Locale : LCID) : LCID');
 CL.AddDelphiFunction('Function GetThreadLocale : LCID');
 CL.AddDelphiFunction('Function SetThreadLocale( Locale : LCID) : BOOL');
 //CL.AddDelphiFunction('Function DdeSetQualityOfService( hWndClient : HWnd; const pqosNew : TSecurityQualityOfService; pqosPrev : PSecurityQualityOfService) : BOOL');
 CL.AddDelphiFunction('Function ImpersonateDdeClientWindow( hWndClient : HWnd; hWndServer : HWnd) : BOOL');
 CL.AddDelphiFunction('Function PackDDElParam( msg : UINT; uiLo : UINT; uiHi : UINT) : Longint');
 //CL.AddDelphiFunction('Function UnpackDDElParam( msg : UINT; lParam : Longint; puiLo : PUINT; puiHi : PUINT) : BOOL');
 CL.AddDelphiFunction('Function FreeDDElParam( msg : UINT; lParam : Longint) : BOOL');
 CL.AddDelphiFunction('Function ReuseDDElParam( lParam : Longint; msgIn : UINT; msgOut : UINT; uiLo : UINT; uiHi : UINT) : Longint');
  CL.AddDelphiFunction('Function ImpersonateNamedPipeClient( hNamedPipe : THandle) : BOOL');
 CL.AddDelphiFunction('Function ImpersonateLoggedOnUser( hToken : THandle) : BOOL');
 CL.AddDelphiFunction('Function HwndMSWheel( var puiMsh_MsgMouseWheel, puiMsh_Msg3DSupport, puiMsh_MsgScrollLines : UINT; var pf3DSupport : BOOL; var piScrollLines : Integer) : HWND');
 //CL.AddDelphiFunction('Function ImpersonateSelf( ImpersonationLevel : TSecurityImpersonationLevel) : BOOL');
 CL.AddDelphiFunction('Function RevertToSelf : BOOL');
 CL.AddDelphiFunction('function GlobalAllocString(s: AnsiString): HGlobal;');
 CL.AddDelphiFunction('function IPToHostName(const IP: string): string;');
 CL.AddDelphiFunction('function GetMACAddress2: string;');
 CL.AddDelphiFunction('function GetMACAddress: string;');
 CL.AddDelphiFunction('function GetMacAddresses2(const Machine: string; const Addresses: TStrings): Integer;');
 CL.AddDelphiFunction('function JavaToDelphiDateTime(const dt: int64): TDateTime;');
 CL.AddDelphiFunction('function DelphiToJavaDateTime(const dt: TDateTime): int64;');
 CL.AddDelphiFunction('PROCEDURE WrapLines(VAR a, b: String; len: Integer);');
 CL.AddDelphiFunction('procedure UASwapEndian(var UC: TUArrDW);');
 CL.AddDelphiFunction('function SliceByteArray(const B: array of Byte; Start, Len: Integer): TBytes;');
 CL.AddDelphiFunction('procedure TailOfFile(aFilename: string; aTailContainer: TStrings; MaxNumLines:integer);');
 CL.AddDelphiFunction('procedure JumpToRegistryKey(Key: string);');
 CL.AddDelphiFunction('procedure SetDecimalSeparator2(Ch: Char);');
 CL.AddDelphiFunction('procedure GetWaveOutDevices(DeviceNames: TStrings);');
 CL.AddDelphiFunction('procedure GetMIDIOutDevices(Devices: TStrings);');
 CL.AddDelphiFunction('procedure GetMIDIOutDevices(Devices: TStrings);');
 CL.AddDelphiFunction('function GetPNGSize2(const FileName: string): TSize;');

  
      (*const
  {$EXTERNALSYM WAVE_FORMAT_PCM}
  WAVE_FORMAT_PCM     = 1;
   *)

  //QS_MOUSE = (QS_MOUSEMOVE or QS_MOUSEBUTTON);
  //{$EXTERNALSYM QS_INPUT}
  //QS_INPUT = (QS_MOUSE or QS_KEY);
  CL.AddConstantN('QS_MOUSE','LongWord').SetUInt(QS_MOUSEMOVE or QS_MOUSEBUTTON);
  CL.AddConstantN('QS_INPUT','LongWord').SetUInt(QS_MOUSE or QS_KEY);
  CL.AddConstantN('QS_ALLINPUT','LongWord').SetUInt(QS_INPUT or QS_POSTMESSAGE or QS_TIMER or QS_PAINT or QS_HOTKEY or QS_SENDMESSAGE);

  // QS_ALLINPUT = (QS_INPUT or QS_POSTMESSAGE or QS_TIMER or QS_PAINT
  //  or QS_HOTKEY or QS_SENDMESSAGE);

  CL.AddDelphiFunction('Function EnumDisplaySettings( lpszDeviceName : PChar; iModeNum : DWORD; var lpDevMode : TDeviceMode) : BOOL');
  CL.AddTypeS('TDLLVersionInfo', 'record cbsize, dwMajorVersion, dwMinorVersion, dwBuildNumber, dwPlatformID: DWord; end');

  //CL.AddTypeS('PProcessMemoryCounters', '^_PROCESS_MEMORY_COUNTERS // will not work');
 //CL.AddDelphiFunction('Function EnumProcesses( lpidProcess : LPDWORD; cb : DWORD; var cbNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function EnumProcessModules( hProcess : THandle; lphModule : LPDWORD; cb : DWORD; var lpcbNeeded : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetModuleBaseName( hProcess : THandle; hModule : HMODULE; lpBaseName : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleBaseNameA( hProcess : THandle; hModule : HMODULE; lpBaseName : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleBaseNameW( hProcess : THandle; hModule : HMODULE; lpBaseName : PWideChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleFileNameEx( hProcess : THandle; hModule : HMODULE; lpFilename : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleFileNameExA( hProcess : THandle; hModule : HMODULE; lpFilename : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleFileNameExW( hProcess : THandle; hModule : HMODULE; lpFilename : PWideChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetModuleInformation( hProcess : THandle; hModule : HMODULE; lpmodinfo : LPMODULEINFO; cb : DWORD) : BOOL');
 CL.AddDelphiFunction('Function EmptyWorkingSet( hProcess : THandle) : BOOL');
 CL.AddDelphiFunction('Function QueryWorkingSet( hProcess : THandle; pv : ___Pointer; cb : DWORD) : BOOL');
 CL.AddDelphiFunction('Function InitializeProcessForWsWatch( hProcess : THandle) : BOOL');
 CL.AddDelphiFunction('Function GetMappedFileName( hProcess : THandle; lpv : ___Pointer; lpFilename : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetMappedFileNameA( hProcess : THandle; lpv : Pointer; lpFilename : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetMappedFileNameW( hProcess : THandle; lpv : Pointer; lpFilename : PWideChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetDeviceDriverBaseName( ImageBase : ___Pointer; lpBaseName : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverBaseNameA( ImageBase : Pointer; lpBaseName : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverBaseNameW( ImageBase : Pointer; lpBaseName : PWideChar; nSize : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetDeviceDriverFileName( ImageBase : ___Pointer; lpFileName : PChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverFileNameA( ImageBase : Pointer; lpFileName : PAnsiChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetDeviceDriverFileNameW( ImageBase : Pointer; lpFileName : PWideChar; nSize : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function EnumDeviceDrivers( lpImageBase : PPointer; cb : DWORD; var lpcbNeeded : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetProcessMemoryInfo( Process : THandle; ppsmemCounters : PPROCESS_MEMORY_COUNTERS; cb : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetProcessMemoryInfo(Process : THandle; ppsmemCounters: TProcessMemoryCounters; cb: DWORD): BOOL');

 CL.AddDelphiFunction('function getProcessAllMemory(ProcessID : DWORD): TProcessMemoryCounters;');
 CL.AddDelphiFunction('function getProcessMemoryInfo2(ProcessID : DWORD): TProcessMemoryCounters;');
 CL.AddDelphiFunction('function getProcMemInfo(ProcessID : DWORD): TProcessMemoryCounters;');

 //CL.AddDelphiFunction('Function GetCurrentThread : THandle');
 //CL.AddDelphiFunction('Function GetCurrentThreadId : DWORD');
 CL.AddDelphiFunction('Function SetThreadAffinityMask( hThread : THandle; dwThreadAffinityMask : DWORD) : DWORD');
 CL.AddDelphiFunction('Function SetThreadIdealProcessor( hThread : THandle; dwIdealProcessor : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetProcessPriorityBoost( hThread : THandle; DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function GetProcessPriorityBoost( hThread : THandle; var DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function SetThreadPriority( hThread : THandle; nPriority : Integer) : BOOL');
 CL.AddDelphiFunction('Function GetThreadPriority( hThread : THandle) : Integer');
 CL.AddDelphiFunction('Function SetThreadPriorityBoost( hThread : THandle; DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function GetThreadPriorityBoost( hThread : THandle; var DisablePriorityBoost : Bool) : BOOL');
 CL.AddDelphiFunction('Function GetThreadTimes( hThread : THandle; var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime : TFileTime) : BOOL');
 CL.AddDelphiFunction('Procedure ExitThread( dwExitCode : DWORD)');
 CL.AddDelphiFunction('Function TerminateThread( hThread : THandle; dwExitCode : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetExitCodeThread( hThread : THandle; var lpExitCode : DWORD) : BOOL');

 CL.AddDelphiFunction('Function GetTimeZoneInformation( var lpTimeZoneInformation : TTimeZoneInformation) : DWORD');
 CL.AddDelphiFunction('Function SetTimeZoneInformation( const lpTimeZoneInformation : TTimeZoneInformation) : BOOL');
 CL.AddDelphiFunction('Function IsProcessorFeaturePresent( ProcessorFeature : DWORD) : BOOL');
 CL.AddDelphiFunction('function RunCaptured(const _dirName, _exeName, _cmdLine: string; amemo: TStringlist): Boolean;');
 CL.AddDelphiFunction('function ConsoleCapture(const _dirName, _exeName, _cmdLine: string; amemo: TStringlist): Boolean;');
 CL.AddDelphiFunction('function ConsoleCaptureDOS(const _dirName, _exeName, _cmdLine: string; amemo: TStrings): Boolean;');
 CL.AddDelphiFunction('procedure PerformanceDelayMS(ams: integer);');
 CL.AddDelphiFunction('function ExecuteProcess(FileName:string;Visibility:Integer;BitMask:Integer;Synch:Boolean):Longword;');
 CL.AddDelphiFunction('function ExecuteMultiProcessor(FileName:string;Visibility:Integer;BitMask:Integer;Synch:Boolean):Longword;');

  //http://www.swissdelphicenter.ch/en/showcode.php?id=2179
   CL.AddClassN(CL.FindClass('TOBJECT'),'TService');
  CL.AddDelphiFunction('procedure StartServiceAfterInstall(aserv: TService);');
  CL.AddDelphiFunction('function GetDllVersion2(DllName: string; var DLLVersionInfo: TDLLVersionInfo): Boolean;');
  CL.AddDelphiFunction('procedure SendCopyMessage(amess, astation: string);');
  CL.AddDelphiFunction('function BrowseComputer2(DialogTitle: string; var CompName: string; bNewStyle: Boolean): Boolean;');
  CL.AddDelphiFunction('Function FindWindowEx( Parent, Child : HWND; ClassName, WindowName : PChar) : HWND');
  CL.AddDelphiFunction('Function SetWindowExtEx( DC : HDC; XExt, YExt : Integer; Size : integer) : BOOL');
  CL.AddDelphiFunction('Function SetWindowOrgEx( DC : HDC; X, Y : Integer; Point : TPoint) : BOOL');
  CL.AddDelphiFunction('Function GetTextFace( DC : HDC; Count : Integer; Buffer : PChar) : Integer');
 {CL.AddDelphiFunction('Function GetDCOrgEx( DC : HDC; var Origin : TPoint) : BOOL');
 CL.AddDelphiFunction('Function UnrealizeObject( hGDIObj : HGDIOBJ) : BOOL');
 CL.AddDelphiFunction('Function GdiFlush : BOOL');
 CL.AddDelphiFunction('Function GdiSetBatchLimit( Limit : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GdiGetBatchLimit : DWORD');}
  CL.AddDelphiFunction('Function SetICMMode( DC : HDC; Mode : Integer) : Integer');
 CL.AddDelphiFunction('Function CheckColorsInGamut( DC : HDC; var RGBQuads, Results, Count : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetColorSpace( DC : HDC) : THandle');
CL.AddDelphiFunction('Function SetColorSpace( DC : HDC; ColorSpace : HCOLORSPACE) : BOOL');
 CL.AddDelphiFunction('Function DeleteColorSpace( ColorSpace : HCOLORSPACE) : BOOL');
 CL.AddDelphiFunction('Function GetICMProfile( DC : HDC; var Size : DWORD; Name : PChar) : BOOL');
 CL.AddDelphiFunction('Function SetICMProfile( DC : HDC; Name : PChar) : BOOL');
 //CL.AddDelphiFunction('Function ColorMatchToTarget( DC : HDC; Target : HDC; Action : DWORD) : BOOL');
 CL.AddDelphiFunction('procedure GetGeoInfo(const IpAddress : string;var GeoInfo :TGeoInfo; const UrlGeoLookupInfo: string)');
  CL.AddDelphiFunction('Function VkKeyScan( ch : Char) : SHORT');
 CL.AddDelphiFunction('Function VkKeyScanEx( ch : Char; dwhkl : HKL) : SHORT');
CL.AddDelphiFunction('Function GetKeyboardType( nTypeFlag : Integer) : Integer');
 CL.AddDelphiFunction('Function ToAscii( uVirtKey, uScanCode : UINT; const KeyState : TKeyboardState; lpChar : PChar; uFlags : UINT) : Integer');
 CL.AddDelphiFunction('Function ToAsciiEx( uVirtKey : UINT; uScanCode : UINT; const KeyState : TKeyboardState; lpChar : PChar; uFlags : UINT; dwhkl : HKL) : Integer');
 CL.AddDelphiFunction('Function ToUnicode( wVirtKey, wScanCode : UINT; const KeyState : TKeyboardState; var pwszBuff, cchBuff : Integer; wFlags : UINT) : Integer');
  CL.AddDelphiFunction('Function GetKeyNameText( lParam : Longint; lpString : PChar; nSize : Integer) : Integer');
  CL.AddDelphiFunction('function getFormRes(classname: string): string;');
  CL.AddDelphiFunction('function RoundTime(ADate: string; Rounding: Integer; bRound: Boolean): string;');
  CL.AddDelphiFunction('procedure ScanNetworkResources(ResourceType, DisplayType: DWord; List: TStrings);');

 CL.AddDelphiFunction('Function IsDialogMessage( hDlg : HWND; var lpMsg : TMsg) : BOOL');
 CL.AddDelphiFunction('Function MapDialogRect( hDlg : HWND; var lpRect : TRect) : BOOL');
 CL.AddDelphiFunction('Function DlgDirList( hDlg : HWND; lpPathSpec : PChar; nIDListBox, nIDStaticPath : Integer; uFileType : UINT) : Integer');
 CL.AddDelphiFunction('Function WinHelp( hWndMain : HWND; lpszHelp : PChar; uCommand : UINT; dwData : DWORD) : BOOL');
 //CL.AddDelphiFunction('function RoundTime(ADate: string; Rounding: Integer; bRound: Boolean): string;');
 CL.AddDelphiFunction('function StringtoHex(Data: string): string;');
 CL.AddDelphiFunction('function GetAnsistringRefcount(const S: string): Cardinal;');
 CL.AddDelphiFunction('function WideStringToString(const ws: WideString; codePage: Word): AnsiString;');
 CL.AddDelphiFunction('function StringToWideString(const s: AnsiString; codePage: Word): WideString;');
 CL.AddDelphiFunction('function SecondToTime(const Seconds: Cardinal): Double;');

 CL.AddDelphiFunction('function CopyDir2(const fromDir, toDir: string): Boolean;');
 CL.AddDelphiFunction('function MoveDir(const fromDir, toDir: string): Boolean;');
 CL.AddDelphiFunction('function DelDir(dir: string): Boolean;');
 CL.AddDelphiFunction('procedure DeleteScansRect(Src, Dest: TBitmap; rs, rd: TRect);');
 CL.AddDelphiFunction('procedure FadeIn(ImageFileName: TFileName; aForm1: TForm);');
 CL.AddDelphiFunction('procedure FadeOut(ImageFileName: TFileName);');
 CL.AddDelphiFunction('procedure FadeOut32(const Bmp: TImage; Pause: Integer);');
 CL.AddDelphiFunction('function CheckBDEInstalled: Boolean;');
 CL.AddDelphiFunction('function IsBDE: Boolean;');
 CL.AddDelphiFunction('function ScanTime(const S: string; var Pos: Integer; var Time: TDateTime): Boolean;');
 CL.AddDelphiFunction('function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;');
 CL.AddDelphiFunction('function ScanNumber(const S: string; var Pos: Integer; var Number: Word): Boolean;');
 CL.AddDelphiFunction('function ScanString(const S: string; var Pos: Integer; const Symbol: string): Boolean;');
 CL.AddDelphiFunction('procedure GetZoneIcon(IconPath: string; var Icon: TIcon);');
 CL.AddDelphiFunction('procedure CGITester;');
 CL.AddDelphiFunction('function search_adapter_key_networkcard: string;');
 CL.AddDelphiFunction('function getnetworkcard: string;');
 CL.AddDelphiFunction('function Get_MACAddress: string;');
 CL.AddDelphiFunction('function ConnectPrinterDevice(_lptPort:string;_netPath:string;_showError:Boolean;_reconnect:Boolean):DWORD;');
 CL.AddDelphiFunction('function DisconnectNetDrive(_locDrive:string;_showError:Boolean;_force:Boolean;_save:Boolean):DWORD;');
 CL.AddDelphiFunction('function ConnectDrive(_drvLetter: string; _netPath: string; _showError:Boolean; _reconnect:Boolean):DWORD;');
 CL.AddDelphiFunction('function GetConnectionKind(var strKind: string): Boolean;');
 CL.AddDelphiFunction('function floattoint(value: double): Integer;');
 CL.AddDelphiFunction('function f2i(value: double): Integer;');
 CL.AddDelphiFunction('function GetTimeBias: integer;');
 CL.AddDelphiFunction('function DelphiDateTimeToISO8601Date(dt: TDateTime): String;');
 CL.AddDelphiFunction('procedure ResizeBitmap(Bitmap: TBitmap; Width, Height: Integer; Background: TColor);');
 CL.AddDelphiFunction('function ProcessCount(const ExeName: String): Integer;');
 CL.AddDelphiFunction('function CloneByteArray(const B: array of Byte): TBytes;');
 CL.AddDelphiFunction('procedure AppendByteArray(var B1: TBytes; const B2: array of Byte);');
 CL.AddDelphiFunction('function PopByteArray(var A: TBytes): Byte;');
  CL.AddDelphiFunction('procedure PushByteArray(const B: Byte; var A: TBytes);');
  CL.AddDelphiFunction('function ShiftByteArray(var A: TBytes): Byte;');
  CL.AddDelphiFunction('procedure PrintUsingShell( psFileName :string);');
 CL.AddDelphiFunction('function LocalExecute32(FileName:String; Wait:boolean; Visibility:integer;lWaitFor:Cardinal):integer;');
  CL.AddDelphiFunction('function GetEXEVersionData(const FileName: string): TEXEVersionData;');
  CL.AddDelphiFunction('function isAvxSupported: Boolean;');
  CL.AddDelphiFunction('function txtsearch(pat: string; text: string): integer;');
  CL.AddDelphiFunction('procedure GetRegisteredAntiviruses(ProgIDs: TStrings);');

      //CL.AddDelphiFunction('function GetZoneAttributes(const URL: string): TZoneAttributes;');
         //makeintresource
 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_PsAPI_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@EnumProcesses, 'EnumProcesses', cdRegister);
 //S.RegisterDelphiFunction(@EnumProcessModules, 'EnumProcessModules', cdRegister);
 S.RegisterDelphiFunction(@GetModuleBaseName, 'GetModuleBaseName', cdRegister);
 S.RegisterDelphiFunction(@GetModuleInformation, 'GetModuleInformation', cdRegister);
 S.RegisterDelphiFunction(@EmptyWorkingSet, 'EmptyWorkingSet', cdRegister);
 S.RegisterDelphiFunction(@QueryWorkingSet, 'QueryWorkingSet', cdRegister);
 S.RegisterDelphiFunction(@InitializeProcessForWsWatch, 'InitializeProcessForWsWatch', cdRegister);
 S.RegisterDelphiFunction(@GetMappedFileName, 'GetMappedFileName', cdRegister);
 //S.RegisterDelphiFunction(@GetMappedFileNameA, 'GetMappedFileNameA', cdRegister);
 //S.RegisterDelphiFunction(@GetMappedFileNameW, 'GetMappedFileNameW', cdRegister);
 S.RegisterDelphiFunction(@GetDeviceDriverBaseName, 'GetDeviceDriverBaseName', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverBaseNameA, 'GetDeviceDriverBaseNameA', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverBaseNameW, 'GetDeviceDriverBaseNameW', cdRegister);
 S.RegisterDelphiFunction(@GetDeviceDriverFileName, 'GetDeviceDriverFileName', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverFileNameA, 'GetDeviceDriverFileNameA', cdRegister);
 //S.RegisterDelphiFunction(@GetDeviceDriverFileNameW, 'GetDeviceDriverFileNameW', cdRegister);
 S.RegisterDelphiFunction(@EnumDeviceDrivers, 'EnumDeviceDrivers', cdRegister);
 S.RegisterDelphiFunction(@GetProcessMemoryInfoInt, 'GetProcessMemoryInfo', cdRegister);
 S.RegisterDelphiFunction(@GetProcessAllMemory, 'GetProcessMemoryInfo2', cdRegister);
 S.RegisterDelphiFunction(@getProcessAllMemory, 'getProcessAllMemory', cdRegister);
 S.RegisterDelphiFunction(@getProcessAllMemory, 'getProcMemInfo', cdRegister);
 S.RegisterDelphiFunction(@ConsoleCapture, 'ConsoleCapture', cdRegister);
 S.RegisterDelphiFunction(@ConsoleCaptureDOS, 'ConsoleCaptureDOS', cdRegister);
 S.RegisterDelphiFunction(@ConsoleCapture, 'RunCaptured', cdRegister);

//  S.RegisterDelphiFunction(@GetCurrentThread, 'GetCurrentThread', CdStdCall);
 //S.RegisterDelphiFunction(@GetCurrentThreadId, 'GetCurrentThreadId', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadAffinityMask, 'SetThreadAffinityMask', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadIdealProcessor, 'SetThreadIdealProcessor', CdStdCall);
 S.RegisterDelphiFunction(@SetProcessPriorityBoost, 'SetProcessPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessPriorityBoost, 'GetProcessPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadPriority, 'SetThreadPriority', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadPriority, 'GetThreadPriority', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadPriorityBoost, 'SetThreadPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadPriorityBoost, 'GetThreadPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadTimes, 'GetThreadTimes', CdStdCall);
 S.RegisterDelphiFunction(@ExitThread, 'ExitThread', CdStdCall);
 S.RegisterDelphiFunction(@TerminateThread, 'TerminateThread', CdStdCall);
 S.RegisterDelphiFunction(@GetExitCodeThread, 'GetExitCodeThread', CdStdCall);
  S.RegisterDelphiFunction(@FindWindowEx, 'FindWindowEx', CdStdCall);

 S.RegisterDelphiFunction(@IsProcessorFeaturePresent, 'IsProcessorFeaturePresent', CdStdCall);
 S.RegisterDelphiFunction(@GetTimeZoneInformation, 'GetTimeZoneInformation', CdStdCall);
 S.RegisterDelphiFunction(@SetTimeZoneInformation, 'SetTimeZoneInformation', CdStdCall);
 S.RegisterDelphiFunction(@CreateProcess, 'CreateProcess', CdStdCall);
 S.RegisterDelphiFunction(@PerformanceDelayMS, 'PerformanceDelayMS', CdRegister);
 S.RegisterDelphiFunction(@ExecuteProcess, 'ExecuteProcess', CdRegister);
 S.RegisterDelphiFunction(@ExecuteProcess, 'ExecuteMultiProcessor', CdRegister);  //Alias

 S.RegisterDelphiFunction(@StartServiceAfterInstall, 'StartServiceAfterInstall', CdRegister);
 S.RegisterDelphiFunction(@GetDllVersion2, 'GetDllVersion2', CdRegister);
 S.RegisterDelphiFunction(@SendCopyMessage, 'SendCopyMessage', CdRegister);
 S.RegisterDelphiFunction(@BrowseComputer2, 'BrowseComputer2', CdRegister);
 S.RegisterDelphiFunction(@SetWindowExtEx, 'SetWindowExtEx', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowOrgEx, 'SetWindowOrgEx', CdStdCall);
 S.RegisterDelphiFunction(@GetTextFace, 'GetTextFace', CdStdCall);
 S.RegisterDelphiFunction(@SetICMMode, 'SetICMMode', CdStdCall);
 S.RegisterDelphiFunction(@GetColorSpace, 'GetColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@GetLogColorSpace, 'GetLogColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@SetColorSpace, 'SetColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@DeleteColorSpace, 'DeleteColorSpace', CdStdCall);
 S.RegisterDelphiFunction(@GetICMProfile, 'GetICMProfile', CdStdCall);
 S.RegisterDelphiFunction(@SetICMProfile, 'SetICMProfile', CdStdCall);
 //S.RegisterDelphiFunction(@ColorMatchToTarget, 'ColorMatchToTarget', CdStdCall);
 S.RegisterDelphiFunction(@GetGeoInfo, 'GetGeoInfo', CdRegister);
  S.RegisterDelphiFunction(@GetKeyNameText, 'GetKeyNameText', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyboardType, 'GetKeyboardType', CdStdCall);
 S.RegisterDelphiFunction(@ToAscii, 'ToAscii', CdStdCall);
 S.RegisterDelphiFunction(@ToAsciiEx, 'ToAsciiEx', CdStdCall);
 S.RegisterDelphiFunction(@ToUnicode, 'ToUnicode', CdStdCall);
 S.RegisterDelphiFunction(@OemKeyScan, 'OemKeyScan', CdStdCall);
 S.RegisterDelphiFunction(@VkKeyScan, 'VkKeyScan', CdStdCall);
 S.RegisterDelphiFunction(@VkKeyScanEx, 'VkKeyScanEx', CdStdCall);
 S.RegisterDelphiFunction(@getFormRes, 'getFormRes', CdRegister);
 S.RegisterDelphiFunction(@RoundTime, 'RoundTime', CdRegister);
 S.RegisterDelphiFunction(@ScanNetworkResources, 'ScanNetworkResources', CdRegister);

  S.RegisterDelphiFunction(@IsDialogMessage, 'IsDialogMessage', CdStdCall);
 S.RegisterDelphiFunction(@MapDialogRect, 'MapDialogRect', CdStdCall);
 S.RegisterDelphiFunction(@DlgDirList, 'DlgDirList', CdStdCall);
 S.RegisterDelphiFunction(@WinHelp, 'WinHelp', CdStdCall);
 S.RegisterDelphiFunction(@StringtoHex, 'StringtoHex', CdRegister);
 S.RegisterDelphiFunction(@GetAnsistringRefcount, 'GetAnsistringRefcount', CdRegister);
 S.RegisterDelphiFunction(@WideStringToString, 'WideStringToString', CdRegister);
 S.RegisterDelphiFunction(@StringTowIDEString, 'StringToWideString', CdRegister);
 S.RegisterDelphiFunction(@SecondtoTime, 'SecondtoTime', CdRegister);
 S.RegisterDelphiFunction(@CopyDir, 'CopyDir2', CdRegister);
 S.RegisterDelphiFunction(@MoveDir, 'MoveDir', CdRegister);
 S.RegisterDelphiFunction(@DelDir, 'DelDir', CdRegister);
 S.RegisterDelphiFunction(@DeleteScansRect, 'DeleteScansRect', CdRegister);
 S.RegisterDelphiFunction(@FadeIn, 'FadeIn', CdRegister);
 S.RegisterDelphiFunction(@FadeOut, 'FadeOut', CdRegister);
 S.RegisterDelphiFunction(@FadeOut32, 'FadeOut32', CdRegister);
 S.RegisterDelphiFunction(@CheckBDEInstalled, 'CheckBDEInstalled', CdRegister);
 S.RegisterDelphiFunction(@CheckBDEInstalled, 'IsBDE', CdRegister);
 S.RegisterDelphiFunction(@EnumDisplaySettings, 'EnumDisplaySettings', CdStdCall);
  S.RegisterDelphiFunction(@GetAltTabInfo, 'GetAltTabInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetListBoxInfo, 'GetListBoxInfo', CdStdCall);
 S.RegisterDelphiFunction(@LockWorkStation, 'LockWorkStation', CdStdCall);
 S.RegisterDelphiFunction(@UserHandleGrantAccess, 'UserHandleGrantAccess', CdStdCall);
 S.RegisterDelphiFunction(@IsValidLocale, 'IsValidLocale', CdStdCall);
 S.RegisterDelphiFunction(@ConvertDefaultLocale, 'ConvertDefaultLocale', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadLocale, 'GetThreadLocale', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadLocale, 'SetThreadLocale', CdStdCall);
  S.RegisterDelphiFunction(@ImpersonateDdeClientWindow, 'ImpersonateDdeClientWindow', CdStdCall);
 S.RegisterDelphiFunction(@PackDDElParam, 'PackDDElParam', CdStdCall);
 //S.RegisterDelphiFunction(@UnpackDDElParam, 'UnpackDDElParam', CdStdCall);
 S.RegisterDelphiFunction(@FreeDDElParam, 'FreeDDElParam', CdStdCall);
 S.RegisterDelphiFunction(@ReuseDDElParam, 'ReuseDDElParam', CdStdCall);
 S.RegisterDelphiFunction(@HwndMSWheel, 'HwndMSWheel', cdRegister);
 S.RegisterDelphiFunction(@ImpersonateNamedPipeClient, 'ImpersonateNamedPipeClient', CdStdCall);
 //S.RegisterDelphiFunction(@ImpersonateSelf, 'ImpersonateSelf', CdStdCall);
 S.RegisterDelphiFunction(@ImpersonateLoggedOnUser, 'ImpersonateLoggedOnUser', CdStdCall);
 S.RegisterDelphiFunction(@RevertToSelf, 'RevertToSelf', CdStdCall);
 S.RegisterDelphiFunction(@GlobalAllocString, 'GlobalAllocString', CdRegister);
 S.RegisterDelphiFunction(@ScanTime, 'ScanTime', CdRegister);
 S.RegisterDelphiFunction(@ScanChar, 'ScanChar', CdRegister);
 S.RegisterDelphiFunction(@ScanNumber, 'ScanNumber', CdRegister);
 S.RegisterDelphiFunction(@ScansTRING, 'ScanString', CdRegister);
 S.RegisterDelphiFunction(@IPToHostName, 'IPToHostName', CdRegister);
 S.RegisterDelphiFunction(@getzoneicon, 'getzoneicon', CdRegister);
 S.RegisterDelphiFunction(@CGITester, 'CGItester', CdRegister);
 S.RegisterDelphiFunction(@search_adapter_key_networkcard, 'search_adapter_key_networkcard', CdRegister);
 S.RegisterDelphiFunction(@search_adapter_key_networkcard, 'getnetworkcard', CdRegister);
 S.RegisterDelphiFunction(@Get_MACAddress, 'Get_MACAddress', CdRegister);
 S.RegisterDelphiFunction(@GetMACAddress2, 'GetMACAddress', CdRegister);
 S.RegisterDelphiFunction(@GetMACAddress2, 'GetMACAddress2', CdRegister);
 S.RegisterDelphiFunction(@GetMACAddresses2, 'GetMACAddresses2', CdRegister);
 S.RegisterDelphiFunction(@ConnectDrive, 'ConnectDrive', CdRegister);
 S.RegisterDelphiFunction(@ConnectPrinterDevice, 'ConnectPrinterDevice', CdRegister);
 S.RegisterDelphiFunction(@DisconnectNetDrive, 'DisconnectNetDrive', CdRegister);
 S.RegisterDelphiFunction(@GetConnectionKind, 'GetConnectionKind', CdRegister);
 S.RegisterDelphiFunction(@GetKerningPairs, 'GetKerningPairs', CdStdCall);
 S.RegisterDelphiFunction(@MessageBoxIndirect, 'MessageBoxIndirect', CdStdCall);
 S.RegisterDelphiFunction(@floattoint, 'floattoint', CdRegister);
 S.RegisterDelphiFunction(@floattoint, 'f2i', CdRegister);
 S.RegisterDelphiFunction(@JavaToDelphiDateTime, 'JavaToDelphiDateTime', CdRegister);
 S.RegisterDelphiFunction(@DelphiToJavaDateTime, 'DelphiToJavaDateTime', CdRegister);
  S.RegisterDelphiFunction(@GetTimeBias, 'GetTimeBias', CdRegister);
 S.RegisterDelphiFunction(@DelphiDateTimeToISO8601Date, 'DelphiDateTimeToISO8601Date', CdRegister);
 S.RegisterDelphiFunction(@WrapLines, 'WrapLines', CdRegister);
 S.RegisterDelphiFunction(@UASwapEndian, 'UASwapEndian', CdRegister);
 S.RegisterDelphiFunction(@SliceByteArray, 'SliceByteArray', CdRegister);
 S.RegisterDelphiFunction(@TailOfFile, 'TailOfFile', CdRegister);
 S.RegisterDelphiFunction(@JumpToRegistryKey, 'JumpToRegistryKey', CdRegister);
 S.RegisterDelphiFunction(@SetDecimalSeparator2, 'SetDecimalSeparator2', CdRegister);
 S.RegisterDelphiFunction(@GetWaveOutDevices, 'GetWaveOutDevices', CdRegister);
 S.RegisterDelphiFunction(@GetMIDIOutDevices, 'GetMIDIOutDevices', CdRegister);
 S.RegisterDelphiFunction(@ResizeBitmap, 'ResizeBitmap', CdRegister);
 S.RegisterDelphiFunction(@ProcessCount, 'ProcessCount', CdRegister);

 S.RegisterDelphiFunction(@CloneByteArray, 'CloneByteArray', CdRegister);
 S.RegisterDelphiFunction(@PopByteArray, 'PopByteArray', CdRegister);
 S.RegisterDelphiFunction(@PushByteArray, 'PushByteArray', CdRegister);
 S.RegisterDelphiFunction(@AppendByteArray, 'AppendByteArray', CdRegister);
 S.RegisterDelphiFunction(@ShiftByteArray, 'ShiftByteArray', CdRegister);
 S.RegisterDelphiFunction(@PrintUsingShell, 'PrintUsingShell', CdRegister);
 S.RegisterDelphiFunction(@LocalExecute32, 'LocalExecute32', CdRegister);
 S.RegisterDelphiFunction(@GetPNGSize2, 'GetPNGSize2', CdRegister);
 S.RegisterDelphiFunction(@GetEXEVersionData, 'GetEXEVersionData', CdRegister);
 S.RegisterDelphiFunction(@isAvxSupported, 'isAvxSupported', CdRegister);
 S.RegisterDelphiFunction(@txtsearch, 'txtsearch', CdRegister);
 S.RegisterDelphiFunction(@GetRegisteredAntiviruses, 'GetRegisteredAntiviruses', CdRegister);

 // CL.AddDelphiFunction('function isAvxSupported: Boolean;')
      //FUNCTION TrimStrOf(VAR S; Len: Integer): String;
// CL.AddDelphiFunction('function GetTimeBias: integer;');
// CL.AddDelphiFunction('function DelphiDateTimeToISO8601Date(dt: TDateTime): String;');
  //CL.AddDelphiFunction('function JavaToDelphiDateTime(const dt: int64): TDateTime;');
 //CL.AddDelphiFunction('function DelphiToJavaDateTime(const dt: TDateTime): int64;');

end;

{ TPSImport_PsAPI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PsAPI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PsAPI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PsAPI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_PsAPI(ri);
  RIRegister_PsAPI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)

end.
