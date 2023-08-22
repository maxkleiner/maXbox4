unit uPSI_cyFlyingContainer;
{
   to basecontainer
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
  TPSImport_cyFlyingContainer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyFlyingContainer(CL: TPSPascalCompiler);
procedure SIRegister_cyFlyingContainer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyFlyingContainer_Routines(S: TPSExec);
procedure RIRegister_TcyFlyingContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyFlyingContainer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,Controls
  ,Types
  ,cyBaseContainer
  ,cyFlyingContainer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyFlyingContainer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyFlyingContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyBaseContainer', 'TcyFlyingContainer') do
  with CL.AddClassN(CL.FindClass('TcyBaseContainer'),'TcyFlyingContainer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Execute( ScreenCoord : TPoint)');
    RegisterMethod('procedure Close;');
    RegisterProperty('EscKey', 'Boolean', iptrw);
    RegisterProperty('CloseOnExit', 'Boolean', iptrw);
    RegisterMethod('Procedure ExecuteAsSplashScreen');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyFlyingContainer(CL: TPSPascalCompiler);
begin
  SIRegister_TcyFlyingContainer(CL);
 CL.AddDelphiFunction('Function ShowStayOnTopControl( aControl : TControl; BS : TFormBorderStyle; BI : TBorderIcons; WS : TWindowState; Title : String; BeforeShowModal : TNotifyEvent) : TForm');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyFlyingContainerCloseOnExit_W(Self: TcyFlyingContainer; const T: Boolean);
begin Self.CloseOnExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyFlyingContainerCloseOnExit_R(Self: TcyFlyingContainer; var T: Boolean);
begin T := Self.CloseOnExit; end;

(*----------------------------------------------------------------------------*)
procedure TcyFlyingContainerEscKey_W(Self: TcyFlyingContainer; const T: Boolean);
begin Self.EscKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyFlyingContainerEscKey_R(Self: TcyFlyingContainer; var T: Boolean);
begin T := Self.EscKey; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyFlyingContainer_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ShowStayOnTopControl, 'ShowStayOnTopControl', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyFlyingContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyFlyingContainer) do begin
    RegisterConstructor(@TcyFlyingContainer.Create, 'Create');
    RegisterMethod(@TcyFlyingContainer.Execute, 'Execute');
    RegisterMethod(@TcyFlyingContainer.Close, 'Close');
    RegisterPropertyHelper(@TcyFlyingContainerEscKey_R,@TcyFlyingContainerEscKey_W,'EscKey');
    RegisterPropertyHelper(@TcyFlyingContainerCloseOnExit_R,@TcyFlyingContainerCloseOnExit_W,'CloseOnExit');
    RegisterMethod(@TcyFlyingContainer.ExecuteAsSplashScreen, 'ExecuteAsSplashScreen');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyFlyingContainer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyFlyingContainer(CL);
end;

 
 
{ TPSImport_cyFlyingContainer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyFlyingContainer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyFlyingContainer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyFlyingContainer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyFlyingContainer(ri);
  RIRegister_cyFlyingContainer_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
