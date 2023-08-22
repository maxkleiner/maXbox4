unit uPSI_IdMappedFTP;
{
  for SQL FTP
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
  TPSImport_IdMappedFTP = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdMappedFTP(CL: TPSPascalCompiler);
procedure SIRegister_TIdMappedFtpDataThread(CL: TPSPascalCompiler);
procedure SIRegister_TIdMappedFtpThread(CL: TPSPascalCompiler);
procedure SIRegister_IdMappedFTP(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdMappedFTP(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMappedFtpDataThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMappedFtpThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdMappedFTP(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdTCPServer
  ,IdMappedPortTCP
  ,IdAssignedNumbers
  ,IdThread
  ,IdTCPConnection
  ,IdMappedFTP
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMappedFTP]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedFTP(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMappedPortTCP', 'TIdMappedFTP') do
  with CL.AddClassN(CL.FindClass('TIdMappedPortTCP'),'TIdMappedFTP') do begin
  registerPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('OutboundDcMode', 'TIdMappedFtpOutboundDcMode', iptrw);
    RegisterProperty('DefaultPort', 'integer', iptr);
    RegisterProperty('MappedPort', 'integer', iptr);
   // property DefaultPort default IdPORT_FTP;
   // property MappedPort default IdPORT_FTP;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedFtpDataThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThread', 'TIdMappedFtpDataThread') do
  with CL.AddClassN(CL.FindClass('TIdThread'),'TIdMappedFtpDataThread') do begin
    RegisterMethod('Constructor Create( AMappedFtpThread : TIdMappedFtpThread)');
    RegisterProperty('MappedFtpThread', 'TIdMappedFtpThread', iptr);
    RegisterProperty('Connection', 'TIdTcpConnection', iptr);
    RegisterProperty('OutboundClient', 'TIdTCPConnection', iptr);
    RegisterProperty('NetData', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMappedFtpThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdMappedPortThread', 'TIdMappedFtpThread') do
  with CL.AddClassN(CL.FindClass('TIdMappedPortThread'),'TIdMappedFtpThread') do begin
    RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
    RegisterProperty('FtpCommand', 'string', iptrw);
    RegisterProperty('FtpParams', 'string', iptrw);
    RegisterProperty('FtpCmdLine', 'string', iptr);
    RegisterProperty('Host', 'string', iptrw);
    RegisterProperty('OutboundHost', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('OutboundPort', 'Integer', iptrw);
    RegisterProperty('DataChannelThread', 'TIdMappedFtpDataThread', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMappedFTP(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdMappedFtpDataThread');
  SIRegister_TIdMappedFtpThread(CL);
  SIRegister_TIdMappedFtpDataThread(CL);
  CL.AddTypeS('TIdMappedFtpOutboundDcMode', '( fdcmClient, fdcmPort, fdcmPasv )');
  SIRegister_TIdMappedFTP(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMappedFTPOutboundDcMode_W(Self: TIdMappedFTP; const T: TIdMappedFtpOutboundDcMode);
begin Self.OutboundDcMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFTPOutboundDcMode_R(Self: TIdMappedFTP; var T: TIdMappedFtpOutboundDcMode);
begin T := Self.OutboundDcMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpDataThreadNetData_W(Self: TIdMappedFtpDataThread; const T: string);
begin Self.NetData := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpDataThreadNetData_R(Self: TIdMappedFtpDataThread; var T: string);
begin T := Self.NetData; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpDataThreadOutboundClient_R(Self: TIdMappedFtpDataThread; var T: TIdTCPConnection);
begin T := Self.OutboundClient; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpDataThreadConnection_R(Self: TIdMappedFtpDataThread; var T: TIdTcpConnection);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpDataThreadMappedFtpThread_R(Self: TIdMappedFtpDataThread; var T: TIdMappedFtpThread);
begin T := Self.MappedFtpThread; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadDataChannelThread_R(Self: TIdMappedFtpThread; var T: TIdMappedFtpDataThread);
begin T := Self.DataChannelThread; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadOutboundPort_W(Self: TIdMappedFtpThread; const T: Integer);
begin Self.OutboundPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadOutboundPort_R(Self: TIdMappedFtpThread; var T: Integer);
begin T := Self.OutboundPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadPort_W(Self: TIdMappedFtpThread; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadPort_R(Self: TIdMappedFtpThread; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadOutboundHost_W(Self: TIdMappedFtpThread; const T: string);
begin Self.OutboundHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadOutboundHost_R(Self: TIdMappedFtpThread; var T: string);
begin T := Self.OutboundHost; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadHost_W(Self: TIdMappedFtpThread; const T: string);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadHost_R(Self: TIdMappedFtpThread; var T: string);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadFtpCmdLine_R(Self: TIdMappedFtpThread; var T: string);
begin T := Self.FtpCmdLine; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadFtpParams_W(Self: TIdMappedFtpThread; const T: string);
begin Self.FtpParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadFtpParams_R(Self: TIdMappedFtpThread; var T: string);
begin T := Self.FtpParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadFtpCommand_W(Self: TIdMappedFtpThread; const T: string);
begin Self.FtpCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMappedFtpThreadFtpCommand_R(Self: TIdMappedFtpThread; var T: string);
begin T := Self.FtpCommand; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedFTP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedFTP) do
  begin
    RegisterConstructor(@TIdMappedFTP.Create, 'Create');
    RegisterPropertyHelper(@TIdMappedFTPOutboundDcMode_R,@TIdMappedFTPOutboundDcMode_W,'OutboundDcMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedFtpDataThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedFtpDataThread) do
  begin
    RegisterConstructor(@TIdMappedFtpDataThread.Create, 'Create');
    RegisterPropertyHelper(@TIdMappedFtpDataThreadMappedFtpThread_R,nil,'MappedFtpThread');
    RegisterPropertyHelper(@TIdMappedFtpDataThreadConnection_R,nil,'Connection');
    RegisterPropertyHelper(@TIdMappedFtpDataThreadOutboundClient_R,nil,'OutboundClient');
    RegisterPropertyHelper(@TIdMappedFtpDataThreadNetData_R,@TIdMappedFtpDataThreadNetData_W,'NetData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMappedFtpThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedFtpThread) do
  begin
    RegisterConstructor(@TIdMappedFtpThread.Create, 'Create');
    RegisterPropertyHelper(@TIdMappedFtpThreadFtpCommand_R,@TIdMappedFtpThreadFtpCommand_W,'FtpCommand');
    RegisterPropertyHelper(@TIdMappedFtpThreadFtpParams_R,@TIdMappedFtpThreadFtpParams_W,'FtpParams');
    RegisterPropertyHelper(@TIdMappedFtpThreadFtpCmdLine_R,nil,'FtpCmdLine');
    RegisterPropertyHelper(@TIdMappedFtpThreadHost_R,@TIdMappedFtpThreadHost_W,'Host');
    RegisterPropertyHelper(@TIdMappedFtpThreadOutboundHost_R,@TIdMappedFtpThreadOutboundHost_W,'OutboundHost');
    RegisterPropertyHelper(@TIdMappedFtpThreadPort_R,@TIdMappedFtpThreadPort_W,'Port');
    RegisterPropertyHelper(@TIdMappedFtpThreadOutboundPort_R,@TIdMappedFtpThreadOutboundPort_W,'OutboundPort');
    RegisterPropertyHelper(@TIdMappedFtpThreadDataChannelThread_R,nil,'DataChannelThread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMappedFTP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMappedFtpDataThread) do
  RIRegister_TIdMappedFtpThread(CL);
  RIRegister_TIdMappedFtpDataThread(CL);
  RIRegister_TIdMappedFTP(CL);
end;

 
 
{ TPSImport_IdMappedFTP }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMappedFTP.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMappedFTP(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMappedFTP.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdMappedFTP(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
