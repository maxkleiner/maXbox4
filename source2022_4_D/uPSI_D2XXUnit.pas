unit uPSI_D2XXUnit;
{
   for USB lowlevel API
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
  TPSImport_D2XXUnit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_D2XXUnit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_D2XXUnit_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Dialogs
  ,Messages
  ,Variants
  ,Graphics
  ,Controls
  ,D2XXUnit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_D2XXUnit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_D2XXUnit(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('FT_Result', 'Integer');
  //CL.AddTypeS('TDWordptr', '^DWord // will not work');
  CL.AddTypeS('TFT_Program_Data', 'record Signature1 : DWord; Signature2 : DWor'
   +'d; Version : DWord; VendorID : Word; ProductID : Word; Manufacturer : PCha'
   +'r; ManufacturerID : PChar; Description : PChar; SerialNumber : PChar; MaxP'
   +'ower : Word; PnP : Word; SelfPowered : Word; RemoteWakeup : Word; Rev4 : B'
   +'yte; IsoIn : Byte; IsoOut : Byte; PullDownEnable : Byte; SerNumEnable : By'
   +'te; USBVersionEnable : Byte; USBVersion : Word; Rev5 : Byte; IsoInA : Byte'
   +'; IsoInB : Byte; IsoOutA : Byte; IsoOutB : Byte; PullDownEnable5 : Byte; S'
   +'erNumEnable5 : Byte; USBVersionEnable5 : Byte; USBVersion5 : Word; AIsHigh'
   +'Current : Byte; BIsHighCurrent : Byte; IFAIsFifo : Byte; IFAIsFifoTar : By'
   +'te; IFAIsFastSer : Byte; AIsVCP : Byte; IFBIsFifo : Byte; IFBIsFifoTar : B'
   +'yte; IFBIsFastSer : Byte; BIsVCP : Byte; UseExtOsc : Byte; HighDriveIOs : '
   +'Byte; EndpointSize : Byte; PullDownEnableR : Byte; SerNumEnableR : Byte; I'
   +'nvertTXD : Byte; InvertRXD : Byte; InvertRTS : Byte; InvertCTS : Byte; Inv'
   +'ertDTR : Byte; InvertDSR : Byte; InvertDCD : Byte; InvertRI : Byte; Cbus0 '
   +': Byte; Cbus1 : Byte; Cbus2 : Byte; Cbus3 : Byte; Cbus4 : Byte; RIsVCP : B'
   +'yte; end');
 CL.AddDelphiFunction('Function GetFTDeviceCount : FT_Result');
 CL.AddDelphiFunction('Function GetFTDeviceSerialNo( DeviceIndex : DWord) : FT_Result');
 CL.AddDelphiFunction('Function GetFTDeviceDescription( DeviceIndex : DWord) : FT_Result');
 CL.AddDelphiFunction('Function GetFTDeviceLocation( DeviceIndex : DWord) : FT_Result');
 CL.AddDelphiFunction('Function Open_USB_Device : FT_Result');
 CL.AddDelphiFunction('Function Open_USB_Device_By_Serial_Number( Serial_Number : string) : FT_Result');
 CL.AddDelphiFunction('Function Open_USB_Device_By_Device_Description( Device_Description : string) : FT_Result');
 CL.AddDelphiFunction('Function Open_USB_Device_By_Device_Location( Location : DWord) : FT_Result');
 CL.AddDelphiFunction('Function Close_USB_Device : FT_Result');
 CL.AddDelphiFunction('Function Read_USB_Device_Buffer( Read_Count : Integer) : Integer');
 CL.AddDelphiFunction('Function Write_USB_Device_Buffer( Write_Count : Integer) : Integer');
 CL.AddDelphiFunction('Function Reset_USB_Device : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_BaudRate : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_BaudRate_Divisor( Divisor : Dword) : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_DataCharacteristics : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_FlowControl : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_RTS : FT_Result');
 CL.AddDelphiFunction('Function Clr_USB_Device_RTS : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_DTR : FT_Result');
 CL.AddDelphiFunction('Function Clr_USB_Device_DTR : FT_Result');
 CL.AddDelphiFunction('Function Get_USB_Device_ModemStatus : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_Chars : FT_Result');
 CL.AddDelphiFunction('Function Purge_USB_Device_Out : FT_Result');
 CL.AddDelphiFunction('Function Purge_USB_Device_In : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_TimeOuts( ReadTimeOut, WriteTimeOut : DWord) : FT_Result');
 CL.AddDelphiFunction('Function Get_USB_Device_QueueStatus : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_Break_On : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_Break_Off : FT_Result');
 CL.AddDelphiFunction('Function Get_USB_Device_Status : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_Event_Notification( EventMask : DWord) : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_GetDeviceInfo( DevType, ID : DWord; SerialNumber, Description : array of char) : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_Reset_Pipe_Retry_Count( RetryCount : DWord) : FT_Result');
 CL.AddDelphiFunction('Function Stop_USB_Device_InTask : FT_Result');
 CL.AddDelphiFunction('Function Restart_USB_Device_InTask : FT_Result');
 CL.AddDelphiFunction('Function Reset_USB_Port : FT_Result');
 CL.AddDelphiFunction('Function Cycle_USB_Port : FT_Result');
 CL.AddDelphiFunction('Function Create_USB_Device_List : FT_Result');
 CL.AddDelphiFunction('Function Get_USB_Device_List : FT_Result');
 CL.AddDelphiFunction('Function Get_USB_Device_List_Detail( Index : DWord) : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_EE_Read : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_C_EE_Read : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_R_EE_Read : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_EE_Program : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_ReadEE( WordAddr : Dword) : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_WriteEE( WordAddr : Dword; WordData : Word) : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_EraseEE : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_EE_UARead : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_EE_UAWrite : FT_Result');
 CL.AddDelphiFunction('Function USB_FT_EE_UASize : FT_Result');
 CL.AddDelphiFunction('Function Get_USB_Device_LatencyTimer : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_LatencyTimer( Latency : Byte) : FT_Result');
 CL.AddDelphiFunction('Function Get_USB_Device_BitMode( var BitMode : Byte) : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Device_BitMode( Mask, Enable : Byte) : FT_Result');
 CL.AddDelphiFunction('Function Set_USB_Parameters( InSize, OutSize : Dword) : FT_Result');
 //CL.AddDelphiFunction('Function Get_USB_Driver_Version( DrVersion : TDWordptr) : FT_Result');
 //CL.AddDelphiFunction('Function Get_USB_Library_Version( LbVersion : TDWordptr) : FT_Result');
 CL.AddConstantN('FT_OK','LongInt').SetInt( 0);
 CL.AddConstantN('FT_INVALID_HANDLE','LongInt').SetInt( 1);
 CL.AddConstantN('FT_DEVICE_NOT_FOUND','LongInt').SetInt( 2);
 CL.AddConstantN('FT_DEVICE_NOT_OPENED','LongInt').SetInt( 3);
 CL.AddConstantN('FT_IO_ERROR','LongInt').SetInt( 4);
 CL.AddConstantN('FT_INSUFFICIENT_RESOURCES','LongInt').SetInt( 5);
 CL.AddConstantN('FT_INVALID_PARAMETER','LongInt').SetInt( 6);
 CL.AddConstantN('FT_SUCCESS','integer').SetInt( FT_OK);
 CL.AddConstantN('FT_INVALID_BAUD_RATE','LongInt').SetInt( 7);
 CL.AddConstantN('FT_DEVICE_NOT_OPENED_FOR_ERASE','LongInt').SetInt( 8);
 CL.AddConstantN('FT_DEVICE_NOT_OPENED_FOR_WRITE','LongInt').SetInt( 9);
 CL.AddConstantN('FT_FAILED_TO_WRITE_DEVICE','LongInt').SetInt( 10);
 CL.AddConstantN('FT_EEPROM_READ_FAILED','LongInt').SetInt( 11);
 CL.AddConstantN('FT_EEPROM_WRITE_FAILED','LongInt').SetInt( 12);
 CL.AddConstantN('FT_EEPROM_ERASE_FAILED','LongInt').SetInt( 13);
 CL.AddConstantN('FT_EEPROM_NOT_PRESENT','LongInt').SetInt( 14);
 CL.AddConstantN('FT_EEPROM_NOT_PROGRAMMED','LongInt').SetInt( 15);
 CL.AddConstantN('FT_INVALID_ARGS','LongInt').SetInt( 16);
 CL.AddConstantN('FT_OTHER_ERROR','LongInt').SetInt( 17);
 CL.AddConstantN('FT_OPEN_BY_SERIAL_NUMBER','LongInt').SetInt( 1);
 CL.AddConstantN('FT_OPEN_BY_DESCRIPTION','LongInt').SetInt( 2);
 CL.AddConstantN('FT_OPEN_BY_LOCATION','LongInt').SetInt( 4);
 CL.AddConstantN('FT_LIST_NUMBER_ONLY','LongWord').SetUInt( $80000000);
 CL.AddConstantN('FT_LIST_BY_INDEX','LongWord').SetUInt( $40000000);
 CL.AddConstantN('FT_LIST_ALL','LongWord').SetUInt( $20000000);
 CL.AddConstantN('FT_BAUD_300','LongInt').SetInt( 300);
 CL.AddConstantN('FT_BAUD_600','LongInt').SetInt( 600);
 CL.AddConstantN('FT_BAUD_1200','LongInt').SetInt( 1200);
 CL.AddConstantN('FT_BAUD_2400','LongInt').SetInt( 2400);
 CL.AddConstantN('FT_BAUD_4800','LongInt').SetInt( 4800);
 CL.AddConstantN('FT_BAUD_9600','LongInt').SetInt( 9600);
 CL.AddConstantN('FT_BAUD_14400','LongInt').SetInt( 14400);
 CL.AddConstantN('FT_BAUD_19200','LongInt').SetInt( 19200);
 CL.AddConstantN('FT_BAUD_38400','LongInt').SetInt( 38400);
 CL.AddConstantN('FT_BAUD_57600','LongInt').SetInt( 57600);
 CL.AddConstantN('FT_BAUD_115200','LongInt').SetInt( 115200);
 CL.AddConstantN('FT_BAUD_230400','LongInt').SetInt( 230400);
 CL.AddConstantN('FT_BAUD_460800','LongInt').SetInt( 460800);
 CL.AddConstantN('FT_BAUD_921600','LongInt').SetInt( 921600);
 CL.AddConstantN('FT_DATA_BITS_7','LongInt').SetInt( 7);
 CL.AddConstantN('FT_DATA_BITS_8','LongInt').SetInt( 8);
 CL.AddConstantN('FT_STOP_BITS_1','LongInt').SetInt( 0);
 CL.AddConstantN('FT_STOP_BITS_2','LongInt').SetInt( 2);
 CL.AddConstantN('FT_PARITY_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('FT_PARITY_ODD','LongInt').SetInt( 1);
 CL.AddConstantN('FT_PARITY_EVEN','LongInt').SetInt( 2);
 CL.AddConstantN('FT_PARITY_MARK','LongInt').SetInt( 3);
 CL.AddConstantN('FT_PARITY_SPACE','LongInt').SetInt( 4);
 CL.AddConstantN('FT_FLOW_NONE','LongWord').SetUInt( $0000);
 CL.AddConstantN('FT_FLOW_RTS_CTS','LongWord').SetUInt( $0100);
 CL.AddConstantN('FT_FLOW_DTR_DSR','LongWord').SetUInt( $0200);
 CL.AddConstantN('FT_FLOW_XON_XOFF','LongWord').SetUInt( $0400);
 CL.AddConstantN('FT_PURGE_RX','LongInt').SetInt( 1);
 CL.AddConstantN('FT_PURGE_TX','LongInt').SetInt( 2);
 CL.AddConstantN('FT_EVENT_RXCHAR','LongInt').SetInt( 1);
 CL.AddConstantN('FT_EVENT_MODEM_STATUS','LongInt').SetInt( 2);
 CL.AddConstantN('CTS','LongWord').SetUInt( $10);
 CL.AddConstantN('DSR','LongWord').SetUInt( $20);
 CL.AddConstantN('RI','LongWord').SetUInt( $40);
 CL.AddConstantN('DCD','LongWord').SetUInt( $80);
 CL.AddConstantN('FT_In_Buffer_Size','LongWord').SetUInt( $10000);
 CL.AddConstantN('FT_In_Buffer_Index','LongInt').SetInt( FT_In_Buffer_Size - 1);
 CL.AddConstantN('FT_Out_Buffer_Size','LongWord').SetUInt( $10000);
 CL.AddConstantN('FT_Out_Buffer_Index','LongInt').SetInt( FT_Out_Buffer_Size - 1);
 CL.AddConstantN('FT_DLL_Name','String').SetString( 'FTD2XX.DLL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_D2XXUnit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetFTDeviceCount, 'GetFTDeviceCount', cdRegister);
 S.RegisterDelphiFunction(@GetFTDeviceSerialNo, 'GetFTDeviceSerialNo', cdRegister);
 S.RegisterDelphiFunction(@GetFTDeviceDescription, 'GetFTDeviceDescription', cdRegister);
 S.RegisterDelphiFunction(@GetFTDeviceLocation, 'GetFTDeviceLocation', cdRegister);
 S.RegisterDelphiFunction(@Open_USB_Device, 'Open_USB_Device', cdRegister);
 S.RegisterDelphiFunction(@Open_USB_Device_By_Serial_Number, 'Open_USB_Device_By_Serial_Number', cdRegister);
 S.RegisterDelphiFunction(@Open_USB_Device_By_Device_Description, 'Open_USB_Device_By_Device_Description', cdRegister);
 S.RegisterDelphiFunction(@Open_USB_Device_By_Device_Location, 'Open_USB_Device_By_Device_Location', cdRegister);
 S.RegisterDelphiFunction(@Close_USB_Device, 'Close_USB_Device', cdRegister);
 S.RegisterDelphiFunction(@Read_USB_Device_Buffer, 'Read_USB_Device_Buffer', cdRegister);
 S.RegisterDelphiFunction(@Write_USB_Device_Buffer, 'Write_USB_Device_Buffer', cdRegister);
 S.RegisterDelphiFunction(@Reset_USB_Device, 'Reset_USB_Device', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_BaudRate, 'Set_USB_Device_BaudRate', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_BaudRate_Divisor, 'Set_USB_Device_BaudRate_Divisor', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_DataCharacteristics, 'Set_USB_Device_DataCharacteristics', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_FlowControl, 'Set_USB_Device_FlowControl', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_RTS, 'Set_USB_Device_RTS', cdRegister);
 S.RegisterDelphiFunction(@Clr_USB_Device_RTS, 'Clr_USB_Device_RTS', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_DTR, 'Set_USB_Device_DTR', cdRegister);
 S.RegisterDelphiFunction(@Clr_USB_Device_DTR, 'Clr_USB_Device_DTR', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Device_ModemStatus, 'Get_USB_Device_ModemStatus', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_Chars, 'Set_USB_Device_Chars', cdRegister);
 S.RegisterDelphiFunction(@Purge_USB_Device_Out, 'Purge_USB_Device_Out', cdRegister);
 S.RegisterDelphiFunction(@Purge_USB_Device_In, 'Purge_USB_Device_In', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_TimeOuts, 'Set_USB_Device_TimeOuts', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Device_QueueStatus, 'Get_USB_Device_QueueStatus', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_Break_On, 'Set_USB_Device_Break_On', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_Break_Off, 'Set_USB_Device_Break_Off', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Device_Status, 'Get_USB_Device_Status', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_Event_Notification, 'Set_USB_Device_Event_Notification', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_GetDeviceInfo, 'USB_FT_GetDeviceInfo', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_Reset_Pipe_Retry_Count, 'Set_USB_Device_Reset_Pipe_Retry_Count', cdRegister);
 S.RegisterDelphiFunction(@Stop_USB_Device_InTask, 'Stop_USB_Device_InTask', cdRegister);
 S.RegisterDelphiFunction(@Restart_USB_Device_InTask, 'Restart_USB_Device_InTask', cdRegister);
 S.RegisterDelphiFunction(@Reset_USB_Port, 'Reset_USB_Port', cdRegister);
 S.RegisterDelphiFunction(@Cycle_USB_Port, 'Cycle_USB_Port', cdRegister);
 S.RegisterDelphiFunction(@Create_USB_Device_List, 'Create_USB_Device_List', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Device_List, 'Get_USB_Device_List', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Device_List_Detail, 'Get_USB_Device_List_Detail', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_EE_Read, 'USB_FT_EE_Read', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_C_EE_Read, 'USB_FT_C_EE_Read', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_R_EE_Read, 'USB_FT_R_EE_Read', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_EE_Program, 'USB_FT_EE_Program', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_ReadEE, 'USB_FT_ReadEE', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_WriteEE, 'USB_FT_WriteEE', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_EraseEE, 'USB_FT_EraseEE', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_EE_UARead, 'USB_FT_EE_UARead', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_EE_UAWrite, 'USB_FT_EE_UAWrite', cdRegister);
 S.RegisterDelphiFunction(@USB_FT_EE_UASize, 'USB_FT_EE_UASize', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Device_LatencyTimer, 'Get_USB_Device_LatencyTimer', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_LatencyTimer, 'Set_USB_Device_LatencyTimer', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Device_BitMode, 'Get_USB_Device_BitMode', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Device_BitMode, 'Set_USB_Device_BitMode', cdRegister);
 S.RegisterDelphiFunction(@Set_USB_Parameters, 'Set_USB_Parameters', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Driver_Version, 'Get_USB_Driver_Version', cdRegister);
 S.RegisterDelphiFunction(@Get_USB_Library_Version, 'Get_USB_Library_Version', cdRegister);
end;

 
 
{ TPSImport_D2XXUnit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_D2XXUnit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_D2XXUnit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_D2XXUnit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_D2XXUnit(ri);
  RIRegister_D2XXUnit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
