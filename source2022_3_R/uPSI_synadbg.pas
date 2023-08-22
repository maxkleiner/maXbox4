unit uPSI_synadbg;
{
last of 40 units to V mX4       - mXV4
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
  TPSImport_synadbg = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynaDebug(CL: TPSPascalCompiler);
procedure SIRegister_synadbg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synadbg_Routines(S: TPSExec);
procedure RIRegister_TSynaDebug(CL: TPSRuntimeClassImporter);
procedure RIRegister_synadbg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synsock
  ,synautil
  ,synafpc
  ,synadbg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synadbg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynaDebug(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynaDebug') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynaDebug') do
  begin
    RegisterMethod('Procedure HookStatus( Sender : TObject; Reason : THookSocketReason; const Value : string)');
    RegisterMethod('Procedure HookMonitor( Sender : TObject; Writing : Boolean; const Buffer : TMemory; Len : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_synadbg(CL: TPSPascalCompiler);
begin
  SIRegister_TSynaDebug(CL);
 CL.AddDelphiFunction('Procedure AppendToLog( const value : Ansistring)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_synadbg_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AppendToLog, 'AppendToLog', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynaDebug(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynaDebug) do
  begin
    RegisterMethod(@TSynaDebug.HookStatus, 'HookStatus');
    RegisterMethod(@TSynaDebug.HookMonitor, 'HookMonitor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_synadbg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynaDebug(CL);
end;

 
 
{ TPSImport_synadbg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synadbg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synadbg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synadbg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_synadbg(ri);
  RIRegister_synadbg_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
