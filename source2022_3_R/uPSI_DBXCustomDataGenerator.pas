unit uPSI_DBXCustomDataGenerator;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_DBXCustomDataGenerator = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBXWideStringSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXTimestampSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXTimeSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXInt8SequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXInt64SequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXInt32SequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXInt16SequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXDoubleSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXDecimalSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXDateSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXDataGeneratorException(CL: TPSPascalCompiler);
procedure SIRegister_TDBXAnsiStringSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXBlobSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXBooleanSequenceGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TDBXDataGeneratorColumn(CL: TPSPascalCompiler);
procedure SIRegister_TDBXCustomDataGenerator(CL: TPSPascalCompiler);
procedure SIRegister_DBXCustomDataGenerator(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBXWideStringSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXTimestampSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXTimeSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXInt8SequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXInt64SequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXInt32SequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXInt16SequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXDoubleSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXDecimalSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXDateSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXDataGeneratorException(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXAnsiStringSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXBlobSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXBooleanSequenceGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXDataGeneratorColumn(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBXCustomDataGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBXCustomDataGenerator(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DBXMetaDataProvider
  ,DBXCustomDataGenerator
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBXCustomDataGenerator]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXWideStringSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXWideStringSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXWideStringSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXTimestampSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXTimestampSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXTimestampSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXTimeSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXTimeSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXTimeSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXInt8SequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXInt8SequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXInt8SequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXInt64SequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXInt64SequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXInt64SequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXInt32SequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXInt32SequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXInt32SequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetInt32( Row : Int64) : Integer');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXInt16SequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXInt16SequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXInt16SequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetInt16( Row : Int64) : SmallInt');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXDoubleSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXDoubleSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXDoubleSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetDouble( Row : Int64) : Double');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXDecimalSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXDecimalSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXDecimalSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetDecimal( Row : Int64) : WideString');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXDateSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXDateSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXDateSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetYear( Row : Int64) : Integer');
    RegisterMethod('Function GetMonth( Row : Int64) : Integer');
    RegisterMethod('Function GetDay( Row : Int64) : Integer');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXDataGeneratorException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'TDBXDataGeneratorException') do
  with CL.AddClassN(CL.FindClass('Exception'),'TDBXDataGeneratorException') do
  begin
    RegisterMethod('Constructor Create( Message : WideString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXAnsiStringSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXAnsiStringSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXAnsiStringSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXBlobSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXBlobSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXBlobSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
    RegisterMethod('Function GetBytes( Row : Int64) : TBytes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXBooleanSequenceGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXDataGeneratorColumn', 'TDBXBooleanSequenceGenerator') do
  with CL.AddClassN(CL.FindClass('TDBXDataGeneratorColumn'),'TDBXBooleanSequenceGenerator') do
  begin
    RegisterMethod('Constructor Create( MetaData : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetBoolean( Row : Int64) : Boolean');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXDataGeneratorColumn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDBXDataGeneratorColumn') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXDataGeneratorColumn') do
  begin
    RegisterMethod('Constructor Create( InMetaDataColumn : TDBXMetaDataColumn)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function GetString( Row : Int64) : WideString');
    RegisterMethod('Function GetBoolean( Row : Int64) : Boolean');
    RegisterMethod('Function GetInt8( Row : Int64) : Byte');
    RegisterMethod('Function GetInt16( Row : Int64) : SmallInt');
    RegisterMethod('Function GetInt32( Row : Int64) : Integer');
    RegisterMethod('Function GetInt64( Row : Int64) : Int64');
    RegisterMethod('Function GetDouble( Row : Int64) : Double');
    RegisterMethod('Function GetSingle( Row : Int64) : Single');
    RegisterMethod('Function GetBytes( Row : Int64) : TBytes');
    RegisterMethod('Function GetDecimal( Row : Int64) : WideString');
    RegisterMethod('Function GetYear( Row : Int64) : Integer');
    RegisterMethod('Function GetMonth( Row : Int64) : Integer');
    RegisterMethod('Function GetDay( Row : Int64) : Integer');
    RegisterMethod('Function GetHour( Row : Int64) : Integer');
    RegisterMethod('Function GetMinute( Row : Int64) : Integer');
    RegisterMethod('Function GetSeconds( Row : Int64) : Integer');
    RegisterMethod('Function GetMilliseconds( Row : Int64) : Integer');
    RegisterProperty('DataGenerator', 'TDBXCustomDataGenerator', iptw);
    RegisterProperty('ColumnName', 'WideString', iptr);
    RegisterProperty('DataType', 'Integer', iptr);
    RegisterProperty('MetaDataColumn', 'TDBXMetaDataColumn', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXCustomDataGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDBXCustomDataGenerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXCustomDataGenerator') do
  begin
    RegisterMethod('Procedure AddColumn( Column : TDBXDataGeneratorColumn)');
    RegisterMethod('Function GetColumn( Ordinal : Integer) : TDBXDataGeneratorColumn');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function CreateInsertStatement( Row : Integer) : WideString;');
    RegisterMethod('Function CreateInsertStatement1( InsertColumns : TDBXDataGeneratorColumnArray; Row : Integer) : WideString;');
    RegisterMethod('Function CreateParameterizedInsertStatement2 : WideString;');
    RegisterMethod('Function CreateParameterizedInsertStatement3( InsertColumns : TDBXDataGeneratorColumnArray) : WideString;');
    RegisterMethod('Procedure Next');
    RegisterProperty('ColumnCount', 'Integer', iptr);
    RegisterProperty('TableName', 'WideString', iptrw);
    RegisterProperty('MetaDataProvider', 'TDBXMetaDataProvider', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBXCustomDataGenerator(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXDataGeneratorColumn');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXDataGeneratorException');
  CL.AddTypeS('TDBXDataGeneratorColumnArray', 'array of TDBXDataGeneratorColumn');
  SIRegister_TDBXCustomDataGenerator(CL);
  SIRegister_TDBXDataGeneratorColumn(CL);
  SIRegister_TDBXBooleanSequenceGenerator(CL);
  SIRegister_TDBXBlobSequenceGenerator(CL);
  SIRegister_TDBXAnsiStringSequenceGenerator(CL);
  SIRegister_TDBXDataGeneratorException(CL);
  SIRegister_TDBXDateSequenceGenerator(CL);
  SIRegister_TDBXDecimalSequenceGenerator(CL);
  SIRegister_TDBXDoubleSequenceGenerator(CL);
  SIRegister_TDBXInt16SequenceGenerator(CL);
  SIRegister_TDBXInt32SequenceGenerator(CL);
  SIRegister_TDBXInt64SequenceGenerator(CL);
  SIRegister_TDBXInt8SequenceGenerator(CL);
  SIRegister_TDBXTimeSequenceGenerator(CL);
  SIRegister_TDBXTimestampSequenceGenerator(CL);
  SIRegister_TDBXWideStringSequenceGenerator(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBXDataGeneratorColumnMetaDataColumn_R(Self: TDBXDataGeneratorColumn; var T: TDBXMetaDataColumn);
begin T := Self.MetaDataColumn; end;

(*----------------------------------------------------------------------------*)
procedure TDBXDataGeneratorColumnDataType_R(Self: TDBXDataGeneratorColumn; var T: Integer);
begin T := Self.DataType; end;

(*----------------------------------------------------------------------------*)
procedure TDBXDataGeneratorColumnColumnName_R(Self: TDBXDataGeneratorColumn; var T: WideString);
begin T := Self.ColumnName; end;

(*----------------------------------------------------------------------------*)
procedure TDBXDataGeneratorColumnDataGenerator_W(Self: TDBXDataGeneratorColumn; const T: TDBXCustomDataGenerator);
begin Self.DataGenerator := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBXCustomDataGeneratorMetaDataProvider_W(Self: TDBXCustomDataGenerator; const T: TDBXMetaDataProvider);
begin Self.MetaDataProvider := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBXCustomDataGeneratorMetaDataProvider_R(Self: TDBXCustomDataGenerator; var T: TDBXMetaDataProvider);
begin T := Self.MetaDataProvider; end;

(*----------------------------------------------------------------------------*)
procedure TDBXCustomDataGeneratorTableName_W(Self: TDBXCustomDataGenerator; const T: WideString);
begin Self.TableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBXCustomDataGeneratorTableName_R(Self: TDBXCustomDataGenerator; var T: WideString);
begin T := Self.TableName; end;

(*----------------------------------------------------------------------------*)
procedure TDBXCustomDataGeneratorColumnCount_R(Self: TDBXCustomDataGenerator; var T: Integer);
begin T := Self.ColumnCount; end;

(*----------------------------------------------------------------------------*)
Function TDBXCustomDataGeneratorCreateInsertStatement4_P(Self: TDBXCustomDataGenerator;  InsertColumns : TDBXDataGeneratorColumnArray; Row : Integer; Prepare : Boolean) : WideString;
Begin Result := Self.CreateInsertStatement(InsertColumns, Row, Prepare); END;

(*----------------------------------------------------------------------------*)
Function TDBXCustomDataGeneratorCreateParameterizedInsertStatement3_P(Self: TDBXCustomDataGenerator;  InsertColumns : TDBXDataGeneratorColumnArray) : WideString;
Begin Result := Self.CreateParameterizedInsertStatement(InsertColumns); END;

(*----------------------------------------------------------------------------*)
Function TDBXCustomDataGeneratorCreateParameterizedInsertStatement2_P(Self: TDBXCustomDataGenerator) : WideString;
Begin Result := Self.CreateParameterizedInsertStatement; END;

(*----------------------------------------------------------------------------*)
Function TDBXCustomDataGeneratorCreateInsertStatement1_P(Self: TDBXCustomDataGenerator;  InsertColumns : TDBXDataGeneratorColumnArray; Row : Integer) : WideString;
Begin Result := Self.CreateInsertStatement(InsertColumns, Row); END;

(*----------------------------------------------------------------------------*)
Function TDBXCustomDataGeneratorCreateInsertStatement_P(Self: TDBXCustomDataGenerator;  Row : Integer) : WideString;
Begin Result := Self.CreateInsertStatement(Row); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXWideStringSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXWideStringSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXWideStringSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXWideStringSequenceGenerator.Open, 'Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXTimestampSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXTimestampSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXTimestampSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXTimestampSequenceGenerator.Open, 'Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXTimeSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXTimeSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXTimeSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXTimeSequenceGenerator.Open, 'Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXInt8SequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXInt8SequenceGenerator) do
  begin
    RegisterConstructor(@TDBXInt8SequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXInt8SequenceGenerator.Open, 'Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXInt64SequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXInt64SequenceGenerator) do
  begin
    RegisterConstructor(@TDBXInt64SequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXInt64SequenceGenerator.Open, 'Open');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXInt32SequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXInt32SequenceGenerator) do
  begin
    RegisterConstructor(@TDBXInt32SequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXInt32SequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXInt32SequenceGenerator.GetInt32, 'GetInt32');
    RegisterMethod(@TDBXInt32SequenceGenerator.GetString, 'GetString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXInt16SequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXInt16SequenceGenerator) do
  begin
    RegisterConstructor(@TDBXInt16SequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXInt16SequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXInt16SequenceGenerator.GetInt16, 'GetInt16');
    RegisterMethod(@TDBXInt16SequenceGenerator.GetString, 'GetString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXDoubleSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXDoubleSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXDoubleSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXDoubleSequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXDoubleSequenceGenerator.GetDouble, 'GetDouble');
    RegisterMethod(@TDBXDoubleSequenceGenerator.GetString, 'GetString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXDecimalSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXDecimalSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXDecimalSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXDecimalSequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXDecimalSequenceGenerator.GetDecimal, 'GetDecimal');
    RegisterMethod(@TDBXDecimalSequenceGenerator.GetString, 'GetString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXDateSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXDateSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXDateSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXDateSequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXDateSequenceGenerator.GetYear, 'GetYear');
    RegisterMethod(@TDBXDateSequenceGenerator.GetMonth, 'GetMonth');
    RegisterMethod(@TDBXDateSequenceGenerator.GetDay, 'GetDay');
    RegisterMethod(@TDBXDateSequenceGenerator.GetString, 'GetString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXDataGeneratorException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXDataGeneratorException) do
  begin
    RegisterConstructor(@TDBXDataGeneratorException.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXAnsiStringSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXAnsiStringSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXAnsiStringSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXAnsiStringSequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXAnsiStringSequenceGenerator.GetString, 'GetString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXBlobSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXBlobSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXBlobSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXBlobSequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXBlobSequenceGenerator.GetString, 'GetString');
    RegisterMethod(@TDBXBlobSequenceGenerator.GetBytes, 'GetBytes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXBooleanSequenceGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXBooleanSequenceGenerator) do
  begin
    RegisterConstructor(@TDBXBooleanSequenceGenerator.Create, 'Create');
    RegisterMethod(@TDBXBooleanSequenceGenerator.Open, 'Open');
    RegisterMethod(@TDBXBooleanSequenceGenerator.GetBoolean, 'GetBoolean');
    RegisterMethod(@TDBXBooleanSequenceGenerator.GetString, 'GetString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXDataGeneratorColumn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXDataGeneratorColumn) do
  begin
    RegisterConstructor(@TDBXDataGeneratorColumn.Create, 'Create');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.Open, 'Open');
    RegisterVirtualAbstractMethod(@TDBXDataGeneratorColumn, @!.GetString, 'GetString');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetBoolean, 'GetBoolean');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetInt8, 'GetInt8');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetInt16, 'GetInt16');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetInt32, 'GetInt32');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetInt64, 'GetInt64');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetDouble, 'GetDouble');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetSingle, 'GetSingle');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetBytes, 'GetBytes');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetDecimal, 'GetDecimal');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetYear, 'GetYear');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetMonth, 'GetMonth');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetDay, 'GetDay');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetHour, 'GetHour');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetMinute, 'GetMinute');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetSeconds, 'GetSeconds');
    RegisterVirtualMethod(@TDBXDataGeneratorColumn.GetMilliseconds, 'GetMilliseconds');
    RegisterPropertyHelper(nil,@TDBXDataGeneratorColumnDataGenerator_W,'DataGenerator');
    RegisterPropertyHelper(@TDBXDataGeneratorColumnColumnName_R,nil,'ColumnName');
    RegisterPropertyHelper(@TDBXDataGeneratorColumnDataType_R,nil,'DataType');
    RegisterPropertyHelper(@TDBXDataGeneratorColumnMetaDataColumn_R,nil,'MetaDataColumn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXCustomDataGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXCustomDataGenerator) do
  begin
    RegisterVirtualMethod(@TDBXCustomDataGenerator.AddColumn, 'AddColumn');
    RegisterVirtualMethod(@TDBXCustomDataGenerator.GetColumn, 'GetColumn');
    RegisterVirtualMethod(@TDBXCustomDataGenerator.Open, 'Open');
    RegisterVirtualMethod(@TDBXCustomDataGeneratorCreateInsertStatement_P, 'CreateInsertStatement');
    RegisterVirtualMethod(@TDBXCustomDataGeneratorCreateInsertStatement1_P, 'CreateInsertStatement1');
    RegisterVirtualMethod(@TDBXCustomDataGeneratorCreateParameterizedInsertStatement2_P, 'CreateParameterizedInsertStatement2');
    RegisterVirtualMethod(@TDBXCustomDataGeneratorCreateParameterizedInsertStatement3_P, 'CreateParameterizedInsertStatement3');
    RegisterVirtualMethod(@TDBXCustomDataGenerator.Next, 'Next');
    RegisterPropertyHelper(@TDBXCustomDataGeneratorColumnCount_R,nil,'ColumnCount');
    RegisterPropertyHelper(@TDBXCustomDataGeneratorTableName_R,@TDBXCustomDataGeneratorTableName_W,'TableName');
    RegisterPropertyHelper(@TDBXCustomDataGeneratorMetaDataProvider_R,@TDBXCustomDataGeneratorMetaDataProvider_W,'MetaDataProvider');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBXCustomDataGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXDataGeneratorColumn) do
  with CL.Add(TDBXDataGeneratorException) do
  RIRegister_TDBXCustomDataGenerator(CL);
  RIRegister_TDBXDataGeneratorColumn(CL);
  RIRegister_TDBXBooleanSequenceGenerator(CL);
  RIRegister_TDBXBlobSequenceGenerator(CL);
  RIRegister_TDBXAnsiStringSequenceGenerator(CL);
  RIRegister_TDBXDataGeneratorException(CL);
  RIRegister_TDBXDateSequenceGenerator(CL);
  RIRegister_TDBXDecimalSequenceGenerator(CL);
  RIRegister_TDBXDoubleSequenceGenerator(CL);
  RIRegister_TDBXInt16SequenceGenerator(CL);
  RIRegister_TDBXInt32SequenceGenerator(CL);
  RIRegister_TDBXInt64SequenceGenerator(CL);
  RIRegister_TDBXInt8SequenceGenerator(CL);
  RIRegister_TDBXTimeSequenceGenerator(CL);
  RIRegister_TDBXTimestampSequenceGenerator(CL);
  RIRegister_TDBXWideStringSequenceGenerator(CL);
end;

 
 
{ TPSImport_DBXCustomDataGenerator }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXCustomDataGenerator.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBXCustomDataGenerator(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXCustomDataGenerator.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBXCustomDataGenerator(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
