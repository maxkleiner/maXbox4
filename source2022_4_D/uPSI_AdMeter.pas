unit uPSI_AdMeter;
{
T   from asyncpro

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
  TPSImport_AdMeter = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TApdMeter(CL: TPSPascalCompiler);
procedure SIRegister_AdMeter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TApdMeter(CL: TPSRuntimeClassImporter);
procedure RIRegister_AdMeter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Menus
  ,Dialogs
  ,OoMisc
  ,AdMeter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AdMeter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TApdMeter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TApdBaseGraphicControl', 'TApdMeter') do
 // with CL.AddClassN(CL.FindClass('TApdBaseGraphicControl'),'TApdMeter') do
   with CL.AddClassN(CL.FindClass('TGraphicControl'),'TApdMeter') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterProperty('BarColor', 'TColor', iptrw);
    RegisterProperty('BevelColor1', 'TColor', iptrw);
    RegisterProperty('BevelColor2', 'TColor', iptrw);
    RegisterProperty('BevelStyle', 'TBevelStyle', iptrw);
    RegisterProperty('Max', 'Integer', iptrw);
    RegisterProperty('Min', 'Integer', iptrw);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('Step', 'Integer', iptrw);
    RegisterProperty('OnPosChange', 'TNotifyEvent', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
      RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGN', 'TAlignment', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AdMeter(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('admDefBarColor','longint').SetInt( clHighlight);
 CL.AddConstantN('admDefBevelColor1','longint').SetInt( clBtnHighlight);
 CL.AddConstantN('admDefBevelColor2','longint').SetInt( clBtnShadow);
 CL.AddConstantN('admDefMeterHeight','LongInt').SetInt( 16);
 CL.AddConstantN('admDefMax','LongInt').SetInt( 100);
 CL.AddConstantN('admDefMin','LongInt').SetInt( 0);
 CL.AddConstantN('admDefStep','LongInt').SetInt( 8);
 CL.AddConstantN('admDefMeterWidth','LongInt').SetInt( 150);
  CL.AddTypeS('TBevelStyle2', '( bsLowered, bsRaised, bsNone )');
  SIRegister_TApdMeter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TApdMeterOnPosChange_W(Self: TApdMeter; const T: TNotifyEvent);
begin Self.OnPosChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterOnPosChange_R(Self: TApdMeter; var T: TNotifyEvent);
begin T := Self.OnPosChange; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterStep_W(Self: TApdMeter; const T: Integer);
begin Self.Step := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterStep_R(Self: TApdMeter; var T: Integer);
begin T := Self.Step; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterPosition_W(Self: TApdMeter; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterPosition_R(Self: TApdMeter; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterMin_W(Self: TApdMeter; const T: Integer);
begin Self.Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterMin_R(Self: TApdMeter; var T: Integer);
begin T := Self.Min; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterMax_W(Self: TApdMeter; const T: Integer);
begin Self.Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterMax_R(Self: TApdMeter; var T: Integer);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBevelStyle_W(Self: TApdMeter; const T: TBevelStyle);
begin Self.BevelStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBevelStyle_R(Self: TApdMeter; var T: TBevelStyle);
begin T := Self.BevelStyle; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBevelColor2_W(Self: TApdMeter; const T: TColor);
begin Self.BevelColor2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBevelColor2_R(Self: TApdMeter; var T: TColor);
begin T := Self.BevelColor2; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBevelColor1_W(Self: TApdMeter; const T: TColor);
begin Self.BevelColor1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBevelColor1_R(Self: TApdMeter; var T: TColor);
begin T := Self.BevelColor1; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBarColor_W(Self: TApdMeter; const T: TColor);
begin Self.BarColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TApdMeterBarColor_R(Self: TApdMeter; var T: TColor);
begin T := Self.BarColor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApdMeter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApdMeter) do
  begin
    RegisterConstructor(@TApdMeter.Create, 'Create');
    RegisterMethod(@TApdMeter.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TApdMeterBarColor_R,@TApdMeterBarColor_W,'BarColor');
    RegisterPropertyHelper(@TApdMeterBevelColor1_R,@TApdMeterBevelColor1_W,'BevelColor1');
    RegisterPropertyHelper(@TApdMeterBevelColor2_R,@TApdMeterBevelColor2_W,'BevelColor2');
    RegisterPropertyHelper(@TApdMeterBevelStyle_R,@TApdMeterBevelStyle_W,'BevelStyle');
    RegisterPropertyHelper(@TApdMeterMax_R,@TApdMeterMax_W,'Max');
    RegisterPropertyHelper(@TApdMeterMin_R,@TApdMeterMin_W,'Min');
    RegisterPropertyHelper(@TApdMeterPosition_R,@TApdMeterPosition_W,'Position');
    RegisterPropertyHelper(@TApdMeterStep_R,@TApdMeterStep_W,'Step');
    RegisterPropertyHelper(@TApdMeterOnPosChange_R,@TApdMeterOnPosChange_W,'OnPosChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AdMeter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TApdMeter(CL);
end;

 
 
{ TPSImport_AdMeter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdMeter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AdMeter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdMeter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AdMeter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
