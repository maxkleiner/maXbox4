unit uPSI_KhFunction;
{
data science gradients     2 free function & plot

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
  TPSImport_KhFunction = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKhXYPlotFunctions(CL: TPSPascalCompiler);
procedure SIRegister_TKhXYPlotFunction(CL: TPSPascalCompiler);
procedure SIRegister_TKhXYPlotAxis(CL: TPSPascalCompiler);
procedure SIRegister_TKhXYPlot(CL: TPSPascalCompiler);
procedure SIRegister_TKh1stOrderDiffEquation(CL: TPSPascalCompiler);
procedure SIRegister_TKh2ndDerivative(CL: TPSPascalCompiler);
procedure SIRegister_TKh1stDerivative(CL: TPSPascalCompiler);
procedure SIRegister_TKhFunction(CL: TPSPascalCompiler);
procedure SIRegister_TKhFunctionStep(CL: TPSPascalCompiler);
procedure SIRegister_TKhFunctionInterval(CL: TPSPascalCompiler);
procedure SIRegister_KhFunction(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KhFunction_Routines(S: TPSExec);
procedure RIRegister_TKhXYPlotFunctions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKhXYPlotFunction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKhXYPlotAxis(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKhXYPlot(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKh1stOrderDiffEquation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKh2ndDerivative(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKh1stDerivative(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKhFunction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKhFunctionStep(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKhFunctionInterval(CL: TPSRuntimeClassImporter);
procedure RIRegister_KhFunction(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Graphics
  ,KhFunction
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KhFunction]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKhXYPlotFunctions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TKhXYPlotFunctions') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TKhXYPlotFunctions') do
  begin
    RegisterMethod('Function Add : TKhXYPlotFunction');
    RegisterProperty('Items', 'TKhXYPlotFunction Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKhXYPlotFunction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TKhXYPlotFunction') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TKhXYPlotFunction') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
     RegisterMethod('Procedure Free');
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('KhFunction', 'TKhFunction', iptrw);
    RegisterProperty('PenStyle', 'TPenStyle', iptrw);
    RegisterProperty('Width', 'TKhPosInt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKhXYPlotAxis(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKhXYPlotAxis') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKhXYPlotAxis') do
  begin
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('GridCount', 'TKhXYPlotAxisGridCount', iptrw);
    RegisterProperty('GridLines', 'Boolean', iptrw);
    RegisterProperty('High', 'Double', iptrw);
    RegisterProperty('Low', 'Double', iptrw);
    RegisterProperty('Numbered', 'Boolean', iptrw);
    RegisterProperty('Width', 'TKhPosInt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKhXYPlot(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TKhXYPlot') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TKhXYPlot') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure DrawGraph');
    RegisterProperty('AutoDrawGraph', 'Boolean', iptrw);
    RegisterProperty('AxesStyle', 'TKhXYPloteAxesStyle', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('Functions', 'TKhXYPlotFunctions', iptrw);
    RegisterProperty('XAxis', 'TKhXYPlotAxis', iptrw);
    RegisterProperty('YAxis', 'TKhXYPlotAxis', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ALIGN', 'TALIGN', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    //RegisterProperty('CAPTION', 'String', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKh1stOrderDiffEquation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKhFunction', 'TKh1stOrderDiffEquation') do
  with CL.AddClassN(CL.FindClass('TKhFunction'),'TKh1stOrderDiffEquation') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    //RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Evaluate');
    RegisterProperty('Method', 'TKh1stOrderDiffEquationMethod', iptrw);
    RegisterProperty('OnFunction', 'TKh1stOrderDiffEquationFunctionEvent', iptrw);
    RegisterProperty('X0', 'Double', iptrw);
    RegisterProperty('Y0', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKh2ndDerivative(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKhFunction', 'TKh2ndDerivative') do
  with CL.AddClassN(CL.FindClass('TKhFunction'),'TKh2ndDerivative') do
  begin
    RegisterMethod('Procedure Evaluate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKh1stDerivative(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKhFunction', 'TKh1stDerivative') do
  with CL.AddClassN(CL.FindClass('TKhFunction'),'TKh1stDerivative') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Evaluate');
    RegisterProperty('Method', 'TKh1stDerivativeMethod', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKhFunction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TKhFunction') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TKhFunction') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Evaluate');
    RegisterProperty('Interval', 'TKhFunctionInterval', iptrw);
    RegisterProperty('Step', 'TKhFunctionStep', iptrw);
    RegisterProperty('OnFunction', 'TKhFunctionFunctionEvent', iptrw);
    RegisterProperty('OnValue', 'TKhFunctionValueEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKhFunctionStep(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKhFunctionStep') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKhFunctionStep') do
  begin
    RegisterProperty('Count', 'TKhPosInt', iptrw);
    RegisterProperty('Size', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKhFunctionInterval(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TKhFunctionInterval') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TKhFunctionInterval') do
  begin
    RegisterProperty('Start', 'Double', iptrw);
    RegisterProperty('Finish', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_KhFunction(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TKhPosInt', 'Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKhFunction');
  SIRegister_TKhFunctionInterval(CL);
  SIRegister_TKhFunctionStep(CL);
  CL.AddTypeS('TKhFunctionFunctionEvent', 'Procedure ( Sender : TObject; const X : Double; var Y : Double)');
  CL.AddTypeS('TKhFunctionValueEvent', 'Procedure ( Sender : TObject; const X, Y : Double)');
  SIRegister_TKhFunction(CL);
  CL.AddTypeS('TKh1stDerivativeMethod', '( fdmLeftLimit, fdmRightLimit, fdmBoth, fdmLimit )');
  SIRegister_TKh1stDerivative(CL);
  SIRegister_TKh2ndDerivative(CL);
  CL.AddTypeS('TKh1stOrderDiffEquationMethod', '( demEuler, demEulerCauchy )');
  CL.AddTypeS('TKh1stOrderDiffEquationFunctionEvent', 'Procedure (Sender : TObject; const X,Y : Double; var Fxy : Double)');
  SIRegister_TKh1stOrderDiffEquation(CL);
  CL.AddTypeS('TKhXYPloteAxesStyle', '( pasCross, pasBox )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKhXYPlotAxis');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TKhXYPlotFunctions');
  SIRegister_TKhXYPlot(CL);
  CL.AddTypeS('TKhXYPlotAxisGridCount', 'Integer');
  SIRegister_TKhXYPlotAxis(CL);
  SIRegister_TKhXYPlotFunction(CL);
  SIRegister_TKhXYPlotFunctions(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionsItems_W(Self: TKhXYPlotFunctions; const T: TKhXYPlotFunction; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionsItems_R(Self: TKhXYPlotFunctions; var T: TKhXYPlotFunction; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionWidth_W(Self: TKhXYPlotFunction; const T: TKhPosInt);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionWidth_R(Self: TKhXYPlotFunction; var T: TKhPosInt);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionPenStyle_W(Self: TKhXYPlotFunction; const T: TPenStyle);
begin Self.PenStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionPenStyle_R(Self: TKhXYPlotFunction; var T: TPenStyle);
begin T := Self.PenStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionKhFunction_W(Self: TKhXYPlotFunction; const T: TKhFunction);
begin Self.KhFunction := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionKhFunction_R(Self: TKhXYPlotFunction; var T: TKhFunction);
begin T := Self.KhFunction; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionColor_W(Self: TKhXYPlotFunction; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctionColor_R(Self: TKhXYPlotFunction; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisWidth_W(Self: TKhXYPlotAxis; const T: TKhPosInt);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisWidth_R(Self: TKhXYPlotAxis; var T: TKhPosInt);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisNumbered_W(Self: TKhXYPlotAxis; const T: Boolean);
begin Self.Numbered := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisNumbered_R(Self: TKhXYPlotAxis; var T: Boolean);
begin T := Self.Numbered; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisLow_W(Self: TKhXYPlotAxis; const T: Double);
begin Self.Low := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisLow_R(Self: TKhXYPlotAxis; var T: Double);
begin T := Self.Low; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisHigh_W(Self: TKhXYPlotAxis; const T: Double);
begin Self.High := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisHigh_R(Self: TKhXYPlotAxis; var T: Double);
begin T := Self.High; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisGridLines_W(Self: TKhXYPlotAxis; const T: Boolean);
begin Self.GridLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisGridLines_R(Self: TKhXYPlotAxis; var T: Boolean);
begin T := Self.GridLines; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisGridCount_W(Self: TKhXYPlotAxis; const T: TKhXYPlotAxisGridCount);
begin Self.GridCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisGridCount_R(Self: TKhXYPlotAxis; var T: TKhXYPlotAxisGridCount);
begin T := Self.GridCount; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisColor_W(Self: TKhXYPlotAxis; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxisColor_R(Self: TKhXYPlotAxis; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFont_W(Self: TKhXYPlot; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFont_R(Self: TKhXYPlot; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotYAxis_W(Self: TKhXYPlot; const T: TKhXYPlotAxis);
begin Self.YAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotYAxis_R(Self: TKhXYPlot; var T: TKhXYPlotAxis);
begin T := Self.YAxis; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotXAxis_W(Self: TKhXYPlot; const T: TKhXYPlotAxis);
begin Self.XAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotXAxis_R(Self: TKhXYPlot; var T: TKhXYPlotAxis);
begin T := Self.XAxis; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctions_W(Self: TKhXYPlot; const T: TKhXYPlotFunctions);
begin Self.Functions := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotFunctions_R(Self: TKhXYPlot; var T: TKhXYPlotFunctions);
begin T := Self.Functions; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotColor_W(Self: TKhXYPlot; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotColor_R(Self: TKhXYPlot; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxesStyle_W(Self: TKhXYPlot; const T: TKhXYPloteAxesStyle);
begin Self.AxesStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAxesStyle_R(Self: TKhXYPlot; var T: TKhXYPloteAxesStyle);
begin T := Self.AxesStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAutoDrawGraph_W(Self: TKhXYPlot; const T: Boolean);
begin Self.AutoDrawGraph := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhXYPlotAutoDrawGraph_R(Self: TKhXYPlot; var T: Boolean);
begin T := Self.AutoDrawGraph; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationY0_W(Self: TKh1stOrderDiffEquation; const T: Double);
begin Self.Y0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationY0_R(Self: TKh1stOrderDiffEquation; var T: Double);
begin T := Self.Y0; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationX0_W(Self: TKh1stOrderDiffEquation; const T: Double);
begin Self.X0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationX0_R(Self: TKh1stOrderDiffEquation; var T: Double);
begin T := Self.X0; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationOnFunction_W(Self: TKh1stOrderDiffEquation; const T: TKh1stOrderDiffEquationFunctionEvent);
begin Self.OnFunction := T; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationOnFunction_R(Self: TKh1stOrderDiffEquation; var T: TKh1stOrderDiffEquationFunctionEvent);
begin T := Self.OnFunction; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationMethod_W(Self: TKh1stOrderDiffEquation; const T: TKh1stOrderDiffEquationMethod);
begin Self.Method := T; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stOrderDiffEquationMethod_R(Self: TKh1stOrderDiffEquation; var T: TKh1stOrderDiffEquationMethod);
begin T := Self.Method; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stDerivativeMethod_W(Self: TKh1stDerivative; const T: TKh1stDerivativeMethod);
begin Self.Method := T; end;

(*----------------------------------------------------------------------------*)
procedure TKh1stDerivativeMethod_R(Self: TKh1stDerivative; var T: TKh1stDerivativeMethod);
begin T := Self.Method; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionOnValue_W(Self: TKhFunction; const T: TKhFunctionValueEvent);
begin Self.OnValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionOnValue_R(Self: TKhFunction; var T: TKhFunctionValueEvent);
begin T := Self.OnValue; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionOnFunction_W(Self: TKhFunction; const T: TKhFunctionFunctionEvent);
begin Self.OnFunction := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionOnFunction_R(Self: TKhFunction; var T: TKhFunctionFunctionEvent);
begin T := Self.OnFunction; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionStep_W(Self: TKhFunction; const T: TKhFunctionStep);
begin Self.Step := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionStep_R(Self: TKhFunction; var T: TKhFunctionStep);
begin T := Self.Step; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionInterval_W(Self: TKhFunction; const T: TKhFunctionInterval);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionInterval_R(Self: TKhFunction; var T: TKhFunctionInterval);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionStepSize_W(Self: TKhFunctionStep; const T: Double);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionStepSize_R(Self: TKhFunctionStep; var T: Double);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionStepCount_W(Self: TKhFunctionStep; const T: TKhPosInt);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionStepCount_R(Self: TKhFunctionStep; var T: TKhPosInt);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionIntervalFinish_W(Self: TKhFunctionInterval; const T: Double);
begin Self.Finish := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionIntervalFinish_R(Self: TKhFunctionInterval; var T: Double);
begin T := Self.Finish; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionIntervalStart_W(Self: TKhFunctionInterval; const T: Double);
begin Self.Start := T; end;

(*----------------------------------------------------------------------------*)
procedure TKhFunctionIntervalStart_R(Self: TKhFunctionInterval; var T: Double);
begin T := Self.Start; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KhFunction_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKhXYPlotFunctions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhXYPlotFunctions) do
  begin
    RegisterMethod(@TKhXYPlotFunctions.Add, 'Add');
    RegisterPropertyHelper(@TKhXYPlotFunctionsItems_R,@TKhXYPlotFunctionsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKhXYPlotFunction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhXYPlotFunction) do begin
    RegisterConstructor(@TKhXYPlotFunction.Create, 'Create');
    RegisterMethod(@TKhXYPlotFunction.Destroy, 'Free');
    RegisterPropertyHelper(@TKhXYPlotFunctionColor_R,@TKhXYPlotFunctionColor_W,'Color');
    RegisterPropertyHelper(@TKhXYPlotFunctionKhFunction_R,@TKhXYPlotFunctionKhFunction_W,'KhFunction');
    RegisterPropertyHelper(@TKhXYPlotFunctionPenStyle_R,@TKhXYPlotFunctionPenStyle_W,'PenStyle');
    RegisterPropertyHelper(@TKhXYPlotFunctionWidth_R,@TKhXYPlotFunctionWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKhXYPlotAxis(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhXYPlotAxis) do
  begin
    RegisterPropertyHelper(@TKhXYPlotAxisColor_R,@TKhXYPlotAxisColor_W,'Color');
    RegisterPropertyHelper(@TKhXYPlotAxisGridCount_R,@TKhXYPlotAxisGridCount_W,'GridCount');
    RegisterPropertyHelper(@TKhXYPlotAxisGridLines_R,@TKhXYPlotAxisGridLines_W,'GridLines');
    RegisterPropertyHelper(@TKhXYPlotAxisHigh_R,@TKhXYPlotAxisHigh_W,'High');
    RegisterPropertyHelper(@TKhXYPlotAxisLow_R,@TKhXYPlotAxisLow_W,'Low');
    RegisterPropertyHelper(@TKhXYPlotAxisNumbered_R,@TKhXYPlotAxisNumbered_W,'Numbered');
    RegisterPropertyHelper(@TKhXYPlotAxisWidth_R,@TKhXYPlotAxisWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKhXYPlot(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhXYPlot) do begin
    RegisterConstructor(@TKhXYPlot.Create, 'Create');
    RegisterMethod(@TKhXYPlot.Destroy, 'Free');
    RegisterMethod(@TKhXYPlot.DrawGraph, 'DrawGraph');
    RegisterPropertyHelper(@TKhXYPlotAutoDrawGraph_R,@TKhXYPlotAutoDrawGraph_W,'AutoDrawGraph');
    RegisterPropertyHelper(@TKhXYPlotAxesStyle_R,@TKhXYPlotAxesStyle_W,'AxesStyle');
    RegisterPropertyHelper(@TKhXYPlotColor_R,@TKhXYPlotColor_W,'Color');
    RegisterPropertyHelper(@TKhXYPlotFunctions_R,@TKhXYPlotFunctions_W,'Functions');
    RegisterPropertyHelper(@TKhXYPlotXAxis_R,@TKhXYPlotXAxis_W,'XAxis');
    RegisterPropertyHelper(@TKhXYPlotYAxis_R,@TKhXYPlotYAxis_W,'YAxis');
    RegisterPropertyHelper(@TKhXYPlotFont_R,@TKhXYPlotFont_W,'Font');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKh1stOrderDiffEquation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKh1stOrderDiffEquation) do
  begin
    RegisterConstructor(@TKh1stOrderDiffEquation.Create, 'Create');
    RegisterMethod(@TKh1stOrderDiffEquation.Evaluate, 'Evaluate');
    RegisterPropertyHelper(@TKh1stOrderDiffEquationMethod_R,@TKh1stOrderDiffEquationMethod_W,'Method');
    RegisterPropertyHelper(@TKh1stOrderDiffEquationOnFunction_R,@TKh1stOrderDiffEquationOnFunction_W,'OnFunction');
    RegisterPropertyHelper(@TKh1stOrderDiffEquationX0_R,@TKh1stOrderDiffEquationX0_W,'X0');
    RegisterPropertyHelper(@TKh1stOrderDiffEquationY0_R,@TKh1stOrderDiffEquationY0_W,'Y0');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKh2ndDerivative(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKh2ndDerivative) do
  begin
    RegisterMethod(@TKh2ndDerivative.Evaluate, 'Evaluate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKh1stDerivative(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKh1stDerivative) do
  begin
    RegisterConstructor(@TKh1stDerivative.Create, 'Create');
    RegisterMethod(@TKh1stDerivative.Evaluate, 'Evaluate');
    RegisterPropertyHelper(@TKh1stDerivativeMethod_R,@TKh1stDerivativeMethod_W,'Method');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKhFunction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhFunction) do begin
    RegisterConstructor(@TKhFunction.Create, 'Create');
    RegisterMethod(@TKhFunction.Destroy, 'Free');
    RegisterVirtualMethod(@TKhFunction.Evaluate, 'Evaluate');
    RegisterPropertyHelper(@TKhFunctionInterval_R,@TKhFunctionInterval_W,'Interval');
    RegisterPropertyHelper(@TKhFunctionStep_R,@TKhFunctionStep_W,'Step');
    RegisterPropertyHelper(@TKhFunctionOnFunction_R,@TKhFunctionOnFunction_W,'OnFunction');
    RegisterPropertyHelper(@TKhFunctionOnValue_R,@TKhFunctionOnValue_W,'OnValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKhFunctionStep(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhFunctionStep) do
  begin
    RegisterPropertyHelper(@TKhFunctionStepCount_R,@TKhFunctionStepCount_W,'Count');
    RegisterPropertyHelper(@TKhFunctionStepSize_R,@TKhFunctionStepSize_W,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKhFunctionInterval(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhFunctionInterval) do
  begin
    RegisterPropertyHelper(@TKhFunctionIntervalStart_R,@TKhFunctionIntervalStart_W,'Start');
    RegisterPropertyHelper(@TKhFunctionIntervalFinish_R,@TKhFunctionIntervalFinish_W,'Finish');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KhFunction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKhFunction) do
  RIRegister_TKhFunctionInterval(CL);
  RIRegister_TKhFunctionStep(CL);
  RIRegister_TKhFunction(CL);
  RIRegister_TKh1stDerivative(CL);
  RIRegister_TKh2ndDerivative(CL);
  RIRegister_TKh1stOrderDiffEquation(CL);
  with CL.Add(TKhXYPlotAxis) do
  with CL.Add(TKhXYPlotFunctions) do
  RIRegister_TKhXYPlot(CL);
  RIRegister_TKhXYPlotAxis(CL);
  RIRegister_TKhXYPlotFunction(CL);
  RIRegister_TKhXYPlotFunctions(CL);
end;

 
 
{ TPSImport_KhFunction }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KhFunction.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KhFunction(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KhFunction.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KhFunction(ri);
  RIRegister_KhFunction_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
