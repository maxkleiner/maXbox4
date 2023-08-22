unit uPSI_SHDocVw;
{
in the end the webbox   , check handleneeded

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
  TPSImport_SHDocVw = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_CoSearchAssistantOC(CL: TPSPascalCompiler);
procedure SIRegister_CoCScriptErrorList(CL: TPSPascalCompiler);
procedure SIRegister_TShellNameSpace(CL: TPSPascalCompiler);
procedure SIRegister_CoShellNameSpace(CL: TPSPascalCompiler);
procedure SIRegister_TShellUIHelper(CL: TPSPascalCompiler);
procedure SIRegister_CoShellUIHelper(CL: TPSPascalCompiler);
procedure SIRegister_TShellWindows(CL: TPSPascalCompiler);
procedure SIRegister_CoShellWindows(CL: TPSPascalCompiler);
procedure SIRegister_CoShellBrowserWindow(CL: TPSPascalCompiler);
procedure SIRegister_TInternetExplorer(CL: TPSPascalCompiler);
procedure SIRegister_CoInternetExplorer(CL: TPSPascalCompiler);
procedure SIRegister_TWebBrowser(CL: TPSPascalCompiler);
procedure SIRegister_TWebBrowser_V1(CL: TPSPascalCompiler);
procedure SIRegister_ISearchAssistantOC3(CL: TPSPascalCompiler);
procedure SIRegister_ISearchAssistantOC2(CL: TPSPascalCompiler);
procedure SIRegister_ISearchAssistantOC(CL: TPSPascalCompiler);
procedure SIRegister_ISearches(CL: TPSPascalCompiler);
procedure SIRegister_ISearch(CL: TPSPascalCompiler);
procedure SIRegister_IScriptErrorList(CL: TPSPascalCompiler);
procedure SIRegister_IShellNameSpace(CL: TPSPascalCompiler);
procedure SIRegister_IShellFavoritesNameSpace(CL: TPSPascalCompiler);
procedure SIRegister_IShellUIHelper(CL: TPSPascalCompiler);
procedure SIRegister_IShellWindows(CL: TPSPascalCompiler);
procedure SIRegister_IWebBrowser2(CL: TPSPascalCompiler);
procedure SIRegister_IWebBrowserApp(CL: TPSPascalCompiler);
procedure SIRegister_IWebBrowser(CL: TPSPascalCompiler);
procedure SIRegister_SHDocVw(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CoSearchAssistantOC(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoCScriptErrorList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellNameSpace(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoShellNameSpace(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellUIHelper(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoShellUIHelper(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellWindows(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoShellWindows(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoShellBrowserWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInternetExplorer(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoInternetExplorer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebBrowser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebBrowser_V1(CL: TPSRuntimeClassImporter);
procedure RIRegister_SHDocVw(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,Graphics
  ,OleCtrls
  ,OleServer
  ,StdVCL
  ,Variants
  ,SHDocVw
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SHDocVw]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSearchAssistantOC(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSearchAssistantOC') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSearchAssistantOC') do
  begin
    RegisterMethod('Function Create : ISearchAssistantOC3');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISearchAssistantOC3');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoCScriptErrorList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoCScriptErrorList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoCScriptErrorList') do
  begin
    RegisterMethod('Function Create : IScriptErrorList');
    RegisterMethod('Function CreateRemote( const MachineName : string) : IScriptErrorList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellNameSpace(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TShellNameSpace') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TShellNameSpace') do begin
    RegisterMethod('Procedure ConnectTo( svrIntf : IShellNameSpace)');
         RegisterMethod('Constructor Create(AOwner: TComponent)');
        RegisterMethod('Procedure Free');
          RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
  
    RegisterMethod('Procedure MoveSelectionUp');
    RegisterMethod('Procedure MoveSelectionDown');
    RegisterMethod('Procedure ResetSort');
    RegisterMethod('Procedure NewFolder');
    RegisterMethod('Procedure Synchronize');
    RegisterMethod('Procedure InvokeContextMenuCommand( const strCommand : WideString)');
    RegisterMethod('Procedure MoveSelectionTo');
    RegisterMethod('Function CreateSubscriptionForSelection : WordBool');
    RegisterMethod('Function DeleteSubscriptionForSelection : WordBool');
    RegisterMethod('Procedure SetRoot( const bstrFullPath : WideString)');
    RegisterMethod('Procedure SetViewType( iType : SYSINT)');
    RegisterMethod('Function SelectedItems : IDispatch');
    RegisterMethod('Procedure Expand( var_ : OleVariant; iDepth : SYSINT)');
    RegisterMethod('Procedure UnselectAll');
    RegisterProperty('DefaultInterface', 'IShellNameSpace', iptr);
    RegisterProperty('SubscriptionsEnabled', 'WordBool', iptr);
    RegisterProperty('SelectedItem', 'IDispatch', iptrw);
    RegisterProperty('Root', 'OleVariant', iptrw);
    RegisterProperty('CountViewTypes', 'SYSINT', iptr);
    RegisterProperty('EnumOptions', 'Integer', iptrw);
    RegisterProperty('Depth', 'SYSINT', iptrw);
    RegisterProperty('Mode', 'SYSUINT', iptrw);
    RegisterProperty('Flags', 'LongWord', iptrw);
    RegisterProperty('TVFlags', 'LongWord', iptrw);
    RegisterProperty('Columns', 'WideString', iptrw);
    RegisterProperty('OnFavoritesSelectionChange', 'TShellNameSpaceFavoritesSelectionChange', iptrw);
    RegisterProperty('OnSelectionChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDoubleClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnInitialized', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoShellNameSpace(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoShellNameSpace') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoShellNameSpace') do
  begin
    RegisterMethod('Function Create : IShellNameSpace');
    RegisterMethod('Function CreateRemote( const MachineName : string) : IShellNameSpace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellUIHelper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TShellUIHelper') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TShellUIHelper') do begin
    RegisterMethod('Procedure ConnectTo( svrIntf : IShellUIHelper)');
         RegisterMethod('Constructor Create(AOwner: TComponent)');
        RegisterMethod('Procedure Free');
          RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');

    RegisterMethod('Procedure ResetFirstBootMode');
    RegisterMethod('Procedure ResetSafeMode');
    RegisterMethod('Procedure RefreshOfflineDesktop');
    RegisterMethod('Procedure AddFavorite45( const URL : WideString);');
    RegisterMethod('Procedure AddFavorite46( const URL : WideString; var Title : OleVariant);');
    RegisterMethod('Procedure AddChannel( const URL : WideString)');
    RegisterMethod('Procedure AddDesktopComponent47( const URL : WideString; const Type_ : WideString);');
    RegisterMethod('Procedure AddDesktopComponent48( const URL : WideString; const Type_ : WideString; var Left : OleVariant);');
    RegisterMethod('Procedure AddDesktopComponent49( const URL : WideString; const Type_ : WideString; var Left : OleVariant; var Top : OleVariant);');
    RegisterMethod('Procedure AddDesktopComponent50( const URL : WideString; const Type_ : WideString; var Left : OleVariant; var Top : OleVariant; var Width : OleVariant);');
    RegisterMethod('Procedure AddDesktopComponent51( const URL : WideString; const Type_ : WideString; var Left : OleVariant; var Top : OleVariant; var Width : OleVariant; var Height : OleVariant);');
    RegisterMethod('Function IsSubscribed( const URL : WideString) : WordBool');
    RegisterMethod('Procedure NavigateAndFind( const URL : WideString; const strQuery : WideString; var varTargetFrame : OleVariant)');
    RegisterMethod('Procedure ImportExportFavorites( fImport : WordBool; const strImpExpPath : WideString)');
    RegisterMethod('Procedure AutoCompleteSaveForm52;');
    RegisterMethod('Procedure AutoCompleteSaveForm53( var Form : OleVariant);');
    RegisterMethod('Procedure AutoScan54( const strSearch : WideString; const strFailureUrl : WideString);');
    RegisterMethod('Procedure AutoScan55( const strSearch : WideString; const strFailureUrl : WideString; var pvarTargetFrame : OleVariant);');
    RegisterMethod('Procedure AutoCompleteAttach56;');
    RegisterMethod('Procedure AutoCompleteAttach57( var Reserved : OleVariant);');
    RegisterMethod('Function ShowBrowserUI( const bstrName : WideString; var pvarIn : OleVariant) : OleVariant');
    RegisterProperty('DefaultInterface', 'IShellUIHelper', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoShellUIHelper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoShellUIHelper') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoShellUIHelper') do
  begin
    RegisterMethod('Function Create : IShellUIHelper');
    RegisterMethod('Function CreateRemote( const MachineName : string) : IShellUIHelper');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellWindows(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TShellWindows') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TShellWindows') do begin
    RegisterMethod('Procedure ConnectTo( svrIntf : IShellWindows)');
       RegisterMethod('Constructor Create(AOwner: TComponent)');
        RegisterMethod('Procedure Free');
        RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');

      //    procedure Connect; override;
    //procedure ConnectTo(svrIntf: IShellWindows);
    //procedure Disconnect; override;

    RegisterMethod('Function Item43 : IDispatch;');
    RegisterMethod('Function Item44( index : OleVariant) : IDispatch;');
    RegisterMethod('Function _NewEnum : IUnknown');
    RegisterMethod('Procedure Register( const pid : IDispatch; HWND : Integer; swClass : SYSINT; out plCookie : Integer)');
    RegisterMethod('Procedure RegisterPending( lThreadId : Integer; var pvarloc : OleVariant; var pvarlocRoot : OleVariant; swClass : SYSINT; out plCookie : Integer)');
    RegisterMethod('Procedure Revoke( lCookie : Integer)');
    RegisterMethod('Procedure OnNavigate( lCookie : Integer; var pvarloc : OleVariant)');
    RegisterMethod('Procedure OnActivated( lCookie : Integer; fActive : WordBool)');
    RegisterMethod('Function FindWindowSW( var pvarloc : OleVariant; var pvarlocRoot : OleVariant; swClass : SYSINT; out pHWND : Integer; swfwOptions : SYSINT) : IDispatch');
    RegisterMethod('Procedure OnCreated( lCookie : Integer; const punk : IUnknown)');
    RegisterMethod('Procedure ProcessAttachDetach( fAttach : WordBool)');
    RegisterProperty('DefaultInterface', 'IShellWindows', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('OnWindowRegistered', 'TShellWindowsWindowRegistered', iptrw);
    RegisterProperty('OnWindowRevoked', 'TShellWindowsWindowRevoked', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoShellWindows(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoShellWindows') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoShellWindows') do
  begin
    RegisterMethod('Function Create : IShellWindows');
    RegisterMethod('Function CreateRemote( const MachineName : string) : IShellWindows');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoShellBrowserWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoShellBrowserWindow') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoShellBrowserWindow') do
  begin
    RegisterMethod('Function Create : IWebBrowser2');
    RegisterMethod('Function CreateRemote( const MachineName : string) : IWebBrowser2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInternetExplorer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TInternetExplorer') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TInternetExplorer') do begin
    RegisterMethod('Procedure ConnectTo( svrIntf : IWebBrowser2)');
    RegisterMethod('Procedure GoBack');
    RegisterMethod('Procedure GoForward');
    RegisterMethod('Procedure GoHome');
    RegisterMethod('Procedure GoSearch');
       RegisterMethod('Constructor Create(AOwner: TComponent)');
        RegisterMethod('Procedure Free');
          RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure Navigate25( const URL : WideString);');
    RegisterMethod('Procedure Navigate26( const URL : WideString; const Flags : OleVariant);');
    RegisterMethod('Procedure Navigate27( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant);');
    RegisterMethod('Procedure Navigate28( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant);');
    RegisterMethod('Procedure Navigate29( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant; const Headers : OleVariant);');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure Refresh230;');
    RegisterMethod('Procedure Refresh231( var Level : OleVariant);');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Quit');
    RegisterMethod('Procedure ClientToWindow( var pcx : SYSINT; var pcy : SYSINT)');
    RegisterMethod('Procedure PutProperty( const Property_ : WideString; vtValue : OleVariant)');
    RegisterMethod('Function GetProperty( const Property_ : WideString) : OleVariant');
    RegisterMethod('Procedure Navigate232( var URL : OleVariant);');
    RegisterMethod('Procedure Navigate233( var URL : OleVariant; var Flags : OleVariant);');
    RegisterMethod('Procedure Navigate234( var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant);');
    RegisterMethod('Procedure Navigate235( var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant);');
    RegisterMethod('Procedure Navigate236( var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant; var Headers : OleVariant);');
    RegisterMethod('Function QueryStatusWB( cmdID : OLECMDID) : OLECMDF');
    RegisterMethod('Procedure ExecWB37( cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT);');
    RegisterMethod('Procedure ExecWB38( cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant);');
    RegisterMethod('Procedure ExecWB39( cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant; var pvaOut : OleVariant);');
    RegisterMethod('Procedure ShowBrowserBar40( var pvaClsid : OleVariant);');
    RegisterMethod('Procedure ShowBrowserBar41( var pvaClsid : OleVariant; var pvarShow : OleVariant);');
    RegisterMethod('Procedure ShowBrowserBar42( var pvaClsid : OleVariant; var pvarShow : OleVariant; var pvarSize : OleVariant);');
    RegisterProperty('DefaultInterface', 'IWebBrowser2', iptr);
    RegisterProperty('Application', 'IDispatch', iptr);
    RegisterProperty('Parent', 'IDispatch', iptr);
    RegisterProperty('Container', 'IDispatch', iptr);
    RegisterProperty('Document', 'IDispatch', iptr);
    RegisterProperty('TopLevelContainer', 'WordBool', iptr);
    RegisterProperty('type_', 'WideString', iptr);
    RegisterProperty('LocationName', 'WideString', iptr);
    RegisterProperty('LocationURL', 'WideString', iptr);
    RegisterProperty('Busy', 'WordBool', iptr);
    RegisterProperty('Name', 'WideString', iptr);
    RegisterProperty('HWnd', 'Integer', iptr);
    RegisterProperty('FullName', 'WideString', iptr);
    RegisterProperty('Path', 'WideString', iptr);
    RegisterProperty('ReadyState', 'tagREADYSTATE', iptr);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Visible', 'WordBool', iptrw);
    RegisterProperty('StatusBar', 'WordBool', iptrw);
    RegisterProperty('StatusText', 'WideString', iptrw);
    RegisterProperty('ToolBar', 'SYSINT', iptrw);
    RegisterProperty('MenuBar', 'WordBool', iptrw);
    RegisterProperty('FullScreen', 'WordBool', iptrw);
    RegisterProperty('Offline', 'WordBool', iptrw);
    RegisterProperty('Silent', 'WordBool', iptrw);
    RegisterProperty('RegisterAsBrowser', 'WordBool', iptrw);
    RegisterProperty('RegisterAsDropTarget', 'WordBool', iptrw);
    RegisterProperty('TheaterMode', 'WordBool', iptrw);
    RegisterProperty('AddressBar', 'WordBool', iptrw);
    RegisterProperty('Resizable', 'WordBool', iptrw);
    RegisterProperty('OnStatusTextChange', 'TInternetExplorerStatusTextChange', iptrw);
    RegisterProperty('OnProgressChange', 'TInternetExplorerProgressChange', iptrw);
    RegisterProperty('OnCommandStateChange', 'TInternetExplorerCommandStateChange', iptrw);
    RegisterProperty('OnDownloadBegin', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDownloadComplete', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTitleChange', 'TInternetExplorerTitleChange', iptrw);
    RegisterProperty('OnPropertyChange', 'TInternetExplorerPropertyChange', iptrw);
    RegisterProperty('OnBeforeNavigate2', 'TInternetExplorerBeforeNavigate2', iptrw);
    RegisterProperty('OnNewWindow2', 'TInternetExplorerNewWindow2', iptrw);
    RegisterProperty('OnNavigateComplete2', 'TInternetExplorerNavigateComplete2', iptrw);
    RegisterProperty('OnDocumentComplete', 'TInternetExplorerDocumentComplete', iptrw);
    RegisterProperty('OnQuit', 'TNotifyEvent', iptrw);
    RegisterProperty('OnVisible', 'TInternetExplorerOnVisible', iptrw);
    RegisterProperty('OnToolBar', 'TInternetExplorerOnToolBar', iptrw);
    RegisterProperty('OnMenuBar', 'TInternetExplorerOnMenuBar', iptrw);
    RegisterProperty('OnStatusBar', 'TInternetExplorerOnStatusBar', iptrw);
    RegisterProperty('OnFullScreen', 'TInternetExplorerOnFullScreen', iptrw);
    RegisterProperty('OnTheaterMode', 'TInternetExplorerOnTheaterMode', iptrw);
    RegisterProperty('OnWindowSetResizable', 'TInternetExplorerWindowSetResizable', iptrw);
    RegisterProperty('OnWindowSetLeft', 'TInternetExplorerWindowSetLeft', iptrw);
    RegisterProperty('OnWindowSetTop', 'TInternetExplorerWindowSetTop', iptrw);
    RegisterProperty('OnWindowSetWidth', 'TInternetExplorerWindowSetWidth', iptrw);
    RegisterProperty('OnWindowSetHeight', 'TInternetExplorerWindowSetHeight', iptrw);
    RegisterProperty('OnWindowClosing', 'TInternetExplorerWindowClosing', iptrw);
    RegisterProperty('OnClientToHostWindow', 'TInternetExplorerClientToHostWindow', iptrw);
    RegisterProperty('OnSetSecureLockIcon', 'TInternetExplorerSetSecureLockIcon', iptrw);
    RegisterProperty('OnFileDownload', 'TInternetExplorerFileDownload', iptrw);
    RegisterProperty('OnNavigateError', 'TInternetExplorerNavigateError', iptrw);
    RegisterProperty('OnPrintTemplateInstantiation', 'TInternetExplorerPrintTemplateInstantiation', iptrw);
    RegisterProperty('OnPrintTemplateTeardown', 'TInternetExplorerPrintTemplateTeardown', iptrw);
    RegisterProperty('OnUpdatePageStatus', 'TInternetExplorerUpdatePageStatus', iptrw);
    RegisterProperty('OnPrivacyImpactedStateChange', 'TInternetExplorerPrivacyImpactedStateChange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoInternetExplorer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoInternetExplorer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoInternetExplorer') do
  begin
    RegisterMethod('Function Create : IWebBrowser2');
    RegisterMethod('Function CreateRemote( const MachineName : string) : IWebBrowser2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebBrowser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleControl', 'TWebBrowser') do
  with CL.AddClassN(CL.FindClass('TOleControl'),'TWebBrowser') do begin
    RegisterMethod('Procedure GoBack');
    RegisterMethod('Procedure GoForward');
    RegisterMethod('Procedure GoHome');
    RegisterMethod('Procedure GoSearch');
      RegisterMethod('Constructor Create(AOwner: TComponent)');
        RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Navigate( const URL : WideString);');

    RegisterMethod('Procedure Navigate7( const URL : WideString);');
    RegisterMethod('Procedure Navigate8( const URL : WideString; const Flags : OleVariant);');
    RegisterMethod('Procedure Navigate9( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant);');
    RegisterMethod('Procedure Navigate10( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant);');
    RegisterMethod('Procedure Navigate11( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant; const Headers : OleVariant);');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure Refresh212;');
    RegisterMethod('Procedure Refresh213( var Level : OleVariant);');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Quit');
    RegisterMethod('Procedure ClientToWindow( var pcx : SYSINT; var pcy : SYSINT)');
    RegisterMethod('Procedure PutProperty( const Property_ : WideString; vtValue : OleVariant)');
    RegisterMethod('Function GetProperty( const Property_ : WideString) : OleVariant');
    RegisterMethod('Procedure Navigate2( var URL : OleVariant);');

    RegisterMethod('Procedure Navigate214( var URL : OleVariant);');
    RegisterMethod('Procedure Navigate215( var URL : OleVariant; var Flags : OleVariant);');
    RegisterMethod('Procedure Navigate216( var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant);');
    RegisterMethod('Procedure Navigate217( var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant);');
    RegisterMethod('Procedure Navigate218( var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant; var Headers : OleVariant);');
    RegisterMethod('Function QueryStatusWB( cmdID : OLECMDID) : OLECMDF');
    RegisterMethod('Procedure ExecWB19( cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT);');
    RegisterMethod('Procedure ExecWB20( cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant);');
    RegisterMethod('Procedure ExecWB21( cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant; var pvaOut : OleVariant);');
    RegisterMethod('Procedure ShowBrowserBar22( var pvaClsid : OleVariant);');
    RegisterMethod('Procedure ShowBrowserBar23( var pvaClsid : OleVariant; var pvarShow : OleVariant);');
    RegisterMethod('Procedure ShowBrowserBar24( var pvaClsid : OleVariant; var pvarShow : OleVariant; var pvarSize : OleVariant);');
      RegisterPublishedProperties;
     RegisterProperty('Tabstop', 'BOOLEAN', iptrw);
    RegisterProperty('Align', 'TAlign', iptrw);
    RegisterProperty('ParentShowHint', 'BOOLEAN', iptrw);
    RegisterProperty('ShowHint', 'BOOLEAN', iptrw);

    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('GLYPH', 'TBITMAP', iptrw);
    RegisterProperty('LAYOUT', 'TBUTTONLAYOUT', iptrw);
    RegisterProperty('MARGIN', 'INTEGER', iptrw);
    RegisterProperty('NUMGLYPHS', 'BYTE', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('SPACING', 'INTEGER', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEnter', 'TMouseEvent', iptrw);
    RegisterProperty('ONExit', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);

    RegisterProperty('ControlInterface', 'IWebBrowser2', iptr);
    RegisterProperty('DefaultInterface', 'IWebBrowser2', iptr);
    RegisterProperty('Application', 'IDispatch', iptr);
    RegisterProperty('Parent', 'IDispatch', iptr);
    RegisterProperty('Container', 'IDispatch', iptr);
    RegisterProperty('Document', 'IDispatch', iptr);
    RegisterProperty('TopLevelContainer', 'WordBool', iptr);
    RegisterProperty('type_', 'WideString', iptr);
    RegisterProperty('LocationName', 'WideString', iptr);
    RegisterProperty('LocationURL', 'WideString', iptr);
    RegisterProperty('Busy', 'WordBool', iptr);
    RegisterProperty('Name', 'WideString', iptr);
    RegisterProperty('FullName', 'WideString', iptr);
    RegisterProperty('Path', 'WideString', iptr);
    RegisterProperty('Visible', 'WordBool', iptrw);
    RegisterProperty('StatusBar', 'WordBool', iptrw);
    RegisterProperty('StatusText', 'WideString', iptrw);
    RegisterProperty('ToolBar', 'Integer', iptrw);
    RegisterProperty('MenuBar', 'WordBool', iptrw);
    RegisterProperty('FullScreen', 'WordBool', iptrw);
    RegisterProperty('Offline', 'WordBool', iptrw);
    RegisterProperty('Silent', 'WordBool', iptrw);
    RegisterProperty('RegisterAsBrowser', 'WordBool', iptrw);
    RegisterProperty('RegisterAsDropTarget', 'WordBool', iptrw);
    RegisterProperty('TheaterMode', 'WordBool', iptrw);
    RegisterProperty('AddressBar', 'WordBool', iptrw);
    RegisterProperty('Resizable', 'WordBool', iptrw);
    RegisterProperty('OnStatusTextChange', 'TWebBrowserStatusTextChange', iptrw);
    RegisterProperty('OnProgressChange', 'TWebBrowserProgressChange', iptrw);
    RegisterProperty('OnCommandStateChange', 'TWebBrowserCommandStateChange', iptrw);
    RegisterProperty('OnDownloadBegin', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDownloadComplete', 'TNotifyEvent', iptrw);
    RegisterProperty('OnTitleChange', 'TWebBrowserTitleChange', iptrw);
    RegisterProperty('OnPropertyChange', 'TWebBrowserPropertyChange', iptrw);
    RegisterProperty('OnBeforeNavigate2', 'TWebBrowserBeforeNavigate2', iptrw);
    RegisterProperty('OnNewWindow2', 'TWebBrowserNewWindow2', iptrw);
    RegisterProperty('OnNavigateComplete2', 'TWebBrowserNavigateComplete2', iptrw);
    RegisterProperty('OnDocumentComplete', 'TWebBrowserDocumentComplete', iptrw);
    RegisterProperty('OnQuit', 'TNotifyEvent', iptrw);
    RegisterProperty('OnVisible', 'TWebBrowserOnVisible', iptrw);
    RegisterProperty('OnToolBar', 'TWebBrowserOnToolBar', iptrw);
    RegisterProperty('OnMenuBar', 'TWebBrowserOnMenuBar', iptrw);
    RegisterProperty('OnStatusBar', 'TWebBrowserOnStatusBar', iptrw);
    RegisterProperty('OnFullScreen', 'TWebBrowserOnFullScreen', iptrw);
    RegisterProperty('OnTheaterMode', 'TWebBrowserOnTheaterMode', iptrw);
    RegisterProperty('OnWindowSetResizable', 'TWebBrowserWindowSetResizable', iptrw);
    RegisterProperty('OnWindowSetLeft', 'TWebBrowserWindowSetLeft', iptrw);
    RegisterProperty('OnWindowSetTop', 'TWebBrowserWindowSetTop', iptrw);
    RegisterProperty('OnWindowSetWidth', 'TWebBrowserWindowSetWidth', iptrw);
    RegisterProperty('OnWindowSetHeight', 'TWebBrowserWindowSetHeight', iptrw);
    RegisterProperty('OnWindowClosing', 'TWebBrowserWindowClosing', iptrw);
    RegisterProperty('OnClientToHostWindow', 'TWebBrowserClientToHostWindow', iptrw);
    RegisterProperty('OnSetSecureLockIcon', 'TWebBrowserSetSecureLockIcon', iptrw);
    RegisterProperty('OnFileDownload', 'TWebBrowserFileDownload', iptrw);
    RegisterProperty('OnNavigateError', 'TWebBrowserNavigateError', iptrw);
    RegisterProperty('OnPrintTemplateInstantiation', 'TWebBrowserPrintTemplateInstantiation', iptrw);
    RegisterProperty('OnPrintTemplateTeardown', 'TWebBrowserPrintTemplateTeardown', iptrw);
    RegisterProperty('OnUpdatePageStatus', 'TWebBrowserUpdatePageStatus', iptrw);
    RegisterProperty('OnPrivacyImpactedStateChange', 'TWebBrowserPrivacyImpactedStateChange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebBrowser_V1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleControl', 'TWebBrowser_V1') do
  with CL.AddClassN(CL.FindClass('TOleControl'),'TWebBrowser_V1') do begin
    RegisterMethod('Procedure GoBack');
    RegisterMethod('Procedure GoForward');
    RegisterMethod('Procedure GoHome');
    RegisterMethod('Procedure GoSearch');
        RegisterMethod('Constructor Create(AOwner: TComponent)');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Navigate0( const URL : WideString);');
    RegisterMethod('Procedure Navigate1( const URL : WideString; const Flags : OleVariant);');
    RegisterMethod('Procedure Navigate2( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant);');
    RegisterMethod('Procedure Navigate3( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant);');
    RegisterMethod('Procedure Navigate4( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant; const Headers : OleVariant);');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Procedure Refresh25;');
    RegisterMethod('Procedure Refresh26( var Level : OleVariant);');
    RegisterMethod('Procedure Stop');
    RegisterProperty('ControlInterface', 'IWebBrowser', iptr);
    RegisterProperty('DefaultInterface', 'IWebBrowser', iptr);
    RegisterProperty('Application', 'IDispatch', iptr);
    RegisterProperty('Parent', 'IDispatch', iptr);
    RegisterProperty('Container', 'IDispatch', iptr);
    RegisterProperty('Document', 'IDispatch', iptr);
    RegisterProperty('TopLevelContainer', 'WordBool', iptr);
    RegisterProperty('type_', 'WideString', iptr);
    RegisterProperty('LocationName', 'WideString', iptr);
    RegisterProperty('LocationURL', 'WideString', iptr);
    RegisterProperty('Busy', 'WordBool', iptr);
    RegisterProperty('OnBeforeNavigate', 'TWebBrowser_V1BeforeNavigate', iptrw);
    RegisterProperty('OnNavigateComplete', 'TWebBrowser_V1NavigateComplete', iptrw);
    RegisterProperty('OnStatusTextChange', 'TWebBrowser_V1StatusTextChange', iptrw);
    RegisterProperty('OnProgressChange', 'TWebBrowser_V1ProgressChange', iptrw);
    RegisterProperty('OnDownloadComplete', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCommandStateChange', 'TWebBrowser_V1CommandStateChange', iptrw);
    RegisterProperty('OnDownloadBegin', 'TNotifyEvent', iptrw);
    RegisterProperty('OnNewWindow', 'TWebBrowser_V1NewWindow', iptrw);
    RegisterProperty('OnTitleChange', 'TWebBrowser_V1TitleChange', iptrw);
    RegisterProperty('OnFrameBeforeNavigate', 'TWebBrowser_V1FrameBeforeNavigate', iptrw);
    RegisterProperty('OnFrameNavigateComplete', 'TWebBrowser_V1FrameNavigateComplete', iptrw);
    RegisterProperty('OnFrameNewWindow', 'TWebBrowser_V1FrameNewWindow', iptrw);
    RegisterProperty('OnQuit', 'TWebBrowser_V1Quit', iptrw);
    RegisterProperty('OnWindowMove', 'TNotifyEvent', iptrw);
    RegisterProperty('OnWindowResize', 'TNotifyEvent', iptrw);
    RegisterProperty('OnWindowActivate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPropertyChange', 'TWebBrowser_V1PropertyChange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISearchAssistantOC3(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ISearchAssistantOC2', 'ISearchAssistantOC3') do
  with CL.AddInterface(CL.FindInterface('ISearchAssistantOC2'),ISearchAssistantOC3, 'ISearchAssistantOC3') do
  begin
    RegisterMethod('Function Get_SearchCompanionAvailable : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_UseSearchCompanion( pbUseSC : WordBool)', CdStdCall);
    RegisterMethod('Function Get_UseSearchCompanion : WordBool', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISearchAssistantOC2(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ISearchAssistantOC', 'ISearchAssistantOC2') do
  with CL.AddInterface(CL.FindInterface('ISearchAssistantOC'),ISearchAssistantOC2, 'ISearchAssistantOC2') do
  begin
    RegisterMethod('Function Get_ShowFindPrinter : WordBool', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISearchAssistantOC(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISearchAssistantOC') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISearchAssistantOC, 'ISearchAssistantOC') do
  begin
    RegisterMethod('Procedure AddNextMenuItem( const bstrText : WideString; idItem : Integer)', CdStdCall);
    RegisterMethod('Procedure SetDefaultSearchUrl( const bstrUrl : WideString)', CdStdCall);
    RegisterMethod('Procedure NavigateToDefaultSearch', CdStdCall);
    RegisterMethod('Function IsRestricted( const bstrGuid : WideString) : WordBool', CdStdCall);
    RegisterMethod('Function Get_ShellFeaturesEnabled : WordBool', CdStdCall);
    RegisterMethod('Function Get_SearchAssistantDefault : WordBool', CdStdCall);
    RegisterMethod('Function Get_Searches : ISearches', CdStdCall);
    RegisterMethod('Function Get_InWebFolder : WordBool', CdStdCall);
    RegisterMethod('Procedure PutProperty( bPerLocale : WordBool; const bstrName : WideString; const bstrValue : WideString)', CdStdCall);
    RegisterMethod('Function GetProperty( bPerLocale : WordBool; const bstrName : WideString) : WideString', CdStdCall);
    RegisterMethod('Procedure Set_EventHandled( Param1 : WordBool)', CdStdCall);
    RegisterMethod('Procedure ResetNextMenu', CdStdCall);
    RegisterMethod('Procedure FindOnWeb', CdStdCall);
    RegisterMethod('Procedure FindFilesOrFolders', CdStdCall);
    RegisterMethod('Procedure FindComputer', CdStdCall);
    RegisterMethod('Procedure FindPrinter', CdStdCall);
    RegisterMethod('Procedure FindPeople', CdStdCall);
    RegisterMethod('Function GetSearchAssistantURL( bSubstitute : WordBool; bCustomize : WordBool) : WideString', CdStdCall);
    RegisterMethod('Procedure NotifySearchSettingsChanged', CdStdCall);
    RegisterMethod('Procedure Set_ASProvider( const pProvider : WideString)', CdStdCall);
    RegisterMethod('Function Get_ASProvider : WideString', CdStdCall);
    RegisterMethod('Procedure Set_ASSetting( pSetting : SYSINT)', CdStdCall);
    RegisterMethod('Function Get_ASSetting : SYSINT', CdStdCall);
    RegisterMethod('Procedure NETDetectNextNavigate', CdStdCall);
    RegisterMethod('Procedure PutFindText( const FindText : WideString)', CdStdCall);
    RegisterMethod('Function Get_Version : SYSINT', CdStdCall);
    RegisterMethod('Function EncodeString( const bstrValue : WideString; const bstrCharSet : WideString; bUseUTF8 : WordBool) : WideString', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISearches(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISearches') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISearches, 'ISearches') do
  begin
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Get_Default : WideString', CdStdCall);
    RegisterMethod('Function Item( index : OleVariant) : ISearch', CdStdCall);
    RegisterMethod('Function _NewEnum : IUnknown', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISearch(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISearch') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISearch, 'ISearch') do
  begin
    RegisterMethod('Function Get_Title : WideString', CdStdCall);
    RegisterMethod('Function Get_Id : WideString', CdStdCall);
    RegisterMethod('Function Get_URL : WideString', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IScriptErrorList(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IScriptErrorList') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IScriptErrorList, 'IScriptErrorList') do
  begin
    RegisterMethod('Procedure advanceError', CdStdCall);
    RegisterMethod('Procedure retreatError', CdStdCall);
    RegisterMethod('Function canAdvanceError : Integer', CdStdCall);
    RegisterMethod('Function canRetreatError : Integer', CdStdCall);
    RegisterMethod('Function getErrorLine : Integer', CdStdCall);
    RegisterMethod('Function getErrorChar : Integer', CdStdCall);
    RegisterMethod('Function getErrorCode : Integer', CdStdCall);
    RegisterMethod('Function getErrorMsg : WideString', CdStdCall);
    RegisterMethod('Function getErrorUrl : WideString', CdStdCall);
    RegisterMethod('Function getAlwaysShowLockState : Integer', CdStdCall);
    RegisterMethod('Function getDetailsPaneOpen : Integer', CdStdCall);
    RegisterMethod('Procedure setDetailsPaneOpen( fDetailsPaneOpen : Integer)', CdStdCall);
    RegisterMethod('Function getPerErrorDisplay : Integer', CdStdCall);
    RegisterMethod('Procedure setPerErrorDisplay( fPerErrorDisplay : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IShellNameSpace(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IShellFavoritesNameSpace', 'IShellNameSpace') do
  with CL.AddInterface(CL.FindInterface('IShellFavoritesNameSpace'),IShellNameSpace, 'IShellNameSpace') do
  begin
    RegisterMethod('Function Get_EnumOptions : Integer', CdStdCall);
    RegisterMethod('Procedure Set_EnumOptions( pgrfEnumFlags : Integer)', CdStdCall);
    RegisterMethod('Function Get_SelectedItem : IDispatch', CdStdCall);
    RegisterMethod('Procedure Set_SelectedItem( const pItem : IDispatch)', CdStdCall);
    RegisterMethod('Function Get_Root : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Root( pvar : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Depth : SYSINT', CdStdCall);
    RegisterMethod('Procedure Set_Depth( piDepth : SYSINT)', CdStdCall);
    RegisterMethod('Function Get_Mode : SYSUINT', CdStdCall);
    RegisterMethod('Procedure Set_Mode( puMode : SYSUINT)', CdStdCall);
    RegisterMethod('Function Get_Flags : LongWord', CdStdCall);
    RegisterMethod('Procedure Set_Flags( pdwFlags : LongWord)', CdStdCall);
    RegisterMethod('Procedure Set_TVFlags( dwFlags : LongWord)', CdStdCall);
    RegisterMethod('Function Get_TVFlags : LongWord', CdStdCall);
    RegisterMethod('Function Get_Columns : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Columns( const bstrColumns : WideString)', CdStdCall);
    RegisterMethod('Function Get_CountViewTypes : SYSINT', CdStdCall);
    RegisterMethod('Procedure SetViewType( iType : SYSINT)', CdStdCall);
    RegisterMethod('Function SelectedItems : IDispatch', CdStdCall);
    RegisterMethod('Procedure Expand( var_ : OleVariant; iDepth : SYSINT)', CdStdCall);
    RegisterMethod('Procedure UnselectAll', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IShellFavoritesNameSpace(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IShellFavoritesNameSpace') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IShellFavoritesNameSpace, 'IShellFavoritesNameSpace') do
  begin
    RegisterMethod('Procedure MoveSelectionUp', CdStdCall);
    RegisterMethod('Procedure MoveSelectionDown', CdStdCall);
    RegisterMethod('Procedure ResetSort', CdStdCall);
    RegisterMethod('Procedure NewFolder', CdStdCall);
    RegisterMethod('Procedure Synchronize', CdStdCall);
    RegisterMethod('Procedure Import', CdStdCall);
    RegisterMethod('Procedure InvokeContextMenuCommand( const strCommand : WideString)', CdStdCall);
    RegisterMethod('Procedure MoveSelectionTo', CdStdCall);
    RegisterMethod('Function Get_SubscriptionsEnabled : WordBool', CdStdCall);
    RegisterMethod('Function CreateSubscriptionForSelection : WordBool', CdStdCall);
    RegisterMethod('Function DeleteSubscriptionForSelection : WordBool', CdStdCall);
    RegisterMethod('Procedure SetRoot( const bstrFullPath : WideString)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IShellUIHelper(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IShellUIHelper') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IShellUIHelper, 'IShellUIHelper') do
  begin
    RegisterMethod('Procedure ResetFirstBootMode', CdStdCall);
    RegisterMethod('Procedure ResetSafeMode', CdStdCall);
    RegisterMethod('Procedure RefreshOfflineDesktop', CdStdCall);
    RegisterMethod('Procedure AddFavorite( const URL : WideString; var Title : OleVariant)', CdStdCall);
    RegisterMethod('Procedure AddChannel( const URL : WideString)', CdStdCall);
    RegisterMethod('Procedure AddDesktopComponent( const URL : WideString; const Type_ : WideString; var Left : OleVariant; var Top : OleVariant; var Width : OleVariant; var Height : OleVariant)', CdStdCall);
    RegisterMethod('Function IsSubscribed( const URL : WideString) : WordBool', CdStdCall);
    RegisterMethod('Procedure NavigateAndFind( const URL : WideString; const strQuery : WideString; var varTargetFrame : OleVariant)', CdStdCall);
    RegisterMethod('Procedure ImportExportFavorites( fImport : WordBool; const strImpExpPath : WideString)', CdStdCall);
    RegisterMethod('Procedure AutoCompleteSaveForm( var Form : OleVariant)', CdStdCall);
    RegisterMethod('Procedure AutoScan( const strSearch : WideString; const strFailureUrl : WideString; var pvarTargetFrame : OleVariant)', CdStdCall);
    RegisterMethod('Procedure AutoCompleteAttach( var Reserved : OleVariant)', CdStdCall);
    RegisterMethod('Function ShowBrowserUI( const bstrName : WideString; var pvarIn : OleVariant) : OleVariant', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IShellWindows(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IShellWindows') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IShellWindows, 'IShellWindows') do
  begin
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Item( index : OleVariant) : IDispatch', CdStdCall);
    RegisterMethod('Function _NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Procedure Register( const pid : IDispatch; hWnd : Integer; swClass : SYSINT; out plCookie : Integer)', CdStdCall);
    RegisterMethod('Procedure RegisterPending( lThreadId : Integer; var pvarloc : OleVariant; var pvarlocRoot : OleVariant; swClass : SYSINT; out plCookie : Integer)', CdStdCall);
    RegisterMethod('Procedure Revoke( lCookie : Integer)', CdStdCall);
    RegisterMethod('Procedure OnNavigate( lCookie : Integer; var pvarloc : OleVariant)', CdStdCall);
    RegisterMethod('Procedure OnActivated( lCookie : Integer; fActive : WordBool)', CdStdCall);
    RegisterMethod('Function FindWindowSW( var pvarloc : OleVariant; var pvarlocRoot : OleVariant; swClass : SYSINT; out pHWND : Integer; swfwOptions : SYSINT) : IDispatch', CdStdCall);
    RegisterMethod('Procedure OnCreated( lCookie : Integer; const punk : IUnknown)', CdStdCall);
    RegisterMethod('Procedure ProcessAttachDetach( fAttach : WordBool)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWebBrowser2(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IWebBrowserApp', 'IWebBrowser2') do
  with CL.AddInterface(CL.FindInterface('IWebBrowserApp'),IWebBrowser2, 'IWebBrowser2') do
  begin
    RegisterMethod('Procedure Navigate2( const URL : OleVariant; const Flags : OleVariant; const TargetFrameName : OleVariant; const PostData : OleVariant; const Headers : OleVariant)', CdStdCall);
    RegisterMethod('Function QueryStatusWB( cmdID : OLECMDID) : OLECMDF', CdStdCall);
    RegisterMethod('Procedure ExecWB( cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant; var pvaOut : OleVariant)', CdStdCall);
    RegisterMethod('Procedure ShowBrowserBar( var pvaClsid : OleVariant; var pvarShow : OleVariant; var pvarSize : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_ReadyState : tagREADYSTATE', CdStdCall);
    RegisterMethod('Function Get_Offline : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_Offline( pbOffline : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Silent : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_Silent( pbSilent : WordBool)', CdStdCall);
    RegisterMethod('Function Get_RegisterAsBrowser : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_RegisterAsBrowser( pbRegister : WordBool)', CdStdCall);
    RegisterMethod('Function Get_RegisterAsDropTarget : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_RegisterAsDropTarget( pbRegister : WordBool)', CdStdCall);
    RegisterMethod('Function Get_TheaterMode : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_TheaterMode( pbRegister : WordBool)', CdStdCall);
    RegisterMethod('Function Get_AddressBar : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_AddressBar( Value : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Resizable : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_Resizable( Value : WordBool)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWebBrowserApp(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IWebBrowser', 'IWebBrowserApp') do
  with CL.AddInterface(CL.FindInterface('IWebBrowser'),IWebBrowserApp, 'IWebBrowserApp') do
  begin
    RegisterMethod('Procedure Quit', CdStdCall);
    RegisterMethod('Procedure ClientToWindow( var pcx : SYSINT; var pcy : SYSINT)', CdStdCall);
    RegisterMethod('Procedure PutProperty( const Property_ : WideString; vtValue : OleVariant)', CdStdCall);
    RegisterMethod('Function GetProperty( const Property_ : WideString) : OleVariant', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_HWnd : Integer', CdStdCall);
    RegisterMethod('Function Get_FullName : WideString', CdStdCall);
    RegisterMethod('Function Get_Path : WideString', CdStdCall);
    RegisterMethod('Function Get_Visible : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_Visible( pBool : WordBool)', CdStdCall);
    RegisterMethod('Function Get_StatusBar : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_StatusBar( pBool : WordBool)', CdStdCall);
    RegisterMethod('Function Get_StatusText : WideString', CdStdCall);
    RegisterMethod('Procedure Set_StatusText( const StatusText : WideString)', CdStdCall);
    RegisterMethod('Function Get_ToolBar : SYSINT', CdStdCall);
    RegisterMethod('Procedure Set_ToolBar( Value : SYSINT)', CdStdCall);
    RegisterMethod('Function Get_MenuBar : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_MenuBar( Value : WordBool)', CdStdCall);
    RegisterMethod('Function Get_FullScreen : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_FullScreen( pbFullScreen : WordBool)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWebBrowser(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IWebBrowser') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IWebBrowser, 'IWebBrowser') do
  begin
    RegisterMethod('Procedure GoBack', CdStdCall);
    RegisterMethod('Procedure GoForward', CdStdCall);
    RegisterMethod('Procedure GoHome', CdStdCall);
    RegisterMethod('Procedure GoSearch', CdStdCall);
    RegisterMethod('Procedure Navigate( const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant; const Headers : OleVariant)', CdStdCall);
    RegisterMethod('Procedure Refresh', CdStdCall);
    RegisterMethod('Procedure Refresh2( var Level : OleVariant)', CdStdCall);
    RegisterMethod('Procedure Stop', CdStdCall);
    RegisterMethod('Function Get_Application : IDispatch', CdStdCall);
    RegisterMethod('Function Get_Parent : IDispatch', CdStdCall);
    RegisterMethod('Function Get_Container : IDispatch', CdStdCall);
    RegisterMethod('Function Get_Document : IDispatch', CdStdCall);
    RegisterMethod('Function Get_TopLevelContainer : WordBool', CdStdCall);
    RegisterMethod('Function Get_type_ : WideString', CdStdCall);
    RegisterMethod('Function Get_Left : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Left( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_Top : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Top( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_Width : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Width( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_Height : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Height( pl : Integer)', CdStdCall);
    RegisterMethod('Function Get_LocationName : WideString', CdStdCall);
    RegisterMethod('Function Get_LocationURL : WideString', CdStdCall);
    RegisterMethod('Function Get_Busy : WordBool', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SHDocVw(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('CGID_IWebBrowser','TGUID').SetString( '{ED016940-BD5B-11CF-BA4E-00C04FD70816}');
 CL.AddConstantN('HTMLID_FIND','LongInt').SetInt( 1);
 CL.AddConstantN('HTMLID_VIEWSOURCE','LongInt').SetInt( 2);
 CL.AddConstantN('HTMLID_OPTIONS','LongInt').SetInt( 3);
 CL.AddConstantN('SHDocVwMajorVersion','LongInt').SetInt( 1);
 CL.AddConstantN('SHDocVwMinorVersion','LongInt').SetInt( 1);
 (*CL.AddConstantN('LIBID_SHDocVw','TGUID').SetString( '{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}');
 CL.AddConstantN('IID_IWebBrowser','TGUID').SetString( '{EAB22AC1-30C1-11CF-A7EB-0000C05BAE0B}');
 CL.AddConstantN('DIID_DWebBrowserEvents','TGUID').SetString( '{EAB22AC2-30C1-11CF-A7EB-0000C05BAE0B}');
 CL.AddConstantN('IID_IWebBrowserApp','TGUID').SetString( '{0002DF05-0000-0000-C000-000000000046}');
 CL.AddConstantN('IID_IWebBrowser2','TGUID').SetString( '{D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}');
 CL.AddConstantN('DIID_DWebBrowserEvents2','TGUID').SetString( '{34A715A0-6587-11D0-924A-0020AFC7AC4D}');
 CL.AddConstantN('CLASS_WebBrowser_V1','TGUID').SetString( '{EAB22AC3-30C1-11CF-A7EB-0000C05BAE0B}');
 CL.AddConstantN('CLASS_WebBrowser','TGUID').SetString( '{8856F961-340A-11D0-A96B-00C04FD705A2}');
 CL.AddConstantN('CLASS_InternetExplorer','TGUID').SetString( '{0002DF01-0000-0000-C000-000000000046}');
 CL.AddConstantN('CLASS_ShellBrowserWindow','TGUID').SetString( '{C08AFD90-F2A1-11D1-8455-00A0C91F3880}');
 CL.AddConstantN('DIID_DShellWindowsEvents','TGUID').SetString( '{FE4106E0-399A-11D0-A48C-00A0C90A8F39}');
 CL.AddConstantN('IID_IShellWindows','TGUID').SetString( '{85CB6900-4D95-11CF-960C-0080C7F4EE85}');
 CL.AddConstantN('CLASS_ShellWindows','TGUID').SetString( '{9BA05972-F6A8-11CF-A442-00A0C90A8F39}');
 CL.AddConstantN('IID_IShellUIHelper','TGUID').SetString( '{729FE2F8-1EA8-11D1-8F85-00C04FC2FBE1}');
 CL.AddConstantN('CLASS_ShellUIHelper','TGUID').SetString( '{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}');
 CL.AddConstantN('DIID_DShellNameSpaceEvents','TGUID').SetString( '{55136806-B2DE-11D1-B9F2-00A0C98BC547}');
 CL.AddConstantN('IID_IShellFavoritesNameSpace','TGUID').SetString( '{55136804-B2DE-11D1-B9F2-00A0C98BC547}');
 CL.AddConstantN('IID_IShellNameSpace','TGUID').SetString( '{E572D3C9-37BE-4AE2-825D-D521763E3108}');
 CL.AddConstantN('CLASS_ShellNameSpace','TGUID').SetString( '{55136805-B2DE-11D1-B9F2-00A0C98BC547}');
 CL.AddConstantN('IID_IScriptErrorList','TGUID').SetString( '{F3470F24-15FD-11D2-BB2E-00805FF7EFCA}');
 CL.AddConstantN('CLASS_CScriptErrorList','TGUID').SetString( '{EFD01300-160F-11D2-BB2E-00805FF7EFCA}');
 CL.AddConstantN('IID_ISearch','TGUID').SetString( '{BA9239A4-3DD5-11D2-BF8B-00C04FB93661}');
 CL.AddConstantN('IID_ISearches','TGUID').SetString( '{47C922A2-3DD5-11D2-BF8B-00C04FB93661}');
 CL.AddConstantN('IID_ISearchAssistantOC','TGUID').SetString( '{72423E8F-8011-11D2-BE79-00A0C9A83DA1}');
 CL.AddConstantN('IID_ISearchAssistantOC2','TGUID').SetString( '{72423E8F-8011-11D2-BE79-00A0C9A83DA2}');
 CL.AddConstantN('IID_ISearchAssistantOC3','TGUID').SetString( '{72423E8F-8011-11D2-BE79-00A0C9A83DA3}');
 CL.AddConstantN('DIID__SearchAssistantEvents','TGUID').SetString( '{1611FDDA-445B-11D2-85DE-00C04FA35C89}');
 CL.AddConstantN('CLASS_SearchAssistantOC','TGUID').SetString( '{B45FF030-4447-11D2-85DE-00C04FA35C89}');
 }*)
  CL.AddTypeS('CommandStateChangeConstants', 'TOleEnum');
 CL.AddConstantN('CSC_UPDATECOMMANDS','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('CSC_NAVIGATEFORWARD','LongWord').SetUInt( $00000001);
 CL.AddConstantN('CSC_NAVIGATEBACK','LongWord').SetUInt( $00000002);
  CL.AddTypeS('OLECMDID', 'TOleEnum');
 CL.AddConstantN('OLECMDID_OPEN','LongWord').SetUInt( $00000001);
 CL.AddConstantN('OLECMDID_NEW','LongWord').SetUInt( $00000002);
 CL.AddConstantN('OLECMDID_SAVE','LongWord').SetUInt( $00000003);
 CL.AddConstantN('OLECMDID_SAVEAS','LongWord').SetUInt( $00000004);
 CL.AddConstantN('OLECMDID_SAVECOPYAS','LongWord').SetUInt( $00000005);
 CL.AddConstantN('OLECMDID_PRINT','LongWord').SetUInt( $00000006);
 CL.AddConstantN('OLECMDID_PRINTPREVIEW','LongWord').SetUInt( $00000007);
 CL.AddConstantN('OLECMDID_PAGESETUP','LongWord').SetUInt( $00000008);
 CL.AddConstantN('OLECMDID_SPELL','LongWord').SetUInt( $00000009);
 CL.AddConstantN('OLECMDID_PROPERTIES','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('OLECMDID_CUT','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('OLECMDID_COPY','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('OLECMDID_PASTE','LongWord').SetUInt( $0000000D);
 CL.AddConstantN('OLECMDID_PASTESPECIAL','LongWord').SetUInt( $0000000E);
 CL.AddConstantN('OLECMDID_UNDO','LongWord').SetUInt( $0000000F);
 CL.AddConstantN('OLECMDID_REDO','LongWord').SetUInt( $00000010);
 CL.AddConstantN('OLECMDID_SELECTALL','LongWord').SetUInt( $00000011);
 CL.AddConstantN('OLECMDID_CLEARSELECTION','LongWord').SetUInt( $00000012);
 CL.AddConstantN('OLECMDID_ZOOM','LongWord').SetUInt( $00000013);
 CL.AddConstantN('OLECMDID_GETZOOMRANGE','LongWord').SetUInt( $00000014);
 CL.AddConstantN('OLECMDID_UPDATECOMMANDS','LongWord').SetUInt( $00000015);
 CL.AddConstantN('OLECMDID_REFRESH','LongWord').SetUInt( $00000016);
 CL.AddConstantN('OLECMDID_STOP','LongWord').SetUInt( $00000017);
 CL.AddConstantN('OLECMDID_HIDETOOLBARS','LongWord').SetUInt( $00000018);
 CL.AddConstantN('OLECMDID_SETPROGRESSMAX','LongWord').SetUInt( $00000019);
 CL.AddConstantN('OLECMDID_SETPROGRESSPOS','LongWord').SetUInt( $0000001A);
 CL.AddConstantN('OLECMDID_SETPROGRESSTEXT','LongWord').SetUInt( $0000001B);
 CL.AddConstantN('OLECMDID_SETTITLE','LongWord').SetUInt( $0000001C);
 CL.AddConstantN('OLECMDID_SETDOWNLOADSTATE','LongWord').SetUInt( $0000001D);
 CL.AddConstantN('OLECMDID_STOPDOWNLOAD','LongWord').SetUInt( $0000001E);
 CL.AddConstantN('OLECMDID_ONTOOLBARACTIVATED','LongWord').SetUInt( $0000001F);
 CL.AddConstantN('OLECMDID_FIND','LongWord').SetUInt( $00000020);
 CL.AddConstantN('OLECMDID_DELETE','LongWord').SetUInt( $00000021);
 CL.AddConstantN('OLECMDID_HTTPEQUIV','LongWord').SetUInt( $00000022);
 CL.AddConstantN('OLECMDID_HTTPEQUIV_DONE','LongWord').SetUInt( $00000023);
 CL.AddConstantN('OLECMDID_ENABLE_INTERACTION','LongWord').SetUInt( $00000024);
 CL.AddConstantN('OLECMDID_ONUNLOAD','LongWord').SetUInt( $00000025);
 CL.AddConstantN('OLECMDID_PROPERTYBAG2','LongWord').SetUInt( $00000026);
 CL.AddConstantN('OLECMDID_PREREFRESH','LongWord').SetUInt( $00000027);
 CL.AddConstantN('OLECMDID_SHOWSCRIPTERROR','LongWord').SetUInt( $00000028);
 CL.AddConstantN('OLECMDID_SHOWMESSAGE','LongWord').SetUInt( $00000029);
 CL.AddConstantN('OLECMDID_SHOWFIND','LongWord').SetUInt( $0000002A);
 CL.AddConstantN('OLECMDID_SHOWPAGESETUP','LongWord').SetUInt( $0000002B);
 CL.AddConstantN('OLECMDID_SHOWPRINT','LongWord').SetUInt( $0000002C);
 CL.AddConstantN('OLECMDID_CLOSE','LongWord').SetUInt( $0000002D);
 CL.AddConstantN('OLECMDID_ALLOWUILESSSAVEAS','LongWord').SetUInt( $0000002E);
 CL.AddConstantN('OLECMDID_DONTDOWNLOADCSS','LongWord').SetUInt( $0000002F);
 CL.AddConstantN('OLECMDID_UPDATEPAGESTATUS','LongWord').SetUInt( $00000030);
 CL.AddConstantN('OLECMDID_PRINT2','LongWord').SetUInt( $00000031);
 CL.AddConstantN('OLECMDID_PRINTPREVIEW2','LongWord').SetUInt( $00000032);
 CL.AddConstantN('OLECMDID_SETPRINTTEMPLATE','LongWord').SetUInt( $00000033);
 CL.AddConstantN('OLECMDID_GETPRINTTEMPLATE','LongWord').SetUInt( $00000034);
  CL.AddTypeS('OLECMDF', 'TOleEnum');
 CL.AddConstantN('OLECMDF_SUPPORTED','LongWord').SetUInt( $00000001);
 CL.AddConstantN('OLECMDF_ENABLED','LongWord').SetUInt( $00000002);
 CL.AddConstantN('OLECMDF_LATCHED','LongWord').SetUInt( $00000004);
 CL.AddConstantN('OLECMDF_NINCHED','LongWord').SetUInt( $00000008);
 CL.AddConstantN('OLECMDF_INVISIBLE','LongWord').SetUInt( $00000010);
 CL.AddConstantN('OLECMDF_DEFHIDEONCTXTMENU','LongWord').SetUInt( $00000020);
  CL.AddTypeS('OLECMDEXECOPT', 'TOleEnum');
 CL.AddConstantN('OLECMDEXECOPT_DODEFAULT','LongWord').SetUInt( $00000000);
 CL.AddConstantN('OLECMDEXECOPT_PROMPTUSER','LongWord').SetUInt( $00000001);
 CL.AddConstantN('OLECMDEXECOPT_DONTPROMPTUSER','LongWord').SetUInt( $00000002);
 CL.AddConstantN('OLECMDEXECOPT_SHOWHELP','LongWord').SetUInt( $00000003);
  CL.AddTypeS('tagREADYSTATE', 'TOleEnum');
 CL.AddConstantN('READYSTATE_UNINITIALIZED','LongWord').SetUInt( $00000000);
 CL.AddConstantN('READYSTATE_LOADING','LongWord').SetUInt( $00000001);
 CL.AddConstantN('READYSTATE_LOADED','LongWord').SetUInt( $00000002);
 CL.AddConstantN('READYSTATE_INTERACTIVE','LongWord').SetUInt( $00000003);
 CL.AddConstantN('READYSTATE_COMPLETE','LongWord').SetUInt( $00000004);
  CL.AddTypeS('SecureLockIconConstants', 'TOleEnum');
 CL.AddConstantN('secureLockIconUnsecure','LongWord').SetUInt( $00000000);
 CL.AddConstantN('secureLockIconMixed','LongWord').SetUInt( $00000001);
 CL.AddConstantN('secureLockIconSecureUnknownBits','LongWord').SetUInt( $00000002);
 CL.AddConstantN('secureLockIconSecure40Bit','LongWord').SetUInt( $00000003);
 CL.AddConstantN('secureLockIconSecure56Bit','LongWord').SetUInt( $00000004);
 CL.AddConstantN('secureLockIconSecureFortezza','LongWord').SetUInt( $00000005);
 CL.AddConstantN('secureLockIconSecure128Bit','LongWord').SetUInt( $00000006);
  CL.AddTypeS('ShellWindowTypeConstants', 'TOleEnum');
 CL.AddConstantN('SWC_EXPLORER','LongWord').SetUInt( $00000000);
 CL.AddConstantN('SWC_BROWSER','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SWC_3RDPARTY','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SWC_CALLBACK','LongWord').SetUInt( $00000004);
  CL.AddTypeS('ShellWindowFindWindowOptions', 'TOleEnum');
 CL.AddConstantN('SWFO_NEEDDISPATCH','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SWFO_INCLUDEPENDING','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SWFO_COOKIEPASSED','LongWord').SetUInt( $00000004);
  CL.AddTypeS('RefreshConstants', 'TOleEnum');
 CL.AddConstantN('REFRESH_NORMAL','LongInt').SetInt( 0);
 CL.AddConstantN('REFRESH_IFEXPIRED','LongInt').SetInt( 1);
 CL.AddConstantN('REFRESH_CONTINUE','LongInt').SetInt( 2);
 CL.AddConstantN('REFRESH_COMPLETELY','LongInt').SetInt( 3);
  CL.AddTypeS('BrowserNavConstants', 'TOleEnum');
 CL.AddConstantN('navOpenInNewWindow','LongWord').SetUInt( $00000001);
 CL.AddConstantN('navNoHistory','LongWord').SetUInt( $00000002);
 CL.AddConstantN('navNoReadFromCache','LongWord').SetUInt( $00000004);
 CL.AddConstantN('navNoWriteToCache','LongWord').SetUInt( $00000008);
 CL.AddConstantN('navAllowAutosearch','LongWord').SetUInt( $00000010);
 CL.AddConstantN('navBrowserBar','LongWord').SetUInt( $00000020);
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IWebBrowser, 'IWebBrowser');
  //CL.AddTypeS('IWebBrowserDisp', 'dispinterface');
  //CL.AddTypeS('DWebBrowserEvents', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IWebBrowserApp, 'IWebBrowserApp');
  //CL.AddTypeS('IWebBrowserAppDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IWebBrowser2, 'IWebBrowser2');
  //CL.AddTypeS('IWebBrowser2Disp', 'dispinterface');
  //CL.AddTypeS('DWebBrowserEvents2', 'dispinterface');
  //CL.AddTypeS('DShellWindowsEvents', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IShellWindows, 'IShellWindows');
  //CL.AddTypeS('IShellWindowsDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IShellUIHelper, 'IShellUIHelper');
  //CL.AddTypeS('IShellUIHelperDisp', 'dispinterface');
  //CL.AddTypeS('DShellNameSpaceEvents', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IShellFavoritesNameSpace, 'IShellFavoritesNameSpace');
  //CL.AddTypeS('IShellFavoritesNameSpaceDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IShellNameSpace, 'IShellNameSpace');
  //CL.AddTypeS('IShellNameSpaceDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IScriptErrorList, 'IScriptErrorList');
  //CL.AddTypeS('IScriptErrorListDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISearch, 'ISearch');
  //CL.AddTypeS('ISearchDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISearches, 'ISearches');
  //CL.AddTypeS('ISearchesDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISearchAssistantOC, 'ISearchAssistantOC');
  //CL.AddTypeS('ISearchAssistantOCDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISearchAssistantOC2, 'ISearchAssistantOC2');
  //CL.AddTypeS('ISearchAssistantOC2Disp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISearchAssistantOC3, 'ISearchAssistantOC3');
  //CL.AddTypeS('ISearchAssistantOC3Disp', 'dispinterface');
  //CL.AddTypeS('_SearchAssistantEvents', 'dispinterface');
  CL.AddTypeS('WebBrowser_V1', 'IWebBrowser');
  CL.AddTypeS('WebBrowser', 'IWebBrowser2');
  CL.AddTypeS('InternetExplorer', 'IWebBrowser2');
  CL.AddTypeS('ShellBrowserWindow', 'IWebBrowser2');
  CL.AddTypeS('ShellWindows', 'IShellWindows');
  CL.AddTypeS('ShellUIHelper', 'IShellUIHelper');
  CL.AddTypeS('ShellNameSpace', 'IShellNameSpace');
  CL.AddTypeS('CScriptErrorList', 'IScriptErrorList');
  CL.AddTypeS('SearchAssistantOC', 'ISearchAssistantOC3');
  //CL.AddTypeS('POleVariant1', '^OleVariant // will not work');
  SIRegister_IWebBrowser(CL);
  SIRegister_IWebBrowserApp(CL);
  SIRegister_IWebBrowser2(CL);
  SIRegister_IShellWindows(CL);
  SIRegister_IShellUIHelper(CL);
  SIRegister_IShellFavoritesNameSpace(CL);
  SIRegister_IShellNameSpace(CL);
  SIRegister_IScriptErrorList(CL);
  SIRegister_ISearch(CL);
  SIRegister_ISearches(CL);
  SIRegister_ISearchAssistantOC(CL);
  SIRegister_ISearchAssistantOC2(CL);
  SIRegister_ISearchAssistantOC3(CL);
  SIRegister_TWebBrowser_V1(CL);
  CL.AddTypeS('TWebBrowserStatusTextChange', 'Procedure ( ASender : TObject; co'
   +'nst Text : WideString)');
  CL.AddTypeS('TWebBrowserProgressChange', 'Procedure ( ASender : TObject; Prog'
   +'ress : Integer; ProgressMax : Integer)');
  CL.AddTypeS('TWebBrowserCommandStateChange', 'Procedure ( ASender : TObject; '
   +'Command : Integer; Enable : WordBool)');
  CL.AddTypeS('TWebBrowserTitleChange', 'Procedure ( ASender : TObject; const T'
   +'ext : WideString)');
  CL.AddTypeS('TWebBrowserPropertyChange', 'Procedure ( ASender : TObject; cons'
   +'t szProperty : WideString)');
  CL.AddTypeS('TWebBrowserBeforeNavigate2', 'Procedure ( ASender : TObject; con'
   +'st pDisp : IDispatch; var URL : OleVariant; var Flags : OleVariant; var Ta'
   +'rgetFrameName : OleVariant; var PostData : OleVariant; var Headers : OleVa'
   +'riant; var Cancel : WordBool)');
  CL.AddTypeS('TWebBrowserNewWindow2', 'Procedure ( ASender : TObject; var ppDi'
   +'sp : IDispatch; var Cancel : WordBool)');
  CL.AddTypeS('TWebBrowserNavigateComplete2', 'Procedure ( ASender : TObject; c'
   +'onst pDisp : IDispatch; var URL : OleVariant)');
  CL.AddTypeS('TWebBrowserDocumentComplete', 'Procedure ( ASender : TObject; co'
   +'nst pDisp : IDispatch; var URL : OleVariant)');
  CL.AddTypeS('TWebBrowserOnVisible', 'Procedure ( ASender : TObject; Visible :'
   +' WordBool)');
  CL.AddTypeS('TWebBrowserOnToolBar', 'Procedure ( ASender : TObject; ToolBar :'
   +' WordBool)');
  CL.AddTypeS('TWebBrowserOnMenuBar', 'Procedure ( ASender : TObject; MenuBar :'
   +' WordBool)');
  CL.AddTypeS('TWebBrowserOnStatusBar', 'Procedure ( ASender : TObject; StatusB'
   +'ar : WordBool)');
  CL.AddTypeS('TWebBrowserOnFullScreen', 'Procedure ( ASender : TObject; FullSc'
   +'reen : WordBool)');
  CL.AddTypeS('TWebBrowserOnTheaterMode', 'Procedure ( ASender : TObject; Theat'
   +'erMode : WordBool)');
  CL.AddTypeS('TWebBrowserWindowSetResizable', 'Procedure ( ASender : TObject; '
   +'Resizable : WordBool)');
  CL.AddTypeS('TWebBrowserWindowSetLeft', 'Procedure ( ASender : TObject; Left '
   +': Integer)');
  CL.AddTypeS('TWebBrowserWindowSetTop', 'Procedure ( ASender : TObject; Top : Integer)');
  CL.AddTypeS('TWebBrowserWindowSetWidth', 'Procedure ( ASender : TObject; Widt'
   +'h : Integer)');
  CL.AddTypeS('TWebBrowserWindowSetHeight', 'Procedure ( ASender : TObject; Hei'
   +'ght : Integer)');
  CL.AddTypeS('TWebBrowserWindowClosing', 'Procedure ( ASender : TObject; IsChi'
   +'ldWindow : WordBool; var Cancel : WordBool)');
  CL.AddTypeS('TWebBrowserClientToHostWindow', 'Procedure ( ASender : TObject; '
   +'var CX : Integer; var CY : Integer)');
  CL.AddTypeS('TWebBrowserSetSecureLockIcon', 'Procedure ( ASender : TObject; S'
   +'ecureLockIcon : Integer)');
  CL.AddTypeS('TWebBrowserFileDownload', 'Procedure ( ASender : TObject; var Cancel : WordBool)');
  CL.AddTypeS('TWebBrowserNavigateError', 'Procedure ( ASender : TObject; const'
   +' pDisp : IDispatch; var URL : OleVariant; var Frame : OleVariant; var Stat'
   +'usCode : OleVariant; var Cancel : WordBool)');
  CL.AddTypeS('TWebBrowserPrintTemplateInstantiation', 'Procedure ( ASender : T'
   +'Object; const pDisp : IDispatch)');
  CL.AddTypeS('TWebBrowserPrintTemplateTeardown', 'Procedure ( ASender : TObjec'
   +'t; const pDisp : IDispatch)');
  CL.AddTypeS('TWebBrowserUpdatePageStatus', 'Procedure ( ASender : TObject; co'
   +'nst pDisp : IDispatch; var nPage : OleVariant; var fDone : OleVariant)');
  CL.AddTypeS('TWebBrowserPrivacyImpactedStateChange', 'Procedure ( ASender : T'
   +'Object; bImpacted : WordBool)');
  SIRegister_TWebBrowser(CL);
  SIRegister_CoInternetExplorer(CL);
  CL.AddTypeS('TInternetExplorerStatusTextChange', 'Procedure ( ASender : TObje'
   +'ct; const Text : WideString)');
  CL.AddTypeS('TInternetExplorerProgressChange', 'Procedure ( ASender : TObject'
   +'; Progress : Integer; ProgressMax : Integer)');
  CL.AddTypeS('TInternetExplorerCommandStateChange', 'Procedure ( ASender : TOb'
   +'ject; Command : Integer; Enable : WordBool)');
  CL.AddTypeS('TInternetExplorerTitleChange', 'Procedure ( ASender : TObject; c'
   +'onst Text : WideString)');
  CL.AddTypeS('TInternetExplorerPropertyChange', 'Procedure ( ASender : TObject'
   +'; const szProperty : WideString)');
  CL.AddTypeS('TInternetExplorerBeforeNavigate2', 'Procedure ( ASender : TObjec'
   +'t; const pDisp : IDispatch; var URL : OleVariant; var Flags : OleVariant; '
   +'var TargetFrameName : OleVariant; var PostData : OleVariant; var Headers :'
   +' OleVariant; var Cancel : WordBool)');
  CL.AddTypeS('TInternetExplorerNewWindow2', 'Procedure ( ASender : TObject; va'
   +'r ppDisp : IDispatch; var Cancel : WordBool)');
  CL.AddTypeS('TInternetExplorerNavigateComplete2', 'Procedure ( ASender : TObj'
   +'ect; const pDisp : IDispatch; var URL : OleVariant)');
  CL.AddTypeS('TInternetExplorerDocumentComplete', 'Procedure ( ASender : TObje'
   +'ct; const pDisp : IDispatch; var URL : OleVariant)');
  CL.AddTypeS('TInternetExplorerOnVisible', 'Procedure ( ASender : TObject; Vis'
   +'ible : WordBool)');
  CL.AddTypeS('TInternetExplorerOnToolBar', 'Procedure ( ASender : TObject; Too'
   +'lBar : WordBool)');
  CL.AddTypeS('TInternetExplorerOnMenuBar', 'Procedure ( ASender : TObject; Men'
   +'uBar : WordBool)');
  CL.AddTypeS('TInternetExplorerOnStatusBar', 'Procedure ( ASender : TObject; S'
   +'tatusBar : WordBool)');
  CL.AddTypeS('TInternetExplorerOnFullScreen', 'Procedure ( ASender : TObject; '
   +'FullScreen : WordBool)');
  CL.AddTypeS('TInternetExplorerOnTheaterMode', 'Procedure ( ASender : TObject;'
   +' TheaterMode : WordBool)');
  CL.AddTypeS('TInternetExplorerWindowSetResizable', 'Procedure ( ASender : TOb'
   +'ject; Resizable : WordBool)');
  CL.AddTypeS('TInternetExplorerWindowSetLeft', 'Procedure ( ASender : TObject; Left : Integer)');
  CL.AddTypeS('TInternetExplorerWindowSetTop', 'Procedure ( ASender : TObject; Top : Integer)');
  CL.AddTypeS('TInternetExplorerWindowSetWidth', 'Procedure ( ASender : TObject'
   +'; Width : Integer)');
  CL.AddTypeS('TInternetExplorerWindowSetHeight', 'Procedure ( ASender : TObjec'
   +'t; Height : Integer)');
  CL.AddTypeS('TInternetExplorerWindowClosing', 'Procedure ( ASender : TObject;'
   +' IsChildWindow : WordBool; var Cancel : WordBool)');
  CL.AddTypeS('TInternetExplorerClientToHostWindow', 'Procedure ( ASender : TOb'
   +'ject; var CX : Integer; var CY : Integer)');
  CL.AddTypeS('TInternetExplorerSetSecureLockIcon', 'Procedure ( ASender : TObj'
   +'ect; SecureLockIcon : Integer)');
  CL.AddTypeS('TInternetExplorerFileDownload', 'Procedure ( ASender : TObject; '
   +'var Cancel : WordBool)');
  CL.AddTypeS('TInternetExplorerNavigateError', 'Procedure ( ASender : TObject;'
   +' const pDisp : IDispatch; var URL : OleVariant; var Frame : OleVariant; va'
   +'r StatusCode : OleVariant; var Cancel : WordBool)');
  CL.AddTypeS('TInternetExplorerPrintTemplateInstantiation', 'Procedure ( ASend'
   +'er : TObject; const pDisp : IDispatch)');
  CL.AddTypeS('TInternetExplorerPrintTemplateTeardown', 'Procedure ( ASender : '
   +'TObject; const pDisp : IDispatch)');
  CL.AddTypeS('TInternetExplorerUpdatePageStatus', 'Procedure ( ASender : TObje'
   +'ct; const pDisp : IDispatch; var nPage : OleVariant; var fDone : OleVariant)');
  CL.AddTypeS('TInternetExplorerPrivacyImpactedStateChange', 'Procedure ( ASend'
   +'er : TObject; bImpacted : WordBool)');
  SIRegister_TInternetExplorer(CL);
  SIRegister_CoShellBrowserWindow(CL);
  SIRegister_CoShellWindows(CL);
  CL.AddTypeS('TShellWindowsWindowRegistered', 'Procedure ( ASender : TObject; lCookie : Integer)');
  CL.AddTypeS('TShellWindowsWindowRevoked', 'Procedure ( ASender : TObject; lCookie : Integer)');
  SIRegister_TShellWindows(CL);
  SIRegister_CoShellUIHelper(CL);
  SIRegister_TShellUIHelper(CL);
  SIRegister_CoShellNameSpace(CL);
  CL.AddTypeS('TShellNameSpaceFavoritesSelectionChange', 'Procedure ( ASender :'
   +' TObject; cItems : Integer; hItem : Integer; const strName : WideString; c'
   +'onst strUrl : WideString; cVisits : Integer; const strDate : WideString; f'
   +'AvailableOffline : Integer)');
  SIRegister_TShellNameSpace(CL);
  SIRegister_CoCScriptErrorList(CL);
  SIRegister_CoSearchAssistantOC(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnInitialized_W(Self: TShellNameSpace; const T: TNotifyEvent);
begin Self.OnInitialized := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnInitialized_R(Self: TShellNameSpace; var T: TNotifyEvent);
begin T := Self.OnInitialized; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnDoubleClick_W(Self: TShellNameSpace; const T: TNotifyEvent);
begin Self.OnDoubleClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnDoubleClick_R(Self: TShellNameSpace; var T: TNotifyEvent);
begin T := Self.OnDoubleClick; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnSelectionChange_W(Self: TShellNameSpace; const T: TNotifyEvent);
begin Self.OnSelectionChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnSelectionChange_R(Self: TShellNameSpace; var T: TNotifyEvent);
begin T := Self.OnSelectionChange; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnFavoritesSelectionChange_W(Self: TShellNameSpace; const T: TShellNameSpaceFavoritesSelectionChange);
begin Self.OnFavoritesSelectionChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceOnFavoritesSelectionChange_R(Self: TShellNameSpace; var T: TShellNameSpaceFavoritesSelectionChange);
begin T := Self.OnFavoritesSelectionChange; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceColumns_W(Self: TShellNameSpace; const T: WideString);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceColumns_R(Self: TShellNameSpace; var T: WideString);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceTVFlags_W(Self: TShellNameSpace; const T: LongWord);
begin Self.TVFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceTVFlags_R(Self: TShellNameSpace; var T: LongWord);
begin T := Self.TVFlags; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceFlags_W(Self: TShellNameSpace; const T: LongWord);
begin Self.Flags := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceFlags_R(Self: TShellNameSpace; var T: LongWord);
begin T := Self.Flags; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceMode_W(Self: TShellNameSpace; const T: SYSUINT);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceMode_R(Self: TShellNameSpace; var T: SYSUINT);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceDepth_W(Self: TShellNameSpace; const T: SYSINT);
begin Self.Depth := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceDepth_R(Self: TShellNameSpace; var T: SYSINT);
begin T := Self.Depth; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceEnumOptions_W(Self: TShellNameSpace; const T: Integer);
begin Self.EnumOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceEnumOptions_R(Self: TShellNameSpace; var T: Integer);
begin T := Self.EnumOptions; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceCountViewTypes_R(Self: TShellNameSpace; var T: SYSINT);
begin T := Self.CountViewTypes; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceRoot_W(Self: TShellNameSpace; const T: OleVariant);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceRoot_R(Self: TShellNameSpace; var T: OleVariant);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceSelectedItem_W(Self: TShellNameSpace; const T: IDispatch);
begin Self.SelectedItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceSelectedItem_R(Self: TShellNameSpace; var T: IDispatch);
begin T := Self.SelectedItem; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceSubscriptionsEnabled_R(Self: TShellNameSpace; var T: WordBool);
begin T := Self.SubscriptionsEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TShellNameSpaceDefaultInterface_R(Self: TShellNameSpace; var T: IShellNameSpace);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TShellUIHelperDefaultInterface_R(Self: TShellUIHelper; var T: IShellUIHelper);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAutoCompleteAttach57_P(Self: TShellUIHelper;  var Reserved : OleVariant);
Begin Self.AutoCompleteAttach(Reserved); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAutoCompleteAttach56_P(Self: TShellUIHelper);
Begin Self.AutoCompleteAttach; END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAutoScan55_P(Self: TShellUIHelper;  const strSearch : WideString; const strFailureUrl : WideString; var pvarTargetFrame : OleVariant);
Begin Self.AutoScan(strSearch, strFailureUrl, pvarTargetFrame); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAutoScan54_P(Self: TShellUIHelper;  const strSearch : WideString; const strFailureUrl : WideString);
Begin Self.AutoScan(strSearch, strFailureUrl); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAutoCompleteSaveForm53_P(Self: TShellUIHelper;  var Form : OleVariant);
Begin Self.AutoCompleteSaveForm(Form); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAutoCompleteSaveForm52_P(Self: TShellUIHelper);
Begin Self.AutoCompleteSaveForm; END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAddDesktopComponent51_P(Self: TShellUIHelper;  const URL : WideString; const Type_ : WideString; var Left : OleVariant; var Top : OleVariant; var Width : OleVariant; var Height : OleVariant);
Begin Self.AddDesktopComponent(URL, Type_, Left, Top, Width, Height); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAddDesktopComponent50_P(Self: TShellUIHelper;  const URL : WideString; const Type_ : WideString; var Left : OleVariant; var Top : OleVariant; var Width : OleVariant);
Begin Self.AddDesktopComponent(URL, Type_, Left, Top, Width); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAddDesktopComponent49_P(Self: TShellUIHelper;  const URL : WideString; const Type_ : WideString; var Left : OleVariant; var Top : OleVariant);
Begin Self.AddDesktopComponent(URL, Type_, Left, Top); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAddDesktopComponent48_P(Self: TShellUIHelper;  const URL : WideString; const Type_ : WideString; var Left : OleVariant);
Begin Self.AddDesktopComponent(URL, Type_, Left); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAddDesktopComponent47_P(Self: TShellUIHelper;  const URL : WideString; const Type_ : WideString);
Begin Self.AddDesktopComponent(URL, Type_); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAddFavorite46_P(Self: TShellUIHelper;  const URL : WideString; var Title : OleVariant);
Begin Self.AddFavorite(URL, Title); END;

(*----------------------------------------------------------------------------*)
Procedure TShellUIHelperAddFavorite45_P(Self: TShellUIHelper;  const URL : WideString);
Begin Self.AddFavorite(URL); END;

(*----------------------------------------------------------------------------*)
procedure TShellWindowsOnWindowRevoked_W(Self: TShellWindows; const T: TShellWindowsWindowRevoked);
begin Self.OnWindowRevoked := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellWindowsOnWindowRevoked_R(Self: TShellWindows; var T: TShellWindowsWindowRevoked);
begin T := Self.OnWindowRevoked; end;

(*----------------------------------------------------------------------------*)
procedure TShellWindowsOnWindowRegistered_W(Self: TShellWindows; const T: TShellWindowsWindowRegistered);
begin Self.OnWindowRegistered := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellWindowsOnWindowRegistered_R(Self: TShellWindows; var T: TShellWindowsWindowRegistered);
begin T := Self.OnWindowRegistered; end;

(*----------------------------------------------------------------------------*)
procedure TShellWindowsCount_R(Self: TShellWindows; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TShellWindowsDefaultInterface_R(Self: TShellWindows; var T: IShellWindows);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
Function TShellWindowsItem44_P(Self: TShellWindows;  index : OleVariant) : IDispatch;
Begin Result := Self.Item(index); END;

(*----------------------------------------------------------------------------*)
Function TShellWindowsItem43_P(Self: TShellWindows) : IDispatch;
Begin Result := Self.Item; END;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPrivacyImpactedStateChange_W(Self: TInternetExplorer; const T: TInternetExplorerPrivacyImpactedStateChange);
begin Self.OnPrivacyImpactedStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPrivacyImpactedStateChange_R(Self: TInternetExplorer; var T: TInternetExplorerPrivacyImpactedStateChange);
begin T := Self.OnPrivacyImpactedStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnUpdatePageStatus_W(Self: TInternetExplorer; const T: TInternetExplorerUpdatePageStatus);
begin Self.OnUpdatePageStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnUpdatePageStatus_R(Self: TInternetExplorer; var T: TInternetExplorerUpdatePageStatus);
begin T := Self.OnUpdatePageStatus; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPrintTemplateTeardown_W(Self: TInternetExplorer; const T: TInternetExplorerPrintTemplateTeardown);
begin Self.OnPrintTemplateTeardown := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPrintTemplateTeardown_R(Self: TInternetExplorer; var T: TInternetExplorerPrintTemplateTeardown);
begin T := Self.OnPrintTemplateTeardown; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPrintTemplateInstantiation_W(Self: TInternetExplorer; const T: TInternetExplorerPrintTemplateInstantiation);
begin Self.OnPrintTemplateInstantiation := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPrintTemplateInstantiation_R(Self: TInternetExplorer; var T: TInternetExplorerPrintTemplateInstantiation);
begin T := Self.OnPrintTemplateInstantiation; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnNavigateError_W(Self: TInternetExplorer; const T: TInternetExplorerNavigateError);
begin Self.OnNavigateError := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnNavigateError_R(Self: TInternetExplorer; var T: TInternetExplorerNavigateError);
begin T := Self.OnNavigateError; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnFileDownload_W(Self: TInternetExplorer; const T: TInternetExplorerFileDownload);
begin Self.OnFileDownload := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnFileDownload_R(Self: TInternetExplorer; var T: TInternetExplorerFileDownload);
begin T := Self.OnFileDownload; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnSetSecureLockIcon_W(Self: TInternetExplorer; const T: TInternetExplorerSetSecureLockIcon);
begin Self.OnSetSecureLockIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnSetSecureLockIcon_R(Self: TInternetExplorer; var T: TInternetExplorerSetSecureLockIcon);
begin T := Self.OnSetSecureLockIcon; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnClientToHostWindow_W(Self: TInternetExplorer; const T: TInternetExplorerClientToHostWindow);
begin Self.OnClientToHostWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnClientToHostWindow_R(Self: TInternetExplorer; var T: TInternetExplorerClientToHostWindow);
begin T := Self.OnClientToHostWindow; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowClosing_W(Self: TInternetExplorer; const T: TInternetExplorerWindowClosing);
begin Self.OnWindowClosing := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowClosing_R(Self: TInternetExplorer; var T: TInternetExplorerWindowClosing);
begin T := Self.OnWindowClosing; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetHeight_W(Self: TInternetExplorer; const T: TInternetExplorerWindowSetHeight);
begin Self.OnWindowSetHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetHeight_R(Self: TInternetExplorer; var T: TInternetExplorerWindowSetHeight);
begin T := Self.OnWindowSetHeight; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetWidth_W(Self: TInternetExplorer; const T: TInternetExplorerWindowSetWidth);
begin Self.OnWindowSetWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetWidth_R(Self: TInternetExplorer; var T: TInternetExplorerWindowSetWidth);
begin T := Self.OnWindowSetWidth; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetTop_W(Self: TInternetExplorer; const T: TInternetExplorerWindowSetTop);
begin Self.OnWindowSetTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetTop_R(Self: TInternetExplorer; var T: TInternetExplorerWindowSetTop);
begin T := Self.OnWindowSetTop; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetLeft_W(Self: TInternetExplorer; const T: TInternetExplorerWindowSetLeft);
begin Self.OnWindowSetLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetLeft_R(Self: TInternetExplorer; var T: TInternetExplorerWindowSetLeft);
begin T := Self.OnWindowSetLeft; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetResizable_W(Self: TInternetExplorer; const T: TInternetExplorerWindowSetResizable);
begin Self.OnWindowSetResizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnWindowSetResizable_R(Self: TInternetExplorer; var T: TInternetExplorerWindowSetResizable);
begin T := Self.OnWindowSetResizable; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnTheaterMode_W(Self: TInternetExplorer; const T: TInternetExplorerOnTheaterMode);
begin Self.OnTheaterMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnTheaterMode_R(Self: TInternetExplorer; var T: TInternetExplorerOnTheaterMode);
begin T := Self.OnTheaterMode; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnFullScreen_W(Self: TInternetExplorer; const T: TInternetExplorerOnFullScreen);
begin Self.OnFullScreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnFullScreen_R(Self: TInternetExplorer; var T: TInternetExplorerOnFullScreen);
begin T := Self.OnFullScreen; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnStatusBar_W(Self: TInternetExplorer; const T: TInternetExplorerOnStatusBar);
begin Self.OnStatusBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnStatusBar_R(Self: TInternetExplorer; var T: TInternetExplorerOnStatusBar);
begin T := Self.OnStatusBar; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnMenuBar_W(Self: TInternetExplorer; const T: TInternetExplorerOnMenuBar);
begin Self.OnMenuBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnMenuBar_R(Self: TInternetExplorer; var T: TInternetExplorerOnMenuBar);
begin T := Self.OnMenuBar; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnToolBar_W(Self: TInternetExplorer; const T: TInternetExplorerOnToolBar);
begin Self.OnToolBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnToolBar_R(Self: TInternetExplorer; var T: TInternetExplorerOnToolBar);
begin T := Self.OnToolBar; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnVisible_W(Self: TInternetExplorer; const T: TInternetExplorerOnVisible);
begin Self.OnVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnVisible_R(Self: TInternetExplorer; var T: TInternetExplorerOnVisible);
begin T := Self.OnVisible; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnQuit_W(Self: TInternetExplorer; const T: TNotifyEvent);
begin Self.OnQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnQuit_R(Self: TInternetExplorer; var T: TNotifyEvent);
begin T := Self.OnQuit; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnDocumentComplete_W(Self: TInternetExplorer; const T: TInternetExplorerDocumentComplete);
begin Self.OnDocumentComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnDocumentComplete_R(Self: TInternetExplorer; var T: TInternetExplorerDocumentComplete);
begin T := Self.OnDocumentComplete; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnNavigateComplete2_W(Self: TInternetExplorer; const T: TInternetExplorerNavigateComplete2);
begin Self.OnNavigateComplete2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnNavigateComplete2_R(Self: TInternetExplorer; var T: TInternetExplorerNavigateComplete2);
begin T := Self.OnNavigateComplete2; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnNewWindow2_W(Self: TInternetExplorer; const T: TInternetExplorerNewWindow2);
begin Self.OnNewWindow2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnNewWindow2_R(Self: TInternetExplorer; var T: TInternetExplorerNewWindow2);
begin T := Self.OnNewWindow2; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnBeforeNavigate2_W(Self: TInternetExplorer; const T: TInternetExplorerBeforeNavigate2);
begin Self.OnBeforeNavigate2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnBeforeNavigate2_R(Self: TInternetExplorer; var T: TInternetExplorerBeforeNavigate2);
begin T := Self.OnBeforeNavigate2; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPropertyChange_W(Self: TInternetExplorer; const T: TInternetExplorerPropertyChange);
begin Self.OnPropertyChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnPropertyChange_R(Self: TInternetExplorer; var T: TInternetExplorerPropertyChange);
begin T := Self.OnPropertyChange; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnTitleChange_W(Self: TInternetExplorer; const T: TInternetExplorerTitleChange);
begin Self.OnTitleChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnTitleChange_R(Self: TInternetExplorer; var T: TInternetExplorerTitleChange);
begin T := Self.OnTitleChange; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnDownloadComplete_W(Self: TInternetExplorer; const T: TNotifyEvent);
begin Self.OnDownloadComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnDownloadComplete_R(Self: TInternetExplorer; var T: TNotifyEvent);
begin T := Self.OnDownloadComplete; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnDownloadBegin_W(Self: TInternetExplorer; const T: TNotifyEvent);
begin Self.OnDownloadBegin := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnDownloadBegin_R(Self: TInternetExplorer; var T: TNotifyEvent);
begin T := Self.OnDownloadBegin; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnCommandStateChange_W(Self: TInternetExplorer; const T: TInternetExplorerCommandStateChange);
begin Self.OnCommandStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnCommandStateChange_R(Self: TInternetExplorer; var T: TInternetExplorerCommandStateChange);
begin T := Self.OnCommandStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnProgressChange_W(Self: TInternetExplorer; const T: TInternetExplorerProgressChange);
begin Self.OnProgressChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnProgressChange_R(Self: TInternetExplorer; var T: TInternetExplorerProgressChange);
begin T := Self.OnProgressChange; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnStatusTextChange_W(Self: TInternetExplorer; const T: TInternetExplorerStatusTextChange);
begin Self.OnStatusTextChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOnStatusTextChange_R(Self: TInternetExplorer; var T: TInternetExplorerStatusTextChange);
begin T := Self.OnStatusTextChange; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerResizable_W(Self: TInternetExplorer; const T: WordBool);
begin Self.Resizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerResizable_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.Resizable; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerAddressBar_W(Self: TInternetExplorer; const T: WordBool);
begin Self.AddressBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerAddressBar_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.AddressBar; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerTheaterMode_W(Self: TInternetExplorer; const T: WordBool);
begin Self.TheaterMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerTheaterMode_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.TheaterMode; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerRegisterAsDropTarget_W(Self: TInternetExplorer; const T: WordBool);
begin Self.RegisterAsDropTarget := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerRegisterAsDropTarget_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.RegisterAsDropTarget; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerRegisterAsBrowser_W(Self: TInternetExplorer; const T: WordBool);
begin Self.RegisterAsBrowser := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerRegisterAsBrowser_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.RegisterAsBrowser; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerSilent_W(Self: TInternetExplorer; const T: WordBool);
begin Self.Silent := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerSilent_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.Silent; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOffline_W(Self: TInternetExplorer; const T: WordBool);
begin Self.Offline := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerOffline_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.Offline; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerFullScreen_W(Self: TInternetExplorer; const T: WordBool);
begin Self.FullScreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerFullScreen_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.FullScreen; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerMenuBar_W(Self: TInternetExplorer; const T: WordBool);
begin Self.MenuBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerMenuBar_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.MenuBar; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerToolBar_W(Self: TInternetExplorer; const T: SYSINT);
begin Self.ToolBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerToolBar_R(Self: TInternetExplorer; var T: SYSINT);
begin T := Self.ToolBar; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerStatusText_W(Self: TInternetExplorer; const T: WideString);
begin Self.StatusText := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerStatusText_R(Self: TInternetExplorer; var T: WideString);
begin T := Self.StatusText; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerStatusBar_W(Self: TInternetExplorer; const T: WordBool);
begin Self.StatusBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerStatusBar_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.StatusBar; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerVisible_W(Self: TInternetExplorer; const T: WordBool);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerVisible_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerHeight_W(Self: TInternetExplorer; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerHeight_R(Self: TInternetExplorer; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerWidth_W(Self: TInternetExplorer; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerWidth_R(Self: TInternetExplorer; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerTop_W(Self: TInternetExplorer; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerTop_R(Self: TInternetExplorer; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerLeft_W(Self: TInternetExplorer; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerLeft_R(Self: TInternetExplorer; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerReadyState_R(Self: TInternetExplorer; var T: tagREADYSTATE);
begin T := Self.ReadyState; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerPath_R(Self: TInternetExplorer; var T: WideString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerFullName_R(Self: TInternetExplorer; var T: WideString);
begin T := Self.FullName; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerHWnd_R(Self: TInternetExplorer; var T: Integer);
begin T := Self.HWnd; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerName_R(Self: TInternetExplorer; var T: WideString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerBusy_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.Busy; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerLocationURL_R(Self: TInternetExplorer; var T: WideString);
begin T := Self.LocationURL; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerLocationName_R(Self: TInternetExplorer; var T: WideString);
begin T := Self.LocationName; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorertype__R(Self: TInternetExplorer; var T: WideString);
begin T := Self.type_; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerTopLevelContainer_R(Self: TInternetExplorer; var T: WordBool);
begin T := Self.TopLevelContainer; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerDocument_R(Self: TInternetExplorer; var T: IDispatch);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerContainer_R(Self: TInternetExplorer; var T: IDispatch);
begin T := Self.Container; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerParent_R(Self: TInternetExplorer; var T: IDispatch);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerApplication_R(Self: TInternetExplorer; var T: IDispatch);
begin T := Self.Application; end;

(*----------------------------------------------------------------------------*)
procedure TInternetExplorerDefaultInterface_R(Self: TInternetExplorer; var T: IWebBrowser2);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerShowBrowserBar42_P(Self: TInternetExplorer;  var pvaClsid : OleVariant; var pvarShow : OleVariant; var pvarSize : OleVariant);
Begin Self.ShowBrowserBar(pvaClsid, pvarShow, pvarSize); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerShowBrowserBar41_P(Self: TInternetExplorer;  var pvaClsid : OleVariant; var pvarShow : OleVariant);
Begin Self.ShowBrowserBar(pvaClsid, pvarShow); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerShowBrowserBar40_P(Self: TInternetExplorer;  var pvaClsid : OleVariant);
Begin Self.ShowBrowserBar(pvaClsid); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerExecWB39_P(Self: TInternetExplorer;  cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant; var pvaOut : OleVariant);
Begin Self.ExecWB(cmdID, cmdexecopt, pvaIn, pvaOut); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerExecWB38_P(Self: TInternetExplorer;  cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant);
Begin Self.ExecWB(cmdID, cmdexecopt, pvaIn); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerExecWB37_P(Self: TInternetExplorer;  cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT);
Begin Self.ExecWB(cmdID, cmdexecopt); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate236_P(Self: TInternetExplorer;  var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant; var Headers : OleVariant);
Begin Self.Navigate2(URL, Flags, TargetFrameName, PostData, Headers); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate235_P(Self: TInternetExplorer;  var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant);
Begin Self.Navigate2(URL, Flags, TargetFrameName, PostData); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate234_P(Self: TInternetExplorer;  var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant);
Begin Self.Navigate2(URL, Flags, TargetFrameName); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate233_P(Self: TInternetExplorer;  var URL : OleVariant; var Flags : OleVariant);
Begin Self.Navigate2(URL, Flags); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate232_P(Self: TInternetExplorer;  var URL : OleVariant);
Begin Self.Navigate2(URL); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerRefresh231_P(Self: TInternetExplorer;  var Level : OleVariant);
Begin Self.Refresh2(Level); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerRefresh230_P(Self: TInternetExplorer);
Begin Self.Refresh2; END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate29_P(Self: TInternetExplorer;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant; const Headers : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName, PostData, Headers); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate28_P(Self: TInternetExplorer;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName, PostData); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate27_P(Self: TInternetExplorer;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate26_P(Self: TInternetExplorer;  const URL : WideString; const Flags : OleVariant);
Begin Self.Navigate(URL, Flags); END;

(*----------------------------------------------------------------------------*)
Procedure TInternetExplorerNavigate25_P(Self: TInternetExplorer;  const URL : WideString);
Begin Self.Navigate(URL); END;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPrivacyImpactedStateChange_W(Self: TWebBrowser; const T: TWebBrowserPrivacyImpactedStateChange);
begin Self.OnPrivacyImpactedStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPrivacyImpactedStateChange_R(Self: TWebBrowser; var T: TWebBrowserPrivacyImpactedStateChange);
begin T := Self.OnPrivacyImpactedStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnUpdatePageStatus_W(Self: TWebBrowser; const T: TWebBrowserUpdatePageStatus);
begin Self.OnUpdatePageStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnUpdatePageStatus_R(Self: TWebBrowser; var T: TWebBrowserUpdatePageStatus);
begin T := Self.OnUpdatePageStatus; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPrintTemplateTeardown_W(Self: TWebBrowser; const T: TWebBrowserPrintTemplateTeardown);
begin Self.OnPrintTemplateTeardown := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPrintTemplateTeardown_R(Self: TWebBrowser; var T: TWebBrowserPrintTemplateTeardown);
begin T := Self.OnPrintTemplateTeardown; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPrintTemplateInstantiation_W(Self: TWebBrowser; const T: TWebBrowserPrintTemplateInstantiation);
begin Self.OnPrintTemplateInstantiation := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPrintTemplateInstantiation_R(Self: TWebBrowser; var T: TWebBrowserPrintTemplateInstantiation);
begin T := Self.OnPrintTemplateInstantiation; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnNavigateError_W(Self: TWebBrowser; const T: TWebBrowserNavigateError);
begin Self.OnNavigateError := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnNavigateError_R(Self: TWebBrowser; var T: TWebBrowserNavigateError);
begin T := Self.OnNavigateError; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnFileDownload_W(Self: TWebBrowser; const T: TWebBrowserFileDownload);
begin Self.OnFileDownload := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnFileDownload_R(Self: TWebBrowser; var T: TWebBrowserFileDownload);
begin T := Self.OnFileDownload; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnSetSecureLockIcon_W(Self: TWebBrowser; const T: TWebBrowserSetSecureLockIcon);
begin Self.OnSetSecureLockIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnSetSecureLockIcon_R(Self: TWebBrowser; var T: TWebBrowserSetSecureLockIcon);
begin T := Self.OnSetSecureLockIcon; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnClientToHostWindow_W(Self: TWebBrowser; const T: TWebBrowserClientToHostWindow);
begin Self.OnClientToHostWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnClientToHostWindow_R(Self: TWebBrowser; var T: TWebBrowserClientToHostWindow);
begin T := Self.OnClientToHostWindow; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowClosing_W(Self: TWebBrowser; const T: TWebBrowserWindowClosing);
begin Self.OnWindowClosing := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowClosing_R(Self: TWebBrowser; var T: TWebBrowserWindowClosing);
begin T := Self.OnWindowClosing; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetHeight_W(Self: TWebBrowser; const T: TWebBrowserWindowSetHeight);
begin Self.OnWindowSetHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetHeight_R(Self: TWebBrowser; var T: TWebBrowserWindowSetHeight);
begin T := Self.OnWindowSetHeight; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetWidth_W(Self: TWebBrowser; const T: TWebBrowserWindowSetWidth);
begin Self.OnWindowSetWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetWidth_R(Self: TWebBrowser; var T: TWebBrowserWindowSetWidth);
begin T := Self.OnWindowSetWidth; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetTop_W(Self: TWebBrowser; const T: TWebBrowserWindowSetTop);
begin Self.OnWindowSetTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetTop_R(Self: TWebBrowser; var T: TWebBrowserWindowSetTop);
begin T := Self.OnWindowSetTop; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetLeft_W(Self: TWebBrowser; const T: TWebBrowserWindowSetLeft);
begin Self.OnWindowSetLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetLeft_R(Self: TWebBrowser; var T: TWebBrowserWindowSetLeft);
begin T := Self.OnWindowSetLeft; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetResizable_W(Self: TWebBrowser; const T: TWebBrowserWindowSetResizable);
begin Self.OnWindowSetResizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnWindowSetResizable_R(Self: TWebBrowser; var T: TWebBrowserWindowSetResizable);
begin T := Self.OnWindowSetResizable; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnTheaterMode_W(Self: TWebBrowser; const T: TWebBrowserOnTheaterMode);
begin Self.OnTheaterMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnTheaterMode_R(Self: TWebBrowser; var T: TWebBrowserOnTheaterMode);
begin T := Self.OnTheaterMode; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnFullScreen_W(Self: TWebBrowser; const T: TWebBrowserOnFullScreen);
begin Self.OnFullScreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnFullScreen_R(Self: TWebBrowser; var T: TWebBrowserOnFullScreen);
begin T := Self.OnFullScreen; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnStatusBar_W(Self: TWebBrowser; const T: TWebBrowserOnStatusBar);
begin Self.OnStatusBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnStatusBar_R(Self: TWebBrowser; var T: TWebBrowserOnStatusBar);
begin T := Self.OnStatusBar; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnMenuBar_W(Self: TWebBrowser; const T: TWebBrowserOnMenuBar);
begin Self.OnMenuBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnMenuBar_R(Self: TWebBrowser; var T: TWebBrowserOnMenuBar);
begin T := Self.OnMenuBar; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnToolBar_W(Self: TWebBrowser; const T: TWebBrowserOnToolBar);
begin Self.OnToolBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnToolBar_R(Self: TWebBrowser; var T: TWebBrowserOnToolBar);
begin T := Self.OnToolBar; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnVisible_W(Self: TWebBrowser; const T: TWebBrowserOnVisible);
begin Self.OnVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnVisible_R(Self: TWebBrowser; var T: TWebBrowserOnVisible);
begin T := Self.OnVisible; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnQuit_W(Self: TWebBrowser; const T: TNotifyEvent);
begin Self.OnQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnQuit_R(Self: TWebBrowser; var T: TNotifyEvent);
begin T := Self.OnQuit; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnDocumentComplete_W(Self: TWebBrowser; const T: TWebBrowserDocumentComplete);
begin Self.OnDocumentComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnDocumentComplete_R(Self: TWebBrowser; var T: TWebBrowserDocumentComplete);
begin T := Self.OnDocumentComplete; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnNavigateComplete2_W(Self: TWebBrowser; const T: TWebBrowserNavigateComplete2);
begin Self.OnNavigateComplete2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnNavigateComplete2_R(Self: TWebBrowser; var T: TWebBrowserNavigateComplete2);
begin T := Self.OnNavigateComplete2; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnNewWindow2_W(Self: TWebBrowser; const T: TWebBrowserNewWindow2);
begin Self.OnNewWindow2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnNewWindow2_R(Self: TWebBrowser; var T: TWebBrowserNewWindow2);
begin T := Self.OnNewWindow2; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnBeforeNavigate2_W(Self: TWebBrowser; const T: TWebBrowserBeforeNavigate2);
begin Self.OnBeforeNavigate2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnBeforeNavigate2_R(Self: TWebBrowser; var T: TWebBrowserBeforeNavigate2);
begin T := Self.OnBeforeNavigate2; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPropertyChange_W(Self: TWebBrowser; const T: TWebBrowserPropertyChange);
begin Self.OnPropertyChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnPropertyChange_R(Self: TWebBrowser; var T: TWebBrowserPropertyChange);
begin T := Self.OnPropertyChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnTitleChange_W(Self: TWebBrowser; const T: TWebBrowserTitleChange);
begin Self.OnTitleChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnTitleChange_R(Self: TWebBrowser; var T: TWebBrowserTitleChange);
begin T := Self.OnTitleChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnDownloadComplete_W(Self: TWebBrowser; const T: TNotifyEvent);
begin Self.OnDownloadComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnDownloadComplete_R(Self: TWebBrowser; var T: TNotifyEvent);
begin T := Self.OnDownloadComplete; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnDownloadBegin_W(Self: TWebBrowser; const T: TNotifyEvent);
begin Self.OnDownloadBegin := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnDownloadBegin_R(Self: TWebBrowser; var T: TNotifyEvent);
begin T := Self.OnDownloadBegin; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnCommandStateChange_W(Self: TWebBrowser; const T: TWebBrowserCommandStateChange);
begin Self.OnCommandStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnCommandStateChange_R(Self: TWebBrowser; var T: TWebBrowserCommandStateChange);
begin T := Self.OnCommandStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnProgressChange_W(Self: TWebBrowser; const T: TWebBrowserProgressChange);
begin Self.OnProgressChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnProgressChange_R(Self: TWebBrowser; var T: TWebBrowserProgressChange);
begin T := Self.OnProgressChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnStatusTextChange_W(Self: TWebBrowser; const T: TWebBrowserStatusTextChange);
begin Self.OnStatusTextChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOnStatusTextChange_R(Self: TWebBrowser; var T: TWebBrowserStatusTextChange);
begin T := Self.OnStatusTextChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserResizable_W(Self: TWebBrowser; const T: WordBool);
begin Self.Resizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserResizable_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.Resizable; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserAddressBar_W(Self: TWebBrowser; const T: WordBool);
begin Self.AddressBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserAddressBar_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.AddressBar; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserTheaterMode_W(Self: TWebBrowser; const T: WordBool);
begin Self.TheaterMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserTheaterMode_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.TheaterMode; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserRegisterAsDropTarget_W(Self: TWebBrowser; const T: WordBool);
begin Self.RegisterAsDropTarget := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserRegisterAsDropTarget_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.RegisterAsDropTarget; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserRegisterAsBrowser_W(Self: TWebBrowser; const T: WordBool);
begin Self.RegisterAsBrowser := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserRegisterAsBrowser_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.RegisterAsBrowser; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserSilent_W(Self: TWebBrowser; const T: WordBool);
begin Self.Silent := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserSilent_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.Silent; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOffline_W(Self: TWebBrowser; const T: WordBool);
begin Self.Offline := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserOffline_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.Offline; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserFullScreen_W(Self: TWebBrowser; const T: WordBool);
begin Self.FullScreen := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserFullScreen_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.FullScreen; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserMenuBar_W(Self: TWebBrowser; const T: WordBool);
begin Self.MenuBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserMenuBar_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.MenuBar; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserToolBar_W(Self: TWebBrowser; const T: Integer);
begin Self.ToolBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserToolBar_R(Self: TWebBrowser; var T: Integer);
begin T := Self.ToolBar; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserStatusText_W(Self: TWebBrowser; const T: WideString);
begin Self.StatusText := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserStatusText_R(Self: TWebBrowser; var T: WideString);
begin T := Self.StatusText; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserStatusBar_W(Self: TWebBrowser; const T: WordBool);
begin Self.StatusBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserStatusBar_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.StatusBar; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserVisible_W(Self: TWebBrowser; const T: WordBool);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserVisible_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserPath_R(Self: TWebBrowser; var T: WideString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserFullName_R(Self: TWebBrowser; var T: WideString);
begin T := Self.FullName; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserName_R(Self: TWebBrowser; var T: WideString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserBusy_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.Busy; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserLocationURL_R(Self: TWebBrowser; var T: WideString);
begin T := Self.LocationURL; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserLocationName_R(Self: TWebBrowser; var T: WideString);
begin T := Self.LocationName; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowsertype__R(Self: TWebBrowser; var T: WideString);
begin T := Self.type_; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserTopLevelContainer_R(Self: TWebBrowser; var T: WordBool);
begin T := Self.TopLevelContainer; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserDocument_R(Self: TWebBrowser; var T: IDispatch);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserContainer_R(Self: TWebBrowser; var T: IDispatch);
begin T := Self.Container; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserParent_R(Self: TWebBrowser; var T: IDispatch);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserApplication_R(Self: TWebBrowser; var T: IDispatch);
begin T := Self.Application; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserDefaultInterface_R(Self: TWebBrowser; var T: IWebBrowser2);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowserControlInterface_R(Self: TWebBrowser; var T: IWebBrowser2);
begin T := Self.ControlInterface; end;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserShowBrowserBar24_P(Self: TWebBrowser;  var pvaClsid : OleVariant; var pvarShow : OleVariant; var pvarSize : OleVariant);
Begin Self.ShowBrowserBar(pvaClsid, pvarShow, pvarSize); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserShowBrowserBar23_P(Self: TWebBrowser;  var pvaClsid : OleVariant; var pvarShow : OleVariant);
Begin Self.ShowBrowserBar(pvaClsid, pvarShow); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserShowBrowserBar22_P(Self: TWebBrowser;  var pvaClsid : OleVariant);
Begin Self.ShowBrowserBar(pvaClsid); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserExecWB21_P(Self: TWebBrowser;  cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant; var pvaOut : OleVariant);
Begin Self.ExecWB(cmdID, cmdexecopt, pvaIn, pvaOut); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserExecWB20_P(Self: TWebBrowser;  cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT; var pvaIn : OleVariant);
Begin Self.ExecWB(cmdID, cmdexecopt, pvaIn); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserExecWB19_P(Self: TWebBrowser;  cmdID : OLECMDID; cmdexecopt : OLECMDEXECOPT);
Begin Self.ExecWB(cmdID, cmdexecopt); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate218_P(Self: TWebBrowser;  var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant; var Headers : OleVariant);
Begin Self.Navigate2(URL, Flags, TargetFrameName, PostData, Headers); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate217_P(Self: TWebBrowser;  var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant; var PostData : OleVariant);
Begin Self.Navigate2(URL, Flags, TargetFrameName, PostData); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate216_P(Self: TWebBrowser;  var URL : OleVariant; var Flags : OleVariant; var TargetFrameName : OleVariant);
Begin Self.Navigate2(URL, Flags, TargetFrameName); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate215_P(Self: TWebBrowser;  var URL : OleVariant; var Flags : OleVariant);
Begin Self.Navigate2(URL, Flags); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate214_P(Self: TWebBrowser;  var URL : OleVariant);
Begin Self.Navigate2(URL); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserRefresh213_P(Self: TWebBrowser;  var Level : OleVariant);
Begin Self.Refresh2(Level); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserRefresh212_P(Self: TWebBrowser);
Begin Self.Refresh2; END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate11_P(Self: TWebBrowser;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant; const Headers : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName, PostData, Headers); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate10_P(Self: TWebBrowser;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName, PostData); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate9_P(Self: TWebBrowser;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate8_P(Self: TWebBrowser;  const URL : WideString; const Flags : OleVariant);
Begin Self.Navigate(URL, Flags); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowserNavigate7_P(Self: TWebBrowser;  const URL : WideString);
Begin Self.Navigate(URL); END;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnPropertyChange_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1PropertyChange);
begin Self.OnPropertyChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnPropertyChange_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1PropertyChange);
begin T := Self.OnPropertyChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnWindowActivate_W(Self: TWebBrowser_V1; const T: TNotifyEvent);
begin Self.OnWindowActivate := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnWindowActivate_R(Self: TWebBrowser_V1; var T: TNotifyEvent);
begin T := Self.OnWindowActivate; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnWindowResize_W(Self: TWebBrowser_V1; const T: TNotifyEvent);
begin Self.OnWindowResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnWindowResize_R(Self: TWebBrowser_V1; var T: TNotifyEvent);
begin T := Self.OnWindowResize; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnWindowMove_W(Self: TWebBrowser_V1; const T: TNotifyEvent);
begin Self.OnWindowMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnWindowMove_R(Self: TWebBrowser_V1; var T: TNotifyEvent);
begin T := Self.OnWindowMove; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnQuit_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1Quit);
begin Self.OnQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnQuit_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1Quit);
begin T := Self.OnQuit; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnFrameNewWindow_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1FrameNewWindow);
begin Self.OnFrameNewWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnFrameNewWindow_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1FrameNewWindow);
begin T := Self.OnFrameNewWindow; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnFrameNavigateComplete_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1FrameNavigateComplete);
begin Self.OnFrameNavigateComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnFrameNavigateComplete_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1FrameNavigateComplete);
begin T := Self.OnFrameNavigateComplete; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnFrameBeforeNavigate_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1FrameBeforeNavigate);
begin Self.OnFrameBeforeNavigate := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnFrameBeforeNavigate_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1FrameBeforeNavigate);
begin T := Self.OnFrameBeforeNavigate; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnTitleChange_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1TitleChange);
begin Self.OnTitleChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnTitleChange_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1TitleChange);
begin T := Self.OnTitleChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnNewWindow_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1NewWindow);
begin Self.OnNewWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnNewWindow_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1NewWindow);
begin T := Self.OnNewWindow; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnDownloadBegin_W(Self: TWebBrowser_V1; const T: TNotifyEvent);
begin Self.OnDownloadBegin := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnDownloadBegin_R(Self: TWebBrowser_V1; var T: TNotifyEvent);
begin T := Self.OnDownloadBegin; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnCommandStateChange_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1CommandStateChange);
begin Self.OnCommandStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnCommandStateChange_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1CommandStateChange);
begin T := Self.OnCommandStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnDownloadComplete_W(Self: TWebBrowser_V1; const T: TNotifyEvent);
begin Self.OnDownloadComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnDownloadComplete_R(Self: TWebBrowser_V1; var T: TNotifyEvent);
begin T := Self.OnDownloadComplete; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnProgressChange_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1ProgressChange);
begin Self.OnProgressChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnProgressChange_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1ProgressChange);
begin T := Self.OnProgressChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnStatusTextChange_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1StatusTextChange);
begin Self.OnStatusTextChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnStatusTextChange_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1StatusTextChange);
begin T := Self.OnStatusTextChange; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnNavigateComplete_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1NavigateComplete);
begin Self.OnNavigateComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnNavigateComplete_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1NavigateComplete);
begin T := Self.OnNavigateComplete; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnBeforeNavigate_W(Self: TWebBrowser_V1; const T: TWebBrowser_V1BeforeNavigate);
begin Self.OnBeforeNavigate := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1OnBeforeNavigate_R(Self: TWebBrowser_V1; var T: TWebBrowser_V1BeforeNavigate);
begin T := Self.OnBeforeNavigate; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1Busy_R(Self: TWebBrowser_V1; var T: WordBool);
begin T := Self.Busy; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1LocationURL_R(Self: TWebBrowser_V1; var T: WideString);
begin T := Self.LocationURL; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1LocationName_R(Self: TWebBrowser_V1; var T: WideString);
begin T := Self.LocationName; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1type__R(Self: TWebBrowser_V1; var T: WideString);
begin T := Self.type_; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1TopLevelContainer_R(Self: TWebBrowser_V1; var T: WordBool);
begin T := Self.TopLevelContainer; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1Document_R(Self: TWebBrowser_V1; var T: IDispatch);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1Container_R(Self: TWebBrowser_V1; var T: IDispatch);
begin T := Self.Container; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1Parent_R(Self: TWebBrowser_V1; var T: IDispatch);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1Application_R(Self: TWebBrowser_V1; var T: IDispatch);
begin T := Self.Application; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1DefaultInterface_R(Self: TWebBrowser_V1; var T: IWebBrowser);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TWebBrowser_V1ControlInterface_R(Self: TWebBrowser_V1; var T: IWebBrowser);
begin T := Self.ControlInterface; end;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowser_V1Refresh26_P(Self: TWebBrowser_V1;  var Level : OleVariant);
Begin Self.Refresh2(Level); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowser_V1Refresh25_P(Self: TWebBrowser_V1);
Begin Self.Refresh2; END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowser_V1Navigate4_P(Self: TWebBrowser_V1;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant; const Headers : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName, PostData, Headers); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowser_V1Navigate3_P(Self: TWebBrowser_V1;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant; var PostData : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName, PostData); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowser_V1Navigate2_P(Self: TWebBrowser_V1;  const URL : WideString; const Flags : OleVariant; const TargetFrameName : OleVariant);
Begin Self.Navigate(URL, Flags, TargetFrameName); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowser_V1Navigate1_P(Self: TWebBrowser_V1;  const URL : WideString; const Flags : OleVariant);
Begin Self.Navigate(URL, Flags); END;

(*----------------------------------------------------------------------------*)
Procedure TWebBrowser_V1Navigate0_P(Self: TWebBrowser_V1;  const URL : WideString);
Begin Self.Navigate(URL); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSearchAssistantOC(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSearchAssistantOC) do
  begin
    RegisterMethod(@CoSearchAssistantOC.Create, 'Create');
    RegisterMethod(@CoSearchAssistantOC.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoCScriptErrorList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoCScriptErrorList) do
  begin
    RegisterMethod(@CoCScriptErrorList.Create, 'Create');
    RegisterMethod(@CoCScriptErrorList.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellNameSpace(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellNameSpace) do begin
    RegisterConstructor(@TShellNameSpace.Create, 'Create');
             RegisterMethod(@TShellNameSpace.Destroy, 'Free');
             RegisterMethod(@TShellNameSpace.Connect, 'Connect');
         RegisterMethod(@TShellNameSpace.Disconnect, 'Disconnect');

    RegisterMethod(@TShellNameSpace.ConnectTo, 'ConnectTo');
    RegisterMethod(@TShellNameSpace.MoveSelectionUp, 'MoveSelectionUp');
    RegisterMethod(@TShellNameSpace.MoveSelectionDown, 'MoveSelectionDown');
    RegisterMethod(@TShellNameSpace.ResetSort, 'ResetSort');
    RegisterMethod(@TShellNameSpace.NewFolder, 'NewFolder');
    RegisterMethod(@TShellNameSpace.Synchronize, 'Synchronize');
    RegisterMethod(@TShellNameSpace.InvokeContextMenuCommand, 'InvokeContextMenuCommand');
    RegisterMethod(@TShellNameSpace.MoveSelectionTo, 'MoveSelectionTo');
    RegisterMethod(@TShellNameSpace.CreateSubscriptionForSelection, 'CreateSubscriptionForSelection');
    RegisterMethod(@TShellNameSpace.DeleteSubscriptionForSelection, 'DeleteSubscriptionForSelection');
    RegisterMethod(@TShellNameSpace.SetRoot, 'SetRoot');
    RegisterMethod(@TShellNameSpace.SetViewType, 'SetViewType');
    RegisterMethod(@TShellNameSpace.SelectedItems, 'SelectedItems');
    RegisterMethod(@TShellNameSpace.Expand, 'Expand');
    RegisterMethod(@TShellNameSpace.UnselectAll, 'UnselectAll');
    RegisterPropertyHelper(@TShellNameSpaceDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TShellNameSpaceSubscriptionsEnabled_R,nil,'SubscriptionsEnabled');
    RegisterPropertyHelper(@TShellNameSpaceSelectedItem_R,@TShellNameSpaceSelectedItem_W,'SelectedItem');
    RegisterPropertyHelper(@TShellNameSpaceRoot_R,@TShellNameSpaceRoot_W,'Root');
    RegisterPropertyHelper(@TShellNameSpaceCountViewTypes_R,nil,'CountViewTypes');
    RegisterPropertyHelper(@TShellNameSpaceEnumOptions_R,@TShellNameSpaceEnumOptions_W,'EnumOptions');
    RegisterPropertyHelper(@TShellNameSpaceDepth_R,@TShellNameSpaceDepth_W,'Depth');
    RegisterPropertyHelper(@TShellNameSpaceMode_R,@TShellNameSpaceMode_W,'Mode');
    RegisterPropertyHelper(@TShellNameSpaceFlags_R,@TShellNameSpaceFlags_W,'Flags');
    RegisterPropertyHelper(@TShellNameSpaceTVFlags_R,@TShellNameSpaceTVFlags_W,'TVFlags');
    RegisterPropertyHelper(@TShellNameSpaceColumns_R,@TShellNameSpaceColumns_W,'Columns');
    RegisterPropertyHelper(@TShellNameSpaceOnFavoritesSelectionChange_R,@TShellNameSpaceOnFavoritesSelectionChange_W,'OnFavoritesSelectionChange');
    RegisterPropertyHelper(@TShellNameSpaceOnSelectionChange_R,@TShellNameSpaceOnSelectionChange_W,'OnSelectionChange');
    RegisterPropertyHelper(@TShellNameSpaceOnDoubleClick_R,@TShellNameSpaceOnDoubleClick_W,'OnDoubleClick');
    RegisterPropertyHelper(@TShellNameSpaceOnInitialized_R,@TShellNameSpaceOnInitialized_W,'OnInitialized');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoShellNameSpace(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoShellNameSpace) do
  begin
    RegisterMethod(@CoShellNameSpace.Create, 'Create');
    RegisterMethod(@CoShellNameSpace.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellUIHelper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellUIHelper) do begin
    RegisterConstructor(@TShellUIHelper.Create, 'Create');
             RegisterMethod(@TShellUIHelper.Destroy, 'Free');
             RegisterMethod(@TShellUIHelper.Connect, 'Connect');
         RegisterMethod(@TShellUIHelper.Disconnect, 'Disconnect');

    RegisterMethod(@TShellUIHelper.ConnectTo, 'ConnectTo');
    RegisterMethod(@TShellUIHelper.ResetFirstBootMode, 'ResetFirstBootMode');
    RegisterMethod(@TShellUIHelper.ResetSafeMode, 'ResetSafeMode');
    RegisterMethod(@TShellUIHelper.RefreshOfflineDesktop, 'RefreshOfflineDesktop');
    RegisterMethod(@TShellUIHelperAddFavorite45_P, 'AddFavorite45');
    RegisterMethod(@TShellUIHelperAddFavorite46_P, 'AddFavorite46');
    RegisterMethod(@TShellUIHelper.AddChannel, 'AddChannel');
    RegisterMethod(@TShellUIHelperAddDesktopComponent47_P, 'AddDesktopComponent47');
    RegisterMethod(@TShellUIHelperAddDesktopComponent48_P, 'AddDesktopComponent48');
    RegisterMethod(@TShellUIHelperAddDesktopComponent49_P, 'AddDesktopComponent49');
    RegisterMethod(@TShellUIHelperAddDesktopComponent50_P, 'AddDesktopComponent50');
    RegisterMethod(@TShellUIHelperAddDesktopComponent51_P, 'AddDesktopComponent51');
    RegisterMethod(@TShellUIHelper.IsSubscribed, 'IsSubscribed');
    RegisterMethod(@TShellUIHelper.NavigateAndFind, 'NavigateAndFind');
    RegisterMethod(@TShellUIHelper.ImportExportFavorites, 'ImportExportFavorites');
    RegisterMethod(@TShellUIHelperAutoCompleteSaveForm52_P, 'AutoCompleteSaveForm52');
    RegisterMethod(@TShellUIHelperAutoCompleteSaveForm53_P, 'AutoCompleteSaveForm53');
    RegisterMethod(@TShellUIHelperAutoScan54_P, 'AutoScan54');
    RegisterMethod(@TShellUIHelperAutoScan55_P, 'AutoScan55');
    RegisterMethod(@TShellUIHelperAutoCompleteAttach56_P, 'AutoCompleteAttach56');
    RegisterMethod(@TShellUIHelperAutoCompleteAttach57_P, 'AutoCompleteAttach57');
    RegisterMethod(@TShellUIHelper.ShowBrowserUI, 'ShowBrowserUI');
    RegisterPropertyHelper(@TShellUIHelperDefaultInterface_R,nil,'DefaultInterface');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoShellUIHelper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoShellUIHelper) do
  begin
    RegisterMethod(@CoShellUIHelper.Create, 'Create');
    RegisterMethod(@CoShellUIHelper.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellWindows(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellWindows) do begin
    //RegisterMethod(@TShellWindows.ConnectTo, 'ConnectTo');
       RegisterConstructor(@TShellWindows.Create, 'Create');
             RegisterMethod(@TShellWindows.Destroy, 'Free');
             RegisterMethod(@TShellWindows.Connect, 'Connect');
         RegisterMethod(@TShellWindows.Disconnect, 'Disconnect');

    RegisterMethod(@TShellWindows.ConnectTo, 'ConnectTo');
    RegisterMethod(@TShellWindowsItem43_P, 'Item43');
    RegisterMethod(@TShellWindowsItem44_P, 'Item44');
    RegisterMethod(@TShellWindows._NewEnum, '_NewEnum');
    RegisterMethod(@TShellWindows.Register, 'Register');
    RegisterMethod(@TShellWindows.RegisterPending, 'RegisterPending');
    RegisterMethod(@TShellWindows.Revoke, 'Revoke');
    RegisterMethod(@TShellWindows.OnNavigate, 'OnNavigate');
    RegisterMethod(@TShellWindows.OnActivated, 'OnActivated');
    RegisterMethod(@TShellWindows.FindWindowSW, 'FindWindowSW');
    RegisterMethod(@TShellWindows.OnCreated, 'OnCreated');
    RegisterMethod(@TShellWindows.ProcessAttachDetach, 'ProcessAttachDetach');
    RegisterPropertyHelper(@TShellWindowsDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TShellWindowsCount_R,nil,'Count');
    RegisterPropertyHelper(@TShellWindowsOnWindowRegistered_R,@TShellWindowsOnWindowRegistered_W,'OnWindowRegistered');
    RegisterPropertyHelper(@TShellWindowsOnWindowRevoked_R,@TShellWindowsOnWindowRevoked_W,'OnWindowRevoked');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoShellWindows(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoShellWindows) do
  begin
    RegisterMethod(@CoShellWindows.Create, 'Create');
    RegisterMethod(@CoShellWindows.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoShellBrowserWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoShellBrowserWindow) do
  begin
    RegisterMethod(@CoShellBrowserWindow.Create, 'Create');
    RegisterMethod(@CoShellBrowserWindow.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInternetExplorer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInternetExplorer) do begin
    RegisterMethod(@TInternetExplorer.ConnectTo, 'ConnectTo');
       RegisterConstructor(@TInternetExplorer.Create, 'Create');
             RegisterMethod(@TInternetExplorer.Destroy, 'Free');
             RegisterMethod(@TInternetExplorer.Connect, 'Connect');
         RegisterMethod(@TInternetExplorer.Disconnect, 'Disconnect');

    RegisterMethod(@TInternetExplorer.GoBack, 'GoBack');
    RegisterMethod(@TInternetExplorer.GoForward, 'GoForward');
    RegisterMethod(@TInternetExplorer.GoHome, 'GoHome');
    RegisterMethod(@TInternetExplorer.GoSearch, 'GoSearch');
    RegisterMethod(@TInternetExplorerNavigate25_P, 'Navigate25');
    RegisterMethod(@TInternetExplorerNavigate26_P, 'Navigate26');
    RegisterMethod(@TInternetExplorerNavigate27_P, 'Navigate27');
    RegisterMethod(@TInternetExplorerNavigate28_P, 'Navigate28');
    RegisterMethod(@TInternetExplorerNavigate29_P, 'Navigate29');
    RegisterMethod(@TInternetExplorer.Refresh, 'Refresh');
    RegisterMethod(@TInternetExplorerRefresh230_P, 'Refresh230');
    RegisterMethod(@TInternetExplorerRefresh231_P, 'Refresh231');
    RegisterMethod(@TInternetExplorer.Stop, 'Stop');
    RegisterMethod(@TInternetExplorer.Quit, 'Quit');
    RegisterMethod(@TInternetExplorer.ClientToWindow, 'ClientToWindow');
    RegisterMethod(@TInternetExplorer.PutProperty, 'PutProperty');
    RegisterMethod(@TInternetExplorer.GetProperty, 'GetProperty');
    RegisterMethod(@TInternetExplorerNavigate232_P, 'Navigate232');
    RegisterMethod(@TInternetExplorerNavigate233_P, 'Navigate233');
    RegisterMethod(@TInternetExplorerNavigate234_P, 'Navigate234');
    RegisterMethod(@TInternetExplorerNavigate235_P, 'Navigate235');
    RegisterMethod(@TInternetExplorerNavigate236_P, 'Navigate236');
    RegisterMethod(@TInternetExplorer.QueryStatusWB, 'QueryStatusWB');
    RegisterMethod(@TInternetExplorerExecWB37_P, 'ExecWB37');
    RegisterMethod(@TInternetExplorerExecWB38_P, 'ExecWB38');
    RegisterMethod(@TInternetExplorerExecWB39_P, 'ExecWB39');
    RegisterMethod(@TInternetExplorerShowBrowserBar40_P, 'ShowBrowserBar40');
    RegisterMethod(@TInternetExplorerShowBrowserBar41_P, 'ShowBrowserBar41');
    RegisterMethod(@TInternetExplorerShowBrowserBar42_P, 'ShowBrowserBar42');
    RegisterPropertyHelper(@TInternetExplorerDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TInternetExplorerApplication_R,nil,'Application');
    RegisterPropertyHelper(@TInternetExplorerParent_R,nil,'Parent');
    RegisterPropertyHelper(@TInternetExplorerContainer_R,nil,'Container');
    RegisterPropertyHelper(@TInternetExplorerDocument_R,nil,'Document');
    RegisterPropertyHelper(@TInternetExplorerTopLevelContainer_R,nil,'TopLevelContainer');
    RegisterPropertyHelper(@TInternetExplorertype__R,nil,'type_');
    RegisterPropertyHelper(@TInternetExplorerLocationName_R,nil,'LocationName');
    RegisterPropertyHelper(@TInternetExplorerLocationURL_R,nil,'LocationURL');
    RegisterPropertyHelper(@TInternetExplorerBusy_R,nil,'Busy');
    RegisterPropertyHelper(@TInternetExplorerName_R,nil,'Name');
    RegisterPropertyHelper(@TInternetExplorerHWnd_R,nil,'HWnd');
    RegisterPropertyHelper(@TInternetExplorerFullName_R,nil,'FullName');
    RegisterPropertyHelper(@TInternetExplorerPath_R,nil,'Path');
    RegisterPropertyHelper(@TInternetExplorerReadyState_R,nil,'ReadyState');
    RegisterPropertyHelper(@TInternetExplorerLeft_R,@TInternetExplorerLeft_W,'Left');
    RegisterPropertyHelper(@TInternetExplorerTop_R,@TInternetExplorerTop_W,'Top');
    RegisterPropertyHelper(@TInternetExplorerWidth_R,@TInternetExplorerWidth_W,'Width');
    RegisterPropertyHelper(@TInternetExplorerHeight_R,@TInternetExplorerHeight_W,'Height');
    RegisterPropertyHelper(@TInternetExplorerVisible_R,@TInternetExplorerVisible_W,'Visible');
    RegisterPropertyHelper(@TInternetExplorerStatusBar_R,@TInternetExplorerStatusBar_W,'StatusBar');
    RegisterPropertyHelper(@TInternetExplorerStatusText_R,@TInternetExplorerStatusText_W,'StatusText');
    RegisterPropertyHelper(@TInternetExplorerToolBar_R,@TInternetExplorerToolBar_W,'ToolBar');
    RegisterPropertyHelper(@TInternetExplorerMenuBar_R,@TInternetExplorerMenuBar_W,'MenuBar');
    RegisterPropertyHelper(@TInternetExplorerFullScreen_R,@TInternetExplorerFullScreen_W,'FullScreen');
    RegisterPropertyHelper(@TInternetExplorerOffline_R,@TInternetExplorerOffline_W,'Offline');
    RegisterPropertyHelper(@TInternetExplorerSilent_R,@TInternetExplorerSilent_W,'Silent');
    RegisterPropertyHelper(@TInternetExplorerRegisterAsBrowser_R,@TInternetExplorerRegisterAsBrowser_W,'RegisterAsBrowser');
    RegisterPropertyHelper(@TInternetExplorerRegisterAsDropTarget_R,@TInternetExplorerRegisterAsDropTarget_W,'RegisterAsDropTarget');
    RegisterPropertyHelper(@TInternetExplorerTheaterMode_R,@TInternetExplorerTheaterMode_W,'TheaterMode');
    RegisterPropertyHelper(@TInternetExplorerAddressBar_R,@TInternetExplorerAddressBar_W,'AddressBar');
    RegisterPropertyHelper(@TInternetExplorerResizable_R,@TInternetExplorerResizable_W,'Resizable');
    RegisterPropertyHelper(@TInternetExplorerOnStatusTextChange_R,@TInternetExplorerOnStatusTextChange_W,'OnStatusTextChange');
    RegisterPropertyHelper(@TInternetExplorerOnProgressChange_R,@TInternetExplorerOnProgressChange_W,'OnProgressChange');
    RegisterPropertyHelper(@TInternetExplorerOnCommandStateChange_R,@TInternetExplorerOnCommandStateChange_W,'OnCommandStateChange');
    RegisterPropertyHelper(@TInternetExplorerOnDownloadBegin_R,@TInternetExplorerOnDownloadBegin_W,'OnDownloadBegin');
    RegisterPropertyHelper(@TInternetExplorerOnDownloadComplete_R,@TInternetExplorerOnDownloadComplete_W,'OnDownloadComplete');
    RegisterPropertyHelper(@TInternetExplorerOnTitleChange_R,@TInternetExplorerOnTitleChange_W,'OnTitleChange');
    RegisterPropertyHelper(@TInternetExplorerOnPropertyChange_R,@TInternetExplorerOnPropertyChange_W,'OnPropertyChange');
    RegisterPropertyHelper(@TInternetExplorerOnBeforeNavigate2_R,@TInternetExplorerOnBeforeNavigate2_W,'OnBeforeNavigate2');
    RegisterPropertyHelper(@TInternetExplorerOnNewWindow2_R,@TInternetExplorerOnNewWindow2_W,'OnNewWindow2');
    RegisterPropertyHelper(@TInternetExplorerOnNavigateComplete2_R,@TInternetExplorerOnNavigateComplete2_W,'OnNavigateComplete2');
    RegisterPropertyHelper(@TInternetExplorerOnDocumentComplete_R,@TInternetExplorerOnDocumentComplete_W,'OnDocumentComplete');
    RegisterPropertyHelper(@TInternetExplorerOnQuit_R,@TInternetExplorerOnQuit_W,'OnQuit');
    RegisterPropertyHelper(@TInternetExplorerOnVisible_R,@TInternetExplorerOnVisible_W,'OnVisible');
    RegisterPropertyHelper(@TInternetExplorerOnToolBar_R,@TInternetExplorerOnToolBar_W,'OnToolBar');
    RegisterPropertyHelper(@TInternetExplorerOnMenuBar_R,@TInternetExplorerOnMenuBar_W,'OnMenuBar');
    RegisterPropertyHelper(@TInternetExplorerOnStatusBar_R,@TInternetExplorerOnStatusBar_W,'OnStatusBar');
    RegisterPropertyHelper(@TInternetExplorerOnFullScreen_R,@TInternetExplorerOnFullScreen_W,'OnFullScreen');
    RegisterPropertyHelper(@TInternetExplorerOnTheaterMode_R,@TInternetExplorerOnTheaterMode_W,'OnTheaterMode');
    RegisterPropertyHelper(@TInternetExplorerOnWindowSetResizable_R,@TInternetExplorerOnWindowSetResizable_W,'OnWindowSetResizable');
    RegisterPropertyHelper(@TInternetExplorerOnWindowSetLeft_R,@TInternetExplorerOnWindowSetLeft_W,'OnWindowSetLeft');
    RegisterPropertyHelper(@TInternetExplorerOnWindowSetTop_R,@TInternetExplorerOnWindowSetTop_W,'OnWindowSetTop');
    RegisterPropertyHelper(@TInternetExplorerOnWindowSetWidth_R,@TInternetExplorerOnWindowSetWidth_W,'OnWindowSetWidth');
    RegisterPropertyHelper(@TInternetExplorerOnWindowSetHeight_R,@TInternetExplorerOnWindowSetHeight_W,'OnWindowSetHeight');
    RegisterPropertyHelper(@TInternetExplorerOnWindowClosing_R,@TInternetExplorerOnWindowClosing_W,'OnWindowClosing');
    RegisterPropertyHelper(@TInternetExplorerOnClientToHostWindow_R,@TInternetExplorerOnClientToHostWindow_W,'OnClientToHostWindow');
    RegisterPropertyHelper(@TInternetExplorerOnSetSecureLockIcon_R,@TInternetExplorerOnSetSecureLockIcon_W,'OnSetSecureLockIcon');
    RegisterPropertyHelper(@TInternetExplorerOnFileDownload_R,@TInternetExplorerOnFileDownload_W,'OnFileDownload');
    RegisterPropertyHelper(@TInternetExplorerOnNavigateError_R,@TInternetExplorerOnNavigateError_W,'OnNavigateError');
    RegisterPropertyHelper(@TInternetExplorerOnPrintTemplateInstantiation_R,@TInternetExplorerOnPrintTemplateInstantiation_W,'OnPrintTemplateInstantiation');
    RegisterPropertyHelper(@TInternetExplorerOnPrintTemplateTeardown_R,@TInternetExplorerOnPrintTemplateTeardown_W,'OnPrintTemplateTeardown');
    RegisterPropertyHelper(@TInternetExplorerOnUpdatePageStatus_R,@TInternetExplorerOnUpdatePageStatus_W,'OnUpdatePageStatus');
    RegisterPropertyHelper(@TInternetExplorerOnPrivacyImpactedStateChange_R,@TInternetExplorerOnPrivacyImpactedStateChange_W,'OnPrivacyImpactedStateChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoInternetExplorer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoInternetExplorer) do
  begin
    RegisterMethod(@CoInternetExplorer.Create, 'Create');
    RegisterMethod(@CoInternetExplorer.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebBrowser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebBrowser) do begin
    RegisterMethod(@TWebBrowser.GoBack, 'GoBack');
    RegisterMethod(@TWebBrowser.GoForward, 'GoForward');
    RegisterMethod(@TWebBrowser.GoHome, 'GoHome');
      RegisterConstructor(@TWebBrowser.Create, 'Create');
             RegisterMethod(@TWebBrowser.Destroy, 'Free');

    RegisterMethod(@TWebBrowser.GoSearch, 'GoSearch');
    RegisterMethod(@TWebBrowserNavigate7_P, 'Navigate7');
     RegisterMethod(@TWebBrowserNavigate7_P, 'Navigate');

    RegisterMethod(@TWebBrowserNavigate8_P, 'Navigate8');
    RegisterMethod(@TWebBrowserNavigate9_P, 'Navigate9');
    RegisterMethod(@TWebBrowserNavigate10_P, 'Navigate10');
    RegisterMethod(@TWebBrowserNavigate11_P, 'Navigate11');
    RegisterMethod(@TWebBrowser.Refresh, 'Refresh');
    RegisterMethod(@TWebBrowserRefresh212_P, 'Refresh212');
    RegisterMethod(@TWebBrowserRefresh213_P, 'Refresh213');
    RegisterMethod(@TWebBrowser.Stop, 'Stop');
    RegisterMethod(@TWebBrowser.Quit, 'Quit');
    RegisterMethod(@TWebBrowser.ClientToWindow, 'ClientToWindow');
    RegisterMethod(@TWebBrowser.PutProperty, 'PutProperty');
    RegisterMethod(@TWebBrowser.GetProperty, 'GetProperty');
    RegisterMethod(@TWebBrowserNavigate214_P, 'Navigate2');

    RegisterMethod(@TWebBrowserNavigate214_P, 'Navigate214');
    RegisterMethod(@TWebBrowserNavigate215_P, 'Navigate215');
    RegisterMethod(@TWebBrowserNavigate216_P, 'Navigate216');
    RegisterMethod(@TWebBrowserNavigate217_P, 'Navigate217');
    RegisterMethod(@TWebBrowserNavigate218_P, 'Navigate218');
    RegisterMethod(@TWebBrowser.QueryStatusWB, 'QueryStatusWB');
    RegisterMethod(@TWebBrowserExecWB19_P, 'ExecWB19');
    RegisterMethod(@TWebBrowserExecWB20_P, 'ExecWB20');
    RegisterMethod(@TWebBrowserExecWB21_P, 'ExecWB21');
    RegisterMethod(@TWebBrowserShowBrowserBar22_P, 'ShowBrowserBar22');
    RegisterMethod(@TWebBrowserShowBrowserBar23_P, 'ShowBrowserBar23');
    RegisterMethod(@TWebBrowserShowBrowserBar24_P, 'ShowBrowserBar24');
    RegisterPropertyHelper(@TWebBrowserControlInterface_R,nil,'ControlInterface');
    RegisterPropertyHelper(@TWebBrowserDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TWebBrowserApplication_R,nil,'Application');
    RegisterPropertyHelper(@TWebBrowserParent_R,nil,'Parent');
    RegisterPropertyHelper(@TWebBrowserContainer_R,nil,'Container');
    RegisterPropertyHelper(@TWebBrowserDocument_R,nil,'Document');
    RegisterPropertyHelper(@TWebBrowserTopLevelContainer_R,nil,'TopLevelContainer');
    RegisterPropertyHelper(@TWebBrowsertype__R,nil,'type_');
    RegisterPropertyHelper(@TWebBrowserLocationName_R,nil,'LocationName');
    RegisterPropertyHelper(@TWebBrowserLocationURL_R,nil,'LocationURL');
    RegisterPropertyHelper(@TWebBrowserBusy_R,nil,'Busy');
    RegisterPropertyHelper(@TWebBrowserName_R,nil,'Name');
    RegisterPropertyHelper(@TWebBrowserFullName_R,nil,'FullName');
    RegisterPropertyHelper(@TWebBrowserPath_R,nil,'Path');
    RegisterPropertyHelper(@TWebBrowserVisible_R,@TWebBrowserVisible_W,'Visible');
    RegisterPropertyHelper(@TWebBrowserStatusBar_R,@TWebBrowserStatusBar_W,'StatusBar');
    RegisterPropertyHelper(@TWebBrowserStatusText_R,@TWebBrowserStatusText_W,'StatusText');
    RegisterPropertyHelper(@TWebBrowserToolBar_R,@TWebBrowserToolBar_W,'ToolBar');
    RegisterPropertyHelper(@TWebBrowserMenuBar_R,@TWebBrowserMenuBar_W,'MenuBar');
    RegisterPropertyHelper(@TWebBrowserFullScreen_R,@TWebBrowserFullScreen_W,'FullScreen');
    RegisterPropertyHelper(@TWebBrowserOffline_R,@TWebBrowserOffline_W,'Offline');
    RegisterPropertyHelper(@TWebBrowserSilent_R,@TWebBrowserSilent_W,'Silent');
    RegisterPropertyHelper(@TWebBrowserRegisterAsBrowser_R,@TWebBrowserRegisterAsBrowser_W,'RegisterAsBrowser');
    RegisterPropertyHelper(@TWebBrowserRegisterAsDropTarget_R,@TWebBrowserRegisterAsDropTarget_W,'RegisterAsDropTarget');
    RegisterPropertyHelper(@TWebBrowserTheaterMode_R,@TWebBrowserTheaterMode_W,'TheaterMode');
    RegisterPropertyHelper(@TWebBrowserAddressBar_R,@TWebBrowserAddressBar_W,'AddressBar');
    RegisterPropertyHelper(@TWebBrowserResizable_R,@TWebBrowserResizable_W,'Resizable');
    RegisterPropertyHelper(@TWebBrowserOnStatusTextChange_R,@TWebBrowserOnStatusTextChange_W,'OnStatusTextChange');
    RegisterPropertyHelper(@TWebBrowserOnProgressChange_R,@TWebBrowserOnProgressChange_W,'OnProgressChange');
    RegisterPropertyHelper(@TWebBrowserOnCommandStateChange_R,@TWebBrowserOnCommandStateChange_W,'OnCommandStateChange');
    RegisterPropertyHelper(@TWebBrowserOnDownloadBegin_R,@TWebBrowserOnDownloadBegin_W,'OnDownloadBegin');
    RegisterPropertyHelper(@TWebBrowserOnDownloadComplete_R,@TWebBrowserOnDownloadComplete_W,'OnDownloadComplete');
    RegisterPropertyHelper(@TWebBrowserOnTitleChange_R,@TWebBrowserOnTitleChange_W,'OnTitleChange');
    RegisterPropertyHelper(@TWebBrowserOnPropertyChange_R,@TWebBrowserOnPropertyChange_W,'OnPropertyChange');
    RegisterPropertyHelper(@TWebBrowserOnBeforeNavigate2_R,@TWebBrowserOnBeforeNavigate2_W,'OnBeforeNavigate2');
    RegisterPropertyHelper(@TWebBrowserOnNewWindow2_R,@TWebBrowserOnNewWindow2_W,'OnNewWindow2');
    RegisterPropertyHelper(@TWebBrowserOnNavigateComplete2_R,@TWebBrowserOnNavigateComplete2_W,'OnNavigateComplete2');
    RegisterPropertyHelper(@TWebBrowserOnDocumentComplete_R,@TWebBrowserOnDocumentComplete_W,'OnDocumentComplete');
    RegisterPropertyHelper(@TWebBrowserOnQuit_R,@TWebBrowserOnQuit_W,'OnQuit');
    RegisterPropertyHelper(@TWebBrowserOnVisible_R,@TWebBrowserOnVisible_W,'OnVisible');
    RegisterPropertyHelper(@TWebBrowserOnToolBar_R,@TWebBrowserOnToolBar_W,'OnToolBar');
    RegisterPropertyHelper(@TWebBrowserOnMenuBar_R,@TWebBrowserOnMenuBar_W,'OnMenuBar');
    RegisterPropertyHelper(@TWebBrowserOnStatusBar_R,@TWebBrowserOnStatusBar_W,'OnStatusBar');
    RegisterPropertyHelper(@TWebBrowserOnFullScreen_R,@TWebBrowserOnFullScreen_W,'OnFullScreen');
    RegisterPropertyHelper(@TWebBrowserOnTheaterMode_R,@TWebBrowserOnTheaterMode_W,'OnTheaterMode');
    RegisterPropertyHelper(@TWebBrowserOnWindowSetResizable_R,@TWebBrowserOnWindowSetResizable_W,'OnWindowSetResizable');
    RegisterPropertyHelper(@TWebBrowserOnWindowSetLeft_R,@TWebBrowserOnWindowSetLeft_W,'OnWindowSetLeft');
    RegisterPropertyHelper(@TWebBrowserOnWindowSetTop_R,@TWebBrowserOnWindowSetTop_W,'OnWindowSetTop');
    RegisterPropertyHelper(@TWebBrowserOnWindowSetWidth_R,@TWebBrowserOnWindowSetWidth_W,'OnWindowSetWidth');
    RegisterPropertyHelper(@TWebBrowserOnWindowSetHeight_R,@TWebBrowserOnWindowSetHeight_W,'OnWindowSetHeight');
    RegisterPropertyHelper(@TWebBrowserOnWindowClosing_R,@TWebBrowserOnWindowClosing_W,'OnWindowClosing');
    RegisterPropertyHelper(@TWebBrowserOnClientToHostWindow_R,@TWebBrowserOnClientToHostWindow_W,'OnClientToHostWindow');
    RegisterPropertyHelper(@TWebBrowserOnSetSecureLockIcon_R,@TWebBrowserOnSetSecureLockIcon_W,'OnSetSecureLockIcon');
    RegisterPropertyHelper(@TWebBrowserOnFileDownload_R,@TWebBrowserOnFileDownload_W,'OnFileDownload');
    RegisterPropertyHelper(@TWebBrowserOnNavigateError_R,@TWebBrowserOnNavigateError_W,'OnNavigateError');
    RegisterPropertyHelper(@TWebBrowserOnPrintTemplateInstantiation_R,@TWebBrowserOnPrintTemplateInstantiation_W,'OnPrintTemplateInstantiation');
    RegisterPropertyHelper(@TWebBrowserOnPrintTemplateTeardown_R,@TWebBrowserOnPrintTemplateTeardown_W,'OnPrintTemplateTeardown');
    RegisterPropertyHelper(@TWebBrowserOnUpdatePageStatus_R,@TWebBrowserOnUpdatePageStatus_W,'OnUpdatePageStatus');
    RegisterPropertyHelper(@TWebBrowserOnPrivacyImpactedStateChange_R,@TWebBrowserOnPrivacyImpactedStateChange_W,'OnPrivacyImpactedStateChange');


  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebBrowser_V1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebBrowser_V1) do begin
    RegisterMethod(@TWebBrowser_V1.GoBack, 'GoBack');
    RegisterMethod(@TWebBrowser_V1.GoForward, 'GoForward');
    RegisterMethod(@TWebBrowser_V1.GoHome, 'GoHome');
     RegisterConstructor(@TWebBrowser_V1.Create, 'Create');
             RegisterMethod(@TWebBrowser_V1.Destroy, 'Free');

    RegisterMethod(@TWebBrowser_V1.GoSearch, 'GoSearch');
    RegisterMethod(@TWebBrowser_V1Navigate0_P, 'Navigate0');
    RegisterMethod(@TWebBrowser_V1Navigate1_P, 'Navigate1');
    RegisterMethod(@TWebBrowser_V1Navigate2_P, 'Navigate2');
    RegisterMethod(@TWebBrowser_V1Navigate3_P, 'Navigate3');
    RegisterMethod(@TWebBrowser_V1Navigate4_P, 'Navigate4');
    RegisterMethod(@TWebBrowser_V1.Refresh, 'Refresh');
    RegisterMethod(@TWebBrowser_V1Refresh25_P, 'Refresh25');
    RegisterMethod(@TWebBrowser_V1Refresh26_P, 'Refresh26');
    RegisterMethod(@TWebBrowser_V1.Stop, 'Stop');
    RegisterPropertyHelper(@TWebBrowser_V1ControlInterface_R,nil,'ControlInterface');
    RegisterPropertyHelper(@TWebBrowser_V1DefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TWebBrowser_V1Application_R,nil,'Application');
    RegisterPropertyHelper(@TWebBrowser_V1Parent_R,nil,'Parent');
    RegisterPropertyHelper(@TWebBrowser_V1Container_R,nil,'Container');
    RegisterPropertyHelper(@TWebBrowser_V1Document_R,nil,'Document');
    RegisterPropertyHelper(@TWebBrowser_V1TopLevelContainer_R,nil,'TopLevelContainer');
    RegisterPropertyHelper(@TWebBrowser_V1type__R,nil,'type_');
    RegisterPropertyHelper(@TWebBrowser_V1LocationName_R,nil,'LocationName');
    RegisterPropertyHelper(@TWebBrowser_V1LocationURL_R,nil,'LocationURL');
    RegisterPropertyHelper(@TWebBrowser_V1Busy_R,nil,'Busy');
    RegisterPropertyHelper(@TWebBrowser_V1OnBeforeNavigate_R,@TWebBrowser_V1OnBeforeNavigate_W,'OnBeforeNavigate');
    RegisterPropertyHelper(@TWebBrowser_V1OnNavigateComplete_R,@TWebBrowser_V1OnNavigateComplete_W,'OnNavigateComplete');
    RegisterPropertyHelper(@TWebBrowser_V1OnStatusTextChange_R,@TWebBrowser_V1OnStatusTextChange_W,'OnStatusTextChange');
    RegisterPropertyHelper(@TWebBrowser_V1OnProgressChange_R,@TWebBrowser_V1OnProgressChange_W,'OnProgressChange');
    RegisterPropertyHelper(@TWebBrowser_V1OnDownloadComplete_R,@TWebBrowser_V1OnDownloadComplete_W,'OnDownloadComplete');
    RegisterPropertyHelper(@TWebBrowser_V1OnCommandStateChange_R,@TWebBrowser_V1OnCommandStateChange_W,'OnCommandStateChange');
    RegisterPropertyHelper(@TWebBrowser_V1OnDownloadBegin_R,@TWebBrowser_V1OnDownloadBegin_W,'OnDownloadBegin');
    RegisterPropertyHelper(@TWebBrowser_V1OnNewWindow_R,@TWebBrowser_V1OnNewWindow_W,'OnNewWindow');
    RegisterPropertyHelper(@TWebBrowser_V1OnTitleChange_R,@TWebBrowser_V1OnTitleChange_W,'OnTitleChange');
    RegisterPropertyHelper(@TWebBrowser_V1OnFrameBeforeNavigate_R,@TWebBrowser_V1OnFrameBeforeNavigate_W,'OnFrameBeforeNavigate');
    RegisterPropertyHelper(@TWebBrowser_V1OnFrameNavigateComplete_R,@TWebBrowser_V1OnFrameNavigateComplete_W,'OnFrameNavigateComplete');
    RegisterPropertyHelper(@TWebBrowser_V1OnFrameNewWindow_R,@TWebBrowser_V1OnFrameNewWindow_W,'OnFrameNewWindow');
    RegisterPropertyHelper(@TWebBrowser_V1OnQuit_R,@TWebBrowser_V1OnQuit_W,'OnQuit');
    RegisterPropertyHelper(@TWebBrowser_V1OnWindowMove_R,@TWebBrowser_V1OnWindowMove_W,'OnWindowMove');
    RegisterPropertyHelper(@TWebBrowser_V1OnWindowResize_R,@TWebBrowser_V1OnWindowResize_W,'OnWindowResize');
    RegisterPropertyHelper(@TWebBrowser_V1OnWindowActivate_R,@TWebBrowser_V1OnWindowActivate_W,'OnWindowActivate');
    RegisterPropertyHelper(@TWebBrowser_V1OnPropertyChange_R,@TWebBrowser_V1OnPropertyChange_W,'OnPropertyChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SHDocVw(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWebBrowser_V1(CL);
  RIRegister_TWebBrowser(CL);
  RIRegister_CoInternetExplorer(CL);
  RIRegister_TInternetExplorer(CL);
  RIRegister_CoShellBrowserWindow(CL);
  RIRegister_CoShellWindows(CL);
  RIRegister_TShellWindows(CL);
  RIRegister_CoShellUIHelper(CL);
  RIRegister_TShellUIHelper(CL);
  RIRegister_CoShellNameSpace(CL);
  RIRegister_TShellNameSpace(CL);
  RIRegister_CoCScriptErrorList(CL);
  RIRegister_CoSearchAssistantOC(CL);
end;

 
 
{ TPSImport_SHDocVw }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SHDocVw.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SHDocVw(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SHDocVw.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SHDocVw(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
