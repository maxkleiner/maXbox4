unit uPSI_ovccalc;
{
   kraftiwerki
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
  TPSImport_ovccalc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcCalculator(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCustomCalculator(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCalcTape(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCustomCalculatorEngine(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCalcPanel(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCalcColors(CL: TPSPascalCompiler);
procedure SIRegister_ovccalc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcCalculator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCustomCalculator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCalcTape(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCustomCalculatorEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCalcPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCalcColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovccalc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Buttons
  ,ClipBrd
  ,Controls
  ,ExtCtrls
  ,Forms
  ,Graphics
  ,Menus
  ,Messages
  ,StdCtrls
  ,OvcData
  ,OvcConst
  ,OvcBase
  ,OvcMisc
  ,ovccalc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovccalc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCalculator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcCustomCalculator', 'TOvcCalculator') do
  with CL.AddClassN(CL.FindClass('TOvcCustomCalculator'),'TOvcCalculator') do
  begin
    REgisterPublishedProperties;
        RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCustomCalculator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcCustomControl', 'TOvcCustomCalculator') do
  with CL.AddClassN(CL.FindClass('TOvcCustomControl'),'TOvcCustomCalculator') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Constructor CreateEx( AOwner : TComponent; AsPopup : Boolean)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure KeyPress( var Key : Char)');
    RegisterMethod('Procedure PushOperand( const Value : Extended)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure PasteFromClipboard');
    RegisterMethod('Procedure PressButton( Button : TOvcCalculatorButton)');
    RegisterProperty('LastOperand', 'Extended', iptrw);
    RegisterProperty('Memory', 'Extended', iptrw);
    RegisterProperty('Operand', 'Extended', iptrw);
    RegisterProperty('DisplayStr', 'string', iptrw);
    RegisterProperty('DisplayValue', 'Extended', iptrw);
    RegisterProperty('Tape', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCalcTape(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TOvcCalcTape') do
  with CL.AddClassN(CL.FindClass('TObject'),'TOvcCalcTape') do
  begin
    RegisterMethod('Constructor Create( const AOwner : TComponent; const AOperandSize : Integer)');
    RegisterMethod('Procedure InitializeTape');
    RegisterMethod('Procedure SetBounds( const ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Function GetDisplayedItemCount : Integer');
    RegisterMethod('Procedure AddToTape( const Value : string; const OpString : string)');
    RegisterMethod('Procedure AddToTapeLeft( const Value : string)');
    RegisterMethod('Procedure ClearTape');
    RegisterMethod('Procedure RefreshDisplays');
    RegisterMethod('Procedure SpaceTape( const Value : char)');
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('MaxPaperCount', 'Integer', iptrw);
    RegisterProperty('ShowTape', 'Boolean', iptrw);
    RegisterProperty('Tape', 'TStrings', iptrw);
    RegisterProperty('TapeColor', 'TColor', iptrw);
    RegisterProperty('TapeDisplaySpace', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('TopIndex', 'Integer', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCustomCalculatorEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TOvcCustomCalculatorEngine') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TOvcCustomCalculatorEngine') do
  begin
    RegisterMethod('Function AddOperand( const Value : Extended; const Button : TOvcCalculatorOperation) : Boolean');
    RegisterMethod('Function AddOperation( const Button : TOvcCalculatorOperation) : Boolean');
    RegisterMethod('Procedure ClearAll');
    RegisterMethod('Procedure PushOperand( const Value : Extended)');
    RegisterMethod('Function PopOperand : Extended');
    RegisterMethod('Function TopOperand : Extended');
    RegisterProperty('Decimals', 'Integer', iptrw);
    RegisterProperty('LastOperation', 'TOvcCalculatorOperation', iptrw);
    RegisterProperty('Memory', 'Extended', iptrw);
    RegisterProperty('OperationCount', 'Integer', iptrw);
    RegisterProperty('ShowSeparatePercent', 'Boolean', iptrw);
    RegisterProperty('State', 'TOvcCalcStates', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCalcPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPanel', 'TOvcCalcPanel') do
  with CL.AddClassN(CL.FindClass('TPanel'),'TOvcCalcPanel') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCalcColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TOvcCalcColors') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TOvcCalcColors') do begin
    RegisterProperty('FCalcColors', 'TOvcCalcColorArray', iptrw);
    RegisterProperty('FColorScheme', 'TOvcCalcColorScheme', iptrw);
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('ColorScheme', 'TOvcCalcColorScheme', iptrw);
    RegisterProperty('DisabledMemoryButtons', 'TColor', iptrw);
    RegisterProperty('Display', 'TColor', iptrw);
    RegisterProperty('DisplayTextColor', 'TColor', iptrw);
    RegisterProperty('EditButtons', 'TColor', iptrw);
    RegisterProperty('FunctionButtons', 'TColor', iptrw);
    RegisterProperty('MemoryButtons', 'TColor', iptrw);
    RegisterProperty('NumberButtons', 'TColor', iptrw);
    RegisterProperty('OperatorButtons', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovccalc(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcCalculatorButton', '( cbNone, cbTape, cbBack, cbClearEntry, '
   +'cbClear, cbAdd, cbSub, cbMul, cbDiv, cb0, cb1, cb2, cb3, cb4, cb5, cb6, cb'
   +'7, cb8, cb9, cbDecimal, cbEqual, cbInvert, cbChangeSign, cbPercent, cbSqrt'
   +', cbMemClear, cbMemRecall, cbMemStore, cbMemAdd, cbMemSub, cbSubTotal )');
  CL.AddTypeS('TOvcButtonInfo', 'record Position : TRect; Caption : string; Visible: Boolean; end');
  CL.AddTypeS('TOvcCalculatorOperation', '( coNone, coAdd, coSub, coMul, coDiv,'
   +' coEqual, coInvert, coPercent, coSqrt, coMemClear, coMemRecall, coMemStore'
   +', coMemAdd, coMemSub, coSubTotal )');
  CL.AddTypeS('TOvcCalcState', '( csValid, csLocked, csClear )');
  CL.AddTypeS('TOvcCalcStates', 'set of TOvcCalcState');
  CL.AddTypeS('TOvcCalcColorScheme', '( cscalcCustom, cscalcWindows, cscalcDark'
   +', cscalcOcean, cscalcPlain )');
  SIRegister_TOvcCalcColors(CL);
  SIRegister_TOvcCalcPanel(CL);
  SIRegister_TOvcCustomCalculatorEngine(CL);
  SIRegister_TOvcCalcTape(CL);
  CL.AddTypeS('TOvcCalcButtonPressedEvent', 'Procedure ( Sender : TObject; Butt'
   +'on : TOvcCalculatorButton)');
  CL.AddTypeS('TOvcCalculatorOption', '( coShowItemCount, coShowMemoryButtons, '
   +'coShowClearTapeButton, coShowTape, coShowSeparatePercent )');
  CL.AddTypeS('TOvcCalculatorOptions', 'set of TOvcCalculatorOption');
  SIRegister_TOvcCustomCalculator(CL);
  SIRegister_TOvcCalculator(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorTape_W(Self: TOvcCustomCalculator; const T: TStrings);
begin Self.Tape := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorTape_R(Self: TOvcCustomCalculator; var T: TStrings);
begin T := Self.Tape; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorDisplayValue_W(Self: TOvcCustomCalculator; const T: Extended);
begin Self.DisplayValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorDisplayValue_R(Self: TOvcCustomCalculator; var T: Extended);
begin T := Self.DisplayValue; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorDisplayStr_W(Self: TOvcCustomCalculator; const T: string);
begin Self.DisplayStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorDisplayStr_R(Self: TOvcCustomCalculator; var T: string);
begin T := Self.DisplayStr; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorOperand_W(Self: TOvcCustomCalculator; const T: Extended);
begin Self.Operand := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorOperand_R(Self: TOvcCustomCalculator; var T: Extended);
begin T := Self.Operand; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorMemory_W(Self: TOvcCustomCalculator; const T: Extended);
begin Self.Memory := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorMemory_R(Self: TOvcCustomCalculator; var T: Extended);
begin T := Self.Memory; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorLastOperand_W(Self: TOvcCustomCalculator; const T: Extended);
begin Self.LastOperand := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorLastOperand_R(Self: TOvcCustomCalculator; var T: Extended);
begin T := Self.LastOperand; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeWidth_W(Self: TOvcCalcTape; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeWidth_R(Self: TOvcCalcTape; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeVisible_W(Self: TOvcCalcTape; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeVisible_R(Self: TOvcCalcTape; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTopIndex_W(Self: TOvcCalcTape; const T: Integer);
begin Self.TopIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTopIndex_R(Self: TOvcCalcTape; var T: Integer);
begin T := Self.TopIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTop_W(Self: TOvcCalcTape; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTop_R(Self: TOvcCalcTape; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTapeDisplaySpace_W(Self: TOvcCalcTape; const T: Integer);
begin Self.TapeDisplaySpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTapeDisplaySpace_R(Self: TOvcCalcTape; var T: Integer);
begin T := Self.TapeDisplaySpace; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTapeColor_W(Self: TOvcCalcTape; const T: TColor);
begin Self.TapeColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTapeColor_R(Self: TOvcCalcTape; var T: TColor);
begin T := Self.TapeColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTape_W(Self: TOvcCalcTape; const T: TStrings);
begin Self.Tape := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeTape_R(Self: TOvcCalcTape; var T: TStrings);
begin T := Self.Tape; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeShowTape_W(Self: TOvcCalcTape; const T: Boolean);
begin Self.ShowTape := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeShowTape_R(Self: TOvcCalcTape; var T: Boolean);
begin T := Self.ShowTape; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeMaxPaperCount_W(Self: TOvcCalcTape; const T: Integer);
begin Self.MaxPaperCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeMaxPaperCount_R(Self: TOvcCalcTape; var T: Integer);
begin T := Self.MaxPaperCount; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeHeight_W(Self: TOvcCalcTape; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeHeight_R(Self: TOvcCalcTape; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeFont_W(Self: TOvcCalcTape; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcTapeFont_R(Self: TOvcCalcTape; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineState_W(Self: TOvcCustomCalculatorEngine; const T: TOvcCalcStates);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineState_R(Self: TOvcCustomCalculatorEngine; var T: TOvcCalcStates);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineShowSeparatePercent_W(Self: TOvcCustomCalculatorEngine; const T: Boolean);
begin Self.ShowSeparatePercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineShowSeparatePercent_R(Self: TOvcCustomCalculatorEngine; var T: Boolean);
begin T := Self.ShowSeparatePercent; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineOperationCount_W(Self: TOvcCustomCalculatorEngine; const T: Integer);
begin Self.OperationCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineOperationCount_R(Self: TOvcCustomCalculatorEngine; var T: Integer);
begin T := Self.OperationCount; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineMemory_W(Self: TOvcCustomCalculatorEngine; const T: Extended);
begin Self.Memory := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineMemory_R(Self: TOvcCustomCalculatorEngine; var T: Extended);
begin T := Self.Memory; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineLastOperation_W(Self: TOvcCustomCalculatorEngine; const T: TOvcCalculatorOperation);
begin Self.LastOperation := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineLastOperation_R(Self: TOvcCustomCalculatorEngine; var T: TOvcCalculatorOperation);
begin T := Self.LastOperation; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineDecimals_W(Self: TOvcCustomCalculatorEngine; const T: Integer);
begin Self.Decimals := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomCalculatorEngineDecimals_R(Self: TOvcCustomCalculatorEngine; var T: Integer);
begin T := Self.Decimals; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsOperatorButtons_W(Self: TOvcCalcColors; const T: TColor);
begin Self.OperatorButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsOperatorButtons_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.OperatorButtons; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsNumberButtons_W(Self: TOvcCalcColors; const T: TColor);
begin Self.NumberButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsNumberButtons_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.NumberButtons; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsMemoryButtons_W(Self: TOvcCalcColors; const T: TColor);
begin Self.MemoryButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsMemoryButtons_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.MemoryButtons; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsFunctionButtons_W(Self: TOvcCalcColors; const T: TColor);
begin Self.FunctionButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsFunctionButtons_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.FunctionButtons; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsEditButtons_W(Self: TOvcCalcColors; const T: TColor);
begin Self.EditButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsEditButtons_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.EditButtons; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsDisplayTextColor_W(Self: TOvcCalcColors; const T: TColor);
begin Self.DisplayTextColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsDisplayTextColor_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.DisplayTextColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsDisplay_W(Self: TOvcCalcColors; const T: TColor);
begin Self.Display := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsDisplay_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.Display; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsDisabledMemoryButtons_W(Self: TOvcCalcColors; const T: TColor);
begin Self.DisabledMemoryButtons := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsDisabledMemoryButtons_R(Self: TOvcCalcColors; var T: TColor);
begin T := Self.DisabledMemoryButtons; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsColorScheme_W(Self: TOvcCalcColors; const T: TOvcCalcColorScheme);
begin Self.ColorScheme := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsColorScheme_R(Self: TOvcCalcColors; var T: TOvcCalcColorScheme);
begin T := Self.ColorScheme; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsOnChange_W(Self: TOvcCalcColors; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsOnChange_R(Self: TOvcCalcColors; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsFColorScheme_W(Self: TOvcCalcColors; const T: TOvcCalcColorScheme);
Begin Self.FColorScheme := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsFColorScheme_R(Self: TOvcCalcColors; var T: TOvcCalcColorScheme);
Begin T := Self.FColorScheme; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsFCalcColors_W(Self: TOvcCalcColors; const T: TOvcCalcColorArray);
Begin Self.FCalcColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcColorsFCalcColors_R(Self: TOvcCalcColors; var T: TOvcCalcColorArray);
Begin T := Self.FCalcColors; end;

procedure TOvcCalcParent_W(Self: TOvcCalculator; const T: TWincontrol);
begin Self.parent:= T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCalcParent_R(Self: TOvcCalculator; var T: TWinControl);
begin T:= Self.Parent; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCalculator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCalculator) do begin
     RegisterPropertyHelper(@TOvcCalcParent_R,@TOvcCalcParent_W,'Parent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCustomCalculator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCustomCalculator) do begin
    RegisterConstructor(@TOvcCustomCalculator.Create, 'Create');
    RegisterVirtualConstructor(@TOvcCustomCalculator.CreateEx, 'CreateEx');
    RegisterMethod(@TOvcCustomCalculator.Destroy, 'Free');
    RegisterMethod(@TOvcCustomCalculator.KeyPress, 'KeyPress');
    RegisterMethod(@TOvcCustomCalculator.PushOperand, 'PushOperand');
    RegisterMethod(@TOvcCustomCalculator.SetBounds, 'SetBounds');
    RegisterMethod(@TOvcCustomCalculator.CopyToClipboard, 'CopyToClipboard');
    RegisterMethod(@TOvcCustomCalculator.PasteFromClipboard, 'PasteFromClipboard');
    RegisterMethod(@TOvcCustomCalculator.PressButton, 'PressButton');
    RegisterPropertyHelper(@TOvcCustomCalculatorLastOperand_R,@TOvcCustomCalculatorLastOperand_W,'LastOperand');
    RegisterPropertyHelper(@TOvcCustomCalculatorMemory_R,@TOvcCustomCalculatorMemory_W,'Memory');
    RegisterPropertyHelper(@TOvcCustomCalculatorOperand_R,@TOvcCustomCalculatorOperand_W,'Operand');
    RegisterPropertyHelper(@TOvcCustomCalculatorDisplayStr_R,@TOvcCustomCalculatorDisplayStr_W,'DisplayStr');
    RegisterPropertyHelper(@TOvcCustomCalculatorDisplayValue_R,@TOvcCustomCalculatorDisplayValue_W,'DisplayValue');
    //RegisterPropertyHelper(@TOvcCalcParent_R,@TOvcCustomCalculatorDisplayValue_W,'DisplayValue');
    RegisterPropertyHelper(@TOvcCustomCalculatorTape_R,@TOvcCustomCalculatorTape_W,'Tape');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCalcTape(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCalcTape) do
  begin
    RegisterConstructor(@TOvcCalcTape.Create, 'Create');
    RegisterMethod(@TOvcCalcTape.InitializeTape, 'InitializeTape');
    RegisterMethod(@TOvcCalcTape.SetBounds, 'SetBounds');
    RegisterMethod(@TOvcCalcTape.GetDisplayedItemCount, 'GetDisplayedItemCount');
    RegisterMethod(@TOvcCalcTape.AddToTape, 'AddToTape');
    RegisterMethod(@TOvcCalcTape.AddToTapeLeft, 'AddToTapeLeft');
    RegisterMethod(@TOvcCalcTape.ClearTape, 'ClearTape');
    RegisterMethod(@TOvcCalcTape.RefreshDisplays, 'RefreshDisplays');
    RegisterMethod(@TOvcCalcTape.SpaceTape, 'SpaceTape');
    RegisterPropertyHelper(@TOvcCalcTapeFont_R,@TOvcCalcTapeFont_W,'Font');
    RegisterPropertyHelper(@TOvcCalcTapeHeight_R,@TOvcCalcTapeHeight_W,'Height');
    RegisterPropertyHelper(@TOvcCalcTapeMaxPaperCount_R,@TOvcCalcTapeMaxPaperCount_W,'MaxPaperCount');
    RegisterPropertyHelper(@TOvcCalcTapeShowTape_R,@TOvcCalcTapeShowTape_W,'ShowTape');
    RegisterPropertyHelper(@TOvcCalcTapeTape_R,@TOvcCalcTapeTape_W,'Tape');
    RegisterPropertyHelper(@TOvcCalcTapeTapeColor_R,@TOvcCalcTapeTapeColor_W,'TapeColor');
    RegisterPropertyHelper(@TOvcCalcTapeTapeDisplaySpace_R,@TOvcCalcTapeTapeDisplaySpace_W,'TapeDisplaySpace');
    RegisterPropertyHelper(@TOvcCalcTapeTop_R,@TOvcCalcTapeTop_W,'Top');
    RegisterPropertyHelper(@TOvcCalcTapeTopIndex_R,@TOvcCalcTapeTopIndex_W,'TopIndex');
    RegisterPropertyHelper(@TOvcCalcTapeVisible_R,@TOvcCalcTapeVisible_W,'Visible');
    RegisterPropertyHelper(@TOvcCalcTapeWidth_R,@TOvcCalcTapeWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCustomCalculatorEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCustomCalculatorEngine) do begin
    //RegisterVirtualAbstractMethod(@TOvcCustomCalculatorEngine, @!.AddOperand, 'AddOperand');
    //RegisterVirtualAbstractMethod(@TOvcCustomCalculatorEngine, @!.AddOperation, 'AddOperation');
    RegisterMethod(@TOvcCustomCalculatorEngine.ClearAll, 'ClearAll');
    RegisterMethod(@TOvcCustomCalculatorEngine.PushOperand, 'PushOperand');
    RegisterMethod(@TOvcCustomCalculatorEngine.PopOperand, 'PopOperand');
    RegisterMethod(@TOvcCustomCalculatorEngine.TopOperand, 'TopOperand');
    RegisterPropertyHelper(@TOvcCustomCalculatorEngineDecimals_R,@TOvcCustomCalculatorEngineDecimals_W,'Decimals');
    RegisterPropertyHelper(@TOvcCustomCalculatorEngineLastOperation_R,@TOvcCustomCalculatorEngineLastOperation_W,'LastOperation');
    RegisterPropertyHelper(@TOvcCustomCalculatorEngineMemory_R,@TOvcCustomCalculatorEngineMemory_W,'Memory');
    RegisterPropertyHelper(@TOvcCustomCalculatorEngineOperationCount_R,@TOvcCustomCalculatorEngineOperationCount_W,'OperationCount');
    RegisterPropertyHelper(@TOvcCustomCalculatorEngineShowSeparatePercent_R,@TOvcCustomCalculatorEngineShowSeparatePercent_W,'ShowSeparatePercent');
    RegisterPropertyHelper(@TOvcCustomCalculatorEngineState_R,@TOvcCustomCalculatorEngineState_W,'State');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCalcPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCalcPanel) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCalcColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCalcColors) do
  begin
    RegisterPropertyHelper(@TOvcCalcColorsFCalcColors_R,@TOvcCalcColorsFCalcColors_W,'FCalcColors');
    RegisterPropertyHelper(@TOvcCalcColorsFColorScheme_R,@TOvcCalcColorsFColorScheme_W,'FColorScheme');
    RegisterMethod(@TOvcCalcColors.Assign, 'Assign');
    RegisterMethod(@TOvcCalcColors.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TOvcCalcColors.EndUpdate, 'EndUpdate');
    RegisterPropertyHelper(@TOvcCalcColorsOnChange_R,@TOvcCalcColorsOnChange_W,'OnChange');
    RegisterPropertyHelper(@TOvcCalcColorsColorScheme_R,@TOvcCalcColorsColorScheme_W,'ColorScheme');
    RegisterPropertyHelper(@TOvcCalcColorsDisabledMemoryButtons_R,@TOvcCalcColorsDisabledMemoryButtons_W,'DisabledMemoryButtons');
    RegisterPropertyHelper(@TOvcCalcColorsDisplay_R,@TOvcCalcColorsDisplay_W,'Display');
    RegisterPropertyHelper(@TOvcCalcColorsDisplayTextColor_R,@TOvcCalcColorsDisplayTextColor_W,'DisplayTextColor');
    RegisterPropertyHelper(@TOvcCalcColorsEditButtons_R,@TOvcCalcColorsEditButtons_W,'EditButtons');
    RegisterPropertyHelper(@TOvcCalcColorsFunctionButtons_R,@TOvcCalcColorsFunctionButtons_W,'FunctionButtons');
    RegisterPropertyHelper(@TOvcCalcColorsMemoryButtons_R,@TOvcCalcColorsMemoryButtons_W,'MemoryButtons');
    RegisterPropertyHelper(@TOvcCalcColorsNumberButtons_R,@TOvcCalcColorsNumberButtons_W,'NumberButtons');
    RegisterPropertyHelper(@TOvcCalcColorsOperatorButtons_R,@TOvcCalcColorsOperatorButtons_W,'OperatorButtons');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovccalc(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcCalcColors(CL);
  RIRegister_TOvcCalcPanel(CL);
  RIRegister_TOvcCustomCalculatorEngine(CL);
  RIRegister_TOvcCalcTape(CL);
  RIRegister_TOvcCustomCalculator(CL);
  RIRegister_TOvcCalculator(CL);
end;

 
 
{ TPSImport_ovccalc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovccalc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovccalc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovccalc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovccalc(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
