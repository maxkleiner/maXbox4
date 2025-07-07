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
                  23.01.05 rebuild, save handling d6movetothispadXY from kylix2
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
         3250    V3.8.1 dragndrop usecase, 10 add unitfs, print exception
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
         4920    V3.9.7.1.a fulltextfinder, navigator2, fla unit , 4units
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
         7293    V3.9.9.8 november , extreme socks, fastfinder, add units
         7376      build 16   todolist, finderlinks, SimpleXML bug fixing
         7537      build 18   more indy, ADOTester, SimpleXML bug fixing, QRCode
         7656      build 20   richedit, save as prompt, filerun, webtemplate, logfile
         7850      build 50   rtf export, tools section, bold package
         7950      build 60   key send, some bugs and functions ,MATRIX , one Zeos
         8115      build 80  constructors, status dyn, more sockets, RTDOS, fplot
         8180      build 80.1 DJ units, bugfixes, passtyle
         8228      build 81 statictext, reversi, geometry
         8372      build 82 sortgrid, fpcolor, InterBase , streams, perftime
         8533      build 84 persistform, autobookmark , AL package2, isadmin
         8650      build 85 orpheus, asyncfree, guid  , advapi, form constructor
         8783      build 86 bugfixing, winapi2 , mysql firebird first, gsAPI
         9181      build 91 2 tutorials, synapse, component, persistence, opengl, environment change
         9250      build 92 OCX, dbtreeview  , dbctrls
         9370      build 94 //3.9.9.94_3   bigfixing and remote , cindy, jv
         9444       build 95 oscilloscope, hexview, mixer, wininet
         9496      build 96 wot, color - caption hack, wake on lan , basecomm
         9527       build 96_1 getwebscript, cycontainer
         9544       build 96_2 backgroundcolor themes fix, backgroundparent, fixing
         9580       build 96_3 5 units, fixing, checkers. DOS syntax
         9608       build 98  toolbox units,  regex2
         9650       build 98_1  processlist,  pipes, GSM, BetterADO
         9661       build 98_2  inno setup functions
         9705       build 98_3 more inno functions, video grabber, 32 units add
         9733       build 98_4 add async pro tools
         9792       build 98_5 8 more unit unit testing async pro tools
         9890       build 98_6 5 more units fileclass set ,dmmcanvas, led set, morse gen
         9925       build 98_7 maps, maXmap, downloadengine
         9938       build 98_8 IDL Syntax, maXmap, downloadengine , openmapX
         10050      build 100 3 units, cgi, openmapX3, runbytecode, synwrap, cgi
         10162      build 101 DOM Support, IPUtils, geocode, compass, GPSDemo, 3DDemo
         10208      build 110 external app, mcisendstring, sqlscriptparser
         10217      build 110_1 two units, bugfix stdcall
         10288      build 120 8 units more, panview, planets, ActiveX
         10332      build 160 5 units ,hirestimer, unit converter , parser form, upsutils
         10356      build 160_1 1 units ,DOS redirecter, createprocess , servicemanager
         10380      build 180 8 units ,BigNumbers, Dictionary, ModBus, IBAN
         10404     build 180_2 vcl samples, 14 bugfixes, sql helper, modbus res, actman, IBcomp
         10415     build 180_3 4 bugfixes, dbtable redesign checkconstrains, modbus consts, testvendor
                                    dunit testframework vendor dbtests - 3.3.2015
         10465     build 190 override bugfixing, virtual constructor - 7 units, soap conn
         10470     build 191 ADOCOMUtils_set  - recordset2
         10490     build 192 TClientDataSet2  - recordset3, script executor, vbscript, DLLRun
         10500     build 193 TClientDataSet2  - filter, objbroker
         10538     build 194 myscript TClientDataSet3  - connect dlgs
         10592     build 195 tcom, vterminal, utilspac

         10621          build 200 to V4   Jupiter
         10700     build 215 4.0.1.15    change tracker traxx, 22 more units
                   build 215 after disaster win10 update!
         10880     build 4.0.2.60 chessboard 3dgraph- - minor bugs - orange style - XMLRPC -maxutils
         10905     build 4.0.2.80 another mAXXML class interface struct and VListBox, X509 Cert, ASn1, SH+
         10926     build 4.0.2.80_1     wide string package  - unified routines
         10960     build 4.2.0.10 more wide strings - stringgridlib - REXX
         10993     build 4.2.0.80 another pipe solution - change ___pointer to btstring at upscompiler
         11032     build 4.2.2.90 kronos and pipe fix - setkeypressed - compare v - tokens2lib - kdialogs, maxpipe
         11040     build 4.2.2.90 III add kcontrols and last functions of coolcode! getform()
         11078     build 4.2.2.95 another 9 units and kmemo kkstring  II
         11084     build 4.2.2.98 55 code snippets  openurl
         11085     build 4.2.2.98 II more snippets in utilsmx4
         11104    build 4.2.4.25 one unit many fixes and new functions asn1 back - globallock
         11125    build 4.2.4.60 new stream concept - WMI - RegSvr  - Utilsmax5 - webtop - webbox - shorts
         11160     build 4.2.4.80 second units dragdrop tcontrol  ocean7 dateutil - dateutils  -win32find - locale
         11171     build 4.2.4.80 II unicode dosextend checksystem
         11230          build 4.2.5.10 atom edit and 6 units more  hugeword RSA
          11235         build 4.2.5.10 II with Xbase lib and routines
          11240         build  4.2.5.10 III  histogramm speed opti - hook functions   anothe winsock
          11250       build 4.2.5.10 IV  wdosdrivers astronomy2
                  [the last one before V4.5 in 2016]  V4.5   in  March 2017
          11286       build 4.2.6.10  I  WMI III StreamStorage Series   SHA256 Double August 2017
          11321       build 4.2.8.10  XMLDoc XMLIntf, ADO _Recordset  CryptoLib4, XMLW  Oct 2017
          11362         build 4.2.8.10 II ini enhance  XML3  DEP Boot  Webhelp
          11410       build 4.2.8.10 III include bug - xml save saveF1  - to do list not modal -terminal stylebase
          11440      b. 4.2.8.10 IV 2app, DEP $DYNAMICBASE ON, tabindent , maxxmlutils2
          11554   4.5.8.10  III  prepare for code folding with indent guide  - hash maps - coderheader check2 ifdef
          11605   4.5.8.10 IV   fann neural nwtwork - january 2018  - background worker II  - bugfix thread II
          11624   4.6.2.10   3 few pascalcoin units     -compact exe
          11667   4.6.3.10   -compact exe  matrix, statemachine, RSA+, DX9 Tools <matrix metric> , FlyFilesUtils
          11680   4.7.1.5     prepare test  commdrv   add some fixes and docu update 2 Platform eXtended Library
          11755   4.7.1.10   interactive shell , graphics brush, statemachine font , odometer, cgirunner
          11780   4.7.1.20   test only exchange and visual state check  - overbytes units, drbobcgi  movestring
          11808   4.7.1.80    alcinoe plus  , runjs, phprunner2, ISAPI plus  , more Execfunctions, Dec. 2019
          11836   4.7.1.82 II turbopower lockbox 3 updates, TURL  from EWB  , sendmail for EWB
          11855   4.7.2.82 II rss feeds lockbox3 updates, tmaskedit, blobstream , printtext, 2Prometheus Library
          11863   4.7.3.60 a bit neural bit   - neuralab, neuralbit , getoutdevices
          11877   4.7.4.60 add neural CAI  - wmiserv2  - winsvc2
          11892   4.7.4.62 json2 lib and bug fixing   listbox, checklistbox
          11914   4.7.4.64 json2 bugfix , cybernetics bricks and lifeblocks
          11990   4.7.5.20 some Fundamentals 5.00  , more jcl fixes, GraphMathLibrary - StringBuilder -second
          12002   4.7.5.20 II some Fundamentals 5.00, m -second Synth- patternmatch .unicode char test, ASCII routines AsCIITalk
          12056   4.7.5.80 II Delphi4Python Base, richedt bugfix, xmlrss parser  wdc_, _stringutils , varpyth, jcl+
          12093   4.7.5.80/90 IV/III fix P4D dll bug, +python versions, eval+exec as string, vectclass,register python
          12112   4.7.5.90 III TNNeural Network CAI  uPSI_neuralnetworkCAI;  neuralfit, neuraldatasets
          12117   4.7.5.90 V TNeuralNetwork neuralfit ipdate  - verbose and debug mode in neuralnetwork
          12120   4.7.5.90 VI bugfixiing neuralnetwork, customapp - prepare for Pas2JS - convolution tests
          12140   4.7.6.10 2 new units  neuralthreas debugweights usystools - uwinNT
          12150   4.7.6.10 II plus ovc units overbyte  and metronom  _ics overbyteutils experimental
          12170   4.7.6.10 III several fixes, SeSHA256.pas  , blockchain, deltics base lib
          12180   4.7.6.10 IV richedit.plaintext ,clJSON, rollercoaster, ARRsoundstr, deltics baselib 2, mars utils
          12184   4.7.6.10 V synpy, pagecontrol fixes , CAI bugs , Azulia
          12262   4.7.6.10 VIII neuronclass, QRCode, CAI bugs, commondelphi, AVXcheck, CAR console application runner, upsutils, klibutils
          12275   4.7.6.10 IX unit ALHttpClient2 ils    OpenAPI Extensions for EKON26  ALWininetHttpClient2
          12280   4.7.6.10 X unit unit uPSI_RestUtils;   TEEChart extensions , WGet3()
          12298   4.7.6.20 bugfixing teEngine, tecanvas , PSResources TFEditorBuildRegFuncList(Sender: TPSScript);
          12312   4.7.6.20 V bugfixing teEngine, TChart , neuralfit, INet, elevated support, webpostdata2, synCrtSock;
          12316   4.7.6.20 VIII httpsender - uPSI_HttpConnection;, interface support RESt client
          12320   4.7.6.20 IX restclient, jsonconverter, jazzsound, superobject
          12410   4.7.6.50 I internals  - TProcess2 dprocess - xmlstorage  -AsphyreTimer -pacman core  -superobject
          12414   4.7.6.50 II internals  - TProcess2 dprocess - xmlstorage  -AsphyreTimer -pacman core  -superobject
          12420   4.7.6.50 III internals  - TJvCreateProcess2 - syscomp  -  -superobject fix teebar jpeg res ocean330
          12430   4.7.6.50 IV collusive outcome, TExporter , SIRegister_uExporterDestinationCSV, TRexporter
          - try   5.0.1.10  could not run - pre alpha state  - 20.8.2023
          12481   5.0.1.11 first time 24/08/2023 double compile - py64 test passed!!
          12506   5.0.1.12 re register and import std, stdctrsl, classes, forms & graphics, bccompatible
          12518   5.0.1.13 x64 string return works, create CreateOleObject and variant from IDispatch works
          12541   5.0.1.14 maxform1. reflection utf8decode for loadfile, umath, getwebscript, jvchart
          12542   5.0.1.15 maxform1. madexcept utf8decode for loadfile, umath, getwebscript, jvchart
          12584   5.0.1.17 GPS2, ADOTest, ADODB, GPS, VendorTestFramework , dmath2 ,statmach, uPSI_SHDocVw;
          12600   5.0.1.18 unit SynEditMiscClasses2;,unit SynEdit2; prepare for Clear or TrackChanges;
          12721   5.0.1.20 DProcess, upsi_process , redefine te_engine, techart, pos-fix, PCRE PerlRegEx , classes_orig, Novus
          12728   5.0.1.22 Novus Line , Todoe, serial monitor, code.search, rest adds, ResurceStream - Release build, makeAPP
          12797   5.0.2.24 d11.3 on Win11  aboutbox, finddlg, exception catch AV and debuginfo, debugmode, APILibs
          12808   5.0.2.28 wine compatible, GUI Automation, JSON Converter, API_Base
          12844   5.0.2.40 APITrackbar, LEDGrid, JSON Converter, API_Base2, rfc1213, wordwrap logic, Python3.12
          12925   5.0.2.70 saveasunicode UTF-8  , PythonVersions, saveasansi, ctools, savestringUC, loadfileUC, flcunicodecodecs
          12932   5.0.2.80 exit3() , orig delphi regex tregex record class , unicode_encode_unit.pas
          12936   5.0.2.90 IOHandler Indy10, unicodetester, bindings, httpserver, tcpserver, commandhandler
          12937   5.0.2.95 IOHandler Indy10, udpserver, bindings, idmessager, DNSResolver, arcade5
          12938   5.0.3.40 IOHandler Indy10, streaming resources, DNSResolver2, CastBaseServer
          12945   5.0.3.60 tDict2, umakecitylocations, UTF32Resolver2, PM2, CastBaseServer
          12998   5.0.4.70 +resource explorer library PM.2 res, pacMAIN, pacscores, loadjpegres, GOL
          13010   5.1.4.80 +XN Resource Editor , RSH Server, image Preview, BCD, PaC Analyzer, NavUtils
          13030   5.1.4.90 +OAuth O ,(@)GetGeoInfoMap5save, TBytes Viewer, bigfixing
          13035   5.1.4.95 SynCrtSock.pas, bigfixing, ALMultipartformdata , TIdMultiPartFormDataStream, modbus_indy10
          13044   5.1.4.98 HTTPUtils , HttpComponent, TIdMultiPartFormDataStream, modbus_indy10_2, stringstream savetofile(stream)
          13070   5.1.4.98 VII XNClasses, XOpenGL, VectorGeometry, GLScriptPython, Charsetmap, FBX, MySQL
          13088   5.1.4.98 VIII-IX uWebUI, RegexIII, Charsetmap+, truncate, uPSI_ComObjOleDB_utils2, idwebsocketclient, uwebsocket
          13115   5.1.4.98 XIV uwebsocket2, nDoneWithPostStream , chartcolormap, customtcpserver, WebString, McJSON, codemap
          13180   5.1.6.98 XX-XIX -XVIII regularexpression2, edgeview2 runtime kit VCL.Edge - TEdgeViewForm, RichEdit5, minor fixes, MIDI Keys
          13214   5.1.7.120 D12.1 test small refactoring  - power - memoutf8  UNICODE_CHARSET transparent
          13268   5.2.8.140 May 2025 D12.1 plus 24 units  - python 3.13, 3.14 integration P4D  gogame, jclsysinfo update
          13280   5.2.9.160 June 2025 D12.1 plus 28 units  - http_getstream, jpeg imageclass update fillchar, htm,rtf export fix, synhtml, synunicode
          13286   5.2.9.170 June 2025 fix bug in debug  - jclsvc more methods, funky resource, getjpegfromresname()
          13295   5.2.9.180 July 2025 fix bug in colorgrid  - minesweeper5, itemheights, mX5 Chess engine, getjpegfromresname()

************************************************************************************* }

unit fMain;

interface

   //USB Support of  FTD2XX = 'ftd2xx.dll';
   //{$DEFINE CD2XXUNIT}

uses
  Forms, SysUtils, uPSComponent, uPSCompiler, uPSRuntime, Menus,
  Classes, ExtCtrls, Controls, StdCtrls,  SynEditHighlighter,
  SynHighlighterPas, SynEdit, {SynMemo,SynEdit2} SynEditMiscClasses, SynEditSearch,
  XPMan, Buttons, Dialogs, uPSComponent_Default, Messages,
  uPSComponent_Controls, SynCompletionProposal, SynEditPrint, SynEditAutoComplete,
  ImgList, ComCtrls, ToolWin, Graphics, uPSDebugger, uPSDisassembly,
  uPSComponent_COM, uPSComponent_StdCtrls, uPSComponent_Forms, uPSComponent_DB,
  SynHighlighterHtml, SynHighlighterTeX, SynHighlighterCpp, SynHighlighterSQL,
  SynHighlighterXML, SynHighlighterJava,  ide_debugoutput, SynHighlighterPHP,
  SynHighlighterCS, SynEditExport, SynExportHTML, Types, SynHighlighterPerl,
  SynHighlighterPython, SynHighlighterJScript, SynHighlighterRuby,
  SynHighlighterUNIXShellScript, SynEditPrintPreview, SynEditPrintTypes,
  SynHighlighterURI, SynURIOpener, SynHighlighterMulti, SynExportRTF, SynHighlighterCSS,
  SynHighlighterEiffel, SynHighlighterAsm, SynHighlighterDfm, SynHighlighterVB,
  SynHighlighterIni, SynHighlighterBat, SynHighlighterIDL,
  SynHighlighterVBScript, SynHighlighterMsg, syneditcodefolding,
  System.ImageList, syneditkeycmds, Vcl.Imaging.pngimage //, fmain_47650
  {,IWBaseControl,IWBaseHTMLControl}; //, jpeg;

const
   BYTECODE = 'bytecode.psb';        //3.5
   PSTEXT = 'PS Scriptfiles (*.txt;*.pas)|*.TXT;*.PAS';     //4.2.5.10
   PSMODEL = 'PS Modelfiles (*.uc)|*.UC';
   PSPASCAL ='PS Pascalfiles (*.pas)|*.PAS';
   PSINC = 'PS Includes (*.inc)|*.INC';
   PSALL = 'All files (*.*)|*.*';
   DEFFILENAME = 'firstdemo.txt';
   DEFINIFILE = 'maxboxdef.ini';
   FTD2XX = 'ftd2xx.dll';
   EXCEPTLOGFILE = 'maxboxerrorlog.txt';
   LOGFILE = 'maxboxlog.log';
   ALLFUNCTIONSLIST = 'upsi_allfunctionslist.txt';
   ALLFUNCTIONSLISTPDF = 'maxbox_functions.pdf';
   ALLFUNCTIONSLISTWEB = 'http://www.softwareschule.ch/maxbox_functions.txt';
   ALLOBJECTSLIST = 'docs\VCL.pdf';
   ALLRESOURCELIST = 'docs\upsi_allresourcelist.txt';
   ALLTYPELIST = 'maxbox_types.pdf'; //'maXboxTypeList.pdf';
   ALLUNITLIST = 'docs\maxbox5_2.xml'; //'in /docs;  change in 5.2
   INCLUDEBOX = 'pas_includebox.inc';
   BOOTSCRIPT = 'maxbootscript.txt';
   MBVERSION = '5.2.9.180';
   MBVER = '529';              //for checking!
   MBVER2 = '529180';              //for checking!
   EXENAME ='maXbox5.exe';
   MXSITE = 'http://www.softwareschule.ch/maxbox.htm';
   MXVERSIONFILE = 'http://www.softwareschule.ch/maxvfile64.txt';
   MXVERSIONFILE2 = 'http://www.softwareschule.ch/maxvfile264.txt';
   MXINTERNETCHECK = 'www.ask.com';
   MXMAIL = 'maxkleiner1@gmail.com';
   TAB = #$09;
   CODECOMPLETION ='bds_delphi.dci';
   ENDSIGN='end.';

type
  tbtString = AnsiString;

  Tmaxform1 = class(TForm)
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
    //memo1: TSynEdit;        //fix5
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
    AllFunctionsList1: TMenuItem;       //                                          3
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
    ADOWorkbench1: TMenuItem;
    SocketServer1: TMenuItem;
    FormDemo1: TMenuItem;
    Richedit1: TMenuItem;
    SimpleBrowser1: TMenuItem;
    Tools1: TMenuItem;
    Richedit2: TMenuItem;
    Browser1: TMenuItem;
    UnitAnalyzer1: TMenuItem;
    SynExport1: TMenuItem;
    DOSShell1: TMenuItem;
    ExporttoRTF1: TMenuItem;
    SynExporterRTF1: TSynExporterRTF;
    FindFunction1: TMenuItem;
    SOAPTester1: TMenuItem;
    Sniffer1: TMenuItem;
    AutoDetectSyntax1: TMenuItem;
    SynCssSyn1: TSynCssSyn;
    SynEiffelSyn1: TSynEiffelSyn;
    FPlot1: TMenuItem;
    N21: TMenuItem;
    PasStyle1: TMenuItem;
    Tutorial183RGBLED1: TMenuItem;
    Reversi1: TMenuItem;
    ManualmaXbox1: TMenuItem;
    BlaisePascalMagazine1: TMenuItem;
    SynAsmSyn1: TSynAsmSyn;
    AddToDo1: TMenuItem;
    CreateGUID1: TMenuItem;
    Tutorial27XML1: TMenuItem;
    SynDfmSyn1: TSynDfmSyn;
    SynVBSyn1: TSynVBSyn;
    CreateDLLStub1: TMenuItem;
    Tutorial28DLL1: TMenuItem;
    FileChanges1: TMenuItem;
    OpenGLTry1: TMenuItem;
    AllUnitList1: TMenuItem;
    spdbrowse: TSpeedButton;
    Tutorial29UML: TMenuItem;
    CreateHeader1: TMenuItem;
    Oscilloscope1: TMenuItem;
    Tutorial30WOT1: TMenuItem;
    SynIniSyn1: TSynIniSyn;
    GetWebScript1: TMenuItem;
    SynBatSyn1: TSynBatSyn;
    Checkers1: TMenuItem;
    TaskMgr1: TMenuItem;
    WebCam1: TMenuItem;
    Tutorial31Closure1: TMenuItem;
    GEOMapView1: TMenuItem;
    SynIdlSyn1: TSynIdlSyn;
    Run1: TMenuItem;
    GPSSatView1: TMenuItem;
    N3DLab1: TMenuItem;
    ExternalApp1: TMenuItem;
    PANView1: TMenuItem;
    Tutorial39GEOMaps1: TMenuItem;
    UnitConverter1: TMenuItem;
    SynVBScriptSyn1: TSynVBScriptSyn;
    MyScript1: TMenuItem;
    Terminal1: TMenuItem;
    SynMsgSyn1: TSynMsgSyn;
    Tutorial361: TMenuItem;
    ArduinoIOT1: TMenuItem;
    TrainingArduino1: TMenuItem;
    Chess41: TMenuItem;
    OrangeStyle1: TMenuItem;
    Darkcolor1: TMenuItem;
    MyScript21: TMenuItem;
    ExternalApp22: TMenuItem;
    ShowIndent1: TMenuItem;
    JumptoTerminal1: TMenuItem;
    JumptoOutput1: TMenuItem;
    memo1: TSynEdit;
    Collapse1: TMenuItem;
    ImageList3: TImageList;
    SaveasUnicode1: TMenuItem;
    PacManX51: TMenuItem;
    Richedit5: TMenuItem;
    midikey: TMenuItem;
    PSScript1: TPSScript;
    GoGame51: TMenuItem;      //SynEdit1
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
    procedure cedebugBreakpoint(Sender: TObject; const FileName: tbtString;
      Position, Row, Col: Cardinal);
    procedure cedebugCompile(Sender: TPSScript);
    procedure cedebugExecute(Sender: TPSScript);
    procedure cedebugIdle(Sender: TObject);
    procedure cedebugLineInfo(Sender: TObject; const FileName: tbtString;
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
    procedure ADOWorkbench1Click(Sender: TObject);
    procedure SocketServer1Click(Sender: TObject);
    procedure FormDemo1Click(Sender: TObject);
    procedure Richedit1Click(Sender: TObject);
    procedure SimpleBrowser1Click(Sender: TObject);
    procedure HEXEditor1Click(Sender: TObject);
    procedure DOSShell1Click(Sender: TObject);
    procedure SynExport1Click(Sender: TObject);
    procedure ExporttoRTF1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FindFunction1Click(Sender: TObject);
    procedure SOAPTester1Click(Sender: TObject);
    procedure Sniffer1Click(Sender: TObject);
    procedure AutoDetectSyntax1Click(Sender: TObject);
    procedure FPlot1Click(Sender: TObject);
    procedure PasStyle1Click(Sender: TObject);
    procedure Tutorial183RGBLED1Click(Sender: TObject);
    procedure Reversi1Click(Sender: TObject);
    procedure ManualmaXbox1Click(Sender: TObject);
    procedure BlaisePascalMagazine1Click(Sender: TObject);
    procedure AddToDo1Click(Sender: TObject);
    procedure CreateGUID1Click(Sender: TObject);
    procedure Tutorial27XML1Click(Sender: TObject);
    procedure CreateDLLStub1Click(Sender: TObject);
    procedure Tutorial28DLL1Click(Sender: TObject);
    procedure FileChanges1Click(Sender: TObject);
    procedure OpenGLTry1Click(Sender: TObject);
    procedure AllUnitList1Click(Sender: TObject);
    procedure Tutorial29UMLClick(Sender: TObject);
    procedure CreateHeader1Click(Sender: TObject);
    procedure Oscilloscope1Click(Sender: TObject);
    procedure Tutorial30WOT1Click(Sender: TObject);
    procedure GetWebScript1Click(Sender: TObject);
    procedure Checkers1Click(Sender: TObject);
    procedure TaskMgr1Click(Sender: TObject);
    procedure WebCam1Click(Sender: TObject);
    procedure Tutorial31Closure1Click(Sender: TObject);
    procedure GEOMapView1Click(Sender: TObject);                 //    webspider
    procedure Run1Click(Sender: TObject);
    procedure GPSSatView1Click(Sender: TObject);
    procedure N3DLab1Click(Sender: TObject);
    procedure ExternalApp1Click(Sender: TObject);
    procedure PANView1Click(Sender: TObject);
    procedure Tutorial39GEOMaps1Click(Sender: TObject);
    procedure UnitConverter1Click(Sender: TObject);
    procedure MyScript1Click(Sender: TObject);
    procedure Terminal1Click(Sender: TObject);
    procedure Tutorial361Click(Sender: TObject);
    procedure TrainingArduino1Click(Sender: TObject);
    procedure Chess41Click(Sender: TObject);
    procedure OrangeStyle1Click(Sender: TObject);
    procedure Darkcolor1Click(Sender: TObject);
    procedure MyScript2Click(Sender: TObject);
    procedure ExternalApp22Click(Sender: TObject);
    procedure ShowIndent1Click(Sender: TObject);
    procedure JumptoTerminal1Click(Sender: TObject);
    procedure JumptoOutput1Click(Sender: TObject);
    procedure Collapse1Click(Sender: TObject);
    procedure SaveasUnicode1Click(Sender: TObject);
    procedure PacManX51Click(Sender: TObject);
    procedure Richedit5Click(Sender: TObject);
    procedure midikeyClick(Sender: TObject);
    function PSScript1NeedFile(Sender: TObject; const OrginFileName: tbtString;
      var FileName, Output: tbtString): Boolean;
    procedure Go5Click(Sender: TObject);
    //function PSScriptNeedFile(Sender: TObject; const OrginFileName: AnsiString;
      //var FileName, Output: AnsiString): Boolean;
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
    STATDebugcheck: boolean;     //V5.0.2
    STATActiveyellow: Boolean;
    STATVersionCheck: boolean;
    STATOtherHL: boolean;
    STATAutoBookmark: boolean;
    STATCodefolding: boolean;      //new4                                         3

    Act_Filename: string[255];
    ExternalApp: string[255];
    ExternalApp2: string[255];
    Act_Filestring: string;

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
    Last_fName9: string[255];
    Last_fName10: string[255];
    ledimage: TImage;
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
    //lbintflist: TListBox;
    tmpcodestr: string;
    fmemoclick: boolean;
    perftime: string;
    lbintflistwidth: integer;
    Mark: TSynEditMark;
    bookmarkimage: byte;
    factivelinecolor: TColor;
    fkeypressed: boolean;
    mFormatSettings, formatsettings: TFormatSettings;
     //procedure ListViewWndProc(var Msg: TMessage); //message WM_DROP;
    function CompileDebug: Boolean;
    function ExecuteDebug: Boolean;
    function RunCompiledScript(bytecode: ansistring; out RTErrors: string): boolean;
    procedure showandSaveBCode(const bdata: ansistring);
    procedure lineToNumber(met: boolean);
    procedure defFileread;
    procedure SaveFileOptionsToIni(const filen: string);
    procedure LoadFileNameFromIni;
    function GetClientTop: integer;
    function UpdateFindtext: string;
    procedure FindNextText(Sender: TObject);
    procedure FindNextTextEnd(Sender: TObject);
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
      out RuntimeErrors: String): Boolean;
    procedure SetTodoMarks(myFile: string);
   //procedure DoEditorExecuteCommand(EditorCommand: word);
  //  procedure WebScannerDirect(urls: string);
     procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
  public
    STATMemoryReport, codemap: boolean;
    IPHost: string[255];
    IPPort: integer;
    COMPort: integer;
    lbintflist: TListBox;
    //procedure FindNextText(Sender: TObject);
    function GetStatChange: boolean;
    procedure SetStatChange(vstat: boolean);
    function GetActFileName: string;
    function GetScriptPath: string;      //42810

    procedure SetActFileName(vname: string);
    function GetLastFileName: string;
    procedure SetLastFileName(vname: string);
    procedure WebScannerDirect(urls: string);
    procedure LoadInterfaceList2;
    function GetStatExecuteShell: boolean;
    function GetStatDebugCheck: boolean;
    procedure SetStatDebugCheck(ab: boolean);
    procedure DoEditorExecuteCommand(EditorCommand: word);
    function GetActiveLineColor: TColor;
    procedure SetActiveLineColor(acolor: TColor);
    //function keypressed2: boolean;
   //procedure defFilereadUpdate;
    function GetPerftime: string;
    procedure ResetKeyPressed;
    procedure SetKeyPressed;
    procedure SaveByteCode;
    function GetPSScript: TPSScript;
    //procedure SetDebugCheck(ab: boolean);
    //function LoadFile3(const FileName: TFileName): string;
 end;


var
  maxform1: Tmaxform1;

implementation

{$R *.dfm}

uses
  uPSR_std,
  uPSC_std,          //TObject!   TComponent
  uPSR_stdctrls,
  uPSC_stdctrls,    //listbox   , memo , button   ondatafind , customedit
  uPSC_classes_orig,   //memory stream    interfacelist, tlist, stringlist, collection   , resourcestream
  uPSR_classes_orig,    //stringstream createstring
  uPSR_forms,
  uPSC_forms,
  uPSI_Types, //3.5+3.6  dword-longword
  uPSC_graphics,          //canvas
  uPSC_controls_orig,   //tcontrol & twincontrol thackclass
  //uPSC_classes,
  //uPSR_classes,
  uPSComponentExt,
  uPSR_graphics,
  uPSR_controls_orig,
  uPSR_extctrls,   //TPanel  autosize
  uPSC_extctrls,
  uPSC_dateutils,
  uPSR_dateutils,
  uPSC_menus,
  uPSR_menus,
  uPSC_buttons,
  uPSR_buttons, //*)  //with function
  uPSI_mathmax,    //fix5
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
  IFSI_WinForm1puzzle_,  //fix5 to indy
  bossUnit1,
   Windows, {WinForm1,} FindReplDlg, ConfirmReplDlg, //, WinForm1;
   winform1,
  dlgSearchText,
  SynEditTypes,
  //ConfirmReplDlg,
    //FindReplDlg,     //new line!!!     *)
   //windows,
  ShellAPI,
  uPSI_ShellAPI,   //3.9.6.3
  uPSI_cFileUtils,
  uPSI_cDateTime,
  uPSI_cTimers,
  uPSI_cRandom,
  uPSI_ueval,
 // SynEditKeyCmds,  redeclare
  uPSI_SynEditKeyCmds,   //3.9.9
  uPSI_SynEditMiscProcs,
   uPSI_JvZoom,
  uPSI_PMrand,
  uPSI_JvSticker, //*)
  // ide_debugoutput,
   //ToolWin;
   //Types, Grids
  UCMainForm,
   JimShape,  //*)
   RXMain, //3.6.3
   EXEImage,
   DependencyWalkerDemoMainForm,
  WebMapperDemoMainForm,  //*)
  sdpStopwatch,
  //jclunicode conflict
  uPSI_JclStatistics,
  uPSI_JclMiscel,  //needs unicode.pas* fixed)
  uPSI_JclLogic,  //*)
  uPSI_uTPLb_StreamUtils,  //LockBox3
  uPSI_uTPLb_AES,
  uPSI_uTPLb_SHA2,
  uPSI_AESPassWordDlg,     //*)
  uPSI_MathUtils,
  uPSI_JclMultimedia,   //*)
  uPSI_FMTBcd,
  uPSI_TypeTrans,  //*)
  uPSI_DBCommonTypes,
  uPSI_DBCommon,  //3.1
  uPSI_DBPlatform, //3.6  *)
  uPSC_DB,
  uPSR_DB,
  //(*
  //uPSI_DBTables,
  uPSI_DBLogDlg, //3.9
  uPSI_SqlTimSt,    //*)
 //uPSI_Types, //3.5
  uPSI_Printers, //3.1  *)
  //uPSI_SqlExpr, //3.2  incompatible *)
   uPSI_ADODB,
 // uPSI_ADODButils,                       //( a//adosbtest   vardatasize
 uPSI_DBGrids,  //3.5.1   local fork of vcl.dbgrids
  uPSI_DBCtrls, //*)
  uPSI_DBCGrids,   //*)
  uPSI_Provider,
  uPSI_ImgList,
 uPSI_Clipbrd,  //*)
  uPSI_MPlayer,
  uPSI_RunElevatedSupport,
  uPSI_SynCrtSock,
//  uPSI_StrUtils,    move  down
  uPSI_StrHlpr, //3.2
 uPSI_FileUtils, //3.2
  IFSI_gsUtils, //3.2
  uPSI_JclBase,  //3.8.6!
  uPSI_JvgCommClasses,   //*)
  uPSI_JvgUtils, //*)                      //    j
  uPSI_JvFunctions,
  uPSI_JvVCLUtils, //3.8.2  *)
  uPSI_JvUtils, //3.8.6!
  uPSI_JvJCLUtils, //3.9!  *)
  //uPSI_JvDBUtil,
  uPSI_JvDBUtils,   //*)
  uPSI_JvAppUtils,   //*)
  uPSI_JvParsing,  //maXcalc
  uPSI_JvFormToHtml,
  uPSI_JvCtrlUtils,
 (* uPSI_JvBdeUtils,  *)
  uPSI_JvDateUtil, //3.8.6   *)
  uPSI_JvGenetic,
  uPSI_JvStrUtil,
  uPSI_JvStrUtils,
  uPSI_JvFileUtil,
  uPSI_JvMemoryInfos,
  uPSI_JvComputerInfo,   //*
  uPSI_JvCalc,
  uPSI_JvComponent, // *)
  uPSI_JvLED,
  uPSI_JvgLogics,  //*)
  uPSI_JvTurtle,
  uPSI_SortThds,
  uPSI_ThSort, thsort,
  uPSI_JvExprParser,  //*)
  uPSI_HexDump,
 uPSI_JvHtmlParser,
 uPSI_JvgXMLSerializer,
  uPSI_JvStrings,  //*)
  uPSI_uTPLb_IntegerUtils,
  uPSI_uTPLb_HugeCardinal,
  uPSI_uTPLb_HugeCardinalUtils,    //*)
  uPSI_SynRegExpr,    //RegExprStudio! .$DEFINE reRealExceptionAddr undefine
  uPSI_RegularExpressions,  //delphi ones based on perlregex
  uPSI_SynURIOpener,
  uPSI_EdgeMain,      // //5.1.6.98
  remain, // for richedit5
  uPSI_remain,
  uPSI_VclGoogleMap,
  gMainForm,         //googlemapedgeviewr
  SecondaryForm,
  HealthSystem_Unit1,

  uPSI_StBase,
  uPSI_StUtils,   //SysTools4 -3.9.1
  uPSI_IMouse,  //*)
  uPSI_SyncObjs,
  uPSI_AsyncCalls,
  //uPSI_ParallelJobs,  AV Crash//*)
  uPSI_OAuth,  //mX51490
  uPSI_Variants,       //olestream with IStream   regextest  res functions parsejsonvalue2
  uPSI_VarCmplx,
  uPSI_WebString,
  uPSI_McJSON, //V5.1.4.98 XII
  uPSI_DTDSchema, //*)
  uPSI_ShLwApi,
 uPSI_IBUtils,    //3.9.2.2 fin   *)
   uPSI_CheckLst,
  uPSI_JclSimpleXml,
  uPSI_JvSimpleXml,
  uPSI_JvXmlDatabase,  //((((*)
  uPSI_StGenLog,
  uPSI_JvComCtrls,
  uPSI_JvLogFile,
  uPSI_JvGraph,
  uPSI_JvCtrls, //*)
  uPSI_CPort,
  uPSI_CPortCtl,
  uPSI_CPortEsc, //3.9.3
  uPSI_StSystem,
 uPSI_JvKeyboardStates,
  uPSI_JvMail,
  uPSI_JclConsole,
  uPSI_JclLANMan,   //*)
  uPSI_BarCodeScaner, //*)
  uPSI_GUITesting,
  uPSI_JvFindFiles,  // *)
  uPSI_StToHTML,
   uPSI_StStrms,
  uPSI_StFIN, //*)
  uPSI_StAstro,  //*)
  uPSI_StDate,
  uPSI_StDateSt,
  uPSI_StVInfo,
  uPSI_JvBrowseFolder,
  uPSI_JvBoxProcs, //*)
  uPSI_urandom,
  uPSI_usimann,
  uPSI_JvHighlighter, //*)
  uPSI_Diff,   //*)
 // uPSI_cJSON,  //fundamentals  differs differs
  uPSI_StBits,
  uPSI_StAstroP,
  uPSI_StStat,
  uPSI_StNetCon,
  uPSI_StDecMth,     //cont
  uPSI_StOStr,    //errros
  uPSI_StPtrns,
  uPSI_StNetMsg,  //*)
  uPSI_StMath,
  uPSI_StExport,
  uPSI_StExpLog,
  uPSI_StFirst,
  uPSI_StSort,
  uPSI_ActnList, // execute *)
  uPSI_jpeg,
  uPSI_StRandom,
  uPSI_StDict,
  uPSI_StBCD, // *)
  uPSI_StTxtDat,   //*)
  uPSI_StRegEx,
  JvFunctions_max, //screenshot
  uPSI_Serial,  //3.8.4
  uPSI_SerDlgs,    //*)
  memorymax3,      //add on games  *)
  gewinntmax3,
  IdGlobal_max,   //3.7 for file information    *)
  StrUtils, uPSI_StrUtils,       // dupestring fillchar
  uPSI_dwsWebUtils,
  edgemain,

  uPSI_FileCtrl,    //3.5.1
  uPSI_Outline,
  uPSI_ScktComp,
  uPSI_Calendar,  //*)
  uPSI_ComCtrls, //3.6 ttreeview and listview!  richedit   trackbar tabsheet  datetimepicketr , tupdown  fix , pagecontrol

 uPSI_VarHlpr, //uPSI_Dialogs,  rmoved
  uPSI_ExtDlgs,
  uPSI_ValEdit,  //*)
  VListView,
  uPSI_utypes,     //for dmath.dll TFunc    TVector, TMatrix
  uPSI_FlatSB, //*)
  uPSI_uwinplot,  //*)
  uPSI_umath,
  uPSI_ugamma, //*)
  uPSI_StSpawn,  //*)
  uPSI_actionMain,
  uPSI_CtlPanel,          //          DragQueryFile( Drop : HDROP;  *)
  uPSI_LongIntList,
  uPSI_xrtl_util_CPUUtils,
  uPSI_xrtl_net_URI,
  uPSI_xrtl_net_URIUtils,
  uPSI_xrtl_util_StrUtils,
  uPSI_xrtl_util_COMCat,
  uPSI_xrtl_util_VariantUtils,
  uPSI_xrtl_util_FileUtils,
  xrtl_util_Compat,
  uPSI_xrtl_util_Compat,
  uPSI_OleAuto,
  uPSI_xrtl_util_COMUtils,
  uPSI_CmAdmCtl, //*)
  //uPSI_ValEdit,    redeclared
  //uPSI_GR32,
 (*ç uPSI_GR32_Image,
  uPSI_GR32_System, *)
  uPSI_CPortMonitor,
  uPSI_StIniStm,
 (* uPSI_GR32_ExtImage,      //3.9.7
  uPSI_GR32_OrdinalMaps,
  uPSI_GR32_Rasterizers,  *)
  uPSI_xrtl_util_Exception,
  uPSI_xrtl_util_Compare,
  uPSI_xrtl_util_Value,
  uPSI_JvDirectories,  //a
  uPSI_JclSchedule,
  uPSI_JvDBUltimGrid,
  uPSI_JclSvcCtrl,       //add helper function
  uPSI_JvSoundControl,
  //uPSI_JvBDESQLScript, //*)
  uPSI_JvgDigits, //*)
  uPSI_JclMIDI,
  uPSI_JclWinMidi,
  aide_clavier,       //for midi controller
  midimain,          //midi virtual keyboard
  uPSI_JclNTFS,
  uPSI_JclAppInst,
  uPSI_JvRle,
  uPSI_JvRas32,
  uPSI_JvImageDrawThread, //*)
  uPSI_JvImageWindow,
  uPSI_JvTransparentForm,
  uPSI_JvWinDialogs,
  uPSI_JvSimLogic,
  uPSI_JvSimIndicator,
  uPSI_JvSimPID,
  uPSI_JvSimPIDLinker, //*)
  uPSI_JclPeImage,      //anti virus routines   CL.AddTypeS('TImageFileHeader
  //uPSI_JclPrint,   not found
  uPSI_CompilersURunner,
  //uPSI_AzuliaUtils,   redeclare
  uPSI_JclMime,
  uPSI_JvRichEdit,
  uPSI_JvDBRichEd,
  uPSI_JvDice,   //*)
  uPSI_JvFloatEdit,    //3.9.8
  uPSI_JvDirFrm,
  uPSI_JvDualListForm, //*)
  uPSI_JvTransLED,
  uPSI_JvPlaylist,
  uPSI_JvFormAutoSize,
  uPSI_JvDualList,
  uPSI_JvSwitch,
  uPSI_JvTimerLst,
  // uPSI_JvMemTable,   //  BDE *)
  uPSI_JvObjStr,
  uPSI_xrtl_math_Integer,
  uPSI_JvPicClip,
  uPSI_JvImagPrvw,
  uPSI_JvFormPatch,  //((*)
  uPSI_JvDataConv,
  uPSI_JvCpuUsage,
  uPSI_JvCpuUsage2,   //*)
  uPSI_JvParserForm,
   uPSI_JvJanTreeView,
  uPSI_JvYearGridEditForm, //*)
  uPSI_JvMarkupCommon,   //*)
  uPSI_JvChart,  //*)
  uPSI_JvXPCore,  //add resource rc files!  res file  - in fundamentals_lib
  resMainForm2,                  //XN resource workshop from wilson!
  uPSI_JvXPCoreUtils,
  uPSI_JvSearchFiles,
  uPSI_JvSpeedbar,
  uPSI_JvSpeedbarSetupForm,   //3.9.8 fin  *)
  uPSI_ExcelExport,
 uPSI_JvDBGridExport,   //*)
  uPSI_JvgExport,
  uPSI_JvSerialMaker,  //*)
  uPSI_JvWin32, // *)
   uPSI_JvPaintFX,
   uPSI_JvValidators,
  //uPSI_JvOracleDataSet,
  uPSI_JvNTEventLog,    //3.9.8.6  *)
  uPSI_ShellZipTool,
  ShellZipTool, //numprocessthreads
  uPSI_JvJoystick,
  uPSI_JvMailSlots,
  uPSI_JclComplex,  //*)
  uPSI_SynPdf,          //3.9.8.8
  uPSI_Registry,
 uPSI_TlHelp32,
  uPSI_JclRegistry,
  uPSI_mORMotReport, //*)
  uPSI_JvAirBrush,
  uPSI_JclLocales,      //last  *)
  uPSI_XmlVerySimple, //*)
    uPSI_Services,
  uPSI_JvForth,                //*)
  uPSI_RestRequest,
 // HttpRESTConnectionIndy,
 // uPSI_HttpRESTConnectionIndy,
  //uPSI_JvXmlDatabase,  // redeclared *)
  uPSI_WinAPI,    //register simple upsi_windows
  uPSI_HyperLabel,
  uPSI_hhAvALT,
  uPSI_MultilangTranslator,
  //uPSI_TomDBQue,   //*)
  uPSI_Starter,
  uPSI_FileAssocs,
  uPSI_devFileMonitorX,  //*)
  uPSI_devrun,
  uPSI_devExec,
  ProcessListFrm,
  dprocess3,         //as TProcess2  --> TProcess
  uPSI_dpipes,
  uPSI_dprocess,       //parameters2 valid chaine
  //uPSI_cDictionaries,
  uPSI_oysUtils,
  tetris1,
  usniffer,
  uPSI_DosCommand,
  ViewToDoFm,  //3.9.9.6
  uPSI_CppTokenizer,
  uPSI_JvHLParser,
  uPSI_JclMapi,    //&&*)
  uPSI_JclShell, //3.9.9.6
  uPSI_JclCOM,
  (*uPSI_GR32_Math,
  uPSI_GR32_LowLevel,  //*)
  uPSI_SimpleHl,
 (* uPSI_GR32_Filters,
  uPSI_GR32_VectorMaps,  *)
  uPSI_cXMLFunctions, //*)
  uPSI_JvTimer,
  uPSI_cHTTPUtils,
  uPSI_cTLSUtils,     //3.9.9.7
  uPSI_JclGraphics, //*)
  uPSI_JclSynch,
 uPSI_IdEcho,
  uPSI_IdEchoServer,
  uPSI_IdEchoUDP,
  uPSI_IdEchoUDPServer,
  //uPSI_IdDsnRegister, *)
  uPSI_IdStack,
  uPSI_IdSocks,
  uPSI_IdTelnetServer,
  uPSI_IdAntiFreezeBase,
  //uPSI_IdHostnameServer,  nit found
  uPSI_IdTunnelCommon,
  //uPSI_IdTunnelMaster, //*)
  //uPSI_IdTunnelSlave, //*)
  uPSI_IdRSH,
  uPSI_IdRSHServer,  //*)
  uPSI_Spring_Cryptography_Utils,
  uPSI_MapReader,
  uPSI_LibTar,      //FileTimeGMT
  uPSI_IdChargenServer,  //*)
  uPSI_IdBlockCipherIntercept,  //3.9.9.8   *)
  //uPSI_IdFTPServer,
  uPSI_IdException, //*)
  uPSI_uwinstr,
  uPSI_utexplot,
  uPSI_VarRecUtils,
  uPSI_JvStringListToHtml,
  uPSI_JvStringHolder,
  uPSI_IdCoder, //*)
  uPSI_LazFileUtils,   //inc2
  uPSI_FileUtil,
  changefind,  // for change control
  uPSI_changefind,
  uPSI_cmdIntf,
  //uPSI_fservice,   //*)
  uPSI_Keyboard,
  uPSI_IDECmdLine,
  uPSI_ip_misc,  //*)
  uPSI_Barcode, //*)
  uPSI_SimpleXML,
  uPSI_JclIniFiles,
 (* //if fileexists(FTD2XX) then  //script file
  {$IFDEF CD2XXUNIT}
     uPSI_D2XXUnit,
  {$ENDIF}  *)
  uPSI_JclDateTime,
  uPSI_JclEDI,
  uPSI_JclMiscel2,  //*)
  uPSI_JclAnsiStrings,
  uPSI_JclStreams,
  uPSI_JclTask,             //V5.2.9.160

  uPSI_synautil,  //*)             uPSI_JclTask.pas
  uPSI_SRMgr,     // check finalization
  uPSI_HotLog,
  hotlog,
  (*
  soapunit1,   *)
  uPSI_DebugBox,
  uPSI_ustrings,
  uPSI_uregtest,
  uPSI_usimplex,
  uPSI_uhyper,
  uPSI_unlfit,
  uPSI_ExtPascalUtils,
  uPSI_SocketsDelphi,
  uPSI_StBarC,
  uPSI_StDbBarC,
  uPSI_StBarPN,
  uPSI_StDbPNBC,
  uPSI_StDb2DBC,  //*)
  uPSI_StMoney_,  // defwin64* or win32)
  uPSI_SynEditTypes,
  uPSI_SynEditMiscClasses,
  uPSI_SynEditHighlighter,
  uPSI_SynHighlighterPas,   //keywords like using
  uPSI_SynEdit,
  uPSI_SynEditRegexSearch,
  uPSI_SynMacroRecorder,  //*)
  SynMiniMap,               //5.1.4.98 XIV
  //uPSI_SynHighlighterAny,
  //SynHighlighterAny,
  uPSI_SynEditKbdHandler,
  uPSI_SynEditSearch,
  uPSI_SynEditExport,
  uPSI_SynExportHTML,      //update 5.2.8.160
  uPSI_SynExportRTF,     //3.9.9
  uPSI_SynHighlighterDfm,  //*)
  uPSI_SynHighlighterHtml,  //V5.2.8.160
  uPSI_lazMasks,
  //uPSI_SynEditMiscProcs, //* redeclare)
  uPSI_BlockSocket,
  //uPSI_IdExtHTTPServer,   //filetypetomimetype
   uPSI_JclMath,
   uPSI_uWebUIMiscFunctions,      //5.1.4.98 VIII -IX

  ScktMain, //SocketServer   *)
  SvcMgr,       //fix application namespace  to svcmgr.sapplication
  uPSI_ImageWin,
  uPSI_GraphWin,  //3.9.9.18
  frmExportMain,
  uPSI_frmExportMain,
  uPSI_SynDBEdit,
  uPSI_SynEditWildcardSearch, // *)
  uPSI_JvAppInst,
  uPSI_JvAppEvent,
  uPSI_JvAppCommand,
  uPSI_JvAnimTitle,
  uPSI_JvAnimatedImage,  //*)
  Unit1dll,     //DLL Spy Form
  uPSI_SynMemo,
  uPSI_IdMIMETypes,
  uPSI_JvConverter, //also in JvDataConv
  uPSI_JvCsvParse,   //*)
  uPSI_StatsClasses,
  uPSI_ExtCtrls2,         //TGridPanel TColorBox   itemheight
  uPSI_JvUrlGrabbers,
  uPSI_JvXmlTree,
  uPSI_JvWavePlayer,
  uPSI_JvUnicodeCanvas,
  uPSI_JvTFUtils,
  uPSI_StLArr,
  uPSI_StWmDCpy,
  uPSI_StText,
  uPSI_StNTLog,  //*)
  uPSI_JclUnitConv_mX2,   //*)
  uPSI_xrtl_util_TimeUtils,
  uPSI_xrtl_util_TimeZone,
  uPSI_xrtl_util_TimeStamp,
  uPSI_xrtl_util_Map,
  uPSI_xrtl_util_Set, //*)
  uPSI_VListView,
  uPSI_IdServerIOHandler,
  uPSI_IdServerIOHandlerSocket,   //*)
  uPSI_IdMessageCoder,
  uPSI_IdMessageCoderMIME,
  uPSI_IdMultipartFormData, //cause of http post; TIdMultiPartFormDataStream   *)
  uPSI_IdRawBase,
  //uPSI_IdNTLM,  *)
  uPSI_IdNNTP,
  uPSI_usniffer,
  uPSI_IdCoder3to4,
  uPSI_IdCoderMIME,
  uPSI_IdCoderXXE,
  uPSI_IdCoderUUE,
 (* uPSI_IdCookie,   *)
  uPSI_IdCookieManager, //*)
  uPSI_IdHTTPWebBrokerBridge,
  uPSI_IdIntercept, //*)
  uPSI_IdLogBase,
  uPSI_IdIOHandlerStream,  //*)
  uPSI_IdMappedPortUDP,  //*)
  uPSI_WDosSocketUtils,
  uPSI_WDosPlcUtils,
  uPSI_WDosPorts,
  uPSI_WDosResolvers,
  uPSI_WDosTimers,
  uPSI_WDosPlcs,
  uPSI_WDosPneumatics,     //3.9.9.80   *)
  uPSI_TextUtils, //TextUtils;
  //uPSI_DTDSchema,     rredeclare *)
  uPSI_MandelbrotEngine,
  uPSI_delphi_arduino_Unit1,
  uPSI_fplotMain,
  uPSI_FindFileIter,
  uPSI_PppState,
  uPSI_PppParser,
  uPSI_PppLexer,  //*)
  uPSI_PCharUtils, // *)
  uPSI_uJSON,
  uPSI_JclStrHashMap,
  uPSI_JclHookExcept,    //*)
  fplotMain, //add on
  uPSI_EncdDecd,
  //uPSI_SockAppReg,   not found
  uPSI_DbxSocketChannelNative,  //*)
  uPSI_DbxDataGenerator,
  uPSI_DBXClient,   // *)
  uPSI_IdGlobal,
  uPSI_IdIOHandler,     //V5.0.2.90 read & write!
  uPSI_IdIOHandlerSocket,  //3.9.3
  uPSI_IdTCPConnection, //3.1
  IFSI_IdTCPClient,  //*)
  uPSI_IdHeaderList,     //3.9.6
  uPSI_IdHTTPHeaderInfo,     //user agent compatible    *)
  IFSI_IdHTTP,               //getStream
  uPSI_HTTPParse, //3.2
  uPSI_HTTPUtil, //3.2  *)
  uPSI_HTTPApp, //3.7
  uPSI_IdSocketHandle,
  uPSI_IdCustomTCPServer, //V51498 X
  uPSI_IdTCPServer, //  for bindings 5.0.2.90*)
  uPSI_IdCustomHTTPServer, //TIdHTTPServer   *)
  uPSI_U_MakeCityLocations2,  // for demo 5.0.3.60
  uPSI_UDict2,
  IFSI_IdURI,
 IFSI_IdFTP,
  uPSI_IdRemoteCMDClient,
  uPSI_IdRemoteCMDServer, //*)
  uPSI_IdRexec,
  uPSI_IdUDPServer,   // *)
  uPSI_IdIPWatch,
  uPSI_IdMessageCollection,
  uPSI_IdIrcServer, //*)
  //uPSI_IdHL7,
  uPSI_IdIPMCastBase,
  uPSI_IdIPMCastServer, //*503)
  uPSI_IdIPMCastClient,  //*)
  uPSI_IdRawHeaders, //*)
  uPSI_IdRawClient,   //*)
  uPSI_IdRawFunctions,
  uPSI_IdTCPStream,
  uPSI_IdSNPP,  //*)
  AdoMain, //ADO Workbench   *)
  actionMain, //FormDemo   *)
  MDIEdit,  //RichEdit
  uPSI_MDIEdit,
  uPSI_AppEvnts,
  uPSI_ExtActns,     //3.9.9.20
  uPSI_JvRgbToHtml,
  uPSI_JvRemLog, //*)
  uPSI_JvSysComp,
 uPSI_JvTMTL,
  uPSI_JvWinampApi, //3.9.9.60    *)
  uPSI_MSysUtils,
  uPSI_ESBMaths2,
 uPSI_ESBMaths,  //*)
  uPSI_uLkJSON,
 uPSI_ZURL,
  uPSI_ZSysUtils,  //3.9.9.60
 uPSI_ZMatchPattern,
  uPSI_ZClasses,
  uPSI_ZCollections,
  uPSI_ZEncoding,
  uPSI_PJFileHandle,
  uPSI_PJEnvVars,
  uPSI_PJPipeFilters,
  uPSI_PJPipe,
  uPSI_PJConsoleApp,
  uPSI_UConsoleAppEx,  //3.9.9.80
  uPSI_UConsoleApp, //&&  V5.0.2
  uPSI_IdLogEvent,
  uPSI_Reversi, //*)
  uPSI_Geometry,
  uPSI_Textures,
  //uPSI_IdSMTPServer,
  uPSI_IB,
  uPSI_IBX,
 // uPSI_IWDBCommon,  not found
  uPSI_MyGrids,  //*)
  uPSI_SortGrid,
  uPSI_IBScript,
  uPSI_JvCSVBaseControls,
  uPSI_Jvg3DColors,
  uPSI_JvHLEditor,
  uPSI_JvHLEditorPropertyForm,
  uPSI_JvFullColorForm,
  uPSI_JvSegmentedLEDDisplayMapperFrame,  //*)
  uPSI_JvShellHook,    //*)
  uPSI_JvSHFileOperation,     //3.9.9.82
  uPSI_uFilexport,
  uPSI_JvDialogs,
  uPSI_JvDBTreeView,   // *)
  //uPSI_JvDBUltimGrid,  redeclare
  uPSI_JvDBQueryParamsForm, //*)
  uPSI_JvExControls,
  //uPSI_JvBDEMemTable,   *)
  uPSI_JvCommStatus,
  //uPSI_JvMailSlots,    redeclare*)
  uPSI_JvgWinMask,  //3.9.9.82   *)
  uPSI_StEclpse,
  uPSI_StMime, //*)
  uPSI_StList,
  uPSI_StMerge,
 // uPSI_StStrS,     //nt found Shortstring functions !
  uPSI_StTree,
  uPSI_StVArr, //*)
  uPSI_StRegIni, // *)
  uPSI_usvd,   //*)
  uPSI_DepWalkUtils,
  uPSI_OptionsFrm,
  uPSI_yuvconverts,  // *)
  uPSI_JvPropAutoSave,
  uPSI_AclAPI,
  uPSI_AviCap,   //*)
  //uPSI_ALAVLBinaryTree,  //* build problem internal error!)
  uPSI_ALFcnMisc,
 //uPSI_ALStringList,
  uPSI_ALQuickSortList,  //*)
  uPSI_ALStaticText,
  uPSI_ALJSONDoc,
  uPSI_ALGSMComm,    //*)
  uPSI_ALWindows,
  uPSI_ALMultiPartBaseParser,
  uPSI_ALMultiPartFormDataParser,
  uPSI_ALMultiPartAlternativeParser,  //*)
  uPSI_ALHttpCommon,
  uPSI_ALHttpClient,
  uPSI_ALWebSpider,
  //uPSI_ALHttpClient,  redelare
  uPSI_ALFcnHTML,  //*)
  uPSI_ALFTPClient,
  uPSI_ALInternetMessageCommon,  // *)
  uPSI_ALWininetHttpClient,
  uPSI_ALWininetHttpClient2,
  uPSI_ALWinInetFTPClient, //*)
  uPSI_ALWinHttpWrapper,          ///ALHttpClient2
 uPSI_ALWinHttpClient,
  uPSI_ALFcnWinSock,
  //uPSI_ALFcnSQL,   *)
  uPSI_ALFcnCGI,  //*)
  uPSI_ALFcnExecute,  //*)
  uPSI_ALHttpClient2,          //PostUrlEncoded0, PostUrlEncoded1

  uPSI_ALFcnFile,
  uPSI_ALFcnMime,
  uPSI_ALPhpRunner,     //*)
  uPSI_ALGraphic,
  uPSI_ALIniFiles,
  uPSI_ALMemCachedClient,  //3.9.9.84   *)
  uPSI_ALMultiPartMixedParser,
 (* uPSI_ALSMTPClient,
  uPSI_ALHttpClient2,
  //uPSI_ALfcnString,
  uPSI_ALNNTPClient,  *)
  uPSI_ALHintBalloon,  //*)
  uPSI_ALXmlDoc,
  uPSI_IPCThrd,
  uPSI_MonForm, //3.9.9.84    *)
  uPSI_ovcmisc,
  uPSI_ovcfiler,
  uPSI_ovcstate,
  uPSI_ovccoco,      //scanner grammar!
  uPSI_ovcrvexp,
  uPSI_OvcFormatSettings,
  uPSI_ovcstore,
  uPSI_ovcstr,
  uPSI_ovcmru,
  uPSI_ovccmd,
  uPSI_ovctimer,
  uPSI_ovcintl,   //*)
  uPSI_AfCircularBuffer,   //*)
  uPSI_AfUtils,         //regopenkey advapi_ADVAPI32.DLL  wGetClassName , hooks   API
  uPSI_AfSafeSync,
  uPSI_AfComPortCore,
  uPSI_AfComPort,
  uPSI_AfPortControls,  //*)
  uPSI_AfDataDispatcher,
  uPSI_AfViewers,
  uPSI_AfDataTerminal,
  uPSI_SimplePortMain, //3.9.9.85   //tportform1   *)
  uPSI_simplecomport,
  uPSI_ovcclock,
  uPSI_o32intlst,
  uPSI_o32ledlabel,
  uPSI_AlMySqlClient,  // V 5.1.4.98 V//*)
  uPSI_ALFBXLib,
  uPSI_ALFBXClient,
  uPSI_ALFcnSQL,
  uPSI_AsyncTimer,
  uPSI_ApplicationFileIO,  //9.85  *)
  uPSI_PsAPI,      //processmemory , createprocess, exitthread  , addspeed
 uPSI_ovcuser,
  uPSI_ovcurl,
 // uPSI_ovcvlb,  internal error
  uPSI_ovccolor,
  //uPSI_ALFBXLib,
  uPSI_ovcmeter,
  uPSI_ovcpeakm,
  //uPSI_O32BGSty,
  uPSI_ovcBidi,     //9.86
  uPSI_ovctcary,
  uPSI_DXPUtils,
 (* uPSI_ALPOP3Client, *)
  uPSI_SmallUtils,
  uPSI_MakeApp,
  uPSI_O32MouseMon,
  uPSI_OvcCache,
  uPSI_ovccalc,
  uPSI_Joystick,  //*)
  uPSI_ScreenSaver,
  uPSI_XCollection,
  uPSI_Polynomials,   //*)
  uPSI_PersistentClasses, //9.86
  uPSI_XOpenGL,  //*)
  uPSI_VectorLists_,
  uPSI_MeshUtils,  //  vector geo*)
  uPSI_JclSysUtils,
  uPSI_JclBorlandTools,
 uPSI_JclFileUtils_max,    //*)
  uPSI_AfDataControls,
  uPSI_GLSilhouette, // *)
  uPSI_VRMLParser,
  uPSI_GLFileVRML, //*)
  uPSI_Octree,
  uPSI_GLPolyhedron, //*)
  uPSI_GLCrossPlatform,
   uPSI_GLParticles,  //*)
  uPSI_GLNavigator,
  uPSI_GLStarRecord, //*)
  uPSI_GLCanvas, //*)
  uPSI_GeometryBB, //*)
  uPSI_GeometryCoordinates,  //*)
  uPSI_VectorGeometry, //*)
  uPSI_unitCharsetMap,
  uPSI_XnClasses,                 //51498 II
  uPSI_TGA,
  uPSI_GLScriptPython,
  //uPSI_GLVectorFileObjects,  //3.9.9.88   *)
  uPSI_ButtonGroup,
  uPSI_CategoryButtons,
  //uPSI_DbExcept,
  gl_actorUnit1, // open gl demo for I := 0 to List.Count - 1 do   *)
  uPSI_AxCtrls,
  uPSI_gl_actorUnit1,
  uPSI_StdVCL,     //only in^terfaces
  uPSI_DataAwareMain,  //3.9.9.88
  uPSI_TabNotBk, // *)
  uPSI_Tabs,
  uPSI_udwsfiler,  //*)
  uPSI_synaip,
  uPSI_synacode,
  uPSI_synachar,  //*)
  uPSI_synamisc,
  synamisc, //for dns info
  uPSI_synaser,      //serial asm  TBlockSerial
  uPSI_synaicnv,
  uPSI_tlntsend,
  uPSI_pingsend,  //*)
  uPSI_blcksock,
  uPSI_asn1util,
  uPSI_dnssend,
  uPSI_clamsend, //*)
  uPSI_ldapsend,   //*)
  uPSI_mimemess,
  uPSI_slogsend, //*)
  uPSI_mimepart,
  //uPSI_mimeinln,  *)
  uPSI_ftpsend,
  uPSI_ftptsend,  // *)
  uPSI_httpsend,
  uPSI_sntpsend,
  uPSI_smtpsend,
  uPSI_snmpsend,    //3.9.9.91
  uPSI_imapsend,
  uPSI_pop3send,
  uPSI_nntpsend,
  //uPSI_ssl_sbb,
  //uPSI_ssl_cryptlib,
  //{$IFDEF CD2XXUNIT}
    // uPSI_ssl_openssl,
  //{$ENDIF}
  uPSI_ssl_openssl,  //3.9.9.91  *)
  uPSI_synhttp_daemon,
  uPSI_NetWork,
  uPSI_PingThread,
  uPSI_JvThreadTimer,    //*)
  uPSI_wwSystem,
  uPSI_IdComponent,
  uPSI_IdIOHandlerThrottle,  //*)
  uPSI_Themes,
  uPSI_StdStyleActnCtrls,
  uPSI_UDDIHelper,
 // uPSI_IdIMAP4Server,
  uPSI_VariantSymbolTable, //3.9.9.92   *)
  uPSI_udf_glob,
  uPSI_TabGrid,
  uPSI_JsDBTreeView,
  uPSI_JsSendMail, //*)
  //uPSI_dbTvRecordList,  *)
  uPSI_TreeVwEx,
 // uPSI_ECDataLink,       BDE
(*  uPSI_dbTree,      //properties     *)
 // uPSI_dbTreeCBox,   *)
  uPSI_Debug,  //3.9.9.92
  // uPSI_FileIntf,    file not found
  //uPSI_SockTransport,   *)
  uPSI_WinInet,
  uPSI_Wwstr,
 //uPSI_DBLookup,     not founc
 // uPSI_Printgri, *)
  uPSI_Hotspot,
  uPSI_HList,
 //&& uPSI_DrTable,   bde *)
  uPSI_TConnect,
  uPSI_DataBkr,  //*)
  uPSI_HTTPIntr,        //httpserver
  uPSI_Mathbox,  //3.9.9.94
  uPSI_cyIndy,  //*)
  uPSI_cySysUtils,
  uPSI_cyWinUtils,
  uPSI_cyStrUtils,
  uPSI_cyObjUtils,
  uPSI_cyDateUtils,
 (* uPSI_cyBDE,   *)
  uPSI_cyClasses,
  uPSI_cyGraphics,  //3.9.9.94_2
  uPSI_cyTypes,
  uPSI_JvDateTimePicker,
  uPSI_JvCreateProcess,
  uPSI_JvEasterEgg,
  uPSI_JvDatePickerEdit,  //*)
  uPSI_WinSvc,
  uPSI_WinSvc2,   //*)   extension to /JclSvcCtrl.pas
  uPSI_SvcMgr,
 uPSI_JvPickDate,
  //uPSI_JvNotify,     errors
  uPSI_JvStrHlder,   //*)
  uPSI_JclNTFS2,
  uPSI_Jcl8087, //3.9.9.94_3
  uPSI_JvAddPrinter,
  uPSI_JvCabFile,   //*)
  uPSI_JvDataEmbedded,
  U_HexView,
  uPSI_U_HexView,
  uPSI_UWavein4,
  uPSI_AMixer,
  U_Oscilloscope4, //in 'U_Oscilloscope4.pas' {frmMain},
  U_Spectrum4, // in 'U_Spectrum4.pas' {Form2},
  //uPSI_JvBoxProcs,     redecalre
  uPSI_JvaScrollText,
  uPSI_JvArrow,    //3.9.9.95   *)
  uPSI_UrlMon,
  uPSI_U_Oscilloscope4,
  uPSI_DFFUtils,       //regexpathfinder
  uPSI_MathsLib,
  uPSI_UIntList,
  uPSI_UGetParens, //i//n DFFUtils
  uPSI_UGeometry,
  uPSI_UAstronomy, //3.9.9.95
  uPSI_USolarSystem,   //4.7.4.62

  uPSI_UCardComponentV2,
  uPSI_UTGraphSearch, //*)
  uPSI_UParser10,
  uPSI_cyIEUtils, //*)
  uPSI_UcomboV2,   //3.9.9.96
  uPSI_cyBaseComm,
  uPSI_cyAppInstances,
  uPSI_cyAttract,
  uPSI_cyDERUtils,
  uPSI_cyDocER,  //3.9.9.96
  uPSI_ODBC,
  uPSI_AssocExec,
  uPSI_cyBaseCommRoomConnector,
  uPSI_cyCommRoomConnector,   //*)
  uPSI_cyCommunicate,
  uPSI_cyImage,
  uPSI_cyBaseContainer,
  uPSI_cyModalContainer,
  uPSI_cyFlyingContainer,  //3.9.9.96_1   *)
  uPSI_RegStr,
  uPSI_HtmlHelpViewer,     ////3.9.9.96_2
  uPSI_cyIniForm,
  uPSI_cyVirtualGrid,
  uPSI_Profiler,
  uPSI_BackgroundWorker,  //*)
  uPSI_WavePlay,
  uPSI_WaveTimer,
  uPSI_WaveUtils,  ////3.9.9.96_3   *)
  dlgMain,  //CHECKERS GAME    dlgmain2 needs register gameboard bpl
  uPSI_NamedPipes,
  uPSI_NamedPipeServer, //*)
  uPSI_process,
  uPSI_DPUtils,
  uPSI_CommonTools,
  uPSI_DataSendToWeb,
  uPSI_StarCalc,
  uPSI_D2_VistaHelperU,   ////3.9.9.98     *)
  uPSI_ProcessUnit,
  uPSI_pipes,
  uPSI_adgsm,   //*)
  uPSI_BetterADODataSet,
 uPSI_AdSelCom,      ////3.9.9.98_1    *)
  uPSI_dwsXPlatform,
  uPSI_AdSocket,
  uPSI_AdPacket,
  uPSI_AdPort,   ////3.9.9.98_1
  uPSI_PathFunc,
  uPSI_CmnFunc2,
  uPSI_CmnFunc,  ////3.9.9.98_2
  uPSI_BitmapImage,
  uPSI_ImageGrabber,
  uPSI_SecurityFunc,
  uPSI_RedirFunc,
  uPSI_FIFO,
  //uPSI_Int64Em,   *)
  uPSI_InstFunc,
  uPSI_ScriptFunc_R,  //findfirst tester
  uPSI_LibFusion,  //*)
  uPSI_SimpleExpression,
  uPSI_unitResourceDetails,
  uPSI_unitResFile,     ////3.9.9.98_3  *)
  uPSI_Console,
  //uPSI_PlayCap,
  uPSI_AnalogMeter,
  uPSI_XPrinter, //*)
  uPSI_lazIniFiles, //*)
  uPSI_testutils,
  uPSI_ToolsUnit,
  uPSI_fpcunit,  //*)
  uPSI_testdecorator,
  uPSI_fpcunittests,
  uPSI_cTCPBuffer,  ////3.9.9.98_5   *)
  uPSI_Glut,  // *)
  uPSI_LEDBitmaps,
  uPSI_FileClass,
  uPSI_FileUtilsClass,
  uPSI_ComPortInterface,
  uPSI_SwitchLed,
  uPSI_cyDmmCanvas,
  uPSI_uColorFunctions,   //*)
  uPSI_uSettings,
  uPSI_cyDebug,   ////3.9.9.98_6
  uPSI_cyBaseColorMatrix,
  uPSI_cyColorMatrix,
  uPSI_cyCopyFiles,
  uPSI_cySearchFiles,
  uPSI_cyBaseMeasure,
//  uPSI_PJIStreams, //3.9.9.98_6  *)
  uPSI_cyRunTimeResize,
  uPSI_jcontrolutils,
  uPSI_kcMapViewer, //add GeoNames
  uPSI_kcMapViewerDESynapse,  //*)
  uPSI_cparserutils,    //3.9.9.98_7   *)
  //uPSI_GIS_SysUtils,  //*)
  uPSI_LedNumber,
  uPSI_StStrL,         //3.9.9.98_8
  uPSI_indGnouMeter,  //*)
  uPSI_Sensors, //)
  uPSI_pwmain,   //beta but stable, 2015 V4
  pwnative_out,          // for interactive shell cli
  uPSI_pwnative_out,
  uPSI_HTMLUtil,
  uPSI_synwrap1,
(*  uPSI_W32VersionInfo,   *)
  uPSI_IpAnim, //*)
  uPSI_IpUtils,
  uPSI_LrtPoTools,
  uPSI_Laz_DOM,  //3*)
  uPSI_hhAvComp,          //3.9.9.101   *)
  uPSI_GPS2,
  uPSI_GPS,  //*)
  //uPSI_GPSUDemo,      internal erros!
  GPSUDemo, //for form call; *)
  uPSI_IsNavUtils2,
  uPSI_NMEA,        //3.9.9.101
  uPSI_ScreenThreeDLab,
  ScreenThreeDLab,   //form call  *)
  uPSI_Spin,
  uPSI_DynaZip,   //*)
  uPSI_clockExpert,
  uPSI_SortUtils,  //*)
  uPSI_BitmapConversion,
  uPSI_JclTD32,  //3.9.9.110   *)
  uPSI_ZDbcUtils,
  uPSI_ZScriptParser,//*)
  uPSI_JvIni,
  uPSI_JvFtpGrabber,    // *)
  uPSI_NeuralNetwork,
  uPSI_StExpr,
  panUnit1,      //panorama Viewer
 (* uPSI_GR32_Geometry,
  uPSI_GR32_Containers,
  uPSI_GR32_Backends_VCL,   *)
  uPSI_StSaturn,    //all other planets!
  uPSI_JclParseUses,
  uPSI_JvFinalize,    //3.9.9.120
  uPSI_panUnit1,
  uPSI_DD83u1, //*)
  uPSI_BigIni, //*)
  uPSI_ShellCtrls,
  uPSI_fmath,
  uPSI_fcomp,     //3.9.9.160
  uPSI_HighResTimer,   //*)
  uconvMain,
  uPSI_uconvMain,  // *)
  uPSI_ParserUtils,
  uPSI_uPSUtils,   //3.9.9.160    - add func CalculateDigits
  uPSI_ParserU,
  //uPSI_TypInfo,
  uPSI_ServiceMgr,
  uPSI_UDict,
  uPSI_ubigFloatV3,  //*  cut the dec sign bug)
  uPSI_UBigIntsV4,   //bigpow bigfloat
  uPSI_UP10Build, //3.9.9.180
  U_BigFloatTest, //5.1.6.98   for Tutorial 36 testing
  uPSI_IdModBusServer,
  uPSI_IdModBusClient,
  uPSI_ModbusUtils,
  uPSI_ColorGrd,
  uPSI_DirOutln,
  uPSI_Gauges,
  uPSI_CustomizeDlg, //3.9.9.182
  uPSI_ActnMan,
  uPSI_CollPanl,
  //uPSI_Calendar,     redeclare
 // uPSI_IBCtrls,   //3.9.9.182
  uPSI_IdStackWindows, //*)
  uPSI_CopyPrsr,
  uPSI_CTSVendorUtils,
  uPSI_VendorTestFramework,
  uPSI_JvAnimate,
  uPSI_DBXCharDecoder,
  //uPSI_JvDBLists,
  uPSI_JvFileInfo,
  uPSI_SOAPConn,
  uPSI_SOAPLinked,  //*)
  uPSI_XSBuiltIns, //3.9.9.190
  //uPSI_JvgDigits,    redeclare
  uPSI_JvDesignUtils,
  uPSI_JvgCrossTable,  //*)
  uPSI_JvgReport,
  uPSI_JvDBRichEdit, //3.9.9.190
  uPSI_JvWinHelp,
  uPSI_WaveConverter,
  uPSI_ACMConvertor,    //*)
  uPSI_ComObjOleDB_utils, //3.9.9.191     vardatasize!
  uPSI_SMScript,
  uPSI_CompFileIo,
 (* uPSI_SynHighlighterGeneral,  //3.9.9.192   *)
  uPSI_geometry2,   // *)
  uPSI_MConnect,  //*)
  uPSI_ObjBrkr, //3.9.9.193  *)
  uPSI_uMultiStr,
  //uPSI_JvAVICapture,
  uPSI_JvExceptionForm,
  uPSI_JvConnectNetwork, //3.9.9.194    *)
  MTMainForm,
  uPSI_MTMainForm,
  uPSI_DdeMan,  //*)
  uPSI_DIUtils,   //3.9.9.195
  //uPSI_gnugettext,
  uPSI_Xmlxform,  //*)
 //uPSI_SvrHTTPIndy, //*)
  uPSI_CPortTrmSet, //3.9.9.195
  //XMLDoc3,  to V4
  //////
  ///
   MDIFrame,           //V4 37 adds  mX4
  uPSI_synacrypt,
 uPSI_HTTPProd,
//  uPSI_SockHTTP,
  //uPSI_IndySockTransport,  *)
  uPSI_CppParser,
  uPSI_CodeCompletion, //*)
  uPSI_U_IntList,
 (* uPSI_SockAppNotify,  *)
  //uPSI_NSToIS,
  uPSI_DBOleCtl,  //*)
  //uPSI_xercesxmldom,
  uPSI_xmldom, //*)
  uPSI_JclExprEval, //*)
  uPSI_Gameboard, //*)
  uPSI_ExtPascal,
  uPSI_ExtUtil,
  uPSI_FCGIApp,  //*)
  uPSI_PersistSettings,  //also Windows API Settings  SpectraLib , pipehelper, pipe2,  CompareCLRVersions
  uPSI_SynEditAutoComplete,
  //uPSI_SynEditTextBuffer,
  uPSI_JclPCRE,
  uPSI_JclPCRE2,
  uPSI_GpTimezone,
  //uPSI_ZConnection,
  //uPSI_ZSequence, *)
  chessPrg,
  uPSI_ChessBrd,
  uPSI_ChessPrg,
  uPSI_Graph3D, //*)
  uPSI_SysInfoCtrls,
  uPSI_RegUtils,  //*)
  uPSI_StdFuncs,      // wrong iintit   - missing comp
  uPSI_VariantRtn,
  uPSI_SqlTxtRtns,    //*)
  uPSI_BSpectrum,
 uPSI_IPAddressControl,
  uPSI_Paradox,  //*)
  uPSI_Environ,
  uPSI_GraphicsPrimitivesLibrary,
  uPSI_DrawFigures,
  uPSI_synadbg,   //*)
  uPSI_Streams,
  uPSI_BitStream,   //*)
  uPSI_xrtl_util_FileVersion,
  uPSI_XmlRpcTypes,
  uPSI_XmlRpcCommon,
 (* uPSI_XmlRpcClient,
  uPSI_XmlRpcServer, *)
  //uPSI_SynAutoIndent,  *)
  uPSI_synafpc,
  uPSI_RxNotify,
  uPSI_SynAutoCorrect,
  uPSI_rxOle2Auto, //*)
  uPSI_Spring_Utilsmx,
  uPSI_ulogifit,
  uPSI_HarmFade,
  uPSI_SynCompletionProposal,  //*)
  uPSI_rxAniFile, //*)
  uPSI_ulinfit,     {with usvdfit}
  uPSI_JclStringLists,
  //uPSI_ZLib,       obj error   *)
  uPSI_MaxTokenizers,
  uPSI_MaxStrUtils,
 uPSI_MaxXMLUtils,
  uPSI_MaxUtils,             //64 units add in V4   -Format- Test   type-test
  uPSI_VListBox,
  uPSI_MaxDOM,
  uPSI_MaxDOMDictionary,     //68 units add
  uPSI_cASN1,
  uPSI_cX509Certificate,
  uPSI_uCiaXml,   //*)
  uPSI_StringsW,
  uPSI_FileStreamW,
  uPSI_InetUtilsUnified,      //75 units
  uPSI_FileMask,
  uPSI_StrConv,
  uPSI_Simpat,
  uPSI_Tooltips, //*)
  uPSI_StringGridLibrary,
  uPSI_ChronCheck,
  uPSI_REXX,           //mX5.1.4.90
  uPSI_SysImg,
  uPSI_Tokens,   //*)
  uPSI_KFunctions,   //func pac campbell
  uPSI_KMessageBox,
  uPSI_NamedPipesImpl,
  uPSI_KLog,                //4.2.0.80  plus thread
  uPSI_NamedPipeThreads,
  uPSI_MapFiles,
  uPSI_BKPwdGen,  //*)
  uPSI_Kronos,   //4.2.2.90
  uPSI_TokenLibrary2,
  uPSI_KDialogs,
  uPSI_Numedit,
  uPSI_KGraphics,
  uPSI_umaxPipes,     //4.2.2.90 II
  uPSI_KControls,
  uPSI_IdAntiFreeze,  //4.2.2.95
  uPSI_IdLogStream,
  uPSI_IdThreadSafe,
  //uPSI_IdThreadMgr,    not found
  uPSI_IdAuthentication,
  uPSI_IdAuthenticationManager, //*)
  uPSI_OverbyteIcsConApp, //*)
  //SIRegister_SimpleSFTP
  uPSI_KMemo,             //richview
  //uPSI_kmemofrm,          dfm error
  uPSI_OverbyteIcsTicks64,
  uPSI_OverbyteIcsSha1,     //context input2   *)
  uPSI_KEditCommon,       //*)
 uPSI_UtilsMax4,      //with idbase component - 4.2.2.98 - 4.2.8.10 , inSetword  , unitsused , 4.7.6.10 III
   uPSI_Hashes,           //45810
  uPSI_IdCoderHeader,
  uPSI_uMRU,
  (*uPSI_FannNetwork,  //needs a dll !  *)
  uPSI_RTLDateTimeplus,       //46210   *)
  uPSI_ULog,
  uPSI_UThread,
  //uPSI_UTCPIP,    *)
  uPSI_statmach,           //46310
  uPSI_uTPLb_RSA_Primitives,
  uPSI_UMatrix,
  uPSI_DXUtil,
  uPSI_crlfParser,
  uPSI_DCPbase64,   //*)
  uPSI_FlyFilesUtils,
  //uPSI_PJConsoleApp,    redeclared
  uPSI_PJStreamWrapper,   // templ for free()   *)
  uPSI_LatLonDist,   //*)
  uPSI_cHash,
  uPSI_commDriver,
  uPSI_PXLNetComs,      //FDEF VER185} // Delphi 2007
  uPSI_PXLTiming,   //*)
  uPSI_Odometer,         //4.7.1.10
  uPSI_UIntegerpartition,
  uPSI_API_strings,
  uPSI_API_tools,
  uPSI_API_services,
  uPSI_API_rs232,
  uPSI_API_winprocess,
   uPSI_API_files,         //5.0.2.24
  uPSI_JsonConverter,
  uPSI_GUIUtils,
  uPSI_GUIAutomation,
  uPSI_API_trackbar,

  //SI_idPHPRunner,
  //SI_idCGIRunner,  //*
  //uPSI_cTCPConnection,
  //uPSI_cHTTPTests, *)
  uPSI_cSocksUtils,        // need ctrings
  //uPSI_ZSqlProcessor,
  //uPSI_ZSqlTestForm,
  uPSI_DrBobCGI,             //4.7.1.20    compile test
  uPSI_OverbyteIcsLogger,
  //uPSI_OverbyteIcsNntpCli, *)
  uPSI_OverbyteIcsCharsetUtils,
  uPSI_OverbyteIcsMimeUtils,    //*)
  uPSI_OverbyteIcsUrl,
  uPSI_JclCharsets,           //5.1.6.98 XIX
  //uPSI_uWebSocket,
  uPSI_IdWebSocketSimpleClient,   //5.1.4.98 IX
  uPSI_ExecuteidWebSocket,
  uPSI_ExecuteGLPanel, // ExecuteGLPanel;
  uPSI_KhFunction,
  uPSI_ALOpenOffice,
  //uPSI_ALLibPhoneNumber,    need dll
  uPSI_ALExecute2,
 uPSI_ALIsapiHTTP,         //4.7.1.80
  uPSI_uUsb,
  uPSI_uWebcam,    //(( *)
  uPSI_uTPLb_MemoryStreamPool,   //4.7.1.80 II
  uPSI_uTPLb_Signatory,
  uPSI_uTPLb_Constants,
  uPSI_uTPLb_Random,
  uPSI_EwbCoreTools,
  uPSI_EwbUrl,
  //uPSI_SendMail_For_Ewb, //*)
  uPSI_MaskEdit,
  uPSI_SimpleRSSTypes,
  uPSI_SimpleRSS,           //4.7.2.82
  uPSI_psULib,
  uPSI_rfc1213ip,
  uPSI_rfc1213util,  //*)
  uPSI_JTools,              //4.7.2.82 II *)
  uPSI_neuralbit,
  uPSI_neuralab,  {uPSI_neuralabfun, }// uPSI_neuralvolumev,  //4.7.3.60
  uPSI_neuralcache,
  uPSI_neuralbyteprediction,     //4.7.4.60
  uPSI_neuralplanbuilder,
  uPSI_USearchAnagrams,          //4.7.4.62     *)
  uPSI_JsonsUtilsEx,
   uPSI_Jsons,
   uPSI_Bricks,  //*)
   uPSI_lifeblocks,           //4.7.4.64
   uPSI_AsciiShapes,
   //uPSI_SystemsDiagram,       //4.7.5.20 -----  47520
  //uPSI_qsFoundation,    *)
  //uPSI_Prediction,
  uPSI_cInternetUtils2,
  uPSI_cWindows,
  uPSI_flcSysUtils,            // include exclude  *)
  uPSI_RotImg, //*)
  uPSI_SimpleImageLoader,
  uPSI_HSLUtils,
  uPSI_GraphicsMathLibrary,
  uPSI_umodels,
  uPSI_flcStatistics,
  uPSI_flcMaths,
  uPSI_flcCharSet,
  uPSI_flcBits32,
  uPSI_flcTimers,     //flcTimers.pas   flc
  uPSI_cBlaiseParserLexer,  // *)
  uPSI_flcRational,
  uPSI_flcComplex,
  uPSI_flcVectors,             //TInt64ArrayClass
  uPSI_flcMatrix,
  uPSI_flcStringBuilder,
  //uPSI_flcDynArrays,   //*)
  uPSI_flcASCII,
  uPSI_flcStringPatternMatcher,
  uPSI_flcUnicodeChar, //*)
  uPSI_flcUnicodeCodecs,
  uPSI_flcFloats,            //4.7.5.90
  uPSI_SemaphorGrids,        //4.7.5.80
  uPSI_uXmlDates,
  uPSI_JclTimeZones,
  uPSI_XmlDocRssParser,
  uPSI_RssParser,
  uPSI_SimpleParserRSS,
  uPSI_SimpleRSSUtils, //*)
  uPSI_StrUtil,
  uPSI_Pas2JSUtils,      //++
  uPSI_TAChartUtils,  // *)
   //Python Section
  uPSI_PythonEngine,        //change to 1.12
  uPSI_VclPythonGUIInputOutput,
  uPSI_VarPyth,
  uPSI_cParameters,  //uPSI_cFileTemplates, *)
  uPSI_uCommonFunctions,        //5.02.40
  uPSI_WDCCMisc,
  uPSI_WDCCOleVariantEnum,
  uPSI_WDCCWinInet,  //*)
  uPSI_PythonVersions,
  uPSI_PythonAction,  // *)
  uPSI_SingleList,          //4.7.5.90
  uPSI_AdMeter,  //*)
  uPSI_neuralvolume,    //maxForm1.memo2.lines.Add('
  uPSI_neuralvolumev,   // with CL.Add(TNNetLayerFullConnectReLU) do
  uPSI_DoubleList4,      //CL.AddClassN(CL.FindClass('TOBJECT'),'TNNetLayerFullConnectReLU');
  uPSI_ByteListClass,
  uPSI_CurlHttpCodes,  //*)
  uPSI_NeuralNetworkCAI,
  uPSI_neuralfit,
  uPSI_neuraldatasets,
  uPSI_neuraldatasetsv,
  uPSI_CustApp,              //4.7.5.90 VI
  uPSI_neuralgeneric,        //4.7.6.10
  uPSI_neuralthread,
  uPSI_uSysTools,

  uPSI_uWinNT,
  //4.7.6.10  II
  uPSI_URungeKutta4,
  //uPSI_UrlConIcs,
  uPSI_OverbyteIcsUtils,
  uPSI_SeSHA256,
  uPSI_BlocksUnit, //*)
  uPSI_DelticsCommandLine,
  uPSI_DelticsStrUtils,
  uPSI_DelticsBitField, //*)
  uPSI_DelticsSysUtils,    //4.7.6.10 III
  uPSI_U_Splines,     //4.7.6.10 IV    getpython()   getpython6
  uPSI_U_CoasterB,        //inc coastersounds.res
  uPSI_clJsonSerializerBase,
  uPSI_clJsonParser,   //*)
  uPSI_SynHighlighterPython,
  uPSI_DudsCommonDelphi,
  uPSI_AINNNeuron,  //*)
  uPSI_uHTMLBuilder,
  uPSI_WinApiDownload,
  uPSI_pxQRcode,    //4.7.6.10 VII     *)
  uPSI_DelphiZXingQRCode,
  uPSI_RestJsonUtils,
  uPSI_KLibUtils,           // 4.7.6.10 VIII
  uPSI_KLibWindows,   //*)
  uPSI_AzuliaUtils,           //httpget
  uPSI_HttpConnection,
  uPSI_HttpConnectionWinInet,   //Interface to GUID TEch !
  uPSI_RestUtils,
  uPSI_PSResources,         //4.7.6.20
  uPSI_RestClient,
  uPSI_OpenApiUtils,
  uPSI_Pas2jsFileUtils,
  uPSI_HTTPSender,
  uPSI_NovusFileUtils,
  uPSI_NovusUtilities,
  uPSI_NovusStringUtils,
  uPSI_NovusWindows,
  uPSI_NovusNumUtils,
  // uPSI_NovuscURLUtils,     needs libcurl.dll
  uPSI_NovusWebUtils,
  pacMAIN, pacscores,          //V50460
  uPSI_pacMain,
  uPSI_HttpUtils,             //51498
  uPSI_HttpClasses,           //THttpRequestC = class(TComponent)

  //uPSI_IdNNTPServer,        //4.2.4.25  *)
  uPSI_UWANTUtils,
  uPSI_OverbyteIcsAsn1Utils,
  //uPSI_SimpleSFTP,  //needs 'CL32.DLL';  &&*)
  uPSI_WbemScripting_TLB,  //*-->uPSI_ComObjOleDB_utils;)
  uPSI_wmiserv,
 // uPSI_uJSON,   //*)
  uPSI_RegSvrUtils,
  uPSI_osFileUtil,   //4.2.4.60    *)
  uPSI_SHDocVw,       //twebbrowser   or edge
  uPSI_xutils,
  uPSI_ietf,          //4.2.4.80
  //uPSI_iso3166,*  missing)
  uPSI_dateutil,      //real
  uPSI_dateext4,      //4.2.4.80_2
  uPSI_locale,   //*)
  uPSI_Strings,
   uPSI_crc_checks,  //*)
  uPSI_extdos,        //4.2.4.80_3
  //uPSI_uBild,  //internal errors
  uPSI_SimpleTCP, //*)
  //uPSI_IdFTPList,
  uPSI_uTPLb_RSA_Engine,
  uPSI_uTPLb_CryptographicLibrary,
  uPSI_cHugeInt,          //4.2.5.10
  //uPSI_xBase,
 uPSI_ImageHistogram,
 // uPSI_WDosDrivers,      //  asm 4.2.5.10 IV  *)
  uPSI_cCipherRSA,
  uPSI_CromisStreams,   //4.2.6.10
  uPSI_uTPLb_BinaryUtils,    //*)
  uPSI_UJSONFunctions,
  //UJSONFunctions.pas
  uPSI_USha256,  //*)
  uPSI_Series,    //*)  to tee chart
  uPSI_uTPLb_HashDsc,
  uPSI_uTPLb_Hash,
  uPSI_mimeinln,
  uPSI_UTime, // UTime,  *)
  uPSI_uTPLb_StreamCipher,    //4.2.8.10
  uPSI_uTPLb_BlockCipher,
  uPSI_uTPLb_Asymetric,
  uPSI_uTPLb_CodecIntf,
  uPSI_uTPLb_Codec,
  uPSI_ADOInt,//*)
  uPSI_MidasCon,
  uPSI_XMLIntf,
  //uPSI_XMLDoc, * local unit mismatch)
  uPSI_xrtl_util_ValueImpl,  //*)
  uPSI_ProxyUtils,           //4.2.8.10 II
  uPSI_maxXMLUtils2,      //4.2.8.10 IV   *)
  //pwnative_out;           // for interactive shell cli

 uPSI_St2DBarC,
  uPSI_FmxUtils,
  uPSI_CustomDrawTreeView,
  uPSI_IdLPR,
 // uPSI_SockRequestInterpreter,  //3.9.9.18  *)
  uPSI_ulambert,
  //dbchart,  *)
 uPSI_SimpleDS,
  uPSI_DBXSqlScanner,
  uPSI_DBXMetaDataUtil, // *)
 uPSI_TeEngine,
  uPSI_TeeProcs,
  uPSI_TeCanvas,  //((*)      // check fonts   fixed fonts   bug fix with tmpLines[x-1] do

  uPSI_Chart,
  //uPSI_MDIEdit,  //redeclare
  //uPSI_CopyPrsr, *)
  //uPSI_SockApp,   not found*)
  CoolMain,
  uPSI_CoolMain,
  uPSI_StCRC, //*)
  uPSI_BoldComUtils,
  uPSI_BoldIsoDateTime,
  uPSI_BoldXMLRequests,
  uPSI_BoldStringList,
  uPSI_BoldFileHandler,
  uPSI_BoldThread, //*)
  uPSI_BoldContainers,
  uPSI_BoldQueryUserDlg, //*)
  uPSI_BoldWinINet,
  uPSI_BoldQueue,     //*)
  uPSI_JvPcx,
  uPSI_IdWhois,
 (* uPSI_IdWhoIsServer, *)
  uPSI_IdGopher, //*)
  uPSI_IdDateTimeStamp,
 uPSI_IdDayTimeServer,
  uPSI_IdDayTimeUDP,
  uPSI_IdDayTimeUDPServer,
  uPSI_IdDICTServer,
  uPSI_IdDiscardServer,
  uPSI_IdDiscardUDPServer,// *)
  //uPSI_IdMappedPortTCP_,
  //uPSI_IdMappedFTP,    //3.9.9.50
(*  uPSI_IdGopherServer, *)
  uPSI_IdQotdServer,   //*)
  uPSI_IdFingerServer,
  uPSI_IdDNSResolver,  //incompatible add to iddnscommon*)
  //uPSI_IdUserAccounts, redeclare//*)
  //uPSI_StDecMth,     redeclare
  uPSI_DSUtil,
    teeprocs,
  //series,  //to 2007*)
  uPSI_cPEM,             //3.9.6
  uPSI_xmlutil, //3.2  XML    *)
 uPSI_MaskUtils, //3.5  *)
  uPSI_cutils,  cutils, //GetVersionString
  uPSI_BoldUtils,                   //function CPUID_Supported: Boolean;
 uPSI_IdSimpleServer,
  //uPSI_OpenSSLUtils,   libeay
//  uPSI_IdSSLOpenSSL,     //3.9.4    *)
  uPSI_PerlRegEx,     //3.9.6   getmatchstring
  uPSI_Masks,
  uPSI_Contnrs,
  uPSI_MyBigInt,
  uPSI_SOAPHTTPClient,
  uPSI_VCLScannerIntf,
  uPSI_VCLScannerImpl, //*)
  uPSI_StdConvs,
  uPSI_Midas,                 //V4
  U_go3,                      //GoGame  V5.2
  uPSI_U_Go3,

  uPSI_ConvUtils,
  uPSI_DBClient,   //
  uPSI_CDSUtil,
  uPSI_GraphUtil, //3.7
 uPSI_devcutils,
  uPSI_DBWeb,
  uPSI_DBXpressWeb,
  //uPSI_DBBdeWeb,   *)
  uPSI_ShadowWnd, //3.8   *)
  uPSI_ToolWin,
  //uPSI_Tabs, //redecalre*)
  uPSI_JclGraphUtils,  //not found - fixed
  uPSI_VelthuisFloatUtils,
  uPSI_JclCounter,  //*)
  uPSI_JclSysInfo,
  uPSI_JclSecurity,
  uPSI_IdUserAccounts, //*)
  uPSI_JclFileUtils,   //*)
  uPSI_JvAnalogClock,    //3.9.7
  uPSI_JvAlarms,
// uPSI_JvSQLS,
  //uPSI_JvDBSecur,    bde
  //uPSI_JvDBQBE, *)
  uPSI_JvStarfield,
 // uPSI_JVCLMiscal,
 uPSI_JvProfiler32,
  //uPSI_IdAuthentication,     redeclare
 //uPSI_IdRFCReply,       not found //3.9.75
  uPSI_IdIdentServer,   //*)
  uPSI_IdIdent,   //*)
  //uPSI_StNetCon,     redeclaer
  uPSI_StNet,
  uPSI_StNetPfm,
  uPSI_JvPatchFile,  //*)
 //uPSI_SynMemo,    redeclare
  uPSI_IdASN1Util,
  uPSI_IdHashCRC,
   uPSI_IdHash, //*)
  uPSI_IdHashMessageDigest, //3.5
  //uPSI_IdHash,   //types  redeclare
  uPSI_IdHashSHA1,
  uPSI_IdLogFile,
  uPSI_IdTime,
  uPSI_IdQOTDUDP,
  uPSI_IdQOTDUDPServer,  //*)
  uPSI_IdSysLogMessage,
  uPSI_IdSysLog,
  uPSI_IdSysLogServer,
  uPSI_IdTimeServer,
  uPSI_IdTimeUDP,
  uPSI_IdTimeUDPServer,   //*)
  uPSI_IdDayTime,
  uPSI_IdEMailAddress,   //*)
  uPSI_IdMessage,
  uPSI_IdMessageClient,
  (*uPSI_IdSMTP,
  uPSI_IdPOP3,  *)
  uPSI_IdMailBox,  // *)
  uPSI_IdQotd, //*)
  uPSI_IdTelnet,
  uPSI_IdNetworkCalculator,      //f  *)
  uPSI_IdFinger,
  uPSI_IdIcmpClient,     //*)
  uPSI_IdUDPBase,
  uPSI_IdUDPClient,  //*)
  uPSI_IdTrivialFTPBase,
  uPSI_IdTrivialFTP,   //*)
  uPSI_LinarBitmap,
  uPSI_PNGLoader,       //fix byte reverse order
  // WinForm1,    redeclare
  CRC32, // *)
  gsutils, //3.5
  reversiMain,
 // SynEditMarkupHighAll,  //3.9.8.9 beta   *)
  uHighlighterProcs,
  uPSI_ufft, snakeU,
  GameofLife,
  uPSI_GameOfLife,
  Minesweeper.VclUI.Forms.GameForm,
  uPSI_MinesweeperGame,
 // uPSI_DBXChannel,
  //uPSI_DBXIndyChannel, *)
  VCLScannerIntf,
  SOAPHTTPClient, //Test for WS  *)
  uPSI_interface2_so,     //----------exports for DLL func  *)
  uPSI_IniFiles,    //standard
  uPSI_IdThread,  //*)
  uPSI_fMain,   //Register Methods to Open Tools API and MBVersion!
  ComObj, //OCX internet radio
  uPSI_niSTRING,
  uPSI_niRegularExpression,
  uPSI_niExtendedRegularExpression, //3.1
  uPSI_IdSNTP,  //*)    time server
  JclSysInfo,  //loadedmoduleslist getipaddr, getDNS*)
   IFSI_SysUtils_max, Globfct,        //*)
  uPSI_cFundamentUtils; //, PSResources;


resourcestring
  RCReplace = 'Replace this '#13'of "%s"'#13+'by "%s"?';
  RCSTRMB =' maXbox5 ';
  RCPRINTFONT ='Courier New';
  FILELOAD = ' File loaded';
  FILESAVE = ' File is saved';
  BEFOREFILE = ' last File set history';
  CLIFILELOAD = ' File from Commandline';
  RS_PS='http://pascalprogramming.byethost15.com/lessonindex.html';
  //RS_DS='http://www.delphi3000.com/';
  //RS_DS='http://delphi.about.com/';
  RS_DS='http://www.delphibasics.co.uk/';
  RS_BPM='http://www.blaisepascal.eu/';

  //www.swissdelphicenter.ch/';
  SConfirmDelete = 'Confirm delete';
  SConfirmClear  = 'Confirm clear';
  SDelSelItemsPrompt = 'Delete selected items?';


const
  DefSynEditOptions = [eoAltSetsColumnMode, eoAutoIndent, eoDragDropEditing,
  eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoScrollPastEol, eoSmartTabs,
  eoTabsToSpaces, eoSmartTabDelete];

var
  srec: TSearchRec;
  f: TextFile;
  fx: Text;


procedure Tmaxform1.IFPS3ClassesPlugin1CompImport(Sender: TObject;
  x: TIFPSPascalcompiler);
begin
  SIRegister_Std(x);
  SIRegister_Classes(x, true);
  SIRegister_Types(X);       //3.5+3.6
  SIRegister_Graphics(x, true);     //canvas
  SIRegister_Controls(x);
  SIRegister_stdctrls(x);
  SIRegister_extctrls(x);
  SIRegister_Types(X);       //3.5+3.6
  SIRegister_Menus(X); //from up to 3.9.7 cause of form
  //RIRegister_Controls_Routines(Exec);
  SIRegister_Forms(x);
  //SIRegister_TwinFormp(x);
(*  SIRegister_TMyLabel(x);    *)
  SIRegister_WinForm1(x);
  RegisterDateTimeLibrary_C(x);   // from upsc_dateutils*)
  SIRegister_Types(X);       //3.5
  SIRegister_Graphics(x, true);

  SIRegister_StrUtils(X);
   SIRegister_SysUtils(X);   //3.2   --> sysutils_max also unit down  , TBytes
  SIRegister_Pas2JSUtils(X);         //++
  SIRegister_pacMain(X);
  SIRegister_HttpUtils(X);
  SIRegister_HttpClasses(X);

  SIRegister_EInvalidArgument(x);
  SIRegister_MathMax(x);  //*)
 SIRegister_WideStrUtils(X);
  SIRegister_WideStrings(X);
  SIRegister_StrHlpr(X);    //*)
  //dbtables of bde is out of fashion

  SIRegister_DB(x);          //this shit!
  SIRegister_DBCommonTypes(X);
  SIRegister_DBCommon(X);
  //SIRegister_DBTables(X);

  SIRegister_DBPlatform(X);
  SIRegister_DBLogDlg(X);  //3.9
  SIRegister_DateUtils(X); //3.2
  SIRegister_FileUtils(X);
  SIRegister_SqlTimSt(X);
  SIRegister_gsUtils(X);
  SIRegister_JvFunctions(X);   //*)
  SIRegister_Grids(X);
  SIRegister_Menus(X); //3.1  up  *)
  SIRegister_ComObj(X);      //uPSC_comobj
  SIRegister_Printers(X);
  SIRegister_Dialogs(X); //remove 3.9.6.1   *)

  SIRegister_MPlayer(X);    //*)
  SIRegister_ImgList(X);
  SIRegister_Buttons(X);
  SIRegister_Clipbrd(X);
 (* SIRegister_SqlExpr(X); *)
  SIRegister_ADOInt(X);   //4.2.8.10  *)
  SIRegister_uWebUIMiscFunctions(X);      //51498

  SIRegister_ADODB(X);
  SIRegister_DBGrids(X); //*)
  SIRegister_DBCtrls(X);  //*)
  SIRegister_DBCGrids(X); //3.6
  SIRegister_IniFiles(X);    //remove 3.8.4
  SIRegister_JclBase(X);
  SIRegister_JclMath(X);  // *)
  SIRegister_JvgCommClasses(X);  //*)
  SIRegister_JvgUtils(X);    //with JvGTypes
  SIRegister_JclStatistics(X);
  SIRegister_JclMiscel(X); //*)
  SIRegister_JclLogic(X);
  SIRegister_JvVCLUtils(X);  //3.8   *)
  SIRegister_JvUtils(X);
  SIRegister_JvJCLUtils(X); //3.9   +
  SIRegister_JvAppUtils(X);
(*  SIRegister_JvDBUtil(X);  *)
  SIRegister_JvDBUtils(X);   //*)
  SIRegister_JvParsing(X);        //maxcalc
  SIRegister_JvFormToHtml(X);
  SIRegister_JvCtrlUtils(X); //*)
  SIRegister_JvComponent(X);     // base >to glue to VCL
 (* SIRegister_JvBdeUtils(X);   *)
  SIRegister_JvDateUtil(X);  //*)
  SIRegister_JvGenetic(X);
  SIRegister_JvStrUtil(X);
  SIRegister_JvStrUtils(X);
  SIRegister_JvFileUtil(X);
  SIRegister_JvCalc(X);  //*)
  //SIRegister_JvJCLUtils(X); //3.9
  SIRegister_JvMemoryInfos(X);
  SIRegister_JvComputerInfo(X);  //*)
  SIRegister_Serial(X);
  SIRegister_SerDlgs(X);  //*)
  SIRegister_JvLED(X);
  SIRegister_JvgLogics(X);
  SIRegister_JvTurtle(X);
  SIRegister_JvHtmlParser(X);
  SIRegister_JvgXMLSerializer(X);  //*)
  SIRegister_JvStrings(X);    //*)
  SIRegister_uTPLb_MemoryStreamPool(X);     //4.7.1.80
  SIRegister_uTPLb_Constants(X);
  SIRegister_uTPLb_Random(X);  //*)

  SIRegister_uTPLb_IntegerUtils(X);
  SIRegister_uTPLb_HugeCardinal(X);
  SIRegister_uTPLb_HugeCardinalUtils(X);
  SIRegister_LongIntList(X);
  SIRegister_SortThds(X);
  SIRegister_ThSort(X);
  SIRegister_JvExprParser(X);   //*)
  SIRegister_SynRegExpr(X);
  SIRegister_RegularExpressions(X);
  SIRegister_SynURIOpener(X);           //5.1.6.98
  SIRegister_EdgeMain(X);
  SIRegister_remain(X);      //richedit
  SIRegister_VclGoogleMap(X);

  SIRegister_StUtils(X);  //SysTools4
  SIRegister_IMouse(X); //*)
  SIRegister_SyncObjs(X);
  SIRegister_AsyncCalls(X);
  //SIRegister_ParallelJobs(X);  //*)
  SIRegister_Variants(X);
  SIRegister_OAuth(X);
  SIRegister_VarCmplx(X);
  SIRegister_DTDSchema(X);  //*)
  SIRegister_ShLwApi(X);
  SIRegister_IBUtils(X); //3.9.2.2 fin -3.9.3
  SIRegister_JvGraph(X);   //*)
  SIRegister_Registry(X);
  SIRegister_TlHelp32(X);
  SIRegister_RunElevatedSupport(X);
  SIRegister_SynCrtSock(X);
  SIRegister_JclRegistry(X);
  // SIRegister_TJvGradient(X);      from JVGraph
  SIRegister_JvLogFile(X);   //*)
  SIRegister_JvComCtrls(X);
  SIRegister_JvCtrls(X);   //*)
  SIRegister_CPort(X);
  SIRegister_CPortEsc(X);   //3.9.3
  SIRegister_CPortCtl(X);
  SIRegister_CPortMonitor(X);
  SIRegister_cutils(X);  //3.9.4
  SIRegister_PerlRegEx(X);    //*)
  SIRegister_BoldUtils(X);
  SIRegister_IdSimpleServer(X); // *)
  SIRegister_BarCodeScaner(X);            //  *)
  SIRegister_GUITesting(X);
  SIRegister_JvFindFiles(X);
  SIRegister_JclSimpleXml(X);   //*)
  SIRegister_CheckLst(X);   // *)
  SIRegister_ToolWin(x);     //moved up!!
  SIRegister_Spin(X);        //3.9.9.101   *)

  SIRegister_ComCtrls(X); //3.9 moved up

  SIRegister_StBase(X);     //*)
  SIRegister_ExtPascalUtils(X);
  SIRegister_JvSimpleXml(X);     //domtotree
  SIRegister_JvXmlDatabase(X);   //*)
  SIRegister_StList(X);   //*)
  SIRegister_StFirst(X);
  SIRegister_StMime(X);  //*)
  SIRegister_StToHTML(X);
  SIRegister_StStrms(X);
  SIRegister_StFIN(X);  //&&*)
  SIRegister_StDate(X);
  SIRegister_StDateSt(X);
  SIRegister_StAstroP(X);
  SIRegister_StStat(X);
  SIRegister_StNetCon(X);
  SIRegister_StDecMth(X);
  SIRegister_StOStr(X); // *)
  SIRegister_StPtrns(X);
  SIRegister_StNetMsg(X);
  SIRegister_StMath(X);  //*)
  SIRegister_StExpLog(X);
  SIRegister_StExport(X);
  SIRegister_StGenLog(X);  //*)
  SIRegister_StSystem(X);
 SIRegister_StIniStm(X);
 SIRegister_StBarC(X);
  SIRegister_StDbBarC(X);
  SIRegister_StBarPN(X);
  SIRegister_StDbPNBC(X);
  SIRegister_StDb2DBC(X); // *)
  SIRegister_StMoney(X);
  SIRegister_StMime(X); // *)
  SIRegister_StEclpse(X);
  SIRegister_JvKeyboardStates(X);
  SIRegister_JclMapi(X);
  SIRegister_JvMail(X);
  SIRegister_JclConsole(X);
  SIRegister_JclLANMan(X);
  SIRegister_ActnList(X);  //*  many changes)
  SIRegister_ActnMan(X);  //3.9.9.182       *)
  SIRegister_jpeg(X);
  SIRegister_StRandom(X);
  SIRegister_StDict(X);
  SIRegister_StBCD(X);   ///this shit
  SIRegister_StTxtDat(X);     //*)
  SIRegister_StRegEx(X);
  SIRegister_HexDump(X);
  SIRegister_uTPLb_Codec(X);    //mX 4.7.1.80
  SIRegister_uTPLb_StreamUtils(X);
  SIRegister_uTPLb_StreamCipher(X); // uPSI_uTPLb_StreamCipher,
  SIRegister_uTPLb_BlockCipher(X);
  SIRegister_uTPLb_CodecIntf(X); ///uPSI_uTPLb_CodecIntf.pas
  SIRegister_uTPLb_Asymetric(X); //uPSI_uTPLb_Asymetric,
  SIRegister_uTPLb_Signatory(X);      //check codec

  SIRegister_uTPLb_AES(X);
  SIRegister_uTPLb_SHA2(X);
  SIRegister_AESPassWordDlg(X);
  SIRegister_JclMultimedia(X);   // *)
  SIRegister_TTypeTranslatoR(X);
 SIRegister_IdMessageCoder(X);
  SIRegister_IdMessageCoderMIME(X);
  //SIRegister_IdServerIOHandler(X);
  //SIRegister_IdServerIOHandlerSocket(X);   //change 3.9.9.8
  SIRegister_IdHeaderList(X);
  SIRegister_IdMultipartFormData(X);   //*)
  SIRegister_MathUtils(X);
  SIRegister_HTTPParse(X);
  SIRegister_HTTPUtil(X);   //*)
  SIRegister_utypes(X);  //for dmath.dll   and eval
  SIRegister_FlatSB(X);
  //SIRegister_EIdHTTPProtocolException(x);    *)
  SIRegister_TIdHTTP(x);
 SIRegister_TIdCustomHTTP(x);
 SIRegister_U_MakeCityLocations2(X);
  SIRegister_TIdHTTPProtocol(x);
  SIRegister_TIdHTTPRequest(x);
  SIRegister_TIdHTTPResponse(x);  //}
  SIRegister_IdException(X); //*)
  SIRegister_IdGlobal(X);     //remove 3.9.9.1
 (* SIRegister_IdRFCReply(X);   //3.9.7.5   3)*)
  SIRegister_IdDateTimeStamp(X);  //3.9.9.40
  SIRegister_IdStack(X);  //*V5.0.2.90)
  SIRegister_IdSocks(X);   // *)
  SIRegister_IdComponent(X); //3.9.9.91
  SIRegister_IdIOHandlerThrottle(X);    //*)
  SIRegister_IdIOHandler(X);
  SIRegister_IdSocketHandle(X);
  //SIRegister_IdCustomTCPServer(X);  //V51498 X
  SIRegister_IdIntercept(X);
  SIRegister_IdIOHandlerSocket(X);       //V5.0.2.90
  SIRegister_IdServerIOHandler(X);
  SIRegister_IdServerIOHandlerSocket(X); //7*)
  SIRegister_IdCustomTCPServer(X);  //V51498 X
  SIRegister_IdCoder(X);
  SIRegister_IdRawBase(X);
  //SIRegister_IdNTLM(X);  *)
  SIRegister_IdNNTP(X);
  SIRegister_usniffer(X);
 SIRegister_IdCoder3to4(X);
 (* SIRegister_IdCookie(X); *)
  SIRegister_IdCookieManager(X);
  SIRegister_IdIOHandlerStream(X);  //*)
  SIRegister_IdLogBase(X);     //*)
  SIRegister_TextUtils(X);  //*)
  SIRegister_MandelbrotEngine(X);
  SIRegister_fplotMain(X);   //*)
  SIRegister_uJSON(X);
(*  SIRegister_EncdDecd(X);
  SIRegister_SockAppReg(X);    *)
  SIRegister_Reversi(X);  //*)
  SIRegister_GameOfLife(X);
  SIRegister_MinesweeperGame(X);
  SIRegister_Textures(X);
 SIRegister_MyGrids(X);
  SIRegister_SortGrid(X);
  SIRegister_JvExControls(X);
  //SIRegister_JvBDEMemTable(X);  *)
  SIRegister_yuvconverts(X);
 SIRegister_PsAPI(X);  //*)
  SIRegister_ovcurl(X);
  SIRegister_ovcuser(X);
  SIRegister_ovccolor(X);
 // SIRegister_ovcvlb(X);
  SIRegister_ovctcary(X);
  SIRegister_DXPUtils(X);
  SIRegister_JclSysUtils(X);
 SIRegister_IdTCPConnection(X);  //3.1   idcontext connection*)
  SIRegister_IdTCPClient(X);    //*)
  SIRegister_IdAuthentication(X);  //4.7.1.80
  SIRegister_IdHTTPHeaderInfo(X);    // *)
  SIRegister_IdHTTP(x);  //*)
  SIRegister_HTTPApp(X);
  //SIRegister_TIdURI(x);   *)
  SIRegister_IdURI(x);
  //SIRegister_IdSocketHandle(X);
  SIRegister_IdTCPServer(X);  // bindings*)
  SIRegister_IdFTP(X);
  SIRegister_IdCustomHTTPServer(X); //3.9.3
   (* SIRegister_IdSSLOpenSSL(X);   *)
  SIRegister_xmlutil(X);    //3.2 XML  *)
  SIRegister_MaskUtils(X); //3.5
  SIRegister_Masks(X); //*)
  SIRegister_FileCtrl(X);
  SIRegister_dwsWebUtils(X);

  SIRegister_Outline(X);
  SIRegister_ScktComp(X);
  SIRegister_Calendar(X);  //*)
  SIRegister_VListView(X);
  SIRegister_ide_debugoutput(X);
  //SIRegister_ComCtrls(X); //3.6  move upwards
 SIRegister_VarHlpr(X);    //variants5.  system.internal.varhlpr*)
  SIRegister_StatsClasses(X);   //unit test
  SIRegister_Dialogs(X);
  SIRegister_ExtDlgs(X);
  SIRegister_ValEdit(X);
  SIRegister_interface2_so(X);  //*)
  SIRegister_Contnrs(X);
 SIRegister_MyBigInt(X); //*)
  SIRegister_StdConvs(X);
  SIRegister_ConvUtils(X);
  SIRegister_SOAPHTTPClient(X);  //HTTPRIO
  SIRegister_VCLScannerIntf(X);
  SIRegister_VCLScannerImpl(X);  //*)
  SIRegister_FMTBcd(X);
  SIRegister_Midas(X);
  SIRegister_Provider(X);  //*)
  SIRegister_DBClient(X);  //3.6  *)
  SIRegister_CDSUtil(X);   //*)
  SIRegister_GraphUtil(X);   //3.7
  SIRegister_DBWeb(X);
  SIRegister_DBXpressWeb(X);
  //SIRegister_DBBdeWeb(X);  *)
  SIRegister_ShadowWnd(X); //3.8
  SIRegister_ToolWin(x);
  SIRegister_devcutils(X);
 // SIRegister_Tabs(X);
  SIRegister_JclGraphUtils(X);   //*)
  SIRegister_VelthuisFloatUtils(X);
  SIRegister_JclCounter(X);   //*)
  SIRegister_JclSysInfo(X);      //getCPUInfo open
  SIRegister_JclSecurity(X);
  SIRegister_IdUserAccounts(X);  //*)
  SIRegister_JclFileUtils(X);   //*)
  SIRegister_JvStarfield(X);   //3.9.7    *)
  SIRegister_JvAnalogClock(X);
  SIRegister_JvAlarms(X);
(*  SIRegister_JvSQLS(X);
  SIRegister_JvDBSecur(X);
  SIRegister_JvDBQBE(X);  *)
  SIRegister_JvProfiler32(X);   //*)
  SIRegister_JvDirectories(X);
  SIRegister_JclSvcCtrl(X);        // try to move to 3629 winsvc
  SIRegister_JclSchedule(X);
  SIRegister_JvSoundControl(X);
  //SIRegister_JvBDESQLScript(X);  *)
  SIRegister_IdAuthentication(X);  // *)
  SIRegister_JclNTFS(X);
  SIRegister_JclAppInst(X);     //3     *)
  SIRegister_JclMIDI(X);
  SIRegister_JclWinMidi(X);
  SIRegister_JvRle(X);
  SIRegister_JvRas32(X);
 SIRegister_JvImageWindow(X);
  SIRegister_JvImageDrawThread(X);  //*)//3.9.7.3
  SIRegister_JvTransparentForm(X);  //*)
  SIRegister_JvWinDialogs(X);  //*)
  SIRegister_JclUnitConv_mX2(X);
  SIRegister_JvFloatEdit(X);  //3.9.8   *)
  SIRegister_ShellZipTool(X);
 SIRegister_JvJoystick(X);
  SIRegister_JvMailSlots(X);
  SIRegister_JclComplex(X);  // *)
  SIRegister_SynPdf(X);
  SIRegister_JvAirBrush(X);   //*)
  SIRegister_mORMotReport(X);    //*)
  SIRegister_ugamma(X);
  SIRegister_ExcelExport(X);
  SIRegister_JvDBGridExport(X);
  SIRegister_JvSerialMaker(X);   //*)
  SIRegister_JvWin32(X);
  SIRegister_JvPaintFX(X); //*)
  SIRegister_JvNTEventLog(X);
  SIRegister_JvValidators(X);
  SIRegister_JvDirFrm(X);
  SIRegister_JvParserForm(X);
  SIRegister_JvDualListForm(X);
  SIRegister_JvDualList(X);
  SIRegister_JvSwitch(X);
  SIRegister_JvTimerLst(X);  //*)
  SIRegister_JvObjStr(X);
(*  SIRegister_JvMemTable(X);   *)
  SIRegister_JvPicClip(X);
  SIRegister_JvImagPrvw(X);
  SIRegister_JvFormPatch(X);  //*)
  SIRegister_JvDataConv(X);
  SIRegister_JvCpuUsage(X);
  SIRegister_JvCpuUsage2(X); // *)
  SIRegister_JvJanTreeView(X);
  SIRegister_JvYearGridEditForm(X);    //*)
  SIRegister_JvMarkupCommon(X);
  SIRegister_JvPlaylist(X);
  SIRegister_JvTransLED(X);
  SIRegister_JvFormAutoSize(X); // *)
  SIRegister_JvChart(X);  //*)
  SIRegister_JvXPCore(X);
  SIRegister_JvXPCoreUtils(X);  //*)
  SIRegister_ExtCtrls2(X);
  SIRegister_JvUrlGrabbers(X);
  SIRegister_JvXmlTree(X);
  SIRegister_JvWavePlayer(X);
  SIRegister_JvUnicodeCanvas(X);
  SIRegister_JvTFUtils(X);
  SIRegister_IdMIMETypes(X);
  SIRegister_JvConverter(X);    //JVdataConv  *)
  SIRegister_JvCsvParse(X);   //*)
  SIRegister_JclLocales(X); //*)
  SIRegister_JvSearchFiles(X);
  SIRegister_xrtl_math_Integer(X); //*)
  SIRegister_JvSpeedbar(X);
  SIRegister_JvSpeedbarSetupForm(x);
  SIRegister_lazMasks(X);
  SIRegister_StLArr(X);
  SIRegister_StWmDCpy(X);
  SIRegister_StText(X);
  SIRegister_StNTLog(X);  //*)
  SIRegister_SynEditTypes(X);
  //  syn API int and ext
  SIRegister_SynEditKeyCmds(X);
  SIRegister_SynEditMiscClasses(X);   //*)
  SIRegister_SynEditHighlighter(X);
  SIRegister_SynHighlighterPas(X);
  SIRegister_SynEdit(X);
  SIRegister_SynEditRegexSearch(X);
  SIRegister_SynMacroRecorder(X);  //*)
  SIRegister_SynMemo(X);
 // SIRegister_SynHighlighterAny(X);
  SIRegister_SynEditKbdHandler(X); // *)
  SIRegister_SynEditMiscProcs(X);
  SIRegister_SynEditExport(X);
  SIRegister_SynExportRTF(X);
  SIRegister_SynExportHTML(X);
  SIRegister_SynEditSearch(X);  //3.9.9
  SIRegister_SynHighlighterDfm(X);   //*)
  SIRegister_SynHighlighterHtml(X);
  SIRegister_frmExportMain(X);
  SIRegister_SynDBEdit(X);
  SIRegister_SynEditWildcardSearch(X);  //*)
  SIRegister_JvSticker(X); // *)
  SIRegister_JvZoom(X); //*)
  SIRegister_PMrand(X);
  SIRegister_StAstro(X);  //*)
  SIRegister_StSort(X);
 SIRegister_XmlVerySimple(X);
  SIRegister_StVInfo(X);  //*)
  SIRegister_JvBrowseFolder(X);
  SIRegister_JvBoxProcs(X);   //*)
  SIRegister_usimann(X);
  SIRegister_urandom(X);
 (* SIRegister_uranuvag(X);
  SIRegister_uqsort(X); *)
  SIRegister_ugenalg(X);
  SIRegister_uinterv(X);
  SIRegister_JvHighlighter(X);  //*)
  SIRegister_Diff(X); //*)
  SIRegister_WinAPI(X);
  SIRegister_Services(X);
  SIRegister_SocketsDelphi(X);  //*)
  SIRegister_BlockSocket(X);
  SIRegister_JvForth(X);
  //SIRegister_HttpRESTConnectionIndy(X);
  SIRegister_RestRequest(X);       //((*)
  SIRegister_StBits(X);    //*)
  SIRegister_MultilangTranslator(X);
 SIRegister_HyperLabel(X);
 SIRegister_hhAvALT(X);
  //SIRegister_TomDBQue(X);
  SIRegister_Starter(X);
  SIRegister_FileAssocs(X);
  SIRegister_devFileMonitorX(X); //*)
  SIRegister_devrun(X);
  SIRegister_devExec(X);
  SIRegister_dpipes(X);
  SIRegister_dprocess(X);
  SIRegister_oysUtils(X);
  SIRegister_DosCommand(X);      //3996
 SIRegister_CppTokenizer(X);
  SIRegister_JvHLParser(X); //*)
  SIRegister_JclShell(X);
  SIRegister_JclCOM(X);
  //SIRegister_GR32_Math(X);
  //SIRegister_GR32_LowLevel(X); *)
  SIRegister_UtilsMax4(X);
  SIRegister_MaxUtils(X);

   SIRegister_SimpleHl(X); //*)
  SIRegister_cXMLFunctions(X);  //*)
  SIRegister_JvTimer(X);
  SIRegister_cHTTPUtils(X);
  SIRegister_cTLSUtils(X);
  SIRegister_JclGraphics(X);   // *)
  SIRegister_JclSynch(X);   //*)
  SIRegister_Spring_Cryptography_Utils(X);
  SIRegister_MapReader(X);
  SIRegister_uwinstr(X);
  SIRegister_utexplot(X);
  SIRegister_VarRecUtils(X);
  SIRegister_JvStringHolder(X);  //*)
  SIRegister_JvStringListToHtml(X);  //*)
  SIRegister_Barcode(X);
  SIRegister_ip_misc(X);
  SIRegister_SimpleXML(X);  //*)
  SIRegister_JvAppEvent(X);
  SIRegister_JvAppInst(X);
  SIRegister_JvAppCommand(X);
  SIRegister_JvAnimatedImage(X);
  SIRegister_JvAnimTitle(X);   //*)
  SIRegister_IdASN1Util(X);
  SIRegister_IdHashMessageDigest(X);  //3.5
  SIRegister_IdHash(X);
  SIRegister_IdHashCRC(X);
  //SIRegister_IdHashMessageDigest(X);  //3.5   *)
  SIRegister_IdHashSHA1(X);
  SIRegister_IdLogFile(X);
  SIRegister_IdTime(X);
  SIRegister_IdDayTime(X);
 // SIRegister_IdGlobal(X);  *)
 SIRegister_IdEMailAddress(X);
  SIRegister_IdMessage(X);
  SIRegister_IdMessageClient(X);
(* SIRegister_IdSMTP(X);
  SIRegister_IdPOP3(X);   *)
  SIRegister_IdMailBox(X);  //*)
  SIRegister_IdQotd(X);
  SIRegister_IdTelnet(X);
  SIRegister_IdNetworkCalculator(X);  //*)
  SIRegister_IdFinger(X);
  SIRegister_IdIcmpClient(X);  //*)
  SIRegister_IdUDPBase(X);
  SIRegister_IdUDPClient(X);  //*)
  SIRegister_IdTrivialFTPBase(X);
  SIRegister_IdTrivialFTP(X);    //*)
  SIRegister_IdRemoteCMDClient(X);
  SIRegister_IdRemoteCMDServer(X);
  SIRegister_IdRexec(X); //client & server
  SIRegister_IdUDPServer(X);  //* 502095)
  SIRegister_IdIPWatch(X);
 SIRegister_IdIrcServer(X);   //*)
  SIRegister_IdMessageCollection(X);
  SIRegister_IdDNSResolver(X); //*)
  //SIRegister_IdRFCReply(X);   //3.9.7.5   *)
  SIRegister_IdIdentServer(X);  //*)
  SIRegister_IdIdent(X);    //*)
  SIRegister_IdEcho(X);
  SIRegister_IdEchoServer(X);
  //SIRegister_IdEchoUDP(X);
  SIRegister_IdEchoUDP(X);
  SIRegister_IdEchoUDPServer(X);
  SIRegister_IdTelnetServer(X);    //*)
  SIRegister_IdAntiFreezeBase(X);
 //SIRegister_IdHostnameServer(X);
  SIRegister_IdTunnelCommon(X);
 (* SIRegister_IdTunnelMaster(X);
  SIRegister_IdTunnelSlave(X);  *)
  SIRegister_IdRSH(X);   //*)
   SIRegister_IdRSHServer(X);    //*)
  SIRegister_LibTar(X);
  SIRegister_IdQOTDUDP(X);
  SIRegister_IdQOTDUDPServer(X);
  SIRegister_IdChargenServer(X);    //*)
  SIRegister_IdBlockCipherIntercept(X);
  //SIRegister_IdFTPList(X);                //4.2.5.10   *)
  SIRegister_IdCoderHeader(X);
  (* SIRegister_IdFTPServer(X);  *)
  SIRegister_IdFingerServer(X);    //*)
  SIRegister_StNet(X);
  SIRegister_StNetPfm(X);
 SIRegister_JvPatchFile(X);
 (* SIRegister_JclPrint(X); *)
  SIRegister_JclMime(X);
  SIRegister_JvRichEdit(X);
  SIRegister_JvDBRichEd(X);   //*)
  SIRegister_JvDice(X);  //*)
  SIRegister_cPEM(X);
  //SIRegister_cFundamentUtils(X);   //3.9.6.3 remove   *)
  SIRegister_uwinplot(X);  //*)
  SIRegister_umath(X); //*)
  SIRegister_ufft(X);
 (* SIRegister_GR32_System(X);  *)
  SIRegister_PJFileHandle(X);
  SIRegister_PJEnvVars(X);
  SIRegister_PJPipe(X);
  SIRegister_PJPipeFilters(X);
  SIRegister_PJConsoleApp(X);
  SIRegister_UConsoleAppEx(X);
  SIRegister_UConsoleApp(X);
  SIRegister_DbxDataGenerator(X);
  SIRegister_DbxSocketChannelNative(X);
  SIRegister_DBXClient(X);   //*)
  SIRegister_IdLogEvent(X);
 (* SIRegister_IdSMTPServer(X);    *)
  SIRegister_Geometry(X); //*)
  SIRegister_IB(X);
  SIRegister_IBX(X);
 // SIRegister_IWDBCommon(X);
  SIRegister_IBScript(X);   //*)
  SIRegister_JvCSVBaseControls(X);      //*)
 SIRegister_JvFullColorForm(X);
  SIRegister_JvSegmentedLEDDisplayMapperFrame(X);
  SIRegister_JvShellHook(X);
  SIRegister_Jvg3DColors(X);
  SIRegister_JvSHFileOperation(X);
  SIRegister_uFilexport(X);
  SIRegister_JvDialogs(X);
  SIRegister_JvDBTreeView(X);  //*)
  SIRegister_JvDBUltimGrid(X);
  SIRegister_JvDBQueryParamsForm(X);   //3.9.9.82   plus mX51*)
  SIRegister_JvCommStatus(X);    //*)
  SIRegister_JvgWinMask(X);
  //SIRegister_StStrS(X);
  SIRegister_StMerge(X);
  SIRegister_StTree(X);
  SIRegister_StVArr(X); //*)
  SIRegister_StRegIni(X);   //*)
  SIRegister_usvd(X);  //*)
  SIRegister_DepWalkUtils(X);
  SIRegister_OptionsFrm(X);  //*)
  SIRegister_JvPropAutoSave(X);
  SIRegister_AviCap(X);
  //SIRegister_AclAPI(X);   //*)
  //SIRegister_ALAVLBinaryTree(X); //*)
  //SIRegister_ALStringList(X);
  SIRegister_ALQuickSortList(X); //*)
  SIRegister_ALFcnMisc(X);
  SIRegister_ALStaticText(X);
  SIRegister_ALJSONDoc(X);  //*)
  SIRegister_ALGSMComm(X);  //*)
  SIRegister_ALWindows(X);
 SIRegister_ALMultiPartBaseParser(X);
  SIRegister_ALMultiPartFormDataParser(X);
  SIRegister_ALMultiPartAlternativeParser(X);  //*)
  SIRegister_ALHttpCommon(X);
  SIRegister_ALHttpClient(X);
  SIRegister_ALWebSpider(X);
  //SIRegister_ALHttpClient(X);
  SIRegister_ALFTPClient(X);
  SIRegister_ALInternetMessageCommon(X);
  SIRegister_ALWininetHttpClient(X);
  SIRegister_ALWinInetFTPClient(X);  //*)
  SIRegister_ALWinHttpWrapper(X);
  SIRegister_ALWinHttpClient(X);
  SIRegister_ALFcnWinSock(X);
  SIRegister_ALIsapiHTTP(X);    //4.7.1.80
  SIRegister_ALFcnSQL(X);  //  5.1.4.98 V*)
  SIRegister_ALFcnHTML(X);
  SIRegister_ALFcnCGI(X);  // 5.1.4.98 V**)

  SIRegister_ALFcnExecute(X);
  SIRegister_ALFcnFile(X);
  SIRegister_ALFcnMime(X);
  SIRegister_ALPhpRunner(X);  //*)
  SIRegister_ALGraphic(X);
  SIRegister_ALIniFiles(X);
  SIRegister_ALMemCachedClient(X);  //3.9.9.84   *)
  SIRegister_ALMultiPartMixedParser(X);
 (* SIRegister_ALSMTPClient(X);
  SIRegister_ALNNTPClient(X);   *)
  SIRegister_ALHttpClient2(X);           //V47610 IX
  SIRegister_ALWininetHttpClient2(X);
  SIRegister_ALHintBalloon(X);  //*)
  SIRegister_ALXmlDoc(X);
  SIRegister_IPCThrd(X);
  SIRegister_MonForm(X);
  SIRegister_ovcmisc(X);
  SIRegister_ovcfiler(X);
  SIRegister_ovcstate(X);
  SIRegister_ovccoco(X);
  SIRegister_ovcrvexp(X);
  SIRegister_OvcFormatSettings(X);
  SIRegister_ovcstore(X);
  SIRegister_ovcstr(X);
  SIRegister_ovcmru(X);
  SIRegister_ovccmd(X);
  SIRegister_ovctimer(X);
  SIRegister_ovcintl(X);  //*)
  SIRegister_AfCircularBuffer(X); //*)
  SIRegister_AfUtils(X);
    SIRegister_AfSafeSync(X);
 SIRegister_AfDataDispatcher(X);
 SIRegister_AfDataControls(X);   //*)
  SIRegister_AfComPortCore(X);
  SIRegister_AfComPort(X);
  SIRegister_AfPortControls(X);  //*)
  SIRegister_AfViewers(X);
  SIRegister_AfDataTerminal(X);  //3.9.9.85
  SIRegister_SimplePortMain(X);   //*)
  SIRegister_o32ledlabel(X);
  SIRegister_ovcclock(x);
  SIRegister_o32intlst(x);
  SIRegister_ALFBXLib(X);
  SIRegister_AlMySqlClient(X);
  SIRegister_ALFBXClient(X);
  //SIRegister_ALFcnSQL(X);     redeclare//*)
  SIRegister_AsyncTimer(X);  //*)
  SIRegister_ApplicationFileIO(X);  //*)
  SIRegister_ovcmeter(X);
  SIRegister_ovcpeakm(X);
  SIRegister_ovcBidi(X);     //3.9.9.86
 SIRegister_DXPUtils(X);
(*  SIRegister_ALPOP3Client(X);  *)
  SIRegister_SmallUtils(X);
  SIRegister_MakeApp(X);  //*)
  SIRegister_O32MouseMon(X);
  SIRegister_OvcCache(X);
  SIRegister_ovccalc(X);
 (* SIRegister_Joystick(X);   *)
  SIRegister_ScreenSaver(X);
  SIRegister_Polynomials(X);
  SIRegister_XCollection(X);
  //RIRegister_XCollection_Routines(Exec);  *)
  SIRegister_PersistentClasses(X);
  //SIRegister_DSUtil( X);      //constant value type mismatch
  SIRegister_XOpenGL(X);  //*)
  SIRegister_VectorLists(X);
  SIRegister_MeshUtils(X);   //*)
  SIRegister_JclBorlandTools(X); //3.9.9.86    *)
  SIRegister_JclFileUtils_max(X);
  SIRegister_GLSilhouette(X);  //*)
  SIRegister_changefind(X);
  SIRegister_cmdIntf(X);
  SIRegister_Keyboard(X);
  SIRegister_Octree(X);   //*)
  SIRegister_VRMLParser(X);
  SIRegister_GLFileVRML(X); //*)
  SIRegister_GLCrossPlatform(X);
  SIRegister_GLPolyhedron(X);
  SIRegister_GLParticles(X);   //*)
  SIRegister_GLNavigator(X);
  SIRegister_GLStarRecord(X);  //*)
  SIRegister_GLCanvas(X);  //*)
  SIRegister_GeometryBB(X);
  SIRegister_GeometryCoordinates(X);
  SIRegister_VectorGeometry(X);  //*)
  SIRegister_unitCharsetMap(X);
  SIRegister_JclCharsets(X);
  SIRegister_XnClasses(X);
  SIRegister_TGA(X);
  SIRegister_GLScriptPython(X);      //5.1.4.98 II
  //SIRegister_GLVectorFileObjects(X); //3.9.9.88   *)
  SIRegister_CategoryButtons(X);
  SIRegister_ButtonGroup(X);
 // SIRegister_DbExcept(X);  *)
  SIRegister_StdVCL(X);
  SIRegister_AxCtrls(X);
  SIRegister_gl_actorUnit1(X);  //3.9.9.88    *)
  SIRegister_DataAwareMain(X);
  SIRegister_TabNotBk(X);
  SIRegister_udwsfiler(X);  //*)
  SIRegister_synaip(X);
  SIRegister_synacode(X);
  SIRegister_synachar(X);   //*)
  SIRegister_synamisc(X);
  SIRegister_synaser(X); //*)
  SIRegister_synaicnv(X);
  SIRegister_blcksock(X); //synaclient
  SIRegister_tlntsend(X);
  SIRegister_pingsend(X);  //*)
  SIRegister_asn1util(X);
  SIRegister_dnssend(X);
  SIRegister_ldapsend(X);
  SIRegister_clamsend(X);  //*)
  SIRegister_slogsend(X);  //*)
  SIRegister_mimepart(X);
  SIRegister_mimemess(X);  // *)
  SIRegister_mimeinln(X);  //*)
  SIRegister_ftpsend(X);
  SIRegister_ftptsend(X);    //*)
  SIRegister_httpsend(X);
  SIRegister_sntpsend(X);
  SIRegister_snmpsend(X);
  SIRegister_smtpsend(X);    //3.9.9.91
 SIRegister_imapsend(X);
  SIRegister_pop3send(X);
  SIRegister_nntpsend(X);
 // SIRegister_ssl_openssl(X); //3.9.9.91   *)
  SIRegister_synhttp_daemon(X);
 SIRegister_PingThread(X);
  SIRegister_JvThreadTimer(X);
  SIRegister_NetWork(X);   //*)
  SIRegister_wwSystem(X);
  SIRegister_Themes(X);
  SIRegister_StdStyleActnCtrls(X);
  SIRegister_UDDIHelper(X);
  //SIRegister_IdIMAP4Server(X);
  SIRegister_VariantSymbolTable(X);   //*)
  SIRegister_udf_glob(X);
  SIRegister_TabGrid(X); // *)
  SIRegister_JsDBTreeView(X);
  SIRegister_JsSendMail(X);         //3.9.9.92     *)
  SIRegister_Wwstr(X);
(*  SIRegister_dblookup(X);
  SIRegister_Printgri(X);   *)
  SIRegister_Hotspot(X);
  SIRegister_HList(X);
  SIRegister_TConnect(X);
  SIRegister_DataBkr(X);
 (* SIRegister_DrTable(X);   *)
  SIRegister_HTTPIntr(X);   //3.9.9.94
  SIRegister_Mathbox(X);  //*)
  SIRegister_cyTypes(X);
  SIRegister_cyIndy(X);  //*)
  SIRegister_cySysUtils(X);
  SIRegister_cyWinUtils(X);
  SIRegister_cyStrUtils(X);
  SIRegister_cyDateUtils(X);
  SIRegister_cyObjUtils(X);
 (* SIRegister_cyBDE(X);   *)
  SIRegister_cyClasses(X);
  SIRegister_cyGraphics(X);
 SIRegister_JvDateTimePicker(X);
  SIRegister_JvEasterEgg(X);
  SIRegister_JvCreateProcess(X);    //*)
  SIRegister_JvDatePickerEdit(X);
  SIRegister_WinSvc(X); //*)
  SIRegister_SvcMgr(X);
  SIRegister_WinSvc2(X);
  //SIRegister_JclSvcCtrl(X);   //move from above
  SIRegister_JvPickDate(X);
 SIRegister_JvStrHlder(X);
 (*SIRegister_JvNotify(X);  *)
 SIRegister_JclNTFS2(X);
 SIRegister_Jcl8087(X);
 SIRegister_JvAddPrinter(X);
 SIRegister_JvCabFile(X);   //*)
 SIRegister_JvDataEmbedded(X);
 SIRegister_U_HexView(X);
 SIRegister_UWavein4(X);
 SIRegister_AMixer(X);
 SIRegister_JvArrow(X);
 SIRegister_JvaScrollText(X);      //*)
 SIRegister_UrlMon(X);  //types also in wininet
 SIRegister_U_Oscilloscope4(X); //*)
 SIRegister_DFFUtils(X);
 SIRegister_MathsLib(X);
 SIRegister_UGetParens(X);
 SIRegister_UIntList(X);
 SIRegister_UGeometry(X);
 SIRegister_UAstronomy(X);
 SIRegister_USolarSystem(X);   //*)

 SIRegister_UCardComponentV2(X);
 SIRegister_UTGraphSearch(X);
 SIRegister_UParser10(X);
 SIRegister_cyIEUtils(X);  //*)
 SIRegister_UcomboV2(X);
 SIRegister_cyBaseComm(X);
 SIRegister_cyAppInstances(X);
 SIRegister_cyAttract(X);
 SIRegister_cyDERUtils(X);
SIRegister_cyDocER(X);
 SIRegister_ODBC(X);
 SIRegister_AssocExec(X);
 SIRegister_cyBaseCommRoomConnector(X);
 SIRegister_cyCommRoomConnector(X); //*)
 SIRegister_cyCommunicate(X);
 SIRegister_cyImage(X);
 SIRegister_cyBaseContainer(X);
 SIRegister_cyModalContainer(X);
 SIRegister_cyFlyingContainer(X);   //*)
 SIRegister_RegStr(X);          //just consts
 SIRegister_HtmlHelpViewer(X);  //just intf
 SIRegister_cyIniForm(X);
 SIRegister_cyVirtualGrid(X);
 SIRegister_Profiler(X);
 SIRegister_BackgroundWorker(X);   //*)
 SIRegister_WavePlay(X);
 SIRegister_WaveTimer(X);
 SIRegister_WaveUtils(X);
 SIRegister_NamedPipes(X);
 SIRegister_NamedPipeServer(X);     //*)
 SIRegister_pipes(X); //*)
 SIRegister_process(X);
 SIRegister_DPUtils(X);
 SIRegister_CommonTools(X);
 SIRegister_DataSendToWeb(X);
 SIRegister_StarCalc(X);
 SIRegister_D2_VistaHelperU(X);  // *)
 SIRegister_ProcessUnit(X);
 SIRegister_adgsm(X);
 SIRegister_BetterADODataSet(X);   //*)
 SIRegister_AdSelCom(X);  //*)
 SIRegister_dwsXPlatform(X);
 SIRegister_AdSocket(X);
 SIRegister_AdPacket(X);
  SIRegister_AdPort(X);
  SIRegister_AdPacket(X);
 SIRegister_adgsm(X);
 SIRegister_PathFunc(X);
 SIRegister_CmnFunc2(X);
 SIRegister_CmnFunc(X);
 SIRegister_BitmapImage(X);
 SIRegister_ImageGrabber(X);
 SIRegister_SecurityFunc(X);  //*)
 SIRegister_RedirFunc(X);
 SIRegister_FIFO(X);
 //SIRegister_Int64Em(X);
 SIRegister_InstFunc(X);
 SIRegister_ScriptFunc_R(X);
 SIRegister_LibFusion(X);  //*)
 SIRegister_SimpleExpression(X);
 SIRegister_unitResourceDetails(X);
 SIRegister_unitResFile(X);   //*)
 SIRegister_simplecomport(X);
 SIRegister_Console(X);
 SIRegister_AnalogMeter(X);
 SIRegister_XPrinter(X);  //*)
 SIRegister_lazIniFiles(X);  //*)
 SIRegister_fpcunit(X);
 SIRegister_testdecorator(X); //((*)
 SIRegister_testutils(X);
 SIRegister_ToolsUnit(X);  //*)
 SIRegister_fpcunittests(X);
 SIRegister_cTCPBuffer(X); //*)
 SIRegister_Glut(X);    //*)
 SIRegister_LEDBitmaps(X);
 SIRegister_FileClass(X);
 SIRegister_FileUtilsClass(X);
 SIRegister_ComPortInterface(X);
 SIRegister_SwitchLed(X);
 SIRegister_cyDmmCanvas(X);
 SIRegister_uColorFunctions(X);   //*)
 SIRegister_uSettings(X);
 SIRegister_cyDebug(X);
 SIRegister_cyBaseColorMatrix(X);
 SIRegister_cyColorMatrix(X);
SIRegister_cySearchFiles(X);
 SIRegister_cyCopyFiles(X);
 SIRegister_cyBaseMeasure(X);
(* SIRegister_PJIStreams(X); *)
 SIRegister_cyRunTimeResize(X);
 SIRegister_jcontrolutils(X);
 SIRegister_kcMapViewer(X);
 SIRegister_kcMapViewerGLGeoNames(X);
 SIRegister_kcMapViewerDESynapse(X); //*)
 SIRegister_cparserutils(X);  //*)
 SIRegister_uCommonFunctions(X);
 SIRegister_LedNumber(X);
 SIRegister_StStrL(X);
 SIRegister_indGnouMeter(X);  //*)
 SIRegister_Sensors(X);  //*)
 SIRegister_pwnative_out(X);
 SIRegister_HTMLUtil(X);
 SIRegister_synwrap1(X);
 SIRegister_pwmain(X);
(* SIRegister_W32VersionInfo(X);  *)
 SIRegister_IpAnim(X);  //*)
 SIRegister_IpUtils(X);
 SIRegister_LrtPoTools(X);
 SIRegister_Laz_DOM(X);   //*)
 SIRegister_hhAvComp(X);// *)
 SIRegister_GPS2(X);
 SIRegister_GPS(X);
 //SIRegister_GPSUDemo(X);  *)
 SIRegister_IsNavUtils2(X);    //V5.1.4.80
 SIRegister_NMEA(X);        //3.9.9.101
 SIRegister_ScreenThreeDLab(X);
 SIRegister_DynaZip(X);  //*)
 SIRegister_clockExpert(X);    //*)
 SIRegister_SortUtils(X);  //*)
 //SIRegister_BitmapConversion(X); //down with LinearBitbitmap
  SIRegister_JclTD32(X);  //*)
 SIRegister_ZDbcUtils(X);
 SIRegister_ZScriptParser(X);
 SIRegister_JvFtpGrabber(X);  //*)
 SIRegister_JvIni(X); //*)
 SIRegister_NeuralNetwork(X);
 //SIRegister_neuralnetworkCAI(X);
 SIRegister_U_Go3(X);

 SIRegister_StExpr(X);
 SIRegister_StSaturn(X);
 SIRegister_JclParseUses(X);
 SIRegister_JvFinalize(X);     //3.9.9.120
 SIRegister_panUnit1(X);  //*)
 SIRegister_DD83u1(X);   //*)
 SIRegister_BigIni(X);  //*)
 SIRegister_ShellCtrls(X);
 SIRegister_fmath(X);
 SIRegister_fcomp(X);     //3.9.9.160
 SIRegister_HighResTimer(X);
 SIRegister_uconvMain(X);   //*)
 SIRegister_ParserUtils(X);
 SIRegister_uPSUtils(X);
 SIRegister_ParserU(X);
 //RIRegister_uCommonFunctions_Routines(Exec);
 //SIRegister_TypInfo(X);
 SIRegister_ServiceMgr(X);
 SIRegister_UDict(X);
  SIRegister_UDict2(X);
  SIRegister_ubigFloatV3(X);
  SIRegister_UBigIntsV4(X);
  SIRegister_UP10Build(X);
  SIRegister_IdModBusServer(X); //*)
  SIRegister_IdModBusClient(X);    //3.9.9.180   *)
  SIRegister_ModbusUtils(X);
  SIRegister_ColorGrd(X);
  SIRegister_DirOutln(X);
  SIRegister_Gauges(X);
  SIRegister_CustomizeDlg(X);    //3.9.9.182
  SIRegister_CollPanl(X);
(*  SIRegister_IBCtrls(X);   *)
  SIRegister_IdStackWindows(X);  //*)
  SIRegister_VendorTestFramework(X);
  SIRegister_CTSVendorUtils(X);
  SIRegister_JvAnimate(X);
  SIRegister_DBXCharDecoder(X);
  //SIRegister_JvDBLists(X);  *)
  SIRegister_JvFileInfo(X);
  SIRegister_SOAPConn(X);
  SIRegister_SOAPLinked(X); //*)
  SIRegister_XSBuiltIns(X);  //3.9.9.190   *)
  SIRegister_JvgDigits(X);
  SIRegister_JvDesignUtils(X);
  SIRegister_JvgCrossTable(X);
  SIRegister_JvgReport(X);
  SIRegister_JvDBRichEdit(X); //3.9.9.190
  SIRegister_JvWinHelp(X);
  SIRegister_WaveConverter(X);
  SIRegister_ACMConvertor(X);   //*)
 SIRegister_ComObj2(X);    //3.9.9.191  uPSI_ComObjOleDB_utils! CL.AddTypeS('OleVariant', 'Variant');*)
  SIRegister_SMScript(X);
  SIRegister_CompFileIo(X);
 (* SIRegister_SynHighlighterGeneral(X); //3.9.9.192   *)
  SIRegister_geometry2(X); //*)
  SIRegister_MConnect(X);
  SIRegister_ObjBrkr(X);  //*)
  SIRegister_uMultiStr(X);
 (* SIRegister_JvAVICapture(X);  *)
  SIRegister_JvExceptionForm(X);
  SIRegister_JvConnectNetwork(X); // *)
  SIRegister_MTMainForm(X);
   SIRegister_DdeMan(X);  //*)
  SIRegister_DIUtils(X);  //3.9.9.195
(*  SIRegister_gnugettext(X);    *)
  SIRegister_Xmlxform(X);
  //SIRegister_SvrHTTPIndy(X);   //*)
  SIRegister_CPortTrmSet(X);
  SIRegister_HTTPProd(X);                    //V4   mX4  - 44 units
  SIRegister_TAChartUtils(X);
 //uPSI_SockHTTP.pas
  //SIRegister_SockHTTP(X); //based on webrequest & httpapp
 // SIRegister_IndySockTransport(X);      *)
  SIRegister_synacrypt(X);
  SIRegister_CppParser(X);
  SIRegister_CodeCompletion(X);
  SIRegister_U_IntList2(X);
 (* SIRegister_SockAppNotify(X);  *)
  SIRegister_DBOleCtl(X);
  //SIRegister_NSToIS(X);     no ns-http*.dll
  //SIRegister_xercesxmldom(X);  *)
  SIRegister_xmldom(X);  //*)
  SIRegister_JclExprEval(X);   //*)
  SIRegister_Gameboard(X);   // *)
  SIRegister_ExtPascal(X);
  SIRegister_ExtUtil(X);
 SIRegister_FCGIApp(X);
  SIRegister_PersistSettings(X);
 SIRegister_SynEditAutoComplete(X);
  //SIRegister_SynEditTextBuffer(X);
  SIRegister_JclPCRE(X);
  //RIRegister_JclPCRE_Routines(Exec);  *)
  SIRegister_JclPCRE2(X);
  SIRegister_GpTimezone(X);
  SIRegister_ChessBrd(X);
  SIRegister_ChessPrg(X);
  SIRegister_Graph3D(X);   //*)
  SIRegister_SysInfoCtrls(X);   //*)
  SIRegister_StdFuncs(X);   //this whole shot shit!è
  SIRegister_RegUtils(X);
  SIRegister_VariantRtn(X);
  SIRegister_SqlTxtRtns(X);    //*)
  SIRegister_BSpectrum(X);
  SIRegister_IPAddressControl(X);  //*)
  SIRegister_Paradox(X);
  //RIRegister_Paradox_Routines(Exec);    *)
  SIRegister_Environ(X);
  SIRegister_GraphicsPrimitivesLibrary(X);
  SIRegister_DrawFigures(X);
  SIRegister_synadbg(X);  //*)
  SIRegister_xrtl_util_FileVersion(X);
 SIRegister_Streams(X);                //42610

  SIRegister_BitStream(X);
  SIRegister_XmlRpcTypes(X);
  SIRegister_XmlRpcCommon(X);
 (* SIRegister_XmlRpcClient(X);
  SIRegister_XmlRpcServer(X);     //xmlrpc
  SIRegister_SynAutoIndent(X);    *)
  SIRegister_synafpc(X);
  SIRegister_RxNotify(X);
  SIRegister_SynAutoCorrect(X);
  SIRegister_rxOle2Auto(X);  // *)
  SIRegister_Spring_Utilsmx(X);
  SIRegister_ulogifit(X);
  SIRegister_HarmFade(X);
  SIRegister_SynCompletionProposal(X);
  SIRegister_rxAniFile(X);  //*)
  SIRegister_ulinfit(X);
  SIRegister_JclStringLists(x);
  //SIRegister_ZLib(X);
  //RIRegister_ZLib_Routines(Exec);    *)
  SIRegister_MaxTokenizers(X);
  SIRegister_MaxDOM(X);
  //SIRegister_MaxUtils(X);      //----->upper to type test--
  SIRegister_MaxStrUtils(X);   //this shit
  SIRegister_MaxXMLUtils(X);
  SIRegister_VListBox(X);           //canvas +
  SIRegister_MaxDOMDictionary(X);
  //uPSI_MaxDOM,
  //uPSI_MaxDOMDictionary,     //68 units add
  //*)
  SIRegister_cASN1(X);
  //RIRegister_cASN1_Routines(Exec);
  //RIRegister_cX509Certificate_Routines(Exec);
  SIRegister_cX509Certificate(X);
  SIRegister_uCiaXml(X);      // *)
  SIRegister_StringsW(X);
  SIRegister_FileStreamW(X);
  SIRegister_StringsW(X);
  SIRegister_InetUtils(X);
  SIRegister_FileMask(X);
  SIRegister_StrConv(X);
  SIRegister_Simpat(X);
  SIRegister_Tooltips(X);  //*)
  SIRegister_StringGridLibrary(X);    //mX 4.2.0
  SIRegister_ChronCheck(X);
  SIRegister_REXX(X);
  SIRegister_SysImg(X);
  SIRegister_Tokens(X); //*)
  SIRegister_KFunctions(X);
  SIRegister_KMessageBox(X);
  SIRegister_NamedPipesImpl(X);
  SIRegister_KLog(X);               //4.2.0.80
  SIRegister_NamedPipeThreads(X);
  SIRegister_MapFiles(X);
  SIRegister_BKPwdGen(X);  //*)
  SIRegister_Kronos(X);
  SIRegister_TokenLibrary2(X);
  SIRegister_KEditCommon(X);  //add
  SIRegister_KControls(X);  //Base Class
  SIRegister_KDialogs(X);
  SIRegister_NumEdit(X);
  SIRegister_KGraphics(X);
 SIRegister_umaxPipes(X);
  SIRegister_IdAntiFreeze(X);
  SIRegister_IdLogStream(X);
  SIRegister_IdThreadSafe(X);
  //SIRegister_IdThreadMgr(X);
  SIRegister_IdAuthenticationManager(X);  //*)
  SIRegister_OverbyteIcsConApp(X);  //*)
  SIRegister_KMemo(X);
  //SIRegister_kmemofrm(X);
  SIRegister_OverbyteIcsTicks64(X);
  SIRegister_OverbyteIcsSha1(X);
 (* SIRegister_IdNNTPServer(X); *)
  SIRegister_UWANTUtils(X);
  SIRegister_OverbyteIcsAsn1Utils(X); /// *)
  //SIRegister_SimpleSFTP(X);
  SIRegister_WbemScripting_TLB(X); //*)
  SIRegister_wmiserv(X);
  SIRegister_uJSON(X);
  SIRegister_RegSvrUtils(X);    //4.2.4.60
  SIRegister_osFileUtil(X);
  SIRegister_SHDocVw(X);       //4.2.4.60_2
  SIRegister_ietf(X);   //*)
  SIRegister_xutils(X);          //4.2.4.80   *)
  SIRegister_dateutil(X);
  SIRegister_dateext4(X);
  SIRegister_locale(X);  //*)
  SIRegister_Strings(X);
   SIRegister_crc(X);   //*)
  SIRegister_extdos(X);
 (* SIRegister_uBild(X);  *)
  SIRegister_SimpleTCP(X);
  //SIRegister_IdFTPList(X);   *)
  SIRegister_uTPLb_RSA_Engine(X);
  SIRegister_uTPLb_CryptographicLibrary(X);
  SIRegister_THugeInt(X);
  SIRegister_cHugeInt(X);
  // of version 4.2.5.10
(* SIRegister_xBase(X);   *)
  SIRegister_ImageHistogram(X);
  (*SIRegister_WDosDrivers(X);  *)
  SIRegister_cCipherRSA(X);
  SIRegister_CromisStreams(X);
  SIRegister_uTPLb_BinaryUtils(X); //*)
  SIRegister_USha256(X);     //*)
  SIRegister_UJSONFunctions(X);
  SIRegister_uTPLb_HashDsc(X);
 SIRegister_uTPLb_Hash(X);
  SIRegister_UTime(X);
  SIRegister_uTPLb_Codec(X);   //4.2.8.10     move up
  SIRegister_uTPLb_Signatory(X);      //check codec
  SIRegister_EwbCoreTools(X);
  //SIRegister_SendMail_For_Ewb(X);
   SIRegister_EwbUrl(X);    //*)
  SIRegister_MaskEdit(X);
  SIRegister_SimpleRSSTypes(X);
  SIRegister_SimpleRSS(X);          //4.7.2.80    dep to indy
  SIRegister_psULib(X);
  SIRegister_psUFinancial(X);
  SIRegister_rfc1213ip(X);
  SIRegister_rfc1213util(X);    //*)
  SIRegister_JTools(X);  //*)
  //SIRegister_neuralbit(X);
  SIRegister_neuralab(X);
  SIRegister_neuralcache(X);
  SIRegister_neuralbyteprediction(X);
  SIRegister_USearchAnagrams(X);
  SIRegister_HashUnit(X);          //4.7.4.62   *)
  SIRegister_JsonsUtilsEx(X);
  SIRegister_Jsons(X);
  SIRegister_Bricks(X);
  SIRegister_lifeblocks(X);       //4.7.4.64       *)
  SIRegister_AsciiShapes(X);
  SIRegister_cInternetUtils(X);    //4.7.5.20 -----  47520
  SIRegister_cWindows(X);
  SIRegister_flcSysUtils(X);      //*)
  SIRegister_SimpleImageLoader(X);
  SIRegister_RotImg(X);
  SIRegister_HSLUtils(X);
  SIRegister_GraphicsMathLibrary(X);
 SIRegister_flcStatistics(X);
  SIRegister_flcMaths(X);
  //SIRegister_flcCharSet(X); //---> behind cfundamentutils cause charset
  //SIRegister_flcBits32(X);   ---> behind cause word32
  //SIRegister_flcTimers(X);  ---> behind cfundamentutils cause word64
  SIRegister_cBlaiseParserLexer(X);    //*)
  SIRegister_flcRational(X);
  SIRegister_flcComplex(X);
  SIRegister_flcVectors(X);
  SIRegister_flcMatrix(X);
  SIRegister_flcStringBuilder(X); //*)
  SIRegister_flcASCII(X);
  SIRegister_flcStringPatternMatcher(X);
  SIRegister_flcUnicodeChar(X);
  SIRegister_flcUnicodeCodecs(X);   //5.0.2.70
  SIRegister_SemaphorGrids(X);     //4-7-5-80
  SIRegister_uXmlDates(X);
  SIRegister_JclTimeZones(X);
  SIRegister_XmlDocRssParser(X);
  SIRegister_RssModel(X);
  SIRegister_RssParser(X);
  SIRegister_SimpleParserRSS(X);
  SIRegister_SimpleRSSUtils(X);    //*)
  SIRegister_StrUtil(X);   //*)
 // SIRegister_Pas2JSUtils(X);   //++
  SIRegister_PythonEngine(X);
  SIRegister_VclPythonGUIInputOutput(X);
  SIRegister_VarPyth(X);
  SIRegister_cParameters(X);
  SIRegister_WDCCMisc(X);
  SIRegister_WDCCWinInet(X);
  SIRegister_WDCCOleVariantEnum(X);
  SIRegister_PythonVersions(X);
  SIRegister_PythonAction(X); //*)
  SIRegister_SingleListClass(X);
  SIRegister_AdMeter(X);
  SIRegister_neuralplanbuilder(X);
  SIRegister_neuralvolume(X);
  SIRegister_neuralvolumev(X);
  SIRegister_DoubleList4(X);    //47590
  SIRegister_ByteListClass(X);
  //SIRegister_flcVectors(X);
  SIRegister_CurlHttpCodes(X);
  SIRegister_NeuralNetwork(X);
  SIRegister_neuralnetworkCAI(X);
  SIRegister_neuralfit(X);
  SIRegister_neuraldatasets(X);
  SIRegister_neuraldatasetsv(X);    //47590 III

  SIRegister_flcFloats(X);          //47590 V
  //*)
  SIRegister_CustApp(X);
  ///uPSI_neuralgeneric,        //4.7.6.10
  SIRegister_neuralgeneric(X);
  //uPSI_neuralthread,
  SIRegister_neuralthread(X);
  SIRegister_uSysTools(X);
 SIRegister_uWinNT(X);
  SIRegister_URungeKutta4(X);
 SIRegister_OverbyteIcsUtils(X);
  SIRegister_SeSHA256(X);
  SIRegister_BlocksUnit(X); //*)
  SIRegister_DelticsCommandLine(X);
  SIRegister_DelticsStrUtils(X);
  SIRegister_DelticsBitField(X);    //*)
  SIRegister_DelticsSysUtils(X);    //4.7.6.10 III
  SIRegister_U_Splines(X);
  SIRegister_U_CoasterB(X);
  SIRegister_clJsonParser(X);    //*)
  SIRegister_clJsonSerializerBase(X);
  SIRegister_SynHighlighterPython(X);  //4.7.6.10 V
  SIRegister_DudsCommonDelphi(X);
  SIRegister_AINNNeuron(X);    //*)
  SIRegister_uHTMLBuilder(X);
  SIRegister_WinApiDownload(X);
  //uPSI_pxQRcode.pas                 //4.7.6.10 VII
  SIRegister_pxQRcode(X);  //*)
  SIRegister_DelphiZXingQRCode(X);
 SIRegister_RestJsonUtils(X);  //*)
  SIRegister_KLibUtils(X);
  SIRegister_KLibWindows(X);
  SIRegister_AzuliaUtils(X);   //*)
  SIRegister_RestUtils(X);
 SIRegister_PSResources(X);           //4.7.6.20
  //PSResources;
  SIRegister_HttpConnection(X);
  SIRegister_HttpConnectionWinInet(X);
  SIRegister_RestClient(X);
  SIRegister_Pas2jsFileUtils(X);
  SIRegister_OpenApiUtils(X);
  SIRegister_HTTPSender(X);
  SIRegister_NovusUtilities(X);
  SIRegister_NovusStringUtils(X);
  SIRegister_NovusWindows(X);
  SIRegister_NovusNumUtils(X);
  SIRegister_NovusWebUtils(X);

  SIRegister_XMLIntf(X);
  //SIRegister_XMLDoc(X);  *)
  SIRegister_MidasCon(X); //*)
  //SIRegister_xrtl_util_ValueImpl(X);  //*)
  SIRegister_ProxyUtils(X);
  SIRegister_OmniXMLUtils(X);
  SIRegister_Hashes(X);         //45810
  SIRegister_uMRU(X);
 (* SIRegister_FannNetwork(X);   *)
  SIRegister_RTLDateTimeplus(X);
 SIRegister_UThread(X);  //*)
   SIRegister_ULog(X);
 (* SIRegister_UTCPIP(X);   *)
  SIRegister_statmach(X);     //46310  *)
  //SIRegister_uTPLb_RSA_Primitives_Routines(X);
  SIRegister_uTPLb_RSA_Primitives(X);
  SIRegister_UMatrix(X);
  SIRegister_DXUtil(X);
  SIRegister_crlfParser(X);
  SIRegister_DCPbase64(X);   //*)
  SIRegister_FlyFilesUtils(X);
  SIRegister_PJConsoleApp(X);
  SIRegister_PJStreamWrapper(X);   //*)
  SIRegister_LatLonDist(X);
  SIRegister_cHash(X);
 SIRegister_commDriver(X);
  SIRegister_PXLNetComs(X);
  SIRegister_PXLTiming(X);
  SIRegister_Odometer(X);        //47110
  SIRegister_UIntList(X);
  SIRegister_UIntegerpartition(X);
  SIRegister_API_strings(X);
  SIRegister_API_services(x);
  SIRegister_API_tools(X);
  SIRegister_API_rs232(X);
  SIRegister_API_winprocess(X);
  SIRegister_API_files(X);      //5.0.2.24
  SIRegister_JsonConverter(X);
  SIRegister_GUIUtils(X);
  SIRegister_GUIAutomation(X);  //5.0.2.28
  SIRegister_API_trackbar(X);

  // SIRegister_idCGIRunner(X);
  //IRegister_idPHPRunner(X);
 // SIRegister_DrBobCGI(X);   *)
  SIRegister_OverbyteIcsLogger(X);  //*)
  SIRegister_OverbyteIcsCharsetUtils(X);
  SIRegister_OverbyteIcsMimeUtils(X);   //*)
  SIRegister_OverbyteIcsUrl(X);
 // SIRegister_uWebSocket(X);
 SIRegister_IdWebSocketSimpleClient(X);
 SIRegister_ExecuteidWebSocket(X);
 SIRegister_WebString(X);
 SIRegister_McJSON(X);
 SIRegister_ExecuteGLPanel(X);
  SIRegister_cSocksUtils(X);
  SIRegister_KhFunction(X);
  SIRegister_ALOpenOffice(X);
  //SIRegister_ALLibPhoneNumber(X);
  SIRegister_ALExecute2(X);
  SIRegister_uUsb(X);
  SIRegister_uWebcam(X);

  //  SIRegister_dbTvRecordList(X);    *)
    SIRegister_TreeVwEx(X);
 (*   SIRegister_ECDataLink(X);
    SIRegister_dbTree(X);
    SIRegister_dbTreeCBox(X);  *)
    SIRegister_Debug(X);
 (* SIRegister_FileIntf(X);
  SIRegister_SockTransport(X);  *)
  SIRegister_WinInet(X);
  SIRegister_JvSimLogic(X);      //3.9.7.4
  SIRegister_JvSimIndicator(X);
  SIRegister_JvSimPID(X);
  SIRegister_JvSimPIDLinker(X);
  SIRegister_JclPeImage(X);
  SIRegister_xrtl_util_CPUUtils(X);   //*)
  SIRegister_CompilersURunner(X);
  SIRegister_xrtl_net_URI(X);
  SIRegister_xrtl_net_URIUtils(X);
  SIRegister_xrtl_util_StrUtils(X);
  SIRegister_xrtl_util_COMCat(X);
  SIRegister_xrtl_util_VariantUtils(X);
  SIRegister_xrtl_util_FileUtils(X);
   SIRegister_xrtl_util_Compat(X);
  SIRegister_OleAuto(X);            //OlESysError
  SIRegister_xrtl_util_COMUtils(X);
  SIRegister_CmAdmCtl(X);
 (* SIRegister_GR32(X);
  SIRegister_GR32_Image(X);
  SIRegister_GR32_Rasterizers(X);
  SIRegister_GR32_ExtImage(X);
  SIRegister_GR32_OrdinalMaps(X);
  SIRegister_GR32_LowLevel(X);
  SIRegister_GR32_Filters(X);
  SIRegister_GR32_VectorMaps(X);
  SIRegister_GR32_Geometry(X);
  SIRegister_GR32_Containers(X);
  SIRegister_GR32_Backends_VCL(X); *)

  SIRegister_LazFileUtils(X);
  SIRegister_FileUtil(X);
  SIRegister_IDECmdLine(X);
  SIRegister_JclMiscel2(X);
  SIRegister_JclIniFiles(X);
 (*  {$IFDEF CD2XXUNIT}
     SIRegister_D2XXUnit(X);
  {$ENDIF}
  //SIRegister_D2XXUnit(X);   *)
  SIRegister_JclStreams(X);
  SIRegister_JclTask(X);
  SIRegister_JclDateTime(X);
  SIRegister_JclEDI(X);   //*)
  SIRegister_JclAnsiStrings(X);    //3.9.9.14
  SIRegister_synautil(X);
  SIRegister_SRMgr(X);   //*)
  SIRegister_DebugBox(X);   // *)
  SIRegister_HotLog(X);

  SIRegister_ustrings(X);
  SIRegister_uregtest(X);
  SIRegister_usimplex(X);
  SIRegister_uhyper(X);
  SIRegister_unlfit(X);
(*  SIRegister_IdHL7(X);   *)
  //uPSI_IdIPMCastBase;
  SIRegister_IdIPMCastBase(X);
   SIRegister_IdIPMCastServer(X);
  SIRegister_IdIPMCastClient(X); // *)
  SIRegister_IdRawHeaders(X);
  SIRegister_IdRawClient(X);
  SIRegister_IdRawFunctions(X);
  SIRegister_IdTCPStream(X);
  SIRegister_IdSNPP(X);   //*)
  SIRegister_St2DBarC(X);
  SIRegister_ImageWin(X);
  SIRegister_FmxUtils(X);
  SIRegister_CustomDrawTreeView(X);
  SIRegister_GraphWin(X);
  SIRegister_StSpawn(X);  //*)
  SIRegister_actionMain(X);
  SIRegister_CtlPanel(X);
  SIRegister_IdLPR(X);
 (* SIRegister_SockRequestInterpreter(X);  out *)
  SIRegister_ulambert(X);
  SIRegister_SimpleDS(X);
 SIRegister_DBXSqlScanner(X);
  SIRegister_DBXMetaDataUtil(X);    //*)
  SIRegister_TeeProcs(X);
  SIRegister_TeCanvas(X);    //TEcanvas
  //SIRegister_TeeProcs(X);
  SIRegister_TeEngine(X);   //*)
  SIRegister_Chart(X);     //3.9.9.20!
  SIRegister_Series(X);  //4.2.6.10     *)
    //TEEChart 64b
  SIRegister_CopyPrsr(X);
 (* SIRegister_SockApp(X);   *)
  SIRegister_MDIEdit(X);
 SIRegister_ExtActns(X);
  SIRegister_AppEvnts(X);
 SIRegister_CoolMain(X);
  SIRegister_StCRC(X);
  SIRegister_BoldContainers(X);
  SIRegister_BoldComUtils(X);
  SIRegister_BoldIsoDateTime(X);
  SIRegister_BoldXMLRequests(X);
 SIRegister_BoldStringList(X);
  SIRegister_BoldFileHandler(X);
  SIRegister_BoldThread(X); //*)
  SIRegister_BoldWinINet(X);
  SIRegister_BoldQueryUserDlg(X);
  SIRegister_BoldQueue(X); //*)
  SIRegister_JvPcx(X);
  SIRegister_IdWhois(X);
 (* SIRegister_IdWhoIsServer(X);   *)
  SIRegister_IdGopher(X);
  SIRegister_IdDiscardServer(X);
  SIRegister_IdDiscardUDPServer(X); // *)
  SIRegister_IdDICTServer(X);  //*)
  SIRegister_IdDayTimeUDPServer(X);
  SIRegister_IdDayTimeServer(X);  //*)
  SIRegister_IdDayTimeUDP(X);  //3.9.9.50   *)
  //SIRegister_IdMappedPortTCP(X);
  //SIRegister_IdMappedFTP(X);
  SIRegister_IdMappedPortUDP(X);
  SIRegister_IdQotdServer(X);
 (* SIRegister_IdGopherServer(X);     *)
  SIRegister_JvRgbToHtml(X);
  SIRegister_JvSysComp(X);
  SIRegister_JvRemLog(X);
  SIRegister_JvTMTL(X);
  SIRegister_JvWinampApi(X);    // *)
  SIRegister_MSysUtils(X);
  SIRegister_ESBMaths(X);
  SIRegister_ESBMaths2(X);   //*)
  SIRegister_uLkJSON(X);
  SIRegister_ZSysUtils(X);
  SIRegister_ZURL(X);
  SIRegister_ZClasses(X);
  SIRegister_ZMatchPattern(X);
  SIRegister_ZCollections(X);
  SIRegister_ZEncoding(X);
  SIRegister_IdCoderMIME(X);
  SIRegister_IdCoderUUE(X);
  SIRegister_IdCoderXXE(X);   //*)
  SIRegister_WDosSocketUtils(X);
  SIRegister_WDosPlcUtils(X);
  SIRegister_WDosPorts(X);
  SIRegister_WDosResolvers(X);
  SIRegister_WDosTimers(X);
  SIRegister_WDosPlcs(X);
  SIRegister_WDosPneumatics(X);
  SIRegister_IdHTTPWebBrokerBridge(X);  // *)
  SIRegister_IdSysLogMessage(X);
  SIRegister_IdSysLog(X);
  SIRegister_IdSysLogServer(X);
  SIRegister_IdTimeServer(X);
  SIRegister_IdTimeUDPServer(X);  //*)
  SIRegister_IdTimeUDP(X);
  SIRegister_IdUserAccounts(X); //*)
  SIRegister_JclStrHashMap(X); //*)
  SIRegister_delphi_arduino_Unit1(X);
  SIRegister_PppState(X); //*)
  SIRegister_FindFileIter(X);
 SIRegister_PppParser(X);
  SIRegister_PppLexer(X);     // *)
  SIRegister_PCharUtils(X);
  SIRegister_JclHookExcept(X);
  //SIRegister_StStrS(X);    //ansi char   shortstring
   SIRegister_EncdDecd(X);
  //SIRegister_SockAppReg(X);   nort found*)
   SIRegister_xrtl_util_TimeStamp(X);
  SIRegister_xrtl_util_TimeUtils(X);
  SIRegister_xrtl_util_TimeZone(X);
  SIRegister_xrtl_util_Map(X);
  SIRegister_xrtl_util_Set(X);  //3.9.6.4 *)
  SIRegister_xrtl_util_Compare(X);
  SIRegister_xrtl_util_Value(X);
  SIRegister_xrtl_util_Exception(X);
  SIRegister_cFileUtils(X);
  SIRegister_cDateTime(X);   //*)
  SIRegister_cTimers(X);
  SIRegister_cRandom(X);
  SIRegister_ueval(X);
 (* SIRegister_DBXChannel(X);
  SIRegister_DBXIndyChannel(X);   *)
  SIRegister_LinarBitmap(X);
  SIRegister_PNGLoader(X);
  SIRegister_BitmapConversion(X); //*)
  SIRegister_IniFiles(X);
 SIRegister_IdThread(X);  //*)
  SIRegister_fMain(X);       //reflection
 SIRegister_niSTRING(X);
  SIRegister_niRegularExpression(X);
  SIRegister_niExtendedRegularExpression(X);
  SIRegister_IdSNTP(X);
  //SIRegister_SysUtils(X);         //maybe bug      *)
  SIRegister_cFundamentUtils(X);   //3.9.6.3   *)
  SIRegister_ShellAPI(X);

  SIRegister_flcCharSet(X);
  SIRegister_flcBits32(X);
  SIRegister_flcTimers(X);     //*)


end;

procedure Tmaxform1.IFPS3ClassesPlugin1ExecImport(Sender: TObject; Exec: TIFPSExec;
  x: TIFPSRuntimeClassImporter);
begin
  //procedure RIRegister_ExtCtrls(cl: TPSRuntimeClassImporter);
  RIRegister_Std(x);
  RIRegister_Classes(x, True);
  RIRegister_Graphics(x, True);
  RIRegister_Graphics_Routines(Exec); //3.6     add
  RIRegister_Controls(x);
  RIRegister_stdctrls(x);
  RIRegister_extctrls(x);
  RIRegister_Controls_Routines(Exec);
  RIRegister_Forms(x);
  RIRegister_Grids(x);
  RIRegister_Menus(X);
  RIRegister_Menus_Routines(Exec);
  RIRegister_Buttons(X);
  RIRegister_Buttons_Routines(Exec);    // add
  (*RIRegister_TwinFormp(x);
  RIRegister_TMyLabel(x);
  RIRegister_WinForm1(x);  *)
  RegisterDateTimeLibrary_R(exec); //*)
  RIRegister_EInvalidArgument(x);
  RIRegister_MathMax_Routines(exec);
  RIRegister_WideStrUtils_Routines(Exec);
  RIRegister_WideStrings(X);  //3.2    *)
  RIRegister_Types_Routines(Exec);  //3.5
  RIRegister_StrHlpr_Routines(Exec);   //*)
  RIRegister_DBCommon_Routines(Exec);
  RIRegister_DBCommon(X);
    RIRegister_DB(x);
  RIRegister_DB_Routines(Exec);
 (* RIRegister_DBTables_Routines(Exec);  *)
  //RIRegister_DBTables(X);
  RIRegister_DBPlatform(X);
  RIRegister_DBLogDlg(X);
  RIRegister_DBLogDlg_Routines(Exec);  //*)
  RIRegister_SqlTimSt_Routines(Exec);   //*)
  RIRegister_Printers(X);
  RIRegister_Printers_Routines(Exec); //*)
  RIRegister_StrUtils_Routines(exec);
  RIRegister_Pas2JSUtils_Routines(Exec);    //++
  RIRegister_pacMain(X);
  RIRegister_HttpUtils_Routines(Exec);
  RIRegister_HttpClasses(X);
  RIRegister_HttpClasses_Routines(Exec);   //5.1.4.98

  RIRegister_MPlayer(X);
  RIRegister_ImgList(X);
  RIRegister_ComObj(Exec);  //*)
 RIRegister_Clipbrd(X);
  RIRegister_Clipbrd_Routines(Exec);
 (* RIRegister_SqlExpr(X); //3.2
  RIRegister_SqlExpr_Routines(Exec); *)
  RIRegister_ADODB(X);
  RIRegister_ADODB_Routines(Exec);
  RIRegister_DBGrids(X);  //*)
  RIRegister_DBCtrls(X);  //
  RIRegister_DBCtrls_Routines(Exec);
  RIRegister_DBCGrids(X);
  RIRegister_DateUtils_Routines(Exec);
  RIRegister_FileUtils_Routines(Exec);
  RIRegister_gsUtils_Routines(Exec);
 RIRegister_JvFunctions_Routines(Exec);   //*)
  RIRegister_JclBase(X);
 RIRegister_JvgCommClasses(X);
  RIRegister_JvgUtils(X);
  RIRegister_JvgUtils_Routines(Exec);  //*)
  RIRegister_JclBase_Routines(Exec);
  RIRegister_JclStatistics_Routines(Exec);
  RIRegister_JclMiscel_Routines(Exec);  // *)
  RIRegister_JclLogic_Routines(Exec);
 RIRegister_JvVCLUtils(X);   //3.8.2
  RIRegister_JvVCLUtils_Routines(Exec);  //   user.dll*)
  RIRegister_JvUtils_Routines(Exec);
  RIRegister_JvJCLUtils(X);           //+
  RIRegister_JvJCLUtils_Routines(Exec);
  RIRegister_JvAppUtils_Routines(Exec);
 (* RIRegister_JvDBUtil(X);
  RIRegister_JvDBUtil_Routines(Exec);
  RIRegister_JvDBUtils(X);   *)
  RIRegister_JvDBUtils_Routines(Exec);   // *)
  RIRegister_JvParsing(X);
  RIRegister_JvParsing_Routines(Exec);   // *)
  RIRegister_JvComponent(X);
  RIRegister_JvFormToHtml(X);
  RIRegister_IdHeaderList(X);
  RIRegister_IdMultipartFormData(X);  //*)
  //SIRegister_JvCtrlUtils(X);
  RIRegister_JvCtrlUtils_Routines(Exec);
 (* RIRegister_JvBdeUtils(X);
  RIRegister_JvBdeUtils_Routines(Exec);   *)
  RIRegister_JvDateUtil_Routines(Exec);    //*)
  RIRegister_JvGenetic(X);
  RIRegister_JvStrUtil_Routines(Exec);
  RIRegister_JvStrUtils_Routines(Exec);
  RIRegister_JvFileUtil_Routines(Exec);
(*  RIRegister_JvJCLUtils(X);
  RIRegister_JvJCLUtils_Routines(Exec);  *)
  RIRegister_JvCalc(X);
  RIRegister_JvCalc_Routines(Exec);
 RIRegister_JvMemoryInfos(X);
  RIRegister_JvComputerInfo(X);  //*)
  RIRegister_JvStarfield(X);     //*)
  RIRegister_JvAnalogClock(X);
  RIRegister_JvAlarms(X);
 (* RIRegister_JvSQLS(X);
  RIRegister_JvDBSecur(X);
  RIRegister_JvDBQBE(X);    *)
  RIRegister_JvProfiler32(X);  //*)
  RIRegister_Serial(X);
  RIRegister_SerDlgs(X);
  //RIRegister_SerDlgs_Routines(Exec); //only register   *)
  RIRegister_JvLED(X);
  RIRegister_JvgLogics(X);
  RIRegister_JvTurtle(X);
  RIRegister_SortThds(X);
  RIRegister_ThSort(X);
  RIRegister_JvExprParser(X);   //*)
  RIRegister_SynRegExpr(X);
  RIRegister_SynRegExpr_Routines(Exec);
  RIRegister_RegularExpressions(X);   //Delphi PCRE16
  RIRegister_RegularExpressions_Routines(Exec);
  RIRegister_JvHtmlParser(X);
  RIRegister_JvgXMLSerializer(X);   //*)
  RIRegister_JvStrings_Routines(Exec);   //*)
  RIRegister_uTPLb_IntegerUtils_Routines(Exec);
  RIRegister_uTPLb_HugeCardinal(X);
  RIRegister_uTPLb_HugeCardinalUtils_Routines(Exec);
  RIRegister_LongIntList(X);    // *)
  RIRegister_StBase(X);
  RIRegister_StBase_Routines(Exec);
  RIRegister_StUtils_Routines(Exec);  //SysTools4
  RIRegister_StFirst_Routines(Exec);
  RIRegister_StToHTML(X);
  RIRegister_StStrms(X);
  RIRegister_StFIN_Routines(Exec);   //*)
  RIRegister_StAstroP_Routines(Exec);
  RIRegister_StStat_Routines(Exec);
  RIRegister_StNetCon(X);
  RIRegister_StDecMth(X);
  RIRegister_StOStr(X);
  RIRegister_StPtrns(X);
  RIRegister_StNetMsg(X);
  RIRegister_StMath_Routines(Exec); //*)
  RIRegister_StExpLog(X);
  RIRegister_StExport(X);
  RIRegister_StGenLog(X);
  RIRegister_StGenLog_Routines(Exec);
  RIRegister_ActnList(X);      //*)
  RIRegister_jpeg(X);
 RIRegister_StRandom(X);
  RIRegister_StDict(X);
  RIRegister_StDict_Routines(Exec);    //45810
  RIRegister_Hashes(X);
  RIRegister_IdCoderHeader_Routines(Exec);
  RIRegister_uMRU(X);
  // STATMemoryReport:= false;  //if STATMemoryReport then
 (* RIRegister_FannNetwork(X);
  
  RIRegister_FANN_Routines(Exec); *)
  RIRegister_RTLDateTimeplus_Routines(Exec);
  RIRegister_RTLDateTimeplus(X);
   RIRegister_ULog(X);
 RIRegister_UThread(X);
  //RIRegister_UTCPIP(X);  *)
  RIRegister_statmach(X);              //46310    *)
  RIRegister_uTPLb_RSA_Primitives_Routines(Exec);
  RIRegister_UMatrix_Routines(Exec);
  RIRegister_DXUtil_Routines(Exec);
  RIRegister_CArrayList(X);     //DXUtil
  RIRegister_crlfParser(X);
  RIRegister_DCPbase64_Routines(Exec);   //*)
  RIRegister_FlyFilesUtils_Routines(Exec);
  RIRegister_PJStreamWrapper(X);       //*)
  RIRegister_LatLonDist_Routines(Exec);
  RIRegister_cHash_Routines(Exec);
  RIRegister_AHash(X);
  RIRegister_commDriver(X);
  RIRegister_PXLNetComs(X);
  RIRegister_PXLTiming_Routines(Exec);
  RIRegister_PXLTiming(X);
  RIRegister_Odometer(X);        //47110
  RIRegister_UIntList(X);
  RIRegister_UIntegerpartition(X);
  RIRegister_API_strings_Routines(Exec);
  RIRegister_API_services(X);
  RIRegister_API_tools(x);
  RIRegister_API_tools_Routines(Exec);
  RIRegister_API_rs232(X);
  RIRegister_API_winprocess(X);
  RIRegister_API_files_Routines(Exec);
  RIRegister_API_files(X);   //5.0.2.24
  RIRegister_JsonConverter(X);
  RIRegister_GUIUtils_Routines(Exec);
  RIRegister_GUIAutomation(X);  //5.0.2.28
  RIRegister_API_trackbar(X);

  (* RIRegister_idCGIRunner(X);
  RIRegister_idPHPRunner(X);
  RIRegister_DrBobCGI_Routines(Exec);   *)
  RIRegister_OverbyteIcsLogger(X);   //*)
  RIRegister_OverbyteIcsCharsetUtils_Routines(Exec);
  RIRegister_OverbyteIcsCharsetUtils(X);    //47120
  RIRegister_OverbyteIcsMimeUtils(X);
  RIRegister_OverbyteIcsMimeUtils_Routines(Exec);  //*)
  RIRegister_OverbyteIcsUrl_Routines(Exec);
  //RIRegister_uWebSocket(X);
  RIRegister_IdWebSocketSimpleClient(X);   //5.1.4.98 IX
  RIRegister_ExecuteidWebSocket(X);
  RIRegister_ExecuteWebsocket_Routines(Exec);
  RIRegister_WebString(x);
  RIRegister_WebString_Routines(Exec);
  RIRegister_McJSON(X);
  RIRegister_McJSON_Routines(Exec);
  RIRegister_cSocksUtils_Routines(Exec);
  RIRegister_ExecuteGLPanel_Routines(Exec);
  RIRegister_ExecuteGLPanel(X);
  RIRegister_KhFunction_Routines(exec);
  RIRegister_KhFunction(X);
  RIRegister_ALOpenOffice_Routines(Exec);
  RIRegister_ALOpenOffice(X);
  //RIRegister_ALLibPhoneNumber_Routines(Exec);
  RIRegister_ALExecute_Routines2(Exec);
  RIRegister_uUsb(X);
  RIRegister_uWebcam_Routines(Exec);    //*)
  RIRegister_uTPLb_MemoryStreamPool(X);  //4.7.1.80
  RIRegister_uTPLb_Signatory(X);
  RIRegister_EwbCoreTools_Routines(Exec);
  RIRegister_EwbUrl(X);
  //RIRegister_SendMail_For_Ewb_Routines(Exec);
  //RIRegister_SendMail_For_Ewb(X);     *)
  RIRegister_MaskEdit(X);
  RIRegister_MaskEdit_Routines(Exec);
  RIRegister_SimpleRSSTypes(X);
 RIRegister_SimpleRSS(X);    //4.7.2.82
  RIRegister_psULib_Routines(Exec);
  RIRegister_psUFinancial_Routines(Exec);
  RIRegister_rfc1213ip(X);
  RIRegister_rfc1213util_Routines(Exec);    //*)
  RIRegister_JTools_Routines(Exec);
  //RIRegister_neuralbit_Routines(Exec);   *)
  RIRegister_neuralab_Routines(Exec);
  RIRegister_neuralab(X);
  RIRegister_neuralcache(X);
  RIRegister_neuralbyteprediction(X);
  RIRegister_USearchAnagrams(X);
  RIRegister_HashUnit(X);            //4.7.4.62    *)
  RIRegister_Jsons(X);
  RIRegister_JsonsUtilsEx_Routines(Exec);
  RIRegister_Bricks(X);
  RIRegister_lifeblocks(X);  //*)
  RIRegister_AsciiShapes(X);
  RIRegister_cInternetUtils_Routines(Exec);  ////4.7.5.20  ----47520
  RIRegister_cInternetUtils(X);   //*)
  RIRegister_cWindows_Routines(Exec);
  RIRegister_cWindows(X);
  RIRegister_flcSysUtils_Routines(Exec);
  RIRegister_flcSysUtils(X);   //*)
  RIRegister_SimpleImageLoader(X);
  RIRegister_RotImg_Routines(Exec);
  RIRegister_RotImg(X);
  RIRegister_HSLUtils_Routines(Exec);
  RIRegister_GraphicsMathLibrary_Routines(Exec);
  RIRegister_GraphicsMathLibrary(X);
  RIRegister_flcStatistics_Routines(Exec);
  RIRegister_flcStatistics(X);
  RIRegister_flcMaths_Routines(Exec);
  RIRegister_flcCharSet_Routines(Exec);
  RIRegister_flcBits32_Routines(Exec);
  RIRegister_flcTimers_Routines(Exec);
  RIRegister_flcTimers(X);
  RIRegister_cBlaiseParserLexer(X);  //*)
  RIRegister_flcRational_Routines(Exec);
  RIRegister_flcRational(X);
  RIRegister_flcComplex_Routines(Exec);
  RIRegister_flcComplex(X);
  RIRegister_flcMatrix_Routines(Exec);
  RIRegister_flcMatrix(X);
  RIRegister_flcStringBuilder_Routines(Exec);
  RIRegister_flcStringBuilder(X);    //*)
  RIRegister_flcASCII_Routines(Exec);      //47520  - 80
  RIRegister_flcStringPatternMatcher_Routines(Exec);
  RIRegister_flcUnicodeChar_Routines(Exec);
  RIRegister_flcUnicodeCodecs_Routines(Exec);
  RIRegister_flcUnicodeCodecs(X);           //V50270
  RIRegister_SemaphorGrids(X);
  RIRegister_uXmlDates_Routines(Exec);
  RIRegister_JclTimeZones(X);
  RIRegister_JclTimeZones_Routines(Exec);
  RIRegister_XmlDocRssParser(X);
  RIRegister_RssParser_Routines(Exec);
  RIRegister_RssModel(X);
  RIRegister_SimpleParserRSS(X);
  //RIRegister_SimpleRSSUtils(X);
  RIRegister_SimpleRSSUtils_Routines(Exec);   //*)
  RIRegister_StrUtil_Routines(Exec);
  RIRegister_StrUtil(X);    //*)
  RIRegister_PythonEngine_Routines(Exec);
  RIRegister_PythonEngine(X);
  RIRegister_VclPythonGUIInputOutput(X);
  RIRegister_VarPyth_Routines(Exec);
  RIRegister_cParameters_Routines(Exec);
  RIRegister_cParameters(X);
  RIRegister_WDCCMisc_Routines(Exec);
  RIRegister_WDCCWinInet(X);
 RIRegister_WDCCOleVariantEnum(X);
  RIRegister_WDCCOleVariantEnum_Routines(Exec);
  RIRegister_WDCCWinInet_Routines(Exec);
  RIRegister_PythonVersions_Routines(Exec);
  RIRegister_PythonVersions(X);
  RIRegister_PythonAction(X);    //*//)
  RIRegister_VclPythonGUIInputOutput_Routines(Exec);  //*)
  RIRegister_SingleList_Routines(Exec);
  RIRegister_SingleListClass(X);
  RIRegister_AdMeter(X);
  RIRegister_neuralplanbuilder(X);
  RIRegister_neuralvolume(X);
  RIRegister_neuralvolume_Routines(Exec);
  RIRegister_neuralvolumev_Routines(Exec);
  RIRegister_DoubleList4_Routines(Exec);
  RIRegister_DoubleList4(X);               //47590
  RIRegister_ByteListClass_Routines(Exec);
  RIRegister_ByteListClass(X);  //*)
  RIRegister_flcVectors_Routines(Exec);
  RIRegister_flcVectors(X);   //*)
  RIRegister_uSysTools_Routines(Exec);
  RIRegister_StBCD_Routines(Exec);
  RIRegister_StTxtDat(X);       //---ch<r
  RIRegister_StTxtDat_Routines(Exec);  //*)
  RIRegister_StRegEx(X);
  RIRegister_StIniStm(X);
  RIRegister_StIniStm_Routines(Exec);
  RIRegister_StBarC(X);
 RIRegister_StDbBarC(X);
  RIRegister_StBarPN(X);
  RIRegister_StDbPNBC(X);
  RIRegister_StDb2DBC(X); //*)
  RIRegister_StMoney(X);    //*)
  RIRegister_STSystem_Routines(Exec);
  RIRegister_SynURIOpener(X);
  RIRegister_EdgeMain(X);            //5.1.6.98
  RIRegister_remain(X);
  RIRegister_VclGoogleMap(X);
  RIRegister_U_Go3(X);
  RIRegister_GoGame_Routines(Exec);
 RIRegister_JvKeyboardStates(X);
  RIRegister_JclMapi(X);
  RIRegister_JclMapi_Routines(Exec); //3.9.9.6
  RIRegister_JvMail(X);
  RIRegister_JclConsole(X);
  RIRegister_JclLANMan_Routines(exec);
 RIRegister_JclLocales(X);
  RIRegister_JclLocales_Routines(Exec);
  RIRegister_IdStack(X);  //*  V5.0.2.90)
  RIRegister_IdSocks(X); //ZZ*)
  RIRegister_IdIOHandler(X);
  RIRegister_IdSocketHandle(X);
  RIRegister_IdCustomTCPServer(X);
  RIRegister_IdMessageCoder(X);
  RIRegister_IdMessageCoderMIME(X);
  RIRegister_IdServerIOHandler(X);
  RIRegister_IdServerIOHandlerSocket(X);
  RIRegister_IdIOHandlerSocket(X);
  RIRegister_IdTCPServer(X); // for bindings*)
  RIRegister_IdCustomHTTPServer(X);
  RIRegister_IdCustomHTTPServer_Routines(Exec);
  RIRegister_U_MakeCityLocations2(X);
(* RIRegister_IdSSLOpenSSL(X);    *)
  RIRegister_IdRemoteCMDClient(X);
  RIRegister_IdRemoteCMDServer(X);
  RIRegister_IdRexec(X);
  RIRegister_IdUDPServer(X);  //5.0.2.95*)
  RIRegister_IdIPWatch(X);
  RIRegister_IdIrcServer(X);   //*)
  RIRegister_IdMessageCollection(X);  //*)
  //RIRegister_IdRFCReply(X); //*)
  RIRegister_IdIdentServer(X);  //*)
  RIRegister_IdIdent(X);  //*)
  RIRegister_IdEcho(X);
  RIRegister_IdEchoServer(X);
  //SIRegister_IdEchoUDP(X);
  RIRegister_IdRawBase(X);
  RIRegister_IdEchoUDP(X);
  RIRegister_IdEchoUDPServer(X);
  RIRegister_IdTelnetServer(X);
  RIRegister_IdAntiFreezeBase(X);
(*  RIRegister_IdHostnameServer(X);   *)
  RIRegister_IdTunnelCommon(X);
 (* RIRegister_IdTunnelMaster(X);
  RIRegister_IdTunnelSlave(X);  *)
  RIRegister_IdRSHServer(X);   //*)
  RIRegister_IdRSH(X);    //*)
  RIRegister_MapReader_Routines(Exec);
  RIRegister_LibTar(X);
  RIRegister_LibTar_Routines(Exec);
  RIRegister_IdChargenServer(X);  //*)
  RIRegister_IdBlockCipherIntercept(X);  //*)
  RIRegister_IdException(X);
 (* RIRegister_IdFTPServer(X); *)
  RIRegister_uwinstr_Routines(Exec);
  RIRegister_utexplot_Routines(Exec);
  RIRegister_VarRecUtils_Routines(Exec);
  RIRegister_JvStringHolder(X);   //*)
  RIRegister_JvStringListToHtml(X);
  RIRegister_IdCoder(X);   //*)
  RIRegister_LazFileUtils_Routines(Exec);
  RIRegister_FileUtil_Routines(Exec);
  RIRegister_FileUtil(X);
  RIRegister_IDECmdLine_Routines(Exec);    // *)
  RIRegister_lazMasks_Routines(Exec);
  RIRegister_lazMasks(X);
  RIRegister_Barcode(X);
  RIRegister_Barcode_Routines(Exec);
  RIRegister_ip_misc_Routines(Exec);  //*)
 RIRegister_SimpleXML_Routines(Exec);
  RIRegister_StNet(X);
  RIRegister_StNetPfm(X);
  RIRegister_JvPatchFile(X);
  RIRegister_JclPeImage(X);
  RIRegister_JclPeImage_Routines(Exec);   //*)
  RIRegister_CompilersURunner(X);
  RIRegister_cPEM(X);
  RIRegister_cPEM_Routines(Exec);
  RIRegister_FlatSB_Routines(Exec);  //*)
  RIRegister_JvDirectories(X);
  RIRegister_JclSvcCtrl(X);
  RIRegister_JclSchedule(X);
  RIRegister_JclSchedule_Routines(Exec);
  RIRegister_JvSoundControl(X);
  //RIRegister_JvBDESQLScript(X);  *)
  RIRegister_JvSearchFiles(X);
  RIRegister_JvSpeedbar_Routines(Exec);
  RIRegister_JvSpeedbar(X);
  RIRegister_JvSpeedbarSetupForm(X);
  RIRegister_JvSpeedbarSetupForm_Routines(Exec);
   //RIRegister_IdSSLOpenSSL_Routines(Exec);
  //RIRegister_StBCD(X);
  RIRegister_ActnList_Routines(Exec);
  RIRegister_JclNTFS(X);
   RIRegister_JclNTFS_Routines(Exec);
  RIRegister_JclAppInst(X);
  RIRegister_JclAppInst_Routines(Exec);    //*)
  RIRegister_JclMIDI(X);
  RIRegister_JclMIDI_Routines(Exec);
  //RIRegister_JclWinMidi(X);
  RIRegister_JclWinMidi_Routines(Exec);
  //RIRegister_JvRle(X);
 RIRegister_JvRle_Routines(Exec);
 RIRegister_JvRas32(X);
  RIRegister_JvImageWindow(X);
  RIRegister_JvImageDrawThread(X);  //*)//3.9.7.3
  RIRegister_JvTransparentForm(X); //*)
  RIRegister_JvWinDialogs(X);
  RIRegister_JvWinDialogs_Routines(Exec);  //*)
  RIRegister_JvFloatEdit(X); //*)
  RIRegister_JvDirFrm(X);
  RIRegister_JvDirFrm_Routines(Exec);  //*)
  RIRegister_JclUnitConv_mX2_Routines(Exec);
  RIRegister_JvDualListForm(X);
  RIRegister_JvDualList(X);    //*)
  RIRegister_JvSwitch(X);
  RIRegister_JvTimerLst(X);   //*)
  RIRegister_JvObjStr(X);
 (* RIRegister_JvMemTable(X);    *)
  RIRegister_xrtl_math_Integer(X);
  RIRegister_xrtl_math_Integer_Routines(Exec);
  RIRegister_StLArr(X);
  RIRegister_StWmDCpy(X);
  RIRegister_StText_Routines(Exec);
  RIRegister_StNTLog(X);
  RIRegister_JvImagPrvw_Routines(Exec);
  RIRegister_JvImagPrvw(X); //*)
  RIRegister_JvFormPatch(X);  //((*)
  RIRegister_JvDataConv(X); // *)
  RIRegister_JvPicClip(X);
  RIRegister_JvCpuUsage(X);
  RIRegister_JvCpuUsage2(X);  //*)
  RIRegister_JvParserForm(X);
  RIRegister_JvJanTreeView(X);   //*)
  RIRegister_JvPlaylist(X);
  RIRegister_JvTransLED(X);
  RIRegister_JvFormAutoSize(X);
  RIRegister_JvYearGridEditForm(X); //*)
  RIRegister_JvMarkupCommon(X);  // *)
  RIRegister_JvChart(X); //*)
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
  RIRegister_JvTFUtils_Routines(Exec);  //*)
 RIRegister_Registry(X);
  RIRegister_TlHelp32_Routines(Exec);
 RIRegister_RunElevatedSupport_Routines(Exec);
 RIRegister_SynCrtSock(X);
  RIRegister_SynCrtSock_Routines(Exec);
  RIRegister_devcutils_Routines(Exec);
 RIRegister_JclRegistry_Routines(Exec);  //*)
 // SIRegister_JvXPCoreUtils(X);
  RIRegister_JvXPCoreUtils_Routines(Exec);  //3.9.8 fin   *)
  RIRegister_ShellZipTool_Routines(Exec);
  RIRegister_ShellZipTool(X);
  RIRegister_JvJoystick(X);
  RIRegister_JvMailSlots(X);
  RIRegister_JclComplex(X);   //*)
  RIRegister_SynPdf(X);
  RIRegister_SynPdf_Routines(Exec);
  RIRegister_JvAirBrush(X);   //*)
  RIRegister_mORMotReport(X);
  RIRegister_mORMotReport_Routines(Exec);
  RIRegister_ExcelExport(X);
  RIRegister_JvDBGridExport(X);
  RIRegister_JvDBGridExport_Routines(Exec);  //*)
  RIRegister_JvSerialMaker(X);  //*)
  RIRegister_JvWin32_Routines(Exec);
  RIRegister_JvPaintFX(X);
  RIRegister_JvPaintFX_Routines(Exec);   //*)
  RIRegister_JvValidators(X);
  RIRegister_JvNTEventLog(X);  //*)
  RIRegister_ugamma_Routines(Exec);
  RIRegister_IdMIMETypes_Routines(Exec);
  RIRegister_JvConverter(X);     //*)
  RIRegister_JvCsvParse_Routines(Exec);  //*)
  RIRegister_HexDump(X);
  RIRegister_HexDump_Routines(Exec);
  RIRegister_uTPLb_StreamUtils_Routines(Exec); //4.2.8.10
  RIRegister_uTPLb_StreamCipher(X); // uPSI_uTPLb_StreamCipher,*)
  RIRegister_uTPLb_Asymetric(X); //uPSI_uTPLb_Asymetric,  *)
  RIRegister_uTPLb_Random(X);

  RIRegister_uTPLb_AES(X);
  RIRegister_uTPLb_AES_Routines(Exec);
  RIRegister_uTPLb_SHA2(X);
  RIRegister_AESPassWordDlg(X);  //*)
  RIRegister_MathUtils_Routines(Exec);
  RIRegister_JclMultimedia(X);
  RIRegister_JclMultimedia_Routines(Exec); //3.9.75  *)
  RIRegister_TTypeTranslator(X);
  RIRegister_TypeTrans_Routines(Exec);
  RIRegister_utypes_Routines(Exec);    //for dmath.dll
  RIRegister_uwinplot_Routines(Exec);  // *)
  RIRegister_umath_Routines(Exec);
 (* RIRegister_GR32_System(X);
  RIRegister_GR32_System_Routines(Exec);    *)
  RIRegister_JvSimLogic(X);
  RIRegister_JvSimIndicator(X);
  RIRegister_JvSimPID(X);
  RIRegister_JvSimPIDLinker(X);
  RIRegister_xrtl_util_CPUUtils_Routines(Exec);   // *)
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
 // RIRegister_GR32(X);  //*)
 // RIRegister_GR32_Routines(Exec);
 (* RIRegister_GR32_Rasterizers(X);
  RIRegister_GR32_Rasterizers_Routines(Exec);
  RIRegister_GR32_Image(X);
  RIRegister_GR32_ExtImage(X);
  RIRegister_GR32_ExtImage_Routines(Exec);
  RIRegister_GR32_OrdinalMaps(X);  *)
  RIRegister_xrtl_util_TimeStamp(X);
 // RIRegister_xrtl_util_TimeUtils(X);
  RIRegister_xrtl_util_TimeUtils_Routines(Exec);
  RIRegister_xrtl_util_TimeZone(X);
  RIRegister_xrtl_util_TimeZone_Routines(Exec);
  RIRegister_xrtl_util_Map(X);
  RIRegister_xrtl_util_Set(X);  //3.9.6.4   *)
  RIRegister_xrtl_util_Exception(X);
  RIRegister_xrtl_util_Exception_Routines(Exec);
  RIRegister_xrtl_util_Compare_Routines(Exec);
  RIRegister_xrtl_util_Value(X);
  RIRegister_xrtl_util_Value_Routines(Exec);  //*)
  RIRegister_cRandom_Routines(Exec);
  RIRegister_ueval_Routines(Exec);
   //RIRegister_EIdHTTPProtocolException(x);
  RIRegister_TIdHTTP(x);
  RIRegister_TIdCustomHTTP(x);
  RIRegister_TIdHTTPProtocol(x);
  RIRegister_TIdHTTPRequest(x);       //check for duplicate
  RIRegister_TIdHTTPResponse(x);  //}
  RIRegister_IdTCPConnection(X);  //*)
  RIRegister_IdTCPClient(X); //*)
  RIRegister_IdHTTPHeaderInfo(X);
  RIRegister_IdHTTP(x);   //*)
  RIRegister_HTTPParse(X);
  RIRegister_HTTPUtil_Routines(Exec); //*)
  RIRegister_HTTPApp(X);         //3.7
  RIRegister_HTTPApp_Routines(EXec);
  RIRegister_DBWeb(X);
  RIRegister_DBWeb_Routines(Exec);
  RIRegister_DBXpressWeb(X);
 // RIRegister_DBBdeWeb(X);   *)
  RIRegister_ShadowWnd(X);  //3.8  *)
  RIRegister_ToolWin(X);
  RIRegister_Tabs(X);
  RIRegister_JclGraphUtils_Routines(Exec);  //*)
  RIRegister_VelthuisFloatUtils_Routines(Exec);
  RIRegister_IdHashSHA1Utils_Routines(Exec);
  RIRegister_JclCounter(X);
  RIRegister_JclCounter_Routines(Exec);  //*)
  RIRegister_JclSysInfo_Routines(Exec);
  RIRegister_JclSecurity_Routines(Exec);
  RIRegister_IdUserAccounts(X); //*)
  RIRegister_JclFileUtils(X);
  RIRegister_JclFileUtils_Routines(Exec);   //*)
  RIRegister_IdAuthentication(X);
  RIRegister_IdAuthentication_Routines(Exec);  //*)
  RIRegister_IMouse_Routines(Exec);
  RIRegister_IMouse(X);
 (* RIRegister_JclPrint(X);
  RIRegister_JclPrint_Routines(Exec);   *)
  RIRegister_JclMime_Routines(Exec);
  RIRegister_JvRichEdit(X);
  RIRegister_JvDBRichEd(X);     //*)
  RIRegister_JvDice(X);
  //RIRegister_JclMime(X);
  //RIRegister_TIdURI(x);   *)
  RIRegister_IdURI(X);    //*)
   RIRegister_SyncObjs(X);
  //RIRegister_AsyncCalls_Routines(Exec);
  RIRegister_AsyncCalls(X);
  RIRegister_AsyncCalls_Routines(Exec);
   //RIRegister_ParallelJobs(X);
  //RIRegister_ParallelJobs_Routines(Exec);  //*)
  RIRegister_OAuth(X);
  RIRegister_Variants_Routines(Exec);
  RIRegister_VarCmplx_Routines(Exec);
  RIRegister_DTDSchema(X);   //*)
  RIRegister_ShLwApi_Routines(Exec);
  RIRegister_IBUtils_Routines(Exec);
  RIRegister_TIBTimer(X);    ////3.9.2.2 fin -3.9.3  *)
  RIRegister_JclSimpleXml(X);
  RIRegister_JclSimpleXml_Routines(Exec); //*)
  RIRegister_JvLogFile(X);
  RIRegister_JvGraph_Routines(Exec);
  RIRegister_TJvGradient(X);   //*)
  RIRegister_JvComCtrls(X);
  RIRegister_JvCtrls(X);  //*)
  RIRegister_CPort(X);
  RIRegister_CPort_Routines(Exec);
  RIRegister_CPortCtl(X);
  RIRegister_CPortEsc(X);   //3.9.3
  RIRegister_CPortMonitor(X);
  RIRegister_cutils_Routines(Exec);
  RIRegister_PerlRegEx(X);  //*)
  RIRegister_BoldUtils_Routines(Exec);
  RIRegister_IdSimpleServer(X);
  RIRegister_BarCodeScaner(X);  //*)
  RIRegister_BarCodeScaner_Routines(Exec);
  RIRegister_GUITesting(X);
  RIRegister_JvFindFiles(X);
  RIRegister_JvFindFiles_Routines(Exec);   //*)
  RIRegister_CheckLst(X);
  RIRegister_JvSimpleXml(X);
  RIRegister_JvSimpleXml_Routines(Exec);    //*)
  RIRegister_ExtPascalUtils_Routines(Exec);
 RIRegister_SocketsDelphi_Routines(Exec);
  RIRegister_XmlVerySimple(X);
  //RIRegister_StAstro(X);
  RIRegister_StAstro_Routines(Exec); //*)
  RIRegister_StSort(X);
  RIRegister_StSort_Routines(Exec);  // *)
  RIRegister_StDate_Routines(Exec);
  RIRegister_StDateSt_Routines(Exec);
  RIRegister_StVInfo(X);
  RIRegister_JvBrowseFolder(X);
  RIRegister_JvBrowseFolder_Routines(Exec);
  RIRegister_JvBoxProcs_Routines(Exec);   //*)
  RIRegister_usimann_Routines(Exec);
  RIRegister_urandom_Routines(Exec);
 (* RIRegister_uranuvag_Routines(Exec);
  RIRegister_uqsort_Routines(Exec);  *)
  RIRegister_ugenalg_Routines(Exec);
  RIRegister_uinterv_Routines(Exec);
  RIRegister_JvHighlighter(X);     //*)
  RIRegister_Diff(X); //*)
  RIRegister_WinAPI_Routines(Exec);
  RIRegister_StBits(X);
  RIRegister_MultilangTranslator(X);
  RIRegister_HyperLabel(X);
 (* RIRegister_TomDBQue(X);    *)
  RIRegister_hhAvALT(X);
  RIRegister_Starter(X);
  RIRegister_FileAssocs_Routines(Exec);
  RIRegister_devFileMonitorX(X);  //*)
  RIRegister_devrun(X);
  RIRegister_devExec(X);
  RIRegister_devExec_Routines(Exec);
  RIRegister_dpipes_Routines(Exec);
  RIRegister_dpipes(X);
  RIRegister_dprocess_Routines(Exec);
  RIRegister_dprocess(X);
 RIRegister_oysUtils(X);
  RIRegister_oysUtils_Routines(Exec);
  RIRegister_DosCommand(X);
  RIRegister_CppTokenizer(X);
  RIRegister_JvHLParser(X);
  RIRegister_JvHLParser_Routines(Exec); // *)
  RIRegister_JclShell_Routines(Exec);
  RIRegister_JclCOM_Routines(Exec);
(*  RIRegister_GR32_Math_Routines(Exec);
  RIRegister_GR32_LowLevel_Routines(Exec); *)
  RIRegister_SimpleHl(X);
 (* RIRegister_GR32_Filters_Routines(Exec);
  RIRegister_GR32_VectorMaps(X);  *)
  RIRegister_cXMLFunctions_Routines(Exec);   //*)
  RIRegister_JvTimer(X);
  RIRegister_cHTTPUtils_Routines(Exec);
  RIRegister_cHTTPUtils(X);
   RIRegister_ETLSError(X);
  RIRegister_cTLSUtils_Routines(Exec);
  RIRegister_JclGraphics_Routines(Exec);
  RIRegister_JclGraphics(X);    //*)
  RIRegister_JclSynch(X);
  RIRegister_JclSynch_Routines(Exec);  //*)
  RIRegister_Spring_Cryptography_Utils_Routines(Exec);
 RIRegister_JclIniFiles_Routines(Exec);
(*   {$IFDEF CD2XXUNIT}
    RIRegister_D2XXUnit_Routines(Exec);
  {$ENDIF}
   //SIRegister_D2XXUnit(X);
  //RIRegister_D2XXUnit_Routines(Exec);  *)
  RIRegister_JclMath(X);  // *)
  RIRegister_JCLMathMax_Routines(Exec);
  RIRegister_JclDateTime_Routines(Exec);
  RIRegister_JclEDI_Routines(Exec);
  RIRegister_JclEDI(X);
  RIRegister_JclMiscel2_Routines(Exec);  //*)
  RIRegister_JclAnsiStrings_Routines(Exec);
  RIRegister_JclStreams(X);
  RIRegister_JclStreams_Routines(Exec);  // *)
  RIRegister_JclTask(X);                 //V5.2.9.160

  RIRegister_BlockSocket(X);
  RIRegister_synautil_Routines(Exec);
   RIRegister_JvXmlDatabase(X);  //*)
   RIRegister_IdURI(x);
  RIRegister_IdFTP(X);
  RIRegister_xmlutil_Routines(Exec); //3.2 XML    *)
  RIRegister_MaskUtils_Routines(Exec); //3.5
  RIRegister_Masks(X);
  RIRegister_Masks_Routines(Exec);  //*)
  RIRegister_FileCtrl(X);
  RIRegister_FileCtrl_Routines(Exec);
  RIRegister_dwsWebUtils(X);
  RIRegister_Outline(X);
  RIRegister_ScktComp(X);
  RIRegister_ScktComp_Routines(Exec);
  RIRegister_Calendar(X);    //*)
  RIRegister_VListView(X);
  RIRegister_ide_debugoutput(X);    //*)
  RIRegister_ComCtrls(X); //3.6
  RIRegister_ComCtrls_Routines(Exec);

  RIRegister_Dialogs(X);
  RIRegister_Dialogs_Routines(Exec);
  RIRegister_ExtDlgs(X);
  RIRegister_ValEdit(X);  //*)
  RIRegister_FMTBcd(X);
  RIRegister_FMTBcd_Routines(Exec);
  RIRegister_Provider_Routines(Exec); //3.6
  RIRegister_Provider(X); //*)
  RIRegister_DBClient_Routines(Exec);
  RIRegister_DBClient(X); // *)
  RIRegister_CDSUtil_Routines(Exec); // *)
  RIRegister_GraphUtil_Routines(Exec);
  RIRegister_VarHlpr_Routines(Exec);
  RIRegister_interface2_so(X);  // *)
  RIRegister_IdASN1Util_Routines(Exec); // *)
  RIRegister_Contnrs(X);
  RIRegister_Contnrs_Routines(Exec);
  RIRegister_MyBigInt(X); //*)
  RIRegister_StdConvs_Routines(Exec);
  RIRegister_ConvUtils(X);
  RIRegister_ConvUtils_Routines(Exec);
  RIRegister_SOAPHTTPClient(X);
  RIRegister_VCLScannerImpl(X);
  //RIRegister_SynEditKeyCmds_Routines(Exec);
  //RIRegister_SynEditKeyCmds(X);
  RIRegister_SynMacroRecorder(X);  //*)
  RIRegister_SynEditTypes_Routines(Exec);
  RIRegister_SynEditMiscClasses(X);  //*)
  RIRegister_SynEditHighlighter(X);
  RIRegister_SynEditHighlighter_Routines(Exec);
  RIRegister_SynHighlighterPas(X);
  RIRegister_SynEdit(X);
  RIRegister_SynEditRegexSearch(X);   //*)
  RIRegister_SynMemo(X);
 // RIRegister_SynHighlighterAny(X);
  RIRegister_SynEditMiscProcs_Routines(Exec);
  RIRegister_SynEditExport(X);
  RIRegister_SynExportRTF(X);
  RIRegister_SynExportHTML(X);
  RIRegister_SynEditSearch(X);
  RIRegister_JvSticker(X);  //*)
  RIRegister_JvZoom(X);    //*)
  RIRegister_PMrand_Routines(Exec);
  RIRegister_SynHighlighterDfm_Routines(Exec);
  RIRegister_SynHighlighterDfm(X);  //*)
  RIRegister_SynHighlighterHtml(X);
  RIRegister_ImageWin(X);
  RIRegister_CustomDrawTreeView(X);
  RIRegister_GraphWin(X);
  RIRegister_StSpawn(X);  //*)
  RIRegister_actionMain(X);
 RIRegister_CtlPanel(X);
  RIRegister_CtlPanel_Routines(Exec);
  RIRegister_IdLPR(X);
 (* RIRegister_SockRequestInterpreter(X);  *)
  RIRegister_ulambert_Routines(Exec);
  RIRegister_SimpleDS(X);
  RIRegister_DBXSqlScanner(X);
  RIRegister_DBXMetaDataUtil(X);   //*)
  RIRegister_TeeProcs(X);
  RIRegister_TeeProcs_Routines(Exec);
  RIRegister_TeCanvas_Routines(Exec);
  RIRegister_TeCanvas(X);
  RIRegister_TeEngine(X);
  RIRegister_TeEngine_Routines(Exec); // *)
  RIRegister_Chart(X);
  RIRegister_Chart_Routines(Exec);
  RIRegister_Series_Routines(Exec);
  RIRegister_Series(X);             //4.2.6.10   *)
  RIRegister_CopyPrsr(X);
  RIRegister_MDIEdit(X);
 RIRegister_ExtActns(X);
  RIRegister_AppEvnts(X); // *)
  RIRegister_frmExportMain(X);
  RIRegister_BoldComUtils_Routines(exec);
  RIRegister_BoldIsoDateTime_routines(exec);
  RIRegister_BoldComUtils(X);
  RIRegister_BoldXMLRequests(X);
 RIRegister_BoldStringList(X);
  RIRegister_BoldFileHandler_Routines(Exec);
  RIRegister_BoldFileHandler(X);
  RIRegister_BoldThread(X);    //*)
  RIRegister_BoldContainers(X);
  RIRegister_BoldQueryUserDlg(X);
  RIRegister_BoldQueryUserDlg_Routines(Exec);
  RIRegister_BoldWinINet_Routines(Exec);
  RIRegister_BoldQueue(X);
  RIRegister_BoldQueue_Routines(Exec);
 // RIRegister_IdMappedPortTCP(X);
 //RIRegister_IdMappedFTP(X);
  RIRegister_IdMappedPortUDP(X);   //*)
  RIRegister_MSysUtils_Routines(Exec);
  RIRegister_ESBMaths2_Routines(Exec);
  RIRegister_ESBMaths_Routines(Exec);   //  *)
  RIRegister_uLkJSON(X);
  RIRegister_uLkJSON_Routines(Exec);
  RIRegister_ZURL(X);
  RIRegister_ZSysUtils(X);
  RIRegister_ZSysUtils_Routines(Exec);
  RIRegister_ZClasses(X);
 //SIRegister_ZMatchPattern(X);
  RIRegister_ZMatchPattern_Routines(Exec);
  RIRegister_ZCollections(X);
  RIRegister_ZEncoding_Routines(Exec);
 (* RIRegister_IdNTLM_Routines(Exec); //SIRegister_IdNTLM(X);   *)
  RIRegister_IdNNTP(X);
  RIRegister_usniffer(X);
  RIRegister_IdCoder3to4(X);
  RIRegister_IdCoderMIME(X);
  RIRegister_IdCoderUUE(X);
  RIRegister_IdCoderXXE(X);
 (* RIRegister_IdCookie(X);  *)
  RIRegister_IdCookieManager(X);  //*)
  RIRegister_WDosSocketUtils_Routines(Exec);
  RIRegister_WDosPlcUtils_Routines(Exec);
  RIRegister_WDosPorts(X);
  RIRegister_WDosResolvers(X);
  RIRegister_WDosTimers(X);
  RIRegister_WDosTimers_Routines(Exec);
  RIRegister_WDosPlcs(X);
  RIRegister_WDosPneumatics(X);
  RIRegister_IdDNSResolver(X);  //502095*)
  RIRegister_IdFingerServer(X);  //*)
  RIRegister_IdIntercept(X);
  RIRegister_IdHTTPWebBrokerBridge(X);
  RIRegister_IdIOHandlerStream(X);
  RIRegister_IdLogBase(X);
  RIRegister_IdQOTDUDP(X);
  RIRegister_IdQOTDUDPServer(X);    //*)
  RIRegister_IdSysLogMessage_Routines(Exec);
  RIRegister_IdSysLogMessage(X);
  RIRegister_IdSysLog(X);
  RIRegister_IdSysLogServer(X);
  RIRegister_IdTimeServer(X);
  RIRegister_IdTimeUDPServer(X); //*)
  RIRegister_IdTimeUDP(X);
  RIRegister_IdUserAccounts(X); //*)
  RIRegister_TextUtils_Routines(Exec); // *)
  RIRegister_MandelbrotEngine(X);
  RIRegister_delphi_arduino_Unit1(X);
 RIRegister_fplotMain(X);
   RIRegister_SRMgr(X);
   RIRegister_PppState(X);  //*)
   RIRegister_FindFileIter_Routines(exec);
   RIRegister_PppParser(X);
   RIRegister_PppLexer(X);   //*)
   RIRegister_uJSON(X);    //3.9.9.80
  RIRegister_PCharUtils_Routines(Exec);
  RIRegister_JclStrHashMap(X);
  RIRegister_JclStrHashMap_Routines(Exec);
  RIRegister_JclHookExcept_Routines(Exec);
  RIRegister_EncdDecd_Routines(Exec);
  //RIRegister_SockAppReg_Routines(Exec);      *)
  RIRegister_PJFileHandle(X);
  RIRegister_TPJEnvVars(X);
  RIRegister_TPJEnvVarsEnumerator(X);
  RIRegister_PJEnvVars_Routines(Exec);
  RIRegister_PJPipe(X);
  RIRegister_PJPipeFilters(X);
  RIRegister_TPJConsoleApp(X);
  RIRegister_TPJCustomConsoleApp(X);
  RIRegister_PJConsoleApp_Routines(Exec);
 RIRegister_UConsoleAppEx(X);     //3.99.80
  RIRegister_UConsoleApp(X);
  RIRegister_DbxDataGenerator(X);
  RIRegister_DbxSocketChannelNative(X);
  RIRegister_DBXClient(X);  //*)
  RIRegister_IdLogEvent(X);
  RIRegister_Reversi_Routines(Exec);
  RIRegister_GameOfLife(X);
  RIRegister_MinesweeperGame(X);
 (* RIRegister_IdSMTPServer(X);     *)
  RIRegister_Geometry_Routines(Exec);  //*)
  RIRegister_Textures(X);        //3.9.9.81
  RIRegister_IBX(X);
  RIRegister_IBSQL_Routines(Exec);
(*  RIRegister_IWDBCommon_Routines(Exec);    *)
  RIRegister_MyGrids(X);
  RIRegister_SortGrid(X);
  RIRegister_SortGrid_Routines(Exec);    //*)
  RIRegister_IB(X);
  RIRegister_IB_Routines(Exec);
  RIRegister_IBScript(X); //*)
  RIRegister_JvCSVBaseControls(X); //*)
  RIRegister_JvShellHook(X);
  RIRegister_JvShellHook_Routines(Exec);
  RIRegister_JvFullColorForm(X);
  RIRegister_JvSegmentedLEDDisplayMapperFrame(X);
  RIRegister_Jvg3DColors(X);
  RIRegister_JvSHFileOperation(X);
  RIRegister_uFilexport(X);
  RIRegister_JvDialogs(X);
  RIRegister_JvDBTreeView(X);  // *)
  RIRegister_JvDBUltimGrid(X);
  RIRegister_JvDBQueryParamsForm(X);
  RIRegister_JvDBQueryParamsForm_Routines(Exec); // *)
  RIRegister_JvExControls(X);
  RIRegister_JvExControls_Routines(Exec);
 // RIRegister_JvBDEMemTable(X);    *)
  RIRegister_JvCommStatus(X); //*)
  RIRegister_JvgWinMask(X);  //*)
  RIRegister_StList(X);
  RIRegister_StMime(X);  //*)
  RIRegister_StEclpse(X);
 (* RIRegister_StStrS_Routines(Exec);  *)
  RIRegister_StMerge(X);
  RIRegister_StTree(X);
  RIRegister_StVArr(X); // *)
  RIRegister_StRegIni(X);   //*)
  RIRegister_usvd_Routines(Exec);    //*)
  RIRegister_DepWalkUtils_Routines(Exec);
 RIRegister_OptionsFrm(X);
  RIRegister_yuvconverts_Routines(Exec);
  RIRegister_JvPropAutoSave(X);
  //RIRegister_AclAPI_Routines(Exec);  *)
  RIRegister_AviCap_Routines(Exec);  //  *)
  //RIRegister_ALAVLBinaryTree(X);  //*)
  //RIRegister_ALStringList(X);
  RIRegister_ALQuickSortList(X);  //*)
  RIRegister_ALFcnMisc_Routines(EXec);
  RIRegister_ALStaticText(X);   //Res dcr files
  RIRegister_ALJSONDoc_Routines(Exec);   //*)
  RIRegister_ALGSMComm_Routines(eXec);
  RIRegister_ALGSMComm(X);   //*)
  RIRegister_ALWindows_Routines(Exec);
  RIRegister_ALMultiPartBaseParser(X);
  RIRegister_ALMultiPartBaseParser_Routines(Exec);
  RIRegister_ALMultiPartAlternativeParser(X);
  RIRegister_ALMultiPartFormDataParser(X);      //*)
  RIRegister_ALHttpCommon(X);
  RIRegister_ALHttpCommon_Routines(Exec);
  RIRegister_ALWebSpider(X);
  RIRegister_TAlTrivialWebSpider_Routines(Exec);    //4.7.1.82   *)
  RIRegister_ALHttpClient(X);
  RIRegister_ALFTPClient(X);
 RIRegister_ALInternetMessageCommon(X);
  RIRegister_ALInternetMessageCommon_Routines(Exec);
  RIRegister_ALWininetHttpClient(X);
  RIRegister_ALWinInetFTPClient(X);  //*)
  RIRegister_ALWinHttpWrapper_Routines(eXec);
  RIRegister_ALWinHttpClient(X);
  RIRegister_ALFcnSQL(X);
  RIRegister_ALFcnWinSock_Routines(Exec);   //*)
  RIRegister_ALFcnHTML_Routines(Exec);
  RIRegister_ALIsapiHTTP_Routines(Exec);
  RIRegister_ALIsapiHTTP(X);

  RIRegister_ALFcnCGI_Routines(Exec); // 5.1.4.98 V* *)
  RIRegister_ALFcnExecute_Routines(Exec);
  RIRegister_ALFcnFile_Routines(Exec);
  RIRegister_ALFcnMime_Routines(Exec);
  RIRegister_ALPhpRunner(X);    //*)
  RIRegister_ALGraphic_Routines(Exec);
  RIRegister_ALIniFiles(X);
  RIRegister_ALMemCachedClient(X); //3.9.9.84  *)
  RIRegister_ALMultiPartMixedParser(X);
 (* RIRegister_ALSMTPClient(X);
  RIRegister_ALNNTPClient(X);  *)
  RIRegister_ALHttpClient2(X);
  RIRegister_ALHttpClient2_Routines(Exec);        //V47610 IX
  RIRegister_ALWininetHttpClient2(X);

  RIRegister_ALHintBalloon(X); //*)
  RIRegister_ALXmlDoc(X);
  RIRegister_ALXmlDoc_Routines(Exec);
  RIRegister_IPCThrd_Routines(Exec);
  RIRegister_IPCThrd(X);
  RIRegister_MonForm(X);  //3.9.9.84
  RIRegister_ovcmisc_Routines(Exec);
  RIRegister_ovcfiler(X);
  RIRegister_ovcfiler_Routines(Exec);
  RIRegister_ovcstate(X);
  RIRegister_ovcstate_Routines(Exec);
  RIRegister_ovccoco(X);
  RIRegister_ovccoco_Routines(Exec);
  RIRegister_ovcrvexp(X);
  RIRegister_OvcFormatSettings_Routines(Exec);
  RIRegister_ovcstore(X);
  RIRegister_ovcstr_Routines(Exec);
  RIRegister_ovcmru(X);
  RIRegister_ovccmd(X);
  RIRegister_ovctimer(X);
  RIRegister_ovcintl(X);  //*)
  RIRegister_AfCircularBuffer(X);
  RIRegister_AfSafeSync_Routines(Exec);  //*)
  RIRegister_AfUtils_Routines(Exec);
  RIRegister_AfDataDispatcher(X);
  RIRegister_AfComPortCore(X);
  RIRegister_AfComPort(X);
  RIRegister_AfComPortCore_Routines(Exec);
  RIRegister_AfPortControls(X);  //*)
  RIRegister_AfViewers(X);
  RIRegister_AfDataTerminal(X);
  RIRegister_SimplePortMain(X);
  RIRegister_ovcclock(x);
  RIRegister_o32intlst(x);
  RIRegister_o32ledlabel(X);
  RIRegister_AlMySqlClient(X);
  RIRegister_AlMySqlClient_Routines(Exec); // V5.1.4.98 V *)
  RIRegister_ALFBXClient(X);
  //RIRegister_ALFcnSQL(X);   redeclare*)
  RIRegister_AsyncTimer(X);  //*)
  RIRegister_ApplicationFileIO(X);
  RIRegister_ApplicationFileIO_Routines(Exec);
  RIRegister_PsAPI_Routines(Exec);  //*)
  RIRegister_ovcurl(X);
  RIRegister_ovcuser(X);
 (* RIRegister_ovcvlb(X);   *)
  RIRegister_ovccolor(X);
  RIRegister_ALFBXLib(X);
  RIRegister_ALFBXLib_Routines(Exec);      //*)
  RIRegister_ovcmeter(X);
  RIRegister_ovcpeakm(X);
  RIRegister_ovcBidi_Routines(EXec);
  RIRegister_ovctcary(X);
RIRegister_DXPUtils_Routines(Exec);
(*  RIRegister_ALPOP3Client(X);   *)
  RIRegister_SmallUtils_Routines(Exec);
  RIRegister_MakeApp_Routines(Exec);   //*)
  RIRegister_O32MouseMon_Routines(Exec);
  RIRegister_OvcCache(X);
  RIRegister_ovccalc(X);
 (* RIRegister_Joystick(X);  *)
  RIRegister_ScreenSaver(X);
  RIRegister_ScreenSaver_Routines(Exec);
  RIRegister_Polynomials_Routines(Exec);
  RIRegister_XCollection(X);
  RIRegister_XCollection_Routines(Exec);    // *)
  RIRegister_PersistentClasses(X);
RIRegister_DSUtil_Routines(Exec);
  RIRegister_XOpenGL_Routines(Exec);  //*)
  RIRegister_VectorLists_Routines(Exec);
  RIRegister_VectorLists(X);
  RIRegister_MeshUtils_Routines(Exec);  //*)
  RIRegister_JclSysUtils(X);
  RIRegister_JclSysUtils_Routines(Exec);
  RIRegister_JclBorlandTools(X);
  RIRegister_JclBorlandTools_Routines(Exec); //3.9.9.86   *)
  RIRegister_JclFileUtils_max_Routines(Exec);
  RIRegister_JclFileUtils_max(X);   //*)
  RIRegister_AfDataControls(X);
  RIRegister_GLSilhouette(X);  // *)
  RIRegister_changefind(X);
  RIRegister_cmdIntf(X);   //*)
  RIRegister_Keyboard_Routines(Exec);
  RIRegister_VRMLParser(X);
  RIRegister_GLFileVRML(X); //*)
  RIRegister_Octree(X);    //*)
   RIRegister_GLCrossPlatform_Routines(eXec);
   RIRegister_GLPolyhedron(X);
   RIRegister_GLParticles(X); //*)
  RIRegister_GLNavigator(X);
  RIRegister_GLStarRecord_Routines(eXec);  //*)
  RIRegister_GLCanvas(X);    //*)
  RIRegister_GeometryBB_Routines(eXec);
  RIRegister_GeometryCoordinates_Routines(eXec);
  RIRegister_VectorGeometry_Routines(Exec);  //*)
  RIRegister_unitCharsetMap_Routines(Exec);
  RIRegister_unitCharsetMap(X);
  RIRegister_JclCharsets_Routines(Exec);
  RIRegister_JclCharsets(X);
  RIRegister_XnClasses(X);
  RIRegister_GLScriptPython(X);
  RIRegister_TGA(X);
 (* RIRegister_GLVectorFileObjects_Routines(Exec);
  RIRegister_GLVectorFileObjects(X);   //3.9.9.88     *)
  RIRegister_ButtonGroup(X);
  RIRegister_CategoryButtons(X);
 //RIRegister_DbExcept(X);  *)
  RIRegister_AxCtrls(X);
  RIRegister_gl_actorUnit1(X);  //3.9.9.88    *)
  RIRegister_AxCtrls_Routines(Exec);
 RIRegister_DataAwareMain(X);
  RIRegister_TabNotBk(X);
  RIRegister_udwsfiler(X); //*)
  RIRegister_synaip_Routines(Exec);
  RIRegister_synacode_Routines(Exec);
  RIRegister_synachar_Routines(Exec);  //*)
  RIRegister_synamisc_Routines(Exec); // comment it if no routines
  RIRegister_synaser(X);
  RIRegister_synaser_Routines(Exec);   //*)
  RIRegister_synaicnv_Routines(Exec);
  RIRegister_blcksock(X);
  RIRegister_tlntsend(X);
 RIRegister_pingsend_Routines(Exec);
  RIRegister_pingsend(X);  //*)
  RIRegister_asn1util_Routines(exec);
 RIRegister_dnssend(X);
  RIRegister_dnssend_Routines(Exec);
  RIRegister_ldapsend(X);
  RIRegister_clamsend(X);
  RIRegister_ldapsend_Routines(Exec);     //*)
  RIRegister_slogsend(X);
  RIRegister_mimemess(X);
  RIRegister_slogsend_Routines(Exec);
  RIRegister_mimepart(X);
  RIRegister_mimepart_Routines(Exec);  //*)
  RIRegister_mimeinln_Routines(Exec);  //*)
  RIRegister_ftpsend(X);
  RIRegister_ftptsend(X);  //*)
  RIRegister_httpsend(X);
 RIRegister_ftpsend_Routines(Exec);
  RIRegister_httpsend_Routines(Exec);
  RIRegister_sntpsend(X);
  RIRegister_snmpsend(X);
  RIRegister_snmpsend_Routines(Exec);
  RIRegister_smtpsend_Routines(Exec);
  RIRegister_smtpsend(X);    //3.9.9.91
  RIRegister_imapsend(X);
  RIRegister_pop3send(X);
  RIRegister_nntpsend(X);
  //RIRegister_ssl_openssl(X); //3.9.9.91     *)
  RIRegister_synhttp_daemon(X);
  RIRegister_PingThread(X);
  RIRegister_JvThreadTimer(X);
  RIRegister_NetWork_Routines(EXec); //*)
  RIRegister_wwSystem_Routines(Exec);
  RIRegister_IdComponent(X);    //Indy 10
  RIRegister_IdIOHandlerThrottle(X);  //*)
  RIRegister_Themes(X);
  RIRegister_StdStyleActnCtrls(X);
  RIRegister_Themes_Routines(Exec);
  RIRegister_UDDIHelper_Routines(EXec);
 // RIRegister_IdIMAP4Server(X);
  RIRegister_VariantSymbolTable(X);  //*)
  RIRegister_udf_glob(X);
  RIRegister_TabGrid(X);
  RIRegister_udf_glob_Routines(Exec);
  RIRegister_JsDBTreeView(X);
  RIRegister_JsSendMail(X);         //3.9.9.92     *)
  RIRegister_Wwstr_Routines(exec);
 (* RIRegister_dblookup(X);
  RIRegister_dbTvRecordList(X);  *)
  RIRegister_TreeVwEx(X);
 (* RIRegister_ECDataLink(X);
  RIRegister_dbTree(X);
  RIRegister_dbTreeCBox(X);     *)
  RIRegister_Debug(X);
 (* RIRegister_FileIntf(X);
  RIRegister_SockTransport(X);
  RIRegister_SockTransport_Routines(Exec);   *)
  RIRegister_WinInet_Routines(Exec);
 (* RIRegister_Printgri(X);   *)
  RIRegister_Hotspot(X);
  RIRegister_HList(X);
 (* RIRegister_TConnect(X);
  RIRegister_DataBkr(X);
  RIRegister_DrTable(X);
  RIRegister_DataBkr_Routines(Exec);  *)
  RIRegister_HTTPIntr(X);
  RIRegister_HTTPIntr_Routines(Exec);   //3.9.9.94
  RIRegister_Mathbox_Routines(Exec);    //*)
  RIRegister_UrlMon_Routines(Exec);
  RIRegister_cyIndy_Routines(Exec);
  RIRegister_cySysUtils_Routines(Exec);
  RIRegister_cyWinUtils_Routines(Exec);
  RIRegister_cyStrUtils_Routines(Exec);
  RIRegister_cyDateUtils_Routines(Exec);
  RIRegister_cyObjUtils_Routines(Exec);
 (* RIRegister_cyBDE_Routines(Exec);   *)
  RIRegister_cyClasses(X);
  RIRegister_cyClasses_Routines(Exec);
  RIRegister_cyGraphics_Routines(Exec);
  RIRegister_JvDateTimePicker(X);
  RIRegister_JvEasterEgg(X);
  RIRegister_JvCreateProcess(X);   //*)
  RIRegister_JvDatePickerEdit(X);
  RIRegister_WinSvc_Routines(Exec);
  RIRegister_WinSvc2_Routines(Exec);  // *)

  RIRegister_SvcMgr(X);
  RIRegister_JvPickDate_Routines(Exec);
  RIRegister_JvStrHlder(X);
 (* RIRegister_JvNotify(X);
  RIRegister_JvNotify_Routines(Exec);
  RIRegister_JclNTFS2_Routines(Exec);    *)
  RIRegister_Jcl8087_Routines(Exec);
  RIRegister_JvAddPrinter(X);
  RIRegister_JvCabFile(X);      //3.9.9.94_3    *)
  RIRegister_JvDataEmbedded(X);
  RIRegister_U_HexView(X);
  RIRegister_UWavein4(X);
  RIRegister_AMixer(X);
  RIRegister_JvArrow(X);
  RIRegister_JvaScrollText(X);
  RIRegister_U_Oscilloscope4(X); // *)
  RIRegister_DFFUtils_Routines(Exec);
  RIRegister_TPrimes(X);     //*)
  RIRegister_MathsLib_Routines(Exec);
  RIRegister_UGetParens_Routines(Exec);
  RIRegister_UIntList(X);
  RIRegister_UGeometry_Routines(EXec);
  RIRegister_UAstronomy(X);
  RIRegister_UAstronomy_Routines(Exec);  //3.9.9.95_1
  RIRegister_USolarSystem_Routines(Exec);  //*)
  RIRegister_UCardComponentV2(X);
  RIRegister_UTGraphSearch(X);
  RIRegister_UParser10(X);
  RIRegister_cyIEUtils_Routines(Exec);
  RIRegister_UcomboV2(X);           //3.9.9.96
  RIRegister_cyBaseComm(X);
  RIRegister_cyBaseComm_Routines(Exec);
  RIRegister_cyAppInstances(X);
  RIRegister_cyAttract(X);
  RIRegister_cyDERUtils_Routines(eXec);
  RIRegister_cyDocER(X);
  RIRegister_ODBC(X);
  RIRegister_AssocExec(X);
  RIRegister_cyBaseCommRoomConnector(X);
  RIRegister_cyCommRoomConnector(X);  //*)
  RIRegister_cyCommunicate(X);
  RIRegister_cyImage_Routines(eXec);
  RIRegister_cyBaseContainer(X);
  RIRegister_cyModalContainer(X);
  RIRegister_cyModalContainer_Routines(Exec);
  RIRegister_cyFlyingContainer(X);   //*)
  RIRegister_cyIniForm(X);
  RIRegister_cyVirtualGrid(X);
  RIRegister_Profiler(X);
  RIRegister_BackgroundWorker(X); //*)
  RIRegister_WavePlay(X);
  RIRegister_WaveTimer(X);
  RIRegister_WaveUtils(X);     //3.9.9.96_3
  RIRegister_WaveUtils_Routines(Exec);
  RIRegister_NamedPipes(X);
  RIRegister_NamedPipes_Routines(Exec);
  RIRegister_NamedPipeServer(X); //*)
  RIRegister_process(X);
  RIRegister_DPUtils_Routines(Exec);
  RIRegister_DPUtils(X);
  RIRegister_CommonTools_Routines(Exec);
  RIRegister_CommonTools(X);
  RIRegister_DataSendToWeb(X);
  RIRegister_StarCalc(X);
  RIRegister_D2_VistaHelperU_Routines(Exec); //3.9.9.98
 RIRegister_pipes_Routines(Exec);
  RIRegister_pipes(X);  //*)
  RIRegister_ProcessUnit(X);
  RIRegister_adgsm_Routines(Exec);
 RIRegister_BetterADODataSet_Routines(Exec);
  RIRegister_BetterADODataSet(X);  //*)
  RIRegister_AdSelCom_Routines(Exec);
  RIRegister_AdSelCom(X);       //*)
  RIRegister_dwsXPlatform_Routines(Exec);
  RIRegister_dwsXPlatform(X);
  RIRegister_AdSocket(X);
  RIRegister_AdPacket(X);
  RIRegister_AdPort(X);
  RIRegister_AdPort_Routines(Exec);
  RIRegister_PathFunc_Routines(Exec);
  RIRegister_CmnFunc2_Routines(Exec);
  RIRegister_CmnFunc2(X);
  RIRegister_CmnFunc_Routines(Exec);
  RIRegister_CmnFunc(X);   //3.9.9.98_2
  RIRegister_BitmapImage(X);
  RIRegister_ImageGrabber(X);
  RIRegister_RedirFunc_Routines(Exec);
  RIRegister_TFileRedir(X);
  RIRegister_SecurityFunc_Routines(Exec);
  RIRegister_FIFO(X);
  //RIRegister_Int64Em_Routines(EXec);
  RIRegister_InstFunc(X);
  RIRegister_InstFunc_Routines(Exec);
  RIRegister_ScriptFunc_R_Routines(Exec);
 RIRegister_LibFusion_Routines(Exec);
  RIRegister_LibFusion(X);   //*)
  RIRegister_SimpleExpression(X);
  RIRegister_unitResourceDetails(X);
  RIRegister_unitResFile(X);
  RIRegister_unitResourceDetails_Routines(Exec);   // *)
  RIRegister_simplecomport(X);          //3.9.9.98
  RIRegister_Console_Routines(Exec);
  RIRegister_AnalogMeter(X);
  RIRegister_XPrinter(X);
  RIRegister_lazIniFiles(X);  //*)
  RIRegister_testutils(X);
  RIRegister_ToolsUnit_Routines(Exec);
  RIRegister_ToolsUnit(X);  //*)
  RIRegister_fpcunit_Routines(Exec);
  RIRegister_fpcunit(X);
  RIRegister_fpcunittests(X);
  RIRegister_testdecorator(X);
  RIRegister_cTCPBuffer_Routines(Exec);
  RIRegister_cTCPBuffer(X); //*)
  RIRegister_Glut_Routines(Exec);      //*)
  RIRegister_LEDBitmaps_Routines(Exec);
  RIRegister_FileClass(X);
  RIRegister_FileUtilsClass(X);
  RIRegister_ComPortInterface(X);
  RIRegister_SwitchLed(X);
  RIRegister_cyDmmCanvas(X);
  RIRegister_uColorFunctions_Routines(EXec);    //*)
  RIRegister_uSettings_Routines(EXec);
  RIRegister_cyDebug(X);
  RIRegister_cyBaseColorMatrix(X);
  RIRegister_cyColorMatrix(X);
  RIRegister_cySearchFiles_Routines(Exec);
  RIRegister_cySearchFiles(X);
  RIRegister_cyCopyFiles(X);
  RIRegister_cyCopyFiles_Routines(Exec);
  RIRegister_cyBaseMeasure(X);
 (* RIRegister_PJIStreams(X);     *)
  RIRegister_cyRunTimeResize(X);
  RIRegister_jcontrolutils_Routines(Exec);
  RIRegister_kcMapViewer(X);
  RIRegister_kcMapViewerGLGeoNames(X);
  RIRegister_kcMapViewerDESynapse(X); //*)
  RIRegister_TLineBreaker(X);  //*)
  RIRegister_cparserutils_Routines(Exec); //3.9.9.98_7   *)
  RIRegister_uCommonFunctions_Routines(Exec);
  RIRegister_LedNumber(X);
 RIRegister_StStrL_Routines(EXec);
  RIRegister_indGnouMeter(X);  //*)
  RIRegister_Sensors(X);      //*)
  RIRegister_pwnative_out_Routines(Exec);
  RIRegister_HTMLUtil_Routines(Exec);
  RIRegister_synwrap1_Routines(Exec);
  RIRegister_pwmain_Routines(Exec);
 (* RIRegister_W32VersionInfo_Routines(Exec);
  RIRegister_W32VersionInfo(X);   *)
  RIRegister_IpAnim(X);  //*)
  RIRegister_IpUtils(X);
  RIRegister_IpUtils_Routines(Exec);
  RIRegister_LrtPoTools_Routines(Exec);
  RIRegister_Laz_DOM(X);
  RIRegister_hhAvComp(X);
  RIRegister_hhAvComp_Routines(Exec);    //*)
  RIRegister_GPS2(X);
  RIRegister_GPS(X);  //redeclare ?
  RIRegister_GPS_Routines(Exec);
  //RIRegister_GPSUDemo(X);    *)
  RIRegister_IsNavUtils2_Routines(Exec);
  RIRegister_IsNavUtils2(X);                 //V5.1.4.80
  RIRegister_NMEA_Routines(Exec); //3.9.9.101
  RIRegister_ScreenThreeDLab(X);  //*)
  RIRegister_Spin(X);
  RIRegister_DynaZip(X);  //*)
  RIRegister_clockExpert(X);   //*)
  RIRegister_BitmapConversion_Routines(Exec);
  RIRegister_SortUtils_Routines(Exec);
  RIRegister_JclTD32(X);  //*)
  RIRegister_ZDbcUtils_Routines(EXec);
  RIRegister_ZScriptParser(X);
  RIRegister_JvFtpGrabber(X); //*)
  RIRegister_JvIni(X);
  RIRegister_JvIni_Routines(Exec);  //*)
  RIRegister_NeuralNetwork(X);
  RIRegister_neuralnetwork_Routines(Exec);
  RIRegister_neuralnetworkCAI(X);
  RIRegister_neuralfit(X);
  RIRegister_neuralfit_Routines(Exec);
  RIRegister_neuraldatasets(X);
  RIRegister_neuraldatasets_Routines(Exec);
  //RIRegister_neuraldatasetsv(X);
  RIRegister_neuraldatasetsv_Routines(Exec);
  RIRegister_flcFloats_Routines(Exec);
  RIRegister_CustApp(X);
  RIRegister_neuralgeneric(X);
  //uPSI_neuralthread,
 RIRegister_neuralthread(X);
  RIRegister_neuralgeneric_Routines(Exec);
  RIRegister_neuralthread_Routines(Exec);

  RIRegister_uWinNT_Routines(Exec);
  RIRegister_URungeKutta4_Routines(Exec);
 RIRegister_OverbyteIcsUtils(X);
  RIRegister_OverbyteIcsUtils_Routines(Exec);
  //RIRegister_SimpleSFTP(X);
  RIRegister_SeSHA256_Routines(Exec);
  RIRegister_BlocksUnit(X);  //*)
  RIRegister_DelticsCommandLine_Routines(Exec);
  RIRegister_DelticsCommandLine(X);
  RIRegister_DelticsStrUtils(X);
  RIRegister_DelticsStrUtils_Routines(Exec);
  RIRegister_DelticsBitField(X);     //*)
  RIRegister_DelticsSysUtils_Routines(Exec);
  RIRegister_DelticsSysUtils(X);                //4.7.6.10 III
  RIRegister_U_Splines(X);
  RIRegister_U_CoasterB(X);
  RIRegister_MARSCoreUtils_Routines(Exec);  //*)
  RIRegister_clJsonParser(X);
  RIRegister_clJsonSerializerBase(X);
  RIRegister_SynHighlighterPython(X);  // *)
  RIRegister_DudsCommonDelphi_Routines(Exec);
  RIRegister_AINNNeuron(X);    // *)
  RIRegister_uHTMLBuilder(X);
  RIRegister_WinApiDownload(X);
  RIRegister_pxQRcode_Routines(Exec);   //*)
  RIRegister_DelphiZXingQRCode(X);
  RIRegister_RestJsonUtils_Routines(Exec);
  RIRegister_RestJsonUtils(X);  //*)
  RIRegister_KLibUtils_Routines(Exec);   //VIII
  RIRegister_KLibWindows_Routines(Exec);
  RIRegister_AzuliaUtils_Routines(Exec);
  RIRegister_AzuliaUtils(X); //*)
  RIRegister_RestUtils(X);
  RIRegister_PSResources(X);
  RIRegister_PSResources_Routines(Exec);
  RIRegister_HttpConnection(X);
  RIRegister_HttpConnectionWinInet(X);
   RIRegister_HTTPSender(X);
  RIRegister_RestClient(X);
  RIRegister_OpenApiUtils_Routines(Exec);
 RIRegister_Pas2jsFileUtils_Routines(Exec);   //the real shit to found for 4hrs!
  RIRegister_NovusUtilities(X);
  RIRegister_NovusUtilities_Routines(Exec);
  RIRegister_NovusStringUtils(X);
  RIRegister_NovusWindows(X);
  RIRegister_NovusNumUtils(X);
  RIRegister_NovusWebUtils(X);

  RIRegister_StExpr(X);
  RIRegister_StExpr_Routines(Exec);
 (* RIRegister_GR32_Geometry_Routines(Exec);
  RIRegister_GR32_Containers(X);
  RIRegister_GR32_Containers_Routines(Exec);
  RIRegister_GR32_Backends_VCL(X);    *)
  RIRegister_StSaturn_Routines(Exec);
  RIRegister_JclParseUses(X);
  RIRegister_JclParseUses_Routines(Exec);
  RIRegister_JvFinalize_Routines(Exec);  //3.9.9.120
  RIRegister_panUnit1(X);   //*)
  RIRegister_DD83u1(X);   //*)
  RIRegister_BigIni(X);
  RIRegister_BigIni_Routines(Exec);   //*)
  RIRegister_ShellCtrls(X);
  RIRegister_ShellCtrls_Routines(Exec);
  RIRegister_fmath_Routines(Exec);
  RIRegister_fcomp_Routines(Exec);
  RIRegister_HighResTimer(X);
  RIRegister_uconvMain(X);       // *)
  RIRegister_ParserUtils_Routines(Exec);
  RIRegister_uPSUtils_Routines(Exec);
  RIRegister_uPSUtils(X);
  RIRegister_ParserU(X);
  //RIRegister_TypInfo_Routines(Exec); //last
  RIRegister_ServiceMgr(X);
  RIRegister_UDict(X);
  RIRegister_UDict2(X);
  RIRegister_ubigFloatV3(X);
  RIRegister_UBigIntsV4(X);
  RIRegister_UBigIntsV4_Routines(Exec);  //last 180
  RIRegister_UP10Build_Routines(Exec);
  RIRegister_IdModBusServer(X); //*)
  RIRegister_IdModBusClient(X);   //*)
  RIRegister_ModbusUtils_Routines(Exec);
  RIRegister_ColorGrd(X);
  RIRegister_DirOutln(X);
  RIRegister_Gauges(X);
  RIRegister_DirOutln_Routines(Exec);
  RIRegister_ActnMan(X);
  RIRegister_ActnMan_Routines(Exec);
  RIRegister_CustomizeDlg(X);
  RIRegister_CollPanl(X);
 (* RIRegister_IBCtrls(X);  *)
  RIRegister_IdStackWindows(X);  //*)
  RIRegister_VendorTestFramework(X);
  RIRegister_CTSVendorUtils(X);   //last 180_3
  RIRegister_JvAnimate(X);
  RIRegister_DBXCharDecoder(X);
 // RIRegister_JvDBLists(X);   *)
  RIRegister_JvFileInfo(X);
  RIRegister_SOAPConn(X);
  RIRegister_SOAPLinked(X);  //*)
  RIRegister_XSBuiltIns(X);
  RIRegister_XSBuiltIns_Routines(Exec);  //last 190    *)
  RIRegister_JvgDigits(X);
  RIRegister_JvDesignUtils_Routines(eXec);
  RIRegister_JvgCrossTable(X);
  RIRegister_JvgReport(X);
  RIRegister_JvDBRichEdit(X); //3.9.9.190
  RIRegister_JvWinHelp(X);
  RIRegister_WaveConverter(X);
  RIRegister_ACMConvertor(X);  //*)
  RIRegister_ComObj2(X);        //uPSI_ComObjOleDB_utils
  RIRegister_ComObj2_Routines(Exec);   //*)
  RIRegister_SMScript(X);
  RIRegister_CompFileIo_Routines(Exec);
 (* RIRegister_SynHighlighterGeneral(X);   *)
  RIRegister_geometry_Routines2(Exec);  //!  *)
  RIRegister_MConnect(X);
  RIRegister_ObjBrkr(X);
  RIRegister_MConnect_Routines(Exec);   //*)
  RIRegister_uMultiStr(X);
 (* RIRegister_JvAVICapture(X);  *)
  RIRegister_JvExceptionForm(X);
  RIRegister_JvConnectNetwork(X);
  RIRegister_JvExceptionForm_Routines(Exec); //*)
  RIRegister_MTMainForm(X);
  RIRegister_DdeMan(X);
  RIRegister_DdeMan_Routines(Exec); //*)
  RIRegister_DIUtils(X);
  RIRegister_DIUtils_Routines(Exec);
 (* RIRegister_gnugettext_Routines(Exec);
  RIRegister_TGnuGettextInstance(X);   //3.9.9.195     *)
  RIRegister_Xmlxform(X);
  RIRegister_Xmlxform_Routines(Exec);
(* RIRegister_SvrHTTPIndy(X);
  RIRegister_SvrHTTPIndy_Routines(Exec);  *)
  RIRegister_CPortTrmSet(X);
  RIRegister_CPortTrmSet_Routines(Exec); //3.9.9.195
  RIRegister_TIntervalList(X);   //single class of TAChartutils
  RIRegister_TAChartUtils_Routines(Exec);
  RIRegister_HTTPProd(X);                      //V4
  RIRegister_HTTPProd_Routines(Exec);
 (* RIRegister_SockHTTP(X);
  RIRegister_IndySockTransport(X);     *)
  RIRegister_synacrypt(X);
  RIRegister_synacrypt_Routines(Exec);
  RIRegister_CppParser(X);
  RIRegister_CodeCompletion(X);
  RIRegister_U_IntList2(X);
 // RIRegister_SockAppNotify(X);
 // RIRegister_NSToIS_Routines(Exec);
  //RIRegister_NSToIS(X);
  RIRegister_DBOleCtl(X);
  //RIRegister_xercesxmldom(X);  *)
  RIRegister_xmldom(X);
  RIRegister_xmldom_Routines(Exec);  // *)
  RIRegister_JclExprEval(X);   //*)
  RIRegister_Gameboard(X);
  RIRegister_Gameboard_Routines(Exec);  // *)

  RIRegister_ExtPascal(X);
  RIRegister_ExtUtil(X);
  RIRegister_FCGIApp(X);
  RIRegister_PersistSettings_Routines(Exec);
  RIRegister_PersistSettings(X);
  RIRegister_SynEditAutoComplete(X);
  //RIRegister_SynEditTextBuffer(X);
  RIRegister_JclPCRE(X);
  RIRegister_JclPCRE_Routines(Exec);   // *)
  RIRegister_JclPCRE2(X);
  RIRegister_JclPCRE2_Routines(Exec);   // *)
  RIRegister_GpTimezone(X);
  RIRegister_GpTimezone_Routines(Exec);

  RIRegister_ChessBrd(X);
  RIRegister_ChessPrg(X);    //Form
   RIRegister_Graph3D(X);
  RIRegister_Graph3D_Routines(Exec);  //*)
  RIRegister_SysInfoCtrls(X); //*)
  RIRegister_StdFuncs(X);  //  *)
  RIRegister_StdFuncs_Routines(Exec);
  RIRegister_RegUtils_Routines(Exec);
  RIRegister_VariantRtn_Routines(Exec);
  RIRegister_SqlTxtRtns_Routines(Exec); //*)
  RIRegister_BSpectrum(X);
 RIRegister_IPAddressControl(X);
  RIRegister_Paradox(X);
  RIRegister_Paradox_Routines(Exec);   //*)
  RIRegister_Environ(X);
  RIRegister_GraphicsPrimitivesLibrary(X);
  //SIRegister_DrawFigures(X);
  RIRegister_DrawFigures_Routines(Exec);
  RIRegister_synadbg(X);
  RIRegister_synadbg_Routines(Exec);  //*)
  RIRegister_xrtl_util_FileVersion(X);
  RIRegister_Streams(X);
  RIRegister_Streams_Routines(Exec);
  RIRegister_BitStream(X);
  RIRegister_XmlRpcTypes(X);
  RIRegister_XmlRpcCommon(X);
  RIRegister_XmlRpcCommon_Routines(Exec);
 (* RIRegister_XmlRpcClient(X);
  RIRegister_XmlRpcServer(X);
  RIRegister_SynAutoIndent(X);         //4.0.2.60    *)
  RIRegister_synafpc_Routines(Exec);
  RIRegister_RxNotify(X);
  RIRegister_RxNotify_Routines(Exec);
  RIRegister_SynAutoCorrect(X);
  RIRegister_rxOle2Auto(X);
  RIRegister_rxOle2Auto_Routines(Exec);   //*)
  RIRegister_Spring_Utilsmx(X);
  RIRegister_Spring_Utilsmx_Routines(Exec);
  RIRegister_HarmFade(X);
  RIRegister_ulogifit_Routines(Exec);
  RIRegister_SynCompletionProposal(X);
  RIRegister_SynCompletionProposal_Routines(Exec);
  RIRegister_rxAniFile(X);  //*)
  RIRegister_ulinfit_Routines(Exec);
  RIRegister_JclStringLists_Routines(Exec);
  RIRegister_JclStringLists(X);
  //RIRegister_ZLib(X);              *)
  //RIRegister_ZLib_Routines(Exec);
  RIRegister_MaxTokenizers(X);
  RIRegister_MaxUtils_Routines(eXec);
  RIRegister_MaxStrUtils_Routines(eXec);
  RIRegister_MaxXMLUtils_Routines(eXec);    //64 units
  RIRegister_VListBox(X);
 (* RIRegister_TNode(X);             //change namespace
  RIRegister_TAttribute(X);   *)
  RIRegister_MaxDOM_Routines(Exec);
  RIRegister_MaxDOMDictionary(X);
  RIRegister_MaxDOMDictionary_Routines(Exec);  //*)
  RIRegister_cASN1(X);
  RIRegister_cASN1_Routines(Exec);
  RIRegister_cX509Certificate_Routines(Exec);
  RIRegister_cX509Certificate(X);
  RIRegister_uCiaXml(X);   //*)
  RIRegister_StringsW(X);
  RIRegister_FileStreamW(X);
  RIRegister_FileStreamW_Routines(Exec);
  RIRegister_InetUtils(X);
  RIRegister_InetUtils_Routines(Exec);
  RIRegister_FileMask(X);
  RIRegister_StrConv_Routines(Exec);
  RIRegister_Simpat(X);
  RIRegister_Tooltips(X);  //*)
  RIRegister_StringGridLibrary_Routines(exec);
  RIRegister_ChronCheck(X);
  RIRegister_REXX_Routines(exec);
  RIRegister_SysImg(X);
  RIRegister_SysImg_Routines(exec);
  RIRegister_Tokens(X);    //*)
  RIRegister_KFunctions_Routines(Exec);
  RIRegister_KMessageBox_Routines(Exec);
 RIRegister_NamedPipeThreads(X);
  RIRegister_NamedPipesImpl(X);
  RIRegister_KLog(X);
  RIRegister_NamedPipesImpl_Routines(Exec);
  RIRegister_MapFiles(X);
  RIRegister_BKPwdGen(X);    //*)
  RIRegister_Kronos(X);             //4.2.2.90
  RIRegister_TokenLibrary2(X);
  RIRegister_KDialogs(X);
  RIRegister_NumEdit(X);
  RIRegister_KGraphics(X);
  RIRegister_umaxPipes(X);
  RIRegister_KGraphics_Routines(EXEC); //4.2.2.90 OII
  RIRegister_KControls(X);
  RIRegister_KControls_Routines(Exec);
  RIRegister_IdAntiFreeze(X);
  RIRegister_IdLogStream(X);
  RIRegister_IdThreadSafe(X);
  //RIRegister_IdThreadMgr(X);
  RIRegister_IdAuthenticationManager(X); //*)
  RIRegister_OverbyteIcsConApp(X);  //*)
  RIRegister_KMemo(X);
  RIRegister_KMemo_Routines(Exec);
  //RIRegister_kmemofrm(X);
  RIRegister_OverbyteIcsTicks64_Routines(Exec);  //4.2.2.95
  RIRegister_OverbyteIcsSha1_Routines(Exec);   //*)
  //uPSI_KEditCommon.pas
  RIRegister_KEditCommon(X);
  RIRegister_KEditCommon_Routines(exec);
  RIRegister_UtilsMax4(X);
  RIRegister_UtilsMax4_Routines(Exec);
 (* RIRegister_IdNNTPServer(X);  *)
  RIRegister_UWANTUtils_Routines(Exec);
  RIRegister_OverbyteIcsAsn1Utils_Routines(Exec);  //*)
  RIRegister_wmiserv_Routines(Exec);
  RIRegister_WbemScripting_TLB(X);  //*)
  RIRegister_uJSON(X);
  RIRegister_RegSvrUtils_Routines(Exec);
  RIRegister_RegSvrUtils(X);
  RIRegister_osFileUtil_Routines(Exec); //4.2.4.60
   RIRegister_SHDocVw(X);
   RIRegister_ietf_Routines(Exec);   //*)
  RIRegister_xutils_Routines(Exec);
  RIRegister_dateutil_Routines(Exec);
  RIRegister_dateext4_Routines(Exec);
  RIRegister_locale_Routines(Exec);  //*)
    RIRegister_Strings_Routines(Exec);
  RIRegister_crc_Routines(Exec);   //*)
  RIRegister_extdos_Routines(Exec);
 (* RIRegister_uBild(x);  *)
  RIRegister_SimpleTCP(X);
  //RIRegister_IdFTPList(X); *)
  RIRegister_uTPLb_RSA_Engine(X);
  RIRegister_uTPLb_CryptographicLibrary(X);
  RIRegister_THugeInt(X);
  RIRegister_cHugeInt_Routines(Exec);
  // 4.2.5.10
(*  RIRegister_xBase(X);
  RIRegister_xBase_Routines(Exec);   *)
  RIRegister_ImageHistogram(X);
  RIRegister_ImageHistogram_Routines(Exec);
 (* RIRegister_WDosDrivers(X);   *)
  RIRegister_cCipherRSA_Routines(Exec);
  RIRegister_TStreamStorage(X);
  RIRegister_TNamesEnumerator(X);
  RIRegister_CromisStreams_Routines(Exec);
  RIRegister_uTPLb_BinaryUtils_Routines(Exec);    //*)
   RIRegister_USha256_Routines(Exec);  //*)
  RIRegister_UJSONFunctions(X);
  RIRegister_uTPLb_Hash(X);        //4.2.6.10
  RIRegister_UTime_Routines(Exec);
  RIRegister_uTPLb_Codec(X);    //4.2.8.10
  RIRegister_uTPLb_BlockCipher(X);
  RIRegister_ADOInt(X);
  RIRegister_XMLIntf(X);
 (* RIRegister_XMLDoc(X);
  RIRegister_XMLDoc_Routines(Exec);  *)
  RIRegister_MidasCon(X);
  RIRegister_xrtl_util_ValueImpl(X);  // *)
  RIRegister_ProxyUtils_Routines(Exec);
  RIRegister_OmniXMLUtils_Routines(Exec); //type real to test*)
  RIRegister_uWebUIMiscFunctions_Routines(Exec);

  RIRegister_DebugBox(X); //*)
  RIRegister_HotLog(X);
  RIRegister_HotLog_Routines(Exec);

  RIRegister_ustrings_Routines(Exec);
 RIRegister_uregtest_Routines(Exec);
  RIRegister_usimplex_Routines(Exec);
  RIRegister_uhyper_Routines(Exec);
  RIRegister_unlfit_Routines(Exec);
 (* RIRegister_IdHL7(X);  *)
  RIRegister_IdIPMCastBase(X);
  RIRegister_IdIPMCastServer(X);
  RIRegister_IdIPMCastClient(X);   //*)
  //RIRegister_IdRawHeaders(X);
  RIRegister_IdRawClient(X);
  RIRegister_IdRawFunctions_Routines(Exec);
  RIRegister_IdTCPStream(X);
  RIRegister_IdSNPP(X);  //*)
  RIRegister_St2DBarC(X);
  RIRegister_FmxUtils_Routines(Exec);
  //RIRegister_SockApp(X);  *)
  RIRegister_CoolMain(X);    //*)
  RIRegister_StCRC_Routines(Exec);
 RIRegister_SynDBEdit(X);
  RIRegister_SynEditWildcardSearch(X);
  RIRegister_JvPcx(X);
 RIRegister_IdWhois(X);
(*  RIRegister_IdWhoIsServer(X); *)
  RIRegister_IdGopher(X); //*)
  RIRegister_IdDateTimeStamp(X);
  RIRegister_IdDiscardServer(X);
  RIRegister_IdDiscardUDPServer(X); //*)
  RIRegister_IdDICTServer(X);    //*)
  RIRegister_IdDayTimeUDPServer(X);
  RIRegister_IdDayTimeServer(X);   //*)
  RIRegister_IdDayTimeUDP(X);  //3.9.9.50
 RIRegister_IdQotdServer(X);
(*  RIRegister_IdGopherServer(X); *)
  RIRegister_JvRgbToHtml(X);
  RIRegister_JvRgbToHtml_Routines(Exec);
  RIRegister_JvSysComp(X);
  RIRegister_JvRemLog(X);
  RIRegister_JvTMTL(X);
  RIRegister_JvWinampApi(X);  //*)
  //RIRegister_XmlVerySimple(X);
  RIRegister_Services(X);  //*)
  RIRegister_JvForth(X);
  RIRegister_JvForth_Routines(Exec);
  //RIRegister_HttpRESTConnectionIndy(X);
  RIRegister_RestRequest(X);  //*)
 RIRegister_JvAppEvent(X);
  RIRegister_JvAppInst(X);  // *)
  RIRegister_JvAppCommand(X);
  RIRegister_JvAppCommand_Routines(Exec);
  RIRegister_JvAnimatedImage(X);
  RIRegister_JvAnimTitle(X);   //*)
  RIRegister_IdHash(X);    //*)
  RIRegister_IdHashCRC(X);
  RIRegister_IdHashMessageDigest(X);
  RIRegister_IdHashSHA1(X);
 RIRegister_IdLogFile(X);
  RIRegister_IdTime(X);
 RIRegister_IdDayTime(X);   //*)
  RIRegister_IdGlobal(X);
  RIRegister_IdGlobal_Routines(exec);
  RIRegister_IdEMailAddress(X);
  RIRegister_IdMessage(X);
  RIRegister_IdMessageClient(X);
 (* RIRegister_IdSMTP(X);
  RIRegister_IdPOP3(X);  *)
  RIRegister_IdMailBox(X);  // *)
  RIRegister_IdQotd(X);
  RIRegister_IdTelnet(X);
  RIRegister_IdNetworkCalculator(X);  //*)
  RIRegister_IdFinger(X);
  RIRegister_IdIcmpClient(X);  //*)
  RIRegister_IdUDPBase(X);
  RIRegister_IdUDPClient(X);  //*)
  RIRegister_IdTrivialFTPBase_Routines(Exec);
  RIRegister_IdTrivialFTP(X);    //*)
  RIRegister_LinarBitmap(X);
  RIRegister_LinarBitmap_Routines(Exec);
  RIRegister_PNGLoader(X);
  RIRegister_PNGLoader_Routines(Exec);  //*)
  RIRegister_IniFiles(X);
  RIRegister_IdThread(X); //*)
  RIRegister_fMain(X);           //reflection
 RIRegister_niSTRING_Routines(Exec);
  RIRegister_niSTRING(X);
  RIRegister_niRegularExpression(X);
  RIRegister_niExtendedRegularExpression(X);
  RIRegister_IdSNTP(X);  //*)
  RIRegister_cFileUtils_Routines(exec);
 // RIRegister_EFileError(X); *)
  RIRegister_ufft_Routines(Exec);
 // RIRegister_DBXChannel(X);
 // RIRegister_DBXIndyChannel(X);
  //RIRegister_ufft(X);    //*)
  RIRegister_cDateTime_Routines(Exec); // *)
  RIRegister_cDateTime(X);
  RIRegister_cTimers_Routines(Exec);
  RIRegister_cTimers(X);
  RIRegister_SysUtils(X);
  RIRegister_SysUtils_Routines(Exec);   //fallback resort!   *)
  RIRegister_ShellAPI_Routines(Exec);
  RIRegister_cFundamentUtils_Routines(Exec);     //*)
end;

function ExePath: string;
begin
  result:= ExtractFilePath(Forms.Application.ExeName)
end;

//unit IFSI_SysUtils_max;

function LoadTextFromFile(const FileName: string): string;
var
  SL: TStringList;
begin
  Result := '';
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function LoadFromFile(const FileName: string): string;
var
  SL: TStringList;
begin
  Result := '';
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

procedure SearchAndCopy(aStrList: TStrings; aSearchStr, aNewStr: string; offset: integer);
var i, t1: integer;
    s1: string;
begin
  // old string can't be part of new string!, eg.: max --> climax
  if pos(aSearchStr, aNewStr) > 0 then begin
    write('old string cant be part of new string');
    exit;
  end;
  for i:= 0 to aStrList.Count -1 do begin
    s1:= aStrList[i];
      t1:= pos(aSearchStr, s1);
      if t1 > 0 then begin
        Delete(s1, t1+offset-length(asearchstr), Length(aNewStr));
        Insert(aNewStr, s1, t1+offset);
        aStrList[i]:= s1;
      end;
  end;
end;

procedure searchAndOpenDoc(vfilenamepath: string);
var FileName: string;
begin
  if fileexists(vfilenamepath) then begin
    FileName:= vfilenamepath;
    ShellAPI.ShellExecute(HInstance, NIL, pchar(FileName), NIL, NIL, sw_ShowNormal);
  end else
    Showmessage('Sorry, filepath to '+vfilenamepath+' is missing')
    //MessageBox(0, pChar('Sorry, filepath to '+vfilenamepath+' is missing'),'maXbox Doc',MB_OKCANCEL);
end;

function IsFileOpen(const txtpath:string):Boolean;
var atxt: Textfile;
const
  fmTextOpenRead = 55217;
  fmTextOpenWrite = 55218;
begin
  AssignFile(atxt, txtpath);
  Result:= (TTextRec(atxt).Mode = fmTextOpenRead) or (TTextRec(atxt).Mode = fmTextOpenWrite)
end;

function IsFileInUse(fName: string) : boolean;
var
  HFileRes: HFILE;
begin
  Result:= False;
  if not FileExists(fName) then begin
    Exit;
  end;
  HFileRes:= CreateFile(PChar(fName)
    ,GENERIC_READ or GENERIC_WRITE
    ,0
    ,nil
    ,OPEN_EXISTING
    ,FILE_ATTRIBUTE_NORMAL
    ,0);
  Result:= (HFileRes = INVALID_HANDLE_VALUE);
  if not(Result) then begin
    CloseHandle(HFileRes);
  end;
end;

 function FileReallyIsInUse(fName: string): boolean;
var Stream: TFileStream;
begin
  result:= false;
  try
    try
      Stream:= TFileStream.Create(fName, fmcreate or fmShareDenyNone);  //fmCreate, fmShareExclusive);
      //Stream.Seek(0, soFromBeginning);  //  (resulting file was 0 bytes)
    except on E: EFOpenError do//    Exception do
      result:= true;
    end;
  finally
    Stream.Free;
  end;
end;


procedure Tmaxform1.FormCreate(Sender: TObject);
//var //Plugin: TPSPlugin;
//var    amark: TSynEditMark;
  var lm: integer;  m: string;   T0: int64;
begin
  self.Height:= 830;
  self.Width:= 950;
  STATEdchanged:= false;
  STATSavebefore:= true;    //2.8.1. once
  STATInclude:= false;   // mx42810
  STATExceptionLog:= true; //v3
  STATExecuteShell:= true; //v3   from IFSI_WinForm1puzzle!!
  STATDebugCheck:= true;            //V5.0.2
  STATformOutput:= false; //v3.5
  STATExecuteBoot:= true; //v38
  STATLastFile:= false; //v393
  STATMemoryReport:= false; //396
  STATMacro:= true;
  STATActiveyellow:= false;
  STATVersionCheck:= false;
  STATOtherHL:= false;
  fdebuginst:= false;
  fmemoclick:= false;
  STATAutoBookmark:= true;
   STATCodefolding:= true;        //new4

  //ActiveLineColor1Click(Self);
  //memo1.activeLineColor:= clmoneygreen;
  factivelinecolor:= clWebFloralWhite;
  memo1.Options:= memo1.Options + [eoDropFiles];
  //memo1.TabWidth:= 6;  //3.9.3
  memo1.TabWidth:= 3;  //3.9.8    //9.9.20
  dragAcceptFiles(maxForm1.Handle, True );    //fix5
  memo2.Lines.add('Welcode Coder: memo1 is editor 😎 - memo2 is console output ☘');
  //should  be a first help docu
  memo2.Height:= 175;
  memo2.WordWrap:= true;
  wordWrap1.Checked:= false;  // to be set cause folding & indent is on!
  //Plugin:= TPSImport_Winform1.create(self);
  //TPSPluginItem(psscript.plugins.add).plugin:= Plugin;
  //cedebug.Plugins:= psscript.Plugins.
  cedebug.OnCompile:= PSScriptCompile;
  cedebug.OnExecute:= cedebugExecute; //!! independent from main execute
  memo1.Options:= DefSynEditOptions;
  //memo1.gutter.BorderColor
  SynPasSyn1.FloatAttri.Foreground:= clWebTomato; //IndianRed; //clWebTomato; //cllime; //clAqua; //clWebDarkOrange;  //clTeal; //clnavy; //cllime;
  memo1.Highlighter:= SynPasSyn1;
  //SynPasSyn1.
  //should be a get highlight from extension
  memo1.Gutter.ShowLineNumbers:= true;
  //// draw word wrap glyphs transparently over gradient
  memo1.gutter.Gradient:= true;
  //memo1.gutter.trackchanges
  //memo1.Gutter.color:= CoolBar1.COLOR; //clmoneygreen;
  memo1.WantTabs:= true;
  memo1.WordWrap:= true;       //not possible wrap & folding but in advance
  memo1.UseCodeFolding := true;
   statusbar1.SimplePanel:= false;
  with statusbar1 do begin
    //simplepanel:= true;
    showhint:= true;
    //left:= 50;
    hint:= ExtractFilePath(forms.application.ExeName)+' Exe directory';
     Panels.add;
     //panels.items[0].left:= 20;
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
      last_fName9:= 'PRELAST_FILE9';        //3.9.9.88
      last_fName10:= 'PRELAST_FILE10';
      //last_fName10:= 'PRELAST_FILE11';

      last_fontsize:= 11;
      IPPORT:= 8080;
      IPHOST:= '127.0.0.1';
      COMPORT:= 3;
      //NAVWIDTH:= 100; min
      lbintflistwidth:= 350;
  // if (ParamStr(1) = '') then begin   //bug
   SetCurrentDir(ExtractFilePath(ParamStr(0)));   //3.9.9.100
    if fileexists(DEFINIFILE) then LoadFileNameFromIni;  //script file and -onchange
    DefFileread;
  // end;
  PSScript.UsePreProcessor:= true;
  //PSScript.compileroptions.
  dlgPrintFont1.Font.Size:= 7;      //Default 3.8
  dlgPrintFont1.Font.Name:= RCPRINTFONT;
  fPrintOut:= TSynEditPrint.Create(Self);
  fPrintOut.Font.Name:= RCPRINTFONT;
  fPrintOut.Font.Assign(dlgPrintFont1.Font); //3.1
  //fprintout.OnPrintLine:= SynEditPrint1PrintLine;
  fprintout.OnPrintStatus:= SynEditPrint1PrintStatus;
   //fAutoComplete.Editor := TCustomSynEdit(SynPasSyn1);
  if forms.Application.MainForm = NIL then begin
    fAutoComplete:= TSynAutoComplete.Create(Self);
    fAutoComplete.Editor:= memo1;
  if fileexists('bds_delphi.dci') then
    fAutoComplete.AutoCompleteList.LoadFromFile('bds_delphi.dci') else
      showmessage('maXbox: a bds_delphi.dci file is missing (code completion)'+#13#10+
                  'get file: http://www.softwareschule.ch/download/bds_delphi.zip');
  end else
    maxForm1.fAutoComplete.AddEditor(memo1);
   memo1.AddKey(ecAutoCompletion, word('J'), [ssCtrl], 0, []);  //fix5
  //statusbar1.simplepanel:= true;
  //statusbar1.Width:= 400;
     statusbar1.panels.items[0].width:= maxform1.width-270;
     statusbar1.panels.items[1].width:= 210;
     statusbar1.panels.items[2].width:= 60;
     //createmessagedlg
    ledimage:= TImage.Create(self);
    ledimage.parent:= statusbar1;
     ledimage.align:= alleft;
     ledimage.Top:= 2;
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
  Saveasunicode1.Checked:= false;   //5.0.2.60
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
    CB1SCList.Items.Add(last_fName10);
    CB1SCList.Items.Add(last_fName9);
    CB1SCList.Items.Add(last_fName8);
    CB1SCList.Items.Add(last_fName7);
    CB1SCList.Items.Add(last_fName6);
    CB1SCList.Items.Add(last_fName5);
    CB1SCList.Items.Add(last_fName4);
    CB1SCList.Items.Add(last_fName3);
    CB1SCList.Items.Add(last_fName2);
   CB1SCList.Items.Add(last_fName1);
    CB1SCList.Items.Add(last_fName);
    if Act_Filename <> '' then
    CB1SCList.Items.Add(Act_Filename);
  CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
  //if STATVERSIONCHECK then
    //if VersionCheck then memo2.Lines.Add('Version on Internet Checked!') else
  if (STATVERSIONCHECK AND VersionCheck) then memo2.Lines.Add('Version on Internet checked!') else
   memo2.Lines.Add('Internet Version NOT checked!');   //3.8
  if STATExecuteBoot then LoadBootScript;
  if STATExceptionLog then begin
     forms.Application.OnException:= AppOnException;   //v3
    //CLI of command line or ShellExecute
   if not FileExists(ExePath+LOGFILE) then begin
     FileCreate(ExePath+LOGFILE);
     sleep(200);
   end;
   maxform1.Caption:= 'maXbox52 Ocean1150 mX529 XIXRheingold+++++ beta640!';
   //GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);
   //showmessage(formatsettings.ShortDateFormat);
        //FFileStream := TFileStream.Create(Filename, fmCreate);

   //memo2.Lines.Add('maxboxlog open: '+booltostr(IsFileopen(exepath+'maxboxlog.log')));
   memo2.Lines.Add('maxboxlog open1: '+booltostr(IsFileinuse(exepath+'maxboxlog.log')));
   //if not IsFileopen(exepath+'maxboxlog.log') then begin
   //if not IsFileinuse(exepath+'maxboxlog.log') then begin
    hlog.hlWriter.hlFileDef.ddname:= 'maxboxlog'; //dexamples\THotlogfile.txt';
    hlog.hlWriter.hlFileDef.path:= exepath;  //+'examples'; //dexamples\THotlogfile.txt';
    hlog.hlWriter.hlFileDef.append:= true;  //+'examples'; //dexamples\THotlogfile.txt';
    if not IsFileInUse(exepath+'maxboxlog.log') then begin
    //if hlog.started = false then begin
    try
      hlog.StartLogging; //fix5 }  //bug
      memo2.Lines.Add('maxboxlog hlog.started open2: '+booltostr(hlog.started));
    except
      memo2.lines.add('except: second logfile sync warning');
    end;
   end;
   //memo1.modified:= false;
  end;
 try
   // test bed for interactive shell to hell:
   //https://stackoverflow.com/questions/55726166/attachconsole-and-64-bit-application
   if (ParamStr(1) = '-c') then begin
         act_Filestring:= ParamStr(2);
         AttachConsole(dword(-1));   //fix5
         //PSScript.Script.Assign(act_Filestring);
         //f//unction LoadTextFromFile(const FileName: string): string;
         T0:= GetTickCOunt;
         PSScript.Script.text:=  LoadTextFromFile(act_Filestring) ;
      //showmessage(psscript.script.Text);
         // showmessage(act_Filestring) ;
        NativeWriteln(act_Filestring);
         NativeWriteln('Version maXbox5 is: '+MBVERSION);
         if not PSScript.Compile then begin
             NativeWriteln('nit compiled');
           //  NativeWriteLn(act_Filestring);
              for lm:= 0 to PSScript.CompilerMessageCount - 1 do begin
                 m:= psscript.CompilerMessages[lm].MessageToString;
                NativeWriteln('mXShell: '+PSScript.CompilerErrorToStr(lm)+#13#10 +m);
            end;
           end;
         if PSScript.Compile then begin
             NativeWriteLn('compiled5...');
             nativeWriteln('XCompiler Message Count: '+inttoStr(PSScript.CompilerMessageCount));
           for lm:= 0 to PSScript.CompilerMessageCount - 1 do begin
             NativeWriteln('compiled'+ psscript.CompilerMessages[lm].MessageToString);
              Nativewriteln(PSScript.CompilerMessages[lm].messagetostring);

           end;
           if PSScript.Execute then begin
                 NativeWriteLn('executed...');
              for lm:= 0 to PSScript.CompilerMessageCount - 1 do begin
             NativeWriteln('exec'+ psscript.CompilerMessages[lm].MessageToString);
            end;
            nativeWriteln(memo2.text);    //6100
            NativeWriteln('Script '+act_Filestring+' finished: '+DateTimeToStr(Now)+' >');
             NativeWriteln('Script '+act_Filestring+' performs: '+floattostr((GetTickCount-t0)/1000)+' s. >>');
             NativeWriteln(' >>>');
            FreeConsole();
            maxform1.free;
            halt(10);
          {  for lm:= 0 to PSScript.CompilerMessageCount - 1 do begin
              m:= psscript.CompilerMessages[lm].MessageToString;
              nativeWriteln('PSXCompiler: '+PSScript.CompilerErrorToStr(lm)+#13#10 +m);
            end;}
             //V 4.7.6.50
            if ((ParamStr(3) = 's') or (ParamStr(3) = '-s')) then begin
               maxform1.memo2.lines.add('CLI -c -s Console Call Show -read only!: ' +ParamStr(3));
               maxform1.memo1.Lines.LoadFromFile(act_Filestring);
               CB1SCList.Items.Add((Act_Filestring));   //3.9 wb  bugfix 3.9.3.6
               CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
               //to keep the save script file in sync!
               act_Filename:= Act_Filestring;
               maxform1.Showmodal;
               NativeWriteln('Script '+act_Filestring+' finished: '+DateTimeToStr(Now)+' >>');
               NativeWriteln(' >>>');
               maxform1.free;
               halt(10);
               //maxform1.memo2.lines.add('CLI -c Console Call Show: ' +ParamStr(3));
            end; //}
          NativeWriteln('script finished'+ psscript.CompilerMessages[lm].MessageToString);
         end;
          //end else NativeWriteln('mXShell: '+PSScript.CompilerErrorToStr(lm)+#13#10 +m);

         if not PSScript.Execute then begin
          //memo1.SelStart := PSScript.ExecErrorPosition;
            NativeWriteln(PSScript.ExecErrorToString +' at '+Inttostr(PSScript.ExecErrorProcNo)
                       +'.'+Inttostr(PSScript.ExecErrorByteCodePosition));
         end;
       end;
       //NativeWriteln('mXShell: '+PSScript.CompilerErrorToStr(1)+#13#10);
       NativeWriteln('Script '+act_Filestring+' finished: '+DateTimeToStr(Now)+' >');
       NativeWriteln('Script '+act_Filestring+' performs: '+floattostr((GetTickCount-t0)/1000)+' s. >>');
       NativeWriteln(' >>>');
       FreeConsole();
      maxform1.free;
      halt(10);   //*)
         //OutputMessages;
          memo2.Lines.Add(RCSTRMB +extractFileName(Act_Filename)+' Compiled done: '
                                                        +dateTimetoStr(now()));
      end;
    //end;
     if ((ParamStr(1)= 'version') or (ParamStr(1)= '-version') or (ParamStr(1)= '-ver')) then begin  //new4
       AttachConsole(dword(-1));
       NativeWriteln('Version is: '+MBVERSION);
       NativeWriteln('>>>');
       FreeConsole();
       //halt(10);
       forms.Application.terminate;
     end;   //fix5 *)

  if (ParamStr(1) <> '') then begin
     //showmessage('this is param debug');
     SetCurrentDir(ExtractFilePath(ParamStr(0))); //3.9.9.100 !
    act_Filename:= ParamStr(1);
     memo1.Lines.LoadFromFile(act_Filename);
     memo2.Lines.Add(Act_Filename + CLIFILELOAD+' '+getCurrentDir);
     statusBar1.panels.items[0].text:= Act_Filename + CLIFILELOAD+' '+getCurrentDir;
     CB1SCList.Items.Add((Act_Filename));   //3.9 wb  bugfix 3.9.3.6
     CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;

     if ((ParamStr(2) = 'f') or (ParamStr(2) = '-f')) then begin
       forms.Application.BringToFront;  //maximize?
       //maxform1.Show;
       maxform1.memo2.lines.add('CLI Console Call Front: ' +ParamStr(2));
     end;
     if ((ParamStr(2) = 's') or (ParamStr(2) = '-s')) then begin
         maxform1.Show;
         maxform1.memo2.lines.add('CLI Console Call Show: ' +ParamStr(2));
     end;
     if ((ParamStr(2) = 'st') or (ParamStr(2) = '-st')) then begin
         maxform1.Show;
         maxform1.memo2.lines.add('CLI Console Call Show: ' +ParamStr(2));
     end;

     Compile1Click(self);

     maxform1.memo2.lines.add('CLI Console Call Log at: ' +DateTimeToStr(Now));
     hlog.Add('>>>> Start Console Call Exe: {App_name} v{App_ver}{80@}{now}');
     if ((ParamStr(2) = 'm') or (ParamStr(2) = '-m')) then begin
       //Compile1Click(self);!
       forms.Application.Minimize;
     end;
    if (ParamStr(2) = 'r') then begin
       forms.Application.run;
     end;
      if ((ParamStr(2) = 't') or (ParamStr(2) = '-t')) then begin     //new4
        maxform1.memo2.lines.add('CLI Console Call Logt: ' +ParamStr(2));
       forms.Application.terminate;
     end;
     if ((ParamStr(2) = 'st') or (ParamStr(2) = '-st')) then begin
       forms.Application.terminate;
     end;
     if ((ParamStr(1) = 'version') or (ParamStr(1) = '-version') or (ParamStr(1) = '-ver')) then begin  //new4
       AttachConsole(dword(-1));
       //NativeWriteln(MBVERSION);
       FreeConsole();
     end;  //}

  end;
  Except  //silent less log                 Rheingoldwagen-Set "Tin Plate" MHI, Märklin H0 40851
    //raise Exception.Create('CLI fault in parse file: '+RCSTRMB+':' +act_filename);
    //showmessage('');
  end;
  memo1.UseCodeFolding := true;
  (*
  memo1.CodeFolding.Enabled:= false;

  if STATCodefolding then begin              //new V 45810
     memo1.CodeFolding.IndentGuides:= true;
    //memo1.CodeFolding.FolderBarColor:= clred;
    memo1.CodeFolding.HighlighterFoldRegions:= false;
    memo1.CodeFolding.CaseSensitive:= false;
      memo1.codefolding.HighlightIndentGuides:= true;
      memo1.codefolding.ShowCollapsedLine := false;

  // memo1.CodeFolding.CollapsedCodeHint:= true;
   //memo1.ongutterclick:= Nil;   //memo1.Gutter.Width:= 80;   *)
   memo1.gutter.Visible:= true;  //memo1.CodeFolding.CollapsedCodeHint:= true;
 (*   memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'begin','end');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'for','end');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'with','end');
    memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'try','end');
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'while','do');
    memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'repeat','until');
    memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, 'case','end');
    memo1.CodeFolding.FoldRegions.Add(rtkeyword, true, false, true, '{$IFDEF','{$ENDIF}');
    memo1.InitCodeFolding;

    *)
    //memo1.REScanForFoldRanges;

   //  AAddEnding, ANoSubFoldRegions, AWholeWords: Boolean; AOpen, AClose: PChar;
   //memo1.CodeFolding.FoldRegions.Add(rtkeyword, false, false, true, 'begin','end');
  // memo1.CodeFolding.FoldRegions.Add(rtchar, true, false, true, '{','}');
    //memo1.CodeFolding.FoldRegions.Add(rtchar, true, false, true, '<','>');
    //memo1.CodeFolding.FoldRegions.Add(rtchar, true, false, true, '(*','*)');

  //end;

  //if not STATCodefolding then showIndent1.Checked:= false;
  //SetErrorMode(SEM_FAILCRITICALERRORS);

  Sleep(100);
  if STATExceptionLog then begin
     hlog.AddStr(' ');
     hlog.AddStr('New Session Exe Start '+Act_Filename);
     hlog.Add('>>>> Start Exe: {App_name} v{App_ver}{80@}{now}');
     hlog.Add('>>>> Start {RAM-} {disk-}{80@}{now}');
  end;
      (*aMark:= TSynEditMark.Create;
     with amark do begin
        Line:= 2;
        //Char:= p.char;
        ImageIndex:= bookmarkimage;//(Sender as TSpeedButton).Tag;  10-13
        Visible:= TRUE;
        //InternalImage:= BookMarkOptions.BookMarkImages = nil;
        memo1.Marks.Add(amark);
        //amark.Free;
      end; *)
         memo1.Gutter.BorderColor:= clwebblue; //clwebgold;      //3.9.9.100
         //maxForm1.showInclude1.Checked:= false;
         //7ShowInclude1Click(self);
        // ShowInclude1Click(self);
       showinclude1.Checked:= false;
       memo1.options:= memo1.options + [eoTabIndent]  //silvis wish
end;

procedure Tmaxform1.FormActivate(Sender: TObject);
begin
  //STATSavebefore:= true;
  //STATInclude:= true;
  //idLogDebug1.Active:= true;
 // ActiveLineColor1Click(Self);
 // memo1.activeLineColor:= clskyblue;
 // GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);
  StatWriteFirst:= true;
  if fileexists(DEFFILENAME) then
    Def_FName:= DEFFILENAME else begin
      memo1.Lines.SaveToFile(ExePath+DEFFILENAME);
      memo2.Lines.Add('Intern Set: ' +DEFFILENAME + FILESAVE);
  end;
  memo1.SetFocus;
  memo2.Lines.Add('Ver: '+MBVERSION+' ('+MBVER+'). Workdir: ' +(GetCurrentDir)); //3.3
  //memo2.Lines.Add('Version: ' +MBVERSION); //3.6
  // saved with line numbers and check state before
  if pos(inttostr(1), memo1.lines.Strings[1]) <> 0 then
                                Slinenumbers1.Checked:= true;
  if last_fontsize = 14 then begin
        Largefont1.checked:= true;
        largeFont1.Caption:= 'Small Font';
  end;
  statusbar1.panels.items[0].width:= maxform1.width-270;
  //CB1SCList.Items.Add(ExtractFileName(Act_Filename));
  //CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;//}
 // CB1SCList.Items.Add(format('%-6s = %6.2f',[z0,StrToFloat(z1)/1000])); // mm in Meter umrechnen
  //statusBar1.SimpleText:= MBVERSION +' '+Act_Filename;
  //last_fontsize:= 12; //fallback
  //myIncludeOFF;
//  maxForm1.showInclude1.Checked:= false;
  // maxForm1.STATInclude:= false;
  //ShowInclude1Click(self);
  //memo1.InsertMode:= false;
  //memo1.modified:= false;
end;

procedure Tmaxform1.FormMarkup(Sender: TObject);
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


procedure Tmaxform1.AppOnException(sender: TObject; E: Exception);
begin
  MAppOnException(sender, E);
end;

procedure Tmaxform1.ArduinoDump1Click(Sender: TObject);
begin
  ShowMessage('Arduino HexDump to Flash in uC available in V4'+#13#10+
                'first example in: ..\examples\arduino_examples'+#13#10+
                'tests with AVRDUDE to get the flash on a shell with success');
end;

procedure Tmaxform1.TaskMgr1Click(Sender: TObject);
begin
   S_ShellExecute('taskmgr','',seCMDOpen);
    statusbar1.panels.items[0].TEXT:= statusbar1.simpletext +' Task Manager started';
end;

procedure Tmaxform1.AutoDetectSyntax1Click(Sender: TObject);
var fHighlighters: TStringList;
begin
  // auto detect of extension
  fHighlighters := TStringList.Create;
  fHighlighters.Sorted := TRUE;
 (* GetHighlighters(Self, fHighlighters, FALSE);
  memo1.Highlighter:= GetHighlighterFromFileExt(fHighlighters,
      ExtractFileExt(act_filename));
    if uppercase(ExtractFileExt(act_filename)) = uppercase('.txt') then
       memo1.Highlighter:= SynPasSyn1;
    if uppercase(ExtractFileExt(act_filename)) = uppercase('.pas') then
       memo1.Highlighter:= SynPasSyn1;
    //ChangeFileExt(
    //showmessage(ExtractFileExt(dlgFileOpen.FileName));
    if Assigned(memo1.Highlighter) then
      Statusbar1.SimpleText := 'Using highlighter for ' +
        memo1.Highlighter.GetLanguageName
    else
      Statusbar1.SimpleText := 'No highlighter assigned';
      *)
  //end;
  fHighlighters.Free;
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

function myLength(const mytext: string): integer;
begin
   result:= length(mytext)
end;

function myLens(const mytext: string): string;
begin
   result:= inttostr(length(mytext));
end;

procedure MyWriteln(const sln: string);
begin
  maxForm1.memo2.Lines.Add(sln);
end;

procedure MyWritelnUC(const sln: unicodestring);
begin
  maxform1.memo2.lines.defaultencoding:= TEncoding.UTF8;
  maxForm1.memo2.Lines.Add((sln));
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

procedure myreadln1(var ast: string);
begin
  inputquery('maXbox Console Input','please type a string:',ast);
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

procedure myIncb2(var x: byte; n: byte);
begin
  X:= X+N;
end;

function myExit2(res: integer): integer;
begin
  result:= res;
  Exit;
end;


procedure myFillcharSearchRec;
begin
  FillChar(srec, SizeOf(srec), 0);
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
      with maxform1.ledimage do begin
        Top:= 2;
        visible:= true;
         //picture.bitmap.loadfromResourcename(application.handle,'LED_RED_ON')
       end;
  end;

procedure myProcMessON;
begin
  maxForm1.PSScript.OnLine:= maxForm1.PSScriptLine;
  maxForm1.procMess.Checked:= true;
      with maxform1.ledimage do begin
        Top:= 2;
        visible:= false;
      end;
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
   maxform1.memo2.lines.add('True Assert Log: '+msg+' mX4 Assertion: ' +DateTimeToStr(Now));
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
    //append
  end;
end;

//procedure myappend(var mystring: string); //v3.99.91
procedure myappend(var F: text); //v3.99.91
begin
    //append(Text(mystring))
    append(F)
end;

procedure saveasunicode; //v5.02.60
begin
    //to save contexr as unicode - append(Text(mycodestring))
    maxform1.memo1.lines.savetofile(maxform1.Act_Filename, TEncoding.UTF8);
    maxform1.memo2.lines.Add('----File saved as Unicode!----UTF8 😀');
    maxform1.memo1.Lines.LoadFromFile(maxform1.Act_Filename, TEncoding.UTF8);
end;

procedure saveasansi; //v5.02.60
begin //to save contexr as unicode - append(Text(mycodestring))
    maxform1.memo1.lines.savetofile(maxform1.Act_Filename, TEncoding.ansi);
    maxform1.memo2.lines.Add('----File saved as Ansi!----Ansi8');
    maxform1.memo1.Lines.LoadFromFile(maxform1.Act_Filename, TEncoding.Ansi);
end;

procedure saveasunicode1; //v5.02.60
begin
    //to save contexr as unicode - append(Text(mycodestring))
    maxform1.memo1.lines.savetofile(maxform1.Act_Filename, TEncoding.Unicode);
    maxform1.memo2.lines.Add('----File saved as Unicode!----Unicode 😀 マックスボックス5');
    maxform1.memo1.Lines.LoadFromFile(maxform1.Act_Filename, TEncoding.Unicode);
end;

procedure saveasdefault; //v5.02.60
begin
    //to save contexr as unicode - append(Text(mycodestring))
    maxform1.memo1.lines.savetofile(maxform1.Act_Filename, TEncoding.default);
    maxform1.memo2.lines.Add('----File saved as Unicode!----Default �');
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
  //result:= MessageBox(hndl, text, caption, utype);
end;

procedure mySucc(var X: integer);
begin
  //succ(X);
end;

procedure myPred(X: int64);
begin
 // pred(X);
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

// TbtString = {$IFDEF DELPHI2009UP}AnsiString{$ELSE}String{$ENDIF};

function RunCompiledScript3(Bytecode: AnsiString; out RuntimeErrors: String): Boolean;
begin
  result:= maxform1.RunCompiledScript2(Bytecode, RuntimeErrors);
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
end; //*)

function keypressed2: boolean;    //keypress on memo2!
begin
  result:= maxform1.fkeypressed;
  //iskeypressed
end;

procedure Set_ReportMemoryLeaksOnShutdown(abo: boolean);
begin
  ReportMemoryLeaksOnShutdown:= abo;
end;

function myGetPerftime: string;
begin
  result:= maxform1.getperftime;
end;

function myGetPSScript: string; //TPSScript;
begin
  result:= maxform1.PSScript.Script.text;
end;

procedure mysaveByteCode;
begin
  maxform1.SaveByteCode;
end;

procedure myResetKeyPressed;
begin
  maxform1.ResetKeyPressed;
end;

procedure mySetKeyPressed;
begin
  maxform1.setKeyPressed;
end;

function myformatsettings: Tformatsettings;
var formatSettings: TFormatsettings;
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);
  result:= formatSettings;
end;

function myformatsettings2: Tformatsettings;
//var formatSettings: TFormatsettings;
begin
  //GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);
  result:= formatSettings;
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

function Tmaxform1.PSScript1NeedFile(Sender: TObject;
  const OrginFileName: tbtString; var FileName, Output: tbtString): Boolean;
//begin
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

procedure Tmaxform1.PSScriptCompile(Sender: TPSScript);
//var s: TSearchRec;
 var mFormatSettings: TFormatSettings;
begin
  //AddTypeS('TThreadFunction','TThreadFunction = function(P: Pointer): Longint; stdcall)');
  formatsettings:= myformatsettings2;
   mformatsettings:= myformatsettings2;
  Sender.AddFunction(@MyWriteln, 'procedure Writeln(s: string);');
  Sender.AddFunction(@MyWritelnUC, 'procedure WritelnUC(s: unicodestring);');
  Sender.AddFunction(@MyWriteln, 'procedure Writ(s: string);');
  Sender.AddFunction(@MyWriteln, 'procedure Println(s: string);');  //alias
  Sender.AddFunction(@MyWrite, 'procedure Write(S: string);');
  Sender.AddFunction(@MyWrite, 'procedure Print(S: string);');
  Sender.AddFunction(@Mylength, 'function Len(s: string): integer;');
  Sender.AddFunction(@Mylens, 'function Lens(s: string): string;');

   Sender.AddFunction(@MyReadln, 'function Readln(question: string): string;');
  Sender.AddFunction(@MyReadln1, 'procedure Readln1(var ast: string);');
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
  Sender.AddFunction(@myIncb2, 'procedure Incb2(var x: byte; n: byte);');
  Sender.AddFunction(@myExit2, 'function Exit2(res: integer):integer;');
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
  Sender.AddFunction(@FileExists, 'function fileExists(const FileName: string): Boolean;');   // *)
  Sender.AddFunction(@myShellExecute,'function ShellExecute(hWnd: HWND;' +
      'Operation, FileName, Parameters,Directory: string; ShowCmd: Integer): integer; stdcall;');
  Sender.AddFunction(@myShellExecute2,'function Shellexecute2(hwnd: HWND; const FileName: string):integer; stdcall;');

  Sender.AddFunction(@myBeep2, 'function beep2(dwFreq, dwDuration: integer): boolean;');
  Sender.AddFunction(@myBeep2, 'function tone(dwFreq, dwDuration: integer): boolean;');
  Sender.AddFunction(@myWinExec, 'function winexec(FileName: pchar; showCmd: integer): integer;');
  Sender.AddFunction(@myAssert,'procedure Assert2(expr : Boolean; const msg: string);');
  Sender.AddFunction(@ExtractFileName,'function ExtractFileName(const filename: string):string;');
  Sender.AddFunction(@ExtractFilePath,'function ExtractFilePath(const filename: string):string;');
  Sender.AddFunction(@Max3,'function Max3(const x,y,z: Integer): Integer;');
  //Sender.AddFunction(@Max,'function Max(const x,y: Integer): Integer;');
  Sender.AddFunction(@SwapChar,'procedure SwapChar(var X,Y: char);');
  Sender.AddFunction(@Shuffle,'procedure Shuffle(vQ: TStringList);');
  Sender.AddFunction(@CharToHexStr, 'function CharToHexStr(Value: char): string);');
  Sender.AddFunction(@HexToInt, 'function HexToInt(hexnum: string): LongInt;');  //*)
  Sender.AddFunction(@IntToBin, 'function IntToBin(Int: Integer): String;'); //in idglobal
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
  Sender.AddFunction(@lengthmp3,'function lengthmp3(mp3path: string):integer;');  //*)
  Sender.AddFunction(@ExePath, 'function ExePath: string;');
  Sender.AddFunction(@MaxPath, 'function MaxPath: string;');
  Sender.AddFunction(@MaxPath, 'function ExePathName: string;');
  Sender.AddFunction(@constrain, 'function constrain(x, a, b: integer): integer;');
  Sender.AddFunction(@myassign,'procedure Assign2(mystring, mypath: string);');
  Sender.AddFunction(@myreset,'function Reset2(mypath: string): TStringlist;');
  Sender.AddFunction(@myappend,'procedure append(var F: text);');
  //procedure myappend(var F: text); //v3.99.91

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
  Sender.AddFunction(@myreset,'function Reset2(mypath: string):string;');
  Sender.AddFunction(@myVal, 'procedure Val(const s: string; var n, z: Integer)');  //*)
  Sender.AddFunction(@searchAndOpenDoc, 'procedure SearchAndOpenDoc(vfilenamepath: string)');
  Sender.AddFunction(@searchAndOpenDoc, 'procedure SearchAndOpenFile(vfilenamepath: string)');
  Sender.AddFunction(@searchAndOpenDoc, 'procedure OpenFile(vfilenamepath: string)');
  Sender.AddFunction(@searchAndOpenDoc, 'procedure OpenDoc(vfilenamepath: string)');

  Sender.AddFunction(@ExecuteCommand, 'Procedure ExecuteCommand(executeFile, paramstring: string)');
  Sender.AddFunction(@ExecuteCommand, 'Procedure ExecuteShell(executeFile, paramstring: string)');
  Sender.AddFunction(@ShellExecuteAndWait, 'Procedure ShellExecuteAndWait(executeFile, paramstring: string)');
  Sender.AddFunction(@ExecConsoleApp,'function ExecConsoleApp(const AppName, Parameters: String; AppOutput: TStrings): boolean;');
  Sender.AddFunction(@myGetDriveType,'function GetDriveType(rootpath: pchar): cardinal;');   //*)
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
  //*)
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
  Sender.AddFunction(@getTimeAMString, 'function TimeAMString: string;');
  Sender.AddFunction(@getTimePMString, 'function TimePMString: string;');
  Sender.AddFunction(@readm, 'function readm: string;');
  Sender.AddFunction(@readm, 'function readln2: string;');

  Sender.AddFunction(@GetHinstance, 'function GetHINSTANCE: longword;');
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
  Sender.AddFunction(@GetFileVersion,'function GetFileVersion(Filename: String): String;');
  Sender.AddFunction(@StringPad,'Function StringPad(InputStr,FillChar: String; StrLen:Integer; StrJustify:Boolean): String;');
  Sender.AddFunction(@MinimizeMaxbox, 'Procedure MinimizeMaxbox;');
  Sender.AddFunction(@MinimizeMaxbox, 'Procedure MinimizeWindow;');
  Sender.AddFunction(@SaveCanvas2, 'procedure SaveCanvas2(vCanvas: TCanvas; FileName: string);');
  Sender.AddFunction(@SaveCanvas2, 'procedure SaveCanvas(vCanvas: TCanvas; FileName: string);');
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
  Sender.AddFunction(@FormatBigInt,'FUNCTION FormatBigInt(s: string): STRING;');   //*)
  Sender.AddFunction(@ComputeFileCRC32, 'function ComputeFileCRC32(const FileName : String) : Integer;');
  Sender.AddFunction(@myprintf, 'procedure printf(const format: String; const args: array of const);');
  Sender.AddFunction(@myprintf, 'procedure formatf(const format: String; const args: array of const);');
  Sender.AddFunction(@myprintfw, 'procedure printfw(const format: String; const args: array of const);');
  Sender.AddFunction(@myprintf, 'procedure FormatLn(const format: String; const args: array of const);');  //alias
  Sender.AddFunction(@myscanf, 'function scanf(const aformat: String; const args: array of const): string;');
  Sender.AddFunction(@getHexArray,'function GetHexArray(ahexdig: THexArray): THexArray;');
  Sender.AddFunction(@CharToHex,'Function CharToHex(const APrefix : String; const cc : Char) : shortstring;');
  Sender.AddFunction(@GetMultiN,'Function GetMultiN(aval: integer): string;');  // *)
  Sender.AddFunction(@PowerBig,'Function PowerBig(aval, n:integer): string;');  //n^n (see up in this script)
  Sender.AddFunction(@Split,'procedure Split(Str: string;  SubStr: string; List: TStrings);');
  Sender.AddFunction(@Combination,'Function Combination(npr, ncr: integer): extended;');
  Sender.AddFunction(@Permutation, 'function Permutation(npr, k: integer): extended;');
  Sender.AddFunction(@CombinationInt,'Function CombinationInt(npr, ncr: integer): Int64;');
  Sender.AddFunction(@PermutationInt, 'function PermutationInt(npr, k: integer): Int64;');  //*)
  Sender.AddFunction(@winform1.MD5,'function MD5(const fileName: string): string;');
  Sender.AddFunction(@winform1.IdSHA1Hash,'function SHA1(const fileName: string): string;');
  Sender.AddFunction(@winform1.SHA1,'function SHA1_(const fileName: string): string;');
  Sender.AddFunction(@winform1.IdSHA2Hash,'function SHA2_(const fileName: string): string;');
  Sender.AddFunction(@winform1.SHA1fromString,'function SHAfromString(const fileName: string): string;');
  Sender.AddFunction(@upsi_chash.SHA2,'function SHA2_(const fileName: string): ansistring;');
  Sender.AddFunction(@winform1.SHA2fromFile,'function SHA2(const fileName: string): string;');
  Sender.AddFunction(@winform1.SHA3fromFile,'function SHA3(const fileName: string): string;');

  Sender.AddFunction(@CRC32H,'function CRC32(const fileName: string): LongWord;');
  Sender.AddFunction(@getCmdLine,'function CmdLine: PChar;');
  Sender.AddFunction(@getCmdShow,'function CmdShow: Integer;');
  Sender.AddFunction(@getCmdLine,'function getCmdLine: PChar;');
  Sender.AddFunction(@getCmdShow,'function getCmdShow: Integer;');
  Sender.AddFunction(@FindComponent1,'function FindComponent(vlabel: string): TComponent;');
  Sender.AddFunction(@FindComponent2,'function FindComponent2(vlabel: string): TComponent;');
  Sender.AddFunction(@IsFormOpen,'Function IsFormOpen(const FormName: string): Boolean;');  //*)
  Sender.AddFunction(@IsInternet,'Function IsInternet: boolean;');
  Sender.AddFunction(@IsInternet,'Function WebExists: boolean;');   //alias
  Sender.AddFunction(@VersionCheck,'function VersionCheck: boolean;');
  Sender.AddFunction(@VersionCheck,'function CheckVersion: boolean;'); //alias
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
  Sender.AddFunction(@mytimegetsystemtime,'function timegetsystemtime: int64;'); //((*)
  Sender.AddFunction(@GetCPUSpeed,'function GetCPUSpeed: Double;');
  Sender.AddFunction(@IsWoW64,'function IsWoW64: boolean;');
  Sender.AddFunction(@IsWoW64,'function IsWin64: boolean;');
  Sender.AddFunction(@IsWow64String,'function IsWow64String(var s: string): Boolean;');
  Sender.AddFunction(@IsWow64String,'function IsWin64String(var s: string): Boolean;');
  Sender.AddFunction(@RGB,'Function RGB(R,G,B: Byte): TColor;');
  Sender.AddFunction(@Sendln,'Function Sendln(amess: string): boolean;');
 // Sender.AddFunction(@GetSource,'function GetSource: string;');
  Sender.AddFunction(@maXbox,'procedure maXbox;');
  Sender.AddFunction(@AspectRatio,'Function AspectRatio(aWidth, aHeight: Integer): String;');  // *)
  Sender.AddFunction(@wget,'function wget(aURL, afile: string): boolean;');
  Sender.AddFunction(@wget2,'function wget2(aURL, afile: string): boolean;');
  Sender.AddFunction(@wget3,'function wget3(aURL, afile: string; opendoc: boolean): boolean;');
  Sender.AddFunction(@booltostr3,'Function BoToStr3(value : bool) : string;');
  Sender.AddFunction(@booltostr4,'Function BoolToStr4(value : boolean) : string;');
  Sender.AddFunction(@BoolToInt ,'function BoolToInt(aBool: Boolean): LongInt;');
  Sender.AddFunction(@BoToInt ,'function BoToInt(aBool: Boolean): LongInt;');
  //Sender.AddFunction(@Bo2Str ,'function Bo2Str(aBool: boolean): string;');
  Sender.AddFunction(@IntToBool ,'Function IntToBool(aInt: LongInt): Boolean ;');

  Sender.AddFunction(@DownloadFileOpen,'function wgetX(aURL, afile: string): boolean;');
  Sender.AddFunction(@DownloadFile,'function wgetX2(aURL, afile: string): boolean;');
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
  Sender.AddFunction(@SetArrayLength2String2,'procedure SetArrayLength2String2(var arr: T2StringArray; asize1, asize2: integer);');
  Sender.AddFunction(@SetArrayLength2Integer2,'procedure SetArrayLength2Integer2(var arr: T2IntegerArray; asize1, asize2: integer);');
  Sender.AddFunction(@SetArrayLength2String2,'procedure Set2DimStrArray(var arr: T2StringArray; asize1, asize2: integer);');
  Sender.AddFunction(@SetArrayLength2Integer2,'procedure Set2DimIntArray(var arr: T2IntegerArray; asize1, asize2: integer);');
  Sender.AddFunction(@Set3DimIntArray,'procedure Set3DimIntArray(var arr: T3IntegerArray; asize1, asize2, asize3: integer);');
  Sender.AddFunction(@Set3DimStrArray,'procedure Set3DimStrArray(var arr: T3StringArray; asize1, asize2, asize3: integer);');
  Sender.AddFunction(@SetArrayLength2Char2,'procedure SetArrayLength2Char2(var arr: T2CharArray; asize1, asize2: integer);');

  Sender.AddFunction(@SaveAsExcelFile,'function SaveAsExcelFile(AGrid: TStringGrid; ASheetName, AFileName: string; open: boolean): Boolean;');
  Sender.AddFunction(@SaveAsExcelFile,'function SaveAsExcel(aGrid: TStringGrid; aSheetName, aFileName: string; openexcel: boolean): Boolean;');
  Sender.AddFunction(@YesNoDialog,'function YesNoDialog(const ACaption, AMsg: string): boolean;');
  Sender.AddFunction(@myStrToBytes,'function StrToBytes(const Value: String): TBytes;');
  Sender.AddFunction(@myBytesToStr,'function BytesToStr(const Value: TBytes): String;');
  Sender.AddFunction(@ReverseDNSLookup,'function ReverseDNSLookup(const IPAddress:String; const DNSServer:String; Timeout,Retries:Integer; var HostName:String):Boolean;');
  // *)
 Sender.AddFunction(@FindInPaths,'function FindInPaths(const fileName,paths: String): String;');
  Sender.AddFunction(@initHexArray,'procedure initHexArray(var hexn: THexArray);');
  Sender.AddFunction(@josephusG,'function josephusG(n,k: integer; var graphout: string): integer;');
  Sender.AddFunction(@isPowerof2,'function isPowerof2(num: int64): boolean;');
  Sender.AddFunction(@powerOf2,'function powerOf2(exponent: integer): int64;');   //*)
  Sender.AddFunction(@getBigPI,'function getBigPI: string;');
  Sender.AddFunction(@getBigPI,'function BigPI: string;');
  Sender.AddFunction(@MakeSound,'procedure MakeSound(Frequency,Duration: Integer; Volume: Byte; savefilePath: string);');
  Sender.AddFunction(@GetASCIILine,'function GetASCIILine: string;');
  Sender.AddFunction(@MakeComplexSound,'procedure MakeComplexSound(N:integer;freqlist:TStrings; Duration{mSec}: Integer; pinknoise: boolean; Volume: Byte);');
  Sender.AddFunction(@MakeComplexSound2,'function MakeComplexSound2(N:integer;freqlist:TStrings; Duration{mSec}: Integer; pinknoise: boolean; Volume: Byte): MSArray;');
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
  Sender.AddFunction(@GetOSName2,'function GetOSName2: string;');
  Sender.AddFunction(@GetEarth,'procedure GetEarth;');
  Sender.AddFunction(@GetMax,'procedure GetMax;');
  Sender.AddFunction(@getjpegfromresname,'procedure getjpegfromresname(resname: string; bstretch: boolean);');
  Sender.AddFunction(@GetOSVersion,'function GetOSVersion: string;');
  Sender.AddFunction(@GetOSNumber,'function GetOSNumber: string;');
  Sender.AddFunction(@StrReplace,'procedure StrReplace(var Str: String; Old, New: String);');
  Sender.AddFunction(@getTeamViewerID, 'function getTeamViewerID: string;');
  Sender.AddFunction(@StartFileFinder3,'procedure StartFileFinder3(spath, aext, searchstr: string; arecursiv: boolean; reslist: TStringlist);');
  Sender.AddFunction(@StartFileFinder3,'procedure Grep(spath, aext, searchstr: string; arecursiv: boolean; reslist: TStringlist);');
  Sender.AddFunction(@RecurseDirectory,'Procedure RecurseDirectory(Dir: String; IncludeSubs : boolean; callback : TFileCallbackProcedure);');
  Sender.AddFunction(@RecurseDirectory2,'Procedure RecurseDirectory2(Dir: String; IncludeSubs : boolean);');
  //*)
  Sender.AddFunction(@WinInet_HttpGet,'procedure WinInet_HttpGet(const Url: string; Stream:TStream);');
  Sender.AddFunction(@WinInet_HttpGet,'procedure HttpGet(const Url: string; Stream:TStream);');
  Sender.AddFunction(@WinInet_HttpGet,'procedure Http_GetStream(const Url: string; Stream:TStream);');
  Sender.AddFunction(@GetQrCode2,'procedure GetQrCode2(Width,Height: Word; Correct_Level: string;'+
                                      'const Data:string; apath: string);');
  Sender.AddFunction(@GetQrCode3,'procedure GetQrCode3(Width,Height: Word; Correct_Level: string;'+
                                      'const Data:string; apath: string);');
  Sender.AddFunction(@GetQrCode4,'function GetQrCode4(Width,Height: Word; Correct_Level: string;'+
                                      'const Data:string; format: string):TBitmap;');
   Sender.AddFunction(@GetQrCode5,'procedure GetQrCode5(Width,Height: Word; Correct_Level: string;'+
                                      'const Data:string; apath: string);');
  Sender.AddFunction(@isRunningWine, 'function IsRunningWine: boolean;');
  Sender.AddFunction(@isRunningWine, 'function IsWine: boolean;');
   Sender.AddFunction(@GetFileList, 'function GetFileList(FileList: TStringlist; apath: string): TStringlist;');
  Sender.AddFunction(@GetFileList1, 'function GetFileList1(apath: string): TStringlist;');
  Sender.AddFunction(@LetFileList, 'procedure LetFileList(FileList: TStringlist; apath: string)');
  Sender.AddFunction(@StartWeb, 'procedure StartWeb(aurl: string);');
  Sender.AddFunction(@StartWeb, 'procedure WebStart(aurl: string);');
  Sender.AddFunction(@GetTodayFiles, 'function GetTodayFiles(startdir, amask: string): TStringlist;');
  Sender.AddFunction(@PortTCPIsOpen, 'function PortTCPIsOpen(dwPort : Word; ipAddressStr: String): boolean;');
  Sender.AddFunction(@PortTCPIsOpen, 'function IsTCPPortOpen(dwPort : Word; ipAddressStr: String): boolean;');
  Sender.AddFunction(@JavahashCode, 'function JavahashCode(val: string): Integer;');
  Sender.AddFunction(@PostKeyEx32, 'procedure PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean);');
  Sender.AddFunction(@getDiskSpace2, 'function getDiskSpace2(const path: String; index: integer): int64;');
  Sender.AddFunction(@Set_ReportMemoryLeaksOnShutdown, 'procedure Set_ReportMemoryLeaksOnShutdown(abo: boolean)');
  Sender.AddFunction(@SaveBytesToFile2, 'procedure SaveBytesToFile(const Data: TBytes; const FileName: string);');
  Sender.AddFunction(@HideWindowForSeconds, 'Procedure HideWindowForSeconds(secs: integer);');
  Sender.AddFunction(@HideWindowForSeconds2, 'Procedure HideWindowForSeconds2(secs: integer; apphandle, aself: TForm);');
  Sender.AddFunction(@HideWindowForSeconds2, 'Procedure HideWindow(secs: integer; apphandle, aself: TForm);');
   Sender.AddFunction(@ConvertToGray, 'Procedure ConvertToGray(Cnv: TCanvas);');
  Sender.AddFunction(@GetFileDate, 'function GetFileDate(aFile:string; aWithTime:Boolean):string;');
  //*//)
  Sender.AddFunction(@ShowMemory, 'procedure ShowMemory');
  Sender.AddFunction(@ShowMemory2, 'function ShowMemory2: string;');   //*)
  //Sender.AddFunction(@ShowMemory2, 'function ShowMemory2: string;');   //*)
  Sender.AddFunction(@mygetperftime, 'function getPerfTime: string;');
  Sender.AddFunction(@mygetperftime, 'function getRuntime: string;');
  Sender.AddFunction(@getHostIP, 'function getHostIP: string;');
  Sender.AddFunction(@getIsAdmin, 'function getISAdmin: boolean;');
  Sender.AddFunction(@ShowBitmap, 'procedure ShowBitmap(bmap: TBitmap);');
  Sender.AddFunction(@IsWindowsVista, 'function IsWindowsVista: boolean;');
  Sender.AddFunction(@GetOsVersionInfo, 'function GetOsVersionInfo: TOSVersionInfo;');
  Sender.AddFunction(@ChangeOEPFromBytes, 'function ChangeOEPFromBytes(bFile:mTByteArray):Boolean;');
  Sender.AddFunction(@ChangeOEPFromFile, 'function ChangeOEPFromFile(sFile:string; sDestFile:string):Boolean;');
  Sender.AddFunction(@CopyEXIF, 'procedure CopyEXIF(const FileNameEXIFSource, FileNameEXIFTarget: string);');
  Sender.AddFunction(@IsNetworkConnected, 'function IsNetworkConnected: Boolean;');  //*)
  Sender.AddFunction(@IsInternetConnected, 'function IsInternetConnected: Boolean;');
  Sender.AddFunction(@IsNetworkConnected, 'function IsNetOn: Boolean;');
  Sender.AddFunction(@IsInternetConnected, 'function IsInternetOn: Boolean;');
  Sender.AddFunction(@IsCOMConnected, 'function IsCOMOn: Boolean;');
  Sender.AddFunction(@IsCOMConnected, 'function IsCOMConnected: Boolean;');
  Sender.AddFunction(@IsCOMConnected, 'function IsCOMPort: Boolean;');
  Sender.AddFunction(@IsService, 'function IsService: Boolean;');
  Sender.AddFunction(@IsNTFS, 'function IsNTFS: Boolean;');
  Sender.AddFunction(@dowebcampic, 'procedure doWebCamPic(picname: string);');
  Sender.AddFunction(@dowebcampic, 'procedure WebCamPic(picname: string);');
  Sender.AddFunction(@GetMapX, 'function GetMapX(C_form,apath: string; const Data: string): boolean;');
  Sender.AddFunction(@GetGEOMap, 'procedure GetGEOMap(C_form,apath: string; const Data: string);');
  Sender.AddFunction(@GetMapXGeoReverse, 'function GetMapXGeoReverse(C_form: string; const lat,long: string): string;');
  Sender.AddFunction(@GetGeoCodeCoord, 'function GetGeocodeCoord(C_form: string; const data:string; atxt: boolean): string;');
  Sender.AddFunction(@GetGeoCodeCoord, 'function GetGeoCoord(C_form: string; const data:string; atxt: boolean): string;');
  Sender.AddFunction(@GetGeoCodeCoord, 'function GetGeoCode2(C_form: string; const data:string; atxt: boolean): string;');
  Sender.AddFunction(@EncodeURIComponent2, 'function EncodeURIComponent2(const ASrc: string): UTF8String;');
  Sender.AddFunction(@TAddressGeoCodeOSM5, 'function TAddressGeoCodeOSM5(faddress: string): tlatlong;');
  Sender.AddFunction(@OpenMap, 'function OpenMap(const Data: string): boolean;');
  Sender.AddFunction(@OpenMap, 'function OpenMapX(const Data: string): boolean;');
  Sender.AddFunction(@OpenMap, 'function OpenStreetMap(const Data: string): boolean;');
  Sender.AddFunction(@GetGeoCode, 'function GetGeoCode(C_form,apath: string; const data: string; sfile: boolean): string;');
  Sender.AddFunction(@GetGeoCode5, 'function GetGeoCode5(C_form,apath: string; const data: string; sfile: boolean): string;');
  Sender.AddFunction(@GetGeoInfoMap5save, 'function GetGeoInfoMap5(const lat,lon, zoom: double; asize: integer; UrlGeoLookupInfo, apath: string; showfile: boolean): string;');
  Sender.AddFunction(@GetGeoInfoMap5save, 'function GetGeoInfoMap5save(const lat,lon, zoom: double; asize: integer; UrlGeoLookupInfo, apath: string; showfile: boolean): string;');
   Sender.AddFunction(@getFileCount, 'Function getFileCount(amask: string): integer;');
  Sender.AddFunction(@CoordinateStr, 'function CoordinateStr(Idx: Integer; PosInSec: Double; PosLn: TNavPos): string;');
  Sender.AddFunction(@Debugln, 'procedure Debugln(DebugLOGFILE: string; E: string);');
  Sender.AddFunction(@IntToFloat, 'function IntToFloat(i: Integer): double;');
  Sender.AddFunction(@AddThousandSeparator, 'function AddThousandSeparator(S: string; myChr: Char): string;');
  Sender.AddFunction(@mymcisendstring, 'function mciSendString(cmd: PChar; ret: PChar; len: integer; callback: integer): cardinal;');
  Sender.AddFunction(@IsSound, 'function IsSound: Boolean;');

  Sender.AddFunction(@DownloadFile, 'function DownloadFile(SourceFile, DestFile: string): Boolean;');
  Sender.AddFunction(@DownloadFileOpen, 'function DownloadFileOpen(SourceFile, DestFile: string): Boolean;');   //*)
  Sender.AddFunction(@RunCompiledScript3, 'function RunByteCode(Bytecode: AnsiString; out RuntimeErrors: AnsiString): Boolean;');
  Sender.AddFunction(@RunCompiledScript3, 'function RunCompiledScript2(Bytecode: AnsiString; out RuntimeErrors: AnsiString): Boolean;');

  Sender.AddFunction(@IsApplication, 'function IsApplication: Boolean;');
  Sender.AddFunction(@IsTerminalSession, 'function IsTerminalSession: Boolean;');
  Sender.AddFunction(@SetPrivilege, 'function SetPrivilege(privilegeName: string; enable: boolean): boolean;');
  Sender.AddFunction(@getScriptandRun, 'procedure getScriptandRun(ascript: string);');
  Sender.AddFunction(@getScriptandRunAsk, 'procedure getScriptandRunAsk;');
  Sender.AddFunction(@getScriptandRun, 'procedure getScript(ascript: string);');
  Sender.AddFunction(@getScriptandRun, 'procedure getWebScript(ascript: string);');
  Sender.AddFunction(@versionCheckAct, 'function VersionCheckAct: string;'); //*)
  Sender.AddFunction(@getBox, 'procedure getBox(aurl, extension: string);');
  Sender.AddFunction(@checkBox, 'function CheckBox: string;');
  Sender.AddFunction(@myFillcharSearchRec, 'procedure FillCharSearchRec;');  //*)
  Sender.AddFunction(@mySaveByteCode, 'procedure SaveByteCode;');
  Sender.AddFunction(@myResetKeyPressed, 'procedure ResetKeyPressed;');
  Sender.AddFunction(@mysetKeyPressed, 'procedure SetKeyPressed;');
  Sender.AddFunction(@myGetPSScript, 'function GetPSScript: string;');
  //Sender.AddFunction(@list_functions, 'function list_functions: TStringlist');
    //*)
  Sender.AddFunction(@CheckMemory, 'procedure CheckMemory;');
  Sender.AddFunction(@GetMemoryInfo, 'function getMemoryInfo: string;');
  Sender.AddFunction(@GetMemoryInfo, 'function getMemInf: string;');
  Sender.AddFunction(@GetMemoryData, 'function getMemoryData: integer;');
  Sender.AddFunction(@myformatsettings, 'function Formatsettings_: Tformatsettings;');
  Sender.AddFunction(@myformatsettings2, 'function Formatsettings__: Tformatsettings;');

  Sender.AddFunction(@GetScriptPath2, 'function GetScriptPath: string;');
  Sender.AddFunction(@GetScriptPath2, 'function ScriptPath: string;');
  Sender.AddFunction(@GetScriptName2, 'function ScriptName: string;');
  Sender.AddFunction(@saveasunicode, 'procedure SaveasUnicode');
  Sender.AddFunction(@saveasunicode1, 'procedure SaveasUnicode1');
  Sender.AddFunction(@saveasansi, 'procedure SaveasAnsi');
  Sender.AddFunction(@saveasdefault, 'procedure SaveasDefault');
  Sender.AddFunction(@SaveString2, 'procedure SaveString2(const AFile, AText: string);');
  Sender.AddFunction(@SaveString3, 'procedure SaveString3(const AFile, AText: string; Append: Boolean);');
  Sender.AddFunction(@SaveString3, 'procedure SaveStringUC(const AFile, AText: string; Append: Boolean);');
  Sender.AddFunction(@loadfile3, 'function LoadFile3(const FileName: TFileName): string;');
  Sender.AddFunction(@loadfile3, 'function LoadFile2(const FileName: TFileName): string;');
  Sender.AddFunction(@loadfile3, 'function LoadFileUC(const FileName: TFileName): string;');
  Sender.AddFunction(@SetDebugCheck3, 'procedure SetDebugCheck(ab: boolean);');
  Sender.AddFunction(@SetDebugON, 'procedure SetDebugON;');
  Sender.AddFunction(@SetDebugOFF, 'procedure SetDebugOFF;');

      //Sender.AddFunction(@mmsystem32.timegettime
  //Sender.AddFunction(@AssignFile,'Procedure AssignFile(var F: Text; FileName: string)');
  //Sender.AddFunction(@CloseFile,'Procedure CloseFile(var F: Text);');   *)
  Sender.AddRegisteredVariable('Application', 'TApplication');
  Sender.AddRegisteredVariable('Screen', 'TScreen');
  Sender.AddRegisteredVariable('Self', 'TForm');
  Sender.AddRegisteredVariable('Memo1', 'TSynEdit');
  Sender.AddRegisteredVariable('memo2', 'TMemo');
  //with Sender.AddClassN(CL.FindClass('TForm'),'TMaxform1')
   // Sender.AddRegisteredVariable('maxForm1', 'TForm');  //!!
    Sender.AddRegisteredVariable('maxForm1', 'TmaxForm1');  //!!
  Sender.AddRegisteredVariable('debugout', 'Tdebugoutput');  //!!
  Sender.AddRegisteredVariable('formatsettings', 'TFormatsettings');  //!!

  //Sender.AddRegisteredVariable('hlog','THotlog');  //!!
  Sender.AddRegisteredVariable('it','integer');  //for closure!!
  Sender.AddRegisteredVariable('sr','string');  //for closure!!
  Sender.AddRegisteredVariable('srlist','TStringlist');  //for closure!!
  Sender.AddRegisteredVariable('bt','boolean');  //for closure!!
  Sender.AddRegisteredVariable('ft','double');  //for closure!!
  Sender.AddRegisteredVariable('mouse','TMouse');  //at controls.TMouse!
  Sender.AddRegisteredVariable('NewStyleControls','boolean');  //at controls.TMouse!

  //*)
    //GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);
  //Sender.AddRegisteredVariable('FormatSettings','TFormatSettings');  //at sysutils!
   //FormatSettings := TFormatSettings(; //.  .Create(LOCALE_INVARIANT); // Auch nicht besser
  //mouse.cursorpos
  //FormatSettings.

  //Sender.AddRegisteredVariable('maxForm1', 'TMaxForm1');
  //Sender.AddRegisteredVariable('stringgrid1', 'TStringGrid');
  //sender.AddRegisteredVariable('puzObj','TWinFormp');
  //sender.AddRegisteredVariable('HexDigits','THexArray');
   //sender.addregisteredconst(
end;


procedure Tmaxform1.Expand_Macro;
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
  SearchAndCopy(memo1.lines, '#file', fname, 11);    //*)
  SearchAndCopy(memo1.lines, '#fils', fname +' '+SHA1(Act_Filename), 11);
  SearchAndCopy(memo1.lines, '#locs', intToStr(getCodeEnd), 11);
  SearchAndCopy(memo1.lines, '#head',Format('%s: %s: %s %s ',
       [getUserNameWin, getComputernameWin, datetimetoStr(now), Act_Filename]), 11);
  SearchAndCopy(memo1.lines, '#perf', perftime, 11);
  SearchAndCopy(memo1.lines, '#sign',Format('%s: %s: %s ',
       [getUserNameWin, getComputernameWin, datetimetoStr(now)]), 11);
 SearchAndCopy(memo1.lines, '#tech',Format('perf: %s threads: %d %s %s %s',
       [perftime, numprocessthreads, getIPAddress(getComputerNameWin), timetoStr(time),mbversion]), 11);
  SearchAndCopy(memo1.lines, '#net',Format('DNS: %s; local IPs: %s; local IP: %s',
       [getDNS, GetLocalIPs, getIPAddress(getComputerNameWin)]), 10);   // *) }
  memo2.Lines.Add('Macro Expanded '+inttostr(memo1.Lines.count-1)+' lines');
end;

//var it: integer;

procedure Tmaxform1.PSScriptExecute(Sender: TPSScript);
begin
  PSScript.SetVarToInstance('APPLICATION', Application);
  PSScript.SetVarToInstance('SCREEN', SCREEN);
  PSScript.SetVarToInstance('SELF', Self);
  //PSScript.SetPointerToData('Memo1', @Memo1, PSScript.FindNamedType('TSynMemo'));
  PSScript.SetVarToInstance('memo1', memo1);
  PSScript.SetVarToInstance('memo2', memo2);
  PSScript.SetVarToInstance('maxForm1', maxForm1);
  //PSScript.SetVarToInstance('maxForm1', maxForm1);
  PSScript.SetVarToInstance('debugout', debugout);
  PSScript.SetVarToInstance('hlog', hlog);
  PSScript.SetVarToInstance('mouse', mouse);
  psscript.AddRegisteredVariable('mFormatSettings','TFormatSettings');
  // PSScript.SetVarToInstance('formatsettings',TObject(formatsettings));
  //PSScript.SetPointerToData()
    //PSScript.SetVarToInstance('it', it);
  //PSScript.SetPointerToData('maxForm1', @maxForm1, PSScript.FindNamedType('TMaxForm1'));
  //PSScript.SetVarToInstance('stringgrid1', stringgrid1);
end;

// facade and mediator pattern
procedure Tmaxform1.Compile1Click(Sender: TObject);
//var //mybytecode: string;
  var stopw: TStopwatch;
    debugoutform: TDebugoutput; //static;
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
      memo2.Lines.Add('PSXCompiler5: '+PSScript.CompilerErrorToStr(l)+#13#10 +m);
      //memo1.SetBookmark(8,2,memo1.CaretY);
      if (not b) and (PSScript.CompilerMessages[l] is TIFPSPascalCompilerError)
      then begin
        b:= True;
        memo1.SetBookmark(0,2,memo1.CaretY);
        memo1.SelStart:= PSScript.CompilerMessages[l].Pos;
        //memo1.SetBookmark(8,2,memo1.carety);
        //memo1.SetBookmark(8,2,memo1.CaretY);
        memo2.Lines.Add('syntax error at line: '+inttostr(memo1.CaretY)) ;
        //memo1.Refresh;
      end;
    end;
    if b then begin
       memo2.Lines.Add('XCompiler Message Count: '+inttoStr(PSScript.CompilerMessageCount));
       with ledimage do begin
        Top:= 2;
        visible:= true;
        //picture.bitmap.loadfromResourcename(HINSTANCE,'LED_RED_ON');
          picture.bitmap.loadfromResourcename(HINSTANCE,'LEDREDON');
        memo1.SetBookmark(0,2,memo1.CaretY);
        //memo1.Gutter.BeginUpdate;
       end;
    //bitmap.LoadFromResName }
    end else begin
      memo2.Lines.Add('XCompiler Message Count: '+inttoStr(PSScript.CompilerMessageCount));
     with ledimage do begin
      visible:= false;
     end;
    end;
  end;
begin
  memo2.Lines.Clear;
  if STATExceptionLog then begin
    hlog.StartLogging;
    hlog.AddStr(' ');
    hlog.Add('>>>> Start Script: '+Act_Filename+' {80@}{now}');
    hlog.Add('{@12}From Host: {App_name} of {App_path}');
    hlog.AddStr('Compile Script: '+Act_Filename);
    memo2.Lines.Add('Hot Log Script started');   //*)
  end;
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
  // debig memo2.Lines.Add('XCompiler Scripz: '+memo1.text);
  //showmessage(psscript.script.Text);
  memo2.Lines.Add('Compiling 🐺 '+RCSTRMB +inttostr(memo1.Lines.count-1)+' lines');
  //TPSPascalCompiler transforms to bytecode
  memo2.Lines.Add('Codelines in window: '+inttoStr(memo1.LinesInWindow));
  statusBar1.panels[1].text:= 'Codelines window: '+inttoStr(memo1.LinesInWindow);
  //PSScript.Comp.OnUses:= '';    units
  maxForm1.Caption:= 'maXbox5 64-bit ScriptStudio🎧  '+ExtractFilename(Act_Filename);
   //if pos('#', memo1.lines) > 0 then
    if STATMacro then
        Expand_Macro;
   //memo2.Lines.Add('debug after macro: '+inttoStr(memo1.LinesInWindow));

   // if STATCodefolding then            //new4
     // memo1.ReScanForFoldRanges;

   if PSScript.Compile then begin
   memo2.Lines.Add('compiled: '+inttoStr(memo1.LinesInWindow));
    OutputMessages;
     with ledimage do begin
        visible:= true;
        picture.bitmap.loadfromResourcename(HINSTANCE,'LEDGREENON')
       end;
    memo2.Lines.Add(RCSTRMB +extractFileName(Act_Filename)+' Compiled done: '
                                                         +dateTimetoStr(now()));
    memo2.Lines.Add('--------------------------------------------------------');
    statusBar1.panels[0].text:= RCSTRMB +Act_Filename+' Ct:'
             +dateTimetoStr(now())+' Mem:'+inttoStr(GetMemoryLoad) +'% ';
    if not PSScript.Execute then begin
      //pause;
      //ShowMessage('We do not get this far: '+'param');
      memo1.SelStart := PSScript.ExecErrorPosition;
      memo2.Lines.Add(PSScript.ExecErrorToString +' at '+Inttostr(PSScript.ExecErrorProcNo)
                       +'.'+Inttostr(PSScript.ExecErrorByteCodePosition));
      with ledimage do begin
        parent:= statusbar1;
        align:= alleft;
        picture.bitmap.loadfromResourcename(HINSTANCE,'LEDREDON')
       //bitmap.LoadFromResName
      end;
      memo1.SetBookmark(0,2,memo1.caretY);
    end else begin
    stopw.Stop;
     memo2.Lines.Add(' mX5🐞 executed: '+dateTimetoStr(Now())+
      '  Runtime: '+stopw.GetValueStr +'  Memload: '+inttoStr(uPSI_MaxUtils.GetMemoryLoad) +'% use');
    end;
    statusBar1.panels.items[1].text:= ' Rtime:'+stopw.GetValueStr+' Thr:'+intToStr(numprocessthreads);
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
   { if STATShowBytecode then begin        //refactor 3.9.9.100
      mybytecode:= '';
      //PSScript.Comp.OnUses:= IFPS3ClassesPlugin1CompImport;
      PSScript.GetCompiled(mybytecode);   //compiler.getOutput
      //psscript.Comp.GetOutput(mybytecode);
      showAndSaveBCode(mybytecode);
      statusBar1.panels[1].text:= 'ByteCode Saved: '+mybytecode;
    end;}
     with ledimage do begin
        visible:= false;
       end;
    imglogo.Transparent:= true;
    //mybytecode:= 'memo2.Lines.Add(PSScript.ExecErrorToString +';
    //memo1.lines.add(mybytecode);
    //call to macro    3.9.8.9
   memo1.Hint:= intToStr(memo1.CaretY)+' Cursor: '+memo1.WordAtCursor +' Mouse: '+memo1.WordAtMouse;
  if STATExceptionLog then begin
   hlog.Add('>>>> Stop Script: '+ExtractFileName(Act_Filename)+' {80@}{now}');
   hlog.Add('{RAM--} CompileRun Success! RT: '+perftime);
  end;
  end else begin
    OutputMessages;
    memo2.Lines.Add('Compiling Script mX5 failed');
    memo1.Gutter.BorderColor:= clred;      //4.2.4.80
    if STATExceptionLog then begin
     hlog.AddStr(Act_Filename+ ' failed');
      hlog.Add('>>>> Fail {App_name} {80@}{now}');
    end;
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
     //last exit check line 9008 in upsruntime
end;


procedure Tmaxform1.RubySyntax1Click(Sender: TObject);
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

procedure Tmaxform1.Run1Click(Sender: TObject);
 var stopw: TStopwatch;    //3.8.2
begin
  //runs only precondition compile syntax check
 stopw:= TStopwatch.Create;    //3.8.2
  stopw.Start;
  if not PSScript.Execute then begin
      memo1.SelStart := PSScript.ExecErrorPosition;
      memo2.Lines.Add(PSScript.ExecErrorToString +' at '+Inttostr(PSScript.ExecErrorProcNo)
                       +'.'+Inttostr(PSScript.ExecErrorByteCodePosition));
      with ledimage do begin
        parent:= statusbar1;
        align:= alleft;
        picture.bitmap.loadfromResourcename(HINSTANCE,'LED_RED_ON')
       //bitmap.LoadFromResName
      end;
    end else begin
    stopw.Stop;
    memo2.Lines.Add(' mX5🦊 run mode executed: '+dateTimetoStr(Now())+
    '  Runtime: '+stopw.GetValueStr +'  Memoryload: '+inttoStr(GetMemoryLoad) +'% use');
    stopw.Free;
   end;
end;

function Tmaxform1.RunCompiledScript(bytecode: ansistring; out RTErrors: string): boolean;
begin
 //psscript.LoadExec;
 //result:= psscript.Exec.LoadData(bytecode);
 result:= psscript.Exec.LoadData(bytecode)
    and psscript.Exec.RunScript and (psscript.Exec.ExceptionCode = erNoError);
 if not result then RTErrors:= PSErrorToString(psscript.Exec.ExceptionCode,'');
 //psscript.RuntimeImporter.CreateAndRegister(psscript.exec,false);
end;

function Tmaxform1.RunCompiledScript2(Bytecode: AnsiString; out RuntimeErrors: String): Boolean;
var
  Runtime: TPSExec;
  ClassImporter: TPSRuntimeClassImporter;
  stopw: TStopwatch;    //3.9.9.120
  bycout: string;

begin
  stopw:= TStopwatch.Create;    //3.8.2
  stopw.Start;
  Runtime:= TPSExec.Create;
  //ClassImporter := TPSRuntimeClassImporter.CreateAndRegister(Runtime, false);
  try
    //ExtendRuntime(Runtime, ClassImporter);
    //IFPS3ClassesPlugin1ExecImport(Self, runtime, classImporter);
  //x: TIFPSRuntimeClassImporter);
   // PSScript1Compile(PSScript1);
   // PSScript1ExecImport(PSScript1, runtime, PSScript1.RuntimeImporter);
    PSScriptExecute(PSScript);   //3.9.9.101

    result:= psscript.Exec.LoadData(bytecode)
    and psscript.Exec.RunScript and (psscript.Exec.ExceptionCode = erNoError);
    if not result then RunTimeErrors:= PSErrorToString(psscript.Exec.ExceptionCode,'');

 {  PSScript.RuntimeImporter.CreateAndRegister(runtime, false);
    Result:= Runtime.LoadData(Bytecode)
          and Runtime.RunScript
          and (Runtime.ExceptionCode = erNoError);  }
     memo2.lines.add(bytecode);
    //PSScript1.SetCompiled(Bytecode);
    if not result then begin
      IFPS3DataToText(Bytecode,bycout);
      memo2.lines.add(bycout);
    end;  //}
    //if not Result then
      //RuntimeErrors:=  PSErrorToString(Runtime.LastEx, '');
  finally
    //ClassImporter.Free;
    Runtime.Free;
  end;
    stopw.Stop;
    memo2.Lines.Add(' mX5 byte code executed: '+dateTimetoStr(Now())+
    '  Runtime: '+stopw.GetValueStr +'  Memload: '+inttoStr(GetMemoryLoad) +'% use');
    stopw.Free;
end;

//helper
function LoadFile(const FileName: TFileName): string;
   begin
     with TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite) do begin
       try
         SetLength(Result, Size);
         Read(Pointer(Result)^, Size);
       except
         Result := '';  // Deallocates memory
         Free;
         raise;
       end;
       Free;
     end;
   end;

   //helper
function LoadFile2(const FileName: TFileName): ansistring;
   begin
     with TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite) do begin
       try
         SetLength(Result, Size);
         Read(Pointer(Result)^, Size);
       except
         Result := '';  // Deallocates memory
         Free;
         raise;
       end;
       Free;
     end;
   end;



procedure Tmaxform1.LoadBytecode1Click(Sender: TObject);
var bcerrorcode, afilename: string;
    sdata: ansistring;
begin
 with TOpenDialog.Create(self) do begin
    Filter:= 'ByteCode files (*.psb)|*.PSB';
    FileName:= '*.psb';
    defaultExt:= fileextension;
    title:= 'PascalScript ByteCode Open';
    InitialDir:= ExtractFilePath(forms.application.ExeName)+'\examples\*.psb';
    //SetCurrentDir(ExtractFilePath(ParamStr(0)));   //3.9.9.100
    if execute then begin
    //filename:=
     Memo2.lines.add('ByteCode Start of: '+filename+' '+datetimetostr(now)); //end else
      sdata:= loadFile2(filename);
    //filename:= ExtractFilePath(ParamStr(0)) + ChangeFileExt(SCRIPTFILE,'.out');
         if MessageDlg(RCSTRMB+': Run ByteCode now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
         if RunCompiledScript2(sdata, bcerrorcode) then begin
            sysutils.beep;
            showmessage('Byte Code Run Success!');
         Memo2.lines.add('ByteCode Success Message of: '+filename+' '+bcerrorcode); //end else
        end else
      Memo2.lines.add('ByteCode Error Message: '+bcerrorcode); //end else
     //end;   //}
    end;//end;
  //this open and free
    Free;
  end;
end;


procedure Tmaxform1.mnConsole2Click(Sender: TObject);
begin
  mnConsole2.Checked:= not mnConsole2.Checked;
  memo2.Visible:= mnConsole2.Checked;
//console  , output or shell
end;

procedure Tmaxform1.mnCoolbar2Click(Sender: TObject);
begin
  mnCoolbar2.Checked:= not mnCoolbar2.Checked;
  Coolbar1.Visible:= mnCoolbar2.Checked;
end;

procedure Tmaxform1.mnSplitter2Click(Sender: TObject);
begin
  mnSplitter2.Checked:= not mnSplitter2.Checked;
  Splitter1.Visible:= mnSplitter2.Checked;
end;

procedure Tmaxform1.mnStatusbar2Click(Sender: TObject);
begin
  mnStatusBar2.Checked:= not mnStatusBar2.Checked;
  StatusBar1.Visible:= mnStatusBar2.Checked;
//status in menu view
end;

procedure Tmaxform1.mnToolbar1Click(Sender: TObject);
begin
  mnToolBar1.Checked:= not mnToolBar1.Checked;
  ControlBar1.Visible:= mnToolbar1.Checked;
  //toolbar in view
end;

procedure Tmaxform1.open1Click(Sender: TObject);
begin
  with TOpenDialog.Create(self) do begin
    Filter:= PSTEXT + '|' + PSMODEL + '|' + PSPASCAL + '|' + PSINC +'|'+ PSALL;
    //Filter:= 'Text files (*.txt)|*.TXT|Model files (*.uc)|*.UC';
    FileName:= '*.txt;*.pas';
    defaultExt:= fileextension;
    title:= 'PascalScript File Open';
    InitialDir:= ExtractFilePath(forms.application.ExeName)+'*.txt';
    if execute then begin
      if STATedchanged then begin
         sysutils.beep;
         if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
         Save2Click(self)
      end else
        STATEdchanged:= false;
         memo1.onchange:= Nil;
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
      maxForm1.Caption:= 'maXbox5 64bit ScriptStudio:  '+ExtractFilename(Act_Filename);
       memo1.onchange:= memo1change;
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
    memo1.Gutter.BorderColor:= clwindow;      //3.9.9.100
end;

procedure Tmaxform1.Saveas3Click(Sender: TObject);
begin
  with TSaveDialog.Create(self) do begin
    Filter:= PSTEXT + '|' + PSINC + '|' + PSPASCAL +'|'+ PSALL;
    //Filename:= '*.txt';
    {if Act_Filename <> '' then begin
      last_fName:= Act_Filename;
      memo2.Lines.Add(extractFileName(last_fName) + BEFOREFILE);    //beta
      loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
    end;}
    FileName:= Act_Filename;
    defaultExt:= fileextension;
    options:= options+[ofOverwritePrompt];   //3.9.9.20
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
      maxForm1.Caption:= 'maXbox5 ScriptStudio:  '+ExtractFilename(Act_Filename);
       // add last file to the deffile
      SaveFileOptionsToIni(FileName);
      STATEdchanged:= false;
      statusBar1.panels[2].text:= ' S';
   //  CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
   if AnsiCompareFileName(last_fname, FileName) <> 0 then begin
     CB1SCList.Items.Add((Act_Filename));   //3.8 wb    3.9.3
     CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
   end;
    end;
   Free;
  end
end;

procedure Tmaxform1.SaveasUnicode1Click(Sender: TObject);
begin
  Saveasunicode1.Checked:= not saveasunicode1.Checked;
   if Saveasunicode1.Checked then begin saveasunicode;
     memo2.lines.Add('----saveasunicode() click - now utf8 saved!----')
   end;
   if not Saveasunicode1.Checked then begin
    //saveasansi;
    case MessageDlg(Format(RCSTRMB+': '+'ANSI Save - all Unicode/UTF8 signs will be lost!',
                   [act_filename]),mtConfirmation,
    [mbYes,mbNo,mbcancel], 0) of
      idYes: begin
              saveasAnsi;
              //memo1.Lines.Clear;
               memo2.lines.Add('----saveasansi() click - now saved as ANSI!----');
            end;
      idCancel: begin
                 memo2.lines.Add('Cancel Clicked - Try again to save now as Unicode');
                 //CanClose := False;  //Action:= caNone;
               end;
      idNo: memo2.lines.Add('No Clicked - back to mX5') //   Action:= caFree;
    end;
   end;
end;

procedure Tmaxform1.Save2Click(Sender: TObject);
begin
  if Act_Filename <> '' then begin
    memo1.Lines.SaveToFile(Act_Filename);
    memo2.Lines.Add(Act_Filename +' File stored');
    SaveFileOptionsToIni(Act_Filename);
    STATEdchanged:= false;
    statusBar1.panels[2].text:= ' S';
    memo1.Gutter.BorderColor:= clgreen;      //3.9.9.100
  end else
    Saveas3Click(sender);
end;

procedure Tmaxform1.Savebefore1Click(Sender: TObject);
begin
 Savebefore1.Checked:= not Savebefore1.Checked;
 if Savebefore1.Checked then STATSavebefore:= true else
   STATSavebefore:= false;
end;

procedure Tmaxform1.SaveByteCode;
begin
  SBytecode1Click(self);
end;

function Tmaxform1.GetPSScript: TPSScript;
begin
  result:= maxForm1.PSScript;
end;


procedure Tmaxform1.WebCam1Click(Sender: TObject);
begin
  //start webcam
  memo2.Lines.Add(getVideoDrivers +'web cam started - try once');
  try
    doWebCamPic(Exepath+'mxwebcampic5.png');
  except
    memo2.Lines.Add('WebCam failed - try again ');
  end;//*)
end;

procedure Tmaxform1.WebScanner1Click(Sender: TObject);
begin
 WebMapperDemoMainFrm:= TWebMapperDemoMainFrm.Create(Self);
  try
    WebMapperDemoMainFrm.ShowModal
  finally
    WebMapperDemoMainFrm.Free;
  end;  //}
end;


procedure Tmaxform1.WebScannerDirect(urls: string);
begin
 WebMapperDemoMainFrm:= TWebMapperDemoMainFrm.Create(Self);
  try
    WebMapperDemoMainFrm.UrlEdit.Text:= urls;
    WebMapperDemoMainFrm.RunFirst;
    WebMapperDemoMainFrm.ShowModal;
    //WebMapperDemoMainFrm.ParseBtnClick(self);
   finally
    WebMapperDemoMainFrm.Free;
  end;  //}
end;


procedure Tmaxform1.WebServer1Click(Sender: TObject);
begin
   HTTPServerStartExecute(self);
  //add seq in 3.9.9.96
  //ShowMessage('https server available in V4'+#13#10+
    //            'first example in: ..\examples\303_webserver');
 //start to webserver2
end;

procedure Tmaxform1.WMCopyData(var Msg: TWMCopyData);
var
  sText: array[0..99] of Char;
begin
  // generate text from parameter
  // anzuzeigenden Text aus den Parametern generieren
  StrLCopy(sText, Msg.CopyDataStruct.lpData, Msg.CopyDataStruct.cbData);
  // write received text
  // Empfangenen Text ausgeben
  memo2.lines.add(sText);
end;


procedure Tmaxform1.WMDROP_THEFILES(var message: TWMDROPFILES);
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
    memo1.onchange:= Nil;     //to prevent do change at first
   with Memo1 do begin
     Lines.clear;
     //Grab the name of a dropped file
     dragQueryFile(hDroppedFile, 0, @bFilename, sizeOf(bFilename));
     //check ansistrings
     Lines.loadFromFile(StrPas(bFilename));
   end;
    memo1.onchange:= memo1change;     //to prevent do change at first
   Act_Filename:= strpas(bFilename);   //fix5   fixed
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
    memo1.Gutter.BorderColor:= clwindow;      //3.9.9.100
   //if intfnavigator1.checked then LoadInterfaceList;
    //else      lbintflist.Free;
end;

procedure Tmaxform1.Largefont1Click(Sender: TObject);
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

 {procedure TpsForm1.btnSaveCompClick(Sender: TObject);
var
  OutFile, sdata: string;
  Fx: Longint ;
begin
  PSScript1.GetCompiled(sData);
  OutFile:= ExtractFilePath(ParamStr(0)) + ChangeFileExt(SCRIPTFILE,'.out');
  Fx:= FileCreate(OutFile) ;
  FileWrite(Fx,sData[1],Length(sData));
  FileClose(Fx) ;
end;}


procedure Tmaxform1.showAndSaveBCode(const bdata: ansistring);
var outfile: string;
    fx: longint;
begin
 //numWritten:= 0;
 //outfile:= ExtractFilePath(paramstr(0))+extractFilename(act_filename)+BYTECODE;
 outfile:= ExtractFilePath(ParamStr(0))+'examples\'+
        ChangeFileExt(extractFilename(act_filename),'.psb');
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
 memo2.Lines.Add('-----PS-BYTECODE (PSB) mX4-----'+timetostr(time));
 memo2.Lines.Add('-----BYTECODE saved as: '+outfile+' -----');
 memo2.Lines.Append(bdata);
   //delete(locstr, 80, length(locstr)-80);  //after cut
end;

procedure Tmaxform1.SBytecode1Click(Sender: TObject);
var mybytecode: ansistring;
begin
 //sBytecode1.Checked:= not sBytecode1.Checked;
 //if sBytecode1.Checked then STATShowBytecode:= true else
   //STATShowBytecode:= false;
    //if STATShowBytecode then begin
      mybytecode:= '';
      //PSScript.Comp.OnUses:= IFPS3ClassesPlugin1CompImport;
      PSScript.GetCompiled(mybytecode);   //compiler.getOutput  !! bccompatible
      //psscript.Comp.GetOutput(mybytecode);
      showAndSaveBCode(mybytecode);
      statusBar1.panels[1].text:= 'ByteCode Saved: '+mybytecode;
    //end;
end;

procedure Tmaxform1.ScriptExplorer1Click(Sender: TObject);
var listform: TFormListView;
begin
 listform1:= TFormListview.Create(self);
    if not (listform1.hasClosed) then begin
    with listform1 do
      Show;
    end else begin
   listform1:= TFormListview.Create(self);
   listform1.Show;
  end; //}
end;

procedure Tmaxform1.ScriptListbox1Click(Sender: TObject);
begin
  //CB1SCList.SetFocus;
  CB1SCList.DroppedDown:= true;
  CB1SCList.SetFocus;
end;

procedure Tmaxform1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //if Key = #27 then Close;
  if Key = #27 then begin
   // if assigned(cb1sclist) then
    //FreeAndNIL(cb1sclist);  //prevent invalid pointer op!
   Close;
  end;
end;

procedure Tmaxform1.FormOutput1Click(Sender: TObject);
begin
  //redirect the memo2 in form
  formOutput1.Checked:= not formOutput1.Checked;
  if formOutput1.Checked then STATformOutput:= true else
   STATformOutput:= false;
  memo2.Lines.add('Switch: next compile output will result in window');
  //  memo2.Lines.SaveToFile(Act_Filename+'Output'+'.txt');
end;


procedure Tmaxform1.FPlot1Click(Sender: TObject);
begin
   Application.CreateForm(TfplotForm1, fplotForm1);
   fplotForm1.show;
   fplotForm1.btnPlot.Click;
end;

procedure Tmaxform1.FractalDemo1Click(Sender: TObject);
begin
 winformp.SetFractalForm(875, 895);
 //getrvalue
 //writeln(screensize)
end;

procedure Tmaxform1.FullTextFinder1Click(Sender: TObject);
begin
  //full text finder
  //winformp.
   Application.CreateForm(TwinFormp, winFormp);
   winformp.Height:= 1100;
   winformp.Width:= winformp.Width+200;
   winformp.finderactive:= true;
   //StartFileFinder;     //Full Text Finder
end;

procedure Tmaxform1.Checkers1Click(Sender: TObject);
begin
  // fplotForm1.show;
  //checkers gamer
  Application.CreateForm(TchkMainForm, chkMainForm);
   chkMainForm.Show ;
  //Application.Run;
end;

procedure Tmaxform1.Chess41Click(Sender: TObject);
begin
  //this is chess game
  ///chessbrd.Register;
  //Application.CreateForm(TChessForm1, chessform1);
  //chessform1.Show   //thread!!
  //begin
  //fixed to mX52 with inlline StrPas()
  chessform1:= TChessForm1.Create(Self);
  try
    chessform1.ShowModal
  finally
    chessform1.Free;
  end;    //}
end;

procedure Tmaxform1.CipherFile1Click(Sender: TObject);
begin
  //showmessage('CipherBox available in mX3.5')
  WinFormp.SetCryptForm;
end;

procedure Tmaxform1.CreateDLLStub1Click(Sender: TObject);
begin
//ShowMessage('https server available in V4'+#13#10+
    //            'first example in: ..\examples\303_webserver');
 memo2.Lines.add('Function OpenProcess2(dwDesiredAccess: DWORD; bInheritHandle:BOOL;'+#13#10+
                                          '     dwProcessId:DWORD): THandle; '+#13#10+
                          '          External ''OpenProcess@kernel32.dll stdcall'';');
end;

procedure Tmaxform1.CreateGUID1Click(Sender: TObject);
var Guid: TGUID;
begin
 //bold
 CreateGUID(Guid);
   memo2.Lines.add(GUIDToString(GUID));
end;

procedure Tmaxform1.CreateHeader1Click(Sender: TObject);
begin
  if fileExists(ExtractFilePath(ParamStr(0))+ CODECOMPLETION) then
       maxForm1.fAutoComplete.ExecuteCompletion('header',memo1) else
      showMessage('The file '+CODECOMPLETION+' is missing');
    statusBar1.panels[0].text:= 'Header Template loaded: '+inttoStr(memo1.LinesInWindow-1);
 // is in file template
end;

procedure Tmaxform1.CryptoBox1Click(Sender: TObject);
begin
  //crypto box  AES
    WinFormp.SetCryptFormAES;
end;


procedure Tmaxform1.Clear1Click(Sender: TObject);
begin
  if MessageDlg('mX4 Welcode to '+RCSTRMB+ ' Clear code memo now?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin
    if STATedchanged then begin
         sysutils.beep;
         if MessageDlg(RCSTRMB+': Save Code Changes now?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then
         Save2Click(self);
         statusBar1.panels[2].text:= ' S';
         memo1.Gutter.BorderColor:= clgreen;
       end else
        STATEdchanged:= false;
    last_fName:= Act_Filename;
    loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
    memo1.Lines.Clear;
    memo1.lines.Add('----code_cleared_checked_clean----');
    STATEdchanged:= false;
    statusBar1.panels[2].text:= ' SM';
    Act_Filename:= '';
       memo1.Gutter.BorderColor:= clwindow;      //4.2.4.80
   end
end;

procedure Tmaxform1.lineToNumber(met: boolean);
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

procedure Tmaxform1.Slinenumbers1Click(Sender: TObject);
begin
  if Slinenumbers1.Checked then lineToNumber(true)
    else lineToNumber(false)
end;


procedure Tmaxform1.Sniffer1Click(Sender: TObject);
begin
   Application.CreateForm(TsniffForm, sniffForm);
   sniffForm.Show;
   memo2.lines.add('web sniffer wiremax started at: ' +DateTimeToStr(Now));   //}
end;

procedure Tmaxform1.SOAPTester1Click(Sender: TObject);
begin
  // Application.CreateForm(TSoapForm, SoapForm);
  // SoapForm.Show;
  //Application.CreateForm(TWSDLPicker, WSDLPicker);
end;

procedure Tmaxform1.SocketServer1Click(Sender: TObject);
begin
  //borland socket Server
    CreateMutex(nil, True, 'SCKTSRVR');
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      MessageBox(0, PChar('SocketAlreadyRunning'), 'BorlandSocketServer', MB_ICONERROR);
      Halt;
    end;
  if StartSocketService then begin
    StartSocketServiceForm;
     memo2.Lines.add('Switch: StartSocketService');
    {SvcMgr.Application.Initialize;
    SocketService := TSocketService.CreateNew(SvcMgr.Application, 0);
    SvcMgr.Application.CreateForm(TSocketForm, SocketForm);
    SvcMgr.Application.Run;}
  end else begin
    //Application.ShowMainForm := False;
    //SocketForm:= TSocketForm.Create(NIL);
    memo2.Lines.add('Switch: StartSocketServiceForm_Create');
    //SocketForm.ShowModal;
    //Application.Initialize;
    Application.CreateForm(TSocketForm, SocketForm);
    SocketForm.Show;
    SocketForm.Initialize(False);
    //SocketForm.Free;
    //Application.Run;
  end;     // *)
end;

procedure Tmaxform1.Sort1IntflistClick(Sender: TObject);
begin
//sort intflist
  if intfnavigator1.checked then
     lbintflist.Sorted:= true;
end;

procedure Tmaxform1.defFileread;
var deflist: TStringlist;
     filepath, fN: string;
begin
deflist:= TStringlist.create;
filepath:= ExtractFilePath(forms.Application.ExeName);
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
      last_fName9:= (deflist.Values['PRELAST_FILE9']);
      last_fName10:= (deflist.Values['PRELAST_FILE10']);

      loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
      last_fontsize:= strtoint((deflist.values['FONTSIZE']));
      if deflist.values['FONTNAME'] <> '' then
           memo1.Font.Name:= deflist.values['FONTNAME']; //)
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
      try
        ExternalApp:= deflist.Values['APP'];       //3.9.9.110
        if fileexists(ExternalApp) then
          ExternalApp1.Caption:= 'App: '+extractfilename(ExternalApp);
      except
        ExternalApp1.Caption:= 'External App';
        //ExternalApp:= last_fName1;
      end;
      try
        ExternalApp2:= deflist.Values['APP2'];       //4.2.8.10
        if fileexists(ExternalApp2) then
          ExternalApp22.Caption:= 'App2: '+extractfilename(ExternalApp2);
      except
        ExternalApp22.Caption:= 'External App2';
        //ExternalApp:= last_fName1;
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
      if deflist.Values['DEBUG'] = 'Y' then       //V5.0.2
              STATDebugCheck:= true else
              STATDebugCheck:= false;

      if deflist.Values['AUTOBOOKMARK'] = 'Y' then   //3.9.9.84
              STATAutoBookmark:= true;
      if deflist.Values['AUTOBOOKMARK'] = 'N' then   //3.9.9.84
              STATAutoBookmark:= false;
       if deflist.Values['INDENT'] = 'Y' then    //new4
        STATCodefolding:= true else
         STATCodefolding:= false;

      if deflist.Values['INDENT'] = '' then   //3.9.9
              STATCodefolding:= true;
        
      if deflist.Values['DEP'] = 'Y' then begin  //4.2.8.10
              uPSI_UtilsMax4.ActiveDEP;
        memo2.Lines.Add('DataExecutionPrevention DEP active .ini: '+timetostr(time));
      end;

   //STATVersionCheck
    end else begin
      // init values case of no file  ini template
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
      deflist.values['PRELAST_FILE9']:= 'FILENAME9'; //Def_FName;
      deflist.values['PRELAST_FILE10']:= 'FILENAME10'; //Def_FName;

      deflist.values['FONTSIZE']:= '11';
      deflist.values['EXTENSION']:= 'txt';
      deflist.Values['SCREENX']:= '950';
      deflist.Values['SCREENY']:= '825';
      deflist.Values['MEMHEIGHT']:= '175';
      deflist.Values['PRINTFONT']:= 'Courier New';
      deflist.Values['FONTNAME']:= 'Courier New';
      deflist.Values['LINENUMBERS']:= 'Y';
      deflist.Values['EXCEPTIONLOG']:= 'Y';
      deflist.Values['EXECUTESHELL']:= 'Y';
      deflist.Values['BOOTSCRIPT']:= 'Y';
      deflist.Values['MEMORYREPORT']:= 'N';
      deflist.Values['INDENT']:= 'Y';           //new4
      deflist.Values['DEP']:= 'Y';           //new4
      deflist.Values['NAVIGATOR']:= 'N';
      deflist.Values['MACRO']:= 'Y';
      deflist.Values['AUTOBOOKMARK']:= 'Y';
      deflist.Values['COMPORT']:= '3';
      deflist.Values['NAVWIDTH']:= '350';
      deflist.add('[WEB]'); //ini file compatible mX3
      deflist.Values['ROOTCERT']:= 'filepathY';
      deflist.Values['SCERT']:= 'filepathY';
      deflist.Values['RSAKEY']:= 'filepathY';
      deflist.Values['IPHOST']:= '127.0.0.1';
      deflist.Values['IPPORT']:= '8080';
      deflist.Values['VERSIONCHECK']:= 'N';
      deflist.Values['APP']:= 'C:\WINDOWS\System32\Calc.exe';
      deflist.Values['MYSCRIPT']:= 'E:\maxbox5\mXGit50120\maxbox5\examples\330_myclock.txt';
      deflist.Values['DEP']:= 'Y';

      deflist.SaveToFile(fN);
    end;
  finally
    deflist.Free
 end;
end;

procedure Tmaxform1.defFilereadUpdate;
var deflist: TStringlist;
     filepath, fN: string;
begin
deflist:= TStringlist.create;
filepath:= ExtractFilePath(forms.Application.ExeName);
  try
    fN:= filepath+ DEFINIFILE;
    if fileexists(fN) then begin
      deflist.LoadFromFile(fN);
      last_fontsize:= strtoint((deflist.values['FONTSIZE']));
      if deflist.values['FONTNAME'] <> '' then
           memo1.Font.Name:= deflist.values['FONTNAME']; //)
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
      if deflist.Values['AUTOBOOKMARK'] = 'Y' then   //3.9.9.84
              STATAutoBookmark:= true;
      if deflist.Values['AUTOBOOKMARK'] = 'N' then   //3.9.9.84
              STATAutoBookmark:= false;
   //
     //STATVersionCheck
     end;
  finally
    deflist.Free
 end;
end;


procedure Tmaxform1.SaveFileOptionsToIni(const filen: string);
var filepath, fN: string;
begin
 filepath:= ExtractFilePath(forms.Application.ExeName);
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
    last_fName8:= items[items.Count-10];     //3.9.9.88
    last_fName9:= items[items.Count-11];
    last_fName10:= items[items.Count-12];

    //memo2.lines.add('ini hist debug' +items[items.Count-1]);
    end;
  end;

 if fileexists(fN) then begin
   with TStringlist.Create do begin
    //end;
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
     Values['PRELAST_FILE9']:= last_fName9;
     Values['PRELAST_FILE10']:= last_fName10;

     Values['FONTSIZE']:= inttoStr(last_fontsize);
     Values['FONTNAME']:= memo1.Font.Name;
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
  memo2.Lines.Add(extractFileName(filen) +' in maxboxdef.ini stored: '+timetostr(time));
  statusBar1.panels[0].text:= last_fName +' last in .ini stored';
 end;
end;   //*)

procedure Tmaxform1.LoadFileNameFromIni;
begin
 with TStringlist.Create do begin
   LoadFromFile(DEFINIFILE);
   try
     memo1.onchange:= Nil;     //to prevent do change at first
     memo1.Lines.LoadFromFile(values['LAST_FILE']);
   //set act filename
     Act_Filename:= values['LAST_FILE'];
     memo2.Lines.Add(Act_Filename + FILELOAD);
     statusBar1.panels[0].text:= Act_Filename + FILELOAD;
   except
     Showmessage('Invalid File Path - Please Set <File Open/Save As...or open maxboxdef.ini.Backup>');
     memo1.Lines.LoadFromFile(values['PRELAST_FILE']);
     Act_Filename:= values['PRELAST_FILE'];
     Showmessage('Prelast file loaded: '+Act_Filename + FILELOAD);
     memo2.Lines.Add('Exception! Prelast file loaded: '+Act_Filename + FILELOAD);
   end;
   Free;
 end;
  memo1.onchange:= Memo1Change;
end;


procedure Tmaxform1.LinuxShellScript1Click(Sender: TObject);
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

Procedure Tmaxform1.LoadBootScript;
var filepath, fN: string;   //bcerrorcode
    i: longint;
    vresult: boolean;
begin
 filepath:= ExtractFilePath(forms.Application.ExeName);
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


procedure Tmaxform1.About1Click(Sender: TObject);
begin
  ShowinfoBox('About maXbox5 - maxbox5.wordpress.com/', RCSTRMB,(MBVERSION),true);
  statusBar1.Font.color:= clblue;
  statusBar1.panels[0].text:= MXSITE +' ***\/*** '+MXMAIL;
end;



//this section describes search & replace functions
// OnFind routine for find text
procedure Tmaxform1.FileChanges1Click(Sender: TObject);
var  drive: shortstring;
    mycf: TChangeFinder;
    alistview: TListbox;
begin
// this is hope
  alistview:= CreateDBGridForm(TStringlist.create);
    screen.cursor:=crHourglass;
    //drive:= dcbHD.Drive;
    //drive:= drive + ':';
    //drive:= drive + 'E:';
    drive:= Exepath;
    alistview.BorderStyle:= bsSingle; //bsSizeable; //bsSingle;
    alistview.color:= clcream;
    alistview.AutoComplete:= true;
    //alistview.gridlines;
    mycf:= TChangeFinder.Create_prepList_and_Date(alistview);
    mycf.SearchDirectories(drive + '\','*.*');
    alistview.items.savetofile(exepath+'mXfileChangeToday_list.txt');
    searchAndOpenDoc(ExePath+'mXfileChangeToday_list.txt');
    mycf.Free;
    //alistview.Free;
    screen.cursor:=crDefault;     //*)
end;

procedure Tmaxform1.FindFunction1Click(Sender: TObject);
begin
  ShowMessage('Add On available in V53')
end;

procedure Tmaxform1.FindNextText(Sender: TObject);
begin
  with FindReplDialog do begin
  //showmessage(inttostr(length(findtext)));   debug
    if Length(FindText)=0 then SysUtils.Beep else begin
      //btnSearch.SetFocus;
      //cbCase.Checked:= false;
      //Options:= options-[ssoMatchCase];
      //memo1.SearchReplace(lowercase(FindText),'',Options);
      if (memo1.SearchReplace(FindText,'',Options)= 0) {or
         (memo1.SearchReplace(uppercase(Findtext),'',Options)= 0) or
          (memo1.SearchReplace(lowercase(Findtext),'',Options)= 0)} then begin
        SysUtils.Beep;
        ShowMessage('"'+FindText+'" not found yet!');
        end;
      end;
      //Options:= options+[ssoMatchCase];
    end;
  end;

procedure Tmaxform1.FindNextTextEnd(Sender: TObject);
begin
  with FindReplDialog do begin
  //showmessage(inttostr(length(findtext)));   debug
    if Length(FindText)=0 then SysUtils.Beep else begin
      //btnSearch.SetFocus;
      //cbCase.Checked:= false;
      Options:= options+[ssoWholeWord];
      //memo1.SearchReplace(lowercase(FindText),'',Options);
      if (memo1.SearchReplace(FindText,'',Options)> 0) or
          (memo1.SearchReplace(uppercase(Findtext),'',Options)> 0) or
          (memo1.SearchReplace(lowercase(Findtext),'',Options)> 0) then
        SysUtils.Beep else
        ShowMessage('"'+FindText+'" not found yet!');
        //end;
      end;
      Options:= options-[ssoWholeWord];
    end;
  end;

// OnReplace routine for replace text
procedure Tmaxform1.ReplaceNextText(Sender: TObject);
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

procedure Tmaxform1.Search1Click(Sender: TObject);
var SearchOptions: TSynSearchOptions;
begin
  with FindReplDialog do begin
  //procedure TFindReplDialog.rgpStartClick(Sender: TObject);
    rgpStart.ItemIndex:= 0;  //set back to from cursor
    Exclude(SearchOptions, ssoMatchCase);
    Findtext:= UpdateFindtext;
    //btnSearch.SetFocus;
    OnFind:= FindNextText;
    Execute(false);
   //btnSearch.SetFocus;
  end;
end;

procedure Tmaxform1.GEOMapView1Click(Sender: TObject);
begin
 //get geo map mapbox
 //getGEOMapandRunAsk
end;

function Tmaxform1.GetActFileName: string;
begin
  result:= Act_Filename;
end;

function Tmaxform1.GetScriptPath: string;
begin
  result:= extractfilepath(Act_Filename);
end;

procedure Tmaxform1.SetActFileName(vname: string);
begin
  Act_Filename:= vname;
end;

function Tmaxform1.GetLastFileName: string;
begin
  result:= Last_fName;
end;

function Tmaxform1.GetPerftime: string;
begin
  result:= perftime;
end;

procedure Tmaxform1.ResetKeyPressed;
begin
  fKeypressed:= false;
end;

procedure Tmaxform1.setKeyPressed;
begin
  fKeypressed:= true;
end;

procedure Tmaxform1.SetLastFileName(vname: string);
begin
  Last_fName:= vname;
end;

function Tmaxform1.GetClientTop : integer;
begin
  Result:= Height-ClientHeight + Coolbar1.Height+ControlBar1.Height+15;
end;

procedure Tmaxform1.Undo1Click(Sender: TObject);
begin
  memo1.Undo; //check unlockundo
end;


function Tmaxform1.UpdateFindtext : string;
begin
  with memo1 do begin
    if SelAvail then Result:= SelText
    else Result:= wordAtCursor;
  end;
end;

procedure Tmaxform1.UpdateService1Click(Sender: TObject);
begin
    //if MBVER < MBVER then getfileversion//get from internet text file
  screen.cursor:=crHourglass;
  //ShowinfoBox('Get the last Update and News ', RCSTRMB,(MBVERSION), false);
  screen.cursor:=crDefault;
  statusBar1.Font.color:= clblue;
  statusBar1.panels[0].text:= MXSITE +' ***\News and Updates/*** '+MXMAIL;
  //showmessage('Updater at V3.5, now go to: www.softwareschule.ch/maxbox.htm');
 // memo2.lines.Add(' Actual Version is: '+VersionCheckAct);
 // memo2.lines.Add(' Checked Version: '+checkBox);
end;

procedure Tmaxform1.Memo1ReplaceText(Sender: TObject; const ASearch,
  AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  mPos: TPoint;
begin
  //mPos:= memo1.RowColumnToPixels(DisplayCoord(Column,Line+1));
  with mPos do begin
    x:= x+Left;
    Y:= Y+Top+GetClientTop;
  end;
  Action:= ConfirmReplDialog.Execute(mPos,Format(RCReplace,[ASearch,AReplace]));
end;

procedure Tmaxform1.Memo1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
const
  ModifiedStrs: array[boolean] of string = ('', 'Modified');
var  p: TBufferCoord;
 begin
  if Changes*[scCaretY,scCaretX]<>[] then begin
    with FindReplDialog do if Visible and not Searching then
                             FindText:= UpdateFindtext;
   Statusbar1.Panels[1].Text:= Format('Row:%6d-Col:%3d s:%5d',
       [memo1.CaretY, memo1.CaretX, memo1.SelStart]);
   if Changes * [scAll, scCaretX, scCaretY] <> [] then
     memo1.Hint:= intToStr(memo1.CaretY)+' Cursor: '+memo1.WordAtCursor +'  Mouse: '+memo1.WordAtMouse;
   if Not activelinecolor1.checked and NOT StatActiveyellow then
      memo1.ActiveLineColor:= factivelinecolor else
      memo1.ActiveLineColor:= clWebFloralWhite;
  end;
  if activelinecolor1.checked and StatActiveyellow then
      memo1.ActiveLineColor:= clYellow;
    //   else memo1.ActiveLineColor:= clNone;
  //if Changes * [scAll, scModified] <> [] then begin     fix 11
   // Statusbar1.Panels[1].Text:= ModifiedStrs[memo1.Modified];
    //memo1.Gutter.BorderColor:= clyellow;
     //if STATCodefolding then
       // memo1.ReScanForFoldRanges;              //new4
  //end;

  {if Changes * [scAll, scCaretX, scCaretY] <> [] then begin
    p:= memo1.CaretXY;
    Statusbar1.Panels[0].Text := Format('%6d:%3d',[p.Line, p.Char]);
    //ResetMarkButtons;
  end;}
end;

procedure Tmaxform1.Memo2KeyPress(Sender: TObject; var Key: Char);
begin
  //keypressed simulates the dos shell
  fkeypressed:= true;
  Statusbar1.Panels[1].Text:= ' isKeyPressed on Shell at '+timetoStr(time);
  //memo2.Lines.Add('ShellCompiler: isKeyPressed at '+DatetimetoStr(Now));
end;

procedure Tmaxform1.Memory1Click(Sender: TObject);
begin
  //memory game
  FormCreateInit(self);
end;

procedure Tmaxform1.MetricReport1Click(Sender: TObject);
begin
  ShowMessage('Add On available in V5.2')
end;

procedure Tmaxform1.midikeyClick(Sender: TObject);
begin
  Application.CreateForm(TForm2clavier, Form2clavier);
  //Form2clavier.Show;
   Application.CreateForm(TmidiForm1, midiForm1);
  midiForm1.Show;
end;

procedure Tmaxform1.Minesweeper1Click(Sender: TObject);
begin
  ShowMessage('Add On available in V5.2 - start now with OK, script: 1419_minesweeper5.TXT');
  //minesweeper game 5
  Application.CreateForm(TGameForm, GameForm);
  Gameform.Show;
end;

procedure Tmaxform1.WordWrap1Click(Sender: TObject);
begin
 wordWrap1.Checked:= not WordWrap1.Checked;
   if WordWrap1.Checked then begin
      memo1.useCodeFolding:= false;
      memo1.WordWrap:= true
   end else begin
      memo1.useCodeFolding:= true;
      memo1.WordWrap:= false;
   end;
end;


procedure Tmaxform1.SearchNext1Click(Sender: TObject);
begin
  FindNextText(self);
end;


procedure Tmaxform1.SerialRS2321Click(Sender: TObject);
begin
  //start to serial rs332
  StartSerialDialog;
end;

procedure Tmaxform1.Replace1Click(Sender: TObject);
begin
  with FindReplDialog do begin
    Findtext:= UpdateFindtext;
    OnFind:= FindNextText;
    OnReplace:= ReplaceNextText;
    Execute(true);
  end;
end;
     (*
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
end;  //*)

procedure Tmaxform1.PythonSyntax1Click(Sender: TObject);
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

procedure Tmaxform1.ShowInclude1Click(Sender: TObject);
begin
 //showInclude1.Checked:= false;
 showInclude1.Checked:= not showInclude1.Checked;
 if showInclude1.Checked then STATInclude:= true else
   STATInclude:= false;
end;

procedure Tmaxform1.ShowIndent1Click(Sender: TObject);  //new4
begin
  showIndent1.Checked:= not showIndent1.Checked;

 //if STATCodefolding     in combination with wordwrap

 if showIndent1.Checked then begin
    memo1.useCodeFolding:= true;
    STATCodefolding:= true;
  end else begin
    //memo1.CodeFolding.IndentGuides:= false; --changed from 10.4 to 11.33
     //memo1.CodeFolding.ShowHintMark  := false;
     memo1.useCodeFolding:= false;
    STATCodefolding:= false;
  end;  //}
end;

procedure Tmaxform1.ShowSpecChars1Click(Sender: TObject);
begin
 showSpecChars1.Checked:= not showSpecChars1.Checked;
 if showSpecChars1.Checked then Memo1.Options:=
                              Memo1.Options +[eoShowSpecialChars] else
 Memo1.Options:= Memo1.Options - [eoShowSpecialChars];
end;

procedure Tmaxform1.ShrinkFontConsole1Click(Sender: TObject);
begin
  memo2.Font.Size:= memo2.Font.Size-1;
  //last_fontsize:= memo1.Font.Size;
end;

procedure Tmaxform1.SimpleBrowser1Click(Sender: TObject);
begin
    Application.CreateForm(TEdgeViewForm, EdgeViewForm);
    edgeviewform.Show;
    //Application.CreateForm(TwebMainForm, webMainForm);
    memo2.lines.Add('----Simple EdgeView Browser started----');
end;

procedure Tmaxform1.SimuLogBox1Click(Sender: TObject);
begin
  //start of the logbox
   winformp.SetLogBoxForm;
end;


procedure Tmaxform1.SkyStyle1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 230;
    color:= clwebgold;  //clblack
    font.size:= 15;
    font.color:= clPurple;
    //clear;
 end;
  maxform1.Color:= clwebgold;
  forms.Application.HintColor:= clYellow;
  //ActiveLineColor1Click(self);
  memo1.activeLineColor:= clskyblue;
  factivelinecolor:= clskyblue;
  memo1.RightEdgeColor:= clPurple;
  memo1.Gutter.Color:= clMoneyGreen;
  //ActiveLineColor1Click(self);
  if intfnavigator1.checked then
    lbintfList.Color:= clskyblue;
end;

procedure Tmaxform1.SynEditPrint1PrintLine(Sender: TObject; LineNumber,
  PageNumber: Integer);
begin
  //fprintout.Footer.Add()
   //fprintout.footer.Print(NIL, pagenumber);
 //fprintout.Footer.DefaultFont.Size:= 7;
 //fprintout.UpdatePages(Printer.Canvas);
 //fprintout.Footer.Add('P: '+IntToStr((pagenumber)), NIL, taRightJustify, 3);
end;

//var ppagenumber: integer;

procedure Tmaxform1.SynEditPrint1PrintStatus(Sender: TObject; Status: TSynPrintStatus;
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

procedure Tmaxform1.SynExport1Click(Sender: TObject);
begin
 // exprt to do
  Application.CreateForm(TSynexportform, Synexportform);
  Synexportform.show;
end;

procedure Tmaxform1.SynMultiSyn1CustomRange(Sender: TSynMultiSyn;
  Operation: TRangeOperation; var Range: Pointer);
begin
//  to be test for filters
end;

//printing procedures--------------------------------------
procedure Tmaxform1.Preview1Click(Sender: TObject);
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

procedure Tmaxform1.Printout1Click(Sender: TObject);
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
   // Footer.Add(GetComputerNameWin+' '+fPrintOut.Title, NIL, taLeftJustify, 1 );
   // Footer.Add(MXSITE, NIL, taLeftJustify, 2);
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
         forms.Application.MessageBox(PChar('SPrintError' +#13#10+E.Message),
                              PChar(fprintout.Title), MB_ICONSTOP + MB_OK);
       end; { on }
    end; { try }
   end; //if
  end;  //with
  Screen.Cursor:= crDefault;
  statusBar1.panels[0].text:= Act_Filename +' is printed';
end;

procedure Tmaxform1.ProcessList1Click(Sender: TObject);
begin
  // processlist of devcc
  //ProcessListForm.Show;
 ProcessListForm:= TProcessListForm.Create(self);
  try
    ProcessListForm.ShowModal;
  finally
    ProcessListForm.Free;
  end;   //}

end;

procedure Tmaxform1.EditFont1Click(Sender: TObject);
begin
  dlgPrintFont1.Font.Assign(memo1.Font);
  if dlgPrintFont1.Execute then begin
    memo1.Font.Assign(dlgPrintFont1.Font);
    last_fontsize:= memo1.Font.Size;
    statusBar1.panels[0].text:= memo1.Font.Name+' font is active';
  end;
   //CaptionEdit.Font := FontDialog1.Font;
end;

procedure Tmaxform1.EditReplace1Click(Sender: TObject);
begin
 //edit replace to enable rename clicked words
  editreplace1.checked:= not editreplace1.checked;
end;

procedure Tmaxform1.EnlargeFontConsole1Click(Sender: TObject);
begin
  memo2.Font.Size:= memo2.Font.Size+1;
  //last_fontsize:= memo1.Font.Size;
end;

procedure Tmaxform1.EnlargeGutter1Click(Sender: TObject);
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

procedure Tmaxform1.Terminal1Click(Sender: TObject);
begin
  Application.CreateForm(TvtMainForm, vtMainForm);
  vtmainForm.Show;
  //
end;

procedure Tmaxform1.TCPSockets1Click(Sender: TObject);
begin
  //this is 26
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter26.pdf');
end;

procedure Tmaxform1.TerminalStyle1Click(Sender: TObject);
var Attri: TSynHighlighterAttributes;
begin
 with memo1 do begin
   TabWidth:= 3;  //3.9.8    //9.9.20
  Options:= DefSynEditOptions;
  Highlighter:= SynPasSyn1;
  //attri:= synpassyn1.Attribute[1];
  //SynPasSyn1.GetCapabilities; //  options:=  DefSynEditOptions;
  //((SynPasSyn1.Attribute[1]:= GetDefaultAttribute(1);
  //((SynPasSyn1.Attribute[2]:= GetDefaultAttribute(2);
  with synpassyn1 do begin
    GetDefaultAttribute(1);
    GetDefaultAttribute(2);
   GetDefaultAttribute(3);
    GetDefaultAttribute(4);
    GetDefaultAttribute(5);
   GetDefaultAttribute(6);
  end;
   factivelinecolor:= clWebFloralWhite;
  Gutter.ShowLineNumbers:= true;
  font.Color:= clblack;
  memo1.Color:= clwhite;
  WantTabs:= true;

 end;
 with memo2 do begin
    //height:= 350;
    color:= clwhite;
    font.size:= 14;
    font.color:= clblack;
    //clear;
  end;
end;

procedure Tmaxform1.Tetris1Click(Sender: TObject);
begin
  //will be tetris kiss
  Application.CreateForm(TTetro1, Tetro1);
end;

procedure Tmaxform1.ShellStyle1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 350;
    color:= clblack;  //clblack
    font.size:= 18;
    font.color:= clred;
    //clear;
  end;
end;

procedure Tmaxform1.BigScreen1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 500;
    color:= clblack;
    font.size:= 28;
    font.color:= clGreen;
    self.windowstate:= wsmaximized;
    //clear;
  end;
end;

procedure Tmaxform1.BlaisePascalMagazine1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
begin
    strPCopy(URLBuf, RS_BPM);
    ShellExecute(forms.Application.handle, NIL, URLBuf,
                NIL, NIL, sw_ShowNormal)
end;

procedure Tmaxform1.Bookmark11Click(Sender: TObject);
begin
  bookmarkimage:= 10;   //warning
end;

procedure Tmaxform1.Bookmark21Click(Sender: TObject);
begin
  bookmarkimage:= 11;   //bug
end;

procedure Tmaxform1.Bookmark31Click(Sender: TObject);
begin
  bookmarkimage:= 12;  //info
end;

procedure Tmaxform1.Bookmark41Click(Sender: TObject);
begin
  bookmarkimage:= 13;  //question
end;

procedure Tmaxform1.Bookmark51Click(Sender: TObject);
begin
  bookmarkimage:= 15;  //hint
end;

procedure Tmaxform1.ConfigFile1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+DEFINIFILE); // 'maxboxdef.ini');
end;

procedure Tmaxform1.ConfigUpdate1Click(Sender: TObject);
begin
  deffilereadupdate;  //refresh the ini file
  statusBar1.panels[0].text:= 'Refresh Config File Reload: '+DEFINIFILE;
  memo2.lines.Add(statusBar1.panels[0].text);
end;

procedure Tmaxform1.Configuration1Click(Sender: TObject);
begin
  //configuration
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter25.pdf');
end;

procedure Tmaxform1.Console1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 300;
    color:= clblack;
    font.size:= 14;
    font.color:= clwhite;
    //clear;
  end;
end;


procedure Tmaxform1.CountWords1Click(Sender: TObject);
begin
  //jumps to highlightning of words      F11
  Memo1DblClick(self);
end;

procedure Tmaxform1.Richedit5Click(Sender: TObject);
begin
   Application.CreateForm(TREMainForm, REMainForm);
  REMainForm.Show;
end;

procedure Tmaxform1.ReadOnly1Click(Sender: TObject);
begin
 readonly1.Checked:= not readonly1.Checked;
 if readonly1.Checked then memo2.ReadOnly:= true else
   memo2.ReadOnly:= false;
end;


procedure Tmaxform1.Redo1Click(Sender: TObject);
begin
  memo1.Redo;
end;

procedure Tmaxform1.Rename1Click(Sender: TObject);
begin
  showmessage('will be in V5');
end;

procedure Tmaxform1.intfRefactor1Click(Sender: TObject);
begin
// refactor
  showmessage('will be in V5');
end;


procedure Tmaxform1.mnuPrintFont1Click(Sender: TObject);
begin
  dlgPrintFont1.Font.Assign(memo1.Font);  //fPrintOut
  if dlgPrintFont1.Execute then
    fPrintOut.Font.Assign(dlgPrintFont1.Font);
end;

procedure Tmaxform1.ModulesCount1Click(Sender: TObject);
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
      debugout.caption:= 'mX5 System Modules Library List';
      debugout.visible:= true;
  finally
    aStrList.Free;
  end;
  //get modules dll list
end;

procedure Tmaxform1.SetInterfacesMarks(myFile: string);
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
   if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
      and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6)
   then break;  //bug 3.9.3  afterbug

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

procedure Tmaxform1.SetInterfacesMarks2(myFile: string);   //active
var
  i, it1, it2, it3,it4, it5, itstr: integer;
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
      it4:= pos('{', s1);
      it5:= pos('forward', s1);
      //if memo1.Highlighter.GetTokenKind = 1 then
      //if memo1.Highlighter.  GetTokenAttribute.Style = fsBold
      //showmessage('comment bold');
      //if posex(  amemo1. then
      //if it1 > 6 then break;
      if (it1 > 6) or (it2 > 6) then continue;

     //t1:= mymemo.searchReplace(uppercase('function '),'',[]);
      //if pos(uppercase(ENDSIGN),uppercase(s1)) > 0 then break;   //bug 3.9.9.91
        if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
      and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6)
       then break;
      if ((it2 > 0) or (it1 > 0)) and (itstr < 9) and (it3 = 0) and (it4=0) and (it5=0) then begin
        inc(itstr);
        if STATAutobookmark then
          memo1.SetBookmark(itstr,2,i+1);
        //showmessage('bookmark found at ' +inttostr(i+1));
      end;
    end;
  finally
    //mymemo.CaretY:= 8;  //test
    aStrList.Free;
  end;
end;

procedure Tmaxform1.SetTodoMarks(myFile: string);
var
  i, it1, itstr: integer;
  s1: string;
  aStrList: TStringList;
    amark: TSynEditMark;

begin
  aStrList:= TStringList.create;
  aStrList.loadFromfile(myFile);
  itstr:= 0;
  try
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      it1:= pos(uppercase('TODO'), uppercase(s1));
     //t1:= mymemo.searchReplace(uppercase('function '),'',[]);
      //if pos(uppercase(ENDSIGN),uppercase(s1)) > 0 then break;   //bug 3.9.9.91
        if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
      and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6)
        then break;
      if it1 > 0 then begin
        inc(itstr);
       aMark:= TSynEditMark.Create(memo1);
        with aMark do begin
          Line:= i+1;
          //Char:= p.char;
          ImageIndex:= 15; //12; //bookmarkimage;//(Sender as TSpeedButton).Tag;  10-13
          Visible:= TRUE;
        //InternalImage:= BookMarkOptions.BookMarkImages = nil;
          memo1.Marks.Add(amark);
        end;  //}
        //memo1.SetBookmark(itstr,2,i+1);
        //showmessage('bookmark found at ' +inttostr(i+1));
      end;
    end;
  finally
    //mymemo.align:= alClient;
    //mymemo.CaretY:= 8;  //test
    aStrList.Free;
  end;
end;


procedure Tmaxform1.SetInterfacesMarksMemo3; //deprecated
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
      //if pos(uppercase(ENDSIGN),uppercase(s1)) > 0 then break;
        if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
          and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6)
           then break;
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



procedure Tmaxform1.Move1Click(Sender: TObject);
begin
  Showmessage('available in V5');
end;

procedure Tmaxform1.MP3Player1Click(Sender: TObject);
begin
  //call mp3player
  FormSetMP3FormCreate;
end;

procedure Tmaxform1.MyScript1Click(Sender: TObject);
var deflist: TStringlist;
  filepath, fn, myscript: string;
begin
//this is myscript opener
deflist:= TStringlist.create;
filepath:= ExtractFilePath(forms.Application.ExeName);
  try
    fN:= filepath+ DEFINIFILE;
    if fileexists(fN) then begin
      deflist.LoadFromFile(fN);
      myscript:= (deflist.Values['MYSCRIPT']);
      if fileexists(myscript) then
      S_ShellExecute(ExtractFilePath(ParamStr(0))+'maxbox5.exe',
        myscript,seCmdOpen) else
      MessageDlg('Could not open myscript: '+myscript+' please verify ini script path', mtWarning, [mbOK], 0);
   end else
     MessageDlg('Could not open inifile: maxboxdef.ini, please verify ini file', mtWarning, [mbOK], 0);
   finally
    deflist.Free;
  end;
end;

procedure Tmaxform1.MyScript2Click(Sender: TObject);
var deflist: TStringlist;
  filepath, fn, myscript: string;
begin
//this is myscript opener
deflist:= TStringlist.create;
filepath:= ExtractFilePath(forms.Application.ExeName);
  try
    fN:= filepath+ DEFINIFILE;
    if fileexists(fN) then begin
      deflist.LoadFromFile(fN);
      myscript:= (deflist.Values['MYSCRIPT2']);
      if fileexists(myscript) then
      S_ShellExecute(ExtractFilePath(ParamStr(0))+'maxbox5.exe',
        myscript,seCmdOpen) else
      MessageDlg('Could not open myscript: '+myscript+' please verify ini script path', mtWarning, [mbOK], 0);
   end else
     MessageDlg('Could not open inifile: maxboxdef.ini, please verify ini file', mtWarning, [mbOK], 0);
   finally
    deflist.Free;
  end;
end;

procedure Tmaxform1.N3DLab1Click(Sender: TObject);
var FormLab3D: TFormLab3D;
begin
  FormLab3D:= TFormLab3D.Create(self);
  try
    FormLab3D.ShowModal;
  finally
    FormLab3D.Free;
  end;   //}
// modal
end;

procedure Tmaxform1.N4GewinntGame1Click(Sender: TObject);
begin
 // start the game 4gewinnt
  FormCreateInit4Game(self);
end;

procedure Tmaxform1.New1Click(Sender: TObject);
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
    //CB1SCList.Items.Add((Act_Filename));   //3.9 wb
    //CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;  //fix 3.9.9.82
    If fileExists('newtemplate.txt') then begin
      if MessageDlg('Filename exists!, you want to overwrite newtemplate.txt ?',
                  mtConfirmation, [mbYes,mbNo], 0) = mrYes then begin  //3.8
        statusBar1.panels[0].text:= 'newtemplate.txt will be overriden';
        loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
       CB1SCList.Items.Add((Act_Filename));   //3.9 wb
       CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
      end else begin
        statusBar1.panels[0].text:= 'Filename newtemplate.txt must be renamed';
        Act_Filename:= '';
        loadLastfile1.Caption:= '&Load Last File'+': '+ extractFileName(last_fName);
        Saveas3Click(sender);
      end;
    end else begin
      statusBar1.panels[0].text:= 'File newtemplate.txt not exists - now saved!';
      memo1.lines.Add('----File newtemplate.txt not exists - now saved!----');
      Saveas3Click(sender);
    end;
  end
end;

procedure Tmaxform1.NewInstance1Click(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists(ExtractFilePath(forms.Application.ExeName)) then begin
    sOName:= ExtractFilePath(forms.Application.ExeName) + #0;
    sEName:= forms.Application.ExeName;
    maxForm1.color:= clgreen;
    hlog.Add('>>>> New Instance: {App_name} v{App_ver}{80@}{now}');
    if IsFileInUse(exepath+'maxboxlog.log') then
        hlog.Free; //prevent efpopen file exception
    ShellExecute(0, 'open', @sEName[1], NIL, @sOName[1], SW_SHOW);
    //ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
    statusBar1.panels[0].text:= 'New Instance created of: '+ExtractFileName(Act_Filename);
    memo2.lines.Add(statusBar1.panels[0].text);
  end else
    showMessage('No mX4_5 Instance found...');
    //GetCurrentDir;
  //searchAndOpenDoc(ExePath+ExtractFileName(Application.ExeName))
     //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb
     //CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
end;

procedure Tmaxform1.Include1Click(Sender: TObject);
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

procedure Tmaxform1.DoEditorExecuteCommand(EditorCommand: word);
begin
  memo1.CommandProcessor(TSynEditorCommand(EditorCommand),' ',NIL);
end;

procedure Tmaxform1.DOSShell1Click(Sender: TObject);
begin
  //ghgh      shellexecute3
  //ExecuteCommand('cmd','/k dir *.*')
  S_ShellExecute('cmd','/k dir *.*',seCMDOpen)

  //ExecuteShell('explorer.exe',ExePath)
  //ExecConsoleApp('cmd','/k dir *.*',NIL);
end;

procedure Tmaxform1.IndentSelection1Click(Sender: TObject);
begin
 //memo1.Marks;
  //memo1.Keystrokes.items[0].command:= ecBlockIndent;
  DoEditorExecuteCommand(ecBlockIndent);
end;

procedure Tmaxform1.UnindentSection1Click(Sender: TObject);
begin
  //memo1.Keystrokes.items[0].command:= ecBlockUnIndent;
  // Find Command(ecBlockUnIndent);
  //memo1.Keystrokes.items[memo1.Keystrokes.FindCommand(ecBlockUnIndent)].Command:=ecBlockUnIndent;
  DoEditorExecuteCommand(ecBlockUnIndent);
end;


procedure Tmaxform1.UnitConverter1Click(Sender: TObject);
// open unit converter
//((var uconvFormLab3D: TFormLab3D;
var fconvMain: TfconvMain;
begin
  fconvMain:= TfconvMain.Create(self);
  try
    fconvMain.ShowModal;
  finally
    fconvMain.Free;
  end; //}
end;

procedure Tmaxform1.Info1Click(Sender: TObject);
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
        output.Font.Size:= 12;
       //debugout.output.Color:= clgreen;
        Width:= 750;
        Height:= 780;
         //debugout.Color:= 123;
       //caption:= 'mX4 Script File Information of '+getOSName+' '
         //                    +getOSVersion+' '+getOSNumber;
        caption:= 'mX5 Script File Information of  :';
        //output.Font.Style:= [fsbold];
        output.Lines.add(DupeString('_',90));
        output.Lines.add('App Name: '+extractFileName(Act_Filename));
        output.Lines.add('Path Name: '+extractFilePath(Act_Filename));
        output.Lines.add('Exe Name: '+extractFileName(forms.Application.ExeName));
        //output.Font.Style:= [];
        output.Lines.add(DupeString('_',90));
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
        output.Lines.add('MD5 of File: '+MD5(Act_Filename));   // *)
        output.Lines.add('CRC32 of File: '+IntToStr((CRC32H(Act_Filename)))+' : '+inttoHex(CRC32H(Act_Filename),4));
        Attributes:= FileGetAttr(Act_Filename);
        ReadOnly:= (Attributes and faReadOnly) = faReadOnly;
        Archive:= (Attributes and faArchive) = faArchive;
        System:= (Attributes and faSysFile) = faSysFile;
        if ReadOnly then output.Lines.Add('File is Readonly!');
        if Archive then output.Lines.Add('File is Archive');
        if System then output.Lines.Add('File is System!');  //*)
        output.Lines.add('File Version1: '+GetVersionString(Act_Filename));
        output.Lines.add('File Version2: '+GetVersionString(exepath+'maXbox5.exe'));
        output.Lines.add(DupeString('_',90)); //*)
        output.Lines.add('Work Dir: '+GetCurrentDir);  //*)
        output.Lines.add('Exe Dir: '+ExePath);
        if STATSavebefore then output.Lines.Add('Auto Save On')
                   else output.Lines.Add('Auto Save Off');
        if STATMemoryReport then output.Lines.Add('Mem Report On')
                   else output.Lines.Add('Mem Report Off');
        if STATMacro then output.Lines.Add('Macro On')
                   else output.Lines.Add('Macro Off');
        if procMess.Checked then output.Lines.Add('ProcessMessages On')
                   else output.Lines.Add('ProcessMessages Off');
        if IsNetworkConnected then output.Lines.Add('Network On'+ '  COMPort: ')
                   else output.Lines.Add('Network Off' + '  COMPort: false');
        if IsInternetConnected then output.Lines.Add('Internet On')
                   else output.Lines.Add('Internet Off');
        output.Lines.add('Local IP: '+getIPAddress(getComputerNameWin)+' DNS: '+ getDNS);
        output.Lines.add('Host Name: '+getComputerNameWin+'  WoW64: '+boolToStr(isWoW64,true)+'  OS: '+getOSName2);
        output.Lines.add('User Name: '+getUserNameWin+'    Is Admin: '+boolToStr(getISAdmin,true));
        output.Lines.add('Process ID: '+intToStr(CurrentProcessID) +'  ThreadCount: '+intToStr(numprocessthreads));
        output.Lines.add('Memory Load: '+inttoStr(GetMemoryLoad) +'% used'+ '  CPU: '+GetProcessorName);
        output.Lines.add('Committ Stack Size: '+inttostr(CommittedStackSize));
        output.Lines.add('Free Mem: '+inttoStr(GetFreePhysicalMemory div 1024)+' KB'+'  SYS_BIOS: '+GetBiosVendor);
        output.Lines.add('Time: '+DateTimeToInternetStr(now, true));   //*)
        output.Lines.add('mX5 Installed Version: '+MBVERSION);
        output.Lines.add('mX5 Internet Version: '+ActVersion);
        output.Lines.add('Highlighter: '+memo1.Highlighter.GetLanguageName +'  Akku: '+inttostr(RemainingBatteryPercent));
        output.Lines.add('Uptime: '+uptime);
        output.Lines.add('Make Path: '+GenMakePath2(Act_Filename));

         output.Lines.add('Unit name: '+PSScript.Comp.UnitName);
        //output.Lines.add(PSScript.Exec.GlobalVarNames);
         debugout.output.Lines.Add(inttoStr(memo1.lines.Count-1)+' Total Lines Found: ' +
                                     (ExtractFileName(ExePath+INCLUDEBOX)));  //*)
      visible:= true;
      bringToFront;
      end;
    end else
      Showmessage('File is not available '+ ExePath)
  finally
    //debugout.output.Color:= clwhite;
    //debugout.output.Font.Size:= 14;
    //aStrList.Free;
  end;   //*)
  //File Info
  end;
//end;
//end;

procedure Tmaxform1.InternetRadio1Click(Sender: TObject);
   var wmp: OleVariant;
   var URLBuf: array[0..255] of char;

begin
///
   Showmessage('Yeah, will be in V5 to go too...');
   //http://europe1.radio.net/
 //Maybe you'll be more comfortable with automation.
 //I believe it would provide most of the functionality as the interfaces provide.
  if IsInternetConnected then begin
    strPCopy(URLBuf, 'http://europe1.radio.net/');
    ShellExecute(forms.Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal);
   end;
   wmp:= CreateOleObject('WMPlayer.OCX');
   //wmp.OpenPlayer(Exepath+'examples\maxbox.wav');
   if ISInternetconnected then begin
     wmp.URL:= 'http://www.softwareschule.ch/download/airmaxloop3.mp3';
     wmp.OpenPlayer(wmp.URL);
   end else
     wmp.OpenPlayer(Exepath+'examples\maxbox.wav');   //*)
  //wmp.controls.play;
end;

procedure Tmaxform1.IntfNavigator1Click(Sender: TObject);
begin
  intfnavigator1.checked:= NOT intfnavigator1.checked;
  if intfnavigator1.checked then LoadInterfaceList else
     FreeAndNil(lbintflist);
end;

procedure Tmaxform1.FormDemo1Click(Sender: TObject);
begin
 //SynMiniMap;
  // actionMain unit;
   Application.CreateForm(TActionForm, ActionForm);
   ActionForm.Show;
   Application.CreateForm(TFormSynEditMinimap, FormSynEditMinimap);
   FormSynEditMinimap.Show;
end;

procedure Tmaxform1.FormDestroy(Sender: TObject);
begin
  //fprintOut.Free;
  DragAcceptFiles(maxForm1.Handle, false);
  //DragAcceptFiles(listform1.Handle, false);
  //ListForm1.WindowProc:= FOrgListViewWndProc; // restore window proc
  //FOrgListViewWndProc:= NIL;
  //listform1.Free;
end;

procedure Tmaxform1.FormClose(Sender: TObject; var Action: TCloseAction);
//const
  //SWarningText = ' Save Code Changes to %s?';
begin
  //stringGrid1.Free;
 (* if STATedchanged then begin
  {if MessageDlg(RCSTRMB+': Save Code Changes now?',
    mtConfirmation, [mbYes,mbNo,mbcancel], 0) = mrYes then begin
      Save2Click(sender);
      memo1.Lines.Clear;
      Action:= caFree;  }
  case MessageDlg(Format(RCSTRMB+': '+SWarningText,[act_filename]),mtConfirmation,
   [mbYes,mbNo,mbcancel], 0) of
    end;
  end; *)
  //mX4.2.4.25
  if STATExceptionLog then begin
     hlog.AddStr(' ');
     hlog.AddStr('Session Exe Stop! '+Act_Filename);
     hlog.Add('>>>> Stop Exe: {App_name} v{App_ver}{80@}{now}');
  end;
  try
    CopyFile(PChar(Exepath+DEFINIFILE),
       PChar(ChangeFileExt(Exepath+DEFINIFILE, '.ini.BACKUP')), False);
  except
    MessageDlg('Could not make a backup of' +DEFINIFILE+', please verify you have enough permissions', mtWarning, [mbOK], 0);
    //Exit;
  end;
  //copyfile(  DEFINIFILE
  fprintOut.Free;
  fAutoComplete.Free;
  debugout.Free;
  listform1.Free;
  hlog.free; //V5 64bit
  //memo1.CodeFolding.FoldRegions.Clear;
  //memo1.CodeFolding.FoldRegions.Free;
   // memo1.codefolding.enabled:= False;  //FoldRanges.ranges.free;
   // memo1.CodeFolding.FoldRegions.ItemClass.
   //  memo1.CodeFolding.Free;     //new4
   //CB1SCList.Free;
  //if assigned(cb1sclist) then
    //FreeAndNIL(cb1sclist);  //prevent invalid pointer op!
     if assigned(winFormp) then
      winFormp.Free;
   // if assigned(webMainForm) then
     // webMainForm.Free;
    if assigned(ledimage) then
      ledimage.Free;                 //39998
   Action:= caFree;
    //maxform1.SetFocus;
  {end else
    Action:= caFree;
  end;}
  //showmessage('form close');  //debug
end;

procedure Tmaxform1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
const
  SWarningText = ' Save Code Changes to %s ?';
begin
 if STATedchanged then begin
  {if MessageDlg(RCSTRMB+': Save Code Changes now?',
    mtConfirmation, [mbYes,mbNo,mbcancel], 0) = mrYes then begin
      Save2Click(sender);
      memo1.Lines.Clear;
      Action:= caFree;  }
  case MessageDlg(Format(RCSTRMB+': '+SWarningText,[act_filename]),mtConfirmation,
   [mbYes,mbNo,mbcancel], 0) of
      idYes: begin
              Save2Click(Self);
              memo1.Lines.Clear;
            end;
      idCancel: begin
                 memo2.lines.Add('Cancel Clicked - back to mX5');
                 CanClose := False;  //Action:= caNone;
               end;
      idNo: CanClose:= True; //   Action:= caFree;
    end;
  end;
end;

procedure Tmaxform1.UpdateView1Click(Sender: TObject);
begin
  memo1.Repaint; //after copy&paste or drag'n drop
end;


procedure Tmaxform1.URILinksClicks1Click(Sender: TObject);
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

procedure Tmaxform1.Tutorial22Services1Click(Sender: TObject);
begin
  //for a midi controller keyboard with jclmidi interface and usbtomidi
  Application.CreateForm(TForm2clavier, Form2clavier);
  //Form2clavier.Show;
   Application.CreateForm(TmidiForm1, midiForm1);
  midiForm1.Show;
 searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter22.pdf');
end;

procedure Tmaxform1.Tutorial23RealTime1Click(Sender: TObject);
begin
//    Showmessage('available in V4');
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter23.pdf');
end;

procedure Tmaxform1.Tutorial24CleanCode1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter24.pdf');
end;

procedure Tmaxform1.Tutorial27XML1Click(Sender: TObject);
begin
    Showmessage('will available soon');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter27.pdf');
end;

procedure Tmaxform1.Tutorial28DLL1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter28.pdf');
end;

procedure Tmaxform1.Tutorial29UMLClick(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter29.pdf');
end;

procedure Tmaxform1.Tutorial30WOT1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter30.pdf');
end;

procedure Tmaxform1.Tutorial19COMArduino1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter19.pdf');
end;

procedure Tmaxform1.Tutorial20RegexClick(Sender: TObject);
begin
  //searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter20.pdf');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter125_modern_regex_medium.pdf');
end;

procedure Tmaxform1.Tutorial21Android1Click(Sender: TObject);
begin
  //android
    Showmessage('available in V5');
end;

procedure Tmaxform1.Tutorial17Server1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter17.pdf');
end;

procedure Tmaxform1.Tutorial183RGBLED1Click(Sender: TObject);
begin
 //wille be arduino
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter18_3.pdf');
end;

procedure Tmaxform1.Tutorial18Arduino1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter18.pdf');
end;

procedure Tmaxform1.Tutorial13Ciphering1Click(Sender: TObject);
begin
// cipher a file pdf
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter13.pdf');
end;

procedure Tmaxform1.Tutorial14Async1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter14.pdf');
end;

procedure Tmaxform1.Tutorial151Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter15.pdf');
end;

procedure Tmaxform1.Lessons15Review1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter16.pdf');
end;


procedure Tmaxform1.Tutorial10Statistics1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter10.pdf');
  //statistics pdf
end;

procedure Tmaxform1.Tutorial11Forms1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter11.pdf');
end;

procedure Tmaxform1.Tutorial12SQL1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter12.pdf');
end;

procedure Tmaxform1.TrainingArduino1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\arduino_training.pdf');
end;

procedure Tmaxform1.Tutorial0Function1Click(Sender: TObject);
begin
   Application.CreateForm(TFormSynEditMinimap, FormSynEditMinimap);
   FormSynEditMinimap.Show;
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter7.pdf');
end;

procedure Tmaxform1.Tutorial101Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter9.pdf');
end;

procedure Tmaxform1.CodeCompletionList1Click(Sender: TObject);
begin
  if fileExists(ExtractFilePath(ParamStr(0))+ CODECOMPLETION) then begin
    statusBar1.panels[0].text:= ' Code Completion Load...' +CODECOMPLETION;
    memo2.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+CODECOMPLETION) end else
    showMessage('the file '+CODECOMPLETION+' is missing');
end;

procedure Tmaxform1.CodeSearch1Click(Sender: TObject);
 var S: string;
begin
 codemap:= true;
 Application.CreateForm(TFormSynEditMinimap, FormSynEditMinimap);
   FormSynEditMinimap.Show;
  S:= '';
  S:= 'StringReplace(';
  if InputQuery('CodeSearchEngine2', 'Enter your code search for examples:', S) and (S <> '') then
    StartCodeFinder(S);
  //code searchforall
  end;

procedure Tmaxform1.Collapse1Click(Sender: TObject);
begin
  collapse1.Checked:= not collapse1.Checked;
  //if STATCodefolding
  if collapse1.Checked then begin
    memo1.UncollapseAll;
    collapse1.Caption:= ' Collapsefolding';
    //ATCodefolding:= true;
  end else begin
    memo1.collapseAll;
     collapse1.Caption:= ' Expandfolding';
    //ATCodefolding:= false;
  end;  //}
  //memo1.UncollapseAll;
end;

procedure Tmaxform1.SaveOutput1Click(Sender: TObject);
begin
  memo2.Lines.SaveToFile(Act_Filename+'Output'+'.txt',memo2.lines.Encoding.UTF8);
  memo2.Lines.Add(Act_Filename+'Output'+'.txt'+'  as output file stored');
end;

procedure Tmaxform1.SaveScreenshotClick(Sender: TObject);
begin
 { CaptureScreenPNG(ExePath+'mx5_screenshot.png');
  memo2.Lines.Add('Screenshot saved as: '+ExePath+'mx5_screenshot.png');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'mx5_screenshot.png'); //}
  TakeScreenshot(ExePath+'mx5_screenshot.png');
  memo2.Lines.Add('Screenshot saved as: '+ExePath+'mx5_screenshot.png');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'mx5_screenshot.png');
 { CaptureScreenJPG(ExePath+'mx5_screenshot.jpg');
  memo2.Lines.Add('Screenshot saved as: '+ExePath+'mx5_screenshot.jpg');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'mx5_screenshot.jpg');    }
end;

procedure Tmaxform1.sbvclhelpClick(Sender: TObject);
begin
  //sbvclhelp vcl.pdf
    searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLOBJECTSLIST)
end;

procedure Tmaxform1.ExportClipboard1Click(Sender: TObject);
begin
  memo1.SelectAll;
  if memo1.Focused then memo1.CopyToClipboard;
  statusBar1.panels[0].text:= ' Export to Clipboard...' +FILELOAD;
end;

function FileNewExt(const FileName, NewExt: TFileName): TFileName;
begin
  Result:= Copy(FileName,1,Length(FileName)-Length(ExtractFileExt(FileName)))+ NewExt;
end;


procedure Tmaxform1.ExporttoHTML1Click(Sender: TObject);
begin
  //export to HTML
  SynExporterHTML1.Highlighter:= memo1.Highlighter;
  if Assigned(SynExporterHTML1.Highlighter) then begin
      Statusbar1.SimpleText := 'HTML Using highlighter for ' +
        SynExporterHTML1.Highlighter.GetLanguageName;
        memo2.Lines.Add(Statusbar1.SimpleText);
  end
    else
      Statusbar1.SimpleText := 'No HTML highlighter assigned';
  SynExporterHTML1.CreateHTMLFragment:= true;
  SynExporterHTML1.ExportAll(memo1.Lines);
  //SynExporterHTML1.SaveToFile(Act_Filename+'out'+'.htm');
  SynExporterHTML1.SaveToFile(FileNewExt(Act_Filename,'.htm'));
  memo2.Lines.Add(FileNewExt(Act_Filename,'.htm')+' as HTML output stored');
  sleep(200);
  SearchAndOpenDoc(FileNewExt(Act_Filename,'.htm'));
end;

procedure Tmaxform1.ExporttoRTF1Click(Sender: TObject);
//var fHighlighters: TStringList;
begin
  {fHighlighters:= TStringList.Create;
  fHighlighters.Sorted:= TRUE;
  GetHighlighters(Self, fHighlighters, FALSE);
  SynExporterRTF1.Highlighter:= GetHighlighterFromFileExt(fHighlighters,
      ExtractFileExt(act_filename));
    if uppercase(ExtractFileExt(act_filename)) = uppercase('.txt') then
       SynExporterRTF1.Highlighter:= SynPasSyn1;
    if uppercase(ExtractFileExt(act_filename)) = uppercase('.pas') then
       SynExporterRTF1.Highlighter:= SynPasSyn1;
    //ChangeFileExt(
    //showmessage(ExtractFileExt(dlgFileOpen.FileName));
    if Assigned(SynExporterRTF1.Highlighter) then
      Statusbar1.SimpleText := 'RTF Using highlighter for ' +
        SynExporterRTF1.Highlighter.GetLanguageName
    else Statusbar1.SimpleText := 'No highlighter assigned';
  //end;
  fHighlighters.Free;}

  SynExporterRTF1.Highlighter:= memo1.Highlighter;
  if Assigned(SynExporterRTF1.Highlighter) then begin
      Statusbar1.SimpleText:= 'RTF Using highlighter for ' +
        SynExporterRTF1.Highlighter.GetLanguageName;
      memo2.Lines.Add(Statusbar1.SimpleText);
   end
    else
      Statusbar1.SimpleText := 'No RTF highlighter assigned';
  //SynExporterRTF1.CreateHTMLFragment:= true;
  SynExporterRTF1.ExportAll(memo1.Lines);
  //SynExporterHTML1.SaveToFile(Act_Filename+'out'+'.htm');
  SynExporterRTF1.SaveToFile(FileNewExt(Act_Filename,'.rtf'));
  memo2.Lines.Add(FileNewExt(Act_Filename,'.rtf')+' as RTF output stored');

end;

procedure Tmaxform1.ExternalApp1Click(Sender: TObject);
begin
 // has an app entry in ini
   if fileExists(ExternalApp) then begin
     S_ShellExecute(Externalapp,'',seCmdOpen);
     ExternalApp1.Caption:= 'App: '+extractfilename(ExternalApp);
     memo2.Lines.Add(ExternalApp+' External App loaded') end
   else begin
     ExternalApp1.Caption:= 'External App';
     memo2.Lines.Add('External App '+ExternalApp +' not found: check in ini-file [APP=]');
     memo2.Lines.Add('External App Example'+ExternalApp +'APP=C:\windows\system32\calc.exe')
   end;
 end;

procedure Tmaxform1.ExternalApp22Click(Sender: TObject);
begin
  if fileExists(ExternalApp2) then begin
     S_ShellExecute(Externalapp2,'',seCmdOpen);
     ExternalApp22.Caption:= 'App2: '+extractfilename(ExternalApp2);
     memo2.Lines.Add(ExternalApp+' External App2 loaded') end
   else begin
     ExternalApp22.Caption:= 'External App2';
     memo2.Lines.Add('External App2 '+ExternalApp2 +' not found: check in ini-file [APP2=]');
     memo2.Lines.Add('External App2 Example'+ExternalApp2 +'APP=C:\windows\system32\calc.exe')
   end;
end;

procedure Tmaxform1.ImportfromClipboard1Click(Sender: TObject);
begin
  last_fName:= Act_Filename;
  loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
  if memo1.Focused then memo1.PasteFromClipboard;
  statusBar1.panels[0].text:= ' Import of Clipboard...' +FILELOAD;
  //CB1SCList.Items.Add(ExtractFileName(Act_Filename));   //3.8 wb no name first
   CB1SCList.Items.Add((Act_Filename));   //3.8 wb
  CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
end;

procedure Tmaxform1.ImportfromClipboard2Click(Sender: TObject);
begin
  ImportfromClipboard1Click(Sender);
end;
procedure Tmaxform1.Close1Click(Sender: TObject);
begin
  self.Close;
end;

procedure Tmaxform1.Manual1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\delphi_kurs.pdf')
end;

procedure Tmaxform1.ManualE1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\objectpascal_guide.pdf')
end;

procedure Tmaxform1.ManualmaXbox1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maXbox_Introduction_2014.pdf')
end;

procedure Tmaxform1.tutorial1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter.pdf')
end;

procedure Tmaxform1.tutorial21Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter2.pdf');
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\VCLHierarchyPoster.pdf');
end;

procedure Tmaxform1.tutorial31Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter3.pdf');
end;

procedure Tmaxform1.Tutorial31Closure1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter31.pdf');
end;

procedure Tmaxform1.Tutorial361Click(Sender: TObject);
begin
   Application.CreateForm(TOpBox, OpBox);
  //Form2clavier.Show;
   //Application.CreateForm(TmidiForm1, midiForm1);
  OpBox.Show;
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter36.pdf');
end;

procedure Tmaxform1.Tutorial39GEOMaps1Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter39.pdf');
end;

procedure Tmaxform1.tutorial4Click(Sender: TObject);
begin
   Application.CreateForm(ThealthForm1, healthForm1);
  healthForm1.Show;
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter4.pdf');
end;

procedure Tmaxform1.Tutorial5Click(Sender: TObject);
// LFormSecondary: TFormSecondary;
begin
 //Application.CreateForm(TFormSecondary, LFormSecondary);
  //Form2clavier.Show;
   Application.CreateForm(TgformMain, gformMain);
  gformMain.Show;
  //searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter5.pdf');
end;

procedure Tmaxform1.Tutorial6Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter6.pdf');
end;

procedure Tmaxform1.Tutorial71Click(Sender: TObject);
begin
  //Snake small - GameofLife
   //Application.CreateForm(TsnakeForm1, snakeForm1);
   //snakeForm1.Show ;
   Application.CreateForm(TGOLMainForm, GOLMainForm);
   GOLMainForm.Show ;
  //searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter7.pdf');
end;

procedure Tmaxform1.Tutorial81Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter8.pdf');
  Showmessage('available in 3.1');
end;

procedure Tmaxform1.Tutorial91Click(Sender: TObject);
begin
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))
                    +'docs\PascalScript_maXbox_EKON_14_2.pdf');
end;


procedure Tmaxform1.intfAdd1Click(Sender: TObject);
 var S: string;
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


procedure Tmaxform1.intfDelete1Click(Sender: TObject);
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

procedure Tmaxform1.ActiveLineColor1Click(Sender: TObject);
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

procedure Tmaxform1.AddToDo1Click(Sender: TObject);
begin
 //ctrl+shift
   if fileExists(ExtractFilePath(ParamStr(0))+ CODECOMPLETION) then
      maxForm1.fAutoComplete.ExecuteCompletion('todo',memo1) else
      showMessage('The file '+CODECOMPLETION+' is missing');
end;

procedure Tmaxform1.ADOWorkbench1Click(Sender: TObject);
begin
 //ADO
 //ADODBTest
    Application.CreateForm(TADODBTest, ADODBTest);
    ADODBTest.Show;
  memo2.Lines.Add('ADO Workbench4 Loaded');
end;

procedure Tmaxform1.AllFunctionsList1Click(Sender: TObject);
var URLBuf: array[0..255] of char;
  begin
 searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLFUNCTIONSLISTPDF);
  if IsInternetConnected then begin
    strPCopy(URLBuf, ALLFUNCTIONSLISTWEB);
    ShellExecute(forms.Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal);
  end;   //}
end;

procedure Tmaxform1.AllObjectsList1Click(Sender: TObject);
begin
  //this is all objects list
  searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLOBJECTSLIST)
end;

procedure Tmaxform1.AllResourceList1Click(Sender: TObject);
begin
  //all resource show
    searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLTYPELIST)
end;

procedure Tmaxform1.AllUnitList1Click(Sender: TObject);
begin
 searchAndOpenDoc(ExtractFilePath(ParamStr(0))+ALLUNITLIST)
end;

procedure Tmaxform1.AndroidDump1Click(Sender: TObject);
begin
   ShowMessage('Android Dump to Dalvik Compile Format Runtime Emulator available in V5'+#13#10+
                'first example in: ..\examples\androidlcl')
end;

procedure Replace(var Str: String; Old, New: String);
begin
  Str:= StringReplace(Str, Old, New, [rfReplaceAll]);
end;


//----------------------- PlugIns---------------------------------------------
procedure Tmaxform1.PacManX51Click(Sender: TObject);
begin
  //for pacman 5
    //this start of pacman    - pacman
   Form1pac:= TForm1pac.Create(self);
   Form2pac:= TForm2pac.create(form1pac);
  try
    memo2.Lines.Add('PacManX View started');
    Form1pac.Cursor:= CRHandpoint;
    {if fileExists(ExtractFilePath(ParamStr(0))+'\examples\sejour2048.jpg') then
      panForm1.GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile(ExtractFilePath(ParamStr(0))+'\examples\sejour2048.jpg');
    memo2.Lines.Add('OpenGL Panorama View start in single mode');  }
     //Form1pac.ShowModal;
     //modal to ensure free all 6 timers action:= cafree;
      Form1pac.ShowModal;
    memo2.Lines.Add('PacManX View ended');
   finally
    Form1pac.Cursor:= CRDefault;
    Form1pac.Free;
  end;
end;

procedure Tmaxform1.PANView1Click(Sender: TObject);
begin
 //start the pan view
   panForm1:= TpanForm1.Create(self);
  try
    panForm1.Cursor:= CRHandpoint;
    if fileExists(ExtractFilePath(ParamStr(0))+'\examples\sejour2048.jpg') then
      panForm1.GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile(ExtractFilePath(ParamStr(0))+'\examples\sejour2048.jpg');
    memo2.Lines.Add('OpenGL Panorama View start in single mode');
     panForm1.ShowModal;
    memo2.Lines.Add('OpenGL 3D Panorama View ended');
   finally
    panForm1.Cursor:= CRDefault;
    panForm1.Free;
  end;  //}
end;

function Tmaxform1.ParseMacros(Str: String): String;
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

procedure Tmaxform1.PascalSchool1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
  begin
    strPCopy(URLBuf, RS_PS);
    ShellExecute(forms.Application.handle, NIL, URLBuf,
                 NIL, NIL, sw_ShowNormal)
  //from about
end;


procedure Tmaxform1.PasStyle1Click(Sender: TObject);
begin
 with memo2 do begin
    height:= 230;
    color:= clwebgold;  //clblack
    font.size:= 17;
    font.color:= clPurple;
    //clear;
 end;
  maxform1.Color:= clwebgold;
  forms.Application.HintColor:= clYellow;
  //ActiveLineColor1Click(self);
  //memo1.activeLineColor:= clskyblue;
  factivelinecolor:= clWebLightYellow; //clcream; //clsilver;       //teal, lime
  memo1.RightEdgeColor:= clYellow;
  memo1.Gutter.Color:= clMoneyGreen;
  memo1.Gutter.Gradient:= true;

  //ActiveLineColor1Click(self);
  if intfnavigator1.checked then
    lbintfList.Color:= clskyblue;
  memo1.Font.Size:= 15;
  SynPasSyn1.KeyAttri.Foreground:= clNavy;
  SynPasSyn1.SymbolAttribute.Foreground:= clRed;
  SynPasSyn1.FloatAttri.Foreground:= cllime;
end;

procedure Tmaxform1.PerlSyntax1Click(Sender: TObject);
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

procedure Tmaxform1.PHPSyntax1Click(Sender: TObject);
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

procedure Tmaxform1.PicturePuzzle1Click(Sender: TObject);
begin
  Form1Boss:= TForm1boss.Create(self);
  try
    Form1Boss.ShowModal;
  finally
    Form1Boss.Free;
  end;    //}
   //Application.CreateForm(TForm1Boss, Form1boss);
  //start the picturepuzzle
end;


procedure Tmaxform1.DelphiSite1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
  begin
    strPCopy(URLBuf, RS_DS);
    ShellExecute(forms.Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal)
end;

procedure Tmaxform1.DependencyWalker1Click(Sender: TObject);
begin
// go to dependency walker  unit explorer  - pansichar to widestring!
   DependencyWalkerDemoMainFrm:= TDependencyWalkerDemoMainFrm.Create(self);
   try
     DependencyWalkerDemoMainFrm.ShowModal;
   finally
     DependencyWalkerDemoMainFrm.Free;
   end;    //}
end;


procedure Tmaxform1.DLLSpy1Click(Sender: TObject);
begin
  //DLL Spy
   DLLForm1:= TDLLForm1.Create(self);
  try
    DLLForm1.ShowModal;
  finally
    DLLForm1.Free;
  end;   //}
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

procedure Tmaxform1.ClickinListbox2(sender: TObject);
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



procedure Tmaxform1.ClickinListbox(sender: TObject);
var idx: integer;
    temp: string;
begin
  idx:= lbintflist.itemindex;
  //memo2.lines.add(lbintflist.items[idx]); debug
  lbintflist.hint:= lbintflist.Items[idx];
  showhint:= true;
  with FindReplDialog do begin
    //show;
   // Options:= Options -[ssoReplaceAll, ssoReplace];   //bugfix 3.9.8.2
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
    //Options:= Options + [ssoEntireScope];
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


procedure Tmaxform1.GetIntflistWidth(sender: TObject);
begin
  lbintflistwidth:= lbintflist.width;
  statusBar1.panels[1].text:= 'Interfacelist change: '+inttoStr(lbintflistwidth);
end;


procedure Tmaxform1.LoadInterfaceList;
var
  //  i: integer;
  AFilename: string;
  //lbintflist: TListBox;
  i, t1, t2, t3, t4, t5, tstr: integer;
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
      t3:= pos('//', s1);
      t4:= pos('{', s1);
      t5:= pos('forward', s1);
      if (t1 > 7) or (t2 > 6) then continue;

      if ((t1 or t2) > 0) and (t3 = 0) and (t4=0) and (t5=0) then begin
        inc(tstr);
        mstr:= mstr + s1 + #13;  //+#13;
      end;
     // mstr:= mstr + 'locs: '+ intToStr(getCodeEnd);
     //t1:= mymemo.searchReplace(uppercase('function '),'',[]);
      //if pos(uppercase('end.'),uppercase(s1)) > 0 then break;
      //if ((it2 > 0) or (it1 > 0)) and (itstr < 9) and (it3 = 0) and (it4=0) then begin
       if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
        and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6)
          then break;
     //if pos(uppercase(ENDSIGN),uppercase(s1)) > 0 then break;  //bug 3.9.3
    end;
     //mstr:= mstr + 'locs: '+ intToStr(getCodeEnd);

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
    if pythonsyntax1.Checked then begin         //python c#
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('class '), uppercase(s1));
      t2:= pos(uppercase('def '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
   end;

   mstr:= mstr + 'Locs: '+ intToStr(getCodeEnd)+' - code blocks: '+inttostr(tstr);

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
      if width < 200 then width:= 200;  //bug 3.9.9.95
      
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
        if memo1.Color = clblack then
         maxform1.lbintfList.Color:= clskyblue;      //45810

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


procedure Tmaxform1.LoadInterfaceList2;
begin
  if NOT assigned(lbintflist) then begin
   LoadInterfaceList;
   intfnavigator1.checked:= true;
  end;
end;

procedure Tmaxform1.DMathLibrary1Click(Sender: TObject);
begin
   searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\dmath_manual.pdf');
end;

procedure Tmaxform1.DocuforAddOns1Click(Sender: TObject);
begin
  //searchAndOpenDoc(ExtractFilePath(ParamStr(0))+'docs\maxbox_starter63.pdf');
   ShowMessage('Full Add Ons Docu available in V5_1')
end;

procedure Tmaxform1.PlayMP31Click(Sender: TObject);
begin
  Application.CreateForm(TwinFormp, winFormp);
  winformp.Height:= 750;
  winformp.show;// this is play
end;

procedure Tmaxform1.GetEMails1Click(Sender: TObject);
begin
  //GetMailHeaders;
end;

Function Tmaxform1.GetStatChange: boolean;
begin
  result:= STATEdchanged;
end;

Function Tmaxform1.GetActiveLineColor: TColor;
begin
  result:= factivelinecolor;
end;

Procedure Tmaxform1.SetActiveLineColor(acolor: TColor);
begin
  factivelinecolor:= acolor;
end;


Function Tmaxform1.GetStatExecuteShell: boolean;
begin
  result:= StatExecuteShell;
end;

Function Tmaxform1.GetStatDebugCheck: boolean;
begin
  result:= StatDebugCheck;
end;

procedure Tmaxform1.SetStatDebugCheck(ab: boolean);
begin
  StatDebugCheck:= ab;
end;

procedure SetDebugCheck(ab: boolean);
begin
  maxform1.StatDebugCheck:= ab;
end;

procedure Tmaxform1.GetWebScript1Click(Sender: TObject);
begin
  //this is srvice in winformpuzzle
  getScriptandRunAsk;
end;

procedure Tmaxform1.GetWidth(sender: TObject);
begin
end;

procedure Tmaxform1.Go5Click(Sender: TObject);
begin
 //go game 5
  Application.CreateForm(TGoForm1, GoForm1);
  GoForm1.Show;
  //GoForm1: TGoForm1;
end;

procedure Tmaxform1.GotoEnd1Click(Sender: TObject);
begin
  with FindReplDialog do begin
  FindText:='';                    //bugfix 3.8.6.2
  //FindText:=' ';                    //bugfix 3.8.6.2
  ReplaceText:= '';
   //cbxSearch.Clear;
   cbxReplace.Clear;
   //cbCase.Checked
   options:= options-[ssoMatchCase];                    //ssoMatchCase
   //Found := Pos(LowerCase(SearchText), LowerCase(SourceText)) > 0;
    //Findtext:= 'end.';   //ENDSIGN fix to V5.0.2 with +space cause attributes with resend.start
    //OnFind:= FindNextText;
    //FindNextText(self);
    Findtext:= 'End.';
    FindNextTextEnd(self);

    //Execute(false);
  end;
  //goto code end
end;

procedure Tmaxform1.GotoLine1Click(Sender: TObject);
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

procedure Tmaxform1.GPSSatView1Click(Sender: TObject);
var  FDemo: TFDemo;
begin
 FDemo:= TFDemo.Create(self);
  try
    FDemo.ShowModal;
  finally
    FDemo.Free;
  end; //}
  //the view
end;

procedure Tmaxform1.ThreadDemo1Click(Sender: TObject);
begin
  //StartThreadDemo;
   with TThreadSortForm.Create(self) do begin
      label1.caption:= 'Bubble Sort down up';
      show;
   end; //}
end;

procedure Tmaxform1.ToDoList1Click(Sender: TObject);
var ViewToDoForm: TViewToDoForm;
begin
  //to do form devcc
 ViewToDoForm:= TViewToDoForm.Create(self);
  try
    ViewToDoForm.Show;
    //ViewToDoForm.ShowModal;

  finally
    //ViewToDoForm.Free;
        memo2.Lines.Add('Tasklist opened '+Act_Filename);
  end;
  //}
end;

Procedure Tmaxform1.SetStatChange(vstat: boolean);
begin
  STATEdchanged:= vstat;//
end;

procedure Tmaxform1.LoadLastFile1Click(Sender: TObject);
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
  try
   memo1.Lines.LoadFromFile(last_fName);
   templastfile:= Act_Filename;
   Act_Filename:= last_fName;
   last_fName:= templastfile;
   loadLastfile1.Caption:= '&Load Last'+': '+ extractFileName(last_fName);
   memo2.Lines.Add(extractFileName(last_fName) +' '+ BEFOREFILE);
   statusBar1.panels[0].text:= Act_Filename +' '+ FILELOAD;
   memo2.Lines.Add(extractFileName(Act_Filename) +' '+ FILELOAD);
  //CB1SCList.Items.ValueFromIndex
  if Act_Filename <> CB1SCList.items[CB1SCList.ItemIndex-1] then
   CB1SCList.Items.Add((Act_Filename));   //3.9.3 wb
  //CB1SCList.ItemIndex:= CB1SCList.Items.IndexOfName(Act_FileName)-1;
  //STATlastfile:= Not STATlastfile;        //big think to sync history
  //CB1SCList.Items[CB1SCList.Items.Count]:= last_fName;
   CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
  {if STATLastfile then
    CB1SCList.ItemIndex:= CB1SCList.Items.Count-2 else
    CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;}
  except
    Showmessage('Invalid File Path - Please Set <File Open/Save As...>');
  end;
end;

procedure Tmaxform1.Memo1Change(Sender: TObject);
begin
  STATedchanged:= true;
  memo1.Refresh; //2.8.1
  //debug statusBar1.SimpleText:= ' editior changed';
  memo1.SetBookmark(3,2,memo1.carety);
  statusBar1.panels[2].text:= ' M!'+' T:'+intToStr(numprocessthreads);
  memo1.Gutter.BorderColor:= clwebyellow;  //clweblightyellow;
end;


procedure Tmaxform1.ShowWords(mystring: string);
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
        if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
         and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6)
           then break;
     //if pos(uppercase(ENDSIGN),uppercase(s1)) > 0 then break;  //bug 3.9.3
    end;
  debugout.output.Font.Size:= 12;
  debugout.output.Lines.Text:= mstr;
  debugout.caption:= 'Words List in Code Line Change';
  debugout.output.Lines.Add(inttoStr(tstr)+' Words Found per Line/Substring: ' +
                                     ExtractFileName(Act_Filename));
  debugout.visible:= true;
    memo1.hint:= ' cwfound words: '+inttoStr(tstr)+' ';
   memo2.Lines.Add(' cwfound: '+inttoStr(tstr)+' ');
   statusBar1.panels[1].text:= ' cwfound words: '+inttoStr(tstr)+' ';

  finally
    aStrList.Free;
  end;
end;


procedure Tmaxform1.Memo1DblClick(Sender: TObject);  //beta 3
var fw, s1: string;
  t1, cfound: integer;
  //oldcolor, selcolor: TSynSelectedColor;
   mbuffer: TBufferCoord;
   mysyn: TSynpasSyn;
  //CmntSet: TCommentStyles;
  oldhighlight: TSynCustomHighlighter;
begin
  //search for same words links
  oldhighlight:= memo1.Highlighter;
  memo2.Lines.Add('highlighter dat: '+oldhighlight.GetLanguageName);

  mysyn:= TSynpasSyn.create(self);
  fmemoclick:= Not fmemoclick;
  cfound:= 0;
  if fmemoclick then begin
   memo1.Highlighter:= mysyn;
   fw:= memo1.WordAtCursor;
   //mysyn.Objects.Add(uppercase(fw));
   //mysyn.Constants.Add(uppercase(fw));
   //FactiveLine:= memo1.CaretY;
     //memo1.setSelword;
   tmpcodestr:= fw;
   //oldcolor:= memo1.SelectedColor;
    memo1.GetPositionOfMouse(mbuffer);
    memo1.setwordblock(mbuffer);
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
    memo1.setwordblock(mbuffer);
    ShowWords(fw);

  {( for i:= 0 to memo1.Lines.Count -1 do begin
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
   end; //}
   memo1.hint:= fw +' found words: '+inttoStr(cfound)+' ';
   memo2.Lines.Add(fw +' cfound: '+inttoStr(cfound)+' ');
   statusBar1.panels[1].text:= fw +' found words: '+inttoStr(cfound)+' ';
  end else begin

  //mysyn.Constants.clear;
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
    memo1.setwordblock(mbuffer);
   //FactiveLine:= memo1.CaretY;
  if editreplace1.Checked then begin
   cfound:= memo1.searchReplace(fw,tmpcodestr,[ssoWholeWord,ssoEntireScope,ssoReplaceAll]);
   // else
   //cfound:= memo1.searchReplace(fw,fw,[ssoWholeWord,ssoEntireScope,ssoReplaceAll]);
   statusBar1.panels[1].text:= fw +' foundback2: '+inttoStr(cfound)+' ';
    memo1.setwordblock(mbuffer);
   memo2.Lines.Add(fw +' foundback2: '+inttoStr(cfound)+' ');
   tmpcodestr:='';
   ShowWords(fw);

  end else begin
   cfound:= memo1.searchReplace(fw,fw,[ssoWholeWord,ssoEntireScope]);
   statusBar1.panels[1].text:= fw +' found: '+inttoStr(cfound)+' ';
    memo1.setwordblock(mbuffer);
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
  end; //*)
end;

procedure Tmaxform1.Memo1GutterClick(Sender: TObject; Button: TMouseButton; X, Y,
  Line: Integer; Mark: TSynEditMark);
var  p: TBufferCoord;
   aline, i: integer;
    amark: TSynEditMark;
    //marksmemo: TSynEditMarklist;     of memo
    marks: TSynEditMarkList; //TSynEditLineMarks;
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
//    memo1.SetBookMark(1, X, Y);
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
     statusBar1.panels[1].text:= 'found delbkmark: '+inttoStr(aline)+' ';
     foundbm:= true;
     //memo1.Gutter.bands[0]:= memo1.Marks[i];
     //memo1.Gutter.DigitCount:= 5;
     //memo1.UpdateCaret;
     memo1.Marks[i].visible:= true;
     memo1.SetBookMark(1,2, aline);
     //memo1.Gutter.bands[1].gutter.color:= clred;
     memo1.Gutter.bands[0].gutter.visible:= true;
     //memo1.Gutter.bands[0].gutter.internalimage:= bookmarkimage;
     //memo1.Gutter.internalimage:= bookmarkimage;
     break;
     //memo1.Marks[i].Free;
     //memo1.Marks.Remove(memo1.Marks[i]);
     //memo1.Marks[i]:= NIL;
     //memo1.Gutter.bands[0]:= memo1.Marks[i];

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
   aMark:= TSynEditMark.Create(memo1);
     with aMark do begin
        Line:= aLine;
        //Char:= p.char;
        ImageIndex:= bookmarkimage;//(Sender as TSpeedButton).Tag;  10-13
        //memo2.lines.add('debug bookmark: '+inttostr(imageindex));
        //memo1.Marks[imageindex].visible:= true;
        amark.Visible:= TRUE;
        //InternalImage:= BookMarkOptions.BookMarkImages = nil;
      end;
    memo1.Marks.Add(amark); //}
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

procedure Tmaxform1.Memo1PlaceBookmark(Sender: TObject;
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
     // memo1.Marks.ClearLine(aline);
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
function Tmaxform1.CompileDebug: Boolean;
var
  i: Longint;
begin
  cedebug.Script.Assign(memo1.Lines);
  Result:= cedebug.Compile;
  //result:= PSScript.Compile;
  //memo2.Clear;
  for i:= 0 to cedebug.CompilerMessageCount -1 do begin
    memo2.lines.Add(cedebug.CompilerMessages[i].MessageToString);
  end;
  if Result then begin
    memo2.lines.Add('Succesfully compiled/decompiled at: '+timetostr(time));
    statusBar1.panels[0].text:= Act_Filename +' in ---debug mode--- '+ FILELOAD
  end;
end;


procedure Tmaxform1.ComponentCount1Click(Sender: TObject);
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
  complist.Free;   //}
end;

function Tmaxform1.ExecuteDebug: Boolean;
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

procedure Tmaxform1.Decompile1Click(Sender: TObject);
 var
  s: ansistring;        sout: string;
begin
  lineToNumber(false);
  if CompileDebug then begin
    cedebug.GetCompiled(s);
    IFPS3DataToText(s, sout);
    debugout.font.size:= 12;
    debugout.Caption:= 'Debug Decompile Output';
    debugout.output.Lines.Text:= sout;
    debugout.output.Lines.Add('Decompiled Code maXbox: ' +
                                     ExtractFileName(Act_Filename));
    debugout.visible:= true;
  end;
end;

procedure Tmaxform1.Defactor1Click(Sender: TObject);
begin
  Showmessage('yeah, will be in V54');
end;

procedure Tmaxform1.StepInto1Click(Sender: TObject);
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

procedure Tmaxform1.StepOut1Click(Sender: TObject);
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


procedure Tmaxform1.SyntaxCheck1Click(Sender: TObject);
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
    // memo1.ReScanForFoldRanges;              //new4
   //maxForm1.Caption:= 'maXbox3 Sol mX4+  '+ExtractFilename(Act_Filename);  //new4
   maxForm1.Caption:= 'maXbox5 ScriptStudio:  '+ExtractFilename(Act_Filename);

  ledimage.Hide;
  if procMess.Checked= false then
      with ledimage do begin
        Top:= 2;
        visible:= true;
        picture.bitmap.loadfromResourcename(HINSTANCE,'YELLOW')
      end;
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
    SetTodoMarks(Act_Filename);
     //SetInterfacesMarks(Act_Filename);
  if memo1.lines.count > 10000 then memo1.Gutter.DigitCount:= 6; //or 7
  if memo1.lines.count > 100000 then memo1.Gutter.DigitCount:= 7; //or 7

end;

procedure Tmaxform1.Reset1Click(Sender: TObject);
begin
if cedebug.Exec.Status = isRunning then
    cedebug.Stop;
     memo2.Lines.Add('Runtimer Debug Reset');
       memo1.Gutter.BorderColor:= clwindow;      //4.2.4.80
end;

procedure Tmaxform1.ResourceExplore1Click(Sender: TObject);
begin
  tbtn6resClick(self)
  //to do
end;

procedure Tmaxform1.Reversi1Click(Sender: TObject);
var revfrm: TmForm;
begin
  //othello
 mform:= TmForm.Create(self);
  try
    mForm.Cursor:= CRHandpoint;
    mform.ShowModal;
    memo2.Lines.Add('Reversi start in single mode ../source/OpenGLData');
  finally
    mForm.Cursor:= CRDefault;
    mform.Free;
  end;   //}
end;

procedure Tmaxform1.Richedit1Click(Sender: TObject);
begin
//applicatino
 //Application.Initialize;
   //7Application.CreateForm(TFrameForm, FrameForm);
   //FrameForm.Show;
   //RunMDIForm;
  Application.CreateForm(TEditForm, EditForm);
   EditForm.Show;
   memo2.Lines.Add('RichEdit Editor Loaded');
        //}
  //Application.Run;
   //with  TFrameForm.Create(self) do begin
     //show;
   //end;
   //FrameForm.ActiveMDIChild:= FrameForm;
   //FrameForm.Show;
end;

procedure Tmaxform1.cedebugAfterExecute(Sender: TPSScript);
begin
//Caption:= 'Editor';
  FActiveLine:= 0;
  memo1.Refresh;
  memo1.Gutter.LeadingZeros:= false; //2.8
end;

procedure Tmaxform1.cedebugBreakpoint(Sender: TObject;
                const FileName: tbtString; Position, Row, Col: Cardinal);
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

procedure Tmaxform1.cedebugCompile(Sender: TPSScript);
begin
// this is just for test and runtime
  Sender.AddRegisteredVariable('Self', 'TForm');
  Sender.AddRegisteredVariable('Application', 'TApplication');
  Sender.AddRegisteredVariable('Screen', 'TScreen');
  Sender.AddRegisteredVariable('maxForm1', 'TMaxForm1');
  Sender.AddRegisteredVariable('Memo1', 'TSynEdit');
  Sender.AddRegisteredVariable('memo2', 'TMemo');
  Sender.AddRegisteredVariable('debugout', 'Tdebugoutput');  //!!
end;

procedure Tmaxform1.cedebugExecute(Sender: TPSScript);
begin
  cedebug.SetVarToInstance('SELF', Self);
  cedebug.SetVarToInstance('APPLICATION', Application);
  cedebug.SetVarToInstance('Screen', Screen);
  //PSScript.SetPointerToData('Memo1', @Memo1, PSScript.FindNamedType('TSynMemo'));
  cedebug.SetVarToInstance('memo1', memo1);
  cedebug.SetVarToInstance('memo2', memo2);
  //with Sender.findclass(CL.FindClass('TForm'),'TMaxform1')
  //with CL.AddClassN(CL.FindClass('TForm'),'TMaxform1')
  //  Sender.AddRegisteredVariable('maxForm1', 'TMaxform1');
  cedebug.SetVarToInstance('maxForm1', maxForm1);
  cedebug.SetVarToInstance('debugout', debugout);
end;

procedure Tmaxform1.cedebugIdle(Sender: TObject);
begin
 forms.Application.HandleMessage;
  if FResume then begin
    FResume:= False;
    cedebug.Resume;
    FActiveLine:= 0;
    memo1.Refresh;
  end;
end;

procedure Tmaxform1.cedebugLineInfo(Sender: TObject;
              const FileName: tbtString; Position, Row, Col: Cardinal);
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

procedure Tmaxform1.Memo1SpecialLineColors(Sender: TObject; Line: Integer;
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


procedure Tmaxform1.BreakPointMenuClick(Sender: TObject);
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

procedure Tmaxform1.btnClassReportClick(Sender: TObject);
var
  s,ss, s1, mstr: string;
  aStrList: TStringList;
  i, t1, t2, tstr: integer;
begin
  Showmessage('Interface and Unit Report will be in V5.5');
  aStrList:= TStringList.create;
  debugout.Output.Clear;
  tstr:= 0;
  lineToNumber(false);
  if CompileDebug then begin
  // cedebug.GetCompiled(s);
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


procedure Tmaxform1.BtnZoomMinusClick(Sender: TObject);
begin
  memo1.Font.Size:= memo1.Font.Size-1;
  last_fontsize:= memo1.Font.Size;
end;

procedure Tmaxform1.BtnZoomPlusClick(Sender: TObject);
begin
// fonstsize
  memo1.Font.Size:= memo1.Font.Size+1;
  last_fontsize:= memo1.Font.Size;
end;

procedure Tmaxform1.Calculator1Click(Sender: TObject);
begin
  SearchAndOpenDoc('C:\WINDOWS\System32\calc.exe');
  Tutorial361Click(self);
end;

procedure Tmaxform1.CB1SCListChange(Sender: TObject);
var idx, old: integer; temps: string;
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

   memo1.onchange:= Nil;
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
     memo1.onchange:= memo1change;
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
  memo1.Gutter.BorderColor:= clWindow;      //3.9.9.100
end;

procedure Tmaxform1.CB1SCListDrawItem(Control: TWinControl; Index: Integer; aRect: TRect;
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

function RGB2TColor(R,G,B: Byte): TColor;
begin
  Result:=R or (Integer(G) shl 8) or (Integer(B) shl 16);
end;

procedure Tmaxform1.Darkcolor1Click(Sender: TObject);
  begin
      orangestyle1click(self);
      memo1.Gutter.Gradient:= false;
      //maxform1.skystyle1click(self);
      forms.Application.HintColor:= clweblightBlue;
      SynPasSyn1.DirectiveAttri.background:= clred;
      SynPasSyn1.DirectiveAttri.foreground:= clwhite;
      memo1.font.color:= clMoneyGreen;
      memo1.font.size:= 12;
      memo2.font.size:= 12;
          // set hi coolor
      //memo1.color:= clblack - 50;
      memo1.activelinecolor:= clWebDarkSlategray; //clWebDarkred; //clOlive; //clWebFloralWhite; //clnone;   V5.0.2.80
      //memo2.color:= clblack-20;
      memo1.color:= RGB2TColor(32,32,32);  //20,18,18
      memo2.color:= RGB2TColor(20,18,18);
      factivelinecolor:= clnone; //memo1.activelinecolor; //clnone;
      SynPasSyn1.KeyAttri.Foreground:= clskyblue; //clweblightBlue; clskyblue;
      SynPasSyn1.SymbolAttribute.Foreground:= clGreen; //clPurple;
      SynPasSyn1.CommentAttribute.Foreground:= clwebOrange;
      //maxform1.SynPasSyn1.FloatAttri.Foreground:= clwhite;
      SynPasSyn1.ASMAttri.Foreground:= clRed;
       memo1.Gutter.Color:= clMoneyGreen;
      // intfnavigator1.checked:= FALSE;
       if intfnavigator1.checked then
         maxform1.lbintfList.Color:= clskyblue;
       statusbar1.Color:=  clMoneyGreen;
      //writeln(memo1.font.name)
      //maxform1.SynPasSyn1.color
    memo2.Lines.Add('DarkColor Style load lines: '+inttoStr(memo1.LinesInWindow));

end;

procedure Tmaxform1.DebugRun1Click(Sender: TObject);
begin
 memo1.Gutter.Gradient:= true;
 if cedebug.Running then begin
    FResume:= True
  end else begin
    if CompileDebug then
      ExecuteDebug;
     memo2.Lines.Add('Debug ReRun during Runtime');
  end;
end;

procedure Tmaxform1.StatusBar1DblClick(Sender: TObject);
begin
  if statedChanged = false then
  statusBar1.panels[0].text:=
       ExtractFilePath(forms.application.ExeName)+' exe directory'
  else
    statusBar1.panels[0].text:= ExtractFilePath(Act_Filename) +' file directory';
end;

procedure Tmaxform1.PSScriptLine(Sender: TObject);
begin
  //PSScript.online:= , doesn't hang while long running
  forms.Application.ProcessMessages;
  //memo2.lines.Add('runtime is running test');
end;

function Tmaxform1.PSScriptNeedFile(Sender: TObject;
  const OrginFileName: String; var FileName, Output: String): Boolean;
//begin
 //PSScriptNeedFile
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

procedure Tmaxform1.OpenDirectory1Click(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists(ExtractFilePath(Act_Filename)) then begin
    sOName:= ExtractFilePath(Act_Filename) + #0;
    sEName:= 'explorer.exe';
    ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
  end else
    showMessage('No Example Workdirectory found...');
        memo1.Gutter.BorderColor:= clwindow;      //4.2.4.80
end;

procedure Tmaxform1.OpenExamples1Click(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists(ExePath+'\examples') then begin
    sOName:= ExtractFilePath(ExePath+'examples\') + #0;
    sEName:= 'explorer.exe';
    ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
  end else
    showMessage('No Standard Examples found...');
end;

procedure Tmaxform1.OpenGLTry1Click(Sender: TObject);
//var sOname, sEName: string;
begin
  //human gl SearchAndOpenDoc(Exepath+'exercices\Actor.exe');
  {  if DirectoryExists(ExePath+'\exercices') then begin
    sOName:= ExtractFilePath(ExePath+'exercices\model\') + #0;
    sEName:= 'Actor.exe';
    ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
  end else  }
 //if ShellExecute(0,'open','Actor.exe',PChar(ExePath+'\exercices'),nil,SW_SHOWNORMAL) <= 32 then
 {if ShellExecute(0,'open','Actor.exe',PChar(ExePath+'\exercices\model'),
            PChar(ExePath+'\exercices\'),SW_SHOWNORMAL) <= 32 then
    showMessage('No OPen GL Exercices\Model Path found...');}
  if DirectoryExists(ExePath+'exercices\model\') then begin
  glActorForm1:= TglActorForm1.Create(self);
  try
    glActorForm1.Cursor:= CRHandpoint;
    glActorForm1.ShowModal;
    memo2.Lines.Add('OpenGL start in single mode ..\exercices\model');
  finally
    glActorForm1.Cursor:= CRDefault;
    glActorForm1.Free;
  end;
   end else
    showMessage('No ..\exercices\model\*.* Data found..., please copy');  //}
end;

procedure Tmaxform1.OrangeStyle1Click(Sender: TObject);
begin
  with memo2 do begin
        color:= clblack;
        font.color:= clweborange;
        font.size:= 16;
      end;
   maxform1.Color:=clsilver;
   with memo1 do begin
      color:=clwhite;
      font.color:= clblack;
      font.size:= 14;
      ActiveLineColor:= clweborange;
      factivelinecolor:= clWebLightYellow; //clcream; //clsilver;       //teal, lime
      Gutter.BorderColor:= clweborange;
    //mymemo.BorderRightColor:= clred;
      RightEdgeColor:= clpurple;
      Gutter.Gradient:= true;
    //memo1.highlighter.keywordattribute.color
      //highlighter.KeyAttri.foreground:= clblue;
      //like pas style
   end;
    SynPasSyn1.KeyAttri.Foreground:= clNavy;
  SynPasSyn1.SymbolAttribute.Foreground:= clRed;
  SynPasSyn1.FloatAttri.Foreground:= cllime;
  forms.Application.HintColor:= clweblightYellow;
  //ActiveLineColor1Click(self);
  //memo1.activeLineColor:= clskyblue;
//
end;

procedure Tmaxform1.Oscilloscope1Click(Sender: TObject);
begin
try
  Application.CreateForm(TOscfrmMain, oscfrmMain);
  oscfrmMain.Show;
  //Application.CreateForm(TForm2, Form2);
  //Form2.Show;
  except; showmessage('Please run maXbox4 or wait till V5.2 '); end;
  Application.CreateForm(TForm2, Form2);
  Form2.Show;
end;

procedure Tmaxform1.procMessClick(Sender: TObject);
begin
   procMess.Checked:= not procMess.Checked;
   if procMess.Checked then PSScript.OnLine:= maxForm1.PSScriptLine else
   PSScript.OnLine:= NIL;
end;

procedure Tmaxform1.tbtn6resClick(Sender: TObject);
var
 TmpExeFile: TExeImage;
 //rcfrm: TresFormMain2; //TRCMainForm;
begin
 //rcFrm:= TresFormMain2.Create(nil); //TRCMainForm.Create(NIL);
 //with rcFrm do begin
   try
   { Application.CreateForm(TRCMainForm, rcmainform);
    TmpexeFile:= TExeImage.CreateImage(rcmainform, ExePath+'maxbox5.exe');
    rcmainform.FExeFile:= tmpexefile;
    //rcmainform.DisplayResources;
    rcmainform.Showmodal;    }

     Application.CreateForm(TresFormMain2, resFormMain2);

    //resFormMain2.filename:= application.ExeName;
    // resFormMain2.OpenFilefil(application.ExeName);
    resFormMain2.StatusBarMain.Panels [1].Text := 'maXbox5 loaded';
    resFormMain2.Showmodal;
  { with FileOpenDialog do begin
      if not Execute then Exit;
      TmpExeFile:= TExeImage.CreateImage(Self, ExePath+'maxbox3.exe');
      if Assigned(FExeFile) then FExeFile.Destroy;
      FExeFile:= TmpExeFile;
    end; //}
     //FExeFile:= TExeImage.CreateImage(rcFrm, ExePath+'maxbox5.exe');
     try
      //DisplayResources;
      //showModal;
      statusBar1.panels[0].text:= ' mX5 Resources loaded!';
      //end;
     finally
        resFormMain2.Release;
       resFormMain2.Free;
      statusBar1.panels[0].text:= 'Resource Explorer closed';
     end;
    except
      statusBar1.panels[0].text:= 'Resource Explorer not yet ready!'
    end;
  end; //*)
//end;

procedure Tmaxform1.tbtnUseCaseClick(Sender: TObject);
var newNameExt, ucFile: string;
begin
  with TUCMainDlg.create(application) do begin
    try
      //first with a actor and a packagae
      newNameExt := ChangeFileExt(Act_Filename, '.uc');
      if fileexists(newNameExt) then begin
        ucFile:= newNameExt;
        //SetCodeFileName(ucFile);
        TmCustomShape.LoadFromFile(ucFile, ScrollBox1);
        statusBar1.panels[0].text:= ExtractFileName(ucFile)+' : Code & Model ready!';
      end;
      SetCodeFileName(newNameExt);       //WHRE??
      showModal;
      statusBar1.panels[0].text:= 'UC Dialog active';
    finally
      release;
      Free;
      statusBar1.panels[0].text:= 'UC Dialog closed';
    end;
  end;  //*)
  //this is stack attack
  //fix it with a cast
end;


procedure Tmaxform1.Halt1Click(Sender: TObject);
begin
  //stop the app
  StepInto1Click(sender);
  memo2.Lines.Add('Program stopped: '+inttoStr(memo1.LinesInWindow));

end;

procedure Tmaxform1.HEXEditor1Click(Sender: TObject);
begin
  Showmessage('available V5 but you find one in ..\maxbox3\source\Hex_Editor_MX');
  Application.CreateForm(THexForm2, HexForm2);
  HexForm2.Show;
  //Application.CreateForm(THexForm2, HexForm2);
end;

procedure Tmaxform1.HEXEditor2Click(Sender: TObject);
begin
  Showmessage('available in V5 you find one in ..\maxbox3\source\Hex_Editor_MX');
  Application.CreateForm(THexForm2, HexForm2);
  HexForm2.Show;
end;

procedure Tmaxform1.HEXView1Click(Sender: TObject);
begin
  Showmessage('available in V4 you find one in ..\maxbox3\source\Hex_Editor_MX');
  Application.CreateForm(THexForm2, HexForm2);
  HexForm2.Show;
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

procedure Tmaxform1.HTMLSyntax1Click(Sender: TObject);
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


procedure Tmaxform1.texSyntax1Click(Sender: TObject);
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


procedure Tmaxform1.toolbtnTutorialClick(Sender: TObject);
var sOname, sEName: string;
begin
  if DirectoryExists((ExePath+'docs\')) then begin
    sOName:= ExePath+'docs\' + #0;
    sEName:= 'explorer.exe';
    ShellExecute(0, NIL, @sEName[1], @sOName[1], NIL, SW_SHOW);
  end else
    showMessage('No Tutorials Directory found...');
end;


procedure Tmaxform1.CSyntax1Click(Sender: TObject);
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

procedure Tmaxform1.CSyntax2Click(Sender: TObject);
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

procedure Tmaxform1.SQLSyntax1Click(Sender: TObject);
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

procedure Tmaxform1.XMLSyntax1Click(Sender: TObject);
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
end;

procedure Tmaxform1.JavaScriptSyntax1Click(Sender: TObject);
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

procedure Tmaxform1.JavaSyntax1Click(Sender: TObject);
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

procedure Tmaxform1.JumptoOutput1Click(Sender: TObject);
begin
  memo2.setfocus;
end;

procedure Tmaxform1.JumptoTerminal1Click(Sender: TObject);
begin
  memo2.setfocus;
end;

function Tmaxform1.getCodeEnd: integer;
var i: integer;
    s1: string;
begin
  for i:= 0 to memo1.lines.Count -1 do begin
     s1:= memo1.lines[i];
    if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
      and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6) then begin
      //if pos(uppercase(ENDSIGN),uppercase(s1)) > 0 then begin
       result:= i+1;
       break;  //first end counts!
     end;
  end;
end;

procedure Tmaxform1.ShowInterfaces(myFile: string);
var i, t1, t2, tstr: integer;
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
        if (pos(uppercase(ENDSIGN),uppercase(s1)) > 0)
         and (pos(uppercase(ENDSIGN),uppercase(s1)) < 6)
           then break;
     //if pos(uppercase(ENDSIGN),uppercase(s1)) > 0 then break;  //bug 3.9.3
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
   if pythonsyntax1.Checked then begin         //python c#   45810
    for i:= 0 to aStrList.Count -1 do begin
      s1:= aStrList[i];
      t1:= pos(uppercase('class '), uppercase(s1));
      t2:= pos(uppercase('def '), uppercase(s1));
      if (t1 or t2) > 0 then begin
        inc(tstr);
        mstr:= mstr + s1 + #10+#13;
      end;
    end;
   end;
   // if memo1.Color = clblack then maxform1.lbintfList.Color:= clskyblue;  //45810
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
// inderface list to F11

procedure Tmaxform1.ShowInterfaces1Click(Sender: TObject);
begin
  //this is all about declaration
  ShowInterfaces(Act_Filename);
  IntfNavigator1Click(Self);
      memo1.Gutter.BorderColor:= clwindow;      //4.2.4.80
end;

procedure Tmaxform1.ShowLastException1Click(Sender: TObject);
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
      Showmessage('Ex File not ready '+ ExePath+EXCEPTLOGFILE)
  finally
    aStrList.Free;
  end;
end;

     //kh_function demo with graph plot  //to set to late
   { RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterConstructor(@TJvMail.Create, 'Create');
     RegisterMethod('Procedure Free');  RegisterMethod(@TJvMail.Destroy, 'Free');
     RegisterMethod(@TKCustomColors.Assign, 'Assign');
         RegisterPublishedProperties;}  //RIRegister_KMessageBox_Routines
   // CL.AddConstantN('MBVERSION','String').SetString('5.0.2.40');
   //https://github.com/maxkleiner/maXbox4/blob/master/fMain_47650.pas
   //unit SystemRegularExpressions2;  - unit uPSI_RegularExpressions;
   //  with CL.AddClassN(CL.FindClass('TObjectList'),'TKObjectList') do
   //{ CL.AddClassN(CL.FindClass('Class of TIdAuthentication'),'TIdAuthenticationClass');   //3.8
  //CL.AddTypeS('TIdAuthenticationClass', 'class of TIdAuthentication');
  //TVC_RedistVersion = (VC_Redist2013X86, VC_Redist2013X64, VC_Redist2019X64);
  //RIRegister_ALHttpClient2_Routines(S: TPSExec);
  //https://github.com/DeveloppeurPascal/Delphi-samples
  //https://github.com/MagicFoundation/Alcinoe/blob/master/Source/Alcinoe.CGI.pas
  //https://github.com/salvadordf/WebUI4Delphi/tree/main
  //https://github.com/arvanus/Indy/blob/WebSocketImpl/Lib/Core/IdWebSocketSimpleClient.pas
  //https://github.com/adaloveless/commonx/blob/master/PSoCProgrammerCOMLib_TLB.pas
 // https://github.com/adaloveless/commonx/blob/master/webstring.pas
 //https://github.com/maxkleiner/McJSON/tree/main
 //https://regex101.com/
 //https://github.com/project-jedi/jcl/blob/master/jcl/source/common/JclCharsets.pas
 //https://github.com/maxkleiner/DelphiGoogleMap/tree/main/Demo

End.
