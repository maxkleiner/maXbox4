unit uPSI_AINNNeuron;
{
teach and train

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
  TPSImport_AINNNeuron = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNeuronClass(CL: TPSPascalCompiler);
procedure SIRegister_AINNNeuron(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TNeuronClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_AINNNeuron(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   AINNNeuron
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AINNNeuron]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuronClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TNeuronClass') do
  with CL.AddClassN(CL.FindClass('TObject'),'TNeuronClass') do
  begin
    RegisterMethod('Constructor Create( aInputCount : Integer)');
    RegisterMethod('Procedure RandomInitialize');
    RegisterProperty('Load', 'Single', iptr);
    RegisterProperty('Output', 'Single', iptr);
    RegisterProperty('Threshold', 'Single', iptrw);
    RegisterProperty('Inputs', 'Single Integer', iptrw);
    RegisterProperty('Weights', 'Single Integer', iptrw);
    RegisterProperty('InputCount', 'Integer', iptrw);
    RegisterProperty('AnalogOutput', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AINNNeuron(CL: TPSPascalCompiler);
begin
  SIRegister_TNeuronClass(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNeuronClassAnalogOutput_W(Self: TNeuronClass; const T: Boolean);
begin Self.AnalogOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassAnalogOutput_R(Self: TNeuronClass; var T: Boolean);
begin T := Self.AnalogOutput; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassInputCount_W(Self: TNeuronClass; const T: Integer);
begin Self.InputCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassInputCount_R(Self: TNeuronClass; var T: Integer);
begin T := Self.InputCount; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassWeights_W(Self: TNeuronClass; const T: Single; const t1: Integer);
begin Self.Weights[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassWeights_R(Self: TNeuronClass; var T: Single; const t1: Integer);
begin T := Self.Weights[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassInputs_W(Self: TNeuronClass; const T: Single; const t1: Integer);
begin Self.Inputs[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassInputs_R(Self: TNeuronClass; var T: Single; const t1: Integer);
begin T := Self.Inputs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassThreshold_W(Self: TNeuronClass; const T: Single);
begin Self.Threshold := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassThreshold_R(Self: TNeuronClass; var T: Single);
begin T := Self.Threshold; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassOutput_R(Self: TNeuronClass; var T: Single);
begin T := Self.Output; end;

(*----------------------------------------------------------------------------*)
procedure TNeuronClassLoad_R(Self: TNeuronClass; var T: Single);
begin T := Self.Load; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuronClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuronClass) do
  begin
    RegisterConstructor(@TNeuronClass.Create, 'Create');
    RegisterMethod(@TNeuronClass.RandomInitialize, 'RandomInitialize');
    RegisterPropertyHelper(@TNeuronClassLoad_R,nil,'Load');
    RegisterPropertyHelper(@TNeuronClassOutput_R,nil,'Output');
    RegisterPropertyHelper(@TNeuronClassThreshold_R,@TNeuronClassThreshold_W,'Threshold');
    RegisterPropertyHelper(@TNeuronClassInputs_R,@TNeuronClassInputs_W,'Inputs');
    RegisterPropertyHelper(@TNeuronClassWeights_R,@TNeuronClassWeights_W,'Weights');
    RegisterPropertyHelper(@TNeuronClassInputCount_R,@TNeuronClassInputCount_W,'InputCount');
    RegisterPropertyHelper(@TNeuronClassAnalogOutput_R,@TNeuronClassAnalogOutput_W,'AnalogOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AINNNeuron(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNeuronClass(CL);
end;

 
 
{ TPSImport_AINNNeuron }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AINNNeuron.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AINNNeuron(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AINNNeuron.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AINNNeuron(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
