unit uPSI_LrtPoTools;
{
  of lazarus
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
  TPSImport_LrtPoTools = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_LrtPoTools(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_LrtPoTools_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Forms
  ,LrtPoTools
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LrtPoTools]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_LrtPoTools(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPOStyle', '( postStandard, postPropName, postFull )');
 CL.AddDelphiFunction('Procedure Lrt2Po( const LRTFile : string; POStyle : TPOStyle)');
 CL.AddDelphiFunction('Procedure CombinePoFiles( SL : TStrings; const FName : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_LrtPoTools_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Lrt2Po, 'Lrt2Po', cdRegister);
 S.RegisterDelphiFunction(@CombinePoFiles, 'CombinePoFiles', cdRegister);
end;

 
 
{ TPSImport_LrtPoTools }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LrtPoTools.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LrtPoTools(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LrtPoTools.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_LrtPoTools(ri);
  RIRegister_LrtPoTools_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
