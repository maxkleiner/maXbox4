{ Compiletime Extctrls support }
unit uPSC_extctrls;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

(*
   Will register files from:
     ExtCtrls    // add custom radio methods
Requires:
  STD, classes, controls, graphics {$IFNDEF PS_MINIVCL}, stdctrls {$ENDIF}
*)

procedure SIRegister_ExtCtrls_TypesAndConsts(cl: TPSPascalCompiler);

procedure SIRegisterTSHAPE(Cl: TPSPascalCompiler);
procedure SIRegisterTIMAGE(Cl: TPSPascalCompiler);
procedure SIRegisterTPAINTBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTBEVEL(Cl: TPSPascalCompiler);
procedure SIRegisterTTIMER(Cl: TPSPascalCompiler);
procedure SIRegisterTCUSTOMPANEL(Cl: TPSPascalCompiler);
procedure SIRegisterTPANEL(Cl: TPSPascalCompiler);
{$IFNDEF CLX}
procedure SIRegisterTPAGE(Cl: TPSPascalCompiler);
procedure SIRegisterTNOTEBOOK(Cl: TPSPascalCompiler);
procedure SIRegisterTHEADER(Cl: TPSPascalCompiler);
{$ENDIF}
procedure SIRegisterTCUSTOMRADIOGROUP(Cl: TPSPascalCompiler);
procedure SIRegisterTRADIOGROUP(Cl: TPSPascalCompiler);

procedure SIRegister_ExtCtrls(cl: TPSPascalCompiler);

implementation
procedure SIRegisterTSHAPE(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TSHAPE') do begin
    RegisterProperty('BRUSH', 'TBRUSH', iptrw);
    RegisterProperty('PEN', 'TPEN', iptrw);
    RegisterProperty('SHAPE', 'TSHAPETYPE', iptrw);
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
      {$IFNDEF PS_MINIVCL}
    RegisterMethod('procedure STYLECHANGED(SENDER:TOBJECT)');
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    RegisterMethod('procedure ScaleBy(M, D: Integer);');
      RegisterProperty('Visible', 'Boolean', iptrw);
    {$ENDIF}
    RegisterPublishedProperties;
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
    RegisterProperty('Constraints', 'TSizeConstraints', iptrw);
  end;
end;

procedure SIRegisterTIMAGE(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TIMAGE') do begin
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
    RegisterProperty('AUTOSIZE', 'BOOLEAN', iptrw);
    RegisterProperty('CENTER', 'BOOLEAN', iptrw);
    RegisterProperty('PICTURE', 'TPICTURE', iptrw);
    RegisterProperty('STRETCH', 'BOOLEAN', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Procedure Free');
       RegisterPublishedProperties;
     RegisterProperty('Proportional', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('IncrementalDisplay', 'Boolean', iptrw);
         RegisterProperty('Visible', 'Boolean', iptrw);
    {$IFNDEF PS_MINIVCL}
     RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    RegisterProperty('OnProgress', 'TProgressEvent', iptrw);
      // property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
      {$ENDIF}
  end;
end;

procedure SIRegisterTPAINTBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TPAINTBOX') do begin
     RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterProperty('CANVAS', 'TCanvas', iptr);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONPAINT', 'TNOTIFYEVENT', iptrw);
      RegisterPublishedProperties;
        RegisterProperty('Constraints', 'TSizeConstraints', iptrw);
       RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
     {$IFNDEF PS_MINIVCL}
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTBEVEL(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TBEVEL') do begin
      RegisterMethod('Constructor Create(AOwner: TComponent);');
      RegisterPublishedProperties;
      RegisterProperty('SHAPE', 'TBEVELSHAPE', iptrw);
    RegisterProperty('STYLE', 'TBEVELSTYLE', iptrw);
    RegisterProperty('Constraints', 'TSizeConstraints', iptrw);
      RegisterProperty('Visible', 'Boolean', iptrw);
       //RegisterProperty('Constraints', 'TSizeConstraints', iptrw);
      {$IFNDEF PS_MINIVCL}
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTTIMER(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCOMPONENT'), 'TTIMER') do begin
  RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterProperty('ENABLED', 'BOOLEAN', iptrw);
    RegisterProperty('INTERVAL', 'CARDINAL', iptrw);
    RegisterProperty('ONTIMER', 'TNOTIFYEVENT', iptrw);
  end;
end;

procedure SIRegisterTCUSTOMPANEL(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'TCUSTOMPANEL') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
    //RegisterMethod('Procedure Free');
     RegisterMethod('function GetControlsAlignment: TAlignment;');
  end
end;

procedure SIRegisterTPANEL(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMPANEL'), 'TPANEL') do begin
    RegisterPublishedProperties;
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BEVELINNER', 'TPanelBevel', iptrw);
    RegisterProperty('BEVELOUTER', 'TPanelBevel', iptrw);
    RegisterProperty('BEVELWIDTH', 'TBevelWidth', iptrw);
    RegisterProperty('BORDERWIDTH', 'TBorderWidth', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    //RegisterProperty('CAPTION', 'String', iptrw);
    //RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    //  RegisterPublishedProperties;
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('FullRepaint', 'Boolean', iptrw);
    RegisterProperty('Padding', 'TPadding', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('Autosize', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);


    {$IFNDEF PS_MINIVCL}
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('LOCKED', 'Boolean', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONRESIZE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;
{$IFNDEF CLX}
procedure SIRegisterTPAGE(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'TPAGE') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
     RegisterProperty('CAPTION', 'String', iptrw);
  end;
end;
procedure SIRegisterTNOTEBOOK(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'TNOTEBOOK') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
   RegisterMethod('Procedure Free');
        RegisterPublishedProperties;
      RegisterProperty('ACTIVEPAGE', 'String', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PAGEINDEX', 'INTEGER', iptrw);
    RegisterProperty('PAGES', 'TSTRINGS', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONPAGECHANGED', 'TNOTIFYEVENT', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTHEADER(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'THEADER') do begin
     RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
      RegisterProperty('SECTIONWIDTH', 'INTEGER INTEGER', iptrw);
    RegisterProperty('ALLOWRESIZE', 'BOOLEAN', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBORDERSTYLE', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('SECTIONS', 'TSTRINGS', iptrw);
    RegisterProperty('ONSIZING', 'TSECTIONEVENT', iptrw);
    RegisterProperty('ONSIZED', 'TSECTIONEVENT', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    {$ENDIF}
  end;
end;
{$ENDIF}

procedure SIRegisterTCUSTOMRADIOGROUP(Cl: TPSPascalCompiler);
begin
 //with CL.AddClassN(CL.FindClass('TCustomGroupBox'),'TCustomRadioGroup') do begin
 with  Cl.AddClassN(cl.FindClass('TCUSTOMGROUPBOX'), 'TCUSTOMRADIOGROUP') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure FlipChildren( AllLevels : Boolean)');
    RegisterProperty('Buttons', 'TRadioButton Integer', iptr);
 end;
end;

procedure SIRegisterTRADIOGROUP(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMRADIOGROUP'), 'TRADIOGROUP') do begin
    RegisterPublishedProperties;
     RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('COLUMNS', 'Integer', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ITEMINDEX', 'Integer', iptrw);
    RegisterProperty('ITEMS', 'TStrings', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegister_ExtCtrls_TypesAndConsts(cl: TPSPascalCompiler);
begin
  cl.AddTypeS('TShapeType', '(stRectangle, stSquare, stRoundRect, stRoundSquare, stEllipse, stCircle)');
  cl.AddTypeS('TBevelStyle', '(bsLowered, bsRaised)');
  cl.AddTypeS('TBevelShape', '(bsBox, bsFrame, bsTopLine, bsBottomLine, bsLeftLine, bsRightLine,bsSpacer)');
  cl.AddTypeS('TPanelBevel', '(bvNone, bvLowered, bvRaised,bvSpace)');
  cl.AddTypeS('TBevelWidth', 'Longint');
  cl.AddTypeS('TBorderWidth', 'Longint');
  cl.AddTypeS('TSectionEvent', 'procedure(Sender: TObject; ASection, AWidth: Integer)');
end;

procedure SIRegister_ExtCtrls(cl: TPSPascalCompiler);
begin
  SIRegister_ExtCtrls_TypesAndConsts(cl);

  {$IFNDEF PS_MINIVCL}
  SIRegisterTSHAPE(Cl);
  SIRegisterTIMAGE(Cl);
  SIRegisterTPAINTBOX(Cl);
  {$ENDIF}
  SIRegisterTBEVEL(Cl);
  {$IFNDEF PS_MINIVCL}
  SIRegisterTTIMER(Cl);
  {$ENDIF}
  SIRegisterTCUSTOMPANEL(Cl);
  SIRegisterTPANEL(Cl);
  {$IFNDEF PS_MINIVCL}
  {$IFNDEF CLX}
  SIRegisterTPAGE(Cl);
  SIRegisterTNOTEBOOK(Cl);
  SIRegisterTHEADER(Cl);
  {$ENDIF}
  SIRegisterTCUSTOMRADIOGROUP(Cl);
  SIRegisterTRADIOGROUP(Cl);
  {$ENDIF}
end;

end.





