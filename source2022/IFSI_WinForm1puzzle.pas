unit IFSI_WinForm1puzzle;
{
//Contains most of the win32 specific functions and test functions,  by mX3
//procedure TMyLabel.setLabelEvent(labelclick: TLabel; eventclick: TNotifyEvent);
//more various functions for mainroutine and script language locs=6101
// forms.application namespace! for find component, getbox, navigation  - httpget  4.7.4.62 -https 4.7.6.20
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
  ,Windows
  ,Graphics
  ,StdCtrls
  ,Grids;

function IsWow64Process(cu: THandle; var res: boolean): boolean; external kernel32 name 'IsWow64Process';


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
  TThreadFunction = function: Longint; stdcall;  //also in sysutils
  TThreadFunction22 = procedure; stdcall;

  //TByteArray = array[0..255] of byte;
  THexArray = array [0..15] of Char; // = '0123456789ABCDEF';

  //TDbiGetExactRecordCount = function(hCursor: hDBICur;
    //var iRecCount: Longint): boolean;


  TWow64Process = function(cu: THandle; var res: boolean):boolean;

   TBitmapStyle = (bsNormal, bsCentered, bsStretched);

   T2StringArray = array of array of string;
   T2IntegerArray = array of array of integer;
   T2CharArray = array of array of char;


   T3StringArray = array of array of array of string;
   T3IntegerArray = array of array of array of integer;

  TVolumeLevel = 0..127;

  TFileCallbackProcedure = procedure(filename:string);



const
  ChS = '0123456789abcdefghijklmnopqrstuvwxyz';
//var
  WDAYS: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri' , 'Sat'); {do not localize}
  MONTHNAMES: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May'  , 'Jun',  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); {do not localize}
  HexDigits: array [0..15] of Char = '0123456789ABCDEF';    {Do not Localize}
  SeparationCHAR = '.';
  IdHexDigits: array [0..15] of AnsiChar = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'); {do not localize}
  //CTHexSet = '0123456789ABCDEF';


var
  // STATExecuteShell: Boolean;
   ActVersion: shortstring;
   comp_count: integer;


type

  //THexSet2 = (1..9, A..F);
  mTByteArray = array of Byte;
  TNavPos = (tLat, tLon);


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
procedure SearchAndCopy(aStrList: TStrings; aSearchStr, aNewStr: string; offset: integer);
Procedure ExecuteCommand(executeFile, paramstring: string);
Procedure ShellExecuteAndWait(executeFile, paramstring: string);
procedure SearchAndOpenDoc(vfilenamepath: string);
Function GetUserNameWin: string;
function GetComputerNameWin: string;
procedure Shuffle(vQ: TStringList);
function Max3(const X,Y,Z: Integer): Integer;
function Max(const A, B: Integer): Integer; overload; inline;
//procedure ReverseString(var S: String);
procedure Swap(var X,Y: Char);
//function IntToBin(Int: Integer): String;  from IdGlobal better of 64bit
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

procedure ExecuteThread2(afunc: TThreadFunction22; var thrOK: boolean);
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
function getTimeAMString: string;
function getTimePMString: string;

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
Function CharToHex(const APrefix: String; const cc: Char): string;
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
function IsVirtualPcGuest : Boolean;
function IsVmWareGuest : Boolean;
procedure StartSerialDialog;
function IsWoW64: boolean;
function IsWow64String(var s: string): Boolean;
procedure StartThreadDemo;
Function RGB(R,G,B: Byte): TColor;
Function Sendln(amess: string): boolean;
Procedure maXbox;
Function AspectRatio(aWidth, aHeight: Integer): String;
function wget(aURL, afile: string): boolean;
function wget2(aURL, afile: string): boolean;
function wget3(aURL, afile: string; opendoc: boolean): boolean;
procedure PrintList(Value: TStringList);
procedure PrintImage(aValue: TBitmap; Style: TBitmapStyle);
procedure getEnvironmentInfo;
procedure AntiFreeze;
function getBitmap(apath: string): TBitmap;
procedure ShowMessageBig(const aText : string);
procedure ShowMessageBig2(const aText : string; aautosize: boolean);
procedure ShowMessageBig3(const aText : string; fsize: byte; aautosize: boolean);
function YesNoDialog(const ACaption, AMsg: string): boolean;
procedure SetArrayLength2String(arr: T2StringArray; asize1, asize2: integer);
procedure SetArrayLength2Integer(arr: T2IntegerArray; asize1, asize2: integer);
procedure SetArrayLength2String2(var arr: T2StringArray; asize1, asize2: integer);
procedure SetArrayLength2Integer2(var arr: T2IntegerArray; asize1, asize2: integer);
procedure SetArrayLength2Char2(var arr: T2CharArray; asize1, asize2: integer);
procedure Set3DimIntArray(var arr: T3IntegerArray; asize1, asize2, asize3: integer);
procedure Set3DimStrArray(var arr: T3StringArray; asize1, asize2, asize3: integer);


//function myStrToBytes(const Value: String): TBytes;
//function myBytesToStr(const Value: TBytes): String;
function SaveAsExcelFile(AGrid: TStringGrid; ASheetName, AFileName: string; open: boolean): Boolean;
function ReverseDNSLookup(const IPAddress: String; const DNSServer: String; Timeout, Retries: Integer; var HostName: String): Boolean;
function FindInPaths(const fileName, paths : String) : String;
procedure initHexArray(var hexn: THexArray);
function josephusG(n,k: integer; var graphout: string): integer;
function isPowerof2(num: int64): boolean;
function powerOf2(exponent: integer): int64;
function getBigPI: string;
procedure MakeSound(Frequency{Hz}, Duration{mSec}: Integer; Volume: TVolumeLevel; savefilePath: string);
 function GetASCIILine: string;
procedure MakeComplexSound(N:integer {stream # to use}; freqlist:TStrings; Duration{mSec}: Integer;
                           pinknoise: boolean; shape: integer; Volume: TVolumeLevel);
type
    MSArray = array[0..1] of tmemorystream;
function MakeComplexSound2(N:integer {stream # to use}; freqlist:TStrings; Duration{mSec}: Integer;
                           pinknoise: boolean; shape: integer; Volume: TVolumeLevel): MSArray;

procedure SetComplexSoundElements(freqedt,Phaseedt,AmpEdt,WaveGrp:integer);
procedure AddComplexSoundObjectToList(newf,newp,newa,news:integer; freqlist: TStrings);
function mapfunc(ax, in_min, in_max, out_min, out_max: integer): integer;
function mapmax(ax, in_min, in_max, out_min, out_max: integer): integer;
procedure StrSplitP(const Delimiter: Char; Input: string; const Strings: TStrings);
function ReadReg(Base: HKEY; KeyName, ValueName: string): string;
function GetOSName: string;
function GetOSVersion: string;
function GetOSNumber: string;
function getEnvironmentString: string;
procedure StrReplace(var Str: String; Old, New: String);
procedure SendEmail(mFrom,  mTo,  mSubject,  mBody,  mAttachment: variant);
function getTeamViewerID: string;
Procedure RecurseDirectory(
  Dir : String;
  IncludeSubs : boolean;
  callback : TFileCallbackProcedure);
Procedure RecurseDirectory2(Dir : String; IncludeSubs : boolean);
procedure WinInet_HttpGet(const Url: string; Stream:TStream);
procedure GetQrCode2(Width,Height: Word; Correct_Level: string;
           const Data:string; apath: string);
procedure GetQrCode3(Width,Height: Word; Correct_Level: string;
           const Data:string; apath: string);
//function GetQrCode4(Width,Height: Word; Correct_Level: string;
  //         const Data:string; aformat: string): TLinearBitmap;
function StartSocketService: Boolean;
procedure StartSocketServiceForm;
function GetFileList(FileList: TStringlist; apath: string): TStringlist;
function GetFileList1(apath: string): TStringlist;
procedure LetFileList(FileList: TStringlist; apath: string);
procedure StartWeb(aurl: string);
function GetTodayFiles(startdir, amask: string): TStringlist;
function PortTCPIsOpen(dwPort : Word; ipAddressStr: String): boolean;
function JavahashCode(val: string): Integer;
procedure PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean);
procedure SaveBytesToFile2(const Data: Sysutils.TBytes; const FileName: string);
Procedure HideWindowForSeconds(secs: integer);   {//3 seconds}
Procedure HideWindowForSeconds2(secs: integer; apphandle, aself: TForm);   {//3 seconds}
Procedure ConvertToGray(Cnv: TCanvas);
function GetFileDate(aFile:string; aWithTime:Boolean):string;
procedure ShowMemory;
function ShowMemory2: string;
function getHostIP: string;
procedure ShowBitmap(bmap: TBitmap);
function IsWindowsVista: boolean;
function GetOsVersionInfo: TOSVersionInfo;      //thx to wischnewski
//function GetOsVersionInfoEx: TOSVersionInfo;      //thx to wischnewski
function CreateDBGridForm(dblist: TStringList): TListbox;

//function getProcessAllMemory(ProcessID : DWORD): TProcessMemoryCounters;
{*
	index means:
	0 - FreeBytesAvailable
	1 - TotalNumberOfBytes
	2 - TotalNumberOfFreeBytes
}
function getDiskSpace2(const path: String; index: int): int64;
function GetIsAdmin: Boolean;
function ChangeOEPFromBytes(bFile:mTByteArray):Boolean;
function ChangeOEPFromFile(sFile:string; sDestFile:string):Boolean;
procedure CopyEXIF(const FileNameEXIFSource, FileNameEXIFTarget: string);
function IsNetworkConnected: Boolean;
function IsInternetConnected: Boolean;
function IsCOMConnected: Boolean;
 function isService: boolean;
  function isApplication: boolean;
  function isTerminalSession: boolean;
  function SetPrivilege(privilegeName: string; enable: boolean): boolean;
  procedure getScriptandRunAsk;
  procedure getScriptandRun(ascript: string);
  function VersionCheckAct: string;
  procedure getBox(aurl, extension: string);
  function CheckBox: string;
  function isNTFS: boolean;
  //procedure doWebCamPic;
  procedure doWebCamPic(picname: string);
  function readm: string;
  procedure getGEOMapandRunAsk;
 function GetMapX(C_form,apath: string; const Data: string): boolean;
  procedure GetGEOMap(C_form,apath: string; const Data: string);
  function GetMapXGeoReverse(C_form: string; const lat,long: string): string;
 function GetGeocodeCoord(C_form: string; const data:string; atxt: boolean): string;

  //function RoundTo(const AValue: Extended;
    //             const ADigit: TRoundToEXRangeExtended): Extended;
 function DownloadFile(SourceFile, DestFile: string): Boolean;
 function DownloadFileOpen(SourceFile, DestFile: string): Boolean;
 function OpenMap(const Data: string): boolean;
 function GetGeoCode(C_form,apath: string; const data: string; sfile: boolean): string;
 Function getFileCount(amask: string): integer;
 function CoordinateStr(Idx: Integer; PosInSec: Double; PosLn: TNavPos): string;
 procedure Debugln(DebugLOGFILE: string; E: string);
 function IntToFloat(i: Integer): double;
function AddThousandSeparator(S: string; myChr: Char): string;
function mymciSendString(cmd: PChar; ret: PChar; len: integer; callback: integer): cardinal;
function isSound: boolean;
 procedure CheckMemory;
 function GetMemoryInfo: string;
   function GetMemoryData: integer;
     function UpTime: string;

  function GetProcessorName: string;   
  function GetBiosVendor: string;
  function RemainingBatteryPercent: Integer;

  function GetScriptPath2: string;
  function GetScriptName2: string;

implementation

uses
   Messages
  //,Graphics
  //,Controls
  //,Forms
  ,Dialogs
  //,StdCtrls
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
  ,serialUnit1
  ,THSort
  ,fileUtils
  ,JCLSysInfo
  ,ComObj
  ,upsi_comctrls
  ,Variants
  ,IdDNSResolver
  ,HTTPApp
  ,LinarBitmap
  ,ExtCtrls
  ,IdcoderMime
  ,SvcMgr ,WinSvc, ScktCnst, ScktMain, avicap, uPSI_LinarBitmap
   ,WinInet, winsock, Cport, gsUtils, lazFileUtils, JvStrUtils, JCLNTFS2, XmlVerysimple;

  //,Registry
  //,Grids
  //,Printers

  const
   ZAEHLER = 0;
   NENNER  = 1;
   POSIT   = 0;
   PILARGE = '3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282'+
   '306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165'+
   '271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360011330'+
   '530548820466521384146951941511609433057270365759591953092186117381932611793105118548074462379962749567351885752724891227938183'+
   '011949129833673362440656643086021394946395224737190702179860943702770539217176293176752384674818467669405132000568127145263560'+
   '827785771342757789609173637178721468440901224953430146549585371050792279689258923542019956112129021960864034418159813629774771'+
   '309960518707211349999998372978049951059731732816096318595024459455346908302642522308253344685035261931188171010003137838752886'+
   '587533208381420617177669147303598253490428755468731159562863882353787593751957781857780532171226806613001927876611195909216420198';



 function getBigPI: string;
 begin
   result:= PILARGE;
 end;

function getHostIP: string;
begin
  //writeln(gethostname);
  result:= getIPAddress(getComputerNameWin);
end;

function RemainingBatteryPercent: Integer;
var
  Stat: Windows.TSystemPowerStatus;
begin
  Windows.GetSystemPowerStatus(Stat);
  Result := Stat.BatteryLifePercent;
  if (Result < 0) or (Result > 100) then
    Result := -1;
end;

function GetScriptPath2: string;
begin
  result:= maxform1.getscriptpath;
end;

function GetScriptName2: string;
begin
  result:= maxform1.GetActFileName;
end;

function GetProcessorName: string;
var
  Reg: Registry.TRegistry;
begin
  Result := '';
  Reg := Registry.TRegistry.Create(Windows.KEY_READ);
  try
    Reg.RootKey := Windows.HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey(
      'HARDWARE\DESCRIPTION\System\CentralProcessor\0\', False
    ) then
      Exit;
    Result := Reg.ReadString('ProcessorNameString');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function GetBiosVendor: string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey('HARDWARE\DESCRIPTION\System\Bios\', False) then
      Exit;
    Result := Reg.ReadString('BIOSVendor');
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;


function isSound: boolean;
begin
  result:= waveOutGetNumDevs > 0;
end;

function IsNetworkConnected: Boolean;
begin
  if GetSystemMetrics(SM_NETWORK) and $01 = $01 then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

function isNTFS: boolean;
 begin
   result:= NtfsReparsePointsSupported(Extractfiledrive('C')+'\')
 end;


const  WM_CAP_DRIVER_CONNECT = WM_CAP_START + 10;
       WM_CAP_DRIVER_DISCONNECT = WM_CAP_START + 11;
       WM_CAP_SET_CALLBACK_FRAME = (WM_CAP_START+  5);


procedure doWebCamPic(picname: string);
 var hWndC: THandle;
  FBitmap: TBitmap;
  DC:HDC;
  i: integer;
  mpanel: TPanel;
begin
  //hWndC:= 0;
   FBitmap:= TBitmap.Create;
    mPanel:= TPanel.Create(maxform1);
    mpanel.parent:= maxform1;
    mpanel.SetBounds(20,20,412,412);
   FBitmap.PixelFormat:= pf32Bit;
  for i:= 1 to 2 do begin
  hWndC:= capCreateCaptureWindow('My maXfilm Capture Window',
    WS_CHILD or WS_VISIBLE , 0,0,
    mPanel.Width, mPanel.Height,
    mPanel.Handle, 0);
     SendMessage(hWndC, WM_CAP_DRIVER_CONNECT, 0, 0);
   if (hWndC <> 0) and (i= 1) then begin
       //SendMessage(hwndc, WM_CAP_DRIVER_DISCONNECT, 0, 0);
       mPanel.Free;
       mPanel:= TPanel.Create(maxform1);
      mpanel.parent:= maxform1;
      mpanel.SetBounds(20,20,420,420)
     //renewPanel;
    //SendMessage(hWndC, WM_CAP_DRIVER_CONNECT, 0, 0);
    end;
  end;
    //fbitmap.canvas.Handle, 0);
    //writeln('frame graber handle: '+inttoStr(hWndc));
    DC:= GetDc(mpanel.Handle);
    fbitmap.Width:= mpanel.width;
    fbitmap.Height:= mpanel.height;
    BitBlt(FBitmap.Canvas.Handle,0,0,mPanel.Width,mPanel.Height,DC,0,0,SRCCOPY);
    SaveCanvas2(FBitmap.canvas, picname);
  // fbitmap.savetofile(Exepath+FOTOFILE);
    FBitmap.Free;
    mpanel.free;
   ShowmessageBig2('Foto saved as '+picname,true);
   SearchandOpenDoc(picname);
   capCaptureStop(hWndc);
  //TForm1_StopFotoClick(self);
end;


 function readm: string;
 begin
   //SendMessage(maxform1.memo2.Handle, EM_SCROLL, SB_LINEDOWN, 0);
   result:= maxform1.Memo2.Lines[maxform1.Memo2.Lines.Count-1];
 end;

function IntToFloat(i: Integer): double;
begin
  result:= i;
end;

function AddThousandSeparator(S: string; myChr: Char): string;
var
  I: Integer;
begin
  Result:= S;
  I:= Length(S) - 2;
  while I > 1 do begin
    Insert(myChr, Result, I);
    I:= I - 3;
  end;
end;


function IsInternetConnected: Boolean;
begin
  Result:= InternetGetConnectedState(nil, 0);
end;

function IsCOMConnected: Boolean;
begin
  try
  result:= getcomports.Count > 0;
  except
    //showmessage('No COM Ports available!');
    result:= false;
  end;
end;

 function isService: boolean;
  begin
    result:= NOT(Forms.Application is TApplication);
    {result:= Application is TServiceApplication;}
  end;
  function isApplication: boolean;
  begin
    result:= Forms.Application is TApplication;
  end;
  //SM_REMOTESESSION = $1000
  function isTerminalSession: boolean;
  begin
    result:= GetSystemMetrics(SM_REMOTESESSION) > 0;
  end;

function SetPrivilege(privilegeName: string; enable: boolean): boolean;
var
  tpPrev,
  tp         : TTokenPrivileges;
  token      : THandle;
  dwRetLen   : DWord;
begin
  result := False;

  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, token);

  tp.PrivilegeCount := 1;
  if LookupPrivilegeValue(nil, pchar(privilegeName), tp.Privileges[0].LUID) then
  begin
    if enable then
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else
      tp.Privileges[0].Attributes := 0;

    dwRetLen := 0;
    result := AdjustTokenPrivileges(token, False, tp, SizeOf(tpPrev), tpPrev, dwRetLen);
  end;
  CloseHandle(token);
end;

//with apikey key=4fq4nLMtfdWnJIHxAOIw8juuFpXymkaa&

const
  UrlMapQuestAPICode='http://open.mapquestapi.com/nominatim/v1/search.php?key=4fq4nLMtfdWnJIHxAOIw8juuFpXymkaa&format=html&json_callback=renderBasicSearchNarrative&q=%s';
  UrlMapQuestAPICode2='http://open.mapquestapi.com/nominatim/v1/search.php?key=4fq4nLMtfdWnJIHxAOIw8juuFpXymkaa&format=%s&json_callback=renderBasicSearchNarrative&q=%s';


procedure getGEOMapandRunAsk;
  var getstr, ascript: string;
 encodedURL, apath: string;
 begin
   if IsInternet then begin
   //ascript:= 'http://www.softwareschule.ch/examples/demoscript.txt';
  apath:= ExePath+'geomapX.html';
  ascript:= 'Cathedral Cologne';
    if InputQuery('Get Web GEO Map - Tutorial 39','Please enter a GEO search location:',ascript) then
     begin
     //writeln('you entered: '+(string(ascript)));
    // wGet(ascript,'scriptdemo.txt');
  encodedURL:= Format(UrlMapQuestAPICode,[HTTPEncode(ascript)]);
  try
   //HttpGet(EncodedURL, mapStream);   //WinInet
   UrlDownloadToFile(Nil,PChar(encodedURL),PChar(apath),0,Nil);
  //OpenFile(apath);
  S_ShellExecute(apath,'',seCmdOpen);
  finally
    encodedURL:= '';
  end;
       //ShellExecute3
      maxForm1.memo2.lines.Add(' GEO Web Script started: '+ascript+ ' at: '+timetostr(time));
      maxForm1.statusBar1.SimpleText:= ' GEO Web Script finished: '+ascript;
      maxForm1.memo2.lines.Add(' GEO Web Script finished: '+getStr+ ' at: '+timetostr(time));
        //statusline
   end else
         showmessage('No Search Location!');
  //end;
   end else
         showmessage('No Web Connection available!');
end;


function GetMapX(C_form,apath: string; const Data: string): boolean;
var encodedURL: string;
begin
  //encodedURL:= Format(UrlGoogleQrCode,[Width,Height, C_Level, HTTPEncode(Data)]);
  encodedURL:= Format(UrlMapQuestAPICode2,[c_form,HTTPEncode(Data)]);
  try
   //HttpGet(EncodedURL, mapStream);   //WinInet
  Result:= UrlDownloadToFile(Nil,PChar(encodedURL),PChar(apath),0,Nil)= 0;
  //OpenDoc(apath);
   S_ShellExecute(apath,'',seCmdOpen);
  finally
    encodedURL:= '';
  end;
end;


procedure GetGEOMap(C_form,apath: string; const Data: string);
var
  encodedURL: string;
  mapStream: TMemoryStream;
begin
  //encodedURL:= Format(UrlGoogleQrCode,[Width,Height, C_Level, HTTPEncode(Data)]);
  encodedURL:= Format(UrlMapQuestAPICode2,[c_form,HTTPEncode(Data)]);
  mapStream:= TMemoryStream.create;
  try
    Wininet_HttpGet(EncodedURL, mapStream);   //WinInet
    mapStream.Position:= 0;
    mapStream.Savetofile(apath);
   // OpenDoc(apath);
   S_ShellExecute(apath,'',seCmdOpen);

  finally
    mapStream.Free;
  end;
end;

function OpenMap(const Data: string): boolean;
var encURL: string;
begin
  //encodedURL:= Format(UrlGoogleQrCode,[Width,Height, C_Level, HTTPEncode(Data)]);
  encURL:= Format(UrlMapQuestAPICode2,['html',HTTPEncode(Data)]);
  try
   //HttpGet(EncodedURL, mapStream);   //WinInet
  Result:= UrlDownloadToFile(Nil,PChar(encURL),PChar(Exepath+'openmapx.html'),0,Nil)= 0;
  //OpenDoc(Exepath+'openmapx.html');
  S_ShellExecute(Exepath+'openmapx.html','',seCmdOpen);
  finally
    encURL:= '';
  end;
end;

function GetGeocodeCoord(C_form: string; const data:string; atxt: boolean): string;
 var encodURL, alat, alon: string;
    mapStream: TStringStream;
    xmlDoc: TXmlVerySimple; //TALXMLDocument;
    Nodes: TXmlNodeListSimple;
    Node: TXmlNodeSimple;
    i: integer;
 begin
   encodURL:= Format(UrlMapQuestAPICode2,[c_form,HTTPEncode(Data)]);
   mapStream:= TStringStream.create('');
   xmldoc:= TXmlVerySimple.create;
   try
     Wininet_HttpGet(EncodURL, mapStream);  {WinInet}
     //local tester
     //mapstream.writestring(loadstringfromfile(apath));
     mapStream.Position:= 0;
     //writeln('string stream size: '+inttostr(mapstream.size));
     //writeln('string stream cont: '+mapstream.datastring);
     {SaveStringtoFile(apath, mapStream.datastring) OpenDoc(apath); }
     xmlDoc.loadfromStream(mapstream);
     //writeln('childcounts: '+inttostr(xmlDoc.root.childnodes.count))
     if xmlDoc.root.childnodes.count > 0 then begin
       Nodes:= XmlDoc.Root.FindNodes('place');    //or result
       for i:= 0 to TXMLNodeListSimple(nodes).count-1 do begin
         //for Node in Nodes do
         Node:= TXMLNodeSimple(nodes.items[i]);
         alon:= node.attribute['lon'];
         alat:= node.attribute['lat'];
       end;
       if atxt then
         result:= 'GEOMapX Coordinates Topics found: '+(mapstream.datastring)+#13#10;
       result:= result+(#13#10+'latitude: '+alat+'  longitude: '
                   +alon+' of place: '+data+#13#10);
       Nodes.Free;
     end;
   finally
     encodURL:= '';
     mapStream.Free;
     xmlDoc.Free;
   end;
 end;



function  StreamtoString2( Source: TStream): string;
begin
SetLength( result, Source.Size);
if result <> '' then
  Source.ReadBuffer( result[1], Length( result) * SizeOf( AnsiChar))
end;

type TShowFmt = (sfNautical, sfStatute, sfMetric);

const
  OneEighty  = 180*3600;                         // Sec of arc
  ThreeSixty = 360*3600;                         //

function CoordinateStr(Idx: Integer; PosInSec: Double; PosLn: TNavPos): string;

const
  FmtStrArray: array[tLat..tLon, 0..3] of string =

 { Lat }  (('%s %d %.2d %.2d',  '%s %d %.2d.%4:.2d',     '%s %5:.4f',
               // D M S               D M.m                 D.d

                      '%1:.2d%2:.2d.%4:.2d,%0:s'),
                        //  Waypoint per NMEA

 { Lon }   ('%s %d %.2d %.2d',  '%s %d %.2d.%4:.2d',     '%s %5:.4f',

                      '%1:.3d%2:.2d.%4:.2d,%0:s'));

var
  Pos, Deg, Min, Sec, Dec: Integer;
  Dd: Double;
  C: Char;
begin
  if (PosInSec > OneEighty) then
    PosInSec := PosInSec - ThreeSixty;

  case PosLn of
    tLat: if (PosInSec <= 0) then C := 'S' else C := 'N';
    tLon: if (PosInSec <= 0) then C := 'W' else C := 'E';
  end; {case}

  PosInSec := Abs(PosInSec);
  Dd  := PosInSec/3600;                          // DDD.ddd..
  Pos := Round(PosInSec);
  Deg := (Pos div 3600);                         // DDD
  Min := (Pos mod 3600) div 60;                  // MM
  Sec := (Pos mod 60) mod 60;                    // SS
  Dec := Round(1.667*Sec);                       // mm
  Result := Format(FmtStrArray[PosLN, Idx], [C, Deg, Min, Sec, Dec, Dd]);
end;



function GetMapXGeoReverse(C_form:string; const lat,long: string): string;
 var encodedURL, UrlMapQuestAPI, bufstr: string;
    mapStream: TMemoryStream;
 begin
  UrlMapQuestAPI:= 'http://open.mapquestapi.com/nominatim/v1/reverse.php?format=%s&json_callback=renderExampleThreeResults&lat=%s&lon=%s';
  encodedURL:= Format(UrlMapQuestAPI,[c_form, lat, long]);
   mapStream:= TMemoryStream.create;
   try
    Wininet_HttpGet(EncodedURL, mapStream);  {WinInet}
    //Result:= UrlDownloadToFile(Nil,PChar(encodedURL),PChar(apath),0,Nil)= 0;
     mapStream.Position:= 0;
     maxform1.memo2.lines.add('stream size: '+inttostr(mapstream.size));
      //mapStream.readbuffer(bufstr, mapStream.Size);
      //mapStream.memory;
      result:= StreamToString2(mapstream);
      //mapstream.loadfromstream
     maxform1.memo2.lines.add('encodedURL: '+encodedURL);
    //OpenDoc(apath);
    //result:= bufstr;
  finally
    encodedURL:= '';
    mapStream.Free;
  end;
end;

 procedure CheckMemory;
  var MS:TMemoryStatus;
  begin
    GlobalMemoryStatus(MS);
    if MS.dwMemoryLoad>80 then begin
       MessageDlg(format('Aware:'#13#13'Only %d %% Memory free',
           [100-MS.dwMemoryLoad]),mtWarning,[mbOk],0);
//       Programmabbruch:=true;
//       Application.Terminate;
    end else
       MessageDlg(format('Still %d %% Memory free',
           [100-MS.dwMemoryLoad]),mtInformation,[mbOk],0);
  end;

  function GetMemoryInfo: string;
  var MS:TMemoryStatus;
  begin
    GlobalMemoryStatus(MS);
    if MS.dwMemoryLoad>80 then begin
       result:= (format('Be Aware:'#13#13'Only %d %% Memory free',
           [100-MS.dwMemoryLoad]));
//       Programmabbruch:=true;
//       Application.Terminate;
    end else
       result:=(format('Still %d %% RAM Memory free',
           [100-MS.dwMemoryLoad]));
  end;

  function GetMemoryData: integer;
  var MS:TMemoryStatus;
  begin
    GlobalMemoryStatus(MS);
      result:= 100-MS.dwMemoryLoad;
  end;



procedure SaveString(const AFile, AText: string);
begin
  with TFileStream.Create(AFile, fmCreate) do
  try
    WriteBuffer(AText[1], Length(AText));
  finally
    Free;
  end;
end;


function GetGeoCode(C_form,apath: string; const data: string; sfile: boolean): string;
 var encodURL, alat, alon: string;
    mapStream: TStringStream;
    xmlDoc: TXmlVerySimple; //TALXMLDocument;
    Nodes: TXmlNodeListSimple;
    Node: TXmlNodeSimple;
    it: integer;
 begin
   encodURL:= Format(UrlMapQuestAPICode2,[c_form,HTTPEncode(Data)]);
   mapStream:= TStringStream.create('');
   xmldoc:= TXmlVerySimple.create;
   try
     Wininet_HttpGet(EncodURL, mapStream);  {WinInet}
     //local tester
     //mapstream.writestring(loadstringfromfile(apath));
     mapStream.Position:= 0;
     //writeln('string stream size: '+inttostr(mapstream.size));
     //writeln('string stream cont: '+mapstream.datastring);
     if sfile then begin
      SaveString(apath, mapStream.datastring);
       //OpenDoc(apath);
       S_ShellExecute(apath,'',seCmdOpen);
     end;
     xmlDoc.loadfromStream(mapstream);
     //writeln('childcounts: '+inttostr(xmlDoc.root.childnodes.count))
     if xmlDoc.root.childnodes.count > 0 then begin
       Nodes:= XmlDoc.Root.FindNodes('place');    //or result
       for it:= 0 to TXMLNodeListSimple(nodes).count-1 do begin
         //for Node in Nodes do
         Node:= TXMLNodeSimple(nodes.items[it]);
         alon:= node.attribute['lon'];
         alat:= node.attribute['lat'];
       end;
       //result:= 'GEO Topic found: '+(node.text)+CRLF
       result:= result+('latitude: '+alat+'  longitude: '+alon);
       Nodes.Free;
     end;
   finally
     encodURL:= '';
     mapStream.Free;
     xmlDoc.Free;
   end;
 end;   

 
 Function getFileCount(amask: string): integer;
var
  DOSerr: integer;
  fsrch: TsearchRec;
begin
  result:= 0;
  doserr:= FindFirst(amask{'*.*'},faAnyFile, fsrch);
  if (DOSerr = 0) then begin
    while (DOSerr = 0) do begin
      if (fsrch.Attr and faDirectory) = 0 then inc(result);
      //writeln(searchRecName)
      DOSerr:= findNext(fsrch);
    end;
   sysutils.findClose(fsrch);
  end;
end;
                         

function DownloadFile(SourceFile, DestFile: string): Boolean;
begin
  //TCIPStatus //TBindStatus
  //TUrlTemplate
  //TUrlZoneReg of URLMon
  try
    Result:= UrlDownloadToFile(Nil,PChar(SourceFile),PChar(DestFile),0,Nil)= 0;
  except
    Result:= False;
  end;
end;

function DownloadFileOpen(SourceFile, DestFile: string): Boolean;
begin
  //TCIPStatus //TBindStatus
  //TUrlTemplate
  //TUrlZoneReg of URLMon
  try
    Result:= UrlDownloadToFile(Nil,PChar(SourceFile),PChar(DestFile),0,Nil)= 0;
     S_ShellExecute(DestFile,'',seCmdOpen);
  except
    Result:= False;
  end;
end;

procedure getScriptandRunAsk;
  var getstr, ascript: string;
  begin
   if IsInternet then begin
   ascript:= 'http://www.softwareschule.ch/examples/demoscript.txt';
   if InputQuery('Get Web Script4','Please enter a http script path ----------------------------------->',ascript) then
     begin
     //writeln('you entered: '+(string(ascript)));
    // wGet(ascript,'scriptdemo.txt');
     //writeln(ExtractFileNameOnly(ascript))
     //laz files
     getstr:= ExtractFileNameOnly(ascript)+'.txt';
     wGet(ascript,getstr);

    if MessageDlg('You want to run this script?'+#13#10+ascript+#13#10+#13#10+
                   'Runs a second instance of maXbox!',
            mtConfirmation,[mbYes,mbNo],0)=mrYes
    then begin
       //ShellExecute3
        maxForm1.memo2.lines.Add(' Web Script started: '+getStr+ ' at: '+timetostr(time));
        S_ShellExecute(ExePath+'maxbox4.exe',getstr,seCmdOpen);
        maxForm1.statusBar1.SimpleText:= ' Web Script finished: '+getStr;
        maxForm1.memo2.lines.Add(' Web Script finished: '+getStr+ ' at: '+timetostr(time));
        //statusline
    end else
      showmessage('Script start halted!');
     //www.softwareschule.ch/examples/demoscript.txt
    end;
   end else
         showmessage('No Web Connection available!');

  end;

  procedure getScriptandRun(ascript: string);
  var str3, getstr: string;
  begin
   //if InputQuery('Script please','please enter a script path', str3) then
     //writeln('you entered: '+(string(str3)));
     //writeln(floatToStr(single(PI)))
    // wGet(ascript,'scriptdemo.txt');
     //writeln(ExtractFileNameOnly(ascript))
     //laz files
     getstr:= ExtractFileNameOnly(ascript)+'.txt';
     wGet(ascript,getstr);
    if MessageDlg('You want to run this script?'+#13#10+ascript+#13#10+#13#10+
                   'Runs a second instance of maXbox!',
            mtConfirmation,[mbYes,mbNo],0)=mrYes
    then begin
        maxForm1.memo2.lines.Add(' Code Web Script started: '+getStr);
        S_ShellExecute(ExePath+'maxbox4.exe',getstr,seCmdOpen);
        maxForm1.memo2.lines.Add(' Code Web Script finished: '+getStr);
    end else
     showmessage('Script start halted!');
     //www.softwareschule.ch/examples/demoscript.txt
  end;

  procedure getBox(aurl, extension: string);
  var str3, getstr: string;
  begin
   //if InputQuery('Script please','please enter a script path', str3) then
     //writeln('you entered: '+(string(str3)));
     //writeln(floatToStr(single(PI)))
    // wGet(ascript,'scriptdemo.txt');
     //writeln(ExtractFileNameOnly(ascript))
     //laz files
     getstr:= ExtractFileNameOnly(aurl)+'.'+extension;
     wGet2(aurl,getstr);
    if MessageDlg('You want to run this Release?'+#13#10+aurl+#13#10+#13#10+
                   'Opens a file '+extension+ '  process instance of maXbox!',
            mtConfirmation,[mbYes,mbNo],0)=mrYes
    then begin
        maxForm1.memo2.lines.Add(' maXbox Release started: '+getStr);
        SearchAndOpenDoc(getstr);
        maxForm1.memo2.lines.Add(' maXbox Release finished: '+getStr);
    end else
     showmessage('Version script run start halted!');
     //www.softwareschule.ch/examples/demoscript.txt
  end;


{function IsInternetConnected: Boolean;
begin
  if InternetGetConnectedState(nil, 0) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;}

procedure CopyEXIF(const FileNameEXIFSource, FileNameEXIFTarget: string);
const
  M_JFIF = $E0;
  M_EXIF = $E1;
var
  MSSource, MSTarget: TMemoryStream;
  FS: TFileStream;
  TargetStartPos, SourceEndPos: Longint;
  Buf: Array [0..3] of Byte;
begin
  MSTarget := TMemoryStream.Create;
  try
// 4. Lies dann Deine veränderte jpeg-Datei in den MemoryStream.
    TargetStartPos := 2;
    MSTarget.LoadFromFile(FileNameEXIFTarget);
    MSTarget.Seek(TargetStartPos, soFromBeginning);
    MSTarget.Read(Buf, 4);
    if Buf[1] = M_JFIF then begin
      TargetStartPos := TargetStartPos+(Buf[2]*256)+Buf[3]+2;
      MSTarget.Seek(TargetStartPos, soFromBeginning);
      MSTarget.Read(Buf, 4);
    end;
    if (Buf[1] <> M_EXIF) or
       (MessageDLG('Die Datei '''+FileNameEXIFTarget+''' hat selbst ein EXIF! Soll dieser wirklich überschrieben werden?',
                   mtConfirmation, [mbYes,mbNo], 0) = mrYes) then begin
      if Buf[1] = M_EXIF then TargetStartPos:= TargetStartPos+(Buf[2]*256)+Buf[3]+2;

      MSSource := TMemoryStream.Create;
      try
// 1. Lies aus Deiner originalen jpeg-Datei die Größe der EXIF-Struktur aus (steht in den Bytes unmittelbar nach dem EXIF-StartTag "FFE1" und reicht bis zur Kennung "786969660000" = "Exif").
        SourceEndPos := 2;
        MSSource.LoadFromFile(FileNameEXIFSource);
        MSSource.Seek(SourceEndPos, soFromBeginning);
        MSSource.Read(Buf, 4);
        if Buf[1] = M_EXIF then SourceEndPos := SourceEndPos+(Buf[2]*256)+Buf[3]+2;
// 2. Lies die originale jpeg-Datei in einen MemoryStream. Setze die Größe des MemoryStreams zurück auf die Größe der EXIF-Struktur zuzüglich der 4 führenden Kennbytes der jpeg-Datei (FFD8 und FFE1).
        MSSource.SetSize(SourceEndPos);

// 3. Übertrage den MemoryStream in den FileStream, der Deine neue jpeg-Datei anlegt, welche sowohl Dein verändertes jpeg-Bild als auch die ursprüngliche EXIF-Information aufnehmen soll.
        FS := TFileStream.Create(FileNameEXIFTarget, fmCreate or fmShareExclusive);
        try
          MSSource.SaveToStream(FS);

// 5. Setze den Pointer des MemoryStreams auf die Position $02 (also ab dem 3.Byte, d.h. ohne die JPEG-Kennung "FFD8" der zweiten Datei) und übertrage den MemoryStream ab dieser Position in den zuvor begonnenen Filestream.
          MSTarget.Seek(TargetStartPos, soFromBeginning);
          FS.CopyFrom(MSTarget, MSTarget.Size-TargetStartPos);
        finally
          FS.Free;
        end;
      finally
        MSSource.Free;
      end
    end;
  finally
    MSTarget.Free;
  end;
end;



 
{function getProcessAllMemory(ProcessID : DWORD): TProcessMemoryCounters;
var ProcessHandle : THandle;
    //MemCounters   : TProcessMemoryCounters;
    //ppsmemCounters: PPROCESS_MEMORY_COUNTERS;
    MemCounters: PPROCESS_MEMORY_COUNTERS;
begin
  //Result:= NULL;
  ProcessHandle:= OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,
                               false, ProcessID);
  try
    if GetProcessMemoryInfo(ProcessHandle,
                            //PPROCESS_MEMORY_COUNTERS(MemCounters),
                            memCounters,
                            sizeof(MemCounters))
    then Result:= TProcessMemoryCounters(MemCounters^);
  finally
    CloseHandle(ProcessHandle);
  end;
end;}

{procedure CopytoFile(sender: TObject);
begin
  TListBox(sender).items.savetofile(exepath+'mXfileChangeToday_list.txt');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'mXfileChangeToday_list.txt')
  //Exepath
end;}


//ChangeOEPFromFile('notepad.exe', 'fixed.exe');



function ChangeOEPFromBytes(bFile:mTByteArray):Boolean;
var
  dOEP: DWORD;
  dCodePos: DWORD;
  IDH:    TImageDosHeader;
  INH:    TImageNtHeaders;
  ISH:    TImageSectionHeader;
begin
  Result := TRUE;
  try
    CopyMemory(@IDH, @bFile[0], SizeOf(IDH));
    if not IDH.e_magic = IMAGE_DOS_SIGNATURE then
      Exit;

    CopyMemory(@INH, @bFile[IDH._lfanew], SizeOf(INH));
    if not INH.Signature = IMAGE_NT_SIGNATURE then
      Exit;

    CopyMemory(@ISH, @bFile[IDH._lfanew + SizeOf(INH)], SizeOf(ISH));
    dOEP := INH.OptionalHeader.AddressOfEntryPoint + INH.OptionalHeader.ImageBase;
    dCodePos := ISH.Misc.VirtualSize + ISH.PointerToRawData;
    INH.OptionalHeader.AddressOfEntryPoint := dCodePos + INH.OptionalHeader.BaseOfCode - ISH.PointerToRawData;
    CopyMemory(@bFile[IDH._lfanew], @INH, SizeOf(INH));
    ISH.Misc.VirtualSize := ISH.SizeOfRawData;
    CopyMemory(@bFile[IDH._lfanew + SizeOf(INH)], @ISH, SizeOf(ISH));

    bFile[dCodePos] := $68;
    CopyMemory(@bFile[dCodePos + 1], @dOEP, $4);
    bFile[dCodePos + 5] := $C3;
  except
    Result := FALSE;
  end;
end;


function ChangeOEPFromFile(sFile:string; sDestFile:string):Boolean;
var
  hFile:    THandle;
  dSize:    DWORD;
  dRead:    DWORD;
  dWritten: DWORD;
  bFile:    mTByteArray;
begin
  Result := FALSE;
  hFile := CreateFile(PChar(sFile), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    dSize:= windows.GetFileSize(hFile, nil);
    SetLength(bFile, dSize);
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    ReadFile(hFile, bFile[0], dSize, dRead, nil);
    CloseHandle(hFile);

    if (ChangeOEPFromBytes(bFile)) and (dSize = dRead) then
    begin
      if sDestFile = '' then
        sDestFile := sFile;
      hFile := CreateFile(PChar(sDestFile), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);
      if hFile <> INVALID_HANDLE_VALUE then
      begin
        SetFilePointer(hFile, 0, nil, FILE_BEGIN);
        WriteFile(hFile, bFile[0], dSize, dWritten, nil);
        CloseHandle(hFile);
        Result := TRUE;
      end;
    end;
  end;
end;


type
   TDBEventHandlers = class // create a dummy class
       class procedure ClickinListbox(Sender: TObject) ;
   end;


class procedure TDBEventHandlers.ClickinListbox(sender: TObject);
var idx: integer;
    FileName, getStr, firsts: string;
    //lstbox: TListBox;
begin
  idx:= TListbox(sender).itemindex;
  //memo2.lines.add(lbintflist.items[idx]); debug
  TListbox(sender).hint:= TListbox(sender).Items[idx];
  TListbox(sender).showhint:= true;
    FileName:= TListbox(sender).Items[idx];
    {delete(Filename,1,3);
    delete(filename,pos('.',filename)+4,22);
     if pos(' ',filename) > 0 then
        delete(filename,1,1);}

     firsts:= Copy2SymbDel(filename, ' ');
     //writeln(checkstr);
     filename:= Copy2SymbDel(filename, ' ');
     //writeln(seconds);

  //showmessage(extractfilepath(filename));
    //   getstr:= ExtractFileNameOnly(ascript)+'.txt';
  //showmessage(extractfilenameonly(filename));
 //if fileexists(TListbox(sender).Items[idx]) then begin
 if fileexists(filename) then begin
    //FileName:= TListbox(sender).Items[idx];
    //showmessage(extractfilepath(filename));
    showmessage(filename);
    ShellAPI.ShellExecute(HInstance, NIL, pchar('"'+FileName+'"'), NIL, NIL, sw_ShowNormal);
  end else
    Showmessage('Sorry, filepath to '+Filename+' is missing or incorrect')
  //memo1.SetFocus;
  //listbox1.items[idx]:= temp;
  //listbox1.ItemIndex:= idx;
end;



function CreateDBGridForm(dblist: TStringList): TListBox;
var
   dbform: TForm;
  alistView: TListBox;

{  procedure TDBEventHandlers.ClickinListbox;
var idx: integer;
    FileName: string;
    //lstbox: TListBox;
begin
  idx:= alistView.itemindex;
  //memo2.lines.add(lbintflist.items[idx]); debug
  alistView.hint:= alistView.Items[idx];
  alistView.showhint:= true;
 if fileexists(alistView.Items[idx]) then begin
    FileName:= alistView.Items[idx];
    ShellAPI.ShellExecute(HInstance, NIL, pchar(FileName), NIL, NIL, sw_ShowNormal);
  end else
    Showmessage('Sorry, filepath to '+filename+' is missing')
  //memo1.SetFocus;
  //listbox1.items[idx]:= temp;
  //listbox1.ItemIndex:= idx;
end; }

  begin
   dbform:= CreateMessageDialog('My Fast Form File Finder Converter - FFC',mtwarning,
                                        [mball, mbyes, mbhelp, mbok]);
   dbform.caption:= 'File Changes Today in maXbox Dir: exepath List: '+exepath;
   dbform.setBounds(50,50,1000,800);
   dbform.Formstyle:= fsStayontop;
   dbform.Color:= 123;
   with TLabel.Create(dbform) do begin
     parent:= dbform;
     SetBounds(40,90,500,200);
     font.size:= 17;
     font.color:= clyellow;
     dblist.Add('File Changes of Today in maXbox Dir of: '+DatetoStr(date));
     dblist.Add('Save and open content in mXfileChangeToday_list.txt');
    caption:= dblist.text;
   end;

   alistView:= TListBox.Create(dbform);
     with alistView do begin
     parent:= dbform;
     font.size:= 12;
     scrollWidth:= 1400;
     //ondblclick:= CopytoFile;
     //onDblClick:=  TNotifyEvent(ClickinListbox);
     onDblClick:=  TDBEventHandlers.ClickinListbox;
      // items.savetofile(exepath+'mXfileChangeToday_list.txt');
     SetBounds(40,155,900,592)
   end;
   result:= alistView;
   dbform.Show;
   //searchAndOpenDoc(ExePath+'mXfileChangeToday_list.txt');
   //dbform.Free;
   //Tdataset
end;



function GetIsAdmin: Boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
  SE_GROUP_ENABLED = $00000004;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  Result   := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken);
  if not bSuccess then
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken);
  if bSuccess then
  begin
    GetTokenInformation(hAccessToken, TokenGroups, nil, 0, dwInfoBufferSize);
    ptgGroups := GetMemory(dwInfoBufferSize);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, dwInfoBufferSize, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdministrators);
      for x := 0 to ptgGroups.GroupCount - 1 do
      begin
        if (SE_GROUP_ENABLED = (ptgGroups.Groups[x].Attributes and SE_GROUP_ENABLED)) and EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
      end;
      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;



procedure ShowMemory;
var MS: TMemoryStatus;
    z:string;
    i:integer;
begin
  GlobalMemoryStatus(MS);
  i:=MS.dwTotalPhys - MS.dwAvailPhys; // =benutzer physikalischer Speicher
  z:=FormatFloat('#,###" MB"', i / (1024*1024));
  z:=z+#13#10+FormatFloat('#,###" KB"', i / 1024);
  z:=z+#13#10+FormatFloat('#,###" Bytes"', i);
  ShowMessage(z);
end;

function ShowMemory2: string;
var MS: TMemoryStatus;
    z:string;
    i:integer;
begin
  GlobalMemoryStatus(MS);
  i:=MS.dwTotalPhys - MS.dwAvailPhys; // =benutzer physikalischer Speicher
  z:=FormatFloat('mX4: #,###" MB"', i / (1024*1024));
  z:=z+#13#10+FormatFloat('#,###" KB"', i / 1024);
  z:=z+#13#10+FormatFloat('#,###" Bytes"', i);
  //ShowMessage(z);
  result:= z;
end;


 Procedure Check4CDROM(var Anzahl, Erstes: word); assembler;
asm
  mov ax, 1500h
  xor bx, bx
  int $2f
  //les di, Anzahl
  mov es:[di], bx
  //les di, Erstes
  mov es:[di], cx
end;

Function IstCDrom(LW : Char):BOOLEAN;
Var I, Anzahl,Erstes : word;
begin
  Result := false;
  Check4CDROM(Anzahl,Erstes);
  if Anzahl > 0 then
    for I := 0 to (Anzahl-1) do
      If char(Erstes + Byte('A') + I) = upcase(LW)
         Then Result := True;
end;


 procedure SaveBytesToFile2(const Data: Sysutils.TBytes; const FileName: string);
var
  stream: TMemoryStream;
begin
  stream := TMemoryStream.Create;
  try
    if length(data) > 0 then
      stream.WriteBuffer(data[0], length(data));
    stream.SaveToFile(FileName);
  finally
    stream.Free;
  end;
end;

Procedure ConvertToGray(Cnv: TCanvas);
Var X, Y: Integer;
    Color: LongInt;
    R, G, B, Gr: Byte;
    T0: tdateTime;
Begin
  T0:= Time;
  With Cnv Do
    For X:= Cliprect.Left To ClipRect.Right Do
      For Y := Cliprect.Top To ClipRect.Bottom Do begin
        Color := ColorToRGB(Pixels[X,Y]);
        B  := (Color And $FF0000) Shr 16;
        G  := (Color And $FF00) Shr 8;
        R  := (Color And $FF);
        Gr := HiByte(R*77+G*151+B*28);(* GR := Trunc(B*0.11+G*0.59+R*0.3);*)
        Pixels[X,Y] := RGB(Gr,Gr,Gr);
      End;
  ShowMessage(IntToStr(Trunc((Time-T0)*24*60*60*10)));
End;



Procedure HideWindowForSeconds(secs: integer);   {//3 seconds}
Var T : tdateTime;
begin
  //ShowWindow(Self.Handle, SW_Hide);
  ShowWindow(Forms.Application.Handle, SW_Hide);
  T:= Time;
  Repeat
    Forms.Application.ProcessMessages;
  Until Time - T > secs / 24 / 3600;
  //ShowWindow(Self.Handle, SW_Show);
  ShowWindow(Forms.Application.Handle, SW_Show);
end;

Procedure HideWindowForSeconds2(secs: integer; apphandle, aself: TForm);   {//3 seconds}
Var T : tdateTime;
begin
  ShowWindow(aSelf.Handle, SW_Hide);
  ShowWindow(Forms.Application.Handle, SW_Hide);
  T:= Time;
  Repeat
    Forms.Application.ProcessMessages;
  Until Time - T > secs / 24 / 3600;
  ShowWindow(aSelf.Handle, SW_Show);
  ShowWindow(Forms.Application.Handle, SW_Show);
end;


function Base64Decode(const EncodedText: string): TBytes;
var
  DecodedStm: TBytesStream;
  Decoder: TIdDecoderMIME;
  abytes: sysutils.TBytes;
begin
  Decoder := TIdDecoderMIME.Create(NIL);
  try
    DecodedStm := TBytesStream.Create(abytes);
    try
      {Decoder.DecodeBegin(DecodedStm);
      Decoder.Decode(EncodedText);
      Decoder.DecodeEnd;
      Result := DecodedStm.Bytes;  }
    finally
      DecodedStm.Free;
    end;
  finally
    Decoder.Free;
  end;
end;

 function GetASCIILine: string;
 var i: integer;
 begin
  for i:= 1 to 255 do
    result:= result +Chr(i)
 end;

  function RoundEx(x: Extended): Integer;
  begin
    Result := Trunc(x) + Trunc(Frac(x) * 2);
  end;

function JavahashCode(val: string): Integer;
var
  i: Integer;
  res: Extended;
  x: Integer;
begin
  res:= 0;
  for i:= 1 to Length(val) do begin
    res:= res + Ord(val[i]) * Power(31, Length(val)-(i-1)-1);
  end;
  Result:= RoundEx(res);
end;


type
  PULARGE_INTEGER = ^LARGE_INTEGER;
  LARGE_INTEGER = packed record
    case Integer of
    0: (
      LowPart: DWORD;
      HighPart: Longint);
    1: (
      QuadPart: LONGLONG);
  end;


function getDiskSpace2(const path: String; index: int): int64;
var
  dir: String;
  res: bool;
  savail,
  total,
  free: ULARGE_INTEGER;
begin
  if (1 < length(path)) then begin
    //
    if (':' = path[2]) then
      dir := copy(path, 1, 3)
    else
      dir := path;
    //
      res:= GetDiskFreeSpaceExA(pChar(String(dir)), savail, total, pLARGEINTEGER(@free));
    //
    if (res) then begin
      //
      case (index) of
 	0: result := savail.QuadPart;
	1: result := total.QuadPart;
	2: result := free.QuadPart;
 	else
	  result := -1;
      end;
    end
    else
      result := -1;
  end
  else
    result := -1;    
end;



procedure PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean);
{************************************************************
* Procedure PostKeyEx32
*
* Parameters:
*  key    : virtual keycode of the key to send. For printable
*           keys this is simply the ANSI code (Ord(character)).
*  shift  : state of the modifier keys. This is a set, so you
*           can set several of these keys (shift, control, alt,
*           mouse buttons) in tandem. The TShiftState type is
*           declared in the Classes Unit.
*  specialkey: normally this should be False. Set it to True to
*           specify a key on the numeric keypad, for example.
* Description:
*  Uses keybd_event to manufacture a series of key events matching
*  the passed parameters. The events go to the control with focus.
*  Note that for characters key is always the upper-case version of
*  the character. Sending without any modifier keys will result in
*  a lower-case character, sending it with [ssShift] will result
*  in an upper-case character!
// Code by P. Below
************************************************************}
type
  TShiftKeyInfo = record
    shift: Byte;
    vkey: Byte;
  end;
  byteset = set of 0..7;
const
  shiftkeys: array [1..3] of TShiftKeyInfo =
    ((shift: Ord(ssCtrl); vkey: VK_CONTROL),
    (shift: Ord(ssShift); vkey: VK_SHIFT),
    (shift: Ord(ssAlt); vkey: VK_MENU));
var
  flag: DWORD;
  bShift: ByteSet absolute shift;
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0), 0, 0);
  end; { For }
  if specialkey then
    flag := KEYEVENTF_EXTENDEDKEY
  else
    flag := 0;

  keybd_event(key, MapvirtualKey(key, 0), flag, 0);
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event(key, MapvirtualKey(key, 0), flag, 0);

  for i := 3 downto 1 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0),
        KEYEVENTF_KEYUP, 0);
  end; { For }
end; { PostKeyEx32 }




procedure StartWeb(aurl: string);
begin
  if getIPHostbyName(MXINTERNETCHECK) > '0' then
   //if (GetHostByName('www.ask.com')) > '0' then
    ExecuteCommand(aurl,'') else
    showmessage('please run internet first - not connected');
end;


 procedure StrReplace(var Str: String; Old, New: String);
begin
  Str := StringReplace(Str, Old, New, [rfReplaceAll]);
end;

procedure StartSocketServiceForm;
begin
    SvcMgr.Application.Initialize;
    SocketService:= TSocketService.CreateNew(SvcMgr.Application, 0);
    SvcMgr.Application.CreateForm(TSocketForm, SocketForm);
    SvcMgr.Application.Run;
    //SvcMgr.TService;
    //timesetevent
end;


function StartSocketService: Boolean;
var
  Mgr, Svc: Integer;
  UserName, ServiceStartName: string;
  Config: Pointer;
  Size: DWord;
begin
  Result := False;
  Mgr := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if Mgr <> 0 then begin
    Svc := OpenService(Mgr, PChar(SServiceName), SERVICE_ALL_ACCESS);
    Result := Svc <> 0;
    if Result then begin
      QueryServiceConfig(Svc, nil, 0, Size);
      Config := AllocMem(Size);
      try
        QueryServiceConfig(Svc, Config, Size, Size);
        ServiceStartName := PQueryServiceConfig(Config)^.lpServiceStartName;
        if CompareText(ServiceStartName, 'LocalSystem') = 0 then
          ServiceStartName := 'SYSTEM';
      finally
        Dispose(Config);
      end;
      CloseServiceHandle(Svc);
    end;
    CloseServiceHandle(Mgr);
  end;
  if Result then begin
    Size := 256;
    SetLength(UserName, Size);
    GetUserName(PChar(UserName), Size);
    SetLength(UserName, StrLen(PChar(UserName)));
    Result := CompareText(UserName, ServiceStartName) = 0;
  end;
  //stringtowidechar
  //val
end;


function GetFileList(FileList: TStringlist; apath: string): TStringlist;
var SearchRec:TSearchRec;
    Found:integer;
begin
  FileList.Clear;
  try
      Found:= FindFirst(apath, faAnyFile-faDirectory, SearchRec);
      while Found=0 do begin
            FileList.Add(SearchRec.Name);
            Found:=FindNext(SearchRec);
      end;
  finally
      Sysutils.FindClose(SearchRec);
  end;
  FileList.Sort;
  result:= FileList;
end;

function GetFileList1(apath: string): TStringlist;
var SearchRec:TSearchRec;
    Found:integer;
    //filelist: TStringlist;
begin
  result:= TStringlist.create;
  result.Clear;
  try
      Found:= FindFirst(apath, faAnyFile-faDirectory, SearchRec);
      while Found=0 do begin
            result.Add(SearchRec.Name);
            Found:=FindNext(SearchRec);
      end;
  finally
      Sysutils.FindClose(SearchRec);
  end;
  result.Sort;
  //result:= FileList;
end;

procedure LetFileList(FileList: TStringlist; apath: string);
var SearchRec:TSearchRec;
    Found:integer;
begin
  FileList.Clear;
  try
      Found:= FindFirst(apath, faAnyFile-faDirectory, SearchRec);
      while Found=0 do begin
            FileList.Add(SearchRec.Name);
            Found:=FindNext(SearchRec);
      end;
  finally
      Sysutils.FindClose(SearchRec);
  end;
  FileList.Sort;
end;

procedure FindAllFilesToday(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
  myDosdate: TDateTime;
  year, year1, month, month1, day, day1: word;

begin
  decodeDate(date, year1, month1, day1);
  if StartDir[length(StartDir)] <> '\' then
                       StartDir:= StartDir + '\';
  { Build a list of the files in directory StartDir (not the directories!)}
  IsFound:= FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    myDosdate:= fileDatetoDateTime(Sr.time);
    decodedate(mydosdate, year, month, day);
    if (day = day1) and (month = month1) and (year = year1) then
       FilesList.Add(StartDir + Sr.Name + ' '+DateTimeToStr(mydosdate));// + DateTimetoStr(mydosdate));
    IsFound:= FindNext(SR) = 0;
  end;
  Sysutils.FindClose(SR);
  //Build a list of subdirectories
  DirList:= TStringList.Create;
    IsFound:= FindFirst(StartDir+'*.*', faAnyFile,SR) = 0;
    while IsFound do begin
      if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
           DirList.Add(StartDir + SR.Name);
      IsFound:= FindNext(SR) = 0;
      end;
    sysutils.FindClose(SR);
  //Scan the list of subdirectories recursive!
  for i:= 0 to DirList.Count - 1 do
    FindAllFilesToday(FilesList, DirList[i], FileMask);
   DirList.Free;
end;

function GetTodayFiles(startdir, amask: string): TStringlist;
var
  FilesList: TStringList;
begin
  FilesList:= TStringList.Create;
  try
    FindAllFilesToday(FilesList, startdir, amask);
    fileslist.add(formatdatetime('"mX4 Find of '+startdir+' from:" dd:mm:yyyy',date));
    fileslist.add(formatdatetime('"mX4 Datfinder all files of '+amask+' from:" dd:mm:yyyy',date));
    //fileslist.saveToFile(ExePath+'Examples\datefindlist.txt');
  finally
    result:= fileslist;
    //FilesList.Free;
  end;
end;

function PortTCPIsOpen(dwPort : Word; ipAddressStr: String): boolean;
var
  client : sockaddr_in;
  sock   : Integer;
  ret    : Integer;
  wsdata : WSAData;
begin
 Result:=False;
 ret := WSAStartup($0002, wsdata); //initiates use of the Winsock DLL
  if ret<>0 then exit;
  try
    client.sin_family      := AF_INET;  //Set the protocol to use , in this case (IPv4)
    client.sin_port        := htons(dwPort); //convert to TCP/IP network byte order (big-endian)
    client.sin_addr.s_addr := inet_addr(PAnsiChar(ipAddressStr));  //convert to IN_ADDR  structure
    sock  :=socket(AF_INET, SOCK_STREAM, 0);    //creates a socket
    Result:=connect(sock,client,SizeOf(client))=0;  //establishes a connection to a specified socket
  finally
  WSACleanup;
  end;
end;

 function PortTCPIsOpen2(dwPort : Word; ipAddressStr:string) : boolean;
    var
      client : sockaddr_in;//sockaddr_in is used by Windows Sockets to specify a local or remote endpoint address
      sock   : Integer;
      ret    : Integer;
      wsdata : WSAData;
   begin
   ret := WSAStartup($0002, wsdata);//initiates use of the Winsock
   if ret<>0 then exit;

        client.sin_family      := AF_INET;
        client.sin_port        := htons(dwPort);//htons converts a u_short from host to TCP/IP network byte order.
        client.sin_addr.s_addr := inet_addr(PChar(ipAddressStr)); //the inet_addr function converts a string containing an IPv4 dotted-decimal address into a proper address for the IN_ADDR structure.
        sock  :=socket(AF_INET, SOCK_STREAM, 0);//The socket function creates a socket
        Result:=connect(sock,client,SizeOf(client))=0;//establishes a connection to a specified socket.
     WSACleanup; //terminates use of the Winsock
   end;


procedure WinInet_HttpGet(const Url: string; Stream:TStream);
const
BuffSize = 1024*1024;
var
  hInter   : HINTERNET;
  UrlHandle: HINTERNET;
  BytesRead: DWORD;
  Buffer   : Pointer;
begin
  hInter := InternetOpen('', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hInter) then
  begin
    Stream.Seek(0,0);
    GetMem(Buffer,BuffSize);
    try
        UrlHandle := InternetOpenUrl(hInter, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);
        if Assigned(UrlHandle) then
        begin
          repeat
            InternetReadFile(UrlHandle, Buffer, BuffSize, BytesRead);
            if BytesRead>0 then
             Stream.WriteBuffer(Buffer^,BytesRead);
          until BytesRead = 0;
          InternetCloseHandle(UrlHandle);
        end;
    finally
      FreeMem(Buffer);
    end;
    InternetCloseHandle(hInter);
  end
end;

function HttpGetDirect(const Url: string): string;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1024] of Char;
  BytesRead: dWord;
begin
  Result := '';
  //NetHandle := InternetOpen('Delphi 5.x', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  NetHandle := InternetOpen('', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then  { UrlHandle valid? Proceed with download }
    begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        Result := Result + Buffer;
        FillChar(Buffer, SizeOf(Buffer), 0);
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
      until BytesRead = 0;
      InternetCloseHandle(UrlHandle);
    end
    else
      { UrlHandle is not valid. Raise an exception. }
      raise Exception.CreateFmt('Cannot open URL %s', [Url]);

    InternetCloseHandle(NetHandle);
  end else
    { NetHandle is not valid. Raise an exception }
    raise Exception.Create('Unable to initialize Wininet');
end;

Const
   UrlGoogleQrCode='http://chart.apis.google.com/chart?chs=%dx%d&cht=qr&chld=%s&chl=%s';


procedure GetQrCode2(Width,Height: Word; Correct_Level: string;
           const Data:string; apath: string);
var
  encodedURL: string;
  idhttp: TIdHttp;// THTTPSend;
  //png: TLinearBitmap;//TPNGObject;
  pngStream: TMemoryStream;
begin
  encodedURL:= Format(UrlGoogleQrCode,[Width,Height, Correct_Level, HTTPEncode(Data)]);
  //WinInet_HttpGet(EncodedURL,StreamImage);
  idHTTP:= TIdHTTP.Create(NIL);
  pngStream:= TMemoryStream.create;
  with TLinearBitmap.Create do try
    idHTTP.Get(EncodedURL, pngStream);
    pngStream.Position:= 0;
    LoadFromStream(pngStream,'PNG');
    //aImage.Picture:= NIL;
    //AssignTo(aimage.picture.bitmap);
    SaveToFile(apath);
    SearchAndOpenDoc(apath);
  finally
    Dispose;
    Free;
    idHTTP.Free;
    pngStream.Free;
  end;
end;

procedure GetQrCode3(Width,Height: Word; Correct_Level: string;
           const Data:string; apath: string);
var
  encodedURL: string;
  idhttp: TIdHttp;// THTTPSend;
  pngStream: TMemoryStream;
begin
  encodedURL:= Format(UrlGoogleQrCode,[Width,Height, Correct_Level, HTTPEncode(Data)]);
  //WinInet_HttpGet(EncodedURL,StreamImage);
  idHTTP:= TIdHTTP.Create(NIL);
  pngStream:= TMemoryStream.create;
  with TLinearBitmap.Create do try
    idHTTP.Get(EncodedURL, pngStream);
    pngStream.Position:= 0;
    LoadFromStream(pngStream,'PNG');
    //aImage.Picture:= NIL;
    //AssignTo(aimage.picture.bitmap);
    SaveToFile(apath);
    //SearchAndOpenDoc(apath);
  finally
    Dispose;
    Free;
    idHTTP.Free;
    pngStream.Free;
  end;
end;

function GetQrCode4(Width,Height: Word; Correct_Level: string;
           const Data:string; aformat: string): TLinearBitmap;
var
  encodedURL: string;
  idhttp: TIdHttp;// THTTPSend;
  png: TLinearBitmap;//TPNGObject;
  pngStream: TMemoryStream;
begin
  encodedURL:= Format(UrlGoogleQrCode,[Width,Height, Correct_Level, HTTPEncode(Data)]);
  //WinInet_HttpGet(EncodedURL,StreamImage);
  idHTTP:= TIdHTTP.Create(NIL);
  pngStream:= TMemoryStream.create;
  png:= TLinearBitmap.Create;
  with png do try
    idHTTP.Get(EncodedURL, pngStream);
    pngStream.Position:= 0;
    LoadFromStream(pngStream,aformat);
    //AssignTo(aimage.picture.bitmap);
    result:= png;
  finally
    //Dispose;
    //Free;
    idHTTP.Free;
    pngStream.Free;
  end;
end;



//*************************************************************SMTP
// this procedure works!!
// maybe you don't need last line  mMessage:= Unassigned; cause of ref garbage

const MAILINIFILE = 'maildef.ini';


procedure SendEmail(mFrom,  mTo,  mSubject,  mBody,  mAttachment: variant);
var  schema: string;
     mMessage, mconfig: Variant;
   deflist: TStringlist;
     filepath, fN: string;

begin
  {var smtpServer = "smtp.gmail.com";
   var smtpPort = 587 //465;
   var userLogin = "USER_LOGIN"; // e.g. "abc" if the address is abc@gmail.com
  var userPassword = "USER_PASSWORD";
   var autentificationType = 1; // cdoBasic
   var connectionTimeout = 30;
   // Required by Gmail
   var useSSL = true; }

    mMessage:= CreateOleObject('CDO.Message');
    mConfig:= CreateOleObject('CDO.Configuration');
    deflist:= TStringlist.create;
    filepath:= ExePath;

  try
    fN:= filepath+ MAILINIFILE;
    if fileexists(fN) then begin
      deflist.LoadFromFile(fN);
      {vhost:= deflist.Values['HOST'];
      vuser:= deflist.Values['USER'];
      vpass:= deflist.Values['PASS'];
      vbody:= deflist.Values['BODY'];
      vport:= strtoint(deflist.values['PORT']);
      vlast:= strToInt(deflist.Values['LAST']); }

    schema:= 'http://schemas.microsoft.com/cdo/configuration/';
    //cdoPostUsingPort = $00000002;.
    mConfig.Fields.Item(schema + 'sendusing'):= 2; //2; // cdoSendUsingPort, cdoPostUsingPort
    mConfig.Fields.Item(schema + 'smtpserver'):=  deflist.Values['HOST']; //'mail.hover.com';//'smtp.gmail.com';
    maxForm1.memo2.lines.Add('Host: '+deflist.Values['HOST']);
    mConfig.Fields.Item(schema + 'smtpserverport'):= strtoint(deflist.values['PORT']);//465;  //  25; //587; //465 ssl;
    maxForm1.memo2.lines.Add('Port: '+deflist.Values['PORT']);
    mConfig.Fields.Item(schema + 'sendusername'):= deflist.Values['USER']; //'max@kleiner.com';
    maxForm1.memo2.lines.Add('User: '+deflist.Values['USER']);

    mConfig.Fields.Item(schema + 'sendpassword'):= deflist.Values['PASS']; //'';
    mConfig.Fields.Item(schema + 'smtpauthenticate'):= 1;
    if deflist.Values['SSL']='Y' then begin
        mConfig.Fields.Item(schema + 'smtpusessl'):= True;
        maxForm1.memo2.lines.Add('SSL in Use: '+deflist.Values['SSL']);
    end;
    mConfig.Fields.Item(schema + 'smtpconnectiontimeout'):= 30;
    mConfig.Fields.Update;
   { with MConfig.Configuration.Fields do begin
    Item[s + 'sendusing']:= cdoPostUsingPort;
    Item[s + 'smtpserver']:= 'smtp.host.com';
    Item[s + 'smtpauthenticate']:= cdoBasic;
    Item[s + 'sendusername']:= 'user_name';
    Item[s + 'sendpassword']:= 'password';
    Item[s + 'smtpserverport']:= 587;
    Item[s + 'smtpusessl']:= False;
    Item[s + 'smtpconnectiontimeout']:= 5;  // default is 30 seconds
    Update;
  end;}

    mMessage.Configuration:= mConfig;
    maxForm1.memo2.lines.Add('got your email settings from '+MAILINIFILE);
    mMessage.From:= mFrom;
    mMessage.To:= mTo;   //dont work cause of late binding, <to> is keyword!
    //mMessage.CC:= mTo;
    mMessage.Subject:= mSubject;
    mMessage.HTMLBody:= mBody;
     //if (0 < mAttachment.length) then
      //mMessage.AddAttachment(mAttachment);
     mMessage.Send;
   maxForm1.memo2.lines.Add('Log.Message(Message to <' + mTo +  '> was successfully sent);');
  end else
    maxForm1.memo2.lines.Add('important: set email settings in '+MAILINIFILE);
  Except
     on E: Exception do begin
      ShowMessage(E.Message);
     maxForm1.memo2.lines.Add('Log.Error("E-mail cannot be sent", exception.description)');
     maxForm1.memo2.lines.Add('important: put your email settings in '+MAILINIFILE)
     end;
     //result:= false;
   end;
  //return true;  *)
  mConfig:= unassigned;
  mMessage:= Unassigned;
  deflist.Free;
  //if mConfig <> ''  then
end;

const
  REG_KEY_TEAMVIEWER8 = '\SOFTWARE\Wow6432Node\TeamViewer\Version8';
  REG_VAL_CLIENTID = 'ClientID';


function getTeamViewerID: string;
var
  Reg: TRegistry;
  TeamViewerID: String;
begin
  TeamViewerID:='';
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REG_KEY_TEAMVIEWER8, False) then
    begin
      TeamViewerID:=Format('%d',[Reg.ReadInteger(REG_VAL_CLIENTID)]);
    end;
    Reg.CloseKey;
  finally
    Result:=TeamViewerID;
    FreeAndNil(Reg);
  end;
end;

//type
  //TFileCallbackProcedure = procedure(filename:string);

Procedure RecurseDirectory(
  Dir : String;
  IncludeSubs : boolean;
  callback : TFileCallbackProcedure);
var
  SearchRec :TSearchRec;
  Result : LongInt;
begin
  Result := FindFirst(Dir+'\*.*', faAnyFile , SearchRec);
  while Result = 0 do begin
    { This makes sure its not the . or .. directorys}
    if not(SearchRec.name[1]='.') then begin
      if (SearchRec.attr and faDirectory) <> 0 then begin
      { its a dir so do a recursive call
        if subdirectories wanted }
        if IncludeSubs then
          RecurseDirectory(Dir +'\' + SearchRec.name,
                           IncludeSubs, callback);
      end
      else
        { Call are callback function}
        callback(dir+'\'+SearchRec.name);
      end; //if . ..
    Result := FindNext(SearchRec);
  end;
end;

Procedure RecurseDirectory2(Dir : String; IncludeSubs : boolean);
var
  SearchRec :TSearchRec;
  Result : LongInt;
begin
  Result := FindFirst(Dir+'\*.*', faAnyFile , SearchRec);
  while Result = 0 do begin
    { This makes sure its not the . or .. directorys}
    if not(SearchRec.name[1]='.') then begin
      if (SearchRec.attr and faDirectory) <> 0 then begin
      { its a dir so do a recursive call
        if subdirectories wanted }
        if IncludeSubs then
          RecurseDirectory2(Dir +'\' + SearchRec.name, IncludeSubs);
      end
      else
        { Call are callback function}
      maxForm1.memo2.lines.Add(Dir+'\'+SearchRec.name);
      end; //if . ..
    Result := FindNext(SearchRec);
  end;
end;




//type
  //TVolumeLevel = 0..127;

(*{ --- Shell Execute ---- }
type
  TS_ShellExecuteCmd = (seCmdOpen,seCmdPrint,seCmdExplore);

{ ---------------------------------------------------------------------------- }
{ --- Shell Execute routines ------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
function ShellExecuteCmdToStr(aCommand:TS_ShellExecuteCmd):String;
begin
  Case aCommand of
    seCmdOpen   : Result := 'open';
    seCmdPrint  : Result := 'print';
    seCmdExplore: Result := 'explore'
  end;
end;

{ ---------------------------------------------------------------------------- }
function GetShellExecuteResult(aExitValue:integer):String;
begin
  Result := '';
  if aExitValue = 0                      then Result := sMb_OutOfMemory;
  if aExitValue = ERROR_FILE_NOT_FOUND   then Result := sMb_ERROR_FILE_NOT_FOUND;
  if aExitValue = ERROR_PATH_NOT_FOUND   then Result := sMb_ERROR_PATH_NOT_FOUND;
  if aExitValue = ERROR_BAD_FORMAT       then Result := sMb_ERROR_BAD_FORMAT;
  if aExitValue = SE_ERR_ACCESSDENIED    then Result := sMb_SE_ERR_ACCESSDENIED;
  if aExitValue = SE_ERR_ASSOCINCOMPLETE then Result := sMb_SE_ERR_ASSOCINCOMPLETE;
  if aExitValue = SE_ERR_DDEBUSY	 then Result := sMb_SE_ERR_DDEBUSY;
  if aExitValue = SE_ERR_DDEFAIL	 then Result := sMb_SE_ERR_DDEFAIL;
  if aExitValue = SE_ERR_DDETIMEOUT      then Result := sMb_SE_ERR_DDETIMEOUT;
  if aExitValue = SE_ERR_DLLNOTFOUND     then Result := sMb_SE_ERR_DLLNOTFOUND;
  if aExitValue = SE_ERR_FNF	         then Result := sMb_SE_ERR_FNF;
  if aExitValue = SE_ERR_NOASSOC	 then Result := sMb_SE_ERR_NOASSOC;
  if aExitValue = SE_ERR_OOM	         then Result := sMb_SE_ERR_OOM;
  if aExitValue = SE_ERR_PNF	         then Result := sMb_SE_ERR_PNF;
  if aExitValue = SE_ERR_SHARE	         then Result := sMb_SE_ERR_SHARE;
end;

function S_ShellExecute(aFilename: string; aParameters:string;
                        aCommand: TS_ShellExecuteCmd):string;
var
  fExitValue:integer;
begin
   // if STATExecuteShell then begin    //global var in winform1puzzle!

  fExitValue := Shellexecute(0,
                             pChar(ShellExecuteCmdToStr(aCommand)),
                             pChar(aFilename),
                             pChar(aParameters),
                             pChar(ExtractFilePath(aFilename)),
                             SW_SHOWNORMAL);
  Result := GetShellExecuteResult(fExitValue);
    //end else MessageBox(0,pchar('Error Starting Shell'),pchar('mX3 command'),MB_OKCANCEL);
     maxForm1.memo2.Lines.Add('ExecuteShell Command could be protected in ini-File!'+#13#10+
                               'by setting EXECUTESHELL=N');

end; *)



procedure MakeSound(Frequency{Hz}, Duration{mSec}: Integer; Volume: TVolumeLevel; savefilePath: string);
  {writes tone to memory and plays it}
var
  WaveFormatEx: TWaveFormatEx;
  MS: TMemoryStream;
  i, TempInt, DataCount, RiffCount: integer;
  SoundValue: byte;
  w: double; // omega ( 2 * pi * frequency)
const
  Mono: Word = $0001;
  SampleRate: Integer = 11025; // 8000, 11025, 22050, or 44100
  RiffId: string = 'RIFF';
  WaveId: string = 'WAVE';
  FmtId: string = 'fmt ';
  DataId: string = 'data';
begin
  if Frequency > (0.6 * SampleRate) then begin
    ShowMessage(Format('Sample rate of %d is too Low to play a tone of %dHz',
      [SampleRate, Frequency]));
    Exit;
  end;
  with WaveFormatEx do begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := Mono;
    nSamplesPerSec := SampleRate;
    wBitsPerSample := $0008;
    nBlockAlign := (nChannels * wBitsPerSample) div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  MS:= TMemoryStream.Create;
  with MS do begin
    {Calculate length of sound data and of file data}
    DataCount := (Duration * SampleRate) div 1000; // sound data
    RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
      SizeOf(TWaveFormatEx) + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
    {write out the wave header}
    Write(RiffId[1], 4); // 'RIFF'
    Write(RiffCount, SizeOf(DWORD)); // file data size
    Write(WaveId[1], Length(WaveId)); // 'WAVE'
    Write(FmtId[1], Length(FmtId)); // 'fmt '
    TempInt := SizeOf(TWaveFormatEx);
    Write(TempInt, SizeOf(DWORD)); // TWaveFormat data size
    Write(WaveFormatEx, SizeOf(TWaveFormatEx)); // WaveFormatEx record
    Write(DataId[1], Length(DataId)); // 'data'
    Write(DataCount, SizeOf(DWORD)); // sound data size
    {calculate and write out the tone signal} // now the data values
    w := 2 * Pi * Frequency; // omega
    // wt = w * i / SampleRate
    for i := 0 to DataCount - 1 do begin
      SoundValue := 127 + trunc(Volume * sin(i * w / SampleRate));
      Write(SoundValue, SizeOf(Byte));
    end;
      // you could save the wave tone to file with, add by max :
     if savefilePath <> '' then begin
       MS.Seek(0, soFromBeginning);
      //MS.SaveToFile('C:\MyFile.wav');
       MS.SaveToFile(savefilePath);
     end;
    // then reload and play them without having to
    // construct them each time.
    {now play the sound}
    sndPlaySound(MS.Memory, SND_MEMORY or SND_SYNC);
    MS.Free;
  end;
end;   {Alan Lloyd}

//*********************************makeCompleXSound
type

 TfreqObj=class(TObject)
     ftemp,f,P,a,shape:INTEGER;
     StringRep:String;
     constructor Create(newf, newP, newA, newshape:integer);
     procedure makestringrep;
  end;

var shapenames:array[0..3] of string=('Sine','Square','Sawtooth','Triangle');
  defaultname:string='DEFAULT.SND';
  newf,newp, newA, newshape: integer;



 {************ TFreqObj.Create *********}
Constructor TFreqObj.Create;

begin
  inherited create;
  f:=newf;
  ftemp:=f;
  p:=newp;
  a:=newA;
  shape:=newSHAPE;
  makestringrep;
end;

procedure TFreqObj.makestringrep;
begin
  //stringrep:=format('%5d (F:%4d, P:%4d, A:%4d  %S)',[ftemp,f,p,a,SHAPENAMES[SHAPE]]);
end;


{********** msPlaySound ********}
(* procedure msPlaySound;
 var options:integer;
 begin
   options:=SND_MEMORY or SND_ASYNC;
   if duration.position=0 then  options:=options or SND_LOOP;
   PlaySound(MS[streaminuse].Memory, 0, options);
 end;*)

procedure SetComplexSoundElements(freqedt,Phaseedt,AmpEdt,WaveGrp:integer);
 //procedure TElementDlg.SetElement;
begin
  newf:= freqedt;
  newp:= Phaseedt;
  AmpEdt:= newa;
  newshape:= WaveGrp;
end;

{**************** AddObjectToList *************}
procedure AddComplexSoundObjectToList(newf,newp,newa,news:integer; freqlist: TStrings);
{Create a new TFreqObj and add it to Listbox1}
var
  ff:TFreqObj;
begin
     ff:=TFreqObj.create(newf,newp,newa,news);
     freqlist.addobject(ff.stringrep,ff);
     //itemindex:=items.count-1;
     //checked[itemindex]:=true;
     //modified:=true;
   //end;
    ff.Free;
end;


function mapfunc(ax, in_min, in_max, out_min, out_max: integer): integer;
begin
  result:= (ax - in_min) * (out_max - out_min) div (in_max - in_min) + out_min;
end;

function mapmax(ax, in_min, in_max, out_min, out_max: integer): integer;
begin
  result:= ax * (out_max - out_min) div (in_max - in_min);
end;


{********************* MakeComplexSound **************}
procedure MakeComplexSound(N:integer {stream # to use};
                           freqlist:TStrings;
                           Duration{mSec}: Integer;
                           pinknoise: boolean;
                           shape: integer;
                           Volume: TVolumeLevel);
  {writes complex tone defined by a list to memory stream N }
const   SampleRate: Integer = 11025; // 8000, 11025, 22050, or 44100
  Mono: Word = $0001;
  RiffId: string = 'RIFF';
  WaveId: string = 'WAVE';
  FmtId: string = 'fmt ';
  DataId: string = 'data';

var
  //Newshape:= shape;
  //ff:TFreqObj;
  WaveFormatEx: TWaveFormatEx;
  iz,i,j, TempInt, RiffCount: integer;
  SoundValue: integer;
  Byteval:byte;
  minfreq, maxval:integer;
  options:integer;
  w,ph, amp: double; // w= omega = ( 2 * pi * frequency) {= radians per second}
  freqerror:boolean;
  sampdiv2:integer; {half of sampling rate}
  msg:string;
  ptspercycle,x:extended;
  MS: array[0..1] of tmemorystream;
  StreamInUse:integer;
  datacount:integer;
  imagedata:array of byte;

begin
   //ff:= TFreqObj.Create(newf,newp,newa,shape);
   //with ff do begin
   //end;

  options:=SND_MEMORY or SND_ASYNC;
  with WaveFormatEx do begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := Mono;
    nSamplesPerSec := SampleRate;
    wBitsPerSample := $0008;
    nBlockAlign := (nChannels * wBitsPerSample) div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  MS[n]:= TMemoryStream.Create;
  with MS[n] do begin
    {Calculate length of sound data and of file data}
    DataCount := (Duration * SampleRate) div 1000; {record "duration" ms at "samplrate" samps/sec}
    RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
    SizeOf(TWaveFormatEx) + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
    {write out the wave header}
    Write(RiffId[1], 4); // 'RIFF'
    Write(RiffCount, SizeOf(DWORD)); // file data size
    Write(WaveId[1], Length(WaveId)); // 'WAVE'
    Write(FmtId[1], Length(FmtId)); // 'fmt '
    TempInt := SizeOf(TWaveFormatEx);
    Write(TempInt, SizeOf(DWORD)); // TWaveFormat data size
    Write(WaveFormatEx, SizeOf(TWaveFormatEx)); // WaveFormatEx record
    Write(DataId[1], Length(DataId)); // 'data'
    Write(DataCount, SizeOf(DWORD)); // sound data size
    {calculate and write out the tone signal} // now the data values
     {calculate a few cycles of the lowest frequency to find an appropriate
     scaling value for the signal}
    minfreq:=TFreqObj(freqlist.objects[0]).ftemp;
    maxval:=0;
    freqerror:=false;
    sampdiv2:=samplerate div 2;
    for i:= 0 to trunc(2/minfreq*samplerate) do begin
      soundvalue:=0;
      for j:=0 to freqlist.count-1 do
      if TFreqObj(freqlist.objects[j])<>nil then
      with TFreqObj(freqlist.objects[j]) do begin
        if ftemp>sampdiv2 then freqerror:=true;
        w := 2 * Pi * Ftemp; // omega
        ph:=p/pi;
        SoundValue:= soundvalue+ trunc(Volume * a/1000* sin(ph+i * w /SampleRate)); // wt = w * i / SampleRate
      end;
      If soundvalue>maxval
      then maxval:=soundvalue;
    end;
    if freqerror then begin
      msg:='Some frequency components ignored (too high to display';
      beep(1000,500);
    end
    else msg:='Sound OK';
      showmessage(msg);
    {now we can generate the waveform}
    for iz:= 0 to (DataCount - 1) do begin
      soundvalue:=127;
      for j:=0 to freqlist.count-1 do  {last entry is "add new freq" - ignore}
      if TFreqObj(freqlist.objects[j])<>nil then
      with TFreqObj(freqlist.objects[j]) do begin
        if ftemp< sampdiv2 then begin
          ptspercycle:=samplerate/Ftemp;
          if j=0 then setlength(imagedata,min(datacount,trunc(5*ptspercycle)));
          x:=frac(iz/ptspercycle+p/360); {where are we in the cycle}
          amp:=a/1000 ;  {amplitude}
          if pinknoise then amp:=amp+100*a*(1-random)/(f*1000) ;  {add pink noise}
          CASE SHAPE OF
            0: {Sine}
            begin
              w := 2 * Pi * Ftemp; {omega}
              ph:=p/pi;  {phase}
              SoundValue:= soundvalue+ trunc(Volume * amp* sin(ph+iz * w / SampleRate));
               // wt = w * i / SampleRate
            end;
            1: {Square}
            begin
              if x<0.5
              then SoundValue := soundvalue -trunc(Volume * amp)
              else SoundValue := soundvalue +trunc(Volume * amp);
            end;
            2: {Sawtooth}
            begin
              SoundValue := soundvalue + trunc(Volume * amp*(2*x-1));
            end;
            3: {Triangle}
            begin
              if x<0.5
              then SoundValue := soundvalue +trunc(Volume * amp*(4*x-1))
              else SoundValue := soundvalue +trunc(Volume * amp*(3-4*x));
            end;
          end; {case}
        end;
      end;
      if maxval>127 then byteval:=soundvalue*127 div maxval
      else byteval:=soundvalue;
      Write(Byteval, SizeOf(Byte));
      {write a few cycles for debugging}
      If iz<=high(imagedata) then imagedata[iz]:=byteval;
    end;
  end;
   streaminuse:= N;
   PlaySound(MS[streaminuse].Memory, 0, options);
   //ff.Free;
end;

{********************* MakeComplexSound **************}
function MakeComplexSound2(N:integer {stream # to use};
                           freqlist:TStrings;
                           Duration{mSec}: Integer;
                           pinknoise: boolean;
                           shape: integer;
                           Volume: TVolumeLevel): MSArray;
  {writes complex tone defined by a list to memory stream N }
const   SampleRate: Integer = 11025; // 8000, 11025, 22050, or 44100
  Mono: Word = $0001;
  RiffId: string = 'RIFF';
  WaveId: string = 'WAVE';
  FmtId: string = 'fmt ';
  DataId: string = 'data';

var
  //Newshape:= shape;
  //ff:TFreqObj;
  WaveFormatEx: TWaveFormatEx;
  iz,i,j, TempInt, RiffCount: integer;
  SoundValue: integer;
  Byteval:byte;
  minfreq, maxval:integer;
  options:integer;
  w,ph, amp: double; // w= omega = ( 2 * pi * frequency) {= radians per second}
  freqerror:boolean;
  sampdiv2:integer; {half of sampling rate}
  msg:string;
  ptspercycle,x:extended;
  MS: array[0..1] of tmemorystream;
  StreamInUse:integer;
  datacount:integer;
  imagedata:array of byte;

begin
   //ff:= TFreqObj.Create(newf,newp,newa,shape);
   //with ff do begin
   //end;

  options:=SND_MEMORY or SND_ASYNC;
  with WaveFormatEx do begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := Mono;
    nSamplesPerSec := SampleRate;
    wBitsPerSample := $0008;
    nBlockAlign := (nChannels * wBitsPerSample) div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;
  MS[n]:= TMemoryStream.Create;
  with MS[n] do begin
    {Calculate length of sound data and of file data}
    DataCount := (Duration * SampleRate) div 1000; {record "duration" ms at "samplrate" samps/sec}
    RiffCount := Length(WaveId) + Length(FmtId) + SizeOf(DWORD) +
    SizeOf(TWaveFormatEx) + Length(DataId) + SizeOf(DWORD) + DataCount; // file data
    {write out the wave header}
    Write(RiffId[1], 4); // 'RIFF'
    Write(RiffCount, SizeOf(DWORD)); // file data size
    Write(WaveId[1], Length(WaveId)); // 'WAVE'
    Write(FmtId[1], Length(FmtId)); // 'fmt '
    TempInt := SizeOf(TWaveFormatEx);
    Write(TempInt, SizeOf(DWORD)); // TWaveFormat data size
    Write(WaveFormatEx, SizeOf(TWaveFormatEx)); // WaveFormatEx record
    Write(DataId[1], Length(DataId)); // 'data'
    Write(DataCount, SizeOf(DWORD)); // sound data size
    {calculate and write out the tone signal} // now the data values
     {calculate a few cycles of the lowest frequency to find an appropriate
     scaling value for the signal}
    minfreq:=TFreqObj(freqlist.objects[0]).ftemp;
    maxval:=0;
    freqerror:=false;
    sampdiv2:=samplerate div 2;
    for i:= 0 to trunc(2/minfreq*samplerate) do begin
      soundvalue:=0;
      for j:=0 to freqlist.count-1 do
      if TFreqObj(freqlist.objects[j])<>nil then
      with TFreqObj(freqlist.objects[j]) do begin
        if ftemp>sampdiv2 then freqerror:=true;
        w := 2 * Pi * Ftemp; // omega
        ph:=p/pi;
        SoundValue:= soundvalue+ trunc(Volume * a/1000* sin(ph+i * w /SampleRate)); // wt = w * i / SampleRate
      end;
      If soundvalue>maxval
      then maxval:=soundvalue;
    end;
    if freqerror then begin
      msg:='Some frequency components ignored (too high to display';
      beep(1000,500);
    end
    else msg:='Sound OK';
      showmessage(msg);
    {now we can generate the waveform}
    for iz:= 0 to (DataCount - 1) do begin
      soundvalue:=127;
      for j:=0 to freqlist.count-1 do  {last entry is "add new freq" - ignore}
      if TFreqObj(freqlist.objects[j])<>nil then
      with TFreqObj(freqlist.objects[j]) do begin
        if ftemp< sampdiv2 then begin
          ptspercycle:=samplerate/Ftemp;
          if j=0 then setlength(imagedata,min(datacount,trunc(5*ptspercycle)));
          x:=frac(iz/ptspercycle+p/360); {where are we in the cycle}
          amp:=a/1000 ;  {amplitude}
          if pinknoise then amp:=amp+100*a*(1-random)/(f*1000) ;  {add pink noise}
          CASE SHAPE OF
            0: {Sine}
            begin
              w := 2 * Pi * Ftemp; {omega}
              ph:=p/pi;  {phase}
              SoundValue:= soundvalue+ trunc(Volume * amp* sin(ph+iz * w / SampleRate));
               // wt = w * i / SampleRate
            end;
            1: {Square}
            begin
              if x<0.5
              then SoundValue := soundvalue -trunc(Volume * amp)
              else SoundValue := soundvalue +trunc(Volume * amp);
            end;
            2: {Sawtooth}
            begin
              SoundValue := soundvalue + trunc(Volume * amp*(2*x-1));
            end;
            3: {Triangle}
            begin
              if x<0.5
              then SoundValue := soundvalue +trunc(Volume * amp*(4*x-1))
              else SoundValue := soundvalue +trunc(Volume * amp*(3-4*x));
            end;
          end; {case}
        end;
      end;
      if maxval>127 then byteval:=soundvalue*127 div maxval
      else byteval:=soundvalue;
      Write(Byteval, SizeOf(Byte));
      {write a few cycles for debugging}
      If iz<=high(imagedata) then imagedata[iz]:=byteval;
    end;
  end;
   streaminuse:= N;
   result:= MSarray(MS);
   PlaySound(MS[streaminuse].Memory, 0, options);
   //ff.Free;
end;


 // var comp_count: integer;

{function getNetUserName: string;
var
  szVar: array[0..32] of char;
begin
  DBIGetNetUserName(szVar);
  result:= StrPas(@szVar) ;
end;}

 //var mc: taction;


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

{function IsWoW64: boolean;
var biswow64result: boolean;
  isWow64Process : TWow64Process;
//const
 // DbiGetExactRecCnt: TDbiGetExactRecordCount = nil;
begin
  result:= false;
  @IsWow64Process:= GetProcAddress(Hinstance, 'IsWow64Process');
  //bisWow64Result:= @IsWow64Process;
  if (Assigned(isWow64Process)) then
   if (IsWow64Process(GetCurrentProcess, bIsWow64Result)) then
     result:= bisWow64result;
end;}


{procedure ShowFileProperties(const FileName: string);
var
  SEI : SHELLEXECUTEINFO;
begin
 ZeroMem(SEI,SizeOf(SEI));
 with SEI do
 begin
   cbSize:=SizeOf(SEI);
   fMask:=SEE_MASK_NOCLOSEPROCESS or SEE_MASK_INVOKEIDLIST or SEE_MASK_FLAG_NO_UI;
   Wnd:=Application.Handle;
   lpVerb:='properties';
   lpFile:=PChar(FileName);
  end;
  if not ShellExecuteEx(@SEI) then RaiseLastWin32Error;
end;}


const
  tolerance = 1E-2;

 procedure initHexArray(var hexn: THexArray);
  var i: integer;
  begin
    for i:= 0 to 9 do
      hexn[i]:= Chr(i+48);
    hexn[10]:= 'A'; hexn[11]:= 'B'; hexn[12]:= 'C'; hexn[13]:= 'D';
    hexn[14]:= 'E'; hexn[15]:= 'F';
  end;

function IsEven(I: Integer): Boolean;
begin
  Result := not Odd(I);
end;

procedure StrSplitP(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings),'Assert not Assigned!') ;
   Strings.Clear;
   Strings.Delimiter:= Delimiter;
   Strings.DelimitedText:= Input;
end;



function isPowerof2(num: int64): boolean;
begin
  result:= false;
  while  isEven(num) do
  num:= num div 2;
  if num= 1 then
  result:= true;
end;

function powerOf2(exponent: integer): int64;
var shifter: int64;
counter: integer;
begin
  shifter:= 1;
  for counter:= 1 to exponent do
  shifter:= shifter + shifter;
  result:= shifter;
end;



procedure SetArrayLength2String(arr: T2StringArray; asize1, asize2: integer);
var i: integer;
begin
   for i:= 0 to asize1 do
     SetLength(arr[i], asize2);
end;

procedure SetArrayLength2Integer(arr: T2IntegerArray; asize1, asize2: integer);
var i: integer;
begin
   for i:= 0 to asize1 do
     SetLength(arr[i], asize2);
end;

procedure SetArrayLength2String2(var arr: T2StringArray; asize1, asize2: integer);
var i: integer;
begin
   setlength(arr, asize1);
   for i:= 0 to asize1 do
     SetLength(arr[i], asize2);
end;

procedure SetArrayLength2Integer2(var arr: T2IntegerArray; asize1, asize2: integer);
var i: integer;
begin
   setlength(arr, asize1);
   for i:= 0 to asize1 do
     SetLength(arr[i], asize2);
end;

procedure SetArrayLength2Char2(var arr: T2CharArray; asize1, asize2: integer);
var i: integer;
begin
   setlength(arr, asize1);
   for i:= 0 to asize1 do
     SetLength(arr[i], asize2);
end;

procedure Set3DimIntArray(var arr: T3IntegerArray; asize1, asize2, asize3: integer);
begin
   setlength(arr, asize1, asize2,asize3);
end;

procedure Set3DimStrArray(var arr: T3StringArray; asize1, asize2, asize3: integer);
begin
   setlength(arr, asize1, asize2, asize3);
end;

// FindInPaths
//
function FindInPaths(const fileName, paths : String) : String;
var
   p : Integer;
   buf : String;
   sl : TStringList;
begin
   if FileExists(fileName) then begin
      Result:=fileName;
      Exit;
   end;
   buf:=paths;
   sl:=TStringList.Create;
   try
      p:=Pos(';', buf);
      while p>0 do begin
         sl.Add(Copy(buf, 1, p-1));
         buf:=Copy(buf, p+1, Maxint);
         p:=Pos(';', buf);
      end;
      sl.Add(buf);
      for p:=0 to sl.Count-1 do begin
         buf:=sl[p];
         if Copy(buf, 1, Length(buf))<>'\' then
            buf:=Buf+'\';
         buf:=buf+fileName;
         if FileExists(buf) then begin
            Result:=buf;
            Exit;
         end;
      end;
   finally
      sl.Free;
   end;
   Result:='';
end;




function RefToCell(ARow, ACol: Integer): string;
begin
  Result:= Chr(Ord('A') + ACol - 1) + IntToStr(ARow);
end;

function SaveAsExcelFile(AGrid: TStringGrid; ASheetName, AFileName: string; open: boolean): Boolean;
const
  xlWBATWorksheet = -4167;
var
  Row, Col: Integer;
  GridPrevFile: string;
  XLApp, Sheet, Data: OLEVariant;
  i, j: Integer;
begin
  // Prepare Data
  Data:= VarArrayCreate([1, AGrid.RowCount, 1, AGrid.ColCount], varVariant);
  for i:= 0 to AGrid.ColCount - 1 do
    for j:= 0 to AGrid.RowCount - 1 do
      Data[j + 1, i + 1]:= AGrid.Cells[i, j];
  // Create Excel-OLE Object
  Result:= False;
  XLApp:= CreateOleObject('Excel.Application');
  try
    // Hide Excel
    if open then
    XLApp.Visible:= true else
    XLApp.Visible:= False;
    // Add new Workbook
    XLApp.Workbooks.Add(xlWBatWorkSheet);
    Sheet:= XLApp.Workbooks[1].WorkSheets[1];
    Sheet.Name:= ASheetName;
    // Fill up the sheet
    //XLApp.sheet.cells[2,2]:= 'thisis5';
    Sheet.Range[RefToCell(1, 1), RefToCell(AGrid.RowCount, AGrid.ColCount)].Value:= Data;
    // Save Excel Worksheet
    try
      XLApp.Workbooks[1].SaveAs(AFileName);
      Result:= True;
    except
      // Error ?
      Showmessage('excel COM error');
    end;
  finally
    // Quit Excel
    if not VarIsEmpty(XLApp) then begin
      XLApp.DisplayAlerts:= False;
      XLApp.Quit;
      XLAPP:= Unassigned;
      Sheet:= Unassigned;
    end;
  end;
end;


{function myStrToBytes(const Value: String): TBytes;
var i: integer;
begin
  SetLength(result, Length(Value));
  for i:= 0 to Length(Value)-1 do
    result[i]:= Ord(Value[i+1])- 48;    //-48
end;}


{function myBytesToStr(const Value: TBytes): String;
var I: integer;
    Letra: char;
begin
  result:= '';
  for I:= Length(Value)-1 Downto 0 do begin
    letra:= Chr(Value[I] + 48);
    result:= letra + result;
  end;
end;}

function josephusG(n,k: integer; var graphout: string): integer;
var i,p,kt: smallint;
    aist: array of char;
 begin
   SetLength(aist,n);
   kt:= 2;
   p:= 0;
   for i:= 0 to length(aist)-1 do aist[i]:= '1';//init array
   while kt <= length(aist) do begin    
     for i:= 0 to length(aist)-1 do begin
       if aist[i]= '1' then inc(p);
       if p = k then begin
         aist[i]:= 'x';
         inc(kt);
         p:= 0;
       end;
     end;
     for i:= 0 to length(aist)-1 do  //line out
       graphout:= graphout + aist[i];
     graphout:= graphout + #13#10;
   end; 
   for i:= 0 to length(aist)-1 do  //solution out
     if aist[i]= '1' then result:= (i+1);
 end;



function ReverseDNSLookup(const IPAddress: String; const DNSServer: String; Timeout, Retries: Integer; var HostName: String): Boolean;
var
  AIdDNSResolver: TIdDNSResolver;
  RetryCount: Integer;
begin
  Result := FALSE;
  AIdDNSResolver:= TIdDNSResolver.Create(nil);
  try
    AIdDNSResolver.QueryResult.Clear;
    AIdDNSResolver.ReceiveTimeout:= Timeout;     //waittime
    AIdDNSResolver.QueryRecords:= [qtPTR];
    AIdDNSResolver.Host:= DNSServer;
    RetryCount:= Retries;
    repeat
      try
        dec(RetryCount);
        AIdDNSResolver.Resolve(IPAddress);
        Break;
      except
        on e: Exception do
        begin
          if RetryCount <= 0 then
          begin
            if SameText(e.Message, 'RSCodeQueryName') then
              Result := FALSE
            else
              raise Exception.Create(e.Message);
            Break;
          end;
        end;
      end;
    until FALSE;
    Result:= AIdDNSResolver.QueryResult.Count > 0;
    if Result then begin
      Result := TRUE;
    //  HostName:= ParseReverseDNSResult(AIdDNSResolver.QueryResult[0].RData);
     if AIdDNSResolver.QueryResult.Count > 0 then
         Hostname:= AIdDNSResolver.QueryResult.DomainName;
   end
   finally
      FreeAndNil(AIdDNSResolver);
  end;
end;


function YesNoDialog(const ACaption, AMsg: string): boolean;
begin
  Result := MessageBox(GetFocus, PChar(AMsg), PChar(ACaption),
    MB_YESNO or MB_ICONQUESTION or MB_TASKMODAL) = IDYES;
end;


procedure getEnvironmentInfo;
var
  List: TStringList;
  I: Integer;
begin
  List:= TStringList.Create;
  try
    GetEnvironmentVars(List, False);
    for I:= 0 to List.Count - 1 do
      //Writeln(List[I]);
      //maxform1.memo2.lines[i]:= list[i];
      maxform1.memo2.lines.add(list[i]);
    //Readln;
  finally
    List.Free;
  end;
end;

function getEnvironmentString: string;
var
  List: TStringList;
  I: Integer;
begin
  List:= TStringList.Create;
  try
    GetEnvironmentVars(List, False);
    for I:= 0 to List.Count - 1 do
      //Writeln(List[I]);
      //maxform1.memo2.lines[i]:= list[i];
      //result:= result + list[i];
      result:= result + list[i]+ #13#10;
      //maxform1.memo2.lines.add(list[i]);
    //Readln;
  finally
    List.Free;
  end;
end;


function getBitmap(apath: string): TBitmap;
  begin
    result:= TBitmap.Create;
    with result do try
      LoadFromFile(apath);
    finally
      //Free;
    end;
  end;

 procedure ShowMessageBig(const aText : string);
   begin
   with CreateMessageDialog(atext ,mtinformation, [mbyes, mbok])
      do try
        //setBounds(100,100,500,150)
        caption:= 'mXShowMessageBig';
        font.size:= 15;
        //autosize:= true;
        clientheight:= clientheight+20;
        clientwidth:= clientwidth+20;
        height:= height+10;
        Color:= clwebgold;
        showmodal;
        //canvas.draw(100,200,getBitMapon(Exepath+BITMAP));
      finally
        Free;
      end;
   end;


 procedure ShowMessageBig2(const aText : string; aautosize: boolean);
   begin
   with CreateMessageDialog(atext ,mtinformation, [mbyes, mbok])
      do try
        //setBounds(100,100,500,150)
        caption:= 'mXShowMessageBig';
        font.size:= 15;
        if aautosize then
           autosize:= true;
        clientheight:= clientheight+10;
        height:= height+10;
        Color:= clwebgold;
        showmodal;
        //canvas.draw(100,200,getBitMapon(Exepath+BITMAP));
      finally
        Free;
      end;
   end;

 procedure ShowMessageBig3(const aText : string; fsize: byte; aautosize: boolean);
   begin
   with CreateMessageDialog(atext ,mtinformation, [mbyes, mbok])
      do try
        //setBounds(100,100,500,150)
        caption:= 'mXShowMessageBig3';
        font.size:= fsize; //25;
        if aautosize then
           autosize:= true;
        clientheight:= clientheight+50;
        height:= height+150;
        Color:= clwebgold;
        showmodal;
        //canvas.draw(100,200,getBitMapon(Exepath+BITMAP));
      finally
        Free;
      end;
   end;


procedure AntiFreeze;
var
  Msg: TMsg;
  ApplicationHasPriority: boolean;
begin
  if ApplicationHasPriority then begin
    Forms.Application.ProcessMessages;
  end else begin
    // This guarantees it will not ever call Application.Idle
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then begin
      Forms.Application.HandleMessage;
    end;
  end;
end;


procedure PrintList(Value: TStringList);
var
  I, Line, Pagenum: Integer;
begin
  //let's print
  //if Assigned(FOnBeginPrint) then
    //FOnBeginPrint(Self);
  line := 0;
  Printer.BeginDoc;
  Pagenum := 1;
  for I := 0 to Value.Count - 1 do
  begin
    //if Assigned(FOnProgress) then
      //FOnProgress(Self, I + 1, Value.Count);

    Line := Line + Printer.Canvas.TextHeight(Value[I]);
    if Line + Printer.Canvas.TextHeight(Value[I]) > Printer.PageHeight then
    begin
      Line := Printer.Canvas.TextHeight(Value[I]);
      Printer.NewPage;
      Inc(PageNum);
      //if Assigned(FOnNextPage) then
        //FOnNextPage(Self, PageNum);
    end;

    Printer.Canvas.TextOut(0, Line, Value[I]);
  end;
  Printer.EndDoc;
  //if Assigned(FOnFinishedPrint) then
    //FOnFinishedPrint(Self);
end;

procedure PrintImage(aValue: TBitmap; Style: TBitmapStyle);
begin
  //let's print too :)
  //if Assigned(FOnBeginPrint) then
    //FOnBeginPrint(Self);
  case Style of
    bsNormal:
      begin
        with Printer do begin
          BeginDoc;
          Canvas.Draw(0, 0, aValue);
          EndDoc;
        end;
      end;
    bsCentered:
      begin
        with Printer do begin
          BeginDoc;
          Canvas.Draw((PageWidth-aValue.Width) div 2, (PageHeight-aValue.Height) div 2, aValue);
          EndDoc;
        end;
      end;
    bsStretched:
      begin
        with Printer do begin
          BeginDoc;
          Canvas.StretchDraw(Rect(0, 0, PageWidth, PageHeight), aValue);
          EndDoc;
        end;
      end;
  end;
  //if Assigned(FOnFinishedPrint) then
    //FOnFinishedPrint(Self);
end;


Function AspectRatio(aWidth, aHeight: Integer): String;
var
  RatioX : Array [0..4] of integer;
  RatioY : Array [0..4] of integer;
  diff,dmin, ratio : Double;
  i,j : Integer;

Begin
  ratiox[0]:=4; ratiox[1]:=5; ratiox[2]:=16; ratiox[3]:=16;  ratiox[4]:=16; 
  ratioy[0]:=3; ratioy[1]:=4; ratioy[2]:=10; ratioy[3]:=9;  ratioy[4]:=12;
  ratio:= aWidth/aHeight;
  dmin:= 999;
  j:=-1;
  for i:=0 to High(RatioX) do begin
    diff:= abs(RatioX[i]/RatioY[i] - ratio);
    if diff < dmin then begin
      j:= i;
      dmin:= diff;
    end
  end;
  if diff<tolerance then
     result:= Format('%d:%d',[RatioX[j], RatioY[j]])
  else
     result:= 'Non Standard';
End;  



procedure maXbox;
begin
  ShowFileProperties(ExePath+EXENAME);
end;

Function RGB(R,G,B: Byte): TColor;
Begin
  Result:= B Shl 16 Or G Shl 8 Or R;
End;


Function Sendln(amess: string): boolean;
Begin
  showmessage('net email in V4');
End;


function IsWow64: Boolean;
{Returns true if the current process is executing as a 32 bit process under
WOW64 on 64 bit Windows. s gives status message}
type
  TIsWow64Process = function(// Type of IsWow64Process API fn
      Handle: Windows.THandle; var Res: Windows.BOOL): Windows.BOOL; stdcall;
var
  IsWow64Result: Windows.BOOL; // Result from IsWow64Process
  IsWow64Process: TIsWow64Process; // IsWow64Process fn reference
begin
  Result:= False;
// Try to load required function from kernel32
  IsWow64Process:= Windows.GetProcAddress(Windows.GetModuleHandle('kernel32'), 'IsWow64Process');
if Assigned(IsWow64Process) then
  if IsWow64Process(Windows.GetCurrentProcess, IsWow64Result) then
    Result:= IsWow64Result;
{if Result then s := 'Process is running on Wow64'
else s := 'Process is NOT running on Wow64';
end else s := 'IsWow64 call failed';
end else s := 'IsWow64Process not present in kernel32.dll';}
end;

function IsWow64String(var s: string): Boolean;
{Returns true if the current process is executing as a 32 bit process under
WOW64 on 64 bit Windows. s gives status message}
type
  TIsWow64Process = function(// Type of IsWow64Process API fn
  Handle: Windows.THandle; var Res: Windows.BOOL): Windows.BOOL; stdcall;
var
  IsWow64Result: Windows.BOOL; // Result from IsWow64Process
  IsWow64Process: TIsWow64Process; // IsWow64Process fn reference
   // FProcessEntry32: TProcessEntry32;

begin
Result := False;
// Try to load required function from kernel32
IsWow64Process := Windows.GetProcAddress(Windows.GetModuleHandle('kernel32'), 'IsWow64Process');
if Assigned(IsWow64Process) then begin
if IsWow64Process(Windows.GetCurrentProcess, IsWow64Result) then begin
Result := IsWow64Result;
if Result then s := 'Process is running on Wow64'
else s := 'Process is NOT running on Wow64';
end else s := 'IsWow64 call failed';
end else s := 'IsWow64Process not present in kernel32.dll';
end;


procedure StartSerialDialog;
var tsfrm: TForm1;     //in winformpuzzle
begin
  tsFrm:= TForm1.Create(NIL);
  with tsFrm do begin
   try
     // FExeFile:= TExeImage.CreateImage(rcFrm, ExePath+'maxbox3.exe');
    //  DisplayResources;
    //INVALID_FILE_ATTRIBUTES;
      maxForm1.statusBar1.SimpleText:= ' mX SerialForm opened!';
      showModal;
    finally
      Release;
      Free;
      maxForm1.statusBar1.SimpleText:= 'mX SerialForm closed';
    end;
  end;
end;

procedure StartThreadDemo;
//var tsfrm: TForm1;     //in winformpuzzle
begin
   with TThreadSortForm.Create(maxForm1) do begin
      //label1.caption:= 'Bubble Sort down up';
      show;
      //StartBtn.caption:= 'go parallel';
      //StartBtnClick(self);
     end;
  maxForm1.statusBar1.SimpleText:= ' mX Thread Demo opened!';
end;




function IsVirtualPcGuest : Boolean;
var
    bRC : Boolean;
begin
    bRC := false;
    try
        asm
            push ebx
            mov  ebx, 0 
            mov  eax, 1

            db $0F
            db $3F
            db $07
            db $0B

            test ebx, ebx
            setz [bRC]
            pop ebx
        end; { asm }

        Result := bRC;
    except
        Result := false;
    end; { try / except }
end; { IsVirtualPcGuest }

(* ---- *)

function IsVmWareGuest : Boolean;
var
    bRC : Boolean;
begin
    bRC := true;
    try
        asm
            push   edx
            push   ecx
            push   ebx

            mov    eax, 'VMXh'
            mov    ebx, 0
            mov    ecx, 10
            mov    edx, 'VX'

            in     eax, dx
            // EAX gibt die Version zurück
            cmp    ebx, 'VMXh'
            setz   [bRC]

            pop    ebx
            pop    ecx
            pop    edx
        end; { asm }

        Result := bRC;
    except
        Result := false;
    end; { try / except }
end; { IsVmWareGuest }



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


  function UpTime: string;
var t: Longword;
  d, h, m, s: Integer;
  ticksperday, ticksperhour: Integer;
  ticksperminute, tickspersecond: Integer;
  B2X: byte;
begin
  ticksperday:= 1000 * 60 * 60 * 24;
  ticksperhour:= 1000 * 60 * 60;
  ticksperminute:= 1000 * 60;
  tickspersecond:= 1000;
  t := GetTickCount;
  d := t div ticksperday;
  t:=t- d * ticksperday;
  h := t div ticksperhour;
  //Dec(t, h * ticksperhour);
  t:= t- h * ticksperhour;
  m := t div ticksperminute;
  //Dec(t, m * ticksperminute);
  t:= t- m * ticksperminute;
  s := t div tickspersecond;
  Result := 'OS Uptime: ' + IntToStr(d) + ' Days ' + IntToStr(h) + ' Hours ' + IntToStr(m) +
    ' Minutes ' + IntToStr(s) + ' Seconds';
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
  result:= mseconds div 29;
end;

{Anmerkung:
1 Minute = 1.666666 Industrieminuten (0.01 = 0.0166666)
1 Industrieminute = 36 Sekunden      (0.01 = 0.006)
}

function ReadReg(Base: HKEY; KeyName, ValueName: string): string;
begin
  with TRegistry.Create do begin
    RootKey := Base;
    OpenKey(KeyName, False);
    try
      if ValueExists(ValueName) then
        Result := ReadString(ValueName)
      else
        Result := '';
    except
      Result := '';
    end;
    Free;
  end;
end;


const
  RC_VNetKey = 'System\CurrentControlSet\Services\Vxd\VNETSUP';
  RC_VNetKeyNT = '';
  RC_CurrentKey = 'Software\Microsoft\Windows\CurrentVersion';
  RC_CurrentKeyNT = 'Software\Microsoft\Windows NT\CurrentVersion';

  cOSCurrentKey: array [Boolean] of string =
  (RC_CurrentKey, RC_CurrentKeyNT);

function IsNT: Boolean;
begin
  Result:= Win32Platform = VER_PLATFORM_WIN32_NT;
end;


function GetOSName: string;
begin
  Result:= ReadReg(HKEY_LOCAL_MACHINE, cOSCurrentKey[IsNT], 'ProductName');
end;


function GetOSVersion: string;
begin
  Result:= ReadReg(HKEY_LOCAL_MACHINE, cOSCurrentKey[IsNT], 'Version');
end;

function GetOSNumber: string;
begin
  Result:= ReadReg(HKEY_LOCAL_MACHINE, cOSCurrentKey[IsNT], 'VersionNumber');
end;


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
     //idHTTP.Request.UserAgent:= 'maXbox4 compatible http';
     //vstring:= idHTTP.Get(MXVERSIONFILE);
     vstring:= HttpGetDirect(MXVERSIONFILE);
     //vstring:= gethtml
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
     Speak(' A new Version '+vstr+' of max box is available! ');
     maxform1.memo2.Font.Size:= oldsize;
     end;
     result:= true;
   end;
 end;

function VersionCheckAct: string;
var idHTTP: TIDHTTP;
 begin
   result:= 'sorry version not found';
   if IsInternet then begin
     idHTTP:= TIdHTTP.Create(NIL);
   try
      //idHTTP.Request.UserAgent:= 'maXbox4 compatible http';
       // result:= idHTTP.Get(MXVERSIONFILE2);
       result:= HttpGetDirect(MXVERSIONFILE2);
    // actVersion:= vstring;
    //idhttp.get2('http://www.softwareschule.ch/maxbox.htm')
   finally
     idHTTP.Free
   end;
 end;
 end;

function CheckBox: string;
var idHTTP: TIDHTTP;
 begin
   result:= 'mX4 version not found';
   if IsInternet then begin
     idHTTP:= TIdHTTP.Create(NIL);
   try
      //idHTTP.Request.UserAgent:= 'maXbox4 compatible';
        //result:= idHTTP.Get(MXVERSIONFILE2);
     result:= HttpGetDirect(MXVERSIONFILE2);
     result:= result[1]+result[2]+result[3]+result[4]+result[5]+result[6];
     if result = MBVER2 then //begin
       //output.Font.Style:= [fsbold];
     //Speak(' A new Version '+vstr+' of max box is available! ');
     result:= ('!!! OK. You have the latest Version: '+result+' available at '+MXSITE)
     else result:= ('!!! NO. You dont have the latest Version: '+result+' available at '+MXSITE);
    //end;
    // actVersion:= vstring;
    //idhttp.get2('http://www.softwareschule.ch/maxbox.htm')
   finally
     idHTTP.Free
   end;
 end;
 end;


function wget(aURL, afile: string): boolean;
var  idHTTP: TIDHTTP;
      pStream: TFileStream;
begin
  result:= false;
  pStream:= TFileStream.create(afile, fmCreate);
  idHTTP:= TIdHTTP.Create(NIL);
  try
    //idhttp.get(aURL, pStream);
    WinInet_HttpGet(aURL, pStream);
    sleep(2000);
    SearchAndOpenDoc(afile);
    //ShellExecute(0, '', '',PDF_FILE,'',2 )
    result:= true;
  finally
    idHTTP.Free;
    pStream.Free;
  end;
end;

function wget2(aURL, afile: string): boolean;
var  idHTTP: TIDHTTP;
      pStream: TFileStream;
begin
  result:= false;
  pStream:= TFileStream.create(afile, fmCreate);
  idHTTP:= TIdHTTP.Create(NIL);
  try
    //  idHTTP.Request.UserAgent:= 'maXbox4 compatible';
    //idhttp.get(aURL, pStream);
    WinInet_HttpGet(aURL, pStream);
    sleep(1000);
    //sleep(2000);
    //SearchAndOpenDoc(afile);
    //ShellExecute(0, '', '',PDF_FILE,'',2 )
    result:= true;
  finally
    idHTTP.Free;
    pStream.Free;
  end;
end;


function wget3(aURL, afile: string; opendoc: boolean): boolean;
var  idHTTP: TIDHTTP;
      pStream: TFileStream;
begin
  result:= false;
  pStream:= TFileStream.create(afile, fmCreate);
  //idHTTP:= TIdHTTP.Create(NIL);
  try
    //  idHTTP.Request.UserAgent:= 'maXbox4 compatible';
    //idhttp.get(aURL, pStream);
    WinInet_HttpGet(aURL, pStream);
    sleep(1000);
    if opendoc then
      SearchAndOpenDoc(afile);
    //sleep(2000);
    //SearchAndOpenDoc(afile);
    //ShellExecute(0, '', '',PDF_FILE,'',2 )
    result:= true;
  finally
    //idHTTP.Free;
    pStream.Free;
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
  for i:= 0 to Forms.Application.ComponentCount - 1 do begin
    // all components of a Form
    for j:= 0 to Forms.Application.Components[i].ComponentCount - 1 do begin
      c:= Forms.Application.Components[i].Components[j];
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

Function CharToHex(const APrefix : String; const cc : Char): string;
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
           Forms.Application.ProcessMessages;
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
     MessageBox(Forms.Application.MainForm.Handle,
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
        Forms.Application.MessageBox(PChar('Failed to launch default browser, go to '+URL+' at yours.'),'not launch browser...',0);
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
  Forms.Application.Minimize;
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


function IsWindowsVista: boolean;
var
  verInfo: TOSVersionInfo;
begin
  verinfo.dwOSVersionInfoSize:= Sizeof(TOsVersioninfo);
  GetVersionEx(Verinfo);
  result:= Verinfo.dwMajorVersion >=6;
end;

function GetOsVersionInfo: TOSVersionInfo;
var
  verInfo: TOSVersionInfo;
begin
  verinfo.dwOSVersionInfoSize:= sizeof(verinfo);
  GetVersionEx(Verinfo);
  result:= Verinfo;
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


function getTimeAMString: string;
begin
 result:= getTimeAMString;
end;

function getTimePMString: string;
begin
 result:= TimePMString;
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

procedure SearchAndCopy(aStrList: TStrings; aSearchStr, aNewStr: string; offset: integer);
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
      t1:= pos(aSearchStr, s1);
      if t1 > 0 then begin
        Delete(s1, t1+offset-length(asearchstr), Length(aNewStr));
        Insert(aNewStr, s1, t1+offset);
        aStrList[i]:= s1;
      end;
  end;
end;

procedure ShowBitmap(bmap: TBitmap);
begin
 with TForm.Create(NIL) do begin
   SetBounds(0,0,bmap.width, bmap.height);
   Show;
   BringtoFront;
   Canvas.Draw(0,0, bmap);
   //showmodal;
   //Free;
 end;
end;


 function GetFileDate(aFile:string; aWithTime:Boolean):string;
  var i:integer;
      aDate:TDateTime;
  begin
    result:='';
    i:=FileAge(aFile);
    if i>=0 then begin
       aDate:=FileDateToDateTime(i);
       if aWithTime
       then result:=FormatDateTime('dd/mm/yyyy   hh:nn',aDate)
       else result:=FormatDateTime('dd/mm/yyyy',aDate);
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
  FileNamePath:= extractFilePath(forms.application.exeName) + EXCEPTLOGFILE;
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

procedure Debugln(DebugLOGFILE: string; E: string);
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
  if not FileExists(debugLOGFILE) then
     FileCreate(debugLOGFILE);

  //FileNamePath:= extractFilePath(DebugLOGFILE);
  AssignFile(FErrorLog, DebugLOGFILE);
  try
    System.Append(FErrorlog);
  except
    on EInOutError do Rewrite(FErrorLog);
  end;
  Addr:= inttoStr(mem.dwAvailPageFile div 1024) + 'pgf; mem:'
               +inttoStr(mem.dwAvailPhys div 1024);
  Writeln(FErrorLog, Format('%s %s [%s] %s %s [%s]',[DateTimeToStr(Now),'V:'+MBVERSION,
          getUserNameWin, getComputerNameWin, E,'at:  '+Addr]));
  System.Close(FErrorLog);
  maxForm1.memo2.Lines.Add('Debug add '+MBVERSION +' '+E +'. occured at: '+Addr)
  //MessageDlg(MBVERSION +' '+E +'. occured at: '+Addr,mtError,[mbOK],0);
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

procedure ExecuteThread2(afunc: TThreadFunction22; var thrOK: boolean);
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
      Wnd:= Forms.Application.Handle;
      lpFile:= PChar(ExecuteFile) ;
 //ParamString contains app parameters.
  lpParameters:= PChar(ParamString) ;
 {
 StartInString specifies the name of the working directory.
 If ommited, the current directory is used. }
 // lpDirectory := PChar(StartInString) ;
      nShow:= SW_SHOWNORMAL;
    end;
    if maxForm1.getSTATExecuteShell then begin
      if ShellExecuteEx(@SEInfo) then begin
       repeat
        Forms.Application.ProcessMessages;
        GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
      until (ExitCode <> STILL_ACTIVE) or
                   	 Forms.Application.Terminated;
      //for security reason to control what happens
     maxForm1.memo2.Lines.Add('MessageBox: Shell Terminated mX3 command at: '+
                                    DateTimeToStr(Now));
    end
     end
     else begin
        MessageBox(0,pchar('Error Starting Shell'),pchar('mX3 command'),MB_OKCANCEL);
        maxForm1.memo2.Lines.Add('Error Starting Shell protected in ini-File!'+#13#10+
                               'by setting EXECUTESHELL=N');
     end;
     maxForm1.memo2.Lines.Add('ExecuteShell Command could be protected in ini-File!'+#13#10+
                               'by setting EXECUTESHELL=N');
 end;

Procedure ShellExecuteAndWait(executeFile, paramstring: string);
var
    SEInfo: TShellExecuteInfo;
    ExitCode: DWORD;
    //StartInString: string;
 begin
    FillChar(SEInfo, SizeOf(SEInfo), 0);
    with SEInfo do begin
      fMask:= SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
      //Wnd:= Forms.Application.Handle;
      cbSize:= SizeOf(TShellExecuteInfo) ;
      Wnd:= GetActiveWindow;
      lpFile:= PChar(ExecuteFile);
      SEInfo.lpVerb:= 'open';
      lpParameters:= PChar(ParamString) ;
 { StartInString specifies the name of the working directory.
 If ommited, the current directory is used. }
 // lpDirectory := PChar(StartInString) ;
      nShow:= SW_SHOWNORMAL;
    end;
    if maxForm1.getSTATExecuteShell then begin
      if ShellExecuteEx(@SEInfo) then begin
        ExitCode:= SEInfo.hProcess;
      end else begin
        ShowMessage(SysErrorMessage(GetLastError));
        Exit;
      end;
      while WaitForSingleObject(SEInfo.hProcess, 50) <> WAIT_OBJECT_0 do
                //   	 Forms.Application.Terminated;
      Forms.Application.ProcessMessages;
       CloseHandle(ExitCode);
      //for security reason to control what happens
     maxForm1.memo2.Lines.Add('Message: Shell Terminated mX3 command at: '+
                                    DateTimeToStr(Now));
    end
     else begin
        MessageBox(0,pchar('Error Starting Shell'),pchar('mX3 command'),MB_OKCANCEL);
        maxForm1.memo2.Lines.Add('Error Starting Shell protected in ini-File!'+#13#10+
                               'by setting EXECUTESHELL=N');
     end;
     maxForm1.memo2.Lines.Add('ExecuteShell Command could be protected in ini-File!'+#13#10+
                               'by setting EXECUTESHELL=N');
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
     Result := 'Unknown';     //wm_quit
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
  result:= ExtractFilePath(Forms.Application.ExeName)
end;

function MaxPath: string;
begin
  result:= ExtractFilePath(Forms.Application.ExeName)+ExtractFileName(Forms.Application.ExeName);
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

function StringRefCount(const s: String): integer;
begin
  result := Integer(Pointer(integer(Addr(s)^)-8)^);
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

function mymciSendString(cmd: PChar; ret: PChar; len: integer; callback: integer): cardinal;
begin
  result:= mciSendString(cmd, ret, len, callback);
end;

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
   CL.AddTypeS('TThreadFunction','function: Longint; stdcall)');
   //CL.AddTypeS('TThreadFunction3','function: Longint; stdcall)');
   CL.AddTypeS('TThreadFunction22','procedure; stdcall');

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
 CL.AddConstantN('PILARGE','String').SetString(PILARGE);
  CL.AddConstantN('VK_LWIN','LongInt').SetInt( 91);
 CL.AddConstantN('VK_RWIN','LongInt').SetInt( 92);
 CL.AddConstantN('VK_APPS','LongInt').SetInt( 93);
 CL.AddConstantN('VK_SLEEP','LongInt').SetInt( 95);
 CL.AddConstantN('VK_NUMPAD0','LongInt').SetInt( 96);
 CL.AddConstantN('VK_NUMPAD1','LongInt').SetInt( 97);
 CL.AddConstantN('VK_NUMPAD2','LongInt').SetInt( 98);
 CL.AddConstantN('VK_NUMPAD3','LongInt').SetInt( 99);
 CL.AddConstantN('VK_NUMPAD4','LongInt').SetInt( 100);
 CL.AddConstantN('VK_NUMPAD5','LongInt').SetInt( 101);
 CL.AddConstantN('VK_NUMPAD6','LongInt').SetInt( 102);
 CL.AddConstantN('VK_NUMPAD7','LongInt').SetInt( 103);
 CL.AddConstantN('VK_NUMPAD8','LongInt').SetInt( 104);
 CL.AddConstantN('VK_NUMPAD9','LongInt').SetInt( 105);
 CL.AddConstantN('VK_MULTIPLY','LongInt').SetInt( 106);
 CL.AddConstantN('VK_ADD','LongInt').SetInt( 107);
 CL.AddConstantN('VK_SEPARATOR','LongInt').SetInt( 108);
 CL.AddConstantN('VK_SUBTRACT','LongInt').SetInt( 109);
 CL.AddConstantN('VK_DECIMAL','LongInt').SetInt( 110);
 CL.AddConstantN('VK_DIVIDE','LongInt').SetInt( 111);
 //VK 112 - 123 in sysutils_max
 CL.AddConstantN('VK_NUMLOCK','LongInt').SetInt( 144);
 CL.AddConstantN('VK_SCROLL','LongInt').SetInt( 145);
 CL.AddConstantN('VK_LSHIFT','LongInt').SetInt( 160);
 CL.AddConstantN('VK_RSHIFT','LongInt').SetInt( 161);
 CL.AddConstantN('VK_LCONTROL','LongInt').SetInt( 162);
 CL.AddConstantN('VK_RCONTROL','LongInt').SetInt( 163);
 CL.AddConstantN('VK_LMENU','LongInt').SetInt( 164);
 CL.AddConstantN('VK_RMENU','LongInt').SetInt( 165);
 CL.AddConstantN('VK_BROWSER_BACK','LongInt').SetInt( 166);
 CL.AddConstantN('VK_BROWSER_FORWARD','LongInt').SetInt( 167);
 CL.AddConstantN('VK_BROWSER_REFRESH','LongInt').SetInt( 168);
 CL.AddConstantN('VK_BROWSER_STOP','LongInt').SetInt( 169);
 CL.AddConstantN('VK_BROWSER_SEARCH','LongInt').SetInt( 170);
 CL.AddConstantN('VK_BROWSER_FAVORITES','LongInt').SetInt( 171);
 CL.AddConstantN('VK_BROWSER_HOME','LongInt').SetInt( 172);
 CL.AddConstantN('VK_VOLUME_MUTE','LongInt').SetInt( 173);
 CL.AddConstantN('VK_VOLUME_DOWN','LongInt').SetInt( 174);
 CL.AddConstantN('VK_VOLUME_UP','LongInt').SetInt( 175);
 CL.AddConstantN('VK_MEDIA_NEXT_TRACK','LongInt').SetInt( 176);
 CL.AddConstantN('VK_MEDIA_PREV_TRACK','LongInt').SetInt( 177);
 CL.AddConstantN('VK_MEDIA_STOP','LongInt').SetInt( 178);
 CL.AddConstantN('VK_MEDIA_PLAY_PAUSE','LongInt').SetInt( 179);
 CL.AddConstantN('VK_LAUNCH_MAIL','LongInt').SetInt( 180);
 CL.AddConstantN('VK_LAUNCH_MEDIA_SELECT','LongInt').SetInt( 181);
 CL.AddConstantN('VK_LAUNCH_APP1','LongInt').SetInt( 182);
 CL.AddConstantN('VK_LAUNCH_APP2','LongInt').SetInt( 183);
 CL.AddConstantN('VK_OEM_1','LongInt').SetInt( 186);
 CL.AddConstantN('VK_OEM_PLUS','LongInt').SetInt( 187);
 CL.AddConstantN('VK_OEM_COMMA','LongInt').SetInt( 188);
 CL.AddConstantN('VK_OEM_MINUS','LongInt').SetInt( 189);
 CL.AddConstantN('VK_OEM_PERIOD','LongInt').SetInt( 190);
 CL.AddConstantN('VK_OEM_2','LongInt').SetInt( 191);
 CL.AddConstantN('VK_OEM_3','LongInt').SetInt( 192);
 CL.AddConstantN('VK_OEM_4','LongInt').SetInt( 219);
 CL.AddConstantN('VK_OEM_5','LongInt').SetInt( 220);
 CL.AddConstantN('VK_OEM_6','LongInt').SetInt( 221);
 CL.AddConstantN('VK_OEM_7','LongInt').SetInt( 222);
 CL.AddConstantN('VK_OEM_8','LongInt').SetInt( 223);
 CL.AddConstantN('VK_OEM_102','LongInt').SetInt( 226);
 CL.AddConstantN('VK_PACKET','LongInt').SetInt( 231);
 CL.AddConstantN('VK_PROCESSKEY','LongInt').SetInt( 229);
 CL.AddConstantN('VK_ATTN','LongInt').SetInt( 246);
 CL.AddConstantN('VK_CRSEL','LongInt').SetInt( 247);
 CL.AddConstantN('VK_EXSEL','LongInt').SetInt( 248);
 CL.AddConstantN('VK_EREOF','LongInt').SetInt( 249);
 CL.AddConstantN('VK_PLAY','LongInt').SetInt( 250);
 CL.AddConstantN('VK_ZOOM','LongInt').SetInt( 251);
 CL.AddConstantN('VK_NONAME','LongInt').SetInt( 252);
 CL.AddConstantN('VK_PA1','LongInt').SetInt( 253);
 CL.AddConstantN('VK_OEM_CLEAR','LongInt').SetInt( 254);
 CL.AddConstantN('HC_ACTION','LongInt').SetInt( 0);
 CL.AddConstantN('HC_GETNEXT','LongInt').SetInt( 1);
 CL.AddConstantN('HC_SKIP','LongInt').SetInt( 2);
 CL.AddConstantN('HC_NOREMOVE','LongInt').SetInt( 3);
 CL.AddConstantN('HC_NOREM','longint').Setint(3);
 CL.AddConstantN('HC_SYSMODALON','LongInt').SetInt( 4);
 CL.AddConstantN('HC_SYSMODALOFF','LongInt').SetInt( 5);
 CL.AddConstantN('HCBT_MOVESIZE','LongInt').SetInt( 0);
 CL.AddConstantN('HCBT_MINMAX','LongInt').SetInt( 1);
 CL.AddConstantN('HCBT_QS','LongInt').SetInt( 2);
 CL.AddConstantN('HCBT_CREATEWND','LongInt').SetInt( 3);
 CL.AddConstantN('HCBT_DESTROYWND','LongInt').SetInt( 4);
 CL.AddConstantN('HCBT_ACTIVATE','LongInt').SetInt( 5);
 CL.AddConstantN('HCBT_CLICKSKIPPED','LongInt').SetInt( 6);
 CL.AddConstantN('HCBT_KEYSKIPPED','LongInt').SetInt( 7);
 CL.AddConstantN('HCBT_SYSCOMMAND','LongInt').SetInt( 8);
 CL.AddConstantN('HCBT_SETFOCUS','LongInt').SetInt( 9);
 CL.AddConstantN('APPCOMMAND_HELP','LongInt').SetInt( 27);
 CL.AddConstantN('APPCOMMAND_FIND','LongInt').SetInt( 28);
 CL.AddConstantN('APPCOMMAND_NEW','LongInt').SetInt( 29);
 CL.AddConstantN('APPCOMMAND_OPEN','LongInt').SetInt( 30);
 CL.AddConstantN('APPCOMMAND_CLOSE','LongInt').SetInt( 31);
 CL.AddConstantN('APPCOMMAND_SAVE','LongInt').SetInt( 32);
 CL.AddConstantN('APPCOMMAND_PRINT','LongInt').SetInt( 33);
 CL.AddConstantN('APPCOMMAND_UNDO','LongInt').SetInt( 34);
 CL.AddConstantN('APPCOMMAND_REDO','LongInt').SetInt( 35);
 CL.AddConstantN('APPCOMMAND_COPY','LongInt').SetInt( 36);
 CL.AddConstantN('APPCOMMAND_CUT','LongInt').SetInt( 37);
 CL.AddConstantN('APPCOMMAND_PASTE','LongInt').SetInt( 38);
 CL.AddConstantN('APPCOMMAND_REPLY_TO_MAIL','LongInt').SetInt( 39);
 CL.AddConstantN('APPCOMMAND_FORWARD_MAIL','LongInt').SetInt( 40);
 CL.AddConstantN('APPCOMMAND_SEND_MAIL','LongInt').SetInt( 41);
 CL.AddConstantN('APPCOMMAND_SPELL_CHECK','LongInt').SetInt( 42);
 CL.AddConstantN('APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE','LongInt').SetInt( 43);
 CL.AddConstantN('APPCOMMAND_MIC_ON_OFF_TOGGLE','LongInt').SetInt( 44);
 CL.AddConstantN('APPCOMMAND_CORRECTION_LIST','LongInt').SetInt( 45);
 CL.AddConstantN('APPCOMMAND_MEDIA_PLAY','LongInt').SetInt( 46);
 CL.AddConstantN('APPCOMMAND_MEDIA_PAUSE','LongInt').SetInt( 47);
 CL.AddConstantN('APPCOMMAND_MEDIA_RECORD','LongInt').SetInt( 48);
 CL.AddConstantN('APPCOMMAND_MEDIA_FAST_FORWARD','LongInt').SetInt( 49);
 CL.AddConstantN('APPCOMMAND_MEDIA_REWIND','LongInt').SetInt( 50);
 CL.AddConstantN('APPCOMMAND_MEDIA_CHANNEL_UP','LongInt').SetInt( 51);
 CL.AddConstantN('APPCOMMAND_MEDIA_CHANNEL_DOWN','LongInt').SetInt( 52);
 CL.AddConstantN('APPCOMMAND_DELETE','LongInt').SetInt( 53);
 CL.AddConstantN('APPCOMMAND_DWM_FLIP3D','LongInt').SetInt( 54);
 CL.AddConstantN('FAPPCOMMAND_MOUSE','LongWord').SetUInt( $8000);
 CL.AddConstantN('FAPPCOMMAND_KEY','LongInt').SetInt( 0);
 CL.AddConstantN('FAPPCOMMAND_OEM','LongWord').SetUInt( $1000);
 CL.AddConstantN('FAPPCOMMAND_MASK','LongWord').SetUInt( $F000);
 CL.AddConstantN('APPCOMMAND_BROWSER_BACKWARD','LongInt').SetInt( 1);
 CL.AddConstantN('APPCOMMAND_BROWSER_FORWARD','LongInt').SetInt( 2);
 CL.AddConstantN('APPCOMMAND_BROWSER_REFRESH','LongInt').SetInt( 3);
 CL.AddConstantN('APPCOMMAND_BROWSER_STOP','LongInt').SetInt( 4);
 CL.AddConstantN('APPCOMMAND_BROWSER_SEARCH','LongInt').SetInt( 5);
 CL.AddConstantN('APPCOMMAND_BROWSER_FAVORITES','LongInt').SetInt( 6);
 CL.AddConstantN('APPCOMMAND_BROWSER_HOME','LongInt').SetInt( 7);
 CL.AddConstantN('APPCOMMAND_VOLUME_MUTE','LongInt').SetInt( 8);
 CL.AddConstantN('APPCOMMAND_VOLUME_DOWN','LongInt').SetInt( 9);
 CL.AddConstantN('APPCOMMAND_VOLUME_UP','LongInt').SetInt( 10);
 CL.AddConstantN('APPCOMMAND_MEDIA_NEXTTRACK','LongInt').SetInt( 11);
 CL.AddConstantN('APPCOMMAND_MEDIA_PREVIOUSTRACK','LongInt').SetInt( 12);
 CL.AddConstantN('APPCOMMAND_MEDIA_STOP','LongInt').SetInt( 13);
 CL.AddConstantN('APPCOMMAND_MEDIA_PLAY_PAUSE','LongInt').SetInt( 14);
 CL.AddConstantN('APPCOMMAND_LAUNCH_MAIL','LongInt').SetInt( 15);
 CL.AddConstantN('APPCOMMAND_LAUNCH_MEDIA_SELECT','LongInt').SetInt( 16);
 CL.AddConstantN('APPCOMMAND_LAUNCH_APP1','LongInt').SetInt( 17);
 CL.AddConstantN('APPCOMMAND_LAUNCH_APP2','LongInt').SetInt( 18);
 CL.AddConstantN('APPCOMMAND_BASS_DOWN','LongInt').SetInt( 19);
 CL.AddConstantN('APPCOMMAND_BASS_BOOST','LongInt').SetInt( 20);
 CL.AddConstantN('APPCOMMAND_BASS_UP','LongInt').SetInt( 21);
 CL.AddConstantN('APPCOMMAND_TREBLE_DOWN','LongInt').SetInt( 22);
 CL.AddConstantN('APPCOMMAND_TREBLE_UP','LongInt').SetInt( 23);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_MUTE','LongInt').SetInt( 24);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_DOWN','LongInt').SetInt( 25);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_UP','LongInt').SetInt( 26);
 CL.AddConstantN('WS_CHILD','LongWord').SetUInt( $40000000);
 CL.AddConstantN('WS_MINIMIZE','LongWord').SetUInt( $20000000);
 CL.AddConstantN('WS_VISIBLE','LongWord').SetUInt( $10000000);
 CL.AddConstantN('WS_OVERLAPPED','LongInt').SetInt( 0);
 CL.AddConstantN('WS_POPUP','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('WS_DISABLED','LongWord').SetUInt( $8000000);
 CL.AddConstantN('WS_CLIPSIBLINGS','LongWord').SetUInt( $4000000);
 CL.AddConstantN('WS_CLIPCHILDREN','LongWord').SetUInt( $2000000);
 CL.AddConstantN('WS_MAXIMIZE','LongWord').SetUInt( $1000000);
 CL.AddConstantN('WS_CAPTION','LongWord').SetUInt( $C00000);
 CL.AddConstantN('WS_BORDER','LongWord').SetUInt( $800000);
 CL.AddConstantN('WS_DLGFRAME','LongWord').SetUInt( $400000);
 CL.AddConstantN('WS_VSCROLL','LongWord').SetUInt( $200000);
 CL.AddConstantN('WS_HSCROLL','LongWord').SetUInt( $100000);
 CL.AddConstantN('WS_SYSMENU','LongWord').SetUInt( $80000);
 CL.AddConstantN('WS_THICKFRAME','LongWord').SetUInt( $40000);
 CL.AddConstantN('WS_GROUP','LongWord').SetUInt( $20000);
 CL.AddConstantN('WS_TABSTOP','LongWord').SetUInt( $10000);
 CL.AddConstantN('WS_MINIMIZEBOX','LongWord').SetUInt( $20000);
 CL.AddConstantN('WS_MAXIMIZEBOX','LongWord').SetUInt( $10000);
 CL.AddConstantN('WS_TILED','longword').SetUInt( 0);
 CL.AddConstantN('WS_ICONIC','longword').SetUInt( $20000000);
 CL.AddConstantN('WS_SIZEBOX','longword').SetUInt( $40000);
 CL.AddConstantN('WS_TILEDWINDOW','longword').SetUInt(0);
 CL.AddConstantN('HSHELL_WINDOWCREATED','LongInt').SetInt( 1);
 CL.AddConstantN('HSHELL_WINDOWDESTROYED','LongInt').SetInt( 2);
 CL.AddConstantN('HSHELL_ACTIVATESHELLWINDOW','LongInt').SetInt( 3);
 CL.AddConstantN('HSHELL_WINDOWACTIVATED','LongInt').SetInt( 4);
 CL.AddConstantN('HSHELL_GETMINRECT','LongInt').SetInt( 5);
 CL.AddConstantN('HSHELL_REDRAW','LongInt').SetInt( 6);
 CL.AddConstantN('HSHELL_TASKMAN','LongInt').SetInt( 7);
 CL.AddConstantN('HSHELL_LANGUAGE','LongInt').SetInt( 8);
 CL.AddConstantN('HSHELL_ACCESSIBILITYSTATE','LongInt').SetInt( 11);
 CL.AddConstantN('HSHELL_APPCOMMAND','LongInt').SetInt( 12);
 CL.AddConstantN('HSHELL_WINDOWREPLACED','LongInt').SetInt( 13);
 CL.AddConstantN('ISMEX_NOSEND','LongInt').SetInt( 0);
 CL.AddConstantN('ISMEX_SEND','LongInt').SetInt( 1);
 CL.AddConstantN('ISMEX_NOTIFY','LongInt').SetInt( 2);
 CL.AddConstantN('ISMEX_CALLBACK','LongInt').SetInt( 4);
 CL.AddConstantN('ISMEX_REPLIED','LongInt').SetInt( 8);
 CL.AddConstantN('KEYEVENTF_EXTENDEDKEY','LongInt').SetInt( 1);
 CL.AddConstantN('KEYEVENTF_KEYUP','LongInt').SetInt( 2);
 CL.AddConstantN('MOUSEEVENTF_MOVE','LongWord').SetUInt( $0001);
 CL.AddConstantN('MOUSEEVENTF_LEFTDOWN','LongWord').SetUInt( $0002);
 CL.AddConstantN('MOUSEEVENTF_LEFTUP','LongWord').SetUInt( $0004);
 CL.AddConstantN('MOUSEEVENTF_RIGHTDOWN','LongWord').SetUInt( $0008);
 CL.AddConstantN('MOUSEEVENTF_RIGHTUP','LongWord').SetUInt( $0010);
 CL.AddConstantN('MOUSEEVENTF_MIDDLEDOWN','LongWord').SetUInt( $0020);
 CL.AddConstantN('MOUSEEVENTF_MIDDLEUP','LongWord').SetUInt( $0040);
 CL.AddConstantN('MOUSEEVENTF_WHEEL','LongWord').SetUInt( $0800);
 CL.AddConstantN('MOUSEEVENTF_ABSOLUTE','LongWord').SetUInt( $8000);
 CL.AddConstantN('EW_RESTARTWINDOWS','LongWord').SetUInt( $0042);
 CL.AddConstantN('EW_REBOOTSYSTEM','LongWord').SetUInt( $0043);
 CL.AddConstantN('EW_EXITANDEXECAPP','LongWord').SetUInt( $0044);
 CL.AddConstantN('ENDSESSION_LOGOFF','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddConstantN('EWX_LOGOFF','LongInt').SetInt( 0);
 CL.AddConstantN('EWX_SHUTDOWN','LongInt').SetInt( 1);
 CL.AddConstantN('EWX_REBOOT','LongInt').SetInt( 2);
 CL.AddConstantN('EWX_FORCE','LongInt').SetInt( 4);
 CL.AddConstantN('EWX_POWEROFF','LongInt').SetInt( 8);
 CL.AddConstantN('EWX_FORCEIFHUNG','LongWord').SetUInt( $10);
  CL.AddConstantN('STATUS_WAIT_0','LongWord').SetUInt( $00000000);
 CL.AddConstantN('STATUS_ABANDONED_WAIT_0','LongWord').SetUInt( $00000080);
 CL.AddConstantN('STATUS_USER_APC','LongWord').SetUInt( $000000C0);
 CL.AddConstantN('STATUS_TIMEOUT','LongWord').SetUInt( $00000102);
 CL.AddConstantN('STATUS_PENDING','LongWord').SetUInt( $00000103);
 CL.AddConstantN('STATUS_SEGMENT_NOTIFICATION','LongWord').SetUInt( $40000005);
 CL.AddConstantN('STATUS_GUARD_PAGE_VIOLATION','LongWord').SetUInt( DWORD ( $80000001 ));
 CL.AddConstantN('STATUS_DATATYPE_MISALIGNMENT','LongWord').SetUInt( DWORD ( $80000002 ));
 CL.AddConstantN('STATUS_BREAKPOINT','LongWord').SetUInt( DWORD ( $80000003 ));
 CL.AddConstantN('STATUS_SINGLE_STEP','LongWord').SetUInt( DWORD ( $80000004 ));
 CL.AddConstantN('STATUS_ACCESS_VIOLATION','LongWord').SetUInt( DWORD ( $C0000005 ));
 CL.AddConstantN('STATUS_IN_PAGE_ERROR','LongWord').SetUInt( DWORD ( $C0000006 ));
 CL.AddConstantN('STATUS_INVALID_HANDLE','LongWord').SetUInt( DWORD ( $C0000008 ));
 CL.AddConstantN('STATUS_NO_MEMORY','LongWord').SetUInt( DWORD ( $C0000017 ));
 CL.AddConstantN('STATUS_ILLEGAL_INSTRUCTION','LongWord').SetUInt( DWORD ( $C000001D ));
 CL.AddConstantN('STATUS_NONCONTINUABLE_EXCEPTION','LongWord').SetUInt( DWORD ( $C0000025 ));
 CL.AddConstantN('STATUS_INVALID_DISPOSITION','LongWord').SetUInt( DWORD ( $C0000026 ));
 CL.AddConstantN('STATUS_ARRAY_BOUNDS_EXCEEDED','LongWord').SetUInt( DWORD ( $C000008C ));
 CL.AddConstantN('STATUS_FLOAT_DENORMAL_OPERAND','LongWord').SetUInt( DWORD ( $C000008D ));
 CL.AddConstantN('STATUS_FLOAT_DIVIDE_BY_ZERO','LongWord').SetUInt( DWORD ( $C000008E ));
 CL.AddConstantN('STATUS_FLOAT_INEXACT_RESULT','LongWord').SetUInt( DWORD ( $C000008F ));
 CL.AddConstantN('STATUS_FLOAT_INVALID_OPERATION','LongWord').SetUInt( DWORD ( $C0000090 ));
 CL.AddConstantN('STATUS_FLOAT_OVERFLOW','LongWord').SetUInt( DWORD ( $C0000091 ));
 CL.AddConstantN('STATUS_FLOAT_STACK_CHECK','LongWord').SetUInt( DWORD ( $C0000092 ));
 CL.AddConstantN('STATUS_FLOAT_UNDERFLOW','LongWord').SetUInt( DWORD ( $C0000093 ));
 CL.AddConstantN('STATUS_INTEGER_DIVIDE_BY_ZERO','LongWord').SetUInt( DWORD ( $C0000094 ));
 CL.AddConstantN('STATUS_INTEGER_OVERFLOW','LongWord').SetUInt( DWORD ( $C0000095 ));
 CL.AddConstantN('STATUS_PRIVILEGED_INSTRUCTION','LongWord').SetUInt( DWORD ( $C0000096 ));
 CL.AddConstantN('STATUS_STACK_OVERFLOW','LongWord').SetUInt( DWORD ( $C00000FD ));
 CL.AddConstantN('STATUS_CONTROL_C_EXIT','LongWord').SetUInt( DWORD ( $C000013A ));
 CL.AddConstantN('MAXIMUM_WAIT_OBJECTS','LongInt').SetInt( 64);
 CL.AddConstantN('SIZE_OF_80387_REGISTERS','LongInt').SetInt( 80);
 CL.AddConstantN('CONTEXT_i386','LongWord').SetUInt( $10000);
 CL.AddConstantN('CONTEXT_i486','LongWord').SetUInt( $10000);

 CL.AddConstantN('VER_PLATFORM_WIN32s','LongInt').SetInt( 0);
 CL.AddConstantN('VER_PLATFORM_WIN32_WINDOWS','LongInt').SetInt( 1);
 CL.AddConstantN('VER_PLATFORM_WIN32_NT','LongInt').SetInt( 2);
 CL.AddConstantN('VER_PLATFORM_WIN32_CE','LongInt').SetInt( 3);
 CL.AddConstantN('STATUS_TIMEOUT','LongWord').SetUInt($00000102);
 CL.AddConstantN('WAIT_TIMEOUT','LongWord').SetUInt($00000102);
 CL.AddConstantN('STATUS_WAIT_0','LongWord').SetUInt($00000000);
 CL.AddConstantN('WAIT_OBJECT_0','LongWord').SetUInt($00000000+0);
 CL.AddConstantN('WAIT_ABANDONED','LongWord').SetUInt($00000080+0);
 CL.AddConstantN('WAIT_ABANDONED_0','LongWord').SetUInt($00000080+0);

 CL.AddConstantN('THREAD_BASE_PRIORITY_LOWRT','LongInt').SetInt( 15);
 CL.AddConstantN('THREAD_BASE_PRIORITY_MAX','LongInt').SetInt( 2);
 CL.AddConstantN('THREAD_BASE_PRIORITY_MIN','LongInt').SetInt( - 2);
 CL.AddConstantN('THREAD_BASE_PRIORITY_IDLE','LongInt').SetInt( - 15);
 CL.AddConstantN('THREAD_PRIORITY_LOWEST','longint').SetInt( THREAD_BASE_PRIORITY_MIN);
 CL.AddConstantN('THREAD_PRIORITY_BELOW_NORMAL','LongInt').SetInt( THREAD_PRIORITY_LOWEST + 1);
 CL.AddConstantN('THREAD_PRIORITY_NORMAL','LongInt').SetInt( 0);
 CL.AddConstantN('THREAD_PRIORITY_HIGHEST','longint').SetInt( THREAD_BASE_PRIORITY_MAX);
 CL.AddConstantN('THREAD_PRIORITY_ABOVE_NORMAL','LongInt').SetInt( THREAD_PRIORITY_HIGHEST - 1);
 CL.AddConstantN('THREAD_PRIORITY_ERROR_RETURN','longint').SetInt( MAXLONG);
 CL.AddConstantN('THREAD_PRIORITY_TIME_CRITICAL','longint').SetInt( THREAD_BASE_PRIORITY_LOWRT);
 CL.AddConstantN('THREAD_PRIORITY_IDLE','longint').SetInt( THREAD_BASE_PRIORITY_IDLE);
 //CL.AddConstantN('GWL_HINSTANCE','LongInt').SetInt( - 6);
 //CL.AddConstantN('GWL_HWNDPARENT','LongInt').SetInt( - 8);
 //CL.AddConstantN('GWL_EXSTYLE','LongInt').SetInt( - 20);
 //CL.AddConstantN('GWL_USERDATA','LongInt').SetInt( - 21);
 //CL.AddConstantN('GWL_ID','LongInt').SetInt( - 12);
 CL.AddConstantN('SWP_FRAMECHANGED','LongWord').SetUInt( $20);
  CL.AddConstantN('GWL_WNDPROC','LongInt').SetInt( - 4);
 CL.AddConstantN('GWL_HINSTANCE','LongInt').SetInt( - 6);
 CL.AddConstantN('GWL_HWNDPARENT','LongInt').SetInt( - 8);
 CL.AddConstantN('GWL_STYLE','LongInt').SetInt( - 16);
 CL.AddConstantN('GWL_EXSTYLE','LongInt').SetInt( - 20);
 CL.AddConstantN('GWL_USERDATA','LongInt').SetInt( - 21);
 CL.AddConstantN('GWL_ID','LongInt').SetInt( - 12);
 CL.AddConstantN('HWND_TOP','LongInt').SetInt( 0);
 CL.AddConstantN('HWND_BOTTOM','LongInt').SetInt( 1);
 CL.AddConstantN('HWND_TOPMOST','LongInt').SetInt( HWND ( - 1 ));
 CL.AddConstantN('HWND_NOTOPMOST','LongInt').SetInt( HWND ( - 2 ));

  CL.AddConstantN('HKEY_CLASSES_ROOT','LongInt').SetInt($80000000);
  CL.AddConstantN('HKEY_CURRENT_USER','LongInt').SetInt($80000001);
  CL.AddConstantN('HKEY_LOCAL_MACHINE','LongInt').SetInt($80000002);
  CL.AddConstantN('HKEY_USERS','LongInt').SetInt($80000003);
  CL.AddConstantN('HKEY_PERFORMANCE_DATA','LongInt').SetInt($80000004);
  CL.AddConstantN('HKEY_CURRENT_CONFIG','LongInt').SetInt($80000005);
  CL.AddConstantN('HKEY_DYN_DATA','LongInt').SetInt($80000006);
  CL.AddConstantN('KEY_READ2','LongInt').SetInt(131097);

  //KEY_READ
  CL.AddConstantN('FACILITY_WINDOWS','LongInt').SetInt( 8);
 CL.AddConstantN('FACILITY_STORAGE','LongInt').SetInt( 3);
 CL.AddConstantN('FACILITY_RPC','LongInt').SetInt( 1);
 CL.AddConstantN('FACILITY_SSPI','LongInt').SetInt( 9);
 CL.AddConstantN('FACILITY_WIN32','LongInt').SetInt( 7);
 CL.AddConstantN('FACILITY_CONTROL','LongInt').SetInt( 10);
 CL.AddConstantN('FACILITY_NULL','LongInt').SetInt( 0);
 CL.AddConstantN('FACILITY_INTERNET','LongInt').SetInt( 12);
 CL.AddConstantN('FACILITY_ITF','LongInt').SetInt( 4);
 CL.AddConstantN('FACILITY_DISPATCH','LongInt').SetInt( 2);
 CL.AddConstantN('FACILITY_CERT','LongInt').SetInt( 11);
 CL.AddConstantN('ERROR_SUCCESS','LongInt').SetInt( 0);
 CL.AddConstantN('NO_ERROR','LongInt').SetInt( 0);
 CL.AddConstantN('ERROR_INVALID_FUNCTION','LongInt').SetInt( 1);
 CL.AddConstantN('ERROR_FILE_NOT_FOUND','LongInt').SetInt( 2);
 CL.AddConstantN('ERROR_PATH_NOT_FOUND','LongInt').SetInt( 3);
 CL.AddConstantN('ERROR_TOO_MANY_OPEN_FILES','LongInt').SetInt( 4);
 CL.AddConstantN('ERROR_ACCESS_DENIED','LongInt').SetInt( 5);
 CL.AddConstantN('ERROR_INVALID_HANDLE','LongInt').SetInt( 6);
 CL.AddConstantN('ERROR_ARENA_TRASHED','LongInt').SetInt( 7);
 CL.AddConstantN('ERROR_NOT_ENOUGH_MEMORY','LongInt').SetInt( 8);
 CL.AddConstantN('ERROR_INVALID_BLOCK','LongInt').SetInt( 9);
 CL.AddConstantN('ERROR_BAD_ENVIRONMENT','LongInt').SetInt( 10);
 CL.AddConstantN('ERROR_BAD_FORMAT','LongInt').SetInt( 11);
 CL.AddConstantN('ERROR_INVALID_ACCESS','LongInt').SetInt( 12);
 CL.AddConstantN('ERROR_INVALID_DATA','LongInt').SetInt( 13);
 CL.AddConstantN('ERROR_OUTOFMEMORY','LongInt').SetInt( 14);
 CL.AddConstantN('ERROR_INVALID_DRIVE','LongInt').SetInt( 15);
 CL.AddConstantN('ERROR_CURRENT_DIRECTORY','LongWord').SetUInt( $10);
 CL.AddConstantN('ERROR_NOT_SAME_DEVICE','LongInt').SetInt( 17);
 CL.AddConstantN('ERROR_NO_MORE_FILES','LongInt').SetInt( 18);
 CL.AddConstantN('ERROR_WRITE_PROTECT','LongInt').SetInt( 19);
 CL.AddConstantN('ERROR_BAD_UNIT','LongInt').SetInt( 20);
 CL.AddConstantN('ERROR_NOT_READY','LongInt').SetInt( 21);
 CL.AddConstantN('ERROR_BAD_COMMAND','LongInt').SetInt( 22);
 CL.AddConstantN('ERROR_CRC','LongInt').SetInt( 23);
 CL.AddConstantN('ERROR_BAD_LENGTH','LongInt').SetInt( 24);
 CL.AddConstantN('ERROR_SEEK','LongInt').SetInt( 25);
 CL.AddConstantN('ERROR_NOT_DOS_DISK','LongInt').SetInt( 26);
 CL.AddConstantN('ERROR_SECTOR_NOT_FOUND','LongInt').SetInt( 27);
 CL.AddConstantN('ERROR_OUT_OF_PAPER','LongInt').SetInt( 28);
 CL.AddConstantN('ERROR_WRITE_FAULT','LongInt').SetInt( 29);
 CL.AddConstantN('ERROR_READ_FAULT','LongInt').SetInt( 30);
 CL.AddConstantN('ERROR_GEN_FAILURE','LongInt').SetInt( 31);
 CL.AddConstantN('ERROR_SHARING_VIOLATION','LongWord').SetUInt( $20);
 CL.AddConstantN('ERROR_LOCK_VIOLATION','LongInt').SetInt( 33);
 CL.AddConstantN('ERROR_WRONG_DISK','LongInt').SetInt( 34);
 CL.AddConstantN('ERROR_SHARING_BUFFER_EXCEEDED','LongInt').SetInt( 36);
 CL.AddConstantN('ERROR_HANDLE_EOF','LongInt').SetInt( 38);
 CL.AddConstantN('ERROR_HANDLE_DISK_FULL','LongInt').SetInt( 39);
 CL.AddConstantN('ERROR_NOT_SUPPORTED','LongInt').SetInt( 50);
 CL.AddConstantN('ERROR_REM_NOT_LIST','LongInt').SetInt( 51);
 CL.AddConstantN('ERROR_DUP_NAME','LongInt').SetInt( 52);
 CL.AddConstantN('ERROR_BAD_NETPATH','LongInt').SetInt( 53);
 CL.AddConstantN('ERROR_NETWORK_BUSY','LongInt').SetInt( 54);
 CL.AddConstantN('ERROR_DEV_NOT_EXIST','LongInt').SetInt( 55);
 CL.AddConstantN('ERROR_TOO_MANY_CMDS','LongInt').SetInt( 56);
 CL.AddConstantN('ERROR_ADAP_HDW_ERR','LongInt').SetInt( 57);
 CL.AddConstantN('ERROR_BAD_NET_RESP','LongInt').SetInt( 58);
 CL.AddConstantN('ERROR_UNEXP_NET_ERR','LongInt').SetInt( 59);
 CL.AddConstantN('ERROR_BAD_REM_ADAP','LongInt').SetInt( 60);
 CL.AddConstantN('ERROR_PRINTQ_FULL','LongInt').SetInt( 61);
 CL.AddConstantN('ERROR_NO_SPOOL_SPACE','LongInt').SetInt( 62);
 CL.AddConstantN('ERROR_PRINT_CANCELLED','LongInt').SetInt( 63);

  CL.AddConstantN('KEY_QUERY_VALUE','LongWord').SetUInt( $0001);
 CL.AddConstantN('KEY_SET_VALUE','LongWord').SetUInt( $0002);
 CL.AddConstantN('KEY_CREATE_SUB_KEY','LongWord').SetUInt( $0004);
 CL.AddConstantN('KEY_ENUMERATE_SUB_KEYS','LongWord').SetUInt( $0008);
 CL.AddConstantN('KEY_NOTIFY','LongWord').SetUInt( $0010);
 CL.AddConstantN('KEY_CREATE_LINK','LongWord').SetUInt( $0020);
 CL.AddConstantN('KEY_WOW64_32KEY','LongWord').SetUInt( $0200);
 CL.AddConstantN('KEY_WOW64_64KEY','LongWord').SetUInt( $0100);
 CL.AddConstantN('KEY_WOW64_RES','LongWord').SetUInt( $0300);
 CL.AddConstantN('REG_OPTION_RESERVED','LongWord').SetUInt( ( $00000000 ));
 CL.AddConstantN('REG_OPTION_NON_VOLATILE','LongWord').SetUInt( ( $00000000 ));
 CL.AddConstantN('REG_OPTION_VOLATILE','LongWord').SetUInt( ( $00000001 ));
 CL.AddConstantN('REG_OPTION_CREATE_LINK','LongWord').SetUInt( ( $00000002 ));
 CL.AddConstantN('REG_OPTION_BACKUP_RESTORE','LongWord').SetUInt( ( $00000004 ));
 CL.AddConstantN('REG_CREATED_NEW_KEY','LongWord').SetUInt( ( $00000001 ));
 CL.AddConstantN('REG_OPENED_EXISTING_KEY','LongWord').SetUInt( ( $00000002 ));
 CL.AddConstantN('REG_WHOLE_HIVE_VOLATILE','LongWord').SetUInt( ( $00000001 ));
 CL.AddConstantN('REG_REFRESH_HIVE','LongWord').SetUInt( ( $00000002 ));
 CL.AddConstantN('REG_NOTIFY_CHANGE_NAME','LongWord').SetUInt( ( $00000001 ));
 CL.AddConstantN('REG_NOTIFY_CHANGE_ATTRIBUTES','LongWord').SetUInt( ( $00000002 ));
 CL.AddConstantN('REG_NOTIFY_CHANGE_LAST_SET','LongWord').SetUInt( ( $00000004 ));
 CL.AddConstantN('REG_NOTIFY_CHANGE_SECURITY','LongWord').SetUInt( ( $00000008 ));
 CL.AddConstantN('REG_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('REG_SZ','LongInt').SetInt( 1);
 CL.AddConstantN('REG_EXPAND_SZ','LongInt').SetInt( 2);
 CL.AddConstantN('REG_BINARY','LongInt').SetInt( 3);
 CL.AddConstantN('REG_DWORD','LongInt').SetInt( 4);
 CL.AddConstantN('REG_DWORD_LITTLE_ENDIAN','LongInt').SetInt( 4);
 CL.AddConstantN('REG_DWORD_BIG_ENDIAN','LongInt').SetInt( 5);
 CL.AddConstantN('REG_LINK','LongInt').SetInt( 6);
 CL.AddConstantN('REG_MULTI_SZ','LongInt').SetInt( 7);
 CL.AddConstantN('REG_RESOURCE_LIST','LongInt').SetInt( 8);
 CL.AddConstantN('REG_FULL_RESOURCE_DESCRIPTOR','LongInt').SetInt( 9);
 CL.AddConstantN('REG_RESOURCE_REQUIREMENTS_LIST','LongInt').SetInt( 10);
  CL.AddTypeS('LPARAM','LongInt');
  CL.AddTypeS('WPARAM','LongInt');
  CL.AddTypeS('LRESULT','Longint');
    CL.AddTypeS('HHOOK', 'LongWord');
    CL.AddTypeS('HINST','THandle');
    CL.AddTypeS('TNavPos','(tLat, tLon)');
 CL.AddConstantN('WM_NULL','LongWord').SetUInt( $0000);
 CL.AddConstantN('WM_CREATE','LongWord').SetUInt( $0001);
 CL.AddConstantN('WM_DESTROY','LongWord').SetUInt( $0002);
 CL.AddConstantN('WM_MOVE','LongWord').SetUInt( $0003);
 CL.AddConstantN('WM_SIZE','LongWord').SetUInt( $0005);
 CL.AddConstantN('WM_ACTIVATE','LongWord').SetUInt( $0006);
 CL.AddConstantN('WM_SETFOCUS','LongWord').SetUInt( $0007);
 CL.AddConstantN('WM_KILLFOCUS','LongWord').SetUInt( $0008);
 CL.AddConstantN('WM_QUERYENDSESSION','LongWord').SetUInt( $0011);
 CL.AddConstantN('WM_QUIT','LongWord').SetUInt( $0012);
 CL.AddConstantN('WM_QUERYOPEN','LongWord').SetUInt( $0013);
 CL.AddConstantN('WM_ERASEBKGND','LongWord').SetUInt( $0014);
 CL.AddConstantN('WM_SYSCOLORCHANGE','LongWord').SetUInt( $0015);
 CL.AddConstantN('WM_ENDSESSION','LongWord').SetUInt( $0016);
 CL.AddConstantN('WM_SYSTEMERROR','LongWord').SetUInt( $0017);
 CL.AddConstantN('WM_SHOWWINDOW','LongWord').SetUInt( $0018);
  CL.AddTypeS('TFNHookProc','function (code: Integer; wparam: WPARAM; lparam: LPARAM): LRESULT stdcall;');
  CL.AddConstantN('FILEOPENORD','LongInt').SetInt( 1536);
 CL.AddConstantN('MULTIFILEOPENORD','LongInt').SetInt( 1537);
 CL.AddConstantN('PRINTDLGORD','LongInt').SetInt( 1538);
 CL.AddConstantN('PRNSETUPDLGORD','LongInt').SetInt( 1539);
 CL.AddConstantN('FINDDLGORD','LongInt').SetInt( 1540);
 CL.AddConstantN('REPLACEDLGORD','LongInt').SetInt( 1541);
 CL.AddConstantN('FONTDLGORD','LongInt').SetInt( 1542);
 CL.AddConstantN('FORMATDLGORD31','LongInt').SetInt( 1543);
 CL.AddConstantN('FORMATDLGORD30','LongInt').SetInt( 1544);
 CL.AddConstantN('PAGESETUPDLGORD','LongInt').SetInt( 1546);
 CL.AddConstantN('NEWFILEOPENORD','LongInt').SetInt( 1547);
  CL.AddTypeS('tagCRGB', 'record bRed : BYTE; bGreen : BYTE; bBlue : BYTE; bExtra: BYTE; end');
  CL.AddTypeS('CRGB', 'tagCRGB');
  // TFNHookProc = function (code: Integer; wparam: WPARAM; lparam: LPARAM): LRESULT stdcall;
 CL.AddDelphiFunction('Function SetWindowsHook( nFilterType : Integer; pfnFilterProc : TFNHookProc) : HHOOK');
 CL.AddDelphiFunction('Function SetWindowsHookA( nFilterType : Integer; pfnFilterProc : TFNHookProc) : HHOOK');
 CL.AddDelphiFunction('Function SetWindowsHookW( nFilterType : Integer; pfnFilterProc : TFNHookProc) : HHOOK');
 CL.AddDelphiFunction('Function SetWindowsHookEx( idHook : Integer; lpfn : TFNHookProc; hmod : HINST; dwThreadId : DWORD) : HHOOK');
 CL.AddDelphiFunction('Function SetWindowsHookExA( idHook : Integer; lpfn : TFNHookProc; hmod : HINST; dwThreadId : DWORD) : HHOOK');
 CL.AddDelphiFunction('Function SetWindowsHookExW( idHook : Integer; lpfn : TFNHookProc; hmod : HINST; dwThreadId : DWORD) : HHOOK');
 CL.AddDelphiFunction('Function UnhookWindowsHook( nCode : Integer; pfnFilterProc : TFNHookProc) : BOOLean');
 CL.AddDelphiFunction('Function UnhookWindowsHookEx( hhk : HHOOK) : BOOLean');
 CL.AddDelphiFunction('Function CallNextHookEx( hhk : HHOOK; nCode : Integer; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Function DefHookProc( nCode : Integer; wParam : WPARAM; lParam : LPARAM; phhk : TObject) : LRESULT');
  CL.AddDelphiFunction('Function GetClassName( hWnd : HWND; lpClassName : PChar; nMaxCount : Integer) : Integer');
 // CL.AddDelphiFunction('function HttpGetDirect(const Url: string): string;');
 // CL.AddDelphiFunction('function HttpGet_Direct(const Url: string): string;');

 // function HttpGetDirect(const Url: string): string;

  // rest in uPSI_AfUtils !
  CL.AddTypeS('THexArray', 'array[0..15] of char;');
  //CL.AddTypeS('THexSet', 'HexDigits');
   //CL.AddConstantN('HEXDIGITS','THexArray').SetSet('0123456789ABCDEF');
   // HexDigits: array [0..15] of Char = '0123456789ABCDEF';    {Do not Localize}
  CL.AddTypeS('TFloatPoint2', 'record X, Y: Double; end');
  //CL.AddTypeS('TPointArray', 'array of TPoint;');
  CL.AddTypeS('shortstring', 'string[255];');
  CL.AddTypeS('Float', 'Double;');
  CL.AddTypeS('Real', 'Double;');
  //CL.AddTypeS('Int', 'Integer;');
  CL.AddTypeS('Long', 'Int64;');
  CL.AddTypeS('Pointer2', '___Pointer;');     //3.8.1
  CL.AddTypeS('__Pointer', 'TObject;');
  CL.AddTypeS('TFileCallbackProcedure','procedure(filename:string);');
  CL.AddTypeS('TBitmapStyle','(bsNormal, bsCentered, bsStretched)');
  CL.AddTypeS('T2IntegerArray', 'array of array of integer;');
  CL.AddTypeS('T2StringArray', 'array of array of string;');
  CL.AddTypeS('T2CharArray', 'array of array of char;');
  CL.AddTypeS('T3IntegerArray', 'array of array of array of integer;');
  CL.AddTypeS('T3StringArray', 'array of array of array of string;');

  CL.AddTypeS('mTByteArray', 'array of byte;');
  //   (@getProcessAllMemory, '');
 //CL.AddDelphiFunction('function getProcessAllMemory(ProcessID : DWORD): TProcessMemoryCounters;');

  //CL.AddDelphiFunction('function GetQrCode4(Width,Height: Word; Correct_Level: string;'+
    //       'const Data:string; aformat: string): TLinearBitmap;');
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
