unit uPSI_snmpsend;
{
   synapse V40
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
  TPSImport_snmpsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSNMPSend(CL: TPSPascalCompiler);
procedure SIRegister_TSNMPRec(CL: TPSPascalCompiler);
procedure SIRegister_TSNMPMib(CL: TPSPascalCompiler);
procedure SIRegister_snmpsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_snmpsend_Routines(S: TPSExec);
procedure RIRegister_TSNMPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSNMPRec(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSNMPMib(CL: TPSRuntimeClassImporter);
procedure RIRegister_snmpsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,asn1util
  ,synaip
  ,synacode
  ,synacrypt
  ,snmpsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_snmpsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSNMPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TSNMPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TSNMPSend') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Function SendRequest : Boolean');
    RegisterMethod('Function SendTrap : Boolean');
    RegisterMethod('Function RecvTrap : Boolean');
    RegisterMethod('Function DoIt : Boolean');
    RegisterProperty('Buffer', 'AnsiString', iptrw);
    RegisterProperty('HostIP', 'AnsiString', iptr);
    RegisterProperty('Query', 'TSNMPRec', iptr);
    RegisterProperty('Reply', 'TSNMPRec', iptr);
    RegisterProperty('Sock', 'TUDPBlockSocket', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSNMPRec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSNMPRec') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSNMPRec') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Function DecodeBuf( Buffer : AnsiString) : Boolean');
    RegisterMethod('Function EncodeBuf : AnsiString');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure MIBAdd( const MIB, Value : AnsiString; ValueType : Integer)');
    RegisterMethod('Procedure MIBDelete( Index : Integer)');
    RegisterMethod('Function MIBGet( const MIB : AnsiString) : AnsiString');
    RegisterMethod('Function MIBCount : integer');
    RegisterMethod('Function MIBByIndex( Index : Integer) : TSNMPMib');
    RegisterProperty('SNMPMibList', 'TList', iptr);
    RegisterProperty('Version', 'Integer', iptrw);
    RegisterProperty('Community', 'AnsiString', iptrw);
    RegisterProperty('PDUType', 'Integer', iptrw);
    RegisterProperty('ID', 'Integer', iptrw);
    RegisterProperty('ErrorStatus', 'Integer', iptrw);
    RegisterProperty('ErrorIndex', 'Integer', iptrw);
    RegisterProperty('NonRepeaters', 'Integer', iptrw);
    RegisterProperty('MaxRepetitions', 'Integer', iptrw);
    RegisterProperty('MaxSize', 'Integer', iptrw);
    RegisterProperty('Flags', 'TV3Flags', iptrw);
    RegisterProperty('FlagReportable', 'Boolean', iptrw);
    RegisterProperty('ContextEngineID', 'AnsiString', iptrw);
    RegisterProperty('ContextName', 'AnsiString', iptrw);
    RegisterProperty('AuthMode', 'TV3Auth', iptrw);
    RegisterProperty('PrivMode', 'TV3Priv', iptrw);
    RegisterProperty('AuthEngineID', 'AnsiString', iptrw);
    RegisterProperty('AuthEngineBoots', 'Integer', iptrw);
    RegisterProperty('AuthEngineTime', 'Integer', iptrw);
    RegisterProperty('AuthEngineTimeStamp', 'Cardinal', iptrw);
    RegisterProperty('UserName', 'AnsiString', iptrw);
    RegisterProperty('Password', 'AnsiString', iptrw);
    RegisterProperty('AuthKey', 'AnsiString', iptrw);
    RegisterProperty('PrivPassword', 'AnsiString', iptrw);
    RegisterProperty('PrivKey', 'AnsiString', iptrw);
    RegisterProperty('OldTrapEnterprise', 'AnsiString', iptrw);
    RegisterProperty('OldTrapHost', 'AnsiString', iptrw);
    RegisterProperty('OldTrapGen', 'Integer', iptrw);
    RegisterProperty('OldTrapSpec', 'Integer', iptrw);
    RegisterProperty('OldTrapTimeTicks', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSNMPMib(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSNMPMib') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSNMPMib') do begin
    RegisterProperty('OID', 'AnsiString', iptrw);
    RegisterProperty('Value', 'AnsiString', iptrw);
    RegisterProperty('ValueType', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_snmpsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cSnmpProtocol','String').SetString( '161');
 CL.AddConstantN('cSnmpTrapProtocol','String').SetString( '162');
 CL.AddConstantN('SNMP_V1','LongInt').SetInt( 0);
 CL.AddConstantN('SNMP_V2C','LongInt').SetInt( 1);
 CL.AddConstantN('SNMP_V3','LongInt').SetInt( 3);
 CL.AddConstantN('PDUGetRequest','LongWord').SetUInt( $A0);
 CL.AddConstantN('PDUGetNextRequest','LongWord').SetUInt( $A1);
 CL.AddConstantN('PDUGetResponse','LongWord').SetUInt( $A2);
 CL.AddConstantN('PDUSetRequest','LongWord').SetUInt( $A3);
 CL.AddConstantN('PDUTrap','LongWord').SetUInt( $A4);
 CL.AddConstantN('PDUGetBulkRequest','LongWord').SetUInt( $A5);
 CL.AddConstantN('PDUInformRequest','LongWord').SetUInt( $A6);
 CL.AddConstantN('PDUTrapV2','LongWord').SetUInt( $A7);
 CL.AddConstantN('PDUReport','LongWord').SetUInt( $A8);
 CL.AddConstantN('ENoError','LongInt').SetInt( 0);
 CL.AddConstantN('ETooBig','LongInt').SetInt( 1);
 CL.AddConstantN('ENoSuchName','LongInt').SetInt( 2);
 CL.AddConstantN('EBadValue','LongInt').SetInt( 3);
 CL.AddConstantN('EReadOnly','LongInt').SetInt( 4);
 CL.AddConstantN('EGenErr','LongInt').SetInt( 5);
 CL.AddConstantN('ENoAccess','LongInt').SetInt( 6);
 CL.AddConstantN('EWrongType','LongInt').SetInt( 7);
 CL.AddConstantN('EWrongLength','LongInt').SetInt( 8);
 CL.AddConstantN('EWrongEncoding','LongInt').SetInt( 9);
 CL.AddConstantN('EWrongValue','LongInt').SetInt( 10);
 CL.AddConstantN('ENoCreation','LongInt').SetInt( 11);
 CL.AddConstantN('EInconsistentValue','LongInt').SetInt( 12);
 CL.AddConstantN('EResourceUnavailable','LongInt').SetInt( 13);
 CL.AddConstantN('ECommitFailed','LongInt').SetInt( 14);
 CL.AddConstantN('EUndoFailed','LongInt').SetInt( 15);
 CL.AddConstantN('EAuthorizationError','LongInt').SetInt( 16);
 CL.AddConstantN('ENotWritable','LongInt').SetInt( 17);
 CL.AddConstantN('EInconsistentName','LongInt').SetInt( 18);
  CL.AddTypeS('TV3Flags', '( NoAuthNoPriv, AuthNoPriv, AuthPriv )');
  CL.AddTypeS('TV3Auth', '( AuthMD5, AuthSHA1 )');
  CL.AddTypeS('TV3Priv', '( PrivDES, Priv3DES, PrivAES )');
  SIRegister_TSNMPMib(CL);
  CL.AddTypeS('TV3Sync', 'record EngineID : AnsiString; EngineBoots : integer; '
   +'EngineTime : integer; EngineStamp : Cardinal; end');
  SIRegister_TSNMPRec(CL);
  SIRegister_TSNMPSend(CL);
 CL.AddDelphiFunction('Function SNMPGet( const OID, Community, SNMPHost : AnsiString; var Value : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function SNMPSet( const OID, Community, SNMPHost, Value : AnsiString; ValueType : Integer) : Boolean');
 CL.AddDelphiFunction('Function SNMPGetNext( var OID : AnsiString; const Community, SNMPHost : AnsiString; var Value : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function SNMPGetTable( const BaseOID, Community, SNMPHost : AnsiString; const Value : TStrings) : Boolean');
 CL.AddDelphiFunction('Function SNMPGetTableElement( const BaseOID, RowID, ColID, Community, SNMPHost : AnsiString; var Value : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function SendTrap( const Dest, Source, Enterprise, Community : AnsiString; Generic, Specific, Seconds : Integer; const MIBName, MIBValue : AnsiString; MIBtype : Integer) : Integer');
 CL.AddDelphiFunction('Function RecvTrap( var Dest, Source, Enterprise, Community : AnsiString; var Generic, Specific, Seconds : Integer; const MIBName, MIBValue : TStringList) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSNMPSendSock_R(Self: TSNMPSend; var T: TUDPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPSendReply_R(Self: TSNMPSend; var T: TSNMPRec);
begin T := Self.Reply; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPSendQuery_R(Self: TSNMPSend; var T: TSNMPRec);
begin T := Self.Query; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPSendHostIP_R(Self: TSNMPSend; var T: AnsiString);
begin T := Self.HostIP; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPSendBuffer_W(Self: TSNMPSend; const T: AnsiString);
begin Self.Buffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPSendBuffer_R(Self: TSNMPSend; var T: AnsiString);
begin T := Self.Buffer; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapTimeTicks_W(Self: TSNMPRec; const T: Integer);
begin Self.OldTrapTimeTicks := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapTimeTicks_R(Self: TSNMPRec; var T: Integer);
begin T := Self.OldTrapTimeTicks; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapSpec_W(Self: TSNMPRec; const T: Integer);
begin Self.OldTrapSpec := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapSpec_R(Self: TSNMPRec; var T: Integer);
begin T := Self.OldTrapSpec; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapGen_W(Self: TSNMPRec; const T: Integer);
begin Self.OldTrapGen := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapGen_R(Self: TSNMPRec; var T: Integer);
begin T := Self.OldTrapGen; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapHost_W(Self: TSNMPRec; const T: AnsiString);
begin Self.OldTrapHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapHost_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.OldTrapHost; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapEnterprise_W(Self: TSNMPRec; const T: AnsiString);
begin Self.OldTrapEnterprise := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecOldTrapEnterprise_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.OldTrapEnterprise; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPrivKey_W(Self: TSNMPRec; const T: AnsiString);
begin Self.PrivKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPrivKey_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.PrivKey; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPrivPassword_W(Self: TSNMPRec; const T: AnsiString);
begin Self.PrivPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPrivPassword_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.PrivPassword; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthKey_W(Self: TSNMPRec; const T: AnsiString);
begin Self.AuthKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthKey_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.AuthKey; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPassword_W(Self: TSNMPRec; const T: AnsiString);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPassword_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecUserName_W(Self: TSNMPRec; const T: AnsiString);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecUserName_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineTimeStamp_W(Self: TSNMPRec; const T: Cardinal);
begin Self.AuthEngineTimeStamp := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineTimeStamp_R(Self: TSNMPRec; var T: Cardinal);
begin T := Self.AuthEngineTimeStamp; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineTime_W(Self: TSNMPRec; const T: Integer);
begin Self.AuthEngineTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineTime_R(Self: TSNMPRec; var T: Integer);
begin T := Self.AuthEngineTime; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineBoots_W(Self: TSNMPRec; const T: Integer);
begin Self.AuthEngineBoots := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineBoots_R(Self: TSNMPRec; var T: Integer);
begin T := Self.AuthEngineBoots; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineID_W(Self: TSNMPRec; const T: AnsiString);
begin Self.AuthEngineID := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthEngineID_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.AuthEngineID; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPrivMode_W(Self: TSNMPRec; const T: TV3Priv);
begin Self.PrivMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPrivMode_R(Self: TSNMPRec; var T: TV3Priv);
begin T := Self.PrivMode; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthMode_W(Self: TSNMPRec; const T: TV3Auth);
begin Self.AuthMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecAuthMode_R(Self: TSNMPRec; var T: TV3Auth);
begin T := Self.AuthMode; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecContextName_W(Self: TSNMPRec; const T: AnsiString);
begin Self.ContextName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecContextName_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.ContextName; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecContextEngineID_W(Self: TSNMPRec; const T: AnsiString);
begin Self.ContextEngineID := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecContextEngineID_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.ContextEngineID; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecFlagReportable_W(Self: TSNMPRec; const T: Boolean);
begin Self.FlagReportable := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecFlagReportable_R(Self: TSNMPRec; var T: Boolean);
begin T := Self.FlagReportable; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecFlags_W(Self: TSNMPRec; const T: TV3Flags);
begin Self.Flags := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecFlags_R(Self: TSNMPRec; var T: TV3Flags);
begin T := Self.Flags; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecMaxSize_W(Self: TSNMPRec; const T: Integer);
begin Self.MaxSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecMaxSize_R(Self: TSNMPRec; var T: Integer);
begin T := Self.MaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecMaxRepetitions_W(Self: TSNMPRec; const T: Integer);
begin Self.MaxRepetitions := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecMaxRepetitions_R(Self: TSNMPRec; var T: Integer);
begin T := Self.MaxRepetitions; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecNonRepeaters_W(Self: TSNMPRec; const T: Integer);
begin Self.NonRepeaters := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecNonRepeaters_R(Self: TSNMPRec; var T: Integer);
begin T := Self.NonRepeaters; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecErrorIndex_W(Self: TSNMPRec; const T: Integer);
begin Self.ErrorIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecErrorIndex_R(Self: TSNMPRec; var T: Integer);
begin T := Self.ErrorIndex; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecErrorStatus_W(Self: TSNMPRec; const T: Integer);
begin Self.ErrorStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecErrorStatus_R(Self: TSNMPRec; var T: Integer);
begin T := Self.ErrorStatus; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecID_W(Self: TSNMPRec; const T: Integer);
begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecID_R(Self: TSNMPRec; var T: Integer);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPDUType_W(Self: TSNMPRec; const T: Integer);
begin Self.PDUType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecPDUType_R(Self: TSNMPRec; var T: Integer);
begin T := Self.PDUType; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecCommunity_W(Self: TSNMPRec; const T: AnsiString);
begin Self.Community := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecCommunity_R(Self: TSNMPRec; var T: AnsiString);
begin T := Self.Community; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecVersion_W(Self: TSNMPRec; const T: Integer);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecVersion_R(Self: TSNMPRec; var T: Integer);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPRecSNMPMibList_R(Self: TSNMPRec; var T: TList);
begin T := Self.SNMPMibList; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPMibValueType_W(Self: TSNMPMib; const T: Integer);
begin Self.ValueType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPMibValueType_R(Self: TSNMPMib; var T: Integer);
begin T := Self.ValueType; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPMibValue_W(Self: TSNMPMib; const T: AnsiString);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPMibValue_R(Self: TSNMPMib; var T: AnsiString);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPMibOID_W(Self: TSNMPMib; const T: AnsiString);
begin Self.OID := T; end;

(*----------------------------------------------------------------------------*)
procedure TSNMPMibOID_R(Self: TSNMPMib; var T: AnsiString);
begin T := Self.OID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_snmpsend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SNMPGet, 'SNMPGet', cdRegister);
 S.RegisterDelphiFunction(@SNMPSet, 'SNMPSet', cdRegister);
 S.RegisterDelphiFunction(@SNMPGetNext, 'SNMPGetNext', cdRegister);
 S.RegisterDelphiFunction(@SNMPGetTable, 'SNMPGetTable', cdRegister);
 S.RegisterDelphiFunction(@SNMPGetTableElement, 'SNMPGetTableElement', cdRegister);
 S.RegisterDelphiFunction(@SendTrap, 'SendTrap', cdRegister);
 S.RegisterDelphiFunction(@RecvTrap, 'RecvTrap', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSNMPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSNMPSend) do begin
    RegisterConstructor(@TSNMPSend.Create, 'Create');
      RegisterMethod(@TSNMPSend.Destroy, 'Free');
       RegisterMethod(@TSNMPSend.SendRequest, 'SendRequest');
    RegisterMethod(@TSNMPSend.SendTrap, 'SendTrap');
    RegisterMethod(@TSNMPSend.RecvTrap, 'RecvTrap');
    RegisterMethod(@TSNMPSend.DoIt, 'DoIt');
    RegisterPropertyHelper(@TSNMPSendBuffer_R,@TSNMPSendBuffer_W,'Buffer');
    RegisterPropertyHelper(@TSNMPSendHostIP_R,nil,'HostIP');
    RegisterPropertyHelper(@TSNMPSendQuery_R,nil,'Query');
    RegisterPropertyHelper(@TSNMPSendReply_R,nil,'Reply');
    RegisterPropertyHelper(@TSNMPSendSock_R,nil,'Sock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSNMPRec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSNMPRec) do begin
    RegisterConstructor(@TSNMPRec.Create, 'Create');
      RegisterMethod(@TSNMPRec.Destroy, 'Free');
      RegisterMethod(@TSNMPRec.DecodeBuf, 'DecodeBuf');
    RegisterMethod(@TSNMPRec.EncodeBuf, 'EncodeBuf');
    RegisterMethod(@TSNMPRec.Clear, 'Clear');
    RegisterMethod(@TSNMPRec.MIBAdd, 'MIBAdd');
    RegisterMethod(@TSNMPRec.MIBDelete, 'MIBDelete');
    RegisterMethod(@TSNMPRec.MIBGet, 'MIBGet');
    RegisterMethod(@TSNMPRec.MIBCount, 'MIBCount');
    RegisterMethod(@TSNMPRec.MIBByIndex, 'MIBByIndex');
    RegisterPropertyHelper(@TSNMPRecSNMPMibList_R,nil,'SNMPMibList');
    RegisterPropertyHelper(@TSNMPRecVersion_R,@TSNMPRecVersion_W,'Version');
    RegisterPropertyHelper(@TSNMPRecCommunity_R,@TSNMPRecCommunity_W,'Community');
    RegisterPropertyHelper(@TSNMPRecPDUType_R,@TSNMPRecPDUType_W,'PDUType');
    RegisterPropertyHelper(@TSNMPRecID_R,@TSNMPRecID_W,'ID');
    RegisterPropertyHelper(@TSNMPRecErrorStatus_R,@TSNMPRecErrorStatus_W,'ErrorStatus');
    RegisterPropertyHelper(@TSNMPRecErrorIndex_R,@TSNMPRecErrorIndex_W,'ErrorIndex');
    RegisterPropertyHelper(@TSNMPRecNonRepeaters_R,@TSNMPRecNonRepeaters_W,'NonRepeaters');
    RegisterPropertyHelper(@TSNMPRecMaxRepetitions_R,@TSNMPRecMaxRepetitions_W,'MaxRepetitions');
    RegisterPropertyHelper(@TSNMPRecMaxSize_R,@TSNMPRecMaxSize_W,'MaxSize');
    RegisterPropertyHelper(@TSNMPRecFlags_R,@TSNMPRecFlags_W,'Flags');
    RegisterPropertyHelper(@TSNMPRecFlagReportable_R,@TSNMPRecFlagReportable_W,'FlagReportable');
    RegisterPropertyHelper(@TSNMPRecContextEngineID_R,@TSNMPRecContextEngineID_W,'ContextEngineID');
    RegisterPropertyHelper(@TSNMPRecContextName_R,@TSNMPRecContextName_W,'ContextName');
    RegisterPropertyHelper(@TSNMPRecAuthMode_R,@TSNMPRecAuthMode_W,'AuthMode');
    RegisterPropertyHelper(@TSNMPRecPrivMode_R,@TSNMPRecPrivMode_W,'PrivMode');
    RegisterPropertyHelper(@TSNMPRecAuthEngineID_R,@TSNMPRecAuthEngineID_W,'AuthEngineID');
    RegisterPropertyHelper(@TSNMPRecAuthEngineBoots_R,@TSNMPRecAuthEngineBoots_W,'AuthEngineBoots');
    RegisterPropertyHelper(@TSNMPRecAuthEngineTime_R,@TSNMPRecAuthEngineTime_W,'AuthEngineTime');
    RegisterPropertyHelper(@TSNMPRecAuthEngineTimeStamp_R,@TSNMPRecAuthEngineTimeStamp_W,'AuthEngineTimeStamp');
    RegisterPropertyHelper(@TSNMPRecUserName_R,@TSNMPRecUserName_W,'UserName');
    RegisterPropertyHelper(@TSNMPRecPassword_R,@TSNMPRecPassword_W,'Password');
    RegisterPropertyHelper(@TSNMPRecAuthKey_R,@TSNMPRecAuthKey_W,'AuthKey');
    RegisterPropertyHelper(@TSNMPRecPrivPassword_R,@TSNMPRecPrivPassword_W,'PrivPassword');
    RegisterPropertyHelper(@TSNMPRecPrivKey_R,@TSNMPRecPrivKey_W,'PrivKey');
    RegisterPropertyHelper(@TSNMPRecOldTrapEnterprise_R,@TSNMPRecOldTrapEnterprise_W,'OldTrapEnterprise');
    RegisterPropertyHelper(@TSNMPRecOldTrapHost_R,@TSNMPRecOldTrapHost_W,'OldTrapHost');
    RegisterPropertyHelper(@TSNMPRecOldTrapGen_R,@TSNMPRecOldTrapGen_W,'OldTrapGen');
    RegisterPropertyHelper(@TSNMPRecOldTrapSpec_R,@TSNMPRecOldTrapSpec_W,'OldTrapSpec');
    RegisterPropertyHelper(@TSNMPRecOldTrapTimeTicks_R,@TSNMPRecOldTrapTimeTicks_W,'OldTrapTimeTicks');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSNMPMib(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSNMPMib) do
  begin
    RegisterPropertyHelper(@TSNMPMibOID_R,@TSNMPMibOID_W,'OID');
    RegisterPropertyHelper(@TSNMPMibValue_R,@TSNMPMibValue_W,'Value');
    RegisterPropertyHelper(@TSNMPMibValueType_R,@TSNMPMibValueType_W,'ValueType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_snmpsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSNMPMib(CL);
  RIRegister_TSNMPRec(CL);
  RIRegister_TSNMPSend(CL);
end;

 
 
{ TPSImport_snmpsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_snmpsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_snmpsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_snmpsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_snmpsend(ri);
  RIRegister_snmpsend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
