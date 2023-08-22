unit uPSI_Odometer;
{
odo path meter  for raspi   , res with digits

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
  TPSImport_Odometer = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOdometer(CL: TPSPascalCompiler);
procedure SIRegister_Odometer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Odometer_Routines(S: TPSExec);
procedure RIRegister_TOdometer(CL: TPSRuntimeClassImporter);
procedure RIRegister_Odometer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Controls
  ,extctrls
  ,Odometer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Odometer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOdometer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TOdometer') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TOdometer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Paint');
    RegisterMethod('Procedure Increase');
    RegisterMethod('Procedure Decrease');
    RegisterProperty('AnimationType', 'TAnimationType', iptrw);
    RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('Width', 'Integer', iptr);
    RegisterProperty('FrameInterval', 'byte', iptrw);
    RegisterProperty('BaseType', 'TBaseType', iptrw);
    RegisterProperty('DigitCount', 'byte', iptrw);
    RegisterProperty('Limit', 'Cardinal', iptr);
    RegisterProperty('IncTopToBottom', 'boolean', iptrw);
    RegisterProperty('Value', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Odometer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBaseType', '( btBinary, btDecimal, btHexadecimal )');
  CL.AddTypeS('TAnimationType', '( atNone, atSynchronous, atAsynchronous )');
  SIRegister_TOdometer(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOdometerValue_W(Self: TOdometer; const T: Cardinal);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerValue_R(Self: TOdometer; var T: Cardinal);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerIncTopToBottom_W(Self: TOdometer; const T: boolean);
begin Self.IncTopToBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerIncTopToBottom_R(Self: TOdometer; var T: boolean);
begin T := Self.IncTopToBottom; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerLimit_R(Self: TOdometer; var T: Cardinal);
begin T := Self.Limit; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerDigitCount_W(Self: TOdometer; const T: byte);
begin Self.DigitCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerDigitCount_R(Self: TOdometer; var T: byte);
begin T := Self.DigitCount; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerBaseType_W(Self: TOdometer; const T: TBaseType);
begin Self.BaseType := T; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerBaseType_R(Self: TOdometer; var T: TBaseType);
begin T := Self.BaseType; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerFrameInterval_W(Self: TOdometer; const T: byte);
begin Self.FrameInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerFrameInterval_R(Self: TOdometer; var T: byte);
begin T := Self.FrameInterval; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerWidth_R(Self: TOdometer; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerHeight_R(Self: TOdometer; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerAnimationType_W(Self: TOdometer; const T: TAnimationType);
begin Self.AnimationType := T; end;

(*----------------------------------------------------------------------------*)
procedure TOdometerAnimationType_R(Self: TOdometer; var T: TAnimationType);
begin T := Self.AnimationType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Odometer_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOdometer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOdometer) do begin
    RegisterConstructor(@TOdometer.Create, 'Create');
    RegisterMethod(@TOdometer.Destroy, 'Free');
    RegisterMethod(@TOdometer.Paint, 'Paint');
    RegisterMethod(@TOdometer.Increase, 'Increase');
    RegisterMethod(@TOdometer.Decrease, 'Decrease');
    RegisterPropertyHelper(@TOdometerAnimationType_R,@TOdometerAnimationType_W,'AnimationType');
    RegisterPropertyHelper(@TOdometerHeight_R,nil,'Height');
    RegisterPropertyHelper(@TOdometerWidth_R,nil,'Width');
    RegisterPropertyHelper(@TOdometerFrameInterval_R,@TOdometerFrameInterval_W,'FrameInterval');
    RegisterPropertyHelper(@TOdometerBaseType_R,@TOdometerBaseType_W,'BaseType');
    RegisterPropertyHelper(@TOdometerDigitCount_R,@TOdometerDigitCount_W,'DigitCount');
    RegisterPropertyHelper(@TOdometerLimit_R,nil,'Limit');
    RegisterPropertyHelper(@TOdometerIncTopToBottom_R,@TOdometerIncTopToBottom_W,'IncTopToBottom');
    RegisterPropertyHelper(@TOdometerValue_R,@TOdometerValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Odometer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOdometer(CL);
end;

 
 
{ TPSImport_Odometer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Odometer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Odometer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Odometer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Odometer(ri);
  //RIRegister_Odometer_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
