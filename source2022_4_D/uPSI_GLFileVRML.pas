unit uPSI_GLFileVRML;
{
   wiht VRML Parser
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
  TPSImport_GLFileVRML = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGLVRMLVectorFile(CL: TPSPascalCompiler);
procedure SIRegister_GLFileVRML(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGLVRMLVectorFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_GLFileVRML(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   GLVectorFileObjects
  ,GLMisc
  ,GLTexture
  ,ApplicationFileIO
  ,VectorGeometry
  ,VectorLists
  ,VRMLParser
  ,MeshUtils
  ,GLFileVRML
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLFileVRML]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLVRMLVectorFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVectorFile', 'TGLVRMLVectorFile') do
  with CL.AddClassN(CL.FindClass('TVectorFile'),'TGLVRMLVectorFile') do begin
    RegisterMethod('Function Capabilities : TDataFileCapabilities');
    RegisterMethod('Procedure LoadFromStream( aStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GLFileVRML(CL: TPSPascalCompiler);
begin
  SIRegister_TGLVRMLVectorFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLVRMLVectorFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLVRMLVectorFile) do begin
     RegisterMethod(@TGLVRMLVectorFile.Capabilities, 'Capabilities');
    RegisterMethod(@TGLVRMLVectorFile.LoadFromStream, 'LoadFromStream');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLFileVRML(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGLVRMLVectorFile(CL);
end;

 
 
{ TPSImport_GLFileVRML }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLFileVRML.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLFileVRML(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLFileVRML.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GLFileVRML(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
