unit uPSI_cyColorMatrix;
{
   the matrix
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
  TPSImport_cyColorMatrix = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyColorMatrix(CL: TPSPascalCompiler);
procedure SIRegister_TcyCustomColorMatrix(CL: TPSPascalCompiler);
procedure SIRegister_cyColorMatrix(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyColorMatrix(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcyCustomColorMatrix(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyColorMatrix(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Types
  ,Controls
  ,Graphics
  ,Messages
  ,ExtCtrls
  ,cyTypes
  ,cyClasses
  ,cyBaseColorMatrix
  ,cyColorMatrix
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyColorMatrix]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyColorMatrix(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyCustomColorMatrix', 'TcyColorMatrix') do
  with CL.AddClassN(CL.FindClass('TcyCustomColorMatrix'),'TcyColorMatrix') do begin
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
    RegisterProperty('Bevels', 'tcyBevels', iptrw);
    RegisterProperty('Wallpaper', 'TcyBgPicture', iptrw);
      RegisterProperty('onClick', 'TNotifyEvent', iptrw);
    RegisterProperty('onDblClick', 'TNotifyEvent', iptrw);
    RegisterProperty('Background', 'TcyGradient', iptrw);
    RegisterProperty('BorderWidth', 'Integer', iptrw);
    RegisterProperty('CellHeight', 'integer', iptrw);
    RegisterProperty('CellWidth', 'Integer', iptrw);
    RegisterProperty('ColCount', 'integer', iptrw);
    RegisterProperty('RowCount', 'Integer', iptrw);
    RegisterProperty('CellFrameColor', 'TColor', iptrw);
    RegisterProperty('CellFrameWidth', 'Integer', iptrw);
    RegisterProperty('CellSpacingWidth', 'integer', iptrw);
    RegisterProperty('CellSpacingHeight', 'Integer', iptrw);
    RegisterProperty('DefaultColor', 'TColor', iptrw);
    RegisterProperty('TopRowValue', 'Double', iptrw);
    RegisterProperty('OnPaint', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCellClick', 'TProcOnCellClick', iptrw);
    RegisterProperty('OnCustomDrawCell', 'TProcOnDrawCell', iptrw);
    RegisterProperty('LeftColumnValue', 'Double', iptrw);
    RegisterProperty('BottomRowValue', 'Double', iptrw);
    RegisterProperty('RightColumnValue', 'Double', iptrw);

    {FRightColumnValue: Double;
    FBottomRowValue: Double;
    property BottomRowValue;
    property RightColumnValue;}
   //property Bevels;
   // property Wallpaper;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyCustomColorMatrix(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyBaseColorMatrix', 'TcyCustomColorMatrix') do
  with CL.AddClassN(CL.FindClass('TcyBaseColorMatrix'),'TcyCustomColorMatrix') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyColorMatrix(CL: TPSPascalCompiler);
begin
  SIRegister_TcyCustomColorMatrix(CL);
  SIRegister_TcyColorMatrix(CL);
end;

procedure TBitmapCanvas_R(Self: TcyColorMatrix; var T: TCanvas); begin T:= Self.Canvas; end;
//procedure TBitmapCanvas_W(Self: TcyColorMatrix; var T: TCanvas); begin Self.Canvas:= T; end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyColorMatrix(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyColorMatrix) do begin
      RegisterPropertyHelper(@TBitmapCanvas_R,NIL{@TBitmapCanvas_W},'Canvas');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyCustomColorMatrix(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyCustomColorMatrix) do begin
    RegisterConstructor(@TcyCustomColorMatrix.Create, 'Create');
    RegisterMethod(@TcyCustomColorMatrix.Destroy, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyColorMatrix(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyCustomColorMatrix(CL);
  RIRegister_TcyColorMatrix(CL);
end;

 
 
{ TPSImport_cyColorMatrix }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyColorMatrix.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyColorMatrix(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyColorMatrix.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyColorMatrix(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
