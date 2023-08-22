unit uPSI_IpAnim;
{
  of lazarus
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
  TPSImport_IpAnim = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIpAnimatedGraphic(CL: TPSPascalCompiler);
procedure SIRegister_TIpAnimationFrameList(CL: TPSPascalCompiler);
procedure SIRegister_TIpAnimationFrame(CL: TPSPascalCompiler);
procedure SIRegister_IpAnim(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIpAnimatedGraphic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIpAnimationFrameList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIpAnimationFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_IpAnim(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // LCLType
  //,GraphType
  //,LCLIntf
  Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ExtCtrls
  ,IpConst
  ,IpAnim
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IpAnim]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIpAnimatedGraphic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TIpAnimatedGraphic') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TIpAnimatedGraphic') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AssignTo( Dest : TPersistent)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Function StartAnimation : boolean');
    RegisterMethod('Procedure StopAnimation');
    RegisterProperty('AggressiveDrawing', 'Boolean', iptrw);
    RegisterProperty('Animate', 'boolean', iptrw);
    RegisterProperty('BackgroundColor', 'TColor', iptrw);
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterProperty('CurrentFrameIndex', 'Integer', iptrw);
    RegisterProperty('DelayTime', 'Integer', iptrw);
    RegisterProperty('DestinationCanvas', 'TCanvas', iptrw);
    RegisterProperty('DestinationRect', 'TRect', iptrw);
    RegisterProperty('DrawingCanvas', 'TCanvas', iptrw);
    RegisterProperty('DrawingRect', 'TRect', iptrw);
    RegisterProperty('DisposalMethod', 'TDisposalMethod', iptrw);
    RegisterProperty('FrameChangeNotify', 'Boolean', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Images', 'TIpAnimationFrameList', iptrw);
    RegisterProperty('NumFrames', 'Integer', iptrw);
    RegisterProperty('Transparent', 'boolean', iptrw);
    RegisterProperty('TransparentColor', 'TColor', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('OnAfterFrameChange', 'TOnAfterFrameChange', iptrw);
    RegisterProperty('OnBeforeFrameChange', 'TOnBeforeFrameChange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIpAnimationFrameList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIpAnimationFrameList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIpAnimationFrameList') do begin
    RegisterMethod('Constructor Create');
         RegisterMethod('Procedure Free');
    RegisterMethod('Function Add( AFrame : TIpAnimationFrame) : Integer');
    RegisterMethod('Procedure Assign( Source : TIpAnimationFrameList)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IndexOf( AFrame : TIpAnimationFrame) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; AFrame : TIpAnimationFrame)');
    RegisterMethod('Function Remove( AFrame : TIpAnimationFrame) : Integer');
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'TIpAnimationFrame Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('List', 'TList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIpAnimationFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIpAnimationFrame') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIpAnimationFrame') do begin
    RegisterMethod('Constructor Create');
         RegisterMethod('Procedure Free');
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterProperty('DelayTime', 'Integer', iptrw);
    RegisterProperty('DisposalMethod', 'TDisposalMethod', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('TransparentColor', 'TColor', iptrw);
    RegisterProperty('XOffset', 'Integer', iptrw);
    RegisterProperty('YOffset', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IpAnim(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('DefaultAggressiveDrawing','Boolean')BoolToStr( False);
 //CL.AddConstantN('DefaultFrameChangeNotify','Boolean')BoolToStr( False);
  CL.AddTypeS('TDisposalMethod', '( NODISPOSALMETHOD, DONOTDISPOSE, OVERWRITEWI'
   +'THBKGCOLOR, OVERWRITEWITHPREVIOUS )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIpAnimationFrameList');
  CL.AddTypeS('TOnBeforeFrameChange', 'Procedure ( Sender : TObject; CurrentFra'
   +'me : Integer; var NewFrame : Integer; Frames : TIpAnimationFrameList; var CanChange : boolean)');
  CL.AddTypeS('TOnAfterFrameChange', 'Procedure ( Sender : TObject; CurrentFrame: Integer; Frames : TIpAnimationFrameList)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAnimationError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EFrameListError');
  SIRegister_TIpAnimationFrame(CL);
  SIRegister_TIpAnimationFrameList(CL);
  SIRegister_TIpAnimatedGraphic(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicOnBeforeFrameChange_W(Self: TIpAnimatedGraphic; const T: TOnBeforeFrameChange);
begin Self.OnBeforeFrameChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicOnBeforeFrameChange_R(Self: TIpAnimatedGraphic; var T: TOnBeforeFrameChange);
begin T := Self.OnBeforeFrameChange; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicOnAfterFrameChange_W(Self: TIpAnimatedGraphic; const T: TOnAfterFrameChange);
begin Self.OnAfterFrameChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicOnAfterFrameChange_R(Self: TIpAnimatedGraphic; var T: TOnAfterFrameChange);
begin T := Self.OnAfterFrameChange; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicWidth_W(Self: TIpAnimatedGraphic; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicWidth_R(Self: TIpAnimatedGraphic; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicTransparentColor_W(Self: TIpAnimatedGraphic; const T: TColor);
begin Self.TransparentColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicTransparentColor_R(Self: TIpAnimatedGraphic; var T: TColor);
begin T := Self.TransparentColor; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicTransparent_W(Self: TIpAnimatedGraphic; const T: boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicTransparent_R(Self: TIpAnimatedGraphic; var T: boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicNumFrames_W(Self: TIpAnimatedGraphic; const T: Integer);
begin Self.NumFrames := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicNumFrames_R(Self: TIpAnimatedGraphic; var T: Integer);
begin T := Self.NumFrames; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicImages_W(Self: TIpAnimatedGraphic; const T: TIpAnimationFrameList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicImages_R(Self: TIpAnimatedGraphic; var T: TIpAnimationFrameList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicHeight_W(Self: TIpAnimatedGraphic; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicHeight_R(Self: TIpAnimatedGraphic; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicFrameChangeNotify_W(Self: TIpAnimatedGraphic; const T: Boolean);
begin Self.FrameChangeNotify := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicFrameChangeNotify_R(Self: TIpAnimatedGraphic; var T: Boolean);
begin T := Self.FrameChangeNotify; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDisposalMethod_W(Self: TIpAnimatedGraphic; const T: TDisposalMethod);
begin Self.DisposalMethod := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDisposalMethod_R(Self: TIpAnimatedGraphic; var T: TDisposalMethod);
begin T := Self.DisposalMethod; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDrawingRect_W(Self: TIpAnimatedGraphic; const T: TRect);
begin Self.DrawingRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDrawingRect_R(Self: TIpAnimatedGraphic; var T: TRect);
begin T := Self.DrawingRect; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDrawingCanvas_W(Self: TIpAnimatedGraphic; const T: TCanvas);
begin Self.DrawingCanvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDrawingCanvas_R(Self: TIpAnimatedGraphic; var T: TCanvas);
begin T := Self.DrawingCanvas; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDestinationRect_W(Self: TIpAnimatedGraphic; const T: TRect);
begin Self.DestinationRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDestinationRect_R(Self: TIpAnimatedGraphic; var T: TRect);
begin T := Self.DestinationRect; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDestinationCanvas_W(Self: TIpAnimatedGraphic; const T: TCanvas);
begin Self.DestinationCanvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDestinationCanvas_R(Self: TIpAnimatedGraphic; var T: TCanvas);
begin T := Self.DestinationCanvas; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDelayTime_W(Self: TIpAnimatedGraphic; const T: Integer);
begin Self.DelayTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicDelayTime_R(Self: TIpAnimatedGraphic; var T: Integer);
begin T := Self.DelayTime; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicCurrentFrameIndex_W(Self: TIpAnimatedGraphic; const T: Integer);
begin Self.CurrentFrameIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicCurrentFrameIndex_R(Self: TIpAnimatedGraphic; var T: Integer);
begin T := Self.CurrentFrameIndex; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicBitmap_W(Self: TIpAnimatedGraphic; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicBitmap_R(Self: TIpAnimatedGraphic; var T: TBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicBackgroundColor_W(Self: TIpAnimatedGraphic; const T: TColor);
begin Self.BackgroundColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicBackgroundColor_R(Self: TIpAnimatedGraphic; var T: TColor);
begin T := Self.BackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicAnimate_W(Self: TIpAnimatedGraphic; const T: boolean);
begin Self.Animate := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicAnimate_R(Self: TIpAnimatedGraphic; var T: boolean);
begin T := Self.Animate; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicAggressiveDrawing_W(Self: TIpAnimatedGraphic; const T: Boolean);
begin Self.AggressiveDrawing := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimatedGraphicAggressiveDrawing_R(Self: TIpAnimatedGraphic; var T: Boolean);
begin T := Self.AggressiveDrawing; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameListList_W(Self: TIpAnimationFrameList; const T: TList);
begin Self.List := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameListList_R(Self: TIpAnimationFrameList; var T: TList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameListItems_W(Self: TIpAnimationFrameList; const T: TIpAnimationFrame; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameListItems_R(Self: TIpAnimationFrameList; var T: TIpAnimationFrame; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameListCount_W(Self: TIpAnimationFrameList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameListCount_R(Self: TIpAnimationFrameList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameYOffset_W(Self: TIpAnimationFrame; const T: Integer);
begin Self.YOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameYOffset_R(Self: TIpAnimationFrame; var T: Integer);
begin T := Self.YOffset; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameXOffset_W(Self: TIpAnimationFrame; const T: Integer);
begin Self.XOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameXOffset_R(Self: TIpAnimationFrame; var T: Integer);
begin T := Self.XOffset; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameTransparentColor_W(Self: TIpAnimationFrame; const T: TColor);
begin Self.TransparentColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameTransparentColor_R(Self: TIpAnimationFrame; var T: TColor);
begin T := Self.TransparentColor; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameTransparent_W(Self: TIpAnimationFrame; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameTransparent_R(Self: TIpAnimationFrame; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameDisposalMethod_W(Self: TIpAnimationFrame; const T: TDisposalMethod);
begin Self.DisposalMethod := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameDisposalMethod_R(Self: TIpAnimationFrame; var T: TDisposalMethod);
begin T := Self.DisposalMethod; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameDelayTime_W(Self: TIpAnimationFrame; const T: Integer);
begin Self.DelayTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameDelayTime_R(Self: TIpAnimationFrame; var T: Integer);
begin T := Self.DelayTime; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameBitmap_W(Self: TIpAnimationFrame; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpAnimationFrameBitmap_R(Self: TIpAnimationFrame; var T: TBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIpAnimatedGraphic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpAnimatedGraphic) do begin
    RegisterConstructor(@TIpAnimatedGraphic.Create, 'Create');
          RegisterMethod(@TIpAnimatedGraphic.Destroy, 'Free');
    RegisterMethod(@TIpAnimatedGraphic.Assign, 'Assign');
    RegisterMethod(@TIpAnimatedGraphic.AssignTo, 'AssignTo');
    RegisterMethod(@TIpAnimatedGraphic.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TIpAnimatedGraphic.StartAnimation, 'StartAnimation');
    RegisterVirtualMethod(@TIpAnimatedGraphic.StopAnimation, 'StopAnimation');
    RegisterPropertyHelper(@TIpAnimatedGraphicAggressiveDrawing_R,@TIpAnimatedGraphicAggressiveDrawing_W,'AggressiveDrawing');
    RegisterPropertyHelper(@TIpAnimatedGraphicAnimate_R,@TIpAnimatedGraphicAnimate_W,'Animate');
    RegisterPropertyHelper(@TIpAnimatedGraphicBackgroundColor_R,@TIpAnimatedGraphicBackgroundColor_W,'BackgroundColor');
    RegisterPropertyHelper(@TIpAnimatedGraphicBitmap_R,@TIpAnimatedGraphicBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TIpAnimatedGraphicCurrentFrameIndex_R,@TIpAnimatedGraphicCurrentFrameIndex_W,'CurrentFrameIndex');
    RegisterPropertyHelper(@TIpAnimatedGraphicDelayTime_R,@TIpAnimatedGraphicDelayTime_W,'DelayTime');
    RegisterPropertyHelper(@TIpAnimatedGraphicDestinationCanvas_R,@TIpAnimatedGraphicDestinationCanvas_W,'DestinationCanvas');
    RegisterPropertyHelper(@TIpAnimatedGraphicDestinationRect_R,@TIpAnimatedGraphicDestinationRect_W,'DestinationRect');
    RegisterPropertyHelper(@TIpAnimatedGraphicDrawingCanvas_R,@TIpAnimatedGraphicDrawingCanvas_W,'DrawingCanvas');
    RegisterPropertyHelper(@TIpAnimatedGraphicDrawingRect_R,@TIpAnimatedGraphicDrawingRect_W,'DrawingRect');
    RegisterPropertyHelper(@TIpAnimatedGraphicDisposalMethod_R,@TIpAnimatedGraphicDisposalMethod_W,'DisposalMethod');
    RegisterPropertyHelper(@TIpAnimatedGraphicFrameChangeNotify_R,@TIpAnimatedGraphicFrameChangeNotify_W,'FrameChangeNotify');
    RegisterPropertyHelper(@TIpAnimatedGraphicHeight_R,@TIpAnimatedGraphicHeight_W,'Height');
    RegisterPropertyHelper(@TIpAnimatedGraphicImages_R,@TIpAnimatedGraphicImages_W,'Images');
    RegisterPropertyHelper(@TIpAnimatedGraphicNumFrames_R,@TIpAnimatedGraphicNumFrames_W,'NumFrames');
    RegisterPropertyHelper(@TIpAnimatedGraphicTransparent_R,@TIpAnimatedGraphicTransparent_W,'Transparent');
    RegisterPropertyHelper(@TIpAnimatedGraphicTransparentColor_R,@TIpAnimatedGraphicTransparentColor_W,'TransparentColor');
    RegisterPropertyHelper(@TIpAnimatedGraphicWidth_R,@TIpAnimatedGraphicWidth_W,'Width');
    RegisterPropertyHelper(@TIpAnimatedGraphicOnAfterFrameChange_R,@TIpAnimatedGraphicOnAfterFrameChange_W,'OnAfterFrameChange');
    RegisterPropertyHelper(@TIpAnimatedGraphicOnBeforeFrameChange_R,@TIpAnimatedGraphicOnBeforeFrameChange_W,'OnBeforeFrameChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIpAnimationFrameList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpAnimationFrameList) do begin
    RegisterConstructor(@TIpAnimationFrameList.Create, 'Create');
     RegisterMethod(@TIpAnimationFrameList.Destroy, 'Free');
      RegisterMethod(@TIpAnimationFrameList.Add, 'Add');
    RegisterVirtualMethod(@TIpAnimationFrameList.Assign, 'Assign');
    RegisterMethod(@TIpAnimationFrameList.Clear, 'Clear');
    RegisterMethod(@TIpAnimationFrameList.IndexOf, 'IndexOf');
    RegisterMethod(@TIpAnimationFrameList.Insert, 'Insert');
    RegisterMethod(@TIpAnimationFrameList.Remove, 'Remove');
    RegisterPropertyHelper(@TIpAnimationFrameListCount_R,@TIpAnimationFrameListCount_W,'Count');
    RegisterPropertyHelper(@TIpAnimationFrameListItems_R,@TIpAnimationFrameListItems_W,'Items');
    RegisterPropertyHelper(@TIpAnimationFrameListList_R,@TIpAnimationFrameListList_W,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIpAnimationFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpAnimationFrame) do begin
    RegisterConstructor(@TIpAnimationFrame.Create, 'Create');
          RegisterMethod(@TIpAnimationFrame.Destroy, 'Free');
      RegisterPropertyHelper(@TIpAnimationFrameBitmap_R,@TIpAnimationFrameBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TIpAnimationFrameDelayTime_R,@TIpAnimationFrameDelayTime_W,'DelayTime');
    RegisterPropertyHelper(@TIpAnimationFrameDisposalMethod_R,@TIpAnimationFrameDisposalMethod_W,'DisposalMethod');
    RegisterPropertyHelper(@TIpAnimationFrameTransparent_R,@TIpAnimationFrameTransparent_W,'Transparent');
    RegisterPropertyHelper(@TIpAnimationFrameTransparentColor_R,@TIpAnimationFrameTransparentColor_W,'TransparentColor');
    RegisterPropertyHelper(@TIpAnimationFrameXOffset_R,@TIpAnimationFrameXOffset_W,'XOffset');
    RegisterPropertyHelper(@TIpAnimationFrameYOffset_R,@TIpAnimationFrameYOffset_W,'YOffset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IpAnim(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpAnimationFrameList) do
  with CL.Add(EAnimationError) do
  with CL.Add(EFrameListError) do
  RIRegister_TIpAnimationFrame(CL);
  RIRegister_TIpAnimationFrameList(CL);
  RIRegister_TIpAnimatedGraphic(CL);
end;

 
 
{ TPSImport_IpAnim }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IpAnim.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IpAnim(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IpAnim.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IpAnim(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
