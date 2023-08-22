unit uPSI_HotLog;
{
   with a helpfile
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
  TPSImport_HotLog = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THotLog(CL: TPSPascalCompiler);
procedure SIRegister_THotLogVisual(CL: TPSPascalCompiler);
procedure SIRegister_THotLogWriter(CL: TPSPascalCompiler);
procedure SIRegister_THotLogParser(CL: TPSPascalCompiler);
procedure SIRegister_THLHeapMonMsg(CL: TPSPascalCompiler);
procedure SIRegister_THLErrMsg(CL: TPSPascalCompiler);
procedure SIRegister_THLConstArrayMsg(CL: TPSPascalCompiler);
procedure SIRegister_THLStringMsg(CL: TPSPascalCompiler);
procedure SIRegister_THLFileDef(CL: TPSPascalCompiler);
procedure SIRegister_TQTimer(CL: TPSPascalCompiler);
procedure SIRegister_THeapMonitor(CL: TPSPascalCompiler);
procedure SIRegister_HotLog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HotLog_Routines(S: TPSExec);
procedure RIRegister_THotLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_THotLogVisual(CL: TPSRuntimeClassImporter);
procedure RIRegister_THotLogWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_THotLogParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_THLHeapMonMsg(CL: TPSRuntimeClassImporter);
procedure RIRegister_THLErrMsg(CL: TPSRuntimeClassImporter);
procedure RIRegister_THLConstArrayMsg(CL: TPSRuntimeClassImporter);
procedure RIRegister_THLStringMsg(CL: TPSRuntimeClassImporter);
procedure RIRegister_THLFileDef(CL: TPSRuntimeClassImporter);
procedure RIRegister_TQTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeapMonitor(CL: TPSRuntimeClassImporter);
procedure RIRegister_HotLog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,StrUtils
  ,Math
  ,Forms
  ,Registry
  ,StdCtrls
  ,HotLog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HotLog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THotLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THotLog') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THotLog') do begin
    RegisterProperty('hlWriter', 'THotLogWriter', iptrw);
    RegisterProperty('header', 'TStringList', iptrw);
    RegisterProperty('footer', 'TStringList', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure DisplayFeedBackInto( aMemo : TMemo)');
    RegisterMethod('Function StopVisualFeedBack : Boolean');
    RegisterMethod('Procedure ScrollMemo( doScroll : Boolean)');
    RegisterMethod('Procedure SetErrorCaption( value : String; surroundChar : String; jumpLines : Boolean)');
    RegisterMethod('Procedure SetErrorViewStyle( style : TVarRecStyle)');
    RegisterMethod('Procedure SetRulerLength( newLength : Integer)');
    RegisterMethod('Function ModifyLineNumbering( doShow : Boolean; alignment : TAlignment; size : Integer) : Boolean');
    RegisterMethod('Procedure ResetHeapTable');
    RegisterMethod('Function HeapMonitor( hmExtra : String; directOutput : Boolean) : THeapMRec');
    RegisterMethod('Procedure ResetRamTable');
    RegisterMethod('Function RamMonitor( hmExtra : String; directOutput : Boolean) : THeapMRec');
    RegisterMethod('Procedure StartLogging');
    RegisterMethod('Procedure JumpLine( LinesToJump : Integer)');
    RegisterMethod('Procedure Add( aString : String);');
    RegisterMethod('Procedure Add1( aStringList : TStringList);');
    RegisterMethod('Procedure Add2( style : TVarRecStyle; aConstArray : array of const);');
    RegisterMethod('Procedure AddStr( aString : String)');
    RegisterMethod('Procedure AddException( ex : Exception; err : Integer; freeAfterPost : Boolean);');
    RegisterMethod('Procedure AddException1( ex : Exception; func : String; args : array of const; err : Integer; freeAfterPost : Boolean);');
    RegisterMethod('Procedure AddError( err : Integer);');
    RegisterMethod('Procedure AddError1( err : Integer; func : String; args : array of const);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THotLogVisual(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'THotLogVisual') do
  with CL.AddClassN(CL.FindClass('TThread'),'THotLogVisual') do
  begin
    RegisterProperty('FStarted', 'Boolean', iptrw);
    RegisterProperty('s', 'String', iptrw);
    RegisterProperty('sl', 'TStringList', iptrw);
    RegisterMethod('Constructor Create( createSuspended : Boolean)');
    RegisterMethod('Procedure RemoveCRLF( fromWhat : Boolean)');
    RegisterMethod('Procedure DisplayLine');
    RegisterMethod('Procedure DisplayList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THotLogWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'THotLogWriter') do
  with CL.AddClassN(CL.FindClass('TThread'),'THotLogWriter') do
  begin
    RegisterProperty('hlFileDef', 'THLFileDef', iptrw);
    RegisterMethod('Constructor Create( createSuspended : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THotLogParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'THotLogParser') do
  with CL.AddClassN(CL.FindClass('TThread'),'THotLogParser') do begin
     RegisterMethod('Procedure Execute');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THLHeapMonMsg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THLHeapMonMsg') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THLHeapMonMsg') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THLErrMsg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THLErrMsg') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THLErrMsg') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THLConstArrayMsg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THLConstArrayMsg') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THLConstArrayMsg') do
  begin
    RegisterProperty('FConstArray', 'TConstArray', iptrw);
    RegisterProperty('FOutputStyle', 'TVarRecStyle', iptrw);
    RegisterMethod('Constructor Create( outputStyle : TVarRecStyle)');
    RegisterMethod('Procedure Post( toThread : THandle)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THLStringMsg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THLStringMsg') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THLStringMsg') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THLFileDef(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THLFileDef') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THLFileDef') do
  begin
    RegisterMethod('Constructor create');
    RegisterProperty('ddname', 'String', iptrw);
    RegisterProperty('path', 'String', iptrw);
    RegisterProperty('ext', 'String', iptrw);
    RegisterProperty('fileName', 'TFileName', iptrw);
    RegisterProperty('append', 'Boolean', iptrw);
    RegisterProperty('gdgMax', 'Word', iptrw);
    RegisterProperty('OpMode', 'Word', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TQTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TQTimer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TQTimer') do begin
    RegisterProperty('fmtOutput', 'String', iptrw);
    RegisterProperty('timeUnitsWanted', 'set of TQTimeScale', iptrw);
    RegisterProperty('removeOverHead', 'Boolean', iptrw);
    RegisterProperty('deltaShowNatives', 'Boolean', iptrw);
    RegisterProperty('deltaShowOptimal', 'Boolean', iptrw);
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function HMS( startOrStop : TQTimerAction) : TDateTime');
    RegisterMethod('Function GTC( startOrStop : TQTimerAction) : Integer');
    RegisterMethod('Function QPC( startOrStop : TQTimerAction) : Int64');
    RegisterMethod('Function RDT( startOrStop : TQTimerAction) : Int64');
    RegisterMethod('Procedure GlobalStop');
    RegisterMethod('Procedure Reset');
    RegisterProperty('isFinalized', 'Boolean', iptr);
    RegisterProperty('RegistryFreq', 'int64', iptr);
    RegisterProperty('QueryPerfFreq', 'Int64', iptr);
    RegisterProperty('ReaDTSCOverhead', 'int64', iptr);
    RegisterProperty('QueryPerfOverhead', 'int64', iptr);
    RegisterProperty('Count', 'integer', iptr);
    RegisterProperty('iStart', 'int64 Integer', iptr);
    RegisterProperty('iStop', 'int64 Integer', iptr);
    RegisterProperty('iDelta', 'int64 Integer', iptr);
    RegisterProperty('sStart', 'String Integer', iptr);
    RegisterProperty('sStop', 'String Integer', iptr);
    RegisterProperty('sDelta', 'String Integer', iptr);
    RegisterProperty('iDeltaFmt', 'Extended Integer', iptr);
    RegisterProperty('sDeltaFmt', 'String Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeapMonitor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THeapMonitor') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THeapMonitor') do
  begin
    RegisterMethod('Constructor Create( asKind : TMonitorKind)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HotLog(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('UM_HLSOON_USED','LongInt').SetInt( 0);
 CL.AddConstantN('HL_LINENUMCHANGED','LongInt').SetInt( 0);
 CL.AddConstantN('HL_SIMPLESTRING','LongInt').SetInt( 1);
 CL.AddConstantN('HL_PARSEEXCEPTION','LongInt').SetInt( 2);
 CL.AddConstantN('HL_JUMPLINES','LongInt').SetInt( 3);
 CL.AddConstantN('HL_PARSELINE','LongInt').SetInt( 4);
 CL.AddConstantN('HL_PARSELIST','LongInt').SetInt( 5);
 CL.AddConstantN('HL_PARSEARRAY','LongInt').SetInt( 6);
 CL.AddConstantN('HL_HEAPMONITOR','LongInt').SetInt( 7);
 CL.AddConstantN('HL_RAMMONITOR','LongInt').SetInt( 8);
 CL.AddConstantN('HL_DSKMONITOR','LongInt').SetInt( 9);
 CL.AddConstantN('HL_RESETHEAPTABLE','LongInt').SetInt( 10);
 CL.AddConstantN('HL_RESETRAMTABLE','LongInt').SetInt( 11);
 CL.AddConstantN('HL_RESETRULER','LongInt').SetInt( 12);
 CL.AddConstantN('HLT_AND','LongInt').SetInt( 38);
 CL.AddConstantN('HLT_PAD','LongInt').SetInt( 42);
 CL.AddConstantN('HLT_AT','LongInt').SetInt( 64);
 CL.AddConstantN('HLT_RAM','LongInt').SetInt( 16799);
 CL.AddConstantN('HLT_HEAP','LongInt').SetInt( 38281);
 CL.AddConstantN('HLT_DISK','LongInt').SetInt( 38039);
 CL.AddConstantN('HLT_RAM1','LongInt').SetInt( 28319);
 CL.AddConstantN('HLT_HEAP1','LongInt').SetInt( 38326);
 CL.AddConstantN('HLT_DISK1','LongInt').SetInt( 38084);
 CL.AddConstantN('HLT_RAM2','LongInt').SetInt( 28364);
 CL.AddConstantN('HLT_HEAP2','LongInt').SetInt( 49846);
 CL.AddConstantN('HLT_DISK2','LongInt').SetInt( 49604);
 CL.AddConstantN('HLT_RAM3','LongInt').SetInt( 39884);
 CL.AddConstantN('HLT_HEAP3','LongInt').SetInt( 49891);
 CL.AddConstantN('HLT_DISK3','LongInt').SetInt( 49649);
 CL.AddConstantN('HLT_CPUI','LongInt').SetInt( 39320);
 CL.AddConstantN('HLT_OSVI','LongInt').SetInt( 40101);
 CL.AddConstantN('HLT_MEM','LongInt').SetInt( 17818);
 CL.AddConstantN('HLT_TIMERS','LongInt').SetInt( 57843);
 CL.AddConstantN('HLT_DHG','LongInt').SetInt( 18571);
 CL.AddConstantN('HLT_DTE','LongInt').SetInt( 21641);
 CL.AddConstantN('HLT_GTC','LongInt').SetInt( 21642);
 CL.AddConstantN('HLT_HMS','LongInt').SetInt( 19867);
 CL.AddConstantN('HLT_LNUM','LongInt').SetInt( 39841);
 CL.AddConstantN('HLT_NOW','LongInt').SetInt( 20389);
 CL.AddConstantN('HLT_CRLF','LongInt').SetInt( 47);
 CL.AddConstantN('HLT_LNUMOFF','LongInt').SetInt( 57910);
 CL.AddConstantN('HLT_APP_NAME','LongInt').SetInt( 79404);
 CL.AddConstantN('HLT_APP_PATH','LongInt').SetInt( 80181);
 CL.AddConstantN('HLT_APP_LFN','LongInt').SetInt( 63019);
 CL.AddConstantN('HLT_APP_VER','LongInt').SetInt( 62777);
 CL.AddConstantN('HLT_RULER','LongInt').SetInt( 39664);
 CL.AddConstantN('HLT_RULER1','LongInt').SetInt( 50672);
 CL.AddConstantN('HLT_APP_PRM','LongInt').SetInt( 66094);
 CL.AddConstantN('APP_PRM_LN','LongInt').SetInt( 77614);
 CL.AddConstantN('MB','LongInt').SetInt( 1024 * 1024);
 //CL.AddConstantN('FROM_LINE','Boolean')BoolToStr( True);
 //CL.AddConstantN('FROM_LIST','Boolean')BoolToStr( True);
  //CL.AddTypeS('TConstArray', 'array of TVarRec');
  CL.AddTypeS('TMonitorKind', '( mkHeap, mkRam )');
  CL.AddTypeS('TVarRecStyle', '( vsNone, vsBasic, vsExtended )');
  CL.AddTypeS('TParseItemKind', '( ikStr, ikTag )');
  //CL.AddTypeS('PParseItem', '^TParseItem // will not work');
  CL.AddTypeS('TParseItem', 'record kind : TParseItemKind; sValue : String; iVa'
   +'lue : Cardinal; isSingle : Boolean; end');
  CL.AddTypeS('THeapMRec', 'record hBlocks : integer; hBytes : integer; hLoad :'
   +' Integer; hExtra : String; end');
  SIRegister_THeapMonitor(CL);
  CL.AddTypeS('TQTimeScale', '( tsSeconds, tsMilliSec, tsMicroSec, tsNanosSec )');
  CL.AddTypeS('TQTimerAction', '( taStart, taStop, taGlobalStop )');
  CL.AddTypeS('TQTimerWanted', '( twStart, twStop, twDelta )');
  CL.AddTypeS('TQTimerKind', '( tkHMS, tkGTC, tkQPC, tkRDT )');
  CL.AddTypeS('TQTimerEntry', 'record tStart : int64; tStop : int64; kind : TQTimerKind; end');
  SIRegister_TQTimer(CL);
  //CL.AddTypeS('PFlName', '^FlName // will not work');
  CL.AddTypeS('FlName', 'record fullName : TFileName; ext3 : String; isGdg : Boolean; end');
  SIRegister_THLFileDef(CL);
  SIRegister_THLStringMsg(CL);
  SIRegister_THLConstArrayMsg(CL);
  SIRegister_THLErrMsg(CL);
  SIRegister_THLHeapMonMsg(CL);
  SIRegister_THotLogParser(CL);
  SIRegister_THotLogWriter(CL);
  SIRegister_THotLogVisual(CL);
  SIRegister_THotLog(CL);
 CL.AddDelphiFunction('Function CompareGdgNames( p1, p2 : TObject) : Integer');
 CL.AddDelphiFunction('Function RDTSC : Int64');
   //CL.AddUsedVariableN('hlog','THotlog');
   //CL.AddUsedPtrVariableN('hlog','THotlog');
   //AddRegisteredVariable('hlog', 'THotlog'); //init of unit

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure THotLogAddError1_P(Self: THotLog;  err : Integer; func : String; args : array of const);
Begin Self.AddError(err, func, args); END;

(*----------------------------------------------------------------------------*)
Procedure THotLogAddError_P(Self: THotLog;  err : Integer);
Begin Self.AddError(err); END;

(*----------------------------------------------------------------------------*)
Procedure THotLogAddException1_P(Self: THotLog;  ex : Exception; func : String; args : array of const; err : Integer; freeAfterPost : Boolean);
Begin Self.AddException(ex, func, args, err, freeAfterPost); END;

(*----------------------------------------------------------------------------*)
Procedure THotLogAddException_P(Self: THotLog;  ex : Exception; err : Integer; freeAfterPost : Boolean);
Begin Self.AddException(ex, err, freeAfterPost); END;

(*----------------------------------------------------------------------------*)
Procedure THotLogAdd2_P(Self: THotLog;  style : TVarRecStyle; aConstArray : array of const);
Begin Self.Add(style, aConstArray); END;

(*----------------------------------------------------------------------------*)
Procedure THotLogAdd1_P(Self: THotLog;  aStringList : TStringList);
Begin Self.Add(aStringList); END;

(*----------------------------------------------------------------------------*)
Procedure THotLogAdd_P(Self: THotLog;  aString : String);
Begin Self.Add(aString); END;

(*----------------------------------------------------------------------------*)
procedure THotLogfooter_W(Self: THotLog; const T: TStringList);
Begin Self.footer := T; end;

(*----------------------------------------------------------------------------*)
procedure THotLogfooter_R(Self: THotLog; var T: TStringList);
Begin T := Self.footer; end;

(*----------------------------------------------------------------------------*)
procedure THotLogheader_W(Self: THotLog; const T: TStringList);
Begin Self.header := T; end;

(*----------------------------------------------------------------------------*)
procedure THotLogheader_R(Self: THotLog; var T: TStringList);
Begin T := Self.header; end;

(*----------------------------------------------------------------------------*)
procedure THotLoghlWriter_W(Self: THotLog; const T: THotLogWriter);
Begin Self.hlWriter := T; end;

(*----------------------------------------------------------------------------*)
procedure THotLoghlWriter_R(Self: THotLog; var T: THotLogWriter);
Begin T := Self.hlWriter; end;

(*----------------------------------------------------------------------------*)
procedure THotLogVisualsl_W(Self: THotLogVisual; const T: TStringList);
Begin Self.sl := T; end;

(*----------------------------------------------------------------------------*)
procedure THotLogVisualsl_R(Self: THotLogVisual; var T: TStringList);
Begin T := Self.sl; end;

(*----------------------------------------------------------------------------*)
procedure THotLogVisuals_W(Self: THotLogVisual; const T: String);
Begin Self.s := T; end;

(*----------------------------------------------------------------------------*)
procedure THotLogVisuals_R(Self: THotLogVisual; var T: String);
Begin T := Self.s; end;

(*----------------------------------------------------------------------------*)
procedure THotLogVisualFStarted_W(Self: THotLogVisual; const T: Boolean);
Begin Self.FStarted := T; end;

(*----------------------------------------------------------------------------*)
procedure THotLogVisualFStarted_R(Self: THotLogVisual; var T: Boolean);
Begin T := Self.FStarted; end;

(*----------------------------------------------------------------------------*)
procedure THotLogWriterhlFileDef_W(Self: THotLogWriter; const T: THLFileDef);
Begin Self.hlFileDef := T; end;

(*----------------------------------------------------------------------------*)
procedure THotLogWriterhlFileDef_R(Self: THotLogWriter; var T: THLFileDef);
Begin T := Self.hlFileDef; end;

(*----------------------------------------------------------------------------*)
Procedure THotLogParserAddLineNum1_P(Self: THotLogParser;  var lst : TStringList);
Begin //Self.AddLineNum(lst);
END;

(*----------------------------------------------------------------------------*)
Function THotLogParserAddLineNum_P(Self: THotLogParser;  line : String) : String;
Begin //Result := Self.AddLineNum(line);
END;

(*----------------------------------------------------------------------------*)
procedure THLConstArrayMsgFOutputStyle_W(Self: THLConstArrayMsg; const T: TVarRecStyle);
Begin Self.FOutputStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure THLConstArrayMsgFOutputStyle_R(Self: THLConstArrayMsg; var T: TVarRecStyle);
Begin T := Self.FOutputStyle; end;

(*----------------------------------------------------------------------------*)
procedure THLConstArrayMsgFConstArray_W(Self: THLConstArrayMsg; const T: TConstArray);
Begin Self.FConstArray := T; end;

(*----------------------------------------------------------------------------*)
procedure THLConstArrayMsgFConstArray_R(Self: THLConstArrayMsg; var T: TConstArray);
Begin T := Self.FConstArray; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefOpMode_R(Self: THLFileDef; var T: Word);
begin T := Self.OpMode; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefgdgMax_W(Self: THLFileDef; const T: Word);
begin Self.gdgMax := T; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefgdgMax_R(Self: THLFileDef; var T: Word);
begin T := Self.gdgMax; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefappend_W(Self: THLFileDef; const T: Boolean);
begin Self.append := T; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefappend_R(Self: THLFileDef; var T: Boolean);
begin T := Self.append; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDeffileName_W(Self: THLFileDef; const T: TFileName);
begin Self.fileName := T; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDeffileName_R(Self: THLFileDef; var T: TFileName);
begin T := Self.fileName; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefext_W(Self: THLFileDef; const T: String);
begin Self.ext := T; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefext_R(Self: THLFileDef; var T: String);
begin T := Self.ext; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefpath_W(Self: THLFileDef; const T: String);
begin Self.path := T; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefpath_R(Self: THLFileDef; var T: String);
begin T := Self.path; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefddname_W(Self: THLFileDef; const T: String);
begin Self.ddname := T; end;

(*----------------------------------------------------------------------------*)
procedure THLFileDefddname_R(Self: THLFileDef; var T: String);
begin T := Self.ddname; end;

(*----------------------------------------------------------------------------*)
procedure TQTimersDeltaFmt_R(Self: TQTimer; var T: String; const t1: Integer);
begin T := Self.sDeltaFmt[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimeriDeltaFmt_R(Self: TQTimer; var T: Extended; const t1: Integer);
begin T := Self.iDeltaFmt[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimersDelta_R(Self: TQTimer; var T: String; const t1: Integer);
begin T := Self.sDelta[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimersStop_R(Self: TQTimer; var T: String; const t1: Integer);
begin T := Self.sStop[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimersStart_R(Self: TQTimer; var T: String; const t1: Integer);
begin T := Self.sStart[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimeriDelta_R(Self: TQTimer; var T: int64; const t1: Integer);
begin T := Self.iDelta[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimeriStop_R(Self: TQTimer; var T: int64; const t1: Integer);
begin T := Self.iStop[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimeriStart_R(Self: TQTimer; var T: int64; const t1: Integer);
begin T := Self.iStart[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerCount_R(Self: TQTimer; var T: integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerQueryPerfOverhead_R(Self: TQTimer; var T: int64);
begin T := Self.QueryPerfOverhead; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerReaDTSCOverhead_R(Self: TQTimer; var T: int64);
begin T := Self.ReaDTSCOverhead; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerQueryPerfFreq_R(Self: TQTimer; var T: Int64);
begin T := Self.QueryPerfFreq; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerRegistryFreq_R(Self: TQTimer; var T: int64);
begin T := Self.RegistryFreq; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerisFinalized_R(Self: TQTimer; var T: Boolean);
begin T := Self.isFinalized; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerdeltaShowOptimal_W(Self: TQTimer; const T: Boolean);
Begin Self.deltaShowOptimal := T; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerdeltaShowOptimal_R(Self: TQTimer; var T: Boolean);
Begin T := Self.deltaShowOptimal; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerdeltaShowNatives_W(Self: TQTimer; const T: Boolean);
Begin Self.deltaShowNatives := T; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerdeltaShowNatives_R(Self: TQTimer; var T: Boolean);
Begin T := Self.deltaShowNatives; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerremoveOverHead_W(Self: TQTimer; const T: Boolean);
Begin Self.removeOverHead := T; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerremoveOverHead_R(Self: TQTimer; var T: Boolean);
Begin T := Self.removeOverHead; end;

(*----------------------------------------------------------------------------*)
(*procedure TQTimertimeUnitsWanted_W(Self: TQTimer; const T: set of TQTimeScale);
Begin Self.timeUnitsWanted := T; end; *)

(*----------------------------------------------------------------------------*)
(*procedure TQTimertimeUnitsWanted_R(Self: TQTimer; var T: set of TQTimeScale);
Begin T := Self.timeUnitsWanted; end;*)

(*----------------------------------------------------------------------------*)
procedure TQTimerfmtOutput_W(Self: TQTimer; const T: String);
Begin Self.fmtOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TQTimerfmtOutput_R(Self: TQTimer; var T: String);
Begin T := Self.fmtOutput; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HotLog_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CompareGdgNames, 'CompareGdgNames', cdRegister);
 S.RegisterDelphiFunction(@RDTSC, 'RDTSC', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THotLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THotLog) do begin
    RegisterPropertyHelper(@THotLoghlWriter_R,@THotLoghlWriter_W,'hlWriter');
    RegisterPropertyHelper(@THotLogheader_R,@THotLogheader_W,'header');
    RegisterPropertyHelper(@THotLogfooter_R,@THotLogfooter_W,'footer');
    RegisterConstructor(@THotLog.Create, 'Create');
    RegisterMethod(@THotLog.Destroy, 'Free');
    RegisterMethod(@THotLog.DisplayFeedBackInto, 'DisplayFeedBackInto');
    RegisterMethod(@THotLog.StopVisualFeedBack, 'StopVisualFeedBack');
    RegisterMethod(@THotLog.ScrollMemo, 'ScrollMemo');
    RegisterMethod(@THotLog.SetErrorCaption, 'SetErrorCaption');
    RegisterMethod(@THotLog.SetErrorViewStyle, 'SetErrorViewStyle');
    RegisterMethod(@THotLog.SetRulerLength, 'SetRulerLength');
    RegisterMethod(@THotLog.ModifyLineNumbering, 'ModifyLineNumbering');
    RegisterMethod(@THotLog.ResetHeapTable, 'ResetHeapTable');
    RegisterMethod(@THotLog.HeapMonitor, 'HeapMonitor');
    RegisterMethod(@THotLog.ResetRamTable, 'ResetRamTable');
    RegisterMethod(@THotLog.RamMonitor, 'RamMonitor');
    RegisterMethod(@THotLog.StartLogging, 'StartLogging');
    RegisterMethod(@THotLog.JumpLine, 'JumpLine');
    RegisterMethod(@THotLogAdd_P, 'Add');
    RegisterMethod(@THotLogAdd1_P, 'Add1');
    RegisterMethod(@THotLogAdd2_P, 'Add2');
    RegisterMethod(@THotLog.AddStr, 'AddStr');
    RegisterMethod(@THotLogAddException_P, 'AddException');
    RegisterMethod(@THotLogAddException1_P, 'AddException1');
    RegisterMethod(@THotLogAddError_P, 'AddError');
    RegisterMethod(@THotLogAddError1_P, 'AddError1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THotLogVisual(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THotLogVisual) do begin
    RegisterPropertyHelper(@THotLogVisualFStarted_R,@THotLogVisualFStarted_W,'FStarted');
    RegisterPropertyHelper(@THotLogVisuals_R,@THotLogVisuals_W,'s');
    RegisterPropertyHelper(@THotLogVisualsl_R,@THotLogVisualsl_W,'sl');
    RegisterConstructor(@THotLogVisual.Create, 'Create');
    RegisterMethod(@THotLogVisual.RemoveCRLF, 'RemoveCRLF');
    RegisterMethod(@THotLogVisual.DisplayLine, 'DisplayLine');
    RegisterMethod(@THotLogVisual.DisplayList, 'DisplayList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THotLogWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THotLogWriter) do
  begin
    RegisterPropertyHelper(@THotLogWriterhlFileDef_R,@THotLogWriterhlFileDef_W,'hlFileDef');
    RegisterConstructor(@THotLogWriter.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THotLogParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THotLogParser) do begin
    RegisterMethod(@THotLogParser.Execute, 'Execute');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THLHeapMonMsg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THLHeapMonMsg) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THLErrMsg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THLErrMsg) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THLConstArrayMsg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THLConstArrayMsg) do
  begin
    RegisterPropertyHelper(@THLConstArrayMsgFConstArray_R,@THLConstArrayMsgFConstArray_W,'FConstArray');
    RegisterPropertyHelper(@THLConstArrayMsgFOutputStyle_R,@THLConstArrayMsgFOutputStyle_W,'FOutputStyle');
    RegisterConstructor(@THLConstArrayMsg.Create, 'Create');
    RegisterMethod(@THLConstArrayMsg.Post, 'Post');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THLStringMsg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THLStringMsg) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THLFileDef(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THLFileDef) do begin
    RegisterConstructor(@THLFileDef.create, 'create');
    RegisterPropertyHelper(@THLFileDefddname_R,@THLFileDefddname_W,'ddname');
    RegisterPropertyHelper(@THLFileDefpath_R,@THLFileDefpath_W,'path');
    RegisterPropertyHelper(@THLFileDefext_R,@THLFileDefext_W,'ext');
    RegisterPropertyHelper(@THLFileDeffileName_R,@THLFileDeffileName_W,'fileName');
    RegisterPropertyHelper(@THLFileDefappend_R,@THLFileDefappend_W,'append');
    RegisterPropertyHelper(@THLFileDefgdgMax_R,@THLFileDefgdgMax_W,'gdgMax');
    RegisterPropertyHelper(@THLFileDefOpMode_R,nil,'OpMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TQTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TQTimer) do begin
    RegisterPropertyHelper(@TQTimerfmtOutput_R,@TQTimerfmtOutput_W,'fmtOutput');
    //RegisterPropertyHelper(@TQTimertimeUnitsWanted_R,@TQTimertimeUnitsWanted_W,'timeUnitsWanted');
    RegisterPropertyHelper(@TQTimerremoveOverHead_R,@TQTimerremoveOverHead_W,'removeOverHead');
    RegisterPropertyHelper(@TQTimerdeltaShowNatives_R,@TQTimerdeltaShowNatives_W,'deltaShowNatives');
    RegisterPropertyHelper(@TQTimerdeltaShowOptimal_R,@TQTimerdeltaShowOptimal_W,'deltaShowOptimal');
    RegisterConstructor(@TQTimer.Create, 'Create');
    RegisterMethod(@TQTimer.Destroy, 'Free');
    RegisterMethod(@TQTimer.HMS, 'HMS');
    RegisterMethod(@TQTimer.GTC, 'GTC');
    RegisterMethod(@TQTimer.QPC, 'QPC');
    RegisterMethod(@TQTimer.RDT, 'RDT');
    RegisterMethod(@TQTimer.GlobalStop, 'GlobalStop');
    RegisterMethod(@TQTimer.Reset, 'Reset');
    RegisterPropertyHelper(@TQTimerisFinalized_R,nil,'isFinalized');
    RegisterPropertyHelper(@TQTimerRegistryFreq_R,nil,'RegistryFreq');
    RegisterPropertyHelper(@TQTimerQueryPerfFreq_R,nil,'QueryPerfFreq');
    RegisterPropertyHelper(@TQTimerReaDTSCOverhead_R,nil,'ReaDTSCOverhead');
    RegisterPropertyHelper(@TQTimerQueryPerfOverhead_R,nil,'QueryPerfOverhead');
    RegisterPropertyHelper(@TQTimerCount_R,nil,'Count');
    RegisterPropertyHelper(@TQTimeriStart_R,nil,'iStart');
    RegisterPropertyHelper(@TQTimeriStop_R,nil,'iStop');
    RegisterPropertyHelper(@TQTimeriDelta_R,nil,'iDelta');
    RegisterPropertyHelper(@TQTimersStart_R,nil,'sStart');
    RegisterPropertyHelper(@TQTimersStop_R,nil,'sStop');
    RegisterPropertyHelper(@TQTimersDelta_R,nil,'sDelta');
    RegisterPropertyHelper(@TQTimeriDeltaFmt_R,nil,'iDeltaFmt');
    RegisterPropertyHelper(@TQTimersDeltaFmt_R,nil,'sDeltaFmt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeapMonitor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeapMonitor) do
  begin
    RegisterConstructor(@THeapMonitor.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HotLog(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THeapMonitor(CL);
  RIRegister_TQTimer(CL);
  RIRegister_THLFileDef(CL);
  RIRegister_THLStringMsg(CL);
  RIRegister_THLConstArrayMsg(CL);
  RIRegister_THLErrMsg(CL);
  RIRegister_THLHeapMonMsg(CL);
  RIRegister_THotLogParser(CL);
  RIRegister_THotLogWriter(CL);
  RIRegister_THotLogVisual(CL);
  RIRegister_THotLog(CL);
end;

 
 
{ TPSImport_HotLog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HotLog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HotLog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HotLog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HotLog(ri);
  RIRegister_HotLog_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
