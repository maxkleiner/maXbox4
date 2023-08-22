unit uPSI_PXLNetComs;
{
Tprepae for Raspi4  & Arduino TempSensors and so on and off
  receuveevebt2

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
  TPSImport_PXLNetComs = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNetCom(CL: TPSPascalCompiler);
procedure SIRegister_PXLNetComs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TNetCom(CL: TPSRuntimeClassImporter);
procedure RIRegister_PXLNetComs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinSock2
  WinSock
  //,termio
  //,BaseUnix
  ,Sockets
  ,PXLNetComs
  ;

 type
     TReceiveEvent2 = procedure(const Sender: TObject; const Host: StdString; const Port: Integer; const Data: string;
      const Size: Integer) of object;      

 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PXLNetComs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNetCom(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TNetCom') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TNetCom') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Initialize : Boolean');
    RegisterMethod('Procedure Finalize');
    RegisterMethod('Function ResolveHost( const Host : String) : String');
    RegisterMethod('Function ResolveIP( const IPAddress : String) : String');
    RegisterMethod('Function SendStr( const Host : String; const Port : Integer; const Data : string; const Size : Integer) : Boolean');
    RegisterMethod('Function Send2( const Host : String; const Port : Integer; const Data : string; const Size : Integer) : Boolean');
    RegisterMethod('Function Send( const Host : String; const Port : Integer; const Data : string; const Size : Integer) : Boolean');
    RegisterMethod('Procedure Update');
    RegisterMethod('Procedure ResetStatistics');
    RegisterProperty('LocalIP', 'String', iptr);
    RegisterProperty('Initialized', 'Boolean', iptr);
    RegisterProperty('Broadcast', 'Boolean', iptrw);
    RegisterProperty('LocalPort', 'Integer', iptrw);
    RegisterProperty('OnReceive2', 'TReceiveEvent2', iptrw);
    RegisterProperty('UpdateRefreshTime', 'Integer', iptrw);
    RegisterProperty('BytesReceived', 'Integer', iptr);
    RegisterProperty('BytesSent', 'Integer', iptr);
    RegisterProperty('SentPackets', 'Integer', iptr);
    RegisterProperty('ReceivedPackets', 'Integer', iptr);
    RegisterProperty('BytesPerSec', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PXLNetComs(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaximumPacketSize','LongInt').SetInt( 8166);
  CL.AddTypeS('TSocket', 'Integer');
  CL.AddTypeS('TInAddr', 'record S_addr : Cardinal; end');

  CL.AddTypeS('TReceiveEvent2','procedure(const Sender: TObject; const Host: String; const Port: Integer; '+
                                'const Data: string;  const Size: Integer) of object');

  SIRegister_TNetCom(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNetComBytesPerSec_R(Self: TNetCom; var T: Integer);
begin T := Self.BytesPerSec; end;

(*----------------------------------------------------------------------------*)
procedure TNetComReceivedPackets_R(Self: TNetCom; var T: Integer);
begin T := Self.ReceivedPackets; end;

(*----------------------------------------------------------------------------*)
procedure TNetComSentPackets_R(Self: TNetCom; var T: Integer);
begin T := Self.SentPackets; end;

(*----------------------------------------------------------------------------*)
procedure TNetComBytesSent_R(Self: TNetCom; var T: Integer);
begin T := Self.BytesSent; end;

(*----------------------------------------------------------------------------*)
procedure TNetComBytesReceived_R(Self: TNetCom; var T: Integer);
begin T := Self.BytesReceived; end;

(*----------------------------------------------------------------------------*)
procedure TNetComUpdateRefreshTime_W(Self: TNetCom; const T: Integer);
begin Self.UpdateRefreshTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetComUpdateRefreshTime_R(Self: TNetCom; var T: Integer);
begin T := Self.UpdateRefreshTime; end;


(*----------------------------------------------------------------------------*)
procedure TNetComOnReceive_W(Self: TNetCom; const T: TReceiveEvent2);
begin Self.OnReceive2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetComOnReceive_R(Self: TNetCom; var T: TReceiveEvent2);
begin T := Self.OnReceive2; end;


(*----------------------------------------------------------------------------*)
procedure TNetComLocalPort_W(Self: TNetCom; const T: Integer);
begin Self.LocalPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetComLocalPort_R(Self: TNetCom; var T: Integer);
begin T := Self.LocalPort; end;

(*----------------------------------------------------------------------------*)
procedure TNetComBroadcast_W(Self: TNetCom; const T: Boolean);
begin Self.Broadcast := T; end;

(*----------------------------------------------------------------------------*)
procedure TNetComBroadcast_R(Self: TNetCom; var T: Boolean);
begin T := Self.Broadcast; end;

(*----------------------------------------------------------------------------*)
procedure TNetComInitialized_R(Self: TNetCom; var T: Boolean);
begin T := Self.Initialized; end;

(*----------------------------------------------------------------------------*)
procedure TNetComLocalIP_R(Self: TNetCom; var T: StdString);
begin T := Self.LocalIP; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNetCom(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNetCom) do begin
    RegisterConstructor(@TNetCom.Create, 'Create');
    RegisterMethod(@TNetCom.Destroy, 'Free');
    RegisterMethod(@TNetCom.Initialize, 'Initialize');
    RegisterMethod(@TNetCom.Finalize, 'Finalize');
    RegisterMethod(@TNetCom.ResolveHost, 'ResolveHost');
    RegisterMethod(@TNetCom.ResolveIP, 'ResolveIP');
    RegisterMethod(@TNetCom.SendStr, 'SendStr');
    RegisterMethod(@TNetCom.SendStr, 'Send2');
    RegisterMethod(@TNetCom.SendStr, 'Send');
    RegisterMethod(@TNetCom.Update, 'Update');
    RegisterMethod(@TNetCom.ResetStatistics, 'ResetStatistics');
    RegisterPropertyHelper(@TNetComLocalIP_R,nil,'LocalIP');
    RegisterPropertyHelper(@TNetComInitialized_R,nil,'Initialized');
    RegisterPropertyHelper(@TNetComBroadcast_R,@TNetComBroadcast_W,'Broadcast');
    RegisterPropertyHelper(@TNetComLocalPort_R,@TNetComLocalPort_W,'LocalPort');
    RegisterPropertyHelper(@TNetComOnReceive_R,@TNetComOnReceive_W,'OnReceive2');
    RegisterPropertyHelper(@TNetComUpdateRefreshTime_R,@TNetComUpdateRefreshTime_W,'UpdateRefreshTime');
    RegisterPropertyHelper(@TNetComBytesReceived_R,nil,'BytesReceived');
    RegisterPropertyHelper(@TNetComBytesSent_R,nil,'BytesSent');
    RegisterPropertyHelper(@TNetComSentPackets_R,nil,'SentPackets');
    RegisterPropertyHelper(@TNetComReceivedPackets_R,nil,'ReceivedPackets');
    RegisterPropertyHelper(@TNetComBytesPerSec_R,nil,'BytesPerSec');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PXLNetComs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNetCom(CL);
end;

 
 
{ TPSImport_PXLNetComs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PXLNetComs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PXLNetComs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PXLNetComs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PXLNetComs(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
