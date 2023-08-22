unit uPSI_NMEA;
{
  for GPS and David I and Detlef
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_NMEA = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_NMEA(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_NMEA_Routines(S: TPSExec);


(*procedure ItemHTDrawEx(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string; var Width: Integer;
  CalcType: TJvHTMLCalcType;  MouseX, MouseY: Integer; var MouseOnLink: Boolean;
  var LinkName: string; Scale: Integer = 100);
  { example for Text parameter : 'Item 1 <b>bold</b> <i>italic ITALIC <br><FONT COLOR="clRed">red <FONT COLOR="clgreen">green <FONT COLOR="clblue">blue </i>' }
function ItemHTDraw(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string; Scale: Integer = 100): string;
function ItemHTDrawHL(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string; MouseX, MouseY: Integer; Scale: Integer = 100): string;
function ItemHTWidth(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string; Scale: Integer = 100): Integer;
function ItemHTPlain(const Text: string): string;
function ItemHTHeight(Canvas: TCanvas; const Text: string; Scale: Integer = 100): Integer;
function PrepareText(const A: string): string; deprecated;*)


procedure Register;

implementation


uses
   NMEA, Windows, Strutils, Tlhelp32, Forms, winsock, mmsystem, dialogs, db, ShellAPI, JvVCLUtils, graphics;

 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_NMEA]);
end;

const
  MaxTicks    = 39045157;   {Max ticks, 24.8 days}

  {Clock frequency of 1193180/65536 is reduced to 1675/92. This}
  {allows longint conversions of Ticks values upto TicksPerDay}
  TicksFreq = 1675;
  SecsFreq  = 92;
  MSecsFreq = 92000;

function Ticks2Secs(Ticks : LongInt) : LongInt;
    {-Returns seconds value for Ticks Ticks}
  begin
    Ticks2Secs := ((Ticks + 9) * SecsFreq) div TicksFreq;
  end;

  function Secs2Ticks(Secs : LongInt) : LongInt;
    {-Returns Ticks value for Secs seconds}
  begin
    Secs2Ticks := (Secs * TicksFreq) div SecsFreq;
  end;

  function MSecs2Ticks(MSecs : LongInt) : LongInt;
    {-Returns Ticks value for msecs}
  begin
    Result := (MSecs * TicksFreq) div MSecsFreq;
  end;

  function ApWinExecAndWait32(FileName : PChar; CommandLine : PChar;
                            Visibility : Integer) : Integer;
 { returns -1 if the Exec failed, otherwise returns the process' exit }
 { code when the process terminates }
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:ShortString;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  Temp : DWORD;
begin
  StrCopy(zAppName, FileName);
  if assigned(CommandLine) then                                        
    StrCat(zAppName, CommandLine);                                     
  GetDir(0, WorkDir);                                                  
  StrPCopy(zCurDir, WorkDir);                                          
  FillChar(StartupInfo, Sizeof(StartupInfo),#0);                       
  StartupInfo.cb := Sizeof(StartupInfo);                               
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;                         
  StartupInfo.wShowWindow := Visibility;                               
  if not CreateProcess(nil,                                            
      zAppName,              { pointer to command line string }        
      nil,                   { pointer to process security attributes }
      nil,                   { pointer to thread security attributes } 
      false,                 { handle inheritance flag }               
      CREATE_NEW_CONSOLE or  { creation flags }                        
      NORMAL_PRIORITY_CLASS,
      nil,                   { pointer to new environment block }
      nil,                   { pointer to current directory name }
      StartupInfo,           { pointer to STARTUPINFO }                
      ProcessInfo) then      { pointer to PROCESS_INF }                
        Result := -1                                                   
  else begin                                                           
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);                
    GetExitCodeProcess(ProcessInfo.hProcess,Temp);
    CloseHandle(ProcessInfo.hProcess);                                   {!!.02}
    CloseHandle(ProcessInfo.hThread);                                    {!!.02}
    Result := Integer(Temp);                                           
  end;                                                                 
end;


const CRLF = #13#10;
function getStringTickCount: string;
begin
  result:= 'cr:= GetTickCount();'+CRLF+ 
           'ia:= round(LinesCount(fn));'+CRLF+
           'f:= GetTickCount();'+CRLF+
           'a:= f -cr;'+CRLF+
           'PrintF(''Lines: %.n Ticks: %.n'',[ia *1.0, a *1.0]);'
end;


procedure DeleteLine(StrList: TStringList; SearchPattern: String);
var
  Index : Integer;
 begin
 for Index := 0 to StrList.Count-1 do
  begin
   if ContainsText(StrList[Index], SearchPattern) then
    begin
     StrList.Delete(Index);
     Break;
    end;
  end;
end;


function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

const WM_CLOSE =$0010;

procedure KillProcess(hWindowHandle: HWND);
var
  hprocessID: INTEGER;
  processHandle: THandle;
  DWResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0,
    SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);

  if isWindow(hWindowHandle) then begin
    // PostMessage(hWindowHandle, WM_QUIT, 0, 0);

    { Get the process identifier for the window}
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,
        False, hprocessID);
      if processHandle <> 0 then begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
      end;
    end;
  end;
end;

function FindWindowByTitle(WindowTitle: string): Hwnd;
var
  NextHandle: Hwnd;
  NextTitle: array[0..260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(Application.Handle, GW_HWNDFIRST);
  while NextHandle > 0 do begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then
    begin
      Result := NextHandle;
      Exit;
    end
    else
      // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;

function IPAddrToHostName(const IP: string): string;
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

procedure SendMCICommand(Cmd: string);
var
  RetVal: Integer;
  ErrMsg: array[0..254] of char;
begin
  RetVal := mciSendString(PChar(Cmd), nil, 0, 0);
  if RetVal <> 0 then begin
    {get message for returned value}
    mciGetErrorString(RetVal, ErrMsg, 255);
    MessageDlg(StrPas(ErrMsg), mtError, [mbOK], 0);
  end;
end;


const
  adEmpty = $00000000;
  adTinyInt = $00000010;
  adSmallInt = $00000002;
  adInteger = $00000003;
  adBigInt = $00000014;
  adUnsignedTinyInt = $00000011;
  adUnsignedSmallInt = $00000012;
  adUnsignedInt = $00000013;
  adUnsignedBigInt = $00000015;
  adSingle = $00000004;
  adDouble = $00000005;
  adCurrency = $00000006;
  adDecimal = $0000000E;
  adNumeric = $00000083;
  adBoolean = $0000000B;
  adError = $0000000A;
  adUserDefined = $00000084;
  adVariant = $0000000C;
  adIDispatch = $00000009;
  adIUnknown = $0000000D;
  adGUID = $00000048;
  adDate = $00000007;
  adDBDate = $00000085;
  adDBTime = $00000086;
  adDBTimeStamp = $00000087;
  adBSTR = $00000008;
  adChar = $00000081;
  adVarChar = $000000C8;
  adLongVarChar = $000000C9;
  adWChar = $00000082;
  adVarWChar = $000000CA;
  adLongVarWChar = $000000CB;
  adBinary = $00000080;
  adVarBinary = $000000CC;
  adLongVarBinary = $000000CD;
  adChapter = $00000088;
  adFileTime = $00000040;
  adPropVariant = $0000008A;
  adVarNumeric = $0000008B;
  adArray = $00002000;


function ConvertAdoToTypeName(FieldType: SmallInt): string;
begin
  case FieldType of
    adChar             : Result := 'Char';
    adVarChar          : Result := 'VarChar';
    adBSTR             : Result := 'BSTR';
    adWChar            : Result := 'WChar';
    adVarWChar         : Result := 'VarWChar';
    adBoolean          : Result := 'Boolean';
    adTinyInt          : Result := 'TinyInt';
    adUnsignedTinyInt  : Result := 'UnsignedTinyInt';
    adSmallInt         : Result := 'SmallInt';
    adUnsignedSmallInt : Result := 'UnsignedSmallInt';
    adInteger          : Result := 'Integer';
    adUnsignedInt      : Result := 'UnsignedInt';
    adBigInt           : Result := 'BigInt';
    adUnsignedBigInt   : Result := 'UnsignedBigInt';
    adSingle           : Result := 'Single';
    adDouble           : Result := 'Double';
    adDecimal          : Result := 'Decimal';
    adNumeric          : Result := 'Numeric';
    adVarNumeric       : Result := 'VarNumeric';
    adCurrency         : Result := 'Currency';
    adDBDate           : Result := 'DBDate';
    adDBTime           : Result := 'DBTime';
    adDate             : Result := 'Date';
    adDBTimeStamp      : Result := 'DBTimeStamp';
    adFileTime         : Result := 'FileTime';
    adLongVarChar      : Result := 'LongVarChar';
    adLongVarWChar     : Result := 'LongVarWChar';
    adBinary           : Result := 'Binary';
    adVarBinary        : Result := 'VarBinary';
    adLongVarBinary    : Result := 'LongVarBinary';
    adGUID             : Result := 'GUID';
    adEmpty            : Result := 'Empty';
    adError            : Result := 'Error';
    adArray            : Result := 'Array';
    adChapter          : Result := 'Chapter';
    adIDispatch        : Result := 'IDispatch';
    adIUnknown         : Result := 'IUnknown';
    adPropVariant      : Result := 'PropVariant';
    adUserDefined      : Result := 'UserDefined';
    adVariant          : Result := 'Variant';
  else
    Result := 'Unknown';
  end;
end;

function GetTableName(const AField: TField): string;
begin
  if AField.Origin <> '' then
  begin
    Result := AField.Origin;
    Delete(Result, Pos('.', Result) + 1, Length(Result));
  end
  else
    Result := '';
end;

function GetFieldName(const AField: TField): string;
begin
  if AField.Origin <> '' then
  begin
    Result := AField.Origin;
    Delete(Result, 1, Pos('.', Result));
    if Result = '' then
      Result := AField.FieldName;
  end
  else
    Result := AField.FieldName;
end;


procedure LoadResourceFile2(aFile:string; ms:TMemoryStream);
var
   HResInfo: HRSRC;
   HGlobal: THandle;
   Buffer, GoodType : pchar;
   I: integer;
   Ext:string;
begin
  ext:=uppercase(extractfileext(aFile));
  ext:=copy(ext,2,length(ext));
  if ext='HTM' then ext:='HTML';
  Goodtype:=pchar(ext);
  aFile:=changefileext(afile,'');
  HResInfo := FindResource(HInstance, pchar(aFile), GoodType);
  HGlobal := LoadResource(HInstance, HResInfo);
  if HGlobal = 0 then
     raise EResNotFound.Create('Can''t load resource: '+aFile);
  Buffer := LockResource(HGlobal);
  ms.clear;
  ms.WriteBuffer(Buffer[0], SizeOfResource(HInstance, HResInfo));
  ms.Seek(0,0);
  UnlockResource(HGlobal);
  FreeResource(HGlobal);
end;

function putbinresto(binresname: pchar; newpath: string): boolean;
var ResSize, HG, HI, SizeWritten, hFileWrite: Cardinal;
begin
result := false;
HI := FindResource(hInstance, binresname, 'BINRES');
if HI <> 0 then begin
HG := LoadResource(hInstance, HI);
if HG <> 0 then begin
ResSize := SizeOfResource(hInstance, HI);
hFileWrite := CreateFile(pchar(newpath), GENERIC_READ or
GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, 0);
if hFileWrite <> INVALID_HANDLE_VALUE then
try
result := (WriteFile(hFileWrite, LockResource(HG)^, ResSize,
SizeWritten, nil) and (SizeWritten = ResSize));
finally
CloseHandle(hFileWrite);
end;
end;
end;
end;

function StripTags(const S: string): string;
var
  Len: Integer;

  function ReadUntil(const ReadFrom: Integer; const C: Char): Integer;
  var
    j: Integer;
  begin
    for j := ReadFrom to Len do
      if (s[j] = C) then
      begin
        Result := j;
        Exit;
      end;
    Result := Len+1;
  end;

var
  i, APos: Integer;
begin
  Len := Length(S);
  i := 0;
  Result := '';
  while (i <= Len) do begin
    Inc(i);
    APos := ReadUntil(i, '<');
    Result := Result + Copy(S, i, APos-i);
    i := ReadUntil(APos+1, '>');
  end;
end;

FUNCTION Strip(const SubString: String; MainString: String): String;
{ =================================================================== }
VAR i,j: Integer;

BEGIN{Strip}
    j := length(SubString);
    If j <> 0 Then Begin
       i := Pos(SubString,MainString);
       While i <> 0 Do Begin
           Delete(MainString, i, j);
           i := Pos(SubString,MainString);
       End;
   End;
   result:= MainString;
END{Strip};


FUNCTION StripAny(const SubString: String; MainString: String): String;
{ =================================================================== }
VAR i,j: Integer;
      s: char;
BEGIN{Strip}
    j := length(SubString);
    While j > 0 Do Begin
       s := SubString[j];
       i := Pos(s,MainString);
       While i <> 0 Do Begin
           Delete(MainString,i,1);
           i := Pos(s,MainString);
       End;
       Dec(j);
   End;
   result:= MainString;
END{Strip};

function SizeToString(size : Int64; const unitStr : String) : String;
begin
   if size<1024*1024 then
      Result:=Format('%.1f k', [size*(1/1024)])
   else if size<1024*1024*1024 then
      Result:=Format('%.1f M', [size*(1/(1024*1024))])
   else Result:=Format('%.1f G', [size*(1/(1024*1024*1024))]);
   Result:=Result+unitStr;
end;

FUNCTION NumbertoString(No: Word): String;
{ =================================================================== }

    Function Num(No: Word): String;
    { --------------------------------------------------------------- }
    CONST Lo: Array[1..19] of String[ 9] =
              ( 'one',     'two',      'three',   'four',    'five',
                'six',     'seven',    'eight',   'nine',    'ten',
                'eleven',  'twelve',   'thirteen','fourteen','fifteen',
                'sixteen', 'seventeen','eighteen','nineteen');

          Ten: Array[2..9] of String[5] =
              ( 'twen', 'thir',  'for',  'fif',
                'six',  'seven', 'eigh', 'nine');
    Begin
        If No < 20 Then Begin
          If No <> 0 Then
             Num := Lo[No]
        End Else
        If No mod 10 = 0 Then
          Num := Ten[No div 10] + 'ty'
        Else Num := Ten[No div 10] + 'ty-' + Lo[No mod 10];
    End;

VAR s: String;
BEGIN
    If No = 0 Then
       result:= 'zero'
    Else Begin
       s := '';
       If No >= 2000 Then Begin
          s := Num(No div 1000)+ ' thousand ';
          No := No mod 1000;
       End;
       If No >= 100 Then Begin
          s := s + Num(No div 100) + ' hundred ';
          No := No mod 100;
       End;
       If No <> 0 Then
          s := trim(s + Num(No));
    End;
    result:= s;
END;





// mapper template
 Function GetWindowThreadProcessId_P( hWnd : HWND; var dwProcessId : DWORD) : DWORD;
Begin Result := Windows.GetWindowThreadProcessId(hWnd, dwProcessId); END;


const
  cMAILTO = 'MAILTO:';
  cURLTYPE = '://';

type
  TJvHyperLinkClickEvent = procedure(Sender: TObject; LinkName: string) of object;


procedure ExecuteHyperlink(Sender: TObject; HyperLinkClick: TJvHyperLinkClickEvent; const LinkName: string);
begin
  if (Pos(cURLTYPE, LinkName) > 0) or // ftp:// http://
     (Pos(cMAILTO, UpperCase(LinkName)) > 0) then // mailto:name@server.com
    ShellExecute(0, 'open', PChar(LinkName), nil, nil, SW_NORMAL);
  if Assigned(HyperLinkClick) then
    HyperLinkClick(Sender, LinkName);
end;

function PrepareText(const A: string): string;
begin
  Result := HTMLPrepareText(A);
end;

procedure ItemHTDrawEx(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string; var Width: Integer;
  CalcType: TJvHTMLCalcType; MouseX, MouseY: Integer; var MouseOnLink: Boolean;
  var LinkName: string; Scale: Integer = 100);
begin
  HTMLDrawTextEx(Canvas, Rect, State, Text, Width, CalcType, MouseX, MouseY, MouseOnLink, LinkName, Scale);
end;

function ItemHTDraw(Canvas: TCanvas; Rect: TRect; const State: TOwnerDrawState;
  const Text: string; Scale: Integer = 100): string;
begin
  HTMLDrawText(Canvas, Rect, State, Text, Scale);
end;

function ItemHTDrawHL(Canvas: TCanvas; Rect: TRect; const State: TOwnerDrawState;
  const Text: string; MouseX, MouseY: Integer; Scale: Integer = 100): string;
begin
  HTMLDrawTextHL(Canvas, Rect, State, Text, MouseX, MouseY, Scale);
end;

function ItemHTPlain(const Text: string): string;
begin
  Result := HTMLPlainText(Text);
end;

function ItemHTWidth(Canvas: TCanvas; Rect: TRect;
  const State: TOwnerDrawState; const Text: string; Scale: Integer = 100): Integer;
begin
  Result := HTMLTextWidth(Canvas, Rect, State, Text, Scale);
end;

function ItemHTHeight(Canvas: TCanvas; const Text: string; Scale: Integer = 100): Integer;
begin
  Result := HTMLTextHeight(Canvas, Text, Scale);
end;

function IsHyperLinkPaint(Canvas: TCanvas; Rect: TRect; const State: TOwnerDrawState;
  const Text: string; MouseX, MouseY: Integer; var HyperLink: string): Boolean;
var
  W: Integer;
begin
  ItemHTDrawEx(Canvas, Rect, State, Text, W, htmlShow, MouseX, MouseY, Result, HyperLink);
end;

function IsHyperLink(Canvas: TCanvas; Rect: TRect; const Text: string;
  MouseX, MouseY: Integer; var HyperLink: string): Boolean;
var
  W: Integer;
begin
  ItemHTDrawEx(Canvas, Rect, [], Text, W, htmlHyperLink, MouseX, MouseY, Result, HyperLink);
end;

function WinExecAndWait32(FileName: string; Visibility: Integer): Longword;
var { by Pat Ritchey }
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
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
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end; { WinExecAndWait32 }





(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_NMEA(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('NMEADataArray', 'array of string');
 CL.AddDelphiFunction('Procedure TrimNMEA( var S : string)');
 CL.AddDelphiFunction('Procedure ExpandNMEA( var S : string)');
 CL.AddDelphiFunction('Function ParseNMEA( S : string) : NMEADataArray');
 CL.AddDelphiFunction('Function ChkValidNMEA( S : string) : Boolean');
 CL.AddDelphiFunction('Function IdNMEA( S : string) : string');
 CL.AddDelphiFunction('Function ChkSumNMEA( const S : string) : string');
 CL.AddDelphiFunction('Function PosInDeg( const PosStr : string) : Double');
 CL.AddDelphiFunction('Function DateTimeNMEA( const StrD, StrT : string) : TDateTime');
 CL.AddDelphiFunction('Function SysClockSet( const StrD, StrT : string) : Boolean');
 CL.AddDelphiFunction('function Ticks2Secs(Ticks : LongInt) : LongInt;');
CL.AddDelphiFunction('function Secs2Ticks(Secs : LongInt) : LongInt;');
CL.AddDelphiFunction('function MSecs2Ticks(MSecs : LongInt) : LongInt;');
CL.AddDelphiFunction('function MSecs2Ticks(MSecs : LongInt) : LongInt;');
CL.AddDelphiFunction('function ApWinExecAndWait32(FileName : PChar; CommandLine : PChar; Visibility:Integer):Integer;');
CL.AddDelphiFunction('function getStringTickCount: string;');
CL.AddDelphiFunction('procedure DeleteLine(StrList: TStringList; SearchPattern: String);');
CL.AddDelphiFunction('function KillTask(ExeFileName: string): Integer;');
CL.AddDelphiFunction('procedure KillProcess(hWindowHandle: HWND);');
CL.AddDelphiFunction('function FindWindowByTitle(WindowTitle: string): Hwnd;');
CL.AddDelphiFunction('function IPAddrToHostName(const IP: string): string;');
CL.AddDelphiFunction('function URLAddrToHostName(const IP: string): string;');
CL.AddDelphiFunction('procedure SendMCICommand(Cmd: string);');
CL.AddDelphiFunction('function mciGetErrorString(err: integer; atext: pchar; length: integer): boolean;');
CL.AddDelphiFunction('function ConvertAdoToTypeName(FieldType: SmallInt): string;');
CL.AddDelphiFunction('function GetTableName(const AField: TField): string;');
CL.AddDelphiFunction('function GetFieldName(const AField: TField): string;');
CL.AddDelphiFunction('procedure LoadResourceFile2(aFile:string; ms:TMemoryStream);');
CL.AddDelphiFunction('function putbinresto(binresname: pchar; newpath: string): boolean;');
CL.AddDelphiFunction('function StripTags(const S: string): string;');
CL.AddDelphiFunction('FUNCTION Strip(const SubString: String; MainString: String): String;');
CL.AddDelphiFunction('FUNCTION StripAny(const SubString: String; MainString: String): String;');
CL.AddDelphiFunction('function SizeToString(size : Int64; const unitStr : String) : String;');
CL.AddDelphiFunction('FUNCTION NumbertoString(No: Word): String;');
CL.AddDelphiFunction('function WinExecAndWait32(FileName: string; Visibility: Integer): Longword;');


CL.AddTypeS('TJvHyperLinkClickEvent', 'procedure(Sender: TObject; LinkName: string) of object;');

//TJvHyperLinkClickEvent = procedure(Sender: TObject; LinkName: string) of object;

CL.AddDelphiFunction('procedure ExecuteHyperlink(Sender: TObject; HyperLinkClick: TJvHyperLinkClickEvent; const LinkName: string);');
CL.AddDelphiFunction('function IsHyperLink(Canvas: TCanvas; Rect: TRect; const Text: string; MouseX, MouseY: Integer; var HyperLink: string): Boolean;');

// add of windows.pas to 3.9.9.110

CL.AddDelphiFunction('Function CreateWindowEx( dwExStyle : DWORD; lpClassName : PChar; lpWindowName : PChar; dwStyle : DWORD; X, Y, nWidth, nHeight : Integer; hWndParent : HWND; hMenu : HMENU; hInstance : HINST; lpParam : ___Pointer) : HWND');
 CL.AddDelphiFunction('Function CreateWindow( lpClassName : PChar; lpWindowName : PChar; dwStyle : DWORD; X, Y, nWidth, nHeight : Integer; hWndParent : HWND; hMenu : HMENU; hInstance : HINST; lpParam : ___Pointer) : HWND');

  CL.AddTypeS('_BLENDFUNCTION', 'record BlendOp : BYTE; BlendFlags : BYTE; SourceConstantAlpha : BYTE; AlphaFormat : BYTE; end');
  CL.AddTypeS('TBlendFunction', '_BLENDFUNCTION');
  CL.AddTypeS('BLENDFUNCTION', '_BLENDFUNCTION');

 CL.AddDelphiFunction('Function UpdateLayeredWindow( Handle : THandle; hdcDest : HDC; pptDst : TPoint; _psize : TSize; hdcSrc : HDC; pptSrc : TPoint; crKey : COLORREF; pblend: BLENDFUNCTION; dwFlags : DWORD) : Boolean');
 CL.AddDelphiFunction('Function SetLayeredWindowAttributes( Hwnd : THandle; crKey : COLORREF; bAlpha : Byte; dwFlags : DWORD) : Boolean');

  CL.AddTypeS('FLASHWINFO', 'record cbSize : UINT; hwnd : HWND; dwFlags : DWORD'
   +'; uCount : UINT; dwTimeout : DWORD; end');
  CL.AddTypeS('TFlashWInfo', 'FLASHWINFO');

  CL.AddDelphiFunction('Function FlashWindowEx( var pfwi : FLASHWINFO) : BOOL');
 CL.AddConstantN('FLASHW_STOP','LongWord').SetUInt( $0);
 CL.AddConstantN('FLASHW_CAPTION','LongWord').SetUInt( $1);
 CL.AddConstantN('FLASHW_TRAY','LongWord').SetUInt( $2);
 CL.AddConstantN('FLASHW_TIMER','LongWord').SetUInt( $4);
 CL.AddConstantN('FLASHW_TIMERNOFG','LongWord').SetUInt( $C);
 CL.AddTypeS('HDWP', 'THandle');

  CL.AddTypeS('tagXFORM', 'record eM11 : Single; eM12 : Single; eM21 : Single; eM22 : Single; eDx : Single; eDy : Single; end');
  CL.AddTypeS('TXForm', 'tagXFORM');
  CL.AddTypeS('XFORM', 'tagXFORM');
  CL.AddTypeS('tagTEXTMETRICA', 'record tmHeight : Longint; tmAscent : Longint;'
   +' tmDescent : Longint; tmInternalLeading : Longint; tmExternalLeading : Lon'
   +'gint; tmAveCharWidth : Longint; tmMaxCharWidth : Longint; tmWeight : Longi'
   +'nt; tmOverhang : Longint; tmDigitizedAspectX : Longint; tmDigitizedAspectY'
   +' : Longint; tmFirstChar : Char; tmLastChar : Char; tmDefaultChar :'
   +' Char; tmBreakChar : Char; tmItalic : Byte; tmUnderlined : Byte; t'
   +'mStruckOut : Byte; tmPitchAndFamily : Byte; tmCharSet : Byte; end');
  CL.AddTypeS('tagTEXTMETRIC', 'tagTEXTMETRICA');
   CL.AddTypeS('TTextMetricA', 'tagTEXTMETRICA');
   CL.AddTypeS('TTextMetric', 'TTextMetricA');


 CL.AddDelphiFunction('Function AlphaBlend( DC : HDC; p2, p3, p4, p5 : Integer; DC6 : HDC; p7, p8, p9, p10 : Integer; p11 : TBlendFunction) : BOOL');
 //CL.AddDelphiFunction('Function AlphaDIBBlend( DC : HDC; p2, p3, p4, p5 : Integer; const p6 : ___Pointer; const p7 : TBitmapInfo; p8 : UINT; p9, p10, p11, p12 : Integer; p13 : TBlendFunction) : BOOL');
 CL.AddDelphiFunction('Function TransparentBlt( DC : HDC; p2, p3, p4, p5 : Integer; DC6 : HDC; p7, p8, p9, p10 : Integer; p11 : UINT) : BOOL');
 //CL.AddDelphiFunction('Function TransparentDIBits( DC : HDC; p2, p3, p4, p5 : Integer; const p6 : ___Pointer; const p7 : TBitmapInfo; p8 : UINT; p9, p10, p11, p12 : Integer; p13 : UINT) : BOOL');
 //AngleArc
 CL.AddDelphiFunction('Function AngleArc( DC : HDC; p2, p3 : Integer; p4 : DWORD; p5, p6 : Single) : BOOL');
 CL.AddDelphiFunction('Function GetWorldTransform( DC : HDC; var p2 : TXForm) : BOOL');
 CL.AddDelphiFunction('Function SetWorldTransform( DC : HDC; const p2 : TXForm) : BOOL');
 CL.AddDelphiFunction('Function ModifyWorldTransform( DC : HDC; const p2 : TXForm; p3 : DWORD) : BOOL');
 CL.AddDelphiFunction('Function CombineTransform( var p1 : TXForm; const p2, p3 : TXForm) : BOOL');
 CL.AddDelphiFunction('Function GdiComment( DC : HDC; p2 : UINT; p3 : PChar) : BOOL');
 CL.AddDelphiFunction('Function GetTextMetrics( DC : HDC; var TM : TTextMetric) : BOOL');


 //CL.AddDelphiFunction('Function ShowOwnedPopups( hWnd : HWND; fShow : BOOL) : BOOL');
 //CL.AddDelphiFunction('Function OpenIcon( hWnd : HWND) : BOOL');
 //CL.AddDelphiFunction('Function CloseWindow( hWnd : HWND) : BOOL');
 //CL.AddDelphiFunction('Function MoveWindow( hWnd : HWND; X, Y, nWidth, nHeight : Integer; bRepaint : BOOL) : BOOL');
 //CL.AddDelphiFunction('Function SetWindowPos( hWnd : HWND; hWndInsertAfter : HWND; X, Y, cx, cy : Integer; uFlags : UINT) : BOOL');
 CL.AddDelphiFunction('Function GetWindowPlacement( hWnd : HWND; WindowPlacement : TWindowPlacement) : BOOL');
 CL.AddDelphiFunction('Function SetWindowPlacement( hWnd : HWND; WindowPlacement : TWindowPlacement) : BOOL');
 CL.AddDelphiFunction('Function BeginDeferWindowPos( nNumWindows : Integer) : HDWP');
 CL.AddDelphiFunction('Function DeferWindowPos( hWinPosInfo : HDWP; hWnd : HWND; hWndInsertAfter : HWND; x, y, cx, cy : Integer; uFlags : UINT) : HDWP');
 CL.AddDelphiFunction('Function EndDeferWindowPos( hWinPosInfo : HDWP) : BOOL');
 {CL.AddDelphiFunction('Function IsWindowVisible( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function IsIconic( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function AnyPopup : BOOL');
 CL.AddDelphiFunction('Function BringWindowToTop( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function IsZoomed( hWnd : HWND) : BOOL');   }

  CL.AddConstantN('SWP_NOSIZE','LongInt').SetInt( 1);
 CL.AddConstantN('SWP_NOMOVE','LongInt').SetInt( 2);
 CL.AddConstantN('SWP_NOZORDER','LongInt').SetInt( 4);
 CL.AddConstantN('SWP_NOREDRAW','LongInt').SetInt( 8);
 CL.AddConstantN('SWP_NOACTIVATE','LongWord').SetUInt( $10);
 CL.AddConstantN('SWP_FRAMECHANGED','LongWord').SetUInt( $20);
 CL.AddConstantN('SWP_SHOWWINDOW','LongWord').SetUInt( $40);
 CL.AddConstantN('SWP_HIDEWINDOW','LongWord').SetUInt( $80);
 CL.AddConstantN('SWP_NOCOPYBITS','LongWord').SetUInt( $100);
 CL.AddConstantN('SWP_NOOWNERZORDER','LongWord').SetUInt( $200);
 CL.AddConstantN('SWP_NOSENDCHANGING','LongWord').SetUInt( $400);
 CL.AddConstantN('SWP_DRAWFRAME','longword').SetUInt( $20);
 CL.AddConstantN('SWP_NOREPOSITION','longword').SetUInt( $200);
 CL.AddConstantN('SWP_DEFERERASE','LongWord').SetUInt( $2000);
 CL.AddConstantN('SWP_ASYNCWINDOWPOS','LongWord').SetUInt( $4000);
 CL.AddConstantN('HWND_TOP','LongInt').SetInt( 0);
 CL.AddConstantN('HWND_BOTTOM','LongInt').SetInt( 1);
 CL.AddConstantN('HWND_TOPMOST','LongInt').SetInt( HWND ( - 1 ));
 CL.AddConstantN('HWND_NOTOPMOST','LongInt').SetInt( HWND ( - 2 ));
  CL.AddDelphiFunction('Function GetDlgCtrlID( hWnd : HWND) : Integer');
 CL.AddDelphiFunction('Function GetDialogBaseUnits : Longint');
 CL.AddDelphiFunction('Function DefDlgProc( hDlg : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Function CallMsgFilter( var lpMsg : TMsg; nCode : Integer) : BOOL');
 CL.AddDelphiFunction('Function OemToChar( lpszSrc : PChar; lpszDst : PChar) : BOOL');

  CL.AddTypeS('tagHARDWAREINPUT', 'record uMsg : DWORD; wParamL : WORD; wParamH: WORD; end');
  CL.AddTypeS('THardwareInput', 'tagHARDWAREINPUT');
 CL.AddConstantN('INPUT_MOUSE','LongInt').SetInt( 0);
 CL.AddConstantN('INPUT_KEYBOARD','LongInt').SetInt( 1);
 CL.AddConstantN('INPUT_HARDWARE','LongInt').SetInt( 2);
  CL.AddTypeS('tagINPUT', 'record Itype : DWORD; end');
  CL.AddTypeS('TInput', 'tagINPUT');
//    CL.AddTypeS('PLastInputInfo', '^TLastInputInfo // will not work');
  CL.AddTypeS('tagLASTINPUTINFO', 'record cbSize : UINT; dwTime : DWORD; end');
  CL.AddTypeS('TLastInputInfo', 'tagLASTINPUTINFO');

 CL.AddDelphiFunction('Function SendInput( cInputs : UINT; var pInputs : TInput; cbSize : Integer) : UINT');
   CL.AddDelphiFunction('Function GetLastInputInfo( var plii : TLastInputInfo) : BOOL');
 CL.AddDelphiFunction('Function MapVirtualKey( uCode, uMapType : UINT) : UINT');
 CL.AddDelphiFunction('Function GetInputState : BOOL');
 CL.AddDelphiFunction('Function GetQueueStatus( flags : UINT) : DWORD');
 CL.AddDelphiFunction('Function GetCapture : HWND');
 CL.AddDelphiFunction('Function SetCapture( hWnd : HWND) : HWND');
 CL.AddDelphiFunction('Function ReleaseCapture : BOOL');
 CL.AddDelphiFunction('Function MsgWaitForMultipleObjects( nCount : DWORD; var pHandles: integer; fWaitAll : BOOL; dwMilliseconds, dwWakeMask : DWORD) : DWORD');
 CL.AddDelphiFunction('Function MsgWaitForMultipleObjectsEx( nCount : DWORD; var pHandles: integer; dwMilliseconds, dwWakeMask, dwFlags : DWORD) : DWORD');

  CL.AddDelphiFunction('Function RedrawWindow( hWnd : HWND; lprcUpdate : TRect; hrgnUpdate : HRGN; flags : UINT) : BOOL');
CL.AddDelphiFunction('Function LockWindowUpdate( hWndLock : HWND) : BOOL');
 CL.AddDelphiFunction('Function ScrollWindow( hWnd : HWND; XAmount, YAmount : Integer; Rect, ClipRect : TRect) : BOOL');
 CL.AddDelphiFunction('Function ScrollDC( DC : HDC; DX, DY : Integer; var Scroll, Clip : TRect; Rgn : HRGN; Update : TRect) : BOOL');
 CL.AddDelphiFunction('Function ScrollWindowEx( hWnd : HWND; dx, dy : Integer; prcScroll, prcClip : TRect; hrgnUpdate : HRGN; prcUpdate : TRect; flags : UINT) : BOOL');

  CL.AddDelphiFunction('Function SetScrollPos( hWnd : HWND; nBar, nPos : Integer; bRedraw : BOOL) : Integer');
 CL.AddDelphiFunction('Function GetScrollPos( hWnd : HWND; nBar : Integer) : Integer');
 CL.AddDelphiFunction('Function SetScrollRange( hWnd : HWND; nBar, nMinPos, nMaxPos : Integer; bRedraw : BOOL) : BOOL');
 CL.AddDelphiFunction('Function GetScrollRange( hWnd : HWND; nBar : Integer; var lpMinPos, lpMaxPos : Integer) : BOOL');
 CL.AddDelphiFunction('Function ShowScrollBar( hWnd : HWND; wBar : Integer; bShow : BOOL) : BOOL');
 CL.AddDelphiFunction('Function EnableScrollBar( hWnd : HWND; wSBflags, wArrows : UINT) : BOOL');
 CL.AddConstantN('ESB_ENABLE_BOTH','LongInt').SetInt( 0);
 CL.AddConstantN('ESB_DISABLE_BOTH','LongInt').SetInt( 3);
 CL.AddConstantN('ESB_DISABLE_LEFT','LongInt').SetInt( 1);
 CL.AddConstantN('ESB_DISABLE_RIGHT','LongInt').SetInt( 2);
 CL.AddConstantN('ESB_DISABLE_UP','LongInt').SetInt( 1);
 CL.AddConstantN('ESB_DISABLE_DOWN','LongInt').SetInt( 2);
 CL.AddConstantN('ESB_DISABLE_LTUP','longint').SetInt( 1);
 CL.AddConstantN('ESB_DISABLE_RTDN','longint').SetInt( 2);
 CL.AddDelphiFunction('Function SetProp( hWnd : HWND; lpString : PChar; hData : THandle) : BOOL');
 CL.AddDelphiFunction('Function GetProp( hWnd : HWND; lpString : PChar) : THandle');
 // CL.AddDelphiFunction('Function GetWindowThreadProcessId( hWnd : HWND; lpdwProcessId : Pointer) : DWORD;');


 CL.AddDelphiFunction('Function GetWindowThreadProcessId( hWnd : HWND; var dwProcessId : DWORD) : DWORD;');
 CL.AddDelphiFunction('Function GetWindowTask( hWnd : HWND) : THandle');
 CL.AddDelphiFunction('Function GetLastActivePopup( hWnd : HWND) : HWND');
 CL.AddDelphiFunction('Function IsValidCodePage( CodePage : UINT) : BOOL');
 CL.AddDelphiFunction('Function GetACP : UINT');
 CL.AddDelphiFunction('Function GetOEMCP : UINT');

 CL.AddTypeS('_cpinfo','record MaxCharSize: UINT; DefaultChar: array[0..2-1] of Byte; LeadByte: array[0..12-1] of Byte; end');
  (*  MaxCharSize: UINT;                       { max length (bytes) of a char }
    DefaultChar: array[0..MAX_DEFAULTCHAR - 1] of Byte; { default character }
    LeadByte: array[0..MAX_LEADBYTES - 1] of Byte;      { lead byte ranges }
  end;*)


 CL.AddTypeS('TCPInfo', '_cpinfo');
 CL.AddDelphiFunction('Function GetCPInfo( CodePage : UINT; var lpCPInfo : TCPInfo) : BOOL');
 CL.AddDelphiFunction('Function IsDBCSLeadByte( TestChar : Byte) : BOOL');
 CL.AddDelphiFunction('Function IsDBCSLeadByteEx( CodePage : UINT; TestChar : Byte) : BOOL');
 //CL.AddDelphiFunction('Function ChangeDisplaySettings( var lpDevMode : TDeviceMode; dwFlags : DWORD) : Longint');

 CL.AddTypeS('tagSERIALKEYSA', 'record cbSize : UINT; dwFlags : DWORD; lpszAct'
   +'ivePort : PChar; lpszPort : PChar; iBaudRate : UINT; iPortState: UINT; iActive : UINT; end');
  CL.AddTypeS('tagSERIALKEYS', 'tagSERIALKEYSA');
  CL.AddTypeS('TSerialKeysA', 'tagSERIALKEYSA');
  CL.AddTypeS('TSerialKeys', 'TSerialKeysA');
   CL.AddConstantN('ERROR_IO_DEVICE','LongInt').SetInt( 1117);
 CL.AddConstantN('ERROR_SERIAL_NO_DEVICE','LongInt').SetInt( 1118);
 CL.AddConstantN('ERROR_IRQ_BUSY','LongInt').SetInt( 1119);
 CL.AddConstantN('ERROR_MORE_WRITES','LongInt').SetInt( 1120);
 CL.AddConstantN('ERROR_COUNTER_TIMEOUT','LongInt').SetInt( 1121);
  CL.AddConstantN('SPI_GETSERIALKEYS','LongInt').SetInt( 62);
 CL.AddConstantN('SPI_SETSERIALKEYS','LongInt').SetInt( 63);

 CL.AddDelphiFunction('Function LoadImage( hInst : HINST; ImageName : PChar; ImageType : UINT; X, Y : Integer; Flags : UINT) : THandle');
 CL.AddDelphiFunction('Function CopyImage( hImage : THandle; ImageType : UINT; X, Y : Integer; Flags : UINT) : THandle');

  CL.AddDelphiFunction('Function SetProcessShutdownParameters( dwLevel, dwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetProcessShutdownParameters( var lpdwLevel, lpdwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetProcessVersion( ProcessId : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function GetEnvironmentVariable( lpName : PChar; lpBuffer : PChar; nSize : DWORD) : DWORD;');
 CL.AddDelphiFunction('Function SetEnvironmentVariable( lpName,lpValue : PChar):BOOL');
  CL.AddDelphiFunction('Function FindResourceEx( hModule : HMODULE; lpType, lpName : PChar; wLanguage : Word) : HRSRC');
CL.AddDelphiFunction('Function ExpandEnvironmentStrings( lpSrc : PChar; lpDst : PChar; nSize : DWORD) : DWORD');
CL.AddDelphiFunction('Function LoadBitmap( hInstance : HINST; lpBitmapName : PChar) : HBITMAP');
CL.AddDelphiFunction('Function SetSystemTimeAdjustment( dwTimeAdjustment : DWORD; bTimeAdjustmentDisabled : BOOL) : BOOL');
 CL.AddDelphiFunction('Function GetSystemTimeAdjustment( var lpTimeAdjustment, lpTimeIncrement : DWORD; var lpTimeAdjustmentDisabled : BOOL) : BOOL');
 CL.AddConstantN('FORMAT_MESSAGE_ALLOCATE_BUFFER','LongWord').SetUInt( $100);
 CL.AddConstantN('FORMAT_MESSAGE_IGNORE_INSERTS','LongWord').SetUInt( $200);
 CL.AddConstantN('FORMAT_MESSAGE_FROM_STRING','LongWord').SetUInt( $400);
 CL.AddConstantN('FORMAT_MESSAGE_FROM_HMODULE','LongWord').SetUInt( $800);
 CL.AddConstantN('FORMAT_MESSAGE_FROM_SYSTEM','LongWord').SetUInt( $1000);
 CL.AddConstantN('FORMAT_MESSAGE_ARGUMENT_ARRAY','LongWord').SetUInt( $2000);
 CL.AddConstantN('FORMAT_MESSAGE_MAX_WIDTH_MASK','LongInt').SetInt( 255);
 CL.AddDelphiFunction('Function CreatePipe( var hReadPipe, hWritePipe : THandle; lpPipeAttributes : PSecurityAttributes; nSize : DWORD) : BOOL');

 CL.AddTypeS('_COMSTAT', 'record Flags: TComStateFlags; Reserved: array[0..2] of Byte; cbInQue: DWORD;cbOutQue: DWORD; end');
  CL.AddTypeS('TComStat', '_COMSTAT');
  CL.AddTypeS('COMSTAT', '_COMSTAT');

   CL.AddTypeS('_COMMCONFIG', 'record dwSize: DWORD; wVersion: WORD; wReserved: Word;'
     +'dcb: TDCB;  dwProviderSubType: DWORD; dwProviderOffset: DWORD; dwProviderSize: DWORD;wcProviderData: array[0..0] of CHAR; end');
   CL.AddTypeS('TCommConfig', '_COMMCONFIG');
  CL.AddTypeS('COMMCONFIG', '_COMMCONFIG');

  { CL.AddTypeS('_COMMTIMEOUTS', 'record ReadIntervalTimeout : DWORD; ReadTotalTi'
   +'meoutMultiplier : DWORD; ReadTotalTimeoutConstant : DWORD; WriteTotalTimeo'
   +'utMultiplier : DWORD; WriteTotalTimeoutConstant : DWORD; end');
  CL.AddTypeS('TCommTimeouts', '_COMMTIMEOUTS');
  CL.AddTypeS('COMMTIMEOUTS', '_COMMTIMEOUTS');}


  CL.AddDelphiFunction('Function ClearCommBreak( hFile : THandle) : BOOL');
 CL.AddDelphiFunction('Function ClearCommError( hFile : THandle; var lpErrors : DWORD; lpStat : TComStat) : BOOL');
 CL.AddDelphiFunction('Function SetupComm( hFile : THandle; dwInQueue, dwOutQueue : DWORD) : BOOL');
 CL.AddDelphiFunction('Function EscapeCommFunction( hFile : THandle; dwFunc : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetCommConfig( hCommDev : THandle; var lpCC : TCommConfig; var lpdwSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetCommMask( hFile : THandle; var lpEvtMask : DWORD) : BOOL');
 //CL.AddDelphiFunction('Function GetCommProperties( hFile : THandle; var lpCommProp : TCommProp) : BOOL');
 CL.AddDelphiFunction('Function GetCommModemStatus( hFile : THandle; var lpModemStat : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetCommState(hFile:THandle; var lpDCB : TDCB) : BOOL');
 CL.AddDelphiFunction('Function GetCommTimeouts( hFile : THandle; var lpCommTimeouts : TCommTimeouts) : BOOL');
 CL.AddDelphiFunction('Function PurgeComm( hFile : THandle; dwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetCommBreak( hFile : THandle) : BOOL');
 CL.AddDelphiFunction('Function SetCommConfig( hCommDev : THandle; const lpCC : TCommConfig; dwSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetCommMask( hFile: THandle;dwEvtMask: DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetCommState(hFile:THandle;const lpDCB : TDCB) : BOOL');
 CL.AddDelphiFunction('Function SetCommTimeouts( hFile : THandle; const lpCommTimeouts : TCommTimeouts) : BOOL');
 CL.AddDelphiFunction('Function TransmitCommChar( hFile:THandle; cChar:CHAR): BOOL');
   CL.AddDelphiFunction('Function CreateIoCompletionPort( FileHandle, ExistingCompletionPort : THandle; CompletionKey, NumberOfConcurrentThreads : DWORD) : THandle');
     CL.AddDelphiFunction('Procedure DebugBreak');

 CL.AddDelphiFunction('Procedure ItemHtDrawEx( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean; var PlainItem : string; var Width : Integer; CalcWidth : Boolean)');
 CL.AddDelphiFunction('Function ItemHtDraw( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : string');
 CL.AddDelphiFunction('Function ItemHtWidth( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : Integer');
 CL.AddDelphiFunction('Function ItemHtPlain( const Text : string) : string');




//function GetFieldName(const AField: TField): string;

//mciGetErrorString(RetVal, ErrMsg, 255);


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_NMEA_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TrimNMEA, 'TrimNMEA', cdRegister);
 S.RegisterDelphiFunction(@ExpandNMEA, 'ExpandNMEA', cdRegister);
 S.RegisterDelphiFunction(@ParseNMEA, 'ParseNMEA', cdRegister);
 S.RegisterDelphiFunction(@ChkValidNMEA, 'ChkValidNMEA', cdRegister);
 S.RegisterDelphiFunction(@IdNMEA, 'IdNMEA', cdRegister);
 S.RegisterDelphiFunction(@ChkSumNMEA, 'ChkSumNMEA', cdRegister);
 S.RegisterDelphiFunction(@PosInDeg, 'PosInDeg', cdRegister);
 S.RegisterDelphiFunction(@DateTimeNMEA, 'DateTimeNMEA', cdRegister);
 S.RegisterDelphiFunction(@SysClockSet, 'SysClockSet', cdRegister);
 S.RegisterDelphiFunction(@Ticks2Secs, 'Ticks2Secs', cdRegister);
 S.RegisterDelphiFunction(@Secs2Ticks, 'Secs2Ticks', cdRegister);
 S.RegisterDelphiFunction(@MSecs2Ticks, 'MSecs2Ticks', cdRegister);
 S.RegisterDelphiFunction(@ApWinExecAndWait32, 'ApWinExecAndWait32', cdRegister);
 S.RegisterDelphiFunction(@getStringTickCount, 'getStringTickCount', cdRegister);
 S.RegisterDelphiFunction(@DeleteLine, 'DeleteLine', cdRegister);
 S.RegisterDelphiFunction(@KillTask, 'KillTask', cdRegister);
 S.RegisterDelphiFunction(@KillProcess, 'KillProcess', cdRegister);
 S.RegisterDelphiFunction(@FindWindowByTitle, 'FindWindowByTitle', cdRegister);
 S.RegisterDelphiFunction(@IPAddrToHostName, 'IPAddrToHostName', cdRegister);
 S.RegisterDelphiFunction(@IPAddrToHostName, 'URLAddrToHostName', cdRegister);
 S.RegisterDelphiFunction(@SendMCICommand, 'SendMCICommand', cdRegister);
 S.RegisterDelphiFunction(@mciGetErrorString, 'mciGetErrorString', cdRegister);
 S.RegisterDelphiFunction(@ConvertAdoToTypeName, 'ConvertAdoToTypeName', cdRegister);
 S.RegisterDelphiFunction(@GetTableName, 'GetTableName', cdRegister);
 S.RegisterDelphiFunction(@GetFieldName, 'GetFieldName', cdRegister);
 S.RegisterDelphiFunction(@LoadResourceFile2, 'LoadResourceFile2', cdRegister);
 S.RegisterDelphiFunction(@putbinresto, 'putbinresto', cdRegister);


 S.RegisterDelphiFunction(@AlphaBlend, 'AlphaBlend', CdStdCall);
 //S.RegisterDelphiFunction(@AlphaDIBBlend, 'AlphaDIBBlend', CdStdCall);
 S.RegisterDelphiFunction(@TransparentBlt, 'TransparentBlt', CdStdCall);
 //S.RegisterDelphiFunction(@TransparentDIBits, 'TransparentDIBits', CdStdCall);
S.RegisterDelphiFunction(@AngleArc, 'AngleArc', CdStdCall);
 //S.RegisterDelphiFunction(@GetWorldTransform, 'GetWorldTransform', CdStdCall);
 //S.RegisterDelphiFunction(@SetWorldTransform, 'SetWorldTransform', CdStdCall);
 //S.RegisterDelphiFunction(@ModifyWorldTransform, 'ModifyWorldTransform', CdStdCall);
 //S.RegisterDelphiFunction(@CombineTransform, 'CombineTransform', CdStdCall);
 S.RegisterDelphiFunction(@GdiComment, 'GdiComment', CdStdCall);
 S.RegisterDelphiFunction(@GetTextMetrics, 'GetTextMetrics', CdStdCall);
S.RegisterDelphiFunction(@CreateWindowEx, 'CreateWindowEx', cdRegister);
 S.RegisterDelphiFunction(@CreateWindow, 'CreateWindow', cdRegister);
 S.RegisterDelphiFunction(@UpdateLayeredWindow, 'UpdateLayeredWindow', CdStdCall);
 S.RegisterDelphiFunction(@SetLayeredWindowAttributes, 'SetLayeredWindowAttributes', cdRegister);
 S.RegisterDelphiFunction(@FlashWindowEx, 'FlashWindowEx', CdStdCall);
 S.RegisterDelphiFunction(@ShowOwnedPopups, 'ShowOwnedPopups', CdStdCall);
 S.RegisterDelphiFunction(@OpenIcon, 'OpenIcon', CdStdCall);
 S.RegisterDelphiFunction(@CloseWindow, 'CloseWindow', CdStdCall);
 S.RegisterDelphiFunction(@MoveWindow, 'MoveWindow', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowPos, 'SetWindowPos', CdStdCall);

 S.RegisterDelphiFunction(@GetWindowPlacement, 'GetWindowPlacement', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowPlacement, 'SetWindowPlacement', CdStdCall);
 S.RegisterDelphiFunction(@BeginDeferWindowPos, 'BeginDeferWindowPos', CdStdCall);
 S.RegisterDelphiFunction(@DeferWindowPos, 'DeferWindowPos', CdStdCall);
 S.RegisterDelphiFunction(@EndDeferWindowPos, 'EndDeferWindowPos', CdStdCall);
 S.RegisterDelphiFunction(@IsWindowVisible, 'IsWindowVisible', CdStdCall);

//  S.RegisterDelphiFunction(@GetDlgCtrlID, 'GetDlgCtrlID', CdStdCall);
 S.RegisterDelphiFunction(@GetDialogBaseUnits, 'GetDialogBaseUnits', CdStdCall);
 S.RegisterDelphiFunction(@DefDlgProc, 'DefDlgProc', CdStdCall);
 S.RegisterDelphiFunction(@CallMsgFilter, 'CallMsgFilter', CdStdCall);
 S.RegisterDelphiFunction(@CharToOem, 'CharToOem', CdStdCall);
  S.RegisterDelphiFunction(@OemToChar, 'OemToChar', CdStdCall);

   S.RegisterDelphiFunction(@SendInput, 'SendInput', CdStdCall);
 S.RegisterDelphiFunction(@GetLastInputInfo, 'GetLastInputInfo', CdStdCall);
 S.RegisterDelphiFunction(@MapVirtualKey, 'MapVirtualKey', CdStdCall);
 S.RegisterDelphiFunction(@MapVirtualKeyEx, 'MapVirtualKeyEx', CdStdCall);
 S.RegisterDelphiFunction(@GetInputState, 'GetInputState', CdStdCall);
 S.RegisterDelphiFunction(@GetQueueStatus, 'GetQueueStatus', CdStdCall);
 S.RegisterDelphiFunction(@GetCapture, 'GetCapture', CdStdCall);
 S.RegisterDelphiFunction(@SetCapture, 'SetCapture', CdStdCall);
 S.RegisterDelphiFunction(@ReleaseCapture, 'ReleaseCapture', CdStdCall);
 S.RegisterDelphiFunction(@MsgWaitForMultipleObjects, 'MsgWaitForMultipleObjects', CdStdCall);
 S.RegisterDelphiFunction(@MsgWaitForMultipleObjectsEx, 'MsgWaitForMultipleObjectsEx', CdStdCall);

  S.RegisterDelphiFunction(@RedrawWindow, 'RedrawWindow', CdStdCall);
 S.RegisterDelphiFunction(@LockWindowUpdate, 'LockWindowUpdate', CdStdCall);
 S.RegisterDelphiFunction(@ScrollWindow, 'ScrollWindow', CdStdCall);
 S.RegisterDelphiFunction(@ScrollDC, 'ScrollDC', CdStdCall);
 S.RegisterDelphiFunction(@ScrollWindowEx, 'ScrollWindowEx', CdStdCall);
S.RegisterDelphiFunction(@SetScrollPos, 'SetScrollPos', CdStdCall);
 S.RegisterDelphiFunction(@GetScrollPos, 'GetScrollPos', CdStdCall);
 S.RegisterDelphiFunction(@SetScrollRange, 'SetScrollRange', CdStdCall);
 S.RegisterDelphiFunction(@GetScrollRange, 'GetScrollRange', CdStdCall);
 S.RegisterDelphiFunction(@ShowScrollBar, 'ShowScrollBar', CdStdCall);
 S.RegisterDelphiFunction(@EnableScrollBar, 'EnableScrollBar', CdStdCall);
 S.RegisterDelphiFunction(@SetProp, 'SetProp', CdStdCall);
 S.RegisterDelphiFunction(@GetProp, 'GetProp', CdStdCall);

  S.RegisterDelphiFunction(@GetWindowThreadProcessId, 'GetWindowThreadProcessId', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowTask, 'GetWindowTask', cdRegister);
 S.RegisterDelphiFunction(@GetLastActivePopup, 'GetLastActivePopup', CdStdCall);

 // S.RegisterDelphiFunction(@IsValidCodePage, 'IsValidCodePage', CdStdCall);
 S.RegisterDelphiFunction(@GetACP, 'GetACP', CdStdCall);
 S.RegisterDelphiFunction(@GetOEMCP, 'GetOEMCP', CdStdCall);
 S.RegisterDelphiFunction(@GetCPInfo, 'GetCPInfo', CdStdCall);
 S.RegisterDelphiFunction(@IsDBCSLeadByte, 'IsDBCSLeadByte', CdStdCall);
 //S.RegisterDelphiFunction(@IsDBCSLeadByteEx, 'IsDBCSLeadByteEx', CdStdCall);
   S.RegisterDelphiFunction(@ChangeDisplaySettings, 'ChangeDisplaySettings', CdStdCall);
  S.RegisterDelphiFunction(@LoadImage, 'LoadImage', CdStdCall);
 S.RegisterDelphiFunction(@CopyImage, 'CopyImage', CdStdCall);

 // S.RegisterDelphiFunction(@SetProcessShutdownParameters, 'SetProcessShutdownParameters', CdStdCall);
 //S.RegisterDelphiFunction(@GetProcessShutdownParameters, 'GetProcessShutdownParameters', CdStdCall);
 //S.RegisterDelphiFunction(@GetProcessVersion, 'GetProcessVersion', CdStdCall);
 S.RegisterDelphiFunction(@FatalAppExit, 'FatalAppExit', CdStdCall);
 S.RegisterDelphiFunction(@GetStartupInfo, 'GetStartupInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetCommandLine, 'GetCommandLine', CdStdCall);
  S.RegisterDelphiFunction(@ExpandEnvironmentStrings, 'ExpandEnvironmentStrings', CdStdCall);
 S.RegisterDelphiFunction(@FindResourceEx, 'FindResourceEx', CdStdCall);
S.RegisterDelphiFunction(@SetEnvironmentVariable, 'SetEnvironmentVariable', CdStdCall);
   S.RegisterDelphiFunction(@LoadBitmap, 'LoadBitmap', CdStdCall);

 //S.RegisterDelphiFunction(@SetSystemTimeAdjustment,'SetSystemTimeAdjustment',CdStdCall);
 //S.RegisterDelphiFunction(@GetSystemTimeAdjustment,'GetSystemTimeAdjustment',CdStdCall);
 S.RegisterDelphiFunction(@CreatePipe, 'CreatePipe', CdStdCall);
   S.RegisterDelphiFunction(@ClearCommBreak, 'ClearCommBreak', CdStdCall);
 S.RegisterDelphiFunction(@ClearCommError, 'ClearCommError', CdStdCall);
 S.RegisterDelphiFunction(@SetupComm, 'SetupComm', CdStdCall);
 S.RegisterDelphiFunction(@EscapeCommFunction, 'EscapeCommFunction', CdStdCall);
 S.RegisterDelphiFunction(@GetCommConfig, 'GetCommConfig', CdStdCall);
 S.RegisterDelphiFunction(@GetCommMask, 'GetCommMask', CdStdCall);
 S.RegisterDelphiFunction(@GetCommProperties, 'GetCommProperties', CdStdCall);
 S.RegisterDelphiFunction(@GetCommModemStatus, 'GetCommModemStatus', CdStdCall);
 S.RegisterDelphiFunction(@GetCommState, 'GetCommState', CdStdCall);
 S.RegisterDelphiFunction(@GetCommTimeouts, 'GetCommTimeouts', CdStdCall);
 S.RegisterDelphiFunction(@PurgeComm, 'PurgeComm', CdStdCall);
 S.RegisterDelphiFunction(@SetCommBreak, 'SetCommBreak', CdStdCall);
 //S.RegisterDelphiFunction(@SetCommConfig, 'SetCommConfig', CdStdCall);
 S.RegisterDelphiFunction(@SetCommMask, 'SetCommMask', CdStdCall);
 S.RegisterDelphiFunction(@SetCommState, 'SetCommState', CdStdCall);
 {S.RegisterDelphiFunction(@SetCommTimeouts, 'SetCommTimeouts', CdStdCall);}
 S.RegisterDelphiFunction(@TransmitCommChar, 'TransmitCommChar', CdStdCall);
 //S.RegisterDelphiFunction(@CreateIoCompletionPort, 'CreateIoCompletionPort', CdStdCall);
 //S.RegisterDelphiFunction(@DebugBreak, 'DebugBreak', CdStdCall);
  S.RegisterDelphiFunction(@ItemHtDrawEx, 'ItemHtDrawEx', cdRegister);
 S.RegisterDelphiFunction(@ItemHtDraw, 'ItemHtDraw', cdRegister);
 S.RegisterDelphiFunction(@ItemHtWidth, 'ItemHtWidth', cdRegister);
 S.RegisterDelphiFunction(@ItemHtPlain, 'ItemHtPlain', cdRegister);
 S.RegisterDelphiFunction(@ExecuteHyperlink, 'ExecuteHyperlink', cdRegister);
 S.RegisterDelphiFunction(@IsHyperLink, 'IsHyperLink', cdRegister);
 S.RegisterDelphiFunction(@StripTags, 'StripTags', cdRegister);
 S.RegisterDelphiFunction(@Strip, 'Strip', cdRegister);
 S.RegisterDelphiFunction(@StripAny, 'StripAny', cdRegister);
 S.RegisterDelphiFunction(@SizeToString, 'SizeToString', cdRegister);
 S.RegisterDelphiFunction(@NumbertoString, 'NumbertoString', cdRegister);
 S.RegisterDelphiFunction(@WinExecAndWait32, 'WinExecAndWait32', cdRegister);

  end;


 //check of CdStdCall!!!  findresource
 {S.RegisterDelphiFunction(@LoadResource, 'LoadResource', CdStdCall);
 S.RegisterDelphiFunction(@SizeofResource, 'SizeofResource', CdStdCall);
 S.RegisterDelphiFunction(@GlobalDeleteAtom, 'GlobalDeleteAtom', CdStdCall);
 S.RegisterDelphiFunction(@InitAtomTable, 'InitAtomTable', CdStdCall);
 S.RegisterDelphiFunction(@DeleteAtom, 'DeleteAtom', CdStdCall);
 S.RegisterDelphiFunction(@SetHandleCount, 'SetHandleCount', CdStdCall);
 S.RegisterDelphiFunction(@GetLogicalDrives, 'GetLogicalDrives', CdStdCall);
 S.RegisterDelphiFunction(@LockFile, 'LockFile', CdStdCall);
 S.RegisterDelphiFunction(@UnlockFile, 'UnlockFile', CdStdCall);
 S.RegisterDelphiFunction(@LockFileEx, 'LockFileEx', CdStdCall);
 S.RegisterDelphiFunction(@UnlockFileEx, 'UnlockFileEx', CdStdCall);
 S.RegisterDelphiFunction(@GetFileInformationByHandle, 'GetFileInformationByHandle', CdStdCall); }


 //mciGetErrorString

//SendMCICommand
 //IPAddrToHostName
 //ApWinExecAndWait32



{ TPSImport_NMEA }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NMEA.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NMEA(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NMEA.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_NMEA(ri);
  RIRegister_NMEA_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
