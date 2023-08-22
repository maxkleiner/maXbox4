unit uPSI_AdSocket;
{
   just to alternate
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
  TPSImport_AdSocket = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TApdSocket(CL: TPSPascalCompiler);
procedure SIRegister_EApdSocketException(CL: TPSPascalCompiler);
procedure SIRegister_AdSocket(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TApdSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_EApdSocketException(CL: TPSRuntimeClassImporter);
procedure RIRegister_AdSocket(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Messages
  ,Forms
  ,OOMisc
  ,AdWUtil
  ,AdSocket
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AdSocket]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TApdSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TApdSocket') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TApdSocket') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CheckLoaded');
    RegisterMethod('Function htonl( HostLong : LongInt) : LongInt');
    RegisterMethod('Function htons( HostShort : Word) : Word');
    RegisterMethod('Function ntohl( NetLong : LongInt) : LongInt');
    RegisterMethod('Function ntohs( NetShort : Word) : Word');
    RegisterMethod('Function NetAddr2String( InAddr : TInAddr) : string');
    RegisterMethod('Function String2NetAddr( const S : string) : TInAddr');
    RegisterMethod('Function LookupAddress( InAddr : TInAddr) : string');
    RegisterMethod('Function LookupName( const Name : string) : TInAddr');
    RegisterMethod('Function LookupPort( Port : Word) : string');
    RegisterMethod('Function LookupService( const Service : string) : Integer');
    RegisterMethod('Function AcceptSocket( Socket : TSocket; var Address : TSockAddrIn) : TSocket');
    RegisterMethod('Function BindSocket( Socket : TSocket; Address : TSockAddrIn) : Integer');
    RegisterMethod('Function CanReadSocket( Socket : TSocket; WaitTime : Longint) : Boolean');
    RegisterMethod('Function CanWriteSocket( Socket : TSocket; WaitTime : Longint) : Boolean');
    RegisterMethod('Function CloseSocket( Socket : TSocket) : Integer');
    RegisterMethod('Function ConnectSocket( Socket : TSocket; Address : TSockAddrIn) : Integer');
    RegisterMethod('Function CreateSocket : TSocket');
    RegisterMethod('Function ListenSocket( Socket : TSocket; Backlog : Integer) : Integer');
    RegisterMethod('Function ReadSocket( Socket : TSocket; var Buf, BufSize, Flags : Integer) : Integer');
    RegisterMethod('Function ShutdownSocket( Socket : TSocket; How : Integer) : Integer');
    RegisterMethod('Function SetSocketOptions( Socket : TSocket; Level : Cardinal; OptName : Integer; var OptVal, OptLen : Integer) : Integer');
    RegisterMethod('Function SetAsyncStyles( Socket : TSocket; lEvent : LongInt) : Integer');
    RegisterMethod('Function WriteSocket( Socket : TSocket; var Buf, BufSize, Flags : Integer) : Integer');
    RegisterProperty('Description', 'string', iptr);
    RegisterProperty('Handle', 'HWnd', iptr);
    RegisterProperty('HighVersion', 'Word', iptr);
    RegisterProperty('LastError', 'Integer', iptr);
    RegisterProperty('LocalHost', 'string', iptr);
    RegisterProperty('LocalAddress', 'string', iptr);
    RegisterProperty('MaxSockets', 'Word', iptr);
    RegisterProperty('SystemStatus', 'string', iptr);
    RegisterProperty('WsVersion', 'Word', iptr);
    RegisterProperty('OnWsAccept', 'TWsNotifyEvent', iptrw);
    RegisterProperty('OnWsConnect', 'TWsNotifyEvent', iptrw);
    RegisterProperty('OnWsDisconnect', 'TWsNotifyEvent', iptrw);
    RegisterProperty('OnWsError', 'TWsSocketErrorEvent', iptrw);
    RegisterProperty('OnWsRead', 'TWsNotifyEvent', iptrw);
    RegisterProperty('OnWsWrite', 'TWsNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EApdSocketException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EApdSocketException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EApdSocketException') do
  begin
    RegisterProperty('ErrorCode', 'Integer', iptrw);
    RegisterMethod('Constructor CreateNoInit( ErrCode : Integer; Dummy : PChar)');
    RegisterMethod('Constructor CreateTranslate( ErrCode, Dummy1, Dummy2 : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AdSocket(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IPStrSize','LongInt').SetInt( 15);
 CL.AddConstantN('CM_APDSOCKETMESSAGE','LongWord').SetUInt( WM_USER + $0711);
 CL.AddConstantN('CM_APDSOCKETQUIT','LongWord').SetUInt( WM_USER + $0712);
 CL.AddConstantN('ADWSBASE','LongInt').SetInt( 9000);
  CL.AddTypeS('TCMAPDSocketMessage', 'record Msg : Cardinal; Socket : TSocket; '
   +'SelectEvent : Word; SelectError : Word; Result : Longint; end');
  SIRegister_EApdSocketException(CL);
  CL.AddTypeS('TWsMode', '( wsClient, wsServer )');
  CL.AddTypeS('TWsNotifyEvent', 'Procedure ( Sender : TObject; Socket : TSocket)');
  CL.AddTypeS('TWsSocketErrorEvent', 'Procedure ( Sender : TObject; Socket : TSocket; ErrCode : Integer)');
  SIRegister_TApdSocket(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsWrite_W(Self: TApdSocket; const T: TWsNotifyEvent);
begin Self.OnWsWrite := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsWrite_R(Self: TApdSocket; var T: TWsNotifyEvent);
begin T := Self.OnWsWrite; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsRead_W(Self: TApdSocket; const T: TWsNotifyEvent);
begin Self.OnWsRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsRead_R(Self: TApdSocket; var T: TWsNotifyEvent);
begin T := Self.OnWsRead; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsError_W(Self: TApdSocket; const T: TWsSocketErrorEvent);
begin Self.OnWsError := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsError_R(Self: TApdSocket; var T: TWsSocketErrorEvent);
begin T := Self.OnWsError; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsDisconnect_W(Self: TApdSocket; const T: TWsNotifyEvent);
begin Self.OnWsDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsDisconnect_R(Self: TApdSocket; var T: TWsNotifyEvent);
begin T := Self.OnWsDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsConnect_W(Self: TApdSocket; const T: TWsNotifyEvent);
begin Self.OnWsConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsConnect_R(Self: TApdSocket; var T: TWsNotifyEvent);
begin T := Self.OnWsConnect; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsAccept_W(Self: TApdSocket; const T: TWsNotifyEvent);
begin Self.OnWsAccept := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketOnWsAccept_R(Self: TApdSocket; var T: TWsNotifyEvent);
begin T := Self.OnWsAccept; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketWsVersion_R(Self: TApdSocket; var T: Word);
begin T := Self.WsVersion; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketSystemStatus_R(Self: TApdSocket; var T: string);
begin T := Self.SystemStatus; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketMaxSockets_R(Self: TApdSocket; var T: Word);
begin T := Self.MaxSockets; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketLocalAddress_R(Self: TApdSocket; var T: string);
begin T := Self.LocalAddress; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketLocalHost_R(Self: TApdSocket; var T: string);
begin T := Self.LocalHost; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketLastError_R(Self: TApdSocket; var T: Integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketHighVersion_R(Self: TApdSocket; var T: Word);
begin T := Self.HighVersion; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketHandle_R(Self: TApdSocket; var T: HWnd);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TApdSocketDescription_R(Self: TApdSocket; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure EApdSocketExceptionErrorCode_W(Self: EApdSocketException; const T: Integer);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EApdSocketExceptionErrorCode_R(Self: EApdSocketException; var T: Integer);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApdSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdSocket) do begin
    RegisterConstructor(@TApdSocket.Create, 'Create');
      RegisterMethod(@TApdSocket.Destroy, 'Free');
      RegisterMethod(@TApdSocket.CheckLoaded, 'CheckLoaded');
    RegisterMethod(@TApdSocket.htonl, 'htonl');
    RegisterMethod(@TApdSocket.htons, 'htons');
    RegisterMethod(@TApdSocket.ntohl, 'ntohl');
    RegisterMethod(@TApdSocket.ntohs, 'ntohs');
    RegisterMethod(@TApdSocket.NetAddr2String, 'NetAddr2String');
    RegisterMethod(@TApdSocket.String2NetAddr, 'String2NetAddr');
    RegisterMethod(@TApdSocket.LookupAddress, 'LookupAddress');
    RegisterMethod(@TApdSocket.LookupName, 'LookupName');
    RegisterMethod(@TApdSocket.LookupPort, 'LookupPort');
    RegisterMethod(@TApdSocket.LookupService, 'LookupService');
    RegisterMethod(@TApdSocket.AcceptSocket, 'AcceptSocket');
    RegisterMethod(@TApdSocket.BindSocket, 'BindSocket');
    RegisterMethod(@TApdSocket.CanReadSocket, 'CanReadSocket');
    RegisterMethod(@TApdSocket.CanWriteSocket, 'CanWriteSocket');
    RegisterMethod(@TApdSocket.CloseSocket, 'CloseSocket');
    RegisterMethod(@TApdSocket.ConnectSocket, 'ConnectSocket');
    RegisterMethod(@TApdSocket.CreateSocket, 'CreateSocket');
    RegisterMethod(@TApdSocket.ListenSocket, 'ListenSocket');
    RegisterMethod(@TApdSocket.ReadSocket, 'ReadSocket');
    RegisterMethod(@TApdSocket.ShutdownSocket, 'ShutdownSocket');
    RegisterMethod(@TApdSocket.SetSocketOptions, 'SetSocketOptions');
    RegisterMethod(@TApdSocket.SetAsyncStyles, 'SetAsyncStyles');
    RegisterMethod(@TApdSocket.WriteSocket, 'WriteSocket');
    RegisterPropertyHelper(@TApdSocketDescription_R,nil,'Description');
    RegisterPropertyHelper(@TApdSocketHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TApdSocketHighVersion_R,nil,'HighVersion');
    RegisterPropertyHelper(@TApdSocketLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TApdSocketLocalHost_R,nil,'LocalHost');
    RegisterPropertyHelper(@TApdSocketLocalAddress_R,nil,'LocalAddress');
    RegisterPropertyHelper(@TApdSocketMaxSockets_R,nil,'MaxSockets');
    RegisterPropertyHelper(@TApdSocketSystemStatus_R,nil,'SystemStatus');
    RegisterPropertyHelper(@TApdSocketWsVersion_R,nil,'WsVersion');
    RegisterPropertyHelper(@TApdSocketOnWsAccept_R,@TApdSocketOnWsAccept_W,'OnWsAccept');
    RegisterPropertyHelper(@TApdSocketOnWsConnect_R,@TApdSocketOnWsConnect_W,'OnWsConnect');
    RegisterPropertyHelper(@TApdSocketOnWsDisconnect_R,@TApdSocketOnWsDisconnect_W,'OnWsDisconnect');
    RegisterPropertyHelper(@TApdSocketOnWsError_R,@TApdSocketOnWsError_W,'OnWsError');
    RegisterPropertyHelper(@TApdSocketOnWsRead_R,@TApdSocketOnWsRead_W,'OnWsRead');
    RegisterPropertyHelper(@TApdSocketOnWsWrite_R,@TApdSocketOnWsWrite_W,'OnWsWrite');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EApdSocketException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EApdSocketException) do
  begin
    RegisterPropertyHelper(@EApdSocketExceptionErrorCode_R,@EApdSocketExceptionErrorCode_W,'ErrorCode');
    RegisterConstructor(@EApdSocketException.CreateNoInit, 'CreateNoInit');
    RegisterConstructor(@EApdSocketException.CreateTranslate, 'CreateTranslate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AdSocket(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EApdSocketException(CL);
  RIRegister_TApdSocket(CL);
end;

 
 
{ TPSImport_AdSocket }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdSocket.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AdSocket(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdSocket.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AdSocket(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
