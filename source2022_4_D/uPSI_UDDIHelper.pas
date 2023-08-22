unit uPSI_UDDIHelper;
{
   RIO WS    one function
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
  TPSImport_UDDIHelper = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_UDDIHelper(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UDDIHelper_Routines(S: TPSExec);

procedure Register;

implementation


uses
   UDDIHelper
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UDDIHelper]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_UDDIHelper(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function GetBindingkeyAccessPoint( const Operator : String; const key : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_UDDIHelper_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetBindingkeyAccessPoint, 'GetBindingkeyAccessPoint', cdRegister);
end;

 
 
{ TPSImport_UDDIHelper }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UDDIHelper.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UDDIHelper(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UDDIHelper.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_UDDIHelper(ri);
  RIRegister_UDDIHelper_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
