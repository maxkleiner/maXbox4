unit uPSI_Dialogs;
{
  with overload of createdialogs  execute says vista or later ?
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
  TPSImport_Dialogs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTaskDialog(CL: TPSPascalCompiler);
procedure SIRegister_TCustomTaskDialog(CL: TPSPascalCompiler);
procedure SIRegister_TTaskDialogButtons(CL: TPSPascalCompiler);
procedure SIRegister_TTaskDialogButtonsEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TTaskDialogRadioButtonItem(CL: TPSPascalCompiler);
procedure SIRegister_TTaskDialogButtonItem(CL: TPSPascalCompiler);
procedure SIRegister_TTaskDialogBaseButtonItem(CL: TPSPascalCompiler);
procedure SIRegister_TTaskDialogProgressBar(CL: TPSPascalCompiler);
procedure SIRegister_TFileSaveDialog(CL: TPSPascalCompiler);
procedure SIRegister_TCustomFileSaveDialog(CL: TPSPascalCompiler);
procedure SIRegister_TFileOpenDialog(CL: TPSPascalCompiler);
procedure SIRegister_TCustomFileOpenDialog(CL: TPSPascalCompiler);
procedure SIRegister_TCustomFileDialog(CL: TPSPascalCompiler);
procedure SIRegister_TFavoriteLinkItems(CL: TPSPascalCompiler);
procedure SIRegister_TFavoriteLinkItemsEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TFavoriteLinkItem(CL: TPSPascalCompiler);
procedure SIRegister_TFileTypeItems(CL: TPSPascalCompiler);
procedure SIRegister_TFileTypeItem(CL: TPSPascalCompiler);
procedure SIRegister_TReplaceDialog(CL: TPSPascalCompiler);
procedure SIRegister_TFindDialog(CL: TPSPascalCompiler);
procedure SIRegister_TPageSetupDialog(CL: TPSPascalCompiler);
procedure SIRegister_TPrintDialog(CL: TPSPascalCompiler);
procedure SIRegister_TPrinterSetupDialog(CL: TPSPascalCompiler);
procedure SIRegister_TFontDialog(CL: TPSPascalCompiler);
procedure SIRegister_TColorDialog(CL: TPSPascalCompiler);
procedure SIRegister_TSaveDialog(CL: TPSPascalCompiler);
procedure SIRegister_TOpenDialog(CL: TPSPascalCompiler);
procedure SIRegister_TCommonDialog(CL: TPSPascalCompiler);
procedure SIRegister_Dialogs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Dialogs_Routines(S: TPSExec);
procedure RIRegister_TTaskDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTaskDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskDialogButtons(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskDialogButtonsEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskDialogRadioButtonItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskDialogButtonItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskDialogBaseButtonItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskDialogProgressBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileSaveDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomFileSaveDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileOpenDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomFileOpenDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomFileDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFavoriteLinkItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFavoriteLinkItemsEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFavoriteLinkItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileTypeItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileTypeItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TReplaceDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFindDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPageSetupDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPrintDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPrinterSetupDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFontDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TColorDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSaveDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOpenDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCommonDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_Dialogs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Dialogs, Forms, Controls, Windows, Graphics, shlobj, commdlg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Dialogs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTaskDialog', 'TTaskDialog') do
  with CL.AddClassN(CL.FindClass('TCustomTaskDialog'),'TTaskDialog') do
  begin
  end;
end;

function myCreateMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Button: TMsgDlgBtn): TForm;
  var buttons: TMsgDlgButtons;
  begin

   if button = TMsgDlgBtn(ord(mbAbort) or ord(mbIgnore)) then
     button:= TMsgDlgBtn(ord(mbAbort) or ord(mbIgnore));
     //button:= [mbAbortIgnore];
   //case ord(Buttons) of
     //mbAbortIgnore:=  ord(mbAbort) or ord(mbIgnore);
   //end;
   //'mbAbortIgnore','LongInt').Value.ts32 := ord(mbAbort) or ord(mbIgnore);
    buttons:= [button];
    result:= CreateMessageDialog(Msg, DlgType, buttons);
  end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomTaskDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomTaskDialog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomTaskDialog') do begin
    RegisterMethod('Function Execute : Boolean;');
    RegisterMethod('Function Execute1( ParentWnd : HWND) : Boolean;');
    RegisterProperty('Button', 'TTaskDialogButtonItem', iptrw);
    RegisterProperty('Buttons', 'TTaskDialogButtons', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('CommonButtons', 'TTaskDialogCommonButtons', iptrw);
    RegisterProperty('CustomFooterIcon', 'TIcon', iptrw);
    RegisterProperty('CustomMainIcon', 'TIcon', iptrw);
    RegisterProperty('DefaultButton', 'TTaskDialogCommonButton', iptrw);
    RegisterProperty('ExpandButtonCaption', 'string', iptrw);
    RegisterProperty('Expanded', 'Boolean', iptr);
    RegisterProperty('ExpandedText', 'string', iptrw);
    RegisterProperty('Flags', 'TTaskDialogFlags', iptrw);
    RegisterProperty('FooterIcon', 'TTaskDialogIcon', iptrw);
    RegisterProperty('FooterText', 'string', iptrw);
    RegisterProperty('Handle', 'HWND', iptr);
    RegisterProperty('HelpContext', 'Integer', iptrw);
    RegisterProperty('MainIcon', 'TTaskDialogIcon', iptrw);
    RegisterProperty('ModalResult', 'TModalResult', iptrw);
    RegisterProperty('ProgressBar', 'TTaskDialogProgressBar', iptrw);
    RegisterProperty('RadioButton', 'TTaskDialogRadioButtonItem', iptr);
    RegisterProperty('RadioButtons', 'TTaskDialogButtons', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('URL', 'string', iptr);
    RegisterProperty('VerificationText', 'string', iptrw);
    RegisterProperty('OnButtonClicked', 'TTaskDlgClickEvent', iptrw);
    RegisterProperty('OnDialogConstructed', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDialogCreated', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDialogDestroyed', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExpanded', 'TNotifyEvent', iptrw);
    RegisterProperty('OnHyperlinkClicked', 'TNotifyEvent', iptrw);
    RegisterProperty('OnNavigated', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRadioButtonClicked', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTimer', 'TTaskDlgTimerEvent', iptrw);
    RegisterProperty('OnVerificationClicked', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskDialogButtons(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TTaskDialogButtons') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TTaskDialogButtons') do begin
    RegisterMethod('Function Add : TTaskDialogBaseButtonItem');
    RegisterMethod('Function Buttons : PTaskDialogButton');
    RegisterMethod('Function FindButton( AModalResult : TModalResult) : TTaskDialogBaseButtonItem');
    RegisterMethod('Function GetEnumerator : TTaskDialogButtonsEnumerator');
    RegisterMethod('Procedure SetInitialState');
    RegisterProperty('DefaultButton', 'TTaskDialogBaseButtonItem', iptrw);
    RegisterProperty('Items', 'TTaskDialogBaseButtonItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskDialogButtonsEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTaskDialogButtonsEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTaskDialogButtonsEnumerator') do begin
    RegisterMethod('Constructor Create( ACollection : TTaskDialogButtons)');
    RegisterMethod('Function GetCurrent : TTaskDialogBaseButtonItem');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TTaskDialogBaseButtonItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskDialogRadioButtonItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTaskDialogBaseButtonItem', 'TTaskDialogRadioButtonItem') do
  with CL.AddClassN(CL.FindClass('TTaskDialogBaseButtonItem'),'TTaskDialogRadioButtonItem') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskDialogButtonItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTaskDialogBaseButtonItem', 'TTaskDialogButtonItem') do
  with CL.AddClassN(CL.FindClass('TTaskDialogBaseButtonItem'),'TTaskDialogButtonItem') do
  begin
    RegisterProperty('CommandLinkHint', 'string', iptrw);
    RegisterProperty('ElevationRequired', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskDialogBaseButtonItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TTaskDialogBaseButtonItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TTaskDialogBaseButtonItem') do
  begin
    RegisterMethod('Procedure Click');
    RegisterMethod('Procedure SetInitialState');
    RegisterProperty('ModalResult', 'TModalResult', iptrw);
    RegisterProperty('TextWStr', 'LPCWSTR', iptr);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Default', 'Boolean', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskDialogProgressBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTaskDialogProgressBar') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTaskDialogProgressBar') do
  begin
    RegisterMethod('Constructor Create( AClient : TCustomTaskDialog)');
    RegisterMethod('Procedure Initialize');
    RegisterProperty('MarqueeSpeed', 'Cardinal', iptrw);
    RegisterProperty('Max', 'Integer', iptrw);
    RegisterProperty('Min', 'Integer', iptrw);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('State', 'TProgressBarState', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileSaveDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFileSaveDialog', 'TFileSaveDialog') do
  with CL.AddClassN(CL.FindClass('TCustomFileSaveDialog'),'TFileSaveDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomFileSaveDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFileDialog', 'TCustomFileSaveDialog') do
  with CL.AddClassN(CL.FindClass('TCustomFileDialog'),'TCustomFileSaveDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileOpenDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFileOpenDialog', 'TFileOpenDialog') do
  with CL.AddClassN(CL.FindClass('TCustomFileOpenDialog'),'TFileOpenDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomFileOpenDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFileDialog', 'TCustomFileOpenDialog') do
  with CL.AddClassN(CL.FindClass('TCustomFileDialog'),'TCustomFileOpenDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomFileDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomFileDialog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomFileDialog') do begin
    RegisterPublishedProperties;

    RegisterMethod('Function Execute : Boolean;');
    RegisterMethod('Function Execute1( ParentWnd : HWND) : Boolean;');
    RegisterMethod('Constructor Create(AOwner: TComponent);');

    RegisterProperty('ClientGuid', 'string', iptrw);
    RegisterProperty('DefaultExtension', 'string', iptrw);
    RegisterProperty('DefaultFolder', 'string', iptrw);
    RegisterProperty('Dialog', 'IFileDialog', iptr);
    RegisterProperty('FavoriteLinks', 'TFavoriteLinkItems', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('FileNameLabel', 'string', iptrw);
    RegisterProperty('Files', 'TStrings', iptr);
    RegisterProperty('FileTypes', 'TFileTypeItems', iptrw);
    RegisterProperty('FileTypeIndex', 'Cardinal', iptrw);
    RegisterProperty('Handle', 'HWnd', iptr);
    RegisterProperty('OkButtonLabel', 'string', iptrw);
    RegisterProperty('Options', 'TFileDialogOptions', iptrw);
    RegisterProperty('ShellItem', 'IShellItem', iptr);
    RegisterProperty('ShellItems', 'IShellItemArray', iptr);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('OnExecute', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFileOkClick', 'TFileDialogCloseEvent', iptrw);
    RegisterProperty('OnFolderChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFolderChanging', 'TFileDialogFolderChangingEvent', iptrw);
    RegisterProperty('OnOverwrite', 'TFileDialogOverwriteEvent', iptrw);
    RegisterProperty('OnSelectionChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShareViolation', 'TFileDialogShareViolationEvent', iptrw);
    RegisterProperty('OnTypeChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFavoriteLinkItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TFavoriteLinkItems') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TFavoriteLinkItems') do begin
    RegisterMethod('Function Add : TFavoriteLinkItem');
    RegisterMethod('Function GetEnumerator : TFavoriteLinkItemsEnumerator');
    RegisterProperty('Items', 'TFavoriteLinkItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFavoriteLinkItemsEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFavoriteLinkItemsEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFavoriteLinkItemsEnumerator') do begin
    RegisterMethod('Constructor Create( ACollection : TFavoriteLinkItems)');
    RegisterMethod('Function GetCurrent : TFavoriteLinkItem');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TFavoriteLinkItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFavoriteLinkItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TFavoriteLinkItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TFavoriteLinkItem') do
  begin
    RegisterProperty('Location', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileTypeItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TFileTypeItems') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TFileTypeItems') do begin
    RegisterMethod('Function Add : TFileTypeItem');
    RegisterMethod('Function FilterSpecArray : TComdlgFilterSpecArray');
    RegisterProperty('Items', 'TFileTypeItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileTypeItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TFileTypeItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TFileTypeItem') do begin
    RegisterProperty('DisplayNameWStr', 'LPCWSTR', iptr);
    RegisterProperty('FileMaskWStr', 'LPCWSTR', iptr);
    RegisterProperty('DisplayName', 'string', iptrw);
    RegisterProperty('FileMask', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TReplaceDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFindDialog', 'TReplaceDialog') do
  with CL.AddClassN(CL.FindClass('TFindDialog'),'TReplaceDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFindDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialog', 'TFindDialog') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TFindDialog') do begin
    RegisterMethod('Procedure CloseDialog');
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Position', 'TPoint', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('FindText', 'string', iptrw);
    RegisterProperty('Options', 'TFindOptions', iptrw);
    RegisterProperty('OnFind', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPageSetupDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialog', 'TPageSetupDialog') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TPageSetupDialog') do begin
    RegisterMethod('Function GetDefaults : Boolean');
    RegisterProperty('PageSetupDlgRec', 'TPageSetupDlg', iptr);
    RegisterProperty('MinMarginLeft', 'Integer', iptrw);
    RegisterProperty('MinMarginTop', 'Integer', iptrw);
    RegisterProperty('MinMarginRight', 'Integer', iptrw);
    RegisterProperty('MinMarginBottom', 'Integer', iptrw);
    RegisterProperty('MarginLeft', 'Integer', iptrw);
    RegisterProperty('MarginTop', 'Integer', iptrw);
    RegisterProperty('MarginRight', 'Integer', iptrw);
    RegisterProperty('MarginBottom', 'Integer', iptrw);
    RegisterProperty('Options', 'TPageSetupDialogOptions', iptrw);
    RegisterProperty('PageWidth', 'Integer', iptrw);
    RegisterProperty('PageHeight', 'Integer', iptrw);
    RegisterProperty('Units', 'TPageMeasureUnits', iptrw);
    RegisterProperty('BeforePaint', 'TPageSetupBeforePaintEvent', iptrw);
    RegisterProperty('OnDrawFullPage', 'TPaintPageEvent', iptrw);
    RegisterProperty('OnDrawMinMargin', 'TPaintPageEvent', iptrw);
    RegisterProperty('OnDrawMargin', 'TPaintPageEvent', iptrw);
    RegisterProperty('OnDrawGreekText', 'TPaintPageEvent', iptrw);
    RegisterProperty('OnDrawEnvStamp', 'TPaintPageEvent', iptrw);
    RegisterProperty('OnDrawRetAddress', 'TPaintPageEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPrintDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialog', 'TPrintDialog') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TPrintDialog') do begin
    RegisterProperty('Collate', 'Boolean', iptrw);
    RegisterProperty('Copies', 'Integer', iptrw);
    RegisterProperty('FromPage', 'Integer', iptrw);
    RegisterProperty('MinPage', 'Integer', iptrw);
    RegisterProperty('MaxPage', 'Integer', iptrw);
    RegisterProperty('Options', 'TPrintDialogOptions', iptrw);
    RegisterProperty('PrintToFile', 'Boolean', iptrw);
    RegisterProperty('PrintRange', 'TPrintRange', iptrw);
    RegisterProperty('ToPage', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPrinterSetupDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialog', 'TPrinterSetupDialog') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TPrinterSetupDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFontDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialog', 'TFontDialog') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TFontDialog') do begin
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('Device', 'TFontDialogDevice', iptrw);
    RegisterProperty('MinFontSize', 'Integer', iptrw);
    RegisterProperty('MaxFontSize', 'Integer', iptrw);
    RegisterProperty('Options', 'TFontDialogOptions', iptrw);
    RegisterProperty('OnApply', 'TFDApplyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TColorDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialog', 'TColorDialog') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TColorDialog') do begin
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('CustomColors', 'TStrings', iptrw);
    RegisterProperty('Options', 'TColorDialogOptions', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSaveDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenDialog', 'TSaveDialog') do
  with CL.AddClassN(CL.FindClass('TOpenDialog'),'TSaveDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOpenDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialog', 'TOpenDialog') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TOpenDialog') do begin
    RegisterProperty('FileEditStyle', 'TFileEditStyle', iptrw);
    RegisterProperty('Files', 'TStrings', iptr);
    RegisterProperty('HistoryList', 'TStrings', iptrw);
    RegisterProperty('DefaultExt', 'string', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('Filter', 'string', iptrw);
    RegisterProperty('FilterIndex', 'Integer', iptrw);
    RegisterProperty('InitialDir', 'string', iptrw);
    RegisterProperty('Options', 'TOpenOptions', iptrw);
    RegisterProperty('OptionsEx', 'TOpenOptionsEx', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('OnCanClose', 'TCloseQueryEvent', iptrw);
    RegisterProperty('OnFolderChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnSelectionChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTypeChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnIncludeItem', 'TIncludeItemEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommonDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCommonDialog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCommonDialog') do begin
    RegisterPublishedProperties;
    RegisterMethod('Function Execute : Boolean;');
    RegisterMethod('Function Execute1( ParentWnd : HWND) : Boolean;');
    RegisterProperty('Handle', 'HWnd', iptr);
    RegisterProperty('Ctl3D', 'Boolean', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShow', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Dialogs(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxCustomColors','LongInt').SetInt( 16);
  SIRegister_TCommonDialog(CL);
  CL.AddTypeS('TOpenOption', '( ofReadOnly, ofOverwritePrompt, ofHideReadOnly, '
   +'ofNoChangeDir, ofShowHelp, ofNoValidate, ofAllowMultiSelect, ofExtensionDi'
   +'fferent, ofPathMustExist, ofFileMustExist, ofCreatePrompt, ofShareAware, o'
   +'fNoReadOnlyReturn, ofNoTestFileCreate, ofNoNetworkButton, ofNoLongNames, o'
   +'fOldStyleDialog, ofNoDereferenceLinks, ofEnableIncludeNotify, ofEnableSizi'
   +'ng, ofDontAddToRecent, ofForceShowHidden )');
  CL.AddTypeS('TOpenOptions', 'set of TOpenOption');
  CL.AddTypeS('TOpenOptionEx', '( ofExNoPlacesBar )');
  CL.AddTypeS('TOpenOptionsEx', 'set of TOpenOptionEx');
  CL.AddTypeS('TFileEditStyle', '( fsEdit, fsComboBox )');
  SIRegister_TOpenDialog(CL);
  SIRegister_TSaveDialog(CL);
  CL.AddTypeS('TColorDialogOption','(cdFullOpen, cdPreventFullOpen, cdShowHelp, cdSolidColor, cdAnyColor )');
  CL.AddTypeS('TColorDialogOptions', 'set of TColorDialogOption');
  SIRegister_TColorDialog(CL);
  CL.AddTypeS('TFontDialogOption', '( fdAnsiOnly, fdTrueTypeOnly, fdEffects, fd'
   +'FixedPitchOnly, fdForceFontExist, fdNoFaceSel, fdNoOEMFonts, fdNoSimulatio'
   +'ns, fdNoSizeSel, fdNoStyleSel, fdNoVectorFonts, fdShowHelp, fdWysiwyg, fdL'
   +'imitSize, fdScalableOnly, fdApplyButton )');
  CL.AddTypeS('TFontDialogOptions', 'set of TFontDialogOption');
  CL.AddTypeS('TFontDialogDevice', '( fdScreen, fdPrinter, fdBoth )');
  CL.AddTypeS('TFDApplyEvent', 'Procedure ( Sender : TObject; Wnd : HWND)');
  SIRegister_TFontDialog(CL);
  SIRegister_TPrinterSetupDialog(CL);
  CL.AddTypeS('TPrintRange', '( prAllPages, prSelection, prPageNums )');
  CL.AddTypeS('TPrintDialogOption', '( poPrintToFile, poPageNums, poSelection, '
   +'poWarning, poHelp, poDisablePrintToFile )');
  CL.AddTypeS('TPrintDialogOptions', 'set of TPrintDialogOption');
  SIRegister_TPrintDialog(CL);
  CL.AddTypeS('TPageSetupDialogOption', '( psoDefaultMinMargins, psoDisableMarg'
   +'ins, psoDisableOrientation, psoDisablePagePainting, psoDisablePaper, psoDi'
   +'sablePrinter, psoMargins, psoMinMargins, psoShowHelp, psoWarning, psoNoNetworkButton )');
  CL.AddTypeS('TPageSetupDialogOptions', 'set of TPageSetupDialogOption');
  CL.AddTypeS('TPrinterKind', '( pkDotMatrix, pkHPPCL )');
  CL.AddTypeS('TPageType', '( ptEnvelope, ptPaper )');
  CL.AddTypeS('TPageSetupBeforePaintEvent', 'Procedure ( Sender : TObject; cons'
   +'t PaperSize : SmallInt; const Orientation : TPrinterOrientation; const Pag'
   +'eType : TPageType; var DoneDrawing : Boolean)');
  CL.AddTypeS('TPageMeasureUnits', '( pmDefault, pmMillimeters, pmInches )');
  CL.AddTypeS('TPaintPageEvent', 'Procedure ( Sender : TObject; Canvas : TCanva'
   +'s; PageRect : TRect; var DoneDrawing : Boolean)');
  SIRegister_TPageSetupDialog(CL);
  CL.AddTypeS('TFindOption', '( frDown, frFindNext, frHideMatchCase, frHideWhol'
   +'eWord, frHideUpDown, frMatchCase, frDisableMatchCase, frDisableUpDown, frD'
   +'isableWholeWord, frReplace, frReplaceAll, frWholeWord, frShowHelp )');
  CL.AddTypeS('TFindOptions', 'set of TFindOption');
  SIRegister_TFindDialog(CL);
  SIRegister_TReplaceDialog(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPlatformVersionException');
  CL.AddTypeS('TFileDialogOption', '( fdoOverWritePrompt, fdoStrictFileTypes, f'
   +'doNoChangeDir, fdoPickFolders, fdoForceFileSystem, fdoAllNonStorageItems, '
   +'fdoNoValidate, fdoAllowMultiSelect, fdoPathMustExist, fdoFileMustExist, fd'
   +'oCreatePrompt, fdoShareAware, fdoNoReadOnlyReturn, fdoNoTestFileCreate, fd'
   +'oHideMRUPlaces, fdoHidePinnedPlaces, fdoNoDereferenceLinks, fdoDontAddToRe'
   +'cent, fdoForceShowHidden, fdoDefaultNoMiniMode, fdoForcePreviewPaneOn )');
  CL.AddTypeS('TFileDialogOptions', 'set of TFileDialogOption');
  SIRegister_TFileTypeItem(CL);
  SIRegister_TFileTypeItems(CL);
  SIRegister_TFavoriteLinkItem(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TFavoriteLinkItems');
  SIRegister_TFavoriteLinkItemsEnumerator(CL);
  SIRegister_TFavoriteLinkItems(CL);
  SIRegister_TCustomFileDialog(CL);
  SIRegister_TCustomFileOpenDialog(CL);
  SIRegister_TFileOpenDialog(CL);
  SIRegister_TCustomFileSaveDialog(CL);
  SIRegister_TFileSaveDialog(CL);
 CL.AddConstantN('tdiNone','LongInt').SetInt( 0);
 CL.AddConstantN('tdiWarning','LongInt').SetInt( 1);
 CL.AddConstantN('tdiError','LongInt').SetInt( 2);
 CL.AddConstantN('tdiInformation','LongInt').SetInt( 3);
 CL.AddConstantN('tdiShield','LongInt').SetInt( 4);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomTaskDialog');
  CL.AddTypeS('TTaskDialogFlag', '( tfEnableHyperlinks, tfUseHiconMain, tfUseHi'
   +'conFooter, tfAllowDialogCancellation, tfUseCommandLinks, tfUseCommandLinks'
   +'NoIcon, tfExpandFooterArea, tfExpandedByDefault, tfVerificationFlagChecked'
   +', tfShowProgressBar, tfShowMarqueeProgressBar, tfCallbackTimer, tfPosition'
   +'RelativeToWindow, tfRtlLayout, tfNoDefaultRadioButton, tfCanBeMinimized )');
  CL.AddTypeS('TTaskDialogFlags', 'set of TTaskDialogFlag');
  CL.AddTypeS('TTaskDialogCommonButton', '( tcbOk, tcbYes, tcbNo, tcbCancel, tcbRetry, tcbClose )');
  CL.AddTypeS('TTaskDialogCommonButtons', 'set of TTaskDialogCommonButton');
  CL.AddTypeS('TProgressBarState', '( pbsNormal, pbsError, pbsPaused )');
  SIRegister_TTaskDialogProgressBar(CL);
  SIRegister_TTaskDialogBaseButtonItem(CL);
  SIRegister_TTaskDialogButtonItem(CL);
  SIRegister_TTaskDialogRadioButtonItem(CL);
  //CL.AddTypeS('TTaskDialogButtonList', 'array of TTaskDialogButton');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTaskDialogButtons');
  SIRegister_TTaskDialogButtonsEnumerator(CL);
  SIRegister_TTaskDialogButtons(CL);
  CL.AddTypeS('TTaskDlgClickEvent', 'Procedure ( Sender : TObject; ModalResult '
   +': TModalResult; var CanClose : Boolean)');
  CL.AddTypeS('TTaskDlgTimerEvent', 'Procedure ( Sender : TObject; TickCount : '
   +'Cardinal; var Reset : Boolean)');
  SIRegister_TCustomTaskDialog(CL);
  SIRegister_TTaskDialog(CL);
//  CL.AddTypeS('TMsgDlgBtn', '( mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll,'+
  // 'mbYesToAll, mbHelp, mbAbortRetryIgnore )');
 //CL.AddConstantN('mbYesNo','LongInt').Value.ts32 := ord(mbYes) or ord(mbNo);
 //CL.AddConstantN('mbYesNoCancel','LongInt').Value.ts32 := ord(mbYes) or ord(mbNo) or ord(mbCancel);
 //CL.AddConstantN('mbYesAllNoAllCancel','LongInt').Value.ts32 := ord(mbYes) or ord(mbYesToAll) or ord(mbNo) or ord(mbNoToAll) or ord(mbCancel);
 //CL.AddConstantN('mbOKCancel','LongInt').Value.ts32 := ord(mbOK) or ord(mbCancel);
 //CL.AddConstantN('mbAbortRetryIgnore','LongInt').Value.ts32 := ord(mbAbort) or ord(mbRetry) or ord(mbIgnore);
 //CL.AddConstantN('mbAbortIgnore','LongInt').Value.ts32 := ord(mbAbort) or ord(mbIgnore);
 //CL.AddConstantN('mbYesNoCancel','LongInt').Value.ts32 := ord(mbYes) or ord(mbNo) or ord(mbCancel);

 // TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore,
   // mbAll, mbNoToAll, mbYesToAll, mbHelp);

  //CL.AddTypeS('mbYesNoCancel', 'LongInt.Value.ts32 := ord(mbYes) or ord(mbNo) or ord(mbCancel)');

  CL.AddTypeS('TMsgDlgType','( mtWarning, mtError, mtInformation, mtConfirmation, mtCustom )');
  //CL.AddTypeS('TMsgDlgBtn', '( mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll,'+
   //'mbYesToAll, mbHelp, mbYesNoCancel)'); {11}
  CL.AddTypeS('TMsgDlgBtn', '(mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll,'+
   'mbYesToAll,  mbhelp, mbYesNoCancel,  mbOKCancel, mbYesOkCancel, mbNoOkCancel, mbYesNoOkCancel, mbAbort)');
  //CL.AddTypeS('mbYesNoCancel', 'LongInt.Value.ts32 := ord(mbYes) or ord(mbNo) or ord(mbCancel)');


   //mbAbortRetryIgnore,mbYesNo,mbYesNoCancel,mbYesAllNoAllCancel,'+
   //'mbOKCancel,mbAbortIgnore)');
 CL.AddTypeS('TMsgDlgButtons', 'set of TMsgDlgBtn');
 //CL.AddConstantN('mbYesNo','LongInt').Value.ts32 := ord(mbYes) or ord(mbNo);
 //CL.AddConstantN('CmbYesNo','LongInt').SetSet('mbYes,mbNo');
 CL.AddConstantN('CmbYesNoCancel','LongInt').Value.ts32 := ord(mbYes) or ord(mbNo) or ord(mbCancel);
 //CL.AddTypeS('mbYesNoCancel', '(mbYes, mbNo, mbCancel)');

 CL.AddConstantN('mbYesAllNoAllCancel','LongInt').Value.ts32 := ord(mbYes) or ord(mbYesToAll) or ord(mbNo) or ord(mbNoToAll) or ord(mbCancel);
 //CL.AddConstantN('mbOKCancel','LongInt').Value.ts32 := ord(mbOK) or ord(mbCancel);
 CL.AddConstantN('mbAbortRetryIgnore','LongInt').Value.ts32 := ord(mbAbort) or ord(mbRetry) or ord(mbIgnore);
 CL.AddConstantN('mbAbortIgnore','LongInt').Value.ts32 := ord(mbAbort) or ord(mbIgnore);

 CL.AddDelphiFunction('Function CreateMessageDialog2( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgBtn) : TForm;');
 CL.AddDelphiFunction('Function CreateMessageDlg( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgBtn) : TForm;');

 CL.AddDelphiFunction('Function CreateMessageDialog( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : TForm;');
 CL.AddDelphiFunction('Function CreateMessageDialog1( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; DefaultButton : TMsgDlgBtn) : TForm;');
 CL.AddDelphiFunction('Function MessageDlg( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint) : Integer;');
 CL.AddDelphiFunction('Function MessageDlg1( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; DefaultButton : TMsgDlgBtn) : Integer;');
 CL.AddDelphiFunction('Function MessageDlgPos( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer) : Integer;');
 CL.AddDelphiFunction('Function MessageDlgPos1( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; DefaultButton : TMsgDlgBtn) : Integer;');
 CL.AddDelphiFunction('Function MessageDlgPosHelp( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string) : Integer;');
 CL.AddDelphiFunction('Function MessageDlgPosHelp1( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string; DefaultButton : TMsgDlgBtn) : Integer;');
 CL.AddDelphiFunction('Function TaskMessageDlg( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint) : Integer;');
 CL.AddDelphiFunction('Function TaskMessageDlg1( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; DefaultButton : TMsgDlgBtn) : Integer;');
 CL.AddDelphiFunction('Function TaskMessageDlgPos( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer) : Integer;');
 CL.AddDelphiFunction('Function TaskMessageDlgPos1( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; DefaultButton : TMsgDlgBtn) : Integer;');
 CL.AddDelphiFunction('Function TaskMessageDlgPosHelp( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string) : Integer;');
 CL.AddDelphiFunction('Function TaskMessageDlgPosHelp1( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string; DefaultButton : TMsgDlgBtn) : Integer;');
 CL.AddDelphiFunction('Procedure ShowMessage( const Msg : string)');
 CL.AddDelphiFunction('Procedure ShowMessageFmt( const Msg : string; Params : array of const)');
 CL.AddDelphiFunction('Procedure ShowMessagePos( const Msg : string; X, Y : Integer)');
 CL.AddDelphiFunction('Function InputBox( const ACaption, APrompt, ADefault : string) : string');
 CL.AddDelphiFunction('Function InputQuery( const ACaption, APrompt : string; var Value : string) : Boolean');
 CL.AddDelphiFunction('Function PromptForFileName( var AFileName : string; const AFilter : string; const ADefaultExt : string; const ATitle : string; const AInitialDir : string; SaveDialog : Boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TaskMessageDlgPosHelp1_P( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string; DefaultButton : TMsgDlgBtn) : Integer;
Begin Result := Dialogs.TaskMessageDlgPosHelp(Title, Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName, DefaultButton); END;

(*----------------------------------------------------------------------------*)
Function TaskMessageDlgPosHelp_P( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string) : Integer;
Begin Result := Dialogs.TaskMessageDlgPosHelp(Title, Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName); END;

(*----------------------------------------------------------------------------*)
Function TaskMessageDlgPos1_P( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; DefaultButton : TMsgDlgBtn) : Integer;
Begin Result := Dialogs.TaskMessageDlgPos(Title, Msg, DlgType, Buttons, HelpCtx, X, Y, DefaultButton); END;

(*----------------------------------------------------------------------------*)
Function TaskMessageDlgPos_P( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer) : Integer;
Begin Result := Dialogs.TaskMessageDlgPos(Title, Msg, DlgType, Buttons, HelpCtx, X, Y); END;

(*----------------------------------------------------------------------------*)
Function TaskMessageDlg1_P( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; DefaultButton : TMsgDlgBtn) : Integer;
Begin Result := Dialogs.TaskMessageDlg(Title, Msg, DlgType, Buttons, HelpCtx, DefaultButton); END;

(*----------------------------------------------------------------------------*)
Function TaskMessageDlg_P( const Title, Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint) : Integer;
Begin Result := Dialogs.TaskMessageDlg(Title, Msg, DlgType, Buttons, HelpCtx); END;

(*----------------------------------------------------------------------------*)
Function MessageDlgPosHelp1_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string; DefaultButton : TMsgDlgBtn) : Integer;
Begin Result := Dialogs.MessageDlgPosHelp(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName, DefaultButton); END;

(*----------------------------------------------------------------------------*)
Function MessageDlgPosHelp_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; const HelpFileName : string) : Integer;
Begin Result := Dialogs.MessageDlgPosHelp(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName); END;

(*----------------------------------------------------------------------------*)
Function MessageDlgPos1_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer; DefaultButton : TMsgDlgBtn) : Integer;
Begin Result := Dialogs.MessageDlgPos(Msg, DlgType, Buttons, HelpCtx, X, Y, DefaultButton); END;

(*----------------------------------------------------------------------------*)
Function MessageDlgPos_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; X, Y : Integer) : Integer;
Begin Result := Dialogs.MessageDlgPos(Msg, DlgType, Buttons, HelpCtx, X, Y); END;

(*----------------------------------------------------------------------------*)
Function MessageDlg1_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint; DefaultButton : TMsgDlgBtn) : Integer;
Begin Result := Dialogs.MessageDlg(Msg, DlgType, Buttons, HelpCtx, DefaultButton); END;

(*----------------------------------------------------------------------------*)
Function MessageDlg_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpCtx : Longint) : Integer;
Begin Result := Dialogs.MessageDlg(Msg, DlgType, Buttons, HelpCtx); END;

(*----------------------------------------------------------------------------*)
Function CreateMessageDialog1_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; DefaultButton : TMsgDlgBtn) : TForm;
Begin Result := Dialogs.CreateMessageDialog(Msg, DlgType, Buttons, DefaultButton); END;

(*----------------------------------------------------------------------------*)
Function CreateMessageDialog_P( const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons) : TForm;
Begin Result := Dialogs.CreateMessageDialog(Msg, DlgType, Buttons); END;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnVerificationClicked_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnVerificationClicked := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnVerificationClicked_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnVerificationClicked; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnTimer_W(Self: TCustomTaskDialog; const T: TTaskDlgTimerEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnTimer_R(Self: TCustomTaskDialog; var T: TTaskDlgTimerEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnRadioButtonClicked_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnRadioButtonClicked := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnRadioButtonClicked_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnRadioButtonClicked; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnNavigated_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnNavigated := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnNavigated_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnNavigated; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnHyperlinkClicked_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnHyperlinkClicked := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnHyperlinkClicked_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnHyperlinkClicked; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnExpanded_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnExpanded := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnExpanded_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnExpanded; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnDialogDestroyed_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnDialogDestroyed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnDialogDestroyed_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnDialogDestroyed; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnDialogCreated_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnDialogCreated := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnDialogCreated_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnDialogCreated; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnDialogConstructed_W(Self: TCustomTaskDialog; const T: TNotifyEvent);
begin Self.OnDialogConstructed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnDialogConstructed_R(Self: TCustomTaskDialog; var T: TNotifyEvent);
begin T := Self.OnDialogConstructed; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnButtonClicked_W(Self: TCustomTaskDialog; const T: TTaskDlgClickEvent);
begin Self.OnButtonClicked := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogOnButtonClicked_R(Self: TCustomTaskDialog; var T: TTaskDlgClickEvent);
begin T := Self.OnButtonClicked; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogVerificationText_W(Self: TCustomTaskDialog; const T: string);
begin Self.VerificationText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogVerificationText_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.VerificationText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogURL_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogTitle_W(Self: TCustomTaskDialog; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogTitle_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogText_W(Self: TCustomTaskDialog; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogText_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogRadioButtons_W(Self: TCustomTaskDialog; const T: TTaskDialogButtons);
begin Self.RadioButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogRadioButtons_R(Self: TCustomTaskDialog; var T: TTaskDialogButtons);
begin T := Self.RadioButtons; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogRadioButton_R(Self: TCustomTaskDialog; var T: TTaskDialogRadioButtonItem);
begin T := Self.RadioButton; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogProgressBar_W(Self: TCustomTaskDialog; const T: TTaskDialogProgressBar);
begin Self.ProgressBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogProgressBar_R(Self: TCustomTaskDialog; var T: TTaskDialogProgressBar);
begin T := Self.ProgressBar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogModalResult_W(Self: TCustomTaskDialog; const T: TModalResult);
begin Self.ModalResult := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogModalResult_R(Self: TCustomTaskDialog; var T: TModalResult);
begin T := Self.ModalResult; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogMainIcon_W(Self: TCustomTaskDialog; const T: TTaskDialogIcon);
begin Self.MainIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogMainIcon_R(Self: TCustomTaskDialog; var T: TTaskDialogIcon);
begin T := Self.MainIcon; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogHelpContext_W(Self: TCustomTaskDialog; const T: Integer);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogHelpContext_R(Self: TCustomTaskDialog; var T: Integer);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogHandle_R(Self: TCustomTaskDialog; var T: HWND);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogFooterText_W(Self: TCustomTaskDialog; const T: string);
begin Self.FooterText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogFooterText_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.FooterText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogFooterIcon_W(Self: TCustomTaskDialog; const T: TTaskDialogIcon);
begin Self.FooterIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogFooterIcon_R(Self: TCustomTaskDialog; var T: TTaskDialogIcon);
begin T := Self.FooterIcon; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogFlags_W(Self: TCustomTaskDialog; const T: TTaskDialogFlags);
begin Self.Flags := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogFlags_R(Self: TCustomTaskDialog; var T: TTaskDialogFlags);
begin T := Self.Flags; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogExpandedText_W(Self: TCustomTaskDialog; const T: string);
begin Self.ExpandedText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogExpandedText_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.ExpandedText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogExpanded_R(Self: TCustomTaskDialog; var T: Boolean);
begin T := Self.Expanded; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogExpandButtonCaption_W(Self: TCustomTaskDialog; const T: string);
begin Self.ExpandButtonCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogExpandButtonCaption_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.ExpandButtonCaption; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogDefaultButton_W(Self: TCustomTaskDialog; const T: TTaskDialogCommonButton);
begin Self.DefaultButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogDefaultButton_R(Self: TCustomTaskDialog; var T: TTaskDialogCommonButton);
begin T := Self.DefaultButton; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCustomMainIcon_W(Self: TCustomTaskDialog; const T: TIcon);
begin Self.CustomMainIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCustomMainIcon_R(Self: TCustomTaskDialog; var T: TIcon);
begin T := Self.CustomMainIcon; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCustomFooterIcon_W(Self: TCustomTaskDialog; const T: TIcon);
begin Self.CustomFooterIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCustomFooterIcon_R(Self: TCustomTaskDialog; var T: TIcon);
begin T := Self.CustomFooterIcon; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCommonButtons_W(Self: TCustomTaskDialog; const T: TTaskDialogCommonButtons);
begin Self.CommonButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCommonButtons_R(Self: TCustomTaskDialog; var T: TTaskDialogCommonButtons);
begin T := Self.CommonButtons; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCaption_W(Self: TCustomTaskDialog; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogCaption_R(Self: TCustomTaskDialog; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogButtons_W(Self: TCustomTaskDialog; const T: TTaskDialogButtons);
begin Self.Buttons := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogButtons_R(Self: TCustomTaskDialog; var T: TTaskDialogButtons);
begin T := Self.Buttons; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogButton_W(Self: TCustomTaskDialog; const T: TTaskDialogButtonItem);
begin Self.Button := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTaskDialogButton_R(Self: TCustomTaskDialog; var T: TTaskDialogButtonItem);
begin T := Self.Button; end;

(*----------------------------------------------------------------------------*)
Function TCustomTaskDialogExecute1_P(Self: TCustomTaskDialog;  ParentWnd : HWND) : Boolean;
Begin Result := Self.Execute(ParentWnd); END;

(*----------------------------------------------------------------------------*)
Function TCustomTaskDialogExecute_P(Self: TCustomTaskDialog) : Boolean;
Begin Result := Self.Execute; END;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonsItems_W(Self: TTaskDialogButtons; const T: TTaskDialogBaseButtonItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonsItems_R(Self: TTaskDialogButtons; var T: TTaskDialogBaseButtonItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonsDefaultButton_W(Self: TTaskDialogButtons; const T: TTaskDialogBaseButtonItem);
begin Self.DefaultButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonsDefaultButton_R(Self: TTaskDialogButtons; var T: TTaskDialogBaseButtonItem);
begin T := Self.DefaultButton; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonsEnumeratorCurrent_R(Self: TTaskDialogButtonsEnumerator; var T: TTaskDialogBaseButtonItem);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonItemElevationRequired_W(Self: TTaskDialogButtonItem; const T: Boolean);
begin Self.ElevationRequired := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonItemElevationRequired_R(Self: TTaskDialogButtonItem; var T: Boolean);
begin T := Self.ElevationRequired; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonItemCommandLinkHint_W(Self: TTaskDialogButtonItem; const T: string);
begin Self.CommandLinkHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogButtonItemCommandLinkHint_R(Self: TTaskDialogButtonItem; var T: string);
begin T := Self.CommandLinkHint; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemEnabled_W(Self: TTaskDialogBaseButtonItem; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemEnabled_R(Self: TTaskDialogBaseButtonItem; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemDefault_W(Self: TTaskDialogBaseButtonItem; const T: Boolean);
begin Self.Default := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemDefault_R(Self: TTaskDialogBaseButtonItem; var T: Boolean);
begin T := Self.Default; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemCaption_W(Self: TTaskDialogBaseButtonItem; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemCaption_R(Self: TTaskDialogBaseButtonItem; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemTextWStr_R(Self: TTaskDialogBaseButtonItem; var T: LPCWSTR);
begin T := Self.TextWStr; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemModalResult_W(Self: TTaskDialogBaseButtonItem; const T: TModalResult);
begin Self.ModalResult := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogBaseButtonItemModalResult_R(Self: TTaskDialogBaseButtonItem; var T: TModalResult);
begin T := Self.ModalResult; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarState_W(Self: TTaskDialogProgressBar; const T: TProgressBarState);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarState_R(Self: TTaskDialogProgressBar; var T: TProgressBarState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarPosition_W(Self: TTaskDialogProgressBar; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarPosition_R(Self: TTaskDialogProgressBar; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarMin_W(Self: TTaskDialogProgressBar; const T: Integer);
begin Self.Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarMin_R(Self: TTaskDialogProgressBar; var T: Integer);
begin T := Self.Min; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarMax_W(Self: TTaskDialogProgressBar; const T: Integer);
begin Self.Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarMax_R(Self: TTaskDialogProgressBar; var T: Integer);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarMarqueeSpeed_W(Self: TTaskDialogProgressBar; const T: Cardinal);
begin Self.MarqueeSpeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDialogProgressBarMarqueeSpeed_R(Self: TTaskDialogProgressBar; var T: Cardinal);
begin T := Self.MarqueeSpeed; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnTypeChange_W(Self: TCustomFileDialog; const T: TNotifyEvent);
begin Self.OnTypeChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnTypeChange_R(Self: TCustomFileDialog; var T: TNotifyEvent);
begin T := Self.OnTypeChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnShareViolation_W(Self: TCustomFileDialog; const T: TFileDialogShareViolationEvent);
begin Self.OnShareViolation := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnShareViolation_R(Self: TCustomFileDialog; var T: TFileDialogShareViolationEvent);
begin T := Self.OnShareViolation; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnSelectionChange_W(Self: TCustomFileDialog; const T: TNotifyEvent);
begin Self.OnSelectionChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnSelectionChange_R(Self: TCustomFileDialog; var T: TNotifyEvent);
begin T := Self.OnSelectionChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnOverwrite_W(Self: TCustomFileDialog; const T: TFileDialogOverwriteEvent);
begin Self.OnOverwrite := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnOverwrite_R(Self: TCustomFileDialog; var T: TFileDialogOverwriteEvent);
begin T := Self.OnOverwrite; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnFolderChanging_W(Self: TCustomFileDialog; const T: TFileDialogFolderChangingEvent);
begin Self.OnFolderChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnFolderChanging_R(Self: TCustomFileDialog; var T: TFileDialogFolderChangingEvent);
begin T := Self.OnFolderChanging; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnFolderChange_W(Self: TCustomFileDialog; const T: TNotifyEvent);
begin Self.OnFolderChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnFolderChange_R(Self: TCustomFileDialog; var T: TNotifyEvent);
begin T := Self.OnFolderChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnFileOkClick_W(Self: TCustomFileDialog; const T: TFileDialogCloseEvent);
begin Self.OnFileOkClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnFileOkClick_R(Self: TCustomFileDialog; var T: TFileDialogCloseEvent);
begin T := Self.OnFileOkClick; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnExecute_W(Self: TCustomFileDialog; const T: TNotifyEvent);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOnExecute_R(Self: TCustomFileDialog; var T: TNotifyEvent);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogTitle_W(Self: TCustomFileDialog; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogTitle_R(Self: TCustomFileDialog; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogShellItems_R(Self: TCustomFileDialog; var T: IShellItemArray);
begin T := Self.ShellItems; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogShellItem_R(Self: TCustomFileDialog; var T: IShellItem);
begin T := Self.ShellItem; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOptions_W(Self: TCustomFileDialog; const T: TFileDialogOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOptions_R(Self: TCustomFileDialog; var T: TFileDialogOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOkButtonLabel_W(Self: TCustomFileDialog; const T: string);
begin Self.OkButtonLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogOkButtonLabel_R(Self: TCustomFileDialog; var T: string);
begin T := Self.OkButtonLabel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogHandle_R(Self: TCustomFileDialog; var T: HWnd);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileTypeIndex_W(Self: TCustomFileDialog; const T: Cardinal);
begin Self.FileTypeIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileTypeIndex_R(Self: TCustomFileDialog; var T: Cardinal);
begin T := Self.FileTypeIndex; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileTypes_W(Self: TCustomFileDialog; const T: TFileTypeItems);
begin Self.FileTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileTypes_R(Self: TCustomFileDialog; var T: TFileTypeItems);
begin T := Self.FileTypes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFiles_R(Self: TCustomFileDialog; var T: TStrings);
begin T := Self.Files; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileNameLabel_W(Self: TCustomFileDialog; const T: string);
begin Self.FileNameLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileNameLabel_R(Self: TCustomFileDialog; var T: string);
begin T := Self.FileNameLabel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileName_W(Self: TCustomFileDialog; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFileName_R(Self: TCustomFileDialog; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFavoriteLinks_W(Self: TCustomFileDialog; const T: TFavoriteLinkItems);
begin Self.FavoriteLinks := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogFavoriteLinks_R(Self: TCustomFileDialog; var T: TFavoriteLinkItems);
begin T := Self.FavoriteLinks; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogDialog_R(Self: TCustomFileDialog; var T: IFileDialog);
begin T := Self.Dialog; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogDefaultFolder_W(Self: TCustomFileDialog; const T: string);
begin Self.DefaultFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogDefaultFolder_R(Self: TCustomFileDialog; var T: string);
begin T := Self.DefaultFolder; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogDefaultExtension_W(Self: TCustomFileDialog; const T: string);
begin Self.DefaultExtension := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogDefaultExtension_R(Self: TCustomFileDialog; var T: string);
begin T := Self.DefaultExtension; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogClientGuid_W(Self: TCustomFileDialog; const T: string);
begin Self.ClientGuid := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileDialogClientGuid_R(Self: TCustomFileDialog; var T: string);
begin T := Self.ClientGuid; end;

(*----------------------------------------------------------------------------*)
Function TCustomFileDialogExecute1_P(Self: TCustomFileDialog;  ParentWnd : HWND) : Boolean;
Begin Result := Self.Execute(ParentWnd); END;

(*----------------------------------------------------------------------------*)
Function TCustomFileDialogExecute_P(Self: TCustomFileDialog) : Boolean;
Begin Result := Self.Execute; END;

(*----------------------------------------------------------------------------*)
procedure TFavoriteLinkItemsItems_W(Self: TFavoriteLinkItems; const T: TFavoriteLinkItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TFavoriteLinkItemsItems_R(Self: TFavoriteLinkItems; var T: TFavoriteLinkItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFavoriteLinkItemsEnumeratorCurrent_R(Self: TFavoriteLinkItemsEnumerator; var T: TFavoriteLinkItem);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TFavoriteLinkItemLocation_W(Self: TFavoriteLinkItem; const T: string);
begin Self.Location := T; end;

(*----------------------------------------------------------------------------*)
procedure TFavoriteLinkItemLocation_R(Self: TFavoriteLinkItem; var T: string);
begin T := Self.Location; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemsItems_W(Self: TFileTypeItems; const T: TFileTypeItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemsItems_R(Self: TFileTypeItems; var T: TFileTypeItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemFileMask_W(Self: TFileTypeItem; const T: string);
begin Self.FileMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemFileMask_R(Self: TFileTypeItem; var T: string);
begin T := Self.FileMask; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemDisplayName_W(Self: TFileTypeItem; const T: string);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemDisplayName_R(Self: TFileTypeItem; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemFileMaskWStr_R(Self: TFileTypeItem; var T: LPCWSTR);
begin T := Self.FileMaskWStr; end;

(*----------------------------------------------------------------------------*)
procedure TFileTypeItemDisplayNameWStr_R(Self: TFileTypeItem; var T: LPCWSTR);
begin T := Self.DisplayNameWStr; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogOnFind_W(Self: TFindDialog; const T: TNotifyEvent);
begin Self.OnFind := T; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogOnFind_R(Self: TFindDialog; var T: TNotifyEvent);
begin T := Self.OnFind; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogOptions_W(Self: TFindDialog; const T: TFindOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogOptions_R(Self: TFindDialog; var T: TFindOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogFindText_W(Self: TFindDialog; const T: string);
begin Self.FindText := T; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogFindText_R(Self: TFindDialog; var T: string);
begin T := Self.FindText; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogTop_W(Self: TFindDialog; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogTop_R(Self: TFindDialog; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogPosition_W(Self: TFindDialog; const T: TPoint);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogPosition_R(Self: TFindDialog; var T: TPoint);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogLeft_W(Self: TFindDialog; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TFindDialogLeft_R(Self: TFindDialog; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawRetAddress_W(Self: TPageSetupDialog; const T: TPaintPageEvent);
begin Self.OnDrawRetAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawRetAddress_R(Self: TPageSetupDialog; var T: TPaintPageEvent);
begin T := Self.OnDrawRetAddress; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawEnvStamp_W(Self: TPageSetupDialog; const T: TPaintPageEvent);
begin Self.OnDrawEnvStamp := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawEnvStamp_R(Self: TPageSetupDialog; var T: TPaintPageEvent);
begin T := Self.OnDrawEnvStamp; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawGreekText_W(Self: TPageSetupDialog; const T: TPaintPageEvent);
begin Self.OnDrawGreekText := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawGreekText_R(Self: TPageSetupDialog; var T: TPaintPageEvent);
begin T := Self.OnDrawGreekText; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawMargin_W(Self: TPageSetupDialog; const T: TPaintPageEvent);
begin Self.OnDrawMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawMargin_R(Self: TPageSetupDialog; var T: TPaintPageEvent);
begin T := Self.OnDrawMargin; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawMinMargin_W(Self: TPageSetupDialog; const T: TPaintPageEvent);
begin Self.OnDrawMinMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawMinMargin_R(Self: TPageSetupDialog; var T: TPaintPageEvent);
begin T := Self.OnDrawMinMargin; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawFullPage_W(Self: TPageSetupDialog; const T: TPaintPageEvent);
begin Self.OnDrawFullPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOnDrawFullPage_R(Self: TPageSetupDialog; var T: TPaintPageEvent);
begin T := Self.OnDrawFullPage; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogBeforePaint_W(Self: TPageSetupDialog; const T: TPageSetupBeforePaintEvent);
begin Self.BeforePaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogBeforePaint_R(Self: TPageSetupDialog; var T: TPageSetupBeforePaintEvent);
begin T := Self.BeforePaint; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogUnits_W(Self: TPageSetupDialog; const T: TPageMeasureUnits);
begin Self.Units := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogUnits_R(Self: TPageSetupDialog; var T: TPageMeasureUnits);
begin T := Self.Units; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogPageHeight_W(Self: TPageSetupDialog; const T: Integer);
begin Self.PageHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogPageHeight_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.PageHeight; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogPageWidth_W(Self: TPageSetupDialog; const T: Integer);
begin Self.PageWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogPageWidth_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.PageWidth; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOptions_W(Self: TPageSetupDialog; const T: TPageSetupDialogOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogOptions_R(Self: TPageSetupDialog; var T: TPageSetupDialogOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginBottom_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MarginBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginBottom_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginRight_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MarginRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginRight_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginTop_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MarginTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginTop_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginLeft_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MarginLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMarginLeft_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginBottom_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MinMarginBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginBottom_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MinMarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginRight_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MinMarginRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginRight_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MinMarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginTop_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MinMarginTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginTop_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MinMarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginLeft_W(Self: TPageSetupDialog; const T: Integer);
begin Self.MinMarginLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogMinMarginLeft_R(Self: TPageSetupDialog; var T: Integer);
begin T := Self.MinMarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TPageSetupDialogPageSetupDlgRec_R(Self: TPageSetupDialog; var T: TPageSetupDlg);
begin T := Self.PageSetupDlgRec; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogToPage_W(Self: TPrintDialog; const T: Integer);
begin Self.ToPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogToPage_R(Self: TPrintDialog; var T: Integer);
begin T := Self.ToPage; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogPrintRange_W(Self: TPrintDialog; const T: TPrintRange);
begin Self.PrintRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogPrintRange_R(Self: TPrintDialog; var T: TPrintRange);
begin T := Self.PrintRange; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogPrintToFile_W(Self: TPrintDialog; const T: Boolean);
begin Self.PrintToFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogPrintToFile_R(Self: TPrintDialog; var T: Boolean);
begin T := Self.PrintToFile; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogOptions_W(Self: TPrintDialog; const T: TPrintDialogOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogOptions_R(Self: TPrintDialog; var T: TPrintDialogOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogMaxPage_W(Self: TPrintDialog; const T: Integer);
begin Self.MaxPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogMaxPage_R(Self: TPrintDialog; var T: Integer);
begin T := Self.MaxPage; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogMinPage_W(Self: TPrintDialog; const T: Integer);
begin Self.MinPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogMinPage_R(Self: TPrintDialog; var T: Integer);
begin T := Self.MinPage; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogFromPage_W(Self: TPrintDialog; const T: Integer);
begin Self.FromPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogFromPage_R(Self: TPrintDialog; var T: Integer);
begin T := Self.FromPage; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogCopies_W(Self: TPrintDialog; const T: Integer);
begin Self.Copies := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogCopies_R(Self: TPrintDialog; var T: Integer);
begin T := Self.Copies; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogCollate_W(Self: TPrintDialog; const T: Boolean);
begin Self.Collate := T; end;

(*----------------------------------------------------------------------------*)
procedure TPrintDialogCollate_R(Self: TPrintDialog; var T: Boolean);
begin T := Self.Collate; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogOnApply_W(Self: TFontDialog; const T: TFDApplyEvent);
begin Self.OnApply := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogOnApply_R(Self: TFontDialog; var T: TFDApplyEvent);
begin T := Self.OnApply; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogOptions_W(Self: TFontDialog; const T: TFontDialogOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogOptions_R(Self: TFontDialog; var T: TFontDialogOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogMaxFontSize_W(Self: TFontDialog; const T: Integer);
begin Self.MaxFontSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogMaxFontSize_R(Self: TFontDialog; var T: Integer);
begin T := Self.MaxFontSize; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogMinFontSize_W(Self: TFontDialog; const T: Integer);
begin Self.MinFontSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogMinFontSize_R(Self: TFontDialog; var T: Integer);
begin T := Self.MinFontSize; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogDevice_W(Self: TFontDialog; const T: TFontDialogDevice);
begin Self.Device := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogDevice_R(Self: TFontDialog; var T: TFontDialogDevice);
begin T := Self.Device; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogFont_W(Self: TFontDialog; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontDialogFont_R(Self: TFontDialog; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TColorDialogOptions_W(Self: TColorDialog; const T: TColorDialogOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorDialogOptions_R(Self: TColorDialog; var T: TColorDialogOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TColorDialogCustomColors_W(Self: TColorDialog; const T: TStrings);
begin Self.CustomColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorDialogCustomColors_R(Self: TColorDialog; var T: TStrings);
begin T := Self.CustomColors; end;

(*----------------------------------------------------------------------------*)
procedure TColorDialogColor_W(Self: TColorDialog; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorDialogColor_R(Self: TColorDialog; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnIncludeItem_W(Self: TOpenDialog; const T: TIncludeItemEvent);
begin Self.OnIncludeItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnIncludeItem_R(Self: TOpenDialog; var T: TIncludeItemEvent);
begin T := Self.OnIncludeItem; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnTypeChange_W(Self: TOpenDialog; const T: TNotifyEvent);
begin Self.OnTypeChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnTypeChange_R(Self: TOpenDialog; var T: TNotifyEvent);
begin T := Self.OnTypeChange; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnSelectionChange_W(Self: TOpenDialog; const T: TNotifyEvent);
begin Self.OnSelectionChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnSelectionChange_R(Self: TOpenDialog; var T: TNotifyEvent);
begin T := Self.OnSelectionChange; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnFolderChange_W(Self: TOpenDialog; const T: TNotifyEvent);
begin Self.OnFolderChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnFolderChange_R(Self: TOpenDialog; var T: TNotifyEvent);
begin T := Self.OnFolderChange; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnCanClose_W(Self: TOpenDialog; const T: TCloseQueryEvent);
begin Self.OnCanClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOnCanClose_R(Self: TOpenDialog; var T: TCloseQueryEvent);
begin T := Self.OnCanClose; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogTitle_W(Self: TOpenDialog; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogTitle_R(Self: TOpenDialog; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOptionsEx_W(Self: TOpenDialog; const T: TOpenOptionsEx);
begin Self.OptionsEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOptionsEx_R(Self: TOpenDialog; var T: TOpenOptionsEx);
begin T := Self.OptionsEx; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOptions_W(Self: TOpenDialog; const T: TOpenOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogOptions_R(Self: TOpenDialog; var T: TOpenOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogInitialDir_W(Self: TOpenDialog; const T: string);
begin Self.InitialDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogInitialDir_R(Self: TOpenDialog; var T: string);
begin T := Self.InitialDir; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFilterIndex_W(Self: TOpenDialog; const T: Integer);
begin Self.FilterIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFilterIndex_R(Self: TOpenDialog; var T: Integer);
begin T := Self.FilterIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFilter_W(Self: TOpenDialog; const T: string);
begin Self.Filter := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFilter_R(Self: TOpenDialog; var T: string);
begin T := Self.Filter; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFileName_W(Self: TOpenDialog; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFileName_R(Self: TOpenDialog; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogDefaultExt_W(Self: TOpenDialog; const T: string);
begin Self.DefaultExt := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogDefaultExt_R(Self: TOpenDialog; var T: string);
begin T := Self.DefaultExt; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogHistoryList_W(Self: TOpenDialog; const T: TStrings);
begin Self.HistoryList := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogHistoryList_R(Self: TOpenDialog; var T: TStrings);
begin T := Self.HistoryList; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFiles_R(Self: TOpenDialog; var T: TStrings);
begin T := Self.Files; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFileEditStyle_W(Self: TOpenDialog; const T: TFileEditStyle);
begin Self.FileEditStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenDialogFileEditStyle_R(Self: TOpenDialog; var T: TFileEditStyle);
begin T := Self.FileEditStyle; end;

(*----------------------------------------------------------------------------*)
Function TOpenDialogDoExecute1_P(Self: TOpenDialog;  Func : Pointer; ParentWnd : HWND) : Bool;
Begin //Result := Self.DoExecute(Func, ParentWnd);
 END;

(*----------------------------------------------------------------------------*)
Function TOpenDialogDoExecute_P(Self: TOpenDialog;  Func : Pointer) : Bool;
Begin //Result := Self.DoExecute(Func);
 END;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogOnShow_W(Self: TCommonDialog; const T: TNotifyEvent);
begin Self.OnShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogOnShow_R(Self: TCommonDialog; var T: TNotifyEvent);
begin T := Self.OnShow; end;

procedure TCommonDialogOnClick_W(Self: TCommonDialog; const T: TNOTIFYEVENT);
begin //Self.ONCLICK := T;
 end;

procedure TCommonDialogonClick_R(Self: TCommonDialog; var T: TNOTIFYEVENT);
begin //T := Self.ONCLICK;
 end;


(*----------------------------------------------------------------------------*)
procedure TCommonDialogOnClose_W(Self: TCommonDialog; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogOnClose_R(Self: TCommonDialog; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogHelpContext_W(Self: TCommonDialog; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogHelpContext_R(Self: TCommonDialog; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogCtl3D_W(Self: TCommonDialog; const T: Boolean);
begin Self.Ctl3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogCtl3D_R(Self: TCommonDialog; var T: Boolean);
begin T := Self.Ctl3D; end;

(*----------------------------------------------------------------------------*)
procedure TCommonDialogHandle_R(Self: TCommonDialog; var T: HWnd);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
Function TCommonDialogExecute1_P(Self: TCommonDialog;  ParentWnd : HWND) : Boolean;
Begin Result := Self.Execute(ParentWnd); END;

(*----------------------------------------------------------------------------*)
Function TCommonDialogExecute_P(Self: TCommonDialog) : Boolean;
Begin Result := Self.Execute; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Dialogs_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@myCreateMessageDialog, 'CreateMessageDlg', cdRegister);
 S.RegisterDelphiFunction(@CreateMessageDialog_P, 'CreateMessageDlg', cdRegister);
 S.RegisterDelphiFunction(@CreateMessageDialog_P, 'CreateMessageDialog', cdRegister);
 S.RegisterDelphiFunction(@CreateMessageDialog_P, 'CreateMessageDialog2', cdRegister);
 S.RegisterDelphiFunction(@CreateMessageDialog1_P, 'CreateMessageDialog1', cdRegister);
 S.RegisterDelphiFunction(@MessageDlg_P, 'MessageDlg', cdRegister);
 S.RegisterDelphiFunction(@MessageDlg1_P, 'MessageDlg1', cdRegister);
 S.RegisterDelphiFunction(@MessageDlgPos_P, 'MessageDlgPos', cdRegister);
 S.RegisterDelphiFunction(@MessageDlgPos1_P, 'MessageDlgPos1', cdRegister);
 S.RegisterDelphiFunction(@MessageDlgPosHelp_P, 'MessageDlgPosHelp', cdRegister);
 S.RegisterDelphiFunction(@MessageDlgPosHelp1_P, 'MessageDlgPosHelp1', cdRegister);
 S.RegisterDelphiFunction(@TaskMessageDlg_P, 'TaskMessageDlg', cdRegister);
 S.RegisterDelphiFunction(@TaskMessageDlg1_P, 'TaskMessageDlg1', cdRegister);
 S.RegisterDelphiFunction(@TaskMessageDlgPos_P, 'TaskMessageDlgPos', cdRegister);
 S.RegisterDelphiFunction(@TaskMessageDlgPos1_P, 'TaskMessageDlgPos1', cdRegister);
 S.RegisterDelphiFunction(@TaskMessageDlgPosHelp_P, 'TaskMessageDlgPosHelp', cdRegister);
 S.RegisterDelphiFunction(@TaskMessageDlgPosHelp1_P, 'TaskMessageDlgPosHelp1', cdRegister);
 S.RegisterDelphiFunction(@ShowMessage, 'ShowMessage', cdRegister);
 S.RegisterDelphiFunction(@ShowMessageFmt, 'ShowMessageFmt', cdRegister);
 S.RegisterDelphiFunction(@ShowMessagePos, 'ShowMessagePos', cdRegister);
 S.RegisterDelphiFunction(@InputBox, 'InputBox', cdRegister);
 S.RegisterDelphiFunction(@InputQuery, 'InputQuery', cdRegister);
 S.RegisterDelphiFunction(@PromptForFileName, 'PromptForFileName', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTaskDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTaskDialog) do begin
    RegisterMethod(@TCustomTaskDialog.Execute, 'Execute');
    RegisterMethod(@TCustomTaskDialogExecute1_P, 'Execute1');
    RegisterPropertyHelper(@TCustomTaskDialogButton_R,@TCustomTaskDialogButton_W,'Button');
    RegisterPropertyHelper(@TCustomTaskDialogButtons_R,@TCustomTaskDialogButtons_W,'Buttons');
    RegisterPropertyHelper(@TCustomTaskDialogCaption_R,@TCustomTaskDialogCaption_W,'Caption');
    RegisterPropertyHelper(@TCustomTaskDialogCommonButtons_R,@TCustomTaskDialogCommonButtons_W,'CommonButtons');
    RegisterPropertyHelper(@TCustomTaskDialogCustomFooterIcon_R,@TCustomTaskDialogCustomFooterIcon_W,'CustomFooterIcon');
    RegisterPropertyHelper(@TCustomTaskDialogCustomMainIcon_R,@TCustomTaskDialogCustomMainIcon_W,'CustomMainIcon');
    RegisterPropertyHelper(@TCustomTaskDialogDefaultButton_R,@TCustomTaskDialogDefaultButton_W,'DefaultButton');
    RegisterPropertyHelper(@TCustomTaskDialogExpandButtonCaption_R,@TCustomTaskDialogExpandButtonCaption_W,'ExpandButtonCaption');
    RegisterPropertyHelper(@TCustomTaskDialogExpanded_R,nil,'Expanded');
    RegisterPropertyHelper(@TCustomTaskDialogExpandedText_R,@TCustomTaskDialogExpandedText_W,'ExpandedText');
    RegisterPropertyHelper(@TCustomTaskDialogFlags_R,@TCustomTaskDialogFlags_W,'Flags');
    RegisterPropertyHelper(@TCustomTaskDialogFooterIcon_R,@TCustomTaskDialogFooterIcon_W,'FooterIcon');
    RegisterPropertyHelper(@TCustomTaskDialogFooterText_R,@TCustomTaskDialogFooterText_W,'FooterText');
    RegisterPropertyHelper(@TCustomTaskDialogHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TCustomTaskDialogHelpContext_R,@TCustomTaskDialogHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TCustomTaskDialogMainIcon_R,@TCustomTaskDialogMainIcon_W,'MainIcon');
    RegisterPropertyHelper(@TCustomTaskDialogModalResult_R,@TCustomTaskDialogModalResult_W,'ModalResult');
    RegisterPropertyHelper(@TCustomTaskDialogProgressBar_R,@TCustomTaskDialogProgressBar_W,'ProgressBar');
    RegisterPropertyHelper(@TCustomTaskDialogRadioButton_R,nil,'RadioButton');
    RegisterPropertyHelper(@TCustomTaskDialogRadioButtons_R,@TCustomTaskDialogRadioButtons_W,'RadioButtons');
    RegisterPropertyHelper(@TCustomTaskDialogText_R,@TCustomTaskDialogText_W,'Text');
    RegisterPropertyHelper(@TCustomTaskDialogTitle_R,@TCustomTaskDialogTitle_W,'Title');
    RegisterPropertyHelper(@TCustomTaskDialogURL_R,nil,'URL');
    RegisterPropertyHelper(@TCustomTaskDialogVerificationText_R,@TCustomTaskDialogVerificationText_W,'VerificationText');
    RegisterPropertyHelper(@TCustomTaskDialogOnButtonClicked_R,@TCustomTaskDialogOnButtonClicked_W,'OnButtonClicked');
    RegisterPropertyHelper(@TCustomTaskDialogOnDialogConstructed_R,@TCustomTaskDialogOnDialogConstructed_W,'OnDialogConstructed');
    RegisterPropertyHelper(@TCustomTaskDialogOnDialogCreated_R,@TCustomTaskDialogOnDialogCreated_W,'OnDialogCreated');
    RegisterPropertyHelper(@TCustomTaskDialogOnDialogDestroyed_R,@TCustomTaskDialogOnDialogDestroyed_W,'OnDialogDestroyed');
    RegisterPropertyHelper(@TCustomTaskDialogOnExpanded_R,@TCustomTaskDialogOnExpanded_W,'OnExpanded');
    RegisterPropertyHelper(@TCustomTaskDialogOnHyperlinkClicked_R,@TCustomTaskDialogOnHyperlinkClicked_W,'OnHyperlinkClicked');
    RegisterPropertyHelper(@TCustomTaskDialogOnNavigated_R,@TCustomTaskDialogOnNavigated_W,'OnNavigated');
    RegisterPropertyHelper(@TCustomTaskDialogOnRadioButtonClicked_R,@TCustomTaskDialogOnRadioButtonClicked_W,'OnRadioButtonClicked');
    RegisterPropertyHelper(@TCustomTaskDialogOnTimer_R,@TCustomTaskDialogOnTimer_W,'OnTimer');
    RegisterPropertyHelper(@TCustomTaskDialogOnVerificationClicked_R,@TCustomTaskDialogOnVerificationClicked_W,'OnVerificationClicked');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskDialogButtons(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskDialogButtons) do begin
    RegisterMethod(@TTaskDialogButtons.Add, 'Add');
    RegisterMethod(@TTaskDialogButtons.Buttons, 'Buttons');
    RegisterMethod(@TTaskDialogButtons.FindButton, 'FindButton');
    RegisterMethod(@TTaskDialogButtons.GetEnumerator, 'GetEnumerator');
    RegisterVirtualMethod(@TTaskDialogButtons.SetInitialState, 'SetInitialState');
    RegisterPropertyHelper(@TTaskDialogButtonsDefaultButton_R,@TTaskDialogButtonsDefaultButton_W,'DefaultButton');
    RegisterPropertyHelper(@TTaskDialogButtonsItems_R,@TTaskDialogButtonsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskDialogButtonsEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskDialogButtonsEnumerator) do
  begin
    RegisterConstructor(@TTaskDialogButtonsEnumerator.Create, 'Create');
    RegisterMethod(@TTaskDialogButtonsEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TTaskDialogButtonsEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TTaskDialogButtonsEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskDialogRadioButtonItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskDialogRadioButtonItem) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskDialogButtonItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskDialogButtonItem) do
  begin
    RegisterPropertyHelper(@TTaskDialogButtonItemCommandLinkHint_R,@TTaskDialogButtonItemCommandLinkHint_W,'CommandLinkHint');
    RegisterPropertyHelper(@TTaskDialogButtonItemElevationRequired_R,@TTaskDialogButtonItemElevationRequired_W,'ElevationRequired');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskDialogBaseButtonItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskDialogBaseButtonItem) do begin
    RegisterMethod(@TTaskDialogBaseButtonItem.Click, 'Click');
    RegisterVirtualMethod(@TTaskDialogBaseButtonItem.SetInitialState, 'SetInitialState');
    RegisterPropertyHelper(@TTaskDialogBaseButtonItemModalResult_R,@TTaskDialogBaseButtonItemModalResult_W,'ModalResult');
    RegisterPropertyHelper(@TTaskDialogBaseButtonItemTextWStr_R,nil,'TextWStr');
    RegisterPropertyHelper(@TTaskDialogBaseButtonItemCaption_R,@TTaskDialogBaseButtonItemCaption_W,'Caption');
    RegisterPropertyHelper(@TTaskDialogBaseButtonItemDefault_R,@TTaskDialogBaseButtonItemDefault_W,'Default');
    RegisterPropertyHelper(@TTaskDialogBaseButtonItemEnabled_R,@TTaskDialogBaseButtonItemEnabled_W,'Enabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskDialogProgressBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskDialogProgressBar) do begin
    RegisterConstructor(@TTaskDialogProgressBar.Create, 'Create');
    RegisterMethod(@TTaskDialogProgressBar.Initialize, 'Initialize');
    RegisterPropertyHelper(@TTaskDialogProgressBarMarqueeSpeed_R,@TTaskDialogProgressBarMarqueeSpeed_W,'MarqueeSpeed');
    RegisterPropertyHelper(@TTaskDialogProgressBarMax_R,@TTaskDialogProgressBarMax_W,'Max');
    RegisterPropertyHelper(@TTaskDialogProgressBarMin_R,@TTaskDialogProgressBarMin_W,'Min');
    RegisterPropertyHelper(@TTaskDialogProgressBarPosition_R,@TTaskDialogProgressBarPosition_W,'Position');
    RegisterPropertyHelper(@TTaskDialogProgressBarState_R,@TTaskDialogProgressBarState_W,'State');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileSaveDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileSaveDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomFileSaveDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomFileSaveDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileOpenDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileOpenDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomFileOpenDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomFileOpenDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomFileDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomFileDialog) do begin
    //RegisterVirtualMethod(@TCustomFileDialogExecute_P, 'Execute');
    RegisterVirtualMethod(@TCustomFileDialog.Execute, 'Execute');

    RegisterVirtualMethod(@TCustomFileDialogExecute1_P, 'Execute1');
    RegisterConstructor(@TCustomFileDialog.Create, 'Create');

    RegisterPropertyHelper(@TCustomFileDialogClientGuid_R,@TCustomFileDialogClientGuid_W,'ClientGuid');
    RegisterPropertyHelper(@TCustomFileDialogDefaultExtension_R,@TCustomFileDialogDefaultExtension_W,'DefaultExtension');
    RegisterPropertyHelper(@TCustomFileDialogDefaultFolder_R,@TCustomFileDialogDefaultFolder_W,'DefaultFolder');
    RegisterPropertyHelper(@TCustomFileDialogDialog_R,nil,'Dialog');
    RegisterPropertyHelper(@TCustomFileDialogFavoriteLinks_R,@TCustomFileDialogFavoriteLinks_W,'FavoriteLinks');
    RegisterPropertyHelper(@TCustomFileDialogFileName_R,@TCustomFileDialogFileName_W,'FileName');
    RegisterPropertyHelper(@TCustomFileDialogFileNameLabel_R,@TCustomFileDialogFileNameLabel_W,'FileNameLabel');
    RegisterPropertyHelper(@TCustomFileDialogFiles_R,nil,'Files');
    RegisterPropertyHelper(@TCustomFileDialogFileTypes_R,@TCustomFileDialogFileTypes_W,'FileTypes');
    RegisterPropertyHelper(@TCustomFileDialogFileTypeIndex_R,@TCustomFileDialogFileTypeIndex_W,'FileTypeIndex');
    RegisterPropertyHelper(@TCustomFileDialogHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TCustomFileDialogOkButtonLabel_R,@TCustomFileDialogOkButtonLabel_W,'OkButtonLabel');
    RegisterPropertyHelper(@TCustomFileDialogOptions_R,@TCustomFileDialogOptions_W,'Options');
    RegisterPropertyHelper(@TCustomFileDialogShellItem_R,nil,'ShellItem');
    RegisterPropertyHelper(@TCustomFileDialogShellItems_R,nil,'ShellItems');
    RegisterPropertyHelper(@TCustomFileDialogTitle_R,@TCustomFileDialogTitle_W,'Title');
    RegisterPropertyHelper(@TCustomFileDialogOnExecute_R,@TCustomFileDialogOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TCustomFileDialogOnFileOkClick_R,@TCustomFileDialogOnFileOkClick_W,'OnFileOkClick');
    RegisterPropertyHelper(@TCustomFileDialogOnFolderChange_R,@TCustomFileDialogOnFolderChange_W,'OnFolderChange');
    RegisterPropertyHelper(@TCustomFileDialogOnFolderChanging_R,@TCustomFileDialogOnFolderChanging_W,'OnFolderChanging');
    RegisterPropertyHelper(@TCustomFileDialogOnOverwrite_R,@TCustomFileDialogOnOverwrite_W,'OnOverwrite');
    RegisterPropertyHelper(@TCustomFileDialogOnSelectionChange_R,@TCustomFileDialogOnSelectionChange_W,'OnSelectionChange');
    RegisterPropertyHelper(@TCustomFileDialogOnShareViolation_R,@TCustomFileDialogOnShareViolation_W,'OnShareViolation');
    RegisterPropertyHelper(@TCustomFileDialogOnTypeChange_R,@TCustomFileDialogOnTypeChange_W,'OnTypeChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFavoriteLinkItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFavoriteLinkItems) do
  begin
    RegisterMethod(@TFavoriteLinkItems.Add, 'Add');
    RegisterMethod(@TFavoriteLinkItems.GetEnumerator, 'GetEnumerator');
    RegisterPropertyHelper(@TFavoriteLinkItemsItems_R,@TFavoriteLinkItemsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFavoriteLinkItemsEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFavoriteLinkItemsEnumerator) do begin
    RegisterConstructor(@TFavoriteLinkItemsEnumerator.Create, 'Create');
    RegisterMethod(@TFavoriteLinkItemsEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TFavoriteLinkItemsEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TFavoriteLinkItemsEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFavoriteLinkItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFavoriteLinkItem) do
  begin
    RegisterPropertyHelper(@TFavoriteLinkItemLocation_R,@TFavoriteLinkItemLocation_W,'Location');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileTypeItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileTypeItems) do
  begin
    RegisterMethod(@TFileTypeItems.Add, 'Add');
    RegisterMethod(@TFileTypeItems.FilterSpecArray, 'FilterSpecArray');
    RegisterPropertyHelper(@TFileTypeItemsItems_R,@TFileTypeItemsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileTypeItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileTypeItem) do begin
    RegisterPropertyHelper(@TFileTypeItemDisplayNameWStr_R,nil,'DisplayNameWStr');
    RegisterPropertyHelper(@TFileTypeItemFileMaskWStr_R,nil,'FileMaskWStr');
    RegisterPropertyHelper(@TFileTypeItemDisplayName_R,@TFileTypeItemDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TFileTypeItemFileMask_R,@TFileTypeItemFileMask_W,'FileMask');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TReplaceDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TReplaceDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFindDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFindDialog) do begin
    RegisterMethod(@TFindDialog.CloseDialog, 'CloseDialog');
    RegisterPropertyHelper(@TFindDialogLeft_R,@TFindDialogLeft_W,'Left');
    RegisterPropertyHelper(@TFindDialogPosition_R,@TFindDialogPosition_W,'Position');
    RegisterPropertyHelper(@TFindDialogTop_R,@TFindDialogTop_W,'Top');
    RegisterPropertyHelper(@TFindDialogFindText_R,@TFindDialogFindText_W,'FindText');
    RegisterPropertyHelper(@TFindDialogOptions_R,@TFindDialogOptions_W,'Options');
    RegisterPropertyHelper(@TFindDialogOnFind_R,@TFindDialogOnFind_W,'OnFind');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPageSetupDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPageSetupDialog) do begin
    RegisterMethod(@TPageSetupDialog.GetDefaults, 'GetDefaults');
    RegisterPropertyHelper(@TPageSetupDialogPageSetupDlgRec_R,nil,'PageSetupDlgRec');
    RegisterPropertyHelper(@TPageSetupDialogMinMarginLeft_R,@TPageSetupDialogMinMarginLeft_W,'MinMarginLeft');
    RegisterPropertyHelper(@TPageSetupDialogMinMarginTop_R,@TPageSetupDialogMinMarginTop_W,'MinMarginTop');
    RegisterPropertyHelper(@TPageSetupDialogMinMarginRight_R,@TPageSetupDialogMinMarginRight_W,'MinMarginRight');
    RegisterPropertyHelper(@TPageSetupDialogMinMarginBottom_R,@TPageSetupDialogMinMarginBottom_W,'MinMarginBottom');
    RegisterPropertyHelper(@TPageSetupDialogMarginLeft_R,@TPageSetupDialogMarginLeft_W,'MarginLeft');
    RegisterPropertyHelper(@TPageSetupDialogMarginTop_R,@TPageSetupDialogMarginTop_W,'MarginTop');
    RegisterPropertyHelper(@TPageSetupDialogMarginRight_R,@TPageSetupDialogMarginRight_W,'MarginRight');
    RegisterPropertyHelper(@TPageSetupDialogMarginBottom_R,@TPageSetupDialogMarginBottom_W,'MarginBottom');
    RegisterPropertyHelper(@TPageSetupDialogOptions_R,@TPageSetupDialogOptions_W,'Options');
    RegisterPropertyHelper(@TPageSetupDialogPageWidth_R,@TPageSetupDialogPageWidth_W,'PageWidth');
    RegisterPropertyHelper(@TPageSetupDialogPageHeight_R,@TPageSetupDialogPageHeight_W,'PageHeight');
    RegisterPropertyHelper(@TPageSetupDialogUnits_R,@TPageSetupDialogUnits_W,'Units');
    RegisterPropertyHelper(@TPageSetupDialogBeforePaint_R,@TPageSetupDialogBeforePaint_W,'BeforePaint');
    RegisterPropertyHelper(@TPageSetupDialogOnDrawFullPage_R,@TPageSetupDialogOnDrawFullPage_W,'OnDrawFullPage');
    RegisterPropertyHelper(@TPageSetupDialogOnDrawMinMargin_R,@TPageSetupDialogOnDrawMinMargin_W,'OnDrawMinMargin');
    RegisterPropertyHelper(@TPageSetupDialogOnDrawMargin_R,@TPageSetupDialogOnDrawMargin_W,'OnDrawMargin');
    RegisterPropertyHelper(@TPageSetupDialogOnDrawGreekText_R,@TPageSetupDialogOnDrawGreekText_W,'OnDrawGreekText');
    RegisterPropertyHelper(@TPageSetupDialogOnDrawEnvStamp_R,@TPageSetupDialogOnDrawEnvStamp_W,'OnDrawEnvStamp');
    RegisterPropertyHelper(@TPageSetupDialogOnDrawRetAddress_R,@TPageSetupDialogOnDrawRetAddress_W,'OnDrawRetAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPrintDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPrintDialog) do begin
    RegisterPropertyHelper(@TPrintDialogCollate_R,@TPrintDialogCollate_W,'Collate');
    RegisterPropertyHelper(@TPrintDialogCopies_R,@TPrintDialogCopies_W,'Copies');
    RegisterPropertyHelper(@TPrintDialogFromPage_R,@TPrintDialogFromPage_W,'FromPage');
    RegisterPropertyHelper(@TPrintDialogMinPage_R,@TPrintDialogMinPage_W,'MinPage');
    RegisterPropertyHelper(@TPrintDialogMaxPage_R,@TPrintDialogMaxPage_W,'MaxPage');
    RegisterPropertyHelper(@TPrintDialogOptions_R,@TPrintDialogOptions_W,'Options');
    RegisterPropertyHelper(@TPrintDialogPrintToFile_R,@TPrintDialogPrintToFile_W,'PrintToFile');
    RegisterPropertyHelper(@TPrintDialogPrintRange_R,@TPrintDialogPrintRange_W,'PrintRange');
    RegisterPropertyHelper(@TPrintDialogToPage_R,@TPrintDialogToPage_W,'ToPage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPrinterSetupDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPrinterSetupDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFontDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFontDialog) do begin
    RegisterPropertyHelper(@TFontDialogFont_R,@TFontDialogFont_W,'Font');
    RegisterPropertyHelper(@TFontDialogDevice_R,@TFontDialogDevice_W,'Device');
    RegisterPropertyHelper(@TFontDialogMinFontSize_R,@TFontDialogMinFontSize_W,'MinFontSize');
    RegisterPropertyHelper(@TFontDialogMaxFontSize_R,@TFontDialogMaxFontSize_W,'MaxFontSize');
    RegisterPropertyHelper(@TFontDialogOptions_R,@TFontDialogOptions_W,'Options');
    RegisterPropertyHelper(@TFontDialogOnApply_R,@TFontDialogOnApply_W,'OnApply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColorDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColorDialog) do
  begin
    RegisterPropertyHelper(@TColorDialogColor_R,@TColorDialogColor_W,'Color');
    RegisterPropertyHelper(@TColorDialogCustomColors_R,@TColorDialogCustomColors_W,'CustomColors');
    RegisterPropertyHelper(@TColorDialogOptions_R,@TColorDialogOptions_W,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSaveDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSaveDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOpenDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOpenDialog) do begin
    RegisterPropertyHelper(@TOpenDialogFileEditStyle_R,@TOpenDialogFileEditStyle_W,'FileEditStyle');
    RegisterPropertyHelper(@TOpenDialogFiles_R,nil,'Files');
    RegisterPropertyHelper(@TOpenDialogHistoryList_R,@TOpenDialogHistoryList_W,'HistoryList');
    RegisterPropertyHelper(@TOpenDialogDefaultExt_R,@TOpenDialogDefaultExt_W,'DefaultExt');
    RegisterPropertyHelper(@TOpenDialogFileName_R,@TOpenDialogFileName_W,'FileName');
    RegisterPropertyHelper(@TOpenDialogFilter_R,@TOpenDialogFilter_W,'Filter');
    RegisterPropertyHelper(@TOpenDialogFilterIndex_R,@TOpenDialogFilterIndex_W,'FilterIndex');
    RegisterPropertyHelper(@TOpenDialogInitialDir_R,@TOpenDialogInitialDir_W,'InitialDir');
    RegisterPropertyHelper(@TOpenDialogOptions_R,@TOpenDialogOptions_W,'Options');
    RegisterPropertyHelper(@TOpenDialogOptionsEx_R,@TOpenDialogOptionsEx_W,'OptionsEx');
    RegisterPropertyHelper(@TOpenDialogTitle_R,@TOpenDialogTitle_W,'Title');
    RegisterPropertyHelper(@TOpenDialogOnCanClose_R,@TOpenDialogOnCanClose_W,'OnCanClose');
    RegisterPropertyHelper(@TOpenDialogOnFolderChange_R,@TOpenDialogOnFolderChange_W,'OnFolderChange');
    RegisterPropertyHelper(@TOpenDialogOnSelectionChange_R,@TOpenDialogOnSelectionChange_W,'OnSelectionChange');
    RegisterPropertyHelper(@TOpenDialogOnTypeChange_R,@TOpenDialogOnTypeChange_W,'OnTypeChange');
    RegisterPropertyHelper(@TOpenDialogOnIncludeItem_R,@TOpenDialogOnIncludeItem_W,'OnIncludeItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommonDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommonDialog) do begin
    RegisterVirtualMethod(@TCommonDialog.Execute, 'Execute');
    //RegisterVirtualAbstractMethod(@TCommonDialog, @!.Execute1, 'Execute1');
    RegisterPropertyHelper(@TCommonDialogHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TCommonDialogCtl3D_R,@TCommonDialogCtl3D_W,'Ctl3D');
    RegisterPropertyHelper(@TCommonDialogHelpContext_R,@TCommonDialogHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TCommonDialogOnClose_R,@TCommonDialogOnClose_W,'OnClose');
    RegisterPropertyHelper(@TCommonDialogOnShow_R,@TCommonDialogOnShow_W,'OnShow');
		RegisterEventPropertyHelper(@TCommonDialogOnClick_R,@TCommonDialogonCLICK_W,'ONCLICK');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Dialogs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCommonDialog(CL);
  RIRegister_TOpenDialog(CL);
  RIRegister_TSaveDialog(CL);
  RIRegister_TColorDialog(CL);
  RIRegister_TFontDialog(CL);
  RIRegister_TPrinterSetupDialog(CL);
  RIRegister_TPrintDialog(CL);
  RIRegister_TPageSetupDialog(CL);
  RIRegister_TFindDialog(CL);
  RIRegister_TReplaceDialog(CL);
  with CL.Add(EPlatformVersionException) do
  RIRegister_TFileTypeItem(CL);
  RIRegister_TFileTypeItems(CL);
  RIRegister_TFavoriteLinkItem(CL);
  with CL.Add(TFavoriteLinkItems) do
  RIRegister_TFavoriteLinkItemsEnumerator(CL);
  RIRegister_TFavoriteLinkItems(CL);
  RIRegister_TCustomFileDialog(CL);
  RIRegister_TCustomFileOpenDialog(CL);
  RIRegister_TFileOpenDialog(CL);
  RIRegister_TCustomFileSaveDialog(CL);
  RIRegister_TFileSaveDialog(CL);
  with CL.Add(TCustomTaskDialog) do
  RIRegister_TTaskDialogProgressBar(CL);
  RIRegister_TTaskDialogBaseButtonItem(CL);
  RIRegister_TTaskDialogButtonItem(CL);
  RIRegister_TTaskDialogRadioButtonItem(CL);
  with CL.Add(TTaskDialogButtons) do
  RIRegister_TTaskDialogButtonsEnumerator(CL);
  RIRegister_TTaskDialogButtons(CL);
  RIRegister_TCustomTaskDialog(CL);
  RIRegister_TTaskDialog(CL);
end;

 
 
{ TPSImport_Dialogs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Dialogs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Dialogs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Dialogs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Dialogs(ri);
  RIRegister_Dialogs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
