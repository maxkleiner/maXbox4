unit uPSI_cyBaseMeasure;
{
   for gauging
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
  TPSImport_cyBaseMeasure = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyBaseMeasure(CL: TPSPascalCompiler);
procedure SIRegister_TGraduations(CL: TPSPascalCompiler);
procedure SIRegister_TGraduation(CL: TPSPascalCompiler);
procedure SIRegister_TLevels(CL: TPSPascalCompiler);
procedure SIRegister_TLevel(CL: TPSPascalCompiler);
procedure SIRegister_TBookmarks(CL: TPSPascalCompiler);
procedure SIRegister_TBookmarkItem(CL: TPSPascalCompiler);
procedure SIRegister_cyBaseMeasure(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyBaseMeasure(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGraduations(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGraduation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLevels(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLevel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBookmarks(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBookmarkItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyBaseMeasure(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cyGraphics
  ,Windows
  ,Graphics
  ,Controls
  ,cyBaseMeasure
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyBaseMeasure]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyBaseMeasure(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TcyBaseMeasure') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TcyBaseMeasure') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
     RegisterPublishedProperties;
    RegisterProperty('ShowHint', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGraduations(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TGraduations') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TGraduations') do begin
    RegisterMethod('Constructor Create( aControl : TControl; GraduationClass : TGraduationClass)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Add : TGraduation');
    RegisterProperty('Items', 'TGraduation Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGraduation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TGraduation') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TGraduation') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('Size', 'Word', iptrw);
    RegisterProperty('Pen', 'TPen', iptrw);
    RegisterProperty('ShowMarks', 'boolean', iptrw);
    RegisterProperty('ShowValues', 'boolean', iptrw);
    RegisterProperty('Spacing', 'integer', iptrw);
    RegisterProperty('Step', 'Word', iptrw);
    RegisterProperty('Style', 'TGraduationStyle', iptrw);
    RegisterProperty('ValueFormat', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLevels(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TLevels') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TLevels') do
  begin
    RegisterMethod('Constructor Create( aControl : TControl; LevelClass : TLevelClass)');
    RegisterMethod('Function Add : TLevel');
    RegisterProperty('Items', 'TLevel Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLevel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TLevel') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TLevel') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterProperty('FromColor', 'TColor', iptrw);
    RegisterProperty('FromValue', 'Double', iptrw);
    RegisterProperty('ToColor', 'TColor', iptrw);
    RegisterProperty('ToValue', 'Double', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBookmarks(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TBookmarks') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TBookmarks') do
  begin
    RegisterMethod('Constructor Create( aControl : TControl; BookmarkItemClass : TBookmarkItemClass)');
    RegisterMethod('Function Add : TBookmarkItem');
    RegisterProperty('Items', 'TBookmarkItem Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBookmarkItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TBookmarkItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TBookmarkItem') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyBaseMeasure(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBookmarkStyle', '( bsNone, bsArrow, bsTriangle, bsLine, bsRectangle, bsCirle, bsPicture )');
  SIRegister_TBookmarkItem(CL);
  //CL.AddTypeS('TBookmarkItemClass', 'class of TBookmarkItem');
  SIRegister_TBookmarks(CL);
  SIRegister_TLevel(CL);
  //CL.AddTypeS('TLevelClass', 'class of TLevel');
  SIRegister_TLevels(CL);
  CL.AddTypeS('TGraduationStyle', '( gsGuideLine, gsMarks )');
  SIRegister_TGraduation(CL);
  //CL.AddTypeS('TGraduationClass', 'class of tGraduation');
  SIRegister_TGraduations(CL);
  SIRegister_TcyBaseMeasure(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGraduationsItems_R(Self: TGraduations; var T: TGraduation; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationValueFormat_W(Self: TGraduation; const T: String);
begin Self.ValueFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationValueFormat_R(Self: TGraduation; var T: String);
begin T := Self.ValueFormat; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationStyle_W(Self: TGraduation; const T: TGraduationStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationStyle_R(Self: TGraduation; var T: TGraduationStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationStep_W(Self: TGraduation; const T: Word);
begin Self.Step := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationStep_R(Self: TGraduation; var T: Word);
begin T := Self.Step; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationSpacing_W(Self: TGraduation; const T: integer);
begin Self.Spacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationSpacing_R(Self: TGraduation; var T: integer);
begin T := Self.Spacing; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationShowValues_W(Self: TGraduation; const T: boolean);
begin Self.ShowValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationShowValues_R(Self: TGraduation; var T: boolean);
begin T := Self.ShowValues; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationShowMarks_W(Self: TGraduation; const T: boolean);
begin Self.ShowMarks := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationShowMarks_R(Self: TGraduation; var T: boolean);
begin T := Self.ShowMarks; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationPen_W(Self: TGraduation; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationPen_R(Self: TGraduation; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationSize_W(Self: TGraduation; const T: Word);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationSize_R(Self: TGraduation; var T: Word);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationFont_W(Self: TGraduation; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraduationFont_R(Self: TGraduation; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TLevelsItems_R(Self: TLevels; var T: TLevel; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLevelVisible_W(Self: TLevel; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TLevelVisible_R(Self: TLevel; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TLevelToValue_W(Self: TLevel; const T: Double);
begin Self.ToValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TLevelToValue_R(Self: TLevel; var T: Double);
begin T := Self.ToValue; end;

(*----------------------------------------------------------------------------*)
procedure TLevelToColor_W(Self: TLevel; const T: TColor);
begin Self.ToColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TLevelToColor_R(Self: TLevel; var T: TColor);
begin T := Self.ToColor; end;

(*----------------------------------------------------------------------------*)
procedure TLevelFromValue_W(Self: TLevel; const T: Double);
begin Self.FromValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TLevelFromValue_R(Self: TLevel; var T: Double);
begin T := Self.FromValue; end;

(*----------------------------------------------------------------------------*)
procedure TLevelFromColor_W(Self: TLevel; const T: TColor);
begin Self.FromColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TLevelFromColor_R(Self: TLevel; var T: TColor);
begin T := Self.FromColor; end;

(*----------------------------------------------------------------------------*)
procedure TBookmarksItems_R(Self: TBookmarks; var T: TBookmarkItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyBaseMeasure(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyBaseMeasure) do begin
    RegisterConstructor(@TcyBaseMeasure.Create, 'Create');
     RegisterMethod(@TcyBaseMeasure.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGraduations(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGraduations) do begin
    RegisterConstructor(@TGraduations.Create, 'Create');
       RegisterMethod(@TGraduations.Destroy, 'Free');
      RegisterMethod(@TGraduations.Add, 'Add');
    RegisterPropertyHelper(@TGraduationsItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGraduation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGraduation) do
  begin
    RegisterConstructor(@TGraduation.Create, 'Create');
    RegisterPropertyHelper(@TGraduationFont_R,@TGraduationFont_W,'Font');
    RegisterPropertyHelper(@TGraduationSize_R,@TGraduationSize_W,'Size');
    RegisterPropertyHelper(@TGraduationPen_R,@TGraduationPen_W,'Pen');
    RegisterPropertyHelper(@TGraduationShowMarks_R,@TGraduationShowMarks_W,'ShowMarks');
    RegisterPropertyHelper(@TGraduationShowValues_R,@TGraduationShowValues_W,'ShowValues');
    RegisterPropertyHelper(@TGraduationSpacing_R,@TGraduationSpacing_W,'Spacing');
    RegisterPropertyHelper(@TGraduationStep_R,@TGraduationStep_W,'Step');
    RegisterPropertyHelper(@TGraduationStyle_R,@TGraduationStyle_W,'Style');
    RegisterPropertyHelper(@TGraduationValueFormat_R,@TGraduationValueFormat_W,'ValueFormat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLevels(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLevels) do
  begin
    RegisterConstructor(@TLevels.Create, 'Create');
    RegisterMethod(@TLevels.Add, 'Add');
    RegisterPropertyHelper(@TLevelsItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLevel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLevel) do
  begin
    RegisterConstructor(@TLevel.Create, 'Create');
    RegisterPropertyHelper(@TLevelFromColor_R,@TLevelFromColor_W,'FromColor');
    RegisterPropertyHelper(@TLevelFromValue_R,@TLevelFromValue_W,'FromValue');
    RegisterPropertyHelper(@TLevelToColor_R,@TLevelToColor_W,'ToColor');
    RegisterPropertyHelper(@TLevelToValue_R,@TLevelToValue_W,'ToValue');
    RegisterPropertyHelper(@TLevelVisible_R,@TLevelVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBookmarks(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBookmarks) do
  begin
    RegisterConstructor(@TBookmarks.Create, 'Create');
    RegisterMethod(@TBookmarks.Add, 'Add');
    RegisterPropertyHelper(@TBookmarksItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBookmarkItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBookmarkItem) do begin
    RegisterConstructor(@TBookmarkItem.Create, 'Create');
     RegisterMethod(@TBookmarkItem.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyBaseMeasure(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBookmarkItem(CL);
  RIRegister_TBookmarks(CL);
  RIRegister_TLevel(CL);
  RIRegister_TLevels(CL);
  RIRegister_TGraduation(CL);
  RIRegister_TGraduations(CL);
  RIRegister_TcyBaseMeasure(CL);
end;

 
 
{ TPSImport_cyBaseMeasure }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseMeasure.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyBaseMeasure(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseMeasure.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyBaseMeasure(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
