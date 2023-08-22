unit uPSI_ZDbcUtils;
{
   to enlarge db tree
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
  TPSImport_ZDbcUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ZDbcUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ZDbcUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ,Contnrs
  ,ZCompatibility
  //,ZDbcIntfs
  //,ZDbcResultSetMetadata
  ,ZDbcUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZDbcUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ZDbcUtils(CL: TPSPascalCompiler);
begin

 { TZSQLType = (stUnknown, stBoolean, stByte, stShort, stInteger, stLong,
    stFloat, stDouble, stBigDecimal, stString, stUnicodeString, stBytes,
    stDate, stTime, stTimestamp, stDataSet, stGUID,
    stAsciiStream, stUnicodeStream, stBinaryStream);}
 CL.AddTypeS('TZSQLType', '(zsqlstUnknown, zsqlstBoolean, zsqlstByte, zsqlstShort, zsqlstInteger, zsqlstLong, zsqlstFloat, zsqlstDouble,'
  +'zsqlstBigDecimal, zsqlstString, zsqlstUnicodeString, zsqlstBytes, zsqlstDate, zsqlstTime, zsqlstTimestamp, zsqlstDataSet, zsqlstGUID,'
    +'zsqlstAsciiStream, zsqlstUnicodeStream, zsqlstBinaryStream)');
 CL.AddDelphiFunction('Function ResolveConnectionProtocol( Url : string; SupportedProtocols : TStringDynArray) : string');
 //CL.AddDelphiFunction('Procedure ResolveDatabaseUrl( const Url : string; Info : TStrings; var HostName : string; var Port : Integer; var Database : string; var UserName : string; var Password : string; ResultInfo : TStrings)');
 CL.AddDelphiFunction('Function CheckConvertion( InitialType : TZSQLType; ResultType : TZSQLType) : Boolean');
 CL.AddDelphiFunction('Function DefineColumnTypeName( ColumnType : TZSQLType) : string');
 CL.AddDelphiFunction('Procedure RaiseSQLException( E : Exception)');
 //CL.AddDelphiFunction('Procedure CopyColumnsInfo( FromList : TObjectList; ToList : TObjectList)');
 //CL.AddDelphiFunction('Function DefineStatementParameter( Statement : IZStatement; const ParamName : string; const Default : string) : string');
 CL.AddDelphiFunction('Function ToLikeString( const Value : string) : string');
 CL.AddDelphiFunction('Function GetSQLHexWideString( Value : PChar; Len : Integer; ODBC : Boolean) : WideString');
 CL.AddDelphiFunction('Function GetSQLHexAnsiString( Value : PChar; Len : Integer; ODBC : Boolean) : RawByteString');
 CL.AddDelphiFunction('Function GetSQLHexString( Value : PChar; Len : Integer; ODBC : Boolean) : String');
 //CL.AddDelphiFunction('Function GetFieldSize( const SQLType : TZSQLType; ConSettings : PZConSettings; const Precision, CharWidth : Integer; DisplaySize : PInteger; SizeInBytes : Boolean) : Integer');
 CL.AddDelphiFunction('Function WideStringStream( const AString : WideString) : TStream');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ZDbcUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ResolveConnectionProtocol, 'ResolveConnectionProtocol', cdRegister);
 //S.RegisterDelphiFunction(@ResolveDatabaseUrl, 'ResolveDatabaseUrl', cdRegister);
 S.RegisterDelphiFunction(@CheckConvertion, 'CheckConvertion', cdRegister);
 S.RegisterDelphiFunction(@DefineColumnTypeName, 'DefineColumnTypeName', cdRegister);
 S.RegisterDelphiFunction(@RaiseSQLException, 'RaiseSQLException', cdRegister);
 //S.RegisterDelphiFunction(@CopyColumnsInfo, 'CopyColumnsInfo', cdRegister);
 //S.RegisterDelphiFunction(@DefineStatementParameter, 'DefineStatementParameter', cdRegister);
 S.RegisterDelphiFunction(@ToLikeString, 'ToLikeString', cdRegister);
 S.RegisterDelphiFunction(@GetSQLHexWideString, 'GetSQLHexWideString', cdRegister);
 S.RegisterDelphiFunction(@GetSQLHexAnsiString, 'GetSQLHexAnsiString', cdRegister);
 S.RegisterDelphiFunction(@GetSQLHexString, 'GetSQLHexString', cdRegister);
 //S.RegisterDelphiFunction(@GetFieldSize, 'GetFieldSize', cdRegister);
 S.RegisterDelphiFunction(@WideStringStream, 'WideStringStream', cdRegister);
end;

 
 
{ TPSImport_ZDbcUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZDbcUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZDbcUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZDbcUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ZDbcUtils(ri);
  RIRegister_ZDbcUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
