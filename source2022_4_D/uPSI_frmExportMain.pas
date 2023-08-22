unit uPSI_frmExportMain;
{
  direct export of code
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
  TPSImport_frmExportMain = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
procedure SIRegister_frmExportMain(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_frmExportMain(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,SynEdit
  ,Menus
  ,SynExportRTF
  ,SynEditExport
  ,SynExportHTML
  ,SynEditHighlighter
  ,SynHighlighterPas
  ,ComCtrls
  ,SynHighlighterDfm
  ,SynHighlighterCpp
  ,frmExportMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_frmExportMain]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TSynexportForm') do begin
    RegisterProperty('menuMain', 'TMainMenu', iptrw);
    RegisterProperty('mFile', 'TMenuItem', iptrw);
    RegisterProperty('miFileOpen', 'TMenuItem', iptrw);
    RegisterProperty('N1', 'TMenuItem', iptrw);
    RegisterProperty('miFileExit', 'TMenuItem', iptrw);
    RegisterProperty('SynEdit1', 'TSynEdit', iptrw);
    RegisterProperty('dlgFileOpen', 'TOpenDialog', iptrw);
    RegisterProperty('dlgFileSaveAs', 'TSaveDialog', iptrw);
    RegisterProperty('mExport', 'TMenuItem', iptrw);
    RegisterProperty('miExportToFile', 'TMenuItem', iptrw);
    RegisterProperty('Statusbar', 'TStatusBar', iptrw);
    RegisterProperty('SynExporterHTML1', 'TSynExporterHTML', iptrw);
    RegisterProperty('SynExporterRTF1', 'TSynExporterRTF', iptrw);
    RegisterProperty('miExportAsHTML', 'TMenuItem', iptrw);
    RegisterProperty('miExportAsRTF', 'TMenuItem', iptrw);
    RegisterProperty('miExportAllFormats', 'TMenuItem', iptrw);
    RegisterProperty('N2', 'TMenuItem', iptrw);
    RegisterProperty('N3', 'TMenuItem', iptrw);
    RegisterProperty('miExportClipboardNative', 'TMenuItem', iptrw);
    RegisterProperty('miExportClipboardText', 'TMenuItem', iptrw);
    RegisterProperty('SynCppSyn1', 'TSynCppSyn', iptrw);
    RegisterProperty('SynDfmSyn1', 'TSynDfmSyn', iptrw);
    RegisterProperty('SynPasSyn1', 'TSynPasSyn', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure miFileOpenClick( Sender : TObject)');
    RegisterMethod('Procedure miFileExitClick( Sender : TObject)');
    RegisterMethod('Procedure miExportToFileClick( Sender : TObject)');
    RegisterMethod('Procedure mExportClick( Sender : TObject)');
    RegisterMethod('Procedure miExportAsClicked( Sender : TObject)');
    RegisterMethod('Procedure miExportClipboardNativeClick( Sender : TObject)');
    RegisterMethod('Procedure miExportClipboardTextClick( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_frmExportMain(CL: TPSPascalCompiler);
begin
  SIRegister_TForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm1SynPasSyn1_W(Self: TSynexportForm; const T: TSynPasSyn);
Begin Self.SynPasSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynPasSyn1_R(Self: TSynexportform; var T: TSynPasSyn);
Begin T := Self.SynPasSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynDfmSyn1_W(Self: TSynexportform; const T: TSynDfmSyn);
Begin Self.SynDfmSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynDfmSyn1_R(Self: TSynexportform; var T: TSynDfmSyn);
Begin T := Self.SynDfmSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynCppSyn1_W(Self: TSynexportform; const T: TSynCppSyn);
Begin Self.SynCppSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynCppSyn1_R(Self: TSynexportform; var T: TSynCppSyn);
Begin T := Self.SynCppSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportClipboardText_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miExportClipboardText := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportClipboardText_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miExportClipboardText; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportClipboardNative_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miExportClipboardNative := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportClipboardNative_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miExportClipboardNative; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N3_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.N3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N3_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.N3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N2_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.N2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N2_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.N2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportAllFormats_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miExportAllFormats := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportAllFormats_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miExportAllFormats; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportAsRTF_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miExportAsRTF := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportAsRTF_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miExportAsRTF; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportAsHTML_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miExportAsHTML := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportAsHTML_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miExportAsHTML; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynExporterRTF1_W(Self: TSynexportform; const T: TSynExporterRTF);
Begin Self.SynExporterRTF1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynExporterRTF1_R(Self: TSynexportform; var T: TSynExporterRTF);
Begin T := Self.SynExporterRTF1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynExporterHTML1_W(Self: TSynexportform; const T: TSynExporterHTML);
Begin Self.SynExporterHTML1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynExporterHTML1_R(Self: TSynexportform; var T: TSynExporterHTML);
Begin T := Self.SynExporterHTML1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Statusbar_W(Self: TSynexportform; const T: TStatusBar);
Begin Self.Statusbar := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Statusbar_R(Self: TSynexportform; var T: TStatusBar);
Begin T := Self.Statusbar; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportToFile_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miExportToFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miExportToFile_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miExportToFile; end;

(*----------------------------------------------------------------------------*)
procedure TForm1mExport_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.mExport := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1mExport_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.mExport; end;

(*----------------------------------------------------------------------------*)
procedure TForm1dlgFileSaveAs_W(Self: TSynexportform; const T: TSaveDialog);
Begin Self.dlgFileSaveAs := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1dlgFileSaveAs_R(Self: TSynexportform; var T: TSaveDialog);
Begin T := Self.dlgFileSaveAs; end;

(*----------------------------------------------------------------------------*)
procedure TForm1dlgFileOpen_W(Self: TSynexportform; const T: TOpenDialog);
Begin Self.dlgFileOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1dlgFileOpen_R(Self: TSynexportform; var T: TOpenDialog);
Begin T := Self.dlgFileOpen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynEdit1_W(Self: TSynexportform; const T: TSynEdit);
Begin Self.SynEdit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SynEdit1_R(Self: TSynexportform; var T: TSynEdit);
Begin T := Self.SynEdit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miFileExit_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miFileExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miFileExit_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miFileExit; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N1_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.N1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N1_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.N1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miFileOpen_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.miFileOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1miFileOpen_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.miFileOpen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1mFile_W(Self: TSynexportform; const T: TMenuItem);
Begin Self.mFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1mFile_R(Self: TSynexportform; var T: TMenuItem);
Begin T := Self.mFile; end;

(*----------------------------------------------------------------------------*)
procedure TForm1menuMain_W(Self: TSynexportform; const T: TMainMenu);
Begin Self.menuMain := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1menuMain_R(Self: TSynexportform; var T: TMainMenu);
Begin T := Self.menuMain; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynexportform) do begin
    RegisterPropertyHelper(@TForm1menuMain_R,@TForm1menuMain_W,'menuMain');
    RegisterPropertyHelper(@TForm1mFile_R,@TForm1mFile_W,'mFile');
    RegisterPropertyHelper(@TForm1miFileOpen_R,@TForm1miFileOpen_W,'miFileOpen');
    RegisterPropertyHelper(@TForm1N1_R,@TForm1N1_W,'N1');
    RegisterPropertyHelper(@TForm1miFileExit_R,@TForm1miFileExit_W,'miFileExit');
    RegisterPropertyHelper(@TForm1SynEdit1_R,@TForm1SynEdit1_W,'SynEdit1');
    RegisterPropertyHelper(@TForm1dlgFileOpen_R,@TForm1dlgFileOpen_W,'dlgFileOpen');
    RegisterPropertyHelper(@TForm1dlgFileSaveAs_R,@TForm1dlgFileSaveAs_W,'dlgFileSaveAs');
    RegisterPropertyHelper(@TForm1mExport_R,@TForm1mExport_W,'mExport');
    RegisterPropertyHelper(@TForm1miExportToFile_R,@TForm1miExportToFile_W,'miExportToFile');
    RegisterPropertyHelper(@TForm1Statusbar_R,@TForm1Statusbar_W,'Statusbar');
    RegisterPropertyHelper(@TForm1SynExporterHTML1_R,@TForm1SynExporterHTML1_W,'SynExporterHTML1');
    RegisterPropertyHelper(@TForm1SynExporterRTF1_R,@TForm1SynExporterRTF1_W,'SynExporterRTF1');
    RegisterPropertyHelper(@TForm1miExportAsHTML_R,@TForm1miExportAsHTML_W,'miExportAsHTML');
    RegisterPropertyHelper(@TForm1miExportAsRTF_R,@TForm1miExportAsRTF_W,'miExportAsRTF');
    RegisterPropertyHelper(@TForm1miExportAllFormats_R,@TForm1miExportAllFormats_W,'miExportAllFormats');
    RegisterPropertyHelper(@TForm1N2_R,@TForm1N2_W,'N2');
    RegisterPropertyHelper(@TForm1N3_R,@TForm1N3_W,'N3');
    RegisterPropertyHelper(@TForm1miExportClipboardNative_R,@TForm1miExportClipboardNative_W,'miExportClipboardNative');
    RegisterPropertyHelper(@TForm1miExportClipboardText_R,@TForm1miExportClipboardText_W,'miExportClipboardText');
    RegisterPropertyHelper(@TForm1SynCppSyn1_R,@TForm1SynCppSyn1_W,'SynCppSyn1');
    RegisterPropertyHelper(@TForm1SynDfmSyn1_R,@TForm1SynDfmSyn1_W,'SynDfmSyn1');
    RegisterPropertyHelper(@TForm1SynPasSyn1_R,@TForm1SynPasSyn1_W,'SynPasSyn1');
    RegisterMethod(@TSynexportform.FormCreate, 'FormCreate');
    RegisterMethod(@TSynexportform.FormDestroy, 'FormDestroy');
    RegisterMethod(@TSynexportform.miFileOpenClick, 'miFileOpenClick');
    RegisterMethod(@TSynexportform.miFileExitClick, 'miFileExitClick');
    RegisterMethod(@TSynexportform.miExportToFileClick, 'miExportToFileClick');
    RegisterMethod(@TSynexportform.mExportClick, 'mExportClick');
    RegisterMethod(@TSynexportform.miExportAsClicked, 'miExportAsClicked');
    RegisterMethod(@TSynexportform.miExportClipboardNativeClick, 'miExportClipboardNativeClick');
    RegisterMethod(@TSynexportform.miExportClipboardTextClick, 'miExportClipboardTextClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_frmExportMain(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm1(CL);
end;

 
 
{ TPSImport_frmExportMain }
(*----------------------------------------------------------------------------*)
procedure TPSImport_frmExportMain.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_frmExportMain(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_frmExportMain.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_frmExportMain(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
