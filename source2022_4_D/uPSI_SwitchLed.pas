unit uPSI_SwitchLed;
{
   led with res
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
  TPSImport_SwitchLed = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSwitchLed(CL: TPSPascalCompiler);
procedure SIRegister_SwitchLed(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SwitchLed_Routines(S: TPSExec);
procedure RIRegister_TSwitchLed(CL: TPSRuntimeClassImporter);
procedure RIRegister_SwitchLed(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Graphics
  ,Menus
  ,SwitchLed
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SwitchLed]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSwitchLed(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TSwitchLed') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TSwitchLed') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterMethod('Function IntToLedColor( Int : Byte) : TLedColor');
    RegisterMethod('Function LedColorToInt( LedColor : TLedColor) : Byte');
    RegisterProperty('Version', 'String', iptr);
    RegisterProperty('Author', 'String', iptr);
    RegisterProperty('OnColor', 'TLedColor', iptrw);
    RegisterProperty('OffColor', 'TLedColor', iptrw);
    RegisterProperty('DisabledColor', 'TLedColor', iptrw);
    RegisterProperty('LedState', 'TTLedState', iptrw);
    RegisterProperty('AllowChanges', 'Boolean', iptrw);
    RegisterPublishedProperties;
      RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('onclick', 'TNotifyEvent', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('ondblclick', 'TNotifyEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SwitchLed(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLedColor', '( Aqua, Pink, Purple, Red, Yellow, Green, Blue, Orange, Black )');
  CL.AddTypeS('TTLedState', '( LedOn, LedOff, LedDisabled )');
  SIRegister_TSwitchLed(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSwitchLedAllowChanges_W(Self: TSwitchLed; const T: Boolean);
begin Self.AllowChanges := T; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedAllowChanges_R(Self: TSwitchLed; var T: Boolean);
begin T := Self.AllowChanges; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedLedState_W(Self: TSwitchLed; const T: TLedState);
begin Self.LedState := T; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedLedState_R(Self: TSwitchLed; var T: TLedState);
begin T := Self.LedState; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedDisabledColor_W(Self: TSwitchLed; const T: TLedColor);
begin Self.DisabledColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedDisabledColor_R(Self: TSwitchLed; var T: TLedColor);
begin T := Self.DisabledColor; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedOffColor_W(Self: TSwitchLed; const T: TLedColor);
begin Self.OffColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedOffColor_R(Self: TSwitchLed; var T: TLedColor);
begin T := Self.OffColor; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedOnColor_W(Self: TSwitchLed; const T: TLedColor);
begin Self.OnColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedOnColor_R(Self: TSwitchLed; var T: TLedColor);
begin T := Self.OnColor; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedAuthor_R(Self: TSwitchLed; var T: String);
begin T := Self.Author; end;

(*----------------------------------------------------------------------------*)
procedure TSwitchLedVersion_R(Self: TSwitchLed; var T: String);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SwitchLed_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSwitchLed(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSwitchLed) do
  begin
    RegisterConstructor(@TSwitchLed.Create, 'Create');
    RegisterMethod(@TSwitchLed.Paint, 'Paint');
    RegisterMethod(@TSwitchLed.IntToLedColor, 'IntToLedColor');
    RegisterMethod(@TSwitchLed.LedColorToInt, 'LedColorToInt');
    RegisterPropertyHelper(@TSwitchLedVersion_R,nil,'Version');
    RegisterPropertyHelper(@TSwitchLedAuthor_R,nil,'Author');
    RegisterPropertyHelper(@TSwitchLedOnColor_R,@TSwitchLedOnColor_W,'OnColor');
    RegisterPropertyHelper(@TSwitchLedOffColor_R,@TSwitchLedOffColor_W,'OffColor');
    RegisterPropertyHelper(@TSwitchLedDisabledColor_R,@TSwitchLedDisabledColor_W,'DisabledColor');
    RegisterPropertyHelper(@TSwitchLedLedState_R,@TSwitchLedLedState_W,'LedState');
    RegisterPropertyHelper(@TSwitchLedAllowChanges_R,@TSwitchLedAllowChanges_W,'AllowChanges');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SwitchLed(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSwitchLed(CL);
end;

 
 
{ TPSImport_SwitchLed }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SwitchLed.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SwitchLed(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SwitchLed.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SwitchLed(ri);
  RIRegister_SwitchLed_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
