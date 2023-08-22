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
         3402    V3.8.4  CryptoBox31, fasttimer, first android draft, PHP Syn
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
  SynHighlighterXML, SynHighlighterJava,  ide_debugoutput, SynHighlighterPHP; //, jpeg;

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
   ALLOBJECTSLIST = 'upsi_allobjectslist.txt';
   ALLRESOURCELIST = 'docs\upsi_allresourcelist.txt';
   INCLUDEBOX = 'pas_includebox.inc';
   BOOTSCRIPT = 'maxbootscript.txt';
   MBVERSION = '3.8.4.0';
   MBVER = '384';
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
    procedure IFPS3ClassesPlugin1CompImport(Sender: TObject; x: TPSPascalCompiler);
    procedure IFPS3ClassesPlugin1ExecImport(Sender: TObject; Exec: TPSExec;
                                              x: TPSRuntimeClassImporter);
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
    //procedure Memo1DropFiles(Sender: TObject; X,Y: Integer; AFiles: TStrings);
  private
    STATSavebefore: boolean;
    STATShowBytecode: boolean;
    STATInclude: boolean;
    STATEdchanged: boolean;
    STATExceptionLog: boolean;
    STATWriteFirst: boolean;
    STATExecuteBoot: boolean;
    Act_Filename: string[255];
    Def_FName: string[255];
    Last_fName: string[255];
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
  public
    function GetStatChange: boolean;
    procedure SetStatChange(vstat: boolean);
    function GetActFileName: string;
    procedure SetActFileName(vname: string);
    function GetLastFileName: string;
    procedure SetLastFileName(vname: string);
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
  uPSI_Types, //3.5+3.6
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
  uPSI_mathmax, infobox1,
  uPSI_WideStrUtils, //3.7 
  uPSI_WideStrings, //3.2
  uPSI_DateUtils,  //3.2
  uPSR_Grids,
  uPSC_Grids,
  uPSR_comobj,
  uPSC_comobj,
  //IFSI_Tetris1,
  IFSI_WinForm1puzzle, Windows,
  //dlgSearchText,
  SynEditTypes, ConfirmReplDlg, FindReplDlg, ShellAPI,
  SynEditKeyCmds,
  //ide_debugoutput,
  //ToolWin; Types, Grids
  UCMainForm, JimShape,
  RXMain, //3.6.3
  EXEImage, sdpStopwatch,
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
  uPSC_DB, uPSR_DB,
  uPSI_DBTables,
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
  uPSI_JvFunctions,
  uPSI_JvVCLUtils, //3.8.2
  JvFunctions_max, //screenshot
  memorymax3,      //add on games
  gewinntmax3,
  IdGlobal_max,   //3.7 for file information
  StrUtils,        // dupestring
  uPSI_FileCtrl,    //3.5.1
  uPSI_Outline,
  uPSI_ScktComp,
  uPSI_Calendar,
  uPSI_ComCtrls, //3.6
  uPSI_VarHlpr,
  uPSI_Dialogs,
  uPSI_ExtDlgs,
  uPSI_ValEdit,
  VListView,
  uPSI_VListView,
  uPSI_IdGlobal,
  uPSI_IdTCPConnection, //3.1
  IFSI_IdTCPClient,
  uPSI_IdHTTPHeaderInfo,
  IFSI_IdHTTP,
  uPSI_HTTPParse, //3.2
  uPSI_HTTPUtil, //3.2
  uPSI_HTTPApp, //3.7
  IFSI_IdURI,
  IFSI_IdFTP,
  uPSI_xmlutil, //3.2  XML
  uPSI_MaskUtils, //3.5
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
  uPSI_IdAuthentication,
  uPSI_SynMemo,
  uPSI_IdASN1Util,
  uPSI_IdHashCRC, uPSI_IdHash,
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
  uPSI_LinarBitmap,
  uPSI_PNGLoader,
  WinForm1, CRC32,   //3.5
  VCLScannerIntf, SOAPHTTPClient, //Test for WS
  uPSI_interface2_so,
  uPSI_IniFiles,
  uPSI_IdThread,
  uPSI_fMain,   //Register Methods to Open Tools API
  uPSI_niSTRING,
  uPSI_niRegularExpression,
  uPSI_niExtendedRegularExpression, //3.1
  uPSI_IdSNTP,
  JclSysInfo,  //loadedmoduleslist
  IFSI_SysUtils_max;


resourcestring
  RCReplace = 'Replace this '#13'of "%s"'#13+'by "%s"?';
  RCSTRMB ='maXbox3 ';
  RCPRINTFONT ='Courier New';
  FILELOAD = ' File loaded';
  FILESAVE = ' File is saved';
  BEFOREFILE = ' last File set';
  CLIFILELOAD = ' File from Commandline';
  RS_PS='http://pascalprogramming.byethost15.com/lessonindex.html';
  RS_DS='http://www.delphi3000.com/';

const
  DefSynEditOptions = [eoAltSetsColumnMode, eoAutoIndent, eoDragDropEditing,
  eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoScrollPastEol, eoSmartTabs,
  eoTabsToSpaces, eoSmartTabDelete, eoGroupUndo];

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
  SIRegister_Graphics(x, true);
  SIRegister_Controls(x);
  SIRegister_stdctrls(x);
  SIRegister_extctrls(x);
  SIRegister_Types(X);       //3.5+3.6
  SIRegister_Forms(x);
  SIRegister_TwinFormp(x);
  SIRegister_TMyLabel(x);
  SIRegister_WinForm1(x);
  RegisterDateTimeLibrary_C(x);
  //SIRegister_Types(X);       //3.5
  //SIRegister_Graphics(x, true);
  SIRegister_StrUtils(X);
  SIRegister_SysUtils(X);   //3.2
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
  SIRegister_DateUtils(X); //3.2
  SIRegister_FileUtils(X);
  SIRegister_gsUtils(X);
  SIRegister_JvFunctions(X);
  SIRegister_Grids(X);
  SIRegister_Menus(X); //3.1
  SIRegister_ComObj(X);
  SIRegister_Printers(X);
  SIRegister_MPlayer(X);
  SIRegister_ImgList(X);
  SIRegister_Buttons(X);
  SIRegister_Clipbrd(X);
  SIRegister_SqlExpr(X);
  SIRegister_ADODB(X);
  SIRegister_DBGrids(X);
  SIRegister_DBCtrls(X);
  SIRegister_DBCGrids(X); //3.6
  SIRegister_JclStatistics(X);
  SIRegister_JclMiscel(X);
  SIRegister_JclLogic(X);
  SIRegister_JvVCLUtils(X);  //3.8
   SIRegister_uTPLb_StreamUtils(X);
  SIRegister_uTPLb_AES(X);
  SIRegister_uTPLb_SHA2(X);
  SIRegister_AESPassWordDlg(X);
  SIRegister_JclMultimedia(X);
  SIRegister_TTypeTranslatoR(X);
  SIRegister_MathUtils(X);
  SIRegister_HTTPParse(X);
  SIRegister_HTTPUtil(X);
  //SIRegister_EIdHTTPProtocolException(x);
  {SIRegister_TIdHTTP(x);
  SIRegister_TIdCustomHTTP(x);
  SIRegister_TIdHTTPProtocol(x);
  SIRegister_TIdHTTPRequest(x);
  SIRegister_TIdHTTPResponse(x);}
  SIRegister_IdTCPConnection(X);  //3.1
  SIRegister_IdTCPClient(X);
  SIRegister_IdHTTPHeaderInfo(X);
  SIRegister_IdHTTP(x);
  SIRegister_HTTPApp(X);
  //SIRegister_TIdURI(x);
  SIRegister_IdURI(x);
  SIRegister_IdFTP(X);
  SIRegister_xmlutil(X);    //3.2 XML
  SIRegister_MaskUtils(X); //3.5
  SIRegister_Masks(X);
  SIRegister_FileCtrl(X);
  SIRegister_Outline(X);
  SIRegister_ScktComp(X);
  SIRegister_Calendar(X);
  SIRegister_VListView(X);
  SIRegister_ide_debugoutput(X);
  SIRegister_ComCtrls(X); //3.6
  SIRegister_VarHlpr(X);
  SIRegister_Dialogs(X);
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
  SIRegister_Tabs(X);
  SIRegister_JclGraphUtils(X);
  SIRegister_JclCounter(X);
  SIRegister_JclSysInfo(X);
  SIRegister_JclSecurity(X);
  SIRegister_IdUserAccounts(X);
  SIRegister_JclFileUtils(X);
  SIRegister_IdAuthentication(X);
  SIRegister_SynMemo(X);
  SIRegister_IdASN1Util(X);
  SIRegister_IdHash(X);
  SIRegister_IdHashCRC(X);
  SIRegister_IdHashMessageDigest(X);  //3.5
  SIRegister_IdHashSHA1(X);
  SIRegister_IdLogFile(X);
  SIRegister_IdTime(X);
  SIRegister_IdDayTime(X);
  SIRegister_IdGlobal(X);
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
  SIRegister_LinarBitmap(X);
  SIRegister_PNGLoader(X);
  SIRegister_IniFiles(X);
  SIRegister_IdThread(X);
  SIRegister_fMain(X);
  SIRegister_niSTRING(X);
  SIRegister_niRegularExpression(X);
  SIRegister_niExtendedRegularExpression(X);
  SIRegister_IdSNTP(X);
  SIRegister_SysUtils(X);

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
  RIRegister_DBTables_Routines(Exec);
  RIRegister_DBTables(X);
  RIRegister_DBPlatform(X);
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
  RIRegister_DBCGrids(X);
  RIRegister_DateUtils_Routines(Exec);
  RIRegister_FileUtils_Routines(Exec);
  RIRegister_gsUtils_Routines(Exec);
  RIRegister_JvFunctions_Routines(Exec);
  RIRegister_JclStatistics_Routines(Exec);
  RIRegister_JclMiscel_Routines(Exec);
  RIRegister_JclLogic_Routines(Exec);
  RIRegister_JvVCLUtils(X);   //3.8.2
  RIRegister_JvVCLUtils_Routines(Exec);
  RIRegister_uTPLb_StreamUtils_Routines(Exec);
  RIRegister_uTPLb_AES(X);
  RIRegister_uTPLb_AES_Routines(Exec);
  RIRegister_uTPLb_SHA2(X);
  RIRegister_AESPassWordDlg(X);
  RIRegister_MathUtils_Routines(Exec);
  RIRegister_JclMultimedia(X);
  RIRegister_TTypeTranslator(X);
  RIRegister_TypeTrans_Routines(Exec);
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
  //RIRegister_TIdURI(x);
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
  RIRegister_SynMemo(X);
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
  RIRegister_LinarBitmap(X);
  RIRegister_LinarBitmap_Routines(Exec);
  RIRegister_PNGLoader(X);
  RIRegister_IniFiles(X);
  RIRegister_IdThread(X);
  RIRegister_fMain(X);
  RIRegister_niSTRING_Routines(Exec);
  RIRegister_niSTRING(X);
  RIRegister_niRegularExpression(X);
  RIRegister_niExtendedRegularExpression(X);
  RIRegister_IdSNTP(X);
  RIRegister_SysUtils(X);
  RIRegister_SysUtils_Routines(Exec);   //fallback resort!

end;

procedure TMaxForm1.FormCreate(Sender: TObject);
//var
  //Plugin: TPSPlugin;
begin
  self.Height:= 830;
  self.Width:= 950;
  STATEdchanged:= false;
  STATSavebefore:= true;    //2.8.1. once
  STATInclude:= true;
  STATExceptionLog:= true; //v3
  STATExecuteShell:= true; //v3
  STATformOutput:= false; //v3.5
  STATExecuteBoot:= true; //v38
  fdebuginst:= false;
  memo1.Options:= memo1.Options + [eoDropFiles];
  dragAcceptFiles(maxForm1.Handle, True );
  memo2.Height:= 175;
  memo2.WordWrap:= true;
  //Plugin:= TPSImport_Winform1.create(self);
  //TPSPluginItem(psscript.plugins.add).plugin:= Plugin;
  //cedebug.Plugins:= psscript.Plugins.
  cedebug.OnCompile:= PSScriptCompile;
  cedebug.OnExecute:= cedebugExecute; //!! independent from main execute
  memo1.Options:= DefSynEditOptions;
  memo1.Highlighter:= SynPasSyn1;
  memo1.Gutter.ShowLineNumbers:= true;
  memo1.WantTabs:= true;
  if fileexists(DEFINIFILE) then LoadFileNameFromIni;
  DefFileread;
  PSScript.UsePreProcessor:= true;
  dlgPrintFont1.Font.Size:= 7;      //Default 3.8
  dlgPrintFont1.Font.Name:= RCPRINTFONT;
  fPrintOut:= TSynEditPrint.Create(Self);
  fPrintOut.Font.Name:= RCPRINTFONT;
  fPrintOut.Font.Assign(dlgPrintFont1.Font); //3.1
  //fAutoComplete.Editor := TCustomSynEdit(SynPasSyn1);
  if Application.MainForm = NIL then begin
    fAutoComplete:= TSynAutoComplete.Create(Self);
    fAutoComplete.Editor:= memo1;
  if fileexists('bds_delphi.dci') then
    fAutoComplete.AutoCompleteList.LoadFromFile('bds_delphi.dci') else
      showmessage('maXbox: a bds_delphi.dci file is missing (code completion)'+#13#10+
                  'get the file: http://www.softwareschule.ch/download/bds_delphi.zip');
  end else
    maxForm1.fAutoComplete.AddEditor(memo1);
  memo1.AddKey(ecAutoCompletion, word('J'), [ssCtrl], 0, []);
  statusbar1.simplepanel:= true;
  showSpecChars1.Checked:= false;
  debugout:= Tdebugoutput.Create(self);
  //listform1:= TFormListview.Create(self);
  //listform1.Hide;
  //FOrgListViewWndProc:= ListForm1.WindowProc; // save old window proc
  //ListForm1.WindowProc:= ListViewWndProc;  // subclass
  //TMessage(WMDROP_THEFILES);//
  //DragAcceptFiles(listform1.Handle, True);
  if VersionCheck then memo2.Lines.Add('Version on Internet Checked!');        //3.8
  if STATExecuteBoot then LoadBootScript;
  if STATExceptionLog then
     Application.OnException:= AppOnException;   //v3
    //CLI of command line or ShellExecute
  if (ParamStr(1) <> '') then begin
     act_Filename:= ParamStr(1);
     memo1.Lines.LoadFromFile(act_Filename);
     memo2.Lines.Add(Act_Filename + CLIFILELOAD);
     statusBar1.SimpleText:= Act_Filename + CLIFILELOAD;
     Compile1Click(self);
     if (ParamStr(2) = 'm') then begin
       //Compile1Click(self);!
       Application.Minimize;
     end;
  end;
end;

procedure TMaxForm1.FormActivate(Sender: TObject);
begin
  //STATSavebefore:= true;
  //STATInclude:= true;
  //idLogDebug1.Active:= true;
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
  //statusBar1.SimpleText:= MBVERSION +' '+Act_Filename;
  //last_fontsize:= 12; //fallback
end;

procedure TMaxForm1.AppOnException(sender: TObject; E: Exception);
begin
  MAppOnException(sender, E);
end;

procedure TMaxForm1.ArduinoDump1Click(Sender: TObject);
begin
  ShowMessage('Arduino HexDump to Flash in uC available in V4')
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
  {$C+}
  Assert(expr, (msg));
  {$C-}
   maxform1.memo2.lines.add('Assertion: '+msg+' mX3 Assert at ' +DateTimeToStr(Now));
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
  mylist.Free;
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
  MyWriteln(Format(aformat, args));
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
  Sender.AddFunction(@myreset,'function Reset2(mypath: string):string;');
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
  //Sender.AddFunction(@ExecuteThread, 'procedure ExecuteThread(afunc: TThreadFunction; thrOK: boolean)');
  Sender.AddFunction(@Move2, 'procedure Move2(const Source: TByteArray; var Dest: TByteArray; Count: Integer)');
  Sender.AddFunction(@SearchAndReplace,'procedure SearchAndReplace(aStrList: TStrings; aSearchStr, aNewStr: string)');
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
  Sender.AddFunction(@ReadVersion,'procedure ReadVersion(aFileName: STRING; aVersion : TStrings);');
  //Sender.AddFunction(@GetFileVersion,'function GetFileVersion(Filename: String): String;');
  Sender.AddFunction(@StringPad,'Function StringPad(InputStr,FillChar: String; StrLen:Integer; StrJustify:Boolean): String;');
  Sender.AddFunction(@MinimizeMaxbox, 'Procedure MinimizeMaxbox;');
  Sender.AddFunction(@MinimizeMaxbox, 'Procedure MinimizeWindow;');
  Sender.AddFunction(@SaveCanvas2, 'procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);');
  Sender.AddFunction(@DrawPlot, 'procedure drawPlot(vPoints: TPointArray; cFrm: TForm; vcolor: integer);');
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
  Sender.AddFunction(@mytimegetsystemtime,'function timegetsystemtime: int64;');
  Sender.AddFunction(@GetCPUSpeed,'function GetCPUSpeed: Double;');

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
  statusBar1.SimpleText:= 'Codelines window: '+inttoStr(memo1.LinesInWindow-1);
  //PSScript.Comp.OnUses:= '';    units
  if PSScript.Compile then begin
    OutputMessages;
    memo2.Lines.Add(RCSTRMB +extractFileName(Act_Filename)+' Compiled done: '
                                                         +dateTimetoStr(now()));
    memo2.Lines.Add('--------------------------------------------------------');
    statusBar1.SimpleText:= RCSTRMB +Act_Filename+' Compiled done: '
                                                         +dateTimetoStr(now());
    if not PSScript.Execute then begin
      memo1.SelStart := PSScript.ExecErrorPosition;
      memo2.Lines.Add(PSScript.ExecErrorToString +' at '+Inttostr(PSScript.ExecErrorProcNo)
                       +'.'+Inttostr(PSScript.ExecErrorByteCodePosition));
    end else begin
    stopw.Stop;
    memo2.Lines.Add(' mX3 executed: '+dateTimetoStr(Now())+'  Runtime: '+stopw.GetValueStr);
    end;
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
      statusBar1.SimpleText:= 'Form Output Active Lines: '+inttoStr(memo2.Lines.count-1);
      end
    end;

    if STATShowBytecode then begin
      mybytecode:= '';
      //PSScript.Comp.OnUses:= IFPS3ClassesPlugin1CompImport;
      PSScript.GetCompiled(mybytecode);   //compiler.getOutput
      //psscript.Comp.GetOutput(mybytecode);
      showAndSaveBCode(mybytecode);
    end;
    imglogo.Transparent:= true;
    //mybytecode:= 'memo2.Lines.Add(PSScript.ExecErrorToString +';
    //memo1.lines.add(mybytecode);
  end else begin
    OutputMessages;
    memo2.Lines.Add('Compiling Script failed');
  end;
  //TestWebService;   //Test WS
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
         if RunCompiledScript(Filename, bcerrorcode) then begin
            sysutils.beep;
            showmessage('Byte Code run success')
         end else
      Memo2.lines.add('ByteCode Error Message: '+bcerrorcode); //end else
    end;
  //this open and free
    Free;
  end;
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
      memo2.Lines.Add(last_fName + BEFOREFILE);    //beta
      loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
      Act_Filename:= FileName;
      memo2.Lines.Add(FileName + FILELOAD);
      statusBar1.SimpleText:= FileName + FILELOAD;
    //default action
    end else if fileexists(Def_FName) then
      if MessageDlg('WellCode, you want to load '+DEFFILENAME,
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
        memo1.Lines.LoadFromFile(Def_FName);
        memo2.Lines.Add(DEFFILENAME + FILELOAD);
        statusBar1.SimpleText:= DEFFILENAME + FILELOAD;
        Act_Filename:= Def_FName;
      end else begin
        statusbar1.SimpleText:= 'load DIALOG cancelled';  //beta
        exit;
      end;
      //raise Exception.Create('Brake File in '+RCSTRMB+':' +FileName);
    Free;
  end; //with
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
      statusBar1.SimpleText:= FileName +' File stored';
      // add last file to the deffile
      SaveFileOptionsToIni(FileName);
      STATEdchanged:= false;
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
  end else
    Saveas3Click(sender);
end;

procedure TMaxForm1.Savebefore1Click(Sender: TObject);
begin
 Savebefore1.Checked:= not Savebefore1.Checked;
 if Savebefore1.Checked then STATSavebefore:= true else
   STATSavebefore:= false;
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
     end else
       STATEdchanged:= false;
   last_fName:= Act_Filename;
   memo2.Lines.Add(last_fName + BEFOREFILE);    //beta
   loadLastfile1.Caption:= '&Load Last File' +': '+ extractFileName(last_fName);
   with Memo1 do begin
     Lines.clear;
     //Grab the name of a dropped file
     dragQueryFile(hDroppedFile, 0, @bFilename, sizeOf(bFilename));
     Lines.loadFromFile(StrPas(bFilename));
   end;
   Act_Filename:= bFilename;
   memo2.Lines.Add(bFileName + FILELOAD);
   statusBar1.SimpleText:= bFileName +' drag&drop' +FILELOAD;
   //release memory.
   dragFinish(hDroppedFile );
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

procedure TMaxForm1.Lessons15Review1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter15.pdf');
end;

procedure TMaxForm1.showAndSaveBCode(const bdata: string);
var outfile: string;
    fx: longint;
begin
 //numWritten:= 0;
 outfile:= ExtractFilePath(paramstr(0))+extractFilename(act_filename)+BYTECODE;
 fx:= fileCreate(outfile);
 fileWrite(fx, bdata[1], length(bdata));
 fileClose(fx);
 //AssignFile(f, outfile); //BYTECODE
 //{$I-}
 //Rewrite(f,1);
 //{$I+}
 //if IOResult = 0  then begin
 //  Writeln(f, bdata);
 //  PSScript.SetCompiled(bdata);
 //  CloseFile(f)
 //end;
 memo2.Lines.Add('');
 memo2.Lines.Add('-----PS-BYTECODE (PSB)-----');
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

procedure TMaxForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
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
    last_fName:= Act_Filename;
    loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
    memo1.Lines.Clear;
    memo1.lines.Add('----code_cleared_checked----');
    STATEdchanged:= false;
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
      loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
      last_fontsize:= strtoint((deflist.values['FONTSIZE']));
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
    end else begin
      // init values case of no file
      deflist.add('//***Definitions for ' +RCSTRMB+MBVERSION+' ***');
      deflist.add('[FORM]'); //ini file compatible mX3
      deflist.values['LAST_FILE']:= DEFFILENAME; //Def_FName;
      deflist.values['PRELAST_FILE']:= DEFFILENAME; //Def_FName;
      deflist.values['FONTSIZE']:= '10';
      deflist.values['EXTENSION']:= 'txt';
      deflist.Values['SCREENX']:= '950';
      deflist.Values['SCREENY']:= '825';
      deflist.Values['MEMHEIGHT']:= '175';
      deflist.Values['PRINTFONT']:= 'Courier New';
      deflist.Values['LINENUMBERS']:= 'Y';
      deflist.Values['EXCEPTIONLOG']:= 'Y';
      deflist.Values['EXECUTESHELL']:= 'Y';
      deflist.Values['BOOTSCRIPT']:= 'Y';
      deflist.SaveToFile(fN);
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
 if fileexists(fN) then begin
   with TStringlist.Create do begin
     LoadFromFile(fN);
     Values['LAST_FILE']:= filen;
     Values['PRELAST_FILE']:= last_fName;
     Values['FONTSIZE']:= inttoStr(last_fontsize);
     Values['SCREENY']:= inttostr(maxForm1.height);
     Values['SCREENX']:= inttoStr(maxForm1.Width);
     Values['MEMHEIGHT']:= inttoStr(memo2.height);
     SaveToFile(fN);
     Free;
   end;
  memo2.Lines.Add(extractFileName(filen) +' in .ini stored');
  statusBar1.SimpleText:= last_fName +' last in .ini stored';
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
     statusBar1.SimpleText:= Act_Filename + FILELOAD;
   except
     Showmessage('Invalid File Path - Please Set <File Open/Save As...>');
   end;
   Free;
 end;
end;

Procedure TMaxForm1.LoadBootScript;
var filepath, fN, bcerrorcode: string;
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
  statusBar1.SimpleText:= MXSITE +' ***\/*** '+MXMAIL;
end;

//this section describes search & replace functions
// OnFind routine for find text
procedure TMaxForm1.FindNextText(Sender: TObject);
begin
  with FindReplDialog do begin
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
    Findtext:= UpdateFindtext;
    OnFind:= FindNextText;
    Execute(false);
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
  Result:= Height-ClientHeight + Coolbar1.Height;
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
  statusBar1.SimpleText:= MXSITE +' ***\News and Updates/*** '+MXMAIL;
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

procedure TMaxForm1.Memo1StatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if Changes*[scCaretY,scCaretX]<>[] then begin
    with FindReplDialog do if Visible and not Searching then
                             FindText:= UpdateFindtext;
  end;
end;

procedure TMaxForm1.Memory1Click(Sender: TObject);
begin
  //memory game
  FormCreateInit(self);
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

procedure TMaxForm1.ShowInclude1Click(Sender: TObject);
begin
 showInclude1.Checked:= not showInclude1.Checked;
 if showInclude1.Checked then STATInclude:= true else
   STATInclude:= false;
end;

procedure TMaxForm1.ShowSpecChars1Click(Sender: TObject);
begin
 showSpecChars1.Checked:= not showSpecChars1.Checked;
 if showSpecChars1.Checked then Memo1.Options:=
                              Memo1.Options +[eoShowSpecialChars] else
 Memo1.Options:= Memo1.Options - [eoShowSpecialChars];
end;

//printing procedures--------------------------------------
procedure TMaxForm1.Printout1Click(Sender: TObject);
var pntindex: integer;
begin
   //set all properties because this can affect pagination
  Screen.Cursor := crHourGlass;
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
    Footer.Add('Total: '+IntToStr(fPrintOut.PageCount), NIL, taRightJustify, 2);
    //Footer.Add('Page: '+IntToStr((fPrintOut.PageOffset)), NIL, taRightJustify, 3);
    Colors:= mnPrintColors1.Checked;
    //Highlighter:= SynPasSyn1;
    Highlighter:= memo1.Highlighter;  //3.1
    LineNumbers:= true;
    //fprintout.p
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
  statusBar1.SimpleText:= Act_Filename +' is printed';
end;

procedure TMaxForm1.EditFont1Click(Sender: TObject);
begin
  dlgPrintFont1.Font.Assign(memo1.Font);
  if dlgPrintFont1.Execute then begin
    memo1.Font.Assign(dlgPrintFont1.Font);
    last_fontsize:= memo1.Font.Size;
    statusBar1.SimpleText:= memo1.Font.Name+' font is active';
  end;
   //CaptionEdit.Font := FontDialog1.Font;
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


procedure TMaxForm1.ReadOnly1Click(Sender: TObject);
begin
 readonly1.Checked:= not readonly1.Checked;
 if readonly1.Checked then memo2.ReadOnly:= true else
   memo2.ReadOnly:= false;
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

procedure TMaxForm1.N4GewinntGame1Click(Sender: TObject);
begin
 // start the game 4gewinnt
  FormCreateInit4Game(self);
end;

procedure TMaxForm1.New1Click(Sender: TObject);
begin
  if MessageDlg('Welcode to '+RCSTRMB+ ' Clear memo now and load code?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
    last_fName:= Act_Filename;
    //loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
    memo1.Lines.Clear;
   if fileExists(ExtractFilePath(ParamStr(0))+ CODECOMPLETION) then
       maxForm1.fAutoComplete.ExecuteCompletion('program',memo1) else
      showMessage('The file '+CODECOMPLETION+' is missing');
    statusBar1.SimpleText:= 'New Template loaded lines: '+inttoStr(memo1.LinesInWindow-1);
    memo1.lines.Add('----app_template_loaded----');
    //maxForm1.fAutoComplete.ExecuteCompletion('unit',memo1);
    //memo1.lines.Add('----unit_template_loaded----');
    STATEdchanged:= false;
    Act_Filename:= 'newtemplate.txt'; //3.1
    statusBar1.SimpleText:= 'Filename newtemplate.txt is set';
    If fileExists('newtemplate.txt') then begin
      if MessageDlg('Filename exists, you want to override newtemplate.txt',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin  //3.8
        statusBar1.SimpleText:= 'newtemplate.txt will be overriden';
        loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
      end else begin
        statusBar1.SimpleText:= 'Filename newtemplate.txt must change';
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
  end else
    showMessage('No Instance found...');
    //GetCurrentDir;
  //searchAndOpenDoc(ExePath+ExtractFileName(Application.ExeName))
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
        Width:= 700;
        Height:= 610;
         //debugout.Color:= 123;
        caption:= 'mX3 Script File Information';
        //output.Font.Style:= [fsbold];
        output.Lines.add(DupeString('-',140));
        output.Lines.add('App Name: '+extractFileName(Act_Filename));
        output.Lines.add('Path Name: '+extractFilePath(Act_Filename));
        //output.Font.Style:= [];
        output.Lines.add(DupeString('-',140));
        output.Lines.add('File Size: '+IntToStr(FileSizeByName(Act_Filename))+' Kb');
        output.Lines.add('File Age: '+IntToStr(FileAge(Act_Filename)));
        mytimestamp:= GetFileCreationTime(Act_Filename);
        output.Lines.add('File Created: '+datetimetoStr(mytimestamp));
        output.Lines.add('File Lines: '+inttostr(memo1.Lines.count-1));
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
        if procMess.Checked then output.Lines.Add('ProcessMessages On')
                   else output.Lines.Add('ProcessMessages Off');
        if IsInternet then output.Lines.Add('Internet On')
                   else output.Lines.Add('Internet Off');
        output.Lines.add('Host Name: '+getComputerNameWin);
        output.Lines.add('User Name: '+getUserNameWin);
        output.Lines.add('Process ID: '+intToStr(CurrentProcessID));
        output.Lines.add('Time: '+DateTimeToInternetStr(now, true));
        output.Lines.add('mX3 Installed Version: '+MBVERSION);
        output.Lines.add('mX3 Internet Version: '+ActVersion);

      //debugout.output.Lines.Add(inttoStr(aStrList.Count)+' Lines Found: ' +
        //                             (ExtractFileName(ExePath+INCLUDEBOX)));
      visible:= true;
      end;
    end else
      Showmessage('A File is not available '+ ExePath)
  finally
    //debugout.output.Color:= clwhite;
    //debugout.output.Font.Size:= 14;
    //aStrList.Free;
  end;
  //File Info
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
  if STATedchanged then begin
  if MessageDlg(RCSTRMB+': Save Code Changes now?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
      Save2Click(sender);
      memo1.Lines.Clear;
      Action:= caFree;
    end else
    Action:= caFree;
  end;
    if assigned(winFormp) then
      winFormp.Free;
  // debug showmessage('close');
end;

procedure TMaxForm1.UpdateView1Click(Sender: TObject);
begin
  memo1.Repaint; //after copy&paste or drag'n drop
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

procedure TMaxForm1.Tutorial101Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter9.pdf');
end;

procedure TMaxForm1.CodeCompletionList1Click(Sender: TObject);
begin
  if fileExists(ExtractFilePath(ParamStr(0))+ CODECOMPLETION) then begin
    statusBar1.SimpleText:= ' Code Completion Load...' +CODECOMPLETION;
    memo2.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+CODECOMPLETION) end else
    showMessage('the file '+CODECOMPLETION+' is missing');
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

procedure TMaxForm1.ExportClipboard1Click(Sender: TObject);
begin
  memo1.SelectAll;
  if memo1.Focused then memo1.CopyToClipboard;
  statusBar1.SimpleText:= ' Export to Clipboard...' +FILELOAD;
end;

procedure TMaxForm1.ImportfromClipboard1Click(Sender: TObject);
begin
  last_fName:= Act_Filename;
  loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
  if memo1.Focused then memo1.PasteFromClipboard;
  statusBar1.SimpleText:= ' Import of Clipboard...' +FILELOAD;
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
    searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLRESOURCELIST)
end;

procedure TMaxForm1.AndroidDump1Click(Sender: TObject);
begin
   ShowMessage('Android Dump to Dalvik Format Runtime Emulator available in V4')
end;

//----------------------- PlugIns---------------------------------------------
procedure TMaxForm1.PascalSchool1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
  begin
    strPCopy(URLBuf, RS_PS);
    ShellExecute(Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal)
  //from about
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

procedure TMaxForm1.DelphiSite1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
  begin
    strPCopy(URLBuf, RS_DS);
    ShellExecute(Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal)
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

procedure TMaxForm1.GotoEnd1Click(Sender: TObject);
begin
  with FindReplDialog do begin
    Findtext:= 'End.';
    //OnFind:= FindNextText;
    FindNextText(self);
    //Execute(false);
  end;
  //goto code end
end;

Procedure TMaxForm1.SetStatChange(vstat: boolean);
begin
  STATEdchanged:= vstat;//
end;

procedure TMaxForm1.LoadLastFile1Click(Sender: TObject);
var templastfile: string;
begin
  memo1.Lines.LoadFromFile(last_fName);
  templastfile:= Act_Filename;
  Act_Filename:= last_fName;
  last_fName:= templastfile;
  loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
  memo2.Lines.Add(extractFileName(last_fName) +' '+ BEFOREFILE);
  statusBar1.SimpleText:= Act_Filename +' '+ FILELOAD;
  memo2.Lines.Add(extractFileName(Act_Filename) +' '+ FILELOAD);
end;

procedure TMaxForm1.Memo1Change(Sender: TObject);
begin
  STATedchanged:= true;
  memo1.Refresh; //2.8.1
  //debug statusBar1.SimpleText:= ' editior changed';
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
    statusBar1.SimpleText:= Act_Filename +' in ---debug mode--- '+ FILELOAD
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
    debugout.output.Lines.Add('Component Count of maXbox: ' +
                                     MBVERSION);
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
  imglogo.Transparent:= false;
  lineToNumber(false);
  Slinenumbers1.Checked:= false;
  PSScript.MainFileName:= Act_Filename;
  PSScript.Script.Assign(memo1.Lines);
  cedebug.MainFileName:= Act_Filename;
  cedebug.Script.Assign(memo1.Lines);
  //showmessage(psscript.script.Text);
  memo2.Lines.Add('Syntax Check Start '+RCSTRMB +inttostr(memo1.Lines.count-1)+' lines');
  //TPSPascalCompiler transforms to bytecode
  if PSScript.Compile then begin
    OutputMessages;
    memo2.Lines.Add(RCSTRMB +extractFileName(Act_Filename)+' Syntax Check done: '
                                                         +dateTimetoStr(now()));
    memo2.Lines.Add('--------------------------------------------------------');
    statusBar1.SimpleText:= RCSTRMB +extractFileName(Act_Filename)+' Syntax Check done: '
                                                         +dateTimetoStr(now());
  end else begin
    OutputMessages;
    memo2.Lines.Add('Syntax Check not completed');
  end;
  //scheck....
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
  statusBar1.SimpleText:=
       ExtractFilePath(application.ExeName)+' exe directory'
  else
    statusBar1.SimpleText:= ExtractFilePath(Act_Filename) +' file directory';
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

procedure TMaxForm1.procMessClick(Sender: TObject);
begin
   procMess.Checked:= not procMess.Checked;
   if procMess.Checked then PSScript.OnLine:= maxForm1.PSScriptLine else
   PSScript.OnLine:= NIL;
end;

procedure TMaxForm1.tbtn6resClick(Sender: TObject);
var
 TmpExeFile: TExeImage;
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
      statusBar1.SimpleText:= ' mX Resources loaded!';
    finally
      Release;
      Free;
      statusBar1.SimpleText:= 'Resource Explorer closed';
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
        statusBar1.SimpleText:= ExtractFileName(ucFile)+' : Code & Model ready!';
      end;
      SetCodeFileName(newNameExt);
      showModal;
      statusBar1.SimpleText:= 'UC Dialog active';
    finally
      release;
      Free;
      statusBar1.SimpleText:= 'UC Dialog closed';
    end;
  end;
  //this is stack attack
end;


procedure TMaxForm1.HTMLSyntax1Click(Sender: TObject);
begin
  with HTMLSyntax1 do
    checked:= NOT checked;
  if HTMLSyntax1.Checked then begin
    memo1.Highlighter:= SynHTMLSyn1;
    HTMLSyntax1.Caption:= 'Pascal Syntax'
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
    TexSyntax1.Caption:= 'Pascal Syntax'
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
    CSyntax1.Caption:= 'Pascal Syntax'
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      CSyntax1.Caption:= 'C++ Syntax';
    end;
end;

procedure TMaxForm1.SQLSyntax1Click(Sender: TObject);
begin
  with SQLSyntax1 do
    checked:= NOT checked;
  if SQLSyntax1.Checked then begin
    memo1.Highlighter:= SynSQLSyn1;
    SQLSyntax1.Caption:= 'Pascal Syntax'
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
    XMLSyntax1.Caption:= 'Pascal Syntax'
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      XMLSyntax1.Caption:= 'XML Syntax';
    end;
// this is SQL
end;

procedure TMaxForm1.JavaSyntax1Click(Sender: TObject);
begin
  with JavaSyntax1 do
    checked:= NOT checked;
  if JavaSyntax1.Checked then begin
    memo1.Highlighter:= SynJavaSyn1;
    JavaSyntax1.Caption:= 'Pascal Syntax'
  end
    else begin
      memo1.Highlighter:= SynPasSyn1;
      JavaSyntax1.Caption:= 'Java Syntax';
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
end;

procedure TMaxForm1.ShowLastException1Click(Sender: TObject);
var
  aStrList: TStringList;
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
