unit uPSI_FlatSB;
{
 first test of android like flat
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
  TPSImport_FlatSB = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_FlatSB(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FlatSB_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,FlatSB
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FlatSB]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_FlatSB(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function InitializeFlatSB( hWnd : HWND) : Boolean');
 CL.AddDelphiFunction('Procedure UninitializeFlatSB( hWnd : HWND)');
 CL.AddDelphiFunction('Function FlatSB_GetScrollProp( p1 : HWND; propIndex : Integer; p3 : Integer) : Boolean');
 CL.AddDelphiFunction('Function FlatSB_SetScrollProp( p1 : HWND; index : Integer; newValue : Integer; p4 : Boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_FlatSB_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitializeFlatSB, 'InitializeFlatSB', CdStdCall);
 S.RegisterDelphiFunction(@UninitializeFlatSB, 'UninitializeFlatSB', CdStdCall);
 S.RegisterDelphiFunction(@FlatSB_GetScrollProp, 'FlatSB_GetScrollProp', CdStdCall);
 S.RegisterDelphiFunction(@FlatSB_SetScrollProp, 'FlatSB_SetScrollProp', CdStdCall);
end;

 
 
{ TPSImport_FlatSB }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FlatSB.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FlatSB(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FlatSB.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_FlatSB(ri);
  RIRegister_FlatSB_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
