unit uPSI_udf_glob;
{
  just an interbase func
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
  TPSImport_udf_glob = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TThreadLocalVariables(CL: TPSPascalCompiler);
procedure SIRegister_udf_glob(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_udf_glob_Routines(S: TPSExec);
procedure RIRegister_TThreadLocalVariables(CL: TPSRuntimeClassImporter);
procedure RIRegister_udf_glob(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ibase
  ,udf_glob
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_udf_glob]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TThreadLocalVariables(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TThreadLocalVariables') do
  with CL.AddClassN(CL.FindClass('TObject'),'TThreadLocalVariables') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_udf_glob(CL: TPSPascalCompiler);
begin
  SIRegister_TThreadLocalVariables(CL);
 CL.AddDelphiFunction('Function MakeResultString( Source, OptionalDest : PChar; Len : DWORD) : PChar');
 //CL.AddDelphiFunction('Function MakeResultQuad( Source, OptionalDest : PISC_QUAD) : PISC_QUAD');
 CL.AddDelphiFunction('Function ThreadLocals : TThreadLocalVariables');
 CL.AddDelphiFunction('Procedure WriteDebug( sz : String)');
 CL.AddConstantN('UDF_SUCCESS','LongInt').SetInt( 0);
 CL.AddConstantN('UDF_FAILURE','LongInt').SetInt( 1);
 CL.AddConstantN('cSignificantlyLarger','LongInt').SetInt( 1024 * 4);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_udf_glob_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MakeResultString, 'MakeResultString', cdRegister);
 //S.RegisterDelphiFunction(@MakeResultQuad, 'MakeResultQuad', cdRegister);
 S.RegisterDelphiFunction(@ThreadLocals, 'ThreadLocals', cdRegister);
 S.RegisterDelphiFunction(@WriteDebug, 'WriteDebug', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TThreadLocalVariables(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThreadLocalVariables) do begin
    RegisterConstructor(@TThreadLocalVariables.Create, 'Create');
          RegisterMethod(@TThreadLocalVariables.Destroy, 'Free');
     end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_udf_glob(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TThreadLocalVariables(CL);
end;

 
 
{ TPSImport_udf_glob }
(*----------------------------------------------------------------------------*)
procedure TPSImport_udf_glob.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_udf_glob(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_udf_glob.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_udf_glob(ri);
  RIRegister_udf_glob_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
