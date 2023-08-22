unit uPSI_SynExportHTML;
{
  as menu and shell
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
  TPSImport_SynExportHTML = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TSynExporterHTML(CL: TPSPascalCompiler);
procedure SIRegister_SynExportHTML(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynExporterHTML(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynExportHTML(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 //  Qt
  //,QGraphics
  //,QSynEditExport
  //,QSynEditHighlighter
  //Windows
  //,Graphics
  SynEditExport
  ,SynEditHighlighter
  ,SynExportHTML
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynExportHTML]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynExporterHTML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomExporter', 'TSynExporterHTML') do
  with CL.AddClassN(CL.FindClass('TSynCustomExporter'),'TSynExporterHTML') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('CreateHTMLFragment', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynExportHTML(CL: TPSPascalCompiler);
begin
  SIRegister_TSynExporterHTML(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynExporterHTMLCreateHTMLFragment_W(Self: TSynExporterHTML; const T: boolean);
begin Self.CreateHTMLFragment := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynExporterHTMLCreateHTMLFragment_R(Self: TSynExporterHTML; var T: boolean);
begin T := Self.CreateHTMLFragment; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynExporterHTML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynExporterHTML) do begin
    RegisterConstructor(@TSynExporterHTML.Create, 'Create');
    RegisterMethod(@TSynExporterHTML.Destroy, 'Free');
    RegisterPropertyHelper(@TSynExporterHTMLCreateHTMLFragment_R,@TSynExporterHTMLCreateHTMLFragment_W,'CreateHTMLFragment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynExportHTML(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynExporterHTML(CL);
end;

 
 
{ TPSImport_SynExportHTML }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynExportHTML.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynExportHTML(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynExportHTML.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynExportHTML(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
