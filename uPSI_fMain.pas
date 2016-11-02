unit uPSI_fMain;
{
*******************Open Tools API Catalog***********************************
code implementing the class wrapper
as an OpenToolsAPI to modify the maXbox GUI - V3.5 -V3.8.6 , version check
   actual 3.9.8 , new ipport, comport, iphost, appname, open examples, intflist
   locs=   1624   , last is gotoline, intfnavlist, configfileclick
  DoEditorExecuteCommand(EditorCommand: word);
  Updated to 3.9.9.85 /80/82/91/94/95/96/98/100/101/110/120/160/190/195 ,420 locs=3787,
  MBVERIALL, ResetKeyPressed, arduino items, terminal;
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
  //,SynEditMiscClasses
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
  //,uPSDisassembly
  //,uPSComponent_COM
  //,uPSComponent_StdCtrls
  //,uPSComponent_Forms
  //,uPSComponent_DB
  ,SynHighlighterHtml
  ,SynHighlighterTeX
  ,fMain
  //,SynHighlighterHtml
  //,SynHighlighterTeX
  ,SynHighlighterCpp
  ,SynHighlighterSQL
  ,SynHighlighterXML
  ,SynHighlighterJava
  ,ide_debugoutput
  ,SynHighlighterPHP
  ,SynHighlighterCS
  ,SynEditExport
  ,SynExportHTML
  ,Types
  ,SynHighlighterPerl
  ,SynHighlighterPython
  ,SynHighlighterJScript
  ,SynHighlighterRuby
  ,SynHighlighterUNIXShellScript
  ,SynEditPrintPreview
  ,SynEditPrintTypes
  ,SynHighlighterURI
  ,SynURIOpener
  ,SynHighlighterMulti

  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_fMain]);
end;


function getAppName: string;
begin
  result:= maxform1.GetActFileName;
end;

function getLastName: string;
begin
  result:= maxform1.GetLastFileName;
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
    RegisterProperty('CB1SCList', 'TComboBox', iptrw);
    RegisterProperty('mxNavigator', 'TComboBox', iptrw);
    RegisterProperty('lbintfList', 'TListbox', iptrw);
    RegisterProperty('navigatorList', 'TListbox', iptrw);
    RegisterProperty('IPHost', 'string', iptrw);
    RegisterProperty('IPPort', 'integer', iptrw);
    RegisterProperty('COMPort', 'integer', iptrw);      //3.9.6.4
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
    RegisterProperty('SynCppSyn1', 'TSynCppSyn', iptrw);
    RegisterProperty('CSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial6', 'TMenuItem', iptrw);
    RegisterProperty('New1', 'TMenuItem', iptrw);
    RegisterProperty('AllObjectsList1', 'TMenuItem', iptrw);
    RegisterProperty('LoadBytecode1', 'TMenuItem', iptrw);
    RegisterProperty('CipherFile1', 'TMenuItem', iptrw);
    RegisterProperty('N9', 'TMenuItem', iptrw);
    RegisterProperty('N10', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial11', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial71', 'TMenuItem', iptrw);
    RegisterProperty('UpdateService1', 'TMenuItem', iptrw);
    RegisterProperty('PascalSchool1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial81', 'TMenuItem', iptrw);
    RegisterProperty('DelphiSite1', 'TMenuItem', iptrw);
    RegisterProperty('Output1', 'TMenuItem', iptrw);
    RegisterProperty('TerminalStyle1', 'TMenuItem', iptrw);
    RegisterProperty('ReadOnly1', 'TMenuItem', iptrw);
    RegisterProperty('ShellStyle1', 'TMenuItem', iptrw);
    RegisterProperty('BigScreen1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial91', 'TMenuItem', iptrw);
    RegisterProperty('SaveOutput2', 'TMenuItem', iptrw);
    RegisterProperty('N11', 'TMenuItem', iptrw);
    RegisterProperty('SaveScreenshot', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial101', 'TMenuItem', iptrw);
    RegisterProperty('SQLSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('SynSQLSyn1', 'TSynSQLSyn', iptrw);
    RegisterProperty('Console1', 'TMenuItem', iptrw);
    RegisterProperty('SynXMLSyn1', 'TSynXMLSyn', iptrw);
    RegisterProperty('XMLSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('ComponentCount1', 'TMenuItem', iptrw);
    RegisterProperty('NewInstance1', 'TMenuItem', iptrw);
    RegisterProperty('toolbtnTutorial', 'TToolButton', iptrw);
    RegisterProperty('Memory1', 'TMenuItem', iptrw);
    RegisterProperty('SynJavaSyn1', 'TSynJavaSyn', iptrw);
    RegisterProperty('JavaSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('SyntaxCheck1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial10Statistics1', 'TMenuItem', iptrw);
    RegisterProperty('ScriptExplorer1', 'TMenuItem', iptrw);
    RegisterProperty('FormOutput1', 'TMenuItem', iptrw);
    RegisterProperty('ArduinoDump1', 'TMenuItem', iptrw);
    RegisterProperty('AndroidDump1', 'TMenuItem', iptrw);
    RegisterProperty('GotoEnd1', 'TMenuItem', iptrw);
    RegisterProperty('AllResourceList1', 'TMenuItem', iptrw);
    RegisterProperty('ToolButton4', 'TToolButton', iptrw);
    RegisterProperty('tbtn6res', 'TToolButton', iptrw);
    RegisterProperty('Tutorial11Forms1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial12SQL1', 'TMenuItem', iptrw);
    RegisterProperty('ResourceExplore1', 'TMenuItem', iptrw);
    RegisterProperty('Info1', 'TMenuItem', iptrw);
    RegisterProperty('N12', 'TMenuItem', iptrw);
    RegisterProperty('CryptoBox1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial13Ciphering1', 'TMenuItem', iptrw);
    RegisterProperty('CipherFile2', 'TMenuItem', iptrw);
    RegisterProperty('N13', 'TMenuItem', iptrw);
    RegisterProperty('ModulesCount1', 'TMenuItem', iptrw);
    RegisterProperty('AddOns2', 'TMenuItem', iptrw);
    RegisterProperty('N4GewinntGame1', 'TMenuItem', iptrw);
    RegisterProperty('DocuforAddOns1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial14Async1', 'TMenuItem', iptrw);
    RegisterProperty('Lessons15Review1', 'TMenuItem', iptrw);
    RegisterProperty('SynPHPSyn1', 'TSynPHPSyn', iptrw);
    RegisterProperty('PHPSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('Breakpoint1', 'TMenuItem', iptrw);
    RegisterProperty('SerialRS2321', 'TMenuItem', iptrw);
    RegisterProperty('N14', 'TMenuItem', iptrw);
    RegisterProperty('SynCSSyn1', 'TSynCSSyn', iptrw);
    RegisterProperty('CSyntax2', 'TMenuItem', iptrw);
    RegisterProperty('Calculator1', 'TMenuItem', iptrw);
    RegisterProperty('tbtnSerial', 'TToolButton', iptrw);
    RegisterProperty('ToolButton8', 'TToolButton', iptrw);
    RegisterProperty('Tutorial151', 'TMenuItem', iptrw);
    RegisterProperty('N15', 'TMenuItem', iptrw);
    RegisterProperty('N16', 'TMenuItem', iptrw);
    RegisterProperty('ControlBar1', 'TControlBar', iptrw);
    RegisterProperty('ToolBar2', 'TToolBar', iptrw);
    RegisterProperty('BtnOpen', 'TToolButton', iptrw);
    RegisterProperty('BtnSave', 'TToolButton', iptrw);
    RegisterProperty('BtnPrint', 'TToolButton', iptrw);
    RegisterProperty('BtnColors', 'TToolButton', iptrw);
    RegisterProperty('btnClassReport', 'TToolButton', iptrw);
    RegisterProperty('BtnRotateRight', 'TToolButton', iptrw);
    RegisterProperty('BtnFullSize', 'TToolButton', iptrw);
    RegisterProperty('BtnFitToWindowSize', 'TToolButton', iptrw);
    RegisterProperty('BtnZoomMinus', 'TToolButton', iptrw);
    RegisterProperty('BtnZoomPlus', 'TToolButton', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('LabelBrettgroesse', 'TLabel', iptrw);
    RegisterProperty('CB1SCList', 'TComboBox', iptrw);
    RegisterProperty('ImageListNormal', 'TImageList', iptrw);
    RegisterProperty('spbtnexplore', 'TSpeedButton', iptrw);
    RegisterProperty('spbtnexample', 'TSpeedButton', iptrw);
    RegisterProperty('spbsaveas', 'TSpeedButton', iptrw);
    RegisterProperty('imglogobox', 'TImage', iptrw);
    RegisterProperty('EnlargeFont1', 'TMenuItem', iptrw);
    RegisterProperty('EnlargeFont2', 'TMenuItem', iptrw);
    RegisterProperty('ShrinkFont1', 'TMenuItem', iptrw);
    RegisterProperty('ThreadDemo1', 'TMenuItem', iptrw);
    RegisterProperty('HEXEditor1', 'TMenuItem', iptrw);
    RegisterProperty('HEXView1', 'TMenuItem', iptrw);
    RegisterProperty('HEXInspect1', 'TMenuItem', iptrw);
    RegisterProperty('SynExporterHTML1', 'TSynExporterHTML', iptrw);
    RegisterProperty('ExporttoHTML1', 'TMenuItem', iptrw);
    RegisterProperty('ClassCount1', 'TMenuItem', iptrw);
    RegisterProperty('HTMLOutput1', 'TMenuItem', iptrw);
    RegisterProperty('HEXEditor2', 'TMenuItem', iptrw);
    RegisterProperty('Minesweeper1', 'TMenuItem', iptrw);
    RegisterProperty('N17', 'TMenuItem', iptrw);
    RegisterProperty('PicturePuzzle1', 'TMenuItem', iptrw);
    RegisterProperty('sbvclhelp', 'TSpeedButton', iptrw);
    RegisterProperty('DependencyWalker1', 'TMenuItem', iptrw);
    RegisterProperty('WebScanner1', 'TMenuItem', iptrw);
    RegisterProperty('View1', 'TMenuItem', iptrw);
    RegisterProperty('mnToolbar1', 'TMenuItem', iptrw);
    RegisterProperty('mnStatusbar2', 'TMenuItem', iptrw);
    RegisterProperty('mnConsole2', 'TMenuItem', iptrw);
    RegisterProperty('mnCoolbar2', 'TMenuItem', iptrw);
    RegisterProperty('mnSplitter2', 'TMenuItem', iptrw);
    RegisterProperty('WebServer1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial17Server1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial18Arduino1', 'TMenuItem', iptrw);
    RegisterProperty('SynPerlSyn1', 'TSynPerlSyn', iptrw);
    RegisterProperty('PerlSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('SynPythonSyn1', 'TSynPythonSyn', iptrw);
    RegisterProperty('PythonSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('DMathLibrary1', 'TMenuItem', iptrw);
    RegisterProperty('IntfNavigator1', 'TMenuItem', iptrw);
    RegisterProperty('EnlargeFontConsole1', 'TMenuItem', iptrw);
    RegisterProperty('ShrinkFontConsole1', 'TMenuItem', iptrw);
    RegisterProperty('SetInterfaceList1', 'TMenuItem', iptrw);
    RegisterProperty('popintfList', 'TPopupMenu', iptrw);
    RegisterProperty('intfAdd1', 'TMenuItem', iptrw);
    RegisterProperty('intfDelete1', 'TMenuItem', iptrw);
    RegisterProperty('intfRefactor1', 'TMenuItem', iptrw);
    RegisterProperty('Defactor1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial19COMArduino1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial20Regex', 'TMenuItem', iptrw);
    RegisterProperty('N18', 'TMenuItem', iptrw);
    RegisterProperty('ManualE1', 'TMenuItem', iptrw);
    RegisterProperty('FullTextFinder1', 'TMenuItem', iptrw);
    RegisterProperty('Move1', 'TMenuItem', iptrw);
    RegisterProperty('FractalDemo1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial21Android1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial0Function1', 'TMenuItem', iptrw);
    RegisterProperty('SimuLogBox1', 'TMenuItem', iptrw);
    RegisterProperty('OpenExamples1', 'TMenuItem', iptrw);
    RegisterProperty('SynJScriptSyn1', 'TSynJScriptSyn', iptrw);
    RegisterProperty('JavaScriptSyntax1', 'TMenuItem', iptrw);
    RegisterProperty('Halt1', 'TMenuItem', iptrw);
    RegisterProperty('CodeSearch1', 'TMenuItem', iptrw);
    RegisterProperty('SynRubySyn1', 'TSynRubySyn', iptrw);
    RegisterProperty('RubySyntax1', 'TMenuItem', iptrw);
    RegisterProperty('Undo1', 'TMenuItem', iptrw);
    RegisterProperty('SynUNIXShellScriptSyn1', 'TSynUNIXShellScriptSyn', iptrw);
    RegisterProperty('LinuxShellScript1', 'TMenuItem', iptrw);
    RegisterProperty('Rename1', 'TMenuItem', iptrw);
    RegisterProperty('spdcodesearch', 'TSpeedButton', iptrw);
    RegisterProperty('Preview1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial22Services1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial23RealTime1', 'TMenuItem', iptrw);
    RegisterProperty('Configuration1', 'TMenuItem', iptrw);
    RegisterProperty('MP3Player1', 'TMenuItem', iptrw);
    RegisterProperty('DLLSpy1', 'TMenuItem', iptrw);
    RegisterProperty('SynURIOpener1', 'TSynURIOpener', iptrw);
    RegisterProperty('SynURISyn1', 'TSynURISyn', iptrw);
    RegisterProperty('URILinksClicks1', 'TMenuItem', iptrw);
    RegisterProperty('EditReplace1', 'TMenuItem', iptrw);
    RegisterProperty('GotoLine1', 'TMenuItem', iptrw);
    RegisterProperty('ActiveLineColor1', 'TMenuItem', iptrw);
    RegisterProperty('ConfigFile1', 'TMenuItem', iptrw);
    RegisterProperty('Sort1Intflist', 'TMenuItem', iptrw);
    RegisterProperty('Redo1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial24CleanCode1', 'TMenuItem', iptrw);
    RegisterProperty('Tutorial25Configuration1', 'TMenuItem', iptrw);
    RegisterProperty('IndentSelection1', 'TMenuItem', iptrw);
    RegisterProperty('UnindentSection1', 'TMenuItem', iptrw);
    RegisterProperty('SkyStyle1', 'TMenuItem', iptrw);
    RegisterProperty('N19', 'TMenuItem', iptrw);
    RegisterProperty('CountWords1', 'TMenuItem', iptrw);
    RegisterProperty('imbookmarkimages', 'TImageList', iptrw);
    RegisterProperty('Bookmark11', 'TMenuItem', iptrw);
    RegisterProperty('N20', 'TMenuItem', iptrw);
    RegisterProperty('Bookmark21', 'TMenuItem', iptrw);
    RegisterProperty('Bookmark31', 'TMenuItem', iptrw);
    RegisterProperty('Bookmark41', 'TMenuItem', iptrw);
    RegisterProperty('SynMultiSyn1', 'TSynMultiSyn', iptrw);
    RegisterProperty('MyScript1', 'TMenuItem', iptrw);
    RegisterProperty('ExternalApp1', 'TMenuItem', iptrw);

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
    RegisterMethod('procedure PHPSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure SerialRS2321Click(Sender: TObject);');
    RegisterMethod('procedure CSyntax2Click(Sender: TObject);');
    RegisterMethod('procedure Calculator1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial13Ciphering1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial14Async1Click(Sender: TObject);');
    RegisterMethod('procedure PHPSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure BtnZoomPlusClick(Sender: TObject);');
    RegisterMethod('procedure BtnZoomMinusClick(Sender: TObject);');
    RegisterMethod('procedure btnClassReportClick(Sender: TObject);');
    RegisterMethod('procedure ThreadDemo1Click(Sender: TObject);');
   RegisterMethod('procedure HEXView1Click(Sender: TObject);');
    RegisterMethod('procedure ExporttoHTML1Click(Sender: TObject);');
    RegisterMethod('procedure Minesweeper1Click(Sender: TObject);');
    RegisterMethod('procedure PicturePuzzle1Click(Sender: TObject);');
   //V3.9
    RegisterMethod('procedure sbvclhelpClick(Sender: TObject);');
    RegisterMethod('procedure DependencyWalker1Click(Sender: TObject);');
    RegisterMethod('procedure CB1SCListDrawItem(Control: TWinControl; Index: Integer; aRect: TRect; State: TOwnerDrawState);');
    RegisterMethod('procedure WebScanner1Click(Sender: TObject);');
    RegisterMethod('procedure mnToolbar1Click(Sender: TObject);');
    RegisterMethod('procedure mnStatusbar2Click(Sender: TObject);');
    RegisterMethod('procedure mnConsole2Click(Sender: TObject);');
    RegisterMethod('procedure mnCoolbar2Click(Sender: TObject);');
    RegisterMethod('procedure mnSplitter2Click(Sender: TObject);');
    RegisterMethod('procedure WebServer1Click(Sender: TObject);');
    RegisterMethod('procedure PerlSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure PythonSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure DMathLibrary1Click(Sender: TObject);');
    RegisterMethod('procedure IntfNavigator1Click(Sender: TObject);');
    RegisterMethod('procedure FullTextFinder1Click(Sender: TObject);');
    RegisterMethod('function AppName: string;');
    RegisterMethod('function ScriptName: string;');
    RegisterMethod('function LastName: string;');
    RegisterMethod('procedure FractalDemo1Click(Sender: TObject);');
    RegisterMethod('procedure SimuLogBox1Click(Sender: TObject);');
    RegisterMethod('procedure OpenExamples1Click(Sender: TObject);');
    RegisterMethod('procedure Halt1Click(Sender: TObject);');
    RegisterMethod('procedure Stop;');
    RegisterMethod('procedure CodeSearch1Click(Sender: TObject);');
    RegisterMethod('procedure RubySyntax1Click(Sender: TObject);');
    RegisterMethod('procedure Undo1Click(Sender: TObject);');
    RegisterMethod('procedure LinuxShellScript1Click(Sender: TObject);');
    RegisterMethod('procedure WebScannerDirect(urls: string);');
    RegisterMethod('procedure WebScanner(urls: string);');
    RegisterMethod('procedure LoadInterfaceList2;');
    RegisterMethod('procedure DLLSpy1Click(Sender: TObject);');
    RegisterMethod('procedure Memo1DblClick(Sender: TObject);');
    RegisterMethod('procedure URILinksClicks1Click(Sender: TObject);');
    RegisterMethod('procedure GotoLine1Click(Sender: TObject);');
    RegisterMethod('procedure ConfigFile1Click(Sender: TObject);');
    RegisterMethod('procedure ActiveLineColor1Click(Sender: TObject);');
    //RegisterMethod('procedure DoEditorExecuteCommand(EditorCommand: word);');
    RegisterMethod('procedure SkyStyle1Click(Sender: TObject);');
    RegisterMethod('procedure CountWords1Click(Sender: TObject);');
    RegisterMethod('Procedure Memo1PlaceBookmark( Sender : TObject; var Mark : TSynEditMark)');
    RegisterMethod('Procedure Memo1GutterClick( Sender : TObject; Button : TMouseButton; X, Y, Line : Integer; Mark : TSynEditMark)');
    RegisterMethod('Procedure Bookmark11Click( Sender : TObject)');
    RegisterMethod('Procedure Bookmark21Click( Sender : TObject)');
    RegisterMethod('Procedure Bookmark31Click( Sender : TObject)');
    RegisterMethod('Procedure Bookmark41Click( Sender : TObject)');
    RegisterMethod('Procedure Bookmark51Click( Sender : TObject)');
    RegisterMethod('Function GetStatChange : boolean');
    RegisterMethod('Procedure SetStatChange( vstat : boolean)');
    RegisterMethod('Function GetActFileName : string');
    RegisterMethod('Procedure SetActFileName( vname : string)');
    RegisterMethod('Function GetLastFileName : string');
    RegisterMethod('Procedure SetLastFileName( vname : string)');
    RegisterMethod('Procedure WebScannerDirect( urls : string)');
    RegisterMethod('Procedure LoadInterfaceList2');
    RegisterMethod('Function GetStatExecuteShell : boolean');
    RegisterMethod('Procedure DoEditorExecuteCommand( EditorCommand : word)');
    RegisterMethod('function GetActiveLineColor: TColor');
    RegisterMethod('procedure SetActiveLineColor(acolor: TColor)');
    RegisterMethod('procedure ScriptListbox1Click(Sender: TObject);');
    RegisterMethod('procedure Memo2KeyPress(Sender: TObject; var Key: Char);');
    RegisterMethod('procedure EnlargeGutter1Click(Sender: TObject);');
    RegisterMethod('procedure Tetris1Click(Sender: TObject);');
    RegisterMethod('procedure ToDoList1Click(Sender: TObject);');
    RegisterMethod('procedure ProcessList1Click(Sender: TObject);');
    RegisterMethod('procedure TCPSockets1Click(Sender: TObject);');
    RegisterMethod('procedure ConfigUpdate1Click(Sender: TObject);');
    RegisterMethod('procedure ADOWorkbench1Click(Sender: TObject);');
    RegisterMethod('procedure SocketServer1Click(Sender: TObject);');
    RegisterMethod('procedure FormDemo1Click(Sender: TObject);');
    RegisterMethod('procedure Richedit1Click(Sender: TObject);');
    RegisterMethod('procedure SimpleBrowser1Click(Sender: TObject);');
    RegisterMethod('procedure DOSShell1Click(Sender: TObject);');
    RegisterMethod('procedure SynExport1Click(Sender: TObject);');
    RegisterMethod('procedure ExporttoRTF1Click(Sender: TObject);');
    RegisterMethod('procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);');
    RegisterMethod('procedure SOAPTester1Click(Sender: TObject);');
    RegisterMethod('procedure Sniffer1Click(Sender: TObject);');
    RegisterMethod('procedure AutoDetectSyntax1Click(Sender: TObject);');
    RegisterMethod('procedure FPlot1Click(Sender: TObject);');
    RegisterMethod('procedure PasStyle1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial183RGBLED1Click(Sender: TObject);');
    RegisterMethod('procedure Reversi1Click(Sender: TObject);');
    RegisterMethod('procedure ManualmaXbox1Click(Sender: TObject);');
    RegisterMethod('procedure BlaisePascalMagazine1Click(Sender: TObject);');
    RegisterMethod('procedure AddToDo1Click(Sender: TObject);');
    RegisterMethod('procedure CreateGUID1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial27XML1Click(Sender: TObject);');
    RegisterMethod('procedure CreateDLLStub1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial28DLL1Click(Sender: TObject);');
    RegisterMethod('procedure ResetKeyPressed;');
    RegisterMethod('procedure SaveByteCode;');
    RegisterMethod('procedure KeyPressedFalse;');
    RegisterMethod('procedure FileChanges1Click(Sender: TObject);');
    RegisterMethod('procedure OpenGLTry1Click(Sender: TObject);');
    RegisterMethod('procedure AllUnitList1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial29UMLClick(Sender: TObject);');
    RegisterMethod('procedure CreateHeader1Click(Sender: TObject);');
    RegisterMethod('procedure Oscilloscope1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial30WOT1Click(Sender: TObject);');
    RegisterMethod('procedure GetWebScript1Click(Sender: TObject);');
    RegisterMethod('procedure Checkers1Click(Sender: TObject);');
    RegisterMethod('procedure TaskMgr1Click(Sender: TObject);');
    RegisterMethod('procedure WebCam1Click(Sender: TObject);');
    RegisterMethod('procedure Tutorial31Closure1Click(Sender: TObject);');
    RegisterMethod('procedure GEOMapView1Click(Sender: TObject);');
    RegisterMethod('procedure Run1Click(Sender: TObject');
    RegisterMethod('procedure GPSSatView1Click(Sender: TObject);');
    RegisterMethod('procedure N3DLab1Click(Sender: TObject);');
    RegisterMethod('procedure ExternalApp1Click(Sender: TObject);');
    RegisterMethod('procedure PANView1Click(Sender: TObject);');
    RegisterMethod('procedure UnitConverter1Click(Sender: TObject);');
    RegisterMethod('procedure MyScript1Click(Sender: TObject);');
    RegisterMethod('procedure Terminal1Click(Sender: TObject);');
    RegisterMethod('procedure TrainingArduino1Click(Sender: TObject);');
    RegisterMethod('procedure Chess41Click(Sender: TObject);');
    RegisterMethod('procedure OrangeStyle1Click(Sender: TObject);');

      //RegisterMethod('procedure defFilereadUpdate;');
      //  procedure defFilereadUpdate;
    //DEFINIFILE
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
 CL.AddConstantN('ALLFUNCTIONSLIST','String').SetString( 'upsi_allfunctionslist.txt');
 CL.AddConstantN('ALLFUNCTIONSLISTPDF','String').SetString( 'maxbox_functions_all.pdf');
 CL.AddConstantN('ALLOBJECTSLIST','String').SetString( 'docs\VCL.pdf');
 CL.AddConstantN('ALLRESOURCELIST','String').SetString( 'docs\upsi_allresourcelist.txt');
 //CL.AddConstantN('ALLUNITLIST','String').SetString( 'docs\maxbox3_9.xml');
 CL.AddConstantN('ALLUNITLIST','String').SetString( 'docs\maxbox4_0.xml');

 CL.AddConstantN('INCLUDEBOX','String').SetString('pas_includebox.inc');
 CL.AddConstantN('BOOTSCRIPT','String').SetString('maxbootscript.txt');
 CL.AddConstantN('MBVERSION','String').SetString('4.2.0.10');
 CL.AddConstantN('VERSION','String').SetString('4.2.0.10');
 CL.AddConstantN('MBVERIALL','Integer').SetInt(42010);
 CL.AddConstantN('MBVER2','String').SetString('42010');
 CL.AddConstantN('EXENAME','String').SetString( 'maXbox4.exe');
 CL.AddConstantN('MXINTERNETCHECK','String').SetString( 'www.ask.com');
 CL.AddConstantN('MBVER','String').SetString('420');
 CL.AddConstantN('MBVERI','Integer').SetInt(420);
 CL.AddConstantN('MXVERSIONFILE','String').SetString('http://www.softwareschule.ch/maxvfile.txt');
 CL.AddConstantN('MXVERSIONFILE2','String').SetString('http://www.softwareschule.ch/maxvfile2.txt');
 // MXVERSIONFILE = 'http://www.softwareschule.ch/maxvfile.txt';
  // MXVERSIONFILE2 = 'http://www.softwareschule.ch/maxvfile2.txt';
  //CL.AddConstantN('MBVERIALL','Integer').SetInt(39996);
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
procedure TMaxForm1SynCppSyn1_W(Self: TMaxForm1; const T: TSynCppSyn);
Begin Self.SynCppSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynCppSyn1_R(Self: TMaxForm1; var T: TSynCppSyn);
Begin T := Self.SynCppSyn1; end;


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
procedure TMaxForm1Iphost_W(Self: TMaxForm1; const T: string);
Begin Self.IPhost:= T; end;
(*----------------------------------------------------------------------------*)
procedure TMaxForm1Iphost_R(Self: TMaxForm1; var T: string);
Begin T:= Self.iphost; end;

procedure TMaxForm1Ipport_W(Self: TMaxForm1; const T: integer);
Begin Self.IPport:= T; end;
(*----------------------------------------------------------------------------*)
procedure TMaxForm1Ipport_R(Self: TMaxForm1; var T: integer);
Begin T:= Self.ipport; end;

procedure TMaxForm1comport_W(Self: TMaxForm1; const T: integer);
Begin Self.comport:= T; end;
(*----------------------------------------------------------------------------*)
procedure TMaxForm1Comport_R(Self: TMaxForm1; var T: integer);
Begin T:= Self.comport; end;

//   RegisterPropertyHelper(@TMaxForm1IPhost_R,@IPhost_W,'IPHost');


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

(*----------------------------------------------------------------------------*)
procedure TMaxForm1sclist1_W(Self: TMaxForm1; const T: TComboBox);
Begin Self.CB1SCList:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1sclist1_R(Self: TMaxForm1; var T: TComboBox);
Begin T:= Self.CB1SCList; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intflist1_W(Self: TMaxForm1; const T: TListbox);
Begin Self.lbintflist:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intflist1_R(Self: TMaxForm1; var T: TListbox);
Begin T:= Self.lbintflist; end;

//procedure TAPPLICATIONHINTCOLOR_R(Self: TAPPLICATION; var T: TCOLOR); begin T := Self.HINTCOLOR; end;
//procedure TAPPLICATIONHINTCOLOR_W(Self: TAPPLICATION; T: TCOLOR); begin Self.HINTCOLOR := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1lbintflist_W(Self: TMaxForm1; const T: TListBox);
Begin Self.lbintflist := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1lbintflist_R(Self: TMaxForm1; var T: TListBox);
Begin T := Self.lbintflist; end;

(*----------------------------------------------------------------------------*)
{procedure TMaxForm1COMPort_W(Self: TMaxForm1; const T: integer);
Begin Self.COMPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1COMPort_R(Self: TMaxForm1; var T: integer);
Begin T := Self.COMPort; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IPPort_W(Self: TMaxForm1; const T: integer);
Begin Self.IPPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IPPort_R(Self: TMaxForm1; var T: integer);
Begin T := Self.IPPort; end; }

(*----------------------------------------------------------------------------*)
procedure TMaxForm1STATMemoryReport_W(Self: TMaxForm1; const T: boolean);
Begin Self.STATMemoryReport := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1STATMemoryReport_R(Self: TMaxForm1; var T: boolean);
Begin T := Self.STATMemoryReport; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynMultiSyn1_W(Self: TMaxForm1; const T: TSynMultiSyn);
Begin Self.SynMultiSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynMultiSyn1_R(Self: TMaxForm1; var T: TSynMultiSyn);
Begin T := Self.SynMultiSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark41_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Bookmark41 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark41_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Bookmark41; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark31_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Bookmark31 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark31_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Bookmark31; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark21_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Bookmark21 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark21_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Bookmark21; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N20_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N20 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N20_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N20; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark11_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Bookmark11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Bookmark11_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Bookmark11; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1imbookmarkimages_W(Self: TMaxForm1; const T: TImageList);
Begin Self.imbookmarkimages := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1imbookmarkimages_R(Self: TMaxForm1; var T: TImageList);
Begin T := Self.imbookmarkimages; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CountWords1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CountWords1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CountWords1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CountWords1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N19_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N19 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N19_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N19; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SkyStyle1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SkyStyle1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SkyStyle1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SkyStyle1; end;

procedure TMaxForm1myscript1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.MyScript1:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1myscript1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.MyScript1; end;

procedure TMaxForm1externalapp_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ExternalApp1:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1externalapp_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ExternalApp1; end;

procedure TMaxForm1terminal_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.terminal1:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1terminal_R(Self: TMaxForm1; var T: TMenuItem);
Begin T:= Self.terminal1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1UnindentSection1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.UnindentSection1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1UnindentSection1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.UnindentSection1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IndentSelection1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.IndentSelection1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IndentSelection1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.IndentSelection1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial25Configuration1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial25Configuration1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial25Configuration1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial25Configuration1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial24CleanCode1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial24CleanCode1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial24CleanCode1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial24CleanCode1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Redo1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Redo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Redo1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Redo1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Sort1Intflist_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Sort1Intflist := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Sort1Intflist_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Sort1Intflist; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ConfigFile1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ConfigFile1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ConfigFile1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ConfigFile1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ActiveLineColor1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ActiveLineColor1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ActiveLineColor1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ActiveLineColor1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1GotoLine1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.GotoLine1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1GotoLine1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.GotoLine1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EditReplace1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.EditReplace1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EditReplace1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.EditReplace1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1URILinksClicks1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.URILinksClicks1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1URILinksClicks1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.URILinksClicks1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynURISyn1_W(Self: TMaxForm1; const T: TSynURISyn);
Begin Self.SynURISyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynURISyn1_R(Self: TMaxForm1; var T: TSynURISyn);
Begin T := Self.SynURISyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynURIOpener1_W(Self: TMaxForm1; const T: TSynURIOpener);
Begin Self.SynURIOpener1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynURIOpener1_R(Self: TMaxForm1; var T: TSynURIOpener);
Begin T := Self.SynURIOpener1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DLLSpy1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.DLLSpy1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DLLSpy1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.DLLSpy1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1MP3Player1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.MP3Player1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1MP3Player1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.MP3Player1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Configuration1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Configuration1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Configuration1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Configuration1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial23RealTime1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial23RealTime1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial23RealTime1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial23RealTime1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial22Services1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial22Services1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial22Services1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial22Services1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Preview1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Preview1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Preview1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Preview1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spdcodesearch_W(Self: TMaxForm1; const T: TSpeedButton);
Begin Self.spdcodesearch := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spdcodesearch_R(Self: TMaxForm1; var T: TSpeedButton);
Begin T := Self.spdcodesearch; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Rename1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Rename1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Rename1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Rename1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1LinuxShellScript1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.LinuxShellScript1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1LinuxShellScript1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.LinuxShellScript1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynUNIXShellScriptSyn1_W(Self: TMaxForm1; const T: TSynUNIXShellScriptSyn);
Begin Self.SynUNIXShellScriptSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynUNIXShellScriptSyn1_R(Self: TMaxForm1; var T: TSynUNIXShellScriptSyn);
Begin T := Self.SynUNIXShellScriptSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Undo1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Undo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Undo1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Undo1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1RubySyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.RubySyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1RubySyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.RubySyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynRubySyn1_W(Self: TMaxForm1; const T: TSynRubySyn);
Begin Self.SynRubySyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynRubySyn1_R(Self: TMaxForm1; var T: TSynRubySyn);
Begin T := Self.SynRubySyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CodeSearch1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CodeSearch1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CodeSearch1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CodeSearch1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Halt1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Halt1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Halt1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Halt1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1JavaScriptSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.JavaScriptSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1JavaScriptSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.JavaScriptSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynJScriptSyn1_W(Self: TMaxForm1; const T: TSynJScriptSyn);
Begin Self.SynJScriptSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynJScriptSyn1_R(Self: TMaxForm1; var T: TSynJScriptSyn);
Begin T := Self.SynJScriptSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1OpenExamples1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.OpenExamples1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1OpenExamples1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.OpenExamples1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SimuLogBox1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SimuLogBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SimuLogBox1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SimuLogBox1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial0Function1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial0Function1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial0Function1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial0Function1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial21Android1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial21Android1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial21Android1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial21Android1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1FractalDemo1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.FractalDemo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1FractalDemo1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.FractalDemo1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Move1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Move1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Move1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Move1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1FullTextFinder1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.FullTextFinder1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1FullTextFinder1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.FullTextFinder1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ManualE1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ManualE1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ManualE1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ManualE1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N18_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N18 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N18_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N18; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial20Regex_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial20Regex := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial20Regex_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial20Regex; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial19COMArduino1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial19COMArduino1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial19COMArduino1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial19COMArduino1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Defactor1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Defactor1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Defactor1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Defactor1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intfRefactor1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.intfRefactor1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intfRefactor1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.intfRefactor1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intfDelete1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.intfDelete1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intfDelete1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.intfDelete1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intfAdd1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.intfAdd1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1intfAdd1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.intfAdd1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1popintfList_W(Self: TMaxForm1; const T: TPopupMenu);
Begin Self.popintfList := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1popintfList_R(Self: TMaxForm1; var T: TPopupMenu);
Begin T := Self.popintfList; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SetInterfaceList1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SetInterfaceList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SetInterfaceList1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SetInterfaceList1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShrinkFontConsole1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ShrinkFontConsole1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShrinkFontConsole1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ShrinkFontConsole1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EnlargeFontConsole1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.EnlargeFontConsole1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EnlargeFontConsole1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.EnlargeFontConsole1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IntfNavigator1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.IntfNavigator1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1IntfNavigator1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.IntfNavigator1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DMathLibrary1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.DMathLibrary1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DMathLibrary1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.DMathLibrary1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PythonSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.PythonSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PythonSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.PythonSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPythonSyn1_W(Self: TMaxForm1; const T: TSynPythonSyn);
Begin Self.SynPythonSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPythonSyn1_R(Self: TMaxForm1; var T: TSynPythonSyn);
Begin T := Self.SynPythonSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PerlSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.PerlSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PerlSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.PerlSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPerlSyn1_W(Self: TMaxForm1; const T: TSynPerlSyn);
Begin Self.SynPerlSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPerlSyn1_R(Self: TMaxForm1; var T: TSynPerlSyn);
Begin T := Self.SynPerlSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial18Arduino1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial18Arduino1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial18Arduino1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial18Arduino1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial17Server1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial17Server1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial17Server1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial17Server1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1WebServer1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.WebServer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1WebServer1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.WebServer1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnSplitter2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.mnSplitter2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnSplitter2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.mnSplitter2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnCoolbar2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.mnCoolbar2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnCoolbar2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.mnCoolbar2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnConsole2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.mnConsole2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnConsole2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.mnConsole2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnStatusbar2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.mnStatusbar2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnStatusbar2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.mnStatusbar2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnToolbar1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.mnToolbar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1mnToolbar1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.mnToolbar1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1View1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.View1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1View1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.View1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1WebScanner1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.WebScanner1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1WebScanner1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.WebScanner1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DependencyWalker1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.DependencyWalker1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DependencyWalker1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.DependencyWalker1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1sbvclhelp_W(Self: TMaxForm1; const T: TSpeedButton);
Begin Self.sbvclhelp := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1sbvclhelp_R(Self: TMaxForm1; var T: TSpeedButton);
Begin T := Self.sbvclhelp; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PicturePuzzle1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.PicturePuzzle1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PicturePuzzle1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.PicturePuzzle1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N17_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N17 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N17_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N17; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Minesweeper1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Minesweeper1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Minesweeper1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Minesweeper1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXEditor2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.HEXEditor2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXEditor2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.HEXEditor2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HTMLOutput1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.HTMLOutput1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HTMLOutput1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.HTMLOutput1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ClassCount1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ClassCount1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ClassCount1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ClassCount1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ExporttoHTML1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ExporttoHTML1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ExporttoHTML1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ExporttoHTML1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynExporterHTML1_W(Self: TMaxForm1; const T: TSynExporterHTML);
Begin Self.SynExporterHTML1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynExporterHTML1_R(Self: TMaxForm1; var T: TSynExporterHTML);
Begin T := Self.SynExporterHTML1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXInspect1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.HEXInspect1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXInspect1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.HEXInspect1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXView1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.HEXView1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXView1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.HEXView1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXEditor1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.HEXEditor1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1HEXEditor1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.HEXEditor1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ThreadDemo1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ThreadDemo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ThreadDemo1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ThreadDemo1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShrinkFont1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ShrinkFont1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShrinkFont1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ShrinkFont1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EnlargeFont2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.EnlargeFont2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EnlargeFont2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.EnlargeFont2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EnlargeFont1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.EnlargeFont1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1EnlargeFont1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.EnlargeFont1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1imglogobox_W(Self: TMaxForm1; const T: TImage);
Begin Self.imglogobox := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1imglogobox_R(Self: TMaxForm1; var T: TImage);
Begin T := Self.imglogobox; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spbsaveas_W(Self: TMaxForm1; const T: TSpeedButton);
Begin Self.spbsaveas := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spbsaveas_R(Self: TMaxForm1; var T: TSpeedButton);
Begin T := Self.spbsaveas; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spbtnexample_W(Self: TMaxForm1; const T: TSpeedButton);
Begin Self.spbtnexample := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spbtnexample_R(Self: TMaxForm1; var T: TSpeedButton);
Begin T := Self.spbtnexample; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spbtnexplore_W(Self: TMaxForm1; const T: TSpeedButton);
Begin Self.spbtnexplore := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1spbtnexplore_R(Self: TMaxForm1; var T: TSpeedButton);
Begin T := Self.spbtnexplore; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImageListNormal_W(Self: TMaxForm1; const T: TImageList);
Begin Self.ImageListNormal := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ImageListNormal_R(Self: TMaxForm1; var T: TImageList);
Begin T := Self.ImageListNormal; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CB1SCList_W(Self: TMaxForm1; const T: TComboBox);
Begin Self.CB1SCList := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CB1SCList_R(Self: TMaxForm1; var T: TComboBox);
Begin T := Self.CB1SCList; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1LabelBrettgroesse_W(Self: TMaxForm1; const T: TLabel);
Begin //Self.LabelBrettgroesse := T;
end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1LabelBrettgroesse_R(Self: TMaxForm1; var T: TLabel);
Begin //T := Self.LabelBrettgroesse;
end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Panel1_W(Self: TMaxForm1; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Panel1_R(Self: TMaxForm1; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnZoomPlus_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnZoomPlus := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnZoomPlus_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnZoomPlus; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnZoomMinus_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnZoomMinus := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnZoomMinus_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnZoomMinus; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnFitToWindowSize_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnFitToWindowSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnFitToWindowSize_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnFitToWindowSize; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnFullSize_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnFullSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnFullSize_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnFullSize; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnRotateRight_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnRotateRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnRotateRight_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnRotateRight; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1btnClassReport_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.btnClassReport := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1btnClassReport_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.btnClassReport; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnColors_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnColors_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnColors; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnPrint_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnPrint := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnPrint_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnPrint; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnSave_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnSave := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnSave_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnSave; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnOpen_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.BtnOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BtnOpen_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.BtnOpen; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolBar2_W(Self: TMaxForm1; const T: TToolBar);
Begin Self.ToolBar2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolBar2_R(Self: TMaxForm1; var T: TToolBar);
Begin T := Self.ToolBar2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ControlBar1_W(Self: TMaxForm1; const T: TControlBar);
Begin Self.ControlBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ControlBar1_R(Self: TMaxForm1; var T: TControlBar);
Begin T := Self.ControlBar1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N16_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N16 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N16_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N16; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N15_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N15 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N15_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N15; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial151_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial151 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial151_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial151; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton8_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.ToolButton8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton8_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.ToolButton8; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnSerial_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtnSerial := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtnSerial_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtnSerial; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Calculator1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Calculator1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Calculator1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Calculator1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CSyntax2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CSyntax2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CSyntax2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CSyntax2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynCSSyn1_W(Self: TMaxForm1; const T: TSynCSSyn);
Begin Self.SynCSSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynCSSyn1_R(Self: TMaxForm1; var T: TSynCSSyn);
Begin T := Self.SynCSSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N14_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N14 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N14_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N14; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SerialRS2321_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SerialRS2321 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SerialRS2321_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SerialRS2321; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Breakpoint1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Breakpoint1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Breakpoint1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Breakpoint1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PHPSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.PHPSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PHPSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.PHPSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPHPSyn1_W(Self: TMaxForm1; const T: TSynPHPSyn);
Begin Self.SynPHPSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynPHPSyn1_R(Self: TMaxForm1; var T: TSynPHPSyn);
Begin T := Self.SynPHPSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Lessons15Review1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Lessons15Review1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Lessons15Review1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Lessons15Review1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial14Async1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial14Async1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial14Async1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial14Async1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DocuforAddOns1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.DocuforAddOns1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DocuforAddOns1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.DocuforAddOns1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N4GewinntGame1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N4GewinntGame1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N4GewinntGame1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N4GewinntGame1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AddOns2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.AddOns2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AddOns2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.AddOns2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ModulesCount1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ModulesCount1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ModulesCount1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ModulesCount1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N13_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N13 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N13_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N13; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CipherFile2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CipherFile2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CipherFile2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CipherFile2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial13Ciphering1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial13Ciphering1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial13Ciphering1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial13Ciphering1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CryptoBox1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CryptoBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CryptoBox1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CryptoBox1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N12_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N12_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N12; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Info1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Info1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Info1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Info1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ResourceExplore1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ResourceExplore1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ResourceExplore1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ResourceExplore1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial12SQL1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial12SQL1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial12SQL1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial12SQL1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial11Forms1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial11Forms1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial11Forms1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial11Forms1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtn6res_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.tbtn6res := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1tbtn6res_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.tbtn6res; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton4_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.ToolButton4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ToolButton4_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.ToolButton4; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AllResourceList1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.AllResourceList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AllResourceList1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.AllResourceList1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1GotoEnd1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.GotoEnd1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1GotoEnd1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.GotoEnd1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AndroidDump1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.AndroidDump1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AndroidDump1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.AndroidDump1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ArduinoDump1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ArduinoDump1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ArduinoDump1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ArduinoDump1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1FormOutput1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.FormOutput1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1FormOutput1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.FormOutput1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ScriptExplorer1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ScriptExplorer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ScriptExplorer1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ScriptExplorer1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial10Statistics1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial10Statistics1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial10Statistics1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial10Statistics1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SyntaxCheck1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SyntaxCheck1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SyntaxCheck1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SyntaxCheck1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1JavaSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.JavaSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1JavaSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.JavaSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynJavaSyn1_W(Self: TMaxForm1; const T: TSynJavaSyn);
Begin Self.SynJavaSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynJavaSyn1_R(Self: TMaxForm1; var T: TSynJavaSyn);
Begin T := Self.SynJavaSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Memory1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Memory1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Memory1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Memory1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1toolbtnTutorial_W(Self: TMaxForm1; const T: TToolButton);
Begin Self.toolbtnTutorial := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1toolbtnTutorial_R(Self: TMaxForm1; var T: TToolButton);
Begin T := Self.toolbtnTutorial; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1NewInstance1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.NewInstance1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1NewInstance1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.NewInstance1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ComponentCount1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ComponentCount1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ComponentCount1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ComponentCount1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1XMLSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.XMLSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1XMLSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.XMLSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynXMLSyn1_W(Self: TMaxForm1; const T: TSynXMLSyn);
Begin Self.SynXMLSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynXMLSyn1_R(Self: TMaxForm1; var T: TSynXMLSyn);
Begin T := Self.SynXMLSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Console1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Console1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Console1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Console1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynSQLSyn1_W(Self: TMaxForm1; const T: TSynSQLSyn);
Begin Self.SynSQLSyn1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SynSQLSyn1_R(Self: TMaxForm1; var T: TSynSQLSyn);
Begin T := Self.SynSQLSyn1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SQLSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SQLSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SQLSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SQLSyntax1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial101_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial101 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial101_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial101; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SaveScreenshot_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SaveScreenshot := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SaveScreenshot_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SaveScreenshot; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N11_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N11_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N11; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SaveOutput2_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.SaveOutput2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1SaveOutput2_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.SaveOutput2; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial91_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial91 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial91_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial91; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BigScreen1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.BigScreen1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1BigScreen1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.BigScreen1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShellStyle1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ShellStyle1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ShellStyle1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ShellStyle1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ReadOnly1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.ReadOnly1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1ReadOnly1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.ReadOnly1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1TerminalStyle1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.TerminalStyle1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1TerminalStyle1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.TerminalStyle1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Output1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Output1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Output1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Output1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DelphiSite1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.DelphiSite1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1DelphiSite1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.DelphiSite1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial81_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial81 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial81_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial81; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PascalSchool1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.PascalSchool1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1PascalSchool1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.PascalSchool1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1UpdateService1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.UpdateService1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1UpdateService1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.UpdateService1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial71_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial71 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial71_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial71; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial11_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial11_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial11; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N10_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N10_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N10; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N9_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.N9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1N9_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.N9; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CipherFile1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CipherFile1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CipherFile1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CipherFile1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1LoadBytecode1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.LoadBytecode1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1LoadBytecode1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.LoadBytecode1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AllObjectsList1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.AllObjectsList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1AllObjectsList1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.AllObjectsList1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1New1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.New1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1New1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.New1; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial6_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.Tutorial6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1Tutorial6_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.Tutorial6; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CSyntax1_W(Self: TMaxForm1; const T: TMenuItem);
Begin Self.CSyntax1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaxForm1CSyntax1_R(Self: TMaxForm1; var T: TMenuItem);
Begin T := Self.CSyntax1; end;

(*----------------------------------------------------------------------------*)
//procedure TMaxForm1SynCppSyn1_W(Self: TMaxForm1; const T: TSynCppSyn);
//Begin Self.SynCppSyn1 := T; end;




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
    RegisterPropertyHelper(@TMaxForm1sclist1_R,@TMaxForm1sclist1_W,'CB1SCList');
    RegisterPropertyHelper(@TMaxForm1sclist1_R,@TMaxForm1sclist1_W,'mxNavigator');

    RegisterPropertyHelper(@TMaxForm1intflist1_R,@TMaxForm1intflist1_W,'lbintfList');
    RegisterPropertyHelper(@TMaxForm1intflist1_R,@TMaxForm1intflist1_W,'navigatorList');
   //  RegisterProperty('lbintfList', 'TListbox', iptrw);

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
     RegisterPropertyHelper(@TMaxForm1GetEMails1_R,@TMaxForm1GetEMails1_W,'GetEMails1');
    RegisterPropertyHelper(@TMaxForm1SynCppSyn1_R,@TMaxForm1SynCppSyn1_W,'SynCppSyn1');
    RegisterPropertyHelper(@TMaxForm1CSyntax1_R,@TMaxForm1CSyntax1_W,'CSyntax1');
    RegisterPropertyHelper(@TMaxForm1Tutorial6_R,@TMaxForm1Tutorial6_W,'Tutorial6');
    RegisterPropertyHelper(@TMaxForm1New1_R,@TMaxForm1New1_W,'New1');
    RegisterPropertyHelper(@TMaxForm1AllObjectsList1_R,@TMaxForm1AllObjectsList1_W,'AllObjectsList1');
    RegisterPropertyHelper(@TMaxForm1LoadBytecode1_R,@TMaxForm1LoadBytecode1_W,'LoadBytecode1');
    RegisterPropertyHelper(@TMaxForm1CipherFile1_R,@TMaxForm1CipherFile1_W,'CipherFile1');
    RegisterPropertyHelper(@TMaxForm1N9_R,@TMaxForm1N9_W,'N9');
    RegisterPropertyHelper(@TMaxForm1N10_R,@TMaxForm1N10_W,'N10');
    RegisterPropertyHelper(@TMaxForm1Tutorial11_R,@TMaxForm1Tutorial11_W,'Tutorial11');
    RegisterPropertyHelper(@TMaxForm1Tutorial71_R,@TMaxForm1Tutorial71_W,'Tutorial71');
    RegisterPropertyHelper(@TMaxForm1UpdateService1_R,@TMaxForm1UpdateService1_W,'UpdateService1');
    RegisterPropertyHelper(@TMaxForm1PascalSchool1_R,@TMaxForm1PascalSchool1_W,'PascalSchool1');
    RegisterPropertyHelper(@TMaxForm1Tutorial81_R,@TMaxForm1Tutorial81_W,'Tutorial81');
    RegisterPropertyHelper(@TMaxForm1DelphiSite1_R,@TMaxForm1DelphiSite1_W,'DelphiSite1');
    RegisterPropertyHelper(@TMaxForm1Output1_R,@TMaxForm1Output1_W,'Output1');
    RegisterPropertyHelper(@TMaxForm1TerminalStyle1_R,@TMaxForm1TerminalStyle1_W,'TerminalStyle1');
    RegisterPropertyHelper(@TMaxForm1ReadOnly1_R,@TMaxForm1ReadOnly1_W,'ReadOnly1');
    RegisterPropertyHelper(@TMaxForm1ShellStyle1_R,@TMaxForm1ShellStyle1_W,'ShellStyle1');
    RegisterPropertyHelper(@TMaxForm1BigScreen1_R,@TMaxForm1BigScreen1_W,'BigScreen1');
    RegisterPropertyHelper(@TMaxForm1Tutorial91_R,@TMaxForm1Tutorial91_W,'Tutorial91');
    RegisterPropertyHelper(@TMaxForm1SaveOutput2_R,@TMaxForm1SaveOutput2_W,'SaveOutput2');
    RegisterPropertyHelper(@TMaxForm1N11_R,@TMaxForm1N11_W,'N11');
    RegisterPropertyHelper(@TMaxForm1SaveScreenshot_R,@TMaxForm1SaveScreenshot_W,'SaveScreenshot');
    RegisterPropertyHelper(@TMaxForm1Tutorial101_R,@TMaxForm1Tutorial101_W,'Tutorial101');
    RegisterPropertyHelper(@TMaxForm1SQLSyntax1_R,@TMaxForm1SQLSyntax1_W,'SQLSyntax1');
    RegisterPropertyHelper(@TMaxForm1SynSQLSyn1_R,@TMaxForm1SynSQLSyn1_W,'SynSQLSyn1');
    RegisterPropertyHelper(@TMaxForm1Console1_R,@TMaxForm1Console1_W,'Console1');
    RegisterPropertyHelper(@TMaxForm1SynXMLSyn1_R,@TMaxForm1SynXMLSyn1_W,'SynXMLSyn1');
    RegisterPropertyHelper(@TMaxForm1XMLSyntax1_R,@TMaxForm1XMLSyntax1_W,'XMLSyntax1');
    RegisterPropertyHelper(@TMaxForm1ComponentCount1_R,@TMaxForm1ComponentCount1_W,'ComponentCount1');
    RegisterPropertyHelper(@TMaxForm1NewInstance1_R,@TMaxForm1NewInstance1_W,'NewInstance1');
    RegisterPropertyHelper(@TMaxForm1toolbtnTutorial_R,@TMaxForm1toolbtnTutorial_W,'toolbtnTutorial');
    RegisterPropertyHelper(@TMaxForm1Memory1_R,@TMaxForm1Memory1_W,'Memory1');
    RegisterPropertyHelper(@TMaxForm1SynJavaSyn1_R,@TMaxForm1SynJavaSyn1_W,'SynJavaSyn1');
    RegisterPropertyHelper(@TMaxForm1JavaSyntax1_R,@TMaxForm1JavaSyntax1_W,'JavaSyntax1');
    RegisterPropertyHelper(@TMaxForm1SyntaxCheck1_R,@TMaxForm1SyntaxCheck1_W,'SyntaxCheck1');
    RegisterPropertyHelper(@TMaxForm1Tutorial10Statistics1_R,@TMaxForm1Tutorial10Statistics1_W,'Tutorial10Statistics1');
    RegisterPropertyHelper(@TMaxForm1ScriptExplorer1_R,@TMaxForm1ScriptExplorer1_W,'ScriptExplorer1');
    RegisterPropertyHelper(@TMaxForm1FormOutput1_R,@TMaxForm1FormOutput1_W,'FormOutput1');
    RegisterPropertyHelper(@TMaxForm1ArduinoDump1_R,@TMaxForm1ArduinoDump1_W,'ArduinoDump1');
    RegisterPropertyHelper(@TMaxForm1AndroidDump1_R,@TMaxForm1AndroidDump1_W,'AndroidDump1');
    RegisterPropertyHelper(@TMaxForm1GotoEnd1_R,@TMaxForm1GotoEnd1_W,'GotoEnd1');
    RegisterPropertyHelper(@TMaxForm1AllResourceList1_R,@TMaxForm1AllResourceList1_W,'AllResourceList1');
    RegisterPropertyHelper(@TMaxForm1ToolButton4_R,@TMaxForm1ToolButton4_W,'ToolButton4');
    RegisterPropertyHelper(@TMaxForm1tbtn6res_R,@TMaxForm1tbtn6res_W,'tbtn6res');
    RegisterPropertyHelper(@TMaxForm1Tutorial11Forms1_R,@TMaxForm1Tutorial11Forms1_W,'Tutorial11Forms1');
    RegisterPropertyHelper(@TMaxForm1Tutorial12SQL1_R,@TMaxForm1Tutorial12SQL1_W,'Tutorial12SQL1');
    RegisterPropertyHelper(@TMaxForm1ResourceExplore1_R,@TMaxForm1ResourceExplore1_W,'ResourceExplore1');
    RegisterPropertyHelper(@TMaxForm1Info1_R,@TMaxForm1Info1_W,'Info1');
    RegisterPropertyHelper(@TMaxForm1N12_R,@TMaxForm1N12_W,'N12');
    RegisterPropertyHelper(@TMaxForm1CryptoBox1_R,@TMaxForm1CryptoBox1_W,'CryptoBox1');
    RegisterPropertyHelper(@TMaxForm1Tutorial13Ciphering1_R,@TMaxForm1Tutorial13Ciphering1_W,'Tutorial13Ciphering1');
    RegisterPropertyHelper(@TMaxForm1CipherFile2_R,@TMaxForm1CipherFile2_W,'CipherFile2');
    RegisterPropertyHelper(@TMaxForm1N13_R,@TMaxForm1N13_W,'N13');
    RegisterPropertyHelper(@TMaxForm1ModulesCount1_R,@TMaxForm1ModulesCount1_W,'ModulesCount1');
    RegisterPropertyHelper(@TMaxForm1AddOns2_R,@TMaxForm1AddOns2_W,'AddOns2');
    RegisterPropertyHelper(@TMaxForm1N4GewinntGame1_R,@TMaxForm1N4GewinntGame1_W,'N4GewinntGame1');
    RegisterPropertyHelper(@TMaxForm1DocuforAddOns1_R,@TMaxForm1DocuforAddOns1_W,'DocuforAddOns1');
    RegisterPropertyHelper(@TMaxForm1Tutorial14Async1_R,@TMaxForm1Tutorial14Async1_W,'Tutorial14Async1');
    RegisterPropertyHelper(@TMaxForm1Lessons15Review1_R,@TMaxForm1Lessons15Review1_W,'Lessons15Review1');
    RegisterPropertyHelper(@TMaxForm1SynPHPSyn1_R,@TMaxForm1SynPHPSyn1_W,'SynPHPSyn1');
    RegisterPropertyHelper(@TMaxForm1PHPSyntax1_R,@TMaxForm1PHPSyntax1_W,'PHPSyntax1');
    RegisterPropertyHelper(@TMaxForm1Breakpoint1_R,@TMaxForm1Breakpoint1_W,'Breakpoint1');
    RegisterPropertyHelper(@TMaxForm1SerialRS2321_R,@TMaxForm1SerialRS2321_W,'SerialRS2321');
    RegisterPropertyHelper(@TMaxForm1N14_R,@TMaxForm1N14_W,'N14');
    RegisterPropertyHelper(@TMaxForm1SynCSSyn1_R,@TMaxForm1SynCSSyn1_W,'SynCSSyn1');
    RegisterPropertyHelper(@TMaxForm1CSyntax2_R,@TMaxForm1CSyntax2_W,'CSyntax2');
    RegisterPropertyHelper(@TMaxForm1Calculator1_R,@TMaxForm1Calculator1_W,'Calculator1');
    RegisterPropertyHelper(@TMaxForm1tbtnSerial_R,@TMaxForm1tbtnSerial_W,'tbtnSerial');
    RegisterPropertyHelper(@TMaxForm1ToolButton8_R,@TMaxForm1ToolButton8_W,'ToolButton8');
    RegisterPropertyHelper(@TMaxForm1Tutorial151_R,@TMaxForm1Tutorial151_W,'Tutorial151');
    RegisterPropertyHelper(@TMaxForm1N15_R,@TMaxForm1N15_W,'N15');
    RegisterPropertyHelper(@TMaxForm1N16_R,@TMaxForm1N16_W,'N16');
    RegisterPropertyHelper(@TMaxForm1ControlBar1_R,@TMaxForm1ControlBar1_W,'ControlBar1');
    RegisterPropertyHelper(@TMaxForm1ToolBar2_R,@TMaxForm1ToolBar2_W,'ToolBar2');
    RegisterPropertyHelper(@TMaxForm1BtnOpen_R,@TMaxForm1BtnOpen_W,'BtnOpen');
    RegisterPropertyHelper(@TMaxForm1BtnSave_R,@TMaxForm1BtnSave_W,'BtnSave');
    RegisterPropertyHelper(@TMaxForm1BtnPrint_R,@TMaxForm1BtnPrint_W,'BtnPrint');
    RegisterPropertyHelper(@TMaxForm1BtnColors_R,@TMaxForm1BtnColors_W,'BtnColors');
    RegisterPropertyHelper(@TMaxForm1btnClassReport_R,@TMaxForm1btnClassReport_W,'btnClassReport');
    RegisterPropertyHelper(@TMaxForm1BtnRotateRight_R,@TMaxForm1BtnRotateRight_W,'BtnRotateRight');
    RegisterPropertyHelper(@TMaxForm1BtnFullSize_R,@TMaxForm1BtnFullSize_W,'BtnFullSize');
    RegisterPropertyHelper(@TMaxForm1BtnFitToWindowSize_R,@TMaxForm1BtnFitToWindowSize_W,'BtnFitToWindowSize');
    RegisterPropertyHelper(@TMaxForm1BtnZoomMinus_R,@TMaxForm1BtnZoomMinus_W,'BtnZoomMinus');
    RegisterPropertyHelper(@TMaxForm1BtnZoomPlus_R,@TMaxForm1BtnZoomPlus_W,'BtnZoomPlus');
    RegisterPropertyHelper(@TMaxForm1Panel1_R,@TMaxForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TMaxForm1LabelBrettgroesse_R,@TMaxForm1LabelBrettgroesse_W,'LabelBrettgroesse');
    RegisterPropertyHelper(@TMaxForm1CB1SCList_R,@TMaxForm1CB1SCList_W,'CB1SCList');
    RegisterPropertyHelper(@TMaxForm1ImageListNormal_R,@TMaxForm1ImageListNormal_W,'ImageListNormal');
    RegisterPropertyHelper(@TMaxForm1spbtnexplore_R,@TMaxForm1spbtnexplore_W,'spbtnexplore');
    RegisterPropertyHelper(@TMaxForm1spbtnexample_R,@TMaxForm1spbtnexample_W,'spbtnexample');
    RegisterPropertyHelper(@TMaxForm1spbsaveas_R,@TMaxForm1spbsaveas_W,'spbsaveas');
    RegisterPropertyHelper(@TMaxForm1imglogobox_R,@TMaxForm1imglogobox_W,'imglogobox');
    RegisterPropertyHelper(@TMaxForm1EnlargeFont1_R,@TMaxForm1EnlargeFont1_W,'EnlargeFont1');
    RegisterPropertyHelper(@TMaxForm1EnlargeFont2_R,@TMaxForm1EnlargeFont2_W,'EnlargeFont2');
    RegisterPropertyHelper(@TMaxForm1ShrinkFont1_R,@TMaxForm1ShrinkFont1_W,'ShrinkFont1');
    RegisterPropertyHelper(@TMaxForm1ThreadDemo1_R,@TMaxForm1ThreadDemo1_W,'ThreadDemo1');
    RegisterPropertyHelper(@TMaxForm1HEXEditor1_R,@TMaxForm1HEXEditor1_W,'HEXEditor1');
    RegisterPropertyHelper(@TMaxForm1HEXView1_R,@TMaxForm1HEXView1_W,'HEXView1');
    RegisterPropertyHelper(@TMaxForm1HEXInspect1_R,@TMaxForm1HEXInspect1_W,'HEXInspect1');
    RegisterPropertyHelper(@TMaxForm1SynExporterHTML1_R,@TMaxForm1SynExporterHTML1_W,'SynExporterHTML1');
    RegisterPropertyHelper(@TMaxForm1ExporttoHTML1_R,@TMaxForm1ExporttoHTML1_W,'ExporttoHTML1');
    RegisterPropertyHelper(@TMaxForm1ClassCount1_R,@TMaxForm1ClassCount1_W,'ClassCount1');
    RegisterPropertyHelper(@TMaxForm1HTMLOutput1_R,@TMaxForm1HTMLOutput1_W,'HTMLOutput1');
    RegisterPropertyHelper(@TMaxForm1HEXEditor2_R,@TMaxForm1HEXEditor2_W,'HEXEditor2');
    RegisterPropertyHelper(@TMaxForm1Minesweeper1_R,@TMaxForm1Minesweeper1_W,'Minesweeper1');
    RegisterPropertyHelper(@TMaxForm1N17_R,@TMaxForm1N17_W,'N17');
    RegisterPropertyHelper(@TMaxForm1PicturePuzzle1_R,@TMaxForm1PicturePuzzle1_W,'PicturePuzzle1');
    RegisterPropertyHelper(@TMaxForm1sbvclhelp_R,@TMaxForm1sbvclhelp_W,'sbvclhelp');
    RegisterPropertyHelper(@TMaxForm1DependencyWalker1_R,@TMaxForm1DependencyWalker1_W,'DependencyWalker1');
    RegisterPropertyHelper(@TMaxForm1WebScanner1_R,@TMaxForm1WebScanner1_W,'WebScanner1');
    RegisterPropertyHelper(@TMaxForm1View1_R,@TMaxForm1View1_W,'View1');
    RegisterPropertyHelper(@TMaxForm1mnToolbar1_R,@TMaxForm1mnToolbar1_W,'mnToolbar1');
    RegisterPropertyHelper(@TMaxForm1mnStatusbar2_R,@TMaxForm1mnStatusbar2_W,'mnStatusbar2');
    RegisterPropertyHelper(@TMaxForm1mnConsole2_R,@TMaxForm1mnConsole2_W,'mnConsole2');
    RegisterPropertyHelper(@TMaxForm1mnCoolbar2_R,@TMaxForm1mnCoolbar2_W,'mnCoolbar2');
    RegisterPropertyHelper(@TMaxForm1mnSplitter2_R,@TMaxForm1mnSplitter2_W,'mnSplitter2');
    RegisterPropertyHelper(@TMaxForm1WebServer1_R,@TMaxForm1WebServer1_W,'WebServer1');
    RegisterPropertyHelper(@TMaxForm1Tutorial17Server1_R,@TMaxForm1Tutorial17Server1_W,'Tutorial17Server1');
    RegisterPropertyHelper(@TMaxForm1Tutorial18Arduino1_R,@TMaxForm1Tutorial18Arduino1_W,'Tutorial18Arduino1');
    RegisterPropertyHelper(@TMaxForm1SynPerlSyn1_R,@TMaxForm1SynPerlSyn1_W,'SynPerlSyn1');
    RegisterPropertyHelper(@TMaxForm1PerlSyntax1_R,@TMaxForm1PerlSyntax1_W,'PerlSyntax1');
    RegisterPropertyHelper(@TMaxForm1SynPythonSyn1_R,@TMaxForm1SynPythonSyn1_W,'SynPythonSyn1');
    RegisterPropertyHelper(@TMaxForm1PythonSyntax1_R,@TMaxForm1PythonSyntax1_W,'PythonSyntax1');
    RegisterPropertyHelper(@TMaxForm1DMathLibrary1_R,@TMaxForm1DMathLibrary1_W,'DMathLibrary1');
    RegisterPropertyHelper(@TMaxForm1IntfNavigator1_R,@TMaxForm1IntfNavigator1_W,'IntfNavigator1');
    RegisterPropertyHelper(@TMaxForm1EnlargeFontConsole1_R,@TMaxForm1EnlargeFontConsole1_W,'EnlargeFontConsole1');
    RegisterPropertyHelper(@TMaxForm1ShrinkFontConsole1_R,@TMaxForm1ShrinkFontConsole1_W,'ShrinkFontConsole1');
    RegisterPropertyHelper(@TMaxForm1SetInterfaceList1_R,@TMaxForm1SetInterfaceList1_W,'SetInterfaceList1');
    RegisterPropertyHelper(@TMaxForm1popintfList_R,@TMaxForm1popintfList_W,'popintfList');
    RegisterPropertyHelper(@TMaxForm1intfAdd1_R,@TMaxForm1intfAdd1_W,'intfAdd1');
    RegisterPropertyHelper(@TMaxForm1intfDelete1_R,@TMaxForm1intfDelete1_W,'intfDelete1');
    RegisterPropertyHelper(@TMaxForm1intfRefactor1_R,@TMaxForm1intfRefactor1_W,'intfRefactor1');
    RegisterPropertyHelper(@TMaxForm1Defactor1_R,@TMaxForm1Defactor1_W,'Defactor1');
    RegisterPropertyHelper(@TMaxForm1Tutorial19COMArduino1_R,@TMaxForm1Tutorial19COMArduino1_W,'Tutorial19COMArduino1');
    RegisterPropertyHelper(@TMaxForm1Tutorial20Regex_R,@TMaxForm1Tutorial20Regex_W,'Tutorial20Regex');
    RegisterPropertyHelper(@TMaxForm1N18_R,@TMaxForm1N18_W,'N18');
    RegisterPropertyHelper(@TMaxForm1ManualE1_R,@TMaxForm1ManualE1_W,'ManualE1');
    RegisterPropertyHelper(@TMaxForm1FullTextFinder1_R,@TMaxForm1FullTextFinder1_W,'FullTextFinder1');
    RegisterPropertyHelper(@TMaxForm1Move1_R,@TMaxForm1Move1_W,'Move1');
    RegisterPropertyHelper(@TMaxForm1FractalDemo1_R,@TMaxForm1FractalDemo1_W,'FractalDemo1');
    RegisterPropertyHelper(@TMaxForm1Tutorial21Android1_R,@TMaxForm1Tutorial21Android1_W,'Tutorial21Android1');
    RegisterPropertyHelper(@TMaxForm1Tutorial0Function1_R,@TMaxForm1Tutorial0Function1_W,'Tutorial0Function1');
    RegisterPropertyHelper(@TMaxForm1SimuLogBox1_R,@TMaxForm1SimuLogBox1_W,'SimuLogBox1');
    RegisterPropertyHelper(@TMaxForm1OpenExamples1_R,@TMaxForm1OpenExamples1_W,'OpenExamples1');
    RegisterPropertyHelper(@TMaxForm1SynJScriptSyn1_R,@TMaxForm1SynJScriptSyn1_W,'SynJScriptSyn1');
    RegisterPropertyHelper(@TMaxForm1JavaScriptSyntax1_R,@TMaxForm1JavaScriptSyntax1_W,'JavaScriptSyntax1');
    RegisterPropertyHelper(@TMaxForm1Halt1_R,@TMaxForm1Halt1_W,'Halt1');
    RegisterPropertyHelper(@TMaxForm1CodeSearch1_R,@TMaxForm1CodeSearch1_W,'CodeSearch1');
    RegisterPropertyHelper(@TMaxForm1SynRubySyn1_R,@TMaxForm1SynRubySyn1_W,'SynRubySyn1');
    RegisterPropertyHelper(@TMaxForm1RubySyntax1_R,@TMaxForm1RubySyntax1_W,'RubySyntax1');
    RegisterPropertyHelper(@TMaxForm1Undo1_R,@TMaxForm1Undo1_W,'Undo1');
    RegisterPropertyHelper(@TMaxForm1SynUNIXShellScriptSyn1_R,@TMaxForm1SynUNIXShellScriptSyn1_W,'SynUNIXShellScriptSyn1');
    RegisterPropertyHelper(@TMaxForm1LinuxShellScript1_R,@TMaxForm1LinuxShellScript1_W,'LinuxShellScript1');
    RegisterPropertyHelper(@TMaxForm1Rename1_R,@TMaxForm1Rename1_W,'Rename1');
    RegisterPropertyHelper(@TMaxForm1spdcodesearch_R,@TMaxForm1spdcodesearch_W,'spdcodesearch');
    RegisterPropertyHelper(@TMaxForm1Preview1_R,@TMaxForm1Preview1_W,'Preview1');
    RegisterPropertyHelper(@TMaxForm1Tutorial22Services1_R,@TMaxForm1Tutorial22Services1_W,'Tutorial22Services1');
    RegisterPropertyHelper(@TMaxForm1Tutorial23RealTime1_R,@TMaxForm1Tutorial23RealTime1_W,'Tutorial23RealTime1');
    RegisterPropertyHelper(@TMaxForm1Configuration1_R,@TMaxForm1Configuration1_W,'Configuration1');
    RegisterPropertyHelper(@TMaxForm1MP3Player1_R,@TMaxForm1MP3Player1_W,'MP3Player1');
    RegisterPropertyHelper(@TMaxForm1DLLSpy1_R,@TMaxForm1DLLSpy1_W,'DLLSpy1');
    RegisterPropertyHelper(@TMaxForm1SynURIOpener1_R,@TMaxForm1SynURIOpener1_W,'SynURIOpener1');
    RegisterPropertyHelper(@TMaxForm1SynURISyn1_R,@TMaxForm1SynURISyn1_W,'SynURISyn1');
    RegisterPropertyHelper(@TMaxForm1URILinksClicks1_R,@TMaxForm1URILinksClicks1_W,'URILinksClicks1');
    RegisterPropertyHelper(@TMaxForm1EditReplace1_R,@TMaxForm1EditReplace1_W,'EditReplace1');
    RegisterPropertyHelper(@TMaxForm1GotoLine1_R,@TMaxForm1GotoLine1_W,'GotoLine1');
    RegisterPropertyHelper(@TMaxForm1ActiveLineColor1_R,@TMaxForm1ActiveLineColor1_W,'ActiveLineColor1');
    RegisterPropertyHelper(@TMaxForm1ConfigFile1_R,@TMaxForm1ConfigFile1_W,'ConfigFile1');
    RegisterPropertyHelper(@TMaxForm1Sort1Intflist_R,@TMaxForm1Sort1Intflist_W,'Sort1Intflist');
    RegisterPropertyHelper(@TMaxForm1Redo1_R,@TMaxForm1Redo1_W,'Redo1');
    RegisterPropertyHelper(@TMaxForm1Tutorial24CleanCode1_R,@TMaxForm1Tutorial24CleanCode1_W,'Tutorial24CleanCode1');
    RegisterPropertyHelper(@TMaxForm1Tutorial25Configuration1_R,@TMaxForm1Tutorial25Configuration1_W,'Tutorial25Configuration1');
    RegisterPropertyHelper(@TMaxForm1IndentSelection1_R,@TMaxForm1IndentSelection1_W,'IndentSelection1');
    RegisterPropertyHelper(@TMaxForm1UnindentSection1_R,@TMaxForm1UnindentSection1_W,'UnindentSection1');
    RegisterPropertyHelper(@TMaxForm1SkyStyle1_R,@TMaxForm1SkyStyle1_W,'SkyStyle1');
    RegisterPropertyHelper(@TMaxForm1N19_R,@TMaxForm1N19_W,'N19');
    RegisterPropertyHelper(@TMaxForm1CountWords1_R,@TMaxForm1CountWords1_W,'CountWords1');
    RegisterPropertyHelper(@TMaxForm1imbookmarkimages_R,@TMaxForm1imbookmarkimages_W,'imbookmarkimages');
    RegisterPropertyHelper(@TMaxForm1Bookmark11_R,@TMaxForm1Bookmark11_W,'Bookmark11');
    RegisterPropertyHelper(@TMaxForm1N20_R,@TMaxForm1N20_W,'N20');
    RegisterPropertyHelper(@TMaxForm1Bookmark21_R,@TMaxForm1Bookmark21_W,'Bookmark21');
    RegisterPropertyHelper(@TMaxForm1Bookmark31_R,@TMaxForm1Bookmark31_W,'Bookmark31');
    RegisterPropertyHelper(@TMaxForm1Bookmark41_R,@TMaxForm1Bookmark41_W,'Bookmark41');
    RegisterPropertyHelper(@TMaxForm1SynMultiSyn1_R,@TMaxForm1SynMultiSyn1_W,'SynMultiSyn1');
    RegisterPropertyHelper(@TMaxForm1myscript1_R,@TMaxForm1myscript1_W,'myscript1');
    RegisterPropertyHelper(@TMaxForm1externalapp_R,@TMaxForm1externalapp_W,'externalapp1');
    RegisterPropertyHelper(@TMaxForm1terminal_R,@TMaxForm1terminal_W,'terminal1');

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
    RegisterMethod(@TMaxForm1.PHPSyntax1Click, 'PHPSyntax1Click');
    RegisterMethod(@TMaxForm1.SerialRS2321Click, 'SerialRS2321Click');
    RegisterMethod(@TMaxForm1.CSyntax2Click, 'CSyntax2Click');
    RegisterMethod(@TMaxForm1.Calculator1Click, 'Calculator1Click');
    RegisterMethod(@TMaxForm1.Tutorial13Ciphering1Click, 'Tutorial13Ciphering1Click');
    RegisterMethod(@TMaxForm1.Tutorial14Async1Click, 'Tutorial14Async1Click');
    RegisterMethod(@TMaxForm1.PHPSyntax1Click, 'PHPSyntax1Click');
    RegisterMethod(@TMaxForm1.BtnZoomPlusClick, 'BtnZoomPlusClick');
    RegisterMethod(@TMaxForm1.BtnZoomMinusClick, 'BtnZoomMinusClick');
    RegisterMethod(@TMaxForm1.BtnClassReportClick, 'btnClassReportClick');
    RegisterMethod(@TMaxForm1.ThreadDemo1Click, 'ThreadDemo1Click');
    RegisterMethod(@TMaxForm1.HEXView1Click, 'HEXView1Click');
    RegisterMethod(@TMaxForm1.ExporttoHTML1Click, 'ExporttoHTML1Click');
    RegisterMethod(@TMaxForm1.Minesweeper1Click, 'Minesweeper1Click');
    RegisterMethod(@TMaxForm1.PicturePuzzle1Click, 'PicturePuzzle1Click');
    //RegisterMethod(@TMaxForm1.MyScript1, 'MyScript1');

    RegisterMethod(@TMaxForm1.sbvclhelpClick, 'sbvclhelpClick');
    RegisterMethod(@TMaxForm1.DependencyWalker1Click, 'DependencyWalker1Click');
    RegisterMethod(@TMaxForm1.CB1SCListDrawItem, 'CB1SCListDrawItem');
    RegisterMethod(@TMaxForm1.WebScanner1Click, 'WebScanner1Click');
    RegisterMethod(@TMaxForm1.mnToolbar1Click, 'mnToolbar1Click');
    RegisterMethod(@TMaxForm1.mnStatusbar2Click, 'mnStatusbar2Click');
    RegisterMethod(@TMaxForm1.mnConsole2Click, 'mnConsole2Click');
    RegisterMethod(@TMaxForm1.mnCoolbar2Click, 'mnCoolbar2Click');
    RegisterMethod(@TMaxForm1.mnSplitter2Click, 'mnSplitter2Click');
    RegisterMethod(@TMaxForm1.WebServer1Click, 'webServer1Click');
    RegisterMethod(@TMaxForm1.PerlSyntax1Click, 'PerlSyntax1Click');
    RegisterMethod(@TMaxForm1.PythonSyntax1Click, 'PythonSyntax1Click');
    RegisterMethod(@TMaxForm1.DMathLibrary1Click, 'DMathLibrary1Click');
    RegisterMethod(@TMaxForm1.IntfNavigator1Click, 'IntfNavigator1Click');
    RegisterMethod(@TMaxForm1.getActFileName, 'AppName');
    RegisterMethod(@TMaxForm1.getActFileName, 'ScriptName');  //alias
    //RegisterMethod(@getAppName, 'FileName');  //alias
    RegisterMethod(@TMaxForm1.getLastFileName, 'LastName');
    RegisterMethod(@TMaxForm1.FractalDemo1Click , 'FractalDemo1Click');
    RegisterMethod(@TMaxForm1.SimuLogBox1Click, 'SimuLogBox1Click');
    RegisterMethod(@TMaxForm1.Halt1Click , 'Halt1Click');
    RegisterMethod(@TMaxForm1.Halt1Click , 'Stop');        //Alias
    RegisterMethod(@TMaxForm1.CodeSearch1Click, 'CodeSearch');        //Alias
    RegisterMethod(@TMaxForm1.RubySyntax1Click, 'RubySyntax1Click');
    RegisterMethod(@TMaxForm1.Undo1Click, 'Undo1Click');
    RegisterMethod(@TMaxForm1.LinuxShellScript1Click, 'LinuxShellScript1Click');
    RegisterPropertyHelper(@TMaxForm1IPhost_R,@TMaxForm1IPhost_W,'IPHost');
    RegisterPropertyHelper(@TMaxForm1IPPort_R,@TMaxForm1IPPort_W,'IPPort');
    RegisterPropertyHelper(@TMaxForm1COMPort_R,@TMaxForm1COMPort_W,'COMPort');
    RegisterMethod(@TMaxForm1.WebScannerDirect, 'WebScannerDirect');
    RegisterMethod(@TMaxForm1.WebScannerDirect, 'WebScanner');
    RegisterMethod(@TMaxForm1.LoadInterfaceList2, 'LoadInterfaceList2');
    RegisterMethod(@TMaxForm1.FullTextfinder1Click, 'FullTextfinder1Click');
    RegisterMethod(@TMaxForm1.OpenExamples1Click, 'OpenExamples1Click');
    RegisterMethod(@TMaxForm1.JavaScriptSyntax1Click, 'JavaScriptSyntax1Click');
    RegisterMethod(@TMaxForm1.DLLSpy1Click, 'DLLSpy1Click');
    RegisterMethod(@TMaxForm1.Memo1DblClick, 'Memo1DblClick');
    RegisterMethod(@TMaxForm1.URILinksClicks1Click, 'URILinksClicks1Click');
    RegisterMethod(@TMaxForm1.GotoLine1Click, 'GotoLine1Click');
    RegisterMethod(@TMaxForm1.ConfigFile1Click, 'ConfigFile1Click');
    RegisterMethod(@TMaxForm1.ActiveLineColor1Click, 'ActiveLineColor1Click');
    //RegisterMethod(@TMaxForm1.DoEditorExecuteCommand, 'DoEditorExecuteCommand');
    RegisterMethod(@TMaxForm1.SkyStyle1Click, 'SkyStyle1Click');
    RegisterMethod(@TMaxForm1.CountWords1Click, 'CountWords1Click');
    RegisterMethod(@TMaxForm1.Memo1PlaceBookmark, 'Memo1PlaceBookmark');
    RegisterMethod(@TMaxForm1.Memo1GutterClick, 'Memo1GutterClick');
    RegisterMethod(@TMaxForm1.Bookmark11Click, 'Bookmark11Click');
    RegisterMethod(@TMaxForm1.Bookmark21Click, 'Bookmark21Click');
    RegisterMethod(@TMaxForm1.Bookmark31Click, 'Bookmark31Click');
    RegisterMethod(@TMaxForm1.Bookmark41Click, 'Bookmark41Click');
    RegisterMethod(@TMaxForm1.GetStatChange, 'GetStatChange');
    RegisterMethod(@TMaxForm1.SetStatChange, 'SetStatChange');
    RegisterMethod(@TMaxForm1.GetActFileName, 'GetActFileName');
    RegisterMethod(@TMaxForm1.SetActFileName, 'SetActFileName');
    RegisterMethod(@TMaxForm1.GetActiveLineColor, 'GetActiveLineColor');
    RegisterMethod(@TMaxForm1.SetActiveLineColor, 'SetActiveLineColor');
    RegisterMethod(@TMaxForm1.GetLastFileName, 'GetLastFileName');
    RegisterMethod(@TMaxForm1.SetLastFileName, 'SetLastFileName');
    RegisterMethod(@TMaxForm1.WebScannerDirect, 'WebScannerDirect');
    RegisterMethod(@TMaxForm1.LoadInterfaceList2, 'LoadInterfaceList2');
    RegisterMethod(@TMaxForm1.GetStatExecuteShell, 'GetStatExecuteShell');
    RegisterMethod(@TMaxForm1.DoEditorExecuteCommand, 'DoEditorExecuteCommand');
    RegisterMethod(@TMaxForm1.ScriptListbox1Click, 'ScriptListbox1Click');
    RegisterMethod(@TMaxForm1.Memo2KeyPress, 'Memo2KeyPress');
    RegisterMethod(@TMaxForm1.Bookmark51Click, 'Bookmark51Click');
    RegisterMethod(@TMaxForm1.EnlargeGutter1Click, 'EnlargeGutter1Click');
    RegisterMethod(@TMaxForm1.Tetris1Click, 'Tetris1Click');
    RegisterMethod(@TMaxForm1.ToDoList1Click, 'ToDoList1Click');
    RegisterMethod(@TMaxForm1.ProcessList1Click, 'ProcessList1Click');
    RegisterMethod(@TMaxForm1.TCPSockets1Click, 'TCPSockets1Click');
    RegisterMethod(@TMaxForm1.ConfigUpdate1Click, 'ConfigUpdate1Click');
    RegisterMethod(@TMaxForm1.ADOWorkbench1Click, 'ADOWorkbench1Click');
    RegisterMethod(@TMaxForm1.SocketServer1Click, 'SocketServer1Click');
    RegisterMethod(@TMaxForm1.FormDemo1Click, 'FormDemo1Click');
    RegisterMethod(@TMaxForm1.Richedit1Click, 'Richedit1Click');
    RegisterMethod(@TMaxForm1.SimpleBrowser1Click, 'SimpleBrowser1Click');
    RegisterMethod(@TMaxForm1.DOSShell1Click, 'DOSShell1Click');
    RegisterMethod(@TMaxForm1.SynExport1Click, 'SynExport1Click');
    RegisterMethod(@TMaxForm1.ExporttoRTF1Click, 'ExporttoRTF1Click');
    RegisterMethod(@TMaxForm1.FormCloseQuery, 'FormCloseQuery');
    RegisterMethod(@TMaxForm1.SOAPTester1Click, 'SOAPTester1Click');
    RegisterMethod(@TMaxForm1.Sniffer1Click, 'Sniffer1Click');
    RegisterMethod(@TMaxForm1.AutoDetectSyntax1Click, 'AutoDetectSyntax1Click');
    RegisterMethod(@TMaxForm1.FPlot1Click, 'FPlot1Click');
    RegisterMethod(@TMaxForm1.PasStyle1Click, 'PasStyle1Click');
    RegisterMethod(@TMaxForm1.Tutorial183RGBLED1Click, 'Tutorial183RGBLED1Click');
    RegisterMethod(@TMaxForm1.Reversi1Click, 'Reversi1Click');
    RegisterMethod(@TMaxForm1.ManualmaXbox1Click, 'ManualmaXbox1Click');
    RegisterMethod(@TMaxForm1.BlaisePascalMagazine1Click, 'BlaisePascalMagazine1Click');
    RegisterMethod(@TMaxForm1.AddToDo1Click, 'AddToDo1Click');
    RegisterMethod(@TMaxForm1.CreateGUID1Click, 'CreateGUID1Click');
    RegisterMethod(@TMaxForm1.Tutorial27XML1Click, 'Tutorial27XML1Click');
    RegisterMethod(@TMaxForm1.CreateDLLStub1Click, 'CreateDLLStub1Click');
    RegisterMethod(@TMaxForm1.Tutorial28DLL1Click, 'Tutorial28DLL1Click');
    RegisterMethod(@TMaxForm1.ResetKeyPressed, 'ResetKeyPressed');
    RegisterMethod(@TMaxForm1.ResetKeyPressed, 'KeyPressedFalse');
    RegisterMethod(@TMaxForm1.FileChanges1Click, 'FileChanges1Click');
    RegisterMethod(@TMaxForm1.OpenGLTry1Click, 'OpenGLTry1Click');
    RegisterMethod(@TMaxForm1.AllUnitList1Click, 'AllUnitList1Click');
    RegisterMethod(@TMaxForm1.CreateHeader1Click, 'CreateHeader1Click');
    RegisterMethod(@TMaxForm1.Tutorial29UMLClick, 'Tutorial29UMLClick');
    RegisterMethod(@TMaxForm1.Oscilloscope1Click, 'Oscilloscope1Click');
    RegisterMethod(@TMaxForm1.Tutorial30WOT1Click, 'Tutorial30WOT1Click');
    RegisterMethod(@TMaxForm1.GetWebScript1Click, 'GetWebScript1Click');
    RegisterMethod(@TMaxForm1.Checkers1Click, 'Checkers1Click');
    RegisterMethod(@TMaxForm1.TaskMgr1Click, 'TaskMgr1Click');
    RegisterMethod(@TMaxForm1.WebCam1Click, 'WebCam1Click');
    RegisterMethod(@TMaxForm1.Tutorial31Closure1Click, 'Tutorial31Closure1Click');
    RegisterMethod(@TMaxForm1.GEOMapView1Click, 'GEOMapView1Click');
    RegisterMethod(@TMaxForm1.Run1Click, 'Run1Click');
    RegisterMethod(@TMaxForm1.GPSSatView1Click, 'GPSSatView1Click');
    RegisterMethod(@TMaxForm1.N3DLab1Click, 'N3DLab1Click');
    RegisterMethod(@TMaxForm1.ExternalApp1Click, 'ExternalApp1Click');
    RegisterMethod(@TMaxForm1.PANView1Click, 'PANView1Click');
    RegisterMethod(@TMaxForm1.UnitConverter1Click, 'UnitConverter1Click');
    RegisterMethod(@TMaxForm1.MyScript1Click, 'MyScript1Click');
    RegisterMethod(@TMaxForm1.terminal1click, 'Terminal1Click');
    RegisterMethod(@TMaxForm1.TrainingArduino1Click, 'TrainingArduino1Click');
    RegisterMethod(@TMaxForm1.SaveByteCode, 'SaveByteCode');
    RegisterMethod(@TMaxForm1.Chess41Click, 'Chess41Click');
    RegisterMethod(@TMaxForm1.OrangeStyle1Click, 'OrangeStyle1Click');

    //procedure OrangeStyle1Click(Sender: TObject);
     //RegisterMethod(@TMaxForm1.ExternalApp1, 'ExternalApp1');
             //  GetWebScript1Click
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
