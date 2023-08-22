unit uPSI_SynEditExport;
{
    base class     , add constructor
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
  TPSImport_SynEditExport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynCustomExporter(CL: TPSPascalCompiler);
procedure SIRegister_SynEditExport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynCustomExporter(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditExport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 {  Libc
  ,Qt
  ,QGraphics
  ,Types
  ,QClipbrd
  ,QSynEditHighlighter
  ,QSynEditTypes
  ,Windows}
  Graphics
  ,Clipbrd
  ,SynEditHighlighter
  ,SynEditTypes
  ,SynEditExport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditExport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynCustomExporter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSynCustomExporter') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSynCustomExporter') do begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure ExportAll( ALines : TStrings)');
    RegisterMethod('Procedure ExportRange( ALines : TStrings; Start, Stop : TBufferCoord)');
    RegisterMethod('Procedure SaveToFile( const AFileName : string)');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('DefaultFilter', 'string', iptrw);
    RegisterProperty('ExportAsText', 'boolean', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('FormatName', 'string', iptr);
    RegisterProperty('Highlighter', 'TSynCustomHighlighter', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('UseBackground', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditExport(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PSynReplaceCharsArray', '^TSynReplaceCharsArray // will not work');
  SIRegister_TSynCustomExporter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterUseBackground_W(Self: TSynCustomExporter; const T: boolean);
begin Self.UseBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterUseBackground_R(Self: TSynCustomExporter; var T: boolean);
begin T := Self.UseBackground; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterTitle_W(Self: TSynCustomExporter; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterTitle_R(Self: TSynCustomExporter; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterHighlighter_W(Self: TSynCustomExporter; const T: TSynCustomHighlighter);
begin Self.Highlighter := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterHighlighter_R(Self: TSynCustomExporter; var T: TSynCustomHighlighter);
begin T := Self.Highlighter; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterFormatName_R(Self: TSynCustomExporter; var T: string);
begin T := Self.FormatName; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterFont_W(Self: TSynCustomExporter; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterFont_R(Self: TSynCustomExporter; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterExportAsText_W(Self: TSynCustomExporter; const T: boolean);
begin Self.ExportAsText := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterExportAsText_R(Self: TSynCustomExporter; var T: boolean);
begin T := Self.ExportAsText; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterDefaultFilter_W(Self: TSynCustomExporter; const T: string);
begin Self.DefaultFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterDefaultFilter_R(Self: TSynCustomExporter; var T: string);
begin T := Self.DefaultFilter; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterColor_W(Self: TSynCustomExporter; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomExporterColor_R(Self: TSynCustomExporter; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynCustomExporter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynCustomExporter) do begin
   RegisterConstructor(@TSynCustomExporter.Create, 'Create');
      RegisterMethod(@TSynCustomExporter.Destroy, 'Free');
       RegisterVirtualMethod(@TSynCustomExporter.Clear, 'Clear');
    RegisterMethod(@TSynCustomExporter.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TSynCustomExporter.ExportAll, 'ExportAll');
    RegisterMethod(@TSynCustomExporter.ExportRange, 'ExportRange');
    RegisterMethod(@TSynCustomExporter.SaveToFile, 'SaveToFile');
    RegisterMethod(@TSynCustomExporter.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TSynCustomExporterColor_R,@TSynCustomExporterColor_W,'Color');
    RegisterPropertyHelper(@TSynCustomExporterDefaultFilter_R,@TSynCustomExporterDefaultFilter_W,'DefaultFilter');
    RegisterPropertyHelper(@TSynCustomExporterExportAsText_R,@TSynCustomExporterExportAsText_W,'ExportAsText');
    RegisterPropertyHelper(@TSynCustomExporterFont_R,@TSynCustomExporterFont_W,'Font');
    RegisterPropertyHelper(@TSynCustomExporterFormatName_R,nil,'FormatName');
    RegisterPropertyHelper(@TSynCustomExporterHighlighter_R,@TSynCustomExporterHighlighter_W,'Highlighter');
    RegisterPropertyHelper(@TSynCustomExporterTitle_R,@TSynCustomExporterTitle_W,'Title');
    RegisterPropertyHelper(@TSynCustomExporterUseBackground_R,@TSynCustomExporterUseBackground_W,'UseBackground');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditExport(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynCustomExporter(CL);
end;

 
 
{ TPSImport_SynEditExport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditExport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditExport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditExport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditExport(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
