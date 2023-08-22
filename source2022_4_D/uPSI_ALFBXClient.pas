unit uPSI_ALFBXClient;
{
   direct to firebird with fcnSQL
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
  TPSImport_ALFBXClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALFBXEventThread(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXConnectionPoolClient(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXStringKeyPoolBinTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXReadStatementPoolContainer(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXReadTransactionPoolContainer(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXConnectionWithoutStmtPoolContainer(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXConnectionWithStmtPoolContainer(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXConnectionStatementPoolBinTree(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXConnectionStatementPoolBinTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXClient(CL: TPSPascalCompiler);
procedure SIRegister_ALFBXClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALFBXEventThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXConnectionPoolClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXStringKeyPoolBinTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXReadStatementPoolContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXReadTransactionPoolContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXConnectionWithoutStmtPoolContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXConnectionWithStmtPoolContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXConnectionStatementPoolBinTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXConnectionStatementPoolBinTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALFBXClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Contnrs
  ,SyncObjs
  ,AlXmlDoc
  ,ALAVLBinaryTree
  ,ALFBXLib
  ,ALFBXBase
  ,AlFcnMisc
  ,ALStringList
  ,ALFBXClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFBXClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXEventThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TALFBXEventThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TALFBXEventThread') do begin
    RegisterMethod('Constructor Create( aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aEventNames : AnsiString; aApiVer : TALFBXVersion_API; const alib : AnsiString; const aConnectionMaxIdleTime : integer;'+
    ' const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString);');
    RegisterMethod('Constructor Create1( aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aEventNames : AnsiString; alib : TALFBXLibrary; const aConnectionMaxIdleTime : integer; const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString);');
    RegisterProperty('Signal', 'Thandle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXConnectionPoolClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALFBXConnectionPoolClient') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALFBXConnectionPoolClient') do begin
    RegisterMethod('Constructor Create( aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aApiVer : TALFBXVersion_API; const alib : AnsiString; const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString);');
    RegisterMethod('Constructor Create1( aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; alib : TALFBXLibrary; const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString);');
        RegisterMethod('Procedure Free');
       RegisterMethod('Procedure ReleaseAllConnections( const WaitWorkingConnections : Boolean)');
    RegisterMethod('Procedure GetMonitoringInfos( ConnectionID, TransactionID : int64; StatementSQL : AnsiString; var IOStats : TALFBXClientMonitoringIOStats; var RecordStats : TALFBXClientMonitoringRecordStats; var MemoryUsage : TALFBXClientMonitoringMemoryUsage;'+
    ' const SkipIOStats : Boolean; const SkipRecordStats : Boolean; const SkipMemoryUsage : Boolean)');
    RegisterMethod('Function GetConnectionID( DBHandle : IscDbHandle) : Integer');
    RegisterMethod('Function GetTransactionID( TraHandle : IscTrHandle) : Cardinal');
    RegisterMethod('Function GetDataBaseInfoInt( const item : Integer; const DBHandle : IscDbHandle) : Integer');
    RegisterMethod('Function GetDataBaseInfoString( const item : Integer; const DBHandle : IscDbHandle) : AnsiString');
    RegisterMethod('Function GetDataBaseInfoDateTime( const item : Integer; const DBHandle : IscDbHandle) : TDateTime');
    RegisterMethod('Procedure TransactionStart( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var StatementPool : TALFBXConnectionStatementPoolBinTree; TPB : AnsiString);');
    RegisterMethod('Procedure TransactionCommit( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var StatementPool : TALFBXConnectionStatementPoolBinTree; const CloseConnection : Boolean);');
    RegisterMethod('Procedure TransactionRollback( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var StatementPool : TALFBXConnectionStatementPoolBinTree; const CloseConnection : Boolean);');
    RegisterMethod('Procedure TransactionStart1( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; TPB : AnsiString);');
    RegisterMethod('Procedure TransactionCommit1( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; const CloseConnection : Boolean);');
    RegisterMethod('Procedure TransactionRollback1( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; const CloseConnection : Boolean);');
    RegisterMethod('Procedure TransactionCommitRetaining( TraHandle : IscTrHandle)');
    RegisterMethod('Procedure TransactionRollbackRetaining( TraHandle : IscTrHandle)');
    RegisterMethod('Function Prepare( SQL : AnsiString; var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var StmtHandle : IscStmtHandle; var Sqlda : TALFBXSQLResult; const TPB : AnsiString) : TALFBXStatementType');
    RegisterMethod('Procedure SelectData( SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle;'+
    ' const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData1( SQL : TALFBXClientSelectDataSQL; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool :'+
    ' TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData2( SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; '+
    'const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData3( SQL : AnsiString; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool :'+
    ' TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData4( SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree;'+
    ' const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData5( SQL : TALFBXClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree;'+
    ' const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData6( SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool :'+
    ' TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData7( SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree;'+
    ' const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData8( SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData9( SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle;'+
    ' const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData10( SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool :'+
    ' TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure SelectData11( SQL : AnsiString; Params : array of AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool :'+
    ' TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure UpdateData( SQLs : TALFBXClientUpdateDataSQLs; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure UpdateData1( SQL : TALFBXClientUpdateDataSQL; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure UpdateData2( SQLs : TALStrings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure UpdateData3( SQL : AnsiString; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure UpdateData4( SQL : AnsiString; Params : array of AnsiString; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Procedure UpdateData5( SQLs : array of AnsiString; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);');
    RegisterMethod('Function ConnectionCount : Integer');
    RegisterMethod('Function WorkingConnectionCount : Integer');
    RegisterProperty('SqlDialect', 'word', iptrw);
    RegisterProperty('DataBaseName', 'AnsiString', iptrw);
    RegisterProperty('Login', 'AnsiString', iptrw);
    RegisterProperty('Password', 'AnsiString', iptrw);
    RegisterProperty('ConnectionMaxIdleTime', 'integer', iptrw);
    RegisterProperty('TransactionMaxIdleTime', 'integer', iptrw);
    RegisterProperty('StatementMaxIdleTime', 'integer', iptrw);
    RegisterProperty('NullString', 'AnsiString', iptrw);
    RegisterProperty('Lib', 'TALFBXLibrary', iptrw);
    RegisterProperty('CharSet', 'TALFBXCharacterSet', iptrw);
    RegisterProperty('DefaultReadTPB', 'AnsiString', iptrw);
    RegisterProperty('DefaultWriteTPB', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXStringKeyPoolBinTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALStringKeyAVLBinaryTreeNode', 'TALFBXStringKeyPoolBinTreeNode') do
  with CL.AddClassN(CL.FindClass('TALStringKeyAVLBinaryTreeNode'),'TALFBXStringKeyPoolBinTreeNode') do
  begin
    RegisterProperty('Pool', 'TObjectList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXReadStatementPoolContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALFBXReadStatementPoolContainer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALFBXReadStatementPoolContainer') do
  begin
    RegisterProperty('DBHandle', 'IscDbHandle', iptrw);
    RegisterProperty('TraHandle', 'IscTrHandle', iptrw);
    RegisterProperty('StmtHandle', 'IscStmtHandle', iptrw);
    RegisterProperty('Sqlda', 'TALFBXSQLResult', iptrw);
    RegisterProperty('LastAccessDate', 'int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXReadTransactionPoolContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALFBXReadTransactionPoolContainer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALFBXReadTransactionPoolContainer') do
  begin
    RegisterProperty('DBHandle', 'IscDbHandle', iptrw);
    RegisterProperty('TraHandle', 'IscTrHandle', iptrw);
    RegisterProperty('LastAccessDate', 'int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXConnectionWithoutStmtPoolContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALFBXConnectionWithoutStmtPoolContainer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALFBXConnectionWithoutStmtPoolContainer') do
  begin
    RegisterProperty('DBHandle', 'IscDbHandle', iptrw);
    RegisterProperty('LastAccessDate', 'int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXConnectionWithStmtPoolContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALFBXConnectionWithStmtPoolContainer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALFBXConnectionWithStmtPoolContainer') do
  begin
    RegisterProperty('DBHandle', 'IscDbHandle', iptrw);
    RegisterProperty('StatementPool', 'TALFBXConnectionStatementPoolBinTree', iptrw);
    RegisterProperty('LastAccessDate', 'int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXConnectionStatementPoolBinTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALStringKeyAVLBinaryTree', 'TALFBXConnectionStatementPoolBinTree') do
  with CL.AddClassN(CL.FindClass('TALStringKeyAVLBinaryTree'),'TALFBXConnectionStatementPoolBinTree') do
  begin
    RegisterProperty('LastGarbage', 'Int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXConnectionStatementPoolBinTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALStringKeyAVLBinaryTreeNode', 'TALFBXConnectionStatementPoolBinTreeNode') do
  with CL.AddClassN(CL.FindClass('TALStringKeyAVLBinaryTreeNode'),'TALFBXConnectionStatementPoolBinTreeNode') do
  begin
    RegisterProperty('Lib', 'TALFBXLibrary', iptrw);
    RegisterProperty('StmtHandle', 'IscStmtHandle', iptrw);
    RegisterProperty('Sqlda', 'TALFBXSQLResult', iptrw);
    RegisterProperty('LastAccessDate', 'int64', iptrw);
    RegisterProperty('OwnsObjects', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALFBXClient') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALFBXClient') do begin
    RegisterMethod('Constructor Create( ApiVer : TALFBXVersion_API; const lib : AnsiString);');
       RegisterMethod('Procedure Free');
   //  Constructor Create(ApiVer: TALFBXVersion_API; const lib: AnsiString = GDS32DLL); overload; virtual;

    RegisterMethod('Constructor Create1(lib : TALFBXLibrary);');
    RegisterMethod('Procedure GetMonitoringInfos( ConnectionID, TransactionID : int64; StatementSQL : AnsiString; var IOStats : TALFBXClientMonitoringIOStats; var RecordStats : TALFBXClientMonitoringRecordStats;'+
    ' var MemoryUsage : TALFBXClientMonitoringMemoryUsage; const SkipIOStats : Boolean; const SkipRecordStats : Boolean; const SkipMemoryUsage : Boolean)');
    RegisterMethod('Function GetDataBaseInfoInt( const item : Integer) : Integer');
    RegisterMethod('Function GetDataBaseInfoString( const item : Integer) : AnsiString');
    RegisterMethod('Function GetDataBaseInfoDateTime( const item : Integer) : TDateTime');
    RegisterMethod('Procedure GetUserNames( UserNames : TALStrings)');
    RegisterMethod('Procedure CreateDatabase( SQL : AnsiString)');
    RegisterMethod('Procedure DropDatabase');
    RegisterMethod('Procedure Connect( DataBaseName, Login, Password, CharSet : AnsiString; const ExtraParams : AnsiString);');
    RegisterMethod('Procedure Connect1( DataBaseName, Login, Password, CharSet : AnsiString; Numbuffers : integer);');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure TransactionStart( TPB : AnsiString)');
    RegisterMethod('Procedure TransactionCommit');
    RegisterMethod('Procedure TransactionCommitRetaining');
    RegisterMethod('Procedure TransactionRollback');
    RegisterMethod('Procedure TransactionRollbackRetaining');
    RegisterMethod('Function Prepare( SQL : AnsiString) : TALFBXStatementType');
    RegisterMethod('Procedure SelectData( SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData1( SQL : TALFBXClientSelectDataSQL; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData2( SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData3( SQL : AnsiString; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData4( SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData5( SQL : TALFBXClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData6( SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData7( SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData8( SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData9( SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData10( SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData11( SQL : AnsiString; Params : array of AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure UpdateData( SQLs : TALFBXClientUpdateDataSQLs);');
    RegisterMethod('Procedure UpdateData1( SQL : TALFBXClientUpdateDataSQL);');
    RegisterMethod('Procedure UpdateData2( SQLs : TALStrings);');
    RegisterMethod('Procedure UpdateData3( SQL : AnsiString);');
    RegisterMethod('Procedure UpdateData4( SQL : AnsiString; Params : array of AnsiString);');
    RegisterMethod('Procedure UpdateData5( SQLs : array of AnsiString);');
    RegisterProperty('Connected', 'Boolean', iptrw);
    RegisterProperty('SqlDialect', 'word', iptrw);
    RegisterProperty('InTransaction', 'Boolean', iptrw);
    RegisterProperty('NullString', 'AnsiString', iptrw);
    RegisterProperty('Lib', 'TALFBXLibrary', iptrw);
    RegisterProperty('CharSet', 'TALFBXCharacterSet', iptrw);
    RegisterProperty('DefaultReadTPB', 'AnsiString', iptrw);
    RegisterProperty('DefaultWriteTPB', 'AnsiString', iptrw);
    RegisterProperty('TransactionID', 'Cardinal', iptrw);
    RegisterProperty('ConnectionID', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFBXClient(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TALFBXClientSQLParam', 'record Value : AnsiString; IsNull : Boolean; end');
  CL.AddTypeS('TALFBXClientSQLParams', 'array of TALFBXClientSQLParam');
  CL.AddTypeS('TALFBXClientSelectDataSQL', 'record SQL : AnsiString; Params : T'
   +'ALFBXClientSQLParams; RowTag : AnsiString; ViewTag : AnsiString; Skip : in'
   +'teger; First : Integer; CacheThreshold : Integer; end');
  CL.AddTypeS('TALFBXClientSelectDataSQLs', 'array of TALFBXClientSelectDataSQL');
  CL.AddTypeS('TALFBXClientUpdateDataSQL', 'record SQL : AnsiString; Params : TALFBXClientSQLParams; end');
  CL.AddTypeS('TALFBXClientUpdateDataSQLs', 'array of TALFBXClientUpdateDataSQL');
  CL.AddTypeS('TALFBXClientMonitoringIOStats', 'record page_reads : int64; page'
   +'_writes : int64; page_fetches : int64; page_marks : int64; end');
  CL.AddTypeS('TALFBXClientMonitoringRecordStats', 'record record_idx_reads : i'
   +'nt64; record_seq_reads : int64; record_inserts : int64; record_updates : i'
   +'nt64; record_deletes : int64; record_backouts : int64; record_purges : int'
   +'64; record_expunges : int64; end');
  CL.AddTypeS('TALFBXClientMonitoringMemoryUsage', 'record memory_used : int64;'
   +' memory_allocated : int64; max_memory_used: int64; max_memory_allocated: int64; end');
  CL.AddTypeS('TALFBXVersion_API', '(FB102, FB103, FB15, FB20, FB21, FB25)');
 //TALFBXVersion_API = (FB102, FB103, FB15, FB20, FB21, FB25);
    CL.AddTypeS('TBGImageStyle', '(bgNone, bgNormal, bgCenter, bgStretch, bgTile)');

  SIRegister_TALFBXClient(CL);
  SIRegister_TALFBXConnectionStatementPoolBinTreeNode(CL);
  SIRegister_TALFBXConnectionStatementPoolBinTree(CL);
  SIRegister_TALFBXConnectionWithStmtPoolContainer(CL);
  SIRegister_TALFBXConnectionWithoutStmtPoolContainer(CL);
  SIRegister_TALFBXReadTransactionPoolContainer(CL);
  SIRegister_TALFBXReadStatementPoolContainer(CL);
  SIRegister_TALFBXStringKeyPoolBinTreeNode(CL);
  SIRegister_TALFBXConnectionPoolClient(CL);
  SIRegister_TALFBXEventThread(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALFBXEventThreadSignal_R(Self: TALFBXEventThread; var T: Thandle);
begin T := Self.Signal; end;

(*----------------------------------------------------------------------------*)
Function TALFBXEventThreadCreate1_P(Self: TClass; CreateNewInstance: Boolean;  aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aEventNames : AnsiString; alib : TALFBXLibrary; const aConnectionMaxIdleTime : integer; const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString):TObject;
Begin Result := TALFBXEventThread.Create(aDataBaseName, aLogin, aPassword, aCharSet, aEventNames, alib, aConnectionMaxIdleTime, aNumbuffers, aOpenConnectionExtraParams); END;

(*----------------------------------------------------------------------------*)
Function TALFBXEventThreadCreate_P(Self: TClass; CreateNewInstance: Boolean;  aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aEventNames : AnsiString; aApiVer : TALFBXVersion_API; const alib : AnsiString; const aConnectionMaxIdleTime : integer; const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString):TObject;
Begin Result := TALFBXEventThread.Create(aDataBaseName, aLogin, aPassword, aCharSet, aEventNames, aApiVer, alib, aConnectionMaxIdleTime, aNumbuffers, aOpenConnectionExtraParams); END;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientDefaultWriteTPB_W(Self: TALFBXConnectionPoolClient; const T: AnsiString);
begin Self.DefaultWriteTPB := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientDefaultWriteTPB_R(Self: TALFBXConnectionPoolClient; var T: AnsiString);
begin T := Self.DefaultWriteTPB; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientDefaultReadTPB_W(Self: TALFBXConnectionPoolClient; const T: AnsiString);
begin Self.DefaultReadTPB := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientDefaultReadTPB_R(Self: TALFBXConnectionPoolClient; var T: AnsiString);
begin T := Self.DefaultReadTPB; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientCharSet_R(Self: TALFBXConnectionPoolClient; var T: TALFBXCharacterSet);
begin T := Self.CharSet; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientLib_R(Self: TALFBXConnectionPoolClient; var T: TALFBXLibrary);
begin T := Self.Lib; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientNullString_W(Self: TALFBXConnectionPoolClient; const T: AnsiString);
begin Self.NullString := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientNullString_R(Self: TALFBXConnectionPoolClient; var T: AnsiString);
begin T := Self.NullString; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientStatementMaxIdleTime_W(Self: TALFBXConnectionPoolClient; const T: integer);
begin Self.StatementMaxIdleTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientStatementMaxIdleTime_R(Self: TALFBXConnectionPoolClient; var T: integer);
begin T := Self.StatementMaxIdleTime; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientTransactionMaxIdleTime_W(Self: TALFBXConnectionPoolClient; const T: integer);
begin Self.TransactionMaxIdleTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientTransactionMaxIdleTime_R(Self: TALFBXConnectionPoolClient; var T: integer);
begin T := Self.TransactionMaxIdleTime; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientConnectionMaxIdleTime_W(Self: TALFBXConnectionPoolClient; const T: integer);
begin Self.ConnectionMaxIdleTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientConnectionMaxIdleTime_R(Self: TALFBXConnectionPoolClient; var T: integer);
begin T := Self.ConnectionMaxIdleTime; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientPassword_R(Self: TALFBXConnectionPoolClient; var T: AnsiString);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientLogin_R(Self: TALFBXConnectionPoolClient; var T: AnsiString);
begin T := Self.Login; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientDataBaseName_R(Self: TALFBXConnectionPoolClient; var T: AnsiString);
begin T := Self.DataBaseName; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionPoolClientSqlDialect_R(Self: TALFBXConnectionPoolClient; var T: word);
begin T := Self.SqlDialect; end;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientUpdateData5_P(Self: TALFBXConnectionPoolClient;  SQLs : array of AnsiString; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.UpdateData(SQLs, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientUpdateData4_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; Params : array of AnsiString; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.UpdateData(SQL, Params, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientUpdateData3_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.UpdateData(SQL, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientUpdateData2_P(Self: TALFBXConnectionPoolClient;  SQLs : TALStrings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.UpdateData(SQLs, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientUpdateData1_P(Self: TALFBXConnectionPoolClient;  SQL : TALFBXClientUpdateDataSQL; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.UpdateData(SQL, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientUpdateData_P(Self: TALFBXConnectionPoolClient;  SQLs : TALFBXClientUpdateDataSQLs; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.UpdateData(SQLs, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData11_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; Params : array of AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, Params, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData10_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, Params, RowTag, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData9_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, Params, RowTag, Skip, First, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData8_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData7_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, RowTag, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData6_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, RowTag, Skip, First, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData5_P(Self: TALFBXConnectionPoolClient;  SQL : TALFBXClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData4_P(Self: TALFBXConnectionPoolClient;  SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQLs, XMLDATA, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData3_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData2_P(Self: TALFBXConnectionPoolClient;  SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, Skip, First, OnNewRowFunct, ExtData, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData1_P(Self: TALFBXConnectionPoolClient;  SQL : TALFBXClientSelectDataSQL; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientSelectData_P(Self: TALFBXConnectionPoolClient;  SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const DBHandle : IscDbHandle; const TraHandle : IscTrHandle; const StatementPool : TALFBXConnectionStatementPoolBinTree; const TPB : AnsiString);
Begin Self.SelectData(SQLs, XMLDATA, OnNewRowFunct, ExtData, FormatSettings, DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientTransactionRollback1_P(Self: TALFBXConnectionPoolClient;  var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; const CloseConnection : Boolean);
Begin Self.TransactionRollback(DBHandle, TraHandle, CloseConnection); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientTransactionCommit1_P(Self: TALFBXConnectionPoolClient;  var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; const CloseConnection : Boolean);
Begin Self.TransactionCommit(DBHandle, TraHandle, CloseConnection); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientTransactionStart1_P(Self: TALFBXConnectionPoolClient;  var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; TPB : AnsiString);
Begin Self.TransactionStart(DBHandle, TraHandle, TPB); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientTransactionRollback_P(Self: TALFBXConnectionPoolClient;  var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var StatementPool : TALFBXConnectionStatementPoolBinTree; const CloseConnection : Boolean);
Begin Self.TransactionRollback(DBHandle, TraHandle, StatementPool, CloseConnection); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientTransactionCommit_P(Self: TALFBXConnectionPoolClient;  var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var StatementPool : TALFBXConnectionStatementPoolBinTree; const CloseConnection : Boolean);
Begin Self.TransactionCommit(DBHandle, TraHandle, StatementPool, CloseConnection); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXConnectionPoolClientTransactionStart_P(Self: TALFBXConnectionPoolClient;  var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var StatementPool : TALFBXConnectionStatementPoolBinTree; TPB : AnsiString);
Begin Self.TransactionStart(DBHandle, TraHandle, StatementPool, TPB); END;

(*----------------------------------------------------------------------------*)
Function TALFBXConnectionPoolClientCreate1_P(Self: TClass; CreateNewInstance: Boolean;  aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; alib : TALFBXLibrary; const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString):TObject;
Begin Result := TALFBXConnectionPoolClient.Create(aDataBaseName, aLogin, aPassword, aCharSet, alib, aNumbuffers, aOpenConnectionExtraParams); END;

(*----------------------------------------------------------------------------*)
Function TALFBXConnectionPoolClientCreate_P(Self: TClass; CreateNewInstance: Boolean;  aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aApiVer : TALFBXVersion_API; const alib : AnsiString; const aNumbuffers : integer; const aOpenConnectionExtraParams : AnsiString):TObject;
Begin Result := TALFBXConnectionPoolClient.Create(aDataBaseName, aLogin, aPassword, aCharSet, aApiVer, alib, aNumbuffers, aOpenConnectionExtraParams); END;

(*----------------------------------------------------------------------------*)
procedure TALFBXStringKeyPoolBinTreeNodePool_W(Self: TALFBXStringKeyPoolBinTreeNode; const T: TObjectList);
Begin Self.Pool := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXStringKeyPoolBinTreeNodePool_R(Self: TALFBXStringKeyPoolBinTreeNode; var T: TObjectList);
Begin T := Self.Pool; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerLastAccessDate_W(Self: TALFBXReadStatementPoolContainer; const T: int64);
Begin Self.LastAccessDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerLastAccessDate_R(Self: TALFBXReadStatementPoolContainer; var T: int64);
Begin T := Self.LastAccessDate; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerSqlda_W(Self: TALFBXReadStatementPoolContainer; const T: TALFBXSQLResult);
Begin Self.Sqlda := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerSqlda_R(Self: TALFBXReadStatementPoolContainer; var T: TALFBXSQLResult);
Begin T := Self.Sqlda; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerStmtHandle_W(Self: TALFBXReadStatementPoolContainer; const T: IscStmtHandle);
Begin Self.StmtHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerStmtHandle_R(Self: TALFBXReadStatementPoolContainer; var T: IscStmtHandle);
Begin T := Self.StmtHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerTraHandle_W(Self: TALFBXReadStatementPoolContainer; const T: IscTrHandle);
Begin Self.TraHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerTraHandle_R(Self: TALFBXReadStatementPoolContainer; var T: IscTrHandle);
Begin T := Self.TraHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerDBHandle_W(Self: TALFBXReadStatementPoolContainer; const T: IscDbHandle);
Begin Self.DBHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadStatementPoolContainerDBHandle_R(Self: TALFBXReadStatementPoolContainer; var T: IscDbHandle);
Begin T := Self.DBHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadTransactionPoolContainerLastAccessDate_W(Self: TALFBXReadTransactionPoolContainer; const T: int64);
Begin Self.LastAccessDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadTransactionPoolContainerLastAccessDate_R(Self: TALFBXReadTransactionPoolContainer; var T: int64);
Begin T := Self.LastAccessDate; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadTransactionPoolContainerTraHandle_W(Self: TALFBXReadTransactionPoolContainer; const T: IscTrHandle);
Begin Self.TraHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadTransactionPoolContainerTraHandle_R(Self: TALFBXReadTransactionPoolContainer; var T: IscTrHandle);
Begin T := Self.TraHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadTransactionPoolContainerDBHandle_W(Self: TALFBXReadTransactionPoolContainer; const T: IscDbHandle);
Begin Self.DBHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXReadTransactionPoolContainerDBHandle_R(Self: TALFBXReadTransactionPoolContainer; var T: IscDbHandle);
Begin T := Self.DBHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithoutStmtPoolContainerLastAccessDate_W(Self: TALFBXConnectionWithoutStmtPoolContainer; const T: int64);
Begin Self.LastAccessDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithoutStmtPoolContainerLastAccessDate_R(Self: TALFBXConnectionWithoutStmtPoolContainer; var T: int64);
Begin T := Self.LastAccessDate; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithoutStmtPoolContainerDBHandle_W(Self: TALFBXConnectionWithoutStmtPoolContainer; const T: IscDbHandle);
Begin Self.DBHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithoutStmtPoolContainerDBHandle_R(Self: TALFBXConnectionWithoutStmtPoolContainer; var T: IscDbHandle);
Begin T := Self.DBHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithStmtPoolContainerLastAccessDate_W(Self: TALFBXConnectionWithStmtPoolContainer; const T: int64);
Begin Self.LastAccessDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithStmtPoolContainerLastAccessDate_R(Self: TALFBXConnectionWithStmtPoolContainer; var T: int64);
Begin T := Self.LastAccessDate; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithStmtPoolContainerStatementPool_W(Self: TALFBXConnectionWithStmtPoolContainer; const T: TALFBXConnectionStatementPoolBinTree);
Begin Self.StatementPool := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithStmtPoolContainerStatementPool_R(Self: TALFBXConnectionWithStmtPoolContainer; var T: TALFBXConnectionStatementPoolBinTree);
Begin T := Self.StatementPool; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithStmtPoolContainerDBHandle_W(Self: TALFBXConnectionWithStmtPoolContainer; const T: IscDbHandle);
Begin Self.DBHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionWithStmtPoolContainerDBHandle_R(Self: TALFBXConnectionWithStmtPoolContainer; var T: IscDbHandle);
Begin T := Self.DBHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeLastGarbage_W(Self: TALFBXConnectionStatementPoolBinTree; const T: Int64);
Begin Self.LastGarbage := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeLastGarbage_R(Self: TALFBXConnectionStatementPoolBinTree; var T: Int64);
Begin T := Self.LastGarbage; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeOwnsObjects_W(Self: TALFBXConnectionStatementPoolBinTreeNode; const T: Boolean);
Begin Self.OwnsObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeOwnsObjects_R(Self: TALFBXConnectionStatementPoolBinTreeNode; var T: Boolean);
Begin T := Self.OwnsObjects; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeLastAccessDate_W(Self: TALFBXConnectionStatementPoolBinTreeNode; const T: int64);
Begin Self.LastAccessDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeLastAccessDate_R(Self: TALFBXConnectionStatementPoolBinTreeNode; var T: int64);
Begin T := Self.LastAccessDate; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeSqlda_W(Self: TALFBXConnectionStatementPoolBinTreeNode; const T: TALFBXSQLResult);
Begin Self.Sqlda := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeSqlda_R(Self: TALFBXConnectionStatementPoolBinTreeNode; var T: TALFBXSQLResult);
Begin T := Self.Sqlda; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeStmtHandle_W(Self: TALFBXConnectionStatementPoolBinTreeNode; const T: IscStmtHandle);
Begin Self.StmtHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeStmtHandle_R(Self: TALFBXConnectionStatementPoolBinTreeNode; var T: IscStmtHandle);
Begin T := Self.StmtHandle; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeLib_W(Self: TALFBXConnectionStatementPoolBinTreeNode; const T: TALFBXLibrary);
Begin Self.Lib := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXConnectionStatementPoolBinTreeNodeLib_R(Self: TALFBXConnectionStatementPoolBinTreeNode; var T: TALFBXLibrary);
Begin T := Self.Lib; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientConnectionID_R(Self: TALFBXClient; var T: Integer);
begin T := Self.ConnectionID; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientTransactionID_R(Self: TALFBXClient; var T: Cardinal);
begin T := Self.TransactionID; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientDefaultWriteTPB_W(Self: TALFBXClient; const T: AnsiString);
begin Self.DefaultWriteTPB := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientDefaultWriteTPB_R(Self: TALFBXClient; var T: AnsiString);
begin T := Self.DefaultWriteTPB; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientDefaultReadTPB_W(Self: TALFBXClient; const T: AnsiString);
begin Self.DefaultReadTPB := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientDefaultReadTPB_R(Self: TALFBXClient; var T: AnsiString);
begin T := Self.DefaultReadTPB; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientCharSet_R(Self: TALFBXClient; var T: TALFBXCharacterSet);
begin T := Self.CharSet; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientLib_R(Self: TALFBXClient; var T: TALFBXLibrary);
begin T := Self.Lib; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientNullString_W(Self: TALFBXClient; const T: AnsiString);
begin Self.NullString := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientNullString_R(Self: TALFBXClient; var T: AnsiString);
begin T := Self.NullString; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientInTransaction_R(Self: TALFBXClient; var T: Boolean);
begin T := Self.InTransaction; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientSqlDialect_R(Self: TALFBXClient; var T: word);
begin T := Self.SqlDialect; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXClientConnected_R(Self: TALFBXClient; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientUpdateData5_P(Self: TALFBXClient;  SQLs : array of AnsiString);
Begin Self.UpdateData(SQLs); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientUpdateData4_P(Self: TALFBXClient;  SQL : AnsiString; Params : array of AnsiString);
Begin Self.UpdateData(SQL, Params); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientUpdateData3_P(Self: TALFBXClient;  SQL : AnsiString);
Begin Self.UpdateData(SQL); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientUpdateData2_P(Self: TALFBXClient;  SQLs : TALStrings);
Begin Self.UpdateData(SQLs); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientUpdateData1_P(Self: TALFBXClient;  SQL : TALFBXClientUpdateDataSQL);
Begin Self.UpdateData(SQL); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientUpdateData_P(Self: TALFBXClient;  SQLs : TALFBXClientUpdateDataSQLs);
Begin Self.UpdateData(SQLs); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData11_P(Self: TALFBXClient;  SQL : AnsiString; Params : array of AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, Params, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData10_P(Self: TALFBXClient;  SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, Params, RowTag, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData9_P(Self: TALFBXClient;  SQL : AnsiString; Params : array of AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, Params, RowTag, Skip, First, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData8_P(Self: TALFBXClient;  SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData7_P(Self: TALFBXClient;  SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, RowTag, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData6_P(Self: TALFBXClient;  SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, RowTag, Skip, First, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData5_P(Self: TALFBXClient;  SQL : TALFBXClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData4_P(Self: TALFBXClient;  SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQLs, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData3_P(Self: TALFBXClient;  SQL : AnsiString; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData2_P(Self: TALFBXClient;  SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, Skip, First, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData1_P(Self: TALFBXClient;  SQL : TALFBXClientSelectDataSQL; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientSelectData_P(Self: TALFBXClient;  SQLs : TALFBXClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TALFBXClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQLs, XMLDATA, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientConnect1_P(Self: TALFBXClient;  DataBaseName, Login, Password, CharSet : AnsiString; Numbuffers : integer);
Begin Self.Connect(DataBaseName, Login, Password, CharSet, Numbuffers); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXClientConnect_P(Self: TALFBXClient;  DataBaseName, Login, Password, CharSet : AnsiString; const ExtraParams : AnsiString);
Begin Self.Connect(DataBaseName, Login, Password, CharSet, ExtraParams); END;

(*----------------------------------------------------------------------------*)
//Function TALFBXClientCreate1_P(Self: TClass; CreateNewInstance: Boolean;  lib : TALFBXLibrary):TObject;
Function TALFBXClientCreate1_P(Self: TClass; lib : TALFBXLibrary):TObject;
Begin Result:= TALFBXClient.Create(lib); END;

(*----------------------------------------------------------------------------*)
Function TALFBXClientCreate_P(Self: TClass; ApiVer : TALFBXVersion_API; const lib : AnsiString):TObject;
Begin Result := TALFBXClient.Create(ApiVer, lib); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXEventThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXEventThread) do begin
    RegisterVirtualConstructor(@TALFBXEventThreadCreate_P, 'Create');
    RegisterVirtualConstructor(@TALFBXEventThreadCreate1_P, 'Create1');
    RegisterPropertyHelper(@TALFBXEventThreadSignal_R,nil,'Signal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXConnectionPoolClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXConnectionPoolClient) do begin
    RegisterConstructor(@TALFBXConnectionPoolClientCreate_P, 'Create');
    RegisterConstructor(@TALFBXConnectionPoolClientCreate1_P, 'Create1');
      RegisterMethod(@TALFBXConnectionPoolClient.Destroy, 'Free');
       RegisterVirtualMethod(@TALFBXConnectionPoolClient.ReleaseAllConnections, 'ReleaseAllConnections');
    RegisterMethod(@TALFBXConnectionPoolClient.GetMonitoringInfos, 'GetMonitoringInfos');
    RegisterMethod(@TALFBXConnectionPoolClient.GetConnectionID, 'GetConnectionID');
    RegisterMethod(@TALFBXConnectionPoolClient.GetTransactionID, 'GetTransactionID');
    RegisterMethod(@TALFBXConnectionPoolClient.GetDataBaseInfoInt, 'GetDataBaseInfoInt');
    RegisterMethod(@TALFBXConnectionPoolClient.GetDataBaseInfoString, 'GetDataBaseInfoString');
    RegisterMethod(@TALFBXConnectionPoolClient.GetDataBaseInfoDateTime, 'GetDataBaseInfoDateTime');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientTransactionStart_P, 'TransactionStart');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientTransactionCommit_P, 'TransactionCommit');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientTransactionRollback_P, 'TransactionRollback');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientTransactionStart1_P, 'TransactionStart1');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientTransactionCommit1_P, 'TransactionCommit1');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientTransactionRollback1_P, 'TransactionRollback1');
    RegisterVirtualMethod(@TALFBXConnectionPoolClient.TransactionCommitRetaining, 'TransactionCommitRetaining');
    RegisterVirtualMethod(@TALFBXConnectionPoolClient.TransactionRollbackRetaining, 'TransactionRollbackRetaining');
    RegisterMethod(@TALFBXConnectionPoolClient.Prepare, 'Prepare');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData_P, 'SelectData');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData1_P, 'SelectData1');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData2_P, 'SelectData2');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData3_P, 'SelectData3');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData4_P, 'SelectData4');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData5_P, 'SelectData5');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData6_P, 'SelectData6');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData7_P, 'SelectData7');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData8_P, 'SelectData8');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData9_P, 'SelectData9');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData10_P, 'SelectData10');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientSelectData11_P, 'SelectData11');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientUpdateData_P, 'UpdateData');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientUpdateData1_P, 'UpdateData1');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientUpdateData2_P, 'UpdateData2');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientUpdateData3_P, 'UpdateData3');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientUpdateData4_P, 'UpdateData4');
    RegisterVirtualMethod(@TALFBXConnectionPoolClientUpdateData5_P, 'UpdateData5');
    RegisterMethod(@TALFBXConnectionPoolClient.ConnectionCount, 'ConnectionCount');
    RegisterMethod(@TALFBXConnectionPoolClient.WorkingConnectionCount, 'WorkingConnectionCount');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientSqlDialect_R,nil,'SqlDialect');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientDataBaseName_R,nil,'DataBaseName');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientLogin_R,nil,'Login');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientPassword_R,nil,'Password');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientConnectionMaxIdleTime_R,@TALFBXConnectionPoolClientConnectionMaxIdleTime_W,'ConnectionMaxIdleTime');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientTransactionMaxIdleTime_R,@TALFBXConnectionPoolClientTransactionMaxIdleTime_W,'TransactionMaxIdleTime');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientStatementMaxIdleTime_R,@TALFBXConnectionPoolClientStatementMaxIdleTime_W,'StatementMaxIdleTime');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientNullString_R,@TALFBXConnectionPoolClientNullString_W,'NullString');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientLib_R,nil,'Lib');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientCharSet_R,nil,'CharSet');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientDefaultReadTPB_R,@TALFBXConnectionPoolClientDefaultReadTPB_W,'DefaultReadTPB');
    RegisterPropertyHelper(@TALFBXConnectionPoolClientDefaultWriteTPB_R,@TALFBXConnectionPoolClientDefaultWriteTPB_W,'DefaultWriteTPB');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXStringKeyPoolBinTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXStringKeyPoolBinTreeNode) do
  begin
    RegisterPropertyHelper(@TALFBXStringKeyPoolBinTreeNodePool_R,@TALFBXStringKeyPoolBinTreeNodePool_W,'Pool');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXReadStatementPoolContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXReadStatementPoolContainer) do begin
    RegisterPropertyHelper(@TALFBXReadStatementPoolContainerDBHandle_R,@TALFBXReadStatementPoolContainerDBHandle_W,'DBHandle');
    RegisterPropertyHelper(@TALFBXReadStatementPoolContainerTraHandle_R,@TALFBXReadStatementPoolContainerTraHandle_W,'TraHandle');
    RegisterPropertyHelper(@TALFBXReadStatementPoolContainerStmtHandle_R,@TALFBXReadStatementPoolContainerStmtHandle_W,'StmtHandle');
    RegisterPropertyHelper(@TALFBXReadStatementPoolContainerSqlda_R,@TALFBXReadStatementPoolContainerSqlda_W,'Sqlda');
    RegisterPropertyHelper(@TALFBXReadStatementPoolContainerLastAccessDate_R,@TALFBXReadStatementPoolContainerLastAccessDate_W,'LastAccessDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXReadTransactionPoolContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXReadTransactionPoolContainer) do begin
    RegisterPropertyHelper(@TALFBXReadTransactionPoolContainerDBHandle_R,@TALFBXReadTransactionPoolContainerDBHandle_W,'DBHandle');
    RegisterPropertyHelper(@TALFBXReadTransactionPoolContainerTraHandle_R,@TALFBXReadTransactionPoolContainerTraHandle_W,'TraHandle');
    RegisterPropertyHelper(@TALFBXReadTransactionPoolContainerLastAccessDate_R,@TALFBXReadTransactionPoolContainerLastAccessDate_W,'LastAccessDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXConnectionWithoutStmtPoolContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXConnectionWithoutStmtPoolContainer) do begin
    RegisterPropertyHelper(@TALFBXConnectionWithoutStmtPoolContainerDBHandle_R,@TALFBXConnectionWithoutStmtPoolContainerDBHandle_W,'DBHandle');
    RegisterPropertyHelper(@TALFBXConnectionWithoutStmtPoolContainerLastAccessDate_R,@TALFBXConnectionWithoutStmtPoolContainerLastAccessDate_W,'LastAccessDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXConnectionWithStmtPoolContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXConnectionWithStmtPoolContainer) do begin
    RegisterPropertyHelper(@TALFBXConnectionWithStmtPoolContainerDBHandle_R,@TALFBXConnectionWithStmtPoolContainerDBHandle_W,'DBHandle');
    RegisterPropertyHelper(@TALFBXConnectionWithStmtPoolContainerStatementPool_R,@TALFBXConnectionWithStmtPoolContainerStatementPool_W,'StatementPool');
    RegisterPropertyHelper(@TALFBXConnectionWithStmtPoolContainerLastAccessDate_R,@TALFBXConnectionWithStmtPoolContainerLastAccessDate_W,'LastAccessDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXConnectionStatementPoolBinTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXConnectionStatementPoolBinTree) do
  begin
    RegisterPropertyHelper(@TALFBXConnectionStatementPoolBinTreeLastGarbage_R,@TALFBXConnectionStatementPoolBinTreeLastGarbage_W,'LastGarbage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXConnectionStatementPoolBinTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXConnectionStatementPoolBinTreeNode) do begin
    RegisterPropertyHelper(@TALFBXConnectionStatementPoolBinTreeNodeLib_R,@TALFBXConnectionStatementPoolBinTreeNodeLib_W,'Lib');
    RegisterPropertyHelper(@TALFBXConnectionStatementPoolBinTreeNodeStmtHandle_R,@TALFBXConnectionStatementPoolBinTreeNodeStmtHandle_W,'StmtHandle');
    RegisterPropertyHelper(@TALFBXConnectionStatementPoolBinTreeNodeSqlda_R,@TALFBXConnectionStatementPoolBinTreeNodeSqlda_W,'Sqlda');
    RegisterPropertyHelper(@TALFBXConnectionStatementPoolBinTreeNodeLastAccessDate_R,@TALFBXConnectionStatementPoolBinTreeNodeLastAccessDate_W,'LastAccessDate');
    RegisterPropertyHelper(@TALFBXConnectionStatementPoolBinTreeNodeOwnsObjects_R,@TALFBXConnectionStatementPoolBinTreeNodeOwnsObjects_W,'OwnsObjects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXClient) do begin
    RegisterConstructor(@TALFBXClientCreate_P, 'Create');
    RegisterConstructor(@TALFBXClientCreate1_P, 'Create1');
     RegisterMethod(@TALFBXClient.Destroy, 'Free');
      RegisterMethod(@TALFBXClient.GetMonitoringInfos, 'GetMonitoringInfos');
    RegisterMethod(@TALFBXClient.GetDataBaseInfoInt, 'GetDataBaseInfoInt');
    RegisterMethod(@TALFBXClient.GetDataBaseInfoString, 'GetDataBaseInfoString');
    RegisterMethod(@TALFBXClient.GetDataBaseInfoDateTime, 'GetDataBaseInfoDateTime');
    RegisterMethod(@TALFBXClient.GetUserNames, 'GetUserNames');
    RegisterMethod(@TALFBXClient.CreateDatabase, 'CreateDatabase');
    RegisterMethod(@TALFBXClient.DropDatabase, 'DropDatabase');
    RegisterMethod(@TALFBXClientConnect_P, 'Connect');
    RegisterMethod(@TALFBXClientConnect1_P, 'Connect1');
    RegisterMethod(@TALFBXClient.Disconnect, 'Disconnect');
    RegisterMethod(@TALFBXClient.TransactionStart, 'TransactionStart');
    RegisterMethod(@TALFBXClient.TransactionCommit, 'TransactionCommit');
    RegisterMethod(@TALFBXClient.TransactionCommitRetaining, 'TransactionCommitRetaining');
    RegisterMethod(@TALFBXClient.TransactionRollback, 'TransactionRollback');
    RegisterMethod(@TALFBXClient.TransactionRollbackRetaining, 'TransactionRollbackRetaining');
    RegisterMethod(@TALFBXClient.Prepare, 'Prepare');
    RegisterMethod(@TALFBXClientSelectData_P, 'SelectData');
    RegisterMethod(@TALFBXClientSelectData1_P, 'SelectData1');
    RegisterMethod(@TALFBXClientSelectData2_P, 'SelectData2');
    RegisterMethod(@TALFBXClientSelectData3_P, 'SelectData3');
    RegisterMethod(@TALFBXClientSelectData4_P, 'SelectData4');
    RegisterMethod(@TALFBXClientSelectData5_P, 'SelectData5');
    RegisterMethod(@TALFBXClientSelectData6_P, 'SelectData6');
    RegisterMethod(@TALFBXClientSelectData7_P, 'SelectData7');
    RegisterMethod(@TALFBXClientSelectData8_P, 'SelectData8');
    RegisterMethod(@TALFBXClientSelectData9_P, 'SelectData9');
    RegisterMethod(@TALFBXClientSelectData10_P, 'SelectData10');
    RegisterMethod(@TALFBXClientSelectData11_P, 'SelectData11');
    RegisterMethod(@TALFBXClientUpdateData_P, 'UpdateData');
    RegisterMethod(@TALFBXClientUpdateData1_P, 'UpdateData1');
    RegisterMethod(@TALFBXClientUpdateData2_P, 'UpdateData2');
    RegisterMethod(@TALFBXClientUpdateData3_P, 'UpdateData3');
    RegisterMethod(@TALFBXClientUpdateData4_P, 'UpdateData4');
    RegisterMethod(@TALFBXClientUpdateData5_P, 'UpdateData5');
    RegisterPropertyHelper(@TALFBXClientConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TALFBXClientSqlDialect_R,nil,'SqlDialect');
    RegisterPropertyHelper(@TALFBXClientInTransaction_R,nil,'InTransaction');
    RegisterPropertyHelper(@TALFBXClientNullString_R,@TALFBXClientNullString_W,'NullString');
    RegisterPropertyHelper(@TALFBXClientLib_R,nil,'Lib');
    RegisterPropertyHelper(@TALFBXClientCharSet_R,nil,'CharSet');
    RegisterPropertyHelper(@TALFBXClientDefaultReadTPB_R,@TALFBXClientDefaultReadTPB_W,'DefaultReadTPB');
    RegisterPropertyHelper(@TALFBXClientDefaultWriteTPB_R,@TALFBXClientDefaultWriteTPB_W,'DefaultWriteTPB');
    RegisterPropertyHelper(@TALFBXClientTransactionID_R,nil,'TransactionID');
    RegisterPropertyHelper(@TALFBXClientConnectionID_R,nil,'ConnectionID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFBXClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALFBXClient(CL);
  RIRegister_TALFBXConnectionStatementPoolBinTreeNode(CL);
  RIRegister_TALFBXConnectionStatementPoolBinTree(CL);
  RIRegister_TALFBXConnectionWithStmtPoolContainer(CL);
  RIRegister_TALFBXConnectionWithoutStmtPoolContainer(CL);
  RIRegister_TALFBXReadTransactionPoolContainer(CL);
  RIRegister_TALFBXReadStatementPoolContainer(CL);
  RIRegister_TALFBXStringKeyPoolBinTreeNode(CL);
  RIRegister_TALFBXConnectionPoolClient(CL);
  RIRegister_TALFBXEventThread(CL);
end;

 
 
{ TPSImport_ALFBXClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFBXClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFBXClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFBXClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALFBXClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
