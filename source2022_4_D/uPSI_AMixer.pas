unit uPSI_AMixer;
{
  for oscilloscope
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
  TPSImport_AMixer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAudioMixer(CL: TPSPascalCompiler);
procedure SIRegister_TMixerDestinations(CL: TPSPascalCompiler);
procedure SIRegister_TMixerDestination(CL: TPSPascalCompiler);
procedure SIRegister_TMixerConnections(CL: TPSPascalCompiler);
procedure SIRegister_TMixerConnection(CL: TPSPascalCompiler);
procedure SIRegister_TMixerControls(CL: TPSPascalCompiler);
procedure SIRegister_TPointerList(CL: TPSPascalCompiler);
procedure SIRegister_AMixer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AMixer_Routines(S: TPSExec);
procedure RIRegister_TAudioMixer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMixerDestinations(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMixerDestination(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMixerConnections(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMixerConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMixerControls(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPointerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_AMixer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,MMSystem
  ,AMixer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AMixer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAudioMixer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAudioMixer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAudioMixer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
    RegisterProperty('DriverVersion', 'MMVERSION', iptr);
    RegisterProperty('ProductId', 'WORD', iptr);
    RegisterProperty('NumberOfLine', 'Integer', iptr);
    RegisterProperty('Manufacturer', 'string', iptr);
    RegisterProperty('ProductName', 'string', iptr);
    RegisterProperty('MixerId', 'Integer', iptrw);
    RegisterProperty('OnLineChange', 'TMixerChange', iptrw);
    RegisterProperty('OnControlChange', 'TMixerChange', iptrw);
    RegisterMethod('Function GetVolume( ADestination, AConnection : Integer; var LeftVol, RightVol, Mute : Integer; var Stereo, VolDisabled, MuteDisabled, MuteIsSelect : Boolean) : Boolean');
    RegisterMethod('Function SetVolume( ADestination, AConnection : Integer; LeftVol, RightVol, Mute : Integer) : Boolean');
    RegisterMethod('Function GetPeak( ADestination, AConnection : Integer; var LeftPeak, RightPeak : Integer) : Boolean');
    RegisterMethod('Function GetMute( ADestination, AConnection : Integer; var Mute : Boolean) : Boolean');
    RegisterMethod('Function SetMute( ADestination, AConnection : Integer; Mute : Boolean) : Boolean');
    RegisterProperty('Destinations', 'TMixerDestinations', iptr);
    RegisterProperty('MixerCaps', 'TMixerCaps', iptr);
    RegisterProperty('MixerCount', 'Integer', iptr);
    RegisterProperty('MixerHandle', 'HMixer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMixerDestinations(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMixerDestinations') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMixerDestinations') do begin
    RegisterMethod('Constructor Create( AMixer : TAudioMixer)');
         RegisterMethod('Procedure Free');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Destination', 'TMixerDestination Integer', iptr);
    SetDefaultPropery('Destination');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMixerDestination(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMixerDestination') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMixerDestination') do begin
       RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AMixer : TAudioMixer; AData : TMixerLine)');
    RegisterProperty('Connections', 'TMixerConnections', iptr);
    RegisterProperty('Controls', 'TMixerControls', iptr);
    //RegisterProperty('Data', 'TMixerLine', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMixerConnections(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMixerConnections') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMixerConnections') do begin
       RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AMixer : TAudioMixer; AData : TMixerLine)');
    RegisterProperty('Connection', 'TMixerConnection Integer', iptr);
    SetDefaultPropery('Connection');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMixerConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMixerConnection') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMixerConnection') do begin
       RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AMixer : TAudioMixer; AData : TMixerLine)');
    RegisterProperty('Controls', 'TMixerControls', iptr);
    //RegisterProperty('Data', 'TMixerLine', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMixerControls(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMixerControls') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMixerControls') do begin
       RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AMixer : TAudioMixer; AData : TMixerLine)');
    //RegisterProperty('Control', 'PMixerControl Integer', iptr);
    //SetDefaultPropery('Control');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPointerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPointerList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPointerList') do begin
       RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Add( Pntr : TObject)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('TObject', 'TObject Integer', iptr);
    SetDefaultPropery('TObject');
    RegisterProperty('OnFreeItem', 'TPListFreeItemNotify', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AMixer(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAudioMixer');
 //   HMIXER = Integer;
(*   tagMIXERCAPSA = record
    wMid: WORD;                    { manufacturer id }
    wPid: WORD;                    { product id }
    vDriverVersion: MMVERSION;     { version of the driver }
    szPname: array [0..MAXPNAMELEN - 1] of AnsiChar;   { product name }
    fdwSupport: DWORD;             { misc. support bits }
    cDestinations: DWORD;          { count of destinations }
  end; *)

   CL.AddTypeS('TMIXERCAPS','record wMid: Word; wPid: Word;'+
 'vDriverVersion: Longint; szPname: array[0..32] of char; fdwSupport : DWord; cDestinations: DWORD; end');

 CL.AddTypeS('HMIXER', 'Integer');
  CL.AddTypeS('TPListFreeItemNotify', 'Procedure ( Pntr : TObject)');
  CL.AddTypeS('TMixerChange', 'Procedure ( Sender : TObject; MixerH : HMixer; ID : Integer)');
  SIRegister_TPointerList(CL);
  SIRegister_TMixerControls(CL);
  SIRegister_TMixerConnection(CL);
  SIRegister_TMixerConnections(CL);
  SIRegister_TMixerDestination(CL);
  SIRegister_TMixerDestinations(CL);
  SIRegister_TAudioMixer(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAudioMixerMixerHandle_R(Self: TAudioMixer; var T: HMixer);
begin T := Self.MixerHandle; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerMixerCount_R(Self: TAudioMixer; var T: Integer);
begin T := Self.MixerCount; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerMixerCaps_R(Self: TAudioMixer; var T: TMixerCaps);
begin T := Self.MixerCaps; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerDestinations_R(Self: TAudioMixer; var T: TMixerDestinations);
begin T := Self.Destinations; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerOnControlChange_W(Self: TAudioMixer; const T: TMixerChange);
begin Self.OnControlChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerOnControlChange_R(Self: TAudioMixer; var T: TMixerChange);
begin T := Self.OnControlChange; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerOnLineChange_W(Self: TAudioMixer; const T: TMixerChange);
begin Self.OnLineChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerOnLineChange_R(Self: TAudioMixer; var T: TMixerChange);
begin T := Self.OnLineChange; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerMixerId_W(Self: TAudioMixer; const T: Integer);
begin Self.MixerId := T; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerMixerId_R(Self: TAudioMixer; var T: Integer);
begin T := Self.MixerId; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerProductName_R(Self: TAudioMixer; var T: string);
begin T := Self.ProductName; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerManufacturer_R(Self: TAudioMixer; var T: string);
begin T := Self.Manufacturer; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerNumberOfLine_R(Self: TAudioMixer; var T: Integer);
begin T := Self.NumberOfLine; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerProductId_R(Self: TAudioMixer; var T: WORD);
begin T := Self.ProductId; end;

(*----------------------------------------------------------------------------*)
procedure TAudioMixerDriverVersion_R(Self: TAudioMixer; var T: MMVERSION);
begin T := Self.DriverVersion; end;

(*----------------------------------------------------------------------------*)
procedure TMixerDestinationsDestination_R(Self: TMixerDestinations; var T: TMixerDestination; const t1: Integer);
begin T := Self.Destination[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMixerDestinationsCount_R(Self: TMixerDestinations; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TMixerDestinationData_R(Self: TMixerDestination; var T: TMixerLine);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TMixerDestinationControls_R(Self: TMixerDestination; var T: TMixerControls);
begin T := Self.Controls; end;

(*----------------------------------------------------------------------------*)
procedure TMixerDestinationConnections_R(Self: TMixerDestination; var T: TMixerConnections);
begin T := Self.Connections; end;

(*----------------------------------------------------------------------------*)
procedure TMixerConnectionsCount_R(Self: TMixerConnections; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TMixerConnectionsConnection_R(Self: TMixerConnections; var T: TMixerConnection; const t1: Integer);
begin T := Self.Connection[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMixerConnectionData_R(Self: TMixerConnection; var T: TMixerLine);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TMixerConnectionControls_R(Self: TMixerConnection; var T: TMixerControls);
begin T := Self.Controls; end;

(*----------------------------------------------------------------------------*)
procedure TMixerControlsCount_R(Self: TMixerControls; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TMixerControlsControl_R(Self: TMixerControls; var T: PMixerControl; const t1: Integer);
begin T := Self.Control[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPointerListOnFreeItem_W(Self: TPointerList; const T: TPListFreeItemNotify);
begin Self.OnFreeItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPointerListOnFreeItem_R(Self: TPointerList; var T: TPListFreeItemNotify);
begin T := Self.OnFreeItem; end;

(*----------------------------------------------------------------------------*)
procedure TPointerListPointer_R(Self: TPointerList; var T: Pointer; const t1: Integer);
begin T := Self.Pointer[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPointerListCount_R(Self: TPointerList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AMixer_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAudioMixer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAudioMixer) do begin
    RegisterConstructor(@TAudioMixer.Create, 'Create');
      RegisterMethod(@TAudioMixer.Destroy, 'Free');
      RegisterPropertyHelper(@TAudioMixerDriverVersion_R,nil,'DriverVersion');
    RegisterPropertyHelper(@TAudioMixerProductId_R,nil,'ProductId');
    RegisterPropertyHelper(@TAudioMixerNumberOfLine_R,nil,'NumberOfLine');
    RegisterPropertyHelper(@TAudioMixerManufacturer_R,nil,'Manufacturer');
    RegisterPropertyHelper(@TAudioMixerProductName_R,nil,'ProductName');
    RegisterPropertyHelper(@TAudioMixerMixerId_R,@TAudioMixerMixerId_W,'MixerId');
    RegisterPropertyHelper(@TAudioMixerOnLineChange_R,@TAudioMixerOnLineChange_W,'OnLineChange');
    RegisterPropertyHelper(@TAudioMixerOnControlChange_R,@TAudioMixerOnControlChange_W,'OnControlChange');
    RegisterMethod(@TAudioMixer.GetVolume, 'GetVolume');
    RegisterMethod(@TAudioMixer.SetVolume, 'SetVolume');
    RegisterMethod(@TAudioMixer.GetPeak, 'GetPeak');
    RegisterMethod(@TAudioMixer.GetMute, 'GetMute');
    RegisterMethod(@TAudioMixer.SetMute, 'SetMute');
    RegisterPropertyHelper(@TAudioMixerDestinations_R,nil,'Destinations');
    RegisterPropertyHelper(@TAudioMixerMixerCaps_R,nil,'MixerCaps');
    RegisterPropertyHelper(@TAudioMixerMixerCount_R,nil,'MixerCount');
    RegisterPropertyHelper(@TAudioMixerMixerHandle_R,nil,'MixerHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMixerDestinations(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMixerDestinations) do begin
    RegisterConstructor(@TMixerDestinations.Create, 'Create');
        RegisterMethod(@TMixerDestinations.Destroy, 'Free');
      RegisterPropertyHelper(@TMixerDestinationsCount_R,nil,'Count');
    RegisterPropertyHelper(@TMixerDestinationsDestination_R,nil,'Destination');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMixerDestination(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMixerDestination) do begin
    RegisterConstructor(@TMixerDestination.Create, 'Create');
        RegisterMethod(@TMixerDestination.Destroy, 'Free');
      RegisterPropertyHelper(@TMixerDestinationConnections_R,nil,'Connections');
    RegisterPropertyHelper(@TMixerDestinationControls_R,nil,'Controls');
    RegisterPropertyHelper(@TMixerDestinationData_R,nil,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMixerConnections(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMixerConnections) do begin
    RegisterConstructor(@TMixerConnections.Create, 'Create');
        RegisterMethod(@TMixerConnections.Destroy, 'Free');
      RegisterPropertyHelper(@TMixerConnectionsConnection_R,nil,'Connection');
    RegisterPropertyHelper(@TMixerConnectionsCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMixerConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMixerConnection) do begin
    RegisterConstructor(@TMixerConnection.Create, 'Create');
        RegisterMethod(@TMixerConnection.Destroy, 'Free');
      RegisterPropertyHelper(@TMixerConnectionControls_R,nil,'Controls');
    RegisterPropertyHelper(@TMixerConnectionData_R,nil,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMixerControls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMixerControls) do begin
    RegisterConstructor(@TMixerControls.Create, 'Create');
        RegisterMethod(@TMixerControls.Destroy, 'Free');
      RegisterPropertyHelper(@TMixerControlsControl_R,nil,'Control');
    RegisterPropertyHelper(@TMixerControlsCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPointerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPointerList) do begin
    RegisterConstructor(@TPointerList.Create, 'Create');
        RegisterMethod(@TPointerList.Destroy, 'Free');
      RegisterMethod(@TPointerList.Clear, 'Clear');
    RegisterMethod(@TPointerList.Add, 'Add');
    RegisterPropertyHelper(@TPointerListCount_R,nil,'Count');
    RegisterPropertyHelper(@TPointerListPointer_R,nil,'Pointer');
    RegisterPropertyHelper(@TPointerListOnFreeItem_R,@TPointerListOnFreeItem_W,'OnFreeItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AMixer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAudioMixer) do
  RIRegister_TPointerList(CL);
  RIRegister_TMixerControls(CL);
  RIRegister_TMixerConnection(CL);
  RIRegister_TMixerConnections(CL);
  RIRegister_TMixerDestination(CL);
  RIRegister_TMixerDestinations(CL);
  RIRegister_TAudioMixer(CL);
end;

 
 
{ TPSImport_AMixer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AMixer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AMixer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AMixer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AMixer(ri);
  //RIRegister_AMixer_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
