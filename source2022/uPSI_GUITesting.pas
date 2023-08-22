unit uPSI_GUITesting;
{
   unit testing
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
  TPSImport_GUITesting = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGUITestCase(CL: TPSPascalCompiler);
procedure SIRegister_GUITesting(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGUITestCase(CL: TPSRuntimeClassImporter);
procedure RIRegister_GUITesting(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   TestFramework
  //,Types
  //,Windows
  //,Messages
  {,Qt
  ,QControls
  ,QForms}
  ,Controls
  ,Forms
  ,GUITesting
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GUITesting]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGUITestCase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestCase', 'TGUITestCase') do
  with CL.AddClassN(CL.FindClass('TTestCase'),'TGUITestCase') do begin
    RegisterProperty('FGUI', 'TControl', iptrw);
    RegisterProperty('FActionDelay', 'Integer', iptrw);
    RegisterMethod('Constructor Create( MethodName : string)');
    RegisterMethod('Procedure TearDown');
    RegisterMethod('Function FindControl( Comp : TComponent; const CtlName : string; Addrs : Pointer) : TControl;');
    RegisterMethod('Function FindControl1( const AName : string; Addrs : Pointer) : TControl;');
    RegisterMethod('Function FindParentWinControl( Control : TControl) : TWinControl');
    RegisterMethod('Procedure SetKeyboardStateDown( pControl : TWinControl; pShiftState : TShiftState)');
    RegisterMethod('Procedure SetKeyboardStateUp( pControl : TWinControl; pShiftState : TShiftState)');
    RegisterMethod('Procedure ClickLeftMouseButtonOn( Control : TControl)');
    RegisterMethod('Procedure Click;');
    RegisterMethod('Procedure Click1( ControlName : string);');
    RegisterMethod('Procedure Click2( control : TControl);');
    RegisterMethod('Procedure EnterKey( Key : Word; const ShiftState : TShiftState);');
    RegisterMethod('Procedure EnterKeyInto( Control : TControl; Key : Word; const ShiftState : TShiftState);');
    RegisterMethod('Procedure EnterKeyInto1( ControlName : string; Key : Word; const ShiftState : TShiftState);');
    RegisterMethod('Procedure EnterKey2( Key : Char; const ShiftState : TShiftState);');
    RegisterMethod('Procedure EnterKeyInto2( Control : TControl; Key : Char; const ShiftState : TShiftState);');
    RegisterMethod('Procedure EnterKeyInto3( ControlName : string; Key : Char; const ShiftState : TShiftState);');
    RegisterMethod('Procedure EnterText( Text : string)');
    RegisterMethod('Procedure EnterTextInto( Control : TControl; Text : string);');
    RegisterMethod('Procedure EnterTextInto1( ControlName : string; Text : string);');
    RegisterMethod('Procedure Show( OnOff : boolean);');
    RegisterMethod('Procedure Show1( Control : TControl; OnOff : boolean);');
    RegisterMethod('Procedure Show2( ControlName : string; OnOff : boolean);');
    RegisterMethod('Procedure Hide;');
    RegisterMethod('Procedure Hide1( Control : TControl);');
    RegisterMethod('Procedure Hide2( ControlName : string);');
    RegisterMethod('Procedure Tab( n : Integer)');
    RegisterMethod('Procedure CheckTabTo( Control : TControl; Addrs : Pointer);');
    RegisterMethod('Procedure CheckTabTo1( ControlName : string);');
    RegisterMethod('Function GetFocused : TControl');
    RegisterMethod('Function IsFocused( Control : TControl) : boolean');
    RegisterMethod('Procedure SetFocus( Control : TControl; Addrs : Pointer);');
    RegisterMethod('Procedure SetFocus1( ControlName : string);');
    RegisterMethod('Procedure CheckFocused( Control : TControl; Addrs : Pointer);');
    RegisterMethod('Procedure CheckFocused1( ControlName : string);');
    RegisterMethod('Procedure CheckEnabled( Control : TControl; Addrs : Pointer);');
    RegisterMethod('Procedure CheckEnabled1( ControlName : string);');
    RegisterMethod('Procedure CheckVisible( Control : TControl; Addrs : Pointer);');
    RegisterMethod('Procedure CheckVisible1( ControlName : string);');
    RegisterMethod('Procedure CheckVisible2;');
    RegisterProperty('GUI', 'TControl', iptrw);
    RegisterProperty('ActionDelay', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GUITesting(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('rcs_id','string').SetString( '#(@)$Id: GUITesting.pas,v 1.36 2006/07/19 02:45:54 judc Exp $');
  SIRegister_TGUITestCase(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGUITestCaseActionDelay_W(Self: TGUITestCase; const T: Integer);
begin Self.ActionDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TGUITestCaseActionDelay_R(Self: TGUITestCase; var T: Integer);
begin T := Self.ActionDelay; end;

(*----------------------------------------------------------------------------*)
procedure TGUITestCaseGUI_W(Self: TGUITestCase; const T: TControl);
begin Self.GUI := T; end;

(*----------------------------------------------------------------------------*)
procedure TGUITestCaseGUI_R(Self: TGUITestCase; var T: TControl);
begin T := Self.GUI; end;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckVisible2_P(Self: TGUITestCase);
Begin Self.CheckVisible; END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckVisible1_P(Self: TGUITestCase;  ControlName : string);
Begin Self.CheckVisible(ControlName); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckVisible_P(Self: TGUITestCase;  Control : TControl; Addrs : Pointer);
Begin Self.CheckVisible(Control, Addrs); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckEnabled1_P(Self: TGUITestCase;  ControlName : string);
Begin Self.CheckEnabled(ControlName); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckEnabled_P(Self: TGUITestCase;  Control : TControl; Addrs : Pointer);
Begin Self.CheckEnabled(Control, Addrs); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckFocused1_P(Self: TGUITestCase;  ControlName : string);
Begin Self.CheckFocused(ControlName); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckFocused_P(Self: TGUITestCase;  Control : TControl; Addrs : Pointer);
Begin Self.CheckFocused(Control, Addrs); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseSetFocus1_P(Self: TGUITestCase;  ControlName : string);
Begin Self.SetFocus(ControlName); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseSetFocus_P(Self: TGUITestCase;  Control : TControl; Addrs : Pointer);
Begin Self.SetFocus(Control, Addrs); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckTabTo1_P(Self: TGUITestCase;  ControlName : string);
Begin Self.CheckTabTo(ControlName); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseCheckTabTo_P(Self: TGUITestCase;  Control : TControl; Addrs : Pointer);
Begin Self.CheckTabTo(Control, Addrs); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseHide2_P(Self: TGUITestCase;  ControlName : string);
Begin Self.Hide(ControlName); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseHide1_P(Self: TGUITestCase;  Control : TControl);
Begin Self.Hide(Control); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseHide_P(Self: TGUITestCase);
Begin Self.Hide; END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseShow2_P(Self: TGUITestCase;  ControlName : string; OnOff : boolean);
Begin Self.Show(ControlName, OnOff); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseShow1_P(Self: TGUITestCase;  Control : TControl; OnOff : boolean);
Begin Self.Show(Control, OnOff); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseShow_P(Self: TGUITestCase;  OnOff : boolean);
Begin Self.Show(OnOff); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterTextInto1_P(Self: TGUITestCase;  ControlName : string; Text : string);
Begin Self.EnterTextInto(ControlName, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterTextInto_P(Self: TGUITestCase;  Control : TControl; Text : string);
Begin Self.EnterTextInto(Control, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterKeyInto3_P(Self: TGUITestCase;  ControlName : string; Key : Char; const ShiftState : TShiftState);
Begin Self.EnterKeyInto(ControlName, Key, ShiftState); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterKeyInto2_P(Self: TGUITestCase;  Control : TControl; Key : Char; const ShiftState : TShiftState);
Begin Self.EnterKeyInto(Control, Key, ShiftState); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterKey2_P(Self: TGUITestCase;  Key : Char; const ShiftState : TShiftState);
Begin Self.EnterKey(Key, ShiftState); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterKeyInto1_P(Self: TGUITestCase;  ControlName : string; Key : Word; const ShiftState : TShiftState);
Begin Self.EnterKeyInto(ControlName, Key, ShiftState); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterKeyInto_P(Self: TGUITestCase;  Control : TControl; Key : Word; const ShiftState : TShiftState);
Begin Self.EnterKeyInto(Control, Key, ShiftState); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseEnterKey_P(Self: TGUITestCase;  Key : Word; const ShiftState : TShiftState);
Begin Self.EnterKey(Key, ShiftState); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseClick2_P(Self: TGUITestCase;  control : TControl);
Begin Self.Click(control); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseClick1_P(Self: TGUITestCase;  ControlName : string);
Begin Self.Click(ControlName); END;

(*----------------------------------------------------------------------------*)
Procedure TGUITestCaseClick_P(Self: TGUITestCase);
Begin Self.Click; END;

(*----------------------------------------------------------------------------*)
Function TGUITestCaseFindControl1_P(Self: TGUITestCase;  const AName : string; Addrs : Pointer) : TControl;
Begin Result := Self.FindControl(AName, Addrs); END;

(*----------------------------------------------------------------------------*)
Function TGUITestCaseFindControl_P(Self: TGUITestCase;  Comp : TComponent; const CtlName : string; Addrs : Pointer) : TControl;
Begin Result := Self.FindControl(Comp, CtlName, Addrs); END;

(*----------------------------------------------------------------------------*)
procedure TGUITestCaseFActionDelay_W(Self: TGUITestCase; const T: Integer);
Begin Self.FActionDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TGUITestCaseFActionDelay_R(Self: TGUITestCase; var T: Integer);
Begin T := Self.FActionDelay; end;

(*----------------------------------------------------------------------------*)
procedure TGUITestCaseFGUI_W(Self: TGUITestCase; const T: TControl);
Begin Self.FGUI := T; end;

(*----------------------------------------------------------------------------*)
procedure TGUITestCaseFGUI_R(Self: TGUITestCase; var T: TControl);
Begin T := Self.FGUI; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGUITestCase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGUITestCase) do
  begin
    RegisterPropertyHelper(@TGUITestCaseFGUI_R,@TGUITestCaseFGUI_W,'FGUI');
    RegisterPropertyHelper(@TGUITestCaseFActionDelay_R,@TGUITestCaseFActionDelay_W,'FActionDelay');
    RegisterConstructor(@TGUITestCase.Create, 'Create');
    RegisterMethod(@TGUITestCase.TearDown, 'TearDown');
    RegisterMethod(@TGUITestCaseFindControl_P, 'FindControl');
    RegisterMethod(@TGUITestCaseFindControl1_P, 'FindControl1');
    RegisterMethod(@TGUITestCase.FindParentWinControl, 'FindParentWinControl');
    RegisterMethod(@TGUITestCase.SetKeyboardStateDown, 'SetKeyboardStateDown');
    RegisterMethod(@TGUITestCase.SetKeyboardStateUp, 'SetKeyboardStateUp');
    RegisterMethod(@TGUITestCase.ClickLeftMouseButtonOn, 'ClickLeftMouseButtonOn');
    RegisterMethod(@TGUITestCaseClick_P, 'Click');
    RegisterMethod(@TGUITestCaseClick1_P, 'Click1');
    RegisterMethod(@TGUITestCaseClick2_P, 'Click2');
    RegisterMethod(@TGUITestCaseEnterKey_P, 'EnterKey');
    RegisterMethod(@TGUITestCaseEnterKeyInto_P, 'EnterKeyInto');
    RegisterMethod(@TGUITestCaseEnterKeyInto1_P, 'EnterKeyInto1');
    RegisterMethod(@TGUITestCaseEnterKey2_P, 'EnterKey2');
    RegisterMethod(@TGUITestCaseEnterKeyInto2_P, 'EnterKeyInto2');
    RegisterMethod(@TGUITestCaseEnterKeyInto3_P, 'EnterKeyInto3');
    RegisterMethod(@TGUITestCase.EnterText, 'EnterText');
    RegisterMethod(@TGUITestCaseEnterTextInto_P, 'EnterTextInto');
    RegisterMethod(@TGUITestCaseEnterTextInto1_P, 'EnterTextInto1');
    RegisterMethod(@TGUITestCaseShow_P, 'Show');
    RegisterMethod(@TGUITestCaseShow1_P, 'Show1');
    RegisterMethod(@TGUITestCaseShow2_P, 'Show2');
    RegisterMethod(@TGUITestCaseHide_P, 'Hide');
    RegisterMethod(@TGUITestCaseHide1_P, 'Hide1');
    RegisterMethod(@TGUITestCaseHide2_P, 'Hide2');
    RegisterMethod(@TGUITestCase.Tab, 'Tab');
    RegisterMethod(@TGUITestCaseCheckTabTo_P, 'CheckTabTo');
    RegisterMethod(@TGUITestCaseCheckTabTo1_P, 'CheckTabTo1');
    RegisterMethod(@TGUITestCase.GetFocused, 'GetFocused');
    RegisterMethod(@TGUITestCase.IsFocused, 'IsFocused');
    RegisterMethod(@TGUITestCaseSetFocus_P, 'SetFocus');
    RegisterMethod(@TGUITestCaseSetFocus1_P, 'SetFocus1');
    RegisterMethod(@TGUITestCaseCheckFocused_P, 'CheckFocused');
    RegisterMethod(@TGUITestCaseCheckFocused1_P, 'CheckFocused1');
    RegisterMethod(@TGUITestCaseCheckEnabled_P, 'CheckEnabled');
    RegisterMethod(@TGUITestCaseCheckEnabled1_P, 'CheckEnabled1');
    RegisterMethod(@TGUITestCaseCheckVisible_P, 'CheckVisible');
    RegisterMethod(@TGUITestCaseCheckVisible1_P, 'CheckVisible1');
    RegisterMethod(@TGUITestCaseCheckVisible2_P, 'CheckVisible2');
    RegisterPropertyHelper(@TGUITestCaseGUI_R,@TGUITestCaseGUI_W,'GUI');
    RegisterPropertyHelper(@TGUITestCaseActionDelay_R,@TGUITestCaseActionDelay_W,'ActionDelay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GUITesting(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGUITestCase(CL);
end;

 
 
{ TPSImport_GUITesting }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GUITesting.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GUITesting(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GUITesting.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GUITesting(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
