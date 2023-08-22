unit uPSI_JvExControls;
{
    another baseline
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
  TPSImport_JvExControls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvExPubGraphicControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvExHintWindow(CL: TPSPascalCompiler);
procedure SIRegister_TJvExGraphicControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvExCustomControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvExWinControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvExControl(CL: TPSPascalCompiler);
procedure SIRegister_TStructPtrMessage(CL: TPSPascalCompiler);
procedure SIRegister_IJvDenySubClassing(CL: TPSPascalCompiler);
procedure SIRegister_IJvExControl(CL: TPSPascalCompiler);
procedure SIRegister_JvExControls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvExPubGraphicControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvExHintWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvExGraphicControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvExCustomControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvExWinControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvExControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvExControls_Routines(S: TPSExec);
procedure RIRegister_TStructPtrMessage(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvExControls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Types
  ,Graphics
  ,Controls
  ,Forms
  //,JclUnitVersioning
  ,JvTypes
  //,JvThemes
  ,JVCLVer
  ,JvExControls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvExControls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvExPubGraphicControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvExGraphicControl', 'TJvExPubGraphicControl') do
  with CL.AddClassN(CL.FindClass('TJvExGraphicControl'),'TJvExPubGraphicControl') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvExHintWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THintWindow', 'TJvExHintWindow') do
  with CL.AddClassN(CL.FindClass('THintWindow'),'TJvExHintWindow') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('HintWindowClass', 'THintWindowClass', iptrw);
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('DotNetHighlighting', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvExGraphicControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvExGraphicControl') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvExGraphicControl') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('HintWindowClass', 'THintWindowClass', iptrw);
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvExCustomControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TJvExCustomControl') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TJvExCustomControl') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('HintWindowClass', 'THintWindowClass', iptrw);
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('DotNetHighlighting', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvExWinControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TJvExWinControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TJvExWinControl') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('HintWindowClass', 'THintWindowClass', iptrw);
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('DotNetHighlighting', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvExControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TControl', 'TJvExControl') do
  with CL.AddClassN(CL.FindClass('TControl'),'TJvExControl') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('HintWindowClass', 'THintWindowClass', iptrw);
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStructPtrMessage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStructPtrMessage') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStructPtrMessage') do
  begin
    RegisterProperty('Msg', 'TMessage', iptrw);
    RegisterMethod('Constructor Create( Msg : Integer; WParam : Integer; var LParam)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJvDenySubClassing(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IJvDenySubClassing') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJvDenySubClassing, 'IJvDenySubClassing') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJvExControl(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IJvExControl') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJvExControl, 'IJvExControl') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvExControls(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDlgCode', '( dcWantAllKeys, dcWantArrows, dcWantChars, dcButton'
   +', dcHasSetSel, dcWantTab, dcNative )');
  CL.AddTypeS('TDlgCodes', 'set of TDlgCode');
 //CL.AddConstantN('dcWantMessage','').SetString( dcWantAllKeys);
  SIRegister_IJvExControl(CL);
  SIRegister_IJvDenySubClassing(CL);
  SIRegister_TStructPtrMessage(CL);
 CL.AddDelphiFunction('Procedure SetDotNetFrameColors( FocusedColor, UnfocusedColor : TColor)');
 CL.AddDelphiFunction('Procedure DrawDotNetControl( Control : TWinControl; AColor : TColor; InControl : Boolean);');
 CL.AddDelphiFunction('Procedure DrawDotNetControl1( DC : HDC; R : TRect; AColor : TColor; UseFocusedColor : Boolean);');
 CL.AddDelphiFunction('Procedure HandleDotNetHighlighting( Control : TWinControl; const Msg : TMessage; MouseOver : Boolean; Color : TColor)');
 CL.AddDelphiFunction('Function CreateWMMessage( Msg : Integer; WParam : Integer; LParam : Longint) : TMessage;');
 CL.AddDelphiFunction('Function CreateWMMessage1( Msg : Integer; WParam : Integer; LParam : TControl) : TMessage;');
 CL.AddDelphiFunction('Function SmallPointToLong( const Pt : TSmallPoint) : Longint');
 CL.AddDelphiFunction('Function ShiftStateToKeyData( Shift : TShiftState) : Longint');
 CL.AddDelphiFunction('Function GetFocusedControl( AControl : TControl) : TWinControl');
 CL.AddDelphiFunction('Function DlgcToDlgCodes( Value : Longint) : TDlgCodes');
 CL.AddDelphiFunction('Function DlgCodesToDlgc( Value : TDlgCodes) : Longint');
 //CL.AddDelphiFunction('Procedure GetHintColor( var HintInfo : THintInfo; AControl : TControl; HintColor : TColor)');
 CL.AddDelphiFunction('Function DispatchIsDesignMsg( Control : TControl; var Msg : TMessage) : Boolean');
  SIRegister_TJvExControl(CL);
  SIRegister_TJvExWinControl(CL);
  SIRegister_TJvExCustomControl(CL);
  SIRegister_TJvExGraphicControl(CL);
  SIRegister_TJvExHintWindow(CL);
  SIRegister_TJvExPubGraphicControl(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvExHintWindowDotNetHighlighting_W(Self: TJvExHintWindow; const T: Boolean);
begin Self.DotNetHighlighting := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExHintWindowDotNetHighlighting_R(Self: TJvExHintWindow; var T: Boolean);
begin T := Self.DotNetHighlighting; end;

(*----------------------------------------------------------------------------*)
procedure TJvExHintWindowAboutJVCL_W(Self: TJvExHintWindow; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExHintWindowAboutJVCL_R(Self: TJvExHintWindow; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvExHintWindowHintWindowClass_W(Self: TJvExHintWindow; const T: THintWindowClass);
begin Self.HintWindowClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExHintWindowHintWindowClass_R(Self: TJvExHintWindow; var T: THintWindowClass);
begin T := Self.HintWindowClass; end;

(*----------------------------------------------------------------------------*)
Function TJvExHintWindowBaseWndProc9_P(Self: TJvExHintWindow;  Msg : Integer; WParam : Integer; LParam : TControl) : Integer;
Begin
//Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
Function TJvExHintWindowBaseWndProc8_P(Self: TJvExHintWindow;  Msg : Integer; WParam : Integer; LParam : Longint) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
procedure TJvExGraphicControlAboutJVCL_W(Self: TJvExGraphicControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExGraphicControlAboutJVCL_R(Self: TJvExGraphicControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvExGraphicControlHintWindowClass_W(Self: TJvExGraphicControl; const T: THintWindowClass);
begin Self.HintWindowClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExGraphicControlHintWindowClass_R(Self: TJvExGraphicControl; var T: THintWindowClass);
begin T := Self.HintWindowClass; end;

(*----------------------------------------------------------------------------*)
Function TJvExGraphicControlBaseWndProc7_P(Self: TJvExGraphicControl;  Msg : Integer; WParam : Integer; LParam : TControl) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
Function TJvExGraphicControlBaseWndProc6_P(Self: TJvExGraphicControl;  Msg : Integer; WParam : Integer; LParam : Longint) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
procedure TJvExCustomControlDotNetHighlighting_W(Self: TJvExCustomControl; const T: Boolean);
begin Self.DotNetHighlighting := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExCustomControlDotNetHighlighting_R(Self: TJvExCustomControl; var T: Boolean);
begin T := Self.DotNetHighlighting; end;

(*----------------------------------------------------------------------------*)
procedure TJvExCustomControlAboutJVCL_W(Self: TJvExCustomControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExCustomControlAboutJVCL_R(Self: TJvExCustomControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvExCustomControlHintWindowClass_W(Self: TJvExCustomControl; const T: THintWindowClass);
begin Self.HintWindowClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExCustomControlHintWindowClass_R(Self: TJvExCustomControl; var T: THintWindowClass);
begin T := Self.HintWindowClass; end;

(*----------------------------------------------------------------------------*)
Function TJvExCustomControlBaseWndProc5_P(Self: TJvExCustomControl;  Msg : Integer; WParam : Integer; LParam : TControl) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
Function TJvExCustomControlBaseWndProc4_P(Self: TJvExCustomControl;  Msg : Integer; WParam : Integer; LParam : Longint) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
procedure TJvExWinControlDotNetHighlighting_W(Self: TJvExWinControl; const T: Boolean);
begin Self.DotNetHighlighting := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExWinControlDotNetHighlighting_R(Self: TJvExWinControl; var T: Boolean);
begin T := Self.DotNetHighlighting; end;

(*----------------------------------------------------------------------------*)
procedure TJvExWinControlAboutJVCL_W(Self: TJvExWinControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExWinControlAboutJVCL_R(Self: TJvExWinControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvExWinControlHintWindowClass_W(Self: TJvExWinControl; const T: THintWindowClass);
begin Self.HintWindowClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExWinControlHintWindowClass_R(Self: TJvExWinControl; var T: THintWindowClass);
begin T := Self.HintWindowClass; end;

(*----------------------------------------------------------------------------*)
Function TJvExWinControlBaseWndProc3_P(Self: TJvExWinControl;  Msg : Integer; WParam : Integer; LParam : TControl) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);

END;

(*----------------------------------------------------------------------------*)
Function TJvExWinControlBaseWndProc2_P(Self: TJvExWinControl;  Msg : Integer; WParam : Integer; LParam : Longint) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
procedure TJvExControlAboutJVCL_W(Self: TJvExControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExControlAboutJVCL_R(Self: TJvExControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvExControlHintWindowClass_W(Self: TJvExControl; const T: THintWindowClass);
begin Self.HintWindowClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvExControlHintWindowClass_R(Self: TJvExControl; var T: THintWindowClass);
begin T := Self.HintWindowClass; end;

(*----------------------------------------------------------------------------*)
Function TJvExControlBaseWndProc1_P(Self: TJvExControl;  Msg : Integer; WParam : Integer; LParam : TControl) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
Function TJvExControlBaseWndProc_P(Self: TJvExControl;  Msg : Integer; WParam : Integer; LParam : Longint) : Integer;
Begin //Result := Self.BaseWndProc(Msg, WParam, LParam);
END;

(*----------------------------------------------------------------------------*)
Function CreateWMMessage1_P( Msg : Integer; WParam : Integer; LParam : TControl) : TMessage;
Begin Result := JvExControls.CreateWMMessage(Msg, WParam, LParam); END;

(*----------------------------------------------------------------------------*)
Function CreateWMMessage_P( Msg : Integer; WParam : Integer; LParam : Longint) : TMessage;
Begin Result := JvExControls.CreateWMMessage(Msg, WParam, LParam); END;

(*----------------------------------------------------------------------------*)
Procedure DrawDotNetControl1_P( DC : HDC; R : TRect; AColor : TColor; UseFocusedColor : Boolean);
Begin JvExControls.DrawDotNetControl(DC, R, AColor, UseFocusedColor); END;

(*----------------------------------------------------------------------------*)
Procedure DrawDotNetControl_P( Control : TWinControl; AColor : TColor; InControl : Boolean);
Begin JvExControls.DrawDotNetControl(Control, AColor, InControl); END;

(*----------------------------------------------------------------------------*)
procedure TStructPtrMessageMsg_W(Self: TStructPtrMessage; const T: TMessage);
Begin Self.Msg := T; end;

(*----------------------------------------------------------------------------*)
procedure TStructPtrMessageMsg_R(Self: TStructPtrMessage; var T: TMessage);
Begin T := Self.Msg; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvExPubGraphicControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvExPubGraphicControl) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvExHintWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvExHintWindow) do
  begin
    RegisterConstructor(@TJvExHintWindow.Create, 'Create');
    RegisterPropertyHelper(@TJvExHintWindowHintWindowClass_R,@TJvExHintWindowHintWindowClass_W,'HintWindowClass');
    RegisterPropertyHelper(@TJvExHintWindowAboutJVCL_R,@TJvExHintWindowAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvExHintWindowDotNetHighlighting_R,@TJvExHintWindowDotNetHighlighting_W,'DotNetHighlighting');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvExGraphicControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvExGraphicControl) do
  begin
    RegisterConstructor(@TJvExGraphicControl.Create, 'Create');
    RegisterPropertyHelper(@TJvExGraphicControlHintWindowClass_R,@TJvExGraphicControlHintWindowClass_W,'HintWindowClass');
    RegisterPropertyHelper(@TJvExGraphicControlAboutJVCL_R,@TJvExGraphicControlAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvExCustomControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvExCustomControl) do
  begin
    RegisterConstructor(@TJvExCustomControl.Create, 'Create');
    RegisterPropertyHelper(@TJvExCustomControlHintWindowClass_R,@TJvExCustomControlHintWindowClass_W,'HintWindowClass');
    RegisterPropertyHelper(@TJvExCustomControlAboutJVCL_R,@TJvExCustomControlAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvExCustomControlDotNetHighlighting_R,@TJvExCustomControlDotNetHighlighting_W,'DotNetHighlighting');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvExWinControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvExWinControl) do
  begin
    RegisterConstructor(@TJvExWinControl.Create, 'Create');
    RegisterPropertyHelper(@TJvExWinControlHintWindowClass_R,@TJvExWinControlHintWindowClass_W,'HintWindowClass');
    RegisterPropertyHelper(@TJvExWinControlAboutJVCL_R,@TJvExWinControlAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvExWinControlDotNetHighlighting_R,@TJvExWinControlDotNetHighlighting_W,'DotNetHighlighting');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvExControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvExControl) do
  begin
    RegisterConstructor(@TJvExControl.Create, 'Create');
    RegisterPropertyHelper(@TJvExControlHintWindowClass_R,@TJvExControlHintWindowClass_W,'HintWindowClass');
    RegisterPropertyHelper(@TJvExControlAboutJVCL_R,@TJvExControlAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvExControls_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetDotNetFrameColors, 'SetDotNetFrameColors', cdRegister);
 S.RegisterDelphiFunction(@DrawDotNetControl, 'DrawDotNetControl', cdRegister);
 S.RegisterDelphiFunction(@DrawDotNetControl1_P, 'DrawDotNetControl1', cdRegister);
 S.RegisterDelphiFunction(@HandleDotNetHighlighting, 'HandleDotNetHighlighting', cdRegister);
 S.RegisterDelphiFunction(@CreateWMMessage, 'CreateWMMessage', cdRegister);
 S.RegisterDelphiFunction(@CreateWMMessage1_P, 'CreateWMMessage1', cdRegister);
 S.RegisterDelphiFunction(@SmallPointToLong, 'SmallPointToLong', cdRegister);
 S.RegisterDelphiFunction(@ShiftStateToKeyData, 'ShiftStateToKeyData', cdRegister);
 S.RegisterDelphiFunction(@GetFocusedControl, 'GetFocusedControl', cdRegister);
 S.RegisterDelphiFunction(@DlgcToDlgCodes, 'DlgcToDlgCodes', cdRegister);
 S.RegisterDelphiFunction(@DlgCodesToDlgc, 'DlgCodesToDlgc', cdRegister);
 S.RegisterDelphiFunction(@GetHintColor, 'GetHintColor', cdRegister);
 S.RegisterDelphiFunction(@DispatchIsDesignMsg, 'DispatchIsDesignMsg', cdRegister);
  {RIRegister_TJvExControl(CL);
  RIRegister_TJvExWinControl(CL);
  RIRegister_TJvExCustomControl(CL);
  RIRegister_TJvExGraphicControl(CL);
  RIRegister_TJvExHintWindow(CL);
  RIRegister_TJvExPubGraphicControl(CL);}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStructPtrMessage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStructPtrMessage) do
  begin
    RegisterPropertyHelper(@TStructPtrMessageMsg_R,@TStructPtrMessageMsg_W,'Msg');
    RegisterConstructor(@TStructPtrMessage.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvExControls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStructPtrMessage(CL);
  RIRegister_TJvExControl(CL);
  RIRegister_TJvExWinControl(CL);
  RIRegister_TJvExCustomControl(CL);
  RIRegister_TJvExGraphicControl(CL);
  RIRegister_TJvExHintWindow(CL);
  RIRegister_TJvExPubGraphicControl(CL);

end;



{ TPSImport_JvExControls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvExControls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvExControls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvExControls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvExControls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
