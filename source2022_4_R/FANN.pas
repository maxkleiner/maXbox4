unit FANN;

interface

{*******************************************************

  Only Delphi 6 and above supports variable arguments
  functions.
  If you are using a older version of Delphi comment the
  VARIABLE_ARGUMENTS directive.
  If you disable the VARIABLE_ARGUMENTS directive the
  following functions will not be available:
    fann_create_shortcut
    fann_create_sparse
    fann_create_standard

********************************************************}

{$DEFINE VARIABLE_ARGUMENTS}

{*******************************************************

  If you want to use Fixed Fann or Double Fann please
  uncomment the corresponding definition.
  As default fann.pas uses the fannfloat dll.

********************************************************}
//{$DEFINE FIXEDFANN} //Uncomment for fixed fann
//{$DEFINE DOUBLEFANN} //Uncomment for double fann








{$IF Defined(FIXEDFANN)}
const DLL_FILE = 'fannfixed.dll';
{$ELSEIF Defined(DOUBLEFANN)}
const DLL_FILE = 'fanndouble.dll';
{$ELSE}
const DLL_FILE = 'fannfloat.dll';
{$IFEND}

type

        {$IF Defined(FIXEDFANN)}
        fann_type = integer;
        {$ELSEIF Defined(DOUBLEFANN)}
        fann_type = double;
        {$ELSE}
        fann_type = single;
        {$IFEND}


        PFann_Type = ^fann_type;

        PPFann_Type = ^pfann_type;

        Fann_Type_Array = array [0..65535] of fann_type;

        PFann_Type_Array = ^Fann_type_array;

        PPFann_Type_Array = array [0..65535] of ^Fann_Type_Array;

      


        (* MICROSOFT VC++ STDIO'S FILE DEFINITION*)
        _iobuf = packed record
                _ptr: Pchar;
                _cnt: integer;
                _base: Pchar;
                _flag: integer;
                _file: integer;
                _charbuf: integer;
                _bufsiz: integer;
                _tmpfname: Pchar;
        end;


        PFile = ^TFile;
        TFile = _iobuf;


        PPFann_Neuron = ^PFann_Neuron;
        PFann_Neuron = ^TFann_Neuron;
        TFann_Neuron = packed record
                first_con: Cardinal;
                last_con: Cardinal;
                sum: fann_type;
                value: fann_type;
                activation_steepness: fann_type;
                activation_function: Cardinal; //enum
        end;


        PFann_Layer = ^TFann_Layer;
        TFann_Layer = packed record
                first_neuron: PFann_Neuron;
                last_neuron: PFann_Neuron;
        end;

        PFann = ^TFann;
        TFann = packed record
                errno_f: cardinal;
                error_log: PFile;
                errstr: Pchar;

                learning_rate: single;
                learning_momentum: single;
                connection_rate: single;

                network_type: Cardinal; //ENUM

                first_layer: PFann_Layer;
                last_layer: PFann_Layer;

                total_neurons: cardinal;
                num_input: cardinal;
                num_output: cardinal;

                weights: Pfann_type;

                connections: PPFann_Neuron;

                train_errors: Pfann_type;

                training_algorithm: cardinal; //ENUM


                {$IFDEF FIXEDFANN}
                 decimal_point: cardinal;
                 multiplier: cardinal;

                 sigmoid_results: array [0..5] of fann_type;
                 sigmoid_values: array [0..5] of fann_type;
                 symmetric_results: array [0..5] of fann_type;
                 symmetric_values: array [0..5] of fann_type;

                {$ENDIF}

                total_connections: cardinal;
                output: pfann_type;

                num_MSE: cardinal;
                MSE_value: single;

                num_bit_fail: cardinal;
                bit_fail_limit: fann_type;

                train_error_function: cardinal;//enum
                train_stop_function: cardinal; //enum

                callback: Pointer; //TFANN_CALLBACK

                user_data: Pointer;

                cascade_output_change_fraction: single;
                cascade_output_stagnation_epochs: Cardinal;
                cascade_candidate_change_fraction: single;
                cascade_candidate_stagnation_epochs: Cardinal;
                cascade_best_candidate: Cardinal;

                cascade_candidate_limit: fann_type;
                cascade_weight_multiplier: fann_type;

                cascade_max_out_epochs: Cardinal;
                cascade_max_cand_epochs: Cardinal;

                cascade_activation_functions: PCardinal;
                cascade_activation_functions_count: Cardinal;

                cascade_activation_steepnesses: PFann_Type;

                cascade_activation_steepnesses_count: Cardinal;
                cascade_num_candidate_groups: Cardinal;

                cascade_candidate_scores: PFann_Type;

                total_neurons_allocated: Cardinal;
                total_connections_allocated: Cardinal;



                quickprop_decay: single;
                quickprop_mu: single;

                rprop_increase_factor: single;
                rprop_decrease_factor: single;

                rprop_delta_min: single;
                rprop_delta_max: single;

                rprop_delta_zero: single;

                train_slopes: pfann_type;

                prev_steps: pfann_type;

                prev_train_slopes: pfann_type;

                prev_weights_deltas: pfann_type;

                {$IFNDEF FIXEDFANN}
                scale_mean_in: psingle;
                scale_deviation_in: psingle;
                scale_new_min_in: psingle;
                scale_factor_in: psingle;
                scale_mean_out: psingle;
                scale_deviation_out: psingle;
                scale_new_min_out: psingle;
                scale_factor_out: psingle;

                {$ENDIF}
        end;

        PFann_Train_Data = ^TFann_Train_Data;
        TFann_Train_Data = packed record
                errno_f: cardinal;
                erro_log: PFile;
                errstr: Pchar;
                num_data: cardinal;
                num_input: cardinal;
                num_ouput: cardinal;
                input: PPFann_Type_Array;
                output: PPFann_Type_Array;
        end;

        PFann_Connection = ^TFann_Connection;
        TFann_Connection = packed record
                from_neuron: Cardinal;
                to_neuron: Cardinal;
                weight: fann_type;
        end;

        PFann_Error = ^TFann_Error;
        TFann_Error = packed record
                errno_f: Cardinal; //Enum
                error_log: PFile;
                errstr: PChar;
        end;


        //_Fann_Train =
        const

          	FANN_TRAIN_INCREMENTAL = 0;
	          FANN_TRAIN_BATCH = 1;
	          FANN_TRAIN_RPROP = 2;
            FANN_TRAIN_QUICKPROP = 3;


        //_Fann_Error_Func =

            FANN_ERRORFUNC_LINEAR = 0;
            FANN_ERRORFUNC_TANH = 1;


        //_Fann_Activation_Func =
            FANN_LINEAR = 0;
            FANN_THRESHOLD = 1;
	          FANN_THRESHOLD_SYMMETRIC = 2;
            FANN_SIGMOID = 3;
            FANN_SIGMOID_STEPWISE = 4;
            FANN_SIGMOID_SYMMETRIC = 5;
            FANN_SIGMOID_SYMMETRIC_STEPWISE = 6;
            FANN_GAUSSIAN = 7;
            FANN_GAUSSIAN_SYMMETRIC = 8;
            FANN_GAUSSIAN_STEPWISE = 9;
            FANN_ELLIOT = 10;
            FANN_ELLIOT_SYMMETRIC = 11;
            FANN_LINEAR_PIECE = 12;
            FANN_LINEAR_PIECE_SYMMETRIC = 13;
            FANN_SIN_SYMMETRIC = 14;
            FANN_COS_SYMMETRIC = 15;
            FANN_SIN = 16;
            FANN_COS = 17;


        //_Fann_ErroNo =
          	FANN_E_NO_ERROR = 0;
	          FANN_E_CANT_OPEN_CONFIG_R = 1;
          	FANN_E_CANT_OPEN_CONFIG_W = 2;
          	FANN_E_WRONG_CONFIG_VERSION = 3;
          	FANN_E_CANT_READ_CONFIG = 4;
          	FANN_E_CANT_READ_NEURON = 5;
          	FANN_E_CANT_READ_CONNECTIONS = 6;
          	FANN_E_WRONG_NUM_CONNECTIONS = 7;
          	FANN_E_CANT_OPEN_TD_W = 8;
          	FANN_E_CANT_OPEN_TD_R = 9;
          	FANN_E_CANT_READ_TD = 10;
          	FANN_E_CANT_ALLOCATE_MEM = 11;
          	FANN_E_CANT_TRAIN_ACTIVATION = 12;
          	FANN_E_CANT_USE_ACTIVATION = 13;
          	FANN_E_TRAIN_DATA_MISMATCH = 14;
          	FANN_E_CANT_USE_TRAIN_ALG = 15;
          	FANN_E_TRAIN_DATA_SUBSET = 16;
          	FANN_E_INDEX_OUT_OF_BOUND = 17;
          	FANN_E_SCALE_NOT_PRESENT = 18;


        //_Fann_Stop_Func =

            FANN_STOPFUNC_MSE = 0;
            FANN_STOPFUNC_BIT = 1;

        //_Fann_Net_Type =
            FANN_NETTYPE_LAYER = 0;
            FANN_NETTYPE_SHORTCUT = 1;

        type

        TFann_CallBack = function(Ann: PFann;
                                  train: PFann_Train_Data;
                                  max_epochs: Cardinal;
                                  epochs_between_reports: cardinal;
                                  desired_error: single;
                                  epochs: cardinal): integer; cdecl;

        TUser_Function = procedure(num: Cardinal;
                                  num_input: Cardinal;
                                  num_output: cardinal;
                                  input: PFann_Type;
                                  output: PFann_Type); cdecl;


                                                  

var
        FANN_ERRORFUNC_NAMES: array [0..1] of string = (
        	'FANN_ERRORFUNC_LINEAR',
	        'FANN_ERRORFUNC_TANH'
        );

        FANN_TRAIN_NAMES: array [0..3] of string =
        (
	        'FANN_TRAIN_INCREMENTAL',
	        'FANN_TRAIN_BATCH',
	        'FANN_TRAIN_RPROP',
	        'FANN_TRAIN_QUICKPROP'
        );

        FANN_ACTIVATIONFUNC_NAMES: array [0..17] of string =
        (
          	'FANN_LINEAR',
	          'FANN_THRESHOLD',
          	'FANN_THRESHOLD_SYMMETRIC',
          	'FANN_SIGMOID',
          	'FANN_SIGMOID_STEPWISE',
          	'FANN_SIGMOID_SYMMETRIC',
          	'FANN_SIGMOID_SYMMETRIC_STEPWISE',
          	'FANN_GAUSSIAN',
          	'FANN_GAUSSIAN_SYMMETRIC',
          	'FANN_GAUSSIAN_STEPWISE',
          	'FANN_ELLIOT',
          	'FANN_ELLIOT_SYMMETRIC',
          	'FANN_LINEAR_PIECE',
          	'FANN_LINEAR_PIECE_SYMMETRIC',
          	'FANN_SIN_SYMMETRIC',
          	'FANN_COS_SYMMETRIC',
          	'FANN_SIN',
          	'FANN_COS'
        );

        FANN_STOPFUNC_NAMES: array [0..1] of string =
        (
	          'FANN_STOPFUNC_MSE',
	          'FANN_STOPFUNC_BIT'
        );

        FANN_NETTYPE_NAMES: array [0..1] of string =
        (
	          'FANN_NETTYPE_LAYER',
	          'FANN_NETTYPE_SHORTCUT'
        );


        //DECLARATIONS FROM FANN.H

        {$IFDEF VARIABLE_ARGUMENTS}

        {

          ATTENTION!
          If your compilation breaks here maybe you are using a version of Delphi
          prior to 6. In this case you should comment the VARIABLE_ARGUMENTS define
          at the beginning of this file and live without this functions!

        }
        function fann_create_standard(num_layers: Cardinal): PFann; cdecl; varargs;

        function fann_create_sparse(connection_rate: single; num_layers: Cardinal): PFann; cdecl; varargs;
       
        function fann_create_shortcut(connection_rate: single): PFann; cdecl; varargs;


        {$ENDIF}


        function fann_create_standard_array(num_layers: Cardinal; const layers: PCardinal): PFann; cdecl;

        function fann_create_sparse_array(connection_rate: single; num_layers: Cardinal; const layers: PCardinal): PFann; cdecl;

        function fann_create_shortcut_array(num_layers: cardinal;const layers: Pcardinal): PFann; cdecl;


        procedure fann_destroy(Ann: PFann); cdecl;


        function fann_run(ann: PFann; input: PFann_Type): Pfann_type_array; cdecl;


        procedure fann_randomize_weights(Ann: PFann; Min_weight: fann_type; Max_weight: fann_type); cdecl;

        procedure fann_init_weights(Ann: PFann; train_data: PFann_Train_Data); cdecl;


        procedure fann_print_connections(ann: PFann);cdecl;

        procedure fann_print_parameters(ann: PFann);cdecl;


        function fann_get_num_input(Ann: PFann): cardinal;cdecl;

        function fann_get_num_output(Ann: PFann): cardinal;cdecl;

        function fann_get_total_neurons(Ann: PFann): cardinal; cdecl;

        function fann_get_total_connections(Ann: PFann): cardinal; cdecl;


        function fann_get_network_type(Ann: PFann): cardinal; cdecl;

        function fann_get_connection_rate(Ann: PFann): single; cdecl;


        function fann_get_num_layers(Ann: PFann): cardinal; cdecl;


        procedure fann_get_layer_array(Ann: PFann; layers: PCardinal); cdecl;

        procedure fann_get_bias_array(Ann: PFann; bias: PCardinal);cdecl;


        procedure fann_get_connection_array(Ann: PFann; connections: PFann_Connection);cdecl;


        procedure fann_set_weight_array(Ann: PFann; connections: PFann_Connection; num_connection: Cardinal);cdecl;


        procedure fann_set_weight(Ann: PFann; from_neuron: Cardinal; to_neuron: Cardinal; weight: fann_type);cdecl;

        procedure fann_set_user_data(Ann: PFann; user_data: Pointer);cdecl;

        function fann_get_user_data(Ann: PFann): Pointer; cdecl;


        {$IFDEF FIXEDFANN}

                function fann_get_decimal_point(Ann: Pfann): cardinal; cdecl;

                function fann_get_multiplier(Ann: PFann): cardinal;cdecl;

        {$ENDIF}

        //END OF DECLARATIONS FROM FANN.H



        //DECLARATIONS FROM FANN_IO.H


        function fann_create_from_file(const configuration_file: PChar): PFann; cdecl;

        procedure fann_save(Ann: PFann; Const Configuration_File: PChar);cdecl;

        function fann_save_to_fixed(Ann: PFann; Const Configuration_File: PChar): integer;cdecl;

        //END OF DECLARATIONS FROM FANN_IO.H


        //DECLARATIONS FROM FANN_TRAIN.H

        {$IFNDEF FIXEDFANN}
                procedure fann_train(Ann: PFann; Input: PFann_Type; Desired_Output: PFann_Type);cdecl;
        {$ENDIF}

        function fann_test(Ann: PFann; Input: PFann_Type;  Desired_Output: Pfann_Type): Pfann_type_array;cdecl;

  
        function fann_get_MSE(Ann: PFann): single;cdecl;

        function fann_get_bit_fail(Ann: PFann): Cardinal;cdecl;

        procedure fann_reset_MSE(Ann: Pfann); cdecl;


        {$IFNDEF FIXEDFANN}


              procedure fann_train_on_data(Ann: PFann; Data: PFann_Train_Data;max_epochs: cardinal;epochs_between_reports: cardinal; desired_error: single);cdecl;

              procedure fann_train_on_file(Ann: PFann; Filename: Pchar;max_epochs: cardinal;epochs_between_reports: cardinal; desired_error: single); cdecl;



              function fann_train_epoch(Ann: PFann; data: PFann_Train_Data): single; cdecl;


              function fann_test_data(Ann: PFann; data: PFann_Train_Data): single; cdecl;

        {$ENDIF}

        function fann_read_train_from_file(const filename: PChar): PFann_Train_Data; cdecl;



        function fann_create_train_from_callback(num_data: Cardinal;
                                                 num_input: Cardinal;
                                                 num_output: Cardinal;
                                                 user_function: TUser_Function): PFann_Train_Data; cdecl;



        procedure fann_destroy_train(train_data: PFann_Train_Data); cdecl;


        procedure fann_shuffle_train_data(Train_Data: PFann_Train_Data);cdecl;


        procedure fann_scale_train(Ann: PFann; data: PFann_Train_Data);cdecl;

        procedure fann_descale_train(Ann: PFann; data: PFann_Train_Data);cdecl;


        function fann_set_input_scaling_params(Ann: PFann;
                                                const data: PFann_Train_Data;
                                                new_input_min: single;
                                                new_input_max: single): integer;cdecl;


        function fann_set_output_scaling_params(Ann: PFann;
                                                const data: PFann_Train_Data;
                                                new_output_min: single;
                                                new_output_max: single): integer;cdecl;



        function fann_set_scaling_params(Ann: PFann;
                                                const data: PFann_Train_Data;
                                                new_input_min: single;
                                                new_input_max: single;
                                                new_output_min: single;
                                                new_output_max: single): integer; cdecl;


        function fann_clear_scaling_params(Ann: PFann): integer; cdecl;



        procedure fann_scale_input(Ann: PFann; input_vector: PFann_type); cdecl;


        procedure fann_scale_output(Ann: PFann; output_vector: PFann_type); cdecl;


        procedure fann_descale_input(Ann: PFann; input_vector: PFann_type); cdecl;


        procedure fann_descale_output(Ann: PFann; output_vector: PFann_type); cdecl;


        procedure fann_scale_input_train_data(Train_Data: PFann_Train_Data;
                                              new_min: fann_type;
                                              new_max: fann_type); cdecl;


        procedure fann_scale_output_train_data(Train_Data: PFann_Train_Data;
                                              new_min: fann_type;
                                              new_max: fann_type); cdecl;


        procedure fann_scale_train_data(Train_Data: PFann_Train_Data;
                                              new_min: fann_type;
                                              new_max: fann_type); cdecl;


        function fann_merge_train_data(Data1: PFann_Train_Data; Data2: PFann_Train_Data): PFann_Train_Data; cdecl;


        function fann_duplicate_train_data(Data: PFann_Train_Data): PFann_Train_Data;cdecl;


        function fann_subset_train_data(data: PFann_Train_Data; pos: Cardinal; length: Cardinal): PFann_Train_Data; cdecl;


        function fann_length_train_data(data: PFann_Train_Data): Cardinal; cdecl;


        function fann_num_input_train_data(data: PFann_Train_Data): Cardinal; cdecl;

        function fann_num_output_train_data(data: PFann_Train_Data): Cardinal; cdecl;

        function fann_save_train(Data: PFann_train_Data; const Filename: PChar): integer;cdecl;

        function fann_save_train_to_fixed(Data: PFann_train_Data; const FileName: Pchar; decimal_point: cardinal): integer;cdecl;



        function fann_get_training_algorithm(Ann: Pfann): cardinal;cdecl;

        procedure fann_set_training_algorithm(Ann: PFann; Training_Algorithm: cardinal);cdecl;

        function fann_get_learning_rate(Ann: PFann): single;cdecl;

        procedure fann_set_learning_rate(Ann: PFann; Learning_Rate: Single); cdecl;

        function fann_get_learning_momentum(Ann: PFann): single;cdecl;

        procedure fann_set_learning_momentum(Ann: PFann; learning_momentum: Single); cdecl;



        function fann_get_activation_function(Ann: PFann; layer: integer; neuron: integer): Cardinal; cdecl; //ENUM

        procedure fann_set_activation_function(Ann: PFann; activation_function: Cardinal; layer: integer; neuron: integer); cdecl; //ENUM


        procedure fann_set_activation_function_layer(Ann: PFann; activation_function: Cardinal; layer: integer); cdecl; //ENUM


        procedure fann_set_activation_function_hidden(Ann: Pfann; Activation_function: cardinal); cdecl;

        procedure fann_set_activation_function_output(Ann: Pfann; Activation_Function: cardinal); cdecl;

        function fann_get_activation_steepness(Ann: PFann; layer: integer; neuron: integer): fann_type; cdecl;


        procedure fann_set_activation_steepness(Ann: PFann; steepness: fann_type; layer: integer; neuron: integer); cdecl;


        procedure fann_set_activation_steepness_layer(Ann: PFann; steepness: fann_type; layer: integer); cdecl;


        procedure fann_set_activation_steepness_hidden(Ann: PFann; steepness: Fann_Type); cdecl;

        procedure fann_set_activation_steepness_output(Ann: PFann; steepness: Fann_Type);cdecl;

        function fann_get_train_error_function(Ann: PFann): cardinal;cdecl;

        procedure fann_set_train_error_function(Ann: PFann; Train_Error_Function: cardinal); cdecl;

        function fann_get_train_stop_function(Ann: PFann): Cardinal; cdecl;

        procedure fann_set_train_stop_function(Ann: PFann; train_stop_function: cardinal); cdecl;

        function fann_get_bit_fail_limit(Ann: PFann): fann_type; cdecl;

        procedure fann_set_bit_fail_limit(Ann: PFann; bit_fail_limit: fann_type); cdecl;

        procedure fann_set_callback(Ann: PFann; callback: TFann_Callback); cdecl;

        function fann_get_quickprop_decay(Ann: PFann): single;cdecl;

        procedure fann_set_quickprop_decay(Ann: Pfann; quickprop_decay: Single);cdecl;

        function fann_get_quickprop_mu(Ann: PFann): single;cdecl;

        procedure fann_set_quickprop_mu(Ann: PFann; Mu: Single);cdecl;

        function fann_get_rprop_increase_factor(Ann: PFann): single;cdecl;

        procedure fann_set_rprop_increase_factor(Ann: PFann;rprop_increase_factor: single);cdecl;

        function fann_get_rprop_decrease_factor(Ann: PFann): single;cdecl;

        procedure fann_set_rprop_decrease_factor(Ann: PFann;rprop_decrease_factor: single); cdecl;

        function fann_get_rprop_delta_min(Ann: PFann): single; cdecl;

        procedure fann_set_rprop_delta_min(Ann: PFann; rprop_delta_min: Single); cdecl;

        function fann_get_rprop_delta_max(Ann: PFann): single;cdecl;

        procedure fann_set_rprop_delta_max(Ann: PFann; rprop_delta_max: Single); cdecl;

        function fann_get_rprop_delta_zero(Ann: PFann): single;cdecl;

        procedure fann_set_rprop_delta_zero(Ann: PFann; rprop_delta_zero: Single); cdecl;

        //END OF DECLARATIONS OF FANN_TRAIN.H


        //DECLARATIONS OF FANN_ERROR.H

        procedure fann_set_error_log(errdat: PFann_Error; Log_File: PFile);cdecl;

        function fann_get_errno(errdat: PFann_Error): cardinal;cdecl;

        procedure fann_reset_errno(errdat: PFann_Error);cdecl;

        procedure fann_reset_errstr(errdat: PFann_Error);cdecl;

        function fann_get_errstr(errdat: PFann_Error): PChar;cdecl;

        procedure fann_print_error(Errdat: PFann_Error);cdecl;


        //END OF DECLARATIONS OF FANN_ERROR

        //DECLARATIONS OF FANN_CASCADE.H

        procedure fann_cascadetrain_on_data(Ann: PFann;
                                            data: PFann_Train_Data;
                                            max_neurons: Cardinal;
                                            neurons_between_reports: Cardinal;
                                            desired_error: single); cdecl;

        procedure fann_cascadetrain_on_file(Ann: PFann;
                                            const filename: PChar;
                                            max_neurons: Cardinal;
                                            neurons_between_reports: Cardinal;
                                            desired_error: single); cdecl;


        function fann_get_cascade_output_change_fraction(Ann: PFann): single; cdecl;


        procedure fann_set_cascade_output_change_fraction(Ann: PFann; cascade_output_change_fraction: single); cdecl;


        function fann_get_cascade_output_stagnation_epochs(Ann: PFann): cardinal; cdecl;


        procedure fann_set_cascade_output_stagnation_epochs(Ann: PFann; cascade_output_stagnation_epochs: cardinal); cdecl;


        function fann_get_cascade_candidate_change_fraction(Ann: PFann): single; cdecl;


        procedure fann_set_cascade_candidate_change_fraction(Ann: PFann; cascade_candidate_change_fraction: single); cdecl;


        function fann_get_cascade_candidate_stagnation_epochs(Ann: PFann): cardinal; cdecl;


        procedure fann_set_cascade_candidate_stagnation_epochs(Ann: PFann; cascade_candidate_stagnation_epochs: cardinal); cdecl;


        function fann_get_cascade_weight_multiplier(Ann: PFann): fann_type; cdecl;


        procedure fann_set_cascade_weight_multiplier(Ann: PFann; cascade_weight_multiplier: fann_type); cdecl;


        function fann_get_cascade_candidate_limit(Ann: PFann): fann_type; cdecl;


        procedure fann_set_cascade_candidate_limit(Ann: PFann; cascade_candidate_limit: fann_type); cdecl;



        function fann_get_cascade_max_out_epochs(Ann: PFann): cardinal; cdecl;


        procedure fann_set_cascade_max_out_epochs(Ann: PFann; cascade_max_out_epochs: cardinal); cdecl;


        function fann_get_cascade_max_cand_epochs(Ann: PFann): cardinal; cdecl;


        procedure fann_set_cascade_max_cand_epochs(Ann: PFann; cascade_max_cand_epochs: cardinal); cdecl;


        function fann_get_cascade_num_candidates(Ann: PFann): cardinal; cdecl;


        function fann_get_cascade_activation_functions_count(Ann: PFann): cardinal; cdecl;



        function fann_get_cascade_activation_functions(Ann: PFann): PCardinal; cdecl;


        procedure fann_set_cascade_activation_functions(Ann: PFann; cascade_activation_functions: PCardinal; cascade_activation_functions_count: Cardinal); cdecl;


        function fann_get_cascade_activation_steepnesses_count(Ann: PFann): cardinal; cdecl;


        function fann_get_cascade_activation_steepnesses(Ann: PFann): pfann_type; cdecl;

        procedure fann_set_cascade_activation_steepnesses(Ann: PFann; cascade_activation_steepnesses: PFann_Type; cascade_activation_steepnesses_count: Cardinal); cdecl;


        function fann_get_cascade_num_candidate_groups(Ann: PFann): cardinal; cdecl;


        procedure fann_set_cascade_num_candidate_groups(Ann: PFann; cascade_num_candidate_groups: cardinal); cdecl;


        //END OF DECLARATIONS OF FANN_CASCADE.H



implementation

 uses Windows;

var DLLHandle: THandle;
   DLLLOAD: boolean;


  // DLLHandle := LoadLibrary(DLL_FILE);    //DLL_FILE
    //if DLLHandle <> 0 then begin
 { begin
   @ShowForm := GetProcAddress(DLLHandle, 'ShowDllForm');
   @ShowFormModal := GetProcAddress(DLLHandle, 
                                   'ShowDllFormModal');
 end; }

  // if DLLLOAD then begin

  function GLGetProcAddress(ProcName: PChar):Pointer;
begin
  //result := wglGetProcAddress(ProcName);
    result := GetProcAddress(DLLHandle, ProcName);

  end;

    //(*
		    {$IFDEF VARIABLE_ARGUMENTS}
        //try

		    function fann_create_standard;
        //try
        external DLL_FILE;
        //except
        //end

        {$ENDIF}


        function fann_create_standard_array; external DLL_FILE;


        {$IFDEF VARIABLE_ARGUMENTS}

        function fann_create_sparse; external DLL_FILE;

        {$ENDIF}



        function fann_create_sparse_array; external DLL_FILE;



        {$IFDEF VARIABLE_ARGUMENTS}

        function fann_create_shortcut; external DLL_FILE;

        {$ENDIF}


        function fann_create_shortcut_array; external DLL_FILE;


        procedure fann_destroy; external DLL_FILE;


        function fann_run; external DLL_FILE;


        procedure fann_randomize_weights; external DLL_FILE;

        procedure fann_init_weights; external DLL_FILE;


        procedure fann_print_connections; external DLL_FILE;

        procedure fann_print_parameters; external DLL_FILE;


        function fann_get_num_input; external DLL_FILE;

        function fann_get_num_output; external DLL_FILE;

        function fann_get_total_neurons; external DLL_FILE;

        function fann_get_total_connections; external DLL_FILE;


        function fann_get_network_type; external DLL_FILE;

        function fann_get_connection_rate; external DLL_FILE;


        function fann_get_num_layers; external DLL_FILE;


        procedure fann_get_layer_array; external DLL_FILE;

        procedure fann_get_bias_array; external DLL_FILE;


        procedure fann_get_connection_array; external DLL_FILE;


        procedure fann_set_weight_array; external DLL_FILE;


        procedure fann_set_weight; external DLL_FILE;

        procedure fann_set_user_data; external DLL_FILE;

        function fann_get_user_data; external DLL_FILE;


        {$IFDEF FIXEDFANN}

                function fann_get_decimal_point; external DLL_FILE;

                function fann_get_multiplier; external DLL_FILE;

        {$ENDIF}

        //END OF DECLARATIONS FROM FANN.H



        //DECLARATIONS FROM FANN_IO.H


        function fann_create_from_file; external DLL_FILE;

        procedure fann_save; external DLL_FILE;

        function fann_save_to_fixed; external DLL_FILE;

        //END OF DECLARATIONS FROM FANN_IO.H


        //DECLARATIONS FROM FANN_TRAIN.H

        {$IFNDEF FIXEDFANN}
                procedure fann_train; external DLL_FILE;
        {$ENDIF}

        function fann_test; external DLL_FILE;

  
        function fann_get_MSE; external DLL_FILE;

        function fann_get_bit_fail; external DLL_FILE;

        procedure fann_reset_MSE; external DLL_FILE;


        {$IFNDEF FIXEDFANN}


              procedure fann_train_on_data; external DLL_FILE;

              procedure fann_train_on_file; external DLL_FILE;



              function fann_train_epoch; external DLL_FILE;


              function fann_test_data; external DLL_FILE;

        {$ENDIF}

        function fann_read_train_from_file; external DLL_FILE;



        function fann_create_train_from_callback; external DLL_FILE;



        procedure fann_destroy_train; external DLL_FILE;


        procedure fann_shuffle_train_data; external DLL_FILE;


        procedure fann_scale_train; external DLL_FILE;

        procedure fann_descale_train; external DLL_FILE;


        function fann_set_input_scaling_params; external DLL_FILE;


        function fann_set_output_scaling_params; external DLL_FILE;



        function fann_set_scaling_params; external DLL_FILE;


        function fann_clear_scaling_params; external DLL_FILE;



        procedure fann_scale_input; external DLL_FILE;


        procedure fann_scale_output; external DLL_FILE;


        procedure fann_descale_input; external DLL_FILE;


        procedure fann_descale_output; external DLL_FILE;


        procedure fann_scale_input_train_data; external DLL_FILE;


        procedure fann_scale_output_train_data; external DLL_FILE;


        procedure fann_scale_train_data; external DLL_FILE;


        function fann_merge_train_data; external DLL_FILE;


        function fann_duplicate_train_data; external DLL_FILE;


        function fann_subset_train_data; external DLL_FILE;


        function fann_length_train_data; external DLL_FILE;


        function fann_num_input_train_data; external DLL_FILE;

        function fann_num_output_train_data; external DLL_FILE;

        function fann_save_train; external DLL_FILE;

        function fann_save_train_to_fixed; external DLL_FILE;



        function fann_get_training_algorithm; external DLL_FILE;

        procedure fann_set_training_algorithm; external DLL_FILE;

        function fann_get_learning_rate; external DLL_FILE;

        procedure fann_set_learning_rate; external DLL_FILE;

        function fann_get_learning_momentum; external DLL_FILE;

        procedure fann_set_learning_momentum; external DLL_FILE;



        function fann_get_activation_function; external DLL_FILE; //ENUM

        procedure fann_set_activation_function; external DLL_FILE; //ENUM


        procedure fann_set_activation_function_layer; external DLL_FILE; //ENUM


        procedure fann_set_activation_function_hidden; external DLL_FILE;

        procedure fann_set_activation_function_output; external DLL_FILE;

        function fann_get_activation_steepness; external DLL_FILE;


        procedure fann_set_activation_steepness; external DLL_FILE;


        procedure fann_set_activation_steepness_layer; external DLL_FILE;


        procedure fann_set_activation_steepness_hidden; external DLL_FILE;

        procedure fann_set_activation_steepness_output; external DLL_FILE;

        function fann_get_train_error_function; external DLL_FILE;
        
        procedure fann_set_train_error_function; external DLL_FILE;

        function fann_get_train_stop_function; external DLL_FILE;

        procedure fann_set_train_stop_function; external DLL_FILE;

        function fann_get_bit_fail_limit; external DLL_FILE;

        procedure fann_set_bit_fail_limit; external DLL_FILE;

        procedure fann_set_callback; external DLL_FILE;

        function fann_get_quickprop_decay; external DLL_FILE;

        procedure fann_set_quickprop_decay; external DLL_FILE;

        function fann_get_quickprop_mu; external DLL_FILE;

        procedure fann_set_quickprop_mu; external DLL_FILE;

        function fann_get_rprop_increase_factor; external DLL_FILE;

        procedure fann_set_rprop_increase_factor; external DLL_FILE;

        function fann_get_rprop_decrease_factor; external DLL_FILE;

        procedure fann_set_rprop_decrease_factor; external DLL_FILE;

        function fann_get_rprop_delta_min; external DLL_FILE;

        procedure fann_set_rprop_delta_min; external DLL_FILE;

        function fann_get_rprop_delta_max; external DLL_FILE;

        procedure fann_set_rprop_delta_max; external DLL_FILE;

        function fann_get_rprop_delta_zero; external DLL_FILE;

        procedure fann_set_rprop_delta_zero; external DLL_FILE;

        //END OF DECLARATIONS OF FANN_TRAIN.H


        //DECLARATIONS OF FANN_ERROR.H

        procedure fann_set_error_log; external DLL_FILE;

        function fann_get_errno; external DLL_FILE;

        procedure fann_reset_errno; external DLL_FILE;

        procedure fann_reset_errstr; external DLL_FILE;

        function fann_get_errstr; external DLL_FILE;

        procedure fann_print_error; external DLL_FILE;


        //END OF DECLARATIONS OF FANN_ERROR

        //DECLARATIONS OF FANN_CASCADE.H

        procedure fann_cascadetrain_on_data; external DLL_FILE;

        procedure fann_cascadetrain_on_file; external DLL_FILE;


        function fann_get_cascade_output_change_fraction; external DLL_FILE;


        procedure fann_set_cascade_output_change_fraction; external DLL_FILE;


        function fann_get_cascade_output_stagnation_epochs; external DLL_FILE;


        procedure fann_set_cascade_output_stagnation_epochs; external DLL_FILE;


        function fann_get_cascade_candidate_change_fraction; external DLL_FILE;


        procedure fann_set_cascade_candidate_change_fraction; external DLL_FILE;


        function fann_get_cascade_candidate_stagnation_epochs; external DLL_FILE;


        procedure fann_set_cascade_candidate_stagnation_epochs; external DLL_FILE;


        function fann_get_cascade_weight_multiplier; external DLL_FILE;


        procedure fann_set_cascade_weight_multiplier; external DLL_FILE;


        function fann_get_cascade_candidate_limit; external DLL_FILE;


        procedure fann_set_cascade_candidate_limit; external DLL_FILE;



        function fann_get_cascade_max_out_epochs; external DLL_FILE;


        procedure fann_set_cascade_max_out_epochs; external DLL_FILE;


        function fann_get_cascade_max_cand_epochs; external DLL_FILE;


        procedure fann_set_cascade_max_cand_epochs; external DLL_FILE;


        function fann_get_cascade_num_candidates; external DLL_FILE;


        function fann_get_cascade_activation_functions_count; external DLL_FILE;



        function fann_get_cascade_activation_functions; external DLL_FILE;


        procedure fann_set_cascade_activation_functions; external DLL_FILE;


        function fann_get_cascade_activation_steepnesses_count; external DLL_FILE;


        function fann_get_cascade_activation_steepnesses; external DLL_FILE;

        procedure fann_set_cascade_activation_steepnesses; external DLL_FILE;


        function fann_get_cascade_num_candidate_groups; external DLL_FILE;


        procedure fann_set_cascade_num_candidate_groups; external DLL_FILE;

        //*)


     initialization

     SetErrorMode(SEM_FAILCRITICALERRORS);

     try

      DLLHandle := LoadLibrary(DLL_FILE);    //DLL_FILE
         if DLLHandle <> 0 then DLLLOAD:= true else DLLLOAD:= false;
       if DLLHandle <= 32 then
       MessageBox(0,'Error: could not load ' + DLL_FILE, 'Oops!', MB_OK)
      except
       messagebox(0,'Error: could not load ' + DLL_FILE, 'DLLOops!', MB_OK)

     end;

end.

