unit uPSI_ComPortInterface;
{
   #5 of Serial CPort, asyncP, TSerial, ALSer
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
  TPSImport_ComPortInterface = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTComPort(CL: TPSPascalCompiler);
procedure SIRegister_TComPorts(CL: TPSPascalCompiler);
procedure SIRegister_TComPortInterface(CL: TPSPascalCompiler);
procedure SIRegister_ComPortInterface(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTComPort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComPorts(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComPortInterface(CL: TPSRuntimeClassImporter);
procedure RIRegister_ComPortInterface(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ComPortInterface
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ComPortInterface]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTComPort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TTComPort') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TTComPort') do
  begin
    RegisterMethod('Procedure Select');
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('Nr', 'Cardinal', iptr);
    RegisterProperty('Selected', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComPorts(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TComPorts') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TComPorts') do
  begin
    RegisterMethod('Constructor Create( AComPortInterface : TComPortInterface)');
    RegisterMethod('Function Add : TTComPort');
    RegisterProperty('Items', 'TTComPort Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComPortInterface(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TComPortInterface') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TComPortInterface') do begin
    RegisterMethod('Constructor Create');
          RegisterMethod('Procedure Free');
    RegisterMethod('Procedure RescanPorts');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('ComPorts', 'TComPorts', iptr);
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterMethod('Function ReadData( var Buffer : string; BufferSize : Cardinal) : Cardinal');
    RegisterMethod('Function ReadByte( var Buffer : Byte) : Boolean');
    RegisterMethod('Procedure WriteData( const Buffer : string; BufferSize : Cardinal)');
    RegisterMethod('Procedure WriteByte( Buffer : Byte)');
    RegisterMethod('Procedure ClearInputBuffer');
    RegisterMethod('Procedure ClearOutputBuffer');
    RegisterProperty('BaudRate', 'Cardinal', iptrw);
    RegisterProperty('DataBits', 'Byte', iptrw);
    RegisterProperty('StopBits', 'TTStopBits', iptrw);
    RegisterProperty('Parity', 'TTParity', iptrw);
    RegisterProperty('TimeOut', 'Cardinal', iptrw);
    RegisterProperty('Break', 'Boolean', iptrw);
    RegisterProperty('RTS', 'Boolean', iptrw);
    RegisterProperty('DTR', 'Boolean', iptrw);
    RegisterProperty('CTS', 'Boolean', iptr);
    RegisterProperty('DSR', 'Boolean', iptr);
    RegisterProperty('DCD', 'Boolean', iptr);
    RegisterProperty('RI', 'Boolean', iptr);
   { RegisterMethod('Constructor Create');
    RegisterMethod('Procedure RescanPorts');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('ComPorts', 'TComPorts', iptr);
    RegisterProperty('Connected', 'Boolean', iptr);}

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ComPortInterface(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('fttBinary','LongWord').SetUInt( $0001);
 CL.AddConstantN('fttParity','LongWord').SetUInt( $0002);
 CL.AddConstantN('fttOutxCtsFlow','LongWord').SetUInt( $0004);
 CL.AddConstantN('fttOutxDsrFlow','LongWord').SetUInt( $0008);
 CL.AddConstantN('fttDtrControlMask','LongWord').SetUInt( $0030);
 CL.AddConstantN('fttDsrSensitivity','LongWord').SetUInt( $0040);
 CL.AddConstantN('fttTXContinueOnXoff','LongWord').SetUInt( $0080);
 CL.AddConstantN('fttOutX','LongWord').SetUInt( $0100);
 CL.AddConstantN('fttInX','LongWord').SetUInt( $0200);
 CL.AddConstantN('fttErrorChar','LongWord').SetUInt( $0400);
 CL.AddConstantN('fttNull','LongWord').SetUInt( $0800);
 CL.AddConstantN('fttRtsControlMask','LongWord').SetUInt( $3000);
 CL.AddConstantN('fttAbortOnError','LongWord').SetUInt( $4000);
  CL.AddTypeS('TTParity', '( parNone, parOdd, parEven, parMark, parSpace )');
  CL.AddTypeS('TTStopBits', '( sbOne, sbOnePointFive, sbTwo )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TComPorts');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTComPort');
  SIRegister_TComPortInterface(CL);
  SIRegister_TComPorts(CL);
  SIRegister_TTComPort(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EComPortInterface');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EComPortAlreadyOpen');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EComPortNotOpen');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ENoComPortSelected');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECouldNotOpenComPort');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECouldCloseComPort');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidParameter');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EReadError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWriteError');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTComPortSelected_W(Self: TTComPort; const T: Boolean);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TTComPortSelected_R(Self: TTComPort; var T: Boolean);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TTComPortNr_R(Self: TTComPort; var T: Cardinal);
begin T := Self.Nr; end;

(*----------------------------------------------------------------------------*)
procedure TTComPortName_R(Self: TTComPort; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TComPortsItems_R(Self: TComPorts; var T: TTComPort; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceConnected_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceComPorts_R(Self: TComPortInterface; var T: TComPorts);
begin T := Self.ComPorts; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTComPort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTComPort) do
  begin
    RegisterMethod(@TTComPort.Select, 'Select');
    RegisterPropertyHelper(@TTComPortName_R,nil,'Name');
    RegisterPropertyHelper(@TTComPortNr_R,nil,'Nr');
    RegisterPropertyHelper(@TTComPortSelected_R,@TTComPortSelected_W,'Selected');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComPorts(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComPorts) do
  begin
    RegisterConstructor(@TComPorts.Create, 'Create');
    RegisterMethod(@TComPorts.Add, 'Add');
    RegisterPropertyHelper(@TComPortsItems_R,nil,'Items');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceRI_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.RI; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceDCD_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.DCD; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceDSR_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.DSR; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceCTS_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.CTS; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceDTR_W(Self: TComPortInterface; const T: Boolean);
begin Self.DTR := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceDTR_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.DTR; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceRTS_W(Self: TComPortInterface; const T: Boolean);
begin Self.RTS := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceRTS_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.RTS; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceBreak_W(Self: TComPortInterface; const T: Boolean);
begin Self.Break := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceBreak_R(Self: TComPortInterface; var T: Boolean);
begin T := Self.Break; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceTimeOut_W(Self: TComPortInterface; const T: Cardinal);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceTimeOut_R(Self: TComPortInterface; var T: Cardinal);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceParity_W(Self: TComPortInterface; const T: TTParity);
begin Self.Parity := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceParity_R(Self: TComPortInterface; var T: TTParity);
begin T := Self.Parity; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceStopBits_W(Self: TComPortInterface; const T: TTStopBits);
begin Self.StopBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceStopBits_R(Self: TComPortInterface; var T: TTStopBits);
begin T := Self.StopBits; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceDataBits_W(Self: TComPortInterface; const T: Byte);
begin Self.DataBits := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceDataBits_R(Self: TComPortInterface; var T: Byte);
begin T := Self.DataBits; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceBaudRate_W(Self: TComPortInterface; const T: Cardinal);
begin Self.BaudRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TComPortInterfaceBaudRate_R(Self: TComPortInterface; var T: Cardinal);
begin T := Self.BaudRate; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TComPortInterface(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComPortInterface) do begin
    RegisterConstructor(@TComPortInterface.Create, 'Create');
     RegisterMethod(@TComPortInterface.Destroy, 'Free');
      RegisterMethod(@TComPortInterface.RescanPorts, 'RescanPorts');
    RegisterVirtualMethod(@TComPortInterface.Connect, 'Connect');
    RegisterVirtualMethod(@TComPortInterface.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TComPortInterfaceComPorts_R,nil,'ComPorts');
    RegisterPropertyHelper(@TComPortInterfaceConnected_R,nil,'Connected');
      RegisterMethod(@TComPortInterface.ReadData, 'ReadData');
    RegisterMethod(@TComPortInterface.ReadByte, 'ReadByte');
    RegisterMethod(@TComPortInterface.WriteData, 'WriteData');
    RegisterMethod(@TComPortInterface.WriteByte, 'WriteByte');
    RegisterMethod(@TComPortInterface.ClearInputBuffer, 'ClearInputBuffer');
    RegisterMethod(@TComPortInterface.ClearOutputBuffer, 'ClearOutputBuffer');
    RegisterPropertyHelper(@TComPortInterfaceBaudRate_R,@TComPortInterfaceBaudRate_W,'BaudRate');
    RegisterPropertyHelper(@TComPortInterfaceDataBits_R,@TComPortInterfaceDataBits_W,'DataBits');
    RegisterPropertyHelper(@TComPortInterfaceStopBits_R,@TComPortInterfaceStopBits_W,'StopBits');
    RegisterPropertyHelper(@TComPortInterfaceParity_R,@TComPortInterfaceParity_W,'Parity');
    RegisterPropertyHelper(@TComPortInterfaceTimeOut_R,@TComPortInterfaceTimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TComPortInterfaceBreak_R,@TComPortInterfaceBreak_W,'Break');
    RegisterPropertyHelper(@TComPortInterfaceRTS_R,@TComPortInterfaceRTS_W,'RTS');
    RegisterPropertyHelper(@TComPortInterfaceDTR_R,@TComPortInterfaceDTR_W,'DTR');
    RegisterPropertyHelper(@TComPortInterfaceCTS_R,nil,'CTS');
    RegisterPropertyHelper(@TComPortInterfaceDSR_R,nil,'DSR');
    RegisterPropertyHelper(@TComPortInterfaceDCD_R,nil,'DCD');
    RegisterPropertyHelper(@TComPortInterfaceRI_R,nil,'RI');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ComPortInterface(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComPorts) do
  with CL.Add(TTComPort) do
  RIRegister_TComPortInterface(CL);
  RIRegister_TComPorts(CL);
  RIRegister_TTComPort(CL);
  with CL.Add(EComPortInterface) do
  with CL.Add(EComPortAlreadyOpen) do
  with CL.Add(EComPortNotOpen) do
  with CL.Add(ENoComPortSelected) do
  with CL.Add(ECouldNotOpenComPort) do
  with CL.Add(ECouldCloseComPort) do
  with CL.Add(EInvalidParameter) do
  with CL.Add(EReadError) do
  with CL.Add(EWriteError) do
end;

 
 
{ TPSImport_ComPortInterface }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComPortInterface.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ComPortInterface(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ComPortInterface.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ComPortInterface(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
