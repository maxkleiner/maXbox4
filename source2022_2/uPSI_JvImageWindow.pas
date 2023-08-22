unit uPSI_JvImageWindow;
{
  in compare with image32
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
  TPSImport_JvImageWindow = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvImageSquare(CL: TPSPascalCompiler);
procedure SIRegister_TJvImageWindow(CL: TPSPascalCompiler);
procedure SIRegister_JvImageWindow(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvImageSquare(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvImageWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvImageWindow(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,ExtCtrls
  ,CommCtrl
  ,ImgList
  ,JvComponent
  ,JvImageWindow
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvImageWindow]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvImageSquare(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvImageSquare') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvImageSquare') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('HiColor', 'TColor', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ImageList', 'TImageList', iptrw);
    RegisterProperty('ImageIndex', 'Integer', iptrw);
    RegisterProperty('ShowClick', 'Boolean', iptrw);
    RegisterProperty('OnEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExit', 'TNotifyEvent', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvImageWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvImageWindow') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvImageWindow') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SaveImage( Index : Integer; Filename : string; AsBmp : Boolean)');
    RegisterMethod('Procedure SaveImageList( Filename : string)');
    RegisterProperty('ImageIndex', 'Integer', iptr);
    RegisterProperty('Optimal', 'Boolean', iptrw);
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('FrontColor', 'TColor', iptrw);
    RegisterProperty('Ghost', 'Boolean', iptrw);
    RegisterProperty('Margin', 'TJvMargin', iptrw);
    RegisterProperty('ColCount', 'TJvPositive', iptrw);
    RegisterProperty('ImageCount', 'Integer', iptrw);
    RegisterProperty('ImageList', 'TImageList', iptrw);
    RegisterProperty('ShowFrame', 'Boolean', iptrw);
    RegisterProperty('ShowGrid', 'Boolean', iptrw);
    RegisterProperty('GridColor', 'TColor', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvImageWindow(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvMargin', 'Integer');
  CL.AddTypeS('TJvPositive', 'Integer');
  SIRegister_TJvImageWindow(CL);
  SIRegister_TJvImageSquare(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvImageSquareOnExit_W(Self: TJvImageSquare; const T: TNotifyEvent);
begin Self.OnExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareOnExit_R(Self: TJvImageSquare; var T: TNotifyEvent);
begin T := Self.OnExit; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareOnEnter_W(Self: TJvImageSquare; const T: TNotifyEvent);
begin Self.OnEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareOnEnter_R(Self: TJvImageSquare; var T: TNotifyEvent);
begin T := Self.OnEnter; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareShowClick_W(Self: TJvImageSquare; const T: Boolean);
begin Self.ShowClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareShowClick_R(Self: TJvImageSquare; var T: Boolean);
begin T := Self.ShowClick; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareImageIndex_W(Self: TJvImageSquare; const T: Integer);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareImageIndex_R(Self: TJvImageSquare; var T: Integer);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareImageList_W(Self: TJvImageSquare; const T: TImageList);
begin Self.ImageList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareImageList_R(Self: TJvImageSquare; var T: TImageList);
begin T := Self.ImageList; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareBorderStyle_W(Self: TJvImageSquare; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareBorderStyle_R(Self: TJvImageSquare; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareBackColor_W(Self: TJvImageSquare; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareBackColor_R(Self: TJvImageSquare; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareHiColor_W(Self: TJvImageSquare; const T: TColor);
begin Self.HiColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageSquareHiColor_R(Self: TJvImageSquare; var T: TColor);
begin T := Self.HiColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowGridColor_W(Self: TJvImageWindow; const T: TColor);
begin Self.GridColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowGridColor_R(Self: TJvImageWindow; var T: TColor);
begin T := Self.GridColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowShowGrid_W(Self: TJvImageWindow; const T: Boolean);
begin Self.ShowGrid := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowShowGrid_R(Self: TJvImageWindow; var T: Boolean);
begin T := Self.ShowGrid; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowShowFrame_W(Self: TJvImageWindow; const T: Boolean);
begin Self.ShowFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowShowFrame_R(Self: TJvImageWindow; var T: Boolean);
begin T := Self.ShowFrame; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowImageList_W(Self: TJvImageWindow; const T: TImageList);
begin Self.ImageList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowImageList_R(Self: TJvImageWindow; var T: TImageList);
begin T := Self.ImageList; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowImageCount_W(Self: TJvImageWindow; const T: Integer);
begin Self.ImageCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowImageCount_R(Self: TJvImageWindow; var T: Integer);
begin T := Self.ImageCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowColCount_W(Self: TJvImageWindow; const T: TJvPositive);
begin Self.ColCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowColCount_R(Self: TJvImageWindow; var T: TJvPositive);
begin T := Self.ColCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowMargin_W(Self: TJvImageWindow; const T: TJvMargin);
begin Self.Margin := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowMargin_R(Self: TJvImageWindow; var T: TJvMargin);
begin T := Self.Margin; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowGhost_W(Self: TJvImageWindow; const T: Boolean);
begin Self.Ghost := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowGhost_R(Self: TJvImageWindow; var T: Boolean);
begin T := Self.Ghost; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowFrontColor_W(Self: TJvImageWindow; const T: TColor);
begin Self.FrontColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowFrontColor_R(Self: TJvImageWindow; var T: TColor);
begin T := Self.FrontColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowBackColor_W(Self: TJvImageWindow; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowBackColor_R(Self: TJvImageWindow; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowAutoSize_W(Self: TJvImageWindow; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowAutoSize_R(Self: TJvImageWindow; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowOptimal_W(Self: TJvImageWindow; const T: Boolean);
begin Self.Optimal := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowOptimal_R(Self: TJvImageWindow; var T: Boolean);
begin T := Self.Optimal; end;

(*----------------------------------------------------------------------------*)
procedure TJvImageWindowImageIndex_R(Self: TJvImageWindow; var T: Integer);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvImageSquare(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvImageSquare) do begin
    RegisterConstructor(@TJvImageSquare.Create, 'Create');
    RegisterPropertyHelper(@TJvImageSquareHiColor_R,@TJvImageSquareHiColor_W,'HiColor');
    RegisterPropertyHelper(@TJvImageSquareBackColor_R,@TJvImageSquareBackColor_W,'BackColor');
    RegisterPropertyHelper(@TJvImageSquareBorderStyle_R,@TJvImageSquareBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TJvImageSquareImageList_R,@TJvImageSquareImageList_W,'ImageList');
    RegisterPropertyHelper(@TJvImageSquareImageIndex_R,@TJvImageSquareImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TJvImageSquareShowClick_R,@TJvImageSquareShowClick_W,'ShowClick');
    RegisterPropertyHelper(@TJvImageSquareOnEnter_R,@TJvImageSquareOnEnter_W,'OnEnter');
    RegisterPropertyHelper(@TJvImageSquareOnExit_R,@TJvImageSquareOnExit_W,'OnExit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvImageWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvImageWindow) do begin
    RegisterConstructor(@TJvImageWindow.Create, 'Create');
    RegisterMethod(@TJvImageWindow.SaveImage, 'SaveImage');
    RegisterMethod(@TJvImageWindow.SaveImageList, 'SaveImageList');
    RegisterPropertyHelper(@TJvImageWindowImageIndex_R,nil,'ImageIndex');
    RegisterPropertyHelper(@TJvImageWindowOptimal_R,@TJvImageWindowOptimal_W,'Optimal');
    RegisterPropertyHelper(@TJvImageWindowAutoSize_R,@TJvImageWindowAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TJvImageWindowBackColor_R,@TJvImageWindowBackColor_W,'BackColor');
    RegisterPropertyHelper(@TJvImageWindowFrontColor_R,@TJvImageWindowFrontColor_W,'FrontColor');
    RegisterPropertyHelper(@TJvImageWindowGhost_R,@TJvImageWindowGhost_W,'Ghost');
    RegisterPropertyHelper(@TJvImageWindowMargin_R,@TJvImageWindowMargin_W,'Margin');
    RegisterPropertyHelper(@TJvImageWindowColCount_R,@TJvImageWindowColCount_W,'ColCount');
    RegisterPropertyHelper(@TJvImageWindowImageCount_R,@TJvImageWindowImageCount_W,'ImageCount');
    RegisterPropertyHelper(@TJvImageWindowImageList_R,@TJvImageWindowImageList_W,'ImageList');
    RegisterPropertyHelper(@TJvImageWindowShowFrame_R,@TJvImageWindowShowFrame_W,'ShowFrame');
    RegisterPropertyHelper(@TJvImageWindowShowGrid_R,@TJvImageWindowShowGrid_W,'ShowGrid');
    RegisterPropertyHelper(@TJvImageWindowGridColor_R,@TJvImageWindowGridColor_W,'GridColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvImageWindow(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvImageWindow(CL);
  RIRegister_TJvImageSquare(CL);
end;

 
 
{ TPSImport_JvImageWindow }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvImageWindow.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvImageWindow(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvImageWindow.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvImageWindow(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
