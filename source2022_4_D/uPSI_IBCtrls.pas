unit uPSI_IBCtrls;
{
   ib events   also ibcomponent!
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
  TPSImport_IBCtrls = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIBEventAlerter(CL: TPSPascalCompiler);
procedure SIRegister_TIBComponent(CL: TPSPascalCompiler);
procedure SIRegister_IBCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIBEventAlerter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIBComponent(CL: TPSRuntimeClassImporter);
procedure RIRegister_IBCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,DB
  ,DBTables
  ,IBProc32
  ,BDE
  ,IBCtrls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IBCtrls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBEventAlerter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBComponent', 'TIBEventAlerter') do
  with CL.AddClassN(CL.FindClass('TIBComponent'),'TIBEventAlerter') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
       RegisterMethod('Procedure CancelEvents');
    RegisterMethod('Procedure QueueEvents');
    RegisterMethod('Procedure RegisterEvents');
    RegisterMethod('Procedure UnRegisterEvents');
    RegisterProperty('Queued', 'Boolean', iptr);
    RegisterProperty('Events', 'TStrings', iptrw);
    RegisterProperty('Registered', 'Boolean', iptrw);
    RegisterProperty('OnEventAlert', 'TEventAlert', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBComponent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIBComponent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIBComponent') do
  begin
    RegisterProperty('Database', 'TDatabase', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBCtrls(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxEvents','LongInt').SetInt( 15);
 CL.AddConstantN('EventLength','LongInt').SetInt( 64);
  SIRegister_TIBComponent(CL);
  CL.AddTypeS('TEventAlert', 'Procedure ( Sender : TObject; EventName : string;'
   +' EventCount : longint; var CancelAlerts : Boolean)');
  SIRegister_TIBEventAlerter(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIBError');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBEventAlerterOnEventAlert_W(Self: TIBEventAlerter; const T: TEventAlert);
begin Self.OnEventAlert := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBEventAlerterOnEventAlert_R(Self: TIBEventAlerter; var T: TEventAlert);
begin T := Self.OnEventAlert; end;

(*----------------------------------------------------------------------------*)
procedure TIBEventAlerterRegistered_W(Self: TIBEventAlerter; const T: Boolean);
begin Self.Registered := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBEventAlerterRegistered_R(Self: TIBEventAlerter; var T: Boolean);
begin T := Self.Registered; end;

(*----------------------------------------------------------------------------*)
procedure TIBEventAlerterEvents_W(Self: TIBEventAlerter; const T: TStrings);
begin Self.Events := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBEventAlerterEvents_R(Self: TIBEventAlerter; var T: TStrings);
begin T := Self.Events; end;

(*----------------------------------------------------------------------------*)
procedure TIBEventAlerterQueued_R(Self: TIBEventAlerter; var T: Boolean);
begin T := Self.Queued; end;

(*----------------------------------------------------------------------------*)
procedure TIBComponentDatabase_W(Self: TIBComponent; const T: TDatabase);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBComponentDatabase_R(Self: TIBComponent; var T: TDatabase);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBEventAlerter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBEventAlerter) do begin
    RegisterConstructor(@TIBEventAlerter.Create, 'Create');
    RegisterMethod(@TIBEventAlerter.Destroy, 'Free');
    RegisterMethod(@TIBEventAlerter.CancelEvents, 'CancelEvents');
    RegisterMethod(@TIBEventAlerter.QueueEvents, 'QueueEvents');
    RegisterMethod(@TIBEventAlerter.RegisterEvents, 'RegisterEvents');
    RegisterMethod(@TIBEventAlerter.UnRegisterEvents, 'UnRegisterEvents');
    RegisterPropertyHelper(@TIBEventAlerterQueued_R,nil,'Queued');
    RegisterPropertyHelper(@TIBEventAlerterEvents_R,@TIBEventAlerterEvents_W,'Events');
    RegisterPropertyHelper(@TIBEventAlerterRegistered_R,@TIBEventAlerterRegistered_W,'Registered');
    RegisterPropertyHelper(@TIBEventAlerterOnEventAlert_R,@TIBEventAlerterOnEventAlert_W,'OnEventAlert');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBComponent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBComponent) do
  begin
    RegisterPropertyHelper(@TIBComponentDatabase_R,@TIBComponentDatabase_W,'Database');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBCtrls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIBComponent(CL);
  RIRegister_TIBEventAlerter(CL);
  with CL.Add(EIBError) do
end;

 
 
{ TPSImport_IBCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IBCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IBCtrls(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
