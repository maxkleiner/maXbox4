{ Compiletime Controls support }
unit uPSC_controls;
{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{
  Will register files from:
    Controls
    added with standard mouse events
 
  Register the STD, Classes (at least the types&consts) and Graphics libraries first
    add with TImage
    CreateParented and TWinControl Constructor
    seems NO constructor in TWinControl with canvas  , boundsrect!  'BORDERWIDTH', 'TBorderWidth', iptrw);
  parentbackground hack
  color bugfix2   boundsrect r/W    add action property    - imagelist create  - ReplaceDockedControl
}

procedure SIRegister_Controls_TypesAndConsts(Cl: TPSPascalCompiler);

procedure SIRegisterTControl(Cl: TPSPascalCompiler);
procedure SIRegisterTWinControl(Cl: TPSPascalCompiler);
procedure SIRegister_TWinControlActionLink(CL: TPSPascalCompiler);
procedure SIRegisterTGraphicControl(cl: TPSPascalCompiler);
procedure SIRegisterTCustomControl(cl: TPSPascalCompiler);
procedure SIRegisterTDragObject(cl: TPSPascalCompiler);


procedure SIRegister_TCustomTransparentControl(CL: TPSPascalCompiler);
//procedure SIRegister_TCustomControl(CL: TPSPascalCompiler);
procedure SIRegister_TCustomListControl(CL: TPSPascalCompiler);
procedure SIRegister_TCustomMultiSelectListControl(CL: TPSPascalCompiler);
procedure SIRegister_THintWindow(CL: TPSPascalCompiler);
procedure SIRegister_TCustomPanningWindow(CL: TPSPascalCompiler);
(*----------------------------------------------------------------------------*)


//procedure SIRegister_TWinControlActionLink(CL: TPSPascalCompiler);
//procedure SIRegister_TControl(CL: TPSPascalCompiler);
procedure SIRegister_TPadding(CL: TPSPascalCompiler);
procedure SIRegister_TMargins(CL: TPSPascalCompiler);
procedure SIRegister_TSizeConstraints(CL: TPSPascalCompiler);
procedure SIRegister_TControlActionLink(CL: TPSPascalCompiler);
procedure SIRegister_TControlAction(CL: TPSPascalCompiler);
procedure SIRegister_TCustomControlAction(CL: TPSPascalCompiler);
procedure SIRegister_TControlCanvas(CL: TPSPascalCompiler);

procedure SIRegister_Controls(Cl: TPSPascalCompiler);         //main call
procedure SIRegister_TImageList(CL: TPSPascalCompiler);
procedure SIRegister_TDragImageList(CL: TPSPascalCompiler);
procedure SIRegister_TMouse(CL: TPSPascalCompiler);




implementation

(*----------------------------------------------------------------------------*)
procedure SIRegister_TImageList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDragImageList', 'TImageList') do
  with CL.AddClassN(CL.FindClass('TDragImageList'),'TImageList') do begin
    RegisterPublishedProperties;
      RegisterProperty('BlendColor', 'TColor', iptrw);
    RegisterProperty('BkColor', 'TColor', iptrw);
    RegisterProperty('DrawingStyle', 'TDrawingStyle', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('ImageType', 'TImageType', iptrw);
    RegisterProperty('Masked', 'Boolean', iptrw);
    RegisterProperty('ShareImages', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  {
       property BlendColor;
    property BkColor;
    property AllocBy;
    property DrawingStyle;
    property Height;
    property ImageType;
    property Masked;
    property OnChange;
    property ShareImages;
    property Width;
   }

  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomListControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomListControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomListControl') do begin
    RegisterMethod('Procedure AddItem( Item : String; AObject : TObject)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearSelection');
    RegisterMethod('Procedure CopySelection( Destination : TCustomListControl)');
    RegisterMethod('Procedure DeleteSelected');
    RegisterMethod('Procedure MoveSelection( Destination : TCustomListControl)');
    RegisterMethod('Procedure SelectAll');
    RegisterProperty('ItemIndex', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomMultiSelectListControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomListControl', 'TCustomMultiSelectListControl') do
  with CL.AddClassN(CL.FindClass('TCustomListControl'),'TCustomMultiSelectListControl') do
  begin
    RegisterProperty('MultiSelect', 'Boolean', iptrw);
    RegisterProperty('SelCount', 'Integer', iptr);
  end;
end;


(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomControl') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
  end;
end;

procedure SIRegister_TCustomPanningWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomPanningWindow') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomPanningWindow') do begin
    RegisterMethod('Function GetIsPanning : Boolean');
    RegisterMethod('Function StartPanning( AHandle : THandle; AControl : TControl) : Boolean');
    RegisterMethod('Procedure StopPanning');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomTransparentControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomTransparentControl') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomTransparentControl') do begin
    RegisterProperty('InterceptMouse', 'Boolean', iptrw);
  end;
end;

procedure SIRegister_THintWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'THintWindow') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'THintWindow') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ActivateHint( Rect : TRect; const AHint : string)');
    RegisterMethod('Procedure ActivateHintData( Rect : TRect; const AHint : string; AData : Pointer)');
    RegisterMethod('Function CalcHintRect( MaxWidth : Integer; const AHint : string; AData : Pointer) : TRect');
    RegisterMethod('Function IsHintMsg( var Msg : TMsg) : Boolean');
    RegisterMethod('Function ShouldHideHint : Boolean');
    RegisterMethod('Procedure ReleaseHandle');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_TDragImageList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomImageList', 'TDragImageList') do
  with CL.AddClassN(CL.FindClass('TCustomImageList'),'TDragImageList') do begin
    RegisterMethod('Function BeginDrag( Window : HWND; X, Y : Integer) : Boolean');
    RegisterMethod('Function DragLock( Window : HWND; XPos, YPos : Integer) : Boolean');
    RegisterMethod('Function DragMove( X, Y : Integer) : Boolean');
    RegisterMethod('Procedure DragUnlock');
    RegisterMethod('Function EndDrag : Boolean');
    RegisterMethod('Procedure HideDragImage');
    RegisterMethod('Function SetDragImage( Index, HotSpotX, HotSpotY : Integer) : Boolean');
    RegisterMethod('Procedure ShowDragImage');
    RegisterMethod('function GetHotSpot: TPoint;');

    //function GetHotSpot: TPoint; override;
    RegisterProperty('DragCursor', 'TCursor', iptrw);
    RegisterProperty('DragHotspot', 'TPoint', iptrw);
    RegisterProperty('Dragging', 'Boolean', iptr);
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TWinControlActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TControlActionLink', 'TWinControlActionLink') do
  with CL.AddClassN(CL.FindClass('TControlActionLink'),'TWinControlActionLink') do
  begin
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TPadding(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMargins', 'TPadding') do
  with CL.AddClassN(CL.FindClass('TMargins'),'TPadding') do begin
        RegisterPublishedProperties;
     RegisterProperty('Left', 'Integer', iptRW);
    RegisterProperty('Top', 'Integer', iptRW);
    RegisterProperty('Right', 'Integer', iptRW);
    RegisterProperty('Bottom', 'Integer', iptRW);
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_TMargins(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TMargins') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TMargins') do begin
    RegisterMethod('Constructor Create( Control : TControl)');
    RegisterMethod('Procedure SetControlBounds( ALeft, ATop, AWidth, AHeight : Integer; Aligning : Boolean);');
    RegisterMethod('Procedure SetControlBounds1( const ARect : TRect; Aligning : Boolean);');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, ARight, ABottom : Integer)');
    RegisterProperty('ControlLeft', 'Integer', iptr);
    RegisterProperty('ControlTop', 'Integer', iptr);
    RegisterProperty('ControlWidth', 'Integer', iptr);
    RegisterProperty('ControlHeight', 'Integer', iptr);
    RegisterProperty('ExplicitLeft', 'Integer', iptr);
    RegisterProperty('ExplicitTop', 'Integer', iptr);
    RegisterProperty('ExplicitWidth', 'Integer', iptr);
    RegisterProperty('ExplicitHeight', 'Integer', iptr);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('Left', 'TMarginSize', iptrw);
    RegisterProperty('Top', 'TMarginSize', iptrw);
    RegisterProperty('Right', 'TMarginSize', iptrw);
    RegisterProperty('Bottom', 'TMarginSize', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSizeConstraints(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSizeConstraints') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSizeConstraints') do begin
    RegisterMethod('Constructor Create( Control : TControl)');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('MaxHeight', 'TConstraintSize', iptrw);
    RegisterProperty('MaxWidth', 'TConstraintSize', iptrw);
    RegisterProperty('MinHeight', 'TConstraintSize', iptrw);
    RegisterProperty('MinWidth', 'TConstraintSize', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TControlActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionLink', 'TControlActionLink') do
  with CL.AddClassN(CL.FindClass('TActionLink'),'TControlActionLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TControlAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControlAction', 'TControlAction') do
  with CL.AddClassN(CL.FindClass('TCustomControlAction'),'TControlAction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomControlAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAction', 'TCustomControlAction') do
  with CL.AddClassN(CL.FindClass('TCustomAction'),'TCustomControlAction') do
  begin
    RegisterProperty('DropdownMenu', 'TPopupMenu', iptrw);
    RegisterProperty('EnableDropdown', 'Boolean', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TControlCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCanvas', 'TControlCanvas') do
  with CL.AddClassN(CL.FindClass('TCanvas'),'TControlCanvas') do begin
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure FreeHandle');
    RegisterMethod('Procedure UpdateTextFlags');
    RegisterProperty('Control', 'TControl', iptrw);
  end;
end;




procedure SIRegisterTControl(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TComponent'), 'TCONTROL') do begin
    RegisterMethod('constructor Create(AOwner: TComponent);');
      RegisterMethod('Procedure Free');
      RegisterMethod('procedure BringToFront;');
    RegisterMethod('procedure Hide;');
    RegisterMethod('procedure Invalidate;');
    RegisterMethod('procedure Refresh;');
    RegisterMethod('procedure Repaint;');
    RegisterMethod('procedure SendToBack;');
    RegisterMethod('procedure Show;');
    RegisterMethod('procedure Update;');
    RegisterMethod('procedure SetBounds(x,y,w,h: Integer);virtual;');
    RegisterMethod('function ManualFloat(ScreenPos: TRect): Boolean;');
    RegisterMethod('procedure SetDesignVisible(Value: Boolean);');

    RegisterMethod('function IsRightToLeft: Boolean;');
    RegisterMethod('procedure MouseWheelHandler(var Message: TMessage);');
    RegisterMethod('function GetParentComponent: TComponent;');
   // RegisterMethod('function GetTextBuf(Buffer: PChar; BufSize: Integer): Integer;');
    //RegisterMethod('function GetTextLen: Integer;');
    RegisterMethod('function HasParent: Boolean;');
    RegisterMethod('procedure InitiateAction;');
    RegisterMethod('function GetControlsAlignment: TAlignment;');
    RegisterMethod('procedure DragDrop(Source: TObject; X, Y: Integer)');
 RegisterMethod('function DrawTextBiDiModeFlags(Flags: Longint): Longint;');
 RegisterMethod('function DrawTextBiDiModeFlagsReadingOnly: Longint;');
 RegisterMethod('function UseRightToLeftAlignment: Boolean;');
 RegisterMethod('function UseRightToLeftReading: Boolean;');
 RegisterMethod('function UseRightToLeftScrollBar: Boolean;');


     RegisterPublishedProperties;
    RegisterProperty('AlignWithMargins', 'Boolean', iptrw);
    RegisterProperty('Floating', 'Boolean', iptr);
    RegisterProperty('Left', 'Integer', iptRW);
    RegisterProperty('Top', 'Integer', iptRW);
    RegisterProperty('Width', 'Integer', iptRW);
    RegisterProperty('Height', 'Integer', iptRW);
    RegisterProperty('Hint', 'String', iptRW);
    RegisterProperty('Align', 'TAlign', iptRW);
    RegisterProperty('ClientHeight', 'Longint', iptRW);
    RegisterProperty('ClientWidth', 'Longint', iptRW);
    RegisterProperty('ClientOrigin', 'TPoint', iptr);
    RegisterProperty('ClientRect', 'TRect', iptr);
    RegisterProperty('Anchors', 'TAnchors', iptRW);
    RegisterProperty('BidiMode', 'TBiDiMode', iptrw);
    RegisterProperty('BoundsRect', 'TRect', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);      //hack2
    RegisterProperty('Caption', 'TCaption', iptrw);  //hack2
  //del  RegisterProperty('Color', 'TColor', iptrw);      //hack2
    RegisterProperty('HostDockSite', 'TWinControl', iptrw);  //hack2
    RegisterProperty('LRDockWidth', 'integer', iptrw);  //hack2
    RegisterProperty('Action', 'TBasicAction', iptrw);  //hack2

    //  property Action: TBasicAction read GetAction write SetAction;

     //RegisterProperty('ClientWidth', 'Integer', iptrw);
    RegisterProperty('Constraints', 'TSizeConstraints', iptrw);
    RegisterProperty('ExplicitLeft', 'Integer', iptr);
    RegisterProperty('ExplicitTop', 'Integer', iptr);
    RegisterProperty('ExplicitWidth', 'Integer', iptr);
    RegisterProperty('ExplicitHeight', 'Integer', iptr);
    RegisterProperty('HelpType', 'THelpType', iptrw);
    RegisterProperty('HelpKeyword', 'String', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('Margins', 'TMargins', iptrw);

    RegisterProperty('ShowHint', 'Boolean', iptRW);
    RegisterProperty('Visible', 'Boolean', iptRW);
    RegisterProperty('ENABLED', 'BOOLEAN', iptrw);
    RegisterProperty('CURSOR', 'TCURSOR', iptrw);
    RegisterProperty('Parent', 'TWinControl', iptRW);

    //RegisterPublishedProperties;
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
    RegisterProperty('ControlState', 'TControlState', iptrw);
    RegisterProperty('ControlStyle', 'TControlStyle', iptrw);
    RegisterProperty('WindowProc', 'TWndMethod', iptrw);

    //AlignWithMargins
    //WindowProc

    {$IFNDEF PS_MINIVCL}
    RegisterMethod('function Dragging: Boolean;');
    RegisterMethod('function HasParent: Boolean');
    RegisterMethod('procedure BEGINDRAG(IMMEDIATE:BOOLEAN)');
    RegisterMethod('function CLIENTTOSCREEN(POINT:TPOINT):TPOINT');
    RegisterMethod('procedure ENDDRAG(DROP:BOOLEAN)');
    {$IFNDEF CLX}
    RegisterMethod('function GETTEXTBUF(BUFFER:PCHAR;BUFSIZE:INTEGER):INTEGER');
    RegisterMethod('function GETTEXTLEN:INTEGER');
    RegisterMethod('procedure SETTEXTBUF(BUFFER:PCHAR)');
    RegisterMethod('function PERFORM(MSG:CARDINAL;WPARAM,LPARAM:LONGINT):LONGINT');
    {$ENDIF}
    RegisterMethod('function SCREENTOCLIENT(POINT:TPOINT):TPOINT');
    // with Cl.FindClass('TWINCONTROL') do begin
    with Cl.AddClassN(cl.FindClass('TControl'), 'TWINCONTROL') do
    RegisterMethod('function ParentTOCLIENT(POINT:TPOINT; AParent: TWinControl):TPOINT');
    // end;
    // function ParentToClient(const Point: TPoint; AParent: TWinControl = nil): TPoint;
    RegisterMethod('function ReplaceDockedControl(Control: TControl; NewDockSite: TWinControl; '+
                           ' DropControl: TControl; ControlSide: TAlign): Boolean)');


    {$ENDIF}
  end;
end;

procedure SIRegisterTWinControl(Cl: TPSPascalCompiler); // requires TControl
begin
  with Cl.AddClassN(cl.FindClass('TControl'), 'TWINCONTROL') do begin

    with Cl.FindClass('TControl') do begin
      RegisterProperty('Parent', 'TWinControl', iptRW);
    end;
    RegisterMethod('constructor Create(AOwner: TComponent);');  //  !! register constructor
    RegisterMethod('constructor CreateParented(ParentWindow: HWnd);');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure DefaultHandler(var Message);');
    RegisterMethod('Procedure DisableAlign');
    RegisterMethod('procedure SetDesignVisible(Value: Boolean);');
    RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)');
    RegisterMethod('Procedure Repaint');
    RegisterMethod('Function ControlAtPos( const Pos : TPoint; AllowDisabled : Boolean; AllowWinControls : Boolean; AllLevels : Boolean) : TControl');
    RegisterMethod('Function FindChildControl( const ControlName : string) : TControl');
    RegisterMethod('Procedure FlipChildren( AllLevels : Boolean)');
        //constructor CreateParented(ParentWindow: HWnd);
     {$IFNDEF CLX}
    RegisterProperty('Handle', 'Longint', iptR);
    {$ENDIF}
    RegisterProperty('Showing', 'Boolean', iptR);
    RegisterProperty('TabOrder', 'Integer', iptRW);
    RegisterProperty('TabStop', 'Boolean', iptRW);
    RegisterMethod('function CANFOCUS:BOOLEAN');
    RegisterMethod('function FOCUSED:BOOLEAN');
    RegisterProperty('CONTROLS', 'TCONTROL INTEGER', iptr);
    RegisterProperty('CONTROLCOUNT', 'INTEGER', iptr);
    RegisterProperty('DoubleBuffered', 'Boolean', iptrw);
    RegisterProperty('DockClientCount', 'Integer', iptr);
    RegisterProperty('DockClients', 'TControl Integer', iptr);
    RegisterProperty('DockSite', 'Boolean', iptrw);
    RegisterPublishedProperties;    //3.9.8
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
    RegisterProperty('VisibleDockClientCount', 'Integer', iptr);
    //RegisterProperty('Brush', 'TBrush', iptr);
    //RegisterProperty('Controls', 'TControl Integer', iptr);
    //RegisterProperty('ControlCount', 'Integer', iptr);
    //RegisterProperty('Handle', 'HWnd', iptr);
    RegisterProperty('Padding', 'TPadding', iptrw);
     RegisterProperty('ParentWindow', 'Longint', iptrw);
       RegisterProperty('AlignDisabled', 'Boolean', iptr);
    RegisterProperty('MouseInClient', 'Boolean', iptr);
    RegisterProperty('VisibleDockClientCount', 'Integer', iptr);
    RegisterProperty('UseDockManager', 'Boolean', iptr);
    RegisterProperty('ParentBackground', 'Boolean', iptrw);

   //   property ParentBackground: Boolean read GetParentBackground write SetParentBackground;


       {$IFNDEF PS_MINIVCL}
    RegisterMethod('function HandleAllocated: Boolean;');
    RegisterMethod('procedure HandleNeeded;');
    RegisterMethod('procedure EnableAlign;');
    RegisterMethod('procedure RemoveControl(AControl: TControl);');
    RegisterMethod('procedure InsertControl(AControl: TControl);');
    RegisterMethod('procedure Realign;');
    RegisterMethod('procedure ScaleBy(M, D: Integer);');
    RegisterMethod('procedure ScrollBy(DeltaX, DeltaY: Integer);');
    RegisterMethod('procedure SetFocus; virtual;');
    {$IFNDEF CLX}
    RegisterMethod('procedure PAINTTO(DC:Longint;X,Y:INTEGER)');
    RegisterMethod('procedure PAINTTOC(Canvas: TCanvas;X,Y:INTEGER)');
    RegisterMethod('procedure PAINTTO1(Canvas: TCanvas;X,Y:INTEGER)');

    //RegisterMethod('Procedure PaintTo( DC : HDC; X, Y : Integer);');
    //RegisterMethod('Procedure PaintTo1( Canvas : TCanvas; X, Y : Integer);');

    RegisterMethod('PreProcessMessage(var Msg: TMsg): Boolean;');
    //    function PreProcessMessage(var Msg: TMsg): Boolean; dynamic;
   // procedure RemoveControl(AControl: TControl);
      // procedure PaintTo(DC: HDC; X, Y: Integer); overload;
    // procedure PaintTo(Canvas: TCanvas; X, Y: Integer); overload;

    {$ENDIF}

    RegisterMethod('function CONTAINSCONTROL(CONTROL:TCONTROL):BOOLEAN');
    RegisterMethod('procedure DISABLEALIGN');
    RegisterMethod('procedure UPDATECONTROLSTATE');
    //RegisterMethod('procedure PaintWindow(DC: HDC)');
           // procedure PaintWindow(DC: HDC); virtual;
         //RegisterMethod('procedure UPDATECONTROLSTATE');

    RegisterProperty('BRUSH', 'TBRUSH', iptr);
    RegisterProperty('HELPCONTEXT', 'LONGINT', iptrw);
    //RegisterProperty('BORDERWIDTH', 'TBorderWidth', iptrw);    in Forms

    {$ENDIF}
  end;
end;
procedure SIRegisterTGraphicControl(cl: TPSPascalCompiler); // requires TControl
begin
 with Cl.AddClassN(cl.FindClass('TControl'), 'TGRAPHICCONTROL') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
  end;
   //  RegisterMethod('procedure ScaleBy(M, D: Integer);');
end;

procedure SIRegisterTCustomControl(cl: TPSPascalCompiler); // requires TWinControl
begin
  with Cl.AddClassN(cl.FindClass('TWinControl'), 'TCUSTOMCONTROL') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
   //RegisterProperty('Color', 'TColor', iptr);

  end;
end;

const CM_BASE= $B000;

procedure SIRegister_Controls_TypesAndConsts(Cl: TPSPascalCompiler);
begin
{$IFNDEF FPC}
  Cl.addTypeS('TEShiftState','(ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble)');
  {$ELSE}
  Cl.addTypeS('TEShiftState','(ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble,' +
  'ssMeta, ssSuper, ssHyper, ssAltGr, ssCaps, ssNum,ssScroll,ssTriple,ssQuad)');
  {$ENDIF}
  Cl.addTypeS('TShiftState','set of TEShiftState');
  cl.AddTypeS('TMouseButton', '(mbLeft, mbRight, mbMiddle)');
  cl.AddTypeS('TDragMode', '(dmManual, dmAutomatic)');
  cl.AddTypeS('TDragState', '(dsDragEnter, dsDragLeave, dsDragMove)');
  cl.AddTypeS('TDragKind', '(dkDrag, dkDock)');
  cl.AddTypeS('TMouseEvent', 'procedure (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);');
  cl.AddTypeS('TMouseMoveEvent', 'procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer);');
  cl.AddTypeS('TKeyEvent', 'procedure (Sender: TObject; var Key: Word; Shift: TShiftState);');
  cl.AddTypeS('TKeyPressEvent', 'procedure(Sender: TObject; var Key: Char);');
  cl.AddTypeS('TDragOverEvent', 'procedure(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean)');
  cl.AddTypeS('TDragDropEvent', 'procedure(Sender, Source: TObject;X, Y: Integer)');
  cl.AddTypeS('HWND', 'Longword');  //pretype
  //CL.AddTypeS('TKeyPressEvent', 'Procedure ( Sender : TObject; var Key : Char)');

  cl.AddTypeS('TEndDragEvent', 'procedure(Sender, Target: TObject; X, Y: Integer)');
  //cl.addTypeS('TAlign', '(alNone, alTop, alBottom, alLeft, alRight, alClient)');
  CL.AddTypeS('TAlign', '( alNone, alTop, alBottom, alLeft, alRight, alClient,alCustom )');
  CL.AddTypeS('TAlignSet', 'set of TAlign');
  cl.addTypeS('TAnchorKind', '(akTop, akLeft, akRight, akBottom)');
  cl.addTypeS('TAnchors','set of TAnchorKind');
  CL.AddTypeS('TMessage','record msg: Cardinal; WParam, LParam, Result: Longint; end');
  CL.AddTypeS('TWndMethod', 'procedure(var Message: TMessage) of object');


//    TAnchorKind = (akLeft, akTop, akRight, akBottom);
 // TAnchors = set of TAnchorKind;

  cl.AddTypeS('TModalResult', 'Integer');
  cl.AddTypeS('TCursor', 'Integer');
  //cl.AddTypeS('TPoint', 'record x,y: Longint; end;');
  CL.AddTypeS('TConstraintSize', 'Integer');
  //SIRegister_TSizeConstraints(CL);
  CL.AddTypeS('TMarginSize', 'Integer');
    CL.AddTypeS('TScalingFlag', '( sfLeft, sfTop, sfWidth, sfHeight, sfFont, sfDesignSize )');
    CL.AddTypeS('TScalingFlags', 'set of TScalingFlag');
    CL.AddTypeS('TConstrainedResizeEvent', 'Procedure ( Sender : TObject; var Min'
   +'Width, MinHeight, MaxWidth, MaxHeight : Integer)');
  CL.AddTypeS('TMouseWheelEvent', 'Procedure ( Sender : TObject; Shift : TShift'
   +'State; WheelDelta : Integer; MousePos : TPoint; var Handled : Boolean)');
  CL.AddTypeS('TMouseWheelUpDownEvent', 'Procedure ( Sender : TObject; Shift : '
   +'TShiftState; MousePos : TPoint; var Handled : Boolean)');
  CL.AddTypeS('TContextPopupEvent', 'Procedure ( Sender : TObject; MousePos : T'
   +'Point; var Handled : Boolean)');
  CL.AddTypeS('TDockOrientation', '( doNoOrient, doHorizontal, doVertical )');
 CL.AddTypeS('TControlStates',{set of} '( csLButtonDown, csClicked, csPalette, c'
   +'sReadingState, csAlignmentNeeded, csFocusing, csCreating, csPaintCopy, csC'
   +'ustomPaint, csDestroyingHandle, csDocking, csDesignerHide, csPanning, csRe'
   +'creating, csAligning )');
  CL.AddTypeS('TControlState', 'set of TControlStates');

  CL.AddTypeS('TControlStyles', '( csAcceptsControls, csCaptureMouse, csD'
   +'esignInteractive, csClickEvents, csFramed, csSetCaption, csOpaque, csDoubl'
   +'eClicks, csFixedWidth, csFixedHeight, csNoDesignVisible, csReplicatable, c'
   +'sNoStdEvents, csDisplayDragImage, csReflector, csActionClient, csMenuEvent'
   +'s, csNeedsBorderPaint, csParentBackground, csPannable, csAlignWithMargins)');
  CL.AddTypeS('TControlStyle', 'set of TControlStyles');

   CL.AddTypeS('TMouseActivate', '( maDefault, maActivate, maActivateAndEat, maN'
   +'oActivate, maNoActivateAndEat )');
  CL.AddTypeS('TMouseActivateEvent', 'Procedure ( Sender : TObject; Button : TM'
   +'ouseButton; Shift : TShiftState; X, Y : Integer; HitTest : Integer; var Mo'
   +'useActivate : TMouseActivate)');

  // TAlignment = (taLeftJustify, taRightJustify, taCenter);

   
  CL.AddConstantN('CM_BASE','LongWord').SetUInt( $B000);
 CL.AddConstantN('CM_ACTIVATE','LongInt').SetInt( CM_BASE + 0);
 CL.AddConstantN('CM_DEACTIVATE','LongInt').SetInt( CM_BASE + 1);
 CL.AddConstantN('CM_GOTFOCUS','LongInt').SetInt( CM_BASE + 2);
 CL.AddConstantN('CM_LOSTFOCUS','LongInt').SetInt( CM_BASE + 3);
 CL.AddConstantN('CM_CANCELMODE','LongInt').SetInt( CM_BASE + 4);
 CL.AddConstantN('CM_DIALOGKEY','LongInt').SetInt( CM_BASE + 5);
 CL.AddConstantN('CM_DIALOGCHAR','LongInt').SetInt( CM_BASE + 6);
 CL.AddConstantN('CM_FOCUSCHANGED','LongInt').SetInt( CM_BASE + 7);
 CL.AddConstantN('CM_PARENTFONTCHANGED','LongInt').SetInt( CM_BASE + 8);
 CL.AddConstantN('CM_PARENTCOLORCHANGED','LongInt').SetInt( CM_BASE + 9);
 CL.AddConstantN('CM_HITTEST','LongInt').SetInt( CM_BASE + 10);
 CL.AddConstantN('CM_VISIBLECHANGED','LongInt').SetInt( CM_BASE + 11);
 CL.AddConstantN('CM_ENABLEDCHANGED','LongInt').SetInt( CM_BASE + 12);
 CL.AddConstantN('CM_COLORCHANGED','LongInt').SetInt( CM_BASE + 13);
 CL.AddConstantN('CM_FONTCHANGED','LongInt').SetInt( CM_BASE + 14);
 CL.AddConstantN('CM_CURSORCHANGED','LongInt').SetInt( CM_BASE + 15);
 CL.AddConstantN('CM_CTL3DCHANGED','LongInt').SetInt( CM_BASE + 16);
 CL.AddConstantN('CM_PARENTCTL3DCHANGED','LongInt').SetInt( CM_BASE + 17);
 CL.AddConstantN('CM_TEXTCHANGED','LongInt').SetInt( CM_BASE + 18);
 CL.AddConstantN('CM_MOUSEENTER','LongInt').SetInt( CM_BASE + 19);
 CL.AddConstantN('CM_MOUSELEAVE','LongInt').SetInt( CM_BASE + 20);
 CL.AddConstantN('CM_MENUCHANGED','LongInt').SetInt( CM_BASE + 21);
 CL.AddConstantN('CM_APPKEYDOWN','LongInt').SetInt( CM_BASE + 22);
 CL.AddConstantN('CM_APPSYSCOMMAND','LongInt').SetInt( CM_BASE + 23);
 CL.AddConstantN('CM_BUTTONPRESSED','LongInt').SetInt( CM_BASE + 24);
 CL.AddConstantN('CM_SHOWINGCHANGED','LongInt').SetInt( CM_BASE + 25);
 CL.AddConstantN('CM_ENTER','LongInt').SetInt( CM_BASE + 26);
 CL.AddConstantN('CM_EXIT','LongInt').SetInt( CM_BASE + 27);
 CL.AddConstantN('CM_DESIGNHITTEST','LongInt').SetInt( CM_BASE + 28);
 CL.AddConstantN('CM_ICONCHANGED','LongInt').SetInt( CM_BASE + 29);
 CL.AddConstantN('CM_WANTSPECIALKEY','LongInt').SetInt( CM_BASE + 30);
 CL.AddConstantN('CM_INVOKEHELP','LongInt').SetInt( CM_BASE + 31);
 CL.AddConstantN('CM_WINDOWHOOK','LongInt').SetInt( CM_BASE + 32);
 CL.AddConstantN('CM_RELEASE','LongInt').SetInt( CM_BASE + 33);
 CL.AddConstantN('CM_SHOWHINTCHANGED','LongInt').SetInt( CM_BASE + 34);
 CL.AddConstantN('CM_PARENTSHOWHINTCHANGED','LongInt').SetInt( CM_BASE + 35);
 CL.AddConstantN('CM_SYSCOLORCHANGE','LongInt').SetInt( CM_BASE + 36);
 CL.AddConstantN('CM_WININICHANGE','LongInt').SetInt( CM_BASE + 37);
 CL.AddConstantN('CM_FONTCHANGE','LongInt').SetInt( CM_BASE + 38);
 CL.AddConstantN('CM_TIMECHANGE','LongInt').SetInt( CM_BASE + 39);
 CL.AddConstantN('CM_TABSTOPCHANGED','LongInt').SetInt( CM_BASE + 40);
 CL.AddConstantN('CM_UIACTIVATE','LongInt').SetInt( CM_BASE + 41);
 CL.AddConstantN('CM_UIDEACTIVATE','LongInt').SetInt( CM_BASE + 42);
 CL.AddConstantN('CM_DOCWINDOWACTIVATE','LongInt').SetInt( CM_BASE + 43);
 CL.AddConstantN('CM_CONTROLLISTCHANGE','LongInt').SetInt( CM_BASE + 44);
 CL.AddConstantN('CM_GETDATALINK','LongInt').SetInt( CM_BASE + 45);
 CL.AddConstantN('CM_CHILDKEY','LongInt').SetInt( CM_BASE + 46);
 CL.AddConstantN('CM_DRAG','LongInt').SetInt( CM_BASE + 47);
 CL.AddConstantN('CM_HINTSHOW','LongInt').SetInt( CM_BASE + 48);
 CL.AddConstantN('CM_DIALOGHANDLE','LongInt').SetInt( CM_BASE + 49);
 CL.AddConstantN('CM_ISTOOLCONTROL','LongInt').SetInt( CM_BASE + 50);
 CL.AddConstantN('CM_RECREATEWND','LongInt').SetInt( CM_BASE + 51);
 CL.AddConstantN('CM_INVALIDATE','LongInt').SetInt( CM_BASE + 52);
 CL.AddConstantN('CM_SYSFONTCHANGED','LongInt').SetInt( CM_BASE + 53);
 CL.AddConstantN('CM_CONTROLCHANGE','LongInt').SetInt( CM_BASE + 54);
 CL.AddConstantN('CM_CHANGED','LongInt').SetInt( CM_BASE + 55);
 CL.AddConstantN('CM_DOCKCLIENT','LongInt').SetInt( CM_BASE + 56);
 CL.AddConstantN('CM_UNDOCKCLIENT','LongInt').SetInt( CM_BASE + 57);
 CL.AddConstantN('CM_FLOAT','LongInt').SetInt( CM_BASE + 58);
 CL.AddConstantN('CM_BORDERCHANGED','LongInt').SetInt( CM_BASE + 59);
 CL.AddConstantN('CM_BIDIMODECHANGED','LongInt').SetInt( CM_BASE + 60);
 CL.AddConstantN('CM_PARENTBIDIMODECHANGED','LongInt').SetInt( CM_BASE + 61);
 CL.AddConstantN('CM_ALLCHILDRENFLIPPED','LongInt').SetInt( CM_BASE + 62);
 CL.AddConstantN('CM_ACTIONUPDATE','LongInt').SetInt( CM_BASE + 63);
 CL.AddConstantN('CM_ACTIONEXECUTE','LongInt').SetInt( CM_BASE + 64);
 CL.AddConstantN('CM_HINTSHOWPAUSE','LongInt').SetInt( CM_BASE + 65);
 CL.AddConstantN('CM_DOCKNOTIFICATION','LongInt').SetInt( CM_BASE + 66);
 CL.AddConstantN('CM_MOUSEWHEEL','LongInt').SetInt( CM_BASE + 67);
 CL.AddConstantN('CM_ISSHORTCUT','LongInt').SetInt( CM_BASE + 68);
 CL.AddConstantN('CM_RAWX11EVENT','LongInt').SetInt( CM_BASE + 69);
 CL.AddConstantN('CM_INVALIDATEDOCKHOST','LongInt').SetInt( CM_BASE + 70);
 CL.AddConstantN('CM_SETACTIVECONTROL','LongInt').SetInt( CM_BASE + 71);
 CL.AddConstantN('CM_POPUPHWNDDESTROY','LongInt').SetInt( CM_BASE + 72);
 CL.AddConstantN('CM_CREATEPOPUP','LongInt').SetInt( CM_BASE + 73);
 CL.AddConstantN('CM_DESTROYHANDLE','LongInt').SetInt( CM_BASE + 74);
 CL.AddConstantN('CM_MOUSEACTIVATE','LongInt').SetInt( CM_BASE + 75);
 CL.AddConstantN('CM_CONTROLLISTCHANGING','LongInt').SetInt( CM_BASE + 76);
 CL.AddConstantN('CM_BUFFEREDPRINTCLIENT','LongInt').SetInt( CM_BASE + 77);
 CL.AddConstantN('CM_UNTHEMECONTROL','LongInt').SetInt( CM_BASE + 78);
 CL.AddConstantN('CN_BASE','LongWord').SetUInt( $BC00);
 CL.AddTypeS('TWMNoParams', 'record Msg : Cardinal; unused: array[0..3] of word; '
   +'result: Longint; end');
 CL.AddTypeS('TWMKey', 'record Msg : Cardinal; charcode, unused: word; '
   +'keydata, result: Longint; end');

  CL.AddTypeS('TCMActivate', 'TWMNoParams');
  CL.AddTypeS('TCMDeactivate', 'TWMNoParams');
  CL.AddTypeS('TCMGotFocus', 'TWMNoParams');
  CL.AddTypeS('TCMLostFocus', 'TWMNoParams');
  CL.AddTypeS('TCMDialogKey', 'TWMKey');
  CL.AddTypeS('TCMDialogChar', 'TWMKey');
  //CL.AddTypeS('TCMHitTest', 'TWMNCHitTest');
  CL.AddTypeS('TCMEnter', 'TWMNoParams');
  CL.AddTypeS('TCMExit', 'TWMNoParams');
  //CL.AddTypeS('TCMDesignHitTest', 'TWMMouse');
  CL.AddTypeS('TCMWantSpecialKey', 'TWMKey');
  CL.AddTypeS('TImeMode', '( imDisable, imClose, imOpen, imDontCare, imSAlpha, '
   +'imAlpha, imHira, imSKata, imKata, imChinese, imSHanguel, imHanguel )');
  CL.AddTypeS('TImeName', 'string');
  CL.AddTypeS('HIMC', 'Integer');
  CL.AddTypeS('TAlignInfo', 'record AlignList : TList; ControlIndex : Integer; '
   +'Align : TAlign; Scratch : Integer; end');


  cl.AddConstantN('mrNone', 'Integer').Value.ts32 := 0;
  cl.AddConstantN('mrOk', 'Integer').Value.ts32 := 1;
  cl.AddConstantN('mrCancel', 'Integer').Value.ts32 := 2;
  cl.AddConstantN('mrAbort', 'Integer').Value.ts32 := 3;
  cl.AddConstantN('mrRetry', 'Integer').Value.ts32 := 4;
  cl.AddConstantN('mrIgnore', 'Integer').Value.ts32 := 5;
  cl.AddConstantN('mrYes', 'Integer').Value.ts32 := 6;
  cl.AddConstantN('mrNo', 'Integer').Value.ts32 := 7;
  cl.AddConstantN('mrAll', 'Integer').Value.ts32 := 8;
  cl.AddConstantN('mrNoToAll', 'Integer').Value.ts32 := 9;
  cl.AddConstantN('mrYesToAll', 'Integer').Value.ts32 := 10;
  cl.AddConstantN('crDefault', 'Integer').Value.ts32 := 0;
  cl.AddConstantN('crNone', 'Integer').Value.ts32 := -1;
  cl.AddConstantN('crArrow', 'Integer').Value.ts32 := -2;
  cl.AddConstantN('crCross', 'Integer').Value.ts32 := -3;
  cl.AddConstantN('crIBeam', 'Integer').Value.ts32 := -4;
  cl.AddConstantN('crSizeNESW', 'Integer').Value.ts32 := -6;
  cl.AddConstantN('crSizeNS', 'Integer').Value.ts32 := -7;
  cl.AddConstantN('crSizeNWSE', 'Integer').Value.ts32 := -8;
  cl.AddConstantN('crSizeWE', 'Integer').Value.ts32 := -9;
  cl.AddConstantN('crUpArrow', 'Integer').Value.ts32 := -10;
  cl.AddConstantN('crHourGlass', 'Integer').Value.ts32 := -11;
  cl.AddConstantN('crDrag', 'Integer').Value.ts32 := -12;
  cl.AddConstantN('crNoDrop', 'Integer').Value.ts32 := -13;
  cl.AddConstantN('crHSplit', 'Integer').Value.ts32 := -14;
  cl.AddConstantN('crVSplit', 'Integer').Value.ts32 := -15;
  cl.AddConstantN('crMultiDrag', 'Integer').Value.ts32 := -16;
  cl.AddConstantN('crSQLWait', 'Integer').Value.ts32 := -17;
  cl.AddConstantN('crNo', 'Integer').Value.ts32 := -18;
  cl.AddConstantN('crAppStart', 'Integer').Value.ts32 := -19;
  cl.AddConstantN('crHelp', 'Integer').Value.ts32 := -20;
{$IFDEF DELPHI3UP}
  cl.AddConstantN('crHandPoint', 'Integer').Value.ts32 := -21;
{$ENDIF}
{$IFDEF DELPHI4UP}
  cl.AddConstantN('crSizeAll', 'Integer').Value.ts32 := -22;
{$ENDIF}
  CL.AddDelphiFunction('Function IsAnAllResult( const AModalResult : TModalResult) : Boolean');
  CL.AddDelphiFunction('Function InitWndProc( HWindow : HWnd; Message, WParam : Longint; LParam : Longint) : Longint');
 CL.AddConstantN('CTL3D_ALL','LongWord').SetUInt( $FFFF);
 CL.AddDelphiFunction('Procedure ChangeBiDiModeAlignment( var Alignment : TAlignment)');
 //CL.AddDelphiFunction('Function SendAppMessage( Msg : Cardinal; WParam, LParam : Longint) : Longint');
 //CL.AddDelphiFunction('Procedure MoveWindowOrg( DC : HDC; DX, DY : Integer)');
 CL.AddDelphiFunction('Procedure SetImeMode( hWnd : HWND; Mode : TImeMode)');
 CL.AddDelphiFunction('Procedure SetImeName( Name : TImeName)');
 CL.AddDelphiFunction('Function Win32NLSEnableIME( hWnd : HWND; Enable : Boolean) : Boolean');
 CL.AddDelphiFunction('Function Imm32GetContext( hWnd : HWND) : HIMC');
 CL.AddDelphiFunction('Function Imm32ReleaseContext( hWnd : HWND; hImc : HIMC) : Boolean');
 CL.AddDelphiFunction('Function Imm32GetConversionStatus( hImc : HIMC; var Conversion, Sentence : longword) : Boolean');
 CL.AddDelphiFunction('Function Imm32SetConversionStatus( hImc : HIMC; Conversion, Sentence : longword) : Boolean');
 CL.AddDelphiFunction('Function Imm32SetOpenStatus( hImc : HIMC; fOpen : Boolean) : Boolean');
// CL.AddDelphiFunction('Function Imm32SetCompositionWindow( hImc : HIMC; lpCompForm : PCOMPOSITIONFORM) : Boolean');
 //CL.AddDelphiFunction('Function Imm32SetCompositionFont( hImc : HIMC; lpLogfont : PLOGFONTA) : Boolean');
 CL.AddDelphiFunction('Function Imm32GetCompositionString( hImc : HIMC; dWord1 : longword; lpBuf : string; dwBufLen : longint) : Longint');
 CL.AddDelphiFunction('Function Imm32IsIME( hKl : longword) : Boolean');
 CL.AddDelphiFunction('Function Imm32NotifyIME( hImc : HIMC; dwAction, dwIndex, dwValue : longword) : Boolean');
 CL.AddDelphiFunction('Procedure DragDone( Drop : Boolean)');

end;

procedure SIRegisterTDragObject(cl: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject'),'TDragObject') do
  begin
{$IFNDEF PS_MINIVCL}
{$IFDEF DELPHI4UP}
    RegisterMethod('Procedure Assign( Source : TDragObject)');
{$ENDIF}
{$IFNDEF FPC}
    RegisterMethod('Function GetName : String');
    RegisterMethod('Function Instance : Longint');
    RegisterMethod('procedure AfterConstruction;');
    RegisterMethod('procedure BeforeDestruction;');

{$ENDIF}
    RegisterMethod('Procedure HideDragImage');
    RegisterMethod('Procedure ShowDragImage');
{$IFDEF DELPHI4UP}
    RegisterProperty('Cancelling', 'Boolean', iptrw);
    RegisterProperty('DragHandle', 'Longint', iptrw);
    RegisterProperty('DragPos', 'TPoint', iptrw);
    RegisterProperty('DragTargetPos', 'TPoint', iptrw);
    RegisterProperty('MouseDeltaX', 'Double', iptr);
    RegisterProperty('MouseDeltaY', 'Double', iptr);
{$ENDIF}
{$ENDIF}
  end;
  Cl.AddTypeS('TStartDragEvent', 'procedure (Sender: TObject; var DragObject: TDragObject)');
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMouse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMouse') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMouse') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure SettingChanged( Setting : Integer)');
    RegisterMethod('Function CreatePanningWindow : TCustomPanningWindow');
    RegisterProperty('Capture', 'HWND', iptrw);
    RegisterProperty('CursorPos', 'TPoint', iptrw);
    RegisterProperty('DragImmediate', 'Boolean', iptrw);
    RegisterProperty('DragThreshold', 'Integer', iptrw);
    RegisterProperty('MousePresent', 'Boolean', iptr);
    RegisterProperty('IsDragging', 'Boolean', iptr);
    RegisterProperty('IsPanning', 'Boolean', iptr);
    RegisterProperty('PanningWindow', 'TCustomPanningWindow', iptrw);
    RegisterProperty('PanningWindowClass', 'TPanningWindowClass', iptrw);
    RegisterProperty('RegWheelMessage', 'UINT', iptr);
    RegisterProperty('WheelPresent', 'Boolean', iptr);
    RegisterProperty('WheelScrollLines', 'Integer', iptr);
  end;
end;


procedure SIRegister_Controls(Cl: TPSPascalCompiler);
begin
  SIRegister_Controls_TypesAndConsts(cl);
  SIRegisterTDragObject(cl);

  SIRegister_TMargins(CL);
  SIRegister_TPadding(CL);
  SIRegister_TSizeConstraints(CL);

  SIRegisterTControl(Cl);
  SIRegisterTWinControl(Cl);
   SIRegisterTGraphicControl(cl);
   SIRegister_TWinControlActionLink(CL);

  SIRegister_TCustomControl(CL);
  SIRegister_TCustomTransparentControl(CL);
  SIRegister_THintWindow(CL);
  SIRegister_TCustomPanningWindow(CL);
  SIRegister_TMouse(CL);
  SIRegister_TCustomListControl(CL);
  SIRegister_TCustomMultiSelectListControl(CL);

  SIRegister_TControlCanvas(CL);
  SIRegister_TCustomControlAction(CL);
  SIRegister_TControlAction(CL);
  SIRegister_TControlActionLink(CL);
  //SIRegister_TMargins(CL);
  //SIRegister_TPadding(CL);
  //SIRegister_TSizeConstraints(CL);

   CL.AddTypeS('TCMCancelMode', 'record Msg : Cardinal; Unused : Integer; Sender'
   +' : TControl; Result : Longint; end');
  CL.AddTypeS('TCMFocusChanged', 'record Msg : Cardinal; Unused : Integer; Send'
   +'er : TWinControl; Result : Longint; end');
  CL.AddTypeS('TCMControlListChange', 'record Msg : Cardinal; Control : TContro'
   +'l; Inserting : LongBool; Result : Longint; end');
   CL.AddTypeS('TGetSiteInfoEvent', 'Procedure ( Sender : TObject; DockClient : '
   +'TControl; var InfluenceRect : TRect; MousePos : TPoint; var CanDock : Boolean)');
  CL.AddTypeS('TCanResizeEvent', 'Procedure ( Sender : TObject; var NewWidth, N'
   +'ewHeight : Integer; var Resize : Boolean)');
  //CL.AddTypeS('PControlListItem', '^TControlListItem // will not work');
  CL.AddTypeS('TControlListItem', 'record Control : TControl; Parent : TWinControl; end');
  //CL.AddTypeS('TCMControlListChanging', 'record Msg : Cardinal; ControlListItem'
  // +' : PControlListItem; Inserting : LongBool; Result : Longint; end');
  CL.AddTypeS('TCMChildKey', 'record Msg : Cardinal; CharCode : Word; Unused : Word; Sender : TWinControl; Result : Longint; end');
  CL.AddTypeS('TCMControlChange', 'record Msg : Cardinal; Control : TControl; Inserting : LongBool; Result : Longint; end');
  CL.AddTypeS('TCMChanged', 'record Msg : Cardinal; Unused : Longint; Child : TControl; Result : Longint; end');
  CL.AddTypeS('TConstrainedResizeEvent', 'Procedure ( Sender : TObject; var Min'
   +'Width, MinHeight, MaxWidth, MaxHeight : Integer)');
  CL.AddTypeS('TMouseWheelEvent', 'Procedure ( Sender : TObject; Shift : TShift'
   +'State; WheelDelta : Integer; MousePos : TPoint; var Handled : Boolean)');
  CL.AddTypeS('TMouseWheelUpDownEvent', 'Procedure ( Sender : TObject; Shift : '
   +'TShiftState; MousePos : TPoint; var Handled : Boolean)');
  CL.AddTypeS('TContextPopupEvent', 'Procedure ( Sender : TObject; MousePos : T'
   +'Point; var Handled : Boolean)');
    CL.AddTypeS('TAlignInsertBeforeEvent', 'Function ( Sender : TWinControl; C1, '
   +'C2 : TControl) : Boolean');
  CL.AddTypeS('TAlignPositionEvent', 'Procedure ( Sender : TWinControl; Control'
   +' : TControl; var NewLeft, NewTop, NewWidth, NewHeight : Integer; var Align'
   +'Rect : TRect; AlignInfo : TAlignInfo)');

  //SIRegisterTCustomControl(cl);
  //SIRegister_TImageList(CL);

   CL.AddClassN(CL.FindClass('TComponent'),'TCustomImageList');

  SIRegister_TDragImageList(CL);
  SIRegister_TImageList(CL);
  SIRegister_TMouse(CL);


end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.
