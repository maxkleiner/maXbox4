unit uPSI_uHTMLBuilder;
{
as a pretest to pas2js
https://github.com/guitorres/htmlbuilder/blob/master/src/uHTMLBuilder.pas

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
  TPSImport_uHTMLBuilder = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THTMLBuild(CL: TPSPascalCompiler);
procedure SIRegister_THTMLReport(CL: TPSPascalCompiler);
procedure SIRegister_THTMLTable(CL: TPSPascalCompiler);
procedure SIRegister_THTMLRow(CL: TPSPascalCompiler);
procedure SIRegister_THTMLParagraph(CL: TPSPascalCompiler);
procedure SIRegister_THTMLItem(CL: TPSPascalCompiler);
procedure SIRegister_THTMLCell(CL: TPSPascalCompiler);
procedure SIRegister_THTMLBase(CL: TPSPascalCompiler);
procedure SIRegister_uHTMLBuilder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THTMLBuild(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLReport(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLRow(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLParagraph(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLCell(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_uHTMLBuilder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,DB
  ,uHTMLBuilder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uHTMLBuilder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLBuild(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTMLBuild') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLBuild') do
  begin
    RegisterMethod('Function Build( item : TObject) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLReport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTMLReport') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLReport') do
  begin
    RegisterProperty('HTMLItemList', 'TObjectList', iptrw);
    RegisterProperty('Style', 'string', iptrw);
    RegisterProperty('StyleHTML', 'string', iptrw);
    RegisterProperty('Head', 'string', iptrw);
    RegisterMethod('Procedure AddTable( table : THTMLTable)');
    RegisterMethod('Procedure AddItem( item : THTMLItem)');
    RegisterMethod('Function AddParagraph( paragraphName, paragraphStyle : string) : THTMLParagraph');
    RegisterMethod('Function Build : string');
    RegisterMethod('Procedure SaveToFile( fileName : string)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Constructor Create;');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Constructor Create1( reportStyle : string);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THTMLBase', 'THTMLTable') do
  with CL.AddClassN(CL.FindClass('THTMLBase'),'THTMLTable') do
  begin
    RegisterProperty('Style', 'string', iptrw);
    RegisterProperty('RowList', 'TObjectList', iptrw);
    RegisterMethod('Function AddRow( cellList : array of THTMLCell; rowStyle : string) : THTMLRow;');
    RegisterMethod('Function AddRow1( rowName, rowStyle : string) : THTMLRow;');
    RegisterMethod('Function AddEmptyRow( rowStyle : string) : THTMLRow');
    RegisterMethod('Function Build : string');
    RegisterMethod('Procedure SetDataSet( dataSet : TDataSet; HeaderColor : string; EvenColor : string; OddColor : string; EmptyValue : string; AfterAddRow : TAfterAddRow)');
    RegisterMethod('Constructor Create( tableStyle : string)');
     RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLRow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTMLRow') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLRow') do
  begin
    RegisterProperty('Style', 'string', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('CellList', 'TObjectList', iptrw);
    RegisterMethod('Function Build : string');
    RegisterMethod('Function AddCell( cellName, cellStyle : string) : THTMLCell');
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( rowCellList : array of THTMLCell);');
    RegisterMethod('Constructor Create2( rowCellList : array of THTMLCell; rowStyle : string);');
     RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLParagraph(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTMLParagraph') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLParagraph') do
  begin
    RegisterProperty('Style', 'string', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('ItemList', 'TObjectList', iptrw);
    RegisterMethod('Function Build : string');
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( paragraphName, style : string);');
     RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTMLItem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLItem') do
  begin
    RegisterProperty('HTML', 'TStringList', iptrw);
    RegisterMethod('Function Build : string');
    RegisterMethod('Constructor Create( itemHtml : string)');
     RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLCell(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTMLCell') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLCell') do
  begin
    RegisterProperty('Style', 'string', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('ItemList', 'TObjectList', iptrw);
    RegisterMethod('Function Build : string');
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( cellName, cellStyle : string);');
     RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THTMLBase') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLBase') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uHTMLBuilder(CL: TPSPascalCompiler);
begin
  SIRegister_THTMLBase(CL);
  SIRegister_THTMLCell(CL);
  CL.AddTypeS('TAfterAddRow', 'Procedure ( Table : THTMLBase; DataSet : TDataSet)');
  SIRegister_THTMLItem(CL);
  SIRegister_THTMLParagraph(CL);
  SIRegister_THTMLRow(CL);
  SIRegister_THTMLTable(CL);
  SIRegister_THTMLReport(CL);
  SIRegister_THTMLBuild(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function THTMLReportCreate10_P(Self: TClass; CreateNewInstance: Boolean;  reportStyle : string):TObject;
Begin Result := THTMLReport.Create(reportStyle); END;

(*----------------------------------------------------------------------------*)
Function THTMLReportCreate9_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := THTMLReport.Create; END;

(*----------------------------------------------------------------------------*)
procedure THTMLReportHead_W(Self: THTMLReport; const T: string);
begin Self.Head := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLReportHead_R(Self: THTMLReport; var T: string);
begin T := Self.Head; end;

(*----------------------------------------------------------------------------*)
procedure THTMLReportStyleHTML_W(Self: THTMLReport; const T: string);
begin Self.StyleHTML := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLReportStyleHTML_R(Self: THTMLReport; var T: string);
begin T := Self.StyleHTML; end;

(*----------------------------------------------------------------------------*)
procedure THTMLReportStyle_W(Self: THTMLReport; const T: string);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLReportStyle_R(Self: THTMLReport; var T: string);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure THTMLReportHTMLItemList_W(Self: THTMLReport; const T: TObjectList);
begin Self.HTMLItemList := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLReportHTMLItemList_R(Self: THTMLReport; var T: TObjectList);
begin T := Self.HTMLItemList; end;

(*----------------------------------------------------------------------------*)
Function THTMLTableAddRow1_P(Self: THTMLTable;  rowName, rowStyle : string) : THTMLRow;
Begin Result := Self.AddRow(rowName, rowStyle); END;

(*----------------------------------------------------------------------------*)
Function THTMLTableAddRow_P(Self: THTMLTable;  cellList : array of THTMLCell; rowStyle : string) : THTMLRow;
Begin Result := Self.AddRow(cellList, rowStyle); END;

(*----------------------------------------------------------------------------*)
procedure THTMLTableRowList_W(Self: THTMLTable; const T: TObjectList);
begin Self.RowList := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableRowList_R(Self: THTMLTable; var T: TObjectList);
begin T := Self.RowList; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableStyle_W(Self: THTMLTable; const T: string);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableStyle_R(Self: THTMLTable; var T: string);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
Function THTMLRowCreate6_P(Self: TClass; CreateNewInstance: Boolean;  rowCellList : array of THTMLCell; rowStyle : string):TObject;
Begin Result := THTMLRow.Create(rowCellList, rowStyle); END;

(*----------------------------------------------------------------------------*)
Function THTMLRowCreate5_P(Self: TClass; CreateNewInstance: Boolean;  rowCellList : array of THTMLCell):TObject;
Begin Result := THTMLRow.Create(rowCellList); END;

(*----------------------------------------------------------------------------*)
Function THTMLRowCreate4_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := THTMLRow.Create; END;

(*----------------------------------------------------------------------------*)
procedure THTMLRowCellList_W(Self: THTMLRow; const T: TObjectList);
begin Self.CellList := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLRowCellList_R(Self: THTMLRow; var T: TObjectList);
begin T := Self.CellList; end;

(*----------------------------------------------------------------------------*)
procedure THTMLRowName_W(Self: THTMLRow; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLRowName_R(Self: THTMLRow; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure THTMLRowStyle_W(Self: THTMLRow; const T: string);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLRowStyle_R(Self: THTMLRow; var T: string);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
Function THTMLParagraphCreate3_P(Self: TClass; CreateNewInstance: Boolean;  paragraphName, style : string):TObject;
Begin Result := THTMLParagraph.Create(paragraphName, style); END;

(*----------------------------------------------------------------------------*)
Function THTMLParagraphCreate2_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := THTMLParagraph.Create; END;

(*----------------------------------------------------------------------------*)
procedure THTMLParagraphItemList_W(Self: THTMLParagraph; const T: TObjectList);
begin Self.ItemList := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLParagraphItemList_R(Self: THTMLParagraph; var T: TObjectList);
begin T := Self.ItemList; end;

(*----------------------------------------------------------------------------*)
procedure THTMLParagraphName_W(Self: THTMLParagraph; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLParagraphName_R(Self: THTMLParagraph; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure THTMLParagraphStyle_W(Self: THTMLParagraph; const T: string);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLParagraphStyle_R(Self: THTMLParagraph; var T: string);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure THTMLItemHTML_W(Self: THTMLItem; const T: TStringList);
begin Self.HTML := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLItemHTML_R(Self: THTMLItem; var T: TStringList);
begin T := Self.HTML; end;

(*----------------------------------------------------------------------------*)
Function THTMLCellCreate1_P(Self: TClass; CreateNewInstance: Boolean;  cellName, cellStyle : string):TObject;
Begin Result := THTMLCell.Create(cellName, cellStyle); END;

(*----------------------------------------------------------------------------*)
Function THTMLCellCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := THTMLCell.Create; END;

(*----------------------------------------------------------------------------*)
procedure THTMLCellItemList_W(Self: THTMLCell; const T: TObjectList);
begin Self.ItemList := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLCellItemList_R(Self: THTMLCell; var T: TObjectList);
begin T := Self.ItemList; end;

(*----------------------------------------------------------------------------*)
procedure THTMLCellName_W(Self: THTMLCell; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLCellName_R(Self: THTMLCell; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure THTMLCellStyle_W(Self: THTMLCell; const T: string);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLCellStyle_R(Self: THTMLCell; var T: string);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLBuild(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLBuild) do
  begin
    RegisterMethod(@THTMLBuild.Build, 'Build');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLReport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLReport) do
  begin
    RegisterPropertyHelper(@THTMLReportHTMLItemList_R,@THTMLReportHTMLItemList_W,'HTMLItemList');
    RegisterPropertyHelper(@THTMLReportStyle_R,@THTMLReportStyle_W,'Style');
    RegisterPropertyHelper(@THTMLReportStyleHTML_R,@THTMLReportStyleHTML_W,'StyleHTML');
    RegisterPropertyHelper(@THTMLReportHead_R,@THTMLReportHead_W,'Head');
    RegisterMethod(@THTMLReport.AddTable, 'AddTable');
    RegisterMethod(@THTMLReport.AddItem, 'AddItem');
    RegisterMethod(@THTMLReport.AddParagraph, 'AddParagraph');
    RegisterMethod(@THTMLReport.Build, 'Build');
    RegisterMethod(@THTMLReport.SaveToFile, 'SaveToFile');
    RegisterMethod(@THTMLReport.Clear, 'Clear');
    RegisterConstructor(@THTMLReportCreate9_P, 'Create');
    RegisterConstructor(@THTMLReportCreate10_P, 'Create1');
    RegisterMethod(@THTMLReport.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLTable) do
  begin
    RegisterPropertyHelper(@THTMLTableStyle_R,@THTMLTableStyle_W,'Style');
    RegisterPropertyHelper(@THTMLTableRowList_R,@THTMLTableRowList_W,'RowList');
    RegisterMethod(@THTMLTableAddRow_P, 'AddRow');
    RegisterMethod(@THTMLTableAddRow1_P, 'AddRow1');
    RegisterMethod(@THTMLTable.AddEmptyRow, 'AddEmptyRow');
    RegisterMethod(@THTMLTable.Build, 'Build');
    RegisterMethod(@THTMLTable.SetDataSet, 'SetDataSet');
    RegisterConstructor(@THTMLTable.Create, 'Create');
    RegisterMethod(@THTMLTable.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLRow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLRow) do
  begin
    RegisterPropertyHelper(@THTMLRowStyle_R,@THTMLRowStyle_W,'Style');
    RegisterPropertyHelper(@THTMLRowName_R,@THTMLRowName_W,'Name');
    RegisterPropertyHelper(@THTMLRowCellList_R,@THTMLRowCellList_W,'CellList');
    RegisterMethod(@THTMLRow.Build, 'Build');
    RegisterMethod(@THTMLRow.AddCell, 'AddCell');
    RegisterConstructor(@THTMLRowCreate4_P, 'Create');
    RegisterConstructor(@THTMLRowCreate5_P, 'Create1');
    RegisterConstructor(@THTMLRowCreate6_P, 'Create2');
    RegisterMethod(@THTMLRow.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLParagraph(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLParagraph) do
  begin
    RegisterPropertyHelper(@THTMLParagraphStyle_R,@THTMLParagraphStyle_W,'Style');
    RegisterPropertyHelper(@THTMLParagraphName_R,@THTMLParagraphName_W,'Name');
    RegisterPropertyHelper(@THTMLParagraphItemList_R,@THTMLParagraphItemList_W,'ItemList');
    RegisterMethod(@THTMLParagraph.Build, 'Build');
    RegisterConstructor(@THTMLParagraphCreate2_P, 'Create');
    RegisterConstructor(@THTMLParagraphCreate3_P, 'Create1');
    RegisterMethod(@THTMLParagraph.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLItem) do
  begin
    RegisterPropertyHelper(@THTMLItemHTML_R,@THTMLItemHTML_W,'HTML');
    RegisterMethod(@THTMLItem.Build, 'Build');
    RegisterConstructor(@THTMLItem.Create, 'Create');
    RegisterMethod(@THTMLItem.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLCell(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLCell) do
  begin
    RegisterPropertyHelper(@THTMLCellStyle_R,@THTMLCellStyle_W,'Style');
    RegisterPropertyHelper(@THTMLCellName_R,@THTMLCellName_W,'Name');
    RegisterPropertyHelper(@THTMLCellItemList_R,@THTMLCellItemList_W,'ItemList');
    RegisterMethod(@THTMLCell.Build, 'Build');
    RegisterConstructor(@THTMLCellCreate_P, 'Create');
    RegisterConstructor(@THTMLCellCreate1_P, 'Create1');
    RegisterMethod(@THTMLCell.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLBase) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uHTMLBuilder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THTMLBase(CL);
  RIRegister_THTMLCell(CL);
  RIRegister_THTMLItem(CL);
  RIRegister_THTMLParagraph(CL);
  RIRegister_THTMLRow(CL);
  RIRegister_THTMLTable(CL);
  RIRegister_THTMLReport(CL);
  RIRegister_THTMLBuild(CL);
end;

 
 
{ TPSImport_uHTMLBuilder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uHTMLBuilder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uHTMLBuilder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uHTMLBuilder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uHTMLBuilder(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
