unit uPSI_DrTable;
{
   BDE
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
  TPSImport_DrTable = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TQueryDescription(CL: TPSPascalCompiler);
procedure SIRegister_TDRRelationshipList(CL: TPSPascalCompiler);
procedure SIRegister_TDRObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TDRInstanceItems(CL: TPSPascalCompiler);
procedure SIRegister_TDRAttrDescList(CL: TPSPascalCompiler);
procedure SIRegister_TDRRelationshipDescList(CL: TPSPascalCompiler);
procedure SIRegister_TDRObjectItems(CL: TPSPascalCompiler);
procedure SIRegister_TDRObjectDescList(CL: TPSPascalCompiler);
procedure SIRegister_TDRDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TDRList(CL: TPSPascalCompiler);
procedure SIRegister_DrTable(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TQueryDescription(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRRelationshipList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRInstanceItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRAttrDescList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRRelationshipDescList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRObjectItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRObjectDescList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDRList(CL: TPSRuntimeClassImporter);
procedure RIRegister_DrTable(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,BDE
  ,DB
  ,DBTables
  ,DrTable
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DrTable]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TQueryDescription(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBdeDataset', 'TQueryDescription') do
  with CL.AddClassN(CL.FindClass('TBdeDataset'),'TQueryDescription') do
  begin
    RegisterProperty('Query', 'TQuery', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRRelationshipList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDRInstanceItems', 'TDRRelationshipList') do
  with CL.AddClassN(CL.FindClass('TDRInstanceItems'),'TDRRelationshipList') do
  begin
    RegisterMethod('Procedure NavigateFromTo( const ASource, ATarget : DRObject)');
    RegisterProperty('RelationshipTypeName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDRInstanceItems', 'TDRObjectList') do
  with CL.AddClassN(CL.FindClass('TDRInstanceItems'),'TDRObjectList') do
  begin
    RegisterMethod('Procedure NavigateFrom( const ASource : DRObject; const ARelationship : string)');
    RegisterProperty('ObjectTypeName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRInstanceItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDRObjectItems', 'TDRInstanceItems') do
  with CL.AddClassN(CL.FindClass('TDRObjectItems'),'TDRInstanceItems') do
  begin
    RegisterProperty('Condition', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRAttrDescList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDRObjectItems', 'TDRAttrDescList') do
  with CL.AddClassN(CL.FindClass('TDRObjectItems'),'TDRAttrDescList') do
  begin
    RegisterProperty('TypeName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRRelationshipDescList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDRObjectItems', 'TDRRelationshipDescList') do
  with CL.AddClassN(CL.FindClass('TDRObjectItems'),'TDRRelationshipDescList') do
  begin
    RegisterProperty('ObjectTypeName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRObjectItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDRDataset', 'TDRObjectItems') do
  with CL.AddClassN(CL.FindClass('TDRDataset'),'TDRObjectItems') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRObjectDescList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDRDataSet', 'TDRObjectDescList') do
  with CL.AddClassN(CL.FindClass('TDRDataSet'),'TDRObjectDescList') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBdeDataSet', 'TDRDataSet') do
  with CL.AddClassN(CL.FindClass('TBdeDataSet'),'TDRDataSet') do
  begin
    RegisterProperty('DRHandle', 'HDBIDR', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDRList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBdeDataSet', 'TDRList') do
  with CL.AddClassN(CL.FindClass('TBdeDataSet'),'TDRList') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DrTable(CL: TPSPascalCompiler);
begin
  SIRegister_TDRList(CL);
  SIRegister_TDRDataSet(CL);
  SIRegister_TDRObjectDescList(CL);
  SIRegister_TDRObjectItems(CL);
  SIRegister_TDRRelationshipDescList(CL);
  SIRegister_TDRAttrDescList(CL);
  SIRegister_TDRInstanceItems(CL);
  SIRegister_TDRObjectList(CL);
  SIRegister_TDRRelationshipList(CL);
  SIRegister_TQueryDescription(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TQueryDescriptionQuery_W(Self: TQueryDescription; const T: TQuery);
begin Self.Query := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryDescriptionQuery_R(Self: TQueryDescription; var T: TQuery);
begin T := Self.Query; end;

(*----------------------------------------------------------------------------*)
procedure TDRRelationshipListRelationshipTypeName_W(Self: TDRRelationshipList; const T: string);
begin Self.RelationshipTypeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDRRelationshipListRelationshipTypeName_R(Self: TDRRelationshipList; var T: string);
begin T := Self.RelationshipTypeName; end;

(*----------------------------------------------------------------------------*)
procedure TDRObjectListObjectTypeName_W(Self: TDRObjectList; const T: string);
begin Self.ObjectTypeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDRObjectListObjectTypeName_R(Self: TDRObjectList; var T: string);
begin T := Self.ObjectTypeName; end;

(*----------------------------------------------------------------------------*)
procedure TDRInstanceItemsCondition_W(Self: TDRInstanceItems; const T: string);
begin Self.Condition := T; end;

(*----------------------------------------------------------------------------*)
procedure TDRInstanceItemsCondition_R(Self: TDRInstanceItems; var T: string);
begin T := Self.Condition; end;

(*----------------------------------------------------------------------------*)
procedure TDRAttrDescListTypeName_W(Self: TDRAttrDescList; const T: string);
begin Self.TypeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDRAttrDescListTypeName_R(Self: TDRAttrDescList; var T: string);
begin T := Self.TypeName; end;

(*----------------------------------------------------------------------------*)
procedure TDRRelationshipDescListObjectTypeName_W(Self: TDRRelationshipDescList; const T: string);
begin Self.ObjectTypeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDRRelationshipDescListObjectTypeName_R(Self: TDRRelationshipDescList; var T: string);
begin T := Self.ObjectTypeName; end;

(*----------------------------------------------------------------------------*)
procedure TDRDataSetDRHandle_W(Self: TDRDataSet; const T: HDBIDR);
begin Self.DRHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TDRDataSetDRHandle_R(Self: TDRDataSet; var T: HDBIDR);
begin T := Self.DRHandle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TQueryDescription(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TQueryDescription) do
  begin
    RegisterPropertyHelper(@TQueryDescriptionQuery_R,@TQueryDescriptionQuery_W,'Query');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRRelationshipList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRRelationshipList) do
  begin
    RegisterMethod(@TDRRelationshipList.NavigateFromTo, 'NavigateFromTo');
    RegisterPropertyHelper(@TDRRelationshipListRelationshipTypeName_R,@TDRRelationshipListRelationshipTypeName_W,'RelationshipTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRObjectList) do
  begin
    RegisterMethod(@TDRObjectList.NavigateFrom, 'NavigateFrom');
    RegisterPropertyHelper(@TDRObjectListObjectTypeName_R,@TDRObjectListObjectTypeName_W,'ObjectTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRInstanceItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRInstanceItems) do
  begin
    RegisterPropertyHelper(@TDRInstanceItemsCondition_R,@TDRInstanceItemsCondition_W,'Condition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRAttrDescList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRAttrDescList) do
  begin
    RegisterPropertyHelper(@TDRAttrDescListTypeName_R,@TDRAttrDescListTypeName_W,'TypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRRelationshipDescList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRRelationshipDescList) do
  begin
    RegisterPropertyHelper(@TDRRelationshipDescListObjectTypeName_R,@TDRRelationshipDescListObjectTypeName_W,'ObjectTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRObjectItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRObjectItems) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRObjectDescList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRObjectDescList) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRDataSet) do
  begin
    RegisterPropertyHelper(@TDRDataSetDRHandle_R,@TDRDataSetDRHandle_W,'DRHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDRList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDRList) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DrTable(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDRList(CL);
  RIRegister_TDRDataSet(CL);
  RIRegister_TDRObjectDescList(CL);
  RIRegister_TDRObjectItems(CL);
  RIRegister_TDRRelationshipDescList(CL);
  RIRegister_TDRAttrDescList(CL);
  RIRegister_TDRInstanceItems(CL);
  RIRegister_TDRObjectList(CL);
  RIRegister_TDRRelationshipList(CL);
  RIRegister_TQueryDescription(CL);
end;

 
 
{ TPSImport_DrTable }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DrTable.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DrTable(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DrTable.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DrTable(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
