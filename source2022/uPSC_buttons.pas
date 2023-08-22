{ Compiletime Buttons support }
unit uPSC_buttons;
{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{
  Will register files from:
    Buttons
 
  Requires
      STD, classes, controls and graphics and StdCtrls    , add function
}
procedure SIRegister_Buttons_TypesAndConsts(Cl: TPSPascalCompiler);

procedure SIRegisterTSPEEDBUTTON(Cl: TPSPascalCompiler);
procedure SIRegisterTBITBTN(Cl: TPSPascalCompiler);
procedure SIRegister_TBitBtnActionLink(CL: TPSPascalCompiler);


procedure SIRegister_Buttons(Cl: TPSPascalCompiler);

implementation

procedure SIRegisterTSPEEDBUTTON(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TSPEEDBUTTON') do begin
      RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Click');
      RegisterPublishedProperties;
   RegisterProperty('ALLOWALLUP', 'BOOLEAN', iptrw);
    RegisterProperty('GROUPINDEX', 'INTEGER', iptrw);
    RegisterProperty('DOWN', 'BOOLEAN', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('GLYPH', 'TBITMAP', iptrw);
    RegisterProperty('LAYOUT', 'TBUTTONLAYOUT', iptrw);
    RegisterProperty('MARGIN', 'INTEGER', iptrw);
    RegisterProperty('NUMGLYPHS', 'BYTE', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('SPACING', 'INTEGER', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

procedure SIRegisterTBITBTN(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TBUTTON'), 'TBITBTN') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Click');
    RegisterPublishedProperties;
    RegisterProperty('GLYPH', 'TBITMAP', iptrw);
    RegisterProperty('KIND', 'TBITBTNKIND', iptrw);
    RegisterProperty('LAYOUT', 'TBUTTONLAYOUT', iptrw);
    RegisterProperty('MARGIN', 'INTEGER', iptrw);
    RegisterProperty('NUMGLYPHS', 'BYTE', iptrw);
    RegisterProperty('STYLE', 'TBUTTONSTYLE', iptrw);
    RegisterProperty('SPACING', 'INTEGER', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitBtnActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TControlActionLink', 'TBitBtnActionLink') do
  with CL.AddClassN(CL.FindClass('TControlActionLink'),'TBitBtnActionLink') do begin
    RegisterMethod('Constructor Create(AClient: TObject);');
  end;
end;




procedure SIRegister_Buttons_TypesAndConsts(Cl: TPSPascalCompiler);
begin
  Cl.AddTypeS('TButtonLayout', '(blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom)');
  Cl.AddTypeS('TButtonState', '(bsUp, bsDisabled, bsDown, bsExclusive)');
  Cl.AddTypeS('TButtonStyle', '(bsAutoDetect, bsWin31, bsNew)');
  Cl.AddTypeS('TBitBtnKind', '(bkCustom, bkOK, bkCancel, bkHelp, bkYes, bkNo, bkClose, bkAbort, bkRetry, bkIgnore, bkAll)');
  CL.AddTypeS('TNumGlyphs', 'Integer');


 CL.AddDelphiFunction('Function DrawButtonFace( Canvas : TCanvas; const Client : TRect; BevelWidth : Integer; Style : TButtonStyle; IsRounded, IsDown, IsFocused : Boolean) : TRect');

end;

procedure SIRegister_Buttons(Cl: TPSPascalCompiler);
begin
  SIRegister_Buttons_TypesAndConsts(cl);
  SIRegisterTSPEEDBUTTON(cl);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBitBtn');
  SIRegister_TBitBtnActionLink(CL);
   SIRegisterTBITBTN(cl);
end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.




