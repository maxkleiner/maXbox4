unit uPSI_ZSysUtils;
{
   last of Z from ADA to Zeos
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
  TPSImport_ZSysUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZSortedList(CL: TPSPascalCompiler);
procedure SIRegister_ZSysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ZSysUtils_Routines(S: TPSExec);
procedure RIRegister_TZSortedList(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZSysUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,ZMessages
  ,ZCompatibility
  ,Types
  ,ZSysUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZSysUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZSortedList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TZSortedList') do
  with CL.AddClassN(CL.FindClass('TList'),'TZSortedList') do
  begin
    RegisterMethod('Procedure Sort( Compare : TZListSortCompare)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZSysUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TZListSortCompare', 'Function (Item1, Item2 : TObject): Integer');
  SIRegister_TZSortedList(CL);
 CL.AddDelphiFunction('Function zFirstDelimiter( const Delimiters, Str : string) : Integer');
 CL.AddDelphiFunction('Function zLastDelimiter( const Delimiters, Str : string) : Integer');
 //CL.AddDelphiFunction('Function MemLCompUnicode( P1, P2 : PWideChar; Len : Integer) : Boolean');
 //CL.AddDelphiFunction('Function MemLCompAnsi( P1, P2 : PAnsiChar; Len : Integer) : Boolean');
 CL.AddDelphiFunction('Function zStartsWith( const Str, SubStr : WideString) : Boolean;');
 CL.AddDelphiFunction('Function StartsWith1( const Str, SubStr : RawByteString) : Boolean;');
 CL.AddDelphiFunction('Function EndsWith( const Str, SubStr : WideString) : Boolean;');
 CL.AddDelphiFunction('Function EndsWith1( const Str, SubStr : RawByteString) : Boolean;');
 CL.AddDelphiFunction('Function SQLStrToFloatDef( Str : RawByteString; Def : Extended) : Extended;');
 CL.AddDelphiFunction('Function SQLStrToFloatDef1( Str : String; Def : Extended) : Extended;');
 CL.AddDelphiFunction('Function SQLStrToFloat( const Str : AnsiString) : Extended');
 //CL.AddDelphiFunction('Function BufferToStr( Buffer : PWideChar; Length : LongInt) : string;');
 //CL.AddDelphiFunction('Function BufferToStr1( Buffer : PAnsiChar; Length : LongInt) : string;');
 CL.AddDelphiFunction('Function BufferToBytes( Buffer : TObject; Length : LongInt) : TByteDynArray');
 CL.AddDelphiFunction('Function StrToBoolEx( Str : string) : Boolean');
 CL.AddDelphiFunction('Function BoolToStrEx( Bool : Boolean) : String');
 CL.AddDelphiFunction('Function IsIpAddr( const Str : string) : Boolean');
 CL.AddDelphiFunction('Function IsIP( const Str : string) : Boolean');       //alias
 CL.AddDelphiFunction('Function zSplitString( const Str, Delimiters : string) : TStrings');
 CL.AddDelphiFunction('Procedure PutSplitString( List : TStrings; const Str, Delimiters : string)');
 CL.AddDelphiFunction('Procedure AppendSplitString( List : TStrings; const Str, Delimiters : string)');
 CL.AddDelphiFunction('Function ComposeString( List : TStrings; const Delimiter : string) : string');
 CL.AddDelphiFunction('Function FloatToSQLStr( Value : Extended) : string');
 CL.AddDelphiFunction('Procedure PutSplitStringEx( List : TStrings; const Str, Delimiter : string)');
 CL.AddDelphiFunction('Function SplitStringEx( const Str, Delimiter : string) : TStrings');
 CL.AddDelphiFunction('Procedure AppendSplitStringEx( List : TStrings; const Str, Delimiter : string)');
 CL.AddDelphiFunction('Function zBytesToStr( const Value : TByteDynArray) : AnsiString');
 CL.AddDelphiFunction('Function zStrToBytes( const Value : AnsiString) : TByteDynArray;');
 CL.AddDelphiFunction('Function StrToBytes1( const Value : UTF8String) : TByteDynArray;');
 CL.AddDelphiFunction('Function StrToBytes2( const Value : RawByteString) : TByteDynArray;');
 CL.AddDelphiFunction('Function StrToBytes3( const Value : WideString) : TByteDynArray;');
 CL.AddDelphiFunction('Function StrToBytes4( const Value : UnicodeString) : TByteDynArray;');
 CL.AddDelphiFunction('Function BytesToVar( const Value : TByteDynArray) : Variant');
 CL.AddDelphiFunction('Function VarToBytes( const Value : Variant) : TByteDynArray');
 CL.AddDelphiFunction('Function AnsiSQLDateToDateTime( const Value : string) : TDateTime');
 CL.AddDelphiFunction('Function TimestampStrToDateTime( const Value : string) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToAnsiSQLDate( Value : TDateTime; WithMMSec : Boolean) : string');
 CL.AddDelphiFunction('Function EncodeCString( const Value : string) : string');
 CL.AddDelphiFunction('Function DecodeCString( const Value : string) : string');
 CL.AddDelphiFunction('Function zReplaceChar( const Source, Target : Char; const Str : string) : string');
 CL.AddDelphiFunction('Function MemPas( Buffer : PChar; Length : LongInt) : string');
 CL.AddDelphiFunction('Procedure DecodeSQLVersioning( const FullVersion : Integer; out MajorVersion : Integer; out MinorVersion : Integer; out SubVersion : Integer)');
 CL.AddDelphiFunction('Function EncodeSQLVersioning( const MajorVersion : Integer; const MinorVersion : Integer; const SubVersion : Integer) : Integer');
 CL.AddDelphiFunction('Function FormatSQLVersion( const SQLVersion : Integer) : String');
 CL.AddDelphiFunction('Function ZStrToFloat( Value : AnsiChar) : Extended;');
 CL.AddDelphiFunction('Function ZStrToFloat1( Value : AnsiString) : Extended;');
 CL.AddDelphiFunction('Procedure ZSetString( const Src : AnsiChar; var Dest : AnsiString);');
 CL.AddDelphiFunction('Procedure ZSetString1( const Src : AnsiChar; const Len : Cardinal; var Dest : AnsiString);');
 CL.AddDelphiFunction('Procedure ZSetString2( const Src : AnsiChar; var Dest : UTF8String);');
 CL.AddDelphiFunction('Procedure ZSetString3( const Src : AnsiChar; const Len : Cardinal; var Dest : UTF8String);');
 CL.AddDelphiFunction('Procedure ZSetString4( const Src : AnsiChar; const Len : Cardinal; var Dest : WideString);');
 CL.AddDelphiFunction('Procedure ZSetString5( const Src : AnsiChar; var Dest : RawByteString);');
 CL.AddDelphiFunction('Procedure ZSetString6( const Src : AnsiChar; const Len : Cardinal; var Dest : RawByteString);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure ZSetString6_P( const Src : PAnsiChar; const Len : Cardinal; var Dest : RawByteString);
Begin ZSysUtils.ZSetString(Src, Len, Dest); END;

(*----------------------------------------------------------------------------*)
Procedure ZSetString5_P( const Src : PAnsiChar; var Dest : RawByteString);
Begin ZSysUtils.ZSetString(Src, Dest); END;

(*----------------------------------------------------------------------------*)
Procedure ZSetString4_P( const Src : PAnsiChar; const Len : Cardinal; var Dest : ZWideString);
Begin ZSysUtils.ZSetString(Src, Len, Dest); END;

(*----------------------------------------------------------------------------*)
Procedure ZSetString3_P( const Src : PAnsiChar; const Len : Cardinal; var Dest : UTF8String);
Begin ZSysUtils.ZSetString(Src, Len, Dest); END;

(*----------------------------------------------------------------------------*)
Procedure ZSetString2_P( const Src : PAnsiChar; var Dest : UTF8String);
Begin ZSysUtils.ZSetString(Src, Dest); END;

(*----------------------------------------------------------------------------*)
Procedure ZSetString1_P( const Src : PAnsiChar; const Len : Cardinal; var Dest : AnsiString);
Begin ZSysUtils.ZSetString(Src, Len, Dest); END;

(*----------------------------------------------------------------------------*)
Procedure ZSetString_P( const Src : PAnsiChar; var Dest : AnsiString);
Begin ZSysUtils.ZSetString(Src, Dest); END;

(*----------------------------------------------------------------------------*)
Function ZStrToFloat1_P( Value : AnsiString) : Extended;
Begin Result := ZSysUtils.ZStrToFloat(Value); END;

(*----------------------------------------------------------------------------*)
Function ZStrToFloat_P( Value : PAnsiChar) : Extended;
Begin Result := ZSysUtils.ZStrToFloat(Value); END;

(*----------------------------------------------------------------------------*)
Function StrToBytes4_P( const Value : WideString) : TByteDynArray;
Begin Result := ZSysUtils.StrToBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function StrToBytes3_P( const Value : WideString) : TByteDynArray;
Begin Result := ZSysUtils.StrToBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function StrToBytes2_P( const Value : RawByteString) : TByteDynArray;
Begin Result := ZSysUtils.StrToBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function StrToBytes1_P( const Value : UTF8String) : TByteDynArray;
Begin Result := ZSysUtils.StrToBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function StrToBytes_P( const Value : AnsiString) : TByteDynArray;
Begin Result := ZSysUtils.StrToBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function BufferToStr1_P( Buffer : PAnsiChar; Length : LongInt) : string;
Begin Result := ZSysUtils.BufferToStr(Buffer, Length); END;

(*----------------------------------------------------------------------------*)
Function BufferToStr_P( Buffer : PWideChar; Length : LongInt) : string;
Begin Result := ZSysUtils.BufferToStr(Buffer, Length); END;

(*----------------------------------------------------------------------------*)
Function SQLStrToFloatDef1_P( Str : String; Def : Extended) : Extended;
Begin Result := ZSysUtils.SQLStrToFloatDef(Str, Def); END;

(*----------------------------------------------------------------------------*)
Function SQLStrToFloatDef_P( Str : RawByteString; Def : Extended) : Extended;
Begin Result := ZSysUtils.SQLStrToFloatDef(Str, Def); END;

(*----------------------------------------------------------------------------*)
Function EndsWith1_P( const Str, SubStr : RawByteString) : Boolean;
Begin Result := ZSysUtils.EndsWith(Str, SubStr); END;

(*----------------------------------------------------------------------------*)
Function EndsWith_P( const Str, SubStr : ZWideString) : Boolean;
Begin Result := ZSysUtils.EndsWith(Str, SubStr); END;

(*----------------------------------------------------------------------------*)
Function StartsWith1_P( const Str, SubStr : RawByteString) : Boolean;
Begin Result := ZSysUtils.StartsWith(Str, SubStr); END;

(*----------------------------------------------------------------------------*)
Function StartsWith_P( const Str, SubStr : ZWideString) : Boolean;
Begin Result := ZSysUtils.StartsWith(Str, SubStr); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZSysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FirstDelimiter, 'zFirstDelimiter', cdRegister);
 S.RegisterDelphiFunction(@LastDelimiter, 'zLastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@MemLCompUnicode, 'MemLCompUnicode', cdRegister);
 S.RegisterDelphiFunction(@MemLCompAnsi, 'MemLCompAnsi', cdRegister);
 S.RegisterDelphiFunction(@StartsWith, 'zStartsWith', cdRegister);
 S.RegisterDelphiFunction(@StartsWith1_P, 'StartsWith1', cdRegister);
 S.RegisterDelphiFunction(@EndsWith, 'EndsWith', cdRegister);
 S.RegisterDelphiFunction(@EndsWith1_P, 'EndsWith1', cdRegister);
 S.RegisterDelphiFunction(@SQLStrToFloatDef, 'SQLStrToFloatDef', cdRegister);
 S.RegisterDelphiFunction(@SQLStrToFloatDef1_P, 'SQLStrToFloatDef1', cdRegister);
 S.RegisterDelphiFunction(@SQLStrToFloat, 'SQLStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@BufferToStr, 'BufferToStr', cdRegister);
 S.RegisterDelphiFunction(@BufferToStr1_P, 'BufferToStr1', cdRegister);
 S.RegisterDelphiFunction(@BufferToBytes, 'BufferToBytes', cdRegister);
 S.RegisterDelphiFunction(@StrToBoolEx, 'StrToBoolEx', cdRegister);
 S.RegisterDelphiFunction(@BoolToStrEx, 'BoolToStrEx', cdRegister);
 S.RegisterDelphiFunction(@IsIpAddr, 'IsIpAddr', cdRegister);
 S.RegisterDelphiFunction(@IsIpAddr, 'IsIP', cdRegister);
 S.RegisterDelphiFunction(@SplitString, 'zSplitString', cdRegister);
 S.RegisterDelphiFunction(@PutSplitString, 'PutSplitString', cdRegister);
 S.RegisterDelphiFunction(@AppendSplitString, 'AppendSplitString', cdRegister);
 S.RegisterDelphiFunction(@ComposeString, 'ComposeString', cdRegister);
 S.RegisterDelphiFunction(@FloatToSQLStr, 'FloatToSQLStr', cdRegister);
 S.RegisterDelphiFunction(@PutSplitStringEx, 'PutSplitStringEx', cdRegister);
 S.RegisterDelphiFunction(@SplitStringEx, 'SplitStringEx', cdRegister);
 S.RegisterDelphiFunction(@AppendSplitStringEx, 'AppendSplitStringEx', cdRegister);
 S.RegisterDelphiFunction(@BytesToStr, 'zBytesToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToBytes, 'zStrToBytes', cdRegister);
 S.RegisterDelphiFunction(@StrToBytes1_P, 'StrToBytes1', cdRegister);
 S.RegisterDelphiFunction(@StrToBytes2_P, 'StrToBytes2', cdRegister);
 S.RegisterDelphiFunction(@StrToBytes3_P, 'StrToBytes3', cdRegister);
 S.RegisterDelphiFunction(@StrToBytes4_P, 'StrToBytes4', cdRegister);
 S.RegisterDelphiFunction(@BytesToVar, 'BytesToVar', cdRegister);
 S.RegisterDelphiFunction(@VarToBytes, 'VarToBytes', cdRegister);
 S.RegisterDelphiFunction(@AnsiSQLDateToDateTime, 'AnsiSQLDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TimestampStrToDateTime, 'TimestampStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToAnsiSQLDate, 'DateTimeToAnsiSQLDate', cdRegister);
 S.RegisterDelphiFunction(@EncodeCString, 'EncodeCString', cdRegister);
 S.RegisterDelphiFunction(@DecodeCString, 'DecodeCString', cdRegister);
 S.RegisterDelphiFunction(@ReplaceChar, 'zReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@MemPas, 'MemPas', cdRegister);
 S.RegisterDelphiFunction(@DecodeSQLVersioning, 'DecodeSQLVersioning', cdRegister);
 S.RegisterDelphiFunction(@EncodeSQLVersioning, 'EncodeSQLVersioning', cdRegister);
 S.RegisterDelphiFunction(@FormatSQLVersion, 'FormatSQLVersion', cdRegister);
 S.RegisterDelphiFunction(@ZStrToFloat, 'ZStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@ZStrToFloat1_P, 'ZStrToFloat1', cdRegister);
 S.RegisterDelphiFunction(@ZSetString, 'ZSetString', cdRegister);
 S.RegisterDelphiFunction(@ZSetString1_P, 'ZSetString1', cdRegister);
 S.RegisterDelphiFunction(@ZSetString2_P, 'ZSetString2', cdRegister);
 S.RegisterDelphiFunction(@ZSetString3_P, 'ZSetString3', cdRegister);
 S.RegisterDelphiFunction(@ZSetString4_P, 'ZSetString4', cdRegister);
 S.RegisterDelphiFunction(@ZSetString5_P, 'ZSetString5', cdRegister);
 S.RegisterDelphiFunction(@ZSetString6_P, 'ZSetString6', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZSortedList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZSortedList) do
  begin
    RegisterMethod(@TZSortedList.Sort, 'Sort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZSysUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZSortedList(CL);
end;

 
 
{ TPSImport_ZSysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZSysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZSysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZSysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZSysUtils(ri);
  RIRegister_ZSysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
