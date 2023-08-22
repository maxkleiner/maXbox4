{ Compiletime STDCtrls support }
unit uPSC_stdctrls;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{
   Will register files from:
     stdctrls   with memo events, oemconvert, max   add click as method
     add statictext
     more props and methods in tmemo, tlistbox, tcombobox , add boxstring - add on datafind listbox
 
Requires:
  STD, classes, controls and graphics     RegisterProperty('PageSize', 'Integer', iptrwf);
}

procedure SIRegister_StdCtrls_TypesAndConsts(cl: TPSPascalCompiler);



procedure SIRegisterTCUSTOMGROUPBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTGROUPBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTCUSTOMLABEL(Cl: TPSPascalCompiler);
procedure SIRegisterTLABEL(Cl: TPSPascalCompiler);
procedure SIRegisterTCUSTOMEDIT(Cl: TPSPascalCompiler);
procedure SIRegisterTEDIT(Cl: TPSPascalCompiler);
procedure SIRegisterTCUSTOMMEMO(Cl: TPSPascalCompiler);
procedure SIRegisterTMEMO(Cl: TPSPascalCompiler);
procedure SIRegister_TCustomComboBoxStrings(CL: TPSPascalCompiler);
procedure SIRegisterTCUSTOMCOMBOBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTCOMBOBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTBUTTONCONTROL(Cl: TPSPascalCompiler);
procedure SIRegisterTBUTTON(Cl: TPSPascalCompiler);
procedure SIRegisterTCUSTOMCHECKBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTCHECKBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTRADIOBUTTON(Cl: TPSPascalCompiler);
procedure SIRegisterTCUSTOMLISTBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTLISTBOX(Cl: TPSPascalCompiler);
procedure SIRegisterTSCROLLBAR(Cl: TPSPascalCompiler);
procedure SIRegister_TStaticText(CL: TPSPascalCompiler);
procedure SIRegister_TCustomStaticText(CL: TPSPascalCompiler);


procedure SIRegister_StdCtrls(cl: TPSPascalCompiler);


implementation

procedure SIRegisterTCUSTOMGROUPBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'TCUSTOMGROUPBOX') do
      RegisterMethod('Constructor Create( AOwner : TComponent)');

end;


procedure SIRegister_TCustomComboBoxStrings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStrings', 'TCustomComboBoxStrings') do
  with CL.AddClassN(CL.FindClass('TStrings'),'TCustomComboBoxStrings') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function IndexOf( const S : string) : Integer');
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStaticText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomStaticText', 'TStaticText') do
  with CL.AddClassN(CL.FindClass('TCustomStaticText'),'TStaticText') do begin
  RegisterPublishedProperties;
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
     RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('ShowButtons', 'Boolean', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ShowLines', 'Boolean', iptrw);
    RegisterProperty('ShowRoot', 'Boolean', iptrw);
    RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('SCROLLBARS', 'TScrollStyle', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomStaticText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TCustomStaticText') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TCustomStaticText') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;




procedure SIRegisterTGROUPBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMGROUPBOX'), 'TGROUPBOX') do begin
    RegisterPublishedProperties;
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
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
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegisterTCUSTOMLABEL(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TCUSTOMLABEL') do
  begin
    {$IFNDEF PS_MINIVCL}
{$IFNDEF CLX}
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
{$ENDIF}
    {$ENDIF}
    RegisterProperty('Caption', 'TCaption', iptrw);
   RegisterProperty('CaptionS', 'STRING', iptrw);
   RegisterMethod('Constructor Create(AOwner: TComponent);');
  end;
end;


procedure SIRegisterTLABEL(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMLABEL'), 'TLABEL') do begin
    RegisterPublishedProperties;
     RegisterProperty('ALIGN', 'TALIGN', iptrw);
      RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('AUTOSIZE', 'Boolean', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('FOCUSCONTROL', 'TWinControl', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('LAYOUT', 'TTextLayout', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('SHOWACCELCHAR', 'Boolean', iptrw);
    RegisterProperty('TRANSPARENT', 'Boolean', iptrw);
    RegisterProperty('WORDWRAP', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
  end;
end;



procedure SIRegisterTCUSTOMEDIT(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TWINCONTROL'), 'TCUSTOMEDIT') do begin
    RegisterMethod('procedure CLEAR');
    RegisterMethod('procedure CLEARSELECTION');
    RegisterMethod('procedure SELECTALL');
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('procedure DefaultHandler(var Message);');
    RegisterMethod('procedure Undo;');
   RegisterMethod('procedure ClearUndo;');

    RegisterProperty('MODIFIED', 'BOOLEAN', iptrw);
    RegisterProperty('SELLENGTH', 'INTEGER', iptrw);
    RegisterProperty('SELSTART', 'INTEGER', iptrw);
    RegisterProperty('SELTEXT', 'String', iptrw);
    RegisterProperty('TEXT', 'String', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterMethod('procedure COPYTOCLIPBOARD');
    RegisterMethod('procedure CUTTOCLIPBOARD');
    RegisterMethod('procedure PASTEFROMCLIPBOARD');
    RegisterMethod('function GETSELTEXTBUF(BUFFER:PCHAR;BUFSIZE:INTEGER):INTEGER');
    RegisterMethod('procedure SETSELTEXTBUF(BUFFER:PCHAR)');
    {$ENDIF}
  end;
end;




procedure SIRegisterTEDIT(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMEDIT'), 'TEDIT') do begin
    RegisterPublishedProperties;
      RegisterProperty('ALIGN', 'TALIGN', iptrw);
      RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('AUTOSIZE', 'Boolean', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
     RegisterProperty('AUTOSELECT', 'Boolean', iptrw);
    RegisterProperty('AUTOSIZE', 'Boolean', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PASSWORDCHAR', 'Char', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ALIGN', 'TALIGN', iptrw);
     {$IFNDEF PS_MINIVCL}
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
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




procedure SIRegisterTCUSTOMMEMO(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMEDIT'), 'TCUSTOMMEMO') do begin
    {$IFNDEF CLX}
    RegisterProperty('LINES', 'TSTRINGS', iptrw);
     RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
     RegisterMethod('function GetControlsAlignment: TAlignment;');
     RegisterProperty('CaretPos', 'TPoint', iptrw);
    // property CaretPos: TPoint read GetCaretPos write SetCaretPos;
     // function GetControlsAlignment: TAlignment; override;
    {$ENDIF}
  end;
end;


procedure SIRegisterTMEMO(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMMEMO'), 'TMEMO') do begin
    {$IFDEF CLX}
    RegisterProperty('LINES', 'TSTRINGS', iptrw);
    {$ENDIF}
    RegisterPublishedProperties;
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
       RegisterProperty('ALIGN', 'TALIGN', iptrw);
      RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('SCROLLBARS', 'TScrollStyle', iptrw);
    RegisterProperty('WANTRETURNS', 'Boolean', iptrw);
    RegisterProperty('WANTTABS', 'Boolean', iptrw);
    RegisterProperty('WORDWRAP', 'Boolean', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('OEMConvert', 'Boolean', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);

    //RegisterProperty('COLOR', 'TColor', iptrw);
    //RegisterProperty('FONT', 'TFont', iptrw);
    //RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    //RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     //RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     //RegisterProperty('TEXT', 'String', iptrw);
    //RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
   
    {$IFNDEF PS_MINIVCL}
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
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




procedure SIRegisterTCUSTOMCOMBOBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TWINCONTROL'), 'TCUSTOMCOMBOBOX') do begin
    RegisterProperty('DROPPEDDOWN', 'BOOLEAN', iptrw);
    RegisterProperty('ITEMS', 'TSTRINGS', iptrw);
    RegisterProperty('ITEMINDEX', 'INTEGER', iptrw);
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    {$IFNDEF PS_MINIVCL}
    RegisterMethod('procedure CLEAR');
    RegisterMethod('procedure SELECTALL');
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
    RegisterProperty('SELLENGTH', 'INTEGER', iptrw);
    RegisterProperty('SELSTART', 'INTEGER', iptrw);
    RegisterProperty('SELTEXT', 'String', iptrw);
    {$ENDIF}
  end;
end;


procedure SIRegisterTCOMBOBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCOMBOBOX'), 'TCOMBOBOX') do begin
       RegisterPublishedProperties;
     RegisterProperty('STYLE', 'TComboBoxStyle', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('DROPDOWNCOUNT', 'Integer', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('SORTED', 'Boolean', iptrw);
    RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDROPDOWN', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('ITEMHEIGHT', 'Integer', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONDRAWITEM', 'TDrawItemEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMEASUREITEM', 'TMeasureItemEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegisterTBUTTONCONTROL(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TWINCONTROL'), 'TBUTTONCONTROL') do begin
     //RegisterMethod('Function Finished: boolean', cdRegister);
     RegisterMethod('Constructor Create(AOwner: TComponent);');
   end;
end;



procedure SIRegisterTBUTTON(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TBUTTONCONTROL'),  'TBUTTON') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent)');
   RegisterMethod('Procedure Click');
   RegisterMethod('Function UseRightToLeftAlignment: boolean');
     //  procedure Click; override;

    RegisterPublishedProperties;
    RegisterProperty('CANCEL', 'BOOLEAN', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('DEFAULT', 'BOOLEAN', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('MODALRESULT', 'LONGINT', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('WordWrap', 'BOOLEAN', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegisterTCUSTOMCHECKBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TBUTTONCONTROL'), 'TCUSTOMCHECKBOX') do begin
   RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('GetControlsAlignment: TAlignment;');
  end;
end;



procedure SIRegisterTCHECKBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCHECKBOX'), 'TCHECKBOX') do begin
       RegisterPublishedProperties;
     RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('ALLOWGRAYED', 'Boolean', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'Boolean', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('STATE', 'TCheckBoxState', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCHANGE', 'TNOTIFYEVENT', iptrw);

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
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegisterTRADIOBUTTON(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TBUTTONCONTROL'), 'TRADIOBUTTON') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('GetControlsAlignment: TAlignment;');
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
       RegisterPublishedProperties;
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
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegisterTCUSTOMLISTBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TWINCONTROL'), 'TCUSTOMLISTBOX') do begin
    RegisterProperty('ITEMS', 'TSTRINGS', iptrw);
    RegisterProperty('ITEMINDEX', 'INTEGER', iptrw);
    RegisterProperty('SELCOUNT', 'INTEGER', iptr);
    RegisterProperty('SELECTED', 'BOOLEAN INTEGER', iptrw);
    RegisterProperty('ScrollWidth', 'integer', iptrw);
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    {$IFNDEF PS_MINIVCL}
    RegisterMethod('procedure CLEAR');
    RegisterMethod('procedure CLEARSelection');
    RegisterMethod('procedure DeleteSelected');
    RegisterMethod('procedure SelectAll');
    RegisterMethod('procedure AddItem(Item: String; AObject: TObject);');
    RegisterMethod('function ITEMATPOS(POS:TPOINT;EXISTING:BOOLEAN):INTEGER');
    RegisterMethod('function ITEMRECT(INDEX:INTEGER):TRECT');
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
    RegisterProperty('TOPINDEX', 'INTEGER', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegisterTLISTBOX(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMLISTBOX'), 'TLISTBOX') do begin
    RegisterPublishedProperties;
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('BEVELOUTER', 'TPanelBevel', iptrw);
    RegisterProperty('BEVELWIDTH', 'TBevelWidth', iptrw);
    RegisterProperty('BORDERWIDTH', 'TBorderWidth', iptrw);
    //RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    //RegisterProperty('Style', 'TListboxStyle', iptrw);
    RegisterProperty('AutoComplete', 'boolean', iptrw);
    RegisterProperty('AutoCompleteDelay', 'integer', iptrw);
      RegisterProperty('ALIGN', 'TALIGN', iptrw);
      RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('AUTOSIZE', 'Boolean', iptrw);
    //RegisterProperty('CAPTION', 'String', iptrw);
       RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('MULTISELECT', 'Boolean', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('SORTED', 'Boolean', iptrw);
    RegisterProperty('STYLE', 'TListBoxStyle', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    //RegisterProperty('ScrollWidth', 'integer', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);

    {$IFNDEF PS_MINIVCL}
    RegisterProperty('COLUMNS', 'Integer', iptrw);
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('EXTENDEDSELECT', 'Boolean', iptrw);
    RegisterProperty('INTEGRALHEIGHT', 'Boolean', iptrw);
    RegisterProperty('ITEMHEIGHT', 'Integer', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('TABWIDTH', 'Integer', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONDRAWITEM', 'TDrawItemEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMEASUREITEM', 'TMeasureItemEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    RegisterProperty('OnData', 'TLBGetDataEvent', iptrw);
    RegisterProperty('OnDataFind', 'TLBFindDataEvent', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegisterTSCROLLBAR(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TWINCONTROL'), 'TSCROLLBAR') do begin
     RegisterMethod('Constructor Create(AOwner: TComponent);');
     RegisterMethod('procedure SetParams(APosition, AMin, AMax: Integer);');
     RegisterPublishedProperties;
     RegisterProperty('KIND', 'TSCROLLBARKIND', iptrw);
    RegisterProperty('MAX', 'INTEGER', iptrw);
    RegisterProperty('MIN', 'INTEGER', iptrw);
    RegisterProperty('POSITION', 'INTEGER', iptrw);
    RegisterProperty('ONCHANGE', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('PageSize', 'Integer', iptrw);
    RegisterProperty('showhint', 'boolean', iptrw);

    {$IFNDEF PS_MINIVCL}
    //RegisterMethod('procedure SETPARAMS(APOSITION,AMIN,AMAX:INTEGER)');
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('LARGECHANGE', 'TSCROLLBARINC', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('SMALLCHANGE', 'TSCROLLBARINC', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONSCROLL', 'TSCROLLEVENT', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;



procedure SIRegister_StdCtrls_TypesAndConsts(cl: TPSPascalCompiler);
begin
  Cl.addTypeS('TEOwnerDrawState', '(odSelected, odGrayed, odDisabled, odChecked,'
    +' odFocused, odDefault, odHotLight, odInactive, odNoAccel, odNoFocusRect,'
    +' odReserved1, odReserved2, odComboBoxEdit)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPopUpMenu');
   cl.AddTypeS('TFormBorderStyle', '(bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin)');
  cl.AddTypeS('TBorderStyle', 'TFormBorderStyle');       //also in upsc_forms
  cl.AddTypeS('TOwnerDrawState', 'set of TEOwnerDrawState');
  cl.AddTypeS('TEditCharCase', '(ecNormal, ecUpperCase, ecLowerCase)');
  cl.AddTypeS('TScrollStyle', '(ssNone, ssHorizontal, ssVertical, ssBoth)');
  cl.AddTypeS('TComboBoxStyle', '(csDropDown, csSimple, csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable)');
  //cl.AddTypeS('TDrawItemEvent', 'procedure(Control: TWinControl; Index: Integer; Rect: TRect; State: Byte)');
  cl.AddTypeS('TDrawItemEvent', 'procedure(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState)');
  CL.AddTypeS('TSelection', 'record StartPos : integer; EndPos : Integer; end');
   CL.AddTypeS('TLBGetDataEvent', 'procedure(Control: TWinControl; Index: Integer; var Data: string)');
   CL.AddTypeS('TLBFindDataEvent', 'function(Control: TWinControl; FindString: string): Integer)');


  //State: TOwnerDrawState
  cl.AddTypeS('TMeasureItemEvent', 'procedure(Control: TWinControl; Index: Integer; var Height: Integer)');
  cl.AddTypeS('TCheckBoxState', '(cbUnchecked, cbChecked, cbGrayed)');
  cl.AddTypeS('TListBoxStyle', '(lbStandard, lbOwnerDrawFixed, lbOwnerDrawVariable)');
  cl.AddTypeS('TScrollCode', '(scLineUp, scLineDown, scPageUp, scPageDown, scPosition, scTrack, scTop, scBottom, scEndScroll)');
  cl.AddTypeS('TScrollEvent', 'procedure(Sender: TObject; ScrollCode: TScrollCode;var ScrollPos: Integer)');

  cl.AddTypeS('TTextLayout', '( tlTop, tlCenter, tlBottom )');
end;


procedure SIRegister_stdctrls(cl: TPSPascalCompiler);
begin
  SIRegister_StdCtrls_TypesAndConsts(cl);
  {$IFNDEF PS_MINIVCL}
  SIRegisterTCUSTOMGROUPBOX(Cl);
  SIRegisterTGROUPBOX(Cl);
  {$ENDIF}
  SIRegisterTCUSTOMLABEL(Cl);
  SIRegisterTLABEL(Cl);
  SIRegisterTCUSTOMEDIT(Cl);
  SIRegisterTEDIT(Cl);
  SIRegisterTCUSTOMMEMO(Cl);
  SIRegisterTMEMO(Cl);
  SIRegisterTCUSTOMCOMBOBOX(Cl);
  SIRegisterTCOMBOBOX(Cl);
  SIRegisterTBUTTONCONTROL(Cl);
  SIRegisterTBUTTON(Cl);
  SIRegisterTCUSTOMCHECKBOX(Cl);
  SIRegisterTCHECKBOX(Cl);
  SIRegisterTRADIOBUTTON(Cl);
  SIRegisterTCUSTOMLISTBOX(Cl);
  SIRegisterTLISTBOX(Cl);
  SIRegister_TCustomStaticText(CL);
  SIRegister_TStaticText(CL);
  {$IFNDEF PS_MINIVCL}
  SIRegisterTSCROLLBAR(Cl);
  {$ENDIF}
  SIRegister_TCustomComboBoxStrings(CL);

end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.





