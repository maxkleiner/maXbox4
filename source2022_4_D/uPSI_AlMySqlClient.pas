unit uPSI_AlMySqlClient;
{
   first step  //const lib: AnsiString = 'libmysql.dll'
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
  TPSImport_AlMySqlClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TalMySqlConnectionPoolClient(CL: TPSPascalCompiler);
procedure SIRegister_TalMySqlConnectionPoolContainer(CL: TPSPascalCompiler);
procedure SIRegister_TalMySqlClient(CL: TPSPascalCompiler);
procedure SIRegister_EALMySqlError(CL: TPSPascalCompiler);
procedure SIRegister_AlMySqlClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AlMySqlClient_Routines(S: TPSExec);
procedure RIRegister_TalMySqlConnectionPoolClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TalMySqlConnectionPoolContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TalMySqlClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_EALMySqlError(CL: TPSRuntimeClassImporter);
procedure RIRegister_AlMySqlClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Contnrs
  ,SyncObjs
  ,AlXmlDoc
  ,ALStringList
  //,ALFcnString
  ,AlFcnMisc
  ,AlMySqlWrapper
  ,AlMySqlClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AlMySqlClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TalMySqlConnectionPoolClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TalMySqlConnectionPoolClient') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TalMySqlConnectionPoolClient') do begin
    RegisterMethod('Constructor Create( aHost : AnsiString; aPort : integer; aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aApiVer : TALMySqlVersion_API; const alib : AnsiString;'+
    ' const aOpenConnectionClientFlag : Cardinal; const aOpenConnectionOptions : TALMySQLOptions);');
    RegisterMethod('Constructor Create1( aHost : AnsiString; aPort : integer; aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; alib : TALMySqlLibrary; const aOpenConnectionClientFlag : Cardinal; const aOpenConnectionOptions : TALMySQLOptions);');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ReleaseAllConnections( const WaitWorkingConnections : Boolean)');
    RegisterMethod('Procedure TransactionStart( var ConnectionHandle : PMySql)');
    RegisterMethod('Procedure TransactionCommit( var ConnectionHandle : PMySql; const CloseConnection : Boolean)');
    RegisterMethod('Procedure TransactionRollback( var ConnectionHandle : PMySql; const CloseConnection : Boolean)');
    RegisterMethod('Procedure SelectData( SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData1( SQL : TalMySqlClientSelectDataSQL; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData2( SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData3( SQL : AnsiString; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData4( SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData5( SQL : TalMySqlClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData6( SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData7( SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure SelectData8( SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure UpdateData( SQLs : TalMySqlClientUpdateDataSQLs; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure UpdateData1( SQL : TalMySqlClientUpdateDataSQL; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure UpdateData2( SQLs : TALStrings; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure UpdateData3( SQL : AnsiString; const ConnectionHandle : PMySql);');
    RegisterMethod('Procedure UpdateData4( SQLs : array of AnsiString; const ConnectionHandle : PMySql);');
    RegisterMethod('Function insert_id( SQL : AnsiString; const ConnectionHandle : PMySql) : UlongLong');
    RegisterMethod('Function ConnectionCount : Integer');
    RegisterMethod('Function WorkingConnectionCount : Integer');
    RegisterProperty('DataBaseName', 'AnsiString', iptr);
    RegisterProperty('Host', 'AnsiString', iptr);
    RegisterProperty('Port', 'integer', iptr);
    RegisterProperty('ConnectionMaxIdleTime', 'integer', iptrw);
    RegisterProperty('NullString', 'AnsiString', iptrw);
    RegisterProperty('Lib', 'TALMySqlLibrary', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TalMySqlConnectionPoolContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TalMySqlConnectionPoolContainer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TalMySqlConnectionPoolContainer') do
  begin
    RegisterProperty('ConnectionHandle', 'PMySql', iptrw);
    RegisterProperty('LastAccessDate', 'int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TalMySqlClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TalMySqlClient') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TalMySqlClient') do begin
  //const lib: AnsiString = 'libmysql.dll'
    RegisterMethod('Constructor Create(ApiVer : TALMySqlVersion_API; const lib : AnsiString);');
    RegisterMethod('Constructor Create2( lib : TALMySqlLibrary);');
    RegisterMethod('Procedure Connect( Host : AnsiString; Port : integer; DataBaseName, Login, Password, CharSet : AnsiString; const ClientFlag : Cardinal; const Options : TALMySQLOptions)');
    RegisterMethod('Procedure Disconnect');
       RegisterMethod('Procedure Free');
      RegisterMethod('Procedure TransactionStart');
    RegisterMethod('Procedure TransactionCommit');
    RegisterMethod('Procedure TransactionRollback');
    RegisterMethod('Procedure SelectData( SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData1( SQL : TalMySqlClientSelectDataSQL; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData2( SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData3( SQL : AnsiString; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData4( SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData5( SQL : TalMySqlClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData6( SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData7( SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure SelectData8( SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);');
    RegisterMethod('Procedure UpdateData( SQLs : TalMySqlClientUpdateDataSQLs);');
    RegisterMethod('Procedure UpdateData1( SQL : TalMySqlClientUpdateDataSQL);');
    RegisterMethod('Procedure UpdateData2( SQLs : TALStrings);');
    RegisterMethod('Procedure UpdateData3( SQL : AnsiString);');
    RegisterMethod('Procedure UpdateData4( SQLs : array of AnsiString);');
    RegisterMethod('Function insert_id( SQL : AnsiString) : ULongLong');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('InTransaction', 'Boolean', iptr);
    RegisterProperty('NullString', 'AnsiString', iptrw);
    RegisterProperty('Lib', 'TALMySqlLibrary', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EALMySqlError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EALException', 'EALMySqlError') do
  with CL.AddClassN(CL.FindClass('EALException'),'EALMySqlError') do begin
    RegisterMethod('Constructor Create( aErrorMsg : AnsiString; aErrorCode : Integer; aSqlState : AnsiString);');
    RegisterProperty('ErrorCode', 'Integer', iptr);
    RegisterProperty('SQLState', 'AnsiString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AlMySqlClient(CL: TPSPascalCompiler);
begin
  SIRegister_EALMySqlError(CL);

   CL.AddTypeS('uLongLong', 'LongLong');
 CL.AddConstantN('cALMySql_INVALIDELIBVERSION','String').SetString( 'Incorrect Database Server Version.');
 CL.AddConstantN('cALMySql_CANTLOADLIB','String').SetString( 'Can''t load library: %s.');
 CL.AddConstantN('CR_UNKNOWN_ERROR','LongInt').SetInt( 2000);
 CL.AddConstantN('CR_SOCKET_CREATE_ERROR','LongInt').SetInt( 2001);
 CL.AddConstantN('CR_CONNECTION_ERROR','LongInt').SetInt( 2002);
 CL.AddConstantN('CR_CONN_HOST_ERROR','LongInt').SetInt( 2003);
 CL.AddConstantN('CR_IPSOCK_ERROR','LongInt').SetInt( 2004);
 CL.AddConstantN('CR_UNKNOWN_HOST','LongInt').SetInt( 2005);
 CL.AddConstantN('CR_SERVER_GONE_ERROR','LongInt').SetInt( 2006);
 CL.AddConstantN('CR_VERSION_ERROR','LongInt').SetInt( 2007);
 CL.AddConstantN('CR_OUT_OF_MEMORY','LongInt').SetInt( 2008);
 CL.AddConstantN('CR_WRONG_HOST_INFO','LongInt').SetInt( 2009);
 CL.AddConstantN('CR_LOCALHOST_CONNECTION','LongInt').SetInt( 2010);
 CL.AddConstantN('CR_TCP_CONNECTION','LongInt').SetInt( 2011);
 CL.AddConstantN('CR_SERVER_HANDSHAKE_ERR','LongInt').SetInt( 2012);
 CL.AddConstantN('CR_SERVER_LOST','LongInt').SetInt( 2013);
 CL.AddConstantN('CR_COMMANDS_OUT_OF_SYNC','LongInt').SetInt( 2014);
 CL.AddConstantN('CR_NAMEDPIPE_CONNECTION','LongInt').SetInt( 2015);
 CL.AddConstantN('CR_NAMEDPIPEWAIT_ERROR','LongInt').SetInt( 2016);
 CL.AddConstantN('CR_NAMEDPIPEOPEN_ERROR','LongInt').SetInt( 2017);
 CL.AddConstantN('CR_NAMEDPIPESETSTATE_ERROR','LongInt').SetInt( 2018);
 CL.AddConstantN('CR_CANT_READ_CHARSET','LongInt').SetInt( 2019);
 CL.AddConstantN('CR_NET_PACKET_TOO_LARGE','LongInt').SetInt( 2020);
 CL.AddConstantN('CR_EMBEDDED_CONNECTION','LongInt').SetInt( 2021);
 CL.AddConstantN('CR_PROBE_SLAVE_STATUS','LongInt').SetInt( 2022);
 CL.AddConstantN('CR_PROBE_SLAVE_HOSTS','LongInt').SetInt( 2023);
 CL.AddConstantN('CR_PROBE_SLAVE_CONNECT','LongInt').SetInt( 2024);
 CL.AddConstantN('CR_PROBE_MASTER_CONNECT','LongInt').SetInt( 2025);
 CL.AddConstantN('CR_SSL_CONNECTION_ERROR','LongInt').SetInt( 2026);
 CL.AddConstantN('CR_MALFORMED_PACKET','LongInt').SetInt( 2027);
 CL.AddConstantN('CR_WRONG_LICENSE','LongInt').SetInt( 2028);
 CL.AddConstantN('CR_NULL_POINTER','LongInt').SetInt( 2029);
 CL.AddConstantN('CR_NO_PREPARE_STMT','LongInt').SetInt( 2030);
 CL.AddConstantN('CR_PARAMS_NOT_BOUND','LongInt').SetInt( 2031);
 CL.AddConstantN('CR_DATA_TRUNCATED','LongInt').SetInt( 2032);
 CL.AddConstantN('CR_NO_PARAMETERS_EXISTS','LongInt').SetInt( 2033);
 CL.AddConstantN('CR_INVALID_PARAMETER_NO','LongInt').SetInt( 2034);
 CL.AddConstantN('CR_INVALID_BUFFER_USE','LongInt').SetInt( 2035);
 CL.AddConstantN('CR_UNSUPPORTED_PARAM_TYPE','LongInt').SetInt( 2036);
 CL.AddConstantN('CR_SHARED_MEMORY_CONNECTION','LongInt').SetInt( 2037);
 CL.AddConstantN('CR_SHARED_MEMORY_CONNECT_REQUEST_ERROR','LongInt').SetInt( 2038);
 CL.AddConstantN('CR_SHARED_MEMORY_CONNECT_ANSWER_ERROR','LongInt').SetInt( 2039);
 CL.AddConstantN('CR_SHARED_MEMORY_CONNECT_FILE_MAP_ERROR','LongInt').SetInt( 2040);
 CL.AddConstantN('CR_SHARED_MEMORY_CONNECT_MAP_ERROR','LongInt').SetInt( 2041);
 CL.AddConstantN('CR_SHARED_MEMORY_FILE_MAP_ERROR','LongInt').SetInt( 2042);
 CL.AddConstantN('CR_SHARED_MEMORY_MAP_ERROR','LongInt').SetInt( 2043);
 CL.AddConstantN('CR_SHARED_MEMORY_EVENT_ERROR','LongInt').SetInt( 2044);
 CL.AddConstantN('CR_SHARED_MEMORY_CONNECT_ABANDONED_ERROR','LongInt').SetInt( 2045);
 CL.AddConstantN('CR_SHARED_MEMORY_CONNECT_SET_ERROR','LongInt').SetInt( 2046);
 CL.AddConstantN('CR_CONN_UNKNOW_PROTOCOL','LongInt').SetInt( 2047);
 CL.AddConstantN('CR_INVALID_CONN_HANDLE','LongInt').SetInt( 2048);
 CL.AddConstantN('CR_SECURE_AUTH','LongInt').SetInt( 2049);
 CL.AddConstantN('CR_FETCH_CANCELED','LongInt').SetInt( 2050);
 CL.AddConstantN('CR_NO_DATA','LongInt').SetInt( 2051);
 CL.AddConstantN('CR_NO_STMT_METADATA','LongInt').SetInt( 2052);
 CL.AddConstantN('CR_NO_RESULT_SET','LongInt').SetInt( 2053);
 CL.AddConstantN('CR_NOT_IMPLEMENTED','LongInt').SetInt( 2054);
 CL.AddConstantN('CR_SERVER_LOST_EXTENDED','LongInt').SetInt( 2055);
 CL.AddConstantN('CR_STMT_CLOSED','LongInt').SetInt( 2056);
 CL.AddConstantN('CR_NEW_STMT_METADATA','LongInt').SetInt( 2057);
 CL.AddConstantN('CR_ALREADY_CONNECTED','LongInt').SetInt( 2058);
 CL.AddConstantN('CR_AUTH_PLUGIN_CANNOT_LOAD','LongInt').SetInt( 2059);
 CL.AddConstantN('MYSQL_ERRMSG_SIZE','LongInt').SetInt( 512);
 CL.AddConstantN('SQLSTATE_LENGTH','LongInt').SetInt( 5);
 CL.AddConstantN('MYSQL_PORT','LongInt').SetInt( 3306);
 CL.AddConstantN('LOCAL_HOST','String').SetString( 'localhost');
 CL.AddConstantN('NOT_NULL_FLAG','LongInt').SetInt( 1);
 CL.AddConstantN('PRI_KEY_FLAG','LongInt').SetInt( 2);
 CL.AddConstantN('UNIQUE_KEY_FLAG','LongInt').SetInt( 4);
 CL.AddConstantN('MULTIPLE_KEY_FLAG','LongInt').SetInt( 8);
 CL.AddConstantN('BLOB_FLAG','LongInt').SetInt( 16);
 CL.AddConstantN('UNSIGNED_FLAG','LongInt').SetInt( 32);
 CL.AddConstantN('ZEROFILL_FLAG','LongInt').SetInt( 64);
 CL.AddConstantN('BINARY_FLAG','LongInt').SetInt( 128);
 CL.AddConstantN('ENUM_FLAG','LongInt').SetInt( 256);
 CL.AddConstantN('AUTO_INCREMENT_FLAG','LongInt').SetInt( 512);
 CL.AddConstantN('TIMESTAMP_FLAG','LongInt').SetInt( 1024);
 CL.AddConstantN('SET_FLAG','LongInt').SetInt( 2048);
 CL.AddConstantN('NUM_FLAG','LongInt').SetInt( 32768);
 CL.AddConstantN('PART_KEY_FLAG','LongInt').SetInt( 16384);
 CL.AddConstantN('GROUP_FLAG','LongInt').SetInt( 32768);
 CL.AddConstantN('UNIQUE_FLAG','LongInt').SetInt( 65536);
 CL.AddConstantN('BINCMP_FLAG','LongWord').SetUInt( $20000);
 CL.AddConstantN('GET_FIXED_FIELDS_FLAG','LongWord').SetUInt( $40000);
 CL.AddConstantN('FIELD_IN_PART_FUNC_FLAG','LongWord').SetUInt( $80000);
 CL.AddConstantN('FIELD_IN_ADD_INDEX','LongWord').SetUInt( $100000);
 CL.AddConstantN('FIELD_IS_RENAMED','LongWord').SetUInt( $200000);
 CL.AddConstantN('_CLIENT_LONG_PASSWORD','LongInt').SetInt( 1);
 CL.AddConstantN('_CLIENT_FOUND_ROWS','LongInt').SetInt( 2);
 CL.AddConstantN('_CLIENT_LONG_FLAG','LongInt').SetInt( 4);
 CL.AddConstantN('_CLIENT_CONNECT_WITH_DB','LongInt').SetInt( 8);
 CL.AddConstantN('_CLIENT_NO_SCHEMA','LongInt').SetInt( 16);
 CL.AddConstantN('_CLIENT_COMPRESS','LongInt').SetInt( 32);
 CL.AddConstantN('_CLIENT_ODBC','LongInt').SetInt( 64);
 CL.AddConstantN('_CLIENT_LOCAL_FILES','LongInt').SetInt( 128);
 CL.AddConstantN('_CLIENT_IGNORE_SPACE','LongInt').SetInt( 256);
 CL.AddConstantN('_CLIENT_CHANGE_USER','LongInt').SetInt( 512);
 CL.AddConstantN('_CLIENT_INTERACTIVE','LongInt').SetInt( 1024);
 CL.AddConstantN('_CLIENT_SSL','LongInt').SetInt( 2048);
 CL.AddConstantN('_CLIENT_IGNORE_SIGPIPE','LongInt').SetInt( 4096);
 CL.AddConstantN('_CLIENT_TRANSACTIONS','LongInt').SetInt( 8196);
 CL.AddConstantN('_CLIENT_RESERVED','LongInt').SetInt( 16384);
 CL.AddConstantN('_CLIENT_SECURE_CONNECTION','LongInt').SetInt( 32768);
 CL.AddConstantN('_CLIENT_MULTI_STATEMENTS','LongInt').SetInt( 65536);
 CL.AddConstantN('_CLIENT_MULTI_RESULTS','LongInt').SetInt( 131072);
 CL.AddConstantN('_CLIENT_PS_MULTI_RESULTS','LongInt').SetInt( 262144);
 CL.AddConstantN('_CLIENT_PLUGIN_AUTH','LongInt').SetInt( 524288);
 CL.AddConstantN('_CLIENT_SSL_VERIFY_SERVER_CERT','LongInt').SetInt( 1073741824);
 CL.AddConstantN('_CLIENT_REMEMBER_OPTIONS','LongWord').SetUInt( 2147483648);
 CL.AddConstantN('MYSQL_SHUTDOWN_KILLABLE_CONNECT','LongInt').SetInt( 1);
 CL.AddConstantN('MYSQL_SHUTDOWN_KILLABLE_TRANS','LongInt').SetInt( 2);
 CL.AddConstantN('MYSQL_SHUTDOWN_KILLABLE_LOCK_TABLE','LongInt').SetInt( 4);
 CL.AddConstantN('MYSQL_SHUTDOWN_KILLABLE_UPDATE','LongInt').SetInt( 8);
 CL.AddConstantN('STMT_FETCH_OK','LongInt').SetInt( 0);
 CL.AddConstantN('STMT_FETCH_ERROR','LongInt').SetInt( 1);
 CL.AddConstantN('STMT_FETCH_NO_DATA','LongInt').SetInt( 100);
 CL.AddConstantN('STMT_FETCH_DATA_TRUNC','LongInt').SetInt( 101);

  CL.AddTypeS('TMYSQL_CLIENT_OPTIONS', '( CLIENT_LONG_PASSWORD, CLIENT_FOUND_RO'
   +'WS, CLIENT_LONG_FLAG, CLIENT_CONNECT_WITH_DB, CLIENT_NO_SCHEMA, CLIENT_COM'
   +'PRESS, CLIENT_ODBC, CLIENT_LOCAL_FILES, CLIENT_IGNORE_SPACE, CLIENT_CHANGE'
   +'_USER, CLIENT_INTERACTIVE, CLIENT_SSL, CLIENT_IGNORE_SIGPIPE, CLIENT_TRANS'
   +'ACTIONS, CLIENT_RESERVED, CLIENT_SECURE_CONNECTION, CLIENT_MULTI_STATEMENT'
   +'S, CLIENT_MULTI_RESULTS, CLIENT_PS_MULTI_RESULTS, CLIENT_PLUGIN_AUTH, CLIE'
   +'NT_OPT_20, CLIENT_OPT_21, CLIENT_OPT_22, CLIENT_OPT_23, CLIENT_OPT_24, CLI'
   +'ENT_OPT_25, CLIENT_OPT_26, CLIENT_OPT_27, CLIENT_OPT_28, CLIENT_OPT_29, CL'
   +'IENT_SSL_VERIFY_SERVER_CERT, CLIENT_REMEMBER_OPTIONS )');
  CL.AddTypeS('MYSQL_TIME', 'record year : UInt; month : UInt; day : UInt; hour'
   +' : UInt; minute : UInt; second : UInt; second_part : ULong; neg : Byte; end');

   CL.AddTypeS('TMySqlOption', '( MYSQL_OPT_CONNECT_TIMEOUT, MYSQL_OPT_COMPRESS,'
   +' MYSQL_OPT_NAMED_PIPE, MYSQL_INIT_COMMAND, MYSQL_READ_DEFAULT_FILE, MYSQL_'
   +'READ_DEFAULT_GROUP, MYSQL_SET_CHARSET_DIR, MYSQL_SET_CHARSET_NAME, MYSQL_O'
   +'PT_LOCAL_INFILE, MYSQL_OPT_PROTOCOL, MYSQL_SHARED_MEMORY_BASE_NAME, MYSQL_'
   +'OPT_READ_TIMEOUT, MYSQL_OPT_WRITE_TIMEOUT, MYSQL_OPT_USE_RESULT, MYSQL_OPT'
   +'_USE_REMOTE_CONNECTION, MYSQL_OPT_USE_EMBEDDED_CONNECTION, MYSQL_OPT_GUESS'
   +'_CONNECTION, MYSQL_SET_CLIENT_IP, MYSQL_SECURE_AUTH, MYSQL_REPORT_DATA_TRU'
   +'NCATION, MYSQL_OPT_RECONNECT, MYSQL_OPT_SSL_VERIFY_SERVER_CERT, MYSQL_PLUG'
   +'IN_DIR, MYSQL_DEFAULT_AUTH )');

  CL.AddTypeS('TalMySqlClientSelectDataSQL', 'record SQL : AnsiString; RowTag :'
   +' AnsiString; ViewTag: AnsiString; Skip: integer; First: Integer; CacheThreshold: Integer; end');
  CL.AddTypeS('TalMySqlClientSelectDataSQLs', 'array of TalMySqlClientSelectDataSQL');
  CL.AddTypeS('TalMySqlClientUpdateDataSQL', 'record SQL : AnsiString; end');
  CL.AddTypeS('TalMySqlClientUpdateDataSQLs', 'array of TalMySqlClientUpdateDataSQL');
  CL.AddTypeS('TALMySQLOption', 'record Option : TMySqlOption; Value : PChar; end');
  CL.AddTypeS('TALMySQLOptions', 'array of TALMySQLOption');
  CL.AddTypeS('TALMySqlVersion_API', '(MYSQL50, MYSQL55)');

  // TALMySqlVersion_API = (MYSQL50, MYSQL55);

  SIRegister_TalMySqlClient(CL);
  SIRegister_TalMySqlConnectionPoolContainer(CL);
  SIRegister_TalMySqlConnectionPoolClient(CL);
 CL.AddDelphiFunction('Function AlMySqlClientSlashedStr( const Str : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientLib_R(Self: TalMySqlConnectionPoolClient; var T: TALMySqlLibrary);
begin T := Self.Lib; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientNullString_W(Self: TalMySqlConnectionPoolClient; const T: AnsiString);
begin Self.NullString := T; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientNullString_R(Self: TalMySqlConnectionPoolClient; var T: AnsiString);
begin T := Self.NullString; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientConnectionMaxIdleTime_W(Self: TalMySqlConnectionPoolClient; const T: integer);
begin Self.ConnectionMaxIdleTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientConnectionMaxIdleTime_R(Self: TalMySqlConnectionPoolClient; var T: integer);
begin T := Self.ConnectionMaxIdleTime; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientPort_R(Self: TalMySqlConnectionPoolClient; var T: integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientHost_R(Self: TalMySqlConnectionPoolClient; var T: AnsiString);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolClientDataBaseName_R(Self: TalMySqlConnectionPoolClient; var T: AnsiString);
begin T := Self.DataBaseName; end;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientUpdateData4_P(Self: TalMySqlConnectionPoolClient;  SQLs : array of AnsiString; const ConnectionHandle : PMySql);
Begin Self.UpdateData(SQLs, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientUpdateData3_P(Self: TalMySqlConnectionPoolClient;  SQL : AnsiString; const ConnectionHandle : PMySql);
Begin Self.UpdateData(SQL, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientUpdateData2_P(Self: TalMySqlConnectionPoolClient;  SQLs : TALStrings; const ConnectionHandle : PMySql);
Begin Self.UpdateData(SQLs, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientUpdateData1_P(Self: TalMySqlConnectionPoolClient;  SQL : TalMySqlClientUpdateDataSQL; const ConnectionHandle : PMySql);
Begin Self.UpdateData(SQL, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientUpdateData_P(Self: TalMySqlConnectionPoolClient;  SQLs : TalMySqlClientUpdateDataSQLs; const ConnectionHandle : PMySql);
Begin Self.UpdateData(SQLs, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData8_P(Self: TalMySqlConnectionPoolClient;  SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData7_P(Self: TalMySqlConnectionPoolClient;  SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQL, RowTag, XMLDATA, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData6_P(Self: TalMySqlConnectionPoolClient;  SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQL, RowTag, Skip, First, XMLDATA, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData5_P(Self: TalMySqlConnectionPoolClient;  SQL : TalMySqlClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData4_P(Self: TalMySqlConnectionPoolClient;  SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQLs, XMLDATA, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData3_P(Self: TalMySqlConnectionPoolClient;  SQL : AnsiString; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData2_P(Self: TalMySqlConnectionPoolClient;  SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQL, Skip, First, OnNewRowFunct, ExtData, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData1_P(Self: TalMySqlConnectionPoolClient;  SQL : TalMySqlClientSelectDataSQL; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlConnectionPoolClientSelectData_P(Self: TalMySqlConnectionPoolClient;  SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings; const ConnectionHandle : PMySql);
Begin Self.SelectData(SQLs, XMLDATA, OnNewRowFunct, ExtData, FormatSettings, ConnectionHandle); END;

(*----------------------------------------------------------------------------*)
Function TalMySqlConnectionPoolClientCreate1_P(Self: TClass; CreateNewInstance: Boolean;  aHost : AnsiString; aPort : integer; aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; alib : TALMySqlLibrary; const aOpenConnectionClientFlag : Cardinal; const aOpenConnectionOptions : TALMySQLOptions):TObject;
Begin Result := TalMySqlConnectionPoolClient.Create(aHost, aPort, aDataBaseName, aLogin, aPassword, aCharSet, alib, aOpenConnectionClientFlag, aOpenConnectionOptions); END;

(*----------------------------------------------------------------------------*)
Function TalMySqlConnectionPoolClientCreate_P(Self: TClass; CreateNewInstance: Boolean;  aHost : AnsiString; aPort : integer; aDataBaseName, aLogin, aPassword, aCharSet : AnsiString; aApiVer : TALMySqlVersion_API; const alib : AnsiString; const aOpenConnectionClientFlag : Cardinal; const aOpenConnectionOptions : TALMySQLOptions):TObject;
Begin Result := TalMySqlConnectionPoolClient.Create(aHost, aPort, aDataBaseName, aLogin, aPassword, aCharSet, aApiVer, alib, aOpenConnectionClientFlag, aOpenConnectionOptions); END;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolContainerLastAccessDate_W(Self: TalMySqlConnectionPoolContainer; const T: int64);
Begin Self.LastAccessDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolContainerLastAccessDate_R(Self: TalMySqlConnectionPoolContainer; var T: int64);
Begin T := Self.LastAccessDate; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolContainerConnectionHandle_W(Self: TalMySqlConnectionPoolContainer; const T: PMySql);
Begin Self.ConnectionHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlConnectionPoolContainerConnectionHandle_R(Self: TalMySqlConnectionPoolContainer; var T: PMySql);
Begin T := Self.ConnectionHandle; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlClientLib_R(Self: TalMySqlClient; var T: TALMySqlLibrary);
begin T := Self.Lib; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlClientNullString_W(Self: TalMySqlClient; const T: AnsiString);
begin Self.NullString := T; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlClientNullString_R(Self: TalMySqlClient; var T: AnsiString);
begin T := Self.NullString; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlClientInTransaction_R(Self: TalMySqlClient; var T: Boolean);
begin T := Self.InTransaction; end;

(*----------------------------------------------------------------------------*)
procedure TalMySqlClientConnected_R(Self: TalMySqlClient; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientUpdateData4_P(Self: TalMySqlClient;  SQLs : array of AnsiString);
Begin Self.UpdateData(SQLs); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientUpdateData3_P(Self: TalMySqlClient;  SQL : AnsiString);
Begin Self.UpdateData(SQL); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientUpdateData2_P(Self: TalMySqlClient;  SQLs : TALStrings);
Begin Self.UpdateData(SQLs); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientUpdateData1_P(Self: TalMySqlClient;  SQL : TalMySqlClientUpdateDataSQL);
Begin Self.UpdateData(SQL); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientUpdateData_P(Self: TalMySqlClient;  SQLs : TalMySqlClientUpdateDataSQLs);
Begin Self.UpdateData(SQLs); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData8_P(Self: TalMySqlClient;  SQL : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData7_P(Self: TalMySqlClient;  SQL : AnsiString; RowTag : AnsiString; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, RowTag, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData6_P(Self: TalMySqlClient;  SQL : AnsiString; RowTag : AnsiString; Skip : integer; First : Integer; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, RowTag, Skip, First, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData5_P(Self: TalMySqlClient;  SQL : TalMySqlClientSelectDataSQL; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData4_P(Self: TalMySqlClient;  SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQLs, XMLDATA, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData3_P(Self: TalMySqlClient;  SQL : AnsiString; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData2_P(Self: TalMySqlClient;  SQL : AnsiString; Skip : integer; First : Integer; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, Skip, First, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData1_P(Self: TalMySqlClient;  SQL : TalMySqlClientSelectDataSQL; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings);
Begin Self.SelectData(SQL, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Procedure TalMySqlClientSelectData_P(Self: TalMySqlClient;  SQLs : TalMySqlClientSelectDataSQLs; XMLDATA : TalXMLNode; OnNewRowFunct : TalMySqlClientSelectDataOnNewRowFunct; ExtData : Pointer; FormatSettings : TFormatSettings

);
Begin Self.SelectData(SQLs, XMLDATA, OnNewRowFunct, ExtData, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Function TalMySqlClientCreate2_P(Self: TClass; CreateNewInstance: Boolean;  lib : TALMySqlLibrary):TObject;
Begin Result := TalMySqlClient.Create(lib); END;

(*----------------------------------------------------------------------------*)
Function TalMySqlClientCreate1_P(Self: TClass; CreateNewInstance: Boolean;  ApiVer : TALMySqlVersion_API; const lib : AnsiString):TObject;
Begin Result := TalMySqlClient.Create(ApiVer, lib); END;

(*----------------------------------------------------------------------------*)
procedure EALMySqlErrorSQLState_R(Self: EALMySqlError; var T: AnsiString);
begin T := Self.SQLState; end;

(*----------------------------------------------------------------------------*)
procedure EALMySqlErrorErrorCode_R(Self: EALMySqlError; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
Function EALMySqlErrorCreate_P(Self: TClass; CreateNewInstance: Boolean;  aErrorMsg : AnsiString; aErrorCode : Integer; aSqlState : AnsiString):TObject;
Begin Result := EALMySqlError.Create(aErrorMsg, aErrorCode, aSqlState); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AlMySqlClient_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlMySqlClientSlashedStr, 'AlMySqlClientSlashedStr', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TalMySqlConnectionPoolClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TalMySqlConnectionPoolClient) do begin
    RegisterConstructor(@TalMySqlConnectionPoolClientCreate_P, 'Create');
    RegisterConstructor(@TalMySqlConnectionPoolClientCreate1_P, 'Create1');
     RegisterMethod(@TalMySqlConnectionPoolClient.Destroy, 'Free');
      RegisterVirtualMethod(@TalMySqlConnectionPoolClient.ReleaseAllConnections, 'ReleaseAllConnections');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClient.TransactionStart, 'TransactionStart');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClient.TransactionCommit, 'TransactionCommit');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClient.TransactionRollback, 'TransactionRollback');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData_P, 'SelectData');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData1_P, 'SelectData1');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData2_P, 'SelectData2');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData3_P, 'SelectData3');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData4_P, 'SelectData4');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData5_P, 'SelectData5');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData6_P, 'SelectData6');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData7_P, 'SelectData7');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientSelectData8_P, 'SelectData8');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientUpdateData_P, 'UpdateData');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientUpdateData1_P, 'UpdateData1');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientUpdateData2_P, 'UpdateData2');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientUpdateData3_P, 'UpdateData3');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClientUpdateData4_P, 'UpdateData4');
    RegisterVirtualMethod(@TalMySqlConnectionPoolClient.insert_id, 'insert_id');
    RegisterMethod(@TalMySqlConnectionPoolClient.ConnectionCount, 'ConnectionCount');
    RegisterMethod(@TalMySqlConnectionPoolClient.WorkingConnectionCount, 'WorkingConnectionCount');
    RegisterPropertyHelper(@TalMySqlConnectionPoolClientDataBaseName_R,nil,'DataBaseName');
    RegisterPropertyHelper(@TalMySqlConnectionPoolClientHost_R,nil,'Host');
    RegisterPropertyHelper(@TalMySqlConnectionPoolClientPort_R,nil,'Port');
    RegisterPropertyHelper(@TalMySqlConnectionPoolClientConnectionMaxIdleTime_R,@TalMySqlConnectionPoolClientConnectionMaxIdleTime_W,'ConnectionMaxIdleTime');
    RegisterPropertyHelper(@TalMySqlConnectionPoolClientNullString_R,@TalMySqlConnectionPoolClientNullString_W,'NullString');
    RegisterPropertyHelper(@TalMySqlConnectionPoolClientLib_R,nil,'Lib');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TalMySqlConnectionPoolContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TalMySqlConnectionPoolContainer) do
  begin
    RegisterPropertyHelper(@TalMySqlConnectionPoolContainerConnectionHandle_R,@TalMySqlConnectionPoolContainerConnectionHandle_W,'ConnectionHandle');
    RegisterPropertyHelper(@TalMySqlConnectionPoolContainerLastAccessDate_R,@TalMySqlConnectionPoolContainerLastAccessDate_W,'LastAccessDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TalMySqlClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TalMySqlClient) do begin
    RegisterConstructor(@TalMySqlClientCreate1_P, 'Create');
    RegisterConstructor(@TalMySqlClientCreate2_P, 'Create2');
    RegisterVirtualMethod(@TalMySqlClient.Connect, 'Connect');
    RegisterMethod(@TalMySqlClient.Disconnect, 'Disconnect');
    RegisterMethod(@TalMySqlClient.Destroy, 'Free');
    RegisterMethod(@TalMySqlClient.TransactionStart, 'TransactionStart');
    RegisterMethod(@TalMySqlClient.TransactionCommit, 'TransactionCommit');
    RegisterMethod(@TalMySqlClient.TransactionRollback, 'TransactionRollback');
    RegisterMethod(@TalMySqlClientSelectData_P, 'SelectData');
    RegisterMethod(@TalMySqlClientSelectData1_P, 'SelectData1');
    RegisterMethod(@TalMySqlClientSelectData2_P, 'SelectData2');
    RegisterMethod(@TalMySqlClientSelectData3_P, 'SelectData3');
    RegisterMethod(@TalMySqlClientSelectData4_P, 'SelectData4');
    RegisterMethod(@TalMySqlClientSelectData5_P, 'SelectData5');
    RegisterMethod(@TalMySqlClientSelectData6_P, 'SelectData6');
    RegisterMethod(@TalMySqlClientSelectData7_P, 'SelectData7');
    RegisterMethod(@TalMySqlClientSelectData8_P, 'SelectData8');
    RegisterMethod(@TalMySqlClientUpdateData_P, 'UpdateData');
    RegisterMethod(@TalMySqlClientUpdateData1_P, 'UpdateData1');
    RegisterMethod(@TalMySqlClientUpdateData2_P, 'UpdateData2');
    RegisterMethod(@TalMySqlClientUpdateData3_P, 'UpdateData3');
    RegisterMethod(@TalMySqlClientUpdateData4_P, 'UpdateData4');
    RegisterMethod(@TalMySqlClient.insert_id, 'insert_id');
    RegisterPropertyHelper(@TalMySqlClientConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TalMySqlClientInTransaction_R,nil,'InTransaction');
    RegisterPropertyHelper(@TalMySqlClientNullString_R,@TalMySqlClientNullString_W,'NullString');
    RegisterPropertyHelper(@TalMySqlClientLib_R,nil,'Lib');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EALMySqlError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALMySqlError) do
  begin
    RegisterConstructor(@EALMySqlErrorCreate_P, 'Create');
    RegisterPropertyHelper(@EALMySqlErrorErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@EALMySqlErrorSQLState_R,nil,'SQLState');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AlMySqlClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EALMySqlError(CL);
  RIRegister_TalMySqlClient(CL);
  RIRegister_TalMySqlConnectionPoolContainer(CL);
  RIRegister_TalMySqlConnectionPoolClient(CL);
end;

 
 
{ TPSImport_AlMySqlClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AlMySqlClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AlMySqlClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AlMySqlClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AlMySqlClient(ri);
  RIRegister_AlMySqlClient_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
