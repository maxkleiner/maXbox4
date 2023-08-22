unit uPSI_fMain;
{
code implementing the class wrapper 
as an OpenToolsAPI to modify the maXbox GUI - V3.5 -V3.7.1 , version check
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
  TPSImport_fMain = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMaxForm1(CL: TPSPascalCompiler);
procedure SIRegister_fMain(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMaxForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_fMain(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,Menus
  ,ExtCtrls
  ,Controls
  ,StdCtrls
  //,SynEditHighlighter
  ,SynHighlighterPas
  ,SynEdit
  ,SynMemo
  ,SynEditMiscClasses
  ,SynEditSearch
  ,XPMan
  ,Buttons
  ,Dialogs
  ,uPSComponent_Default
  //,Messages
  ,uPSComponent_Controls
  ,SynCompletionProposal
  ,SynEditPrint
  ,SynEditAutoComplete
  //,ImgList
  ,ComCtrls
  //,ToolWin
  //,Graphics
  ,uPSDebugger
  ,uPSDisassembly
  //,uPSComponent_COM
  //,uPSComponent_StdCtrls
  //,uPSComponent_Forms
  //,uPSComponent_DB
  ,SynHighlighterHtml
  ,SynHighlighterTeX
  ,fMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_fMain]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMaxForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TMaxForm1') do
  //RegClassS(CL, 'TGraphicControl', 'TToolButton');
  with CL.AddClassN(CL.FindClass('TGraphicControl'), 'TToolButton')  do begin
    RegisterProperty('CAPTION', 'STRING', iptrw);
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('FONT', 'TFONT', iptrw);
  end;

  //with CL.AddClassN(CL.FindClass('TComponent'), 'TMenuItem') do begin
    //RegisterProperty('CAPTION', 'STRING', iptrw);
  //end;
  //with CL.AddClassN(CL.FindClass('TMaxForm1'),'MaxForm1') do begin
   CL.AddClassN(CL.FindClass('TSynEdit'),'TSynMemo');


  with CL.AddClassN(CL.FindClass('TForm'),'TMaxForm1') do begin
    RegisterProperty('memo2', 'TMemo', iptrw);
    RegisterProperty('memo1', 'TSynMemo', iptrw);
    RegisterProperty('Splitter1', 'TSplitter', iptrw);
    RegisterProperty('PSScript', 'TPSScript', iptrw);
    RegisterProperty('PS3DllPlugin', 'TPSDllPlugin', iptrw);
    RegisterProperty('MainMenu1', 'TMainMenu', iptrw);
    RegisterProperty('Program1', 'TMenuItem', iptrw);
    RegisterProperty('Compile1', 'TMenuItem', iptrw);
    RegisterProperty('Files1', 'TMenuItem', iptrw);
    RegisterProperty('open1', 'TMenuItem', iptrw);
    RegisterProperty('Save2', 'TMenuItem', iptrw);
    RegisterProperty('Options1', 'TMenuItem', iptrw);
    RegisterProperty('Savebefore1', 'TMenuItem', iptrw);
    RegisterProperty('Largefont1', 'TMenuItem', iptrw);
    RegisterProperty('sBytecode1', 'TMenuItem', iptrw);
    RegisterProperty('Saveas3', 'TMenuItem', iptrw);
    RegisterProperty('Clear1', 'TMenuItem', iptrw);
    RegisterProperty('Slinenumbers1', 'TMenuItem', iptrw);
    RegisterProperty('About1', 'TMenuItem', iptrw);
    RegisterProperty('Search1', 'TMenuItem', iptrw);
    RegisterProperty('SynPasSyn1', 'TSynPasSyn', iptrw);
    RegisterProperty('memo1', 'TSynMemo', iptrw);
    RegisterProperty('SynEditSearch1', 'TSynEditSearch', iptrw);
    RegisterProperty('WordWrap1', 'TMenuItem', iptrw);
    RegisterProperty('XPManifest1', 'TXPManifest', iptrw);
    RegisterProperty('SearchNext1', 'TMenuItem', iptrw);
    RegisterProperty('Replace1', 'TMenuItem', iptrw);
    RegisterProperty('PSImport_Controls1', 'TPSImport_Controls', iptrw);
    RegisterProperty('PSImport_Classes1', 'TPSImport_Classes', iptrw);
    RegisterProperty('ShowInclude1', 'TMenuItem', iptrw);
    RegisterProperty('SynEditPrint1', 'TSynEditPrint', iptrw);
    RegisterProperty('Printout1', 'TMenuItem', iptrw);
    RegisterProperty('mnPrintColors1', 'TMenuItem', iptrw);
    RegisterProperty('dlgFilePrint', 'TPrintDialog', iptrw);
    RegisterProperty('dlgPrintFont1', 'TFontDialog', iptrw);
    RegisterProperty('mnuPrintFont1', 'TMenuItem', iptrw);
    RegisterProperty('Include1', 'TMenuItem', iptrw);
    RegisterProperty('CodeCompletionList1', 'TMenuItem', iptrw);
    RegisterProperty('IncludeList1', 'TMenuItem', iptrw);
    RegisterProperty('ImageList1', 'TImageList', iptrw);
    RegisterProperty('ImageList2', 'TImageList', iptrw);
    RegisterProperty('CoolBar1', 'TCoolBar', iptrw);
    RegisterProperty('ToolBar1', 'TToolBar', iptrw);
    RegisterProperty('tbtnLoad', 'TToolButton', iptrw);
    RegisterProperty('ToolButton2', 'TToolButton', iptrw);
    RegisterProperty('tbtnFind', 'TToolButton', iptrw);
    RegisterProperty('tbtnCompile', 'TToolButton', iptrw);
    RegisterProperty('tbtnTrans', 'TToolButton', iptrw);
    RegisterProperty('tbtnUseCase', 'TToolButton', iptrw);   //3.8
    RegisterProperty('toolbtnTutorial', 'TToolButton', iptrw);
    RegisterProperty('tbtn6res', 'TToolButton', iptrw);
    RegisterProperty('ToolButton5', 'TToolButton', iptrw);
    RegisterProperty('ToolButton1', 'TToolButton', iptrw);
    RegisterProperty('ToolButton3', 'TToolButton', iptrw);
    RegisterProperty('statusBar1', 'TStatusBar', iptrw);
    RegisterProperty('SaveOutput1', 'TMenuItem', iptrw);
    RegisterProperty('ExportClipboard1', 'TMenuItem', iptrw);
    RegisterProperty('Close1', 'TMenuItem', iptrw);
    RegisterProperty('Manual1', 'TMenuItem', iptrw);
    RegisterProperty('About2', 'TMenuItem', iptrw);
    RegisterProperty('loadLastfile1', 'TMenuItem', iptrw);
    RegisterProperty('imglogo', 'TImage', iptrw);
    RegisterProperty('cedebug', 'TPSScriptDebugger', iptrw);
    RegisterProperty('debugPopupMenu1', 'TPopupMenu', iptrw);
    RegisterProperty('BreakPointMenu', 'TMenuItem', iptrw);
    RegisterProperty('Decompile1', 'TMenuItem', iptrw);
    RegisterProperty('N2', 'TMenuItem', iptrw);
    RegisterProperty('StepInto1', 'TMenuItem', iptrw);
    RegisterProperty('StepOut1', 'TMenuItem', iptrw);
    RegisterProperty('Reset1', 'TMenuItem', iptrw);
    RegisterProperty('N3', 'TMenuItem', iptrw);
    RegisterProperty('DebugRun1', 'TMenuItem', iptrw);
    RegisterProperty('PSImport_ComObj1', 'TPSImport_ComObj', iptrw);
    RegisterProperty('PSImport_StdCtrls1', 'TPSImport_StdCtrls', iptrw);
    RegisterProperty('PSImport_Forms1', 'TPSImport_Forms', iptrw);
    RegisterProperty('PSImport_DateUtils1', 'TPSImport_DateUtils', iptrw);
    RegisterProperty('tutorial4', 'TMenuItem', iptrw);
    RegisterProperty('ExporttoClipboard1', 'TMenuItem', iptrw);
    RegisterProperty('ImportfromClipboard1', 'TMenuItem', iptrw);
    RegisterProperty('N4', 'TMenuItem', iptrw);
    RegisterProperty('N5', 'TMenuItem', iptrw);
    RegisterProperty('N6', 'TMenuItem', iptrw);
    RegisterProperty('ImportfromClipboard2', 'TMenuItem', iptrw);
    RegisterProperty('tutorial1', 'TMenuItem', iptrw);
    RegisterProperty('N7', 'TMenuItem', iptrw);
    RegisterProperty('ShowSpecChars1', 'TMenuItem', iptrw);
    RegisterProperty('OpenDirectory1', 'TMenuItem', iptrw);
    RegisterProperty('procMess', 'TMenuItem', iptrw);
    RegisterProperty('tbtnUseCase', 'TToolButton', iptrw);
    RegisterProperty('ToolButton7', 'TToolButton', iptrw);
    RegisterProperty('EditFont1', 'TMenuItem', iptrw);
    RegisterProperty('UseCase1', 'TMenuItem', iptrw);
    RegisterProperty('tutorial21', 'TMenuItem', iptrw);
    RegisterProperty('OpenUseCase1', 'TMenuItem', iptrw);
    RegisterProperty('PSImport_DB1', 'TPSImport_DB', iptrw);
    RegisterProperty('tutorial31', 'TMenuItem', iptrw);
    RegisterProperty('SynHTMLSyn1', 'TSynHTMLSyn', iptrw);
    RegisterProperty('HTMLSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('ShowInterfaces1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial5', 'TMenuItem', iptrw);
    RegisterProperty('AllFunctionsList1', 'TMenuItem', iptrw);
    RegisterProperty('ShowLastException1', 'TMenuItem', iptrw);
    RegisterProperty('PlayMP31', 'TMenuItem', iptrw);
    RegisterProperty('SynTeXSyn1', 'TSynTeXSyn', iptrw);
    RegisterProperty('texSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('N8', 'TMenuItem', iptrw);
    RegisterProperty('GetEMails1', 'TMenuItem', iptrw);
    RegisterMethod('Procedure IFPS3ClassesPlugin1CompImport( Sender : TObject; x : TPSPascalCompiler)');
    RegisterMethod('Procedure IFPS3ClassesPlugin1ExecImport( Sender : TObject; Exec : TPSExec; x : TPSRuntimeClassImporter)');
    RegisterMethod('Procedure PSScriptCompile( Sender : TPSScript)');
    RegisterMethod('Procedure Compile1Click( Sender : TObject)');
    RegisterMethod('Procedure PSScriptExecute( Sender : TPSScript)');
    RegisterMethod('Procedure open1Click( Sender : TObject)');
    RegisterMethod('Procedure Save2Click( Sender : TObject)');
    RegisterMethod('Procedure Savebefore1Click( Sender : TObject)');
    RegisterMethod('Procedure Largefont1Click( Sender : TObject)');
    RegisterMethod('Procedure FormActivate( Sender : TObject)');
    RegisterMethod('Procedure SBytecode1Click( Sender : TObject)');
    RegisterMethod('Procedure FormKeyPress( Sender : TObject; var Key : Char)');
    RegisterMethod('Procedure Saveas3Click( Sender : TObject)');
    RegisterMethod('Procedure Clear1Click( Sender : TObject)');
    RegisterMethod('Procedure Slinenumbers1Click( Sender : TObject)');
    RegisterMethod('Procedure About1Click( Sender : TObject)');
    RegisterMethod('Procedure Search1Click( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure Memo1ReplaceText( Sender : TObject; const ASearch, AReplace : String; Line, Column : Integer; var Action : TSynReplaceAction)');
    RegisterMethod('Procedure Memo1StatusChange( Sender : TObject; Changes : TSynStatusChanges)');
    RegisterMethod('Procedure WordWrap1Click( Sender : TObject)');
    RegisterMethod('Procedure SearchNext1Click( Sender : TObject)');
    RegisterMethod('Procedure Replace1Click( Sender : TObject)');
    RegisterMethod('Function PSScriptNeedFile( Sender : TObject; const OrginFileName : String; var FileName, Output : String) : Boolean');
    RegisterMethod('Procedure ShowInclude1Click( Sender : TObject)');
    RegisterMethod('Procedure Printout1Click( Sender : TObject)');
    RegisterMethod('Procedure mnuPrintFont1Click( Sender : TObject)');
    RegisterMethod('Procedure Include1Click( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure UpdateView1Click( Sender : TObject)');
    RegisterMethod('Procedure CodeCompletionList1Click( Sender : TObject)');
    RegisterMethod('Procedure SaveOutput1Click( Sender : TObject)');
    RegisterMethod('Procedure ExportClipboard1Click( Sender : TObject)');
    RegisterMethod('Procedure Close1Click( Sender : TObject)');
    RegisterMethod('Procedure Manual1Click( Sender : TObject)');
    RegisterMethod('Procedure LoadLastFile1Click( Sender : TObject)');
    RegisterMethod('Procedure Memo1Change( Sender : TObject)');
    RegisterMethod('Procedure Decompile1Click( Sender : TObject)');
    RegisterMethod('Procedure StepInto1Click( Sender : TObject)');
    RegisterMethod('Procedure StepOut1Click( Sender : TObject)');
    RegisterMethod('Procedure Reset1Click( Sender : TObject)');
    RegisterMethod('Procedure cedebugAfterExecute( Sender : TPSScript)');
    RegisterMethod('Procedure cedebugBreakpoint( Sender : TObject; const FileName : String; Position, Row, Col : Cardinal)');
    RegisterMethod('Procedure cedebugCompile( Sender : TPSScript)');
    RegisterMethod('Procedure cedebugExecute( Sender : TPSScript)');
    RegisterMethod('Procedure cedebugIdle( Sender : TObject)');
    RegisterMethod('Procedure cedebugLineInfo( Sender : TObject; const FileName : String; Position, Row, Col : Cardinal)');
    RegisterMethod('Procedure Memo1SpecialLineColors( Sender : TObject; Line : Integer; var Special : Boolean; var FG, BG : TColor)');
    RegisterMethod('Procedure BreakPointMenuClick( Sender : TObject)');
    RegisterMethod('Procedure DebugRun1Click( Sender : TObject)');
    RegisterMethod('Procedure tutorial4Click( Sender : TObject)');
    RegisterMethod('Procedure ImportfromClipboard1Click( Sender : TObject)');
    RegisterMethod('Procedure ImportfromClipboard2Click( Sender : TObject)');
    RegisterMethod('Procedure tutorial1Click( Sender : TObject)');
    RegisterMethod('Procedure ShowSpecChars1Click( Sender : TObject)');
    RegisterMethod('Procedure StatusBar1DblClick( Sender : TObject)');
    RegisterMethod('Procedure PSScriptLine( Sender : TObject)');
    RegisterMethod('Procedure OpenDirectory1Click( Sender : TObject)');
    RegisterMethod('Procedure procMessClick( Sender : TObject)');
    RegisterMethod('Procedure tbtnUseCaseClick( Sender : TObject)');
    RegisterMethod('Procedure EditFont1Click( Sender : TObject)');
    RegisterMethod('Procedure tutorial21Click( Sender : TObject)');
    RegisterMethod('Procedure tutorial31Click( Sender : TObject)');
    RegisterMethod('Procedure HTMLSyntax1Click( Sender : TObject)');
    RegisterMethod('Procedure ShowInterfaces1Click( Sender : TObject)');
    RegisterMethod('Procedure Tutorial5Click( Sender : TObject)');
    RegisterMethod('Procedure ShowLastException1Click( Sender : TObject)');
    RegisterMethod('Procedure PlayMP31Click( Sender : TObject)');
    RegisterMethod('Procedure AllFunctionsList1Click( Sender : TObject)');
    RegisterMethod('Procedure texSyntax1Click( Sender : TObject)');
    RegisterMethod('Procedure GetEMails1Click( Sender : TObject)');
    RegisterMethod('procedure DelphiSite1Click(Sender: TObject);');
    RegisterMethod('procedure TerminalStyle1Click(Sender: TObject);');
    RegisterMethod('procedure ReadOnly1Click(Sender: TObject);');
    RegisterMethod('procedure ShellStyle1Click(Sender: TObject);');
    RegisterMethod('procedure Console1Click(Sender: TObject);');     //3.2
    RegisterMethod('procedure BigScreen1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial91Click(Sender: TObject);');
    RegisterMethod('procedure SaveScreenshotClick(Sender: TObject);');
    RegisterMethod('procedure Tutorial101Click(Sender: TObject);');
    RegisterMethod('procedure SQLSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure XMLSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure ComponentCount1Click(Sender: TObject);');
    RegisterMethod('procedure NewInstance1Click(Sender: TObject);');

    RegisterMethod('procedure CSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial6Click(Sender: TObject);');
    RegisterMethod('procedure New1Click(Sender: TObject);');
    RegisterMethod('procedure AllObjectsList1Click(Sender: TObject);');
    RegisterMethod('procedure LoadBytecode1Click(Sender: TObject);');
    RegisterMethod('procedure CipherFile1Click(Sender: TObject);');
    //V3.5
    RegisterMethod('procedure NewInstance1Click(Sender: TObject);');
    RegisterMethod('procedure toolbtnTutorialClick(Sender: TObject);');
    RegisterMethod('procedure Memory1Click(Sender: TObject);');
    RegisterMethod('procedure JavaSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure SyntaxCheck1Click(Sender: TObject);');
    RegisterMethod('procedure ScriptExplorer1Click(Sender: TObject);');
    RegisterMethod('procedure FormOutput1Click(Sender: TObject);');
    //V3.6
    RegisterMethod('procedure GotoEnd1Click(Sender: TObject);');
    RegisterMethod('procedure AllResourceList1Click(Sender: TObject);');
    RegisterMethod('procedure tbtn6resClick(Sender: TObject);');
    //V3.7
    RegisterMethod('procedure Info1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial10Statistics1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial11Forms1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial12SQL1Click(Sender: TObject);');
    //V3.8
    RegisterMethod('procedure ResourceExplore1Click(Sender: TObject);');
    RegisterMethod('procedure Info1Click(Sender: TObject);');
    RegisterMethod('procedure CryptoBox1Click(Sender: TObject);');
    RegisterMethod('procedure ModulesCount1Click(Sender: TObject);');
    RegisterMethod('procedure N4GewinntGame1Click(Sender: TObject);');





   //RegisterMethod('procedure Console1Click(Sender: TObject);');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_fMain(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('BYTECODE','String').SetString( 'bytecode.txt');
 CL.AddConstantN('PSTEXT','String').SetString( 'PS Scriptfiles (*.txt)|*.TXT');
 CL.AddConstantN('PSMODEL','String').SetString( 'PS Modelfiles (*.uc)|*.UC');
 CL.AddConstantN('PSPASCAL','String').SetString( 'PS Pascalfiles (*.pas)|*.PAS');
 CL.AddConstantN('PSINC','String').SetString( 'PS Includes (*.inc)|*.INC');
 CL.AddConstantN('DEFFILENAME','String').SetString( 'firstdemo.txt');
 CL.AddConstantN('DEFINIFILE','String').SetString( 'maxboxdef.ini');
 CL.AddConstantN('EXCEPTLOGFILE','String').SetString( 'maxboxerrorlog.txt');
 CL.AddConstantN('INCLUDEBOX','String').SetString('pas_includebox.inc');
 CL.AddConstantN('BOOTSCRIPT','String').SetString('maxbootscript.txt');
 CL.AddConstantN('MBVERSION','String').SetString( '3.8.4.0');
 CL.AddConstantN('MBVER','String').SetString( '384');
 CL.AddConstantN('MXSITE','String').SetString( 'http://www.softwareschule.ch/maxbox.htm');
 CL.AddConstantN('MXMAIL','String').SetString( 'max@kleiner.com');
 CL.AddConstantN('TAB','Char').SetString( #$09);
 CL.AddConstantN('CODECOMPLETION','String').SetString('bds_delphi.dci');
  SIRegister_TMaxForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMaxForm1GetEMails1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.GetEMails1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1GetEMails1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.GetEMails1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N8_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N8_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N8; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1texSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.texSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1texSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.texSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynTeXSyn1_W(Self: TMaxForm1; const T: TSynTeXSyn);
Begin Self.SynTeXSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynTeXSyn1_R(Self: TMaxForm1; var T: TSynTeXSyn);
Begin T := Self.SynTeXSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PlayMP31_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.PlayMP31 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PlayMP31_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.PlayMP31; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowLastException1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ShowLastException1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowLastException1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ShowLastException1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AllFunctionsList1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.AllFunctionsList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AllFunctionsList1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.AllFunctionsList1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial5_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial5_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial5; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowInterfaces1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ShowInterfaces1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowInterfaces1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ShowInterfaces1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HTMLSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.HTMLSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HTMLSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.HTMLSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynHTMLSyn1_W(Self: TMaxForm1; const T: TSynHTMLSyn);
Begin Self.SynHTMLSyn1:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynHTMLSyn1_R(Self: TMaxForm1; var T: TSynHTMLSyn);
Begin T := Self.SynHTMLSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial31_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.tutorial31 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial31_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.tutorial31; end;

(*----------------------------------------------------------------------------*)
{procedure TMaxForm1PSImport_DB1_W(Self: TMaxForm1; const T: TPSImport_DB);
Begin Self.PSImport_DB1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_DB1_R(Self: TMaxForm1; var T: TPSImport_DB);
Begin T := Self.PSImport_DB1; end; }

(*----------------------------------------------------------------------------*)
procedure TMaxForm1OpenUseCase1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.OpenUseCase1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1OpenUseCase1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.OpenUseCase1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial21_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.tutorial21 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial21_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.tutorial21; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1UseCase1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.UseCase1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1UseCase1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.UseCase1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EditFont1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.EditFont1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EditFont1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.EditFont1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton7_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.ToolButton7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton7_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.ToolButton7; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnUseCase_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtnUseCase := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnUseCase_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtnUseCase; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1procMess_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.procMess := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1procMess_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.procMess; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1OpenDirectory1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.OpenDirectory1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1OpenDirectory1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.OpenDirectory1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowSpecChars1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ShowSpecChars1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowSpecChars1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ShowSpecChars1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N7_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N7_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N7; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.tutorial1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.tutorial1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImportfromClipboard2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ImportfromClipboard2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImportfromClipboard2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ImportfromClipboard2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N6_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N6_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N6; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N5_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N5_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N5; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N4_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N4_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N4; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImportfromClipboard1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ImportfromClipboard1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImportfromClipboard1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ImportfromClipboard1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ExporttoClipboard1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ExporttoClipboard1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ExporttoClipboard1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ExporttoClipboard1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial4_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.tutorial4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tutorial4_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.tutorial4; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_DateUtils1_W(Self: TMaxForm1; const T: TPSImport_DateUtils);
Begin Self.PSImport_DateUtils1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_DateUtils1_R(Self: TMaxForm1; var T: TPSImport_DateUtils);
Begin T := Self.PSImport_DateUtils1; end;

(*----------------------------------------------------------------------------*)
{procedure TMaxForm1PSImport_Forms1_W(Self: TMaxForm1; const T: TPSImport_Forms);
Begin Self.PSImport_Forms1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_Forms1_R(Self: TMaxForm1; var T: TPSImport_Forms);
Begin T := Self.PSImport_Forms1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_StdCtrls1_W(Self: TMaxForm1; const T: TPSImport_StdCtrls);
Begin Self.PSImport_StdCtrls1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_StdCtrls1_R(Self: TMaxForm1; var T: TPSImport_StdCtrls);
Begin T := Self.PSImport_StdCtrls1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_ComObj1_W(Self: TMaxForm1; const T: TPSImport_ComObj);
Begin Self.PSImport_ComObj1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_ComObj1_R(Self: TMaxForm1; var T: TPSImport_ComObj);
Begin T := Self.PSImport_ComObj1; end;  }

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DebugRun1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.DebugRun1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DebugRun1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.DebugRun1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N3_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N3_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N3; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Reset1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Reset1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Reset1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Reset1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1StepOut1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.StepOut1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1StepOut1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.StepOut1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1StepInto1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.StepInto1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1StepInto1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.StepInto1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Decompile1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Decompile1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Decompile1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Decompile1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BreakPointMenu_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.BreakPointMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BreakPointMenu_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.BreakPointMenu; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1debugPopupMenu1_W(Self: TMaxForm1; const T: TPopupMenu);
Begin Self.debugPopupMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1debugPopupMenu1_R(Self: TMaxForm1; var T: TPopupMenu);
Begin T := Self.debugPopupMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1cedebug_W(Self: TMaxForm1; const T: TPSScriptDebugger);
Begin Self.cedebug := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1cedebug_R(Self: TMaxForm1; var T: TPSScriptDebugger);
Begin T := Self.cedebug; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1imglogo_W(Self: TMaxForm1; const T: TImage);
Begin Self.imglogo := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1imglogo_R(Self: TMaxForm1; var T: TImage);
Begin T := Self.imglogo; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1loadLastfile1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.loadLastfile1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1loadLastfile1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.loadLastfile1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1About2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.About2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1About2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.About2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Manual1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Manual1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Manual1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Manual1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Close1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Close1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Close1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Close1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ExportClipboard1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ExportClipboard1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ExportClipboard1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ExportClipboard1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SaveOutput1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SaveOutput1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SaveOutput1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SaveOutput1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1statusBar1_W(Self: TMaxForm1; const T: TStatusBar);
Begin Self.statusBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1statusBar1_R(Self: TMaxForm1; var T: TStatusBar);
Begin T := Self.statusBar1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton3_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.ToolButton3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton3_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.ToolButton3; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton1_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.ToolButton1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton1_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.ToolButton1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton5_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.ToolButton5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton5_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.ToolButton5; end;


(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnUC_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtnUseCase:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnUC_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtnUseCase; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtntut_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.toolbtnTutorial:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtntut_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.toolbtnTutorial; end;
(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnres_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtn6res:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnres_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtn6res; end;



(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnTrans_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtnTrans := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnTrans_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtnTrans; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnCompile_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtnCompile := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnCompile_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtnCompile; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnFind_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtnFind := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnFind_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtnFind; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton2_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.ToolButton2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton2_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.ToolButton2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnLoad_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtnLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnLoad_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtnLoad; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolBar1_W(Self: TMaxForm1; const T: TToolBar);
Begin Self.ToolBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolBar1_R(Self: TMaxForm1; var T: TToolBar);
Begin T := Self.ToolBar1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CoolBar1_W(Self: TMaxForm1; const T: TCoolBar);
Begin Self.CoolBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CoolBar1_R(Self: TMaxForm1; var T: TCoolBar);
Begin T := Self.CoolBar1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImageList2_W(Self: TMaxForm1; const T: TImageList);
Begin Self.ImageList2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImageList2_R(Self: TMaxForm1; var T: TImageList);
Begin T := Self.ImageList2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImageList1_W(Self: TMaxForm1; const T: TImageList);
Begin Self.ImageList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImageList1_R(Self: TMaxForm1; var T: TImageList);
Begin T := Self.ImageList1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IncludeList1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.IncludeList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IncludeList1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.IncludeList1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CodeCompletionList1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CodeCompletionList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CodeCompletionList1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CodeCompletionList1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Include1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Include1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Include1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Include1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnuPrintFont1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.mnuPrintFont1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnuPrintFont1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.mnuPrintFont1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1dlgPrintFont1_W(Self: TMaxForm1; const T: TFontDialog);
Begin Self.dlgPrintFont1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1dlgPrintFont1_R(Self: TMaxForm1; var T: TFontDialog);
Begin T := Self.dlgPrintFont1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1dlgFilePrint_W(Self: TMaxForm1; const T: TPrintDialog);
Begin Self.dlgFilePrint := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1dlgFilePrint_R(Self: TMaxForm1; var T: TPrintDialog);
Begin T := Self.dlgFilePrint; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnPrintColors1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.mnPrintColors1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnPrintColors1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.mnPrintColors1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Printout1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Printout1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Printout1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Printout1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynEditPrint1_W(Self: TMaxForm1; const T: TSynEditPrint);
Begin Self.SynEditPrint1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynEditPrint1_R(Self: TMaxForm1; var T: TSynEditPrint);
Begin T := Self.SynEditPrint1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowInclude1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ShowInclude1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShowInclude1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ShowInclude1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_Classes1_W(Self: TMaxForm1; const T: TPSImport_Classes);
Begin Self.PSImport_Classes1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_Classes1_R(Self: TMaxForm1; var T: TPSImport_Classes);
Begin T := Self.PSImport_Classes1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_Controls1_W(Self: TMaxForm1; const T: TPSImport_Controls);
Begin Self.PSImport_Controls1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSImport_Controls1_R(Self: TMaxForm1; var T: TPSImport_Controls);
Begin T := Self.PSImport_Controls1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Replace1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Replace1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Replace1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Replace1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SearchNext1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SearchNext1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SearchNext1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SearchNext1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1XPManifest1_W(Self: TMaxForm1; const T: TXPManifest);
Begin Self.XPManifest1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1XPManifest1_R(Self: TMaxForm1; var T: TXPManifest);
Begin T := Self.XPManifest1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1WordWrap1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.WordWrap1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1WordWrap1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.WordWrap1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynEditSearch1_W(Self: TMaxForm1; const T: TSynEditSearch);
Begin Self.SynEditSearch1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynEditSearch1_R(Self: TMaxForm1; var T: TSynEditSearch);
Begin T := Self.SynEditSearch1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1memo1_W(Self: TMaxForm1; const T: TSynMemo);
Begin Self.memo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1memo1_R(Self: TMaxForm1; var T: TSynMemo);
Begin T := Self.memo1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPasSyn1_W(Self: TMaxForm1; const T: TSynPasSyn);
Begin Self.SynPasSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPasSyn1_R(Self: TMaxForm1; var T: TSynPasSyn);
Begin T := Self.SynPasSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Search1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Search1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Search1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Search1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1About1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.About1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1About1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.About1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Slinenumbers1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Slinenumbers1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Slinenumbers1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Slinenumbers1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Clear1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Clear1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Clear1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Clear1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Saveas3_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Saveas3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Saveas3_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Saveas3; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1sBytecode1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.sBytecode1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1sBytecode1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.sBytecode1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Largefont1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Largefont1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Largefont1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Largefont1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Savebefore1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Savebefore1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Savebefore1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Savebefore1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Options1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Options1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Options1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Options1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Save2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Save2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Save2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Save2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1open1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.open1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1open1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.open1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Files1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Files1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Files1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Files1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Compile1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Compile1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Compile1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Compile1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Program1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Program1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Program1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Program1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1MainMenu1_W(Self: TMaxForm1; const T: TMainMenu);
Begin Self.MainMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1MainMenu1_R(Self: TMaxForm1; var T: TMainMenu);
Begin T := Self.MainMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PS3DllPlugin_W(Self: TMaxForm1; const T: TPSDllPlugin);
Begin Self.PS3DllPlugin := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PS3DllPlugin_R(Self: TMaxForm1; var T: TPSDllPlugin);
Begin T := Self.PS3DllPlugin; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSScript_W(Self: TMaxForm1; const T: TPSScript);
Begin Self.PSScript := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PSScript_R(Self: TMaxForm1; var T: TPSScript);
Begin T := Self.PSScript; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Splitter1_W(Self: TMaxForm1; const T: TSplitter);
Begin Self.Splitter1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Splitter1_R(Self: TMaxForm1; var T: TSplitter);
Begin T := Self.Splitter1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1memo2_W(Self: TMaxForm1; const T: TMemo);
Begin Self.memo2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1memo2_R(Self: TMaxForm1; var T: TMemo);
Begin T := Self.memo2; end;

(*----------------------------------------------------------------------------*)
{procedure TMaxForm1memo1_W(Self: TMaxForm1; const T: TSynMemo);
Begin Self.memo1:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1memo1_R(Self: TMaxForm1; var T: TSynMemo);
Begin T := Self.memo1; end;}


procedure TMaxForm1ToolButton_Caption_R(Self: TToolButton; var T: STRING);
 begin T := Self.caption; end;

procedure TMaxForm1ToolButton_Caption_W(Self: TToolButton; T: STRING);
  begin Self.caption:= T; end;


//procedure TAPPLICATIONHINTCOLOR_R(Self: TAPPLICATION; var T: TCOLOR); begin T := Self.HINTCOLOR; end;
//procedure TAPPLICATIONHINTCOLOR_W(Self: TAPPLICATION; T: TCOLOR); begin Self.HINTCOLOR := T; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TMaxForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolButton) do begin
   RegisterPropertyHelper(@TMaxForm1ToolButton_Caption_R,
            @TMaxForm1ToolButton_Caption_W, 'CAPTION');
  end;

  with CL.Add(TMaxForm1) do begin
    RegisterPropertyHelper(@TMaxForm1memo2_R,@TMaxForm1memo2_W,'memo2');
    RegisterPropertyHelper(@TMaxForm1memo1_R,@TMaxForm1memo1_W,'memo1');
    RegisterPropertyHelper(@TMaxForm1Splitter1_R,@TMaxForm1Splitter1_W,'Splitter1');
    RegisterPropertyHelper(@TMaxForm1PSScript_R,@TMaxForm1PSScript_W,'PSScript');
    RegisterPropertyHelper(@TMaxForm1PS3DllPlugin_R,@TMaxForm1PS3DllPlugin_W,'PS3DllPlugin');
    RegisterPropertyHelper(@TMaxForm1MainMenu1_R,@TMaxForm1MainMenu1_W,'MainMenu1');
    RegisterPropertyHelper(@TMaxForm1Program1_R,@TMaxForm1Program1_W,'Program1');
    RegisterPropertyHelper(@TMaxForm1Compile1_R,@TMaxForm1Compile1_W,'Compile1');
    RegisterPropertyHelper(@TMaxForm1Files1_R,@TMaxForm1Files1_W,'Files1');
    RegisterPropertyHelper(@TMaxForm1open1_R,@TMaxForm1open1_W,'open1');
    RegisterPropertyHelper(@TMaxForm1Save2_R,@TMaxForm1Save2_W,'Save2');
    RegisterPropertyHelper(@TMaxForm1Options1_R,@TMaxForm1Options1_W,'Options1');
    RegisterPropertyHelper(@TMaxForm1Savebefore1_R,@TMaxForm1Savebefore1_W,'Savebefore1');
    RegisterPropertyHelper(@TMaxForm1Largefont1_R,@TMaxForm1Largefont1_W,'Largefont1');
    RegisterPropertyHelper(@TMaxForm1sBytecode1_R,@TMaxForm1sBytecode1_W,'sBytecode1');
    RegisterPropertyHelper(@TMaxForm1Saveas3_R,@TMaxForm1Saveas3_W,'Saveas3');
    RegisterPropertyHelper(@TMaxForm1Clear1_R,@TMaxForm1Clear1_W,'Clear1');
    RegisterPropertyHelper(@TMaxForm1Slinenumbers1_R,@TMaxForm1Slinenumbers1_W,'Slinenumbers1');
    RegisterPropertyHelper(@TMaxForm1About1_R,@TMaxForm1About1_W,'About1');
    RegisterPropertyHelper(@TMaxForm1Search1_R,@TMaxForm1Search1_W,'Search1');
    RegisterPropertyHelper(@TMaxForm1SynPasSyn1_R,@TMaxForm1SynPasSyn1_W,'SynPasSyn1');
    RegisterPropertyHelper(@TMaxForm1memo1_R,@TMaxForm1memo1_W,'memo1');
    RegisterPropertyHelper(@TMaxForm1SynEditSearch1_R,@TMaxForm1SynEditSearch1_W,'SynEditSearch1');
    RegisterPropertyHelper(@TMaxForm1WordWrap1_R,@TMaxForm1WordWrap1_W,'WordWrap1');
    RegisterPropertyHelper(@TMaxForm1XPManifest1_R,@TMaxForm1XPManifest1_W,'XPManifest1');
    RegisterPropertyHelper(@TMaxForm1SearchNext1_R,@TMaxForm1SearchNext1_W,'SearchNext1');
    RegisterPropertyHelper(@TMaxForm1Replace1_R,@TMaxForm1Replace1_W,'Replace1');
    RegisterPropertyHelper(@TMaxForm1PSImport_Controls1_R,@TMaxForm1PSImport_Controls1_W,'PSImport_Controls1');
    RegisterPropertyHelper(@TMaxForm1PSImport_Classes1_R,@TMaxForm1PSImport_Classes1_W,'PSImport_Classes1');
    RegisterPropertyHelper(@TMaxForm1ShowInclude1_R,@TMaxForm1ShowInclude1_W,'ShowInclude1');
    RegisterPropertyHelper(@TMaxForm1SynEditPrint1_R,@TMaxForm1SynEditPrint1_W,'SynEditPrint1');
    RegisterPropertyHelper(@TMaxForm1Printout1_R,@TMaxForm1Printout1_W,'Printout1');
    RegisterPropertyHelper(@TMaxForm1mnPrintColors1_R,@TMaxForm1mnPrintColors1_W,'mnPrintColors1');
    RegisterPropertyHelper(@TMaxForm1dlgFilePrint_R,@TMaxForm1dlgFilePrint_W,'dlgFilePrint');
    RegisterPropertyHelper(@TMaxForm1dlgPrintFont1_R,@TMaxForm1dlgPrintFont1_W,'dlgPrintFont1');
    RegisterPropertyHelper(@TMaxForm1mnuPrintFont1_R,@TMaxForm1mnuPrintFont1_W,'mnuPrintFont1');
    RegisterPropertyHelper(@TMaxForm1Include1_R,@TMaxForm1Include1_W,'Include1');
    RegisterPropertyHelper(@TMaxForm1CodeCompletionList1_R,@TMaxForm1CodeCompletionList1_W,'CodeCompletionList1');
    RegisterPropertyHelper(@TMaxForm1IncludeList1_R,@TMaxForm1IncludeList1_W,'IncludeList1');
    RegisterPropertyHelper(@TMaxForm1ImageList1_R,@TMaxForm1ImageList1_W,'ImageList1');
    RegisterPropertyHelper(@TMaxForm1ImageList2_R,@TMaxForm1ImageList2_W,'ImageList2');
    RegisterPropertyHelper(@TMaxForm1CoolBar1_R,@TMaxForm1CoolBar1_W,'CoolBar1');
    RegisterPropertyHelper(@TMaxForm1ToolBar1_R,@TMaxForm1ToolBar1_W,'ToolBar1');
    RegisterPropertyHelper(@TMaxForm1tbtnLoad_R,@TMaxForm1tbtnLoad_W,'tbtnLoad');
    RegisterPropertyHelper(@TMaxForm1ToolButton2_R,@TMaxForm1ToolButton2_W,'ToolButton2');
    RegisterPropertyHelper(@TMaxForm1tbtnFind_R,@TMaxForm1tbtnFind_W,'tbtnFind');
    RegisterPropertyHelper(@TMaxForm1tbtnCompile_R,@TMaxForm1tbtnCompile_W,'tbtnCompile');
    RegisterPropertyHelper(@TMaxForm1tbtnTrans_R,@TMaxForm1tbtnTrans_W,'tbtnTrans');
    RegisterPropertyHelper(@TMaxForm1tbtnUC_R,@TMaxForm1tbtnUC_W,'tbtnUseCase');
    RegisterPropertyHelper(@TMaxForm1tbtntut_R,@TMaxForm1tbtntut_W,'toolbtnTutorial');
    RegisterPropertyHelper(@TMaxForm1tbtnres_R,@TMaxForm1tbtnres_W,'tbtn6res');
    RegisterPropertyHelper(@TMaxForm1ToolButton5_R,@TMaxForm1ToolButton5_W,'ToolButton5');
    RegisterPropertyHelper(@TMaxForm1ToolButton1_R,@TMaxForm1ToolButton1_W,'ToolButton1');
    RegisterPropertyHelper(@TMaxForm1ToolButton3_R,@TMaxForm1ToolButton3_W,'ToolButton3');
    RegisterPropertyHelper(@TMaxForm1statusBar1_R,@TMaxForm1statusBar1_W,'statusBar1');
    RegisterPropertyHelper(@TMaxForm1SaveOutput1_R,@TMaxForm1SaveOutput1_W,'SaveOutput1');
    RegisterPropertyHelper(@TMaxForm1ExportClipboard1_R,@TMaxForm1ExportClipboard1_W,'ExportClipboard1');
    RegisterPropertyHelper(@TMaxForm1Close1_R,@TMaxForm1Close1_W,'Close1');
    RegisterPropertyHelper(@TMaxForm1Manual1_R,@TMaxForm1Manual1_W,'Manual1');
    RegisterPropertyHelper(@TMaxForm1About2_R,@TMaxForm1About2_W,'About2');
    RegisterPropertyHelper(@TMaxForm1loadLastfile1_R,@TMaxForm1loadLastfile1_W,'loadLastfile1');
    RegisterPropertyHelper(@TMaxForm1imglogo_R,@TMaxForm1imglogo_W,'imglogo');
    RegisterPropertyHelper(@TMaxForm1cedebug_R,@TMaxForm1cedebug_W,'cedebug');
    RegisterPropertyHelper(@TMaxForm1debugPopupMenu1_R,@TMaxForm1debugPopupMenu1_W,'debugPopupMenu1');
    RegisterPropertyHelper(@TMaxForm1BreakPointMenu_R,@TMaxForm1BreakPointMenu_W,'BreakPointMenu');
    RegisterPropertyHelper(@TMaxForm1Decompile1_R,@TMaxForm1Decompile1_W,'Decompile1');
    RegisterPropertyHelper(@TMaxForm1N2_R,@TMaxForm1N2_W,'N2');
    RegisterPropertyHelper(@TMaxForm1StepInto1_R,@TMaxForm1StepInto1_W,'StepInto1');
    RegisterPropertyHelper(@TMaxForm1StepOut1_R,@TMaxForm1StepOut1_W,'StepOut1');
    RegisterPropertyHelper(@TMaxForm1Reset1_R,@TMaxForm1Reset1_W,'Reset1');
    RegisterPropertyHelper(@TMaxForm1N3_R,@TMaxForm1N3_W,'N3');
    RegisterPropertyHelper(@TMaxForm1DebugRun1_R,@TMaxForm1DebugRun1_W,'DebugRun1');
   // RegisterPropertyHelper(@TMaxForm1PSImport_ComObj1_R,@TMaxForm1PSImport_ComObj1_W,'PSImport_ComObj1');
    //RegisterPropertyHelper(@TMaxForm1PSImport_StdCtrls1_R,@TMaxForm1PSImport_StdCtrls1_W,'PSImport_StdCtrls1');
    //RegisterPropertyHelper(@TMaxForm1PSImport_Forms1_R,@TMaxForm1PSImport_Forms1_W,'PSImport_Forms1');
    //RegisterPropertyHelper(@TMaxForm1PSImport_DateUtils1_R,@TMaxForm1PSImport_DateUtils1_W,'PSImport_DateUtils1');
    RegisterPropertyHelper(@TMaxForm1tutorial4_R,@TMaxForm1tutorial4_W,'tutorial4');
    RegisterPropertyHelper(@TMaxForm1ExporttoClipboard1_R,@TMaxForm1ExporttoClipboard1_W,'ExporttoClipboard1');
    RegisterPropertyHelper(@TMaxForm1ImportfromClipboard1_R,@TMaxForm1ImportfromClipboard1_W,'ImportfromClipboard1');
    RegisterPropertyHelper(@TMaxForm1N4_R,@TMaxForm1N4_W,'N4');
    RegisterPropertyHelper(@TMaxForm1N5_R,@TMaxForm1N5_W,'N5');
    RegisterPropertyHelper(@TMaxForm1N6_R,@TMaxForm1N6_W,'N6');
    RegisterPropertyHelper(@TMaxForm1ImportfromClipboard2_R,@TMaxForm1ImportfromClipboard2_W,'ImportfromClipboard2');
    RegisterPropertyHelper(@TMaxForm1tutorial1_R,@TMaxForm1tutorial1_W,'tutorial1');
    RegisterPropertyHelper(@TMaxForm1N7_R,@TMaxForm1N7_W,'N7');
    RegisterPropertyHelper(@TMaxForm1ShowSpecChars1_R,@TMaxForm1ShowSpecChars1_W,'ShowSpecChars1');
    RegisterPropertyHelper(@TMaxForm1OpenDirectory1_R,@TMaxForm1OpenDirectory1_W,'OpenDirectory1');
    RegisterPropertyHelper(@TMaxForm1procMess_R,@TMaxForm1procMess_W,'procMess');
    RegisterPropertyHelper(@TMaxForm1tbtnUseCase_R,@TMaxForm1tbtnUseCase_W,'tbtnUseCase');
    RegisterPropertyHelper(@TMaxForm1ToolButton7_R,@TMaxForm1ToolButton7_W,'ToolButton7');
    RegisterPropertyHelper(@TMaxForm1EditFont1_R,@TMaxForm1EditFont1_W,'EditFont1');
    RegisterPropertyHelper(@TMaxForm1UseCase1_R,@TMaxForm1UseCase1_W,'UseCase1');
    RegisterPropertyHelper(@TMaxForm1tutorial21_R,@TMaxForm1tutorial21_W,'tutorial21');
    RegisterPropertyHelper(@TMaxForm1OpenUseCase1_R,@TMaxForm1OpenUseCase1_W,'OpenUseCase1');
    //RegisterPropertyHelper(@TMaxForm1PSImport_DB1_R,@TMaxForm1PSImport_DB1_W,'PSImport_DB1');
    RegisterPropertyHelper(@TMaxForm1tutorial31_R,@TMaxForm1tutorial31_W,'tutorial31');
    RegisterPropertyHelper(@TMaxForm1SynHTMLSyn1_R,@TMaxForm1SynHTMLSyn1_W,'SynHTMLSyn1');
    RegisterPropertyHelper(@TMaxForm1HTMLSyntax1_R,@TMaxForm1HTMLSyntax1_W,'HTMLSyntax1');
    RegisterPropertyHelper(@TMaxForm1ShowInterfaces1_R,@TMaxForm1ShowInterfaces1_W,'ShowInterfaces1');
    RegisterPropertyHelper(@TMaxForm1Tutorial5_R,@TMaxForm1Tutorial5_W,'Tutorial5');
    RegisterPropertyHelper(@TMaxForm1AllFunctionsList1_R,@TMaxForm1AllFunctionsList1_W,'AllFunctionsList1');
    RegisterPropertyHelper(@TMaxForm1ShowLastException1_R,@TMaxForm1ShowLastException1_W,'ShowLastException1');
    RegisterPropertyHelper(@TMaxForm1PlayMP31_R,@TMaxForm1PlayMP31_W,'PlayMP31');
    RegisterPropertyHelper(@TMaxForm1SynTeXSyn1_R,@TMaxForm1SynTeXSyn1_W,'SynTeXSyn1');
    RegisterPropertyHelper(@TMaxForm1texSyntax1_R,@TMaxForm1texSyntax1_W,'texSyntax1');
    RegisterPropertyHelper(@TMaxForm1N8_R,@TMaxForm1N8_W,'N8');
    RegisterPropertyHelper(@TMaxForm1GetEMails1_R,@TMaxForm1GetEMails1_W,'GetEMails1');
    RegisterMethod(@TMaxForm1.IFPS3ClassesPlugin1CompImport, 'IFPS3ClassesPlugin1CompImport');
    RegisterMethod(@TMaxForm1.IFPS3ClassesPlugin1ExecImport, 'IFPS3ClassesPlugin1ExecImport');
    RegisterMethod(@TMaxForm1.PSScriptCompile, 'PSScriptCompile');
    RegisterMethod(@TMaxForm1.Compile1Click, 'Compile1Click');
    RegisterMethod(@TMaxForm1.PSScriptExecute, 'PSScriptExecute');
    RegisterMethod(@TMaxForm1.open1Click, 'open1Click');
    RegisterMethod(@TMaxForm1.Save2Click, 'Save2Click');
    RegisterMethod(@TMaxForm1.Savebefore1Click, 'Savebefore1Click');
    RegisterMethod(@TMaxForm1.Largefont1Click, 'Largefont1Click');
    RegisterMethod(@TMaxForm1.FormActivate, 'FormActivate');
    RegisterMethod(@TMaxForm1.SBytecode1Click, 'SBytecode1Click');
    RegisterMethod(@TMaxForm1.FormKeyPress, 'FormKeyPress');
    RegisterMethod(@TMaxForm1.Saveas3Click, 'Saveas3Click');
    RegisterMethod(@TMaxForm1.Clear1Click, 'Clear1Click');
    RegisterMethod(@TMaxForm1.Slinenumbers1Click, 'Slinenumbers1Click');
    RegisterMethod(@TMaxForm1.About1Click, 'About1Click');
    RegisterMethod(@TMaxForm1.Search1Click, 'Search1Click');
    RegisterMethod(@TMaxForm1.FormCreate, 'FormCreate');
    RegisterMethod(@TMaxForm1.Memo1ReplaceText, 'Memo1ReplaceText');
    RegisterMethod(@TMaxForm1.Memo1StatusChange, 'Memo1StatusChange');
    RegisterMethod(@TMaxForm1.WordWrap1Click, 'WordWrap1Click');
    RegisterMethod(@TMaxForm1.SearchNext1Click, 'SearchNext1Click');
    RegisterMethod(@TMaxForm1.Replace1Click, 'Replace1Click');
    RegisterMethod(@TMaxForm1.PSScriptNeedFile, 'PSScriptNeedFile');
    RegisterMethod(@TMaxForm1.ShowInclude1Click, 'ShowInclude1Click');
    RegisterMethod(@TMaxForm1.Printout1Click, 'Printout1Click');
    RegisterMethod(@TMaxForm1.mnuPrintFont1Click, 'mnuPrintFont1Click');
    RegisterMethod(@TMaxForm1.Include1Click, 'Include1Click');
    RegisterMethod(@TMaxForm1.FormDestroy, 'FormDestroy');
    RegisterMethod(@TMaxForm1.FormClose, 'FormClose');
    RegisterMethod(@TMaxForm1.UpdateView1Click, 'UpdateView1Click');
    RegisterMethod(@TMaxForm1.CodeCompletionList1Click, 'CodeCompletionList1Click');
    RegisterMethod(@TMaxForm1.SaveOutput1Click, 'SaveOutput1Click');
    RegisterMethod(@TMaxForm1.ExportClipboard1Click, 'ExportClipboard1Click');
    RegisterMethod(@TMaxForm1.Close1Click, 'Close1Click');
    RegisterMethod(@TMaxForm1.Manual1Click, 'Manual1Click');
    RegisterMethod(@TMaxForm1.LoadLastFile1Click, 'LoadLastFile1Click');
    RegisterMethod(@TMaxForm1.Memo1Change, 'Memo1Change');
    RegisterMethod(@TMaxForm1.Decompile1Click, 'Decompile1Click');
    RegisterMethod(@TMaxForm1.StepInto1Click, 'StepInto1Click');
    RegisterMethod(@TMaxForm1.StepOut1Click, 'StepOut1Click');
    RegisterMethod(@TMaxForm1.Reset1Click, 'Reset1Click');
    RegisterMethod(@TMaxForm1.cedebugAfterExecute, 'cedebugAfterExecute');
    RegisterMethod(@TMaxForm1.cedebugBreakpoint, 'cedebugBreakpoint');
    RegisterMethod(@TMaxForm1.cedebugCompile, 'cedebugCompile');
    RegisterMethod(@TMaxForm1.cedebugExecute, 'cedebugExecute');
    RegisterMethod(@TMaxForm1.cedebugIdle, 'cedebugIdle');
    RegisterMethod(@TMaxForm1.cedebugLineInfo, 'cedebugLineInfo');
    RegisterMethod(@TMaxForm1.Memo1SpecialLineColors, 'Memo1SpecialLineColors');
    RegisterMethod(@TMaxForm1.BreakPointMenuClick, 'BreakPointMenuClick');
    RegisterMethod(@TMaxForm1.DebugRun1Click, 'DebugRun1Click');
    RegisterMethod(@TMaxForm1.tutorial4Click, 'tutorial4Click');
    RegisterMethod(@TMaxForm1.ImportfromClipboard1Click, 'ImportfromClipboard1Click');
    RegisterMethod(@TMaxForm1.ImportfromClipboard2Click, 'ImportfromClipboard2Click');
    RegisterMethod(@TMaxForm1.tutorial1Click, 'tutorial1Click');
    RegisterMethod(@TMaxForm1.ShowSpecChars1Click, 'ShowSpecChars1Click');
    RegisterMethod(@TMaxForm1.StatusBar1DblClick, 'StatusBar1DblClick');
    RegisterMethod(@TMaxForm1.PSScriptLine, 'PSScriptLine');
    RegisterMethod(@TMaxForm1.OpenDirectory1Click, 'OpenDirectory1Click');
    RegisterMethod(@TMaxForm1.procMessClick, 'procMessClick');
    RegisterMethod(@TMaxForm1.tbtnUseCaseClick, 'tbtnUseCaseClick');
    RegisterMethod(@TMaxForm1.EditFont1Click, 'EditFont1Click');
    RegisterMethod(@TMaxForm1.tutorial21Click, 'tutorial21Click');
    RegisterMethod(@TMaxForm1.tutorial31Click, 'tutorial31Click');
    RegisterMethod(@TMaxForm1.HTMLSyntax1Click, 'HTMLSyntax1Click');
    RegisterMethod(@TMaxForm1.ShowInterfaces1Click, 'ShowInterfaces1Click');
    RegisterMethod(@TMaxForm1.Tutorial5Click, 'Tutorial5Click');
    RegisterMethod(@TMaxForm1.ShowLastException1Click, 'ShowLastException1Click');
    RegisterMethod(@TMaxForm1.PlayMP31Click, 'PlayMP31Click');
    RegisterMethod(@TMaxForm1.AllFunctionsList1Click, 'AllFunctionsList1Click');
    RegisterMethod(@TMaxForm1.texSyntax1Click, 'texSyntax1Click');
    RegisterMethod(@TMaxForm1.GetEMails1Click, 'GetEMails1Click');
    RegisterMethod(@TMaxForm1.DelphiSite1Click, 'DelphiSite1Click');
    RegisterMethod(@TMaxForm1.TerminalStyle1Click,'TerminalStyle1Click');
    RegisterMethod(@TMaxForm1.ReadOnly1Click, 'ReadOnly1Click');
    RegisterMethod(@TMaxForm1.ShellStyle1Click, 'ShellStyle1Click');

    RegisterMethod(@TMaxForm1.Console1Click,'Console1Click');     //3.2
    RegisterMethod(@TMaxForm1.BigScreen1Click,'BigScreen1Click');
    RegisterMethod(@TMaxForm1.Tutorial91Click,'Tutorial91Click');
    RegisterMethod(@TMaxForm1.SaveScreenshotClick,'SaveScreenshotClick');
    RegisterMethod(@TMaxForm1.Tutorial101Click,'Tutorial101Click');
    RegisterMethod(@TMaxForm1.SQLSyntax1Click,'SQLSyntax1Click');
    RegisterMethod(@TMaxForm1.XMLSyntax1Click,'XMLSyntax1Click');
    RegisterMethod(@TMaxForm1.ComponentCount1Click,'ComponentCount1Click');
    RegisterMethod(@TMaxForm1.NewInstance1Click,'NewInstance1Click');
    RegisterMethod(@TMaxForm1.CSyntax1Click,'CSyntax1Click');
    RegisterMethod(@TMaxForm1.Tutorial6Click,'Tutorial6Click');
    RegisterMethod(@TMaxForm1.New1Click,'New1Click');
    RegisterMethod(@TMaxForm1.AllObjectsList1Click,'AllObjectsList1Click');
    RegisterMethod(@TMaxForm1.LoadBytecode1Click,'LoadBytecode1Click');
    RegisterMethod(@TMaxForm1.CipherFile1Click,'CipherFile1Click');
    RegisterMethod(@TMaxForm1.NewInstance1Click, 'NewInstance1Click');
    RegisterMethod(@TMaxForm1.toolbtnTutorialClick, 'toolbtnTutorialClick');
    RegisterMethod(@TMaxForm1.Memory1Click, 'Memory1Click');
    RegisterMethod(@TMaxForm1.JavaSyntax1Click, 'JavaSyntax1Click');
    RegisterMethod(@TMaxForm1.SyntaxCheck1Click,'SyntaxCheck1Click');
    RegisterMethod(@TMaxForm1.ScriptExplorer1Click,'ScriptExplorer1Click');
    RegisterMethod(@TMaxForm1.FormOutput1Click, 'FormOutput1Click');
    RegisterMethod(@TMaxForm1.GotoEnd1Click, 'GotoEnd1Click');
    RegisterMethod(@TMaxForm1.AllResourceList1Click, 'AllResourceList1Click');
    RegisterMethod(@TMaxForm1.tbtn6resClick, 'tbtn6resClick');
    RegisterMethod(@TMaxForm1.Info1Click, 'Info1Click');
    RegisterMethod(@TMaxForm1.Tutorial10Statistics1Click, 'Tutorial10Statistics1Click');
    RegisterMethod(@TMaxForm1.Tutorial11Forms1Click, 'Tutorial11Forms1Click');
    RegisterMethod(@TMaxForm1.Tutorial12SQL1Click, 'Tutorial12SQL1Click');
    RegisterMethod(@TMaxForm1.ResourceExplore1Click, 'ResourceExplore1Click');
    RegisterMethod(@TMaxForm1.Info1Click, 'Info1Click');
    RegisterMethod(@TMaxForm1.CryptoBox1Click, 'CryptoBox1Click');
    RegisterMethod(@TMaxForm1.ModulesCount1Click, 'ModulesCount1Click');
    RegisterMethod(@TMaxForm1.N4GewinntGame1Click, 'N4GewinntGame1Click');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_fMain(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMaxForm1(CL);
end;

{ TPSImport_fMain }
(*----------------------------------------------------------------------------*)
procedure TPSImport_fMain.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_fMain(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_fMain.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_fMain(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
