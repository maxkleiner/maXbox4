unit uPSI_cyBaseContainer;
{
    container or collection
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
  TPSImport_cyBaseContainer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyBaseContainer(CL: TPSPascalCompiler);
procedure SIRegister_TcyCustomGrid(CL: TPSPascalCompiler);
procedure SIRegister_cyBaseContainer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyBaseContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyCustomGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyBaseContainer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,Graphics
  ,Controls
  ,Types
  ,Grids
  ,Messages
  ,cyBaseContainer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyBaseContainer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyBaseContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyBaseContainer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyBaseContainer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure ExecuteFromControl( aControl : TControl; posX, posY : integer)');
    RegisterMethod('Procedure ExecuteFromGrid( aGrid : TCustomGrid; Align : TAlignment)');
    RegisterMethod('Procedure Execute( ScreenCoord : TPoint)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyCustomGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGrid', 'TcyCustomGrid') do
  with CL.AddClassN(CL.FindClass('TCustomGrid'),'TcyCustomGrid') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyBaseContainer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TEnterKeyAction', '( enterKeyDefault, enterKeyNothing, enterKeyGotoNextControl )');
  SIRegister_TcyCustomGrid(CL);
  SIRegister_TcyBaseContainer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyBaseContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyBaseContainer) do
  begin
    RegisterConstructor(@TcyBaseContainer.Create, 'Create');
    RegisterVirtualMethod(@TcyBaseContainer.Close, 'Close');
    RegisterMethod(@TcyBaseContainer.ExecuteFromControl, 'ExecuteFromControl');
    RegisterMethod(@TcyBaseContainer.ExecuteFromGrid, 'ExecuteFromGrid');
    RegisterVirtualMethod(@TcyBaseContainer.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyCustomGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyCustomGrid) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyBaseContainer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyCustomGrid(CL);
  RIRegister_TcyBaseContainer(CL);
end;

 
 
{ TPSImport_cyBaseContainer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseContainer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyBaseContainer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseContainer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyBaseContainer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
