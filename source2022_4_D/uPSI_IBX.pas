//Source/ThirdParty/uPSI_IBX.pas

unit uPSI_IBX;
{ mXadded
  assign, create, free etc.
}

interface

uses
  SysUtils, Classes, uPSComponent, uPSCompiler, uPSRuntime;

type
  TPSImport_IBX = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure CompileImport2(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

{ run-time registration functions }
(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)


  procedure SIRegister_IBDatabase(CL: TPSPascalCompiler);
  procedure SIRegister_IBSQL(CL: TPSPascalCompiler);
  procedure SIRegister_IBCustomDataSet(CL: TPSPascalCompiler);
  procedure SIRegister_IBTable(CL: TPSPascalCompiler);
  procedure SIRegister_IBQuery(CL: TPSPascalCompiler);

procedure SIRegister_IBX(CL: TPSPascalCompiler);

//CL: TPSRuntimeClassImporter
  procedure RIRegister_IBDatabase(CL: TPSRuntimeClassImporter);
  procedure RIRegister_IBSQL(CL: TPSRuntimeClassImporter);
  procedure RIRegister_IBCustomDataSet(CL: TPSRuntimeClassImporter);
  procedure RIRegister_IBTable(CL: TPSRuntimeClassImporter);
  procedure RIRegister_IBQuery(CL: TPSRuntimeClassImporter);
  procedure RIRegister_IBSQL_Routines(S: TIFPSExec);


procedure RIRegister_IBX(CL: TPSRuntimeClassImporter);


implementation


uses
   WINDOWS
  ,CONTROLS
  ,IBEXTERNALS
  ,IB
  ,IBDatabase
  ,IBHEADER
  ,STDVCL
  ,IBSQL
  ,DB
  ,IBUTILS
  ,IBBLOB
  ,IBCustomDataSet
  ,IBTable
  ,IBQuery
  ;

procedure SIRegister_IBX(CL: TPSPascalCompiler);
begin
 SIRegister_IBDatabase(CL);
 SIRegister_IBSQL(CL);
 SIRegister_IBCustomDataSet(CL);
 SIRegister_IBTable(CL);
 SIRegister_IBQuery(CL);

end;

procedure RIRegister_IBX(CL: TPSRuntimeClassImporter);
//procedure TPSImport_IBX.CompileImport1(CompExec: TPSScript);
begin
 RIRegister_IBDatabase(CL);
  RIRegister_IBSQL(CL);
  RIRegister_IBCustomDataSet(CL);
  RIRegister_IBTable(CL);
  RIRegister_IBQuery(CL);
  //nextsqltoken
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBDATASET(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBCUSTOMDATASET', 'TIBDATASET') do
  with CL.AddClassN(CL.FindClass('TIBCUSTOMDATASET'),'TIBDATASET') do begin
    RegisterMethod('Procedure PREPARE');
    RegisterMethod('Procedure UNPREPARE');
    RegisterMethod('Procedure BATCHINPUT( INPUTOBJECT : TIBBATCHINPUT)');
    RegisterMethod('Procedure BATCHOUTPUT( OUTPUTOBJECT : TIBBATCHOUTPUT)');
    RegisterMethod('Procedure EXECSQL');
    RegisterMethod('Function PARAMBYNAME( IDX : STRING) : TIBXSQLVAR');
    RegisterPublishedProperties;
    RegisterProperty('PREPARED', 'BOOLEAN', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBCUSTOMDATASET(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDATASET', 'TIBCUSTOMDATASET') do
  with CL.AddClassN(CL.FindClass('TDATASET'),'TIBCUSTOMDATASET') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure APPLYUPDATES');
    RegisterMethod('Function CACHEDUPDATESTATUS : TCACHEDUPDATESTATUS');
    RegisterMethod('Procedure CANCELUPDATES');
    RegisterMethod('Procedure FETCHALL');
    RegisterMethod('Function LOCATENEXT( const KEYFIELDS : STRING; const KEYVALUES : VARIANT; OPTIONS : TLOCATEOPTIONS) : BOOLEAN');
// RegisterMethod('Function LOCATE( const KEYFIELDS : STRING; const KEYVALUES : VARIANT; OPTIONS : TLOCATEOPTIONS) : BOOLEAN');
    RegisterMethod('Procedure RECORDMODIFIED( VALUE : BOOLEAN)');
    RegisterMethod('Procedure REVERTRECORD');
    RegisterMethod('Procedure UNDELETE');
    RegisterMethod('Function CURRENT : TIBXSQLDA');
    RegisterMethod('Function SQLTYPE : TIBSQLTYPES');
    RegisterProperty('DBHANDLE', 'PISC_DB_HANDLE', iptr);
    RegisterProperty('TRHANDLE', 'PISC_TR_HANDLE', iptr);
    RegisterProperty('UPDATEOBJECT', 'TIBDATASETUPDATEOBJECT', iptrw);
    RegisterProperty('UPDATESPENDING', 'BOOLEAN', iptr);
    RegisterProperty('UPDATERECORDTYPES', 'TIBUPDATERECORDTYPES', iptrw);
    RegisterProperty('ROWSAFFECTED', 'INTEGER', iptr);
    RegisterProperty('PLAN', 'STRING', iptr);
    RegisterProperty('DATABASE', 'TIBDATABASE', iptrw);
    RegisterProperty('TRANSACTION', 'TIBTRANSACTION', iptrw);
    RegisterProperty('FORCEDREFRESH', 'BOOLEAN', iptrw);
    RegisterProperty('ONUPDATEERROR', 'TIBUPDATEERROREVENT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBGENERATORFIELD(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPERSISTENT', 'TIBGENERATORFIELD') do
  with CL.AddClassN(CL.FindClass('TPERSISTENT'),'TIBGENERATORFIELD') do begin
    RegisterMethod('Constructor CREATE( ADATASET : TIBCUSTOMDATASET)');
    RegisterMethod('Function VALUENAME : STRING');
    RegisterMethod('Procedure APPLY');
    RegisterProperty('FIELD', 'STRING', iptrw);
    RegisterProperty('GENERATOR', 'STRING', iptrw);
    RegisterProperty('INCREMENTBY', 'INTEGER', iptrw);
    RegisterProperty('APPLYEVENT', 'TIBGENERATORAPPLYEVENT', iptrw);
  end;
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBBASE(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIBBASE') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIBBASE') do begin
    RegisterMethod('Constructor CREATE( AOWNER : TOBJECT)');
    RegisterMethod('Procedure CHECKDATABASE');
    RegisterMethod('Procedure CHECKTRANSACTION');
    RegisterProperty('BEFOREDATABASEDISCONNECT', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('AFTERDATABASEDISCONNECT', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDATABASEFREE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('BEFORETRANSACTIONEND', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('AFTERTRANSACTIONEND', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONTRANSACTIONFREE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('DATABASE', 'TIBDATABASE', iptrw);
    RegisterProperty('DBHANDLE', 'PISC_DB_HANDLE', iptr);
    RegisterProperty('OWNER', 'TOBJECT', iptr);
    RegisterProperty('TRHANDLE', 'PISC_TR_HANDLE', iptr);
    RegisterProperty('TRANSACTION', 'TIBTRANSACTION', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBTRANSACTION(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCOMPONENT', 'TIBTRANSACTION') do
  with CL.AddClassN(CL.FindClass('TCOMPONENT'),'TIBTRANSACTION') do
  begin
    RegisterMethod('Function CALL( ERRCODE : ISC_STATUS; RAISEERROR : BOOLEAN) : ISC_STATUS');
    RegisterMethod('Procedure COMMIT');
    RegisterMethod('Procedure COMMITRETAINING');
    RegisterMethod('Procedure ROLLBACK');
    RegisterMethod('Procedure ROLLBACKRETAINING');
    RegisterMethod('Procedure STARTTRANSACTION');
    RegisterMethod('Procedure CHECKINTRANSACTION');
    RegisterMethod('Procedure CHECKNOTINTRANSACTION');
    RegisterMethod('Procedure CHECKAUTOSTOP');
    RegisterMethod('Function ADDDATABASE( DB : TIBDATABASE) : INTEGER');
    RegisterMethod('Function FINDDATABASE( DB : TIBDATABASE) : INTEGER');
    RegisterMethod('Function FINDDEFAULTDATABASE : TIBDATABASE');
    RegisterMethod('Procedure REMOVEDATABASE( IDX : INTEGER)');
    RegisterMethod('Procedure REMOVEDATABASES');
    RegisterMethod('Procedure CHECKDATABASESINLIST');
    RegisterProperty('DATABASECOUNT', 'INTEGER', iptr);
    RegisterProperty('DATABASES', 'TIBDATABASE INTEGER', iptr);
    RegisterProperty('SQLOBJECTCOUNT', 'INTEGER', iptr);
    RegisterProperty('SQLOBJECTS', 'TIBBASE INTEGER', iptr);
    RegisterProperty('HANDLE', 'TISC_TR_HANDLE', iptr);
    RegisterProperty('HANDLEISSHARED', 'BOOLEAN', iptr);
    RegisterProperty('INTRANSACTION', 'BOOLEAN', iptr);
    RegisterProperty('TPB', 'PCHAR', iptr);
    RegisterProperty('TPBLENGTH', 'SHORT', iptr);
    RegisterProperty('ACTIVE', 'BOOLEAN', iptrw);
    RegisterProperty('DEFAULTDATABASE', 'TIBDATABASE', iptrw);
    RegisterProperty('IDLETIMER', 'INTEGER', iptrw);
    RegisterProperty('DEFAULTACTION', 'TTRANSACTIONACTION', iptrw);
    RegisterProperty('PARAMS', 'TSTRINGS', iptrw);
    RegisterProperty('AUTOSTOPACTION', 'TAUTOSTOPACTION', iptrw);
    RegisterProperty('ONIDLETIMER', 'TNOTIFYEVENT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBDATABASE(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCUSTOMCONNECTION', 'TIBDATABASE') do
  with CL.AddClassN(CL.FindClass('TCUSTOMCONNECTION'),'TIBDATABASE') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ADDEVENTNOTIFIER( NOTIFIER : IIBEVENTNOTIFIER)');
    RegisterMethod('Procedure REMOVEEVENTNOTIFIER( NOTIFIER : IIBEVENTNOTIFIER)');
    RegisterMethod('Procedure APPLYUPDATES( const DATASETS : array of TDATASET)');
    RegisterMethod('Procedure CLOSEDATASETS');
    RegisterMethod('Procedure CHECKACTIVE');
    RegisterMethod('Procedure CHECKINACTIVE');
    RegisterMethod('Procedure CREATEDATABASE');
    RegisterMethod('Procedure DROPDATABASE');
    RegisterMethod('Procedure FORCECLOSE');
    RegisterMethod('Procedure GETFIELDNAMES( const TABLENAME : STRING; LIST : TSTRINGS)');
    RegisterMethod('Procedure GETTABLENAMES( LIST : TSTRINGS; SYSTEMTABLES : BOOLEAN)');
    RegisterMethod('Function INDEXOFDBCONST( ST : STRING) : INTEGER');
    RegisterMethod('Function TESTCONNECTED : BOOLEAN');
    RegisterMethod('Procedure CHECKDATABASENAME');
    RegisterMethod('Function CALL( ERRCODE : ISC_STATUS; RAISEERROR : BOOLEAN) : ISC_STATUS');
    RegisterMethod('Function ADDTRANSACTION( TR : TIBTRANSACTION) : INTEGER');
    RegisterMethod('Function FINDTRANSACTION( TR : TIBTRANSACTION) : INTEGER');
    RegisterMethod('Function FINDDEFAULTTRANSACTION( ) : TIBTRANSACTION');
    RegisterMethod('Procedure REMOVETRANSACTION( IDX : INTEGER)');
    RegisterMethod('Procedure REMOVETRANSACTIONS');
    RegisterMethod('Procedure SETHANDLE( VALUE : TISC_DB_HANDLE)');
    RegisterMethod('procedure Open');
    RegisterMethod('procedure Close');
    RegisterProperty('Connected','BOOLEAN',iptrw);
    RegisterProperty('HANDLE', 'TISC_DB_HANDLE', iptr);
    RegisterProperty('ISREADONLY', 'BOOLEAN', iptr);
    RegisterProperty('DBPARAMBYDPB', 'STRING INTEGER', iptrw);
    RegisterProperty('SQLOBJECTCOUNT', 'INTEGER', iptr);
    RegisterProperty('SQLOBJECTS', 'TIBBASE INTEGER', iptr);
    RegisterProperty('HANDLEISSHARED', 'BOOLEAN', iptr);
    RegisterProperty('TRANSACTIONCOUNT', 'INTEGER', iptr);
    RegisterProperty('TRANSACTIONS', 'TIBTRANSACTION INTEGER', iptr);
    RegisterProperty('INTERNALTRANSACTION', 'TIBTRANSACTION', iptr);
    RegisterMethod('Function HAS_DEFAULT_VALUE( RELATION, FIELD : STRING) : BOOLEAN');
    RegisterMethod('Function HAS_COMPUTED_BLR( RELATION, FIELD : STRING) : BOOLEAN');
    RegisterMethod('Procedure FLUSHSCHEMA');
    RegisterProperty('DATABASENAME', 'TIBFILENAME', iptrw);
    RegisterProperty('PARAMS', 'TSTRINGS', iptrw);
    RegisterProperty('DEFAULTTRANSACTION', 'TIBTRANSACTION', iptrw);
    RegisterProperty('IDLETIMER', 'INTEGER', iptrw);
    RegisterProperty('SQLDIALECT', 'INTEGER', iptrw);
    RegisterProperty('DBSQLDIALECT', 'INTEGER', iptr);
    RegisterProperty('TRACEFLAGS', 'TTRACEFLAGS', iptrw);
    RegisterProperty('ALLOWSTREAMEDCONNECTED', 'BOOLEAN', iptrw);
    RegisterProperty('ONLOGIN', 'TIBDATABASELOGINEVENT', iptrw);
    RegisterProperty('ONIDLETIMER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDIALECTDOWNGRADEWARNING', 'TNOTIFYEVENT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBSCHEMA(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIBSCHEMA') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIBSCHEMA') do begin
    RegisterMethod('Procedure FREENODES');
    RegisterMethod('Function HAS_DEFAULT_VALUE( RELATION, FIELD : STRING) : BOOLEAN');
    RegisterMethod('Function HAS_COMPUTED_BLR( RELATION, FIELD : STRING) : BOOLEAN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBDatabase(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBDATABASE');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBTRANSACTION');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBBASE');
  CL.AddTypeS('TIBDATABASELOGINEVENT', 'Procedure ( DATABASE : TIBDATABASE; LOG'
   +'INPARAMS : TSTRINGS)');
  SIRegister_TIBSCHEMA(CL);
  CL.AddTypeS('TIBFILENAME', 'STRING');
  SIRegister_TIBDATABASE(CL);
  CL.AddTypeS('TTRANSACTIONACTION', '( TAROLLBACK, TACOMMIT, TAROLLBACKRETAINING, TACOMMITRETAINING )');
  CL.AddTypeS('TAUTOSTOPACTION', '( SANONE, SAROLLBACK, SACOMMIT, SAROLLBACKRET'
   +'AINING, SACOMMITRETAINING )');
  SIRegister_TIBTRANSACTION(CL);
  SIRegister_TIBBASE(CL);
  CL.AddDelphiFunction('procedure GenerateDPB(sl: TStrings; var DPB: string; var DPBLength: Short);');
//procedure GenerateDPB(sl: TStrings; var DPB: string; var DPBLength: Short);
  CL.AddDelphiFunction('procedure GenerateTPB(sl: TStrings; var TPB: string; var TPBLength: Short);');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBBASETRANSACTION_W(Self: TIBBASE; const T: TIBTRANSACTION);
begin Self.TRANSACTION := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASETRANSACTION_R(Self: TIBBASE; var T: TIBTRANSACTION);
begin T := Self.TRANSACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASETRHANDLE_R(Self: TIBBASE; var T: PISC_TR_HANDLE);
begin T := Self.TRHANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEOWNER_R(Self: TIBBASE; var T: TOBJECT);
begin T := Self.OWNER; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEDBHANDLE_R(Self: TIBBASE; var T: PISC_DB_HANDLE);
begin T := Self.DBHANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEDATABASE_W(Self: TIBBASE; const T: TIBDATABASE);
begin Self.DATABASE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEDATABASE_R(Self: TIBBASE; var T: TIBDATABASE);
begin T := Self.DATABASE; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEONTRANSACTIONFREE_W(Self: TIBBASE; const T: TNOTIFYEVENT);
begin Self.ONTRANSACTIONFREE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEONTRANSACTIONFREE_R(Self: TIBBASE; var T: TNOTIFYEVENT);
begin T := Self.ONTRANSACTIONFREE; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEAFTERTRANSACTIONEND_W(Self: TIBBASE; const T: TNOTIFYEVENT);
begin Self.AFTERTRANSACTIONEND := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEAFTERTRANSACTIONEND_R(Self: TIBBASE; var T: TNOTIFYEVENT);
begin T := Self.AFTERTRANSACTIONEND; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEBEFORETRANSACTIONEND_W(Self: TIBBASE; const T: TNOTIFYEVENT);
begin Self.BEFORETRANSACTIONEND := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEBEFORETRANSACTIONEND_R(Self: TIBBASE; var T: TNOTIFYEVENT);
begin T := Self.BEFORETRANSACTIONEND; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEONDATABASEFREE_W(Self: TIBBASE; const T: TNOTIFYEVENT);
begin Self.ONDATABASEFREE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEONDATABASEFREE_R(Self: TIBBASE; var T: TNOTIFYEVENT);
begin T := Self.ONDATABASEFREE; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEAFTERDATABASEDISCONNECT_W(Self: TIBBASE; const T: TNOTIFYEVENT);
begin Self.AFTERDATABASEDISCONNECT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEAFTERDATABASEDISCONNECT_R(Self: TIBBASE; var T: TNOTIFYEVENT);
begin T := Self.AFTERDATABASEDISCONNECT; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEBEFOREDATABASEDISCONNECT_W(Self: TIBBASE; const T: TNOTIFYEVENT);
begin Self.BEFOREDATABASEDISCONNECT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBBASEBEFOREDATABASEDISCONNECT_R(Self: TIBBASE; var T: TNOTIFYEVENT);
begin T := Self.BEFOREDATABASEDISCONNECT; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONONIDLETIMER_W(Self: TIBTRANSACTION; const T: TNOTIFYEVENT);
begin Self.ONIDLETIMER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONONIDLETIMER_R(Self: TIBTRANSACTION; var T: TNOTIFYEVENT);
begin T := Self.ONIDLETIMER; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONAUTOSTOPACTION_W(Self: TIBTRANSACTION; const T: TAUTOSTOPACTION);
begin Self.AUTOSTOPACTION := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONAUTOSTOPACTION_R(Self: TIBTRANSACTION; var T: TAUTOSTOPACTION);
begin T := Self.AUTOSTOPACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONPARAMS_W(Self: TIBTRANSACTION; const T: TSTRINGS);
begin Self.PARAMS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONPARAMS_R(Self: TIBTRANSACTION; var T: TSTRINGS);
begin T := Self.PARAMS; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONDEFAULTACTION_W(Self: TIBTRANSACTION; const T: TIBTRANSACTIONAction);
begin Self.DEFAULTACTION := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONDEFAULTACTION_R(Self: TIBTRANSACTION; var T: TIBTRANSACTIONACTION);
begin T := Self.DEFAULTACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONIDLETIMER_W(Self: TIBTRANSACTION; const T: INTEGER);
begin Self.IDLETIMER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONIDLETIMER_R(Self: TIBTRANSACTION; var T: INTEGER);
begin T := Self.IDLETIMER; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONDEFAULTDATABASE_W(Self: TIBTRANSACTION; const T: TIBDATABASE);
begin Self.DEFAULTDATABASE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONDEFAULTDATABASE_R(Self: TIBTRANSACTION; var T: TIBDATABASE);
begin T := Self.DEFAULTDATABASE; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONACTIVE_W(Self: TIBTRANSACTION; const T: BOOLEAN);
begin Self.ACTIVE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONACTIVE_R(Self: TIBTRANSACTION; var T: BOOLEAN);
begin T := Self.ACTIVE; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONTPBLENGTH_R(Self: TIBTRANSACTION; var T: SHORT);
begin T := Self.TPBLENGTH; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONTPB_R(Self: TIBTRANSACTION; var T: PCHAR);
begin T := Self.TPB; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONINTRANSACTION_R(Self: TIBTRANSACTION; var T: BOOLEAN);
begin T := Self.INTRANSACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONHANDLEISSHARED_R(Self: TIBTRANSACTION; var T: BOOLEAN);
begin T := Self.HANDLEISSHARED; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONHANDLE_R(Self: TIBTRANSACTION; var T: TISC_TR_HANDLE);
begin T := Self.HANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONSQLOBJECTS_R(Self: TIBTRANSACTION; var T: TIBBASE; const t1: INTEGER);
begin T := Self.SQLOBJECTS[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONSQLOBJECTCOUNT_R(Self: TIBTRANSACTION; var T: INTEGER);
begin T := Self.SQLOBJECTCOUNT; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONDATABASES_R(Self: TIBTRANSACTION; var T: TIBDATABASE; const t1: INTEGER);
begin T := Self.DATABASES[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBTRANSACTIONDATABASECOUNT_R(Self: TIBTRANSACTION; var T: INTEGER);
begin T := Self.DATABASECOUNT; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEONDIALECTDOWNGRADEWARNING_W(Self: TIBDATABASE; const T: TNOTIFYEVENT);
begin Self.ONDIALECTDOWNGRADEWARNING := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEONDIALECTDOWNGRADEWARNING_R(Self: TIBDATABASE; var T: TNOTIFYEVENT);
begin T := Self.ONDIALECTDOWNGRADEWARNING; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEONIDLETIMER_W(Self: TIBDATABASE; const T: TNOTIFYEVENT);
begin Self.ONIDLETIMER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEONIDLETIMER_R(Self: TIBDATABASE; var T: TNOTIFYEVENT);
begin T := Self.ONIDLETIMER; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEONLOGIN_W(Self: TIBDATABASE; const T: TIBDATABASELOGINEVENT);
begin Self.ONLOGIN := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEONLOGIN_R(Self: TIBDATABASE; var T: TIBDATABASELOGINEVENT);
begin T := Self.ONLOGIN; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASECONNECTED_W(Self: TIBDATABASE; const T: Boolean);
begin Self.Connected := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASECONNECTED_R(Self: TIBDATABASE; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEALLOWSTREAMEDCONNECTED_W(Self: TIBDATABASE; const T: BOOLEAN);
begin Self.ALLOWSTREAMEDCONNECTED := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEALLOWSTREAMEDCONNECTED_R(Self: TIBDATABASE; var T: BOOLEAN);
begin T := Self.ALLOWSTREAMEDCONNECTED; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASETRACEFLAGS_W(Self: TIBDATABASE; const T: TTRACEFLAGS);
begin Self.TRACEFLAGS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASETRACEFLAGS_R(Self: TIBDATABASE; var T: TTRACEFLAGS);
begin T := Self.TRACEFLAGS; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEDBSQLDIALECT_R(Self: TIBDATABASE; var T: INTEGER);
begin T := Self.DBSQLDIALECT; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASESQLDIALECT_W(Self: TIBDATABASE; const T: INTEGER);
begin Self.SQLDIALECT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASESQLDIALECT_R(Self: TIBDATABASE; var T: INTEGER);
begin T := Self.SQLDIALECT; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEIDLETIMER_W(Self: TIBDATABASE; const T: INTEGER);
begin Self.IDLETIMER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEIDLETIMER_R(Self: TIBDATABASE; var T: INTEGER);
begin T := Self.IDLETIMER; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEDEFAULTTRANSACTION_W(Self: TIBDATABASE; const T: TIBTRANSACTION);
begin Self.DEFAULTTRANSACTION := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEDEFAULTTRANSACTION_R(Self: TIBDATABASE; var T: TIBTRANSACTION);
begin T := Self.DEFAULTTRANSACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEPARAMS_W(Self: TIBDATABASE; const T: TSTRINGS);
begin Self.PARAMS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEPARAMS_R(Self: TIBDATABASE; var T: TSTRINGS);
begin T := Self.PARAMS; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEDATABASENAME_W(Self: TIBDATABASE; const T: TIBFILENAME);
begin Self.DATABASENAME := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEDATABASENAME_R(Self: TIBDATABASE; var T: TIBFILENAME);
begin T := Self.DATABASENAME; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEINTERNALTRANSACTION_R(Self: TIBDATABASE; var T: TIBTRANSACTION);
begin T := Self.INTERNALTRANSACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASETRANSACTIONS_R(Self: TIBDATABASE; var T: TIBTRANSACTION; const t1: INTEGER);
begin T := Self.TRANSACTIONS[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASETRANSACTIONCOUNT_R(Self: TIBDATABASE; var T: INTEGER);
begin T := Self.TRANSACTIONCOUNT; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEHANDLEISSHARED_R(Self: TIBDATABASE; var T: BOOLEAN);
begin T := Self.HANDLEISSHARED; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASESQLOBJECTS_R(Self: TIBDATABASE; var T: TIBBASE; const t1: INTEGER);
begin T := Self.SQLOBJECTS[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASESQLOBJECTCOUNT_R(Self: TIBDATABASE; var T: INTEGER);
begin T := Self.SQLOBJECTCOUNT; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEDBPARAMBYDPB_W(Self: TIBDATABASE; const T: STRING; const t1: INTEGER);
begin Self.DBPARAMBYDPB[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEDBPARAMBYDPB_R(Self: TIBDATABASE; var T: STRING; const t1: INTEGER);
begin T := Self.DBPARAMBYDPB[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEISREADONLY_R(Self: TIBDATABASE; var T: BOOLEAN);
begin T := Self.ISREADONLY; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATABASEHANDLE_R(Self: TIBDATABASE; var T: TISC_DB_HANDLE);
begin T := Self.HANDLE; end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBDATALINK(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDETAILDATALINK', 'TIBDATALINK') do
  with CL.AddClassN(CL.FindClass('TDETAILDATALINK'),'TIBDATALINK') do
  begin
    RegisterMethod('Constructor CREATE( ADATASET : TIBCUSTOMDATASET)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBBCDFIELD(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBCDFIELD', 'TIBBCDFIELD') do
  with CL.AddClassN(CL.FindClass('TBCDFIELD'),'TIBBCDFIELD') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBSTRINGFIELD(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSTRINGFIELD', 'TIBSTRINGFIELD') do
  with CL.AddClassN(CL.FindClass('TSTRINGFIELD'),'TIBSTRINGFIELD') do
  begin
    RegisterMethod('Function GETVALUE( var VALUE : STRING) : BOOLEAN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBDATASETUPDATEOBJECT(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCOMPONENT', 'TIBDATASETUPDATEOBJECT') do
  with CL.AddClassN(CL.FindClass('TCOMPONENT'),'TIBDATASETUPDATEOBJECT') do
  begin
    RegisterProperty('REFRESHSQL', 'TSTRINGS', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBCustomDataSet(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('BUFFERCACHESIZE','LONGINT').SetInt( 1000);
 CL.AddConstantN('UNICACHE','LONGINT').SetInt( 2);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBCUSTOMDATASET');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBDATASET');
  SIRegister_TIBDATASETUPDATEOBJECT(CL);
  CL.AddTypeS('TCACHEDUPDATESTATUS', '( CUSUNMODIFIED, CUSMODIFIED, CUSINSERTED'
   +', CUSDELETED, CUSUNINSERTED )');
  SIRegister_TIBSTRINGFIELD(CL);
  SIRegister_TIBBCDFIELD(CL);
  SIRegister_TIBDATALINK(CL);
  CL.AddTypeS('TIBGENERATORAPPLYEVENT', '( GAMONNEWRECORD, GAMONPOST, GAMONSERVER )');
  SIRegister_TIBGENERATORFIELD(CL);
  CL.AddTypeS('TIBUPDATEACTION', '( UAFAIL, UAABORT, UASKIP, UARETRY, UAAPPLY, UAAPPLIED )');
  CL.AddTypeS('TIBUPDATERECORDTYPES', 'set of TCACHEDUPDATESTATUS');
  CL.AddTypeS('TLIVEMODE', '( LMINSERT, LMMODIFY, LMDELETE, LMREFRESH )');
  CL.AddTypeS('TLIVEMODES', 'set of TLIVEMODE');
  SIRegister_TIBCUSTOMDATASET(CL);
  SIRegister_TIBDATASET(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBDATASETPREPARED_R(Self: TIBDATASET; var T: BOOLEAN);
begin T := Self.PREPARED; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETFORCEDREFRESH_W(Self: TIBCUSTOMDATASET; const T: BOOLEAN);
begin Self.FORCEDREFRESH := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETFORCEDREFRESH_R(Self: TIBCUSTOMDATASET; var T: BOOLEAN);
begin T := Self.FORCEDREFRESH; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETTRANSACTION_W(Self: TIBCUSTOMDATASET; const T: TIBTRANSACTION);
begin Self.TRANSACTION := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETTRANSACTION_R(Self: TIBCUSTOMDATASET; var T: TIBTRANSACTION);
begin T := Self.TRANSACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETDATABASE_W(Self: TIBCUSTOMDATASET; const T: TIBDATABASE);
begin Self.DATABASE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETDATABASE_R(Self: TIBCUSTOMDATASET; var T: TIBDATABASE);
begin T := Self.DATABASE; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETPLAN_R(Self: TIBCUSTOMDATASET; var T: STRING);
begin T := Self.PLAN; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETROWSAFFECTED_R(Self: TIBCUSTOMDATASET; var T: INTEGER);
begin T := Self.ROWSAFFECTED; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETUPDATERECORDTYPES_W(Self: TIBCUSTOMDATASET; const T: TIBUPDATERECORDTYPES);
begin Self.UPDATERECORDTYPES := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETUPDATERECORDTYPES_R(Self: TIBCUSTOMDATASET; var T: TIBUPDATERECORDTYPES);
begin T := Self.UPDATERECORDTYPES; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETUPDATESPENDING_R(Self: TIBCUSTOMDATASET; var T: BOOLEAN);
begin T := Self.UPDATESPENDING; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETUPDATEOBJECT_W(Self: TIBCUSTOMDATASET; const T: TIBDATASETUPDATEOBJECT);
begin Self.UPDATEOBJECT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETUPDATEOBJECT_R(Self: TIBCUSTOMDATASET; var T: TIBDATASETUPDATEOBJECT);
begin T := Self.UPDATEOBJECT; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETTRHANDLE_R(Self: TIBCUSTOMDATASET; var T: PISC_TR_HANDLE);
begin T := Self.TRHANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBCUSTOMDATASETDBHANDLE_R(Self: TIBCUSTOMDATASET; var T: PISC_DB_HANDLE);
begin T := Self.DBHANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDAPPLYEVENT_W(Self: TIBGENERATORFIELD; const T: TIBGENERATORAPPLYEVENT);
begin Self.APPLYEVENT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDAPPLYEVENT_R(Self: TIBGENERATORFIELD; var T: TIBGENERATORAPPLYEVENT);
begin T := Self.APPLYEVENT; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDINCREMENTBY_W(Self: TIBGENERATORFIELD; const T: INTEGER);
begin Self.INCREMENTBY := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDINCREMENTBY_R(Self: TIBGENERATORFIELD; var T: INTEGER);
begin T := Self.INCREMENTBY; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDGENERATOR_W(Self: TIBGENERATORFIELD; const T: STRING);
begin Self.GENERATOR := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDGENERATOR_R(Self: TIBGENERATORFIELD; var T: STRING);
begin T := Self.GENERATOR; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDFIELD_W(Self: TIBGENERATORFIELD; const T: STRING);
begin Self.FIELD := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBGENERATORFIELDFIELD_R(Self: TIBGENERATORFIELD; var T: STRING);
begin T := Self.FIELD; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATASETUPDATEOBJECTREFRESHSQL_W(Self: TIBDATASETUPDATEOBJECT; const T: TSTRINGS);
begin Self.REFRESHSQL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBDATASETUPDATEOBJECTREFRESHSQL_R(Self: TIBDATASETUPDATEOBJECT; var T: TSTRINGS);
begin T := Self.REFRESHSQL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBDATASET(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBDATASET) do
  begin
    RegisterMethod(@TIBDATASET.PREPARE, 'PREPARE');
    RegisterMethod(@TIBDATASET.UNPREPARE, 'UNPREPARE');
    RegisterMethod(@TIBDATASET.BATCHINPUT, 'BATCHINPUT');
    RegisterMethod(@TIBDATASET.BATCHOUTPUT, 'BATCHOUTPUT');
    RegisterMethod(@TIBDATASET.EXECSQL, 'EXECSQL');
    RegisterMethod(@TIBDATASET.PARAMBYNAME, 'PARAMBYNAME');
    RegisterPropertyHelper(@TIBDATASETPREPARED_R,nil,'PREPARED');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBCUSTOMDATASET(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBCUSTOMDATASET) do begin
    RegisterConstructor(@TIBCUSTOMDATASET.Create, 'Create');
    RegisterMethod(@TIBCUSTOMDATASET.Destroy, 'Free');
    RegisterMethod(@TIBCUSTOMDATASET.APPLYUPDATES, 'APPLYUPDATES');
    RegisterMethod(@TIBCUSTOMDATASET.CACHEDUPDATESTATUS, 'CACHEDUPDATESTATUS');
    RegisterMethod(@TIBCUSTOMDATASET.CANCELUPDATES, 'CANCELUPDATES');
    RegisterMethod(@TIBCUSTOMDATASET.FETCHALL, 'FETCHALL');
    RegisterMethod(@TIBCUSTOMDATASET.LOCATENEXT, 'LOCATENEXT');
// RegisterMethod(@TIBCUSTOMDATASET.LOCATE, 'LOCATE');
    RegisterMethod(@TIBCUSTOMDATASET.RECORDMODIFIED, 'RECORDMODIFIED');
    RegisterMethod(@TIBCUSTOMDATASET.REVERTRECORD, 'REVERTRECORD');
    RegisterMethod(@TIBCUSTOMDATASET.UNDELETE, 'UNDELETE');
    RegisterMethod(@TIBCUSTOMDATASET.CURRENT, 'CURRENT');
    RegisterMethod(@TIBCUSTOMDATASET.SQLTYPE, 'SQLTYPE');
    RegisterPropertyHelper(@TIBCUSTOMDATASETDBHANDLE_R,nil,'DBHANDLE');
    RegisterPropertyHelper(@TIBCUSTOMDATASETTRHANDLE_R,nil,'TRHANDLE');
    RegisterPropertyHelper(@TIBCUSTOMDATASETUPDATEOBJECT_R,@TIBCUSTOMDATASETUPDATEOBJECT_W,'UPDATEOBJECT');
    RegisterPropertyHelper(@TIBCUSTOMDATASETUPDATESPENDING_R,nil,'UPDATESPENDING');
    RegisterPropertyHelper(@TIBCUSTOMDATASETUPDATERECORDTYPES_R,@TIBCUSTOMDATASETUPDATERECORDTYPES_W,'UPDATERECORDTYPES');
    RegisterPropertyHelper(@TIBCUSTOMDATASETROWSAFFECTED_R,nil,'ROWSAFFECTED');
    RegisterPropertyHelper(@TIBCUSTOMDATASETPLAN_R,nil,'PLAN');
    RegisterPropertyHelper(@TIBCUSTOMDATASETDATABASE_R,@TIBCUSTOMDATASETDATABASE_W,'DATABASE');
    RegisterPropertyHelper(@TIBCUSTOMDATASETTRANSACTION_R,@TIBCUSTOMDATASETTRANSACTION_W,'TRANSACTION');
    RegisterPropertyHelper(@TIBCUSTOMDATASETFORCEDREFRESH_R,@TIBCUSTOMDATASETFORCEDREFRESH_W,'FORCEDREFRESH');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBGENERATORFIELD(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBGENERATORFIELD) do
  begin
    RegisterConstructor(@TIBGENERATORFIELD.CREATE, 'CREATE');
    RegisterMethod(@TIBGENERATORFIELD.VALUENAME, 'VALUENAME');
    RegisterMethod(@TIBGENERATORFIELD.APPLY, 'APPLY');
    RegisterPropertyHelper(@TIBGENERATORFIELDFIELD_R,@TIBGENERATORFIELDFIELD_W,'FIELD');
    RegisterPropertyHelper(@TIBGENERATORFIELDGENERATOR_R,@TIBGENERATORFIELDGENERATOR_W,'GENERATOR');
    RegisterPropertyHelper(@TIBGENERATORFIELDINCREMENTBY_R,@TIBGENERATORFIELDINCREMENTBY_W,'INCREMENTBY');
    RegisterPropertyHelper(@TIBGENERATORFIELDAPPLYEVENT_R,@TIBGENERATORFIELDAPPLYEVENT_W,'APPLYEVENT');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBDATALINK(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBDATALINK) do
  begin
    RegisterConstructor(@TIBDATALINK.CREATE, 'CREATE');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBBCDFIELD(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBBCDFIELD) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBSTRINGFIELD(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBSTRINGFIELD) do
  begin
    RegisterMethod(@TIBSTRINGFIELD.GETVALUE, 'GETVALUE');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBDATASETUPDATEOBJECT(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBDATASETUPDATEOBJECT) do
  begin
    RegisterPropertyHelper(@TIBDATASETUPDATEOBJECTREFRESHSQL_R,@TIBDATASETUPDATEOBJECTREFRESHSQL_W,'REFRESHSQL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBCustomDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBCUSTOMDATASET) do
  with CL.Add(TIBDATASET) do
  RIRegister_TIBDATASETUPDATEOBJECT(CL);
  RIRegister_TIBSTRINGFIELD(CL);
  RIRegister_TIBBCDFIELD(CL);
  RIRegister_TIBDATALINK(CL);
  RIRegister_TIBGENERATORFIELD(CL);
  RIRegister_TIBCUSTOMDATASET(CL);
  RIRegister_TIBDATASET(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBBASE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBBASE) do begin
    RegisterConstructor(@TIBBASE.CREATE, 'CREATE');
    RegisterVirtualMethod(@TIBBASE.CHECKDATABASE, 'CHECKDATABASE');
    RegisterVirtualMethod(@TIBBASE.CHECKTRANSACTION, 'CHECKTRANSACTION');
    RegisterPropertyHelper(@TIBBASEBEFOREDATABASEDISCONNECT_R,@TIBBASEBEFOREDATABASEDISCONNECT_W,'BEFOREDATABASEDISCONNECT');
    RegisterPropertyHelper(@TIBBASEAFTERDATABASEDISCONNECT_R,@TIBBASEAFTERDATABASEDISCONNECT_W,'AFTERDATABASEDISCONNECT');
    RegisterEventPropertyHelper(@TIBBASEONDATABASEFREE_R,@TIBBASEONDATABASEFREE_W,'ONDATABASEFREE');
    RegisterPropertyHelper(@TIBBASEBEFORETRANSACTIONEND_R,@TIBBASEBEFORETRANSACTIONEND_W,'BEFORETRANSACTIONEND');
    RegisterPropertyHelper(@TIBBASEAFTERTRANSACTIONEND_R,@TIBBASEAFTERTRANSACTIONEND_W,'AFTERTRANSACTIONEND');
    RegisterEventPropertyHelper(@TIBBASEONTRANSACTIONFREE_R,@TIBBASEONTRANSACTIONFREE_W,'ONTRANSACTIONFREE');
    RegisterPropertyHelper(@TIBBASEDATABASE_R,@TIBBASEDATABASE_W,'DATABASE');
    RegisterPropertyHelper(@TIBBASEDBHANDLE_R,nil,'DBHANDLE');
    RegisterPropertyHelper(@TIBBASEOWNER_R,nil,'OWNER');
    RegisterPropertyHelper(@TIBBASETRHANDLE_R,nil,'TRHANDLE');
    RegisterPropertyHelper(@TIBBASETRANSACTION_R,@TIBBASETRANSACTION_W,'TRANSACTION');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBTRANSACTION(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBTRANSACTION) do begin
    RegisterMethod(@TIBTRANSACTION.CALL, 'CALL');
    RegisterMethod(@TIBTRANSACTION.COMMIT, 'COMMIT');
    RegisterMethod(@TIBTRANSACTION.COMMITRETAINING, 'COMMITRETAINING');
    RegisterMethod(@TIBTRANSACTION.ROLLBACK, 'ROLLBACK');
    RegisterMethod(@TIBTRANSACTION.ROLLBACKRETAINING, 'ROLLBACKRETAINING');
    RegisterMethod(@TIBTRANSACTION.STARTTRANSACTION, 'STARTTRANSACTION');
    RegisterMethod(@TIBTRANSACTION.CHECKINTRANSACTION, 'CHECKINTRANSACTION');
    RegisterMethod(@TIBTRANSACTION.CHECKNOTINTRANSACTION, 'CHECKNOTINTRANSACTION');
    RegisterMethod(@TIBTRANSACTION.CHECKAUTOSTOP, 'CHECKAUTOSTOP');
    RegisterMethod(@TIBTRANSACTION.ADDDATABASE, 'ADDDATABASE');
    RegisterMethod(@TIBTRANSACTION.FINDDATABASE, 'FINDDATABASE');
    RegisterMethod(@TIBTRANSACTION.FINDDEFAULTDATABASE, 'FINDDEFAULTDATABASE');
    RegisterMethod(@TIBTRANSACTION.REMOVEDATABASE, 'REMOVEDATABASE');
    RegisterMethod(@TIBTRANSACTION.REMOVEDATABASES, 'REMOVEDATABASES');
    RegisterMethod(@TIBTRANSACTION.CHECKDATABASESINLIST, 'CHECKDATABASESINLIST');
    RegisterPropertyHelper(@TIBTRANSACTIONDATABASECOUNT_R,nil,'DATABASECOUNT');
    RegisterPropertyHelper(@TIBTRANSACTIONDATABASES_R,nil,'DATABASES');
    RegisterPropertyHelper(@TIBTRANSACTIONSQLOBJECTCOUNT_R,nil,'SQLOBJECTCOUNT');
    RegisterPropertyHelper(@TIBTRANSACTIONSQLOBJECTS_R,nil,'SQLOBJECTS');
    RegisterPropertyHelper(@TIBTRANSACTIONHANDLE_R,nil,'HANDLE');
    RegisterPropertyHelper(@TIBTRANSACTIONHANDLEISSHARED_R,nil,'HANDLEISSHARED');
    RegisterPropertyHelper(@TIBTRANSACTIONINTRANSACTION_R,nil,'INTRANSACTION');
    RegisterPropertyHelper(@TIBTRANSACTIONTPB_R,nil,'TPB');
    RegisterPropertyHelper(@TIBTRANSACTIONTPBLENGTH_R,nil,'TPBLENGTH');
    RegisterPropertyHelper(@TIBTRANSACTIONACTIVE_R,@TIBTRANSACTIONACTIVE_W,'ACTIVE');
    RegisterPropertyHelper(@TIBTRANSACTIONDEFAULTDATABASE_R,@TIBTRANSACTIONDEFAULTDATABASE_W,'DEFAULTDATABASE');
    RegisterPropertyHelper(@TIBTRANSACTIONIDLETIMER_R,@TIBTRANSACTIONIDLETIMER_W,'IDLETIMER');
    RegisterPropertyHelper(@TIBTRANSACTIONDEFAULTACTION_R,@TIBTRANSACTIONDEFAULTACTION_W,'DEFAULTACTION');
    RegisterPropertyHelper(@TIBTRANSACTIONPARAMS_R,@TIBTRANSACTIONPARAMS_W,'PARAMS');
    RegisterPropertyHelper(@TIBTRANSACTIONAUTOSTOPACTION_R,@TIBTRANSACTIONAUTOSTOPACTION_W,'AUTOSTOPACTION');
    RegisterEventPropertyHelper(@TIBTRANSACTIONONIDLETIMER_R,@TIBTRANSACTIONONIDLETIMER_W,'ONIDLETIMER');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBDATABASE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBDATABASE) do begin
    RegisterConstructor(@TIBDATABASE.Create, 'Create');
    RegisterMethod(@TIBDATABASE.Destroy, 'Free');
    RegisterMethod(@TIBDATABASE.ADDEVENTNOTIFIER, 'ADDEVENTNOTIFIER');
    RegisterMethod(@TIBDATABASE.REMOVEEVENTNOTIFIER, 'REMOVEEVENTNOTIFIER');
    RegisterMethod(@TIBDATABASE.APPLYUPDATES, 'APPLYUPDATES');
    RegisterMethod(@TIBDATABASE.CLOSEDATASETS, 'CLOSEDATASETS');
    RegisterMethod(@TIBDATABASE.CHECKACTIVE, 'CHECKACTIVE');
    RegisterMethod(@TIBDATABASE.CHECKINACTIVE, 'CHECKINACTIVE');
    RegisterMethod(@TIBDATABASE.CREATEDATABASE, 'CREATEDATABASE');
    RegisterMethod(@TIBDATABASE.DROPDATABASE, 'DROPDATABASE');
    RegisterMethod(@TIBDATABASE.FORCECLOSE, 'FORCECLOSE');
    RegisterMethod(@TIBDATABASE.GETFIELDNAMES, 'GETFIELDNAMES');
    RegisterMethod(@TIBDATABASE.GETTABLENAMES, 'GETTABLENAMES');
    RegisterMethod(@TIBDATABASE.INDEXOFDBCONST, 'INDEXOFDBCONST');
    RegisterMethod(@TIBDATABASE.TESTCONNECTED, 'TESTCONNECTED');
    RegisterMethod(@TIBDATABASE.CHECKDATABASENAME, 'CHECKDATABASENAME');
    RegisterMethod(@TIBDATABASE.CALL, 'CALL');
    RegisterMethod(@TIBDATABASE.Open, 'OPEN');
    RegisterMethod(@TIBDATABASE.Close, 'CLOSE');
    RegisterMethod(@TIBDATABASE.ADDTRANSACTION, 'ADDTRANSACTION');
    RegisterMethod(@TIBDATABASE.FINDTRANSACTION, 'FINDTRANSACTION');
    RegisterMethod(@TIBDATABASE.FINDDEFAULTTRANSACTION, 'FINDDEFAULTTRANSACTION');
    RegisterMethod(@TIBDATABASE.REMOVETRANSACTION, 'REMOVETRANSACTION');
    RegisterMethod(@TIBDATABASE.REMOVETRANSACTIONS, 'REMOVETRANSACTIONS');
    RegisterMethod(@TIBDATABASE.SETHANDLE, 'SETHANDLE');
    RegisterPropertyHelper(@TIBDATABASEHANDLE_R,nil,'HANDLE');
    RegisterPropertyHelper(@TIBDATABASEISREADONLY_R,nil,'ISREADONLY');
    RegisterPropertyHelper(@TIBDATABASEDBPARAMBYDPB_R,@TIBDATABASEDBPARAMBYDPB_W,'DBPARAMBYDPB');
    RegisterPropertyHelper(@TIBDATABASESQLOBJECTCOUNT_R,nil,'SQLOBJECTCOUNT');
    RegisterPropertyHelper(@TIBDATABASESQLOBJECTS_R,nil,'SQLOBJECTS');
    RegisterPropertyHelper(@TIBDATABASEHANDLEISSHARED_R,nil,'HANDLEISSHARED');
    RegisterPropertyHelper(@TIBDATABASETRANSACTIONCOUNT_R,nil,'TRANSACTIONCOUNT');
    RegisterPropertyHelper(@TIBDATABASETRANSACTIONS_R,nil,'TRANSACTIONS');
    RegisterPropertyHelper(@TIBDATABASEINTERNALTRANSACTION_R,nil,'INTERNALTRANSACTION');
    RegisterMethod(@TIBDATABASE.HAS_DEFAULT_VALUE, 'HAS_DEFAULT_VALUE');
    RegisterMethod(@TIBDATABASE.HAS_COMPUTED_BLR, 'HAS_COMPUTED_BLR');
    RegisterMethod(@TIBDATABASE.FLUSHSCHEMA, 'FLUSHSCHEMA');
    RegisterPropertyHelper(@TIBDATABASEDATABASENAME_R,@TIBDATABASEDATABASENAME_W,'DATABASENAME');
    RegisterPropertyHelper(@TIBDATABASECONNECTED_R,@TIBDATABASECONNECTED_W,'CONNECTED');
    RegisterPropertyHelper(@TIBDATABASEPARAMS_R,@TIBDATABASEPARAMS_W,'PARAMS');
    RegisterPropertyHelper(@TIBDATABASEDEFAULTTRANSACTION_R,@TIBDATABASEDEFAULTTRANSACTION_W,'DEFAULTTRANSACTION');
    RegisterPropertyHelper(@TIBDATABASEIDLETIMER_R,@TIBDATABASEIDLETIMER_W,'IDLETIMER');
    RegisterPropertyHelper(@TIBDATABASESQLDIALECT_R,@TIBDATABASESQLDIALECT_W,'SQLDIALECT');
    RegisterPropertyHelper(@TIBDATABASEDBSQLDIALECT_R,nil,'DBSQLDIALECT');
    RegisterPropertyHelper(@TIBDATABASETRACEFLAGS_R,@TIBDATABASETRACEFLAGS_W,'TRACEFLAGS');
    RegisterPropertyHelper(@TIBDATABASEALLOWSTREAMEDCONNECTED_R,@TIBDATABASEALLOWSTREAMEDCONNECTED_W,'ALLOWSTREAMEDCONNECTED');
    RegisterEventPropertyHelper(@TIBDATABASEONLOGIN_R,@TIBDATABASEONLOGIN_W,'ONLOGIN');
    RegisterEventPropertyHelper(@TIBDATABASEONIDLETIMER_R,@TIBDATABASEONIDLETIMER_W,'ONIDLETIMER');
    RegisterEventPropertyHelper(@TIBDATABASEONDIALECTDOWNGRADEWARNING_R,@TIBDATABASEONDIALECTDOWNGRADEWARNING_W,'ONDIALECTDOWNGRADEWARNING');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBDatabase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBDATABASE) do
  with CL.Add(TIBTRANSACTION) do
  with CL.Add(TIBBASE) do
  RIRegister_TIBDATABASE(CL);
  RIRegister_TIBTRANSACTION(CL);
  RIRegister_TIBBASE(CL);
  //S.RegisterDelphiFunction(@OUTPUTXML, 'OUTPUTXML', cdRegister);

end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBTABLE(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBCUSTOMDATASET', 'TIBTABLE') do
  with CL.AddClassN(CL.FindClass('TIBCUSTOMDATASET'),'TIBTABLE') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('function Locate(const KeyFields: string; const KeyValues: Variant;'+
                    'Options: TLocateOptions): Boolean;');
    RegisterMethod('Procedure ADDINDEX( const NAME, FIELDS : STRING; OPTIONS : TINDEXOPTIONS; const DESCFIELDS : STRING)');
    RegisterMethod('Procedure CREATETABLE');
    RegisterMethod('Procedure DELETEINDEX( const NAME : STRING)');
    RegisterMethod('Procedure DELETETABLE');
    RegisterMethod('Procedure EMPTYTABLE');
    RegisterMethod('Procedure GETINDEXNAMES( LIST : TSTRINGS)');
    RegisterMethod('Procedure GOTOCURRENT( TABLE : TIBTABLE)');
    RegisterPublishedProperties;
    RegisterProperty('CURRENTDBKEY', 'TIBDBKEY', iptr);
    RegisterProperty('EXISTS', 'BOOLEAN', iptr);
    RegisterProperty('INDEXFIELDCOUNT', 'INTEGER', iptr);
    RegisterProperty('INDEXFIELDS', 'TFIELD INTEGER', iptrw);
    RegisterProperty('TABLENAMES', 'TSTRINGS', iptr);
    RegisterProperty('DEFAULTINDEX', 'BOOLEAN', iptrw);
    RegisterProperty('INDEXDEFS', 'TINDEXDEFS', iptrw);
    RegisterProperty('INDEXFIELDNAMES', 'STRING', iptrw);
    RegisterProperty('INDEXNAME', 'STRING', iptrw);
    RegisterProperty('MASTERFIELDS', 'STRING', iptrw);
    RegisterProperty('MASTERSOURCE', 'TDATASOURCE', iptrw);
    RegisterProperty('READONLY', 'BOOLEAN', iptrw);
    RegisterProperty('STOREDEFS', 'BOOLEAN', iptrw);
    RegisterProperty('TABLENAME', 'STRING', iptrw);
    RegisterProperty('TABLETYPES', 'TIBTABLETYPES', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBTable(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIBTABLETYPE', '( TTSYSTEM, TTVIEW )');
  CL.AddTypeS('TIBTABLETYPES', 'set of TIBTABLETYPE');
  CL.AddTypeS('TINDEXNAME', 'STRING');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBTABLE');
  SIRegister_TIBTABLE(CL);

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBTABLETABLETYPES_W(Self: TIBTABLE; const T: TIBTABLETYPES);
begin Self.TABLETYPES := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLETABLETYPES_R(Self: TIBTABLE; var T: TIBTABLETYPES);
begin T := Self.TABLETYPES; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLETABLENAME_W(Self: TIBTABLE; const T: STRING);
begin Self.TABLENAME := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLETABLENAME_R(Self: TIBTABLE; var T: STRING);
begin T := Self.TABLENAME; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLESTOREDEFS_W(Self: TIBTABLE; const T: BOOLEAN);
begin Self.STOREDEFS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLESTOREDEFS_R(Self: TIBTABLE; var T: BOOLEAN);
begin T := Self.STOREDEFS; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEREADONLY_W(Self: TIBTABLE; const T: BOOLEAN);
begin Self.READONLY := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEREADONLY_R(Self: TIBTABLE; var T: BOOLEAN);
begin T := Self.READONLY; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEMASTERSOURCE_W(Self: TIBTABLE; const T: TDATASOURCE);
begin Self.MASTERSOURCE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEMASTERSOURCE_R(Self: TIBTABLE; var T: TDATASOURCE);
begin T := Self.MASTERSOURCE; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEMASTERFIELDS_W(Self: TIBTABLE; const T: STRING);
begin Self.MASTERFIELDS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEMASTERFIELDS_R(Self: TIBTABLE; var T: STRING);
begin T := Self.MASTERFIELDS; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXNAME_W(Self: TIBTABLE; const T: STRING);
begin Self.INDEXNAME := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXNAME_R(Self: TIBTABLE; var T: STRING);
begin T := Self.INDEXNAME; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXFIELDNAMES_W(Self: TIBTABLE; const T: STRING);
begin Self.INDEXFIELDNAMES := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXFIELDNAMES_R(Self: TIBTABLE; var T: STRING);
begin T := Self.INDEXFIELDNAMES; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXDEFS_W(Self: TIBTABLE; const T: TINDEXDEFS);
begin Self.INDEXDEFS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXDEFS_R(Self: TIBTABLE; var T: TINDEXDEFS);
begin T := Self.INDEXDEFS; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEDEFAULTINDEX_W(Self: TIBTABLE; const T: BOOLEAN);
begin Self.DEFAULTINDEX := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEDEFAULTINDEX_R(Self: TIBTABLE; var T: BOOLEAN);
begin T := Self.DEFAULTINDEX; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLETABLENAMES_R(Self: TIBTABLE; var T: TSTRINGS);
begin T := Self.TABLENAMES; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXFIELDS_W(Self: TIBTABLE; const T: TFIELD; const t1: INTEGER);
begin Self.INDEXFIELDS[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXFIELDS_R(Self: TIBTABLE; var T: TFIELD; const t1: INTEGER);
begin T := Self.INDEXFIELDS[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEINDEXFIELDCOUNT_R(Self: TIBTABLE; var T: INTEGER);
begin T := Self.INDEXFIELDCOUNT; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLEEXISTS_R(Self: TIBTABLE; var T: BOOLEAN);
begin T := Self.EXISTS; end;

(*----------------------------------------------------------------------------*)
procedure TIBTABLECURRENTDBKEY_R(Self: TIBTABLE; var T: TIBDBKEY);
begin T := Self.CURRENTDBKEY; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBTABLE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBTABLE) do begin
    RegisterMethod(@TIBTABLE.ADDINDEX, 'ADDINDEX');
    RegisterConstructor(@TIBTABLE.Create, 'Create');
    RegisterMethod(@TIBTABLE.Destroy, 'Free');
    RegisterMethod(@TIBTABLE.Locate, 'Locate');
    RegisterMethod(@TIBTABLE.CREATETABLE, 'CREATETABLE');
    RegisterMethod(@TIBTABLE.DELETEINDEX, 'DELETEINDEX');
    RegisterMethod(@TIBTABLE.DELETETABLE, 'DELETETABLE');
    RegisterMethod(@TIBTABLE.EMPTYTABLE, 'EMPTYTABLE');
    RegisterMethod(@TIBTABLE.GETINDEXNAMES, 'GETINDEXNAMES');
    RegisterMethod(@TIBTABLE.GOTOCURRENT, 'GOTOCURRENT');
    RegisterPropertyHelper(@TIBTABLECURRENTDBKEY_R,nil,'CURRENTDBKEY');
    RegisterPropertyHelper(@TIBTABLEEXISTS_R,nil,'EXISTS');
    RegisterPropertyHelper(@TIBTABLEINDEXFIELDCOUNT_R,nil,'INDEXFIELDCOUNT');
    RegisterPropertyHelper(@TIBTABLEINDEXFIELDS_R,@TIBTABLEINDEXFIELDS_W,'INDEXFIELDS');
    RegisterPropertyHelper(@TIBTABLETABLENAMES_R,nil,'TABLENAMES');
    RegisterPropertyHelper(@TIBTABLEDEFAULTINDEX_R,@TIBTABLEDEFAULTINDEX_W,'DEFAULTINDEX');
    RegisterPropertyHelper(@TIBTABLEINDEXDEFS_R,@TIBTABLEINDEXDEFS_W,'INDEXDEFS');
    RegisterPropertyHelper(@TIBTABLEINDEXFIELDNAMES_R,@TIBTABLEINDEXFIELDNAMES_W,'INDEXFIELDNAMES');
    RegisterPropertyHelper(@TIBTABLEINDEXNAME_R,@TIBTABLEINDEXNAME_W,'INDEXNAME');
    RegisterPropertyHelper(@TIBTABLEMASTERFIELDS_R,@TIBTABLEMASTERFIELDS_W,'MASTERFIELDS');
    RegisterPropertyHelper(@TIBTABLEMASTERSOURCE_R,@TIBTABLEMASTERSOURCE_W,'MASTERSOURCE');
    RegisterPropertyHelper(@TIBTABLEREADONLY_R,@TIBTABLEREADONLY_W,'READONLY');
    RegisterPropertyHelper(@TIBTABLESTOREDEFS_R,@TIBTABLESTOREDEFS_W,'STOREDEFS');
    RegisterPropertyHelper(@TIBTABLETABLENAME_R,@TIBTABLETABLENAME_W,'TABLENAME');
    RegisterPropertyHelper(@TIBTABLETABLETYPES_R,@TIBTABLETABLETYPES_W,'TABLETYPES');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBTABLE) do
  RIRegister_TIBTABLE(CL);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBSQL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCOMPONENT', 'TIBSQL') do
  with CL.AddClassN(CL.FindClass('TCOMPONENT'),'TIBSQL') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure BATCHINPUT( INPUTOBJECT : TIBBATCHINPUT)');
    RegisterMethod('Procedure BATCHOUTPUT( OUTPUTOBJECT : TIBBATCHOUTPUT)');
    RegisterMethod('Function CALL( ERRCODE : ISC_STATUS; RAISEERROR : BOOLEAN) : ISC_STATUS');
    RegisterMethod('Procedure CHECKCLOSED');
    RegisterMethod('Procedure CHECKOPEN');
    RegisterMethod('Procedure CHECKVALIDSTATEMENT');
    RegisterMethod('Procedure CLOSE');
    RegisterMethod('Function CURRENT : TIBXSQLDA');
    RegisterMethod('Procedure EXECQUERY');
    RegisterMethod('Function FIELDBYNAME( FIELDNAME : STRING) : TIBXSQLVAR');
    RegisterMethod('Procedure FREEHANDLE');
    RegisterMethod('Function NEXT : TIBXSQLDA');
    RegisterMethod('Procedure PREPARE');
    RegisterMethod('Function GETUNIQUERELATIONNAME : STRING');
    RegisterMethod('Function PARAMBYNAME( IDX : STRING) : TIBXSQLVAR');
    RegisterProperty('BOF', 'BOOLEAN', iptr);
    RegisterProperty('DBHANDLE', 'PISC_DB_HANDLE', iptr);
    RegisterProperty('EOF', 'BOOLEAN', iptr);
    RegisterProperty('FIELDS', 'TIBXSQLVAR INTEGER', iptr);
    RegisterProperty('FIELDINDEX', 'INTEGER STRING', iptr);
    RegisterProperty('OPEN', 'BOOLEAN', iptr);
    RegisterProperty('PARAMS', 'TIBXSQLDA', iptr);
    RegisterProperty('PLAN', 'STRING', iptr);
    RegisterProperty('PREPARED', 'BOOLEAN', iptr);
    RegisterProperty('RECORDCOUNT', 'INTEGER', iptr);
    RegisterProperty('ROWSAFFECTED', 'INTEGER', iptr);
    RegisterProperty('SQLTYPE', 'TIBSQLTYPES', iptr);
    RegisterProperty('TRHANDLE', 'PISC_TR_HANDLE', iptr);
    RegisterProperty('HANDLE', 'TISC_STMT_HANDLE', iptr);
    RegisterProperty('GENERATEPARAMNAMES', 'BOOLEAN', iptrw);
    RegisterProperty('UNIQUERELATIONNAME', 'STRING', iptr);
    RegisterProperty('DATABASE', 'TIBDATABASE', iptrw);
    RegisterProperty('GOTOFIRSTRECORDONEXECUTE', 'BOOLEAN', iptrw);
    RegisterProperty('PARAMCHECK', 'BOOLEAN', iptrw);
    RegisterProperty('SQL', 'TSTRINGS', iptrw);
    RegisterProperty('TRANSACTION', 'TIBTRANSACTION', iptrw);
    RegisterProperty('ONSQLCHANGING', 'TNOTIFYEVENT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBOUTPUTXML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIBOUTPUTXML') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIBOUTPUTXML') do
  begin
    RegisterMethod('Procedure WRITEXML( SQL : TIBSQL)');
    RegisterProperty('HEADERTAG', 'STRING', iptrw);
    RegisterProperty('DATABASETAG', 'STRING', iptrw);
    RegisterProperty('STREAM', 'TSTREAM', iptrw);
    RegisterProperty('TABLETAG', 'STRING', iptrw);
    RegisterProperty('ROWTAG', 'STRING', iptrw);
    RegisterProperty('FLAGS', 'TIBXMLFLAGS', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBINPUTRAWFILE(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBBATCHINPUT', 'TIBINPUTRAWFILE') do
  with CL.AddClassN(CL.FindClass('TIBBATCHINPUT'),'TIBINPUTRAWFILE') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBOUTPUTRAWFILE(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBBATCHOUTPUT', 'TIBOUTPUTRAWFILE') do
  with CL.AddClassN(CL.FindClass('TIBBATCHOUTPUT'),'TIBOUTPUTRAWFILE') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBINPUTDELIMITEDFILE(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBBATCHINPUT', 'TIBINPUTDELIMITEDFILE') do
  with CL.AddClassN(CL.FindClass('TIBBATCHINPUT'),'TIBINPUTDELIMITEDFILE') do
  begin
    RegisterMethod('Function GETCOLUMN( var COL : STRING) : INTEGER');
    RegisterProperty('COLDELIMITER', 'STRING', iptrw);
    RegisterProperty('READBLANKSASNULL', 'BOOLEAN', iptrw);
    RegisterProperty('ROWDELIMITER', 'STRING', iptrw);
    RegisterProperty('SKIPTITLES', 'BOOLEAN', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBOUTPUTDELIMITEDFILE(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBBATCHOUTPUT', 'TIBOUTPUTDELIMITEDFILE') do
  with CL.AddClassN(CL.FindClass('TIBBATCHOUTPUT'),'TIBOUTPUTDELIMITEDFILE') do
  begin
    RegisterProperty('COLDELIMITER', 'STRING', iptrw);
    RegisterProperty('OUTPUTTITLES', 'BOOLEAN', iptrw);
    RegisterProperty('ROWDELIMITER', 'STRING', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBBATCHOUTPUT(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBBATCH', 'TIBBATCHOUTPUT') do
  with CL.AddClassN(CL.FindClass('TIBBATCH'),'TIBBATCHOUTPUT') do
  begin
    RegisterMethod('Function WRITECOLUMNS : BOOLEAN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBBATCHINPUT(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBBATCH', 'TIBBATCHINPUT') do
  with CL.AddClassN(CL.FindClass('TIBBATCH'),'TIBBATCHINPUT') do
  begin
    RegisterMethod('Function READPARAMETERS : BOOLEAN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBBATCH(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIBBATCH') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIBBATCH') do
  begin
    RegisterMethod('Procedure READYFILE');
    RegisterProperty('COLUMNS', 'TIBXSQLDA', iptrw);
    RegisterProperty('FILENAME', 'STRING', iptrw);
    RegisterProperty('PARAMS', 'TIBXSQLDA', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBXSQLDA(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIBXSQLDA') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIBXSQLDA') do
  begin
    RegisterMethod('Constructor CREATE( QUERY : TIBSQL)');
    RegisterMethod('Procedure ADDNAME( FIELDNAME : STRING; IDX : INTEGER)');
    RegisterMethod('Function BYNAME( IDX : STRING) : TIBXSQLVAR');
    RegisterProperty('ASXSQLDA', 'PXSQLDA', iptr);
    RegisterProperty('COUNT', 'INTEGER', iptrw);
    RegisterProperty('MODIFIED', 'BOOLEAN', iptr);
    RegisterProperty('NAMES', 'STRING', iptr);
    RegisterProperty('RECORDSIZE', 'INTEGER', iptr);
    RegisterProperty('VARS', 'TIBXSQLVAR INTEGER', iptr);
    SetDefaultPropery('VARS');
    RegisterProperty('UNIQUERELATIONNAME', 'STRING', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBXSQLVAR(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIBXSQLVAR') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIBXSQLVAR') do
  begin
    RegisterMethod('Constructor CREATE( PARENT : TIBXSQLDA; QUERY : TIBSQL)');
    RegisterMethod('Procedure ASSIGN( SOURCE : TIBXSQLVAR)');
    RegisterMethod('Procedure LOADFROMFILE( const FILENAME : STRING)');
    RegisterMethod('Procedure LOADFROMSTREAM( STREAM : TSTREAM)');
    RegisterMethod('Procedure SAVETOFILE( const FILENAME : STRING)');
    RegisterMethod('Procedure SAVETOSTREAM( STREAM : TSTREAM)');
    RegisterMethod('Procedure CLEAR');
    RegisterProperty('ASDATE', 'TDATETIME', iptrw);
    RegisterProperty('ASTIME', 'TDATETIME', iptrw);
    RegisterProperty('ASDATETIME', 'TDATETIME', iptrw);
    RegisterProperty('ASDOUBLE', 'DOUBLE', iptrw);
    RegisterProperty('ASFLOAT', 'FLOAT', iptrw);
    RegisterProperty('ASCURRENCY', 'CURRENCY', iptrw);
    RegisterProperty('ASINT64', 'INT64', iptrw);
    RegisterProperty('ASINTEGER', 'INTEGER', iptrw);
    RegisterProperty('ASLONG', 'LONG', iptrw);
    RegisterProperty('ASPOINTER', 'POINTER', iptrw);
    RegisterProperty('ASQUAD', 'TISC_QUAD', iptrw);
    RegisterProperty('ASSHORT', 'SHORT', iptrw);
    RegisterProperty('ASSTRING', 'STRING', iptrw);
    RegisterProperty('ASTRIMSTRING', 'STRING', iptrw);
    RegisterProperty('ASVARIANT', 'VARIANT', iptrw);
    RegisterProperty('ASXSQLVAR', 'PXSQLVAR', iptrw);
    RegisterProperty('DATA', 'PXSQLVAR', iptrw);
    RegisterProperty('ISNULL', 'BOOLEAN', iptrw);
    RegisterProperty('ISNULLABLE', 'BOOLEAN', iptrw);
    RegisterProperty('INDEX', 'INTEGER', iptr);
    RegisterProperty('MODIFIED', 'BOOLEAN', iptrw);
    RegisterProperty('NAME', 'STRING', iptr);
    RegisterProperty('SIZE', 'INTEGER', iptr);
    RegisterProperty('SQLTYPE', 'INTEGER', iptr);
    RegisterProperty('VALUE', 'VARIANT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBSQL(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBSQL');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBXSQLDA');
  SIRegister_TIBXSQLVAR(CL);
  CL.AddTypeS('TIBXSQLVARARRAY', 'array of TIBXSQLVAR');
  SIRegister_TIBXSQLDA(CL);
  SIRegister_TIBBATCH(CL);
  SIRegister_TIBBATCHINPUT(CL);
  SIRegister_TIBBATCHOUTPUT(CL);
  SIRegister_TIBOUTPUTDELIMITEDFILE(CL);
  SIRegister_TIBINPUTDELIMITEDFILE(CL);
  SIRegister_TIBOUTPUTRAWFILE(CL);
  SIRegister_TIBINPUTRAWFILE(CL);
  CL.AddTypeS('TIBXMLFLAG', '( XMLATTRIBUTE, XMLDISPLAYNULL, XMLNOHEADER )');
  CL.AddTypeS('TIBXMLFLAGS', 'set of TIBXMLFLAG');
  SIRegister_TIBOUTPUTXML(CL);
  CL.AddTypeS('TIBSQLTYPES', '( SQLUNKNOWN, SQLSELECT, SQLINSERT, SQLUPDATE, SQ'
   +'LDELETE, SQLDDL, SQLGETSEGMENT, SQLPUTSEGMENT, SQLEXECPROCEDURE, SQLSTARTT'
   +'RANSACTION, SQLCOMMIT, SQLROLLBACK, SQLSELECTFORUPDATE, SQLSETGENERATOR )');
  SIRegister_TIBSQL(CL);
 CL.AddDelphiFunction('Procedure OUTPUTXML( SQLOBJECT : TIBSQL; OUTPUTOBJECT : TIBOUTPUTXML)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBSQLONSQLCHANGING_W(Self: TIBSQL; const T: TNOTIFYEVENT);
begin Self.ONSQLCHANGING := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLONSQLCHANGING_R(Self: TIBSQL; var T: TNOTIFYEVENT);
begin T := Self.ONSQLCHANGING; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLTRANSACTION_W(Self: TIBSQL; const T: TIBTRANSACTION);
begin Self.TRANSACTION := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLTRANSACTION_R(Self: TIBSQL; var T: TIBTRANSACTION);
begin T := Self.TRANSACTION; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLSQL_W(Self: TIBSQL; const T: TSTRINGS);
begin Self.SQL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLSQL_R(Self: TIBSQL; var T: TSTRINGS);
begin T := Self.SQL; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLPARAMCHECK_W(Self: TIBSQL; const T: BOOLEAN);
begin Self.PARAMCHECK := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLPARAMCHECK_R(Self: TIBSQL; var T: BOOLEAN);
begin T := Self.PARAMCHECK; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLGOTOFIRSTRECORDONEXECUTE_W(Self: TIBSQL; const T: BOOLEAN);
begin Self.GOTOFIRSTRECORDONEXECUTE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLGOTOFIRSTRECORDONEXECUTE_R(Self: TIBSQL; var T: BOOLEAN);
begin T := Self.GOTOFIRSTRECORDONEXECUTE; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLDATABASE_W(Self: TIBSQL; const T: TIBDATABASE);
begin Self.DATABASE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLDATABASE_R(Self: TIBSQL; var T: TIBDATABASE);
begin T := Self.DATABASE; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLUNIQUERELATIONNAME_R(Self: TIBSQL; var T: STRING);
begin T := Self.UNIQUERELATIONNAME; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLGENERATEPARAMNAMES_W(Self: TIBSQL; const T: BOOLEAN);
begin Self.GENERATEPARAMNAMES := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLGENERATEPARAMNAMES_R(Self: TIBSQL; var T: BOOLEAN);
begin T := Self.GENERATEPARAMNAMES; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLHANDLE_R(Self: TIBSQL; var T: TISC_STMT_HANDLE);
begin T := Self.HANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLTRHANDLE_R(Self: TIBSQL; var T: PISC_TR_HANDLE);
begin T := Self.TRHANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLSQLTYPE_R(Self: TIBSQL; var T: TIBSQLTYPES);
begin T := Self.SQLTYPE; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLROWSAFFECTED_R(Self: TIBSQL; var T: INTEGER);
begin T := Self.ROWSAFFECTED; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLRECORDCOUNT_R(Self: TIBSQL; var T: INTEGER);
begin T := Self.RECORDCOUNT; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLPREPARED_R(Self: TIBSQL; var T: BOOLEAN);
begin T := Self.PREPARED; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLPLAN_R(Self: TIBSQL; var T: STRING);
begin T := Self.PLAN; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLPARAMS_R(Self: TIBSQL; var T: TIBXSQLDA);
begin T := Self.PARAMS; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLOPEN_R(Self: TIBSQL; var T: BOOLEAN);
begin T := Self.OPEN; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLFIELDINDEX_R(Self: TIBSQL; var T: INTEGER; const t1: STRING);
begin T := Self.FIELDINDEX[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLFIELDS_R(Self: TIBSQL; var T: TIBXSQLVAR; const t1: INTEGER);
begin T := Self.FIELDS[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLEOF_R(Self: TIBSQL; var T: BOOLEAN);
begin T := Self.EOF; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLDBHANDLE_R(Self: TIBSQL; var T: PISC_DB_HANDLE);
begin T := Self.DBHANDLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLBOF_R(Self: TIBSQL; var T: BOOLEAN);
begin T := Self.BOF; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLFLAGS_W(Self: TIBOUTPUTXML; const T: TIBXMLFLAGS);
begin Self.FLAGS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLFLAGS_R(Self: TIBOUTPUTXML; var T: TIBXMLFLAGS);
begin T := Self.FLAGS; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLROWTAG_W(Self: TIBOUTPUTXML; const T: STRING);
begin Self.ROWTAG := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLROWTAG_R(Self: TIBOUTPUTXML; var T: STRING);
begin T := Self.ROWTAG; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLTABLETAG_W(Self: TIBOUTPUTXML; const T: STRING);
begin Self.TABLETAG := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLTABLETAG_R(Self: TIBOUTPUTXML; var T: STRING);
begin T := Self.TABLETAG; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLSTREAM_W(Self: TIBOUTPUTXML; const T: TSTREAM);
begin Self.STREAM := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLSTREAM_R(Self: TIBOUTPUTXML; var T: TSTREAM);
begin T := Self.STREAM; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLDATABASETAG_W(Self: TIBOUTPUTXML; const T: STRING);
begin Self.DATABASETAG := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLDATABASETAG_R(Self: TIBOUTPUTXML; var T: STRING);
begin T := Self.DATABASETAG; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLHEADERTAG_W(Self: TIBOUTPUTXML; const T: STRING);
begin Self.HEADERTAG := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTXMLHEADERTAG_R(Self: TIBOUTPUTXML; var T: STRING);
begin T := Self.HEADERTAG; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILESKIPTITLES_W(Self: TIBINPUTDELIMITEDFILE; const T: BOOLEAN);
begin Self.SKIPTITLES := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILESKIPTITLES_R(Self: TIBINPUTDELIMITEDFILE; var T: BOOLEAN);
begin T := Self.SKIPTITLES; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILEROWDELIMITER_W(Self: TIBINPUTDELIMITEDFILE; const T: STRING);
begin Self.ROWDELIMITER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILEROWDELIMITER_R(Self: TIBINPUTDELIMITEDFILE; var T: STRING);
begin T := Self.ROWDELIMITER; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILEREADBLANKSASNULL_W(Self: TIBINPUTDELIMITEDFILE; const T: BOOLEAN);
begin Self.READBLANKSASNULL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILEREADBLANKSASNULL_R(Self: TIBINPUTDELIMITEDFILE; var T: BOOLEAN);
begin T := Self.READBLANKSASNULL; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILECOLDELIMITER_W(Self: TIBINPUTDELIMITEDFILE; const T: STRING);
begin Self.COLDELIMITER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBINPUTDELIMITEDFILECOLDELIMITER_R(Self: TIBINPUTDELIMITEDFILE; var T: STRING);
begin T := Self.COLDELIMITER; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTDELIMITEDFILEROWDELIMITER_W(Self: TIBOUTPUTDELIMITEDFILE; const T: STRING);
begin Self.ROWDELIMITER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTDELIMITEDFILEROWDELIMITER_R(Self: TIBOUTPUTDELIMITEDFILE; var T: STRING);
begin T := Self.ROWDELIMITER; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTDELIMITEDFILEOUTPUTTITLES_W(Self: TIBOUTPUTDELIMITEDFILE; const T: BOOLEAN);
begin Self.OUTPUTTITLES := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTDELIMITEDFILEOUTPUTTITLES_R(Self: TIBOUTPUTDELIMITEDFILE; var T: BOOLEAN);
begin T := Self.OUTPUTTITLES; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTDELIMITEDFILECOLDELIMITER_W(Self: TIBOUTPUTDELIMITEDFILE; const T: STRING);
begin Self.COLDELIMITER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBOUTPUTDELIMITEDFILECOLDELIMITER_R(Self: TIBOUTPUTDELIMITEDFILE; var T: STRING);
begin T := Self.COLDELIMITER; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDAUNIQUERELATIONNAME_R(Self: TIBXSQLDA; var T: STRING);
begin T := Self.UNIQUERELATIONNAME; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDAVARS_R(Self: TIBXSQLDA; var T: TIBXSQLVAR; const t1: INTEGER);
begin T := Self.VARS[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDARECORDSIZE_R(Self: TIBXSQLDA; var T: INTEGER);
begin T := Self.RECORDSIZE; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDANAMES_R(Self: TIBXSQLDA; var T: STRING);
begin T := Self.NAMES; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDAMODIFIED_R(Self: TIBXSQLDA; var T: BOOLEAN);
begin T := Self.MODIFIED; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDACOUNT_W(Self: TIBXSQLDA; const T: INTEGER);
begin Self.COUNT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDACOUNT_R(Self: TIBXSQLDA; var T: INTEGER);
begin T := Self.COUNT; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLDAASXSQLDA_R(Self: TIBXSQLDA; var T: PXSQLDA);
begin T := Self.ASXSQLDA; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARVALUE_W(Self: TIBXSQLVAR; const T: VARIANT);
begin Self.VALUE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARVALUE_R(Self: TIBXSQLVAR; var T: VARIANT);
begin T := Self.VALUE; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARSQLTYPE_R(Self: TIBXSQLVAR; var T: INTEGER);
begin T := Self.SQLTYPE; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARSIZE_R(Self: TIBXSQLVAR; var T: INTEGER);
begin T := Self.SIZE; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARNAME_R(Self: TIBXSQLVAR; var T: STRING);
begin T := Self.NAME; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARMODIFIED_W(Self: TIBXSQLVAR; const T: BOOLEAN);
begin Self.MODIFIED := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARMODIFIED_R(Self: TIBXSQLVAR; var T: BOOLEAN);
begin T := Self.MODIFIED; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARINDEX_R(Self: TIBXSQLVAR; var T: INTEGER);
begin T := Self.INDEX; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARISNULLABLE_W(Self: TIBXSQLVAR; const T: BOOLEAN);
begin Self.ISNULLABLE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARISNULLABLE_R(Self: TIBXSQLVAR; var T: BOOLEAN);
begin T := Self.ISNULLABLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARISNULL_W(Self: TIBXSQLVAR; const T: BOOLEAN);
begin Self.ISNULL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARISNULL_R(Self: TIBXSQLVAR; var T: BOOLEAN);
begin T := Self.ISNULL; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARDATA_W(Self: TIBXSQLVAR; const T: PXSQLVAR);
begin //Self.DATA := T;
end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARDATA_R(Self: TIBXSQLVAR; var T: PXSQLVAR);
begin //T := Self.DATA;
end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASXSQLVAR_W(Self: TIBXSQLVAR; const T: PXSQLVAR);
begin //Self.ASXSQLVAR := T;
end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASXSQLVAR_R(Self: TIBXSQLVAR; var T: PXSQLVAR);
begin //T := Self.ASXSQLVAR;
end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASVARIANT_W(Self: TIBXSQLVAR; const T: VARIANT);
begin Self.ASVARIANT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASVARIANT_R(Self: TIBXSQLVAR; var T: VARIANT);
begin T := Self.ASVARIANT; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASTRIMSTRING_W(Self: TIBXSQLVAR; const T: STRING);
begin Self.ASTRIMSTRING := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASTRIMSTRING_R(Self: TIBXSQLVAR; var T: STRING);
begin T := Self.ASTRIMSTRING; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASSTRING_W(Self: TIBXSQLVAR; const T: STRING);
begin Self.ASSTRING := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASSTRING_R(Self: TIBXSQLVAR; var T: STRING);
begin T := Self.ASSTRING; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASSHORT_W(Self: TIBXSQLVAR; const T: SHORT);
begin Self.ASSHORT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASSHORT_R(Self: TIBXSQLVAR; var T: SHORT);
begin T := Self.ASSHORT; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASQUAD_W(Self: TIBXSQLVAR; const T: TISC_QUAD);
begin Self.ASQUAD := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASQUAD_R(Self: TIBXSQLVAR; var T: TISC_QUAD);
begin T := Self.ASQUAD; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASPOINTER_W(Self: TIBXSQLVAR; const T: POINTER);
begin Self.ASPOINTER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASPOINTER_R(Self: TIBXSQLVAR; var T: POINTER);
begin T := Self.ASPOINTER; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASLONG_W(Self: TIBXSQLVAR; const T: LONG);
begin Self.ASLONG := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASLONG_R(Self: TIBXSQLVAR; var T: LONG);
begin T := Self.ASLONG; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASINTEGER_W(Self: TIBXSQLVAR; const T: INTEGER);
begin Self.ASINTEGER := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASINTEGER_R(Self: TIBXSQLVAR; var T: INTEGER);
begin T := Self.ASINTEGER; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASINT64_W(Self: TIBXSQLVAR; const T: INT64);
begin Self.ASINT64 := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASINT64_R(Self: TIBXSQLVAR; var T: INT64);
begin T := Self.ASINT64; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASCURRENCY_W(Self: TIBXSQLVAR; const T: CURRENCY);
begin Self.ASCURRENCY := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASCURRENCY_R(Self: TIBXSQLVAR; var T: CURRENCY);
begin T := Self.ASCURRENCY; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASFLOAT_W(Self: TIBXSQLVAR; const T: FLOAT);
begin Self.ASFLOAT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASFLOAT_R(Self: TIBXSQLVAR; var T: FLOAT);
begin T := Self.ASFLOAT; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASDOUBLE_W(Self: TIBXSQLVAR; const T: DOUBLE);
begin Self.ASDOUBLE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASDOUBLE_R(Self: TIBXSQLVAR; var T: DOUBLE);
begin T := Self.ASDOUBLE; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASDATETIME_W(Self: TIBXSQLVAR; const T: TDATETIME);
begin Self.ASDATETIME := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASDATETIME_R(Self: TIBXSQLVAR; var T: TDATETIME);
begin T := Self.ASDATETIME; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASTIME_W(Self: TIBXSQLVAR; const T: TDATETIME);
begin Self.ASTIME := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASTIME_R(Self: TIBXSQLVAR; var T: TDATETIME);
begin T := Self.ASTIME; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASDATE_W(Self: TIBXSQLVAR; const T: TDATETIME);
begin Self.ASDATE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBXSQLVARASDATE_R(Self: TIBXSQLVAR; var T: TDATETIME);
begin T := Self.ASDATE; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBSQL_Routines(S: TIFPSExec);
begin
 S.RegisterDelphiFunction(@OUTPUTXML, 'OUTPUTXML', cdRegister);
 S.RegisterDelphiFunction(@GenerateDPB, 'GenerateDPB', cdRegister);
 S.RegisterDelphiFunction(@GenerateTPB, 'GenerateTPB', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBSQL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBSQL) do begin
    RegisterConstructor(@TIBSQL.Create, 'Create');
    RegisterMethod(@TIBSQL.Destroy, 'Free');
    RegisterMethod(@TIBSQL.BATCHINPUT, 'BATCHINPUT');
    RegisterMethod(@TIBSQL.BATCHOUTPUT, 'BATCHOUTPUT');
    RegisterMethod(@TIBSQL.CALL, 'CALL');
    RegisterMethod(@TIBSQL.CHECKCLOSED, 'CHECKCLOSED');
    RegisterMethod(@TIBSQL.CHECKOPEN, 'CHECKOPEN');
    RegisterMethod(@TIBSQL.CHECKVALIDSTATEMENT, 'CHECKVALIDSTATEMENT');
    RegisterMethod(@TIBSQL.CLOSE, 'CLOSE');
    RegisterMethod(@TIBSQL.CURRENT, 'CURRENT');
    RegisterMethod(@TIBSQL.EXECQUERY, 'EXECQUERY');
    RegisterMethod(@TIBSQL.FIELDBYNAME, 'FIELDBYNAME');
    RegisterMethod(@TIBSQL.FREEHANDLE, 'FREEHANDLE');
    RegisterMethod(@TIBSQL.NEXT, 'NEXT');
    RegisterMethod(@TIBSQL.PREPARE, 'PREPARE');
    RegisterMethod(@TIBSQL.GETUNIQUERELATIONNAME, 'GETUNIQUERELATIONNAME');
    RegisterMethod(@TIBSQL.PARAMBYNAME, 'PARAMBYNAME');
    RegisterPropertyHelper(@TIBSQLBOF_R,nil,'BOF');
    RegisterPropertyHelper(@TIBSQLDBHANDLE_R,nil,'DBHANDLE');
    RegisterPropertyHelper(@TIBSQLEOF_R,nil,'EOF');
    RegisterPropertyHelper(@TIBSQLFIELDS_R,nil,'FIELDS');
    RegisterPropertyHelper(@TIBSQLFIELDINDEX_R,nil,'FIELDINDEX');
    RegisterPropertyHelper(@TIBSQLOPEN_R,nil,'OPEN');
    RegisterPropertyHelper(@TIBSQLPARAMS_R,nil,'PARAMS');
    RegisterPropertyHelper(@TIBSQLPLAN_R,nil,'PLAN');
    RegisterPropertyHelper(@TIBSQLPREPARED_R,nil,'PREPARED');
    RegisterPropertyHelper(@TIBSQLRECORDCOUNT_R,nil,'RECORDCOUNT');
    RegisterPropertyHelper(@TIBSQLROWSAFFECTED_R,nil,'ROWSAFFECTED');
    RegisterPropertyHelper(@TIBSQLSQLTYPE_R,nil,'SQLTYPE');
    RegisterPropertyHelper(@TIBSQLTRHANDLE_R,nil,'TRHANDLE');
    RegisterPropertyHelper(@TIBSQLHANDLE_R,nil,'HANDLE');
    RegisterPropertyHelper(@TIBSQLGENERATEPARAMNAMES_R,@TIBSQLGENERATEPARAMNAMES_W,'GENERATEPARAMNAMES');
    RegisterPropertyHelper(@TIBSQLUNIQUERELATIONNAME_R,nil,'UNIQUERELATIONNAME');
    RegisterPropertyHelper(@TIBSQLDATABASE_R,@TIBSQLDATABASE_W,'DATABASE');
    RegisterPropertyHelper(@TIBSQLGOTOFIRSTRECORDONEXECUTE_R,@TIBSQLGOTOFIRSTRECORDONEXECUTE_W,'GOTOFIRSTRECORDONEXECUTE');
    RegisterPropertyHelper(@TIBSQLPARAMCHECK_R,@TIBSQLPARAMCHECK_W,'PARAMCHECK');
    RegisterPropertyHelper(@TIBSQLSQL_R,@TIBSQLSQL_W,'SQL');
    RegisterPropertyHelper(@TIBSQLTRANSACTION_R,@TIBSQLTRANSACTION_W,'TRANSACTION');
    RegisterEventPropertyHelper(@TIBSQLONSQLCHANGING_R,@TIBSQLONSQLCHANGING_W,'ONSQLCHANGING');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBOUTPUTXML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBOUTPUTXML) do
  begin
    RegisterMethod(@TIBOUTPUTXML.WRITEXML, 'WRITEXML');
    RegisterPropertyHelper(@TIBOUTPUTXMLHEADERTAG_R,@TIBOUTPUTXMLHEADERTAG_W,'HEADERTAG');
    RegisterPropertyHelper(@TIBOUTPUTXMLDATABASETAG_R,@TIBOUTPUTXMLDATABASETAG_W,'DATABASETAG');
    RegisterPropertyHelper(@TIBOUTPUTXMLSTREAM_R,@TIBOUTPUTXMLSTREAM_W,'STREAM');
    RegisterPropertyHelper(@TIBOUTPUTXMLTABLETAG_R,@TIBOUTPUTXMLTABLETAG_W,'TABLETAG');
    RegisterPropertyHelper(@TIBOUTPUTXMLROWTAG_R,@TIBOUTPUTXMLROWTAG_W,'ROWTAG');
    RegisterPropertyHelper(@TIBOUTPUTXMLFLAGS_R,@TIBOUTPUTXMLFLAGS_W,'FLAGS');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBINPUTRAWFILE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBINPUTRAWFILE) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBOUTPUTRAWFILE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBOUTPUTRAWFILE) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBINPUTDELIMITEDFILE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBINPUTDELIMITEDFILE) do
  begin
    RegisterMethod(@TIBINPUTDELIMITEDFILE.GETCOLUMN, 'GETCOLUMN');
    RegisterPropertyHelper(@TIBINPUTDELIMITEDFILECOLDELIMITER_R,@TIBINPUTDELIMITEDFILECOLDELIMITER_W,'COLDELIMITER');
    RegisterPropertyHelper(@TIBINPUTDELIMITEDFILEREADBLANKSASNULL_R,@TIBINPUTDELIMITEDFILEREADBLANKSASNULL_W,'READBLANKSASNULL');
    RegisterPropertyHelper(@TIBINPUTDELIMITEDFILEROWDELIMITER_R,@TIBINPUTDELIMITEDFILEROWDELIMITER_W,'ROWDELIMITER');
    RegisterPropertyHelper(@TIBINPUTDELIMITEDFILESKIPTITLES_R,@TIBINPUTDELIMITEDFILESKIPTITLES_W,'SKIPTITLES');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBOUTPUTDELIMITEDFILE(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBOUTPUTDELIMITEDFILE) do
  begin
    RegisterPropertyHelper(@TIBOUTPUTDELIMITEDFILECOLDELIMITER_R,@TIBOUTPUTDELIMITEDFILECOLDELIMITER_W,'COLDELIMITER');
    RegisterPropertyHelper(@TIBOUTPUTDELIMITEDFILEOUTPUTTITLES_R,@TIBOUTPUTDELIMITEDFILEOUTPUTTITLES_W,'OUTPUTTITLES');
    RegisterPropertyHelper(@TIBOUTPUTDELIMITEDFILEROWDELIMITER_R,@TIBOUTPUTDELIMITEDFILEROWDELIMITER_W,'ROWDELIMITER');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBXSQLDA(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBXSQLDA) do
  begin
    RegisterConstructor(@TIBXSQLDA.CREATE, 'CREATE');
    RegisterMethod(@TIBXSQLDA.ADDNAME, 'ADDNAME');
    RegisterMethod(@TIBXSQLDA.BYNAME, 'BYNAME');
    RegisterPropertyHelper(@TIBXSQLDAASXSQLDA_R,nil,'ASXSQLDA');
    RegisterPropertyHelper(@TIBXSQLDACOUNT_R,@TIBXSQLDACOUNT_W,'COUNT');
    RegisterPropertyHelper(@TIBXSQLDAMODIFIED_R,nil,'MODIFIED');
    RegisterPropertyHelper(@TIBXSQLDANAMES_R,nil,'NAMES');
    RegisterPropertyHelper(@TIBXSQLDARECORDSIZE_R,nil,'RECORDSIZE');
    RegisterPropertyHelper(@TIBXSQLDAVARS_R,nil,'VARS');
    RegisterPropertyHelper(@TIBXSQLDAUNIQUERELATIONNAME_R,nil,'UNIQUERELATIONNAME');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBXSQLVAR(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBXSQLVAR) do begin
    RegisterConstructor(@TIBXSQLVAR.CREATE, 'CREATE');
    RegisterMethod(@TIBXSQLVAR.ASSIGN, 'ASSIGN');
    RegisterMethod(@TIBXSQLVAR.LOADFROMFILE, 'LOADFROMFILE');
    RegisterMethod(@TIBXSQLVAR.LOADFROMSTREAM, 'LOADFROMSTREAM');
    RegisterMethod(@TIBXSQLVAR.SAVETOFILE, 'SAVETOFILE');
    RegisterMethod(@TIBXSQLVAR.SAVETOSTREAM, 'SAVETOSTREAM');
    RegisterMethod(@TIBXSQLVAR.CLEAR, 'CLEAR');
    RegisterPropertyHelper(@TIBXSQLVARASDATE_R,@TIBXSQLVARASDATE_W,'ASDATE');
    RegisterPropertyHelper(@TIBXSQLVARASTIME_R,@TIBXSQLVARASTIME_W,'ASTIME');
    RegisterPropertyHelper(@TIBXSQLVARASDATETIME_R,@TIBXSQLVARASDATETIME_W,'ASDATETIME');
    RegisterPropertyHelper(@TIBXSQLVARASDOUBLE_R,@TIBXSQLVARASDOUBLE_W,'ASDOUBLE');
    RegisterPropertyHelper(@TIBXSQLVARASFLOAT_R,@TIBXSQLVARASFLOAT_W,'ASFLOAT');
    RegisterPropertyHelper(@TIBXSQLVARASCURRENCY_R,@TIBXSQLVARASCURRENCY_W,'ASCURRENCY');
    RegisterPropertyHelper(@TIBXSQLVARASINT64_R,@TIBXSQLVARASINT64_W,'ASINT64');
    RegisterPropertyHelper(@TIBXSQLVARASINTEGER_R,@TIBXSQLVARASINTEGER_W,'ASINTEGER');
    RegisterPropertyHelper(@TIBXSQLVARASLONG_R,@TIBXSQLVARASLONG_W,'ASLONG');
    RegisterPropertyHelper(@TIBXSQLVARASPOINTER_R,@TIBXSQLVARASPOINTER_W,'ASPOINTER');
    RegisterPropertyHelper(@TIBXSQLVARASQUAD_R,@TIBXSQLVARASQUAD_W,'ASQUAD');
    RegisterPropertyHelper(@TIBXSQLVARASSHORT_R,@TIBXSQLVARASSHORT_W,'ASSHORT');
    RegisterPropertyHelper(@TIBXSQLVARASSTRING_R,@TIBXSQLVARASSTRING_W,'ASSTRING');
    RegisterPropertyHelper(@TIBXSQLVARASTRIMSTRING_R,@TIBXSQLVARASTRIMSTRING_W,'ASTRIMSTRING');
    RegisterPropertyHelper(@TIBXSQLVARASVARIANT_R,@TIBXSQLVARASVARIANT_W,'ASVARIANT');
    RegisterPropertyHelper(@TIBXSQLVARASXSQLVAR_R,@TIBXSQLVARASXSQLVAR_W,'ASXSQLVAR');
    RegisterPropertyHelper(@TIBXSQLVARDATA_R,@TIBXSQLVARDATA_W,'DATA');
    RegisterPropertyHelper(@TIBXSQLVARISNULL_R,@TIBXSQLVARISNULL_W,'ISNULL');
    RegisterPropertyHelper(@TIBXSQLVARISNULLABLE_R,@TIBXSQLVARISNULLABLE_W,'ISNULLABLE');
    RegisterPropertyHelper(@TIBXSQLVARINDEX_R,nil,'INDEX');
    RegisterPropertyHelper(@TIBXSQLVARMODIFIED_R,@TIBXSQLVARMODIFIED_W,'MODIFIED');
    RegisterPropertyHelper(@TIBXSQLVARNAME_R,nil,'NAME');
    RegisterPropertyHelper(@TIBXSQLVARSIZE_R,nil,'SIZE');
    RegisterPropertyHelper(@TIBXSQLVARSQLTYPE_R,nil,'SQLTYPE');
    RegisterPropertyHelper(@TIBXSQLVARVALUE_R,@TIBXSQLVARVALUE_W,'VALUE');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBSQL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBSQL) do
  with CL.Add(TIBXSQLDA) do
  RIRegister_TIBXSQLVAR(CL);
  RIRegister_TIBXSQLDA(CL);
  RIRegister_TIBOUTPUTDELIMITEDFILE(CL);
  RIRegister_TIBINPUTDELIMITEDFILE(CL);
  RIRegister_TIBOUTPUTRAWFILE(CL);
  RIRegister_TIBINPUTRAWFILE(CL);
  RIRegister_TIBOUTPUTXML(CL);
  RIRegister_TIBSQL(CL);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBQuery(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIBCustomDataSet', 'TIBQuery') do
  with CL.AddClassN(CL.FindClass('TIBCustomDataSet'),'TIBQuery') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure BatchInput( InputObject : TIBBatchInput)');
    RegisterMethod('Procedure BatchOutput( OutputObject : TIBBatchOutput)');
    RegisterMethod('Procedure ExecSQL');
    RegisterMethod('Function ParamByName( const Value : string) : TParam');
    RegisterMethod('Procedure Prepare');
    RegisterMethod('Procedure UnPrepare');
    RegisterProperty('Prepared', 'Boolean', iptrw);
    RegisterProperty('ParamCount', 'Word', iptr);
    RegisterProperty('StmtHandle', 'TISC_STMT_HANDLE', iptr);
    RegisterProperty('Text', 'string', iptr);
    RegisterProperty('RowsAffected', 'Integer', iptr);
    RegisterProperty('GenerateParamNames', 'Boolean', iptrw);
    RegisterProperty('DataSource', 'TDatasource', iptrw);
    RegisterProperty('SQL', 'TStrings', iptrw);
    RegisterProperty('Params', 'TParams', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBQuery(CL: TPSPascalCompiler);
begin
  SIRegister_TIBQuery(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBQueryParams_W(Self: TIBQuery; const T: TParams);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryParams_R(Self: TIBQuery; var T: TParams);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TIBQuerySQL_W(Self: TIBQuery; const T: TStrings);
begin Self.SQL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBQuerySQL_R(Self: TIBQuery; var T: TStrings);
begin T := Self.SQL; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryDataSource_W(Self: TIBQuery; const T: TDatasource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryDataSource_R(Self: TIBQuery; var T: TDatasource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryGenerateParamNames_W(Self: TIBQuery; const T: Boolean);
begin Self.GenerateParamNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryGenerateParamNames_R(Self: TIBQuery; var T: Boolean);
begin T := Self.GenerateParamNames; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryRowsAffected_R(Self: TIBQuery; var T: Integer);
begin T := Self.RowsAffected; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryText_R(Self: TIBQuery; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryStmtHandle_R(Self: TIBQuery; var T: TISC_STMT_HANDLE);
begin T := Self.StmtHandle; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryParamCount_R(Self: TIBQuery; var T: Word);
begin T := Self.ParamCount; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryPrepared_W(Self: TIBQuery; const T: Boolean);
begin Self.Prepared := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBQueryPrepared_R(Self: TIBQuery; var T: Boolean);
begin T := Self.Prepared; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBQuery(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBQuery) do begin
    RegisterConstructor(@TIBQuery.Create, 'Create');
    RegisterMethod(@TIBQuery.Destroy, 'Free');
    RegisterMethod(@TIBQuery.BatchInput, 'BatchInput');
    RegisterMethod(@TIBQuery.BatchOutput, 'BatchOutput');
    RegisterMethod(@TIBQuery.ExecSQL, 'ExecSQL');
    RegisterMethod(@TIBQuery.ParamByName, 'ParamByName');
    RegisterMethod(@TIBQuery.Prepare, 'Prepare');
    RegisterMethod(@TIBQuery.UnPrepare, 'UnPrepare');
    RegisterPropertyHelper(@TIBQueryPrepared_R,@TIBQueryPrepared_W,'Prepared');
    RegisterPropertyHelper(@TIBQueryParamCount_R,nil,'ParamCount');
    RegisterPropertyHelper(@TIBQueryStmtHandle_R,nil,'StmtHandle');
    RegisterPropertyHelper(@TIBQueryText_R,nil,'Text');
    RegisterPropertyHelper(@TIBQueryRowsAffected_R,nil,'RowsAffected');
    RegisterPropertyHelper(@TIBQueryGenerateParamNames_R,@TIBQueryGenerateParamNames_W,'GenerateParamNames');
    RegisterPropertyHelper(@TIBQueryDataSource_R,@TIBQueryDataSource_W,'DataSource');
    RegisterPropertyHelper(@TIBQuerySQL_R,@TIBQuerySQL_W,'SQL');
    RegisterPropertyHelper(@TIBQueryParams_R,@TIBQueryParams_W,'Params');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBQuery(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIBQuery(CL);
end;



{ TIFPS3CE_IBCustomDataSet }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBX.CompOnUses(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBX.ExecOnUses(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBX.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IBDatabase(CompExec.Comp);
  SIRegister_IBSQL(CompExec.Comp);
  SIRegister_IBCustomDataSet(CompExec.Comp);
  SIRegister_IBTable(CompExec.Comp);
  SIRegister_IBQuery(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBX.CompileImport2(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBX.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IBDatabase(ri);
  RIRegister_IBSQL(ri);
  RIRegister_IBCustomDataSet(ri);
  RIRegister_IBTable(ri);
  RIRegister_IBQuery(ri);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBX.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing }
end;

end.
//Source/ThirdParty/uPSI_IBX.pas

//----code_cleared_checked_clean----