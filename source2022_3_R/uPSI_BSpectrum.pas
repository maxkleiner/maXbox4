unit uPSI_BSpectrum;
{
 with spec lib

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
  TPSImport_BSpectrum = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBSpectrum(CL: TPSPascalCompiler);
procedure SIRegister_BSpectrum(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BSpectrum_Routines(S: TPSExec);
procedure RIRegister_TBSpectrum(CL: TPSRuntimeClassImporter);
procedure RIRegister_BSpectrum(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,BSpectrum
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BSpectrum]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBSpectrum(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TBSpectrum') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TBSpectrum') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Paint');
    RegisterProperty('Interval', 'Boolean', iptrw);
    RegisterProperty('IntervalDelta', 'Integer', iptrw);
    RegisterProperty('PhotoPlateOrder', 'Boolean', iptrw);
    RegisterProperty('Kind', 'TSpectrumKind', iptrw);
    RegisterProperty('OnMouseMove', 'TspMM', iptrw);
    registerpublishedproperties;
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BSpectrum(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('LongWord', 'Integer');
  CL.AddTypeS('Nanometers', 'Double');
  CL.AddTypeS('TSpectrumKind', '( skVisible, skEmission, skAbsorption )');
  CL.AddTypeS('TSpMM', 'Procedure ( Shift : TShiftState; X, Y : Integer; R, G, B : Byte)');
  SIRegister_TBSpectrum(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBSpectrumOnMouseMove_W(Self: TBSpectrum; const T: TspMM);
begin Self.OnMouseMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumOnMouseMove_R(Self: TBSpectrum; var T: TspMM);
begin T := Self.OnMouseMove; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumKind_W(Self: TBSpectrum; const T: TSpectrumKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumKind_R(Self: TBSpectrum; var T: TSpectrumKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumPhotoPlateOrder_W(Self: TBSpectrum; const T: Boolean);
begin Self.PhotoPlateOrder := T; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumPhotoPlateOrder_R(Self: TBSpectrum; var T: Boolean);
begin T := Self.PhotoPlateOrder; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumIntervalDelta_W(Self: TBSpectrum; const T: Integer);
begin Self.IntervalDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumIntervalDelta_R(Self: TBSpectrum; var T: Integer);
begin T := Self.IntervalDelta; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumInterval_W(Self: TBSpectrum; const T: Boolean);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TBSpectrumInterval_R(Self: TBSpectrum; var T: Boolean);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BSpectrum_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBSpectrum(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBSpectrum) do begin
    RegisterConstructor(@TBSpectrum.Create, 'Create');
     RegisterMethod(@TBSpectrum.Destroy, 'Free');
    RegisterMethod(@TBSpectrum.Paint, 'Paint');
    RegisterPropertyHelper(@TBSpectrumInterval_R,@TBSpectrumInterval_W,'Interval');
    RegisterPropertyHelper(@TBSpectrumIntervalDelta_R,@TBSpectrumIntervalDelta_W,'IntervalDelta');
    RegisterPropertyHelper(@TBSpectrumPhotoPlateOrder_R,@TBSpectrumPhotoPlateOrder_W,'PhotoPlateOrder');
    RegisterPropertyHelper(@TBSpectrumKind_R,@TBSpectrumKind_W,'Kind');
    RegisterPropertyHelper(@TBSpectrumOnMouseMove_R,@TBSpectrumOnMouseMove_W,'OnMouseMove');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BSpectrum(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBSpectrum(CL);
end;

 
 
{ TPSImport_BSpectrum }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BSpectrum.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BSpectrum(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BSpectrum.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BSpectrum(ri);
  RIRegister_BSpectrum_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
