unit uPSI_neuralnetworkCAI;
{
mymymneuralnet

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
  TPSImport_neuralnetwork = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TEasyBytePredictionViaNNet(CL: TPSPascalCompiler);
procedure SIRegister_TBytePredictionViaNNet(CL: TPSPascalCompiler);
procedure SIRegister_TNNetForByteProcessing(CL: TPSPascalCompiler);
procedure SIRegister_TNNetByteProcessing(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDataParallelism(CL: TPSPascalCompiler);
procedure SIRegister_THistoricalNets(CL: TPSPascalCompiler);
procedure SIRegister_TNNet(CL: TPSPascalCompiler);
procedure SIRegister_TNNetUpsample(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDeMaxPool(CL: TPSPascalCompiler);
procedure SIRegister_TNNetAvgChannel(CL: TPSPascalCompiler);
procedure SIRegister_TNNetAvgPool(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMinChannel(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMaxChannel(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMinPool(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMaxPoolPortable(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMaxPool(CL: TPSPascalCompiler);
procedure SIRegister_TNNetPoolBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDeLocalConnectReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLocalConnectReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDeLocalConnect(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLocalProduct(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLocalConnect(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDeconvolutionReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDeconvolution(CL: TPSPascalCompiler);
procedure SIRegister_TNNetPointwiseConvReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetPointwiseConvLinear(CL: TPSPascalCompiler);
procedure SIRegister_TNNetPointwiseConv(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConvolutionReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConvolutionLinear(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConvolutionSharedWeights(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConvolution(CL: TPSPascalCompiler);
procedure SIRegister_TNNetGroupedPointwiseConvReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetGroupedPointwiseConvLinear(CL: TPSPascalCompiler);
procedure SIRegister_TNNetGroupedConvolutionReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetGroupedConvolutionLinear(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConvolutionBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDepthwiseConvReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDepthwiseConvLinear(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDepthwiseConv(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConvolutionAbstract(CL: TPSPascalCompiler);
procedure SIRegister_TNNetSoftMax(CL: TPSPascalCompiler);
procedure SIRegister_TNNetFullConnectDiff(CL: TPSPascalCompiler);
procedure SIRegister_TNNetFullConnectReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetFullConnectSigmoid(CL: TPSPascalCompiler);
procedure SIRegister_TNNetFullConnectLinear(CL: TPSPascalCompiler);
procedure SIRegister_TNNetFullConnect(CL: TPSPascalCompiler);
procedure SIRegister_TNNetSplitChannelEvery(CL: TPSPascalCompiler);
procedure SIRegister_TNNetSplitChannels(CL: TPSPascalCompiler);
procedure SIRegister_TNNetSum(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDeepConcat(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConcat(CL: TPSPascalCompiler);
procedure SIRegister_TNNetConcatBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetReshape(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLocalResponseNormDepth(CL: TPSPascalCompiler);
procedure SIRegister_TNNetInterleaveChannels(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLocalResponseNorm2D(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelStdNormalization(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelZeroCenter(CL: TPSPascalCompiler);
procedure SIRegister_TNNetCellMul(CL: TPSPascalCompiler);
procedure SIRegister_TNNetCellBias(CL: TPSPascalCompiler);
procedure SIRegister_TNNetCellMulByCell(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelMulByLayer(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelMul(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelBias(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelShiftBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelTransformBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMovingStdNormalization(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLayerStdNormalization(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLayerMaxNormalization(CL: TPSPascalCompiler);
procedure SIRegister_TNNetChannelRandomMulAdd(CL: TPSPascalCompiler);
procedure SIRegister_TNNetRandomMulAdd(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDropout(CL: TPSPascalCompiler);
procedure SIRegister_TNNetAddNoiseBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetAddAndDiv(CL: TPSPascalCompiler);
procedure SIRegister_TNNetNegate(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMulByConstant(CL: TPSPascalCompiler);
procedure SIRegister_TNNetMulLearning(CL: TPSPascalCompiler);
procedure SIRegister_TNNetHyperbolicTangent(CL: TPSPascalCompiler);
procedure SIRegister_TNNetSigmoid(CL: TPSPascalCompiler);
procedure SIRegister_TNNetVeryLeakyReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLeakyReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetPower(CL: TPSPascalCompiler);
procedure SIRegister_TNNetReLUSqrt(CL: TPSPascalCompiler);
procedure SIRegister_TNNetSwish(CL: TPSPascalCompiler);
procedure SIRegister_TNNetSELU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetReLUL(CL: TPSPascalCompiler);
procedure SIRegister_TNNetReLU(CL: TPSPascalCompiler);
procedure SIRegister_TNNetDigital(CL: TPSPascalCompiler);
procedure SIRegister_TNNetReLUBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetIdentityWithoutBackprop(CL: TPSPascalCompiler);
procedure SIRegister_TNNetIdentityWithoutL2(CL: TPSPascalCompiler);
procedure SIRegister_TNNetPad(CL: TPSPascalCompiler);
procedure SIRegister_TNNetIdentity(CL: TPSPascalCompiler);
procedure SIRegister_TNNetInput(CL: TPSPascalCompiler);
procedure SIRegister_TNNetInputBase(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLayerList(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLayerConcatedWeights(CL: TPSPascalCompiler);
procedure SIRegister_TNNetLayer(CL: TPSPascalCompiler);
procedure SIRegister_TNNetNeuronList(CL: TPSPascalCompiler);
procedure SIRegister_TNNetNeuron(CL: TPSPascalCompiler);
procedure SIRegister_neuralnetwork(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralnetwork_Routines(S: TPSExec);
procedure RIRegister_TEasyBytePredictionViaNNet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBytePredictionViaNNet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetForByteProcessing(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetByteProcessing(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDataParallelism(CL: TPSRuntimeClassImporter);
procedure RIRegister_THistoricalNets(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetUpsample(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDeMaxPool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetAvgChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetAvgPool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMinChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMaxChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMinPool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMaxPoolPortable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMaxPool(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetPoolBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDeLocalConnectReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLocalConnectReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDeLocalConnect(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLocalProduct(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLocalConnect(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDeconvolutionReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDeconvolution(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetPointwiseConvReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetPointwiseConvLinear(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetPointwiseConv(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConvolutionReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConvolutionLinear(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConvolutionSharedWeights(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConvolution(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetGroupedPointwiseConvReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetGroupedPointwiseConvLinear(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetGroupedConvolutionReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetGroupedConvolutionLinear(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConvolutionBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDepthwiseConvReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDepthwiseConvLinear(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDepthwiseConv(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConvolutionAbstract(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetSoftMax(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetFullConnectDiff(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetFullConnectReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetFullConnectSigmoid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetFullConnectLinear(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetFullConnect(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetSplitChannelEvery(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetSplitChannels(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetSum(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDeepConcat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConcat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetConcatBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetReshape(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLocalResponseNormDepth(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetInterleaveChannels(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLocalResponseNorm2D(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelStdNormalization(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelZeroCenter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetCellMul(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetCellBias(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetCellMulByCell(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelMulByLayer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelMul(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelBias(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelShiftBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelTransformBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMovingStdNormalization(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLayerStdNormalization(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLayerMaxNormalization(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetChannelRandomMulAdd(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetRandomMulAdd(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDropout(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetAddNoiseBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetAddAndDiv(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetNegate(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMulByConstant(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetMulLearning(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetHyperbolicTangent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetSigmoid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetVeryLeakyReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLeakyReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetPower(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetReLUSqrt(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetSwish(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetSELU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetReLUL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetReLU(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetDigital(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetReLUBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetIdentityWithoutBackprop(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetIdentityWithoutL2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetPad(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetIdentity(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetInput(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetInputBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLayerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLayerConcatedWeights(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetLayer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetNeuronList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetNeuron(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralnetwork(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //cl
  //,neuralopencl
  //,fgl
  math
  ,syncobjs
  ,neuralvolume
  ,neuralgeneric
  ,neuralbyteprediction
  ,neuralcache
  ,neuralab
  ,neuralnetworkCAI
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralnetwork]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TEasyBytePredictionViaNNet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBytePredictionViaNNet', 'TEasyBytePredictionViaNNet') do
  with CL.AddClassN(CL.FindClass('TBytePredictionViaNNet'),'TEasyBytePredictionViaNNet') do
  begin
    RegisterMethod('Constructor Create( pActionByteLen, pStateByteLen : word; NumNeurons : integer; CacheSize : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBytePredictionViaNNet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMObject', 'TBytePredictionViaNNet') do
  with CL.AddClassN(CL.FindClass('TMObject'),'TBytePredictionViaNNet') do
  begin
    RegisterProperty('FCache', 'TCacheMem', iptrw);
    RegisterMethod('Constructor Create( pNN : TNNet; pActionByteLen, pStateByteLen : word; CacheSize : integer)');
    RegisterMethod('Procedure Predict( var pActions, pCurrentState : array of byte; var pPredictedState : array of byte)');
    RegisterMethod('Function newStateFound( stateFound : array of byte) : extended');
    RegisterProperty('NN', 'TNNet', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetForByteProcessing(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNet', 'TNNetForByteProcessing') do
  with CL.AddClassN(CL.FindClass('TNNet'),'TNNetForByteProcessing') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure AddBasicByteProcessingLayers( InputByteCount, OutputByteCount : integer; FullyConnectedLayersCnt : integer; NeuronsPerPath : integer)');
    RegisterMethod('Procedure Compute( var pInput : array of byte)');
    RegisterMethod('Procedure Backpropagate( var pOutput : array of byte)');
    RegisterMethod('Procedure GetOutput( var pOutput : array of byte)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetByteProcessing(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetByteProcessing') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetByteProcessing') do
  begin
    RegisterMethod('Constructor Create76( CacheSize, TestCount, OperationCount : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDataParallelism(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetList', 'TNNetDataParallelism') do
  with CL.AddClassN(CL.FindClass('TNNetList'),'TNNetDataParallelism') do
  begin
    RegisterProperty('Items', 'TNNet Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Constructor Create74( CloneNN : TNNet; pSize : integer; pFreeObjects : Boolean);');
    RegisterMethod('Constructor Create75( pSize : integer; pFreeObjects : Boolean);');
    RegisterMethod('Procedure SetLearningRate( pLearningRate, pInertia : TNeuralFloat)');
    RegisterMethod('Procedure SetBatchUpdate( pBatchUpdate : boolean)');
    RegisterMethod('Procedure SetL2Decay( pL2Decay : TNeuralFloat)');
    RegisterMethod('Procedure SetL2DecayToConvolutionalLayers( pL2Decay : TNeuralFloat)');
    RegisterMethod('Procedure EnableDropouts( pFlag : boolean)');
    RegisterMethod('Procedure CopyWeights( Origin : TNNet)');
    RegisterMethod('Procedure SumWeights( Destin : TNNet)');
    RegisterMethod('Procedure SumDeltas( Destin : TNNet)');
    RegisterMethod('Procedure AvgWeights( Destin : TNNet)');
    RegisterMethod('Procedure ReplaceAtIdxAndUpdateWeightAvg( Idx : integer; NewNet, AverageNet : TNNet)');
    RegisterMethod('Procedure DisableOpenCL( )');
    RegisterMethod('Procedure EnableOpenCL( platform_id : cl_platform_id; device_id : cl_device_id)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THistoricalNets(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNet', 'THistoricalNets') do
  with CL.AddClassN(CL.FindClass('TNNet'),'THistoricalNets') do
  begin
    RegisterMethod('Procedure AddLeCunLeNet5( IncludeInput : boolean)');
    RegisterMethod('Procedure AddAlexNet( IncludeInput : boolean)');
    RegisterMethod('Procedure AddVGGNet( IncludeInput : boolean)');
    RegisterMethod('Procedure AddResNetUnit( pNeurons : integer)');
    RegisterMethod('Function AddDenseNetBlock( pUnits, k : integer; BottleNeck : integer; supressBias : integer; DropoutRate : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function AddDenseNetTransition( Compression : TNeuralFloat; supressBias : integer; HasAvgPool : boolean) : TNNetLayer');
    RegisterMethod('Function AddDenseNetBlockCAI71( pUnits, k, supressBias : integer; PointWiseConv : TNNetConvolutionClass; IsSeparable : boolean; HasNorm : boolean; pBefore : TNNetLayerClass; pAfter : TNNetLayerClass; ' +
      'BottleNeck : integer; Compression : integer; DropoutRate : TNeuralFloat; RandomBias : integer; RandomAmplifier : integer; FeatureSize : integer) : TNNetLayer;');
    RegisterMethod('Function AddDenseNetBlockCAI72( pUnits, k, supressBias : integer; PointWiseConv : TNNetConvolutionClass; IsSeparable : boolean; HasNorm : boolean; pBeforeBottleNeck : TNNetLayerClass; pAfterBottleNeck' +
      ' : TNNetLayerClass; pBeforeConv : TNNetLayerClass; pAfterConv : TNNetLayerClass; BottleNeck : integer; Compression : integer; DropoutRate : TNeuralFloat; RandomBias : integer; RandomAmplifier : intege' +
      'r; FeatureSize : integer) : TNNetLayer;');
    RegisterMethod('Function AddkDenseNetBlock73( pUnits, k, supressBias : integer; PointWiseConv : TNNetGroupedPointwiseConvClass; IsSeparable : boolean; HasNorm : boolean; pBeforeBottleNeck : TNNetLayerClass; pAfterBot' +
      'tleNeck : TNNetLayerClass; pBeforeConv : TNNetLayerClass; pAfterConv : TNNetLayerClass; BottleNeck : integer; Compression : integer; DropoutRate : TNeuralFloat; RandomBias : integer; RandomAmplifier :' +
      ' integer; FeatureSize : integer; MinGroupSize : integer) : TNNetLayer;');
    RegisterMethod('Function AddParallelConvs( PointWiseConv : TNNetConvolutionClass; IsSeparable : boolean; CopyInput : boolean; pBeforeBottleNeck : TNNetLayerClass; pAfterBottleNeck : TNNetLayerClass; pBeforeConv : TNN' +
      'etLayerClass; pAfterConv : TNNetLayerClass; PreviousLayer : TNNetLayer; BottleNeck : integer; p11ConvCount : integer; p11FilterCount : integer; p33ConvCount : integer; p33FilterCount : integer; p55Con' +
      'vCount : integer; p55FilterCount : integer; p77ConvCount : integer; p77FilterCount : integer; maxPool : integer; minPool : integer) : TNNetLayer');
    RegisterMethod('Function AddDenseFullyConnected( pUnits, k, supressBias : integer; PointWiseConv : TNNetConvolutionClass; HasNorm : boolean; HasReLU : boolean; pBefore : TNNetLayerClass; pAfter : TNNetLayerClass; Bot' +
      'tleNeck : integer; Compression : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function AddSuperResolution( pSizeX, pSizeY, BottleNeck, pNeurons, pLayerCnt : integer; IsSeparable : boolean) : TNNetLayer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMObject', 'TNNet') do
  with CL.AddClassN(CL.FindClass('TMObject'),'TNNet') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Function CreateLayer( strData : string) : TNNetLayer');
    RegisterMethod('Function AddLayer47( pLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddLayer48( strData : string) : TNNetLayer;');
    RegisterMethod('Function AddLayer49( pLayers : array of TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddLayerAfter50( pLayer, pAfterLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddLayerAfter51( pLayer : TNNetLayer; pAfterLayerIdx : integer) : TNNetLayer;');
    RegisterMethod('Function AddLayerAfter52( strData : string; pAfterLayerIdx : integer) : TNNetLayer;');
    RegisterMethod('Function AddLayerAfter53( pLayers : array of TNNetLayer; pLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddLayerAfter54( pLayers : array of TNNetLayer; pAfterLayerIdx : integer) : TNNetLayer;');
    RegisterMethod('Function AddLayerConcatingInputOutput55( pLayers : array of TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddLayerConcatingInputOutput56( pLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddLayerDeepConcatingInputOutput57( pLayers : array of TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddLayerDeepConcatingInputOutput58( pLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddSeparableConv( pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pDepthMultiplier : integer; pSuppressBias : integer; pAfterLayer : TNNetLayer) : TNNetLayer');
    RegisterMethod('Function AddSeparableConvReLU( pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pDepthMultiplier : integer; pSuppressBias : integer; pAfterLayer : TNNetLayer) : TNNetLayer');
    RegisterMethod('Function AddSeparableConvLinear( pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pDepthMultiplier : integer; pSuppressBias : integer; pAfterLayer : TNNetLayer) : TNNetLayer');
    RegisterMethod('Function AddGroupedConvolution(Conv2d:TNNetConvolutionClass;Groups,pNumFeatures,pFeatureSize,pInputPadding, pStride : integer; pSuppressBias:integer; ChannelInterleaving:boolean): TNNetLayer');
    RegisterMethod('Function AddAutoGroupedPointwiseConv( Conv2d : TNNetGroupedPointwiseConvClass; MinChannelsPerGroupCount, pNumFeatures : integer; HasNormalization : boolean; pSuppressBias : integer; HasIntergroup : bo' +
      'olean) : TNNetLayer');
    RegisterMethod('Function AddAutoGroupedPointwiseConv2( Conv2d : TNNetGroupedPointwiseConvClass; MinChannelsPerGroupCount, pNumFeatures : integer; HasNormalization : boolean; pSuppressBias : integer; AlwaysIntergroup ' +
      ': boolean; HasIntergroup : boolean) : TNNetLayer');
    RegisterMethod('Function AddAutoGroupedConvolution( Conv2d : TNNetConvolutionClass; MinChannelsPerGroupCount, pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pSuppressBias : integer; ChannelInterleaving' +
      ' : boolean) : TNNetLayer');
    RegisterMethod('Function AddGroupedFullConnect( FullConnect : TNNetFullConnectClass; Groups, pNumFeatures : integer; pSuppressBias : integer; ChannelInterleaving : boolean) : TNNetLayer');
    RegisterMethod('Function AddMovingNorm59( PerCell : boolean; pAfterLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddMovingNorm60( PerCell : boolean; RandomBias, RandomAmplifier : integer; pAfterLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddChannelMovingNorm( PerCell : boolean; RandomBias, RandomAmplifier : integer; pAfterLayer : TNNetLayer) : TNNetLayer');
    RegisterMethod('Function AddConvOrSeparableConv61( IsSeparable, HasReLU, HasNorm : boolean; pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; PerCell : boolean; pSuppressBias : integer; RandomBias : integ' +
      'er; RandomAmplifier : integer; pAfterLayer : TNNetLayer) : TNNetLayer;');
    RegisterMethod('Function AddConvOrSeparableConv62( IsSeparable : boolean; pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pSuppressBias : integer; pActFn : TNNetActivationFunctionClass; pAfterLayer : TN' +
      'NetLayer) : TNNetLayer;');
    RegisterMethod('Function AddCompression( Compression : TNeuralFloat; supressBias : integer) : TNNetLayer');
    RegisterMethod('Function AddGroupedCompression( Compression : TNeuralFloat; MinGroupSize : integer; supressBias : integer; HasIntergroup : boolean) : TNNetLayer');
    RegisterMethod('Function AddMinMaxPool( pPoolSize : integer; pStride : integer; pPadding : integer) : TNNetLayer');
    RegisterMethod('Function AddAvgMaxPool( pPoolSize : integer; pMaxPoolDropout : TNeuralFloat; pKeepDepth : boolean; pAfterLayer : TNNetLayer) : TNNetLayer');
    RegisterMethod('Function AddMinMaxChannel( pAfterLayer : TNNetLayer) : TNNetLayer');
    RegisterMethod('Function AddAvgMaxChannel( pMaxPoolDropout : TNeuralFloat; pKeepDepth : boolean; pAfterLayer : TNNetLayer) : TNNetLayer');
    RegisterMethod('Procedure AddToExponentialWeightAverage( NewElement : TNNet; Decay : TNeuralFloat)');
    RegisterMethod('Procedure AddToWeightAverage( NewElement : TNNet; CurrentElementCount : integer)');
    RegisterMethod('Function GetFirstNeuronalLayerIdx( FromLayerIdx : integer) : integer');
    RegisterMethod('Function GetFirstImageNeuronalLayerIdx( FromLayerIdx : integer) : integer');
    RegisterMethod('Function GetFirstNeuronalLayerIdxWithChannels( FromLayerIdx, Channels : integer) : integer');
    RegisterMethod('Function GetLastLayerIdx( ) : integer');
    RegisterMethod('Function GetLastLayer( ) : TNNetLayer');
    RegisterMethod('Function GetRandomLayer( ) : TNNetLayer');
    RegisterMethod('Procedure Compute63( pInput, pOutput : TNNetVolumeList; FromLayerIdx : integer);');
    RegisterMethod('Procedure Compute64( pInput, pOutput : TNNetVolume; FromLayerIdx : integer);');
    RegisterMethod('Procedure Compute65( pInput : TNNetVolume; FromLayerIdx : integer);');
    RegisterMethod('Procedure Compute66( pInput : array of TNNetVolume);');
    RegisterMethod('Procedure Compute67( pInput : array of TNeuralFloatDynArr);');
    RegisterMethod('Procedure Compute68( pInput : array of TNeuralFloat; FromLayerIdx : integer);');
    RegisterMethod('Procedure Backpropagate69( pOutput : TNNetVolume);');
    RegisterMethod('Procedure BackpropagateForIdx( pOutput : TNNetVolume; const aIdx : array of integer)');
    RegisterMethod('Procedure BackpropagateFromLayerAndNeuron( LayerIdx, NeuronIdx : integer; Error : TNeuralFloat)');
    RegisterMethod('Procedure Backpropagate70( pOutput : array of TNeuralFloat);');
    RegisterMethod('Procedure GetOutput( pOutput : TNNetVolume)');
    RegisterMethod('Procedure AddOutput( pOutput : TNNetVolume)');
    RegisterMethod('Procedure SetActivationFn( ActFn, ActFnDeriv : TNeuralActivationFunction)');
    RegisterMethod('Procedure SetLearningRate( pLearningRate, pInertia : TNeuralFloat)');
    RegisterMethod('Procedure SetBatchUpdate( pBatchUpdate : boolean)');
    RegisterMethod('Procedure InitWeights( )');
    RegisterMethod('Procedure UpdateWeights( )');
    RegisterMethod('Procedure ClearDeltas( )');
    RegisterMethod('Procedure ResetBackpropCallCurrCnt( )');
    RegisterMethod('Procedure SetL2Decay( pL2Decay : TNeuralFloat)');
    RegisterMethod('Procedure SetL2DecayToConvolutionalLayers( pL2Decay : TNeuralFloat)');
    RegisterMethod('Procedure ComputeL2Decay( )');
    RegisterMethod('Procedure SetSmoothErrorPropagation( p : boolean)');
    RegisterMethod('Procedure ClearTime( )');
    RegisterMethod('Procedure Clear( )');
    RegisterMethod('Procedure IdxsToLayers( aIdx : array of integer; var aL : array of TNNetLayer)');
    RegisterMethod('Procedure EnableDropouts( pFlag : boolean)');
    RegisterMethod('Procedure RefreshDropoutMask( )');
    RegisterMethod('Procedure MulMulAddWeights( Value1, Value2 : TNeuralFloat; Origin : TNNet)');
    RegisterMethod('Procedure MulAddWeights( Value : TNeuralFloat; Origin : TNNet)');
    RegisterMethod('Procedure MulWeights( V : TNeuralFloat)');
    RegisterMethod('Procedure MulDeltas( V : TNeuralFloat)');
    RegisterMethod('Procedure SumWeights( Origin : TNNet)');
    RegisterMethod('Procedure SumDeltas( Origin : TNNet)');
    RegisterMethod('Procedure SumDeltasNoChecks( Origin : TNNet)');
    RegisterMethod('Procedure CopyWeights( Origin : TNNet)');
    RegisterMethod('Function ForceMaxAbsoluteDelta( vMax : TNeuralFloat) : TNeuralFloat');
    RegisterMethod('Function GetMaxAbsoluteDelta( ) : TNeuralFloat');
    RegisterMethod('Function NormalizeMaxAbsoluteDelta( NewMax : TNeuralFloat) : TNeuralFloat');
    RegisterMethod('Procedure ClearInertia( )');
    RegisterMethod('Procedure DisableOpenCL( )');
    RegisterMethod('Procedure EnableOpenCL( platform_id : cl_platform_id; device_id : cl_device_id)');
    RegisterMethod('Procedure DebugWeights( )');
    RegisterMethod('Procedure DebugErrors( )');
    RegisterMethod('Procedure DebugStructure( )');
    RegisterMethod('Function CountLayers( ) : integer');
    RegisterMethod('Function CountNeurons( ) : integer');
    RegisterMethod('Function CountWeights( ) : integer');
    RegisterMethod('Function GetWeightSum( ) : TNeuralFloat');
    RegisterMethod('Function GetBiasSum( ) : TNeuralFloat');
    RegisterMethod('Function SaveDataToString( ) : string');
    RegisterMethod('Procedure LoadDataFromString( strData : string)');
    RegisterMethod('Procedure LoadDataFromFile( filename : string)');
    RegisterMethod('Function SaveStructureToString( ) : string');
    RegisterMethod('Procedure LoadStructureFromString( strData : string)');
    RegisterMethod('Function SaveToString( ) : string');
    RegisterMethod('Procedure SaveToFile( filename : string)');
    RegisterMethod('Procedure LoadFromString( strData : string)');
    RegisterMethod('Procedure LoadFromFile( filename : string)');
    RegisterMethod('Function Clone( ) : TNNet');
    RegisterMethod('Procedure MulWeightsGlorotBengio( V : TNeuralFloat)');
    RegisterMethod('Procedure MulWeightsHe( V : TNeuralFloat)');
    RegisterMethod('Function ShouldIncDepartingBranchesCnt( pLayer : TNNetLayer) : boolean');
    RegisterProperty('BackwardTime', 'double', iptrw);
    RegisterProperty('ForwardTime', 'double', iptrw);
    RegisterProperty('Layers', 'TNNetLayerList', iptr);
    RegisterProperty('LearningRate', 'TNeuralFloat', iptr);
    RegisterProperty('MaxDeltaLayer', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetUpsample(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetDeMaxPool', 'TNNetUpsample') do
  with CL.AddClassN(CL.FindClass('TNNetDeMaxPool'),'TNNetUpsample') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure ComputePreviousLayerError( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDeMaxPool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetMaxPool', 'TNNetDeMaxPool') do
  with CL.AddClassN(CL.FindClass('TNNetMaxPool'),'TNNetDeMaxPool') do
  begin
    RegisterMethod('Constructor Create46( pPoolSize : integer; pSpacing : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure ComputePreviousLayerError( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetAvgChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetAvgPool', 'TNNetAvgChannel') do
  with CL.AddClassN(CL.FindClass('TNNetAvgPool'),'TNNetAvgChannel') do
  begin
    RegisterMethod('Constructor Create( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetAvgPool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetMaxPool', 'TNNetAvgPool') do
  with CL.AddClassN(CL.FindClass('TNNetMaxPool'),'TNNetAvgPool') do
  begin
    RegisterMethod('Constructor Create45( pPoolSize : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMinChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetMinPool', 'TNNetMinChannel') do
  with CL.AddClassN(CL.FindClass('TNNetMinPool'),'TNNetMinChannel') do
  begin
    RegisterMethod('Constructor Create( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMaxChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetMaxPool', 'TNNetMaxChannel') do
  with CL.AddClassN(CL.FindClass('TNNetMaxPool'),'TNNetMaxChannel') do
  begin
    RegisterMethod('Constructor Create( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMinPool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetPoolBase', 'TNNetMinPool') do
  with CL.AddClassN(CL.FindClass('TNNetPoolBase'),'TNNetMinPool') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMaxPoolPortable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetMaxPool', 'TNNetMaxPoolPortable') do
  with CL.AddClassN(CL.FindClass('TNNetMaxPool'),'TNNetMaxPoolPortable') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMaxPool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetPoolBase', 'TNNetMaxPool') do
  with CL.AddClassN(CL.FindClass('TNNetPoolBase'),'TNNetMaxPool') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetPoolBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetPoolBase') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetPoolBase') do
  begin
    RegisterMethod('Constructor Create44( pPoolSize : integer; pStride : integer; pPadding : integer);');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDeLocalConnectReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLocalConnectReLU', 'TNNetDeLocalConnectReLU') do
  with CL.AddClassN(CL.FindClass('TNNetLocalConnectReLU'),'TNNetDeLocalConnectReLU') do
  begin
    RegisterMethod('Constructor Create43( pNumFeatures, pFeatureSize : integer; pSuppressBias : integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLocalConnectReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLocalConnect', 'TNNetLocalConnectReLU') do
  with CL.AddClassN(CL.FindClass('TNNetLocalConnect'),'TNNetLocalConnectReLU') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDeLocalConnect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLocalConnect', 'TNNetDeLocalConnect') do
  with CL.AddClassN(CL.FindClass('TNNetLocalConnect'),'TNNetDeLocalConnect') do
  begin
    RegisterMethod('Constructor Create42( pNumFeatures, pFeatureSize : integer; pSuppressBias : integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLocalProduct(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionBase', 'TNNetLocalProduct') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionBase'),'TNNetLocalProduct') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure ComputeCPU( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure BackpropagateCPU( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLocalConnect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionBase', 'TNNetLocalConnect') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionBase'),'TNNetLocalConnect') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure ComputeCPU( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure BackpropagateCPU( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDeconvolutionReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionReLU', 'TNNetDeconvolutionReLU') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionReLU'),'TNNetDeconvolutionReLU') do
  begin
    RegisterMethod('Constructor Create41( pNumFeatures, pFeatureSize : integer; pSuppressBias : integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDeconvolution(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolution', 'TNNetDeconvolution') do
  with CL.AddClassN(CL.FindClass('TNNetConvolution'),'TNNetDeconvolution') do
  begin
    RegisterMethod('Constructor Create40( pNumFeatures, pFeatureSize : integer; pSuppressBias : integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetPointwiseConvReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionReLU', 'TNNetPointwiseConvReLU') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionReLU'),'TNNetPointwiseConvReLU') do
  begin
    RegisterMethod('Constructor Create( pNumFeatures : integer; pSuppressBias : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetPointwiseConvLinear(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionLinear', 'TNNetPointwiseConvLinear') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionLinear'),'TNNetPointwiseConvLinear') do
  begin
    RegisterMethod('Constructor Create( pNumFeatures : integer; pSuppressBias : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetPointwiseConv(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolution', 'TNNetPointwiseConv') do
  with CL.AddClassN(CL.FindClass('TNNetConvolution'),'TNNetPointwiseConv') do
  begin
    RegisterMethod('Constructor Create( pNumFeatures : integer; pSuppressBias : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConvolutionReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolution', 'TNNetConvolutionReLU') do
  with CL.AddClassN(CL.FindClass('TNNetConvolution'),'TNNetConvolutionReLU') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConvolutionLinear(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolution', 'TNNetConvolutionLinear') do
  with CL.AddClassN(CL.FindClass('TNNetConvolution'),'TNNetConvolutionLinear') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConvolutionSharedWeights(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolution', 'TNNetConvolutionSharedWeights') do
  with CL.AddClassN(CL.FindClass('TNNetConvolution'),'TNNetConvolutionSharedWeights') do
  begin
    RegisterMethod('Constructor Create39( LinkedLayer : TNNetLayer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConvolution(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionBase', 'TNNetConvolution') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionBase'),'TNNetConvolution') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetGroupedPointwiseConvReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetGroupedPointwiseConvLinear', 'TNNetGroupedPointwiseConvReLU') do
  with CL.AddClassN(CL.FindClass('TNNetGroupedPointwiseConvLinear'),'TNNetGroupedPointwiseConvReLU') do
  begin
    RegisterMethod('Constructor Create( pNumFeatures, pGroups : integer; pSuppressBias : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetGroupedPointwiseConvLinear(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetGroupedConvolutionLinear', 'TNNetGroupedPointwiseConvLinear') do
  with CL.AddClassN(CL.FindClass('TNNetGroupedConvolutionLinear'),'TNNetGroupedPointwiseConvLinear') do
  begin
    RegisterMethod('Constructor Create( pNumFeatures, pGroups : integer; pSuppressBias : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetGroupedConvolutionReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetGroupedConvolutionLinear', 'TNNetGroupedConvolutionReLU') do
  with CL.AddClassN(CL.FindClass('TNNetGroupedConvolutionLinear'),'TNNetGroupedConvolutionReLU') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetGroupedConvolutionLinear(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionBase', 'TNNetGroupedConvolutionLinear') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionBase'),'TNNetGroupedConvolutionLinear') do
  begin
    RegisterMethod('Constructor Create37( pNumFeatures, pFeatureSize, pInputPadding, pStride, pGroups : integer; pSuppressBias : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConvolutionBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionAbstract', 'TNNetConvolutionBase') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionAbstract'),'TNNetConvolutionBase') do
  begin
    RegisterMethod('Constructor Create36( pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pSuppressBias : integer);');
    RegisterMethod('Procedure EnableOpenCL( DotProductKernel : TDotProductKernel)');
    RegisterProperty('Pointwise', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDepthwiseConvReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetDepthwiseConv', 'TNNetDepthwiseConvReLU') do
  with CL.AddClassN(CL.FindClass('TNNetDepthwiseConv'),'TNNetDepthwiseConvReLU') do
  begin
    RegisterMethod('Constructor Create( pMultiplier, pFeatureSize, pInputPadding, pStride : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDepthwiseConvLinear(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetDepthwiseConv', 'TNNetDepthwiseConvLinear') do
  with CL.AddClassN(CL.FindClass('TNNetDepthwiseConv'),'TNNetDepthwiseConvLinear') do
  begin
    RegisterMethod('Constructor Create( pMultiplier, pFeatureSize, pInputPadding, pStride : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDepthwiseConv(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConvolutionAbstract', 'TNNetDepthwiseConv') do
  with CL.AddClassN(CL.FindClass('TNNetConvolutionAbstract'),'TNNetDepthwiseConv') do
  begin
    RegisterMethod('Constructor Create33( pMultiplier, pFeatureSize, pInputPadding, pStride : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure InitDefault( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConvolutionAbstract(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayerConcatedWeights', 'TNNetConvolutionAbstract') do
  with CL.AddClassN(CL.FindClass('TNNetLayerConcatedWeights'),'TNNetConvolutionAbstract') do
  begin
    RegisterMethod('Constructor Create32( pFeatureSize, pInputPadding, pStride : integer; pSuppressBias : integer);');
    RegisterMethod('Procedure InitDefault( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetSoftMax(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetSoftMax') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetSoftMax') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetFullConnectDiff(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetFullConnectReLU', 'TNNetFullConnectDiff') do
  with CL.AddClassN(CL.FindClass('TNNetFullConnectReLU'),'TNNetFullConnectDiff') do
  begin
    RegisterMethod('Constructor Create( pSizeX, pSizeY, pDepth : integer; pSuppressBias : integer)');
    RegisterMethod('Constructor Create31( pSize : integer; pSuppressBias : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetFullConnectReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetFullConnectLinear', 'TNNetFullConnectReLU') do
  with CL.AddClassN(CL.FindClass('TNNetFullConnectLinear'),'TNNetFullConnectReLU') do
  begin
    RegisterMethod('Procedure ComputeCPU( )');
    RegisterMethod('Procedure BackpropagateCPU( )');
    RegisterMethod('Constructor Create( pSizeX, pSizeY, pDepth : integer; pSuppressBias : integer)');
    RegisterMethod('Constructor Create30( pSize : integer; pSuppressBias : integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetFullConnectSigmoid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetFullConnect', 'TNNetFullConnectSigmoid') do
  with CL.AddClassN(CL.FindClass('TNNetFullConnect'),'TNNetFullConnectSigmoid') do
  begin
    RegisterMethod('Constructor Create( pSizeX, pSizeY, pDepth : integer; pSuppressBias : integer)');
    RegisterMethod('Constructor Create29( pSize : integer; pSuppressBias : integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetFullConnectLinear(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetFullConnect', 'TNNetFullConnectLinear') do
  with CL.AddClassN(CL.FindClass('TNNetFullConnect'),'TNNetFullConnectLinear') do
  begin
    RegisterMethod('Procedure ComputeCPU( )');
    RegisterMethod('Procedure BackpropagateCPU( )');
    RegisterMethod('Constructor Create( pSizeX, pSizeY, pDepth : integer; pSuppressBias : integer)');
    RegisterMethod('Constructor Create28( pSize : integer; pSuppressBias : integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetFullConnect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayerConcatedWeights', 'TNNetFullConnect') do
  with CL.AddClassN(CL.FindClass('TNNetLayerConcatedWeights'),'TNNetFullConnect') do
  begin
    RegisterMethod('Constructor Create26( pSizeX, pSizeY, pDepth : integer; pSuppressBias : integer);');
    RegisterMethod('Constructor Create27( pSize : integer; pSuppressBias : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure ComputeCPU( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure BackpropagateCPU( )');
    RegisterMethod('Procedure EnableOpenCL( DotProductKernel : TDotProductKernel)');
    RegisterMethod('Procedure ComputeOpenCL( )');
    RegisterMethod('Procedure BackpropagateOpenCL( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetSplitChannelEvery(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetSplitChannels', 'TNNetSplitChannelEvery') do
  with CL.AddClassN(CL.FindClass('TNNetSplitChannels'),'TNNetSplitChannelEvery') do
  begin
    RegisterMethod('Constructor Create24( GetChannelEvery, ChannelShift : integer);');
    RegisterMethod('Constructor Create25( pChannels : array of integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetSplitChannels(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetSplitChannels') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetSplitChannels') do
  begin
    RegisterMethod('Constructor Create22( ChannelStart, ChannelLen : integer);');
    RegisterMethod('Constructor Create23( pChannels : array of integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Function SaveStructureToString( ) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetSum(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConcatBase', 'TNNetSum') do
  with CL.AddClassN(CL.FindClass('TNNetConcatBase'),'TNNetSum') do
  begin
    RegisterMethod('Constructor Create21( aL : array of TNNetLayer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDeepConcat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConcatBase', 'TNNetDeepConcat') do
  with CL.AddClassN(CL.FindClass('TNNetConcatBase'),'TNNetDeepConcat') do
  begin
    RegisterMethod('Constructor Create20( aL : array of TNNetLayer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConcat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetConcatBase', 'TNNetConcat') do
  with CL.AddClassN(CL.FindClass('TNNetConcatBase'),'TNNetConcat') do
  begin
    RegisterMethod('Constructor Create18( pSizeX, pSizeY, pDepth : integer; aL : array of TNNetLayer);');
    RegisterMethod('Constructor Create19( aL : array of TNNetLayer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetConcatBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetConcatBase') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetConcatBase') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Function SaveStructureToString( ) : string');
    RegisterMethod('Procedure BackpropagateConcat( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetReshape(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetReshape') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetReshape') do
  begin
    RegisterMethod('Constructor Create17( pSizeX, pSizeY, pDepth : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLocalResponseNormDepth(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLocalResponseNorm2D', 'TNNetLocalResponseNormDepth') do
  with CL.AddClassN(CL.FindClass('TNNetLocalResponseNorm2D'),'TNNetLocalResponseNormDepth') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetInterleaveChannels(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetInterleaveChannels') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetInterleaveChannels') do
  begin
    RegisterMethod('Constructor Create16( StepSize : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLocalResponseNorm2D(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetLocalResponseNorm2D') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetLocalResponseNorm2D') do
  begin
    RegisterMethod('Constructor Create15( pSize : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelStdNormalization(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetChannelZeroCenter', 'TNNetChannelStdNormalization') do
  with CL.AddClassN(CL.FindClass('TNNetChannelZeroCenter'),'TNNetChannelStdNormalization') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure InitDefault( )');
    RegisterMethod('Function GetMaxAbsoluteDelta( ) : TNeuralFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelZeroCenter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetChannelShiftBase', 'TNNetChannelZeroCenter') do
  with CL.AddClassN(CL.FindClass('TNNetChannelShiftBase'),'TNNetChannelZeroCenter') do
  begin
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure ComputeL2Decay( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetCellMul(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentityWithoutL2', 'TNNetCellMul') do
  with CL.AddClassN(CL.FindClass('TNNetIdentityWithoutL2'),'TNNetCellMul') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure InitDefault( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetCellBias(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentityWithoutL2', 'TNNetCellBias') do
  with CL.AddClassN(CL.FindClass('TNNetIdentityWithoutL2'),'TNNetCellBias') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure InitDefault( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetCellMulByCell(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetChannelTransformBase', 'TNNetCellMulByCell') do
  with CL.AddClassN(CL.FindClass('TNNetChannelTransformBase'),'TNNetCellMulByCell') do
  begin
    RegisterMethod('Constructor Create( LayerA, LayerB : TNNetLayer)');
    RegisterMethod('Constructor Create( LayerAIdx, LayerBIdx : integer)');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelMulByLayer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetChannelTransformBase', 'TNNetChannelMulByLayer') do
  with CL.AddClassN(CL.FindClass('TNNetChannelTransformBase'),'TNNetChannelMulByLayer') do
  begin
    RegisterMethod('Constructor Create( LayerWithChannels, LayerMul : TNNetLayer)');
    RegisterMethod('Constructor Create( LayerWithChannelsIdx, LayerMulIdx : integer)');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelMul(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetChannelTransformBase', 'TNNetChannelMul') do
  with CL.AddClassN(CL.FindClass('TNNetChannelTransformBase'),'TNNetChannelMul') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure InitDefault( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelBias(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetChannelShiftBase', 'TNNetChannelBias') do
  with CL.AddClassN(CL.FindClass('TNNetChannelShiftBase'),'TNNetChannelBias') do
  begin
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelShiftBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetChannelTransformBase', 'TNNetChannelShiftBase') do
  with CL.AddClassN(CL.FindClass('TNNetChannelTransformBase'),'TNNetChannelShiftBase') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure InitDefault( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelTransformBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentityWithoutL2', 'TNNetChannelTransformBase') do
  with CL.AddClassN(CL.FindClass('TNNetIdentityWithoutL2'),'TNNetChannelTransformBase') do
  begin
    RegisterMethod('Constructor Create( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMovingStdNormalization(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentityWithoutL2', 'TNNetMovingStdNormalization') do
  with CL.AddClassN(CL.FindClass('TNNetIdentityWithoutL2'),'TNNetMovingStdNormalization') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure InitDefault( )');
    RegisterMethod('Function GetMaxAbsoluteDelta( ) : TNeuralFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLayerStdNormalization(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetLayerStdNormalization') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetLayerStdNormalization') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLayerMaxNormalization(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetLayerMaxNormalization') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetLayerMaxNormalization') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetChannelRandomMulAdd(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetAddNoiseBase', 'TNNetChannelRandomMulAdd') do
  with CL.AddClassN(CL.FindClass('TNNetAddNoiseBase'),'TNNetChannelRandomMulAdd') do
  begin
    RegisterMethod('Constructor Create14( AddRate, MulRate : integer);');
    RegisterMethod('Procedure SetPrevLayer( pPrevLayer : TNNetLayer)');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetRandomMulAdd(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetAddNoiseBase', 'TNNetRandomMulAdd') do
  with CL.AddClassN(CL.FindClass('TNNetAddNoiseBase'),'TNNetRandomMulAdd') do
  begin
    RegisterMethod('Constructor Create13( AddRate, MulRate : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDropout(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetAddNoiseBase', 'TNNetDropout') do
  with CL.AddClassN(CL.FindClass('TNNetAddNoiseBase'),'TNNetDropout') do
  begin
    RegisterMethod('Constructor Create12( Rate : double; OneMaskPerbatch : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure CopyWeights( Origin : TNNetLayer)');
    RegisterMethod('Procedure RefreshDropoutMask( )');
    RegisterProperty('DropoutMask', 'TNNetVolume', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetAddNoiseBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetAddNoiseBase') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetAddNoiseBase') do
  begin
    RegisterProperty('Enabled', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetAddAndDiv(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetAddAndDiv') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetAddAndDiv') do
  begin
    RegisterMethod('Constructor Create11( pAdd, pDiv : integer);');
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetNegate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetMulByConstant', 'TNNetNegate') do
  with CL.AddClassN(CL.FindClass('TNNetMulByConstant'),'TNNetNegate') do
  begin
    RegisterMethod('Constructor Create( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMulByConstant(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetMulLearning', 'TNNetMulByConstant') do
  with CL.AddClassN(CL.FindClass('TNNetMulLearning'),'TNNetMulByConstant') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetMulLearning(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetMulLearning') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetMulLearning') do
  begin
    RegisterMethod('Constructor Create10( pMul : integer);');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetHyperbolicTangent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetSigmoid', 'TNNetHyperbolicTangent') do
  with CL.AddClassN(CL.FindClass('TNNetSigmoid'),'TNNetHyperbolicTangent') do
  begin
    RegisterMethod('Constructor Create( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetSigmoid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetSigmoid') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetSigmoid') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetVeryLeakyReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLeakyReLU', 'TNNetVeryLeakyReLU') do
  with CL.AddClassN(CL.FindClass('TNNetLeakyReLU'),'TNNetVeryLeakyReLU') do
  begin
    RegisterMethod('Constructor Create( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLeakyReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetReLUBase', 'TNNetLeakyReLU') do
  with CL.AddClassN(CL.FindClass('TNNetReLUBase'),'TNNetLeakyReLU') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetPower(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetReLUBase', 'TNNetPower') do
  with CL.AddClassN(CL.FindClass('TNNetReLUBase'),'TNNetPower') do
  begin
    RegisterMethod('Constructor Create9( iPower : integer);');
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetReLUSqrt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetReLUBase', 'TNNetReLUSqrt') do
  with CL.AddClassN(CL.FindClass('TNNetReLUBase'),'TNNetReLUSqrt') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetSwish(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetReLUBase', 'TNNetSwish') do
  with CL.AddClassN(CL.FindClass('TNNetReLUBase'),'TNNetSwish') do
  begin
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetSELU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetReLUBase', 'TNNetSELU') do
  with CL.AddClassN(CL.FindClass('TNNetReLUBase'),'TNNetSELU') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetReLUL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetReLUBase', 'TNNetReLUL') do
  with CL.AddClassN(CL.FindClass('TNNetReLUBase'),'TNNetReLUL') do
  begin
    RegisterMethod('Constructor Create8( LowLimit, HighLimit : integer);');
    RegisterMethod('Procedure Compute( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetReLU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetReLUBase', 'TNNetReLU') do
  with CL.AddClassN(CL.FindClass('TNNetReLUBase'),'TNNetReLU') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDigital(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetDigital') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetDigital') do
  begin
    RegisterMethod('Constructor Create7( LowValue, HighValue : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetReLUBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetReLUBase') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetReLUBase') do
  begin
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetIdentityWithoutBackprop(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetIdentityWithoutBackprop') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetIdentityWithoutBackprop') do
  begin
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetIdentityWithoutL2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetIdentity', 'TNNetIdentityWithoutL2') do
  with CL.AddClassN(CL.FindClass('TNNetIdentity'),'TNNetIdentityWithoutL2') do
  begin
    RegisterMethod('Procedure ComputeL2Decay( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetPad(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetPad') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetPad') do
  begin
    RegisterMethod('Constructor Create6( Padding : integer);');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetIdentity(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetIdentity') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetIdentity') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetInput(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetInputBase', 'TNNetInput') do
  with CL.AddClassN(CL.FindClass('TNNetInputBase'),'TNNetInput') do
  begin
    RegisterMethod('Constructor Create3( pSize : integer);');
    RegisterMethod('Constructor Create4( pSizeX, pSizeY, pDepth : integer);');
    RegisterMethod('Constructor Create5( pSizeX, pSizeY, pDepth, pError : integer);');
    RegisterMethod('Function EnableErrorCollection : TNNetInput');
    RegisterMethod('Function DisableErrorCollection : TNNetInput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetInputBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetInputBase') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetInputBase') do
  begin
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLayerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetList', 'TNNetLayerList') do
  with CL.AddClassN(CL.FindClass('TNNetList'),'TNNetLayerList') do
  begin
    RegisterProperty('Items', 'TNNetLayer Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLayerConcatedWeights(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetLayer', 'TNNetLayerConcatedWeights') do
  with CL.AddClassN(CL.FindClass('TNNetLayer'),'TNNetLayerConcatedWeights') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure RefreshNeuronWeightList( )');
    RegisterMethod('Procedure EnableOpenCL( DotProductKernel : TDotProductKernel)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetLayer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMObject', 'TNNetLayer') do
  with CL.AddClassN(CL.FindClass('TMObject'),'TNNetLayer') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure DisableOpenCL( )');
    RegisterMethod('Procedure EnableOpenCL( DotProductKernel : TDotProductKernel)');
    RegisterMethod('Procedure Compute( )');
    RegisterMethod('Procedure Backpropagate( )');
    RegisterMethod('Procedure ComputeOutputErrorForOneNeuron( NeuronIdx : integer; value : TNeuralFloat)');
    RegisterMethod('Procedure ComputeOutputErrorWith( pOutput : TNNetVolume)');
    RegisterMethod('Procedure ComputeOutputErrorForIdx( pOutput : TNNetVolume; const aIdx : array of integer)');
    RegisterMethod('Procedure ComputeErrorDeriv( )');
    RegisterMethod('Procedure Fill( value : TNeuralFloat)');
    RegisterMethod('Procedure ClearDeltas( )');
    RegisterMethod('Procedure AddNeurons( NeuronNum : integer)');
    RegisterMethod('Procedure AddMissingNeurons( NeuronNum : integer)');
    RegisterMethod('Procedure SetNumWeightsForAllNeurons0( NumWeights : integer);');
    RegisterMethod('Procedure SetNumWeightsForAllNeurons1( x, y, d : integer);');
    RegisterMethod('Procedure SetNumWeightsForAllNeurons2( Origin : TNNetVolume);');
    RegisterMethod('Function GetMaxWeight( ) : TNeuralFloat');
    RegisterMethod('Function GetMinWeight( ) : TNeuralFloat');
    RegisterMethod('Function GetMaxDelta( ) : TNeuralFloat');
    RegisterMethod('Function GetMinDelta( ) : TNeuralFloat');
    RegisterMethod('Function ForceMaxAbsoluteDelta( vMax : TNeuralFloat) : TNeuralFloat');
    RegisterMethod('Function GetMaxAbsoluteDelta( ) : TNeuralFloat');
    RegisterMethod('Procedure GetMinMaxAtDepth( pDepth : integer; var pMin, pMax : TNeuralFloat)');
    RegisterMethod('Function GetWeightSum( ) : TNeuralFloat');
    RegisterMethod('Function GetBiasSum( ) : TNeuralFloat');
    RegisterMethod('Function GetInertiaSum( ) : TNeuralFloat');
    RegisterMethod('Function CountWeights( ) : integer');
    RegisterMethod('Function CountNeurons( ) : integer');
    RegisterMethod('Procedure MulWeights( V : TNeuralFloat)');
    RegisterMethod('Procedure MulDeltas( V : TNeuralFloat)');
    RegisterMethod('Procedure ClearInertia( )');
    RegisterMethod('Procedure ClearTimes( )');
    RegisterMethod('Procedure AddTimes( Origin : TNNetLayer)');
    RegisterMethod('Procedure CopyTimes( Origin : TNNetLayer)');
    RegisterMethod('Procedure MulMulAddWeights( Value1, Value2 : TNeuralFloat; Origin : TNNetLayer)');
    RegisterMethod('Procedure SumWeights( Origin : TNNetLayer)');
    RegisterMethod('Procedure SumDeltas( Origin : TNNetLayer)');
    RegisterMethod('Procedure SumDeltasNoChecks( Origin : TNNetLayer)');
    RegisterMethod('Procedure CopyWeights( Origin : TNNetLayer)');
    RegisterMethod('Procedure ForceRangeWeights( V : TNeuralFloat)');
    RegisterMethod('Procedure NormalizeWeights( VMax : TNeuralFloat)');
    RegisterMethod('Function SaveDataToString( ) : string');
    RegisterMethod('Procedure LoadDataFromString( strData : string)');
    RegisterMethod('Function SaveStructureToString( ) : string');
    RegisterMethod('Procedure SetBatchUpdate( pBatchUpdate : boolean)');
    RegisterMethod('Procedure UpdateWeights( )');
    RegisterMethod('Function InitBasicPatterns( ) : TNNetLayer');
    RegisterMethod('Procedure IncDepartingBranchesCnt( )');
    RegisterMethod('Procedure ResetBackpropCallCurrCnt( )');
    RegisterMethod('Function InitUniform( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function InitLeCunUniform( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function InitHeUniform( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function InitHeUniformDepthwise( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function InitHeGaussian( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function InitHeGaussianDepthwise( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function InitGlorotBengioUniform( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Function InitSELU( Value : TNeuralFloat) : TNNetLayer');
    RegisterMethod('Procedure InitDefault( )');
    RegisterProperty('ActivationFn', 'TNeuralActivationFunction', iptrw);
    RegisterProperty('ActivationFnDerivative', 'TNeuralActivationFunction', iptrw);
    RegisterProperty('Neurons', 'TNNetNeuronList', iptr);
    RegisterProperty('NN', 'TNNet', iptrw);
    RegisterProperty('Output', 'TNNetVolume', iptr);
    RegisterProperty('OutputRaw', 'TNNetVolume', iptr);
    RegisterProperty('PrevLayer', 'TNNetLayer', iptrw);
    RegisterProperty('LearningRate', 'TNeuralFloat', iptrw);
    RegisterProperty('L2Decay', 'TNeuralFloat', iptrw);
    RegisterProperty('Inertia', 'TNeuralFloat', iptr);
    RegisterProperty('OutputError', 'TNNetVolume', iptrw);
    RegisterProperty('OutputErrorDeriv', 'TNNetVolume', iptrw);
    RegisterProperty('LayerIdx', 'integer', iptr);
    RegisterProperty('SmoothErrorPropagation', 'boolean', iptrw);
    RegisterProperty('BackwardTime', 'double', iptrw);
    RegisterProperty('ForwardTime', 'double', iptrw);
    RegisterProperty('LinkedNeurons', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetNeuronList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetList', 'TNNetNeuronList') do
  with CL.AddClassN(CL.FindClass('TNNetList'),'TNNetNeuronList') do
  begin
    RegisterProperty('Items', 'TNNetNeuron Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Constructor CreateWithElements( ElementCount : integer)');
    RegisterMethod('Function GetMaxWeight( ) : TNeuralFloat');
    RegisterMethod('Function GetMaxAbsWeight( ) : TNeuralFloat');
    RegisterMethod('Function GetMinWeight( ) : TNeuralFloat');
    RegisterMethod('Procedure InitForDebug( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetNeuron(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMObject', 'TNNetNeuron') do
  with CL.AddClassN(CL.FindClass('TMObject'),'TNNetNeuron') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Fill( Value : TNeuralFloat)');
    RegisterMethod('Procedure AddInertia( )');
    RegisterMethod('Procedure UpdateWeights( Inertia : TNeuralFloat)');
    RegisterMethod('Function SaveToString( ) : string');
    RegisterMethod('Procedure LoadFromString( strData : string)');
    RegisterMethod('Procedure ClearDelta');
    RegisterMethod('Procedure InitUniform( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitGaussian( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitLeCunUniform( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitHeUniform( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitHeGaussian( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitHeUniformDepthwise( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitHeGaussianDepthwise( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitSELU( Value : TNeuralFloat)');
    RegisterProperty('Weights', 'TNNetVolume', iptr);
    RegisterProperty('BackInertia', 'TNNetVolume', iptr);
    RegisterProperty('Delta', 'TNNetVolume', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralnetwork(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('csMaxInterleavedSize','integer').SetInt( 95);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNNet');
  SIRegister_TNNetNeuron(CL);
  SIRegister_TNNetNeuronList(CL);
 CL.AddConstantN('csNNetMaxParameterIdx','LongInt').SetInt( 7);
  SIRegister_TNNetLayer(CL);
  //CL.AddTypeS('TNNetLayerClass', 'class of TNNetLayer');
  SIRegister_TNNetLayerConcatedWeights(CL);
  SIRegister_TNNetLayerList(CL);
  SIRegister_TNNetInputBase(CL);
  SIRegister_TNNetInput(CL);
  SIRegister_TNNetIdentity(CL);
  SIRegister_TNNetPad(CL);
  SIRegister_TNNetIdentityWithoutL2(CL);
  SIRegister_TNNetIdentityWithoutBackprop(CL);
  //CL.AddTypeS('TNNetActivationFunctionClass', 'class of TNNetIdentity');
  SIRegister_TNNetReLUBase(CL);
  SIRegister_TNNetDigital(CL);
  SIRegister_TNNetReLU(CL);
  SIRegister_TNNetReLUL(CL);
  SIRegister_TNNetSELU(CL);
  SIRegister_TNNetSwish(CL);
  SIRegister_TNNetReLUSqrt(CL);
  SIRegister_TNNetPower(CL);
  SIRegister_TNNetLeakyReLU(CL);
  SIRegister_TNNetVeryLeakyReLU(CL);
  SIRegister_TNNetSigmoid(CL);
  SIRegister_TNNetHyperbolicTangent(CL);
  SIRegister_TNNetMulLearning(CL);
  SIRegister_TNNetMulByConstant(CL);
  SIRegister_TNNetNegate(CL);
  SIRegister_TNNetAddAndDiv(CL);
  SIRegister_TNNetAddNoiseBase(CL);
  SIRegister_TNNetDropout(CL);
  SIRegister_TNNetRandomMulAdd(CL);
  SIRegister_TNNetChannelRandomMulAdd(CL);
  SIRegister_TNNetLayerMaxNormalization(CL);
  SIRegister_TNNetLayerStdNormalization(CL);
  SIRegister_TNNetMovingStdNormalization(CL);
  SIRegister_TNNetChannelTransformBase(CL);
  SIRegister_TNNetChannelShiftBase(CL);
  SIRegister_TNNetChannelBias(CL);
  SIRegister_TNNetChannelMul(CL);
  SIRegister_TNNetChannelMulByLayer(CL);
  SIRegister_TNNetCellMulByCell(CL);
  SIRegister_TNNetCellBias(CL);
  SIRegister_TNNetCellMul(CL);
  SIRegister_TNNetChannelZeroCenter(CL);
  SIRegister_TNNetChannelStdNormalization(CL);
  SIRegister_TNNetLocalResponseNorm2D(CL);
  SIRegister_TNNetInterleaveChannels(CL);
  SIRegister_TNNetLocalResponseNormDepth(CL);
  SIRegister_TNNetReshape(CL);
  SIRegister_TNNetConcatBase(CL);
  SIRegister_TNNetConcat(CL);
  SIRegister_TNNetDeepConcat(CL);
  SIRegister_TNNetSum(CL);
  SIRegister_TNNetSplitChannels(CL);
  SIRegister_TNNetSplitChannelEvery(CL);
  SIRegister_TNNetFullConnect(CL);
  //CL.AddTypeS('TNNetFullConnectClass', 'class of TNNetFullConnect');
  SIRegister_TNNetFullConnectLinear(CL);
  SIRegister_TNNetFullConnectSigmoid(CL);
  SIRegister_TNNetFullConnectReLU(CL);
  SIRegister_TNNetFullConnectDiff(CL);
  SIRegister_TNNetSoftMax(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNNetLayerFullConnect');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNNetLayerFullConnectReLU');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNNetLayerSoftMax');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNNetDense');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNNetDenseReLU');
  SIRegister_TNNetConvolutionAbstract(CL);
  SIRegister_TNNetDepthwiseConv(CL);
  SIRegister_TNNetDepthwiseConvLinear(CL);
  SIRegister_TNNetDepthwiseConvReLU(CL);
  SIRegister_TNNetConvolutionBase(CL);
  //CL.AddTypeS('TNNetConvolutionClass', 'class of TNNetConvolutionBase');
  SIRegister_TNNetGroupedConvolutionLinear(CL);
  SIRegister_TNNetGroupedConvolutionReLU(CL);
  SIRegister_TNNetGroupedPointwiseConvLinear(CL);
  //CL.AddTypeS('TNNetGroupedPointwiseConvClass', 'class of TNNetGroupedPointwiseConvLinear');
  SIRegister_TNNetGroupedPointwiseConvReLU(CL);
  SIRegister_TNNetConvolution(CL);
  SIRegister_TNNetConvolutionSharedWeights(CL);
  SIRegister_TNNetConvolutionLinear(CL);
  SIRegister_TNNetConvolutionReLU(CL);
  SIRegister_TNNetPointwiseConv(CL);
  SIRegister_TNNetPointwiseConvLinear(CL);
  SIRegister_TNNetPointwiseConvReLU(CL);
  SIRegister_TNNetDeconvolution(CL);
  SIRegister_TNNetDeconvolutionReLU(CL);
  SIRegister_TNNetLocalConnect(CL);
  SIRegister_TNNetLocalProduct(CL);
  SIRegister_TNNetDeLocalConnect(CL);
  SIRegister_TNNetLocalConnectReLU(CL);
  SIRegister_TNNetDeLocalConnectReLU(CL);
  SIRegister_TNNetPoolBase(CL);
  SIRegister_TNNetMaxPool(CL);
  SIRegister_TNNetMaxPoolPortable(CL);
  SIRegister_TNNetMinPool(CL);
  SIRegister_TNNetMaxChannel(CL);
  SIRegister_TNNetMinChannel(CL);
  SIRegister_TNNetAvgPool(CL);
  SIRegister_TNNetAvgChannel(CL);
  SIRegister_TNNetDeMaxPool(CL);
  SIRegister_TNNetUpsample(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNNetDeAvgPool');
  SIRegister_TNNet(CL);
  SIRegister_THistoricalNets(CL);
  SIRegister_TNNetDataParallelism(CL);
  SIRegister_TNNetByteProcessing(CL);
  SIRegister_TNNetForByteProcessing(CL);
  SIRegister_TBytePredictionViaNNet(CL);
  SIRegister_TEasyBytePredictionViaNNet(CL);
 CL.AddDelphiFunction('Procedure CompareComputing( NN1, NN2 : TNNet)');
 CL.AddDelphiFunction('Procedure CompareNNStructure( NN, NN2 : TNNet)');
 CL.AddDelphiFunction('Procedure TestConvolutionAPI( )');
 CL.AddDelphiFunction('Procedure TestDataParallelism( NN : TNNet)');
 CL.AddDelphiFunction('Procedure TestConvolutionOpenCL( platform_id : cl_platform_id; device_id : cl_device_id)');
 CL.AddDelphiFunction('Procedure TestFullConnectOpenCL( platform_id : cl_platform_id; device_id : cl_device_id)');
 CL.AddDelphiFunction('Procedure RebuildPatternOnPreviousPatterns( Calculated : TNNetVolume; LocalWeight : TNNetVolume; PrevLayer : TNNetNeuronList; PrevStride : integer; ReLU : boolean; Threshold : TNeuralFloat)');
 CL.AddDelphiFunction('Procedure RebuildNeuronListOnPreviousPatterns( CalculatedLayer : TNNetNeuronList; CurrentLayer, PrevLayer : TNNetNeuronList; PrevStride : integer; ReLU : boolean; Threshold : TNeuralFloat)');
end;

(* === run-time registration functions === *)

(*----------------------------------------------------------------------------*)
procedure TBytePredictionViaNNetNN_R(Self: TBytePredictionViaNNet; var T: TNNet);
begin T := Self.NN; end;

(*----------------------------------------------------------------------------*)
procedure TBytePredictionViaNNetFCache_W(Self: TBytePredictionViaNNet; const T: TCacheMem);
Begin Self.FCache := T; end;

(*----------------------------------------------------------------------------*)
procedure TBytePredictionViaNNetFCache_R(Self: TBytePredictionViaNNet; var T: TCacheMem);
Begin T := Self.FCache; end;

(*----------------------------------------------------------------------------*)
Function TNNetByteProcessingCreate76_P(Self: TClass; CreateNewInstance: Boolean;  CacheSize, TestCount, OperationCount : integer):TObject;
Begin Result := TNNetByteProcessing.Create(CacheSize, TestCount, OperationCount); END;

(*----------------------------------------------------------------------------*)
Function TNNetDataParallelismCreate75_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer; pFreeObjects : Boolean):TObject;
Begin Result := TNNetDataParallelism.Create(pSize, pFreeObjects); END;

(*----------------------------------------------------------------------------*)
Function TNNetDataParallelismCreate74_P(Self: TClass; CreateNewInstance: Boolean;  CloneNN : TNNet; pSize : integer; pFreeObjects : Boolean):TObject;
Begin Result := TNNetDataParallelism.Create(CloneNN, pSize, pFreeObjects); END;

(*----------------------------------------------------------------------------*)
procedure TNNetDataParallelismItems_W(Self: TNNetDataParallelism; const T: TNNet; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetDataParallelismItems_R(Self: TNNetDataParallelism; var T: TNNet; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function THistoricalNetsAddkDenseNetBlock73_P(Self: THistoricalNets;  pUnits, k, supressBias : integer; PointWiseConv : TNNetGroupedPointwiseConvClass; IsSeparable : boolean; HasNorm : boolean; pBeforeBottleNeck : TNNetLayerClass; pAfterBottleNeck : TNNetLayerClass; pBeforeConv : TNNetLayerClass; pAfterConv : TNNetLayerClass; BottleNeck : integer; Compression : integer; DropoutRate : TNeuralFloat; RandomBias : integer; RandomAmplifier : integer; FeatureSize : integer; MinGroupSize : integer) : TNNetLayer;
Begin Result := Self.AddkDenseNetBlock(pUnits, k, supressBias, PointWiseConv, IsSeparable, HasNorm, pBeforeBottleNeck, pAfterBottleNeck, pBeforeConv, pAfterConv, BottleNeck, Compression, DropoutRate, RandomBias, RandomAmplifier, FeatureSize, MinGroupSize); END;

(*----------------------------------------------------------------------------*)
Function THistoricalNetsAddDenseNetBlockCAI72_P(Self: THistoricalNets;  pUnits, k, supressBias : integer; PointWiseConv : TNNetConvolutionClass; IsSeparable : boolean; HasNorm : boolean; pBeforeBottleNeck : TNNetLayerClass; pAfterBottleNeck : TNNetLayerClass; pBeforeConv : TNNetLayerClass; pAfterConv : TNNetLayerClass; BottleNeck : integer; Compression : integer; DropoutRate : TNeuralFloat; RandomBias : integer; RandomAmplifier : integer; FeatureSize : integer) : TNNetLayer;
Begin Result := Self.AddDenseNetBlockCAI(pUnits, k, supressBias, PointWiseConv, IsSeparable, HasNorm, pBeforeBottleNeck, pAfterBottleNeck, pBeforeConv, pAfterConv, BottleNeck, Compression, DropoutRate, RandomBias, RandomAmplifier, FeatureSize); END;

(*----------------------------------------------------------------------------*)
Function THistoricalNetsAddDenseNetBlockCAI71_P(Self: THistoricalNets;  pUnits, k, supressBias : integer; PointWiseConv : TNNetConvolutionClass; IsSeparable : boolean; HasNorm : boolean; pBefore : TNNetLayerClass; pAfter : TNNetLayerClass; BottleNeck : integer; Compression : integer; DropoutRate : TNeuralFloat; RandomBias : integer; RandomAmplifier : integer; FeatureSize : integer) : TNNetLayer;
Begin Result := Self.AddDenseNetBlockCAI(pUnits, k, supressBias, PointWiseConv, IsSeparable, HasNorm, pBefore, pAfter, BottleNeck, Compression, DropoutRate, RandomBias, RandomAmplifier, FeatureSize); END;

(*----------------------------------------------------------------------------*)
procedure TNNetMaxDeltaLayer_R(Self: TNNet; var T: integer);
begin T := Self.MaxDeltaLayer; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLearningRate_R(Self: TNNet; var T: TNeuralFloat);
begin T := Self.LearningRate; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayers_R(Self: TNNet; var T: TNNetLayerList);
begin T := Self.Layers; end;

(*----------------------------------------------------------------------------*)
procedure TNNetForwardTime_W(Self: TNNet; const T: double);
begin Self.ForwardTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetForwardTime_R(Self: TNNet; var T: double);
begin T := Self.ForwardTime; end;

(*----------------------------------------------------------------------------*)
procedure TNNetBackwardTime_W(Self: TNNet; const T: double);
begin Self.BackwardTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetBackwardTime_R(Self: TNNet; var T: double);
begin T := Self.BackwardTime; end;

(*----------------------------------------------------------------------------*)
Procedure TNNetBackpropagate70_P(Self: TNNet;  pOutput : array of TNeuralFloat);
Begin Self.Backpropagate(pOutput); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetBackpropagate69_P(Self: TNNet;  pOutput : TNNetVolume);
Begin Self.Backpropagate(pOutput); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetCompute68_P(Self: TNNet;  pInput : array of TNeuralFloat; FromLayerIdx : integer);
Begin Self.Compute(pInput, FromLayerIdx); END;

(*----------------------------------------------------------------------------*)
//Procedure TNNetCompute67_P(Self: TNNet;  pInput : array of TNeuralFloatDynArr);
//B/egin Self.Compute(pInput); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetCompute66_P(Self: TNNet;  pInput : array of TNNetVolume);
Begin Self.Compute(pInput); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetCompute65_P(Self: TNNet;  pInput : TNNetVolume; FromLayerIdx : integer);
Begin Self.Compute(pInput, FromLayerIdx); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetCompute64_P(Self: TNNet;  pInput, pOutput : TNNetVolume; FromLayerIdx : integer);
Begin Self.Compute(pInput, pOutput, FromLayerIdx); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetCompute63_P(Self: TNNet;  pInput, pOutput : TNNetVolumeList; FromLayerIdx : integer);
Begin Self.Compute(pInput, pOutput, FromLayerIdx); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddConvOrSeparableConv62_P(Self: TNNet;  IsSeparable : boolean; pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pSuppressBias : integer; pActFn : TNNetActivationFunctionClass; pAfterLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddConvOrSeparableConv(IsSeparable, pNumFeatures, pFeatureSize, pInputPadding, pStride, pSuppressBias, pActFn, pAfterLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddConvOrSeparableConv61_P(Self: TNNet;  IsSeparable, HasReLU, HasNorm : boolean; pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; PerCell : boolean; pSuppressBias : integer; RandomBias : integer; RandomAmplifier : integer; pAfterLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddConvOrSeparableConv(IsSeparable, HasReLU, HasNorm, pNumFeatures, pFeatureSize, pInputPadding, pStride, PerCell, pSuppressBias, RandomBias, RandomAmplifier, pAfterLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddMovingNorm60_P(Self: TNNet;  PerCell : boolean; RandomBias, RandomAmplifier : integer; pAfterLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddMovingNorm(PerCell, RandomBias, RandomAmplifier, pAfterLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddMovingNorm59_P(Self: TNNet;  PerCell : boolean; pAfterLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddMovingNorm(PerCell, pAfterLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerDeepConcatingInputOutput58_P(Self: TNNet;  pLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayerDeepConcatingInputOutput(pLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerDeepConcatingInputOutput57_P(Self: TNNet;  pLayers : array of TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayerDeepConcatingInputOutput(pLayers); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerConcatingInputOutput56_P(Self: TNNet;  pLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayerConcatingInputOutput(pLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerConcatingInputOutput55_P(Self: TNNet;  pLayers : array of TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayerConcatingInputOutput(pLayers); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerAfter54_P(Self: TNNet;  pLayers : array of TNNetLayer; pAfterLayerIdx : integer) : TNNetLayer;
Begin Result := Self.AddLayerAfter(pLayers, pAfterLayerIdx); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerAfter53_P(Self: TNNet;  pLayers : array of TNNetLayer; pLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayerAfter(pLayers, pLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerAfter52_P(Self: TNNet;  strData : string; pAfterLayerIdx : integer) : TNNetLayer;
Begin Result := Self.AddLayerAfter(strData, pAfterLayerIdx); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerAfter51_P(Self: TNNet;  pLayer : TNNetLayer; pAfterLayerIdx : integer) : TNNetLayer;
Begin //Result := Self.AddLayerAfter(pLayer, pAfterLayerIdx);
END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayerAfter50_P(Self: TNNet;  pLayer, pAfterLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayerAfter(pLayer, pAfterLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayer49_P(Self: TNNet;  pLayers : array of TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayer(pLayers); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayer48_P(Self: TNNet;  strData : string) : TNNetLayer;
Begin Result := Self.AddLayer(strData); END;

(*----------------------------------------------------------------------------*)
Function TNNetAddLayer47_P(Self: TNNet;  pLayer : TNNetLayer) : TNNetLayer;
Begin Result := Self.AddLayer(pLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetDeMaxPoolCreate46_P(Self: TClass; CreateNewInstance: Boolean;  pPoolSize : integer; pSpacing : integer):TObject;
Begin Result := TNNetDeMaxPool.Create(pPoolSize, pSpacing); END;

(*----------------------------------------------------------------------------*)
Function TNNetAvgPoolCreate45_P(Self: TClass; CreateNewInstance: Boolean;  pPoolSize : integer):TObject;
Begin Result := TNNetAvgPool.Create(pPoolSize); END;

(*----------------------------------------------------------------------------*)
Function TNNetPoolBaseCreate44_P(Self: TClass; CreateNewInstance: Boolean;  pPoolSize : integer; pStride : integer; pPadding : integer):TObject;
Begin Result := TNNetPoolBase.Create(pPoolSize, pStride, pPadding); END;

(*----------------------------------------------------------------------------*)
Function TNNetDeLocalConnectReLUCreate43_P(Self: TClass; CreateNewInstance: Boolean;  pNumFeatures, pFeatureSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetDeLocalConnectReLU.Create(pNumFeatures, pFeatureSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetDeLocalConnectCreate42_P(Self: TClass; CreateNewInstance: Boolean;  pNumFeatures, pFeatureSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetDeLocalConnect.Create(pNumFeatures, pFeatureSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetDeconvolutionReLUCreate41_P(Self: TClass; CreateNewInstance: Boolean;  pNumFeatures, pFeatureSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetDeconvolutionReLU.Create(pNumFeatures, pFeatureSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetDeconvolutionCreate40_P(Self: TClass; CreateNewInstance: Boolean;  pNumFeatures, pFeatureSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetDeconvolution.Create(pNumFeatures, pFeatureSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetConvolutionSharedWeightsCreate39_P(Self: TClass; CreateNewInstance: Boolean;  LinkedLayer : TNNetLayer):TObject;
Begin Result := TNNetConvolutionSharedWeights.Create(LinkedLayer); END;

(*----------------------------------------------------------------------------*)
Function TNNetGroupedConvolutionReLUCreate38_P(Self: TClass; CreateNewInstance: Boolean;  pNumFeatures, pFeatureSize, pInputPadding, pStride, pGroups : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetGroupedConvolutionReLU.Create(pNumFeatures, pFeatureSize, pInputPadding, pStride, pGroups, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetGroupedConvolutionLinearCreate37_P(Self: TClass; CreateNewInstance: Boolean;  pNumFeatures, pFeatureSize, pInputPadding, pStride, pGroups : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetGroupedConvolutionLinear.Create(pNumFeatures, pFeatureSize, pInputPadding, pStride, pGroups, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
procedure TNNetConvolutionBasePointwise_R(Self: TNNetConvolutionBase; var T: boolean);
begin T := Self.Pointwise; end;

(*----------------------------------------------------------------------------*)
Function TNNetConvolutionBaseCreate36_P(Self: TClass; CreateNewInstance: Boolean;  pNumFeatures, pFeatureSize, pInputPadding, pStride : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetConvolutionBase.Create(pNumFeatures, pFeatureSize, pInputPadding, pStride, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetConvolutionBasePrepareInputForConvolution35_P(Self: TNNetConvolutionBase;  OutputX, OutputY : integer);
Begin //Self.PrepareInputForConvolution(OutputX, OutputY);
END;

(*----------------------------------------------------------------------------*)
//Procedure TNNetConvolutionBasePrepareInputForConvolution34_P(Self: TNNetConvolutionBase;  );
//Begin Self.PrepareInputForConvolution; END;

(*----------------------------------------------------------------------------*)
Function TNNetDepthwiseConvCreate33_P(Self: TClass; CreateNewInstance: Boolean;  pMultiplier, pFeatureSize, pInputPadding, pStride : integer):TObject;
Begin Result := TNNetDepthwiseConv.Create(pMultiplier, pFeatureSize, pInputPadding, pStride); END;

(*----------------------------------------------------------------------------*)
Function TNNetConvolutionAbstractCreate32_P(Self: TClass; CreateNewInstance: Boolean;  pFeatureSize, pInputPadding, pStride : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetConvolutionAbstract.Create(pFeatureSize, pInputPadding, pStride, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetFullConnectDiffCreate31_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetFullConnectDiff.Create(pSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetFullConnectReLUCreate30_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetFullConnectReLU.Create(pSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetFullConnectSigmoidCreate29_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetFullConnectSigmoid.Create(pSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetFullConnectLinearCreate28_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetFullConnectLinear.Create(pSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetFullConnectCreate27_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetFullConnect.Create(pSize, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetFullConnectCreate26_P(Self: TClass; CreateNewInstance: Boolean;  pSizeX, pSizeY, pDepth : integer; pSuppressBias : integer):TObject;
Begin Result := TNNetFullConnect.Create(pSizeX, pSizeY, pDepth, pSuppressBias); END;

(*----------------------------------------------------------------------------*)
Function TNNetSplitChannelEveryCreate25_P(Self: TClass; CreateNewInstance: Boolean;  pChannels : array of integer):TObject;
Begin Result := TNNetSplitChannelEvery.Create(pChannels); END;

(*----------------------------------------------------------------------------*)
Function TNNetSplitChannelEveryCreate24_P(Self: TClass; CreateNewInstance: Boolean;  GetChannelEvery, ChannelShift : integer):TObject;
Begin Result := TNNetSplitChannelEvery.Create(GetChannelEvery, ChannelShift); END;

(*----------------------------------------------------------------------------*)
Function TNNetSplitChannelsCreate23_P(Self: TClass; CreateNewInstance: Boolean;  pChannels : array of integer):TObject;
Begin Result := TNNetSplitChannels.Create(pChannels); END;

(*----------------------------------------------------------------------------*)
Function TNNetSplitChannelsCreate22_P(Self: TClass; CreateNewInstance: Boolean;  ChannelStart, ChannelLen : integer):TObject;
Begin Result := TNNetSplitChannels.Create(ChannelStart, ChannelLen); END;

(*----------------------------------------------------------------------------*)
Function TNNetSumCreate21_P(Self: TClass; CreateNewInstance: Boolean;  aL : array of TNNetLayer):TObject;
Begin Result := TNNetSum.Create(aL); END;

(*----------------------------------------------------------------------------*)
Function TNNetDeepConcatCreate20_P(Self: TClass; CreateNewInstance: Boolean;  aL : array of TNNetLayer):TObject;
Begin Result := TNNetDeepConcat.Create(aL); END;

(*----------------------------------------------------------------------------*)
Function TNNetConcatCreate19_P(Self: TClass; CreateNewInstance: Boolean;  aL : array of TNNetLayer):TObject;
Begin Result := TNNetConcat.Create(aL); END;

(*----------------------------------------------------------------------------*)
Function TNNetConcatCreate18_P(Self: TClass; CreateNewInstance: Boolean;  pSizeX, pSizeY, pDepth : integer; aL : array of TNNetLayer):TObject;
Begin Result := TNNetConcat.Create(pSizeX, pSizeY, pDepth, aL); END;

(*----------------------------------------------------------------------------*)
Function TNNetReshapeCreate17_P(Self: TClass; CreateNewInstance: Boolean;  pSizeX, pSizeY, pDepth : integer):TObject;
Begin Result := TNNetReshape.Create(pSizeX, pSizeY, pDepth); END;

(*----------------------------------------------------------------------------*)
Function TNNetInterleaveChannelsCreate16_P(Self: TClass; CreateNewInstance: Boolean;  StepSize : integer):TObject;
Begin Result := TNNetInterleaveChannels.Create(StepSize); END;

(*----------------------------------------------------------------------------*)
Function TNNetLocalResponseNorm2DCreate15_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer):TObject;
Begin Result := TNNetLocalResponseNorm2D.Create(pSize); END;

(*----------------------------------------------------------------------------*)
Function TNNetChannelRandomMulAddCreate14_P(Self: TClass; CreateNewInstance: Boolean;  AddRate, MulRate : integer):TObject;
Begin Result := TNNetChannelRandomMulAdd.Create(AddRate, MulRate); END;

(*----------------------------------------------------------------------------*)
Function TNNetRandomMulAddCreate13_P(Self: TClass; CreateNewInstance: Boolean;  AddRate, MulRate : integer):TObject;
Begin Result := TNNetRandomMulAdd.Create(AddRate, MulRate); END;

(*----------------------------------------------------------------------------*)
procedure TNNetDropoutDropoutMask_R(Self: TNNetDropout; var T: TNNetVolume);
begin T := Self.DropoutMask; end;

(*----------------------------------------------------------------------------*)
Function TNNetDropoutCreate12_P(Self: TClass; CreateNewInstance: Boolean;  Rate : double; OneMaskPerbatch : integer):TObject;
Begin Result := TNNetDropout.Create(Rate, OneMaskPerbatch); END;

(*----------------------------------------------------------------------------*)
procedure TNNetAddNoiseBaseEnabled_W(Self: TNNetAddNoiseBase; const T: boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetAddNoiseBaseEnabled_R(Self: TNNetAddNoiseBase; var T: boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
Function TNNetAddAndDivCreate11_P(Self: TClass; CreateNewInstance: Boolean;  pAdd, pDiv : integer):TObject;
Begin Result := TNNetAddAndDiv.Create(pAdd, pDiv); END;

(*----------------------------------------------------------------------------*)
Function TNNetMulLearningCreate10_P(Self: TClass; CreateNewInstance: Boolean;  pMul : integer):TObject;
Begin Result := TNNetMulLearning.Create(pMul); END;

(*----------------------------------------------------------------------------*)
Function TNNetPowerCreate9_P(Self: TClass; CreateNewInstance: Boolean;  iPower : integer):TObject;
Begin Result := TNNetPower.Create(iPower); END;

(*----------------------------------------------------------------------------*)
Function TNNetReLULCreate8_P(Self: TClass; CreateNewInstance: Boolean;  LowLimit, HighLimit : integer):TObject;
Begin Result := TNNetReLUL.Create(LowLimit, HighLimit); END;

(*----------------------------------------------------------------------------*)
Function TNNetDigitalCreate7_P(Self: TClass; CreateNewInstance: Boolean;  LowValue, HighValue : integer):TObject;
Begin Result := TNNetDigital.Create(LowValue, HighValue); END;

(*----------------------------------------------------------------------------*)
Function TNNetPadCreate6_P(Self: TClass; CreateNewInstance: Boolean;  Padding : integer):TObject;
Begin Result := TNNetPad.Create(Padding); END;

(*----------------------------------------------------------------------------*)
Function TNNetInputCreate5_P(Self: TClass; CreateNewInstance: Boolean;  pSizeX, pSizeY, pDepth, pError : integer):TObject;
Begin Result := TNNetInput.Create(pSizeX, pSizeY, pDepth, pError); END;

(*----------------------------------------------------------------------------*)
Function TNNetInputCreate4_P(Self: TClass; CreateNewInstance: Boolean;  pSizeX, pSizeY, pDepth : integer):TObject;
Begin Result := TNNetInput.Create(pSizeX, pSizeY, pDepth); END;

(*----------------------------------------------------------------------------*)
Function TNNetInputCreate3_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer):TObject;
Begin Result := TNNetInput.Create(pSize); END;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerListItems_W(Self: TNNetLayerList; const T: TNNetLayer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerListItems_R(Self: TNNetLayerList; var T: TNNetLayer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerLinkedNeurons_R(Self: TNNetLayer; var T: boolean);
begin T := Self.LinkedNeurons; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerForwardTime_W(Self: TNNetLayer; const T: double);
begin Self.ForwardTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerForwardTime_R(Self: TNNetLayer; var T: double);
begin T := Self.ForwardTime; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerBackwardTime_W(Self: TNNetLayer; const T: double);
begin Self.BackwardTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerBackwardTime_R(Self: TNNetLayer; var T: double);
begin T := Self.BackwardTime; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerSmoothErrorPropagation_W(Self: TNNetLayer; const T: boolean);
begin Self.SmoothErrorPropagation := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerSmoothErrorPropagation_R(Self: TNNetLayer; var T: boolean);
begin T := Self.SmoothErrorPropagation; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerLayerIdx_R(Self: TNNetLayer; var T: integer);
begin T := Self.LayerIdx; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerOutputErrorDeriv_W(Self: TNNetLayer; const T: TNNetVolume);
begin Self.OutputErrorDeriv := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerOutputErrorDeriv_R(Self: TNNetLayer; var T: TNNetVolume);
begin T := Self.OutputErrorDeriv; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerOutputError_W(Self: TNNetLayer; const T: TNNetVolume);
begin Self.OutputError := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerOutputError_R(Self: TNNetLayer; var T: TNNetVolume);
begin T := Self.OutputError; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerInertia_R(Self: TNNetLayer; var T: TNeuralFloat);
begin T := Self.Inertia; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerL2Decay_W(Self: TNNetLayer; const T: TNeuralFloat);
begin Self.L2Decay := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerL2Decay_R(Self: TNNetLayer; var T: TNeuralFloat);
begin T := Self.L2Decay; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerLearningRate_W(Self: TNNetLayer; const T: TNeuralFloat);
begin Self.LearningRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerLearningRate_R(Self: TNNetLayer; var T: TNeuralFloat);
begin T := Self.LearningRate; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerPrevLayer_W(Self: TNNetLayer; const T: TNNetLayer);
begin Self.PrevLayer := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerPrevLayer_R(Self: TNNetLayer; var T: TNNetLayer);
begin T := Self.PrevLayer; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerOutputRaw_R(Self: TNNetLayer; var T: TNNetVolume);
begin T := Self.OutputRaw; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerOutput_R(Self: TNNetLayer; var T: TNNetVolume);
begin T := Self.Output; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerNN_W(Self: TNNetLayer; const T: TNNet);
begin Self.NN := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerNN_R(Self: TNNetLayer; var T: TNNet);
begin T := Self.NN; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerNeurons_R(Self: TNNetLayer; var T: TNNetNeuronList);
begin T := Self.Neurons; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerActivationFnDerivative_W(Self: TNNetLayer; const T: TNeuralActivationFunction);
begin Self.ActivationFnDerivative := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerActivationFnDerivative_R(Self: TNNetLayer; var T: TNeuralActivationFunction);
begin T := Self.ActivationFnDerivative; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerActivationFn_W(Self: TNNetLayer; const T: TNeuralActivationFunction);
begin Self.ActivationFn := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetLayerActivationFn_R(Self: TNNetLayer; var T: TNeuralActivationFunction);
begin T := Self.ActivationFn; end;

(*----------------------------------------------------------------------------*)
Procedure TNNetLayerSetNumWeightsForAllNeurons2_P(Self: TNNetLayer;  Origin : TNNetVolume);
Begin Self.SetNumWeightsForAllNeurons(Origin); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetLayerSetNumWeightsForAllNeurons1_P(Self: TNNetLayer;  x, y, d : integer);
Begin Self.SetNumWeightsForAllNeurons(x, y, d); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetLayerSetNumWeightsForAllNeurons0_P(Self: TNNetLayer;  NumWeights : integer);
Begin Self.SetNumWeightsForAllNeurons(NumWeights); END;

(*----------------------------------------------------------------------------*)
procedure TNNetNeuronListItems_W(Self: TNNetNeuronList; const T: TNNetNeuron; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetNeuronListItems_R(Self: TNNetNeuronList; var T: TNNetNeuron; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNNetNeuronDelta_R(Self: TNNetNeuron; var T: TNNetVolume);
begin T := Self.Delta; end;

(*----------------------------------------------------------------------------*)
procedure TNNetNeuronBackInertia_R(Self: TNNetNeuron; var T: TNNetVolume);
begin T := Self.BackInertia; end;

(*----------------------------------------------------------------------------*)
procedure TNNetNeuronWeights_R(Self: TNNetNeuron; var T: TNNetVolume);
begin T := Self.Weights; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralnetwork_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CompareComputing, 'CompareComputing', cdRegister);
 S.RegisterDelphiFunction(@CompareNNStructure, 'CompareNNStructure', cdRegister);
 S.RegisterDelphiFunction(@TestConvolutionAPI, 'TestConvolutionAPI', cdRegister);
 S.RegisterDelphiFunction(@TestDataParallelism, 'TestDataParallelism', cdRegister);
// S.RegisterDelphiFunction(@TestConvolutionOpenCL, 'TestConvolutionOpenCL', cdRegister);
 //S.RegisterDelphiFunction(@TestFullConnectOpenCL, 'TestFullConnectOpenCL', cdRegister);
 S.RegisterDelphiFunction(@RebuildPatternOnPreviousPatterns, 'RebuildPatternOnPreviousPatterns', cdRegister);
 S.RegisterDelphiFunction(@RebuildNeuronListOnPreviousPatterns, 'RebuildNeuronListOnPreviousPatterns', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEasyBytePredictionViaNNet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEasyBytePredictionViaNNet) do
  begin
    RegisterConstructor(@TEasyBytePredictionViaNNet.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBytePredictionViaNNet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBytePredictionViaNNet) do
  begin
    RegisterPropertyHelper(@TBytePredictionViaNNetFCache_R,@TBytePredictionViaNNetFCache_W,'FCache');
    RegisterConstructor(@TBytePredictionViaNNet.Create, 'Create');
    RegisterMethod(@TBytePredictionViaNNet.Predict, 'Predict');
    RegisterMethod(@TBytePredictionViaNNet.newStateFound, 'newStateFound');
    RegisterPropertyHelper(@TBytePredictionViaNNetNN_R,nil,'NN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetForByteProcessing(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetForByteProcessing) do
  begin
    RegisterConstructor(@TNNetForByteProcessing.Create, 'Create');
    RegisterMethod(@TNNetForByteProcessing.AddBasicByteProcessingLayers, 'AddBasicByteProcessingLayers');
    RegisterMethod(@TNNetForByteProcessing.Compute, 'Compute');
    RegisterMethod(@TNNetForByteProcessing.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetForByteProcessing.GetOutput, 'GetOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetByteProcessing(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetByteProcessing) do
  begin
    RegisterConstructor(@TNNetByteProcessingCreate76_P, 'Create76');
    RegisterMethod(@TNNetByteProcessing.Compute, 'Compute');
    RegisterMethod(@TNNetByteProcessing.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDataParallelism(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDataParallelism) do
  begin
    RegisterPropertyHelper(@TNNetDataParallelismItems_R,@TNNetDataParallelismItems_W,'Items');
    RegisterConstructor(@TNNetDataParallelismCreate74_P, 'Create74');
    RegisterConstructor(@TNNetDataParallelismCreate75_P, 'Create75');
    RegisterMethod(@TNNetDataParallelism.SetLearningRate, 'SetLearningRate');
    RegisterMethod(@TNNetDataParallelism.SetBatchUpdate, 'SetBatchUpdate');
    RegisterMethod(@TNNetDataParallelism.SetL2Decay, 'SetL2Decay');
    RegisterMethod(@TNNetDataParallelism.SetL2DecayToConvolutionalLayers, 'SetL2DecayToConvolutionalLayers');
    RegisterMethod(@TNNetDataParallelism.EnableDropouts, 'EnableDropouts');
    RegisterMethod(@TNNetDataParallelism.CopyWeights, 'CopyWeights');
    RegisterMethod(@TNNetDataParallelism.SumWeights, 'SumWeights');
    RegisterMethod(@TNNetDataParallelism.SumDeltas, 'SumDeltas');
    RegisterMethod(@TNNetDataParallelism.AvgWeights, 'AvgWeights');
    RegisterMethod(@TNNetDataParallelism.ReplaceAtIdxAndUpdateWeightAvg, 'ReplaceAtIdxAndUpdateWeightAvg');
    //RegisterMethod(@TNNetDataParallelism.DisableOpenCL, 'DisableOpenCL');
    //RegisterMethod(@TNNetDataParallelism.EnableOpenCL, 'EnableOpenCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THistoricalNets(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THistoricalNets) do
  begin
    RegisterMethod(@THistoricalNets.AddLeCunLeNet5, 'AddLeCunLeNet5');
    RegisterMethod(@THistoricalNets.AddAlexNet, 'AddAlexNet');
    RegisterMethod(@THistoricalNets.AddVGGNet, 'AddVGGNet');
    RegisterMethod(@THistoricalNets.AddResNetUnit, 'AddResNetUnit');
    RegisterMethod(@THistoricalNets.AddDenseNetBlock, 'AddDenseNetBlock');
    RegisterMethod(@THistoricalNets.AddDenseNetTransition, 'AddDenseNetTransition');
    RegisterMethod(@THistoricalNetsAddDenseNetBlockCAI71_P, 'AddDenseNetBlockCAI71');
    RegisterMethod(@THistoricalNetsAddDenseNetBlockCAI72_P, 'AddDenseNetBlockCAI72');
    RegisterMethod(@THistoricalNetsAddkDenseNetBlock73_P, 'AddkDenseNetBlock73');
    RegisterMethod(@THistoricalNets.AddParallelConvs, 'AddParallelConvs');
    RegisterMethod(@THistoricalNets.AddDenseFullyConnected, 'AddDenseFullyConnected');
    RegisterMethod(@THistoricalNets.AddSuperResolution, 'AddSuperResolution');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNet) do
  begin
    RegisterConstructor(@TNNet.Create, 'Create');
    RegisterMethod(@TNNet.CreateLayer, 'CreateLayer');
    RegisterMethod(@TNNetAddLayer47_P, 'AddLayer47');
    RegisterMethod(@TNNetAddLayer48_P, 'AddLayer48');
    RegisterMethod(@TNNetAddLayer49_P, 'AddLayer49');
    RegisterMethod(@TNNetAddLayerAfter50_P, 'AddLayerAfter50');
    RegisterMethod(@TNNetAddLayerAfter51_P, 'AddLayerAfter51');
    RegisterMethod(@TNNetAddLayerAfter52_P, 'AddLayerAfter52');
    RegisterMethod(@TNNetAddLayerAfter53_P, 'AddLayerAfter53');
    RegisterMethod(@TNNetAddLayerAfter54_P, 'AddLayerAfter54');
    RegisterMethod(@TNNetAddLayerConcatingInputOutput55_P, 'AddLayerConcatingInputOutput55');
    RegisterMethod(@TNNetAddLayerConcatingInputOutput56_P, 'AddLayerConcatingInputOutput56');
    RegisterMethod(@TNNetAddLayerDeepConcatingInputOutput57_P, 'AddLayerDeepConcatingInputOutput57');
    RegisterMethod(@TNNetAddLayerDeepConcatingInputOutput58_P, 'AddLayerDeepConcatingInputOutput58');
    RegisterMethod(@TNNet.AddSeparableConv, 'AddSeparableConv');
    RegisterMethod(@TNNet.AddSeparableConvReLU, 'AddSeparableConvReLU');
    RegisterMethod(@TNNet.AddSeparableConvLinear, 'AddSeparableConvLinear');
    RegisterMethod(@TNNet.AddGroupedConvolution, 'AddGroupedConvolution');
    RegisterMethod(@TNNet.AddAutoGroupedPointwiseConv, 'AddAutoGroupedPointwiseConv');
    RegisterMethod(@TNNet.AddAutoGroupedPointwiseConv2, 'AddAutoGroupedPointwiseConv2');
    RegisterMethod(@TNNet.AddAutoGroupedConvolution, 'AddAutoGroupedConvolution');
    RegisterMethod(@TNNet.AddGroupedFullConnect, 'AddGroupedFullConnect');
    RegisterMethod(@TNNetAddMovingNorm59_P, 'AddMovingNorm59');
    RegisterMethod(@TNNetAddMovingNorm60_P, 'AddMovingNorm60');
    RegisterMethod(@TNNet.AddChannelMovingNorm, 'AddChannelMovingNorm');
    RegisterMethod(@TNNetAddConvOrSeparableConv61_P, 'AddConvOrSeparableConv61');
    RegisterMethod(@TNNetAddConvOrSeparableConv62_P, 'AddConvOrSeparableConv62');
    RegisterMethod(@TNNet.AddCompression, 'AddCompression');
    RegisterMethod(@TNNet.AddGroupedCompression, 'AddGroupedCompression');
    RegisterMethod(@TNNet.AddMinMaxPool, 'AddMinMaxPool');
    RegisterMethod(@TNNet.AddAvgMaxPool, 'AddAvgMaxPool');
    RegisterMethod(@TNNet.AddMinMaxChannel, 'AddMinMaxChannel');
    RegisterMethod(@TNNet.AddAvgMaxChannel, 'AddAvgMaxChannel');
    RegisterMethod(@TNNet.AddToExponentialWeightAverage, 'AddToExponentialWeightAverage');
    RegisterMethod(@TNNet.AddToWeightAverage, 'AddToWeightAverage');
    RegisterMethod(@TNNet.GetFirstNeuronalLayerIdx, 'GetFirstNeuronalLayerIdx');
    RegisterMethod(@TNNet.GetFirstImageNeuronalLayerIdx, 'GetFirstImageNeuronalLayerIdx');
    RegisterMethod(@TNNet.GetFirstNeuronalLayerIdxWithChannels, 'GetFirstNeuronalLayerIdxWithChannels');
    RegisterMethod(@TNNet.GetLastLayerIdx, 'GetLastLayerIdx');
    RegisterMethod(@TNNet.GetLastLayer, 'GetLastLayer');
    RegisterMethod(@TNNet.GetRandomLayer, 'GetRandomLayer');
    RegisterMethod(@TNNetCompute63_P, 'Compute63');
    RegisterMethod(@TNNetCompute64_P, 'Compute64');
    RegisterMethod(@TNNetCompute65_P, 'Compute65');
    RegisterMethod(@TNNetCompute66_P, 'Compute66');
    //RegisterMethod(@TNNetCompute67_P, 'Compute67');
    RegisterMethod(@TNNetCompute68_P, 'Compute68');
    RegisterMethod(@TNNetBackpropagate69_P, 'Backpropagate69');
    RegisterMethod(@TNNet.BackpropagateForIdx, 'BackpropagateForIdx');
    RegisterMethod(@TNNet.BackpropagateFromLayerAndNeuron, 'BackpropagateFromLayerAndNeuron');
    RegisterMethod(@TNNetBackpropagate70_P, 'Backpropagate70');
    RegisterMethod(@TNNet.GetOutput, 'GetOutput');
    RegisterMethod(@TNNet.AddOutput, 'AddOutput');
    RegisterMethod(@TNNet.SetActivationFn, 'SetActivationFn');
    RegisterMethod(@TNNet.SetLearningRate, 'SetLearningRate');
    RegisterMethod(@TNNet.SetBatchUpdate, 'SetBatchUpdate');
    RegisterMethod(@TNNet.InitWeights, 'InitWeights');
    RegisterMethod(@TNNet.UpdateWeights, 'UpdateWeights');
    RegisterMethod(@TNNet.ClearDeltas, 'ClearDeltas');
    RegisterMethod(@TNNet.ResetBackpropCallCurrCnt, 'ResetBackpropCallCurrCnt');
    RegisterMethod(@TNNet.SetL2Decay, 'SetL2Decay');
    RegisterMethod(@TNNet.SetL2DecayToConvolutionalLayers, 'SetL2DecayToConvolutionalLayers');
    RegisterMethod(@TNNet.ComputeL2Decay, 'ComputeL2Decay');
    RegisterMethod(@TNNet.SetSmoothErrorPropagation, 'SetSmoothErrorPropagation');
    RegisterMethod(@TNNet.ClearTime, 'ClearTime');
    RegisterMethod(@TNNet.Clear, 'Clear');
    RegisterMethod(@TNNet.IdxsToLayers, 'IdxsToLayers');
    RegisterMethod(@TNNet.EnableDropouts, 'EnableDropouts');
    RegisterMethod(@TNNet.RefreshDropoutMask, 'RefreshDropoutMask');
    RegisterMethod(@TNNet.MulMulAddWeights, 'MulMulAddWeights');
    RegisterMethod(@TNNet.MulAddWeights, 'MulAddWeights');
    RegisterMethod(@TNNet.MulWeights, 'MulWeights');
    RegisterMethod(@TNNet.MulDeltas, 'MulDeltas');
    RegisterMethod(@TNNet.SumWeights, 'SumWeights');
    RegisterMethod(@TNNet.SumDeltas, 'SumDeltas');
    RegisterMethod(@TNNet.SumDeltasNoChecks, 'SumDeltasNoChecks');
    RegisterMethod(@TNNet.CopyWeights, 'CopyWeights');
    RegisterMethod(@TNNet.ForceMaxAbsoluteDelta, 'ForceMaxAbsoluteDelta');
    RegisterMethod(@TNNet.GetMaxAbsoluteDelta, 'GetMaxAbsoluteDelta');
    RegisterMethod(@TNNet.NormalizeMaxAbsoluteDelta, 'NormalizeMaxAbsoluteDelta');
    RegisterMethod(@TNNet.ClearInertia, 'ClearInertia');
    //RegisterMethod(@TNNet.DisableOpenCL, 'DisableOpenCL');
    //RegisterMethod(@TNNet.EnableOpenCL, 'EnableOpenCL');
    RegisterMethod(@TNNet.DebugWeights, 'DebugWeights');
    RegisterMethod(@TNNet.DebugErrors, 'DebugErrors');
    RegisterMethod(@TNNet.DebugStructure, 'DebugStructure');
    RegisterMethod(@TNNet.CountLayers, 'CountLayers');
    RegisterMethod(@TNNet.CountNeurons, 'CountNeurons');
    RegisterMethod(@TNNet.CountWeights, 'CountWeights');
    RegisterMethod(@TNNet.GetWeightSum, 'GetWeightSum');
    RegisterMethod(@TNNet.GetBiasSum, 'GetBiasSum');
    RegisterMethod(@TNNet.SaveDataToString, 'SaveDataToString');
    RegisterMethod(@TNNet.LoadDataFromString, 'LoadDataFromString');
    RegisterMethod(@TNNet.LoadDataFromFile, 'LoadDataFromFile');
    RegisterMethod(@TNNet.SaveStructureToString, 'SaveStructureToString');
    RegisterMethod(@TNNet.LoadStructureFromString, 'LoadStructureFromString');
    RegisterMethod(@TNNet.SaveToString, 'SaveToString');
    RegisterMethod(@TNNet.SaveToFile, 'SaveToFile');
    RegisterMethod(@TNNet.LoadFromString, 'LoadFromString');
    RegisterMethod(@TNNet.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TNNet.Clone, 'Clone');
    RegisterMethod(@TNNet.MulWeightsGlorotBengio, 'MulWeightsGlorotBengio');
    RegisterMethod(@TNNet.MulWeightsHe, 'MulWeightsHe');
    RegisterVirtualMethod(@TNNet.ShouldIncDepartingBranchesCnt, 'ShouldIncDepartingBranchesCnt');
    RegisterPropertyHelper(@TNNetBackwardTime_R,@TNNetBackwardTime_W,'BackwardTime');
    RegisterPropertyHelper(@TNNetForwardTime_R,@TNNetForwardTime_W,'ForwardTime');
    RegisterPropertyHelper(@TNNetLayers_R,nil,'Layers');
    RegisterPropertyHelper(@TNNetLearningRate_R,nil,'LearningRate');
    RegisterPropertyHelper(@TNNetMaxDeltaLayer_R,nil,'MaxDeltaLayer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetUpsample(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetUpsample) do
  begin
    RegisterConstructor(@TNNetUpsample.Create, 'Create');
    RegisterMethod(@TNNetUpsample.Compute, 'Compute');
    RegisterMethod(@TNNetUpsample.ComputePreviousLayerError, 'ComputePreviousLayerError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDeMaxPool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDeMaxPool) do
  begin
    RegisterConstructor(@TNNetDeMaxPoolCreate46_P, 'Create46');
    RegisterMethod(@TNNetDeMaxPool.Compute, 'Compute');
    RegisterMethod(@TNNetDeMaxPool.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetDeMaxPool.ComputePreviousLayerError, 'ComputePreviousLayerError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetAvgChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetAvgChannel) do
  begin
    RegisterConstructor(@TNNetAvgChannel.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetAvgPool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetAvgPool) do
  begin
    RegisterConstructor(@TNNetAvgPoolCreate45_P, 'Create45');
    RegisterMethod(@TNNetAvgPool.Compute, 'Compute');
    RegisterMethod(@TNNetAvgPool.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMinChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMinChannel) do
  begin
    RegisterConstructor(@TNNetMinChannel.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMaxChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMaxChannel) do
  begin
    RegisterConstructor(@TNNetMaxChannel.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMinPool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMinPool) do
  begin
    RegisterMethod(@TNNetMinPool.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMaxPoolPortable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMaxPoolPortable) do
  begin
    RegisterMethod(@TNNetMaxPoolPortable.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMaxPool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMaxPool) do
  begin
    RegisterMethod(@TNNetMaxPool.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetPoolBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetPoolBase) do
  begin
    RegisterConstructor(@TNNetPoolBaseCreate44_P, 'Create44');
    RegisterMethod(@TNNetPoolBase.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDeLocalConnectReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDeLocalConnectReLU) do
  begin
    RegisterConstructor(@TNNetDeLocalConnectReLUCreate43_P, 'Create43');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLocalConnectReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLocalConnectReLU) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDeLocalConnect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDeLocalConnect) do
  begin
    RegisterConstructor(@TNNetDeLocalConnectCreate42_P, 'Create42');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLocalProduct(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLocalProduct) do
  begin
    RegisterMethod(@TNNetLocalProduct.Compute, 'Compute');
    RegisterMethod(@TNNetLocalProduct.ComputeCPU, 'ComputeCPU');
    RegisterMethod(@TNNetLocalProduct.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetLocalProduct.BackpropagateCPU, 'BackpropagateCPU');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLocalConnect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLocalConnect) do
  begin
    RegisterMethod(@TNNetLocalConnect.Compute, 'Compute');
    RegisterMethod(@TNNetLocalConnect.ComputeCPU, 'ComputeCPU');
    RegisterMethod(@TNNetLocalConnect.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetLocalConnect.BackpropagateCPU, 'BackpropagateCPU');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDeconvolutionReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDeconvolutionReLU) do
  begin
    RegisterConstructor(@TNNetDeconvolutionReLUCreate41_P, 'Create41');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDeconvolution(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDeconvolution) do
  begin
    RegisterConstructor(@TNNetDeconvolutionCreate40_P, 'Create40');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetPointwiseConvReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetPointwiseConvReLU) do
  begin
    RegisterVirtualConstructor(@TNNetPointwiseConvReLU.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetPointwiseConvLinear(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetPointwiseConvLinear) do
  begin
    RegisterVirtualConstructor(@TNNetPointwiseConvLinear.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetPointwiseConv(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetPointwiseConv) do
  begin
    RegisterVirtualConstructor(@TNNetPointwiseConv.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConvolutionReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConvolutionReLU) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConvolutionLinear(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConvolutionLinear) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConvolutionSharedWeights(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConvolutionSharedWeights) do
  begin
    RegisterVirtualConstructor(@TNNetConvolutionSharedWeightsCreate39_P, 'Create39');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConvolution(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConvolution) do
  begin
    RegisterMethod(@TNNetConvolution.Compute, 'Compute');
    RegisterMethod(@TNNetConvolution.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetGroupedPointwiseConvReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetGroupedPointwiseConvReLU) do
  begin
    RegisterConstructor(@TNNetGroupedPointwiseConvReLU.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetGroupedPointwiseConvLinear(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetGroupedPointwiseConvLinear) do
  begin
    RegisterVirtualConstructor(@TNNetGroupedPointwiseConvLinear.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetGroupedConvolutionReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetGroupedConvolutionReLU) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetGroupedConvolutionLinear(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetGroupedConvolutionLinear) do
  begin
    RegisterVirtualConstructor(@TNNetGroupedConvolutionLinearCreate37_P, 'Create37');
    RegisterMethod(@TNNetGroupedConvolutionLinear.Compute, 'Compute');
    RegisterMethod(@TNNetGroupedConvolutionLinear.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConvolutionBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConvolutionBase) do
  begin
    RegisterVirtualConstructor(@TNNetConvolutionBaseCreate36_P, 'Create36');
    //RegisterMethod(@TNNetConvolutionBase.EnableOpenCL, 'EnableOpenCL');
    RegisterPropertyHelper(@TNNetConvolutionBasePointwise_R,nil,'Pointwise');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDepthwiseConvReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDepthwiseConvReLU) do
  begin
    RegisterConstructor(@TNNetDepthwiseConvReLU.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDepthwiseConvLinear(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDepthwiseConvLinear) do
  begin
    RegisterConstructor(@TNNetDepthwiseConvLinear.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDepthwiseConv(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDepthwiseConv) do
  begin
    RegisterVirtualConstructor(@TNNetDepthwiseConvCreate33_P, 'Create33');
    RegisterMethod(@TNNetDepthwiseConv.Compute, 'Compute');
    RegisterMethod(@TNNetDepthwiseConv.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetDepthwiseConv.InitDefault, 'InitDefault');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConvolutionAbstract(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConvolutionAbstract) do
  begin
    RegisterConstructor(@TNNetConvolutionAbstractCreate32_P, 'Create32');
    RegisterMethod(@TNNetConvolutionAbstract.InitDefault, 'InitDefault');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetSoftMax(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetSoftMax) do
  begin
    RegisterMethod(@TNNetSoftMax.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetFullConnectDiff(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetFullConnectDiff) do
  begin
    RegisterConstructor(@TNNetFullConnectDiff.Create, 'Create');
    RegisterConstructor(@TNNetFullConnectDiffCreate31_P, 'Create31');
    RegisterMethod(@TNNetFullConnectDiff.Compute, 'Compute');
    RegisterMethod(@TNNetFullConnectDiff.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetFullConnectReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetFullConnectReLU) do
  begin
    RegisterMethod(@TNNetFullConnectReLU.ComputeCPU, 'ComputeCPU');
    RegisterMethod(@TNNetFullConnectReLU.BackpropagateCPU, 'BackpropagateCPU');
    RegisterConstructor(@TNNetFullConnectReLU.Create, 'Create');
    RegisterConstructor(@TNNetFullConnectReLUCreate30_P, 'Create30');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetFullConnectSigmoid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetFullConnectSigmoid) do
  begin
    RegisterConstructor(@TNNetFullConnectSigmoid.Create, 'Create');
    RegisterConstructor(@TNNetFullConnectSigmoidCreate29_P, 'Create29');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetFullConnectLinear(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetFullConnectLinear) do
  begin
    RegisterMethod(@TNNetFullConnectLinear.ComputeCPU, 'ComputeCPU');
    RegisterMethod(@TNNetFullConnectLinear.BackpropagateCPU, 'BackpropagateCPU');
    RegisterConstructor(@TNNetFullConnectLinear.Create, 'Create');
    RegisterConstructor(@TNNetFullConnectLinearCreate28_P, 'Create28');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetFullConnect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetFullConnect) do
  begin
    RegisterVirtualConstructor(@TNNetFullConnectCreate26_P, 'Create26');
    RegisterConstructor(@TNNetFullConnectCreate27_P, 'Create27');
    RegisterMethod(@TNNetFullConnect.Compute, 'Compute');
    RegisterVirtualMethod(@TNNetFullConnect.ComputeCPU, 'ComputeCPU');
    RegisterMethod(@TNNetFullConnect.Backpropagate, 'Backpropagate');
    RegisterVirtualMethod(@TNNetFullConnect.BackpropagateCPU, 'BackpropagateCPU');
    //RegisterMethod(@TNNetFullConnect.EnableOpenCL, 'EnableOpenCL');
    //RegisterVirtualMethod(@TNNetFullConnect.ComputeOpenCL, 'ComputeOpenCL');
    //RegisterVirtualMethod(@TNNetFullConnect.BackpropagateOpenCL, 'BackpropagateOpenCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetSplitChannelEvery(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetSplitChannelEvery) do
  begin
    RegisterConstructor(@TNNetSplitChannelEveryCreate24_P, 'Create24');
    RegisterConstructor(@TNNetSplitChannelEveryCreate25_P, 'Create25');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetSplitChannels(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetSplitChannels) do
  begin
    RegisterConstructor(@TNNetSplitChannelsCreate22_P, 'Create22');
    RegisterConstructor(@TNNetSplitChannelsCreate23_P, 'Create23');
    RegisterMethod(@TNNetSplitChannels.Compute, 'Compute');
    RegisterMethod(@TNNetSplitChannels.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetSplitChannels.SaveStructureToString, 'SaveStructureToString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetSum(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetSum) do
  begin
    RegisterConstructor(@TNNetSumCreate21_P, 'Create21');
    RegisterMethod(@TNNetSum.Compute, 'Compute');
    RegisterMethod(@TNNetSum.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDeepConcat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDeepConcat) do
  begin
    RegisterConstructor(@TNNetDeepConcatCreate20_P, 'Create20');
    RegisterMethod(@TNNetDeepConcat.Compute, 'Compute');
    RegisterMethod(@TNNetDeepConcat.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConcat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConcat) do
  begin
    RegisterConstructor(@TNNetConcatCreate18_P, 'Create18');
    RegisterConstructor(@TNNetConcatCreate19_P, 'Create19');
    RegisterMethod(@TNNetConcat.Compute, 'Compute');
    RegisterMethod(@TNNetConcat.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetConcatBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetConcatBase) do
  begin
    RegisterConstructor(@TNNetConcatBase.Create, 'Create');
    RegisterMethod(@TNNetConcatBase.SaveStructureToString, 'SaveStructureToString');
    RegisterMethod(@TNNetConcatBase.BackpropagateConcat, 'BackpropagateConcat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetReshape(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetReshape) do
  begin
    RegisterConstructor(@TNNetReshapeCreate17_P, 'Create17');
    RegisterMethod(@TNNetReshape.Compute, 'Compute');
    RegisterMethod(@TNNetReshape.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLocalResponseNormDepth(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLocalResponseNormDepth) do
  begin
    RegisterMethod(@TNNetLocalResponseNormDepth.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetInterleaveChannels(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetInterleaveChannels) do
  begin
    RegisterConstructor(@TNNetInterleaveChannelsCreate16_P, 'Create16');
    RegisterMethod(@TNNetInterleaveChannels.Compute, 'Compute');
    RegisterMethod(@TNNetInterleaveChannels.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLocalResponseNorm2D(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLocalResponseNorm2D) do
  begin
    RegisterConstructor(@TNNetLocalResponseNorm2DCreate15_P, 'Create15');
    RegisterMethod(@TNNetLocalResponseNorm2D.Compute, 'Compute');
    RegisterMethod(@TNNetLocalResponseNorm2D.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelStdNormalization(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelStdNormalization) do
  begin
    RegisterConstructor(@TNNetChannelStdNormalization.Create, 'Create');
    RegisterMethod(@TNNetChannelStdNormalization.Compute, 'Compute');
    RegisterMethod(@TNNetChannelStdNormalization.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetChannelStdNormalization.InitDefault, 'InitDefault');
    RegisterMethod(@TNNetChannelStdNormalization.GetMaxAbsoluteDelta, 'GetMaxAbsoluteDelta');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelZeroCenter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelZeroCenter) do
  begin
    RegisterMethod(@TNNetChannelZeroCenter.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetChannelZeroCenter.ComputeL2Decay, 'ComputeL2Decay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetCellMul(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetCellMul) do
  begin
    RegisterMethod(@TNNetCellMul.Compute, 'Compute');
    RegisterMethod(@TNNetCellMul.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetCellMul.InitDefault, 'InitDefault');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetCellBias(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetCellBias) do
  begin
    RegisterMethod(@TNNetCellBias.Compute, 'Compute');
    RegisterMethod(@TNNetCellBias.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetCellBias.InitDefault, 'InitDefault');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetCellMulByCell(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetCellMulByCell) do
  begin
    RegisterConstructor(@TNNetCellMulByCell.Create, 'Create');
    RegisterConstructor(@TNNetCellMulByCell.Create, 'Create');
    RegisterMethod(@TNNetCellMulByCell.Compute, 'Compute');
    RegisterMethod(@TNNetCellMulByCell.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelMulByLayer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelMulByLayer) do
  begin
    RegisterConstructor(@TNNetChannelMulByLayer.Create, 'Create');
    RegisterConstructor(@TNNetChannelMulByLayer.Create, 'Create');
    RegisterMethod(@TNNetChannelMulByLayer.Compute, 'Compute');
    RegisterMethod(@TNNetChannelMulByLayer.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelMul(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelMul) do
  begin
    RegisterMethod(@TNNetChannelMul.Compute, 'Compute');
    RegisterMethod(@TNNetChannelMul.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetChannelMul.InitDefault, 'InitDefault');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelBias(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelBias) do
  begin
    RegisterMethod(@TNNetChannelBias.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelShiftBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelShiftBase) do
  begin
    RegisterMethod(@TNNetChannelShiftBase.Compute, 'Compute');
    RegisterMethod(@TNNetChannelShiftBase.InitDefault, 'InitDefault');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelTransformBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelTransformBase) do
  begin
    RegisterConstructor(@TNNetChannelTransformBase.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMovingStdNormalization(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMovingStdNormalization) do
  begin
    RegisterConstructor(@TNNetMovingStdNormalization.Create, 'Create');
    RegisterMethod(@TNNetMovingStdNormalization.Compute, 'Compute');
    RegisterMethod(@TNNetMovingStdNormalization.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetMovingStdNormalization.InitDefault, 'InitDefault');
    RegisterMethod(@TNNetMovingStdNormalization.GetMaxAbsoluteDelta, 'GetMaxAbsoluteDelta');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLayerStdNormalization(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLayerStdNormalization) do
  begin
    RegisterMethod(@TNNetLayerStdNormalization.Compute, 'Compute');
    RegisterMethod(@TNNetLayerStdNormalization.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLayerMaxNormalization(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLayerMaxNormalization) do
  begin
    RegisterMethod(@TNNetLayerMaxNormalization.Compute, 'Compute');
    RegisterMethod(@TNNetLayerMaxNormalization.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetChannelRandomMulAdd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetChannelRandomMulAdd) do
  begin
    RegisterConstructor(@TNNetChannelRandomMulAddCreate14_P, 'Create14');
    RegisterMethod(@TNNetChannelRandomMulAdd.SetPrevLayer, 'SetPrevLayer');
    RegisterMethod(@TNNetChannelRandomMulAdd.Compute, 'Compute');
    RegisterMethod(@TNNetChannelRandomMulAdd.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetRandomMulAdd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetRandomMulAdd) do
  begin
    RegisterConstructor(@TNNetRandomMulAddCreate13_P, 'Create13');
    RegisterMethod(@TNNetRandomMulAdd.Compute, 'Compute');
    RegisterMethod(@TNNetRandomMulAdd.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDropout(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDropout) do
  begin
    RegisterConstructor(@TNNetDropoutCreate12_P, 'Create12');
    RegisterMethod(@TNNetDropout.Compute, 'Compute');
    RegisterMethod(@TNNetDropout.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetDropout.CopyWeights, 'CopyWeights');
    RegisterMethod(@TNNetDropout.RefreshDropoutMask, 'RefreshDropoutMask');
    RegisterPropertyHelper(@TNNetDropoutDropoutMask_R,nil,'DropoutMask');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetAddNoiseBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetAddNoiseBase) do
  begin
    RegisterPropertyHelper(@TNNetAddNoiseBaseEnabled_R,@TNNetAddNoiseBaseEnabled_W,'Enabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetAddAndDiv(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetAddAndDiv) do
  begin
    RegisterConstructor(@TNNetAddAndDivCreate11_P, 'Create11');
    RegisterMethod(@TNNetAddAndDiv.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetNegate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetNegate) do
  begin
    RegisterConstructor(@TNNetNegate.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMulByConstant(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMulByConstant) do
  begin
    RegisterMethod(@TNNetMulByConstant.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetMulLearning(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetMulLearning) do
  begin
    RegisterConstructor(@TNNetMulLearningCreate10_P, 'Create10');
    RegisterMethod(@TNNetMulLearning.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetHyperbolicTangent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetHyperbolicTangent) do
  begin
    RegisterConstructor(@TNNetHyperbolicTangent.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetSigmoid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetSigmoid) do
  begin
    RegisterConstructor(@TNNetSigmoid.Create, 'Create');
    RegisterMethod(@TNNetSigmoid.Compute, 'Compute');
    RegisterMethod(@TNNetSigmoid.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetVeryLeakyReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetVeryLeakyReLU) do
  begin
    RegisterConstructor(@TNNetVeryLeakyReLU.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLeakyReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLeakyReLU) do
  begin
    RegisterConstructor(@TNNetLeakyReLU.Create, 'Create');
    RegisterMethod(@TNNetLeakyReLU.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetPower(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetPower) do
  begin
    RegisterConstructor(@TNNetPowerCreate9_P, 'Create9');
    RegisterMethod(@TNNetPower.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetReLUSqrt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetReLUSqrt) do
  begin
    RegisterMethod(@TNNetReLUSqrt.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetSwish(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetSwish) do
  begin
    RegisterMethod(@TNNetSwish.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetSELU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetSELU) do
  begin
    RegisterConstructor(@TNNetSELU.Create, 'Create');
    RegisterMethod(@TNNetSELU.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetReLUL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetReLUL) do
  begin
    RegisterConstructor(@TNNetReLULCreate8_P, 'Create8');
    RegisterMethod(@TNNetReLUL.Compute, 'Compute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetReLU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetReLU) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDigital(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDigital) do
  begin
    RegisterConstructor(@TNNetDigitalCreate7_P, 'Create7');
    RegisterMethod(@TNNetDigital.Compute, 'Compute');
    RegisterMethod(@TNNetDigital.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetReLUBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetReLUBase) do
  begin
    RegisterMethod(@TNNetReLUBase.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetIdentityWithoutBackprop(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetIdentityWithoutBackprop) do
  begin
    RegisterMethod(@TNNetIdentityWithoutBackprop.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetIdentityWithoutL2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetIdentityWithoutL2) do
  begin
    RegisterMethod(@TNNetIdentityWithoutL2.ComputeL2Decay, 'ComputeL2Decay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetPad(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetPad) do
  begin
    RegisterConstructor(@TNNetPadCreate6_P, 'Create6');
    RegisterMethod(@TNNetPad.Compute, 'Compute');
    RegisterMethod(@TNNetPad.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetIdentity(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetIdentity) do
  begin
    RegisterMethod(@TNNetIdentity.Compute, 'Compute');
    RegisterMethod(@TNNetIdentity.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetInput(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetInput) do
  begin
    RegisterConstructor(@TNNetInputCreate3_P, 'Create3');
    RegisterConstructor(@TNNetInputCreate4_P, 'Create4');
    RegisterConstructor(@TNNetInputCreate5_P, 'Create5');
    RegisterMethod(@TNNetInput.EnableErrorCollection, 'EnableErrorCollection');
    RegisterMethod(@TNNetInput.DisableErrorCollection, 'DisableErrorCollection');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetInputBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetInputBase) do
  begin
    RegisterMethod(@TNNetInputBase.Compute, 'Compute');
    RegisterMethod(@TNNetInputBase.Backpropagate, 'Backpropagate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLayerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLayerList) do
  begin
    RegisterPropertyHelper(@TNNetLayerListItems_R,@TNNetLayerListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLayerConcatedWeights(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLayerConcatedWeights) do
  begin
    RegisterConstructor(@TNNetLayerConcatedWeights.Create, 'Create');
    RegisterMethod(@TNNetLayerConcatedWeights.RefreshNeuronWeightList, 'RefreshNeuronWeightList');
    //RegisterMethod(@TNNetLayerConcatedWeights.EnableOpenCL, 'EnableOpenCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetLayer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetLayer) do
  begin
    RegisterConstructor(@TNNetLayer.Create, 'Create');
    //RegisterVirtualMethod(@TNNetLayer.DisableOpenCL, 'DisableOpenCL');
    //RegisterVirtualMethod(@TNNetLayer.EnableOpenCL, 'EnableOpenCL');
    //RegisterVirtualAbstractMethod(@TNNetLayer, @!.Compute, 'Compute');
    //RegisterVirtualAbstractMethod(@TNNetLayer, @!.Backpropagate, 'Backpropagate');
    RegisterMethod(@TNNetLayer.ComputeOutputErrorForOneNeuron, 'ComputeOutputErrorForOneNeuron');
    RegisterVirtualMethod(@TNNetLayer.ComputeOutputErrorWith, 'ComputeOutputErrorWith');
    RegisterVirtualMethod(@TNNetLayer.ComputeOutputErrorForIdx, 'ComputeOutputErrorForIdx');
    RegisterMethod(@TNNetLayer.ComputeErrorDeriv, 'ComputeErrorDeriv');
    RegisterMethod(@TNNetLayer.Fill, 'Fill');
    RegisterMethod(@TNNetLayer.ClearDeltas, 'ClearDeltas');
    RegisterMethod(@TNNetLayer.AddNeurons, 'AddNeurons');
    RegisterMethod(@TNNetLayer.AddMissingNeurons, 'AddMissingNeurons');
    RegisterMethod(@TNNetLayerSetNumWeightsForAllNeurons0_P, 'SetNumWeightsForAllNeurons0');
    RegisterMethod(@TNNetLayerSetNumWeightsForAllNeurons1_P, 'SetNumWeightsForAllNeurons1');
    RegisterMethod(@TNNetLayerSetNumWeightsForAllNeurons2_P, 'SetNumWeightsForAllNeurons2');
    RegisterMethod(@TNNetLayer.GetMaxWeight, 'GetMaxWeight');
    RegisterMethod(@TNNetLayer.GetMinWeight, 'GetMinWeight');
    RegisterMethod(@TNNetLayer.GetMaxDelta, 'GetMaxDelta');
    RegisterMethod(@TNNetLayer.GetMinDelta, 'GetMinDelta');
    RegisterMethod(@TNNetLayer.ForceMaxAbsoluteDelta, 'ForceMaxAbsoluteDelta');
    RegisterVirtualMethod(@TNNetLayer.GetMaxAbsoluteDelta, 'GetMaxAbsoluteDelta');
    RegisterMethod(@TNNetLayer.GetMinMaxAtDepth, 'GetMinMaxAtDepth');
    RegisterMethod(@TNNetLayer.GetWeightSum, 'GetWeightSum');
    RegisterMethod(@TNNetLayer.GetBiasSum, 'GetBiasSum');
    RegisterMethod(@TNNetLayer.GetInertiaSum, 'GetInertiaSum');
    RegisterMethod(@TNNetLayer.CountWeights, 'CountWeights');
    RegisterMethod(@TNNetLayer.CountNeurons, 'CountNeurons');
    RegisterMethod(@TNNetLayer.MulWeights, 'MulWeights');
    RegisterMethod(@TNNetLayer.MulDeltas, 'MulDeltas');
    RegisterMethod(@TNNetLayer.ClearInertia, 'ClearInertia');
    RegisterMethod(@TNNetLayer.ClearTimes, 'ClearTimes');
    RegisterMethod(@TNNetLayer.AddTimes, 'AddTimes');
    RegisterMethod(@TNNetLayer.CopyTimes, 'CopyTimes');
    RegisterMethod(@TNNetLayer.MulMulAddWeights, 'MulMulAddWeights');
    RegisterMethod(@TNNetLayer.SumWeights, 'SumWeights');
    RegisterMethod(@TNNetLayer.SumDeltas, 'SumDeltas');
    RegisterMethod(@TNNetLayer.SumDeltasNoChecks, 'SumDeltasNoChecks');
    RegisterVirtualMethod(@TNNetLayer.CopyWeights, 'CopyWeights');
    RegisterMethod(@TNNetLayer.ForceRangeWeights, 'ForceRangeWeights');
    RegisterMethod(@TNNetLayer.NormalizeWeights, 'NormalizeWeights');
    RegisterVirtualMethod(@TNNetLayer.SaveDataToString, 'SaveDataToString');
    RegisterVirtualMethod(@TNNetLayer.LoadDataFromString, 'LoadDataFromString');
    RegisterVirtualMethod(@TNNetLayer.SaveStructureToString, 'SaveStructureToString');
    RegisterMethod(@TNNetLayer.SetBatchUpdate, 'SetBatchUpdate');
    RegisterMethod(@TNNetLayer.UpdateWeights, 'UpdateWeights');
    RegisterMethod(@TNNetLayer.InitBasicPatterns, 'InitBasicPatterns');
    RegisterMethod(@TNNetLayer.IncDepartingBranchesCnt, 'IncDepartingBranchesCnt');
    RegisterMethod(@TNNetLayer.ResetBackpropCallCurrCnt, 'ResetBackpropCallCurrCnt');
    RegisterMethod(@TNNetLayer.InitUniform, 'InitUniform');
    RegisterMethod(@TNNetLayer.InitLeCunUniform, 'InitLeCunUniform');
    RegisterMethod(@TNNetLayer.InitHeUniform, 'InitHeUniform');
    RegisterMethod(@TNNetLayer.InitHeUniformDepthwise, 'InitHeUniformDepthwise');
    RegisterMethod(@TNNetLayer.InitHeGaussian, 'InitHeGaussian');
    RegisterMethod(@TNNetLayer.InitHeGaussianDepthwise, 'InitHeGaussianDepthwise');
    RegisterMethod(@TNNetLayer.InitGlorotBengioUniform, 'InitGlorotBengioUniform');
    RegisterMethod(@TNNetLayer.InitSELU, 'InitSELU');
    RegisterVirtualMethod(@TNNetLayer.InitDefault, 'InitDefault');
    RegisterPropertyHelper(@TNNetLayerActivationFn_R,@TNNetLayerActivationFn_W,'ActivationFn');
    RegisterPropertyHelper(@TNNetLayerActivationFnDerivative_R,@TNNetLayerActivationFnDerivative_W,'ActivationFnDerivative');
    RegisterPropertyHelper(@TNNetLayerNeurons_R,nil,'Neurons');
    RegisterPropertyHelper(@TNNetLayerNN_R,@TNNetLayerNN_W,'NN');
    RegisterPropertyHelper(@TNNetLayerOutput_R,nil,'Output');
    RegisterPropertyHelper(@TNNetLayerOutputRaw_R,nil,'OutputRaw');
    RegisterPropertyHelper(@TNNetLayerPrevLayer_R,@TNNetLayerPrevLayer_W,'PrevLayer');
    RegisterPropertyHelper(@TNNetLayerLearningRate_R,@TNNetLayerLearningRate_W,'LearningRate');
    RegisterPropertyHelper(@TNNetLayerL2Decay_R,@TNNetLayerL2Decay_W,'L2Decay');
    RegisterPropertyHelper(@TNNetLayerInertia_R,nil,'Inertia');
    RegisterPropertyHelper(@TNNetLayerOutputError_R,@TNNetLayerOutputError_W,'OutputError');
    RegisterPropertyHelper(@TNNetLayerOutputErrorDeriv_R,@TNNetLayerOutputErrorDeriv_W,'OutputErrorDeriv');
    RegisterPropertyHelper(@TNNetLayerLayerIdx_R,nil,'LayerIdx');
    RegisterPropertyHelper(@TNNetLayerSmoothErrorPropagation_R,@TNNetLayerSmoothErrorPropagation_W,'SmoothErrorPropagation');
    RegisterPropertyHelper(@TNNetLayerBackwardTime_R,@TNNetLayerBackwardTime_W,'BackwardTime');
    RegisterPropertyHelper(@TNNetLayerForwardTime_R,@TNNetLayerForwardTime_W,'ForwardTime');
    RegisterPropertyHelper(@TNNetLayerLinkedNeurons_R,nil,'LinkedNeurons');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetNeuronList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetNeuronList) do
  begin
    RegisterPropertyHelper(@TNNetNeuronListItems_R,@TNNetNeuronListItems_W,'Items');
    RegisterConstructor(@TNNetNeuronList.CreateWithElements, 'CreateWithElements');
    RegisterMethod(@TNNetNeuronList.GetMaxWeight, 'GetMaxWeight');
    RegisterMethod(@TNNetNeuronList.GetMaxAbsWeight, 'GetMaxAbsWeight');
    RegisterMethod(@TNNetNeuronList.GetMinWeight, 'GetMinWeight');
    RegisterMethod(@TNNetNeuronList.InitForDebug, 'InitForDebug');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetNeuron(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetNeuron) do
  begin
    RegisterConstructor(@TNNetNeuron.Create, 'Create');
    RegisterMethod(@TNNetNeuron.Fill, 'Fill');
    RegisterMethod(@TNNetNeuron.AddInertia, 'AddInertia');
    RegisterMethod(@TNNetNeuron.UpdateWeights, 'UpdateWeights');
    RegisterMethod(@TNNetNeuron.SaveToString, 'SaveToString');
    RegisterMethod(@TNNetNeuron.LoadFromString, 'LoadFromString');
    RegisterMethod(@TNNetNeuron.ClearDelta, 'ClearDelta');
    RegisterMethod(@TNNetNeuron.InitUniform, 'InitUniform');
    RegisterMethod(@TNNetNeuron.InitGaussian, 'InitGaussian');
    RegisterMethod(@TNNetNeuron.InitLeCunUniform, 'InitLeCunUniform');
    RegisterMethod(@TNNetNeuron.InitHeUniform, 'InitHeUniform');
    RegisterMethod(@TNNetNeuron.InitHeGaussian, 'InitHeGaussian');
    RegisterMethod(@TNNetNeuron.InitHeUniformDepthwise, 'InitHeUniformDepthwise');
    RegisterMethod(@TNNetNeuron.InitHeGaussianDepthwise, 'InitHeGaussianDepthwise');
    RegisterMethod(@TNNetNeuron.InitSELU, 'InitSELU');
    RegisterPropertyHelper(@TNNetNeuronWeights_R,nil,'Weights');
    RegisterPropertyHelper(@TNNetNeuronBackInertia_R,nil,'BackInertia');
    RegisterPropertyHelper(@TNNetNeuronDelta_R,nil,'Delta');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralnetwork(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNet) do
  RIRegister_TNNetNeuron(CL);
  RIRegister_TNNetNeuronList(CL);
  RIRegister_TNNetLayer(CL);
  RIRegister_TNNetLayerConcatedWeights(CL);
  RIRegister_TNNetLayerList(CL);
  RIRegister_TNNetInputBase(CL);
  RIRegister_TNNetInput(CL);
  RIRegister_TNNetIdentity(CL);
  RIRegister_TNNetPad(CL);
  RIRegister_TNNetIdentityWithoutL2(CL);
  RIRegister_TNNetIdentityWithoutBackprop(CL);
  RIRegister_TNNetReLUBase(CL);
  RIRegister_TNNetDigital(CL);
  RIRegister_TNNetReLU(CL);
  RIRegister_TNNetReLUL(CL);
  RIRegister_TNNetSELU(CL);
  RIRegister_TNNetSwish(CL);
  RIRegister_TNNetReLUSqrt(CL);
  RIRegister_TNNetPower(CL);
  RIRegister_TNNetLeakyReLU(CL);
  RIRegister_TNNetVeryLeakyReLU(CL);
  RIRegister_TNNetSigmoid(CL);
  RIRegister_TNNetHyperbolicTangent(CL);
  RIRegister_TNNetMulLearning(CL);
  RIRegister_TNNetMulByConstant(CL);
  RIRegister_TNNetNegate(CL);
  RIRegister_TNNetAddAndDiv(CL);
  RIRegister_TNNetAddNoiseBase(CL);
  RIRegister_TNNetDropout(CL);
  RIRegister_TNNetRandomMulAdd(CL);
  RIRegister_TNNetChannelRandomMulAdd(CL);
  RIRegister_TNNetLayerMaxNormalization(CL);
  RIRegister_TNNetLayerStdNormalization(CL);
  RIRegister_TNNetMovingStdNormalization(CL);
  RIRegister_TNNetChannelTransformBase(CL);
  RIRegister_TNNetChannelShiftBase(CL);
  RIRegister_TNNetChannelBias(CL);
  RIRegister_TNNetChannelMul(CL);
  RIRegister_TNNetChannelMulByLayer(CL);
  RIRegister_TNNetCellMulByCell(CL);
  RIRegister_TNNetCellBias(CL);
  RIRegister_TNNetCellMul(CL);
  RIRegister_TNNetChannelZeroCenter(CL);
  RIRegister_TNNetChannelStdNormalization(CL);
  RIRegister_TNNetLocalResponseNorm2D(CL);
  RIRegister_TNNetInterleaveChannels(CL);
  RIRegister_TNNetLocalResponseNormDepth(CL);
  RIRegister_TNNetReshape(CL);
  RIRegister_TNNetConcatBase(CL);
  RIRegister_TNNetConcat(CL);
  RIRegister_TNNetDeepConcat(CL);
  RIRegister_TNNetSum(CL);
  RIRegister_TNNetSplitChannels(CL);
  RIRegister_TNNetSplitChannelEvery(CL);
  RIRegister_TNNetFullConnect(CL);
  RIRegister_TNNetFullConnectLinear(CL);
  RIRegister_TNNetFullConnectSigmoid(CL);
  RIRegister_TNNetFullConnectReLU(CL);
  RIRegister_TNNetFullConnectDiff(CL);
  RIRegister_TNNetSoftMax(CL);
  with CL.Add(TNNetLayerFullConnect) do
  with CL.Add(TNNetLayerFullConnectReLU) do
  with CL.Add(TNNetLayerSoftMax) do
  with CL.Add(TNNetDense) do
  with CL.Add(TNNetDenseReLU) do
  RIRegister_TNNetConvolutionAbstract(CL);
  RIRegister_TNNetDepthwiseConv(CL);
  RIRegister_TNNetDepthwiseConvLinear(CL);
  RIRegister_TNNetDepthwiseConvReLU(CL);
  RIRegister_TNNetConvolutionBase(CL);
  RIRegister_TNNetGroupedConvolutionLinear(CL);
  RIRegister_TNNetGroupedConvolutionReLU(CL);
  RIRegister_TNNetGroupedPointwiseConvLinear(CL);
  RIRegister_TNNetGroupedPointwiseConvReLU(CL);
  RIRegister_TNNetConvolution(CL);
  RIRegister_TNNetConvolutionSharedWeights(CL);
  RIRegister_TNNetConvolutionLinear(CL);
  RIRegister_TNNetConvolutionReLU(CL);
  RIRegister_TNNetPointwiseConv(CL);
  RIRegister_TNNetPointwiseConvLinear(CL);
  RIRegister_TNNetPointwiseConvReLU(CL);
  RIRegister_TNNetDeconvolution(CL);
  RIRegister_TNNetDeconvolutionReLU(CL);
  RIRegister_TNNetLocalConnect(CL);
  RIRegister_TNNetLocalProduct(CL);
  RIRegister_TNNetDeLocalConnect(CL);
  RIRegister_TNNetLocalConnectReLU(CL);
  RIRegister_TNNetDeLocalConnectReLU(CL);
  RIRegister_TNNetPoolBase(CL);
  RIRegister_TNNetMaxPool(CL);
  RIRegister_TNNetMaxPoolPortable(CL);
  RIRegister_TNNetMinPool(CL);
  RIRegister_TNNetMaxChannel(CL);
  RIRegister_TNNetMinChannel(CL);
  RIRegister_TNNetAvgPool(CL);
  RIRegister_TNNetAvgChannel(CL);
  RIRegister_TNNetDeMaxPool(CL);
  RIRegister_TNNetUpsample(CL);
  with CL.Add(TNNetDeAvgPool) do
  RIRegister_TNNet(CL);
  RIRegister_THistoricalNets(CL);
  RIRegister_TNNetDataParallelism(CL);
  RIRegister_TNNetByteProcessing(CL);
  RIRegister_TNNetForByteProcessing(CL);
  RIRegister_TBytePredictionViaNNet(CL);
  RIRegister_TEasyBytePredictionViaNNet(CL);
end;

 
 
{ TPSImport_neuralnetwork }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralnetwork.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralnetwork(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralnetwork.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralnetwork(ri);
  RIRegister_neuralnetwork_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
