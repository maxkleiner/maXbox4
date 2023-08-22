unit uPSI_SynEditMiscProcs;
{
   only functions     the real one
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
  TPSImport_SynEditMiscProcs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_SynEditMiscProcs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynEditMiscProcs_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
 { ,kTextDrawer
  ,QGraphics
  ,QSynEditTypes
  ,QSynEditHighlighter
  ,Windows   }
  ,Graphics
  ,SynEditTypes
  ,SynEditHighlighter
  ,Math , fmain
  ,SynEditMiscProcs
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditMiscProcs]);
end;


type
  TColorRec = packed record
    Blue: Byte;
    Green: Byte;
    Red: Byte;
    Unused: Byte;
  end;

function synGetRValue(RGBValue: TColor): byte;
begin
  Result := TColorRec(RGBValue).Red;
end;

function synGetGValue(RGBValue: TColor): byte;
begin
  Result := TColorRec(RGBValue).Green;
end;

function synGetBValue(RGBValue: TColor): byte;
begin
  Result := TColorRec(RGBValue).Blue;
end;

function synRGB(r, g, b: Byte): Cardinal;
begin
  Result := (r or (g shl 8) or (b shl 16));
end;

procedure SynAssert(Expr: Boolean);  { stub for Delphi 2 }
begin
  if not expr then maxform1.memo2.Lines.add('ASSERT false:'+booltoStr(Expr));
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditMiscProcs(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('PIntArray', '^TIntArray // will not work');

 CL.Addtypes('TConvertTabsProc' ,'function(const Line: AnsiString; TabWidth: integer): AnsiString');
 CL.Addtypes('TConvertTabsProcEx' ,'function(const Line: AnsiString; TabWidth: integer; var HasTabs: boolean): AnsiString');
 CL.AddDelphiFunction('Function synMax( x, y : integer) : integer');
 CL.AddDelphiFunction('Function synMin( x, y : integer) : integer');
 CL.AddDelphiFunction('Function synMinMax( x, mi, ma : integer) : integer');
 CL.AddDelphiFunction('Procedure synSwapInt( var l, r : integer)');
 CL.AddDelphiFunction('Function synMaxPoint( const P1, P2 : TPoint) : TPoint');
 CL.AddDelphiFunction('Function synMinPoint( const P1, P2 : TPoint) : TPoint');
 //CL.AddDelphiFunction('Function synGetIntArray( Count : Cardinal; InitialValue : integer) : PIntArray');
 CL.AddDelphiFunction('Procedure InternalFillRect( dc : HDC; const rcPaint : TRect)');
 CL.AddDelphiFunction('Function GetBestConvertTabsProc( TabWidth : integer) : TConvertTabsProc');
 CL.AddDelphiFunction('Function ConvertTabs( const Line : AnsiString; TabWidth : integer) : AnsiString');
 CL.AddDelphiFunction('Function GetBestConvertTabsProcEx( TabWidth : integer) : TConvertTabsProcEx');
 CL.AddDelphiFunction('Function ConvertTabsEx( const Line : AnsiString; TabWidth : integer; var HasTabs : boolean) : AnsiString');
 CL.AddDelphiFunction('Function GetExpandedLength( const aStr : string; aTabWidth : integer) : integer');
 CL.AddDelphiFunction('Function CharIndex2CaretPos( Index, TabWidth : integer; const Line : string) : integer');
 CL.AddDelphiFunction('Function CaretPos2CharIndex( Position, TabWidth : integer; const Line : string; var InsideTabChar : boolean) : integer');
 CL.AddDelphiFunction('Function StrScanForCharInSet( const Line : string; Start : integer; AChars : TSynIdentChars) : integer');
 CL.AddDelphiFunction('Function StrRScanForCharInSet( const Line : string; Start : integer; AChars : TSynIdentChars) : integer');
  CL.AddTypeS('TStringType', '( stNone, stHalfNumAlpha, stHalfSymbol, stHalfKat'
   +'akana, stWideNumAlpha, stWideSymbol, stWideKatakana, stHiragana, stIdeogra'
   +'ph, stControl, stKashida )');
 CL.AddConstantN('C3_NONSPACING','LongInt').SetInt( 1);
 CL.AddConstantN('C3_DIACRITIC','LongInt').SetInt( 2);
 CL.AddConstantN('C3_VOWELMARK','LongInt').SetInt( 4);
 CL.AddConstantN('C3_SYMBOL','LongInt').SetInt( 8);
 CL.AddConstantN('C3_KATAKANA','LongWord').SetUInt( $0010);
 CL.AddConstantN('C3_HIRAGANA','LongWord').SetUInt( $0020);
 CL.AddConstantN('C3_HALFWIDTH','LongWord').SetUInt( $0040);
 CL.AddConstantN('C3_FULLWIDTH','LongWord').SetUInt( $0080);
 CL.AddConstantN('C3_IDEOGRAPH','LongWord').SetUInt( $0100);
 CL.AddConstantN('C3_KASHIDA','LongWord').SetUInt( $0200);
 CL.AddConstantN('C3_LEXICAL','LongWord').SetUInt( $0400);
 CL.AddConstantN('C3_ALPHA','LongWord').SetUInt( $8000);
 CL.AddConstantN('C3_NOTAPPLICABLE','LongInt').SetInt( 0);
 CL.AddDelphiFunction('Function StrScanForMultiByteChar( const Line : string; Start : Integer) : Integer');
 CL.AddDelphiFunction('Function StrRScanForMultiByteChar( const Line : string; Start : Integer) : Integer');
 CL.AddDelphiFunction('Function synIsStringType( Value : Word) : TStringType');
 CL.AddDelphiFunction('Function IsStringType( Value : Word) : TStringType');
 CL.AddDelphiFunction('Function synGetEOL( Line : PChar) : PChar');
 CL.AddDelphiFunction('Function synEncodeString( s : string) : string');
 CL.AddDelphiFunction('Function synDecodeString( s : string) : string');
 CL.AddDelphiFunction('Function EncodeString( s : string) : string');
 CL.AddDelphiFunction('Function DecodeString( s : string) : string');
 CL.AddDelphiFunction('Procedure synFreeAndNil( var Obj: TObject)');
 CL.AddDelphiFunction('Procedure synAssert( Expr : Boolean)');
 CL.AddDelphiFunction('Function synLastDelimiter( const Delimiters, S : string) : Integer');
  CL.AddDelphiFunction('Procedure FreeAndNilStream( var Obj: TStream)');
   CL.AddDelphiFunction('Procedure FreeAndNilBmp( var Obj: TBitmap)');
  CL.AddDelphiFunction('Procedure FreeAndNilStringList( var Obj: TStringlist)');
 // CL.AddTypeS('TReplaceFlag', '( rfReplaceAll, rfIgnoreCase )');
 // CL.AddTypeS('TReplaceFlags', 'set of TReplaceFlag )');
 //CL.AddTypeS('TReplaceFlag', '(rfReplaceAll, rfIgnoreCase)');
 //CL.AddTypeS('TReplaceFlags', 'set of TReplaceFlag');

 CL.AddDelphiFunction('Function synStringReplace( const S, OldPattern, NewPattern : string; Flags : TReplaceFlags) : string');
 CL.AddDelphiFunction('Function synGetRValue( RGBValue : TColor) : byte');
 CL.AddDelphiFunction('Function synGetGValue( RGBValue : TColor) : byte');
 CL.AddDelphiFunction('Function synGetBValue( RGBValue : TColor) : byte');
 CL.AddDelphiFunction('Function synRGB( r, g, b : Byte) : Cardinal');
//  CL.AddTypeS('THighlighterAttriProc', 'Function ( Highlighter : TSynCustomHigh'
  // +'lighter; Attri : TSynHighlighterAttributes; UniqueAttriName : string; Para'
   //+'ms : array of Pointer) : Boolean');
 //CL.AddDelphiFunction('Function synEnumHighlighterAttris( Highlighter : TSynCustomHighlighter; SkipDuplicates : Boolean; HighlighterAttriProc : THighlighterAttriProc; Params : array of Pointer) : Boolean');
 CL.AddDelphiFunction('Function synCalcFCS( const ABuf, ABufSize : Cardinal) : Word');
 CL.AddDelphiFunction('Procedure synSynDrawGradient( const ACanvas : TCanvas; const AStartColor, AEndColor : TColor; ASteps : integer; const ARect : TRect; const AHorizontal : boolean)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditMiscProcs_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Max, 'synMax', cdRegister);
 S.RegisterDelphiFunction(@Min, 'synMin', cdRegister);
 S.RegisterDelphiFunction(@MinMax, 'synMinMax', cdRegister);
 S.RegisterDelphiFunction(@SwapInt, 'synSwapInt', cdRegister);
 S.RegisterDelphiFunction(@MaxPoint, 'synMaxPoint', cdRegister);
 S.RegisterDelphiFunction(@MinPoint, 'synMinPoint', cdRegister);
 S.RegisterDelphiFunction(@GetIntArray, 'synGetIntArray', cdRegister);
 S.RegisterDelphiFunction(@InternalFillRect, 'InternalFillRect', cdRegister);
 S.RegisterDelphiFunction(@GetBestConvertTabsProc, 'GetBestConvertTabsProc', cdRegister);
 S.RegisterDelphiFunction(@ConvertTabs, 'ConvertTabs', cdRegister);
 S.RegisterDelphiFunction(@GetBestConvertTabsProcEx, 'GetBestConvertTabsProcEx', cdRegister);
 S.RegisterDelphiFunction(@ConvertTabsEx, 'ConvertTabsEx', cdRegister);
 S.RegisterDelphiFunction(@GetExpandedLength, 'GetExpandedLength', cdRegister);
 S.RegisterDelphiFunction(@CharIndex2CaretPos, 'CharIndex2CaretPos', cdRegister);
 S.RegisterDelphiFunction(@CaretPos2CharIndex, 'CaretPos2CharIndex', cdRegister);
 S.RegisterDelphiFunction(@StrScanForCharInSet, 'StrScanForCharInSet', cdRegister);
 S.RegisterDelphiFunction(@StrRScanForCharInSet, 'StrRScanForCharInSet', cdRegister);
 S.RegisterDelphiFunction(@StrScanForMultiByteChar, 'StrScanForMultiByteChar', cdRegister);
 S.RegisterDelphiFunction(@StrRScanForMultiByteChar, 'StrRScanForMultiByteChar', cdRegister);
 S.RegisterDelphiFunction(@IsStringType, 'synIsStringType', cdRegister);
 S.RegisterDelphiFunction(@GetEOL, 'synGetEOL', cdRegister);
 S.RegisterDelphiFunction(@EncodeString, 'synEncodeString', cdRegister);
 S.RegisterDelphiFunction(@DecodeString, 'synDecodeString', cdRegister);
 S.RegisterDelphiFunction(@EncodeString, 'EncodeString', cdRegister);
 S.RegisterDelphiFunction(@DecodeString, 'DecodeString', cdRegister);
 S.RegisterDelphiFunction(@IsStringType, 'IsStringType', cdRegister);
  S.RegisterDelphiFunction(@FreeAndNil, 'synFreeAndNil', cdRegister);
   S.RegisterDelphiFunction(@SynAssert, 'synAssert', cdRegister);
   S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNilStream', cdRegister);
   S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNilBmp', cdRegister);
   S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNilStringList', cdRegister);
 // CL.AddDelphiFunction('Procedure synAssert( Expr : Boolean)');
 //S.RegisterDelphiFunction(@Assert, 'Assert', cdRegister);
 S.RegisterDelphiFunction(@LastDelimiter, 'synLastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@StringReplace, 'synStringReplace', cdRegister);
 S.RegisterDelphiFunction(@synGetRValue, 'synGetRValue', cdRegister);
 S.RegisterDelphiFunction(@synGetGValue, 'synGetGValue', cdRegister);
 S.RegisterDelphiFunction(@synGetBValue, 'synGetBValue', cdRegister);
 S.RegisterDelphiFunction(@synRGB, 'synRGB', cdRegister);
 S.RegisterDelphiFunction(@EnumHighlighterAttris, 'synEnumHighlighterAttris', cdRegister);
 //S.RegisterDelphiFunction(@CalcFCS, 'CalcFCS', cdRegister);
 S.RegisterDelphiFunction(@SynDrawGradient, 'synSynDrawGradient', cdRegister);
end;



{ TPSImport_SynEditMiscProcs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditMiscProcs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditMiscProcs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditMiscProcs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_SynEditMiscProcs(ri);
  RIRegister_SynEditMiscProcs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
