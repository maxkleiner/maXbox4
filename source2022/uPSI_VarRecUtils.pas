unit uPSI_VarRecUtils;
{

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
  TPSImport_VarRecUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_VarRecUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VarRecUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   VarRecUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VarRecUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_VarRecUtils(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('TConstArray', 'array of TVarRec');
 //CL.AddDelphiFunction('Function CopyVarRec( const Item : TVarRec) : TVarRec');
 //CL.AddDelphiFunction('Function CreateConstArray( const Elements : array of const) : TConstArray');
 //CL.AddDelphiFunction('Procedure FinalizeVarRec( var Item : TVarRec)');
 //CL.AddDelphiFunction('Procedure FinalizeConstArray( var Arr : TConstArray)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_VarRecUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CopyVarRec, 'CopyVarRec', cdRegister);
 S.RegisterDelphiFunction(@CreateConstArray, 'CreateConstArray', cdRegister);
 S.RegisterDelphiFunction(@FinalizeVarRec, 'FinalizeVarRec', cdRegister);
 S.RegisterDelphiFunction(@FinalizeConstArray, 'FinalizeConstArray', cdRegister);
end;

 
 
{ TPSImport_VarRecUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VarRecUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VarRecUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VarRecUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_VarRecUtils(ri);
  RIRegister_VarRecUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
