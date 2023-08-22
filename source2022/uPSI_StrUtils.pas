unit uPSI_StrUtils;
{

//imports by max  and imports more runtime lib functions of delphi2 up
 set constants and sets to provide is dependent from sysutils
 overload with leftstr2 ... correction   , getmem vars  TSearchRec bug! getdir! , setstring!
}
interface
 
uses
   SysUtils
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_StrUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_StrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StrUtils_Routines(S: TPSExec);

procedure Register;

implementation

uses
   Types
  ,Classes 
  ,StrUtils
  ,Dialogs
  //,windows
  ;

Type TBuffer = array[0..255] of char;



var mf: Textfile;
    mfilename: string;

procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_StrUtils]);
end;

procedure getmemarray(var arr: array of integer; size: integer);
begin
  //getmem
   //GetMem(pointer(arr), Size);
  //Val(S, I, Error);
end;


procedure RaiseException3(const Msg: string);
begin
  { Exception mit Meldung auslösen }
  raise Exception.Create(Msg);
end;

// CL.AddDelphiFunction('procedure SetString(var s: string; buffer: PChar; len: Integer)');

procedure mySetString(var s: string; buffer: PChar; len: Integer);
begin
  SetString(s,buffer, len);
end;

procedure mySetLength(var S: string; NewLength: Integer);
begin
  SetLength(s, newlength);
end;




(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StrUtils(CL: TPSPascalCompiler);
begin

  {faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform deprecated;  // not used in Win32
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faSymLink   = $00000040 platform;
  faAnyFile   = $0000003F;}

 CL.AddConstantN('faReadOnly','LongInt').SetInt($00000001);
 CL.AddConstantN('faHidden','LongInt').SetInt($00000002);
 CL.AddConstantN('faSysFile','LongInt').SetInt($00000004);
 CL.AddConstantN('faDirectory','LongInt').SetInt($00000010);
 CL.AddConstantN('faArchive','LongInt').SetInt($00000020);
 CL.AddConstantN('faAnyFile','LongInt').SetInt($0000003F);
 CL.AddConstantN('faVolumeID','LongInt').SetInt($00000008); //platform deprecated;
 CL.AddConstantN('faSymLink','LongInt').SetInt($00000040); // platform;
 CL.AddConstantN('TwoDigitYearCenturyWindow','Word').SetInt(50);

  CL.AddConstantN('fmClosed','LongInt').SetInt($D7B0);
 CL.AddConstantN('fmInput','LongInt').SetInt($D7B1);
 CL.AddConstantN('fmOutput','LongInt').SetInt($D7B2);
 CL.AddConstantN('fmInOut','LongInt').SetInt($D7B3);
 {CL.AddConstantN('fmClosed','LongWord').SetUInt( $D7B0);
 CL.AddConstantN('fmInput','LongWord').SetUInt( $D7B1);
 CL.AddConstantN('fmOutput','LongWord').SetUInt( $D7B2);
 CL.AddConstantN('fmInOut','LongWord').SetUInt( $D7B3);}
 CL.AddConstantN('tfCRLF','LongWord').SetUInt( $1);

                                //getlocalestr //locale_system_default
 //TformatSettings
  //ansilength ?
 CL.AddDelphiFunction('Function ResemblesText( const AText, AOther : string) : Boolean');
 CL.AddDelphiFunction('Function ResemblesText( const AText, AOther : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiResemblesText( const AText, AOther : string) : Boolean');
 CL.AddDelphiFunction('Function ContainsText( const AText, ASubText : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiContainsText( const AText, ASubText : string) : Boolean');
 CL.AddDelphiFunction('Function StartsText( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiStartsText( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function EndsText( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiEndsText( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function ReplaceText( const AText, AFromText, AToText : string) : string');
 CL.AddDelphiFunction('Function AnsiReplaceText( const AText, AFromText, AToText : string) : string');
 CL.AddDelphiFunction('Function MatchText( const AText : string; const AValues : array of string) : Boolean');
 CL.AddDelphiFunction('Function AnsiMatchText( const AText : string; const AValues : array of string) : Boolean');
 CL.AddDelphiFunction('Function IndexText( const AText : string; const AValues : array of string) : Integer');
 CL.AddDelphiFunction('Function AnsiIndexText( const AText : string; const AValues : array of string) : Integer');
 CL.AddDelphiFunction('Function ContainsStr( const AText, ASubText : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiContainsStr( const AText, ASubText : string) : Boolean');
 CL.AddDelphiFunction('Function StartsStr( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiStartsStr( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function EndsStr( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiEndsStr( const ASubText, AText : string) : Boolean');
 CL.AddDelphiFunction('Function ReplaceStr( const AText, AFromText, AToText : string) : string');
 CL.AddDelphiFunction('Function AnsiReplaceStr( const AText, AFromText, AToText : string) : string');
 CL.AddDelphiFunction('Function MatchStr( const AText : string; const AValues : array of string) : Boolean');
 CL.AddDelphiFunction('Function AnsiMatchStr( const AText : string; const AValues : array of string) : Boolean');
 CL.AddDelphiFunction('Function IndexStr( const AText : string; const AValues : array of string) : Integer');
 CL.AddDelphiFunction('Function AnsiIndexStr( const AText : string; const AValues : array of string) : Integer');
 CL.AddDelphiFunction('Function DupeString( const AText : string; ACount : Integer) : string');
 CL.AddDelphiFunction('Function ReverseString( const AText : string) : string');
 CL.AddDelphiFunction('Function AnsiReverseString( const AText : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StuffString( const AText : string; AStart, ALength : Cardinal; const ASubText : string) : string');
 CL.AddDelphiFunction('Function RandomFrom( const AValues : array of string) : string;');
 CL.AddDelphiFunction('Function IfThen( AValue : Boolean; const ATrue : string; AFalse : string) : string;');
// CL.AddDelphiFunction('Function IfThenInt( AValue : Boolean; const ATrue : integer; AFalse : integer): integer;');
// CL.AddDelphiFunction('Function IfThenDouble( AValue : Boolean; const ATrue : double; AFalse : double): double;');
// CL.AddDelphiFunction('Function IfThenBool( AValue : Boolean; const ATrue : boolean; AFalse : boolean): boolean;');

 //Function iif1( ATest : Boolean; const ATrue : Integer; const AFalse : Integer) : Integer;

 CL.AddDelphiFunction('procedure RaiseException3(const Msg: string);');
 CL.AddDelphiFunction('Function LeftStr( const AText : AnsiString; const ACount : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function LeftStr2( const AText : WideString; const ACount : Integer) : WideString;');
 CL.AddDelphiFunction('Function RightStr( const AText : AnsiString; const ACount : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function RightStr2( const AText : WideString; const ACount : Integer) : WideString;');
 CL.AddDelphiFunction('Function MidStr( const AText : AnsiString; const AStart, ACount : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function MidStr2( const AText : WideString; const AStart, ACount : Integer) : WideString;');
 //CL.AddDelphiFunction('Function LeftBStr( const AText : AnsiString; const AByteCount : Integer) : AnsiString');
 //CL.AddDelphiFunction('Function RightBStr( const AText : AnsiString; const AByteCount : Integer) : AnsiString');
 //CL.AddDelphiFunction('Function MidBStr( const AText : AnsiString; const AByteStart, AByteCount : Integer) : AnsiString');
 CL.AddDelphiFunction('Function AnsiLeftStr( const AText : AnsiString; const ACount : Integer) : AnsiString');
 CL.AddDelphiFunction('Function AnsiRightStr( const AText : AnsiString; const ACount : Integer) : AnsiString');
 CL.AddDelphiFunction('Function AnsiMidStr( const AText : AnsiString; const AStart, ACount : Integer) : AnsiString');
  CL.AddTypeS('TReplaceFlag', '(rfReplaceAll, rfIgnoreCase)');
  CL.AddTypeS('TReplaceFlags', 'set of TReplaceFlag');
  CL.AddDelphiFunction('Function StringReplace(const SourceString, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;');
  CL.AddTypeS('TStringSeachOption', '(soDown, soMatchCase, soWholeWord )');
  CL.AddTypeS('TStringSearchOption', '(soDown, soMatchCase, soWholeWord )');
  CL.AddTypeS('TMbcsByteType', '(mbSingleByte, mbLeadByte, mbTrailByte)');
  CL.AddTypeS('TFloatValue','(fvExtended, fvCurrency)');
  CL.AddTypeS('TFloatFormat','(ffGeneral, ffExponent, ffFixed,ffNumber, ffCurrency)');
 // CL.AddTypeS('TMsgDlgType','(mtWarning, mtError, mtInformation, mtConfirmation, mtCustom)');
 // CL.AddTypeS('TMsgDlgBtn','(mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp);');
 // CL.AddTypeS('TMsgDlgButtons','set of TMsgDlgBtn)');

 CL.AddTypeS('TValueRelationship2','array [-1..1] of byte)');

 CL.AddTypeS('TValueRelationship','(LessThanValue, EqualsValue, GreaterThanValue)');

 CL.AddTypeS('THandle', 'LongWord');
 CL.AddTypeS('TFileName', 'String');
 //CL.AddTypeS('TFileTime', 'record dwLowDateTime: WORD; dwHighDateTime: WORD; end');

  CL.AddTypeS('_FILETIME', 'record dwLowDateTime: DWORD; dwHighDateTime: DWORD; end');
  CL.AddTypeS('TFileTime', '_FILETIME');
  CL.AddTypeS('FILETIME', '_FILETIME');

  {TCreateParams = record
    Caption: PChar;
    Style: DWORD;
    ExStyle: DWORD;
    X, Y: Integer;
    Width, Height: Integer;
    WndParent: HWnd;
    Param: Pointer;
    WindowClass: TWndClass;
    WinClassName: array[0..63] of Char;
  end;}

   CL.AddTypeS('TCreateParams',
    'record' +
    '  caption: PChar;' +
    '  Style: DWord;' +
    '  ExStyle: DWord;' +
    '  X,Y: Integer;' +
    '  Width, Height: Integer;' +
    '  WndParent: HWnd;' +
    '  Param: ___Pointer;' +
    '  WindowClass: TObject;' +
    '  WinClassName: array[0..63] of Char;' +
    'end');


//  CL.AddTypeS('TWin32FindData', 'record dwFileAttributes: LongWord; ftCreationTime,ftLastAccessTime,ftLastWriteTime: TFileTime;'
 // +'nFileSizeHigh,nFileSizeLow,dwReserved0,dwReserved1: LongWORD; cFileName: array[0..259] of WideChar; cAlternateFileName: array[0..13] of WideChar; end');

  CL.AddTypeS('_WIN32_FIND_DATAA', 'record dwFileAttributes: DWord; ftCreationTime: TFileTime; ftLastAccessTime: TFileTime; ftLastWriteTime: TFileTime;'
  +'nFileSizeHigh: DWord; nFileSizeLow: DWORD; dwReserved0: DWORD; dwReserved1: DWORD; cFileName: array[0..260-1] of Char; cAlternateFileName: array[0..13] of Char; end');

   CL.AddTypeS('_WIN32_FIND_DATAAA', 'record dwFileAttributes: DWord; ftCreationTime: TFileTime; ftLastAccessTime: TFileTime; ftLastWriteTime: TFileTime;'
  +'nFileSizeHigh: DWord; nFileSizeLow: DWORD; dwReserved0: DWORD; dwReserved1: DWORD; cFileName: array of char; cAlternateFileName: array of char; end');

  { _WIN32_FIND_DATAA = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..MAX_PATH - 1] of AnsiChar;
    cAlternateFileName: array[0..13] of AnsiChar;
  end; }

   //_WIN32_FIND_DATAA
  CL.AddTypeS('_WIN32_FIND_DATA', '_WIN32_FIND_DATAA');
  CL.AddTypeS('TWin32FindDataA', '_WIN32_FIND_DATAAA');
  //CL.AddTypeS('TWin32FindDataW', '_WIN32_FIND_DATAW');
  //CL.AddTypeS('TWin32FindData', 'TWin32FindDataA');
  CL.AddTypeS('TWin32FindData', '_WIN32_FIND_DATAA');

   //CL.AddTypeS('mlongword', 'btU32');

   CL.AddTypeS('TFormatSettings', 'record CurrencyFormat: Byte; NegCurrFormat: Byte;'
   +'ThousandSeparator: Char; DecimalSeparator: Char; CurrencyDecimals: Byte; DateSeparator: Char;'
   +'TimeSeparator: Char; ListSeparator: Char; CurrencyString: string; ShortDateFormat: string; LongDateFormat: string;'
   +'TimeAMString: string; TimePMString: string; ShortTimeFormat: string; LongTimeFormat: string;'
   +'ShortMonthNames: array[1..12] of string; LongMonthNames: array[1..12] of string; ShortDayNames: array[1..7] of string;'
   +'LongDayNames: array[1..7] of string; TwoDigitYearCenturyWindow: Word; end;');

//   CL.AddTypeS('TSearchRec', 'record Time: Integer; Size: Int64; Attr: Integer;'
  //+'Name: TFileName; ExcludeAttr: Integer; FindHandle: THandle; FindData: TWin32FindData; end');

  CL.AddTypeS('TFindRec',
    'record' +
    '  Name: String;' +
    '  Attributes: LongWord;' +
    '  SizeHigh: LongWord;' +
    '  SizeLow: LongWord;' +
    '  CreationTime: TFileTime;' +
    '  LastAccessTime: TFileTime;' +
    '  LastWriteTime: TFileTime;' +
    '  AlternateName: String;' +
    '  FindHandle: THandle;' +
    'end');


   CL.AddTypeS('TSearchRec', 'record Time: Integer; Size: Int64; Attr: Integer;'
    +'Name: TFileName; ExcludeAttr: Integer; FindHandle: THandle; FindData: TWin32FindData; end;');

{  TSearchRec = record
    Time: Integer;
    Size: Int64;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
//{$IFDEF MSWINDOWS}
   { FindHandle: THandle  platform;
    FindData: TWin32FindData  platform;}


    //TSearchRec.sysutils.TWin32FindData
    //sysutils.TWin32FindData
  //CL.AddTypeS('TSearchRec', 'record Time: Integer; Size: Int64; Attr: Integer; Name: TFileName; ExcludeAttr: Integer; FindHandle: THandle; FindData: TWin32FindData; end');
   CL.AddTypeS('TSmallPoint', 'record x: smallint; y: smallint; end;');

  CL.AddTypeS('TGUID', 'record D1: LongWord; D2: word; D3: word; D4: array[0..7] of Byte; end');
  //CL.AddTypeS('TGUID', 'TGUID');
  CL.AddTypeS('HRESULT', 'longint');
  CL.AddTYpeS('TByteArray','array[0..32767] of byte');
  CL.AddTypeS('TSysCharSet', 'set of Char');
  CL.AddTypeS('TStringSearchOptions', 'set of TStringSeachOption');
 CL.AddDelphiFunction('function LastDelimiter(const Delimiters: string; const S: string): Integer)');
 CL.AddDelphiFunction('function SameText(const S1: string; const S2: string): Boolean)');
 CL.AddDelphiFunction('function CompareStr(const S1: string; const S2: string): Integer)');
 CL.AddDelphiFunction('function CompareString(const S1: string; const S2: string): Integer)');
 CL.AddDelphiFunction('function CompareText(const S1: string; const S2: string): Integer)');
 CL.AddDelphiFunction('function TrimLeft(const S: string): string)');
 CL.AddDelphiFunction('function TrimRight(const S: string): string)');
 CL.AddDelphiFunction('function StrToIntDef(const S: string; Default: Integer): Integer)');
 CL.AddDelphiFunction('function StrToFloatDef(const S: string; const Default: Extended): Extended)');
 //from classes
 CL.AddDelphiFunction('function ExtractStrings(Separators: TSysCharSet; WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings): Integer)');
 CL.AddDelphiFunction('function LineStart(Buffer, BufPos: PChar): PChar)');
 CL.AddDelphiFunction('function HexToBin(Text,Buffer:PChar; BufSize:Integer):Integer;');
 CL.AddDelphiFunction('procedure BinToHex(Buffer: PChar; Text: PChar; BufSize: Integer);');
 //CL.AddDelphiFunction('function StringOfChar(ch: WideChar; Count: Integer): WideString)');
 CL.AddDelphiFunction('procedure FillCharS(var p: string; count: integer; value: char);'); //fix3.8
 CL.AddDelphiFunction('procedure UniqueString(var str: AnsiString)');
 CL.AddDelphiFunction('procedure SetString(var s: string; buffer: PChar; len: Integer)');
 CL.AddDelphiFunction('procedure SetLength2(var S: string; NewLength: Integer)');
 CL.AddDelphiFunction('Function SearchBuf( Buf : PChar; BufLen : Integer; SelStart, SelLength : Integer; SearchString : String; Options : TStringSearchOptions) : PChar');
 CL.AddDelphiFunction('Function SearchBuf2( Buf : String; SelStart, SelLength : Integer; SearchString : String; Options : TStringSearchOptions) : Integer');

 CL.AddDelphiFunction('Function PosEx( const SubStr, S : string; Offset : Integer) : Integer');
 CL.AddTypeS('TSoundexLength', 'Integer');
 CL.AddDelphiFunction('Function Soundex( const AText : string; ALength : TSoundexLength) : string');
  CL.AddTypeS('TSoundexIntLength', 'Integer');
  CL.AddTypeS('TextFile', 'string');   //integer beta in mx3
 //  CL.AddTypeS('Text', 'file of char');   //beta in mx3

  CL.AddTypeS('File', 'string');   //integer beta in mx3
  CL.AddTypeS('TBuffer', 'PChar');   //beta in mx3
  CL.AddTypeS('TTextLineBreakStyle', '(tlbsLF, tlbsCRLF)');   //beta in mx3
 
  //  TTextLineBreakStyle = (tlbsLF, tlbsCRLF);

  //CL.AddTypeS('RandSeed', 'Longint');   //beta in mx3   randseed now a functionvar

 CL.AddClassN(CL.FindClass('TOBJECT'),'EAbort');

 CL.AddDelphiFunction('Function SoundexInt( const AText : string; ALength : TSoundexIntLength) : Integer');
 CL.AddDelphiFunction('Function DecodeSoundexInt( AValue : Integer) : string');
 CL.AddDelphiFunction('Function SoundexWord( const AText : string) : Word');
 CL.AddDelphiFunction('Function DecodeSoundexWord( AValue : Word) : string');
 CL.AddDelphiFunction('Function SoundexSimilar( const AText, AOther : string; ALength : TSoundexLength) : Boolean');
 CL.AddDelphiFunction('Function SoundexCompare( const AText, AOther : string; ALength : TSoundexLength) : Integer');
 CL.AddDelphiFunction('Function SoundexProc( const AText, AOther : string) : Boolean');
 //from system.pas or sysutils
 CL.AddDelphiFunction('Function ParamCount: Integer');
 CL.AddDelphiFunction('function ParamStr(Index: Integer): string)');
 CL.AddDelphiFunction('procedure Abort)');
 CL.AddDelphiFunction('function CallTerminateProcs: Boolean)');
 CL.AddDelphiFunction('procedure RaiseLastWin32Error)');
 CL.AddDelphiFunction('function Win32Check(RetVal: boolean): boolean)');
 CL.AddDelphiFunction('function SysErrorMessage(ErrorCode: Integer): string)');
 CL.AddDelphiFunction('function InputQuery(const ACaption: string; const APrompt: string; var Value: string): Boolean)');
 CL.AddDelphiFunction('function InputBox(const ACaption: string; const APrompt: string; const ADefault: string): string)');
 //remove to upsi_dialogs
 //CL.AddDelphiFunction('function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer)');
 CL.AddDelphiFunction('procedure ShowMessageFmt(const Msg: string; Params: array of const))');
 CL.AddDelphiFunction('procedure ShowMessagePos(const Msg: string; X: Integer; Y: Integer))');
 CL.AddDelphiFunction('function PromptForFileName(var AFileName: string; const AFilter: string; const ADefaultExt: string;'
         +'const ATitle: string; const AInitialDir: string; SaveDialog: Boolean): Boolean)');

 //CL.AddDelphiFunction('Procedure FreeAndNil(var ObjectReference)');
 //CL.AddDelphiFunction('function IntToStr64(Value: Int64): string)'); in math

 //file and disk management
 CL.AddDelphiFunction('Procedure MkDir(const s: string)');
 CL.AddDelphiFunction('Procedure ChDir(const s: string)');
 CL.AddDelphiFunction('Procedure MakeDir(const s: string)');
 CL.AddDelphiFunction('Procedure ChangeDir(const s: string)');

 CL.AddDelphiFunction('Procedure GetDir(d: byte; var s: string)');
 CL.AddDelphiFunction('procedure RmDir(const S: string)');
 CL.AddDelphiFunction('Function makeFile(const FileName: string): integer)');
 CL.AddDelphiFunction('Function mkFile(const FileName: string): integer)');

 CL.AddDelphiFunction('Function FileCreate(const FileName: string): integer)');
 CL.AddDelphiFunction('Function FileOpen(const FileName: string; mode:integer): integer)');
 CL.AddDelphiFunction('Procedure FileClose(handle: integer)');
 CL.AddDelphiFunction('Function FileAge(const FileName: string): integer)');
 CL.AddDelphiFunction('Function FileGetDate(handle: integer): integer');
 //CL.AddDelphiFunction('Function Concat(s: string): string');
 CL.AddDelphiFunction('Function Concat(const Args: array of string): string');

 CL.AddDelphiFunction('function FileWrite(Handle: Integer; const Buffer: pChar; Count: LongWord): Integer)');
 CL.AddDelphiFunction('Function FileRead(handle: integer; Buffer: PChar; count: LongWord): integer');   //fix?
 CL.AddDelphiFunction('Function FileSeek(handle, offset, origin: integer): integer');
 CL.AddDelphiFunction('Function FileSetDate(handle: integer; age: integer): integer');
 CL.AddDelphiFunction('Function DeleteFile(const FileName: string): boolean)');
 CL.AddDelphiFunction('Function FileGetAttr(const FileName: string): integer)');
 CL.AddDelphiFunction('Function FileSearch(const Name, dirList: string): string)');
 Cl.AddDelphiFunction('function RenameFile(const OldName: string; const NewName: string): Boolean)');
 CL.AddDelphiFunction('function FileSetAttr(const FileName: string; Attr: Integer): Integer)');
 CL.AddDelphiFunction('function CreateDir(const Dir: string): Boolean)');
 CL.AddDelphiFunction('function GetCurrentDir: string)');
 CL.AddDelphiFunction('function RemoveDir(const Dir: string): Boolean)');
 CL.AddDelphiFunction('function ExtractFileDir(const FileName: string): string)');
 CL.AddDelphiFunction('function SetCurrentDir(const Dir: string): Boolean)');
 CL.AddDelphiFunction('function DiskFree(Drive: Byte): Int64)');
 CL.AddDelphiFunction('function DiskSize(Drive: Byte): Int64)');
 CL.AddDelphiFunction('function CreateGUID(out Guid: TGUID): HResult)');
 CL.AddDelphiFunction('function CreateGUID2(var Guid: TGUID): HResult)');
 CL.AddDelphiFunction('function CreateGUID3(var aGuid: TGUID): HResult)');

 CL.AddDelphiFunction('function StringToGUID(const S: string): TGUID)');
 CL.AddDelphiFunction('function GUIDToString(const GUID: TGUID): string)');
 CL.AddDelphiFunction('function IsEqualGUID(const guid1, guid2: TGUID): Boolean)');

 CL.AddDelphiFunction('function FindFirst2(const Path: string; Attr: Integer; var F: TSearchRec): Integer)');
 CL.AddDelphiFunction('function FindNext2(var F: TSearchRec): Integer)');
 CL.AddDelphiFunction('procedure FindClose2(var F: TSearchRec)');

 CL.AddDelphiFunction('function ChangeFileExt(const FileName: string; const Extension: string): string)');
 CL.AddDelphiFunction('procedure FmtStr(var Result: string; const Format: string; const Args: array of const)');
 CL.AddDelphiFunction('function ExcludeTrailingBackslash(const S: string): string)');
 CL.AddDelphiFunction('function IncludeTrailingBackslash(const S: string): string)');
 CL.AddDelphiFunction('function ExcludeTrailingPathDelimiter(const S: string): string)');
 CL.AddDelphiFunction('function IncludeTrailingPathDelimiter(const S: string): string)');
 CL.AddDelphiFunction('function IsPathDelimiter(const S: string; Index: Integer): boolean)');
 CL.AddDelphiFunction('function ExpandFileName(const FileName: string): string)');
 //CL.AddDelphiFunction('function ExtractFileDir(const FileName: string): string)');
 CL.AddDelphiFunction('function ExpandUNCFileName(const FileName: string): string)');
 CL.AddDelphiFunction('function ExtractFileDrive(const FileName: string): string)');
 CL.AddDelphiFunction('function ExtractFileExt(const FileName: string): string)');
 CL.AddDelphiFunction('function ExtractShortPathName(const FileName: string): string)');
 CL.AddDelphiFunction('function ExtractRelativePath(const BaseName: string; const DestName: string): string)');
 CL.AddDelphiFunction('function AdjustLineBreaksS(const S: string): string)');
 CL.AddDelphiFunction('function AdjustLineBreaks(const S: string; Style: TTextLineBreakStyle): string;');

 //function AdjustLineBreaks(const S: string; Style: TTextLineBreakStyle): string;

 CL.AddDelphiFunction('function AnsiCompareFileName(const S1: string; const S2: string): Integer)');
 CL.AddDelphiFunction('function AnsiCompareStr(const S1: string; const S2: string): Integer;)');
 CL.AddDelphiFunction('function AnsiCompareText(const S1: string; const S2: string): Integer;)');
 CL.AddDelphiFunction('function AnsiPos(const Substr: string; const S: string): Integer;)');
 CL.AddDelphiFunction('function AnsiLastChar(const S: string): PChar)');
 CL.AddDelphiFunction('function AnsiSameCaption(const Text1: string; const Text2: string): Boolean)');
 CL.AddDelphiFunction('function AnsiSameStr(const S1: string; const S2: string): Boolean)');
 CL.AddDelphiFunction('function AnsiSameText(const S1: string; const S2: string): Boolean)');
 //WideCharString
 CL.AddDelphiFunction('function WideSameText(const S1: WideString; const S2: WideString): Boolean)');
 CL.AddDelphiFunction('function WideSameStr(const S1: WideString; const S2: WideString): Boolean)');
 CL.AddDelphiFunction('function WideLowerCase(const S: WideString): WideString)');
 CL.AddDelphiFunction('function WideFormat(const Format: WideString; const Args: array of const): WideString)');  //overload;
 CL.AddDelphiFunction('function WideCompareText(const S1: WideString; const S2: WideString): Integer)');
 CL.AddDelphiFunction('function WideCompareStr(const S1: WideString; const S2: WideString): Integer)');

 CL.AddDelphiFunction('function ByteToCharIndex(const S: string; Index: Integer): Integer)');
 CL.AddDelphiFunction('function CharToByteIndex(const S: string; Index: Integer): Integer)');
 CL.AddDelphiFunction('function ByteToCharLen(const S: string; MaxLen: Integer): Integer)');
 CL.AddDelphiFunction('function CharToByteLen(const S: string; MaxLen: Integer): Integer)');
 CL.AddDelphiFunction('function ByteType(const S: string; Index: Integer): TMbcsByteType)');
 CL.AddDelphiFunction('function StrByteType(Str: PChar; Index: Cardinal): TMbcsByteType)');
 CL.AddDelphiFunction('function IsDelimiter(const Delimiters: string; const S: string; Index: Integer): Boolean)');
 CL.AddDelphiFunction('function IsPathDelimiter(const S: string; Index: Integer): Boolean)');
 CL.AddDelphiFunction('function LastDelimiter(const Delimiters: string; const S: string): Integer)');
 //CL.AddDelphiFunction('function IsValidIdent(const Ident: string; AllowDots: Boolean): Boolean)');
 CL.AddDelphiFunction('function IsValidIdent1(const Ident: string; AllowDots: Boolean): Boolean)');
 CL.AddDelphiFunction('function IsValidIdent2(const Ident: string; AllowDots: Boolean): Boolean)');

 //Experimental and fix for 3.5
 CL.AddDelphiFunction('procedure New(P: PChar)');
 CL.AddDelphiFunction('procedure Dispose(P: PChar)');
 CL.AddDelphiFunction('procedure GetMemS(var S: String; Size: Integer)');
 CL.AddDelphiFunction('procedure FreeMemS(var S: String; Size: Integer)');
 CL.AddDelphiFunction('procedure GetMem(var P: PChar; Size: Integer)');
 CL.AddDelphiFunction('procedure GetMemP(var P: ___Pointer; Size: Integer)');
 CL.AddDelphiFunction('procedure FreeMem(P: PChar; Size: Integer)');
 //PCHAR functions
 CL.AddDelphiFunction('function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string)');
 CL.AddDelphiFunction('function AnsiStrComp(S1: PChar; S2: PChar): Integer)');
 CL.AddDelphiFunction('function AnsiStrIComp(S1: PChar; S2: PChar): Integer)');
 CL.AddDelphiFunction('function AnsiStrLastChar(P: PChar): PChar)');
 CL.AddDelphiFunction('function AnsiStrPos(Str: PChar; SubStr: PChar): PChar)');
 CL.AddDelphiFunction('function StrAlloc(Size: Cardinal): PChar)');
 CL.AddDelphiFunction('function StrBufSize(const Str: PChar): Cardinal)');
 CL.AddDelphiFunction('function StrNew(const Str: PChar): PChar)');
 CL.AddDelphiFunction('function StrCat(Dest: PChar; const Source: PChar): PChar)');
 CL.AddDelphiFunction('function StrCopy(Dest: PChar; const Source: PChar): PChar)');
 CL.AddDelphiFunction('procedure StrDispose(Str: PChar)');
 CL.AddDelphiFunction('function StrComp(const Str1: PChar; const Str2: PChar): Integer)');
 CL.AddDelphiFunction('function StrLen(const Str: PChar): Cardinal)');
 CL.AddDelphiFunction('function StrEnd(const Str: PChar): PChar)');
 CL.AddDelphiFunction('function StrMove(Dest: PChar; const Source: PChar; Count: Cardinal): PChar)');
 CL.AddDelphiFunction('function StrPCopy(Dest: PChar; const Source: string): PChar)');
 CL.AddDelphiFunction('function StrPas(const Str: PChar): string)');
 CL.AddDelphiFunction('function FloatToText(BufferArg: PChar; const Value: Extended; ValueType: TFloatValue; Format: TFloatFormat; Precision: Integer; Digits: Integer): Integer)');
 CL.AddDelphiFunction('function TextToFloat(Buffer: PChar; var Value: Extended; ValueType: TFloatValue): Boolean)');
 CL.AddDelphiFunction('function FloatToStrF(Value: Extended; Format: TFloatFormat; Precision: Integer; Digits: Integer): string)');
 CL.AddDelphiFunction('function FmtLoadStr(Ident: Integer; const Args: array of const): string)');
 CL.AddDelphiFunction('procedure FmtStr(var Result: string; const Format: string; const Args: array of const)');
 CL.AddDelphiFunction('Function StrFmt(Buffer, Format: PChar; const Args: array of const): PChar)');
 CL.AddDelphiFunction('Function StrLFmt(Buffer: PChar; MaxBufLen: Cardinal; Format: PChar; const Args: array of const): PChar;)');
 CL.AddDelphiFunction('Function StrScan(const Str: PChar; vChr: Char): PChar)');
 CL.AddDelphiFunction('function StrRScan(const Str: PChar; vChr: Char): PChar)');
 CL.AddDelphiFunction('function AnsiStrScan(Str: PChar; vChr: Char): PChar)');

               //comptocurrency from system

 CL.AddDelphiFunction('function FormatBuf(var Buffer: PChar; BufLen: Cardinal; const Format: string; FmtLen: Cardinal; const Args: array of const): Cardinal)');
 CL.AddDelphiFunction('function FormatCurr(const Format: string; Value: Currency): string)');
 CL.AddDelphiFunction('function FormatFloat(const Format: string; Value: Extended): string)');
 CL.AddDelphiFunction('function StrToCurr(const S: string): Currency)');
 CL.AddDelphiFunction('function CurrToStr(Value: Currency): string)');
 CL.AddDelphiFunction('function StrToInt64Def(const S: string; const Default: Int64):Int64)');
 CL.AddDelphiFunction('procedure AssignFile(var F: TextFile; FileName: string)');

 //from Unit Types
 CL.AddDelphiFunction('function Rect(ALeft: Integer; ATop: Integer; ARight: Integer; ABottom: Integer): TRect)');
 CL.AddDelphiFunction('function EqualRect(const R1, R2: TRect): Boolean)');
 //CL.AddDelphiFunction('function Point(X, Y: Integer): TPoint)');
 CL.AddDelphiFunction('function PtInRect(const Rect: TRect; const P: TPoint): Boolean)');
 CL.AddDelphiFunction('function IntersectRect(out Rect: TRect; const R1, R2: TRect): Boolean)');
 CL.AddDelphiFunction('function UnionRect(out Rect: TRect; const R1, R2: TRect): Boolean)');
 CL.AddDelphiFunction('function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TRect)');
 CL.AddDelphiFunction('Function BoolToStr(B: Boolean; UseBoolStrs: Boolean): string)');
 CL.AddDelphiFunction('function IsRectEmpty(const Rect: TRect): Boolean)');
 CL.AddDelphiFunction('function OffsetRect(var Rect: TRect; DX:Integer; DY:Integer): Boolean)');
 CL.AddDelphiFunction('function CenterPoint(const Rect: TRect): TPoint)');
 CL.AddDelphiFunction('function SmallPoint(X, Y: Integer): TSmallPoint)');
 CL.AddDelphiFunction('function StrFillChar(const C: Char; Count: Integer): string)');
 CL.AddDelphiFunction('function IntFillChar(const I: Integer; Count: Integer): string)');
 CL.AddDelphiFunction('function ByteFillChar(const B: Byte; Count: Integer): string)');
 CL.AddDelphiFunction('function ArrFillChar(const AC: Char; Count: Integer): TCharArray;');
 CL.AddDelphiFunction('function ArrByteFillChar(const AB: Char; Count: Integer): TByteArray;');

                                    //tsmallpoint
 //CL.AddFunction('Function GetWindowRect(hdwnd: HWND, arect: TRect): boolean;');
        //cl.add               // getwindowrect
 end;


 procedure getmemA(var P: PChar; Size: Integer);
 begin
   getmem(p, size);
 end;
procedure freemema(var P: PChar; Size: Integer);
 begin
   freemem(p, size);
 end;


 procedure getmemp(var p: pointer; size: integer);
 begin
   getmem(p, size);
 end;

 procedure getmems(var p: string; size: integer);
 begin
   getmem(pointer(p), size);
 end;

 procedure freemems(var p: string; size: integer);
 begin
   freemem(pchar(p), size);
 end;

 procedure myFillChar(var p: string; count: integer; value: char);
 begin
   FillChar(p, count, value);
 end;

 function StrFillChar(const C: Char; Count: Integer): string;
begin
  SetLength(Result, Count);
  if Count > 0 then
    FillChar(Result[1], Count, C);
end;

 function IntFillChar(const I: Integer; Count: Integer): string;
begin
  SetLength(Result, Count);
  if Count > 0 then
    FillChar(Result[1], Count, I);
end;

function ByteFillChar(const B: Byte; Count: Integer): string;
begin
  SetLength(Result, Count);
  if Count > 0 then
    FillChar(Result[1], Count, B);
end;

type TCharArray = array of char;

function ArrFillChar(const AC: Char; Count: Integer): TCharArray;
begin
  SetLength(Result, Count);
  if Count > 0 then
    FillChar(Result[1], Count, AC);
end;

function ArrByteFillChar(const AB: Char; Count: Integer): TByteArray;
begin
  //SetLength(Result, Count);
  if Count > 0 then
    FillChar(Result[1], Count, AB);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function MidStr2_P( const AText : WideString; const AStart, ACount : Integer) : WideString;
Begin Result := StrUtils.MidStr(AText, AStart, ACount); END;

(*----------------------------------------------------------------------------*)
Function MidStr1_P( const AText : AnsiString; const AStart, ACount : Integer) : AnsiString;
Begin Result := StrUtils.MidStr(AText, AStart, ACount); END;

(*----------------------------------------------------------------------------*)
Function RightStr2_P( const AText : WideString; const ACount : Integer) : WideString;
Begin Result := StrUtils.RightStr(AText, ACount); END;

(*----------------------------------------------------------------------------*)
Function RightStr1_P( const AText : AnsiString; const ACount : Integer) : AnsiString;
Begin Result := StrUtils.RightStr(AText, ACount); END;

(*----------------------------------------------------------------------------*)
Function LeftStr2_P( const AText : WideString; const ACount : Integer) : WideString;
Begin Result := StrUtils.LeftStr(AText, ACount); END;

(*----------------------------------------------------------------------------*)
Function LeftStr1_P( const AText : AnsiString; const ACount : Integer) : AnsiString;
Begin Result := StrUtils.LeftStr(AText, ACount); END;

(*----------------------------------------------------------------------------*)
Function IfThen1_P( AValue : Boolean; const ATrue : string; AFalse : string) : string;
Begin Result := StrUtils.IfThen(AValue, ATrue, AFalse); END;

(*----------------------------------------------------------------------------*)
Function RandomFrom1_P( const AValues : array of string) : string;
Begin Result := StrUtils.RandomFrom(AValues); END;

function CurrToStr_1(Value: Currency): string;
begin
  result:= CurrToStr(Value);
end;

function StrToCurr_1(Value: string): currency;
begin
  result:= StrToCurr(Value);
end;

procedure System_GetDir(d: byte; var s: string);
begin
  System.GetDir(d, s);
end;


function SearchBuf2(Buf: string; SelStart, SelLength: Integer;
  SearchString: String; Options: TStringSearchOptions): integer;
var
  pr, Pbuf: PChar;
  begin
    result:= 0;
    if buf <> '' then begin   { back up char, to leave ptr on first non delim }
      pbuf:= pchar(buf);
      pr:= strutils.SearchBuf(Pbuf,length(buf),selstart-1,sellength, searchstring,options);
      if pr<> NIL then result:= (pr-pbuf) + 1;
      //Dec(BufPtr, Direction);
      //Inc(SearchCount);
    end;
  end;

procedure FmtStr2(var Result: string; const Format: string;
  const Args: array of const; const FormatSettings: TFormatSettings);
begin
  FmtStr(Result, Format, Args, FormatSettings);
end;

function concat4( const Args: array of string): string;
var i: integer;
begin
  for I := 0 to length(args) - 1 do  result:= result + args[i];
    
  //result:= concat((args));
  //FmtStr(Result, concat4, Args);
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_StrUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ResemblesText, 'ResemblesText', cdRegister);
 S.RegisterDelphiFunction(@AnsiResemblesText, 'AnsiResemblesText', cdRegister);
 S.RegisterDelphiFunction(@ContainsText, 'ContainsText', cdRegister);
 S.RegisterDelphiFunction(@AnsiContainsText, 'AnsiContainsText', cdRegister);
 S.RegisterDelphiFunction(@StartsText, 'StartsText', cdRegister);
 S.RegisterDelphiFunction(@AnsiStartsText, 'AnsiStartsText', cdRegister);
 S.RegisterDelphiFunction(@EndsText, 'EndsText', cdRegister);
 S.RegisterDelphiFunction(@AnsiEndsText, 'AnsiEndsText', cdRegister);
 S.RegisterDelphiFunction(@ReplaceText, 'ReplaceText', cdRegister);
 S.RegisterDelphiFunction(@AnsiReplaceText, 'AnsiReplaceText', cdRegister);
 S.RegisterDelphiFunction(@MatchText, 'MatchText', cdRegister);
 S.RegisterDelphiFunction(@AnsiMatchText, 'AnsiMatchText', cdRegister);
 S.RegisterDelphiFunction(@IndexText, 'IndexText', cdRegister);
 S.RegisterDelphiFunction(@AnsiIndexText, 'AnsiIndexText', cdRegister);
 S.RegisterDelphiFunction(@ContainsStr, 'ContainsStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiContainsStr, 'AnsiContainsStr', cdRegister);
 S.RegisterDelphiFunction(@StartsStr, 'StartsStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiStartsStr, 'AnsiStartsStr', cdRegister);
 S.RegisterDelphiFunction(@EndsStr, 'EndsStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiEndsStr, 'AnsiEndsStr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStr, 'ReplaceStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiReplaceStr, 'AnsiReplaceStr', cdRegister);
 S.RegisterDelphiFunction(@MatchStr, 'MatchStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiMatchStr, 'AnsiMatchStr', cdRegister);
 S.RegisterDelphiFunction(@IndexStr, 'IndexStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiIndexStr, 'AnsiIndexStr', cdRegister);
 S.RegisterDelphiFunction(@DupeString, 'DupeString', cdRegister);
 S.RegisterDelphiFunction(@ReverseString, 'ReverseString', cdRegister);
 S.RegisterDelphiFunction(@AnsiReverseString, 'AnsiReverseString', cdRegister);
 S.RegisterDelphiFunction(@StuffString, 'StuffString', cdRegister);
 //S.RegisterDelphiFunction(@RandomFrom, 'RandomFrom', cdRegister);
 S.RegisterDelphiFunction(@RandomFrom1_P, 'RandomFrom', cdRegister);
 S.RegisterDelphiFunction(@IfThen1_P, 'IfThen', cdRegister);


 S.RegisterDelphiFunction(@LeftStr1_P, 'LeftStr', cdRegister);
 S.RegisterDelphiFunction(@LeftStr2_P, 'LeftStr2', cdRegister);
 S.RegisterDelphiFunction(@RightStr1_P, 'RightStr', cdRegister);
 S.RegisterDelphiFunction(@RightStr2_P, 'RightStr2', cdRegister);
 S.RegisterDelphiFunction(@MidStr1_P, 'MidStr', cdRegister);
 S.RegisterDelphiFunction(@MidStr2_P, 'MidStr2', cdRegister);
 S.RegisterDelphiFunction(@LeftBStr, 'LeftBStr', cdRegister);
 S.RegisterDelphiFunction(@RightBStr, 'RightBStr', cdRegister);
 S.RegisterDelphiFunction(@MidBStr, 'MidBStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiLeftStr, 'AnsiLeftStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiRightStr, 'AnsiRightStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiMidStr, 'AnsiMidStr', cdRegister);

 S.RegisterDelphiFunction(@WideSameText, 'WideSameText', cdRegister);
 S.RegisterDelphiFunction(@WideSameStr, 'WideSameStr', cdRegister);
 S.RegisterDelphiFunction(@WideLowerCase, 'WideLowerCase', cdRegister);
 S.RegisterDelphiFunction(@WideFormat, 'WideFormat', cdRegister);
 S.RegisterDelphiFunction(@WideCompareText, 'WideCompareText', cdRegister);
 S.RegisterDelphiFunction(@WideCompareStr, 'WideCompareStr', cdRegister);

 S.RegisterDelphiFunction(@StringReplace, 'StringReplace', cdRegister);
 S.RegisterDelphiFunction(@SearchBuf, 'SearchBuf', cdRegister);
 S.RegisterDelphiFunction(@SearchBuf2, 'SearchBuf2', cdRegister);
 S.RegisterDelphiFunction(@PosEx, 'PosEx', cdRegister);
 S.RegisterDelphiFunction(@Soundex, 'Soundex', cdRegister);
 S.RegisterDelphiFunction(@SoundexInt, 'SoundexInt', cdRegister);
 S.RegisterDelphiFunction(@DecodeSoundexInt, 'DecodeSoundexInt', cdRegister);
 S.RegisterDelphiFunction(@SoundexWord, 'SoundexWord', cdRegister);
 S.RegisterDelphiFunction(@DecodeSoundexWord, 'DecodeSoundexWord', cdRegister);
 S.RegisterDelphiFunction(@SoundexSimilar, 'SoundexSimilar', cdRegister);
 S.RegisterDelphiFunction(@SoundexCompare, 'SoundexCompare', cdRegister);
 S.RegisterDelphiFunction(@SoundexProc, 'SoundexProc', cdRegister);
 S.RegisterDelphiFunction(@ParamCount, 'ParamCount',cdRegister);
 //S.RegisterDelphiFunction(@FreeAndNIL, 'FreeAndNIL',cdRegister);

 S.RegisterDelphiFunction(@MkDir,'MkDir', cdRegister);
 S.RegisterDelphiFunction(@ChDir,'ChDir', cdRegister);
 S.RegisterDelphiFunction(@MkDir,'MakeDir', cdRegister);
 S.RegisterDelphiFunction(@ChDir,'ChangeDir', cdRegister);

 S.RegisterDelphiFunction(@RMDir,'RmDir', cdRegister);
 S.RegisterDelphiFunction(@System_GetDir,'GetDir', cdRegister);
 S.RegisterDelphiFunction(@FileCreate,'FileCreate', cdRegister);
 S.RegisterDelphiFunction(@FileCreate,'MakeFile', cdRegister);
 S.RegisterDelphiFunction(@FileCreate,'MkFile', cdRegister);

 S.RegisterDelphiFunction(@FileClose,'FileClose', cdRegister);
 S.RegisterDelphiFunction(@FileAge, 'FileAge', cdRegister);
 S.RegisterDelphiFunction(@FileGetDate, 'FileGetDate', cdRegister);
 S.RegisterDelphiFunction(@FileOpen,'FileOpen', cdRegister);
 S.RegisterDelphiFunction(@FileRead,'FileRead', cdRegister);
 S.RegisterDelphiFunction(@FileSeek,'FileSeek', cdRegister);
 S.RegisterDelphiFunction(@FileSetDate,'FileSetDate', cdRegister);
 S.RegisterDelphiFunction(@DeleteFile,'DeleteFile', cdRegister);
 S.RegisterDelphiFunction(@FileGetAttr,'FileGetAttr', cdRegister);
 S.RegisterDelphiFunction(@FileSearch,'FileSearch', cdRegister);
 S.RegisterDelphiFunction(@RenameFile,'RenameFile', cdRegister);
 S.RegisterDelphiFunction(@FileSetAttr,'FileSetAttr', cdRegister);
 S.RegisterDelphiFunction(@FileWrite,'FileWrite', cdRegister);

 S.RegisterDelphiFunction(@CreateDir,'CreateDir', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentDir,'GetCurrentDir', cdRegister);
 S.RegisterDelphiFunction(@RemoveDir,'RemoveDir', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDir,'ExtractFileDir', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentDir,'SetCurrentDir', cdRegister);
  S.RegisterDelphiFunction(@DiskFree,'DiskFree', cdRegister);
 S.RegisterDelphiFunction(@DiskSize,'DiskSize', cdRegister);
 S.RegisterDelphiFunction(@ParamStr, 'ParamStr', cdRegister);

 S.RegisterDelphiFunction(@Abort,'Abort', cdRegister);
 S.RegisterDelphiFunction(@CallTerminateProcs,'CallTerminateProcs', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastWin32Error,'RaiseLastWin32Error', cdRegister);
 S.RegisterDelphiFunction(@Win32Check,'Win32Check', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'SysErrorMessage', cdRegister);

 S.RegisterDelphiFunction(@LastDelimiter,'LastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@SameText,'SameText', cdRegister);
 S.RegisterDelphiFunction(@CompareStr,'CompareStr', cdRegister);
 S.RegisterDelphiFunction(@CompareStr,'CompareString', cdRegister);
 S.RegisterDelphiFunction(@CompareText,'CompareText', cdRegister);
 S.RegisterDelphiFunction(@TrimLeft,'TrimLeft', cdRegister);
 S.RegisterDelphiFunction(@TrimRight,'TrimRight', cdRegister);
 S.RegisterDelphiFunction(@StrToIntDef,'StrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatDef,'StrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@ExtractStrings,'ExtractStrings', cdRegister);
 S.RegisterDelphiFunction(@LineStart,'LineStart', cdRegister);
 S.RegisterDelphiFunction(@HexToBin, 'HexToBin', cdRegister); //overload
 S.RegisterDelphiFunction(@BinToHex, 'BinToHex', cdRegister); //overload
 S.RegisterDelphiFunction(@UniqueString,'UniqueString', cdRegister);
 S.RegisterDelphiFunction(@mySetString, 'SetString', cdRegister);
 S.RegisterDelphiFunction(@mySetLength, 'SetLength2', cdRegister);

 //S.RegisterDelphiFunction(@StringofChar,'StringofChar', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt,'ChangeFileExt', cdRegister);
 S.RegisterDelphiFunction(@FmtStr,'FmtStr', cdRegister);
 S.RegisterDelphiFunction(@FmtStr2,'FmtStr2', cdRegister);
 S.RegisterDelphiFunction(@StrFmt,'StrFmt', cdRegister);
 S.RegisterDelphiFunction(@StrLFmt,'StrLFmt', cdRegister);
 S.RegisterDelphiFunction(@StrScan,'StrScan', cdRegister);
 S.RegisterDelphiFunction(@StrRScan,'StrRScan', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrScan,'AnsiStrScan', cdRegister);

 S.RegisterDelphiFunction(@ExcludeTrailingBackslash,'ExcludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingBackslash,'IncludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter,'ExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiter,'IncludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiter,'IsPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName,'ExpandFileName', cdRegister);
 //S.RegisterDelphiFunction(@ExtractFileDir,'ExtractFileDir', cdRegister);
 S.RegisterDelphiFunction(@ExpandUNCFileName, 'ExpandUNCFileName',cdRegister);
  S.RegisterDelphiFunction(@ExtractFileDrive,'ExtractFileDrive', cdRegister);
  S.RegisterDelphiFunction(@ExtractFileExt,'ExtractFileExt', cdRegister);
  S.RegisterDelphiFunction(@ExtractShortPathName,'ExtractShortPathName', cdRegister);
  S.RegisterDelphiFunction(@ExtractRelativePath,'ExtractRelativePath', cdRegister);
 S.RegisterDelphiFunction(@AdjustLineBreaks,'AdjustLineBreaks', cdRegister);
 S.RegisterDelphiFunction(@AdjustLineBreaks,'AdjustLineBreaksS', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareFileName,'AnsiCompareFileName', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareStr,'AnsiCompareStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareText,'AnsiCompareText', cdRegister);
 S.RegisterDelphiFunction(@AnsiPos,'AnsiPost', cdRegister);
 S.RegisterDelphiFunction(@AnsiLastChar,'AnsiLastChar', cdRegister);
 //S.RegisterDelphiFunction(@AnsiSameCaption,'AnsiSameCaption', cdRegister);
 S.RegisterDelphiFunction(@AnsiSameStr,'AnsiSameStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiSameText,'AnsiSameText', cdRegister);
 S.RegisterDelphiFunction(@ByteToCharIndex,'ByteToCharIndex', cdRegister);
 S.RegisterDelphiFunction(@CharToByteIndex,'CharToByteIndex', cdRegister);
 S.RegisterDelphiFunction(@ByteToCharLen,'ByteToCharLen', cdRegister);
 S.RegisterDelphiFunction(@CharToByteLen,'CharToByteLen', cdRegister);
 S.RegisterDelphiFunction(@CreateGUID,'CreateGUID', cdRegister);
 S.RegisterDelphiFunction(@CreateGUID,'CreateGUID2', cdRegister);
 S.RegisterDelphiFunction(@CreateGUID,'CreateGUID3', cdRegister);

 S.RegisterDelphiFunction(@StringToGUID, 'StringToGUID', cdRegister);
 S.RegisterDelphiFunction(@GUIDToString, 'GUIDToString', cdRegister);
 S.RegisterDelphiFunction(@IsEqualGUID, 'IsEqualGUID', cdRegister);

 S.RegisterDelphiFunction(@ByteType,'ByteType', cdRegister);
 S.RegisterDelphiFunction(@StrByteType,'StrByteType', cdRegister);
 S.RegisterDelphiFunction(@IsDelimiter,'IsDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiter,'IsPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@LastDelimiter,'LastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IsValidIdent,'IsValidIdent1', cdRegister);
 S.RegisterDelphiFunction(@IsValidIdent,'IsValidIdent2', cdRegister);
 S.RegisterDelphiFunction(@InputQuery, 'InputQuery', cdRegister);
 S.RegisterDelphiFunction(@InputBox,'InputBox', cdRegister);
 //S.RegisterDelphiFunction(@MessageDlg,'MessageDlg', cdRegister);
 S.RegisterDelphiFunction(@ShowMessageFmt, 'ShowMessageFmt', cdRegister);
 S.RegisterDelphiFunction(@ShowMessagePos,'ShowMessagePos', cdRegister);
 S.RegisterDelphiFunction(@PromptForFileName,'PromptForFileName', cdRegister);
 S.RegisterDelphiFunction(@PromptForFileName,'OpenFileDialog', cdRegister);
 S.RegisterDelphiFunction(@Sysutils.FindFirst,'FindFirst2', cdRegister);
 S.RegisterDelphiFunction(@Sysutils.FindNext, 'FindNext2', cdRegister);
 S.RegisterDelphiFunction(@Sysutils.FindClose,'FindClose2', cdRegister);

 //PCHAR functions
 S.RegisterDelphiFunction(@AnsiExtractQuotedStr,'AnsiExtractQuotedStr', cdRegister);
  S.RegisterDelphiFunction(@AnsiStrComp,'AnsiStrComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrIComp,'AnsiExtractQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLastChar,'AnsiStrLastChar', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrPos,'AnsiStrPos', cdRegister);
 S.RegisterDelphiFunction(@StrAlloc,'StrAlloc', cdRegister);
 S.RegisterDelphiFunction(@StrBufSize,'StrBufSize', cdRegister);
 S.RegisterDelphiFunction(@StrNew,'StrNew', cdRegister);
 S.RegisterDelphiFunction(@StrCat,'StrCat', cdRegister);
  S.RegisterDelphiFunction(@StrCopy,'StrCopy', cdRegister);
 S.RegisterDelphiFunction(@StrDispose,'StrDispose', cdRegister);
 S.RegisterDelphiFunction(@StrComp,'StrComp', cdRegister);
 S.RegisterDelphiFunction(@StrLen,'StrLen', cdRegister);
 S.RegisterDelphiFunction(@StrEnd,'StrEnd', cdRegister);
 S.RegisterDelphiFunction(@StrMove,'StrMove', cdRegister);
 S.RegisterDelphiFunction(@StrPCopy,'StrPCopy', cdRegister);
 S.RegisterDelphiFunction(@StrPas,'StrPas', cdRegister);
 S.RegisterDelphiFunction(@Sysutils.FloatToText,'FloatToText', cdRegister);
 S.RegisterDelphiFunction(@TextToFloat,'TextToFloat', cdRegister);
 S.RegisterDelphiFunction(@FloatToStrF,'FloatToStrF', cdRegister);
 S.RegisterDelphiFunction(@FmtLoadStr,'FmtLoadStr', cdRegister);
 S.RegisterDelphiFunction(@FmtStr,'FmtStr', cdRegister);
 S.RegisterDelphiFunction(@FormatBuf,'FormatBuf', cdRegister);
 S.RegisterDelphiFunction(@FormatCurr,'FormatCurr', cdRegister);
 S.RegisterDelphiFunction(@StrToCurr_1,'StrToCurr', cdRegister);
 S.RegisterDelphiFunction(@FormatFloat,'FormatFloat', cdRegister);
 S.RegisterDelphiFunction(@CurrToStr_1,'CurrToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToInt64Def,'StrToInt64Def', cdRegister);
 S.RegisterDelphiFunction(@Rect,'Rect', cdRegister);
  S.RegisterDelphiFunction(@EqualRect,'EqualRect', cdRegister);
 //S.RegisterDelphiFunction(@Point,'Point', cdRegister);
 S.RegisterDelphiFunction(@PtInRect,'PtInRect', cdRegister);
 S.RegisterDelphiFunction(@IntersectRect,'IntersectRect', cdRegister);
 S.RegisterDelphiFunction(@UnionRect,'UnionRect', cdRegister);
 S.RegisterDelphiFunction(@BoolToStr,'BoolToStr', cdRegister);
 S.RegisterDelphiFunction(@IsRectEmpty,'IsRectEmpty', cdRegister);
 S.RegisterDelphiFunction(@OffsetRect,'OffsetRect', cdRegister);
 S.RegisterDelphiFunction(@CenterPoint,'CenterPoint', cdRegister);
 S.RegisterDelphiFunction(@SmallPoint,'SmallPoint', cdRegister);

 //S.RegisterDelphiFunction(@GetASCII,'GetASCII', cdRegister);

 //S.RegisterDelphiFunction(@AssignFile(mF, mFileName), 'AssignFile', cdRegister);
 {S.RegisterDelphiFunction(@New, 'New', cdRegister);               //3.5
 S.RegisterDelphiFunction(@Dispose,'Dispose', cdRegister);
 S.RegisterDelphiFunction(@GetMem, 'GetMem', cdRegister);
 S.RegisterDelphiFunction(@FreeMem,'FreeMem', cdRegister);}
 S.RegisterDelphiFunction(@GetMemA, 'GetMem', cdRegister);
 S.RegisterDelphiFunction(@GetMemS, 'GetMemS', cdRegister);
  S.RegisterDelphiFunction(@FreeMemA,'FreeMem', cdRegister);
  S.RegisterDelphiFunction(@FreeMemS,'FreeMemS', cdRegister);

  S.RegisterDelphiFunction(@StrFillChar,'FillCharS', cdRegister);
  S.RegisterDelphiFunction(@StrFillChar,'StrFillChar', cdRegister);
  S.RegisterDelphiFunction(@IntFillChar,'IntFillChar', cdRegister);
  S.RegisterDelphiFunction(@ByteFillChar,'ByteFillChar', cdRegister);
  S.RegisterDelphiFunction(@ArrFillChar,'ArrFillChar', cdRegister);
  S.RegisterDelphiFunction(@ArrFillChar,'ArrByteFillChar', cdRegister);

 S.RegisterDelphiFunction(@Concat4,'Concat', cdRegister);
 S.RegisterDelphiFunction(@GetMemP, 'GetMemP', cdRegister);
 S.RegisterDelphiFunction(@RaiseException3, 'RaiseException3', cdRegister);
 S.RegisterDelphiFunction(@RaiseException3, 'RaiseExcept', cdRegister);

// procedure RaiseException3(const Msg: string);
end;



{ TPSImport_StrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StrUtils(ri);
  RIRegister_StrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)

 
end.
