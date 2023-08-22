unit uPSI_TGA;
{
   last graph
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
  TPSImport_TGA = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ETGAException(CL: TPSPascalCompiler);
procedure SIRegister_TTGAImage(CL: TPSPascalCompiler);
procedure SIRegister_TGA(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ETGAException(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTGAImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGA(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   GLCrossPlatform
  ,TGA
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TGA]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ETGAException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ETGAException') do
  with CL.AddClassN(CL.FindClass('Exception'),'ETGAException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTGAImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLBitmap', 'TTGAImage') do
  with CL.AddClassN(CL.FindClass('TGLBitmap'),'TTGAImage') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromStream( stream : TStream)');
    RegisterMethod('Procedure SaveToStream( stream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGA(CL: TPSPascalCompiler);
begin
  SIRegister_TTGAImage(CL);
  SIRegister_ETGAException(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ETGAException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ETGAException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTGAImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTGAImage) do begin
    RegisterConstructor(@TTGAImage.Create, 'Create');
            RegisterMethod(@TTGAImage.Destroy, 'Free');
    RegisterMethod(@TTGAImage.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TTGAImage.SaveToStream, 'SaveToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGA(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTGAImage(CL);
  RIRegister_ETGAException(CL);
end;

 
 
{ TPSImport_TGA }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TGA.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TGA(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TGA.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TGA(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
