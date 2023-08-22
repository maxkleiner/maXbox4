unit HotLog;


    { ****************************************************************** }
    {                                                                    }
    {           Delphi (6) unit  --   LogFile manager, buffered and      }
    {                                 multithreaded.                     }
    {                                                                    }
    {           Copyright © 2004 by Olivier Touzot "QnnO"                }
    {    (http://mapage.noos.fr/qnno/delphi_en.htm  -  qnno@noos.fr)     }
    { v 1.0                                                              }
    { ****************************************************************** }


    //  This unit is freeware, but under copyrights that remain mine for my
    //  parts of the code, and original writters for their parts of the code.
    //  This is mainly the case about "variant open array parameters"
    //  copying routines, that come from Rudy Velthuis' pages on the web at :
    //  http://rvelthuis.bei.t-online.de/index.htm

    //  This unit can be freely used in any application, freeware, shareware
    //  or commercial. However, I would apreciate your sending me an email if
    //  you decide to use it. Of course, you use it under your own and single
    //  responsability. Neither me, nor contributors, could be held responsible
    //  for any problem resulting from the use of this unit.  ;-)

    //  It can also be freely distributed, provided all the above (and current)
    //  lines remain within it unchanged, and the readme.txt and HotLog.chm
    //  help files are distributed with it too.



interface

uses Classes, Windows, Messages, SysUtils, StrUtils, Math,
     Forms,        // needed by "application.XXX"
     Registry,     // SysInfo, Timing
     StdCtrls;     // needed for visual feedback;


const
//Windows messaging sub system:
  UM_HLSOON_USED    = 0;                                       // Change this, to slide HotLog's UM values if needed
  //parser
  UM_HLSERVICEMSG   = WM_USER + UM_HLSOON_USED + 10;           // Parser wake-up message,
  UM_HLACTIONMSG    = WM_USER + UM_HLSOON_USED + 11;           // Parser, line(s) to add.
  //writer & feedBack
  UM_HLSIMPLESTRING = WM_USER + UM_HLSOON_USED + 12;           // Writer thread; decides what to...
  UM_HLSTRINGLIST   = WM_USER + UM_HLSOON_USED + 13;           // ...work with (String or StringList)

//messages for Parser : wParam  ("job to do")
  HL_LINENUMCHANGED = 0;
  HL_SIMPLESTRING   = 1;
  HL_PARSEEXCEPTION = 2;
  HL_JUMPLINES      = 3;
  HL_PARSELINE      = 4;
  HL_PARSELIST      = 5;
  HL_PARSEARRAY     = 6;
  HL_HEAPMONITOR    = 7;
  HL_RAMMONITOR     = 8;
  HL_DSKMONITOR     = 9;
  HL_RESETHEAPTABLE = 10;
  HL_RESETRAMTABLE  = 11;
  HL_RESETRULER     = 12;

// Parser tags
  HLT_AND      = 38;       HLT_PAD      = 42;       HLT_AT       = 64;
  HLT_RAM      = 16799;    HLT_HEAP     = 38281;    HLT_DISK     = 38039;
  HLT_RAM1     = 28319;    HLT_HEAP1    = 38326;    HLT_DISK1    = 38084;
  HLT_RAM2     = 28364;    HLT_HEAP2    = 49846;    HLT_DISK2    = 49604;
  HLT_RAM3     = 39884;    HLT_HEAP3    = 49891;    HLT_DISK3    = 49649;
  HLT_CPUI     = 39320;    HLT_OSVI     = 40101;    HLT_MEM      = 17818;
  HLT_TIMERS   = 57843;    HLT_DHG      = 18571;    HLT_DTE      = 21641;
  HLT_GTC      = 21642;    HLT_HMS      = 19867;    HLT_LNUM     = 39841;
  HLT_NOW      = 20389;    HLT_CRLF     = 47;       HLT_LNUMOFF  = 57910;
  HLT_APP_NAME = 79404;    HLT_APP_PATH = 80181;    HLT_APP_LFN  = 63019;
  HLT_APP_VER  = 62777;    HLT_RULER    = 39664;    HLT_RULER1   = 50672;
  HLT_APP_PRM  = 66094;    APP_PRM_LN   = 77614;


//other const
  MB = 1024*1024;                                   // Bytes conversion to Megs.
  HL_MAX_INT = High(Integer);
  FROM_LINE  : Boolean = True;
  FROM_LIST  : Boolean = False;

//VarRec -> String
  Bool2Str  :     Array[Boolean] of string = ('False', 'True');
  vTypeDesc :     Array[0..16] of String = ('vtInteger','vtBoolean','vtChar',
                  'vtExtended','vtString','vtPointer','vtPChar','vtObject', 'vtClass',
                  'vtWideChar','vtPWideChar','vtAnsiString','vtCurrency','vtVariant',
                  'vtInterface','vtWideString','vtInt64');
  vTypeAsSring :  Array[0..17] of String = ('Integer     : ', 'Boolean     : ', 'Char        : ',
                  'Extended    : ', 'String      : ', 'Pointer     : ', 'PChar       : ',
                  'TObject     : ', 'Class       : ', 'WideChar    : ', 'PWideChar   : ',
                  'AnsiString  : ', 'Currency    : ', 'Variant     : ', 'Interface   : ',
                  'WideString  : ', 'Int64       : ', '#HLType     : ');
  TimeScale2Str : Array[0..3] of String = ('s.', 'ms', 'µs', 'ns');
  TimerUnit2Str : Array[0..3] of String = ( 's.', 'ms.', '"units"', 'cycles' );

type

 {Types généraux}

  TConstArray    = Array of TVarRec;                // "Variant open array parameters"
  TMonitorKind   = (mkHeap, mkRam);
  TVarRecStyle   = (vsNone, vsBasic, vsExtended);   // Wanted output format for VarRec values
  TInt4Array     = Array[0..3] of integer;

  TParseItemKind = (ikStr, ikTag);                  // Kind of a part of a string ("TParseItem"), before parsing

  PParseItem = ^TParseItem;
  TParseItem = Record                               // item (to) parse(d)
    kind     : TParseItemKind;                      // (ikTag | ikStr);
    sValue   : String;                              // Tag or string original | parsed value ;
    iValue   : Cardinal;                            // Tag value, after convertion to a unique integer identifier
    isSingle : Boolean;                             // Filters inLine / standAlone tags
  End;

//Heap and ram monitoring
  THeapMRec = record
    hBlocks,
    hBytes,
    hLoad : Integer;
    hExtra: String;
  End;

  THeapMonitor = Class
  Private
    FKindOfVals : TMonitorKind;
    heapRecords : array of THeapMRec;
    Procedure   AddRec(rec:Integer);
    Procedure   ResetMemTable;
    Function    GetFirstEntry:THeapMRec;
  Public
    Constructor Create(asKind:TMonitorKind);
    Destructor  Destroy;override;
  End;

//Timer
  TQTimeScale   = (tsSeconds, tsMilliSec, tsMicroSec, tsNanosSec);
  TQTimerAction = (taStart,taStop,taGlobalStop);
  TQTimerWanted = (twStart,twStop,twDelta);
  TQTimerKind   = (tkHMS,tkGTC,tkQPC,tkRDT);

  TQTimerEntry  = record
    tStart,
    tStop : int64;
    kind  : TQTimerKind;
  End;


  TQTimer = class
  Private
    FEntry : Array of TQTimerEntry;
    FIsFinalized : Boolean;
    FRegFrq,                                      // Registry stored frequency  * 1000000
    FQpcFrq,                                      // Returned value of QueryPerformanceFrequency
    FRDTOverhead,                                 // direct ASM call overhead
    FQpcOverhead: int64;                          // direct API call overhead
  //Internals
    Function  GetCount: Integer;
    Function  GetStartAsInt(ix:integer):Int64;
    Function  GetStopAsInt (ix:integer):Int64;
    Function  GetDeltaAsInt(ix:integer):Int64;
    Function  GetStartAsStr(ix:integer):String;
    Function  GetStopAsStr (ix:integer):String;
    Function  GetDeltaAsStr(ix:integer):String;
    Function  GetFormatedDeltaAsExt(ix:Integer):Extended;
    Function  GetFormatedDeltaAsStr(ix:Integer):String;
    Function  GetEntry(ix:Integer;wanted:TQTimerWanted):Int64;
    Function  Overhead(ix:Integer):integer;
    Function  GetTimeMeasureAs(timeScale:TQTimeScale; measure:Int64; counter:TQTimerKind):real;
    Function  GetOptimalMeasure(measure:Int64; counter:TQTimerKind; var tScale:TQTimeScale):real;
    Procedure Store(value:Int64;inOrOut:TQTimerAction;timerKind:TQTimerKind);
    Function  Int64ToTime(value:Int64):String;
    Procedure InitTimerEnvir;
  Public
    fmtOutput        : String;                    // Used for the Format() function ; Defaults to '%3.9n'
    timeUnitsWanted  : Set of TQTimeScale;
    removeOverHead,
    deltaShowNatives,                             // outputs deltas in native units;
    deltaShowOptimal : Boolean;                   // outputs deltas in the most "readable" unit possible;

    Constructor Create;
    Destructor  Destroy; override;

    Function  HMS(startOrStop:TQTimerAction=taStart):TDateTime;
    Function  GTC(startOrStop:TQTimerAction=taStart):Integer;
    Function  QPC(startOrStop:TQTimerAction=taStart):Int64;
    Function  RDT(startOrStop:TQTimerAction=taStart):Int64;
    Procedure GlobalStop;
    Procedure Reset;

    Property isFinalized        : Boolean  Read FIsFinalized;
    Property RegistryFreq       : int64    Read FRegFrq;
    Property QueryPerfFreq      : Int64    Read FQpcFrq;
    Property ReaDTSCOverhead    : int64    Read FRDTOverhead;
    Property QueryPerfOverhead  : int64    Read FQpcOverhead;

    Property Count              : integer  Read GetCount;
    Property iStart[ix:Integer] : int64    Read GetStartAsInt;
    Property iStop [ix:Integer] : int64    Read GetStopAsInt;
    Property iDelta[ix:Integer] : int64    Read GetDeltaAsInt;

    Property sStart[ix:Integer] : String   Read GetStartAsStr;
    Property sStop [ix:Integer] : String   Read GetStopAsStr;
    Property sDelta[ix:Integer] : String   Read GetDeltaAsStr;

    Property iDeltaFmt[ix:Integer] : Extended Read GetFormatedDeltaAsExt;
    Property sDeltaFmt[ix:Integer] : String   Read GetFormatedDeltaAsStr;
  End;
  

//log file name management
  PFlName = ^FlName;
  FlName  = record                      // Will temporary store existing files names...
    fullName: TFileName;                // ...descriptions in order to manage generations.
    ext3: String;
    isGdg:Boolean;
  end;

  THLFileDef = Class                    // Log file name and acces mode definition
  private
  //fields
    FPath,                              // Log path
    FDdn,                               // log name, without path nor ext
    FExt,                               // log extention. '.log' by default if non GDG, gdg count otherwise
    FLFN     : string;                  // Long file name
    FGDGMax  : word;                    // max Number of generations to keep. 0 < GDG < 999. //0 <=> no gdg
    FDoAppend: Boolean;                 // Shall log be emptied or not ? , if exists. Ignored if FGDGMax > 0
    FBuild   : Boolean;                 // "BuildFileName" function soon called or not;
  //procs & functions
    procedure SetPath(Value:String);
    procedure SetExt(Value:String);
    procedure SetFileName(lfn:TFileName);
    procedure SetDoAppend(Value:Boolean);
    procedure SetGdgMax(Value:Word);
    function  BuildFileName:TFileName;
    function  GetGdg(sL:TList):String;
    function  GetFileName:TFileName;
    function  GetOpenMode:Word;
    Function  FileInUse(f: string): Boolean;
  public
    constructor create;
    destructor destroy; override;
    property   ddname   : String     Read FDdn           write FDdn;
    property   path     : String     Read FPath          write SetPath;
    property   ext      : String     Read FExt           write SetExt;
    property   fileName : TFileName  Read GetFileName    write SetFileName;
    property   append   : Boolean    Read FDoAppend      write SetDoAppend;
    property   gdgMax   : Word       Read FGDGMax        write SetGdgMax;
    property   OpMode   : Word       Read GetOpenMode;
  end;{class THLFileDef}


 {Internal messages, used for communication between threads}

  THLStringMsg = class                        // basic string
  private
    FHlMsg:string;
    constructor Create(s:string);
    procedure   Post(toThread:THandle; kindOfString:integer=HL_SIMPLESTRING);
  public
    destructor  Destroy;override;
  end;


  THLConstArrayMsg = class                    // Arrays of const
    FConstArray: TConstArray;
    FOutputStyle:TVarRecStyle;                // basic or extended output
    constructor Create(outputStyle:TVarRecStyle);
    procedure   Post(toThread:THandle);
  public
    destructor  Destroy;override;
  end;


  THLErrMsg = class                           // Exceptions ans errors to be parsed
  private
    FEMsg:String;
    FlastErr:Integer;
    Ffull:Boolean;
    FFunc:String;
    Fargs:TConstArray;
    procedure   Post(toThread:THandle);
    constructor Create;
  public
    destructor  Destroy;override;
  end;


  THLHeapMonMsg = Class                       // Heap & Ram values monitoring message
  private
    FBlocks,
    FBytes,
    FLoad : Integer;
    FExtra : String;
    Procedure   Post(toThread:THandle;RamOrHeap:Integer;dirOutput:Boolean=False);
    constructor Create(bl,by,ld:Integer;ex:String);
  public
    Destructor  Destroy;override;
  End;


 {Thread : Parser}

  THotLogParser = class(TThread)
  private
    mxHLLineNum : THandle;
    FStarted    : Boolean;
    FWriterTID  : THandle;                       // Writer ThreadId, needed to post messages to.
  //Lines counting
    FpvLineCount: Cardinal;
    FshowLineNum: Boolean;
    FpvLnNumLen : Word;
    FShowLNTemp : Boolean;                       // used for temporary override;
    FpvMaxValue : Cardinal;                      // ;-)
    FpvLnAlign  : TAlignment;                    // line numbers output formatting;
  //Ruler
    fRulerLength:Integer;
    fRulerDots,
    fRulerNums: String;
    fRulerBuild: Boolean;
  //Error displaying
    FErrorCaption : String;
    FErrViewStyle : TVarRecStyle;                // (vsBasic, vsExtended)
    FErrJumpLines,
    FErrIsSurrounded : Boolean;
    FErrSurroundChar,
    FErrSurroundLine,
    FErrWideSurround : String;
  //Timers
    FsRegSpeed:String;                           // Proc speed, from registry
  protected
    FLnShowNum: Boolean;
    FLnNumLen : Integer;
    FLnAlign  : TAlignment;
  private
    HMonitor  : THeapMonitor;
    RMonitor  : THeapMonitor;
  //Line Numbers management
    Procedure UpdateLineNum;
    Function  GetLineNum:String;
    Function  AddLineNum(line:String):String;  overload;
    Procedure AddLineNum(Var lst:TStringList); overload;
  //Errors display setting
    Procedure SetFErrCaption(Value:String);
    Procedure SetFErrSurroundChar(Value:String);
  //VarRec handling
    Function  VarRecToStr(vr:TVarRec):String;
    Function  ConstArrayToString(const Elements: array of const;
                                 style:TVarRecStyle=vsBasic): String;
    Function  ConstArrayToTSList(const Elements: array of const): TStringList;
    Procedure FinalizeVarRecArray(var Arr: TConstArray);
    Procedure FinalizeVarRec(var Item: TVarRec);
    Function  GetBasicValue(s:String; vKind:Byte):String;
    Function  GetOriginalValue(s:String):String;
  //parsing
    Function  ParseLine(source:String):TStringList;
    Function  ParseList(source:Integer):TStringList;
    Function  ParseArray(source:integer):TStringList;
    Function  LineToList(line:String):TList;
    Function  ExtractItem(Var source:String; Var itm:PParseItem):Boolean;
    Procedure PrepareParsing(var lst:Tlist);
    Procedure TranslateTags(var lst:Tlist; var omitLNum:Boolean);
    Function  PadString(src,tag:String; posPtr:Integer):String;
    Procedure FreeParsedList(var l:TList);
    Function  GetRegValue(root:HKey;key,wanted:String):String;
    Function  GetParams(singleline:Boolean):String;
    Function  GetVersionAsText:String;
    Function  CurrentNumVer:TInt4Array;
    Procedure GetRuler(var lst:TList;showNums:Boolean=True);
    Procedure ResetRuler(value:integer);
    Function  GetHeap(HeapRec,outFmt:integer):TStringList;
    Function  GetRam(HeapRec,outFmt:integer):TStringList;
    Function  GetDisk(outFmt:Integer):TStringList;
    Procedure GetMemoryStatus(var lst:TList);
    Procedure GetCPUInfoAsPitem(var hLst:Tlist);
    Procedure GetOSVIAsPitem(var lst:Tlist);
    Procedure GetRamOrHeapAsPitem(RamOrHeap,HeapRec,outFmt,ptr:integer; var hLst:Tlist);
    Procedure GetTimerResolutionsAsPitem(var lst:Tlist);
    function  ParseException(exRec:Integer):TstringList;

    property  ErrorCaption : String read FErrorCaption    write SetFErrCaption;
    property  SurroundCh   : String read FErrSurroundChar write SetFErrSurroundChar;
    constructor Create(createSuspended:Boolean);

  public
    procedure   Execute; override;
    destructor  Destroy; override;
  end;


 {Thread : Writer}

//  Writer thread will have to partly manage the feedback, in order to :
//  -1- Choose whether freeing memory of received lines, or
//  -2- Send them to the FeedBackThread, which thus will be in charge of
//      freing the memory.

  THotLogWriter = class(TThread)
  private
    FStarted,
    FDoFeedBack : Boolean;
    FVisualTID  : THandle;                       // Feedbacker ThreadId
  public
    hlFileDef   : THLFileDef;                    // The log file name to use
    constructor Create(createSuspended:Boolean);
    destructor  Destroy; override;
    procedure   Execute; override;
  end;


 {Thread : Visual feedback}

  THotLogVisual = class(TThread)
  private
    mxHLFeedBack:THandle;                       // Feedback suspention control.
    FfbMemo     : TMemo;
    FDoFeedBack,
    FDoScroll   : Boolean;
  public
    FStarted:Boolean;
    s: String;
    sl:TStringList;
    constructor Create(createSuspended:Boolean);
    destructor  Destroy; override;
    procedure   Execute; override;
    procedure   RemoveCRLF(fromWhat:Boolean);
    procedure   DisplayLine;                    // Synchronised procs. Execute...
    procedure   DisplayList;                    // ... in main thread
  end;


 {HotLog public interface}

  THotLog = Class
  private
    FStarted:Boolean;
    hlParser:THotLogParser;                   // parser thread
    hlVisual:THotLogVisual;                   // feedBack manager thread
  //VarRec handling
    Function CreateConstArray(const Elements: array of const): TConstArray;
    Function CopyVarRec(const Item: TVarRec): TVarRec;
  public
    hlWriter :  THotLogWriter;                // made public, to allow direct acces to the log file name definition properties.
    header,
    footer   :  TStringList;
    constructor Create;
    destructor  Destroy;override;
  //Settings
    Procedure   DisplayFeedBackInto(aMemo:TMemo);
    Function    StopVisualFeedBack:Boolean;
    Procedure   ScrollMemo(doScroll:Boolean);
    Procedure   SetErrorCaption(value:String; surroundChar:String; jumpLines:Boolean=True);
    Procedure   SetErrorViewStyle(style:TVarRecStyle);
    Procedure   SetRulerLength(newLength:Integer);
    Function    ModifyLineNumbering(doShow:Boolean; alignment:TAlignment=taRightJustify;
                                    size:Integer=3):Boolean;
  //ram & heap monitoring
    Procedure   ResetHeapTable;
    Function    HeapMonitor(hmExtra:String='';directOutput:Boolean=False):THeapMRec;
    Procedure   ResetRamTable;
    Function    RamMonitor(hmExtra:String='';directOutput:Boolean=False):THeapMRec;
  //Logging
    Procedure   StartLogging;
    Procedure   JumpLine(LinesToJump:Integer = 1);
    Procedure   Add(aString:String); overload;                                    // Parsing involved
    Procedure   Add(aStringList:TStringList); overload;                           // Parsing involved
    Procedure   Add(style:TVarRecStyle;aConstArray:Array of Const); overload;     // Parsing involved
    Procedure   AddStr(aString:String);                                           // -No- parsing
    Procedure   AddException(ex:Exception; err:Integer=0; freeAfterPost:Boolean=False); overload;
    Procedure   AddException(ex:Exception; func:String; args : Array of const;
                               err:Integer=0; freeAfterPost:Boolean=False);overload;
    Procedure   AddError(err:Integer); Overload;
    Procedure   AddError(err:Integer; func:String; args : Array of const); Overload;
  end;

{Thread:Main(VCL)}
Function  CompareGdgNames(p1, p2: Pointer): Integer;
Function  RDTSC: Int64; assembler;


var
// hLog itself, alone but proud...
  hLog : THotLog;



implementation


    {----------------------------------------------------------}
    {---        Threads:Main(VCL) : File definition         ---}
    {----------------------------------------------------------}
    { Will be used to acces the log file. File name is set ;   }
    { If generations have to be managed, -> rename (and needed }
    { deletions) are made.                                     }
    {----------------------------------------------------------}


constructor THLFileDef.Create;
Begin
  inherited;
  Path     := ExtractFilePath(Application.ExeName);
  FDdn     := ChangeFileExt(ExtractFileName(Application.ExeName),'');
  FExt     := '.log';
  FGDGMax  := 0;                                     // as long as an ext is provided, no gdg is managed
  FDoAppend:= False;                                 // if exists, will be overrided
  FBuild   := False;
End;


destructor THLFileDef.destroy;
begin
  inherited;
end;


function THLFileDef.GetFileName:TFileName;
Begin
  If (FGDGMax = 0) Or (Self.FBuild)
     Then result := FPath + FDdn + FExt
     Else result := BuildFileName;
End;


procedure THLFileDef.SetFileName(lfn:TFileName);
//  Sets the full log name
Begin
  If lfn <> '' Then
  Begin
    FPath := ExtractFilePath(lfn);                   // if not provided...
    If FPath <> '' Then SetPath(FPath);              // ...current path is kept
    FDdn  := ChangeFileExt(lfn,'');
    If FDdn = '' Then FDdn := 'LogRecord';           // '' is forbidden;
    FExt  := ExtractFileExt(lfn);
    If FExt <> '' then FGDGMax := 0;                 // If provided, THLFileDef is no longer supposed to manage GDG
  End
End;


procedure THLFileDef.SetPath(Value:String);
Begin
  If value <> '' then                                // Otherwise unchanged.
  Begin
     If value[length(value)]<>'\' then value := value + '\';
     self.FPath := value;
  End;
End;


procedure THLFileDef.SetExt(Value:String);
Begin
  If Value[1] <> '.' Then value := '.' + value;
  Self.FExt := Value;                                // empty allowed
  Self.GdgMax := 0;                                  // Gdg no longer managed
End;


procedure THLFileDef.SetDoAppend(Value:Boolean);
Begin
  Self.FDoAppend := Value;
  If Value Then Self.FGDGMax := 0;                   // Gdg no longer managed
End;


procedure THLFileDef.SetGdgMax(Value:Word);
Begin
  If Value > 999 Then Self.FGDGMax := 999
                 Else Self.FGDGMax := Value;
  If Value > 0 Then Self.FDoAppend := False;
End;


Function THLFileDef.GetOpenMode:Word;
Begin
  If Self.FDoAppend
     Then  Result := fmOpenReadWrite OR fmShareDenyWrite
     Else  Result := fmCreate OR fmShareDenyWrite;
End;


Function THLFileDef.BuildFileName:TFileName;
// Called only if gdg extention has to be managed.
// Returns the long file name of the new log.
Var sRec:TSearchRec;
    lstFlNames: TList;
    sTmp:String;
    aGdgRec: PFlName;
Begin
  // First populate a list of potential "on disk"
  // log files (extention temporary ingnored)
  lstFlNames := TList.Create;                                 // allways created, to avoid compiler warning
  TRY {Finally}
  TRY {Except}
    sTmp   := self.path + self.ddname + '.*';
    If FindFirst(sTmp, faAnyfile, sRec) = 0 Then
    Begin
      new(aGdgRec);
      aGdgRec^.fullName := self.path + sRec.Name;
      aGdgRec^.isGdg := False;                                // will be tested later, if needed
      lstFlNames.Add(aGdgRec);
      While ( FindNext(sRec) = 0 ) Do
      Begin
        new(aGdgRec);
        aGdgRec^.fullName := self.path + sRec.Name;
        aGdgRec^.isGdg := False;
        lstFlNames.Add(aGdgRec);
      End;
      FindClose(sRec);
      Result := self.path + self.ddname + GetGdg(lstFlNames); // GetGdg wil return the new generation number
    End Else Result := path + ddname + '.001';                // No fileName actually looks like the one wanted
  EXCEPT  Result := self.ddname + '.~og'; END;

  FINALLY                                                     // Cleanup list items then the list
    TRY
    Self.FBuild := True;
    Self.FPath  := ExtractFilePath(result);
    Self.FDdn   := ChangeFileExt(ExtractFileName(result),'');
    Self.FExt   := ExtractFileExt(result);
    Self.FLFN   := Result;
    While lstFlNames.Count > 0 do
    Begin
      If assigned(lstFlNames[0]) Then
      Begin
        aGdgRec := lstFlNames.Items[0];
        Dispose(aGdgRec);
      End;
      lstFlNames.Delete(0);
    End;
    lstFlNames.Free;
    EXCEPT; END;
  END;
End;


Function THLFileDef.GetGdg(sL:TList):String;

// Called only if at least one file still exists, with a "gdg looking like"
// filename. Sets the generation number of a gdg file.
// (".001" < gdg < "."gdgmax ). Lists all gdg present with the ddn HLFileDef.ddname,
// and keeps only the gdgMax -1 most recent (highest gdg) ones, & renames them
// (001..gdgMax-1). Then returns the new gdg extention. NOT(FileExists)  and
// NOT(InUse) newFileName are controlled too.

Var gTmp,i: Integer;
    sTmp: String;
    Succes: Boolean;
    aGdgRec: PFlName;
Begin
  TRY
    For i := 0 To sL.count -1 Do
    Begin
      sTmp := RightStr(ExtractFileExt(PFlName(sL.items[i]).fullName),3);
      TRY StrToInt(sTmp);
          PFlName(sL.items[i]).ext3  := sTmp;                            // PROGRAMMERS, if an ex raises : Keep cool !...
          PFlName(sL.items[i]).isGdg := True;                            // ...EConvertError wonn't appear at run time
      EXCEPT
          aGdgRec := PFlName(sL.items[i]);
          Dispose(aGdgRec);                                              // not a gdg file name...
          sL.items[i] := nil;                                            // ...then, remove it
      END;
    End;

   {pack will apply the deletions, if any happened}
    sL.Pack;                                                             // sL now contains gdg fileNames only.
    If sL.Count = 0 Then
    Begin
      Result := '.001';
      Exit;
    End;

    If sL.count > 1 Then sL.Sort(@CompareGdgNames);                      // let's sort them ascending
    For i:= 0 To sl.Count - self.gdgMax Do
    Begin
      If DeleteFile(PFlName(sL.items[i]).fullName) Then
         sL.Items[i] := nil;                                             // If unable to delete... keep that generation
    End;

    sl.Pack;
    Succes := True;
    For i:= 0 To sl.Count - 1 Do                                         // Now tries to rename each kept file
    Begin
      sTmp := IntToStr(i+1);                                             // generation numbers, starting from "001"
      While Length(sTmp) < 3 Do sTmp := '0' + sTmp;
      sTmp := ChangeFileExt(PFlName(sL.items[i]).fullName, '.' + sTmp);
      If NOT( RenameFile (PFlName(sL.items[i]).fullName, sTmp) ) Then
         succes := False;
    End;

    If succes
       Then gTmp := sl.Count + 1
       Else Begin
              sTmp := RightStr(ExtractFileExt(PFlName(sL.items[sl.Count]).fullName),3);
              TRY    gTmp := StrToInt(sTmp) +1;                          // will try to assign the new generation a number
              EXCEPT gTmp := 999;                                        // higher than the one soon present.
              END;
            End;

    Result := IntToStr(gTmp);
    While Length(Result) < 3 Do Result := '0' + Result;
    Result := '.' + Result;
    sTmp := ChangeFileExt(PFlName(sL.items[0]).fullName, result);
    If NOT(Succes) OR FileExists(sTmp)
       OR FileInUse(sTmp) Then result := '.~og';
  EXCEPT Result := '.~og';
  END;
End;


Function THLFileDEf.FileInUse(f: string): Boolean;         // NIH
var hF: HFILE;
begin
  Result := False;
  If not FileExists(f) then exit;
  hF := CreateFile(PChar(f),
                   GENERIC_READ or GENERIC_WRITE,
                   0, NIL, OPEN_EXISTING,
                   FILE_ATTRIBUTE_NORMAL, 0);
  Result := (hF = INVALID_HANDLE_VALUE);
  If NOT Result Then CloseHandle(hF);
end;


//Non object-linked functions

Function CompareGdgNames(p1, p2: Pointer): Integer;
//Seems that it has to be external to the class (?)
begin
  Result := CompareText(PFlName(p1).ext3,
                        PFlName(p2).ext3);
end;


Function RDTSC: Int64; assembler;               // NIH...  Result in EAX and EDX (Int64)
asm
  Rdtsc                                         // <=> DB $0F,$31  (for versions below D4 ?)
end;



    {---------------------------------------------------------------------}
    {---                   Threads : Main(VCL) : hotLog                ---}
    {---------------------------------------------------------------------}
    { THotLog methodes execute in the main thread,and are kept as basic   }
    { as possible, to avoid costing time. Most of the work will be done   }
    { in the parser thread.                                               }
    { Strings aso. to logg are sent to the parser throught messages build }
    { at run time. The parser is responsible for freeing the corresponding} 
    { memory, and possibly sending messages to the "feedbacker".          }
    {---------------------------------------------------------------------}


constructor THotLog.Create;
Begin
  hlParser  := THotLogParser.Create(True);                 // suspended, waiting for resume
  hlWriter  := THotLogWriter.Create(True);

  Self.header := TstringList.Create;
  With Self.Header Do
  Begin
    Add('{/}{LNumOff}{*80*}');                             // <=>  Add('{LNumOff}{/}{}{*80*}');   <- empty tag
    Add('>>>> Start {App_name}  v {App_ver}{80@}{&}{dte} {hms}{&}');
    Add('{@12}From : {App_path}');
    Add('{@12}Prms : {App_prm-}{/}');
  End;

  Self.footer := TStringList.Create;
  With self.Footer Do
  Begin
    Add('{LNumOff}');
    Add('<<<< Stop  {App_name}{80@}{&}{dte} {hms}{&}');
    Add('{*80*}{/}');
  End;

  While Not(Self.hlParser.FStarted) Do sleep(5);
  While Not(Self.hlWriter.FStarted) Do sleep(5);

  hlParser.FWriterTID := hlWriter.ThreadID;
  With hlParser Do
  Begin
    FErrJumpLines := True;
    SurroundCh    := '•';
    ErrorCaption  := '•••    E R R O R    •••';
    FErrViewStyle :=  vsBasic;
  End;
  Self.FStarted := False;                         // will be set to true once writer and parser...
End;                                              // ... resume methode will have been called


destructor THotLog.Destroy;
Begin
  // First of all, tries to Stop visualFeedBack, waiting up to one half a second.
  If assigned(hlVisual) Then
     If Not Self.StopVisualFeedBack Then
        Self.StopVisualFeedBack;

  // Then stops both parser and writer. The particular point is that
  // they are almost surely assigned, but may never have been 'resumed'.
  // In such a case, WaitFor would wait for a very, very long time...

  If Assigned (HLParser) Then
  Begin
    If Not(hlparser.Suspended) Then
    Begin
      PostThreadMessage(HLParser.ThreadId, WM_Quit,0,0);
      HLParser.WaitFor;
    End;
    HLParser.Free;
  End;

  If Assigned (HLWriter) Then
  Begin
    If Not(HLWriter.Suspended) Then
    Begin
      PostThreadMessage(HLWriter.ThreadID, WM_Quit,0,0);
      HLWriter.WaitFor;
    End;
    HLWriter.Free;
  End;
  
  // Visual has FreeOnTerminate := True;
  If assigned(hlVisual) Then hlVisual.Terminate;

  If Assigned(footer)   Then footer.Free;
  If Assigned(header)   Then header.Free;

  Inherited;
end;



Procedure THotLog.DisplayFeedBackInto(aMemo:TMemo);

// Enables (or re-enables) the showing of the logged strings into a memo.

// If Writer no longer runs, nothing to do...
// Otherwise : Instanciate FeedBacker if needed, give it the memo handle,
// give its threadID to writer (in order for him to now to whom to post
// visual feedBack datas), then tries to catch the FDoFeedBack protection
// mutex, and enable feedBack.

var tries: Integer;
    done : Boolean;
Begin
  If (WaitForSingleObject(Self.hlWriter.Handle, 0) <> WAIT_TIMEOUT) Then Exit;
  TRY
    If Not (assigned( hlVisual )) Then
    Begin
      hlVisual := THotLogVisual.Create(false);
      tries := -1; 
      done := False;
      While not(done) Do
      Begin
        Sleep(5); Inc(tries);
        Done := (hlVisual.FStarted) Or (tries > 9);
      End;
      If Not(hlVisual.FStarted) Then Exit;

      hlWriter.FVisualTID := hlVisual.ThreadID;
      hlVisual.FfbMemo    := aMemo;
    End;
    
    If (WaitForSingleObject(Self.hlVisual.mxHLFeedBack,50) = WAIT_OBJECT_0) Then
    Begin
      hlVisual.FDoFeedBack := True;     
      hlWriter.FDoFeedBack := True;
      ReleaseMutex(Self.hlVisual.mxHLFeedBack);
    End;
    EXCEPT; END;
End;


Function THotLog.StopVisualFeedBack:Boolean;

// StopVisualFeedback doesn't stop the feedBack Thread, but says Writer to stop
// accessing that thread, and says "FeedBacker" to stop accessing the memo.
// The feedBack thread is still available, and can be launched again through a
// new call to DisplayFeedBackInto(aMemo:TMemo);

// The function returns True if it succeeds, False otherwise. You should
// ALLWAYS check this return before choosing wether closing or hidding the
// form upon which your log feedback memo is, if it isn't on your application's
// main Form.

Begin
  Result := (WaitForSingleObject(Self.hlVisual.mxHLFeedBack,50) = WAIT_OBJECT_0);
  If result Then
  Begin
    hlVisual.FDoFeedBack := False;
    hlWriter.FDoFeedBack := False;
    ReleaseMutex(Self.hlVisual.mxHLFeedBack);
  End;
End;


Procedure THotLog.ScrollMemo(doScroll:Boolean);
Begin
  If Not (assigned( hlVisual )) Then Exit;
  hlVisual.FDoScroll := doScroll;
End;

Function THotLog.ModifyLineNumbering(doShow:Boolean;
                                     alignment:TAlignment=taRightJustify;
                                     size:Integer=3):Boolean;

// Log's line numbers management. Can be called at any moment during run time.
// Notify changes to the parser through messages.
// If the parser can't be reached, the function returns false, otherwise it 
// returns true. 

// Line numbers will typically be added at the begining of any line, aligned right,
// on 3 positions (size:=3) , padded with space(s), and followed by one more space.

// Line numbers are NOT displayed by default; hlParser constructor sets line 
// numbering fields to : (doShow: False;  alignment: taRightJustify;  size:3);

// Line counting is allways maintained, be line numbers displayed or not.

// If lineNum representation grows above "size" (for example if you did set
// size to 3 and your log reaches 1000 lines (!), then the size parameter is
// ignored (unless you change it for something bigger);

Begin
  result := (WaitForSingleObject(self.hlParser.mxHLLineNum,50) = WAIT_OBJECT_0);
  If result Then
  Begin
    If size = 0 Then Self.HLParser.FLnShowNum := False
                Else Self.HLParser.FLnShowNum := doShow;
    self.HLParser.FLnAlign   := alignment;
    self.HLParser.FLnNumLen  := size;
    ReleaseMutex(self.hlParser.mxHLLineNum);
    //now notifies the parser to take these changes into account;
    PostThreadMessage(Self.HLParser.ThreadId,UM_HLSERVICEMSG,HL_LINENUMCHANGED,0);
  End;
End;


procedure THotLog.SetErrorCaption(value:String;surroundChar:String;
                                  jumpLines:Boolean=True);
                                  
// Defines how errors will appear in the log file. "Value" is the string the
// error line will start with ; If surroundChar is provided, it will be expanded
// -> at least to the size of "value" and will be added above and bellow the error line ;
// -> up to at least 80 characters, if SetErrorViewStyle is set to vsExtended.
//    (see procedure SetErrorViewStyle below)
// If Jumpline is set, an empty line will be added too, before and after line(s).

Begin
  With hlParser Do
  Begin
    If value = '' Then
    Begin
      FErrJumpLines := False;
      SurroundCh    := '';
      ErrorCaption  := '';
    End Else
    Begin
      SurroundCh    := surroundChar[1];
      ErrorCaption  := value;
      FErrJumpLines := jumpLines;
    End
  End;
End;


procedure THotLog.SetErrorViewStyle(style:TVarRecStyle);

// vsBasic or vsExtended : Decides how wide the error surrounding line
// will be. If vsBasic, the suround line will be of the same length than
// the "ErrorCaption" you provided ; if extended, it will be expanded to
// at least 80 chars.
// Ignored if SetErrorCaption() above passed an empty 'Value'.

Begin
  Self.hlParser.FErrViewStyle := style;
End;


procedure THotLog.StartLogging;
// Where everything begins...
Begin
  If Self.FStarted Then Exit;
  hlParser.Resume;
  hlWriter.Resume;
  Self.FStarted := True;  
End;


Procedure THotLog.SetRulerLength(newLength:Integer);
Begin
  If newLength > 0 Then
     PostThreadMessage(Self.hlParser.ThreadId,UM_HLSERVICEMSG,HL_RESETRULER,newLength);
End;


Procedure THotLog.ResetHeapTable;
Begin
  PostThreadMessage(Self.hlParser.ThreadID, UM_HLSERVICEMSG,
                    HL_RESETHEAPTABLE,0);
End;

Function THotLog.HeapMonitor(hmExtra:String='';directOutput:Boolean=False):THeapMRec;

//  -> hmExtra is a user defined string that may be added to the end of
//  the (first) line of outputed values ; As long as StandAlone tags are
//  parsed in one "pass" only, hmExtra cannot be an inline tag, but only a string.
//  -> If directOutput is set, values won't be stored. HeapTable will stay unchanged.
//  -> The result of the call is transmitted into result.hExtra, under the form
//  of a "boolean string", which can be read throught delphi function StrToBool();
//  However, testing (result.hblock=0) or (result.hbytes=0) would give the very
//  same information...

var bl,by :Integer;
Begin
  If (WaitForSingleObject(Self.hlParser.Handle, 0) <> WAIT_TIMEOUT) Then Exit;
  TRY
    bl := AllocMemCount;
    by := AllocMemSize;
    result.hBlocks := bl;
    result.hBytes  := by;
    result.hLoad   := 0;
    result.hExtra  := '1';                            // StrToBool('1') -> True;
    With THLHeapMonMsg.Create(bl,by,0,hmExtra) Do Post(Self.hlParser.ThreadID,
                                                       HL_HEAPMONITOR,
                                                       directOutput);
  EXCEPT
    result.hBlocks := 0;
    result.hBytes  := 0;
    result.hLoad   := 0;
    result.hExtra  := '0';                            // StrToBool('0') -> False
  END;
End;


Procedure THotLog.ResetRamTable;
Begin
  PostThreadMessage(Self.hlParser.ThreadID, UM_HLSERVICEMSG,
                    HL_RESETRAMTABLE,0);
End;

Function THotLog.RamMonitor(hmExtra:String='';directOutput:Boolean=False):THeapMRec;
var bl,by,ld: Integer;
    mSS:   TMemoryStatus;
Begin
  TRY
    mSS.dwLength := SizeOf(mSS);
    GlobalMemoryStatus(mSS);

    bl := mSS.dwTotalPhys;
    by := mSS.dwAvailPhys;
    ld := mSS.dwMemoryLoad;

    result.hBlocks := bl;
    result.hBytes  := by;
    result.hLoad   := ld;
    result.hExtra  := '1';                                 // "True"
    With THLHeapMonMsg.Create(bl,by,ld,hmExtra) Do Post(Self.hlParser.ThreadID,
                                                        HL_RAMMONITOR,
                                                        directOutput);
  EXCEPT
    result.hBlocks := 0;
    result.hBytes  := 0;
    result.hLoad   := 0;
    result.hExtra  := '0';                                 // "False"
  END;
End;



procedure THotLog.JumpLine(linesToJump:Integer = 1);
//  writes "linesToJump" CRLF.
var i: Integer;
Begin
  If (linesToJump < 1)  Then exit
  Else If (WaitForSingleObject(Self.hlParser.Handle, 0) = WAIT_TIMEOUT)
       Then PostThreadMessage(Self.hlParser.ThreadID, UM_HLACTIONMSG,HL_JUMPLINES, linesToJump)
       Else For i := 0 To linesToJump -1 Do Self.AddStr(#13#10);
end;


procedure THotLog.Add(aString:String);
Begin
  If (WaitForSingleObject(Self.hlParser.Handle, 0) = WAIT_TIMEOUT) Then
  With THLStringMsg.Create(aString) Do Post(Self.hlParser.ThreadID,
                                          HL_PARSELINE);
End;


procedure THotLog.Add(aStringList:TStringList);
var sl: TStringList;
Begin
  TRY
    sl := TStringList.Create;
    sl.Assign(aStringList);
    If (WaitForSingleObject(Self.hlParser.Handle, 0) = WAIT_TIMEOUT) Then
        PostThreadMessage(Self.hlParser.ThreadId, UM_HLACTIONMSG,
                          HL_PARSELIST,Integer(sl));
  EXCEPT With THLStringMsg.Create('#HL_Invalid_TSList') Do
              Post(Self.hlParser.ThreadID, HL_SIMPLESTRING);
  END;
End;


Procedure THotLog.Add(style:TVarRecStyle;aConstArray:Array of Const);
Begin
  With THLConstArrayMsg.Create(style) Do
  Begin
    FConstArray := Self.CreateConstArray(aConstArray);
    post(Self.hlParser.ThreadID);
  End;
End;



procedure THotLog.AddStr(aString:String);
// aString will be written without parsing.
Begin
  If (WaitForSingleObject(Self.hlParser.Handle, 0) = WAIT_TIMEOUT) Then
      With THLStringMsg.Create(aString) Do Post(Self.hlParser.ThreadID);
End;


procedure THotLog.AddException(ex:Exception; func:String; args : Array of const;
                               err:Integer=0; freeAfterPost:Boolean=False);
// Overloaded definition, used for transmission of routine names and parameters
Begin
  TRY
  If (WaitForSingleObject(Self.hlParser.Handle, 0) = WAIT_TIMEOUT) Then
  Begin
    With THLErrMsg.Create Do                                    // Build message
    Begin
      FEMsg    := ex.message;
      FlastErr := err;
      Ffull    := Length(args) > 0;
      FFunc    := func;
      FArgs    := Self.CreateConstArray(args);
      Post(Self.hlParser.ThreadID);
    End;
    If freeAfterPost Then ex.Free;
  End;
  EXCEPT
  END;
End;


procedure THotLog.AddException(ex:Exception;err:Integer=0;freeAfterPost:Boolean=False);
// BAsic Exception storage and sending.
Begin
  TRY
  If (WaitForSingleObject(Self.hlParser.Handle, 0) = WAIT_TIMEOUT) Then
  Begin
    With THLErrMsg.Create Do
    Begin
      FEMsg    := ex.message;
      FlastErr := err;
      Ffull    := False;
      Post(Self.hlParser.ThreadID);
    End;
    If freeAfterPost Then ex.Free;
  End;
  EXCEPT
  END;
end;


procedure THotLog.AddError(err:Integer; func:String; args : Array of const);
Begin
  Self.AddException(Exception.Create(SysErrorMessage(err)),
                    func, args, err, True);
End;


procedure THotLog.AddError(err:Integer);
// basic procedure, to allow "exception formatting" for errors too;
Begin
  Self.AddException(Exception.Create(SysErrorMessage(err)), err, True );
End;



////////////////////////////////////////////////////////////////////////////////
// Handling tVarRec  (Main thread's side)
////////////////////////////////////////////////////////////////////////////////

function THotLog.CreateConstArray(const Elements: array of const): TConstArray;   // (c)Rudy Velthuis
var I: Integer;
begin
  SetLength(Result, Length(Elements));
  For I := Low(Elements) to High(Elements) do
      Result[I] := CopyVarRec(Elements[I]);
end;


function THotLog.CopyVarRec(const Item: TVarRec): TVarRec;           // (c)Rudy Velthuis
// "Copies a TVarRec and its contents. If the content is referenced
// the value will be copied to a new location and the reference updated."   (Rudy V.)
var W: WideString;
    S: String;
begin
  Result := Item;                                 // Copy entire TVarRec first.
    case Item.VType of                            // Now handle special cases.
      vtExtended:
        begin
          New(Result.VExtended);
          Result.VExtended^ := Item.VExtended^;
        end;
      vtString:
        begin
          New(Result.VString);
          Result.VString^ := Item.VString^;
        end;
      vtPChar:
        Result.VPChar := StrNew(Item.VPChar);
      vtPWideChar:                                // There is no StrNew for PWideChar.
        begin
          W := Item.VPWideChar;
          GetMem(Result.VPWideChar,
                 (Length(W) + 1) * SizeOf(WideChar));
          Move(PWideChar(W)^, Result.VPWideChar^,
               (Length(W) + 1) * SizeOf(WideChar));
        end;
      // A little trickier: casting to string will ensure
      // reference counting is done properly.
      vtAnsiString:
        begin
          // Nil out first, so no attempt to decrement reference count.
          Result.VAnsiString := nil;
          string(Result.VAnsiString) := string(Item.VAnsiString);
        end;
      vtCurrency:
        begin
          New(Result.VCurrency);
          Result.VCurrency^ := Item.VCurrency^;
        end;
      vtVariant:
        begin
          New(Result.VVariant);
          Result.VVariant^ := Item.VVariant^;
        end;
      vtInterface:                                // Casting ensures proper reference counting.
        begin
          Result.VInterface := nil;
          IInterface(Result.VInterface) := IInterface(Item.VInterface);
        end;
      vtWideString:                              // Casting ensures a proper copy is created.
        begin
          Result.VWideString := nil;
          WideString(Result.VWideString) := WideString(Item.VWideString);
        end;
      vtInt64:
        begin
          New(Result.VInt64);
          Result.VInt64^ := Item.VInt64^;
        end;
      // "VPointer and VObject don't have proper copy semantics so it
      // is impossible to write generic code that copies the contents." (Rudy V.)
      // (So, let's try to take as much as possible from them now.)
      vtPointer:
        begin
          New(Result.VString);
          result.VType := vtString;
          If Item.VPointer = Nil
             Then result.VString^ := '$_H_' + vTypeAsSring[vtPointer] + ' ^(NIL)'
             Else result.VString^ := '$_H_' + vTypeAsSring[vtPointer]
                          + ' ^(' +  Format('%P', [(addr(item.VPointer)) ]) +')';
        end;
      vtObject:
        begin
          New(Result.VString);
          result.VType := vtString;
          If not(assigned(Item.VObject))                  // dealing with nil pointers
             Then result.VString^ := '$_H_' + vTypeAsSring[vtObject] + ' ^(NIL)'
             Else Begin
                    TRY                                  // dealing with dangling pointers you left ...
                      s := '$_H_' + vTypeAsSring[vtObject] + ' ' + Item.VObject.classname;
                      If Item.VObject is TComponent Then
                         s := s + ' ('  + TComponent(Item.VObject).Name + ')';;
                      If Item.VObject is TEdit   Then
                         s := s + ' ("'  + TEdit(Item.VObject).Text + '")';
                      If Item.VObject is TButton Then
                         s := s + ' ("'  + TButton(Item.VObject).Caption + '")';
                      If (Item.VObject is TList) Then
                            s := s + ' (capacity=' + IntToStr(TList(Item.VObject).Capacity)
                                   + ', count='    + IntToStr(TList(Item.VObject).Count) + ')'  ;
                      If (Item.VObject is TStringList) Then
                            s := s + ' (capacity=' + IntToStr(TStringList(Item.VObject).Capacity)
                                   + ', count='    + IntToStr(TStringList(Item.VObject).Count) + ')'  ;
                    EXCEPT
                      s := '$_H_' + vTypeAsSring[vtObject] + ' !_DANGLING_POINTER_!';
                    END;
                    Result.VString^ := s;
                    s := '';
                  End;
        end;
    end;{case}
end;




    {----------------------------------------------------------}
    {---                  Threads : Parser                     }
    {----------------------------------------------------------}
    {----------------------------------------------------------}

constructor THotLogParser.Create(createSuspended:Boolean);
Begin
  inherited create(createSuspended);
  Self.FpvLineCount:= 0;
  Self.FshowLineNum:= False;
  Self.FpvLnNumLen := 3;
  Self.FpvMaxValue := 999;
  Self.FpvLnAlign  := taRightJustify;
  mxHLLineNum  := CreateMutex(nil, false, pchar('THLLineNumsMutex'
                + DateTimeToStr(Now) + IntToStr(GetTickCount) ));
  HMonitor := THeapMonitor.Create(mkHeap);
  RMonitor := THeapMonitor.Create(mkRam);
  Self.fRulerLength:= 80;
  Self.fRulerDots  := '';
  Self.fRulerNums  := '';
  Self.fRulerBuild := False;
  Self.FsRegSpeed  := '';
  Self.FStarted    := True;
End;


destructor THotLogParser.Destroy;
Begin
  HMonitor.Free;
  RMonitor.Free;
  If mxHLLineNum  > 0   Then CloseHandle(mxHLLineNum);
  inherited destroy;
End;


////////////////////////////////////////////////////////////////////////////////
// internals
////////////////////////////////////////////////////////////////////////////////
Procedure THotLogParser.UpdateLineNum;
begin
  If WaitForSingleObject(mxHLLineNum,50) = WAIT_OBJECT_0 Then
  Begin
    TRY
      FshowLineNum := FLnShowNum;
      FpvLnNumLen  := FLnNumLen;
      FpvMaxValue  := Trunc(Power(10, FLnNumLen)) -1;
      FpvLnAlign   := FLnAlign;
      ReleaseMutex(mxHLLineNum);
    EXCEPT; END;
  End;
end;


procedure THotLogParser.SetFErrCaption(Value : String);
Var i : Integer;
Begin
  Self.FErrorCaption := Value;
  If Self.FErrIsSurrounded And (Self.FErrSurroundChar <> '')
  Then For i := 0 To Length(value) -1 Do
       Self.FErrSurroundLine := Self.FErrSurroundLine + Self.FErrSurroundChar;
  Self.FErrWideSurround := Self.FErrSurroundLine;
  Repeat
    FErrWideSurround := FErrWideSurround + FErrSurroundLine;
  Until Length(FErrWideSurround) >= 80;
End;


procedure THotLogParser.SetFErrSurroundChar(Value : String);
Begin
  Self.FErrSurroundChar := Value;
  If Value = '' Then Self.FErrIsSurrounded := False
  Else Begin
         Self.FErrIsSurrounded := True;
         If Self.FErrorCaption <> ''
            Then SetFErrCaption(Self.FErrorCaption);           // (Re)build surround line's length
       End;
End;


Function THotLogParser.GetLineNum:String;
var i,
    iPad : Integer;
begin
  TRY
    result := IntToStr(FpvLineCount);
    If FpvLineCount <= FpvMaxValue Then
    Begin
      iPad := FpvLnNumLen - Length(result);
      Case self.FLnAlign of
        taRightJustify : For i := 1 To iPad Do Result := ' ' + Result;
        taLeftJustify  : For i := 1 To iPad Do Result := Result + ' ';
          //taCenter : ...
      End; {case}
    End;   {if}
  result := Result + ' ';                     // final space
  EXCEPT; END;
end;


////////////////////////////////////////////////////////////////////////////////
// TVarRec, again   (parser's side)
////////////////////////////////////////////////////////////////////////////////
Function THotLogParser.VarRecToStr(vr:TVarRec):String;
// See D6PE help topic "TVarRec"
Begin
  Result := vTypeAsSring[vr.VType] + ' ';
  TRY
    With vr Do
    Case VType of
       vtInteger:    result := result + IntToStr(VInteger);
       vtBoolean:    result := result + Bool2Str[VBoolean];
       vtChar:       Result := Result + VChar;
       vtExtended:   Result := Result + FloatToStr(VExtended^);
       vtString:     result := result + VString^;
// maintened in case of futur need, but will actually not arrive.
       vtPointer:    result := result + '^(' +  Format('%P', [(addr(VPointer)) ]) +')';
       vtPChar:      result := Result + VPChar;
// ...
       vtObject:     Begin
                       If VObject = Nil Then result := result + '^(NIL)'
                       Else result := result + VObject.classname;
                     End;
// ...
       vtClass:      result := result + VClass.classname;
       vtWideChar:   Result := Result + string(VWideChar);
       vtPWideChar:  Result := Result + VPWideChar;
       vtAnsiString: Result := Result + string(VAnsiString);
       vtCurrency:   result := result + CurrToStr(VCurrency^);
       vtVariant:    Result := Result + string(VVariant^);
       vtInterface:  Result := Result + '(Interfaced object)';
       vtWideString: Result := Result + string(VWideString^);
       vtInt64:      Result := Result + IntToStr(VInt64^);
       else          result := result + Format('[#HLvrType(%d)]',       // "Else" not possible...
                               [ integer(vr.VType) ]);                  // ...with D6, but laters ?
    End;{case}
  EXCEPT
      result := result + Format('[#HLvrValue(%s)]', [vTypeDesc[vr.VType]]);
  END;
end;


procedure THotLogParser.FinalizeVarRecArray(var Arr: TConstArray);     // (c)Rudy Velthuis
// "A TConstArray contains TVarRecs that must be finalized. This function
// does that for all items in the array." (Rudy V.)
var I: Integer;
begin
  for I := Low(Arr) to High(Arr) do
      FinalizeVarRec(Arr[I]);
  Arr := nil;
end;


procedure THotLogParser.FinalizeVarRec(var Item: TVarRec);             // (c)Rudy Velthuis
// "TVarRecs created by CopyVarRec must be finalized with this function.
// You should not use it on other TVarRecs." (Rudy V.)
begin
  case Item.VType of
    vtExtended: Dispose(Item.VExtended);
    vtString: Dispose(Item.VString);
    vtPChar: StrDispose(Item.VPChar);
    vtPWideChar: FreeMem(Item.VPWideChar);
    vtAnsiString: string(Item.VAnsiString) := '';
    vtCurrency: Dispose(Item.VCurrency);
    vtVariant: Dispose(Item.VVariant);
    vtInterface: IInterface(Item.VInterface) := nil;
    vtWideString: WideString(Item.VWideString) := '';
    vtInt64: Dispose(Item.VInt64);
  end;
  Item.VInteger := 0;
end;


function THotLogParser.ConstArrayToTSList(const Elements: array of const): TStringList;
// -1-> Returns à TStringList, with items like 'vType : vValue[,details]'
//      Once done, items will be checked, to restitute their real type
//      (to handle the particular cases of Pointers and Objects, that we translated
//      to strings earlier).
var i:Integer;
Begin
  Result := TStringList.create;
  TRY
    For i:= Low(Elements) to High(Elements) do
        result.Add( VarRecToStr(Elements[I]));
    For i := 0 To result.Count -1 Do
        If Pos('$_H_',result.Strings[i]) > 0
        Then result.Strings[i] := GetOriginalValue(result.Strings[i]);
  EXCEPT
    result.Clear;
    result.Add('[#HLvrConvert]');
  END;
End;


function THotLogParser.ConstArrayToString(const Elements: array of const;
                                          style:TVarRecStyle=vsBasic): String;
// -2-> Returns à string, surrounded by parenthesis : '(elts[0]; ...; elts[n-1]);'
//      ("Basic infos" only.)
Var i: Integer;
    s,sep: String;
Begin
  TRY
    If style = vsBasic Then
    Begin
      Result := '(';
      sep := '; ';
    End Else sep := '';
    For i:= Low(Elements) to High(Elements) do
    Begin
      s := VarRecToStr(Elements[I]);
      Result := Result + GetBasicValue(s,Elements[i].VType) + sep;
    End;
    If style = vsBasic Then
       Result := LeftStr(Result, length(result)-2) + ');' ;      // replaces last ", " by final ");".

  EXCEPT result := '[#HLvrConvert]';
  END;
End;


Function THotLogParser.GetBasicValue(s:String; vKind:Byte):String;
var iTmp : Integer;
    wasTObject: Boolean;
Begin
  Result := s;
  If s = '' Then exit;
  TRY
    iTmp := Pos('$_H_',s);
    wasTObject := (Pos('$_H_TObject',s) > 0);
    If (iTmp > 0 ) Then Result := GetOriginalValue(s);           // converts fake strings back to original
    Result := RightStr(Result, length(result)-15);               // From now on, works on "result"
    If (vKind In [vtString,vtAnsiString,vtWideString,vtPChar,vtWideChar,vtPWideChar])
    And Not(wasTObject) Then Exit
    Else Begin
           iTmp   := Pos(' ',Result);
           If ( iTmp > 0 ) And (iTmp < Length(result))
              Then result := LeftStr(result, iTmp);
         End;
  EXCEPT; END;
End;


Function THotLogParser.GetOriginalValue(s:String):String;
//  Called to remove the false 'AnsiString :' assertion, for pointers and objects
Begin
  result := RightStr(s,Length(s)-19);
End;


////////////////////////////////////////////////////////////////////////////////
//  work
////////////////////////////////////////////////////////////////////////////////

procedure THotLogParser.Execute;
var tmpMsg: tagMSG;                                 // messages packed record
    SlTmp: TStringList;
    sTmp: String;
    i: Integer;
begin
  TRY {Except}
    While Not( Terminated ) do
    Begin
      If PeekMessage(tmpMsg, 0, 0, 0, PM_REMOVE) then
      Case tmpMsg.message of

         WM_Quit         : Terminate;

         UM_HLSERVICEMSG : Begin
                             Case(tmpMsg.wParam) of
                               HL_LINENUMCHANGED : UpdateLineNum;
                               HL_RESETRULER     : ResetRuler(tmpMsg.lParam);
                               HL_RESETHEAPTABLE : HMonitor.ResetMemTable;
                               HL_RESETRAMTABLE  : RMonitor.ResetMemTable;
                               HL_HEAPMONITOR :
                                  Begin
                                    HMonitor.AddRec(tmpMsg.lParam);
                                    THLHeapMonMsg(tmpMsg.lParam).free;
                                  End;
                               HL_RAMMONITOR :
                                  Begin
                                    RMonitor.AddRec(tmpMsg.lParam);
                                    THLHeapMonMsg(tmpMsg.lParam).free;
                                  End;
                             end; {case wParam}
                           End; {Case UM_HLSERVICEMSG}

         UM_HLACTIONMSG  : Begin
                             Case(tmpMsg.wParam) of
                               HL_SIMPLESTRING:
                                  Begin
                                    sTmp := AddLineNum(THLStringMsg(tmpMsg.lParam).fHlMsg);
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSIMPLESTRING, Integer(THLStringMsg.Create(sTmp)), 0);
                                    THLStringMsg(tmpMsg.lParam).Free;
                                  End;{simpleString}
                               HL_PARSELINE :
                                  Begin
                                    slTmp := ParseLine(THLStringMsg(tmpMsg.lParam).fHlMsg);
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSTRINGLIST, Integer(slTmp), 0);
                                    THLStringMsg(tmpMsg.lParam).Free;
                                  End;{parseLine}
                               HL_PARSELIST :
                                  Begin
                                    slTmp := ParseList(tmpMsg.lParam);
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSTRINGLIST, Integer(slTmp), 0);
                                    TStringList(tmpMsg.lParam).Free;
                                  End;{ParseList}
                               HL_PARSEARRAY :
                                  Begin
                                    slTmp := ParseArray(tmpMsg.lParam);
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSTRINGLIST, Integer(slTmp), 0);
                                    THLConstArrayMsg(tmpMsg.lParam).Free;
                                  End;{ParseArray}
                               HL_PARSEEXCEPTION:
                                  Begin
                                    slTmp := ParseException(tmpMsg.lParam);
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSTRINGLIST, Integer(slTmp), 0);
                                    THLErrMsg(tmpMsg.lParam).Free;
                                  End;{parseException}
                               HL_JUMPLINES:
                                  Begin
                                    slTmp := TStringList.Create;
                                    For i := 0 To tmpMsg.lParam -1 Do
                                        slTmp.Add(AddLineNum(''));
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSTRINGLIST, Integer(SlTmp), 0);    // nothing to free, here
                                  End;{jumpLines}
                               HL_HEAPMONITOR:                                  // direct output requested
                                  Begin
                                    slTmp := GetHeap(tmpMsg.lParam,0);          // 0->Full result
                                    AddLineNum(slTmp);
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSTRINGLISt, Integer(slTmp), 0);    // slTmp sera libérée plus tard
                                    THLHeapMonMsg(tmpMsg.lParam).free;
                                  End;{heapMonitor}
                               HL_RAMMONITOR :
                                  Begin
                                    slTmp := GetRam(tmpMsg.lParam,0);
                                    AddLineNum(slTmp);
                                    PostThreadMessage(Self.FWriterTID,
                                        UM_HLSTRINGLISt, Integer(slTmp), 0);
                                    THLHeapMonMsg(tmpMsg.lParam).free;
                                  End; {ramMonitor}
                             End; {Case wParam}
                           End; {Case UM_HLACTIONMSG}
         // No Else to come...
      End; {casetmpMsg.message}
      Sleep(50);
    End;
    If terminated Then Exit;
  EXCEPT; END;
end;


Procedure THotLogParser.ResetRuler(value : integer);
Begin
  Self.fRulerLength:= value;
  Self.fRulerDots  := '';
  self.fRulerNums  := '';
  self.fRulerBuild := False;
End;


Function THotLogParser.AddLineNum(line:String):String;
Begin
  result := line;
  Inc(Self.FpvLineCount);                                        // Line counter is incremented anycase...
  If Self.FshowLineNum Then result := Self.GetLineNum + line;    // ... and then added, if needed;
End;


procedure THotLogParser.AddLineNum(Var lst:TStringList);
var i:Integer;
Begin
  For i := 0 To lst.Count -1 Do
  Begin
    Inc(Self.FpvLineCount);
    If Self.FshowLineNum Then
       lst.Strings[i] := Self.GetLineNum + lst.Strings[i];
  End;
End;


Function THotLogParser.ParseException(exRec:integer):TstringList;
Var sTmp,
    spaces: String;
    slTmp:  TStringList;
    i,iPos: Integer;
Begin
  result := TStringList.Create;
  If Self.FErrJumpLines Then Result.Add('');
  Case Self.FErrViewStyle of
    vsBasic :
      Begin
        If Self.FErrIsSurrounded Then result.Add(Self.FErrSurroundLine);
        sTmp := Self.ErrorCaption + ' ';
        If THLErrMsg(exRec).FlastErr <> 0
           Then sTmp := sTmp +  '(' + IntToStr(THLErrMsg(exRec).FlastErr) +') ';
        If THLErrMsg(exRec).FEMsg <> ''
           Then sTmp := sTmp + '"' + THLErrMsg(exRec).FEMsg + '" ';
        If THLErrMsg(exRec).FFunc <> ''
           Then sTmp := sTmp + ' in ' + THLErrMsg(exRec).FFunc;
        If THLErrMsg(exRec).Ffull Then
        Begin
          sTmp := sTmp + ConstArrayToString(THLErrMsg(exRec).Fargs);
          FinalizeVarRecArray( THLErrMsg(exRec).Fargs );
        End;
        result.Add(sTmp);
        If Self.FErrIsSurrounded Then result.Add(Self.FErrSurroundLine);
      End;
    vsExtended :
      Begin
        If Self.FErrIsSurrounded Then result.Add(Self.FErrWideSurround);
        sTmp := Self.ErrorCaption + ' ';
        If THLErrMsg(exRec).FlastErr <> 0
           Then sTmp := sTmp +  '(' + IntToStr(THLErrMsg(exRec).FlastErr) +') ';
        If THLErrMsg(exRec).FEMsg <> ''
           Then sTmp := sTmp + '"' + THLErrMsg(exRec).FEMsg + '"';

        If THLErrMsg(exRec).Ffull Then
        Begin
          sTmp  := sTmp + ' in :';
          result.Add(sTmp);                                      // New line
          iPos  := Pos('"',sTmp)- length(Self.FErrSurroundLine); // 1 : trouver le 1er 'buttoir'
          spaces:= '';
          For i := 0 To iPos -1 Do spaces := spaces + ' ';
          sTmp  := FErrSurroundLine;
          sTmp  := sTmp + spaces + THLErrMsg(exRec).FFunc;
          spaces:= '';
        //now waiting for the first "arg"
          slTmp := ConstArrayToTSList(THLErrMsg(exRec).Fargs);   // 2 : alimenter tslist tmp
          If slTmp.Count <= 0 Then sTmp  := sTmp + '()'
          Else
          Begin
            sTmp  := sTmp + '( ';
            iPos  := Length(sTmp);                               // 3 : trouver le 'buttoir'
            sTmp  := sTmp + slTmp.Strings[0];
            result.Add(sTmp);
            slTmp.Delete(0);
            For i := 0 To iPos -1 Do spaces := spaces + ' ';
            For i := 0 To slTmp.Count -1 Do                      // 4 : insérer les espaces j-> buttoir
                slTmp.Strings[i] := spaces + slTmp.Strings[i];
            i := slTmp.Count -1;
            slTmp.Strings[i] := slTmp.Strings[i] + ' );';
            result.AddStrings(slTmp);                             // Construire le résultat
            slTmp.Free;                                           // slTmp was created in ConstArrayToStr.
            FinalizeVarRecArray( THLErrMsg(exRec).Fargs );
          End;
        End Else
        Begin
          If THLErrMsg(exRec).FFunc <> ''
             Then sTmp := sTmp + ' in ' + THLErrMsg(exRec).FFunc;
          If THLErrMsg(exRec).Ffull
             Then sTmp := sTmp + ConstArrayToString(THLErrMsg(exRec).Fargs);
          result.Add(sTmp);
          FinalizeVarRecArray( THLErrMsg(exRec).Fargs );
        End;
        If Self.FErrIsSurrounded Then result.Add(Self.FErrWideSurround);
      End;
    End;{case}
  If Self.FErrJumpLines Then Result.Add('');
  AddLineNum(result);
End;


Function THotLogParser.ParseArray(source:Integer):TStringList;
Begin
  TRY
    Case THLConstArrayMsg(source).FOutputStyle Of
      vsNone, vsBasic    :
        Begin
          result := ParseLine(ConstArrayToString(THLConstArrayMsg(source).FConstArray,
                                                 THLConstArrayMsg(source).FOutputStyle));
        End;
      Else
        Begin
          result := ParseList(Integer(ConstArrayToTSList(THLConstArrayMsg(source).FConstArray)));
        End;
    End;{case}
  FINALLY;
    FinalizeVarRecArray( THLConstArrayMsg(source).FConstArray );
  END;
end;


Function THotLogParser.ParseLine(source:String):TStringList;
// Main function for parsing strings (appart from errors) ;
Var pil : TList;                                    // Parse(d) Item List
    i : Integer;
    tmpOmitLNum : Boolean;                          // line numbers eventual override;
Begin                                               // Check de '' fait dans LineToList
  result := TStringList.Create;                     // pil := TList.Create; fait dans LineToList
  tmpOmitLNum := False;
  TRY
    TRY
      pil  := LineToList(Source);                   // LineToList will create the List (and fill it)
      PrepareParsing(pil);                          // retourne un type (inLine ou standAlone) et la liste "packée";
      TranslateTags(pil,tmpOmitLNum);
      For i:= 0 To pil.count -1 Do
          result.Add(PParseItem(pil[i]).sValue);    // original or converted...
    EXCEPT
      result.Add('#HLParserSTR('+ source + ')');
      exit;
    END;
  FINALLY
      If tmpOmitLNum Then
      Begin
        FShowLNTemp  := FShowLineNum;
        FShowLineNum := False;
        AddlineNum(result);
        FShowLineNum := FShowLNTemp;
      End Else AddlineNum(result);
    TRY
      FreeParsedList(pil);
      pil.Free;
    EXCEPT;END;
  END;
End;


Function THotLogParser.ParseList(source:Integer):TStringList;
// stringsLists parsing;
Var pil : TList;                                    // Parse(d) Item List
    i,j : Integer;
    tmpOmitLNum : Boolean;                          // line numbers eventual override;
Begin                                               // Check de '' fait dans LineToList
  result := TStringList.Create;                     // pil := TList.Create; -> fait dans LineToList
  tmpOmitLNum := False;
  TRY
    TRY
      For j := 0 To TStringList(source).count -1 Do
      Begin
        pil  := LineToList(TStringList(source).Strings[j]);
        PrepareParsing(pil);
        TranslateTags(pil,tmpOmitLNum);
        For i:= 0 To pil.count -1 Do
            result.Add(PParseItem(pil[i]).sValue);
        TRY
          FreeParsedList(pil);
          pil.Free;
        EXCEPT;END;
      End;
    EXCEPT
      result.Add('#HLParserTSL.Strings)');
    END;

  FINALLY
      If tmpOmitLNum Then
      Begin
        FShowLNTemp  := FShowLineNum;
        FShowLineNum := False;
        AddlineNum(result);
        FShowLineNum := FShowLNTemp;
      End Else AddlineNum(result);
  END;
End;


Function THotLogParser.LineToList(line:String):TList;
// instancie une TLsit, et la renvoi alimentée sous la forme
// d'une entrée PParseItem par string/tag lu ;
var aPitem:PParseItem;
    sRemain: String;
    done:  Boolean;
Begin
  result  := TList.Create;
  sRemain := line;
  TRY
    If sRemain = '' Then                           // empty line
    begin
      new(aPitem);
      aPitem^.kind  := ikStr;
      aPitem^.sValue := #13#10;
      aPitem^.isSingle:= False;
      Result.Add(aPitem);
    End Else                                       // Loops searching for tags
    Begin                                          // (and removing their brackets)
    //1 remove $d$a
      If sRemain[length(sRemain)] in [#13,#10] Then
         sRemain := Copy(sRemain,1 , length(sRemain)-1);
      If sRemain[length(sRemain)] in [#13,#10] Then
         sRemain := Copy(sRemain,1 , length(sRemain)-1);
      done    := False;
      While Not Done Do
      Begin
        New(aPitem);
        Done := ExtractItem(sRemain, aPitem);
        Result.Add(aPitem);
      End;
    End;
  EXCEPT
     On E:Exception Do
     Begin
       new(aPitem);
       aPitem^.kind  := ikStr;
       aPitem^.sValue := '#HLParsing('+ E.Message +')with:('+ sRemain +')';
       aPitem^.isSingle:= False;
       Result.Add(aPitem);
     End;
    //exit;
  END;
end;


Function THotLogParser.ExtractItem(Var source:String; Var itm:PParseItem):Boolean;
// "itm" will be either a tag (without brackets) or a string.
//  Returns true (+last item) once there's nothing more to extract;
var op,
    cl : Integer;
    extr: String;
Begin
  TRY {Finally}
  TRY {Except}
  // ExtractItem is called only if length(source) > 0 ;
  // We'll first check whether there is a tag in source or not;
  op := Pos('{', source);
  cl := Pos('}', source);
  If (op <= 0) Or (cl <= 0) Or (cl < op) Then         // No valid Tag. Checked at each call, because ...
  Begin                                               // ... a line could embedd valid AND invalid tags
    itm^.kind    := ikStr;
    itm^.sValue  := source;
    itm^.isSingle:= False;
    source := '';                                     // Nothing more to do
    Result := True;                                   // Avoiding Compiler warning,...
    exit;                                             // ...emitted despite the Finally Block
  End;

  //op may be =1 or more ;
  If op > 1 Then                                      // we got a string, easiest case;
  Begin
    itm^.kind    := ikStr;
    itm^.sValue  := Copy (source, 1, op -1);
    itm^.isSingle:= False;
    source := Copy (source, op, HL_MAX_INT);          // removes the string
    Result := ( source = '' );                        // ...Compiler warning...
    exit;
  End;

  // "op" neither 0 nor > 1 => op=1  ;-)   The leading bloc is a tag.
  // We'll first surch for '{{}' '{}}'(2nd form being uncovered by "cl=pos('}') which returns "2",
  // whereas we'd need "3"), then empty tag '{}'; We will also have to check for 2 charcters strings;

  // len=1 and not a tag : implicitely handeled by first section
  // len=2 : cl can then only be = 2, and these two chars can only be an empty tag ...
  If length(source) = 2 Then                          // ...as long as we arrive there ...
  Begin                                               // ...(first section would have detect (op>0 & no close))
    itm^.kind    := ikStr;
    itm^.sValue  := '';                               // gets the tag, as string; (can't use source
    itm^.isSingle:= False;
    source       := '';                               // now removes the tag
    Result := True;                                   // ...Compiler warning...
    exit;
  End;

  //len>=3
  If source[3] = '}' Then                             // closing mark, we got sthg
  Begin                                               // like {{}, {}},{&} or {x}
    If (source[2] = '&') or (source[2] = '/')
       Then itm^.kind    := ikTag                     // gets the value as tag
       Else itm^.kind    := ikStr;                    // gets the value as string;
    itm^.sValue  := source[2];
    itm^.isSingle:= False;
    source := Copy (source, 4, HL_MAX_INT);           // now removes the tag
  End Else If source[2] = '}' Then                    // Empty tags are place holders
  Begin
    source       := Copy (source, cl+1, HL_MAX_INT);
    itm^.kind    := ikStr;
    itm^.sValue  := '';                               // gets the tag, as string;
    itm^.isSingle:= False;
  End Else                                            // Tag found
  Begin
    extr         := Copy (source, 2, cl-2);           // open allways = 1, we don't keep opening or closing brackets
    itm^.kind    := ikTag;
    itm^.sValue  := extr;                             // gets the tag, as string;
    itm^.isSingle:= False;
    source       := Copy (source, cl+1, HL_MAX_INT);  // now removes it
  End;
  EXCEPT
    itm^.kind    := ikStr;
    itm^.sValue  := '#HLTag('+source+')';
    itm^.isSingle:= False;
    source := '';
  END;
  FINALLY
    Result := ( source = '' );
  END;
end;


Procedure THotLogParser.PrepareParsing(var lst:Tlist);
// Converts tags (actually strings) to "unique identifiers" of
// kind Integer, to make them checkable later in a case statement;

// If a standAlone tag is met at first position, removes anything
// that would follow it, otherwise, eliminates eventualy embedded
// standAlone Tags not alone in this line;

    Function IsStandAloneTag(c:Cardinal):Boolean;
    Begin
      Result := (c = HLT_RULER)
             or (c = HLT_RULER1)
             or (c = HLT_TIMERS)
             or (c = HLT_RAM)
             or (c = HLT_HEAP)
             or (c = HLT_DISK)
             or (c = HLT_CPUI)
             or (c = HLT_MEM)
             or (c = HLT_OSVI);
    End;

    {--------------     Local     --------------}
     Function HLCheckSum(s:String):Cardinal;
     // kinda personnal checksum, to convert tags to single numerical
     // identifiers, in order to check them later in a case statement.
     var c1,c2,
         c3,c4: Integer;
         mdl,lng,der: Integer;
     Begin
       result := 0; If s = '' Then exit;
       s   := UpperCase(s);
       mdl := Length(s) mod 4;
       lng := Length(s)-mdl;
       der := lng+mdl;
       c1 := 0; c2 := 0;
       c3 := 0; c4 := 0;

       If lng > 0 Then
       Repeat
         c1  := c1 + Byte(s[lng-3]);
         c2  := c2 + Byte(s[lng-2]) SHL 8;
         c3  := c3 + Byte(s[lng-1]);
         c4  := c4 + Byte(s[lng])  SHL 8;
         lng := lng-4;
       Until lng = 0;

       Case mdl of
       //0 : nothing left;
         1 : Begin c1 := c1 + Byte(s[der]);  End;
         2 : Begin c1 := c1 + Byte(s[der-1]);
                   c2 := c2 + Byte(s[der]) SHL 8;
             End;
         3 : Begin c1 := c1 + Byte(s[der-2]);
                   c2 := c2 + Byte(s[der-1]) SHL 8;
                   c3 := c3 + Byte(s[der]);
             End;
       End; //case
       result := (c1+c2) + (c3+c4);
     End;
    {------------      \Local\      ------------}


var i : Integer;
    aPitem:PParseItem;
Begin
  TRY
  For i := 0 To lst.count -1 Do
  Begin
    aPitem := PParseItem(lst[i]);
    With aPitem^ Do
    If kind = ikTag Then
    Begin
      // 1-special cases : "@" and "*"
      If Length(sValue)> 0 Then
      Begin
        If (sValue[1] = '@') Or (sValue[1] = '*') Or (sValue[1] = '/')
             Then iValue := HLCheckSum(sValue[1])
        Else if (sValue[length(sValue)] = '@')
             Then iValue := HLT_AT                            //HLCheckSum('@')
      // 2-other tags
             Else iValue := HLCheckSum(UpperCase(sValue));
      End;
      isSingle := IsStandAloneTag(iValue);
    End; {with...if}
  End; {for}
  lst.Pack;                                                 // applies deletions;
  // -2- Eliminates what shoudn't be there (no standalone + inline tags mix...);
  If lst.Count > 1 Then
  Begin
    If (PParseItem(lst.Items[0]).kind = ikTag) And (PParseItem(lst.items[0]).isSingle) Then
    For i := 1 {0 soon checked} To lst.Count -1 Do        // Empties the list, keeping only the first item.
    Begin
      aPitem := PParseItem(lst.Items[i]);
      Dispose(aPitem);
      lst[i] := Nil;
    End Else
    For i := 1 {0 soon checked} To lst.Count -1 Do
    If  (PParseItem(lst.Items[i]).kind = ikTag) And (PParseItem(lst.Items[i]).isSingle) Then
    Begin                                                 // StandAlone tags no longer accepted
      aPitem := PParseItem(lst.Items[i]);
      Dispose(aPitem);
      lst[i] := Nil;
    End;
  lst.Pack;                                               // applies deletions;
  End;{With PParseItem(lst)}
  EXCEPT; END;
End;



Procedure THotLogParser.TranslateTags(var lst:Tlist; var omitLNum:Boolean);
// Recieves either a standalone tag, or inline ones
// Returns lst with updated, added or removed entries
// converted to their definitive values.

// Tags '*' and '@' receive a special treatement : Their original values
// (minus the brackets) are kept in sValue, and they work on the sValue
// of the preceding item('*') or of the following item. Then, '@' (which
// work on absolute position) are converted lastly, whereas all others are
// converted when met.

var byteCount, i : Integer;
    concatenating: Boolean;
    s, catVal : String;
    aPitem: PParseItem;
Begin
  TRY
  // Standalone tags => overriding item[0], and adding as many items as needed
    If PParseItem(lst.items[0]).isSingle Then
    Begin
      Case PParseItem(lst.items[0]).iValue of
       HLT_MEM    : GetMemoryStatus(lst);
       HLT_RAM    : GetRamOrHeapAsPitem(HL_RAMMONITOR, -1,0,0,lst);  // ram, full info
       HLT_HEAP   : GetRamOrHeapAsPitem(HL_HEAPMONITOR,-1,0,0,lst);  // heap, full info
       HLT_DISK   : GetRamOrHeapAsPitem(HL_DSKMONITOR, -1,0,0,lst);  // disk, full info
       HLT_CPUI   : GetCPUInfoAsPitem(lst);
       HLT_OSVI   : GetOSVIAsPitem(lst);
       HLT_TIMERS : GetTimerResolutionsAsPitem(lst);
       HLT_RULER  : GetRuler(lst,False);                             // ruler
       HLT_RULER1 : GetRuler(lst,True);                              // ruler+
      End;{case}
    End Else
  // InLine tags
    Begin
      byteCount := 0;                                                // current length of future line
      For i := 0 To lst.Count -1 Do
      Begin
        If PParseItem(lst[i]).kind = ikTag Then
           Case PParseItem(lst[i]).iValue of

             HLT_PAD :
                  Begin  {*}
                    If (i = 0) or (lst[i-1] = nil)
                    Then PParseItem(lst[i]).sValue :=
                              PadString('', PParseItem(lst[i]).sValue, byteCount) //byteCount as var
                    Else Begin
                           PParseItem(lst[i-1]).sValue := PadString(PParseItem(lst[i-1]).sValue,
                                                          PParseItem(lst[i]).sValue, byteCount);
                           aPitem := PParseItem(lst[i]);       // item no longer needed => free it.
                           Dispose(aPitem);
                           lst[i] := Nil;
                         End;
                  End;{case '*'}

            HLT_AT : ;{@}                // will be translated later. PlaceHolder,
                                          // to avoid false "unknownTag" assertions
            HLT_DHG :
                  Begin
                    PParseItem(lst[i]).sValue := FormatDateTime('yyyy-mm-dd hh:mm:ss ',Now)
                                               + intToStr(GetTickCount);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_DTE :
                  Begin
                    PParseItem(lst[i]).sValue := FormatDateTime('yyyy-mm-dd',Now);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_GTC : Begin
                    PParseItem(lst[i]).sValue := intToStr(GetTickCount);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_HMS :
                  Begin
                    PParseItem(lst[i]).sValue := FormatDateTime('hh:mm:ss',Now);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_NOW :
                  Begin
                    PParseItem(lst[i]).sValue := FormatDateTime('yyyy-mm-dd hh:mm:ss ',Now);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_LNUM :
                  Begin
                    PParseItem(lst[i]).sValue := IntToStr(self.FpvLineCount+1);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_CRLF :
                  Begin
                    PParseItem(lst[i]).sValue := '';
                    byteCount := 0;
                  End;
            HLT_RAM1 :
                  Begin
                    GetRamOrHeapAsPitem(HL_RAMMONITOR, -1,1,i,lst);  // Ram-
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_RAM2 :
                  Begin
                    GetRamOrHeapAsPitem(HL_RAMMONITOR, -1,2,i,lst);  // Ram--
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_RAM3 :
                  Begin
                    GetRamOrHeapAsPitem(HL_RAMMONITOR, -1,3,i,lst);  // Ram---
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_HEAP1 :
                  Begin
                    GetRamOrHeapAsPitem(HL_HEAPMONITOR,-1,1,i,lst);  // Heap-
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_HEAP2 :
                  Begin
                    GetRamOrHeapAsPitem(HL_HEAPMONITOR,-1,2,i,lst);  // heap--
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_HEAP3 :
                  Begin
                    GetRamOrHeapAsPitem(HL_HEAPMONITOR,-1,3,i,lst);  // heap---
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_DISK1 :
                  Begin
                    GetRamOrHeapAsPitem(HL_DSKMONITOR,-1,1,i,lst);  // Disk-
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_DISK2 :
                  Begin
                    GetRamOrHeapAsPitem(HL_DSKMONITOR,-1,2,i,lst);  // Disk--
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_DISK3 :
                  Begin
                    GetRamOrHeapAsPitem(HL_DSKMONITOR,-1,3,i,lst);  // Disk---
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_LNUMOFF :
                  Begin
                    omitLNum := True;
                    aPitem := PParseItem(lst[i]);
                    Dispose(aPitem);
                    lst[i] := Nil;
                  End;
            HLT_APP_LFN :
                  Begin
                    PParseItem(lst[i]).sValue := Paramstr(0);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_APP_VER :
                  Begin
                    PParseItem(lst[i]).sValue := GetVersionAsText;
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_APP_PRM :      // app_prm, one line by parameter, line counting is loosed
                 Begin
                    PParseItem(lst[i]).sValue := GetParams(False);
                    byteCount := 0;
                  End;
            APP_PRM_LN :      // app_prm- one line only, whatever be it's length
                  Begin
                    PParseItem(lst[i]).sValue := GetParams(True);
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_APP_NAME :
                  Begin
                    PParseItem(lst[i]).sValue := ExtractFileName(Paramstr(0));
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
            HLT_APP_PATH :
                  Begin
                    PParseItem(lst[i]).sValue := ExtractFilePath(Paramstr(0));
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
           Else   Begin
                    PParseItem(lst[i]).sValue := '#HLTag('
                                               + PParseItem(lst[i]).sValue + ')';
                    byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
                  End;
           End{case}
        Else byteCount := byteCount + Length(PParseItem(lst[i]).sValue);   // takes strings lengths into account
      End;{for}
      lst.Pack;                                                            // because of '*' deletions.

      // 2° loop : takes "&" block markers into account :
      concatenating := False;
      catVal := '';
      For i := 0 To lst.Count -1 Do
      If concatenating Then
      Begin
      // -1- search for a closing "&" or stores the value
        If (PParseItem(lst[i]).kind = ikTag) And (PParseItem(lst[i]).iValue =HLT_AND) Then
        Begin
          concatenating := False;
          PParseItem(lst[i]).kind   := ikStr;          // item will now be used to store the cat string
          PParseItem(lst[i]).sValue := catVal;
          catVal := '';
        End Else
        Begin
          catVal := catVal + PParseItem(lst[i]).sValue;
          aPitem := PParseItem(lst[i]);                // item no longer needed => free.
          Dispose(aPitem);
          lst[i] := Nil;
        End;
      End Else If (PParseItem(lst[i]).kind = ikTag)
               And (PParseItem(lst[i]).iValue = HLT_AND) Then
               Begin                                   // not yet concatenating -> block open marker
                 concatenating := True;
                 aPitem := PParseItem(lst[i]);         // "&" tag no longer needed => free its item.
                 Dispose(aPitem);
                 lst[i] := Nil;
               End;{If cat and ! cat}
      If concatenating Then                            // we're done, but still "concatenating" ...
      Begin                                            // ... -> closing {&} is missing, we will ...
        New(aPitem);                                   // ... 'emulate' it, forcing the closing.
        aPitem^.kind   := ikStr;
        aPitem^.sValue := catVal;
        aPitem^.isSingle:= False;
        catVal := '';
        lst.Add(aPitem);
      End;
      lst.Pack;

      // 3° loop, for '@' tags (64);
      byteCount := 0;
      For i := 0 To lst.Count -2 Do  // -1 -> nothing to do (and... index array out of bounds with lst[i+1])
         If ( PParseItem(lst[i]).kind = ikTag) And (PParseItem(lst[i]).iValue = HLT_AT )
         Then Begin
           PParseItem(lst[i+1]).sValue := PadString(PParseItem(lst[i+1]).sValue,
                                          PParseItem(lst[i]).sValue,byteCount);
           aPitem := PParseItem(lst[i]);                                      // item no longer needed => free.
           Dispose(aPitem);
           lst[i] := Nil;
         End Else If (PParseItem(lst[i]).kind = ikTag)
                  And (PParseItem(lst[i]).iValue = HLT_CRLF)                  // crlf    295
                      Then byteCount := 0
                      Else byteCount := byteCount + Length(PParseItem(lst[i]).sValue);
      // Checks if last entry is an '@'.If yes, removes it.
      // (care for index out of bounds :
      If (lst.Count > 0) Then
         If  (PParseItem(lst[lst.Count -1]).kind = ikTag)
         And (PParseItem(lst[lst.Count -1]).iValue = HLT_AT ) Then
         Begin
           aPitem := PParseItem(lst[lst.Count -1]);
           Dispose(aPitem);
           lst[lst.Count -1] := Nil;
        End;
      lst.Pack;
      s := '';
      For i := 0 To lst.Count-1 Do
      Begin
        If ((PParseItem(lst[i]).kind = ikTag)
        And (PParseItem(lst[i]).iValue = HLT_CRLF)) Then                      // crlf
        Begin
          s := s + PParseItem(lst[i]).sValue;
          PParseItem(lst[i]).sValue := s;
          PParseItem(lst[i]).kind   := ikStr;
          PParseItem(lst[i]).isSingle := False;
          s := '';
        End Else
        Begin
          s := s + PParseItem(lst[i]).sValue;
          aPitem := PParseItem(lst[i]);
          Dispose(aPitem);
          lst[i] := Nil;
        end;
      End;
      new(aPitem);
      aPitem.kind := ikStr;
      aPitem.sValue := s;
      aPitem.isSingle := False;
      lst.Add(aPitem);
    End;{with}
  FINALLY
   lst.Pack;
  END;
End;


Function THotLogParser.PadString(src,tag:String; posPtr:Integer):String;
// posPtr reflects the actual position in bytes in the line being build.
var iTagVal, iBefore, needed : integer;
    bAlLeft, bCenter, bAlRight : Boolean;
    sTagVal:String;
    padChar : Char;
Begin
  result  := src;                                       // in case invalid tag;
  sTagVal := ' ';

  TRY{EXCEPT}
    // "*" : Pad src with char "padChar", up to nnn;
    If (tag[1] = '*') Then
    Begin
      padChar := tag[length(Tag)];
      sTagVal := LeftStr (tag, Length(tag)-1);
      sTagVal := RightStr(sTagVal, Length(sTagVal)-1);
      iTagVal := StrToInt(sTagVal);
      needed  := iTagVal - length(src);
      result  := src + StringOfChar(padChar, needed);
    End

    // "@"  : Alignment
    // "What FOLLOWS the tag wil start at position "nnn", if possible.
    // "If possible" means that if "what follows" actually starts at a position
    // greater than the wanted one, the tag is ignored (but a leading space is
    // added to the new string, in order to distinguish it from the preceding one);
    Else Begin
      bAlLeft  := (tag[1]   = '@');
      bAlRight := (tag[length(tag)] = '@');
      bCenter  :=  bAlLeft And bAlRight;

      If bCenter then
      Begin
        sTagVal := LeftStr (tag, Length(tag)-1);
        sTagVal := RightStr(sTagVal, Length(sTagVal)-1);
        iTagVal := StrToInt(sTagVal);
        needed  := iTagVal - Length(src);
        iBefore := needed SHR 1;                                      // ie Length(src) div 2
        If needed <= 0 Then result := src
        Else result := StringOfChar(' ', iBefore) + src
                     + StringOfChar(' ', iBefore  + (needed Mod 2));  // Adds 1 if odds;
      End Else
      Begin
        If bAlLeft Then                                               // value starts at pos n -> spaces first, the value;
        Begin
          iTagVal := StrToInt(RightStr(tag,Length(tag)-1));
          needed  := iTagVal - posPtr -1;                             // current position
        End Else
        Begin                                                         // value ends at pos n;
          iTagVal := StrToInt(LeftStr(tag,Length(tag)-1));
          needed  := iTagVal - (posPtr + length(src));
        End;
        If needed <= 0
           Then result := ' ' + src
           Else result  := StringOfChar(' ', needed) + src ;
      End;{left or right}
    End; {@}
  EXCEPT  result := '#HLTag(' + tag +') '+ result; END;
End;


Procedure THotLogParser.FreeParsedList(var l:TList);
var i:Integer;
    aPitem:PParseItem;
Begin
  TRY
    For i := 0 To l.Count -1 Do
    Begin
      aPitem := PParseItem(l[i]);
      Dispose(aPitem);
      l[i] := Nil;
    End;
  EXCEPT; END;
End;


Function THotLogParser.GetParams(singleLine:Boolean):String;
var splitter : string;
    i: Integer;
Begin
  If singleLine then splitter := ', '
  Else Begin
         splitter := #13#10;
         If Self.FshowLineNum Then for i := 0 To Self.FpvLnNumLen Do   // to len instead of "-1", ...
            Splitter := splitter + ' ';                                // ...to add the needed extra space
        End;
  If paramCount < 1 Then result := '(No params)'
  Else Begin
         result := paramstr(1);
         For i := 2 To paramCount Do
             result := result + splitter + paramStr(i);
       End;
End;


Function THotLogParser.GetVersionAsText:String;
var
  nVer:TInt4Array;
Begin
  nVer   := CurrentNumVer;
  Result := IntToStr(nVer[0]) + '.' + IntToStr(nVer[1]) + '.'
          + IntToStr(nVer[2]) + '.' + IntToStr(nVer[3]);
End;



Function THotLogParser.CurrentNumVer:TInt4Array;
// Retourne les N° de version majeur et mineur de l'appli, le N° de révision, et
// le Build ;
var
  vInfoSize, aDword,
  vValueSize: DWord;
  vInfo: Pointer;
  vValue: PVSFixedFileInfo;
begin
  zeroMemory(@result,SizeOf(result));
  TRY
    vInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), aDword);
    If vInfoSize <> 0 then
    Begin
      GetMem(vInfo, vInfoSize);
      GetFileVersionInfo(PChar(ParamStr(0)), 0, vInfoSize, vInfo);
      VerQueryValue(vInfo, '\', Pointer(vValue), vValueSize);
      result[0] := vValue^.dwFileVersionMS shr 16;
      result[1] := vValue^.dwFileVersionMS and $FFFF;
      result[2] := vValue^.dwFileVersionLS shr 16;
      result[3] := vValue^.dwFileVersionLS and $FFFF ;
      FreeMem(vInfo, vInfoSize);
    End;
  EXCEPT
    Result[0]:=-1;
  END;
end;


Procedure THotLogParser.GetRamOrHeapAsPitem(RamOrHeap,HeapRec,outFmt,ptr:integer; var hLst:Tlist);
// ramOrHeap : HL_HEAPMONITOR or HL_RAMMONITOR
// Receives both the list we're working on, and the index of the element to be
// filled. The index will be used to add a single line for all "single line
// output" versions, the whole list itself will be used (expanded) to return
// all heap monitor full formated values.

var sl: TStringList;                                   // will be created by GetHeap(); but freed here
    aPitem: PParseItem;
    i: Integer;
Begin
  Case ramOrHeap of
    HL_HEAPMONITOR : sl := GetHeap(HeapRec,outFmt);
    HL_RAMMONITOR  : sl := GetRam (HeapRec,outFmt);
    Else             sl := GetDisk(outFmt);            // HL_DSKMONITOR
  End;{case}

  // -1- The first entry, that is needed any case (extended or inline) :
    PParseItem(hLst[ptr]).kind    := ikStr;
    PParseItem(hLst[ptr]).sValue  := sl.Strings[0];
    PParseItem(hLst[ptr]).isSingle:= False;
    TRY
  // -2- The rest if Standalone tag used
    For i :=1 To sl.Count-1 Do                         // "0" soon managed
    Begin
      new(aPitem);
      aPitem^.kind    := ikStr;
      aPitem^.sValue  := sl.Strings[i];
      aPitem^.isSingle:= False;
      hLst.Add(aPitem);
    End;
    sl.Free;
  EXCEPT;
     TRY new(aPitem);
         aPitem^.kind    := ikStr;
         aPitem^.sValue  := '#HLMem';
         hLst.Add(aPitem);
     EXCEPT;END;
  END;
End;


Function THotLogParser.GetHeap(HeapRec,outFmt:integer):TStringList;
// May be called either for formatting "direct" values, or for formatting
// previously stored ones.
// outFmt values: 0=Heap, 1=Heap-, 2=Heap--, 3=Heap---
// If HeapRec <> -1 => to be used. Otherwise => heapMonitor table
var bl,by:Integer;
    st:String;
    hr:THeapMRec;
Begin
  Result := TStringList.Create;
  TRY
    // utilise heapRec transtypé si alimenté, sinon GetFirstEntry
    If HeapRec <> -1 Then
    Begin
      bl := THLHeapMonMsg(heapRec).FBlocks;
      by := THLHeapMonMsg(heapRec).FBytes;
      st := THLHeapMonMsg(heapRec).FExtra;
    End Else
    Begin
      hr := Self.HMonitor.GetFirstEntry;
      bl := hr.hBlocks;
      by := hr.hBytes;
      st := hr.hExtra;
    End;
    Case outFmt of
      0 : Begin
            result.Add('');
            result.Add('===========  Heap Monitor  ============' + st);
            result.Add('  AllocMemCount (Blocks) : '+ IntToStr(bl));
            result.Add('  AllocMemSize  (Bytes)  : '+ IntToStr(by));
            result.Add('=======================================');
            result.Add('');
          End;
      1 : result.Add('[Heap monitor] : Blocks=' + IntToStr(bl)
                   + ', Bytes=' + IntToStr(by) + st + ' ;');
      2 : result.Add('[Heap monitor] : (' + IntToStr(bl) + ', '
                      + IntToStr(by) + st + ')');
      3 : result.Add('(' + IntToStr(bl) + ', ' + IntToStr(by) + st + ')');
    End;{case}
  EXCEPT result.Add('#HLHeap');
  END;
End;


Function THotLogParser.GetRam(HeapRec,outFmt:integer):TStringList;
// outFmt values: 0=Ram, 1=Ram-, 2=Ram--, 3=Ram---
// If HeapRec <> -1 => to be used. Otherwise => heapMonitor table
var bl,by,ld:Integer;
    st:String;
    hr:THeapMRec;
Begin
  Result := TStringList.Create;
  TRY
    If HeapRec <> -1 Then
    Begin
      bl := THLHeapMonMsg(heapRec).FBlocks;
      by := THLHeapMonMsg(heapRec).FBytes;
      ld := THLHeapMonMsg(heapRec).FLoad;
      st := THLHeapMonMsg(heapRec).FExtra;
    End Else
    Begin
      hr := Self.RMonitor.GetFirstEntry;
      bl := hr.hBlocks;
      by := hr.hBytes;
      ld := hr.hLoad;
      st := hr.hExtra;
    End;

    Case outFmt of
      0 : Begin
            result.Add('');
            result.Add('============  RAM Monitor  ============' + st);
            result.Add('  Memory (Total) : '+ IntToStr(Round(bl / mb))
                  + ' MB ('+ IntToStr(bl) + ' B)');
            result.Add('  Memory (Avail) : '+ IntToStr(Round(by / mb))
                       + ' MB ('+ IntToStr(by) + ' B)');
            result.Add(Format('================(%d%%)==================', [ld]));
            result.Add('');
          End;
      1 : result.Add('[RAM  monitor] : Total=' + IntToStr(bl)
                   + ', Avail=' + IntToStr(by) + ', Load='
                   + IntToStr(ld) + '%' + st + ' ;');
      2 : result.Add('[RAM  monitor] : (' + IntToStr(bl) + ', '
                      + IntToStr(by) + ', ' + IntToStr(ld)
                      + '%' + st + ')');
      3 : result.Add('(' + IntToStr(bl) + ', ' + IntToStr(by) + ', '
                         + IntToStr(ld) + '%'  + st + ')');
    End;{case}
  EXCEPT result.Add('#HLRam');
  END;
End;


Function THotLogParser.GetDisk(outFmt:Integer):TStringList;
// outFmt values: 0=disk, 1=disk-, 2=disk--, 3=disc---
// Unlike GetRam & GetHeap, GetDisk only uses directly read values,
// and provides no way to link a message to it's first line.

var bytesA,bytesT,bytesF:Int64;
Begin
  result := TStringList.Create;
  TRY
    If GetDiskFreeSpaceEx(Nil, bytesA, bytesT, @bytesF)       // bytesF shall be PLargeInteger !
    Then Case outFmt of
      0 : Begin
            result.Add('');
            result.Add('============  Disk Monitor  ===========');
            result.Add('  Free avail (user) : '+ IntToStr(Round(bytesA / mb)) + ' MB ('+ IntToStr(bytesA) + ' B)');
            result.Add('  Disk total (user) : '+ IntToStr(Round(bytesT / mb)) + ' MB ('+ IntToStr(bytesT) + ' B)');
            result.Add('  Free total (disk) : '+ IntToStr(Round(bytesF / mb)) + ' MB ('+ IntToStr(bytesF) + ' B)');
            result.Add('=======================================');
            result.Add('');
          End;
      1 : result.Add('[Disk monitor] : Available to user=' + IntToStr(bytesA) + ', Total on disk=' + IntToStr(bytesT) + ', Free total on disk=' + IntToStr(bytesF) + ' ;');
      2 : result.Add('[Disk monitor] : (' + IntToStr(bytesA) + ', ' + IntToStr(bytesT) + ', ' + IntToStr(bytesF) +')');
      3 : result.Add('(' + IntToStr(bytesA) + ', ' + IntToStr(bytesT) + ', ' + IntToStr(bytesF) + ')');
    End{case}
    Else result.Add('HL:Unable to retrieve disk space values');
  EXCEPT result.Add('#HLDisk');
  END;
End;


Procedure THotLogParser.GetCPUInfoAsPitem(var hLst:Tlist);
// Fills directly the list with CPU info values formatted;
var sl:      TStringList;
    aPitem:  PParseItem;
    i:       Integer;
    SysInfo: TSystemInfo;
    sTmp,pTmp,tTmp,
    vendor,regSpeed : String;
Begin
  sl := TStringList.Create;
  TRY
    GetSystemInfo(SysInfo);
    Case SysInfo.wProcessorArchitecture of
      0 : Begin
            sTmp := 'PROCESSOR_ARCHITECTURE_INTEL';
            pTmp := '(x86 Family '  + IntToStr(SysInfo.wProcessorLevel)
                    + ' Model '     + IntToStr(Hi(SysInfo.wProcessorRevision))
                    + ' Stepping '  + IntToStr(Lo(SysInfo.wProcessorRevision))+')';
          End;
      1 :  sTmp := 'PROCESSOR_ARCHITECTURE_MIPS';
      2 :  sTmp := 'PROCESSOR_ARCHITECTURE_ALPHA';
      3 :  sTmp := 'PROCESSOR_ARCHITECTURE_PPC';
      4 :  sTmp := 'PROCESSOR_ARCHITECTURE_SHX';
      5 :  sTmp := 'PROCESSOR_ARCHITECTURE_ARM';
      6 :  sTmp := 'PROCESSOR_ARCHITECTURE_IA64';
      7 :  sTmp := 'PROCESSOR_ARCHITECTURE_ALPHA64';
      8 :  sTmp := 'PROCESSOR_ARCHITECTURE_MSIL';
      Else sTmp := 'PROCESSOR_ARCHITECTURE_UNKNOWN';
    End;{case wProcessorArchitecture }
    Case SysInfo.dwProcessorType Of
       86 : tTmp := 'Intel 386';
      486 : tTmp := 'Intel 486';
      586 : tTmp := 'Intel Pentium';
      601 : tTmp := 'PPC 601';
      603 : tTmp := 'PPC 603';
      604 : tTmp := 'PPC 604';
      620 : tTmp := 'PPC 620';
      860 : tTmp := 'Intel 860';
     2000 : tTmp := 'MIPS R2000';
     3000 : tTmp := 'MIPS R3000';
     4000 : tTmp := 'MIPS R4000';
    21064 : tTmp := 'ALPHA 21064';
      Else  tTmp := '';
    End;{case dwProcessorType}
  // Registry stored values
    regSpeed := GetRegValue(HKEY_LOCAL_MACHINE,
                   'Hardware\Description\System\CentralProcessor\0',
                   '~MHz');
    If regSpeed <> '' Then regSpeed := regSpeed + ' MHz'
                      Else regSpeed := 'n/a';
    vendor :=   GetRegValue(HKEY_LOCAL_MACHINE,
                   'Hardware\Description\System\CentralProcessor\0',
                   'VendorIdentifier');
    If vendor <> '' Then vendor := IntToStr(SysInfo.dwOemId) + ' (' + vendor + ')'
                    Else vendor := IntToStr(SysInfo.dwOemId);
  EXCEPT
    If sTmp = '' Then sTmp := 'n/a';
    If tTmp = '' Then tTmp := 'n/a';
    If regSpeed = '' Then regSpeed :=  'n/a';
    If vendor = '' Then vendor :=  'n/a';
  END;

  TRY
  // -1-  Build result as TstringList ;
  With sl, SysInfo do
  Begin
    Add('');
    Add('==================================  CPU info  =====================================');
    Add('  Architecture                : ' + IntToStr(wProcessorArchitecture) + ' (' + sTmp + ')');
    Add('  OEM ID (vendor)             : ' + vendor );
    Add('  Active processor mask       : ' + IntToStr(dwActiveProcessorMask));
    Add('  Number of processors        : ' + IntToStr(dwNumberOfProcessors));
    Add('  Processor type              : ' + IntToStr(dwProcessorType) + ' (' + tTmp + ')');
    Case wProcessorLevel of
      3: sTmp := ' (Intel 80386) ';
      4: sTmp := ' (Intel 80486) ';
      5: sTmp := ' (Intel Pentium) ';
    Else sTmp := ' ';
    End;
    Add('  Processor level             : ' + IntToStr(wProcessorLevel) + sTmp  + pTmp);
    Add('  Speed (registry)            : ' + regSpeed);
    Add('  VMem allocation granularity : ' + FloatToStr(dwAllocationGranularity / 1024) + ' KB ('
                                           + IntToStr(SysInfo.dwAllocationGranularity) + ' B)');
    Add('  ProcessorRevision           : ' + IntToStr(wProcessorRevision));
    Add('  Page size                   : ' + IntToStr(Round(dwPageSize / 1024))
                                           + ' KB (' + FloatToStr(dwPageSize) + ' B)');
    Add(Format('  Minimum application address : %p',[lpMinimumApplicationAddress]));
    Add(Format('  Maximum application address : %p',[lpMaximumApplicationAddress]));

    Add('===================================================================================');
    Add('');
  end;

  // -2- Converts results -> Tlist of PParseItem.
  //--- 1st one soon exists, override it.
    PParseItem(hLst[0]).kind    := ikStr;
    PParseItem(hLst[0]).sValue  := sl.Strings[0];
    PParseItem(hLst[0]).isSingle:= False;
  //--- Next lines. Items to be created.
    For i :=1 To sl.Count-1 Do                            // "0" soon managed
    Begin
      new(aPitem);
      aPitem^.kind    := ikStr;
      aPitem^.sValue  := sl.Strings[i];
      aPitem^.isSingle:= False;
      hLst.Add(aPitem);
    End;
    sl.Free;
  EXCEPT;
     TRY new(aPitem);
         aPitem^.kind    := ikStr;
         aPitem^.sValue  := '#HLCPUInfo';
         hLst.Add(aPitem);
     EXCEPT;END;
  END;
end;


Procedure THotLogParser.GetOSVIAsPitem(var lst:Tlist);
VAR OSPm,prdSuite,
    OSName: String;               // OSPlatform  & name
    aPitem: PParseItem;
    OSVI: TOSVersionInfo;         // OSVersionInfo
    sl: TStringList;
    i:  Integer;
begin
  sl := TStringList.Create;
  OSVI.dwOSVersionInfoSize := SizeOf(OSVI);
  TRY
  // -1- Retrieve values from API
    GetVersionEx(OSVI);
    Case OSVI.dwPlatformId of
      VER_PLATFORM_WIN32s	      :  OSPm := 'Win32s under Windows 3.x';
      VER_PLATFORM_WIN32_WINDOWS:  OSPm := 'Windows 95, Windows 98, or Windows Me.';
      VER_PLATFORM_WIN32_NT     :  OSPm := 'Windows NT, Windows 2000, Windows XP, or Windows Server 2003 family.'
    End;
    Case OSVI.dwMajorVersion Of
      3 : If OSVI.dwMinorVersion = 51 Then OSName := 'Windows NT 3.51'
                                      Else OSName := 'Unknown (NT 3.X ?)';
      4 : Case OSVI.dwMinorVersion Of
            0 : If OSVI.dwPlatformId = VER_PLATFORM_WIN32_NT
                   Then OSName := 'Windows NT 4.0'
                   Else OSName := 'Windows 95';
           10 : OSName := 'Windows 98';
           90 : OSName := 'Windows Me';
          End;
      5 : Case OSVI.dwMinorVersion Of
            0 : OSName := 'Windows 2000';
            1 : OSName := 'Windows XP';
            2 : OSName := 'Windows Server 2003 family';
          End;
      End;
    prdSuite := GetRegValue(HKEY_LOCAL_MACHINE,
                            'SYSTEM\CurrentControlSet\Control\ProductOptions',
                            'ProductSuite');
    If prdSuite<>'' Then prdSuite := '('+prdSuite+')';
    With sl Do
    Begin
      Add('');
      Add('===============================  OS version info  =================================');
      Add('  Platform  : ' + OSPm);
      Add('  OS Name   : ' + OSName + ' (' + OSVI.szCSDVersion + ')' + prdSuite);
      Add('  (Major Version[ ' + IntToStr(OSVI.dwMajorVersion)
       + ' ]  Minor Version[ ' + IntToStr(OSVI.dwMinorVersion)
       + ' ] Build Number[ '   + IntToStr(LoWord(OSVI.dwBuildNumber))
       + ' ]  Platform ID[ '   + IntToStr(OSVI.dwPlatformID)
       + ' ])');
      Add('===================================================================================');
      Add('');
    End;

  // -2- Converts results -> Tlist of PParseItem.
    PParseItem(lst[0]).kind    := ikStr;
    PParseItem(lst[0]).sValue  := sl.Strings[0];
    PParseItem(lst[0]).isSingle:= False;
    For i :=1 To sl.Count-1 Do
    Begin
      new(aPitem);
      aPitem^.kind    := ikStr;
      aPitem^.sValue  := sl.Strings[i];
      aPitem^.isSingle:= False;
      lst.Add(aPitem);
    End;
    sl.Free;
  EXCEPT;
     TRY new(aPitem);
         aPitem^.kind    := ikStr;
         aPitem^.sValue  := '#HLOSVersionInfo';
         lst.Add(aPitem);
     EXCEPT;END;
  END;
End;


Procedure THotLogParser.GetTimerResolutionsAsPitem(var lst:Tlist);
// Formats local timer general measures, if available.
const HL_NS = '      n/s      ';
      HL_NA = '      n/a      ';
      sHdr1 = '===========================================';
      sHdr2 = '  Timers resolution  ';
      sHdr3 = '                          |                Min resolution                 |       Api \ call overhead';
      sHdr4 = '          Timers          |-----------------------------------------------|--------------------------------';
      sHdr5 = '                          |       ms      :       µs      :      ns       |     native    :    optimal    :';
      sHdr6 = '--------------------------|-----------------------------------------------|--------------------------------';
      sHdr7 = '==================';
      sLft1 = '  GetTickCount            |';
      sLft2 = '  QueryPerformanceCounter |';
      sLft3 = '  ReaDTimeStampCounter    |';
      sCmt1 = '(n/a: not available, n/s : not significant)';
      sCmt2 = 'QueryPerformanceFrequency returned : %d (native units)';
      sCmt3 = '(RDTSC min resolution from registry ; Overhead from asm call)';

var gtcIn, gtcOut: Integer;         //GetTickCount
    aTimer : TQTimer;
    aTimeScale: TQTimeScale;
    aReal:real; i:Integer;
    sGtcMinResMls,
    sQpcMinResMls, sQpcMinResMic, sQpcMinResNan,
    sRdtMinResMls, sRdtMinResMic, sRdtMinResNan,
    sQpcApiOvdNat, sQpcApiOvdOpt,
    sRdtApiOvdNat, sRdtApiOvdOpt: String;
    sl:TStringList;
    aPitem : PParseItem;


    {---------------  Local  ------------------}
    function FormatOutput(value:String;upTo:Integer=14):String;
    var i:Integer;
    Begin
      result := value + ' ';
      For i := Length(result) To upTo Do result := ' ' + result;
    End;
    {------------------------------------------}

Begin
  sl := TStringList.Create;
  aTimer := TQTimer.Create;

  TRY {finally}
// -1- GTC. Should be 15 to 16 ms;
  gtcIn := GetTickCount;
  Repeat
    gtcOut := GetTickCount;
  Until gtcIn <> gtcOut;
  sGtcMinResMls := '  ' + IntToStr(gtcOut-gtcIn) + ',---       ';

  TRY
// -2- QueryPerfCounter resolution = 1 / QueryPerfFrq(qpfFrq);
  If aTimer.FQpcFrq <= 0 Then
  Begin
    sQpcMinResMls := HL_NS;
    sQpcMinResMic := HL_NS;
    sQpcMinResNan := HL_NS;
    sQpcApiOvdNat := HL_NA;
    sQpcApiOvdOpt := HL_NA;
  End Else
  Begin
    sQpcMinResMls := FormatOutput(Format('%3.9n',[aTimer.getTimeMeasureAs(tsMilliSec,1,tkQPC)]));
    sQpcMinResMic := FormatOutput(Format('%3.9n',[aTimer.getTimeMeasureAs(tsMicroSec,1,tkQPC)]));
    sQpcMinResNan := FormatOutput(Format('%3.9n',[aTimer.getTimeMeasureAs(tsNanosSec,1,tkQPC)]));
    sQpcApiOvdNat := FormatOutput(IntToStr(aTimer.FQpcOverhead)+' units ');
    aReal := aTimer.GetOptimalMeasure(aTimer.FQpcOverhead, tkQPC, aTimeScale);
    sQpcApiOvdOpt := Format('%s (%3.9n)',
                     [TimeScale2Str[Ord(aTimeScale)], aReal ]);
  End;

// -3- ReadTimeStampCounter resolution = 1 / (registry's frq -> hrz);
  If aTimer.FRegFrq > 0 Then
  Begin
    sRdtMinResMls := FormatOutput(Format('%3.9n',[aTimer.getTimeMeasureAs(tsMilliSec,1,tkRDT)]));
    sRdtMinResMic := FormatOutput(Format('%3.9n',[aTimer.getTimeMeasureAs(tsMicroSec,1,tkRDT)]));
    sRdtMinResNan := FormatOutput(Format('%3.9n',[aTimer.getTimeMeasureAs(tsNanosSec,1,tkRDT)]));
    If aTimer.FRDTOverhead > 0 Then
    Begin
      sRdtApiOvdNat := FormatOutput(IntToStr(aTimer.FRDTOverhead)+' cycles');
      aReal := aTimer.GetOptimalMeasure(aTimer.FRDTOverhead, tkRDT, aTimeScale);
      sRdtApiOvdOpt := Format('%s (%3.9n)',
                              [TimeScale2Str[Ord(aTimeScale)], aReal ]);
    End Else
    Begin
      sRdtApiOvdNat := HL_NA;
      sRdtApiOvdOpt := HL_NA;
    End;
  End Else
  Begin
    sRdtMinResMls := HL_NA;
    sRdtMinResMic := HL_NA;
    sRdtMinResNan := HL_NA;
  End;

// -4- Résultats :
  With sl Do
  Begin
    Add('');
    Add(sHdr1 + sHdr2 + sHdr1); Add(sHdr3);Add(sHdr4);Add(sHdr5);Add(sHdr6);
    Add(sLft1 + sGtcMinResMls + ':' + HL_NS + ':' + HL_NS + '|      0 ticks  : ms or s.' );
    Add(sLft2 + sQpcMinResMls + ':' + sQpcMinResMic + ':' + sQpcMinResNan + '|' + sQpcApiOvdNat + ': ' + sQpcApiOvdOpt);
    Add(sLft3 + sRdtMinResMls + ':' + sRdtMinResMic + ':' + sRdtMinResNan + '|' + sRdtApiOvdNat + ': ' + sRdtApiOvdOpt);
    Add(sHdr7 + sHdr7 + sHdr7 + sHdr7 + sHdr7 + sHdr7);
    Add(FormatOutput(sCmt1,107));
    Add(FormatOutput(Format(sCmt2,[aTimer.FQpcFrq]),107));
    Add(FormatOutput(sCmt3,107));
    Add(sHdr7 + sHdr7 + sHdr7 + sHdr7 + sHdr7 + sHdr7);
    Add('');
  End;

// -5- Converts results -> Tlist of PParseItem.
    PParseItem(lst[0]).kind    := ikStr;
    PParseItem(lst[0]).sValue  := sl.Strings[0];
    PParseItem(lst[0]).isSingle:= False;
    For i :=1 To sl.Count-1 Do
    Begin
      new(aPitem);
      aPitem^.kind    := ikStr;
      aPitem^.sValue  := sl.Strings[i];
      aPitem^.isSingle:= False;
      lst.Add(aPitem);
    End;
    sl.Free;
  EXCEPT;
     TRY new(aPitem);
         aPitem^.kind    := ikStr;
         aPitem^.sValue  := '#HLTimersResolution';
         lst.Add(aPitem);
     EXCEPT;END;
  END;
  FINALLY aTimer.Free;
  END;
End;


Procedure THotLogParser.GetMemoryStatus(var lst:TList);
var mSS: TMemoryStatus;
    dkFree,
    dkTotal: Int64;
    sl : TStringList;
    i: Integer;
    aPitem: PParseItem;
begin
  dkFree  := DiskFree(0);                                  // drive 0 = current;
  dkTotal := DiskSize(0);
  TRY
    mSS.dwLength := SizeOf(mSS);
    GlobalMemoryStatus(mSS);

    sl := TStringList.Create;
    With mSS,sl Do Begin
      Add('');
      Add('=================================  Memory status  =================================');
      Add('  Memory (Total)              : ' + IntToStr(Round(mSS.dwTotalPhys / mb))
                         + ' MB ('+ IntToStr(mSS.dwTotalPhys) + ' B)');
      Add('  Memory (Available)          : ' + IntToStr(Round(mSS.dwAvailPhys / mb))
                         + ' MB ('+ IntToStr(mSS.dwAvailPhys) + ' B)'
                         + Format('  => Memory load : %d %%', [mSS.dwMemoryLoad]));
      Add('');
      Add('  Page(Swap)File (Total)      : ' + IntToStr(Round(dwTotalPageFile / mb))
                         + ' MB ('+ IntToStr(dwTotalPageFile) + ' B)');
      Add('  Page(Swap)File (Available)  : ' + IntToStr(Round(dwAvailPageFile / mb))
                         + ' MB ('+ IntToStr(dwAvailPageFile) + ' B)');
      Add('  Virtual Memory (Total)      : ' + IntToStr(Round(dwTotalVirtual / mb))
                         + ' MB ('+ IntToStr(dwTotalVirtual) + ' B)');
      Add('  Virtual Memory (Available)  : ' + IntToStr(Round(dwAvailVirtual / mb))
                       + ' MB ('+ IntToStr(dwAvailVirtual) + ' B)');
      Add('');
      Add('  Current Disk (Total)        : ' + IntToStr(Round(dkTotal / mb))
                         + ' MB ('+ IntToStr(dkTotal) + ' B)');
      Add('  Current disk (Available)    : ' + IntToStr(Round(dkFree / mb))
                         + ' MB ('+ IntToStr(dkFree) + ' B)'
                         + Format('  => Free space : %f %% ', [(dkFree / dkTotal*100)]));
      Add('===================================================================================');
      Add('');
    End;

  // -2- Converts results -> Tlist of PParseItem.
    PParseItem(lst[0]).kind    := ikStr;
    PParseItem(lst[0]).sValue  := sl.Strings[0];
    PParseItem(lst[0]).isSingle:= False;
    For i :=1 To sl.Count-1 Do
    Begin
      new(aPitem);
      aPitem^.kind    := ikStr;
      aPitem^.sValue  := sl.Strings[i];
      aPitem^.isSingle:= False;
      lst.Add(aPitem);
    End;
    sl.Free;
  EXCEPT;
     TRY new(aPitem);
         aPitem^.kind    := ikStr;
         aPitem^.sValue  := '#HLOSMemoryStatus';
         lst.Add(aPitem);
     EXCEPT;END;
  END;

end;


// 90   95  100  105  110  115  120
// |....|....|....|....|....|....|
Procedure THotLogParser.GetRuler(var lst:TList;showNums:Boolean=True);
//  Builds ruler lines; based upon stored definitions for ruler.
//  Returns the current lst, updated ; More usefull at design time
//  than at runTime...
Var i, lmt : Integer;
    rl : String;
    aPitem : PParseItem;

     {-------------  local  --------------}
      Function RulerBuildNumLine(current,upTo:integer;pad:String):String;
      Begin
        lmt := min(upTo,fRulerLength);
        result := '';
        While (current <= lmt) Do
        Begin
          result := result + IntToStr(current) + pad;
          inc(current, 5);
        End;
      End;
     {-----------  \ local \  ------------}

Begin
  TRY
  If Not(fRulerBuild) or (fRulerBuild
                          and  showNums
                          and (fRulerNums = '') ) Then
  Begin
    // Numbers
    If showNums Then
    Begin
      fRulerNums := '    5    ';
      fRulerNums := fRulerNums + RulerBuildNumLine(10, 95,'   ');
      If Self.fRulerLength > 95 Then
      Begin
        fRulerNums := Copy(fRulerNums, 1, Length(fRulerNums)-1)  + '100  ';
        fRulerNums := fRulerNums + RulerBuildNumLine(105, 995,'  ');
        If fRulerLength > 995 Then
        Begin
          fRulerNums := fRulerNums + '1000';
          fRulerNums := fRulerNums + RulerBuildNumLine(1005, 10000,' ');
        End;       
      End;
    End;{showNums}
    // dots & pipes
    rl := '....|....|';
    fRulerDots := '';
    For i := 1 to (fRulerLength div 10) Do
        fRulerDots :=  fRulerDots + rl;        
  fRulerBuild := True;
  End;{!fRulerBuild}
  //result
  If showNums Then
  Begin
    PParseItem(lst[0]).kind   := ikStr;
    PParseItem(lst[0]).sValue := fRulerNums;
    PParseItem(lst[0]).isSingle := False;
    New(aPitem);
    aPitem.kind     := ikStr;
    aPitem.sValue   := fRulerDots;
    aPitem.isSingle := False;
    lst.Add(aPitem);
  End Else
  Begin
    PParseItem(lst[0]).kind     := ikStr;
    PParseItem(lst[0]).sValue   := fRulerDots;
    PParseItem(lst[0]).isSingle := False;
  End;
  EXCEPT
    PParseItem(lst[0]).kind     := ikStr;
    PParseItem(lst[0]).sValue   := '#HLRuler(n/a)';
    PParseItem(lst[0]).isSingle := False;
  END;    
end;



////////////////////////////////////////////////////////////////////////////////
//  U T I L S
////////////////////////////////////////////////////////////////////////////////


Function THotLogParser.GetRegValue(root:HKey;key,wanted:String):String;
var Reg: TRegistry;
    i,sz:Integer;
    Buf : array of Byte;
begin
  result := '';
  Reg := TRegistry.Create;
  TRY
    TRY
      Reg.RootKey := root;
      Reg.Access  := KEY_READ;
      If Reg.OpenKeyReadOnly(key) then
      Begin
        Case reg.GetDataType(wanted) of
          rdString,
          rdExpandString : result := Reg.ReadString(wanted);
          rdInteger : result := IntToStr(Reg.ReadInteger(wanted));
          rdBinary,rdUnknown :
            Begin
              sz := Reg.GetDataSize(wanted);
              If sz > 0 Then
              Begin
                SetLength(Buf,sz);
                Reg.ReadBinaryData(wanted,buf[0],sz);     
                Result:='';                               
                For i:=0 to sz-2 do                       //-2 -> ignore final '  '
                    If Buf[i]=0 then result := result + '  '
                    Else result := result + Char(Buf[i]);
              End;
              Buf:=Nil;                  
              While (result[length(result)]=' ') Do
                    result := Copy(result,1,Length(result)-1);
              result := ' (' + result + ')';
            End;{rdBinary}
          Else result := '';
        End;{case}
        Reg.CloseKey;
      end;{if openKey}
    EXCEPT
      result := '';
    END
  FINALLY
    Reg.Free;
  END;
end;


{--------------------------------------------------------------------}
{---                      Threads : Writer                        ---}
{--------------------------------------------------------------------}

constructor THotLogWriter.Create(createSuspended:Boolean);
Begin
  inherited Create(createSuspended);
  Self.FDoFeedBack := False;
  Self.hlFileDef := THLFileDef.Create;
  Self.FStarted  := True;
End;


destructor THotLogWriter.Destroy;
Begin
  self.hlFileDef.Free;
  inherited;
End;


procedure THotLogWriter.Execute;
var tmpMsg:tagMSG;
    F:TFileStream;
begin
  TRY {Finally}
    F := TFileStream.Create(hlFileDef.fileName, hlFileDef.OpMode);
    TRY {Except}
      F.Seek(0, soEnd);
      While not( Terminated ) do
      Begin
        If PeekMessage(tmpMsg, 0, 0, 0, PM_REMOVE) then
          Case tmpMsg.message of

            WM_Quit : Terminate;
            UM_HLSIMPLESTRING:
               With THLStringMsg(tmpMsg.wParam) do
               Begin
                 F.WriteBuffer(PChar(fHlMsg)^, Length(fHlMsg));
                 If Self.FDoFeedBack                             // basic control
                    Then PostThreadMessage(Self.FVisualTID,      // hLog.hlVisual.ThreadID,
                             UM_HLSIMPLESTRING, tmpMsg.wParam, 0)
                    Else Free;
               End;

            UM_HLSTRINGLIST:
               Begin
                 TStringList(tmpMsg.wParam).SaveToStream(F);
                 If Self.FDoFeedBack                             // basic control
                    Then PostThreadMessage(Self.FVisualTID,
                             UM_HLSTRINGLIST, Integer(tmpMsg.wParam), 0)
                    Else TStringList(tmpMsg.wParam).Free;
               End;
          End;{Case}
          Sleep(50);
      End;
    EXCEPT
      On EInOutError do
         Begin
           FStarted := False;
           Terminate;                                            // File can't be used;
         End;
      Else ;                                                     // hides error and continues
    END;                                                         // (if it was not a FatalException...)
  FINALLY 
    FreeAndNil(F);
  END;
end;



{--------------------------------------------------------------------}
{---                   Threads:Visual feedback                       }
{--------------------------------------------------------------------}

// FeedBack adds everything to the memo you gave hLog, provided the
// FDoFeedBack boolean is set to true. This Bool is accesed throught
// the mutex hLog uses to update it, thus the memo is guaranted to be
// accessible (as long as you use hlog.StopVisualFeedBack if you want
// the feedBackThread to stop accessing that memo).

constructor THotLogVisual.Create(CreateSuspended:Boolean);
Begin
  Inherited Create(False);
  Self.sl := TStringList.Create;
  mxHLFeedBack := CreateMutex(nil, false, pchar('THLVisualFBMutex'
                + DateTimeToStr(Now) + IntToStr(GetTickCount) ));
  Self.FStarted := True;
End;


destructor THotLogVisual.Destroy;
Begin
  Self.sl.Free;
  If mxHLFeedBack > 0   Then CloseHandle(mxHLFeedBack);
  inherited;
End;


procedure THotLogVisual.Execute;
var tmpMsg:tagMSG;
begin
  TRY {Except}
    FreeOnTerminate := True;
    While not( Terminated ) do
    Begin
      If PeekMessage(tmpMsg, 0, 0, 0, PM_REMOVE) then
      Begin
        If (WaitForSingleObject(mxHLFeedBack,INFINITE) = WAIT_OBJECT_0) Then
        Begin
          If (Self.fDoFeedBack) Then
          Begin
            Case tmpMsg.message of
              UM_HLSIMPLESTRING:
                 Begin
                   Self.s := THLStringMsg(tmpMsg.wParam).fHlMsg;
                   RemoveCRLF(FROM_LINE);
                   Synchronize(DisplayLine);
                   ReleaseMutex(mxHLFeedBack);
                   THLStringMsg(tmpMsg.wParam).Free;
                   Self.s := '';
                 End;
              UM_HLSTRINGLIST:
                 Begin
                   Self.sl := TStringList(tmpMsg.wParam);
                   RemoveCRLF(FROM_LIST);
                   Synchronize(DisplayList);
                   ReleaseMutex(mxHLFeedBack);
                   TStringList(tmpMsg.wParam).Free;
                 End;
            End;{Case}
          end {FDoFeedBack}
          Else
            ReleaseMutex(mxHLFeedBack);  // we did catch it (but feedBack no longer requested)
        End  {If Wait_object_0}
      //Else -> Didn't obtaine the mutex
      End;{if peekMessage}
      Sleep(50); //le tout dernier
    End;{while}
  EXCEPT;END;
End;


procedure THotLogVisual.RemoveCRLF(fromWhat:Boolean);
// Removes one pair CRLF (or "LFCR", as it seems to potentially
// exist on some "hand made" PC ... )
var i : Integer;
Begin
  TRY
  If fromWhat = FROM_LINE Then
  Begin
    If Self.s <> '' Then
    Begin
      If Self.s[Length(s)] in [#10, #13] Then s := LeftStr(s,Length(s) -1);
         If Self.s[Length(s)] in [#10, #13] Then s := LeftStr(s,Length(s) -1);
    End;
  End Else //-> list
  Begin
    For i := 0 To Self.sl.Count -1 Do
    Begin
      s := self.sl[i];
      If Self.s <> '' Then
      Begin
        If s[Length(s)] in [#10, #13] Then s := LeftStr(s,Length(s) -1);
           If s[Length(s)] in [#10, #13] Then s := LeftStr(s,Length(s) -1);
        self.sl[i] := s;
      End;
    End;
  End;
  EXCEPT; END;
End;


// Below : Memo updating executes into the main thread (Throught the
// Synchronise mechanism) as long as GUI (so Canvas) operations are involved.

procedure THotLogVisual.DisplayLine;
Begin
  TRY Self.FfbMemo.Lines.Add(Self.s); EXCEPT; END;
End;

procedure THotLogVisual.DisplayList;
var ln : Integer;
Begin
  TRY
    Self.FfbMemo.Lines.AddStrings(Self.sl);
    If FDoScroll Then
    Begin
      ln := SendMessage(self.FfbMemo.Handle,EM_GETLINECOUNT,0,0);
      SendMessage(self.FfbMemo.Handle,EM_LINESCROLL,0,ln);
    end;
    EXCEPT; END;
End;



////////////////////////////////////////////////////////////////////////////////
// Others
////////////////////////////////////////////////////////////////////////////////

Constructor THeapMonitor.Create(asKind:TMonitorKind);
Begin
  Inherited Create;
  Self.FKindOfVals := asKind;
End;

Destructor THeapMonitor.Destroy;
Begin
  Self.ResetMemTable;                         // cleaning mem
  Inherited;
End;

Procedure THeapMonitor.AddRec(rec:Integer);
var ix : Integer;
Begin
  ix := length(HeapRecords);
  If (ix > High(Integer)-1) Then Exit
  Else Begin
         SetLength(HeapRecords, ix+1);
         HeapRecords[ix].hBlocks := THLHeapMonMsg(rec).FBlocks;
         HeapRecords[ix].hBytes  := THLHeapMonMsg(rec).FBytes;
         HeapRecords[ix].hLoad   := THLHeapMonMsg(rec).FLoad;
         HeapRecords[ix].hExtra  := THLHeapMonMsg(rec).FExtra;
       End;
End;

Function THeapMonitor.GetFirstEntry:THeapMRec;
var sz : Integer;
    mSS: TMemoryStatus;
Begin
  sz := length(HeapRecords)-1;
  If sz < 0 Then
  Begin                                        // None stored -> get values (thus not realy accurate...)
     Case Self.FKindOfVals of
       mkHeap : Begin
                 result.hBlocks := AllocMemCount;
                 result.hBytes  := AllocMemSize;
                 result.hLoad   := 0;
                 result.hExtra  := '';
               End;
       mkRam : Begin
                 mSS.dwLength := SizeOf(mSS);
                 GlobalMemoryStatus(mSS);
                 result.hBlocks := mSS.dwTotalPhys;
                 result.hBytes  := mSS.dwAvailPhys;
                 result.hLoad   := mSS.dwMemoryLoad;
                 result.hExtra  := '';
               End;
       end;{case}
  End Else                                     // Returns older stored entry
  With HeapRecords[0] Do
  Begin
    result.hBlocks := hBlocks;
    result.hBytes  := hBytes;
    result.hLoad   := hLoad;
    result.hExtra  := hExtra;
    hBlocks := 0;
    hBytes  := 0;
    hLoad   := 0;
    hExtra  := '';
    heapRecords := Copy(heapRecords, 1, sz);
  End;
End;

Procedure THeapMonitor.ResetMemTable;
var sz, ix : Integer;
Begin
  sz := length(HeapRecords);
  If sz > 0 Then
  Begin
    For ix := 0 to sz-1 Do
    Begin
      heapRecords[ix].hBlocks := 0;
      heapRecords[ix].hBytes  := 0;
      heapRecords[ix].hLoad   := 0;
      heapRecords[ix].hExtra  := '';
    End;
    setLength(heapRecords,0);
  End;
End;


constructor THLStringMsg.Create(s: string);
begin
  inherited Create;
  If s = '' Then s := #13#10
  Else If Not( s[Length(s)] in [#10, #13] ) Then s := s + #13#10;
  fHlMsg := s;
end;


destructor THLStringMsg.Destroy;
begin
  inherited;
end;


procedure THLStringMsg.Post(toThread:THandle; kindOfString:integer=HL_SIMPLESTRING);
Begin
  PostThreadMessage(toThread, UM_HLACTIONMSG,
                    kindOfString,Integer(Self));
end;



Constructor THLConstArrayMsg.Create(outputStyle:TVarRecStyle);
// outputStyle := vsBasic, vsExtended
Begin
  Inherited create;
  Self.FOutputStyle := outputStyle;
End;

destructor THLConstArrayMsg.Destroy;
Begin
  Inherited;  // the array has soon been 'finalized'
End;

procedure THLConstArrayMsg.Post(toThread:THandle);
Begin
  PostThreadMessage(toThread, UM_HLACTIONMSG, HL_PARSEARRAY,Integer(Self));
end;



constructor THLErrMsg.Create;
begin
  inherited Create;
end;


destructor THLErrMsg.Destroy;
Begin
  inherited;
end;


procedure THLErrMsg.Post(toThread:THandle);
Begin
   PostThreadMessage(toThread, UM_HLACTIONMSG,
                         HL_PARSEEXCEPTION,Integer(Self));
end;


constructor THLHeapMonMsg.Create(bl,by,ld:Integer;ex:String);
begin
  inherited Create;
  FBlocks := bl;
  FBytes  := by;
  FLoad   := ld;
  FExtra  := ex;
end;

destructor THLHeapMonMsg.Destroy;
Begin
  FBlocks := 0;
  FBytes  := 0;
  FLoad   := 0;
  FExtra  := '';
  Inherited destroy;
End;

procedure THLHeapMonMsg.Post(toThread:THandle;RamOrHeap:Integer;dirOutput:Boolean=False);
// RamOrHeap = HL_HEAPMONITOR or HL_RAMMONITOR
// dirOutput = Request storage or output ;
Begin
  Case dirOutput of
    True  : PostThreadMessage(toThread, UM_HLACTIONMSG, RamOrHeap,Integer(Self));
    False : PostThreadMessage(toThread, UM_HLSERVICEMSG,RamOrHeap,Integer(Self));
  End;{case}
end;





    {---------------------------------------------------------------------}
    {---                  Threads : Main(VCL) : TQTimer                ---}
    {---------------------------------------------------------------------}
    {                                                                     }
    {---------------------------------------------------------------------}

Constructor TQTimer.Create;
// Default output for timer deltas would give sthg like
// "12554092 units, 21.98452 ms"
Begin
  Inherited Create;
  fmtOutput        := '%3.9n';
  TimeUnitsWanted  := [];
  removeOverHead   := False;
  deltaShowNatives := True;                                // Measure's native units
  deltaShowOptimal := True;                                // Use optimal time unit
  FIsFinalized     := False;
  InitTimerEnvir;
End;

Destructor TQTimer.Destroy;
Begin
  fmtOutput := '';
  If Count > 0 Then Reset;
  Inherited;
End;

Procedure TQTimer.Reset;
Begin
  SetLength(FEntry,0);
End;

Function TQTimer.GetCount:Integer;
Begin
  result := Length(FEntry);
End;

Function TQTimer.GetStartAsInt(ix:integer):Int64;
Begin
  result := GetEntry(ix,twStart);
End;

Function TQTimer.GetStopAsInt(ix:integer):Int64;
Begin
  result := GetEntry(ix,twStop);
End;

Function TQTimer.GetDeltaAsInt(ix:integer):Int64;
Begin
  result := GetEntry(ix,twDelta);
End;


Function TQTimer.GetEntry(ix:Integer;wanted:TQTimerWanted):Int64;
Begin
  result := -1;
  ix := Abs(ix);
  TRY
    If ix > (Count -1) Then exit
    Else Case wanted of
           twDelta : result := FEntry[ix].tStop - FEntry[ix].tStart - Overhead(ix);
           twStart : result := FEntry[ix].tStart;
         Else result := FEntry[ix].tStop;
         End;{case}
  EXCEPT ; END;
End;


Function TQTimer.Overhead(ix:Integer):integer;
Begin
  result := 0;
  If Not(FIsFinalized) or Not(removeOverHead) Then Exit;
  TRY
    Case FEntry[ix].kind of
      tkQPC : result := FQpcOverhead;
      tkRDT : result := FRDTOverhead;
    Else {hms, gtc : overhead=0};
    End; {case}
  EXCEPT;
  END;
End;


Function TQTimer.GetStartAsStr(ix:integer):String;
Begin
  result := IntToStr(GetStartAsInt(ix));
End;

Function TQTimer.GetStopAsStr(ix:integer):String;
Begin
  result := IntToStr(GetStopAsInt(ix));
End;

Function TQTimer.GetDeltaAsStr(ix:integer):String;
Begin
  result := IntToStr(GetDeltaAsInt(ix));
End;


Function TQTimer.GetFormatedDeltaAsExt(ix:Integer):Extended;
var dummy : TQTimeScale;
Begin
  result := 0.00;
  TRY
  If Not(FIsFinalized) or Not(deltaShowOptimal)
     Then result := ( GetDeltaAsInt(ix) / 1 )       // Makes it an extended...
     Else result := GetOptimalMeasure(GetDeltaAsInt(ix), FEntry[ix].kind, dummy);
  EXCEPT;
  END;
End;


Function TQTimer.GetFormatedDeltaAsStr(ix:Integer):String;
var tmScale  : TQTimeScale;
    split  : String;
    counter: TQTimerKind;
Begin
  result := '';
  split  := '';
  TRY
  If Not(FIsFinalized) Then result := GetDeltaAsStr(ix) + ' ' + TimerUnit2Str[ Ord(FEntry[ix].kind) ]
  Else Begin
         counter := FEntry[ix].kind;
         If counter = tkHMS Then                      // hms is a special case
         Begin
           result := Int64ToTime(GetDeltaAsInt(ix));
           Exit;
         end;
         If deltaShowNatives Then
         Begin
           result := GetDeltaAsStr(ix) + ' ' + TimerUnit2Str[ Ord(counter) ];
           split  := ', ';
         End;
         If tsSeconds  In timeUnitsWanted Then
         Begin
           result := result + split + Format(fmtOutput,[getTimeMeasureAs(tsSeconds, GetDeltaAsInt(ix),counter)])
                                    + ' s.' ;         //+ TimeScale2Str[ord(tsSecondes)];
           split  := ', ';
         End;
         If tsMilliSec  In timeUnitsWanted Then
         Begin
           result := result + split + Format(fmtOutput,[getTimeMeasureAs(tsMilliSec,GetDeltaAsInt(ix),counter)])
                                    + ' ms';
           split  := ', ';
         End;
         If tsMicroSec  In timeUnitsWanted Then
         Begin
           result := result + split + Format(fmtOutput,[getTimeMeasureAs(tsMicroSec,GetDeltaAsInt(ix),counter)])
                                    + ' µs';
           split  := ', ';
         End;
         If tsNanosSec   In timeUnitsWanted Then
         Begin
           result := result + split + Format(fmtOutput,[getTimeMeasureAs(tsNanosSec,GetDeltaAsInt(ix),counter)])
                                    + ' ns';
           split  := ', ';
         End;
         If deltaShowOptimal
            Then result := result + split + Format(fmtOutput,[GetOptimalMeasure(GetDeltaAsInt(ix),counter, tmScale)])
                                  + ' '   + TimeScale2Str[ord(tmScale)];

       End;
  EXCEPT;
  END;
End;


Procedure TQTimer.Store(value:Int64;inOrOut:TQTimerAction;timerKind:TQTimerKind);
Var ix:Integer;
Begin
  TRY
  Case inOrOut of
    taStop  :  For ix := (Length(FEntry)-1) DownTo 0 Do
                   If FEntry[ix].tStop = 0 Then
                      Begin
                        FEntry[ix].tStop := value;
                        break;
                      End;

    taStart : Begin
                ix := Length(FEntry);
                If (ix = Pred(High(Integer))) Then exit;
                SetLength(FEntry,ix+1);
                FEntry[ix].tStart := value;
                FEntry[ix].tStop := 0;
                FEntry[ix].kind := timerKind;
              End;
  end;{case}
  EXCEPT; END;
End;

Function TQTimer.Int64ToTime(value:Int64):String;
// Converts an int64 back to hms
var Hour, Min, Sec,
    MSec, rmdM : Word;
Begin
  TRY
    hour := value Div 3600;
    rmdM := value - (hour * 3600);
    Min  := rmdM div 60;
    Sec  := rmdM mod 60;
    Msec := 0;
    result := TimeToStr(EncodeTime(Hour, Min, Sec, MSec));
  EXCEPT result := IntToStr(value);
  END;
End;

Function  TQTimer.HMS(startOrStop:TQTimerAction=taStart):TDateTime;
var Hour, Min, Sec, MSec: Word;
    dte64 :Int64;
Begin
  result := Now;
  DecodeTime(result, Hour, Min, Sec, MSec);
  dte64 := ( (hour * 3600)
         +   (Min  * 60)
         +   (sec ) );
  Store(dte64,startOrStop,tkHMS);
End;

Function  TQTimer.GTC(startOrStop:TQTimerAction=taStart):Integer;
Begin
  result := GetTickCount;
  Store(Int64(result),startOrStop,tkGTC);
End;

Function  TQTimer.QPC(startOrStop:TQTimerAction=taStart):Int64;
Begin
TRY
  QueryPerformanceCounter(result);
  Store(result,startOrStop,tkQPC);
EXCEPT; result := -1; END;
End;

Function  TQTimer.RDT(startOrStop:TQTimerAction=taStart):Int64;
Begin
TRY
  result := RDTSC;
  Store(result,startOrStop,tkRDT);
EXCEPT; result := -1; END;
end;



Procedure TQTimer.GlobalStop;
// GlobalStop will read the first non-zero stop entry in the storage table,
// (starting from the end (ie. the most recent one)), and copy it in any
// not yet filled entry.
// If no stop has been emitted before, it does nothing...
// Speed is not an issue : We copy sthg that soon exists, we don't make a measure.

// globalStop is usefull if ALL stored entries not yet stopped come from the
// same counter ; Otherwise it is useless, and will output erroneous measures.

Var ix:Integer;
    gStop:Int64;
Begin
  gStop := 0;
  TRY
    For ix := (Length(FEntry)-1) downTo 0 Do
        If FEntry[ix].tStop <> 0 Then Begin
                                    gStop := FEntry[ix].tStop;
                                    break;
                                  End;
    If gStop <> 0 Then
       For ix := (Length(FEntry)-1) downTo 0 Do
           If FEntry[ix].tStop = 0 Then FEntry[ix].tStop := gStop;
  EXCEPT; END;
End;


Function TQTimer.GetTimeMeasureAs(timeScale:TQTimeScale;
                          measure:Int64;
                          counter:TQTimerKind):real;
// converts a reading (delta) in a time measure corresponding to the timescale wanted;
const scaler : Array[0..3] of int64  = (1,1000,1000000,1000000000);
//                        (tsSecondes, tsMilliSec, tsMicroSec, tsNanosSec);
Begin
  Result := measure/1;
  If Not(FIsFinalized) then Exit;
  TRY
  Case counter of
    tkQPC : Begin
              If FQpcFrq > 0 Then
                 result := (measure / FQpcFrq) * scaler[ord(timeScale)];
            End;
    tkRDT : Begin
              If FRegFrq > 0 Then
                 result := (measure / FRegFrq) * scaler[ord(timeScale)];
            End;
    tkGTC : Begin
              If FRegFrq > 0 Then
                 result := (measure / 1000) * scaler[ord(timeScale)];
            End;
  // Else {hms : nothing to do};
  End;{case}
  EXCEPT;END;
End;


Function TQTimer.GetOptimalMeasure(measure:Int64; counter:TQTimerKind; var tScale:TQTimeScale):real;
var i:TQTimeScale;
    r:Real;
Begin
  TRY
    // hms as integer is simply returned as real :
    If counter = tkHMS Then
    Begin
      result := measure / 1;
      tScale := tsSeconds;
      Exit;
    end;

    For i := low(TQTimeScale) to high(TQTimeScale) Do
    Begin
      r := getTimeMeasureAs(i, measure, counter);
      If r > 100 Then break
      Else If (r < 99.9) And (r > 0.1) Then Break;
    End;
    result := r;
    tScale := i;
  EXCEPT;
    result := measure/1;
    // timeScale would be loosed...
  END;
End;


Procedure TQTimer.InitTimerEnvir;
// Retrieves & stores timers speeds ; Sets overhead, not resolutions.
Var i64In,i64Out,i64Sum : Int64;
    i: Integer;
    reg:TRegistry;
Begin
// queryPerformanceCounter
  If Not ( QueryPerformanceFrequency(FQpcFrq) ) Then
  Begin
    FQpcFrq := -1;
    FqpcOverHead := -1;
  End Else
  Begin
    i64Sum := 0;
    For i  := 0 To 19 Do            // try to average, despite not convincing...
    Begin
      QueryPerformanceCounter(i64In);
      QueryPerformanceCounter(i64Out);
      i64Sum := i64Sum +(i64Out-i64In);
    End;
    FqpcOverHead   := i64Sum div 20;
  End;
// Registry's stored frequency
  Reg := TRegistry.Create;
  FregFrq := -1;
  TRY
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access  := KEY_READ;
    If Reg.OpenKeyReadOnly('Hardware\Description\System\CentralProcessor\0') then
    Begin
      FRegFrq := Reg.ReadInteger('~MHz');
      FRegFrq := FRegFrq * 1000000;
      Reg.CloseKey;
    End;
  EXCEPT ;
  End;
// ReaDTimeStampCounter
  TRY
    i64In  := RDTSC;
    i64Out := RDTSC;
    FRdtOverhead   := i64Out - i64In;
    i64In  := RDTSC;
    i64Out := RDTSC;
    FRdtOverhead := Min((i64Out - i64In),FRdtOverhead);
    i64In  := RDTSC;
    i64Out := RDTSC;
    FRdtOverhead := Min((i64Out - i64In),FRdtOverhead);
  EXCEPT
    FRdtOverhead := -1;
  END;
    Self.FIsFinalized := (FqpcOverHead > -1) And (FRdtOverhead > -1);
End;


    {--------------------------------------------------------------------}
    {---                initialization & finalization                    }
    {--------------------------------------------------------------------}

initialization
  hLog := THotLog.Create;

finalization
  TRY
    hLog.Free;
  EXCEPT;END;

end.

////////////////////////////////////////////////////////////////////////////////



