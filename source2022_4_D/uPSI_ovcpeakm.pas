unit uPSI_ovcpeakm;
{
   peak box
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
  TPSImport_ovcpeakm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcPeakMeter(CL: TPSPascalCompiler);
procedure SIRegister_ovcpeakm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcPeakMeter(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcpeakm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Graphics
  ,Forms
  ,Messages
  ,OvcBase
  ,ExtCtrls
  ,ovcpeakm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcpeakm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcPeakMeter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcGraphicControl', 'TOvcPeakMeter') do
  with CL.AddClassN(CL.FindClass('TOvcGraphicControl'),'TOvcPeakMeter') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Peak', 'Integer', iptrw);
    RegisterProperty('BackgroundColor', 'TColor', iptrw);
    RegisterProperty('BarColor', 'TColor', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('Ctl3D', 'Boolean', iptrw);
    RegisterProperty('GridColor', 'TColor', iptrw);
    RegisterProperty('MarginBottom', 'Integer', iptrw);
    RegisterProperty('MarginLeft', 'Integer', iptrw);
    RegisterProperty('MarginRight', 'Integer', iptrw);
    RegisterProperty('MarginTop', 'Integer', iptrw);
    RegisterProperty('PeakColor', 'TColor', iptrw);
    RegisterProperty('ShowValues', 'Boolean', iptrw);
    RegisterProperty('Style', 'TOvcPmStyle', iptrw);
    RegisterProperty('Value', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcpeakm(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcPmStyle', '( pmBar, pmHistoryPoint )');
  SIRegister_TOvcPeakMeter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterValue_W(Self: TOvcPeakMeter; const T: Integer);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterValue_R(Self: TOvcPeakMeter; var T: Integer);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterStyle_W(Self: TOvcPeakMeter; const T: TOvcPmStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterStyle_R(Self: TOvcPeakMeter; var T: TOvcPmStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterShowValues_W(Self: TOvcPeakMeter; const T: Boolean);
begin Self.ShowValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterShowValues_R(Self: TOvcPeakMeter; var T: Boolean);
begin T := Self.ShowValues; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterPeakColor_W(Self: TOvcPeakMeter; const T: TColor);
begin Self.PeakColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterPeakColor_R(Self: TOvcPeakMeter; var T: TColor);
begin T := Self.PeakColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginTop_W(Self: TOvcPeakMeter; const T: Integer);
begin Self.MarginTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginTop_R(Self: TOvcPeakMeter; var T: Integer);
begin T := Self.MarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginRight_W(Self: TOvcPeakMeter; const T: Integer);
begin Self.MarginRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginRight_R(Self: TOvcPeakMeter; var T: Integer);
begin T := Self.MarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginLeft_W(Self: TOvcPeakMeter; const T: Integer);
begin Self.MarginLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginLeft_R(Self: TOvcPeakMeter; var T: Integer);
begin T := Self.MarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginBottom_W(Self: TOvcPeakMeter; const T: Integer);
begin Self.MarginBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterMarginBottom_R(Self: TOvcPeakMeter; var T: Integer);
begin T := Self.MarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterGridColor_W(Self: TOvcPeakMeter; const T: TColor);
begin Self.GridColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterGridColor_R(Self: TOvcPeakMeter; var T: TColor);
begin T := Self.GridColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterCtl3D_W(Self: TOvcPeakMeter; const T: Boolean);
begin Self.Ctl3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterCtl3D_R(Self: TOvcPeakMeter; var T: Boolean);
begin T := Self.Ctl3D; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterBorderStyle_W(Self: TOvcPeakMeter; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterBorderStyle_R(Self: TOvcPeakMeter; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterBarColor_W(Self: TOvcPeakMeter; const T: TColor);
begin Self.BarColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterBarColor_R(Self: TOvcPeakMeter; var T: TColor);
begin T := Self.BarColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterBackgroundColor_W(Self: TOvcPeakMeter; const T: TColor);
begin Self.BackgroundColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterBackgroundColor_R(Self: TOvcPeakMeter; var T: TColor);
begin T := Self.BackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterPeak_W(Self: TOvcPeakMeter; const T: Integer);
begin Self.Peak := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPeakMeterPeak_R(Self: TOvcPeakMeter; var T: Integer);
begin T := Self.Peak; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcPeakMeter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcPeakMeter) do
  begin
    RegisterConstructor(@TOvcPeakMeter.Create, 'Create');
    RegisterPropertyHelper(@TOvcPeakMeterPeak_R,@TOvcPeakMeterPeak_W,'Peak');
    RegisterPropertyHelper(@TOvcPeakMeterBackgroundColor_R,@TOvcPeakMeterBackgroundColor_W,'BackgroundColor');
    RegisterPropertyHelper(@TOvcPeakMeterBarColor_R,@TOvcPeakMeterBarColor_W,'BarColor');
    RegisterPropertyHelper(@TOvcPeakMeterBorderStyle_R,@TOvcPeakMeterBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TOvcPeakMeterCtl3D_R,@TOvcPeakMeterCtl3D_W,'Ctl3D');
    RegisterPropertyHelper(@TOvcPeakMeterGridColor_R,@TOvcPeakMeterGridColor_W,'GridColor');
    RegisterPropertyHelper(@TOvcPeakMeterMarginBottom_R,@TOvcPeakMeterMarginBottom_W,'MarginBottom');
    RegisterPropertyHelper(@TOvcPeakMeterMarginLeft_R,@TOvcPeakMeterMarginLeft_W,'MarginLeft');
    RegisterPropertyHelper(@TOvcPeakMeterMarginRight_R,@TOvcPeakMeterMarginRight_W,'MarginRight');
    RegisterPropertyHelper(@TOvcPeakMeterMarginTop_R,@TOvcPeakMeterMarginTop_W,'MarginTop');
    RegisterPropertyHelper(@TOvcPeakMeterPeakColor_R,@TOvcPeakMeterPeakColor_W,'PeakColor');
    RegisterPropertyHelper(@TOvcPeakMeterShowValues_R,@TOvcPeakMeterShowValues_W,'ShowValues');
    RegisterPropertyHelper(@TOvcPeakMeterStyle_R,@TOvcPeakMeterStyle_W,'Style');
    RegisterPropertyHelper(@TOvcPeakMeterValue_R,@TOvcPeakMeterValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcpeakm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcPeakMeter(CL);
end;

 
 
{ TPSImport_ovcpeakm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcpeakm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcpeakm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcpeakm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcpeakm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
