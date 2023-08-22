unit uPSI_JvJCLUtils;
{
  in line with JvUtils and jVFunctions_max; experimental mash up
  integerlist with count! add raiselastwin32_2
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
  TPSImport_JvJCLUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIntegerList(CL: TPSPascalCompiler);
procedure SIRegister_JvJCLUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIntegerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvJCLUtils_Routines(S: TPSExec);
procedure RIRegister_JvJCLUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  //Messages
  //,ShlObj
  //,ActiveX
 // ,Variants
  //,Contnrs
  ,Graphics
  //,Clipbrd
  ,Controls
  ,StrUtils
  //,TypInfo
  ,JclBase
  ,JvTypes
  ,JvJCLUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvJCLUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStrJ(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;


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

function binToStr(ans: string): string;
  begin
    result:= intToStr(bintoint(ans));
  end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TIntegerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TIntegerList') do
  with CL.AddClassN(CL.FindClass('TList'),'TIntegerList') do begin
    RegisterMethod('constructor CREATE)');
    RegisterMethod('procedure Sort');
    RegisterMethod('Procedure ReadData( Reader : TReader)');
    RegisterMethod('Procedure WriteData( Writer : TWriter)');
    RegisterProperty('Loading', 'Boolean', iptr);
    RegisterMethod('Function Add( Value : Integer) : Integer');
    RegisterMethod('Function Extract( Item : Integer) : Integer');
    RegisterMethod('Function First : Integer');
    RegisterMethod('Function IndexOf( Item : Integer) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; Item : Integer)');
    RegisterMethod('Function Last : Integer');
    RegisterMethod('Function Remove( Item : Integer) : Integer');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'Integer Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('OnChange', 'TIntegerListChange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvJCLUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PathDelim','String').SetString( '\');
 CL.AddConstantN('DriveDelim','String').SetString( ':');
 CL.AddConstantN('PathSep','String').SetString( ';');
 CL.AddConstantN('AllFilesMask','String').SetString( '*.*');
 CL.AddConstantN('PathDelim','String').SetString( '/');
 CL.AddConstantN('AllFilesMask','String').SetString( '*');
 CL.AddConstantN('NullHandle','LongInt').SetInt( 0);
 CL.AddConstantN('USDecimalSeparator','String').SetString( '.');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvConvertError');
  CL.AddTypeS('TJFileTime', 'Integer');
 // CL.AddTypeS('TFormatSettings', 'record DecimalSeparator : Char; end');
 CL.AddDelphiFunction('Function SendRectMessage( Handle : THandle; Msg : Integer; wParam : longint; var R : TRect) : Integer');
 //CL.AddDelphiFunction('Function SendStructMessage( Handle : THandle; Msg : Integer; wParam : WPARAM; var Data) : Integer');
 CL.AddDelphiFunction('Function ReadCharsFromStream( Stream : TStream; var Buf : array of PChar; BufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function WriteStringToStream( Stream : TStream; const Buf : AnsiString; BufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function UTF8ToString( const S : UTF8String) : string');
 //CL.AddConstantN('DefaultDateOrder','').SetString('doDMY');
 CL.AddConstantN('CenturyOffset','Byte').SetUInt( 60);
 //CL.AddConstantN('NullDate','TDateTime').SetString('0');
 CL.AddDelphiFunction('Function VarIsInt( Value : Variant) : Boolean');
 CL.AddDelphiFunction('Function PosIdx( const SubStr, S : string; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function PosIdxW( const SubStr, S : WideString; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function PosLastCharIdx( Ch : Char; const S : string; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function GetWordOnPos( const S : string; const P : Integer) : string');
 CL.AddDelphiFunction('Function GetWordOnPosW( const S : WideString; const P : Integer) : WideString');
 CL.AddDelphiFunction('Function GetWordOnPos2( const S : string; P : Integer; var iBeg, iEnd : Integer) : string');
 CL.AddDelphiFunction('Function GetWordOnPos2W( const S : WideString; P : Integer; var iBeg, iEnd : Integer) : WideString');
 CL.AddDelphiFunction('Function GetWordOnPosEx( const S : string; const P : Integer; var iBeg, iEnd : Integer) : string');
 CL.AddDelphiFunction('Function GetWordOnPosExW( const S : WideString; const P : Integer; var iBeg, iEnd : Integer) : WideString');
 CL.AddDelphiFunction('Function GetNextWordPosEx( const Text : string; StartIndex : Integer; var iBeg, iEnd : Integer) : string');
 CL.AddDelphiFunction('Function GetNextWordPosExW( const Text : WideString; StartIndex : Integer; var iBeg, iEnd : Integer) : WideString');
 CL.AddDelphiFunction('Procedure GetEndPosCaret( const Text : string; CaretX, CaretY : Integer; var X, Y : Integer)');
 CL.AddDelphiFunction('Procedure GetEndPosCaretW( const Text : WideString; CaretX, CaretY : Integer; var X, Y : Integer)');
 CL.AddDelphiFunction('Function SubStrBySeparator( const S : string; const Index : Integer; const Separator : string; StartIndex : Integer) : string');
 CL.AddDelphiFunction('Function SubStrBySeparatorW( const S : WideString; const Index : Integer; const Separator : WideString; StartIndex : Integer) : WideString');
 CL.AddDelphiFunction('Function SubWord( P : PChar; var P2 : PChar) : string');
 CL.AddDelphiFunction('Function GetLineByPos( const S : string; const Pos : Integer) : Integer');
 CL.AddDelphiFunction('Procedure GetXYByPos( const S : string; const Pos : Integer; var X, Y : Integer)');
 CL.AddDelphiFunction('Procedure GetXYByPosW( const S : WideString; const Pos : Integer; var X, Y : Integer)');
 CL.AddDelphiFunction('Function ReplaceStringJ( S : string; const OldPattern, NewPattern : string; StartIndex : Integer) : string');
 CL.AddDelphiFunction('Function ReplaceStringW( S : WideString; const OldPattern, NewPattern : WideString; StartIndex : Integer) : WideString');
 CL.AddDelphiFunction('Function ConcatSep( const S1, S2, Separator : string) : string');
 CL.AddDelphiFunction('Function ConcatLeftSep( const S1, S2, Separator : string) : string');
 CL.AddDelphiFunction('Procedure Dos2Win( var S : AnsiString)');
 CL.AddDelphiFunction('Procedure Win2Dos( var S : AnsiString)');
 CL.AddDelphiFunction('Function Dos2WinRes( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function Win2DosRes( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function Win2Koi( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure FillString( var Buffer : string; Count : Integer; const Value : Char);');
 CL.AddDelphiFunction('Procedure FillString1( var Buffer : string; StartIndex, Count : Integer; const Value : Char);');
 CL.AddDelphiFunction('Procedure MoveStringJV( const Source : string; var Dest : string; Count : Integer);');
 CL.AddDelphiFunction('Procedure MoveString1( const Source : string; SrcStartIdx : Integer; var Dest : string; DstStartIdx : Integer; Count : Integer);');
 CL.AddDelphiFunction('Procedure FillWideChar( var Buffer, Count : Integer; const Value : WideChar)');
 CL.AddDelphiFunction('Procedure FillNativeChar( var Buffer, Count : Integer; const Value : Char)');
 CL.AddDelphiFunction('Function IsSubString( const S : string; StartIndex : Integer; const SubStr : string) : Boolean');
 CL.AddDelphiFunction('Function Spaces( const N : Integer) : string');
 CL.AddDelphiFunction('Function AddSpaces( const S : string; const N : Integer) : string');
 CL.AddDelphiFunction('Function SpacesW( const N : Integer) : WideString');
 CL.AddDelphiFunction('Function AddSpacesW( const S : WideString; const N : Integer) : WideString');
 CL.AddDelphiFunction('Function LastDateRUS( const Dat : TDateTime) : string');
 CL.AddDelphiFunction('Function CurrencyToStr( const Cur : Currency) : string');
 CL.AddDelphiFunction('Function HasChar( const Ch : Char; const S : string) : Boolean');
 CL.AddDelphiFunction('Function HasCharW( const Ch : WideChar; const S : WideString) : Boolean');
 CL.AddDelphiFunction('Function HasAnyChar( const Chars : string; const S : string) : Boolean');
 //CL.AddDelphiFunction('Function CharInSet( const Ch : AnsiChar; const SetOfChar : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('Function CharInSetW( const Ch : WideChar; const SetOfChar : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('Function CountOfChar( const Ch : Char; const S : string) : Integer');
 CL.AddDelphiFunction('Function DefStr( const S : string; Default : string) : string');
 //CL.AddDelphiFunction('Function StrLICompW2( S1, S2 : PWideChar; MaxLen : Integer) : Integer');
 //CL.AddDelphiFunction('Function StrPosW( S, SubStr : PWideChar) : PWideChar');
 //CL.AddDelphiFunction('Function StrLenW( S : PWideChar) : Integer');
 CL.AddDelphiFunction('Function TrimW( const S : WideString) : WideString');
 CL.AddDelphiFunction('Function TrimLeftW( const S : WideString) : WideString');
 CL.AddDelphiFunction('Function TrimRightW( const S : WideString) : WideString');
 CL.AddDelphiFunction('Procedure SetDelimitedText( List : TStrings; const Text : string; Delimiter : Char)');
 //CL.AddConstantN('DefaultCaseSensitivity','Boolean')BoolToStr( False);
 //CL.AddConstantN('DefaultCaseSensitivity','Boolean')BoolToStr( False);
 CL.AddDelphiFunction('Function GenTempFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function GenTempFileNameExt( FileName : string; const FileExt : string) : string');
 CL.AddDelphiFunction('Function ClearDir( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function DeleteDir( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function FileEquMask( FileName, Mask : TFileName; CaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function FileEquMasks( FileName, Masks : TFileName; CaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function DeleteFiles( const Folder : TFileName; const Masks : string) : Boolean');
 CL.AddDelphiFunction('Function LZFileExpand( const FileSource, FileDest : string) : Boolean');
 CL.AddDelphiFunction('Function FileGetInfo( FileName : TFileName; var SearchRec : TSearchRec) : Boolean');
 CL.AddDelphiFunction('Function HasSubFolder( APath : TFileName) : Boolean');
 CL.AddDelphiFunction('Function IsEmptyFolder( APath : TFileName) : Boolean');
 CL.AddDelphiFunction('Function AddSlash( const Dir : TFileName) : string');
 CL.AddDelphiFunction('Function AddPath( const FileName, Path : TFileName) : TFileName');
 CL.AddDelphiFunction('Function AddPaths( const PathList, Path : string) : string');
 CL.AddDelphiFunction('Function ParentPath( const Path : TFileName) : TFileName');
 CL.AddDelphiFunction('Function FindInPath( const FileName, PathList : string) : TFileName');
 CL.AddDelphiFunction('Function DeleteReadOnlyFile( const FileName : TFileName) : Boolean');
 CL.AddDelphiFunction('Function HasParam( const Param : string) : Boolean');
 CL.AddDelphiFunction('Function HasSwitch( const Param : string) : Boolean');
 CL.AddDelphiFunction('Function Switch( const Param : string) : string');
 CL.AddDelphiFunction('Function ExePathJ : TFileName');
 CL.AddDelphiFunction('Function CopyDir( const SourceDir, DestDir : TFileName) : Boolean');
 CL.AddDelphiFunction('Procedure FileTimeToDosDateTimeDWord( const FT : TJFileTime; out Dft : DWORD)');
 CL.AddDelphiFunction('Function MakeValidFileName( const FileName : TFileName; ReplaceBadChar : Char) : TFileName');
 CL.AddDelphiFunction('Function IsTTFontSelected( const DC : HDC) : Boolean');
 CL.AddDelphiFunction('Function KeyPressed( VK : Integer) : Boolean');
 CL.AddDelphiFunction('Function TrueInflateRect( const R : TRect; const I : Integer) : TRect');
 CL.AddDelphiFunction('Procedure RGBToHSV( R, G, B : Integer; var H, S, V : Integer)');
 CL.AddDelphiFunction('Function RGBToBGR( Value : Cardinal) : Cardinal');
 //CL.AddDelphiFunction('Function ColorToPrettyName( Value : TColor) : string');
 //CL.AddDelphiFunction('Function PrettyNameToColor( const Value : string) : TColor');
 CL.AddDelphiFunction('Procedure SwapIntJ( var Int1, Int2 : Integer)');
 CL.AddDelphiFunction('Function IntPowerJ( Base, Exponent : Integer) : Integer');
 CL.AddDelphiFunction('Function ChangeTopException( E : TObject) : TObject');
 CL.AddDelphiFunction('Function StrToBoolJ( const S : string) : Boolean');
 CL.AddDelphiFunction('Function Var2Type( V : Variant; const DestVarType : Integer) : Variant');
 CL.AddDelphiFunction('Function VarToInt( V : Variant) : Integer');
 CL.AddDelphiFunction('Function VarToFloat( V : Variant) : Double');
 CL.AddDelphiFunction('Function GetLongFileName( const FileName : string) : string');
 CL.AddDelphiFunction('Function FileNewExt( const FileName, NewExt : TFileName) : TFileName');
 CL.AddDelphiFunction('Function GetParameter : string');
 CL.AddDelphiFunction('Function GetComputerID : string');
 CL.AddDelphiFunction('Function GetComputerName : string');
 CL.AddDelphiFunction('Function ReplaceAllStrings( const S : string; Words, Frases : TStrings) : string');
 CL.AddDelphiFunction('Function ReplaceStrings( const S : string; PosBeg, Len : Integer; Words, Frases : TStrings; var NewSelStart : Integer) : string');
 CL.AddDelphiFunction('Function CountOfLines( const S : string) : Integer');
 CL.AddDelphiFunction('Procedure DeleteOfLines( Ss : TStrings; const Words : array of string)');
 CL.AddDelphiFunction('Procedure DeleteEmptyLines( Ss : TStrings)');
 CL.AddDelphiFunction('Procedure SQLAddWhere( SQL : TStrings; const Where : string)');
 CL.AddDelphiFunction('Function ResSaveToFile( const Typ, Name : string; const Compressed : Boolean; const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function ResSaveToFileEx( Instance : HINST; Typ, Name : PChar; const Compressed : Boolean; const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function ResSaveToString( Instance : HINST; const Typ, Name : string; var S : string) : Boolean');
 CL.AddDelphiFunction('Function IniReadSection( const IniFileName : TFileName; const Section : string; Ss : TStrings) : Boolean');
 CL.AddDelphiFunction('Function LoadTextFile( const FileName : TFileName) : string');
 CL.AddDelphiFunction('Procedure SaveTextFile( const FileName : TFileName; const Source : string)');
 CL.AddDelphiFunction('Function ReadFolder( const Folder, Mask : TFileName; FileList : TStrings) : Integer');
 CL.AddDelphiFunction('Function ReadFolders( const Folder : TFileName; FolderList : TStrings) : Integer');
 CL.AddDelphiFunction('Procedure RATextOut( Canvas : TCanvas; const R, RClip : TRect; const S : string)');
 CL.AddDelphiFunction('Function RATextOutEx( Canvas : TCanvas; const R, RClip : TRect; const S : string; const CalcHeight : Boolean) : Integer');
 CL.AddDelphiFunction('Function RATextCalcHeight( Canvas : TCanvas; const R : TRect; const S : string) : Integer');
 CL.AddDelphiFunction('Procedure Cinema( Canvas : TCanvas; rS, rD : TRect)');
 CL.AddDelphiFunction('Procedure Roughed( ACanvas : TCanvas; const ARect : TRect; const AVert : Boolean)');
 CL.AddDelphiFunction('Function BitmapFromBitmap( SrcBitmap : TBitmap; const AWidth, AHeight, Index : Integer) : TBitmap');
 CL.AddDelphiFunction('Function TextWidth( const AStr : string) : Integer');
 CL.AddDelphiFunction('Function TextHeight( const AStr : string) : Integer');
 CL.AddDelphiFunction('Procedure SetChildPropOrd( Owner : TComponent; const PropName : string; Value : Longint)');
 CL.AddDelphiFunction('Procedure Error( const Msg : string)');
 CL.AddDelphiFunction('Procedure ItemHtDrawEx( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean; var PlainItem : string; var Width : Integer; CalcWidth : Boolean)');
 CL.AddDelphiFunction('Function ItemHtDraw( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : string');
 CL.AddDelphiFunction('Function ItemHtWidth( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : Integer');
 CL.AddDelphiFunction('Function ItemHtPlain( const Text : string) : string');
 CL.AddDelphiFunction('Procedure ClearList( List : TList)');
 CL.AddDelphiFunction('Procedure MemStreamToClipBoard( MemStream : TMemoryStream; const Format : Word)');
 CL.AddDelphiFunction('Procedure ClipBoardToMemStream( MemStream : TMemoryStream; const Format : Word)');
 //CL.AddDelphiFunction('Function GetPropType( Obj : TObject; const PropName : string) : TTypeKind');
 CL.AddDelphiFunction('Function GetPropStr( Obj : TObject; const PropName : string) : string');
 CL.AddDelphiFunction('Function GetPropOrd( Obj : TObject; const PropName : string) : Integer');
 //CL.AddDelphiFunction('Function GetPropMethod( Obj : TObject; const PropName : string) : TMethod');
 CL.AddDelphiFunction('Procedure PrepareIniSection( Ss : TStrings)');
 //CL.AddDelphiFunction('Function PointL( const X, Y : Longint) : TPointL');
 CL.AddDelphiFunction('Function iif( const Test : Boolean; const ATrue, AFalse : Variant) : Variant');
 CL.AddDelphiFunction('Procedure CopyIconToClipboard( Icon : TIcon; BackColor : TColor)');
 CL.AddDelphiFunction('Function CreateIconFromClipboard : TIcon');
 CL.AddDelphiFunction('Function CF_ICON : Word');
 CL.AddDelphiFunction('Procedure AssignClipboardIcon( Icon : TIcon)');
 CL.AddDelphiFunction('Procedure GetIconSize( Icon : HICON; var W, H : Integer)');
 CL.AddDelphiFunction('Function CreateRealSizeIcon( Icon : TIcon) : HICON');
 CL.AddDelphiFunction('Procedure DrawRealSizeIcon( Canvas : TCanvas; Icon : TIcon; X, Y : Integer)');
 CL.AddDelphiFunction('Function CreateScreenCompatibleDC : HDC');
   CL.AddTypeS('HWND','LongWord');
 CL.AddDelphiFunction('Function InvalidateRect( hWnd : HWND; const lpRect : TRect; bErase : BOOLean) : BOOLean;');
 //CL.AddDelphiFunction('Function InvalidateRect1( hWnd : HWND; lpRect : PRect; bErase : BOOLean) : BOOLean;');
 CL.AddDelphiFunction('Procedure RleCompressTo( InStream, OutStream : TStream)');
 CL.AddDelphiFunction('Procedure RleDecompressTo( InStream, OutStream : TStream)');
 CL.AddDelphiFunction('Procedure RleCompress( Stream : TStream)');
 CL.AddDelphiFunction('Procedure RleDecompress( Stream : TStream)');
 CL.AddDelphiFunction('Function CurrentYear : Word');
 CL.AddDelphiFunction('Function IsLeapYear( AYear : Integer) : Boolean');
 CL.AddDelphiFunction('Function DaysInAMonth( const AYear, AMonth : Word) : Word');
 CL.AddDelphiFunction('Function DaysPerMonth( AYear, AMonth : Integer) : Integer');
 CL.AddDelphiFunction('Function FirstDayOfPrevMonth : TDateTime');
 CL.AddDelphiFunction('Function LastDayOfPrevMonth : TDateTime');
 CL.AddDelphiFunction('Function FirstDayOfNextMonth : TDateTime');
 CL.AddDelphiFunction('Function ExtractDay( ADate : TDateTime) : Word');
 CL.AddDelphiFunction('Function ExtractMonth( ADate : TDateTime) : Word');
 CL.AddDelphiFunction('Function ExtractYear( ADate : TDateTime) : Word');
 CL.AddDelphiFunction('Function IncDate( ADate : TDateTime; Days, Months, Years : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncDay( ADate : TDateTime; Delta : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncMonth( ADate : TDateTime; Delta : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncYear( ADate : TDateTime; Delta : Integer) : TDateTime');
 CL.AddDelphiFunction('Function ValidDate( ADate : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure DateDiff( Date1, Date2 : TDateTime; var Days, Months, Years : Word)');
 CL.AddDelphiFunction('Function MonthsBetween( Date1, Date2 : TDateTime) : Double');
 CL.AddDelphiFunction('Function DaysInPeriod( Date1, Date2 : TDateTime) : Longint');
 CL.AddDelphiFunction('Function DaysBetween( Date1, Date2 : TDateTime) : Longint');
 CL.AddDelphiFunction('Function IncTime( ATime : TDateTime; Hours, Minutes, Seconds, MSecs : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncHour( ATime : TDateTime; Delta : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncMinute( ATime : TDateTime; Delta : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncSecond( ATime : TDateTime; Delta : Integer) : TDateTime');
 CL.AddDelphiFunction('Function IncMSec( ATime : TDateTime; Delta : Integer) : TDateTime');
 CL.AddDelphiFunction('Function CutTime( ADate : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function GetDateOrder( const DateFormat : string) : TDateOrder');
 CL.AddDelphiFunction('Function MonthFromName( const S : string; MaxLen : Byte) : Byte');
 CL.AddDelphiFunction('Function StrToDateDef( const S : string; Default : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function StrToDateFmt( const DateFormat, S : string) : TDateTime');
 CL.AddDelphiFunction('Function StrToDateFmtDef( const DateFormat, S : string; Default : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function DefDateFormat( AFourDigitYear : Boolean) : string');
 CL.AddDelphiFunction('Function DefDateMask( BlanksChar : Char; AFourDigitYear : Boolean) : string');
 CL.AddDelphiFunction('Function FormatLongDate( Value : TDateTime) : string');
 CL.AddDelphiFunction('Function FormatLongDateTime( Value : TDateTime) : string');
 CL.AddDelphiFunction('Function BufToBinStr( Buf : ___Pointer; BufSize : Integer) : string');
 CL.AddDelphiFunction('Function BinStrToBuf( Value : string; Buf : ___Pointer; BufSize : Integer) : Integer');
 {$IFDEF UNIX}
  //CL.AddDelphiFunction('Function iconversion( InP : PAnsiChar; OutP : Pointer; InBytes, OutBytes : Cardinal; const ToCode, FromCode : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function iconvString( const S, ToCode, FromCode : AnsiString) : string');
 CL.AddDelphiFunction('Function iconvWideString( const S : WideString; const ToCode, FromCode : AnsiString) : WideString');
 CL.AddDelphiFunction('Function OemStrToAnsi( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AnsiStrToOem( const S : AnsiString) : AnsiString');
 {$ENDIF UNIX}

 CL.AddDelphiFunction('Function StrToOem( const AnsiStr : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function OemToAnsiStr( const OemStr : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function IsEmptyStr( const S : string; const EmptyChars : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('Function ReplaceStr( const S, Srch, Replace : string) : string');
 CL.AddDelphiFunction('Function DelSpace( const S : string) : string');
 CL.AddDelphiFunction('Function DelChars( const S : string; aChr : Char) : string');
 CL.AddDelphiFunction('Function DelBSpace( const S : string) : string');
 CL.AddDelphiFunction('Function DelESpace( const S : string) : string');
 CL.AddDelphiFunction('Function DelRSpace( const S : string) : string');
 CL.AddDelphiFunction('Function DelSpace1( const S : string) : string');
 CL.AddDelphiFunction('Function Tab2Space( const S : string; Numb : Byte) : string');
 CL.AddDelphiFunction('Function NPos( const C : string; S : string; N : Integer) : Integer');
 CL.AddDelphiFunction('Function MakeStr( C : Char; N : Integer) : string;');
 CL.AddDelphiFunction('Function MakeStr1( C : WideChar; N : Integer) : WideString;');
 CL.AddDelphiFunction('Function MS( C : Char; N : Integer) : string');
 CL.AddDelphiFunction('Function AddChar( C : Char; const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function AddCharR( C : Char; const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function LeftStrJ( const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function RightStrJ( const S : string; N : Integer) : string');
 CL.AddDelphiFunction('Function CenterStr( const S : string; Len : Integer) : string');
 CL.AddDelphiFunction('Function CompStr( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function CompText( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function Copy2Symb( const S : string; Symb : Char) : string');
 CL.AddDelphiFunction('Function Copy2SymbDel( var S : string; Symb : Char) : string');
 CL.AddDelphiFunction('Function Copy2Space( const S : string) : string');
 CL.AddDelphiFunction('Function Copy2SpaceDel( var S : string) : string');
 CL.AddDelphiFunction('Function AnsiProperCase( const S : string; const WordDelims : TSysCharSet) : string');
 CL.AddDelphiFunction('Function WordCount( const S : string; const WordDelims : TSysCharSet) : Integer');
 CL.AddDelphiFunction('Function WordPosition( const N : Integer; const S : string; const WordDelims : TSysCharSet) : Integer');
 CL.AddDelphiFunction('Function ExtractWord( N : Integer; const S : string; const WordDelims : TSysCharSet) : string');
 CL.AddDelphiFunction('Function ExtractWordPos( N : Integer; const S : string; const WordDelims : TSysCharSet; var Pos : Integer) : string');
 CL.AddDelphiFunction('Function ExtractDelimited( N : Integer; const S : string; const Delims : TSysCharSet) : string');
 CL.AddDelphiFunction('Function ExtractSubstr( const S : string; var Pos : Integer; const Delims : TSysCharSet) : string');
 CL.AddDelphiFunction('Function IsWordPresent( const W, S : string; const WordDelims : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('Function QuotedString( const S : string; Quote : Char) : string');
 CL.AddDelphiFunction('Function ExtractQuotedString( const S : string; Quote : Char) : string');
 CL.AddDelphiFunction('Function FindPart( const HelpWilds, InputStr : string) : Integer');
 CL.AddDelphiFunction('Function IsWild( InputStr, Wilds : string; IgnoreCase : Boolean) : Boolean');
 CL.AddDelphiFunction('Function XorString( const Key, Src : ShortString) : ShortString');
 CL.AddDelphiFunction('Function XorEncode( const Key, Source : string) : string');
 CL.AddDelphiFunction('Function XorDecode( const Key, Source : string) : string');
 CL.AddDelphiFunction('Function GetCmdLineArg( const Switch : string; ASwitchChars : TSysCharSet) : string');
 CL.AddDelphiFunction('Function Numb2USA( const S : string) : string');
 CL.AddDelphiFunction('Function Dec2Hex( N : Longint; A : Byte) : string');
 CL.AddDelphiFunction('Function Hex2Dec( const S : string) : Longint');
 CL.AddDelphiFunction('Function Dec2Numb( N : Int64; A, B : Byte) : string');
 CL.AddDelphiFunction('Function Numb2Dec( S : string; B : Byte) : Int64');
 CL.AddDelphiFunction('Function IntToBinJ( Value : Longint; Digits, Spaces : Integer) : string');
 CL.AddDelphiFunction('Function IntToRoman( Value : Longint) : string');
 CL.AddDelphiFunction('Function RomanToInt( const S : string) : Longint');
 CL.AddDelphiFunction('Function FindNotBlankCharPos( const S : string) : Integer');
 CL.AddDelphiFunction('Function FindNotBlankCharPosW( const S : WideString) : Integer');
 CL.AddDelphiFunction('Function AnsiChangeCase( const S : string) : string');
 CL.AddDelphiFunction('Function WideChangeCase( const S : string) : string');
 CL.AddDelphiFunction('Function StartsText( const SubStr, S : string) : Boolean');
 CL.AddDelphiFunction('Function EndsText( const SubStr, S : string) : Boolean');
 CL.AddDelphiFunction('Function DequotedStr( const S : string; QuoteChar : Char) : string');
 CL.AddDelphiFunction('Function AnsiDequotedStr( const S : string; AQuote : Char) : string');
 //CL.AddDelphiFunction('Function GetTempFileNameJ( const Prefix : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function FileDateTime( const FileName : string) : TDateTime');
 CL.AddDelphiFunction('Function HasAttr( const FileName : string; Attr : Integer) : Boolean');
 CL.AddDelphiFunction('Function DeleteFilesEx( const FileMasks : array of string) : Boolean');
 CL.AddDelphiFunction('Function NormalDir( const DirName : string) : string');
 CL.AddDelphiFunction('Function RemoveBackSlash( const DirName : string) : string');
 CL.AddDelphiFunction('Function ValidFileName( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function FileLock( Handle : Integer; Offset, LockSize : Longint) : Integer;');
 CL.AddDelphiFunction('Function FileLock1( Handle : Integer; Offset, LockSize : Int64) : Integer;');
 CL.AddDelphiFunction('Function FileUnlock( Handle : Integer; Offset, LockSize : Longint) : Integer;');
 CL.AddDelphiFunction('Function FileUnlock1( Handle : Integer; Offset, LockSize : Int64) : Integer;');
 CL.AddDelphiFunction('Function GetWindowsDir : string');
 CL.AddDelphiFunction('Function GetSystemDir : string');
 CL.AddDelphiFunction('Function ShortToLongFileName( const ShortName : string) : string');
 CL.AddDelphiFunction('Function LongToShortFileName( const LongName : string) : string');
 CL.AddDelphiFunction('Function ShortToLongPath( const ShortName : string) : string');
 CL.AddDelphiFunction('Function LongToShortPath( const LongName : string) : string');
 CL.AddDelphiFunction('Procedure CreateFileLink( const FileName, DisplayName : string; Folder : Integer)');
 CL.AddDelphiFunction('Procedure DeleteFileLink( const DisplayName : string; Folder : Integer)');
 CL.AddDelphiFunction('Function PtInRectInclusive( R : TRect; Pt : TPoint) : Boolean');
 CL.AddDelphiFunction('Function PtInRectExclusive( R : TRect; Pt : TPoint) : Boolean');
 CL.AddDelphiFunction('Function FourDigitYear : Boolean');
 CL.AddDelphiFunction('Function IsFourDigitYear : Boolean');
 CL.AddDelphiFunction('Function OpenObject( const Value : string) : Boolean;');
 CL.AddDelphiFunction('Function OpenObject1( Value : PChar) : Boolean;');
 CL.AddDelphiFunction('Procedure RaiseLastWin32;');
 CL.AddDelphiFunction('Procedure RaiseLastWin321( const Text : string);');
 CL.AddDelphiFunction('Procedure RaiseLastWin32_2( const Text : string);');

 CL.AddDelphiFunction('Function GetFileVersion( const AFileName : string) : Cardinal');
 CL.AddDelphiFunction('Function GetShellVersion : Cardinal');
 CL.AddDelphiFunction('Procedure OpenCdDrive');
 CL.AddDelphiFunction('Procedure CloseCdDrive');
 CL.AddDelphiFunction('Function DiskInDrive( Drive : Char) : Boolean');
 CL.AddDelphiFunction('Procedure PError( const Text : string)');
 CL.AddDelphiFunction('Procedure Exec( const FileName, Parameters, Directory : string)');
 CL.AddDelphiFunction('Function ExecuteAndWait( CommandLine : string; const WorkingDirectory : string; Visibility : Integer) : Integer');
 CL.AddDelphiFunction('Function FirstInstance( const ATitle : string) : Boolean');
 CL.AddDelphiFunction('Procedure RestoreOtherInstance( const MainFormClassName, MainFormCaption : string)');
 CL.AddDelphiFunction('Procedure HideTraybar');
 CL.AddDelphiFunction('Procedure ShowTraybar');
 CL.AddDelphiFunction('Procedure ShowStartButton( Visible : Boolean)');
 CL.AddDelphiFunction('Procedure MonitorOn');
 CL.AddDelphiFunction('Procedure MonitorOff');
 CL.AddDelphiFunction('Procedure LowPower');
 CL.AddDelphiFunction('Function SendKey( const AppName : string; Key : Char) : Boolean');
 CL.AddDelphiFunction('Procedure GetVisibleWindows( List : TStrings)');
 CL.AddDelphiFunction('Function GetVisibleWindowsF( List : TStrings):TStrings');
 CL.AddDelphiFunction('Procedure AssociateExtension( const IconPath, ProgramName, Path, Extension : string)');
 CL.AddDelphiFunction('Procedure AddToRecentDocs( const FileName : string)');
 CL.AddDelphiFunction('Function GetRecentDocs : TStringList');
 CL.AddDelphiFunction('Function CharIsMoney( const Ch : Char) : Boolean');
 CL.AddDelphiFunction('Function JvSafeStrToFloatDef( const Str : string; Def : Extended; aDecimalSeparator : Char) : Extended');
 CL.AddDelphiFunction('Function JvSafeStrToFloat( const Str : string; aDecimalSeparator : Char) : Extended');
 CL.AddDelphiFunction('Function StrToCurrDef( const Str : string; Def : Currency) : Currency');
 CL.AddDelphiFunction('Function IntToExtended( I : Integer) : Extended');
 CL.AddDelphiFunction('Function GetChangedText( const Text : string; SelStart, SelLength : Integer; Key : Char) : string');
 CL.AddDelphiFunction('Function MakeYear4Digit( Year, Pivot : Integer) : Integer');
 CL.AddDelphiFunction('Function StrIsInteger( const S : string) : Boolean');
 CL.AddDelphiFunction('Function StrIsFloatMoney( const Ps : string) : Boolean');
 CL.AddDelphiFunction('Function StrIsDateTime( const Ps : string) : Boolean');
 CL.AddDelphiFunction('Function PreformatDateString( Ps : string) : string');
 CL.AddDelphiFunction('Function BooleanToInteger( const B : Boolean) : Integer');
 CL.AddDelphiFunction('Function StringToBoolean( const Ps : string) : Boolean');
 CL.AddDelphiFunction('Function StrToBo( const Ps : string) : Boolean');
 CL.AddDelphiFunction('Function BoToStr(const B: boolean) : String');
 CL.AddDelphiFunction('Function BoolToStrJ(const B: boolean) : String');
 CL.AddDelphiFunction('Function SafeStrToDateTime( const Ps : string) : TDateTime');
 CL.AddDelphiFunction('Function SafeStrToDate( const Ps : string) : TDateTime');
 CL.AddDelphiFunction('Function SafeStrToTime( const Ps : string) : TDateTime');
 CL.AddDelphiFunction('Function StrDelete( const psSub, psMain : string) : string');
 CL.AddDelphiFunction('Function TimeOnly( pcValue : TDateTime) : TTime');
 CL.AddDelphiFunction('Function DateOnly( pcValue : TDateTime) : TDate');
  CL.AddTypeS('TdtKind', '( dtkDateOnly, dtkTimeOnly, dtkDateTime )');
 //CL.AddConstantN('NullEquivalentDate','TDateTime').SetString(' 0.0');
 CL.AddDelphiFunction('Function DateIsNull( const pdtValue : TDateTime; const pdtKind : TdtKind) : Boolean');
 CL.AddDelphiFunction('Function OSCheck( RetVal : Boolean) : Boolean');
 CL.AddDelphiFunction('Function MinimizeFileName( const FileName : string; Canvas : TCanvas; MaxLen : Integer) : string');
 CL.AddDelphiFunction('Function MinimizeText( const Text : string; Canvas : TCanvas; MaxWidth : Integer) : string');
 CL.AddDelphiFunction('Function MinimizeString( const S : string; const MaxLen : Integer) : string');
 CL.AddDelphiFunction('Function RunDLL32( const ModuleName, FuncName, CmdLine : string; WaitForCompletion : Boolean; CmdShow : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure RunDll32Internal( Wnd : THandle; const DLLName, FuncName, CmdLine : string; CmdShow : Integer)');
 CL.AddDelphiFunction('Function GetDLLVersion( const DLLName : string; var pdwMajor, pdwMinor : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure ResourceNotFound( ResID : PChar)');
 CL.AddDelphiFunction('Function EmptyRect : TRect');
 CL.AddDelphiFunction('Function RectWidth( R : TRect) : Integer');
 CL.AddDelphiFunction('Function RectHeight( R : TRect) : Integer');
 CL.AddDelphiFunction('Function CompareRect( const R1, R2 : TRect) : Boolean');
 CL.AddDelphiFunction('Procedure RectNormalize( var R : TRect)');
 CL.AddDelphiFunction('Function RectIsSquare( const R : TRect) : Boolean');
 CL.AddDelphiFunction('Function RectSquare( var ARect : TRect; AMaxSize : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure FreeUnusedOle');
 CL.AddDelphiFunction('Function GetWindowsVersion : string');
 CL.AddDelphiFunction('Function LoadDLL( const LibName : string) : THandle');
 CL.AddDelphiFunction('Function RegisterServer( const ModuleName : string) : Boolean');
 CL.AddDelphiFunction('Function UnregisterServer( const ModuleName : string) : Boolean');
 CL.AddDelphiFunction('Function GetEnvVar( const VarName : string) : string');
 CL.AddDelphiFunction('Function GetEnvironmentVariable( const VarName : string) : string');
 CL.AddDelphiFunction('Function AnsiUpperFirstChar( const S : string) : string');
 CL.AddDelphiFunction('Function StringToPChar( var S : string) : PChar');
 CL.AddDelphiFunction('Function StrPAlloc( const S : string) : PChar');
 CL.AddDelphiFunction('Procedure SplitCommandLine( const CmdLine : string; var ExeName, Params : string)');
 CL.AddDelphiFunction('Function DropT( const S : string) : string');
 CL.AddDelphiFunction('Function AllocMemo( Size : Longint) : ___Pointer');
 CL.AddDelphiFunction('Function ReallocMemo( fpBlock : ___Pointer; Size : Longint) : ___Pointer');
 CL.AddDelphiFunction('Procedure FreeMemo( var fpBlock : ___Pointer)');
 CL.AddDelphiFunction('Function GetMemoSize( fpBlock : ___Pointer) : Longint');
 CL.AddDelphiFunction('Function CompareMem( fpBlock1, fpBlock2 : ___Pointer; Size : Cardinal) : Boolean');
 CL.AddDelphiFunction('Procedure HugeInc( var HugePtr : ___Pointer; Amount : Longint)');
 CL.AddDelphiFunction('Procedure HugeDec( var HugePtr : ___Pointer; Amount : Longint)');
 CL.AddDelphiFunction('Function HugeOffset( HugePtr : ___Pointer; Amount : Longint) : ___Pointer');
 CL.AddDelphiFunction('Procedure HugeMove( Base : ___Pointer; Dst, Src, Size : Longint)');
 CL.AddDelphiFunction('Procedure HMemCpy( DstPtr, SrcPtr : ___Pointer; Amount : Longint)');
 CL.AddDelphiFunction('Function WindowClassName( Wnd : THandle) : string');
 CL.AddDelphiFunction('Procedure SwitchToWindow( Wnd : THandle; Restore : Boolean)');
 CL.AddDelphiFunction('Procedure ActivateWindow( Wnd : THandle)');
 CL.AddDelphiFunction('Procedure ShowWinNoAnimate( Handle : THandle; CmdShow : Integer)');
 CL.AddDelphiFunction('Procedure KillMessage( Wnd : THandle; Msg : Cardinal)');
 CL.AddDelphiFunction('Procedure SetWindowTop( const Handle : THandle; const Top : Boolean)');
 CL.AddDelphiFunction('Procedure CenterWindow( Wnd : THandle)');
 CL.AddDelphiFunction('Function MakeVariant( const Values : array of Variant) : Variant');
 CL.AddDelphiFunction('Function DialogUnitsToPixelsX( DlgUnits : Word) : Word');
 CL.AddDelphiFunction('Function DialogUnitsToPixelsY( DlgUnits : Word) : Word');
 CL.AddDelphiFunction('Function PixelsToDialogUnitsX( PixUnits : Word) : Word');
 CL.AddDelphiFunction('Function PixelsToDialogUnitsY( PixUnits : Word) : Word');
 CL.AddDelphiFunction('Function GetUniqueFileNameInDir( const Path, FileNameMask : string) : string');
 CL.AddDelphiFunction('Function FindPrevInstance( const MainFormClass : ShortString; const ATitle : string) : THandle');
 CL.AddDelphiFunction('Function ActivatePrevInstance( const MainFormClass : ShortString; const ATitle : string) : Boolean');
 CL.AddDelphiFunction('Function FindPrevInstance( const MainFormClass, ATitle : string) : THandle');
 CL.AddDelphiFunction('Function ActivatePrevInstance( const MainFormClass, ATitle : string) : Boolean');
 CL.AddDelphiFunction('Function BrowseForFolderNative( const Handle : THandle; const Title : string; var Folder : string) : Boolean');
 CL.AddDelphiFunction('Procedure AntiAlias( Clip : TBitmap)');
 CL.AddDelphiFunction('Procedure AntiAliasRect( Clip : TBitmap; XOrigin, YOrigin, XFinal, YFinal : Integer)');
 CL.AddDelphiFunction('Procedure CopyRectDIBits( ACanvas : TCanvas; const DestRect : TRect; ABitmap : TBitmap; const SourceRect : TRect)');
 CL.AddDelphiFunction('Function IsTrueType( const FontName : string) : Boolean');
 CL.AddDelphiFunction('Function TextToValText( const AValue : string) : string');
 CL.AddDelphiFunction('Function BitBltJ( DestCanvas : TCanvas; X, Y, Width, Height : Integer; SrcCanvas : TCanvas; XSrc, YSrc : Integer; WinRop : Cardinal; IgnoreMask : Boolean) : LongBool;');
 CL.AddTypeS('HDC','LongWord');
 // CL.AddDelphiFunction('Function BitBlt1( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; Rop : RasterOp; IgnoreMask : Boolean) : LongBool;');
 CL.AddDelphiFunction('Function BitBlt2( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; WinRop : Cardinal; IgnoreMask : Boolean) : LongBool;');
 CL.AddDelphiFunction('Function BitBlt3( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; WinRop : Cardinal) : LongBool;');
 CL.AddDelphiFunction('Function IsEqualGUID( const IID1, IID2 : TGUID) : Boolean');
  CL.AddTypeS('TIntegerListChange', 'Procedure ( Sender : TObject; Item : Integer; Action : TListNotification)');
 CL.AddDelphiFunction('function binToStr(ans: string): string');

 CL.AddDelphiFunction('procedure MoveCardinal2String(const Source: cardinal; SrcStartIdx: Integer; var Dest: string;'
                                     +'DstStartIdx: Integer; Count: Integer);');
 CL.AddDelphiFunction('procedure MoveString2Cardinal(const Source: string; SrcStartIdx: Integer; var Dest: Cardinal;'
                                     +'DstStartIdx: Integer; Count: Integer);');
 CL.AddDelphiFunction('procedure MoveCardinal(const Source: cardinal; var Dest: Cardinal; Count: Integer);');

 {procedure MoveCardinal2String(const Source: cardinal; SrcStartIdx: Integer; var Dest: string;
  DstStartIdx: Integer; Count: Integer);
procedure MoveString2Cardinal(const Source: string; SrcStartIdx: Integer; var Dest: Cardinal;
  DstStartIdx: Integer; Count: Integer);
procedure MoveCardinal(const Source: cardinal; var Dest: Cardinal; Count: Integer); }


  SIRegister_TIntegerList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIntegerListOnChange_W(Self: TIntegerList; const T: TIntegerListChange);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerListOnChange_R(Self: TIntegerList; var T: TIntegerListChange);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerListItems_W(Self: TIntegerList; const T: Integer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerListItems_R(Self: TIntegerList; var T: Integer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerListLoading_R(Self: TIntegerList; var T: Boolean);
begin T := Self.Loading; end;

procedure TIntegerListCount_R(Self: TIntegerList; var T: integer);
begin T:= Self.Count; end;

(*----------------------------------------------------------------------------*)
Function BitBlt3_P( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; WinRop : Cardinal) : LongBool;
Begin Result := JvJCLUtils.BitBlt(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc, WinRop); END;

(*----------------------------------------------------------------------------*)
Function BitBlt2_P( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; WinRop : Cardinal; IgnoreMask : Boolean) : LongBool;
Begin Result := JvJCLUtils.BitBlt(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc, WinRop, IgnoreMask); END;

(*----------------------------------------------------------------------------*)
Function BitBlt1_P( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; Rop : RasterOp; IgnoreMask : Boolean) : LongBool;
Begin Result := JvJCLUtils.BitBlt(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc, Rop, IgnoreMask); END;

(*----------------------------------------------------------------------------*)
Function BitBlt_P( DestCanvas : TCanvas; X, Y, Width, Height : Integer; SrcCanvas : TCanvas; XSrc, YSrc : Integer; WinRop : Cardinal; IgnoreMask : Boolean) : LongBool;
Begin Result := JvJCLUtils.BitBlt(DestCanvas, X, Y, Width, Height, SrcCanvas, XSrc, YSrc, WinRop, IgnoreMask); END;

(*----------------------------------------------------------------------------*)
Procedure RaiseLastWin321_P( const Text : string);
Begin JvJCLUtils.RaiseLastWin32(Text); END;

(*----------------------------------------------------------------------------*)
Procedure RaiseLastWin32_P;
Begin JvJCLUtils.RaiseLastWin32; END;

(*----------------------------------------------------------------------------*)
Function OpenObject1_P( Value : PChar) : Boolean;
Begin Result := JvJCLUtils.OpenObject(Value); END;

(*----------------------------------------------------------------------------*)
Function OpenObject_P( const Value : string) : Boolean;
Begin Result := JvJCLUtils.OpenObject(Value); END;

(*----------------------------------------------------------------------------*)
Function FileUnlock1_P( Handle : Integer; Offset, LockSize : Int64) : Integer;
Begin Result := JvJCLUtils.FileUnlock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
Function FileUnlock_P( Handle : Integer; Offset, LockSize : Longint) : Integer;
Begin Result := JvJCLUtils.FileUnlock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
Function FileLock1_P( Handle : Integer; Offset, LockSize : Int64) : Integer;
Begin Result := JvJCLUtils.FileLock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
Function FileLock_P( Handle : Integer; Offset, LockSize : Longint) : Integer;
Begin Result := JvJCLUtils.FileLock(Handle, Offset, LockSize); END;

(*----------------------------------------------------------------------------*)
Function MakeStr1_P( C : WideChar; N : Integer) : WideString;
Begin Result := JvJCLUtils.MakeStr(C, N); END;

(*----------------------------------------------------------------------------*)
Function MakeStr_P( C : Char; N : Integer) : string;
Begin Result := JvJCLUtils.MakeStr(C, N); END;

(*----------------------------------------------------------------------------*)
Function InvalidateRect1_P( hWnd : HWND; lpRect : PRect; bErase : BOOL) : BOOL;
Begin Result := JvJCLUtils.InvalidateRect(hWnd, lpRect, bErase); END;

(*----------------------------------------------------------------------------*)
Function InvalidateRect_P( hWnd : HWND; const lpRect : TRect; bErase : BOOL) : BOOL;
Begin Result := JvJCLUtils.InvalidateRect(hWnd, lpRect, bErase); END;

(*----------------------------------------------------------------------------*)
Procedure MoveString1_P( const Source : string; SrcStartIdx : Integer; var Dest : string; DstStartIdx : Integer; Count : Integer);
Begin JvJCLUtils.MoveString(Source, SrcStartIdx, Dest, DstStartIdx, Count); END;

(*----------------------------------------------------------------------------*)
Procedure MoveString_P( const Source : string; var Dest : string; Count : Integer);
Begin JvJCLUtils.MoveString(Source, Dest, Count); END;

(*----------------------------------------------------------------------------*)
Procedure FillString1_P( var Buffer : string; StartIndex, Count : Integer; const Value : Char);
Begin JvJCLUtils.FillString(Buffer, StartIndex, Count, Value); END;

(*----------------------------------------------------------------------------*)
Procedure FillString_P( var Buffer : string; Count : Integer; const Value : Char);
Begin JvJCLUtils.FillString(Buffer, Count, Value); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIntegerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntegerList) do begin
    RegisterConstructor(@TIntegerList.Create, 'CREATE');
    RegisterMethod(@TIntegerList.Sort, 'Sort');
    RegisterMethod(@TIntegerList.ReadData, 'ReadData');
    RegisterMethod(@TIntegerList.WriteData, 'WriteData');
    RegisterPropertyHelper(@TIntegerListLoading_R,nil,'Loading');
    RegisterMethod(@TIntegerList.Add, 'Add');
    RegisterMethod(@TIntegerList.Extract, 'Extract');
    RegisterMethod(@TIntegerList.First, 'First');
    RegisterMethod(@TIntegerList.IndexOf, 'IndexOf');
    RegisterMethod(@TIntegerList.Insert, 'Insert');
    RegisterMethod(@TIntegerList.Last, 'Last');
    RegisterMethod(@TIntegerList.Remove, 'Remove');
    RegisterPropertyHelper(@TIntegerListCount_R,NIL,'Count');
     RegisterPropertyHelper(@TIntegerListItems_R,@TIntegerListItems_W,'Items');
    RegisterPropertyHelper(@TIntegerListOnChange_R,@TIntegerListOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvJCLUtils_Routines(S: TPSExec);
begin

 S.RegisterDelphiFunction(@BoolToStrJ, 'BoolToStrJ', cdRegister);
 S.RegisterDelphiFunction(@SendRectMessage, 'SendRectMessage', cdRegister);
 S.RegisterDelphiFunction(@SendStructMessage, 'SendStructMessage', cdRegister);
 S.RegisterDelphiFunction(@ReadCharsFromStream, 'ReadCharsFromStream', cdRegister);
 S.RegisterDelphiFunction(@WriteStringToStream, 'WriteStringToStream', cdRegister);
 S.RegisterDelphiFunction(@UTF8ToString, 'UTF8ToString', cdRegister);
 S.RegisterDelphiFunction(@VarIsInt, 'VarIsInt', cdRegister);
 S.RegisterDelphiFunction(@PosIdx, 'PosIdx', cdRegister);
 S.RegisterDelphiFunction(@PosIdxW, 'PosIdxW', cdRegister);
 S.RegisterDelphiFunction(@PosLastCharIdx, 'PosLastCharIdx', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPos, 'GetWordOnPos', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPosW, 'GetWordOnPosW', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPos2, 'GetWordOnPos2', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPos2W, 'GetWordOnPos2W', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPosEx, 'GetWordOnPosEx', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPosExW, 'GetWordOnPosExW', cdRegister);
 S.RegisterDelphiFunction(@GetNextWordPosEx, 'GetNextWordPosEx', cdRegister);
 S.RegisterDelphiFunction(@GetNextWordPosExW, 'GetNextWordPosExW', cdRegister);
 S.RegisterDelphiFunction(@GetEndPosCaret, 'GetEndPosCaret', cdRegister);
 S.RegisterDelphiFunction(@GetEndPosCaretW, 'GetEndPosCaretW', cdRegister);
 S.RegisterDelphiFunction(@SubStrBySeparator, 'SubStrBySeparator', cdRegister);
 S.RegisterDelphiFunction(@SubStrBySeparatorW, 'SubStrBySeparatorW', cdRegister);
 S.RegisterDelphiFunction(@SubWord, 'SubWord', cdRegister);
 S.RegisterDelphiFunction(@GetLineByPos, 'GetLineByPos', cdRegister);
 S.RegisterDelphiFunction(@GetXYByPos, 'GetXYByPos', cdRegister);
 S.RegisterDelphiFunction(@GetXYByPosW, 'GetXYByPosW', cdRegister);
 S.RegisterDelphiFunction(@ReplaceString, 'ReplaceStringJ', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStringW, 'ReplaceStringW', cdRegister);
 S.RegisterDelphiFunction(@ConcatSep, 'ConcatSep', cdRegister);
 S.RegisterDelphiFunction(@ConcatLeftSep, 'ConcatLeftSep', cdRegister);
 S.RegisterDelphiFunction(@Dos2Win, 'Dos2Win', cdRegister);
 S.RegisterDelphiFunction(@Win2Dos, 'Win2Dos', cdRegister);
 S.RegisterDelphiFunction(@Dos2WinRes, 'Dos2WinRes', cdRegister);
 S.RegisterDelphiFunction(@Win2DosRes, 'Win2DosRes', cdRegister);
 S.RegisterDelphiFunction(@Win2Koi, 'Win2Koi', cdRegister);
 S.RegisterDelphiFunction(@FillString_P, 'FillString', cdRegister);
 S.RegisterDelphiFunction(@FillString1_P, 'FillString1', cdRegister);
 S.RegisterDelphiFunction(@MoveString_P, 'MoveStringJV', cdRegister);
 S.RegisterDelphiFunction(@MoveString1_P, 'MoveString1', cdRegister);
 S.RegisterDelphiFunction(@FillWideChar, 'FillWideChar', cdRegister);
 S.RegisterDelphiFunction(@FillNativeChar, 'FillNativeChar', cdRegister);
 S.RegisterDelphiFunction(@IsSubString, 'IsSubString', cdRegister);
 S.RegisterDelphiFunction(@Spaces, 'Spaces', cdRegister);
 S.RegisterDelphiFunction(@AddSpaces, 'AddSpaces', cdRegister);
 S.RegisterDelphiFunction(@SpacesW, 'SpacesW', cdRegister);
 S.RegisterDelphiFunction(@AddSpacesW, 'AddSpacesW', cdRegister);
 S.RegisterDelphiFunction(@LastDateRUS, 'LastDateRUS', cdRegister);
 S.RegisterDelphiFunction(@CurrencyToStr, 'CurrencyToStr', cdRegister);
 S.RegisterDelphiFunction(@HasChar, 'HasChar', cdRegister);
 S.RegisterDelphiFunction(@HasCharW, 'HasCharW', cdRegister);
 S.RegisterDelphiFunction(@HasAnyChar, 'HasAnyChar', cdRegister);
 S.RegisterDelphiFunction(@CharInSet, 'CharInSet', cdRegister);
 S.RegisterDelphiFunction(@CharInSetW, 'CharInSetW', cdRegister);
 S.RegisterDelphiFunction(@CountOfChar, 'CountOfChar', cdRegister);
 S.RegisterDelphiFunction(@DefStr, 'DefStr', cdRegister);
 S.RegisterDelphiFunction(@StrLICompW2, 'StrLICompW2', cdRegister);
 S.RegisterDelphiFunction(@StrPosW, 'StrPosW', cdRegister);
 S.RegisterDelphiFunction(@StrLenW, 'StrLenW', cdRegister);
 S.RegisterDelphiFunction(@TrimW, 'TrimW', cdRegister);
 S.RegisterDelphiFunction(@TrimLeftW, 'TrimLeftW', cdRegister);
 S.RegisterDelphiFunction(@TrimRightW, 'TrimRightW', cdRegister);
 S.RegisterDelphiFunction(@SetDelimitedText, 'SetDelimitedText', cdRegister);
 S.RegisterDelphiFunction(@GenTempFileName, 'GenTempFileName', cdRegister);
 S.RegisterDelphiFunction(@GenTempFileNameExt, 'GenTempFileNameExt', cdRegister);
 S.RegisterDelphiFunction(@ClearDir, 'ClearDir', cdRegister);
 S.RegisterDelphiFunction(@DeleteDir, 'DeleteDir', cdRegister);
 S.RegisterDelphiFunction(@FileEquMask, 'FileEquMask', cdRegister);
 S.RegisterDelphiFunction(@FileEquMasks, 'FileEquMasks', cdRegister);
 S.RegisterDelphiFunction(@DeleteFiles, 'DeleteFiles', cdRegister);
 S.RegisterDelphiFunction(@LZFileExpand, 'LZFileExpand', cdRegister);
 S.RegisterDelphiFunction(@FileGetInfo, 'FileGetInfo', cdRegister);
 S.RegisterDelphiFunction(@HasSubFolder, 'HasSubFolder', cdRegister);
 S.RegisterDelphiFunction(@IsEmptyFolder, 'IsEmptyFolder', cdRegister);
 S.RegisterDelphiFunction(@AddSlash, 'AddSlash', cdRegister);
 S.RegisterDelphiFunction(@AddPath, 'AddPath', cdRegister);
 S.RegisterDelphiFunction(@AddPaths, 'AddPaths', cdRegister);
 S.RegisterDelphiFunction(@ParentPath, 'ParentPath', cdRegister);
 S.RegisterDelphiFunction(@FindInPath, 'FindInPath', cdRegister);
 S.RegisterDelphiFunction(@DeleteReadOnlyFile, 'DeleteReadOnlyFile', cdRegister);
 S.RegisterDelphiFunction(@HasParam, 'HasParam', cdRegister);
 S.RegisterDelphiFunction(@HasSwitch, 'HasSwitch', cdRegister);
 S.RegisterDelphiFunction(@Switch, 'Switch', cdRegister);
 S.RegisterDelphiFunction(@ExePath, 'ExePathJ', cdRegister);
 S.RegisterDelphiFunction(@CopyDir, 'CopyDir', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToDosDateTimeDWord, 'FileTimeToDosDateTimeDWord', cdRegister);
 S.RegisterDelphiFunction(@MakeValidFileName, 'MakeValidFileName', cdRegister);
 S.RegisterDelphiFunction(@IsTTFontSelected, 'IsTTFontSelected', cdRegister);
 S.RegisterDelphiFunction(@KeyPressed, 'KeyPressed', cdRegister);
 S.RegisterDelphiFunction(@TrueInflateRect, 'TrueInflateRect', cdRegister);
 S.RegisterDelphiFunction(@RGBToHSV, 'RGBToHSV', cdRegister);
 S.RegisterDelphiFunction(@RGBToBGR, 'RGBToBGR', cdRegister);
 //S.RegisterDelphiFunction(@ColorToPrettyName, 'ColorToPrettyName', cdRegister);
 //S.RegisterDelphiFunction(@PrettyNameToColor, 'PrettyNameToColor', cdRegister);
 S.RegisterDelphiFunction(@SwapInt, 'SwapIntJ', cdRegister);
 //S.RegisterDelphiFunction(@SwapInt, 'SwapInt2', cdRegister);
 S.RegisterDelphiFunction(@IntPower, 'IntPowerJ', cdRegister);
 S.RegisterDelphiFunction(@ChangeTopException, 'ChangeTopException', cdRegister);
 S.RegisterDelphiFunction(@StrToBool, 'StrToBoolJ', cdRegister);
 S.RegisterDelphiFunction(@StrToBool, 'StrToBo', cdRegister);
 S.RegisterDelphiFunction(@BoolToStrJ, 'BoToStr', cdRegister);

 S.RegisterDelphiFunction(@Var2Type, 'Var2Type', cdRegister);
 S.RegisterDelphiFunction(@VarToInt, 'VarToInt', cdRegister);
 S.RegisterDelphiFunction(@VarToFloat, 'VarToFloat', cdRegister);
 S.RegisterDelphiFunction(@GetLongFileName, 'GetLongFileName', cdRegister);
 S.RegisterDelphiFunction(@FileNewExt, 'FileNewExt', cdRegister);
 S.RegisterDelphiFunction(@GetParameter, 'GetParameter', cdRegister);
 S.RegisterDelphiFunction(@GetComputerID, 'GetComputerID', cdRegister);
 S.RegisterDelphiFunction(@GetComputerName, 'GetComputerName', cdRegister);
 S.RegisterDelphiFunction(@ReplaceAllStrings, 'ReplaceAllStrings', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStrings, 'ReplaceStrings', cdRegister);
 S.RegisterDelphiFunction(@CountOfLines, 'CountOfLines', cdRegister);
 S.RegisterDelphiFunction(@DeleteOfLines, 'DeleteOfLines', cdRegister);
 S.RegisterDelphiFunction(@DeleteEmptyLines, 'DeleteEmptyLines', cdRegister);
 S.RegisterDelphiFunction(@SQLAddWhere, 'SQLAddWhere', cdRegister);
 S.RegisterDelphiFunction(@ResSaveToFile, 'ResSaveToFile', cdRegister);
 S.RegisterDelphiFunction(@ResSaveToFileEx, 'ResSaveToFileEx', cdRegister);
 S.RegisterDelphiFunction(@ResSaveToString, 'ResSaveToString', cdRegister);
 S.RegisterDelphiFunction(@IniReadSection, 'IniReadSection', cdRegister);
 S.RegisterDelphiFunction(@LoadTextFile, 'LoadTextFile', cdRegister);
 S.RegisterDelphiFunction(@SaveTextFile, 'SaveTextFile', cdRegister);
 S.RegisterDelphiFunction(@ReadFolder, 'ReadFolder', cdRegister);
 S.RegisterDelphiFunction(@ReadFolders, 'ReadFolders', cdRegister);
 S.RegisterDelphiFunction(@RATextOut, 'RATextOut', cdRegister);
 S.RegisterDelphiFunction(@RATextOutEx, 'RATextOutEx', cdRegister);
 S.RegisterDelphiFunction(@RATextCalcHeight, 'RATextCalcHeight', cdRegister);
 S.RegisterDelphiFunction(@Cinema, 'Cinema', cdRegister);
 S.RegisterDelphiFunction(@Roughed, 'Roughed', cdRegister);
 S.RegisterDelphiFunction(@BitmapFromBitmap, 'BitmapFromBitmap', cdRegister);
 S.RegisterDelphiFunction(@TextWidth, 'TextWidth', cdRegister);
 S.RegisterDelphiFunction(@TextHeight, 'TextHeight', cdRegister);
 S.RegisterDelphiFunction(@SetChildPropOrd, 'SetChildPropOrd', cdRegister);
 S.RegisterDelphiFunction(@Error, 'Error', cdRegister);
 S.RegisterDelphiFunction(@ItemHtDrawEx, 'ItemHtDrawEx', cdRegister);
 S.RegisterDelphiFunction(@ItemHtDraw, 'ItemHtDraw', cdRegister);
 S.RegisterDelphiFunction(@ItemHtWidth, 'ItemHtWidth', cdRegister);
 S.RegisterDelphiFunction(@ItemHtPlain, 'ItemHtPlain', cdRegister);
 S.RegisterDelphiFunction(@ClearList, 'ClearList', cdRegister);
 S.RegisterDelphiFunction(@MemStreamToClipBoard, 'MemStreamToClipBoard', cdRegister);
 S.RegisterDelphiFunction(@ClipBoardToMemStream, 'ClipBoardToMemStream', cdRegister);
 S.RegisterDelphiFunction(@GetPropType, 'GetPropType', cdRegister);
 S.RegisterDelphiFunction(@GetPropStr, 'GetPropStr', cdRegister);
 S.RegisterDelphiFunction(@GetPropOrd, 'GetPropOrd', cdRegister);
 S.RegisterDelphiFunction(@GetPropMethod, 'GetPropMethod', cdRegister);
 S.RegisterDelphiFunction(@PrepareIniSection, 'PrepareIniSection', cdRegister);
 S.RegisterDelphiFunction(@PointL, 'PointL', cdRegister);
 S.RegisterDelphiFunction(@iif, 'iif', cdRegister);
 S.RegisterDelphiFunction(@CopyIconToClipboard, 'CopyIconToClipboard', cdRegister);
 S.RegisterDelphiFunction(@CreateIconFromClipboard, 'CreateIconFromClipboard', cdRegister);
 S.RegisterDelphiFunction(@CF_ICON, 'CF_ICON', cdRegister);
 S.RegisterDelphiFunction(@AssignClipboardIcon, 'AssignClipboardIcon', cdRegister);
 S.RegisterDelphiFunction(@GetIconSize, 'GetIconSize', cdRegister);
 S.RegisterDelphiFunction(@CreateRealSizeIcon, 'CreateRealSizeIcon', cdRegister);
 S.RegisterDelphiFunction(@DrawRealSizeIcon, 'DrawRealSizeIcon', cdRegister);
 S.RegisterDelphiFunction(@CreateScreenCompatibleDC, 'CreateScreenCompatibleDC', cdRegister);
 S.RegisterDelphiFunction(@InvalidateRect_P, 'InvalidateRect', cdRegister);
 S.RegisterDelphiFunction(@InvalidateRect1_P, 'InvalidateRect1', cdRegister);
 S.RegisterDelphiFunction(@RleCompressTo, 'RleCompressTo', cdRegister);
 S.RegisterDelphiFunction(@RleDecompressTo, 'RleDecompressTo', cdRegister);
 S.RegisterDelphiFunction(@RleCompress, 'RleCompress', cdRegister);
 S.RegisterDelphiFunction(@RleDecompress, 'RleDecompress', cdRegister);
 S.RegisterDelphiFunction(@CurrentYear, 'CurrentYear', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear', cdRegister);
 S.RegisterDelphiFunction(@DaysInAMonth, 'DaysInAMonth', cdRegister);
 S.RegisterDelphiFunction(@DaysPerMonth, 'DaysPerMonth', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfPrevMonth, 'FirstDayOfPrevMonth', cdRegister);
 S.RegisterDelphiFunction(@LastDayOfPrevMonth, 'LastDayOfPrevMonth', cdRegister);
 S.RegisterDelphiFunction(@FirstDayOfNextMonth, 'FirstDayOfNextMonth', cdRegister);
 S.RegisterDelphiFunction(@ExtractDay, 'ExtractDay', cdRegister);
 S.RegisterDelphiFunction(@ExtractMonth, 'ExtractMonth', cdRegister);
 S.RegisterDelphiFunction(@ExtractYear, 'ExtractYear', cdRegister);
 S.RegisterDelphiFunction(@IncDate, 'IncDate', cdRegister);
 S.RegisterDelphiFunction(@IncDay, 'IncDay', cdRegister);
 S.RegisterDelphiFunction(@IncMonth, 'IncMonth', cdRegister);
 S.RegisterDelphiFunction(@IncYear, 'IncYear', cdRegister);
 S.RegisterDelphiFunction(@ValidDate, 'ValidDate', cdRegister);
 S.RegisterDelphiFunction(@DateDiff, 'DateDiff', cdRegister);
 S.RegisterDelphiFunction(@MonthsBetween, 'MonthsBetween', cdRegister);
 S.RegisterDelphiFunction(@DaysInPeriod, 'DaysInPeriod', cdRegister);
 S.RegisterDelphiFunction(@DaysBetween, 'DaysBetween', cdRegister);
 S.RegisterDelphiFunction(@IncTime, 'IncTime', cdRegister);
 S.RegisterDelphiFunction(@IncHour, 'IncHour', cdRegister);
 S.RegisterDelphiFunction(@IncMinute, 'IncMinute', cdRegister);
 S.RegisterDelphiFunction(@IncSecond, 'IncSecond', cdRegister);
 S.RegisterDelphiFunction(@IncMSec, 'IncMSec', cdRegister);
 S.RegisterDelphiFunction(@CutTime, 'CutTime', cdRegister);
 S.RegisterDelphiFunction(@GetDateOrder, 'GetDateOrder', cdRegister);
 S.RegisterDelphiFunction(@MonthFromName, 'MonthFromName', cdRegister);
 S.RegisterDelphiFunction(@StrToDateDef, 'StrToDateDef', cdRegister);
 S.RegisterDelphiFunction(@StrToDateFmt, 'StrToDateFmt', cdRegister);
 S.RegisterDelphiFunction(@StrToDateFmtDef, 'StrToDateFmtDef', cdRegister);
 //S.RegisterDelphiFunction(@DefDateFormat, 'DefDateFormat', cdRegister);
 //S.RegisterDelphiFunction(@DefDateMask, 'DefDateMask', cdRegister);
 S.RegisterDelphiFunction(@FormatLongDate, 'FormatLongDate', cdRegister);
 S.RegisterDelphiFunction(@FormatLongDateTime, 'FormatLongDateTime', cdRegister);
 S.RegisterDelphiFunction(@BufToBinStr, 'BufToBinStr', cdRegister);
 S.RegisterDelphiFunction(@BinStrToBuf, 'BinStrToBuf', cdRegister);
 {$IFDEF UNIX}
 S.RegisterDelphiFunction(@iconversion, 'iconversion', cdRegister);
 S.RegisterDelphiFunction(@iconvString, 'iconvString', cdRegister);
 S.RegisterDelphiFunction(@iconvWideString, 'iconvWideString', cdRegister);
 S.RegisterDelphiFunction(@OemStrToAnsi, 'OemStrToAnsi', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrToOem, 'AnsiStrToOem', cdRegister);
 {$ENDIF UNIX}

 S.RegisterDelphiFunction(@StrToOem, 'StrToOem', cdRegister);
 S.RegisterDelphiFunction(@OemToAnsiStr, 'OemToAnsiStr', cdRegister);
 S.RegisterDelphiFunction(@IsEmptyStr, 'IsEmptyStr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStr, 'ReplaceStr', cdRegister);
 S.RegisterDelphiFunction(@DelSpace, 'DelSpace', cdRegister);
 S.RegisterDelphiFunction(@DelChars, 'DelChars', cdRegister);
 S.RegisterDelphiFunction(@DelBSpace, 'DelBSpace', cdRegister);
 S.RegisterDelphiFunction(@DelESpace, 'DelESpace', cdRegister);
 S.RegisterDelphiFunction(@DelRSpace, 'DelRSpace', cdRegister);
 S.RegisterDelphiFunction(@DelSpace1, 'DelSpace1', cdRegister);
 S.RegisterDelphiFunction(@Tab2Space, 'Tab2Space', cdRegister);
 S.RegisterDelphiFunction(@NPos, 'NPos', cdRegister);
 S.RegisterDelphiFunction(@MakeStr_P, 'MakeStr', cdRegister);
 S.RegisterDelphiFunction(@MakeStr1_P, 'MakeStr1', cdRegister);
 S.RegisterDelphiFunction(@MS, 'MS', cdRegister);
 S.RegisterDelphiFunction(@AddChar, 'AddChar', cdRegister);
 S.RegisterDelphiFunction(@AddCharR, 'AddCharR', cdRegister);
 S.RegisterDelphiFunction(@LeftStr, 'LeftStrJ', cdRegister);
 S.RegisterDelphiFunction(@RightStr, 'RightStrJ', cdRegister);
 S.RegisterDelphiFunction(@CenterStr, 'CenterStr', cdRegister);
 S.RegisterDelphiFunction(@CompStr, 'CompStr', cdRegister);
 S.RegisterDelphiFunction(@CompText, 'CompText', cdRegister);
 S.RegisterDelphiFunction(@Copy2Symb, 'Copy2Symb', cdRegister);
 S.RegisterDelphiFunction(@Copy2SymbDel, 'Copy2SymbDel', cdRegister);
 S.RegisterDelphiFunction(@Copy2Space, 'Copy2Space', cdRegister);
 S.RegisterDelphiFunction(@Copy2SpaceDel, 'Copy2SpaceDel', cdRegister);
 S.RegisterDelphiFunction(@AnsiProperCase, 'AnsiProperCase', cdRegister);
 S.RegisterDelphiFunction(@WordCount, 'WordCount', cdRegister);
 S.RegisterDelphiFunction(@WordPosition, 'WordPosition', cdRegister);
 S.RegisterDelphiFunction(@ExtractWord, 'ExtractWord', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordPos, 'ExtractWordPos', cdRegister);
 S.RegisterDelphiFunction(@ExtractDelimited, 'ExtractDelimited', cdRegister);
 S.RegisterDelphiFunction(@ExtractSubstr, 'ExtractSubstr', cdRegister);
 S.RegisterDelphiFunction(@IsWordPresent, 'IsWordPresent', cdRegister);
 S.RegisterDelphiFunction(@QuotedString, 'QuotedString', cdRegister);
 S.RegisterDelphiFunction(@ExtractQuotedString, 'ExtractQuotedString', cdRegister);
 S.RegisterDelphiFunction(@FindPart, 'FindPart', cdRegister);
 S.RegisterDelphiFunction(@IsWild, 'IsWild', cdRegister);
 S.RegisterDelphiFunction(@XorString, 'XorString', cdRegister);
 S.RegisterDelphiFunction(@XorEncode, 'XorEncode', cdRegister);
 S.RegisterDelphiFunction(@XorDecode, 'XorDecode', cdRegister);
 S.RegisterDelphiFunction(@GetCmdLineArg, 'GetCmdLineArg', cdRegister);
 S.RegisterDelphiFunction(@Numb2USA, 'Numb2USA', cdRegister);
 S.RegisterDelphiFunction(@Dec2Hex, 'Dec2Hex', cdRegister);
 S.RegisterDelphiFunction(@Hex2Dec, 'Hex2Dec', cdRegister);
 S.RegisterDelphiFunction(@Dec2Numb, 'Dec2Numb', cdRegister);
 S.RegisterDelphiFunction(@Numb2Dec, 'Numb2Dec', cdRegister);
 S.RegisterDelphiFunction(@IntToBin, 'IntToBinJ', cdRegister);
 S.RegisterDelphiFunction(@IntToRoman, 'IntToRoman', cdRegister);
 S.RegisterDelphiFunction(@RomanToInt, 'RomanToInt', cdRegister);
 S.RegisterDelphiFunction(@FindNotBlankCharPos, 'FindNotBlankCharPos', cdRegister);
 S.RegisterDelphiFunction(@FindNotBlankCharPosW, 'FindNotBlankCharPosW', cdRegister);
 S.RegisterDelphiFunction(@AnsiChangeCase, 'AnsiChangeCase', cdRegister);
 S.RegisterDelphiFunction(@WideChangeCase, 'WideChangeCase', cdRegister);
 S.RegisterDelphiFunction(@StartsText, 'StartsText', cdRegister);
 S.RegisterDelphiFunction(@EndsText, 'EndsText', cdRegister);
 S.RegisterDelphiFunction(@DequotedStr, 'DequotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiDequotedStr, 'AnsiDequotedStr', cdRegister);
 //S.RegisterDelphiFunction(@JvJCLUtils.GetTempFileName, 'GetTempFileNameJ', cdRegister);
 S.RegisterDelphiFunction(@FileDateTime, 'FileDateTime', cdRegister);
 S.RegisterDelphiFunction(@HasAttr, 'HasAttr', cdRegister);
 S.RegisterDelphiFunction(@DeleteFilesEx, 'DeleteFilesEx', cdRegister);
 S.RegisterDelphiFunction(@NormalDir, 'NormalDir', cdRegister);
 S.RegisterDelphiFunction(@RemoveBackSlash, 'RemoveBackSlash', cdRegister);
 S.RegisterDelphiFunction(@ValidFileName, 'ValidFileName', cdRegister);
 S.RegisterDelphiFunction(@FileLock_P, 'FileLock', cdRegister);
 S.RegisterDelphiFunction(@FileLock1_P, 'FileLock1', cdRegister);
 S.RegisterDelphiFunction(@FileUnlock_P, 'FileUnlock', cdRegister);
 S.RegisterDelphiFunction(@FileUnlock1_P, 'FileUnlock1', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsDir, 'GetWindowsDir', cdRegister);
 S.RegisterDelphiFunction(@GetSystemDir, 'GetSystemDir', cdRegister);
 S.RegisterDelphiFunction(@ShortToLongFileName, 'ShortToLongFileName', cdRegister);
 S.RegisterDelphiFunction(@LongToShortFileName, 'LongToShortFileName', cdRegister);
 S.RegisterDelphiFunction(@ShortToLongPath, 'ShortToLongPath', cdRegister);
 S.RegisterDelphiFunction(@LongToShortPath, 'LongToShortPath', cdRegister);
 S.RegisterDelphiFunction(@CreateFileLink, 'CreateFileLink', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileLink, 'DeleteFileLink', cdRegister);
 S.RegisterDelphiFunction(@PtInRectInclusive, 'PtInRectInclusive', cdRegister);
 S.RegisterDelphiFunction(@PtInRectExclusive, 'PtInRectExclusive', cdRegister);
 S.RegisterDelphiFunction(@FourDigitYear, 'FourDigitYear', cdRegister);
 S.RegisterDelphiFunction(@IsFourDigitYear, 'IsFourDigitYear', cdRegister);
 S.RegisterDelphiFunction(@OpenObject_P, 'OpenObject', cdRegister);
 S.RegisterDelphiFunction(@OpenObject1_P, 'OpenObject1', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastWin32_P, 'RaiseLastWin32', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastWin321_P, 'RaiseLastWin321', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastWin321_P, 'RaiseLastWin32_2', cdRegister);

 S.RegisterDelphiFunction(@GetFileVersion, 'GetFileVersion', cdRegister);
 S.RegisterDelphiFunction(@GetShellVersion, 'GetShellVersion', cdRegister);
 S.RegisterDelphiFunction(@OpenCdDrive, 'OpenCdDrive', cdRegister);
 S.RegisterDelphiFunction(@CloseCdDrive, 'CloseCdDrive', cdRegister);
 S.RegisterDelphiFunction(@DiskInDrive, 'DiskInDrive', cdRegister);
 S.RegisterDelphiFunction(@PError, 'PError', cdRegister);
 S.RegisterDelphiFunction(@Exec, 'Exec', cdRegister);
 S.RegisterDelphiFunction(@ExecuteAndWait, 'ExecuteAndWait', cdRegister);
 S.RegisterDelphiFunction(@FirstInstance, 'FirstInstance', cdRegister);
 S.RegisterDelphiFunction(@RestoreOtherInstance, 'RestoreOtherInstance', cdRegister);
 S.RegisterDelphiFunction(@HideTraybar, 'HideTraybar', cdRegister);
 S.RegisterDelphiFunction(@ShowTraybar, 'ShowTraybar', cdRegister);
 S.RegisterDelphiFunction(@ShowStartButton, 'ShowStartButton', cdRegister);
 S.RegisterDelphiFunction(@MonitorOn, 'MonitorOn', cdRegister);
 S.RegisterDelphiFunction(@MonitorOff, 'MonitorOff', cdRegister);
 S.RegisterDelphiFunction(@LowPower, 'LowPower', cdRegister);
 S.RegisterDelphiFunction(@SendKey, 'SendKey', cdRegister);
 S.RegisterDelphiFunction(@GetVisibleWindows, 'GetVisibleWindows', cdRegister);
 S.RegisterDelphiFunction(@GetVisibleWindowsF, 'GetVisibleWindowsF', cdRegister);
 S.RegisterDelphiFunction(@AssociateExtension, 'AssociateExtension', cdRegister);
 S.RegisterDelphiFunction(@AddToRecentDocs, 'AddToRecentDocs', cdRegister);
 S.RegisterDelphiFunction(@GetRecentDocs, 'GetRecentDocs', cdRegister);
 S.RegisterDelphiFunction(@CharIsMoney, 'CharIsMoney', cdRegister);
 //S.RegisterDelphiFunction(@JvSafeStrToFloatDef, 'JvSafeStrToFloatDef', cdRegister);
 //S.RegisterDelphiFunction(@JvSafeStrToFloat, 'JvSafeStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@StrToCurrDef, 'StrToCurrDef', cdRegister);
 S.RegisterDelphiFunction(@IntToExtended, 'IntToExtended', cdRegister);
 S.RegisterDelphiFunction(@GetChangedText, 'GetChangedText', cdRegister);
 S.RegisterDelphiFunction(@MakeYear4Digit, 'MakeYear4Digit', cdRegister);
 //S.RegisterDelphiFunction(@StrIsInteger, 'StrIsInteger', cdRegister);
 S.RegisterDelphiFunction(@StrIsFloatMoney, 'StrIsFloatMoney', cdRegister);
 S.RegisterDelphiFunction(@StrIsDateTime, 'StrIsDateTime', cdRegister);
 S.RegisterDelphiFunction(@PreformatDateString, 'PreformatDateString', cdRegister);
 S.RegisterDelphiFunction(@BooleanToInteger, 'BooleanToInteger', cdRegister);
 S.RegisterDelphiFunction(@StringToBoolean, 'StringToBoolean', cdRegister);
 S.RegisterDelphiFunction(@StringToBoolean, 'StrToBo', cdRegister);
 S.RegisterDelphiFunction(@SafeStrToDateTime, 'SafeStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@SafeStrToDate, 'SafeStrToDate', cdRegister);
 S.RegisterDelphiFunction(@SafeStrToTime, 'SafeStrToTime', cdRegister);
 S.RegisterDelphiFunction(@StrDelete, 'StrDelete', cdRegister);
 S.RegisterDelphiFunction(@TimeOnly, 'TimeOnly', cdRegister);
 S.RegisterDelphiFunction(@DateOnly, 'DateOnly', cdRegister);
 S.RegisterDelphiFunction(@DateIsNull, 'DateIsNull', cdRegister);
 S.RegisterDelphiFunction(@OSCheck, 'OSCheck', cdRegister);
 S.RegisterDelphiFunction(@MinimizeFileName, 'MinimizeFileName', cdRegister);
 S.RegisterDelphiFunction(@MinimizeText, 'MinimizeText', cdRegister);
 S.RegisterDelphiFunction(@MinimizeString, 'MinimizeString', cdRegister);
 S.RegisterDelphiFunction(@RunDLL32, 'RunDLL32', cdRegister);
 S.RegisterDelphiFunction(@RunDll32Internal, 'RunDll32Internal', cdRegister);
 S.RegisterDelphiFunction(@GetDLLVersion, 'GetDLLVersion', cdRegister);
 S.RegisterDelphiFunction(@ResourceNotFound, 'ResourceNotFound', cdRegister);
 S.RegisterDelphiFunction(@EmptyRect, 'EmptyRect', cdRegister);
 S.RegisterDelphiFunction(@RectWidth, 'RectWidth', cdRegister);
 S.RegisterDelphiFunction(@RectHeight, 'RectHeight', cdRegister);
 S.RegisterDelphiFunction(@CompareRect, 'CompareRect', cdRegister);
 S.RegisterDelphiFunction(@RectNormalize, 'RectNormalize', cdRegister);
 S.RegisterDelphiFunction(@RectIsSquare, 'RectIsSquare', cdRegister);
 S.RegisterDelphiFunction(@RectSquare, 'RectSquare', cdRegister);
 S.RegisterDelphiFunction(@FreeUnusedOle, 'FreeUnusedOle', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsVersion, 'GetWindowsVersion', cdRegister);
 S.RegisterDelphiFunction(@LoadDLL, 'LoadDLL', cdRegister);
 S.RegisterDelphiFunction(@RegisterServer, 'RegisterServer', cdRegister);
 S.RegisterDelphiFunction(@UnregisterServer, 'UnregisterServer', cdRegister);
 S.RegisterDelphiFunction(@GetEnvVar, 'GetEnvVar', cdRegister);
 S.RegisterDelphiFunction(@GetEnvVar, 'GetEnvironmentVariable', cdRegister);

 S.RegisterDelphiFunction(@AnsiUpperFirstChar, 'AnsiUpperFirstChar', cdRegister);
 S.RegisterDelphiFunction(@StringToPChar, 'StringToPChar', cdRegister);
 S.RegisterDelphiFunction(@StrPAlloc, 'StrPAlloc', cdRegister);
 S.RegisterDelphiFunction(@SplitCommandLine, 'SplitCommandLine', cdRegister);
 S.RegisterDelphiFunction(@DropT, 'DropT', cdRegister);
 S.RegisterDelphiFunction(@AllocMemo, 'AllocMemo', cdRegister);
 S.RegisterDelphiFunction(@ReallocMemo, 'ReallocMemo', cdRegister);
 S.RegisterDelphiFunction(@FreeMemo, 'FreeMemo', cdRegister);
 S.RegisterDelphiFunction(@GetMemoSize, 'GetMemoSize', cdRegister);
 //S.RegisterDelphiFunction(@CompareMem, 'CompareMem', cdRegister);
 S.RegisterDelphiFunction(@HugeInc, 'HugeInc', cdRegister);
 S.RegisterDelphiFunction(@HugeDec, 'HugeDec', cdRegister);
 S.RegisterDelphiFunction(@HugeOffset, 'HugeOffset', cdRegister);
 S.RegisterDelphiFunction(@HugeMove, 'HugeMove', cdRegister);
 S.RegisterDelphiFunction(@HMemCpy, 'HMemCpy', cdRegister);
 S.RegisterDelphiFunction(@WindowClassName, 'WindowClassName', cdRegister);
 S.RegisterDelphiFunction(@SwitchToWindow, 'SwitchToWindow', cdRegister);
 S.RegisterDelphiFunction(@ActivateWindow, 'ActivateWindow', cdRegister);
 S.RegisterDelphiFunction(@ShowWinNoAnimate, 'ShowWinNoAnimate', cdRegister);
 S.RegisterDelphiFunction(@KillMessage, 'KillMessage', cdRegister);
 S.RegisterDelphiFunction(@SetWindowTop, 'SetWindowTop', cdRegister);
 S.RegisterDelphiFunction(@CenterWindow, 'CenterWindow', cdRegister);
 S.RegisterDelphiFunction(@MakeVariant, 'MakeVariant', cdRegister);
 S.RegisterDelphiFunction(@DialogUnitsToPixelsX, 'DialogUnitsToPixelsX', cdRegister);
 S.RegisterDelphiFunction(@DialogUnitsToPixelsY, 'DialogUnitsToPixelsY', cdRegister);
 S.RegisterDelphiFunction(@PixelsToDialogUnitsX, 'PixelsToDialogUnitsX', cdRegister);
 S.RegisterDelphiFunction(@PixelsToDialogUnitsY, 'PixelsToDialogUnitsY', cdRegister);
 S.RegisterDelphiFunction(@GetUniqueFileNameInDir, 'GetUniqueFileNameInDir', cdRegister);
 S.RegisterDelphiFunction(@FindPrevInstance, 'FindPrevInstance', cdRegister);
 S.RegisterDelphiFunction(@ActivatePrevInstance, 'ActivatePrevInstance', cdRegister);
 S.RegisterDelphiFunction(@FindPrevInstance, 'FindPrevInstance', cdRegister);
 S.RegisterDelphiFunction(@ActivatePrevInstance, 'ActivatePrevInstance', cdRegister);
 S.RegisterDelphiFunction(@BrowseForFolderNative, 'BrowseForFolderNative', cdRegister);
 S.RegisterDelphiFunction(@AntiAlias, 'AntiAlias', cdRegister);
 S.RegisterDelphiFunction(@AntiAliasRect, 'AntiAliasRect', cdRegister);
 S.RegisterDelphiFunction(@CopyRectDIBits, 'CopyRectDIBits', cdRegister);
 S.RegisterDelphiFunction(@IsTrueType, 'IsTrueType', cdRegister);
 S.RegisterDelphiFunction(@TextToValText, 'TextToValText', cdRegister);
 S.RegisterDelphiFunction(@BitBlt_P, 'BitBlt', cdRegister);
 S.RegisterDelphiFunction(@BitBlt1_P, 'BitBlt1', cdRegister);
 S.RegisterDelphiFunction(@BitBlt2_P, 'BitBlt2', cdRegister);
 S.RegisterDelphiFunction(@BitBlt3_P, 'BitBlt3', cdRegister);
 S.RegisterDelphiFunction(@IsEqualGUID, 'IsEqualGUID', cdRegister);
 S.RegisterDelphiFunction(@bintostr, 'binToStr', cdRegister);
 S.RegisterDelphiFunction(@MoveCardinal2String, 'MoveCardinal2String', cdRegister);
 S.RegisterDelphiFunction(@MoveString2Cardinal, 'MoveString2Cardinal', cdRegister);
 S.RegisterDelphiFunction(@MoveCardinal, 'MoveCardinal', cdRegister);


 {procedure MoveCardinal2String(const Source: cardinal; SrcStartIdx: Integer; var Dest: string;
  DstStartIdx: Integer; Count: Integer);
procedure MoveString2Cardinal(const Source: string; SrcStartIdx: Integer; var Dest: Cardinal;
  DstStartIdx: Integer; Count: Integer);
procedure MoveCardinal(const Source: cardinal; var Dest: Cardinal; Count: Integer); }


  //RIRegister_TIntegerList(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvJCLUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJvConvertError) do
   RIRegister_TIntegerList(CL);

end;

 
 
{ TPSImport_JvJCLUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvJCLUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvJCLUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvJCLUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvJCLUtils(ri);
  RIRegister_JvJCLUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
