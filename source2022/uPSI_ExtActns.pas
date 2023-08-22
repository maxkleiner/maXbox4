unit uPSI_ExtActns;
{
   TFilerun
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
  TPSImport_ExtActns = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TListControlMoveSelection(CL: TPSPascalCompiler);
procedure SIRegister_TListControlCopySelection(CL: TPSPascalCompiler);
procedure SIRegister_TListControlDeleteSelection(CL: TPSPascalCompiler);
procedure SIRegister_TListControlClearSelection(CL: TPSPascalCompiler);
procedure SIRegister_TListControlSelectAll(CL: TPSPascalCompiler);
procedure SIRegister_TListControlAction(CL: TPSPascalCompiler);
procedure SIRegister_TSendMail(CL: TPSPascalCompiler);
procedure SIRegister_TDownLoadURL(CL: TPSPascalCompiler);
procedure SIRegister_TBrowseURL(CL: TPSPascalCompiler);
procedure SIRegister_TURLAction(CL: TPSPascalCompiler);
procedure SIRegister_TSavePicture(CL: TPSPascalCompiler);
procedure SIRegister_TOpenPicture(CL: TPSPascalCompiler);
procedure SIRegister_TNextTab(CL: TPSPascalCompiler);
procedure SIRegister_TPreviousTab(CL: TPSPascalCompiler);
procedure SIRegister_TTabAction(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditAlignCenter(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditAlignRight(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditAlignLeft(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditBullets(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditStrikeOut(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditUnderline(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditItalic(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditBold(CL: TPSPascalCompiler);
procedure SIRegister_TRichEditAction(CL: TPSPascalCompiler);
procedure SIRegister_TFileRun(CL: TPSPascalCompiler);
procedure SIRegister_TCustomFileRun(CL: TPSPascalCompiler);
procedure SIRegister_ExtActns(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TListControlMoveSelection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListControlCopySelection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListControlDeleteSelection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListControlClearSelection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListControlSelectAll(CL: TPSRuntimeClassImporter);
procedure RIRegister_TListControlAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSendMail(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDownLoadURL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBrowseURL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TURLAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSavePicture(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOpenPicture(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNextTab(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPreviousTab(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTabAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditAlignCenter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditAlignRight(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditAlignLeft(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditBullets(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditStrikeOut(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditUnderline(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditItalic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditBold(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRichEditAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileRun(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomFileRun(CL: TPSRuntimeClassImporter);
procedure RIRegister_ExtActns(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,ComCtrls
  ,Graphics
  ,ActnList
  ,StdActns
  ,StdCtrls
  ,ShellAPI
  ,Dialogs
  ,ExtDlgs
  ,Registry
  ,ImgList
  ,UrlMon
  ,ActiveX
  ,ExtActns
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ExtActns]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TListControlMoveSelection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListControlCopySelection', 'TListControlMoveSelection') do
  with CL.AddClassN(CL.FindClass('TListControlCopySelection'),'TListControlMoveSelection') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListControlCopySelection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListControlAction', 'TListControlCopySelection') do
  with CL.AddClassN(CL.FindClass('TListControlAction'),'TListControlCopySelection') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterProperty('Destination', 'TCustomListControl', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListControlDeleteSelection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListControlAction', 'TListControlDeleteSelection') do
  with CL.AddClassN(CL.FindClass('TListControlAction'),'TListControlDeleteSelection') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListControlClearSelection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListControlAction', 'TListControlClearSelection') do
  with CL.AddClassN(CL.FindClass('TListControlAction'),'TListControlClearSelection') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListControlSelectAll(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TListControlAction', 'TListControlSelectAll') do
  with CL.AddClassN(CL.FindClass('TListControlAction'),'TListControlSelectAll') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TListControlAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAction', 'TListControlAction') do
  with CL.AddClassN(CL.FindClass('TCustomAction'),'TListControlAction') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterProperty('ListControl', 'TCustomListControl', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSendMail(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAction', 'TSendMail') do
  with CL.AddClassN(CL.FindClass('TCustomAction'),'TSendMail') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterProperty('Text', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDownLoadURL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TURLAction', 'TDownLoadURL') do
  with CL.AddClassN(CL.FindClass('TURLAction'),'TDownLoadURL') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterProperty('Filename', 'TFilename', iptrw);
    RegisterProperty('BeforeDownload', 'TNotifyEvent', iptrw);
    RegisterProperty('AfterDownload', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDownloadProgress', 'TDownloadProgressEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBrowseURL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TURLAction', 'TBrowseURL') do
  with CL.AddClassN(CL.FindClass('TURLAction'),'TBrowseURL') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterProperty('BeforeBrowse', 'TNotifyEvent', iptrw);
    RegisterProperty('AfterBrowse', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TURLAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAction', 'TURLAction') do
  with CL.AddClassN(CL.FindClass('TCustomAction'),'TURLAction') do
  begin
    RegisterProperty('URL', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSavePicture(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialogAction', 'TSavePicture') do
  with CL.AddClassN(CL.FindClass('TCommonDialogAction'),'TSavePicture') do
  begin
    RegisterProperty('Dialog', 'TSavePictureDialog', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOpenPicture(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCommonDialogAction', 'TOpenPicture') do
  with CL.AddClassN(CL.FindClass('TCommonDialogAction'),'TOpenPicture') do
  begin
    RegisterProperty('Dialog', 'TOpenPictureDialog', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNextTab(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTabAction', 'TNextTab') do
  with CL.AddClassN(CL.FindClass('TTabAction'),'TNextTab') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterProperty('LastTabCaption', 'String', iptrw);
    RegisterProperty('OnFinish', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPreviousTab(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTabAction', 'TPreviousTab') do
  with CL.AddClassN(CL.FindClass('TTabAction'),'TPreviousTab') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTabAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAction', 'TTabAction') do
  with CL.AddClassN(CL.FindClass('TCustomAction'),'TTabAction') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterProperty('SkipHiddenTabs', 'Boolean', iptrw);
    RegisterProperty('TabControl', 'TCustomTabControl', iptrw);
    RegisterProperty('Wrap', 'Boolean', iptrw);
    RegisterProperty('BeforeTabChange', 'TNotifyEvent', iptrw);
    RegisterProperty('AfterTabChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnValidateTab', 'TValidateTabEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditAlignCenter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditAlignCenter') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditAlignCenter') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditAlignRight(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditAlignRight') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditAlignRight') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditAlignLeft(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditAlignLeft') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditAlignLeft') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditBullets(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditBullets') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditBullets') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditStrikeOut(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditStrikeOut') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditStrikeOut') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditUnderline(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditUnderline') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditUnderline') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditItalic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditItalic') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditItalic') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditBold(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEditAction', 'TRichEditBold') do
  with CL.AddClassN(CL.FindClass('TRichEditAction'),'TRichEditBold') do
  begin
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRichEditAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEditAction', 'TRichEditAction') do
  with CL.AddClassN(CL.FindClass('TEditAction'),'TRichEditAction') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileRun(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFileRun', 'TFileRun') do
  with CL.AddClassN(CL.FindClass('TCustomFileRun'),'TFileRun') do begin
  RegisterPublishedProperties;
    RegisterProperty('ShortCut', 'Word', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('OnUpdate', 'TActionEvent', iptrw);

  {  TActionEvent
   add  property ShortCut;
    property SecondaryShortCuts;
    property Visible;
    property OnUpdate;
    property OnHint; }

 {    property Browse;
    property BrowseDlg;
    property Caption;
    property Directory;
    property Enabled;
    property FileName;
    property HelpContext;
    property Hint;
    property ImageIndex;
    property Operation;
    property ParentControl;
    property Parameters;
    property ShowCmd;
    property ShortCut;
    property SecondaryShortCuts;
    property Visible;
    property OnUpdate;
    property OnHint; }


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomFileRun(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAction', 'TCustomFileRun') do
  with CL.AddClassN(CL.FindClass('TCustomAction'),'TCustomFileRun') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterMethod('Procedure SetupBrowseDialog');
    RegisterProperty('HInst', 'HInst', iptr);
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterProperty('Browse', 'Boolean', iptrw);
    RegisterProperty('BrowseDlg', 'TOpenDialog', iptrw);
    RegisterProperty('Directory', 'TFileName', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('Operation', 'String', iptrw);
    RegisterProperty('ParentControl', 'TWinControl', iptrw);
    RegisterProperty('Parameters', 'String', iptrw);
    RegisterProperty('ShowCmd', 'TShowCmd', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ExtActns(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TShowCmd', '( scHide, scMaximize, scMinimize, scRestore, scShow,'
   +' scShowDefault, scShowMaximized, scShowMinimized, scShowMinNoActive, scSho'
   +'wNA, scShowNoActivate, scShowNormal )');
   CL.AddTypeS('TActionEvent', 'procedure (Action: TBasicAction; var Handled: Boolean) of object;');

  // TActionEvent = procedure (Action: TBasicAction; var Handled: Boolean) of object;

  SIRegister_TCustomFileRun(CL);
  SIRegister_TFileRun(CL);
  SIRegister_TRichEditAction(CL);
  SIRegister_TRichEditBold(CL);
  SIRegister_TRichEditItalic(CL);
  SIRegister_TRichEditUnderline(CL);
  SIRegister_TRichEditStrikeOut(CL);
  SIRegister_TRichEditBullets(CL);
  SIRegister_TRichEditAlignLeft(CL);
  SIRegister_TRichEditAlignRight(CL);
  SIRegister_TRichEditAlignCenter(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTabAction');
  CL.AddTypeS('TValidateTabEvent', 'Procedure ( Sender : TTabAction; TabControl'
   +' : TCustomTabControl; var Enabled : Boolean)');
  SIRegister_TTabAction(CL);
  SIRegister_TPreviousTab(CL);
  SIRegister_TNextTab(CL);
  SIRegister_TOpenPicture(CL);
  SIRegister_TSavePicture(CL);
  SIRegister_TURLAction(CL);
  SIRegister_TBrowseURL(CL);
  CL.AddTypeS('TURLDownloadStatus', '( dsFindingResource, dsConnecting, dsRedir'
   +'ecting, dsBeginDownloadData, dsDownloadingData, dsEndDownloadData, dsBegin'
   +'DownloadComponents, dsInstallingComponents, dsEndDownloadComponents, dsUsi'
   +'ngCachedCopy, dsSendingRequest, dsClassIDAvailable, dsMIMETypeAvailable, d'
   +'sCacheFileNameAvailable, dsBeginSyncOperation, dsEndSyncOperation, dsBegin'
   +'UploadData, dsUploadingData, dsEndUploadData, dsProtocolClassID, dsEncodin'
   +'g, dsVerifiedMIMETypeAvailable, dsClassInstallLocation, dsDecoding, dsLoad'
   +'ingMIMEHandler, dsContentDispositionAttach, dsFilterReportMIMEType, dsCLSI'
   +'DCanInstantiate, dsIUnKnownAvailable, dsDirectBind, dsRawMIMEType, dsProxy'
   +'Detecting, dsAcceptRanges, dsCookieSent, dsCompactPolicyReceived, dsCookie'
   +'Suppressed, dsCookieStateUnknown, dsCookieStateAccept, dsCookeStateReject,'
   +' dsCookieStatePrompt, dsCookieStateLeash, dsCookieStateDowngrade, dsPolicy'
   +'HREF, dsP3PHeader, dsSessionCookieReceived, dsPersistentCookieReceived, ds'
   +'SessionCookiesAllowed )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDownLoadURL');
  CL.AddTypeS('TDownloadProgressEvent', 'Procedure ( Sender : TDownLoadURL; Pro'
   +'gress, ProgressMax : Cardinal; StatusCode : TURLDownloadStatus; StatusText'
   +' : String; var Cancel : Boolean)');
  SIRegister_TDownLoadURL(CL);
  SIRegister_TSendMail(CL);
  SIRegister_TListControlAction(CL);
  SIRegister_TListControlSelectAll(CL);
  SIRegister_TListControlClearSelection(CL);
  SIRegister_TListControlDeleteSelection(CL);
  SIRegister_TListControlCopySelection(CL);
  SIRegister_TListControlMoveSelection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TListControlCopySelectionDestination_W(Self: TListControlCopySelection; const T: TCustomListControl);
begin Self.Destination := T; end;

(*----------------------------------------------------------------------------*)
procedure TListControlCopySelectionDestination_R(Self: TListControlCopySelection; var T: TCustomListControl);
begin T := Self.Destination; end;

(*----------------------------------------------------------------------------*)
procedure TListControlActionListControl_W(Self: TListControlAction; const T: TCustomListControl);
begin Self.ListControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TListControlActionListControl_R(Self: TListControlAction; var T: TCustomListControl);
begin T := Self.ListControl; end;

(*----------------------------------------------------------------------------*)
procedure TSendMailText_W(Self: TSendMail; const T: TStrings);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TSendMailText_R(Self: TSendMail; var T: TStrings);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLOnDownloadProgress_W(Self: TDownLoadURL; const T: TDownloadProgressEvent);
begin Self.OnDownloadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLOnDownloadProgress_R(Self: TDownLoadURL; var T: TDownloadProgressEvent);
begin T := Self.OnDownloadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLAfterDownload_W(Self: TDownLoadURL; const T: TNotifyEvent);
begin Self.AfterDownload := T; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLAfterDownload_R(Self: TDownLoadURL; var T: TNotifyEvent);
begin T := Self.AfterDownload; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLBeforeDownload_W(Self: TDownLoadURL; const T: TNotifyEvent);
begin Self.BeforeDownload := T; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLBeforeDownload_R(Self: TDownLoadURL; var T: TNotifyEvent);
begin T := Self.BeforeDownload; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLFilename_W(Self: TDownLoadURL; const T: TFilename);
begin Self.Filename := T; end;

(*----------------------------------------------------------------------------*)
procedure TDownLoadURLFilename_R(Self: TDownLoadURL; var T: TFilename);
begin T := Self.Filename; end;

(*----------------------------------------------------------------------------*)
procedure TBrowseURLAfterBrowse_W(Self: TBrowseURL; const T: TNotifyEvent);
begin Self.AfterBrowse := T; end;

(*----------------------------------------------------------------------------*)
procedure TBrowseURLAfterBrowse_R(Self: TBrowseURL; var T: TNotifyEvent);
begin T := Self.AfterBrowse; end;

(*----------------------------------------------------------------------------*)
procedure TBrowseURLBeforeBrowse_W(Self: TBrowseURL; const T: TNotifyEvent);
begin Self.BeforeBrowse := T; end;

(*----------------------------------------------------------------------------*)
procedure TBrowseURLBeforeBrowse_R(Self: TBrowseURL; var T: TNotifyEvent);
begin T := Self.BeforeBrowse; end;

(*----------------------------------------------------------------------------*)
procedure TURLActionURL_W(Self: TURLAction; const T: String);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TURLActionURL_R(Self: TURLAction; var T: String);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TSavePictureDialog_R(Self: TSavePicture; var T: TSavePictureDialog);
begin T := Self.Dialog; end;

(*----------------------------------------------------------------------------*)
procedure TOpenPictureDialog_R(Self: TOpenPicture; var T: TOpenPictureDialog);
begin T := Self.Dialog; end;

(*----------------------------------------------------------------------------*)
procedure TNextTabOnFinish_W(Self: TNextTab; const T: TNotifyEvent);
begin Self.OnFinish := T; end;

(*----------------------------------------------------------------------------*)
procedure TNextTabOnFinish_R(Self: TNextTab; var T: TNotifyEvent);
begin T := Self.OnFinish; end;

(*----------------------------------------------------------------------------*)
procedure TNextTabLastTabCaption_W(Self: TNextTab; const T: String);
begin Self.LastTabCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TNextTabLastTabCaption_R(Self: TNextTab; var T: String);
begin T := Self.LastTabCaption; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionOnValidateTab_W(Self: TTabAction; const T: TValidateTabEvent);
begin Self.OnValidateTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionOnValidateTab_R(Self: TTabAction; var T: TValidateTabEvent);
begin T := Self.OnValidateTab; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionAfterTabChange_W(Self: TTabAction; const T: TNotifyEvent);
begin Self.AfterTabChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionAfterTabChange_R(Self: TTabAction; var T: TNotifyEvent);
begin T := Self.AfterTabChange; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionBeforeTabChange_W(Self: TTabAction; const T: TNotifyEvent);
begin Self.BeforeTabChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionBeforeTabChange_R(Self: TTabAction; var T: TNotifyEvent);
begin T := Self.BeforeTabChange; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionWrap_W(Self: TTabAction; const T: Boolean);
begin Self.Wrap := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionWrap_R(Self: TTabAction; var T: Boolean);
begin T := Self.Wrap; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionTabControl_W(Self: TTabAction; const T: TCustomTabControl);
begin Self.TabControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionTabControl_R(Self: TTabAction; var T: TCustomTabControl);
begin T := Self.TabControl; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionSkipHiddenTabs_W(Self: TTabAction; const T: Boolean);
begin Self.SkipHiddenTabs := T; end;

(*----------------------------------------------------------------------------*)
procedure TTabActionSkipHiddenTabs_R(Self: TTabAction; var T: Boolean);
begin T := Self.SkipHiddenTabs; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunShowCmd_W(Self: TCustomFileRun; const T: TShowCmd);
begin Self.ShowCmd := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunShowCmd_R(Self: TCustomFileRun; var T: TShowCmd);
begin T := Self.ShowCmd; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunParameters_W(Self: TCustomFileRun; const T: String);
begin Self.Parameters := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunParameters_R(Self: TCustomFileRun; var T: String);
begin T := Self.Parameters; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunParentControl_W(Self: TCustomFileRun; const T: TWinControl);
begin Self.ParentControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunParentControl_R(Self: TCustomFileRun; var T: TWinControl);
begin T := Self.ParentControl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunOperation_W(Self: TCustomFileRun; const T: String);
begin Self.Operation := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunOperation_R(Self: TCustomFileRun; var T: String);
begin T := Self.Operation; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunFileName_W(Self: TCustomFileRun; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunFileName_R(Self: TCustomFileRun; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunDirectory_W(Self: TCustomFileRun; const T: TFileName);
begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunDirectory_R(Self: TCustomFileRun; var T: TFileName);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunBrowseDlg_W(Self: TCustomFileRun; const T: TOpenDialog);
begin Self.BrowseDlg := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunBrowseDlg_R(Self: TCustomFileRun; var T: TOpenDialog);
begin T := Self.BrowseDlg; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunBrowse_W(Self: TCustomFileRun; const T: Boolean);
begin Self.Browse := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunBrowse_R(Self: TCustomFileRun; var T: Boolean);
begin T := Self.Browse; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFileRunHInst_R(Self: TCustomFileRun; var T: HInst);
begin T := Self.HInst; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListControlMoveSelection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListControlMoveSelection) do
  begin
    RegisterMethod(@TListControlMoveSelection.ExecuteTarget, 'ExecuteTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListControlCopySelection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListControlCopySelection) do
  begin
    RegisterMethod(@TListControlCopySelection.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TListControlCopySelection.HandlesTarget, 'HandlesTarget');
    RegisterMethod(@TListControlCopySelection.UpdateTarget, 'UpdateTarget');
    RegisterPropertyHelper(@TListControlCopySelectionDestination_R,@TListControlCopySelectionDestination_W,'Destination');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListControlDeleteSelection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListControlDeleteSelection) do
  begin
    RegisterMethod(@TListControlDeleteSelection.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TListControlDeleteSelection.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListControlClearSelection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListControlClearSelection) do
  begin
    RegisterMethod(@TListControlClearSelection.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TListControlClearSelection.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListControlSelectAll(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListControlSelectAll) do
  begin
    RegisterMethod(@TListControlSelectAll.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TListControlSelectAll.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TListControlAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TListControlAction) do
  begin
    RegisterConstructor(@TListControlAction.Create, 'Create');
    RegisterMethod(@TListControlAction.HandlesTarget, 'HandlesTarget');
    RegisterPropertyHelper(@TListControlActionListControl_R,@TListControlActionListControl_W,'ListControl');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSendMail(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSendMail) do
  begin
    RegisterMethod(@TSendMail.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TSendMail.HandlesTarget, 'HandlesTarget');
    RegisterMethod(@TSendMail.UpdateTarget, 'UpdateTarget');
    RegisterPropertyHelper(@TSendMailText_R,@TSendMailText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDownLoadURL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDownLoadURL) do
  begin
    RegisterMethod(@TDownLoadURL.ExecuteTarget, 'ExecuteTarget');
    RegisterPropertyHelper(@TDownLoadURLFilename_R,@TDownLoadURLFilename_W,'Filename');
    RegisterPropertyHelper(@TDownLoadURLBeforeDownload_R,@TDownLoadURLBeforeDownload_W,'BeforeDownload');
    RegisterPropertyHelper(@TDownLoadURLAfterDownload_R,@TDownLoadURLAfterDownload_W,'AfterDownload');
    RegisterPropertyHelper(@TDownLoadURLOnDownloadProgress_R,@TDownLoadURLOnDownloadProgress_W,'OnDownloadProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBrowseURL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBrowseURL) do
  begin
    RegisterMethod(@TBrowseURL.ExecuteTarget, 'ExecuteTarget');
    RegisterPropertyHelper(@TBrowseURLBeforeBrowse_R,@TBrowseURLBeforeBrowse_W,'BeforeBrowse');
    RegisterPropertyHelper(@TBrowseURLAfterBrowse_R,@TBrowseURLAfterBrowse_W,'AfterBrowse');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TURLAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TURLAction) do
  begin
    RegisterPropertyHelper(@TURLActionURL_R,@TURLActionURL_W,'URL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSavePicture(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSavePicture) do
  begin
    RegisterPropertyHelper(@TSavePictureDialog_R,nil,'Dialog');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOpenPicture(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOpenPicture) do
  begin
    RegisterPropertyHelper(@TOpenPictureDialog_R,nil,'Dialog');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNextTab(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNextTab) do
  begin
    RegisterMethod(@TNextTab.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TNextTab.UpdateTarget, 'UpdateTarget');
    RegisterPropertyHelper(@TNextTabLastTabCaption_R,@TNextTabLastTabCaption_W,'LastTabCaption');
    RegisterPropertyHelper(@TNextTabOnFinish_R,@TNextTabOnFinish_W,'OnFinish');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPreviousTab(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPreviousTab) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTabAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTabAction) do
  begin
    RegisterConstructor(@TTabAction.Create, 'Create');
    RegisterMethod(@TTabAction.HandlesTarget, 'HandlesTarget');
    RegisterMethod(@TTabAction.UpdateTarget, 'UpdateTarget');
    RegisterPropertyHelper(@TTabActionSkipHiddenTabs_R,@TTabActionSkipHiddenTabs_W,'SkipHiddenTabs');
    RegisterPropertyHelper(@TTabActionTabControl_R,@TTabActionTabControl_W,'TabControl');
    RegisterPropertyHelper(@TTabActionWrap_R,@TTabActionWrap_W,'Wrap');
    RegisterPropertyHelper(@TTabActionBeforeTabChange_R,@TTabActionBeforeTabChange_W,'BeforeTabChange');
    RegisterPropertyHelper(@TTabActionAfterTabChange_R,@TTabActionAfterTabChange_W,'AfterTabChange');
    RegisterPropertyHelper(@TTabActionOnValidateTab_R,@TTabActionOnValidateTab_W,'OnValidateTab');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditAlignCenter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditAlignCenter) do
  begin
    RegisterMethod(@TRichEditAlignCenter.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditAlignCenter.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditAlignRight(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditAlignRight) do
  begin
    RegisterMethod(@TRichEditAlignRight.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditAlignRight.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditAlignLeft(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditAlignLeft) do
  begin
    RegisterMethod(@TRichEditAlignLeft.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditAlignLeft.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditBullets(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditBullets) do
  begin
    RegisterMethod(@TRichEditBullets.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditBullets.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditStrikeOut(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditStrikeOut) do
  begin
    RegisterMethod(@TRichEditStrikeOut.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditStrikeOut.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditUnderline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditUnderline) do
  begin
    RegisterMethod(@TRichEditUnderline.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditUnderline.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditItalic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditItalic) do
  begin
    RegisterMethod(@TRichEditItalic.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditItalic.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditBold(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditBold) do
  begin
    RegisterMethod(@TRichEditBold.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TRichEditBold.UpdateTarget, 'UpdateTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRichEditAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRichEditAction) do
  begin
    RegisterConstructor(@TRichEditAction.Create, 'Create');
    RegisterMethod(@TRichEditAction.HandlesTarget, 'HandlesTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileRun(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileRun) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomFileRun(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomFileRun) do
  begin
    RegisterConstructor(@TCustomFileRun.Create, 'Create');
    RegisterMethod(@TCustomFileRun.ExecuteTarget, 'ExecuteTarget');
    RegisterMethod(@TCustomFileRun.HandlesTarget, 'HandlesTarget');
    RegisterMethod(@TCustomFileRun.SetupBrowseDialog, 'SetupBrowseDialog');
    RegisterPropertyHelper(@TCustomFileRunHInst_R,nil,'HInst');
    RegisterMethod(@TCustomFileRun.UpdateTarget, 'UpdateTarget');
    RegisterPropertyHelper(@TCustomFileRunBrowse_R,@TCustomFileRunBrowse_W,'Browse');
    RegisterPropertyHelper(@TCustomFileRunBrowseDlg_R,@TCustomFileRunBrowseDlg_W,'BrowseDlg');
    RegisterPropertyHelper(@TCustomFileRunDirectory_R,@TCustomFileRunDirectory_W,'Directory');
    RegisterPropertyHelper(@TCustomFileRunFileName_R,@TCustomFileRunFileName_W,'FileName');
    RegisterPropertyHelper(@TCustomFileRunOperation_R,@TCustomFileRunOperation_W,'Operation');
    RegisterPropertyHelper(@TCustomFileRunParentControl_R,@TCustomFileRunParentControl_W,'ParentControl');
    RegisterPropertyHelper(@TCustomFileRunParameters_R,@TCustomFileRunParameters_W,'Parameters');
    RegisterPropertyHelper(@TCustomFileRunShowCmd_R,@TCustomFileRunShowCmd_W,'ShowCmd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ExtActns(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomFileRun(CL);
  RIRegister_TFileRun(CL);
  RIRegister_TRichEditAction(CL);
  RIRegister_TRichEditBold(CL);
  RIRegister_TRichEditItalic(CL);
  RIRegister_TRichEditUnderline(CL);
  RIRegister_TRichEditStrikeOut(CL);
  RIRegister_TRichEditBullets(CL);
  RIRegister_TRichEditAlignLeft(CL);
  RIRegister_TRichEditAlignRight(CL);
  RIRegister_TRichEditAlignCenter(CL);
  with CL.Add(TTabAction) do
  RIRegister_TTabAction(CL);
  RIRegister_TPreviousTab(CL);
  RIRegister_TNextTab(CL);
  RIRegister_TOpenPicture(CL);
  RIRegister_TSavePicture(CL);
  RIRegister_TURLAction(CL);
  RIRegister_TBrowseURL(CL);
  with CL.Add(TDownLoadURL) do
  RIRegister_TDownLoadURL(CL);
  RIRegister_TSendMail(CL);
  RIRegister_TListControlAction(CL);
  RIRegister_TListControlSelectAll(CL);
  RIRegister_TListControlClearSelection(CL);
  RIRegister_TListControlDeleteSelection(CL);
  RIRegister_TListControlCopySelection(CL);
  RIRegister_TListControlMoveSelection(CL);
end;

 
 
{ TPSImport_ExtActns }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtActns.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExtActns(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtActns.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ExtActns(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
