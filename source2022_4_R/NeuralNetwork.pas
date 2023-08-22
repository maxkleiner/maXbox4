unit NeuralNetwork;

interface

type
  TNeuron = class;
//------------------------------------------------------------------------------
  TSynapse = record
    W           : Real;
    Connection  : TNeuron;

  end;
//------------------------------------------------------------------------------
  TAcson = record
    Alfa  : Real;
    Beta  : Real;
    Gama  : Real;

  end;
//------------------------------------------------------------------------------
  TNeuron = class
  protected
    FAcson    : TAcson;
    FSynapse  : array of TSynapse;
    FInput    : Real;
    FOutput   : Real;

    FError    : Real;
    
  protected
    function GetCountSynapses() : Integer;

  protected
    function GetOutput() : Real;

  public
    procedure Connect( ASourceNeuron : TNeuron );

  public
    procedure Compute();
    function  GetDif() : Real;
    procedure SetRandomW();

  public
    constructor Create();

  public
    property CountSynapses : Integer read GetCountSynapses;
    property Input       : Real read FInput write FInput;

  end;
//------------------------------------------------------------------------------
  TNeuronLayer = class
  protected
    FNeurons : array of TNeuron;

  protected
    function GetCountNeurons() : Integer;
    
  public
    procedure Compute();
    procedure RandomW();

  public
    constructor Create( ACountNeurons : Integer );
    destructor  Destroy(); override;
    
  public
    property CountNeurons : Integer read GetCountNeurons;

  end;
//------------------------------------------------------------------------------
  TNeuralNet = class
  protected
    FLayers     : array of TNeuronLayer;

  protected
    FEpoch        : Integer;
    FErrMinimal   : Real;
    FStep         : Real;
    FEpochMaximal : Integer;
    FError        : Real;

  public
    function  GetCountLayers() : Integer;
    function  GetCountInputs() : Integer;
    function  GetCountOutputs() : Integer;
    function  GetInputs(Index: Integer): Real;
    function  GetOutputs(Index: Integer): Real;
    procedure SetInputs(Index: Integer; const Value: Real);
    function  GetResults( Index: Integer): Real;

  public
    procedure AddLayer( ANumNeurons : Integer );
    procedure ConnectAll();
    procedure Train( ATrainData : array of Real; ATrainResult : array of Real );

  public
    procedure TrainEpoch( ATrainData : array of Real; ATrainResult : array of Real );

  public
    procedure Compute();

  public
    constructor Create();
    destructor  Destroy(); override;
    
  public
    property CountLayers  : Integer read GetCountLayers;
    property CountInputs  : Integer read GetCountInputs;
    property CountOutputs : Integer read GetCountOutputs;
    property Inputs[ Index  : Integer ] : Real read GetInputs write SetInputs;
    property Outputs[ Index : Integer ] : Real read GetOutputs;
    property Results[ Index : Integer ] : Real read GetResults;
    property Epoch  : Integer read FEpoch;
    property Error  : Real    read FError;


  end;

implementation

constructor TNeuronLayer.Create( ACountNeurons : Integer );
var
  I : Integer;

begin
  inherited Create();
  SetLength( FNeurons, ACountNeurons );
  
  for I := 0 to CountNeurons - 1 do
    FNeurons[ I ] := TNeuron.Create();
    
end;
//------------------------------------------------------------------------------
destructor TNeuronLayer.Destroy();
var
  I : Integer;

begin
  for I := 0 to CountNeurons - 1 do
    FNeurons[ I ].Free();

  inherited;
end;
//------------------------------------------------------------------------------
procedure TNeuronLayer.Compute();
var
 I : Integer;
 
begin
  for I := 0 to CountNeurons - 1 do
    FNeurons[ I ].Compute();

end;
//------------------------------------------------------------------------------
procedure TNeuronLayer.RandomW;
var
 I : Integer;

begin
  for I :=0 to CountNeurons - 1 do
    FNeurons[ I ].SetRandomW();

end;
//------------------------------------------------------------------------------
function TNeuronLayer.GetCountNeurons() : Integer;
begin
  Result := Length( FNeurons );
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
constructor TNeuron.Create();
begin
  inherited Create();

  FAcson.Beta := 0;
  FAcson.Alfa := 1;
  FAcson.Gama := 0;
end;
//------------------------------------------------------------------------------
procedure TNeuron.SetRandomW();
var
  I : Integer;

begin
  for I := 0 to CountSynapses - 1 do
    FSynapse[ I ].W := ( Random - Random ) / 30 + 0.05;
    
end;
//------------------------------------------------------------------------------
function TNeuron.GetCountSynapses() : Integer;
begin
  Result := Length( FSynapse );
end;
//------------------------------------------------------------------------------
procedure TNeuron.Connect( ASourceNeuron : TNeuron );
begin
  SetLength( FSynapse, CountSynapses + 1 );
  FSynapse[ CountSynapses - 1 ].Connection := ASourceNeuron;
  FSynapse[ CountSynapses - 1 ].W := Random;
end;
//------------------------------------------------------------------------------
procedure TNeuron.Compute();
var
  I  : Integer;

begin
  FInput := 0;
  for I :=0 to CountSynapses - 1 do
    FInput := FInput + FSynapse[I].W * FSynapse[I].Connection.GetOutput();

end;
//------------------------------------------------------------------------------
function TNeuron.GetDif() : Real;
begin
  Result := ( 1 - FOutput ) * FOutput * FAcson.Alfa;
end;
//------------------------------------------------------------------------------
function TNeuron.GetOutput() : Real;
begin
  if( CountSynapses = 0 ) then
    FOutput := FInput

  else
    begin
    FOutput:=( FInput + FAcson.Beta )*( -FAcson.Alfa );
    if( FOutput > 100 ) then
      FOutput:= 1 + FAcson.Gama

    else
      begin
      if( FOutput < -100 ) then
        FOutput := 0 + FAcson.Gama

      else
        begin
        FOutput := Exp(FOutput);
        FOutput := 1 / ( 1 + FOutput ) + FAcson.Gama;
        end;
      end;
    end;

  Result := FOutput;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
constructor TNeuralNet.Create();
begin
  inherited Create();
  FErrMinimal:=0.001;
  FEpochMaximal := 100000;
  FError:=0;
  FEpoch:=0;
  FStep:=0.3;
end;
//------------------------------------------------------------------------------
destructor TNeuralNet.Destroy();
var
  I : Integer;

begin
  for I := 0 to CountLayers - 1 do
    FLayers[ I ].Free();
     
  inherited;
end;
//------------------------------------------------------------------------------
function TNeuralNet.GetCountLayers() : Integer;
begin
  Result := Length( FLayers );
end;
//------------------------------------------------------------------------------
function TNeuralNet.GetCountInputs() : Integer;
begin
  Result := FLayers[ 0 ].CountNeurons;
end;
//------------------------------------------------------------------------------
function TNeuralNet.GetCountOutputs() : Integer;
begin
  Result := FLayers[ CountLayers - 1 ].CountNeurons;
end;
//------------------------------------------------------------------------------
function TNeuralNet.GetInputs(Index: Integer): Real;
begin
  Result := FLayers[ 0 ].FNeurons[Index].Input;
end;
//------------------------------------------------------------------------------
function TNeuralNet.GetOutputs(Index: Integer): Real;
begin
  Result := FLayers[ CountLayers - 1 ].FNeurons[Index].GetOutput();
end;
//------------------------------------------------------------------------------
procedure TNeuralNet.SetInputs(Index: Integer; const Value: Real);
begin
  FLayers[ 0 ].FNeurons[Index].Input := Value;
end;
//------------------------------------------------------------------------------
function TNeuralNet.GetResults(Index: integer): Real;
begin
  Result := Outputs[Index]
end;
//------------------------------------------------------------------------------
procedure TNeuralNet.Compute();
var
 I : Integer;

begin
  for I := 1 to CountLayers - 1 do
    FLayers[ I ].Compute();

end;
//------------------------------------------------------------------------------
procedure TNeuralNet.AddLayer( ANumNeurons : Integer );
begin
  SetLength( FLayers, CountLayers + 1 );
  FLayers[ CountLayers - 1 ] := TNeuronLayer.Create( ANumNeurons );
end;
//------------------------------------------------------------------------------
procedure TNeuralNet.ConnectAll();
var
  I : Integer;
  J : Integer;
  K : Integer;

begin
  for I := 1 to CountLayers - 1 do
    for J := 0 to FLayers[ I ].CountNeurons - 1 do
      for K := 0 to FLayers[ I - 1 ].CountNeurons - 1 do
        FLayers[ I ].FNeurons[ J ].Connect( FLayers[ I - 1 ].FNeurons[ K ] );

end;
//------------------------------------------------------------------------------
procedure TNeuralNet.Train( ATrainData : array of Real; ATrainResult : array of Real );
var
  I : Integer;
begin
  FStep := 0.5;
  for I := 1 to CountLayers - 1 do
    FLayers[ I ].RandomW();

  FEpoch:=0;
  repeat
    FError:=0;
    TrainEpoch( ATrainData, ATrainResult );

  until ( FError <= FErrMinimal )or(FEpoch>=FEpochMaximal);
end;
//------------------------------------------------------------------------------
procedure TNeuralNet.TrainEpoch( ATrainData : array of Real; ATrainResult : array of Real );
var
  n,m,ACountInputs, InputIndex, ACountOutputs,OutputIndex,LayerIndex,NeuronIndex,SynapseIndex:Integer;
  AError :Real;
  AResult, si, AWeight, s3 :Real;
  ADeltaW  : Real;

begin
  FError := 0;
  Inc( FEpoch );
  ACountInputs := CountInputs;
  ACountOutputs := CountOutputs;
  si := 0;
  m := Length(ATrainResult) div ACountOutputs;
  //------------------------
  for n:=0 to m - 1 do
    begin
    for InputIndex :=0 to ACountInputs-1 do
      Inputs[ InputIndex ] := ATrainData[ n * ACountInputs + InputIndex ];

    Compute();
    // Calculate the errors per neuron
    for OutputIndex:=0 to ACountOutputs-1 do
      begin
      AResult := ATrainResult[ n * ACountOutputs + OutputIndex ];
      AError := AResult - Outputs[OutputIndex];
      FError := FError + Sqr(AError);
      FLayers[CountLayers-1].FNeurons[OutputIndex].FError := AError * FLayers[CountLayers-1].FNeurons[OutputIndex].FSynapse[0].Connection.GetDif();
      si := si + Sqr(AResult);
      end;
//---------------------------------------------------------------------------------
    // Calculate the errors per neuron
    for LayerIndex := CountLayers-2 downto 1 do
      begin
      for NeuronIndex:=0 to FLayers[LayerIndex].CountNeurons-1 do
       FLayers[LayerIndex].FNeurons[NeuronIndex].FError:=0;

      for NeuronIndex:=0 to FLayers[LayerIndex+1].CountNeurons - 1 do
        begin
        for SynapseIndex:=0 to FLayers[LayerIndex+1].FNeurons[NeuronIndex].CountSynapses - 1 do
          FLayers[LayerIndex+1].FNeurons[NeuronIndex].FSynapse[SynapseIndex].Connection.FError :=
            FLayers[LayerIndex+1].FNeurons[NeuronIndex].FSynapse[SynapseIndex].Connection.FError +
            FLayers[LayerIndex+1].FNeurons[NeuronIndex].FSynapse[SynapseIndex].W *
            FLayers[LayerIndex+1].FNeurons[NeuronIndex].FError *
            FLayers[LayerIndex+1].FNeurons[NeuronIndex].FSynapse[SynapseIndex].Connection.GetDif();

        end;
      end;
//---------------------------------------------------------------------------------
    // Calculate the new weights from the errors per neuron
    for LayerIndex := CountLayers-1 downto 1 do
      for NeuronIndex:=0 to FLayers[LayerIndex].CountNeurons-1 do
        for SynapseIndex:=0 to FLayers[LayerIndex].FNeurons[NeuronIndex].CountSynapses - 1 do
         begin
         AWeight := FLayers[LayerIndex].FNeurons[NeuronIndex].FSynapse[SynapseIndex].W;
         AError := FLayers[LayerIndex].FNeurons[NeuronIndex].FError;
         s3 := FLayers[LayerIndex].FNeurons[NeuronIndex].FSynapse[SynapseIndex].Connection.GetOutput();
         ADeltaW := FStep * AError * s3;
         FLayers[LayerIndex].FNeurons[NeuronIndex].FSynapse[SynapseIndex].W := AWeight + ADeltaW;
         end;

//---------------------------------------------------------------------------------
    end;

  FError := 0.5 * sqrt(FError/(si+0.01));
end;
//------------------------------------------------------------------------------
end.
