unit uPSI_JvgReport;
{
   a report pac
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
  TPSImport_JvgReport = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvgReport(CL: TPSPascalCompiler);
procedure SIRegister_TJvgReportItem(CL: TPSPascalCompiler);
procedure SIRegister_TJvgReportScrollBox(CL: TPSPascalCompiler);
procedure SIRegister_JvgReport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvgReport(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgReportItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvgReportScrollBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvgReport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Messages
  ,Controls
  ,Graphics
  ,Forms
  ,OleCtnrs
  ,ExtCtrls
  ,Printers
  ,JvComponentBase
  ,JvComponent
  ,JvgUtils_max
  ,JvgTypes
  ,JvgCommClasses
  ,JvgReport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgReport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgReport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvgReport') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvgReport') do
  begin
    RegisterProperty('OwnerWnd', 'TWinControl', iptrw);
    RegisterProperty('ParentWnd', 'TWinControl', iptrw);
    RegisterProperty('ParamNames', 'TStringList', iptrw);
    RegisterProperty('ParamValues', 'TStringList', iptrw);
    RegisterProperty('ParamMasks', 'TStringList', iptrw);
    RegisterProperty('ParamTypes', 'TList', iptrw);
    RegisterProperty('FReportList', 'TStringList', iptrw);
    RegisterProperty('ComponentList', 'TList', iptrw);
    RegisterProperty('FBeforePrint', 'TJvgReportBeforePrintEvent', iptrw);
    RegisterMethod('Procedure Save');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure PaintTo( Canvas : TCanvas)');
    RegisterMethod('Procedure PreviewTo( Window : TWinControl)');
    RegisterMethod('Procedure Print');
    RegisterMethod('Procedure CreateReport( ParentWnd : TWinControl; fNeedClearOwner : Boolean)');
    RegisterMethod('Function SetParam( const sParamName, sParamValue : string) : Boolean');
    RegisterMethod('Function GetParam( const sParamName : string; var sParamValue : string) : Boolean');
    RegisterMethod('Function AddComponent : TJvgReportItem');
    RegisterMethod('Procedure AnalyzeParams( Item : TJvgReportItem; const DefName : string)');
    RegisterProperty('Report', 'TStringList', iptr);
    RegisterProperty('ReportText', 'TStringList', iptrw);
    RegisterProperty('BeforePrint', 'TJvgReportBeforePrintEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgReportItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvgReportItem') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvgReportItem') do
  begin
    RegisterMethod('Procedure Paint');
    RegisterMethod('Procedure PaintTo( Canvas : TCanvas)');
    RegisterProperty('ResText', 'string', iptrw);
    RegisterProperty('OLEContainer', 'TOLEContainer', iptrw);
    RegisterProperty('Selected', 'Boolean', iptrw);
    RegisterProperty('ExternalCanvas', 'TCanvas', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('BkColor', 'Integer', iptrw);
    RegisterProperty('BvColor', 'Integer', iptrw);
    RegisterProperty('Transparent', 'Integer', iptrw);
    RegisterProperty('Alignment', 'Word', iptrw);
    RegisterProperty('SideLeft', 'Word', iptrw);
    RegisterProperty('SideTop', 'Word', iptrw);
    RegisterProperty('SideRight', 'Word', iptrw);
    RegisterProperty('SideBottom', 'Word', iptrw);
    RegisterProperty('PenStyle', 'Integer', iptrw);
    RegisterProperty('PenWidth', 'Word', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('CompName', 'string', iptrw);
    RegisterProperty('FName', 'string', iptrw);
    RegisterProperty('FSize', 'Integer', iptrw);
    RegisterProperty('FColor', 'Integer', iptrw);
    RegisterProperty('FStyle', 'Integer', iptrw);
    RegisterProperty('ContainOLE', 'Boolean', iptrw);
    RegisterProperty('OLELinkToFile', 'string', iptrw);
    RegisterProperty('OLESizeMode', 'Word', iptrw);
    RegisterProperty('Fixed', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgReportScrollBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TScrollBox', 'TJvgReportScrollBox') do
  with CL.AddClassN(CL.FindClass('TScrollBox'),'TJvgReportScrollBox') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('OnDraw', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgReport(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvgReport');
  CL.AddTypeS('TJvgReportParamKind', '( gptUnknown, gptEdit, gptRadio, gptCheck)');
  SIRegister_TJvgReportScrollBox(CL);
  SIRegister_TJvgReportItem(CL);
  CL.AddTypeS('TJvgReportBeforePrintEvent', 'Procedure ( Sender : TJvgReport)');
  SIRegister_TJvgReport(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvgReportBeforePrint_W(Self: TJvgReport; const T: TJvgReportBeforePrintEvent);
begin Self.BeforePrint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportBeforePrint_R(Self: TJvgReport; var T: TJvgReportBeforePrintEvent);
begin T := Self.BeforePrint; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportReportText_W(Self: TJvgReport; const T: TStringList);
begin Self.ReportText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportReportText_R(Self: TJvgReport; var T: TStringList);
begin T := Self.ReportText; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportReport_R(Self: TJvgReport; var T: TStringList);
begin T := Self.Report; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportFBeforePrint_W(Self: TJvgReport; const T: TJvgReportBeforePrintEvent);
Begin Self.FBeforePrint := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportFBeforePrint_R(Self: TJvgReport; var T: TJvgReportBeforePrintEvent);
Begin T := Self.FBeforePrint; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportComponentList_W(Self: TJvgReport; const T: TList);
Begin Self.ComponentList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportComponentList_R(Self: TJvgReport; var T: TList);
Begin T := Self.ComponentList; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportFReportList_W(Self: TJvgReport; const T: TStringList);
Begin Self.FReportList := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportFReportList_R(Self: TJvgReport; var T: TStringList);
Begin T := Self.FReportList; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamTypes_W(Self: TJvgReport; const T: TList);
Begin Self.ParamTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamTypes_R(Self: TJvgReport; var T: TList);
Begin T := Self.ParamTypes; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamMasks_W(Self: TJvgReport; const T: TStringList);
Begin Self.ParamMasks := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamMasks_R(Self: TJvgReport; var T: TStringList);
Begin T := Self.ParamMasks; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamValues_W(Self: TJvgReport; const T: TStringList);
Begin Self.ParamValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamValues_R(Self: TJvgReport; var T: TStringList);
Begin T := Self.ParamValues; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamNames_W(Self: TJvgReport; const T: TStringList);
Begin Self.ParamNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParamNames_R(Self: TJvgReport; var T: TStringList);
Begin T := Self.ParamNames; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParentWnd_W(Self: TJvgReport; const T: TWinControl);
Begin Self.ParentWnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportParentWnd_R(Self: TJvgReport; var T: TWinControl);
Begin T := Self.ParentWnd; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportOwnerWnd_W(Self: TJvgReport; const T: TWinControl);
Begin Self.OwnerWnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportOwnerWnd_R(Self: TJvgReport; var T: TWinControl);
Begin T := Self.OwnerWnd; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFixed_W(Self: TJvgReportItem; const T: Word);
begin Self.Fixed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFixed_R(Self: TJvgReportItem; var T: Word);
begin T := Self.Fixed; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemOLESizeMode_W(Self: TJvgReportItem; const T: Word);
begin Self.OLESizeMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemOLESizeMode_R(Self: TJvgReportItem; var T: Word);
begin T := Self.OLESizeMode; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemOLELinkToFile_W(Self: TJvgReportItem; const T: string);
begin Self.OLELinkToFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemOLELinkToFile_R(Self: TJvgReportItem; var T: string);
begin T := Self.OLELinkToFile; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemContainOLE_W(Self: TJvgReportItem; const T: Boolean);
begin Self.ContainOLE := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemContainOLE_R(Self: TJvgReportItem; var T: Boolean);
begin T := Self.ContainOLE; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFStyle_W(Self: TJvgReportItem; const T: Integer);
begin Self.FStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFStyle_R(Self: TJvgReportItem; var T: Integer);
begin T := Self.FStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFColor_W(Self: TJvgReportItem; const T: Integer);
begin Self.FColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFColor_R(Self: TJvgReportItem; var T: Integer);
begin T := Self.FColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFSize_W(Self: TJvgReportItem; const T: Integer);
begin Self.FSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFSize_R(Self: TJvgReportItem; var T: Integer);
begin T := Self.FSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFName_W(Self: TJvgReportItem; const T: string);
begin Self.FName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemFName_R(Self: TJvgReportItem; var T: string);
begin T := Self.FName; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemCompName_W(Self: TJvgReportItem; const T: string);
begin Self.CompName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemCompName_R(Self: TJvgReportItem; var T: string);
begin T := Self.CompName; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemText_W(Self: TJvgReportItem; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemText_R(Self: TJvgReportItem; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemPenWidth_W(Self: TJvgReportItem; const T: Word);
begin Self.PenWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemPenWidth_R(Self: TJvgReportItem; var T: Word);
begin T := Self.PenWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemPenStyle_W(Self: TJvgReportItem; const T: Integer);
begin Self.PenStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemPenStyle_R(Self: TJvgReportItem; var T: Integer);
begin T := Self.PenStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideBottom_W(Self: TJvgReportItem; const T: Word);
begin Self.SideBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideBottom_R(Self: TJvgReportItem; var T: Word);
begin T := Self.SideBottom; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideRight_W(Self: TJvgReportItem; const T: Word);
begin Self.SideRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideRight_R(Self: TJvgReportItem; var T: Word);
begin T := Self.SideRight; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideTop_W(Self: TJvgReportItem; const T: Word);
begin Self.SideTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideTop_R(Self: TJvgReportItem; var T: Word);
begin T := Self.SideTop; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideLeft_W(Self: TJvgReportItem; const T: Word);
begin Self.SideLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSideLeft_R(Self: TJvgReportItem; var T: Word);
begin T := Self.SideLeft; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemAlignment_W(Self: TJvgReportItem; const T: Word);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemAlignment_R(Self: TJvgReportItem; var T: Word);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemTransparent_W(Self: TJvgReportItem; const T: Integer);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemTransparent_R(Self: TJvgReportItem; var T: Integer);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemBvColor_W(Self: TJvgReportItem; const T: Integer);
begin Self.BvColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemBvColor_R(Self: TJvgReportItem; var T: Integer);
begin T := Self.BvColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemBkColor_W(Self: TJvgReportItem; const T: Integer);
begin Self.BkColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemBkColor_R(Self: TJvgReportItem; var T: Integer);
begin T := Self.BkColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemExternalCanvas_W(Self: TJvgReportItem; const T: TCanvas);
begin Self.ExternalCanvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemExternalCanvas_R(Self: TJvgReportItem; var T: TCanvas);
begin T := Self.ExternalCanvas; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSelected_W(Self: TJvgReportItem; const T: Boolean);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemSelected_R(Self: TJvgReportItem; var T: Boolean);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemOLEContainer_W(Self: TJvgReportItem; const T: TOLEContainer);
Begin Self.OLEContainer := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemOLEContainer_R(Self: TJvgReportItem; var T: TOLEContainer);
Begin T := Self.OLEContainer; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemResText_W(Self: TJvgReportItem; const T: string);
Begin Self.ResText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportItemResText_R(Self: TJvgReportItem; var T: string);
Begin T := Self.ResText; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportScrollBoxOnDraw_W(Self: TJvgReportScrollBox; const T: TNotifyEvent);
begin Self.OnDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgReportScrollBoxOnDraw_R(Self: TJvgReportScrollBox; var T: TNotifyEvent);
begin T := Self.OnDraw; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgReport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgReport) do
  begin
    RegisterPropertyHelper(@TJvgReportOwnerWnd_R,@TJvgReportOwnerWnd_W,'OwnerWnd');
    RegisterPropertyHelper(@TJvgReportParentWnd_R,@TJvgReportParentWnd_W,'ParentWnd');
    RegisterPropertyHelper(@TJvgReportParamNames_R,@TJvgReportParamNames_W,'ParamNames');
    RegisterPropertyHelper(@TJvgReportParamValues_R,@TJvgReportParamValues_W,'ParamValues');
    RegisterPropertyHelper(@TJvgReportParamMasks_R,@TJvgReportParamMasks_W,'ParamMasks');
    RegisterPropertyHelper(@TJvgReportParamTypes_R,@TJvgReportParamTypes_W,'ParamTypes');
    RegisterPropertyHelper(@TJvgReportFReportList_R,@TJvgReportFReportList_W,'FReportList');
    RegisterPropertyHelper(@TJvgReportComponentList_R,@TJvgReportComponentList_W,'ComponentList');
    RegisterPropertyHelper(@TJvgReportFBeforePrint_R,@TJvgReportFBeforePrint_W,'FBeforePrint');
    RegisterMethod(@TJvgReport.Save, 'Save');
    RegisterMethod(@TJvgReport.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJvgReport.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJvgReport.PaintTo, 'PaintTo');
    RegisterMethod(@TJvgReport.PreviewTo, 'PreviewTo');
    RegisterMethod(@TJvgReport.Print, 'Print');
    RegisterMethod(@TJvgReport.CreateReport, 'CreateReport');
    RegisterMethod(@TJvgReport.SetParam, 'SetParam');
    RegisterMethod(@TJvgReport.GetParam, 'GetParam');
    RegisterMethod(@TJvgReport.AddComponent, 'AddComponent');
    RegisterMethod(@TJvgReport.AnalyzeParams, 'AnalyzeParams');
    RegisterPropertyHelper(@TJvgReportReport_R,nil,'Report');
    RegisterPropertyHelper(@TJvgReportReportText_R,@TJvgReportReportText_W,'ReportText');
    RegisterPropertyHelper(@TJvgReportBeforePrint_R,@TJvgReportBeforePrint_W,'BeforePrint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgReportItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgReportItem) do
  begin
    RegisterMethod(@TJvgReportItem.Paint, 'Paint');
    RegisterMethod(@TJvgReportItem.PaintTo, 'PaintTo');
    RegisterPropertyHelper(@TJvgReportItemResText_R,@TJvgReportItemResText_W,'ResText');
    RegisterPropertyHelper(@TJvgReportItemOLEContainer_R,@TJvgReportItemOLEContainer_W,'OLEContainer');
    RegisterPropertyHelper(@TJvgReportItemSelected_R,@TJvgReportItemSelected_W,'Selected');
    RegisterPropertyHelper(@TJvgReportItemExternalCanvas_R,@TJvgReportItemExternalCanvas_W,'ExternalCanvas');
    RegisterConstructor(@TJvgReportItem.Create, 'Create');
    RegisterPropertyHelper(@TJvgReportItemBkColor_R,@TJvgReportItemBkColor_W,'BkColor');
    RegisterPropertyHelper(@TJvgReportItemBvColor_R,@TJvgReportItemBvColor_W,'BvColor');
    RegisterPropertyHelper(@TJvgReportItemTransparent_R,@TJvgReportItemTransparent_W,'Transparent');
    RegisterPropertyHelper(@TJvgReportItemAlignment_R,@TJvgReportItemAlignment_W,'Alignment');
    RegisterPropertyHelper(@TJvgReportItemSideLeft_R,@TJvgReportItemSideLeft_W,'SideLeft');
    RegisterPropertyHelper(@TJvgReportItemSideTop_R,@TJvgReportItemSideTop_W,'SideTop');
    RegisterPropertyHelper(@TJvgReportItemSideRight_R,@TJvgReportItemSideRight_W,'SideRight');
    RegisterPropertyHelper(@TJvgReportItemSideBottom_R,@TJvgReportItemSideBottom_W,'SideBottom');
    RegisterPropertyHelper(@TJvgReportItemPenStyle_R,@TJvgReportItemPenStyle_W,'PenStyle');
    RegisterPropertyHelper(@TJvgReportItemPenWidth_R,@TJvgReportItemPenWidth_W,'PenWidth');
    RegisterPropertyHelper(@TJvgReportItemText_R,@TJvgReportItemText_W,'Text');
    RegisterPropertyHelper(@TJvgReportItemCompName_R,@TJvgReportItemCompName_W,'CompName');
    RegisterPropertyHelper(@TJvgReportItemFName_R,@TJvgReportItemFName_W,'FName');
    RegisterPropertyHelper(@TJvgReportItemFSize_R,@TJvgReportItemFSize_W,'FSize');
    RegisterPropertyHelper(@TJvgReportItemFColor_R,@TJvgReportItemFColor_W,'FColor');
    RegisterPropertyHelper(@TJvgReportItemFStyle_R,@TJvgReportItemFStyle_W,'FStyle');
    RegisterPropertyHelper(@TJvgReportItemContainOLE_R,@TJvgReportItemContainOLE_W,'ContainOLE');
    RegisterPropertyHelper(@TJvgReportItemOLELinkToFile_R,@TJvgReportItemOLELinkToFile_W,'OLELinkToFile');
    RegisterPropertyHelper(@TJvgReportItemOLESizeMode_R,@TJvgReportItemOLESizeMode_W,'OLESizeMode');
    RegisterPropertyHelper(@TJvgReportItemFixed_R,@TJvgReportItemFixed_W,'Fixed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgReportScrollBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgReportScrollBox) do
  begin
    RegisterConstructor(@TJvgReportScrollBox.Create, 'Create');
    RegisterPropertyHelper(@TJvgReportScrollBoxOnDraw_R,@TJvgReportScrollBoxOnDraw_W,'OnDraw');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgReport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgReport) do
  RIRegister_TJvgReportScrollBox(CL);
  RIRegister_TJvgReportItem(CL);
  RIRegister_TJvgReport(CL);
end;

 
 
{ TPSImport_JvgReport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgReport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgReport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgReport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgReport(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
