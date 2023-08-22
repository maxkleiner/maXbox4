unit uPSI_DTDSchema;
{
  before XML
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
  TPSImport_DTDSchema = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDTDImportTranslator(CL: TPSPascalCompiler);
procedure SIRegister_TDTDBaseTranslator(CL: TPSPascalCompiler);
procedure SIRegister_DTDSchema(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDTDImportTranslator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDTDBaseTranslator(CL: TPSRuntimeClassImporter);
procedure RIRegister_DTDSchema(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   XMLSchema
  ,XMLDOM
  ,DTDSchema
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DTDSchema]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDTDImportTranslator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDTDBaseTranslator', 'TDTDImportTranslator') do
  with CL.AddClassN(CL.FindClass('TDTDBaseTranslator'),'TDTDImportTranslator') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDTDBaseTranslator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXMLSchemaTranslator', 'TDTDBaseTranslator') do
  with CL.AddClassN(CL.FindClass('TXMLSchemaTranslator'),'TDTDBaseTranslator') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DTDSchema(CL: TPSPascalCompiler);
begin
  SIRegister_TDTDBaseTranslator(CL);
  SIRegister_TDTDImportTranslator(CL);
 CL.AddConstantN('DTDExtension','String').SetString( '.dtd');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TDTDImportTranslator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDTDImportTranslator) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDTDBaseTranslator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDTDBaseTranslator) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DTDSchema(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDTDBaseTranslator(CL);
  RIRegister_TDTDImportTranslator(CL);
end;

 
 
{ TPSImport_DTDSchema }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DTDSchema.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DTDSchema(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DTDSchema.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DTDSchema(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
