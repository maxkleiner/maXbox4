unit uPSI_xBase;
{
in line with the compeling maxutils to maxbase
  alias to socketx and threadX

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
  TPSImport_xBase = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TResetterThread(CL: TPSPascalCompiler);
procedure SIRegister_TStringColl(CL: TPSPascalCompiler);
procedure SIRegister_TSortedColl(CL: TPSPascalCompiler);
procedure SIRegister_TColl(CL: TPSPascalCompiler);
procedure SIRegister_TAdvCpObject(CL: TPSPascalCompiler);
procedure SIRegister_TAdvObject(CL: TPSPascalCompiler);
procedure SIRegister_TThreadX(CL: TPSPascalCompiler);
procedure SIRegister_TSocketX(CL: TPSPascalCompiler);
procedure SIRegister_TMimeCoder(CL: TPSPascalCompiler);
procedure SIRegister_xBase(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TResetterThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_xBase_Routines(S: TPSExec);
procedure RIRegister_TStringColl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSortedColl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TColl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAdvCpObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAdvObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TThreadX(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSocketX(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMimeCoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_xBase(CL: TPSRuntimeClassImporter);

//procedure Register;

implementation


uses
   Windows
  ,WinSock
  ,xBase
  ;


   type TThreadX = TThread;
   type TSocketX = TSocket;

procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_xBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TResetterThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TResetterThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TResetterThread') do begin
    RegisterProperty('TimeToSleep', 'DWORD', iptrw);
    RegisterProperty('oSleep', 'DWORD', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringColl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSortedColl', 'TStringColl') do
  with CL.AddClassN(CL.FindClass('TSortedColl'),'TStringColl') do
  begin
    RegisterMethod('Procedure Ins( const S : string)');
    RegisterMethod('Procedure Ins0( const S : string)');
    RegisterMethod('Procedure Add( const S : string)');
    RegisterMethod('Procedure AtIns( Index : Integer; const Item : string)');
    RegisterProperty('Strings', 'string Integer', iptrw);
    SetDefaultPropery('Strings');
    RegisterMethod('Function IdxOf( Item : string) : Integer');
    RegisterMethod('Procedure AppendTo( AColl : TStringColl)');
    RegisterMethod('Procedure Concat( AColl : TStringColl)');
    RegisterMethod('Procedure AddStrings( Strings : TStringColl; Sort : Boolean)');
    RegisterMethod('Procedure Fill( const AStrs : array of string)');
    RegisterMethod('Function Found( const Str : string) : Boolean');
    RegisterMethod('Function FoundU( const Str : string) : Boolean');
    RegisterMethod('Function FoundUC( const Str : string) : Boolean');
    RegisterMethod('Procedure FillEnum( Str : string; Delim : Char; Sorted : Boolean)');
    RegisterMethod('Function LongString : string');
    RegisterMethod('Function LongStringD( c : char) : string');
    RegisterMethod('Procedure SetTextStr( const Value : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSortedColl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TColl', 'TSortedColl') do
  with CL.AddClassN(CL.FindClass('TColl'),'TSortedColl') do
  begin
    RegisterProperty('Duplicates', 'Boolean', iptrw);
    RegisterMethod('Function Compare( Key1, Key2 : _Pointer) : Integer');
    RegisterMethod('Function KeyOf( Item : _Pointer) : _Pointer');
    RegisterMethod('Function Search( Key : _Pointer; var Index : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TColl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAdvCpObject', 'TColl') do
  with CL.AddClassN(CL.FindClass('TAdvCpObject'),'TColl') do
  begin
    //RegisterProperty('FList', 'PItemList', iptrw);
    RegisterMethod('Procedure CopyItemsTo( Coll : TColl)');
    RegisterMethod('Function CopyItem( AItem : _Pointer) : _Pointer');
    RegisterMethod('Procedure DoInit( ALimit, ADelta : Integer)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Function At( Index : Integer) : _Pointer');
    RegisterMethod('Procedure AtDelete( Index : Integer)');
    RegisterMethod('Procedure AtFree( Index : Integer)');
    RegisterMethod('Procedure AtInsert( Index : Integer; Item : _Pointer)');
    RegisterMethod('Procedure AtPut( Index : Integer; Item : _Pointer)');
    RegisterMethod('Procedure Delete( Item : _Pointer)');
    RegisterMethod('Procedure DeleteAll');
    RegisterMethod('Procedure FFree( Item : _Pointer)');
    RegisterMethod('Procedure FreeAll');
    RegisterMethod('Procedure FreeItem( Item : _Pointer)');
    RegisterMethod('Function IndexOf( Item : _Pointer) : Integer');
    RegisterMethod('Procedure Insert( Item : _Pointer)');
    RegisterMethod('Procedure Add( Item : _Pointer)');
    RegisterMethod('Procedure Pack');
    RegisterMethod('Procedure SetCapacity( NewCapacity : Integer)');
    RegisterMethod('Procedure MoveTo( CurIndex, NewIndex : Integer)');
    RegisterProperty('Items', '_Pointer Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('First', '_Pointer', iptrw);
    RegisterMethod('Procedure ForEach( Proc : TForEachProc)');
    RegisterMethod('Procedure Sort( Compare : TListSortCompare)');
    RegisterMethod('Procedure Concat( AColl : TColl)');
    RegisterMethod('Procedure Enter');
    RegisterMethod('Procedure Leave');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAdvCpObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAdvObject', 'TAdvCpObject') do
  with CL.AddClassN(CL.FindClass('TAdvObject'),'TAdvCpObject') do
  begin
    RegisterMethod('Function Copy : _Pointer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAdvObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAdvObject') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TAdvObject') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TThreadX(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TThreadX') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TThreadX') do begin
    RegisterMethod('Constructor Create( CreateSuspended : Boolean)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Resume');
    RegisterMethod('Procedure Suspend');
    RegisterMethod('Procedure Terminate');
    RegisterProperty('FreeOnTerminate', 'Boolean', iptrw);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('Priority', 'TThreadPriority', iptrw);
    RegisterProperty('Suspended', 'Boolean', iptrw);
    RegisterProperty('ThreadID', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSocketX(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSocketX') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSocketX') do begin
    RegisterProperty('Dead', 'Integer', iptrw);
    RegisterProperty('FPort', 'DWORD', iptrw);
    RegisterProperty('FAddr', 'DWORD', iptrw);
    RegisterProperty('Handle', 'DWORD', iptrw);
    RegisterProperty('Status', 'Integer', iptrw);
    RegisterProperty('Registered', 'Boolean', iptrw);
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure RegisterSelf');
    RegisterMethod('Procedure DeregisterSelf');
    RegisterMethod('Function Startup : Boolean');
    RegisterMethod('Function Handshake : Boolean');
    RegisterMethod('Function Read( var B, Size : DWORD) : DWORD');
    RegisterMethod('Function Write( const B, Size : DWORD) : DWORD');
    RegisterMethod('Function WriteStr( const s : string) : DWORD');
    RegisterMethod('Function _Write( const B, Size : DWORD) : DWORD');
    RegisterMethod('Function _Read( var B, Size : DWORD) : DWORD');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMimeCoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMimeCoder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMimeCoder') do begin
    RegisterProperty('Table', 'string', iptrw);
    RegisterProperty('MaxChars', 'Byte', iptrw);
    RegisterProperty('Pad', 'Char', iptrw);
    RegisterProperty('XChars', 'TByteTable', iptrw);
    RegisterMethod('Constructor Create( AType : TBase64Table)');
    RegisterMethod('Procedure InitTable');
    RegisterMethod('Function Encode( const Buf, N : byte) : string');
    RegisterMethod('Function EncodeBuf( const Buf, N : byte; var OutBuf) : Integer');
    RegisterMethod('Function EncodeStr( const S : String) : String');
    RegisterMethod('Function Decode( const S : String; var Buf) : Integer');
    RegisterMethod('Function DecodeBuf( const SrcBuf, SrcLen : Integer; var Buf) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xBase(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('_INADDR_ANY','LongWord').SetUInt($00000000);
 //CL.AddConstantN('DCX_EXCLUDERGN','LongWord').SetUInt( $40);
 CL.AddConstantN('INVALID_HANDLE_VALUE','LongInt').SetInt( DWORD ( - 1 ));
 CL.AddConstantN('INVALID_FILE_SIZE','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('INVALID_FILE_ATTRIBUTES','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('INVALID_FILE_TIME','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('INVALID_REGISTRY_KEY','LongWord').SetInt( DWORD ( - 1 ));
 CL.AddConstantN('INVALID_VALUE','LongWord').SetInt( DWORD ( - 1 ));
 CL.AddConstantN('SleepQuant','LongInt').SetInt( 1 * 60 * 1000);
 CL.AddConstantN('MMaxChars','LongInt').SetInt( 250);
  CL.AddTypeS('TBase64Table', '( bsBase64, bsUUE, bsXXE )');
  CL.AddTypeS('TWOHandleArray', 'array[0..64 - 1] of THandle;');
 CL.AddTypeS('TWOHandleArray2', 'array[0..MAXIMUM_WAIT_OBJECTS - 1] of THandle;');
 //type
  //TWOHandleArray = array[0..MAXIMUM_WAIT_OBJECTS - 1] of THandle;
  // MAXIMUM_WAIT_OBJECTS = 64;

  SIRegister_TMimeCoder(CL);
  CL.AddTypeS('TSocketOption', '( soBroadcast, soDebug, soDontLinger, soDontRou'
   +'te, soKeepAlive, soOOBInLine, soReuseAddr, soNoDelay, soBlocking, soAcceptConn )');
  CL.AddTypeS('TSocketOptions', 'set of TSocketOption');
  //CL.AddTypeS('TSocketClass', 'class of TSocket');
  SIRegister_TSocketX(CL);
  CL.AddTypeS('TObjProcX', 'Procedure');
  CL.AddTypeS('TForEachProc', 'Procedure ( P : _Pointer)');
  //CL.AddTypeS('PFileInfo', '^TFileInfo // will not work');
  CL.AddTypeS('TFileInfo', 'record Attr : DWORD; Size : DWORD; Time : DWORD; end');
  CL.AddTypeS('TuFindData', 'record Info : TFileInfo; FName : string; end');
  CL.AddTypeS('TCreateFileMode', '( cRead, cWrite, cFlag, cEnsureNew, cTruncate'
   +', cExisting, cShareAllowWrite, cShareDenyRead, cOverlapped, cRandomAccess, cSequentialScan, cDeleteOnClose )');
  CL.AddTypeS('TCreateFileModeSet', 'set of TCreateFileMode');
  //CL.AddTypeS('PCharSet', '^TCharSet // will not work');
  CL.AddTypeS('TCharSetX', 'set of Char');
  //CL.AddTypeS('PCharArray', '^TCharArray // will not work');
  //CL.AddTypeS('PByteArray', '^TByteArray // will not work');
  //CL.AddTypeS('PIntArray', '^TIntArray // will not work');
  //CL.AddTypeS('PDwordArray', '^TDwordArray // will not work');
  //CL.AddTypeS('PvIntArr', '^TvIntArr // will not work');
  //CL.AddTypeS('TvIntArr', 'record Arr : PIntArray; Cnt : Integer; end');
  //CL.AddTypeS('PBoolean', '^Boolean // will not work');
  //CL.AddTypeS('PItemList', '^TItemList // will not work');
  CL.AddTypeS('TThreadMethodX', 'Procedure');
  CL.AddTypeS('TThreadPriorityXX', '( tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest, tpTimeCritical )');
  SIRegister_TThreadX(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAdvObject');
  SIRegister_TAdvObject(CL);
  SIRegister_TAdvCpObject(CL);
  //CL.AddTypeS('TAdvClass', 'class of TAdvObject');
  //CL.AddTypeS('TCollClass', 'class of TColl');
  SIRegister_TColl(CL);
  SIRegister_TSortedColl(CL);
  SIRegister_TStringColl(CL);
 CL.AddDelphiFunction('Function AddRightSpaces( const S : string; NumSpaces : Integer) : string');
 CL.AddDelphiFunction('Procedure AddStr( var S : string; C : char)');
 CL.AddDelphiFunction('Procedure Add_Str( var S : ShortString; C : char)');
 CL.AddDelphiFunction('Function CompareStrX( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function CopyLeft( const S : string; I : Integer) : string');
 CL.AddDelphiFunction('Procedure DelDoubles( const St : string; var Source : string)');
 CL.AddDelphiFunction('Procedure DelFC( var s : string)');
 CL.AddDelphiFunction('Procedure DelLC( var s : string)');
 CL.AddDelphiFunction('Function DelLeft( const S : string) : string');
 CL.AddDelphiFunction('Function DelRight( const S : string) : string');
 CL.AddDelphiFunction('Function DelSpaces( const s : string) : string');
 CL.AddDelphiFunction('Procedure DeleteLeft( var S : string; I : Integer)');
 CL.AddDelphiFunction('Function DigitsOnly( const AStr : string) : Boolean');
 CL.AddDelphiFunction('Procedure DisposeStr( P : String)');
 CL.AddDelphiFunction('Function ExpandFileNameX( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFilePathX( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractDir( const S : string) : string');
 CL.AddDelphiFunction('Function ExtractFileRootX( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileExtX( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileNameX( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileDriveX( const FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileDirX( const FileName : string) : string');
 CL.AddDelphiFunction('Procedure FSplit( const FName : string; var Path, Name, Ext : string)');
 CL.AddDelphiFunction('Procedure FillCharSetX( const AStr : string; var CharSet : TCharSet)');
 CL.AddDelphiFunction('Function GetWrdStrictUC( var s, w : string) : Boolean');
 CL.AddDelphiFunction('Function GetWrdStrict( var s, w : string) : Boolean');
 CL.AddDelphiFunction('Function GetWrdD( var s, w : string) : Boolean');
 CL.AddDelphiFunction('Function GetWrdA( var s, w : string) : Boolean');
 CL.AddDelphiFunction('Function GetWrd( var s, w : string; c : char) : Boolean');
 CL.AddDelphiFunction('Function Hex2X( a : Byte) : string');
 CL.AddDelphiFunction('Function Hex4X( a : Word) : string');
 CL.AddDelphiFunction('Function Hex8X( a : DWORD) : string');
 CL.AddDelphiFunction('Function Int2Hex( a : Integer) : string');
 CL.AddDelphiFunction('Function Int2StrX( L : Integer) : string');
 CL.AddDelphiFunction('Function ItoS( I : Integer) : string');
 CL.AddDelphiFunction('Function ItoSz( I, Width : Integer) : string');
 CL.AddDelphiFunction('Function LastDelimiterX( const Delimiters, S : string) : Integer');
 CL.AddDelphiFunction('Function LowerCaseX( const S : string) : string');
 CL.AddDelphiFunction('Function MakeFullDir( const D, S : string) : string');
 CL.AddDelphiFunction('Function MakeNormName( const Path, Name : string) : string');
 CL.AddDelphiFunction('Function MonthE( m : Integer) : string');
 CL.AddDelphiFunction('Function NewStr( const S : string) : String');
 CL.AddDelphiFunction('Function ReplaceX( const Pattern, ReplaceString : string; var S : string) : Boolean');
 CL.AddDelphiFunction('Function StoI( const S : string) : Integer');
 CL.AddDelphiFunction('Function StrEnds( const S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function StrRightX( const S : string; Num : Integer) : string');
 CL.AddDelphiFunction('Function UpperCaseX( const S : string) : string');
 CL.AddDelphiFunction('Function WipeChars( const AStr, AWipeChars : string) : string');
 CL.AddDelphiFunction('Function _Val( const S : string; var V : Integer) : Boolean');
 CL.AddDelphiFunction('Function ProcessQuotes( var s : string) : Boolean');
 CL.AddDelphiFunction('Function UnpackPchars( var s : string) : Boolean');
 CL.AddDelphiFunction('Function UnpackUchars( var s : string) : Boolean');
 CL.AddDelphiFunction('Function __alpha( c : char) : Boolean');
 CL.AddDelphiFunction('Function __ctl( c : char) : Boolean');
 CL.AddDelphiFunction('Function __digit( c : char) : Boolean');
 CL.AddDelphiFunction('Function __extra( c : char) : Boolean');
 CL.AddDelphiFunction('Function __national( c : char) : Boolean');
 CL.AddDelphiFunction('Function __pchar( c : char) : Boolean');
 CL.AddDelphiFunction('Function __reserved( c : char) : Boolean');
 CL.AddDelphiFunction('Function __safe( c : char) : Boolean');
 CL.AddDelphiFunction('Function __uchar( c : char) : Boolean');
 CL.AddDelphiFunction('Function __unsafe( c : char) : Boolean');
 CL.AddDelphiFunction('Function Buf2Str( const Buffer: string) : string');
 //CL.AddDelphiFunction('Procedure Clear( var Buf, Count : Integer)');
 CL.AddDelphiFunction('Function CompareMem( P1, P2 : _Pointer; Length : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure FreeObjectX( var O: TObject)');
 CL.AddDelphiFunction('Procedure LowerPrec( var A, B : Integer; Bits : Byte)');
 CL.AddDelphiFunction('Function MemEqu( const A, B, Sz : Integer) : Boolean');
 CL.AddDelphiFunction('Function MaxIX( A, B : Integer) : Integer');
 CL.AddDelphiFunction('Function MinIX( A, B : Integer) : Integer');
 CL.AddDelphiFunction('Function MaxDX( A, B : DWORD) : DWORD');
 CL.AddDelphiFunction('Function MinDX( A, B : DWORD) : DWORD');
 CL.AddDelphiFunction('Function NulSearch( const Buffer: string) : Integer');
 CL.AddDelphiFunction('Function NumBits( I : Integer) : Integer');
 //CL.AddDelphiFunction('Procedure XAdd( var Critical, Normal)');
 //CL.AddDelphiFunction('Procedure XChg( var Critical, Normal)');
 CL.AddDelphiFunction('Function CreateEvtA : DWORD');
 CL.AddDelphiFunction('Function CreateEvt( Initial : Boolean) : DWORD');
 CL.AddDelphiFunction('Function SignaledEvt( id : DWORD) : Boolean');
 CL.AddDelphiFunction('Function WaitEvt( const id : TWOHandleArray; Timeout : DWORD) : DWORD');
 //CL.AddDelphiFunction('Function WaitEvtA( nCount : Integer; lpHandles : PWOHandleArray; Timeout : DWORD) : DWORD');
 CL.AddDelphiFunction('Function ClearHandle( var Handle : THandle) : Boolean');
 CL.AddDelphiFunction('Procedure CloseHandles( const Handles : array of DWORD)');
 CL.AddDelphiFunction('Function FileExistsX( const FName : string) : Boolean');
 CL.AddDelphiFunction('Function FindExecutableX( FileName, Directory : PChar; Result : PChar) : HINST');
 CL.AddDelphiFunction('Function GetEnvVariable( const Name : string) : string');
 CL.AddDelphiFunction('Function GetFileNfo( const FName : string; var Info : TFileInfo; NeedAttr : Boolean) : Boolean');
 CL.AddDelphiFunction('Function GetFileNfoByHandle( Handle : DWORD; var Info : TFileInfo) : Boolean');
 CL.AddDelphiFunction('Function ZeroHandle( var Handle : THandle) : Boolean');
 CL.AddDelphiFunction('Function _CreateFile( const FName : string; Mode : TCreateFileModeSet) : DWORD');
 CL.AddDelphiFunction('Function _CreateFileSecurity( const FName : string; Mode : TCreateFileModeSet; lpSecurityAttributes : PSecurityAttributes) : DWORD');
 CL.AddDelphiFunction('Function _GetFileSize( const FName : string) : DWORD');
 CL.AddDelphiFunction('Function _MatchMaskBody( AName, AMask : string; SupportPercent : Boolean) : Boolean');
 CL.AddDelphiFunction('Function _MatchMask( const AName : string; AMask : string; SupportPercent : Boolean) : Boolean');
 CL.AddDelphiFunction('Function MatchMask( const AName, AMask : string) : Boolean');
 CL.AddDelphiFunction('Function SysErrorMsg( ErrorCode : DWORD) : string');
 CL.AddDelphiFunction('Function CreateRegKeyX( const AFName : string) : HKey');
 CL.AddDelphiFunction('Function OpenRegKeyEx( const AName : string; AMode : DWORD) : HKey');
 CL.AddDelphiFunction('Function OpenRegKey( const AName : string) : DWORD');
 CL.AddDelphiFunction('Function ReadRegBin( Key : DWORD; const rvn : string; Bin : _Pointer; Sz : DWORD) : Boolean');
 CL.AddDelphiFunction('Function ReadRegInt( Key : DWORD; const AStrName : string) : DWORD');
 CL.AddDelphiFunction('Function ReadRegString( Key : DWORD; const AStrName : string) : string');
 CL.AddDelphiFunction('Function WriteRegBin( Key : DWORD; const rvn : string; Bin : _Pointer; Sz : DWORD) : Boolean');
 CL.AddDelphiFunction('Function WriteRegInt( Key : DWORD; const AStrName : string; AValue : DWORD) : Boolean');
 CL.AddDelphiFunction('Function WriteRegString( Key : DWORD; const AStrName, AStr : string) : Boolean');
 CL.AddDelphiFunction('Function AddrInet( i : DWORD) : string');
 CL.AddDelphiFunction('Function GetHostNameByAddr( Addr : DWORD) : string');
 CL.AddDelphiFunction('Function Inet2addr( const s : string) : DWORD');
 CL.AddDelphiFunction('Function InetAddr( const s : string) : DWORD');
 CL.AddDelphiFunction('Procedure GlobalFail');
 CL.AddDelphiFunction('Function _LogOK( const Name : string; var Handle : DWORD) : Boolean');
 CL.AddDelphiFunction('Procedure xBaseDone');
 CL.AddDelphiFunction('Procedure xBaseInit');
 CL.AddDelphiFunction('Procedure uCvtSetFileTime( T : DWORD; var L, H : DWORD)');
 CL.AddDelphiFunction('Function uCvtGetFileTime( L, H : DWORD) : DWORD');
 CL.AddDelphiFunction('Function uGetSystemTime : DWORD');
 CL.AddDelphiFunction('Function VlX( const s : string) : DWORD');
 CL.AddDelphiFunction('Function VlHX( const s : string) : DWORD');
 CL.AddDelphiFunction('Function StrAsg( const Src : string) : string');
  SIRegister_TResetterThread(CL);
 CL.AddConstantN('CServerVersion','String').SetString( '1.93');
 CL.AddConstantN('CServerProductName','String').SetString( 'TinyWeb');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TResetterThreadoSleep_W(Self: TResetterThread; const T: DWORD);
Begin Self.oSleep := T; end;

(*----------------------------------------------------------------------------*)
procedure TResetterThreadoSleep_R(Self: TResetterThread; var T: DWORD);
Begin T := Self.oSleep; end;

(*----------------------------------------------------------------------------*)
procedure TResetterThreadTimeToSleep_W(Self: TResetterThread; const T: DWORD);
Begin Self.TimeToSleep := T; end;

(*----------------------------------------------------------------------------*)
procedure TResetterThreadTimeToSleep_R(Self: TResetterThread; var T: DWORD);
Begin T := Self.TimeToSleep; end;

(*----------------------------------------------------------------------------*)
procedure TStringCollStrings_W(Self: TStringColl; const T: string; const t1: Integer);
begin Self.Strings[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringCollStrings_R(Self: TStringColl; var T: string; const t1: Integer);
begin T := Self.Strings[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSortedCollDuplicates_W(Self: TSortedColl; const T: Boolean);
Begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortedCollDuplicates_R(Self: TSortedColl; var T: Boolean);
Begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
procedure TCollFirst_W(Self: TColl; const T: Pointer);
begin Self.First := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollFirst_R(Self: TColl; var T: Pointer);
begin T := Self.First; end;

(*----------------------------------------------------------------------------*)
procedure TCollCount_R(Self: TColl; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TCollItems_W(Self: TColl; const T: Pointer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollItems_R(Self: TColl; var T: Pointer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCollFList_W(Self: TColl; const T: PItemList);
Begin Self.FList := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollFList_R(Self: TColl; var T: PItemList);
Begin T := Self.FList; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXThreadID_R(Self: TThreadX; var T: THandle);
begin T := Self.ThreadID; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXSuspended_W(Self: TThreadX; const T: Boolean);
begin Self.Suspended := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXSuspended_R(Self: TThreadX; var T: Boolean);
begin T := Self.Suspended; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXPriority_W(Self: TThreadX; const T: TThreadPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXPriority_R(Self: TThreadX; var T: TThreadPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXHandle_R(Self: TThreadX; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXFreeOnTerminate_W(Self: TThreadX; const T: Boolean);
begin Self.FreeOnTerminate := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadXFreeOnTerminate_R(Self: TThreadX; var T: Boolean);
begin T := Self.FreeOnTerminate; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXRegistered_W(Self: TSocketX; const T: Boolean);
Begin Self.Registered := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXRegistered_R(Self: TSocketX; var T: Boolean);
Begin T := Self.Registered; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXStatus_W(Self: TSocketX; const T: Integer);
Begin Self.Status := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXStatus_R(Self: TSocketX; var T: Integer);
Begin T := Self.Status; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXHandle_W(Self: TSocketX; const T: DWORD);
Begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXHandle_R(Self: TSocketX; var T: DWORD);
Begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXFAddr_W(Self: TSocketX; const T: DWORD);
Begin Self.FAddr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXFAddr_R(Self: TSocketX; var T: DWORD);
Begin T := Self.FAddr; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXFPort_W(Self: TSocketX; const T: DWORD);
Begin Self.FPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXFPort_R(Self: TSocketX; var T: DWORD);
Begin T := Self.FPort; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXDead_W(Self: TSocketX; const T: Integer);
Begin Self.Dead := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocketXDead_R(Self: TSocketX; var T: Integer);
Begin T := Self.Dead; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderXChars_W(Self: TMimeCoder; const T: TByteTable);
Begin Self.XChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderXChars_R(Self: TMimeCoder; var T: TByteTable);
Begin T := Self.XChars; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderPad_W(Self: TMimeCoder; const T: Char);
Begin Self.Pad := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderPad_R(Self: TMimeCoder; var T: Char);
Begin T := Self.Pad; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderMaxChars_W(Self: TMimeCoder; const T: Byte);
Begin Self.MaxChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderMaxChars_R(Self: TMimeCoder; var T: Byte);
Begin T := Self.MaxChars; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderTable_W(Self: TMimeCoder; const T: string);
Begin Self.Table := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeCoderTable_R(Self: TMimeCoder; var T: string);
Begin T := Self.Table; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TResetterThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResetterThread) do begin
    RegisterPropertyHelper(@TResetterThreadTimeToSleep_R,@TResetterThreadTimeToSleep_W,'TimeToSleep');
    RegisterPropertyHelper(@TResetterThreadoSleep_R,@TResetterThreadoSleep_W,'oSleep');
    RegisterConstructor(@TResetterThread.Create, 'Create');
      RegisterMethod(@TResetterThread.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xBase_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AddRightSpaces, 'AddRightSpaces', cdRegister);
 S.RegisterDelphiFunction(@AddStr, 'AddStr', cdRegister);
 S.RegisterDelphiFunction(@Add_Str, 'Add_Str', cdRegister);
 S.RegisterDelphiFunction(@CompareStr, 'CompareStrX', cdRegister);
 S.RegisterDelphiFunction(@CopyLeft, 'CopyLeft', cdRegister);
 S.RegisterDelphiFunction(@DelDoubles, 'DelDoubles', cdRegister);
 S.RegisterDelphiFunction(@DelFC, 'DelFC', cdRegister);
 S.RegisterDelphiFunction(@DelLC, 'DelLC', cdRegister);
 S.RegisterDelphiFunction(@DelLeft, 'DelLeft', cdRegister);
 S.RegisterDelphiFunction(@DelRight, 'DelRight', cdRegister);
 S.RegisterDelphiFunction(@DelSpaces, 'DelSpaces', cdRegister);
 S.RegisterDelphiFunction(@DeleteLeft, 'DeleteLeft', cdRegister);
 S.RegisterDelphiFunction(@DigitsOnly, 'DigitsOnly', cdRegister);
 S.RegisterDelphiFunction(@DisposeStr, 'DisposeStr', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName, 'ExpandFileNameX', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath, 'ExtractFilePathX', cdRegister);
 S.RegisterDelphiFunction(@ExtractDir, 'ExtractDir', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileRoot, 'ExtractFileRootX', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExt, 'ExtractFileExtX', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileName, 'ExtractFileNameX', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDrive, 'ExtractFileDriveX', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDir, 'ExtractFileDirX', cdRegister);
 S.RegisterDelphiFunction(@FSplit, 'FSplit', cdRegister);
 S.RegisterDelphiFunction(@FillCharSet, 'FillCharSetX', cdRegister);
 S.RegisterDelphiFunction(@GetWrdStrictUC, 'GetWrdStrictUC', cdRegister);
 S.RegisterDelphiFunction(@GetWrdStrict, 'GetWrdStrict', cdRegister);
 S.RegisterDelphiFunction(@GetWrdD, 'GetWrdD', cdRegister);
 S.RegisterDelphiFunction(@GetWrdA, 'GetWrdA', cdRegister);
 S.RegisterDelphiFunction(@GetWrd, 'GetWrd', cdRegister);
 S.RegisterDelphiFunction(@Hex2, 'Hex2X', cdRegister);
 S.RegisterDelphiFunction(@Hex4, 'Hex4X', cdRegister);
 S.RegisterDelphiFunction(@Hex8, 'Hex8X', cdRegister);
 S.RegisterDelphiFunction(@Int2Hex, 'Int2Hex', cdRegister);
 S.RegisterDelphiFunction(@Int2Str, 'Int2StrX', cdRegister);
 S.RegisterDelphiFunction(@ItoS, 'ItoS', cdRegister);
 S.RegisterDelphiFunction(@ItoSz, 'ItoSz', cdRegister);
 S.RegisterDelphiFunction(@LastDelimiter, 'LastDelimiterx', cdRegister);
 S.RegisterDelphiFunction(@LowerCase, 'LowerCasex', cdRegister);
 S.RegisterDelphiFunction(@MakeFullDir, 'MakeFullDir', cdRegister);
 S.RegisterDelphiFunction(@MakeNormName, 'MakeNormName', cdRegister);
 S.RegisterDelphiFunction(@MonthE, 'MonthE', cdRegister);
 S.RegisterDelphiFunction(@NewStr, 'NewStr', cdRegister);
 S.RegisterDelphiFunction(@Replace, 'ReplaceX', cdRegister);
 S.RegisterDelphiFunction(@StoI, 'StoI', cdRegister);
 S.RegisterDelphiFunction(@StrEnds, 'StrEnds', cdRegister);
 S.RegisterDelphiFunction(@StrRight, 'StrRightX', cdRegister);
 S.RegisterDelphiFunction(@UpperCase, 'UpperCaseX', cdRegister);
 S.RegisterDelphiFunction(@WipeChars, 'WipeChars', cdRegister);
 S.RegisterDelphiFunction(@_Val, '_Val', cdRegister);
 S.RegisterDelphiFunction(@ProcessQuotes, 'ProcessQuotes', cdRegister);
 S.RegisterDelphiFunction(@UnpackPchars, 'UnpackPchars', cdRegister);
 S.RegisterDelphiFunction(@UnpackUchars, 'UnpackUchars', cdRegister);
 S.RegisterDelphiFunction(@__alpha, '__alpha', cdRegister);
 S.RegisterDelphiFunction(@__ctl, '__ctl', cdRegister);
 S.RegisterDelphiFunction(@__digit, '__digit', cdRegister);
 S.RegisterDelphiFunction(@__extra, '__extra', cdRegister);
 S.RegisterDelphiFunction(@__national, '__national', cdRegister);
 S.RegisterDelphiFunction(@__pchar, '__pchar', cdRegister);
 S.RegisterDelphiFunction(@__reserved, '__reserved', cdRegister);
 S.RegisterDelphiFunction(@__safe, '__safe', cdRegister);
 S.RegisterDelphiFunction(@__uchar, '__uchar', cdRegister);
 S.RegisterDelphiFunction(@__unsafe, '__unsafe', cdRegister);
 S.RegisterDelphiFunction(@Buf2Str, 'Buf2Str', cdRegister);
// S.RegisterDelphiFunction(@Clear, 'Clear', cdRegister);
 S.RegisterDelphiFunction(@CompareMem, 'CompareMem', cdRegister);
 S.RegisterDelphiFunction(@FreeObject, 'FreeObjectX', cdRegister);
 S.RegisterDelphiFunction(@LowerPrec, 'LowerPrec', cdRegister);
 S.RegisterDelphiFunction(@MemEqu, 'MemEqu', cdRegister);
 S.RegisterDelphiFunction(@MaxI, 'MaxIX', cdRegister);
 S.RegisterDelphiFunction(@MinI, 'MinIX', cdRegister);
 S.RegisterDelphiFunction(@MaxD, 'MaxDX', cdRegister);
 S.RegisterDelphiFunction(@MinD, 'MinDX', cdRegister);
 S.RegisterDelphiFunction(@NulSearch, 'NulSearch', cdRegister);
 S.RegisterDelphiFunction(@NumBits, 'NumBits', cdRegister);
 S.RegisterDelphiFunction(@XAdd, 'XAdd', cdRegister);
 S.RegisterDelphiFunction(@XChg, 'XChg', cdRegister);
 S.RegisterDelphiFunction(@CreateEvtA, 'CreateEvtA', cdRegister);
 S.RegisterDelphiFunction(@CreateEvt, 'CreateEvt', cdRegister);
 S.RegisterDelphiFunction(@SignaledEvt, 'SignaledEvt', cdRegister);
 S.RegisterDelphiFunction(@WaitEvt, 'WaitEvt', cdRegister);
 S.RegisterDelphiFunction(@WaitEvtA, 'WaitEvtA', cdRegister);
 S.RegisterDelphiFunction(@ClearHandle, 'ClearHandle', cdRegister);
 S.RegisterDelphiFunction(@CloseHandles, 'CloseHandles', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExistsX', cdRegister);
 S.RegisterDelphiFunction(@FindExecutable, 'FindExecutableX', CdStdCall);
 S.RegisterDelphiFunction(@GetEnvVariable, 'GetEnvVariable', cdRegister);
 S.RegisterDelphiFunction(@GetFileNfo, 'GetFileNfo', cdRegister);
 S.RegisterDelphiFunction(@GetFileNfoByHandle, 'GetFileNfoByHandle', cdRegister);
 S.RegisterDelphiFunction(@ZeroHandle, 'ZeroHandle', cdRegister);
 S.RegisterDelphiFunction(@_CreateFile, '_CreateFile', cdRegister);
 S.RegisterDelphiFunction(@_CreateFileSecurity, '_CreateFileSecurity', cdRegister);
 S.RegisterDelphiFunction(@_GetFileSize, '_GetFileSize', cdRegister);
 S.RegisterDelphiFunction(@_MatchMaskBody, '_MatchMaskBody', cdRegister);
 S.RegisterDelphiFunction(@_MatchMask, '_MatchMask', cdRegister);
 S.RegisterDelphiFunction(@MatchMask, 'MatchMask', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMsg, 'SysErrorMsg', cdRegister);
 S.RegisterDelphiFunction(@CreateRegKey, 'CreateRegKeyX', cdRegister);
 S.RegisterDelphiFunction(@OpenRegKeyEx, 'OpenRegKeyEx', cdRegister);
 S.RegisterDelphiFunction(@OpenRegKey, 'OpenRegKey', cdRegister);
 S.RegisterDelphiFunction(@ReadRegBin, 'ReadRegBin', cdRegister);
 S.RegisterDelphiFunction(@ReadRegInt, 'ReadRegInt', cdRegister);
 S.RegisterDelphiFunction(@ReadRegString, 'ReadRegString', cdRegister);
 S.RegisterDelphiFunction(@WriteRegBin, 'WriteRegBin', cdRegister);
 S.RegisterDelphiFunction(@WriteRegInt, 'WriteRegInt', cdRegister);
 S.RegisterDelphiFunction(@WriteRegString, 'WriteRegString', cdRegister);
 S.RegisterDelphiFunction(@AddrInet, 'AddrInet', cdRegister);
 S.RegisterDelphiFunction(@GetHostNameByAddr, 'GetHostNameByAddr', cdRegister);
 S.RegisterDelphiFunction(@Inet2addr, 'Inet2addr', cdRegister);
 S.RegisterDelphiFunction(@InetAddr, 'InetAddr', cdRegister);
 S.RegisterDelphiFunction(@GlobalFail, 'GlobalFail', cdRegister);
 S.RegisterDelphiFunction(@_LogOK, '_LogOK', cdRegister);
 S.RegisterDelphiFunction(@xBaseDone, 'xBaseDone', cdRegister);
 S.RegisterDelphiFunction(@xBaseInit, 'xBaseInit', cdRegister);
 S.RegisterDelphiFunction(@uCvtSetFileTime, 'uCvtSetFileTime', cdRegister);
 S.RegisterDelphiFunction(@uCvtGetFileTime, 'uCvtGetFileTime', cdRegister);
 S.RegisterDelphiFunction(@uGetSystemTime, 'uGetSystemTime', cdRegister);
 S.RegisterDelphiFunction(@Vl, 'VlX', cdRegister);
 S.RegisterDelphiFunction(@VlH, 'VlHX', cdRegister);
 S.RegisterDelphiFunction(@StrAsg, 'StrAsg', cdRegister);
  //RIRegister_TResetterThread(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringColl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringColl) do
  begin
    RegisterMethod(@TStringColl.Ins, 'Ins');
    RegisterMethod(@TStringColl.Ins0, 'Ins0');
    RegisterMethod(@TStringColl.Add, 'Add');
    RegisterMethod(@TStringColl.AtIns, 'AtIns');
    RegisterPropertyHelper(@TStringCollStrings_R,@TStringCollStrings_W,'Strings');
    RegisterMethod(@TStringColl.IdxOf, 'IdxOf');
    RegisterMethod(@TStringColl.AppendTo, 'AppendTo');
    RegisterMethod(@TStringColl.Concat, 'Concat');
    RegisterMethod(@TStringColl.AddStrings, 'AddStrings');
    RegisterMethod(@TStringColl.Fill, 'Fill');
    RegisterMethod(@TStringColl.Found, 'Found');
    RegisterMethod(@TStringColl.FoundU, 'FoundU');
    RegisterMethod(@TStringColl.FoundUC, 'FoundUC');
    RegisterMethod(@TStringColl.FillEnum, 'FillEnum');
    RegisterMethod(@TStringColl.LongString, 'LongString');
    RegisterMethod(@TStringColl.LongStringD, 'LongStringD');
    RegisterMethod(@TStringColl.SetTextStr, 'SetTextStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSortedColl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSortedColl) do
  begin
    RegisterPropertyHelper(@TSortedCollDuplicates_R,@TSortedCollDuplicates_W,'Duplicates');
    //RegisterVirtualAbstractMethod(@TSortedColl, @!.Compare, 'Compare');
    RegisterVirtualMethod(@TSortedColl.KeyOf, 'KeyOf');
    RegisterVirtualMethod(@TSortedColl.Search, 'Search');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColl) do begin
    RegisterPropertyHelper(@TCollFList_R,@TCollFList_W,'FList');
    RegisterMethod(@TColl.CopyItemsTo, 'CopyItemsTo');
    RegisterVirtualMethod(@TColl.CopyItem, 'CopyItem');
    RegisterMethod(@TColl.DoInit, 'DoInit');
    RegisterConstructor(@TColl.Create, 'Create');
        RegisterMethod(@TColl.Destroy, 'Free');
      RegisterMethod(@TColl.At, 'At');
    RegisterMethod(@TColl.AtDelete, 'AtDelete');
    RegisterMethod(@TColl.AtFree, 'AtFree');
    RegisterMethod(@TColl.AtInsert, 'AtInsert');
    RegisterMethod(@TColl.AtPut, 'AtPut');
    RegisterMethod(@TColl.Delete, 'Delete');
    RegisterMethod(@TColl.DeleteAll, 'DeleteAll');
    RegisterMethod(@TColl.FFree, 'FFree');
    RegisterMethod(@TColl.FreeAll, 'FreeAll');
    RegisterVirtualMethod(@TColl.FreeItem, 'FreeItem');
    RegisterVirtualMethod(@TColl.IndexOf, 'IndexOf');
    RegisterVirtualMethod(@TColl.Insert, 'Insert');
    RegisterMethod(@TColl.Add, 'Add');
    RegisterMethod(@TColl.Pack, 'Pack');
    RegisterMethod(@TColl.SetCapacity, 'SetCapacity');
    RegisterMethod(@TColl.MoveTo, 'MoveTo');
    RegisterPropertyHelper(@TCollItems_R,@TCollItems_W,'Items');
    RegisterPropertyHelper(@TCollCount_R,nil,'Count');
    RegisterPropertyHelper(@TCollFirst_R,@TCollFirst_W,'First');
    RegisterVirtualMethod(@TColl.ForEach, 'ForEach');
    RegisterMethod(@TColl.Sort, 'Sort');
    RegisterMethod(@TColl.Concat, 'Concat');
    RegisterMethod(@TColl.Enter, 'Enter');
    RegisterMethod(@TColl.Leave, 'Leave');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAdvCpObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAdvCpObject) do
  begin
    //RegisterVirtualAbstractMethod(@TAdvCpObject, @!.Copy, 'Copy');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAdvObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAdvObject) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TThreadX(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThreadX) do begin
    RegisterConstructor(@TThreadX.Create, 'Create');
      RegisterMethod(@TThreadX.Destroy, 'Free');
      RegisterMethod(@TThreadX.Resume, 'Resume');
    RegisterMethod(@TThreadX.Suspend, 'Suspend');
    RegisterMethod(@TThreadX.Terminate, 'Terminate');
    RegisterPropertyHelper(@TThreadXFreeOnTerminate_R,@TThreadXFreeOnTerminate_W,'FreeOnTerminate');
    RegisterPropertyHelper(@TThreadXHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TThreadXPriority_R,@TThreadXPriority_W,'Priority');
    RegisterPropertyHelper(@TThreadXSuspended_R,@TThreadXSuspended_W,'Suspended');
    RegisterPropertyHelper(@TThreadXThreadID_R,nil,'ThreadID');
  end;
   RIRegister_TResetterThread(CL);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSocketX(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSocketX) do begin
    RegisterPropertyHelper(@TSocketXDead_R,@TSocketXDead_W,'Dead');
    RegisterPropertyHelper(@TSocketXFPort_R,@TSocketXFPort_W,'FPort');
    RegisterPropertyHelper(@TSocketXFAddr_R,@TSocketXFAddr_W,'FAddr');
    RegisterPropertyHelper(@TSocketXHandle_R,@TSocketXHandle_W,'Handle');
    RegisterPropertyHelper(@TSocketXStatus_R,@TSocketXStatus_W,'Status');
    RegisterPropertyHelper(@TSocketXRegistered_R,@TSocketXRegistered_W,'Registered');
      RegisterMethod(@TSocketX.Destroy, 'Free');

    RegisterMethod(@TSocketX.RegisterSelf, 'RegisterSelf');
    RegisterMethod(@TSocketX.DeregisterSelf, 'DeregisterSelf');
    RegisterVirtualMethod(@TSocketX.Startup, 'Startup');
    RegisterVirtualMethod(@TSocketX.Handshake, 'Handshake');
    RegisterMethod(@TSocketX.Read, 'Read');
    RegisterMethod(@TSocketX.Write, 'Write');
    RegisterMethod(@TSocketX.WriteStr, 'WriteStr');
    RegisterVirtualMethod(@TSocketX._Write, '_Write');
    RegisterVirtualMethod(@TSocketX._Read, '_Read');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMimeCoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMimeCoder) do
  begin
    RegisterPropertyHelper(@TMimeCoderTable_R,@TMimeCoderTable_W,'Table');
    RegisterPropertyHelper(@TMimeCoderMaxChars_R,@TMimeCoderMaxChars_W,'MaxChars');
    RegisterPropertyHelper(@TMimeCoderPad_R,@TMimeCoderPad_W,'Pad');
    RegisterPropertyHelper(@TMimeCoderXChars_R,@TMimeCoderXChars_W,'XChars');
    RegisterConstructor(@TMimeCoder.Create, 'Create');
    RegisterMethod(@TMimeCoder.InitTable, 'InitTable');
    RegisterMethod(@TMimeCoder.Encode, 'Encode');
    RegisterMethod(@TMimeCoder.EncodeBuf, 'EncodeBuf');
    RegisterMethod(@TMimeCoder.EncodeStr, 'EncodeStr');
    RegisterMethod(@TMimeCoder.Decode, 'Decode');
    RegisterMethod(@TMimeCoder.DecodeBuf, 'DecodeBuf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xBase(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMimeCoder(CL);
  RIRegister_TSocketX(CL);
  RIRegister_TThreadX(CL);
  with CL.Add(TAdvObject) do
  RIRegister_TAdvObject(CL);
  RIRegister_TAdvCpObject(CL);
  RIRegister_TColl(CL);
  RIRegister_TSortedColl(CL);
  RIRegister_TStringColl(CL);
end;

 
 
{ TPSImport_xBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xBase(ri);
  RIRegister_xBase_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
