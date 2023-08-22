unit uPSI_CPortCtl;
{
  for arduino    //OnChange := @ccbComPortListChange is missing
TComComboBox.create(frmmain)
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
  TPSImport_CPortCtl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TComTerminal(CL: TPSPascalCompiler);
procedure SIRegister_TCustomComTerminal(CL: TPSPascalCompiler);
procedure SIRegister_TComTermBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TComLed(CL: TPSPascalCompiler);
procedure SIRegister_TComRadioGroup(CL: TPSPascalCompiler);
procedure SIRegister_TComComboBox(CL: TPSPascalCompiler);
procedure SIRegister_TComSelect(CL: TPSPascalCompiler);
procedure SIRegister_CPortCtl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TComTerminal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomComTerminal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComTermBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComLed(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComRadioGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComComboBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TComSelect(CL: TPSRuntimeClassImporter);
procedure RIRegister_CPortCtl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,StdCtrls
  //,ExtCtrls
  ,Forms
  //,Messages
  ,Graphics
  //,Windows
  ,CPort
  ,CPortEsc
  ,CPortCtl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CPortCtl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComTerminal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComTerminal', 'TComTerminal') do
  with CL.AddClassN(CL.FindClass('TCustomComTerminal'),'TComTerminal') do begin
    RegisterPublishedProperties;
     RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
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
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
    RegisterProperty('Parent', 'TWinControl', iptrw);
      RegisterProperty('Canvas', 'TCanvas', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomComTerminal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomComTerminal') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomComTerminal') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ClearScreen');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure MoveCaret( AColumn, ARow : Integer)');
    RegisterMethod('Procedure Write( const Buffer : string; Size : Integer)');
    RegisterMethod('Procedure WriteStr( const Str : string)');
    RegisterMethod('Procedure WriteEscCode( ACode : TEscapeCode; AParams : TStrings)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure SelectFont');
    RegisterMethod('Procedure ShowSetupDialog');
    RegisterProperty('AltColor', 'TColor', iptrw);
    RegisterProperty('AppendLF', 'Boolean', iptrw);
    RegisterProperty('ArrowKeys', 'TArrowKeys', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('Caret', 'TTermCaret', iptrw);
    RegisterProperty('Connected', 'Boolean', iptrw);
    RegisterProperty('ComPort', 'TCustomComPort', iptrw);
    RegisterProperty('Columns', 'Integer', iptrw);
    RegisterProperty('Emulation', 'TTermEmulation', iptrw);
    RegisterProperty('EscapeCodes', 'TEscapeCodes', iptr);
    RegisterProperty('Force7Bit', 'Boolean', iptrw);
    RegisterProperty('LocalEcho', 'Boolean', iptrw);
    RegisterProperty('SendLF', 'Boolean', iptrw);
    RegisterProperty('ScrollBars', 'TScrollStyle', iptrw);
    RegisterProperty('SmoothScroll', 'Boolean', iptrw);
    RegisterProperty('Rows', 'Integer', iptrw);
    RegisterProperty('WantTab', 'Boolean', iptrw);
    RegisterProperty('WrapLines', 'Boolean', iptrw);
    RegisterProperty('OnChar', 'TChScreenEvent', iptrw);
    RegisterProperty('OnGetEscapeCodes', 'TEscapeEvent', iptrw);
    RegisterProperty('OnStrRecieved', 'TStrRecvEvent', iptrw);
    RegisterProperty('OnUnhandledCode', 'TUnhandledEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComTermBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TComTermBuffer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TComTermBuffer') do begin
    RegisterMethod('Constructor Create( AOwner : TCustomComTerminal)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Init');
    RegisterMethod('Procedure SetChar( Column, Row : Integer; TermChar : TComTermChar)');
    RegisterMethod('Function GetChar( Column, Row : Integer) : TComTermChar');
    RegisterMethod('Procedure SetTab( Column : Integer; Put : Boolean)');
    RegisterMethod('Function GetTab( Column : Integer) : Boolean');
    RegisterMethod('Function NextTab( Column : Integer) : Integer');
    RegisterMethod('Procedure ClearAllTabs');
    RegisterMethod('Procedure ScrollDown');
    RegisterMethod('Procedure ScrollUp');
    RegisterMethod('Procedure EraseScreen( Column, Row : Integer)');
    RegisterMethod('Procedure EraseLine( Column, Row : Integer)');
    RegisterMethod('Function GetLineLength( Line : Integer) : Integer');
    RegisterMethod('Function GetLastLine : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComLed(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TComLed') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TComLed') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('ComPort', 'TComPort', iptrw);
    RegisterProperty('LedSignal', 'TComLedSignal', iptrw);
    RegisterProperty('Kind', 'TLedKind', iptrw);
    RegisterProperty('GlyphOn', 'TLedBitmap', iptrw);
    RegisterProperty('GlyphOff', 'TLedBitmap', iptrw);
    RegisterProperty('State', 'TLedState', iptrw);
    RegisterProperty('RingDuration', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TLedStateEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComRadioGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRadioGroup', 'TComRadioGroup') do
  with CL.AddClassN(CL.FindClass('TCustomRadioGroup'),'TComRadioGroup') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ApplySettings');
    RegisterMethod('Procedure UpdateSettings');
    RegisterProperty('ComPort', 'TCustomComPort', iptrw);
    RegisterProperty('ComProperty', 'TComProperty', iptrw);
    RegisterProperty('AutoApply', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComComboBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComboBox', 'TComComboBox') do
  with CL.AddClassN(CL.FindClass('TCustomComboBox'),'TComComboBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ApplySettings');
    RegisterMethod('Procedure UpdateSettings');
    RegisterProperty('ComPort', 'TCustomComPort', iptrw);
    RegisterProperty('ComProperty', 'TComProperty', iptrw);
    RegisterProperty('AutoApply', 'Boolean', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ONCHANGE', 'TNOTIFYEVENT', iptrw);
      RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
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
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
    RegisterProperty('Parent', 'TWinControl', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComSelect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TComSelect') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TComSelect') do begin
    RegisterMethod('Procedure SelectPort');
    RegisterMethod('Procedure SelectBaudRate');
    RegisterMethod('Procedure SelectParity');
    RegisterMethod('Procedure SelectStopBits');
    RegisterMethod('Procedure SelectDataBits');
    RegisterMethod('Procedure SelectFlowControl');
    RegisterMethod('Procedure Change( const Text : string)');
    RegisterMethod('Procedure UpdateSettings( var ItemIndex : Integer)');
    RegisterMethod('Procedure ApplySettings');
    RegisterProperty('Items', 'TStrings', iptrw);
    RegisterProperty('ComProperty', 'TComProperty', iptrw);
    RegisterProperty('ComPort', 'TCustomComPort', iptrw);
    RegisterProperty('AutoApply', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CPortCtl(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TComProperty', '( cpNone, cpPort, cpBaudRate, cpDataBits, cpStop'
   +'Bits, cpParity, cpFlowControl )');
  SIRegister_TComSelect(CL);
  SIRegister_TComComboBox(CL);
  SIRegister_TComRadioGroup(CL);
  CL.AddTypeS('TLedBitmap', 'TBitmap');
  CL.AddTypeS('TLedKind', '( lkRedLight, lkGreenLight, lkBlueLight, lkYellowLig'
   +'ht, lkPurpleLight, lkBulb, lkCustom )');
  CL.AddTypeS('TComLedSignal', '( lsConn, lsCTS, lsDSR, lsRLSD, lsRing, lsRx, lsTx )');
  CL.AddTypeS('TLedState', '( lsOff, lsOn )');
  CL.AddTypeS('TLedStateEvent', 'Procedure ( Sender : TObject; AState : TLedState)');
  SIRegister_TComLed(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomComTerminal');
  CL.AddTypeS('TComTermChar', 'record Ch : Char; FrontColor : TColor; BackColor: TColor; Underline : Boolean; end');
  SIRegister_TComTermBuffer(CL);
  CL.AddTypeS('TTermEmulation', '( teVT100orANSI, teVT52, teNone )');
  CL.AddTypeS('TTermCaret', '( tcBlock, tcUnderline, tcNone )');
  CL.AddTypeS('TAdvanceCaret', '( acChar, acReturn, acLineFeed, acReverseLineFeed, acTab, acBackspace, acPage )');
  CL.AddTypeS('TArrowKeys', '( akTerminal, akWindows )');
  CL.AddTypeS('TTermAttributes', 'record FrontColor : TColor; BackColor : TColo'
   +'r; Invert : Boolean; AltIntensity : Boolean; Underline : Boolean; end');
  CL.AddTypeS('TTermMode', 'record Keys : TArrowKeys; end');
  CL.AddTypeS('TEscapeEvent', 'Procedure ( Sender : TObject; var EscapeCodes : TEscapeCodes)');
  CL.AddTypeS('TUnhandledEvent', 'Procedure ( Sender : TObject; Code : TEscapeCode; Data : string)');
  CL.AddTypeS('TStrRecvEvent', 'Procedure ( Sender : TObject; var Str : string)');
  CL.AddTypeS('TChScreenEvent', 'Procedure ( Sender : TObject; Ch : Char)');
  SIRegister_TCustomComTerminal(CL);
  SIRegister_TComTerminal(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnUnhandledCode_W(Self: TCustomComTerminal; const T: TUnhandledEvent);
begin Self.OnUnhandledCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnUnhandledCode_R(Self: TCustomComTerminal; var T: TUnhandledEvent);
begin T := Self.OnUnhandledCode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnStrRecieved_W(Self: TCustomComTerminal; const T: TStrRecvEvent);
begin Self.OnStrRecieved := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnStrRecieved_R(Self: TCustomComTerminal; var T: TStrRecvEvent);
begin T := Self.OnStrRecieved; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnGetEscapeCodes_W(Self: TCustomComTerminal; const T: TEscapeEvent);
begin Self.OnGetEscapeCodes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnGetEscapeCodes_R(Self: TCustomComTerminal; var T: TEscapeEvent);
begin T := Self.OnGetEscapeCodes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnChar_W(Self: TCustomComTerminal; const T: TChScreenEvent);
begin Self.OnChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalOnChar_R(Self: TCustomComTerminal; var T: TChScreenEvent);
begin T := Self.OnChar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalWrapLines_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.WrapLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalWrapLines_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.WrapLines; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalWantTab_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.WantTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalWantTab_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.WantTab; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalRows_W(Self: TCustomComTerminal; const T: Integer);
begin Self.Rows := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalRows_R(Self: TCustomComTerminal; var T: Integer);
begin T := Self.Rows; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalSmoothScroll_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.SmoothScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalSmoothScroll_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.SmoothScroll; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalScrollBars_W(Self: TCustomComTerminal; const T: TScrollStyle);
begin Self.ScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalScrollBars_R(Self: TCustomComTerminal; var T: TScrollStyle);
begin T := Self.ScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalSendLF_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.SendLF := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalSendLF_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.SendLF; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalLocalEcho_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.LocalEcho := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalLocalEcho_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.LocalEcho; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalForce7Bit_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.Force7Bit := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalForce7Bit_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.Force7Bit; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalEscapeCodes_R(Self: TCustomComTerminal; var T: TEscapeCodes);
begin T := Self.EscapeCodes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalEmulation_W(Self: TCustomComTerminal; const T: TTermEmulation);
begin Self.Emulation := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalEmulation_R(Self: TCustomComTerminal; var T: TTermEmulation);
begin T := Self.Emulation; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalColumns_W(Self: TCustomComTerminal; const T: Integer);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalColumns_R(Self: TCustomComTerminal; var T: Integer);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalComPort_W(Self: TCustomComTerminal; const T: TCustomComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalComPort_R(Self: TCustomComTerminal; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalConnected_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.Connected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalConnected_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalCaret_W(Self: TCustomComTerminal; const T: TTermCaret);
begin Self.Caret := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalCaret_R(Self: TCustomComTerminal; var T: TTermCaret);
begin T := Self.Caret; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalBorderStyle_W(Self: TCustomComTerminal; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalBorderStyle_R(Self: TCustomComTerminal; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalArrowKeys_W(Self: TCustomComTerminal; const T: TArrowKeys);
begin Self.ArrowKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalArrowKeys_R(Self: TCustomComTerminal; var T: TArrowKeys);
begin T := Self.ArrowKeys; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalAppendLF_W(Self: TCustomComTerminal; const T: Boolean);
begin Self.AppendLF := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalAppendLF_R(Self: TCustomComTerminal; var T: Boolean);
begin T := Self.AppendLF; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalAltColor_W(Self: TCustomComTerminal; const T: TColor);
begin Self.AltColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomComTerminalAltColor_R(Self: TCustomComTerminal; var T: TColor);
begin T := Self.AltColor; end;

(*----------------------------------------------------------------------------*)
procedure TComLedOnChange_W(Self: TComLed; const T: TLedStateEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedOnChange_R(Self: TComLed; var T: TLedStateEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TComLedRingDuration_W(Self: TComLed; const T: Integer);
begin Self.RingDuration := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedRingDuration_R(Self: TComLed; var T: Integer);
begin T := Self.RingDuration; end;

(*----------------------------------------------------------------------------*)
procedure TComLedState_W(Self: TComLed; const T: TLedState);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedState_R(Self: TComLed; var T: TLedState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TComLedGlyphOff_W(Self: TComLed; const T: TLedBitmap);
begin Self.GlyphOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedGlyphOff_R(Self: TComLed; var T: TLedBitmap);
begin T := Self.GlyphOff; end;

(*----------------------------------------------------------------------------*)
procedure TComLedGlyphOn_W(Self: TComLed; const T: TLedBitmap);
begin Self.GlyphOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedGlyphOn_R(Self: TComLed; var T: TLedBitmap);
begin T := Self.GlyphOn; end;

(*----------------------------------------------------------------------------*)
procedure TComLedKind_W(Self: TComLed; const T: TLedKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedKind_R(Self: TComLed; var T: TLedKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TComLedLedSignal_W(Self: TComLed; const T: TComLedSignal);
begin Self.LedSignal := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedLedSignal_R(Self: TComLed; var T: TComLedSignal);
begin T := Self.LedSignal; end;

(*----------------------------------------------------------------------------*)
procedure TComLedComPort_W(Self: TComLed; const T: TComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TComLedComPort_R(Self: TComLed; var T: TComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComRadioGroupAutoApply_W(Self: TComRadioGroup; const T: Boolean);
begin Self.AutoApply := T; end;

(*----------------------------------------------------------------------------*)
procedure TComRadioGroupAutoApply_R(Self: TComRadioGroup; var T: Boolean);
begin T := Self.AutoApply; end;

(*----------------------------------------------------------------------------*)
procedure TComRadioGroupComProperty_W(Self: TComRadioGroup; const T: TComProperty);
begin Self.ComProperty := T; end;

(*----------------------------------------------------------------------------*)
procedure TComRadioGroupComProperty_R(Self: TComRadioGroup; var T: TComProperty);
begin T := Self.ComProperty; end;

(*----------------------------------------------------------------------------*)
procedure TComRadioGroupComPort_W(Self: TComRadioGroup; const T: TCustomComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TComRadioGroupComPort_R(Self: TComRadioGroup; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxText_W(Self: TComComboBox; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxText_R(Self: TComComboBox; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxAutoApply_W(Self: TComComboBox; const T: Boolean);
begin Self.AutoApply := T; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxAutoApply_R(Self: TComComboBox; var T: Boolean);
begin T := Self.AutoApply; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxComProperty_W(Self: TComComboBox; const T: TComProperty);
begin Self.ComProperty := T; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxComProperty_R(Self: TComComboBox; var T: TComProperty);
begin T := Self.ComProperty; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxComPort_W(Self: TComComboBox; const T: TCustomComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TComComboBoxComPort_R(Self: TComComboBox; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectAutoApply_W(Self: TComSelect; const T: Boolean);
begin Self.AutoApply := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectAutoApply_R(Self: TComSelect; var T: Boolean);
begin T := Self.AutoApply; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectComPort_W(Self: TComSelect; const T: TCustomComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectComPort_R(Self: TComSelect; var T: TCustomComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectComProperty_W(Self: TComSelect; const T: TComProperty);
begin Self.ComProperty := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectComProperty_R(Self: TComSelect; var T: TComProperty);
begin T := Self.ComProperty; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectItems_W(Self: TComSelect; const T: TStrings);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectItems_R(Self: TComSelect; var T: TStrings);
begin T := Self.Items; end;

procedure TControlParentR(Self: TControl; var T: TWinControl); begin T := Self.Parent; end;
procedure TControlParentW(Self: TControl; T: TWinControl); begin Self.Parent:= T; end;

//procedure TBitmapCanvas_R(Self: TComTerminal; var T: TCanvas); begin T:= Self.Canvas; end;

//procedure TBitmapCanvas2_R(Self: TCustomDrawGrid; var T: TCanvas); begin T:= Self.Canvas; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TComTerminal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComTerminal) do begin

    RegisterPropertyHelper(@TControlParentR, @TControlParentW, 'PARENT');
    //RegisterPropertyHelper(@TBitmapCanvas_R,nil,'Canvas');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomComTerminal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomComTerminal) do begin
    RegisterConstructor(@TCustomComTerminal.Create, 'Create');
   RegisterMethod(@TCustomComTerminal.Destroy, 'Free');
    RegisterMethod(@TCustomComTerminal.ClearScreen, 'ClearScreen');
    RegisterMethod(@TCustomComTerminal.MoveCaret, 'MoveCaret');
    RegisterMethod(@TCustomComTerminal.Write, 'Write');
    RegisterMethod(@TCustomComTerminal.WriteStr, 'WriteStr');
    RegisterMethod(@TCustomComTerminal.WriteEscCode, 'WriteEscCode');
    RegisterMethod(@TCustomComTerminal.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TCustomComTerminal.SaveToStream, 'SaveToStream');
    RegisterMethod(@TCustomComTerminal.SelectFont, 'SelectFont');
    RegisterMethod(@TCustomComTerminal.ShowSetupDialog, 'ShowSetupDialog');
    RegisterPropertyHelper(@TCustomComTerminalAltColor_R,@TCustomComTerminalAltColor_W,'AltColor');
    RegisterPropertyHelper(@TCustomComTerminalAppendLF_R,@TCustomComTerminalAppendLF_W,'AppendLF');
    RegisterPropertyHelper(@TCustomComTerminalArrowKeys_R,@TCustomComTerminalArrowKeys_W,'ArrowKeys');
    RegisterPropertyHelper(@TCustomComTerminalBorderStyle_R,@TCustomComTerminalBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TCustomComTerminalCaret_R,@TCustomComTerminalCaret_W,'Caret');
    RegisterPropertyHelper(@TCustomComTerminalConnected_R,@TCustomComTerminalConnected_W,'Connected');
    RegisterPropertyHelper(@TCustomComTerminalComPort_R,@TCustomComTerminalComPort_W,'ComPort');
    RegisterPropertyHelper(@TCustomComTerminalColumns_R,@TCustomComTerminalColumns_W,'Columns');
    RegisterPropertyHelper(@TCustomComTerminalEmulation_R,@TCustomComTerminalEmulation_W,'Emulation');
    RegisterPropertyHelper(@TCustomComTerminalEscapeCodes_R,nil,'EscapeCodes');
    RegisterPropertyHelper(@TCustomComTerminalForce7Bit_R,@TCustomComTerminalForce7Bit_W,'Force7Bit');
    RegisterPropertyHelper(@TCustomComTerminalLocalEcho_R,@TCustomComTerminalLocalEcho_W,'LocalEcho');
    RegisterPropertyHelper(@TCustomComTerminalSendLF_R,@TCustomComTerminalSendLF_W,'SendLF');
    RegisterPropertyHelper(@TCustomComTerminalScrollBars_R,@TCustomComTerminalScrollBars_W,'ScrollBars');
    RegisterPropertyHelper(@TCustomComTerminalSmoothScroll_R,@TCustomComTerminalSmoothScroll_W,'SmoothScroll');
    RegisterPropertyHelper(@TCustomComTerminalRows_R,@TCustomComTerminalRows_W,'Rows');
    RegisterPropertyHelper(@TCustomComTerminalWantTab_R,@TCustomComTerminalWantTab_W,'WantTab');
    RegisterPropertyHelper(@TCustomComTerminalWrapLines_R,@TCustomComTerminalWrapLines_W,'WrapLines');
    RegisterPropertyHelper(@TCustomComTerminalOnChar_R,@TCustomComTerminalOnChar_W,'OnChar');
    RegisterPropertyHelper(@TCustomComTerminalOnGetEscapeCodes_R,@TCustomComTerminalOnGetEscapeCodes_W,'OnGetEscapeCodes');
    RegisterPropertyHelper(@TCustomComTerminalOnStrRecieved_R,@TCustomComTerminalOnStrRecieved_W,'OnStrRecieved');
    RegisterPropertyHelper(@TCustomComTerminalOnUnhandledCode_R,@TCustomComTerminalOnUnhandledCode_W,'OnUnhandledCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComTermBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComTermBuffer) do begin
    RegisterConstructor(@TComTermBuffer.Create, 'Create');
    RegisterMethod(@TComTermBuffer.Destroy, 'Free');
    RegisterMethod(@TComTermBuffer.Init, 'Init');
    RegisterMethod(@TComTermBuffer.SetChar, 'SetChar');
    RegisterMethod(@TComTermBuffer.GetChar, 'GetChar');
    RegisterMethod(@TComTermBuffer.SetTab, 'SetTab');
    RegisterMethod(@TComTermBuffer.GetTab, 'GetTab');
    RegisterMethod(@TComTermBuffer.NextTab, 'NextTab');
    RegisterMethod(@TComTermBuffer.ClearAllTabs, 'ClearAllTabs');
    RegisterMethod(@TComTermBuffer.ScrollDown, 'ScrollDown');
    RegisterMethod(@TComTermBuffer.ScrollUp, 'ScrollUp');
    RegisterMethod(@TComTermBuffer.EraseScreen, 'EraseScreen');
    RegisterMethod(@TComTermBuffer.EraseLine, 'EraseLine');
    RegisterMethod(@TComTermBuffer.GetLineLength, 'GetLineLength');
    RegisterMethod(@TComTermBuffer.GetLastLine, 'GetLastLine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComLed(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComLed) do begin
    RegisterConstructor(@TComLed.Create, 'Create');
   RegisterMethod(@TComLed.Destroy, 'Free');
    RegisterPropertyHelper(@TComLedComPort_R,@TComLedComPort_W,'ComPort');
    RegisterPropertyHelper(@TComLedLedSignal_R,@TComLedLedSignal_W,'LedSignal');
    RegisterPropertyHelper(@TComLedKind_R,@TComLedKind_W,'Kind');
    RegisterPropertyHelper(@TComLedGlyphOn_R,@TComLedGlyphOn_W,'GlyphOn');
    RegisterPropertyHelper(@TComLedGlyphOff_R,@TComLedGlyphOff_W,'GlyphOff');
    RegisterPropertyHelper(@TComLedState_R,@TComLedState_W,'State');
    RegisterPropertyHelper(@TComLedRingDuration_R,@TComLedRingDuration_W,'RingDuration');
    RegisterPropertyHelper(@TComLedOnChange_R,@TComLedOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComRadioGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComRadioGroup) do begin
    RegisterConstructor(@TComRadioGroup.Create, 'Create');
   RegisterMethod(@TComRadioGroup.Destroy, 'Free');
   RegisterMethod(@TComRadioGroup.ApplySettings, 'ApplySettings');
    RegisterMethod(@TComRadioGroup.UpdateSettings, 'UpdateSettings');
    RegisterPropertyHelper(@TComRadioGroupComPort_R,@TComRadioGroupComPort_W,'ComPort');
    RegisterPropertyHelper(@TComRadioGroupComProperty_R,@TComRadioGroupComProperty_W,'ComProperty');
    RegisterPropertyHelper(@TComRadioGroupAutoApply_R,@TComRadioGroupAutoApply_W,'AutoApply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComComboBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComComboBox) do begin
    RegisterConstructor(@TComComboBox.Create, 'Create');
    RegisterMethod(@TComComboBox.Destroy, 'Free');
    RegisterMethod(@TComComboBox.ApplySettings, 'ApplySettings');
    RegisterMethod(@TComComboBox.UpdateSettings, 'UpdateSettings');
    RegisterPropertyHelper(@TComComboBoxComPort_R,@TComComboBoxComPort_W,'ComPort');
    RegisterPropertyHelper(@TComComboBoxComProperty_R,@TComComboBoxComProperty_W,'ComProperty');
    RegisterPropertyHelper(@TComComboBoxAutoApply_R,@TComComboBoxAutoApply_W,'AutoApply');
    RegisterPropertyHelper(@TComComboBoxText_R,@TComComboBoxText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComSelect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComSelect) do begin
    RegisterMethod(@TComSelect.SelectPort, 'SelectPort');
    RegisterMethod(@TComSelect.SelectBaudRate, 'SelectBaudRate');
    RegisterMethod(@TComSelect.SelectParity, 'SelectParity');
    RegisterMethod(@TComSelect.SelectStopBits, 'SelectStopBits');
    RegisterMethod(@TComSelect.SelectDataBits, 'SelectDataBits');
    RegisterMethod(@TComSelect.SelectFlowControl, 'SelectFlowControl');
    RegisterMethod(@TComSelect.Change, 'Change');
    RegisterMethod(@TComSelect.UpdateSettings, 'UpdateSettings');
    RegisterMethod(@TComSelect.ApplySettings, 'ApplySettings');
    RegisterPropertyHelper(@TComSelectItems_R,@TComSelectItems_W,'Items');
    RegisterPropertyHelper(@TComSelectComProperty_R,@TComSelectComProperty_W,'ComProperty');
    RegisterPropertyHelper(@TComSelectComPort_R,@TComSelectComPort_W,'ComPort');
    RegisterPropertyHelper(@TComSelectAutoApply_R,@TComSelectAutoApply_W,'AutoApply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CPortCtl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TComSelect(CL);
  RIRegister_TComComboBox(CL);
  RIRegister_TComRadioGroup(CL);
  RIRegister_TComLed(CL);
  with CL.Add(TCustomComTerminal) do
  RIRegister_TComTermBuffer(CL);
  RIRegister_TCustomComTerminal(CL);
  RIRegister_TComTerminal(CL);
end;

 
 
{ TPSImport_CPortCtl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortCtl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CPortCtl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CPortCtl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CPortCtl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
