unit uPSI_ovcmeter;
{
  met
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
  TPSImport_ovcmeter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcMeter(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCustomMeter(CL: TPSPascalCompiler);
procedure SIRegister_ovcmeter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcMeter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCustomMeter(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcmeter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Graphics
  ,Forms
  ,Messages
  ,OvcBase
  ,OvcMisc
  ,ExtCtrls
  ,ovcmeter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcmeter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcMeter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcCustomMeter', 'TOvcMeter') do
  with CL.AddClassN(CL.FindClass('TOvcCustomMeter'),'TOvcMeter') do begin
    REgisterPublishedProperties;
     RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCustomMeter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcGraphicControl', 'TOvcCustomMeter') do
  with CL.AddClassN(CL.FindClass('TOvcGraphicControl'),'TOvcCustomMeter') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free)');
     RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
      RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('Ctl3D', 'Boolean', iptrw);
    RegisterProperty('InvertPercent', 'Boolean', iptrw);
    RegisterProperty('Orientation', 'TMeterOrientation', iptrw);
    RegisterProperty('ShowPercent', 'boolean', iptrw);
    RegisterProperty('UnusedColor', 'TColor', iptrw);
    RegisterProperty('UnusedImage', 'TBitmap', iptrw);
    RegisterProperty('UsedColor', 'TColor', iptrw);
    RegisterProperty('UsedImage', 'TBitmap', iptrw);
    RegisterProperty('Percent', 'Integer', iptrw);
    RegisterProperty('OnOwnerDraw', 'TOvcOwnerDrawMeterEvent', iptrw);
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcmeter(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcOwnerDrawMeterEvent','Procedure (Canvas:TCanvas; Rec: TRect)');
  CL.AddTypeS('TMeterOrientation', '( moHorizontal, moVertical )');
  SIRegister_TOvcCustomMeter(CL);
  SIRegister_TOvcMeter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterOnOwnerDraw_W(Self: TOvcCustomMeter; const T: TOvcOwnerDrawMeterEvent);
begin Self.OnOwnerDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterOnOwnerDraw_R(Self: TOvcCustomMeter; var T: TOvcOwnerDrawMeterEvent);
begin T := Self.OnOwnerDraw; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterPercent_W(Self: TOvcCustomMeter; const T: Integer);
begin Self.Percent := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterPercent_R(Self: TOvcCustomMeter; var T: Integer);
begin T := Self.Percent; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUsedImage_W(Self: TOvcCustomMeter; const T: TBitmap);
begin Self.UsedImage := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUsedImage_R(Self: TOvcCustomMeter; var T: TBitmap);
begin T := Self.UsedImage; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUsedColor_W(Self: TOvcCustomMeter; const T: TColor);
begin Self.UsedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUsedColor_R(Self: TOvcCustomMeter; var T: TColor);
begin T := Self.UsedColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUnusedImage_W(Self: TOvcCustomMeter; const T: TBitmap);
begin Self.UnusedImage := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUnusedImage_R(Self: TOvcCustomMeter; var T: TBitmap);
begin T := Self.UnusedImage; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUnusedColor_W(Self: TOvcCustomMeter; const T: TColor);
begin Self.UnusedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterUnusedColor_R(Self: TOvcCustomMeter; var T: TColor);
begin T := Self.UnusedColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterShowPercent_W(Self: TOvcCustomMeter; const T: boolean);
begin Self.ShowPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterShowPercent_R(Self: TOvcCustomMeter; var T: boolean);
begin T := Self.ShowPercent; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterOrientation_W(Self: TOvcCustomMeter; const T: TMeterOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterOrientation_R(Self: TOvcCustomMeter; var T: TMeterOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterInvertPercent_W(Self: TOvcCustomMeter; const T: Boolean);
begin Self.InvertPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterInvertPercent_R(Self: TOvcCustomMeter; var T: Boolean);
begin T := Self.InvertPercent; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterCtl3D_W(Self: TOvcCustomMeter; const T: Boolean);
begin Self.Ctl3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterCtl3D_R(Self: TOvcCustomMeter; var T: Boolean);
begin T := Self.Ctl3D; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterBorderStyle_W(Self: TOvcCustomMeter; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomMeterBorderStyle_R(Self: TOvcCustomMeter; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

procedure TOvcMeterParent_W(Self: TOvcMeter; const T: TWincontrol);
begin Self.parent:= T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMeterParent_R(Self: TOvcMeter; var T: TWinControl);
begin T:= Self.Parent; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcMeter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcMeter) do begin
      RegisterPropertyHelper(@TOvcMeterParent_R,@TOvcMeterParent_W,'Parent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCustomMeter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCustomMeter) do begin
    RegisterConstructor(@TOvcCustomMeter.Create, 'Create');
    RegisterMethod(@TOvcCustomMeter.Free, 'Free');
    RegisterMethod(@TOvcCustomMeter.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TOvcCustomMeterBorderStyle_R,@TOvcCustomMeterBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TOvcCustomMeterCtl3D_R,@TOvcCustomMeterCtl3D_W,'Ctl3D');
    RegisterPropertyHelper(@TOvcCustomMeterInvertPercent_R,@TOvcCustomMeterInvertPercent_W,'InvertPercent');
    RegisterPropertyHelper(@TOvcCustomMeterOrientation_R,@TOvcCustomMeterOrientation_W,'Orientation');
    RegisterPropertyHelper(@TOvcCustomMeterShowPercent_R,@TOvcCustomMeterShowPercent_W,'ShowPercent');
    RegisterPropertyHelper(@TOvcCustomMeterUnusedColor_R,@TOvcCustomMeterUnusedColor_W,'UnusedColor');
    RegisterPropertyHelper(@TOvcCustomMeterUnusedImage_R,@TOvcCustomMeterUnusedImage_W,'UnusedImage');
    RegisterPropertyHelper(@TOvcCustomMeterUsedColor_R,@TOvcCustomMeterUsedColor_W,'UsedColor');
    RegisterPropertyHelper(@TOvcCustomMeterUsedImage_R,@TOvcCustomMeterUsedImage_W,'UsedImage');
    RegisterPropertyHelper(@TOvcCustomMeterPercent_R,@TOvcCustomMeterPercent_W,'Percent');
    RegisterPropertyHelper(@TOvcCustomMeterOnOwnerDraw_R,@TOvcCustomMeterOnOwnerDraw_W,'OnOwnerDraw');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcmeter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcCustomMeter(CL);
  RIRegister_TOvcMeter(CL);
end;

 
 
{ TPSImport_ovcmeter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcmeter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcmeter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcmeter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcmeter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
