unit uPSI_uhyper;
{
   for C to D
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
  TPSImport_uhyper = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uhyper(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uhyper_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,uminmax
  ,uhyper
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uhyper]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uhyper(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function uSinh( X : Float) : Float');
 CL.AddDelphiFunction('Function uCosh( X : Float) : Float');
 CL.AddDelphiFunction('Function uTanh( X : Float) : Float');
 CL.AddDelphiFunction('Function uArcSinh( X : Float) : Float');
 CL.AddDelphiFunction('Function uArcCosh( X : Float) : Float');
 CL.AddDelphiFunction('Function ArcTanh( X : Float) : Float');
 CL.AddDelphiFunction('Procedure SinhCosh( X : Float; var SinhX, CoshX : Float)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uhyper_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Sinh, 'uSinh', cdRegister);
 S.RegisterDelphiFunction(@Cosh, 'uCosh', cdRegister);
 S.RegisterDelphiFunction(@Tanh, 'uTanh', cdRegister);
 S.RegisterDelphiFunction(@ArcSinh, 'uArcSinh', cdRegister);
 S.RegisterDelphiFunction(@ArcCosh, 'uArcCosh', cdRegister);
 S.RegisterDelphiFunction(@ArcTanh, 'ArcTanh', cdRegister);
 S.RegisterDelphiFunction(@SinhCosh, 'SinhCosh', cdRegister);
end;

 
 
{ TPSImport_uhyper }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uhyper.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uhyper(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uhyper.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_uhyper(ri);
  RIRegister_uhyper_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
