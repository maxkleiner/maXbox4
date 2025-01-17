unit uPSI_JvDBUtils;
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
  TPSImport_JvDBUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvLocateObject(CL: TPSPascalCompiler);
procedure SIRegister_JvDBUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvDBUtils_Routines(S: TPSExec);
procedure RIRegister_TJvLocateObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Registry
  ,DB
  ,IniFiles
  ,JvDBUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLocateObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvLocateObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvLocateObject') do
  begin
    RegisterMethod('Function Locate( const KeyField, KeyValue : string; Exact, CaseSensitive : Boolean) : Boolean');
    RegisterProperty('DataSet', 'TDataSet', iptrw);
    RegisterProperty('IndexSwitch', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBUtils(CL: TPSPascalCompiler);
begin
  SIRegister_TJvLocateObject(CL);
 CL.AddDelphiFunction('Function CreateLocate( DataSet : TDataSet) : TJvLocateObject');
 CL.AddDelphiFunction('Function IsDataSetEmpty( DataSet : TDataSet) : Boolean');
 CL.AddDelphiFunction('Procedure RefreshQuery( Query : TDataSet)');
 CL.AddDelphiFunction('Function DataSetSortedSearch( DataSet : TDataSet; const Value, FieldName : string; CaseInsensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function DataSetSectionName( DataSet : TDataSet) : string');
 CL.AddDelphiFunction('Procedure InternalSaveFields( DataSet : TDataSet; IniFile : TObject; const Section : string)');
 CL.AddDelphiFunction('Procedure InternalRestoreFields( DataSet : TDataSet; IniFile : TObject; const Section : string; RestoreVisible : Boolean)');
 CL.AddDelphiFunction('Function DataSetLocateThrough( DataSet : TDataSet; const KeyFields : string; const KeyValues : Variant; Options : TLocateOptions) : Boolean');
 //CL.AddDelphiFunction('Procedure SaveFieldsReg( DataSet : TDataSet; IniFile : TRegIniFile)');
 //CL.AddDelphiFunction('Procedure RestoreFieldsReg( DataSet : TDataSet; IniFile : TRegIniFile; RestoreVisible : Boolean)');
 CL.AddDelphiFunction('Procedure SaveFields( DataSet : TDataSet; IniFile : TIniFile)');
 CL.AddDelphiFunction('Procedure RestoreFields( DataSet : TDataSet; IniFile : TIniFile; RestoreVisible : Boolean)');
 CL.AddDelphiFunction('Procedure AssignRecord( Source, Dest : TDataSet; ByName : Boolean)');
 CL.AddDelphiFunction('Function ConfirmDelete : Boolean');
 CL.AddDelphiFunction('Procedure ConfirmDataSetCancel( DataSet : TDataSet)');
 CL.AddDelphiFunction('Procedure CheckRequiredField( Field : TField)');
 CL.AddDelphiFunction('Procedure CheckRequiredFields( const Fields : array of TField)');
 CL.AddDelphiFunction('Function DateToSQL( Value : TDateTime) : string');
 CL.AddDelphiFunction('Function FormatSQLDateRange( Date1, Date2 : TDateTime; const FieldName : string) : string');
 CL.AddDelphiFunction('Function FormatSQLDateRangeEx( Date1, Date2 : TDateTime; const FieldName : string) : string');
 CL.AddDelphiFunction('Function FormatSQLNumericRange( const FieldName : string; LowValue, HighValue, LowEmpty, HighEmpty : Double; Inclusive : Boolean) : string');
 CL.AddDelphiFunction('Function StrMaskSQL( const Value : string) : string');
 CL.AddDelphiFunction('Function FormatSQLCondition( const FieldName, Operator, Value : string; FieldType : TFieldType; Exact : Boolean) : string');
 CL.AddDelphiFunction('Function FormatAnsiSQLCondition( const FieldName, Operator, Value : string; FieldType : TFieldType; Exact : Boolean) : string');
 CL.AddConstantN('TrueExpr','String').SetString( '0=0');
 CL.AddConstantN('sdfStandard16','String').SetString( '''"''mm''/''dd''/''yyyy''"''');
 CL.AddConstantN('sdfStandard32','String').SetString( '''''''dd/mm/yyyy''''''');
 CL.AddConstantN('sdfOracle','String').SetString( '"TO_DATE(''"dd/mm/yyyy"'', ''DD/MM/YYYY'')"');
 CL.AddConstantN('sdfInterbase','String').SetString( '"CAST(''"mm"/"dd"/"yyyy"'' AS DATE)"');
 CL.AddConstantN('sdfMSSQL','String').SetString( '"CONVERT(datetime, ''"mm"/"dd"/"yyyy"'', 103)"');
  CL.AddTypeS('Largeint', 'Longint');
 CL.AddDelphiFunction('Procedure _DBError( const Msg : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvLocateObjectIndexSwitch_W(Self: TJvLocateObject; const T: Boolean);
begin Self.IndexSwitch := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLocateObjectIndexSwitch_R(Self: TJvLocateObject; var T: Boolean);
begin T := Self.IndexSwitch; end;

(*----------------------------------------------------------------------------*)
procedure TJvLocateObjectDataSet_W(Self: TJvLocateObject; const T: TDataSet);
begin Self.DataSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLocateObjectDataSet_R(Self: TJvLocateObject; var T: TDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateLocate, 'CreateLocate', cdRegister);
 S.RegisterDelphiFunction(@IsDataSetEmpty, 'IsDataSetEmpty', cdRegister);
 S.RegisterDelphiFunction(@RefreshQuery, 'RefreshQuery', cdRegister);
 S.RegisterDelphiFunction(@DataSetSortedSearch, 'DataSetSortedSearch', cdRegister);
 S.RegisterDelphiFunction(@DataSetSectionName, 'DataSetSectionName', cdRegister);
 S.RegisterDelphiFunction(@InternalSaveFields, 'InternalSaveFields', cdRegister);
 S.RegisterDelphiFunction(@InternalRestoreFields, 'InternalRestoreFields', cdRegister);
 S.RegisterDelphiFunction(@DataSetLocateThrough, 'DataSetLocateThrough', cdRegister);
 S.RegisterDelphiFunction(@SaveFieldsReg, 'SaveFieldsReg', cdRegister);
 S.RegisterDelphiFunction(@RestoreFieldsReg, 'RestoreFieldsReg', cdRegister);
 S.RegisterDelphiFunction(@SaveFields, 'SaveFields', cdRegister);
 S.RegisterDelphiFunction(@RestoreFields, 'RestoreFields', cdRegister);
 S.RegisterDelphiFunction(@AssignRecord, 'AssignRecord', cdRegister);
 S.RegisterDelphiFunction(@ConfirmDelete, 'ConfirmDelete', cdRegister);
 S.RegisterDelphiFunction(@ConfirmDataSetCancel, 'ConfirmDataSetCancel', cdRegister);
 S.RegisterDelphiFunction(@CheckRequiredField, 'CheckRequiredField', cdRegister);
 S.RegisterDelphiFunction(@CheckRequiredFields, 'CheckRequiredFields', cdRegister);
 S.RegisterDelphiFunction(@DateToSQL, 'DateToSQL', cdRegister);
 S.RegisterDelphiFunction(@FormatSQLDateRange, 'FormatSQLDateRange', cdRegister);
 S.RegisterDelphiFunction(@FormatSQLDateRangeEx, 'FormatSQLDateRangeEx', cdRegister);
 S.RegisterDelphiFunction(@FormatSQLNumericRange, 'FormatSQLNumericRange', cdRegister);
 S.RegisterDelphiFunction(@StrMaskSQL, 'StrMaskSQL', cdRegister);
 S.RegisterDelphiFunction(@FormatSQLCondition, 'FormatSQLCondition', cdRegister);
 S.RegisterDelphiFunction(@FormatAnsiSQLCondition, 'FormatAnsiSQLCondition', cdRegister);
 S.RegisterDelphiFunction(@_DBError, '_DBError', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLocateObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLocateObject) do
  begin
    RegisterMethod(@TJvLocateObject.Locate, 'Locate');
    RegisterPropertyHelper(@TJvLocateObjectDataSet_R,@TJvLocateObjectDataSet_W,'DataSet');
    RegisterPropertyHelper(@TJvLocateObjectIndexSwitch_R,@TJvLocateObjectIndexSwitch_W,'IndexSwitch');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvLocateObject(CL);
end;

 
 
{ TPSImport_JvDBUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBUtils(ri);
  RIRegister_JvDBUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
