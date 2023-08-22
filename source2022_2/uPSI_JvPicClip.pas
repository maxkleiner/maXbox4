unit uPSI_JvPicClip;
{
  for file searcher
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
  TPSImport_JvPicClip = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvPicClip(CL: TPSPascalCompiler);
procedure SIRegister_JvPicClip(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvPicClip(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvPicClip(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,RTLConsts
  ,Graphics
  ,JvPicClip
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvPicClip]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPicClip(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvPicClip') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvPicClip') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function GetIndex( Col, Row : Cardinal) : Integer');
    RegisterMethod('Procedure Draw( Canvas : TCanvas; X, Y, Index : Integer)');
    RegisterMethod('Procedure DrawCenter( Canvas : TCanvas; Rect : TRect; Index : Integer)');
    RegisterMethod('Procedure LoadBitmapRes( Instance : THandle; ResID : PChar)');
    RegisterProperty('Cells', 'TBitmap Cardinal Cardinal', iptr);
    RegisterProperty('GraphicCell', 'TBitmap Integer', iptr);
    RegisterProperty('IsEmpty', 'Boolean', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Cols', 'TCellRange', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Masked', 'Boolean', iptrw);
    RegisterProperty('Rows', 'TCellRange', iptrw);
    RegisterProperty('Picture', 'TPicture', iptrw);
    RegisterProperty('MaskColor', 'TColor', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvPicClip(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCellRange', 'Integer');
  SIRegister_TJvPicClip(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvPicClipOnChange_W(Self: TJvPicClip; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipOnChange_R(Self: TJvPicClip; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipWidth_W(Self: TJvPicClip; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipWidth_R(Self: TJvPicClip; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipMaskColor_W(Self: TJvPicClip; const T: TColor);
begin Self.MaskColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipMaskColor_R(Self: TJvPicClip; var T: TColor);
begin T := Self.MaskColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipPicture_W(Self: TJvPicClip; const T: TPicture);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipPicture_R(Self: TJvPicClip; var T: TPicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipRows_W(Self: TJvPicClip; const T: TCellRange);
begin Self.Rows := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipRows_R(Self: TJvPicClip; var T: TCellRange);
begin T := Self.Rows; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipMasked_W(Self: TJvPicClip; const T: Boolean);
begin Self.Masked := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipMasked_R(Self: TJvPicClip; var T: Boolean);
begin T := Self.Masked; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipHeight_W(Self: TJvPicClip; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipHeight_R(Self: TJvPicClip; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipCols_W(Self: TJvPicClip; const T: TCellRange);
begin Self.Cols := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipCols_R(Self: TJvPicClip; var T: TCellRange);
begin T := Self.Cols; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipCount_R(Self: TJvPicClip; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipIsEmpty_R(Self: TJvPicClip; var T: Boolean);
begin T := Self.IsEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipGraphicCell_R(Self: TJvPicClip; var T: TBitmap; const t1: Integer);
begin T := Self.GraphicCell[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvPicClipCells_R(Self: TJvPicClip; var T: TBitmap; const t1: Cardinal; const t2: Cardinal);
begin T := Self.Cells[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPicClip(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPicClip) do begin
    RegisterConstructor(@TJvPicClip.Create, 'Create');
    RegisterMethod(@TJvPicClip.Destroy, 'Free');
    RegisterMethod(@TJvPicClip.Assign, 'Assign');
    RegisterMethod(@TJvPicClip.GetIndex, 'GetIndex');
    RegisterMethod(@TJvPicClip.Draw, 'Draw');
    RegisterMethod(@TJvPicClip.DrawCenter, 'DrawCenter');
    RegisterMethod(@TJvPicClip.LoadBitmapRes, 'LoadBitmapRes');
    RegisterPropertyHelper(@TJvPicClipCells_R,nil,'Cells');
    RegisterPropertyHelper(@TJvPicClipGraphicCell_R,nil,'GraphicCell');
    RegisterPropertyHelper(@TJvPicClipIsEmpty_R,nil,'IsEmpty');
    RegisterPropertyHelper(@TJvPicClipCount_R,nil,'Count');
    RegisterPropertyHelper(@TJvPicClipCols_R,@TJvPicClipCols_W,'Cols');
    RegisterPropertyHelper(@TJvPicClipHeight_R,@TJvPicClipHeight_W,'Height');
    RegisterPropertyHelper(@TJvPicClipMasked_R,@TJvPicClipMasked_W,'Masked');
    RegisterPropertyHelper(@TJvPicClipRows_R,@TJvPicClipRows_W,'Rows');
    RegisterPropertyHelper(@TJvPicClipPicture_R,@TJvPicClipPicture_W,'Picture');
    RegisterPropertyHelper(@TJvPicClipMaskColor_R,@TJvPicClipMaskColor_W,'MaskColor');
    RegisterPropertyHelper(@TJvPicClipWidth_R,@TJvPicClipWidth_W,'Width');
    RegisterPropertyHelper(@TJvPicClipOnChange_R,@TJvPicClipOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPicClip(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvPicClip(CL);
end;

 
 
{ TPSImport_JvPicClip }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPicClip.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvPicClip(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPicClip.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvPicClip(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
