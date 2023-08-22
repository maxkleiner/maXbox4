unit uPSI_BetterADODataSet;
{
   ADO and MDAC  and connString update BLOB
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
  TPSImport_BetterADODataSet = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBetterADODataSet(CL: TPSPascalCompiler);
procedure SIRegister_TADOVersion(CL: TPSPascalCompiler);
procedure SIRegister_BetterADODataSet(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BetterADODataSet_Routines(S: TPSExec);
procedure RIRegister_TBetterADODataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TADOVersion(CL: TPSRuntimeClassImporter);
procedure RIRegister_BetterADODataSet(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ADOInt
  ,ADODB
  ,ADO26_TLB
  ,DB, OLEDB, ComObj, ActiveX, Forms, StdCtrls, Controls, Dialogs
  ,BetterADODataSet
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BetterADODataSet]);
end;

function ADOConnectionString(ParentHandle: THandle; InitialString: WideString;
  out NewString: string): Boolean;
var
  DataInit: IDataInitialize;
  DBPrompt: IDBPromptInitialize;
  DataSource: IUnknown;
  InitStr: PWideChar;
begin
  Result   := False;
  DataInit := CreateComObject(CLSID_DataLinks) as IDataInitialize;
  if InitialString <> '' then
    DataInit.GetDataSource(nil, CLSCTX_INPROC_SERVER, PWideChar(InitialString),
      IUnknown, DataSource);
  DBPrompt := CreateComObject(CLSID_DataLinks) as IDBPromptInitialize;
  if Succeeded(DBPrompt.PromptDataSource(nil, ParentHandle,
    DBPROMPTOPTIONS_PROPERTYSHEET, 0, nil, nil, IUnknown, DataSource)) then 
  begin
    InitStr := nil;
    DataInit.GetInitializationString(DataSource, True, InitStr);
    NewString := InitStr;
    Result    := True;
  end;
end;


procedure ShowEOleException(AExc: EOleException; Query: String);
var
  ErrShowFrm: TForm;
  Memo: TMemo;
begin
  ErrShowFrm := TForm.Create(nil);
  ErrShowFrm.Position := poScreenCenter;
  ErrShowFrm.Width := 640;
  ErrShowFrm.Height := 480;
  Memo := TMemo.Create(ErrShowFrm);
  Memo.Parent := ErrShowFrm;
  Memo.Align := alClient; //ErrShowFrm.Align;

  Memo.Lines.Clear;
 if assigned(AExc) then begin
   Memo.Lines.Add('Message: ' + AExc.Message);
   Memo.Lines.Add('   Source: ' + AExc.Source);
   Memo.Lines.Add('   ClassName: ' + AExc.ClassName);
   Memo.Lines.Add('   Error Code: ' + IntToStr(AExc.ErrorCode));
  end;
  Memo.Lines.Add('   Query: ' + Query);

  ErrShowFrm.ShowModal;
  Memo.Free;
  ErrShowFrm.Free;
end;


function UpdateBlob(Connection: TADOConnection; Spalte: String; Tabelle: String; Where: String; var ms: TMemoryStream): Boolean;
var
  BlobField: TBlobField;
  Table: TADOTable;
begin
  result := True;
  try
    ms.Seek(0, soFromBeginning);
    Table := TADOTable.Create(nil);
    Table.Connection := Connection;
    Table.TableName := Tabelle;
    Table.Filtered := False;
    // Set Filter like SQL-Command '... WHERE id=1'
    Table.Filter := Where;
    Table.Filtered := True;
    Table.Open;
    Table.First;

    if not Table.FieldByName(Spalte).IsBlob then
     Raise EOleException.Create('The field ' + Spalte + ' is not a blob-field.', S_FALSE, 'ITSQL.UpdateBlob', '', 0);

    BlobField := TBlobField(Table.FieldByName(Spalte));
    Table.Edit;
    BlobField.LoadFromStream(ms);
    Table.Post;
    Table.Free;
  except
    on E: EOleException do
    begin
      ShowEOleException(E, 'UPDATE BLOB FROM: SELECT ' + Spalte + ' FROM ' + Tabelle + ' WHERE ' + Where);
      result := False;
    end;
  end;
end;


function SaveToMHT(const AUrl, AFileName: string; AShowErrorMessage: Boolean = False): Boolean;
var
  oMSG, oConfig: OleVariant;
  sFileName: string;
  Retvar: Boolean;
begin
  sFileName := ChangeFileExt(AFileName, '.mht');
  DeleteFile(PAnsiChar(sFileName));
  try
    oConfig := CreateOleObject('CDO.Configuration');
    oMSG    := CreateOleObject('CDO.Message');
    oMSG.Configuration := oConfig;
    oMSG.CreateMHTMLBody(AUrl);
    oMSG.GetStream.SaveToFile(sFileName);
    Retvar := True;
  except
    on E: Exception do
    begin
      if AShowErrorMessage then MessageDlg(E.Message, mtError, [mbOK], 0);
      Retvar := False;
    end;
  end;
  oMSG    := VarNull;
  oConfig := VarNull;
  Result  := Retvar;
end;


function IsCOMObjectActive(ClassName: string): Boolean;
var
  ClassID: TCLSID;
  Unknown: IUnknown;
begin
  try
    ClassID := ProgIDToClassID(ClassName);
    Result  := GetActiveObject(ClassID, nil, Unknown) = S_OK;
  except
    // raise;
    Result := False;
  end;
end;




(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBetterADODataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TADODataSet', 'TBetterADODataSet') do
  with CL.AddClassN(CL.FindClass('TADODataSet'),'TBetterADODataSet') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Requery( Options : TExecuteOptions);');
    RegisterMethod('Procedure Requery1;');
    RegisterMethod('Procedure Resync( AffectRecords : AffectEnum; ResyncValues : ResyncEnum);');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure DeleteRecords( AffectRecords : TAffectRecords)');
    RegisterMethod('Procedure CancelBatch( AffectRecords : TAffectRecords)');
    RegisterMethod('Function GetCanModify : Boolean');
    RegisterMethod('Function Locate( const KeyFields : String; const KeyValues : Variant; Options : TLocateOptions) : Boolean');
    RegisterMethod('Function Lookup( const KeyFields : String; const KeyValues : Variant; const ResultFields : String) : Variant');
    RegisterMethod('Procedure GetDetailLinkFields( MasterFields, DetailFields : TList)');
    RegisterMethod('Procedure ClearCalcFields( Buffer : TRecordBuffer)');
    RegisterMethod('Function GetFieldData( Field : TField; Buffer : Pointer; NativeFormat : Boolean) : Boolean');
    RegisterMethod('Procedure SaveToADOStream( Destination : OleVariant; PersistFormat : TPersistFormat)');
    RegisterMethod('Procedure LoadFromADOStream( Source : ADO26_TLB_Stream)');
    RegisterMethod('Function GetString( NumRows : Integer; StartPos : TStartPos; const ColumnDelimeter : WideString; const RowDelimeter : WideString; const NullExpr : WideString) : WideString');
    RegisterProperty('FieldStatus', 'FieldStatusEnum WideString', iptr);
    RegisterProperty('ParamByName', 'TParameter WideString', iptr);
    RegisterProperty('StateBeforePost', 'TDataSetState', iptr);
    RegisterProperty('Update_Criteria', 'TUpdateCriteria', iptrw);
    RegisterProperty('Unique_Catalog', 'String', iptrw);
    RegisterProperty('Unique_Schema', 'String', iptrw);
    RegisterProperty('Unique_Table', 'String', iptrw);
    RegisterProperty('Update_Resync', 'TUpdateResync', iptrw);
    RegisterProperty('Resync_Command', 'TStringList', iptrw);
    RegisterProperty('RefreshType', 'TRefreshType', iptrw);
    RegisterProperty('JoinsResolution', 'TJoinsResolution', iptrw);
    RegisterProperty('JoinTest', 'TJoinTest', iptrw);
    RegisterProperty('DeleteGuardian', 'Boolean', iptrw);
    RegisterProperty('NamedParams', 'Boolean', iptrw);
    RegisterProperty('Version', 'TADOVersion', iptrw);
    RegisterProperty('AutoCalcClear', 'Boolean', iptrw);
    RegisterProperty('InitialFetchSize', 'Integer', iptrw);
    RegisterProperty('BackgroundFetchSize', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TADOVersion(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TADOVersion') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TADOVersion') do begin
    RegisterMethod('Constructor Create( AOwner : TBetterADODataSet)');
     RegisterMethod('Procedure Free');
     RegisterProperty('BetterADSVersion', 'String', iptrw);
    RegisterProperty('ADOVersion', 'String', iptrw);
    RegisterProperty('OLEDBVersion', 'String', iptrw);
    RegisterProperty('ProviderName', 'String', iptrw);
    RegisterProperty('ProviderVersion', 'String', iptrw);
    RegisterProperty('DBMSName', 'String', iptrw);
    RegisterProperty('DBMSVersion', 'String', iptrw);
    RegisterProperty('ODBCVersion', 'String', iptrw);
    RegisterProperty('ODBCDriverName', 'String', iptrw);
    RegisterProperty('ODBCDriverVersion', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BetterADODataSet(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('BetterADODataSetVersion','String').SetString( '4.04');
  CL.AddTypeS('TUpdateCriteria','(adCriteriaKey, adCriteriaAllCols, adCriteriaUpdCols, adCriteriaTimeStamp )');
  CL.AddTypeS('TUpdateResyncEnum', '(ResyncAutoIncrement, ResyncConflicts, ResyncUpdates, ResyncInserts )');
  CL.AddTypeS('TUpdateResync', 'set of TUpdateResyncEnum');
  CL.AddTypeS('TRefreshType', '( rtRequery, rtResyncCurrent, rtResyncGroup, rtResyncAll, rtResyncChapters )');
  CL.AddTypeS('TJoinsResolution', '( jrAuto, jrManual, jrNone )');
  CL.AddTypeS('TJoinTest', '( jtInactive, jtNotJoined, jtJoined )');
  CL.AddTypeS('TStartPos', '( spFirstRecord, spCurrentRecord )');
 // CL.AddTypeS('TRecordBuffer', '(PChar)');

  CL.AddClassN(CL.FindClass('TOBJECT'),'TBetterADODataSet');

  CL.AddClassN(CL.FindClass('EOleError'),'EOleException');

  SIRegister_TADOVersion(CL);
  SIRegister_TBetterADODataSet(CL);
 //CL.AddDelphiFunction('Procedure Register');
 CL.AddDelphiFunction('function ADOConnectionString(ParentHandle: THandle; InitialString: WideString; out NewString: string): Boolean;');
 CL.AddDelphiFunction('procedure ShowEOleException(AExc: EOleException; Query: String);');
 CL.AddDelphiFunction('function UpdateBlob(Connection: TADOConnection; Spalte: String; Tabelle: String; Where: String; var ms: TMemoryStream): Boolean;');
 CL.AddDelphiFunction('function SaveToMHT(const AUrl, AFileName: string; AShowErrorMessage: Boolean): Boolean;');
 CL.AddDelphiFunction('function IsCOMObjectActive(ClassName: string): Boolean;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetBackgroundFetchSize_W(Self: TBetterADODataSet; const T: Integer);
begin Self.BackgroundFetchSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetBackgroundFetchSize_R(Self: TBetterADODataSet; var T: Integer);
begin T := Self.BackgroundFetchSize; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetInitialFetchSize_W(Self: TBetterADODataSet; const T: Integer);
begin Self.InitialFetchSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetInitialFetchSize_R(Self: TBetterADODataSet; var T: Integer);
begin T := Self.InitialFetchSize; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetAutoCalcClear_W(Self: TBetterADODataSet; const T: Boolean);
begin Self.AutoCalcClear := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetAutoCalcClear_R(Self: TBetterADODataSet; var T: Boolean);
begin T := Self.AutoCalcClear; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetVersion_W(Self: TBetterADODataSet; const T: TADOVersion);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetVersion_R(Self: TBetterADODataSet; var T: TADOVersion);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetNamedParams_W(Self: TBetterADODataSet; const T: Boolean);
begin Self.NamedParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetNamedParams_R(Self: TBetterADODataSet; var T: Boolean);
begin T := Self.NamedParams; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetDeleteGuardian_W(Self: TBetterADODataSet; const T: Boolean);
begin Self.DeleteGuardian := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetDeleteGuardian_R(Self: TBetterADODataSet; var T: Boolean);
begin T := Self.DeleteGuardian; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetJoinTest_W(Self: TBetterADODataSet; const T: TJoinTest);
begin Self.JoinTest := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetJoinTest_R(Self: TBetterADODataSet; var T: TJoinTest);
begin T := Self.JoinTest; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetJoinsResolution_W(Self: TBetterADODataSet; const T: TJoinsResolution);
begin Self.JoinsResolution := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetJoinsResolution_R(Self: TBetterADODataSet; var T: TJoinsResolution);
begin T := Self.JoinsResolution; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetRefreshType_W(Self: TBetterADODataSet; const T: TRefreshType);
begin Self.RefreshType := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetRefreshType_R(Self: TBetterADODataSet; var T: TRefreshType);
begin T := Self.RefreshType; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetResync_Command_W(Self: TBetterADODataSet; const T: TStringList);
begin Self.Resync_Command := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetResync_Command_R(Self: TBetterADODataSet; var T: TStringList);
begin T := Self.Resync_Command; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUpdate_Resync_W(Self: TBetterADODataSet; const T: TUpdateResync);
begin Self.Update_Resync := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUpdate_Resync_R(Self: TBetterADODataSet; var T: TUpdateResync);
begin T := Self.Update_Resync; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUnique_Table_W(Self: TBetterADODataSet; const T: String);
begin Self.Unique_Table := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUnique_Table_R(Self: TBetterADODataSet; var T: String);
begin T := Self.Unique_Table; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUnique_Schema_W(Self: TBetterADODataSet; const T: String);
begin Self.Unique_Schema := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUnique_Schema_R(Self: TBetterADODataSet; var T: String);
begin T := Self.Unique_Schema; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUnique_Catalog_W(Self: TBetterADODataSet; const T: String);
begin Self.Unique_Catalog := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUnique_Catalog_R(Self: TBetterADODataSet; var T: String);
begin T := Self.Unique_Catalog; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUpdate_Criteria_W(Self: TBetterADODataSet; const T: TUpdateCriteria);
begin Self.Update_Criteria := T; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetUpdate_Criteria_R(Self: TBetterADODataSet; var T: TUpdateCriteria);
begin T := Self.Update_Criteria; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetStateBeforePost_R(Self: TBetterADODataSet; var T: TDataSetState);
begin T := Self.StateBeforePost; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetParamByName_R(Self: TBetterADODataSet; var T: TParameter; const t1: WideString);
begin T := Self.ParamByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBetterADODataSetFieldStatus_R(Self: TBetterADODataSet; var T: FieldStatusEnum; const t1: WideString);
begin T := Self.FieldStatus[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TBetterADODataSetResync_P(Self: TBetterADODataSet;  AffectRecords : AffectEnum; ResyncValues : ResyncEnum);
Begin Self.Resync(AffectRecords, ResyncValues); END;

(*----------------------------------------------------------------------------*)
Procedure TBetterADODataSetRequery1_P(Self: TBetterADODataSet);
Begin Self.Requery; END;

(*----------------------------------------------------------------------------*)
Procedure TBetterADODataSetRequery_P(Self: TBetterADODataSet;  Options : TExecuteOptions);
Begin Self.Requery(Options); END;

(*----------------------------------------------------------------------------*)
procedure TADOVersionODBCDriverVersion_W(Self: TADOVersion; const T: String);
begin Self.ODBCDriverVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionODBCDriverVersion_R(Self: TADOVersion; var T: String);
begin T := Self.ODBCDriverVersion; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionODBCDriverName_W(Self: TADOVersion; const T: String);
begin Self.ODBCDriverName := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionODBCDriverName_R(Self: TADOVersion; var T: String);
begin T := Self.ODBCDriverName; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionODBCVersion_W(Self: TADOVersion; const T: String);
begin Self.ODBCVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionODBCVersion_R(Self: TADOVersion; var T: String);
begin T := Self.ODBCVersion; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionDBMSVersion_W(Self: TADOVersion; const T: String);
begin Self.DBMSVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionDBMSVersion_R(Self: TADOVersion; var T: String);
begin T := Self.DBMSVersion; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionDBMSName_W(Self: TADOVersion; const T: String);
begin Self.DBMSName := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionDBMSName_R(Self: TADOVersion; var T: String);
begin T := Self.DBMSName; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionProviderVersion_W(Self: TADOVersion; const T: String);
begin Self.ProviderVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionProviderVersion_R(Self: TADOVersion; var T: String);
begin T := Self.ProviderVersion; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionProviderName_W(Self: TADOVersion; const T: String);
begin Self.ProviderName := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionProviderName_R(Self: TADOVersion; var T: String);
begin T := Self.ProviderName; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionOLEDBVersion_W(Self: TADOVersion; const T: String);
begin Self.OLEDBVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionOLEDBVersion_R(Self: TADOVersion; var T: String);
begin T := Self.OLEDBVersion; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionADOVersion_W(Self: TADOVersion; const T: String);
begin Self.ADOVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionADOVersion_R(Self: TADOVersion; var T: String);
begin T := Self.ADOVersion; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionBetterADSVersion_W(Self: TADOVersion; const T: String);
begin Self.BetterADSVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TADOVersionBetterADSVersion_R(Self: TADOVersion; var T: String);
begin T := Self.BetterADSVersion; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BetterADODataSet_Routines(S: TPSExec);
begin
// S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
 S.RegisterDelphiFunction(@ADOConnectionString, 'ADOConnectionString', cdRegister);
 S.RegisterDelphiFunction(@ShowEOleException, 'ShowEOleException', cdRegister);
 S.RegisterDelphiFunction(@UpdateBlob, 'UpdateBlob', cdRegister);
 S.RegisterDelphiFunction(@SaveToMHT, 'SaveToMHT', cdRegister);
 S.RegisterDelphiFunction(@IsCOMObjectActive, 'IsCOMObjectActive', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBetterADODataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBetterADODataSet) do begin
    RegisterConstructor(@TBetterADODataSet.Create, 'Create');
    RegisterMethod(@TBetterADODataSet.Destroy, 'Free');
    RegisterMethod(@TBetterADODataSetRequery_P, 'Requery');
    RegisterMethod(@TBetterADODataSetRequery1_P, 'Requery1');
    RegisterMethod(@TBetterADODataSetResync_P, 'Resync');
    RegisterMethod(@TBetterADODataSet.Refresh, 'Refresh');
    RegisterMethod(@TBetterADODataSet.DeleteRecords, 'DeleteRecords');
    RegisterMethod(@TBetterADODataSet.CancelBatch, 'CancelBatch');
    RegisterMethod(@TBetterADODataSet.GetCanModify, 'GetCanModify');
    RegisterMethod(@TBetterADODataSet.Locate, 'Locate');
    RegisterMethod(@TBetterADODataSet.Lookup, 'Lookup');
    RegisterMethod(@TBetterADODataSet.GetDetailLinkFields, 'GetDetailLinkFields');
    RegisterMethod(@TBetterADODataSet.ClearCalcFields, 'ClearCalcFields');
    RegisterMethod(@TBetterADODataSet.GetFieldData, 'GetFieldData');
    RegisterMethod(@TBetterADODataSet.SaveToADOStream, 'SaveToADOStream');
    RegisterMethod(@TBetterADODataSet.LoadFromADOStream, 'LoadFromADOStream');
    RegisterMethod(@TBetterADODataSet.GetString, 'GetString');
    RegisterPropertyHelper(@TBetterADODataSetFieldStatus_R,nil,'FieldStatus');
    RegisterPropertyHelper(@TBetterADODataSetParamByName_R,nil,'ParamByName');
    RegisterPropertyHelper(@TBetterADODataSetStateBeforePost_R,nil,'StateBeforePost');
    RegisterPropertyHelper(@TBetterADODataSetUpdate_Criteria_R,@TBetterADODataSetUpdate_Criteria_W,'Update_Criteria');
    RegisterPropertyHelper(@TBetterADODataSetUnique_Catalog_R,@TBetterADODataSetUnique_Catalog_W,'Unique_Catalog');
    RegisterPropertyHelper(@TBetterADODataSetUnique_Schema_R,@TBetterADODataSetUnique_Schema_W,'Unique_Schema');
    RegisterPropertyHelper(@TBetterADODataSetUnique_Table_R,@TBetterADODataSetUnique_Table_W,'Unique_Table');
    RegisterPropertyHelper(@TBetterADODataSetUpdate_Resync_R,@TBetterADODataSetUpdate_Resync_W,'Update_Resync');
    RegisterPropertyHelper(@TBetterADODataSetResync_Command_R,@TBetterADODataSetResync_Command_W,'Resync_Command');
    RegisterPropertyHelper(@TBetterADODataSetRefreshType_R,@TBetterADODataSetRefreshType_W,'RefreshType');
    RegisterPropertyHelper(@TBetterADODataSetJoinsResolution_R,@TBetterADODataSetJoinsResolution_W,'JoinsResolution');
    RegisterPropertyHelper(@TBetterADODataSetJoinTest_R,@TBetterADODataSetJoinTest_W,'JoinTest');
    RegisterPropertyHelper(@TBetterADODataSetDeleteGuardian_R,@TBetterADODataSetDeleteGuardian_W,'DeleteGuardian');
    RegisterPropertyHelper(@TBetterADODataSetNamedParams_R,@TBetterADODataSetNamedParams_W,'NamedParams');
    RegisterPropertyHelper(@TBetterADODataSetVersion_R,@TBetterADODataSetVersion_W,'Version');
    RegisterPropertyHelper(@TBetterADODataSetAutoCalcClear_R,@TBetterADODataSetAutoCalcClear_W,'AutoCalcClear');
    RegisterPropertyHelper(@TBetterADODataSetInitialFetchSize_R,@TBetterADODataSetInitialFetchSize_W,'InitialFetchSize');
    RegisterPropertyHelper(@TBetterADODataSetBackgroundFetchSize_R,@TBetterADODataSetBackgroundFetchSize_W,'BackgroundFetchSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TADOVersion(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TADOVersion) do begin
    RegisterVirtualConstructor(@TADOVersion.Create, 'Create');
      RegisterMethod(@TADOVersion.Destroy, 'Free');
    RegisterPropertyHelper(@TADOVersionBetterADSVersion_R,@TADOVersionBetterADSVersion_W,'BetterADSVersion');
    RegisterPropertyHelper(@TADOVersionADOVersion_R,@TADOVersionADOVersion_W,'ADOVersion');
    RegisterPropertyHelper(@TADOVersionOLEDBVersion_R,@TADOVersionOLEDBVersion_W,'OLEDBVersion');
    RegisterPropertyHelper(@TADOVersionProviderName_R,@TADOVersionProviderName_W,'ProviderName');
    RegisterPropertyHelper(@TADOVersionProviderVersion_R,@TADOVersionProviderVersion_W,'ProviderVersion');
    RegisterPropertyHelper(@TADOVersionDBMSName_R,@TADOVersionDBMSName_W,'DBMSName');
    RegisterPropertyHelper(@TADOVersionDBMSVersion_R,@TADOVersionDBMSVersion_W,'DBMSVersion');
    RegisterPropertyHelper(@TADOVersionODBCVersion_R,@TADOVersionODBCVersion_W,'ODBCVersion');
    RegisterPropertyHelper(@TADOVersionODBCDriverName_R,@TADOVersionODBCDriverName_W,'ODBCDriverName');
    RegisterPropertyHelper(@TADOVersionODBCDriverVersion_R,@TADOVersionODBCDriverVersion_W,'ODBCDriverVersion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BetterADODataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBetterADODataSet) do
  RIRegister_TADOVersion(CL);
  RIRegister_TBetterADODataSet(CL);
end;



{ TPSImport_BetterADODataSet }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BetterADODataSet.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BetterADODataSet(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BetterADODataSet.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BetterADODataSet(ri);
  RIRegister_BetterADODataSet_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
