unit uPSI_JvCalc;
{
     add with TSpeedButton
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
  TPSImport_JvCalc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCalculatorForm(CL: TPSPascalCompiler);
procedure SIRegister_TJvCalculator(CL: TPSPascalCompiler);
procedure SIRegister_JvCalc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvCalc_Routines(S: TPSExec);
procedure RIRegister_TJvCalculatorForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCalculator(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCalc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,Menus
  ,ExtCtrls
  ,Buttons
  ,Clipbrd
  ,JvxCtrls
  ,JvBaseDlg
  ,JvCalc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCalc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCalculatorForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TJvCalculatorForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TJvCalculatorForm') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCalculator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvCalculator') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvCalculator') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('CalcDisplay', 'Double', iptr);
    RegisterProperty('Memory', 'Double', iptr);
    RegisterProperty('BeepOnError', 'Boolean', iptrw);
    RegisterProperty('Ctl3D', 'Boolean', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('Precision', 'Byte', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Value', 'Double', iptrw);
    RegisterProperty('OnCalcKey', 'TKeyPressEvent', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDisplayChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCalc(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DefCalcPrecision','LongInt').SetInt( 15);
  CL.AddTypeS('TJvCalcState', '( csFirst, csValid, csError )');
  CL.AddTypeS('TBiDiMode', '(bdLeftToRight,bdRightToLeft,bdRightToLeftNoAlign,bdRightToLeftReadingOnly)');
  CL.AddTypeS('TVerticalAlignment', '(taAlignTop,taAlignBottom,taVerticalCenter)');
  CL.AddTypeS('THelpType', '(htKeyword, htContext)');

  //  TBiDiMode = (bdLeftToRight, bdRightToLeft, bdRightToLeftNoAlign,
    //bdRightToLeftReadingOnly);
  // TVerticalAlignment = (taAlignTop, taAlignBottom, taVerticalCenter);

  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvCalculatorForm');
  SIRegister_TJvCalculator(CL);
  SIRegister_TJvCalculatorForm(CL);
 CL.AddDelphiFunction('Function CreateCalculatorForm( AOwner : TComponent; AHelpContext : THelpContext) : TJvCalculatorForm');
 CL.AddDelphiFunction('Function CreatePopupCalculator( AOwner : TComponent; ABiDiMode : TBiDiMode) : TWinControl');
 //CL.AddDelphiFunction('Function CreatePopupCalculator( AOwner : TComponent) : TWinControl');
 CL.AddDelphiFunction('Procedure SetupPopupCalculator( PopupCalc : TWinControl; APrecision : Byte; ABeepOnError : Boolean)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCalculatorOnDisplayChange_W(Self: TJvCalculator; const T: TNotifyEvent);
begin Self.OnDisplayChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorOnDisplayChange_R(Self: TJvCalculator; var T: TNotifyEvent);
begin T := Self.OnDisplayChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorOnChange_W(Self: TJvCalculator; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorOnChange_R(Self: TJvCalculator; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorOnCalcKey_W(Self: TJvCalculator; const T: TKeyPressEvent);
begin Self.OnCalcKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorOnCalcKey_R(Self: TJvCalculator; var T: TKeyPressEvent);
begin T := Self.OnCalcKey; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorValue_W(Self: TJvCalculator; const T: Double);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorValue_R(Self: TJvCalculator; var T: Double);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorTitle_W(Self: TJvCalculator; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorTitle_R(Self: TJvCalculator; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorPrecision_W(Self: TJvCalculator; const T: Byte);
begin Self.Precision := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorPrecision_R(Self: TJvCalculator; var T: Byte);
begin T := Self.Precision; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorHelpContext_W(Self: TJvCalculator; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorHelpContext_R(Self: TJvCalculator; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorCtl3D_W(Self: TJvCalculator; const T: Boolean);
begin Self.Ctl3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorCtl3D_R(Self: TJvCalculator; var T: Boolean);
begin T := Self.Ctl3D; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorBeepOnError_W(Self: TJvCalculator; const T: Boolean);
begin Self.BeepOnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorBeepOnError_R(Self: TJvCalculator; var T: Boolean);
begin T := Self.BeepOnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorMemory_R(Self: TJvCalculator; var T: Double);
begin T := Self.Memory; end;

(*----------------------------------------------------------------------------*)
procedure TJvCalculatorCalcDisplay_R(Self: TJvCalculator; var T: Double);
begin T := Self.CalcDisplay; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCalc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateCalculatorForm, 'CreateCalculatorForm', cdRegister);
 S.RegisterDelphiFunction(@CreatePopupCalculator, 'CreatePopupCalculator', cdRegister);
 //S.RegisterDelphiFunction(@CreatePopupCalculator, 'CreatePopupCalculator', cdRegister);
 S.RegisterDelphiFunction(@SetupPopupCalculator, 'SetupPopupCalculator', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCalculatorForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCalculatorForm) do
  begin
    RegisterConstructor(@TJvCalculatorForm.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCalculator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCalculator) do begin
    RegisterConstructor(@TJvCalculator.Create, 'Create');
    RegisterMethod(@TJvCalculator.Destroy, 'Free');
    RegisterMethod(@TJvCalculator.Execute, 'Execute');
    RegisterPropertyHelper(@TJvCalculatorCalcDisplay_R,nil,'CalcDisplay');
    RegisterPropertyHelper(@TJvCalculatorMemory_R,nil,'Memory');
    RegisterPropertyHelper(@TJvCalculatorBeepOnError_R,@TJvCalculatorBeepOnError_W,'BeepOnError');
    RegisterPropertyHelper(@TJvCalculatorCtl3D_R,@TJvCalculatorCtl3D_W,'Ctl3D');
    RegisterPropertyHelper(@TJvCalculatorHelpContext_R,@TJvCalculatorHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TJvCalculatorPrecision_R,@TJvCalculatorPrecision_W,'Precision');
    RegisterPropertyHelper(@TJvCalculatorTitle_R,@TJvCalculatorTitle_W,'Title');
    RegisterPropertyHelper(@TJvCalculatorValue_R,@TJvCalculatorValue_W,'Value');
    RegisterPropertyHelper(@TJvCalculatorOnCalcKey_R,@TJvCalculatorOnCalcKey_W,'OnCalcKey');
    RegisterPropertyHelper(@TJvCalculatorOnChange_R,@TJvCalculatorOnChange_W,'OnChange');
    RegisterPropertyHelper(@TJvCalculatorOnDisplayChange_R,@TJvCalculatorOnDisplayChange_W,'OnDisplayChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCalc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCalculatorForm) do
  RIRegister_TJvCalculator(CL);
  RIRegister_TJvCalculatorForm(CL);
end;

 
 
{ TPSImport_JvCalc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCalc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCalc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCalc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCalc(ri);
  RIRegister_JvCalc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
