unit uPSI_cyModalContainer;
{
    contain
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
  TPSImport_cyModalContainer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyModalContainer(CL: TPSPascalCompiler);
procedure SIRegister_cyModalContainer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyModalContainer_Routines(S: TPSExec);
procedure RIRegister_TcyModalContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyModalContainer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Types
  ,Graphics
  ,Forms
  ,Controls
  ,ExtCtrls
  ,cyBaseContainer
  ,cyModalContainer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyModalContainer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyModalContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyBaseContainer', 'TcyModalContainer') do
  with CL.AddClassN(CL.FindClass('TcyBaseContainer'),'TcyModalContainer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('procedure Close;');
    RegisterMethod('Procedure Execute( ScreenCoord : TPoint);');
    RegisterMethod('Procedure Execute1;');
    RegisterMethod('Function Execute2( aCaption : String; aControl : TControl) : TModalResult;');
    RegisterProperty('ModalResult', 'TModalResult', iptr);
    RegisterProperty('EscKeyAction', 'TModalResult', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyModalContainer(CL: TPSPascalCompiler);
begin
  SIRegister_TcyModalContainer(CL);
 CL.AddDelphiFunction('Function ShowModalControl( aControl : TControl; BS : TFormBorderStyle; BI : TBorderIcons; WS : TWindowState; aColor : TColor; BW : Integer; Title : String; BeforeShowModal : TNotifyEvent) : TModalResult');
 CL.AddDelphiFunction('Function ShowModalPanel( aPanel : TCustomPanel; Title : String; ShowCloseIcon : Boolean; BeforeShowModal : TNotifyEvent) : TModalResult');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyModalContainerEscKeyAction_W(Self: TcyModalContainer; const T: TModalResult);
begin Self.EscKeyAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyModalContainerEscKeyAction_R(Self: TcyModalContainer; var T: TModalResult);
begin T := Self.EscKeyAction; end;

(*----------------------------------------------------------------------------*)
procedure TcyModalContainerModalResult_R(Self: TcyModalContainer; var T: TModalResult);
begin T := Self.ModalResult; end;

(*----------------------------------------------------------------------------*)
Function TcyModalContainerExecute2_P(Self: TcyModalContainer;  aCaption : String; aControl : TControl) : TModalResult;
Begin Result := Self.Execute(aCaption, aControl); END;

(*----------------------------------------------------------------------------*)
Procedure TcyModalContainerExecute1_P(Self: TcyModalContainer);
Begin Self.Execute; END;

(*----------------------------------------------------------------------------*)
Procedure TcyModalContainerExecute_P(Self: TcyModalContainer;  ScreenCoord : TPoint);
Begin Self.Execute(ScreenCoord); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyModalContainer_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ShowModalControl, 'ShowModalControl', cdRegister);
 S.RegisterDelphiFunction(@ShowModalPanel, 'ShowModalPanel', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyModalContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyModalContainer) do begin
    RegisterConstructor(@TcyModalContainer.Create, 'Create');
      RegisterMethod(@TcyModalContainer.Close, 'Close');
      RegisterMethod(@TcyModalContainerExecute_P, 'Execute');
    RegisterMethod(@TcyModalContainerExecute1_P, 'Execute1');
    RegisterMethod(@TcyModalContainerExecute2_P, 'Execute2');
    RegisterPropertyHelper(@TcyModalContainerModalResult_R,nil,'ModalResult');
    RegisterPropertyHelper(@TcyModalContainerEscKeyAction_R,@TcyModalContainerEscKeyAction_W,'EscKeyAction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyModalContainer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyModalContainer(CL);
end;

 
 
{ TPSImport_cyModalContainer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyModalContainer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyModalContainer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyModalContainer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyModalContainer(ri);
  RIRegister_cyModalContainer_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
