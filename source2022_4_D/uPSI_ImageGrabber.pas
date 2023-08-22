unit uPSI_ImageGrabber;
{
   needs video for windows    API
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
  TPSImport_ImageGrabber = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TCaptureDriver(CL: TPSPascalCompiler);
procedure SIRegister_TCaptureDrivers(CL: TPSPascalCompiler);
procedure SIRegister_TImageGrabber(CL: TPSPascalCompiler);
procedure SIRegister_ImageGrabber(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCaptureDriver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCaptureDrivers(CL: TPSRuntimeClassImporter);
procedure RIRegister_TImageGrabber(CL: TPSRuntimeClassImporter);
procedure RIRegister_ImageGrabber(CL: TPSRuntimeClassImporter);

function getVideoDrivers: string;


procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,VFW
  ,ImageGrabber
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ImageGrabber]);
end;

function getVideoDrivers: string;
//var   ImageGrabber: TImageGrabber;
  var counter: integer;
  ImageGrabber: TImageGrabber;
  alist: TStringlist;
begin
   //result:= false;
   ImageGrabber:= TImageGrabber.Create;
   alist:= TStringlist.create;
  { verfügbare Video-Aufnahmetreiber in das das Kombinationsfeld }
  { CaptureDriverComboBox eintragen }
{  for Counter:= 0 to ImageGrabber.CaptureDrivers.Count - 1 do begin
    CaptureDriverComboBox.Items.Add(
      ImageGrabber.CaptureDrivers[Counter].Name);
    if ImageGrabber.CaptureDrivers[Counter].Selected then
      CaptureDriverComboBox.ItemIndex:= Counter;
  end; }
  for Counter:= 0 to ImageGrabber.CaptureDrivers.Count - 1 do begin
    alist.add(inttoStr(counter) + '  '+ImageGrabber.CaptureDrivers[Counter].Name);
    //if ImageGrabber.CaptureDrivers[Counter].Selected then
      //CaptureDriverComboBox.ItemIndex:= Counter;
  end;
  if counter > 0 then result:= alist.text;
  ImageGrabber.Free;
  alist.Free;
  //ImageGrabber.CaptureDrivers[CaptureDriverComboBox.ItemIndex].Select;
   //if ImageGrabber.CaptureDrivers[0].Selected then
     //ImageGrabber.CaptureDrivers[ImageGrabber.CaptureDrivers[0]].Select;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCaptureDriver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TCaptureDriver') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TCaptureDriver') do
  begin
    RegisterMethod('Procedure Select');
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('Version', 'string', iptr);
    RegisterProperty('Selected', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCaptureDrivers(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TCaptureDrivers') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TCaptureDrivers') do
  begin
    RegisterMethod('Constructor Create( ImageGrabber : TImageGrabber)');
    RegisterMethod('Function Add : TCaptureDriver');
    RegisterProperty('Items', 'TCaptureDriver Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TImageGrabber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TImageGrabber') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TImageGrabber') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure OpenDialog( Dialog : TCaptureDriverDialog)');
    RegisterMethod('Function Grab : TBitmap');
    RegisterProperty('CaptureDrivers', 'TCaptureDrivers', iptr);
    RegisterProperty('SupportedDialogs', 'TCaptureDriverDialogs', iptr);
    RegisterProperty('VideoFormat', 'string', iptr);
    RegisterProperty('VideoFormatSupported', 'Boolean', iptr);
    RegisterProperty('Width', 'Cardinal', iptr);
    RegisterProperty('Height', 'Cardinal', iptr);
    RegisterProperty('Connected', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ImageGrabber(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCaptureDriverDialog', '( cddDisplay, cddFormat, cddSource )');
  CL.AddTypeS('TCaptureDriverDialogs', 'set of TCaptureDriverDialog');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCaptureDrivers');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCaptureDriver');
  SIRegister_TImageGrabber(CL);
  SIRegister_TCaptureDrivers(CL);
  SIRegister_TCaptureDriver(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EImageGrabber');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECouldNotCreateCaptureWindow');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAlreadyConnected');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECaptureDriverNotConnected');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ENoCaptureDriverSelected');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECouldNotConnectToCaptureDriver');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECouldNotDisconnectFromCaptureDriver');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ENoCodecForVideoFormat');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EUnableToCreateBitmap');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECodecError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EGrabError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ECouldNotOpenDialog');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCaptureDriverSelected_W(Self: TCaptureDriver; const T: Boolean);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCaptureDriverSelected_R(Self: TCaptureDriver; var T: Boolean);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TCaptureDriverVersion_R(Self: TCaptureDriver; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TCaptureDriverName_R(Self: TCaptureDriver; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TCaptureDriversItems_R(Self: TCaptureDrivers; var T: TCaptureDriver; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TImageGrabberConnected_R(Self: TImageGrabber; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TImageGrabberHeight_R(Self: TImageGrabber; var T: Cardinal);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TImageGrabberWidth_R(Self: TImageGrabber; var T: Cardinal);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TImageGrabberVideoFormatSupported_R(Self: TImageGrabber; var T: Boolean);
begin T := Self.VideoFormatSupported; end;

(*----------------------------------------------------------------------------*)
procedure TImageGrabberVideoFormat_R(Self: TImageGrabber; var T: string);
begin T := Self.VideoFormat; end;

(*----------------------------------------------------------------------------*)
procedure TImageGrabberSupportedDialogs_R(Self: TImageGrabber; var T: TCaptureDriverDialogs);
begin T := Self.SupportedDialogs; end;

(*----------------------------------------------------------------------------*)
procedure TImageGrabberCaptureDrivers_R(Self: TImageGrabber; var T: TCaptureDrivers);
begin T := Self.CaptureDrivers; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCaptureDriver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCaptureDriver) do
  begin
    RegisterMethod(@TCaptureDriver.Select, 'Select');
    RegisterPropertyHelper(@TCaptureDriverName_R,nil,'Name');
    RegisterPropertyHelper(@TCaptureDriverVersion_R,nil,'Version');
    RegisterPropertyHelper(@TCaptureDriverSelected_R,@TCaptureDriverSelected_W,'Selected');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCaptureDrivers(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCaptureDrivers) do
  begin
    RegisterConstructor(@TCaptureDrivers.Create, 'Create');
    RegisterMethod(@TCaptureDrivers.Add, 'Add');
    RegisterPropertyHelper(@TCaptureDriversItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImageGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImageGrabber) do begin
    RegisterConstructor(@TImageGrabber.Create, 'Create');
    RegisterMethod(@TImageGrabber.Destroy, 'Free');
     RegisterMethod(@TImageGrabber.Connect, 'Connect');
    RegisterMethod(@TImageGrabber.Disconnect, 'Disconnect');
    RegisterMethod(@TImageGrabber.OpenDialog, 'OpenDialog');
    RegisterMethod(@TImageGrabber.Grab, 'Grab');
    RegisterPropertyHelper(@TImageGrabberCaptureDrivers_R,nil,'CaptureDrivers');
    RegisterPropertyHelper(@TImageGrabberSupportedDialogs_R,nil,'SupportedDialogs');
    RegisterPropertyHelper(@TImageGrabberVideoFormat_R,nil,'VideoFormat');
    RegisterPropertyHelper(@TImageGrabberVideoFormatSupported_R,nil,'VideoFormatSupported');
    RegisterPropertyHelper(@TImageGrabberWidth_R,nil,'Width');
    RegisterPropertyHelper(@TImageGrabberHeight_R,nil,'Height');
    RegisterPropertyHelper(@TImageGrabberConnected_R,nil,'Connected');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ImageGrabber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCaptureDrivers) do
  with CL.Add(TCaptureDriver) do
  RIRegister_TImageGrabber(CL);
  RIRegister_TCaptureDrivers(CL);
  RIRegister_TCaptureDriver(CL);
  with CL.Add(EImageGrabber) do
  with CL.Add(ECouldNotCreateCaptureWindow) do
  with CL.Add(EAlreadyConnected) do
  with CL.Add(ECaptureDriverNotConnected) do
  with CL.Add(ENoCaptureDriverSelected) do
  with CL.Add(ECouldNotConnectToCaptureDriver) do
  with CL.Add(ECouldNotDisconnectFromCaptureDriver) do
  with CL.Add(ENoCodecForVideoFormat) do
  with CL.Add(EUnableToCreateBitmap) do
  with CL.Add(ECodecError) do
  with CL.Add(EGrabError) do
  with CL.Add(ECouldNotOpenDialog) do
end;

 
 
{ TPSImport_ImageGrabber }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImageGrabber.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ImageGrabber(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImageGrabber.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ImageGrabber(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
