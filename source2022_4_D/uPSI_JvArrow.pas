unit uPSI_JvArrow;
{
   paint it the way
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
  TPSImport_JvArrow = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvArrow(CL: TPSPascalCompiler);
procedure SIRegister_TCustomArrow(CL: TPSPascalCompiler);
procedure SIRegister_JvArrow(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvArrow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomArrow(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvArrow(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Windows
  ,Controls
  ,Graphics
  ,JvComponent
  ,JvArrow
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvArrow]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvArrow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomArrow', 'TJvArrow') do
  with CL.AddClassN(CL.FindClass('TCustomArrow'),'TJvArrow') do begin
    RegisterPublishedProperties;
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    //RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomArrow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TCustomArrow') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TCustomArrow') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterProperty('ArrowSize', 'Integer', iptrw);
    RegisterProperty('ArrowWidth', 'Integer', iptrw);
    RegisterProperty('Brush', 'TBrush', iptrw);
    RegisterProperty('Pen', 'TPen', iptrw);
    RegisterProperty('Shape', 'TArrowType', iptrw);
    RegisterMethod('Procedure StyleChanged( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvArrow(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TArrowType', '( atDownRight, atDownLeft, atUpRight, atUpLeft, at'
   +'RightDown, atLeftDown, atRightUp, atLeftUp, atTopLeftBottomRight, atBottom'
   +'RightTopLeft, atTopRightBottomLeft, atBottomLeftTopRight )');
  SIRegister_TCustomArrow(CL);
  SIRegister_TJvArrow(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomArrowShape_W(Self: TCustomArrow; const T: TArrowType);
begin Self.Shape := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowShape_R(Self: TCustomArrow; var T: TArrowType);
begin T := Self.Shape; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowPen_W(Self: TCustomArrow; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowPen_R(Self: TCustomArrow; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowBrush_W(Self: TCustomArrow; const T: TBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowBrush_R(Self: TCustomArrow; var T: TBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowArrowWidth_W(Self: TCustomArrow; const T: Integer);
begin Self.ArrowWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowArrowWidth_R(Self: TCustomArrow; var T: Integer);
begin T := Self.ArrowWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowArrowSize_W(Self: TCustomArrow; const T: Integer);
begin Self.ArrowSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomArrowArrowSize_R(Self: TCustomArrow; var T: Integer);
begin T := Self.ArrowSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvArrow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvArrow) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomArrow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomArrow) do begin
    RegisterConstructor(@TCustomArrow.Create, 'Create');
      RegisterMethod(@TCustomArrow.Destroy, 'Free');
      RegisterPropertyHelper(@TCustomArrowArrowSize_R,@TCustomArrowArrowSize_W,'ArrowSize');
    RegisterPropertyHelper(@TCustomArrowArrowWidth_R,@TCustomArrowArrowWidth_W,'ArrowWidth');
    RegisterPropertyHelper(@TCustomArrowBrush_R,@TCustomArrowBrush_W,'Brush');
    RegisterPropertyHelper(@TCustomArrowPen_R,@TCustomArrowPen_W,'Pen');
    RegisterPropertyHelper(@TCustomArrowShape_R,@TCustomArrowShape_W,'Shape');
    RegisterMethod(@TCustomArrow.StyleChanged, 'StyleChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvArrow(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomArrow(CL);
  RIRegister_TJvArrow(CL);
end;

 
 
{ TPSImport_JvArrow }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvArrow.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvArrow(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvArrow.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvArrow(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
