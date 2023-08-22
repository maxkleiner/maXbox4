{ Compiletime Forms support }

// add procedure SIRegisterTSCREEN(Cl: TPSPascalCompiler);
// and NO NativeString
// add TStatusBar  and Panels
// screen with cursors , apponexception    3.8.6.4
// bugfix application.showexception
// add TMonitor                            3.9.9
//  RegisterMethod('constructor Create(AOwner: TComponent);');
  //    RegisterMethod('Procedure Free');   in TForm -- 3.9.9.85 /95   more form props    add windowmenu
  //glass frame add 4.2.4.25  parentbidimode     - 4.7.5.20 OnMouseWheel   locs=730

unit uPSC_forms;
{$I PascalScript.inc}

interface
uses
  uPSCompiler, uPSUtils;

procedure SIRegister_Forms_TypesAndConsts(Cl: TPSPascalCompiler);

procedure SIRegister_TMonitor(CL: TPSPascalCompiler);
procedure SIRegisterTCONTROLSCROLLBAR(Cl: TPSPascalCompiler);
procedure SIRegisterTSCROLLINGWINCONTROL(Cl: TPSPascalCompiler);
procedure SIRegisterTSCROLLBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTFORM(Cl: TPSPascalCompiler);
procedure SIRegisterTAPPLICATION(Cl: TPSPascalCompiler);
procedure SIRegister_TScreen(CL: TPSPascalCompiler);
procedure SIRegister_TStatusBar(CL: TPSPascalCompiler);       //in comctrls!
procedure SIRegister_TCustomStatusBar(CL: TPSPascalCompiler);
procedure SIRegister_TStatusPanels(CL: TPSPascalCompiler);
procedure SIRegister_TStatusPanel(CL: TPSPascalCompiler);
//procedure SIRegister_TMonitor(CL: TPSPascalCompiler);
procedure SIRegister_TGlassFrame(CL: TPSPascalCompiler);
//procedure SIRegister_IOleForm(CL: TPSPascalCompiler);
procedure SIRegister_TFrame(CL: TPSPascalCompiler);
procedure SIRegister_TCustomFrame(CL: TPSPascalCompiler);


procedure SIRegister_Forms(Cl: TPSPascalCompiler);

implementation

//uses sysutils;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGlassFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TGlassFrame') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TGlassFrame') do
  begin
    RegisterMethod('Constructor Create( Client : TCustomForm)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function FrameExtended : Boolean');
    RegisterMethod('Function IntersectsControl( Control : TControl) : Boolean');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Right', 'Integer', iptrw);
    RegisterProperty('Bottom', 'Integer', iptrw);
    RegisterProperty('SheetOfGlass', 'Boolean', iptrw);
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_TMonitor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMonitor') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMonitor') do begin
    RegisterProperty('Handle', 'HMONITOR', iptr);
    RegisterProperty('MonitorNum', 'Integer', iptr);
    RegisterProperty('Left', 'Integer', iptr);
    RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('Top', 'Integer', iptr);
    RegisterProperty('Width', 'Integer', iptr);
    RegisterProperty('BoundsRect', 'TRect', iptr);
    RegisterProperty('WorkareaRect', 'TRect', iptr);
    RegisterProperty('Primary', 'Boolean', iptr);
  end;
end;


procedure SIRegisterTCONTROLSCROLLBAR(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TPERSISTENT'), 'TCONTROLSCROLLBAR') do begin
     RegisterMethod('Assign(Source: TPersistent);');
    RegisterMethod('procedure ChangeBiDiPosition;');
    RegisterMethod('function IsScrollBarVisible: Boolean;');
   RegisterProperty('KIND', 'TSCROLLBARKIND', iptr);
    RegisterProperty('SCROLLPOS', 'INTEGER', iptr);
    RegisterProperty('MARGIN', 'WORD', iptrw);
    RegisterProperty('INCREMENT', 'TSCROLLBARINC', iptrw);
    RegisterProperty('RANGE', 'INTEGER', iptrw);
    RegisterProperty('POSITION', 'INTEGER', iptrw);
    RegisterProperty('TRACKING', 'BOOLEAN', iptrw);
    RegisterProperty('VISIBLE', 'BOOLEAN', iptrw);
  end;
end;

procedure SIRegisterTSCROLLINGWINCONTROL(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TWINCONTROL'), 'TSCROLLINGWINCONTROL') do begin
    RegisterMethod('procedure SCROLLINVIEW(ACONTROL:TCONTROL)');
    RegisterMethod('constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure EnableAutoRange');
    RegisterMethod('procedure DisableAutoRange');
    RegisterPublishedProperties;

    RegisterProperty('OnAlignInsertBefore', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('OnAlignPosition', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('HORZSCROLLBAR', 'TCONTROLSCROLLBAR', iptrw);
    RegisterProperty('VERTSCROLLBAR', 'TCONTROLSCROLLBAR', iptrw);
  end;
end;

procedure SIRegisterTSCROLLBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TSCROLLINGWINCONTROL'), 'TSCROLLBOX') do begin
    RegisterProperty('BORDERSTYLE', 'TBORDERSTYLE', iptrw);
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('FONT', 'TFONT', iptrw);                    
    RegisterProperty('AUTOSCROLL', 'BOOLEAN', iptrw);
    RegisterProperty('PARENTCOLOR', 'BOOLEAN', iptrw);
    RegisterProperty('PARENTFONT', 'BOOLEAN', iptrw);
    RegisterProperty('ParentBiDiMode', 'boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterProperty('ONRESIZE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('DRAGCURSOR', 'TCURSOR', iptrw);
    RegisterProperty('DRAGMODE', 'TDRAGMODE', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'BOOLEAN', iptrw);
    RegisterProperty('POPUPMENU', 'TPOPUPMENU', iptrw);
    RegisterProperty('CTL3D', 'BOOLEAN', iptrw);
    RegisterProperty('PARENTCTL3D', 'BOOLEAN', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDRAGDROPEVENT', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDRAGOVEREVENT', iptrw);
    RegisterProperty('ONENDDRAG', 'TENDDRAGEVENT', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMOUSEEVENT', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMOUSEMOVEEVENT', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMOUSEEVENT', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('OnMouseWheel', 'TMOUSEWheelEVENT', iptrw);
    RegisterProperty('OnMouseWheelDown', 'TMOUSEWheelEVENT', iptrw);
    RegisterProperty('OnMouseWheelup', 'TMOUSEWheelEVENT', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTFORM(Cl: TPSPascalCompiler);
begin
 with Cl.AddClassN(cl.FindClass('TSCROLLINGWINCONTROL'), 'TFORM') do begin
    {$IFDEF DELPHI4UP}
    RegisterMethod('constructor CREATENEW(AOWNER:TCOMPONENT; Dummy: Integer)');
    {$ELSE}
    RegisterMethod('constructor CREATENEW(AOWNER:TCOMPONENT)');
    {$ENDIF}
    RegisterMethod('constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure FreeOnRelease');

    RegisterPublishedProperties;
    RegisterMethod('procedure CLOSE');
    RegisterMethod('procedure HIDE');
    RegisterMethod('procedure SHOW');
    RegisterMethod('function SHOWMODAL:INTEGER');
    RegisterMethod('function InstanceSize: Longint');
    RegisterMethod('procedure RecreateAsPopup(AWindowHandle: HWND);');
    RegisterMethod('function IsShortCut(var Message: TWMKey): Boolean;');
    RegisterMethod('procedure MakeFullyVisible(AMonitor: TMonitor);');
    RegisterMethod('procedure SendCancelMode(Sender: TControl);');
    RegisterMethod('procedure Dock(NewDockSite: TWinControl; ARect: TRect);');
    RegisterMethod('procedure DefaultHandler(var Message);');
    //RegisterMethod('procedure Dock(NewDockSite: TWinControl; ARect: TRect);');
    RegisterMethod('function GetFormImage: TBitmap;');
    RegisterMethod('procedure MouseWheelHandler(var Message: TMessage);');
    RegisterMethod('function WantChildKey(Child: TControl; var Message: TMessage): Boolean;');
   //procedure MouseWheelHandler(var Message: TMessage); override;
   //function WantChildKey(Child: TControl; var Message: TMessage): Boolean; virtual;
    RegisterMethod('procedure RELEASE');
    RegisterProperty('ACTIVE', 'BOOLEAN', iptr);
    RegisterProperty('ACTIVECONTROL', 'TWINCONTROL', iptrw);
    RegisterProperty('BORDERICONS', 'TBorderIcons', iptrw);
    RegisterProperty('BORDERSTYLE', 'TFORMBORDERSTYLE', iptrw);
    RegisterProperty('BORDERWIDTH', 'TBorderWidth', iptrw);
    RegisterProperty('CAPTION', 'STRING', iptrw);
    RegisterProperty('AUTOSCROLL', 'BOOLEAN', iptrw);
    RegisterProperty('AUTOSIZE', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TCOLOR', iptrw);
    RegisterProperty('FONT', 'TFONT', iptrw);
    RegisterProperty('ICON', 'TICON', iptrw);
    RegisterProperty('ClientRect', 'TRect', iptr);
    RegisterProperty('MENU', 'TMainMenu', iptrw);
    RegisterProperty('Monitor', 'TMonitor', iptr);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    RegisterProperty('ParentBiDiMode', 'boolean', iptrw);

    //    property ParentBiDiMode;

    // property Monitor: TMonitor read GetMonitor;

    RegisterProperty('FORMSTYLE', 'TFORMSTYLE', iptrw);
    RegisterProperty('KEYPREVIEW', 'BOOLEAN', iptrw);
    RegisterProperty('POSITION', 'TPOSITION', iptrw);
    RegisterProperty('ONACTIVATE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONCLOSE', 'TCLOSEEVENT', iptrw);
    RegisterProperty('ONCLOSEQUERY', 'TCLOSEQUERYEVENT', iptrw);
    RegisterProperty('ONCREATE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDESTROY', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDEACTIVATE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONHIDE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKEYEVENT', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKEYPRESSEVENT', iptrw);
    RegisterProperty('ONKEYUP', 'TKEYEVENT', iptrw);
    RegisterProperty('ONRESIZE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONCANRESIZE', 'TCanResizeEvent', iptrw);
    RegisterProperty('ONSHOW', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('DOUBLEBUFFERED', 'BOOLEAN', iptrw);
    RegisterProperty('OnConstrainedResize', 'TConstrainedResizeEvent', iptrw);

                             //tkeyevent
       {$IFNDEF PS_MINIVCL}
    {$IFNDEF CLX}
    RegisterMethod('procedure ARRANGEICONS');
    RegisterMethod('function GETFORMIMAGE:TBITMAP');
    RegisterMethod('procedure PRINT');
    RegisterMethod('procedure SENDCANCELMODE(SENDER:TCONTROL)');
    RegisterProperty('ACTIVEOLECONTROL', 'TWINCONTROL', iptrw);
    RegisterProperty('OLEFORMOBJECT', 'TOLEFORMOBJECT', iptrw);
    RegisterProperty('CLIENTHANDLE', 'LONGINT', iptr);
    RegisterProperty('TILEMODE', 'TTILEMODE', iptrw);
    {$ENDIF}
    RegisterMethod('procedure CASCADE');
    RegisterMethod('function CLOSEQUERY:BOOLEAN');
    RegisterMethod('procedure DEFOCUSCONTROL(CONTROL:TWINCONTROL;REMOVING:BOOLEAN)');
    RegisterMethod('procedure FOCUSCONTROL(CONTROL:TWINCONTROL)');
    RegisterMethod('procedure NEXT');
    RegisterMethod('procedure PREVIOUS');
    RegisterMethod('function SETFOCUSEDCONTROL(CONTROL:TWINCONTROL):BOOLEAN');
    RegisterMethod('procedure TILE');
    RegisterMethod('function ClassNameIs(const Name: string): Boolean');  //3.6 test
    RegisterProperty('ACTIVEMDICHILD', 'TFORM', iptr);
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
    RegisterProperty('DROPTARGET', 'BOOLEAN', iptrw);
    RegisterProperty('MODALRESULT', 'Longint', iptrw);
    RegisterProperty('MDICHILDCOUNT', 'INTEGER', iptr);
    RegisterProperty('MDICHILDREN', 'TFORM INTEGER', iptr);
    RegisterProperty('ICON', 'TICON', iptrw);
    RegisterProperty('FormState', 'TFormState', iptr);
    //property FormState: TFormState read FFormState;
    RegisterProperty('ScreenSnap', 'Boolean', iptrw);
    RegisterProperty('SnapBuffer', 'Integer', iptrw);
    RegisterProperty('MENU', 'TMAINMENU', iptrw);
    RegisterProperty('OBJECTMENUITEM', 'TMENUITEM', iptrw);
    RegisterProperty('PIXELSPERINCH', 'INTEGER', iptrw);
    RegisterProperty('PRINTSCALE', 'TPRINTSCALE', iptrw);
    RegisterProperty('SCALED', 'BOOLEAN', iptrw);
    RegisterProperty('WINDOWSTATE', 'TWINDOWSTATE', iptrw);
    RegisterProperty('WINDOWMENU', 'TMENUITEM', iptrw);
    RegisterProperty('CTL3D', 'BOOLEAN', iptrw);
    RegisterProperty('POPUPMENU', 'TPOPUPMENU', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDRAGDROPEVENT', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDRAGOVEREVENT', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMOUSEEVENT', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMOUSEMOVEEVENT', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMOUSEEVENT', iptrw);
    RegisterProperty('ONPAINT', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONMINIMIZE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('OldCreateOrder', 'Boolean', iptrw);
    RegisterProperty('TransparentColor', 'Boolean', iptrw);
    RegisterProperty('OnMouseWheel', 'TMOUSEWheelEVENT', iptrw);
    RegisterProperty('OnMouseWheelDown', 'TMOUSEWheelEVENT', iptrw);
    RegisterProperty('OnMouseWheelup', 'TMOUSEWheelEVENT', iptrw);


    // property OnMouseWheelDown;
    //property OnMouseWheelUp;
    //property OnMouseWheel;
 RegisterProperty('TransparentColorValue', 'TColor', iptrw);

 RegisterProperty('AlphaBlend', 'Boolean', iptrw);
 RegisterProperty('AlphaBlendValue', 'Byte', iptrw);
 RegisterProperty('VertScrollBar', 'TControlScrollBar', iptrw);
 RegisterProperty('HorzScrollBar', 'TControlScrollBar', iptrw);


    {$ENDIF}
  end;
end;

procedure SIRegisterTAPPLICATION(Cl: TPSPascalCompiler);
begin
  //with CL.Add(Exception) do begin
  //with CL.AddClassN(CL.FindClass('TObject'),'Exception') do
  with Cl.AddClassN(cl.FindClass('TCOMPONENT'), 'TAPPLICATION') do begin
    RegisterMethod('procedure BRINGTOFRONT');
    RegisterMethod('function MESSAGEBOX(TEXT,CAPTION:PCHAR;FLAGS:WORD):INTEGER');
    RegisterMethod('procedure MINIMIZE');
    //RegisterMethod('procedure MAXIMIZE');
    RegisterMethod('procedure PROCESSMESSAGES');
    RegisterMethod('procedure RESTORE');
    RegisterMethod('procedure TERMINATE');
    //RegisterMethod('procedure ShowException(E: Exception');
    RegisterMethod('function InstanceSize: Longint');
    RegisterMethod('procedure ModalStarted');
    RegisterMethod('procedure ModalFinished');
    RegisterMethod('function IsRightToLeft: Boolean');
    RegisterMethod('procedure DoApplicationIdle');
   //  procedure HideHint;
    RegisterMethod('procedure HookSynchronizeWakeup');
    //function IsRightToLeft: Boolean;
    //procedure CreateForm(InstanceClass: TComponentClass; var Reference);
    RegisterProperty('ACTIVE', 'BOOLEAN', iptr);
    RegisterProperty('EXENAME', 'STRING', iptr);
    {$IFNDEF CLX}
    RegisterProperty('HANDLE', 'LONGINT', iptrw);
    RegisterProperty('UPDATEFORMATSETTINGS', 'BOOLEAN', iptrw);
    RegisterMethod('function HELPCOMMAND(COMMAND:INTEGER;DATA:LONGINT):BOOLEAN');
    RegisterMethod('function HELPCONTEXT(CONTEXT:THELPCONTEXT):BOOLEAN');
    RegisterMethod('function HELPJUMP(JUMPID:STRING):BOOLEAN');
    {$ENDIF}

    {$IFNDEF PS_MINIVCL}
    RegisterMethod('procedure CONTROLDESTROYED(CONTROL:TCONTROL)');
    RegisterMethod('procedure CANCELHINT');
    RegisterMethod('procedure HANDLEEXCEPTION(SENDER:TOBJECT)');
    RegisterMethod('procedure HANDLEMESSAGE');
    RegisterMethod('procedure HIDEHINT');
//    RegisterMethod('procedure HINTMOUSEMESSAGE(CONTROL:TCONTROL;var MESSAGE:TMESSAGE)');
    RegisterMethod('procedure INITIALIZE');
    RegisterMethod('procedure NORMALIZETOPMOSTS');
    RegisterMethod('procedure RESTORETOPMOSTS');
    RegisterMethod('procedure RUN');

    RegisterMethod('Procedure ActivateHint( CursorPos : TPoint)');
    RegisterMethod('Function AddPopupForm( APopupForm : TCustomForm) : Integer');
    RegisterMethod('Procedure ControlDestroyed( Control : TControl)');
    //RegisterMethod('Procedure CreateForm( InstanceClass : TComponentClass; var Reference)');
    RegisterMethod('Procedure CreateHandle');
    RegisterMethod('Function ExecuteAction( Action : TBasicAction) : Boolean');
    RegisterMethod('Function HelpKeyword( const Keyword : string) : Boolean');
    RegisterMethod('Function HelpShowTableOfContents : Boolean');
    RegisterMethod('Procedure HintMouseMessage( Control : TControl; var Message : TMessage)');
    //RegisterMethod('Procedure HookMainWindow( Hook : TWindowHook)');
    RegisterMethod('Procedure HookSynchronizeWakeup');
    RegisterMethod('Procedure NormalizeAllTopMosts');
    RegisterMethod('Procedure RemovePopupForm( APopupForm : TCustomForm)');
    RegisterMethod('Function UpdateAction( Action : TBasicAction) : Boolean');
    RegisterMethod('Function UseRightToLeftAlignment : Boolean');
    RegisterMethod('Function UseRightToLeftReading : Boolean');
    RegisterMethod('Function UseRightToLeftScrollBar : Boolean');
    RegisterMethod('procedure UnhookSynchronizeWakeup;');

    RegisterMethod('procedure SHOWEXCEPTION(E:EXCEPTION)');
    {$IFNDEF CLX}
    RegisterProperty('DIALOGHANDLE', 'LONGINT', iptrw);
    RegisterProperty('ActiveFormHandle', 'HWND', iptr);
    RegisterProperty('MainFormHandle', 'HWND', iptr);

    RegisterMethod('procedure CREATEHANDLE');
    RegisterMethod('procedure HOOKMAINWINDOW(HOOK:TWINDOWHOOK)');
    RegisterMethod('procedure UNHOOKMAINWINDOW(HOOK:TWINDOWHOOK)');
    {$ENDIF}
     RegisterProperty('HINT', 'STRING', iptrw);
    RegisterProperty('MAINFORM', 'TFORM', iptr);
    RegisterProperty('SHOWHINT', 'BOOLEAN', iptrw);
    RegisterProperty('SHOWMAINFORM', 'BOOLEAN', iptrw);
    RegisterProperty('TERMINATED', 'BOOLEAN', iptr);
    RegisterProperty('TITLE', 'STRING', iptrw);
    RegisterProperty('ONACTIVATE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDEACTIVATE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONIDLE', 'TIDLEEVENT', iptrw);
    RegisterProperty('ONHINT', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONMINIMIZE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONRESTORE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXCEPTION', 'TEXCEPTIONEVENT', iptrw);
    RegisterProperty('ONMESSAGE', 'TMESSAGEEVENT', iptrw);
    RegisterProperty('ONSETTINGCHANGE', 'TSettingChangeEvent', iptrw);
    RegisterProperty('HELPFILE', 'STRING', iptrw);
    RegisterProperty('HINTCOLOR', 'TCOLOR', iptrw);
    RegisterProperty('HINTPAUSE', 'INTEGER', iptrw);
    RegisterProperty('HINTSHORTPAUSE', 'INTEGER', iptrw);
    RegisterProperty('HINTHIDEPAUSE', 'INTEGER', iptrw);
    RegisterProperty('ICON', 'TICON', iptrw);
    RegisterProperty('ONHELP', 'THELPEVENT', iptrw);
    RegisterProperty('HintShortCuts', 'Boolean', iptrw);

    RegisterProperty('ActionUpdateDelay', 'Integer', iptrw);
    RegisterProperty('AllowTesting', 'Boolean', iptrw);
    RegisterProperty('AutoDragDocking', 'Boolean', iptrw);
    RegisterProperty('MainFormOnTaskBar', 'Boolean', iptrw);  //class helper of!

     RegisterProperty('HelpSystem', 'IHelpSystem', iptr);
    RegisterProperty('CurrentHelpFile', 'string', iptr);
    RegisterProperty('HintHidePause', 'Integer', iptrw);
    //RegisterProperty('HintShortCuts', 'Boolean', iptrw);
    RegisterProperty('ModalLevel', 'Integer', iptr);
    RegisterProperty('ModalPopupMode', 'TPopupMode', iptrw);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    //RegisterProperty('ParentBiDiMode', 'TBiDiMode', iptrw);
    RegisterProperty('BiDiKeyboard', 'string', iptrw);
    RegisterProperty('NonBiDiKeyboard', 'string', iptrw);
    RegisterProperty('PopupControlWnd', 'HWND', iptr);
    RegisterProperty('UpdateMetricSettings', 'Boolean', iptrw);
    RegisterProperty('OnActionExecute', 'TActionEvent', iptrw);
    RegisterProperty('OnActionUpdate', 'TActionEvent', iptrw);
    RegisterProperty('OnGetActiveFormHandle', 'TGetHandleEvent', iptrw);
    RegisterProperty('OnGetMainFormHandle', 'TGetHandleEvent', iptrw);
    RegisterProperty('OnModalBegin', 'TNotifyEvent', iptrw);
    RegisterProperty('OnModalEnd', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShowHint', 'TShowHintEvent', iptrw);
    RegisterProperty('OnShortCut', 'TShortCutEvent', iptrw);

    {$ENDIF}
  end;
end;

procedure SIRegister_Forms_TypesAndConsts(Cl: TPSPascalCompiler);
begin

   CL.AddTypeS('WPARAM', 'Longint');
  CL.AddTypeS('LPARAM', 'Longint');
   CL.AddTypeS('HWND', 'LongWord');
    CL.AddTypeS('UINT', 'LongWord');

    //CL.AddTypeS('TMsg', 'record hwnd: longword; wParam: longint; lParam: longint;'
    //+'time: DWORD; pt: TPoint; end');
  // CL.AddTypeS('TMsg', 'record hwnd: longword; message: longword; wParam: longint; lParam: longint; time: DWORD; pt: TPoint; end');

  CL.AddTypeS('tagMSG', 'record hwnd : HWND; message : UINT; wParam : WPARAM; lParam : LPARAM; time : DWORD; pt : TPoint; end');
  CL.AddTypeS('TMsg', 'tagMSG');

    //CL.AddTypeS('TObject', 'Exception');
   CL.AddClassN(CL.FindClass('TOBJECT'),'Exception');
   CL.AddClassN(CL.FindClass('TMenu'),'TMainMenu');
   //TCustomForm = class(TScrollingWinControl)

    CL.AddClassN(CL.FindClass('Class of THintWindow'),'THintWindowClass');   //3.8

    CL.AddTypeS('TActiveFormBorderStyle', '( afbNone, afbSingle, afbSunken, afbRaised )');
    CL.AddTypeS('TTimerMode', '( tmShow, tmHide )');
  CL.AddTypeS('TScrollBarStyle', '( ssRegular, ssFlat, ssHotTrack )');
   CL.AddTypeS('TShortCutEvent', 'Procedure ( var Msg : TWMKey; var Handled : Boolean)');
    CL.AddTypeS('TActiveFormBorderStyle', '( afbNone, afbSingle, afbSunken, afbRaised )');
     CL.AddTypeS('THintInfo', 'record HintControl : TControl; HintWindowClass : TH'
   +'intWindowClass; HintPos : TPoint; HintMaxWidth : Integer; HintColor : TCol'
   +'or; CursorRect : TRect; CursorPos : TPoint; ReshowTimeout : Integer; HideT'
   +'imeout : Integer; HintStr : string; HintData : integer; end');
    CL.AddTypeS('TGetHandleEvent', 'Procedure ( var Handle : HWND)');
   CL.AddTypeS('TShowHintEvent', 'Procedure ( var HintStr : string; var CanShow: Boolean; var HintInfo : THintInfo)');
   CL.AddTypeS('TWindowHook', 'Function ( var Message : TMessage) : Boolean');

   CL.AddClassN(CL.FindClass('TScrollingWinControl'),'TCustomForm');

   with CL.AddClassN(CL.FindClass('TObject'),'Exception') do

  //TMessageEvent = procedure(var Msg: TMsg; var Handled: Boolean) of object;
  //TExceptionEvent = procedure (Sender: TObject; E: Exception) of object;
  //                    exception
  Cl.AddTypeS('TMessageEvent', 'procedure(var Msg: TMsg; var Handled: Boolean)');
  Cl.AddTypeS('TExceptionEvent', 'procedure (Sender: TObject; E: Exception) of object');
  Cl.AddTypeS('TIdleEvent', 'procedure (Sender: TObject; var Done: Boolean) of object');
  cl.AddTypeS('TScrollBarKind', '(sbHorizontal, sbVertical)');
  cl.AddTypeS('TScrollBarInc', 'SmallInt');
  cl.AddTypeS('TFormBorderStyle', '(bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin)');
  cl.AddTypeS('TBorderStyle', 'TFormBorderStyle');
  cl.AddTypeS('TWindowState', '(wsNormal, wsMinimized, wsMaximized)');
  cl.AddTypeS('TFormStyle', '(fsNormal, fsMDIChild, fsMDIForm, fsStayOnTop)');
  cl.AddTypeS('TPosition', '(poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly, poScreenCenter, poDesktopCenter, poMainFormCenter, poOwnerFormCenter)');
  cl.AddTypeS('TPrintScale', '(poNone, poProportional, poPrintToFit)');
  cl.AddTypeS('TCloseAction', '(caNone, caHide, caFree, caMinimize)');
  cl.AddTypeS('TCloseEvent' ,'procedure(Sender: TObject; var Action: TCloseAction)');
  cl.AddTypeS('TCloseQueryEvent' ,'procedure(Sender: TObject; var CanClose: Boolean)');
  cl.AddTypeS('TBorderIcon' ,'(biSystemMenu, biMinimize, biMaximize, biHelp)');
  cl.AddTypeS('TBorderIcons', 'set of TBorderIcon');
  cl.AddTypeS('THELPCONTEXT', 'Longint');
  CL.AddTypeS('TMonitorDefaultTo', '( mdNearest, mdNull, mdPrimary )');
  cl.AddTypeS('TFormState', '(fsCreating, fsVisible, fsShowing, fsModal, fsCreatedMDIChild, fsActivated)');
  cl.AddTypeS('TShowAction', '(saIgnore, saRestore, saMinimize, saMaximize);');
  cl.AddTypeS('TDefaultMonitor', '(dmDesktop, dmPrimary, dmMainForm, dmActiveForm);');
  cl.AddTypeS('TTileMode', '(tbHorizontal, tbVertical);');
  cl.AddTypeS('TPopupMode', '(pmNone, pmAuto, pmExplicit);');
  cl.AddTypeS('TCanResizeEvent' ,'procedure(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean) of object;');
  cl.AddTypeS('TConstrainedResizeEvent' ,'procedure(Sender: TObject; var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer) of object;');

    //TFormState = set of (fsCreating, fsVisible, fsShowing, fsModal,
    //fsCreatedMDIChild, fsActivated);

              //tkeyevent
  {CL.AddTypeS('THintInfo', 'record HintControl : TControl; HintWindowClass : TH'
   +'intWindowClass; HintPos : TPoint; HintMaxWidth : Integer; HintColor : TCol'
   +'or; CursorRect : TRect; CursorPos : TPoint; ReshowTimeout : Integer; HideT'
   +'imeout : Integer; HintStr : string; HintData : integer; end');}
  //CL.AddTypeS('TCMHintShow', 'record Msg : Cardinal; Reserved : Integer; HintIn'
  // +'fo : HintInfo; Result : Integer; end');
  CL.AddTypeS('TCMHintShowPause', 'record Msg : Cardinal; WasActive : Integer; '
   +'Pause : Integer; Result : Integer; end');
  CL.AddTypeS('TPopupForm', 'record FormID: Integer; Form : TCustomForm; WasPopup: Boolean; end');
   CL.AddTypeS('HMONITOR' ,'Integer');
  //  SIRegister_TGlassFrame(CL);
    CL.AddTypeS('TPopupFormArray', 'array of TPopupForm');


end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TScreen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TScreen') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TScreen') do begin
    RegisterMethod('Procedure DisableAlign');
    RegisterMethod('Procedure EnableAlign');
    RegisterMethod('Function MonitorFromPoint( const Point : TPoint; MonitorDefault : TMonitorDefaultTo) : TMonitor');
    RegisterMethod('Function MonitorFromRect( const Rect : TRect; MonitorDefault : TMonitorDefaultTo) : TMonitor');
    RegisterMethod('Function MonitorFromWindow( const Handle : THandle; MonitorDefault : TMonitorDefaultTo) : TMonitor');
    RegisterMethod('Procedure Realign');
    RegisterMethod('Procedure ResetFonts');
    RegisterProperty('ActiveControl', 'TWinControl', iptr);
    RegisterProperty('ActiveCustomForm', 'TCustomForm', iptr);
    RegisterProperty('ActiveForm', 'TForm', iptr);
    RegisterProperty('CustomFormCount', 'Integer', iptr);
    RegisterProperty('CustomForms', 'TCustomForm Integer', iptr);
    RegisterProperty('CursorCount', 'Integer', iptr);
    RegisterProperty('Cursor', 'TCursor', iptrw);
    RegisterProperty('Cursors', 'HCURSOR Integer', iptrw);
    RegisterProperty('DataModules', 'TDataModule Integer', iptr);
    RegisterProperty('DataModuleCount', 'Integer', iptr);
    RegisterProperty('FocusedForm', 'TCustomForm', iptrw);
    RegisterProperty('SaveFocusedList', 'TList', iptr);
    RegisterProperty('MonitorCount', 'Integer', iptr);
    RegisterProperty('Monitors', 'TMonitor Integer', iptr);
    RegisterProperty('DesktopRect', 'TRect', iptr);
    RegisterProperty('DesktopHeight', 'Integer', iptr);
    RegisterProperty('DesktopLeft', 'Integer', iptr);
    RegisterProperty('DesktopTop', 'Integer', iptr);
    RegisterProperty('DesktopWidth', 'Integer', iptr);
    RegisterProperty('WorkAreaRect', 'TRect', iptr);
    RegisterProperty('WorkAreaHeight', 'Integer', iptr);
    RegisterProperty('WorkAreaLeft', 'Integer', iptr);
    RegisterProperty('WorkAreaTop', 'Integer', iptr);
    RegisterProperty('WorkAreaWidth', 'Integer', iptr);
    RegisterProperty('HintFont', 'TFont', iptrw);
    RegisterProperty('IconFont', 'TFont', iptrw);
    RegisterProperty('MenuFont', 'TFont', iptrw);
    RegisterProperty('Fonts', 'TStrings', iptr);
    RegisterProperty('FormCount', 'Integer', iptr);
    RegisterProperty('Forms', 'TForm Integer', iptr);
    RegisterProperty('Imes', 'TStrings', iptr);
    RegisterProperty('DefaultIme', 'string', iptr);
    RegisterProperty('DefaultKbLayout', 'HKL', iptr);
    RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('PixelsPerInch', 'Integer', iptr);
    RegisterProperty('PrimaryMonitor', 'TMonitor', iptr);
    RegisterProperty('Width', 'Integer', iptr);
    RegisterProperty('OnActiveControlChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnActiveFormChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatusBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomStatusBar', 'TStatusBar') do
  with CL.AddClassN(CL.FindClass('TCustomStatusBar'),'TStatusBar') do
  begin
    RegisterProperty('OnDrawPanel', 'TDrawPanelEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomStatusBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomStatusBar') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomStatusBar') do begin
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('AutoHint', 'Boolean', iptrw);
    RegisterProperty('Panels', 'TStatusPanels', iptrw);
    RegisterProperty('SimplePanel', 'Boolean', iptrw);
    RegisterProperty('SimpleText', 'string', iptrw);
    RegisterProperty('SizeGrip', 'Boolean', iptrw);
    RegisterProperty('UseSystemFont', 'Boolean', iptrw);
    RegisterProperty('OnCreatePanelClass', 'TSBCreatePanelClassEvent', iptrw);
    RegisterProperty('OnHint', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDrawPanel', 'TCustomDrawPanelEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatusPanels(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TStatusPanels') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TStatusPanels') do begin
    RegisterMethod('Constructor Create( StatusBar : TCustomStatusBar)');
    RegisterMethod('Function Add : TStatusPanel');
    RegisterMethod('Function AddItem( Item : TStatusPanel; Index : Integer) : TStatusPanel');
    RegisterMethod('Function Insert( Index : Integer) : TStatusPanel');
    RegisterProperty('Items', 'TStatusPanel Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatusPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TStatusPanel') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TStatusPanel') do begin
    RegisterMethod('Procedure ParentBiDiModeChanged');
    RegisterMethod('Function UseRightToLeftAlignment : Boolean');
    RegisterMethod('Function UseRightToLeftReading : Boolean');
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('Bevel', 'TStatusPanelBevel', iptrw);
    RegisterProperty('BiDiMode', 'TBiDiMode', iptrw);
    RegisterProperty('ParentBiDiMode', 'Boolean', iptrw);
    RegisterProperty('Style', 'TStatusPanelStyle', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*procedure SIRegister_IOleForm(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IOleForm') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),forms.IOleForm, 'IOleForm') do
  begin
    RegisterMethod('Procedure OnDestroy', cdRegister);
    RegisterMethod('Procedure OnResize', cdRegister);
  end;
end;
*)

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TScrollingWinControl', 'TCustomFrame') do
  with CL.AddClassN(CL.FindClass('TScrollingWinControl'),'TCustomFrame') do begin
    //RegisterMethod('Constructor Create( ACreateSuspended : Boolean)');
    RegisterMethod('constructor Create(AOwner: TComponent);');
  end;
end;

 (*----------------------------------------------------------------------------*)
procedure SIRegister_TFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFrame', 'TFrame') do
  with CL.AddClassN(CL.FindClass('TCustomFrame'),'TFrame') do begin
  RegisterPublishedProperties;
   RegisterProperty('Active', 'Boolean', iptr);
    RegisterProperty('ActiveControl', 'TWinControl', iptrw);
    RegisterProperty('ActiveOleControl', 'TWinControl', iptrw);
    RegisterProperty('BorderStyle', 'TFormBorderStyle', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('Designer', 'IDesignerHook', iptrw);
    RegisterProperty('DropTarget', 'Boolean', iptrw);
    RegisterProperty('FormState', 'TFormState', iptr);
    RegisterProperty('HelpFile', 'string', iptrw);
    RegisterProperty('ModalResult', 'TModalResult', iptrw);
    RegisterProperty('Monitor', 'TMonitor', iptr);
    RegisterProperty('OleFormObject', 'IOleForm', iptrw);
    RegisterProperty('PopupMode', 'TPopupMode', iptrw);
    RegisterProperty('PopupParent', 'TCustomForm', iptrw);
    RegisterProperty('ScreenSnap', 'Boolean', iptrw);
    RegisterProperty('SnapBuffer', 'Integer', iptrw);
    RegisterProperty('WindowState', 'TWindowState', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
  end;
end;


procedure SIRegister_Forms(Cl: TPSPascalCompiler);
begin
  SIRegister_Forms_TypesAndConsts(cl);
   CL.AddTypeS('HCURSOR','LongWord');
   CL.AddTypeS('HICON','LongWord');
  CL.AddClassN(CL.FindClass('TGraphic'),'TICON');
  CL.AddTypeS('TSettingChangeEvent','procedure (Sender: TObject; Flag: Integer; const Section: string; var Result: Longint) of object)');

  SIRegister_TMonitor(CL);

  {$IFNDEF PS_MINIVCL}
  SIRegisterTCONTROLSCROLLBAR(cl);
  {$ENDIF}
  SIRegisterTScrollingWinControl(cl);
  {$IFNDEF PS_MINIVCL}
  SIRegisterTSCROLLBOX(cl);
  {$ENDIF}
  SIRegisterTForm(Cl);
  {$IFNDEF PS_MINIVCL}
  SIRegisterTApplication(Cl);
  {$ENDIF}
  SIRegister_TScreen(CL);
   CL.AddTypeS('TStatusPanelStyle', '( psText, psOwnerDraw )');
  CL.AddTypeS('TStatusPanelBevel', '( pbNone, pbLowered, pbRaised )');

  //CL.AddTypeS('TStatusPanelClass', 'class of TStatusPanel');
  SIRegister_TStatusPanel(CL);
  SIRegister_TStatusPanels(CL);
  //CL.AddTypeS('TCustomDrawPanelEvent', 'Procedure ( StatusBar : TCustomStatusBa'
  // +'r; Panel : TStatusPanel; const Rect : TRect)');
  //CL.AddTypeS('TSBCreatePanelClassEvent', 'Procedure ( Sender : TCustomStatusBa'
  // +'r; var PanelClass : TStatusPanelClass)');
  SIRegister_TCustomStatusBar(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStatusBar');
  CL.AddTypeS('TDrawPanelEvent', 'Procedure ( StatusBar : TStatusBar; Panel : T'
   +'StatusPanel; const Rect : TRect)');
  SIRegister_TStatusBar(CL);

    SIRegister_TGlassFrame(CL);
   // SIRegister_IOleForm(CL);
   SIRegister_TCustomFrame(CL);
   SIRegister_TFrame(CL);


  // CL.AddTypeS('TFormClass','class of TForm');

end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.

