unit uPSI_LEDBitmaps;
{
   check the LED
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
  TPSImport_LEDBitmaps = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_LEDBitmaps(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_LEDBitmaps_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,LEDBitmaps
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LEDBitmaps]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_LEDBitmaps(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLEDColor', '( ledcGreen, ledcRed, ledcGray )');
 CL.AddDelphiFunction('Function GetLEDBitmapHandle( Color : TLEDColor; State : Boolean) : THandle');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_LEDBitmaps_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetLEDBitmapHandle, 'GetLEDBitmapHandle', cdRegister);
end;

 
 
{ TPSImport_LEDBitmaps }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LEDBitmaps.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LEDBitmaps(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LEDBitmaps.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_LEDBitmaps(ri);
  RIRegister_LEDBitmaps_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
