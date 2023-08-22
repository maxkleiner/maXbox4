unit uPSI_SynExportRTF;
{
   more export
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
  TPSImport_SynExportRTF = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynExporterRTF(CL: TPSPascalCompiler);
procedure SIRegister_SynExportRTF(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynExporterRTF(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynExportRTF(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // Qt
  //,QGraphics
  //,QSynEditExport
  //,Windows
  //,Graphics
  RichEdit
  ,SynEditExport
  ,SynExportRTF
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynExportRTF]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynExporterRTF(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomExporter', 'TSynExporterRTF') do
  with CL.AddClassN(CL.FindClass('TSynCustomExporter'),'TSynExporterRTF') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynExportRTF(CL: TPSPascalCompiler);
begin
  SIRegister_TSynExporterRTF(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynExporterRTF(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynExporterRTF) do begin
    RegisterConstructor(@TSynExporterRTF.Create, 'Create');
    RegisterMethod(@TSynExporterRTF.Destroy, 'Free');
    RegisterMethod(@TSynExporterRTF.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynExportRTF(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynExporterRTF(CL);
end;

 
 
{ TPSImport_SynExportRTF }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynExportRTF.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynExportRTF(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynExportRTF.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynExportRTF(ri);
end;
(*----------------------------------------------------------------------------*)
 

end.
