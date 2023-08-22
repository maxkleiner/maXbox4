unit uPSI_JvgCrossTable;
{
  cross for the boss   - set dataset is missing
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
  TPSImport_JvgCrossTable = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvgPrintCrossTable(CL: TPSPascalCompiler);
procedure SIRegister_TJvgPrintCrossTableIndents(CL: TPSPascalCompiler);
procedure SIRegister_TJvgPrintCrossTableFonts(CL: TPSPascalCompiler);
procedure SIRegister_TJvgPrintCrossTableColors(CL: TPSPascalCompiler);
procedure SIRegister_JvgCrossTable(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvgPrintCrossTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgPrintCrossTableIndents(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgPrintCrossTableFonts(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgPrintCrossTableColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvgCrossTable(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Messages
  ,Controls
  ,Graphics
  ,Buttons
  ,Dialogs
  ,StdCtrls
  ,ExtCtrls
  ,Forms
  ,DB
  ,DBCtrls
  ,Menus
  ,DBTables
  ,Printers
  ,JvComponentBase
  ,JvgTypes
  ,JvgCommClasses
  ,JvgUtils_max
  ,JvgCrossTable
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgCrossTable]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgPrintCrossTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvgPrintCrossTable') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvgPrintCrossTable') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Print');
    RegisterMethod('Procedure PreviewTo( Canvas : TCanvas; PageWidth, PageHeight : Integer)');
    RegisterProperty('DataSet', 'TDataSet', iptrw);
    RegisterProperty('ColumnFieldName', 'string', iptrw);
    RegisterProperty('RowFieldName', 'string', iptrw);
    RegisterProperty('ValueFieldName', 'string', iptrw);
    RegisterProperty('Options', 'TPCTOptions', iptrw);
    RegisterProperty('PageWidth', 'Integer', iptrw);
    RegisterProperty('PageHeight', 'Integer', iptrw);
    RegisterProperty('ColWidthInSantim', 'Single', iptrw);
    RegisterProperty('RowHeightInSantim', 'Single', iptrw);
    RegisterProperty('IndentsInSantim', 'TJvgPrintCrossTableIndents', iptrw);
    RegisterProperty('CaptColWidthInSantim', 'Single', iptrw);
    RegisterProperty('CaptRowHeightInSantim', 'Single', iptrw);
    RegisterProperty('Fonts', 'TJvgPrintCrossTableFonts', iptrw);
    RegisterProperty('Colors', 'TJvgPrintCrossTableColors', iptrw);
    RegisterProperty('OnPrintQuery', 'TPrintQueryEvent', iptrw);
    RegisterProperty('OnPrintNewPage', 'TPrintNewPageEvent', iptrw);
    RegisterProperty('OnPrintTableElement', 'TPrintTableElement', iptrw);
    RegisterProperty('OnCalcResult', 'TCalcResultEvent', iptrw);
    RegisterProperty('OnDuplicateCellValue', 'TDuplicateCellValueEvent', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('TitleAlignment', 'TAlignment', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgPrintCrossTableIndents(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgPrintCrossTableIndents') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgPrintCrossTableIndents') do
  begin
    RegisterProperty('_Left', 'Single', iptrw);
    RegisterProperty('_Top', 'Single', iptrw);
    RegisterProperty('_Right', 'Single', iptrw);
    RegisterProperty('_Bottom', 'Single', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgPrintCrossTableFonts(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgPrintCrossTableFonts') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgPrintCrossTableFonts') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Titles', 'TFont', iptrw);
    RegisterProperty('ColCaptions', 'TFont', iptrw);
    RegisterProperty('RowCaptions', 'TFont', iptrw);
    RegisterProperty('Cells', 'TFont', iptrw);
    RegisterProperty('Results', 'TFont', iptrw);
    RegisterProperty('IntermediateResults', 'TFont', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgPrintCrossTableColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvgPrintCrossTableColors') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvgPrintCrossTableColors') do
  begin
    RegisterProperty('Captions', 'TColor', iptrw);
    RegisterProperty('Cells', 'TColor', iptrw);
    RegisterProperty('Results', 'TColor', iptrw);
    RegisterProperty('IntermediateResults', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgCrossTable(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('JvDefaultCaptionsColor','LongWord').SetUInt( TColor ( $00FFF2D2 ));
 CL.AddConstantN('JvDefaultResultsColor','LongWord').SetUInt( TColor ( $00C5DEC5 ));
 CL.AddConstantN('JvDefaultIntermediateResultsColor','LongWord').SetUInt( TColor ( $00ABCCF1 ));
  CL.AddTypeS('TglPrintingStatus', '( fpsContinue, fpsResume, fpsAbort )');
  CL.AddTypeS('TPrintQueryEvent', 'Procedure ( Sender : TObject; ColPageCount, '
   +'RowPageCount : Cardinal; var CanPrint : Boolean)');
  CL.AddTypeS('TPrintNewPageEvent', 'Procedure ( Sender : TObject; ColPageNo, R'
   +'owPageNo : Cardinal; var PrintingStatus : TglPrintingStatus)');
  CL.AddTypeS('TDrawCellEvent2', 'Procedure ( Sender : TObject; ColNo, RowNo : C'
   +'ardinal; Value : string; var CanPrint : Boolean)');
  CL.AddTypeS('TCalcResultEvent', 'Procedure ( Sender : TObject; ColNo, RowNo :'
   +' Cardinal; CellValue : string; IntermediateColResult, IntermediateRowResul'
   +'t, ColResult, RowResult : Single)');
  CL.AddTypeS('TDuplicateCellValueEvent', 'Procedure ( Sender : TObject; ColNo,'
   +' RowNo : Cardinal; Value : string; var UseDuplicateValue : Boolean)');
  CL.AddTypeS('TPCTOptions', ' ( fcoIntermediateColResults, fcoIntermedia'
   +'teRowResults, fcoColResults, fcoRowResults, fcoIntermediateColCaptions, fc'
   +'oIntermediateRowCaptions, fcoIntermediateLeftIndent, fcoIntermediateTopInd'
   +'ent, fcoIntermediateRightIndent, fcoIntermediateBottomIndent, fcoShowPageN'
   +'umbers, fcoVertColCaptionsFont )');
  CL.AddTypeS('TPCTableElement', '( teTitle, teCell, teColCapt, teRowCapt, teCo'
   +'lIRes, teRowIRes, teColRes, teRowRes )');
  CL.AddTypeS('TPrintTableElement', 'Procedure ( Sender : TObject; var Text : s'
   +'tring; ColNo, RowNo : Integer; TableElement : TPCTableElement; var Font : '
   +'TFont; var Color : TColor; var AlignFlags : Word; var CanPrint : Boolean)');

  SIRegister_TJvgPrintCrossTableColors(CL);
  SIRegister_TJvgPrintCrossTableFonts(CL);
  SIRegister_TJvgPrintCrossTableIndents(CL);
  SIRegister_TJvgPrintCrossTable(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableTitleAlignment_W(Self: TJvgPrintCrossTable; const T: TAlignment);
begin Self.TitleAlignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableTitleAlignment_R(Self: TJvgPrintCrossTable; var T: TAlignment);
begin T := Self.TitleAlignment; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableTitle_W(Self: TJvgPrintCrossTable; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableTitle_R(Self: TJvgPrintCrossTable; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnDuplicateCellValue_W(Self: TJvgPrintCrossTable; const T: TDuplicateCellValueEvent);
begin Self.OnDuplicateCellValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnDuplicateCellValue_R(Self: TJvgPrintCrossTable; var T: TDuplicateCellValueEvent);
begin T := Self.OnDuplicateCellValue; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnCalcResult_W(Self: TJvgPrintCrossTable; const T: TCalcResultEvent);
begin Self.OnCalcResult := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnCalcResult_R(Self: TJvgPrintCrossTable; var T: TCalcResultEvent);
begin T := Self.OnCalcResult; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnPrintTableElement_W(Self: TJvgPrintCrossTable; const T: TPrintTableElement);
begin Self.OnPrintTableElement := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnPrintTableElement_R(Self: TJvgPrintCrossTable; var T: TPrintTableElement);
begin T := Self.OnPrintTableElement; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnPrintNewPage_W(Self: TJvgPrintCrossTable; const T: TPrintNewPageEvent);
begin Self.OnPrintNewPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnPrintNewPage_R(Self: TJvgPrintCrossTable; var T: TPrintNewPageEvent);
begin T := Self.OnPrintNewPage; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnPrintQuery_W(Self: TJvgPrintCrossTable; const T: TPrintQueryEvent);
begin Self.OnPrintQuery := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOnPrintQuery_R(Self: TJvgPrintCrossTable; var T: TPrintQueryEvent);
begin T := Self.OnPrintQuery; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColors_W(Self: TJvgPrintCrossTable; const T: TJvgPrintCrossTableColors);
begin Self.Colors := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColors_R(Self: TJvgPrintCrossTable; var T: TJvgPrintCrossTableColors);
begin T := Self.Colors; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFonts_W(Self: TJvgPrintCrossTable; const T: TJvgPrintCrossTableFonts);
begin Self.Fonts := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFonts_R(Self: TJvgPrintCrossTable; var T: TJvgPrintCrossTableFonts);
begin T := Self.Fonts; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableCaptRowHeightInSantim_W(Self: TJvgPrintCrossTable; const T: Single);
begin Self.CaptRowHeightInSantim := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableCaptRowHeightInSantim_R(Self: TJvgPrintCrossTable; var T: Single);
begin T := Self.CaptRowHeightInSantim; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableCaptColWidthInSantim_W(Self: TJvgPrintCrossTable; const T: Single);
begin Self.CaptColWidthInSantim := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableCaptColWidthInSantim_R(Self: TJvgPrintCrossTable; var T: Single);
begin T := Self.CaptColWidthInSantim; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndentsInSantim_W(Self: TJvgPrintCrossTable; const T: TJvgPrintCrossTableIndents);
begin Self.IndentsInSantim := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndentsInSantim_R(Self: TJvgPrintCrossTable; var T: TJvgPrintCrossTableIndents);
begin T := Self.IndentsInSantim; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableRowHeightInSantim_W(Self: TJvgPrintCrossTable; const T: Single);
begin Self.RowHeightInSantim := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableRowHeightInSantim_R(Self: TJvgPrintCrossTable; var T: Single);
begin T := Self.RowHeightInSantim; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColWidthInSantim_W(Self: TJvgPrintCrossTable; const T: Single);
begin Self.ColWidthInSantim := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColWidthInSantim_R(Self: TJvgPrintCrossTable; var T: Single);
begin T := Self.ColWidthInSantim; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTablePageHeight_W(Self: TJvgPrintCrossTable; const T: Integer);
begin Self.PageHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTablePageHeight_R(Self: TJvgPrintCrossTable; var T: Integer);
begin T := Self.PageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTablePageWidth_W(Self: TJvgPrintCrossTable; const T: Integer);
begin Self.PageWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTablePageWidth_R(Self: TJvgPrintCrossTable; var T: Integer);
begin T := Self.PageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOptions_W(Self: TJvgPrintCrossTable; const T: TPCTOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableOptions_R(Self: TJvgPrintCrossTable; var T: TPCTOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableValueFieldName_W(Self: TJvgPrintCrossTable; const T: string);
begin Self.ValueFieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableValueFieldName_R(Self: TJvgPrintCrossTable; var T: string);
begin T := Self.ValueFieldName; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableRowFieldName_W(Self: TJvgPrintCrossTable; const T: string);
begin Self.RowFieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableRowFieldName_R(Self: TJvgPrintCrossTable; var T: string);
begin T := Self.RowFieldName; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColumnFieldName_W(Self: TJvgPrintCrossTable; const T: string);
begin Self.ColumnFieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColumnFieldName_R(Self: TJvgPrintCrossTable; var T: string);
begin T := Self.ColumnFieldName; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableDataSet_W(Self: TJvgPrintCrossTable; const T: TDataSet);
begin Self.DataSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableDataSet_R(Self: TJvgPrintCrossTable; var T: TDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Bottom_W(Self: TJvgPrintCrossTableIndents; const T: Single);
begin Self._Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Bottom_R(Self: TJvgPrintCrossTableIndents; var T: Single);
begin T := Self._Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Right_W(Self: TJvgPrintCrossTableIndents; const T: Single);
begin Self._Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Right_R(Self: TJvgPrintCrossTableIndents; var T: Single);
begin T := Self._Right; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Top_W(Self: TJvgPrintCrossTableIndents; const T: Single);
begin Self._Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Top_R(Self: TJvgPrintCrossTableIndents; var T: Single);
begin T := Self._Top; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Left_W(Self: TJvgPrintCrossTableIndents; const T: Single);
begin Self._Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableIndents_Left_R(Self: TJvgPrintCrossTableIndents; var T: Single);
begin T := Self._Left; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsIntermediateResults_W(Self: TJvgPrintCrossTableFonts; const T: TFont);
begin Self.IntermediateResults := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsIntermediateResults_R(Self: TJvgPrintCrossTableFonts; var T: TFont);
begin T := Self.IntermediateResults; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsResults_W(Self: TJvgPrintCrossTableFonts; const T: TFont);
begin Self.Results := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsResults_R(Self: TJvgPrintCrossTableFonts; var T: TFont);
begin T := Self.Results; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsCells_W(Self: TJvgPrintCrossTableFonts; const T: TFont);
begin Self.Cells := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsCells_R(Self: TJvgPrintCrossTableFonts; var T: TFont);
begin T := Self.Cells; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsRowCaptions_W(Self: TJvgPrintCrossTableFonts; const T: TFont);
begin Self.RowCaptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsRowCaptions_R(Self: TJvgPrintCrossTableFonts; var T: TFont);
begin T := Self.RowCaptions; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsColCaptions_W(Self: TJvgPrintCrossTableFonts; const T: TFont);
begin Self.ColCaptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsColCaptions_R(Self: TJvgPrintCrossTableFonts; var T: TFont);
begin T := Self.ColCaptions; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsTitles_W(Self: TJvgPrintCrossTableFonts; const T: TFont);
begin Self.Titles := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableFontsTitles_R(Self: TJvgPrintCrossTableFonts; var T: TFont);
begin T := Self.Titles; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsIntermediateResults_W(Self: TJvgPrintCrossTableColors; const T: TColor);
begin Self.IntermediateResults := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsIntermediateResults_R(Self: TJvgPrintCrossTableColors; var T: TColor);
begin T := Self.IntermediateResults; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsResults_W(Self: TJvgPrintCrossTableColors; const T: TColor);
begin Self.Results := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsResults_R(Self: TJvgPrintCrossTableColors; var T: TColor);
begin T := Self.Results; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsCells_W(Self: TJvgPrintCrossTableColors; const T: TColor);
begin Self.Cells := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsCells_R(Self: TJvgPrintCrossTableColors; var T: TColor);
begin T := Self.Cells; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsCaptions_W(Self: TJvgPrintCrossTableColors; const T: TColor);
begin Self.Captions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgPrintCrossTableColorsCaptions_R(Self: TJvgPrintCrossTableColors; var T: TColor);
begin T := Self.Captions; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgPrintCrossTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgPrintCrossTable) do
  begin
    RegisterConstructor(@TJvgPrintCrossTable.Create, 'Create');
      RegisterMethod(@TJvgPrintCrossTable.Destroy, 'Free');
       RegisterMethod(@TJvgPrintCrossTable.Print, 'Print');
    RegisterMethod(@TJvgPrintCrossTable.PreviewTo, 'PreviewTo');
    RegisterPropertyHelper(@TJvgPrintCrossTableDataSet_R,@TJvgPrintCrossTableDataSet_W,'DataSet');
    RegisterPropertyHelper(@TJvgPrintCrossTableColumnFieldName_R,@TJvgPrintCrossTableColumnFieldName_W,'ColumnFieldName');
    RegisterPropertyHelper(@TJvgPrintCrossTableRowFieldName_R,@TJvgPrintCrossTableRowFieldName_W,'RowFieldName');
    RegisterPropertyHelper(@TJvgPrintCrossTableValueFieldName_R,@TJvgPrintCrossTableValueFieldName_W,'ValueFieldName');
    RegisterPropertyHelper(@TJvgPrintCrossTableOptions_R,@TJvgPrintCrossTableOptions_W,'Options');
    RegisterPropertyHelper(@TJvgPrintCrossTablePageWidth_R,@TJvgPrintCrossTablePageWidth_W,'PageWidth');
    RegisterPropertyHelper(@TJvgPrintCrossTablePageHeight_R,@TJvgPrintCrossTablePageHeight_W,'PageHeight');
    RegisterPropertyHelper(@TJvgPrintCrossTableColWidthInSantim_R,@TJvgPrintCrossTableColWidthInSantim_W,'ColWidthInSantim');
    RegisterPropertyHelper(@TJvgPrintCrossTableRowHeightInSantim_R,@TJvgPrintCrossTableRowHeightInSantim_W,'RowHeightInSantim');
    RegisterPropertyHelper(@TJvgPrintCrossTableIndentsInSantim_R,@TJvgPrintCrossTableIndentsInSantim_W,'IndentsInSantim');
    RegisterPropertyHelper(@TJvgPrintCrossTableCaptColWidthInSantim_R,@TJvgPrintCrossTableCaptColWidthInSantim_W,'CaptColWidthInSantim');
    RegisterPropertyHelper(@TJvgPrintCrossTableCaptRowHeightInSantim_R,@TJvgPrintCrossTableCaptRowHeightInSantim_W,'CaptRowHeightInSantim');
    RegisterPropertyHelper(@TJvgPrintCrossTableFonts_R,@TJvgPrintCrossTableFonts_W,'Fonts');
    RegisterPropertyHelper(@TJvgPrintCrossTableColors_R,@TJvgPrintCrossTableColors_W,'Colors');
    RegisterPropertyHelper(@TJvgPrintCrossTableOnPrintQuery_R,@TJvgPrintCrossTableOnPrintQuery_W,'OnPrintQuery');
    RegisterPropertyHelper(@TJvgPrintCrossTableOnPrintNewPage_R,@TJvgPrintCrossTableOnPrintNewPage_W,'OnPrintNewPage');
    RegisterPropertyHelper(@TJvgPrintCrossTableOnPrintTableElement_R,@TJvgPrintCrossTableOnPrintTableElement_W,'OnPrintTableElement');
    RegisterPropertyHelper(@TJvgPrintCrossTableOnCalcResult_R,@TJvgPrintCrossTableOnCalcResult_W,'OnCalcResult');
    RegisterPropertyHelper(@TJvgPrintCrossTableOnDuplicateCellValue_R,@TJvgPrintCrossTableOnDuplicateCellValue_W,'OnDuplicateCellValue');
    RegisterPropertyHelper(@TJvgPrintCrossTableTitle_R,@TJvgPrintCrossTableTitle_W,'Title');
    RegisterPropertyHelper(@TJvgPrintCrossTableTitleAlignment_R,@TJvgPrintCrossTableTitleAlignment_W,'TitleAlignment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgPrintCrossTableIndents(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgPrintCrossTableIndents) do
  begin
    RegisterPropertyHelper(@TJvgPrintCrossTableIndents_Left_R,@TJvgPrintCrossTableIndents_Left_W,'_Left');
    RegisterPropertyHelper(@TJvgPrintCrossTableIndents_Top_R,@TJvgPrintCrossTableIndents_Top_W,'_Top');
    RegisterPropertyHelper(@TJvgPrintCrossTableIndents_Right_R,@TJvgPrintCrossTableIndents_Right_W,'_Right');
    RegisterPropertyHelper(@TJvgPrintCrossTableIndents_Bottom_R,@TJvgPrintCrossTableIndents_Bottom_W,'_Bottom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgPrintCrossTableFonts(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgPrintCrossTableFonts) do
  begin
    RegisterConstructor(@TJvgPrintCrossTableFonts.Create, 'Create');
    RegisterPropertyHelper(@TJvgPrintCrossTableFontsTitles_R,@TJvgPrintCrossTableFontsTitles_W,'Titles');
    RegisterPropertyHelper(@TJvgPrintCrossTableFontsColCaptions_R,@TJvgPrintCrossTableFontsColCaptions_W,'ColCaptions');
    RegisterPropertyHelper(@TJvgPrintCrossTableFontsRowCaptions_R,@TJvgPrintCrossTableFontsRowCaptions_W,'RowCaptions');
    RegisterPropertyHelper(@TJvgPrintCrossTableFontsCells_R,@TJvgPrintCrossTableFontsCells_W,'Cells');
    RegisterPropertyHelper(@TJvgPrintCrossTableFontsResults_R,@TJvgPrintCrossTableFontsResults_W,'Results');
    RegisterPropertyHelper(@TJvgPrintCrossTableFontsIntermediateResults_R,@TJvgPrintCrossTableFontsIntermediateResults_W,'IntermediateResults');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgPrintCrossTableColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgPrintCrossTableColors) do
  begin
    RegisterPropertyHelper(@TJvgPrintCrossTableColorsCaptions_R,@TJvgPrintCrossTableColorsCaptions_W,'Captions');
    RegisterPropertyHelper(@TJvgPrintCrossTableColorsCells_R,@TJvgPrintCrossTableColorsCells_W,'Cells');
    RegisterPropertyHelper(@TJvgPrintCrossTableColorsResults_R,@TJvgPrintCrossTableColorsResults_W,'Results');
    RegisterPropertyHelper(@TJvgPrintCrossTableColorsIntermediateResults_R,@TJvgPrintCrossTableColorsIntermediateResults_W,'IntermediateResults');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgCrossTable(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvgPrintCrossTableColors(CL);
  RIRegister_TJvgPrintCrossTableFonts(CL);
  RIRegister_TJvgPrintCrossTableIndents(CL);
  RIRegister_TJvgPrintCrossTable(CL);
end;

 
 
{ TPSImport_JvgCrossTable }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgCrossTable.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgCrossTable(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgCrossTable.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgCrossTable(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
