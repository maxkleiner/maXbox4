unit uPSI_FannNetwork;
{
the big neural net for python and pascal framwork neurowork
  load dll dynamically mX4

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
  TPSImport_FannNetwork = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFannNetwork(CL: TPSPascalCompiler);
procedure SIRegister_FannNetwork(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FannNetwork_Routines(S: TPSExec);
procedure RIRegister_TFannNetwork(CL: TPSRuntimeClassImporter);
procedure RIRegister_FannNetwork(CL: TPSRuntimeClassImporter);
procedure RIRegister_FANN_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Fann
  ,FannNetwork
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FannNetwork]);
end;


procedure TFannNetworkRun(Inputs: array of fann_type;
  var Outputs: array of fann_type);
var O: Pfann_type_array;
    i: integer;
begin
        //if not pBuilt then
          //     raise Exception.Create('The network has not been built');

      { O:=fann_run(ann,@Inputs[0]);

        for i:=0 to High(outputs) do
        begin
            Outputs[i]:=O[i];
        end;  }

end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFannNetwork(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TFannNetwork') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TFannNetwork') do begin
    RegisterMethod('Constructor Create( Aowner : TComponent)');
    RegisterMethod('Procedure Build( )');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure UnBuild( )');
    RegisterMethod('Function Train( Input : array of fann_type; Output : array of fann_type) : single');
    RegisterMethod('Procedure TrainOnFile( FileName : String; MaxEpochs : Cardinal; DesiredError : Single)');
    RegisterMethod('Procedure Run( Inputs : array of fann_type; var Outputs : TFann_Type_Array2)');
    RegisterMethod('Procedure Run2( Inputs : array of fann_type; var Outputs : array of fann_type)');
    RegisterMethod('Procedure Run3( Inputs : array of fann_type; var Outputs : TFann_Type_Array3)');
    RegisterMethod('Procedure Run4( Inputs : array of fann_type; var Outputs : TFann_Type_Array3)');

    RegisterMethod('Procedure SaveToFile( FileName : String)');
    RegisterMethod('Procedure LoadFromFile( Filename : string)');
    RegisterProperty('FannObject', 'PFann', iptr);
    RegisterProperty('Layers', 'TStrings', iptrw);
    RegisterProperty('LearningRate', 'Single', iptrw);
    RegisterProperty('ConnectionRate', 'Single', iptrw);
    RegisterProperty('LearningMometum', 'single', iptrw);
    RegisterProperty('MSE', 'Single', iptr);
    RegisterProperty('TrainingAlgorithm', 'TTrainingAlgorithm', iptrw);
    RegisterProperty('ActivationFunctionHidden', 'TActivationFunction', iptrw);
    RegisterProperty('ActivationFunctionOutput', 'TActivationFunction', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FannNetwork(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('PCardinalArray', '^CardinalArray // will not work');
  CL.AddConstantN('DLL_FILE','String').SetString( 'fannfloat.dll');

  CL.AddTypeS('fann_type', 'single');
  CL.AddTypeS('Fann_Type_Array', 'array [0..65535] of fann_type');
  CL.AddTypeS('TFann_Type_Array', 'array [0..65535] of fann_type');
  CL.AddTypeS('TFann_Type_Array2', 'array of fann_type');
  CL.AddTypeS('TFann_Type_Array3', 'array of single');

  CL.AddTypeS('TTrainingAlgorithm', '( taFANN_TRAIN_INCREMENTAL, taFANN_TRAIN_B'
   +'ATCH, taFANN_TRAIN_RPROP, taFANN_TRAIN_QUICKPROP )');
  CL.AddTypeS('TActivationFunction', '( afFANN_LINEAR, afFANN_THRESHOLD, afFANN'
   +'_THRESHOLD_SYMMETRIC, afFANN_SIGMOID, afFANN_SIGMOID_STEPWISE, afFANN_SIGM'
   +'OID_SYMMETRIC, afFANN_SIGMOID_SYMMETRIC_STEPWISE, afFANN_GAUSSIAN, afFANN_'
   +'GAUSSIAN_SYMMETRIC, afFANN_GAUSSIAN_STEPWISE, afFANN_ELLIOT, afFANN_ELLIOT'
   +'_SYMMETRIC, afFANN_LINEAR_PIECE, afFANN_LINEAR_PIECE_SYMMETRIC, afFANN_SIN'
   +'_SYMMETRIC, afFANN_COS_SYMMETRIC, afFANN_SIN, afFANN_COS )');
  SIRegister_TFannNetwork(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFannNetworkActivationFunctionOutput_W(Self: TFannNetwork; const T: TActivationFunction);
begin Self.ActivationFunctionOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkActivationFunctionOutput_R(Self: TFannNetwork; var T: TActivationFunction);
begin T := Self.ActivationFunctionOutput; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkActivationFunctionHidden_W(Self: TFannNetwork; const T: TActivationFunction);
begin Self.ActivationFunctionHidden := T; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkActivationFunctionHidden_R(Self: TFannNetwork; var T: TActivationFunction);
begin T := Self.ActivationFunctionHidden; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkTrainingAlgorithm_W(Self: TFannNetwork; const T: TTrainingAlgorithm);
begin Self.TrainingAlgorithm := T; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkTrainingAlgorithm_R(Self: TFannNetwork; var T: TTrainingAlgorithm);
begin T := Self.TrainingAlgorithm; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkMSE_R(Self: TFannNetwork; var T: Single);
begin T := Self.MSE; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkLearningMometum_W(Self: TFannNetwork; const T: single);
begin Self.LearningMometum := T; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkLearningMometum_R(Self: TFannNetwork; var T: single);
begin T := Self.LearningMometum; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkConnectionRate_W(Self: TFannNetwork; const T: Single);
begin Self.ConnectionRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkConnectionRate_R(Self: TFannNetwork; var T: Single);
begin T := Self.ConnectionRate; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkLearningRate_W(Self: TFannNetwork; const T: Single);
begin Self.LearningRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkLearningRate_R(Self: TFannNetwork; var T: Single);
begin T := Self.LearningRate; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkLayers_W(Self: TFannNetwork; const T: TStrings);
begin Self.Layers := T; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkLayers_R(Self: TFannNetwork; var T: TStrings);
begin T := Self.Layers; end;

(*----------------------------------------------------------------------------*)
procedure TFannNetworkFannObject_R(Self: TFannNetwork; var T: PFann);
begin T := Self.FannObject; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FannNetwork_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFannNetwork(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFannNetwork) do begin
    RegisterConstructor(@TFannNetwork.Create, 'Create');
    RegisterMethod(@TFannNetwork.Destroy, 'Free');
    RegisterMethod(@TFannNetwork.Build, 'Build');
    RegisterMethod(@TFannNetwork.UnBuild, 'UnBuild');
    RegisterMethod(@TFannNetwork.Train, 'Train');
    RegisterMethod(@TFannNetwork.TrainOnFile, 'TrainOnFile');
    RegisterMethod(@TFannNetwork.Run, 'Run');
    RegisterMethod(@TFannNetwork.Run, 'Run2');
    RegisterMethod(@TFannNetwork.Run, 'Run3');
    RegisterMethod(@TFannNetwork.Run4, 'Run4');

    RegisterMethod(@TFannNetwork.SaveToFile, 'SaveToFile');
    RegisterMethod(@TFannNetwork.LoadFromFile, 'LoadFromFile');
    RegisterPropertyHelper(@TFannNetworkFannObject_R,nil,'FannObject');
    RegisterPropertyHelper(@TFannNetworkLayers_R,@TFannNetworkLayers_W,'Layers');
    RegisterPropertyHelper(@TFannNetworkLearningRate_R,@TFannNetworkLearningRate_W,'LearningRate');
    RegisterPropertyHelper(@TFannNetworkConnectionRate_R,@TFannNetworkConnectionRate_W,'ConnectionRate');
    RegisterPropertyHelper(@TFannNetworkLearningMometum_R,@TFannNetworkLearningMometum_W,'LearningMometum');
    RegisterPropertyHelper(@TFannNetworkMSE_R,nil,'MSE');
    RegisterPropertyHelper(@TFannNetworkTrainingAlgorithm_R,@TFannNetworkTrainingAlgorithm_W,'TrainingAlgorithm');
    RegisterPropertyHelper(@TFannNetworkActivationFunctionHidden_R,@TFannNetworkActivationFunctionHidden_W,'ActivationFunctionHidden');
    RegisterPropertyHelper(@TFannNetworkActivationFunctionOutput_R,@TFannNetworkActivationFunctionOutput_W,'ActivationFunctionOutput');
  end;
end;

procedure RIRegister_FANN_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@fann_create_standard, 'fann_create_standard', CdCdecl);
 S.RegisterDelphiFunction(@fann_create_sparse, 'fann_create_sparse', CdCdecl);
 S.RegisterDelphiFunction(@fann_create_shortcut, 'fann_create_shortcut', CdCdecl);
 S.RegisterDelphiFunction(@fann_create_standard_array, 'fann_create_standard_array', CdCdecl);
 S.RegisterDelphiFunction(@fann_create_sparse_array, 'fann_create_sparse_array', CdCdecl);
 S.RegisterDelphiFunction(@fann_create_shortcut_array, 'fann_create_shortcut_array', CdCdecl);
 S.RegisterDelphiFunction(@fann_destroy, 'fann_destroy', CdCdecl);
 S.RegisterDelphiFunction(@fann_run, 'fann_run', CdCdecl);
 S.RegisterDelphiFunction(@fann_randomize_weights, 'fann_randomize_weights', CdCdecl);
 S.RegisterDelphiFunction(@fann_init_weights, 'fann_init_weights', CdCdecl);
 S.RegisterDelphiFunction(@fann_print_connections, 'fann_print_connections', CdCdecl);
 S.RegisterDelphiFunction(@fann_print_parameters, 'fann_print_parameters', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_num_input, 'fann_get_num_input', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_num_output, 'fann_get_num_output', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_total_neurons, 'fann_get_total_neurons', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_total_connections, 'fann_get_total_connections', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_network_type, 'fann_get_network_type', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_connection_rate, 'fann_get_connection_rate', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_num_layers, 'fann_get_num_layers', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_layer_array, 'fann_get_layer_array', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_bias_array, 'fann_get_bias_array', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_connection_array, 'fann_get_connection_array', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_weight_array, 'fann_set_weight_array', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_weight, 'fann_set_weight', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_user_data, 'fann_set_user_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_user_data, 'fann_get_user_data', CdCdecl);
 //S.RegisterDelphiFunction(@fann_get_decimal_point, 'fann_get_decimal_point', CdCdecl);
 //S.RegisterDelphiFunction(@fann_get_multiplier, 'fann_get_multiplier', CdCdecl);
 S.RegisterDelphiFunction(@fann_create_from_file, 'fann_create_from_file', CdCdecl);
 S.RegisterDelphiFunction(@fann_save, 'fann_save', CdCdecl);
 S.RegisterDelphiFunction(@fann_save_to_fixed, 'fann_save_to_fixed', CdCdecl);
 S.RegisterDelphiFunction(@fann_train, 'fann_train', CdCdecl);
 S.RegisterDelphiFunction(@fann_test, 'fann_test', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_MSE, 'fann_get_MSE', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_bit_fail, 'fann_get_bit_fail', CdCdecl);
 S.RegisterDelphiFunction(@fann_reset_MSE, 'fann_reset_MSE', CdCdecl);
 S.RegisterDelphiFunction(@fann_train_on_data, 'fann_train_on_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_train_on_file, 'fann_train_on_file', CdCdecl);
 S.RegisterDelphiFunction(@fann_train_epoch, 'fann_train_epoch', CdCdecl);
 S.RegisterDelphiFunction(@fann_test_data, 'fann_test_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_read_train_from_file, 'fann_read_train_from_file', CdCdecl);
 S.RegisterDelphiFunction(@fann_create_train_from_callback, 'fann_create_train_from_callback', CdCdecl);
 S.RegisterDelphiFunction(@fann_destroy_train, 'fann_destroy_train', CdCdecl);
 S.RegisterDelphiFunction(@fann_shuffle_train_data, 'fann_shuffle_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_scale_train, 'fann_scale_train', CdCdecl);
 S.RegisterDelphiFunction(@fann_descale_train, 'fann_descale_train', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_input_scaling_params, 'fann_set_input_scaling_params', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_output_scaling_params, 'fann_set_output_scaling_params', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_scaling_params, 'fann_set_scaling_params', CdCdecl);
 S.RegisterDelphiFunction(@fann_clear_scaling_params, 'fann_clear_scaling_params', CdCdecl);
 S.RegisterDelphiFunction(@fann_scale_input, 'fann_scale_input', CdCdecl);
 S.RegisterDelphiFunction(@fann_scale_output, 'fann_scale_output', CdCdecl);
 S.RegisterDelphiFunction(@fann_descale_input, 'fann_descale_input', CdCdecl);
 S.RegisterDelphiFunction(@fann_descale_output, 'fann_descale_output', CdCdecl);
 S.RegisterDelphiFunction(@fann_scale_input_train_data, 'fann_scale_input_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_scale_output_train_data, 'fann_scale_output_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_scale_train_data, 'fann_scale_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_merge_train_data, 'fann_merge_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_duplicate_train_data, 'fann_duplicate_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_subset_train_data, 'fann_subset_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_length_train_data, 'fann_length_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_num_input_train_data, 'fann_num_input_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_num_output_train_data, 'fann_num_output_train_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_save_train, 'fann_save_train', CdCdecl);
 S.RegisterDelphiFunction(@fann_save_train_to_fixed, 'fann_save_train_to_fixed', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_training_algorithm, 'fann_get_training_algorithm', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_training_algorithm, 'fann_set_training_algorithm', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_learning_rate, 'fann_get_learning_rate', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_learning_rate, 'fann_set_learning_rate', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_learning_momentum, 'fann_get_learning_momentum', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_learning_momentum, 'fann_set_learning_momentum', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_activation_function, 'fann_get_activation_function', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_function, 'fann_set_activation_function', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_function_layer, 'fann_set_activation_function_layer', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_function_hidden, 'fann_set_activation_function_hidden', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_function_output, 'fann_set_activation_function_output', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_activation_steepness, 'fann_get_activation_steepness', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_steepness, 'fann_set_activation_steepness', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_steepness_layer, 'fann_set_activation_steepness_layer', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_steepness_hidden, 'fann_set_activation_steepness_hidden', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_activation_steepness_output, 'fann_set_activation_steepness_output', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_train_error_function, 'fann_get_train_error_function', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_train_error_function, 'fann_set_train_error_function', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_train_stop_function, 'fann_get_train_stop_function', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_train_stop_function, 'fann_set_train_stop_function', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_bit_fail_limit, 'fann_get_bit_fail_limit', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_bit_fail_limit, 'fann_set_bit_fail_limit', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_callback, 'fann_set_callback', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_quickprop_decay, 'fann_get_quickprop_decay', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_quickprop_decay, 'fann_set_quickprop_decay', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_quickprop_mu, 'fann_get_quickprop_mu', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_quickprop_mu, 'fann_set_quickprop_mu', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_rprop_increase_factor, 'fann_get_rprop_increase_factor', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_rprop_increase_factor, 'fann_set_rprop_increase_factor', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_rprop_decrease_factor, 'fann_get_rprop_decrease_factor', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_rprop_decrease_factor, 'fann_set_rprop_decrease_factor', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_rprop_delta_min, 'fann_get_rprop_delta_min', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_rprop_delta_min, 'fann_set_rprop_delta_min', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_rprop_delta_max, 'fann_get_rprop_delta_max', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_rprop_delta_max, 'fann_set_rprop_delta_max', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_rprop_delta_zero, 'fann_get_rprop_delta_zero', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_rprop_delta_zero, 'fann_set_rprop_delta_zero', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_error_log, 'fann_set_error_log', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_errno, 'fann_get_errno', CdCdecl);
 S.RegisterDelphiFunction(@fann_reset_errno, 'fann_reset_errno', CdCdecl);
 S.RegisterDelphiFunction(@fann_reset_errstr, 'fann_reset_errstr', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_errstr, 'fann_get_errstr', CdCdecl);
 S.RegisterDelphiFunction(@fann_print_error, 'fann_print_error', CdCdecl);
 S.RegisterDelphiFunction(@fann_cascadetrain_on_data, 'fann_cascadetrain_on_data', CdCdecl);
 S.RegisterDelphiFunction(@fann_cascadetrain_on_file, 'fann_cascadetrain_on_file', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_output_change_fraction, 'fann_get_cascade_output_change_fraction', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_output_change_fraction, 'fann_set_cascade_output_change_fraction', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_output_stagnation_epochs, 'fann_get_cascade_output_stagnation_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_output_stagnation_epochs, 'fann_set_cascade_output_stagnation_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_candidate_change_fraction, 'fann_get_cascade_candidate_change_fraction', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_candidate_change_fraction, 'fann_set_cascade_candidate_change_fraction', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_candidate_stagnation_epochs, 'fann_get_cascade_candidate_stagnation_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_candidate_stagnation_epochs, 'fann_set_cascade_candidate_stagnation_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_weight_multiplier, 'fann_get_cascade_weight_multiplier', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_weight_multiplier, 'fann_set_cascade_weight_multiplier', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_candidate_limit, 'fann_get_cascade_candidate_limit', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_candidate_limit, 'fann_set_cascade_candidate_limit', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_max_out_epochs, 'fann_get_cascade_max_out_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_max_out_epochs, 'fann_set_cascade_max_out_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_max_cand_epochs, 'fann_get_cascade_max_cand_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_max_cand_epochs, 'fann_set_cascade_max_cand_epochs', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_num_candidates, 'fann_get_cascade_num_candidates', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_activation_functions_count, 'fann_get_cascade_activation_functions_count', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_activation_functions, 'fann_get_cascade_activation_functions', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_activation_functions, 'fann_set_cascade_activation_functions', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_activation_steepnesses_count, 'fann_get_cascade_activation_steepnesses_count', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_activation_steepnesses, 'fann_get_cascade_activation_steepnesses', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_activation_steepnesses, 'fann_set_cascade_activation_steepnesses', CdCdecl);
 S.RegisterDelphiFunction(@fann_get_cascade_num_candidate_groups, 'fann_get_cascade_num_candidate_groups', CdCdecl);
 S.RegisterDelphiFunction(@fann_set_cascade_num_candidate_groups, 'fann_set_cascade_num_candidate_groups', CdCdecl);
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_FannNetwork(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFannNetwork(CL);
end;

 
 
{ TPSImport_FannNetwork }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FannNetwork.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FannNetwork(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FannNetwork.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FannNetwork(ri);
  RIRegister_FannNetwork_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
