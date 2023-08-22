unit uPSI_JvCtrls;
{
  another res
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
  TPSImport_JvCtrls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvImgBtn(CL: TPSPascalCompiler);
procedure SIRegister_TJvImgBtnActionLink(CL: TPSPascalCompiler);
procedure SIRegister_TJvListBox(CL: TPSPascalCompiler);
procedure SIRegister_JvCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvImgBtn(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvImgBtnActionLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,Messages
  ,Graphics
  //,Controls
  //,Forms
  //,StdCtrls
  ,ImgList
  ,ActnList
  ,JVCLVer
  ,JvListBox
  ,JvCtrls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCtrls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvImgBtn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TButton', 'TJvImgBtn') do
  with CL.AddClassN(CL.FindClass('TButton'),'TJvImgBtn') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Click');
    RegisterMethod('Procedure DrawButtonImage( ImageBounds : TRect)');
    RegisterMethod('Procedure DrawButtonFocusRect( const RectContent : TRect)');
    RegisterMethod('Procedure DrawButtonFrame( const DrawItemStruct : TDrawItemStruct; var RectContent : TRect)');
    RegisterMethod('Procedure DrawButtonText( TextBounds : TRect; TextEnabled : Boolean)');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('CurrentAnimateFrame', 'Byte', iptr);
    RegisterProperty('MouseInControl', 'Boolean', iptr);
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('Animate', 'Boolean', iptrw);
    RegisterProperty('AnimateFrames', 'Integer', iptrw);
    RegisterProperty('AnimateInterval', 'Cardinal', iptrw);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('ImageIndex', 'Integer', iptrw);
    RegisterProperty('ImageVisible', 'Boolean', iptrw);
    RegisterProperty('Kind', 'TJvImgBtnKind', iptrw);
    RegisterProperty('Layout', 'TJvImgBtnLayout', iptrw);
    RegisterProperty('Margin', 'Integer', iptrw);
    RegisterProperty('OwnerDraw', 'Boolean', iptrw);
    RegisterProperty('Spacing', 'Integer', iptrw);
    RegisterProperty('OnButtonDraw', 'TJvImgBtnDrawEvent', iptrw);
    RegisterProperty('OnGetAnimateIndex', 'TJvImgBtnAnimIndexEvent', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvImgBtnActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TButtonActionLink', 'TJvImgBtnActionLink') do
  with CL.AddClassN(CL.FindClass('TButtonActionLink'),'TJvImgBtnActionLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomListBox', 'TJvListBox') do
  with CL.AddClassN(CL.FindClass('TJvCustomListBox'),'TJvListBox') do begin
    registerpublishedproperties;
     RegisterProperty('Parent', 'TWinControl', iptrw);
  RegisterProperty('HoverTime', 'Integer', iptrw);
  RegisterProperty('LargeImages', 'TCustomImageList', iptrw);
  RegisterProperty('Items', 'TStrings', iptrw);
  RegisterProperty('Visible', 'boolean', iptrw);
  RegisterProperty('ReadOnly', 'boolean', iptrw);
  RegisterProperty('GridLines', 'boolean', iptrw);
  RegisterProperty('Color', 'TColor', iptrw);
  RegisterProperty('Checkboxes', 'boolean', iptrw);
  RegisterProperty('Columns', 'Integer', iptrw);
  RegisterProperty('ColumnClick', 'boolean', iptrw);
  RegisterProperty('OnDblClick', 'TNotifyEvent', iptrw);
  RegisterProperty('OnEnter', 'TNotifyEvent', iptrw);
  RegisterProperty('OnExit', 'TNotifyEvent', iptrw);
  RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
  RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
  RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
  RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
  RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
   RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
   RegisterProperty('ONCHANGE', 'TLVChangeEvent', iptrw);
    RegisterProperty('MultiSelect', 'boolean', iptrw);
  RegisterProperty('Enabled', 'boolean', iptrw);
  RegisterProperty('FlatScrollBars', 'boolean', iptrw);
  RegisterProperty('SmallImages', 'TCustomImageList', iptrw);
  RegisterProperty('StateImages', 'TCustomImageList', iptrw);
  RegisterProperty('ShowHint', 'boolean', iptrw);
  RegisterProperty('Font', 'TFont', iptrw);
  RegisterProperty('ItemIndex', 'integer', iptrw);
  RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
  RegisterProperty('BORDERWidth', 'integer', iptrw);
  RegisterProperty('SortType', 'TSortType', iptrw);
  RegisterProperty('IconOptions', 'TIconOptions', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCtrls(CL: TPSPascalCompiler);
begin
  SIRegister_TJvListBox(CL);
  CL.AddTypeS('TJvImgBtnLayout', '( blImageLeft, blImageRight )');
  CL.AddTypeS('TJvImgBtnKind', '( bkCustom, bkOK, bkCancel, bkHelp, bkYes, bkNo'
   +', bkClose, bkAbort, bkRetry, bkIgnore, bkAll )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvImgBtn');
  SIRegister_TJvImgBtnActionLink(CL);
 // CL.AddTypeS('TJvImgBtnDrawEvent', 'Procedure ( Sender : TObject; const DrawIt'
   //+'emStruct : TDrawItemStruct)');
  CL.AddTypeS('TJvImgBtnAnimIndexEvent', 'Procedure ( Sender : TObject; Current'
   +'AnimateFrame : Byte; var ImageIndex : Integer)');
  SIRegister_TJvImgBtn(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnMouseLeave_W(Self: TJvImgBtn; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnMouseLeave_R(Self: TJvImgBtn; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnMouseEnter_W(Self: TJvImgBtn; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnMouseEnter_R(Self: TJvImgBtn; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnGetAnimateIndex_W(Self: TJvImgBtn; const T: TJvImgBtnAnimIndexEvent);
begin Self.OnGetAnimateIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnGetAnimateIndex_R(Self: TJvImgBtn; var T: TJvImgBtnAnimIndexEvent);
begin T := Self.OnGetAnimateIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnButtonDraw_W(Self: TJvImgBtn; const T: TJvImgBtnDrawEvent);
begin Self.OnButtonDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOnButtonDraw_R(Self: TJvImgBtn; var T: TJvImgBtnDrawEvent);
begin T := Self.OnButtonDraw; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnSpacing_W(Self: TJvImgBtn; const T: Integer);
begin Self.Spacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnSpacing_R(Self: TJvImgBtn; var T: Integer);
begin T := Self.Spacing; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOwnerDraw_W(Self: TJvImgBtn; const T: Boolean);
begin Self.OwnerDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnOwnerDraw_R(Self: TJvImgBtn; var T: Boolean);
begin T := Self.OwnerDraw; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnMargin_W(Self: TJvImgBtn; const T: Integer);
begin Self.Margin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnMargin_R(Self: TJvImgBtn; var T: Integer);
begin T := Self.Margin; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnLayout_W(Self: TJvImgBtn; const T: TJvImgBtnLayout);
begin Self.Layout := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnLayout_R(Self: TJvImgBtn; var T: TJvImgBtnLayout);
begin T := Self.Layout; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnKind_W(Self: TJvImgBtn; const T: TJvImgBtnKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnKind_R(Self: TJvImgBtn; var T: TJvImgBtnKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnImageVisible_W(Self: TJvImgBtn; const T: Boolean);
begin Self.ImageVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnImageVisible_R(Self: TJvImgBtn; var T: Boolean);
begin T := Self.ImageVisible; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnImageIndex_W(Self: TJvImgBtn; const T: Integer);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnImageIndex_R(Self: TJvImgBtn; var T: Integer);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnImages_W(Self: TJvImgBtn; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnImages_R(Self: TJvImgBtn; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAnimateInterval_W(Self: TJvImgBtn; const T: Cardinal);
begin Self.AnimateInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAnimateInterval_R(Self: TJvImgBtn; var T: Cardinal);
begin T := Self.AnimateInterval; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAnimateFrames_W(Self: TJvImgBtn; const T: Integer);
begin Self.AnimateFrames := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAnimateFrames_R(Self: TJvImgBtn; var T: Integer);
begin T := Self.AnimateFrames; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAnimate_W(Self: TJvImgBtn; const T: Boolean);
begin Self.Animate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAnimate_R(Self: TJvImgBtn; var T: Boolean);
begin T := Self.Animate; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAlignment_W(Self: TJvImgBtn; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAlignment_R(Self: TJvImgBtn; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAboutJVCL_W(Self: TJvImgBtn; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnAboutJVCL_R(Self: TJvImgBtn; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnMouseInControl_R(Self: TJvImgBtn; var T: Boolean);
begin T := Self.MouseInControl; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnCurrentAnimateFrame_R(Self: TJvImgBtn; var T: Byte);
begin T := Self.CurrentAnimateFrame; end;

(*----------------------------------------------------------------------------*)
procedure TJvImgBtnCanvas_R(Self: TJvImgBtn; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvImgBtn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvImgBtn) do
  begin
    RegisterConstructor(@TJvImgBtn.Create, 'Create');
    RegisterMethod(@TJvImgBtn.Destroy, 'Free');
    RegisterMethod(@TJvImgBtn.click, 'Click');
    RegisterMethod(@TJvImgBtn.DrawButtonImage, 'DrawButtonImage');
    RegisterMethod(@TJvImgBtn.DrawButtonFocusRect, 'DrawButtonFocusRect');
    RegisterMethod(@TJvImgBtn.DrawButtonFrame, 'DrawButtonFrame');
    RegisterMethod(@TJvImgBtn.DrawButtonText, 'DrawButtonText');
    RegisterPropertyHelper(@TJvImgBtnCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TJvImgBtnCurrentAnimateFrame_R,nil,'CurrentAnimateFrame');
    RegisterPropertyHelper(@TJvImgBtnMouseInControl_R,nil,'MouseInControl');
    RegisterPropertyHelper(@TJvImgBtnAboutJVCL_R,@TJvImgBtnAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvImgBtnAlignment_R,@TJvImgBtnAlignment_W,'Alignment');
    RegisterPropertyHelper(@TJvImgBtnAnimate_R,@TJvImgBtnAnimate_W,'Animate');
    RegisterPropertyHelper(@TJvImgBtnAnimateFrames_R,@TJvImgBtnAnimateFrames_W,'AnimateFrames');
    RegisterPropertyHelper(@TJvImgBtnAnimateInterval_R,@TJvImgBtnAnimateInterval_W,'AnimateInterval');
    RegisterPropertyHelper(@TJvImgBtnImages_R,@TJvImgBtnImages_W,'Images');
    RegisterPropertyHelper(@TJvImgBtnImageIndex_R,@TJvImgBtnImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TJvImgBtnImageVisible_R,@TJvImgBtnImageVisible_W,'ImageVisible');
    RegisterPropertyHelper(@TJvImgBtnKind_R,@TJvImgBtnKind_W,'Kind');
    RegisterPropertyHelper(@TJvImgBtnLayout_R,@TJvImgBtnLayout_W,'Layout');
    RegisterPropertyHelper(@TJvImgBtnMargin_R,@TJvImgBtnMargin_W,'Margin');
    RegisterPropertyHelper(@TJvImgBtnOwnerDraw_R,@TJvImgBtnOwnerDraw_W,'OwnerDraw');
    RegisterPropertyHelper(@TJvImgBtnSpacing_R,@TJvImgBtnSpacing_W,'Spacing');
    RegisterPropertyHelper(@TJvImgBtnOnButtonDraw_R,@TJvImgBtnOnButtonDraw_W,'OnButtonDraw');
    RegisterPropertyHelper(@TJvImgBtnOnGetAnimateIndex_R,@TJvImgBtnOnGetAnimateIndex_W,'OnGetAnimateIndex');
    RegisterPropertyHelper(@TJvImgBtnOnMouseEnter_R,@TJvImgBtnOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TJvImgBtnOnMouseLeave_R,@TJvImgBtnOnMouseLeave_W,'OnMouseLeave');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvImgBtnActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvImgBtnActionLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvListBox) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCtrls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvListBox(CL);
  with CL.Add(TJvImgBtn) do
  RIRegister_TJvImgBtnActionLink(CL);
  RIRegister_TJvImgBtn(CL);
end;

 
 
{ TPSImport_JvCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCtrls(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
