unit uPSI_IB;
{
  InterBase
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
  TPSImport_IB = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EIBError(CL: TPSPascalCompiler);
procedure SIRegister_IB(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IB_Routines(S: TPSExec);
procedure RIRegister_EIBError(CL: TPSRuntimeClassImporter);
procedure RIRegister_IB(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,Libc
  ,IBHeader
  ,IBExternals
  ,IBUtils
  ,DB
  ,IBXConst
  ,IB
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IB]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EIBError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EDatabaseError', 'EIBError') do
  with CL.AddClassN(CL.FindClass('EDatabaseError'),'EIBError') do begin
    RegisterMethod('Constructor Create( ASQLCode : Long; Msg : string);');
    RegisterMethod('Constructor Create1( ASQLCode : Long; AIBErrorCode : Long; Msg : string);');
    RegisterProperty('SQLCode', 'Long', iptr);
    RegisterProperty('IBErrorCode', 'Long', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IB(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTraceFlag', '( tfQPrepare, tfQExecute, tfQFetch, tfError, tfStm'
   +'t, tfConnect, tfTransact, tfBlob, tfService, tfMisc )');
  CL.AddTypeS('TTraceFlags', 'set of TTraceFlag');
  CL.AddTypeS('ISC_STATUS', 'Long');
  CL.AddTypeS('ISC_LONG', 'Long');
  CL.AddTypeS('UISC_LONG', 'DWord');
  CL.AddTypeS('ISC_INT64', 'Int64');
  CL.AddTypeS('ISC_BOOLEAN', 'SmallInt');
  CL.AddTypeS('UISC_STATUS', 'DWord');
 // CL.AddTypeS('ISC_INT64', 'Int64');

(*  ISC_LONG             = Long;    { 32 bit signed  }
  UISC_LONG            = Dword ULong;   { 32 bit unsigned }
  ISC_INT64            = Int64;   { 64 bit signed  }
  ISC_BOOLEAN          = SmallInt; { 16 bit signed  }
  ISC_STATUS           = Long;    { 32 bit signed }
  UISC_STATUS          = ULong;   { 32 bit unsigned}*)


  //ISC_STATUS           = Long;
  SIRegister_EIBError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIBInterBaseError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIBInterBaseRoleError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIBClientError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIBPlanError');
  CL.AddTypeS('TIBDataBaseErrorMessage', '( ShowSQLCode, ShowIBMessage, ShowSQLMessage )');
  CL.AddTypeS('TIBDataBaseErrorMessages', 'set of TIBDataBaseErrorMessage');
  CL.AddTypeS('TIBClientError', '( ibxeUnknownError, ibxeInterBaseMissing, ibxe'
   +'InterBaseInstallMissing, ibxeIB60feature, ibxeNotSupported, ibxeNotPermitt'
   +'ed, ibxeFileAccessError, ibxeConnectionTimeout, ibxeCannotSetDatabase, ibx'
   +'eCannotSetTransaction, ibxeOperationCancelled, ibxeDPBConstantNotSupported'
   +', ibxeDPBConstantUnknown, ibxeTPBConstantNotSupported, ibxeTPBConstantUnkn'
   +'own, ibxeDatabaseClosed, ibxeDatabaseOpen, ibxeDatabaseNameMissing, ibxeNo'
   +'tInTransaction, ibxeInTransaction, ibxeTimeoutNegative, ibxeNoDatabasesInT'
   +'ransaction, ibxeUpdateWrongDB, ibxeUpdateWrongTR, ibxeDatabaseNotAssigned,'
   +' ibxeTransactionNotAssigned, ibxeXSQLDAIndexOutOfRange, ibxeXSQLDANameDoes'
   +'NotExist, ibxeEOF, ibxeBOF, ibxeInvalidStatementHandle, ibxeSQLOpen, ibxeS'
   +'QLClosed, ibxeDatasetOpen, ibxeDatasetClosed, ibxeUnknownSQLDataType, ibxe'
   +'InvalidColumnIndex, ibxeInvalidParamColumnIndex, ibxeInvalidDataConversion'
   +', ibxeColumnIsNotNullable, ibxeBlobCannotBeRead, ibxeBlobCannotBeWritten, '
   +'ibxeEmptyQuery, ibxeCannotOpenNonSQLSelect, ibxeNoFieldAccess, ibxeFieldRe'
   +'adOnly, ibxeFieldNotFound, ibxeNotEditing, ibxeCannotInsert, ibxeCannotPos'
   +'t, ibxeCannotUpdate, ibxeCannotDelete, ibxeCannotRefresh, ibxeBufferNotSet'
   +', ibxeCircularReference, ibxeSQLParseError, ibxeUserAbort, ibxeDataSetUniD'
   +'irectional, ibxeCannotCreateSharedResource, ibxeWindowsAPIError, ibxeColum'
   +'nListsDontMatch, ibxeColumnTypesDontMatch, ibxeCantEndSharedTransaction, i'
   +'bxeFieldUnsupportedType, ibxeCircularDataLink, ibxeEmptySQLStatement, ibxe'
   +'IsASelectStatement, ibxeRequiredParamNotSet, ibxeNoStoredProcName, ibxeIsA'
   +'ExecuteProcedure, ibxeUpdateFailed, ibxeNotCachedUpdates, ibxeNotLiveReque'
   +'st, ibxeNoProvider, ibxeNoRecordsAffected, ibxeNoTableName, ibxeCannotCrea'
   +'tePrimaryIndex, ibxeCannotDropSystemIndex, ibxeTableNameMismatch, ibxeInde'
   +'xFieldMissing, ibxeInvalidCancellation, ibxeInvalidEvent, ibxeMaximumEvent'
   +'s, ibxeNoEventsRegistered, ibxeInvalidQueueing, ibxeInvalidRegistration, i'
   +'bxeInvalidBatchMove, ibxeSQLDialectInvalid, ibxeSPBConstantNotSupported, i'
   +'bxeSPBConstantUnknown, ibxeServiceActive, ibxeServiceInActive, ibxeServerN'
   +'ameMissing, ibxeQueryParamsError, ibxeStartParamsError, ibxeOutputParsingE'
   +'rror, ibxeUseSpecificProcedures, ibxeSQLMonitorAlreadyPresent, ibxeCantPri'
   +'ntValue, ibxeEOFReached, ibxeEOFInComment, ibxeEOFInString, ibxeParamNameE'
   +'xpected, ibxeSuccess, ibxeDelphiException, ibxeNoOptionsSet, ibxeNoDestina'
   +'tionDirectory, ibxeNosourceDirectory, ibxeNoUninstallFile, ibxeOptionNeeds'
   +'Client, ibxeOptionNeedsServer, ibxeInvalidOption, ibxeInvalidOnErrorResult'
   +', ibxeInvalidOnStatusResult, ibxeDPBConstantUnknownEx, ibxeTPBConstantUnkn'
   +'ownEx, ibxeUnknownPlan, ibxeFieldSizeMismatch, ibxeEventAlreadyRegistered,'
   +' ibxeStringTooLarge, ibxeIB65feature, ibxeIB70Feature )');
 // CL.AddTypeS('PStatusVector', '^TStatusVector // will not work');
 CL.AddConstantN('IBPalette1','String').SetString( 'InterBase');
 CL.AddConstantN('IBPalette2','String').SetString( 'InterBase Admin');
 CL.AddConstantN('IBLocalBufferLength','LongInt').SetInt( 512);
 CL.AddConstantN('IBBigLocalBufferLength','LongInt').SetInt( IBLocalBufferLength * 2);
 CL.AddConstantN('IBHugeLocalBufferLength','LongInt').SetInt( IBBigLocalBufferLength * 20);
 CL.AddDelphiFunction('Procedure IBAlloc( var P, OldSize, NewSize : Integer)');
 CL.AddDelphiFunction('Procedure IBError( ErrMess : TIBClientError; const Args : array of const)');
 CL.AddDelphiFunction('Procedure IBDataBaseError');
 //CL.AddDelphiFunction('Function StatusVector : PISC_STATUS');
 //CL.AddDelphiFunction('Function StatusVectorArray : PStatusVector');
 CL.AddDelphiFunction('Function CheckStatusVector( ErrorCodes : array of ISC_STATUS) : Boolean');
 CL.AddDelphiFunction('Function StatusVectorAsText : string');
 CL.AddDelphiFunction('Procedure SetIBDataBaseErrorMessages( Value : TIBDataBaseErrorMessages)');
 CL.AddDelphiFunction('Function GetIBDataBaseErrorMessages : TIBDataBaseErrorMessages');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EIBErrorIBErrorCode_R(Self: EIBError; var T: Long);
begin T := Self.IBErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure EIBErrorSQLCode_R(Self: EIBError; var T: Long);
begin T := Self.SQLCode; end;

(*----------------------------------------------------------------------------*)
Function EIBErrorCreate1_P(Self: TClass; CreateNewInstance: Boolean;  ASQLCode : Long; AIBErrorCode : Long; Msg : string):TObject;
Begin Result := EIBError.Create(ASQLCode, AIBErrorCode, Msg); END;

(*----------------------------------------------------------------------------*)
Function EIBErrorCreate_P(Self: TClass; CreateNewInstance: Boolean;  ASQLCode : Long; Msg : string):TObject;
Begin Result := EIBError.Create(ASQLCode, Msg); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IB_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IBAlloc, 'IBAlloc', cdRegister);
 S.RegisterDelphiFunction(@IBError, 'IBError', cdRegister);
 S.RegisterDelphiFunction(@IBDataBaseError, 'IBDataBaseError', cdRegister);
 S.RegisterDelphiFunction(@StatusVector, 'StatusVector', cdRegister);
 S.RegisterDelphiFunction(@StatusVectorArray, 'StatusVectorArray', cdRegister);
 S.RegisterDelphiFunction(@CheckStatusVector, 'CheckStatusVector', cdRegister);
 S.RegisterDelphiFunction(@StatusVectorAsText, 'StatusVectorAsText', cdRegister);
 S.RegisterDelphiFunction(@SetIBDataBaseErrorMessages, 'SetIBDataBaseErrorMessages', cdRegister);
 S.RegisterDelphiFunction(@GetIBDataBaseErrorMessages, 'GetIBDataBaseErrorMessages', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EIBError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIBError) do
  begin
    RegisterConstructor(@EIBErrorCreate_P, 'Create');
    RegisterConstructor(@EIBErrorCreate1_P, 'Create1');
    RegisterPropertyHelper(@EIBErrorSQLCode_R,nil,'SQLCode');
    RegisterPropertyHelper(@EIBErrorIBErrorCode_R,nil,'IBErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IB(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EIBError(CL);
  with CL.Add(EIBInterBaseError) do
  with CL.Add(EIBInterBaseRoleError) do
  with CL.Add(EIBClientError) do
  with CL.Add(EIBPlanError) do
end;

 
 
{ TPSImport_IB }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IB.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IB(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IB.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IB(ri);
  RIRegister_IB_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
