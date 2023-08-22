unit uPSI_GraphWin;
{
   FormTemplateLibrary FTL FormPrototypLibrary FPL
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
  TPSImport_GraphWin = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
procedure SIRegister_GraphWin(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_GraphWin(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Buttons
  ,ExtCtrls
  ,StdCtrls
  ,ComCtrls
  ,Menus
  ,GraphWin
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GraphWin]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TGraphWinForm') do begin
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('LineButton', 'TSpeedButton', iptrw);
    RegisterProperty('RectangleButton', 'TSpeedButton', iptrw);
    RegisterProperty('EllipseButton', 'TSpeedButton', iptrw);
    RegisterProperty('RoundRectButton', 'TSpeedButton', iptrw);
    RegisterProperty('PenButton', 'TSpeedButton', iptrw);
    RegisterProperty('BrushButton', 'TSpeedButton', iptrw);
    RegisterProperty('PenBar', 'TPanel', iptrw);
    RegisterProperty('BrushBar', 'TPanel', iptrw);
    RegisterProperty('SolidPen', 'TSpeedButton', iptrw);
    RegisterProperty('DashPen', 'TSpeedButton', iptrw);
    RegisterProperty('DotPen', 'TSpeedButton', iptrw);
    RegisterProperty('DashDotPen', 'TSpeedButton', iptrw);
    RegisterProperty('DashDotDotPen', 'TSpeedButton', iptrw);
    RegisterProperty('ClearPen', 'TSpeedButton', iptrw);
    RegisterProperty('PenWidth', 'TUpDown', iptrw);
    RegisterProperty('PenSize', 'TEdit', iptrw);
    RegisterProperty('StatusBar1', 'TStatusBar', iptrw);
    RegisterProperty('ScrollBox1', 'TScrollBox', iptrw);
    RegisterProperty('Image', 'TImage', iptrw);
    RegisterProperty('SolidBrush', 'TSpeedButton', iptrw);
    RegisterProperty('ClearBrush', 'TSpeedButton', iptrw);
    RegisterProperty('HorizontalBrush', 'TSpeedButton', iptrw);
    RegisterProperty('VerticalBrush', 'TSpeedButton', iptrw);
    RegisterProperty('FDiagonalBrush', 'TSpeedButton', iptrw);
    RegisterProperty('BDiagonalBrush', 'TSpeedButton', iptrw);
    RegisterProperty('CrossBrush', 'TSpeedButton', iptrw);
    RegisterProperty('DiagCrossBrush', 'TSpeedButton', iptrw);
    RegisterProperty('PenColor', 'TSpeedButton', iptrw);
    RegisterProperty('BrushColor', 'TSpeedButton', iptrw);
    RegisterProperty('ColorDialog1', 'TColorDialog', iptrw);
    RegisterProperty('MainMenu1', 'TMainMenu', iptrw);
    RegisterProperty('File1', 'TMenuItem', iptrw);
    RegisterProperty('New1', 'TMenuItem', iptrw);
    RegisterProperty('Open1', 'TMenuItem', iptrw);
    RegisterProperty('Save1', 'TMenuItem', iptrw);
    RegisterProperty('Saveas1', 'TMenuItem', iptrw);
    RegisterProperty('N1', 'TMenuItem', iptrw);
    RegisterProperty('Exit1', 'TMenuItem', iptrw);
    RegisterProperty('Edit1', 'TMenuItem', iptrw);
    RegisterProperty('Cut1', 'TMenuItem', iptrw);
    RegisterProperty('Copy1', 'TMenuItem', iptrw);
    RegisterProperty('Paste1', 'TMenuItem', iptrw);
    RegisterProperty('OpenDialog1', 'TOpenDialog', iptrw);
    RegisterProperty('SaveDialog1', 'TSaveDialog', iptrw);
    RegisterMethod('Procedure FormMouseDown( Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure FormMouseUp( Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure FormMouseMove( Sender : TObject; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure LineButtonClick( Sender : TObject)');
    RegisterMethod('Procedure RectangleButtonClick( Sender : TObject)');
    RegisterMethod('Procedure EllipseButtonClick( Sender : TObject)');
    RegisterMethod('Procedure RoundRectButtonClick( Sender : TObject)');
    RegisterMethod('Procedure PenButtonClick( Sender : TObject)');
    RegisterMethod('Procedure BrushButtonClick( Sender : TObject)');
    RegisterMethod('Procedure SetPenStyle( Sender : TObject)');
    RegisterMethod('Procedure PenSizeChange( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure SetBrushStyle( Sender : TObject)');
    RegisterMethod('Procedure PenColorClick( Sender : TObject)');
    RegisterMethod('Procedure BrushColorClick( Sender : TObject)');
    RegisterMethod('Procedure Exit1Click( Sender : TObject)');
    RegisterMethod('Procedure Open1Click( Sender : TObject)');
    RegisterMethod('Procedure Save1Click( Sender : TObject)');
    RegisterMethod('Procedure Saveas1Click( Sender : TObject)');
    RegisterMethod('Procedure New1Click( Sender : TObject)');
    RegisterMethod('Procedure Copy1Click( Sender : TObject)');
    RegisterMethod('Procedure Cut1Click( Sender : TObject)');
    RegisterMethod('Procedure Paste1Click( Sender : TObject)');
    RegisterProperty('BrushStyle', 'TBrushStyle', iptrw);
    RegisterProperty('PenStyle', 'TPenStyle', iptrw);
    RegisterProperty('PenWide', 'Integer', iptrw);
    RegisterProperty('Drawing', 'Boolean', iptrw);
    RegisterProperty('Origin', 'TPoint', iptrw);
    RegisterProperty('MovePt', 'TPoint', iptrw);
    RegisterProperty('DrawingTool', 'TDrawingTool', iptrw);
    RegisterProperty('CurrentFile', 'string', iptrw);
    RegisterMethod('Procedure SaveStyles');
    RegisterMethod('Procedure RestoreStyles');
    RegisterMethod('Procedure DrawShape( TopLeft, BottomRight : TPoint; AMode : TPenMode)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GraphWin(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDrawingTool', '( dtLine, dtRectangle, dtEllipse, dtRoundRect )');
  SIRegister_TForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm1CurrentFile_W(Self: TGraphWinForm; const T: string);
Begin Self.CurrentFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1CurrentFile_R(Self: TGraphWinForm; var T: string);
Begin T := Self.CurrentFile; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DrawingTool_W(Self: TGraphWinForm; const T: TDrawingTool);
Begin Self.DrawingTool := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DrawingTool_R(Self: TGraphWinForm; var T: TDrawingTool);
Begin T := Self.DrawingTool; end;

(*----------------------------------------------------------------------------*)
procedure TForm1MovePt_W(Self: TGraphWinForm; const T: TPoint);
Begin Self.MovePt := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1MovePt_R(Self: TGraphWinForm; var T: TPoint);
Begin T := Self.MovePt; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Origin_W(Self: TGraphWinForm; const T: TPoint);
Begin Self.Origin := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Origin_R(Self: TGraphWinForm; var T: TPoint);
Begin T := Self.Origin; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Drawing_W(Self: TGraphWinForm; const T: Boolean);
Begin Self.Drawing := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Drawing_R(Self: TGraphWinForm; var T: Boolean);
Begin T := Self.Drawing; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenWide_W(Self: TGraphWinForm; const T: Integer);
Begin Self.PenWide := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenWide_R(Self: TGraphWinForm; var T: Integer);
Begin T := Self.PenWide; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenStyle_W(Self: TGraphWinForm; const T: TPenStyle);
Begin Self.PenStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenStyle_R(Self: TGraphWinForm; var T: TPenStyle);
Begin T := Self.PenStyle; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushStyle_W(Self: TGraphWinForm; const T: TBrushStyle);
Begin Self.BrushStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushStyle_R(Self: TGraphWinForm; var T: TBrushStyle);
Begin T := Self.BrushStyle; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SaveDialog1_W(Self: TGraphWinForm; const T: TSaveDialog);
Begin Self.SaveDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SaveDialog1_R(Self: TGraphWinForm; var T: TSaveDialog);
Begin T := Self.SaveDialog1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenDialog1_W(Self: TGraphWinForm; const T: TOpenDialog);
Begin Self.OpenDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenDialog1_R(Self: TGraphWinForm; var T: TOpenDialog);
Begin T := Self.OpenDialog1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Paste1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Paste1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Paste1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Paste1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Copy1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Copy1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Copy1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Copy1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Cut1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Cut1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Cut1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Cut1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Edit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Edit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Exit1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Exit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Exit1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Exit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.N1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.N1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Saveas1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Saveas1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Saveas1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Saveas1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Save1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Save1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Save1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Save1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Open1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.Open1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Open1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.Open1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1New1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.New1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1New1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.New1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1File1_W(Self: TGraphWinForm; const T: TMenuItem);
Begin Self.File1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1File1_R(Self: TGraphWinForm; var T: TMenuItem);
Begin T := Self.File1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1MainMenu1_W(Self: TGraphWinForm; const T: TMainMenu);
Begin Self.MainMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1MainMenu1_R(Self: TGraphWinForm; var T: TMainMenu);
Begin T := Self.MainMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ColorDialog1_W(Self: TGraphWinForm; const T: TColorDialog);
Begin Self.ColorDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ColorDialog1_R(Self: TGraphWinForm; var T: TColorDialog);
Begin T := Self.ColorDialog1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushColor_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.BrushColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushColor_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.BrushColor; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenColor_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.PenColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenColor_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.PenColor; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DiagCrossBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.DiagCrossBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DiagCrossBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.DiagCrossBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1CrossBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.CrossBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1CrossBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.CrossBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BDiagonalBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.BDiagonalBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BDiagonalBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.BDiagonalBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FDiagonalBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.FDiagonalBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FDiagonalBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.FDiagonalBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1VerticalBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.VerticalBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1VerticalBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.VerticalBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1HorizontalBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.HorizontalBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1HorizontalBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.HorizontalBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ClearBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.ClearBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ClearBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.ClearBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SolidBrush_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.SolidBrush := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SolidBrush_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.SolidBrush; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Image_W(Self: TGraphWinForm; const T: TImage);
Begin Self.Image := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Image_R(Self: TGraphWinForm; var T: TImage);
Begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ScrollBox1_W(Self: TGraphWinForm; const T: TScrollBox);
Begin Self.ScrollBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ScrollBox1_R(Self: TGraphWinForm; var T: TScrollBox);
Begin T := Self.ScrollBox1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StatusBar1_W(Self: TGraphWinForm; const T: TStatusBar);
Begin Self.StatusBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StatusBar1_R(Self: TGraphWinForm; var T: TStatusBar);
Begin T := Self.StatusBar1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenSize_W(Self: TGraphWinForm; const T: TEdit);
Begin Self.PenSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenSize_R(Self: TGraphWinForm; var T: TEdit);
Begin T := Self.PenSize; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenWidth_W(Self: TGraphWinForm; const T: TUpDown);
Begin Self.PenWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenWidth_R(Self: TGraphWinForm; var T: TUpDown);
Begin T := Self.PenWidth; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ClearPen_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.ClearPen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ClearPen_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.ClearPen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DashDotDotPen_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.DashDotDotPen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DashDotDotPen_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.DashDotDotPen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DashDotPen_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.DashDotPen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DashDotPen_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.DashDotPen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DotPen_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.DotPen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DotPen_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.DotPen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DashPen_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.DashPen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DashPen_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.DashPen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SolidPen_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.SolidPen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SolidPen_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.SolidPen; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushBar_W(Self: TGraphWinForm; const T: TPanel);
Begin Self.BrushBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushBar_R(Self: TGraphWinForm; var T: TPanel);
Begin T := Self.BrushBar; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenBar_W(Self: TGraphWinForm; const T: TPanel);
Begin Self.PenBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenBar_R(Self: TGraphWinForm; var T: TPanel);
Begin T := Self.PenBar; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushButton_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.BrushButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrushButton_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.BrushButton; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenButton_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.PenButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PenButton_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.PenButton; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RoundRectButton_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.RoundRectButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RoundRectButton_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.RoundRectButton; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EllipseButton_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.EllipseButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EllipseButton_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.EllipseButton; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RectangleButton_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.RectangleButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RectangleButton_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.RectangleButton; end;

(*----------------------------------------------------------------------------*)
procedure TForm1LineButton_W(Self: TGraphWinForm; const T: TSpeedButton);
Begin Self.LineButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1LineButton_R(Self: TGraphWinForm; var T: TSpeedButton);
Begin T := Self.LineButton; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_W(Self: TGraphWinForm; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_R(Self: TGraphWinForm; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGraphWinForm) do begin
    RegisterPropertyHelper(@TForm1Panel1_R,@TForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TForm1LineButton_R,@TForm1LineButton_W,'LineButton');
    RegisterPropertyHelper(@TForm1RectangleButton_R,@TForm1RectangleButton_W,'RectangleButton');
    RegisterPropertyHelper(@TForm1EllipseButton_R,@TForm1EllipseButton_W,'EllipseButton');
    RegisterPropertyHelper(@TForm1RoundRectButton_R,@TForm1RoundRectButton_W,'RoundRectButton');
    RegisterPropertyHelper(@TForm1PenButton_R,@TForm1PenButton_W,'PenButton');
    RegisterPropertyHelper(@TForm1BrushButton_R,@TForm1BrushButton_W,'BrushButton');
    RegisterPropertyHelper(@TForm1PenBar_R,@TForm1PenBar_W,'PenBar');
    RegisterPropertyHelper(@TForm1BrushBar_R,@TForm1BrushBar_W,'BrushBar');
    RegisterPropertyHelper(@TForm1SolidPen_R,@TForm1SolidPen_W,'SolidPen');
    RegisterPropertyHelper(@TForm1DashPen_R,@TForm1DashPen_W,'DashPen');
    RegisterPropertyHelper(@TForm1DotPen_R,@TForm1DotPen_W,'DotPen');
    RegisterPropertyHelper(@TForm1DashDotPen_R,@TForm1DashDotPen_W,'DashDotPen');
    RegisterPropertyHelper(@TForm1DashDotDotPen_R,@TForm1DashDotDotPen_W,'DashDotDotPen');
    RegisterPropertyHelper(@TForm1ClearPen_R,@TForm1ClearPen_W,'ClearPen');
    RegisterPropertyHelper(@TForm1PenWidth_R,@TForm1PenWidth_W,'PenWidth');
    RegisterPropertyHelper(@TForm1PenSize_R,@TForm1PenSize_W,'PenSize');
    RegisterPropertyHelper(@TForm1StatusBar1_R,@TForm1StatusBar1_W,'StatusBar1');
    RegisterPropertyHelper(@TForm1ScrollBox1_R,@TForm1ScrollBox1_W,'ScrollBox1');
    RegisterPropertyHelper(@TForm1Image_R,@TForm1Image_W,'Image');
    RegisterPropertyHelper(@TForm1SolidBrush_R,@TForm1SolidBrush_W,'SolidBrush');
    RegisterPropertyHelper(@TForm1ClearBrush_R,@TForm1ClearBrush_W,'ClearBrush');
    RegisterPropertyHelper(@TForm1HorizontalBrush_R,@TForm1HorizontalBrush_W,'HorizontalBrush');
    RegisterPropertyHelper(@TForm1VerticalBrush_R,@TForm1VerticalBrush_W,'VerticalBrush');
    RegisterPropertyHelper(@TForm1FDiagonalBrush_R,@TForm1FDiagonalBrush_W,'FDiagonalBrush');
    RegisterPropertyHelper(@TForm1BDiagonalBrush_R,@TForm1BDiagonalBrush_W,'BDiagonalBrush');
    RegisterPropertyHelper(@TForm1CrossBrush_R,@TForm1CrossBrush_W,'CrossBrush');
    RegisterPropertyHelper(@TForm1DiagCrossBrush_R,@TForm1DiagCrossBrush_W,'DiagCrossBrush');
    RegisterPropertyHelper(@TForm1PenColor_R,@TForm1PenColor_W,'PenColor');
    RegisterPropertyHelper(@TForm1BrushColor_R,@TForm1BrushColor_W,'BrushColor');
    RegisterPropertyHelper(@TForm1ColorDialog1_R,@TForm1ColorDialog1_W,'ColorDialog1');
    RegisterPropertyHelper(@TForm1MainMenu1_R,@TForm1MainMenu1_W,'MainMenu1');
    RegisterPropertyHelper(@TForm1File1_R,@TForm1File1_W,'File1');
    RegisterPropertyHelper(@TForm1New1_R,@TForm1New1_W,'New1');
    RegisterPropertyHelper(@TForm1Open1_R,@TForm1Open1_W,'Open1');
    RegisterPropertyHelper(@TForm1Save1_R,@TForm1Save1_W,'Save1');
    RegisterPropertyHelper(@TForm1Saveas1_R,@TForm1Saveas1_W,'Saveas1');
    RegisterPropertyHelper(@TForm1N1_R,@TForm1N1_W,'N1');
    RegisterPropertyHelper(@TForm1Exit1_R,@TForm1Exit1_W,'Exit1');
    RegisterPropertyHelper(@TForm1Edit1_R,@TForm1Edit1_W,'Edit1');
    RegisterPropertyHelper(@TForm1Cut1_R,@TForm1Cut1_W,'Cut1');
    RegisterPropertyHelper(@TForm1Copy1_R,@TForm1Copy1_W,'Copy1');
    RegisterPropertyHelper(@TForm1Paste1_R,@TForm1Paste1_W,'Paste1');
    RegisterPropertyHelper(@TForm1OpenDialog1_R,@TForm1OpenDialog1_W,'OpenDialog1');
    RegisterPropertyHelper(@TForm1SaveDialog1_R,@TForm1SaveDialog1_W,'SaveDialog1');
    RegisterMethod(@TGraphWinForm.FormMouseDown, 'FormMouseDown');
    RegisterMethod(@TGraphWinForm.FormMouseUp, 'FormMouseUp');
    RegisterMethod(@TGraphWinForm.FormMouseMove, 'FormMouseMove');
    RegisterMethod(@TGraphWinForm.LineButtonClick, 'LineButtonClick');
    RegisterMethod(@TGraphWinForm.RectangleButtonClick, 'RectangleButtonClick');
    RegisterMethod(@TGraphWinForm.EllipseButtonClick, 'EllipseButtonClick');
    RegisterMethod(@TGraphWinForm.RoundRectButtonClick, 'RoundRectButtonClick');
    RegisterMethod(@TGraphWinForm.PenButtonClick, 'PenButtonClick');
    RegisterMethod(@TGraphWinForm.BrushButtonClick, 'BrushButtonClick');
    RegisterMethod(@TGraphWinForm.SetPenStyle, 'SetPenStyle');
    RegisterMethod(@TGraphWinForm.PenSizeChange, 'PenSizeChange');
    RegisterMethod(@TGraphWinForm.FormCreate, 'FormCreate');
    RegisterMethod(@TGraphWinForm.SetBrushStyle, 'SetBrushStyle');
    RegisterMethod(@TGraphWinForm.PenColorClick, 'PenColorClick');
    RegisterMethod(@TGraphWinForm.BrushColorClick, 'BrushColorClick');
    RegisterMethod(@TGraphWinForm.Exit1Click, 'Exit1Click');
    RegisterMethod(@TGraphWinForm.Open1Click, 'Open1Click');
    RegisterMethod(@TGraphWinForm.Save1Click, 'Save1Click');
    RegisterMethod(@TGraphWinForm.Saveas1Click, 'Saveas1Click');
    RegisterMethod(@TGraphWinForm.New1Click, 'New1Click');
    RegisterMethod(@TGraphWinForm.Copy1Click, 'Copy1Click');
    RegisterMethod(@TGraphWinForm.Cut1Click, 'Cut1Click');
    RegisterMethod(@TGraphWinForm.Paste1Click, 'Paste1Click');
    RegisterPropertyHelper(@TForm1BrushStyle_R,@TForm1BrushStyle_W,'BrushStyle');
    RegisterPropertyHelper(@TForm1PenStyle_R,@TForm1PenStyle_W,'PenStyle');
    RegisterPropertyHelper(@TForm1PenWide_R,@TForm1PenWide_W,'PenWide');
    RegisterPropertyHelper(@TForm1Drawing_R,@TForm1Drawing_W,'Drawing');
    RegisterPropertyHelper(@TForm1Origin_R,@TForm1Origin_W,'Origin');
    RegisterPropertyHelper(@TForm1MovePt_R,@TForm1MovePt_W,'MovePt');
    RegisterPropertyHelper(@TForm1DrawingTool_R,@TForm1DrawingTool_W,'DrawingTool');
    RegisterPropertyHelper(@TForm1CurrentFile_R,@TForm1CurrentFile_W,'CurrentFile');
    RegisterMethod(@TGraphWinForm.SaveStyles, 'SaveStyles');
    RegisterMethod(@TGraphWinForm.RestoreStyles, 'RestoreStyles');
    RegisterMethod(@TGraphWinForm.DrawShape, 'DrawShape');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GraphWin(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm1(CL);
end;

 
 
{ TPSImport_GraphWin }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphWin.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GraphWin(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphWin.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GraphWin(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
