unit uPSI_blcksock;
{
   synapse to synaclient  , sendbuffer
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
  TPSImport_blcksock = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 

{ compile-time registration functions }
procedure SIRegister_TSynaClient(CL: TPSPascalCompiler);
procedure SIRegister_TSSLNone(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSSL(CL: TPSPascalCompiler);
procedure SIRegister_TPGMStreamBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TPGMMessageBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TRAWBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TICMPBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TUDPBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TDgramBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TTCPBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TSocksBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TBlockSocket(CL: TPSPascalCompiler);
procedure SIRegister_TSynaOption(CL: TPSPascalCompiler);
procedure SIRegister_ESynapseError(CL: TPSPascalCompiler);
procedure SIRegister_blcksock(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynaClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSSLNone(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSSL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPGMStreamBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPGMMessageBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRAWBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TICMPBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TUDPBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDgramBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTCPBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSocksBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBlockSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynaOption(CL: TPSRuntimeClassImporter);
procedure RIRegister_ESynapseError(CL: TPSRuntimeClassImporter);
procedure RIRegister_blcksock(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   synafpc
  ,synsock
  ,synautil
  ,synacode
  ,synaip
  ,blcksock
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_blcksock]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynaClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynaClient') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynaClient') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterProperty('TargetHost', 'string', iptrw);
    RegisterProperty('TargetPort', 'string', iptrw);
    RegisterProperty('IPInterface', 'string', iptrw);
    RegisterProperty('Timeout', 'integer', iptrw);
    RegisterProperty('UserName', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSSLNone(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSSL', 'TSSLNone') do
  with CL.AddClassN(CL.FindClass('TCustomSSL'),'TSSLNone') do
  begin
    RegisterMethod('Function LibVersion : String');
    RegisterMethod('Function LibName : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSSL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomSSL') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCustomSSL') do begin
    RegisterMethod('Constructor Create( const Value : TTCPBlockSocket)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Assign( const Value : TCustomSSL)');
    RegisterMethod('Function LibVersion : String');
    RegisterMethod('Function LibName : String');
    RegisterMethod('Function Connect : boolean');
    RegisterMethod('Function Accept : boolean');
    RegisterMethod('Function Shutdown : boolean');
    RegisterMethod('Function BiShutdown : boolean');
    RegisterMethod('Function SendBuffer( Buffer : TMemory; Len : Integer) : Integer');
    RegisterMethod('Function RecvBuffer( Buffer : TMemory; Len : Integer) : Integer');
    RegisterMethod('Function WaitingData : Integer');
    RegisterMethod('Function GetSSLVersion : string');
    RegisterMethod('Function GetPeerSubject : string');
    RegisterMethod('Function GetPeerSerialNo : integer');
    RegisterMethod('Function GetPeerIssuer : string');
    RegisterMethod('Function GetPeerName : string');
    RegisterMethod('Function GetPeerNameHash : cardinal');
    RegisterMethod('Function GetPeerFingerprint : string');
    RegisterMethod('Function GetCertInfo : string');
    RegisterMethod('Function GetCipherName : string');
    RegisterMethod('Function GetCipherBits : integer');
    RegisterMethod('Function GetCipherAlgBits : integer');
    RegisterMethod('Function GetVerifyCert : integer');
    RegisterProperty('SSLEnabled', 'Boolean', iptr);
    RegisterProperty('LastError', 'integer', iptr);
    RegisterProperty('LastErrorDesc', 'string', iptr);
    RegisterProperty('SSLType', 'TSSLType', iptrw);
    RegisterProperty('KeyPassword', 'string', iptrw);
    RegisterProperty('Username', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('Ciphers', 'string', iptrw);
    RegisterProperty('CertificateFile', 'string', iptrw);
    RegisterProperty('PrivateKeyFile', 'string', iptrw);
    RegisterProperty('Certificate', 'Ansistring', iptrw);
    RegisterProperty('PrivateKey', 'Ansistring', iptrw);
    RegisterProperty('PFX', 'Ansistring', iptrw);
    RegisterProperty('PFXfile', 'string', iptrw);
    RegisterProperty('TrustCertificateFile', 'string', iptrw);
    RegisterProperty('TrustCertificate', 'Ansistring', iptrw);
    RegisterProperty('CertCA', 'Ansistring', iptrw);
    RegisterProperty('CertCAFile', 'string', iptrw);
    RegisterProperty('VerifyCert', 'Boolean', iptrw);
    RegisterProperty('SSHChannelType', 'string', iptrw);
    RegisterProperty('SSHChannelArg1', 'string', iptrw);
    RegisterProperty('SSHChannelArg2', 'string', iptrw);
    RegisterProperty('CertComplianceLevel', 'integer', iptrw);
    RegisterProperty('OnVerifyCert', 'THookVerifyCert', iptrw);
    RegisterProperty('SNIHost', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPGMStreamBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlockSocket', 'TPGMStreamBlockSocket') do
  with CL.AddClassN(CL.FindClass('TBlockSocket'),'TPGMStreamBlockSocket') do
  begin
    RegisterMethod('Function GetSocketType : integer');
    RegisterMethod('Function GetSocketProtocol : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPGMMessageBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlockSocket', 'TPGMMessageBlockSocket') do
  with CL.AddClassN(CL.FindClass('TBlockSocket'),'TPGMMessageBlockSocket') do
  begin
    RegisterMethod('Function GetSocketType : integer');
    RegisterMethod('Function GetSocketProtocol : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRAWBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlockSocket', 'TRAWBlockSocket') do
  with CL.AddClassN(CL.FindClass('TBlockSocket'),'TRAWBlockSocket') do
  begin
    RegisterMethod('Function GetSocketType : integer');
    RegisterMethod('Function GetSocketProtocol : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TICMPBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDgramBlockSocket', 'TICMPBlockSocket') do
  with CL.AddClassN(CL.FindClass('TDgramBlockSocket'),'TICMPBlockSocket') do
  begin
    RegisterMethod('Function GetSocketType : integer');
    RegisterMethod('Function GetSocketProtocol : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TUDPBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDgramBlockSocket', 'TUDPBlockSocket') do
  with CL.AddClassN(CL.FindClass('TDgramBlockSocket'),'TUDPBlockSocket') do begin
    RegisterMethod('Procedure EnableBroadcast( Value : Boolean)');
    RegisterMethod('Function SendBufferTo( Buffer : TMemory; Length : Integer) : Integer');
    RegisterMethod('Procedure AddMulticast( MCastIP : string)');
    RegisterMethod('Procedure DropMulticast( MCastIP : string)');
    RegisterMethod('Procedure EnableMulticastLoop( Value : Boolean)');
    RegisterMethod('Function GetSocketType : integer');
    RegisterMethod('Function GetSocketProtocol : integer');
    RegisterProperty('MulticastTTL', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDgramBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSocksBlockSocket', 'TDgramBlockSocket') do
  with CL.AddClassN(CL.FindClass('TSocksBlockSocket'),'TDgramBlockSocket') do
  begin
    RegisterMethod('Procedure Connect( IP, Port : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTCPBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSocksBlockSocket', 'TTCPBlockSocket') do
  with CL.AddClassN(CL.FindClass('TSocksBlockSocket'),'TTCPBlockSocket') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateWithSSL( SSLPlugin : TSSLClass)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CloseSocket');
    RegisterMethod('Function WaitingData : Integer');
    RegisterMethod('Procedure Listen');
    RegisterMethod('Function Accept : TSocket');
    RegisterMethod('Procedure Connect( IP, Port : string)');
    RegisterMethod('Procedure SSLDoConnect');
    RegisterMethod('Procedure SSLDoShutdown');
    RegisterMethod('Function SSLAcceptConnection : Boolean');
    RegisterMethod('Function GetLocalSinIP : string');
    RegisterMethod('Function GetRemoteSinIP : string');
    RegisterMethod('Function GetLocalSinPort : Integer');
    RegisterMethod('Function GetRemoteSinPort : Integer');
    RegisterMethod('Function SendBuffer( Buffer : TMemory; Length : Integer) : Integer');
    RegisterMethod('Function RecvBuffer( Buffer : TMemory; Len : Integer) : Integer');
    RegisterMethod('Function GetSocketType : integer');
    RegisterMethod('Function GetSocketProtocol : integer');
    RegisterProperty('SSL', 'TCustomSSL', iptr);
    RegisterProperty('HTTPTunnel', 'Boolean', iptr);
    RegisterMethod('Function GetErrorDescEx : string');
    RegisterProperty('HTTPTunnelIP', 'string', iptrw);
    RegisterProperty('HTTPTunnelPort', 'string', iptrw);
    RegisterProperty('HTTPTunnelUser', 'string', iptrw);
    RegisterProperty('HTTPTunnelPass', 'string', iptrw);
    RegisterProperty('HTTPTunnelTimeout', 'integer', iptrw);
    RegisterProperty('OnAfterConnect', 'THookAfterConnect', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSocksBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlockSocket', 'TSocksBlockSocket') do
  with CL.AddClassN(CL.FindClass('TBlockSocket'),'TSocksBlockSocket') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function SocksOpen : Boolean');
    RegisterMethod('Function SocksRequest( Cmd : Byte; const IP, Port : string) : Boolean');
    RegisterMethod('Function SocksResponse : Boolean');
    RegisterProperty('UsingSocks', 'Boolean', iptr);
    RegisterProperty('SocksLastError', 'integer', iptr);
    RegisterProperty('SocksIP', 'string', iptrw);
    RegisterProperty('SocksPort', 'string', iptrw);
    RegisterProperty('SocksUsername', 'string', iptrw);
    RegisterProperty('SocksPassword', 'string', iptrw);
    RegisterProperty('SocksTimeout', 'integer', iptrw);
    RegisterProperty('SocksResolver', 'Boolean', iptrw);
    RegisterProperty('SocksType', 'TSocksType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBlockSocket') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBlockSocket') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor CreateAlternate( Stub : string)');
    RegisterMethod('Procedure CreateSocket');
    RegisterMethod('Procedure CreateSocketByName( const Value : String)');
    RegisterMethod('Procedure CloseSocket');
    RegisterMethod('Procedure AbortSocket');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Bind( IP, Port : string)');
    RegisterMethod('Procedure Connect( IP, Port : string)');
    RegisterMethod('Procedure Listen');
    RegisterMethod('Function Accept : TSocket');
    RegisterMethod('Function SendBuffer( Buffer : Tmemory; Length : Integer) : Integer');
    RegisterMethod('Procedure SendByte( Data : Byte)');
    RegisterMethod('Procedure SendString( Data : AnsiString)');
    RegisterMethod('Procedure SendInteger( Data : integer)');
    RegisterMethod('Procedure SendBlock( const Data : AnsiString)');
    RegisterMethod('Procedure SendStreamRaw( const Stream : TStream)');
    RegisterMethod('Procedure SendStream( const Stream : TStream)');
    RegisterMethod('Procedure SendStreamIndy( const Stream : TStream)');
    RegisterMethod('Function RecvBuffer( Buffer : TMemory; Length : Integer) : Integer');
    RegisterMethod('Function RecvBufferEx( Buffer : Tmemory; Len : Integer; Timeout : Integer) : Integer');
    RegisterMethod('Function RecvBufferStr( Len : Integer; Timeout : Integer) : AnsiString');
    RegisterMethod('Function RecvByte( Timeout : Integer) : Byte');
    RegisterMethod('Function RecvInteger( Timeout : Integer) : Integer');
    RegisterMethod('Function RecvString( Timeout : Integer) : AnsiString');
    RegisterMethod('Function RecvTerminated( Timeout : Integer; const Terminator : AnsiString) : AnsiString');
    RegisterMethod('Function RecvPacket( Timeout : Integer) : AnsiString');
    RegisterMethod('Function RecvBlock( Timeout : Integer) : AnsiString');
    RegisterMethod('Procedure RecvStreamRaw( const Stream : TStream; Timeout : Integer)');
    RegisterMethod('Procedure RecvStreamSize( const Stream : TStream; Timeout : Integer; Size : Integer)');
    RegisterMethod('Procedure RecvStream( const Stream : TStream; Timeout : Integer)');
    RegisterMethod('Procedure RecvStreamIndy( const Stream : TStream; Timeout : Integer)');
    RegisterMethod('Function PeekBuffer( Buffer : TMemory; Length : Integer) : Integer');
    RegisterMethod('Function PeekByte( Timeout : Integer) : Byte');
    RegisterMethod('Function WaitingData : Integer');
    RegisterMethod('Function WaitingDataEx : Integer');
    RegisterMethod('Procedure Purge');
    RegisterMethod('Procedure SetLinger( Enable : Boolean; Linger : Integer)');
    RegisterMethod('Procedure GetSinLocal');
    RegisterMethod('Procedure GetSinRemote');
    RegisterMethod('Procedure GetSins');
    RegisterMethod('Procedure ResetLastError');
    RegisterMethod('Function SockCheck( SockResult : Integer) : Integer');
    RegisterMethod('Procedure ExceptCheck');
    RegisterMethod('Function LocalName : string');
    RegisterMethod('Procedure ResolveNameToIP( Name : string; const IPList : TStrings)');
    RegisterMethod('Function ResolveName( Name : string) : string');
    RegisterMethod('Function ResolveIPToName( IP : string) : string');
    RegisterMethod('Function ResolvePort( Port : string) : Word');
    RegisterMethod('Procedure SetRemoteSin( IP, Port : string)');
    RegisterMethod('Function GetLocalSinIP : string');
    RegisterMethod('Function GetRemoteSinIP : string');
    RegisterMethod('Function GetLocalSinPort : Integer');
    RegisterMethod('Function GetRemoteSinPort : Integer');
    RegisterMethod('Function CanRead( Timeout : Integer) : Boolean');
    RegisterMethod('Function CanReadEx( Timeout : Integer) : Boolean');
    RegisterMethod('Function CanWrite( Timeout : Integer) : Boolean');
    RegisterMethod('Function SendBufferTo( Buffer : TMemory; Length : Integer) : Integer');
    RegisterMethod('Function RecvBufferFrom( Buffer : TMemory; Length : Integer) : Integer');
    RegisterMethod('Function GroupCanRead( const SocketList : TList; Timeout : Integer; const CanReadList : TList) : Boolean');
    RegisterMethod('Procedure EnableReuse( Value : Boolean)');
    RegisterMethod('Procedure SetTimeout( Timeout : Integer)');
    RegisterMethod('Procedure SetSendTimeout( Timeout : Integer)');
    RegisterMethod('Procedure SetRecvTimeout( Timeout : Integer)');
    RegisterMethod('Function GetSocketType : integer');
    RegisterMethod('Function GetSocketProtocol : integer');
    RegisterProperty('WSAData', 'TWSADATA', iptr);
    RegisterProperty('FDset', 'TFDSet', iptr);
    RegisterProperty('LocalSin', 'TVarSin', iptrw);
    RegisterProperty('RemoteSin', 'TVarSin', iptrw);
    RegisterProperty('Socket', 'TSocket', iptrw);
    RegisterProperty('LastError', 'Integer', iptr);
    RegisterProperty('LastErrorDesc', 'string', iptr);
    RegisterProperty('LineBuffer', 'AnsiString', iptrw);
    RegisterProperty('SizeRecvBuffer', 'Integer', iptrw);
    RegisterProperty('SizeSendBuffer', 'Integer', iptrw);
    RegisterProperty('NonBlockMode', 'Boolean', iptrw);
    RegisterProperty('TTL', 'Integer', iptrw);
    RegisterProperty('IP6used', 'Boolean', iptr);
    RegisterProperty('RecvCounter', 'Integer', iptr);
    RegisterProperty('SendCounter', 'Integer', iptr);
    RegisterMethod('Function GetErrorDesc( ErrorCode : Integer) : string');
    RegisterMethod('Function GetErrorDescEx : string');
    RegisterProperty('Tag', 'Integer', iptrw);
    RegisterProperty('RaiseExcept', 'Boolean', iptrw);
    RegisterProperty('MaxLineLength', 'Integer', iptrw);
    RegisterProperty('MaxSendBandwidth', 'Integer', iptrw);
    RegisterProperty('MaxRecvBandwidth', 'Integer', iptrw);
    RegisterProperty('MaxBandwidth', 'Integer', iptw);
    RegisterProperty('ConvertLineEnd', 'Boolean', iptrw);
    RegisterProperty('Family', 'TSocketFamily', iptrw);
    RegisterProperty('PreferIP4', 'Boolean', iptrw);
    RegisterProperty('InterPacketTimeout', 'Boolean', iptrw);
    RegisterProperty('SendMaxChunk', 'Integer', iptrw);
    RegisterProperty('StopFlag', 'Boolean', iptrw);
    RegisterProperty('NonblockSendTimeout', 'Integer', iptrw);
    RegisterProperty('OnStatus', 'THookSocketStatus', iptrw);
    RegisterProperty('OnReadFilter', 'THookDataFilter', iptrw);
    RegisterProperty('OnCreateSocket', 'THookCreateSocket', iptrw);
    RegisterProperty('OnMonitor', 'THookMonitor', iptrw);
    RegisterProperty('OnHeartbeat', 'THookHeartbeat', iptrw);
    RegisterProperty('HeartbeatRate', 'integer', iptrw);
    RegisterProperty('Owner', 'TObject', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynaOption(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynaOption') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynaOption') do
  begin
    RegisterProperty('Option', 'TSynaOptionType', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Value', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ESynapseError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ESynapseError') do
  with CL.AddClassN(CL.FindClass('Exception'),'ESynapseError') do
  begin
    RegisterProperty('ErrorCode', 'Integer', iptrw);
    RegisterProperty('ErrorMessage', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_blcksock(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SynapseRelease','String').SetString( '38');
 CL.AddConstantN('cLocalhost','String').SetString( '127.0.0.1');
 CL.AddConstantN('cAnyHost','String').SetString( '0.0.0.0');
 CL.AddConstantN('cBroadcast','String').SetString( '255.255.255.255');
 CL.AddConstantN('c6Localhost','String').SetString( '::1');
 CL.AddConstantN('c6AnyHost','String').SetString( '::0');
 CL.AddConstantN('c6Broadcast','String').SetString( 'ffff::1');
 CL.AddConstantN('cAnyPort','String').SetString( '0');
 CL.AddConstantN('synCR','Char').SetString( #$0d);
 CL.AddConstantN('synLF','Char').SetString( #$0a);
 CL.AddConstantN('c64k','LongInt').SetInt( 65536);
  SIRegister_ESynapseError(CL);
  CL.AddTypeS('THookSocketReason', '( HR_ResolvingBegin, HR_ResolvingEnd, HR_So'
   +'cketCreate, HR_SocketClose, HR_Bind, HR_Connect, HR_CanRead, HR_CanWrite, '
   +'HR_Listen, HR_Accept, HR_ReadCount, HR_WriteCount, HR_Wait, HR_Error )');
  CL.AddTypeS('THookSocketStatus', 'Procedure ( Sender : TObject; Reason : THoo'
   +'kSocketReason; const Value : String)');
  CL.AddTypeS('THookDataFilter', 'Procedure ( Sender : TObject; var Value : AnsiString)');
  CL.AddTypeS('THookCreateSocket', 'Procedure ( Sender : TObject)');
  //CL.AddTypeS('THookMonitor', 'Procedure ( Sender : TObject; Writing : Boolean;'
   //+' const Buffer : TMemory; Len : Integer)');
  CL.AddTypeS('THookMonitor', 'Procedure ( Sender : TObject; Writing : Boolean;'
   +' const Buffer : TObject; Len : Integer)');
  //CL.AddTypeS('TMemory', 'TMemoryStream');
  CL.AddTypeS('TMemory', 'TObject');

    // orig TMemory = pointer;

  CL.AddTypeS('THookAfterConnect', 'Procedure ( Sender : TObject)');
  CL.AddTypeS('THookVerifyCert', 'Function ( Sender : TObject) : boolean');
  CL.AddTypeS('THookHeartbeat', 'Procedure ( Sender : TObject)');
  CL.AddTypeS('TSocketFamily', '( SF_Any, SF_IP4, SF_IP6 )');
  CL.AddTypeS('TSocksType', '( ST_Socks5, ST_Socks4 )');
  CL.AddTypeS('TSSLType', '( LT_all, LT_SSLv2, LT_SSLv3, LT_TLSv1, LT_TLSv1_1, LT_SSHv2 )');
  CL.AddTypeS('TSynaOptionType', '( SOT_Linger, SOT_RecvBuff, SOT_SendBuff, SOT'
   +'_NonBlock, SOT_RecvTimeout, SOT_SendTimeout, SOT_Reuse, SOT_TTL, SOT_Broad'
   +'cast, SOT_MulticastTTL, SOT_MulticastLoop )');
  SIRegister_TSynaOption(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomSSL');                //find befire
  //CL.AddTypeS('TSSLClass', 'class of TCustomSSL');
  CL.AddTypeS('TSSLClass', 'TCustomSSL');

  SIRegister_TBlockSocket(CL);
  SIRegister_TSocksBlockSocket(CL);
  SIRegister_TTCPBlockSocket(CL);
  SIRegister_TDgramBlockSocket(CL);
  SIRegister_TUDPBlockSocket(CL);
  SIRegister_TICMPBlockSocket(CL);
  SIRegister_TRAWBlockSocket(CL);
  SIRegister_TPGMMessageBlockSocket(CL);
  SIRegister_TPGMStreamBlockSocket(CL);
  SIRegister_TCustomSSL(CL);
  SIRegister_TSSLNone(CL);
  CL.AddTypeS('TIPHeader', 'record VerLen : Byte; TOS : Byte; TotalLen : Word; '
   +'Identifer : Word; FragOffsets : Word; TTL : Byte; Protocol : Byte; CheckSu'
   +'m : Word; SourceIp : LongWord; DestIp : LongWord; Options : LongWord; end');
  SIRegister_TSynaClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynaClientPassword_W(Self: TSynaClient; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientPassword_R(Self: TSynaClient; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientUserName_W(Self: TSynaClient; const T: string);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientUserName_R(Self: TSynaClient; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientTimeout_W(Self: TSynaClient; const T: integer);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientTimeout_R(Self: TSynaClient; var T: integer);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientIPInterface_W(Self: TSynaClient; const T: string);
begin Self.IPInterface := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientIPInterface_R(Self: TSynaClient; var T: string);
begin T := Self.IPInterface; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientTargetPort_W(Self: TSynaClient; const T: string);
begin Self.TargetPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientTargetPort_R(Self: TSynaClient; var T: string);
begin T := Self.TargetPort; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientTargetHost_W(Self: TSynaClient; const T: string);
begin Self.TargetHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaClientTargetHost_R(Self: TSynaClient; var T: string);
begin T := Self.TargetHost; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSNIHost_W(Self: TCustomSSL; const T: string);
begin Self.SNIHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSNIHost_R(Self: TCustomSSL; var T: string);
begin T := Self.SNIHost; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLOnVerifyCert_W(Self: TCustomSSL; const T: THookVerifyCert);
begin Self.OnVerifyCert := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLOnVerifyCert_R(Self: TCustomSSL; var T: THookVerifyCert);
begin T := Self.OnVerifyCert; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertComplianceLevel_W(Self: TCustomSSL; const T: integer);
begin Self.CertComplianceLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertComplianceLevel_R(Self: TCustomSSL; var T: integer);
begin T := Self.CertComplianceLevel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSHChannelArg2_W(Self: TCustomSSL; const T: string);
begin Self.SSHChannelArg2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSHChannelArg2_R(Self: TCustomSSL; var T: string);
begin T := Self.SSHChannelArg2; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSHChannelArg1_W(Self: TCustomSSL; const T: string);
begin Self.SSHChannelArg1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSHChannelArg1_R(Self: TCustomSSL; var T: string);
begin T := Self.SSHChannelArg1; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSHChannelType_W(Self: TCustomSSL; const T: string);
begin Self.SSHChannelType := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSHChannelType_R(Self: TCustomSSL; var T: string);
begin T := Self.SSHChannelType; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLVerifyCert_W(Self: TCustomSSL; const T: Boolean);
begin Self.VerifyCert := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLVerifyCert_R(Self: TCustomSSL; var T: Boolean);
begin T := Self.VerifyCert; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertCAFile_W(Self: TCustomSSL; const T: string);
begin Self.CertCAFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertCAFile_R(Self: TCustomSSL; var T: string);
begin T := Self.CertCAFile; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertCA_W(Self: TCustomSSL; const T: Ansistring);
begin Self.CertCA := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertCA_R(Self: TCustomSSL; var T: Ansistring);
begin T := Self.CertCA; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLTrustCertificate_W(Self: TCustomSSL; const T: Ansistring);
begin Self.TrustCertificate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLTrustCertificate_R(Self: TCustomSSL; var T: Ansistring);
begin T := Self.TrustCertificate; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLTrustCertificateFile_W(Self: TCustomSSL; const T: string);
begin Self.TrustCertificateFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLTrustCertificateFile_R(Self: TCustomSSL; var T: string);
begin T := Self.TrustCertificateFile; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPFXfile_W(Self: TCustomSSL; const T: string);
begin Self.PFXfile := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPFXfile_R(Self: TCustomSSL; var T: string);
begin T := Self.PFXfile; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPFX_W(Self: TCustomSSL; const T: Ansistring);
begin Self.PFX := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPFX_R(Self: TCustomSSL; var T: Ansistring);
begin T := Self.PFX; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPrivateKey_W(Self: TCustomSSL; const T: Ansistring);
begin Self.PrivateKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPrivateKey_R(Self: TCustomSSL; var T: Ansistring);
begin T := Self.PrivateKey; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertificate_W(Self: TCustomSSL; const T: Ansistring);
begin Self.Certificate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertificate_R(Self: TCustomSSL; var T: Ansistring);
begin T := Self.Certificate; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPrivateKeyFile_W(Self: TCustomSSL; const T: string);
begin Self.PrivateKeyFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPrivateKeyFile_R(Self: TCustomSSL; var T: string);
begin T := Self.PrivateKeyFile; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertificateFile_W(Self: TCustomSSL; const T: string);
begin Self.CertificateFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCertificateFile_R(Self: TCustomSSL; var T: string);
begin T := Self.CertificateFile; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCiphers_W(Self: TCustomSSL; const T: string);
begin Self.Ciphers := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLCiphers_R(Self: TCustomSSL; var T: string);
begin T := Self.Ciphers; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPassword_W(Self: TCustomSSL; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLPassword_R(Self: TCustomSSL; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLUsername_W(Self: TCustomSSL; const T: string);
begin Self.Username := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLUsername_R(Self: TCustomSSL; var T: string);
begin T := Self.Username; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLKeyPassword_W(Self: TCustomSSL; const T: string);
begin Self.KeyPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLKeyPassword_R(Self: TCustomSSL; var T: string);
begin T := Self.KeyPassword; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSLType_W(Self: TCustomSSL; const T: TSSLType);
begin Self.SSLType := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSLType_R(Self: TCustomSSL; var T: TSSLType);
begin T := Self.SSLType; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLLastErrorDesc_R(Self: TCustomSSL; var T: string);
begin T := Self.LastErrorDesc; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLLastError_R(Self: TCustomSSL; var T: integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSSLSSLEnabled_R(Self: TCustomSSL; var T: Boolean);
begin T := Self.SSLEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TUDPBlockSocketMulticastTTL_W(Self: TUDPBlockSocket; const T: Integer);
begin Self.MulticastTTL := T; end;

(*----------------------------------------------------------------------------*)
procedure TUDPBlockSocketMulticastTTL_R(Self: TUDPBlockSocket; var T: Integer);
begin T := Self.MulticastTTL; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketOnAfterConnect_W(Self: TTCPBlockSocket; const T: THookAfterConnect);
begin Self.OnAfterConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketOnAfterConnect_R(Self: TTCPBlockSocket; var T: THookAfterConnect);
begin T := Self.OnAfterConnect; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelTimeout_W(Self: TTCPBlockSocket; const T: integer);
begin Self.HTTPTunnelTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelTimeout_R(Self: TTCPBlockSocket; var T: integer);
begin T := Self.HTTPTunnelTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelPass_W(Self: TTCPBlockSocket; const T: string);
begin Self.HTTPTunnelPass := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelPass_R(Self: TTCPBlockSocket; var T: string);
begin T := Self.HTTPTunnelPass; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelUser_W(Self: TTCPBlockSocket; const T: string);
begin Self.HTTPTunnelUser := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelUser_R(Self: TTCPBlockSocket; var T: string);
begin T := Self.HTTPTunnelUser; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelPort_W(Self: TTCPBlockSocket; const T: string);
begin Self.HTTPTunnelPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelPort_R(Self: TTCPBlockSocket; var T: string);
begin T := Self.HTTPTunnelPort; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelIP_W(Self: TTCPBlockSocket; const T: string);
begin Self.HTTPTunnelIP := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnelIP_R(Self: TTCPBlockSocket; var T: string);
begin T := Self.HTTPTunnelIP; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketHTTPTunnel_R(Self: TTCPBlockSocket; var T: Boolean);
begin T := Self.HTTPTunnel; end;

(*----------------------------------------------------------------------------*)
procedure TTCPBlockSocketSSL_R(Self: TTCPBlockSocket; var T: TCustomSSL);
begin T := Self.SSL; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksType_W(Self: TSocksBlockSocket; const T: TSocksType);
begin Self.SocksType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksType_R(Self: TSocksBlockSocket; var T: TSocksType);
begin T := Self.SocksType; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksResolver_W(Self: TSocksBlockSocket; const T: Boolean);
begin Self.SocksResolver := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksResolver_R(Self: TSocksBlockSocket; var T: Boolean);
begin T := Self.SocksResolver; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksTimeout_W(Self: TSocksBlockSocket; const T: integer);
begin Self.SocksTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksTimeout_R(Self: TSocksBlockSocket; var T: integer);
begin T := Self.SocksTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksPassword_W(Self: TSocksBlockSocket; const T: string);
begin Self.SocksPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksPassword_R(Self: TSocksBlockSocket; var T: string);
begin T := Self.SocksPassword; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksUsername_W(Self: TSocksBlockSocket; const T: string);
begin Self.SocksUsername := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksUsername_R(Self: TSocksBlockSocket; var T: string);
begin T := Self.SocksUsername; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksPort_W(Self: TSocksBlockSocket; const T: string);
begin Self.SocksPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksPort_R(Self: TSocksBlockSocket; var T: string);
begin T := Self.SocksPort; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksIP_W(Self: TSocksBlockSocket; const T: string);
begin Self.SocksIP := T; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksIP_R(Self: TSocksBlockSocket; var T: string);
begin T := Self.SocksIP; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketSocksLastError_R(Self: TSocksBlockSocket; var T: integer);
begin T := Self.SocksLastError; end;

(*----------------------------------------------------------------------------*)
procedure TSocksBlockSocketUsingSocks_R(Self: TSocksBlockSocket; var T: Boolean);
begin T := Self.UsingSocks; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOwner_W(Self: TBlockSocket; const T: TObject);
begin Self.Owner := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOwner_R(Self: TBlockSocket; var T: TObject);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketHeartbeatRate_W(Self: TBlockSocket; const T: integer);
begin Self.HeartbeatRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketHeartbeatRate_R(Self: TBlockSocket; var T: integer);
begin T := Self.HeartbeatRate; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnHeartbeat_W(Self: TBlockSocket; const T: THookHeartbeat);
begin Self.OnHeartbeat := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnHeartbeat_R(Self: TBlockSocket; var T: THookHeartbeat);
begin T := Self.OnHeartbeat; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnMonitor_W(Self: TBlockSocket; const T: THookMonitor);
begin Self.OnMonitor := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnMonitor_R(Self: TBlockSocket; var T: THookMonitor);
begin T := Self.OnMonitor; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnCreateSocket_W(Self: TBlockSocket; const T: THookCreateSocket);
begin Self.OnCreateSocket := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnCreateSocket_R(Self: TBlockSocket; var T: THookCreateSocket);
begin T := Self.OnCreateSocket; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnReadFilter_W(Self: TBlockSocket; const T: THookDataFilter);
begin Self.OnReadFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnReadFilter_R(Self: TBlockSocket; var T: THookDataFilter);
begin T := Self.OnReadFilter; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnStatus_W(Self: TBlockSocket; const T: THookSocketStatus);
begin Self.OnStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketOnStatus_R(Self: TBlockSocket; var T: THookSocketStatus);
begin T := Self.OnStatus; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketNonblockSendTimeout_W(Self: TBlockSocket; const T: Integer);
begin Self.NonblockSendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketNonblockSendTimeout_R(Self: TBlockSocket; var T: Integer);
begin T := Self.NonblockSendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketStopFlag_W(Self: TBlockSocket; const T: Boolean);
begin Self.StopFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketStopFlag_R(Self: TBlockSocket; var T: Boolean);
begin T := Self.StopFlag; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSendMaxChunk_W(Self: TBlockSocket; const T: Integer);
begin Self.SendMaxChunk := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSendMaxChunk_R(Self: TBlockSocket; var T: Integer);
begin T := Self.SendMaxChunk; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketInterPacketTimeout_W(Self: TBlockSocket; const T: Boolean);
begin Self.InterPacketTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketInterPacketTimeout_R(Self: TBlockSocket; var T: Boolean);
begin T := Self.InterPacketTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketPreferIP4_W(Self: TBlockSocket; const T: Boolean);
begin Self.PreferIP4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketPreferIP4_R(Self: TBlockSocket; var T: Boolean);
begin T := Self.PreferIP4; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketFamily_W(Self: TBlockSocket; const T: TSocketFamily);
begin Self.Family := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketFamily_R(Self: TBlockSocket; var T: TSocketFamily);
begin T := Self.Family; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketConvertLineEnd_W(Self: TBlockSocket; const T: Boolean);
begin Self.ConvertLineEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketConvertLineEnd_R(Self: TBlockSocket; var T: Boolean);
begin T := Self.ConvertLineEnd; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketMaxBandwidth_W(Self: TBlockSocket; const T: Integer);
begin Self.MaxBandwidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketMaxRecvBandwidth_W(Self: TBlockSocket; const T: Integer);
begin Self.MaxRecvBandwidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketMaxRecvBandwidth_R(Self: TBlockSocket; var T: Integer);
begin T := Self.MaxRecvBandwidth; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketMaxSendBandwidth_W(Self: TBlockSocket; const T: Integer);
begin Self.MaxSendBandwidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketMaxSendBandwidth_R(Self: TBlockSocket; var T: Integer);
begin T := Self.MaxSendBandwidth; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketMaxLineLength_W(Self: TBlockSocket; const T: Integer);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketMaxLineLength_R(Self: TBlockSocket; var T: Integer);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketRaiseExcept_W(Self: TBlockSocket; const T: Boolean);
begin Self.RaiseExcept := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketRaiseExcept_R(Self: TBlockSocket; var T: Boolean);
begin T := Self.RaiseExcept; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketTag_W(Self: TBlockSocket; const T: Integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketTag_R(Self: TBlockSocket; var T: Integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSendCounter_R(Self: TBlockSocket; var T: Integer);
begin T := Self.SendCounter; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketRecvCounter_R(Self: TBlockSocket; var T: Integer);
begin T := Self.RecvCounter; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketIP6used_R(Self: TBlockSocket; var T: Boolean);
begin T := Self.IP6used; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketTTL_W(Self: TBlockSocket; const T: Integer);
begin Self.TTL := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketTTL_R(Self: TBlockSocket; var T: Integer);
begin T := Self.TTL; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketNonBlockMode_W(Self: TBlockSocket; const T: Boolean);
begin Self.NonBlockMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketNonBlockMode_R(Self: TBlockSocket; var T: Boolean);
begin T := Self.NonBlockMode; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSizeSendBuffer_W(Self: TBlockSocket; const T: Integer);
begin Self.SizeSendBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSizeSendBuffer_R(Self: TBlockSocket; var T: Integer);
begin T := Self.SizeSendBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSizeRecvBuffer_W(Self: TBlockSocket; const T: Integer);
begin Self.SizeRecvBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSizeRecvBuffer_R(Self: TBlockSocket; var T: Integer);
begin T := Self.SizeRecvBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketLineBuffer_W(Self: TBlockSocket; const T: AnsiString);
begin Self.LineBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketLineBuffer_R(Self: TBlockSocket; var T: AnsiString);
begin T := Self.LineBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketLastErrorDesc_R(Self: TBlockSocket; var T: string);
begin T := Self.LastErrorDesc; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketLastError_R(Self: TBlockSocket; var T: Integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSocket_W(Self: TBlockSocket; const T: TSocket);
begin Self.Socket := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketSocket_R(Self: TBlockSocket; var T: TSocket);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketRemoteSin_W(Self: TBlockSocket; const T: TVarSin);
begin Self.RemoteSin := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketRemoteSin_R(Self: TBlockSocket; var T: TVarSin);
begin T := Self.RemoteSin; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketLocalSin_W(Self: TBlockSocket; const T: TVarSin);
begin Self.LocalSin := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketLocalSin_R(Self: TBlockSocket; var T: TVarSin);
begin T := Self.LocalSin; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketFDset_R(Self: TBlockSocket; var T: TFDSet);
begin T := Self.FDset; end;

(*----------------------------------------------------------------------------*)
procedure TBlockSocketWSAData_R(Self: TBlockSocket; var T: TWSADATA);
begin T := Self.WSAData; end;

(*----------------------------------------------------------------------------*)
procedure TSynaOptionValue_W(Self: TSynaOption; const T: Integer);
Begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaOptionValue_R(Self: TSynaOption; var T: Integer);
Begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TSynaOptionEnabled_W(Self: TSynaOption; const T: Boolean);
Begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaOptionEnabled_R(Self: TSynaOption; var T: Boolean);
Begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TSynaOptionOption_W(Self: TSynaOption; const T: TSynaOptionType);
Begin Self.Option := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynaOptionOption_R(Self: TSynaOption; var T: TSynaOptionType);
Begin T := Self.Option; end;

(*----------------------------------------------------------------------------*)
procedure ESynapseErrorErrorMessage_W(Self: ESynapseError; const T: string);
begin Self.ErrorMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure ESynapseErrorErrorMessage_R(Self: ESynapseError; var T: string);
begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure ESynapseErrorErrorCode_W(Self: ESynapseError; const T: Integer);
begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure ESynapseErrorErrorCode_R(Self: ESynapseError; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynaClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynaClient) do
  begin
    RegisterConstructor(@TSynaClient.Create, 'Create');
      RegisterMethod(@TSynaClient.Destroy, 'Free');
     RegisterPropertyHelper(@TSynaClientTargetHost_R,@TSynaClientTargetHost_W,'TargetHost');
    RegisterPropertyHelper(@TSynaClientTargetPort_R,@TSynaClientTargetPort_W,'TargetPort');
    RegisterPropertyHelper(@TSynaClientIPInterface_R,@TSynaClientIPInterface_W,'IPInterface');
    RegisterPropertyHelper(@TSynaClientTimeout_R,@TSynaClientTimeout_W,'Timeout');
    RegisterPropertyHelper(@TSynaClientUserName_R,@TSynaClientUserName_W,'UserName');
    RegisterPropertyHelper(@TSynaClientPassword_R,@TSynaClientPassword_W,'Password');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSSLNone(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSSLNone) do
  begin
    RegisterMethod(@TSSLNone.LibVersion, 'LibVersion');
    RegisterMethod(@TSSLNone.LibName, 'LibName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSSL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSSL) do begin
    RegisterVirtualConstructor(@TCustomSSL.Create, 'Create');
      RegisterMethod(@TCustomSSL.Destroy, 'Free');
      RegisterVirtualMethod(@TCustomSSL.Assign, 'Assign');
    RegisterVirtualMethod(@TCustomSSL.LibVersion, 'LibVersion');
    RegisterVirtualMethod(@TCustomSSL.LibName, 'LibName');
    RegisterVirtualMethod(@TCustomSSL.Connect, 'Connect');
    RegisterVirtualMethod(@TCustomSSL.Accept, 'Accept');
    RegisterVirtualMethod(@TCustomSSL.Shutdown, 'Shutdown');
    RegisterVirtualMethod(@TCustomSSL.BiShutdown, 'BiShutdown');
    RegisterVirtualMethod(@TCustomSSL.SendBuffer, 'SendBuffer');
    RegisterVirtualMethod(@TCustomSSL.RecvBuffer, 'RecvBuffer');
    RegisterVirtualMethod(@TCustomSSL.WaitingData, 'WaitingData');
    RegisterVirtualMethod(@TCustomSSL.GetSSLVersion, 'GetSSLVersion');
    RegisterVirtualMethod(@TCustomSSL.GetPeerSubject, 'GetPeerSubject');
    RegisterVirtualMethod(@TCustomSSL.GetPeerSerialNo, 'GetPeerSerialNo');
    RegisterVirtualMethod(@TCustomSSL.GetPeerIssuer, 'GetPeerIssuer');
    RegisterVirtualMethod(@TCustomSSL.GetPeerName, 'GetPeerName');
    RegisterVirtualMethod(@TCustomSSL.GetPeerNameHash, 'GetPeerNameHash');
    RegisterVirtualMethod(@TCustomSSL.GetPeerFingerprint, 'GetPeerFingerprint');
    RegisterVirtualMethod(@TCustomSSL.GetCertInfo, 'GetCertInfo');
    RegisterVirtualMethod(@TCustomSSL.GetCipherName, 'GetCipherName');
    RegisterVirtualMethod(@TCustomSSL.GetCipherBits, 'GetCipherBits');
    RegisterVirtualMethod(@TCustomSSL.GetCipherAlgBits, 'GetCipherAlgBits');
    RegisterVirtualMethod(@TCustomSSL.GetVerifyCert, 'GetVerifyCert');
    RegisterPropertyHelper(@TCustomSSLSSLEnabled_R,nil,'SSLEnabled');
    RegisterPropertyHelper(@TCustomSSLLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TCustomSSLLastErrorDesc_R,nil,'LastErrorDesc');
    RegisterPropertyHelper(@TCustomSSLSSLType_R,@TCustomSSLSSLType_W,'SSLType');
    RegisterPropertyHelper(@TCustomSSLKeyPassword_R,@TCustomSSLKeyPassword_W,'KeyPassword');
    RegisterPropertyHelper(@TCustomSSLUsername_R,@TCustomSSLUsername_W,'Username');
    RegisterPropertyHelper(@TCustomSSLPassword_R,@TCustomSSLPassword_W,'Password');
    RegisterPropertyHelper(@TCustomSSLCiphers_R,@TCustomSSLCiphers_W,'Ciphers');
    RegisterPropertyHelper(@TCustomSSLCertificateFile_R,@TCustomSSLCertificateFile_W,'CertificateFile');
    RegisterPropertyHelper(@TCustomSSLPrivateKeyFile_R,@TCustomSSLPrivateKeyFile_W,'PrivateKeyFile');
    RegisterPropertyHelper(@TCustomSSLCertificate_R,@TCustomSSLCertificate_W,'Certificate');
    RegisterPropertyHelper(@TCustomSSLPrivateKey_R,@TCustomSSLPrivateKey_W,'PrivateKey');
    RegisterPropertyHelper(@TCustomSSLPFX_R,@TCustomSSLPFX_W,'PFX');
    RegisterPropertyHelper(@TCustomSSLPFXfile_R,@TCustomSSLPFXfile_W,'PFXfile');
    RegisterPropertyHelper(@TCustomSSLTrustCertificateFile_R,@TCustomSSLTrustCertificateFile_W,'TrustCertificateFile');
    RegisterPropertyHelper(@TCustomSSLTrustCertificate_R,@TCustomSSLTrustCertificate_W,'TrustCertificate');
    RegisterPropertyHelper(@TCustomSSLCertCA_R,@TCustomSSLCertCA_W,'CertCA');
    RegisterPropertyHelper(@TCustomSSLCertCAFile_R,@TCustomSSLCertCAFile_W,'CertCAFile');
    RegisterPropertyHelper(@TCustomSSLVerifyCert_R,@TCustomSSLVerifyCert_W,'VerifyCert');
    RegisterPropertyHelper(@TCustomSSLSSHChannelType_R,@TCustomSSLSSHChannelType_W,'SSHChannelType');
    RegisterPropertyHelper(@TCustomSSLSSHChannelArg1_R,@TCustomSSLSSHChannelArg1_W,'SSHChannelArg1');
    RegisterPropertyHelper(@TCustomSSLSSHChannelArg2_R,@TCustomSSLSSHChannelArg2_W,'SSHChannelArg2');
    RegisterPropertyHelper(@TCustomSSLCertComplianceLevel_R,@TCustomSSLCertComplianceLevel_W,'CertComplianceLevel');
    RegisterPropertyHelper(@TCustomSSLOnVerifyCert_R,@TCustomSSLOnVerifyCert_W,'OnVerifyCert');
    RegisterPropertyHelper(@TCustomSSLSNIHost_R,@TCustomSSLSNIHost_W,'SNIHost');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPGMStreamBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPGMStreamBlockSocket) do
  begin
    RegisterMethod(@TPGMStreamBlockSocket.GetSocketType, 'GetSocketType');
    RegisterMethod(@TPGMStreamBlockSocket.GetSocketProtocol, 'GetSocketProtocol');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPGMMessageBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPGMMessageBlockSocket) do
  begin
    RegisterMethod(@TPGMMessageBlockSocket.GetSocketType, 'GetSocketType');
    RegisterMethod(@TPGMMessageBlockSocket.GetSocketProtocol, 'GetSocketProtocol');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRAWBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRAWBlockSocket) do
  begin
    RegisterMethod(@TRAWBlockSocket.GetSocketType, 'GetSocketType');
    RegisterMethod(@TRAWBlockSocket.GetSocketProtocol, 'GetSocketProtocol');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TICMPBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TICMPBlockSocket) do
  begin
    RegisterMethod(@TICMPBlockSocket.GetSocketType, 'GetSocketType');
    RegisterMethod(@TICMPBlockSocket.GetSocketProtocol, 'GetSocketProtocol');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUDPBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUDPBlockSocket) do begin
    RegisterMethod(@TUDPBlockSocket.EnableBroadcast, 'EnableBroadcast');
    RegisterMethod(@TUDPBlockSocket.SendBufferTo, 'SendBufferTo');
    RegisterMethod(@TUDPBlockSocket.AddMulticast, 'AddMulticast');
    RegisterMethod(@TUDPBlockSocket.DropMulticast, 'DropMulticast');
    RegisterMethod(@TUDPBlockSocket.EnableMulticastLoop, 'EnableMulticastLoop');
    RegisterMethod(@TUDPBlockSocket.GetSocketType, 'GetSocketType');
    RegisterMethod(@TUDPBlockSocket.GetSocketProtocol, 'GetSocketProtocol');
    RegisterPropertyHelper(@TUDPBlockSocketMulticastTTL_R,@TUDPBlockSocketMulticastTTL_W,'MulticastTTL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDgramBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDgramBlockSocket) do
  begin
    RegisterMethod(@TDgramBlockSocket.Connect, 'Connect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTCPBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTCPBlockSocket) do begin
    RegisterConstructor(@TTCPBlockSocket.Create, 'Create');
      RegisterMethod(@TTCPBlockSocket.Destroy, 'Free');
      RegisterConstructor(@TTCPBlockSocket.CreateWithSSL, 'CreateWithSSL');
    RegisterMethod(@TTCPBlockSocket.CloseSocket, 'CloseSocket');
    RegisterMethod(@TTCPBlockSocket.WaitingData, 'WaitingData');
    RegisterMethod(@TTCPBlockSocket.Listen, 'Listen');
    RegisterMethod(@TTCPBlockSocket.Accept, 'Accept');
    RegisterMethod(@TTCPBlockSocket.Connect, 'Connect');
    RegisterMethod(@TTCPBlockSocket.SSLDoConnect, 'SSLDoConnect');
    RegisterMethod(@TTCPBlockSocket.SSLDoShutdown, 'SSLDoShutdown');
    RegisterMethod(@TTCPBlockSocket.SSLAcceptConnection, 'SSLAcceptConnection');
    RegisterMethod(@TTCPBlockSocket.GetLocalSinIP, 'GetLocalSinIP');
    RegisterMethod(@TTCPBlockSocket.GetRemoteSinIP, 'GetRemoteSinIP');
    RegisterMethod(@TTCPBlockSocket.GetLocalSinPort, 'GetLocalSinPort');
    RegisterMethod(@TTCPBlockSocket.GetRemoteSinPort, 'GetRemoteSinPort');
    RegisterMethod(@TTCPBlockSocket.SendBuffer, 'SendBuffer');
    RegisterMethod(@TTCPBlockSocket.RecvBuffer, 'RecvBuffer');
    RegisterMethod(@TTCPBlockSocket.GetSocketType, 'GetSocketType');
    RegisterMethod(@TTCPBlockSocket.GetSocketProtocol, 'GetSocketProtocol');
    RegisterPropertyHelper(@TTCPBlockSocketSSL_R,nil,'SSL');
    RegisterPropertyHelper(@TTCPBlockSocketHTTPTunnel_R,nil,'HTTPTunnel');
    RegisterMethod(@TTCPBlockSocket.GetErrorDescEx, 'GetErrorDescEx');
    RegisterPropertyHelper(@TTCPBlockSocketHTTPTunnelIP_R,@TTCPBlockSocketHTTPTunnelIP_W,'HTTPTunnelIP');
    RegisterPropertyHelper(@TTCPBlockSocketHTTPTunnelPort_R,@TTCPBlockSocketHTTPTunnelPort_W,'HTTPTunnelPort');
    RegisterPropertyHelper(@TTCPBlockSocketHTTPTunnelUser_R,@TTCPBlockSocketHTTPTunnelUser_W,'HTTPTunnelUser');
    RegisterPropertyHelper(@TTCPBlockSocketHTTPTunnelPass_R,@TTCPBlockSocketHTTPTunnelPass_W,'HTTPTunnelPass');
    RegisterPropertyHelper(@TTCPBlockSocketHTTPTunnelTimeout_R,@TTCPBlockSocketHTTPTunnelTimeout_W,'HTTPTunnelTimeout');
    RegisterPropertyHelper(@TTCPBlockSocketOnAfterConnect_R,@TTCPBlockSocketOnAfterConnect_W,'OnAfterConnect');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSocksBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSocksBlockSocket) do begin
    RegisterConstructor(@TSocksBlockSocket.Create, 'Create');
      RegisterMethod(@TSocksBlockSocket.Destroy, 'Free');
      RegisterMethod(@TSocksBlockSocket.SocksOpen, 'SocksOpen');
    RegisterMethod(@TSocksBlockSocket.SocksRequest, 'SocksRequest');
    RegisterMethod(@TSocksBlockSocket.SocksResponse, 'SocksResponse');
    RegisterPropertyHelper(@TSocksBlockSocketUsingSocks_R,nil,'UsingSocks');
    RegisterPropertyHelper(@TSocksBlockSocketSocksLastError_R,nil,'SocksLastError');
    RegisterPropertyHelper(@TSocksBlockSocketSocksIP_R,@TSocksBlockSocketSocksIP_W,'SocksIP');
    RegisterPropertyHelper(@TSocksBlockSocketSocksPort_R,@TSocksBlockSocketSocksPort_W,'SocksPort');
    RegisterPropertyHelper(@TSocksBlockSocketSocksUsername_R,@TSocksBlockSocketSocksUsername_W,'SocksUsername');
    RegisterPropertyHelper(@TSocksBlockSocketSocksPassword_R,@TSocksBlockSocketSocksPassword_W,'SocksPassword');
    RegisterPropertyHelper(@TSocksBlockSocketSocksTimeout_R,@TSocksBlockSocketSocksTimeout_W,'SocksTimeout');
    RegisterPropertyHelper(@TSocksBlockSocketSocksResolver_R,@TSocksBlockSocketSocksResolver_W,'SocksResolver');
    RegisterPropertyHelper(@TSocksBlockSocketSocksType_R,@TSocksBlockSocketSocksType_W,'SocksType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockSocket) do begin
    RegisterConstructor(@TBlockSocket.Create, 'Create');
      RegisterMethod(@TBlockSocket.Destroy, 'Free');
      RegisterConstructor(@TBlockSocket.CreateAlternate, 'CreateAlternate');
    RegisterMethod(@TBlockSocket.CreateSocket, 'CreateSocket');
    RegisterMethod(@TBlockSocket.CreateSocketByName, 'CreateSocketByName');
    RegisterVirtualMethod(@TBlockSocket.CloseSocket, 'CloseSocket');
    RegisterVirtualMethod(@TBlockSocket.AbortSocket, 'AbortSocket');
    RegisterMethod(@TBlockSocket.Bind, 'Bind');
    RegisterVirtualMethod(@TBlockSocket.Connect, 'Connect');
    RegisterVirtualMethod(@TBlockSocket.Listen, 'Listen');
    RegisterVirtualMethod(@TBlockSocket.Accept, 'Accept');
    RegisterVirtualMethod(@TBlockSocket.SendBuffer, 'SendBuffer');
    RegisterVirtualMethod(@TBlockSocket.SendByte, 'SendByte');
    RegisterVirtualMethod(@TBlockSocket.SendString, 'SendString');
    RegisterVirtualMethod(@TBlockSocket.SendInteger, 'SendInteger');
    RegisterVirtualMethod(@TBlockSocket.SendBlock, 'SendBlock');
    RegisterVirtualMethod(@TBlockSocket.SendStreamRaw, 'SendStreamRaw');
    RegisterVirtualMethod(@TBlockSocket.SendStream, 'SendStream');
    RegisterVirtualMethod(@TBlockSocket.SendStreamIndy, 'SendStreamIndy');
    RegisterVirtualMethod(@TBlockSocket.RecvBuffer, 'RecvBuffer');
    RegisterVirtualMethod(@TBlockSocket.RecvBufferEx, 'RecvBufferEx');
    RegisterVirtualMethod(@TBlockSocket.RecvBufferStr, 'RecvBufferStr');
    RegisterVirtualMethod(@TBlockSocket.RecvByte, 'RecvByte');
    RegisterVirtualMethod(@TBlockSocket.RecvInteger, 'RecvInteger');
    RegisterVirtualMethod(@TBlockSocket.RecvString, 'RecvString');
    RegisterVirtualMethod(@TBlockSocket.RecvTerminated, 'RecvTerminated');
    RegisterVirtualMethod(@TBlockSocket.RecvPacket, 'RecvPacket');
    RegisterVirtualMethod(@TBlockSocket.RecvBlock, 'RecvBlock');
    RegisterVirtualMethod(@TBlockSocket.RecvStreamRaw, 'RecvStreamRaw');
    RegisterMethod(@TBlockSocket.RecvStreamSize, 'RecvStreamSize');
    RegisterVirtualMethod(@TBlockSocket.RecvStream, 'RecvStream');
    RegisterVirtualMethod(@TBlockSocket.RecvStreamIndy, 'RecvStreamIndy');
    RegisterVirtualMethod(@TBlockSocket.PeekBuffer, 'PeekBuffer');
    RegisterVirtualMethod(@TBlockSocket.PeekByte, 'PeekByte');
    RegisterVirtualMethod(@TBlockSocket.WaitingData, 'WaitingData');
    RegisterMethod(@TBlockSocket.WaitingDataEx, 'WaitingDataEx');
    RegisterMethod(@TBlockSocket.Purge, 'Purge');
    RegisterMethod(@TBlockSocket.SetLinger, 'SetLinger');
    RegisterMethod(@TBlockSocket.GetSinLocal, 'GetSinLocal');
    RegisterMethod(@TBlockSocket.GetSinRemote, 'GetSinRemote');
    RegisterMethod(@TBlockSocket.GetSins, 'GetSins');
    RegisterMethod(@TBlockSocket.ResetLastError, 'ResetLastError');
    RegisterVirtualMethod(@TBlockSocket.SockCheck, 'SockCheck');
    RegisterMethod(@TBlockSocket.ExceptCheck, 'ExceptCheck');
    RegisterMethod(@TBlockSocket.LocalName, 'LocalName');
    RegisterMethod(@TBlockSocket.ResolveNameToIP, 'ResolveNameToIP');
    RegisterMethod(@TBlockSocket.ResolveName, 'ResolveName');
    RegisterMethod(@TBlockSocket.ResolveIPToName, 'ResolveIPToName');
    RegisterMethod(@TBlockSocket.ResolvePort, 'ResolvePort');
    RegisterMethod(@TBlockSocket.SetRemoteSin, 'SetRemoteSin');
    RegisterVirtualMethod(@TBlockSocket.GetLocalSinIP, 'GetLocalSinIP');
    RegisterVirtualMethod(@TBlockSocket.GetRemoteSinIP, 'GetRemoteSinIP');
    RegisterVirtualMethod(@TBlockSocket.GetLocalSinPort, 'GetLocalSinPort');
    RegisterVirtualMethod(@TBlockSocket.GetRemoteSinPort, 'GetRemoteSinPort');
    RegisterVirtualMethod(@TBlockSocket.CanRead, 'CanRead');
    RegisterVirtualMethod(@TBlockSocket.CanReadEx, 'CanReadEx');
    RegisterVirtualMethod(@TBlockSocket.CanWrite, 'CanWrite');
    RegisterVirtualMethod(@TBlockSocket.SendBufferTo, 'SendBufferTo');
    RegisterVirtualMethod(@TBlockSocket.RecvBufferFrom, 'RecvBufferFrom');
    RegisterMethod(@TBlockSocket.GroupCanRead, 'GroupCanRead');
    RegisterMethod(@TBlockSocket.EnableReuse, 'EnableReuse');
    RegisterMethod(@TBlockSocket.SetTimeout, 'SetTimeout');
    RegisterMethod(@TBlockSocket.SetSendTimeout, 'SetSendTimeout');
    RegisterMethod(@TBlockSocket.SetRecvTimeout, 'SetRecvTimeout');
    RegisterVirtualMethod(@TBlockSocket.GetSocketType, 'GetSocketType');
    RegisterVirtualMethod(@TBlockSocket.GetSocketProtocol, 'GetSocketProtocol');
    RegisterPropertyHelper(@TBlockSocketWSAData_R,nil,'WSAData');
    RegisterPropertyHelper(@TBlockSocketFDset_R,nil,'FDset');
    RegisterPropertyHelper(@TBlockSocketLocalSin_R,@TBlockSocketLocalSin_W,'LocalSin');
    RegisterPropertyHelper(@TBlockSocketRemoteSin_R,@TBlockSocketRemoteSin_W,'RemoteSin');
    RegisterPropertyHelper(@TBlockSocketSocket_R,@TBlockSocketSocket_W,'Socket');
    RegisterPropertyHelper(@TBlockSocketLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TBlockSocketLastErrorDesc_R,nil,'LastErrorDesc');
    RegisterPropertyHelper(@TBlockSocketLineBuffer_R,@TBlockSocketLineBuffer_W,'LineBuffer');
    RegisterPropertyHelper(@TBlockSocketSizeRecvBuffer_R,@TBlockSocketSizeRecvBuffer_W,'SizeRecvBuffer');
    RegisterPropertyHelper(@TBlockSocketSizeSendBuffer_R,@TBlockSocketSizeSendBuffer_W,'SizeSendBuffer');
    RegisterPropertyHelper(@TBlockSocketNonBlockMode_R,@TBlockSocketNonBlockMode_W,'NonBlockMode');
    RegisterPropertyHelper(@TBlockSocketTTL_R,@TBlockSocketTTL_W,'TTL');
    RegisterPropertyHelper(@TBlockSocketIP6used_R,nil,'IP6used');
    RegisterPropertyHelper(@TBlockSocketRecvCounter_R,nil,'RecvCounter');
    RegisterPropertyHelper(@TBlockSocketSendCounter_R,nil,'SendCounter');
    RegisterMethod(@TBlockSocket.GetErrorDesc, 'GetErrorDesc');
    RegisterVirtualMethod(@TBlockSocket.GetErrorDescEx, 'GetErrorDescEx');
    RegisterPropertyHelper(@TBlockSocketTag_R,@TBlockSocketTag_W,'Tag');
    RegisterPropertyHelper(@TBlockSocketRaiseExcept_R,@TBlockSocketRaiseExcept_W,'RaiseExcept');
    RegisterPropertyHelper(@TBlockSocketMaxLineLength_R,@TBlockSocketMaxLineLength_W,'MaxLineLength');
    RegisterPropertyHelper(@TBlockSocketMaxSendBandwidth_R,@TBlockSocketMaxSendBandwidth_W,'MaxSendBandwidth');
    RegisterPropertyHelper(@TBlockSocketMaxRecvBandwidth_R,@TBlockSocketMaxRecvBandwidth_W,'MaxRecvBandwidth');
    RegisterPropertyHelper(nil,@TBlockSocketMaxBandwidth_W,'MaxBandwidth');
    RegisterPropertyHelper(@TBlockSocketConvertLineEnd_R,@TBlockSocketConvertLineEnd_W,'ConvertLineEnd');
    RegisterPropertyHelper(@TBlockSocketFamily_R,@TBlockSocketFamily_W,'Family');
    RegisterPropertyHelper(@TBlockSocketPreferIP4_R,@TBlockSocketPreferIP4_W,'PreferIP4');
    RegisterPropertyHelper(@TBlockSocketInterPacketTimeout_R,@TBlockSocketInterPacketTimeout_W,'InterPacketTimeout');
    RegisterPropertyHelper(@TBlockSocketSendMaxChunk_R,@TBlockSocketSendMaxChunk_W,'SendMaxChunk');
    RegisterPropertyHelper(@TBlockSocketStopFlag_R,@TBlockSocketStopFlag_W,'StopFlag');
    RegisterPropertyHelper(@TBlockSocketNonblockSendTimeout_R,@TBlockSocketNonblockSendTimeout_W,'NonblockSendTimeout');
    RegisterPropertyHelper(@TBlockSocketOnStatus_R,@TBlockSocketOnStatus_W,'OnStatus');
    RegisterPropertyHelper(@TBlockSocketOnReadFilter_R,@TBlockSocketOnReadFilter_W,'OnReadFilter');
    RegisterPropertyHelper(@TBlockSocketOnCreateSocket_R,@TBlockSocketOnCreateSocket_W,'OnCreateSocket');
    RegisterPropertyHelper(@TBlockSocketOnMonitor_R,@TBlockSocketOnMonitor_W,'OnMonitor');
    RegisterPropertyHelper(@TBlockSocketOnHeartbeat_R,@TBlockSocketOnHeartbeat_W,'OnHeartbeat');
    RegisterPropertyHelper(@TBlockSocketHeartbeatRate_R,@TBlockSocketHeartbeatRate_W,'HeartbeatRate');
    RegisterPropertyHelper(@TBlockSocketOwner_R,@TBlockSocketOwner_W,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynaOption(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynaOption) do
  begin
    RegisterPropertyHelper(@TSynaOptionOption_R,@TSynaOptionOption_W,'Option');
    RegisterPropertyHelper(@TSynaOptionEnabled_R,@TSynaOptionEnabled_W,'Enabled');
    RegisterPropertyHelper(@TSynaOptionValue_R,@TSynaOptionValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ESynapseError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESynapseError) do
  begin
    RegisterPropertyHelper(@ESynapseErrorErrorCode_R,@ESynapseErrorErrorCode_W,'ErrorCode');
    RegisterPropertyHelper(@ESynapseErrorErrorMessage_R,@ESynapseErrorErrorMessage_W,'ErrorMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_blcksock(CL: TPSRuntimeClassImporter);
begin
  RIRegister_ESynapseError(CL);
  RIRegister_TSynaOption(CL);
  with CL.Add(TCustomSSL) do
  RIRegister_TBlockSocket(CL);
  RIRegister_TSocksBlockSocket(CL);
  RIRegister_TTCPBlockSocket(CL);
  RIRegister_TDgramBlockSocket(CL);
  RIRegister_TUDPBlockSocket(CL);
  RIRegister_TICMPBlockSocket(CL);
  RIRegister_TRAWBlockSocket(CL);
  RIRegister_TPGMMessageBlockSocket(CL);
  RIRegister_TPGMStreamBlockSocket(CL);
  RIRegister_TCustomSSL(CL);
  RIRegister_TSSLNone(CL);
  RIRegister_TSynaClient(CL);
end;

 
 
{ TPSImport_blcksock }
(*----------------------------------------------------------------------------*)
procedure TPSImport_blcksock.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_blcksock(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_blcksock.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_blcksock(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
