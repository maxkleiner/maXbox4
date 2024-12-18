unit uPSI_kcMapViewerDEWin32;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_kcMapViewerDEWin32 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMVDEWin32(CL: TPSPascalCompiler);
procedure SIRegister_kcMapViewerDEWin32(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMVDEWin32(CL: TPSRuntimeClassImporter);
procedure RIRegister_kcMapViewerDEWin32(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   kcMapViewer
  ,wininet
  ,kcMapViewerDEWin32
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_kcMapViewerDEWin32]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMVDEWin32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDownloadEngine', 'TMVDEWin32') do
  with CL.AddClassN(CL.FindClass('TCustomDownloadEngine'),'TMVDEWin32') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_kcMapViewerDEWin32(CL: TPSPascalCompiler);
begin
  SIRegister_TMVDEWin32(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TMVDEWin32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMVDEWin32) do
  begin
    RegisterConstructor(@TMVDEWin32.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_kcMapViewerDEWin32(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMVDEWin32(CL);
end;

 
 
{ TPSImport_kcMapViewerDEWin32 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_kcMapViewerDEWin32.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_kcMapViewerDEWin32(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_kcMapViewerDEWin32.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_kcMapViewerDEWin32(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
