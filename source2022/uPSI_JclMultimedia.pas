unit uPSI_JclMultimedia;
{
  add free and overrides
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
  TPSImport_JclMultimedia = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EJclMciError(CL: TPSPascalCompiler);
procedure SIRegister_TJclMixer(CL: TPSPascalCompiler);
procedure SIRegister_TJclMixerDevice(CL: TPSPascalCompiler);
procedure SIRegister_TJclMixerDestination(CL: TPSPascalCompiler);
procedure SIRegister_TJclMixerSource(CL: TPSPascalCompiler);
procedure SIRegister_TJclMixerLine(CL: TPSPascalCompiler);
procedure SIRegister_TJclMixerLineControl(CL: TPSPascalCompiler);
procedure SIRegister_TJclMultimediaTimer(CL: TPSPascalCompiler);
procedure SIRegister_JclMultimedia(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EJclMciError(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclMultimedia_Routines(S: TPSExec);
procedure RIRegister_TJclMixer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMixerDevice(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMixerDestination(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMixerSource(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMixerLine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMixerLineControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMultimediaTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclMultimedia(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,MMSystem
  ,Contnrs
  ,JclBase
  ,JclSynch
  ,JclStrings
  ,JclMultimedia
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclMultimedia]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EJclMciError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EJclError', 'EJclMciError') do
  with CL.AddClassN(CL.FindClass('EJclError'),'EJclMciError') do begin
    RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create( MciErrNo : MCIERROR; const Msg : string)');
    RegisterMethod('Constructor CreateFmt( MciErrNo : MCIERROR; const Msg : string; const Args : array of const)');
    RegisterMethod('Constructor CreateRes( MciErrNo : MCIERROR; Ident : Integer)');
    RegisterProperty('MciErrorNo', 'DWORD', iptr);
    RegisterProperty('MciErrorMsg', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMixer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclMixer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclMixer') do begin
    RegisterMethod('Constructor Create( ACallBackWnd : HWND)');
    RegisterMethod('Procedure Free');
     RegisterProperty('CallbackWnd', 'HWND', iptr);
    RegisterProperty('Devices', 'TJclMixerDevice Integer', iptr);
    SetDefaultPropery('Devices');
    RegisterProperty('DeviceCount', 'Integer', iptr);
    RegisterProperty('FirstDevice', 'TJclMixerDevice', iptr);
    RegisterProperty('LineByID', 'TJclMixerLine HMIXER DWORD', iptr);
    RegisterProperty('LineControlByID', 'TJclMixerLineControl HMIXER DWORD', iptr);
    RegisterProperty('LineMute', 'Boolean Integer', iptrw);
    RegisterProperty('LineVolume', 'Cardinal Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMixerDevice(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclMixerDevice') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclMixerDevice') do begin
    RegisterMethod('Function FindLineControl( ComponentType, ControlType : DWORD) : TJclMixerLineControl');
    RegisterProperty('Capabilities', 'TMixerCaps', iptr);
    RegisterProperty('DeviceIndex', 'Cardinal', iptr);
    RegisterProperty('Destinations', 'TJclMixerDestination Integer', iptr);
    SetDefaultPropery('Destinations');
    RegisterProperty('DestinationCount', 'Integer', iptr);
    RegisterProperty('Handle', 'HMIXER', iptr);
    RegisterProperty('LineByID', 'TJclMixerLine DWORD', iptr);
    RegisterProperty('LineByComponentType', 'TJclMixerLine DWORD', iptr);
    RegisterProperty('Lines', 'TJclMixerLine Integer', iptr);
    RegisterProperty('LineCount', 'Integer', iptr);
    RegisterProperty('LineControlByID', 'TJclMixerLineControl DWORD', iptr);
    RegisterProperty('LineUniformValue', 'Cardinal DWORD DWORD', iptrw);
    RegisterProperty('ProductName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMixerDestination(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclMixerLine', 'TJclMixerDestination') do
  with CL.AddClassN(CL.FindClass('TJclMixerLine'),'TJclMixerDestination') do
  begin
    RegisterProperty('Sources', 'TJclMixerSource Integer', iptr);
    SetDefaultPropery('Sources');
    RegisterProperty('SourceCount', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMixerSource(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclMixerLine', 'TJclMixerSource') do
  with CL.AddClassN(CL.FindClass('TJclMixerLine'),'TJclMixerSource') do
  begin
    RegisterProperty('MixerDestination', 'TJclMixerDestination', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMixerLine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclMixerLine') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclMixerLine') do
  begin
    RegisterMethod('Function ComponentTypeToString( const ComponentType : DWORD) : string');
    RegisterProperty('ComponentString', 'string', iptr);
    RegisterProperty('HasControlType', 'Boolean DWORD', iptr);
    RegisterProperty('ID', 'DWORD', iptr);
    RegisterProperty('LineControlByType', 'TJclMixerLineControl DWORD', iptr);
    RegisterProperty('LineControls', 'TJclMixerLineControl Integer', iptr);
    SetDefaultPropery('LineControls');
    RegisterProperty('LineControlCount', 'Integer', iptr);
    RegisterProperty('LineInfo', 'TMixerLine', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('MixerDevice', 'TJclMixerDevice', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMixerLineControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclMixerLineControl') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclMixerLineControl') do
  begin
    RegisterMethod('Function FormatValue( AValue : Cardinal) : string');
    RegisterProperty('ControlInfo', 'TMixerControl', iptr);
    RegisterProperty('ID', 'DWORD', iptr);
    RegisterProperty('IsDisabled', 'Boolean', iptr);
    RegisterProperty('IsList', 'Boolean', iptr);
    RegisterProperty('IsMultiple', 'Boolean', iptr);
    RegisterProperty('IsUniform', 'Boolean', iptr);
    RegisterProperty('ListText', 'TStrings', iptr);
    RegisterProperty('MixerLine', 'TJclMixerLine', iptr);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('UniformValue', 'Cardinal', iptrw);
    RegisterProperty('Value', 'TDynCardinalArray', iptrw);
    RegisterProperty('ValueString', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMultimediaTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclMultimediaTimer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclMultimediaTimer') do begin
    RegisterMethod('Constructor Create( Kind : TMmTimerKind; Notification : TMmNotificationKind)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Function GetTime : Cardinal');
    RegisterMethod('Function BeginPeriod( const Period : Cardinal) : Boolean');
    RegisterMethod('Function EndPeriod( const Period : Cardinal) : Boolean');
    RegisterMethod('Procedure BeginTimer( const Delay, Resolution : Cardinal)');
    RegisterMethod('Procedure EndTimer');
    RegisterMethod('Function Elapsed( const Update : Boolean) : Cardinal');
    RegisterMethod('Function WaitFor( const TimeOut : Cardinal) : TJclWaitResult');
    RegisterProperty('Event', 'TJclEvent', iptr);
    RegisterProperty('Kind', 'TMmTimerKind', iptr);
    RegisterProperty('MaxPeriod', 'Cardinal', iptr);
    RegisterProperty('MinPeriod', 'Cardinal', iptr);
    RegisterProperty('Notification', 'TMmNotificationKind', iptr);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
    RegisterProperty('Period', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclMultimedia(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMmTimerKind', '( tkOneShot, tkPeriodic )');
  CL.AddTypeS('TMmNotificationKind', '( nkCallback, nkSetEvent, nkPulseEvent )');
  CL.AddTypeS('MCIERROR','DWORD');
  SIRegister_TJclMultimediaTimer(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclMmTimerError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclMixerError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclMixerDevice');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclMixerLine');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclMixerDestination');
  SIRegister_TJclMixerLineControl(CL);
  SIRegister_TJclMixerLine(CL);
  SIRegister_TJclMixerSource(CL);
  SIRegister_TJclMixerDestination(CL);
  SIRegister_TJclMixerDevice(CL);
  SIRegister_TJclMixer(CL);
 CL.AddDelphiFunction('Function MixerLeftRightToArray( Left, Right : Cardinal) : TDynCardinalArray');
  SIRegister_EJclMciError(CL);
 CL.AddDelphiFunction('Function MMCheck( const MciError : MCIERROR; const Msg : string) : MCIERROR');
 CL.AddDelphiFunction('Function GetMciErrorMessage( const MciErrNo : MCIERROR) : string');
 //CL.AddDelphiFunction('Function OpenCdMciDevice( var OpenParams : TMCI_Open_Parms; Drive : Char) : MCIERROR');
 //CL.AddDelphiFunction('Function CloseCdMciDevice( var OpenParams : TMCI_Open_Parms) : MCIERROR');
 CL.AddDelphiFunction('Procedure OpenCloseCdDrive( OpenMode : Boolean; Drive : Char)');
 CL.AddDelphiFunction('Function IsMediaPresentInDrive( Drive : Char) : Boolean');
  CL.AddTypeS('TJclCdMediaInfo', '( miProduct, miIdentity, miUPC )');
  CL.AddTypeS('TJclCdTrackType', '( ttAudio, ttOther )');
  CL.AddTypeS('TJclCdTrackInfo', 'record Minute : Byte; Second: Byte; TrackType: TJclCdTrackType; end');
  CL.AddTypeS('TJclCdTrackInfoArray', 'array of TJclCdTrackInfo');
 CL.AddDelphiFunction('Function GetCdInfo( InfoType : TJclCdMediaInfo; Drive : Char) : string');
 CL.AddDelphiFunction('Function GetCDAudioTrackList( var TrackList : TJclCdTrackInfoArray; Drive : Char) : TJclCdTrackInfo;');
 CL.AddDelphiFunction('Function GetCDAudioTrackList1( TrackList : TStrings; IncludeTrackType : Boolean; Drive : Char) : string;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function GetCDAudioTrackList1_P( TrackList : TStrings; IncludeTrackType : Boolean; Drive : Char) : string;
Begin Result := JclMultimedia.GetCDAudioTrackList(TrackList, IncludeTrackType, Drive); END;

(*----------------------------------------------------------------------------*)
Function GetCDAudioTrackList_P( var TrackList : TJclCdTrackInfoArray; Drive : Char) : TJclCdTrackInfo;
Begin Result := JclMultimedia.GetCDAudioTrackList(TrackList, Drive); END;

(*----------------------------------------------------------------------------*)
procedure EJclMciErrorMciErrorMsg_R(Self: EJclMciError; var T: string);
begin T := Self.MciErrorMsg; end;

(*----------------------------------------------------------------------------*)
procedure EJclMciErrorMciErrorNo_R(Self: EJclMciError; var T: DWORD);
begin T := Self.MciErrorNo; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineVolume_W(Self: TJclMixer; const T: Cardinal; const t1: Integer);
begin Self.LineVolume[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineVolume_R(Self: TJclMixer; var T: Cardinal; const t1: Integer);
begin T := Self.LineVolume[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineMute_W(Self: TJclMixer; const T: Boolean; const t1: Integer);
begin Self.LineMute[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineMute_R(Self: TJclMixer; var T: Boolean; const t1: Integer);
begin T := Self.LineMute[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlByID_R(Self: TJclMixer; var T: TJclMixerLineControl; const t1: HMIXER; const t2: DWORD);
begin T := Self.LineControlByID[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineByID_R(Self: TJclMixer; var T: TJclMixerLine; const t1: HMIXER; const t2: DWORD);
begin T := Self.LineByID[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerFirstDevice_R(Self: TJclMixer; var T: TJclMixerDevice);
begin T := Self.FirstDevice; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceCount_R(Self: TJclMixer; var T: Integer);
begin T := Self.DeviceCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDevices_R(Self: TJclMixer; var T: TJclMixerDevice; const t1: Integer);
begin T := Self.Devices[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerCallbackWnd_R(Self: TJclMixer; var T: HWND);
begin T := Self.CallbackWnd; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceProductName_R(Self: TJclMixerDevice; var T: string);
begin T := Self.ProductName; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceLineUniformValue_W(Self: TJclMixerDevice; const T: Cardinal; const t1: DWORD; const t2: DWORD);
begin Self.LineUniformValue[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceLineUniformValue_R(Self: TJclMixerDevice; var T: Cardinal; const t1: DWORD; const t2: DWORD);
begin T := Self.LineUniformValue[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceLineControlByID_R(Self: TJclMixerDevice; var T: TJclMixerLineControl; const t1: DWORD);
begin T := Self.LineControlByID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceLineCount_R(Self: TJclMixerDevice; var T: Integer);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceLines_R(Self: TJclMixerDevice; var T: TJclMixerLine; const t1: Integer);
begin T := Self.Lines[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceLineByComponentType_R(Self: TJclMixerDevice; var T: TJclMixerLine; const t1: DWORD);
begin T := Self.LineByComponentType[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceLineByID_R(Self: TJclMixerDevice; var T: TJclMixerLine; const t1: DWORD);
begin T := Self.LineByID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceHandle_R(Self: TJclMixerDevice; var T: HMIXER);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceDestinationCount_R(Self: TJclMixerDevice; var T: Integer);
begin T := Self.DestinationCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceDestinations_R(Self: TJclMixerDevice; var T: TJclMixerDestination; const t1: Integer);
begin T := Self.Destinations[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceDeviceIndex_R(Self: TJclMixerDevice; var T: Cardinal);
begin T := Self.DeviceIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDeviceCapabilities_R(Self: TJclMixerDevice; var T: TMixerCaps);
begin T := Self.Capabilities; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDestinationSourceCount_R(Self: TJclMixerDestination; var T: Integer);
begin T := Self.SourceCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerDestinationSources_R(Self: TJclMixerDestination; var T: TJclMixerSource; const t1: Integer);
begin T := Self.Sources[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerSourceMixerDestination_R(Self: TJclMixerSource; var T: TJclMixerDestination);
begin T := Self.MixerDestination; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineMixerDevice_R(Self: TJclMixerLine; var T: TJclMixerDevice);
begin T := Self.MixerDevice; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineName_R(Self: TJclMixerLine; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineLineInfo_R(Self: TJclMixerLine; var T: TMixerLine);
begin T := Self.LineInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineLineControlCount_R(Self: TJclMixerLine; var T: Integer);
begin T := Self.LineControlCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineLineControls_R(Self: TJclMixerLine; var T: TJclMixerLineControl; const t1: Integer);
begin T := Self.LineControls[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineLineControlByType_R(Self: TJclMixerLine; var T: TJclMixerLineControl; const t1: DWORD);
begin T := Self.LineControlByType[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineID_R(Self: TJclMixerLine; var T: DWORD);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineHasControlType_R(Self: TJclMixerLine; var T: Boolean; const t1: DWORD);
begin T := Self.HasControlType[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineComponentString_R(Self: TJclMixerLine; var T: string);
begin T := Self.ComponentString; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlValueString_R(Self: TJclMixerLineControl; var T: string);
begin T := Self.ValueString; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlValue_W(Self: TJclMixerLineControl; const T: TDynCardinalArray);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlValue_R(Self: TJclMixerLineControl; var T: TDynCardinalArray);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlUniformValue_W(Self: TJclMixerLineControl; const T: Cardinal);
begin Self.UniformValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlUniformValue_R(Self: TJclMixerLineControl; var T: Cardinal);
begin T := Self.UniformValue; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlName_R(Self: TJclMixerLineControl; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlMixerLine_R(Self: TJclMixerLineControl; var T: TJclMixerLine);
begin T := Self.MixerLine; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlListText_R(Self: TJclMixerLineControl; var T: TStrings);
begin T := Self.ListText; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlIsUniform_R(Self: TJclMixerLineControl; var T: Boolean);
begin T := Self.IsUniform; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlIsMultiple_R(Self: TJclMixerLineControl; var T: Boolean);
begin T := Self.IsMultiple; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlIsList_R(Self: TJclMixerLineControl; var T: Boolean);
begin T := Self.IsList; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlIsDisabled_R(Self: TJclMixerLineControl; var T: Boolean);
begin T := Self.IsDisabled; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlID_R(Self: TJclMixerLineControl; var T: DWORD);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TJclMixerLineControlControlInfo_R(Self: TJclMixerLineControl; var T: TMixerControl);
begin T := Self.ControlInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerPeriod_W(Self: TJclMultimediaTimer; const T: Cardinal);
begin Self.Period := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerPeriod_R(Self: TJclMultimediaTimer; var T: Cardinal);
begin T := Self.Period; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerOnTimer_W(Self: TJclMultimediaTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerOnTimer_R(Self: TJclMultimediaTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerNotification_R(Self: TJclMultimediaTimer; var T: TMmNotificationKind);
begin T := Self.Notification; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerMinPeriod_R(Self: TJclMultimediaTimer; var T: Cardinal);
begin T := Self.MinPeriod; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerMaxPeriod_R(Self: TJclMultimediaTimer; var T: Cardinal);
begin T := Self.MaxPeriod; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerKind_R(Self: TJclMultimediaTimer; var T: TMmTimerKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TJclMultimediaTimerEvent_R(Self: TJclMultimediaTimer; var T: TJclEvent);
begin T := Self.Event; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EJclMciError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclMciError) do begin
    RegisterConstructor(@EJclMciError.Create, 'Create');
       RegisterMethod(@EJclMciError.Destroy, 'Free');
     RegisterConstructor(@EJclMciError.CreateFmt, 'CreateFmt');
    RegisterConstructor(@EJclMciError.CreateRes, 'CreateRes');
    RegisterPropertyHelper(@EJclMciErrorMciErrorNo_R,nil,'MciErrorNo');
    RegisterPropertyHelper(@EJclMciErrorMciErrorMsg_R,nil,'MciErrorMsg');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMultimedia_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MixerLeftRightToArray, 'MixerLeftRightToArray', cdRegister);
 // RIRegister_EJclMciError(CL);
 S.RegisterDelphiFunction(@MMCheck, 'MMCheck', cdRegister);
 S.RegisterDelphiFunction(@GetMciErrorMessage, 'GetMciErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@OpenCdMciDevice, 'OpenCdMciDevice', cdRegister);
 S.RegisterDelphiFunction(@CloseCdMciDevice, 'CloseCdMciDevice', cdRegister);
 S.RegisterDelphiFunction(@OpenCloseCdDrive, 'OpenCloseCdDrive', cdRegister);
 S.RegisterDelphiFunction(@IsMediaPresentInDrive, 'IsMediaPresentInDrive', cdRegister);
 S.RegisterDelphiFunction(@GetCdInfo, 'GetCdInfo', cdRegister);
 S.RegisterDelphiFunction(@GetCDAudioTrackList, 'GetCDAudioTrackList', cdRegister);
 S.RegisterDelphiFunction(@GetCDAudioTrackList1_P, 'GetCDAudioTrackList1', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMixer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMixer) do begin
    RegisterConstructor(@TJclMixer.Create, 'Create');
       RegisterMethod(@TJclMixer.Destroy, 'Free');
     RegisterPropertyHelper(@TJclMixerCallbackWnd_R,nil,'CallbackWnd');
    RegisterPropertyHelper(@TJclMixerDevices_R,nil,'Devices');
    RegisterPropertyHelper(@TJclMixerDeviceCount_R,nil,'DeviceCount');
    RegisterPropertyHelper(@TJclMixerFirstDevice_R,nil,'FirstDevice');
    RegisterPropertyHelper(@TJclMixerLineByID_R,nil,'LineByID');
    RegisterPropertyHelper(@TJclMixerLineControlByID_R,nil,'LineControlByID');
    RegisterPropertyHelper(@TJclMixerLineMute_R,@TJclMixerLineMute_W,'LineMute');
    RegisterPropertyHelper(@TJclMixerLineVolume_R,@TJclMixerLineVolume_W,'LineVolume');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMixerDevice(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMixerDevice) do begin
    RegisterMethod(@TJclMixerDevice.FindLineControl, 'FindLineControl');
    RegisterPropertyHelper(@TJclMixerDeviceCapabilities_R,nil,'Capabilities');
    RegisterPropertyHelper(@TJclMixerDeviceDeviceIndex_R,nil,'DeviceIndex');
    RegisterPropertyHelper(@TJclMixerDeviceDestinations_R,nil,'Destinations');
    RegisterPropertyHelper(@TJclMixerDeviceDestinationCount_R,nil,'DestinationCount');
    RegisterPropertyHelper(@TJclMixerDeviceHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclMixerDeviceLineByID_R,nil,'LineByID');
    RegisterPropertyHelper(@TJclMixerDeviceLineByComponentType_R,nil,'LineByComponentType');
    RegisterPropertyHelper(@TJclMixerDeviceLines_R,nil,'Lines');
    RegisterPropertyHelper(@TJclMixerDeviceLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TJclMixerDeviceLineControlByID_R,nil,'LineControlByID');
    RegisterPropertyHelper(@TJclMixerDeviceLineUniformValue_R,@TJclMixerDeviceLineUniformValue_W,'LineUniformValue');
    RegisterPropertyHelper(@TJclMixerDeviceProductName_R,nil,'ProductName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMixerDestination(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMixerDestination) do
  begin
    RegisterPropertyHelper(@TJclMixerDestinationSources_R,nil,'Sources');
    RegisterPropertyHelper(@TJclMixerDestinationSourceCount_R,nil,'SourceCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMixerSource(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMixerSource) do
  begin
    RegisterPropertyHelper(@TJclMixerSourceMixerDestination_R,nil,'MixerDestination');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMixerLine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMixerLine) do begin
    RegisterMethod(@TJclMixerLine.ComponentTypeToString, 'ComponentTypeToString');
    RegisterPropertyHelper(@TJclMixerLineComponentString_R,nil,'ComponentString');
    RegisterPropertyHelper(@TJclMixerLineHasControlType_R,nil,'HasControlType');
    RegisterPropertyHelper(@TJclMixerLineID_R,nil,'ID');
    RegisterPropertyHelper(@TJclMixerLineLineControlByType_R,nil,'LineControlByType');
    RegisterPropertyHelper(@TJclMixerLineLineControls_R,nil,'LineControls');
    RegisterPropertyHelper(@TJclMixerLineLineControlCount_R,nil,'LineControlCount');
    RegisterPropertyHelper(@TJclMixerLineLineInfo_R,nil,'LineInfo');
    RegisterPropertyHelper(@TJclMixerLineName_R,nil,'Name');
    RegisterPropertyHelper(@TJclMixerLineMixerDevice_R,nil,'MixerDevice');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMixerLineControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMixerLineControl) do begin
    RegisterMethod(@TJclMixerLineControl.FormatValue, 'FormatValue');
    RegisterPropertyHelper(@TJclMixerLineControlControlInfo_R,nil,'ControlInfo');
    RegisterPropertyHelper(@TJclMixerLineControlID_R,nil,'ID');
    RegisterPropertyHelper(@TJclMixerLineControlIsDisabled_R,nil,'IsDisabled');
    RegisterPropertyHelper(@TJclMixerLineControlIsList_R,nil,'IsList');
    RegisterPropertyHelper(@TJclMixerLineControlIsMultiple_R,nil,'IsMultiple');
    RegisterPropertyHelper(@TJclMixerLineControlIsUniform_R,nil,'IsUniform');
    RegisterPropertyHelper(@TJclMixerLineControlListText_R,nil,'ListText');
    RegisterPropertyHelper(@TJclMixerLineControlMixerLine_R,nil,'MixerLine');
    RegisterPropertyHelper(@TJclMixerLineControlName_R,nil,'Name');
    RegisterPropertyHelper(@TJclMixerLineControlUniformValue_R,@TJclMixerLineControlUniformValue_W,'UniformValue');
    RegisterPropertyHelper(@TJclMixerLineControlValue_R,@TJclMixerLineControlValue_W,'Value');
    RegisterPropertyHelper(@TJclMixerLineControlValueString_R,nil,'ValueString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMultimediaTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMultimediaTimer) do begin
    RegisterConstructor(@TJclMultimediaTimer.Create, 'Create');
       RegisterMethod(@TJclMultimediaTimer.Destroy, 'Free');
     RegisterMethod(@TJclMultimediaTimer.GetTime, 'GetTime');
    RegisterMethod(@TJclMultimediaTimer.BeginPeriod, 'BeginPeriod');
    RegisterMethod(@TJclMultimediaTimer.EndPeriod, 'EndPeriod');
    RegisterMethod(@TJclMultimediaTimer.BeginTimer, 'BeginTimer');
    RegisterMethod(@TJclMultimediaTimer.EndTimer, 'EndTimer');
    RegisterMethod(@TJclMultimediaTimer.Elapsed, 'Elapsed');
    RegisterMethod(@TJclMultimediaTimer.WaitFor, 'WaitFor');
    RegisterPropertyHelper(@TJclMultimediaTimerEvent_R,nil,'Event');
    RegisterPropertyHelper(@TJclMultimediaTimerKind_R,nil,'Kind');
    RegisterPropertyHelper(@TJclMultimediaTimerMaxPeriod_R,nil,'MaxPeriod');
    RegisterPropertyHelper(@TJclMultimediaTimerMinPeriod_R,nil,'MinPeriod');
    RegisterPropertyHelper(@TJclMultimediaTimerNotification_R,nil,'Notification');
    RegisterPropertyHelper(@TJclMultimediaTimerOnTimer_R,@TJclMultimediaTimerOnTimer_W,'OnTimer');
    RegisterPropertyHelper(@TJclMultimediaTimerPeriod_R,@TJclMultimediaTimerPeriod_W,'Period');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMultimedia(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclMultimediaTimer(CL);
  with CL.Add(EJclMmTimerError) do
  with CL.Add(EJclMixerError) do
  with CL.Add(TJclMixerDevice) do
  with CL.Add(TJclMixerLine) do
  with CL.Add(TJclMixerDestination) do
  RIRegister_TJclMixerLineControl(CL);
  RIRegister_TJclMixerLine(CL);
  RIRegister_TJclMixerSource(CL);
  RIRegister_TJclMixerDestination(CL);
  RIRegister_TJclMixerDevice(CL);
  RIRegister_TJclMixer(CL);
end;

 
 
{ TPSImport_JclMultimedia }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMultimedia.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclMultimedia(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMultimedia.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclMultimedia(ri);
  RIRegister_JclMultimedia_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
