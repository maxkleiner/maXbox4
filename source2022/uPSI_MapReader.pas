unit uPSI_MapReader;
{
   step byound a pointer test
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
  TPSImport_MapReader = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MapReader(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MapReader_Routines(S: TPSExec);

procedure Register;

implementation


uses
  { Windows
  ,Messages
  ,Variants
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StrUtils
  ,StdCtrls
  ,Buttons
  ,ExtCtrls
  ,ShellAPI
  ,ComCtrls}
  MapReader
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MapReader]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MapReader(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure ClearModules');
 CL.AddDelphiFunction('Procedure ReadMapFile( Fname : string)');
 CL.AddDelphiFunction('Function AddressInfo( Address : dword) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_MapReader_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ClearModules, 'ClearModules', cdRegister);
 S.RegisterDelphiFunction(@ReadMapFile, 'ReadMapFile', cdRegister);
 S.RegisterDelphiFunction(@AddressInfo, 'AddressInfo', cdRegister);
end;

 
 
{ TPSImport_MapReader }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MapReader.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MapReader(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MapReader.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_MapReader(ri);
  RIRegister_MapReader_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
