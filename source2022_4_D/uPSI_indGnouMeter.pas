unit uPSI_indGnouMeter;
{
   for industrial 4
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
  TPSImport_indGnouMeter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TindGnouMeter(CL: TPSPascalCompiler);
procedure SIRegister_indGnouMeter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TindGnouMeter(CL: TPSRuntimeClassImporter);
procedure RIRegister_indGnouMeter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Graphics
  ,Messages
  ,Types
  //,LCLIntf
  ,indGnouMeter
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_indGnouMeter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TindGnouMeter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TindGnouMeter') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TindGnouMeter') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
      RegisterProperty('Value', 'Double', iptrw);
    RegisterProperty('ColorFore', 'Tcolor', iptrw);
    RegisterProperty('ColorBack', 'Tcolor', iptrw);
    RegisterProperty('SignalUnit', 'String', iptrw);
    RegisterProperty('ValueMin', 'Double', iptrw);
    RegisterProperty('ValueMax', 'Double', iptrw);
    RegisterProperty('Digits', 'Byte', iptrw);
    RegisterProperty('Increment', 'Double', iptrw);
    RegisterProperty('ShowIncrements', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('GapTop', 'Word', iptrw);
    RegisterProperty('GapBottom', 'Word', iptrw);
    RegisterProperty('BarThickness', 'Word', iptrw);
    RegisterProperty('MarkerColor', 'TColor', iptrw);
    RegisterProperty('ShowMarker', 'Boolean', iptrw);
        RegisterpublishedProperties;
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('CANVAS', 'TCanvas', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_indGnouMeter(CL: TPSPascalCompiler);
begin
  SIRegister_TindGnouMeter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TindGnouMeterShowMarker_W(Self: TindGnouMeter; const T: Boolean);
begin Self.ShowMarker := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterShowMarker_R(Self: TindGnouMeter; var T: Boolean);
begin T := Self.ShowMarker; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterMarkerColor_W(Self: TindGnouMeter; const T: TColor);
begin Self.MarkerColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterMarkerColor_R(Self: TindGnouMeter; var T: TColor);
begin T := Self.MarkerColor; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterBarThickness_W(Self: TindGnouMeter; const T: Word);
begin Self.BarThickness := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterBarThickness_R(Self: TindGnouMeter; var T: Word);
begin T := Self.BarThickness; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterGapBottom_W(Self: TindGnouMeter; const T: Word);
begin Self.GapBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterGapBottom_R(Self: TindGnouMeter; var T: Word);
begin T := Self.GapBottom; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterGapTop_W(Self: TindGnouMeter; const T: Word);
begin Self.GapTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterGapTop_R(Self: TindGnouMeter; var T: Word);
begin T := Self.GapTop; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterTransparent_W(Self: TindGnouMeter; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterTransparent_R(Self: TindGnouMeter; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterShowIncrements_W(Self: TindGnouMeter; const T: Boolean);
begin Self.ShowIncrements := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterShowIncrements_R(Self: TindGnouMeter; var T: Boolean);
begin T := Self.ShowIncrements; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterIncrement_W(Self: TindGnouMeter; const T: Double);
begin Self.Increment := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterIncrement_R(Self: TindGnouMeter; var T: Double);
begin T := Self.Increment; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterDigits_W(Self: TindGnouMeter; const T: Byte);
begin Self.Digits := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterDigits_R(Self: TindGnouMeter; var T: Byte);
begin T := Self.Digits; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterValueMax_W(Self: TindGnouMeter; const T: Double);
begin Self.ValueMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterValueMax_R(Self: TindGnouMeter; var T: Double);
begin T := Self.ValueMax; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterValueMin_W(Self: TindGnouMeter; const T: Double);
begin Self.ValueMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterValueMin_R(Self: TindGnouMeter; var T: Double);
begin T := Self.ValueMin; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterSignalUnit_W(Self: TindGnouMeter; const T: ShortString);
begin Self.SignalUnit := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterSignalUnit_R(Self: TindGnouMeter; var T: ShortString);
begin T := Self.SignalUnit; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterColorBack_W(Self: TindGnouMeter; const T: Tcolor);
begin Self.ColorBack := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterColorBack_R(Self: TindGnouMeter; var T: Tcolor);
begin T := Self.ColorBack; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterColorFore_W(Self: TindGnouMeter; const T: Tcolor);
begin Self.ColorFore := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterColorFore_R(Self: TindGnouMeter; var T: Tcolor);
begin T := Self.ColorFore; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterValue_W(Self: TindGnouMeter; const T: Double);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TindGnouMeterValue_R(Self: TindGnouMeter; var T: Double);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TindGnouMeter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TindGnouMeter) do begin
    RegisterConstructor(@TindGnouMeter.Create, 'Create');
       RegisterMethod(@TindGnouMeter.Destroy, 'Free');
     RegisterPropertyHelper(@TindGnouMeterValue_R,@TindGnouMeterValue_W,'Value');
    RegisterPropertyHelper(@TindGnouMeterColorFore_R,@TindGnouMeterColorFore_W,'ColorFore');
    RegisterPropertyHelper(@TindGnouMeterColorBack_R,@TindGnouMeterColorBack_W,'ColorBack');
    RegisterPropertyHelper(@TindGnouMeterSignalUnit_R,@TindGnouMeterSignalUnit_W,'SignalUnit');
    RegisterPropertyHelper(@TindGnouMeterValueMin_R,@TindGnouMeterValueMin_W,'ValueMin');
    RegisterPropertyHelper(@TindGnouMeterValueMax_R,@TindGnouMeterValueMax_W,'ValueMax');
    RegisterPropertyHelper(@TindGnouMeterDigits_R,@TindGnouMeterDigits_W,'Digits');
    RegisterPropertyHelper(@TindGnouMeterIncrement_R,@TindGnouMeterIncrement_W,'Increment');
    RegisterPropertyHelper(@TindGnouMeterShowIncrements_R,@TindGnouMeterShowIncrements_W,'ShowIncrements');
    RegisterPropertyHelper(@TindGnouMeterTransparent_R,@TindGnouMeterTransparent_W,'Transparent');
    RegisterPropertyHelper(@TindGnouMeterGapTop_R,@TindGnouMeterGapTop_W,'GapTop');
    RegisterPropertyHelper(@TindGnouMeterGapBottom_R,@TindGnouMeterGapBottom_W,'GapBottom');
    RegisterPropertyHelper(@TindGnouMeterBarThickness_R,@TindGnouMeterBarThickness_W,'BarThickness');
    RegisterPropertyHelper(@TindGnouMeterMarkerColor_R,@TindGnouMeterMarkerColor_W,'MarkerColor');
    RegisterPropertyHelper(@TindGnouMeterShowMarker_R,@TindGnouMeterShowMarker_W,'ShowMarker');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_indGnouMeter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TindGnouMeter(CL);
end;

 
 
{ TPSImport_indGnouMeter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_indGnouMeter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_indGnouMeter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_indGnouMeter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_indGnouMeter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
