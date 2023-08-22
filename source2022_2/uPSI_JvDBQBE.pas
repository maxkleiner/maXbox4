unit uPSI_JvDBQBE;
{
   byexample
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
  TPSImport_JvDBQBE = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvQBEQuery(CL: TPSPascalCompiler);
procedure SIRegister_JvDBQBE(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvQBEQuery(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBQBE(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Bde
  ,WinTypes
  ,WinProcs
  ,DbiErrs
  ,DbiTypes
  ,DbiProcs
  ,DB
  ,DBTables
  ,JvDBQBE
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBQBE]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvQBEQuery(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBDataSet', 'TJvQBEQuery') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TJvQBEQuery') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetQBEText : PChar');
    RegisterMethod('Procedure ExecQBE');
    RegisterMethod('Function ParamByName( const Value : string) : TParam');
    RegisterMethod('Procedure Prepare');
    RegisterMethod('Procedure RefreshQuery');
    RegisterMethod('Procedure UnPrepare');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterProperty('Local', 'Boolean', iptr);
    RegisterProperty('ParamCount', 'Word', iptr);
    RegisterProperty('Prepared', 'Boolean', iptrw);
    RegisterProperty('StmtHandle', 'HDBIStmt', iptr);
    RegisterProperty('Text', 'string', iptr);
    RegisterProperty('RowsAffected', 'Integer', iptr);
    RegisterProperty('Text', 'PChar', iptr);
    RegisterProperty('AuxiliaryTables', 'Boolean', iptrw);
    RegisterProperty('ParamCheck', 'Boolean', iptrw);
    RegisterProperty('StartParam', 'Char', iptrw);
    RegisterProperty('QBE', 'TStrings', iptrw);
    RegisterProperty('BlankAsZero', 'Boolean', iptrw);
    RegisterProperty('Params', 'TParams', iptrw);
    RegisterProperty('RequestLive', 'Boolean', iptrw);
    RegisterProperty('Constrained', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBQBE(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DefQBEStartParam','String').SetString( '#');
  CL.AddTypeS('TCheckType', '( ctNone, ctCheck, ctCheckPlus, ctCheckDesc, ctChe'
   +'ckGroup )');
  SIRegister_TJvQBEQuery(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryConstrained_W(Self: TJvQBEQuery; const T: Boolean);
begin Self.Constrained := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryConstrained_R(Self: TJvQBEQuery; var T: Boolean);
begin T := Self.Constrained; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryRequestLive_W(Self: TJvQBEQuery; const T: Boolean);
begin Self.RequestLive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryRequestLive_R(Self: TJvQBEQuery; var T: Boolean);
begin T := Self.RequestLive; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryParams_W(Self: TJvQBEQuery; const T: TParams);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryParams_R(Self: TJvQBEQuery; var T: TParams);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryBlankAsZero_W(Self: TJvQBEQuery; const T: Boolean);
begin Self.BlankAsZero := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryBlankAsZero_R(Self: TJvQBEQuery; var T: Boolean);
begin T := Self.BlankAsZero; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryQBE_W(Self: TJvQBEQuery; const T: TStrings);
begin Self.QBE := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryQBE_R(Self: TJvQBEQuery; var T: TStrings);
begin T := Self.QBE; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryStartParam_W(Self: TJvQBEQuery; const T: Char);
begin Self.StartParam := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryStartParam_R(Self: TJvQBEQuery; var T: Char);
begin T := Self.StartParam; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryParamCheck_W(Self: TJvQBEQuery; const T: Boolean);
begin Self.ParamCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryParamCheck_R(Self: TJvQBEQuery; var T: Boolean);
begin T := Self.ParamCheck; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryAuxiliaryTables_W(Self: TJvQBEQuery; const T: Boolean);
begin Self.AuxiliaryTables := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryAuxiliaryTables_R(Self: TJvQBEQuery; var T: Boolean);
begin T := Self.AuxiliaryTables; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryText_R(Self: TJvQBEQuery; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryRowsAffected_R(Self: TJvQBEQuery; var T: Integer);
begin T := Self.RowsAffected; end;

(*----------------------------------------------------------------------------*)
{procedure TJvQBEQueryText_R(Self: TJvQBEQuery; var T: string);
begin T := Self.Text; end;}

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryStmtHandle_R(Self: TJvQBEQuery; var T: HDBIStmt);
begin T := Self.StmtHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryPrepared_W(Self: TJvQBEQuery; const T: Boolean);
begin Self.Prepared := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryPrepared_R(Self: TJvQBEQuery; var T: Boolean);
begin T := Self.Prepared; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryParamCount_R(Self: TJvQBEQuery; var T: Word);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvQBEQueryLocal_R(Self: TJvQBEQuery; var T: Boolean);
begin T := Self.Local; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvQBEQuery(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvQBEQuery) do begin
    RegisterConstructor(@TJvQBEQuery.Create, 'Create');
    RegisterMethod(@TJvQBEQuery.Destroy, 'Free');
    RegisterMethod(@TJvQBEQuery.GetQBEText, 'GetQBEText');
    RegisterMethod(@TJvQBEQuery.ExecQBE, 'ExecQBE');
    RegisterMethod(@TJvQBEQuery.ParamByName, 'ParamByName');
    RegisterMethod(@TJvQBEQuery.Prepare, 'Prepare');
    RegisterMethod(@TJvQBEQuery.RefreshQuery, 'RefreshQuery');
    RegisterMethod(@TJvQBEQuery.UnPrepare, 'UnPrepare');
    RegisterMethod(@TJvQBEQuery.IsEmpty, 'IsEmpty');
    RegisterPropertyHelper(@TJvQBEQueryLocal_R,nil,'Local');
    RegisterPropertyHelper(@TJvQBEQueryParamCount_R,nil,'ParamCount');
    RegisterPropertyHelper(@TJvQBEQueryPrepared_R,@TJvQBEQueryPrepared_W,'Prepared');
    RegisterPropertyHelper(@TJvQBEQueryStmtHandle_R,nil,'StmtHandle');
    RegisterPropertyHelper(@TJvQBEQueryText_R,nil,'Text');
    RegisterPropertyHelper(@TJvQBEQueryRowsAffected_R,nil,'RowsAffected');
    RegisterPropertyHelper(@TJvQBEQueryText_R,nil,'Text');
    RegisterPropertyHelper(@TJvQBEQueryAuxiliaryTables_R,@TJvQBEQueryAuxiliaryTables_W,'AuxiliaryTables');
    RegisterPropertyHelper(@TJvQBEQueryParamCheck_R,@TJvQBEQueryParamCheck_W,'ParamCheck');
    RegisterPropertyHelper(@TJvQBEQueryStartParam_R,@TJvQBEQueryStartParam_W,'StartParam');
    RegisterPropertyHelper(@TJvQBEQueryQBE_R,@TJvQBEQueryQBE_W,'QBE');
    RegisterPropertyHelper(@TJvQBEQueryBlankAsZero_R,@TJvQBEQueryBlankAsZero_W,'BlankAsZero');
    RegisterPropertyHelper(@TJvQBEQueryParams_R,@TJvQBEQueryParams_W,'Params');
    RegisterPropertyHelper(@TJvQBEQueryRequestLive_R,@TJvQBEQueryRequestLive_W,'RequestLive');
    RegisterPropertyHelper(@TJvQBEQueryConstrained_R,@TJvQBEQueryConstrained_W,'Constrained');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBQBE(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvQBEQuery(CL);
end;

 
 
{ TPSImport_JvDBQBE }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBQBE.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBQBE(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBQBE.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBQBE(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
