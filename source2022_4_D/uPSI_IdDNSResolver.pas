unit uPSI_IdDNSResolver;
{
   big unit - no 600
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
  TPSImport_IdDNSResolver = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdDNSResolver(CL: TPSPascalCompiler);
procedure SIRegister_TDNSHeader(CL: TPSPascalCompiler);
procedure SIRegister_TPTRRecord(CL: TPSPascalCompiler);
procedure SIRegister_TQueryResult(CL: TPSPascalCompiler);
procedure SIRegister_TCNRecord(CL: TPSPascalCompiler);
procedure SIRegister_TNSRecord(CL: TPSPascalCompiler);
procedure SIRegister_TNAMERecord(CL: TPSPascalCompiler);
procedure SIRegister_TSOARecord(CL: TPSPascalCompiler);
procedure SIRegister_TMINFORecord(CL: TPSPascalCompiler);
procedure SIRegister_THINFORecord(CL: TPSPascalCompiler);
procedure SIRegister_TTextRecord(CL: TPSPascalCompiler);
procedure SIRegister_TMXRecord(CL: TPSPascalCompiler);
procedure SIRegister_TWKSRecord(CL: TPSPascalCompiler);
procedure SIRegister_TARecord(CL: TPSPascalCompiler);
procedure SIRegister_TRDATARecord(CL: TPSPascalCompiler);
procedure SIRegister_TResultRecord(CL: TPSPascalCompiler);
procedure SIRegister_IdDNSResolver(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdDNSResolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDNSHeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPTRRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TQueryResult(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCNRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNSRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNAMERecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSOARecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMINFORecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_THINFORecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMXRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWKSRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TARecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRDATARecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TResultRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdDNSResolver(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdUDPClient
  ,IdDNSResolver
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdDNSResolver]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdDNSResolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdUDPClient', 'TIdDNSResolver') do
  with CL.AddClassN(CL.FindClass('TIdUDPClient'),'TIdDNSResolver') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Resolve( ADomain : string)');
    RegisterProperty('QueryResult', 'TQueryResult', iptr);
    RegisterProperty('QueryRecords', 'TQueryType', iptrw);
    RegisterProperty('AllowRecursiveQueries', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDNSHeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDNSHeader') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDNSHeader') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure ClearByteCode');
    RegisterProperty('ID', 'Word', iptrw);
    RegisterProperty('Qr', 'Word', iptrw);
    RegisterProperty('OpCode', 'Word', iptrw);
    RegisterProperty('AA', 'Word', iptrw);
    RegisterProperty('TC', 'Word', iptrw);
    RegisterProperty('RD', 'Word', iptrw);
    RegisterProperty('RA', 'Word', iptrw);
    RegisterProperty('RCode', 'Word', iptrw);
    RegisterProperty('BitCode', 'Word', iptr);
    RegisterProperty('QDCount', 'Word', iptrw);
    RegisterProperty('ANCount', 'Word', iptrw);
    RegisterProperty('NSCount', 'Word', iptrw);
    RegisterProperty('ARCount', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPTRRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNAMERecord', 'TPTRRecord') do
  with CL.AddClassN(CL.FindClass('TNAMERecord'),'TPTRRecord') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TQueryResult(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TQueryResult') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TQueryResult') do begin
    RegisterMethod('Constructor Create( AResultRecord : TResultRecord)');
    RegisterMethod('Function Add( Answer : string; var APos : Integer) : TResultRecord');
    RegisterMethod('Procedure Clear');
    RegisterProperty('QueryClass', 'Word', iptr);
    RegisterProperty('QueryType', 'Word', iptr);
    RegisterProperty('DomainName', 'String', iptr);
    RegisterProperty('Items', 'TResultRecord Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCNRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNAMERecord', 'TCNRecord') do
  with CL.AddClassN(CL.FindClass('TNAMERecord'),'TCNRecord') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNSRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNAMERecord', 'TNSRecord') do
  with CL.AddClassN(CL.FindClass('TNAMERecord'),'TNSRecord') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNAMERecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResultRecord', 'TNAMERecord') do
  with CL.AddClassN(CL.FindClass('TResultRecord'),'TNAMERecord') do begin
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterProperty('HostName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSOARecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResultRecord', 'TSOARecord') do
  with CL.AddClassN(CL.FindClass('TResultRecord'),'TSOARecord') do begin
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterProperty('Primary', 'string', iptr);
    RegisterProperty('ResponsiblePerson', 'string', iptr);
    RegisterProperty('Serial', 'cardinal', iptr);
    RegisterProperty('Refresh', 'Cardinal', iptr);
    RegisterProperty('Retry', 'Cardinal', iptr);
    RegisterProperty('Expire', 'Cardinal', iptr);
    RegisterProperty('MinimumTTL', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMINFORecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResultRecord', 'TMINFORecord') do
  with CL.AddClassN(CL.FindClass('TResultRecord'),'TMINFORecord') do begin
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterProperty('ResponsiblePersonMailbox', 'String', iptr);
    RegisterProperty('ErrorMailbox', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THINFORecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTextRecord', 'THINFORecord') do
  with CL.AddClassN(CL.FindClass('TTextRecord'),'THINFORecord') do begin
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterProperty('CPU', 'String', iptr);
    RegisterProperty('OS', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResultRecord', 'TTextRecord') do
  with CL.AddClassN(CL.FindClass('TResultRecord'),'TTextRecord') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterProperty('Text', 'TStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMXRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResultRecord', 'TMXRecord') do
  with CL.AddClassN(CL.FindClass('TResultRecord'),'TMXRecord') do begin
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('ExchangeServer', 'string', iptr);
    RegisterProperty('Preference', 'word', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWKSRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResultRecord', 'TWKSRecord') do
  with CL.AddClassN(CL.FindClass('TResultRecord'),'TWKSRecord') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterProperty('Address', 'String', iptr);
    RegisterProperty('Protocol', 'Word', iptr);
    RegisterProperty('BitMap', 'Byte integer', iptr);
    RegisterProperty('ByteCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TARecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRDATARecord', 'TARecord') do
  with CL.AddClassN(CL.FindClass('TRDATARecord'),'TARecord') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRDATARecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TResultRecord', 'TRDATARecord') do
  with CL.AddClassN(CL.FindClass('TResultRecord'),'TRDATARecord') do begin
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('IPAddress', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TResultRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TResultRecord') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TResultRecord') do begin
    RegisterMethod('Procedure Parse( CompleteMessage : String; APos : Integer)');
    RegisterProperty('RecType', 'TQueryRecordTypes', iptr);
    RegisterProperty('RecClass', 'word', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('TTL', 'cardinal', iptr);
    RegisterProperty('RDataLength', 'Integer', iptr);
    RegisterProperty('RData', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdDNSResolver(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TQueryRecordTypes', '( qtA, qtNS, qtMD, qtMF, qtName, qtSOA, qtM'
   +'B, qtMG, qtMR, qtNull, qtWKS, qtPTR, qtHINFO, qtMINFO, qtMX, qtTXT, qtSTAR)');
  CL.AddTypeS('TQueryType', 'set of TQueryRecordTypes');
  SIRegister_TResultRecord(CL);
  SIRegister_TRDATARecord(CL);
  SIRegister_TARecord(CL);
  SIRegister_TWKSRecord(CL);
  SIRegister_TMXRecord(CL);
  SIRegister_TTextRecord(CL);
  SIRegister_THINFORecord(CL);
  SIRegister_TMINFORecord(CL);
  SIRegister_TSOARecord(CL);
  SIRegister_TNAMERecord(CL);
  SIRegister_TNSRecord(CL);
  SIRegister_TCNRecord(CL);
  SIRegister_TQueryResult(CL);
  SIRegister_TPTRRecord(CL);
  SIRegister_TDNSHeader(CL);
  SIRegister_TIdDNSResolver(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdDNSResolverAllowRecursiveQueries_W(Self: TIdDNSResolver; const T: Boolean);
begin Self.AllowRecursiveQueries := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDNSResolverAllowRecursiveQueries_R(Self: TIdDNSResolver; var T: Boolean);
begin T := Self.AllowRecursiveQueries; end;

(*----------------------------------------------------------------------------*)
procedure TIdDNSResolverQueryRecords_W(Self: TIdDNSResolver; const T: TQueryType);
begin Self.QueryRecords := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDNSResolverQueryRecords_R(Self: TIdDNSResolver; var T: TQueryType);
begin T := Self.QueryRecords; end;

(*----------------------------------------------------------------------------*)
procedure TIdDNSResolverQueryResult_R(Self: TIdDNSResolver; var T: TQueryResult);
begin T := Self.QueryResult; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderARCount_W(Self: TDNSHeader; const T: Word);
begin Self.ARCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderARCount_R(Self: TDNSHeader; var T: Word);
begin T := Self.ARCount; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderNSCount_W(Self: TDNSHeader; const T: Word);
begin Self.NSCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderNSCount_R(Self: TDNSHeader; var T: Word);
begin T := Self.NSCount; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderANCount_W(Self: TDNSHeader; const T: Word);
begin Self.ANCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderANCount_R(Self: TDNSHeader; var T: Word);
begin T := Self.ANCount; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderQDCount_W(Self: TDNSHeader; const T: Word);
begin Self.QDCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderQDCount_R(Self: TDNSHeader; var T: Word);
begin T := Self.QDCount; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderBitCode_R(Self: TDNSHeader; var T: Word);
begin T := Self.BitCode; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderRCode_W(Self: TDNSHeader; const T: Word);
begin Self.RCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderRCode_R(Self: TDNSHeader; var T: Word);
begin T := Self.RCode; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderRA_W(Self: TDNSHeader; const T: Word);
begin Self.RA := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderRA_R(Self: TDNSHeader; var T: Word);
begin T := Self.RA; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderRD_W(Self: TDNSHeader; const T: Word);
begin Self.RD := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderRD_R(Self: TDNSHeader; var T: Word);
begin T := Self.RD; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderTC_W(Self: TDNSHeader; const T: Word);
begin Self.TC := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderTC_R(Self: TDNSHeader; var T: Word);
begin T := Self.TC; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderAA_W(Self: TDNSHeader; const T: Word);
begin Self.AA := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderAA_R(Self: TDNSHeader; var T: Word);
begin T := Self.AA; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderOpCode_W(Self: TDNSHeader; const T: Word);
begin Self.OpCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderOpCode_R(Self: TDNSHeader; var T: Word);
begin T := Self.OpCode; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderQr_W(Self: TDNSHeader; const T: Word);
begin Self.Qr := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderQr_R(Self: TDNSHeader; var T: Word);
begin T := Self.Qr; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderID_W(Self: TDNSHeader; const T: Word);
begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSHeaderID_R(Self: TDNSHeader; var T: Word);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TQueryResultItems_W(Self: TQueryResult; const T: TResultRecord; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TQueryResultItems_R(Self: TQueryResult; var T: TResultRecord; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TQueryResultDomainName_R(Self: TQueryResult; var T: String);
begin T := Self.DomainName; end;

(*----------------------------------------------------------------------------*)
procedure TQueryResultQueryType_R(Self: TQueryResult; var T: Word);
begin T := Self.QueryType; end;

(*----------------------------------------------------------------------------*)
procedure TQueryResultQueryClass_R(Self: TQueryResult; var T: Word);
begin T := Self.QueryClass; end;

(*----------------------------------------------------------------------------*)
procedure TNAMERecordHostName_R(Self: TNAMERecord; var T: string);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure TSOARecordMinimumTTL_R(Self: TSOARecord; var T: Cardinal);
begin T := Self.MinimumTTL; end;

(*----------------------------------------------------------------------------*)
procedure TSOARecordExpire_R(Self: TSOARecord; var T: Cardinal);
begin T := Self.Expire; end;

(*----------------------------------------------------------------------------*)
procedure TSOARecordRetry_R(Self: TSOARecord; var T: Cardinal);
begin T := Self.Retry; end;

(*----------------------------------------------------------------------------*)
procedure TSOARecordRefresh_R(Self: TSOARecord; var T: Cardinal);
begin T := Self.Refresh; end;

(*----------------------------------------------------------------------------*)
procedure TSOARecordSerial_R(Self: TSOARecord; var T: cardinal);
begin T := Self.Serial; end;

(*----------------------------------------------------------------------------*)
procedure TSOARecordResponsiblePerson_R(Self: TSOARecord; var T: string);
begin T := Self.ResponsiblePerson; end;

(*----------------------------------------------------------------------------*)
procedure TSOARecordPrimary_R(Self: TSOARecord; var T: string);
begin T := Self.Primary; end;

(*----------------------------------------------------------------------------*)
procedure TMINFORecordErrorMailbox_R(Self: TMINFORecord; var T: String);
begin T := Self.ErrorMailbox; end;

(*----------------------------------------------------------------------------*)
procedure TMINFORecordResponsiblePersonMailbox_R(Self: TMINFORecord; var T: String);
begin T := Self.ResponsiblePersonMailbox; end;

(*----------------------------------------------------------------------------*)
procedure THINFORecordOS_R(Self: THINFORecord; var T: String);
begin T := Self.OS; end;

(*----------------------------------------------------------------------------*)
procedure THINFORecordCPU_R(Self: THINFORecord; var T: String);
begin T := Self.CPU; end;

(*----------------------------------------------------------------------------*)
procedure TTextRecordText_R(Self: TTextRecord; var T: TStrings);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TMXRecordPreference_R(Self: TMXRecord; var T: word);
begin T := Self.Preference; end;

(*----------------------------------------------------------------------------*)
procedure TMXRecordExchangeServer_R(Self: TMXRecord; var T: string);
begin T := Self.ExchangeServer; end;

(*----------------------------------------------------------------------------*)
procedure TWKSRecordByteCount_R(Self: TWKSRecord; var T: integer);
begin T := Self.ByteCount; end;

(*----------------------------------------------------------------------------*)
procedure TWKSRecordBitMap_R(Self: TWKSRecord; var T: Byte; const t1: integer);
begin T := Self.BitMap[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TWKSRecordProtocol_R(Self: TWKSRecord; var T: Word);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TWKSRecordAddress_R(Self: TWKSRecord; var T: String);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TRDATARecordIPAddress_R(Self: TRDATARecord; var T: string);
begin T := Self.IPAddress; end;

(*----------------------------------------------------------------------------*)
procedure TResultRecordRData_R(Self: TResultRecord; var T: String);
begin T := Self.RData; end;

(*----------------------------------------------------------------------------*)
procedure TResultRecordRDataLength_R(Self: TResultRecord; var T: Integer);
begin T := Self.RDataLength; end;

(*----------------------------------------------------------------------------*)
procedure TResultRecordTTL_R(Self: TResultRecord; var T: cardinal);
begin T := Self.TTL; end;

(*----------------------------------------------------------------------------*)
procedure TResultRecordName_R(Self: TResultRecord; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TResultRecordRecClass_R(Self: TResultRecord; var T: word);
begin T := Self.RecClass; end;

(*----------------------------------------------------------------------------*)
procedure TResultRecordRecType_R(Self: TResultRecord; var T: TQueryRecordTypes);
begin T := Self.RecType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdDNSResolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdDNSResolver) do begin
    RegisterConstructor(@TIdDNSResolver.Create, 'Create');
    RegisterMethod(@TIdDNSResolver.Destroy, 'Free');
    RegisterMethod(@TIdDNSResolver.Resolve, 'Resolve');
    RegisterPropertyHelper(@TIdDNSResolverQueryResult_R,nil,'QueryResult');
    RegisterPropertyHelper(@TIdDNSResolverQueryRecords_R,@TIdDNSResolverQueryRecords_W,'QueryRecords');
    RegisterPropertyHelper(@TIdDNSResolverAllowRecursiveQueries_R,@TIdDNSResolverAllowRecursiveQueries_W,'AllowRecursiveQueries');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDNSHeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDNSHeader) do begin
    RegisterConstructor(@TDNSHeader.Create, 'Create');
    RegisterMethod(@TDNSHeader.ClearByteCode, 'ClearByteCode');
    RegisterPropertyHelper(@TDNSHeaderID_R,@TDNSHeaderID_W,'ID');
    RegisterPropertyHelper(@TDNSHeaderQr_R,@TDNSHeaderQr_W,'Qr');
    RegisterPropertyHelper(@TDNSHeaderOpCode_R,@TDNSHeaderOpCode_W,'OpCode');
    RegisterPropertyHelper(@TDNSHeaderAA_R,@TDNSHeaderAA_W,'AA');
    RegisterPropertyHelper(@TDNSHeaderTC_R,@TDNSHeaderTC_W,'TC');
    RegisterPropertyHelper(@TDNSHeaderRD_R,@TDNSHeaderRD_W,'RD');
    RegisterPropertyHelper(@TDNSHeaderRA_R,@TDNSHeaderRA_W,'RA');
    RegisterPropertyHelper(@TDNSHeaderRCode_R,@TDNSHeaderRCode_W,'RCode');
    RegisterPropertyHelper(@TDNSHeaderBitCode_R,nil,'BitCode');
    RegisterPropertyHelper(@TDNSHeaderQDCount_R,@TDNSHeaderQDCount_W,'QDCount');
    RegisterPropertyHelper(@TDNSHeaderANCount_R,@TDNSHeaderANCount_W,'ANCount');
    RegisterPropertyHelper(@TDNSHeaderNSCount_R,@TDNSHeaderNSCount_W,'NSCount');
    RegisterPropertyHelper(@TDNSHeaderARCount_R,@TDNSHeaderARCount_W,'ARCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPTRRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPTRRecord) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TQueryResult(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TQueryResult) do
  begin
    RegisterConstructor(@TQueryResult.Create, 'Create');
    RegisterMethod(@TQueryResult.Add, 'Add');
    RegisterMethod(@TQueryResult.Clear, 'Clear');
    RegisterPropertyHelper(@TQueryResultQueryClass_R,nil,'QueryClass');
    RegisterPropertyHelper(@TQueryResultQueryType_R,nil,'QueryType');
    RegisterPropertyHelper(@TQueryResultDomainName_R,nil,'DomainName');
    RegisterPropertyHelper(@TQueryResultItems_R,@TQueryResultItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCNRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCNRecord) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNSRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNSRecord) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNAMERecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNAMERecord) do
  begin
    RegisterMethod(@TNAMERecord.Parse, 'Parse');
    RegisterPropertyHelper(@TNAMERecordHostName_R,nil,'HostName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSOARecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSOARecord) do
  begin
    RegisterMethod(@TSOARecord.Parse, 'Parse');
    RegisterPropertyHelper(@TSOARecordPrimary_R,nil,'Primary');
    RegisterPropertyHelper(@TSOARecordResponsiblePerson_R,nil,'ResponsiblePerson');
    RegisterPropertyHelper(@TSOARecordSerial_R,nil,'Serial');
    RegisterPropertyHelper(@TSOARecordRefresh_R,nil,'Refresh');
    RegisterPropertyHelper(@TSOARecordRetry_R,nil,'Retry');
    RegisterPropertyHelper(@TSOARecordExpire_R,nil,'Expire');
    RegisterPropertyHelper(@TSOARecordMinimumTTL_R,nil,'MinimumTTL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMINFORecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMINFORecord) do
  begin
    RegisterMethod(@TMINFORecord.Parse, 'Parse');
    RegisterPropertyHelper(@TMINFORecordResponsiblePersonMailbox_R,nil,'ResponsiblePersonMailbox');
    RegisterPropertyHelper(@TMINFORecordErrorMailbox_R,nil,'ErrorMailbox');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THINFORecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THINFORecord) do
  begin
    RegisterMethod(@THINFORecord.Parse, 'Parse');
    RegisterPropertyHelper(@THINFORecordCPU_R,nil,'CPU');
    RegisterPropertyHelper(@THINFORecordOS_R,nil,'OS');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextRecord) do
  begin
    RegisterConstructor(@TTextRecord.Create, 'Create');
    RegisterMethod(@TTextRecord.Parse, 'Parse');
    RegisterPropertyHelper(@TTextRecordText_R,nil,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMXRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMXRecord) do
  begin
    RegisterMethod(@TMXRecord.Parse, 'Parse');
    RegisterConstructor(@TMXRecord.Create, 'Create');
    RegisterMethod(@TMXRecord.Assign, 'Assign');
    RegisterPropertyHelper(@TMXRecordExchangeServer_R,nil,'ExchangeServer');
    RegisterPropertyHelper(@TMXRecordPreference_R,nil,'Preference');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWKSRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWKSRecord) do
  begin
    RegisterConstructor(@TWKSRecord.Create, 'Create');
    RegisterMethod(@TWKSRecord.Parse, 'Parse');
    RegisterPropertyHelper(@TWKSRecordAddress_R,nil,'Address');
    RegisterPropertyHelper(@TWKSRecordProtocol_R,nil,'Protocol');
    RegisterPropertyHelper(@TWKSRecordBitMap_R,nil,'BitMap');
    RegisterPropertyHelper(@TWKSRecordByteCount_R,nil,'ByteCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TARecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TARecord) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRDATARecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRDATARecord) do
  begin
    RegisterMethod(@TRDATARecord.Parse, 'Parse');
    RegisterConstructor(@TRDATARecord.Create, 'Create');
    RegisterMethod(@TRDATARecord.Assign, 'Assign');
    RegisterPropertyHelper(@TRDATARecordIPAddress_R,nil,'IPAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TResultRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResultRecord) do
  begin
    RegisterVirtualMethod(@TResultRecord.Parse, 'Parse');
    RegisterPropertyHelper(@TResultRecordRecType_R,nil,'RecType');
    RegisterPropertyHelper(@TResultRecordRecClass_R,nil,'RecClass');
    RegisterPropertyHelper(@TResultRecordName_R,nil,'Name');
    RegisterPropertyHelper(@TResultRecordTTL_R,nil,'TTL');
    RegisterPropertyHelper(@TResultRecordRDataLength_R,nil,'RDataLength');
    RegisterPropertyHelper(@TResultRecordRData_R,nil,'RData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdDNSResolver(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TResultRecord(CL);
  RIRegister_TRDATARecord(CL);
  RIRegister_TARecord(CL);
  RIRegister_TWKSRecord(CL);
  RIRegister_TMXRecord(CL);
  RIRegister_TTextRecord(CL);
  RIRegister_THINFORecord(CL);
  RIRegister_TMINFORecord(CL);
  RIRegister_TSOARecord(CL);
  RIRegister_TNAMERecord(CL);
  RIRegister_TNSRecord(CL);
  RIRegister_TCNRecord(CL);
  RIRegister_TQueryResult(CL);
  RIRegister_TPTRRecord(CL);
  RIRegister_TDNSHeader(CL);
  RIRegister_TIdDNSResolver(CL);
end;

 
 
{ TPSImport_IdDNSResolver }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDNSResolver.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdDNSResolver(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDNSResolver.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdDNSResolver(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
