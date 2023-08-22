unit IFSI_WinForm1puzzle;
{
//Contains most of the win32 specific functions and test functions,  by mX3
//procedure TMyLabel.setLabelEvent(labelclick: TLabel; eventclick: TNotifyEvent);
//more various functions for mainroutine and script language
}
{$I PascalScript.inc}
interface

uses
   SysUtils
  ,Classes
  ,Controls
  ,Forms
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ,Types
  ,Graphics
  ,Windows
  ;
type
  Str002 = string[2];
  Float = Double;
 // The generic type Real, in its current implementation, is equivalent to Double (which maps to Double on .NET).
  Real = Double;
  //Java Types
  Int = Integer;
  Long = Int64;
  LongWord = uInt64;

  TFloatRect = record
                  Left, Top, Right, Bottom: Float;
                end;
  TFloatPoint = record
                  X, Y: Double;
                end; 
  TFloatPointArray = array of TFloatPoint;
  TPointArray = array of TPoint;
  TThreadFunction = function(P: Pointer): Longint; stdcall;
  TByteArray = array[0..255] of byte;
  THexArray = array [0..15] of Char; // = '0123456789ABCDEF';



const
  ChS = '0123456789abcdefghijklmnopqrstuvwxyz';
//var
  WDAYS: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri' , 'Sat'); {do not localize}
  MONTHNAMES: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May'  , 'Jun',  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); {do not localize}
  HexDigits: array [0..15] of Char = '0123456789ABCDEF';    {Do not Localize}
  SeparationCHAR = '.';
  IdHexDigits: array [0..15] of AnsiChar = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'); {do not localize}

var
   STATExecuteShell: Boolean;
   ActVersion: shortstring;
   comp_count: integer;


type
(*----------------------------------------------------------------------------*)
  TPSImport_WinForm1 = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure CompileImport2(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

procedure SearchAndReplace(aStrList: TStrings; aSearchStr, aNewStr: string);
Procedure ExecuteCommand(executeFile, paramstring: string);
procedure SearchAndOpenDoc(vfilenamepath: string);
Function GetUserNameWin: string;
function GetComputerNameWin: string;
procedure Shuffle(vQ: TStringList);
function Max3(const X,Y,Z: Integer): Integer;
function Max(const A, B: Integer): Integer; overload; inline;
//procedure ReverseString(var S: String);
procedure Swap(var X,Y: Char);
//function IntToBin(Int: Integer): String;  from IdGlobal better
function BinToInt(Binary: String): Integer;
function HexToBin2(HexNum: string): string;
function BinToHex2(Binary: String): string;
function HexToInt(hexnum: string): LongInt;
function CharToHexStr(Value: Char): string;
function CharToUniCode(Value: Char): string;
function Hex2Dec(Value: Str002): Byte;
function HexStrToStr(Value: string): string;
function UniCodeToStr(Value: string): string;
procedure playmp3(mp3path: string);
procedure stopmp3;
procedure closemp3;
function lengthmp3(mp3path: string):integer;
function ExePath: string;
function MaxPath: string;

function ExecConsoleApp(const AppName, Parameters: String; AppOutput: TStrings): DWORD;
    {output of child process} {if assigned callon each new line}

//procedure ExecuteThread(afunc: TThreadFunction; var thrOK: boolean);
procedure Move2(const Source: TByteArray; var Dest: TByteArray; Count: Integer);

procedure Diff(var X: array of Double);
function PointDist(const P1,P2: TFloatPoint): Double;
function PointDist2(const P1,P2: TPoint): Double;
// Ensure that Left<=Right and Top<=Bottom
function NormalizeRect(const Rect: TRect): TRect;
// Same as Rect(), but with floating point arguments
function RotatePoint(Point: TFloatPoint; const Center: TFloatPoint; const Angle: Float): TFloatPoint;
function Gauss(const x,Spread: Double): Double;
// Result = V1+V2
function VectorAdd(const V1,V2: TFloatPoint): TFloatPoint;
// Result = V1-V2
function VectorSubtract(const V1,V2: TFloatPoint): TFloatPoint;
// Result = V1·V2
function VectorDot(const V1,V2: TFloatPoint): Double;
// Result = |V|²
function VectorLengthSqr(const V: TFloatPoint): Double;
// Result = V*s
function VectorMult(const V: TFloatPoint; const s: Double): TFloatPoint;


{ compile-time registration functions }
procedure SIRegister_TwinFormp(CL: TPSPascalCompiler);
procedure SIRegister_TMyLabel(CL: TPSPascalCompiler);
procedure SIRegister_WinForm1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TwinFormp(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyLabel(CL: TPSRuntimeClassImporter);
procedure RIRegister_WinForm1(CL: TPSRuntimeClassImporter);


{ compile-time registration functions }
procedure SIRegister_Tdebugoutput(CL: TPSPascalCompiler);
procedure SIRegister_ide_debugoutput(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Tdebugoutput(CL: TPSRuntimeClassImporter);
procedure RIRegister_ide_debugoutput(CL: TPSRuntimeClassImporter);


procedure MAppOnException(sender: TObject; E: Exception);
function myShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: string; ShowCmd: Integer): integer; stdcall;
function myShellExecute2(hwnd: HWND; const FileName: string): integer; stdcall;
function myWinExec(FileName: pchar; ShowCmd: Integer): HINST;
function myGetDriveType(rootpath: pchar): cardinal;
function myBeep2(dwFreq, dwDuration: dword): boolean;
Function GCD(x, y : LongInt) : LongInt;
function LCM(m,n: longint): longint;
function GetASCII: string;
function GetItemHeight(Font: TFont): Integer;
function myPlaySound(s: pchar; flag,syncflag: integer): boolean;
function myGetWindowsDirectory(lpBuffer: PChar; uSize: longword): longword;
function getHINSTANCE: longword;
function getHMODULE: longword;

function getAllocMemCount: integer;
function getAllocMemSize: integer;
function getLongTimeFormat: string;
function getLongDateFormat: string;
function getShortTimeFormat: string;
function getShortDateFormat: string;
function getDateSeparator: char;
function getDecimalSeparator: char;
function getThousandSeparator: char;
function getTimeSeparator: char;
function getlISTSeparator: char;

function ExeFileIsRunning(ExeFile: string): boolean;
function myFindWindow(C1, C2: PChar): Longint;
function myFindControl(handle: Hwnd): TWinControl;
function myShowWindow(C1: HWND; C2: integer): boolean;
Function RegistryRead(keyHandle: Longint; keyPath, myField: String): string;
function GetNumberOfProcessors: longint;
function GetPageSize: Cardinal;
procedure PrintBitmap(aGraphic: TGraphic; Title: string);
function ReadVersion(aFileName : STRING; aVersion : TStrings): boolean; //Draft
//function GetFileVersion(Filename: String): String;
Function StringPad(InputStr,FillChar: String; StrLen:Integer; StrJustify:Boolean): String;
Procedure MinimizeMaxbox;
procedure drawPlot(vPoints: TPointArray; cFrm: TForm; vcolor: integer);
procedure PopupURL(URL : WideString);
procedure DumpComponents(comp: TComponent; list: TStrings);  //3.3
function GetVersionString(FileName: string): string;
// Added by MikeB
procedure LoadFilefromResource(const FileName: string; ms: TMemoryStream);
function GetAssociatedProgram(const Extension: string; var Filename, Description: string): boolean;
procedure FilesFromWildcard(Directory, Mask: string;
  var Files : TStringList; Subdirs, ShowDirs, Multitasking: Boolean);
function Hi1(vdat: word): byte;
function Lo1(vdat: word): byte;
function BinominalCoefficient(n, k: Integer): string;
FUNCTION FormatInt64(i: int64): STRING;
FUNCTION FormatInt(i: integer): STRING;
FUNCTION FormatBigInt(s: string): STRING;
Function GetHexArray(ahexdig: THexArray): THexArray;
Function CharToHex(const APrefix: String; const cc: Char): shortstring;
//Function CharToHex(const APrefix: String; const cc: AnsiChar): shortstring;
function GetMultiN(aval: integer): string;
function PowerBig(aval,n: integer): string;
procedure Split(Str: string;  SubStr: string; List: TStrings);
function Combination(npr, ncr: integer): extended;
function Permutation(npr, k: integer): extended;
function CombinationInt(npr, ncr: integer): Int64;
function PermutationInt(npr, k: integer): Int64;
function MD5(const fileName: string): string;   //crypto hash
function SHA1(const fileName: string): string;
function CRC32H(const fileName: string): LongWord;
function getCmdLine: PChar;
function getCmdShow: Integer;
function FindComponent1(vlabel: string): TComponent;
function FindComponent2(const AName: string): TComponent;
function IsFormOpen(const FormName: string): Boolean;   //3.7.1
function IsInternet: boolean;
function Constrain(x, a, b: integer): integer;
function VersionCheck: boolean;
function TimeToFloat(value:Extended):Extended; // Normalstunden --> Industriestunden
function FloatToTime(value:Extended):Extended; // Industriestunden --> Normalstunden
function FloatToTime2Dec(value:Extended):Extended;
function MinToStd(value:Extended):Extended;
function MinToStdAsString(value:Extended):String;
function RoundFloatToStr(zahl:Extended; decimals:integer):String;
function RoundFloat(zahl:Extended; decimals:integer):Extended;
function Round2Dec (zahl:Extended):Extended;
function GetAngle(x,y:Extended):Double;
function AddAngle(a1,a2:Double):Double;
procedure MovePoint(var x,y:Extended; const angle:Extended);
function microsecondsToCentimeters(mseconds: longint): longint;
function mytimeGetTime: int64;
function mytimeGetSystemTime: int64;
function GetCPUSpeed: Double;


implementation

uses
   Messages
  //,Graphics
  //,Controls
  //,Forms
  ,Dialogs
  ,StdCtrls
  //,ExtCtrls
  ,WinForm1
  ,ide_debugoutput
  ,mmsystem
  ,Math
  ,urlmon
  ,ShellAPI
  ,fMain
  ,mathmax
  ,Registry
  ,Printers
  ,myBigInt
  ,IdHash
  ,IdHashMessageDigest
  ,IdHashSHA1
  ,IdHashCRC
  ,IdGlobal_max
  ,IdHTTP
  ;

  const
   ZAEHLER = 0;
   NENNER  = 1;
   POSIT   = 0;

 // var comp_count: integer;

{function getNetUserName: string;
var
  szVar: array[0..32] of char;
begin
  DBIGetNetUserName(szVar);
  result:= StrPas(@szVar) ;
end;}


{procedure ReadVersion(aFileName: STRING; aVersion : TStrings);
const
  InfoNum = 9;
  InfoStr: array[1..InfoNum] of string = ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright', 'LegalTradeMarks', 'OriginalFileName', 'ProductName', 'ProductVersion');
var
  n, Len, i: DWORD;
  Buf: PChar;
  Value: PChar;
begin
  aVersion.Clear;
  n := GetFileVersionInfoSize(PChar( aFileName), n);
  if n > 0 then begin
    Buf := AllocMem(n);
    GetFileVersionInfo(PChar( aFileName), 0, n, Buf);
    for i := 1 to InfoNum do
    //VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
      if VerQueryValue(Buf, PChar('StringFileInfo\040904E4\'+
                           InfoStr[i]), Pointer(Value), Len) then
        aVersion.Add(InfoStr[i] + '='+ Value)
      else aVersion.Add( InfoStr[i] + '=not found');
    FreeMem(Buf, n);
  end
  else aVersion.Add( 'No Versioninfo defined');
end;}

{function GetFileVersion(Filename: String): String;
var
Major, Minor: Word;
VerInfoSize, VerValueSize, Dummy: DWORD;
VerInfo: Pointer;
VerValue: PVSFixedFileInfo;
begin
VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
GetMem(VerInfo, VerInfoSize);
GetFileVersionInfo(PChar(Filename), 0, VerInfoSize, VerInfo);
if not VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then Result := '' else
with VerValue^ do
begin
Major := dwFileVersionMS shr 16;
Minor := dwFileVersionMS and $FFFF;
Result := IntToStr(Major) + '.' + IntToStr(Minor);
end;
FreeMem(VerInfo, VerInfoSize);
end;}


 function GetCPUSpeed: Double;
  const TimeOfDelay = 500;
  var TimerHigh, TimerLow: DWord;
  begin
    Windows.SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
    Windows.SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
    asm
      dw 310Fh
      mov TimerLow, eax
      mov TimerHigh, edx
    end;
    Sleep(TimeOfDelay);
    asm
      dw 310Fh
      sub eax, TimerLow
      sub edx, TimerHigh
      mov TimerLow, eax
      mov TimerHigh, edx
    end;
    Result:= TimerLow / (1000.0 * TimeOfDelay);
  end;


//timegettime

function mytimeGetTime: int64;
begin
  result:= timeGetTime;
end;

function mytimeGetSystemTime: int64;
begin
  //result:= timeGetSystemTime()  ;
end;


//speed of sound is 340m/s
function microsecondsToCentimeters(mseconds: longint): longint;
begin
  mseconds div 29;
end;

{Anmerkung:
1 Minute = 1.666666 Industrieminuten (0.01 = 0.0166666)
1 Industrieminute = 36 Sekunden      (0.01 = 0.006)
}

function GetAngle(x,y:Extended):Double;
var r:Extended;
begin
  r:=arctan2(y,x); // Winkel in Rad (=Bogenmass d.h. -Pi..+Pi)
  if r<0 then r:=2*pi+r;
  result:=RadToDeg(r); // umwandeln in Degrees (d.h. 0 bis 360 Grad)
end;

function AddAngle(a1,a2:Double):Double;
// 2 Winkel addieren, aber so das das Ergebnis zwischen 0 und 360 Grad bleibt
var s:Extended;
    r:integer;
begin
  s:=a1+a2;
  r:=trunc(s / 360);
  result:=s - (r*360);
end;

procedure MovePoint(var x,y:Extended; const angle:Extended);
var winkel:Double;
    radius:Extended;
begin
  radius:=Sqrt(sqr(x) + sqr(y));
  winkel:=GetAngle(x,y);
  winkel:=AddAngle(winkel,angle);
  winkel:=DegToRad(winkel);
  x:=radius * cos(winkel);
  y:=radius * sin(winkel);
end;


function TimeToFloat(value:Extended):Extended; // Normalstunden --> Industriestunden
// z.B. 1:30 --> 1,5
begin
  result:= system.int(value)+frac(value)/0.6;
end;

function FloatToTime(value:Extended):Extended; // Industriestunden --> Normalstunden
// z.B. 1,5 --> 1:30
begin
  result:= system.int(value)+frac(value)*0.6;
end;

function FloatToTime2Dec(value:Extended):Extended;
// Industriestunden --> Normalstunden auf volle Minuten abgerundet z.B. 1 Ind.min = 36 Sek. --> 0 Minuten
var r1,r2:Extended;
begin
  r1:=system.int(value);
  r2:=frac(value)*60;
  r2:=RoundFloat(r2,6);
  if abs(r2)=60 then begin
     if value>=0 then r1:=r1+1 else r1:=r1-1;
     r2:=0;
  end;
  r2:=system.int(r2)/100;
  result:=r1+r2;
end;

function MinToStd(value:Extended):Extended;
// Normalminuten --> Normalstunden (geht auch mit negativen Werten!)
begin
  result:=(round(value) div 60) + ((round(value) mod 60)/100);
end;

function MinToStdAsString(value:Extended):String;
begin
  result:=format('%.2f',[MinToStd(value)]);
  result:=StringReplace(result,DecimalSeparator,TimeSeparator,[]);
end;

function RoundTime15Minuten(value:Extended):Extended;
// Normalstunden auf volle Viertelstunden ab/aufrunden
var r1:Extended;
    faktor,m:integer;
begin
  if value>=0 then faktor:=1 else faktor:=-1;
  r1:= system.int(value);
  m:=abs(round(frac(value)*100));
  Case m of
    0..7  : result:=r1;
    8..22 : result:=r1+faktor*0.15;
    23..37: result:=r1+faktor*0.30;
    38..52: result:=r1+faktor*0.45;
    53..60: result:=r1+faktor;
    else result:=value; // dürfte aber nicht passieren
  end;
end;

function RoundFloatToStr(zahl:Extended; decimals:integer):String;
begin
  result:=format('%.*f',[decimals,zahl]);
end;

function RoundFloat(zahl:Extended; decimals:integer):Extended;
begin
  result:=StrToFloat(format('%.*f',[decimals,zahl]));
end;

function Round2Dec (zahl:Extended):Extended;
begin
  Result:=StrToFloat(format('%.2f',[zahl]));
end;



function constrain(x, a, b: integer): integer;
begin
 if (x >= a) OR (x <= b) then result:= x;  //just AND
 if x < a then result:= a;
 if x > b then result:= b;
end;


function IsInternet: boolean;
 begin
   if getIPHostbyName(MXINTERNETCHECK) > '0' then
     result:= true
     else result:= false;
 end;

function VersionCheck: boolean;
var idHTTP: TIDHTTP;
     vstring, vstr: string;
     oldsize: byte;
 begin
   result:= false;
   if IsInternet then begin
     idHTTP:= TIdHTTP.Create(NIL);
   try
     vstring:= idHTTP.Get(MXVERSIONFILE);
     actVersion:= vstring;
    //idhttp.get2('http://www.softwareschule.ch/maxbox.htm')
   finally
     idHTTP.Free
   end;
     //insert(vstring, vstr, 3);
     vstr:= vstring;
     vstr:= vstr[1]+vstr[2]+vstr[3];
     if StrToInt(vstr) > StrToInt(MBVER) then begin
       //output.Font.Style:= [fsbold];
       oldsize:= maxForm1.memo2.Font.Size;
         maxform1.memo2.Font.Size:= 14;
         maxForm1.memo2.Lines.Add('!!! New version '+vstr+' available at '+MXSITE);
     Speak(' A new Version of max box is available! ');
     maxform1.memo2.Font.Size:= oldsize;
     end;
     result:= true;
   end;
 end;


function IsFormOpen(const FormName: string): Boolean;
var
  i: Integer; 
begin 
  Result:= False; 
  for i:= Screen.FormCount - 1 DownTo 0 do 
    if (Screen.Forms[i].Name = FormName) then begin 
      Result:= True; 
      Break; 
    end; 
end; 


function FindComponent1(vlabel: string): TComponent;
var i,j: integer;
    c: TComponent;
begin
  for i:= 0 to Application.ComponentCount - 1 do begin
    // all components of a Form
    for j:= 0 to Application.Components[i].ComponentCount - 1 do begin
      c:= Application.Components[i].Components[j];
      if (c is TComponent) and (c.name = vlabel) then begin
        result:= c;
        //writeln('cfinder' +inttostr(j)+ ' '+c.name +' '+ c.classname)
      end;
    end;
  end; 
end;

function FindComponent2(const AName: string): TComponent;
var //FComponents: TList;
   mycomponent: TComponent;
begin
  with TComponent.Create(NIL) do begin
    mycomponent:= FindComponent(aname);
    result:= mycomponent;
    Free;
  end;
{  I: Integer;
begin
  if FComponents = nil then FComponents:= TList.Create;
  if (AName <> '') and (FComponents <> nil) then
    for I := 0 to FComponents.Count - 1 do begin
      Result := FComponents[I];
      if SameText(Result.FName, AName) then Exit;
    end;
  Result := nil;}
end;



function CRC32H(const fileName: string): LongWord;
 var
   myhc: TIdHashCRC32;
   fs: TFileStream;
 begin
   myhc:= TIdHashCRC32.Create;
   fs:= TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite);
   try
     result:= myhc.HashValue(fs)
     //result:= idmd5.AsHex(idmd5.HashValue(fs)) ;
   finally
     fs.Free;
     myhc.Free;
   end;
 end;

function MD5(const fileName: string): string;
 var
   idmd5: TIdHashMessageDigest5;
   fs: TFileStream;
   //hash : T4x4LongWordRecord;
 begin
   idmd5:= TIdHashMessageDigest5.Create;
   fs:= TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
   try
     result:= idmd5.AsHex(idmd5.HashValue(fs)) ;
     //result:= TIdHash128.AsHex(idmd5.HashValue(fileName));
   finally
     fs.Free;
     idmd5.Free;
   end;
 end;

{uses SysUtils, IdGlobal, IdHash, IdHashMessageDigest;
with TIdHashMessageDigest5.Create do
try
    Result := TIdHash128.AsHex(HashValue('Hello, world'));
finally
    Free;
end;}


function SHA1(const fileName: string): string;
 var
   idmd5 : TIdHashSHA1;
   fs : TFileStream;
   //hash : T5x4LongWordRecord;
 begin
   idmd5:= TIdHashSHA1.Create;
   fs:= TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
   try
     //hash:= idmd5.hashvalue(fs)
     //result := idmd5.AsHex(hash) ;
     result:= idmd5.AsHex(idmd5.HashValue(fs)) ;
   finally
     fs.Free;
     idmd5.Free;
   end;
 end;



function Combination(npr, ncr: integer): extended;
begin
  result:= (Fact(npr)/Fact(npr-ncr)/Fact(ncr));
end;

function Permutation(npr, k: integer): extended;
//2. Permutation(Variation without repeating) = nPr = n!/(n-k)!
begin
  result:= (Fact(npr)/Fact(npr-k));
  //test 4 of 10 = 5040 = NPR(10,4)
end;

function CombinationInt(npr, ncr: integer): Int64;
begin
  result:= Round(Fact(npr)/Fact(npr-ncr)/Fact(ncr));
end;

function PermutationInt(npr, k: integer): Int64;
//2. Permutation(Variation without repeating) = nPr = n!/(n-k)!
begin
  result:= Round(Fact(npr)/Fact(npr-k));
  //test 4 of 10 = 5040 = NPR(10,4)
end;

procedure Split(Str: string;  SubStr: string; List: TStrings);
var
  I: Integer;
  S, Tmp: string;
begin
  List.Clear;
  S:= Str;
  while Length(S) > 0 do begin
    I:= Pos(SubStr, S);
    if I = 0 then begin
      List.Add(S);
      S:= '';
    end
    else begin
      if I = 1 then begin
        List.Add('');
        Delete(S, 1, Length(SubStr));
      end else begin
        Tmp:= S;
        Delete(Tmp, I, Length(Tmp));
        List.Add(Tmp);
        Delete(S, 1, I + Length(SubStr) - 1);
        if Length(S) = 0 then
          List.Add('');
      end;
    end;
  end;
end;

function PowerBig(aval,n: integer): string;
  //unit mybigint
var mbResult: TMyBigInt;
     i,z: integer;
begin
  //mbResult:= TMyBigInt.Create(2000000000);
  mbResult:= TMyBigInt.Create(1);
  try
     for i:= 1  to n do
       mbResult.Multiply(mbresult, aval);
     Result:= mbResult.ToString;
   //end;    
  finally 
    //FreeAndNil(mbResult);
    mbResult.Free;
  end;
end;

function GetMultiN(aval: integer): string;
  //unit mybigint
var mbResult: TMyBigInt;
     i,z: integer;
begin
  //mbResult:= TMyBigInt.Create(2000000000);
  mbResult:= TMyBigInt.Create(1);
  try
     for i:= 1  to aval do
       mbResult.Multiply(mbresult, aval);
     Result:= mbResult.ToString;
   //end;    
  finally 
    //FreeAndNil(mbResult);
    mbResult.Free;
  end;
end;

Function CharToHex(const APrefix : String; const cc : Char): shortstring;
begin
  SetLength(Result,2);
  Result[1]:= Hexdigits[ord(cc) shr 4];
  Result[2]:= HexDigits[ord(cc) AND $0F];
  Result := APrefix + Result;
end;

//function GetHexArray(var ahexdig: THexArray): THexArray;
function GetHexArray(ahexdig: THEXArray): THexArray;
  var i: byte;
  begin
   for i:= 0 to 9 do
     ahexdig[i]:= chr(i+48);  //of 48
   for i:= 10 to 15 do
     ahexdig[i]:= chr(i+55);  //of 65
   //= '0123456789ABCDEF';
   result:= ahexdig;
end;

FUNCTION FormatInt64(i: int64): STRING;
VAR
  j : INTEGER;
BEGIN
  Result := IntToStr(i);
  j := 3;
  WHILE Length(Result) > j DO BEGIN
    Insert(SeparationChar,
           Result,
           Length(Result) - j + 1);
    //Inc(j,4);
    j:= j+4;
  END;
END;


FUNCTION FormatInt(i: integer): STRING;
VAR
  j : INTEGER;
BEGIN
  Result := IntToStr(i);
  j := 3;
  WHILE Length(Result) > j DO BEGIN
    Insert(SeparationChar,
           Result,
           Length(Result) - j + 1);
    //Inc(j,4);
    j:= j+4;
  END;
END; 


FUNCTION FormatBigInt(s: string): STRING;
VAR
  j : INTEGER;
BEGIN
  Result:= s;
  j := 3;
  WHILE Length(Result) > j DO BEGIN
    Insert(SeparationChar,
           Result,
           Length(Result) - j + 1);
    //Inc(j,4);
    j:= j+4;
  END;
END; 


function ggT(x, y: Integer): Integer;
begin
  if y > x then Result := ggT(y, x)
  else if y = 0 then Result := x
  else
    Result := ggT(y, x mod y);
end;


function BinominalCoefficient(n, k: Integer): string;
var 
  m, i, j, iGgT: Integer;
  arBruch: array[0..1] of array of Integer;
  mbResult: TMyBigInt;
begin
  //"n-k" soll kleiner als "k" sein, gilt wegen Symmetrie des BinomKoeff. im Nenner
  if (n - k) > k then k := n - k;
  m := n - k;

  // Initialisierung der Variablen
  for i := Low(arBruch) to High(arBruch) do SetLength(arBruch[i], m + 1);
  // Setzen der gebliebenen Faktoren, "nur" n-k Faktoren sind wichtig
  for i:= 1 to m do begin
    arBruch[zaehler][i] := i + k;
    arBruch[nenner][i]  := i;
  end;
  arBruch[zaehler][Posit] := 1; // max{m+1: arBruch[zaehler][i]=1 für alle i=1...m}
  arBruch[nenner][Posit]  := 2; // max{m+1: arBruch[nenner][i]=1 für alle i=1...m}
  while arBruch[nenner][Posit] <= m do begin
    for i := m downto arBruch[nenner][Posit] do begin
      for j := m downto arBruch[zaehler][Posit] do begin
        // Bestimmung des ggTs
        iGgT := ggT(arBruch[nenner][i], arBruch[zaehler][j]);
        if iGgT > 1 then begin
          // Kürzen
          arBruch[zaehler][j] := Round(arBruch[zaehler][j] / iGgT);
          arBruch[nenner][i]  := Round(arBruch[nenner][i] / iGgT);
          if arBruch[nenner][i] = 1 then break;
        end;
      end;
      // Verschieben der Position im Zaehler
      for j:= arBruch[zaehler][Posit] to m do
        if arBruch[zaehler][j] = 1 then arBruch[zaehler][Posit] := j + 1
      else
        break;
    end;
    // Verschieben der Position im Nenner
    for i:= arBruch[nenner][Posit] to m do
      if arBruch[nenner][i] = 1 then arBruch[nenner][Posit] := i + 1
    else
      break;
  end;
  //unit mybigint
  mbResult:= TMyBigInt.Create(1);
  try
    // Faktoren im Zaehler aufmultiplizieren
    for i:= arBruch[zaehler][Posit] to m do 
             mbResult.Multiply(mbResult, arBruch[zaehler][i]);
    Result:= mbResult.ToString;
  finally 
    //FreeAndNil(mbResult);
    mbResult.Free;
  end;
end;


function Hi1(vdat: word): byte;
var ahi: word;
  begin
    //hi(vdat)
    // hi and lo function (see below)
    ahi:= vdat shr 8;
    //alo:= w and $FF;
    result:= ahi;
  end;

function Lo1(vdat: word): byte;
var ahi, alo: word;
  begin
    //ahi:= vdat shr 8;
    alo:= vdat and $FF;
    result:= alo;
  end;

procedure FilesFromWildcard(Directory, Mask: String;
  var Files : TStringList; Subdirs, ShowDirs, Multitasking: Boolean);
var
  SearchRec: TSearchRec;
  Attr, Error: Integer;
begin
  Directory := IncludeTrailingPathDelimiter(Directory);

  { First, find the required file... }
  Attr := faAnyFile;
  if ShowDirs = False then
     Attr := Attr - faDirectory;
  Error := FindFirst(Directory + Mask, Attr, SearchRec);
  if (Error = 0) then begin
     while (Error = 0) do begin
     { Found one! }
        Files.Add(Directory + SearchRec.Name);
        Error := FindNext(SearchRec);
        if Multitasking then
           Application.ProcessMessages;
     end;
     SysUtils.FindClose(SearchRec);
  end;

  { Then walk through all subdirectories. }
  if Subdirs then begin
     Error := FindFirst(Directory + '*.*', faAnyFile, SearchRec);
     if (Error = 0) then begin
        while (Error = 0) do begin
           { Found one! }
           if (SearchRec.Name[1] <> '.') and (SearchRec.Attr and
             faDirectory <> 0) then
              { We do this recursively! }
              FilesFromWildcard(Directory + SearchRec.Name, Mask, Files,
                Subdirs, ShowDirs, Multitasking);
           Error := FindNext(SearchRec);
        end;
     SysUtils.FindClose(SearchRec);
     end;
  end;
end;


function GetAssociatedProgram(const Extension: string; var Filename, Description: string): boolean;
const
  NOVALUE = '$__NONE__$';
var
  R: TRegIniFile;
  Base, S: string;
begin
  Result:=False;
  R:=TRegIniFile.Create;
  try
    R.RootKey:=HKEY_CLASSES_ROOT;
    Base:=R.ReadString(Extension, '', NOVALUE);
    if S=NOVALUE then
      Exit;
    S:=R.ReadString(Base+'\shell\open\command', '', NOVALUE);
    if S=NOVALUE then
      Exit;
    Filename:=S; // filename probably contains args, e.g. Filename='"some where\my.exe" "%1"'

    Description:=ExtractFilename(S);
    Result:=True;
    S:=R.ReadString(Base+'\shell\open\ddeexec\application', '', NOVALUE);
    if S=NOVALUE then
      Description:='Default application'
    else
      Description:=S;
    if S='DEVCPP' then // avoid extensions registered to DevCpp ;)
      Result:=False;
  finally
    R.Free;
  end;
end;



procedure LoadFilefromResource(const FileName: string; ms: TMemoryStream);
var
 HResInfo: HRSRC;
 hRes: THandle;
 Buffer: PChar;
 aName, Ext: string;
begin
  Ext:= ExtractFileExt(FileName);
  Ext:= copy(ext, 2, length(ext));
  aName:= ChangeFileExt(ExtractFileName(FileName), '');
  HResInfo:= FindResource(HInstance, pchar(aName), pchar(Ext));
  hres:= LoadResource(HInstance, HResInfo);
  if HRes = 0 then begin
     MessageBox(Application.MainForm.Handle,
       PChar(Format('Lang[ID_ERR_RESOURCE]', [FileName, aName, Ext])),
       PChar('[ID_ERROR]'), MB_OK or MB_ICONERROR);
     exit;
   end;

  Buffer:= LockResource(HRes);
  ms.clear;
  ms.WriteBuffer(Buffer[0], SizeofResource(HInstance, HResInfo));
  ms.Seek(0, 0);
  UnlockResource(HRes);
  FreeResource(HRes);
end;


function ComponentFullName(comp: TComponent): string;
var
  mycomp: TComponent;
begin
  result:= comp.Name;
   //if no component name then at least an index
  if result = '' then
    result:= '#'+IntToStr(comp.ComponentIndex);
  mycomp:= comp;
  //to the top of the owner
  while mycomp.Owner <> NIL do begin
    mycomp:= mycomp.Owner;
    if Length(mycomp.Name) > 0 then
      result:= mycomp.Name+'.'+result;
  end;
end;

function ComponentFullNameAndClass(comp: TComponent): string;
begin
  Result:= ComponentFullName(comp)+': '+comp.Classname;
end;

procedure DumpComponents(comp: TComponent; list: TStrings);
var
  i: Integer;
  fi: boolean;
begin
  //fi:= false;
  //if fi then
  //  comp_count:= 0;
  if Assigned(comp) then begin
    list.Add('lid: '+inttostr(i)+ '  '+'cid:  '+ inttostr(comp_count)+
                    '  '+ComponentFullNameAndClass(comp));
    inc(comp_count);
    //fi:= true;
    for i:= 0 to comp.ComponentCount-1 do begin
      //recursion!
      DumpComponents(comp.Components[i], list);
    end;
  end;
end;


procedure PopupURL(URL: WideString);
begin
  if HLinkNavigateString(NIL, PWideChar(URL)) <> S_OK then
    if ShellExecute(0,'open','firefox.exe',PChar((URL)),nil,SW_SHOWNORMAL) <= 32 then
      if ShellExecute(0,'open','iexplore.exe',PChar((URL)),nil,SW_SHOWNORMAL) <= 32 then
        Application.MessageBox(PChar('Failed to launch default browser, go to '+URL+' at yours.'),'not launch browser...',0);
end;

procedure drawPlot(vPoints: TPointArray; cFrm: TForm; vcolor: integer);
var
  i, hsize: integer;
begin
  with cFrm.canvas do begin
    hsize:= cFrm.Height -1 div 2;
    Pen.Color:= vcolor;
    MoveTo(0, hsize -((round(vPoints[0].Y))));
    for i:= 0 to High(vPoints) do
      LineTo(i, round(vPoints[i].Y));
  end;
end;


Procedure MinimizeMaxbox;
begin
  //maxform1.Height:= 0;
  //maxform1.width:= 100;
  Application.Minimize;
end;

Function StringPad(InputStr, FillChar: String; StrLen: Integer;
   StrJustify: Boolean): String;
Var
   TempFill: String;
   Counter : Integer;
Begin
   If Not (Length(InputStr) = StrLen) Then Begin
     If Length(InputStr) > StrLen Then Begin
       InputStr := Copy(InputStr,1,StrLen) ;
     End
     Else Begin
       TempFill := '';
       For Counter := 1 To StrLen-Length(InputStr) Do Begin
         TempFill := TempFill + FillChar;
       End;
       If StrJustify Then Begin
         {Left Justified}
         InputStr := InputStr + TempFill;
       End
       Else Begin
         {Right Justified}
         InputStr := TempFill + InputStr ;
       End;
     End;
   End;
   Result:= InputStr;
End;

Function ReadVersion(aFileName: STRING; aVersion : TStrings):boolean;
const
   InfoNum = 11;
   InfoStr : array [1..InfoNum] of String =
     ('CompanyName', 'FileDescription', 'FileVersion',
'InternalName', 'LegalCopyright', 'LegalTradeMarks',
'OriginalFilename', 'ProductName', 'ProductVersion',
'Comments', 'Author') ;
   LabelStr : array [1..InfoNum] of String =
     ('Company Name', 'Description', 'File Version',
'Internal Name', 'Copyright', 'TradeMarks',
'Original File Name', 'Product Name',
'Product Version', 'Comments', 'Author') ;
var
   //S : String;
   n, Len, j : DWord;
   Buf : PChar;
   Value : PChar;
begin
   Try
     //S := Application.ExeName;
     aVersion.Clear;
     //aVersion.Sorted:= True;
     n:= GetFileVersionInfoSize(PChar(aFileName),n);
     If n > 0 Then Begin
       Buf := AllocMem(n) ;
       aVersion.Add(StringPad('Size',' ',20,True)+' = '+IntToStr(n)) ;
       GetFileVersionInfo(PChar(aFilename),0,n,Buf) ;
       For j:=1 To InfoNum Do Begin
        If VerQueryValue(Buf,PChar('StringFileInfo\040904E4\'+
                         InfoStr[j]),Pointer(Value),Len) Then Begin
         //If VerQueryValue(Buf,pchar('\'+InfoStr[j]),Pointer(Value),Len) Then Begin
           Value:= PChar(Trim(Value)) ;
           If Length(Value) > 0 Then Begin
             aVersion.Add(StringPad(labelStr[j],' ',20,True)+' = '+Value);
           End;
         End;
       End;
       FreeMem(Buf,n) ;
     End Else Begin
       aVersion.Add('No FileVersionInfo found') ;
     End;
     Result := True;
   Except
     Result := False;
   End;
End;

function GetVersionString(FileName: string): string;
var
  Buf: Pointer;
  i: cardinal;
  P: pointer;
  pSize: cardinal;
  ffi: TVSFixedFileInfo;
begin
  Result := '';
  i := GetFileVersionInfoSize(PChar(FileName), i);
  if i = 0 then
    Exit;

  Buf := AllocMem(i);
  try
    if not GetFileVersionInfo(PChar(FileName), 0, i, Buf) then
      Exit;

    pSize := SizeOf(P);
    VerQueryValue(Buf, '\', p, pSize);

    ffi := TVSFixedFileInfo(p^);
    Result := Format('%d.%d.%d.%d', [
      HiWord(ffi.dwFileVersionMS),
        LoWord(ffi.dwFileVersionMS),
        HiWord(ffi.dwFileVersionLS),
        LoWord(ffi.dwFileVersionLS)]);
  finally
    FreeMem(Buf);
  end;
end;


procedure PrintBitmap(aGraphic: TGraphic; Title: string);
begin
  Printer.Title:= Title;
  //Printer.Printers;
  Printer.Orientation:= poLandscape;
  Printer.BeginDoc;
  //aGraphic.Height:= Printer.PageHeight;
  //aGraphic.Width:= Printer.PageWidth;
  Printer.Canvas.Draw(0,0, aGraphic);
  Printer.EndDoc;
end;

//-----------------------------------------map of system vars -------------------

function getCmdLine: PChar;
begin
  result:= System.CmdLine;
end;

function getCmdShow: Integer;
begin
  result:= System.CmdShow;
end;


function getAllocMemCount: integer;
begin
  result:= AllocMemCount;
end;

function getAllocMemSize: integer;
begin
 result:= AllocMemSize;
end;


function getHINSTANCE: longword;
begin
 result:= HINSTANCE;
end;

function getHMODULE: longword;
begin
 result:= system.HMODULE(HINSTANCE);
end;


function getLongTimeFormat: string;
begin
 result:= LongTimeFormat;
end;

function getLongDateFormat: string;
begin
 result:= LongDateFormat;
end;

function getShortTimeFormat: string;
begin
 result:= LongTimeFormat;
end;

function getShortDateFormat: string;
begin
 result:= LongDateFormat;
end;

function getDateSeparator: char;
begin
 result:= DateSeparator;
end;

function getDecimalSeparator: char;
begin
 result:= DecimalSeparator;
end;

function getThousandSeparator: char;
begin
 result:= ThousandSeparator;
end;

function getTimeSeparator: char;
begin
 result:= TimeSeparator;
end;

function getListSeparator: char;
begin
 result:= ListSeparator;
end;


function myFindWindow(C1, C2: PChar): Longint;
begin
  result:= FindWindow(C1, C2);
end;

function myFindControl(handle: Hwnd): TWinControl;
begin
  result:= Controls.FindControl(Handle);
end;

function myShowWindow(C1: hwnd; C2: integer): boolean;
begin
  result:= ShowWindow(C1, C2);
end;

function ExeFileIsRunning(ExeFile: string): boolean;
var
  H: word;
begin
  H:= CreateFile(PChar(ExeFile), GENERIC_READ, 0, NIL, OPEN_EXISTING, 0, 0);
  Result:= (H >= 65535);
  CloseHandle(H);
end;

Function RegistryRead(keyHandle: Longint; keyPath, myField: String): string;
begin
//Create the Object
  with (TRegistry.Create(KEY_READ)) do begin //als Instanz
    RootKey:= keyHandle;//HKEY_LOCAL_MACHINE;
    if OpenKey(keyPath, false) then begin
      if ValueExists(myField) then
        result:= ReadString(myField) else
      ShowMessage(myField+' does not exists under '+keyPath);
  end else
    ShowMessage('Error opening/read key : '+keyPath);
    CloseKey;
    Free;
  end; //with
end;

function GetNumberOfProcessors: longint;
var
  SystemInfo: TSystemInfo;
begin
  GetSystemInfo(SystemInfo);
  Result:= SystemInfo.dwNumberOfProcessors;
end;

function GetPageSize: Cardinal;
var
  SystemInfo: TSystemInfo;
begin
  GetSystemInfo(SystemInfo);
  Result:= SystemInfo.dwPageSize;
end;


function GetItemHeight(Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Result := Metrics.tmHeight;
end;


Function GCD(x, y : LongInt) : LongInt;
{ The greatest common denominator (GCD) is the largest positive integer
 that divides into both numbers without a remainder.
 Examples: GCD(256,64)=64, GCD(12,8)=4, GCD(5,3)=1 }
Var
  g : LongInt;
Begin
   { Work with absolute values (positive integers) }
   If x < 0 Then x := -x;
   If y < 0 Then y := -y;

   If x + y > 0 Then Begin
    g := y;
    { Iterate until x = 0 }
    While x > 0 Do Begin
     g := x;
     x := y Mod x;
     y := g;
    End;
    result:= g;
   End Else Begin
    { Error, both parameters zero }
    result:= 0;
   End;
End;

function LCM(m,n:longint):longint;
begin
  result:= (m*n) div GCD(m,n);
end;

function myPlaySound(s: pchar; flag,syncflag: integer): boolean;
begin
  result:= PlaySound(s, flag, syncflag);
  //queryperformancecounter
end;

function GetASCII: string;
var i: integer;
begin
  for i:= 1 to 255 do
  result:= result +#13#10+ Format('This Number: %4d is this ASCII %2s',[i, Chr(i)])
end;

function myGetWindowsDirectory(lpBuffer: PChar; uSize: longword): longword;
begin
  result:= GetWindowsDirectory(lpBuffer, uSize);
end;


procedure SearchAndReplace(aStrList: TStrings; aSearchStr, aNewStr: string);
var i, t1: integer;
    s1: string;
begin
  // old string can't be part of new string!, eg.: max --> climax
  if pos(aSearchStr, aNewStr) > 0 then begin
    write('old string cant be part of new string');
    exit;
  end;
  for i:= 0 to aStrList.Count -1 do begin
    s1:= aStrList[i];
    repeat
      t1:= pos(aSearchStr, s1);
      if t1 > 0 then begin
        Delete(s1, t1, Length(aSearchStr));
        Insert(aNewStr, s1, t1);
        aStrList[i]:= s1;
      end;
    until t1 = 0;
  end; 
end;

procedure MAppOnException(sender: TObject; E: Exception);
var
  Addr: string[64];
  FErrorLog: System.Text;
  FileNamePath, userName: string;
  userNameLen: dWord;
  mem: TMemoryStatus;
begin
  //writes errorlog.txt file
  mem.dwLength:= sizeOf(TMemoryStatus);
  GlobalMemoryStatus(mem);
  UserNameLen := 255;
  SetLength(userName, UserNameLen);
  FileNamePath:= extractFilePath(application.exeName) + EXCEPTLOGFILE;
  AssignFile(FErrorLog, FileNamePath);
  try
    System.Append(FErrorlog);
  except
    on EInOutError do Rewrite(FErrorLog);
  end;
  Addr:= inttoStr(mem.dwAvailPageFile div 1024) + 'pgf; mem:'
               +inttoStr(mem.dwAvailPhys div 1024);
  Writeln(FErrorLog, Format('%s %s [%s] %s %s [%s]',[DateTimeToStr(Now),'V:'+MBVERSION,
          getUserNameWin, getComputerNameWin, E.Message,'at:  '+Addr]));
  System.Close(FErrorLog);
  MessageDlg(MBVERSION +' '+E.Message +'. occured at: '+Addr,mtError,[mbOK],0);
  //MessageBox(0, pChar(MBVERSION +' '+E.Message +'. occured at: '+Addr), 'ExceptionLog', MB_OKCANCEL)
end;


// HINST = THandle = LongWord;
function myShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: string; ShowCmd: Integer): integer; stdcall;
begin
  result:= ShellExecute(hwnd, pchar(NIL), pchar(FileName),
                         pchar(Parameters), pchar(Directory), showCmd);
  //ShellExecute(Handle, Operation, FileName, Params, Folder, ShowCmd)
end;

function myShellExecute2(hwnd: HWND; const FileName: string): integer; stdcall;
begin
  result:= ShellExecute(hwnd, pchar(NIL), NIL, pchar(FileName), NIL, sw_ShowNormal);
  //shellexecute(0, pchar('open'), 'notepad', 'cryptofiles2.txt', NIL, 2);
  //ShellExecute(HInstance, 'open'NIL, pchar(FileName), NIL, NIL, sw_ShowNormal);
end;

  //rslt := ShellExecute(0, 'open', pChar (theProgram),
  //pChar (itsParameters), pChar (defaultDirectory), sw_ShowNormal);

function myWinExec(FileName: pchar; ShowCmd: Integer): HINST;
begin
  result:= Windows.winExec(FileName, SW_SHOW);
end;

function myGetDriveType(rootpath: pchar): cardinal;
begin
  result:= GetDriveType((rootpath));
end;

function myBeep2(dwFreq, dwDuration: dword): boolean;
begin
  result:= Beep(dwFreq, dwDuration);
end;


procedure ExecuteThread(afunc: TThreadFunction; var thrOK: boolean);
var
  thr: THandle;
  thrID: Dword;
begin
  thr:= createThread(NIL, 0, @afunc, NIL, 0, thrID);
  if (thr=0) then thrOK:= true;

end;

procedure Move2(const Source: TByteArray; var Dest: TByteArray; Count: Integer);
begin
  Move(Source, Dest, Count);
end;

Procedure ExecuteCommand(executeFile, paramstring: string);
var
    SEInfo: TShellExecuteInfo;
    ExitCode: DWORD;
    //StartInString: string;
 begin
    FillChar(SEInfo, SizeOf(SEInfo), 0) ;
    SEInfo.cbSize:= SizeOf(TShellExecuteInfo) ;
    with SEInfo do begin
      fMask:= SEE_MASK_NOCLOSEPROCESS;
      Wnd:= Application.Handle;
      lpFile:= PChar(ExecuteFile) ;
 //ParamString contains app parameters.
  lpParameters:= PChar(ParamString) ;
 {
 StartInString specifies the name of the working directory.
 If ommited, the current directory is used. }
 // lpDirectory := PChar(StartInString) ;
      nShow:= SW_SHOWNORMAL;
    end;
    if STATExecuteShell then begin
      if ShellExecuteEx(@SEInfo) then begin
       repeat
        Application.ProcessMessages;
        GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
      until (ExitCode <> STILL_ACTIVE) or
                   	 Application.Terminated;
      //for security reason to control what happens
     maxForm1.memo2.Lines.Add('MessageBox: Shell Terminated mX3 command at: '+
                                    DateTimeToStr(Now));
    end
     end
     else MessageBox(0,pchar('Error Starting Shell'),pchar('mX3 command'),MB_OKCANCEL);
     maxForm1.memo2.Lines.Add('Execute Shell Commands could protect in ini-File!')
 end;



function ExecConsoleApp(const AppName, Parameters: String; AppOutput: TStrings): DWORD;
                        //OnNewLine: TNotifyEvent
{we assume that child process requires no input. I have not thought about the
possible consequences of this assumption. I expect we could come up with some
sort of tricky console IO thingy - but we would need to either run an auxilliary
thread or process win messages somewhere.
This function returns exit code of child process (normally 0 for no error)
If the function returns STILL_ACTIVE ($00000103) then the ReadLoop
has terminated before app has finished executing. See comments in body of function}

const
  CR = #$0D;
  LF = #$0A;
  TerminationWaitTime = 5000;
  ExeExt = '.EXE';
  ComExt = '.COM'; {the original dot com}

var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecAttrib: TSecurityAttributes;
  TempHandle,
  WriteHandle,
  ReadHandle: THandle;
  ReadBuf: array[0..2 (* $100*)] of Char;
  BytesRead: Cardinal;
  LineBuf: array[0..$100] of Char;
  LineBufPtr, i: Integer;
  Newline: Boolean;
  BinType, SubSyst: DWORD;
  Ext, CommandLine: String;
  AppNameBuf: array[0..MAX_PATH] of Char;
  ExeName: PChar;

{$IFDEF DEBUG}
  ReadCount: Integer;
  StartExec,
  EndExec,
  PerfFreq: Int64;
{$ENDIF}

procedure OutputLine;
begin
  LineBuf[LineBufPtr]:= #0;
  with AppOutput do
  if Newline then
    Add(LineBuf)
  else
    Strings[Count-1]:= LineBuf; {should never happen with count = 0}
  Newline:= false;
  LineBufPtr:= 0;
  //if Assigned(OnNewLine) then //OnNewLine(AppOutput)
  {there is no reasonable justification for passing AppOutput as self,
  but I don't have anything else to send, and I fancied using TNotifyEvent}
end;

begin
  {Find out about app}
  Ext:= UpperCase(ExtractFileExt(AppName));
  if (Ext = '.BAT') or ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Ext = '.CMD')) then begin
    {just have a bash}
    FmtStr(CommandLine, '"%s" %s', [AppName, Parameters])
  end else
  if (Ext = '') or (Ext = ExeExt) or (Ext = ComExt) then  {locate and test the application}
  begin
    if SearchPath(nil, PChar(AppName), ExeExt, SizeOf(AppNameBuf), AppNameBuf, ExeName) = 0 then
      raise EInOutError.CreateFmt('Could not find file %s', [AppName]);
    if Ext = ComExt then
      BinType:= SCS_DOS_BINARY
    else
      //GetExecutableInfo(AppNameBuf, BinType, SubSyst);
    if ((BinType = SCS_DOS_BINARY) or (BinType = SCS_WOW_BINARY)) and
        (Win32Platform = VER_PLATFORM_WIN32_NT) then
      FmtStr(CommandLine, 'cmd /c""%s" %s"', [AppNameBuf, Parameters])
    else
    if (BinType = SCS_32BIT_BINARY) and (SubSyst = IMAGE_SUBSYSTEM_WINDOWS_CUI) then
      FmtStr(CommandLine, '"%s" %s', [AppNameBuf, Parameters])
    else
      raise EInOutError.Create('Exe image is not a supported type')
            {Supported types are Win32 Console or MSDOS under Windows NT only}
  end else
    raise EInOutError.CreateFmt('%s has invalid file extension', [AppName]);

  FillChar(StartupInfo,SizeOf(StartupInfo), 0);
  FillChar(ReadBuf, SizeOf(ReadBuf), 0);
  FillChar(SecAttrib, SizeOf(SecAttrib), 0);
{$IFDEF DEBUG}
  ReadCount:= 0;
  if QueryPerformanceFrequency(PerfFreq) then
    QueryPerformanceCounter(StartExec);
{$ENDIF}
  LineBufPtr:= 0;
  Newline:= true;
  with SecAttrib do begin
    nLength:= Sizeof(SecAttrib);
    bInheritHandle:= true
  end;
  if not CreatePipe(ReadHandle, WriteHandle, @SecAttrib, 0) then
    RaiseLastOSError;
  {create a pipe to act as StdOut for the child. The write end will need
   to be inherited by the child process}
  try
    {Read end should not be inherited by child process}
    if Win32Platform = VER_PLATFORM_WIN32_NT then begin
      if not SetHandleInformation(ReadHandle, HANDLE_FLAG_INHERIT, 0) then
        RaiseLastOSError
    end else begin
      {SetHandleInformation does not work under Window95, so we
      have to make a copy then close the original}
      if not DuplicateHandle(GetCurrentProcess, ReadHandle,
        GetCurrentProcess, @TempHandle, 0, True, DUPLICATE_SAME_ACCESS) then
        RaiseLastOSError;
      CloseHandle(ReadHandle);
      ReadHandle:= TempHandle
    end;

    with StartupInfo do begin
      cb:= SizeOf(StartupInfo);
      dwFlags:= STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      wShowWindow:= SW_HIDE;
      hStdOutput:= WriteHandle
    end;
    {StartupInfo provides additional parameters to CreateProcess.
    I suspect that it is only safe to pass WriteHandle as hStdOutput
    because we are going to make sure that the child inherits it.
    This is not documented anywhere, but I am reasonably sure it is
    correct. It is (mildly) interesting to note that the example
    given in Win32.hlp "Creating a Child process with redirected
    input and output" does not set the 'StdHandle' fields of StartupInfo.
    Instead the parent process sets its own StdInput and StdOutput
    handles prior to creating the child process - Apparently, the child
    process will then use these values. It all seems a bit odd,
    given that a much simpler mechanism (Handle fields of StartupInfo)
    seems to have been provided. Anyway, this alternative approach does
    not seem to work when the parent process is GUI-based. Perhaps Windows
    ignores SetStdHandle for a GUI app.

    We should not have to use STARTF_USESHOWWINDOW and
    wShowWindow:= SW_HIDE as we are going to tell CreateProcess not to
    bother with an output window, but it would appear that Windows 95
    ignores the CREATE_NO_WINDOW flag. Fair enough - it is not in the SDK
    documentation (I got it out of Richter). CREATE_NO_WINDOW actually makes
    virtually no difference to the execution time of my 'hello world' test
    program, but it seems the correct thing to do.

    I shouldn't bother with the DETACHED_PROCESS flag. I suspect that it is
    only relevant when the calling process is a console app.}

    if not CreateProcess(nil, PChar(CommandLine), nil, nil, true,
          {inherit kernel object handles from parent}
       CREATE_NO_WINDOW,
       nil, nil,
       StartupInfo,
       ProcessInfo) then
     RaiseLastOSError;

    CloseHandle(ProcessInfo.hThread);
    {not interested in threadhandle - close it}

    CloseHandle(WriteHandle);
    {close our copy of Write handle - Child has its own copy now. It is important
    to close ours, otherwise ReadFile may not return when child closes its
    StdOutput - this is the mechanism by which the following loop detects the
    termination of the child process: it does not poll GetExitCodeProcess.

    "To read from the pipe, a process uses the read handle in a call to the
    ReadFile function. When a write operation of any number of bytes completes,
    the ReadFile call returns. The ReadFile call also returns when all handles
    to the write end of the pipe have been closed or if any errors occur before
    the read operation completes normally."
    On this basis (and going somewhat beyond that stated above) I have assumed that
    ReadFile will return TRUE when a write is completed at the other end of the pipe
    and will return FALSE when the write handle is closed at other end.
    I have also assumed that ReadFile will return when its output buffer is full
    regardless of the size of the write at the other end.}

    try
      while ReadFile(ReadHandle, ReadBuf, SizeOf(ReadBuf), BytesRead, nil) do begin
        {There are much more efficient ways of doing this: we don't really
        need two buffers, but we do need to scan for CR & LF &&&}
{$IFDEF Debug}
        Inc(ReadCount);
{$ENDIF}
        for  i:= 0 to BytesRead - 1 do begin
          if (ReadBuf[i] = LF) then begin
            OutputLine;
            Newline:= true;
          end else
          if (ReadBuf[i] = CR) then begin
            OutputLine;
          end else begin
            LineBuf[LineBufPtr]:= ReadBuf[i];
            Inc(LineBufPtr);
            if LineBufPtr >= (SizeOf(LineBuf) - 1) then begin
              Newline:= true;
              OutputLine;
            end
          end
        end
      end;
      WaitForSingleObject(ProcessInfo.hProcess, TerminationWaitTime);
      {The child process may have closed its StdOutput handle but not yet
      terminated, so will wait for up to five seconds to give it a chance to
      terminate. If it has not done so after this time, then we will end
      up returning STILL_ACTIVE ($103)

      If you don't care about the exit code of the process, then you don't
      need this wait: having said that, unless the child process has a
      particularly longwinded cleanup routine, the wait will be very short
      in any event. I recommend you leave this wait in place unless you have an intimate
      understanding of the child process you are spawining and are sure you
      don't want to wait for it}

      GetExitCodeProcess(ProcessInfo.hProcess, Result);
      OutputLine {flush line buffer}

{$IFDEF DEBUG} ;
      if PerfFreq > 0 then begin
        QueryPerformanceCounter(EndExec);
        AppOutput.Add(Format('Debug: (readcount = %d), ExecTime = %.3f ms',
          [ReadCount, ((EndExec - StartExec)*1000.0)/PerfFreq]))
      end else begin
        AppOutput.Add(Format('Debug: (readcount = %d)', [ReadCount]))
      end
{$ENDIF}
    finally
      CloseHandle(ProcessInfo.hProcess)
    end
  finally
    CloseHandle(ReadHandle)
  end
end;
//end;



procedure searchAndOpenDoc(vfilenamepath: string);
var FileName: string;
begin
  if fileexists(vfilenamepath) then begin
    FileName:= vfilenamepath;
    ShellAPI.ShellExecute(HInstance, NIL, pchar(FileName), NIL, NIL, sw_ShowNormal);
  end else
    Showmessage('Sorry, filepath to '+vfilenamepath+' is missing')
    //MessageBox(0, pChar('Sorry, filepath to '+vfilenamepath+' is missing'),'maXbox Doc',MB_OKCANCEL);
end;


Function GetUserNameWin: string;
Var
   UserName : string;
   UserNameLen : Dword;
Begin
   UserNameLen := 255;
   SetLength(userName, UserNameLen) ;
   If GetUserName(PChar(UserName), UserNameLen) Then
     Result := Copy(UserName,1,UserNameLen - 1)
   Else
     Result := 'Unknown';
End;

function GetComputerNameWin: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size:= 256;
  if GetComputerName(buffer, size) then
    Result:= buffer
  else
    Result:= ''
end;

procedure Shuffle(vQ: TStringList);
 var j, k: integer;
     tmp: String;
 begin
   randomize;
   for j:= vQ.count -1 downto 0 do begin
     k:= Random(j+1);
     tmp:= (vQ[j]);
     vQ[j]:= vQ[k];
     vQ[k]:= tmp;
   end;
 end;

function ExePath: string;
begin
  result:= ExtractFilePath(Application.ExeName)
end;

function MaxPath: string;
begin
  result:= ExtractFilePath(Application.ExeName)+ExtractFileName(Application.ExeName);
end;

function Max3(const X,Y,Z: Integer): Integer;
  begin
    if X > Y then
      if X > Z then Result := X
               else Result := Z
    else
      if Y > Z then Result := Y
               else Result := Z
  end;

function Max(const A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

procedure Swap(var X,Y: Char); // faster without inline
  var
    Z: Char;
  begin
    Z:= X;
    X:= Y;
    Y:= Z
  end;

 {procedure ReverseString(var S: String);
  var
    i: Integer;
    Len: Integer;
  begin
    Len := Length(S);
    for i:=1 to Len div 2 do
      Swap(S[i],S[Len+1-i]);
  end;}

procedure playMP3(mp3path: string);
  //liststr: string;
begin
  //liststr:= 'E:\mp3\bolin\Tommy Bolin - Teaser\Teaser.m3u';
  mciSendString(PChar('open "' + mp3path + '" alias MP3'), NIL, 0, 0);
  //player.handle
  mciSendString('play MP3', NIL, 0, 0);
  //mciSendString('close MP3', 0,0,0);
end;

procedure stopMP3;
begin
  mciSendString('stop MP3', 0,0,0);
end;

procedure closeMP3;
begin
  mciSendString('close MP3', 0,0,0);
end;

function lengthmp3(mp3path: string):integer;
var nlength: string;
begin
  mciSendString(PChar('open "' + mp3path + '" alias MP3'), NIL, 0, 0);
  setlength(nlength, 255);
  mciSendString('status MP3 length', pchar(nlength), length(nlength), 0);
  result:= StrToInt(nlength);
end;

function HexToInt(hexnum: string): LongInt;
begin
  result:= StrToInt('$' + hexnum);
end;

function CharToHexStr(Value: Char): string;
var
  Ch: Char;
begin
  Result := IntToHex(Ord(Value), 2);
  if Ch = #0 then Result := IntToHex(Ord(Value), 2);
end;

function IntToBin(Int: Integer): String; //is in IdGlobal 64bit
var
  i: integer;
begin
  Result:= '';
  for i:= 31 downto 0 do
  Result:= Result + IntToStr((Int shr i) and 1);
end;

function BinToInt(Binary: String): Integer;
var
  i: integer;
begin
  Result:= 0;
  if Length(Binary) > 0 then
    for i:= 1 to Length(Binary) do begin
    result:= result + result +(ord(Binary[i]) and 1);
  end  
end;

function HexToBin2(HexNum: string): string;
begin
  Result:= IntToBin(HexToInt(HexNum));
end;

function BinToHex2(Binary: String): string;
begin
  Result:= IntToHex(BinToInt(binary),8)
end;  


//------------------------------------------------------------------------------
function CharToUniCode(Value: Char): string;
var
  S1: string;
  Ch: Char;
begin
  Result := '';
  S1     := AnsiUpperCase(ChS);
  Ch     := UpCase(Value);
  if StrScan(PChar(S1), Ch) = nil then Result := '%' + IntToHex(Ord(Value), 2)
  else
    Result := Value;
  if Ch = #0 then Result := '%' + IntToHex(Ord(Value), 2)
end;

//------------------------------------------------------------------------------
function Hex2Dec(Value: Str002): Byte;
var
  Hi, Lo: Byte;
begin
  Hi := Ord(Upcase(Value[1]));
  Lo := Ord(Upcase(Value[2]));
  if Hi > 57 then Hi := Hi - 55
  else
    Hi := Hi - 48;
  if Lo > 57 then Lo := Lo - 55
  else
    Lo := Lo - 48;
  Result := 16 * Hi + Lo
end;

//------------------------------------------------------------------------------
function HexStrToStr(Value: string): string;
var
  i: Integer;
begin
  I      := 1;
  Result := '';
  repeat
    Result := Result + chr(Hex2Dec(Copy(Value, I, 2)));
    Inc(I, 2);
  until I > Length(Value);
end;

//------------------------------------------------------------------------------
function UniCodeToStr(Value: string): string;
var
  I: Integer;
  function HexToStr: string;
  begin
    Result := chr(Hex2Dec(Copy(Value, I + 1,2)));
    Inc(I, 2);
  end;
begin
  I      := 1;
  Result := '';
  try
    repeat
      if Value[I] = '%' then Result:= Result + HexToStr
      else
        Result := Result + Value[I];
      Inc(I);
    until I > Length(Value);
  except
    Result := '';
  end;
end;

procedure Diff(var X: array of Double);
var
  I : Integer;
begin
  for I:=Low(X) to High(X)-1 do X[I]:=X[I+1]-X[I];
  X[High(X)]:=0;
end;

function NormalizeRect(const Rect: TRect): TRect;
begin
  Result.Left:= Min(Rect.Left,Rect.Right);
  Result.Right:= math.Max(Rect.Left,Rect.Right);
  Result.Top:= Min(Rect.Top,Rect.Bottom);
  Result.Bottom:= math.Max(Rect.Top,Rect.Bottom);
end;

{procedure TridiagonalSolve(var T: array of TTriDiagRec; var y: array of Double; N: Integer);
// Solve system of liniar equtions, Tx = y when T is tridiagonal by simple
// Gaussian elimination.
//
// T(i,1)x(i-1) + T(i,2)x(i) + T(i,3)x(i+1) = y(i)
//
// The contents of y is replaced by the solution, x.
//
// Original Matlab version by Hans Bruun Nielsen, IMM, DTU. 01.10.09 / 10.30
// (tridsolv.m)
var
  i : Integer;
  e : Double;
begin
  if n=0 then n:=Length(T);
  // Forward
  for i:=1 to n-1 do
  begin
    e:=T[i].T1/T[i-1].T2;  // Elimination factor
    T[i].T2:=T[i].T2-e*T[i-1].T3;
    y[i]:=y[i]-e*y[i-1];
  end;
  // Back
  y[n-1]:=y[n-1]/T[n-1].T2;
  for i:=n-2 downto 0 do y[i]:=(y[i]-T[i].T3*y[i+1])/T[i].T2;
end;}

function PointDist(const P1,P2: TFloatPoint): Double;
begin
  Result:=Sqrt(Sqr(P1.X-P2.X)+Sqr(P1.Y-P2.Y));
end;

function PointDist2(const P1,P2: TPoint): Double;
begin
  Result:=Sqrt(Sqr(P1.X-P2.X)+Sqr(P1.Y-P2.Y));
end;

function RotatePoint(Point: TFloatPoint; const Center: TFloatPoint; const Angle: Float): TFloatPoint;
begin
  Point.X:=Point.X-Center.X;
  Point.Y:=Point.Y-Center.Y;
  Result.X:=Cos(Angle)*Point.X-Sin(Angle)*Point.Y+Center.X;
  Result.Y:=Sin(Angle)*Point.X+Cos(Angle)*Point.Y+Center.Y;
end;

function Gauss(const x,Spread: Double): Double;
begin
  Result:=exp(-sqr(x/spread));
end;

// Result = V1+V2
function VectorAdd(const V1,V2: TFloatPoint): TFloatPoint;
begin
  Result.X:=V1.X+V2.X;
  Result.Y:=V1.Y+V2.Y;
end;

// Result = V1-V2
function VectorSubtract(const V1,V2: TFloatPoint): TFloatPoint;
begin
  Result.X:=V1.X-V2.X;
  Result.Y:=V1.Y-V2.Y;
end;

// Result = V1·V2
function VectorDot(const V1,V2: TFloatPoint): Double;
begin
  Result:=V1.X*V2.X+V1.Y*V2.Y;
end;

// Result = |V|²
function VectorLengthSqr(const V: TFloatPoint): Double;
begin
  Result:=Sqr(V.X)+Sqr(V.Y);
end;

// Result = V*s
function VectorMult(const V: TFloatPoint; const s: Double): TFloatPoint;
begin
  Result.X:=V.X*s;
  Result.Y:=V.Y*s;
end;


{ compile-time importer function }
(*----------------------------------------------------------------------------
 Sometimes the CL.AddClassN() fails to correctly register a class,
 for unknown (at least to me) reasons
 So, you may use the below RegClassS() replacing the CL.AddClassN()
 of the various SIRegister_XXXX calls
 ----------------------------------------------------------------------------*)


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TwinFormp(CL: TPSPascalCompiler);
begin
   //CL.AddTypeS('TThreadFunction','function(P: Pointer): Longint; stdcall)');

  //with RegClassS(CL,'TForm', 'TwinFormp') do
  with CL.AddClassN(CL.FindClass('TForm'),'TwinFormp') do begin
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterProperty('maxx', 'Byte', iptrw);
    RegisterProperty('maxy', 'Byte', iptrw);
    RegisterProperty('maxtot', 'Byte', iptrw);
    RegisterProperty('psize', 'integer', iptrw);
    RegisterProperty('freex', 'integer', iptrw);
    RegisterProperty('freey', 'integer', iptrw);
    RegisterProperty('pattern', 'string', iptrw);
    RegisterProperty('formname', 'string', iptrw);
    RegisterMethod('Procedure moveCube( o : TMyLabel)');
    RegisterMethod('Procedure defFileread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyLabel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TLabel', 'TMyLabel') do
  with CL.AddClassN(CL.FindClass('TLabel'),'TMyLabel') do begin
    //RegisterMethod('Procedure Label1Click( Sender : TObject)');
    //RegisterMethod('procedure setLabelEvent(labelclick: TLabel; eventclick: TNotifyEvent)');
    RegisterProperty('lblx', 'integer', iptrw);
    RegisterProperty('lbly', 'integer', iptrw);
    RegisterProperty('okx', 'integer', iptrw);
    RegisterProperty('oky', 'integer', iptrw);
    RegisterProperty('place', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WinForm1(CL: TPSPascalCompiler);
begin
  //VK_RETURN
   CL.AddConstantN('SB_HORZ','LongInt').SetInt( 0);
 CL.AddConstantN('SB_VERT','LongInt').SetInt( 1);
 CL.AddConstantN('SB_CTL','LongInt').SetInt( 2);
 CL.AddConstantN('SB_BOTH','LongInt').SetInt( 3);
 CL.AddConstantN('SB_LINEUP','LongInt').SetInt( 0);
 CL.AddConstantN('SB_LINELEFT','LongInt').SetInt( 0);
 CL.AddConstantN('SB_LINEDOWN','LongInt').SetInt( 1);
 CL.AddConstantN('SB_LINERIGHT','LongInt').SetInt( 1);
 CL.AddConstantN('SB_PAGEUP','LongInt').SetInt( 2);
 CL.AddConstantN('SB_PAGELEFT','LongInt').SetInt( 2);
 CL.AddConstantN('SB_PAGEDOWN','LongInt').SetInt( 3);
 CL.AddConstantN('SB_PAGERIGHT','LongInt').SetInt( 3);
 CL.AddConstantN('SB_THUMBPOSITION','LongInt').SetInt( 4);
 CL.AddConstantN('SB_THUMBTRACK','LongInt').SetInt( 5);
 CL.AddConstantN('SB_TOP','LongInt').SetInt( 6);
 CL.AddConstantN('SB_LEFT','LongInt').SetInt( 6);
 CL.AddConstantN('SB_BOTTOM','LongInt').SetInt( 7);
 CL.AddConstantN('SB_RIGHT','LongInt').SetInt( 7);
 CL.AddConstantN('SB_ENDSCROLL','LongInt').SetInt( 8);
 CL.AddConstantN('SW_HIDE','LongInt').SetInt( 0);
 CL.AddConstantN('SW_SHOWNORMAL','LongInt').SetInt( 1);
 CL.AddConstantN('SW_NORMAL','LongInt').SetInt( 1);
 CL.AddConstantN('SW_SHOWMINIMIZED','LongInt').SetInt( 2);
 CL.AddConstantN('SW_SHOWMAXIMIZED','LongInt').SetInt( 3);
 CL.AddConstantN('SW_MAXIMIZE','LongInt').SetInt( 3);
 CL.AddConstantN('SW_SHOWNOACTIVATE','LongInt').SetInt( 4);
 CL.AddConstantN('SW_SHOW','LongInt').SetInt( 5);
 CL.AddConstantN('SW_MINIMIZE','LongInt').SetInt( 6);
 CL.AddConstantN('SW_SHOWMINNOACTIVE','LongInt').SetInt( 7);
 CL.AddConstantN('SW_SHOWNA','LongInt').SetInt( 8);
 CL.AddConstantN('SW_RESTORE','LongInt').SetInt( 9);
 CL.AddConstantN('SW_SHOWDEFAULT','LongInt').SetInt( 10);
 CL.AddConstantN('SW_MAX','LongInt').SetInt( 10);
 CL.AddConstantN('HIDE_WINDOW','LongInt').SetInt( 0);
 CL.AddConstantN('SHOW_OPENWINDOW','LongInt').SetInt( 1);
 CL.AddConstantN('SHOW_ICONWINDOW','LongInt').SetInt( 2);
 CL.AddConstantN('SHOW_FULLSCREEN','LongInt').SetInt( 3);
 CL.AddConstantN('SHOW_OPENNOACTIVATE','LongInt').SetInt( 4);
 CL.AddConstantN('SW_PARENTCLOSING','LongInt').SetInt( 1);
 CL.AddConstantN('SW_OTHERZOOM','LongInt').SetInt( 2);
 CL.AddConstantN('SW_PARENTOPENING','LongInt').SetInt( 3);
 CL.AddConstantN('SW_OTHERUNZOOM','LongInt').SetInt( 4);
 CL.AddConstantN('AW_HOR_POSITIVE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('AW_HOR_NEGATIVE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('AW_VER_POSITIVE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('AW_VER_NEGATIVE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('AW_CENTER','LongWord').SetUInt( $00000010);
 CL.AddConstantN('AW_HIDE','LongWord').SetUInt( $00010000);
 CL.AddConstantN('AW_ACTIVATE','LongWord').SetUInt( $00020000);
 CL.AddConstantN('AW_SLIDE','LongWord').SetUInt( $00040000);
 CL.AddConstantN('AW_BLEND','LongWord').SetUInt( $00080000);
 CL.AddConstantN('KF_EXTENDED','LongWord').SetUInt( $100);
 CL.AddConstantN('KF_DLGMODE','LongWord').SetUInt( $800);
 CL.AddConstantN('KF_MENUMODE','LongWord').SetUInt( $1000);
 CL.AddConstantN('KF_ALTDOWN','LongWord').SetUInt( $2000);
 CL.AddConstantN('KF_REPEAT','LongWord').SetUInt( $4000);
 CL.AddConstantN('KF_UP','LongWord').SetUInt( $8000);
 CL.AddConstantN('VK_LBUTTON','LongInt').SetInt( 1);
 CL.AddConstantN('VK_RBUTTON','LongInt').SetInt( 2);
 CL.AddConstantN('VK_CANCEL','LongInt').SetInt( 3);
 CL.AddConstantN('VK_MBUTTON','LongInt').SetInt( 4);
 CL.AddConstantN('VK_XBUTTON1','LongInt').SetInt( 5);
 CL.AddConstantN('VK_XBUTTON2','LongInt').SetInt( 6);
 CL.AddConstantN('VK_BACK','LongInt').SetInt( 8);
 CL.AddConstantN('VK_TAB','LongInt').SetInt( 9);
 CL.AddConstantN('VK_CLEAR','LongInt').SetInt( 12);
 CL.AddConstantN('VK_RETURN','LongInt').SetInt( 13);
 CL.AddConstantN('VK_SHIFT','LongWord').SetUInt( $10);
 CL.AddConstantN('VK_CONTROL','LongInt').SetInt( 17);
 CL.AddConstantN('VK_MENU','LongInt').SetInt( 18);
 CL.AddConstantN('VK_PAUSE','LongInt').SetInt( 19);
 CL.AddConstantN('VK_CAPITAL','LongInt').SetInt( 20);
 CL.AddConstantN('VK_KANA','LongInt').SetInt( 21);
 CL.AddConstantN('VK_HANGUL','LongInt').SetInt( 21);
 CL.AddConstantN('VK_JUNJA','LongInt').SetInt( 23);
 CL.AddConstantN('VK_FINAL','LongInt').SetInt( 24);
 CL.AddConstantN('VK_HANJA','LongInt').SetInt( 25);
 CL.AddConstantN('VK_KANJI','LongInt').SetInt( 25);
 CL.AddConstantN('VK_CONVERT','LongInt').SetInt( 28);
 CL.AddConstantN('VK_NONCONVERT','LongInt').SetInt( 29);
 CL.AddConstantN('VK_ACCEPT','LongInt').SetInt( 30);
 CL.AddConstantN('VK_MODECHANGE','LongInt').SetInt( 31);
 CL.AddConstantN('VK_ESCAPE','LongInt').SetInt( 27);
 CL.AddConstantN('VK_SPACE','LongWord').SetUInt( $20);
 CL.AddConstantN('VK_PRIOR','LongInt').SetInt( 33);
 CL.AddConstantN('VK_NEXT','LongInt').SetInt( 34);
 CL.AddConstantN('VK_END','LongInt').SetInt( 35);
 CL.AddConstantN('VK_HOME','LongInt').SetInt( 36);
 CL.AddConstantN('VK_LEFT','LongInt').SetInt( 37);
 CL.AddConstantN('VK_UP','LongInt').SetInt( 38);
 CL.AddConstantN('VK_RIGHT','LongInt').SetInt( 39);
 CL.AddConstantN('VK_DOWN','LongInt').SetInt( 40);
 CL.AddConstantN('VK_SELECT','LongInt').SetInt( 41);
 CL.AddConstantN('VK_PRINT','LongInt').SetInt( 42);
 CL.AddConstantN('VK_EXECUTE','LongInt').SetInt( 43);
 CL.AddConstantN('VK_SNAPSHOT','LongInt').SetInt( 44);
 CL.AddConstantN('VK_INSERT','LongInt').SetInt( 45);
 CL.AddConstantN('VK_DELETE','LongInt').SetInt( 46);
 CL.AddConstantN('VK_HELP','LongInt').SetInt( 47);
  CL.AddConstantN('HKEY_CLASSES_ROOT','LongInt').SetInt($80000000);
  CL.AddConstantN('HKEY_CURRENT_USER','LongInt').SetInt($80000001);
  CL.AddConstantN('HKEY_LOCAL_MACHINE','LongInt').SetInt($80000002);
  CL.AddConstantN('HKEY_USERS','LongInt').SetInt($80000003);
  CL.AddConstantN('HKEY_PERFORMANCE_DATA','LongInt').SetInt($80000004);
  CL.AddConstantN('HKEY_CURRENT_CONFIG','LongInt').SetInt($80000005);
  CL.AddConstantN('HKEY_DYN_DATA','LongInt').SetInt($80000006);
  CL.AddTypeS('THexArray', 'array[0..15] of char;');
  //CL.AddTypeS('THexSet', '(0123456789A,B,C,D,E,F)');

  //CL.AddConstantN('HEXDIGITS','THexArray').SetSet('0123456789ABCDEF');

  // HexDigits: array [0..15] of Char = '0123456789ABCDEF';    {Do not Localize}
  CL.AddTypeS('TFloatPoint2', 'record X, Y: Double; end');
  CL.AddTypeS('TPointArray', 'array of TPoint;');
  CL.AddTypeS('shortstring', 'string[0..255];');
  CL.AddTypeS('Float', 'Double;');
  CL.AddTypeS('Real', 'Double;');
  //CL.AddTypeS('Int', 'Integer;');
  CL.AddTypeS('Long', 'Int64;');
  CL.AddTypeS('Pointer', '___Pointer;');     //3.8.1

  //CL.AddTypeS('Short', 'Smallint'); in Id_Global


  //CL.addConstantN('hexdigits[1]','THEXarray').SetChar('A');
   //0123456789ABCDEF
  //CL.addConstantN('hexdigits','THexArray');
  //CL.addConstantN(hexdigits,'char');
  //CL.addConstantN(hexdigits[1],'char').SetChar('1');
   //CL.addConstantN('hexdigits','const');

   //TFloatPoint
  SIRegister_TMyLabel(CL);
  SIRegister_TwinFormp(CL);
end;

//debug out is global for any calls - app is owner!
procedure SIRegister_Tdebugoutput(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'Tdebugoutput') do
  with CL.AddClassN(CL.FindClass('TForm'),'Tdebugoutput') do begin
    RegisterProperty('output', 'TMemo', iptrw);
    RegisterProperty('mycaption', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ide_debugoutput(CL: TPSPascalCompiler);
begin
  SIRegister_Tdebugoutput(CL);
end;


function RegClassS(CL: TPSPascalCompiler; const InheritsFrom, Classname: string): TPSCompileTimeClass;
begin
  Result := CL.FindClass(Classname);
  if Result = nil then
    Result := CL.AddClassN(CL.FindClass(InheritsFrom), Classname)
  else Result.ClassInheritsFrom := CL.FindClass(InheritsFrom);
end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure Tdebugoutputmycaption_W(Self: Tdebugoutput; const T: string);
Begin Self.mycaption := T; end;

(*----------------------------------------------------------------------------*)
procedure Tdebugoutputmycaption_R(Self: Tdebugoutput; var T: string);
Begin T := Self.mycaption; end;

(*----------------------------------------------------------------------------*)
procedure Tdebugoutputoutput_W(Self: Tdebugoutput; const T: TMemo);
Begin Self.output := T; end;

(*----------------------------------------------------------------------------*)
procedure Tdebugoutputoutput_R(Self: Tdebugoutput; var T: TMemo);
Begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Tdebugoutput(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(Tdebugoutput) do
  begin
    RegisterPropertyHelper(@Tdebugoutputoutput_R,@Tdebugoutputoutput_W,'output');
    RegisterPropertyHelper(@Tdebugoutputmycaption_R,@Tdebugoutputmycaption_W,'mycaption');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ide_debugoutput(CL: TPSRuntimeClassImporter);
begin
  RIRegister_Tdebugoutput(CL);
end;

 
 
{ TPSImport_ide_debugoutput }
(*----------------------------------------------------------------------------*)
{procedure TPSImport_ide_debugoutput.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ide_debugoutput(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ide_debugoutput.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ide_debugoutput(ri);
end;}
(*----------------------------------------------------------------------------*)



procedure TwinFormpformname_W(Self: TwinFormp; const T: shortstring);
Begin Self.formname := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpformname_R(Self: TwinFormp; var T: shortstring);
Begin T := Self.formname; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormppatternmode_W(Self: TwinFormp; const T: shortstring);
Begin Self.patternmode := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormppatternmode_R(Self: TwinFormp; var T: shortstring);
Begin T := Self.patternmode; end;


(*----------------------------------------------------------------------------*)
procedure TwinFormppattern_W(Self: TwinFormp; const T: string);
Begin Self.pattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormppattern_R(Self: TwinFormp; var T: string);
Begin T := Self.pattern; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpfreey_W(Self: TwinFormp; const T: integer);
Begin Self.freey := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpfreey_R(Self: TwinFormp; var T: integer);
Begin T := Self.freey; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpfreex_W(Self: TwinFormp; const T: integer);
Begin Self.freex := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpfreex_R(Self: TwinFormp; var T: integer);
Begin T := Self.freex; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormppsize_W(Self: TwinFormp; const T: integer);
Begin Self.psize := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormppsize_R(Self: TwinFormp; var T: integer);
Begin T := Self.psize; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpmaxtot_W(Self: TwinFormp; const T: Byte);
Begin Self.maxtot := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpmaxtot_R(Self: TwinFormp; var T: Byte);
Begin T := Self.maxtot; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpmaxy_W(Self: TwinFormp; const T: Byte);
Begin Self.maxy := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpmaxy_R(Self: TwinFormp; var T: Byte);
Begin T := Self.maxy; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpmaxx_W(Self: TwinFormp; const T: Byte);
Begin Self.maxx := T; end;

(*----------------------------------------------------------------------------*)
procedure TwinFormpmaxx_R(Self: TwinFormp; var T: Byte);
Begin T := Self.maxx; end;

(*----------------------------------------------------------------------------*)
//less timer 2.8.1

(*----------------------------------------------------------------------------*)
procedure TMyLabelplace_W(Self: TMyLabel; const T: Boolean);
Begin Self.place := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabelplace_R(Self: TMyLabel; var T: Boolean);
Begin T := Self.place; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabeloky_W(Self: TMyLabel; const T: integer);
Begin Self.oky := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabeloky_R(Self: TMyLabel; var T: integer);
Begin T := Self.oky; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabelokx_W(Self: TMyLabel; const T: integer);
Begin Self.okx := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabelokx_R(Self: TMyLabel; var T: integer);
Begin T := Self.okx; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabellbly_W(Self: TMyLabel; const T: integer);
Begin Self.lbly := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabellbly_R(Self: TMyLabel; var T: integer);
Begin T := Self.lbly; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabellblx_W(Self: TMyLabel; const T: integer);
Begin Self.lblx := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyLabellblx_R(Self: TMyLabel; var T: integer);
Begin T := Self.lblx; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TwinFormp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TwinFormp) do begin
    //RegisterPropertyHelper(@TwinFormpTimer1_R,@TwinFormpTimer1_W,'Timer1');
    RegisterMethod(@TwinFormp.FormCreate, 'FormCreate');
    RegisterPropertyHelper(@TwinFormpmaxx_R,@TwinFormpmaxx_W,'maxx');
    RegisterPropertyHelper(@TwinFormpmaxy_R,@TwinFormpmaxy_W,'maxy');
    RegisterPropertyHelper(@TwinFormpmaxtot_R,@TwinFormpmaxtot_W,'maxtot');
    RegisterPropertyHelper(@TwinFormppsize_R,@TwinFormppsize_W,'psize');
    RegisterPropertyHelper(@TwinFormpfreex_R,@TwinFormpfreex_W,'freex');
    RegisterPropertyHelper(@TwinFormpfreey_R,@TwinFormpfreey_W,'freey');
    RegisterPropertyHelper(@TwinFormppattern_R,@TwinFormppattern_W,'pattern');
    RegisterPropertyHelper(@TwinFormppatternmode_R,@TwinFormppatternmode_W,'patternmode');
    RegisterPropertyHelper(@TwinFormpformname_R,@TwinFormpformname_W,'formname');
    RegisterMethod(@TwinFormp.moveCube, 'moveCube');
    //RegisterMethod(@TwinFormp.defFileread, 'defFileread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyLabel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyLabel) do begin
    //RegisterMethod(@TMyLabel.Label1Click, 'Label1Click');
    //RegisterMethod(@TMyLabel.setLabelEvent, 'setLabelEvent');
    RegisterPropertyHelper(@TMyLabellblx_R,@TMyLabellblx_W,'lblx');
    RegisterPropertyHelper(@TMyLabellbly_R,@TMyLabellbly_W,'lbly');
    RegisterPropertyHelper(@TMyLabelokx_R,@TMyLabelokx_W,'okx');
    RegisterPropertyHelper(@TMyLabeloky_R,@TMyLabeloky_W,'oky');
    RegisterPropertyHelper(@TMyLabelplace_R,@TMyLabelplace_W,'place');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WinForm1(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMyLabel(CL);
  RIRegister_TwinFormp(CL);
end;

{ TPSImport_WinForm1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinForm1.CompOnUses(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinForm1.ExecOnUses(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinForm1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WinForm1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinForm1.CompileImport2(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinForm1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WinForm1(ri);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinForm1.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing }
end;

end.
