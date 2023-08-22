unit uPSI_StringGridLibrary;
{
  the grid for visualchrono
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
  TPSImport_StringGridLibrary = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StringGridLibrary(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StringGridLibrary_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Grids
  ,Graphics
  ,WinTypes
  ,StringGridLibrary
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StringGridLibrary]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StringGridLibrary(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure ReadGridFile( var StringGrid : TStringGrid; GridFile : STRING)');
 CL.AddDelphiFunction('Procedure WriteGridFile( var StringGrid : TStringGrid; GridFile : STRING)');
 CL.AddDelphiFunction('Procedure AddBlankRowToTop( var StringGrid : TStringGrid)');
 CL.AddDelphiFunction('Procedure DeleteSelectedRow( var StringGrid : TStringGrid)');
 CL.AddDelphiFunction('Function StringGridSearch( const StringGrid : TStringGrid; const column : INTEGER; const target : STRING) : INTEGER');
 CL.AddDelphiFunction('Function XLeft( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
 CL.AddDelphiFunction('Function XCenter( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
 CL.AddDelphiFunction('Function XRight( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
 CL.AddDelphiFunction('Function YCenter( rect : TRect; canvas : TCanvas; s : STRING) : INTEGER');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StringGridLibrary_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ReadGridFile, 'ReadGridFile', cdRegister);
 S.RegisterDelphiFunction(@WriteGridFile, 'WriteGridFile', cdRegister);
 S.RegisterDelphiFunction(@AddBlankRowToTop, 'AddBlankRowToTop', cdRegister);
 S.RegisterDelphiFunction(@DeleteSelectedRow, 'DeleteSelectedRow', cdRegister);
 S.RegisterDelphiFunction(@StringGridSearch, 'StringGridSearch', cdRegister);
 S.RegisterDelphiFunction(@XLeft, 'XLeft', cdRegister);
 S.RegisterDelphiFunction(@XCenter, 'XCenter', cdRegister);
 S.RegisterDelphiFunction(@XRight, 'XRight', cdRegister);
 S.RegisterDelphiFunction(@YCenter, 'YCenter', cdRegister);
end;

 
 
{ TPSImport_StringGridLibrary }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StringGridLibrary.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StringGridLibrary(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StringGridLibrary.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StringGridLibrary_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
