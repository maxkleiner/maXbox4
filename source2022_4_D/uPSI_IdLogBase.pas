unit uPSI_IdLogBase;
{
  log blog   - add free to logstream
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
  TPSImport_IdLogBase = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdLogBase(CL: TPSPascalCompiler);
procedure SIRegister_IdLogBase(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdLogBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdLogBase(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdIntercept
  ,IdSocketHandle
  ,IdLogBase
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdLogBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdLogBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdConnectionIntercept', 'TIdLogBase') do
  with CL.AddClassN(CL.FindClass('TIdConnectionIntercept'),'TIdLogBase') do begin
    RegisterMethod('Procedure Connect( AConnection : TComponent)');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Receive( ABuffer : TStream)');
    RegisterMethod('Procedure Send( ABuffer : TStream)');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('LogTime', 'Boolean', iptrw);
    RegisterProperty('ReplaceCRLF', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdLogBase(CL: TPSPascalCompiler);
begin
  SIRegister_TIdLogBase(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdLogBaseReplaceCRLF_W(Self: TIdLogBase; const T: Boolean);
begin Self.ReplaceCRLF := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogBaseReplaceCRLF_R(Self: TIdLogBase; var T: Boolean);
begin T := Self.ReplaceCRLF; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogBaseLogTime_W(Self: TIdLogBase; const T: Boolean);
begin Self.LogTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogBaseLogTime_R(Self: TIdLogBase; var T: Boolean);
begin T := Self.LogTime; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogBaseActive_W(Self: TIdLogBase; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogBaseActive_R(Self: TIdLogBase; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdLogBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdLogBase) do begin
    RegisterMethod(@TIdLogBase.Connect, 'Connect');
    RegisterConstructor(@TIdLogBase.Create, 'Create');
     RegisterMethod(@TIdLogBase.Destroy, 'Free');
     RegisterMethod(@TIdLogBase.Receive, 'Receive');
    RegisterMethod(@TIdLogBase.Send, 'Send');
    RegisterMethod(@TIdLogBase.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TIdLogBaseActive_R,@TIdLogBaseActive_W,'Active');
    RegisterPropertyHelper(@TIdLogBaseLogTime_R,@TIdLogBaseLogTime_W,'LogTime');
    RegisterPropertyHelper(@TIdLogBaseReplaceCRLF_R,@TIdLogBaseReplaceCRLF_W,'ReplaceCRLF');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdLogBase(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdLogBase(CL);
end;

 
 
{ TPSImport_IdLogBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLogBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdLogBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLogBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdLogBase(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
