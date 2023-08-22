unit IFSI_SysUtils_max;
{
code implementing the class wrapper is fpr mX3 Win & Linux
  with functions of classes
  stdin, stdout, stderr, processpath
  include system const and functions   TFormClass
}
{$I PascalScript.inc}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler, Windows;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_SysUtils = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure CompileImport2(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 PStrData = ^TStrData;
  TStrData = record
    Ident: Integer;
    Str: string;
  end;

  TDaynames = array[1..7] of string;
  TMonthnames = array[1..12] of string;

  Tforleadbytes = set of char;

  //TFormclass;



{ compile-time registration functions }
procedure SIRegister_EWin32Error(CL: TPSPascalCompiler);
procedure SIRegister_EOSError(CL: TPSPascalCompiler);
procedure SIRegister_EStackOverflow(CL: TPSPascalCompiler);
procedure SIRegister_EExternal(CL: TPSPascalCompiler);
procedure SIRegister_EInOutError(CL: TPSPascalCompiler);
procedure SIRegister_EHeapException(CL: TPSPascalCompiler);
procedure SIRegister_Exception(CL: TPSPascalCompiler);
procedure SIRegister_TLanguages(CL: TPSPascalCompiler);
procedure SIRegister_SysUtils(CL: TPSPascalCompiler);
 
{ run-time registration functions }
procedure RIRegister_SysUtils_Routines(S: TPSExec);
procedure RIRegister_EWin32Error(CL: TPSRuntimeClassImporter);
procedure RIRegister_EOSError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EStackOverflow(CL: TPSRuntimeClassImporter);
procedure RIRegister_EExternal(CL: TPSRuntimeClassImporter);
procedure RIRegister_EInOutError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EHeapException(CL: TPSRuntimeClassImporter);
procedure RIRegister_Exception(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLanguages(CL: TPSRuntimeClassImporter);
procedure RIRegister_SysUtils(CL: TPSRuntimeClassImporter);



implementation


uses
   Types
  //,Libc
  ,FileCtrl
  ,SysConst
  ,Graphics
  ,Controls
  ,Forms
  ,DB
  ,uPSC_dateutils
  ,sdpStopwatch
  ;

type marrstr = array of string;  

{ compile-time importer function }
(*----------------------------------------------------------------------------
 So, you may use the below RegClassS() replacing the CL.AddClassN()
 of the various SIRegister_XXXX calls
 ----------------------------------------------------------------------------*)

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStopwatch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStopwatch') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStopwatch') do begin
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Function GetValueStr : String');
    RegisterMethod('Function GetValueMSec : Cardinal');
    RegisterMethod('Function GetTimeString: String');
    RegisterMethod('Function GetTimeStr: String');
  end;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TStopwatch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStopwatch) do begin
    RegisterMethod(@TStopwatch.Start, 'Start');
    RegisterMethod(@TStopwatch.Stop, 'Stop');
    RegisterMethod(@TStopwatch.GetValueStr, 'GetValueStr');
    RegisterMethod(@TStopwatch.GetValueMSec, 'GetValueMSec');
    RegisterMethod(@TStopwatch.GetTimeString, 'GetTimeString');
    RegisterMethod(@TStopwatch.GetTimeStr, 'GetTimeStr');
  end;
end;



function RegClassS(CL: TPSPascalCompiler; const InheritsFrom, Classname: string): TPSCompileTimeClass;
begin
  Result := CL.FindClass(Classname);
  if Result = nil then
    Result := CL.AddClassN(CL.FindClass(InheritsFrom), Classname)
  else Result.ClassInheritsFrom := CL.FindClass(InheritsFrom);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EWin32Error(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOSError', 'EWin32Error') do
  with CL.AddClassN(CL.FindClass('EOSError'),'EWin32Error') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EOSError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EOSError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EOSError') do begin
    RegisterProperty('ErrorCode', 'DWORD', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EStackOverflow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EExternal', 'EStackOverflow') do
  with CL.AddClassN(CL.FindClass('EExternal'),'EStackOverflow') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EExternal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EExternal') do
  with CL.AddClassN(CL.FindClass('Exception'),'EExternal') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EInOutError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EInOutError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EInOutError') do begin
    RegisterProperty('ErrorCode', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EHeapException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EHeapException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EHeapException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Exception(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'Exception') do
  with CL.AddClassN(CL.FindClass('TObject'),'Exception') do begin
    RegisterMethod('Constructor Create( Msg : string)');
    RegisterMethod('Constructor CreateRes( Ident : Integer);');
    RegisterMethod('Constructor CreateRes( ResStringRec : PResStringRec);');
    RegisterMethod('Constructor CreateResHelp( Ident : Integer; AHelpContext : Integer);');
    RegisterMethod('Constructor CreateResHelp( ResStringRec : PResStringRec; AHelpContext : Integer);');
    RegisterProperty('HelpContext', 'Integer', iptrw);
    RegisterProperty('Message', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLanguages(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLanguages') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLanguages') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IndexOf( ID : LCID) : Integer');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Name', 'string Integer', iptr);
    RegisterProperty('NameFromLocaleID', 'string LCID', iptr);
    RegisterProperty('NameFromLCID', 'string string', iptr);
    RegisterProperty('ID', 'string Integer', iptr);
    RegisterProperty('LocaleID', 'LCID Integer', iptr);
    RegisterProperty('Ext', 'string Integer', iptr);
  end;
end;

Function BoolToStr1(value: boolean) : string;
Begin If value then Result:= 'TRUE' else Result := 'FALSE'
End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SysUtils(CL: TPSPascalCompiler);
begin

 SIRegister_TStopwatch(CL);
 //CL.AddConstantN('fmOpenRead','').SetString( O_RDONLY);
 //CL.AddConstantN('fmOpenWrite','').SetString( O_WRONLY);
 //CL.AddConstantN('fmOpenReadWrite','').SetString( O_RDWR);
 CL.AddConstantN('fmShareExclusive','LongWord').SetUInt( $0010);
 CL.AddConstantN('fmShareDenyWrite','LongWord').SetUInt( $0020);
 CL.AddConstantN('fmShareDenyRead','LongWord').SetUInt( $0030);    //3.2
 CL.AddConstantN('fmOpenRead','LongWord').SetUInt( $0000);
 CL.AddConstantN('fmOpenWrite','LongWord').SetUInt( $0001);
 CL.AddConstantN('fmOpenReadWrite','LongWord').SetUInt( $0002);
 CL.AddConstantN('fmShareExclusive','LongWord').SetUInt( $0010);
 CL.AddConstantN('fmShareDenyWrite','LongWord').SetUInt( $0020);
 CL.AddConstantN('fmShareDenyNone','LongWord').SetUInt( $0040);
 //CL.AddConstantN('faDirectory','LongWord').SetUInt( $00000010);
 //CL.AddConstantN('faAnyFile','LongWord').SetUInt( $0000003F);
 CL.AddConstantN('HoursPerDay','LongInt').SetInt( 24);
 CL.AddConstantN('MinsPerHour','LongInt').SetInt( 60);
 CL.AddConstantN('SecsPerMin','LongInt').SetInt( 60);
 CL.AddConstantN('MSecsPerSec','LongInt').SetInt( 1000);
 CL.AddConstantN('MinsPerDay','LongInt').SetInt(HoursPerDay * MinsPerHour);
 CL.AddConstantN('SecsPerDay','LongInt').SetInt(MinsPerDay * SecsPerMin);
 CL.AddConstantN('Msecsperday','LongInt').SetInt(SecsPerDay * MSecsPerSec);
 CL.AddConstantN('DateDelta','LongInt').SetInt( 693594);
 CL.AddConstantN('UnixDateDelta','LongInt').SetInt( 25569);
 CL.AddConstantN('MaxInt','LongInt').SetInt(2147483647);
 CL.AddConstantN('SRCCOPY','LongWord').SetUInt($00CC0020);
 CL.AddConstantN('SRCPAINT','LongWord').SetUInt($00EE0086);
 CL.AddConstantN('SRCAND','LongWord').SetUInt($008800C6);
 CL.AddConstantN('SRCINVERT','LongWord').SetUInt($00660046);
 CL.AddConstantN('SRCERASE','LongWord').SetUInt($00440328);


  (*SRCPAINT    = $00EE0086;     { dest = source OR dest            }
  {$EXTERNALSYM SRCAND}
  SRCAND      = $008800C6;     { dest = source AND dest           }
  {$EXTERNALSYM SRCINVERT}
  SRCINVERT   = $00660046;     { dest = source XOR dest           }
  {$EXTERNALSYM SRCERASE}
  SRCERASE    = $00440328;     { dest = source AND (NOT dest )*)

  //CL.AddTypeS('PDayTable', '^TDayTable // will not work');
  CL.AddTypeS('TFilenameCaseMatch', '( mkNone, mkExactMatch, mkSingleMatch, mkAmbiguous )');
 // CL.AddTypeS('TReplaceFlags', 'set of ( rfReplaceAll, rfIgnoreCase )');
  CL.AddTypeS('TSysCharSet', 'set of Char');
  //{$EXTERNALSYM FILEOP_FLAGS}
  CL.AddTypeS('FILEOP_FLAGS','Word');

 CL.AddConstantN('RTLVersion','Extended').setExtended( 18.00);    //3.7
 //CL.AddConstantN('GPL','Boolean')BoolToStr( True);
 CL.AddConstantN('varEmpty','LongWord').SetUInt( $0000);
 CL.AddConstantN('varNull','LongWord').SetUInt( $0001);
 CL.AddConstantN('varSmallint','LongWord').SetUInt( $0002);
 CL.AddConstantN('varInteger','LongWord').SetUInt( $0003);
 CL.AddConstantN('varSingle','LongWord').SetUInt( $0004);
 CL.AddConstantN('varDouble','LongWord').SetUInt( $0005);
 CL.AddConstantN('varCurrency','LongWord').SetUInt( $0006);
 CL.AddConstantN('varDate','LongWord').SetUInt( $0007);
 CL.AddConstantN('varOleStr','LongWord').SetUInt( $0008);
 CL.AddConstantN('varDispatch','LongWord').SetUInt( $0009);
 CL.AddConstantN('varError','LongWord').SetUInt( $000A);
 CL.AddConstantN('varBoolean','LongWord').SetUInt( $000B);
 CL.AddConstantN('varVariant','LongWord').SetUInt( $000C);
 CL.AddConstantN('varUnknown','LongWord').SetUInt( $000D);
 CL.AddConstantN('varShortInt','LongWord').SetUInt( $0010);
 CL.AddConstantN('varByte','LongWord').SetUInt( $0011);
 CL.AddConstantN('varWord','LongWord').SetUInt( $0012);
 CL.AddConstantN('varLongWord','LongWord').SetUInt( $0013);
 CL.AddConstantN('varInt64','LongWord').SetUInt( $0014);
 CL.AddConstantN('varStrArg','LongWord').SetUInt( $0048);
 CL.AddConstantN('varString','LongWord').SetUInt( $0100);
 CL.AddConstantN('varAny','LongWord').SetUInt( $0101);
 CL.AddConstantN('varTypeMask','LongWord').SetUInt( $0FFF);
 CL.AddConstantN('varArray','LongWord').SetUInt( $2000);
 CL.AddConstantN('varByRef','LongWord').SetUInt( $4000);
 CL.AddConstantN('vtInteger','LongInt').SetInt( 0);
 CL.AddConstantN('vtBoolean','LongInt').SetInt( 1);
 CL.AddConstantN('vtChar','LongInt').SetInt( 2);
 CL.AddConstantN('vtExtended','LongInt').SetInt( 3);
 CL.AddConstantN('vtString','LongInt').SetInt( 4);
 CL.AddConstantN('vtPointer','LongInt').SetInt( 5);
 CL.AddConstantN('vtPChar','LongInt').SetInt( 6);
 CL.AddConstantN('vtObject','LongInt').SetInt( 7);
 CL.AddConstantN('vtClass','LongInt').SetInt( 8);
 CL.AddConstantN('vtWideChar','LongInt').SetInt( 9);
 CL.AddConstantN('vtPWideChar','LongInt').SetInt( 10);
 CL.AddConstantN('vtAnsiString','LongInt').SetInt( 11);
 CL.AddConstantN('vtCurrency','LongInt').SetInt( 12);
 CL.AddConstantN('vtVariant','LongInt').SetInt( 13);
 CL.AddConstantN('vtInterface','LongInt').SetInt( 14);
 CL.AddConstantN('vtWideString','LongInt').SetInt( 15);
 CL.AddConstantN('vtInt64','LongInt').SetInt( 16);
 CL.AddConstantN('vmtSelfPtr','LongInt').SetInt( - 76);
 CL.AddConstantN('vmtIntfTable','LongInt').SetInt( - 72);
 CL.AddConstantN('vmtAutoTable','LongInt').SetInt( - 68);
 CL.AddConstantN('vmtInitTable','LongInt').SetInt( - 64);
 CL.AddConstantN('vmtTypeInfo','LongInt').SetInt( - 60);
 CL.AddConstantN('vmtFieldTable','LongInt').SetInt( - 56);
 CL.AddConstantN('vmtMethodTable','LongInt').SetInt( - 52);
 CL.AddConstantN('vmtDynamicTable','LongInt').SetInt( - 48);
 CL.AddConstantN('vmtClassName','LongInt').SetInt( - 44);
 CL.AddConstantN('vmtInstanceSize','LongInt').SetInt( - 40);
 CL.AddConstantN('vmtParent','LongInt').SetInt( - 36);


 //LANG_SYSTEM_DEFAULT   = (SUBLANG_SYS_DEFAULT shl 10) or LANG_NEUTRAL;
  //{$EXTERNALSYM LANG_SYSTEM_DEFAULT}
  //LANG_USER_DEFAULT     = (SUBLANG_DEFAULT shl 10) or LANG_NEUTRAL;

 CL.AddConstantN('LOCALE_SYSTEM_DEFAULT','Longint').SetInt((SORT_DEFAULT shl 16) or LANG_SYSTEM_DEFAULT);
  //{$EXTERNALSYM LOCALE_SYSTEM_DEFAULT}
 CL.AddConstantN('LOCALE_USER_DEFAULT','Longint').SetInt((SORT_DEFAULT shl 16) or LANG_USER_DEFAULT);


  {HRSRC = THandle;
  TResourceHandle = HRSRC;   // make an opaque handle type
  HINST = THandle;
  HMODULE = HINST;
  HGLOBAL = THandle; }

  //CL.AddTypeS('mUINT64','Uint64');      //3.6.3.
  CL.AddTypeS('HRSCR','THandle');
  CL.AddTypeS('TResourceHandle','HRSCR');
  CL.AddTypeS('HMODULE','THandle');
  CL.AddTypeS('HINST','THandle');
  CL.AddTypeS('HFONT','LongWord');

  CL.AddTypeS('HGLOBAL','THandle');
  CL.AddTypeS('ATOM','Word');

  CL.AddTypeS('HWND','LongWord');
  CL.AddTypeS('HMETAFILE','LongWord');
  CL.AddTypeS('HBITMAP','LongWord');
  CL.AddTypeS('HDC','LongWord');
  CL.AddTypeS('HCURSOR','LongWord');
  CL.AddTypeS('HBRUSH','LongWord');
  CL.AddTypeS('HICON','LongWord');
  CL.AddTypeS('HPALETTE','LongWord');
  CL.AddTypeS('HRSRC','LongWord'); //Windows resource
  CL.AddTypeS('HKL','LongWord');   //keyboard layout
  CL.AddTypeS('HKEY','LongWord');   //win reg layout
  CL.AddTypeS('HFILE','LongWord'); //A handle to an open file
  CL.AddTypeS('HGDIOBJ','LongWord'); //a GDI object. Pens, device contexts, brushes, etc.
  CL.AddTypeS('LPARAM','LongInt');
  CL.AddTypeS('WPARAM','LongInt');
  CL.AddTypeS('LRESULT','Longint');
  CL.AddTypeS('ULONG','Longint');
  CL.AddTypeS('UINT','Integer');
  CL.AddTypeS('UCHAR','Byte');
  CL.AddTypeS('BOOL','LongBool');  //long !
  CL.AddTypeS('SHORT','SmallInt');
  CL.AddTypeS('LCID','DWord');   //A local identifier
  CL.AddTypeS('TColorRef','DWORD');

  CL.AddTypeS('LANGID','Word');  //A language identifier
  //CL.AddTypeS('RT_RCDATA','Types.RT_RCDATA'); //MakeIntResource(10);
  CL.AddTypeS('RT_RCDATA','PChar(10)'); //MakeIntResource(10);
  CL.AddTypeS('RT_CURSOR','PChar(1)'); //MakeIntResource(10);
  CL.AddTypeS('RT_BITMAP','PChar(2)'); //MakeIntResource(10);
  CL.AddTypeS('RT_ICON','PChar(3)'); //MakeIntResource(10);
  CL.AddTypeS('RT_STRING','PChar(6)'); //MakeIntResource(10);
  CL.AddTypeS('RT_FONT','PChar(8)'); //MakeIntResource(10);
  CL.AddTypeS('RT_DIALOG','PChar(5)'); //MakeIntResource(10);
  CL.AddTypeS('RT_MESSAGETABLE','PChar(11)'); //MakeIntResource(10);
  CL.AddTypeS('TMsg', 'record hwnd: HWND; wParam: WPARAM; lParam: LPARAM;'
    +'time: DWORD; pt: TPoint; end');
   {tagMSG = packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
    pt: TPoint;
  end;}
  //3.8.2
  CL.AddTypeS('TFloatRec','record Exponent: Smallint; Negative: Boolean; Digits: array[0..20] of Char; end');

  //LPARAM      Longint;    A 32-bit message parameter
  //LRESULT     Longint;    A 32-bit function return value
  //CL.AddTypeS('MakeIntResource','PANSIChar');

  //CL.AddTypeS('THexArray', 'array[0..15] of char;');
  //CL.AddTypeS('TIntegerSet', 'set of Integer');
  //CL.AddTypeS('PByteArray', '^TByteArray // will not work');
  //CL.AddTypeS('PWordArray', '^TWordArray // will not work');
  //CL.AddTypeS('TFileName', 'type string');
  CL.AddTypeS('TFileName', 'string');
  CL.AddTypeS('Text', 'File of char');
  //CL.addTypeS('CmdLine', 'PChar');
  CL.AddClassN(CL.FindClass('TPersistent'),'TGraphic');
  CL.AddClassN(CL.FindClass('Class of TForm'),'TFormClass');   //3.8
  //CL.AddTypeS('TGraphic','Class');
  //CL.AddTypeS('TGraphicClass','Class of TGraphic');

 //CL.AddTypeS('TSearchRec', 'record Time : Integer; Size : Integer; Attr : Integer;'
  // +' Name : TFileName; ExcludeAttr : Integer; end');
  CL.AddTypeS('TFloatValue', '( fvExtended, fvCurrency )');
  CL.AddTypeS('TFloatFormat', '( ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency )');
  //CL.AddTypeS('TTimeStamp', 'record Time : Integer; Date : Integer; end');
  CL.AddTypeS('TWordArray', 'array[0..16383] of Word;');
  CL.AddTypeS('TByteArray', 'array[0..32767] of Byte;');
  Cl.AddTypeS('TRect2', 'record TopLeft, BottomRight: TPoint; end;'); //3.8

  //CL.AddTypeS('TFontCharset','0..255');  // from sysutils                                               tfontcharset
   CL.AddTypeS('marrstr', 'array of string;');


  //CL.AddTypeS('Tdnames', 'array[1..7] of string;');
  //CL.AddTypeS('Tmnames','array[1..12] of string;');
  CL.AddTypeS('TDayNames', 'array[1..7] of string');
  CL.AddTypeS('TMonthNames', 'array[1..12] of string');

  CL.AddTypeS('TStreamOriginalFormat','(sofUnknown, sofBinary, sofText)');

  CL.AddTypeS('TMbcsByteType', '( mbSingleByte, mbLeadByte, mbTrailByte )');
  SIRegister_TLanguages(CL);
  CL.AddTypeS('TEraRange', 'record StartDate : Integer; EndDate : Integer; end');
  SIRegister_Exception(CL);
  //CL.AddTypeS('ExceptClass', 'class of Exception');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TClass');
   CL.AddClassN(CL.FindClass('TOBJECT'),'EAbort');
  SIRegister_EHeapException(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOutOfMemory');
  SIRegister_EInOutError(CL);
  //CL.AddTypeS('PExceptionRecord', '^TExceptionRecord // will not work');
  SIRegister_EExternal(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EExternalException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIntError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EDivByZero');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ERangeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIntOverflow');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMathError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidOp');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EZeroDivide');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOverflow');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EUnderflow');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidPointer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidCast');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EConvertError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAccessViolation');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPrivilege');
  SIRegister_EStackOverflow(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EControlC');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropReadOnly');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropWriteOnly');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAssertionFailed');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIntfCastError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidContainer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidInsert');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPackageError');
  SIRegister_EOSError(CL);
  SIRegister_EWin32Error(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESafecallException');
  CL.AddTypeS('TSignalState', '( ssNotHooked, ssHooked, ssOverridden )');
 CL.AddConstantN('MAX_PATH','LongInt').SetInt( 4095);
 CL.AddConstantN('Win32Platform','Integer').SetInt( 0);
 CL.AddConstantN('Win32MajorVersion','Integer').SetInt( 0);
 CL.AddConstantN('Win32MinorVersion','Integer').SetInt( 0);
 CL.AddConstantN('Win32BuildNumber','Integer').SetInt( 0);
 CL.AddConstantN('Win32CSDVersion','string').SetString( '');
 CL.AddDelphiFunction('Function CheckWin32Version( AMajor : Integer; AMinor : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetFileVersion( AFileName : string) : Cardinal');
  CL.AddTypeS('MaxEraCount', 'Integer');
 CL.AddDelphiFunction('Function Languages : TLanguages');
 //CL.AddDelphiFunction('Function AllocMem( Size : Cardinal) : Pointer');
 //CL.AddDelphiFunction('Procedure AddExitProc( Proc : TProcedure)');
 //CL.AddDelphiFunction('Function NewStr( S : string) : PString');
 //CL.AddDelphiFunction('Procedure DisposeStr( P : PString)');
 //CL.AddDelphiFunction('Procedure AssignStr( var P : PString; S : string)');
 CL.AddDelphiFunction('Procedure AppendStr( var Dest : string; S : string)');
 CL.AddDelphiFunction('Function UpperCase( S : string) : string');
 CL.AddDelphiFunction('Function LowerCase( S : string) : string');
 CL.AddDelphiFunction('Function CompareStr( S1, S2 : string) : Integer');
 //CL.AddDelphiFunction('Function CompareMem( P1, P2 : Pointer; Length : Integer) : Boolean');
 CL.AddDelphiFunction('Function CompareText( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function SameText( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiUpperCase( S : string) : string');
 CL.AddDelphiFunction('Function AnsiLowerCase( S : string) : string');
 CL.AddDelphiFunction('Function AnsiCompareStr( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function AnsiSameStr( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiCompareText( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function AnsiSameText( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiStrComp( S1, S2 : PChar) : Integer');
 CL.AddDelphiFunction('Function AnsiStrIComp( S1, S2 : PChar) : Integer');
 CL.AddDelphiFunction('Function AnsiStrLComp( S1, S2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function AnsiStrLIComp( S1, S2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function AnsiStrLower( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function AnsiStrUpper( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function AnsiLastChar( S : string) : PChar');
 CL.AddDelphiFunction('Function AnsiStrLastChar( P : PChar) : PChar');
 CL.AddDelphiFunction('Function WideUpperCase( S : WideString) : WideString');
 CL.AddDelphiFunction('Function WideLowerCase( S : WideString) : WideString');
 CL.AddDelphiFunction('Function WideCompareStr( S1, S2 : WideString) : Integer');
 CL.AddDelphiFunction('Function WideSameStr( S1, S2 : WideString) : Boolean');
 CL.AddDelphiFunction('Function WideCompareText( S1, S2 : WideString) : Integer');
 CL.AddDelphiFunction('Function WideSameText( S1, S2 : WideString) : Boolean');
 CL.AddDelphiFunction('Function Trim( S : string) : string;');
 CL.AddDelphiFunction('Function Trim( S : WideString) : WideString;');
 CL.AddDelphiFunction('Function TrimLeft( S : string) : string;');
 CL.AddDelphiFunction('Function TrimLeft( S : WideString) : WideString;');
 CL.AddDelphiFunction('Function TrimRight( S : string) : string;');
 CL.AddDelphiFunction('Function TrimRight( S : WideString) : WideString;');
 CL.AddDelphiFunction('Function QuotedStr( S : string) : string');
 CL.AddDelphiFunction('Function AnsiQuotedStr( S : string; Quote : Char) : string');
 CL.AddDelphiFunction('Function AnsiExtractQuotedStr( var Src : PChar; Quote : Char) : string');
 CL.AddDelphiFunction('Function AnsiDequotedStr( S : string; AQuote : Char) : string');
 CL.AddDelphiFunction('Function IsValidIdent( Ident : string) : Boolean');
// CL.AddDelphiFunction('Function IntToStr( Value : Integer) : string;');
// CL.AddDelphiFunction('Function IntToStr( Value : Int64) : string;');
 CL.AddDelphiFunction('Function IntToHex( Value : Integer; Digits : Integer) : string;');
 CL.AddDelphiFunction('Function IntToHex64( Value : Int64; Digits : Integer) : string;');
 CL.AddDelphiFunction('Function StrToInt( S : string) : Integer');
 CL.AddDelphiFunction('Function StrToIntDef( S : string; Default : Integer) : Integer');
 CL.AddDelphiFunction('Function StrToInt64( S : string) : Int64');
 CL.AddDelphiFunction('Function StrToInt64Def( S : string; Default : Int64) : Int64');
 CL.AddDelphiFunction('Function StrToBool( S : string) : Boolean');
 CL.AddDelphiFunction('Function StrToBoolDef( S : string; Default : Boolean) : Boolean');
 CL.AddDelphiFunction('Function LoadStr( Ident : Integer) : string');
 CL.AddDelphiFunction('function FindStringResource(Ident: Integer): string)');
 CL.AddDelphiFunction('Function FileOpen( FileName : string; Mode : LongWord) : Integer');
 CL.AddDelphiFunction('Function FileCreate( FileName : string) : Integer;');
 //CL.AddDelphiFunction('Function FileCreate( FileName : string; Rights : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSeek( Handle, Offset, Origin : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSeek( Handle : Integer; Offset : Int64; Origin : Integer) : Int64;');
 CL.AddDelphiFunction('Procedure FileClose( Handle : Integer)');
 CL.AddDelphiFunction('Function FileAge( FileName : string) : Integer');
 CL.AddDelphiFunction('Function FileExists( FileName : string) : Boolean');
 CL.AddDelphiFunction('Function DirectoryExists( Directory : string) : Boolean');
 CL.AddDelphiFunction('Function ForceDirectories( Dir : string) : Boolean');
 //CL.AddDelphiFunction('Function FindFirst( Path : string; Attr : Integer; var F : TSearchRec) : Integer');
 //CL.AddDelphiFunction('Function FindNext( var F : TSearchRec) : Integer');
 //CL.AddDelphiFunction('Procedure FindClose( var F : TSearchRec)');
 CL.AddDelphiFunction('Procedure AssignFile(var F: Text; FileName: string)');
 CL.AddDelphiFunction('Procedure CloseFile(var F: Text);');
 CL.AddDelphiFunction('Function Flush(var t: Text): Integer');

 CL.AddDelphiFunction('Function FileGetDate( Handle : Integer) : Integer');
 CL.AddDelphiFunction('Function FileSetDate(FileName : string; Age : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSetDate2(FileHandle : Integer; Age : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSetDateH( Handle : Integer; Age : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileGetAttr( FileName : string) : Integer');
 CL.AddDelphiFunction('Function FileSetAttr( FileName : string; Attr : Integer) : Integer');
 CL.AddDelphiFunction('Function FileIsReadOnly( FileName : string) : Boolean');
 CL.AddDelphiFunction('Function FileSetReadOnly( FileName : string; ReadOnly : Boolean) : Boolean');
 //CL.AddDelphiFunction('Function DeleteFile( FileName : string) : Boolean');
 CL.AddDelphiFunction('Function RenameFile( OldName, NewName : string) : Boolean');
 CL.AddDelphiFunction('Function ChangeFileExt( FileName, Extension : string) : string');
 CL.AddDelphiFunction('Function ExtractFilePath( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileDir( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileDrive( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileExt( FileName : string) : string');
 CL.AddDelphiFunction('Function ExpandFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function ExpandUNCFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractRelativePath( BaseName, DestName : string) : string');
 CL.AddDelphiFunction('Function ExtractShortPathName( FileName : string) : string');
 CL.AddDelphiFunction('Function FileSearch( Name, DirList : string) : string');
 CL.AddDelphiFunction('Function DiskFree( Drive : Byte) : Int64');
 CL.AddDelphiFunction('Function DiskSize( Drive : Byte) : Int64');
 CL.AddDelphiFunction('Function FileDateToDateTime( FileDate : Integer) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToFileDate( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function GetCurrentDir : string');
 CL.AddDelphiFunction('Function SetCurrentDir( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function CreateDir( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function RemoveDir( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function StrLen( Str : PChar) : Cardinal');
 CL.AddDelphiFunction('Function StrEnd( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrMove( Dest : PChar; Source : PChar; Count : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrCopy( Dest : PChar; Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrECopy( Dest : PChar; Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLCopy( Dest : PChar; Source : PChar; MaxLen : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrPCopy( Dest : PChar; Source : string) : PChar');
 CL.AddDelphiFunction('Function StrPLCopy( Dest : PChar; Source : string; MaxLen : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrCat( Dest : PChar; Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLCat( Dest : PChar; Source : PChar; MaxLen : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrComp( Str1, Str2 : PChar) : Integer');
 CL.AddDelphiFunction('Function StrIComp( Str1, Str2 : PChar) : Integer');
 CL.AddDelphiFunction('Function StrLComp( Str1, Str2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function StrLIComp( Str1, Str2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function StrPos( Str1, Str2 : PChar) : PChar');
 CL.AddDelphiFunction('Function StrUpper( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLower( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrPas( Str : PChar) : string');
 CL.AddDelphiFunction('Function StrAlloc( Size : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrBufSize( Str : PChar) : Cardinal');
 CL.AddDelphiFunction('Function StrNew( Str : PChar) : PChar');
 CL.AddDelphiFunction('Procedure StrDispose( Str : PChar)');
 CL.AddDelphiFunction('Function FloatToStr( Value : Extended) : string;');
 //CL.AddDelphiFunction('Function FloatToStrFS( Value : Extended; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function CurrToStr( Value : Currency) : string;');
 CL.AddDelphiFunction('Function CurrToStrF( Value : Currency; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function FloatToCurr( Value : Extended) : Currency');
 CL.AddDelphiFunction('Function FloatToStrF( Value : Extended; Format : TFloatFormat; Precision, Digits : Integer) : string;');
 CL.AddDelphiFunction('Function FloatToStrFS( Value : Extended; Format : TFloatFormat; Precision, Digits : Integer; FormatSettings : TFormatSettings) : string;');
 //CL.AddDelphiFunction('Function CurrToStrF( Value : Currency; Format : TFloatFormat; Digits : Integer) : string;');
 //CL.AddDelphiFunction('Function CurrToStrF( Value : Currency; Format : TFloatFormat; Digits : Integer; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function FormatFloat( Format : string; Value : Extended) : string;');
 //CL.AddDelphiFunction('Function FormatFloat( Format : string; Value : Extended; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function FormatCurr( Format : string; Value : Currency) : string;');
 //CL.AddDelphiFunction('Function FormatCurr( Format : string; Value : Currency; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function StrToFloat( S : string) : Extended;');
 //CL.AddDelphiFunction('Function StrToFloat( S : string; FormatSettings : TFormatSettings) : Extended;');
 CL.AddDelphiFunction('Function StrToFloatDef( S : string; Default : Extended) : Extended;');
 //CL.AddDelphiFunction('Function StrToFloatDef( S : string; Default : Extended; FormatSettings : TFormatSettings) : Extended;');
 CL.AddDelphiFunction('Function StrToCurr( S : string) : Currency;');
 //CL.AddDelphiFunction('Function StrToCurr( S : string; FormatSettings : TFormatSettings) : Currency;');
 CL.AddDelphiFunction('Function StrToCurrDef( S : string; Default : Currency) : Currency;');
 //CL.AddDelphiFunction('Function StrToCurrDef( S : string; Default : Currency; FormatSettings : TFormatSettings) : Currency;');
 CL.AddDelphiFunction('Function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp');
 CL.AddDelphiFunction('Function TimeStampToDateTime(const TimeStamp: TTimeStamp): TDateTime');
 CL.AddDelphiFunction('Function MSecsToTimeStamp( MSecs : Comp) : TTimeStamp');
 CL.AddDelphiFunction('Function TimeStampToMSecs( TimeStamp : TTimeStamp) : Comp');
 CL.AddDelphiFunction('Function EncodeDate( Year, Month, Day : Word) : TDateTime');
 CL.AddDelphiFunction('Function EncodeTime( Hour, Min, Sec, MSec : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure DecodeDate( DateTime : TDateTime; var Year, Month, Day : Word)');
 CL.AddDelphiFunction('Function DecodeDateFully( DateTime : TDateTime; var Year, Month, Day, DOW : Word) : Boolean');
 CL.AddDelphiFunction('Function InternalDecodeDate( DateTime : TDateTime; var Year, Month, Day, DOW : Word) : Boolean');
 CL.AddDelphiFunction('Procedure DecodeTime( DateTime : TDateTime; var Hour, Min, Sec, MSec : Word)');
 CL.AddDelphiFunction('Procedure DateTimeToSystemTime( DateTime : TDateTime; var SystemTime : TSystemTime)');
 CL.AddDelphiFunction('Function SystemTimeToDateTime( SystemTime : TSystemTime) : TDateTime');
 CL.AddDelphiFunction('Function DayOfWeek( DateTime : TDateTime) : Word');
 CL.AddDelphiFunction('Function Date : TDateTime');
 CL.AddDelphiFunction('Function Time : TDateTime');
 CL.AddDelphiFunction('Function GetTime : TDateTime');
 CL.AddDelphiFunction('Function Now : TDateTime');
 CL.AddDelphiFunction('Function CurrentYear : Word');
 CL.AddDelphiFunction('Function IncMonth( DateTime : TDateTime; NumberOfMonths : Integer) : TDateTime');
 CL.AddDelphiFunction('Procedure IncAMonth( var Year, Month, Day : Word; NumberOfMonths : Integer)');
 CL.AddDelphiFunction('Procedure ReplaceTime( var DateTime : TDateTime; NewTime : TDateTime)');
 CL.AddDelphiFunction('Procedure ReplaceDate( var DateTime : TDateTime; NewDate : TDateTime)');
 CL.AddDelphiFunction('Function IsLeapYear( Year : Word) : Boolean');
 CL.AddDelphiFunction('Function DateToStr( DateTime : TDateTime) : string;');
 //CL.AddDelphiFunction('Function DateToStr( DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function TimeToStr( DateTime : TDateTime) : string;');
 //CL.AddDelphiFunction('Function TimeToStr( DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function DateTimeToStr( DateTime : TDateTime) : string;');
 //CL.AddDelphiFunction('Function DateTimeToStr( DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function StrToDate( S : string) : TDateTime;');
 //CL.AddDelphiFunction('Function StrToDate( S : string; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDateDef( S : string; Default : TDateTime) : TDateTime;');
 //CL.AddDelphiFunction('Function StrToDateDef( S : string; Default : TDateTime; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function TryStrToDate( S : string; Value : TDateTime) : Boolean;');
 //CL.AddDelphiFunction('Function TryStrToDate( S : string; Value : TDateTime; FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function StrToTime( S : string) : TDateTime;');
 //CL.AddDelphiFunction('Function StrToTime( S : string; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function StrToTimeDef( S : string; Default : TDateTime) : TDateTime;');
 //CL.AddDelphiFunction('Function StrToTimeDef( S : string; Default : TDateTime; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function TryStrToTime( S : string; Value : TDateTime) : Boolean;');
 //CL.AddDelphiFunction('Function TryStrToTime( S : string; Value : TDateTime; FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function StrToDateTime( S : string) : TDateTime;');
 //CL.AddDelphiFunction('Function StrToDateTime( S : string; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDateTimeDef( S : string; Default : TDateTime) : TDateTime;');
 //CL.AddDelphiFunction('Function StrToDateTimeDef( S : string; Default : TDateTime; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function TryStrToDateTime( S : string; Value : TDateTime) : Boolean;');
 //CL.AddDelphiFunction('Function TryStrToDateTime( S : string; Value : TDateTime; FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function FormatDateTime( Format : string; DateTime : TDateTime) : string;');
 //CL.AddDelphiFunction('Function FormatDateTime( Format : string; DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Procedure DateTimeToString( var Result : string; Format : string; DateTime : TDateTime);');
 //CL.AddDelphiFunction('Procedure DateTimeToString( var Result : string; Format : string; DateTime : TDateTime; FormatSettings : TFormatSettings);');
 CL.AddDelphiFunction('Function FloatToDateTime( Value : Extended) : TDateTime');
 CL.AddDelphiFunction('Function TryFloatToDateTime( Value : Extended; AResult : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SysErrorMessage( ErrorCode : Integer) : string');
 CL.AddDelphiFunction('Function GetLocaleStr( Locale, LocaleType : Integer; Default : string) : string');
 CL.AddDelphiFunction('Function GetLocaleChar( Locale, LocaleType : Integer; Default : Char) : Char');
 CL.AddDelphiFunction('Procedure GetFormatSettings');
 CL.AddDelphiFunction('Procedure GetLocaleFormatSettings( LCID : Integer; var FormatSettings : TFormatSettings)');
 CL.AddDelphiFunction('Function InquireSignal( RtlSigNum : Integer) : TSignalState');
 CL.AddDelphiFunction('Procedure AbandonSignalHandler( RtlSigNum : Integer)');
 CL.AddDelphiFunction('Procedure HookSignal( RtlSigNum : Integer)');
 CL.AddDelphiFunction('Procedure UnhookSignal( RtlSigNum : Integer; OnlyIfHooked : Boolean)');
 CL.AddDelphiFunction('Procedure HookOSExceptions');
 //CL.AddDelphiFunction('Function MapSignal( SigNum : Integer; Context : PSigContext) : LongWord');
 CL.AddDelphiFunction('Procedure SignalConverter( ExceptionEIP : LongWord; FaultAddr : LongWord; ErrorCode : LongWord)');
 CL.AddDelphiFunction('Procedure SetSafeCallExceptionMsg( Msg : String)');
 //CL.AddDelphiFunction('Procedure SetSafeCallExceptionAddr( Addr : Pointer)');
 CL.AddDelphiFunction('Function GetSafeCallExceptionMsg : String');
 //CL.AddDelphiFunction('Function GetSafeCallExceptionAddr : Pointer');
 //CL.AddDelphiFunction('Function LoadLibrary( ModuleName : PChar) : HMODULE');
 //CL.AddDelphiFunction('Function FreeLibrary( Module : HMODULE) : LongBool');
 //CL.AddDelphiFunction('Function GetProcAddress( Module : HMODULE; Proc : PChar) : Pointer');
 CL.AddDelphiFunction('Function GetModuleHandle( ModuleName : PChar) : HMODULE');
 CL.AddDelphiFunction('Function GetPackageModuleHandle( PackageName : PChar) : HMODULE');
 CL.AddDelphiFunction('Procedure Sleep( milliseconds : Cardinal)');
 CL.AddDelphiFunction('Function GetModuleName( Module : HMODULE) : string');
 //CL.AddDelphiFunction('Function ExceptionErrorMessage( ExceptObject : TObject; ExceptAddr : Pointer; Buffer : PChar; Size : Integer) : Integer');
 //CL.AddDelphiFunction('Procedure ShowException( ExceptObject : TObject; ExceptAddr : Pointer)');
 CL.AddDelphiFunction('Procedure Abort');
 CL.AddDelphiFunction('Procedure OutOfMemoryError');
 CL.AddDelphiFunction('Procedure FPower10');
 CL.AddDelphiFunction('Procedure Halt');
 CL.AddDelphiFunction('Procedure RunError(errorcode: byte)');
 CL.AddDelphiFunction('Function EOF: boolean');
 CL.AddDelphiFunction('Function EOln: boolean');
 CL.AddDelphiFunction('function IOResult: Integer');
 CL.AddDelphiFunction('function GetLastError: Integer');
 CL.AddDelphiFunction('procedure SetLastError(ErrorCode: Integer)');
 CL.AddDelphiFunction('function IsMemoryManagerSet: Boolean)');    //3.6
 CL.AddDelphiFunction('function IsConsole: Boolean)');
 CL.AddDelphiFunction('function IsLibrary: Boolean)');
 CL.AddDelphiFunction('function IsMultiThread: Boolean)');
 CL.AddDelphiFunction('Function Output: Text)');
 CL.AddDelphiFunction('Function Input: Text)');
 CL.AddDelphiFunction('Function ErrOutput: Text)');
 CL.AddDelphiFunction('function HiByte(W: Word): Byte)');
 CL.AddDelphiFunction('function HiWord(l: DWORD): Word)');
 CL.AddDelphiFunction('function MakeWord(A, B: Byte): Word)');
 CL.AddDelphiFunction('function MakeLong(A, B: Word): Longint)');

 CL.AddDelphiFunction('function getLongDayNames: string)');
 CL.AddDelphiFunction('function getShortDayNames: string)');
 CL.AddDelphiFunction('function getLongMonthNames: string)');
 CL.AddDelphiFunction('function getShortMonthNames: string)');

  //CL.AddDelphiFunction('function Slice(var A: array; Count: Integer): array');
 //function StringOfChar(ch: AnsiChar; Count: Integer): AnsiString; overload;
 //CL.AddDelphiFunction('Procedure Beep');
 CL.AddDelphiFunction('Function ByteType( S : string; Index : Integer) : TMbcsByteType');
 CL.AddDelphiFunction('Function StrByteType( Str : PChar; Index : Cardinal) : TMbcsByteType');
 CL.AddDelphiFunction('Function ByteToCharLen( S : string; MaxLen : Integer) : Integer');
 CL.AddDelphiFunction('Function CharToByteLen( S : string; MaxLen : Integer) : Integer');
 CL.AddDelphiFunction('Function ByteToCharIndex( S : string; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function CharToByteIndex( S : string; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function StrCharLength( Str : PChar) : Integer');
 CL.AddDelphiFunction('Function StrNextChar( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function CharLength( S : String; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function NextCharIndex( S : String; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function IsPathDelimiter( S : string; Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function IsDelimiter( Delimiters, S : string; Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function IncludeTrailingPathDelimiter( S : string) : string');
 CL.AddDelphiFunction('Function IncludeTrailingBackslash( S : string) : string');
 CL.AddDelphiFunction('Function ExcludeTrailingPathDelimiter( S : string) : string');
 CL.AddDelphiFunction('Function ExcludeTrailingBackslash( S : string) : string');
 CL.AddDelphiFunction('Function LastDelimiter( Delimiters, S : string) : Integer');
 CL.AddDelphiFunction('Function AnsiCompareFileName( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function SameFileName( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiLowerCaseFileName( S : string) : string');
 CL.AddDelphiFunction('Function AnsiUpperCaseFileName( S : string) : string');
 CL.AddDelphiFunction('Function AnsiPos( Substr, S : string) : Integer');
 CL.AddDelphiFunction('Function AnsiStrPos( Str, SubStr : PChar) : PChar');
 CL.AddDelphiFunction('Function StringReplace( S, OldPattern, NewPattern : string; Flags : TReplaceFlags) : string');
 CL.AddDelphiFunction('Function WrapText( Line, BreakStr : string; BreakChars : TSysCharSet; MaxCol : Integer) : string;');
 CL.AddDelphiFunction('Function WrapText( Line : string; MaxCol : Integer) : string;');
 CL.AddDelphiFunction('Function FindCmdLineSwitch( Switch : string; Chars : TSysCharSet; IgnoreCase : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function FindCmmdLineSwitch( Switch : string) : Boolean;');
 CL.AddDelphiFunction('Function FindCdLineSwitch( Switch : string; IgnoreCase : Boolean) : Boolean;');

 //CL.AddDelphiFunction('Function CmdLine( Switch : string; IgnoreCase : Boolean) : Boolean;');
 CL.AddDelphiFunction('Procedure RaiseLastOSError');
 //from unit filectrl
 {procedure ProcessPath (const EditText: string; var Drive: Char;
  var DirPart: string; var FilePart: string);}
 CL.AddDelphiFunction('Procedure ProcessPath(const EditText: string; var Drive: Char; var DirPart: string; var FilePart: string);');
 CL.AddDelphiFunction('Procedure ProcessPath1(const EditText: string; var Drive: Char; var DirPart: string; var FilePart: string);');
 CL.AddDelphiFunction('function SlashSep(const Path, S: String): String');
 CL.AddDelphiFunction('procedure CutFirstDirectory(var S: String)');
 CL.AddDelphiFunction('function MinimizeName(const Filename: String; Canvas: TCanvas;MaxLen: Integer): TFileName');
 CL.AddDelphiFunction('function VolumeID(DriveChar: Char): string');
 CL.AddDelphiFunction('function NetworkVolume(DriveChar: Char): string');

 //var prototypes func
 CL.AddDelphiFunction('function randSeed: longint');
 CL.AddDelphiFunction('function currencyString: String');
 CL.AddDelphiFunction('function currencyDecimals: Byte');
 CL.AddDelphiFunction('function currencyFormat: Byte');
 CL.AddDelphiFunction('function MainInstance: longword');
 CL.AddDelphiFunction('function MainThreadID: longword');
 CL.AddDelphiFunction('function TrueBoolStrs: array of string');
 CL.AddDelphiFunction('function FalseBoolStrs: array of string');
 CL.AddDelphiFunction('function LeadBytes: set of char');  //TForLeadBytes

 //cl.AddVariable(trueboolstrs, array of string)

 { Object conversion routines of unit classes}
CL.AddDelphiFunction('procedure ObjectBinaryToText(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectBinaryToText1(Input, Output: TStream;'
  +'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('procedure ObjectTextToBinary(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectTextToBinary1(Input, Output: TStream;'+
  'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('procedure ObjectResourceToText(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectResourceToText1(Input, Output: TStream;'+
  'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('procedure ObjectTextToResource(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectTextToResource1(Input, Output: TStream;'+
  'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('function TestStreamFormat(Stream: TStream): TStreamOriginalFormat');

{ Utility routines of unit classes}
CL.AddDelphiFunction('function LineStart(Buffer, BufPos: PChar): PChar');
CL.AddDelphiFunction('function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar;'+
  'Strings: TStrings): Integer');

//procedure BinToHex(Buffer, Text: PChar; BufSize: Integer);
//function HexToBin(Text, Buffer: PChar; BufSize: Integer): Integer;
//function FindRootDesigner(Obj: TPersistent): IDesignerNotify;

{ CountGenerations:  Use this helper function to calculate the distance
  between two related classes.  Returns -1 if Descendent is not a descendent of
  Ancestor. }

CL.AddDelphiFunction('function CountGenerations(Ancestor,Descendent: TClass): Integer');

{  Call CheckSynchronize periodically within the main thread in order for
   background threads to synchronize execution with the main thread.  This
   is mainly for applications that have an event driven UI such as Windows
   or XWindows (Qt/CLX).  The best place this can be called is during Idle
   processing.  This guarantees that the main thread is in a known "good"
   state so that method calls can be safely made.  Returns True if a method
   was synchronized.  Returns False if there was nothing done.
}
CL.AddDelphiFunction('function CheckSynchronize(Timeout: Integer): Boolean');
//CL.AddDelphiFunction('function FindObjects(AClass: TClass; FindDerived: Boolean): TObjectArray');;

 //functions and procs over units -----------------------------------------
 CL.AddDelphiFunction('Procedure Check(Status: Integer)');
 CL.AddDelphiFunction('Function ColorToRGB(color: TColor): Longint');
 CL.AddDelphiFunction('function ColorToString(Color: TColor): string)');
 CL.AddDelphiFunction('function StringToColor(const S: string): TColor)');
 CL.AddDelphiFunction('function ColorToIdent(Color: Longint; var Ident: string): Boolean)');
 CL.AddDelphiFunction('function IdentToColor(const Ident: string; var Color: Longint): Boolean)');
 CL.AddDelphiFunction('function CharsetToIdent(Charset: Longint; var Ident: string): Boolean)');
 CL.AddDelphiFunction('function IdentToCharset(const Ident: string; var Charset: Longint): Boolean)');

 CL.AddDelphiFunction('Procedure DataBaseError(const Message: string)');
 CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
 CL.AddDelphiFunction('Function GetLongHint(const hint: string): string');
 CL.AddDelphiFunction('Function GetShortHint(const hint: string): string');
 CL.AddDelphiFunction('Function GetParentForm(control: TControl): TForm');
 //CL.AddDelphiFunction('Function GraphicFilter(graphicclass: TGraphicClass): string');
 CL.AddDelphiFunction('Function ValidParentForm(control: TControl): TForm');
 CL.AddDelphiFunction('Function IsAccel(VK: Word; const Str: string): Boolean');
 CL.AddDelphiFunction('Function ForegroundTask: Boolean');
 CL.AddDelphiFunction('Function LoadCursor(hInstance: HINST; lpCursorName: PChar): HCURSOR');

 CL.AddDelphiFunction('function LoadPackage(const Name: string): HMODULE');
 CL.AddDelphiFunction('procedure UnloadLoadPackage(Module: HMODULE)');
 CL.AddDelphiFunction('procedure GetPackageDescription(ModuleName: PChar): string)');
 CL.AddDelphiFunction('procedure InitializePackage(Module: HMODULE)');
 CL.AddDelphiFunction('procedure FinalizePackage(Module: HMODULE)');
 CL.AddDelphiFunction('Function GDAL: LongWord');
 CL.AddDelphiFunction('procedure RCS');
 CL.AddDelphiFunction('procedure RPR');
 CL.AddDelphiFunction('function LoadLibrary(const Name: PChar): HMODULE');
 //CL.AddDelphiFunction('function LoadModule(const Name: PChar): HMODULE');
 CL.AddDelphiFunction('function FreeModule(var hLibModule: HINST): BOOLEAN');
 CL.AddDelphiFunction('function FreeLibrary(Module: HMODULE):boolean');
 CL.AddDelphiFunction('Function GetProcAddress(Module : HMODULE; Proc : PChar): Dword');


//getprocessaddres

 {function BitBlt(
  hdcDest: HDC;     // handle to destination device context
  nXDest,           // x-coordinate of destination rectangle's upper-left corner
  nYDest,           // y-coordinate of destination rectangle's upper-left corner
  nWidth,           // width of destination rectangle
  nHeight: Integer; // height of destination rectangle
  hdcSrc: HDC;      // handle to source device context
  nXSrc,            // x-coordinate of source rectangle's upper-left corner
  nYSrc: Integer;   // y-coordinate of source rectangle's upper-left corner
  dwRop: DWORD      // raster operation code
): Boolean; }
 CL.AddDelphiFunction('Function StretchBlt(hdcDest: HDC; nXDest,nYDest,nWidth, nHeight: Integer; hdcSrc:HDC; nXSrc, nYSrc, sWidth, sHeight: Integer; dwRop: DWORD): Boolean;');
 CL.AddDelphiFunction('Function BitBlt(hdcDest: HDC;nXDest,nYDest,nWidth, nHeight: Integer; hdcSrc:HDC; nXSrc, nYSrc: Integer; dwRop: DWORD): Boolean;');
 CL.AddDelphiFunction('Function StretchBlt(hdcDest: HDC;nXDest,nYDest,nWidth, nHeight: Integer; hdcSrc:HDC; nXSrc, nYSrc: Integer; dwRop: DWORD): Boolean;');
  CL.AddDelphiFunction('Function GetDC(hdwnd: HWND): HDC;');
 CL.AddDelphiFunction('Function ReleaseDC(hdwnd: HWND; hdc: HDC): integer;');
 //procedure Exclude(var S: set of T; I: T);
   //getwindowdc
    //getwindowrect(
 CL.AddConstantN('CPUi386','LongInt').SetInt( 2);        //3.7
 CL.AddConstantN('CPUi486','LongInt').SetInt( 3);
 CL.AddConstantN('CPUPentium','LongInt').SetInt( 4);
 //type
//(*$NODEFINE TTextLineBreakStyle*)
 CL.AddTypeS('TTextLineBreakStyle' ,'(tlbsLF, tlbsCRLF)');

 CL.AddDelphiFunction('Function GetWindowDC(hdwnd: HWND): HDC;');
 CL.AddDelphiFunction('Function GetWindowRect(hwnd: HWND; arect: TRect): Boolean');
 CL.AddDelphiFunction('Function BoolToStr1(value : boolean) : string;');
 CL.AddDelphiFunction('Procedure SetLineBreakStyle( var T : Text; Style : TTextLineBreakStyle)');
 CL.AddDelphiFunction('Procedure Set8087CW( NewCW : Word)');
 CL.AddDelphiFunction('Function Get8087CW : Word');
// CL.AddDelphiFunction('Function WideCharToString( Source : PWideChar) : string');
// CL.AddDelphiFunction('Function WideCharLenToString( Source : PWideChar; SourceLen : Integer) : string');
// CL.AddDelphiFunction('Procedure WideCharToStrVar( Source : PWideChar; var Dest : string)');
// CL.AddDelphiFunction('Procedure WideCharLenToStrVar( Source : PWideChar; SourceLen : Integer; var Dest : string)');
// CL.AddDelphiFunction('Function StringToWideChar( const Source : string; Dest : PWideChar; DestSize : Integer) : PWideChar');

  CL.AddTypeS('UTF8String','String;');
  CL.AddTypeS('UCS4Char', 'LongWord;');
  CL.AddTypeS('UCS4String', 'array of UCS4Char;');
  CL.AddTypeS('IntegerArray','array[0..$effffff] of Integer;');
  CL.AddTypeS('marrastr','array of string;');

  //UCS4Char = type LongWord;
  //UCS4String = array of UCS4Char;

 //CL.AddDelphiFunction('Function PUCS4Chars( const S : UCS4String) : PUCS4Char');
 CL.AddDelphiFunction('Function WideStringToUCS4String( const S : WideString) : UCS4String');
 CL.AddDelphiFunction('Function UCS4StringToWideString( const S : UCS4String) : WideString');
 //CL.AddDelphiFunction('Function UnicodeToUtf8( Dest : PChar; Source : PWideChar; MaxBytes : Integer) : Integer;');
 //CL.AddDelphiFunction('Function Utf8ToUnicode( Dest : PWideChar; Source : PChar; MaxChars : Integer) : Integer;');
 //CL.AddDelphiFunction('Function UnicodeToUtf8( Dest : PChar; MaxDestBytes : Cardinal; Source : PWideChar; SourceChars : Cardinal) : Cardinal;');
 //CL.AddDelphiFunction('Function Utf8ToUnicode( Dest : PWideChar; MaxDestChars : Cardinal; Source : PChar; SourceBytes : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function UTF8Encode( const WS : WideString) : UTF8String');
 CL.AddDelphiFunction('Function UTF8Decode( const S : UTF8String) : WideString');
 CL.AddDelphiFunction('Function AnsiToUtf8( const S : string) : UTF8String');
 CL.AddDelphiFunction('Function Utf8ToAnsi( const S : UTF8String) : string');
 //CL.AddDelphiFunction('Function OleStrToString( Source : PWideChar) : string');
 //CL.AddDelphiFunction('Procedure OleStrToStrVar( Source : PWideChar; var Dest : string)');
 //CL.AddDelphiFunction('Function StringToOleStr( const Source : string) : PWideChar');
  CL.AddTypeS('TRuntimeError', '( reNone, reOutOfMemory, reInvalidPtr, reDivByZ'
   +'ero, reRangeError, reIntOverflow, reInvalidOp, reZeroDivide, reOverflow, r'
   +'eUnderflow, reInvalidCast, reAccessViolation, rePrivInstruction, reControl'
   +'Break, reStackOverflow, reVarTypeCast, reVarInvalidOp, reVarDispatch, reVa'
   +'rArrayCreate, reVarNotArray, reVarArrayBounds, reAssertionFailed, reExtern'
   +'alException, reIntfCastError, reSafeCallError )');
 CL.AddDelphiFunction('Function ModuleCacheID : Cardinal');
 CL.AddDelphiFunction('Procedure InvalidateModuleCache');
 CL.AddDelphiFunction('Procedure SetMultiByteConversionCodePage( CodePage : Integer)');
 CL.AddDelphiFunction('Function _CheckAutoResult( ResultCode : HResult) : HResult');
 CL.AddDelphiFunction('Procedure FPower10');
 CL.AddDelphiFunction('Procedure TextStart');
 CL.AddDelphiFunction('Function CompToDouble( Value : Comp) : Double');
 CL.AddDelphiFunction('Procedure DoubleToComp( Value : Double; var Result : Comp)');
 CL.AddDelphiFunction('Function CompToCurrency( Value : Comp) : Currency');
 CL.AddDelphiFunction('Procedure CurrencyToComp( Value : Currency; var Result : Comp)');
 //CL.AddDelphiFunction('Function StringOfChar1( ch : AnsiChar; Count : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function StringOfChar2( ch : WideChar; Count : Integer) : WideString;');
 CL.AddDelphiFunction('Function AttemptToUseSharedMemoryManager : Boolean');
 CL.AddDelphiFunction('Function ShareMemoryManager : Boolean');
 CL.AddDelphiFunction('Function FindResource( ModuleHandle : HMODULE; ResourceName, ResourceType : PChar) : TResourceHandle');
 CL.AddDelphiFunction('Function LoadResource( ModuleHandle : HMODULE; ResHandle : TResourceHandle) : HGLOBAL');
 CL.AddDelphiFunction('Function SizeofResource( ModuleHandle : HMODULE; ResHandle : TResourceHandle) : Integer');
 CL.AddDelphiFunction('Function LockResource( ResData : HGLOBAL) : ___Pointer');
 CL.AddDelphiFunction('Function UnlockResource( ResData : HGLOBAL) : LongBool');
 CL.AddDelphiFunction('Function FreeResource( ResData : HGLOBAL) : LongBool');
 // from controls
 CL.AddDelphiFunction('function SendAppMessage(Msg: Cardinal; WParam, LParam: Longint): Longint');
 CL.AddDelphiFunction('procedure MoveWindowOrg(DC: HDC; DX, DY: Integer);');
 CL.AddDelphiFunction('function IsDragObject(Sender: TObject): Boolean;');
 CL.AddDelphiFunction('function IsVCLControl(Handle: HWnd): Boolean;');
 CL.AddDelphiFunction('function FindControl(Handle: HWnd): TWinControl;');
 CL.AddDelphiFunction('function FindVCLWindow(const Pos: TPoint): TWinControl;');
 CL.AddDelphiFunction('function FindDragTarget(const Pos: TPoint; AllowDisabled: Boolean): TControl;');
 CL.AddDelphiFunction('function GetCaptureControl: TControl;');
 CL.AddDelphiFunction('procedure SetCaptureControl(Control: TControl);');
 CL.AddDelphiFunction('procedure CancelDrag;');
 CL.AddDelphiFunction('function CursorToString(Cursor: TCursor): string;');
 CL.AddDelphiFunction('function StringToCursor(const S: string): TCursor;');
 //CL.AddDelphiFunction('procedure GetCursorValues(Proc: TGetStrProc);');
 CL.AddDelphiFunction('function CursorToIdent(Cursor: Longint; var Ident: string): Boolean;');
 CL.AddDelphiFunction('function IdentToCursor(const Ident: string; var Cursor: Longint): Boolean;');
 CL.AddDelphiFunction('Procedure PerformEraseBackground(Control: TControl; DC: HDC);');
 CL.AddDelphiFunction('procedure ChangeBiDiModeAlignment(var Alignment: TAlignment);');

 CL.AddDelphiFunction('function SendMessage(hWnd: HWND; Msg: longword; wParam: longint; lParam: longint): Boolean;');
 CL.AddDelphiFunction('function PostMessage(hWnd: HWND; Msg: longword; wParam: longint; lParam: longint): Boolean;');
 CL.AddDelphiFunction('procedure FloatToDecimal(var Result: TFloatRec; const Value: extended; ValueType: TFloatValue; Precision, Decimals: Integer);');
 CL.AddDelphiFunction('function queryPerformanceCounter(mse: int64): int64;');
 CL.AddDelphiFunction('function QueryPerformanceFrequency(mse: int64): boolean;');

 //SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL;
 //PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL;

 //CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
 //CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
 //CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
   //maxintvalue
 end;

(* === run-time registration functions === *)


function EnumStringModules(Instance: Longint; Data: Pointer): Boolean;
{$IFDEF MSWINDOWS}
var
  Buffer: array [0..1023] of char;
begin
  with PStrData(Data)^ do begin
    SetString(Str, Buffer,
      LoadString(Instance, Ident, Buffer, sizeof(Buffer)));
    Result := Str = '';
  end;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  rs: TResStringRec;
  Module: HModule;
begin
  Module := Instance;
  rs.Module := @Module;
  with PStrData(Data)^ do begin
    rs.Identifier := Ident;
    Str := LoadResString(@rs);
    Result := Str = '';
  end;
end;
{$ENDIF}


function FindStringResource(Ident: Integer): string;
var
  StrData: TStrData;
begin
  StrData.Ident := Ident;
  StrData.Str := '';
  EnumResourceModules(EnumStringModules, @StrData);
  Result := StrData.Str;
end;


function SlashSep(const Path, S: String): String;
begin
  if AnsiLastChar(Path)^ <> '\' then
    Result := Path + '\' + S
  else
    Result := Path + S;
end;

procedure myHalt;
begin
  Halt;
end;

procedure myRunError(errorcode: byte);
begin
  system.runerror(errorcode);
end;

//PROTOTYPES for vars of system and sysutils

function myrandSeed: longint;
begin
  result:= system.randSeed;
end;

function mycurrencyString: String;
begin
  result:= sysutils.CurrencyString;
end;

function mycurrencyDecimals: Byte;
begin
  result:= sysutils.CurrencyDecimals;
end;

function mycurrencyFormat: Byte;
begin
  result:= sysutils.CurrencyFormat;
end;

function mygetwindowrect(hdwnd: HWND; arect: TRect): boolean;
begin
  result:= windows.GetWindowRect(hdwnd, arect);
end;

function myMainInstance: longword;
begin
  result:= system.mainInstance;
end;

function myMainThreadID: longword;
begin
  result:= system.MainThreadID;
end;

function myLeadBytes: TForleadBytes;
begin
  result:= sysutils.LeadBytes;
end;


function myboolstrstrue: marrstr;
begin
  result:= marrstr(sysutils.TrueBoolStrs);
end;

function myboolstrsfalse: marrstr;
begin
  result:= marrstr(sysutils.FalseBoolStrs);
end;


{function myOutput: Text;
begin
  result:= system.Output;
end;

function myInput: Text;
begin
  result:= system.Input;
end;

function myErrOutput: Text;
begin
  result:= system.ErrOutput;
end;}

{function mycmdlineing: String;
begin
  sysutils.CurrencyString;
end;}

{function mycurrencyString: String;
begin
  sysutils.CurrencyString;
end;}

procedure myProcessPath(const EditText: string; var Drive: Char;
  var DirPart: string; var FilePart: string);
begin
  FileCtrl.ProcessPath(EditText, Drive, DirPart, FilePart);
end;


function myEOF: boolean;
begin
  result:= Eof;
end;

function myEOLN: boolean;
begin
  result:= Eoln;
end;


procedure CutFirstDirectory(var S: String);
var
  Root: Boolean;
  P: Integer;
begin
  if S = '\' then
    S := ''
  else begin
    if S[1] = '\' then begin
      Root := True;
      Delete(S, 1, 1);
    end
    else
      Root := False;
    if S[1] = '.' then
      Delete(S, 1, 4);
    P := AnsiPos('\',S);
    if P <> 0 then begin
      Delete(S, 1, P);
      S := '...\' + S;
    end
    else
      S := '';
    if Root then
      S := '\' + S;
  end;
end;

function VolumeID(DriveChar: Char): string;
var
  OldErrorMode: Integer;
  NotUsed, VolFlags: DWORD;
  Buf: array [0..MAX_PATH] of Char;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    Buf[0] := #$00;
    if GetVolumeInformation(PChar(DriveChar + ':\'), Buf, DWORD(sizeof(Buf)),
      nil, NotUsed, VolFlags, nil, 0) then
      SetString(Result, Buf, StrLen(Buf))
    else Result := '';
    if DriveChar < 'a' then
      Result := AnsiUpperCaseFileName(Result)
    else
      Result := AnsiLowerCaseFileName(Result);
    Result := Format('[%s]',[Result]);
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

function NetworkVolume(DriveChar: Char): string;
var
  Buf: Array [0..MAX_PATH] of Char;
  DriveStr: array [0..3] of Char;
  BufferSize: DWORD;
begin
  BufferSize := sizeof(Buf);
  DriveStr[0] := UpCase(DriveChar);
  DriveStr[1] := ':';
  DriveStr[2] := #0;
  if WNetGetConnection(DriveStr, Buf, BufferSize) = WN_SUCCESS then begin
    SetString(Result, Buf, BufferSize);
    if DriveChar < 'a' then
      Result := AnsiUpperCaseFileName(Result)
    else
      Result := AnsiLowerCaseFileName(Result);
  end
  else
    Result := VolumeID(DriveChar);
end;

function CurrToStr1(Value: Currency): string;
var
  Buffer: array[0..63] of Char;
begin
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvCurrency,
    ffGeneral, 0, 0));
end;


function getIsConsole: boolean;
begin
 result:= IsConsole;
end;

function getIsLibrary: boolean;
begin
 result:= IsLibrary;
end;

function getIsMultiThread: boolean;
begin
 result:= IsMultiThread;
end;

{function getLongDayNames: TDayNames;
var i: byte;
begin
  for I:= 1 to 7 do
    result[i]:= result[i] + longdaynames[i];
end;}

function getLongDayNames: string;
var i: byte;
begin
  for I:= 1 to 7 do
    result:= result +','+ longdaynames[i];
end;


function getShortDayNames: string;
var i: byte;
begin
  for I:= 1 to 7 do
    result:= result +','+ shortdaynames[i];
end;

function getLongMonthNames: string;
var i: byte;
begin
  for I:= 1 to 12 do
    result:= result +','+ longmonthnames[i];
end;

function getShortMonthNames: string;
var i: byte;
begin
  for I:= 1 to 12 do
    result:= result +','+ shortmonthnames[i];
end;

function FileSetDateH(Handle: Integer; Age: Integer): Integer;
begin
  result:= FileSetDate(Handle, Age);
end;

Function FloatToStrFS(Value: Extended; Format : TFloatFormat; Precision,
            Digits : Integer; FormatSettings : TFormatSettings): string;
 begin
   result:= FloatToStrF(Value, format, precision, digits, FormatSettings);
 end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function StringOfChar1( ch : WideChar; Count : Integer) : WideString;
Begin Result := System.StringOfChar(ch, Count); END;

(*----------------------------------------------------------------------------*)
Function StringOfChar2( ch : AnsiChar; Count : Integer) : AnsiString;
Begin Result := System.StringOfChar(ch, Count); END;


(*----------------------------------------------------------------------------*)
procedure EOSErrorErrorCode_W(Self: EOSError; const T: DWORD);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EOSErrorErrorCode_R(Self: EOSError; var T: DWORD);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure EInOutErrorErrorCode_W(Self: EInOutError; const T: Integer);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EInOutErrorErrorCode_R(Self: EInOutError; var T: Integer);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionMessage_W(Self: Exception; const T: string);
begin Self.Message := T; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionMessage_R(Self: Exception; var T: string);
begin T := Self.Message; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionHelpContext_W(Self: Exception; const T: Integer);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionHelpContext_R(Self: Exception; var T: Integer);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
Function ExceptionCreateResHelp_P(Self: TClass; CreateNewInstance: Boolean;  ResStringRec : PResStringRec; AHelpContext : Integer):TObject;
Begin Result := Exception.CreateResHelp(ResStringRec, AHelpContext); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
Function ExceptionCreateRes_P(Self: TClass; CreateNewInstance: Boolean;  ResStringRec : PResStringRec):TObject;
Begin Result := Exception.CreateRes(ResStringRec); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure TLanguagesExt_R(Self: TLanguages; var T: string; const t1: Integer);
begin T := Self.Ext[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesLocaleID_R(Self: TLanguages; var T: LCID; const t1: Integer);
begin T := Self.LocaleID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesID_R(Self: TLanguages; var T: string; const t1: Integer);
begin T := Self.ID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesNameFromLCID_R(Self: TLanguages; var T: string; const t1: string);
begin T := Self.NameFromLCID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesNameFromLocaleID_R(Self: TLanguages; var T: string; const t1: LCID);
begin T := Self.NameFromLocaleID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesName_R(Self: TLanguages; var T: string; const t1: Integer);
begin T := Self.Name[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesCount_R(Self: TLanguages; var T: Integer);
begin T := Self.Count; end;

function myIntToHex64(Value: Int64; Digits: Integer): string;
begin
  result:= sysUtils.IntToHex(Value,Digits)
 end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_SysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CheckWin32Version, 'CheckWin32Version', cdRegister);
 S.RegisterDelphiFunction(@GetFileVersion, 'GetFileVersion', cdRegister);
 S.RegisterDelphiFunction(@Languages, 'Languages', cdRegister);
 S.RegisterDelphiFunction(@AllocMem, 'AllocMem', cdRegister);
 S.RegisterDelphiFunction(@AddExitProc, 'AddExitProc', cdRegister);
 S.RegisterDelphiFunction(@NewStr, 'NewStr', cdRegister);
 S.RegisterDelphiFunction(@DisposeStr, 'DisposeStr', cdRegister);
 S.RegisterDelphiFunction(@AssignStr, 'AssignStr', cdRegister);
 S.RegisterDelphiFunction(@AppendStr, 'AppendStr', cdRegister);
 S.RegisterDelphiFunction(@UpperCase, 'UpperCase', cdRegister);
 S.RegisterDelphiFunction(@LowerCase, 'LowerCase', cdRegister);
 S.RegisterDelphiFunction(@CompareStr, 'CompareStr', cdRegister);
 S.RegisterDelphiFunction(@CompareMem, 'CompareMem', cdRegister);
 S.RegisterDelphiFunction(@CompareText, 'CompareText', cdRegister);
 S.RegisterDelphiFunction(@SameText, 'SameText', cdRegister);
 S.RegisterDelphiFunction(@AnsiUpperCase, 'AnsiUpperCase', cdRegister);
 S.RegisterDelphiFunction(@AnsiLowerCase, 'AnsiLowerCase', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareStr, 'AnsiCompareStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiSameStr, 'AnsiSameStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareText, 'AnsiCompareText', cdRegister);
 S.RegisterDelphiFunction(@AnsiSameText, 'AnsiSameText', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrComp, 'AnsiStrComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrIComp, 'AnsiStrIComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLComp, 'AnsiStrLComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLIComp, 'AnsiStrLIComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLower, 'AnsiStrLower', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrUpper, 'AnsiStrUpper', cdRegister);
 S.RegisterDelphiFunction(@AnsiLastChar, 'AnsiLastChar', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLastChar, 'AnsiStrLastChar', cdRegister);
 S.RegisterDelphiFunction(@WideUpperCase, 'WideUpperCase', cdRegister);
 S.RegisterDelphiFunction(@WideLowerCase, 'WideLowerCase', cdRegister);
 S.RegisterDelphiFunction(@WideCompareStr, 'WideCompareStr', cdRegister);
 S.RegisterDelphiFunction(@WideSameStr, 'WideSameStr', cdRegister);
 S.RegisterDelphiFunction(@WideCompareText, 'WideCompareText', cdRegister);
 S.RegisterDelphiFunction(@WideSameText, 'WideSameText', cdRegister);
 S.RegisterDelphiFunction(@Trim, 'Trim', cdRegister);
 S.RegisterDelphiFunction(@Trim, 'Trim', cdRegister);
 S.RegisterDelphiFunction(@TrimLeft, 'TrimLeft', cdRegister);
 S.RegisterDelphiFunction(@TrimLeft, 'TrimLeft', cdRegister);
 S.RegisterDelphiFunction(@TrimRight, 'TrimRight', cdRegister);
 S.RegisterDelphiFunction(@TrimRight, 'TrimRight', cdRegister);
 S.RegisterDelphiFunction(@QuotedStr, 'QuotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiQuotedStr, 'AnsiQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiExtractQuotedStr, 'AnsiExtractQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiDequotedStr, 'AnsiDequotedStr', cdRegister);
 S.RegisterDelphiFunction(@IsValidIdent, 'IsValidIdent', cdRegister);
 //S.RegisterDelphiFunction(@IntToStr, 'IntToStr', cdRegister);
 //S.RegisterDelphiFunction(@IntToStr, 'IntToStr', cdRegister);
 S.RegisterDelphiFunction(@IntToHex, 'IntToHex', cdRegister);
 S.RegisterDelphiFunction(@myIntToHex64, 'IntToHex64', cdRegister);
 S.RegisterDelphiFunction(@StrToInt, 'StrToInt', cdRegister);
 S.RegisterDelphiFunction(@StrToIntDef, 'StrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@StrToInt64, 'StrToInt64', cdRegister);
 S.RegisterDelphiFunction(@StrToInt64Def, 'StrToInt64Def', cdRegister);
 S.RegisterDelphiFunction(@StrToBool, 'StrToBool', cdRegister);
 S.RegisterDelphiFunction(@StrToBoolDef, 'StrToBoolDef', cdRegister);
 S.RegisterDelphiFunction(@LoadStr, 'LoadStr', cdRegister);
 S.RegisterDelphiFunction(@FindStringResource, 'FindStringResource',cdRegister);
 S.RegisterDelphiFunction(@FileOpen, 'FileOpen', cdRegister);
 S.RegisterDelphiFunction(@FileCreate, 'FileCreate', cdRegister);
 //S.RegisterDelphiFunction(@FileCreate, 'FileCreate', cdRegister);
 S.RegisterDelphiFunction(@FileSeek, 'FileSeek', cdRegister);
 S.RegisterDelphiFunction(@FileSeek, 'FileSeek', cdRegister);
 S.RegisterDelphiFunction(@FileClose, 'FileClose', cdRegister);
 S.RegisterDelphiFunction(@FileAge, 'FileAge', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExists', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'DirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectories', cdRegister);
 {S.RegisterDelphiFunction(@FindFirst, 'FindFirst', cdRegister);
 S.RegisterDelphiFunction(@FindNext, 'FindNext', cdRegister);
 S.RegisterDelphiFunction(@FindClose, 'FindClose', cdRegister);}
 //S.RegisterDelphiFunction(@AssignFile, 'AssignFile', cdRegister);
 //S.RegisterDelphiFunction(@CloseFile, 'CloseFile', cdRegister);
 S.RegisterDelphiFunction(@FileGetDate, 'FileGetDate', cdRegister);
 S.RegisterDelphiFunction(@FileSetDate, 'FileSetDate', cdRegister);
 S.RegisterDelphiFunction(@FileSetDateH, 'FileSetDateH', cdRegister);
 S.RegisterDelphiFunction(@FileSetDateH, 'FileSetDate2', cdRegister);
 S.RegisterDelphiFunction(@FileGetAttr, 'FileGetAttr', cdRegister);
 S.RegisterDelphiFunction(@FileSetAttr, 'FileSetAttr', cdRegister);
 S.RegisterDelphiFunction(@FileIsReadOnly, 'FileIsReadOnly', cdRegister);
 S.RegisterDelphiFunction(@FileSetReadOnly, 'FileSetReadOnly', cdRegister);
 //S.RegisterDelphiFunction(@DeleteFile, 'DeleteFile', cdRegister);
 S.RegisterDelphiFunction(@RenameFile, 'RenameFile', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt, 'ChangeFileExt', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath, 'ExtractFilePath', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDir, 'ExtractFileDir', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDrive, 'ExtractFileDrive', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileName, 'ExtractFileName', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExt, 'ExtractFileExt', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName, 'ExpandFileName', cdRegister);
 S.RegisterDelphiFunction(@ExpandUNCFileName, 'ExpandUNCFileName', cdRegister);
 S.RegisterDelphiFunction(@ExtractRelativePath, 'ExtractRelativePath', cdRegister);
 S.RegisterDelphiFunction(@ExtractShortPathName, 'ExtractShortPathName', cdRegister);
 S.RegisterDelphiFunction(@FileSearch, 'FileSearch', cdRegister);
 S.RegisterDelphiFunction(@DiskFree, 'DiskFree', cdRegister);
 S.RegisterDelphiFunction(@DiskSize, 'DiskSize', cdRegister);
 S.RegisterDelphiFunction(@FileDateToDateTime, 'FileDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToFileDate, 'DateTimeToFileDate', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentDir, 'GetCurrentDir', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentDir, 'SetCurrentDir', cdRegister);
 S.RegisterDelphiFunction(@CreateDir, 'CreateDir', cdRegister);
 S.RegisterDelphiFunction(@RemoveDir, 'RemoveDir', cdRegister);
 S.RegisterDelphiFunction(@StrLen, 'StrLen', cdRegister);
 S.RegisterDelphiFunction(@StrEnd, 'StrEnd', cdRegister);
 S.RegisterDelphiFunction(@StrMove, 'StrMove', cdRegister);
 S.RegisterDelphiFunction(@StrCopy, 'StrCopy', cdRegister);
 S.RegisterDelphiFunction(@StrECopy, 'StrECopy', cdRegister);
 S.RegisterDelphiFunction(@StrLCopy, 'StrLCopy', cdRegister);
 S.RegisterDelphiFunction(@StrPCopy, 'StrPCopy', cdRegister);
 S.RegisterDelphiFunction(@StrPLCopy, 'StrPLCopy', cdRegister);
 S.RegisterDelphiFunction(@StrCat, 'StrCat', cdRegister);
 S.RegisterDelphiFunction(@StrLCat, 'StrLCat', cdRegister);
 S.RegisterDelphiFunction(@StrComp, 'StrComp', cdRegister);
 S.RegisterDelphiFunction(@StrIComp, 'StrIComp', cdRegister);
 S.RegisterDelphiFunction(@StrLComp, 'StrLComp', cdRegister);
 S.RegisterDelphiFunction(@StrLIComp, 'StrLIComp', cdRegister);
 S.RegisterDelphiFunction(@StrPos, 'StrPos', cdRegister);
 S.RegisterDelphiFunction(@StrUpper, 'StrUpper', cdRegister);
 S.RegisterDelphiFunction(@StrLower, 'StrLower', cdRegister);
 S.RegisterDelphiFunction(@StrPas, 'StrPas', cdRegister);
 S.RegisterDelphiFunction(@StrAlloc, 'StrAlloc', cdRegister);
 S.RegisterDelphiFunction(@StrBufSize, 'StrBufSize', cdRegister);
 S.RegisterDelphiFunction(@StrNew, 'StrNew', cdRegister);
 S.RegisterDelphiFunction(@StrDispose, 'StrDispose', cdRegister);
 S.RegisterDelphiFunction(@FloatToStr, 'FloatToStr', cdRegister);
 S.RegisterDelphiFunction(@FloatToStrF, 'FloatToStrF', cdRegister);
 S.RegisterDelphiFunction(@FloatToStrFS, 'FloatToStrFS', cdRegister);
 S.RegisterDelphiFunction(@CurrToStr1, 'CurrToStr', cdRegister);
 S.RegisterDelphiFunction(@CurrToStrF, 'CurrToStrF', cdRegister);
 S.RegisterDelphiFunction(@FloatToCurr, 'FloatToCurr', cdRegister);
 //S.RegisterDelphiFunction(@FloatToStrF, 'FloatToStrF', cdRegister);
 //S.RegisterDelphiFunction(@FloatToStrF, 'FloatToStrF', cdRegister);
 //S.RegisterDelphiFunction(@CurrToStrF, 'CurrToStrF', cdRegister);
 //S.RegisterDelphiFunction(@CurrToStrF, 'CurrToStrF', cdRegister);
 S.RegisterDelphiFunction(@Flush, 'Flush', cdRegister);
 S.RegisterDelphiFunction(@FormatFloat, 'FormatFloat', cdRegister);
 //S.RegisterDelphiFunction(@FormatFloat, 'FormatFloat', cdRegister);
 S.RegisterDelphiFunction(@FormatCurr, 'FormatCurr', cdRegister);
 //S.RegisterDelphiFunction(@FormatCurr, 'FormatCurr', cdRegister);
 S.RegisterDelphiFunction(@StrToFloat, 'StrToFloat', cdRegister);
 //S.RegisterDelphiFunction(@StrToFloat, 'StrToFloat', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatDef, 'StrToFloatDef', cdRegister);
 //S.RegisterDelphiFunction(@StrToFloatDef, 'StrToFloatDef', cdRegister);
 S.RegisterDelphiFunction(@StrToCurr, 'StrToCurr', cdRegister);
 //S.RegisterDelphiFunction(@StrToCurr, 'StrToCurr', cdRegister);
 S.RegisterDelphiFunction(@StrToCurrDef, 'StrToCurrDef', cdRegister);
 //S.RegisterDelphiFunction(@StrToCurrDef, 'StrToCurrDef', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToTimeStamp, 'DateTimeToTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@TimeStampToDateTime, 'TimeStampToDateTime', cdRegister);
 S.RegisterDelphiFunction(@MSecsToTimeStamp, 'MSecsToTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@TimeStampToMSecs, 'TimeStampToMSecs', cdRegister);
 S.RegisterDelphiFunction(@EncodeDate, 'EncodeDate', cdRegister);
 S.RegisterDelphiFunction(@EncodeTime, 'EncodeTime', cdRegister);
 S.RegisterDelphiFunction(@DecodeDate, 'DecodeDate', cdRegister);
 S.RegisterDelphiFunction(@DecodeDateFully, 'DecodeDateFully', cdRegister);
 //S.RegisterDelphiFunction(@InternalDecodeDate, 'InternalDecodeDate', cdRegister);
 S.RegisterDelphiFunction(@DecodeTime, 'DecodeTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToSystemTime, 'DateTimeToSystemTime', cdRegister);
 S.RegisterDelphiFunction(@SystemTimeToDateTime, 'SystemTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeek, 'DayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@Date, 'Date', cdRegister);
 S.RegisterDelphiFunction(@Time, 'Time', cdRegister);
 S.RegisterDelphiFunction(@GetTime, 'GetTime', cdRegister);
 S.RegisterDelphiFunction(@Now, 'Now', cdRegister);
 S.RegisterDelphiFunction(@CurrentYear, 'CurrentYear', cdRegister);
 S.RegisterDelphiFunction(@IncMonth, 'IncMonth', cdRegister);
 S.RegisterDelphiFunction(@IncAMonth, 'IncAMonth', cdRegister);
 S.RegisterDelphiFunction(@ReplaceTime, 'ReplaceTime', cdRegister);
 S.RegisterDelphiFunction(@ReplaceDate, 'ReplaceDate', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear', cdRegister);
 //S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear', cdRegister);
 //S.RegisterDelphiFunction(@IsToday, 'IsToday', cdRegister);
 S.RegisterDelphiFunction(@DateToStr, 'DateToStr', cdRegister);
 S.RegisterDelphiFunction(@TimeToStr, 'TimeToStr', cdRegister);
 //S.RegisterDelphiFunction(@TimeToStr, 'TimeToStr', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToStr, 'DateTimeToStr', cdRegister);
 //S.RegisterDelphiFunction(@DateTimeToStr, 'DateTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToDate, 'StrToDate', cdRegister);
 //S.RegisterDelphiFunction(@StrToDate, 'StrToDate', cdRegister);
 S.RegisterDelphiFunction(@StrToDateDef, 'StrToDateDef', cdRegister);
 //S.RegisterDelphiFunction(@StrToDateDef, 'StrToDateDef', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDate, 'TryStrToDate', cdRegister);
 //S.RegisterDelphiFunction(@TryStrToDate, 'TryStrToDate', cdRegister);
 S.RegisterDelphiFunction(@StrToTime, 'StrToTime', cdRegister);
 //S.RegisterDelphiFunction(@StrToTime, 'StrToTime', cdRegister);
 S.RegisterDelphiFunction(@StrToTimeDef, 'StrToTimeDef', cdRegister);
 //S.RegisterDelphiFunction(@StrToTimeDef, 'StrToTimeDef', cdRegister);
 S.RegisterDelphiFunction(@TryStrToTime, 'TryStrToTime', cdRegister);
 //S.RegisterDelphiFunction(@TryStrToTime, 'TryStrToTime', cdRegister);
 S.RegisterDelphiFunction(@StrToDateTime, 'StrToDateTime', cdRegister);
 //S.RegisterDelphiFunction(@StrToDateTime, 'StrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@StrToDateTimeDef, 'StrToDateTimeDef', cdRegister);
 //S.RegisterDelphiFunction(@StrToDateTimeDef, 'StrToDateTimeDef', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDateTime, 'TryStrToDateTime', cdRegister);
 //S.RegisterDelphiFunction(@TryStrToDateTime, 'TryStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@FormatDateTime, 'FormatDateTime', cdRegister);
 //S.RegisterDelphiFunction(@FormatDateTime, 'FormatDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToString, 'DateTimeToString', cdRegister);
 //S.RegisterDelphiFunction(@DateTimeToString, 'DateTimeToString', cdRegister);
 S.RegisterDelphiFunction(@FloatToDateTime, 'FloatToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryFloatToDateTime, 'TryFloatToDateTime', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'SysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@GetLocaleStr, 'GetLocaleStr', cdRegister);
 S.RegisterDelphiFunction(@GetLocaleChar, 'GetLocaleChar', cdRegister);
 S.RegisterDelphiFunction(@GetFormatSettings, 'GetFormatSettings', cdRegister);
 S.RegisterDelphiFunction(@GetLocaleFormatSettings, 'GetLocaleFormatSettings', cdRegister);
 {S.RegisterDelphiFunction(@InquireSignal, 'InquireSignal', cdRegister);
 S.RegisterDelphiFunction(@AbandonSignalHandler, 'AbandonSignalHandler', cdRegister);
 S.RegisterDelphiFunction(@HookSignal, 'HookSignal', cdRegister);
 S.RegisterDelphiFunction(@UnhookSignal, 'UnhookSignal', cdRegister);
 S.RegisterDelphiFunction(@HookOSExceptions, 'HookOSExceptions', cdRegister);
 S.RegisterDelphiFunction(@MapSignal, 'MapSignal', cdRegister);
 S.RegisterDelphiFunction(@SignalConverter, 'SignalConverter', cdRegister);
 S.RegisterDelphiFunction(@SetSafeCallExceptionMsg, 'SetSafeCallExceptionMsg', cdRegister);
 S.RegisterDelphiFunction(@SetSafeCallExceptionAddr, 'SetSafeCallExceptionAddr', cdRegister);
 S.RegisterDelphiFunction(@GetSafeCallExceptionMsg, 'GetSafeCallExceptionMsg', cdRegister);
 S.RegisterDelphiFunction(@GetSafeCallExceptionAddr, 'GetSafeCallExceptionAddr', cdRegister);}
 S.RegisterDelphiFunction(@LoadLibrary, 'LoadLibrary', cdRegister);
 S.RegisterDelphiFunction(@FreeLibrary, 'FreeLibrary', cdRegister);
 S.RegisterDelphiFunction(@FreeModule, 'FreeModule', cdRegister);
 //S.RegisterDelphiFunction(@LoadModule, 'LoadModule', cdRegister);
 S.RegisterDelphiFunction(@GetProcAddress, 'GetProcAddress', cdRegister);
 S.RegisterDelphiFunction(@GetModuleHandle, 'GetModuleHandle', cdRegister);
 //S.RegisterDelphiFunction(@GetPackageModuleHandle,'GetPackageModuleHandle',cdRegister);
 //S.RegisterDelphiFunction(@GetPackageModuleHandle, 'GetPackageModuleHandle', cdRegister);
 S.RegisterDelphiFunction(@Sleep, 'Sleep', CdStdCall);
 S.RegisterDelphiFunction(@GetModuleName, 'GetModuleName', cdRegister);
 S.RegisterDelphiFunction(@ExceptionErrorMessage, 'ExceptionErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@ShowException, 'ShowException', cdRegister);
 S.RegisterDelphiFunction(@Abort, 'Abort', cdRegister);
 S.RegisterDelphiFunction(@OutOfMemoryError, 'OutOfMemoryError', cdRegister);
 S.RegisterDelphiFunction(@FPower10, 'FPower10', cdRegister);
 S.RegisterDelphiFunction(@myHalt, 'Halt', cdRegister);
 S.RegisterDelphiFunction(@myRunError, 'RunError',cdRegister);

 //S.RegisterDelphiFunction(@Slice, 'Slice', cdRegister);
 S.RegisterDelphiFunction(@myEOF, 'EOF', cdRegister);
 S.RegisterDelphiFunction(@myEoln, 'EOLn', cdRegister);
 S.RegisterDelphiFunction(@IOResult, 'IOResult', cdRegister);
 S.RegisterDelphiFunction(@GetLastError, 'GetLastError', cdRegister);
 S.RegisterDelphiFunction(@SetLastError, 'SetLastError', cdRegister);
 S.RegisterDelphiFunction(@IsMemoryManagerSet,'IsMemoryManagerSet', cdRegister);
 S.RegisterDelphiFunction(@getIsConsole,'IsConsole', cdRegister);
 S.RegisterDelphiFunction(@getIsLibrary,'IsLibrary', cdRegister);
 S.RegisterDelphiFunction(@getIsMultiThread,'IsMultiThread', cdRegister);
 S.RegisterDelphiFunction(@HiByte,'HiByte', cdRegister);
 S.RegisterDelphiFunction(@HiWord,'HiWord', cdRegister);
 S.RegisterDelphiFunction(@MakeWord,'MakeWord', cdRegister);
 S.RegisterDelphiFunction(@MakeLong,'MakeLong', cdRegister);

 S.RegisterDelphiFunction(@getLongDayNames,'getLongDayNames', cdRegister);
 S.RegisterDelphiFunction(@getShortDayNames,'getShortDayNames', cdRegister);
 S.RegisterDelphiFunction(@getLongMonthNames,'getLongMonthNames', cdRegister);
 S.RegisterDelphiFunction(@getShortMonthNames,'getShortMonthNames', cdRegister);


//VAR PROTOTYPES
  S.RegisterDelphiFunction(@RandSeed, 'RandSeed', cdRegister);
  S.RegisterDelphiFunction(@myCurrencyString, 'CurrencyString', cdRegister);
  S.RegisterDelphiFunction(@myCurrencyDecimals, 'CurrencyDecimals', cdRegister);
  S.RegisterDelphiFunction(@myCurrencyFormat, 'CurrencyFormat', cdRegister);
  S.RegisterDelphiFunction(@Output, 'Output', cdRegister);
  S.RegisterDelphiFunction(@Input, 'Input', cdRegister);
  S.RegisterDelphiFunction(@ErrOutput, 'ErrOutput', cdRegister);
  S.RegisterDelphiFunction(@myMainInstance, 'MainInstance', cdRegister);
  S.RegisterDelphiFunction(@myMainThreadID, 'MainThreadID', cdRegister);
  S.RegisterDelphiFunction(@myboolstrstrue, 'trueboolstrs', cdRegister);
  S.RegisterDelphiFunction(@myboolstrsfalse, 'falseboolstrs', cdRegister);
  S.RegisterDelphiFunction(@myleadbytes, 'leadbytes', cdRegister);


 //S.RegisterDelphiFunction(@Beep, 'Beep', cdRegister);
 S.RegisterDelphiFunction(@ByteType, 'ByteType', cdRegister);
 S.RegisterDelphiFunction(@StrByteType, 'StrByteType', cdRegister);
 S.RegisterDelphiFunction(@ByteToCharLen, 'ByteToCharLen', cdRegister);
 S.RegisterDelphiFunction(@CharToByteLen, 'CharToByteLen', cdRegister);
 S.RegisterDelphiFunction(@ByteToCharIndex, 'ByteToCharIndex', cdRegister);
 S.RegisterDelphiFunction(@CharToByteIndex, 'CharToByteIndex', cdRegister);
 S.RegisterDelphiFunction(@StrCharLength, 'StrCharLength', cdRegister);
 S.RegisterDelphiFunction(@StrNextChar, 'StrNextChar', cdRegister);
 S.RegisterDelphiFunction(@CharLength, 'CharLength', cdRegister);
 S.RegisterDelphiFunction(@NextCharIndex, 'NextCharIndex', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiter, 'IsPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IsDelimiter, 'IsDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiter, 'IncludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingBackslash, 'IncludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'ExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingBackslash, 'ExcludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@LastDelimiter, 'LastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareFileName, 'AnsiCompareFileName', cdRegister);
 S.RegisterDelphiFunction(@SameFileName, 'SameFileName', cdRegister);
 S.RegisterDelphiFunction(@AnsiLowerCaseFileName, 'AnsiLowerCaseFileName', cdRegister);
 S.RegisterDelphiFunction(@AnsiUpperCaseFileName, 'AnsiUpperCaseFileName', cdRegister);
 S.RegisterDelphiFunction(@AnsiPos, 'AnsiPos', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrPos, 'AnsiStrPos', cdRegister);
 S.RegisterDelphiFunction(@StringReplace, 'StringReplace', cdRegister);
 S.RegisterDelphiFunction(@WrapText, 'WrapText', cdRegister);
 S.RegisterDelphiFunction(@WrapText, 'WrapText', cdRegister);
 S.RegisterDelphiFunction(@FindCmdLineSwitch, 'FindCmdLineSwitch', cdRegister);
 //S.RegisterDelphiFunction(@FindCmdLineSwitch, 'FindCmdLineSwitch', cdRegister);
 //S.RegisterDelphiFunction(@FindCmdLineSwitch, 'FindCmdLineSwitch', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastOSError, 'RaiseLastOSError', cdRegister);
 S.RegisterDelphiFunction(@myProcessPath, 'ProcessPath1', cdRegister);
 S.RegisterDelphiFunction(@myProcessPath, 'ProcessPath', cdRegister);

 S.RegisterDelphiFunction(@SlashSep, 'SlashSep', cdRegister);
 S.RegisterDelphiFunction(@CutFirstDirectory, 'CutFirstDirectory', cdRegister);
 S.RegisterDelphiFunction(@MiniMizeName, 'MinimizeName', cdRegister);
 S.RegisterDelphiFunction(@VolumeID, 'VolumeID', cdRegister);
 S.RegisterDelphiFunction(@NetworkVolume, 'NetworkVolume',cdRegister);
  { Object conversion routines of unit classes}
S.RegisterDelphiFunction(@ObjectBinaryToText,'ObjectBinaryToText', cdRegister);
S.RegisterDelphiFunction(@ObjectBinaryToText,'ObjectBinaryToText1', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToBinary,'ObjectTextToBinary', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToBinary,'ObjectTextToBinary1', cdRegister);
S.RegisterDelphiFunction(@ObjectResourceToText,'ObjectResourceToText', cdRegister);
S.RegisterDelphiFunction(@ObjectResourceToText,'ObjectResourceToText1', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToResource,'ObjectTextToResource', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToResource,'ObjectTextToResource1', cdRegister);

S.RegisterDelphiFunction(@TestStreamFormat,'TestStreamFormat', cdRegister);
S.RegisterDelphiFunction(@LineStart,'LineStart', cdRegister);
S.RegisterDelphiFunction(@ExtractStrings,'ExtractStrings', cdRegister);
S.RegisterDelphiFunction(@CountGenerations,'CountGenerations', cdRegister);
S.RegisterDelphiFunction(@CheckSynchronize,'CheckSynchronize', cdRegister);

//S.RegisterDelphiFunction(@Check,'Check', cdRegister);     //DB
S.RegisterDelphiFunction(@ColorToRGB,'ColorToRGB', cdRegister); //Graphics
S.RegisterDelphiFunction(@ColorToString,'ColorToString', cdRegister); //Graphics
S.RegisterDelphiFunction(@StringToColor,'StringToColor', cdRegister); //Graphics
S.RegisterDelphiFunction(@ColorToIdent,'ColorToIdent', cdRegister); //Graphics
S.RegisterDelphiFunction(@IdentToColor,'IdentToColor', cdRegister); //Graphics
S.RegisterDelphiFunction(@CharsetToIdent,'CharsetIdent', cdRegister); //Graphics
S.RegisterDelphiFunction(@IdentToCharset,'IdentToCharset', cdRegister); //Graphics

S.RegisterDelphiFunction(@DataBaseError,'DataBaseError', cdRegister); //DB
//S.RegisterDelphiFunction(@DBIError,'DBIError', cdRegister);        //DB
S.RegisterDelphiFunction(@GetLongHint,'GetLongHint', cdRegister); //Controls
S.RegisterDelphiFunction(@GetShortHint,'GetShortHint', cdRegister); //
S.RegisterDelphiFunction(@GetParentForm,'GetParentForm', cdRegister); //Forms
//S.RegisterDelphiFunction(@GraphicFilter,'GraphicFilter', cdRegister); //Graphics
S.RegisterDelphiFunction(@ValidParentForm,'ValidParentForm', cdRegister); //Forms
S.RegisterDelphiFunction(@IsAccel,'IsAccel', cdRegister); //Forms
S.RegisterDelphiFunction(@ForegroundTask,'ForegroundTask', cdRegister); //Forms

S.RegisterDelphiFunction(@LoadCursor,'LoadCursor', cdRegister); //Win
S.RegisterDelphiFunction(@BitBlt,'BitBlt', cdRegister); //Win
S.RegisterDelphiFunction(@StretchBlt,'StretchBlt', cdRegister); //Win
S.RegisterDelphiFunction(@GetDC,'GetDC', cdRegister); //Win
S.RegisterDelphiFunction(@ReleaseDC,'ReleaseDC', cdRegister); //Win
S.RegisterDelphiFunction(@GetWindowDC,'GetWindowDC', cdRegister); //Win  //3.7
S.RegisterDelphiFunction(@GetWindowRect,'GetWindowRect', cdRegister); //Win in graphics
S.RegisterDelphiFunction(@SetLineBreakStyle,'SetLineBreakStyle', cdRegister); //Win in graphics

S.RegisterDelphiFunction(@Set8087CW,'Set8087CW', cdRegister); //Win
S.RegisterDelphiFunction(@Get8087CW,'Get8087CW', cdRegister);
S.RegisterDelphiFunction(@WideStringToUCS4String,'WideStringToUCS4String', cdRegister); //Win
S.RegisterDelphiFunction(@UCS4StringToWideString,'UCS4StringToWideString', cdRegister);

S.RegisterDelphiFunction(@UTF8Encode,'UTF8Encode', cdRegister); //Win
S.RegisterDelphiFunction(@UTF8Decode,'UTF8Decode', cdRegister);
S.RegisterDelphiFunction(@AnsiToUtf8,'AnsiToUtf8', cdRegister); //Win
S.RegisterDelphiFunction(@Utf8ToAnsi,'Utf8ToAnsi', cdRegister);
//S.RegisterDelphiFunction(@ModuleCacheID,'ModuleCacheID', cdRegister);
//S.RegisterDelphiFunction(@InvalidateModuleCache,'AnsiToUtf8', cdRegister); //Win
S.RegisterDelphiFunction(@SetMultiByteConversionCodePage,'SetMultiByteConversionCodePage', cdRegister);
 //S.RegisterDelphiFunction(@_CheckAutoResult, '_CheckAutoResult', cdRegister);
 S.RegisterDelphiFunction(@FPower10, 'FPower10', cdRegister);
 S.RegisterDelphiFunction(@TextStart, 'TextStart', cdRegister);
 S.RegisterDelphiFunction(@CompToDouble, 'CompToDouble', CdCdecl);
 S.RegisterDelphiFunction(@DoubleToComp, 'DoubleToComp', CdCdecl);
 S.RegisterDelphiFunction(@CompToCurrency, 'CompToCurrency', CdCdecl);
 S.RegisterDelphiFunction(@CurrencyToComp, 'CurrencyToComp', CdCdecl);
 S.RegisterDelphiFunction(@GetMemory, 'GetMemory', CdCdecl);
 S.RegisterDelphiFunction(@FreeMemory, 'FreeMemory', CdCdecl);
 S.RegisterDelphiFunction(@ReallocMemory, 'ReallocMemory', CdCdecl);
 S.RegisterDelphiFunction(@StringOfChar1, 'StringOfChar1', cdRegister);
 S.RegisterDelphiFunction(@StringOfChar2, 'StringOfChar2', cdRegister);
 S.RegisterDelphiFunction(@FindResource, 'FindResource', cdRegister);
 S.RegisterDelphiFunction(@LoadResource, 'LoadResource', cdRegister);
 S.RegisterDelphiFunction(@SizeofResource, 'SizeofResource', cdRegister);
 S.RegisterDelphiFunction(@LockResource, 'LockResource', cdRegister);
 S.RegisterDelphiFunction(@UnlockResource, 'UnlockResource', cdRegister);
 S.RegisterDelphiFunction(@FreeResource, 'FreeResource', cdRegister);
 S.RegisterDelphiFunction(@AttemptToUseSharedMemoryManager, 'AttemptToUseSharedMemoryManager', cdRegister);
 S.RegisterDelphiFunction(@ShareMemoryManager, 'ShareMemoryManager', cdRegister);

 S.RegisterDelphiFunction(@SendAppMessage, 'SendAppMessage', cdRegister);
S.RegisterDelphiFunction(@MoveWindowOrg, 'MoveWindowOrg', cdRegister);
S.RegisterDelphiFunction(@IsDragObject, 'IsDragObject', cdRegister);
S.RegisterDelphiFunction(@IsVCLControl, 'IsVCLControl', cdRegister);
S.RegisterDelphiFunction(@FindControl, 'FindControl', cdRegister);
S.RegisterDelphiFunction(@FindVCLWindow, 'FindVCLWindow', cdRegister);
S.RegisterDelphiFunction(@FindDragTarget, 'FindDragTarget', cdRegister);
S.RegisterDelphiFunction(@GetCaptureControl, 'GetCaptureControl', cdRegister);
S.RegisterDelphiFunction(@SetCaptureControl, 'SetCaptureControl', cdRegister);
S.RegisterDelphiFunction(@CancelDrag, 'CancelDrag', cdRegister);
S.RegisterDelphiFunction(@CursorToString, 'CursorToString', cdRegister);
S.RegisterDelphiFunction(@StringToCursor, 'StringToCursor', cdRegister);
S.RegisterDelphiFunction(@CursorToIdent, 'CursorToIdent', cdRegister);
S.RegisterDelphiFunction(@IdentToCursor, 'IdentToCursor', cdRegister);
S.RegisterDelphiFunction(@PerformEraseBackground, 'PerformEraseBackground', cdRegister);
S.RegisterDelphiFunction(@ChangeBiDiModeAlignment, 'ChangeBiDiModeAlignment', cdRegister);
//3.7
S.RegisterDelphiFunction(@LoadPackage, 'LoadPackage', cdRegister);
S.RegisterDelphiFunction(@UnLoadPackage, 'UnLoadPackage', cdRegister);
S.RegisterDelphiFunction(@GetPackageDescription, 'GetPackageDescription', cdRegister);
S.RegisterDelphiFunction(@InitializePackage, 'InitializePackage', cdRegister);
S.RegisterDelphiFunction(@FinalizePackage, 'FinalizePackage', cdRegister);
S.RegisterDelphiFunction(@GDAL, 'GDAL', cdRegister);
S.RegisterDelphiFunction(@RCS, 'RCS', cdRegister);
S.RegisterDelphiFunction(@RPR, 'RPR', cdRegister);
//3.8
S.RegisterDelphiFunction(@SendMessage, 'SendMessage', cdRegister);
S.RegisterDelphiFunction(@PostMessage, 'PostMessage', cdRegister);
S.RegisterDelphiFunction(@FloatToDecimal, 'FloatToDecimal', cdRegister);
S.RegisterDelphiFunction(@LoadLibrary, 'LoadLibrary', cdRegister);
S.RegisterDelphiFunction(@FreeLibrary, 'FreeLibrary', cdRegister);
S.RegisterDelphiFunction(@queryPerformanceCounter, 'queryPerformanceCounter',cdRegister);
S.RegisterDelphiFunction(@QueryPerformanceFrequency,'QueryPerformanceFrequency',cdRegister);
 //procedure ChangeBiDiModeAlignment(var Alignment: TAlignment);
                       //makeintresource

{$DEFINE DEBUG_FUNCTIONS}
//S.RegisterDelphiFunction(@System.FindObjects,'FindObjects', cdRegister);
{$UNDEF DEBUG_FUNCTIONS}

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EWin32Error(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EWin32Error) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOSError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOSError) do begin
    RegisterPropertyHelper(@EOSErrorErrorCode_R,@EOSErrorErrorCode_W,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EStackOverflow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EStackOverflow) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EExternal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EExternal) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EInOutError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInOutError) do
  begin
    RegisterPropertyHelper(@EInOutErrorErrorCode_R,@EInOutErrorErrorCode_W,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EHeapException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EHeapException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Exception(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(Exception) do begin
    RegisterConstructor(@Exception.Create, 'Create');
    RegisterConstructor(@ExceptionCreateRes_P, 'CreateRes');
    RegisterConstructor(@ExceptionCreateRes_P, 'CreateRes');
    RegisterConstructor(@ExceptionCreateResHelp_P, 'CreateResHelp');
    RegisterConstructor(@ExceptionCreateResHelp_P, 'CreateResHelp');
    RegisterPropertyHelper(@ExceptionHelpContext_R,@ExceptionHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@ExceptionMessage_R,@ExceptionMessage_W,'Message');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLanguages(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLanguages) do begin
    RegisterConstructor(@TLanguages.Create, 'Create');
    RegisterMethod(@TLanguages.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TLanguagesCount_R,nil,'Count');
    RegisterPropertyHelper(@TLanguagesName_R,nil,'Name');
    RegisterPropertyHelper(@TLanguagesNameFromLocaleID_R,nil,'NameFromLocaleID');
    RegisterPropertyHelper(@TLanguagesNameFromLCID_R,nil,'NameFromLCID');
    RegisterPropertyHelper(@TLanguagesID_R,nil,'ID');
    RegisterPropertyHelper(@TLanguagesLocaleID_R,nil,'LocaleID');
    RegisterPropertyHelper(@TLanguagesExt_R,nil,'Ext');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SysUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStopwatch(CL);
  RIRegister_TLanguages(CL);
  RIRegister_Exception(CL);
  with CL.Add(EAbort) do
  RIRegister_EHeapException(CL);
  with CL.Add(EOutOfMemory) do
  RIRegister_EInOutError(CL);
  RIRegister_EExternal(CL);
  with CL.Add(EExternalException) do
  with CL.Add(EIntError) do
  with CL.Add(EDivByZero) do
  with CL.Add(ERangeError) do
  with CL.Add(EIntOverflow) do
  with CL.Add(EMathError) do
  with CL.Add(EInvalidOp) do
  with CL.Add(EZeroDivide) do
  with CL.Add(EOverflow) do
  with CL.Add(EUnderflow) do
  with CL.Add(EInvalidPointer) do
  with CL.Add(EInvalidCast) do
  with CL.Add(EConvertError) do
  with CL.Add(EAccessViolation) do
  with CL.Add(EPrivilege) do
  RIRegister_EStackOverflow(CL);
  with CL.Add(EControlC) do
  with CL.Add(EVariantError) do
  with CL.Add(EPropReadOnly) do
  with CL.Add(EPropWriteOnly) do
  with CL.Add(EAssertionFailed) do
  with CL.Add(EIntfCastError) do
  with CL.Add(EInvalidContainer) do
  with CL.Add(EInvalidInsert) do
  with CL.Add(EPackageError) do
  RIRegister_EOSError(CL);
  RIRegister_EWin32Error(CL);
  with CL.Add(ESafecallException) do
end;

 
 
{ TPSImport_SysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.CompOnUses(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.ExecOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.CompileImport2(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SysUtils(ri);
  RIRegister_SysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing }
end;
 

end.
