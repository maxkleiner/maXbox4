{ ****************************************************************
  sourcefile :    fMain.pas
  typ :  	        boundary-Unit
  author :  	    RemObjects, max kleiner, LoC's 1005
  description :   handles scriptloading and user events	ügung
  classes :	      see ModelMaker ps#12
  specials : 	    cooperates with uPS* units/ namespace
  revisions :     20.07.04 build menu structure
		              22.07.04 enlarge register functions
                  10.08.04 options menu, 3 file examples
                  28.08.04 kylix 2 branch, checked uses
                  10.01.05 show & save bytecode in memo
                  23.01.05 rebuild, save handling d6 from kylix2
                  30.01.05 initial dir, pascal analyzer checks
                  08.08.05 clx corrections
                  10.01.06 add random, pos, sleep, delete, max in kernel
                  07.07.06 line numbers in editor
                  19.07.06 OOP extensions, search and inc in kernel
                  20.07.06 line numbers read only
                  21.07.06 ini file read & write
                  11.11.07 SynEdit, timer events, showmessage and oop examples
                  12.12.07 Search & Replace functions   locs = 766
                  26.04.08 findfirst extension & save the monitor,locs = 812
                  04.05.08 random2, fileexists as double, now string,locs = 836
                  13.10.08 filename with *.txt, drag n drop super function
                  19.10.08 include file, print func, comp messages,locs= 970
                  08.04.09 ln, tsearchrec, now2, extract func, timer, locs 1005
                  05.10.09 V2.7 include tstringgrid and treeview, func max3,
                   reversestring, linenumbers, tabs, statusline, locs = 1136
                  09.10.09 timer, datetimefunctions, less plugin, locs= 1166
                  12.10.09 mathmax lib, lastfile and savefile, locs= 1205
                  V 2.7.1  compiledebug, executedebug, decompile, mp3 locs=1551
                  22.01.10 V 2.8 debug checks, assign2, history file in ini
    locs=1605     16.3.10 V2.8.1 shell, math, memo update, undo,"last file" bug
    locs=1690     1.6.10 v2.9 preps, UseCase, DB,codefont, Tpicture bitmap
    locs=1722     V2.9.1. http connection, UseCase free draw
    locs=1798     V2.9.2  ftp, html, memo2 access, show interface
    locs=1974    V3.0 pop3, png, smtp, exceptionlog, emails, RegEX, sysutils
         2130     V3.1 dynarrays, csyntax, menu, assignfile, bytecode load
         2428    Grids, tcpconnection, messagebox, printer, output menu, menus, buttons
                 V3.2, SQLExpress, DBX, ADO, DateTime2, StringHelper, Fileutils, Jedi,XML
         2486     V3.3, CipherBox, instance, componentcount, API extensions
         2650    V3.5 contnrs, mybiginteger, masks, convutils, java syn
                 hash md5, syntaxcheck, logwrite, SHA1, ASN1 functions
         2828    V3.5.1 dbgrid, dbctrls, imagelist, system core, calendar, outline
         2858    V3.6    comctrls, dalvik test, timetable calendar , stdconv., dialogs
         2877    V3.6.1  controls functions, tdbclientdataset, Tprovider, FBCD
         2932    V3.6.2  CDSUtil, system vars, resourcefinder
         3002    V3.6.3  math with jcl, stopwatch class, win types, jcl div.
         3020    V3.7 System Utils - WideStrUtils - GraphUtil; ControlsUtils -HTTPUtils
         3142    V3.7.1 InstanceSize, WebDB, FileInfo, arduino examples
         3189    V3.8.0 beta to 4.0 mX4 compiler with unicode, 64bit, units, open arrays
                        bootscript, versioncheck
         3250    V3.8.1 dragndrop usecase, 10 add units, print exception
         3292    V3.8.2 AES, SHA256, CryptoBox, LockBox3 Units, perf counter
         3339    V3.8.2.1 passworddlg, module list, loadlibrary, AddOns restructure
         3362    V3.8.2.4  JCLVCLutils, CAD functions, tutor 14
         3414    V3.8.4  CryptoBox31, fasttimer, first android draft, PHP Syn, Jutils
         3442    V3.8.4.1 TSerial (RS232) for Arduino, more Jutils
         3525    V3.8.5 Serial, JvComponent , langhighlight
         3538    V3.8.5.1 Bugfixing in math, variant and serial, BDE Utils, JDatUtils
         3564    V3.8.6, Jedi Base and all Util, Utils Functions , Comp&Memory Info
         3727    V3.8.6.2 hashtable, win64 routines, ttextstream, workbench GUI
         3760    V3.8.6.3 thread proto, JVGUtils, Turtle, LED, more overload
         3808    V3.8.6.4  classes and types , expression parser, html export
         3870    V3.9   DB-Functions, more WinAPI, Activity-Diagram, syn RegEx
         3952    V3.9.1 systools by turbopower, picture puzzle, tpoint bug, jpeg
         3990    V3.9.2 asynclib, paralleljobs beta frame, syncobjs, lwshell
         4246    V3.9.3 navigation, ttreeview, units explorer, web scanner
         4286    V3.9.3.6  7 units , CLI bugfix, webserver, context uc
         4315    V3.9.4.4  2 tutorials, 5 units, bugfixes, http post
         4390    V3.9.6.0 perl regex, SQL extensions, FTP, EKON functions, memreport
         4402    V3.9.6.1 app.exception , scanf, raise type
         4672    V3.9.6.3.c bugfix december, interface navigator, more units
         4812    V3.9.6.4  decimals, history=9 , OLE , extini
         4920    V3.9.7.1.a fulltextfinder, navigator2, flat unit , 4units
         4990    V3.9.7.3/4  9 units, tmessage , simulator unit
         5111    V3.9.7.5 add 9 units, simu add on, several bugfixes in routines
         5258    V3.9.8.0  halt routine, 18 units, java intf, duallist, codesearch!
         5373    V3.9.8.2  ruby syn, extctrls2, codesearch for pas&txt, webscanner
         5484    V3.9.8.5  more res, add units , bigadd, page numbers, TFunc
         5522    V3.9.8.6  add 11 units, sound gen,
         5578    V3.9.8.8  add 5 units, Synopse framework, PFDLib, Zip-Unzip, Reg
         5988    V3.9.8.9  synedit api , macros, more config, refactor, reflecting
         6490    V3.9.9.1  anyhighlight, one webservice, commandprocessor, bookmarks
         6680    V3.9.9.5  rest framework, delphisockets, easyxML, barcode
         6865    V3.9.9.6  devcpp extensions , sendmail, dbgrid2
         7055    V3.9.9.7  constructors, posmarks, navlist
         7284    V3.9.9.8 november , extreme socks, fastfinder, add units
                          todolist, finderlinks
                          test for code folding and indent
                  V4.0   in  June 2014     - test code
 ************************************************************************** }

unit fMain;

interface

uses
  Forms, SysUtils, uPSComponent, uPSCompiler, uPSRuntime, Menus,
  Classes, ExtCtrls, Controls, StdCtrls,  SynEditHighlighter,
  SynHighlighterPas, SynEdit, SynMemo, SynEditMiscClasses, SynEditSearch,
  XPMan, Buttons, Dialogs, uPSComponent_Default, Messages,
  uPSComponent_Controls, SynCompletionProposal, SynEditPrint, SynEditAutoComplete,
  ImgList, ComCtrls, ToolWin, Graphics, uPSDebugger, uPSDisassembly,
  uPSComponent_COM, uPSComponent_StdCtrls, uPSComponent_Forms, uPSComponent_DB,
  SynHighlighterHtml, SynHighlighterTeX, SynHighlighterCpp, SynHighlighterSQL,
  SynHighlighterXML, SynHighlighterJava,  ide_debugoutput, SynHighlighterPHP,
  SynHighlighterCS, SynEditExport, SynExportHTML, Types, SynHighlighterPerl,
  SynHighlighterPython, SynHighlighterJScript, SynHighlighterRuby,
  SynHighlighterUNIXShellScript, SynEditPrintPreview, SynEditPrintTypes,
  SynHighlighterURI, SynURIOpener, SynHighlighterMulti, syneditcodefolding; //, jpeg;

const
   BYTECODE = 'bytecode.psb';        //3.5
   PSTEXT = 'PS Scriptfiles (*.txt)|*.TXT';
   PSMODEL = 'PS Modelfiles (*.uc)|*.UC';
   PSPASCAL ='PS Pascalfiles (*.pas)|*.PAS';
   PSINC = 'PS Includes (*.inc)|*.INC';
   DEFFILENAME = 'firstdemo.txt';
   DEFINIFILE = 'maxboxdef.ini';
   EXCEPTLOGFILE = 'maxboxerrorlog.txt';
   ALLFUNCTIONSLIST = 'upsi_allfunctionslist.txt';
   ALLFUNCTIONSLISTPDF = 'maxbox_functions_all.pdf';
   ALLOBJECTSLIST = 'docs\VCL.pdf';
   ALLRESOURCELIST = 'docs\upsi_allresourcelist.txt';
   ALLTYPELIST = 'maxbox_types.pdf'; //'maXboxTypeList.pdf';
   INCLUDEBOX = 'pas_includebox.inc';
   BOOTSCRIPT = 'maxbootscript.txt';
   MBVERSION = '3.9.9.8';
   MBVER = '399';              //for checking!
   EXENAME ='maXbox3.exe';
   MXSITE = 'http://www.softwareschule.ch/maxbox.htm';
   MXVERSIONFILE = 'http://www.softwareschule.ch/maxvfile.txt';
   MXINTERNETCHECK = 'www.ask.com';
   MXMAIL = 'max@kleiner.com';
   TAB = #$09;
   CODECOMPLETION ='bds_delphi.dci';

type
  TMaxForm1 = class(TForm)
    memo2: TMemo;
    Splitter1: TSplitter;
    PSScript: TPSScript;
    PS3DllPlugin: TPSDllPlugin;
    MainMenu1: TMainMenu;
    Program1: TMenuItem;
    Compile1: TMenuItem;
    Files1: TMenuItem;
    open1: TMenuItem;
    Save2: TMenuItem;
    Options1: TMenuItem;
    Savebefore1: TMenuItem;
    Largefont1: TMenuItem;
    sBytecode1: TMenuItem;
    Saveas3: TMenuItem;
    Clear1: TMenuItem;
    Slinenumbers1: TMenuItem;
    About1: TMenuItem;
    Search1: TMenuItem;
    SynPasSyn1: TSynPasSyn;
    memo1: TSynMemo;
    SynEditSearch1: TSynEditSearch;
    WordWrap1: TMenuItem;
    XPManifest1: TXPManifest;
    SearchNext1: TMenuItem;
    Replace1: TMenuItem;
    PSImport_Controls1: TPSImport_Controls;
    PSImport_Classes1: TPSImport_Classes;
    ShowInclude1: TMenuItem;
    SynEditPrint1: TSynEditPrint;
    Printout1: TMenuItem;
    mnPrintColors1: TMenuItem;
    dlgFilePrint: TPrintDialog;
    dlgPrintFont1: TFontDialog;
    mnuPrintFont1: TMenuItem;
    Include1: TMenuItem;
    CodeCompletionList1: TMenuItem;
    IncludeList1: TMenuItem;
    ImageList1: TImageList;
    ImageList2: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    tbtnLoad: TToolButton;
    ToolButton2: TToolButton;
    tbtnFind: TToolButton;
    tbtnCompile: TToolButton;
    tbtnTrans: TToolButton;
    ToolButton5: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    statusBar1: TStatusBar;
    SaveOutput1: TMenuItem;
    ExportClipboard1: TMenuItem;
    Close1: TMenuItem;
    Manual1: TMenuItem;
    About2: TMenuItem;
    loadLastfile1: TMenuItem;
    imglogo: TImage;
    cedebug: TPSScriptDebugger;
    debugPopupMenu1: TPopupMenu;
    BreakPointMenu: TMenuItem;
    Decompile1: TMenuItem;
    N2: TMenuItem;
    StepInto1: TMenuItem;
    StepOut1: TMenuItem;
    Reset1: TMenuItem;
    N3: TMenuItem;
    DebugRun1: TMenuItem;
    PSImport_ComObj1: TPSImport_ComObj;
    PSImport_StdCtrls1: TPSImport_StdCtrls;
    PSImport_Forms1: TPSImport_Forms;
    PSImport_DateUtils1: TPSImport_DateUtils;
    tutorial4: TMenuItem;
    ExporttoClipboard1: TMenuItem;
    ImportfromClipboard1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    ImportfromClipboard2: TMenuItem;
    tutorial1: TMenuItem;
    N7: TMenuItem;
    ShowSpecChars1: TMenuItem;
    OpenDirectory1: TMenuItem;
    procMess: TMenuItem;
    tbtnUseCase: TToolButton;
    ToolButton7: TToolButton;
    EditFont1: TMenuItem;
    UseCase1: TMenuItem;
    tutorial21: TMenuItem;
    OpenUseCase1: TMenuItem;
    PSImport_DB1: TPSImport_DB;
    tutorial31: TMenuItem;
    SynHtmlSyn1: TSynHTMLSyn;
    HTMLSyntax1: TMenuItem;
    ShowInterfaces1: TMenuItem;
    Tutorial5: TMenuItem;
    AllFunctionsList1: TMenuItem;
    ShowLastException1: TMenuItem;
    PlayMP31: TMenuItem;
    SynTeXSyn1: TSynTeXSyn;
    texSyntax1: TMenuItem;
    N8: TMenuItem;
    GetEMails1: TMenuItem;
    SynCppSyn1: TSynCppSyn;
    CSyntax1: TMenuItem;
    Tutorial6: TMenuItem;
    New1: TMenuItem;
    AllObjectsList1: TMenuItem;
    LoadBytecode1: TMenuItem;
    CipherFile1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    Tutorial11: TMenuItem;
    Tutorial71: TMenuItem;
    UpdateService1: TMenuItem;
    PascalSchool1: TMenuItem;
    Tutorial81: TMenuItem;
    DelphiSite1: TMenuItem;
    Output1: TMenuItem;
    TerminalStyle1: TMenuItem;
    ReadOnly1: TMenuItem;
    ShellStyle1: TMenuItem;
    BigScreen1: TMenuItem;
    Tutorial91: TMenuItem;
    SaveOutput2: TMenuItem;
    N11: TMenuItem;
    SaveScreenshot: TMenuItem;
    Tutorial101: TMenuItem;
    SQLSyntax1: TMenuItem;
    SynSQLSyn1: TSynSQLSyn;
    Console1: TMenuItem;
    SynXMLSyn1: TSynXMLSyn;
    XMLSyntax1: TMenuItem;
    ComponentCount1: TMenuItem;
    NewInstance1: TMenuItem;
    toolbtnTutorial: TToolButton;
    Memory1: TMenuItem;
    SynJavaSyn1: TSynJavaSyn;
    JavaSyntax1: TMenuItem;
    SyntaxCheck1: TMenuItem;
    Tutorial10Statistics1: TMenuItem;
    ScriptExplorer1: TMenuItem;
    FormOutput1: TMenuItem;
    ArduinoDump1: TMenuItem;
    AndroidDump1: TMenuItem;
    GotoEnd1: TMenuItem;
    AllResourceList1: TMenuItem;
    ToolButton4: TToolButton;
    tbtn6res: TToolButton;
    Tutorial11Forms1: TMenuItem;
    Tutorial12SQL1: TMenuItem;
    ResourceExplore1: TMenuItem;
    Info1: TMenuItem;
    N12: TMenuItem;
    CryptoBox1: TMenuItem;
    Tutorial13Ciphering1: TMenuItem;
    CipherFile2: TMenuItem;
    N13: TMenuItem;
    ModulesCount1: TMenuItem;
    AddOns2: TMenuItem;
    N4GewinntGame1: TMenuItem;
    DocuforAddOns1: TMenuItem;
    Tutorial14Async1: TMenuItem;
    Lessons15Review1: TMenuItem;
    SynPHPSyn1: TSynPHPSyn;
    PHPSyntax1: TMenuItem;
    Breakpoint1: TMenuItem;
    SerialRS2321: TMenuItem;
    N14: TMenuItem;
    SynCSSyn1: TSynCSSyn;
    CSyntax2: TMenuItem;
    Calculator1: TMenuItem;
    tbtnSerial: TToolButton;
    ToolButton8: TToolButton;
    Tutorial151: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    ControlBar1: TControlBar;
    ToolBar2: TToolBar;
    BtnOpen: TToolButton;
    BtnSave: TToolButton;
    BtnPrint: TToolButton;
    BtnColors: TToolButton;
    btnClassReport: TToolButton;
    BtnRotateRight: TToolButton;
    BtnFullSize: TToolButton;
    BtnFitToWindowSize: TToolButton;
    BtnZoomMinus: TToolButton;
    BtnZoomPlus: TToolButton;
    Panel1: TPanel;
    LabelBrettgroesse: TLabel;
    CB1SCList: TComboBox;
    ImageListNormal: TImageList;
    spbtnexplore: TSpeedButton;
    spbtnexample: TSpeedButton;
    spbsaveas: TSpeedButton;
    imglogobox: TImage;
    EnlargeFont1: TMenuItem;
    EnlargeFont2: TMenuItem;
    ShrinkFont1: TMenuItem;
    ThreadDemo1: TMenuItem;
    HEXEditor1: TMenuItem;
    HEXView1: TMenuItem;
    HEXInspect1: TMenuItem;
    SynExporterHTML1: TSynExporterHTML;
    ExporttoHTML1: TMenuItem;
    ClassCount1: TMenuItem;
    HTMLOutput1: TMenuItem;
    HEXEditor2: TMenuItem;
    Minesweeper1: TMenuItem;
    N17: TMenuItem;
    PicturePuzzle1: TMenuItem;
    sbvclhelp: TSpeedButton;
    DependencyWalker1: TMenuItem;
    WebScanner1: TMenuItem;
    View1: TMenuItem;
    mnToolbar1: TMenuItem;
    mnStatusbar2: TMenuItem;
    mnConsole2: TMenuItem;
    mnCoolbar2: TMenuItem;
    mnSplitter2: TMenuItem;
    WebServer1: TMenuItem;
    Tutorial17Server1: TMenuItem;
    Tutorial18Arduino1: TMenuItem;
    SynPerlSyn1: TSynPerlSyn;
    PerlSyntax1: TMenuItem;
    SynPythonSyn1: TSynPythonSyn;
    PythonSyntax1: TMenuItem;
    DMathLibrary1: TMenuItem;
    IntfNavigator1: TMenuItem;
    EnlargeFontConsole1: TMenuItem;
    ShrinkFontConsole1: TMenuItem;
    SetInterfaceList1: TMenuItem;
    popintfList: TPopupMenu;
    intfAdd1: TMenuItem;
    intfDelete1: TMenuItem;
    intfRefactor1: TMenuItem;
    Defactor1: TMenuItem;
    Tutorial19COMArduino1: TMenuItem;
    Tutorial20Regex: TMenuItem;
    N18: TMenuItem;
    ManualE1: TMenuItem;
    FullTextFinder1: TMenuItem;
    Move1: TMenuItem;
    FractalDemo1: TMenuItem;
    Tutorial21Android1: TMenuItem;
    Tutorial0Function1: TMenuItem;
    SimuLogBox1: TMenuItem;
    OpenExamples1: TMenuItem;
    SynJScriptSyn1: TSynJScriptSyn;
    JavaScriptSyntax1: TMenuItem;
    Halt1: TMenuItem;
    CodeSearch1: TMenuItem;
    SynRubySyn1: TSynRubySyn;
    RubySyntax1: TMenuItem;
    Undo1: TMenuItem;
    SynUNIXShellScriptSyn1: TSynUNIXShellScriptSyn;
    LinuxShellScript1: TMenuItem;
    Rename1: TMenuItem;
    spdcodesearch: TSpeedButton;
    Preview1: TMenuItem;
    Tutorial22Services1: TMenuItem;
    Tutorial23RealTime1: TMenuItem;
    Configuration1: TMenuItem;
    MP3Player1: TMenuItem;
    DLLSpy1: TMenuItem;
    SynURIOpener1: TSynURIOpener;
    SynURISyn1: TSynURISyn;
    URILinksClicks1: TMenuItem;
    EditReplace1: TMenuItem;
    GotoLine1: TMenuItem;
    ActiveLineColor1: TMenuItem;
    ConfigFile1: TMenuItem;
    Sort1Intflist: TMenuItem;
    Redo1: TMenuItem;
    Tutorial24CleanCode1: TMenuItem;
    Tutorial25Configuration1: TMenuItem;
    IndentSelection1: TMenuItem;
    UnindentSection1: TMenuItem;
    SkyStyle1: TMenuItem;
    N19: TMenuItem;
    CountWords1: TMenuItem;
    imbookmarkimages: TImageList;
    Bookmark11: TMenuItem;
    N20: TMenuItem;
    Bookmark21: TMenuItem;
    Bookmark31: TMenuItem;
    Bookmark41: TMenuItem;
    SynMultiSyn1: TSynMultiSyn;
    ScriptListbox1: TMenuItem;
    CountWords2: TMenuItem;
    Bookmark51: TMenuItem;
    EnlargeGutter1: TMenuItem;
    Tetris1: TMenuItem;
    ToDoList1: TMenuItem;
    ProcessList1: TMenuItem;
    MetricReport1: TMenuItem;
    InternetRadio1: TMenuItem;
    TCPSockets1: TMenuItem;
    ConfigUpdate1: TMenuItem;
    ShowIndent1: TMenuItem;
    procedure IFPS3ClassesPlugin1CompImport(Sender: TObject; x: TPSPascalCompiler);
    procedure IFPS3ClassesPlugin1ExecImport(Sender: TObject; Exec: TPSExec; x: TPSRuntimeClassImporter);
    procedure PSScriptCompile(Sender: TPSScript);
    procedure Compile1Click(Sender: TObject);
    procedure PSScriptExecute(Sender: TPSScript);
    procedure open1Click(Sender: TObject);
    procedure Save2Click(Sender: TObject);
    procedure Savebefore1Click(Sender: TObject);
    procedure Largefont1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SBytecode1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Saveas3Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Slinenumbers1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Search1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1ReplaceText(Sender: TObject; const ASearch,
      AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure Memo1StatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure WordWrap1Click(Sender: TObject);
    procedure SearchNext1Click(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
    function PSScriptNeedFile(Sender: TObject; const OrginFileName: String;
      var FileName, Output: String): Boolean;
    procedure ShowInclude1Click(Sender: TObject);
    procedure Printout1Click(Sender: TObject);
    procedure mnuPrintFont1Click(Sender: TObject);
    procedure Include1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateView1Click(Sender: TObject);
    procedure CodeCompletionList1Click(Sender: TObject);
    procedure SaveOutput1Click(Sender: TObject);
    procedure ExportClipboard1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Manual1Click(Sender: TObject);
    procedure LoadLastFile1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Decompile1Click(Sender: TObject);
    procedure StepInto1Click(Sender: TObject);
    procedure StepOut1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure cedebugAfterExecute(Sender: TPSScript);
    procedure cedebugBreakpoint(Sender: TObject; const FileName: String;
      Position, Row, Col: Cardinal);
    procedure cedebugCompile(Sender: TPSScript);
    procedure cedebugExecute(Sender: TPSScript);
    procedure cedebugIdle(Sender: TObject);
    procedure cedebugLineInfo(Sender: TObject; const FileName: String;
      Position, Row, Col: Cardinal);
    procedure Memo1SpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure BreakPointMenuClick(Sender: TObject);
    procedure DebugRun1Click(Sender: TObject);
    procedure tutorial4Click(Sender: TObject);
    procedure ImportfromClipboard1Click(Sender: TObject);
    procedure ImportfromClipboard2Click(Sender: TObject);
    procedure tutorial1Click(Sender: TObject);
    procedure ShowSpecChars1Click(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure PSScriptLine(Sender: TObject);
    procedure OpenDirectory1Click(Sender: TObject);
    procedure procMessClick(Sender: TObject);
    procedure tbtnUseCaseClick(Sender: TObject);
    procedure EditFont1Click(Sender: TObject);
    procedure tutorial21Click(Sender: TObject);
    procedure tutorial31Click(Sender: TObject);
    procedure HTMLSyntax1Click(Sender: TObject);
    procedure ShowInterfaces1Click(Sender: TObject);
    procedure Tutorial5Click(Sender: TObject);
    procedure ShowLastException1Click(Sender: TObject);
    procedure PlayMP31Click(Sender: TObject);
    procedure AllFunctionsList1Click(Sender: TObject);
    procedure texSyntax1Click(Sender: TObject);
    procedure GetEMails1Click(Sender: TObject);
    procedure CSyntax1Click(Sender: TObject);
    procedure Tutorial6Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure AllObjectsList1Click(Sender: TObject);
    procedure LoadBytecode1Click(Sender: TObject);
    procedure CipherFile1Click(Sender: TObject);
    procedure Tutorial71Click(Sender: TObject);
    procedure UpdateService1Click(Sender: TObject);
    procedure PascalSchool1Click(Sender: TObject);
    procedure Tutorial81Click(Sender: TObject);
    procedure DelphiSite1Click(Sender: TObject);
    procedure TerminalStyle1Click(Sender: TObject);
    procedure ReadOnly1Click(Sender: TObject);
    procedure ShellStyle1Click(Sender: TObject);
    procedure BigScreen1Click(Sender: TObject);
    procedure Tutorial91Click(Sender: TObject);
    procedure SaveScreenshotClick(Sender: TObject);
    procedure Tutorial101Click(Sender: TObject);
    procedure SQLSyntax1Click(Sender: TObject);
    procedure Console1Click(Sender: TObject);
    procedure XMLSyntax1Click(Sender: TObject);
    procedure ComponentCount1Click(Sender: TObject);
    procedure NewInstance1Click(Sender: TObject);
    procedure toolbtnTutorialClick(Sender: TObject);
    procedure Memory1Click(Sender: TObject);
    procedure JavaSyntax1Click(Sender: TObject);
    procedure SyntaxCheck1Click(Sender: TObject);
    procedure Tutorial10Statistics1Click(Sender: TObject);
    procedure ScriptExplorer1Click(Sender: TObject);
    procedure FormOutput1Click(Sender: TObject);
    procedure ArduinoDump1Click(Sender: TObject);
    procedure AndroidDump1Click(Sender: TObject);
    procedure GotoEnd1Click(Sender: TObject);
    procedure AllResourceList1Click(Sender: TObject);
    procedure tbtn6resClick(Sender: TObject);
    procedure Tutorial11Forms1Click(Sender: TObject);
    procedure Tutorial12SQL1Click(Sender: TObject);
    procedure ResourceExplore1Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure CryptoBox1Click(Sender: TObject);
    procedure Tutorial13Ciphering1Click(Sender: TObject);
    procedure ModulesCount1Click(Sender: TObject);
    procedure N4GewinntGame1Click(Sender: TObject);
    procedure DocuforAddOns1Click(Sender: TObject);
    procedure Tutorial14Async1Click(Sender: TObject);
    procedure Lessons15Review1Click(Sender: TObject);
    procedure PHPSyntax1Click(Sender: TObject);
    procedure SerialRS2321Click(Sender: TObject);
    procedure CSyntax2Click(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure Tutorial151Click(Sender: TObject);
    procedure BtnZoomPlusClick(Sender: TObject);
    procedure BtnZoomMinusClick(Sender: TObject);
    procedure btnClassReportClick(Sender: TObject);
    procedure CB1SCListChange(Sender: TObject);
    procedure ThreadDemo1Click(Sender: TObject);
    procedure HEXView1Click(Sender: TObject);
    procedure ExporttoHTML1Click(Sender: TObject);
    procedure HEXEditor2Click(Sender: TObject);
    procedure Minesweeper1Click(Sender: TObject);
    procedure PicturePuzzle1Click(Sender: TObject);
    procedure sbvclhelpClick(Sender: TObject);
    procedure DependencyWalker1Click(Sender: TObject);
    procedure CB1SCListDrawItem(Control: TWinControl; Index: Integer; aRect: TRect;
      State: TOwnerDrawState);
    procedure WebScanner1Click(Sender: TObject);
    procedure mnToolbar1Click(Sender: TObject);
    procedure mnStatusbar2Click(Sender: TObject);
    procedure mnConsole2Click(Sender: TObject);
    procedure mnCoolbar2Click(Sender: TObject);
    procedure mnSplitter2Click(Sender: TObject);
    procedure WebServer1Click(Sender: TObject);
    procedure Tutorial17Server1Click(Sender: TObject);
    procedure Tutorial18Arduino1Click(Sender: TObject);
    procedure PerlSyntax1Click(Sender: TObject);
    procedure PythonSyntax1Click(Sender: TObject);
    procedure DMathLibrary1Click(Sender: TObject);
    procedure IntfNavigator1Click(Sender: TObject);
    procedure EnlargeFontConsole1Click(Sender: TObject);
    procedure ShrinkFontConsole1Click(Sender: TObject);
    procedure intfAdd1Click(Sender: TObject);
    procedure intfDelete1Click(Sender: TObject);
    procedure intfRefactor1Click(Sender: TObject);
    procedure Defactor1Click(Sender: TObject);
    procedure Tutorial19COMArduino1Click(Sender: TObject);
    procedure Tutorial20RegexClick(Sender: TObject);
    procedure ManualE1Click(Sender: TObject);
    procedure FullTextFinder1Click(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure FractalDemo1Click(Sender: TObject);
    procedure Tutorial21Android1Click(Sender: TObject);
    procedure Tutorial0Function1Click(Sender: TObject);
    procedure SimuLogBox1Click(Sender: TObject);
    procedure OpenExamples1Click(Sender: TObject);
    procedure JavaScriptSyntax1Click(Sender: TObject);
    procedure Halt1Click(Sender: TObject);
    procedure CodeSearch1Click(Sender: TObject);
    procedure RubySyntax1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure LinuxShellScript1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure SynEditPrint1PrintLine(Sender: TObject; LineNumber, PageNumber: Integer);
    procedure Preview1Click(Sender: TObject);
    procedure SynEditPrint1PrintStatus(Sender: TObject; Status: TSynPrintStatus;
      PageNumber: Integer; var Abort: Boolean);
    procedure Tutorial22Services1Click(Sender: TObject);
    procedure Tutorial23RealTime1Click(Sender: TObject);
    procedure Configuration1Click(Sender: TObject);
    procedure MP3Player1Click(Sender: TObject);
    procedure DLLSpy1Click(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure URILinksClicks1Click(Sender: TObject);
    procedure EditReplace1Click(Sender: TObject);
    procedure GotoLine1Click(Sender: TObject);
    procedure ActiveLineColor1Click(Sender: TObject);
    procedure ConfigFile1Click(Sender: TObject);
    procedure Sort1IntflistClick(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure Tutorial24CleanCode1Click(Sender: TObject);
    procedure IndentSelection1Click(Sender: TObject);
    procedure UnindentSection1Click(Sender: TObject);
    procedure SkyStyle1Click(Sender: TObject);
    procedure CountWords1Click(Sender: TObject);
    procedure Memo1PlaceBookmark(Sender: TObject; var Mark: TSynEditMark);
    procedure Memo1GutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer;
      Mark: TSynEditMark);
    procedure Bookmark11Click(Sender: TObject);
    procedure Bookmark21Click(Sender: TObject);
    procedure Bookmark31Click(Sender: TObject);
    procedure Bookmark41Click(Sender: TObject);
    procedure SynMultiSyn1CustomRange(Sender: TSynMultiSyn; Operation: TRangeOperation;
      var Range: Pointer);
    procedure ScriptListbox1Click(Sender: TObject);
    procedure Memo2KeyPress(Sender: TObject; var Key: Char);
    procedure Bookmark51Click(Sender: TObject);
    procedure EnlargeGutter1Click(Sender: TObject);
    procedure Tetris1Click(Sender: TObject);
    procedure ToDoList1Click(Sender: TObject);
    procedure ProcessList1Click(Sender: TObject);
    procedure MetricReport1Click(Sender: TObject);
    procedure InternetRadio1Click(Sender: TObject);
    procedure TCPSockets1Click(Sender: TObject);
    procedure ConfigUpdate1Click(Sender: TObject);
    procedure ShowIndent1Click(Sender: TObject);
    //procedure Memo1DropFiles(Sender: TObject; X,Y: Integer; AFiles: TStrings);
  private
    STATSavebefore: boolean;
    STATShowBytecode: boolean;
    STATInclude: boolean;
    STATEdchanged: boolean;
    STATExceptionLog: boolean;
    STATWriteFirst: boolean;
    STATExecuteBoot: boolean;
    STATLastfile: boolean;
    STATMacro: boolean;
    STATExecuteShell: Boolean;  //bugfix back from
    STATActiveyellow: Boolean;
    STATVersionCheck: boolean;
    STATOtherHL: boolean;
    STATCodefolding: boolean;      //new4
    Act_Filename: string[255];
    Def_FName: string[255];
    Last_fName: string[255];
    Last_fName1: string[255];
    Last_fName2: string[255];
    Last_fName3: string[255];
    Last_fName4: string[255];
    Last_fName5: string[255];
    Last_fName6: string[255];
    Last_fName7: string[255];
    Last_fName8: string[255];
   // IPHost: string[255];
   // IPPort: integer;
   // COMPort: integer;
    last_fontsize: byte;
    fileextension: string[12];
    fPrintOut: TSynEditPrint;
    fAutoComplete: TSynAutoComplete;
    fActiveLine: Longint;
    fResume: Boolean;
    fdebuginst: boolean;
    debugoutform: TDebugoutput; //static;
    //FOrgListViewWndProc: TWndMethod;
    STATformOutput: Boolean;
  //  lbintflist: TListBox;
    tmpcodestr: string;
    fmemoclick: boolean;
    perftime: string;
    lbintflistwidth: integer;
    Mark: TSynEditMark;
    bookmarkimage: byte;
    factivelinecolor: TColor;
    fkeypressed: boolean;
    //procedure ListViewWndProc(var Msg: TMessage); //message WM_DROP;
    function CompileDebug: Boolean;
    function ExecuteDebug: Boolean;
    function RunCompiledScript(bytecode: string; out RTErrors: string): boolean;
    procedure showandSaveBCode(const bdata: string);
    procedure lineToNumber(met: boolean);
    procedure defFileread;
    procedure SaveFileOptionsToIni(const filen: string);
    procedure LoadFileNameFromIni;
    function GetClientTop: integer;
    function UpdateFindtext: string;
    procedure FindNextText(Sender: TObject);
    procedure ReplaceNextText(Sender: TObject);
    procedure WMDROP_THEFILES(var message: TWMDROPFILES); message WM_DROPFILES;
    procedure ShowInterfaces(myFile: string);
    procedure AppOnException(sender: TObject; E: Exception);
    procedure LoadBootScript;
    procedure LoadInterfaceList;
    procedure ClickinListbox(sender: TObject);
    procedure Expand_Macro;
    procedure FormMarkup(Sender: TObject);
    function getCodeEnd: integer;
    procedure GetWidth(sender: TObject);
    procedure GetIntflistWidth(sender: TObject);
    procedure ShowWords(mystring: string);
    function ParseMacros(Str: String): String;
    procedure SetInterfacesMarks(myFile: string);   //outdate
    procedure SetInterfacesMarks2(myFile: string);
    procedure SetInterfacesMarksMemo3;
    procedure ClickinListbox2(sender: TObject);
    procedure defFilereadUpdate;
    function RunCompiledScript2(Bytecode: AnsiString;
      out RuntimeErrors: AnsiString): Boolean;

   //procedure DoEditorExecuteCommand(EditorCommand: word);
  //  procedure WebScannerDirect(urls: string);
  public
    STATMemoryReport: boolean;
    IPHost: string[255];
    IPPort: integer;
    COMPort: integer;
    lbintflist: TListBox;
    //procedure FindNextText(Sender: TObject);
    function GetStatChange: boolean;
    procedure SetStatChange(vstat: boolean);
    function GetActFileName: string;
    procedure SetActFileName(vname: string);
    function GetLastFileName: string;
    procedure SetLastFileName(vname: string);
    procedure WebScannerDirect(urls: string);
    procedure LoadInterfaceList2;
    function GetStatExecuteShell: boolean;
    procedure DoEditorExecuteCommand(EditorCommand: word);
    function GetActiveLineColor: TColor;
    procedure SetActiveLineColor(acolor: TColor);
    //function keypressed2: boolean;
   //procedure defFilereadUpdate;

 end;


var
  maxForm1: TMaxForm1;

implementation

{$R *.dfm}

uses
  uPSR_std,
  uPSC_std,
  uPSR_stdctrls,
  uPSC_stdctrls,
  uPSC_classes,
  uPSR_classes,
  uPSR_forms,
  uPSC_forms,
  uPSI_Types, //3.5+3.6  dword-longword
  uPSC_graphics,
  uPSC_controls,
  //uPSC_classes,
  //uPSR_classes,
  uPSR_graphics,
  uPSR_controls,
  uPSR_extctrls,
  uPSC_extctrls,
  uPSC_dateutils,
  uPSR_dateutils,
  uPSC_menus,
  uPSR_menus,
  uPSC_buttons,
  uPSR_buttons,
  uPSI_mathmax,
  infobox1,
  uPSI_WideStrUtils, //3.7
  uPSI_WideStrings, //3.2
  uPSI_DateUtils,  //3.2
  uPSR_Grids,
  uPSC_Grids,
  uPSR_comobj,
  uPSC_comobj,
  uPSI_Dialogs,  //remove 3.9.6.1
  //IFSI_Tetris1,
  IFSI_WinForm1puzzle,
  bossUnit1,
   Windows,
  //dlgSearchText,
  SynEditTypes,
  ConfirmReplDlg,
    FindReplDlg,     //new line!!!
  ShellAPI,
  uPSI_ShellAPI,   //3.9.6.3
  uPSI_cFileUtils,
  uPSI_cDateTime,
  uPSI_cTimers,
  uPSI_cRandom,
  uPSI_ueval,
  SynEditKeyCmds,
  uPSI_SynEditKeyCmds,   //3.9.9
  uPSI_SynEditMiscProcs,
  uPSI_JvZoom,
  uPSI_PMrand,
  uPSI_JvSticker,
  //ide_debugoutput,
  //ToolWin; Types, Grids
  UCMainForm,
   JimShape,
  RXMain, //3.6.3
  EXEImage,
  DependencyWalkerDemoMainForm,
  WebMapperDemoMainForm,
  sdpStopwatch,
  uPSI_JclStatistics,
  uPSI_JclMiscel,
  uPSI_JclLogic,
  uPSI_uTPLb_StreamUtils,  //LockBox3
  uPSI_uTPLb_AES,
  uPSI_uTPLb_SHA2,
  uPSI_AESPassWordDlg,
  uPSI_MathUtils,
  uPSI_JclMultimedia,
  uPSI_FMTBcd,
  uPSI_TypeTrans,
  uPSI_DBCommonTypes,
  uPSI_DBCommon,  //3.1
  uPSI_DBPlatform, //3.6
  uPSC_DB,
  uPSR_DB,
  uPSI_DBTables,
  uPSI_DBLogDlg, //3.9
  uPSI_SqlTimSt,
  //uPSI_Types, //3.5
  uPSI_Printers, //3.1
  uPSI_SqlExpr, //3.2
  uPSI_ADODB,
  uPSI_DBGrids,  //3.5.1
  uPSI_DBCtrls,
  uPSI_DBCGrids,
  uPSI_Provider,
  uPSI_ImgList,
  uPSI_Clipbrd,
  uPSI_MPlayer,
  uPSI_StrUtils,
  uPSI_StrHlpr, //3.2
  uPSI_FileUtils, //3.2
  IFSI_gsUtils, //3.2
  uPSI_JclBase,  //3.8.6!
  uPSI_JvgCommClasses,
  uPSI_JvgUtils,
  uPSI_JvFunctions,
  uPSI_JvVCLUtils, //3.8.2
  uPSI_JvUtils, //3.8.6!
  uPSI_JvJCLUtils, //3.9!
  uPSI_JvDBUtil,
  uPSI_JvDBUtils,
  uPSI_JvAppUtils,
  uPSI_JvParsing,  //maXcalc
  uPSI_JvFormToHtml,
  uPSI_JvCtrlUtils,
  uPSI_JvBdeUtils,
  uPSI_JvDateUtil, //3.8.6
  uPSI_JvGenetic,
  uPSI_JvStrUtil,
  uPSI_JvStrUtils,
  uPSI_JvFileUtil,
  uPSI_JvMemoryInfos,
  uPSI_JvComputerInfo,
  uPSI_JvCalc,
  uPSI_JvComponent,
  uPSI_JvLED,
  uPSI_JvgLogics,
  uPSI_JvTurtle,
  uPSI_SortThds,
  uPSI_ThSort,
  uPSI_JvExprParser,
  uPSI_HexDump,
  uPSI_JvHtmlParser,
  uPSI_JvgXMLSerializer,
  uPSI_JvStrings,
  uPSI_uTPLb_IntegerUtils,
  uPSI_uTPLb_HugeCardinal,
  uPSI_uTPLb_HugeCardinalUtils,
  uPSI_SynRegExpr,    //RegExprStudio!
  uPSI_SynURIOpener,
  uPSI_StBase,
  uPSI_StUtils,   //SysTools4 -3.9.1
  uPSI_IMouse,
  uPSI_SyncObjs,
  uPSI_AsyncCalls,
  uPSI_ParallelJobs,
  uPSI_Variants,
  uPSI_VarCmplx,
  uPSI_DTDSchema,
  uPSI_ShLwApi,
  uPSI_IBUtils,    //3.9.2.2 fin
  uPSI_CheckLst,
  uPSI_JclSimpleXml,
  uPSI_JvSimpleXml,
  uPSI_JvXmlDatabase,
  uPSI_StGenLog,
  uPSI_JvComCtrls,
  uPSI_JvLogFile,
  uPSI_JvGraph,
  uPSI_JvCtrls,
  uPSI_CPort,
  uPSI_CPortCtl,
  uPSI_CPortEsc, //3.9.3
  uPSI_StSystem,
  uPSI_JvKeyboardStates,
  uPSI_JvMail,
  uPSI_JclConsole,
  //uPSI_JclLANMan,
  uPSI_BarCodeScaner,
  uPSI_GUITesting,
  uPSI_JvFindFiles,
  uPSI_StToHTML,
  uPSI_StStrms,
  uPSI_StFIN,
  uPSI_StAstro,
  uPSI_StDate,
  uPSI_StDateSt,
  uPSI_StVInfo,
  uPSI_JvBrowseFolder,
  uPSI_JvBoxProcs,
  uPSI_urandom,
  uPSI_usimann,
  uPSI_JvHighlighter,
  uPSI_Diff,
  //uPSI_cJSON,
  uPSI_StBits,
  uPSI_StAstroP,
  uPSI_StStat,
  uPSI_StNetCon,
  uPSI_StDecMth,
  uPSI_StOStr,
  uPSI_StPtrns,
  uPSI_StNetMsg,
  uPSI_StMath,
  uPSI_StExport,
  uPSI_StExpLog,
  uPSI_StFirst,
  uPSI_StSort,
  uPSI_ActnList,
  uPSI_jpeg,
  uPSI_StRandom,
  uPSI_StDict,
  uPSI_StBCD,
  uPSI_StTxtDat,
  uPSI_StRegEx,
  JvFunctions_max, //screenshot
  uPSI_Serial,  //3.8.4
  uPSI_SerDlgs,
  memorymax3,      //add on games
  gewinntmax3,
  IdGlobal_max,   //3.7 for file information
  StrUtils,        // dupestring
  uPSI_FileCtrl,    //3.5.1
  uPSI_Outline,
  uPSI_ScktComp,
  uPSI_Calendar,
  uPSI_ComCtrls, //3.6 ttreeview!
  uPSI_VarHlpr, //uPSI_Dialogs,  rmoved
  uPSI_ExtDlgs,
  uPSI_ValEdit,
  VListView,
  uPSI_utypes,     //for dmath.dll TFunc
  uPSI_FlatSB,
  uPSI_uwinplot,
  uPSI_umath,
  uPSI_ugamma,
  uPSI_LongIntList,
  uPSI_xrtl_util_CPUUtils,
  uPSI_xrtl_net_URI,
  uPSI_xrtl_net_URIUtils,
  uPSI_xrtl_util_StrUtils,
  uPSI_xrtl_util_COMCat,
  uPSI_xrtl_util_VariantUtils,
  uPSI_xrtl_util_FileUtils,
  //xrtl_util_Compat,
  uPSI_xrtl_util_Compat,
  uPSI_OleAuto,
  uPSI_xrtl_util_COMUtils,
  uPSI_CmAdmCtl,
  //uPSI_ValEdit,
  uPSI_GR32,
  uPSI_GR32_Image,
  uPSI_GR32_System,
  uPSI_CPortMonitor,
  uPSI_StIniStm,
  uPSI_GR32_ExtImage,      //3.9.7
  uPSI_GR32_OrdinalMaps,
  uPSI_GR32_Rasterizers,
  uPSI_xrtl_util_Exception,
  uPSI_xrtl_util_Compare,
  uPSI_xrtl_util_Value,
  uPSI_JvDirectories,  //a
  uPSI_JclSchedule,
  //uPSI_JvDBUltimGrid,
  uPSI_JclSvcCtrl,
  uPSI_JvSoundControl,
  uPSI_JvBDESQLScript,
  //uPSI_JvgDigits,
  uPSI_JclMIDI,
  uPSI_JclWinMidi,
  uPSI_JclNTFS,
  uPSI_JclAppInst,
  uPSI_JvRle,
  // uPSI_JvRas32,
  uPSI_JvImageDrawThread,
  uPSI_JvImageWindow,
  uPSI_JvTransparentForm,
  uPSI_JvWinDialogs,
  uPSI_JvSimLogic,
  uPSI_JvSimIndicator,
  uPSI_JvSimPID,
  uPSI_JvSimPIDLinker,
  uPSI_JclPeImage,      //anti virus routines
  uPSI_JclPrint,
  uPSI_JclMime,
  uPSI_JvRichEdit,
  uPSI_JvDBRichEd,
  uPSI_JvDice,
  uPSI_JvFloatEdit,    //3.9.8
  uPSI_JvDirFrm,
  uPSI_JvDualListForm,
  uPSI_JvTransLED,
  uPSI_JvPlaylist,
  uPSI_JvFormAutoSize,
  uPSI_JvDualList,
  uPSI_JvSwitch,
  uPSI_JvTimerLst,
  uPSI_JvMemTable,
  uPSI_JvObjStr,
  uPSI_xrtl_math_Integer,
  uPSI_JvPicClip,
  uPSI_JvImagPrvw,
  uPSI_JvFormPatch,
  uPSI_JvDataConv,
  uPSI_JvCpuUsage,
  uPSI_JvCpuUsage2,
  uPSI_JvParserForm,
  uPSI_JvJanTreeView,
  uPSI_JvYearGridEditForm,
  uPSI_JvMarkupCommon,
  uPSI_JvChart,
  uPSI_JvXPCore,  //add res files!
  uPSI_JvXPCoreUtils,
  uPSI_JvSearchFiles,
  //uPSI_JvSpeedbarSetupForm,   //3.9.8 fin
  uPSI_ExcelExport,
  uPSI_JvDBGridExport,
  //uPSI_JvgExport,
  uPSI_JvSerialMaker,
  uPSI_JvWin32,
  uPSI_JvPaintFX,
  //uPSI_JvValidators,
  //uPSI_JvOracleDataSet,
  uPSI_JvNTEventLog,    //3.9.8.6
  uPSI_ShellZipTool,
  ShellZipTool, //numprocessthreads
  uPSI_JvJoystick,
  uPSI_JvMailSlots,
  uPSI_JclComplex,
  uPSI_SynPdf,          //3.9.8.8
  uPSI_Registry,
  uPSI_TlHelp32,
  uPSI_JclRegistry,
  //uPSI_mORMotReport,
  uPSI_JvAirBrush,
  uPSI_JclLocales,      //last
  uPSI_XmlVerySimple,
  uPSI_Services,
  uPSI_JvForth,
  uPSI_RestRequest,
  //HttpRESTConnectionIndy,
  uPSI_HttpRESTConnectionIndy,
  //uPSI_JvXmlDatabase,
  uPSI_WinAPI,
  uPSI_HyperLabel,
  uPSI_MultilangTranslator,
  uPSI_TomDBQue,
  uPSI_Starter,
  uPSI_FileAssocs,
  uPSI_devFileMonitorX,
  uPSI_devrun,
  uPSI_devExec,
  ProcessListFrm,
  uPSI_oysUtils,
  tetris1,
  uPSI_DosCommand,
  ViewToDoFm,  //3.9.9.6
  uPSI_CppTokenizer,
  //uPSI_JvHLParser,
  uPSI_JclMapi,
  uPSI_JclShell, //3.9.9.6
  uPSI_JclCOM,
  uPSI_GR32_Math,
  uPSI_GR32_LowLevel,
  uPSI_SimpleHl,
  uPSI_GR32_Filters,
  uPSI_GR32_VectorMaps,
  uPSI_cXMLFunctions,
  uPSI_JvTimer,
  uPSI_cHTTPUtils,
  uPSI_cTLSUtils,     //3.9.9.7
  uPSI_JclGraphics,
  uPSI_JclSynch,
  uPSI_IdEcho,
  uPSI_IdEchoServer,
  uPSI_IdEchoUDP,
  uPSI_IdEchoUDPServer,
  //uPSI_IdDsnRegister,
  //uPSI_IdStack,
  uPSI_IdSocks,
  uPSI_IdTelnetServer,
  uPSI_IdAntiFreezeBase,
  uPSI_IdHostnameServer,
  //uPSI_IdTunnelCommon,
  //uPSI_IdTunnelMaster,
  //uPSI_IdTunnelSlave,
  uPSI_IdRSH,
  uPSI_IdRSHServer,
  uPSI_Spring_Cryptography_Utils,
  //uPSI_MapReader,
  uPSI_LibTar,
  uPSI_IdChargenServer,
  //uPSI_IdBlockCipherIntercept,  //3.9.9.8
  uPSI_IdFTPServer,
  //uPSI_IdException,
  uPSI_uwinstr,
  uPSI_utexplot,
  //uPSI_VarRecUtils,
  //uPSI_JvStringListToHtml,
  uPSI_JvStringHolder,
  uPSI_IdCoder,
  //uPSI_LazFileUtils,
  //uPSI_IDECmdLine,
  uPSI_ip_misc,
  uPSI_Barcode,
  uPSI_SimpleXML,

  uPSI_ExtPascalUtils,
  uPSI_SocketsDelphi,
  uPSI_StBarC,
  uPSI_StDbBarC,
  uPSI_StBarPN,
  uPSI_StDbPNBC,
  uPSI_StDb2DBC,
  //uPSI_StMoney,
  uPSI_SynEditTypes,
  uPSI_SynEditMiscClasses,
  uPSI_SynEditHighlighter,
  uPSI_SynHighlighterPas,
  uPSI_SynEdit,
  uPSI_SynEditRegexSearch,
  uPSI_SynMacroRecorder,
  uPSI_SynHighlighterAny,
  SynHighlighterAny,
  uPSI_SynEditKbdHandler,
  uPSI_SynEditSearch,
  uPSI_SynEditExport,
  uPSI_SynExportHTML,
  uPSI_SynExportRTF,     //3.9.9
  //uPSI_SynHighlighterDfm,
  uPSI_lazMasks,

  uPSI_Hashes,

  uPSI_JvAppInst,
  uPSI_JvAppEvent,
  uPSI_JvAppCommand,
  uPSI_JvAnimTitle,
  uPSI_JvAnimatedImage,
  Unit1dll,
  uPSI_SynMemo,
  uPSI_IdMIMETypes,
  uPSI_JvConverter, //also in JvDataConv
  uPSI_JvCsvParse,
  uPSI_StatsClasses,
  uPSI_ExtCtrls2,
  uPSI_JvUrlGrabbers,
  uPSI_JvXmlTree,
  uPSI_JvWavePlayer,
  uPSI_JvUnicodeCanvas,
  uPSI_JvTFUtils,
  uPSI_StLArr,
  uPSI_StWmDCpy,
  uPSI_StText,
  uPSI_StNTLog,
  uPSI_JclUnitConv_mX2,
  uPSI_xrtl_util_TimeUtils,
  uPSI_xrtl_util_TimeZone,
  uPSI_xrtl_util_TimeStamp,
  uPSI_xrtl_util_Map,
  uPSI_xrtl_util_Set,
  uPSI_VListView,
  uPSI_IdServerIOHandler,
  uPSI_IdServerIOHandlerSocket,
  uPSI_IdMessageCoder,
  uPSI_IdMessageCoderMIME,
  uPSI_IdMultipartFormData, //cause of http post;
  uPSI_IdGlobal,
  uPSI_IdIOHandlerSocket,  //3.9.3
  uPSI_IdTCPConnection, //3.1
  IFSI_IdTCPClient,
  uPSI_IdHeaderList,     //3.9.6
  uPSI_IdHTTPHeaderInfo,
  IFSI_IdHTTP,
  uPSI_HTTPParse, //3.2
  uPSI_HTTPUtil, //3.2
  uPSI_HTTPApp, //3.7
  uPSI_IdSocketHandle,
  uPSI_IdTCPServer,
  uPSI_IdCustomHTTPServer,
  IFSI_IdURI,
  IFSI_IdFTP,
  uPSI_IdRemoteCMDClient,
  uPSI_IdRemoteCMDServer,
  uPSI_IdRexec,
  uPSI_IdUDPServer,
  uPSI_IdIPWatch,
  uPSI_IdMessageCollection,
  uPSI_IdIrcServer,
  uPSI_cPEM,             //3.9.6
  uPSI_xmlutil, //3.2  XML
  uPSI_MaskUtils, //3.5
  uPSI_cutils,
  uPSI_BoldUtils,
  uPSI_IdSimpleServer,
  //uPSI_OpenSSLUtils,
  uPSI_IdSSLOpenSSL,     //3.9.4
  uPSI_PerlRegEx,     //3.9.6
  uPSI_Masks,
  uPSI_Contnrs,
  uPSI_MyBigInt,
  uPSI_SOAPHTTPClient,
  uPSI_VCLScannerIntf,
  uPSI_VCLScannerImpl,
  uPSI_StdConvs,
  uPSI_ConvUtils,
  uPSI_DBClient,
  uPSI_CDSUtil,
  uPSI_GraphUtil, //3.7
  uPSI_devcutils,
  uPSI_DBWeb,
  uPSI_DBXpressWeb,
  uPSI_DBBdeWeb,
  uPSI_ShadowWnd, //3.8
  uPSI_ToolWin,
  uPSI_Tabs,
  uPSI_JclGraphUtils,
  uPSI_JclCounter,
  uPSI_JclSysInfo,
  uPSI_JclSecurity,
  uPSI_IdUserAccounts,
  uPSI_JclFileUtils,
  uPSI_JvAnalogClock,    //3.9.7
  uPSI_JvAlarms,
  uPSI_JvSQLS,
  uPSI_JvDBSecur,
  uPSI_JvDBQBE,
  uPSI_JvStarfield,
  //uPSI_JVCLMiscal,
  uPSI_JvProfiler32,
  uPSI_IdAuthentication,
  uPSI_IdRFCReply,        //3.9.75
  uPSI_IdIdentServer,
  uPSI_IdIdent,
  //uPSI_StNetCon,
  uPSI_StNet,
  uPSI_StNetPfm,
  uPSI_JvPatchFile,
  //uPSI_SynMemo,
  uPSI_IdASN1Util,
  uPSI_IdHashCRC,
   uPSI_IdHash,
  uPSI_IdHashMessageDigest, //3.5
  uPSI_IdHashSHA1,
  uPSI_IdLogFile,
  uPSI_IdTime,
  uPSI_IdDayTime,
  uPSI_IdEMailAddress,
  uPSI_IdMessage,
  uPSI_IdMessageClient,
  uPSI_IdSMTP,
  uPSI_IdPOP3,
  uPSI_IdMailBox,
  uPSI_IdQotd,
  uPSI_IdTelnet,
  uPSI_IdNetworkCalculator,
  uPSI_IdFinger,
  uPSI_IdIcmpClient,
  uPSI_IdUDPBase,
  uPSI_IdUDPClient,
  uPSI_IdTrivialFTPBase,
  uPSI_IdTrivialFTP,
  uPSI_LinarBitmap,
  uPSI_PNGLoader,
  WinForm1,
  CRC32,   //3.5
 // SynEditMarkupHighAll,  //3.9.8.9 beta
  uPSI_ufft,
  uPSI_DBXChannel,
  uPSI_DBXIndyChannel,
  VCLScannerIntf,
  SOAPHTTPClient, //Test for WS
  uPSI_interface2_so,
  uPSI_IniFiles,
  uPSI_IdThread,
  uPSI_fMain,   //Register Methods to Open Tools API
  uPSI_niSTRING,
  uPSI_niRegularExpression,
  uPSI_niExtendedRegularExpression, //3.1
  uPSI_IdSNTP,
  JclSysInfo,  //loadedmoduleslist
  IFSI_SysUtils_max,
  uPSI_cFundamentUtils;


resourcestring
  RCReplace = 'Replace this '#13'of "%s"'#13+'by "%s"?';
  RCSTRMB ='maXbox3 ';
  RCPRINTFONT ='Courier New';
  FILELOAD = ' File loaded';
  FILESAVE = ' File is saved';
  BEFOREFILE = ' last File set history';
  CLIFILELOAD = ' File from Commandline';
  RS_PS='http://pascalprogramming.byethost15.com/lessonindex.html';
  //RS_DS='http://www.delphi3000.com/';
  RS_DS='http://delphi.about.com/';
  //www.swissdelphicenter.ch/';
  SConfirmDelete = 'Confirm delete';
  SConfirmClear  = 'Confirm clear';
  SDelSelItemsPrompt = 'Delete selected items?';


const
  DefSynEditOptions = [eoAltSetsColumnMode, eoAutoIndent, eoDragDropEditing,
   eoGroupUndo, eoShowScrollHint, eoScrollPastEol, eoSmartTabs,
  eoTabsToSpaces, eoSmartTabDelete];

var
  srec: TSearchRec;
  f: TextFile;
  fx: Text;


procedure TMaxForm1.IFPS3ClassesPlugin1CompImport(Sender: TObject;
  x: TIFPSPascalcompiler);
begin
  SIRegister_Std(x);
  SIRegister_Classes(x, true);
 // SIRegister_Types(X);       //3.5+3.6
  SIRegister_Graphics(x, true);     //canvas
  SIRegister_Controls(x);
  SIRegister_stdctrls(x);
  SIRegister_extctrls(x);
  SIRegister_Types(X);       //3.5+3.6
  //SIRegister_Menus(X); //from up to 3.9.7 cause of form
  SIRegister_Forms(x);
  SIRegister_TwinFormp(x);
  SIRegister_TMyLabel(x);
  SIRegister_WinForm1(x);
  RegisterDateTimeLibrary_C(x);
  //SIRegister_Types(X);       //3.5
  //SIRegister_Graphics(x, true);
  SIRegister_StrUtils(X);
  SIRegister_SysUtils(X);   //3.2    also unit down
  SIRegister_EInvalidArgument(x);
  SIRegister_MathMax(x);
  SIRegister_WideStrUtils(X);
  SIRegister_WideStrings(X);
  SIRegister_StrHlpr(X);
  SIRegister_DB(x);
  SIRegister_DBCommonTypes(X);
  SIRegister_DBCommon(X);
  SIRegister_DBTables(X);
  SIRegister_DBPlatform(X);
  SIRegister_DBLogDlg(X);  //3.9
  SIRegister_DateUtils(X); //3.2
  SIRegister_FileUtils(X);
  SIRegister_SqlTimSt(X);
  SIRegister_gsUtils(X);
  SIRegister_JvFunctions(X);
  SIRegister_Grids(X);
  SIRegister_Menus(X); //3.1  up
  SIRegister_ComObj(X);
  SIRegister_Printers(X);
  SIRegister_Dialogs(X); //remove 3.9.6.1
  SIRegister_MPlayer(X);
  SIRegister_ImgList(X);
  SIRegister_Buttons(X);
  SIRegister_Clipbrd(X);
  SIRegister_SqlExpr(X);
  SIRegister_ADODB(X);
  SIRegister_DBGrids(X);
  SIRegister_DBCtrls(X);
  SIRegister_DBCGrids(X); //3.6
  SIRegister_IniFiles(X);    //remove 3.8.4
  SIRegister_JclBase(X);
  SIRegister_JvgCommClasses(X);
  SIRegister_JvgUtils(X);    //with JvGTypes
  SIRegister_JclStatistics(X);
  SIRegister_JclMiscel(X);
  SIRegister_JclLogic(X);
  SIRegister_JvVCLUtils(X);  //3.8
  SIRegister_JvUtils(X);
  //SIRegister_JvJCLUtils(X); //3.9
  SIRegister_JvAppUtils(X);
  SIRegister_JvDBUtil(X);
  SIRegister_JvDBUtils(X);
  SIRegister_JvParsing(X);
  SIRegister_JvFormToHtml(X);
  SIRegister_JvCtrlUtils(X);
  SIRegister_JvComponent(X);
  SIRegister_JvBdeUtils(X);
  SIRegister_JvDateUtil(X);
  SIRegister_JvGenetic(X);
  SIRegister_JvStrUtil(X);
  SIRegister_JvStrUtils(X);
  SIRegister_JvFileUtil(X);
  SIRegister_JvCalc(X);
  SIRegister_JvJCLUtils(X); //3.9
  SIRegister_JvMemoryInfos(X);
  SIRegister_JvComputerInfo(X);
  SIRegister_Serial(X);
  SIRegister_SerDlgs(X);
  SIRegister_JvLED(X);
  SIRegister_JvgLogics(X);
  SIRegister_JvTurtle(X);
  SIRegister_JvHtmlParser(X);
  SIRegister_JvgXMLSerializer(X);
  SIRegister_JvStrings(X);
  SIRegister_uTPLb_IntegerUtils(X);
  SIRegister_uTPLb_HugeCardinal(X);
  SIRegister_uTPLb_HugeCardinalUtils(X);
  SIRegister_LongIntList(X);
  SIRegister_SortThds(X);
  SIRegister_ThSort(X);
  SIRegister_JvExprParser(X);
  SIRegister_SynRegExpr(X);
  SIRegister_SynURIOpener(X);
  SIRegister_StUtils(X);  //SysTools4
  SIRegister_IMouse(X);
  SIRegister_SyncObjs(X);
  SIRegister_AsyncCalls(X);
  SIRegister_ParallelJobs(X);
  SIRegister_Variants(X);
  SIRegister_VarCmplx(X);
  SIRegister_DTDSchema(X);
  SIRegister_ShLwApi(X);
  SIRegister_IBUtils(X); //3.9.2.2 fin -3.9.3
  SIRegister_JvGraph(X);
  SIRegister_Registry(X);
  SIRegister_TlHelp32(X);
  SIRegister_JclRegistry(X);
  //SIRegister_TJvGradient(X);
  SIRegister_JvLogFile(X);
  SIRegister_JvComCtrls(X);
  SIRegister_JvCtrls(X);
  SIRegister_CPort(X);
  SIRegister_CPortEsc(X);   //3.9.3
  SIRegister_CPortCtl(X);
  SIRegister_CPortMonitor(X);
  SIRegister_cutils(X);  //3.9.4
  SIRegister_PerlRegEx(X);
  SIRegister_BoldUtils(X);
  SIRegister_IdSimpleServer(X);
  SIRegister_BarCodeScaner(X);
  SIRegister_GUITesting(X);
  SIRegister_JvFindFiles(X);
  SIRegister_JclSimpleXml(X);
  SIRegister_CheckLst(X);
  SIRegister_ComCtrls(X); //3.9 moved up
  SIRegister_StBase(X);
  SIRegister_ExtPascalUtils(X);
  SIRegister_JvSimpleXml(X);     //domtotree
  SIRegister_JvXmlDatabase(X);
  SIRegister_StFirst(X);
  SIRegister_StToHTML(X);
  SIRegister_StStrms(X);
  SIRegister_StFIN(X);
  SIRegister_StDate(X);
  SIRegister_StDateSt(X);
  SIRegister_StAstroP(X);
  SIRegister_StStat(X);
  SIRegister_StNetCon(X);
  SIRegister_StDecMth(X);
  SIRegister_StOStr(X);
  SIRegister_StPtrns(X);
  SIRegister_StNetMsg(X);
  SIRegister_StMath(X);
  SIRegister_StExpLog(X);
  SIRegister_StExport(X);
  SIRegister_StGenLog(X);
  SIRegister_StSystem(X);
  SIRegister_StIniStm(X);
  SIRegister_StBarC(X);
  SIRegister_StDbBarC(X);
  SIRegister_StBarPN(X);
  SIRegister_StDbPNBC(X);
  SIRegister_StDb2DBC(X);
  //SIRegister_StMoney(X);
  SIRegister_JvKeyboardStates(X);
  SIRegister_JclMapi(X);
  SIRegister_JvMail(X);
  SIRegister_JclConsole(X);
  //SIRegister_JclLANMan(X);
  SIRegister_ActnList(X);
  SIRegister_jpeg(X);
  SIRegister_StRandom(X);
  SIRegister_StDict(X);
  SIRegister_StBCD(X);
  SIRegister_StTxtDat(X);
  SIRegister_StRegEx(X);
  SIRegister_HexDump(X);
   SIRegister_uTPLb_StreamUtils(X);
  SIRegister_uTPLb_AES(X);
  SIRegister_uTPLb_SHA2(X);
  SIRegister_AESPassWordDlg(X);
  SIRegister_JclMultimedia(X);
  SIRegister_TTypeTranslatoR(X);
  SIRegister_IdMessageCoder(X);
  SIRegister_IdMessageCoderMIME(X);
  //SIRegister_IdServerIOHandler(X);
  //SIRegister_IdServerIOHandlerSocket(X);   change 3.9.9.8
  SIRegister_IdHeaderList(X);
  SIRegister_IdMultipartFormData(X);
  SIRegister_MathUtils(X);
  SIRegister_HTTPParse(X);
  SIRegister_HTTPUtil(X);
  SIRegister_utypes(X);  //for dmath.dll   and eval
  SIRegister_FlatSB(X);
  //SIRegister_EIdHTTPProtocolException(x);
  {SIRegister_TIdHTTP(x);
  SIRegister_TIdCustomHTTP(x);
  SIRegister_TIdHTTPProtocol(x);
  SIRegister_TIdHTTPRequest(x);
  SIRegister_TIdHTTPResponse(x);}
  //SIRegister_IdException(X);
  SIRegister_IdGlobal(X);     //remove 3.9.9.1
  SIRegister_IdRFCReply(X);   //3.9.7.5
  //SIRegister_IdStack(X);
  SIRegister_IdSocks(X);
  SIRegister_IdSocketHandle(X);
  SIRegister_IdIOHandlerSocket(X);
  SIRegister_IdServerIOHandler(X);
  SIRegister_IdServerIOHandlerSocket(X);
  SIRegister_IdCoder(X);
  SIRegister_IdTCPConnection(X);  //3.1
  SIRegister_IdTCPClient(X);
  SIRegister_IdHTTPHeaderInfo(X);
  SIRegister_IdHTTP(x);
  SIRegister_HTTPApp(X);
  //SIRegister_TIdURI(x);
  SIRegister_IdURI(x);
  //SIRegister_IdSocketHandle(X);
  SIRegister_IdTCPServer(X);
  SIRegister_IdFTP(X);
  SIRegister_IdCustomHTTPServer(X); //3.9.3
  SIRegister_IdSSLOpenSSL(X);
  SIRegister_xmlutil(X);    //3.2 XML
  SIRegister_MaskUtils(X); //3.5
  SIRegister_Masks(X);
  SIRegister_FileCtrl(X);
  SIRegister_Outline(X);
  SIRegister_ScktComp(X);
  SIRegister_Calendar(X);
  SIRegister_VListView(X);
  SIRegister_ide_debugoutput(X);
  //SIRegister_ComCtrls(X); //3.6  move upwards
  SIRegister_VarHlpr(X);    //variants
  SIRegister_StatsClasses(X);   //unit test
  //SIRegister_Dialogs(X);
  SIRegister_ExtDlgs(X);
  SIRegister_ValEdit(X);
  SIRegister_interface2_so(X);
  SIRegister_Contnrs(X);
  SIRegister_MyBigInt(X);
  SIRegister_StdConvs(X);
  SIRegister_ConvUtils(X);
  SIRegister_SOAPHTTPClient(X);
  SIRegister_VCLScannerIntf(X);
  SIRegister_VCLScannerImpl(X);
  SIRegister_FMTBcd(X);
  SIRegister_Provider(X);
  SIRegister_DBClient(X);  //3.6
  SIRegister_CDSUtil(X);
  SIRegister_GraphUtil(X);   //3.7
  SIRegister_DBWeb(X);
  SIRegister_DBXpressWeb(X);
  SIRegister_DBBdeWeb(X);
  SIRegister_ShadowWnd(X); //3.8
  SIRegister_ToolWin(x);
  SIRegister_devcutils(X);
  SIRegister_Tabs(X);
  SIRegister_JclGraphUtils(X);
  SIRegister_JclCounter(X);
  SIRegister_JclSysInfo(X);
  SIRegister_JclSecurity(X);
  SIRegister_IdUserAccounts(X);
  SIRegister_JclFileUtils(X);
  SIRegister_JvStarfield(X);   //3.9.7
  SIRegister_JvAnalogClock(X);
  SIRegister_JvAlarms(X);
  SIRegister_JvSQLS(X);
  SIRegister_JvDBSecur(X);
  SIRegister_JvDBQBE(X);
  SIRegister_JvProfiler32(X);
  SIRegister_JvDirectories(X);
  SIRegister_JclSvcCtrl(X);
  SIRegister_JclSchedule(X);
  SIRegister_JvSoundControl(X);
  SIRegister_JvBDESQLScript(X);
  SIRegister_IdAuthentication(X);
  SIRegister_JclNTFS(X);
  SIRegister_JclAppInst(X);
  SIRegister_JclMIDI(X);
  SIRegister_JclWinMidi(X);
  SIRegister_JvRle(X);
  SIRegister_JvImageWindow(X);
  SIRegister_JvImageDrawThread(X);  //3.9.7.3
  SIRegister_JvTransparentForm(X);
  SIRegister_JvWinDialogs(X);
  SIRegister_JclUnitConv_mX2(X);
  SIRegister_JvFloatEdit(X);  //3.9.8
  SIRegister_ShellZipTool(X);
  SIRegister_JvJoystick(X);
  SIRegister_JvMailSlots(X);
  SIRegister_JclComplex(X);
  SIRegister_SynPdf(X);
  SIRegister_JvAirBrush(X);
  //SIRegister_mORMotReport(X);
  SIRegister_ugamma(X);
  SIRegister_ExcelExport(X);
  SIRegister_JvDBGridExport(X);
  SIRegister_JvSerialMaker(X);
  SIRegister_JvWin32(X);
  SIRegister_JvPaintFX(X);
  SIRegister_JvNTEventLog(X);
  SIRegister_JvDirFrm(X);
  SIRegister_JvParserForm(X);
  SIRegister_JvDualListForm(X);
  SIRegister_JvDualList(X);
  SIRegister_JvSwitch(X);
  SIRegister_JvTimerLst(X);
  SIRegister_JvObjStr(X);
  SIRegister_JvMemTable(X);
  SIRegister_JvPicClip(X);
  SIRegister_JvImagPrvw(X);
  SIRegister_JvFormPatch(X);
  SIRegister_JvDataConv(X);
  SIRegister_JvCpuUsage(X);
  SIRegister_JvCpuUsage2(X);
  SIRegister_JvJanTreeView(X);
  SIRegister_JvYearGridEditForm(X);
  SIRegister_JvMarkupCommon(X);
  SIRegister_JvPlaylist(X);
  SIRegister_JvTransLED(X);
  SIRegister_JvFormAutoSize(X);
  SIRegister_JvChart(X);
  SIRegister_JvXPCore(X);
  SIRegister_JvXPCoreUtils(X);
  SIRegister_ExtCtrls2(X);
  SIRegister_JvUrlGrabbers(X);
  SIRegister_JvXmlTree(X);
  SIRegister_JvWavePlayer(X);
  SIRegister_JvUnicodeCanvas(X);
  SIRegister_JvTFUtils(X);
  SIRegister_IdMIMETypes(X);
  SIRegister_JvConverter(X);    //JVdataConv
  SIRegister_JvCsvParse(X);
  SIRegister_JclLocales(X);
  SIRegister_JvSearchFiles(X);
  SIRegister_xrtl_math_Integer(X);
  SIRegister_lazMasks(X);
  SIRegister_StLArr(X);
  SIRegister_StWmDCpy(X);
  SIRegister_StText(X);
  SIRegister_StNTLog(X);
  SIRegister_SynEditTypes(X);
  //  syn API int and ext
  SIRegister_SynEditKeyCmds(X);
  SIRegister_SynEditMiscClasses(X);
  SIRegister_SynEditHighlighter(X);
  SIRegister_SynHighlighterPas(X);
  SIRegister_SynEdit(X);
  SIRegister_SynEditRegexSearch(X);
  SIRegister_SynMacroRecorder(X);
  SIRegister_SynMemo(X);
  SIRegister_SynHighlighterAny(X);
  SIRegister_SynEditKbdHandler(X);
  SIRegister_SynEditMiscProcs(X);
  SIRegister_SynEditExport(X);
  SIRegister_SynExportRTF(X);
  SIRegister_SynExportHTML(X);
  SIRegister_SynEditSearch(X);  //3.9.9
  //SIRegister_SynHighlighterDfm(X);
  SIRegister_JvSticker(X);
  SIRegister_JvZoom(X);
  SIRegister_PMrand(X);
  SIRegister_StAstro(X);
  SIRegister_StSort(X);
  SIRegister_XmlVerySimple(X);
  SIRegister_StVInfo(X);
  SIRegister_JvBrowseFolder(X);
  SIRegister_JvBoxProcs(X);
  SIRegister_usimann(X);
  SIRegister_urandom(X);
  SIRegister_uranuvag(X);
  SIRegister_uqsort(X);
  SIRegister_ugenalg(X);
  SIRegister_uinterv(X);
  SIRegister_JvHighlighter(X);
  SIRegister_Diff(X);
  SIRegister_WinAPI(X);
  SIRegister_Services(X);
  SIRegister_SocketsDelphi(X);
  SIRegister_JvForth(X);
  SIRegister_HttpRESTConnectionIndy(X);
  SIRegister_RestRequest(X);
  SIRegister_StBits(X);
  SIRegister_MultilangTranslator(X);
  SIRegister_HyperLabel(X);
  SIRegister_TomDBQue(X);
  SIRegister_Starter(X);
  SIRegister_FileAssocs(X);
  SIRegister_devFileMonitorX(X);
  SIRegister_devrun(X);
  SIRegister_devExec(X);
  SIRegister_oysUtils(X);
  SIRegister_DosCommand(X);      //3996
  SIRegister_CppTokenizer(X);
  //SIRegister_JvHLParser(X);
  SIRegister_JclShell(X);
  SIRegister_JclCOM(X);
  SIRegister_GR32_Math(X);
  //SIRegister_GR32_LowLevel(X);
   SIRegister_SimpleHl(X);
  SIRegister_cXMLFunctions(X);
  SIRegister_JvTimer(X);
  SIRegister_cHTTPUtils(X);
  SIRegister_cTLSUtils(X);
  SIRegister_JclGraphics(X);
  SIRegister_JclSynch(X);
  SIRegister_Spring_Cryptography_Utils(X);
  //SIRegister_MapReader(X);
  SIRegister_uwinstr(X);
  SIRegister_utexplot(X);
  //SIRegister_VarRecUtils(X);
  SIRegister_JvStringHolder(X);
  //SIRegister_JvStringListToHtml(X);
  SIRegister_Barcode(X);
  SIRegister_ip_misc(X);
  SIRegister_SimpleXML(X);
  SIRegister_JvAppEvent(X);
  SIRegister_JvAppInst(X);
  SIRegister_JvAppCommand(X);
  SIRegister_JvAnimatedImage(X);
  SIRegister_JvAnimTitle(X);
  SIRegister_IdASN1Util(X);
  SIRegister_IdHash(X);
  SIRegister_IdHashCRC(X);
  SIRegister_IdHashMessageDigest(X);  //3.5
  SIRegister_IdHashSHA1(X);
  SIRegister_IdLogFile(X);
  SIRegister_IdTime(X);
  SIRegister_IdDayTime(X);
 // SIRegister_IdGlobal(X);
  SIRegister_IdEMailAddress(X);
  SIRegister_IdMessage(X);
  SIRegister_IdMessageClient(X);
  SIRegister_IdSMTP(X);
  SIRegister_IdPOP3(X);
  SIRegister_IdMailBox(X);
  SIRegister_IdQotd(X);
  SIRegister_IdTelnet(X);
  SIRegister_IdNetworkCalculator(X);
  SIRegister_IdFinger(X);
  SIRegister_IdIcmpClient(X);
  SIRegister_IdUDPBase(X);
  SIRegister_IdUDPClient(X);
  SIRegister_IdTrivialFTPBase(X);
  SIRegister_IdTrivialFTP(X);
  SIRegister_IdRemoteCMDClient(X);
  SIRegister_IdRemoteCMDServer(X);
  SIRegister_IdRexec(X); //client & server
  SIRegister_IdUDPServer(X);
  SIRegister_IdIPWatch(X);
  SIRegister_IdIrcServer(X);
  SIRegister_IdMessageCollection(X);
  //SIRegister_IdRFCReply(X);   //3.9.7.5
  SIRegister_IdIdentServer(X);
  SIRegister_IdIdent(X);
  SIRegister_IdEcho(X);
  SIRegister_IdEchoServer(X);
  //SIRegister_IdEchoUDP(X);
  SIRegister_IdEchoUDP(X);
  SIRegister_IdEchoUDPServer(X);
  SIRegister_IdTelnetServer(X);
  SIRegister_IdAntiFreezeBase(X);
  SIRegister_IdHostnameServer(X);
  //SIRegister_IdTunnelCommon(X);
  //SIRegister_IdTunnelMaster(X);
  //SIRegister_IdTunnelSlave(X);
  SIRegister_IdRSHServer(X);
  SIRegister_IdRSH(X);
  SIRegister_LibTar(X);
  SIRegister_IdChargenServer(X);
  //SIRegister_IdBlockCipherIntercept(X);
  SIRegister_IdFTPServer(X);
  SIRegister_StNet(X);
  SIRegister_StNetPfm(X);
  SIRegister_JvPatchFile(X);
  SIRegister_JclPrint(X);
  SIRegister_JclMime(X);
  SIRegister_JvRichEdit(X);
  SIRegister_JvDBRichEd(X);
  SIRegister_JvDice(X);
  SIRegister_cPEM(X);
  //SIRegister_cFundamentUtils(X);   //3.9.6.3 remove
  SIRegister_uwinplot(X);
  SIRegister_umath(X);
  SIRegister_ufft(X);
  SIRegister_GR32_System(X);
  SIRegister_JvSimLogic(X);      //3.9.7.4
  SIRegister_JvSimIndicator(X);
  SIRegister_JvSimPID(X);
  SIRegister_JvSimPIDLinker(X);
  SIRegister_JclPeImage(X);
  SIRegister_xrtl_util_CPUUtils(X);
  SIRegister_xrtl_net_URI(X);
  SIRegister_xrtl_net_URIUtils(X);
  SIRegister_xrtl_util_StrUtils(X);
  SIRegister_xrtl_util_COMCat(X);
  SIRegister_xrtl_util_VariantUtils(X);
  SIRegister_xrtl_util_FileUtils(X);
   SIRegister_xrtl_util_Compat(X);
  SIRegister_OleAuto(X);
  SIRegister_xrtl_util_COMUtils(X);
  SIRegister_CmAdmCtl(X);
  SIRegister_GR32(X);
  SIRegister_GR32_Image(X);
  SIRegister_GR32_Rasterizers(X);
  SIRegister_GR32_ExtImage(X);
  SIRegister_GR32_OrdinalMaps(X);
  SIRegister_GR32_LowLevel(X);
  SIRegister_GR32_Filters(X);
  SIRegister_GR32_VectorMaps(X);
  //SIRegister_LazFileUtils(X);
  //SIRegister_IDECmdLine(X);
SIRegister_Hashes(X);
  SIRegister_xrtl_util_TimeStamp(X);
  SIRegister_xrtl_util_TimeUtils(X);
  SIRegister_xrtl_util_TimeZone(X);
  SIRegister_xrtl_util_Map(X);
  SIRegister_xrtl_util_Set(X);  //3.9.6.4
  SIRegister_xrtl_util_Compare(X);
  SIRegister_xrtl_util_Value(X);
  SIRegister_xrtl_util_Exception(X);
  SIRegister_cFileUtils(X);
  SIRegister_cDateTime(X);
  SIRegister_cTimers(X);
  SIRegister_cRandom(X);
  SIRegister_ueval(X);
  SIRegister_DBXChannel(X);
  SIRegister_DBXIndyChannel(X);
  SIRegister_LinarBitmap(X);
  SIRegister_PNGLoader(X);
  //SIRegister_IniFiles(X);
  SIRegister_IdThread(X);
  SIRegister_fMain(X);
  SIRegister_niSTRING(X);
  SIRegister_niRegularExpression(X);
  SIRegister_niExtendedRegularExpression(X);
  SIRegister_IdSNTP(X);
  //SIRegister_SysUtils(X);         //maybe bug
  SIRegister_cFundamentUtils(X);   //3.9.6.3
  SIRegister_ShellAPI(X);
end;

procedure TMaxForm1.IFPS3ClassesPlugin1ExecImport(Sender: TObject; Exec: TIFPSExec;
  x: TIFPSRuntimeClassImporter);
begin
  //procedure RIRegister_ExtCtrls(cl: TPSRuntimeClassImporter);
  RIRegister_Std(x);
  RIRegister_Classes(x, True);
  RIRegister_Graphics(x, True);
  RIRegister_Graphics_Routines(Exec); //3.6
  RIRegister_Controls(x);
  RIRegister_stdctrls(x);
  RIRegister_extctrls(x);
  RIRegister_Forms(x);
  RIRegister_Grids(x);
  RIRegister_Menus(X);
  RIRegister_Buttons(X);
  RIRegister_TwinFormp(x);
  RIRegister_TMyLabel(x);
  RIRegister_WinForm1(x);
  RegisterDateTimeLibrary_R(exec);
  RIRegister_EInvalidArgument(x);
  RIRegister_MathMax_Routines(exec);
  RIRegister_WideStrUtils_Routines(Exec);
  RIRegister_WideStrings(X);  //3.2
  RIRegister_Types_Routines(Exec);  //3.5
  RIRegister_StrHlpr_Routines(Exec);
  RIRegister_DBCommon_Routines(Exec);
  RIRegister_DBCommon(X);
  RIRegister_DB(x);
  RIRegister_DB_Routines(Exec);
  RIRegister_DBTables_Routines(Exec);
  RIRegister_DBTables(X);
  RIRegister_DBPlatform(X);
  RIRegister_DBLogDlg(X);
  RIRegister_DBLogDlg_Routines(Exec);
  RIRegister_SqlTimSt_Routines(Exec);
  RIRegister_Printers(X);
  RIRegister_Printers_Routines(Exec);
  RIRegister_StrUtils_Routines(exec);
  RIRegister_MPlayer(X);
  RIRegister_ImgList(X);
  RIRegister_ComObj(Exec);
  RIRegister_Clipbrd(X);
  RIRegister_Clipbrd_Routines(Exec);
  RIRegister_SqlExpr(X); //3.2
  RIRegister_SqlExpr_Routines(Exec);
  RIRegister_ADODB(X);
  RIRegister_ADODB_Routines(Exec);
  RIRegister_DBGrids(X);
  RIRegister_DBCtrls(X);
  RIRegister_DBCtrls_Routines(Exec);
  RIRegister_DBCGrids(X);
  RIRegister_DateUtils_Routines(Exec);
  RIRegister_FileUtils_Routines(Exec);
  RIRegister_gsUtils_Routines(Exec);
  RIRegister_JvFunctions_Routines(Exec);
  RIRegister_JclBase(X);
  RIRegister_JvgCommClasses(X);
  RIRegister_JvgUtils(X);
  RIRegister_JvgUtils_Routines(Exec);
  RIRegister_JclBase_Routines(Exec);
  RIRegister_JclStatistics_Routines(Exec);
  RIRegister_JclMiscel_Routines(Exec);
  RIRegister_JclLogic_Routines(Exec);
  RIRegister_JvVCLUtils(X);   //3.8.2
  RIRegister_JvVCLUtils_Routines(Exec);
  RIRegister_JvUtils_Routines(Exec);
  //RIRegister_JvJCLUtils(X);
  //RIRegister_JvJCLUtils_Routines(Exec);
  RIRegister_JvAppUtils_Routines(Exec);
  RIRegister_JvDBUtil(X);
  RIRegister_JvDBUtil_Routines(Exec);
  RIRegister_JvDBUtils(X);
  RIRegister_JvDBUtils_Routines(Exec);
  RIRegister_JvParsing(X);
  RIRegister_JvParsing_Routines(Exec);
  RIRegister_JvComponent(X);
  RIRegister_JvFormToHtml(X);
  RIRegister_IdHeaderList(X);
  RIRegister_IdMultipartFormData(X);
  //SIRegister_JvCtrlUtils(X);
  RIRegister_JvCtrlUtils_Routines(Exec);
  RIRegister_JvBdeUtils(X);
  RIRegister_JvBdeUtils_Routines(Exec);
  RIRegister_JvDateUtil_Routines(Exec);
  RIRegister_JvGenetic(X);
  RIRegister_JvStrUtil_Routines(Exec);
  RIRegister_JvStrUtils_Routines(Exec);
  RIRegister_JvFileUtil_Routines(Exec);
  RIRegister_JvJCLUtils(X);
  RIRegister_JvJCLUtils_Routines(Exec);
  RIRegister_JvCalc(X);
  RIRegister_JvCalc_Routines(Exec);
  RIRegister_JvMemoryInfos(X);
  RIRegister_JvComputerInfo(X);
  RIRegister_JvStarfield(X);
  RIRegister_JvAnalogClock(X);
  RIRegister_JvAlarms(X);
  RIRegister_JvSQLS(X);
  RIRegister_JvDBSecur(X);
  RIRegister_JvDBQBE(X);
  RIRegister_JvProfiler32(X);
  RIRegister_Serial(X);
  RIRegister_SerDlgs(X);
  //RIRegister_SerDlgs_Routines(Exec); only register
  RIRegister_JvLED(X);
  RIRegister_JvgLogics(X);
  RIRegister_JvTurtle(X);
  RIRegister_SortThds(X);
  RIRegister_ThSort(X);
  RIRegister_JvExprParser(X);
  RIRegister_SynRegExpr(X);
  RIRegister_SynRegExpr_Routines(Exec);
  RIRegister_JvHtmlParser(X);
  RIRegister_JvgXMLSerializer(X);
  RIRegister_JvStrings_Routines(Exec);
  RIRegister_uTPLb_IntegerUtils_Routines(Exec);
  RIRegister_uTPLb_HugeCardinal(X);
  RIRegister_uTPLb_HugeCardinalUtils_Routines(Exec);
  RIRegister_LongIntList(X);
  RIRegister_StBase(X);
  RIRegister_StBase_Routines(Exec);
  RIRegister_StUtils_Routines(Exec);  //SysTools4
  RIRegister_StFirst_Routines(Exec);
  RIRegister_StToHTML(X);
  RIRegister_StStrms(X);
  RIRegister_StFIN_Routines(Exec);
  RIRegister_StAstroP_Routines(Exec);
  RIRegister_StStat_Routines(Exec);
  RIRegister_StNetCon(X);
  RIRegister_StDecMth(X);
  RIRegister_StOStr(X);
  RIRegister_StPtrns(X);
  RIRegister_StNetMsg(X);
  RIRegister_StMath_Routines(Exec);
  RIRegister_StExpLog(X);
  RIRegister_StExport(X);
  RIRegister_StGenLog(X);
  RIRegister_StGenLog_Routines(Exec);
  RIRegister_ActnList(X);
  RIRegister_jpeg(X);
  RIRegister_StRandom(X);
  RIRegister_StDict(X);
  RIRegister_StDict_Routines(Exec);
RIRegister_Hashes(X);

  RIRegister_StBCD_Routines(Exec);
  RIRegister_StTxtDat(X);
  RIRegister_StTxtDat_Routines(Exec);
  RIRegister_StRegEx(X);
  RIRegister_StIniStm(X);
  RIRegister_StIniStm_Routines(Exec);
  RIRegister_StBarC(X);
  RIRegister_StDbBarC(X);
  RIRegister_StBarPN(X);
  RIRegister_StDbPNBC(X);
  RIRegister_StDb2DBC(X);
  //RIRegister_StMoney(X);
  RIRegister_STSystem_Routines(Exec);
  RIRegister_SynURIOpener(X);
  RIRegister_JvKeyboardStates(X);
  RIRegister_JclMapi(X);
  RIRegister_JclMapi_Routines(Exec); //3.9.9.6
  RIRegister_JvMail(X);
  RIRegister_JclConsole(X);
  //RIRegister_JclLANMan_Routines(exec);
  RIRegister_JclLocales(X);
  RIRegister_JclLocales_Routines(Exec);
  //RIRegister_IdStack(X);
  RIRegister_IdSocks(X);
  RIRegister_IdSocketHandle(X);
  RIRegister_IdMessageCoder(X);
  RIRegister_IdMessageCoderMIME(X);
  RIRegister_IdServerIOHandler(X);
  RIRegister_IdServerIOHandlerSocket(X);
  RIRegister_IdIOHandlerSocket(X);
  RIRegister_IdTCPServer(X);
  RIRegister_IdCustomHTTPServer(X);
  RIRegister_IdCustomHTTPServer_Routines(Exec);
  RIRegister_IdSSLOpenSSL(X);
  RIRegister_IdRemoteCMDClient(X);
  RIRegister_IdRemoteCMDServer(X);
  RIRegister_IdRexec(X);
  RIRegister_IdUDPServer(X);
  RIRegister_IdIPWatch(X);
  RIRegister_IdIrcServer(X);
  RIRegister_IdMessageCollection(X);
  RIRegister_IdRFCReply(X);
  RIRegister_IdIdentServer(X);
  RIRegister_IdIdent(X);
  RIRegister_IdEcho(X);
  RIRegister_IdEchoServer(X);
  //SIRegister_IdEchoUDP(X);
  RIRegister_IdEchoUDP(X);
  RIRegister_IdEchoUDPServer(X);
  RIRegister_IdTelnetServer(X);
  RIRegister_IdAntiFreezeBase(X);
  RIRegister_IdHostnameServer(X);
  //77RIRegister_IdTunnelCommon(X);
  //RIRegister_IdTunnelMaster(X);
  //RIRegister_IdTunnelSlave(X);
  RIRegister_IdRSHServer(X);
  RIRegister_IdRSH(X);
  //RIRegister_MapReader_Routines(Exec);
  RIRegister_LibTar(X);
  RIRegister_LibTar_Routines(Exec);
  RIRegister_IdChargenServer(X);
  //RIRegister_IdBlockCipherIntercept(X);
  //RIRegister_IdException(X);
  RIRegister_IdFTPServer(X);
  RIRegister_uwinstr_Routines(Exec);
  RIRegister_utexplot_Routines(Exec);
  //RIRegister_VarRecUtils_Routines(Exec);
  RIRegister_JvStringHolder(X);
  //RIRegister_JvStringListToHtml(X);
  RIRegister_IdCoder(X);
  //7RIRegister_LazFileUtils_Routines(Exec);
  //RIRegister_IDECmdLine_Routines(Exec);
  RIRegister_lazMasks_Routines(Exec);
  RIRegister_lazMasks(X);
  RIRegister_Barcode(X);
  RIRegister_Barcode_Routines(Exec);
  RIRegister_ip_misc_Routines(Exec);
  RIRegister_SimpleXML_Routines(Exec);
  RIRegister_StNet(X);
  RIRegister_StNetPfm(X);
  RIRegister_JvPatchFile(X);
  RIRegister_JclPeImage(X);
  RIRegister_JclPeImage_Routines(Exec);
  RIRegister_cPEM(X);
  RIRegister_cPEM_Routines(Exec);
  RIRegister_FlatSB_Routines(Exec);
  RIRegister_JvDirectories(X);
  RIRegister_JclSvcCtrl(X);
  RIRegister_JclSchedule(X);
  RIRegister_JclSchedule_Routines(Exec);
  RIRegister_JvSoundControl(X);
  RIRegister_JvBDESQLScript(X);
  RIRegister_JvSearchFiles(X);
   //RIRegister_IdSSLOpenSSL_Routines(Exec);
  //RIRegister_StBCD(X);
  //RIRegister_ActnList_Routines(Exec);
   RIRegister_JclNTFS(X);
   RIRegister_JclNTFS_Routines(Exec);
  RIRegister_JclAppInst(X);
  RIRegister_JclAppInst_Routines(Exec);
  RIRegister_JclMIDI(X);
  RIRegister_JclMIDI_Routines(Exec);
  //RIRegister_JclWinMidi(X);
  RIRegister_JclWinMidi_Routines(Exec);
  //RIRegister_JvRle(X);
  RIRegister_JvRle_Routines(Exec);
  RIRegister_JvImageWindow(X);
  RIRegister_JvImageDrawThread(X);  //3.9.7.3
  RIRegister_JvTransparentForm(X);
  RIRegister_JvWinDialogs(X);
  RIRegister_JvWinDialogs_Routines(Exec);
  RIRegister_JvFloatEdit(X);
  RIRegister_JvDirFrm(X);
  RIRegister_JvDirFrm_Routines(Exec);
  RIRegister_JclUnitConv_mX2_Routines(Exec);
  RIRegister_JvDualListForm(X);
  RIRegister_JvDualList(X);
  RIRegister_JvSwitch(X);
  RIRegister_JvTimerLst(X);
  RIRegister_JvObjStr(X);
  RIRegister_JvMemTable(X);
  RIRegister_xrtl_math_Integer(X);
  RIRegister_xrtl_math_Integer_Routines(Exec);
  RIRegister_StLArr(X);
  RIRegister_StWmDCpy(X);
  RIRegister_StText_Routines(Exec);
  RIRegister_StNTLog(X);
  RIRegister_JvImagPrvw_Routines(Exec);
  RIRegister_JvImagPrvw(X);
  RIRegister_JvFormPatch(X);
  RIRegister_JvDataConv(X);
  RIRegister_JvPicClip(X);
  RIRegister_JvCpuUsage(X);
  RIRegister_JvCpuUsage2(X);
  RIRegister_JvParserForm(X);
  RIRegister_JvJanTreeView(X);
  RIRegister_JvPlaylist(X);
  RIRegister_JvTransLED(X);
  RIRegister_JvFormAutoSize(X);
  RIRegister_JvYearGridEditForm(X);
  RIRegister_JvMarkupCommon(X);
  RIRegister_JvChart(X);
  RIRegister_JvXPCore(X);
  RIRegister_StatsClasses(X);
  RIRegister_ExtCtrls2_Routines(Exec);
  RIRegister_ExtCtrls2(X);
  RIRegister_JvUrlGrabbers(X);
  RIRegister_JvXmlTree_Routines(Exec);
  RIRegister_JvXmlTree(X);
  RIRegister_JvWavePlayer(X);
  RIRegister_JvUnicodeCanvas(X);
  RIRegister_JvTFUtils(X);
  RIRegister_JvTFUtils_Routines(Exec);
  RIRegister_Registry(X);
  RIRegister_TlHelp32_Routines(Exec);
  RIRegister_devcutils_Routines(Exec);
  RIRegister_JclRegistry_Routines(Exec);
  //SIRegister_JvXPCoreUtils(X);
  RIRegister_JvXPCoreUtils_Routines(Exec);  //3.9.8 fin
  RIRegister_ShellZipTool_Routines(Exec);
  RIRegister_ShellZipTool(X);
  RIRegister_JvJoystick(X);
  RIRegister_JvMailSlots(X);
  RIRegister_JclComplex(X);
  RIRegister_SynPdf(X);
  RIRegister_SynPdf_Routines(Exec);
  RIRegister_JvAirBrush(X);
//  RIRegister_mORMotReport(X);
  //RIRegister_mORMotReport_Routines(Exec);
  RIRegister_ExcelExport(X);
  RIRegister_JvDBGridExport(X);
  RIRegister_JvDBGridExport_Routines(Exec);
  RIRegister_JvSerialMaker(X);
  RIRegister_JvWin32_Routines(Exec);
  RIRegister_JvPaintFX(X);
  RIRegister_JvPaintFX_Routines(Exec);
  RIRegister_JvNTEventLog(X);
  RIRegister_ugamma_Routines(Exec);
  RIRegister_IdMIMETypes_Routines(Exec);
  RIRegister_JvConverter(X);
  RIRegister_JvCsvParse_Routines(Exec);
  RIRegister_HexDump(X);
  RIRegister_HexDump_Routines(Exec);
  RIRegister_uTPLb_StreamUtils_Routines(Exec);
  RIRegister_uTPLb_AES(X);
  RIRegister_uTPLb_AES_Routines(Exec);
  RIRegister_uTPLb_SHA2(X);
  RIRegister_AESPassWordDlg(X);
  RIRegister_MathUtils_Routines(Exec);
  RIRegister_JclMultimedia(X);
  RIRegister_JclMultimedia_Routines(Exec); //3.9.75
  RIRegister_TTypeTranslator(X);
  RIRegister_TypeTrans_Routines(Exec);
  RIRegister_utypes_Routines(Exec);    //for dmath.dll
  RIRegister_uwinplot_Routines(Exec);
  RIRegister_umath_Routines(Exec);  
  RIRegister_GR32_System(X);
  RIRegister_GR32_System_Routines(Exec);
  RIRegister_JvSimLogic(X);
  RIRegister_JvSimIndicator(X);
  RIRegister_JvSimPID(X);
  RIRegister_JvSimPIDLinker(X);
  RIRegister_xrtl_util_CPUUtils_Routines(Exec);
  RIRegister_xrtl_net_URIUtils_Routines(Exec);
  RIRegister_xrtl_net_URI(X);
  RIRegister_xrtl_util_StrUtils_Routines(Exec);
  RIRegister_xrtl_util_COMCat_Routines(Exec);
  RIRegister_xrtl_util_VariantUtils_Routines(Exec);
  RIRegister_xrtl_util_FileUtils_Routines(Exec);
  RIRegister_xrtl_util_Compat_Routines(Exec);
  RIRegister_OleAuto(X);
  RIRegister_OleAuto_Routines(Exec);
  RIRegister_xrtl_util_COMUtils(X);
  RIRegister_xrtl_util_COMUtils_Routines(Exec);
  RIRegister_CmAdmCtl(X);
  RIRegister_GR32(X);
  RIRegister_GR32_Routines(Exec);
  RIRegister_GR32_Rasterizers(X);
  RIRegister_GR32_Rasterizers_Routines(Exec);
  RIRegister_GR32_Image(X);
  RIRegister_GR32_ExtImage(X);
  RIRegister_GR32_ExtImage_Routines(Exec);
  RIRegister_GR32_OrdinalMaps(X);
  RIRegister_xrtl_util_TimeStamp(X);
  //RIRegister_xrtl_util_TimeUtils(X);
  RIRegister_xrtl_util_TimeUtils_Routines(Exec);
  RIRegister_xrtl_util_TimeZone(X);
  RIRegister_xrtl_util_TimeZone_Routines(Exec);
  RIRegister_xrtl_util_Map(X);
  RIRegister_xrtl_util_Set(X);  //3.9.6.4
  RIRegister_xrtl_util_Exception(X);
  RIRegister_xrtl_util_Exception_Routines(Exec);
  RIRegister_xrtl_util_Compare_Routines(Exec);
  RIRegister_xrtl_util_Value(X);
  RIRegister_xrtl_util_Value_Routines(Exec);
  RIRegister_cRandom_Routines(Exec);
  RIRegister_ueval_Routines(Exec);
   //RIRegister_EIdHTTPProtocolException(x);
  {RIRegister_TIdHTTP(x);
  RIRegister_TIdCustomHTTP(x);
  RIRegister_TIdHTTPProtocol(x);
  RIRegister_TIdHTTPRequest(x);
  RIRegister_TIdHTTPResponse(x);}
  RIRegister_IdTCPConnection(X);
  RIRegister_IdTCPClient(X);
  RIRegister_IdHTTPHeaderInfo(X);
  RIRegister_IdHTTP(x);
  RIRegister_HTTPParse(X);
  RIRegister_HTTPUtil_Routines(Exec);
  RIRegister_HTTPApp(X);         //3.7
  RIRegister_HTTPApp_Routines(EXec);
  RIRegister_DBWeb(X);
  RIRegister_DBWeb_Routines(Exec);
  RIRegister_DBXpressWeb(X);
  RIRegister_DBBdeWeb(X);
  RIRegister_ShadowWnd(X);  //3.8
  RIRegister_ToolWin(X);
  RIRegister_Tabs(X);
  RIRegister_JclGraphUtils_Routines(Exec);
  RIRegister_JclCounter(X);
  RIRegister_JclCounter_Routines(Exec);
  RIRegister_JclSysInfo_Routines(Exec);
  RIRegister_JclSecurity_Routines(Exec);
  RIRegister_IdUserAccounts(X);
  RIRegister_JclFileUtils(X);
  RIRegister_JclFileUtils_Routines(Exec);
  RIRegister_IdAuthentication(X);
  RIRegister_IdAuthentication_Routines(Exec);
  RIRegister_IMouse_Routines(Exec);
  RIRegister_IMouse(X);
  RIRegister_JclPrint(X);
  RIRegister_JclPrint_Routines(Exec);
  RIRegister_JclMime_Routines(Exec);
  RIRegister_JvRichEdit(X);
  RIRegister_JvDBRichEd(X);
  RIRegister_JvDice(X);
  //RIRegister_JclMime(X);
  //RIRegister_TIdURI(x);
  RIRegister_IdURI(X);
   RIRegister_SyncObjs(X);
  //RIRegister_AsyncCalls_Routines(Exec);
  RIRegister_AsyncCalls(X);
  RIRegister_AsyncCalls_Routines(Exec);
   RIRegister_ParallelJobs(X);
  RIRegister_ParallelJobs_Routines(Exec);
  RIRegister_Variants_Routines(Exec);
  RIRegister_VarCmplx_Routines(Exec);
  RIRegister_DTDSchema(X);
  RIRegister_ShLwApi_Routines(Exec);
  RIRegister_IBUtils_Routines(Exec);
  RIRegister_TIBTimer(X);    ////3.9.2.2 fin -3.9.3
  RIRegister_JclSimpleXml(X);
  RIRegister_JclSimpleXml_Routines(Exec);
  RIRegister_JvLogFile(X);
  RIRegister_JvGraph_Routines(Exec);
  RIRegister_TJvGradient(X);
  RIRegister_JvComCtrls(X);
  RIRegister_JvCtrls(X);
  RIRegister_CPort(X);
  RIRegister_CPort_Routines(Exec);
  RIRegister_CPortCtl(X);
  RIRegister_CPortEsc(X);   //3.9.3
  RIRegister_CPortMonitor(X);
  RIRegister_cutils_Routines(Exec);
  RIRegister_PerlRegEx(X);
  RIRegister_BoldUtils_Routines(Exec);
  RIRegister_IdSimpleServer(X);
  RIRegister_BarCodeScaner(X);
  //RIRegister_BarCodeScaner_Routines(Exec);
  RIRegister_GUITesting(X);
  RIRegister_JvFindFiles(X);
  RIRegister_JvFindFiles_Routines(Exec);
  RIRegister_CheckLst(X);
  RIRegister_JvSimpleXml(X);
  RIRegister_JvSimpleXml_Routines(Exec);
  RIRegister_ExtPascalUtils_Routines(Exec);
  RIRegister_SocketsDelphi_Routines(Exec);
  RIRegister_XmlVerySimple(X);
  //RIRegister_StAstro(X);
  RIRegister_StAstro_Routines(Exec);
  RIRegister_StSort(X);
  RIRegister_StSort_Routines(Exec);
  RIRegister_StDate_Routines(Exec);
  RIRegister_StDateSt_Routines(Exec);
  RIRegister_StVInfo(X);
  RIRegister_JvBrowseFolder(X);
  RIRegister_JvBrowseFolder_Routines(Exec);
  RIRegister_JvBoxProcs_Routines(Exec);
  RIRegister_usimann_Routines(Exec);
  RIRegister_urandom_Routines(Exec);
  RIRegister_uranuvag_Routines(Exec);
  RIRegister_uqsort_Routines(Exec);
  RIRegister_ugenalg_Routines(Exec);
  RIRegister_uinterv_Routines(Exec);
  RIRegister_JvHighlighter(X);
  RIRegister_Diff(X);
  RIRegister_WinAPI_Routines(Exec);
  RIRegister_StBits(X);
  RIRegister_MultilangTranslator(X);
  RIRegister_HyperLabel(X);
  RIRegister_TomDBQue(X);
  RIRegister_Starter(X);
  RIRegister_FileAssocs_Routines(Exec);
  RIRegister_devFileMonitorX(X);
  RIRegister_devrun(X);
  RIRegister_devExec(X);
  RIRegister_devExec_Routines(Exec);
  RIRegister_oysUtils(X);
  RIRegister_oysUtils_Routines(Exec);
  RIRegister_DosCommand(X);
  RIRegister_CppTokenizer(X);
 // RIRegister_JvHLParser(X);
//  RIRegister_JvHLParser_Routines(Exec);
  RIRegister_JclShell_Routines(Exec);
  RIRegister_JclCOM_Routines(Exec);
  RIRegister_GR32_Math_Routines(Exec);
  RIRegister_GR32_LowLevel_Routines(Exec);
  RIRegister_SimpleHl(X);
  RIRegister_GR32_Filters_Routines(Exec);
  RIRegister_GR32_VectorMaps(X);
  RIRegister_cXMLFunctions_Routines(Exec);
  RIRegister_JvTimer(X);
  RIRegister_cHTTPUtils_Routines(Exec);
  RIRegister_cHTTPUtils(X);
   RIRegister_ETLSError(X);
  RIRegister_cTLSUtils_Routines(Exec);
  RIRegister_JclGraphics_Routines(Exec);
  RIRegister_JclGraphics(X);
  RIRegister_JclSynch(X);
  RIRegister_JclSynch_Routines(Exec);
  RIRegister_Spring_Cryptography_Utils_Routines(Exec);

   RIRegister_JvXmlDatabase(X);
   RIRegister_IdURI(x);
  RIRegister_IdFTP(X);
  RIRegister_xmlutil_Routines(Exec); //3.2 XML
  RIRegister_MaskUtils_Routines(Exec); //3.5
  RIRegister_Masks(X);
  RIRegister_Masks_Routines(Exec);
  RIRegister_FileCtrl(X);
  RIRegister_FileCtrl_Routines(Exec);
  RIRegister_Outline(X);
  RIRegister_ScktComp(X);
  RIRegister_ScktComp_Routines(Exec);
  RIRegister_Calendar(X);
  RIRegister_VListView(X);
  RIRegister_ide_debugoutput(X);
  RIRegister_ComCtrls(X); //3.6
  RIRegister_ComCtrls_Routines(Exec);
  RIRegister_Dialogs(X);
  RIRegister_Dialogs_Routines(Exec);
  RIRegister_ExtDlgs(X);
  RIRegister_ValEdit(X);
  RIRegister_FMTBcd(X);
  RIRegister_FMTBcd_Routines(Exec);
  RIRegister_Provider_Routines(Exec); //3.6
  RIRegister_Provider(X);
  RIRegister_DBClient_Routines(Exec);
  RIRegister_DBClient(X);
  RIRegister_CDSUtil_Routines(Exec);
  RIRegister_GraphUtil_Routines(Exec);
  RIRegister_VarHlpr_Routines(Exec);
  RIRegister_interface2_so(X);
  RIRegister_IdASN1Util_Routines(Exec);
  RIRegister_Contnrs(X);
  RIRegister_Contnrs_Routines(Exec);
  RIRegister_MyBigInt(X);
  RIRegister_StdConvs_Routines(Exec);
  RIRegister_ConvUtils(X);
  RIRegister_ConvUtils_Routines(Exec);
  RIRegister_SOAPHTTPClient(X);
  RIRegister_VCLScannerImpl(X);
  RIRegister_SynEditKeyCmds_Routines(Exec);
  RIRegister_SynEditKeyCmds(X);
  RIRegister_SynMacroRecorder(X);
  RIRegister_SynEditTypes_Routines(Exec);
  RIRegister_SynEditMiscClasses(X);
  RIRegister_SynEditHighlighter(X);
  RIRegister_SynEditHighlighter_Routines(Exec);
  RIRegister_SynHighlighterPas(X);
  RIRegister_SynEdit(X);
  RIRegister_SynEditRegexSearch(X);
  RIRegister_SynMemo(X);
  RIRegister_SynHighlighterAny(X);
  RIRegister_SynEditMiscProcs_Routines(Exec);
  RIRegister_SynEditExport(X);
  RIRegister_SynExportRTF(X);
  RIRegister_SynExportHTML(X);
  RIRegister_SynEditSearch(X);
  RIRegister_JvSticker(X);
  RIRegister_JvZoom(X);
  RIRegister_PMrand_Routines(Exec);
//  RIRegister_SynHighlighterDfm_Routines(Exec);
//  RIRegister_SynHighlighterDfm(X);

  //RIRegister_XmlVerySimple(X);
  RIRegister_Services(X);
  RIRegister_JvForth(X);
  RIRegister_JvForth_Routines(Exec);
  RIRegister_HttpRESTConnectionIndy(X);
  RIRegister_RestRequest(X);
  RIRegister_JvAppEvent(X);
  RIRegister_JvAppInst(X);
  RIRegister_JvAppCommand(X);
  RIRegister_JvAppCommand_Routines(Exec);
  RIRegister_JvAnimatedImage(X);
  RIRegister_JvAnimTitle(X);
  RIRegister_IdHash(X);
  RIRegister_IdHashCRC(X);
  RIRegister_IdHashMessageDigest(X);
  RIRegister_IdHashSHA1(X);
  RIRegister_IdLogFile(X);
  RIRegister_IdTime(X);
  RIRegister_IdDayTime(X);
  RIRegister_IdGlobal(X);
  RIRegister_IdGlobal_Routines(exec);
  RIRegister_IdEMailAddress(X);
  RIRegister_IdMessage(X);
  RIRegister_IdMessageClient(X);
  RIRegister_IdSMTP(X);
  RIRegister_IdPOP3(X);
  RIRegister_IdMailBox(X);
  RIRegister_IdQotd(X);
  RIRegister_IdTelnet(X);
  RIRegister_IdNetworkCalculator(X);
  RIRegister_IdFinger(X);
  RIRegister_IdIcmpClient(X);
  RIRegister_IdUDPBase(X);
  RIRegister_IdUDPClient(X);
  RIRegister_IdTrivialFTPBase_Routines(Exec);
  RIRegister_IdTrivialFTP(X);
  RIRegister_LinarBitmap(X);
  RIRegister_LinarBitmap_Routines(Exec);
  RIRegister_PNGLoader(X);
  RIRegister_PNGLoader_Routines(Exec);
  RIRegister_IniFiles(X);
  RIRegister_IdThread(X);
  RIRegister_fMain(X);
  RIRegister_niSTRING_Routines(Exec);
  RIRegister_niSTRING(X);
  RIRegister_niRegularExpression(X);
  RIRegister_niExtendedRegularExpression(X);
  RIRegister_IdSNTP(X);
  RIRegister_cFileUtils_Routines(exec);
  RIRegister_EFileError(X);
  RIRegister_ufft_Routines(Exec);
  RIRegister_DBXChannel(X);
  RIRegister_DBXIndyChannel(X);
  //RIRegister_ufft(X);
  RIRegister_cDateTime_Routines(Exec);
  RIRegister_cDateTime(X);
  RIRegister_cTimers_Routines(Exec);
  RIRegister_cTimers(X);
  RIRegister_SysUtils(X);
  RIRegister_SysUtils_Routines(Exec);   //fallback resort!
  RIRegister_ShellAPI_Routines(Exec);
  RIRegister_cFundamentUtils_Routines(Exec);
end;

//type TFoldRegionType = (rtChar, rtKeyWord);


procedure TMaxForm1.FormCreate(Sender: TObject);
//var //Plugin: TPSPlugin;
begin
  self.Height:= 830;
  self.Width:= 950;
  STATEdchanged:= false;
  STATSavebefore:= true;    //2.8.1. once
  STATInclude:= true;
  STATExceptionLog:= true; //v3
  STATExecuteShell:= true; //v3   from IFSI_WinForm1puzzle!!
  STATformOutput:= false; //v3.5
  STATExecuteBoot:= true; //v38
  STATLastFile:= false; //v393
  STATMemoryReport:= false; //396
  STATMacro:= true;
  STATActiveyellow:= false;
  STATVersionCheck:= true;
  STATOtherHL:= false;
  fdebuginst:= false;
  fmemoclick:= false;
  STATCodefolding:= true;        //new4
  //ActiveLineColor1Click(Self);
  //memo1.activeLineColor:= clmoneygreen;
  factivelinecolor:= clWebFloralWhite;
  memo1.Options:= memo1.Options + [eoDropFiles];
  //memo1.TabWidth:= 6;  //3.9.3
  memo1.TabWidth:= 4;  //3.9.8
  dragAcceptFiles(maxForm1.Handle, True );
  memo2.Lines.add('Welcode: memo1 is editor - memo2 is output');
  memo2.Height:= 175;
  memo2.WordWrap:= true;
  //Plugin:= TPSImport_Winform1.create(self);
  //TPSPluginItem(psscript.plugins.add).plugin:= Plugin;
  //cedebug.Plugins:= psscript.Plugins.
  cedebug.OnCompile:= PSScriptCompile;
  cedebug.OnExecute:= cedebugExecute; //!! independent from main execute
  memo1.Options:= DefSynEditOptions;
  memo1.Highlighter:= SynPasSyn1;
  //SynPasSyn1.
  memo1.Gutter.ShowLineNumbers:= true;
  memo1.WantTabs:= true;
   statusbar1.SimplePanel:= false;
  with statusbar1 do begin
    //simplepanel:= true;
    showhint:= true;
    hint:= ExtractFilePath(application.ExeName)+' Exe directory';
     Panels.add;
     panels.items[0].width:= maxform1.width-270;
     panels.items[0].text:= 'LED BOX Data Log';
     Panels.add;
     panels.items[1].width:= 210;
     panels.items[1].text:= 'BOX Logic Logger State';
     Panels.add;
     panels.items[2].width:= 60;
     panels.items[2].text:= 'Mod';
  end;
   //default for first history write in ini  3.9.3
      last_fName:= 'PRELAST_FILE';
      last_fName1:= 'PRELAST_FILE1';
      last_fName2:= 'PRELAST_FILE2';
      last_fName3:= 'PRELAST_FILE3';
      last_fName4:= 'PRELAST_FILE4';
      last_fName5:= 'PRELAST_FILE5';
      last_fName6:= 'PRELAST_FILE6';
      last_fName7:= 'PRELAST_FILE7';
      last_fName8:= 'PRELAST_FILE8';        //3.9.8.6
      last_fontsize:= 11;
      IPPORT:= 8080;
      IPHOST:= '127.0.0.1';
      COMPORT:= 3;
      //NAVWIDTH:= 100; min
      lbintflistwidth:= 350;
  if fileexists(DEFINIFILE) then LoadFileNameFromIni;  //script file
  DefFileread;
  PSScript.UsePreProcessor:= true;
  dlgPrintFont1.Font.Size:= 7;      //Default 3.8
  dlgPrintFont1.Font.Name:= RCPRINTFONT;
  fPrintOut:= TSynEditPrint.Create(Self);
  fPrintOut.Font.Name:= RCPRINTFONT;
  fPrintOut.Font.Assign(dlgPrintFont1.Font); //3.1
  //fprintout.OnPrintLine:= SynEditPrint1PrintLine;
  fprintout.OnPrintStatus:= SynEditPrint1PrintStatus;
   //fAutoComplete.Editor := TCustomSynEdit(SynPasSyn1);
  if Application.MainForm = NIL then begin
    fAutoComplete:= TSynAutoComplete.Create(Self);
    fAutoComplete.Editor:= memo1;
  if fileexists('bds_delphi.dci') then
    fAutoComplete.AutoCompleteList.LoadFromFile('bds_delphi.dci') else
      showmessage('maXbox: a bds_delphi.dci file is missing (code completion)'+#13#10+
                  'get file: http://www.softwareschule.ch/download/bds_delphi.zip');
  end else
    maxForm1.fAutoComplete.AddEditor(memo1);
  memo1.AddKey(ecAutoCompletion, word('J'), [ssCtrl], 0, []);
  //statusbar1.simplepanel:= true;
  //statusbar1.Width:= 400;
     statusbar1.panels.items[0].width:= maxform1.width-270;
     statusbar1.panels.items[1].width:= 210;
     statusbar1.panels.items[2].width:= 60;

 { statusbar1.SimplePanel:= false;
  with statusbar1 do begin
    //simplepanel:= true;
    showhint:= true;
    hint:= ExtractFilePath(application.ExeName)+' Exe directory';
     Panels.add;
     panels.items[0].width:= maxform1.width-200;
     panels.items[0].text:= 'LED BOX Data Log';
     Panels.add;
     panels.items[1].width:= 200;
     panels.items[1].text:= 'BOX Logic Logger State';
  end;}
  //memo1.Highlighter:= SynUriSyn1;   //not two at same possible

  memo1.BookMarkOptions.BookmarkImages:= imbookmarkimages;
  bookmarkimage:= 12;
  memo1.OnDblClick:= NIL;
  //ActiveLineColor1Click(Self);
  memo1.activeLineColor:= factivelinecolor; //default:clWebFloralWhite;//clskyblue;
  showSpecChars1.Checked:= false;
  debugout:= Tdebugoutput.Create(self);
  editreplace1.Checked:= false;
  //listform1:= TFormListview.Create(self);
  //listform1.Hide;
  //FOrgListViewWndProc:= ListForm1.WindowProc; // save old window proc
  //ListForm1.WindowProc:= ListViewWndProc;  // subclass
  //TMessage(WMDROP_THEFILES);//
  //DragAcceptFiles(listform1.Handle, True);
  //CB1SCList.Items.Add(ExtractFileName(Act_Filename));
  CB1SCList.Style:= csOwnerDrawFixed;
  CB1SCList.Font.Size:= 9;               //3.9.6.4
  //History 8 items times
    CB1SCList.Items.Add(last_fName8);
    CB1SCList.Items.Add(last_fName7);
    CB1SCList.Items.Add(last_fName6);
    CB1SCList.Items.Add(last_fName5);
    CB1SCList.Items.Add(last_fName4);
    CB1SCList.Items.Add(last_fName3);
    CB1SCList.Items.Add(last_fName2);
   CB1SCList.Items.Add(last_fName1);
    CB1SCList.Items.Add(last_fName);
  CB1SCList.Items.Add((Act_Filename));
  CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
  //if STATVERSIONCHECK then
    //if VersionCheck then memo2.Lines.Add('Version on Internet Checked!') else
  if (STATVERSIONCHECK AND VersionCheck) then memo2.Lines.Add('Version on Internet checked!') else
   memo2.Lines.Add('Internet Version NOT checked!');   //3.8
  if STATExecuteBoot then LoadBootScript;
  if STATExceptionLog then
     Application.OnException:= AppOnException;   //v3
    //CLI of command line or ShellExecute

  try
  if (ParamStr(1) <> '') then begin
     act_Filename:= ParamStr(1);
     memo1.Lines.LoadFromFile(act_Filename);
     memo2.Lines.Add(Act_Filename + CLIFILELOAD);
     statusBar1.panels.items[0].text:= Act_Filename + CLIFILELOAD;
     CB1SCList.Items.Add((Act_Filename));   //3.9 wb  bugfix 3.9.3.6
     CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
     if (ParamStr(2) = 'f') then begin
       //Compile1Click(self);!
       Application.BringToFront;  //maximize?
       //maxform1.Show;
     end;
     if (ParamStr(2) = 's') then begin
         maxform1.Show;
     end;

     Compile1Click(self);                    //new4

     if (ParamStr(2) = 'm') then begin
       Application.Minimize;
     end;
    if (ParamStr(2) = 'r') then begin
       Application.run;
     end;
      if (ParamStr(2) = 't') then begin     //new4
       Application.terminate;
     end;


  end;
  Except  //silent less log
    //raise Exception.Create('CLI fault in parse file: '+RCSTRMB+':' +act_filename);
    //showmessage('');
  end;

  //memo1.Width:= 50;
   memo1.CodeFolding.Enabled:= false;
  if STATCodefolding then begin              //new4

  memo1.CodeFolding.IndentGuides:= true;

  //memo1.CodeFolding.FolderBarColor:= clred;
  memo1.CodeFolding.HighlighterFoldRegions:= false;
   memo1.CodeFolding.CaseSensitive:= false;
  // memo1.CodeFolding.CollapsedCodeHint:= true;
   //memo1.ongutterclick:= Nil;
   //memo1.Gutter.Width:= 80;
   //memo1.gutter.Visible:= true;
  //memo1.CodeFolding.CollapsedCodeHint:= true;
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'begin','end');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, false, false, true, 'for','end');
   memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'begin','end');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'if','else');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'for','end');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'with','end');
   memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'try','end');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'while','do');
   memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'repeat','until');
   memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'case','end');

   memo1.InitCodeFolding;
   memo1.ReScanForFoldRanges;

   //memo1.RescanForFoldRegions;
 //  AAddEnding, ANoSubFoldRegions, AWholeWords: Boolean; AOpen, AClose: PChar;
  //memo1.CodeFolding.FoldRegions.Add(rtkeyword, false, false, true, 'begin','end');
   memo1.CodeFolding.FoldRegions.Add(rtchar, true, false, true, '{','}');
  //memo1.CodeFolding.FoldRegions.Add(rtchar, true, false, true, '<','>');
  //memo1.CodeFolding.FoldRegions.Add(rtchar, true, false, true, '(*','*)');

  end;

  if not STATCodefolding then showIndent1.Checked:= false;

   //memo1.ReScanForFoldRanges;
end;

procedure TMaxForm1.FormActivate(Sender: TObject);
begin
  //STATSavebefore:= true;
  //STATInclude:= true;
  //idLogDebug1.Active:= true;
 // ActiveLineColor1Click(Self);
 // memo1.activeLineColor:= clskyblue;

  StatWriteFirst:= true;
  if fileexists(DEFFILENAME) then
    Def_FName:= DEFFILENAME else begin
      memo1.Lines.SaveToFile(ExePath+DEFFILENAME);
      memo2.Lines.Add('Intern Set: ' +DEFFILENAME + FILESAVE);
  end;
  memo1.SetFocus;
  memo2.Lines.Add('Ver: '+MBVERSION+' ('+MBVER+'). Work Dir: ' +GetCurrentDir ); //3.3
  //memo2.Lines.Add('Version: ' +MBVERSION); //3.6
  // saved with line numbers and check state before
  if pos(inttostr(1), memo1.lines.Strings[1]) <> 0 then
                                Slinenumbers1.Checked:= true;
  if last_fontsize = 14 then begin
        Largefont1.checked:= true;
        largeFont1.Caption:= 'Small Font';
  end;

  {CB1SCList.Items.Add(ExtractFileName(Act_Filename));
  CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;}
 // CB1SCList.Items.Add(format('%-6s = %6.2f',[z0,StrToFloat(z1)/1000])); // mm in Meter umrechnen
  //statusBar1.SimpleText:= MBVERSION +' '+Act_Filename;
  //last_fontsize:= 12; //fallback
end;

procedure TMaxForm1.FormMarkup(Sender: TObject);

//var
  //SynMarkup: TSynEditMarkupHighlightAllCaret;
begin
  {SynMarkup := TSynEditMarkupHighlightAllCaret(SynEdit1.MarkupByClass[TSynEditMarkupHighlightAllCaret]);

  SynMarkup.MarkupInfo.FrameColor := clSilver;
  SynMarkup.MarkupInfo.Background := clGray;
  SynMarkup.WaitTime := 100; // millisec
  SynMarkup.Trim := True;     // no spaces, if using selection
  SynMarkup.FullWord := True; // only full words If "Foo" is under caret, do not mark it in "FooBar"
  SynMarkup.IgnoreKeywords := False;}
end;


procedure TMaxForm1.AppOnException(sender: TObject; E: Exception);
begin
  MAppOnException(sender, E);
end;

procedure TMaxForm1.ArduinoDump1Click(Sender: TObject);
begin
  ShowMessage('Arduino HexDump to Flash in uC available in V4'+#13#10+
                'first example in: ..\examples\arduino_examples');
end;

{procedure TMaxForm1.ListViewWndProc(var Msg: TMessage);
begin
  // Catch the WM_DROPFILES message, and call the original ListView WindowProc
  // for all other messages.
  case Msg.Msg of
    WM_DROPFILES: begin
             WMDROP_THEFILES(TWMDROPFILES(Msg));//DropFiles(Msg);
             Showmessage('drop in box done')
    end
  else
    if Assigned(FOrgListViewWndProc) then
      FOrgListViewWndProc(Msg);
  end;
end;}


function ImportTest(const s1:string; s2:Longint; s3:Byte; s4:word; var s5:string): string;
begin
  Result:= s1 +' '+ IntToStr(s2)+ ' '+ IntToStr(s3)+ ' ' + IntToStr(s4)+ 'OK!';
  s5:= s5 + ' '+ result + ' -   OK2!';
end;

{function myrandom(const arnd: integer): integer;  back to standard system
begin
  result:= Random(arnd);
end;}

function myrandom2(arnd: integer): double;  //old version
begin
  if arnd > 0 then
    result:= Random(arnd)
  else result:= Random;
end;

Function myrandomE: extended;  //overload from RTL System
begin
  result:= Random;
end;


function myASCtoChar(const a: byte): char;
begin
  result:= chr(a);
end;

procedure myMessageBox(const mytext: string);
begin
  showmessage(mytext)
end;

procedure MyWriteln(const sln: string);
begin
  maxForm1.memo2.Lines.Add(sln);
end;

procedure myWriteFirst(const S: string);
begin
  maxForm1.memo2.WordWrap:= true;
  //maxForm1.memo2.Text:= maxForm1.memo2.Text + #13#10;
  maxForm1.memo2.Text:= maxForm1.memo2.Text + S;
  maxForm1.StatWriteFirst:= false;
end;

procedure MyWrite(const S: string);
begin
  //if maxForm1.StatWriteFirst then mywriteFirst else   //bug 3.6
  maxForm1.memo2.WordWrap:= true;
  maxForm1.memo2.Text:= maxForm1.memo2.Text + S;
  //maxForm1.memo2.Lines.Delete(idx - 1);
end;

function MyReadln(const question: string): string;
begin
  Result:= InputBox(question, RCSTRMB, '');
end;

{procedure mySleep(vmsec: cardinal);
begin
  if vmsec > 1 then
    sleep(vmsec);
end;}

procedure myInc(var x: longint);
begin
  inc(x);
end;

procedure myDec(var x: Longint);
begin
  dec(x);
end;

procedure myIncb(var x: byte);
begin
  inc(x);
end;

function myfindFirst(const filepath: string; attr: integer): integer;
begin
  result:= findFirst(filePath, Attr, srec);
  //faDirectory = $00000010;
  //faAnyFile   = $0000003F;
end;

function myfindNext: integer;
//var search: TSearchRec;
begin
  result:= findNext(srec)
end;

procedure myfindClose; //TSearchRec
begin
  sysutils.findClose(Srec)
end;

function mySearchRecName: string;
begin
  result:= srec.Name
end;

function mySearchRecSize: integer;
begin
  result:= srec.size
end;

function mySearchRecAttr: integer;
begin
  result:= srec.attr
end;

function mySearchRecTime: integer;
begin
  result:= srec.Time
end;

function mySearchRecExcludeAttr: integer;
begin
  result:= srec.ExcludeAttr
end;

{function mySearchRecFindeHandle: integer;
begin
  result:= srec.FindHandle;
end;}

procedure myBeep;
begin
  sysutils.beep;
end;

procedure myProcMessOFF;
begin
  maxForm1.PSScript.OnLine:= NIL;
  maxForm1.procMess.Checked:= false;
end;

procedure myProcMessON;
begin
  maxForm1.PSScript.OnLine:= maxForm1.PSScriptLine;
  maxForm1.procMess.Checked:= true;
end;

procedure myIncludeOFF;
begin
   maxForm1.showInclude1.Checked:= false;
   maxForm1.STATInclude:= false;
end;

procedure myIncludeON;
begin
  maxForm1.showInclude1.Checked:= true;
  maxForm1.STATInclude:= true;
end;

function myNow: string;
begin
  result:= dateTimetoStr(now);
end;

function myNow2: TDateTime;
begin
  result:= now;
end;

procedure myAssert(expr : Boolean; const msg: string);
begin
  {$C+}             //{$ASSERTIONS ON}
  Assert(expr, (msg));
  {$C-}
   maxform1.memo2.lines.add('True Assert Log: '+msg+' mX3 Assertion: ' +DateTimeToStr(Now));
end;

procedure myassign(mystring, mypath: string); //v2.8
begin
  AssignFile(f, mypath);
  Rewrite(f);
  WriteLn(f, mystring);
  CloseFile(f);
end;

procedure myassignfileWrite(mystring, myfilename: string); //v3.1
begin
  AssignFile(fx, myfilename);
  {$I-}
  Rewrite(fx);
  {$I+}
  if IOResult = 0 then begin
    WriteLn(fx, mystring);
    CloseFile(fx);
  end;
end;

procedure myassignfileRead(var mystring, myfilename: string); //v3.1
begin
  AssignFile(fx, myfilename);
  {$I-}
  ReSet(fx);
  {$I+}
  if IOResult = 0 then begin
    ReadLN(fx, mystring);
    CloseFile(fx);
  end;
end;


function myreset(mypath: string): TStringList; //v2.9.1
var mylist: TStringList;
    mystr: string;
begin
  mylist:= TStringList.Create;
  AssignFile(f, mypath);
  Reset(f);
  while not EOF(f) do begin
    ReadLN(f,mystr);
    mylist.Add(mystr)
  end;
  result:= mylist;
  CloseFile(f);
  //mylist.Free;    //bug 3.9.3
end;

procedure myVal(const s: string; var n, z: Integer);
begin
  Val(s, n, z);
end;

function myMessageBox2(hndl: cardinal; text,caption: PAnsiChar; utype: cardinal): Integer;
begin
  result:= MessageBox(hndl, text, caption, utype);
end;

procedure mySucc(X: int64);
begin
  succ(X);
end;

procedure myPred(X: int64);
begin
  pred(X);
end;

procedure myprintf(const aformat: String; const args: array of const);
begin
  MyWriteln(Format(aformat, args));    //also FormatLn
end;

procedure myprintfW(const aformat: String; const args: array of const);
begin
  MyWrite(Format(aformat, args));    //also FormatLn
end;


function myscanf(const aformat: String; const args: array of const): string;
begin
  result:= MyReadln(Format(aformat, args));    //also FormatLn
end;

function myStrToBytes(const Value: String): TBytes;
var i: integer;
begin
  SetLength(result, Length(Value));
  for i:= 0 to Length(Value)-1 do
    result[i]:= Ord(Value[i+1])- 48;    //-48
end;


function myBytesToStr(const Value: TBytes): String;
var I: integer;
    Letra: char;
begin
  result:= '';
  for I:= Length(Value)-1 Downto 0 do begin
    letra:= Chr(Value[I] + 48);
    result:= letra + result;
  end;
end;


procedure SwapChar(var X,Y: char);
var tmp: char;
begin
 tmp:= x;
 x:= y;
 y:= tmp;
end;

procedure TestWebService;
var rio: THTTPRIO;
    WS: IVCLScanner;
begin
    RIO:= THTTPRIO.Create(NIL);
     ws:= (RIO as IVCLScanner);
end;

function keypressed2: boolean;
begin
  result:= maxform1.fkeypressed;
  //iskeypressed
end;



// how to add function into the engine:
{procedure TPSPascalCompiler.DefineStandardProcedures;
  in upscompiler.pas --- line 11618
 AddFunction('function max(a: integer; b: integer): integer;');
  in upsruntime.pas ---
  procedure TPSExec.RegisterStandardProcs; line 8183
 RegisterFunctionName('MAX', DefProc, Pointer(50), nil);
 function DefProc(Caller: TPSExec; p: TPSExternalProcRec; Global, Stack:
                                                TPSStack): Boolean;
  put function on the stack and calls pointer at runtime ?? line 7924
  50: Stack.SetInt(-1, Max(Stack.GetInt(-2), Stack.GetInt(-3)));// max
 }

procedure TMaxForm1.PSScriptCompile(Sender: TPSScript);
//var s: TSearchRec;
begin
  //AddTypeS('TThreadFunction','TThreadFunction = function(P: Pointer): Longint; stdcall)');
  Sender.AddFunction(@MyWriteln, 'procedure Writeln(s: string);');
  Sender.AddFunction(@MyWriteln, 'procedure Println(s: string);');  //alias
  Sender.AddFunction(@MyWrite, 'procedure Write(S: string);');
  Sender.AddFunction(@MyReadln, 'function Readln(question: string): string;');
  Sender.AddFunction(@ImportTest, 'function ImportTest(S1: string;'+
                     's2:longint; s3:Byte; s4:word; var s5:string): string;');
  // new self function
  Sender.AddFunction(@Random, 'function Random(const ARange: Integer): Integer;');
  Sender.AddFunction(@Random, 'function Rand(const ARange: Integer): Integer;');
  Sender.AddFunction(@myRandomE, 'function RandomE: Extended;');
  Sender.AddFunction(@myRandomE, 'function RandomF: Extended;');
  Sender.AddFunction(@myrandom2, 'function random2(a: integer): double');
  Sender.AddFunction(@myMessageBox, 'procedure showmessage(mytext: string);');
  Sender.AddFunction(@myASCtoChar, 'function ChrA(const a: byte): char;');
  Sender.AddFunction(@Randomize, 'procedure randomize;');
  Sender.AddFunction(@Sleep, 'procedure sleep(milliseconds: cardinal);');
  //Sender.AddFunction(@myInc, 'procedure Inc(var x: longint);');
  Sender.AddFunction(@myIncb, 'procedure Incb(var x: byte);');
  //Sender.AddFunction(@myDec, 'procedure Dec(var x: longint);');
  Sender.AddFunction(@myfindFirst, 'function Findfirst(const filepath: string; attr: integer): integer;');
  Sender.AddFunction(@myfindNext, 'function FindNext: integer;');
  Sender.AddFunction(@myfindClose, 'procedure FindClose;');
  Sender.AddFunction(@mySearchRecName, 'function SearchRecname: string;');
  Sender.AddFunction(@mySearchRecSize, 'function SearchRecsize: integer;');
  Sender.AddFunction(@mySearchRecAttr, 'function SearchRecattr: integer;');
  Sender.AddFunction(@mySearchRecTime, 'function SearchRecTime: integer;');
  Sender.AddFunction(@mySearchRecExcludeAttr, 'function SearchRecExcludeAttr: integer;');
  Sender.AddFunction(@myBeep, 'procedure Beep');
  //Sender.AddFunction(@myNow, 'function Now: string');
  Sender.AddFunction(@myNow2, 'function Now2: tDateTime');
  Sender.AddFunction(@FileExists, 'function fileExists(const FileName: string): Boolean;');
  Sender.AddFunction(@myShellExecute,'function ShellExecute(hWnd: HWND;' +
      'Operation, FileName, Parameters,Directory: string; ShowCmd: Integer): integer; stdcall;');
  Sender.AddFunction(@myShellExecute2,'function Shellexecute2(hwnd: HWND; const FileName: string):integer; stdcall;');
  Sender.AddFunction(@myBeep2, 'function beep2(dwFreq, dwDuration: integer): boolean;');
  Sender.AddFunction(@myWinExec, 'function winexec(FileName: pchar; showCmd: integer): integer;');
  Sender.AddFunction(@myAssert,'procedure Assert2(expr : Boolean; const msg: string);');
  Sender.AddFunction(@ExtractFileName,'function ExtractFileName(const filename: string):string;');
  Sender.AddFunction(@ExtractFilePath,'function ExtractFilePath(const filename: string):string;');
  Sender.AddFunction(@Max3,'function Max3(const x,y,z: Integer): Integer;');
  Sender.AddFunction(@Max,'function Max(const x,y: Integer): Integer;');
  Sender.AddFunction(@SwapChar,'procedure SwapChar(var X,Y: char);');
  Sender.AddFunction(@Shuffle,'procedure Shuffle(vQ: TStringList);');
  Sender.AddFunction(@CharToHexStr, 'function CharToHexStr(Value: char): string);');
  Sender.AddFunction(@HexToInt, 'function HexToInt(hexnum: string): LongInt;');
  //Sender.AddFunction(@IntToBin, 'function IntToBin(Int: Integer): String;'); in idglobal
  Sender.AddFunction(@BinToInt, 'function BinToInt(Binary: String): Integer;');
  Sender.AddFunction(@HexToBin2, 'function HexToBin2(HexNum: string): string;');
  Sender.AddFunction(@BinToHex2, 'function BinToHex2(Binary: String): string;');
  Sender.AddFunction(@HexStrToStr, 'function HexStrToStr(Value: string): string;');
  Sender.AddFunction(@HexStrToStr, 'function HexToStr(Value: string): string;');
  Sender.AddFunction(@UniCodeToStr, 'function UniCodeToStr(Value: string): string;');
  Sender.AddFunction(@CharToUniCode,'function CharToUniCode(Value: Char): string;');
  Sender.AddFunction(@ChartoOEM, 'function CharToOem(ins, outs: PChar):boolean;');
  Sender.AddFunction(@GetUserNameWin, 'Function GetUserName: string;');
  Sender.AddFunction(@playmp3,'procedure playmp3(mpath: string);');
  Sender.AddFunction(@stopmp3,'procedure stopmp3;');
  Sender.AddFunction(@closemp3,'procedure closemp3;');
  Sender.AddFunction(@lengthmp3,'function lengthmp3(mp3path: string):integer;');
  Sender.AddFunction(@ExePath, 'function ExePath: string;');
  Sender.AddFunction(@MaxPath, 'function MaxPath: string;');
  Sender.AddFunction(@MaxPath, 'function ExePathName: string;');
  Sender.AddFunction(@constrain, 'function constrain(x, a, b: integer): integer;');
  Sender.AddFunction(@myassign,'procedure Assign2(mystring, mypath: string);');
  Sender.AddFunction(@myreset,'function Reset2(mypath: string): TStringlist;');
  Sender.AddFunction(@myassignfileWrite,'procedure AssignFileWrite(mystring, myfilename: string);');
  Sender.AddFunction(@myassignfileRead,'procedure AssignFileRead(var mystring, myfilename: string);');
  Sender.AddFunction(@NormalizeRect,'function NormalizeRect(const Rect: TRect): TRect;');
  Sender.AddFunction(@Diff,'procedure Diff(var X: array of Double);');
  Sender.AddFunction(@PointDist,'function PointDist(const P1,P2: TFloatPoint): Double;');
  Sender.AddFunction(@PointDist2,'function PointDist2(const P1,P2: TPoint): Double;');
  Sender.AddFunction(@RotatePoint,'function RotatePoint(Point: TFloatPoint; const Center: TFloatPoint; const Angle: Double): TFloatPoint;');
  Sender.AddFunction(@Gauss,'function Gauss(const x,Spread: Double): Double;');
  Sender.AddFunction(@VectorAdd,'function VectorAdd(const V1,V2: TFloatPoint): TFloatPoint;');
  Sender.AddFunction(@VectorSubtract,'function VectorSubtract(const V1,V2: TFloatPoint): TFloatPoint;');
  Sender.AddFunction(@VectorDot,'function VectorDot(const V1,V2: TFloatPoint): Double;');
  Sender.AddFunction(@VectorLengthSqr,'function VectorLengthSqr(const V: TFloatPoint): Double;');
  Sender.AddFunction(@VectorMult,'function VectorMult(const V: TFloatPoint; const s: Double): TFloatPoint;');
  //Sender.AddFunction(@myreset,'function Reset2(mypath: string):string;');
  Sender.AddFunction(@myVal, 'procedure Val(const s: string; var n, z: Integer)');
  Sender.AddFunction(@searchAndOpenDoc, 'procedure SearchAndOpenDoc(vfilenamepath: string)');
  Sender.AddFunction(@searchAndOpenDoc, 'procedure SearchAndOpenFile(vfilenamepath: string)');
  Sender.AddFunction(@searchAndOpenDoc, 'procedure OpenFile(vfilenamepath: string)');
  Sender.AddFunction(@ExecuteCommand, 'Procedure ExecuteCommand(executeFile, paramstring: string)');
  Sender.AddFunction(@ExecuteCommand, 'Procedure ExecuteShell(executeFile, paramstring: string)');
  Sender.AddFunction(@ExecConsoleApp,'function ExecConsoleApp(const AppName, Parameters: String; AppOutput: TStrings): boolean;');
  Sender.AddFunction(@myGetDriveType,'function GetDriveType(rootpath: pchar): cardinal;');
  Sender.AddFunction(@myprocMessOFF, 'procedure ProcessMessagesOff;');
  Sender.AddFunction(@myprocMessON, 'procedure ProcessMessagesOn;');
  Sender.AddFunction(@myIncludeOFF, 'procedure IncludeOFF;');
  Sender.AddFunction(@myIncludeON, 'procedure IncludeON;');
  Sender.AddFunction(@Speak, 'procedure Speak(const sText: string)');
  Sender.AddFunction(@Speak, 'procedure Voice(const sText: string)');
  Sender.AddFunction(@Speak, 'procedure Say(const sText: string)');
  Sender.AddFunction(@Speak, 'procedure Sayln(const sText: string)');
  Sender.AddFunction(@Speak2, 'procedure Speak2(const sText: string)');
  Sender.AddFunction(@Speak2, 'procedure Voice2(const sText: string)');
  Sender.AddFunction(@Speak2, 'procedure Say2(const sText: string)');
  Sender.AddFunction(@Speak2, 'procedure Talkln(const sText: string)');
  //Sender.AddFunction(@Sendln, 'procedure Sendln(const sText: string)');

  Sender.AddFunction(@SendEmail,'procedure SendEmail(mFrom, mTo,mSubject,mBody,mAttachment: variant);');
  Sender.AddFunction(@SendEmail,'procedure Sendmail(mFrom, mTo,mSubject,mBody,mAttachment: variant);');
  Sender.AddFunction(@SendEmail,'procedure Sendeln(mFrom, mTo,mSubject,mBody,mAttachment: variant);');

  Sender.AddFunction(@ExecuteThread2, 'procedure ExecuteThread2(afunc: TThreadFunction2; thrOK: boolean)');
  Sender.AddFunction(@Move2, 'procedure Move2(const Source: TByteArray; var Dest: TByteArray; Count: Integer)');
  Sender.AddFunction(@SearchAndReplace,'procedure SearchAndReplace(aStrList: TStrings; aSearchStr, aNewStr: string)');
  Sender.AddFunction(@SearchAndCopy,'procedure SearchAndCopy(aStrList: TStrings; aSearchStr, aNewStr: string; offset: integer)');
  Sender.AddFunction(@GCD,'Function GCD(x, y : LongInt) : LongInt;');
  Sender.AddFunction(@LCM,'Function LCM(m,n:longint):longint;');
  Sender.AddFunction(@GetASCII,'Function GetASCII: string)');
  Sender.AddFunction(@GetItemHeight,'Function GetItemHeight(Font: TFont): Integer;'); //upsc_graphics
  Sender.AddFunction(@myMessageBox2,'Function MessageBox(hndl: cardinal; text, caption: string; utype: cardinal): Integer;');
  Sender.AddFunction(@myPlaySound, 'Function PlaySound(s: pchar; flag,syncflag: integer): boolean;');
  Sender.AddFunction(@myGetWindowsDirectory, 'function GetWindowsDirectory(lpBuffer: PChar; uSize: longword): longword;');
  Sender.AddFunction(@GetHINSTANCE, 'function GetHINSTANCE: longword;');
  Sender.AddFunction(@GetHINSTANCE, 'function HINSTANCE: longword;');
  Sender.AddFunction(@getHMODULE, 'function getHMODULE: longword;');
  Sender.AddFunction(@getHMODULE, 'function HMODULE: longword;');
  Sender.AddFunction(@GetAllocMemCount, 'function AllocMemCount: integer;');
  Sender.AddFunction(@GetAllocMemSize, 'function AllocMemSize: integer;');
  Sender.AddFunction(@getLongTimeFormat, 'function LongTimeFormat: string;');
  Sender.AddFunction(@getLongDateFormat, 'function LongDateFormat: string;');
  Sender.AddFunction(@getShortTimeFormat, 'function ShortTimeFormat: string;');
  Sender.AddFunction(@getShortDateFormat, 'function ShortDateFormat: string;');
  Sender.AddFunction(@getDateSeparator, 'function DateSeparator: char;');
  Sender.AddFunction(@getDecimalSeparator, 'function DecimalSeparator: char;');
  Sender.AddFunction(@getThousandSeparator, 'function ThousandSeparator: char;');
  Sender.AddFunction(@getTimeSeparator, 'function TimeSeparator: char;');
  Sender.AddFunction(@getListSeparator, 'function ListSeparator: char;');
  //Sender.AddFunction(@GetHinstance, 'function GetHINSTANCE: longword;');
  Sender.AddFunction(@ExeFileIsRunning, 'function ExeFileIsRunning(ExeFile: string): boolean;');
  Sender.AddFunction(@myFindWindow, 'function FindWindow(C1, C2: PChar): Longint;');
  Sender.AddFunction(@myFindControl, 'function FindControl(handle: Hwnd): TWinControl;');
   Sender.AddFunction(@myShowWindow, 'function ShowWindow(C1: HWND; C2: integer): boolean;');
  Sender.AddFunction(@RegistryRead, 'Function RegistryRead(keyHandle: Longint; keyPath, myField: String): string;');
  Sender.AddFunction(@GetNumberOfProcessors, 'function GetNumberOfProcessors: longint;');
  Sender.AddFunction(@GetPageSize, 'function GetPageSize: Cardinal;');
  Sender.AddFunction(@PrintBitmap, 'procedure PrintBitmap(aGraphic: TGraphic; Title: string);');
  //Sender.AddFunction(@ReadVersion2,'procedure ReadVersion(aFileName: STRING; aVersion : TStrings);');
  Sender.AddFunction(@ReadVersion,'function ReadVersion(aFileName: STRING; aVersion : TStrings): boolean;');
  //Sender.AddFunction(@GetFileVersion,'function GetFileVersion(Filename: String): String;');
  Sender.AddFunction(@StringPad,'Function StringPad(InputStr,FillChar: String; StrLen:Integer; StrJustify:Boolean): String;');
  Sender.AddFunction(@MinimizeMaxbox, 'Procedure MinimizeMaxbox;');
  Sender.AddFunction(@MinimizeMaxbox, 'Procedure MinimizeWindow;');
  Sender.AddFunction(@SaveCanvas2, 'procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);');
  Sender.AddFunction(@SaveCanvas2, 'procedure SaveCanvas(vCanvas: TCanvas; FileName: string);');
   //Sender.AddFunction(@DrawPlot, 'procedure drawPlot(vPoints: TPointArray; cFrm: TForm; vcolor: integer);');
  Sender.AddFunction(@mysucc, 'procedure Succ(X: int64);');
  Sender.AddFunction(@mypred,'procedure Pred(X: int64);');
  Sender.AddFunction(@PopupURL,'Procedure PopupURL(URL : WideString);');
  Sender.AddFunction(@GetVersionString,'Function GetVersionString(FileName: string): string;');
  Sender.AddFunction(@LoadFilefromResource,'procedure LoadFilefromResource(const FileName: string; ms: TMemoryStream);');
  Sender.AddFunction(@GetAssociatedProgram,'function GetAssociatedProgram(const Extension: string; var Filename, Description: string): boolean;');
  Sender.AddFunction(@FilesFromWildcard,'procedure FilesFromWildcard(Directory, Mask: string;'+
  'var Files : TStringList; Subdirs, ShowDirs, Multitasking: Boolean);');
  Sender.AddFunction(@Hi1,'function Hi(vdat: word): byte;'); //3.5
  Sender.AddFunction(@Lo1,'function Lo(vdat: word): byte;'); //3.5
  Sender.AddFunction(@BinominalCoefficient,'function BinominalCoefficient(n, k: Integer): string;');
  Sender.AddFunction(@FormatInt64,'FUNCTION FormatInt64(i: int64): STRING;');
  Sender.AddFunction(@FormatInt,'FUNCTION FormatInt(i: integer): STRING;');
  Sender.AddFunction(@FormatBigInt,'FUNCTION FormatBigInt(s: string): STRING;');
  Sender.AddFunction(@ComputeFileCRC32, 'function ComputeFileCRC32(const FileName : String) : Integer;');
  Sender.AddFunction(@myprintf, 'procedure printf(const format: String; const args: array of const);');
  Sender.AddFunction(@myprintfw, 'procedure printfw(const format: String; const args: array of const);');
  Sender.AddFunction(@myprintf, 'procedure FormatLn(const format: String; const args: array of const);');  //alias
  Sender.AddFunction(@myscanf, 'function scanf(const aformat: String; const args: array of const): string;');
  Sender.AddFunction(@getHexArray,'function GetHexArray(ahexdig: THexArray): THexArray;');
  Sender.AddFunction(@CharToHex,'Function CharToHex(const APrefix : String; const cc : Char) : shortstring;');
  Sender.AddFunction(@GetMultiN,'Function GetMultiN(aval: integer): string;');
  Sender.AddFunction(@PowerBig,'Function PowerBig(aval, n:integer): string;');  //n^n (see up in this script)
  Sender.AddFunction(@Split,'procedure Split(Str: string;  SubStr: string; List: TStrings);');
  Sender.AddFunction(@Combination,'Function Combination(npr, ncr: integer): extended;');
  Sender.AddFunction(@Permutation, 'function Permutation(npr, k: integer): extended;');
  Sender.AddFunction(@CombinationInt,'Function CombinationInt(npr, ncr: integer): Int64;');
  Sender.AddFunction(@PermutationInt, 'function PermutationInt(npr, k: integer): Int64;');
  Sender.AddFunction(@MD5,'function MD5(const fileName: string): string;');
  Sender.AddFunction(@SHA1,'function SHA1(const fileName: string): string;');
  Sender.AddFunction(@CRC32H,'function CRC32(const fileName: string): LongWord;');
  Sender.AddFunction(@getCmdLine,'function CmdLine: PChar;');
  Sender.AddFunction(@getCmdShow,'function CmdShow: Integer;');
  Sender.AddFunction(@getCmdLine,'function getCmdLine: PChar;');
  Sender.AddFunction(@getCmdShow,'function getCmdShow: Integer;');
  Sender.AddFunction(@FindComponent1,'function FindComponent(vlabel: string): TComponent;');
  Sender.AddFunction(@FindComponent2,'function FindComponent2(vlabel: string): TComponent;');
  Sender.AddFunction(@IsFormOpen,'Function IsFormOpen(const FormName: string): Boolean;');
  Sender.AddFunction(@IsInternet,'Function IsInternet: boolean;');
  Sender.AddFunction(@IsInternet,'Function WebExists: boolean;');   //alias
  Sender.AddFunction(@VersionCheck,'function VersionCheck: boolean;');
  Sender.AddFunction(@TimeToFloat,'function TimeToFloat(value:Extended):Extended;');
  Sender.AddFunction(@FloatToTime,'function FloatToTime(value:Extended):Extended;');
  Sender.AddFunction(@FloatToTime2Dec,'function FloatToTime2Dec(value:Extended):Extended;');
  Sender.AddFunction(@MinToStd,'function MinToStd(value:Extended):Extended;');
  Sender.AddFunction(@MinToStdAsString,'function MinToStdAsString(value:Extended):String;');
  Sender.AddFunction(@RoundFloatToStr,'function RoundFloatToStr(zahl:Extended; decimals:integer):String;');
  Sender.AddFunction(@RoundFloat,'function RoundFloat(zahl:Extended; decimals:integer):Extended;');
  Sender.AddFunction(@Round2Dec,'function Round2Dec(zahl:Extended):Extended;');
  Sender.AddFunction(@GetAngle,'function GetAngle(x,y:Extended):Double;');
  Sender.AddFunction(@AddAngle,'function AddAngle(a1,a2:Double):Double;');
  Sender.AddFunction(@MovePoint,'procedure MovePoint(var x,y:Extended; const angle:Extended);');
  Sender.AddFunction(@microsecondsToCentimeters,'function microsecondsToCentimeters(mseconds: longint): longint;');
  Sender.AddFunction(@mytimegettime,'function timegettime: int64;');
  Sender.AddFunction(@mytimegettime,'function millis: int64;');
  Sender.AddFunction(@mytimegetsystemtime,'function timegetsystemtime: int64;');
  Sender.AddFunction(@GetCPUSpeed,'function GetCPUSpeed: Double;');
  Sender.AddFunction(@IsWoW64,'function IsWoW64: boolean;');
  Sender.AddFunction(@IsWoW64,'function IsWin64: boolean;');
  Sender.AddFunction(@IsWow64String,'function IsWow64String(var s: string): Boolean;');
  Sender.AddFunction(@IsWow64String,'function IsWin64String(var s: string): Boolean;');
  Sender.AddFunction(@RGB,'Function RGB(R,G,B: Byte): TColor;');
  Sender.AddFunction(@Sendln,'Function Sendln(amess: string): boolean;');
  //Sender.AddFunction(@GetSource,'function GetSource: string;');
  Sender.AddFunction(@maXbox,'procedure maXbox;');
  Sender.AddFunction(@AspectRatio,'Function AspectRatio(aWidth, aHeight: Integer): String;');
  Sender.AddFunction(@wget,'function wget(aURL, afile: string): boolean;');
  Sender.AddFunction(@PrintList,'procedure PrintList(Value: TStringList);');
  Sender.AddFunction(@PrintImage,'procedure PrintImage(aValue: TBitmap; Style: TBitmapStyle);');
  Sender.AddFunction(@getEnvironmentInfo,' procedure getEnvironmentInfo;');
  Sender.AddFunction(@getEnvironmentString,'function getEnvironmentString: string;');
  Sender.AddFunction(@antiFreeze,' procedure antiFreeze;');
  Sender.AddFunction(@getBitmap,'function getBitmap(apath: string): TBitmap;');
  Sender.AddFunction(@ShowMessageBig,'procedure ShowMessageBig(const aText : string);');
  Sender.AddFunction(@ShowMessageBig,'procedure msgbig(const aText : string);');
  Sender.AddFunction(@ShowMessageBig2,'procedure ShowMessageBig2(const aText : string; aautosize: boolean);');
  Sender.AddFunction(@ShowMessageBig3,'procedure ShowMessageBig3(const aText : string; fsize: byte; aautosize: boolean);');

  Sender.AddFunction(@SetArrayLength2String,'procedure SetArrayLength2String(arr: T2StringArray; asize1, asize2: integer);');
  Sender.AddFunction(@SetArrayLength2Integer,'procedure SetArrayLength2Integer(arr: T2IntegerArray; asize1, asize2: integer);');
  Sender.AddFunction(@SaveAsExcelFile,'function SaveAsExcelFile(AGrid: TStringGrid; ASheetName, AFileName: string; open: boolean): Boolean;');
  Sender.AddFunction(@SaveAsExcelFile,'function SaveAsExcel(aGrid: TStringGrid; aSheetName, aFileName: string; openexcel: boolean): Boolean;');
  Sender.AddFunction(@YesNoDialog,'function YesNoDialog(const ACaption, AMsg: string): boolean;');
  Sender.AddFunction(@myStrToBytes,'function StrToBytes(const Value: String): TBytes;');
  Sender.AddFunction(@myBytesToStr,'function BytesToStr(const Value: TBytes): String;');
  Sender.AddFunction(@ReverseDNSLookup,'function ReverseDNSLookup(const IPAddress:String; const DNSServer:String; Timeout,Retries:Integer; var HostName:String):Boolean;');
  Sender.AddFunction(@FindInPaths,'function FindInPaths(const fileName,paths: String): String;');
  Sender.AddFunction(@initHexArray,'procedure initHexArray(var hexn: THexArray);');
  Sender.AddFunction(@josephusG,'function josephusG(n,k: integer; var graphout: string): integer;');
  Sender.AddFunction(@isPowerof2,'function isPowerof2(num: int64): boolean;');
  Sender.AddFunction(@powerOf2,'function powerOf2(exponent: integer): int64;');
  Sender.AddFunction(@getBigPI,'function getBigPI: string;');
  Sender.AddFunction(@getBigPI,'function BigPI: string;');
  Sender.AddFunction(@MakeSound,'procedure MakeSound(Frequency,Duration: Integer; Volume: Byte; savefilePath: string);');
  Sender.AddFunction(@GetASCIILine,'function GetASCIILine: string;');
  Sender.AddFunction(@MakeComplexSound,'procedure MakeComplexSound(N:integer;freqlist:TStrings; Duration{mSec}: Integer; pinknoise: boolean; Volume: Byte);');
  Sender.AddFunction(@SetComplexSoundElements,'procedure SetComplexSoundElements(freqedt,Phaseedt,AmpEdt,WaveGrp:integer);');
  Sender.AddFunction(@AddComplexSoundObjectToList,'procedure AddComplexSoundObjectToList(newf,newp,newa,news:integer; freqlist: TStrings);');
  Sender.AddFunction(@ListDLLExports,'procedure ListDLLExports(const FileName: string; List: TStrings);');
  Sender.AddFunction(@mapfunc,'function map(ax, in_min, in_max, out_min, out_max: integer): integer;');
  Sender.AddFunction(@mapmax,'function mapmax(ax, in_min, in_max, out_min, out_max: integer): integer;');
  Sender.AddFunction(@Keypressed2,'function isKeypressed: boolean;');
  Sender.AddFunction(@Keypressed2,'function Keypress: boolean;');
  Sender.AddFunction(@StrSplitP,'procedure StrSplitP(const Delimiter: Char; Input: string; const Strings: TStrings);');
  Sender.AddFunction(@ReadReg,'function ReadReg(Base: HKEY; KeyName, ValueName: string): string;');
  Sender.AddFunction(@ReadReg,'function ReadRegistry(Base: HKEY; KeyName, ValueName: string): string;');
  Sender.AddFunction(@GetOSName,'function GetOSName: string;');
  Sender.AddFunction(@GetOSVersion,'function GetOSVersion: string;');
  Sender.AddFunction(@GetOSNumber,'function GetOSNumber: string;');
  Sender.AddFunction(@StrReplace,'procedure StrReplace(var Str: String; Old, New: String);');
  Sender.AddFunction(@getTeamViewerID, 'function getTeamViewerID: string;');

  Sender.AddFunction(@StartFileFinder3,'procedure StartFileFinder3(spath, aext, searchstr: string; arecursiv: boolean; reslist: TStringlist);');
  Sender.AddFunction(@StartFileFinder3,'procedure Grep(spath, aext, searchstr: string; arecursiv: boolean; reslist: TStringlist);');
  Sender.AddFunction(@RecurseDirectory,'Procedure RecurseDirectory(Dir: String; IncludeSubs : boolean; callback : TFileCallbackProcedure);');
  Sender.AddFunction(@RecurseDirectory2,'Procedure RecurseDirectory2(Dir: String; IncludeSubs : boolean);');

   //Sender.AddFunction(@mmsystem32.timegettime
  //Sender.AddFunction(@AssignFile,'Procedure AssignFile(var F: Text; FileName: string)');
  //Sender.AddFunction(@CloseFile,'Procedure CloseFile(var F: Text);');
  Sender.AddRegisteredVariable('Application', 'TApplication');
  Sender.AddRegisteredVariable('Screen', 'TScreen');
  Sender.AddRegisteredVariable('Self', 'TForm');
  Sender.AddRegisteredVariable('Memo1', 'TSynMemo');
  Sender.AddRegisteredVariable('memo2', 'TMemo');
  Sender.AddRegisteredVariable('maxForm1', 'TMaxform1');  //!!
  Sender.AddRegisteredVariable('debugout', 'Tdebugoutput');  //!!
  //Sender.AddRegisteredVariable('maxForm1', 'TMaxForm1');
  //Sender.AddRegisteredVariable('stringgrid1', 'TStringGrid');
  //sender.AddRegisteredVariable('puzObj','TWinFormp');
  //sender.AddRegisteredVariable('HexDigits','THexArray');
   //sender.addregisteredconst(
end;


procedure TMaxForm1.Expand_Macro;
var fpath, fname: string;
begin
 //        output.Lines.add('Host Name: '+getComputerNameWin);
 //       output.Lines.add('User Name: '+getUserNameWin);
  fpath:=  extractFilePath(Act_Filename);
  fname:=  extractFileName(Act_Filename);
  // Dir := ExtractFilePath(ParamStr(0)) + '\lib';

  SearchAndCopy(memo1.lines, '<TIME>', timetoStr(time), 6);
  SearchAndCopy(memo1.lines, '<DATE>', datetoStr(date), 6);
  SearchAndCopy(memo1.lines, '<PATH>', fpath, 6);
  SearchAndCopy(memo1.lines, '<EXEPATH>', EXEPath, 9);
  SearchAndCopy(memo1.lines, '<FILE>', fname, 6);
  SearchAndCopy(memo1.lines, '<SOURCE>', ExePath+'Source', 8);

  SearchAndCopy(memo1.lines, '#name', getUserNameWin, 11);
  SearchAndCopy(memo1.lines, '#date', datetimetoStr(now), 11);
  SearchAndCopy(memo1.lines, '#host', getComputernameWin, 11);
  SearchAndCopy(memo1.lines, '#path', fpath, 11);
  SearchAndCopy(memo1.lines, '#file', fname, 11);
  SearchAndCopy(memo1.lines, '#fils', fname +' '+SHA1(Act_Filename), 11);
  SearchAndCopy(memo1.lines, '#locs', intToStr(getCodeEnd), 11);
  SearchAndCopy(memo1.lines, '#head',Format('%s: %s: %s %s ',
       [getUserNameWin, getComputernameWin, datetimetoStr(now), Act_Filename]), 11);
  SearchAndCopy(memo1.lines, '#perf', perftime, 11);
  SearchAndCopy(memo1.lines, '#sign',Format('%s: %s: %s ',
       [getUserNameWin, getComputernameWin, datetimetoStr(now)]), 11);
  SearchAndCopy(memo1.lines, '#tech',Format('perf: %s threads: %d %s %s %s',
       [perftime, numprocessthreads, getIPAddress(getComputerNameWin), timetoStr(time),mbversion]), 11);

  memo2.Lines.Add('Macro Expanded '+inttostr(memo1.Lines.count-1)+' lines');
end;

procedure TMaxForm1.PSScriptExecute(Sender: TPSScript);
begin
  PSScript.SetVarToInstance('APPLICATION', Application);
  PSScript.SetVarToInstance('SCREEN', SCREEN);
  PSScript.SetVarToInstance('SELF', Self);
  //PSScript.SetPointerToData('Memo1', @Memo1, PSScript.FindNamedType('TSynMemo'));
  PSScript.SetVarToInstance('memo1', memo1);
  PSScript.SetVarToInstance('memo2', memo2);
  PSScript.SetVarToInstance('maxForm1', maxForm1);
  PSScript.SetVarToInstance('debugout', debugout);
  //PSScript.SetPointerToData('maxForm1', @maxForm1, PSScript.FindNamedType('TMaxForm1'));
  //PSScript.SetVarToInstance('stringgrid1', stringgrid1);
end;

// facade and mediator pattern
procedure TMaxForm1.Compile1Click(Sender: TObject);
var mybytecode: string;
    stopw: TStopwatch;
    //debugoutform: TDebugoutput //static;
  procedure OutputMessages;
  var
    l: Longint;
    b: Boolean;
    m: string;
  begin
    b:= False;
    if STATSavebefore then
      if fileexists(Act_Filename) then
        Save2Click(sender)
      else
        showMessage('Load Pascal Script first or - File Open/Save...');
    for l:= 0 to PSScript.CompilerMessageCount - 1 do begin
      m:= psscript.CompilerMessages[l].MessageToString;
      memo2.Lines.Add('PSXCompiler: '+PSScript.CompilerErrorToStr(l)+#13#10 +m);
      if (not b) and (PSScript.CompilerMessages[l] is TIFPSPascalCompilerError)
      then begin
        b:= True;
        memo1.SelStart:= PSScript.CompilerMessages[l].Pos;
      end;
    end
  end;
begin
  memo2.Lines.Clear;
  imglogo.Transparent:= false;
  stopw:= TStopwatch.Create;    //3.8.2
  stopw.Start;
  fkeypressed:= false;  //3.9.9.1
  lineToNumber(false);
  Slinenumbers1.Checked:= false;
  PSScript.MainFileName:= Act_Filename;
  PSScript.Script.Assign(memo1.Lines);
  cedebug.MainFileName:= Act_Filename;
  cedebug.Script.Assign(memo1.Lines);
  //showmessage(psscript.script.Text);
  memo2.Lines.Add('Compiling '+RCSTRMB +inttostr(memo1.Lines.count-1)+' lines');
  //TPSPascalCompiler transforms to bytecode
  memo2.Lines.Add('Codelines in window: '+inttoStr(memo1.LinesInWindow));
  statusBar1.panels[1].text:= 'Codelines window: '+inttoStr(memo1.LinesInWindow);
  //PSScript.Comp.OnUses:= '';    units
  maxForm1.Caption:= 'maXbox3 Sol mX4  '+ExtractFilename(Act_Filename);
   //if pos('#', memo1.lines) > 0 then
    if STATMacro then
        Expand_Macro;

  if STATCodefolding then            //new4
     memo1.ReScanForFoldRanges;

  if PSScript.Compile then begin
    OutputMessages;
    memo2.Lines.Add(RCSTRMB +extractFileName(Act_Filename)+' Compiled done: '
                                                         +dateTimetoStr(now()));
    memo2.Lines.Add('--------------------------------------------------------');
    statusBar1.panels[0].text:= RCSTRMB +Act_Filename+' Compiled done: '
             +dateTimetoStr(now())+'  Memory: '+inttoStr(GetMemoryLoad) +'% ';
    if not PSScript.Execute then begin
      memo1.SelStart := PSScript.ExecErrorPosition;
      memo2.Lines.Add(PSScript.ExecErrorToString +' at '+Inttostr(PSScript.ExecErrorProcNo)
                       +'.'+Inttostr(PSScript.ExecErrorByteCodePosition));
    end else begin
    stopw.Stop;
    memo2.Lines.Add(' mX3 executed: '+dateTimetoStr(Now())+
    '  Runtime: '+stopw.GetValueStr +'  Memoryload: '+inttoStr(GetMemoryLoad) +'% use');
    end;
    statusBar1.panels.items[1].text:= ' Runtime: '+stopw.GetValueStr+' Threads: '+intToStr(numprocessthreads);
    perftime:= stopw.GetValueStr;
    stopw.Free;
     //debug test
  //end; //stopwatch
    memo2.Lines.add(PSScript.About);
    if formOutput1.Checked then begin    //V3.5.1
    if NOT fdebuginst then begin
       debugoutform:= TDebugoutput.create(self);
       fdebuginst:= true;
    end;
    with debugoutForm do begin
      output.color:= clyellow;
      output.Font.Name:= RCPRINTFONT;
      output.Font.Style:= [fsbold];
      output.font.size:= memo2.Font.Size+2;
      output.ReadOnly:= false; 
      width:= memo2.Width;
      height:= memo2.Height;
      caption:= 'Form Output of Console';
      //output.font.size:= memo2.font.size;
      Show;
      output.lines:= memo2.Lines;
      output.lines.Add('Form Out at '+ DateTimeToStr(Now));
      //SendMessage(output.Handle, EM_GETFIRSTVISIBLELINE, 0 , 0 );
      //Show;
      statusBar1.panels[1].text:= 'Form Active Lines: '+inttoStr(memo2.Lines.count-1);
      end
    end;

    if STATShowBytecode then begin
      mybytecode:= '';
      //PSScript.Comp.OnUses:= IFPS3ClassesPlugin1CompImport;
      PSScript.GetCompiled(mybytecode);   //compiler.getOutput
      psscript.Comp.GetOutput(mybytecode);
      showAndSaveBCode(mybytecode);
      statusBar1.panels[1].text:= 'ByteCode Saved: '+mybytecode;
    end;
    imglogo.Transparent:= true;
    //mybytecode:= 'memo2.Lines.Add(PSScript.ExecErrorToString +';
    //memo1.lines.add(mybytecode);
    //call to macro    3.9.8.9

    memo1.Hint:= intToStr(memo1.CaretY)+' Cursor: '+memo1.WordAtCursor +' Mouse: '+memo1.WordAtMouse;

  end else begin
    OutputMessages;
    memo2.Lines.Add('Compiling Script failed');
  end;
  //TestWebService;   //Test WS
  //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
  //CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
   if intfnavigator1.checked then begin
     IntfNavigator1Click(Self);
     IntfNavigator1Click(Self);
    end;
      SetInterfacesMarks2(Act_Filename);   //3.9.9.7
     //call to macro
end;


procedure TMaxForm1.RubySyntax1Click(Sender: TObject);
begin
  with RubySyntax1 do
    checked:= NOT checked;
  if RubySyntax1.Checked then begin
    memo1.Highlighter:= SynRubySyn1;
    RubySyntax1.Caption:= 'Pascal Syntax';
    memo2.Lines.Add('RubySyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      RubySyntax1.Caption:= 'Ruby Syntax';
    end;
end;

function TMaxForm1.RunCompiledScript(bytecode: ansistring; out RTErrors: string): boolean;
begin
 //psscript.LoadExec;
 //result:= psscript.Exec.LoadData(bytecode);
 result:= psscript.Exec.LoadData(bytecode)
    and psscript.Exec.RunScript and (psscript.Exec.ExceptionCode = erNoError);
 if not result then RTErrors:= PSErrorToString(psscript.Exec.ExceptionCode,'');
 //psscript.RuntimeImporter.CreateAndRegister(psscript,false);
end;

function TMaxForm1.RunCompiledScript2(Bytecode: AnsiString; out RuntimeErrors: AnsiString): Boolean;
var
  Runtime: TPSExec;
  ClassImporter: TPSRuntimeClassImporter;
begin
  Runtime := TPSExec.Create;
  ClassImporter := TPSRuntimeClassImporter.CreateAndRegister(Runtime, false);
  try
    //ExtendRuntime(Runtime, ClassImporter);
    //IFPS3ClassesPlugin1ExecImport(Self, runtime, classImporter);
  //x: TIFPSRuntimeClassImporter);
    Result:= Runtime.LoadData(Bytecode)
          and Runtime.RunScript
          and (Runtime.ExceptionCode = erNoError);
    if not Result then
      RuntimeErrors:=  PSErrorToString(Runtime.LastEx, '');
  finally
    ClassImporter.Free;
    Runtime.Free;
  end;
end;


procedure TMaxForm1.LoadBytecode1Click(Sender: TObject);
var bcerrorcode: string;
begin
 with TOpenDialog.Create(self) do begin
    Filter:= 'ByteCode files (*.psb)|*.PSB';
    FileName:= '*.psb';
    defaultExt:= fileextension;
    title:= 'PascalScript ByteCode Open';
    InitialDir:= ExtractFilePath(application.ExeName)+'*.psb';
    if execute then begin
         if MessageDlg(RCSTRMB+': Run ByteCode now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
         if RunCompiledScript2(Filename, bcerrorcode) then begin
            sysutils.beep;
            showmessage('Byte Code run success')
         end else
      Memo2.lines.add('ByteCode Error Message: '+bcerrorcode); //end else
    end;
  //this open and free
    Free;
  end;
end;


procedure TMaxForm1.mnConsole2Click(Sender: TObject);
begin
  mnConsole2.Checked:= not mnConsole2.Checked;
  memo2.Visible:= mnConsole2.Checked;
//console  , output or shell
end;

procedure TMaxForm1.mnCoolbar2Click(Sender: TObject);
begin
  mnCoolbar2.Checked:= not mnCoolbar2.Checked;
  Coolbar1.Visible:= mnCoolbar2.Checked;
end;

procedure TMaxForm1.mnSplitter2Click(Sender: TObject);
begin
  mnSplitter2.Checked:= not mnSplitter2.Checked;
  Splitter1.Visible:= mnSplitter2.Checked;
end;

procedure TMaxForm1.mnStatusbar2Click(Sender: TObject);
begin
  mnStatusBar2.Checked:= not mnStatusBar2.Checked;
  StatusBar1.Visible:= mnStatusBar2.Checked;
//status in menu view
end;

procedure TMaxForm1.mnToolbar1Click(Sender: TObject);
begin
  mnToolBar1.Checked:= not mnToolBar1.Checked;
  ControlBar1.Visible:= mnToolbar1.Checked;
  //toolbar in view
end;

procedure TMaxForm1.open1Click(Sender: TObject);
begin
  with TOpenDialog.Create(self) do begin
    Filter:= PSTEXT + '|' + PSMODEL + '|' + PSPASCAL + '|' + PSINC;
    //Filter:= 'Text files (*.txt)|*.TXT|Model files (*.uc)|*.UC';
    FileName:= '*.txt';
    defaultExt:= fileextension;
    title:= 'PascalScript File Open';
    InitialDir:= ExtractFilePath(application.ExeName)+'*.txt';
    if execute then begin
      if STATedchanged then begin
         sysutils.beep;
         if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
         Save2Click(self)
      end else
        STATEdchanged:= false;
      memo1.Lines.LoadFromFile(FileName);
      last_fName:= Act_Filename;
      memo2.Lines.Add(extractFileName(last_fName) + BEFOREFILE);    //beta
      loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
      Act_Filename:= FileName;
      memo2.Lines.Add(FileName + FILELOAD);
      statusBar1.panels[0].text:= FileName + FILELOAD;
      //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
      CB1SCList.Items.Add((Act_Filename));   //3.9 wb
      CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
    //default action
    end else if fileexists(Def_FName) then
      if MessageDlg('WellCode, you want to load '+DEFFILENAME,
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
        memo1.Lines.LoadFromFile(Def_FName);
        memo2.Lines.Add(DEFFILENAME + FILELOAD);
        statusBar1.panels[0].text:= DEFFILENAME + FILELOAD;
        Act_Filename:= Def_FName;
      end else begin
        statusbar1.panels[0].text:= 'load DIALOG cancelled';  //beta
        exit;
      end;
      //raise Exception.Create('Brake File in '+RCSTRMB+':' +FileName);
    Free;
  end; //with
    if intfnavigator1.checked then begin
     IntfNavigator1Click(Self);
     IntfNavigator1Click(Self);
    end;
end;

procedure TMaxForm1.Saveas3Click(Sender: TObject);
begin
  with TSaveDialog.Create(self) do begin
    Filter:= PSTEXT + '|' + PSINC + '|' + PSPASCAL;
    //Filename:= '*.txt';
    {if Act_Filename <> '' then begin
      last_fName:= Act_Filename;
      memo2.Lines.Add(extractFileName(last_fName) + BEFOREFILE);    //beta
      loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
    end;}
    FileName:= Act_Filename;
    defaultExt:= fileextension;
    title:= 'maXbox_FileSave';
    if execute then begin
      if Act_Filename <> '' then begin            //bug 3.7 solved
        last_fName:= Act_Filename;
        memo2.Lines.Add(extractFileName(last_fName) + BEFOREFILE);    //beta
        loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
      end;
      InitialDir:= ExtractFilePath(FileName);
      memo1.Lines.SaveToFile(FileName);
      Act_Filename:= FileName;
      memo2.Lines.Add(FileName +' stored');
      statusBar1.panels[0].text:= FileName +' File stored';
      // add last file to the deffile
      SaveFileOptionsToIni(FileName);
      STATEdchanged:= false;
      statusBar1.panels[2].text:= ' S';
   //  CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
     CB1SCList.Items.Add((Act_Filename));   //3.8 wb    3.9.3
     CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
    end;
   Free;
  end
end;

procedure TMaxForm1.Save2Click(Sender: TObject);
begin
  if Act_Filename <> '' then begin
    memo1.Lines.SaveToFile(Act_Filename);
    memo2.Lines.Add(Act_Filename +' File stored');
    SaveFileOptionsToIni(Act_Filename);
    STATEdchanged:= false;
    statusBar1.panels[2].text:= ' S';
  end else
    Saveas3Click(sender);
end;

procedure TMaxForm1.Savebefore1Click(Sender: TObject);
begin
 Savebefore1.Checked:= not Savebefore1.Checked;
 if Savebefore1.Checked then STATSavebefore:= true else
   STATSavebefore:= false;
end;

procedure TMaxForm1.WebScanner1Click(Sender: TObject);
begin
  WebMapperDemoMainFrm:= TWebMapperDemoMainFrm.Create(Self);
  try
    WebMapperDemoMainFrm.ShowModal
  finally
    WebMapperDemoMainFrm.Free;
  end;
end;


procedure TMaxForm1.WebScannerDirect(urls: string);
begin
  WebMapperDemoMainFrm:= TWebMapperDemoMainFrm.Create(Self);
  try
    WebMapperDemoMainFrm.UrlEdit.Text:= urls;
    //WebMapperDemoMainFrm.RunFirst;
    WebMapperDemoMainFrm.ShowModal;
    //WebMapperDemoMainFrm.ParseBtnClick(self);
   finally
    WebMapperDemoMainFrm.Free;
  end;
end;


procedure TMaxForm1.WebServer1Click(Sender: TObject);
begin
  HTTPServerStartExecute(self);
  //ShowMessage('https server available in V4'+#13#10+
    //            'first example in: ..\examples\303_webserver');
 //start to webserver2
end;

procedure TMaxForm1.WMDROP_THEFILES(var message: TWMDROPFILES);
const
  MAXCHARS = 254;
var
  hDroppedFile: tHandle;
  bFilename: array[0..MAXCHARS] of char;
begin
   hDroppedFile:= message.Drop;
   //Put the file on a memo and check changes
   if STATedchanged then begin
     sysutils.beep;
     if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
       Save2Click(self)
     else begin
       STATEdchanged:= false;
       statusBar1.panels[2].text:= ' SM';
       memo2.Lines.Add('Change not saved '+bFileName);
     end;
   end;
   last_fName:= Act_Filename;
   memo2.Lines.Add(extractFileName(last_fName) + BEFOREFILE);    //beta
   loadLastfile1.Caption:= '&Load Last File' +': '+ extractFileName(last_fName);
   with Memo1 do begin
     Lines.clear;
     //Grab the name of a dropped file
     dragQueryFile(hDroppedFile, 0, @bFilename, sizeOf(bFilename));
     Lines.loadFromFile(StrPas(bFilename));
   end;
   Act_Filename:= bFilename;
   memo2.Lines.Add(bFileName + FILELOAD);
   statusBar1.panels[0].text:= bFileName +' drag&drop' +FILELOAD;
   //release memory.
   dragFinish(hDroppedFile );
   //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
   CB1SCList.Items.Add((Act_Filename));   //3.8 wb
   CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
   if intfnavigator1.checked then begin
     IntfNavigator1Click(Self);
     IntfNavigator1Click(Self);
    end;
   //if intfnavigator1.checked then LoadInterfaceList;
    //else      lbintflist.Free;
end;

procedure TMaxForm1.Largefont1Click(Sender: TObject);
begin
  Largefont1.checked:= not Largefont1.Checked;
  if Largefont1.Checked then begin
    memo1.Font.Size:= 14;
    memo2.Font.Size:= 14;
    last_fontsize:= 14;
    largeFont1.Caption:= 'Small Font';
  end else begin
    memo1.Font.Size:= 10;
    memo2.Font.Size:= 10;
    last_fontsize:= 10;
    largeFont1.Caption:= 'Large Font';
    //to do - change bitmap too
  end
end;


procedure TMaxForm1.showAndSaveBCode(const bdata: string);
var outfile: string;
    fx: longint;
begin
 //numWritten:= 0;
 outfile:= ExtractFilePath(paramstr(0))+extractFilename(act_filename)+BYTECODE;
 //fx:= fileCreate(outfile);
 //fileWrite(fx, bdata[1], length(bdata));
 //nfileWrite(fx, bdata, length(bdata));

 //fileClose(fx);
 AssignFile(f, outfile); //BYTECODE
 {$I-}
 Rewrite(f); //1
 {$I+}
 if IOResult = 0  then begin
   Writeln(f, bdata);
   //PSScript.SetCompiled(bdata);
   CloseFile(f)
 end;
 memo2.Lines.Add('');
 memo2.Lines.Add('-----PS-BYTECODE (PSB) mX4-----');
 memo2.Lines.Add('-----BYTECODE saved as '+outfile+'-----');
 memo2.Lines.Append(bdata);
   //delete(locstr, 80, length(locstr)-80);  //after cut
end;

procedure TMaxForm1.SBytecode1Click(Sender: TObject);
begin
 sBytecode1.Checked:= not sBytecode1.Checked;
 if sBytecode1.Checked then STATShowBytecode:= true else
   STATShowBytecode:= false;
end;

procedure TMaxForm1.ScriptExplorer1Click(Sender: TObject);
//var listform: TFormListView;
begin
  listform1:= TFormListview.Create(self);
    if not (listform1.hasClosed) then begin
    with listform1 do
      Show;
    end else begin
   listform1:= TFormListview.Create(self);
   listform1.Show;
  end;
end;

procedure TMaxForm1.ScriptListbox1Click(Sender: TObject);
begin
  //CB1SCList.SetFocus;
  CB1SCList.DroppedDown:= true;
  CB1SCList.SetFocus;
end;

procedure TMaxForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //if Key = #27 then Close;
  if Key = #27 then begin
   // if assigned(cb1sclist) then
    //FreeAndNIL(cb1sclist);  //prevent invalid pointer op!
   Close;
  end;
end;

procedure TMaxForm1.FormOutput1Click(Sender: TObject);
begin
  //redirect the memo2 in form
  formOutput1.Checked:= not formOutput1.Checked;
  if formOutput1.Checked then STATformOutput:= true else
   STATformOutput:= false;
  memo2.Lines.add('Switch: next compile output will result in window');
  //  memo2.Lines.SaveToFile(Act_Filename+'Output'+'.txt');
end;


procedure TMaxForm1.FractalDemo1Click(Sender: TObject);
begin
 winformp.SetFractalForm(875, 895);
 //getrvalue
end;

procedure TMaxForm1.FullTextFinder1Click(Sender: TObject);
begin
  //full text finder
  //winformp.
   Application.CreateForm(TwinFormp, winFormp);
   winformp.Height:= 740;
   winformp.finderactive:= true;
   //StartFileFinder;     //Full Text Finder
end;

procedure TMaxForm1.CipherFile1Click(Sender: TObject);
begin
  //showmessage('CipherBox available in mX3.5')
  WinFormp.SetCryptForm;
end;

procedure TMaxForm1.CryptoBox1Click(Sender: TObject);
begin
  //crypto box  AES
    WinFormp.SetCryptFormAES;
end;


procedure TMaxForm1.Clear1Click(Sender: TObject);
begin
  if MessageDlg('mX4 Welcode to '+RCSTRMB+ ' Clear code memo now?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
    if STATedchanged then begin
         sysutils.beep;
         if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
         Save2Click(self);
         statusBar1.panels[2].text:= ' S';
       end else
        STATEdchanged:= false;
    last_fName:= Act_Filename;
    loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
    memo1.Lines.Clear;
    memo1.lines.Add('----code_cleared_checked_clean----');
    STATEdchanged:= false;
    statusBar1.panels[2].text:= ' SM';
    Act_Filename:= '';
  end
end;

procedure TMaxForm1.lineToNumber(met: boolean);
var i: integer;
  mypos, offset: integer;
  mystr: string[250];
begin
  offset:= 1;
  if met then
  for i:= 1 to memo1.Lines.Count - 1 do begin
    memo1.Lines.Strings[i]:= inttostr(i+offset)+' '+memo1.Lines.Strings[i];
    memo1.readonly:= true;
    memo1.Font.Style:= [fsBold];
  end
  // check if linenumber was on before
  else if pos(inttostr(1+offset), memo1.lines.Strings[1]) <> 0 then begin
    for i:= 1 to memo1.Lines.Count - 1 do begin
      mypos:= pos(inttostr(i+offset), memo1.lines.Strings[i]);
      if pos(inttostr(i+offset), memo1.lines.Strings[i]) <> 0 then begin
        mystr:= memo1.Lines.Strings[i];
        delete(mystr, mypos, (length(inttostr(i+offset))+1));
        memo1.Lines.Strings[i]:= mystr;
      end;
    end;
    memo1.readonly:= false;
    memo1.Font.Style:=[];
  end;
end;

procedure TMaxForm1.Slinenumbers1Click(Sender: TObject);
begin
  if Slinenumbers1.Checked then lineToNumber(true)
    else lineToNumber(false)
end;


procedure TMaxForm1.Sort1IntflistClick(Sender: TObject);
begin
//sort intflist
  if intfnavigator1.checked then
     lbintflist.Sorted:= true;
end;

procedure TMaxForm1.defFileread;
var deflist: TStringlist;
     filepath, fN: string;
begin
deflist:= TStringlist.create;
filepath:= ExtractFilePath(Application.ExeName);
  try
    fN:= filepath+ DEFINIFILE;
    if fileexists(fN) then begin
      deflist.LoadFromFile(fN);
      last_fName:= (deflist.Values['PRELAST_FILE']);
      last_fName1:= (deflist.Values['PRELAST_FILE1']);
      last_fName2:= (deflist.Values['PRELAST_FILE2']);
      last_fName3:= (deflist.Values['PRELAST_FILE3']);
      last_fName4:= (deflist.Values['PRELAST_FILE4']);
      last_fName5:= (deflist.Values['PRELAST_FILE5']);
      last_fName6:= (deflist.Values['PRELAST_FILE6']);
      last_fName7:= (deflist.Values['PRELAST_FILE7']);
      last_fName8:= (deflist.Values['PRELAST_FILE8']);
      loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
      last_fontsize:= strtoint((deflist.values['FONTSIZE']));
      IPHost:= deflist.Values['IPHOST'];
      try
        lbintflistwidth:= strtoint((deflist.values['NAVWIDTH']));
      except
        lbintflistwidth:= lbintflistwidth;
      end;
      //lbintflistwidth: integer;
      try
        IPPort:= strToInt(deflist.Values['IPPORT']);         //3.9.6.4
      except
        IPPort:= IPPort;
      end;
      try
        COMPort:= strToInt(deflist.Values['COMPORT']);       //3.9.6.4
      except
        COMPort:= COMPort;
      end;
      if last_fontsize = 0 then last_fontsize:= 8;   //bug 3.6
      memo1.Font.Size:= last_fontsize;
      memo2.Font.Size:= last_fontsize;
      fileextension:= deflist.Values['EXTENSION'];
      self.Height:= strtoint(deflist.Values['SCREENY']);
      self.Width:= strtoInt(deflist.values['SCREENX']);
      memo2.Height:= strToInt(deflist.Values['MEMHEIGHT']);
      if deflist.Values['LINENUMBERS'] = 'Y' then
      memo1.Gutter.ShowLineNumbers:= true
          else memo1.Gutter.ShowLineNumbers:= false;
      if deflist.Values['EXCEPTIONLOG'] = 'Y' then
        STATExceptionLog:= true else
         STATExceptionLog:= false;
      if deflist.Values['EXECUTESHELL'] = 'Y' then
        STATExecuteShell:= true else
         STATExecuteShell:= false;
      if deflist.Values['BOOTSCRIPT'] = 'Y' then
        STATExecuteBoot:= true else
          STATExecuteBoot:= false;
      if deflist.Values['MEMORYREPORT'] = 'Y' then
        STATMemoryReport:= true else
         STATMemoryReport:= false;
      if deflist.Values['NAVIGATOR'] = 'Y' then   //3.9.8.9
              IntfNavigator1Click(Self);
      if deflist.Values['MACRO'] = 'Y' then   //3.9.8.9
              STATMacro:= true else
              STATMacro:= false;
      if deflist.Values['VERSIONCHECK'] = 'Y' then
              STATVersionCheck:= true else
              STATVersionCheck:= false;
      if deflist.Values['VERSIONCHECK'] = '' then   //3.9.9
              STATVersionCheck:= true;

      if deflist.Values['INDENT'] = 'Y' then    //new4
        STATCodefolding:= true else
         STATCodefolding:= false;

      if deflist.Values['INDENT'] = '' then   //3.9.9
              STATCodefolding:= true;

           //   STATCodefolding

   //STATVersionCheck
    end else begin
      // init values case of no file
      deflist.add('//***Definitions for ' +RCSTRMB+MBVERSION+' ***');
      deflist.add('[FORM]'); //ini file compatible mX3
      deflist.values['LAST_FILE']:= DEFFILENAME; //Def_FName;
      deflist.values['PRELAST_FILE']:= 'FILENAME'; //Def_FName;
      deflist.values['PRELAST_FILE1']:= 'FILENAME1'; //Def_FName;
      deflist.values['PRELAST_FILE2']:= 'FILENAME2'; //Def_FName;
      deflist.values['PRELAST_FILE3']:= 'FILENAME3'; //Def_FName;
      deflist.values['PRELAST_FILE4']:= 'FILENAME4'; //Def_FName;
      deflist.values['PRELAST_FILE5']:= 'FILENAME5'; //Def_FName;
      deflist.values['PRELAST_FILE6']:= 'FILENAME6'; //Def_FName;
      deflist.values['PRELAST_FILE7']:= 'FILENAME7'; //Def_FName;
      deflist.values['PRELAST_FILE8']:= 'FILENAME8'; //Def_FName;
      deflist.values['FONTSIZE']:= '11';
      deflist.values['EXTENSION']:= 'txt';
      deflist.Values['SCREENX']:= '950';
      deflist.Values['SCREENY']:= '825';
      deflist.Values['MEMHEIGHT']:= '175';
      deflist.Values['PRINTFONT']:= 'Courier New';
      deflist.Values['LINENUMBERS']:= 'Y';
      deflist.Values['EXCEPTIONLOG']:= 'Y';
      deflist.Values['EXECUTESHELL']:= 'Y';
      deflist.Values['BOOTSCRIPT']:= 'Y';
      deflist.Values['MEMORYREPORT']:= 'N';
      deflist.Values['INDENT']:= 'Y';           //new4

      deflist.Values['NAVIGATOR']:= 'N';
      deflist.Values['MACRO']:= 'Y';
      deflist.Values['COMPORT']:= '3';
      deflist.Values['NAVWIDTH']:= '350';
      deflist.add('[WEB]'); //ini file compatible mX3
      deflist.Values['ROOTCERT']:= 'filepathY';
      deflist.Values['SCERT']:= 'filepathY';
      deflist.Values['RSAKEY']:= 'filepathY';
      deflist.Values['IPHOST']:= '127.0.0.1';
      deflist.Values['IPPORT']:= '8080';
      deflist.Values['VERSIONCHECK']:= 'Y';

      deflist.SaveToFile(fN);
    end;
  finally
    deflist.Free
 end;
end;

procedure TMaxForm1.defFilereadUpdate;
var deflist: TStringlist;
     filepath, fN: string;
begin
deflist:= TStringlist.create;
filepath:= ExtractFilePath(Application.ExeName);
  try
    fN:= filepath+ DEFINIFILE;
    if fileexists(fN) then begin
      deflist.LoadFromFile(fN);
      last_fontsize:= strtoint((deflist.values['FONTSIZE']));
      IPHost:= deflist.Values['IPHOST'];
      try
        lbintflistwidth:= strtoint((deflist.values['NAVWIDTH']));
      except
        lbintflistwidth:= lbintflistwidth;
      end;
      //lbintflistwidth: integer;
      try
        IPPort:= strToInt(deflist.Values['IPPORT']);         //3.9.6.4
      except
        IPPort:= IPPort;
      end;
      try
        COMPort:= strToInt(deflist.Values['COMPORT']);       //3.9.6.4
      except
        COMPort:= COMPort;
      end;
      if last_fontsize = 0 then last_fontsize:= 8;   //bug 3.6
      memo1.Font.Size:= last_fontsize;
      memo2.Font.Size:= last_fontsize;
      fileextension:= deflist.Values['EXTENSION'];
      self.Height:= strtoint(deflist.Values['SCREENY']);
      self.Width:= strtoInt(deflist.values['SCREENX']);
      memo2.Height:= strToInt(deflist.Values['MEMHEIGHT']);
      if deflist.Values['LINENUMBERS'] = 'Y' then
      memo1.Gutter.ShowLineNumbers:= true
          else memo1.Gutter.ShowLineNumbers:= false;
      if deflist.Values['EXCEPTIONLOG'] = 'Y' then
        STATExceptionLog:= true else
         STATExceptionLog:= false;
      if deflist.Values['EXECUTESHELL'] = 'Y' then
        STATExecuteShell:= true else
         STATExecuteShell:= false;
      if deflist.Values['BOOTSCRIPT'] = 'Y' then
        STATExecuteBoot:= true else
          STATExecuteBoot:= false;
      if deflist.Values['MEMORYREPORT'] = 'Y' then
        STATMemoryReport:= true else
         STATMemoryReport:= false;
      if deflist.Values['MACRO'] = 'Y' then   //3.9.8.9
              STATMacro:= true else
              STATMacro:= false;
     //STATVersionCheck
     end;
  finally
    deflist.Free
 end;
end;


procedure TMaxForm1.SaveFileOptionsToIni(const filen: string);
var filepath, fN: string;
begin
 filepath:= ExtractFilePath(Application.ExeName);
 fN:= filepath+ DEFINIFILE;
  if CB1SCList.items.count-1 > 3 then begin   //just a draft
    with  CB1SCList do begin
    last_fName1:= items[items.Count-3];
    last_fName2:= items[items.Count-4];
    last_fName3:= items[items.Count-5];
    last_fName4:= items[items.Count-6];
    last_fName5:= items[items.Count-7];
    last_fName6:= items[items.Count-8];
    last_fName7:= items[items.Count-9];
    last_fName8:= items[items.Count-10];
    //memo2.lines.add('ini hist debug' +items[items.Count-1]);
    end;
 end;

 if fileexists(fN) then begin
   with TStringlist.Create do begin
     LoadFromFile(fN);
     Values['LAST_FILE']:= filen;
     Values['PRELAST_FILE']:= last_fName;
     Values['PRELAST_FILE1']:= last_fName1;
     Values['PRELAST_FILE2']:= last_fName2;
     Values['PRELAST_FILE3']:= last_fName3;
     Values['PRELAST_FILE4']:= last_fName4;
     Values['PRELAST_FILE5']:= last_fName5;
     Values['PRELAST_FILE6']:= last_fName6;
     Values['PRELAST_FILE7']:= last_fName7;
     Values['PRELAST_FILE8']:= last_fName8;
     Values['FONTSIZE']:= inttoStr(last_fontsize);
     Values['SCREENY']:= inttostr(maxForm1.height);
     Values['SCREENX']:= inttoStr(maxForm1.Width);
     Values['MEMHEIGHT']:= inttoStr(memo2.height);
     //if intfnavigator1.checked then
        if lbintflistwidth > 20 then
          Values['NAVWIDTH']:= inttoStr(lbintflistwidth) else
          Values['NAVWIDTH']:= inttoStr(100); //3.9.8.9 minimum
     if intfnavigator1.checked then
        Values['NAVIGATOR']:= 'Y' else
        Values['NAVIGATOR']:= 'N';
      SaveToFile(fN);
     Free;
   end;
  memo2.Lines.Add(extractFileName(filen) +' in .ini stored');
  statusBar1.panels[0].text:= last_fName +' last in .ini stored';
 end;
end;

procedure TMaxForm1.LoadFileNameFromIni;
begin
 with TStringlist.Create do begin
   LoadFromFile(DEFINIFILE);
   try
     memo1.Lines.LoadFromFile(values['LAST_FILE']);
   //set act filename
     Act_Filename:= values['LAST_FILE'];
     memo2.Lines.Add(Act_Filename + FILELOAD);
     statusBar1.panels[0].text:= Act_Filename + FILELOAD;
   except
     Showmessage('Invalid File Path - Please Set <File Open/Save As...>');
   end;
   Free;
 end;
end;

procedure TMaxForm1.LinuxShellScript1Click(Sender: TObject);
begin
//SynUNIXShellScriptSyn1
  with LinuxShellScript1 do
    checked:= NOT checked;
  if LinuxShellScript1.Checked then begin
    memo1.Highlighter:= SynUNIXShellScriptSyn1;
    LinuxShellScript1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('Linux ShellScriptSyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      LinuxShellScript1.Caption:= 'UNIX ShellScriptSyntax';
    end;
 //linux
end;

Procedure TMaxForm1.LoadBootScript;
var filepath, fN: string;   //bcerrorcode
    i: longint;
    vresult: boolean;
begin
 filepath:= ExtractFilePath(Application.ExeName);
 fN:= filepath+ BOOTSCRIPT;
 if fileexists(fN) then begin
   with TStringlist.Create do begin
       LoadFromFile(fN);
     try
     //cedebug.Script.Assign(memo1.Lines);
     cedebug.Script.Add(Text);
     vresult:= cedebug.Compile;
     //result:= PSScript.Compile;
     //memo2.Clear;
     for i:= 0 to cedebug.CompilerMessageCount -1 do begin
       memo2.lines.Add(cedebug.CompilerMessages[i].MessageToString);
     end;
     if vResult then begin
       memo2.Lines.Add('mX4 BOOT-Loader compiled: '+BOOTSCRIPT + FILELOAD);
     end;
     if not cedebug.Execute then begin
      //memo1.SelStart := cedebug.ExecErrorPosition;
       memo2.Lines.Add(cedebug.ExecErrorToString +' at '+Inttostr(cedebug.ExecErrorProcNo)
                       +'.'+Inttostr(cedebug.ExecErrorByteCodePosition));
     end else memo2.Lines.Add('BOOTSCRIPT executed: '+dateTimetoStr(now()));
     except
       Showmessage('Invalid BOOTSCRIPT Execute Path - of '+fN);
     end;
    Free;
   end;
 end; //if
end;


procedure TMaxForm1.About1Click(Sender: TObject);
begin
  ShowinfoBox('About maXbox', RCSTRMB,(MBVERSION),true);
  statusBar1.Font.color:= clblue;
  statusBar1.panels[0].text:= MXSITE +' ***\/*** '+MXMAIL;
end;

//this section describes search & replace functions
// OnFind routine for find text
procedure TMaxForm1.FindNextText(Sender: TObject);
begin
  with FindReplDialog do begin
  //showmessage(inttostr(length(findtext)));   debug
    if Length(FindText)=0 then SysUtils.Beep else begin
      //btnSearch.SetFocus;
      if memo1.SearchReplace(FindText,'',Options)= 0 then begin
        SysUtils.Beep;
        ShowMessage('"'+FindText+'" not found yet!');
        end;
      end
    end;
  end;

// OnReplace routine for replace text
procedure TMaxForm1.ReplaceNextText(Sender: TObject);
begin
  with FindReplDialog do begin
    if Length(FindText)=0 then SysUtils.Beep
    else begin
      if memo1.SearchReplace(FindText,ReplaceText,Options)=0 then begin
        SysUtils.Beep;
        ShowMessage('"'+FindText+'" not found!');
      end;
    end;
  end;
end;

procedure TMaxForm1.Search1Click(Sender: TObject);
begin
  with FindReplDialog do begin
  //procedure TFindReplDialog.rgpStartClick(Sender: TObject);
    rgpStart.ItemIndex:= 0;  //set back to from cursor
    Findtext:= UpdateFindtext;
    //btnSearch.SetFocus;
    OnFind:= FindNextText;
    Execute(false);
   //btnSearch.SetFocus;
  end;
end;

function TMaxForm1.GetActFileName: string;
begin
  result:= Act_Filename;
end;

procedure TMaxForm1.SetActFileName(vname: string);
begin
  Act_Filename:= vname;
end;

function TMaxForm1.GetLastFileName: string;
begin
  result:= Last_fName;
end;

procedure TMaxForm1.SetLastFileName(vname: string);
begin
  Last_fName:= vname;
end;

function TMaxForm1.GetClientTop : integer;
begin
  Result:= Height-ClientHeight + Coolbar1.Height+ControlBar1.Height+15;
end;

procedure TMaxForm1.Undo1Click(Sender: TObject);
begin
  memo1.Undo; //check unlockundo
end;


function TMaxForm1.UpdateFindtext : string;
begin
  with memo1 do begin
    if SelAvail then Result:= SelText
    else Result:= wordAtCursor;
  end;
end;

procedure TMaxForm1.UpdateService1Click(Sender: TObject);
begin
    //if MBVER < MBVER then getfileversion//get from internet text file
  ShowinfoBox('Get the last Update and News ', RCSTRMB,(MBVERSION), false);
  statusBar1.Font.color:= clblue;
  statusBar1.panels[0].text:= MXSITE +' ***\News and Updates/*** '+MXMAIL;
  //showmessage('Updater at V3.5, now go to: www.softwareschule.ch/maxbox.htm');
end;

procedure TMaxForm1.Memo1ReplaceText(Sender: TObject; const ASearch,
  AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  mPos: TPoint;
begin
  mPos:= memo1.RowColumnToPixels(DisplayCoord(Column,Line+1));
  with mPos do begin
    x:= x+Left;
    Y:= Y+Top+GetClientTop;
  end;
  Action:= ConfirmReplDialog.Execute(mPos,Format(RCReplace,[ASearch,AReplace]));
end;

procedure TMaxForm1.Memo1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
const
  ModifiedStrs: array[boolean] of string = ('', 'Modified');
var  p: TBufferCoord;
 begin
  if Changes*[scCaretY,scCaretX]<>[] then begin
  //  with FindReplDialog do if Visible and not Searching then
    //                         FindText:= UpdateFindtext;
   //Statusbar1.Panels[1].Text:= Format(' Row: %7d   ---   Col: %3d  Sel: %6d',

       //[memo1.CaretY, memo1.CaretX, memo1.SelStart]);
   if Changes * [scAll, scCaretX, scCaretY] <> [] then
     memo1.Hint:= intToStr(memo1.CaretY)+' Cursor: '+memo1.WordAtCursor +'  Mouse: '+memo1.WordAtMouse;
   if Not activelinecolor1.checked and NOT StatActiveyellow then
      memo1.ActiveLineColor:= factivelinecolor else
      memo1.ActiveLineColor:= clWebFloralWhite;
  end;  //}
  //if activelinecolor1.checked and StatActiveyellow then
    //  memo1.ActiveLineColor:= clYellow;
    //   else memo1.ActiveLineColor:= clNone;
   if Changes * [scAll, scModified] <> [] then begin
    Statusbar1.Panels[1].Text:= ModifiedStrs[memo1.Modified];
  {if Changes * [scAll, scCaretX, scCaretY] <> [] then begin
    p:= memo1.CaretXY;
    Statusbar1.Panels[0].Text := Format('%6d:%3d',[p.Line, p.Char]);
    //ResetMarkButtons;
  end;//}
     memo1.ReScanForFoldRanges;
   end;
   //memo1.ReScanForFoldRanges;

end;

procedure TMaxForm1.Memo2KeyPress(Sender: TObject; var Key: Char);
begin
  //keypressed simulates the dos shell
  fkeypressed:= true;
  Statusbar1.Panels[1].Text:= ' isKeyPressed on Shell at '+timetoStr(time);
  //memo2.Lines.Add('ShellCompiler: isKeyPressed at '+DatetimetoStr(Now));
end;

procedure TMaxForm1.Memory1Click(Sender: TObject);
begin
  //memory game
  FormCreateInit(self);
end;

procedure TMaxForm1.MetricReport1Click(Sender: TObject);
begin
  ShowMessage('Add On available in V4')
end;

procedure TMaxForm1.Minesweeper1Click(Sender: TObject);
begin
  ShowMessage('Add On available in V4')
end;

procedure TMaxForm1.WordWrap1Click(Sender: TObject);
begin
 wordWrap1.Checked:= not WordWrap1.Checked;
 if WordWrap1.Checked then memo1.WordWrap:= true else
   memo1.WordWrap:= false;
end;


procedure TMaxForm1.SearchNext1Click(Sender: TObject);
begin
  FindNextText(self);
end;


procedure TMaxForm1.SerialRS2321Click(Sender: TObject);
begin
  //start to serial
  StartSerialDialog;
end;

procedure TMaxForm1.Replace1Click(Sender: TObject);
begin
  with FindReplDialog do begin
    Findtext:= UpdateFindtext;
    OnFind:= FindNextText;
    OnReplace:= ReplaceNextText;
    Execute(true);
  end;
end;

function TMaxForm1.PSScriptNeedFile(Sender: TObject;
          const OrginFileName: String; var FileName, Output: String): Boolean;
var path: string;
  f: TFileStream;
begin
  path:= ExtractFilePath(ParamStr(0)) + FileName;
  try
    f:= TFileStream.Create(path, fmOpenRead or fmShareDenyWrite);
  except
    result:= false;
    exit;
  end;
  try
    setLength(output, f.size);
    f.Read(output[1], length(output));
  finally
    f.Free;
  end;
  result:= true;
  if STATInclude then
    showmessage('this Include: '+ orginfilename + ' '+FileName + ' '+output);
end;

procedure TMaxForm1.PythonSyntax1Click(Sender: TObject);
begin
  with PythonSyntax1 do
    checked:= NOT checked;
  if PythonSyntax1.Checked then begin
    memo1.Highlighter:= SynPythonSyn1;
    PythonSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('PythonSyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      PythonSyntax1.Caption:= 'Python Syntax';
    end;
end;

procedure TMaxForm1.ShowInclude1Click(Sender: TObject);
begin
 showInclude1.Checked:= not showInclude1.Checked;
 if showInclude1.Checked then STATInclude:= true else
   STATInclude:= false;
end;

procedure TMaxForm1.ShowIndent1Click(Sender: TObject);   //new4
begin
 showIndent1.Checked:= not showIndent1.Checked;

 //if STATCodefolding

 if showIndent1.Checked then

  memo1.CodeFolding.IndentGuides:= true else

    memo1.CodeFolding.IndentGuides:= false;
 
end;

procedure TMaxForm1.ShowSpecChars1Click(Sender: TObject);
begin
 showSpecChars1.Checked:= not showSpecChars1.Checked;
 if showSpecChars1.Checked then Memo1.Options:=
                              Memo1.Options +[eoShowSpecialChars] else
 Memo1.Options:= Memo1.Options - [eoShowSpecialChars];
end;

procedure TMaxForm1.ShrinkFontConsole1Click(Sender: TObject);
begin
  memo2.Font.Size:= memo2.Font.Size-1;
  //last_fontsize:= memo1.Font.Size;
end;

procedure TMaxForm1.SimuLogBox1Click(Sender: TObject);
begin
  //start of the logbox
   winformp.SetLogBoxForm;
end;


procedure TMaxForm1.SkyStyle1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 230;
    color:= clwebgold;  //clblack
    font.size:= 15;
    font.color:= clPurple;
    //clear;
 end;
  maxform1.Color:= clwebgold;
  Application.HintColor:= clYellow;  
  //ActiveLineColor1Click(self);
  memo1.activeLineColor:= clskyblue;
  factivelinecolor:= clskyblue;
  memo1.RightEdgeColor:= clPurple;
  memo1.Gutter.Color:= clMoneyGreen;
  //ActiveLineColor1Click(self);
  if intfnavigator1.checked then
    lbintfList.Color:= clskyblue;

end;

procedure TMaxForm1.SynEditPrint1PrintLine(Sender: TObject; LineNumber,
  PageNumber: Integer);
begin
  //fprintout.Footer.Add()
   //fprintout.footer.Print(NIL, pagenumber);
 //fprintout.Footer.DefaultFont.Size:= 7;
 //fprintout.UpdatePages(Printer.Canvas);
 //fprintout.Footer.Add('P: '+IntToStr((pagenumber)), NIL, taRightJustify, 3);
end;

//var ppagenumber: integer;

procedure TMaxForm1.SynEditPrint1PrintStatus(Sender: TObject; Status: TSynPrintStatus;
  PageNumber: Integer; var Abort: Boolean);
begin
 //fprintout.Footer.DefaultFont.Size:= 7;
 //if status = psNewpage then
 //fprintout.Footer.Add('',NIL, taRightJustify, 3);
 //fprintout.Footer.Count;
 fprintout.Footer.Delete(3);
 fprintout.Footer.Delete(2);
 fprintout.Footer.Add('T: '+IntToStr(fPrintOut.PageCount), NIL, taRightJustify, 2);
 fprintout.Footer.Add('p: '+IntToStr((pagenumber)),NIL, taRightJustify, 3);
  StatusBar1.Panels[1].Text:= ' Total Page Count: ' + IntToStr(fprintout.PageCount);
   //ppagenumber:= pagenumber;
end;

procedure TMaxForm1.SynMultiSyn1CustomRange(Sender: TSynMultiSyn;
  Operation: TRangeOperation; var Range: Pointer);
begin
//  to be test for filters
end;

//printing procedures--------------------------------------
procedure TMaxForm1.Preview1Click(Sender: TObject);
var dlg: TSynEditPrintPreview;
    afrm: TForm;
begin
 with fPrintOut do begin
    Title:= Act_Filename;
    //Lines.AddStrings(memo1.Lines);  //mX3
    Lines.LoadFromFile(Act_Filename);
    Header.Clear;
    Footer.Clear;
    Header.DefaultFont.Name:= RCPRINTFONT;
    Header.Add(RCSTRMB +MBVERSION, NIL, taLeftJustify, 1 );
    Header.Add(dateTimeToStr(now), NIL, taRightJustify, 1 );
    Footer.DefaultFont.Size:= 8;
    Footer.FixLines;
    //Footer.Delete(2);
    //fPrintOut.PageOffset:= 1;
    //Footer.Add(GetComputerNameWin+' '+fPrintOut.Title, NIL, taLeftJustify, 1 );
    //Footer.Add(MXSITE, NIL, taLeftJustify,1);
    {//fprintout.Footer.Delete(2);
    //Footer.Add('Total: '+IntToStr(fPrintOut.PageCount), NIL, taRightJustify, 2);
   // Footer.Add('Page: '+IntToStr((ppagenumber)), NIL, taRightJustify, 3);}
    Colors:= mnPrintColors1.Checked;
    //Highlighter:= SynPasSyn1;
    Highlighter:= memo1.Highlighter;  //3.1
    LineNumbers:= true;
    //fprintout.PrinterInfo.UpdatePrinter;
    Wrap:= wordWrap1.Checked;
  end;
  afrm:= TForm.Create(self);
  afrm.SetBounds(0,0,780,900);
  afrm.caption:= 'Print Preview Beta Preview';
  //afrm.Show;
  dlg:= TSynEditPrintPreview.Create(afrm);
  try
    dlg.Parent:= afrm;
    dlg.SynEditPrint:= fprintout;
    dlg.UpdatePreview;
    dlg.Show;
    StatusBar1.Panels[1].Text:= ' Page: ' + IntToStr(dlg.PageNumber);
    afrm.ShowModal;
  finally
    dlg.Free;
    afrm.Free;
  end;
   //  SynEditPrintPreview.UpdatePreview;
  //Preview.ShowModal;
   // showmessage('will be in V4');
end;

procedure TMaxForm1.Printout1Click(Sender: TObject);
//var pntindex: integer;
begin
   //set all properties because this can affect pagination
  Screen.Cursor:= crHourGlass;
  with fPrintOut do begin
    Title:= Act_Filename;
    //Lines.AddStrings(memo1.Lines);  //mX3
    Lines.LoadFromFile(Act_Filename);
    Header.Clear;
    Footer.Clear;
    Header.DefaultFont.Name:= RCPRINTFONT;
    Header.Add(RCSTRMB +MBVERSION, NIL, taLeftJustify, 1 );
    Header.Add(dateTimeToStr(now), NIL, taRightJustify, 1 );
    Footer.DefaultFont.Size:= 7;
    //Footer.FixLines;
    fPrintOut.PageOffset:= 1;
    Footer.Add(GetComputerNameWin+' '+fPrintOut.Title, NIL, taLeftJustify, 1 );
    Footer.Add(MXSITE, NIL, taLeftJustify, 2);
    //fprintout.Footer.Delete(2);
    //Footer.Add('Total: '+IntToStr(fPrintOut.PageCount), NIL, taRightJustify, 2);
   // Footer.Add('Page: '+IntToStr((ppagenumber)), NIL, taRightJustify, 3);
    Colors:= mnPrintColors1.Checked;
    //Highlighter:= SynPasSyn1;
    Highlighter:= memo1.Highlighter;  //3.1
    LineNumbers:= true;
    //fprintout.PrinterInfo.UpdatePrinter;
    Wrap:= wordWrap1.Checked;
  end;
  //show print setup dialog and print
  //pntIndex := Printer.PrinterIndex;
  with dlgFilePrint do begin
    MinPage:= 1;
    FromPage:= 1;
    MaxPage:= fPrintOut.PageCount;
    //fprintout.p
    ToPage:= MaxPage;
    if Execute then begin
    try
//      fprintout.Footer.Add('Page: '+IntToStr((ppagenumber)), NIL, taRightJustify, 3);
      fPrintOut.Font.Assign(dlgPrintFont1.Font);      //3.1
      fPrintOut.Copies:= Copies;
      //fprintout.SelectedOnly:= True;
 //fPrintout.Footer.Add('Page: '+IntToStr((fprintout.pageoffset)), NIL, taRightJustify, 3);
      case PrintRange of
        prAllPages: fPrintOut.Print;
        prPageNums: fPrintOut.PrintRange(FromPage, ToPage);
        prSelection: begin
                      fprintout.SelectedOnly := true;
                      fprintout.Print;
                  end;
      end;
    except
       on E: Exception do begin
             //Printer.PrinterIndex := pntIndex;
         Application.MessageBox(PChar('SPrintError' +#13#10+E.Message),
                              PChar(fprintout.Title), MB_ICONSTOP + MB_OK);
       end; { on }
    end; { try }
   end; //if
  end;  //with
  Screen.Cursor:= crDefault;
  statusBar1.panels[0].text:= Act_Filename +' is printed';
end;

procedure TMaxForm1.ProcessList1Click(Sender: TObject);
begin
  // processlist of devcc
  //ProcessListForm.Show;
  ProcessListForm:= TProcessListForm.Create(self);
  try
    ProcessListForm.ShowModal;
  finally
    ProcessListForm.Free;
  end;

end;

procedure TMaxForm1.EditFont1Click(Sender: TObject);
begin
  dlgPrintFont1.Font.Assign(memo1.Font);
  if dlgPrintFont1.Execute then begin
    memo1.Font.Assign(dlgPrintFont1.Font);
    last_fontsize:= memo1.Font.Size;
    statusBar1.panels[0].text:= memo1.Font.Name+' font is active';
  end;
   //CaptionEdit.Font := FontDialog1.Font;
end;

procedure TMaxForm1.EditReplace1Click(Sender: TObject);
begin
 //edit replace to enable rename clicked words
  editreplace1.checked:= not editreplace1.checked;
end;

procedure TMaxForm1.EnlargeFontConsole1Click(Sender: TObject);
begin
  memo2.Font.Size:= memo2.Font.Size+1;
  //last_fontsize:= memo1.Font.Size;
end;

procedure TMaxForm1.EnlargeGutter1Click(Sender: TObject);
begin
  enlargeGutter1.Checked:= not enlargeGutter1.Checked;
  if enlargeGutter1.Checked then begin
    memo1.Gutter.DigitCount:= 6;
    enlargeGutter1.Caption:= 'Delarge Gutter'
  end else begin
    enlargeGutter1.Caption:= 'Enlarge Gutter';
    memo1.Gutter.DigitCount:= 4;
  end;
end;

procedure TMaxForm1.TCPSockets1Click(Sender: TObject);
begin
  //this is 26
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter26.pdf');
end;

procedure TMaxForm1.TerminalStyle1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 350;
    color:= clblack;
    font.size:= 18;
    font.color:= clGreen;
    //clear;
  end;
end;

procedure TMaxForm1.Tetris1Click(Sender: TObject);
begin
  //will be tetris kiss
  Application.CreateForm(TTetro1, Tetro1);
end;

procedure TMaxForm1.ShellStyle1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 350;
    color:= clblack;  //clblack
    font.size:= 18;
    font.color:= clred;
    //clear;
  end;
end;

procedure TMaxForm1.BigScreen1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 500;
    color:= clblack;
    font.size:= 28;
    font.color:= clGreen;
    //clear;
  end;
end;

procedure TMaxForm1.Bookmark11Click(Sender: TObject);
begin
  bookmarkimage:= 10;   //warning
end;

procedure TMaxForm1.Bookmark21Click(Sender: TObject);
begin
  bookmarkimage:= 11;   //bug
end;

procedure TMaxForm1.Bookmark31Click(Sender: TObject);
begin
  bookmarkimage:= 12;  //info
end;

procedure TMaxForm1.Bookmark41Click(Sender: TObject);
begin
  bookmarkimage:= 13;  //question
end;

procedure TMaxForm1.Bookmark51Click(Sender: TObject);
begin
  bookmarkimage:= 15;  //hint
end;

procedure TMaxForm1.ConfigFile1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+DEFINIFILE); // 'maxboxdef.ini');
end;

procedure TMaxForm1.ConfigUpdate1Click(Sender: TObject);
begin
  deffilereadupdate;  //refresh the ini file
  statusBar1.panels[0].text:= 'Refresh Config File Reload: '+DEFINIFILE;
  memo2.lines.Add(statusBar1.panels[0].text);
end;

procedure TMaxForm1.Configuration1Click(Sender: TObject);
begin
  //configuration
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter25.pdf');
end;

procedure TMaxForm1.Console1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 300;
    color:= clblack;
    font.size:= 14;
    font.color:= clwhite;
    //clear;
  end;
end;


procedure TMaxForm1.CountWords1Click(Sender: TObject);
begin
  //jumps to highlightning of words
  Memo1DblClick(self);
end;

procedure TMaxForm1.ReadOnly1Click(Sender: TObject);
begin
 readonly1.Checked:= not readonly1.Checked;
 if readonly1.Checked then memo2.ReadOnly:= true else
   memo2.ReadOnly:= false;
end;


procedure TMaxForm1.Redo1Click(Sender: TObject);
begin
  memo1.Redo;
end;

procedure TMaxForm1.Rename1Click(Sender: TObject);
begin
  showmessage('will be in V4');
end;

procedure TMaxForm1.intfRefactor1Click(Sender: TObject);
begin
// refactor
  showmessage('will be in V4');
end;


procedure TMaxForm1.mnuPrintFont1Click(Sender: TObject);
begin
  dlgPrintFont1.Font.Assign(memo1.Font);  //fPrintOut
  if dlgPrintFont1.Execute then
    fPrintOut.Font.Assign(dlgPrintFont1.Font);
end;

procedure TMaxForm1.ModulesCount1Click(Sender: TObject);
var
  aStrList: TStringList;
  I: Integer;
begin
  aStrList:= TStringList.create;
  try
      debugout.Output.Clear;
      debugout.output.Font.Size:= 12;
      debugout.Width:= 700;
      loadedModulesList(aStrList, CurrentProcessId, false);
      //debugout.output.Lines.Text:= aStrList.Text;
      for I := 0 to aStrList.Count - 1 do
         debugout.output.lines.Add(intToStr(i)+': '+aStrList[i]);
      debugout.caption:= 'mX System Modules Library List';
      debugout.visible:= true;
  finally
    aStrList.Free;
  end;
  //get modules dll list
end;

procedure TMaxForm1.SetInterfacesMarks(myFile: string);
var
  i, t1, t2, tstr, actline, preline: integer;
  s1, mstr: string;
  aStrList: TStringList;
  //mysearch: TSynEditSearchCustom;
begin
  aStrList:= TStringList.create;
  aStrList.loadfromfile(myFile);
  tstr:= 0;
//  TSynSearchOption = (ssoMatchCase, ssoWholeWord, ssoBackwards,
       //mymemo.SetBookmark(5,2,20);
       //mymemo.SetBookmark(5,2,21);
   preline:= memo1.CaretY;
   //preline:= memo1.WordAtCursor;
  try
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      //t1:= pos(uppercase('function'), uppercase(s1));
      //t2:= pos(uppercase('procedure'), uppercase(s1));
   //mysearch:= TSynEditSearch.create(self);
   //mymemo.searchengine:= mysearch;
   //mymemo.searchengine:= maxform1.SynEditSearch1;
   //t1:= mymemo.searchReplace(uppercase('function '),'',[]);
   if pos(uppercase('end.'),uppercase(s1)) > 0 then break;  //bug 3.9.3

   t2:= memo1.searchReplace(uppercase('procedure '),'',[]);
   //memo1.PrevWordPos;
    //memo1.WordAtCursor;
    actline:= memo1.CaretY;
      if ((t1 or t2) > 0) and (tstr < 9) then begin
        inc(tstr);
        //mymemo.activeline
        //mymemo.SetBookmark(tstr,2,actline);
        memo1.SetBookmark(tstr,2,actline);
        //showmessage('bookmark found at ' +inttostr(t2));
      end;
    end;
    memo1.CaretY:= preline;
    //memo1.WordAtCursor:= preline;

  //ShowMessage(mstr+'----------------------'+#13+#10
    //                       +inttoStr(tstr)+' Interface(s) Found');
  finally
    aStrList.Free;
    //mysearch.Free;
  end;
end;

procedure TMaxForm1.SetInterfacesMarks2(myFile: string);
var
  i, it1, it2, it3, itstr: integer;
  s1: string;
  aStrList: TStringList;
begin
  aStrList:= TStringList.create;
  aStrList.loadFromfile(myFile);
  itstr:= 0;
  try
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      it1:= pos(uppercase('function '), uppercase(s1));
      it2:= pos(uppercase('procedure '), uppercase(s1));
      it3:= pos('//', s1);
     //t1:= mymemo.searchReplace(uppercase('function '),'',[]);
      if pos(uppercase('end.'),uppercase(s1)) > 0 then break;
      if ((it2 > 0) or (it1 > 0)) and (itstr < 9) and (it3 = 0) then begin
        inc(itstr);
        memo1.SetBookmark(itstr,2,i+1);
        //showmessage('bookmark found at ' +inttostr(i+1));
      end;
    end;
  finally
    //mymemo.CaretY:= 8;  //test
    aStrList.Free;
  end;
end;

procedure TMaxForm1.SetInterfacesMarksMemo3;
var
  i, it1, it2, itstr: integer;
  s1: string;
begin
  itstr:= 0;
  try
    for i:= 0 to memo1.lines.Count -1 do begin
      s1:= memo1.lines[i];
      it1:= pos(uppercase('function '), uppercase(s1));
      it2:= pos(uppercase('procedure '), uppercase(s1));
     //t1:= mymemo.searchReplace(uppercase('function '),'',[]);
      if pos(uppercase('end.'),uppercase(s1)) > 0 then break;
      if (it2 > 0) or (it1 > 0) and (itstr < 9) then begin
        inc(itstr);
        memo1.SetBookmark(itstr,2,i+1);
        //showmessage('bookmark found at ' +inttostr(i+1));
      end;
    end;
  finally
    //aStrList.Free;
    //mymemo.CaretY:= 10;
  end;
end;



procedure TMaxForm1.Move1Click(Sender: TObject);
begin
  Showmessage('available in V4');
end;

procedure TMaxForm1.MP3Player1Click(Sender: TObject);
begin
  //call mp3player
  FormSetMP3FormCreate;
end;

procedure TMaxForm1.N4GewinntGame1Click(Sender: TObject);
begin
 // start the game 4gewinnt
  FormCreateInit4Game(self);
end;

procedure TMaxForm1.New1Click(Sender: TObject);
begin
  if MessageDlg('Welcode to '+RCSTRMB+ ' Clear memo now and load code?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
    if STATedchanged then begin
         sysutils.beep;
         if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
         Save2Click(self);
         statusBar1.panels[2].text:= ' S';
       end else
        STATEdchanged:= false;
    last_fName:= Act_Filename;
    //loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
    memo1.Lines.Clear;
   if fileExists(ExtractFilePath(ParamStr(0))+ CODECOMPLETION) then
       maxForm1.fAutoComplete.ExecuteCompletion('program',memo1) else
      showMessage('The file '+CODECOMPLETION+' is missing');
    statusBar1.panels[0].text:= 'New Template loaded lines: '+inttoStr(memo1.LinesInWindow-1);
    memo1.lines.Add('----app_template_loaded_code----');
    //maxForm1.fAutoComplete.ExecuteCompletion('unit',memo1);
    //memo1.lines.Add('----unit_template_loaded----');
    STATEdchanged:= false;
    statusBar1.panels[2].text:= ' SM';
    Act_Filename:= 'newtemplate.txt'; //3.1
    statusBar1.panels[0].text:= 'Filename newtemplate.txt is set';
    //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
    CB1SCList.Items.Add((Act_Filename));   //3.9 wb
    CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
    If fileExists('newtemplate.txt') then begin
      if MessageDlg('Filename exists, you want to overwrite newtemplate.txt ?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin  //3.8
        statusBar1.panels[0].text:= 'newtemplate.txt will be overriden';
        loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
      end else begin
        statusBar1.panels[0].text:= 'Filename newtemplate.txt must change';
        Act_Filename:= '';
        loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
        Saveas3Click(sender);
      end;
    end;
  end
end;

procedure TMaxForm1.NewInstance1Click(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists(ExtractFilePath(Application.ExeName)) then begin
    sOName:= ExtractFilePath(Application.ExeName) + #0;
    sEName:= Application.ExeName;
    ShellExecute(0, 'open', @sEName[1], NIL, @sOName[1], SW_SHOW);
    //ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
    statusBar1.panels[0].text:= 'New Instance created of: '+ExtractFileName(Act_Filename);
    memo2.lines.Add(statusBar1.panels[0].text);
  end else
    showMessage('No mX4 Instance found...');
    //GetCurrentDir;
  //searchAndOpenDoc(ExePath+ExtractFileName(Application.ExeName))
     //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
     //CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
end;

procedure TMaxForm1.Include1Click(Sender: TObject);
var
  aStrList: TStringList;
begin
  aStrList:= TStringList.create;
  try
    if FileExists(ExePath+INCLUDEBOX) then begin
      aStrList.loadfromfile(ExePath+INCLUDEBOX);
      debugout.Output.Clear;
      debugout.output.Font.Size:= 12;
      debugout.Width:= 700;
      debugout.output.Lines.Text:= aStrList.Text;
      debugout.caption:= 'INCLUDE MAIN MAXLIB';
      debugout.output.Lines.Add(inttoStr(aStrList.Count)+' Lines Found: ' +
                                     (ExtractFileName(ExePath+INCLUDEBOX)));
      debugout.visible:= true;
    end else
      Showmessage('File not ready '+ ExePath+INCLUDEBOX)
  finally
    aStrList.Free;
  end;
end;

procedure TMaxForm1.DoEditorExecuteCommand(EditorCommand: word);
begin
  memo1.CommandProcessor(TSynEditorCommand(EditorCommand),' ',NIL);
end;

procedure TMaxForm1.IndentSelection1Click(Sender: TObject);
begin
 //memo1.Marks;
  //memo1.Keystrokes.items[0].command:= ecBlockIndent;
  DoEditorExecuteCommand(ecBlockIndent);
end;

procedure TMaxForm1.UnindentSection1Click(Sender: TObject);
begin
  //memo1.Keystrokes.items[0].command:= ecBlockUnIndent;
  // Find Command(ecBlockUnIndent);
  //memo1.Keystrokes.items[memo1.Keystrokes.FindCommand(ecBlockUnIndent)].Command:=ecBlockUnIndent;
  DoEditorExecuteCommand(ecBlockUnIndent);
end;


procedure TMaxForm1.Info1Click(Sender: TObject);
var
  //aStrList: TStringList;
  mytimestamp: TDateTime;
  Attributes: Word;
  ReadOnly, Archive, System: boolean;
  mname, mdes: string;
begin
  //aStrList:= TStringList.create;
  try
    if FileExists(Act_Filename) then begin
      //aStrList.loadfromfile(ExePath+INCLUDEBOX);
      with debugout do begin
        Output.Clear;
        output.Font.Size:= 13;
      //debugout.output.Color:= clred;
        Width:= 750;
        Height:= 720;
         //debugout.Color:= 123;
        caption:= 'mX3 Script File Information of '+getOSName+' '
                             +getOSVersion+' '+getOSNumber;
        //output.Font.Style:= [fsbold];
        output.Lines.add(DupeString('-',140));
        output.Lines.add('App Name: '+extractFileName(Act_Filename));
        output.Lines.add('Path Name: '+extractFilePath(Act_Filename));
        output.Lines.add('Exe Name: '+extractFileName(Application.ExeName));
        //output.Font.Style:= [];
        output.Lines.add(DupeString('-',140));
        output.Lines.add('File Size: '+IntToStr(FileSizeByName(Act_Filename))+' Kb');
        output.Lines.add('File Age: '+IntToStr(FileAge(Act_Filename)));
        mytimestamp:= GetFileCreationTime(Act_Filename);
        output.Lines.add('File Created: '+datetimetoStr(mytimestamp));
        output.Lines.add('File Lines: '+inttostr(memo1.Lines.count-1)+
                         '     Code Lines (Locs): '+intToStr(getCodeEnd));
        output.Lines.add('File Extension: '+ExtractFileExt(Act_Filename));
        GetAssociatedProgram(ExtractFileExt(Act_Filename),mname, mdes);
        output.Lines.add('Associated Task: '+mname+': '+mdes);
        output.Lines.add('SHA1 of File: '+SHA1(Act_Filename));
        output.Lines.add('MD5 of File: '+MD5(Act_Filename));
        output.Lines.add('CRC32 of File: '+IntToStr((CRC32H(Act_Filename))));
        Attributes:= FileGetAttr(Act_Filename);
        ReadOnly:= (Attributes and faReadOnly) = faReadOnly;
        Archive:= (Attributes and faArchive) = faArchive;
        System:= (Attributes and faSysFile) = faSysFile;
        if ReadOnly then output.Lines.Add('File is Readonly!');
        if Archive then output.Lines.Add('File is Archive');
        if System then output.Lines.Add('File is System!');
        output.Lines.add('File Version: '+GetVersionString(Act_Filename));
        output.Lines.add(DupeString('-',140));
        output.Lines.add('Work Dir: '+GetCurrentDir);
        output.Lines.add('Exe Dir: '+ExePath);
        if STATSavebefore then output.Lines.Add('Auto Save On')
                   else output.Lines.Add('Auto Save Off');
        if STATMemoryReport then output.Lines.Add('Mem Report On')
                   else output.Lines.Add('Mem Report Off');
        if STATMacro then output.Lines.Add('Macro On')
                   else output.Lines.Add('Macro Off');
        if procMess.Checked then output.Lines.Add('ProcessMessages On')
                   else output.Lines.Add('ProcessMessages Off');
        if IsInternet then output.Lines.Add('Internet On')
                   else output.Lines.Add('Internet Off');
        output.Lines.add('Local IP: '+getIPAddress(getComputerNameWin));
        output.Lines.add('Host Name: '+getComputerNameWin+'   Win64: '+boolToStr(isWoW64,true)+'  OS: '+getOSName);
        output.Lines.add('User Name: '+getUserNameWin);
        output.Lines.add('Process ID: '+intToStr(CurrentProcessID) +'  ThreadCount: '+intToStr(numprocessthreads));
        output.Lines.add('Memory Load: '+inttoStr(GetMemoryLoad) +'% used');
        output.Lines.add('Free Mem: '+inttoStr(GetFreePhysicalMemory div 1024)+'MB');
        output.Lines.add('Time: '+DateTimeToInternetStr(now, true));
        output.Lines.add('mX3 Installed Version: '+MBVERSION);
        output.Lines.add('mX3 Internet Version: '+ActVersion);
         //output.Lines.add(PSScript.Comp.UnitName);
        //output.Lines.add(PSScript.Exec.GlobalVarNames);
      //debugout.output.Lines.Add(inttoStr(aStrList.Count)+' Lines Found: ' +
        //                             (ExtractFileName(ExePath+INCLUDEBOX)));
      visible:= true;
      bringToFront;
      end;
    end else
      Showmessage('File is not available '+ ExePath)
  finally
    //debugout.output.Color:= clwhite;
    //debugout.output.Font.Size:= 14;
    //aStrList.Free;
  end;
  //File Info
end;

procedure TMaxForm1.InternetRadio1Click(Sender: TObject);
begin
///
   Showmessage('yeah, will be in V4');
end;

procedure TMaxForm1.IntfNavigator1Click(Sender: TObject);
begin
  intfnavigator1.checked:= NOT intfnavigator1.checked;
  if intfnavigator1.checked then LoadInterfaceList else
     FreeAndNil(lbintflist);
end;

procedure TMaxForm1.FormDestroy(Sender: TObject);
begin
  //fprintOut.Free;
  DragAcceptFiles(maxForm1.Handle, false);
  //DragAcceptFiles(listform1.Handle, false);
  //ListForm1.WindowProc:= FOrgListViewWndProc; // restore window proc
  //FOrgListViewWndProc:= NIL;
  //listform1.Free;
end;

procedure TMaxForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //stringGrid1.Free;
  fprintOut.Free;
  fAutoComplete.Free;
  debugout.Free;
  listform1.Free;
   memo1.CodeFolding.Free;     //new4
   memo1.free;

  //CB1SCList.Free;
  //if assigned(cb1sclist) then
    //FreeAndNIL(cb1sclist);  //prevent invalid pointer op!
    if assigned(winFormp) then
      winFormp.Free;
    //maxform1.SetFocus;
  if STATedchanged then begin
  if MessageDlg(RCSTRMB+': Save Code Changes now?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
      Save2Click(sender);
      memo1.Lines.Clear;
      Action:= caFree;
    end else
    Action:= caFree;
  end;
  //  if assigned(winFormp) then
    //  winFormp.Free;
  //showmessage('form close');  //debug
end;

procedure TMaxForm1.UpdateView1Click(Sender: TObject);
begin
  memo1.Repaint; //after copy&paste or drag'n drop
end;


procedure TMaxForm1.URILinksClicks1Click(Sender: TObject);
begin
  with URILinksClicks1 do
    checked:= NOT checked;

  if URILinksClicks1.Checked then begin
   memo1.Highlighter:= SynURISyn1;
   SynMultiSyn1.DefaultFilter:= SynURISyn1.DefaultFilter;
   // memo1.Highlighter:= SynMultiSyn1;

   {SynMultiSyn1.DefaultFilter:= SynHTMLSyn1.DefaultFilter;
   SynMultiSyn1.DefaultFilter:= SynPasSyn1.DefaultFilter;
   SynMultiSyn1.DefaultFilter:= SynURISyn1.DefaultFilter;}

    URILinksClicks1.Caption:= 'Pascal Syntax';
    memo2.Lines.Add('URI Links active with Ctrl and Click ');
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      URILinksClicks1.Caption:= 'URI Links Clicker';
    end;
end;

procedure TMaxForm1.Tutorial22Services1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter22.pdf');
end;

procedure TMaxForm1.Tutorial23RealTime1Click(Sender: TObject);
begin
//    Showmessage('available in V4');
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter23.pdf');
end;

procedure TMaxForm1.Tutorial24CleanCode1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter24.pdf');
end;

procedure TMaxForm1.Tutorial19COMArduino1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter19.pdf');
end;

procedure TMaxForm1.Tutorial20RegexClick(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter20.pdf');
end;

procedure TMaxForm1.Tutorial21Android1Click(Sender: TObject);
begin
  //android
    Showmessage('available in V4');
end;

procedure TMaxForm1.Tutorial17Server1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter17.pdf');
end;

procedure TMaxForm1.Tutorial18Arduino1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter18.pdf');
end;

procedure TMaxForm1.Tutorial13Ciphering1Click(Sender: TObject);
begin
// cipher a file pdf
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter13.pdf');
end;

procedure TMaxForm1.Tutorial14Async1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter14.pdf');
end;

procedure TMaxForm1.Tutorial151Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter15.pdf');
end;

procedure TMaxForm1.Lessons15Review1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter16.pdf');
end;


procedure TMaxForm1.Tutorial10Statistics1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter10.pdf');
  //statistics pdf
end;

procedure TMaxForm1.Tutorial11Forms1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter11.pdf');
end;

procedure TMaxForm1.Tutorial12SQL1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter12.pdf');
end;

procedure TMaxForm1.Tutorial0Function1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter0.pdf');
end;

procedure TMaxForm1.Tutorial101Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter9.pdf');
end;

procedure TMaxForm1.CodeCompletionList1Click(Sender: TObject);
begin
  if fileExists(ExtractFilePath(ParamStr(0))+ CODECOMPLETION) then begin
    statusBar1.panels[0].text:= ' Code Completion Load...' +CODECOMPLETION;
    memo2.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+CODECOMPLETION) end else
    showMessage('the file '+CODECOMPLETION+' is missing');
end;

procedure TMaxForm1.CodeSearch1Click(Sender: TObject);
 var S: string;
begin
  S:= '';
  S:= 'StringReplace(';
  if InputQuery('CodeSearchEngine2', 'Enter your code search for examples:', S) and (S <> '') then
    StartCodeFinder(S);
  //code searchforall
end;

procedure TMaxForm1.SaveOutput1Click(Sender: TObject);
begin
  memo2.Lines.SaveToFile(Act_Filename+'Output'+'.txt');
  memo2.Lines.Add(Act_Filename +' output stored');
end;

procedure TMaxForm1.SaveScreenshotClick(Sender: TObject);
begin
  CaptureScreenPNG(ExePath+'mx_screenshot.png');
  memo2.Lines.Add('Screenshot saved as: '+ExePath+'mx_screenshot.png');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'mx_screenshot.png');
end;

procedure TMaxForm1.sbvclhelpClick(Sender: TObject);
begin
  //sbvclhelp vcl.pdf
    searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLOBJECTSLIST)
end;

procedure TMaxForm1.ExportClipboard1Click(Sender: TObject);
begin
  memo1.SelectAll;
  if memo1.Focused then memo1.CopyToClipboard;
  statusBar1.panels[0].text:= ' Export to Clipboard...' +FILELOAD;
end;

function FileNewExt(const FileName, NewExt: TFileName): TFileName;
begin
  Result:= Copy(FileName,1,Length(FileName)-Length(ExtractFileExt(FileName)))+ NewExt;
end;


procedure TMaxForm1.ExporttoHTML1Click(Sender: TObject);
begin
  //export to HTML
  SynExporterHTML1.CreateHTMLFragment:= true;
  SynExporterHTML1.ExportAll(memo1.Lines);
  //SynExporterHTML1.SaveToFile(Act_Filename+'out'+'.htm');
  SynExporterHTML1.SaveToFile(FileNewExt(Act_Filename,'.htm'));
  memo2.Lines.Add(FileNewExt(Act_Filename,'.htm')+' as HTML output stored');
end;

procedure TMaxForm1.ImportfromClipboard1Click(Sender: TObject);
begin
  last_fName:= Act_Filename;
  loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
  if memo1.Focused then memo1.PasteFromClipboard;
  statusBar1.panels[0].text:= ' Import of Clipboard...' +FILELOAD;
  //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb no name first
   CB1SCList.Items.Add((Act_Filename));   //3.8 wb
  CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
end;

procedure TMaxForm1.ImportfromClipboard2Click(Sender: TObject);
begin
  ImportfromClipboard1Click(Sender);
end;

procedure TMaxForm1.Close1Click(Sender: TObject);
begin
  self.Close;
end;

procedure TMaxForm1.Manual1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\delphi_kurs.pdf')
end;

procedure TMaxForm1.ManualE1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\objectpascal_guide.pdf')
end;

procedure TMaxForm1.tutorial1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter.pdf')
end;

procedure TMaxForm1.tutorial21Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter2.pdf');
end;

procedure TMaxForm1.tutorial31Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter3.pdf');
end;

procedure TMaxForm1.tutorial4Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter4.pdf');
end;

procedure TMaxForm1.Tutorial5Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter5.pdf');
end;

procedure TMaxForm1.Tutorial6Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter6.pdf');
end;

procedure TMaxForm1.Tutorial71Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter7.pdf');
end;

procedure TMaxForm1.Tutorial81Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter8.pdf');
  //Showmessage('available in 3.1');
end;

procedure TMaxForm1.Tutorial91Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))
                    +'docs\PascalScript_maXbox_EKON_14_2.pdf');
end;


procedure TMaxForm1.intfAdd1Click(Sender: TObject);
 var
  S: string;
begin
  S:= '';
  if InputQuery('SAddSkipListTitle', 'SAddSkipListCaption', S) and (S <> '') {and not InSkipList(S)} then
    lbintflist.Items.Add(ChangeFileExt(ExtractFilename(S), ''));
end;

function YesNo(const ACaption, AMsg: string): boolean;
begin
  Result := MessageBox(GetFocus, PChar(AMsg), PChar(ACaption),
    MB_YESNO or MB_ICONQUESTION or MB_TASKMODAL) = IDYES;
end;


procedure TMaxForm1.intfDelete1Click(Sender: TObject);
var
  i: integer;
begin
  if not YesNo(SConfirmDelete, SDelSelItemsPrompt) then
    Exit;
  with lbintflist do
    for i:= Items.Count - 1 downto 0 do
      if Selected[i] then
        Items.Delete(i);
// delete
end;

procedure TMaxForm1.ActiveLineColor1Click(Sender: TObject);
begin
  activelinecolor1.Checked:= not activelinecolor1.Checked;
  if activelinecolor1.Checked then begin
   STATActiveyellow:= true;
    memo1.ActiveLineColor:= clYellow end else begin
   STATActiveyellow:= false;
   memo1.ActiveLineColor:= clWebFloralWhite; //clNone;
 end;
  //activelinecolor1.Checked:= not activelinecolor1.Checked;
end;

procedure TMaxForm1.AllFunctionsList1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLFUNCTIONSLISTPDF)
end;

procedure TMaxForm1.AllObjectsList1Click(Sender: TObject);
begin
  //this is all objects list
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLOBJECTSLIST)
end;

procedure TMaxForm1.AllResourceList1Click(Sender: TObject);
begin
  //all resource show
    searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLTYPELIST)
end;

procedure TMaxForm1.AndroidDump1Click(Sender: TObject);
begin
   ShowMessage('Android Dump to Dalvik Compile Format Runtime Emulator available in V4'+#13#10+
                'first example in: ..\examples\androidlcl')
end;

procedure Replace(var Str: String; Old, New: String);
begin
  Str:= StringReplace(Str, Old, New, [rfReplaceAll]);
end;


//----------------------- PlugIns---------------------------------------------
function TMaxForm1.ParseMacros(Str: String): String;
var
  //e: TEditor;
  Dir: String;
  StrList: TStringList;
begin
  Result := Str;
  //e := MainForm.GetEditor;

  //Replace(Result, '<DEFAULT>', devDirs.Default);
  //Replace(Result, '<DEVCPP>', ExtractFileDir(ParamStr(0)));
  //Replace(Result, '<DEVCPPVERSION>', DEVCPP_VERSION);

  //SearchAndCopy(memo1.lines, '#date', datetimetoStr(now), 11);

  Replace(result, '<EXEPATH>', ExePath);
  Replace(Result, '<DATE>', DateToStr(Now));
  Replace(Result, '<DATETIME>', DateTimeToStr(Now));

  {Dir := ExtractFilePath(ParamStr(0)) + '\include';
  if (not DirectoryExists(Dir)) and (devDirs.C <> '') then begin
      StrList := TStringList.Create;
      StrToList(devDirs.C, StrList);
      Dir := StrList.Strings[0];
      StrList.Free;
  end; }
  Replace(Result, '<INCLUDE>', Dir);
  Dir := ExtractFilePath(ParamStr(0)) + '\lib';
  {if (not DirectoryExists(Dir)) and (devDirs.Lib <> '') then begin
      StrList := TStringList.Create;
      StrToList(devDirs.Lib, StrList);
      Dir := StrList.Strings[0];
      StrList.Free;
  end;}
  Replace(Result, '<LIB>', Dir);

   { Project-dependent macros }
 (* if Assigned(MainForm.fProject) then begin
      Replace(Result, '<EXENAME>',       MainForm.fProject.Executable);
      Replace(Result, '<PROJECTNAME>',   MainForm.fProject.Name);
      Replace(Result, '<PROJECTFILE>',   MainForm.fProject.FileName);
      Replace(Result, '<PROJECTPATH>',   MainForm.fProject.Directory);
      Replace(Result, '<SOURCESPCLIST>', MainForm.fProject.ListUnitStr(' '));
  end
  { Non-project editor macros }
  else if Assigned(e) then begin
      Replace(Result, '<EXENAME>',       ChangeFileExt(e.FileName, EXE_EXT));
      Replace(Result, '<PROJECTNAME>',   e.FileName);
      Replace(Result, '<PROJECTFILE>',   e.FileName);
      Replace(Result, '<PROJECTPATH>',   ExtractFilePath(e.FileName));

      // clear unchanged macros
      Replace(Result, '<SOURCESPCLIST>', '');
  end else begin
      // clear unchanged macros
      Replace(Result, '<EXENAME>',       '');
      Replace(Result, '<PROJECTNAME>',   '');
      Replace(Result, '<PROJECTFILE>',   '');
      Replace(Result, '<PROJECTPATH>',   '');
      Replace(Result, '<SOURCESPCLIST>', '');
  end; *)

  { Editor macros }
      // clear unchanged macros
      Replace(Result, '<SOURCENAME>', '');
      Replace(Result, '<SOURCENAME>', '');
      Replace(Result, '<WORDXY>',     '');

end;

procedure TMaxForm1.PascalSchool1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
  begin
    strPCopy(URLBuf, RS_PS);
    ShellExecute(Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal)
  //from about
end;


procedure TMaxForm1.PerlSyntax1Click(Sender: TObject);
begin
  with PerlSyntax1 do
    checked:= NOT checked;
  if PerlSyntax1.Checked then begin
    memo1.Highlighter:= SynPerlSyn1;
    PerlSyntax1.Caption:= 'Pascal Syntax';
    memo2.Lines.Add('PerlSyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      PerlSyntax1.Caption:= 'Perl Syntax';
    end;
end;

procedure TMaxForm1.PHPSyntax1Click(Sender: TObject);
begin
  with PHPSyntax1 do
    checked:= NOT checked;
  if PHPSyntax1.Checked then begin
    memo1.Highlighter:= SynPHPSyn1;
    PHPSyntax1.Caption:= 'Pascal Syntax'
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      PHPSyntax1.Caption:= 'PHP Syntax';
    end;
end;

procedure TMaxForm1.PicturePuzzle1Click(Sender: TObject);
begin
  Form1Boss:= TForm1boss.Create(self);
  try
    Form1Boss.ShowModal;
  finally
    Form1Boss.Free;
  end;
   //Application.CreateForm(TForm1Boss, Form1boss);
  //start the picturepuzzle
end;


procedure TMaxForm1.DelphiSite1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
  begin
    strPCopy(URLBuf, RS_DS);
    ShellExecute(Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal)
end;

procedure TMaxForm1.DependencyWalker1Click(Sender: TObject);
begin
// go to dependency walker
   DependencyWalkerDemoMainFrm:= TDependencyWalkerDemoMainFrm.Create(self);
   try
     DependencyWalkerDemoMainFrm.ShowModal;
   finally
     DependencyWalkerDemoMainFrm.Free;
   end;
end;


procedure TMaxForm1.DLLSpy1Click(Sender: TObject);
begin
  //DLL Spy
   DLLForm1:= TDLLForm1.Create(self);
  try
    DLLForm1.ShowModal;
  finally
    DLLForm1.Free;
  end;
end;

(*procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  Clipbrd.Undo1.Enabled := memo1.CanUndo;
  Copy1.Enabled := (Edit1.SelLength > 0) and (Edit1.PasswordChar = '');
  Cut1.Enabled := Copy1.Enabled and not Edit1.ReadOnly and (Edit1.PasswordChar = '');
  Paste1.Enabled := Clipboard.HasFormat(CF_TEXT);
  Delete1.Enabled := Copy1.Enabled and not Edit1.ReadOnly;
  SelectAll1.Enabled := (Edit1.SelLength > 0) and (Edit1.SelLength < Length(Edit1.Text));
end;*)

procedure TMaxForm1.ClickinListbox2(sender: TObject);
var idx: integer;
    temp: string;
begin
  idx:= lbintflist.itemindex;
  //memo2.lines.add(lbintflist.items[idx]); debug
  lbintflist.hint:= lbintflist.Items[idx];
  showhint:= true;
  //memo1.SetFocus;
  //listbox1.items[idx]:= temp;
  //listbox1.ItemIndex:= idx;
end;



procedure TMaxForm1.ClickinListbox(sender: TObject);
var idx: integer;
    temp: string;
begin
  idx:= lbintflist.itemindex;
  //memo2.lines.add(lbintflist.items[idx]); debug
  lbintflist.hint:= lbintflist.Items[idx];
  showhint:= true;
  with FindReplDialog do begin
    //show;
    Options:= Options -[ssoReplaceAll, ssoReplace];   //bugfix 3.9.8.2
    //Close;
    //btnSearch.enabled:= false;
    FindText:= '';                    //bugfix 3.8.6.2
    //Hide;
    ReplaceText:= '';
    cbxSearch.Text:= '';
    cbxSearch.Clear;
    cbxReplace.Clear;
    cbxReplace.ClearSelection;
    Findtext:= lbintflist.Items[idx]; //'End.';
    //OnFind:= FindNextText;
    Options:= Options + [ssoEntireScope];
    FindNextText(self);
    //formdeactivate(self);
    //memo1.OnReplaceText:= NIL;
    //onreplace:= NIL;
    //Execute(false);
    //cbxSearch.Text:= '';
    //Execute(false);
  end;
  memo1.SetFocus;
  //listbox1.items[idx]:= temp;
  //listbox1.ItemIndex:= idx;
end;


procedure TMaxForm1.GetIntflistWidth(sender: TObject);
begin
  lbintflistwidth:= lbintflist.width;
  statusBar1.panels[1].text:= 'Interfacelist change: '+inttoStr(lbintflistwidth);
end;


procedure TMaxForm1.LoadInterfaceList;
var
  //  i: integer;
  AFilename: string;
  //lbintflist: TListBox;
  i, t1, t2, tstr: integer;
  s1, mstr: string;
  aStrList: TStringList;
  mysplit: TSplitter;

  begin
  aStrList:= TStringList.create;
  aStrList.loadfromfile(Act_Filename);
  //debugout.Output.Clear;
  tstr:= 0;
    mstr:= 'Interface List: '+ExtractFileName(Act_Filename) +#10;
    mstr:= mstr+ '************************************************'+#10;
    //s1:= 'first';
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('function '), uppercase(s1));
      t2:= pos(uppercase('procedure '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #13;  //+#13;
      end;
     if pos(uppercase('end.'),uppercase(s1)) > 0 then break;  //bug 3.9.3
    end;

    if javaSyntax1.Checked then begin
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('public '), uppercase(s1));
      t2:= pos(uppercase('void '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #13;
      end;
     end;
    end;
    if csyntax1.Checked then begin         //c++
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('public '), uppercase(s1));
      t2:= pos(uppercase('void '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
   end;
    if csyntax2.Checked then begin         //c#
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('public '), uppercase(s1));
      t2:= pos(uppercase('void '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
   end;

  lbintflist:= TListBox.Create(self);
  mysplit:= TSplitter.Create(lbintflist);
  mysplit.parent:= maxForm1;
  mysplit.OnMoved:= GetIntflistWidth;
  mysplit.Align:= alRight;
  //AFilename := ExtractFilePath(Application.Exename) + 'SkipList.txt';
  try
  if FileExists(Act_Filename) then begin
    with lbintfList do begin
      Parent:= maxForm1;
      Align:= alRight;
      popupMenu:= popintflist;
      width:= lbintflistwidth; //default: 350; //scalable, done with splitter and font
      //width:= (memo1.Width-memo1.RightEdge);
      //width:= (memo1.Width-600);
      //showmessage(inttostr(memo1.Width)+' '+inttostr(memo1.RightEdge));
      //scrollbars:= ssboth;
      autoscroll:= true;
      Font.Size:= last_fontsize-2;
      onDblClick:= ClickinListbox;
      onClick:= Clickinlistbox2;
      //onMouseMove
      //onResize:=  GetIntflistWidth;
      //SetBounds(0,0,200,400);
      Sorted:= false;
      //Items.LoadFromFile(AFilename);
      Items.Text:= mstr;
    {    for i := lbSkipList.Items.Count - 1 downto 0 do
        begin
          lbSkipList.Items[i] := ExtractFileName(ChangeFileExt(lbSkipList.Items[i], ''));
          if lbSkipList.Items[i] = '' then
            lbSkipList.Items.Delete(i);
        end; }
      //Sorted:= true;
    end;
    //lbskiplist.ShowModal;
  end;
  finally
    aStrList.Free;
    //lbskiplist.Free;
  end;
end;


procedure TMaxForm1.LoadInterfaceList2;
begin
  if NOT assigned(lbintflist) then begin
   LoadInterfaceList;
   intfnavigator1.checked:= true;
  end;
end;

procedure TMaxForm1.DMathLibrary1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\dmath_manual.pdf');
end;

procedure TMaxForm1.DocuforAddOns1Click(Sender: TObject);
begin
   ShowMessage('Add Ons Docu available in V4')
end;

procedure TMaxForm1.PlayMP31Click(Sender: TObject);
begin
    Application.CreateForm(TwinFormp, winFormp);
  //winformp.show;// this is play
end;

procedure TMaxForm1.GetEMails1Click(Sender: TObject);
begin
  GetMailHeaders;
end;

Function TMaxForm1.GetStatChange: boolean;
begin
  result:= STATEdchanged;
end;

Function TMaxForm1.GetActiveLineColor: TColor;
begin
  result:= factivelinecolor;
end;

Procedure TMaxForm1.SetActiveLineColor(acolor: TColor);
begin
  factivelinecolor:= acolor;
end;


Function TMaxForm1.GetStatExecuteShell: boolean;
begin
  result:= StatExecuteShell;
end;

procedure TMaxForm1.GetWidth(sender: TObject);
begin
end;

procedure TMaxForm1.GotoEnd1Click(Sender: TObject);
begin
  with FindReplDialog do begin
  FindText:='';                    //bugfix 3.8.6.2
  //FindText:=' ';                    //bugfix 3.8.6.2
  ReplaceText:= '';
   //cbxSearch.Clear;
   cbxReplace.Clear;
    Findtext:= 'End.';
    //OnFind:= FindNextText;
    FindNextText(self);
    //Execute(false);
  end;
  //goto code end
end;

procedure TMaxForm1.GotoLine1Click(Sender: TObject);
var lnumb: string;
begin
  try
  if InputQuery('Line Number Input', 'Goto Line Number:',lnumb) then begin
       memo1.GotoLineAndCenter(strToInt(lnumb));
       memo1.ActiveLineColor:= clYellow;
  end;
  statusBar1.panels[2].text:= 'G' +lnumb;
  except
    Showmessage('Please Enter a valid number!');
  end;
end;

procedure TMaxForm1.ThreadDemo1Click(Sender: TObject);
begin
  StartThreadDemo;
   {with TThreadSortForm.Create(self) do begin
      label1.caption:= 'Bubble Sort down up';
      show;
   end;}
end;

procedure TMaxForm1.ToDoList1Click(Sender: TObject);
var ViewToDoForm: TViewToDoForm;
begin
  //to do form devcc
  ViewToDoForm:= TViewToDoForm.Create(self);
  try
    ViewToDoForm.ShowModal;
  finally
    ViewToDoForm.Free;
  end;

end;

Procedure TMaxForm1.SetStatChange(vstat: boolean);
begin
  STATEdchanged:= vstat;//
end;

procedure TMaxForm1.LoadLastFile1Click(Sender: TObject);
var templastfile: string;
//  {$WriteableConst On}
//const toogle1 = true;
begin
  if STATedchanged then begin        //bugfix 3.8
     sysutils.beep;
     if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
       Save2Click(self)
     else begin
       STATEdchanged:= false;
       statusBar1.panels[2].text:= ' SM';
       memo2.Lines.Add('Change not saved '+Act_Filename);
     end;
   end;
  memo1.Lines.LoadFromFile(last_fName);
  templastfile:= Act_Filename;
  Act_Filename:= last_fName;
  last_fName:= templastfile;
  loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
  memo2.Lines.Add(extractFileName(last_fName) +' '+ BEFOREFILE);
  statusBar1.panels[0].text:= Act_Filename +' '+ FILELOAD;
  memo2.Lines.Add(extractFileName(Act_Filename) +' '+ FILELOAD);
  //CB1SCList.Items.ValueFromIndex
  //if Act_Filename <> CB1SCList.items[CB1SCList.ItemIndex-1] then
  CB1SCList.Items.Add((Act_Filename));   //3.9.3 wb
  //CB1SCList.ItemIndex:= CB1SCList.Items.IndexOfName(Act_FileName)-1;
  //STATlastfile:= Not STATlastfile;        //big think to sync history
  //CB1SCList.Items[CB1SCList.Items.Count]:= last_fName;
  CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
  {if STATLastfile then
    CB1SCList.ItemIndex:= CB1SCList.Items.Count-2 else
    CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;}
end;

procedure TMaxForm1.Memo1Change(Sender: TObject);
begin
  STATedchanged:= true;
  memo1.Refresh; //2.8.1
  //debug statusBar1.SimpleText:= ' editior changed';
  statusBar1.panels[2].text:= ' M!'+' T:'+intToStr(numprocessthreads);
end;


procedure TMaxForm1.ShowWords(mystring: string);
var
  i, t1, t2, tstr: integer;
  s1, mstr: string;
  aStrList: TStringList;
begin
  aStrList:= TStringList.create;
  aStrList.loadfromfile(Act_Filename);
  debugout.Output.Clear;
  //debugout.output.Lines.Text:= 'Code Words List';
  tstr:= 0;
  try
    mstr:= 'Code Words List:'+#10+#13;
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase(mystring), uppercase(s1));
      if (t1) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
     if pos(uppercase('end.'),uppercase(s1)) > 0 then break;  //bug 3.9.3
    end;
  debugout.output.Font.Size:= 12;
  debugout.output.Lines.Text:= mstr;
  debugout.caption:= 'Words List in Code Line Change';
  debugout.output.Lines.Add(inttoStr(tstr)+' Words Found per Line/Substring: ' +
                                     ExtractFileName(Act_Filename));
  debugout.visible:= true;
  finally
    aStrList.Free;
  end;
end;


procedure TMaxForm1.Memo1DblClick(Sender: TObject);  //beta 3
var fw, s1: string;
  t1, cfound: integer;
  //oldcolor, selcolor: TSynSelectedColor;
   mbuffer: TBufferCoord;
   mysyn: TSynAnySyn;
  //CmntSet: TCommentStyles;
  oldhighlight: TSynCustomHighlighter;
begin
  //search for same words links
  oldhighlight:= memo1.Highlighter;
  memo2.Lines.Add('highlighter dat: '+oldhighlight.GetLanguageName);

  mysyn:= TSynAnySyn.create(self);
  fmemoclick:= Not fmemoclick;
  cfound:= 0;
  if fmemoclick then begin
   memo1.Highlighter:= mysyn;
   fw:= memo1.WordAtCursor;
   //mysyn.Objects.Add(uppercase(fw));
   mysyn.Constants.Add(uppercase(fw));
   //FactiveLine:= memo1.CaretY;
     //memo1.setSelword;
   tmpcodestr:= fw;
   //oldcolor:= memo1.SelectedColor;
    memo1.GetPositionOfMouse(mbuffer);
    //memo1.setwordblock(mbuffer);
    if editreplace1.Checked then
      cfound:= memo1.searchReplace(fw,Uppercase(fw),[ssoWholeWord,ssoEntireScope,ssoReplaceAll])
    else
    //cfound:= memo1.searchReplace(fw,'',[ssoWholeWord,ssoEntireScope]);
    //cfound:= memo1.searchReplace(fw,'',[ssoWholeWord,ssoEntireScope]);
    if STATActiveyellow then
       cfound:= memo1.searchReplace(fw,fw,[ssoWholeWord,ssoEntireScope,ssoReplaceAll])
    else
       cfound:= memo1.searchReplace(fw,'',[ssoWholeWord,ssoEntireScope]);

    //memo1.GetPositionOfMouse(mbuffer);
   // memo1.setwordblock(mbuffer);
    ShowWords(fw);

  { for i:= 0 to memo1.Lines.Count -1 do begin
      s1:= memo1.lines[i];
      t1:= pos(fw, s1);
      if t1 > 0 then begin
        //oldcolor.Background:= clyellow;
        Delete(s1, t1, Length(fw));
        //Insert('¶'+Uppercase(fw), s1, t1);
        Insert(Uppercase(fw), s1, t1);
        memo1.lines[i]:= s1;
        inc(cfound);
       //found at
      end;
   end; }
   memo1.hint:= fw +' found words: '+inttoStr(cfound)+' ';
   memo2.Lines.Add(fw +' cfound: '+inttoStr(cfound)+' ');
   statusBar1.panels[1].text:= fw +' found words: '+inttoStr(cfound)+' ';
  end else begin

  mysyn.Constants.clear;
   {SynAnySyn.KeyWords.Clear;
   SynAnySyn.Objects.Clear;
   SynAnySyn.Constants.Clear;}
  //memo1.Highlighter:= oldhighlight;
   if NOT STATOtherHL then
     memo1.Highlighter:= SynPasSyn1;
  mysyn.Free;
  //memo1.Highlighter.LanguageName:= oldhighlight.GetLanguageName;

  fw:= memo1.WordAtCursor;
   memo1.GetPositionOfMouse(mbuffer);
    //memo1.setwordblock(mbuffer);
   //FactiveLine:= memo1.CaretY;
  if editreplace1.Checked then begin
   cfound:= memo1.searchReplace(fw,tmpcodestr,[ssoWholeWord,ssoEntireScope,ssoReplaceAll]);
   // else
   //cfound:= memo1.searchReplace(fw,fw,[ssoWholeWord,ssoEntireScope,ssoReplaceAll]);
   statusBar1.panels[1].text:= fw +' foundback2: '+inttoStr(cfound)+' ';
    //memo1.setwordblock(mbuffer);
   memo2.Lines.Add(fw +' foundback2: '+inttoStr(cfound)+' ');
   tmpcodestr:='';
   ShowWords(fw);

  end else begin
   cfound:= memo1.searchReplace(fw,fw,[ssoWholeWord,ssoEntireScope]);
   statusBar1.panels[1].text:= fw +' found: '+inttoStr(cfound)+' ';
    //memo1.setwordblock(mbuffer);
   memo2.Lines.Add(fw +' found: '+inttoStr(cfound)+' ');
   end;
  { for i:= 0 to memo1.Lines.Count -1 do begin
      s1:= memo1.lines[i];
      t1:= pos(fw, s1);
      if t1 > 0 then begin
        //oldcolor.Background:= clyellow;
        //Delete(s1, t1-1, Length(fw)+1);
        Delete(s1, t1, Length(fw));
        Insert(tmpcodestr, s1, t1);
        //Insert(tmpcodestr, s1, t1-1);
        memo1.lines[i]:= s1;
      end;
    end; }
  end;
end;

procedure TMaxForm1.Memo1GutterClick(Sender: TObject; Button: TMouseButton; X, Y,
  Line: Integer; Mark: TSynEditMark);
var  p: TBufferCoord;
   aline, i: integer;
    amark: TSynEditMark;
    marksmemo: TSynEditMarklist;     //of memo
    marks: TSynEditLineMarks;
    foundbm: boolean;
    mbuffer: TBufferCoord;
 begin
//if cbOther.Checked then
  //  LogEvent('OnGutterClick');
  //memo1.CaretY:= Line;
  //if not assigned(mark) then begin // place first mark
    //SpeedButton1.Down := true;
    //SpeedButton1.Click;
  //end else
  //if (not mark.IsBookmark) and (mark.ImageIndex >= SpeedButton1.Tag) then begin
    //if mark.ImageIndex = SpeedButton5.Tag then begin // remove mark
      //SpeedButton5.Down := false;
      //SpeedButton5.Click;
    //end else
  //m: TSynEditMark;
//begin
  //if chkBookMark.Checked
  //then begin
  //Mark.InternalImage:= true;
  // memo1.SetBookMark(1, 1, 1);
  // memo1.OnDblClick:= NIL;

   aline:= memo1.CaretY;
    memo1.SetBookMark(1, X, Y);
   foundbm:= false;

   //memo1.Marks.GetMarksForLine(memo1.CaretY, marks);
    //if Marks[i].Line = aline then
     //memo2.lines.Add('found marks delete bookmark at: '+inttoStr(aline));
   // memo1.Highlighter:= SynPasSyn1;

  for i:= 0 to memo1.Marks.Count-1 do
   if memo1.Marks[i].Line = aline then begin
     memo1.Marks[i].visible:= false;
     memo1.Marks[i].Line:= 0;
     memo1.Marks.ClearLine(aline);
     //memo2.lines.Add('found delete bookmark at: '+inttoStr(aline));
     statusBar1.panels[1].text:= 'found del bookmark: '+inttoStr(aline)+' ';
     foundbm:= true;
     //memo1.Gutter.DigitCount:= 5;
     //memo1.UpdateCaret;
     memo1.Marks[i].visible:= true;
     break;
     //memo1.Marks[i].Free;
     //memo1.Marks.Remove(memo1.Marks[i]);
     //memo1.Marks[i]:= NIL;
     //memo1.Gutter.Color:= claqua;
    end;

    // memo1.setwordblock(mbuffer);
    //foundbm:= false;

  if NOT foundbm then begin
   //if Mark.IsBookmark then
     //memo1.Marks.Remove(mark);
     //memo1.Marks.ClearLine(aline);
   // else begin
   //if Mark.IsBookmark then
   // Mark.InternalImage:= true;       //cbInternalImages.Checked;
    //aMark:= TSynEditMark.Create;
     with aMark do begin
        Line:= aLine;
        //Char:= p.char;
        ImageIndex:= bookmarkimage;//(Sender as TSpeedButton).Tag;  10-13
        Visible:= TRUE;
        //InternalImage:= BookMarkOptions.BookMarkImages = nil;
      end;
    //memo1.Marks.Add(amark);
  end;
   //memo1.SetBookMark(1, 1, 1);
   //memo1.OnDblClick:= Memo1DblClick;
  //  memo1.Highlighter:= SynPasSyn1;
   // if NOT STATOtherHL then
     // memo1.Highlighter:= SynPasSyn1;

    //memo1.Marks.Add()
  {else begin
    m := TSynEditMark.Create(SynEdit1);
    m.Line := SpinLine.Value;
    m.ImageList := ImageList1;
    m.ImageIndex := spinImg.Value;
    m.Visible := true;
    SynEdit1.Marks.Add(m);
  end;}
    //Mark:= TSynEditMark.Create;
     { with Mark do begin
        //Line:= p.Line;
        //Char:= p.Char;
        ImageIndex:= mark.ImageIndex + 1;//(Sender as TSpeedButton).Tag;
        Visible := TRUE;
        //InternalImage:= BookMarkOptions.BookMarkImages = nil;
      end; }
   // mark.BookmarkNumber;
  //  memo2.lines.Add('bookmark is setting at line: '+inttoStr(line));
  //ResetMarkButtons;
end;

procedure TMaxForm1.Memo1PlaceBookmark(Sender: TObject;
                                           var Mark: TSynEditMark);
var aline, i: integer;
    amark: TSynEditMark;
    p: TBufferCoord;
    marks: TSynEditMarklist;
    foundbm: boolean;
begin
  //need a list of bitmaps
   //memo2.lines.Add('place bookmark setting debug');
   //aline:= memo1.CaretY;

   //if Mark.IsBookmark then
     //memo1.Marks.Remove(mark);
      //memo1.Marks.ClearLine(aline);

   //memo1.marks.GetMarksForLine(aline, marks);
   //foundbm:= false;
   //for i:= 0 to memo1.Marks.Count-1 do
   //  if memo1.Marks[mark.Line].Line = aline then begin
     //if mark.isBookmark then begin

  { for i:= 0 to memo1.Marks.Count-1 do
     if memo1.Marks[i].Line = aline then begin
     memo1.Marks[i].visible:= false;
     memo1.Marks[i].Line:= 0;
     memo2.lines.Add('found bookmark at '+inttoStr(aline));
    foundbm:= true;

     //memo1.Marks[i].Free;
     //memo1.Marks.Remove(memo1.Marks[i]);
     //memo1.Marks[i]:= NIL;
    end;}
    // memo1.Marks.Free;

 (* if NOT foundbm then begin
   if Mark.IsBookmark then
     //memo1.Marks.Remove(mark);
     memo1.Marks.ClearLine(aline);
   // else begin
 //if Mark.IsBookmark then
   // Mark.InternalImage:= true;       //cbInternalImages.Checked;
    aMark:= TSynEditMark.Create;
     with aMark do begin
        Line:= aLine;
        //Char:= p.char;
        ImageIndex:= bookmarkimage;//(Sender as TSpeedButton).Tag;  10-13
        Visible := TRUE;
        //InternalImage:= BookMarkOptions.BookMarkImages = nil;
      end;
    memo1.Marks.Add(amark);
  end; *)
   //memo1.SetBookMark(mark.BookmarkNumber+1, 0, 2);
  // memo1.SetBookMark(mark.BookmarkNumber+2, 0, aline);

end;

//-----------------------------------------Debug-----------------------------//
function TMaxForm1.CompileDebug: Boolean;
var
  i: Longint;
begin
  cedebug.Script.Assign(memo1.Lines);
  Result:= cedebug.Compile;
  //result:= PSScript.Compile;
  memo2.Clear;
  for i:= 0 to cedebug.CompilerMessageCount -1 do begin
    memo2.lines.Add(cedebug.CompilerMessages[i].MessageToString);
  end;
  if Result then begin
    memo2.lines.Add('Succesfully compiled/decompiled');
    statusBar1.panels[0].text:= Act_Filename +' in ---debug mode--- '+ FILELOAD
  end;
end;


procedure TMaxForm1.ComponentCount1Click(Sender: TObject);
var
  complist: TStringList;
begin
  //Apploop_tester;
  comp_count:= 0;  //in winform1puzzle
  complist:= TStringList.create;
  dumpComponents(application, complist);
  //for count:= 0 to complist.count -1 do
     //writeln(complist.strings[count])
    debugout.Caption:= 'Component Count Output';
    debugout.Font.Size:= 12;
    debugout.output.Lines.Text:= complist.Text;
    debugout.output.Lines.Add('Component Count of maXbox: ' + MBVERSION);
    debugout.visible:= true;
  complist.Free;
end;

function TMaxForm1.ExecuteDebug: Boolean;
begin
  debugout.Output.Clear;
  if cedebug.Execute then begin
  //if PSScript.Execute then begin
    memo2.lines.Add('Succesfully Execute/Debuged...');
    Result:= True;
  end else begin
    memo2.lines.Add('Debug Runtime Error: '+cedebug.ExecErrorToString +
    ' at ['+IntToStr(cedebug.ExecErrorRow)+':'+IntToStr(cedebug.ExecErrorCol)+'] bytecode pos:'+
    inttostr(cedebug.ExecErrorProcNo)+':'+inttostr(cedebug.ExecErrorByteCodePosition));
    Result:= False;
  end;
end;

procedure TMaxForm1.Decompile1Click(Sender: TObject);
 var
  s: string;
begin
  lineToNumber(false);
  if CompileDebug then begin
   cedebug.GetCompiled(s);
    IFPS3DataToText(s, s);
    debugout.Caption:= 'Debug Decompile Output';
    debugout.output.Lines.Text:= s;
    debugout.output.Lines.Add('Decompiled Code maXbox: ' +
                                     ExtractFileName(Act_Filename));
    debugout.visible:= true;
  end;
end;

procedure TMaxForm1.Defactor1Click(Sender: TObject);
begin
  Showmessage('yeah, will be in V4');
end;

procedure TMaxForm1.StepInto1Click(Sender: TObject);
begin
  if cedebug.Exec.Status = isRunning then
    cedebug.StepInto
  else begin
    memo1.Gutter.LeadingZeros:= true; //2.8
    if CompileDebug then begin
      cedebug.StepInto;
      ExecuteDebug;
    end;
  end;
end;

procedure TMaxForm1.StepOut1Click(Sender: TObject);
begin
if cedebug.Exec.Status = isRunning then
    cedebug.StepOver
  else begin
    if CompileDebug then begin
      cedebug.StepInto;
      ExecuteDebug;
    end;
  end;
end;


procedure TMaxForm1.SyntaxCheck1Click(Sender: TObject);
//var mybytecode: string;
  procedure OutputMessages;
  var
    l: Longint;
    b: Boolean;
    m: string;
  begin
    b:= False;
    if STATSavebefore then
      if fileexists(Act_Filename) then
        Save2Click(sender)
      else
        showMessage('Load PascalScript first or - File Open/Save...');
    for l:= 0 to PSScript.CompilerMessageCount - 1 do begin
      m:= psscript.CompilerMessages[l].MessageToString;
      memo2.Lines.Add('PSXCompiler: '+PSScript.CompilerErrorToStr(l)+#13#10 +m);
      if (not b) and (PSScript.CompilerMessages[l] is TIFPSPascalCompilerError)
      then begin
        b:= True;
        memo1.SelStart:= PSScript.CompilerMessages[l].Pos;
      end;
    end
  end;
begin
  memo2.Lines.Clear;
  memo1.Highlighter:= SynPasSyn1;   //3.9.9
  imglogo.Transparent:= false;
  lineToNumber(false);
  Slinenumbers1.Checked:= false;
  PSScript.MainFileName:= Act_Filename;
  PSScript.Script.Assign(memo1.Lines);
  cedebug.MainFileName:= Act_Filename;
  cedebug.Script.Assign(memo1.Lines);
  if STATCodefolding then
     memo1.ReScanForFoldRanges;              //new4
   maxForm1.Caption:= 'maXbox3 Sol mX4+  '+ExtractFilename(Act_Filename);  //new4

  //showmessage(psscript.script.Text);
  if STATMacro then begin
        //memo1.text:= ParseMacros(memo1.text);
        //Parsemacros(memo1.text);
        Expand_Macro;
  end;
  memo2.Lines.Add('Syntax Check Start '+RCSTRMB +inttostr(memo1.Lines.count-1)+' lines');
  //TPSPascalCompiler transforms to bytecode
  if PSScript.Compile then begin
    OutputMessages;
    memo2.Lines.Add(RCSTRMB +extractFileName(Act_Filename)+' Syntax Check done: '
                                                         +dateTimetoStr(now()));
    memo2.Lines.Add('--------------------------------------------------------');
    statusBar1.panels[0].text:= RCSTRMB +extractFileName(Act_Filename)+' Syntax Check done: '
                                                         +dateTimetoStr(now());
    memo1.Hint:= memo1.WordAtCursor +': '+memo1.WordAtMouse;
  end else begin
    OutputMessages;
    memo2.Lines.Add('Syntax Check not completed');
  end;
  //scheck....
  //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
  //CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
   if intfnavigator1.checked then begin
     IntfNavigator1Click(Self);
     IntfNavigator1Click(Self);
    //SetInterfacesMarks(Act_Filename);
   end;
    SetInterfacesMarks2(Act_Filename);
     //SetInterfacesMarks(Act_Filename);
  if memo1.lines.count > 10000 then memo1.Gutter.DigitCount:= 7;

end;

procedure TMaxForm1.Reset1Click(Sender: TObject);
begin
if cedebug.Exec.Status = isRunning then
    cedebug.Stop;
     memo2.Lines.Add('Runtimer Debug Reset');
end;

procedure TMaxForm1.ResourceExplore1Click(Sender: TObject);
begin
  tbtn6resClick(self)
  //to do
end;

procedure TMaxForm1.cedebugAfterExecute(Sender: TPSScript);
begin
//Caption:= 'Editor';
  FActiveLine:= 0;
  memo1.Refresh;
  memo1.Gutter.LeadingZeros:= false; //2.8
end;

procedure TMaxForm1.cedebugBreakpoint(Sender: TObject;
                const FileName: String; Position, Row, Col: Cardinal);
begin
FActiveLine:= Row;
  if (FActiveLine < memo1.TopLine +2) or
        (FActiveLine > memo1.TopLine + memo1.LinesInWindow -2) then begin
    memo1.TopLine := FActiveLine - (memo1.LinesInWindow div 2);
  end;
  memo1.CaretY:= FActiveLine;
  memo1.CaretX:= 1;
  memo1.Refresh;
// this is debug
end;

procedure TMaxForm1.cedebugCompile(Sender: TPSScript);
begin
// this is just for test and runtime
  Sender.AddRegisteredVariable('Self', 'TForm');
  Sender.AddRegisteredVariable('Application', 'TApplication');
  Sender.AddRegisteredVariable('Screen', 'TScreen');
  Sender.AddRegisteredVariable('maxForm1', 'TMaxForm1');
  Sender.AddRegisteredVariable('Memo1', 'TSynMemo');
  Sender.AddRegisteredVariable('memo2', 'TMemo');
  Sender.AddRegisteredVariable('debugout', 'Tdebugoutput');  //!!
end;

procedure TMaxForm1.cedebugExecute(Sender: TPSScript);
begin
  cedebug.SetVarToInstance('SELF', Self);
  cedebug.SetVarToInstance('APPLICATION', Application);
  cedebug.SetVarToInstance('Screen', Screen);
  //PSScript.SetPointerToData('Memo1', @Memo1, PSScript.FindNamedType('TSynMemo'));
  cedebug.SetVarToInstance('memo1', memo1);
  cedebug.SetVarToInstance('memo2', memo2);
  cedebug.SetVarToInstance('maxForm1', maxForm1);
  cedebug.SetVarToInstance('debugout', debugout);
end;

procedure TMaxForm1.cedebugIdle(Sender: TObject);
begin
 Application.HandleMessage;
  if FResume then begin
    FResume:= False;
    cedebug.Resume;
    FActiveLine:= 0;
    memo1.Refresh;
  end;
end;

procedure TMaxForm1.cedebugLineInfo(Sender: TObject;
              const FileName: String; Position, Row, Col: Cardinal);
begin
  if cedebug.Exec.DebugMode <> dmRun then begin
    FActiveLine:= Row;
    if (FActiveLine < memo1.TopLine +2) or
           (FActiveLine > memo1.TopLine + memo1.LinesInWindow -2) then begin
      memo1.TopLine:= FActiveLine - (memo1.LinesInWindow div 2);
    end;
    memo1.CaretY:= FActiveLine;
    memo1.CaretX:= 1;
    memo1.Refresh;
  end;
end;

procedure TMaxForm1.Memo1SpecialLineColors(Sender: TObject; Line: Integer;
  var Special: Boolean; var FG, BG: TColor);
begin
  cedebug.MainFileName:= Act_Filename;
  if cedebug.HasBreakPoint(cedebug.MainFileName, Line) then begin
    Special:= True;
    if Line = FActiveLine then begin
      BG:= clWhite;
      FG:= clRed;
    end else begin
      FG:= clWhite;
      BG:= clRed;
    end;
  end else
  if Line = FActiveLine then begin
    Special:= True;
    FG:= clWhite;
    bg:= clBlue;
  end else Special:= False;
  {if fmemoclick then begin
    Special:= True;
    if Line = FActiveLine then begin
      BG:= clWhite;
      FG:= clyellow;
    end else begin
      FG:= clWhite;
      BG:= clyellow;
    end;
  end;}
end;


procedure TMaxForm1.BreakPointMenuClick(Sender: TObject);
var
  Line: Longint;
begin
  Line:= memo1.CaretY;
  if cedebug.HasBreakPoint(cedebug.MainFileName, Line) then
    cedebug.ClearBreakPoint(cedebug.MainFileName, Line)
  else
    cedebug.SetBreakPoint(cedebug.MainFileName, Line);
  memo1.Refresh;
end;

procedure TMaxForm1.btnClassReportClick(Sender: TObject);
var
  s,ss, s1, mstr: string;
  aStrList: TStringList;
  i, t1, t2, tstr: integer;
begin
  Showmessage('Interface and Unit Report will be in V4.0');
  aStrList:= TStringList.create;
  debugout.Output.Clear;
  tstr:= 0;
  lineToNumber(false);
  if CompileDebug then begin
   cedebug.GetCompiled(s);
    IFPS3DataToText(s, ss);
  try
   aStrList.text:= ss;
    mstr:= ('*************Class Report**************')+ #10+#13;
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('class '), uppercase(s1));
      t2:= pos(uppercase('class:'), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
  debugout.output.Font.Size:= 12;
  debugout.output.Lines.Text:= mstr;
  debugout.caption:= 'Class Report List in Code';
  debugout.output.Lines.Add(inttoStr(tstr)+' Class Found: ' +
                                     ExtractFileName(Act_Filename));
  debugout.visible:= true;
  finally
    aStrList.Free;
  end;
 end;
end;


procedure TMaxForm1.BtnZoomMinusClick(Sender: TObject);
begin
  memo1.Font.Size:= memo1.Font.Size-1;
  last_fontsize:= memo1.Font.Size;
end;

procedure TMaxForm1.BtnZoomPlusClick(Sender: TObject);
begin
// fonstsize
  memo1.Font.Size:= memo1.Font.Size+1;
  last_fontsize:= memo1.Font.Size;
end;

procedure TMaxForm1.Calculator1Click(Sender: TObject);
begin
  SearchAndOpenDoc('C:\WINDOWS\System32\calc.exe');
end;

procedure TMaxForm1.CB1SCListChange(Sender: TObject);
var idx, old: integer;
   temps: string;
begin
  //test the prototype    for mX3.9.3        //mX3.8.6.2
    if STATedchanged then begin        //bugfix 3.8
     sysutils.beep;
     if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
       Save2Click(self)
     else begin
       STATEdchanged:= false;
       statusBar1.panels[2].text:= ' SM';
       memo2.Lines.Add('Change not saved '+Act_Filename);
     end;
   end;

  idx:= CB1SCList.itemIndex;  //choice
  if CB1SCList.items[idx] <> Act_Filename then begin
    last_fName:= Act_Filename;
    memo2.Lines.Add(extractFileName(last_fName) + BEFOREFILE);    //beta
    loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
    //b idx:= CB1SCList.itemIndex;
   //CB1SCList.itemIndex:= idx;
  //idx:= CB1SCList.itemIndex;  //choice
  try
    Act_Filename:= CB1SCList.items[idx];
    memo1.Lines.LoadFromFile(Act_Filename);
   {old:= idx;
   temps:= CB1SCList.items[CB1SCList.Items.Count-2];
   CB1SCList.items[CB1SCList.Items.Count-2]:= CB1SCList.items[old];
   CB1SCList.items[old]:= temps;
   CB1SCList.itemIndex:= CB1SCList.Items.Count-2;  //choice}
    with CB1SCList do begin
      temps:= items[idx];
      items[idx]:= items[Items.Count-2];
      items[Items.Count-2]:= items[Items.Count-1];
      items[Items.Count-1]:= temps;
     end;
   CB1SCList.itemIndex:= CB1SCList.Items.Count-1;  //choice !!!
    {templastfile:= Act_Filename;
    Act_Filename:= last_fName;
    last_fName:= templastfile;}
    statusBar1.panels[0].text:= Act_Filename +' '+ FILELOAD;
    memo2.Lines.Add(extractFileName(Act_Filename) +' '+ FILELOAD);
    //memo2.Lines.add('mX file load: '+Act_Filename);
  except
    Showmessage('Invalid File Path - Please Set <File Open/Save As...>');
  end;
  end;
  //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
  //CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;  *)
  //idx:= CB1SCList.itemIndex;
  //memo2.Lines.add('mX file changed to: '+CB1SCList.items[idx]);
   //end else
   //memo2.Lines.add('mX file same file loaded: '+CB1SCList.items[idx]);
   if intfnavigator1.checked then begin
     IntfNavigator1Click(Self);
     IntfNavigator1Click(Self);
    end;
  memo1.SetFocus;
end;

procedure TMaxForm1.CB1SCListDrawItem(Control: TWinControl; Index: Integer; aRect: TRect;
  State: TOwnerDrawState);
begin
  //CB1SCList.Canvas.TextRect(ARect,ARect.Left+2,
    //              ARect.Top,ExtractFileName(CB1SCList.Items[Index]));
  //CB1SCList.Canvas.FillRect(aRect);
  aRect.Right:= aRect.Left + 16;
  CB1SCList.Canvas.TextOut(aRect.Right+2, aRect.Top+2,
     IntToStr(Index)+'  '+ExtractFileName(CB1SCList.Items[Index]));
  CB1SCList.hint:= CB1SCList.Items[Index];
  showhint:= true;
  if Index mod 2 = 0 then
    CB1SCList.Canvas.Brush.Color:= clPurple//clNavy           //clPurple
  else
    CB1SCList.Canvas.Brush.Color:= clSilver; //clTeal; clLime
  CB1SCList.Canvas.FillRect(aRect);
end;

procedure TMaxForm1.DebugRun1Click(Sender: TObject);
begin
 if cedebug.Running then begin
    FResume:= True
  end else begin
    if CompileDebug then
      ExecuteDebug;
     memo2.Lines.Add('Debug ReRun during Runtime');
  end;
end;

procedure TMaxForm1.StatusBar1DblClick(Sender: TObject);
begin
  if statedChanged = false then
  statusBar1.panels[0].text:=
       ExtractFilePath(application.ExeName)+' exe directory'
  else
    statusBar1.panels[0].text:= ExtractFilePath(Act_Filename) +' file directory';
end;

procedure TMaxForm1.PSScriptLine(Sender: TObject);
begin
  //PSScript.online:= , doesn't hang while long running
  Application.ProcessMessages;
  //memo2.lines.Add('runtime is running test');
end;

procedure TMaxForm1.OpenDirectory1Click(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists(ExtractFilePath(Act_Filename)) then begin
    sOName:= ExtractFilePath(Act_Filename) + #0;
    sEName:= 'explorer.exe';
    ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
  end else
    showMessage('No Example Workdirectory found...');
end;

procedure TMaxForm1.OpenExamples1Click(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists(ExePath+'\examples') then begin
    sOName:= ExtractFilePath(ExePath+'examples\') + #0;
    sEName:= 'explorer.exe';
    ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
  end else
    showMessage('No Standard Examples found...');
end;

procedure TMaxForm1.procMessClick(Sender: TObject);
begin
   procMess.Checked:= not procMess.Checked;
   if procMess.Checked then PSScript.OnLine:= maxForm1.PSScriptLine else
   PSScript.OnLine:= NIL;
end;

procedure TMaxForm1.tbtn6resClick(Sender: TObject);
var
 //TmpExeFile: TExeImage;
 rcfrm: TRCMainForm;
begin
 rcFrm:= TRCMainForm.Create(NIL);
 with rcFrm do begin
   try
    {with FileOpenDialog do begin
      if not Execute then Exit;
      TmpExeFile:= TExeImage.CreateImage(Self, ExePath+'maxbox3.exe');
      if Assigned(FExeFile) then FExeFile.Destroy;
      FExeFile:= TmpExeFile;
    end; }
     // FExeFile:= TExeImage.CreateImage(rcFrm, ExePath+'maxbox3.exe');
    //  DisplayResources;
      showModal;
      statusBar1.panels[0].text:= ' mX Resources loaded!';
    finally
      Release;
      Free;
      statusBar1.panels[0].text:= 'Resource Explorer closed';
    end;
  end;
end;

procedure TMaxForm1.tbtnUseCaseClick(Sender: TObject);
var newNameExt, ucFile: string;
begin
  with TUCMainDlg.create(application) do begin
    try
      newNameExt := ChangeFileExt(Act_Filename, '.uc');
      if fileexists(newNameExt) then begin
        ucFile:= newNameExt;
        //SetCodeFileName(ucFile);
        TmCustomShape.LoadFromFile(ucFile, ScrollBox1);
        statusBar1.panels[0].text:= ExtractFileName(ucFile)+' : Code & Model ready!';
      end;
      SetCodeFileName(newNameExt);
      showModal;
      statusBar1.panels[0].text:= 'UC Dialog active';
    finally
      release;
      Free;
      statusBar1.panels[0].text:= 'UC Dialog closed';
    end;
  end;
  //this is stack attack
  //fix it with a cast
end;


procedure TMaxForm1.Halt1Click(Sender: TObject);
begin
  //stop the app
  StepInto1Click(sender);
  memo2.Lines.Add('Program stopped: '+inttoStr(memo1.LinesInWindow));

end;

procedure TMaxForm1.HEXEditor2Click(Sender: TObject);
begin
  Showmessage('available in V4');
end;

procedure TMaxForm1.HEXView1Click(Sender: TObject);
begin
   Showmessage('available in V4');
  {HexDump := CreateHexDump(TWinControl(NoteBook.Pages.Objects[3]));
  FileOpenDialog.Filter := SOpenFilter;
  FileSaveDialog.Filter := SSaveFilter;
  Small.ResourceLoad(itBitmap, 'SmallImages', clOlive);
  Large.ResourceLoad(itBitmap, 'LargeImages', clOlive);
  Notebook.PageIndex := 0;
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
  begin
    Show;
    FExeFile := TExeImage.CreateImage(Self, ParamStr(1));
    DisplayResources;
  end;}
      //  HexDump.Address := R.RawData;
      //  HexDump.DataSize := R.Size;
      //  Notebook.PageIndex := 3;
end;

procedure TMaxForm1.HTMLSyntax1Click(Sender: TObject);
begin
  with HTMLSyntax1 do
    checked:= NOT checked;
  if HTMLSyntax1.Checked then begin
    memo1.Highlighter:= SynHTMLSyn1;
    HTMLSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('HTMLSyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      HTMLSyntax1.Caption:= 'HTML Syntax';
    end;
end;


procedure TMaxForm1.texSyntax1Click(Sender: TObject);
begin
  with TexSyntax1 do
    checked:= NOT checked;
  if TexSyntax1.Checked then begin
    memo1.Highlighter:= SynTexSyn1;
    TexSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('TexSyntax active: '+inttoStr(memo1.LinesInWindow));
  end else begin
    memo1.Highlighter:= SynPasSyn1;
    TexSyntax1.Caption:= 'Tex Syntax';
  end;
end;


procedure TMaxForm1.toolbtnTutorialClick(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists((ExePath+'docs\')) then begin
    sOName:= ExePath+'docs\' + #0;
    sEName:= 'explorer.exe';
    ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
  end else
    showMessage('No Tutorials Directory found...');
end;

procedure TMaxForm1.CSyntax1Click(Sender: TObject);
begin
  with CSyntax1 do
    checked:= NOT checked;
  if CSyntax1.Checked then begin
    memo1.Highlighter:= SynCppSyn1;
    CSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('C++Syntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      CSyntax1.Caption:= 'C++ Syntax';
    end;
end;

procedure TMaxForm1.CSyntax2Click(Sender: TObject);
begin
  with CSyntax2 do
    checked:= NOT checked;
  if CSyntax2.Checked then begin
    memo1.Highlighter:= SynCSSyn1;
    CSyntax2.Caption:= 'Pascal Syntax';
    memo2.Lines.Add('C#Syntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      CSyntax2.Caption:= 'C# Syntax';
    end;
end;

procedure TMaxForm1.SQLSyntax1Click(Sender: TObject);
begin
  with SQLSyntax1 do
    checked:= NOT checked;
  if SQLSyntax1.Checked then begin
    memo1.Highlighter:= SynSQLSyn1;
    SQLSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('SQLSyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      SQLSyntax1.Caption:= 'SQL Syntax';
    end;
// this is SQL
end;

procedure TMaxForm1.XMLSyntax1Click(Sender: TObject);
begin
  with XMLSyntax1 do
    checked:= NOT checked;
  if XMLSyntax1.Checked then begin
    memo1.Highlighter:= SynXMLSyn1;
    XMLSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('XMLSyntax active: '+inttoStr(memo1.LinesInWindow));
   STATOtherHL:= true;
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      XMLSyntax1.Caption:= 'XML Syntax';
      STATOtherHL:= false;
    end;
// this is SQL
end;

procedure TMaxForm1.JavaScriptSyntax1Click(Sender: TObject);
begin
  with JavaScriptSyntax1 do
    checked:= NOT checked;
  if JavaScriptSyntax1.Checked then begin
    memo1.Highlighter:= SynJScriptSyn1;
    JavaScriptSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('JavaScriptSyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      JavaScriptSyntax1.Caption:= 'Java Script Syntax';
    end;
end;

procedure TMaxForm1.JavaSyntax1Click(Sender: TObject);
begin
  with JavaSyntax1 do
    checked:= NOT checked;
  if JavaSyntax1.Checked then begin
    memo1.Highlighter:= SynJavaSyn1;
    JavaSyntax1.Caption:= 'Pascal Syntax';
   memo2.Lines.Add('JavaSyntax active: '+inttoStr(memo1.LinesInWindow));
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      JavaSyntax1.Caption:= 'Java Syntax';
    end;
end;

function TMaxForm1.getCodeEnd: integer;
var i: integer;
    s1: string;
begin
  for i:= 0 to memo1.lines.Count -1 do begin
     s1:= memo1.lines[i];
     if pos(uppercase('end.'),uppercase(s1)) > 0 then begin
       result:= i+1;
       break;  //first end counts!
     end;
  end;
end;


procedure TMaxForm1.ShowInterfaces(myFile: string);
var
  i, t1, t2, tstr: integer;
  s1, mstr: string;
  aStrList: TStringList;
begin
  aStrList:= TStringList.create;
  aStrList.loadfromfile(myFile);
  debugout.Output.Clear;
  tstr:= 0;
  try
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('function '), uppercase(s1));
      t2:= pos(uppercase('procedure '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
     if pos(uppercase('end.'),uppercase(s1)) > 0 then break;  //bug 3.9.3
    end;
   if javaSyntax1.Checked then begin
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('public '), uppercase(s1));
      t2:= pos(uppercase('void '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
     end;
    end;
    if csyntax1.Checked then begin         //c++
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('public '), uppercase(s1));
      t2:= pos(uppercase('void '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
   end;
   if csyntax2.Checked then begin           //c#
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('public '), uppercase(s1));
      t2:= pos(uppercase('void '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
   end;
  debugout.output.Font.Size:= 12;
  debugout.output.Lines.Text:= mstr;
  debugout.caption:= 'Interface List in Code';
  debugout.output.Lines.Add(inttoStr(tstr)+' Interface(s) Found: ' +
                                     ExtractFileName(Act_Filename));
  debugout.visible:= true;
  ShowMessage(mstr+'---------------------------------------------------'+#13+#10
                            +inttoStr(tstr)+' Interface(s) Found');
  finally
    aStrList.Free;
  end;
end;

procedure TMaxForm1.ShowInterfaces1Click(Sender: TObject);
begin
  //this is all about declaration
  ShowInterfaces(Act_Filename);
  IntfNavigator1Click(Self);
end;

procedure TMaxForm1.ShowLastException1Click(Sender: TObject);
var aStrList: TStringList;
begin
  aStrList:= TStringList.create;
  try
    if FileExists(ExePath+EXCEPTLOGFILE) then begin
      aStrList.loadfromfile(ExePath+EXCEPTLOGFILE);
      debugout.Output.Clear;
      debugout.output.Font.Size:= 10;
      debugout.Width:= 800;
      debugout.output.Lines.Text:= aStrList.Text;
      debugout.caption:= 'Exception Log Box';
      debugout.output.Lines.Add(inttoStr(aStrList.Count)+' Exceptions Found: ' +
                                     (ExePath+EXCEPTLOGFILE));
      debugout.visible:= true;
    end else
      Showmessage('File not ready '+ ExePath+EXCEPTLOGFILE)
  finally
    aStrList.Free;
  end;
end;

end.
