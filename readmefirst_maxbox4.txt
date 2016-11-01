****************************************************************
Release Notes maXbox 4.2.4.80 October 2016 Ocean7 mX4
****************************************************************
add 20 units + 442 functions- WMI Script Type Library - webbox

1241 uPSI_wmiserv.pas {uPSI_SimpleSFTP.pas}
1242 uPSI_WbemScripting_TLB.pas
1243 unit uPSI_uJSON2;
1244 uPSI_RegSvrUtils.pas
1245 unit uPSI_osFileUtil;
1246 unit uPSI_SHDocVw; //TWebbrowser
1247 unit uPSI_SHDocVw_TLB;
1248 uPSC_classes.pas V2
1249 uPSR_classes.pas V2
1250 uPSI_U_Oscilloscope4_2
1251 unit uPSI_xutils.pas
1252 uPSI_ietf.pas
1253 uPSI_iso3166.pas
1254 uPSI_dateutil_real.pas  //Optima ISO 8601
1255 unit uPSI_dateext4.pas
1256 uPSI_locale.pas
1257 file charset.inc  //IANA Registered character sets
1258 unit uPSI_Strings;
1259 unit uPSI_crc_checks;  //ISO 3309 and ITU-T-V42
1260 unit uPSI_extDOS;

SHA1: of 4.2.4.80 15565A557B0F9576AA5F23F2A1D06BE9699A757B
CRC32: FA1F1F25 26.4 MB (27,720,144 bytes)

 function GetCachedFileFromURL(strUL: string; var strLocalFile: string): boolean;
 function IAddrToHostName(const IP: string): string;
 function GetIEHandle(WebBrowser: TWebbrowser; ClassName: string): HWND;
 function GetTextFromHandle(WinHandle: THandle): string;
 procedure Duplicate_Webbrowser(WB1, WB2: TWebbrowser);
 function FillWebForm(WebBrowser:TWebBrowser;FieldName:string;Value:string):Bool; 
 procedure WB_LoadHTML(WebBrowser: TWebBrowser; HTMLCode: string);
 function NetSend(dest, Source, Msg: string): Longint; overload;
 function RecordsetFromXML2(const XML: string): variant;');
 function RecordsetToXML2(const Recordset: variant): string;');
 Function GetCharEncoding( alias : string; var _name : string) : integer');
 Function MicrosoftCodePageToMIMECharset( cp : word) : string');
 Function MicrosoftLangageCodeToISOCode( langcode : integer) : string');
 procedure CopyHTMLToClipBoard(const str: string; const htmlStr: string = '');
 function RFC1123ToDateTime(Date: string): TDateTime;
 function DateTimeToRFC1123(aDate: TDateTime): string;
 procedure CopyHTMLToClipBoard(const str: string; const htmlStr: string);');
 procedure DumpDOSHeader(const h: IMAGE_DOS_HEADER; Lines: TStrings);');
 procedure DumpPEHeader(const h: IMAGE_FILE_HEADER; Lines: TStrings);');
 procedure DumpOptionalHeader(const h: IMAGE_OPTIONAL_HEADER; Lines: TStrings);');
 Function checkSystem: string;
 Function getSystemReport: string;

****************************************************************
Release Notes maXbox 4.2.4.25 June 2016 Ocean5 mX4
****************************************************************
add 16 units and 225 functions - Class Helper - KMemo RTF -DOSOutput

 1224 uPSI_IdAntiFreeze.pas
 1225 uPSI_IdLogStream.pas
 1226 unit uPSI_IdThreadSafe;
 1227 unit uPSI_IdThreadMgr;
 1228 unit uPSI_IdAuthentication;
 1229 unit uPSI_IdAuthenticationManager;
 1230 uPSI_OverbyteIcsConApp
 1231 unit uPSI_KMemo;
 1232 unit uPSI_OverbyteIcsTicks64;
 1233 unit uPSI_OverbyteIcsSha1.pas
 1234 unit uPSI_KEditCommon.pas
 1235 unit uPSI_UtilsMax4.pas
 1236 unit uPSI_IdNNTPServer;
 1237 unit uPSI_UWANTUtils;
 1238 unit uPSI_UtilsMax5.pas;
 1239 unit uPSI_OverbyteIcsAsn1Utils;
 1240 unit uPSI_IdHTTPHeaderInfo2; //mX response headers

SHA1: of 4.2.4.25 A52ACF844808285D8EE978637365B74B3C7C342F
CRC32: CB882FFC  26.0 MB (27,276,288 bytes) 

 function ContentTypeGetExtn(Const Content: String; var CLSID: String): string;
 function ContentTypeFromExtn(Const Extension: String): string;
 function DateTimeDiff2(Start, Stop : TDateTime) : int64;
 Function LoadStringofFile( const AFile : string) : string');
 Function LSOF( const AFile : string) : string');
 function DOSCommand(const CommandLine: string; const CmdShow:integer;
           const WaitUntilComplete: Boolean; const WorkingDir: string = ''): Boolean;
 function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
 procedure CaptureConsoleOutput(DosApp : string;AMemo : TMemo); 
 function ExecuteCommandDOS(CommandLine:string):string;
 function DOSCommandRedirect(const CommandLine: string;
           const OutStream: Classes.TStream): Boolean; overload;     //8
 procedure SendKeysToWindow(const HWnd: Windows.HWND; const Text: string);
 function FoldWrapText(const Line, BreakStr: string; BreakChars: TSysCharSet; MaxCol: Integer): string;');
 function TextWrap(const Text: string; const Width, Margin: Integer): string;
 Function ShellExecuteX( Operation, FileName, Parameters, Directory : String; ShowCmd : Integer) : Cardinal;');
 Function KeyboardStateToShiftState1(const KeyboardState:TKeyboardState):TShiftState;
 Procedure SetCustomFormGlassFrame( const CustomForm : TCustomForm; const GlassFrame : TGlassFrame)');
 Function GetCustomFormGlassFrame( const CustomForm : TCustomForm) : TGlassFrame');
 Procedure SetApplicationMainFormOnTaskBar(const Application: TApplication; Value : Boolean)');
 Function GetApplicationMainFormOnTaskBar(const Application: TApplication):Boolean');
  function CompressWhiteSpace(const S: string): string;
  function IsASCIIDigit(const Ch: Char): Boolean;
  function CompareNumberStr(const S1, S2: string): Integer;
  procedure HexToBuf(HexStr: string; var Buf: string);
  function BufToHex(const Buf: string; const Size: Cardinal): string;
  Function DOSExec( CommandLine : string; Work : string) : string');
  procedure HexToStrBuf(HexStr: string; var Buf: string);');
  function StrBufToHex(const Buf: string; const Size: Cardinal): string;');
  function GetCharFromVirtualKey(AKey: Word): string;
  function GetParentProcessID(const PID: Windows.DWORD): Windows.DWORD;
  function FormInstanceCount2(AFormClass: Forms.TFormClass): Integer; //overload;
  function FormInstanceCount(const AFormClassName: string): Integer; //overload;
  function FindAssociatedApp(const Doc: string): string;
  function CreateShellLink2(const LinkFileName, AssocFileName,Desc,WorkDir,Args
   ,IconFileName: string; const IconIdx: Integer): Boolean;
  function FileFromShellLink(const LinkFileName: string): string;
  function IsShellLink(const LinkFileName: string): Boolean;
  function ResourceIDToStr(const ResID: PChar): string;
  function IsEqualResID(const R1, R2: PChar): Boolean;
  function RecycleBinInfo(const Drive: Char; out BinSize, FileCount: Int64): Boolean;
  function SysImageListHandle(const Path:string; const WantLargeIcons:Boolean): THandle;
  function EmptyRecycleBin: Boolean;
  function ExploreFile(const Filename: string ): Boolean;
  function ExploreFolder(const Folder: string): Boolean;
  procedure ClearRecentDocs2;
  procedure AddToRecentDocs2(const FileName: string);                   //100
  function StringsToMultiSz(const Strings: Classes.TStrings; const MultiSz: PChar; const BufSize: Integer): Integer;
  procedure DrawTextOutline(const Canvas: Graphics.TCanvas; const X, Y: Integer; const Text: string);
  function CloneGraphicAsBitmap(const Src: Graphics.TGraphic; const PixelFmt: Graphics.TPixelFormat;
  					const TransparentColor: Graphics.TColor): Graphics.TBitmap;
  procedure InvertBitmap(const ABitmap: Graphics.TBitmap); //overload;
  procedure InvertBitmap2(const SrcBmp, DestBmp: Graphics.TBitmap); //overload;


****************************************************************
Release Notes maXbox 4.2.2.90 April 2016 Ocean3 mX4
****************************************************************
add 12 units and 20 functions - minor bugfixes -maxlab
http://max.kleiner.com/boxart.htm

 1212 unit uPSI_MapFiles.pas //map stream of memory-mapped files
 1213 unit uPSI_BKPwdGen,    //Password Generator
 1214 unit uPSI_Kronos,  // big chrono date time library
 1215 unit uPSI_TokenLibrary2;
 1216 uPSI_KDialogs,
 1217 uPSI_Numedit,
 1218 unit uPSI_StSystem2;
 1219 unit uPSI_KGraphics;
 1220 uPSI_KGraphics_functions;
 1221 uPSI_umaxPipes.pas
 1222 unit uPSI_KControls;
 1223 unit SysUtils_max2;

  function RunAsAdmin(hWnd: HWND; filename: string; Parameters: string): Boolean;
  procedure SaveGraphicToStream(Graphic: TGraphic; Stream: TStream);
  function LoadGraphicFromStream(Stream: TStream): TGraphic;
  procedure CopyStreamToFile(S: TStream; F: THandle);
  function BigPow(aone, atwo: integer): string;
  PROCEDURE GetPelsPerMeter(CONST  Bitmap:  TBitmap;
                            VAR xPelsPerMeter, yPelsPerMeter:  INTEGER);
  PROCEDURE RainbowColor(CONST fraction:  Double; VAR R,G,B:  BYTE);
  function GetNewGUID: string;
  function FormatGUID(const GUID: string): string;
  function GetNewFormatedGUID: string;
  EnumerateFiles2(exepath,srlist, false, 0)
  EnumerateDirectories2(exepath+'\',srlist, false, 0)
  Sender.AddFunction(@mysetKeyPressed, 'procedure SetKeyPressed;');
  Function SetEvent( hEvent : THandle) : BOOL');
  CL.AddTypeS('TPosProc','function(const Substr, S: string): Integer)');
  
  function SplitStr(sInput:string; Delimiter:string): TStringArray;
  function GetDataFromFile2(sFileName: AnsiString): AnsiString;
  function ExtractFileNameWithoutExt(const FileName: string): string;
  function SubstringCount (Substring : string; Str : string): Integer;
  function loadForm(vx, vy: smallint): TForm;   //alias getForm()
  procedure paintProcessingstar2(ppform: TForm);

SHA1: of 4.2.2.90: 1EEE461ACF78ACA461806D85488B87A4FA08F39F
CRC32: BCEDACF0,  Size of EXE: 26,920,960

****************************************************************
Release Notes maXbox 4.2.0.80 April 2016 Ocean mX4
****************************************************************

This is an upgrade to mX3 app files dir, if you want all examples/docs for this mX4 
you have to download mX3 first and then copy mX4 files in it too.
Otherwise you already own mX3 on disk just copy new files (save maxboxdef.ini first).
All functions & object: maxbox_functions_all.pdf

News:
Add 5 Units, 1 Tutor, Pipe Libraray2, KLog, FPlot42

1207 unit uPSI_CPUSpeed.pas
1208 uPSI_RoboTracker.pas
1209 unit uPSI_NamedPipesImpl.pas
1210 unit uPSI_KLog.pas
1211 unit uPSI_NamedPipeThreads.pas

new added functions
-----------------------------------------------------

function CPUSpd: String;
function CPUSpeed: String;
function BigFib(n: integer): string;  //BigFibo
function BigFac(n: integer): string;  //BigFact
function UpTime: string;
Function NetLogon( const Server, User, Password : WideString; out ErrorMessage : string) : Boolean');
Function NetLogoff( const Server, User, Password : WideString) : Boolean');
Procedure ErrorNamedPipe( const Message : string)');
procedure BroadcastChange; //method that broadcasts the necessary message WM_SETTINGCHANGE
Function WriteFile2( hFile : THandle; const Buffer, nNumberOfBytesToWrite : DWORD; var lpNumberOfBytesWritten : DWORD; lpOverlapped : Tobject) : BOOL');
Function ReadFile2( hFile : THandle; var Buffer, nNumberOfBytesToRead : DWORD; var lpNumberOfBytesRead : DWORD; lpOverlapped : Tobject) : BOOL');
// Security helper functions
procedure InitializeSecurity(var SA: TSecurityAttributes);
procedure FinalizeSecurity(var SA: TSecurityAttributes);
// Pipe helper functions
procedure CheckPipeName(Value: string);
procedure ClearOverlapped(var Overlapped: TOverlapped; ClearEvent: Boolean);
procedure CloseHandleClear(var Handle: THandle);
function ComputerName2: string;
procedure DisconnectAndClose(Pipe: HPIPE; IsServer: Boolean = True);
function EnumConsoleWindows(Window: HWND; lParam: Integer): BOOL; stdcall;
procedure FlushMessages;
function IsHandle(Handle: THandle): Boolean;
procedure RaiseWindowsError;
function CharSetToCP(ACharSet: TFontCharSet): Integer;
function CPToCharSet(ACodePage: Integer): TFontCharSet;
function TwipsToPoints(AValue: Integer): Integer;
function PointsToTwips(AValue: Integer): Integer;
procedure LoadGraphicFromResource(Graphic: TGraphic; const ResName: string; ResType: PChar);

///////////////////////////////////////////////////////////////////////////////
// Object instance functions
///////////////////////////////////////////////////////////////////////////////
function AllocateHWnd(Method: TWndMethod): HWND;
procedure DeallocateHWnd(Wnd: HWND);

MessageBox(0,PChar('CPU speed is '+CPUSpd+' MHz'),'CPU Speed Check',MB_IconInformation+MB_OK);
CL.AddTypeS('TKLogEvent', 'Procedure ( Sender : TObject; Code : TKLogType; const Text : string)');
AddRegisteredVariable('FormatSettings','TFormatSettings');  //at sysutils!
AddRegisteredVariable('mouse','TMouse');  //at controls
CL.AddTypeS('HPIPE', 'THandle');

Amount of Functions: 16627
Amount of Procedures: 9922
Amount of Constructors: 1633
Totals of Calls: 28182
SHA1: of 4.2.0.80 638E7412750AB0ECF14F2A5515BC4A2DE561EAC2
CRC32: 7C91FD2A  Exe size: 26,650,112

https://www.virustotal.com/en/file/584ca53d6dd8f7de17d0a1959bf78aad04697cf0ad7b3f23aee90b5ff720ede1/analysis/1460194451/

Update for Windows 10 Version 1511 for x64-based Systems (KB3140741)

sha1 of maxbox4.zip: d85814d4693d5f3054eee8bad4e7785a8fecb146

****************************************************************
Release Notes maXbox 4.2.0.10 March 2016 Ocean mX4
****************************************************************

This is an upgrade to mX3 app files dir, if you want all examples/docs for this mX4 
you have to download mX3 first and then copy mX4 files in it too.
Otherwise you already own mX3 on disk just copy new files (save maxboxdef.ini first).
All functions & object: maxbox_functions_all.pdf

News:
Add 9 Units, 1 Tutor, InetUtils, Chron, REXX funcs

1198 unit uPSI_Simpat;
1199 unit uPSI_Tooltips.pas
1200 unit uPSI_StringGridLibrary.pas
1201 unit uPSI_ChronCheck.pas
1202 unit uPSI_REXX.pas - 
1203 uPSI_SysImg.pas
1204 unit uPSI_Tokens;
1205 unit uPSI_KFunctions;
1206 unit uPSI_KMessageBox;

procedure SIRegister_REXX(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TState', '( TrimLeader, StartToken, EndToken )');
  CL.AddTypeS('TStrIndex', 'LongInt');
  CL.AddTypeS('TTokIndex', 'WORD');
  CL.AddTypeS('TStrIndexB', 'BYTE');
  CL.AddTypeS('TTokIndexB', 'BYTE');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EConversionError');
 Function Abbrev(const information,info: STRING; const nMatch: TStrIndex):BOOLEAN');
 Function AllSame( const s : STRING; const c : CHAR) : BOOLEAN');
 Function Capitalize( const s : STRING) : STRING');
 Function Center( const s : STRING; const sLength : TStrIndex) : STRING');
 Function Left( const s : STRING; const sLength : TStrIndex) : STRING');
 Function Right( const s : STRING; const sLength : TStrIndex) : STRING');
 Function Copies( const s : STRING; const n : TStrIndex) : STRING');
 Function CountChar( const s : STRING; const c : CHAR) : TStrIndex');
 Function DeleteStringrexx( const substring : STRING; const s : STRING) : STRING');
 Function Overlay( const ovly, target : STRING; const n : TStrIndex) : STRING');
 Function Plural(const n: LongInt;const singularform,pluralform: STRING): STRING');
 Function Reverse( const s : STRING) : STRING');
 Function Spacerexx( const s : STRING; const n : TStrIndex) : STRING');
 Function Striprexx( const s : STRING; const option : STRING) : STRING');
 Function TestString( const sLength : TStrIndex) : STRING');
 Function Translate( const s, OutTable, InTable : STRING) : STRING');
 Function XRange( const start, stop : BYTE) : STRING');
 Function B2X( const b : BYTE) : STRING');
 Function C2D( const s : STRING) : DOUBLE');
 Function C2I( const s : STRING) : INTEGER');
 Function C2L( const s : STRING) : LONGINT');
 Function C2W( const s : STRING) : WORD');
 Function C2X( const s : STRING) : STRING');
 Function I2C( const i : INTEGER) : STRING');
 Function I2X( const i : INTEGER) : STRING');
 Function L2C( const i : LONGINT) : STRING');
 Function L2X( const i : LONGINT) : STRING');
 Function D2C( const x : DOUBLE; const d : BYTE) : STRING');
 Function W2C( const w : WORD) : STRING');
 Function W2X( const w : WORD) : STRING');
 Function X2W( const s : STRING) : WORD');
 Function JulianDate( const DateTime : TDateTime) : LongInt');
 Function TimeDifference( const StartTime, StopTime : TDateTime) : DOUBLE');
 Function Pwr( const x, y : DOUBLE) : DOUBLE');
end;


procedure SIRegister_KMessageBox(CL: TPSPascalCompiler);
begin
  TKMsgBoxButton', '( mbYes, mbNo, mbOK, mbCancel, mbClose, mbAbor'
  t, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp )');
  TKMsgBoxIcon', '( miNone, miInformation, miQuestion, miWarning, miStop )');
 Function CreateMsgBox( const Caption, Text : string; const Buttons : array of TKMsgBoxButton; Icon : TKMsgBoxIcon; Def : integer) : TCustomForm');
 Function CreateMsgBoxEx( const Caption, Text : string; const Btns : array of string; Icon : TKMsgBoxIcon; Def : integer) : TCustomForm');
 Procedure FreeMsgBox( AMsgBox : TCustomForm)');
 Function KMsgBox( const Caption, Text : string; const Buttons : array of TKMsgBoxButton; Icon : TKMsgBoxIcon; Def : integer) : integer');
 Function KMsgBoxEx( const Caption, Text : string; const Buttons : array of string; Icon : TKMsgBoxIcon; Def : integer) : integer');
 Function KInputBox(const Caption,Prompt:string; var Text: string): TModalResult');
 //Function KNumberInputBox( const ACaption, APrompt : string; var AValue : double; AMin, AMax : double; AFormats : TKNumberEditAcceptedFormats) : TModalResult');
  CL.AddTypeS('TKMsgBoxButtons', '( mbAbortRetryIgnore, mbOkOnly, mbOkCancel, mbRetryCancel, mbYesNo, mbYesNoCancel )');
 Function MsgBox2( const Caption, Text : string; const Buttons : TKMsgBoxButtons; Icon : TKMsgBoxIcon) : integer');
 Function AppMsgBox( const Caption, Text : string; Flags : integer) : integer');
end;


procedure SIRegister_StringGridLibrary(CL: TPSPascalCompiler);
begin
 Procedure ReadGridFile( var StringGrid : TStringGrid; GridFile : STRING)');
 Procedure WriteGridFile( var StringGrid : TStringGrid; GridFile : STRING)');
 Procedure AddBlankRowToTop( var StringGrid : TStringGrid)');
 Procedure DeleteSelectedRow( var StringGrid : TStringGrid)');
 Function StringGridSearch( const StringGrid : TStringGrid; const column : INTEGER; const target : STRING) : INTEGER');
 Function XLeft( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
 Function XCenter( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
 Function XRight( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
 Function YCenter( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
end;

 Procedure AdjustArray( var DWArray : array of DWord; const Delta : Integer; MinValueToAdjust : DWord)');
 Function GetDroppedFileNames( const DropID : Integer) : TWideStringArray');
 Function AreBytesEqual( const First, Second : array of Byte) : Boolean;');
 Function AreBytesEqual1( const First, Second, Length : DWord) : Boolean;');
 Function MaskForBytes( const NumberOfBytes : Byte) : DWord');
 Function IntToBinByte( Int : Byte) : String;');
 Function IntToBinWord( Int : Word) : String;');
 Function IntToBinDWord( Int : DWord; Digits : Byte; SpaceEach : Byte) : String;');
 Function WriteWS( const Stream : TStream; const Str : WideString) : Word');
 Procedure WriteArray(const Stream: TStream; const WSArray: array of WideString);');
 Procedure WriteArray6( const Stream : TStream; const DWArray : array of DWord);');
 Function ReadWS( const Stream : TStream) : WideString;');
 Function ReadWS8( const Stream : TStream; out Len : Word) : WideString;');
 Procedure ReadArray( const Stream : TStream; var WSArray : array of WideString);');
 Procedure ReadArray10( const Stream : TStream; var DWArray : array of DWord);');
 Function ParamStrW( Index : Integer) : WideString');
 Function ParamStrFrom( CmdLine : WideString; Index : Integer) : WideString');
 Function ParamStrEx(CmdLine:WideString;Index:Integer;out Pos:Integer):WideString;
  Procedure FindMask( Mask : WideString; Result : TStringsW)');
 Procedure FindAll( BasePath, Mask : WideString; Result : TStringsW)');
 Procedure FindAllRelative( BasePath, Mask : WideString; Result : TStringsW)');
 Function IsInvalidPathChar( const Char : WideChar) : Boolean');
 Function MakeValidFileNameW( const Str : WideString; const SubstitutionChar : WideChar) : WideString');
  Function ExtractFilePathW( FileName : WideString) : WideString');
 Function ExtractFileNameW( Path : WideString) : WideString');
 Function ExpandFileNameW( FileName : WideString) : WideString;');
 Function ExpandFileName12( FileName, BasePath : WideString) : WideString;');
 Function CurrentDirectory : WideString');
 Function ChDirW( const ToPath : WideString) : Boolean');
 Function ExtractFileExtW( FileName : WideString) : WideString');
 Function ChangeFileExtW2( FileName, Extension : WideString) : WideString');
 Function IncludeTrailingBackslashW( Path : WideString) : WideString');
 Function ExcludeTrailingBackslashW( Path : WideString) : WideString');
 Function IncludeTrailingPathDelimiterW( Path : WideString) : WideString');
 Function ExcludeTrailingPathDelimiterW( Path : WideString) : WideString');
 Function IncludeLeadingPathDelimiter( Path : WideString) : WideString');
 Function ExcludeLeadingPathDelimiter( Path : WideString) : WideString');
  Function FileInfo( Path : WideString) : TWin32FindData');
 Function IsDirectoryW( Path : WideString) : Boolean');
 Function FileAgeW( const FileName : WideString) : Integer');
 Function FileExistsW( Path : WideString) : Boolean');
 Function FileSizeW( Path : WideString) : DWord');
 Function FileSize64( Path : WideString) : Int64');
 Function DeleteFileW( Path : WideString) : Boolean');
 Function CopyDirectoryW( Source, Destination : WideString) : Boolean');
 Function RemoveDirectoryW( Path : WideString) : Boolean');
 Function ForceDirectoriesW( Path : WideString) : Boolean');
 Function MkDirW( Path : WideString) : Boolean');
 Function GetEnvironmentVariableW( Name : WideString) : WideString');
 Function ResolveEnvVars( Path : WideString; Callback : TEnvVarResolver; Unescape : Boolean) : WideString;');
 Function ResolveEnvVars14( Path : WideString; Unescape : Boolean) : WideString;');
 Function ReadRegValue( Root : DWord; const Path, Key : WideString) : WideString');
  Function FadeSettings( Form : TForm; Step : ShortInt; Callback : TNotifyEvent) : TFormFadeSettings;');
 Function FadeSettings17( Form : TForm; MinAlpha, MaxAlpha : Byte; Step : ShortInt) : TFormFadeSettings;');
 Function GetSpecialFolderID( const Path : String) : Integer');
 Function GetSpecialFolderPath2( FolderID : Integer) : String');
 

Amount of Functions: 16584
Amount of Procedures: 9891
Amount of Constructors: 1629
Totals of Calls: 28104
SHA1: of maXbox 4.2.0.10 15671711176CCEA92AEC355B44867D48B7C54575
CRC32: 8C581C30
https://www.virustotal.com/en/file/2dbbeea235d560b7bb2cefcadb05ec328e1d95f32490980894c07c1288123e13/analysis/
Cumulative Update for Windows 10 Version 1511 for x64-based Systems (KB3140768)


****************************************************************
Release Notes maXbox 4.0.2.80 February 2016 Jupiter mX4
****************************************************************

This is an upgrade to mX3 app files dir, if you want all examples/docs for this mX4 
you have to download mX3 first and then copy mX4 files in it too.
Otherwise you already have mX3 on disk just copy the new files (save maxboxdef.ini first).
All functions & object: maxbox_functions_all.pdf

News:
Add 77 Units, 12 Tutors, ChangeTracker, CPP+, OLEUtils2, xmldom, Chess4, 3DFrame, XMLRPC, X509, InetUtils

1121 unit uPSI_IndySockTransport.pas (+IdHTTPHeaderInfo)
1122 unit uPSI_HTTPProd.pas
1123 unit uPSI_CppParser.pas
1124 unit uPSI_SynHighlighterCpp.pas
1125 unit uPSI_CodeCompletion.pas
1126 unit uPSI_U_IntList2.pas
1127 unit uPSI_SockHTTP.pas
1128 uPSI_SockAppNotify.pas
1129 uPSI_NSToIS.pas
1130 unit uPSI_DBOleCtl.pas
1131 unit uPSI_xercesxmldom;
1132 unit uPSI_xmldom;
1133 unit uPSI_Midas;
1134 unit uPSI_JclExprEval;
1135 uPSI_Gameboard;
1136 unit uPSI_ExtUtil;
1137 unit uPSI_FCGIApp;
1138 unit uPSI_ExtPascal;
1139 unit uPSI_PersistSettings;
1140 IdHTTPHeaderInfo.pas
1141 uPSI_SynEditAutoComplete;
1142 uPSI_SynEditTextBuffer.pas
1143 unit uPSI_JclPCRE;
1144 unit uPSI_ZConnection;
1145 unit uPSI_ZSequence;
1146 unit uPSI_ChessPrg;
1147 unit uPSI_ChessBrd;
1148 unit uPSI_Graph3D;
1149 uPSI_SysInfoCtrls2.pas
1150 unit uPSI_RegUtils;
1151 unit uPSI_VariantRtn;
1152 uPSI_StdFuncs,
1153 unit uPSI_SqlTxtRtns;
1154 unit uPSI_BSpectrum;
1155 unit IPAddressControl;
1156 unit uPSI_Paradox;
1157 unit uPSI_Environ;
1158 uPSI_GraphicsPrimitivesLibrary;
1159 uPSI_DrawFigures,
1160 unit uPSI_synadbg;
1161 unit uPSI_BitStream;
1162 unit uPSI_xrtl_util_FileVersion;
1163 uPSI_XmlRpcCommon,
1164 unit uPSI_XmlRpcClient;
1165 unit uPSI_XmlRpcTypes;
1166 unit uPSI_XmlRpcServer;
1167 unit uPSI_SynAutoIndent;
1168 unit uPSI_synafpc;
1169 unit uPSI_RxNotify;
1170 unit uPSI_SynAutoCorrect;
1171 unit uPSI_rxOle2Auto;
1172 unit uPSI_Spring_Utilsmx;
1173 unit uPSI_ulogifit;
1174 unit uPSI_HarmFade;
1175 unit uPSI_SynCompletionProposal;
1176 unit uPSI_rxAniFile;
1177 uPSI_ulinfit,
1178 uPSI_usvdfit;
1179 unit uPSI_JclStringLists;
1180 unit uPSI_ZLib;
1181 unit uPSI_MaxTokenizers;  //WANT
1182 unit uPSI_MaxStrUtils;
1183 unit uPSI_MaxXMLUtils;
1184 unit uPSI_MaxUtils;
1185 unit uPSI_VListBox;
1186 unit uPSI_MaxDOM;
1187 unit uPSI_MaxDOMDictionary;
1188 unit uPSI_MaxDOMDictionary_Routines;
1189 unit uPSI_cASN1;
1190 unit uPSI_cX509Certificate;
1191 unit uPSI_uCiaXml;
1192 unit uPSI_StringsW;
1193 unit uPSI_FileStreamW;  //WideString
1194 unit Drawingutils;
1195 unit uPSI_InetUtilsUnified;
1196 unit uPSI_FileMask;
1197 unit uPSI_StrConv;

 
source of the new units: http://sourceforge.net/projects/maxbox/files/Docu/SourceV4/

New Functions /Classes:

 function DownloadJPGToBitmap(const URL : string; ABitmap: TBitmap): Boolean;)');
 procedure GetImageLinks(AURL: string; AList: TStrings);');
 procedure SaveByteCode;');
 procedure ResetKeyPressed;');

 RIRegister_HTTPProd_Routines(Exec);
 Function ContentFromScriptStream( AStream : TStream; AWebModuleContext : TWebModuleContext; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandleScriptTag : THandledTagProc; const AScriptEngine : string; '+
                                 'ALocateFileService : ILocateFileService) : string');
 Function ContentFromScriptFile( const AFileName : TFileName; AWebModuleContext : TWebModuleContext; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandleScriptTag : THandledTagProc; '+
                                'const AScriptEngine : string; ALocateFileService : ILocateFileService) : string');
 Function FindComponentWebModuleContext( AComponent : TComponent) : TWebModuleContext');
 Function GetTagID( const TagString : string) : TTag');
 Function ContentFromStream( AStream : TStream; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandledTag : THandledTagProc) : string');
 Function ContentFromString( const AValue : string; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandledTag : THandledTagProc) : string');

 RIRegister_synacrypt_Routines(Exec);
 function TestDes: boolean;
 {:Call internal test of all 3DES encryptions. Returns @true if all is OK.}
 function Test3Des: boolean;
 {:Call internal test of all AES encryptions. Returns @true if all is OK.}
 function TestAes: boolean;

 Procedure LogMessage( const Fmt : string; const Params : array of const)');
 Function UnixPathToDosPath2( const Path : string) : string');
 Function DosPathToUnixPath2( const Path : string) : string');
 Procedure InitISAPIApplicationList');
 Procedure DoneISAPIAPplicationList');

 RIRegister_xmldom_Routines(Exec);
 Function IsPrefixed( const AName : DOMString) : Boolean');
 Function IsPrefixedW( const AName : DOMStringW) : Boolean');
 Function ExtractLocalName( const AName : DOMString) : DOMString');
 Function ExtractLocalNameW( const AName : DOMStringW) : DOMStringW');
 Function ExtractPrefixW( const AName : DOMStringW) : DOMStringW');
 Function MakeNodeNameW( const Prefix, LocalName : DOMStringW) : DOMStringW');
 Function ExtractPrefix( const AName : DOMString) : DOMString');
 Function MakeNodeName( const Prefix, LocalName : DOMString) : DOMString');
 Function SameNamespace(const Node:IDOMNode;const namespaceURI:WideString):Boolean;');
 Function SameNamespace2( const URI1, URI2 : WideString) : Boolean;');
 Function NodeMatches( const Node : IDOMNode; const TagName, NamespaceURI : DOMString) : Boolean;');
 Function GetDOMNodeEx( const Node : IDOMNode) : IDOMNodeEx');
 Procedure RegisterDOMVendor( const Vendor : TDOMVendor)');
 Procedure UnRegisterDOMVendor( const Vendor : TDOMVendor)');
 Function GetDOMVendor( VendorDesc : string) : TDOMVendor');
 Function GetDOM( const VendorDesc : string) : IDOMImplementation');
 Procedure DOMVendorNotSupported( const PropOrMethod, VendorName : string)');
{ Function IsValidLocale( Locale : LCID; dwFlags : DWORD) : BOOL');
 Function ConvertDefaultLocale( Locale : LCID) : LCID');
 Function GetThreadLocale : LCID');
 Function SetThreadLocale( Locale : LCID) : BOOL');
 Function GetSystemDefaultLangID : LANGID');
 Function GetUserDefaultLangID : LANGID');
 Function GetSystemDefaultLCID : LCID');
 Function GetUserDefaultLCID : LCID');
 }
 Function AbsInt( const B : integer) : integer');
 Function AbsFloat( const B : double) : extended');

 Procedure ReconcileDeltas( const cdsArray : array of TClientDataset; vDeltaArray : OleVariant)');
 Procedure CDSApplyUpdates( ADatabase : TDatabase; var vDeltaArray : OleVariant; const vProviderArray : OleVariant; Local : Boolean)');
  Sender.AddFunction(@CheckMemory, 'procedure CheckMemory;');
  Sender.AddFunction(@GetMemoryInfo, 'function getMemoryInfo;');
  Sender.AddFunction(@GetMemoryInfo, 'function getMemInf;');
 Procedure RaiseLastWin32_2( const Text : string);');

 RIRegister_Gameboard_Routines(Exec);
 Function Opponent( Player : TPlayer) : TPlayer');
 Procedure InitZobritsNumbers( var ZobristNumbers, Count : Integer)');
 Procedure SaveStringToStream( const Str : String; Stream : TStream)');
 Function LoadStringFromStream( Stream : TStream) : String');
 Function WaitForSyncObject( SyncObject : THandle; Timeout : Cardinal; BlockInput : Boolean) : Cardinal');
 Function ProcessMessage : Boolean');
 Procedure ProcessMessages( Timeout : DWORD)');  //without application!

 RIRegister_PersistSettings_Routines(Exec);
 Procedure SetStorageHandler( AFunction : TStorageHandlerFunction);');
 Procedure SetStorageHandler1( AMethod : TStorageHandlerMethod);');
 Function GetStorage : TPersistStorage');
 Procedure SaveComponents( Root : TComponent; Storage : TPersistStorage)');
 Procedure LoadComponents( Root : TComponent; Storage : TPersistStorage)');
 Procedure AutoSave( Root : TComponent)');
 Procedure AutoLoad( Root : TComponent)');

 procedure FloatToDecimalE(var Result: TFloatRec; const Value: extended; ValueType: TFloatValue; Precision, Decimals: Integer);');
 function FloatToTextE(BufferArg: PChar; const Value: extended; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer): Integer;');
 procedure FloatToDecimalE(var Result: TFloatRec; const Value: extended; ValueType: TFloatValue; Precision, Decimals: Integer);');
 function FloatToTextE(BufferArg: PChar; const Value: extended; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer): Integer;');
 Function GetSystemDefaultLCID : LCID');
 Function GetUserDefaultLCID : LCID');
 Function CreateMutex2( lpMutexAttributes : TObject; bInitialOwner : BOOL; lpName : PChar) : THandle');
  Function CreateSemaphore2( lpSemaphoreAttributes : TObject; lInitialCount, lMaximumCount : Longint; lpName : PChar) : THandle');
 
//GetSystemDefaultLCID : LCID');
 //GetUserDefaultLCID : LCID');

Function GetUserNameAPI( lpBuffer : PChar; var nSize : DWORD) : BOOL');
createmutex2 fhand:= OpenFileHandle(exepath+'maxbox4.exe')
 
 function getMatchString(arex, atext: string): string; 
 function getLastInput: DWord;
 procedure GetKLList(List: TStrings);');   //Keyboardlist2
 procedure EnableCTRLALTDEL(YesNo : boolean);
 function LocalIP: string;
 function IPAddrToName(IPAddr: string): string;
 function GetIPFromHost(const HostName: string): string;
 function FindComputers(Computers : TStringList): DWORD;
 function GetWin32TypeLibList(var Lines: TStringList): Boolean;
 function RecurseWin32(const R: TRegistry; const ThePath: string;
                             const TheKey: string): string;

 RIRegister_JclPCRE_Routines(S: TPSExec);
 Procedure InitializeLocaleSupport');
 Procedure TerminateLocaleSupport');
 Function StrReplaceRegEx( const Subject, Pattern : AnsiString; Args : array of const) : AnsiString');

procedure SIRegister_VariantRtn(CL: TPSPascalCompiler);
begin
CL.AddTypeS('TProcReadElementValue', 'procedure(Value:Variant; IndexValue:integerarray; const HighBoundInd:integer; Var Continue:boolean)');
CL.AddTypeS('TProcWriteElementValue', 'procedure(OldValue:Variant; IndexValue:integerarray; Var NewValue:Variant; Var Continue:boolean)');

 //TProcReadElementValue=procedure (Value:Variant; IndexValue:array of integer; const HighBoundInd:integer; Var Continue:boolean);
 //TProcWriteElementValue=procedure (OldValue:Variant; IndexValue:array of integer; Var NewValue:Variant;  Var Continue:boolean);
//
 Function SafeVarArrayCreate( const Bounds : array of Integer; VarType, DimCount : Integer) : Variant');
 Function VarArrayGet2( const A : Variant; const Indices : array of Integer; const HighBound : integer) : Variant');
 Procedure VarArrayPut2( var A : Variant; const Value : Variant; const Indices : array of Integer; const HighBound : integer)');
 Function CycleReadArray( vArray : Variant; CallBackProc : TProcReadElementValue) : boolean');
 Function CycleWriteArray(var vArray: Variant; CallBackProc: TProcWriteElementValue) : boolean');
 Function CompareVarArray1( vArray1, vArray2 : Variant) : boolean');
 Function EasyCompareVarArray1(vArray1,vArray2:Variant;HighBound:integer): boolean');
end;

procedure SIRegister_StdFuncs(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EParserError');
  //CL.AddTypeS('TCharSet', 'set of Char');
 Function ConvertFromBase(sNum: String; iBase: Integer; cDigits: String): Integer');
 Function ConvertToBase( iNum, iBase : Integer; cDigits : String) : String');
 Function EnsureSentenceTerminates( Sentence : String; Terminator : Char) : String');
 Function FindTokenStartingAt( st : String; var i : Integer; TokenChars : TCharSet; TokenCharsInToken : Boolean) : String');
 Function GetDirectoryOfFile( FileName : String) : String');
 Function GetDirOfFile( FileName : String) : String');

 Function GetTempFilefib( FilePrefix : String) : String');
 Function Icon2Bitmap( Icon : HICON) : HBITMAP');
 Function Maxfib( n1, n2 : Integer) : Integer');
 Function MaxD( n1, n2 : Double) : Double');
 Function Minfib( n1, n2 : Integer) : Integer');
 Function MinD( n1, n2 : Double) : Double');
 Function RandomStringfib( iLength : Integer) : String');
 Function RandomIntegerfib( iLow, iHigh : Integer) : Integer');
 Function Soundexfib( st : String) : String');
 Function StripStringfib( st : String; CharsToStrip : String) : String');
 Function ClosestWeekday( const d : TDateTime) : TDateTime');
 Function Yearfib( d : TDateTime) : Integer');
 Function Monthfib( d : TDateTime) : Integer');
 Function DayOfYearfib( d : TDateTime) : Integer');
 Function DayOfMonth( d : TDateTime) : Integer');
 Function VarCoalesce( V1, V2 : Variant) : Variant');
 Function VarEqual( V1, V2 : Variant) : Boolean');
 Procedure WeekOfYearfib( d : TDateTime; var Year, Week : Integer)');
 Function Degree10( Degree : integer) : double');
 Function CompToStr( Value : comp) : string');
 Function StrToComp( const Value : string) : comp');
 Function CompDiv( A, B : comp) : comp');
 Function CompMod( A, B : comp) : comp');
 // CL.AddTypeS('PComp', '^Comp // will not work');
end;

procedure SIRegister_RegUtils(CL: TPSPascalCompiler);
begin
 Procedure DefWriteToRegistry( const OtherKeys, ParamNames : array of string; const Values : array of Variant)');
 Procedure WriteToRegistry( aRootKey : HKEY; const OtherKeys, ParamNames : array of string; const Values : array of Variant)');
 Function ReadFromRegistry( aRootKey : HKEY; const OtherKeys, ParamNames : array of string) : Variant');
 Function DefReadFromRegistry( const OtherKeys, ParamNames : array of string) : Variant');
 Function AllSubKey( aRootKey : HKEY; const ForPath : array of string) : Variant');
 Function DefAllSubKey( const ForPath : array of string) : Variant');
 Function SaveRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 Function LoadRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 Function AltSaveRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 Function AltLoadRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 Function GetKeyForParValue( const aRootKey, ParName, ParValue : string) : string');
end;

 Function GetEulerPhi( n : int64) : int64');
 function isprime(f: int64): boolean;');

 function  DispositionFrom(const SQLText:string):TPoint;
 procedure AllTables(const SQLText:string;FTables:Tstrings);
 function  TableByAlias(const SQLText,Alias:string):string;
 function  FullFieldName(const SQLText,FieldName:string):string;
 function  AddToWhereClause(const SQLText,NewClause:string):string;
 function  GetWhereClause(SQLText:string;N:integer;var
   StartPos,EndPos:integer ):string;
 function  WhereCount(SQLText:string):integer;
 function  GetOrderInfo(SQLText:string):variant;
 function  OrderStringTxt(SQLText:string; var StartPos,EndPos:integer ):String;

//
 function  PrepareConstraint(Src:Tstrings):string;
 procedure DeleteEmptyStr(Src:Tstrings);
 function  NormalizeSQLText(const SQL: string;MacroChar:Char): string;
 function  CountSelect(const SrcSQL:string):string;
 function  GetModifyTable(const SQLText:string;AlreadyNormal:boolean):string;
function GetCharFromVKey(vkey: Word): string;
function Xls_To_StringGrid(AGrid: TStringGrid; AXLSFile: string): Boolean;
function IsObjectActive(ClassName: string): Boolean;
 function GetActiveObject(ClassID:TGUID; anil:TObject; aUnknown:IUnknown):HRESULT;');
function RegisterOCX(FileName: string): Boolean;
function UnRegisterOCX(FileName: string): Boolean;
function RegisterServer2(const aDllFileName: string; aRegister: Boolean): Boolean;
procedure mIRCDDE(Service, Topic, Cmd: string); //mIRCDDE('mIRC', 'COMMAND', '/say Hallo von SwissDelphiCenter.ch');
function OpenIE(aURL: string): boolean;
function XRTLIsInMainThread: Boolean;
function IsInMainThread: Boolean;
TryConvertStrToDateTime(const s, format: string; out value: TDateTime): Boolean;');
  ConvertStrToDateTime(const s, format: string): TDateTime;');
 Function CreateNotifyThread2(const FolderName : string; WatchSubtree : Boolean; Filter : TFileChangeFilters2) : TNotifyThread');
procedure DetectImage(const InputFileName: string; BM: TBitmap);
   function BitmapToString(Bitmap: TBitmap): String;
   function StringToBitmap(S: String): TBitmap;
  FUNCTION RemoveChar(CONST s: STRING; CONST c: CHAR): STRING;
 procedure SecureClearStr(var S: AnsiString);');
  procedure movestring(const Source: string; var Destination: string; CopyCount : Integer );
  procedure ShowFilePropertiesSH(Files: TStrings; aWnd: HWND);
  function GrabLine(const s: string; ALine: Integer): string;
  function GrabLineFast(const s: string; ALine: Integer): string;
  function IsTextFile(const sFile: TFileName): boolean;
  function getODBC: Tstringlist;
 function getODBCString: string;
 procedure GetJPGSize(const sFile: string; var wWidth, wHeight: Word);
 procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);
 procedure GetGIFSize(const sGIFFile: string; var wWidth, wHeight: Word);
 procedure ChangeWindowStyle(const Form: HWND; Style: DWord; AddIt: Boolean);


procedure SIRegister_SpectraLibrary(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('Nanometers', 'Double');
 CL.AddConstantN('WavelengthMinimum','LongInt').SetInt( 380);
 CL.AddConstantN('WavelengthMaximum','LongInt').SetInt( 780);
 Procedure WavelengthToRGB( const Wavelength : Nanometers; var R, G, B : BYTE)');
end;

procedure SIRegister_DrawFigures(CL: TPSPascalCompiler);
begin
 Procedure DrawCube( const PantoGraph : TPantoGraph; const color : TColor)');
 Procedure DrawSphere( const PantoGraph : TPantoGraph; const LatitudeColor, LongitudeColor : TColor; const LatitudeCircles, LongitudeSemicircles, PointsInCircle : WORD)');
 Procedure DrawSurface( const PantoGraph : TPantoGraph)');
 Procedure DrawFootballField( const PantoGraph : TPantoGraph; const ColorField, ColorLetters, ColorGoals : TColor)');
end;

procedure SIRegister_synadbg(CL: TPSPascalCompiler);
begin
  SIRegister_TSynaDebug(CL);
 Procedure AppendToLog( const value : Ansistring)');
end;

procedure SIRegister_XmlRpcCommon(CL: TPSPascalCompiler);
begin
  SIRegister_TRC4(CL);
  CL.AddTypeS('TRPCDataType', '( rpNone, rpString, rpInteger, rpBoolean, rpDoub'
   +'le, rpDate, rpBase64, rpStruct, rpArray, rpName, rpError )');
 Function GetTempDirRPC : string');
 Function FileIsExpired( const FileName : string; Elapsed : Integer) : Boolean');
 Function EncodeEntities( const Data : string) : string');
 Function DecodeEntities( const Data : string) : string');
 Function ReplaceRPC(const Data: string; const Find: string; const Replace: string): string');
 Function InStr( Start : Integer; const Data : string; const Find : string) : Integer');
 Function Mid( const Data : string; Start : Integer) : string');
 Function DateTimeToISO( ConvertDate : TDateTime) : string');
 Function IsoToDateTime( const ISOStringDate : string) : TDateTime');
 Function ParseStringRPC( const SearchString : string; Delimiter : Char; Substrings : TStrings; const AllowEmptyStrings : Boolean; ClearBeforeParse : Boolean) : Integer');
 Function ParseStream( SearchStream : TStream; Delimiter : Char; Substrings : TStrings; AllowEmptyStrings : Boolean; ClearBeforeParse : Boolean) : Integer');
 Function FixEmptyString( const Value : string) : string');
 Function URLEncodeRPC( const Value : string) : string');
 Function StreamToStringRPC( Stream : TStream) : string');
 Procedure StringToStream( const Text : string; Stream : TStream)');
 Function StreamToVariant( Stream : TStream) : OleVariant');
 Procedure VariantToStream( V : OleVariant; Stream : TStream)');
 Function Hash128AsHex( const Hash128Value : T4x4LongWordRecord) : string');
 CL.AddConstantN('ValidURLChars','String').SetString( 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_@.&+-!''*"(),;/#?:');
end;

procedure SIRegister_synafpc(CL: TPSPascalCompiler);
begin
 Function LoadLibraryfpc( ModuleName : PChar) : TLibHandle');
 Function FreeLibraryfpc( Module : TLibHandle) : LongBool');
 Function GetProcAddressfpc( Module : TLibHandle; Proc : PChar) : Pointer');
 Function GetModuleFileNamefpc(Module:TLibHandle;Buffer:PChar; BufLen:Integer):Integer;
  CL.AddTypeS('TLibHandle', 'Integer');
  CL.AddTypeS('TLibHandle2', 'HModule');
  CL.AddTypeS('LongWordfpc', 'DWord');
 Procedure Sleepfpc( milliseconds : Cardinal)');
end;

procedure SIRegister_Spring_Utilsmx(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOSPlatformType', '( ptUnknown, ptWin3x, ptWin9x, ptWinNT )');
  SIRegister_TOperatingSystem(CL);
  SIRegister_TEnvironmentClass(CL);
  CL.AddTypeS('Environment', 'TEnvironment');
 Function ApplicationPath : string');
 Function ApplicationVersion : TVersion');
 Function ApplicationVersionString : string');
 Function GetLastErrorMessage : string');
 Function CreateCallback( obj : TObject; methodAddress : Pointer) : TCallbackFunc');
 Function ConvertFileTimeToDateTime( const fileTime : TFileTime; useLocalTimeZone : Boolean) : TDateTime;');
 Function ConvertDateTimeToFileTime( const datetime : TDateTime; useLocalTimeZone : Boolean) : TFileTime;');
 {Procedure Synchronize( threadProc : TThreadProcedure)');
 Procedure Queue( threadProc : TThreadProcedure)'); }
 Function TryGetPropInfo( instance : TObject; const propertyName : string; out propInfo : PPropInfo) : Boolean');
 Function IsCtrlPressed : Boolean');
 Function IsShiftPressed : Boolean');
 Function IsAltPressed : Boolean');
 Procedure CheckFileExists( const fileName : string)');
 Procedure CheckDirectoryExists( const directory : string)');
 CL.AddConstantN('COneKB','Int64').SetInt64( 1024);
 CL.AddConstantN('COneMB','Int64').SetInt64( 1048576);
 CL.AddConstantN('COneGB','Int64').SetInt64( 1073741824);
 CL.AddConstantN('COneTB','Int64').SetInt64( 1099511627776);
 function TryConvertStrToDateTime(const s,format:string;out value:TDateTime):Boolean;');
 function ConvertStrToDateTime(const s, format: string): TDateTime;');
end;

procedure SIRegister_rxOle2Auto(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxDispArgs','LongInt').SetInt( 64);
 CL.AddConstantN('MaxDispArgs','LongInt').SetInt( 32);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropReadOnly');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropWriteOnly');
  SIRegister_TOleController(CL);
 Procedure InitOLE2');
 Procedure DoneOLE');
 Function OleInitialized : Boolean');
 Function MakeLangID( PrimaryLangID, SubLangID : Word) : Word');
 Function MakeLCID( LangID : Word) : TLCID');
 Function CreateLCID( PrimaryLangID, SubLangID : Word) : TLCID');
 Function ExtractLangID( LCID : TLCID) : Word');
 Function ExtractSubLangID( LCID : TLCID) : Word');
end;

procedure SIRegister_ulogifit(CL: TPSPascalCompiler);
begin
 Procedure LogiFit( X, Y : TVector; Lb, Ub : Integer; ConsTerm : Boolean; General : Boolean; MaxIter : Integer; Tol : Float; B : TVector; V : TMatrix)');
 Procedure WLogiFit( X, Y, S : TVector; Lb, Ub : Integer; ConsTerm : Boolean; General : Boolean; MaxIter : Integer; Tol : Float; B : TVector; V : TMatrix)');
 Function LogiFit_Func( X : Float; B : TVector) : Float');
end;

procedure SIRegister_ulinfit(CL: TPSPascalCompiler);
begin
 Procedure LinFit( X, Y : TVector; Lb, Ub : Integer; B : TVector; V : TMatrix)');
 Procedure WLinFit( X, Y, S : TVector; Lb, Ub : Integer; B : TVector; V : TMatrix)');
 Procedure SVDLinFit( X, Y : TVector; Lb, Ub : Integer; SVDTol : Float; B : TVector; V : TMatrix)');
 Procedure WSVDLinFit( X, Y, S : TVector; Lb, Ub : Integer; SVDTol : Float; B : TVector; V : TMatrix)');
 Procedure SVDFit( X : TMatrix; Y : TVector; Lb, Ub, Nvar : Integer; ConsTerm : Boolean; SVDTol : Float; B : TVector; V : TMatrix)');
 Procedure WSVDFit( X : TMatrix; Y, S : TVector; Lb, Ub, Nvar : Integer; ConsTerm : Boolean; SVDTol : Float; B : TVector; V : TMatrix)');
 end;

 Procedure FormattedTextOut( TargetCanvas : TCanvas; const Rect : TRect; const Text : string; Selected : Boolean; Columns : TProposalColumns; Images : TImageList)');
 Function FormattedTextWidth( TargetCanvas : TCanvas; const Text : string; Columns : TProposalColumns; Images : TImageList) : Integer');
 Function PrettyTextToFormattedString( const APrettyText : string; AlternateBoldStyle : Boolean) : string');

 procedure SIRegister_MaxUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('MaxCharSet', 'set of Char');
 Function GetMachineNamemax : String');
 Function GetModuleNamemax( HModule : THandle) : String');
 Function TrimChars( const S : string; Chars : MaxCharSet) : string');
 Function TickCountToDateTime( Ticks : Cardinal) : TDateTime');
 Procedure OutputDebugStringmax( const S : String)');
 Procedure OutputDebugFormat( const FmtStr : String; Args : array of const)');
 Function IsAppRunningInDelphi : Boolean');
 Procedure ParseFields( Separators, WhiteSpace : TSysCharSet; Content : PChar; Strings : TStrings; Decode : Boolean)');
 Function HTTPDecodemax( const AStr : String) : string');
 Function HTTPEncodemax( const AStr : String) : string');
 Function FormatDate( const DateString : string) : string');
 Function FormatListMasterDate(const DateStr,FormatDefStr:String; Len:Integer):String');
 Function InvertCase( const S : String) : String');
 Function CommentLinesWithSlashes( const S : String) : String');
 Function UncommentLinesWithSlashes( const S : String) : String');
 Function StripChars( const S : String; Strip : CharSet) : String');
 Function TrimChars( const S : string; Chars : CharSet) : string');
 Function TrimLeftChars( const S : string; Chars : CharSet) : string');
 Function TrimRightChars( const S : string; Chars : CharSet) : string');
 Function ContainsChars( const S : String; Strip : CharSet) : Boolean');
 Function DequotedStrmax( const S : String; AQuoteChar : Char) : String');
 Procedure LeftPadStr( var S : String; toLength : Integer; withChar : Char)');
 Procedure RightPadStr( var S : String; toLength : Integer; withChar : Char)');
 Function RemoveChars( S : string; Chars : CharSet) : string');
 Function FilterChars( S : string; Chars : CharSet) : string');
 Function RemoveNonNumericChars( S : string) : string');
 Function RemoveNonAlphanumChars( S : string) : string');
 Function RemoveNonAlphaChars( S : string) : string');
 Function HasAlphaChars( S : string) : boolean');
 Function ReplaceChars( S : string; Chars : CharSet; ReplaceWith : Char) : string');
 Function DomainOfEMail( const EMailAddress : String) : String');
 Function IPToHexIP( const IP : String) : String');
 Procedure CmdLineToStrings( S : AnsiString; const List : TStrings)');
 BASE2','String').SetString( '01');
 CL.AddConstantN('BASE10','String').SetString( '0123456789');
 CL.AddConstantN('BASE16','String').SetString( '0123456789ABCDEF');
 CL.AddConstantN('BASE36','String').SetString( '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
 CL.AddConstantN('BASE62','String').SetString( '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz');
 Function BaseConvert( Number, FromDigits, ToDigits : String) : String');
Function ValidXmlName( AName : PChar; ASize : Integer) : Boolean;');
 Function ValidXmlName1( const AName : String) : Boolean;');
 Function EncodeXmlAttrValue( const AStr : AnsiString) : AnsiString;');
 Procedure EncodeXmlAttrValue3( ABuff : PChar; ABuffSize : Integer; var AStr : AnsiString; var ALen, AOffset : Integer);');
 Procedure EncodeXmlAttrValue4( const ASource : String; var ADest : String; var ALen, AOffset : Integer);');
 Function EncodeXmlString5( const AStr : String) : String;');
 Procedure EncodeXmlString6( ABuff : PChar; ABuffSize : Integer; var AStr : AnsiString; var ALen, AOffset : Integer);');
 Procedure EncodeXmlComment( const ASource : AnsiString; var ADest : AnsiString; var ALen, AOffset : Integer);');
 Function HasEncoding( const AStr : AnsiString) : Boolean');
 Function DecodeXmlAttrValue( const AStr : String) : String');
 Procedure ReallocateString( var AString : AnsiString; var ALen : Integer; AReqLen : Integer)');
 //Procedure AttrFillXMLString( AnAttr : IAttribute; var aString : AnsiString; var aOffset, aLen : Integer)');
 //Procedure FillXMLString( ANode : INode; var AString : String; var AOffset, ALen : Integer; ASibling : INode; ALevel : Integer)');
 //Function NodeToXML( ANode : INode) : String');
 //Procedure XMLSaveToFile( ANode : INode; const AFileName : String)');
 //Function XMLLoadFromFile( const AFileName : String) : INode');
 Function Hashmax( const ASource : AnsiString) : Cardinal');
 CL.AddConstantN('GXMLIndentSpaces','Integer').SetInt( 2);
 //CL.AddConstantN('GXMLMultiLineAttributes','Boolean')BoolToStr( True);
 CL.AddConstantN('GXMLMultiLineAttributeThreshold','Integer').SetInt( 7);
 end;

procedure SIRegister_MaxDOMDictionary(CL: TPSPascalCompiler);
begin
  SIRegister_IDictionary(CL);
  SIRegister_TDictionary(CL);
 Function HashFast( const AKey : String) : Cardinal');
 Function HashCarlos( const AKey : String) : Cardinal');
 Function BorlandHashOf( const AKey : String) : Cardinal');
 Function HashSumOfChars( const AKey : String) : Cardinal');
end;

procedure SIRegister_MaxDOM(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNodeType', '( ntElement, ntText, ntCDATA, ntComment )');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),INode, 'INode');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAttribute, 'IAttribute');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAttributeCollection, 'IAttributeCollection');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),INodeCollection, 'INodeCollection');
  SIRegister_INode(CL);
  SIRegister_IAttribute(CL);
  SIRegister_IAttributeCollection(CL);
  SIRegister_INodeCollection(CL);
 Function NodeCreate( const ANodeName : String; ANodeType : TNodeType) : INode');
  SIRegister_TAttribute(CL);
  CL.AddTypeS('TNodes', 'array of INode');
  CL.AddTypeS('TAttributes2', 'array of IAttribute');
  CL.AddTypeS('THashedAttributes', 'record Attributes : TAttributes2; AttrCount '
   +': Integer; AttrCapacity : Integer; end');
  CL.AddTypeS('TAttrHashTable', 'array of THashedAttributes');
  SIRegister_TNode(CL);
  //CL.AddTypeS('TNodeClass', 'class of TNode');
  //CL.AddTypeS('TAttributeClass', 'class of TAttribute');
 Function PointerToStr( P : ___Pointer) : String');
 Function StrToPointer( const S : String) : ___Pointer');
 Function INodeToStr( ANode : INode) : String');
 Function StrToINode( const S : String) : INode');
 Function CompareByNodeName( N1, N2 : INode) : Integer');
 Function CompareByNameAttr( N1, N2 : INode) : Integer');
end;

procedure SIRegister_FileStreamW(CL: TPSPascalCompiler);
begin
  SIRegister_TFileStreamW(CL);
  {TFormFadeSettings = record
    Form: TForm;
    Step: ShortInt;
    DisableBlendOnFinish: Boolean;
    Callback: TNotifyEvent;
    MinAlpha, MaxAlpha: Byte;
  end;}

 TFormFadeSettings', 'record Form: TForm;Step: ShortInt; DisableBlendOnFinish: Boolean; Callback: TNotifyEvent; MinAlpha, MaxAlpha: Byte; end');
 CL.AddConstantN('fmForcePath','LongWord').SetUInt( $80000000);
 Function LoadUnicodeFromStream( S : TStream; AsIsAnsi : Boolean) : WideString');
 function GetClipboardText: WideString;');
 procedure CopyToClipboard(Str: WideString);');
 function CurrentWinUser: WideString;');
  function GetTempPathW: WideString;');
 function GetTempFileNameW: WideString;');
 function GetDesktopFolderW: WideString;');
 function IsWritable(const FileName: WideString): Boolean;');
 function SysErrorMessageW(ErrorCode: Integer): WideString;');
 function FormatExceptionInfo: WideString;');
 procedure ShowExceptionW(Message: WideString);');
 procedure ChangeWindowStyle(const Form: HWND; Style: DWord; AddIt: Boolean);');

 function SetNtfsCompressionW(const FileName: WideString; Level: Word): Boolean;');
 function WriteWS(const Stream: TStream; const Str: WideString): Word;');
 procedure FormFadeIn(Form: TForm; Step: ShortInt);');
 procedure FormFadeOut(Form: TForm; Step: ShortInt);');
 procedure FormFadeOutAndWait(Form: TForm; Step: ShortInt);');
 function BrowseForFolderw(const Caption, DefaultPath: WideString; const OwnerWindow: HWND): WideString;');
 procedure FormFade(const Settings: TFormFadeSettings);');
  function HashOfString(const Str: WideString): DWord;
  function ComparePoints(const First, Second: TPoint): ShortInt;

end;

procedure SIRegister_InetUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNetUtilsSettings', 'record UserAgent : String; ProxyURL : Strin'
   +'g; OpenURLFlags : DWord; TrafficCounter : Dword; UploadedCounter : DWord; ReadBufferSize : DWord; end');
  TRawCharset', 'set of Char');
  TInetHeaders', 'array of String');
  SIRegister_EInet(CL);
  TInetDownloadCallback', 'Function ( Downloaded, TotalSize : DWord) : Boolean');
 Function InetDownloadTo( const DestFile : WideString; const URL : String; Callback : TInetDownloadCallback) : Boolean;');
 Function InetDownloadTo1( const DestFile : WideString; const URL : String; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : Boolean;');
 Function InetDownload( const URL : String; Dest : TStream; Callback : TInetDownloadCallback) : Boolean;');
 Function InetDownload3( const URL : String; Dest : TStream; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : Boolean;');
 Function InetBufferedReadFrom( Handle : HInternet; Dest : TStream; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : DWord;');
 Function InetBufferedReadFrom5( Handle : HInternet; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : String;');
 Function IsResponseStatusOK( Handle : HInternet) : Boolean');
  TMultipartItem', 'record Headers : TInetHeaders; Data : TStream; end');

  {  TMaskMatchInfo = record
    Matched: Boolean;
    StrPos: Word;
    MatchLength: Word;
  end;}

  TMaskMatchInfo', 'record Matched: Boolean; StrPos: Word; MatchLength: Word; end');

  TMultipartItems', 'array of TMultipartItem');
  TUploadFile','record Name:String; SourceFileName : WideString; Data : TStream; end');
  TUploadFiles', 'array of TUploadFile');
 Function FindBoundaryFor( const Items : TMultipartItems) : String');
 Function RandomBoundary : String');
 Function GenerateMultipartFormFrom( const Items : TMultipartItems; out ExtraHeaders : TInetHeaders) : String');
 Function InetUploadTo( const ToURL : String; const Headers : TInetHeaders; const Items : TMultipartItems; const Settings : TNetUtilsSettings) : String;');
 Function InetUploadTo7( const ToURL : String; const Items : TMultipartItems; const Settings : TNetUtilsSettings) : String;');
 Function InetUploadTo8(const ToURL: String; const Items: TMultipartItems) : String;');
 Function InetUploadStreamsTo( const ToURL : String; const Settings : TNetUtilsSettings; Streams : TUploadFiles) : String;');
 Function InetUploadStreamsTo10(const ToURL:String;const Streams:TUploadFiles):String;
 Function InetUploadFileTo( const ToURL : String; const Settings : TNetUtilsSettings; const ItemName : String; const FilePath : WideString) : String;');
 Function InetUploadFileTo12( const ToURL : String; const ItemName : String; const FilePath : WideString) : String;');
 Function InetUploadFilesTo( const ToURL : String; const Settings : TNetUtilsSettings; const Files : array of const) : String;');
 Function InetUploadFilesTo14( const ToURL : String; const Files : array of const) : String;');
 Function AppendQueryTo(const URL: String; const Arguments: array of const):String');
 Function HasQueryPart( const URL : String) : Boolean');
 Function BuildQueryFrom( const Arguments : array of const) : String');
 Function BuildURLW( Protocol, Host : String; Port : Word; Path, Script : String; const Arguments : array of const) : String');
 Function CustomEncode(const Str: WideString; const RawChars:TRawCharset): String');
 Function EncodeURI( const Str : WideString) : String');
 Function EncodeURIComponent( const Str : WideString) : String');
 Procedure InetGetLastError( out ErrorCode : DWord; out ErrorMessage : String)');
 Function InetGetLastErrorCode : DWord');
 Function InetGetLastErrorMsg : String');
 Function AbsoluteURLFrom( URL, BaseURL, BasePath : String) : String');
 Procedure SplitURL( const URL : String; out Domain, Path : String)');
 Function DomainOf( const URL : String) : String');
 Function PathFromURL( const URL : String) : String');
 Function InetHeaders( const NameValues : array of const) : TInetHeaders');
 Function NoInetHeaders : TInetHeaders');
 Function JoinHeaders( const Headers : TInetHeaders) : String');
 CL.AddConstantN('InetHeaderEOLN','String').SetString( #13#10);
 Procedure SetDefaultNetUtilsSettings');
 Function TotalDownTrafficThroughNetUtils : DWord');
  TDBDraw', 'record DisplayDC : HDC; MemDC : HDC; MemBitmap : HBIT'
   +'MAP; OldBitmap : HBITMAP; OldFont : HFONT; OldPen : HPEN; end');
  TPieceFormatData', 'record Position : TMaskMatchInfo; Color : TColor; end');
  TFormatData', 'array of TPieceFormatData');
  TDrawFormattedTextSettings', 'record Text : WideString; FormatDa'
   +'ta : TFormatData; Canvas : TCanvas; WrapText : Boolean; DestPos : TPoint; '
   +'MaxWidth : Word; CharSpacing : Word; end');
  TWrapTextSettings', 'record DC : HDC; Str : WideString; Delimite'
   +'r : WideString; MaxWidth : Word; LeftMargin : Word; CharSpacing : Word; LastChar : TSize; end');
 Function TextSize( const DC : HDC; const Str : WideString) : TSize');
 Function TextWidthW2( const DC : HDC; const Str : WideString) : Integer');
 Function TextHeightW2( const DC : HDC; const Str : WideString) : Integer');
 Function GetLineHeightOf( const Font : HFONT) : Word');
 Function TextWidthEx(const DC: HDC;const Str: WideString; const CharSpacing:Word): Integer;
 Function TextHeightEx(const DC: HDC;const Str: WideString; const CharSpacing:Word): Integer;
 Function TextSizeEx(const DC:HDC;const Str:WideString;const CharSpacing:Word):TSize');
 Function TextWithBreaksSize( Settings : TWrapTextSettings) : TSize;');
 Function DoubleBufferedDraw(const DisplaySurface:HDC;const BufferSize:TPoint):TDBDraw;
 Function DoubleBufferedDraw17(const Canvas:TCanvas; const BufferSize:TPoint):TDBDraw;
 Function DoubleBufferedDraw2(const Canvas:TCanvas; const BufferSize:TPoint):TDBDraw;
 Procedure DrawFormattedText( const Settings : TDrawFormattedTextSettings)');
 Function GetLastCharPos( const DC : HDC; const Str : WideString; const MaxWidth : Word; const CharSpacing : Word) : TSize');
 Function WrapNonMonospacedText( const DC : HDC; const Str : WideString; const Delimiter : WideString; const MaxWidth : Word; const CharSpacing : Word) : WideString;');
 Function WrapNonMonospacedText2( var Settings : TWrapTextSettings) : WideString;');
end;

procedure SIRegister_StrConv(CL: TPSPascalCompiler);
begin
 CL.AddTypeS('TCodepage', 'DWord');
 CL.AddConstantN('CP_INVALID','LongInt').SetInt( TCodepage ( - 1 ));
 CL.AddConstantN('CP_ASIS','LongInt').SetInt( TCodepage ( - 2 ));
 CL.AddConstantN('CP_ANSI','longint').SetInt(0);
 CL.AddConstantN('CP_OEM','longint').SetInt(1);
 CL.AddConstantN('CP_SHIFTJIS','LongInt').SetInt( 932);
 CL.AddConstantN('CP_LATIN1','LongInt').SetInt( 1250);
 CL.AddConstantN('CP_UNICODE','LongInt').SetInt( 1200);
 CL.AddConstantN('CP_UTF8','LongInt').SetInt( 65001);
 Function MinStrConvBufSize( SrcCodepage : TCodepage; Str : String) : Integer;');
 Function MinStrConvBufSize1( DestCodepage : TCodepage; Wide : WideString) : Integer;');
 Function ToWideString(SrcCodepage: TCodepage; Str : String; BufSize: Integer) : WideString');
 Function FromWideString( DestCodepage : TCodepage; Str : WideString; BufSize : Integer; Fail : Boolean) : String');
 Function CharsetToID( Str : String) : TCodepage');
 Function IdToCharset( ID : TCodepage; GetDescription : Boolean) : String');
 function CompareStrW(const S1, S2: WideString; Flags: DWord = 0): Integer;
 function CompareTextW(const S1, S2: WideString): Integer;
 function MaskMatch(const Str, Mask: WideString): Boolean;
 { Info can have special values in some cases:
  * Matched = True but MatchLength = 0 (and StrPos having random value) - this means that Mask consisted of only "*" and
    thus no particular substring could be specified (since it could match any part of the string). }
 function MaskMatchInfo(const Str,Mask:WideString;StartingPos:Word = 1):TMaskMatchInfo;
 //Strutils
  Function TryStrToIntStrict(const S: String; out Value:Integer; Min:Integer):Boolean;
 Function TryStrToFloatStrict( const S : String; out Value : Single; const FormatSettings : TFormatSettings) : Boolean;');
 Function TryStrToFloatStrict1( const S : String; out Value : Double; const FormatSettings : TFormatSettings) : Boolean;');
 Function DetectEolnStyleIn( const Str : WideString) : WideString');
 Function DetectEolnStyleInANSI( Stream : TStream) : WideString');
 Function PascalQuote( const Str : WideString) : WideString');
  Function StrRepeatW( const Str : WideString; Times : Integer) : WideString');
  Function EscapeString(const Str: WideString; CharsToEscape:WideString): WideString');
 Function UnescapeString(const Str: WideString; CharsToEscape: WideString):WideString;
 Function BinToHexW( const Buf : String; Delim : String) : String');
 Function HexToBinW( Text : String) : String');
 Function SoftHexToBin( Text : String) : String');
 Function FormatVersion( Version : Word) : WideString');
 Function FormatDateW( Date : DWord) : WideString');
 Function FormatNumber( Number : DWord) : WideString');
 Function GenericFormat(Number:Single;const Language:TGenericFormatLanguage):WideString;
 Function FormatInterval( Millisecs : DWord) : WideString');
 Function FormatSize( Bytes : DWord) : WideString');
 Function PosLast( const Substr, Str : String; Start : Word) : Integer');
 Function PosLastW( const Substr, Str : WideString; Start : Word) : Integer');
 Function IsDelimiterW(const Delimiters,S: WideString; Index: Integer): Boolean');
 Function RemoveNonWordChars(const Str: WideString;DoNotRemove:WideString):WideString;
 Function IsQuoteChar( const aChr : Char) : Boolean');
 Function WrapTextW( const Str : WideString; const Delimiter : WideString; const MaxWidth : Word) : WideString');
 Function PadText( const Str : WideString; const NewLine, PadStr : WideString; const MaxWidth : Word) : WideString');
 Function PadTextWithVariableLineLength( const Str : WideString; const NewLine, PadStr : WideString; const LineLengths : array of Integer) : WideString');
 Function StrPadW(const Str : WideString; ToLength : Integer; PadChar: WideChar) : WideString');
 Function StrPadLeftW(const Str: WideString;ToLength: Integer;PadChar: WideChar) : WideString');
 //Function StrRepeat( const Str : WideString; Times : Integer) : WideString');
 Function StrReverseW( const Str : WideString) : WideString');
  Function CountSubstr( const Substr, Str : WideString) : Integer');
   Procedure DeleteArrayItem( var A : TWideStringArray; Index : Integer)');
 Function TrimStringArray( WSArray : TWideStringArray) : TWideStringArray');
 Function TrimWS( Str : WideString; const Chars : WideString) : WideString');
 Function TrimLeftWS( Str : WideString; const Chars : WideString) : WideString');
 //Function TrimRightWS( Str : WideString; const Chars : WideString) : WideString');
 Function ConsistsOfChars( const Str, Chars : WideString) : Boolean');
 Function UpperCaseW( const Str : WideString) : WideString');
 Function LowerCaseW( const Str : WideString) : WideString');
 Function UpperCaseFirst( const Str : WideString) : WideString');
 Function LowerCaseFirst( const Str : WideString) : WideString');
 Function StripAccelChars( const Str : WideString) : WideString');
end;


Amount of Functions: 16400
Amount of Procedures: 9844
Amount of Constructors: 1618
Totals of Calls: 27862
SHA1: of maXbox4.exe (4.0.2.80) CDC0D39FE16CE883EA98FF65C7E31C874FE1520B
CRC32: 64E170B0
maXbox4.exe 26,506,752 bytes

https://www.virustotal.com/en/file/c51abbc4533c2a13430ecec4efc37857d173476cbb0115b4d91079227239e59a/analysis/1454793082/

Cumulative Update for Windows 10 Version 1511 for x64-based Systems (KB3124263).
Cumulative Update for Windows 10 Version 1511 for x64-based Systems (KB3124262).


****************************************************************
Release Notes maXbox 3.9.9.195 Mai 2015 CODEsign
****************************************************************
Add 36 Units, 1 Tutor, SOAPConn, AVI-Res, OLEUtils, ACM, CDS

1085 unit uPSI_JvAnimate                       //JCL
1086 unit uPSI_DBXCharDecoder;                 //DBX
1087 unit uPSI_JvDBLists;                      //JCL
1088 unit uPSI_JvFileInfo;                     //JCL
1089 unit uPSI_SOAPConn;                       //VCL
1090 unit uPSI_SOAPLinked;                     //VCL
1091 unit uPSI_XSBuiltIns;                     //VCL
1092 unit uPSI_JvgDigits;                      //JCL
1093 unit uPSI_JvDesignUtils;
1094 unit uPSI_JvgCrossTable;
1095 unit uPSI_JvgReport;
1096 unit uPSI_JvDBRichEdit;
1097 unit uPSI_JvWinHelp;
1098 unit uPSI_WaveConverter;
1099 unit uPSI_ACMConvertor;
1100 unit XSBuiltIns_Routines
1101 unit uPSI_ComObjOleDB_utils.pas
1102 unit uPSI_SMScript;
1103 unit uPSI_CompFileIo;
1104 unit uPSI_SynHighlighterGeneral;
1105 unit uPSI_geometry2;
1106 unit uPSI_MConnect
1107 unit uPSI_ObjBrkr;
1108 unit uPSI_uMultiStr;
1109 unit uPSI_WinAPI.pas;
1110 unit uPSI_JvAVICapture;
1111 unit uPSI_JvExceptionForm;
1112 unit uPSI_JvConnectNetwork;
1113 unit uPSI_MTMainForm;
1114 unit uPSI_DdeMan;
1115 unit uPSI_DIUtils;
1116 unit uPSI_gnugettext;
1117 unit uPSI_Xmlxform;
1118 unit uPSI_SvrHTTPIndy;
1119 unit uPSI_CPortTrmSet;
1120 unit SvrLog;


SHA1:  maXbox3.exe F0AB7D054111F5CE46BA122D6280397A841C6FAB
CRC32: maXbox3.exe 602A885C


****************************************************************
Release Notes maXbox 3.9.9.180 March 2015 CODEsign
****************************************************************
Add 20 Units, 1 Slide,Tutor, BigNumbers, TestFramework, GEOInfo

1065 unit uPSI_UDict;                          //DFF
1066 unit uPSI_ubigFloatV3;                    //DFF
1067 unit uPSI_UBigIntsV4;                     //DFF 
1068 unit uPSI_ServiceMgr2;                    //mX
1069 unit uPSI_UP10Build;                      //PS
1070 unit uPSI_UParser10;                      //PS
1071 unit uPSI_IdModBusServer;                 //MB
1072 unit uPSI_IdModBusClient; +MBUtils        //MB
1073 unit uPSI_ColorGrd;                       //VCL
1074 unit uPSI_DirOutln;                       //VCL
1075 unit uPSI_Gauges;                         //VCL
1076 unit uPSI_CustomizeDlg;                   //VCL
1077 unit uPSI_ActnMan;                        //VCL
1078 unit uPSI_CollPanl;                       //VCL
1079 unit uPSI_Calendar2;                      //VCL
1080 unit uPSI_IBCtrls;                        //VCL
1081 unit uPSI_IdStackWindows;                 //Indy
1082 unit uPSI_CTSVendorUtils;
1083 unit uPSI_VendorTestFramework;
1084 unit uPSI_TInterval; 

SHA1:  maXbox3.exe 3D7F88BE9687CB834A5E2DAED08B23358484FEC0
CRC32: maXbox3.exe E2ADE828


****************************************************************
Release Notes maXbox 3.9.9.160 January 2015 CODEsign
****************************************************************
Add 12 Units, 2Slides 1Tutor, CLXUp, ExampleEdition, UnitConv
ExecuteProcess (MultiProcessor), ConsoleCapture (DOS)

1053 unit uPSI_BigIni                          //Hinzen
1054 unit uPSI_ShellCtrls;                     //VCL
1055 unit uPSI_fMath;                          //FMath
1056 unit uPSI_fComp;                          //FMath
1057 unit uPSI_HighResTimer;                   //Lauer
1058 unit uconvMain; (Unit Converter)          //PS
1059 unit uPSI_uconvMain;                      //PS
1060 unit uPSI_ParserUtils;                    //PS
1061 unit uPSI_uPSUtils;                       //PS
1062 unit uPSI_ParserU;                        //PS
1063 unit uPSI_TypInfo; {SubSet}               //VCL
1064 unit uPSI_ServiceMgr;                     //mX

SHA1:  maXbox3.exe 9C80649752AABE948C34180552BEDC2AB295E82A
CRC32: maXbox3.exe B4B4B5C7


****************************************************************
Release Notes maXbox 3.9.9.120 December 2014 CODEsign
****************************************************************
Add 10 Units, 1Slides, NeuralNetwork, Pan3D View, GDIBackend

1043 unit uPSI_NeuralNetwork;
1044 unit uPSI_StExpr;
1045 unit uPSI_GR32_Geometry;
1046 unit uPSI_GR32_Containers;
1047 unit uPSI_GR32_Backends_VCL,
1048 unit uPSI_StSaturn; //Venus+Pluto+Mars+Merc+JupSat+++
1049 unit uPSI_JclParseUses;
1050 unit uPSI_JvFinalize;
1051 unit uPSI_panUnit1;
1052 unit uPSI_DD83u1;  //Arduino Tester

SHA1:  maXbox3.exe 3EFB12E5729BDAA745373C2743F9DD1E93C9295D
CRC32: maXbox3.exe 9435E377


****************************************************************
Release Notes maXbox 3.9.9.110 November 2014 CODEsign
****************************************************************
Add 36 Units, 1 Tutor, maXmap, OpenStreetView, MAPX, timers
Function Menu/View/GEO Map View, DownloadFile, wgetX, sensors
StreamUtils, IDL Syntax, OpenStreetMap, OpenMapX, LPT1, LazDOM
ByteCode2, runByteCode, sensors, CGI-Powtils, IPUtils2, GPS_2

1006 unit uPSI_cyRunTimeResize;
1007 unit uPSI_jcontrolutils;
1008 unit uPSI_kcMapViewer; (+GEONames)
1009 unit uPSI_kcMapViewerDESynapse;
1010 unit uPSI_cparserutils; (+GIS_SysUtils) 
1011 unit uPSI_LedNumber;
1012 unit uPSI_StStrL;
1013 unit uPSI_indGnouMeter;
1014 unit uPSI_Sensors;
1015 unit uPSI_pwnative_out; //CGI of powtils
1016 unit uPSI_HTMLUtil;
1017 unit uPSI_synwrap1; //httpsend
1018 unit StreamWrap1
1019 unit uPSI_pwmain; {beta}
1020 unit pwtypes 
1021 uPSI_W32VersionInfo
1022 unit uPSI_IpAnim;
1023 unit uPSI_IpUtils; //iputils2 (TurboPower)
1024 unit uPSI_LrtPoTools;
1025 unit uPSI_Laz_DOM;
1026 unit uPSI_hhAvComp;
1027 unit uPSI_GPS2;
1028 unit uPSI_GPS;
1029 unit uPSI_GPSUDemo; // formtemplate TFDemo
1030 unit uPSI_NMEA;     // GPS
1031 unit uPSI_ScreenThreeDLab;
1032 unit uPSI_Spin; //VCL	
1033 unit uPSI_DynaZip;
1034 unit uPSI_clockExpert;
1035 unit debugLn
1036 uPSI_SortUtils;
1037 uPSI_BitmapConversion;
1038 unit uPSI_JclTD32;
1039 unit uPSI_ZDbcUtils;
1040 unit uPSI_ZScriptParser;
1041 uPSI_JvIni,
1042 uPSI_JvFtpGrabber;


SHA1:  maXbox3.exe C47713EE2CFFD66F569249E63A16D10874B484B1
CRC32: maXbox3.exe 2242B697


****************************************************************
Release Notes maXbox 3.9.9.98 September 2014
****************************************************************
Add 60 Units, 2 Tutors, Math+, OpenOffice, Pipes, GSM2, VUMeter
TFixedCriticalSection, XPlatform beta, GCC Command Pipe, XPrint
VfW (Video), FindFirst3, ResFiler, AssemblyCache, maXring, morse

946 uPSI_NamedPipes,
947 uPSI_NamedPipeServer,
948 unit uPSI_process,
949 unit uPSI_DPUtils;
950 unit uPSI_CommonTools;
951 uPSI_DataSendToWeb,
952 uPSI_StarCalc,
953 uPSI_D2_XPVistaHelperU
954 unit uPSI_NetTools
955 unit uPSI_Pipes_Prectime, 
956 uPSI_ProcessUnit,
957 uPSI_adGSM,
958 unit uPSI_BetterADODataSet;
959 uPSI_AdSelCom; //FTT
960 unit uPSI_dwsXPlatform;
961 uPSI_AdSocket;
962 uPSI_AdPacket;
963 uPSI_AdPort;
964 uPSI_PathFunc;
965 uPSI_CmnFunc;
966 uPSI_CmnFunc2; //Inno Setup
967 unit uPSI_BitmapImage;
968 unit uPSI_ImageGrabber;
969 uPSI_SecurityFunc,
970 uPSI_RedirFunc,
971 uPSI_FIFO, (MemoryStream)
972 uPSI_Int64Em,
973 unit uPSI_InstFunc;
974 unit uPSI_LibFusion;
975 uPSI_SimpleExpression;
976 uPSI_unitResourceDetails,
977 uPSI_unitResFile,
978 unit uPSI_simpleComport;
979 uPSI_AfViewershelpers;
980 unit uPSI_Console;
981 unit uPSI_AnalogMeter;
982 unit uPSI_XPrinter,
983 unit uPSI_IniFiles;
984 unit uPSI_lazIniFiles;
985 uPSI_testutils;
986 uPSI_ToolsUnit;
987 uPSI_fpcunit
988 uPSI_testdecorator;
989 unit uPSI_fpcunittests;
990 unit uPSI_cTCPBuffer;
991 unit uPSI_Glut,
992 uPSI_LEDBitmaps,
993 uPSI_FileClass,
994 uPSI_FileUtilsClass,
995 uPSI_ComPortInterface; //Kit
996 unit uPSI_SwitchLed;
997 unit uPSI_cyDmmCanvas;
998 uPSI_uColorFunctions;
999 uPSI_uSettings;
1000 uPSI_cyDebug.pas
1001 uPSI_cyColorMatrix;
1002 unit uPSI_cyCopyFiles;
1003 unit uPSI_cySearchFiles;
1004 unit uPSI_cyBaseMeasure;
1005 unit uPSI_PJIStreams;

SHA1:  maXbox3.exe D0EC95326FE1ABD9D441F137336D00CF4BC77CAB
CRC32: maXbox3.exe D74E54A7


****************************************************************
Release Notes maXbox 3.9.9.96 July 2014
****************************************************************
SendBuffer, Color+Caption hack, ComboSet,SetPrivilege, WakeOnLAN
ParaDice 3D Cube Polygraph, OCR, GPS, 20 Units add, getWebScript
Error Helper, Profiler, Checkers

921 unit uPSI_cyIEUtils;
922 unit uPSI_UcomboV2;
923 uPSI_cyBaseComm,
924 uPSI_cyAppInstances,
925 uPSI_cyAttract,
926 uPSI_cyDERUtils
927 unit uPSI_cyDocER;
928 unit uPSI_ODBC;
929 unit uPSI_AssocExec;
930 uPSI_cyBaseCommRoomConnector,
931 uPSI_cyCommRoomConnector,
932 uPSI_cyCommunicate,
933 uPSI_cyImage;
934 uPSI_cyBaseContainer
935 uPSI_cyModalContainer,
936 uPSI_cyFlyingContainer;
937 uPSI_RegStr,
938 uPSI_HtmlHelpViewer;
939 unit uPSI_cyIniForm
940 unit uPSI_cyVirtualGrid;
941 uPSI_Profiler,
942 uPSI_BackgroundWorker,
943 uPSI_WavePlay,
944 uPSI_WaveTimer,
945 uPSI_WaveUtils;

SHA1: Win 3.9.9.96: 6DF0415E1645C98C2298DA0A3F613A016AD72EEE


****************************************************************
Release Notes maXbox 3.9.9.95 Mai 2014
****************************************************************
Oscilloscope V4, Mixer, 17 Units add, URLMon, Form properties+, mathmax

904 unit uPSI_U_HexView;
905 uPSI_UWavein4,
906 uPSI_AMixer,
907 uPSI_JvaScrollText,
908 uPSI_JvArrow,
909 unit uPSI_UrlMon;
910 unit U_Oscilloscope4;  //U_FFT
911 unit uPSI_U_Oscilloscope4; //TOscfrmMain;
912 unit uPSI_DFFUtils;  //DFF
913 unit uPSI_MathsLib;  
914 uPSI_UIntList;
915 uPSI_UGetParens;
916 unit uPSI_UGeometry;
917 unit uPSI_UAstronomy;
918 unit uPSI_UCardComponentV2;
919 unit uPSI_UTGraphSearch;
920 unit uPSI_UParser10;

SHA1: Win 3.9.9.95: A8BE7AD5B70ECAF9797C5C9E42A3CD40E903145F


****************************************************************
Release Notes maXbox 3.9.9.94 April 2014
****************************************************************
DLL Report, UML Tutor, 33 Units add, DRTable, Remote+, Cindy functions!

872 unit uPSI_Wwstr;
873 uPSI_DBLookup,
874 uPSI_Hotspot,
875 uPSI_HList; //History List
876 unit uPSI_DrTable;
877 uPSI_TConnect,
878 uPSI_DataBkr,
879 uPSI_HTTPIntr;
880 unit uPSI_Mathbox;
881 uPSI_cyIndy,
882 uPSI_cySysUtils,
883 uPSI_cyWinUtils,
884 uPSI_cyStrUtils,
885 uPSI_cyObjUtils,
886 uPSI_cyDateUtils,
887 uPSI_cyBDE,
888 uPSI_cyClasses,
889 uPSI_cyGraphics,  //3.9.9.94_2
890 unit uPSI_cyTypes;
891 uPSI_JvDateTimePicker,                     
892 uPSI_JvCreateProcess,                      
893 uPSI_JvEasterEgg,                          
894 uPSI_WinSvc,  //3.9.9.94_3                 
895 uPSI_SvcMgr                                
896 unit uPSI_JvPickDate;
897 unit uPSI_JvNotify;
898 uPSI_JvStrHlder
899 unit uPSI_JclNTFS2;
900 uPSI_Jcl8087 //math coprocessor
901 uPSI_JvAddPrinter
902 uPSI_JvCabFile
903 unit uPSI_JvDataEmbedded;


SHA1: Win 3.9.9.94: 746418954E790A1713A93FF786ABCB50097FCB59


****************************************************************
Release Notes maXbox 3.9.9.92 April 2014
****************************************************************
1 Report, 15 Units add, DBCtrls, Stream+, IRadio, Wininet

857 uPSI_VariantSymbolTable, //3.9.9.92
858 uPSI_udf_glob,
859 uPSI_TabGrid,
860 uPSI_JsDBTreeView,
861 uPSI_JsSendMail,
862 uPSI_dbTvRecordList,
863 uPSI_TreeVwEx,
864 uPSI_ECDataLink,
865 uPSI_dbTree,
866 uPSI_dbTreeCBox,
867 unit uPSI_Debug; //TfrmDebug
868 uPSI_TimeFncs;
869 uPSI_FileIntf,
870 uPSI_SockTransport,
871 unit uPSI_WinInet;

SHA1: Win 3.9.9.92: 61ECB8AF3FA0C72B6AA6DE8DA4A65E1C30F0EE6C


****************************************************************
Release Notes maXbox 3.9.9.91 March 2014
****************************************************************
2 Tutorials, 42 Units add, Synapse V40, LDAP, OpenSSL, AVScan

816 uPSI_TabNotBk;
817 uPSI_udwsfiler;
818 uPSI_synaip; //iputils
819 uPSI_synacode;
820 uPSI_synachar;
821 uPSI_synamisc;
822 uPSI_synaser;
823 uPSI_synaicnv;
824 uPSI_tlntsend;
825 uPSI_pingsend;
826 uPSI_blcksock;
827 uPSI_asn1util; //V2
828 uPSI_dnssend;
829 uPSI_clamsend;
830 uPSI_ldapsend;
831 uPSI_mimemess;
832 uPSI_slogsend;
833 uPSI_mimepart;
834 uPSI_mimeinln;
835 uPSI_ftpsend;
836 uPSI_ftptsend;
837 uPSI_httpsend;
838 uPSI_sntpsend;
839 uPSI_smtpsend;
840 uPSI_snmpsend;
841 uPSI_imapsend;
842 uPSI_pop3send;
843 uPSI_nntpsend;
844 uPSI_ssl_cryptlib;
845 uPSI_ssl_openssl;
846 uPSI_synhttp_daemon;
847 uPSI_NetWork;
848 uPSI_PingThread;
849 uPSI_JvThreadTimer;
850 unit uPSI_wwSystem;
851 unit uPSI_IdComponent;
852 unit uPSI_IdIOHandlerThrottle;
853 unit uPSI_Themes;
854 uPSI_StdStyleActnCtrls;
855 unit uPSI_UDDIHelper;
856 unit uPSI_IdIMAP4Server;


SHA1: Win 3.9.9.91: 8099E25F2508B262E909B76EDF7BB301AFFA1864


****************************************************************
Release Notes maXbox 3.9.9.88 March 2014
****************************************************************
2 Tutorials 30 Units add, VCL constructors, controls+, unit list

786 uPSI_FileUtil;
787 uPSI_changefind;
788 uPSI_cmdIntf;
789 uPSI_fservice;
790 uPSI_Keyboard;
791 uPSI_VRMLParser,
792 uPSI_GLFileVRML,
793 uPSI_Octree;
794 uPSI_GLPolyhedron,
795 uPSI_GLCrossPlatform;
796 uPSI_GLParticles;
797 uPSI_GLNavigator;
798 uPSI_GLStarRecord;
799 uPSI_TGA;
800 uPSI_GLCanvas;
801 uPSI_GeometryBB;
802 uPSI_GeometryCoordinates;
803 uPSI_VectorGeometry;
804 uPSI_BumpMapping;
805 uPSI_GLTextureCombiners;
806 uPSI_GLVectorFileObjects;
807 uPSI_IMM;
808 uPSI_CategoryButtons;
809 uPSI_ButtonGroup;
810 uPSI_DbExcept;
811 uPSI_AxCtrls;
812 uPSI_GL_actorUnit1;
813 uPSI_StdVCL;
814 unit CurvesAndSurfaces;
815 uPSI_DataAwareMain;

SHA1: Win 3.9.9.88: 119533C0725A9B9B2919849759AA2F6298EBFF28


****************************************************************
Release Notes maXbox 3.9.9.86 February 2014
****************************************************************
PEP - Pascal Educ Program , FBX Lib, psAPI, SMS Cell Module, OpenGL, Borland Tools

751 unit uPSI_PsAPI;
752 uPSI_ovcuser;
753 uPSI_ovcurl;
754 uPSI_ovcvlb;
755 uPSI_ovccolor;
756 uPSI_ALFBXLib,
757 uPSI_ovcmeter;
758 uPSI_ovcpeakm;
759 uPSI_O32BGSty;
760 uPSI_ovcBidi;
761 uPSI_ovctcary;
762 uPSI_DXPUtils;
763 uPSI_ALMultiPartBaseParser;
764 uPSI_ALMultiPartAlternativeParser;
765 uPSI_ALPOP3Client;
766 uPSI_SmallUtils;
767 uPSI_MakeApp;
768 uPSI_O32MouseMon;
769 uPSI_OvcCache;
770 unit uPSI_ovccalc;  //widget
771 uPSI_Joystick,
772 uPSI_ScreenSaver;
773 uPSI_XCollection,
774 uPSI_Polynomials,
775 uPSI_PersistentClasses, //9.86
776 uPSI_VectorLists;
777 uPSI_XOpenGL,
778 uPSI_MeshUtils;
779 unit uPSI_JclSysUtils;
780 unit uPSI_JclBorlandTools;
781 unit JclFileUtils_max;
782 uPSI_AfDataControls,
783 uPSI_GLSilhouette,
784 uPSI_JclSysUtils_class;
785 uPSI_JclFileUtils_class;

SHA1: Win 3.9.9.86: D44BBA8FA3AA1A6B1BF498DCEFE2068C685DBFC6

****************************************************************
Release Notes maXbox 3.9.9.85 January 2014
****************************************************************
PEP - Pascal Education Program , GSM Module, CGI, PHP Runner
add 42 + 30  (72 units), memcached database, autobookmark, Alcinoe PAC, IPC Lib 
Orpheus PAC, AsyncFree Library, advapi32 samples, FirebirdExp+MySQL units

676 uPSI_DepWalkUtils;
677 uPSI_OptionsFrm;
678 unit yuvconverts;
679 uPSI_JvPropAutoSave;
680 uPSI_AclAPI;
681 uPSI_AviCap;
682 uPSI_ALAVLBinaryTree;
683 uPSI_ALFcnMisc;
684 uPSI_ALStringList;
685 uPSI_ALQuickSortList;
686 uPSI_ALStaticText;
687 uPSI_ALJSONDoc;
688 uPSI_ALGSMComm;
689 uPSI_ALWindows;
690 uPSI_ALMultiPartFormDataParser;
691 uPSI_ALHttpCommon;
692 uPSI_ALWebSpider,
693 uPSI_ALHttpClient;
694 uPSI_ALFcnHTML;
695 uPSI_ALFTPClient;
696 uPSI_ALInternetMessageCommon;
697 uPSI_ALWininetHttpClient;
698 uPSI_ALWinInetFTPClient;
699 uPSI_ALWinHttpWrapper;
700 uPSI_ALWinHttpClient;
701 uPSI_ALFcnWinSock;
702 uPSI_ALFcnSQL;
703 uPSI_ALFcnCGI;
704 uPSI_ALFcnExecute;
705 uPSI_ALFcnFile;
706 uPSI_ALFcnMime;
707 uPSI_ALPhpRunner;
708 uPSI_ALGraphic;
709 uPSI_ALIniFiles;
710 uPSI_ALMemCachedClient;
711 unit uPSI_MyGrids;
712 uPSI_ALMultiPartMixedParser,
713 uPSI_ALSMTPClient,
714 uPSI_ALNNTPClient;
715 uPSI_ALHintBalloon;
716 uPSI_ALXmlDoc;
717 uPSI_IPCThrd;
718 uPSI_MonForm;
719 unit uPSI_TeCanvas;
720 unit uPSI_Ovcmisc;
721 unit uPSI_ovcfiler;
722 unit uPSI_ovcstate;
723 unit uPSI_ovccoco;
724 unit uPSI_ovcrvexp;
725 unit uPSI_OvcFormatSettings;
726 unit uPSI_OvcUtils;
727 unit uPSI_ovcstore;
728 unit uPSI_ovcstr;
729 unit uPSI_ovcmru;
730 unit uPSI_ovccmd;
731 unit uPSI_ovctimer;
732 unit uPSI_ovcintl;
733 uPSI_AfCircularBuffer;
734 uPSI_AfUtils;
735 uPSI_AfSafeSync;
736 uPSI_AfComPortCore;
737 uPSI_AfComPort;
738 uPSI_AfPortControls;
739 uPSI_AfDataDispatcher;
740 uPSI_AfViewers;
741 uPSI_AfDataTerminal;
742 uPSI_SimplePortMain;
743 unit uPSI_ovcclock;
744 unit uPSI_o32intlst;
745 unit uPSI_o32ledlabel;
746 unit uPSI_AlMySqlClient;
747 unit uPSI_ALFBXClient;
748 unit uPSI_ALFcnSQL;
749 unit uPSI_AsyncTimer;
750 unit uPSI_ApplicationFileIO;

SHA1: Win 3.9.9.85: E559F32B41320182CF44AC4DBAFF6F9B9579B120

****************************************************************
Release Notes maXbox 3.9.9.82 January 2014
****************************************************************
IBUtils Refactor, InterBase Package, DotNet Routines (JvExControls)
add 31 units, mX4 Introduction Paper, more Socket&Streams, ShortString Routines
7% performance gain (hot spot profiling), Perpetual Logger, Pure Code Add

645  uPSI_IBX;
646  uPSI_IWDBCommon;
647  uPSI_SortGrid;
648  uPSI_IB;
649  uPSI_IBScript;
650  uPSI_JvCSVBaseControls;
651  uPSI_Jvg3DColors;
652  uPSI_JvHLEditor;  //beta
653  uPSI_JvShellHook;
654  uPSI_DBCommon2
655  uPSI_JvSHFileOperation;
656  uPSI_uFilexport;
657  uPSI_JvDialogs;
658  uPSI_JvDBTreeView;
659  uPSI_JvDBUltimGrid;
660  uPSI_JvDBQueryParamsForm;
661  uPSI_JvExControls;
662  uPSI_JvBDEMemTable;
663  uPSI_JvCommStatus;
664  uPSI_JvMailSlots2;
665  uPSI_JvgWinMask;
666  uPSI_StEclpse;
667  uPSI_StMime;
668  uPSI_StList;
669  uPSI_StMerge;
670  uPSI_StStrS;
671 uPSI_StTree,
672 uPSI_StVArr;
673 uPSI_StRegIni;
674 unit uPSI_urkf;
675 unit uPSI_usvd;

SHA1: Win 3.9.9.82: A8D32978AD68F73EE3B7D688EFD3915E69FBAD77

****************************************************************
Release Notes maXbox 3.9.9.81 December 2013
****************************************************************
Reversi, GOL, bugfixing, 8 more units, Tutorial 24 Clean Code
Tutorial 18_3 RGB LED, OpenGL Geometry, maxpix, statictext
OpenGL Game Demo: ..Options/Add Ons/Reversi   

637  uPSI_DbxSocketChannelNative,
638  uPSI_DbxDataGenerator,
639  uPSI_DBXClient;
640  uPSI_IdLogEvent;
641  uPSI_Reversi;
642  uPSI_Geometry;
643  uPSI_IdSMTPServer;
644  uPSI_Textures;

SHA1 Win 3.9.9.81: FFF0205DEF64C8F7F714C1DAF382F2E12522BC83

****************************************************************
Release Notes maXbox 3.9.9.80 November 2013
****************************************************************
SPS Utils WDOS, Plc BitBus (PetriNet), 54 more units
maXbox the script studio, WebUtils, Pipes&Filters 
emax layers: system-package-component-unit-class-function-block
HighPrecision Timers,  Indy Package6, AutoDetect, UltraForms

582 unit uPSI_IdRawBase;
583 unit uPSI_IdNTLM;
584 unit uPSI_IdNNTP;
585 unit uPSI_usniffer; //PortScanForm
586 unit uPSI_IdCoderMIME;
587 unit uPSI_IdCoderUUE;
588 unit uPSI_IdCoderXXE;
589 unit uPSI_IdCoder3to4;
590 unit uPSI_IdCookie;
591 unit uPSI_IdCookieManager;
592 unit uPSI_WDosSocketUtils;
593 unit uPSI_WDosPlcUtils;
594 unit uPSI_WDosPorts;
595 unit uPSI_WDosResolvers;
596 unit uPSI_WDosTimers;
597 unit uPSI_WDosPlcs;
598 unit uPSI_WDosPneumatics;
599 unit uPSI_IdFingerServer;
600 unit uPSI_IdDNSResolver;
601 unit uPSI_IdHTTPWebBrokerBridge;
602 unit uPSI_IdIntercept;
603 unit uPSI_IdIPMCastBase;
604 unit uPSI_IdLogBase;
605 unit uPSI_IdIOHandlerStream;
606 unit uPSI_IdMappedPortUDP;
607 unit uPSI_IdQOTDUDPServer;
608 unit uPSI_IdQOTDUDP;
609 unit uPSI_IdSysLog;
610 unit uPSI_IdSysLogServer;
611 unit uPSI_IdSysLogMessage;
612 unit uPSI_IdTimeServer;
613 unit uPSI_IdTimeUDP;
614 unit uPSI_IdTimeUDPServer;
615 unit uPSI_IdUserAccounts;
616 unit uPSI_TextUtils;
617 unit uPSI_MandelbrotEngine;
618 unit uPSI_delphi_arduino_Unit1;
619 unit uPSI_DTDSchema2;
620 unit uPSI_fplotMain;
621 unit uPSI_FindFileIter;
622 unit uPSI_PppState;  (JclStrHashMap)
623 unit uPSI_PppParser;
624 unit uPSI_PppLexer;
625 unit uPSI_PCharUtils;
626 unit uPSI_uJSON;
627 unit uPSI_JclStrHashMap;
628 unit uPSI_JclHookExcept;
629 unit uPSI_EncdDecd;
630 unit uPSI_SockAppReg;
631 unit uPSI_PJFileHandle;
632 unit uPSI_PJEnvVars;
633 unit uPSI_PJPipe;
634 unit uPSI_PJPipeFilters;
635 unit uPSI_PJConsoleApp;
636 unit uPSI_UConsoleAppEx;

SHA1 Win 3.9.9.80: 654D46E6146CA04AFE2575B77FE2E51F6618BE9F

****************************************************************
Release Notes maXbox 3.9.9.60 November 2013
****************************************************************
Tool Section, SOAP Tester, Hot Log Logger2, TCPPortScan, 39 more Units
BOLD Package, Indy Package5, maTRIx. matheMAX, JSON, CSS

538 unit uPSI_frmExportMain;                   //Synedit
539 unit uPSI_SynDBEdit;
540 unit uPSI_SynEditWildcardSearch;
541 unit uPSI_BoldComUtils;
542 unit uPSI_BoldIsoDateTime;
543 unit uPSI_BoldGUIDUtils; //inCOMUtils
544 unit uPSI_BoldXMLRequests;
545 unit uPSI_BoldStringList;
546 unit uPSI_BoldFileHandler;
547 unit uPSI_BoldContainers;
548 unit uPSI_BoldQueryUserDlg;
549 unit uPSI_BoldWinINet;
550 unit uPSI_BoldQueue;
551 unit uPSI_JvPcx;
552 unit uPSI_IdWhois;
553 unit uPSI_IdWhoIsServer;
554 unit uPSI_IdGopher;
555 unit uPSI_IdDateTimeStamp;
556 unit uPSI_IdDayTimeServer;
557 unit uPSI_IdDayTimeUDP;
558 unit uPSI_IdDayTimeUDPServer;
559 unit uPSI_IdDICTServer;
560 unit uPSI_IdDiscardServer;
561 unit uPSI_IdDiscardUDPServer;
562 unit uPSI_IdMappedFTP;
563 unit uPSI_IdMappedPortTCP;
564 unit uPSI_IdGopherServer;
565 unit uPSI_IdQotdServer;
566 unit uPSI_JvRgbToHtml;
567 unit uPSI_JvRemLog,
568 unit uPSI_JvSysComp;
569 unit uPSI_JvTMTL;
570 unit uPSI_JvWinampAPI;
571 unit uPSI_MSysUtils;
572 unit uPSI_ESBMaths;
573 unit uPSI_ESBMaths2;
574 unit uPSI_uLkJSON;
575 unit uPSI_ZURL;  //Zeos
576 unit uPSI_ZSysUtils;
577 lib unaUtils internals
578 unit uPSI_ZMatchPattern;
579 unit uPSI_ZClasses;
580 unit uPSI_ZCollections;
581 unit uPSI_ZEncoding;

SHA1 Win 3.9.9.60: AB8E0030A965B46047AB34F5A24D5B016E04D7AB
(4371 files)

****************************************************************
Release Notes maXbox 3.9.9.20 October 2013
****************************************************************
RestartDialog, RTF, SQL Scanner, RichEdit, Logger, 16 more Units
fireboX browser kit, maXtex docu kit, maXpaint draw kit

521 unit uPSI_ulambert;
522 unit uPSI_ucholesk;
523 unit uPSI_SimpleDS;
524 unit uPSI_DBXSqlScanner;
525 unit uPSI_DBXMetaDataUtil;
526 unit uPSI_Chart;
527 unit uPSI_TeeProcs;
528 lib mXBDEUtils;
529 unit uPSI_MDIEdit; //richedit
530 unit uPSI_CopyPrsr;
531 unit uPSI_SockApp;
532 unit uPSI_AppEvnts;
533 unit uPSI_ExtActns;
534 unit uPSI_TeEngine;
535 unit uPSI_CoolMain; //browser
536 unit uPSI_StCRC;
537 unit uPSI_StDecMth2;

SHA1 Win 3.9.9.20:  D2D826D94B3F21F1F63CDD3D99996E90AA88633F


News in Detail:
>>>Menu
- Context Menu add Richedit <Ctrl Alt R>
- Menu Help, new Config File / Config Update opener
- Menu Help, ToDo List
- Compile HotKey <Alt C> and F9

>>>Options Add-Ons
- Easy Browser 
- ADO SQL Workbench
- new examples 390 - 402, add 15 bitmap ressources
- VERSIONCHECK in ini-file
- Types List in maxbox_types.pdf

>>>Editor /IDE
- check Overwrite prompt Scripts with same name save
- Indent / Unindent with Tab 3 Steps set
- checks if modified /changed file on menu File New and Clear Editor
- Short Key Manager

>>>mXFramework
- Log file of last instance running: maxboxlog.log
- New Form Template Library: Browser and Richedit
- Assign() in more classes added
- FindComponent fixed
- Full Text Finder V3 dblclick open File and Open/Save Dialog



****************************************************************
Release Notes maXbox 3.9.9.18 October 2013
****************************************************************
Gamma Functions, IndyPackage4, HotLog Threadable, FormTemplateLibrary FTL
Nonlinear regression, ADO Workbench Addon, Assign fixing, IntfNavigator fixing, Applet
30 more Units preCompiled, QRCode Indy Service, add Cfunction like CFill or SRand

492 unit uPSI_JclMath_Class;                    //JCL RTL
493 unit ugamdist; //Gamma function	//DMath
494 unit uibeta, ucorrel; //IBeta
495 unit uPSI_SRMgr;
496 unit uPSI_HotLog;
497 unit uPSI_DebugBox;  //FTL
498 unit uPSI_ustrings;
499 unit uPSI_uregtest;
500 unit uPSI_usimplex;
501 unit uPSI_uhyper;
502 unit uPSI_IdHL7;
503 unit uPSI_IdIPMCastBase,
504 unit uPSI_IdIPMCastServer;
505 unit uPSI_IdIPMCastClient;
506 unit uPSI_unlfit; //nlregression
507 unit uPSI_IdRawHeaders;
508 unit uPSI_IdRawClient;
509 unit uPSI_IdRawFunctions;
510 unit uPSI_IdTCPStream;
511 unit uPSI_IdSNPP;
512 unit uPSI_St2DBarC;
513 unit uPSI_ImageWin;  //FTL
514 unit uPSI_CustomDrawTreeView; //FTL
515 unit uPSI_GraphWin;  //FTL
516 unit uPSI_actionMain;  //FTL
517 unit uPSI_StSpawn;
518 unit uPSI_CtlPanel;
519 unit uPSI_IdLPR;
520 unit uPSI_SockRequestInterpreter;

//Provider=MSDASQL;DSN=mX3base;Uid=sa;Pwd=admin

SHA1 Win 3.9.9.18:  1F9AC60552ABDA3D25E4F4A2646C791B5D93303E

****************************************************************
Release Notes maXbox 3.9.9.16 September 2013
****************************************************************
Routines for LaTeX/PS, Utils Addon, Indy Package3, TAR Archive, @Callbacks
First LCL of Lazarus, CmdLine API, ToDo List, 50 more Units preCompiled
QRCode Service, more CFunctions like CDateTime of Synapse Utils

443 unit uPSI_IdTelnet;
444 unit uPSI_IdTelnetServer,
445 unit uPSI_IdEcho,
446 unit uPSI_IdEchoServer,
447 unit uPSI_IdEchoUDP,
448 unit uPSI_IdEchoUDPServer,
449 unit uPSI_IdSocks,
450 unit uPSI_IdAntiFreezeBase;
451 unit uPSI_IdHostnameServer;
452 unit uPSI_IdTunnelCommon,
453 unit uPSI_IdTunnelMaster,
454 unit uPSI_IdTunnelSlave,
455 unit uPSI_IdRSH,
456 unit uPSI_IdRSHServer,
457 unit uPSI_Spring_Cryptography_Utils;
458 unit uPSI_MapReader,
459 unit uPSI_LibTar,
460 unit uPSI_IdStack;
461 unit uPSI_IdBlockCipherIntercept;
462 unit uPSI_IdChargenServer;
463 unit uPSI_IdFTPServer,
464 unit uPSI_IdException,
465 unit uPSI_utexplot;
466 unit uPSI_uwinstr;
467 unit uPSI_VarRecUtils;
468 unit uPSI_JvStringListToHtml,
469 unit uPSI_JvStringHolder,
470 unit uPSI_IdCoder;
471 unit uPSI_SynHighlighterDfm;
472 unit uHighlighterProcs; in 471
473 unit uPSI_LazFileUtils,            
474 unit uPSI_IDECmdLine;                 
475 unit uPSI_lazMasks;           
476 unit uPSI_ip_misc;
477 unit uPSI_Barcode;
478 unit uPSI_SimpleXML;
479 unit uPSI_JclIniFiles;
480 unit uPSI_D2XXUnit;  {$X-}
481 unit uPSI_JclDateTime;
482 unit uPSI_JclEDI;
483 unit uPSI_JclMiscel2;
484 unit uPSI_JclValidation;
485 unit uPSI_JclAnsiStrings; {-PString}
486 unit uPSI_SynEditMiscProcs2;
487 unit uPSI_JclStreams;
488 unit uPSI_QRCode;
489 unit uPSI_BlockSocket;
490 unit uPSI_Masks,
491 unit uPSI_synautil;   //Synapse


SHA1 Win 3.9.9.16: FDBD968F03B416712E4151A2E720CD24950D7A5A


****************************************************************
Release Notes maXbox 3.9.9.7 September 2013
****************************************************************
DCOM, MDAC, MIDI, TLS support, Posmarks, Utils Addon

431 unit uPSI_JclCOM;
432 unit uPSI_GR32_Math;
433 unit uPSI_GR32_LowLevel;
434 unit uPSI_SimpleHl;
435 unit uPSI_GR32_Filters,
436 unit uPSI_GR32_VectorMaps;
437 unit uPSI_cXMLFunctions;
438 unit uPSI_JvTimer;
439 unit uPSI_cHTTPUtils;
440 unit uPSI_cTLSUtils;
441 unit uPSI_JclGraphics;
442 unit uPSI_JclSynch;

SHA1 Win 3.9.9.7: 774BBDAE21BDF92FBD76E9BA7C7F59CF8D69EECC


****************************************************************
Release Notes maXbox 3.9.9.6 August 2013
****************************************************************
New Macros, Sendmail (instant email), DevCUnits, Tetris Addon

421 unit uPSI_FileAssocs;
422 unit uPSI_devFileMonitorX;
423 unit uPSI_devrun,
424 unit uPSI_devExec;
425 unit uPSI_oysUtils;
426 unit uPSI_DosCommand;
427 unit uPSI_CppTokenizer;
428 unit uPSI_JvHLParser;
429 unit uPSI_JclMapi;
430 unit uPSI_JclShell;

SHA1 Win 3.9.9.6: 76ECD732E1531108B35457D56282B0BBBBB20BAA


****************************************************************
Release Notes maXbox 3.9.9.5 August 2013
****************************************************************
StBarCode Lib, StreamReaderClass, BarCode Package, Astro Package
more ShellAPI, add 32 more units, Simulated Annealing, GenAlgo
REST Test Lib, Multilang Component, Forth Interpreter

389 unit uPSI_XmlVerySimple;
390 unit uPSI_Services;                        //ExtPascal
391 unit uPSI_ExtPascalUtils;
392 unit uPSI_SocketsDelphi;
393 unit uPSI_StBarC;
394 unit uPSI_StDbBarC;
395 unit uPSI_StBarPN;
396 unit uPSI_StDbPNBC;
397 unit uPSI_StDb2DBC;
398 unit uPSI_StMoney;
399 unit uPSI_JvForth;
400 unit uPSI_RestRequest;
401 unit uPSI_HttpRESTConnectionIndy;
402 unit uPSI_JvXmlDatabase; //update
403 unit uPSI_StAstro;
404 unit uPSI_StSort;
405 unit uPSI_StDate;
406 unit uPSI_StDateSt;
407 unit uPSI_StBase;
408 unit uPSI_StVInfo;
409 unit uPSI_JvBrowseFolder;
410 unit uPSI_JvBoxProcs;
411 unit uPSI_urandom; (unit uranuvag;)
412 unit uPSI_usimann; (unit ugenalg;)
413 unit uPSI_JvHighlighter;
414 unit uPSI_Diff;
415 unit uPSI_SpringWinAPI;
416 unit uPSI_StBits;
417 unit uPSI_TomDBQue;
418 unit uPSI_MultilangTranslator;
419 unit uPSI_HyperLabel;
420 unit uPSI_Starter;

SHA1 Win 3.9.9.5: EC71940E7F952262522A7DB91B2BF9762F14A8C6


http://fundementals.sourceforge.net/dl.html

News in Detail:
>>>Menu
  new in menu Close/ Shortcut <Ctrl Q>
- Active Line Color <Ctrl H>  (also in Context Menu)
- Context Menu add new Bookmark #5
- Menu Output, new Style Output/Sky Style
- Context Menu, Count Words Metric now with F11
- Context Menu, Enlarge Gutter 
- Compile HotKey <Alt C>

>>>Macro
- new Macro set: #sign  (name, machine name, timestamp)
- new Macro set: #tech  (performance, threads, ip, time)
- MACRO=Y //put macros in your source header file

>>>Options Add-Ons
- FractalDemo3 with BringToFront
- Dll Spy shows simple functions of a DLL
- new examples 375 - 380, add 10 bitmap ressources
- VERSIONCHECK in ini-file
- Short Help in maxbox_functions_all.pdf

>>>Editor /IDE
- Program/Information isWin64 check /ThreadCount
- PrintFW (PrintF with write/writeln)
- GetSystemPath (Folder: Integer) : TFilename ;
- PrintFW('%.3f  ',[180+90*Rrand]);  write in line
- Statusbar in 3 panels[1-3] , [2]: Row, Col, Sel [3] Threds Count
- deprecated Dbl Click on Word Count in Context Menu (search words with highlightning found)
- Click and mark to drag a bookmark
- Syntax Check <F2> will result in default highlighter (Pascal)
- checks if modified /changed file on menu File New and Clear Editor
- memo1.setfocus after navigate

>>>mXFramework
- QueryPerformanceCounter fixed
- QueryPerformanceFrequency fixed
- TTreeView TTreeNodes fixed
- ThreadCount fixed
-  writeln(GetEnvironmentString);   



****************************************************************
Release Notes maXbox 3.9.9.1 July 2013
****************************************************************
additional SynEdit API, isKeyPressed Routine, Bookmarks, OpenToolsAPI Catalog (OTAC)
Class TMonitor, Configuration Tutorial maxbox_starter25.pdf, Chess.dll Game
arduino map() function, PMRandom Generator

Hint: If you code a loop till keypressed use function: isKeyPressed;

Add Units:
372 unit uPSI_SynHighlighterAny;   
373 unit uPSI_SynEditKeyCmds;      
374 unit uPSI_SynEditMiscProcs,    
375 unit uPSI_SynEditKbdHandler    
376 unit uPSI_JvAppInst,           
377 unit uPSI_JvAppEvent;          
378 unit uPSI_JvAppCommand;        
379 unit uPSI_JvAnimTitle;         
380 unit uPSI_JvAnimatedImage;     
381 unit uPSI_SynEditExport;       
382 unit uPSI_SynExportHTML;       
383 unit uPSI_SynExportRTF;        
384 unit uPSI_SynEditSearch;       
385 unit uPSI_fMain_back           
386 unit uPSI_JvZoom;              
387 unit uPSI_PMrand;              
388 unit uPSI_JvSticker;           

SHA1 Win 3.9.9.1: CEEBEF784CAC67F407CF81581E0CDDB6653F8D40

News in Detail:
>>>Menu
  new in menu Close/ Shortcut <Ctrl Q>
- Active Line Color <Ctrl H>  (also in Context Menu)
- Context Menu add 4 Bookmarks Menu/Editor Form Options
- Menu Output, new Style Output/Sky Style
- Context Menu, Indent-Unindent menu, Undo-Redo

>>>Macro
- new Macro set: #sign  (name, machine name, timestamp)
- MACRO=Y //put macros in your source header file

>>>Options Add-Ons
- FractalDemo3 with Matrix Fractal and Performance Test
- Dll Spy shows simple functions of a DLL
- new examples 372 - 375

>>>Editor /IDE
- Default ActiveLineColor (clWebFloralWhite)
- Statusbar in 3 panels[1-3] , [2]: Row, Col, Sel [3] Threds Count
- Dbl Click on Word in Editor search amount of words with highlightning
- Dbl Click on Bookmarks to delete
- Click and mark to drag a bookmark
- Syntax Check <F2> will result in default highlighter (Pascal)
- checks if modified /changed file on menu File New and Clear Editor


****************************************************************
Release Notes maXbox 3.9.8.9 June 2013
****************************************************************
SynEdit API, Macros, Macro Recorder, DLL Spy, Configuration Tutorial maxbox_starter25.pdf
IDE Reflection API, Session Service Shell S3

Please Note: if a script doesnt run well check switch menu: On/Off Options/ProcessMessages!

Add Units:
362 unit uPSI_SynEdit;                  
363 unit uPSI_SynEditTypes;       
364 unit uPSI_SynMacroRecorder; 
365 unit uPSI_LongIntList;               
366 unit uPSI_devCutils;   
367 unit uPSI_SynEditMiscClasses;
368 unit uPSI_SynEditRegexSearch;
369 unit uPSI_SynEditHighlighter;
370 unit uPSI_SynHighlighterPas;         
371 unit uPSI_JvSearchFiles;

SHA1 Win 3.9.8.9:  CD9BAB3E6B6E25827AE237CC4F8E4FEF658058A8

News in Detail:
>>>Menu
  new in menu Debug/Goto Line <Ctrl G>
- Active Line Color <Ctrl H>  (also in Context Menu)
- Help/Configuration (math path)-;
- Help/Config File open access
- File/Print Preview 
- Code Search with <Ctrl F3>

>>>Macro
- Macro set the macros #name, #date, #host, #path, #file, #head#, see Tutorial maxbox_starter25.pdf
- Macro Help in Functions List, line 10186 
- ini-file Macro //  ini-file Navigator
- macro information in menu Program/Information
MACRO=Y //put macros in your source header file
NAVIGATOR=Y //set the nav listbox at the right side of editor

>>>Options Add-Ons
- MP3 Player with list function duallist player
- Dll Spy shows simple functions of a DLL
- new examples 365 - 371

>>>Editor /IDE
- Uri Active Links Context Menu Editor Size Options-URI Links Click <Ctrl W>
- Close Highlighter to simple text with URI links, toogle switch back   <Ctrl W>
- new Statusbar in 3 panels[1-3] , right side S for Save and M! for Modified
- syntax highlighter for asm >better color silver> end //assembler code
- faster Code Search Engine of .pas and .txt files full text Help/Code Search 
- Dbl Click on Word in Editor search amount of words 
- SynEdit - SynMemo API open tools for coding in bootscript or macros!
- Close by Esc bug solved.

****************************************************************
Release Notes maXbox 3.9.8.8 Mai 2013
****************************************************************
Compress-Decompress Zip, Services Tutorial22, Synopse framework, PFDLib

350 unit uPSI_JvNTEventLog;
351 unit uPSI_ShellZipTool;
352 unit uPSI_JvJoystick;
353 unit uPSI_JvMailSlots;
354 unit uPSI_JclComplex;
355 unit uPSI_SynPdf;
356 unit uPSI_Registry;
357 unit uPSI_TlHelp32;
358 unit uPSI_JclRegistry;
359 unit uPSI_JvAirBrush;
360 unit uPSI_mORMotReport;
361 unit uPSI_JclLocales;

SHA1 Win 3.9.8.8:  CB7D64ACF0D65D8D18FF668D7556B263C8BF0082

****************************************************************
Release Notes maXbox 3.9.8.6 April 2013
****************************************************************
Halt-Stop Program in Menu, WebServer2, Stop Event Recompile,
Conversion Routines, Prebuild Forms, more RCData, DebugOutString
CodeSearchEngine to search code patterns in /examples <Ctrl F3>
JvChart - TJvChart Component - 2009 Public, mXGames, JvgXMLSerializer, TJvPaintFX

297 unit uPSI_JvFloatEdit;    //3.9.8 (1258 Objects)
298 unit uPSI_JvDirFrm;
299 unit uPSI_JvDualList;
300 unit uPSI_JvSwitch;
301 unit uPSI_JvTimerLst;
302 unit uPSI_JvMemTable;
303 unit uPSI_JvObjStr;
304 unit uPSI_StLArr;
305 unit uPSI_StWmDCpy;
306 unit uPSI_StText;
307 unit uPSI_StNTLog;
308 unit uPSI_xrtl_math_Integer;
309 unit uPSI_JvImagPrvw;
310 unit uPSI_JvFormPatch;
311 unit uPSI_JvPicClip;
312 unit uPSI_JvDataConv;
313 unit uPSI_JvCpuUsage; 
314 unit uPSI_JclUnitConv_mX2;
315 unit JvDualListForm;
316 unit uPSI_JvCpuUsage2;
317 unit uPSI_JvParserForm;
318 unit uPSI_JvJanTreeView;
319  unit uPSI_JvTransLED;
320 unit uPSI_JvPlaylist;
321 unit uPSI_JvFormAutoSize;
322 unit uPSI_JvYearGridEditForm;
323 unit uPSI_JvMarkupCommon;
324 unit uPSI_JvChart;
325 unit uPSI_JvXPCore; 
326 unit uPSI_JvXPCoreUtils;
327 unit uPSI_StatsClasses;
328 unit uPSI_ExtCtrls2;
329 unit uPSI_JvUrlGrabbers;
330 unit uPSI_JvXmlTree;
331 unit uPSI_JvWavePlayer;
332 unit uPSI_JvUnicodeCanvas;
333 unit uPSI_JvTFUtils;
334 unit uPSI_IdServerIOHandler;
335 unit uPSI_IdServerIOHandlerSocket;
336 unit uPSI_IdMessageCoder;
337 unit uPSI_IdMessageCoderMIME;
338 unit uPSI_IdMIMETypes;
339 unit uPSI_JvConverter;
340 unit uPSI_JvCsvParse;
341 unit uPSI_uMath; unit uPSI_ugamma;
342 unit uPSI_ExcelExport; (Native: TJsExcelExport)
343 unit uPSI_JvDBGridExport;
344 unit uPSI_JvgExport;
345 unit uPSI_JvSerialMaker;
346 unit uPSI_JvWin32;
347 unit uPSI_JvPaintFX;
348 unit uPSI_JvOracleDataSet; (beta)
349 unit uPSI_JvValidators; (preview)
350 unit uPSI_JvNTEventLog;

SHA1 Win 3.9.8.6:  F53090C44C7C8224A08ED6321A30EF22D5DC6EA2

****************************************************************
Release Notes maXbox 3.9.7.5 February 2013
****************************************************************
SimLogBox Addon, Bugfixes
add Ressources & Bitmaps, PEImage Forensic, add Units:

285 unit uPSI_IdRFCReply;
286 unit uPSI_IdIdent;
287 unit uPSI_IdIdentServer;
288 unit uPSI_JvPatchFile;
289 unit uPSI_StNetPfm;
290 unit uPSI_StNet;
291 unit uPSI_JclPeImage;
292 unit uPSI_JclPrint;
293 unit uPSI_JclMime;
294 unit uPSI_JvRichEdit;
295 unit uPSI_JvDBRichEd;
296 unit uPSI_JvDice;

SHA1 Win 3.9.7.5: 636B8937BCC03F2E38952E13CFD4C46C31AAF44C

GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

****************************************************************
Release Notes maXbox 3.9.7.4 January 2013
****************************************************************
SimLogicBox Package
PerformanceTester, InfoControl, MIDI
Added Units:
271 unit uPSI_JclMIDI;
272 unit uPSI_JclWinMidi;
273 unit uPSI_JclNTFS;
274 unit uPSI_JclAppInst;
275 unit uPSI_JvRle;
276 unit uPSI_JvRas32;
277 unit uPSI_JvImageDrawThread,
278 unit uPSI_JvImageWindow,
279 unit uPSI_JvTransparentForm;
280 unit uPSI_JvWinDialogs;
281 uPSI_JvSimLogic,
282 uPSI_JvSimIndicator,
283 uPSI_JvSimPID,
284 uPSI_JvSimPIDLinker,

SHA1 Win 3.9.7.4: ADEE0F6CC0B790A1B5E6C3E01AE39B486D651EFF

****************************************************************
Release Notes maXbox 3.9.7.1 December 2012
****************************************************************
FullText Finder2
IntfNavigator2
Graphics.pas with Assign()
Query by Example
JProfiler

247 unit uPSI_CPortMonitor;
248 unit uPSI_StIniStm;
249 unit uPSI_GR32_ExtImage;
250 unit uPSI_GR32_OrdinalMaps;
251 unit uPSI_GR32_Rasterizers;
252 unit uPSI_xrtl_util_Exception;
253 unit uPSI_xrtl_util_Value;
254 unit uPSI_xrtl_util_Compare;
255 unit uPSI_FlatSB;
256 unit uPSI_JvAnalogClock;
257 unit uPSI_JvAlarms;
258 unit uPSI_JvSQLS;
259 unit uPSI_JvDBSecur;
260 unit uPSI_JvDBQBE;
261 unit uPSI_JvStarfield;
262 unit uPSI_JVCLMiscal;
263 unit uPSI_JvProfiler32;
264 unit uPSI_JvDirectories,
265 unit uPSI_JclSchedule,
266 unit uPSI_JclSvcCtrl,
267 unit uPSI_JvSoundControl,
268 unit uPSI_JvBDESQLScript,
269 unit uPSI_JvgDigits,
270 unit uPSI_ImgList; //TCustomImageList


SHA1 Win 3.9.7.1: F04D41D8A402AD217941AF635DCE2690A9A8980C


****************************************************************
Release Notes maXbox 3.9.6.4 December 2012
****************************************************************
Tutorial 19 WinCOM with Arduino
Tutorial 20 RegularExpressions Coding
Script History to 9 Files
WebServer light ../Options/Addons/WebServer

231 unit uPSI_xrtl_util_COMCat;
232 unit uPSI_xrtl_util_StrUtils;
233 unit uPSI_xrtl_util_VariantUtils;
234 unit uPSI_xrtl_util_FileUtils;
235 unit xrtl_util_Compat;
236 unit uPSI_OleAuto;
237 unit uPSI_xrtl_util_COMUtils;
238 unit uPSI_CmAdmCtl;
239 unit uPSI_ValEdit2;
240 unit uPSI_GR32;  //Graphics32
241 unit uPSI_GR32_Image;
242 uPSI_xrtl_util_TimeUtils;
243 uPSI_xrtl_util_TimeZone;
244 uPSI_xrtl_util_TimeStamp;
245 uPSI_xrtl_util_Map;
246 uPSI_xrtl_util_Set;

SHA1 Win 3.9.6.4: C3E0D8BCC662EAC5DEC8396B46085A548818FFB2

****************************************************************
Release Notes maXbox 3.9.6.3 November 2012
****************************************************************
DMath DLL included incl. Demos
Interface Navigator menu/View/Intf Navigator
Unit Explorer menu/Debug/Units Explorer
EKON 16 Slides ..\maxbox3\docs\utils
Direct Excel Export maXcel

203 unit uPSI_utypes;  //for DMath.DLL
204 unit uPSI_ShellAPI;
205 unit uPSI_IdRemoteCMDClient;
206 unit uPSI_IdRemoteCMDServer;
207 unit IdRexecServer;
208 unit IdRexec; (unit uPSI_IdRexec;)
209 unit IdUDPServer;
210 unit IdTimeUDPServer;
211 unit IdTimeServer;
212 unit IdTimeUDP; (unit uPSI_IdUDPServer;)
213 unit uPSI_IdIPWatch;
214 unit uPSI_IdIrcServer;
215 unit uPSI_IdMessageCollection;
216 unit uPSI_cPEM;
217 unit uPSI_cFundamentUtils;
218 unit uPSI_uwinplot;
219 unit uPSI_xrtl_util_CPUUtils;
220 unit uPSI_GR32_System;
221 unit uPSI_cFileUtils;
222 unit uPSI_cDateTime; (timemachine)
223 unit uPSI_cTimers; (high precision timer)
224 unit uPSI_cRandom;
225 unit uPSI_ueval;
226 unit uPSI_xrtl_net_URIUtils;
227 unit xrtl_net_URIUtils;
228 unit uPSI_ufft;  (FFT of DMath)
229 unit uPSI_DBXChannel;
230 unit uPSI_DBXIndyChannel;


SHA1 Win 3.9.6.3: F576574E57F5EE240566B7D68BC44A84E3BE9938


****************************************************************
Release Notes maXbox 3.9.6 November 2012
****************************************************************
MemoryLeakReport in ini-file (MEMORYREPORT=Y)
PerlRegEx PCRE obj lib included
Perl & Python Syntax Editor
bitbox3 logic example
TAdoQuery.SQL.Add() fixed
ShLwAPI extensions
Indy HTTPHeader Extensions
194 unit uPSI_SynURIOpener;
195 unit uPSI_PerlRegEx;
196 unit uPSI_IdHeaderList;
197 unit uPSI_StFirst;
198 unit uPSI_JvCtrls;
199 unit uPSI_IdTrivialFTPBase;
200 unit uPSI_IdTrivialFTP;
201 unit uPSI_IdUDPBase;
202 unit uPSI_IdUDPClient;

SHA1 Win 3.9.6.1: B55D223159CFB5855A0BB128CB699FD8371B28CA


****************************************************************
Release Notes maXbox 3.9.4 October 2012
****************************************************************

Two new Tutorials, 17 Web Server, 18 Arduino LED
Added Units:
189 unit uPSI_cutils;
190 unit uPSI_BoldUtils;
191 unit uPSI_IdSimpleServer;
192 unit uPSI_IdSSLOpenSSL;
193 unit uPSI_IdMultipartFormData;
SHA1 Hash: Win 3.9.4.4: 8FCD41C4194F08249F085CE32F63C51B92CCC086


****************************************************************
Release Notes maXbox 3.9.3 October 2012
****************************************************************
Add Units:
161 uPSI_CheckLst;
162 uPSI_JvSimpleXml;
163 uPSI_JclSimpleXml;
164 uPSI_JvXmlDatabase;
165 uPSI_JvMaxPixel;
166 uPSI_JvItemsSearchs;
167 uPSI_StExpEng;
168 uPSI_StGenLog;
169 uPSI_JvLogFile;
170 unit uPSI_CPort; //ComPort Library v 4.11 
171 unit uPSI_CPortCtl;
172 unit uPSI_CPortEsc;
173 unit BarCodeScaner;  //frame
174 unit uPSI_JvGraph;
175 unit uPSI_JvComCtrls;
176 unit uPSI_GUITesting;  //DUnit
177 unit uPSI_JvFindFiles;
178 unit uPSI_StSystem;
179 unit uPSI_JvKeyboardStates;
180 unit uPSI_JvMail;
181 unit uPSI_JclConsole;
182 unit uPSI_JclLANMan;
183 unit uPSI_IdCustomHTTPServer;
184 unit IdHTTPServer
185 unit uPSI_IdTCPServer;
186 unit uPSI_IdSocketHandle;
187 unit uPSI_IdIOHandlerSocket;
188 unit IdIOHandler;

New add-on: Units Explorer (dependency walker)
Redesign of use case editor
Script List API in maxform1.mxnavigator
First Android code structure (Lazarus 1.0)
First Arduino Delphi LED example ex. 301 with CPort
add classes TDataModule, TGUITestCase, THTTPServer
HTTP WebServer Script 303_
menu View: Settings
maXcalc extensions (hex in the box)
Form: myform Template with <CtrJ>
SHA1 Hash: Win 3.9.3.6: C3531DC055AEB324459D2D04EB827D73D441B77E

SHA1 Hash: CLX 3.7.6.14: 199E9C3DE23C02DD7C4A32E424D5BCBC0FF47685 
add units: Turtle, JvgLogics, Expression Parser, JvStrings, HTTPServer, TCPServer and more

****************************************************************
Release Notes maXbox 3.9.2 September 2012
****************************************************************

more functions in maXcalc
more functions in RegEx
updated functionlist
152 unit uPSI_IMouse;
153 unit uPSI_SyncObjs;
154 unit uPSI_AsyncCalls; //draft for mX4
155 unit uPSI_ParallelJobs; //draft for mX4
156 unit uPSI_Variants;
157 unit uPSI_VarCmplx;
158 unit uPSI_DTDSchema;
159 unit uPSI_ShLwApi;
160 unit uPSI_IBUtils;
SHA1 Hash of maXbox 3.9.2.2: D6D993CF9F1B98BEBB44295C03E7DE29D8E8CC4B

****************************************************************
Release Notes maXbox 3.9.1 August Distribution 2012
****************************************************************
new tutorial 16 event programming
added docs & examples
no changes in compiler maxbox3.exe !
update to pas_includebox lib
SHA1 Hash of maXbox 3.9.1.2: B8686418D5F31B618E595F26F8E74BBCD39AA839 

****************************************************************
Release Notes maXbox 3.9.1 June 2012
****************************************************************
SysTools4 Integration, PicturePuzzle, HTMLJpeg

129 unit uPSI_StUtils;
130 unit uPSI_StToHTML;
131 unit uPSI_StStrms;
132 unit uPSI_StFIN;
133 unit uPSI_StAstroP;
134 unit uPSI_StStat;
135 unit uPSI_StNetCon;
136 unit uPSI_StDecMth;
137 unit uPSI_StOStr;
138 unit uPSI_StPtrns;
139 unit uPSI_StNetMsg;
140 unit uPSI_StMath;
141 unit uPSI_StExpEng;
142 unit uPSI_StCRC;
143 unit uPSI_StExport,
144 unit uPSI_StExpLog,
145 unit uPSI_ActnList;
146 unit uPSI_jpeg;
147 unit uPSI_StRandom;
148 unit uPSI_StDict;
149 unit uPSI_StBCD;
150 unit uPSI_StTxtDat;
151 unit uPSI_StRegEx;

SHA1 Hash of maXbox 3.9.1.2: B8686418D5F31B618E595F26F8E74BBCD39AA839 

****************************************************************
Release Notes maXbox 3.9.0 June 2012
****************************************************************

Object Finder, HTML Export, SynRegEx,  plus UML Signs

119 unit uPSI_DBLogDlg;
120 unit uPSI_SqlTimSt;
121 unit uPSI_JvHtmlParser;
122 unit uPSI_JvgXMLSerializer;
123 unit uPSI_JvJCLUtils;
124 unit uPSI_JvStrings;
125 unit uPSI_uTPLb_IntegerUtils;
126 unit uPSI_uTPLb_HugeCardinal;
127 unit uPSI_uTPLb_HugeCardinalUtils;
128 unit uPSI_SynRegExpr;

SHA1 Hash of maXbox Win  3.9.0.1:   CFCAB4764DDE25AED6112646BEFC48CF2A2DC306

****************************************************************
Release Notes maXbox 3.8.6.4 Mai 2012
****************************************************************
Workbench Plug-In List, threads, hexdump
Variant Support - Genetix Algorithms - Closure Tests
JBL (Jedi Base Library)-Turtle Interpreter
103 unit uPSI_JvGenetic;
104 unit uPSI_JclBase;
105 unit uPSI_JvUtils;
106 unit uPSI_JvStrUtil;
107 unit uPSI_JvStrUtils;
108 unit uPSI_JvFileUtil;
109 unit uPSI_JvMemoryInfos;
110 unit uPSI_JvComputerInfo;
111 unit uPSI_JvgCommClasses;
112 unit uPSI_JvgLogics;
113 unit uPSI_JvLED;
114 unit uPSI_JvTurtle;
115 unit uPSI_SortThds; unit uPSI_ThSort;
116 unit uPSI_JvgUtils;
117 unit uPSI_JvExprParser;
118 unit uPSI_HexDump;

SHA1 Hash of maXbox Win  3.8.6.4: E5BD4A3AA6488FE01EE0F517C2B5960AAA4BB875
SHA1 Hash of maXbox CLX 3.7.5.1: 16B0FD0CE92D6EA356804E7F1B0E6EC8534C2E58

****************************************************************
Release Notes maXbox 3.8.5.1  April 2012
****************************************************************
- added TSerial 4.3 (RS232) with app on output 
- Tutorial 15 Serial Programming
- added math formula translator of JvParsing
- onMessage and onException events
094 unit uPSI_JvCtrlUtils;
095 unit uPSI_JvFormToHtml;
096 unit uPSI_JvParsing;
097 unit uPSI_SerDlgs;
098 unit uPSI_Serial;
099 unit uPSI_JvComponent;
100 unit uPSI_JvCalc;
101 unit uPSI_JvBdeUtils;
102 unit uPSI_JvDateUtil;

SHA1 Hash of maXbox 3.8.5.1:  F8DF3B816B0CEB72DC44F0F8492E556A10E05AA5
SHA1 Hash of maXbox 3.8.5.0:  CDDA808D3B29B0D517CFE6AF2B68AF0A6D6B35D1

Release 3.8.5 Vienna Edition

****************************************************************
Release Notes maXbox 3.8.4 March 2012
****************************************************************
- PDF function help system, PHP Syntax
- new tutorial about data encryption and async programming
- added functions: Performance Counter, CryptoBox3.1, API Timer
- added crypto and JCL units:
86 unit uPSI_uTPLb_AES;                        //LockBox 3
87 unit uPSI_IdHashSHA1;                       //LockBox 3
88 unit uTPLb_BlockCipher;                     //LockBox 3
89 unit uPSI_ValEdit.pas;	               //Delphi VCL
90 unit uPSI_JvVCLUtils;  		//JCL Utils, DBUtils, AppUtils
91 unit uPSI_JvDBUtil;
92 unit uPSI_JvDBUtils;
93 unit uPSI_JvAppUtils;

SHA1 Hash of maXbox 3.8.4:     3D7BA42B0952065DBE9863E2D517C4CE9BEAFA0C  

****************************************************************
Release Notes maXbox 3.8.1 January 2012
****************************************************************
- Added Units:
76 unit uPSI_ShadowWnd; (VCL)
77 unit uPSI_ToolWin; (VCL)
78 unit uPSI_Tabs; (VCL)
79 unit uPSI_JclGraphUtils; (JCL), OpenGL
80 unit uPSI_JclCounter; (JCL)
81 unit uPSI_JclSysInfo; (JCL)
82 unit uPSI_JclSecurity; (JCL)
83 unit uPSI_JclFileUtils; (JCL)
84 unit uPSI_IdUserAccounts; (Indy) 
85 unit uPSI_IdAuthentication; (Indy)

Tested mX4 compiler
SHA1 Hash of maXbox 3.8.1: 7878D2AF674A222F8D2F1DB8CE6D16951ADFBE78
SHA1 Hash of maXbox CLX:  92D56AFDADA5A8100D57082B5686FAD4B5EA2AD1

****************************************************************
Release Notes maXbox 3.8 2012
****************************************************************
- Update Compiler from mX3 to mX4 (unit support, enhanced decompile/debug)
- Internet Version Check 
- Boot Loader Script (Auto Start) 
- Updated Examples
- mX4 adaption of syntax, compile, decompile and debug synchronisation
SHA1 Hash of maXbox 3.8:   DAB8B2834E4EE14043D440C2C57185586C2F54D1

****************************************************************
Release Notes maXbox 3.7.1 December 2011
****************************************************************

- File Information Menu, Package Loader, 2 New Tutorials 
- Added Units:
69 unit uPSI_WideStrUtils;                    
70 unit uPSI_GraphUtil;                       
71 unit uPSI_TypeTrans;                        
72 unit uPSI_HTTPApp;                          
73 unit uPSI_DBWeb;              
74 unit uPSI_DBBdeWeb;              
75 unit uPSI_DBXpressWeb;         
SHA1 Hash of maXbox 3.7.0.2 Win: CE87326ADA879A60FAF4062AB6E6CC26069B8250
SHA1 Hash of maXbox CLX:             ED8B46160A604F8162A19E0E1FBC3515D0F38C66

****************************************************************
Release Notes maXbox 3.6.3 November 2011
****************************************************************

New Units
unit uPSI_JclStatistics;
unit uPSI_JclLogic;
unit uPSI_JclMiscel;
unit uPSI_JclMath_max;
unit uPSI_uTPLb_StreamUtils;
unit uPSI_MathUtils;
unit uPSI_JclMultimedia;

Resource Finder, Script Explorer, F4 (New Instance) and F6 (Goto End.) 
SHA1 Hash of maXbox Win: 365666B4648C478D3FDB1444D3824422C5C51024 


****************************************************************
Release Notes maXbox 3.6.2 November 2011
****************************************************************
//MATLAB, maXbox, Mapple examples added;)

New Units
58 unit uPSI_CDSUtil;	//Borland MIDAS
59 unit uPSI_VarHlpr;	//Delphi RTL
60 unit uPSI_ExtDlgs;	//Delphi VCL

several bugfixes in graphics, client dataset, dialogs and RTL
allresourcelist.txt and resource dll added (maxbox_res.dll)
switch on/off Options/ProcessMessages!

20.10.2011 14:35:18 Creation Date of maXbox3
SHA1 Hash of maXbox Win: 8BE92CE1B63FACF9AA21807CA9DCDBF49D370FA7

****************************************************************
Release Notes maXbox 3.6.1.2 October 2011
****************************************************************
New Units
- unit uPSI_DBClient;	//Delphi RTL
- unit uPSI_DBPlatform;	//Delphi RTL
- unit uPSI_Provider;		//Delphi RTL
- unit uPSI_FMTBcd;	//Delphi RTL
- unit uPSI_DBCGrids;	//Delphi VCL
	
SHA1 Hash of maXbox Win:   E849BE32DDB42FFB54920ED3486735FEEA6DDCD8
SHA1 Hash of maXbox CLX:   7C3BF0DDA7C62C21F7C8E3A907DAAD423E4B6C6F
SHA1 Hash of maXbox Mac:   E849BE32DDB42FFB54920ED3486735FEEA6DDCD8

****************************************************************
Release Notes maXbox 3.6.0.2 October 2011
****************************************************************
New Units
- ComCtrls Unit
- Dialogs Unit
- StdConvs Unit
- VListView
- DebugOut Window and Android / Arduino HexDump Preparations

27.09.2011 23:52:04 Creation Date of maXbox3
SHA1 Hash of maXbox Win:   ABE2E228BE6853C9327B9623C82AD104F7369720
SHA1 Hash of maXbox CLX:   7C3BF0DDA7C62C21F7C8E3A907DAAD423E4B6C6F
Shell Version is: 393216, Version of maXbox3: 3.6.0.2

****************************************************************
Release Notes maXbox 3.5.1 September 2011
****************************************************************
- 10 Tutorials and 220 Examples
- Android/Mac Beta 0.8 as Delphi VirtualMachine
- Syntax Check F2 - Java, C Syntax in Context Menu
- Stop forever loops by edit and recompile if Options/ProcessMessages is set 
- Crypto Unit, SocketServer, UpdateService, ScriptLoader
- Enhanced OpenTools API, run example '214_mxdocudemo3.txt'
- Upgrade of upsi_allfunctionslist.txt and upsi_allobjectslist.txt
- Service Site: http://www.softwareschule.ch/maxbox.htm 
- Best of Runtime Test Routine, example 165_best_of_runtime2.txt

14.09.2011 23:39:28 Creation Date of maXbox3 for maXbox3 3.5.1.8
Shell Version is: 393216, Version of maXbox3: 3.5.1.8

****************************************************************
Release Notes maXbox 3.3 Juli 2011
****************************************************************
- prepare to WebService and CodeCompletion: uPSI_XMLUtil;  SOAPHTTPClient;            
- new Instance, componentcount, cipherbox, 15 new functions and new Examples

****************************************************************
Release Notes maXbox 3.2 April 2011
****************************************************************
- New Units: WideStrings, BDE, SqlExpr (DBX3), ADO_DB, StrHlpr, DateUtils, FileUtils
//Expansion to DateTimeLib and Expansion to Sys/File Utils
 JUtils / gsUtils / JvFunctions of Jedi Functions
- prepare to WebService: HTTPParser; HTTPUtil; uPSI_XMLUtil;  SOAPHTTPClient;            
- new Tutorial 9 and now 210 Examples

****************************************************************
Release Notes maXbox 3.1 March 2011
****************************************************************
please read also http://www.softwareschule.ch/maxboxnews.htm

Now almost 1000 functions /procedures and about 110 objects /classes from VCL, FCL, LCL or CLX
- start it from a USB stick or from a UNC Network Path
- new output menu of styles for prototyping or teaching include context menu
- include kernel functions of compiler and makro editor with RegEX2
- new Units: DB System, Tables and DataSets, Printer, MediaPlayer, Grids, Clipboard, Statusbar

****************************************************************
Release Notes maXbox 3.0 December 2010
****************************************************************

//Load examples *.txt from /examples and press F9!
//please read the readmefirst...or start with the tutorials in /help
//memo1 is script editor
//memo2 is output space

- over 600 new delphi, pascal, network and indy functions in built
- now 810 functions /procedures and 120 types and constants
  (see in the file: upsi_allfunctionslist.txt)
- png, tiff, jpg and more graphics support for canvas and TPicture
- SMTP, POP3, HTTP, FTP, sysutils, strutils, shell and ini support
- Improvments of 64Bit, PNG, and Ansi/WideStrings are done, Dialogs and Plugins are under way
  (e.g. MP3-Player and POP3-Mail Function)
- Now() is now the origin, you have to call DateTimeToStr(Now)
- maXCom examples 1-150 improved with students
- readonly Mode in ../Options/Save before Compile
- mX3 logo font is Tempus Sans ITC kursiv durchgestrichen 48
- use case designer (in speed button, popup & menu)
  note: when a model file has same name like the code file with extension *.uc
  it will load straight the use case editor from same directory 
  e.g. examples/50_program_starter.txt
         examples/50_program_starter.uc
- updating all the examples from _1 to _150 in 8 categories base, math, graphic, statistic, system, net, internet and games. 	

{ max@kleiner.com  V3.0.0.6 February 2011
  new version and examples from
     http://www.softwareschule.ch/maxbox.htm }


Information for the CLX Linux Version
****************************************************************
you can start a shell script with the name e.g. "maxboxstart.sh":
-----------------------------------------------------------------------------
#!/bin/bash
cd `dirname $0`
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
./maxbox3clx
exit 0
-----------------------------------------------------------------------------
so it will include the path to the 2 symbolic links and you can start the box
 from the shell, from script or with click from a stick.
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
Release Notes on V2.9.2
- ftp, html support (based on indy sockets), examples 104-120
Release Notes on V2.9.1
- http support (based on indy sockets), examples 101-103
-----------------------------------------------------------------------------
Release Notes on V2.9.0
-----------------------------------------------------------------------------

Note about vista and win7: by using labels from TLabel set transparent:= false;
for graphics/forms concerning visibility/performance try the ProcessMessages! flag
under /Options/ProcessMessages! 

****************************************************************
Changes in maXbox 2.9 Juni 2010
****************************************************************
- font editor in menu 
- include bug in menu show include solved, also relative path 
- bitmap support for canvas and TPicture
- TDataSet and DB fields support
- use case designer (in speed button, popup & menu)
  note: when a model file has a same name like the code file but the extension *.uc
  it will load straight in the use case editor from same directory (e.g. examples)
  e.g. examples/50_program_starter.txt
       examples/50_program_starter.uc	


Changes in maXbox 2.8.1 April 2010
****************************************************************
- refresh problem after clipboard actions in editor solved
- standard math functions added (exp, ln, sqr, arctan etc.)
- doesn't hang after long running (application.processMessages)
- commandline interface in shell:>maxbox2.exe "script_file.txt"
- starter tutorial2 in /docs maxbox_starter2.pdf 


maXbox 2.8 Januar 2010
****************************************************************
- 2 file history in ini file and change between
- more perfomance in debug mode 
- starter tutorial in /docs maxbox_starter.pdf
- assign2 and reset2 functions
- special characters in edit mode 
- reptilian liquid motion function (rlmf)


Changes in maXbox 2.7.1 November 2009
****************************************************************
- debug and decompile functions with a second compile engine
- inbuilt math and stat lib
- all time and date functions internal now
- playMP3, stopMP3, closeMP3
- save bytecode bug solves (options show bytecode)

****************************************************************
News in maXbox v 2.7
****************************************************************
code completion in bds_delphi.dci - delphi compatible
escape and cut/copy paste in memo1
write() and TFileStruct bug solved
line numbers in gutter
statusline and toolbar
enhanced clipboard
check the demo: 38_pas_box_demonstrator.txt
published on http://sourceforge.net/projects/maxbox
subset was extended by the Poly data type that allows you to operate with dynamic data structures (lists, trees, and more) without using pointers and apply Pascal language in the Artificial Intelligence data domain with the same success.
PasScript supports more wide subset of the OP language. You can use such concepts as units, default parameters, overloaded routines, open arrays, records, sets, pointers, classes, objects, class references, events, exceptions, and more in a script. PasScript syntax is 98% compatible with OP.
Allow scripts to use dll functions, the syntax is like:
function FindWindow(C1, C2: PChar): Longint; external 'FindWindowA@user32.dll stdcall'; 
You can include files {$I pas_includebox.inc} and print out your work.
maXbox includes a preprocessor that allows you to use defines ({$IFDEF}, {$ELSE}, {$ENDIF}) to include other files in your script ({$I filename.inc}). 

------------------------------------------------------------------
Important First Steps and Tips and Tricks:
------------------------------------------------------------------
1. You can load a script by open the file.
2. Then you can compile /save the file (F9).
3. When using the menu options/show_linenumbers the editor is in read only mode!
4. The output window is object memo2 from TMemo and you can program it.
5. Last file, font- and window size are saved in a ini file. -->maxboxdef.ini
6. By escape <esc> you can close the box.
7. The source in the zip is almost complete, please contact for further source.
8. Some functions like random or beep do have a second one: random2, put2, beep2, assign2 etc.
9. Read the tutorial starter 1-8 in tutorial in /docs maxbox_starter.pdf


Tips of the Day for Version V3.5
----------------------------------------------

- Click on the red maXbox Sign (right on top) opens your work directory
- You can printout your scripts as a pdf-file
- You do have a context menu with the right mouse click
- With the UseCase Editor you can convert graphic formats too.
- On menu Options you find 4 Addons as compiled scripts 
- You don't need a mouse to handle maXbox, use shortcuts
- With F2 you check syntax with F9 you compile
- With escape you can leave the box
- In directory /exercises you find a few compilats 
- Drag n' drop your scripts in the box
- Open in menu Outpout a new instance of the box to compare or prepare your scripts
- You can get templates as code completion with ctrl j in the editor like
  classp or iinterface or ttimer (you type classp and then CTRL J)
- In menu output you can set output menu in edit mode by unchecking read only memo  
- To start from CD-ROM (read only mode) uncheck  in Menu /Options/Save before Compile         


just inside maXbox
         ____    ___   _      ____    _   _   _
        |  _ \  |  _| | |    |  _ \  | | | | | |
        | | . | | |_  | |    | |_| | | |_| | | |
        | | | | |  _| | |    |  __/  |  _  | | |          
        | |_. | | |_  | |__  | |     | | | | | |                      
        |____/  |___| |____| |_|     |_| |_| |_|                                   

max@kleiner.com
 
new version and examples from
http://www.softwareschule.ch/maxbox.htm
http://www.softwareschule.ch/download/maxbox3.zip
http://sourceforge.net/projects/maxbox


// to Delphi users:
 Also add this line to your project source (.DPR).
{$D-} will prevent placing Debug info to your code.
{$L-} will prevent placing local symbols to your code.
{$O+} will optimize your code, remove unnecessary variables etc.
{$Q-} removes code for Integer overflow-checking.
{$R-} removes code for range checking of strings, arrays etc.
{$S-} removes code for stack-checking. USE ONLY AFTER HEAVY TESTING !
{$Y-} will prevent placing smybol information to your code.


Dear software manufacturer,

your software maXbox is listed in the heise software directory for download
Fortunately, our automatic virus checks (done in co-operation with AV-Test GmbH) with more than 40 virus scanners do not indicate a virus infection. Just in case you are interested in the scan result we are sending you the detailed scan report:
============================================================
This is the detailed report:
Scan-Report of: maxbox3.zip
Ahnlab	OK
Avast	OK
AVG	OK
Avira	OK
Bitdefender	OK
Command	OK
Command (Online)	OK
Eset Nod32	OK
Fortinet	OK
F-Prot	OK
G Data	OK
Ikarus	OK
K7 Computing	OK
Kaspersky	OK
Kaspersky (Online)	OK
McAfee	OK
McAfee (BETA)	OK
McAfee (Online)	OK
McAfee GW Edition (Online)	OK
Microsoft	OK
Norman	OK
Panda	OK
Panda (Online)	OK
QuickHeal	Suspicious (warning)
Rising	OK
Rising (Online)	OK
Sophos	OK
Sophos (Online)	OK
Symantec	OK
Symantec (BETA)	OK
ThreatTrack	OK
Total Defense	OK
Trend Micro	OK
Trend Micro (Cons.)	OK
Trend Micro (CPR)	OK
VBA32	OK
VirusBuster	OK
 
The following updates have been used for the test (all times in UTC):
Ahnlab	sdscan-console.zip	2015-01-17	13:10
Avast	av5stream.zip	2015-01-18	01:00
AVG	avg10cmd1191a8405.zip	2015-01-17	09:40
Avira	vdf_fusebundle.zip	2015-01-17	13:50
Bitdefender	bdc.zip	2015-01-18	00:15
Command	antivir-v2-z-201501172305.zip	2015-01-18	00:00
Command (Online)	antivir-v2-z-201501172305.zip	2015-01-18	00:00
Eset Nod32	minnt3.exe	2015-01-18	00:15
Fortinet	vir_high	2015-01-18	00:25
F-Prot	antivir.def	2015-01-18	00:30
G Data	bd.zip	2015-01-18	00:55
Ikarus	t3sigs.vdb	2015-01-17	21:35
K7 Computing	K7Cmdline.zip	2015-01-16	12:45
Kaspersky	kdb-i386-cumul.zip	2015-01-18	00:10
Kaspersky (Online)	kdb-i386-cumul.zip	2015-01-18	00:10
McAfee	avvdat-7684.zip	2015-01-17	19:05
McAfee (BETA)	avvwin_netware_betadat.zip	2015-01-17	23:55
McAfee (Online)	avvdat-7684.zip	2015-01-17	19:05
McAfee GW Edition (Online)	mfegw-cmd-scanner-windows.zip	2015-01-17	21:45
Microsoft	mpam-fe.exe	2015-01-17	23:20
Norman	nse7legacy.zip	2015-01-17	06:55
Panda	pav.zip	2015-01-17	10:55
Panda (Online)	pav.zip	2015-01-17	10:55
QuickHeal	qhadvdef.zip	2015-01-17	16:30
Rising	rame.zip	2015-01-17	13:15
Rising (Online)	rame.zip	2015-01-17	13:15
Sophos	ides.zip	2015-01-17	23:05
Sophos (Online)	ides.zip	2015-01-17	23:05
Symantec	streamset.zip	2015-01-18	01:00
Symantec (BETA)	symrapidreleasedefsv5i32.exe	2015-01-18	00:50
ThreatTrack	CSE39VT-EN-36746-F.sbr.sgn	2015-01-18	00:35
Total Defense	fv_nt86.exe	2015-01-17	20:20
Trend Micro	itbl1503402100.zip	2015-01-18	00:30
Trend Micro (Cons.)	hcoth1141795.zip	2015-01-17	17:15
Trend Micro (CPR)	lpt418.zip	2015-01-17	20:00
VBA32	vba32w-latest.rar	2015-01-16	21:00
VirusBuster	vdb.zip	2015-01-17	17:30
Name:
    maXbox
Hersteller-Link:
    Offizielle Webseite	
Sprache:
    Deutsch/Englisch
Betriebssysteme:
    Windows XP, Vista, 7, 8, Linux, Mac OS X/Intel
Download-Größe:
    118 MByte
Lizenz:
    Open Source
Preis:
    kostenlos
Einschränkungen:
    keine
Hersteller/Autor:
    Kleiner Kommunikation
E-Mail-Adresse:
    k.A. 
Bewertungsrang:
    444
Download-Rang:
    2932
Programmdaten aktualisieren
(nur für Autoren/Hersteller)
Datensatz zuletzt aktualisiert
am 10.01.15
Alle Angaben ohne Gewähr.

============================================================

Examples Info
    examples need internet
    001_1_pas_functest.txt 
    101 - 130
    
    takes time
    044_pas_8queens_solutions.txt (2 min.)
    050_pas_primetest2.txt (1 min)
    064_pas_timetest.txt(1 min)
    070_pas_functionplotter4.txt(2 min.)

075_pas_bitmap_Artwork.txt intelligence test
065 bitcounter as performance test


Object Based Scripting Tool
maXbox is a free scripter tool with an inbuilt delphi engine in one exe! It is designed for teaching, develop, test and analyzing apps and algorithms and runs under Windows and Linux (CLX) to set Delphi in a box without installation and no administration. The tool is based on an educational program with examples and exercises (from biorhythm, form building to how encryption works). Units are precompiled and objects invokable! With a 28 part tutorial for coders.


https://github.com/maxkleiner/maXbox3.git

http://downloads.sourceforge.net/project/maxbox/maxbox3clx.tar.gz
http://de.sourceforge.jp/projects/sfnet_maxbox/downloads/maxbox3clx.tar.gz/
http://www.mirrorservice.org/sites/downloads.sourceforge.net/m/ma/maxbox/maxbox3clx.tar.gz
http://www.mirrorservice.org/sites/downloads.sourceforge.net/m/ma/maxbox/

httpde.sourceforge.jp%2Fprojects%2Fsfnet_maxbox%2Fdownloads%2Fmaxbox3clx.tar.gz%2F&ei=iir5UunlHYWxywO17YLYAg&usg=AFQjCNHecwAFuIbxLJ8nKZ2_NLcdAZpfpg

http://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=4&cad=rja&ved=0CE4QFjAD&url=http%3A%2F%2Fde.sourceforge.jp%2Fprojects%2Fsfnet_maxbox%2Fdownloads%2Fmaxbox3clx.tar.gz%2F&ei=iir5UunlHYWxywO17YLYAg&usg=AFQjCNHecwAFuIbxLJ8nKZ2_NLcdAZpfp