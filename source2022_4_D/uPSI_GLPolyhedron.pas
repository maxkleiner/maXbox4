unit uPSI_GLPolyhedron;
{
   gl poly star start art
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
  TPSImport_GLPolyhedron = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGLIcosahedron(CL: TPSPascalCompiler);
procedure SIRegister_TGLDodecahedron(CL: TPSPascalCompiler);
procedure SIRegister_GLPolyhedron(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGLIcosahedron(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLDodecahedron(CL: TPSRuntimeClassImporter);
procedure RIRegister_GLPolyhedron(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   GLScene
  ,GLTexture
  ,VectorGeometry
  ,OpenGL1x
  ,GLMisc
  ,GLPolyhedron
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLPolyhedron]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLIcosahedron(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLSceneObject', 'TGLIcosahedron') do
  with CL.AddClassN(CL.FindClass('TGLSceneObject'),'TGLIcosahedron') do begin
     RegisterMethod('Procedure BuildList( var rci : TRenderContextInfo)');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLDodecahedron(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLSceneObject', 'TGLDodecahedron') do
  with CL.AddClassN(CL.FindClass('TGLSceneObject'),'TGLDodecahedron') do begin
     RegisterMethod('Procedure BuildList( var rci : TRenderContextInfo)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GLPolyhedron(CL: TPSPascalCompiler);
begin
  SIRegister_TGLDodecahedron(CL);
  SIRegister_TGLIcosahedron(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLIcosahedron(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLIcosahedron) do begin
      RegisterMethod(@TGLIcosahedron.BuildList, 'BuildList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLDodecahedron(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLDodecahedron) do begin
      RegisterMethod(@TGLDodecahedron.BuildList, 'BuildList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLPolyhedron(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGLDodecahedron(CL);
  RIRegister_TGLIcosahedron(CL);
end;

 
 
{ TPSImport_GLPolyhedron }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLPolyhedron.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLPolyhedron(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLPolyhedron.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GLPolyhedron(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
