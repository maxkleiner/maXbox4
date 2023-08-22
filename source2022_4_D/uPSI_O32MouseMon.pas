unit uPSI_O32MouseMon;
{
   WITH proc functions
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
  TPSImport_O32MouseMon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_O32MouseMon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_O32MouseMon_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,OvcMisc
  ,O32MouseMon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_O32MouseMon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_O32MouseMon(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMouseMonHandler', 'Procedure ( const MouseMessage, wParam, lPar'
   +'am : Integer; const ScreenPt : TPoint; const MouseWnd : TOvcHWnd)');
 CL.AddDelphiFunction('Procedure StartMouseMonitor( Callback : TMouseMonHandler)');
 CL.AddDelphiFunction('Procedure StopMouseMonitor( Callback : TMouseMonHandler)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_O32MouseMon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StartMouseMonitor, 'StartMouseMonitor', cdRegister);
 S.RegisterDelphiFunction(@StopMouseMonitor, 'StopMouseMonitor', cdRegister);
end;

 
 
{ TPSImport_O32MouseMon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_O32MouseMon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_O32MouseMon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_O32MouseMon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_O32MouseMon(ri);
  RIRegister_O32MouseMon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
