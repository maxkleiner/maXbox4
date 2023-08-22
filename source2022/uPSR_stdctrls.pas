{ STDCtrls import unit }
unit uPSR_stdctrls;

{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils;

  //REAL

procedure RIRegisterTCUSTOMGROUPBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTGROUPBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMLABEL(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTLABEL(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMEDIT(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTEDIT(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMMEMO(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTMEMO(Cl: TPSRuntimeClassImporter);
procedure RIRegister_TCustomComboBoxStrings(CL: TPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMCOMBOBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCOMBOBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTBUTTONCONTROL(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTBUTTON(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMCHECKBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCHECKBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTRADIOBUTTON(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMLISTBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTLISTBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTSCROLLBAR(Cl: TPSRuntimeClassImporter);
procedure RIRegister_TStaticText(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomStaticText(CL: TPSRuntimeClassImporter);


procedure RIRegister_stdctrls(cl: TPSRuntimeClassImporter);

implementation
uses
  sysutils, classes{$IFDEF CLX}, QControls, QStdCtrls, QGraphics{$ELSE}, controls, stdctrls, types, Graphics{$ENDIF}{$IFDEF FPC},buttons{$ENDIF};

procedure RIRegisterTCUSTOMGROUPBOX(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMGROUPBOX) do
     RegisterConstructor(@TCUSTOMGROUPBOX.Create, 'Create');
end;

procedure RIRegister_TCustomComboBoxStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomComboBoxStrings) do begin
    RegisterMethod(@TCustomComboBoxStrings.Clear, 'Clear');
    RegisterMethod(@TCustomComboBoxStrings.Delete, 'Delete');
    RegisterMethod(@TCustomComboBoxStrings.IndexOf, 'IndexOf');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TStaticText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStaticText) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomStaticText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomStaticText) do begin
    RegisterConstructor(@TCustomStaticText.Create, 'Create');
  end;
end;



procedure RIRegisterTGROUPBOX(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TGROUPBOX);
end;
{$IFNDEF CLX}
procedure TCUSTOMLABELCANVAS_R(Self: TCUSTOMLABEL; var T: TCanvas); begin T := Self.CANVAS; end;
{$ENDIF}

procedure TCUSTOMLABELCaption_R(Self: TCUSTOMLABEL; var T: TCaption); begin T := Self.Caption; end;
procedure TCUSTOMLabelCaption_W(Self: TCUSTOMLabel; T: TCaption); begin Self.Caption:= T; end;

procedure TCUSTOMLABELCaptions_R(Self: TCUSTOMLABEL; var T: string); begin T := Self.Caption; end;
procedure TCUSTOMLabelCaptions_W(Self: TCUSTOMLabel; T: string); begin Self.Caption:= T; end;

procedure RIRegisterTCUSTOMLABEL(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMLABEL) do begin
   RegisterConstructor(@TCUSTOMLABEL.Create, 'Create');
    {$IFNDEF PS_MINIVCL}
{$IFNDEF CLX}
    RegisterPropertyHelper(@TCUSTOMLABELCANVAS_R, nil, 'CANVAS');
{$ENDIF}
    {$ENDIF}
   RegisterPropertyHelper(@TCUSTOMLABELCaption_R,@TCUSTOMLABELCaption_W,'Caption');
   RegisterPropertyHelper(@TCUSTOMLABELCaptions_R,@TCUSTOMLABELCaptions_W,'Captions');

  end;
end;

procedure RIRegisterTLABEL(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TLABEL);
end;
procedure TCUSTOMEDITMODIFIED_R(Self: TCUSTOMEDIT; var T: BOOLEAN); begin T := Self.MODIFIED; end;
procedure TCUSTOMEDITMODIFIED_W(Self: TCUSTOMEDIT; T: BOOLEAN); begin Self.MODIFIED := T; end;
procedure TCUSTOMEDITSELLENGTH_R(Self: TCUSTOMEDIT; var T: INTEGER); begin T := Self.SELLENGTH; end;
procedure TCUSTOMEDITSELLENGTH_W(Self: TCUSTOMEDIT; T: INTEGER); begin Self.SELLENGTH := T; end;
procedure TCUSTOMEDITSELSTART_R(Self: TCUSTOMEDIT; var T: INTEGER); begin T := Self.SELSTART; end;
procedure TCUSTOMEDITSELSTART_W(Self: TCUSTOMEDIT; T: INTEGER); begin Self.SELSTART := T; end;
procedure TCUSTOMEDITSELTEXT_R(Self: TCUSTOMEDIT; var T: STRING); begin T := Self.SELTEXT; end;
procedure TCUSTOMEDITSELTEXT_W(Self: TCUSTOMEDIT; T: STRING); begin Self.SELTEXT := T; end;
procedure TCUSTOMEDITTEXT_R(Self: TCUSTOMEDIT; var T: string); begin T := Self.TEXT; end;
procedure TCUSTOMEDITTEXT_W(Self: TCUSTOMEDIT; T: string); begin Self.TEXT := T; end;


procedure RIRegisterTCUSTOMEDIT(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMEDIT) do begin
    RegisterMethod(@TCUSTOMEDIT.CLEAR, 'CLEAR');
    RegisterMethod(@TCUSTOMEDIT.CLEARSELECTION, 'CLEARSELECTION');
    RegisterMethod(@TCUSTOMEDIT.SELECTALL, 'SELECTALL');

      RegisterConstructor(@TCUSTOMEDIT.Create, 'Create');
    RegisterMethod(@TCUSTOMEDIT.DefaultHandler, 'DefaultHandler');
    RegisterMethod(@TCUSTOMEDIT.Undo, 'Undo');
    RegisterMethod(@TCUSTOMEDIT.ClearUndo, 'ClearUndo');
    RegisterPropertyHelper(@TCUSTOMEDITMODIFIED_R, @TCUSTOMEDITMODIFIED_W, 'MODIFIED');
    RegisterPropertyHelper(@TCUSTOMEDITSELLENGTH_R, @TCUSTOMEDITSELLENGTH_W, 'SELLENGTH');
    RegisterPropertyHelper(@TCUSTOMEDITSELSTART_R, @TCUSTOMEDITSELSTART_W, 'SELSTART');
    RegisterPropertyHelper(@TCUSTOMEDITSELTEXT_R, @TCUSTOMEDITSELTEXT_W, 'SELTEXT');
    RegisterPropertyHelper(@TCUSTOMEDITTEXT_R, @TCUSTOMEDITTEXT_W, 'TEXT');

    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TCUSTOMEDIT.COPYTOCLIPBOARD, 'COPYTOCLIPBOARD');
    RegisterMethod(@TCUSTOMEDIT.CUTTOCLIPBOARD, 'CUTTOCLIPBOARD');
		RegisterMethod(@TCUSTOMEDIT.PASTEFROMCLIPBOARD, 'PASTEFROMCLIPBOARD');
		{$IFNDEF FPC}
		RegisterMethod(@TCUSTOMEDIT.GETSELTEXTBUF, 'GETSELTEXTBUF');
    RegisterMethod(@TCUSTOMEDIT.SETSELTEXTBUF, 'SETSELTEXTBUF');
		{$ENDIF}{FPC}
    {$ENDIF}
  end;
end;

procedure RIRegisterTEDIT(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TEDIT);
end;


procedure TCUSTOMMEMOLINES_R(Self: {$IFDEF CLX}TMemo{$ELSE}TCUSTOMMEMO{$ENDIF}; var T: TSTRINGS); begin T := Self.LINES; end;
procedure TCUSTOMMEMOLINES_W(Self: {$IFDEF CLX}TMemo{$ELSE}TCUSTOMMEMO{$ENDIF}; T: TSTRINGS); begin Self.LINES := T; end;
procedure TCUSTOMMEMOcaret_R(Self: {$IFDEF CLX}TMemo{$ELSE}TCUSTOMMEMO{$ENDIF}; var T: TPoint); begin T:= Self.CaretPos; end;
procedure TCUSTOMMEMOcaret_W(Self: {$IFDEF CLX}TMemo{$ELSE}TCUSTOMMEMO{$ENDIF}; T: TPoint); begin Self.CaretPos:= T; end;


procedure RIRegisterTCUSTOMMEMO(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMMEMO) do begin
    {$IFNDEF CLX}
    RegisterPropertyHelper(@TCUSTOMMEMOLINES_R, @TCUSTOMMEMOLINES_W, 'LINES');
    {$ENDIF}
   RegisterConstructor(@TCUSTOMMEMO.Create, 'Create');
  RegisterMethod(@TCUSTOMMEMO.Free, 'Free');             //free v destroy
   RegisterMethod(@TCUSTOMMEMO.GetControlsAlignment, 'GetControlsAlignment');
    RegisterPropertyHelper(@TCUSTOMMEMOcaret_R, @TCUSTOMMEMOcaret_W, 'CaretPos');
  end;
end;


procedure RIRegisterTMEMO(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TMEMO) do begin
    {$IFDEF CLX}
    RegisterPropertyHelper(@TCUSTOMMEMOLINES_R, @TCUSTOMMEMOLINES_W, 'LINES');
    {$ENDIF}
  end;
end;


procedure TCUSTOMCOMBOBOXCANVAS_R(Self: TCUSTOMCOMBOBOX; var T: TCANVAS); begin T := Self.CANVAS; end;
procedure TCUSTOMCOMBOBOXDROPPEDDOWN_R(Self: TCUSTOMCOMBOBOX; var T: BOOLEAN); begin T := Self.DROPPEDDOWN; end;
procedure TCUSTOMCOMBOBOXDROPPEDDOWN_W(Self: TCUSTOMCOMBOBOX; T: BOOLEAN); begin Self.DROPPEDDOWN := T; end;
procedure TCUSTOMCOMBOBOXITEMS_R(Self: TCUSTOMCOMBOBOX; var T: TSTRINGS); begin T := Self.ITEMS; end;
procedure TCUSTOMCOMBOBOXITEMS_W(Self: TCUSTOMCOMBOBOX; T: TSTRINGS); begin Self.ITEMS := T; end;
procedure TCUSTOMCOMBOBOXITEMINDEX_R(Self: TCUSTOMCOMBOBOX; var T: INTEGER); begin T := Self.ITEMINDEX; end;
procedure TCUSTOMCOMBOBOXITEMINDEX_W(Self: TCUSTOMCOMBOBOX; T: INTEGER); begin Self.ITEMINDEX := T; end;
procedure TCUSTOMCOMBOBOXSELLENGTH_R(Self: TCUSTOMCOMBOBOX; var T: INTEGER); begin T := Self.SELLENGTH; end;
procedure TCUSTOMCOMBOBOXSELLENGTH_W(Self: TCUSTOMCOMBOBOX; T: INTEGER); begin Self.SELLENGTH := T; end;
procedure TCUSTOMCOMBOBOXSELSTART_R(Self: TCUSTOMCOMBOBOX; var T: INTEGER); begin T := Self.SELSTART; end;
procedure TCUSTOMCOMBOBOXSELSTART_W(Self: TCUSTOMCOMBOBOX; T: INTEGER); begin Self.SELSTART := T; end;
procedure TCUSTOMCOMBOBOXSELTEXT_R(Self: TCUSTOMCOMBOBOX; var T: STRING); begin T := Self.SELTEXT; end;
procedure TCUSTOMCOMBOBOXSELTEXT_W(Self: TCUSTOMCOMBOBOX; T: STRING); begin Self.SELTEXT := T; end;


procedure RIRegisterTCUSTOMCOMBOBOX(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMCOMBOBOX) do begin
    RegisterPropertyHelper(@TCUSTOMCOMBOBOXDROPPEDDOWN_R, @TCUSTOMCOMBOBOXDROPPEDDOWN_W, 'DROPPEDDOWN');
    RegisterPropertyHelper(@TCUSTOMCOMBOBOXITEMS_R, @TCUSTOMCOMBOBOXITEMS_W, 'ITEMS');
    RegisterPropertyHelper(@TCUSTOMCOMBOBOXITEMINDEX_R, @TCUSTOMCOMBOBOXITEMINDEX_W, 'ITEMINDEX');
    RegisterConstructor(@TCUSTOMCOMBOBOX.Create, 'Create');
    RegisterMethod(@TCUSTOMCOMBOBOX.Free, 'Free');

    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TCUSTOMCOMBOBOX.CLEAR, 'CLEAR');
    RegisterMethod(@TCUSTOMCOMBOBOX.SELECTALL, 'SELECTALL');
    RegisterPropertyHelper(@TCUSTOMCOMBOBOXCANVAS_R, nil, 'CANVAS');
    RegisterPropertyHelper(@TCUSTOMCOMBOBOXSELLENGTH_R, @TCUSTOMCOMBOBOXSELLENGTH_W, 'SELLENGTH');
    RegisterPropertyHelper(@TCUSTOMCOMBOBOXSELSTART_R, @TCUSTOMCOMBOBOXSELSTART_W, 'SELSTART');
    RegisterPropertyHelper(@TCUSTOMCOMBOBOXSELTEXT_R, @TCUSTOMCOMBOBOXSELTEXT_W, 'SELTEXT');
    {$ENDIF}
  end;
end;


procedure RIRegisterTCOMBOBOX(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TCOMBOBOX);
end;


procedure RIRegisterTBUTTONCONTROL(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TBUTTONCONTROL) do
    RegisterConstructor(@TBUTTONCONTROL.Create, 'Create');

end;

procedure TButtoncolor_R(Self: TButton; var T: TColor);
 begin //T:= Self.Color;
 end;


procedure RIRegisterTBUTTON(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TBUTTON) do begin
   RegisterMethod(@TButton.Click, 'Click');
   RegisterConstructor(@TButton.Create, 'Create');
   //RegisterPropertyHelper(@TButtonColor_R, @TButtonColor_W, 'Color');
   RegisterMethod(@TButton.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
  end;
end;




procedure RIRegisterTCUSTOMCHECKBOX(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMCHECKBOX) do begin
    RegisterConstructor(@TCUSTOMCHECKBOX.Create, 'Create');
   RegisterMethod(@TCUSTOMCHECKBOX.GetControlsAlignment, 'GetControlsAlignment');
  end;
end;


procedure RIRegisterTCHECKBOX(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TCHECKBOX);
end;


procedure RIRegisterTRADIOBUTTON(Cl: TPSRuntimeClassImporter);
begin
 with Cl.Add(TRADIOBUTTON) do begin
      RegisterConstructor(@TRADIOBUTTON.Create, 'Create');
   RegisterMethod(@TRADIOBUTTON.GetControlsAlignment, 'GetControlsAlignment');
end;
end;

procedure TCUSTOMLISTBOXCANVAS_R(Self: TCUSTOMLISTBOX; var T: TCANVAS); begin T := Self.CANVAS; end;
procedure TCUSTOMLISTBOXITEMS_R(Self: TCUSTOMLISTBOX; var T: TSTRINGS); begin T := Self.ITEMS; end;
procedure TCUSTOMLISTBOXITEMS_W(Self: TCUSTOMLISTBOX; T: TSTRINGS); begin Self.ITEMS := T; end;
procedure TCUSTOMLISTBOXITEMINDEX_R(Self: TCUSTOMLISTBOX; var T: INTEGER); begin T := Self.ITEMINDEX; end;
procedure TCUSTOMLISTBOXITEMINDEX_W(Self: TCUSTOMLISTBOX; T: INTEGER); begin Self.ITEMINDEX := T; end;
procedure TCUSTOMLISTBOXSELCOUNT_R(Self: TCUSTOMLISTBOX; var T: INTEGER); begin T := Self.SELCOUNT; end;
procedure TCUSTOMLISTBOXSELECTED_R(Self: TCUSTOMLISTBOX; var T: BOOLEAN; t1: INTEGER); begin T := Self.SELECTED[t1]; end;
procedure TCUSTOMLISTBOXSELECTED_W(Self: TCUSTOMLISTBOX; T: BOOLEAN; t1: INTEGER); begin Self.SELECTED[t1] := T; end;
procedure TCUSTOMLISTBOXTOPINDEX_R(Self: TCUSTOMLISTBOX; var T: INTEGER); begin T := Self.TOPINDEX; end;
procedure TCUSTOMLISTBOXTOPINDEX_W(Self: TCUSTOMLISTBOX; T: INTEGER); begin Self.TOPINDEX := T; end;
procedure TCUSTOMLISTBOXSwidth_R(Self: TCUSTOMLISTBOX; var T: INTEGER); begin T := Self.ScrollWidth; end;
procedure TCUSTOMLISTBOXSwidth_W(Self: TCUSTOMLISTBOX; T: INTEGER); begin Self.ScrollWidth := T; end;


procedure RIRegisterTCUSTOMLISTBOX(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMLISTBOX) do
  begin
    RegisterPropertyHelper(@TCUSTOMLISTBOXITEMS_R, @TCUSTOMLISTBOXITEMS_W, 'ITEMS');
    RegisterPropertyHelper(@TCUSTOMLISTBOXITEMINDEX_R, @TCUSTOMLISTBOXITEMINDEX_W, 'ITEMINDEX');
    RegisterPropertyHelper(@TCUSTOMLISTBOXSELCOUNT_R, nil, 'SELCOUNT');
    RegisterPropertyHelper(@TCUSTOMLISTBOXSELECTED_R, @TCUSTOMLISTBOXSELECTED_W, 'SELECTED');
  {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TCUSTOMLISTBOX.CLEAR, 'CLEAR');
    RegisterMethod(@TCUSTOMLISTBOX.ITEMATPOS, 'ITEMATPOS');
    RegisterMethod(@TCUSTOMLISTBOX.ITEMRECT, 'ITEMRECT');

    RegisterConstructor(@TCUSTOMLISTBOX.Create, 'Create');
  RegisterMethod(@TCUSTOMLISTBOX.Free, 'Free');
  RegisterMethod(@TCUSTOMLISTBOX.CLEARSelection, 'CLEARSelection');
  RegisterMethod(@TCUSTOMLISTBOX.DeleteSelected, 'DeleteSelected');
  RegisterMethod(@TCUSTOMLISTBOX.SelectAll, 'SelectAll');
  RegisterMethod(@TCUSTOMLISTBOX.AddItem, 'AddItem');
   RegisterPropertyHelper(@TCUSTOMLISTBOXCANVAS_R, nil, 'CANVAS');
    RegisterPropertyHelper(@TCUSTOMLISTBOXTOPINDEX_R, @TCUSTOMLISTBOXTOPINDEX_W, 'TOPINDEX');
    RegisterPropertyHelper(@TCUSTOMLISTBOXSWidth_R, @TCUSTOMLISTBOXSWidth_W, 'ScrollWidth');
    {$ENDIF}
  end;
end;


procedure RIRegisterTLISTBOX(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TLISTBOX);
end;


procedure RIRegisterTSCROLLBAR(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TSCROLLBAR) do begin
   RegisterConstructor(@TSCROLLBAR.Create, 'Create');
   RegisterMethod(@TSCROLLBAR.SETPARAMS, 'SETPARAMS');
  end;
end;


procedure RIRegister_stdctrls(cl: TPSRuntimeClassImporter);
begin
  {$IFNDEF PS_MINIVCL}
  RIRegisterTCUSTOMGROUPBOX(Cl);
  RIRegisterTGROUPBOX(Cl);
  {$ENDIF}
  RIRegisterTCUSTOMLABEL(Cl);
  RIRegisterTLABEL(Cl);
  RIRegisterTCUSTOMEDIT(Cl);
  RIRegisterTEDIT(Cl);
  RIRegisterTCUSTOMMEMO(Cl);
  RIRegisterTMEMO(Cl);
  RIRegisterTCUSTOMCOMBOBOX(Cl);
  RIRegisterTCOMBOBOX(Cl);
  RIRegisterTBUTTONCONTROL(Cl);
  RIRegisterTBUTTON(Cl);
  RIRegisterTCUSTOMCHECKBOX(Cl);
  RIRegisterTCHECKBOX(Cl);
  RIRegisterTRADIOBUTTON(Cl);
  RIRegisterTCUSTOMLISTBOX(Cl);
  RIRegisterTLISTBOX(Cl);
  RIRegister_TCustomStaticText(CL);
  RIRegister_TStaticText(CL);
  RIRegister_TCustomComboBoxStrings(CL);

  {$IFNDEF PS_MINIVCL}
  RIRegisterTSCROLLBAR(Cl);
  {$ENDIF}
end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.


