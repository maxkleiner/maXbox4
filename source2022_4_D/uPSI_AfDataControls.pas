unit uPSI_AfDataControls;
{
   async to arrayblockingqueue
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
  TPSImport_AfDataControls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAfDataEdit(CL: TPSPascalCompiler);
procedure SIRegister_AfDataControls(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_AfDataControls_Routines(S: TPSExec);
procedure RIRegister_TAfDataEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfDataControls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,AfDataDispatcher
  ,AfDataControls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfDataControls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfDataEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomEdit', 'TAfDataEdit') do
  with CL.AddClassN(CL.FindClass('TCustomEdit'),'TAfDataEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
                  RegisterMethod('Procedure Free');
     RegisterProperty('Dispatcher', 'TAfCustomDataDispatcher', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfDataControls(CL: TPSPascalCompiler);
begin
  SIRegister_TAfDataEdit(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfDataEditDispatcher_W(Self: TAfDataEdit; const T: TAfCustomDataDispatcher);
begin Self.Dispatcher := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataEditDispatcher_R(Self: TAfDataEdit; var T: TAfCustomDataDispatcher);
begin T := Self.Dispatcher; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfDataControls_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfDataEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfDataEdit) do begin
    RegisterConstructor(@TAfDataEdit.Create, 'Create');
          RegisterMethod(@TAfDataEdit.Destroy, 'Free');
     RegisterPropertyHelper(@TAfDataEditDispatcher_R,@TAfDataEditDispatcher_W,'Dispatcher');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfDataControls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAfDataEdit(CL);
end;

 
 
{ TPSImport_AfDataControls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfDataControls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfDataControls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfDataControls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfDataControls(ri);
  //RIRegister_AfDataControls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
