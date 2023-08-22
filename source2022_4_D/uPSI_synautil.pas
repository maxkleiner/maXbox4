unit uPSI_synautil;
{
  AT LEAST THE CDATETIME
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
  TPSImport_synautil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_synautil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synautil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  //,UnixUtil
  //,Unix
  //,BaseUnix
  //,Libc
  //,SynaFpc
  ,synautil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synautil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_synautil(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function STimeZoneBias : integer');
 CL.AddDelphiFunction('Function TimeZone : string');
 CL.AddDelphiFunction('Function Rfc822DateTime( t : TDateTime) : string');
 CL.AddDelphiFunction('Function CDateTime( t : TDateTime) : string');
 CL.AddDelphiFunction('Function SimpleDateTime( t : TDateTime) : string');
 CL.AddDelphiFunction('Function AnsiCDateTime( t : TDateTime) : string');
 CL.AddDelphiFunction('Function GetMonthNumber( Value : String) : integer');
 CL.AddDelphiFunction('Function GetTimeFromStr( Value : string) : TDateTime');
 CL.AddDelphiFunction('Function GetDateMDYFromStr( Value : string) : TDateTime');
 CL.AddDelphiFunction('Function DecodeRfcDateTime( Value : string) : TDateTime');
 CL.AddDelphiFunction('Function GetUTTime : TDateTime');
 CL.AddDelphiFunction('Function SetUTTime( Newdt : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SGetTick : LongWord');
 CL.AddDelphiFunction('Function STickDelta( TickOld, TickNew : LongWord) : LongWord');
 CL.AddDelphiFunction('Function CodeInt( Value : Word) : Ansistring');
 CL.AddDelphiFunction('Function DecodeInt( const Value : Ansistring; Index : Integer) : Word');
 CL.AddDelphiFunction('Function CodeLongInt( Value : LongInt) : Ansistring');
 CL.AddDelphiFunction('Function DecodeLongInt( const Value : Ansistring; Index : Integer) : LongInt');
 CL.AddDelphiFunction('Function DumpStr( const Buffer : Ansistring) : string');
 CL.AddDelphiFunction('Function DumpExStr( const Buffer : Ansistring) : string');
 CL.AddDelphiFunction('Procedure Dump( const Buffer : AnsiString; DumpFile : string)');
 CL.AddDelphiFunction('Procedure DumpEx( const Buffer : AnsiString; DumpFile : string)');
 CL.AddDelphiFunction('Function TrimSPLeft( const S : string) : string');
 CL.AddDelphiFunction('Function TrimSPRight( const S : string) : string');
 CL.AddDelphiFunction('Function TrimSP( const S : string) : string');
 CL.AddDelphiFunction('Function SeparateLeft( const Value, Delimiter : string) : string');
 CL.AddDelphiFunction('Function SeparateRight( const Value, Delimiter : string) : string');
 CL.AddDelphiFunction('Function SGetParameter( const Value, Parameter : string) : string');
 CL.AddDelphiFunction('Procedure ParseParametersEx( Value, Delimiter : string; const Parameters : TStrings)');
 CL.AddDelphiFunction('Procedure ParseParameters( Value : string; const Parameters : TStrings)');
 CL.AddDelphiFunction('Function IndexByBegin( Value : string; const List : TStrings) : integer');
 CL.AddDelphiFunction('Function GetEmailAddr( const Value : string) : string');
 CL.AddDelphiFunction('Function GetEmailDesc( Value : string) : string');
 CL.AddDelphiFunction('Function CStrToHex( const Value : Ansistring) : string');
 CL.AddDelphiFunction('Function CIntToBin( Value : Integer; Digits : Byte) : string');
 CL.AddDelphiFunction('Function CBinToInt( const Value : string) : Integer');
 CL.AddDelphiFunction('Function ParseURL( URL : string; var Prot, User, Pass, Host, Port, Path, Para : string) : string');
 CL.AddDelphiFunction('Function CReplaceString( Value, Search, Replace : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function CRPosEx( const Sub, Value : string; From : integer) : Integer');
 CL.AddDelphiFunction('Function CRPos( const Sub, Value : String) : Integer');
 CL.AddDelphiFunction('Function FetchBin( var Value : string; const Delimiter : string) : string');
 CL.AddDelphiFunction('Function CFetch( var Value : string; const Delimiter : string) : string');
 CL.AddDelphiFunction('Function FetchEx( var Value : string; const Delimiter, Quotation : string) : string');
 CL.AddDelphiFunction('Function IsBinaryString( const Value : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function PosCRLF( const Value : AnsiString; var Terminator : AnsiString) : integer');
 CL.AddDelphiFunction('Procedure StringsTrim( const value : TStrings)');
 CL.AddDelphiFunction('Function PosFrom( const SubStr, Value : String; From : integer) : integer');
 CL.AddDelphiFunction('Function IncPoint( const p : ___pointer; Value : integer) : ___pointer');
 CL.AddDelphiFunction('Function GetBetween( const PairBegin, PairEnd, Value : string) : string');
 CL.AddDelphiFunction('Function CCountOfChar( const Value : string; aChr : char) : integer');
 CL.AddDelphiFunction('Function UnquoteStr( const Value : string; Quote : Char) : string');
 CL.AddDelphiFunction('Function QuoteStr( const Value : string; Quote : Char) : string');
 CL.AddDelphiFunction('Procedure HeadersToList( const Value : TStrings)');
 CL.AddDelphiFunction('Procedure ListToHeaders( const Value : TStrings)');
 CL.AddDelphiFunction('Function SwapBytes( Value : integer) : integer');
 CL.AddDelphiFunction('Function ReadStrFromStream( const Stream : TStream; len : integer) : AnsiString');
 CL.AddDelphiFunction('Procedure WriteStrToStream( const Stream : TStream; Value : AnsiString)');
 CL.AddDelphiFunction('Function GetTempFile( const Dir, prefix : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function CPadString( const Value : AnsiString; len : integer; Pad : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function CXorString( Indata1, Indata2 : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function NormalizeHeader( Value : TStrings; var Index : Integer) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_synautil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TimeZoneBias, 'STimeZoneBias', cdRegister);
 S.RegisterDelphiFunction(@TimeZone, 'TimeZone', cdRegister);
 S.RegisterDelphiFunction(@Rfc822DateTime, 'Rfc822DateTime', cdRegister);
 S.RegisterDelphiFunction(@CDateTime, 'CDateTime', cdRegister);
 S.RegisterDelphiFunction(@SimpleDateTime, 'SimpleDateTime', cdRegister);
 S.RegisterDelphiFunction(@AnsiCDateTime, 'AnsiCDateTime', cdRegister);
 S.RegisterDelphiFunction(@GetMonthNumber, 'GetMonthNumber', cdRegister);
 S.RegisterDelphiFunction(@GetTimeFromStr, 'GetTimeFromStr', cdRegister);
 S.RegisterDelphiFunction(@GetDateMDYFromStr, 'GetDateMDYFromStr', cdRegister);
 S.RegisterDelphiFunction(@DecodeRfcDateTime, 'DecodeRfcDateTime', cdRegister);
 S.RegisterDelphiFunction(@GetUTTime, 'GetUTTime', cdRegister);
 S.RegisterDelphiFunction(@SetUTTime, 'SetUTTime', cdRegister);
 S.RegisterDelphiFunction(@GetTick, 'SGetTick', cdRegister);
 S.RegisterDelphiFunction(@TickDelta, 'STickDelta', cdRegister);
 S.RegisterDelphiFunction(@CodeInt, 'CodeInt', cdRegister);
 S.RegisterDelphiFunction(@DecodeInt, 'DecodeInt', cdRegister);
 S.RegisterDelphiFunction(@CodeLongInt, 'CodeLongInt', cdRegister);
 S.RegisterDelphiFunction(@DecodeLongInt, 'DecodeLongInt', cdRegister);
 S.RegisterDelphiFunction(@DumpStr, 'DumpStr', cdRegister);
 S.RegisterDelphiFunction(@DumpExStr, 'DumpExStr', cdRegister);
 S.RegisterDelphiFunction(@Dump, 'Dump', cdRegister);
 S.RegisterDelphiFunction(@DumpEx, 'DumpEx', cdRegister);
 S.RegisterDelphiFunction(@TrimSPLeft, 'TrimSPLeft', cdRegister);
 S.RegisterDelphiFunction(@TrimSPRight, 'TrimSPRight', cdRegister);
 S.RegisterDelphiFunction(@TrimSP, 'TrimSP', cdRegister);
 S.RegisterDelphiFunction(@SeparateLeft, 'SeparateLeft', cdRegister);
 S.RegisterDelphiFunction(@SeparateRight, 'SeparateRight', cdRegister);
 S.RegisterDelphiFunction(@GetParameter, 'SGetParameter', cdRegister);
 S.RegisterDelphiFunction(@ParseParametersEx, 'ParseParametersEx', cdRegister);
 S.RegisterDelphiFunction(@ParseParameters, 'ParseParameters', cdRegister);
 S.RegisterDelphiFunction(@IndexByBegin, 'IndexByBegin', cdRegister);
 S.RegisterDelphiFunction(@GetEmailAddr, 'GetEmailAddr', cdRegister);
 S.RegisterDelphiFunction(@GetEmailDesc, 'GetEmailDesc', cdRegister);
 S.RegisterDelphiFunction(@StrToHex, 'CStrToHex', cdRegister);
 S.RegisterDelphiFunction(@IntToBin, 'CIntToBin', cdRegister);
 S.RegisterDelphiFunction(@BinToInt, 'CBinToInt', cdRegister);
 S.RegisterDelphiFunction(@ParseURL, 'ParseURL', cdRegister);
 S.RegisterDelphiFunction(@ReplaceString, 'CReplaceString', cdRegister);
 S.RegisterDelphiFunction(@RPosEx, 'CRPosEx', cdRegister);
 S.RegisterDelphiFunction(@RPos, 'CRPos', cdRegister);
 S.RegisterDelphiFunction(@FetchBin, 'FetchBin', cdRegister);
 S.RegisterDelphiFunction(@Fetch, 'CFetch', cdRegister);
 S.RegisterDelphiFunction(@FetchEx, 'FetchEx', cdRegister);
 S.RegisterDelphiFunction(@IsBinaryString, 'IsBinaryString', cdRegister);
 S.RegisterDelphiFunction(@PosCRLF, 'PosCRLF', cdRegister);
 S.RegisterDelphiFunction(@StringsTrim, 'StringsTrim', cdRegister);
 S.RegisterDelphiFunction(@PosFrom, 'PosFrom', cdRegister);
 S.RegisterDelphiFunction(@IncPoint, 'IncPoint', cdRegister);
 S.RegisterDelphiFunction(@GetBetween, 'GetBetween', cdRegister);
 S.RegisterDelphiFunction(@CountOfChar, 'CCountOfChar', cdRegister);
 S.RegisterDelphiFunction(@UnquoteStr, 'UnquoteStr', cdRegister);
 S.RegisterDelphiFunction(@QuoteStr, 'QuoteStr', cdRegister);
 S.RegisterDelphiFunction(@HeadersToList, 'HeadersToList', cdRegister);
 S.RegisterDelphiFunction(@ListToHeaders, 'ListToHeaders', cdRegister);
 S.RegisterDelphiFunction(@SwapBytes, 'SwapBytes', cdRegister);
 S.RegisterDelphiFunction(@ReadStrFromStream, 'ReadStrFromStream', cdRegister);
 S.RegisterDelphiFunction(@WriteStrToStream, 'WriteStrToStream', cdRegister);
 S.RegisterDelphiFunction(@GetTempFile, 'GetTempFile', cdRegister);
 S.RegisterDelphiFunction(@PadString, 'CPadString', cdRegister);
 S.RegisterDelphiFunction(@XorString, 'CXorString', cdRegister);
 S.RegisterDelphiFunction(@NormalizeHeader, 'NormalizeHeader', cdRegister);
end;

 
 
{ TPSImport_synautil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synautil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synautil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synautil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_synautil(ri);
  RIRegister_synautil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
