unit uPSI_uUsb;
{
usb notif< checker
allows you to detect the insertion or removal of usb devices such as usb memory sticks, usb webcams, etc.
http://www.delphibasics.info/home/delphibasicssnippets/detectusbdeviceinsertandremoval-uusbbytestest

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
  TPSImport_uUsb = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TUsbNotifier(CL: TPSPascalCompiler);
procedure SIRegister_uUsb(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TUsbNotifier(CL: TPSRuntimeClassImporter);
procedure RIRegister_uUsb(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,uUsb
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uUsb]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TUsbNotifier(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TUsbNotifier') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TUsbNotifier') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterProperty('OnUsbArrival', 'TUsbNotifyProc', iptrw);
    RegisterProperty('OnUsbRemoval', 'TUsbNotifyProc', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uUsb(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PDevBroadcastHdr', '^DEV_BROADCAST_HDR // will not work');
  CL.AddTypeS('DEV_BROADCAST_HDR', 'record dbch_size : DWORD; dbch_devicetype :'
   +' DWORD; dbch_reserved : DWORD; end');
  CL.AddTypeS('TDevBroadcastHdr', 'DEV_BROADCAST_HDR');
  //CL.AddTypeS('PDevBroadcastDeviceInterface', '^DEV_BROADCAST_DEVICEINTERFACE /'
   //+'/ will not work');
  CL.AddTypeS('DEV_BROADCAST_DEVICEINTERFACE', 'record dbcc_size : DWORD; dbcc_'
   +'devicetype : DWORD; dbcc_reserved : DWORD; dbcc_classguid : TGUID; dbcc_name : Char; end');
  CL.AddTypeS('TDevBroadcastDeviceInterface', 'DEV_BROADCAST_DEVICEINTERFACE');
 //CL.AddConstantN('GUID_DEVINTERFACE_USB_DEVICE','TGUID').SetString( '{A5DCBF10-6530-11D2-901F-00C04FB951ED}');
 CL.AddConstantN('DBT_DEVICEARRIVAL','LongWord').SetUInt( $8000);
 CL.AddConstantN('DBT_DEVICEREMOVECOMPLETE','LongWord').SetUInt( $8004);
 CL.AddConstantN('DBT_DEVTYP_DEVICEINTERFACE','LongWord').SetUInt( $00000005);
  CL.AddTypeS('TUsbNotifyProc', 'Procedure ( Sender : TObject; const DeviceName: String)');
  SIRegister_TUsbNotifier(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TUsbNotifierOnUsbRemoval_W(Self: TUsbNotifier; const T: TUsbNotifyProc);
begin Self.OnUsbRemoval := T; end;

(*----------------------------------------------------------------------------*)
procedure TUsbNotifierOnUsbRemoval_R(Self: TUsbNotifier; var T: TUsbNotifyProc);
begin T := Self.OnUsbRemoval; end;

(*----------------------------------------------------------------------------*)
procedure TUsbNotifierOnUsbArrival_W(Self: TUsbNotifier; const T: TUsbNotifyProc);
begin Self.OnUsbArrival := T; end;

(*----------------------------------------------------------------------------*)
procedure TUsbNotifierOnUsbArrival_R(Self: TUsbNotifier; var T: TUsbNotifyProc);
begin T := Self.OnUsbArrival; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUsbNotifier(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUsbNotifier) do begin
    RegisterConstructor(@TUsbNotifier.Create, 'Create');
    RegisterMethod(@TUsbNotifier.Destroy, 'Free');
    RegisterPropertyHelper(@TUsbNotifierOnUsbArrival_R,@TUsbNotifierOnUsbArrival_W,'OnUsbArrival');
    RegisterPropertyHelper(@TUsbNotifierOnUsbRemoval_R,@TUsbNotifierOnUsbRemoval_W,'OnUsbRemoval');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uUsb(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TUsbNotifier(CL);
end;

 
 
{ TPSImport_uUsb }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uUsb.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uUsb(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uUsb.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uUsb(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
