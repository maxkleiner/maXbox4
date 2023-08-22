unit uPSI_neuralplanbuilder;
{
for the CAI StateAgentAction Set    - add fix to ListStates

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
  TPSImport_neuralplanbuilder = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCompositePlan(CL: TPSPascalCompiler);
procedure SIRegister_TPlan(CL: TPSPascalCompiler);
procedure SIRegister_TActionStateList(CL: TPSPascalCompiler);
procedure SIRegister_neuralplanbuilder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCompositePlan(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPlan(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralplanbuilder_Routines(S: TPSExec);
procedure RIRegister_TActionStateList(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralplanbuilder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   neuralab
  ,neuralplanbuilder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralplanbuilder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCompositePlan(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCompositePlan') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCompositePlan') do
  begin
    RegisterProperty('Plans', 'TPlansArray', iptrw);
    RegisterProperty('Plans2', 'TPlan integer', iptrw);
    //RegisterProperty('Plans2', 'array[0..99] of TPlan integer', iptrw);
    RegisterProperty('LastUsedPlan', 'longint', iptrw);
    RegisterProperty('LastPlanedPlan', 'longint', iptrw);
    RegisterProperty('LastReceivedPlan', 'longint', iptrw);
    RegisterMethod('Procedure Init( PPred, PPredOpt : TProcPred2; PNumberActions, StateLength : longint)');
    RegisterMethod('Function Run( InitState : array of byte; deep : longint) : boolean');
    RegisterMethod('Function MultipleRun( InitState : array of byte; deep, Number : longint) : boolean');
    RegisterMethod('Function Optimize( ActState : array of byte; deep : longint) : longint');
    RegisterMethod('Procedure MultipleOptimize( ActState : array of byte; deep, Number : longint)');
    RegisterMethod('Procedure MultipleOptimizeLastUsedPlan( ActState : array of byte; deep, Number : longint)');
    RegisterMethod('Procedure ReceivePlan( var P : TActionStateList)');
    RegisterMethod('Function ToAct(ST: array of byte; var Action:byte; var LastAct:boolean; var FutureS:array of byte):boolean');
    RegisterMethod('Procedure SaveState');
    RegisterMethod('Procedure RestoreState');
    RegisterMethod('Procedure ForgetLastUsedPlan');
    RegisterMethod('Procedure InvalidateLastUsedPlan');
    RegisterMethod('Procedure CollapsePlans( X, Y : longint)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPlan(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPlan') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPlan') do
  begin
    RegisterProperty('Found', 'boolean', iptrw);
    RegisterProperty('FPlan', 'TActionStateList', iptrw);
    RegisterMethod('Procedure Init( PPred, PPredOpt : TProcPred2; PNumberActions, StateLength : longint)');
    RegisterMethod('Function Run( InitState : array of byte; deep : longint) : boolean');
    RegisterMethod('Function MultipleRun( InitState : array of byte; deep, Number : longint) : boolean');
    RegisterMethod('Function OptimizeFrom( ST, deep : longint) : longint');
    RegisterMethod('Procedure MultipleOptimizeFrom( ST, deep, Number : longint)');
    RegisterMethod('Procedure RemoveFirst');
    RegisterMethod('Function GetNextStep( CurrentState : array of byte) : longint');
    RegisterMethod('Function Action( I : longint) : byte');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Function NumStates : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionStateList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TActionStateList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TActionStateList') do
  begin
    RegisterProperty('ListStates', 'TListStatesArr', iptrw);
    RegisterProperty('ListActions', 'TListActionsArr', iptrw);
    RegisterProperty('NumStates', 'longint', iptrw);
    RegisterMethod('Procedure Init( StateLength : longint)');
    RegisterMethod('Procedure ReDoHash');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure RemoveFirst');
    RegisterMethod('Procedure Include( ST : array of byte; Action : byte)');
    RegisterMethod('Function Exists( ST : array of byte) : longint');
    RegisterMethod('Function FastExists( ST : array of byte) : longint');
    RegisterMethod('Function RemoveCicles : boolean');
    RegisterMethod('Procedure RemoveAllCicles');
    RegisterMethod('Procedure RemoveSubList( InitPos, FinishPos : longint)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralplanbuilder(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('NeuralMaxStates2','LongInt').SetInt( 400);
 CL.AddConstantN('NeuralMaxPlans2','LongInt').SetInt( 100);
  CL.AddTypeS('TNeuralState2', 'array of byte');
  //CL.AddTypeS('TNeuralState2', 'array of byte');
  //CL.AddTypeS('TPlansArray', 'array[0..99] of TPlan');
  CL.AddTypeS('TProcPred2', 'Function ( var ST : TByteArray; Action : byte) : boolean');
  //ListStates: array[0..MaxStates - 1] of TState; // list of stored states.
    //ListActions: array[0..MaxStates - 1] of byte;   // list of action on state.
  CL.AddTypeS('TListStatesArr', 'array[0..399] of TNeuralState2');
  CL.AddTypeS('TListActionsArr', 'array[0..399] of byte');
  SIRegister_TActionStateList(CL);
  CL.AddDelphiFunction('Procedure TVisitedStatesCopy( var A, B : TActionStateList)');
  SIRegister_TPlan(CL);
  CL.AddTypeS('TPlansArray', 'array[0..99] of TPlan');
  SIRegister_TCompositePlan(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCompositePlanLastReceivedPlan_W(Self: TCompositePlan; const T: longint);
Begin Self.LastReceivedPlan := T; end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanLastReceivedPlan_R(Self: TCompositePlan; var T: longint);
Begin T := Self.LastReceivedPlan; end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanLastPlanedPlan_W(Self: TCompositePlan; const T: longint);
Begin Self.LastPlanedPlan := T; end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanLastPlanedPlan_R(Self: TCompositePlan; var T: longint);
Begin T := Self.LastPlanedPlan; end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanLastUsedPlan_W(Self: TCompositePlan; const T: longint);
Begin Self.LastUsedPlan := T; end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanLastUsedPlan_R(Self: TCompositePlan; var T: longint);
Begin T := Self.LastUsedPlan; end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanPlans_W(Self: TCompositePlan; const T: integer);
Begin //Self.Plans := T; end;
end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanPlans_R(Self: TCompositePlan; var T: integer);
Begin //T := Self.Plans; end;
end;

type TPlansArray = array[0..99] of TPlan;

procedure TCompositePlanPlans_W2(Self: TCompositePlan; const T: integer; const parr: TPlan);
Begin Self.Plans[T]:= parr; end;
//end;

(*----------------------------------------------------------------------------*)
procedure TCompositePlanPlans_R2(Self: TCompositePlan; const T: integer; var parr: TPlan);
Begin parr := Self.Plans[T]; end;
//end;

(*----------------------------------------------------------------------------*)
procedure TPlanFPlan_W(Self: TPlan; const T: TActionStateList);
Begin Self.FPlan := T; end;

(*----------------------------------------------------------------------------*)
procedure TPlanFPlan_R(Self: TPlan; var T: TActionStateList);
Begin T := Self.FPlan; end;

(*----------------------------------------------------------------------------*)
procedure TPlanFound_W(Self: TPlan; const T: boolean);
Begin Self.Found := T; end;

(*----------------------------------------------------------------------------*)
procedure TPlanFound_R(Self: TPlan; var T: boolean);
Begin T := Self.Found; end;

(*----------------------------------------------------------------------------*)
procedure TActionStateListNumStates_W(Self: TActionStateList; const T: longint);
Begin Self.NumStates := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionStateListNumStates_R(Self: TActionStateList; var T: longint);
Begin T := Self.NumStates; end;

//Type TListActionsArr = array[0..399] of byte;

(*----------------------------------------------------------------------------*)
procedure TActionStateListListActions_W(Self: TActionStateList; const T: TListActionsArr);
Begin Self.ListActions := T;
end;

(*----------------------------------------------------------------------------*)
procedure TActionStateListListActions_R(Self: TActionStateList; var T: TListActionsArr);
Begin T := Self.ListActions;
end;

(*----------------------------------------------------------------------------*)
procedure TActionStateListListStates_W(Self: TActionStateList; const T: TListStatesArr);
Begin Self.ListStates := T;
end;

(*----------------------------------------------------------------------------*)
procedure TActionStateListListStates_R(Self: TActionStateList; var T: TListStatesArr);
Begin T := Self.ListStates;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCompositePlan(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCompositePlan) do
  begin
    RegisterPropertyHelper(@TCompositePlanPlans_R,@TCompositePlanPlans_W,'Plans');
    RegisterPropertyHelper(@TCompositePlanPlans_R2,@TCompositePlanPlans_W2,'Plans2');
    RegisterPropertyHelper(@TCompositePlanLastUsedPlan_R,@TCompositePlanLastUsedPlan_W,'LastUsedPlan');
    RegisterPropertyHelper(@TCompositePlanLastPlanedPlan_R,@TCompositePlanLastPlanedPlan_W,'LastPlanedPlan');
    RegisterPropertyHelper(@TCompositePlanLastReceivedPlan_R,@TCompositePlanLastReceivedPlan_W,'LastReceivedPlan');
    RegisterMethod(@TCompositePlan.Init, 'Init');
    RegisterMethod(@TCompositePlan.Run, 'Run');
    RegisterMethod(@TCompositePlan.MultipleRun, 'MultipleRun');
    RegisterMethod(@TCompositePlan.Optimize, 'Optimize');
    RegisterMethod(@TCompositePlan.MultipleOptimize, 'MultipleOptimize');
    RegisterMethod(@TCompositePlan.MultipleOptimizeLastUsedPlan, 'MultipleOptimizeLastUsedPlan');
    RegisterMethod(@TCompositePlan.ReceivePlan, 'ReceivePlan');
    RegisterMethod(@TCompositePlan.ToAct, 'ToAct');
    RegisterMethod(@TCompositePlan.SaveState, 'SaveState');
    RegisterMethod(@TCompositePlan.RestoreState, 'RestoreState');
    RegisterMethod(@TCompositePlan.ForgetLastUsedPlan, 'ForgetLastUsedPlan');
    RegisterMethod(@TCompositePlan.InvalidateLastUsedPlan, 'InvalidateLastUsedPlan');
    RegisterMethod(@TCompositePlan.CollapsePlans, 'CollapsePlans');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPlan(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPlan) do
  begin
    RegisterPropertyHelper(@TPlanFound_R,@TPlanFound_W,'Found');
    RegisterPropertyHelper(@TPlanFPlan_R,@TPlanFPlan_W,'FPlan');
    RegisterMethod(@TPlan.Init, 'Init');
    RegisterMethod(@TPlan.Run, 'Run');
    RegisterMethod(@TPlan.MultipleRun, 'MultipleRun');
    RegisterMethod(@TPlan.OptimizeFrom, 'OptimizeFrom');
    RegisterMethod(@TPlan.MultipleOptimizeFrom, 'MultipleOptimizeFrom');
    RegisterMethod(@TPlan.RemoveFirst, 'RemoveFirst');
    RegisterMethod(@TPlan.GetNextStep, 'GetNextStep');
    RegisterMethod(@TPlan.Action, 'Action');
    RegisterMethod(@TPlan.Invalidate, 'Invalidate');
    RegisterMethod(@TPlan.NumStates, 'NumStates');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralplanbuilder_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TVisitedStatesCopy, 'TVisitedStatesCopy', cdRegister);
  //RIRegister_TPlan(CL);
  //RIRegister_TCompositePlan(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionStateList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionStateList) do
  begin
    RegisterPropertyHelper(@TActionStateListListStates_R,@TActionStateListListStates_W,'ListStates');
    RegisterPropertyHelper(@TActionStateListListActions_R,@TActionStateListListActions_W,'ListActions');
    RegisterPropertyHelper(@TActionStateListNumStates_R,@TActionStateListNumStates_W,'NumStates');
    RegisterMethod(@TActionStateList.Init, 'Init');
    RegisterMethod(@TActionStateList.ReDoHash, 'ReDoHash');
    RegisterMethod(@TActionStateList.Clear, 'Clear');
    RegisterMethod(@TActionStateList.RemoveFirst, 'RemoveFirst');
    RegisterMethod(@TActionStateList.Include, 'Include');
    RegisterMethod(@TActionStateList.Exists, 'Exists');
    RegisterMethod(@TActionStateList.FastExists, 'FastExists');
    RegisterMethod(@TActionStateList.RemoveCicles, 'RemoveCicles');
    RegisterMethod(@TActionStateList.RemoveAllCicles, 'RemoveAllCicles');
    RegisterMethod(@TActionStateList.RemoveSubList, 'RemoveSubList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralplanbuilder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TActionStateList(CL);
  RIRegister_TPlan(CL);
  RIRegister_TCompositePlan(CL);
end;

 
 
{ TPSImport_neuralplanbuilder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralplanbuilder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralplanbuilder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralplanbuilder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralplanbuilder(ri);
  RIRegister_neuralplanbuilder_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
