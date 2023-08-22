unit uPSI_JvFinalize;
{
  in the end 1050 units
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
  TPSImport_JvFinalize = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvFinalize(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvFinalize_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JvFinalize
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFinalize]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFinalize(CL: TPSPascalCompiler);
begin
//type
//  TFinalizeProc = procedure;
  CL.AddTypeS('TFinalizeProc', 'procedure');
 CL.AddDelphiFunction('Procedure AddFinalizeProc( const UnitName : string; FinalizeProc : TFinalizeProc)');
 CL.AddDelphiFunction('Function AddFinalizeObject( const UnitName : string; Instance : TObject) : TObject');
 CL.AddDelphiFunction('Function AddFinalizeObjectNil( const UnitName : string; var Reference: TObject) : TObject');
 CL.AddDelphiFunction('Function AddFinalizeFreeAndNil( const UnitName : string; var Reference: TObject) : TObject');
 CL.AddDelphiFunction('Function AddFinalizeMemory( const UnitName : string; Ptr : ___Pointer) : ___Pointer');
 CL.AddDelphiFunction('Function AddFinalizeMemoryNil( const UnitName : string; var Ptr: ___Pointer) : ___Pointer');
 CL.AddDelphiFunction('Procedure FinalizeUnit( const UnitName : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFinalize_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AddFinalizeProc, 'AddFinalizeProc', cdRegister);
 S.RegisterDelphiFunction(@AddFinalizeObject, 'AddFinalizeObject', cdRegister);
 S.RegisterDelphiFunction(@AddFinalizeObjectNil, 'AddFinalizeObjectNil', cdRegister);
 S.RegisterDelphiFunction(@AddFinalizeFreeAndNil, 'AddFinalizeFreeAndNil', cdRegister);
 S.RegisterDelphiFunction(@AddFinalizeMemory, 'AddFinalizeMemory', cdRegister);
 S.RegisterDelphiFunction(@AddFinalizeMemoryNil, 'AddFinalizeMemoryNil', cdRegister);
 S.RegisterDelphiFunction(@FinalizeUnit, 'FinalizeUnit', cdRegister);
end;

 
 
{ TPSImport_JvFinalize }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFinalize.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFinalize(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFinalize.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvFinalize(ri);
  RIRegister_JvFinalize_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
