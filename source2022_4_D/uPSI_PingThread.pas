unit uPSI_PingThread;
{
   synapse
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
  TPSImport_PingThread = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPingThread(CL: TPSPascalCompiler);
procedure SIRegister_PingThread(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPingThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_PingThread(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   PingSend
  //,IPUtils
  ,PingThread
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PingThread]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPingThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TPingThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TPingThread') do begin
    RegisterProperty('PingResult', 'TPingResult', iptrw);
    RegisterProperty('Ready', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( Ping : TPingResult)');
       RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PingThread(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PPingResult', '^TPingResult // will not work');
  CL.AddTypeS('TPingResult', 'record IPAdress : String; Exists : Boolean; end');
  SIRegister_TPingThread(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPingThreadReady_W(Self: TPingThread; const T: Boolean);
Begin Self.Ready := T; end;

(*----------------------------------------------------------------------------*)
procedure TPingThreadReady_R(Self: TPingThread; var T: Boolean);
Begin T := Self.Ready; end;

(*----------------------------------------------------------------------------*)
procedure TPingThreadPingResult_W(Self: TPingThread; const T: TPingResult);
Begin Self.PingResult := T; end;

(*----------------------------------------------------------------------------*)
procedure TPingThreadPingResult_R(Self: TPingThread; var T: TPingResult);
Begin T := Self.PingResult; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPingThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPingThread) do begin
    RegisterPropertyHelper(@TPingThreadPingResult_R,@TPingThreadPingResult_W,'PingResult');
    RegisterPropertyHelper(@TPingThreadReady_R,@TPingThreadReady_W,'Ready');
    RegisterConstructor(@TPingThread.Create, 'Create');
    RegisterMethod(@TPingThread.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PingThread(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPingThread(CL);
end;

 
 
{ TPSImport_PingThread }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PingThread.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PingThread(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PingThread.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PingThread(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
