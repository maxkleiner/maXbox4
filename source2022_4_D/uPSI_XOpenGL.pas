unit uPSI_XOpenGL;
{
   the road to open gl cl
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
  TPSImport_XOpenGL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_XOpenGL(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_XOpenGL_Routines(S: TPSExec);

procedure Register;

implementation


uses
   OpenGL1x
  ,XOpenGL
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XOpenGL]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_XOpenGL(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMapTexCoordMode', '(mtcmUndefined, mtcmNull, mtcmMain, mtcmDual, mtcmSecond, mtcmArbitrary )');
 CL.AddDelphiFunction('Procedure xglMapTexCoordToNull');
 CL.AddDelphiFunction('Procedure xglMapTexCoordToMain');
 CL.AddDelphiFunction('Procedure xglMapTexCoordToSecond');
 CL.AddDelphiFunction('Procedure xglMapTexCoordToDual');
 CL.AddDelphiFunction('Procedure xglMapTexCoordToArbitrary( const units : array of Cardinal);');
 CL.AddDelphiFunction('Procedure xglMapTexCoordToArbitrary1( const bitWiseUnits : Cardinal);');
 CL.AddDelphiFunction('Procedure xglMapTexCoordToArbitraryAdd( const bitWiseUnits : Cardinal)');
 CL.AddDelphiFunction('Procedure xglBeginUpdate');
 CL.AddDelphiFunction('Procedure xglEndUpdate');
 CL.AddDelphiFunction('Procedure xglPushState');
 CL.AddDelphiFunction('Procedure xglPopState');
 CL.AddDelphiFunction('Procedure xglForbidSecondTextureUnit');
 CL.AddDelphiFunction('Procedure xglAllowSecondTextureUnit');
 CL.AddDelphiFunction('Function xglGetBitWiseMapping : Cardinal');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure xglMapTexCoordToArbitrary1_P( const bitWiseUnits : Cardinal);
Begin XOpenGL.xglMapTexCoordToArbitrary(bitWiseUnits); END;

(*----------------------------------------------------------------------------*)
Procedure xglMapTexCoordToArbitrary_P( const units : array of Cardinal);
Begin XOpenGL.xglMapTexCoordToArbitrary(units); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XOpenGL_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@xglMapTexCoordToNull, 'xglMapTexCoordToNull', cdRegister);
 S.RegisterDelphiFunction(@xglMapTexCoordToMain, 'xglMapTexCoordToMain', cdRegister);
 S.RegisterDelphiFunction(@xglMapTexCoordToSecond, 'xglMapTexCoordToSecond', cdRegister);
 S.RegisterDelphiFunction(@xglMapTexCoordToDual, 'xglMapTexCoordToDual', cdRegister);
 S.RegisterDelphiFunction(@xglMapTexCoordToArbitrary, 'xglMapTexCoordToArbitrary', cdRegister);
 S.RegisterDelphiFunction(@xglMapTexCoordToArbitrary1_P, 'xglMapTexCoordToArbitrary1', cdRegister);
 S.RegisterDelphiFunction(@xglMapTexCoordToArbitraryAdd, 'xglMapTexCoordToArbitraryAdd', cdRegister);
 S.RegisterDelphiFunction(@xglBeginUpdate, 'xglBeginUpdate', cdRegister);
 S.RegisterDelphiFunction(@xglEndUpdate, 'xglEndUpdate', cdRegister);
 S.RegisterDelphiFunction(@xglPushState, 'xglPushState', cdRegister);
 S.RegisterDelphiFunction(@xglPopState, 'xglPopState', cdRegister);
 S.RegisterDelphiFunction(@xglForbidSecondTextureUnit, 'xglForbidSecondTextureUnit', cdRegister);
 S.RegisterDelphiFunction(@xglAllowSecondTextureUnit, 'xglAllowSecondTextureUnit', cdRegister);
 S.RegisterDelphiFunction(@xglGetBitWiseMapping, 'xglGetBitWiseMapping', cdRegister);
end;

 
 
{ TPSImport_XOpenGL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XOpenGL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XOpenGL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XOpenGL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_XOpenGL(ri);
  RIRegister_XOpenGL_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
