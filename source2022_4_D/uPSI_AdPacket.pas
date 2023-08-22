unit uPSI_AdPacket;
{
   to pack GSM
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
  TPSImport_AdPacket = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TApdDataPacket(CL: TPSPascalCompiler);
procedure SIRegister_TApdDataPacketManager(CL: TPSPascalCompiler);
procedure SIRegister_TApdDataPacketManagerList(CL: TPSPascalCompiler);
procedure SIRegister_AdPacket(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TApdDataPacket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TApdDataPacketManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TApdDataPacketManagerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_AdPacket(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,OoMisc
  ,AdExcept
  ,AdPort
  ,AwUser
  ,AdPacket
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AdPacket]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TApdDataPacket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TApdBaseComponent', 'TApdDataPacket') do
  with CL.AddClassN(CL.FindClass('TApdBaseComponent'),'TApdDataPacket') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
      RegisterMethod('Procedure GetCollectedString( var Data : String)');
    RegisterMethod('Procedure GetCollectedData( var Data : TObject; var Size : Integer)');
    RegisterProperty('InternalManager', 'TApdDataPacketManager', iptr);
    RegisterProperty('EnableTimeout', 'Integer', iptrw);
    RegisterProperty('FlushOnTimeout', 'Boolean', iptrw);
    RegisterProperty('SyncEvents', 'Boolean', iptrw);
    RegisterProperty('PacketMode', 'TPacketMode', iptr);
    RegisterMethod('Function WaitForString( var Data : string) : Boolean');
    RegisterMethod('Function WaitForPacket( var Data : TObject; var Size : Integer) : Boolean');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('AutoEnable', 'Boolean', iptrw);
    RegisterProperty('StartCond', 'TPacketStartCond', iptrw);
    RegisterProperty('EndCond', 'TPacketEndSet', iptrw);
    RegisterProperty('StartString', 'string', iptrw);
    RegisterProperty('EndString', 'string', iptrw);
    RegisterProperty('IgnoreCase', 'Boolean', iptrw);
    RegisterProperty('ComPort', 'TApdCustomComPort', iptrw);
    RegisterProperty('PacketSize', 'Integer', iptrw);
    RegisterProperty('IncludeStrings', 'Boolean', iptrw);
    RegisterProperty('TimeOut', 'Integer', iptrw);
    RegisterProperty('OnPacket', 'TPacketNotifyEvent', iptrw);
    RegisterProperty('OnStringPacket', 'TStringPacketNotifyEvent', iptrw);
    RegisterProperty('OnTimeout', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TApdDataPacketManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TApdDataPacketManager') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TApdDataPacketManager') do begin
    RegisterMethod('Constructor Create( ComPort : TApdCustomComPort)');
       RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Enable');
    RegisterMethod('Procedure EnableIfPending');
    RegisterMethod('Procedure Disable');
    RegisterMethod('Procedure Insert( Value : TApdDataPacket)');
    RegisterMethod('Procedure Remove( Value : TApdDataPacket)');
    RegisterMethod('Procedure RemoveData( Start, Size : Integer)');
    RegisterMethod('Procedure SetCapture( Value : TApdDataPacket; TimeOut : Integer)');
    RegisterMethod('Procedure ReleaseCapture( Value : TApdDataPacket)');
    RegisterProperty('DataBuffer', 'pChar', iptr);
    RegisterProperty('ComPort', 'TApdCustomComPort', iptr);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('InEvent', 'Boolean', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TApdDataPacketManagerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TApdDataPacketManagerList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TApdDataPacketManagerList') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Insert( Value : TApdDataPacketManager)');
    RegisterMethod('Procedure Remove( Value : TApdDataPacketManager)');
    RegisterMethod('Function GetPortManager( ComPort : TApdCustomComPort) : TApdDataPacketManager');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AdPacket(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPacketStartCond', '( scString, scAnyData )');
  CL.AddTypeS('TPacketEndCond', '( ecString, ecPacketSize )');
  CL.AddTypeS('TPacketEndSet', 'set of TPacketEndCond');
 CL.AddConstantN('EscapeCharacter','String').SetString( '\');
 CL.AddConstantN('WildCardCharacter','String').SetString( '?');
 CL.AddConstantN('adpDefEnabled','Boolean');
 CL.AddConstantN('adpDefIgnoreCase','Boolean');
 CL.AddConstantN('adpDefIncludeStrings','Boolean');
 CL.AddConstantN('adpDefAutoEnable','Boolean');
 CL.AddConstantN('adpDefStartCond','string').SetString('scString');
 CL.AddConstantN('adpDefTimeOut','LongInt').SetInt( 2184);
 CL.AddConstantN('apdDefFlushOnTimeout','Boolean').SetInt( 2184);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TApdDataPacket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TApdDataPacketManager');
  SIRegister_TApdDataPacketManagerList(CL);
  SIRegister_TApdDataPacketManager(CL);
  CL.AddTypeS('TPacketMode', '( dpIdle, dpWaitStart, dpCollecting )');
  CL.AddTypeS('TPacketNotifyEvent', 'Procedure ( Sender : TObject; Data : TObject; Size : Integer)');
  CL.AddTypeS('TStringPacketNotifyEvent', 'Procedure ( Sender : TObject; Data : string)');
  SIRegister_TApdDataPacket(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TApdDataPacketOnTimeout_W(Self: TApdDataPacket; const T: TNotifyEvent);
begin Self.OnTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketOnTimeout_R(Self: TApdDataPacket; var T: TNotifyEvent);
begin T := Self.OnTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketOnStringPacket_W(Self: TApdDataPacket; const T: TStringPacketNotifyEvent);
begin Self.OnStringPacket := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketOnStringPacket_R(Self: TApdDataPacket; var T: TStringPacketNotifyEvent);
begin T := Self.OnStringPacket; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketOnPacket_W(Self: TApdDataPacket; const T: TPacketNotifyEvent);
begin Self.OnPacket := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketOnPacket_R(Self: TApdDataPacket; var T: TPacketNotifyEvent);
begin T := Self.OnPacket; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketTimeOut_W(Self: TApdDataPacket; const T: Integer);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketTimeOut_R(Self: TApdDataPacket; var T: Integer);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketIncludeStrings_W(Self: TApdDataPacket; const T: Boolean);
begin Self.IncludeStrings := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketIncludeStrings_R(Self: TApdDataPacket; var T: Boolean);
begin T := Self.IncludeStrings; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketPacketSize_W(Self: TApdDataPacket; const T: Integer);
begin Self.PacketSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketPacketSize_R(Self: TApdDataPacket; var T: Integer);
begin T := Self.PacketSize; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketComPort_W(Self: TApdDataPacket; const T: TApdCustomComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketComPort_R(Self: TApdDataPacket; var T: TApdCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketIgnoreCase_W(Self: TApdDataPacket; const T: Boolean);
begin Self.IgnoreCase := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketIgnoreCase_R(Self: TApdDataPacket; var T: Boolean);
begin T := Self.IgnoreCase; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEndString_W(Self: TApdDataPacket; const T: string);
begin Self.EndString := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEndString_R(Self: TApdDataPacket; var T: string);
begin T := Self.EndString; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketStartString_W(Self: TApdDataPacket; const T: string);
begin Self.StartString := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketStartString_R(Self: TApdDataPacket; var T: string);
begin T := Self.StartString; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEndCond_W(Self: TApdDataPacket; const T: TPacketEndSet);
begin Self.EndCond := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEndCond_R(Self: TApdDataPacket; var T: TPacketEndSet);
begin T := Self.EndCond; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketStartCond_W(Self: TApdDataPacket; const T: TPacketStartCond);
begin Self.StartCond := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketStartCond_R(Self: TApdDataPacket; var T: TPacketStartCond);
begin T := Self.StartCond; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketAutoEnable_W(Self: TApdDataPacket; const T: Boolean);
begin Self.AutoEnable := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketAutoEnable_R(Self: TApdDataPacket; var T: Boolean);
begin T := Self.AutoEnable; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEnabled_W(Self: TApdDataPacket; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEnabled_R(Self: TApdDataPacket; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketPacketMode_R(Self: TApdDataPacket; var T: TPacketMode);
begin T := Self.PacketMode; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketSyncEvents_W(Self: TApdDataPacket; const T: Boolean);
begin Self.SyncEvents := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketSyncEvents_R(Self: TApdDataPacket; var T: Boolean);
begin T := Self.SyncEvents; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketFlushOnTimeout_W(Self: TApdDataPacket; const T: Boolean);
begin Self.FlushOnTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketFlushOnTimeout_R(Self: TApdDataPacket; var T: Boolean);
begin T := Self.FlushOnTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEnableTimeout_W(Self: TApdDataPacket; const T: Integer);
begin Self.EnableTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketEnableTimeout_R(Self: TApdDataPacket; var T: Integer);
begin T := Self.EnableTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketInternalManager_R(Self: TApdDataPacket; var T: TApdDataPacketManager);
begin T := Self.InternalManager; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerKeepAlive_W(Self: TApdDataPacketManager; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerKeepAlive_R(Self: TApdDataPacketManager; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerInEvent_W(Self: TApdDataPacketManager; const T: Boolean);
begin Self.InEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerInEvent_R(Self: TApdDataPacketManager; var T: Boolean);
begin T := Self.InEvent; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerEnabled_W(Self: TApdDataPacketManager; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerEnabled_R(Self: TApdDataPacketManager; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerComPort_R(Self: TApdDataPacketManager; var T: TApdCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TApdDataPacketManagerDataBuffer_R(Self: TApdDataPacketManager; var T: pChar);
begin T := Self.DataBuffer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApdDataPacket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdDataPacket) do
  begin
    RegisterConstructor(@TApdDataPacket.Create, 'Create');
       RegisterMethod(@TApdDataPacket.Destroy, 'Free');
     RegisterMethod(@TApdDataPacket.GetCollectedString, 'GetCollectedString');
    RegisterMethod(@TApdDataPacket.GetCollectedData, 'GetCollectedData');
    RegisterPropertyHelper(@TApdDataPacketInternalManager_R,nil,'InternalManager');
    RegisterPropertyHelper(@TApdDataPacketEnableTimeout_R,@TApdDataPacketEnableTimeout_W,'EnableTimeout');
    RegisterPropertyHelper(@TApdDataPacketFlushOnTimeout_R,@TApdDataPacketFlushOnTimeout_W,'FlushOnTimeout');
    RegisterPropertyHelper(@TApdDataPacketSyncEvents_R,@TApdDataPacketSyncEvents_W,'SyncEvents');
    RegisterPropertyHelper(@TApdDataPacketPacketMode_R,nil,'PacketMode');
    RegisterMethod(@TApdDataPacket.WaitForString, 'WaitForString');
    RegisterMethod(@TApdDataPacket.WaitForPacket, 'WaitForPacket');
    RegisterPropertyHelper(@TApdDataPacketEnabled_R,@TApdDataPacketEnabled_W,'Enabled');
    RegisterPropertyHelper(@TApdDataPacketAutoEnable_R,@TApdDataPacketAutoEnable_W,'AutoEnable');
    RegisterPropertyHelper(@TApdDataPacketStartCond_R,@TApdDataPacketStartCond_W,'StartCond');
    RegisterPropertyHelper(@TApdDataPacketEndCond_R,@TApdDataPacketEndCond_W,'EndCond');
    RegisterPropertyHelper(@TApdDataPacketStartString_R,@TApdDataPacketStartString_W,'StartString');
    RegisterPropertyHelper(@TApdDataPacketEndString_R,@TApdDataPacketEndString_W,'EndString');
    RegisterPropertyHelper(@TApdDataPacketIgnoreCase_R,@TApdDataPacketIgnoreCase_W,'IgnoreCase');
    RegisterPropertyHelper(@TApdDataPacketComPort_R,@TApdDataPacketComPort_W,'ComPort');
    RegisterPropertyHelper(@TApdDataPacketPacketSize_R,@TApdDataPacketPacketSize_W,'PacketSize');
    RegisterPropertyHelper(@TApdDataPacketIncludeStrings_R,@TApdDataPacketIncludeStrings_W,'IncludeStrings');
    RegisterPropertyHelper(@TApdDataPacketTimeOut_R,@TApdDataPacketTimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TApdDataPacketOnPacket_R,@TApdDataPacketOnPacket_W,'OnPacket');
    RegisterPropertyHelper(@TApdDataPacketOnStringPacket_R,@TApdDataPacketOnStringPacket_W,'OnStringPacket');
    RegisterPropertyHelper(@TApdDataPacketOnTimeout_R,@TApdDataPacketOnTimeout_W,'OnTimeout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApdDataPacketManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdDataPacketManager) do begin
    RegisterConstructor(@TApdDataPacketManager.Create, 'Create');
           RegisterMethod(@TApdDataPacketManager.Destroy, 'Free');
    RegisterMethod(@TApdDataPacketManager.Enable, 'Enable');
    RegisterMethod(@TApdDataPacketManager.EnableIfPending, 'EnableIfPending');
    RegisterMethod(@TApdDataPacketManager.Disable, 'Disable');
    RegisterMethod(@TApdDataPacketManager.Insert, 'Insert');
    RegisterMethod(@TApdDataPacketManager.Remove, 'Remove');
    RegisterMethod(@TApdDataPacketManager.RemoveData, 'RemoveData');
    RegisterMethod(@TApdDataPacketManager.SetCapture, 'SetCapture');
    RegisterMethod(@TApdDataPacketManager.ReleaseCapture, 'ReleaseCapture');
    RegisterPropertyHelper(@TApdDataPacketManagerDataBuffer_R,nil,'DataBuffer');
    RegisterPropertyHelper(@TApdDataPacketManagerComPort_R,nil,'ComPort');
    RegisterPropertyHelper(@TApdDataPacketManagerEnabled_R,@TApdDataPacketManagerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TApdDataPacketManagerInEvent_R,@TApdDataPacketManagerInEvent_W,'InEvent');
    RegisterPropertyHelper(@TApdDataPacketManagerKeepAlive_R,@TApdDataPacketManagerKeepAlive_W,'KeepAlive');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApdDataPacketManagerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdDataPacketManagerList) do begin
    RegisterConstructor(@TApdDataPacketManagerList.Create, 'Create');
    RegisterMethod(@TApdDataPacketManagerList.Destroy, 'Free');
    RegisterMethod(@TApdDataPacketManagerList.Insert, 'Insert');
    RegisterMethod(@TApdDataPacketManagerList.Remove, 'Remove');
    RegisterMethod(@TApdDataPacketManagerList.GetPortManager, 'GetPortManager');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AdPacket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdDataPacket) do
  with CL.Add(TApdDataPacketManager) do
  RIRegister_TApdDataPacketManagerList(CL);
  RIRegister_TApdDataPacketManager(CL);
  RIRegister_TApdDataPacket(CL);
end;

 
 
{ TPSImport_AdPacket }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdPacket.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AdPacket(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdPacket.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AdPacket(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
