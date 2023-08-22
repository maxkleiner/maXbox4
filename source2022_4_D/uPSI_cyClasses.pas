unit uPSI_cyClasses;
{
  the last class is mass
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
  TPSImport_cyClasses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyImagelistOptions(CL: TPSPascalCompiler);
procedure SIRegister_tcyBevels(CL: TPSPascalCompiler);
procedure SIRegister_tcyBevel(CL: TPSPascalCompiler);
procedure SIRegister_TcyGradient(CL: TPSPascalCompiler);
procedure SIRegister_TcyBgPicture(CL: TPSPascalCompiler);
procedure SIRegister_TcyShadowText(CL: TPSPascalCompiler);
procedure SIRegister_TcyRunTimeDesign(CL: TPSPascalCompiler);
procedure SIRegister_cyClasses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyClasses_Routines(S: TPSExec);
procedure RIRegister_TcyImagelistOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_tcyBevels(CL: TPSRuntimeClassImporter);
procedure RIRegister_tcyBevel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyBgPicture(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyShadowText(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyRunTimeDesign(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyClasses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Buttons
  ,Graphics
  ,Math
  ,Controls
  ,ExtCtrls
  ,StdCtrls
  ,Jpeg
  ,cyTypes
  ,cyGraphics
  ,cyClasses
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyClasses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyImagelistOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TcyImagelistOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TcyImagelistOptions') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure GetDrawingParams( State : TButtonState; var ImageIndexParam : Integer; var EnabledParam : Boolean)');
    RegisterProperty('DisabledIndex', 'Integer', iptrw);
    RegisterProperty('ExclusiveIndex', 'Integer', iptrw);
    RegisterProperty('MouseDownIndex', 'Integer', iptrw);
    RegisterProperty('NormalIndex', 'Integer', iptrw);
    RegisterProperty('ImageList', 'TImageList', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_tcyBevels(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'tcyBevels') do
  with CL.AddClassN(CL.FindClass('TCollection'),'tcyBevels') do
  begin
    RegisterMethod('Constructor Create( aControl : TControl; BevelClass : TcyBevelClass)');
    RegisterMethod('Function Add : TcyBevel');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure DrawBevels( aCanvas : TCanvas; var BoundsRect : TRect; RoundRect : Boolean)');
    RegisterMethod('Function BevelsWidth : Word');
    RegisterProperty('Items', 'TcyBevel Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('NeedOwnerRealign', 'Boolean', iptr);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_tcyBevel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'tcyBevel') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'tcyBevel') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('DrawLeft', 'Boolean', iptrw);
    RegisterProperty('DrawTop', 'Boolean', iptrw);
    RegisterProperty('DrawRight', 'Boolean', iptrw);
    RegisterProperty('DrawBottom', 'Boolean', iptrw);
    RegisterProperty('HighlightColor', 'TColor', iptrw);
    RegisterProperty('ShadowColor', 'TColor', iptrw);
    RegisterProperty('Style', 'TcyBevelCut', iptrw);
    RegisterProperty('Width', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TcyGradient') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TcyGradient') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Draw( aCanvas : TCanvas; aRect : TRect)');
    RegisterProperty('AngleClipRect', 'Boolean', iptrw);
    RegisterProperty('AngleDegree', 'Word', iptrw);
    RegisterProperty('Balance', 'Word', iptrw);
    RegisterProperty('BalanceMode', 'TDgradBalanceMode', iptrw);
    RegisterProperty('FromColor', 'TColor', iptrw);
    RegisterProperty('MaxDegrade', 'byte', iptrw);
    RegisterProperty('Orientation', 'TDgradOrientation', iptrw);
    RegisterProperty('SpeedPercent', 'Integer', iptrw);
    RegisterProperty('ToColor', 'TColor', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyBgPicture(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TcyBgPicture') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TcyBgPicture') do  begin
     RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function SomethingToDraw : Boolean');
    RegisterProperty('IndentX', 'Integer', iptrw);
    RegisterProperty('IndentY', 'Integer', iptrw);
    RegisterProperty('IntervalX', 'Integer', iptrw);
    RegisterProperty('IntervalY', 'Integer', iptrw);
    RegisterProperty('RepeatX', 'Word', iptrw);
    RegisterProperty('RepeatY', 'Word', iptrw);
    RegisterProperty('Picture', 'TPicture', iptrw);
    RegisterProperty('Position', 'TBgPosition', iptrw);
    RegisterProperty('Style', 'TBgStyle', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyShadowText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TcyShadowText') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TcyShadowText') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function Active : boolean');
    RegisterMethod('Function CalcShadowRect( CaptionRect : TRect; Alignment : TAlignment; Layout : TTextLayout; NormalFontHeight : Integer) : TRect');
    RegisterMethod('Procedure DrawShadowText( Canvas : TCanvas; NormalCaptionRect : TRect; Caption : String; Alignment : TAlignment; Layout : TTextLayout; CaptionOrientation : TCaptionOrientation; TextFormat : Longint)');
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('ZoomPercent', 'Word', iptrw);
    RegisterProperty('RelativePosX', 'Integer', iptrw);
    RegisterProperty('RelativePosY', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyRunTimeDesign(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TcyRunTimeDesign') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TcyRunTimeDesign') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function DetermineJobAtPos( X, Y : Integer) : TRunTimeDesignJob');
    RegisterMethod('Procedure StartJob( X, Y : Integer)');
    RegisterMethod('Procedure DoJob( X, Y : Integer)');
    RegisterMethod('Procedure EndJob( X, Y : Integer)');
    RegisterProperty('Control', 'TControl', iptrw);
    RegisterProperty('Job', 'TRunTimeDesignJob', iptrw);
    RegisterProperty('JobAtPos', 'TRunTimeDesignJob', iptrw);
    RegisterProperty('AllowMove', 'Boolean', iptrw);
    RegisterProperty('AllowResizeTop', 'Boolean', iptrw);
    RegisterProperty('AllowResizeLeft', 'Boolean', iptrw);
    RegisterProperty('AllowResizeRight', 'Boolean', iptrw);
    RegisterProperty('AllowResizeBottom', 'Boolean', iptrw);
    RegisterProperty('OutsideParentRect', 'Boolean', iptrw);
    RegisterProperty('ResizeBorderSize', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyClasses(CL: TPSPascalCompiler);
begin
  SIRegister_TcyRunTimeDesign(CL);
  SIRegister_TcyShadowText(CL);
  SIRegister_TcyBgPicture(CL);
  SIRegister_TcyGradient(CL);
  SIRegister_tcyBevel(CL);
  //CL.AddTypeS('TcyBevelClass', 'class of tcyBevel');
  SIRegister_tcyBevels(CL);
  SIRegister_TcyImagelistOptions(CL);
 CL.AddDelphiFunction('Procedure cyDrawBgPicture( aCanvas : TCanvas; aRect : TRect; aBgPicture : TcyBgPicture)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsOnChange_W(Self: TcyImagelistOptions; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsOnChange_R(Self: TcyImagelistOptions; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsImageList_W(Self: TcyImagelistOptions; const T: TImageList);
begin Self.ImageList := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsImageList_R(Self: TcyImagelistOptions; var T: TImageList);
begin T := Self.ImageList; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsNormalIndex_W(Self: TcyImagelistOptions; const T: Integer);
begin Self.NormalIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsNormalIndex_R(Self: TcyImagelistOptions; var T: Integer);
begin T := Self.NormalIndex; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsMouseDownIndex_W(Self: TcyImagelistOptions; const T: Integer);
begin Self.MouseDownIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsMouseDownIndex_R(Self: TcyImagelistOptions; var T: Integer);
begin T := Self.MouseDownIndex; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsExclusiveIndex_W(Self: TcyImagelistOptions; const T: Integer);
begin Self.ExclusiveIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsExclusiveIndex_R(Self: TcyImagelistOptions; var T: Integer);
begin T := Self.ExclusiveIndex; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsDisabledIndex_W(Self: TcyImagelistOptions; const T: Integer);
begin Self.DisabledIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyImagelistOptionsDisabledIndex_R(Self: TcyImagelistOptions; var T: Integer);
begin T := Self.DisabledIndex; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelsOnChange_W(Self: tcyBevels; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelsOnChange_R(Self: tcyBevels; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelsNeedOwnerRealign_R(Self: tcyBevels; var T: Boolean);
begin T := Self.NeedOwnerRealign; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelsItems_R(Self: tcyBevels; var T: TcyBevel; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelWidth_W(Self: tcyBevel; const T: Word);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelWidth_R(Self: tcyBevel; var T: Word);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelStyle_W(Self: tcyBevel; const T: TcyBevelCut);
begin Self.Style := T;
end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelStyle_R(Self: tcyBevel; var T: TcyBevelCut);
begin T := Self.Style;
end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelShadowColor_W(Self: tcyBevel; const T: TColor);
begin Self.ShadowColor := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelShadowColor_R(Self: tcyBevel; var T: TColor);
begin T := Self.ShadowColor; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelHighlightColor_W(Self: tcyBevel; const T: TColor);
begin Self.HighlightColor := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelHighlightColor_R(Self: tcyBevel; var T: TColor);
begin T := Self.HighlightColor; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawBottom_W(Self: tcyBevel; const T: Boolean);
begin Self.DrawBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawBottom_R(Self: tcyBevel; var T: Boolean);
begin T := Self.DrawBottom; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawRight_W(Self: tcyBevel; const T: Boolean);
begin Self.DrawRight := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawRight_R(Self: tcyBevel; var T: Boolean);
begin T := Self.DrawRight; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawTop_W(Self: tcyBevel; const T: Boolean);
begin Self.DrawTop := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawTop_R(Self: tcyBevel; var T: Boolean);
begin T := Self.DrawTop; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawLeft_W(Self: tcyBevel; const T: Boolean);
begin Self.DrawLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure tcyBevelDrawLeft_R(Self: tcyBevel; var T: Boolean);
begin T := Self.DrawLeft; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientOnChange_W(Self: TcyGradient; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientOnChange_R(Self: TcyGradient; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientToColor_W(Self: TcyGradient; const T: TColor);
begin Self.ToColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientToColor_R(Self: TcyGradient; var T: TColor);
begin T := Self.ToColor; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientSpeedPercent_W(Self: TcyGradient; const T: Integer);
begin Self.SpeedPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientSpeedPercent_R(Self: TcyGradient; var T: Integer);
begin T := Self.SpeedPercent; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientOrientation_W(Self: TcyGradient; const T: TDgradOrientation);
begin Self.Orientation := T;
end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientOrientation_R(Self: TcyGradient; var T: TDgradOrientation);
begin T := Self.Orientation;
end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientMaxDegrade_W(Self: TcyGradient; const T: byte);
begin Self.MaxDegrade := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientMaxDegrade_R(Self: TcyGradient; var T: byte);
begin T := Self.MaxDegrade; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientFromColor_W(Self: TcyGradient; const T: TColor);
begin Self.FromColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientFromColor_R(Self: TcyGradient; var T: TColor);
begin T := Self.FromColor; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientBalanceMode_W(Self: TcyGradient; const T: TDgradBalanceMode);
begin Self.BalanceMode := T;
end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientBalanceMode_R(Self: TcyGradient; var T: TDgradBalanceMode);
begin T := Self.BalanceMode;
end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientBalance_W(Self: TcyGradient; const T: Word);
begin Self.Balance := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientBalance_R(Self: TcyGradient; var T: Word);
begin T := Self.Balance; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientAngleDegree_W(Self: TcyGradient; const T: Word);
begin Self.AngleDegree := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientAngleDegree_R(Self: TcyGradient; var T: Word);
begin T := Self.AngleDegree; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientAngleClipRect_W(Self: TcyGradient; const T: Boolean);
begin Self.AngleClipRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyGradientAngleClipRect_R(Self: TcyGradient; var T: Boolean);
begin T := Self.AngleClipRect; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureOnChange_W(Self: TcyBgPicture; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureOnChange_R(Self: TcyBgPicture; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureTransparent_W(Self: TcyBgPicture; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureTransparent_R(Self: TcyBgPicture; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureStyle_W(Self: TcyBgPicture; const T: TBgStyle);
begin Self.Style := T;
end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureStyle_R(Self: TcyBgPicture; var T: TBgStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPicturePosition_W(Self: TcyBgPicture; const T: TBgPosition);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPicturePosition_R(Self: TcyBgPicture; var T: TBgPosition);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPicturePicture_W(Self: TcyBgPicture; const T: TPicture);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPicturePicture_R(Self: TcyBgPicture; var T: TPicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureRepeatY_W(Self: TcyBgPicture; const T: Word);
begin Self.RepeatY := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureRepeatY_R(Self: TcyBgPicture; var T: Word);
begin T := Self.RepeatY; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureRepeatX_W(Self: TcyBgPicture; const T: Word);
begin Self.RepeatX := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureRepeatX_R(Self: TcyBgPicture; var T: Word);
begin T := Self.RepeatX; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIntervalY_W(Self: TcyBgPicture; const T: Integer);
begin Self.IntervalY := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIntervalY_R(Self: TcyBgPicture; var T: Integer);
begin T := Self.IntervalY; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIntervalX_W(Self: TcyBgPicture; const T: Integer);
begin Self.IntervalX := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIntervalX_R(Self: TcyBgPicture; var T: Integer);
begin T := Self.IntervalX; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIndentY_W(Self: TcyBgPicture; const T: Integer);
begin Self.IndentY := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIndentY_R(Self: TcyBgPicture; var T: Integer);
begin T := Self.IndentY; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIndentX_W(Self: TcyBgPicture; const T: Integer);
begin Self.IndentX := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyBgPictureIndentX_R(Self: TcyBgPicture; var T: Integer);
begin T := Self.IndentX; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextOnChange_W(Self: TcyShadowText; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextOnChange_R(Self: TcyShadowText; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextRelativePosY_W(Self: TcyShadowText; const T: Integer);
begin Self.RelativePosY := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextRelativePosY_R(Self: TcyShadowText; var T: Integer);
begin T := Self.RelativePosY; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextRelativePosX_W(Self: TcyShadowText; const T: Integer);
begin Self.RelativePosX := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextRelativePosX_R(Self: TcyShadowText; var T: Integer);
begin T := Self.RelativePosX; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextZoomPercent_W(Self: TcyShadowText; const T: Word);
begin Self.ZoomPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextZoomPercent_R(Self: TcyShadowText; var T: Word);
begin T := Self.ZoomPercent; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextColor_W(Self: TcyShadowText; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyShadowTextColor_R(Self: TcyShadowText; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignResizeBorderSize_W(Self: TcyRunTimeDesign; const T: Word);
begin Self.ResizeBorderSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignResizeBorderSize_R(Self: TcyRunTimeDesign; var T: Word);
begin T := Self.ResizeBorderSize; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignOutsideParentRect_W(Self: TcyRunTimeDesign; const T: Boolean);
begin Self.OutsideParentRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignOutsideParentRect_R(Self: TcyRunTimeDesign; var T: Boolean);
begin T := Self.OutsideParentRect; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeBottom_W(Self: TcyRunTimeDesign; const T: Boolean);
begin Self.AllowResizeBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeBottom_R(Self: TcyRunTimeDesign; var T: Boolean);
begin T := Self.AllowResizeBottom; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeRight_W(Self: TcyRunTimeDesign; const T: Boolean);
begin Self.AllowResizeRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeRight_R(Self: TcyRunTimeDesign; var T: Boolean);
begin T := Self.AllowResizeRight; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeLeft_W(Self: TcyRunTimeDesign; const T: Boolean);
begin Self.AllowResizeLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeLeft_R(Self: TcyRunTimeDesign; var T: Boolean);
begin T := Self.AllowResizeLeft; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeTop_W(Self: TcyRunTimeDesign; const T: Boolean);
begin Self.AllowResizeTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowResizeTop_R(Self: TcyRunTimeDesign; var T: Boolean);
begin T := Self.AllowResizeTop; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowMove_W(Self: TcyRunTimeDesign; const T: Boolean);
begin Self.AllowMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignAllowMove_R(Self: TcyRunTimeDesign; var T: Boolean);
begin T := Self.AllowMove; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignJobAtPos_W(Self: TcyRunTimeDesign; const T: TRunTimeDesignJob);
begin Self.JobAtPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignJobAtPos_R(Self: TcyRunTimeDesign; var T: TRunTimeDesignJob);
begin T := Self.JobAtPos; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignJob_W(Self: TcyRunTimeDesign; const T: TRunTimeDesignJob);
begin Self.Job := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignJob_R(Self: TcyRunTimeDesign; var T: TRunTimeDesignJob);
begin T := Self.Job; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignControl_W(Self: TcyRunTimeDesign; const T: TControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeDesignControl_R(Self: TcyRunTimeDesign; var T: TControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyClasses_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@cyDrawBgPicture, 'cyDrawBgPicture', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyImagelistOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyImagelistOptions) do
  begin
    RegisterVirtualConstructor(@TcyImagelistOptions.Create, 'Create');
    RegisterMethod(@TcyImagelistOptions.GetDrawingParams, 'GetDrawingParams');
    RegisterPropertyHelper(@TcyImagelistOptionsDisabledIndex_R,@TcyImagelistOptionsDisabledIndex_W,'DisabledIndex');
    RegisterPropertyHelper(@TcyImagelistOptionsExclusiveIndex_R,@TcyImagelistOptionsExclusiveIndex_W,'ExclusiveIndex');
    RegisterPropertyHelper(@TcyImagelistOptionsMouseDownIndex_R,@TcyImagelistOptionsMouseDownIndex_W,'MouseDownIndex');
    RegisterPropertyHelper(@TcyImagelistOptionsNormalIndex_R,@TcyImagelistOptionsNormalIndex_W,'NormalIndex');
    RegisterPropertyHelper(@TcyImagelistOptionsImageList_R,@TcyImagelistOptionsImageList_W,'ImageList');
    RegisterPropertyHelper(@TcyImagelistOptionsOnChange_R,@TcyImagelistOptionsOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_tcyBevels(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(tcyBevels) do
  begin
    RegisterConstructor(@tcyBevels.Create, 'Create');
    RegisterMethod(@tcyBevels.Add, 'Add');
    RegisterMethod(@tcyBevels.Delete, 'Delete');
    RegisterMethod(@tcyBevels.DrawBevels, 'DrawBevels');
    RegisterMethod(@tcyBevels.BevelsWidth, 'BevelsWidth');
    RegisterPropertyHelper(@tcyBevelsItems_R,nil,'Items');
    RegisterPropertyHelper(@tcyBevelsNeedOwnerRealign_R,nil,'NeedOwnerRealign');
    RegisterPropertyHelper(@tcyBevelsOnChange_R,@tcyBevelsOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_tcyBevel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(tcyBevel) do
  begin
    RegisterConstructor(@tcyBevel.Create, 'Create');
    RegisterMethod(@tcyBevel.Assign, 'Assign');
    RegisterPropertyHelper(@tcyBevelDrawLeft_R,@tcyBevelDrawLeft_W,'DrawLeft');
    RegisterPropertyHelper(@tcyBevelDrawTop_R,@tcyBevelDrawTop_W,'DrawTop');
    RegisterPropertyHelper(@tcyBevelDrawRight_R,@tcyBevelDrawRight_W,'DrawRight');
    RegisterPropertyHelper(@tcyBevelDrawBottom_R,@tcyBevelDrawBottom_W,'DrawBottom');
    RegisterPropertyHelper(@tcyBevelHighlightColor_R,@tcyBevelHighlightColor_W,'HighlightColor');
    RegisterPropertyHelper(@tcyBevelShadowColor_R,@tcyBevelShadowColor_W,'ShadowColor');
    RegisterPropertyHelper(@tcyBevelStyle_R,@tcyBevelStyle_W,'Style');
    RegisterPropertyHelper(@tcyBevelWidth_R,@tcyBevelWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyGradient) do
  begin
    RegisterVirtualConstructor(@TcyGradient.Create, 'Create');
    RegisterMethod(@TcyGradient.Assign, 'Assign');
    RegisterMethod(@TcyGradient.Draw, 'Draw');
    RegisterPropertyHelper(@TcyGradientAngleClipRect_R,@TcyGradientAngleClipRect_W,'AngleClipRect');
    RegisterPropertyHelper(@TcyGradientAngleDegree_R,@TcyGradientAngleDegree_W,'AngleDegree');
    RegisterPropertyHelper(@TcyGradientBalance_R,@TcyGradientBalance_W,'Balance');
    RegisterPropertyHelper(@TcyGradientBalanceMode_R,@TcyGradientBalanceMode_W,'BalanceMode');
    RegisterPropertyHelper(@TcyGradientFromColor_R,@TcyGradientFromColor_W,'FromColor');
    RegisterPropertyHelper(@TcyGradientMaxDegrade_R,@TcyGradientMaxDegrade_W,'MaxDegrade');
    RegisterPropertyHelper(@TcyGradientOrientation_R,@TcyGradientOrientation_W,'Orientation');
    RegisterPropertyHelper(@TcyGradientSpeedPercent_R,@TcyGradientSpeedPercent_W,'SpeedPercent');
    RegisterPropertyHelper(@TcyGradientToColor_R,@TcyGradientToColor_W,'ToColor');
    RegisterPropertyHelper(@TcyGradientOnChange_R,@TcyGradientOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyBgPicture(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyBgPicture) do begin
    RegisterVirtualConstructor(@TcyBgPicture.Create, 'Create');
       RegisterMethod(@TcyBgPicture.Destroy, 'Free');
     RegisterMethod(@TcyBgPicture.Assign, 'Assign');
    RegisterMethod(@TcyBgPicture.SomethingToDraw, 'SomethingToDraw');
    RegisterPropertyHelper(@TcyBgPictureIndentX_R,@TcyBgPictureIndentX_W,'IndentX');
    RegisterPropertyHelper(@TcyBgPictureIndentY_R,@TcyBgPictureIndentY_W,'IndentY');
    RegisterPropertyHelper(@TcyBgPictureIntervalX_R,@TcyBgPictureIntervalX_W,'IntervalX');
    RegisterPropertyHelper(@TcyBgPictureIntervalY_R,@TcyBgPictureIntervalY_W,'IntervalY');
    RegisterPropertyHelper(@TcyBgPictureRepeatX_R,@TcyBgPictureRepeatX_W,'RepeatX');
    RegisterPropertyHelper(@TcyBgPictureRepeatY_R,@TcyBgPictureRepeatY_W,'RepeatY');
    RegisterPropertyHelper(@TcyBgPicturePicture_R,@TcyBgPicturePicture_W,'Picture');
    RegisterPropertyHelper(@TcyBgPicturePosition_R,@TcyBgPicturePosition_W,'Position');
    RegisterPropertyHelper(@TcyBgPictureStyle_R,@TcyBgPictureStyle_W,'Style');
    RegisterPropertyHelper(@TcyBgPictureTransparent_R,@TcyBgPictureTransparent_W,'Transparent');
    RegisterPropertyHelper(@TcyBgPictureOnChange_R,@TcyBgPictureOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyShadowText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyShadowText) do
  begin
    RegisterVirtualConstructor(@TcyShadowText.Create, 'Create');
    RegisterMethod(@TcyShadowText.Assign, 'Assign');
    RegisterMethod(@TcyShadowText.Active, 'Active');
    RegisterMethod(@TcyShadowText.CalcShadowRect, 'CalcShadowRect');
    RegisterMethod(@TcyShadowText.DrawShadowText, 'DrawShadowText');
    RegisterPropertyHelper(@TcyShadowTextColor_R,@TcyShadowTextColor_W,'Color');
    RegisterPropertyHelper(@TcyShadowTextZoomPercent_R,@TcyShadowTextZoomPercent_W,'ZoomPercent');
    RegisterPropertyHelper(@TcyShadowTextRelativePosX_R,@TcyShadowTextRelativePosX_W,'RelativePosX');
    RegisterPropertyHelper(@TcyShadowTextRelativePosY_R,@TcyShadowTextRelativePosY_W,'RelativePosY');
    RegisterPropertyHelper(@TcyShadowTextOnChange_R,@TcyShadowTextOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyRunTimeDesign(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyRunTimeDesign) do
  begin
    RegisterVirtualConstructor(@TcyRunTimeDesign.Create, 'Create');
    RegisterMethod(@TcyRunTimeDesign.Assign, 'Assign');
    RegisterMethod(@TcyRunTimeDesign.DetermineJobAtPos, 'DetermineJobAtPos');
    RegisterMethod(@TcyRunTimeDesign.StartJob, 'StartJob');
    RegisterMethod(@TcyRunTimeDesign.DoJob, 'DoJob');
    RegisterMethod(@TcyRunTimeDesign.EndJob, 'EndJob');
    RegisterPropertyHelper(@TcyRunTimeDesignControl_R,@TcyRunTimeDesignControl_W,'Control');
    RegisterPropertyHelper(@TcyRunTimeDesignJob_R,@TcyRunTimeDesignJob_W,'Job');
    RegisterPropertyHelper(@TcyRunTimeDesignJobAtPos_R,@TcyRunTimeDesignJobAtPos_W,'JobAtPos');
    RegisterPropertyHelper(@TcyRunTimeDesignAllowMove_R,@TcyRunTimeDesignAllowMove_W,'AllowMove');
    RegisterPropertyHelper(@TcyRunTimeDesignAllowResizeTop_R,@TcyRunTimeDesignAllowResizeTop_W,'AllowResizeTop');
    RegisterPropertyHelper(@TcyRunTimeDesignAllowResizeLeft_R,@TcyRunTimeDesignAllowResizeLeft_W,'AllowResizeLeft');
    RegisterPropertyHelper(@TcyRunTimeDesignAllowResizeRight_R,@TcyRunTimeDesignAllowResizeRight_W,'AllowResizeRight');
    RegisterPropertyHelper(@TcyRunTimeDesignAllowResizeBottom_R,@TcyRunTimeDesignAllowResizeBottom_W,'AllowResizeBottom');
    RegisterPropertyHelper(@TcyRunTimeDesignOutsideParentRect_R,@TcyRunTimeDesignOutsideParentRect_W,'OutsideParentRect');
    RegisterPropertyHelper(@TcyRunTimeDesignResizeBorderSize_R,@TcyRunTimeDesignResizeBorderSize_W,'ResizeBorderSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyClasses(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyRunTimeDesign(CL);
  RIRegister_TcyShadowText(CL);
  RIRegister_TcyBgPicture(CL);
  RIRegister_TcyGradient(CL);
  RIRegister_tcyBevel(CL);
  RIRegister_tcyBevels(CL);
  RIRegister_TcyImagelistOptions(CL);
end;

 
 
{ TPSImport_cyClasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyClasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyClasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyClasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyClasses(ri);
  RIRegister_cyClasses_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
