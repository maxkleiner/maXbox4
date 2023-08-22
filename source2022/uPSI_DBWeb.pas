unit uPSI_DBWeb;
{
 V3.7.1
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
  TPSImport_DBWeb = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TDataSetTableProducer(CL: TPSPascalCompiler);
procedure SIRegister_TDSTableProducer(CL: TPSPascalCompiler);
procedure SIRegister_THTMLTableColumns(CL: TPSPascalCompiler);
procedure SIRegister_THTMLTableColumn(CL: TPSPascalCompiler);
procedure SIRegister_THTTPDataLink(CL: TPSPascalCompiler);
procedure SIRegister_TDSTableProducerEditor(CL: TPSPascalCompiler);
procedure SIRegister_DBWeb(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DBWeb_Routines(S: TPSExec);
procedure RIRegister_TDataSetTableProducer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDSTableProducer(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLTableColumns(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLTableColumn(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTTPDataLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDSTableProducerEditor(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBWeb(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   HTTPApp
  ,DB
  ,HTTPProd
  ,DBWeb
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBWeb]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataSetTableProducer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDSTableProducer', 'TDataSetTableProducer') do
  with CL.AddClassN(CL.FindClass('TDSTableProducer'),'TDataSetTableProducer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDSTableProducer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomContentProducer', 'TDSTableProducer') do
  with CL.AddClassN(CL.FindClass('TCustomContentProducer'),'TDSTableProducer') do begin
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('CaptionAlignment', 'THTMLCaptionAlignment', iptrw);
    RegisterProperty('Columns', 'THTMLTableColumns', iptrw);
    RegisterProperty('DataSet', 'TDataSet', iptrw);
    RegisterProperty('Editor', 'TDSTableProducerEditor', iptrw);
    RegisterProperty('Footer', 'TStrings', iptrw);
    RegisterProperty('Header', 'TStrings', iptrw);
    RegisterProperty('MaxRows', 'Integer', iptrw);
    RegisterProperty('RowAttributes', 'THTMLTableRowAttributes', iptrw);
    RegisterProperty('TableAttributes', 'THTMLTableAttributes', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLTableColumns(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'THTMLTableColumns') do
  with CL.AddClassN(CL.FindClass('TCollection'),'THTMLTableColumns') do begin
    RegisterMethod('Constructor Create( DSTableProducer : TDSTableProducer; ColumnClass : THTMLTableColumnClass)');
    RegisterMethod('Function Add : THTMLTableColumn');
    RegisterMethod('Procedure RestoreDefaults');
    RegisterMethod('Procedure RebuildColumns');
    RegisterProperty('State', 'THTMLColumnState', iptrw);
    RegisterProperty('DSTableProducer', 'TDSTableProducer', iptr);
    RegisterProperty('Items', 'THTMLTableColumn Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLTableColumn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'THTMLTableColumn') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'THTMLTableColumn') do begin
    RegisterMethod('Procedure RestoreDefaults');
    RegisterMethod('Procedure Update');
    RegisterProperty('Field', 'TField', iptrw);
    RegisterProperty('DSTableProducer', 'TDSTableProducer', iptr);
    RegisterProperty('Align', 'THTMLAlign', iptrw);
    RegisterProperty('BgColor', 'THTMLBgColor', iptrw);
    RegisterProperty('Custom', 'string', iptrw);
    RegisterProperty('FieldName', 'string', iptrw);
    RegisterProperty('Title', 'THTMLTableHeaderAttributes', iptrw);
    RegisterProperty('VAlign', 'THTMLVAlign', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPDataLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataLink', 'THTTPDataLink') do
  with CL.AddClassN(CL.FindClass('TDataLink'),'THTTPDataLink') do begin
    RegisterMethod('Constructor Create( DSTableProducer : TDSTableProducer)');
    RegisterMethod('Function AddMapping( const FieldName : string) : Boolean');
    RegisterMethod('Procedure ClearMapping');
    RegisterMethod('Procedure Modified');
    RegisterMethod('Procedure Reset');
    RegisterProperty('DefaultFields', 'Boolean', iptr);
    RegisterProperty('FieldCount', 'Integer', iptr);
    RegisterProperty('Fields', 'TField Integer', iptr);
    RegisterProperty('SparseMap', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDSTableProducerEditor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDSTableProducerEditor') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDSTableProducerEditor') do begin
    RegisterMethod('Constructor Create( DSTableProducer : TDSTableProducer)');
    RegisterMethod('Procedure Changed');
    RegisterMethod('Procedure PostChange');
    RegisterProperty('DSTableProducer', 'TDSTableProducer', iptr);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBWeb(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDSTableProducer');
  SIRegister_TDSTableProducerEditor(CL);
  SIRegister_THTTPDataLink(CL);
  SIRegister_THTMLTableColumn(CL);
  //CL.AddTypeS('THTMLTableColumnClass', 'class of THTMLTableColumn');
  CL.AddTypeS('THTMLColumnState', '( csDefault, csCustom )');
  SIRegister_THTMLTableColumns(CL);
  CL.AddTypeS('THTMLCaptionAlignment', '( caDefault, caTop, caBottom )');
  CL.AddTypeS('TCreateContentEvent', 'Procedure ( Sender : TObject; var Continu'
   +'e : Boolean)');
  CL.AddTypeS('THTMLGetTableCaptionEvent', 'Procedure ( Sender : TObject; var C'
   +'aption : string; var Alignment : THTMLCaptionAlignment)');
 // CL.AddTypeS('THTMLFormatCellEvent', 'Procedure ( Sender : TObject; CellRow, C'
  // +'ellColumn : Integer; var BgColor : THTMLBgColor; var Align : THTMLAlign; v'
   //+'ar VAlign : THTMLVAlign; var CustomAttrs, CellData : string)');
  CL.AddTypeS('THTMLDataSetEmpty', 'Procedure ( Sender : TObject; var Continue '
   +': Boolean)');
  SIRegister_TDSTableProducer(CL);
  SIRegister_TDataSetTableProducer(CL);
 CL.AddDelphiFunction('Function HtmlTable( DataSet : TDataSet; DataSetHandler : TDSTableProducer; MaxRows : Integer) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDSTableProducerTableAttributes_W(Self: TDSTableProducer; const T: THTMLTableAttributes);
begin Self.TableAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerTableAttributes_R(Self: TDSTableProducer; var T: THTMLTableAttributes);
begin T := Self.TableAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerRowAttributes_W(Self: TDSTableProducer; const T: THTMLTableRowAttributes);
begin Self.RowAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerRowAttributes_R(Self: TDSTableProducer; var T: THTMLTableRowAttributes);
begin T := Self.RowAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerMaxRows_W(Self: TDSTableProducer; const T: Integer);
begin Self.MaxRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerMaxRows_R(Self: TDSTableProducer; var T: Integer);
begin T := Self.MaxRows; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerHeader_W(Self: TDSTableProducer; const T: TStrings);
begin Self.Header := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerHeader_R(Self: TDSTableProducer; var T: TStrings);
begin T := Self.Header; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerFooter_W(Self: TDSTableProducer; const T: TStrings);
begin Self.Footer := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerFooter_R(Self: TDSTableProducer; var T: TStrings);
begin T := Self.Footer; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerEditor_W(Self: TDSTableProducer; const T: TDSTableProducerEditor);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerEditor_R(Self: TDSTableProducer; var T: TDSTableProducerEditor);
begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerDataSet_W(Self: TDSTableProducer; const T: TDataSet);
begin Self.DataSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerDataSet_R(Self: TDSTableProducer; var T: TDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerColumns_W(Self: TDSTableProducer; const T: THTMLTableColumns);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerColumns_R(Self: TDSTableProducer; var T: THTMLTableColumns);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerCaptionAlignment_W(Self: TDSTableProducer; const T: THTMLCaptionAlignment);
begin Self.CaptionAlignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerCaptionAlignment_R(Self: TDSTableProducer; var T: THTMLCaptionAlignment);
begin T := Self.CaptionAlignment; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerCaption_W(Self: TDSTableProducer; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerCaption_R(Self: TDSTableProducer; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnsItems_W(Self: THTMLTableColumns; const T: THTMLTableColumn; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnsItems_R(Self: THTMLTableColumns; var T: THTMLTableColumn; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnsDSTableProducer_R(Self: THTMLTableColumns; var T: TDSTableProducer);
begin T := Self.DSTableProducer; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnsState_W(Self: THTMLTableColumns; const T: THTMLColumnState);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnsState_R(Self: THTMLTableColumns; var T: THTMLColumnState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnVAlign_W(Self: THTMLTableColumn; const T: THTMLVAlign);
begin Self.VAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnVAlign_R(Self: THTMLTableColumn; var T: THTMLVAlign);
begin T := Self.VAlign; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnTitle_W(Self: THTMLTableColumn; const T: THTMLTableHeaderAttributes);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnTitle_R(Self: THTMLTableColumn; var T: THTMLTableHeaderAttributes);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnFieldName_W(Self: THTMLTableColumn; const T: string);
begin Self.FieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnFieldName_R(Self: THTMLTableColumn; var T: string);
begin T := Self.FieldName; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnCustom_W(Self: THTMLTableColumn; const T: string);
begin Self.Custom := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnCustom_R(Self: THTMLTableColumn; var T: string);
begin T := Self.Custom; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnBgColor_W(Self: THTMLTableColumn; const T: THTMLBgColor);
begin Self.BgColor := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnBgColor_R(Self: THTMLTableColumn; var T: THTMLBgColor);
begin T := Self.BgColor; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnAlign_W(Self: THTMLTableColumn; const T: THTMLAlign);
begin Self.Align := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnAlign_R(Self: THTMLTableColumn; var T: THTMLAlign);
begin T := Self.Align; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnDSTableProducer_R(Self: THTMLTableColumn; var T: TDSTableProducer);
begin T := Self.DSTableProducer; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnField_W(Self: THTMLTableColumn; const T: TField);
begin Self.Field := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableColumnField_R(Self: THTMLTableColumn; var T: TField);
begin T := Self.Field; end;

(*----------------------------------------------------------------------------*)
procedure THTTPDataLinkSparseMap_W(Self: THTTPDataLink; const T: Boolean);
begin Self.SparseMap := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPDataLinkSparseMap_R(Self: THTTPDataLink; var T: Boolean);
begin T := Self.SparseMap; end;

(*----------------------------------------------------------------------------*)
procedure THTTPDataLinkFields_R(Self: THTTPDataLink; var T: TField; const t1: Integer);
begin T := Self.Fields[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THTTPDataLinkFieldCount_R(Self: THTTPDataLink; var T: Integer);
begin T := Self.FieldCount; end;

(*----------------------------------------------------------------------------*)
procedure THTTPDataLinkDefaultFields_R(Self: THTTPDataLink; var T: Boolean);
begin T := Self.DefaultFields; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerEditorDataSource_W(Self: TDSTableProducerEditor; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerEditorDataSource_R(Self: TDSTableProducerEditor; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TDSTableProducerEditorDSTableProducer_R(Self: TDSTableProducerEditor; var T: TDSTableProducer);
begin T := Self.DSTableProducer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBWeb_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HtmlTable, 'HtmlTable', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataSetTableProducer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataSetTableProducer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDSTableProducer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDSTableProducer) do begin
    RegisterMethod(@TDSTableProducer.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TDSTableProducer.EndUpdate, 'EndUpdate');
    RegisterPropertyHelper(@TDSTableProducerCaption_R,@TDSTableProducerCaption_W,'Caption');
    RegisterPropertyHelper(@TDSTableProducerCaptionAlignment_R,@TDSTableProducerCaptionAlignment_W,'CaptionAlignment');
    RegisterPropertyHelper(@TDSTableProducerColumns_R,@TDSTableProducerColumns_W,'Columns');
    RegisterPropertyHelper(@TDSTableProducerDataSet_R,@TDSTableProducerDataSet_W,'DataSet');
    RegisterPropertyHelper(@TDSTableProducerEditor_R,@TDSTableProducerEditor_W,'Editor');
    RegisterPropertyHelper(@TDSTableProducerFooter_R,@TDSTableProducerFooter_W,'Footer');
    RegisterPropertyHelper(@TDSTableProducerHeader_R,@TDSTableProducerHeader_W,'Header');
    RegisterPropertyHelper(@TDSTableProducerMaxRows_R,@TDSTableProducerMaxRows_W,'MaxRows');
    RegisterPropertyHelper(@TDSTableProducerRowAttributes_R,@TDSTableProducerRowAttributes_W,'RowAttributes');
    RegisterPropertyHelper(@TDSTableProducerTableAttributes_R,@TDSTableProducerTableAttributes_W,'TableAttributes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLTableColumns(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLTableColumns) do begin
    RegisterConstructor(@THTMLTableColumns.Create, 'Create');
    RegisterMethod(@THTMLTableColumns.Add, 'Add');
    RegisterMethod(@THTMLTableColumns.RestoreDefaults, 'RestoreDefaults');
    RegisterMethod(@THTMLTableColumns.RebuildColumns, 'RebuildColumns');
    RegisterPropertyHelper(@THTMLTableColumnsState_R,@THTMLTableColumnsState_W,'State');
    RegisterPropertyHelper(@THTMLTableColumnsDSTableProducer_R,nil,'DSTableProducer');
    RegisterPropertyHelper(@THTMLTableColumnsItems_R,@THTMLTableColumnsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLTableColumn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLTableColumn) do begin
    RegisterMethod(@THTMLTableColumn.RestoreDefaults, 'RestoreDefaults');
    RegisterMethod(@THTMLTableColumn.Update, 'Update');
    RegisterPropertyHelper(@THTMLTableColumnField_R,@THTMLTableColumnField_W,'Field');
    RegisterPropertyHelper(@THTMLTableColumnDSTableProducer_R,nil,'DSTableProducer');
    RegisterPropertyHelper(@THTMLTableColumnAlign_R,@THTMLTableColumnAlign_W,'Align');
    RegisterPropertyHelper(@THTMLTableColumnBgColor_R,@THTMLTableColumnBgColor_W,'BgColor');
    RegisterPropertyHelper(@THTMLTableColumnCustom_R,@THTMLTableColumnCustom_W,'Custom');
    RegisterPropertyHelper(@THTMLTableColumnFieldName_R,@THTMLTableColumnFieldName_W,'FieldName');
    RegisterPropertyHelper(@THTMLTableColumnTitle_R,@THTMLTableColumnTitle_W,'Title');
    RegisterPropertyHelper(@THTMLTableColumnVAlign_R,@THTMLTableColumnVAlign_W,'VAlign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPDataLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPDataLink) do begin
    RegisterConstructor(@THTTPDataLink.Create, 'Create');
    RegisterMethod(@THTTPDataLink.AddMapping, 'AddMapping');
    RegisterMethod(@THTTPDataLink.ClearMapping, 'ClearMapping');
    RegisterMethod(@THTTPDataLink.Modified, 'Modified');
    RegisterMethod(@THTTPDataLink.Reset, 'Reset');
    RegisterPropertyHelper(@THTTPDataLinkDefaultFields_R,nil,'DefaultFields');
    RegisterPropertyHelper(@THTTPDataLinkFieldCount_R,nil,'FieldCount');
    RegisterPropertyHelper(@THTTPDataLinkFields_R,nil,'Fields');
    RegisterPropertyHelper(@THTTPDataLinkSparseMap_R,@THTTPDataLinkSparseMap_W,'SparseMap');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDSTableProducerEditor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDSTableProducerEditor) do begin
    RegisterConstructor(@TDSTableProducerEditor.Create, 'Create');
    RegisterVirtualMethod(@TDSTableProducerEditor.Changed, 'Changed');
    RegisterVirtualMethod(@TDSTableProducerEditor.PostChange, 'PostChange');
    RegisterPropertyHelper(@TDSTableProducerEditorDSTableProducer_R,nil,'DSTableProducer');
    RegisterPropertyHelper(@TDSTableProducerEditorDataSource_R,@TDSTableProducerEditorDataSource_W,'DataSource');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBWeb(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDSTableProducer) do
  RIRegister_TDSTableProducerEditor(CL);
  RIRegister_THTTPDataLink(CL);
  RIRegister_THTMLTableColumn(CL);
  RIRegister_THTMLTableColumns(CL);
  RIRegister_TDSTableProducer(CL);
  RIRegister_TDataSetTableProducer(CL);
end;


 
{ TPSImport_DBWeb }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBWeb.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBWeb(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBWeb.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBWeb(ri);
  RIRegister_DBWeb_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
