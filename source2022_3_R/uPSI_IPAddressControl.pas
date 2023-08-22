unit uPSI_IPAddressControl;
{
T as a component or regex

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
  TPSImport_IPAddressControl = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIPAddressControl(CL: TPSPascalCompiler);
procedure SIRegister_TCustomIPAddressControl(CL: TPSPascalCompiler);
procedure SIRegister_TIPAddressField(CL: TPSPascalCompiler);
procedure SIRegister_TIPAddrRange(CL: TPSPascalCompiler);
procedure SIRegister_IPAddressControl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IPAddressControl_Routines(S: TPSExec);
procedure RIRegister_TIPAddressControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomIPAddressControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIPAddressField(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIPAddrRange(CL: TPSRuntimeClassImporter);
procedure RIRegister_IPAddressControl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,CommCtrl
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ComCtrls
  ,stdctrls
  ,IPAddressControl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IPAddressControl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPAddressControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIPAddressControl', 'TIPAddressControl') do
  with CL.AddClassN(CL.FindClass('TCustomIPAddressControl'),'TIPAddressControl') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomIPAddressControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomIPAddressControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomIPAddressControl') do begin
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
     RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('procedure DefaultHandler(var Message);');
    RegisterProperty('OnEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExit', 'TNotifyEvent', iptrw);
    RegisterProperty('IsBlank', 'boolean', iptrw);
    RegisterProperty('OnRangeError', 'TRangeErrorEvent', iptrw);
    RegisterProperty('IPAddress', 'String', iptrw);
    RegisterProperty('Modified', 'Boolean', iptr);
    RegisterProperty('Field0', 'Integer', iptrw);
    RegisterProperty('Field1', 'Integer', iptrw);
    RegisterProperty('Field2', 'Integer', iptrw);
    RegisterProperty('Field3', 'Integer', iptrw);
    RegisterProperty('RangeField0', 'TIPAddrRange', iptrw);
    RegisterProperty('RangeFiled1', 'TIPAddrRange', iptrw);
    RegisterProperty('RangeField2', 'TIPAddrRange', iptrw);
    RegisterProperty('RangeFiled3', 'TIPAddrRange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPAddressField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIPAddressField') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIPAddressField') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent; AAddrID : Integer)');
     RegisterMethod('Procedure Free');
    RegisterProperty('Range', 'TIPAddrRange', iptrw);
    RegisterProperty('Digit', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIPAddrRange(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIPAddrRange') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIPAddrRange') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('LowerLimit', 'Byte', iptrw);
    RegisterProperty('UpperLimit', 'Byte', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IPAddressControl(CL: TPSPascalCompiler);
begin
  SIRegister_TIPAddrRange(CL);
  SIRegister_TIPAddressField(CL);
  CL.AddTypeS('TRangeErrorEvent', 'Procedure ( Sender : TObject; var IPRange : '
   +'TIPAddrRange; Value, Field : Integer)');
  SIRegister_TCustomIPAddressControl(CL);
  SIRegister_TIPAddressControl(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeFiled3_W(Self: TCustomIPAddressControl; const T: TIPAddrRange);
begin Self.RangeFiled3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeFiled3_R(Self: TCustomIPAddressControl; var T: TIPAddrRange);
begin T := Self.RangeFiled3; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeField2_W(Self: TCustomIPAddressControl; const T: TIPAddrRange);
begin Self.RangeField2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeField2_R(Self: TCustomIPAddressControl; var T: TIPAddrRange);
begin T := Self.RangeField2; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeFiled1_W(Self: TCustomIPAddressControl; const T: TIPAddrRange);
begin Self.RangeFiled1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeFiled1_R(Self: TCustomIPAddressControl; var T: TIPAddrRange);
begin T := Self.RangeFiled1; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeField0_W(Self: TCustomIPAddressControl; const T: TIPAddrRange);
begin Self.RangeField0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlRangeField0_R(Self: TCustomIPAddressControl; var T: TIPAddrRange);
begin T := Self.RangeField0; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField3_W(Self: TCustomIPAddressControl; const T: Integer);
begin Self.Field3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField3_R(Self: TCustomIPAddressControl; var T: Integer);
begin T := Self.Field3; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField2_W(Self: TCustomIPAddressControl; const T: Integer);
begin Self.Field2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField2_R(Self: TCustomIPAddressControl; var T: Integer);
begin T := Self.Field2; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField1_W(Self: TCustomIPAddressControl; const T: Integer);
begin Self.Field1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField1_R(Self: TCustomIPAddressControl; var T: Integer);
begin T := Self.Field1; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField0_W(Self: TCustomIPAddressControl; const T: Integer);
begin Self.Field0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlField0_R(Self: TCustomIPAddressControl; var T: Integer);
begin T := Self.Field0; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlModified_R(Self: TCustomIPAddressControl; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlIPAddress_W(Self: TCustomIPAddressControl; const T: String);
begin Self.IPAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlIPAddress_R(Self: TCustomIPAddressControl; var T: String);
begin T := Self.IPAddress; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnRangeError_W(Self: TCustomIPAddressControl; const T: TRangeErrorEvent);
begin Self.OnRangeError := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnRangeError_R(Self: TCustomIPAddressControl; var T: TRangeErrorEvent);
begin T := Self.OnRangeError; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlIsBlank_W(Self: TCustomIPAddressControl; const T: boolean);
begin Self.IsBlank := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlIsBlank_R(Self: TCustomIPAddressControl; var T: boolean);
begin T := Self.IsBlank; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnExit_W(Self: TCustomIPAddressControl; const T: TNotifyEvent);
begin Self.OnExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnExit_R(Self: TCustomIPAddressControl; var T: TNotifyEvent);
begin T := Self.OnExit; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnEnter_W(Self: TCustomIPAddressControl; const T: TNotifyEvent);
begin Self.OnEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnEnter_R(Self: TCustomIPAddressControl; var T: TNotifyEvent);
begin T := Self.OnEnter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnChange_W(Self: TCustomIPAddressControl; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIPAddressControlOnChange_R(Self: TCustomIPAddressControl; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddressFieldDigit_W(Self: TIPAddressField; const T: Integer);
begin Self.Digit := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddressFieldDigit_R(Self: TIPAddressField; var T: Integer);
begin T := Self.Digit; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddressFieldRange_W(Self: TIPAddressField; const T: TIPAddrRange);
begin Self.Range := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddressFieldRange_R(Self: TIPAddressField; var T: TIPAddrRange);
begin T := Self.Range; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddrRangeUpperLimit_W(Self: TIPAddrRange; const T: Byte);
begin Self.UpperLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddrRangeUpperLimit_R(Self: TIPAddrRange; var T: Byte);
begin T := Self.UpperLimit; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddrRangeLowerLimit_W(Self: TIPAddrRange; const T: Byte);
begin Self.LowerLimit := T; end;

(*----------------------------------------------------------------------------*)
procedure TIPAddrRangeLowerLimit_R(Self: TIPAddrRange; var T: Byte);
begin T := Self.LowerLimit; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IPAddressControl_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPAddressControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPAddressControl) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomIPAddressControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomIPAddressControl) do begin
    RegisterConstructor(@TCustomIPAddressControl.Create, 'Create');
     RegisterMethod(@TCustomIPAddressControl.Destroy, 'Free');
     RegisterMethod(@TCustomIPAddressControl.DefaultHandler, 'DefaultHandler');

    RegisterPropertyHelper(@TCustomIPAddressControlOnChange_R,@TCustomIPAddressControlOnChange_W,'OnChange');
    RegisterPropertyHelper(@TCustomIPAddressControlOnEnter_R,@TCustomIPAddressControlOnEnter_W,'OnEnter');
    RegisterPropertyHelper(@TCustomIPAddressControlOnExit_R,@TCustomIPAddressControlOnExit_W,'OnExit');
    RegisterPropertyHelper(@TCustomIPAddressControlIsBlank_R,@TCustomIPAddressControlIsBlank_W,'IsBlank');
    RegisterPropertyHelper(@TCustomIPAddressControlOnRangeError_R,@TCustomIPAddressControlOnRangeError_W,'OnRangeError');
    RegisterPropertyHelper(@TCustomIPAddressControlIPAddress_R,@TCustomIPAddressControlIPAddress_W,'IPAddress');
    RegisterPropertyHelper(@TCustomIPAddressControlModified_R,nil,'Modified');
    RegisterPropertyHelper(@TCustomIPAddressControlField0_R,@TCustomIPAddressControlField0_W,'Field0');
    RegisterPropertyHelper(@TCustomIPAddressControlField1_R,@TCustomIPAddressControlField1_W,'Field1');
    RegisterPropertyHelper(@TCustomIPAddressControlField2_R,@TCustomIPAddressControlField2_W,'Field2');
    RegisterPropertyHelper(@TCustomIPAddressControlField3_R,@TCustomIPAddressControlField3_W,'Field3');
    RegisterPropertyHelper(@TCustomIPAddressControlRangeField0_R,@TCustomIPAddressControlRangeField0_W,'RangeField0');
    RegisterPropertyHelper(@TCustomIPAddressControlRangeFiled1_R,@TCustomIPAddressControlRangeFiled1_W,'RangeFiled1');
    RegisterPropertyHelper(@TCustomIPAddressControlRangeField2_R,@TCustomIPAddressControlRangeField2_W,'RangeField2');
    RegisterPropertyHelper(@TCustomIPAddressControlRangeFiled3_R,@TCustomIPAddressControlRangeFiled3_W,'RangeFiled3');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPAddressField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPAddressField) do begin
    RegisterConstructor(@TIPAddressField.Create, 'Create');
     RegisterMethod(@TIPAddressField.Destroy, 'Free');
    RegisterPropertyHelper(@TIPAddressFieldRange_R,@TIPAddressFieldRange_W,'Range');
    RegisterPropertyHelper(@TIPAddressFieldDigit_R,@TIPAddressFieldDigit_W,'Digit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIPAddrRange(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIPAddrRange) do
  begin
    RegisterConstructor(@TIPAddrRange.Create, 'Create');
    RegisterPropertyHelper(@TIPAddrRangeLowerLimit_R,@TIPAddrRangeLowerLimit_W,'LowerLimit');
    RegisterPropertyHelper(@TIPAddrRangeUpperLimit_R,@TIPAddrRangeUpperLimit_W,'UpperLimit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IPAddressControl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIPAddrRange(CL);
  RIRegister_TIPAddressField(CL);
  RIRegister_TCustomIPAddressControl(CL);
  RIRegister_TIPAddressControl(CL);
end;

 
 
{ TPSImport_IPAddressControl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IPAddressControl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IPAddressControl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IPAddressControl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IPAddressControl(ri);
  RIRegister_IPAddressControl_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
