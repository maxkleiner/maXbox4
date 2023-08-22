{*------------------------------------------------------------------------------
   TFannNetwork encapsulates the Fast Artificial Neural Network.

   fann.sourceforge.net

   @author Mauricio Pereira Maia
   @email mauriciocpa@gmail.com
   @version 2.1 c              add type by mX4

-------------------------------------------------------------------------------}
unit FannNetwork;

interface

{$R fann.dcr}


uses
  Windows, Messages, SysUtils, Classes,Fann;

type CardinalArray = array [0..32768] of Cardinal; //Array of Cardinal Type
     PCardinalArray = ^CardinalArray; //Pointer to CardinalArray Type

     type TFann_Type_Array3 = array of single;



type TTrainingAlgorithm = ( taFANN_TRAIN_INCREMENTAL,
                	          taFANN_TRAIN_BATCH,
                	          taFANN_TRAIN_RPROP,
                            taFANN_TRAIN_QUICKPROP );



type TActivationFunction = (  afFANN_LINEAR,
                              afFANN_THRESHOLD,
	                            afFANN_THRESHOLD_SYMMETRIC,
                              afFANN_SIGMOID ,
                              afFANN_SIGMOID_STEPWISE,
                              afFANN_SIGMOID_SYMMETRIC ,
                              afFANN_SIGMOID_SYMMETRIC_STEPWISE,
                              afFANN_GAUSSIAN ,
                              afFANN_GAUSSIAN_SYMMETRIC,
                              afFANN_GAUSSIAN_STEPWISE,
                              afFANN_ELLIOT ,
                              afFANN_ELLIOT_SYMMETRIC,
                              afFANN_LINEAR_PIECE,
                              afFANN_LINEAR_PIECE_SYMMETRIC,
                              afFANN_SIN_SYMMETRIC,
                              afFANN_COS_SYMMETRIC,
                              afFANN_SIN,
                              afFANN_COS );

type
{*------------------------------------------------------------------------------
  TFannNetwork Component
-------------------------------------------------------------------------------}
  TFannNetwork = class(TComponent)
  private
    ann: PFann;
    pBuilt: boolean;
    pLayers: TStrings;
    pLearningRate: Single;
    pConnectionRate: Single;
    pLearningMomentum: Single;
    pActivationFunctionHidden: Cardinal;
    pActivationFunctionOutput: Cardinal;
    pTrainingAlgorithm: Cardinal;

    procedure SetLayers(const Value: TStrings);

    procedure SetConnectionRate(const Value: Single);
    function GetConnectionRate(): Single;

    procedure SetLearningRate(Const Value: Single);
    function GetLearningRate(): Single;

    procedure SetLearningMomentum(Const Value: Single);
    function GetLearningMomentum(): Single;

    procedure SetTrainingAlgorithm(Value: TTrainingAlgorithm);
    function GetTrainingAlgorithm(): TTrainingAlgorithm;

    procedure SetActivationFunctionHidden(Value: TActivationFunction);
    function GetActivationFunctionHidden(): TActivationFunction;

    procedure SetActivationFunctionOutput(Value: TActivationFunction);
    function GetActivationFunctionOutput(): TActivationFunction;

    function GetMSE(): Single;

    function EnumActivationFunctionToValue(Value: TActivationFunction): Cardinal;
    function ValueActivationFunctionToEnum(Value: Cardinal): TActivationFunction;

    function EnumTrainingAlgorithmToValue(Value: TTrainingAlgorithm): Cardinal;
    function ValueTrainingAlgorithmToEnum(Value: Cardinal): TTrainingAlgorithm;

  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy(); override;
    procedure Build();
    procedure UnBuild();
    function Train(Input: array of fann_type; Output: array of fann_type): single;
    procedure TrainOnFile(FileName: String; MaxEpochs: Cardinal; DesiredError: Single);
    procedure Run(Inputs: array of fann_type; var Outputs: array of fann_type);
    procedure SaveToFile(FileName: String);
    procedure LoadFromFile(Filename: string);

    procedure Run4(Inputs: array of fann_type; var Outputs: TFann_Type_Array3);


    {*------------------------------------------------------------------------------
     Pointer to the Fann object.
     If you need to call the fann library directly and skip the Delphi Component.
    -------------------------------------------------------------------------------}
    property FannObject: PFann read ann;
  published

    {*------------------------------------------------------------------------------
     Network Layer Structure. Each line need to have the number of neurons
        of the layer.
        2
        4
        1
        Will make a three layered network with 2 input neurons, 4 hidden neurons
        and 1 output neuron.
   -------------------------------------------------------------------------------}
    property Layers: TStrings read PLayers write SetLayers;

    {*------------------------------------------------------------------------------
     Network Learning Rate.
    -------------------------------------------------------------------------------}
    property LearningRate: Single read GetLearningRate write SetLearningRate;

    {*------------------------------------------------------------------------------
     Network Connection Rate. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property ConnectionRate: Single read GetConnectionRate write SetConnectionRate;

    {*------------------------------------------------------------------------------
     Network Learning Momentum. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property LearningMometum: single read GetLearningMomentum write SetLearningMomentum;

    {*------------------------------------------------------------------------------
     Fann Network Mean Square Error. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property MSE: Single read GetMSE;

    {*------------------------------------------------------------------------------
     Training Algorithm used by the network. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property TrainingAlgorithm: TTrainingAlgorithm read GetTrainingAlgorithm write SetTrainingAlgorithm;

    {*------------------------------------------------------------------------------
     Activation Function used by the hidden layers. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property ActivationFunctionHidden: TActivationFunction read GetActivationFunctionHidden write SetActivationFunctionHidden;

    {*------------------------------------------------------------------------------
     Activation Function used by the output layers. See the FANN docs for more info.
    -------------------------------------------------------------------------------}
    property ActivationFunctionOutput: TActivationFunction read GetActivationFunctionOutput write SetActivationFunctionOutput;


end;

procedure Register;

implementation

procedure Register; //Register the Component
begin
  RegisterComponents('FANN', [TFannNetwork]);
end;


{*------------------------------------------------------------------------------
    Builds a Fann neural nerwork.
    Layers property must be set to work.
-------------------------------------------------------------------------------}
procedure TFannNetwork.Build;
var l: PCardinalArray; //Pointer to number of neurons on each layer
    nl: integer; //Number of layers
    i: integer;
begin

        nl:=pLayers.Count;

        if nl=0 then
                Exception.Create('You need to specify the Layers property');

        GetMem(l,nl*sizeof(Cardinal)); //Alloc mem for the array


        for i:=0 to nl-1 do
        begin

                l[i]:=StrtoInt(pLayers.Strings[i]);
                
        end;


        if(pConnectionRate<1) then
          ann:=fann_create_sparse_array(pConnectionRate,nl,@l[0])
        else ann:=fann_create_standard_array(nl,@l[0]);

        fann_randomize_weights(ann,-0.5,0.5);

        fann_set_learning_rate(ann,pLearningRate);

        fann_set_learning_momentum(ann,pLearningMomentum);

        fann_set_activation_steepness_hidden(ann,0.5);

        fann_set_activation_steepness_output(ann,0.5);

        fann_set_activation_function_hidden(ann,pActivationFunctionHidden);

        fann_set_activation_function_output(ann,pActivationFunctionOutput);

        fann_set_training_algorithm(ann,pTrainingAlgorithm);

        pbuilt:=true;

        FreeMem(l);

        
end;

{*------------------------------------------------------------------------------
    Creates an instance of TFannNetwork

    @param      AOwner Owner Component
-------------------------------------------------------------------------------}
constructor TFannNetwork.Create(Aowner: TComponent);
begin
        inherited Create(Aowner);

        ann:=nil;
        pBuilt:=false;
        pConnectionRate:=1;
        pLearningRate:=0.7;
        pLayers:=TStringList.Create;
        pLearningMomentum:=0;
        pActivationFunctionHidden:=FANN_SIGMOID;
        pActivationFunctionOutput:=FANN_SIGMOID;
        pTrainingAlgorithm:=FANN_TRAIN_RPROP;

end;

{*------------------------------------------------------------------------------
    Destroys the TFannNetwork object and frees its memory.
-------------------------------------------------------------------------------}
destructor TFannNetwork.Destroy;
begin
  UnBuild;

  FreeAndNil(pLayers);
  inherited;
end;

{*------------------------------------------------------------------------------
    Gets the activation function used by the hidden layers

    @return Activation Function
-------------------------------------------------------------------------------}
function TFannNetwork.GetActivationFunctionHidden: TActivationFunction;
begin
     result:=ValueActivationFunctionToEnum(pActivationFunctionHidden);
end;

{*------------------------------------------------------------------------------
    Gets the activation function used by the output layer

    @return Activation Function
-------------------------------------------------------------------------------}
function TFannNetwork.GetActivationFunctionOutput: TActivationFunction;
begin
     result:=ValueActivationFunctionToEnum(pActivationFunctionOutput);
end;

{*------------------------------------------------------------------------------
    Gets the network connection rate

    @return Connection Rate
-------------------------------------------------------------------------------}
function TFannNetwork.GetConnectionRate: Single;
begin
       if(ann<>nil)then
         result:=fann_get_connection_rate(ann)
       else result:=pConnectionRate;

end;

{*------------------------------------------------------------------------------
    Gets the network learning momentum

    @return Learning Momentum
-------------------------------------------------------------------------------}
function TFannNetwork.GetLearningMomentum: Single;
begin
       if(ann<>nil)then
         result:=fann_get_learning_momentum(ann)
       else result:=pLearningMomentum;

end;

{*------------------------------------------------------------------------------
    Gets the network learning rate

    @return Learning Rate
-------------------------------------------------------------------------------}
function TFannNetwork.GetLearningRate: Single;
begin
       if (ann<>nil) then
         result:=fann_get_learning_rate(ann)
       else result:=pLearningRate;
end;

{*------------------------------------------------------------------------------
    Returns the Mean Square Error of the Network.

    @return             Mean Square Error
-------------------------------------------------------------------------------}
function TFannNetwork.GetMSE: Single;
begin
        if not pBuilt then
               raise Exception.Create('The nework has not been built');

        result:=fann_get_mse(ann);

end;

{*------------------------------------------------------------------------------
    Gets the network training algorithm

    @return Training algorithm
-------------------------------------------------------------------------------}
function TFannNetwork.GetTrainingAlgorithm: TTrainingAlgorithm;
begin

        if(ann<>nil)then
          result:=ValueTrainingAlgorithmToEnum(fann_get_training_algorithm(ann))
        else result:=ValueTrainingAlgorithmToEnum(pTrainingAlgorithm);
end;

{*------------------------------------------------------------------------------
    Loads a network from a file.

    @param  Filename    File that contains the network
    @see                SavetoFile
-------------------------------------------------------------------------------}
procedure TFannNetwork.LoadFromFile(Filename: string);
begin

        If pBuilt then fann_destroy(ann);

        ann:=fann_create_from_file(PChar(Filename));

        pBuilt:=true;

end;

{*------------------------------------------------------------------------------
    Executes the network.

    @param  Inputs      Array with the value of each input
    @param  Ouputs      Will receive the output of the network. Need to be
                        allocated before the Run function call with the number
                        of outputs on the network.
-------------------------------------------------------------------------------}
procedure TFannNetwork.Run(Inputs: array of fann_type;
  var Outputs: array of fann_type);
var O: Pfann_type_array;
    i: integer;
begin
        if not pBuilt then
               raise Exception.Create('The network has not been built');

        O:=fann_run(ann,@Inputs[0]);

        for i:=0 to High(outputs) do
        begin
            Outputs[i]:=O[i];
        end;



end;

//type TFann_Type_Array3 = array of single;

procedure TFannNetwork.Run4(Inputs: array of fann_type;
  var Outputs: TFann_Type_Array3);
var O: Pfann_type_array;
    i: integer;
begin
        if not pBuilt then
               raise Exception.Create('The network has not been built');

        O:=fann_run(ann,@Inputs[0]);

        for i:=0 to High(outputs) do
        begin
            Outputs[i]:=O[i];
        end;



end;


{*------------------------------------------------------------------------------
    Saves the current network to the specified file.

    @param  Filename    Filename of the network

    @see                LoadFromFile
-------------------------------------------------------------------------------}
procedure TFannNetwork.SaveToFile(FileName: String);
begin
        if not pBuilt then exit;


        fann_save(ann,PChar(Filename));
        

end;

{*------------------------------------------------------------------------------
    Sets the activation function for the hidden layers

    @param  Value       The new activation function
-------------------------------------------------------------------------------}
procedure TFannNetwork.SetActivationFunctionHidden(Value: TActivationFunction);
begin

    if(ann<>nil)then
        fann_set_activation_function_hidden(ann,EnumActivationFunctionToValue(value));

    pActivationFunctionHidden:=EnumActivationFunctionToValue(value);
end;

{*------------------------------------------------------------------------------
    Sets the activation function for the output layer

    @param  Value       The activation function
-------------------------------------------------------------------------------}
procedure TFannNetwork.SetActivationFunctionOutput(Value: TActivationFunction);
begin

    if(ann<>nil)then
        fann_set_activation_function_output(ann,EnumActivationFunctionToValue(value));

    pActivationFunctionOutput:=EnumActivationFunctionToValue(value);
end;

{*------------------------------------------------------------------------------
    Sets the connection rate

    @param  Value       The new connection rate
-------------------------------------------------------------------------------}
procedure TFannNetwork.SetConnectionRate(const Value: Single);
begin

    pConnectionRate:=value;

end;

{*------------------------------------------------------------------------------
    Set the layer structure of the neural network.
    Each line corresponds to a layers on the neural network.

    @param  Value      Text with the layers specification
-------------------------------------------------------------------------------}
procedure TFannNetwork.SetLayers(const Value: TStrings);
begin

   if Value.Count < 2 then
      raise Exception.Create('The network should have at least two layers')
   else
      pLayers.Assign(Value);

end;

{*------------------------------------------------------------------------------
    Sets the network learning momentum

    @param  Value       The new learning momentum
-------------------------------------------------------------------------------}
procedure TFannNetwork.SetLearningMomentum(const Value: Single);
begin

    if(ann<>nil)then
        fann_set_learning_momentum(ann,value);

    pLearningMomentum:=Value;
end;

{*------------------------------------------------------------------------------
    Sets the network learning rate

    @param  Value       The new learning rate
-------------------------------------------------------------------------------}
procedure TFannNetwork.SetLearningRate(const Value: Single);
begin

    if(ann<>nil)then
        fann_set_learning_rate(ann,value);

    pLearningRate:=Value;

end;

{*------------------------------------------------------------------------------
    Sets the network training algorithm

    @param  Value       The new training algorithm
-------------------------------------------------------------------------------}
procedure TFannNetwork.SetTrainingAlgorithm(Value: TTrainingAlgorithm);
begin

    if(ann<>nil)then
        fann_set_training_algorithm(ann,EnumTrainingAlgorithmToValue(Value));

    pTrainingAlgorithm:=EnumTrainingAlgorithmToValue(Value);

end;

{*------------------------------------------------------------------------------
    Will train one iteration with a set of inputs, and a set of desired outputs.

    @param  Input       Array with the value of each input of the network
    @param  Output      Array with the value of each desired output of the network
    @return             Mean Square Error after the training

    @see                TrainOnFile
-------------------------------------------------------------------------------}
function TFannNetwork.Train(Input, Output: array of fann_type): single;
begin

        if not pBuilt then
                raise Exception.Create('The nework has not been built');

        fann_reset_mse(ann);
        fann_train(ann,@Input[0],@Output[0]);

        result:=fann_get_mse(ann);

end;

{*------------------------------------------------------------------------------
    Trains the network using the data in filename until desired error is reached
    or until maxepochs is surpassed.

    @param  FileName    Training Data File.
    @param  MaxEpochs   Maximum number of epochs to train
    @param  DesiredError Desired Error of the network after the training

    @see                Train
-------------------------------------------------------------------------------}
procedure TFannNetwork.TrainOnFile(FileName: String; MaxEpochs: Cardinal;
  DesiredError: Single);
begin

        if not pBuilt then
                raise Exception.Create('The nework has not been built');

        fann_train_on_file(ann,PChar(FileName),MaxEpochs,1000,DesiredError);

end;

{*------------------------------------------------------------------------------
    Converts the delphi enum type to the fann define type.

-------------------------------------------------------------------------------}
function TFannNetwork.EnumActivationFunctionToValue(
  Value: TActivationFunction): Cardinal;
begin

      case Value of

          afFANN_LINEAR:
              result:=FANN_LINEAR;
          afFANN_THRESHOLD:
              result:=FANN_THRESHOLD;
          afFANN_THRESHOLD_SYMMETRIC:
              result:=FANN_THRESHOLD_SYMMETRIC;
          afFANN_SIGMOID:
              result:=FANN_SIGMOID;
          afFANN_SIGMOID_STEPWISE:
              result:=FANN_SIGMOID_STEPWISE;
          afFANN_SIGMOID_SYMMETRIC:
              result:=FANN_SIGMOID;
          afFANN_SIGMOID_SYMMETRIC_STEPWISE:
              result:=FANN_SIGMOID_SYMMETRIC_STEPWISE;
          afFANN_GAUSSIAN:
              result:=FANN_GAUSSIAN;
          afFANN_GAUSSIAN_SYMMETRIC:
              result:=FANN_GAUSSIAN_SYMMETRIC;
          afFANN_GAUSSIAN_STEPWISE:
              result:=FANN_GAUSSIAN_STEPWISE;
          afFANN_ELLIOT:
              result:=FANN_ELLIOT;
          afFANN_ELLIOT_SYMMETRIC:
              result:=FANN_ELLIOT_SYMMETRIC;
          afFANN_LINEAR_PIECE:
              result:=FANN_LINEAR_PIECE;
          afFANN_LINEAR_PIECE_SYMMETRIC:
              result:=FANN_LINEAR_PIECE_SYMMETRIC;
          afFANN_SIN_SYMMETRIC:
              result:=FANN_SIN_SYMMETRIC;
          afFANN_COS_SYMMETRIC:
              result:=FANN_COS_SYMMETRIC;
          afFANN_SIN:
              result:=FANN_SIN;
          afFANN_COS:
              result:=FANN_COS;
          else
              result:=FANN_SIGMOID;



      end;

end;

{*------------------------------------------------------------------------------
    Converts the fann activation value to the delphi enum type

-------------------------------------------------------------------------------}
function TFannNetwork.ValueActivationFunctionToEnum(
  Value: Cardinal): TActivationFunction;
begin

      case Value of

          FANN_LINEAR:
              result:=afFANN_LINEAR;
          FANN_THRESHOLD:
              result:=afFANN_THRESHOLD;
          FANN_THRESHOLD_SYMMETRIC:
              result:=afFANN_THRESHOLD_SYMMETRIC;
          FANN_SIGMOID:
              result:=afFANN_SIGMOID;
          FANN_SIGMOID_STEPWISE:
              result:=afFANN_SIGMOID_STEPWISE;
          FANN_SIGMOID_SYMMETRIC:
              result:=afFANN_SIGMOID;
          FANN_SIGMOID_SYMMETRIC_STEPWISE:
              result:=afFANN_SIGMOID_SYMMETRIC_STEPWISE;
          FANN_GAUSSIAN:
              result:=afFANN_GAUSSIAN;
          FANN_GAUSSIAN_SYMMETRIC:
              result:=afFANN_GAUSSIAN_SYMMETRIC;
          FANN_GAUSSIAN_STEPWISE:
              result:=afFANN_GAUSSIAN_STEPWISE;
          FANN_ELLIOT:
              result:=afFANN_ELLIOT;
          FANN_ELLIOT_SYMMETRIC:
              result:=afFANN_ELLIOT_SYMMETRIC;
          FANN_LINEAR_PIECE:
              result:=afFANN_LINEAR_PIECE;
          FANN_LINEAR_PIECE_SYMMETRIC:
              result:=afFANN_LINEAR_PIECE_SYMMETRIC;
          FANN_SIN_SYMMETRIC:
              result:=afFANN_SIN_SYMMETRIC;
          FANN_COS_SYMMETRIC:
              result:=afFANN_COS_SYMMETRIC;
          FANN_SIN:
              result:=afFANN_SIN;
          FANN_COS:
              result:=afFANN_COS;
          else
              result:=afFANN_SIGMOID;



      end;
end;

{*------------------------------------------------------------------------------
    Converts the delphi enum training algorithm to the fann type

-------------------------------------------------------------------------------}
function TFannNetwork.EnumTrainingAlgorithmToValue(
  Value: TTrainingAlgorithm): Cardinal;
begin


      case Value of

        taFANN_TRAIN_INCREMENTAL:
            Result:=FANN_TRAIN_INCREMENTAL;
        taFANN_TRAIN_BATCH:
            Result:=FANN_TRAIN_BATCH;
        taFANN_TRAIN_RPROP:
            Result:=FANN_TRAIN_RPROP;
        taFANN_TRAIN_QUICKPROP:
            Result:=FANN_TRAIN_QUICKPROP;


      else
        result:=FANN_TRAIN_RPROP

      end;

end;

{*------------------------------------------------------------------------------
    Converts the fann training algorithm to the delphi enum type

-------------------------------------------------------------------------------}
function TFannNetwork.ValueTrainingAlgorithmToEnum(
  Value: Cardinal): TTrainingAlgorithm;
begin

      case Value of

        FANN_TRAIN_INCREMENTAL:
            Result:=taFANN_TRAIN_INCREMENTAL;
        FANN_TRAIN_BATCH:
            Result:=taFANN_TRAIN_BATCH;
        FANN_TRAIN_RPROP:
            Result:=taFANN_TRAIN_RPROP;
        FANN_TRAIN_QUICKPROP:
            Result:=taFANN_TRAIN_QUICKPROP;


      else
        result:=taFANN_TRAIN_RPROP

      end;

end;

{*------------------------------------------------------------------------------
    Destroys the Fann neural nerwork.

-------------------------------------------------------------------------------}
procedure TFannNetwork.UnBuild;
begin
    if(pBuilt)then
        fann_destroy(ann);

    pBuilt:=false;
end;

end.
