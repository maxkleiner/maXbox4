unit uPSI_ALFBXLib;
{
   for firebird/interbase
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
  TPSImport_ALFBXLib = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALFBXLibrary(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXSQLParams(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXSQLResult(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXPoolStream(CL: TPSPascalCompiler);
procedure SIRegister_TALFBXSQLDA(CL: TPSPascalCompiler);
procedure SIRegister_EALFBXException(CL: TPSPascalCompiler);
procedure SIRegister_EALFBXError(CL: TPSPascalCompiler);
procedure SIRegister_ALFBXLib(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALFBXLibrary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXSQLParams(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXSQLResult(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXPoolStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALFBXSQLDA(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALFBXLib_Routines(S: TPSExec);
procedure RIRegister_EALFBXException(CL: TPSRuntimeClassImporter);
procedure RIRegister_EALFBXError(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALFBXLib(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ALFBXbase
  ,ALFBXLib;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFBXLib]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXLibrary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALFBXBaseLibrary', 'TALFBXLibrary') do
  with CL.AddClassN(CL.FindClass('TALFBXBaseLibrary'),'TALFBXLibrary') do begin
    RegisterMethod('Constructor Create( ApiVer : TALFBXVersion_Api)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure CheckFBXApiCall( const Status : ISCStatus; StatusVector : TALFBXStatusVector)');
    RegisterProperty('OnConnectionLost', 'TALFBXOnConnectionLost', iptrw);
    RegisterProperty('OnGetDBExceptionClass', 'TALFBXOnGetDBExceptionClass', iptrw);
    RegisterProperty('RaiseErrors', 'boolean', iptrw);
    RegisterMethod('Function ServerShutdown( timeout : Cardinal; const reason : Integer) : Integer');
    RegisterMethod('Procedure ServerShutdownCallback( callBack : FB_SHUTDOWN_CALLBACK; const mask : Integer; arg : Pointer)');
    RegisterMethod('Procedure AttachDatabase( const FileName : AnsiString; var DbHandle : IscDbHandle; Params : AnsiString; Sep : AnsiChar)');
    RegisterMethod('Procedure DetachDatabase( var DBHandle : IscDbHandle)');
    RegisterMethod('Procedure DatabaseInfo( var DBHandle : IscDbHandle; const Items : AnsiString; var Buffer : AnsiString);');
    RegisterMethod('Function DatabaseInfoIntValue( var DBHandle : IscDbHandle; const item : AnsiChar) : Integer');
    RegisterMethod('Function DatabaseInfoString( var DBHandle : IscDbHandle; item : byte; size : Integer) : AnsiString');
    RegisterMethod('Function DatabaseInfoDateTime( var DBHandle : IscDbHandle; item : byte) : TDateTime');
    RegisterMethod('Procedure DatabaseDrop( DbHandle : IscDbHandle)');
    RegisterMethod('Function DatabaseCancelOperation( var DBHandle : IscDbHandle; option : ISC_USHORT) : Boolean');
    RegisterMethod('Procedure TransactionStart( var TraHandle : IscTrHandle; var DbHandle : IscDbHandle; const TPB : AnsiString)');
    RegisterMethod('Procedure TransactionStartMultiple( var TraHandle : IscTrHandle; DBCount : Smallint; Vector : PISCTEB)');
    RegisterMethod('Procedure TransactionCommit( var TraHandle : IscTrHandle)');
    RegisterMethod('Procedure TransactionRollback( var TraHandle : IscTrHandle)');
    RegisterMethod('Procedure TransactionCommitRetaining( var TraHandle : IscTrHandle)');
    RegisterMethod('Procedure TransactionPrepare( var TraHandle : IscTrHandle)');
    RegisterMethod('Procedure TransactionRollbackRetaining( var TraHandle : IscTrHandle)');
    RegisterMethod('Function TransactionGetId( var TraHandle : IscTrHandle) : Cardinal');
    RegisterMethod('Procedure DSQLExecuteImmediate( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; const Statement : AnsiString; Dialect : Word; Sqlda : TALFBXSQLDA);');
    RegisterMethod('Procedure DSQLExecuteImmediate1( const Statement : AnsiString; Dialect : Word; Sqlda : TALFBXSQLDA);');
    RegisterMethod('Procedure DSQLAllocateStatement( var DBHandle : IscDbHandle; var StmtHandle : IscStmtHandle)');
    RegisterMethod('Function DSQLPrepare( var DbHandle : IscDbHandle; var TraHandle : IscTrHandle; var StmtHandle : IscStmtHandle; Statement : AnsiString; Dialect : Word; Sqlda : TALFBXSQLResult) : TALFBXStatementType');
    RegisterMethod('Procedure DSQLExecute( var TraHandle : IscTrHandle; var StmtHandle : IscStmtHandle; Dialect : Word; Sqlda : TALFBXSQLDA)');
    RegisterMethod('Procedure DSQLExecute2( var TraHandle : IscTrHandle; var StmtHandle : IscStmtHandle; Dialect : Word; InSqlda : TALFBXSQLDA; OutSQLDA : TALFBXSQLResult)');
    RegisterMethod('Procedure DSQLFreeStatement( var StmtHandle : IscStmtHandle; Option : Word)');
    RegisterMethod('Function DSQLFetch( var DBHandle : IscDbHandle; var TransHandle : IscTrHandle; var StmtHandle : IscStmtHandle; Dialect : Word; Sqlda : TALFBXSQLResult) : boolean');
    RegisterMethod('Function DSQLFetchWithBlobs( var DbHandle : IscDbHandle; var TraHandle : IscTrHandle; var StmtHandle : IscStmtHandle; Dialect : Word; Sqlda : TALFBXSQLResult) : boolean');
    RegisterMethod('Procedure DSQLDescribe( var DbHandle : IscDbHandle; var TrHandle : IscTrHandle; var StmtHandle : IscStmtHandle; Dialect : Word; Sqlda : TALFBXSQLResult)');
    RegisterMethod('Procedure DSQLDescribeBind( var StmtHandle : IscStmtHandle; Dialect : Word; Sqlda : TALFBXSQLParams)');
    RegisterMethod('Procedure DSQLSetCursorName( var StmtHandle : IscStmtHandle; const cursor : AnsiString)');
    RegisterMethod('Procedure DSQLExecImmed2( var DBHhandle : IscDbHandle; var TraHandle : IscTrHandle; const Statement : AnsiString; dialect : Word; InSqlda, OutSQLDA : TALFBXSQLDA)');
    RegisterMethod('Procedure DSQLInfo( var StmtHandle : IscStmtHandle; const Items : array of byte; var buffer : AnsiString)');
    RegisterMethod('Function DSQLInfoPlan( var StmtHandle : IscStmtHandle) : AnsiString');
    RegisterMethod('Function DSQLInfoStatementType( var StmtHandle : IscStmtHandle) : TALFBXStatementType');
    RegisterMethod('Function DSQLInfoRowsAffected( var StmtHandle : IscStmtHandle; StatementType : TALFBXStatementType) : Cardinal');
    RegisterMethod('Procedure DSQLInfoRowsAffected2( var StmtHandle : IscStmtHandle; out SelectedRows, InsertedRows, UpdatedRows, DeletedRows : Cardinal)');
    RegisterMethod('Procedure DDLExecute( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; const ddl : AnsiString)');
    RegisterMethod('Function ArrayLookupBounds( var DBHandle : IscDbHandle; var TransHandle : IscTrHandle; const RelationName, FieldName : AnsiString) : TALFBXArrayDesc');
    RegisterMethod('Procedure ArrayGetSlice( var DBHandle : IscDbHandle; var TransHandle : IscTrHandle; ArrayId : TISCQuad; var desc : TALFBXArrayDesc; DestArray : PPointer; var SliceLength : Integer)');
    RegisterMethod('Procedure ArrayPutSlice( var DBHandle : IscDbHandle; var TransHandle : IscTrHandle; var ArrayId : TISCQuad; var desc : TALFBXArrayDesc; DestArray : Pointer; var SliceLength : Integer)');
    RegisterMethod('Procedure ArraySetDesc( const RelationName, FieldName : AnsiString; var SqlDtype, SqlLength, Dimensions : Smallint; var desc : TISCArrayDesc)');
    RegisterMethod('Procedure ServiceAttach( const ServiceName : AnsiString; var SvcHandle : IscSvcHandle; const Spb : AnsiString)');
    RegisterMethod('Procedure ServiceDetach( var SvcHandle : IscSvcHandle)');
    RegisterMethod('Procedure ServiceQuery( var SvcHandle : IscSvcHandle; const SendSpb, RequestSpb : AnsiString; var Buffer : AnsiString)');
    RegisterMethod('Procedure ServiceStart( var SvcHandle : IscSvcHandle; const Spb : AnsiString)');
    RegisterMethod('Function ErrSqlcode( StatusVector : TALFBXStatusVector) : ISCLong');
    RegisterMethod('Function ErrInterprete( StatusVector : TALFBXStatusVector) : AnsiString');
    RegisterMethod('Function ErrSQLInterprete( SQLCODE : Smallint) : AnsiString');
    RegisterMethod('Function ErrSqlState( StatusVector : TALFBXStatusVector) : FB_SQLSTATE_STRING');
    RegisterMethod('Procedure BlobOpen( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var BlobHandle : IscBlobHandle; BlobId : TISCQuad; BPB : AnsiString)');
    RegisterMethod('Function BlobGetSegment( var BlobHandle : IscBlobHandle; out length : Word; BufferLength : Cardinal; Buffer : Pointer) : boolean');
    RegisterMethod('Procedure BlobClose( var BlobHandle : IscBlobHandle)');
    RegisterMethod('Procedure BlobInfo( var BlobHandle : IscBlobHandle; out NumSegments, MaxSegment, TotalLength : Cardinal; out btype : byte)');
    RegisterMethod('Procedure BlobSize( var BlobHandle : IscBlobHandle; out Size : Cardinal)');
    RegisterMethod('Procedure BlobMaxSegment( var BlobHandle : IscBlobHandle; out Size : Cardinal)');
    RegisterMethod('Procedure BlobDefaultDesc( var Desc : TALFBXBlobDesc; const RelationName, FieldName : AnsiString)');
    RegisterMethod('Procedure BlobSaveToStream( var BlobHandle : IscBlobHandle; Stream : TStream)');
    RegisterMethod('Function BlobReadString( var BlobHandle : IscBlobHandle) : AnsiString;');
    RegisterMethod('Procedure BlobReadString1( var BlobHandle : IscBlobHandle; var Str : AnsiString);');
    RegisterMethod('Procedure BlobReadVariant( var BlobHandle : IscBlobHandle; var Value : Variant)');
    RegisterMethod('Procedure BlobReadBuffer( var BlobHandle : IscBlobHandle; var Size : Integer; var Buffer : Pointer; realloc : boolean)');
    RegisterMethod('Procedure BlobReadSizedBuffer( var BlobHandle : IscBlobHandle; Buffer : Pointer);');
    RegisterMethod('Procedure BlobReadSizedBuffer1( var BlobHandle : IscBlobHandle; Buffer : Pointer; MaxSize : Integer);');
    RegisterMethod('Function BlobCreate( var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; var BlobHandle : IscBlobHandle; BPB : AnsiString) : TISCQuad');
    RegisterMethod('Procedure BlobWriteSegment( var BlobHandle : IscBlobHandle; BufferLength : Cardinal; Buffer : Pointer)');
    RegisterMethod('Procedure BlobWriteString( var BlobHandle : IscBlobHandle; const Str : AnsiString);');
    RegisterMethod('Procedure BlobWriteStream( var BlobHandle : IscBlobHandle; Stream : TStream)');
    RegisterMethod('Function StreamBlobOpen( var BlobId : TISCQuad; var Database : IscDbHandle; var Transaction : IscTrHandle; mode : AnsiChar) : PBStream');
    RegisterMethod('Function StreamBlobClose( Stream : PBStream) : integer');
    RegisterMethod('Function EventBlock( var EventBuffer, ResultBuffer : PAnsiChar; Count : Smallint; v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15 : PAnsiChar) : Integer');
    RegisterMethod('Procedure EventQueue( var handle : IscDbHandle; var id : Integer; length : Word; events : PAnsiChar; ast : ISC_EVENT_CALLBACK; arg : Pointer)');
    RegisterMethod('Procedure EventCounts( var ResultVector : TALFBXStatusVector; BufferLength : Smallint; EventBuffer, ResultBuffer : PAnsiChar)');
    RegisterMethod('Procedure EventCancel( var DbHandle : IscDbHandle; var id : integer)');
    RegisterMethod('Procedure EventWaitFor( var handle : IscDbHandle; length : Smallint; events, buffer : Pointer)');
    RegisterMethod('Function IscFree( data : Pointer) : Integer');
    RegisterProperty('SegMentSize', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXSQLParams(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALFBXSQLDA', 'TALFBXSQLParams') do
  with CL.AddClassN(CL.FindClass('TALFBXSQLDA'),'TALFBXSQLParams') do begin
    RegisterMethod('Constructor Create( Charset : TALFBXCharacterSet)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Parse( const SQL : AnsiString) : AnsiString');
    RegisterMethod('Procedure AddFieldType( const Name : AnsiString; FieldType : TALFBXFieldType; Scale : TALFBXScale; Precision : byte)');
    RegisterProperty('FieldName', 'AnsiString Word', iptrw);
    //RegisterProperty('In_DCD', 'boolean', iptr);
    RegisterProperty('ParamCount', 'Word', iptrw);
    RegisterProperty('MaxSqlLen', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXSQLResult(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALFBXSQLDA', 'TALFBXSQLResult') do
  with CL.AddClassN(CL.FindClass('TALFBXSQLDA'),'TALFBXSQLResult') do begin
    RegisterMethod('Constructor Create( Charset : TALFBXCharacterSet; Fields : SmallInt; CachedFetch : Boolean; FetchBlobs : boolean; BufferChunks : Cardinal)');
    RegisterMethod('Procedure ClearRecords');
    RegisterMethod('Procedure GetRecord( const Index : Integer)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure Next');
    //RegisterProperty('In_DCD', 'boolean', iptr);
    RegisterProperty('BlobData', 'PALFBXBlobData word',iptrw);
    RegisterProperty('ArrayData', 'Pointer word', iptrw);
    RegisterProperty('ArrayInfos', 'PALFBXArrayInfo word', iptrw);
    RegisterProperty('ArrayCount', 'Word', iptrw);
    RegisterMethod('Procedure ReadBlob( const Index : Word; Stream : TStream);');
    RegisterMethod('Procedure ReadBlobA( const Index : Word; var str : AnsiString);');
    RegisterMethod('Function ReadBlobA1( const Index : Word) : AnsiString;');
    RegisterMethod('Procedure ReadBlob1( const Index : Word; Data : Pointer);');
    RegisterMethod('Procedure ReadBlob2( const name : AnsiString; Stream : TStream);');
    RegisterMethod('Procedure ReadBlobA3( const name : AnsiString; var str : AnsiString);');
    RegisterMethod('Function ReadBlobA4( const name : AnsiString) : AnsiString;');
    RegisterMethod('Procedure ReadBlob3( const name : AnsiString; Data : Pointer);');
    RegisterMethod('Function GetBlobSize( const Index : Word) : Cardinal');
    RegisterProperty('Eof', 'boolean', iptrw);
    RegisterProperty('ScrollEOF', 'boolean', iptrw);
    RegisterProperty('Bof', 'boolean', iptrw);
    RegisterProperty('CachedFetch', 'boolean', iptrw);
    RegisterProperty('FetchBlobs', 'boolean', iptrw);
    RegisterProperty('RecordCount', 'Integer', iptrw);
    RegisterProperty('CurrentRecord', 'Integer', iptrw);
    RegisterProperty('BufferChunks', 'Cardinal', iptrw);
    RegisterProperty('UniqueRelationName', 'AnsiString', iptrw);
    RegisterProperty('SqlName', 'AnsiString Word', iptrw);
    RegisterProperty('RelName', 'AnsiString Word', iptrw);
    RegisterProperty('OwnName', 'AnsiString Word', iptrw);
    RegisterProperty('AliasName', 'AnsiString Word', iptrw);
    RegisterProperty('AsSmallint', 'Smallint Word', iptrw);
    RegisterProperty('AsInteger', 'Integer Word', iptrw);
    RegisterProperty('AsSingle', 'Single Word', iptrw);
    RegisterProperty('AsDouble', 'Double Word', iptrw);
    RegisterProperty('AsCurrency', 'Currency Word', iptrw);
    RegisterProperty('AsInt64', 'Int64 Word', iptrw);
    RegisterProperty('AsAnsiString', 'AnsiString Word', iptrw);
    RegisterProperty('AsDateTime', 'TDateTime Word', iptrw);
    RegisterProperty('AsDate', 'Integer Word', iptrw);
    RegisterProperty('AsTime', 'Cardinal Word', iptrw);
    RegisterProperty('AsBoolean', 'Boolean Word', iptrw);
    RegisterProperty('ByNameIsNull', 'boolean AnsiString', iptrw);
    RegisterProperty('ByNameIsNullable', 'boolean AnsiString', iptrw);
    RegisterProperty('ByNameAsSmallint', 'Smallint AnsiString', iptrw);
    RegisterProperty('ByNameAsInteger', 'Integer AnsiString', iptrw);
    RegisterProperty('ByNameAsSingle', 'Single AnsiString', iptrw);
    RegisterProperty('ByNameAsDouble', 'Double AnsiString', iptrw);
    RegisterProperty('ByNameAsCurrency', 'Currency AnsiString', iptrw);
    RegisterProperty('ByNameAsInt64', 'Int64 AnsiString', iptrw);
    RegisterProperty('ByNameAsAnsiString', 'AnsiString AnsiString', iptrw);
    RegisterProperty('ByNameAsQuad', 'TISCQuad AnsiString', iptrw);
    RegisterProperty('ByNameAsDateTime', 'TDateTime AnsiString', iptrw);
    RegisterProperty('ByNameAsBoolean', 'Boolean AnsiString', iptrw);
    RegisterProperty('ByNameAsDate', 'Integer AnsiString', iptrw);
    RegisterProperty('ByNameAsTime', 'Cardinal AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXPoolStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TALFBXPoolStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TALFBXPoolStream') do begin
    RegisterMethod('Constructor Create( ItemsInPage, ItemSize : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function SeekTo( Item : Integer) : Longint');
    RegisterMethod('Function Get( Item : Integer) : Pointer');
    RegisterMethod('Function Add : Pointer');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : AnsiString)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const FileName : AnsiString)');
    RegisterProperty('ItemsInPage', 'Integer', iptrw);
    RegisterProperty('ItemSize', 'Integer', iptrw);
    RegisterProperty('PageSize', 'Integer', iptrw);
    RegisterProperty('ItemCount', 'Integer', iptrw);
    RegisterProperty('Items', '___Pointer integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALFBXSQLDA(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TALFBXSQLDA') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TALFBXSQLDA') do begin
    RegisterMethod('Constructor Create( aCharacterSet : TALFBXCharacterSet)');
    RegisterMethod('Procedure CheckRange( const Index : Word)');
    RegisterMethod('Function GetFieldIndex( const name : AnsiString) : Word');
    RegisterMethod('Function TryGetFieldIndex( const name : AnsiString; out index : Word) : Boolean');
    RegisterProperty('Data', 'PALFBXSQLDaData', iptrw);
    RegisterProperty('IsBlob', 'boolean Word', iptrw);
    RegisterProperty('IsBlobText', 'boolean Word', iptrw);
    RegisterProperty('IsNullable', 'boolean Word', iptrw);
    RegisterProperty('IsNumeric', 'boolean Word', iptrw);
    RegisterProperty('FieldCount', 'Integer', iptrw);
    RegisterProperty('SQLType', 'Smallint Word', iptrw);
    RegisterProperty('SQLLen', 'Smallint Word', iptrw);
    RegisterProperty('SQLScale', 'Smallint Word', iptrw);
    RegisterProperty('FieldType', 'TALFBXFieldType Word', iptrw);
    RegisterProperty('CharacterSet', 'TALFBXCharacterSet', iptrw);
    RegisterProperty('IsNull', 'boolean Word', iptrw);
    RegisterProperty('AsSmallint', 'Smallint Word', iptrw);
    RegisterProperty('AsInteger', 'Integer Word', iptrw);
    RegisterProperty('AsSingle', 'Single Word', iptrw);
    RegisterProperty('AsDouble', 'Double Word', iptrw);
    RegisterProperty('AsCurrency', 'Currency Word', iptrw);
    RegisterProperty('AsInt64', 'Int64 Word', iptrw);
    RegisterProperty('AsAnsiString', 'AnsiString Word', iptrw);
    RegisterProperty('AsQuad', 'TISCQuad Word', iptrw);
    RegisterProperty('AsDateTime', 'TDateTime Word', iptrw);
    RegisterProperty('AsBoolean', 'Boolean Word', iptrw);
    RegisterProperty('AsDate', 'Integer Word', iptrw);
    RegisterProperty('AsTime', 'Cardinal Word', iptrw);
    RegisterProperty('ByNameIsBlob', 'boolean AnsiString', iptrw);
    RegisterProperty('ByNameIsBlobText', 'boolean AnsiString', iptrw);
    RegisterProperty('ByNameIsNull', 'boolean AnsiString', iptrw);
    RegisterProperty('ByNameAsSmallint', 'Smallint AnsiString', iptrw);
    RegisterProperty('ByNameAsInteger', 'Integer AnsiString', iptrw);
    RegisterProperty('ByNameAsSingle', 'Single AnsiString', iptrw);
    RegisterProperty('ByNameAsDouble', 'Double AnsiString', iptrw);
    RegisterProperty('ByNameAsCurrency', 'Currency AnsiString', iptrw);
    RegisterProperty('ByNameAsInt64', 'Int64 AnsiString', iptrw);
    RegisterProperty('ByNameAsAnsiString', 'AnsiString AnsiString', iptrw);
    RegisterProperty('ByNameAsQuad', 'TISCQuad AnsiString', iptrw);
    RegisterProperty('ByNameAsDateTime', 'TDateTime AnsiString', iptrw);
    RegisterProperty('ByNameAsBoolean', 'Boolean AnsiString', iptrw);
    RegisterProperty('ByNameAsDate', 'Integer AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EALFBXException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EALFBXError', 'EALFBXException') do
  with CL.AddClassN(CL.FindClass('EALFBXError'),'EALFBXException') do
  begin
    RegisterProperty('Number', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EALFBXError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EALFBXError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EALFBXError') do begin
    RegisterProperty('ErrorCode', 'Integer', iptrw);
    RegisterProperty('SQLCode', 'Integer', iptrw);
    RegisterProperty('GDSCode', 'Integer', iptrw);
    RegisterProperty('SQLState', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFBXLib(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TALFBXFieldType', '( uftUnKnown, uftNumeric, uftChar, uftVarchar'
   +', uftCstring, uftSmallint, uftInteger, uftQuad, uftFloat, uftDoublePrecisi'
   +'on, uftTimestamp, uftBlob, uftBlobId, uftDate, uftTime, uftInt64, uftArray, uftNull )');
  CL.AddTypeS('TALFBXScale', 'Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXConvertError');
  SIRegister_EALFBXError(CL);
  SIRegister_EALFBXException(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXGFixError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXDSQLError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXDynError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXGBakError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXGSecError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXLicenseError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALFBXGStatError');
  //CL.AddTypeS('EALFBXExceptionClass', 'class of EALFBXError');

  {ISC_ARRAY_BOUND = record
    array_bound_lower: Smallint;
    array_bound_upper: Smallint;
  end;
  TISCArrayBound = ISC_ARRAY_BOUND;}

  CL.AddTypeS('ISC_ARRAY_BOUND', 'record array_bound_lower: Smallint; array_bound_upper: Smallint; end');
  CL.AddTypeS('TISCArrayBound','ISC_ARRAY_BOUND');
  CL.AddTypeS('ISC_ARRAY_DESC','record array_desc_dtype: byte; array_desc_scale: byte; array_desc_length: Word; array_desc_field_name: array [0..32 - 1] of Char;'+
             'array_desc_relation_name: array [0..32 - 1] of Char; array_desc_dimensions: Smallint; array_desc_bounds: array [0..15] of TISCArrayBound; end');
  {  ISC_ARRAY_DESC = record
    array_desc_dtype: byte;
    array_desc_scale: byte;
    array_desc_length: Word;
    array_desc_field_name: array [0..METADATALENGTH - 1] of AnsiChar;
    array_desc_relation_name: array [0..METADATALENGTH - 1] of AnsiChar;
    array_desc_dimensions: Smallint;
    array_desc_flags: Smallint;
    array_desc_bounds: array [0..15] of TISCArrayBound;
  end; }
  CL.AddTypeS('TISCArrayDesc','ISC_ARRAY_DESC');

  CL.AddTypeS('TALFBXCharacterSet', '( csNONE, csASCII, csBIG_5, csCYRL, csDOS4'
   +'37, csDOS850, csDOS852, csDOS857, csDOS860, csDOS861, csDOS863, csDOS865, '
   +'csEUCJ_0208, csGB_2312, csISO8859_1, csISO8859_2, csKSC_5601, csNEXT, csOC'
   +'TETS, csSJIS_0208, csUNICODE_FSS, csUTF8, csWIN1250, csWIN1251, csWIN1252,'
   +' csWIN1253, csWIN1254, csDOS737, csDOS775, csDOS858, csDOS862, csDOS864, c'
   +'sDOS866, csDOS869, csWIN1255, csWIN1256, csWIN1257, csISO8859_3, csISO8859'
   +'_4, csISO8859_5, csISO8859_6, csISO8859_7, csISO8859_8, csISO8859_9, csISO'
   +'8859_13, csKOI8R, csKOI8U, csWIN1258, csTIS620, csGBK, csCP943C )');
  CL.AddTypeS('TALFBXTransParam', '( tpConsistency, tpConcurrency, tpShared, tp'
   +'Protected, tpExclusive, tpWait, tpNowait, tpRead, tpWrite, tpLockRead, tpL'
   +'ockWrite, tpVerbTime, tpCommitTime, tpIgnoreLimbo, tpReadCommitted, tpAuto'
   +'Commit, tpRecVersion, tpNoRecVersion, tpRestartRequests, tpNoAutoUndo, tpLockTimeout )');
  CL.AddTypeS('TALFBXTransParams', 'set of TALFBXTransParam');
 CL.AddDelphiFunction('Function ALFBXStrToCharacterSet( const CharacterSet : AnsiString) : TALFBXCharacterSet');
 CL.AddDelphiFunction('Function ALFBXCreateDBParams( Params : AnsiString; Delimiter : Char) : AnsiString');
 CL.AddDelphiFunction('Function ALFBXCreateBlobParams( Params : AnsiString; Delimiter : Char) : AnsiString');
 CL.AddConstantN('cALFBXMaxParamLength','LongInt').SetInt( 125);
  CL.AddTypeS('TALFBXParamsFlag', '( pfNotInitialized, pfNotNullable )');
  CL.AddTypeS('TALFBXParamsFlags', 'set of TALFBXParamsFlag');
  //CL.AddTypeS('PALFBXSQLVar', '^TALFBXSQLVar // will not work');
  //CL.AddTypeS('PALFBXSQLDaData', '^TALFBXSQLDaData // will not work');
  CL.AddTypeS('TALFBXStatementType', '( stSelect, stInsert, stUpdate, stDelete,'
   +' stDDL, stGetSegment, stPutSegment, stExecProcedure, stStartTrans, stCommi'
   +'t, stRollback, stSelectForUpdate, stSetGenerator, stSavePoint )');
  SIRegister_TALFBXSQLDA(CL);
  //CL.AddTypeS('PALFBXPtrArray', '^TALFBXPtrArray // will not work');
  SIRegister_TALFBXPoolStream(CL);
  //CL.AddTypeS('PALFBXBlobData', '^TALFBXBlobData // will not work');
  CL.AddTypeS('TALFBXBlobData', 'record Size : Integer; Buffer : string; end');
  //CL.AddTypeS('PALFBXArrayDesc', '^TALFBXArrayDesc // will not work');
  CL.AddTypeS('TALFBXArrayDesc', 'TISCArrayDesc');
  //CL.AddTypeS('TALFBXBlobDesc', 'TISCBlobDesc');
  //CL.AddTypeS('PALFBXArrayInfo', '^TALFBXArrayInfo // will not work');
  CL.AddTypeS('TALFBXArrayInfo', 'record index : Integer; size : integer; info: TALFBXArrayDesc; end');
  SIRegister_TALFBXSQLResult(CL);
  //CL.AddTypeS('TALFBXSQLResultClass', 'class of TALFBXSQLResult');
  SIRegister_TALFBXSQLParams(CL);
  //CL.AddTypeS('TALFBXSQLParamsClass', 'class of TALFBXSQLParams');
  CL.AddTypeS('TALFBXDSQLInfoData', 'record InfoCode : byte; InfoLen : Word; St'
   +'atementType : TALFBXStatementType; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALFBXLibrary');
  //CL.AddTypeS('PALFBXStatusVector', '^TALFBXStatusVector // will not work');
  CL.AddTypeS('TALFBXOnConnectionLost', 'Procedure ( Lib : TALFBXLibrary)');
  //CL.AddTypeS('TALFBXOnGetDBExceptionClass', 'Procedure ( Number : Integer; out'
   //+' Excep : EALFBXExceptionClass)');
  SIRegister_TALFBXLibrary(CL);
 CL.AddConstantN('cAlFBXDateOffset','LongInt').SetInt( 15018);
 CL.AddConstantN('cALFBXTimeCoeff','LongInt').SetInt( 864000000);
 //CL.AddDelphiFunction('Procedure ALFBXDecodeTimeStamp( v : PISCTimeStamp; out DateTime : Double);');
 //CL.AddDelphiFunction('Procedure ALFBXDecodeTimeStamp1( v : PISCTimeStamp; out TimeStamp : TTimeStamp);');
 //CL.AddDelphiFunction('Function ALFBXDecodeTimeStamp2( v : PISCTimeStamp) : Double;');
 CL.AddDelphiFunction('Procedure ALFBXDecodeSQLDate( v : Integer; out Year : SmallInt; out Month, Day : Word)');
 CL.AddDelphiFunction('Procedure ALFBXDecodeSQLTime( v : Cardinal; out Hour, Minute, Second : Word; out Fractions : LongWord)');
 //CL.AddDelphiFunction('Procedure ALFBXEncodeTimeStamp( const DateTime : TDateTime; v : PISCTimeStamp);');
 //CL.AddDelphiFunction('Procedure ALFBXEncodeTimeStamp1( const Date : Integer; v : PISCTimeStamp);');
 //CL.AddDelphiFunction('Procedure ALFBXEncodeTimeStamp2( const Time : Cardinal; v : PISCTimeStamp);');
 CL.AddDelphiFunction('Function ALFBXEncodeSQLDate( Year : Integer; Month, Day : Integer) : Integer');
 CL.AddDelphiFunction('Function ALFBXEncodeSQLTime( Hour, Minute, Second : Word; var Fractions : LongWord) : Cardinal');
  CL.AddTypeS('TALFBXParamType', '( prNone, prByte, prShrt, prCard, prStrg, prIgno )');
  CL.AddTypeS('TALFBXDPBInfo', 'record Name : AnsiString; ParamType : TALFBXParamType; end');
 CL.AddDelphiFunction('Function ALFBXSQLQuote( const name : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ALFBXSQLUnQuote( const name : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure ALFBXEncodeTimeStamp2_P( const Time : Cardinal; v : PISCTimeStamp);
Begin ALFBXLib.ALFBXEncodeTimeStamp(Time, v); END;

(*----------------------------------------------------------------------------*)
Procedure ALFBXEncodeTimeStamp1_P( const Date : Integer; v : PISCTimeStamp);
Begin ALFBXLib.ALFBXEncodeTimeStamp(Date, v); END;

(*----------------------------------------------------------------------------*)
Procedure ALFBXEncodeTimeStamp_P( const DateTime : TDateTime; v : PISCTimeStamp);
Begin ALFBXLib.ALFBXEncodeTimeStamp(DateTime, v); END;

(*----------------------------------------------------------------------------*)
Function ALFBXDecodeTimeStamp1_P( v : PISCTimeStamp) : Double;
Begin Result := ALFBXLib.ALFBXDecodeTimeStamp(v); END;

(*----------------------------------------------------------------------------*)
Procedure ALFBXDecodeTimeStamp_P( v : PISCTimeStamp; out TimeStamp : TTimeStamp);
Begin ALFBXLib.ALFBXDecodeTimeStamp(v, TimeStamp); END;

(*----------------------------------------------------------------------------*)
Procedure ALFBXDecodeTimeStampP1( v : PISCTimeStamp; out DateTime : Double);
Begin ALFBXLib.ALFBXDecodeTimeStamp(v, DateTime); END;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibrarySegMentSize_W(Self: TALFBXLibrary; const T: Word);
begin Self.SegMentSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibrarySegMentSize_R(Self: TALFBXLibrary; var T: Word);
begin T := Self.SegMentSize; end;

(*----------------------------------------------------------------------------*)
Procedure TALFBXLibraryBlobWriteString_P(Self: TALFBXLibrary;  var BlobHandle : IscBlobHandle; const Str : AnsiString);
Begin Self.BlobWriteString(BlobHandle, Str); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXLibraryBlobReadSizedBuffer1_P(Self: TALFBXLibrary;  var BlobHandle : IscBlobHandle; Buffer : Pointer; MaxSize : Integer);
Begin Self.BlobReadSizedBuffer(BlobHandle, Buffer, MaxSize); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXLibraryBlobReadSizedBuffer_P(Self: TALFBXLibrary;  var BlobHandle : IscBlobHandle; Buffer : Pointer);
Begin Self.BlobReadSizedBuffer(BlobHandle, Buffer); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXLibraryBlobReadString1_P(Self: TALFBXLibrary;  var BlobHandle : IscBlobHandle; var Str : AnsiString);
Begin Self.BlobReadString(BlobHandle, Str); END;

(*----------------------------------------------------------------------------*)
Function TALFBXLibraryBlobReadString_P(Self: TALFBXLibrary;  var BlobHandle : IscBlobHandle) : AnsiString;
Begin Result := Self.BlobReadString(BlobHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXLibraryDSQLExecuteImmediate1_P(Self: TALFBXLibrary;  const Statement : AnsiString; Dialect : Word; Sqlda : TALFBXSQLDA);
Begin Self.DSQLExecuteImmediate(Statement, Dialect, Sqlda); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXLibraryDSQLExecuteImmediate_P(Self: TALFBXLibrary;  var DBHandle : IscDbHandle; var TraHandle : IscTrHandle; const Statement : AnsiString; Dialect : Word; Sqlda : TALFBXSQLDA);
Begin Self.DSQLExecuteImmediate(DBHandle, TraHandle, Statement, Dialect, Sqlda); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXLibraryDatabaseInfo_P(Self: TALFBXLibrary;  var DBHandle : IscDbHandle; const Items : AnsiString; var Buffer : AnsiString);
Begin Self.DatabaseInfo(DBHandle, Items, Buffer); END;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibraryRaiseErrors_W(Self: TALFBXLibrary; const T: boolean);
begin Self.RaiseErrors := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibraryRaiseErrors_R(Self: TALFBXLibrary; var T: boolean);
begin T := Self.RaiseErrors; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibraryOnGetDBExceptionClass_W(Self: TALFBXLibrary; const T: TALFBXOnGetDBExceptionClass);
begin Self.OnGetDBExceptionClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibraryOnGetDBExceptionClass_R(Self: TALFBXLibrary; var T: TALFBXOnGetDBExceptionClass);
begin T := Self.OnGetDBExceptionClass; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibraryOnConnectionLost_W(Self: TALFBXLibrary; const T: TALFBXOnConnectionLost);
begin Self.OnConnectionLost := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXLibraryOnConnectionLost_R(Self: TALFBXLibrary; var T: TALFBXOnConnectionLost);
begin T := Self.OnConnectionLost; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLParamsMaxSqlLen_R(Self: TALFBXSQLParams; var T: Smallint; const t1: Word);
begin T := Self.MaxSqlLen[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLParamsParamCount_R(Self: TALFBXSQLParams; var T: Word);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLParamsFieldName_R(Self: TALFBXSQLParams; var T: AnsiString; const t1: Word);
begin T := Self.FieldName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsTime_R(Self: TALFBXSQLResult; var T: Cardinal; const t1: AnsiString);
begin T := Self.ByNameAsTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsDate_R(Self: TALFBXSQLResult; var T: Integer; const t1: AnsiString);
begin T := Self.ByNameAsDate[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsBoolean_R(Self: TALFBXSQLResult; var T: Boolean; const t1: AnsiString);
begin T := Self.ByNameAsBoolean[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsDateTime_R(Self: TALFBXSQLResult; var T: TDateTime; const t1: AnsiString);
begin T := Self.ByNameAsDateTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsQuad_R(Self: TALFBXSQLResult; var T: TISCQuad; const t1: AnsiString);
begin T := Self.ByNameAsQuad[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsAnsiString_R(Self: TALFBXSQLResult; var T: AnsiString; const t1: AnsiString);
begin T := Self.ByNameAsAnsiString[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsInt64_R(Self: TALFBXSQLResult; var T: Int64; const t1: AnsiString);
begin T := Self.ByNameAsInt64[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsCurrency_R(Self: TALFBXSQLResult; var T: Currency; const t1: AnsiString);
begin T := Self.ByNameAsCurrency[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsDouble_R(Self: TALFBXSQLResult; var T: Double; const t1: AnsiString);
begin T := Self.ByNameAsDouble[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsSingle_R(Self: TALFBXSQLResult; var T: Single; const t1: AnsiString);
begin T := Self.ByNameAsSingle[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsInteger_R(Self: TALFBXSQLResult; var T: Integer; const t1: AnsiString);
begin T := Self.ByNameAsInteger[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameAsSmallint_R(Self: TALFBXSQLResult; var T: Smallint; const t1: AnsiString);
begin T := Self.ByNameAsSmallint[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameIsNullable_R(Self: TALFBXSQLResult; var T: boolean; const t1: AnsiString);
begin T := Self.ByNameIsNullable[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultByNameIsNull_R(Self: TALFBXSQLResult; var T: boolean; const t1: AnsiString);
begin T := Self.ByNameIsNull[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsBoolean_R(Self: TALFBXSQLResult; var T: Boolean; const t1: Word);
begin T := Self.AsBoolean[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsTime_R(Self: TALFBXSQLResult; var T: Cardinal; const t1: Word);
begin T := Self.AsTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsDate_R(Self: TALFBXSQLResult; var T: Integer; const t1: Word);
begin T := Self.AsDate[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsDateTime_R(Self: TALFBXSQLResult; var T: TDateTime; const t1: Word);
begin T := Self.AsDateTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsAnsiString_R(Self: TALFBXSQLResult; var T: AnsiString; const t1: Word);
begin T := Self.AsAnsiString[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsInt64_R(Self: TALFBXSQLResult; var T: Int64; const t1: Word);
begin T := Self.AsInt64[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsCurrency_R(Self: TALFBXSQLResult; var T: Currency; const t1: Word);
begin T := Self.AsCurrency[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsDouble_R(Self: TALFBXSQLResult; var T: Double; const t1: Word);
begin T := Self.AsDouble[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsSingle_R(Self: TALFBXSQLResult; var T: Single; const t1: Word);
begin T := Self.AsSingle[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsInteger_R(Self: TALFBXSQLResult; var T: Integer; const t1: Word);
begin T := Self.AsInteger[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAsSmallint_R(Self: TALFBXSQLResult; var T: Smallint; const t1: Word);
begin T := Self.AsSmallint[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultAliasName_R(Self: TALFBXSQLResult; var T: AnsiString; const t1: Word);
begin T := Self.AliasName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultOwnName_R(Self: TALFBXSQLResult; var T: AnsiString; const t1: Word);
begin T := Self.OwnName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultRelName_R(Self: TALFBXSQLResult; var T: AnsiString; const t1: Word);
begin T := Self.RelName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultSqlName_R(Self: TALFBXSQLResult; var T: AnsiString; const t1: Word);
begin T := Self.SqlName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultUniqueRelationName_R(Self: TALFBXSQLResult; var T: AnsiString);
begin T := Self.UniqueRelationName; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultBufferChunks_R(Self: TALFBXSQLResult; var T: Cardinal);
begin T := Self.BufferChunks; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultCurrentRecord_W(Self: TALFBXSQLResult; const T: Integer);
begin Self.CurrentRecord := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultCurrentRecord_R(Self: TALFBXSQLResult; var T: Integer);
begin T := Self.CurrentRecord; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultRecordCount_R(Self: TALFBXSQLResult; var T: Integer);
begin T := Self.RecordCount; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultFetchBlobs_R(Self: TALFBXSQLResult; var T: boolean);
begin T := Self.FetchBlobs; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultCachedFetch_R(Self: TALFBXSQLResult; var T: boolean);
begin T := Self.CachedFetch; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultBof_R(Self: TALFBXSQLResult; var T: boolean);
begin T := Self.Bof; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultScrollEOF_R(Self: TALFBXSQLResult; var T: boolean);
begin T := Self.ScrollEOF; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultEof_R(Self: TALFBXSQLResult; var T: boolean);
begin T := Self.Eof; end;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLResultReadBlob3_P(Self: TALFBXSQLResult;  const name : AnsiString; Data : Pointer);
Begin Self.ReadBlob(name, Data); END;

(*----------------------------------------------------------------------------*)
Function TALFBXSQLResultReadBlobA4_P(Self: TALFBXSQLResult;  const name : AnsiString) : AnsiString;
Begin Result := Self.ReadBlobA(name); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLResultReadBlobA3_P(Self: TALFBXSQLResult;  const name : AnsiString; var str : AnsiString);
Begin Self.ReadBlobA(name, str); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLResultReadBlob2_P(Self: TALFBXSQLResult;  const name : AnsiString; Stream : TStream);
Begin Self.ReadBlob(name, Stream); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLResultReadBlob1_P(Self: TALFBXSQLResult;  const Index : Word; Data : Pointer);
Begin Self.ReadBlob(Index, Data); END;

(*----------------------------------------------------------------------------*)
Function TALFBXSQLResultReadBlobA1_P(Self: TALFBXSQLResult;  const Index : Word) : AnsiString;
Begin Result := Self.ReadBlobA(Index); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLResultReadBlobA_P(Self: TALFBXSQLResult;  const Index : Word; var str : AnsiString);
Begin Self.ReadBlobA(Index, str); END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLResultReadBlob_P(Self: TALFBXSQLResult;  const Index : Word; Stream : TStream);
Begin Self.ReadBlob(Index, Stream); END;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultArrayCount_R(Self: TALFBXSQLResult; var T: Word);
begin T := Self.ArrayCount; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultArrayInfos_R(Self: TALFBXSQLResult; var T: PALFBXArrayInfo; const t1: word);
begin T := Self.ArrayInfos[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultArrayData_R(Self: TALFBXSQLResult; var T: Pointer; const t1: word);
begin T := Self.ArrayData[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLResultBlobData_R(Self: TALFBXSQLResult; var T: PALFBXBlobData; const t1: word);
begin T := Self.BlobData[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXPoolStreamItems_R(Self: TALFBXPoolStream; var T: Pointer; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXPoolStreamItemCount_R(Self: TALFBXPoolStream; var T: Integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXPoolStreamPageSize_R(Self: TALFBXPoolStream; var T: Integer);
begin T := Self.PageSize; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXPoolStreamItemSize_R(Self: TALFBXPoolStream; var T: Integer);
begin T := Self.ItemSize; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXPoolStreamItemsInPage_R(Self: TALFBXPoolStream; var T: Integer);
begin T := Self.ItemsInPage; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsDate_W(Self: TALFBXSQLDA; const T: Integer; const t1: AnsiString);
begin Self.ByNameAsDate[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsDate_R(Self: TALFBXSQLDA; var T: Integer; const t1: AnsiString);
begin T := Self.ByNameAsDate[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsBoolean_W(Self: TALFBXSQLDA; const T: Boolean; const t1: AnsiString);
begin Self.ByNameAsBoolean[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsBoolean_R(Self: TALFBXSQLDA; var T: Boolean; const t1: AnsiString);
begin T := Self.ByNameAsBoolean[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsDateTime_W(Self: TALFBXSQLDA; const T: TDateTime; const t1: AnsiString);
begin Self.ByNameAsDateTime[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsDateTime_R(Self: TALFBXSQLDA; var T: TDateTime; const t1: AnsiString);
begin T := Self.ByNameAsDateTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsQuad_W(Self: TALFBXSQLDA; const T: TISCQuad; const t1: AnsiString);
begin Self.ByNameAsQuad[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsQuad_R(Self: TALFBXSQLDA; var T: TISCQuad; const t1: AnsiString);
begin T := Self.ByNameAsQuad[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsAnsiString_W(Self: TALFBXSQLDA; const T: AnsiString; const t1: AnsiString);
begin Self.ByNameAsAnsiString[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsAnsiString_R(Self: TALFBXSQLDA; var T: AnsiString; const t1: AnsiString);
begin T := Self.ByNameAsAnsiString[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsInt64_W(Self: TALFBXSQLDA; const T: Int64; const t1: AnsiString);
begin Self.ByNameAsInt64[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsInt64_R(Self: TALFBXSQLDA; var T: Int64; const t1: AnsiString);
begin T := Self.ByNameAsInt64[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsCurrency_W(Self: TALFBXSQLDA; const T: Currency; const t1: AnsiString);
begin Self.ByNameAsCurrency[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsCurrency_R(Self: TALFBXSQLDA; var T: Currency; const t1: AnsiString);
begin T := Self.ByNameAsCurrency[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsDouble_W(Self: TALFBXSQLDA; const T: Double; const t1: AnsiString);
begin Self.ByNameAsDouble[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsDouble_R(Self: TALFBXSQLDA; var T: Double; const t1: AnsiString);
begin T := Self.ByNameAsDouble[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsSingle_W(Self: TALFBXSQLDA; const T: Single; const t1: AnsiString);
begin Self.ByNameAsSingle[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsSingle_R(Self: TALFBXSQLDA; var T: Single; const t1: AnsiString);
begin T := Self.ByNameAsSingle[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsInteger_W(Self: TALFBXSQLDA; const T: Integer; const t1: AnsiString);
begin Self.ByNameAsInteger[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsInteger_R(Self: TALFBXSQLDA; var T: Integer; const t1: AnsiString);
begin T := Self.ByNameAsInteger[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsSmallint_W(Self: TALFBXSQLDA; const T: Smallint; const t1: AnsiString);
begin Self.ByNameAsSmallint[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameAsSmallint_R(Self: TALFBXSQLDA; var T: Smallint; const t1: AnsiString);
begin T := Self.ByNameAsSmallint[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameIsNull_W(Self: TALFBXSQLDA; const T: boolean; const t1: AnsiString);
begin Self.ByNameIsNull[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameIsNull_R(Self: TALFBXSQLDA; var T: boolean; const t1: AnsiString);
begin T := Self.ByNameIsNull[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameIsBlobText_R(Self: TALFBXSQLDA; var T: boolean; const t1: AnsiString);
begin T := Self.ByNameIsBlobText[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAByNameIsBlob_R(Self: TALFBXSQLDA; var T: boolean; const t1: AnsiString);
begin T := Self.ByNameIsBlob[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsTime_W(Self: TALFBXSQLDA; const T: Cardinal; const t1: Word);
begin Self.AsTime[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsTime_R(Self: TALFBXSQLDA; var T: Cardinal; const t1: Word);
begin T := Self.AsTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsDate_W(Self: TALFBXSQLDA; const T: Integer; const t1: Word);
begin Self.AsDate[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsDate_R(Self: TALFBXSQLDA; var T: Integer; const t1: Word);
begin T := Self.AsDate[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsBoolean_W(Self: TALFBXSQLDA; const T: Boolean; const t1: Word);
begin Self.AsBoolean[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsBoolean_R(Self: TALFBXSQLDA; var T: Boolean; const t1: Word);
begin T := Self.AsBoolean[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsDateTime_W(Self: TALFBXSQLDA; const T: TDateTime; const t1: Word);
begin Self.AsDateTime[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsDateTime_R(Self: TALFBXSQLDA; var T: TDateTime; const t1: Word);
begin T := Self.AsDateTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsQuad_W(Self: TALFBXSQLDA; const T: TISCQuad; const t1: Word);
begin Self.AsQuad[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsQuad_R(Self: TALFBXSQLDA; var T: TISCQuad; const t1: Word);
begin T := Self.AsQuad[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsAnsiString_W(Self: TALFBXSQLDA; const T: AnsiString; const t1: Word);
begin Self.AsAnsiString[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsAnsiString_R(Self: TALFBXSQLDA; var T: AnsiString; const t1: Word);
begin T := Self.AsAnsiString[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsInt64_W(Self: TALFBXSQLDA; const T: Int64; const t1: Word);
begin Self.AsInt64[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsInt64_R(Self: TALFBXSQLDA; var T: Int64; const t1: Word);
begin T := Self.AsInt64[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsCurrency_W(Self: TALFBXSQLDA; const T: Currency; const t1: Word);
begin Self.AsCurrency[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsCurrency_R(Self: TALFBXSQLDA; var T: Currency; const t1: Word);
begin T := Self.AsCurrency[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsDouble_W(Self: TALFBXSQLDA; const T: Double; const t1: Word);
begin Self.AsDouble[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsDouble_R(Self: TALFBXSQLDA; var T: Double; const t1: Word);
begin T := Self.AsDouble[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsSingle_W(Self: TALFBXSQLDA; const T: Single; const t1: Word);
begin Self.AsSingle[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsSingle_R(Self: TALFBXSQLDA; var T: Single; const t1: Word);
begin T := Self.AsSingle[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsInteger_W(Self: TALFBXSQLDA; const T: Integer; const t1: Word);
begin Self.AsInteger[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsInteger_R(Self: TALFBXSQLDA; var T: Integer; const t1: Word);
begin T := Self.AsInteger[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsSmallint_W(Self: TALFBXSQLDA; const T: Smallint; const t1: Word);
begin Self.AsSmallint[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAAsSmallint_R(Self: TALFBXSQLDA; var T: Smallint; const t1: Word);
begin T := Self.AsSmallint[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAIsNull_W(Self: TALFBXSQLDA; const T: boolean; const t1: Word);
begin Self.IsNull[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAIsNull_R(Self: TALFBXSQLDA; var T: boolean; const t1: Word);
begin T := Self.IsNull[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDACharacterSet_W(Self: TALFBXSQLDA; const T: TALFBXCharacterSet);
begin Self.CharacterSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDACharacterSet_R(Self: TALFBXSQLDA; var T: TALFBXCharacterSet);
begin T := Self.CharacterSet; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAFieldType_R(Self: TALFBXSQLDA; var T: TALFBXFieldType; const t1: Word);
begin T := Self.FieldType[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDASQLScale_R(Self: TALFBXSQLDA; var T: Smallint; const t1: Word);
begin T := Self.SQLScale[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDASQLLen_R(Self: TALFBXSQLDA; var T: Smallint; const t1: Word);
begin T := Self.SQLLen[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDASQLType_R(Self: TALFBXSQLDA; var T: Smallint; const t1: Word);
begin T := Self.SQLType[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAFieldCount_R(Self: TALFBXSQLDA; var T: Integer);
begin T := Self.FieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAIsNumeric_R(Self: TALFBXSQLDA; var T: boolean; const t1: Word);
begin T := Self.IsNumeric[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAIsNullable_R(Self: TALFBXSQLDA; var T: boolean; const t1: Word);
begin T := Self.IsNullable[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAIsBlobText_R(Self: TALFBXSQLDA; var T: boolean; const t1: Word);
begin T := Self.IsBlobText[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAIsBlob_R(Self: TALFBXSQLDA; var T: boolean; const t1: Word);
begin T := Self.IsBlob[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALFBXSQLDAData_R(Self: TALFBXSQLDA; var T: PALFBXSQLDaData);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
Function TALFBXSQLDADecodeStringA1_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word) : AnsiString;
Begin //Result := Self.DecodeStringA(Code, Index);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDADecodeStringA_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out Str : AnsiString);
Begin //Self.DecodeStringA(Code, Index, Str);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString8_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : Cardinal);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString7_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : boolean);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString6_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : Currency);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString5_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : TDateTime);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString4_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : Smallint);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString3_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : Single);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString2_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : Integer);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString1_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : Double);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
Procedure TALFBXSQLDAConvertString_P(Self: TALFBXSQLDA;  const Code : Smallint; Index : Word; out value : Int64);
Begin //Self.ConvertString(Code, Index, value);
END;

(*----------------------------------------------------------------------------*)
procedure EALFBXExceptionNumber_R(Self: EALFBXException; var T: Integer);
begin T := Self.Number; end;

(*----------------------------------------------------------------------------*)
procedure EALFBXErrorSQLState_R(Self: EALFBXError; var T: AnsiString);
begin T := Self.SQLState; end;

(*----------------------------------------------------------------------------*)
procedure EALFBXErrorGDSCode_R(Self: EALFBXError; var T: Integer);
begin T := Self.GDSCode; end;

(*----------------------------------------------------------------------------*)
procedure EALFBXErrorSQLCode_R(Self: EALFBXError; var T: Integer);
begin T := Self.SQLCode; end;

(*----------------------------------------------------------------------------*)
procedure EALFBXErrorErrorCode_R(Self: EALFBXError; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXLibrary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXLibrary) do begin
    RegisterConstructor(@TALFBXLibrary.Create, 'Create');
    RegisterMethod(@TALFBXLibrary.Destroy, 'Free');
    RegisterMethod(@TALFBXLibrary.CheckFBXApiCall, 'CheckFBXApiCall');
    RegisterPropertyHelper(@TALFBXLibraryOnConnectionLost_R,@TALFBXLibraryOnConnectionLost_W,'OnConnectionLost');
    RegisterPropertyHelper(@TALFBXLibraryOnGetDBExceptionClass_R,@TALFBXLibraryOnGetDBExceptionClass_W,'OnGetDBExceptionClass');
    RegisterPropertyHelper(@TALFBXLibraryRaiseErrors_R,@TALFBXLibraryRaiseErrors_W,'RaiseErrors');
    RegisterMethod(@TALFBXLibrary.ServerShutdown, 'ServerShutdown');
    RegisterMethod(@TALFBXLibrary.ServerShutdownCallback, 'ServerShutdownCallback');
    RegisterMethod(@TALFBXLibrary.AttachDatabase, 'AttachDatabase');
    RegisterMethod(@TALFBXLibrary.DetachDatabase, 'DetachDatabase');
    RegisterMethod(@TALFBXLibraryDatabaseInfo_P, 'DatabaseInfo');
    RegisterMethod(@TALFBXLibrary.DatabaseInfoIntValue, 'DatabaseInfoIntValue');
    RegisterMethod(@TALFBXLibrary.DatabaseInfoString, 'DatabaseInfoString');
    RegisterMethod(@TALFBXLibrary.DatabaseInfoDateTime, 'DatabaseInfoDateTime');
    RegisterMethod(@TALFBXLibrary.DatabaseDrop, 'DatabaseDrop');
    RegisterMethod(@TALFBXLibrary.DatabaseCancelOperation, 'DatabaseCancelOperation');
    RegisterMethod(@TALFBXLibrary.TransactionStart, 'TransactionStart');
    RegisterMethod(@TALFBXLibrary.TransactionStartMultiple, 'TransactionStartMultiple');
    RegisterMethod(@TALFBXLibrary.TransactionCommit, 'TransactionCommit');
    RegisterMethod(@TALFBXLibrary.TransactionRollback, 'TransactionRollback');
    RegisterMethod(@TALFBXLibrary.TransactionCommitRetaining, 'TransactionCommitRetaining');
    RegisterMethod(@TALFBXLibrary.TransactionPrepare, 'TransactionPrepare');
    RegisterMethod(@TALFBXLibrary.TransactionRollbackRetaining, 'TransactionRollbackRetaining');
    RegisterMethod(@TALFBXLibrary.TransactionGetId, 'TransactionGetId');
    RegisterMethod(@TALFBXLibraryDSQLExecuteImmediate_P, 'DSQLExecuteImmediate');
    RegisterMethod(@TALFBXLibraryDSQLExecuteImmediate1_P, 'DSQLExecuteImmediate1');
    RegisterMethod(@TALFBXLibrary.DSQLAllocateStatement, 'DSQLAllocateStatement');
    RegisterMethod(@TALFBXLibrary.DSQLPrepare, 'DSQLPrepare');
    RegisterMethod(@TALFBXLibrary.DSQLExecute, 'DSQLExecute');
    RegisterMethod(@TALFBXLibrary.DSQLExecute2, 'DSQLExecute2');
    RegisterMethod(@TALFBXLibrary.DSQLFreeStatement, 'DSQLFreeStatement');
    RegisterMethod(@TALFBXLibrary.DSQLFetch, 'DSQLFetch');
    RegisterMethod(@TALFBXLibrary.DSQLFetchWithBlobs, 'DSQLFetchWithBlobs');
    RegisterMethod(@TALFBXLibrary.DSQLDescribe, 'DSQLDescribe');
    RegisterMethod(@TALFBXLibrary.DSQLDescribeBind, 'DSQLDescribeBind');
    RegisterMethod(@TALFBXLibrary.DSQLSetCursorName, 'DSQLSetCursorName');
    RegisterMethod(@TALFBXLibrary.DSQLExecImmed2, 'DSQLExecImmed2');
    RegisterMethod(@TALFBXLibrary.DSQLInfo, 'DSQLInfo');
    RegisterMethod(@TALFBXLibrary.DSQLInfoPlan, 'DSQLInfoPlan');
    RegisterMethod(@TALFBXLibrary.DSQLInfoStatementType, 'DSQLInfoStatementType');
    RegisterMethod(@TALFBXLibrary.DSQLInfoRowsAffected, 'DSQLInfoRowsAffected');
    RegisterMethod(@TALFBXLibrary.DSQLInfoRowsAffected2, 'DSQLInfoRowsAffected2');
    RegisterMethod(@TALFBXLibrary.DDLExecute, 'DDLExecute');
    RegisterMethod(@TALFBXLibrary.ArrayLookupBounds, 'ArrayLookupBounds');
    RegisterMethod(@TALFBXLibrary.ArrayGetSlice, 'ArrayGetSlice');
    RegisterMethod(@TALFBXLibrary.ArrayPutSlice, 'ArrayPutSlice');
    RegisterMethod(@TALFBXLibrary.ArraySetDesc, 'ArraySetDesc');
    RegisterMethod(@TALFBXLibrary.ServiceAttach, 'ServiceAttach');
    RegisterMethod(@TALFBXLibrary.ServiceDetach, 'ServiceDetach');
    RegisterMethod(@TALFBXLibrary.ServiceQuery, 'ServiceQuery');
    RegisterMethod(@TALFBXLibrary.ServiceStart, 'ServiceStart');
    RegisterMethod(@TALFBXLibrary.ErrSqlcode, 'ErrSqlcode');
    RegisterMethod(@TALFBXLibrary.ErrInterprete, 'ErrInterprete');
    RegisterMethod(@TALFBXLibrary.ErrSQLInterprete, 'ErrSQLInterprete');
    RegisterMethod(@TALFBXLibrary.ErrSqlState, 'ErrSqlState');
    RegisterMethod(@TALFBXLibrary.BlobOpen, 'BlobOpen');
    RegisterMethod(@TALFBXLibrary.BlobGetSegment, 'BlobGetSegment');
    RegisterMethod(@TALFBXLibrary.BlobClose, 'BlobClose');
    RegisterMethod(@TALFBXLibrary.BlobInfo, 'BlobInfo');
    RegisterMethod(@TALFBXLibrary.BlobSize, 'BlobSize');
    RegisterMethod(@TALFBXLibrary.BlobMaxSegment, 'BlobMaxSegment');
    RegisterMethod(@TALFBXLibrary.BlobDefaultDesc, 'BlobDefaultDesc');
    RegisterMethod(@TALFBXLibrary.BlobSaveToStream, 'BlobSaveToStream');
    RegisterMethod(@TALFBXLibraryBlobReadString_P, 'BlobReadString');
    RegisterMethod(@TALFBXLibraryBlobReadString1_P, 'BlobReadString1');
    RegisterMethod(@TALFBXLibrary.BlobReadVariant, 'BlobReadVariant');
    RegisterMethod(@TALFBXLibrary.BlobReadBuffer, 'BlobReadBuffer');
    RegisterMethod(@TALFBXLibraryBlobReadSizedBuffer_P, 'BlobReadSizedBuffer');
    RegisterMethod(@TALFBXLibraryBlobReadSizedBuffer1_P, 'BlobReadSizedBuffer1');
    RegisterMethod(@TALFBXLibrary.BlobCreate, 'BlobCreate');
    RegisterMethod(@TALFBXLibrary.BlobWriteSegment, 'BlobWriteSegment');
    RegisterMethod(@TALFBXLibraryBlobWriteString_P, 'BlobWriteString');
    RegisterMethod(@TALFBXLibrary.BlobWriteStream, 'BlobWriteStream');
    RegisterMethod(@TALFBXLibrary.StreamBlobOpen, 'StreamBlobOpen');
    RegisterMethod(@TALFBXLibrary.StreamBlobClose, 'StreamBlobClose');
    RegisterMethod(@TALFBXLibrary.EventBlock, 'EventBlock');
    RegisterMethod(@TALFBXLibrary.EventQueue, 'EventQueue');
    RegisterMethod(@TALFBXLibrary.EventCounts, 'EventCounts');
    RegisterMethod(@TALFBXLibrary.EventCancel, 'EventCancel');
    RegisterMethod(@TALFBXLibrary.EventWaitFor, 'EventWaitFor');
    RegisterMethod(@TALFBXLibrary.IscFree, 'IscFree');
    RegisterPropertyHelper(@TALFBXLibrarySegMentSize_R,@TALFBXLibrarySegMentSize_W,'SegMentSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXSQLParams(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXSQLParams) do
  begin
    RegisterConstructor(@TALFBXSQLParams.Create, 'Create');
    RegisterVirtualMethod(@TALFBXSQLParams.Clear, 'Clear');
    RegisterVirtualMethod(@TALFBXSQLParams.Parse, 'Parse');
    RegisterVirtualMethod(@TALFBXSQLParams.AddFieldType, 'AddFieldType');
    RegisterPropertyHelper(@TALFBXSQLParamsFieldName_R,nil,'FieldName');
    RegisterPropertyHelper(@TALFBXSQLParamsParamCount_R,nil,'ParamCount');
    RegisterPropertyHelper(@TALFBXSQLParamsMaxSqlLen_R,nil,'MaxSqlLen');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXSQLResult(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXSQLResult) do
  begin
    RegisterConstructor(@TALFBXSQLResult.Create, 'Create');
    RegisterVirtualMethod(@TALFBXSQLResult.ClearRecords, 'ClearRecords');
    RegisterVirtualMethod(@TALFBXSQLResult.GetRecord, 'GetRecord');
    RegisterVirtualMethod(@TALFBXSQLResult.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TALFBXSQLResult.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TALFBXSQLResult.Next, 'Next');
    RegisterPropertyHelper(@TALFBXSQLResultBlobData_R,nil,'BlobData');
    RegisterPropertyHelper(@TALFBXSQLResultArrayData_R,nil,'ArrayData');
    RegisterPropertyHelper(@TALFBXSQLResultArrayInfos_R,nil,'ArrayInfos');
    RegisterPropertyHelper(@TALFBXSQLResultArrayCount_R,nil,'ArrayCount');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlob_P, 'ReadBlob');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlobA_P, 'ReadBlobA');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlobA1_P, 'ReadBlobA1');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlob1_P, 'ReadBlob1');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlob2_P, 'ReadBlob2');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlobA3_P, 'ReadBlobA3');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlobA4_P, 'ReadBlobA4');
    RegisterVirtualMethod(@TALFBXSQLResultReadBlob3_P, 'ReadBlob3');
    RegisterVirtualMethod(@TALFBXSQLResult.GetBlobSize, 'GetBlobSize');
    RegisterPropertyHelper(@TALFBXSQLResultEof_R,nil,'Eof');
    RegisterPropertyHelper(@TALFBXSQLResultScrollEOF_R,nil,'ScrollEOF');
    RegisterPropertyHelper(@TALFBXSQLResultBof_R,nil,'Bof');
    RegisterPropertyHelper(@TALFBXSQLResultCachedFetch_R,nil,'CachedFetch');
    RegisterPropertyHelper(@TALFBXSQLResultFetchBlobs_R,nil,'FetchBlobs');
    RegisterPropertyHelper(@TALFBXSQLResultRecordCount_R,nil,'RecordCount');
    RegisterPropertyHelper(@TALFBXSQLResultCurrentRecord_R,@TALFBXSQLResultCurrentRecord_W,'CurrentRecord');
    RegisterPropertyHelper(@TALFBXSQLResultBufferChunks_R,nil,'BufferChunks');
    RegisterPropertyHelper(@TALFBXSQLResultUniqueRelationName_R,nil,'UniqueRelationName');
    RegisterPropertyHelper(@TALFBXSQLResultSqlName_R,nil,'SqlName');
    RegisterPropertyHelper(@TALFBXSQLResultRelName_R,nil,'RelName');
    RegisterPropertyHelper(@TALFBXSQLResultOwnName_R,nil,'OwnName');
    RegisterPropertyHelper(@TALFBXSQLResultAliasName_R,nil,'AliasName');
    RegisterPropertyHelper(@TALFBXSQLResultAsSmallint_R,nil,'AsSmallint');
    RegisterPropertyHelper(@TALFBXSQLResultAsInteger_R,nil,'AsInteger');
    RegisterPropertyHelper(@TALFBXSQLResultAsSingle_R,nil,'AsSingle');
    RegisterPropertyHelper(@TALFBXSQLResultAsDouble_R,nil,'AsDouble');
    RegisterPropertyHelper(@TALFBXSQLResultAsCurrency_R,nil,'AsCurrency');
    RegisterPropertyHelper(@TALFBXSQLResultAsInt64_R,nil,'AsInt64');
    RegisterPropertyHelper(@TALFBXSQLResultAsAnsiString_R,nil,'AsAnsiString');
    RegisterPropertyHelper(@TALFBXSQLResultAsDateTime_R,nil,'AsDateTime');
    RegisterPropertyHelper(@TALFBXSQLResultAsDate_R,nil,'AsDate');
    RegisterPropertyHelper(@TALFBXSQLResultAsTime_R,nil,'AsTime');
    RegisterPropertyHelper(@TALFBXSQLResultAsBoolean_R,nil,'AsBoolean');
    RegisterPropertyHelper(@TALFBXSQLResultByNameIsNull_R,nil,'ByNameIsNull');
    RegisterPropertyHelper(@TALFBXSQLResultByNameIsNullable_R,nil,'ByNameIsNullable');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsSmallint_R,nil,'ByNameAsSmallint');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsInteger_R,nil,'ByNameAsInteger');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsSingle_R,nil,'ByNameAsSingle');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsDouble_R,nil,'ByNameAsDouble');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsCurrency_R,nil,'ByNameAsCurrency');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsInt64_R,nil,'ByNameAsInt64');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsAnsiString_R,nil,'ByNameAsAnsiString');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsQuad_R,nil,'ByNameAsQuad');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsDateTime_R,nil,'ByNameAsDateTime');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsBoolean_R,nil,'ByNameAsBoolean');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsDate_R,nil,'ByNameAsDate');
    RegisterPropertyHelper(@TALFBXSQLResultByNameAsTime_R,nil,'ByNameAsTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXPoolStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXPoolStream) do
  begin
    RegisterConstructor(@TALFBXPoolStream.Create, 'Create');
    RegisterMethod(@TALFBXPoolStream.Clear, 'Clear');
    RegisterMethod(@TALFBXPoolStream.SeekTo, 'SeekTo');
    RegisterMethod(@TALFBXPoolStream.Get, 'Get');
    RegisterMethod(@TALFBXPoolStream.Add, 'Add');
    RegisterMethod(@TALFBXPoolStream.SaveToStream, 'SaveToStream');
    RegisterMethod(@TALFBXPoolStream.SaveToFile, 'SaveToFile');
    RegisterMethod(@TALFBXPoolStream.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TALFBXPoolStream.LoadFromFile, 'LoadFromFile');
    RegisterPropertyHelper(@TALFBXPoolStreamItemsInPage_R,nil,'ItemsInPage');
    RegisterPropertyHelper(@TALFBXPoolStreamItemSize_R,nil,'ItemSize');
    RegisterPropertyHelper(@TALFBXPoolStreamPageSize_R,nil,'PageSize');
    RegisterPropertyHelper(@TALFBXPoolStreamItemCount_R,nil,'ItemCount');
    RegisterPropertyHelper(@TALFBXPoolStreamItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALFBXSQLDA(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALFBXSQLDA) do
  begin
    RegisterConstructor(@TALFBXSQLDA.Create, 'Create');
    RegisterMethod(@TALFBXSQLDA.CheckRange, 'CheckRange');
    RegisterVirtualMethod(@TALFBXSQLDA.GetFieldIndex, 'GetFieldIndex');
    RegisterVirtualMethod(@TALFBXSQLDA.TryGetFieldIndex, 'TryGetFieldIndex');
    RegisterPropertyHelper(@TALFBXSQLDAData_R,nil,'Data');
    RegisterPropertyHelper(@TALFBXSQLDAIsBlob_R,nil,'IsBlob');
    RegisterPropertyHelper(@TALFBXSQLDAIsBlobText_R,nil,'IsBlobText');
    RegisterPropertyHelper(@TALFBXSQLDAIsNullable_R,nil,'IsNullable');
    RegisterPropertyHelper(@TALFBXSQLDAIsNumeric_R,nil,'IsNumeric');
    RegisterPropertyHelper(@TALFBXSQLDAFieldCount_R,nil,'FieldCount');
    RegisterPropertyHelper(@TALFBXSQLDASQLType_R,nil,'SQLType');
    RegisterPropertyHelper(@TALFBXSQLDASQLLen_R,nil,'SQLLen');
    RegisterPropertyHelper(@TALFBXSQLDASQLScale_R,nil,'SQLScale');
    RegisterPropertyHelper(@TALFBXSQLDAFieldType_R,nil,'FieldType');
    RegisterPropertyHelper(@TALFBXSQLDACharacterSet_R,@TALFBXSQLDACharacterSet_W,'CharacterSet');
    RegisterPropertyHelper(@TALFBXSQLDAIsNull_R,@TALFBXSQLDAIsNull_W,'IsNull');
    RegisterPropertyHelper(@TALFBXSQLDAAsSmallint_R,@TALFBXSQLDAAsSmallint_W,'AsSmallint');
    RegisterPropertyHelper(@TALFBXSQLDAAsInteger_R,@TALFBXSQLDAAsInteger_W,'AsInteger');
    RegisterPropertyHelper(@TALFBXSQLDAAsSingle_R,@TALFBXSQLDAAsSingle_W,'AsSingle');
    RegisterPropertyHelper(@TALFBXSQLDAAsDouble_R,@TALFBXSQLDAAsDouble_W,'AsDouble');
    RegisterPropertyHelper(@TALFBXSQLDAAsCurrency_R,@TALFBXSQLDAAsCurrency_W,'AsCurrency');
    RegisterPropertyHelper(@TALFBXSQLDAAsInt64_R,@TALFBXSQLDAAsInt64_W,'AsInt64');
    RegisterPropertyHelper(@TALFBXSQLDAAsAnsiString_R,@TALFBXSQLDAAsAnsiString_W,'AsAnsiString');
    RegisterPropertyHelper(@TALFBXSQLDAAsQuad_R,@TALFBXSQLDAAsQuad_W,'AsQuad');
    RegisterPropertyHelper(@TALFBXSQLDAAsDateTime_R,@TALFBXSQLDAAsDateTime_W,'AsDateTime');
    RegisterPropertyHelper(@TALFBXSQLDAAsBoolean_R,@TALFBXSQLDAAsBoolean_W,'AsBoolean');
    RegisterPropertyHelper(@TALFBXSQLDAAsDate_R,@TALFBXSQLDAAsDate_W,'AsDate');
    RegisterPropertyHelper(@TALFBXSQLDAAsTime_R,@TALFBXSQLDAAsTime_W,'AsTime');
    RegisterPropertyHelper(@TALFBXSQLDAByNameIsBlob_R,nil,'ByNameIsBlob');
    RegisterPropertyHelper(@TALFBXSQLDAByNameIsBlobText_R,nil,'ByNameIsBlobText');
    RegisterPropertyHelper(@TALFBXSQLDAByNameIsNull_R,@TALFBXSQLDAByNameIsNull_W,'ByNameIsNull');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsSmallint_R,@TALFBXSQLDAByNameAsSmallint_W,'ByNameAsSmallint');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsInteger_R,@TALFBXSQLDAByNameAsInteger_W,'ByNameAsInteger');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsSingle_R,@TALFBXSQLDAByNameAsSingle_W,'ByNameAsSingle');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsDouble_R,@TALFBXSQLDAByNameAsDouble_W,'ByNameAsDouble');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsCurrency_R,@TALFBXSQLDAByNameAsCurrency_W,'ByNameAsCurrency');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsInt64_R,@TALFBXSQLDAByNameAsInt64_W,'ByNameAsInt64');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsAnsiString_R,@TALFBXSQLDAByNameAsAnsiString_W,'ByNameAsAnsiString');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsQuad_R,@TALFBXSQLDAByNameAsQuad_W,'ByNameAsQuad');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsDateTime_R,@TALFBXSQLDAByNameAsDateTime_W,'ByNameAsDateTime');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsBoolean_R,@TALFBXSQLDAByNameAsBoolean_W,'ByNameAsBoolean');
    RegisterPropertyHelper(@TALFBXSQLDAByNameAsDate_R,@TALFBXSQLDAByNameAsDate_W,'ByNameAsDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFBXLib_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ALFBXStrToCharacterSet, 'ALFBXStrToCharacterSet', cdRegister);
 S.RegisterDelphiFunction(@ALFBXCreateDBParams, 'ALFBXCreateDBParams', cdRegister);
 S.RegisterDelphiFunction(@ALFBXCreateBlobParams, 'ALFBXCreateBlobParams', cdRegister);
 { RIRegister_TALFBXSQLDA(CL);
  RIRegister_TALFBXPoolStream(CL);
  RIRegister_TALFBXSQLResult(CL);
  RIRegister_TALFBXSQLParams(CL);
  with CL.Add(TALFBXLibrary) do
  RIRegister_TALFBXLibrary(CL); }
 S.RegisterDelphiFunction(@ALFBXDecodeTimeStamp, 'ALFBXDecodeTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@ALFBXDecodeTimeStampP1, 'ALFBXDecodeTimeStamp1', cdRegister);
 S.RegisterDelphiFunction(@ALFBXDecodeTimeStamp1_P, 'ALFBXDecodeTimeStamp2', cdRegister);
 S.RegisterDelphiFunction(@ALFBXDecodeSQLDate, 'ALFBXDecodeSQLDate', cdRegister);
 S.RegisterDelphiFunction(@ALFBXDecodeSQLTime, 'ALFBXDecodeSQLTime', cdRegister);
 S.RegisterDelphiFunction(@ALFBXEncodeTimeStamp, 'ALFBXEncodeTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@ALFBXEncodeTimeStamp1_P, 'ALFBXEncodeTimeStamp1', cdRegister);
 S.RegisterDelphiFunction(@ALFBXEncodeTimeStamp2_P, 'ALFBXEncodeTimeStamp2', cdRegister);
 S.RegisterDelphiFunction(@ALFBXEncodeSQLDate, 'ALFBXEncodeSQLDate', cdRegister);
 S.RegisterDelphiFunction(@ALFBXEncodeSQLTime, 'ALFBXEncodeSQLTime', cdRegister);
 S.RegisterDelphiFunction(@ALFBXSQLQuote, 'ALFBXSQLQuote', cdRegister);
 S.RegisterDelphiFunction(@ALFBXSQLUnQuote, 'ALFBXSQLUnQuote', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALFBXException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALFBXException) do
  begin
    RegisterPropertyHelper(@EALFBXExceptionNumber_R,nil,'Number');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALFBXError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALFBXError) do begin
    RegisterPropertyHelper(@EALFBXErrorErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@EALFBXErrorSQLCode_R,nil,'SQLCode');
    RegisterPropertyHelper(@EALFBXErrorGDSCode_R,nil,'GDSCode');
    RegisterPropertyHelper(@EALFBXErrorSQLState_R,nil,'SQLState');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFBXLib(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALFBXSQLDA(CL);
  RIRegister_TALFBXPoolStream(CL);
  RIRegister_TALFBXSQLResult(CL);
  RIRegister_TALFBXSQLParams(CL);
  with CL.Add(TALFBXLibrary) do
  RIRegister_TALFBXLibrary(CL);

  with CL.Add(EALFBXConvertError) do
  RIRegister_EALFBXError(CL);
  RIRegister_EALFBXException(CL);
  with CL.Add(EALFBXGFixError) do
  with CL.Add(EALFBXDSQLError) do
  with CL.Add(EALFBXDynError) do
  with CL.Add(EALFBXGBakError) do
  with CL.Add(EALFBXGSecError) do
  with CL.Add(EALFBXLicenseError) do
  with CL.Add(EALFBXGStatError) do
end;

 
 
{ TPSImport_ALFBXLib }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFBXLib.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFBXLib(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFBXLib.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALFBXLib(ri);
  RIRegister_ALFBXLib_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
