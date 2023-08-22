unit uPSI_DBOleCtl;
{
  db for mX4 - no functions

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
  TPSImport_DBOleCtl = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBOleControl(CL: TPSPascalCompiler);
procedure SIRegister_TDataBindings(CL: TPSPascalCompiler);
procedure SIRegister_TDataBindItem(CL: TPSPascalCompiler);
procedure SIRegister_DBOleCtl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBOleControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataBindings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataBindItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBOleCtl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,Messages
  ,Controls
  ,Forms
  ,OleCtrls
  ,DB
  ,DBCtrls
  ,ActiveX
  ,DBOleCtl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBOleCtl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBOleControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleControl', 'TDBOleControl') do
  with CL.AddClassN(CL.FindClass('TOleControl'),'TDBOleControl') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('DataBindings', 'TDataBindings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataBindings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TDataBindings') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TDataBindings') do
  begin
    RegisterMethod('Constructor Create( DBOleControl : TDBOleControl)');
    RegisterMethod('Function Add : TDataBindItem');
    RegisterMethod('Procedure Update( Item : TCollectionItem)');
    RegisterMethod('Function GetItemByDispID( ADispID : TDispID) : TDataBindItem');
    RegisterMethod('Function GetOwner : TPersistent');
    RegisterProperty('Items', 'TDataBindItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataBindItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TDataBindItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TDataBindItem') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterProperty('DataField', 'string', iptrw);
    RegisterProperty('DispID', 'TDispID', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBOleCtl(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBOleControl');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDataBindings');
  SIRegister_TDataBindItem(CL);
  SIRegister_TDataBindings(CL);
  SIRegister_TDBOleControl(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBOleControlDataBindings_W(Self: TDBOleControl; const T: TDataBindings);
begin Self.DataBindings := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBOleControlDataBindings_R(Self: TDBOleControl; var T: TDataBindings);
begin T := Self.DataBindings; end;

(*----------------------------------------------------------------------------*)
procedure TDBOleControlDataSource_W(Self: TDBOleControl; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBOleControlDataSource_R(Self: TDBOleControl; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TDataBindingsItems_W(Self: TDataBindings; const T: TDataBindItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataBindingsItems_R(Self: TDataBindings; var T: TDataBindItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TDataBindItemDispID_W(Self: TDataBindItem; const T: TDispID);
begin Self.DispID := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataBindItemDispID_R(Self: TDataBindItem; var T: TDispID);
begin T := Self.DispID; end;

(*----------------------------------------------------------------------------*)
procedure TDataBindItemDataField_W(Self: TDataBindItem; const T: string);
begin Self.DataField := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataBindItemDataField_R(Self: TDataBindItem; var T: string);
begin T := Self.DataField; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBOleControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBOleControl) do begin
    RegisterConstructor(@TDBOleControl.Create, 'Create');
    RegisterMethod(@TDBOleControl.Destroy, 'Free');
    RegisterPropertyHelper(@TDBOleControlDataSource_R,@TDBOleControlDataSource_W,'DataSource');
    RegisterPropertyHelper(@TDBOleControlDataBindings_R,@TDBOleControlDataBindings_W,'DataBindings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataBindings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataBindings) do
  begin
    RegisterConstructor(@TDataBindings.Create, 'Create');
    RegisterMethod(@TDataBindings.Add, 'Add');
    RegisterMethod(@TDataBindings.Update, 'Update');
    RegisterMethod(@TDataBindings.GetItemByDispID, 'GetItemByDispID');
    RegisterMethod(@TDataBindings.GetOwner, 'GetOwner');
    RegisterPropertyHelper(@TDataBindingsItems_R,@TDataBindingsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataBindItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataBindItem) do begin
    RegisterConstructor(@TDataBindItem.Create, 'Create');
     RegisterMethod(@TDataBindItem.Destroy, 'Free');
    RegisterPropertyHelper(@TDataBindItemDataField_R,@TDataBindItemDataField_W,'DataField');
    RegisterPropertyHelper(@TDataBindItemDispID_R,@TDataBindItemDispID_W,'DispID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBOleCtl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBOleControl) do
  with CL.Add(TDataBindings) do
  RIRegister_TDataBindItem(CL);
  RIRegister_TDataBindings(CL);
  RIRegister_TDBOleControl(CL);
end;

 
 
{ TPSImport_DBOleCtl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBOleCtl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBOleCtl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBOleCtl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBOleCtl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
