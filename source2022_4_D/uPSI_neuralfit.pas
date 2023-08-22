unit uPSI_neuralfit;
{
neural viral    plus reroutr writeln     check inits    - FitLoading1

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
  TPSImport_neuralfit = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNeuralImageFit(CL: TPSPascalCompiler);
procedure SIRegister_TNeuralImageLoadingFit(CL: TPSPascalCompiler);
procedure SIRegister_TNeuralFit(CL: TPSPascalCompiler);
procedure SIRegister_TNeuralDataLoadingFit(CL: TPSPascalCompiler);
procedure SIRegister_TNeuralFitWithImageBase(CL: TPSPascalCompiler);
procedure SIRegister_TNeuralFitBase(CL: TPSPascalCompiler);
procedure SIRegister_neuralfit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralfit_Routines(S: TPSExec);
procedure RIRegister_TNeuralImageFit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNeuralImageLoadingFit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNeuralFit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNeuralDataLoadingFit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNeuralFitWithImageBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNeuralFitBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralfit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   neuralnetworkCAI
  ,neuralvolume
  ,neuralthread
  ,neuraldatasets
  //,cl
  //,neuralopencl
  ,Windows
  ,neuralfit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralfit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralImageFit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNeuralFitWithImageBase', 'TNeuralImageFit') do
  with CL.AddClassN(CL.FindClass('TNeuralFitWithImageBase'),'TNeuralImageFit') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Fit( pNN : TNNet; pImgVolumes, pImgValidationVolumes, pImgTestVolumes : TNNetVolumeList; pNumClasses, pBatchSize, Epochs : integer)');
    RegisterMethod('Procedure RunNNThread( index, threadnum : integer)');
    RegisterMethod('Procedure TestNNThread( index, threadnum : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralImageLoadingFit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNeuralDataLoadingFit', 'TNeuralImageLoadingFit') do
  with CL.AddClassN(CL.FindClass('TNeuralDataLoadingFit'),'TNeuralImageLoadingFit') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure FitLoading4( pNN : TNNet; pSizeX, pSizeY : integer; pTrainingFileNames, pValidationFileNames, pTestFileNames : TFileNameList; pBatchSize, Epochs : integer);');
    RegisterProperty('SizeX', 'integer', iptr);
    RegisterProperty('SizeY', 'integer', iptr);
    RegisterProperty('TrainingVolumeCacheEnabled', 'boolean', iptrw);
    RegisterProperty('TrainingVolumeCacheSize', 'integer', iptrw);
    RegisterProperty('TrainingVolumeCachePct', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralFit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNeuralDataLoadingFit', 'TNeuralFit') do
  with CL.AddClassN(CL.FindClass('TNeuralDataLoadingFit'),'TNeuralFit') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Fit( pNN : TNNet; pTrainingVolumes, pValidationVolumes, pTestVolumes : TNNetVolumePairList; pBatchSize, Epochs : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralDataLoadingFit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNeuralFitWithImageBase', 'TNeuralDataLoadingFit') do
  with CL.AddClassN(CL.FindClass('TNeuralFitWithImageBase'),'TNeuralDataLoadingFit') do
  begin
    RegisterMethod('Constructor Create()');
   // RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure FitLoading( pNN : TNNet; TrainingCnt, ValidationCnt, TestCnt, pBatchSize, Epochs : integer; pGetTrainingPair, pGetValidationPair, pGetTestPair : TNNetGetPairFn);');
    RegisterMethod('Procedure FitLoading1( pNN : TNNet; TrainingCnt, ValidationCnt, TestCnt, pBatchSize, Epochs : integer; pGetTrainingProc, pGetValidationProc, pGetTestProc : TNNetGet2VolumesProc);');

   RegisterMethod('procedure FitLoading2(pNN:TNNet;TrainingCnt,ValidationCnt,TestCnt,pBatchSize,Epochs:integer;pGetTrainingPair,pGetValidationPair, pGetTestPair:TNNetGetPairFn);');
   RegisterMethod(' procedure FitLoading22(pNN:TNNet; TrainingCnt,ValidationCnt,TestCnt,pBatchSize,Epochs:integer;pGetTrainingProc,pGetValidationProc,pGetTestProc: TNNetGet2VolumesProc);');

    RegisterMethod('Procedure EnableMonopolarHitComparison( )');
    RegisterMethod('Procedure EnableBipolarHitComparison( )');
    RegisterMethod('Procedure EnableBipolar99HitComparison( )');
    RegisterMethod('Procedure EnableClassComparison( )');
    RegisterMethod('Procedure RunNNThread( index, threadnum : integer)');
    RegisterMethod('Procedure TestNNThread( index, threadnum : integer)');
    RegisterMethod('Procedure AllocateMemory( pNN : TNNet; pBatchSize : integer; pGetTrainingPair, pGetValidationPair, pGetTestPair : TNNetGetPairFn);');

    RegisterMethod('Procedure AllocateMemory2( pNN : TNNet; pBatchSize : integer; pGetTrainingPair, pGetValidationPair, pGetTestPair : TNNetGetPairFn);');
    RegisterMethod('Procedure AllocateMemory3( pNN : TNNet; pBatchSize : integer; pGetTrainingProc, pGetValidationProc, pGetTestProc : TNNetGet2VolumesProc);');
    RegisterMethod('Procedure FreeMemory( )');
    RegisterMethod('procedure EnableDefaultImageTreatment()');
    RegisterMethod('procedure CloseResFile');
    ///procedure EnableDefaultImageTreatment(); override;   procedure CloseResFile;
    RegisterMethod('Procedure RunTrainingBatch( )');
    RegisterMethod('Procedure RunValidationBatch( ValidationSize : integer)');
    RegisterMethod('Procedure RunTestBatch( TestSize : integer)');
    RegisterMethod('procedure EnableDefaultImageTreatment()'); //override;
    RegisterProperty('DataAugmentationFn', 'TNNetDataAugmentationFn', iptrw);
    RegisterProperty('InferHitFn', 'TNNetInferHitFn', iptrw);
    RegisterProperty('LossFn', 'TNNetLossFn', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralFitWithImageBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNeuralFitBase', 'TNeuralFitWithImageBase') do
  with CL.AddClassN(CL.FindClass('TNeuralFitBase'),'TNeuralFitWithImageBase') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure ClassifyImage( pNN : TNNet; pImgInput, pOutput : TNNetVolume)');
    RegisterMethod('Procedure EnableDefaultImageTreatment( )');
    RegisterProperty('HasImgCrop', 'boolean', iptrw);
    RegisterProperty('HasMakeGray', 'boolean', iptrw);
    RegisterProperty('HasFlipX', 'boolean', iptrw);
    RegisterProperty('HasFlipY', 'boolean', iptrw);
    RegisterProperty('HasResizing', 'boolean', iptrw);
    RegisterProperty('MaxCropSize', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralFitBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMObject', 'TNeuralFitBase') do
  with CL.AddClassN(CL.FindClass('TMObject'),'TNeuralFitBase') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure WaitUntilFinished');
    RegisterMethod('Procedure DisableOpenCL( )');
    RegisterMethod('Procedure EnableOpenCL( platform_id : cl_platform_id; device_id : cl_device_id)');
    RegisterProperty('AvgWeightEpochCount', 'integer', iptrw);
    RegisterProperty('AvgNN', 'TNNet', iptr);
    RegisterProperty('ClipDelta', 'single', iptrw);
    RegisterProperty('CurrentEpoch', 'integer', iptr);
    RegisterProperty('CurrentStep', 'integer', iptr);
    RegisterProperty('CurrentLearningRate', 'single', iptr);
    RegisterProperty('CustomLearningRateScheduleFn', 'TCustomLearningRateScheduleFn', iptrw);
    RegisterProperty('CustomLearningRateScheduleObjFn', 'TCustomLearningRateScheduleObjFn', iptrw);
    RegisterProperty('CyclicalLearningRateLen', 'integer', iptrw);
    RegisterProperty('FileNameBase', 'string', iptrw);
    RegisterProperty('Inertia', 'single', iptrw);
    RegisterProperty('InitialEpoch', 'integer', iptrw);
    RegisterProperty('InitialLearningRate', 'single', iptrw);
    RegisterProperty('LearningRateDecay', 'single', iptrw);
    RegisterProperty('L2Decay', 'single', iptrw);
    RegisterProperty('MaxThreadNum', 'integer', iptrw);
    RegisterProperty('Momentum', 'single', iptrw);
    RegisterProperty('MultipleSamplesAtValidation', 'boolean', iptrw);
    RegisterProperty('NN', 'TNNet', iptr);
    RegisterProperty('OnAfterStep', 'TNotifyEvent', iptrw);
    RegisterProperty('OnAfterEpoch', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStart', 'TNotifyEvent', iptrw);
    RegisterProperty('StaircaseEpochs', 'integer', iptrw);
    RegisterProperty('TargetAccuracy', 'single', iptrw);
    RegisterProperty('ValidationAccuracy', 'TNeuralFloat', iptr);
    RegisterProperty('Verbose', 'boolean', iptrw);
    RegisterProperty('TestAccuracy', 'TNeuralFloat', iptr);
    RegisterProperty('ThreadNN', 'TNNetDataParallelism', iptr);
    RegisterProperty('TrainingAccuracy', 'TNeuralFloat', iptr);
    RegisterProperty('Running', 'boolean', iptr);
    RegisterProperty('ShouldQuit', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralfit(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCustomLearningRateScheduleObjFn', 'Function ( Epoch : integer) : single');
  CL.AddTypeS('TMultiThreadProcItem', 'TObject');
  SIRegister_TNeuralFitBase(CL);
  SIRegister_TNeuralFitWithImageBase(CL);
  CL.AddTypeS('TNNetDataAugmentationFn', 'Procedure ( pInput : TNNetVolume; ThreadId : integer)');
  CL.AddTypeS('TNNetLossFn', 'Function ( ExpectedOutput, FoundOutput : TNNetVolume; ThreadId : integer) : TNeuralFloat');
  CL.AddTypeS('TNNetGetPairFn', 'Function ( Idx : integer; ThreadId : integer) : TNNetVolumePair');
  CL.AddTypeS('TNNetGet2VolumesProc', 'Procedure ( Idx : integer; ThreadId : integer; pInput, pOutput : TNNetVolume)');
  CL.AddTypeS('TNNetInferHitFn', 'function(A, B: TNNetVolume; ThreadId: integer): boolean;');
  //TNNetInferHitFn = function(A, B: TNNetVolume; ThreadId: integer): boolean;

  SIRegister_TNeuralDataLoadingFit(CL);
  SIRegister_TNeuralFit(CL);
  SIRegister_TNeuralImageLoadingFit(CL);
  SIRegister_TNeuralImageFit(CL);
 CL.AddDelphiFunction('Function MonopolarCompare( A, B : TNNetVolume; ThreadId : integer) : boolean');
 CL.AddDelphiFunction('Function BipolarCompare( A, B : TNNetVolume; ThreadId : integer) : boolean');
 CL.AddDelphiFunction('Function BipolarCompare99( A, B : TNNetVolume; ThreadId : integer) : boolean');
 CL.AddDelphiFunction('Function ClassCompare( A, B : TNNetVolume; ThreadId : integer) : boolean');
end;

(* === run-time registration functions === *)
(*
(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitTrainingVolumeCachePct_W(Self: TNeuralImageLoadingFit; const T: integer);
//begin Self.TrainingVolumeCachePct := T; end;

(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitTrainingVolumeCachePct_R(Self: TNeuralImageLoadingFit; var T: integer);
//begin T := Self.TrainingVolumeCachePct; end;

(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitTrainingVolumeCacheSize_W(Self: TNeuralImageLoadingFit; const T: integer);
//begin Self.TrainingVolumeCacheSize := T; end;

(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitTrainingVolumeCacheSize_R(Self: TNeuralImageLoadingFit; var T: integer);
//begin T := Self.TrainingVolumeCacheSize; end;

(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitTrainingVolumeCacheEnabled_W(Self: TNeuralImageLoadingFit; const T: boolean);
//begin Self.TrainingVolumeCacheEnabled := T; end;

(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitTrainingVolumeCacheEnabled_R(Self: TNeuralImageLoadingFit; var T: boolean);
//begin T := Self.TrainingVolumeCacheEnabled; end;

(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitSizeY_R(Self: TNeuralImageLoadingFit; var T: integer);
//begin T := Self.SizeY; end;

(*----------------------------------------------------------------------------*)
//procedure TNeuralImageLoadingFitSizeX_R(Self: TNeuralImageLoadingFit; var T: integer);
//begin T := Self.SizeX; end;

(*----------------------------------------------------------------------------*)
//Procedure TNeuralImageLoadingFitFitLoading4_P(Self: TNeuralImageLoadingFit;  pNN : TNNet; pSizeX, pSizeY : integer; pTrainingFileNames, pValidationFileNames, pTestFileNames : TFileNameList; pBatchSize, Epochs : integer);
//Begin Self.FitLoading(pNN, pSizeX, pSizeY, pTrainingFileNames, pValidationFileNames, pTestFileNames, pBatchSize, Epochs); END;

//*)
(*----------------------------------------------------------------------------*)
procedure TNeuralDataLoadingFitLossFn_W(Self: TNeuralDataLoadingFit; const T: TNNetLossFn);
begin Self.LossFn := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralDataLoadingFitLossFn_R(Self: TNeuralDataLoadingFit; var T: TNNetLossFn);
begin T := Self.LossFn; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralDataLoadingFitInferHitFn_W(Self: TNeuralDataLoadingFit; const T: TNNetInferHitFn);
begin Self.InferHitFn := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralDataLoadingFitInferHitFn_R(Self: TNeuralDataLoadingFit; var T: TNNetInferHitFn);
begin T := Self.InferHitFn; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralDataLoadingFitDataAugmentationFn_W(Self: TNeuralDataLoadingFit; const T: TNNetDataAugmentationFn);
begin Self.DataAugmentationFn := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralDataLoadingFitDataAugmentationFn_R(Self: TNeuralDataLoadingFit; var T: TNNetDataAugmentationFn);
begin T := Self.DataAugmentationFn; end;

(*----------------------------------------------------------------------------*)
Procedure TNeuralDataLoadingFitAllocateMemory3_P(Self: TNeuralDataLoadingFit;  pNN : TNNet; pBatchSize : integer; pGetTrainingProc, pGetValidationProc, pGetTestProc : TNNetGet2VolumesProc);
Begin Self.AllocateMemory(pNN, pBatchSize, pGetTrainingProc, pGetValidationProc, pGetTestProc); END;

(*----------------------------------------------------------------------------*)
Procedure TNeuralDataLoadingFitAllocateMemory2_P(Self: TNeuralDataLoadingFit;  pNN : TNNet; pBatchSize : integer; pGetTrainingPair, pGetValidationPair, pGetTestPair : TNNetGetPairFn);
Begin Self.AllocateMemory(pNN, pBatchSize, pGetTrainingPair, pGetValidationPair, pGetTestPair); END;

(*----------------------------------------------------------------------------*)
Procedure TNeuralDataLoadingFitFitLoading1_P(Self: TNeuralDataLoadingFit;  pNN: TNNet; TrainingCnt, ValidationCnt, TestCnt, pBatchSize, Epochs: integer; pGetTrainingProc,pGetValidationProc,pGetTestProc: TNNetGet2VolumesProc);
Begin Self.FitLoading(pNN, TrainingCnt, ValidationCnt, TestCnt, pBatchSize, Epochs, pGetTrainingProc, pGetValidationProc, pGetTestProc); END;

(*----------------------------------------------------------------------------*)
Procedure TNeuralDataLoadingFitFitLoading_P(Self: TNeuralDataLoadingFit;  pNN: TNNet; TrainingCnt, ValidationCnt, TestCnt, pBatchSize, Epochs: integer; pGetTrainingPair,pGetValidationPair,pGetTestPair: TNNetGetPairFn);
Begin Self.FitLoading(pNN, TrainingCnt, ValidationCnt, TestCnt, pBatchSize, Epochs, pGetTrainingPair, pGetValidationPair, pGetTestPair); END;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseMaxCropSize_W(Self: TNeuralFitWithImageBase; const T: integer);
begin Self.MaxCropSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseMaxCropSize_R(Self: TNeuralFitWithImageBase; var T: integer);
begin T := Self.MaxCropSize; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasResizing_W(Self: TNeuralFitWithImageBase; const T: boolean);
begin Self.HasResizing := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasResizing_R(Self: TNeuralFitWithImageBase; var T: boolean);
begin T := Self.HasResizing; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasFlipY_W(Self: TNeuralFitWithImageBase; const T: boolean);
begin Self.HasFlipY := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasFlipY_R(Self: TNeuralFitWithImageBase; var T: boolean);
begin T := Self.HasFlipY; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasFlipX_W(Self: TNeuralFitWithImageBase; const T: boolean);
begin Self.HasFlipX := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasFlipX_R(Self: TNeuralFitWithImageBase; var T: boolean);
begin T := Self.HasFlipX; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasMakeGray_W(Self: TNeuralFitWithImageBase; const T: boolean);
begin Self.HasMakeGray := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasMakeGray_R(Self: TNeuralFitWithImageBase; var T: boolean);
begin T := Self.HasMakeGray; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasImgCrop_W(Self: TNeuralFitWithImageBase; const T: boolean);
begin Self.HasImgCrop := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitWithImageBaseHasImgCrop_R(Self: TNeuralFitWithImageBase; var T: boolean);
begin T := Self.HasImgCrop; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseShouldQuit_W(Self: TNeuralFitBase; const T: boolean);
begin Self.ShouldQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseShouldQuit_R(Self: TNeuralFitBase; var T: boolean);
begin T := Self.ShouldQuit; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseRunning_R(Self: TNeuralFitBase; var T: boolean);
begin T := Self.Running; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseTrainingAccuracy_R(Self: TNeuralFitBase; var T: TNeuralFloat);
begin T := Self.TrainingAccuracy; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseThreadNN_R(Self: TNeuralFitBase; var T: TNNetDataParallelism);
begin T := Self.ThreadNN; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseTestAccuracy_R(Self: TNeuralFitBase; var T: TNeuralFloat);
begin T := Self.TestAccuracy; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseVerbose_W(Self: TNeuralFitBase; const T: boolean);
begin Self.Verbose := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseVerbose_R(Self: TNeuralFitBase; var T: boolean);
begin T := Self.Verbose; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseValidationAccuracy_R(Self: TNeuralFitBase; var T: TNeuralFloat);
begin T := Self.ValidationAccuracy; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseTargetAccuracy_W(Self: TNeuralFitBase; const T: single);
begin Self.TargetAccuracy := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseTargetAccuracy_R(Self: TNeuralFitBase; var T: single);
begin T := Self.TargetAccuracy; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseStaircaseEpochs_W(Self: TNeuralFitBase; const T: integer);
begin Self.StaircaseEpochs := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseStaircaseEpochs_R(Self: TNeuralFitBase; var T: integer);
begin T := Self.StaircaseEpochs; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseOnStart_W(Self: TNeuralFitBase; const T: TNotifyEvent);
begin Self.OnStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseOnStart_R(Self: TNeuralFitBase; var T: TNotifyEvent);
begin T := Self.OnStart; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseOnAfterEpoch_W(Self: TNeuralFitBase; const T: TNotifyEvent);
begin Self.OnAfterEpoch := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseOnAfterEpoch_R(Self: TNeuralFitBase; var T: TNotifyEvent);
begin T := Self.OnAfterEpoch; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseOnAfterStep_W(Self: TNeuralFitBase; const T: TNotifyEvent);
begin Self.OnAfterStep := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseOnAfterStep_R(Self: TNeuralFitBase; var T: TNotifyEvent);
begin T := Self.OnAfterStep; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseNN_R(Self: TNeuralFitBase; var T: TNNet);
begin T := Self.NN; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseMultipleSamplesAtValidation_W(Self: TNeuralFitBase; const T: boolean);
begin Self.MultipleSamplesAtValidation := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseMultipleSamplesAtValidation_R(Self: TNeuralFitBase; var T: boolean);
begin T := Self.MultipleSamplesAtValidation; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseMomentum_W(Self: TNeuralFitBase; const T: single);
begin Self.Momentum := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseMomentum_R(Self: TNeuralFitBase; var T: single);
begin T := Self.Momentum; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseMaxThreadNum_W(Self: TNeuralFitBase; const T: integer);
begin Self.MaxThreadNum := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseMaxThreadNum_R(Self: TNeuralFitBase; var T: integer);
begin T := Self.MaxThreadNum; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseL2Decay_W(Self: TNeuralFitBase; const T: single);
begin Self.L2Decay := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseL2Decay_R(Self: TNeuralFitBase; var T: single);
begin T := Self.L2Decay; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseLearningRateDecay_W(Self: TNeuralFitBase; const T: single);
begin Self.LearningRateDecay := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseLearningRateDecay_R(Self: TNeuralFitBase; var T: single);
begin T := Self.LearningRateDecay; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseInitialLearningRate_W(Self: TNeuralFitBase; const T: single);
begin Self.InitialLearningRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseInitialLearningRate_R(Self: TNeuralFitBase; var T: single);
begin T := Self.InitialLearningRate; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseInitialEpoch_W(Self: TNeuralFitBase; const T: integer);
begin Self.InitialEpoch := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseInitialEpoch_R(Self: TNeuralFitBase; var T: integer);
begin T := Self.InitialEpoch; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseInertia_W(Self: TNeuralFitBase; const T: single);
begin Self.Inertia := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseInertia_R(Self: TNeuralFitBase; var T: single);
begin T := Self.Inertia; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseFileNameBase_W(Self: TNeuralFitBase; const T: string);
begin Self.FileNameBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseFileNameBase_R(Self: TNeuralFitBase; var T: string);
begin T := Self.FileNameBase; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCyclicalLearningRateLen_W(Self: TNeuralFitBase; const T: integer);
begin Self.CyclicalLearningRateLen := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCyclicalLearningRateLen_R(Self: TNeuralFitBase; var T: integer);
begin T := Self.CyclicalLearningRateLen; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCustomLearningRateScheduleObjFn_W(Self: TNeuralFitBase; const T: TCustomLearningRateScheduleObjFn);
begin Self.CustomLearningRateScheduleObjFn := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCustomLearningRateScheduleObjFn_R(Self: TNeuralFitBase; var T: TCustomLearningRateScheduleObjFn);
begin T := Self.CustomLearningRateScheduleObjFn; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCustomLearningRateScheduleFn_W(Self: TNeuralFitBase; const T: TCustomLearningRateScheduleFn);
begin Self.CustomLearningRateScheduleFn := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCustomLearningRateScheduleFn_R(Self: TNeuralFitBase; var T: TCustomLearningRateScheduleFn);
begin T := Self.CustomLearningRateScheduleFn; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCurrentLearningRate_R(Self: TNeuralFitBase; var T: single);
begin T := Self.CurrentLearningRate; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCurrentStep_R(Self: TNeuralFitBase; var T: integer);
begin T := Self.CurrentStep; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseCurrentEpoch_R(Self: TNeuralFitBase; var T: integer);
begin T := Self.CurrentEpoch; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseClipDelta_W(Self: TNeuralFitBase; const T: single);
begin Self.ClipDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseClipDelta_R(Self: TNeuralFitBase; var T: single);
begin T := Self.ClipDelta; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseAvgNN_R(Self: TNeuralFitBase; var T: TNNet);
begin T := Self.AvgNN; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseAvgWeightEpochCount_W(Self: TNeuralFitBase; const T: integer);
begin Self.AvgWeightEpochCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralFitBaseAvgWeightEpochCount_R(Self: TNeuralFitBase; var T: integer);
begin T := Self.AvgWeightEpochCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralfit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MonopolarCompare, 'MonopolarCompare', cdRegister);
 S.RegisterDelphiFunction(@BipolarCompare, 'BipolarCompare', cdRegister);
 S.RegisterDelphiFunction(@BipolarCompare99, 'BipolarCompare99', cdRegister);
 S.RegisterDelphiFunction(@ClassCompare, 'ClassCompare', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralImageFit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuralImageFit) do begin
    RegisterConstructor(@TNeuralImageFit.Create, 'Create');
     RegisterMethod(@TNeuralImageFit.Destroy, 'Free');
    RegisterMethod(@TNeuralImageFit.Fit, 'Fit');
    RegisterMethod(@TNeuralImageFit.RunNNThread, 'RunNNThread');
    RegisterMethod(@TNeuralImageFit.TestNNThread, 'TestNNThread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralImageLoadingFit(CL: TPSRuntimeClassImporter);
begin
{
  with CL.Add(TNeuralImageLoadingFit) do
  begin
    RegisterConstructor(@TNeuralImageLoadingFit.Create, 'Create');
    RegisterMethod(@TNeuralImageLoadingFitFitLoading4_P, 'FitLoading4');
    RegisterPropertyHelper(@TNeuralImageLoadingFitSizeX_R,nil,'SizeX');
    RegisterPropertyHelper(@TNeuralImageLoadingFitSizeY_R,nil,'SizeY');
    RegisterPropertyHelper(@TNeuralImageLoadingFitTrainingVolumeCacheEnabled_R,@TNeuralImageLoadingFitTrainingVolumeCacheEnabled_W,'TrainingVolumeCacheEnabled');
    RegisterPropertyHelper(@TNeuralImageLoadingFitTrainingVolumeCacheSize_R,@TNeuralImageLoadingFitTrainingVolumeCacheSize_W,'TrainingVolumeCacheSize');
    RegisterPropertyHelper(@TNeuralImageLoadingFitTrainingVolumeCachePct_R,@TNeuralImageLoadingFitTrainingVolumeCachePct_W,'TrainingVolumeCachePct');
  end;  }
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralFit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuralFit) do
  begin
    RegisterConstructor(@TNeuralFit.Create, 'Create');
     RegisterMethod(@TNeuralFit.Destroy, 'Free');
    RegisterMethod(@TNeuralFit.Fit, 'Fit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralDataLoadingFit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuralDataLoadingFit) do
  begin
    RegisterConstructor(@TNeuralDataLoadingFit.Create, 'Create');
    RegisterMethod(@TNeuralDataLoadingFitFitLoading_P, 'FitLoading');
    RegisterMethod(@TNeuralDataLoadingFitFitLoading1_P, 'FitLoading1');
    RegisterMethod(@TNeuralDataLoadingFit.FitLoading2, 'FitLoading2');
    RegisterMethod(@TNeuralDataLoadingFit.FitLoading22, 'FitLoading22');
    RegisterMethod(@TNeuralDataLoadingFit.EnableMonopolarHitComparison, 'EnableMonopolarHitComparison');
    RegisterMethod(@TNeuralDataLoadingFit.EnableBipolarHitComparison, 'EnableBipolarHitComparison');
    RegisterMethod(@TNeuralDataLoadingFit.EnableBipolar99HitComparison, 'EnableBipolar99HitComparison');
    RegisterMethod(@TNeuralDataLoadingFit.EnableClassComparison, 'EnableClassComparison');
    RegisterMethod(@TNeuralDataLoadingFit.RunNNThread, 'RunNNThread');
    RegisterMethod(@TNeuralDataLoadingFit.TestNNThread, 'TestNNThread');
    RegisterMethod(@TNeuralDataLoadingFitAllocateMemory2_P, 'AllocateMemory2');
    RegisterMethod(@TNeuralDataLoadingFitAllocateMemory2_P, 'AllocateMemory');
    RegisterMethod(@TNeuralDataLoadingFitAllocateMemory3_P, 'AllocateMemory3');
    RegisterMethod(@TNeuralDataLoadingFit.FreeMemory, 'FreeMemory');
    RegisterMethod(@TNeuralDataLoadingFit.EnableDefaultImageTreatment, 'EnableDefaultImageTreatment');
    //RegisterMethod(@TNeuralDataLoadingFit.EnableDefaultImageTreatment, 'EnableDefaultImageTreatment');
    RegisterMethod(@TNeuralDataLoadingFit.CloseResFile, 'CloseResFile');
    //EnableDefaultImageTreatment
    RegisterMethod(@TNeuralDataLoadingFit.RunTrainingBatch, 'RunTrainingBatch');
    RegisterMethod(@TNeuralDataLoadingFit.RunValidationBatch, 'RunValidationBatch');
    RegisterMethod(@TNeuralDataLoadingFit.RunTestBatch, 'RunTestBatch');
    RegisterPropertyHelper(@TNeuralDataLoadingFitDataAugmentationFn_R,@TNeuralDataLoadingFitDataAugmentationFn_W,'DataAugmentationFn');
    RegisterPropertyHelper(@TNeuralDataLoadingFitInferHitFn_R,@TNeuralDataLoadingFitInferHitFn_W,'InferHitFn');
    RegisterPropertyHelper(@TNeuralDataLoadingFitLossFn_R,@TNeuralDataLoadingFitLossFn_W,'LossFn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralFitWithImageBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuralFitWithImageBase) do
  begin
    RegisterConstructor(@TNeuralFitWithImageBase.Create, 'Create');
     RegisterMethod(@TNeuralFitWithImageBase.Destroy, 'Free');
    RegisterMethod(@TNeuralFitWithImageBase.ClassifyImage, 'ClassifyImage');
    RegisterMethod(@TNeuralFitWithImageBase.EnableDefaultImageTreatment, 'EnableDefaultImageTreatment');
    RegisterPropertyHelper(@TNeuralFitWithImageBaseHasImgCrop_R,@TNeuralFitWithImageBaseHasImgCrop_W,'HasImgCrop');
    RegisterPropertyHelper(@TNeuralFitWithImageBaseHasMakeGray_R,@TNeuralFitWithImageBaseHasMakeGray_W,'HasMakeGray');
    RegisterPropertyHelper(@TNeuralFitWithImageBaseHasFlipX_R,@TNeuralFitWithImageBaseHasFlipX_W,'HasFlipX');
    RegisterPropertyHelper(@TNeuralFitWithImageBaseHasFlipY_R,@TNeuralFitWithImageBaseHasFlipY_W,'HasFlipY');
    RegisterPropertyHelper(@TNeuralFitWithImageBaseHasResizing_R,@TNeuralFitWithImageBaseHasResizing_W,'HasResizing');
    RegisterPropertyHelper(@TNeuralFitWithImageBaseMaxCropSize_R,@TNeuralFitWithImageBaseMaxCropSize_W,'MaxCropSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralFitBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuralFitBase) do
  begin
    RegisterConstructor(@TNeuralFitBase.Create, 'Create');
     RegisterMethod(@TNeuralFitBase.Destroy, 'Free');
    RegisterMethod(@TNeuralFitBase.WaitUntilFinished, 'WaitUntilFinished');
    //RegisterMethod(@TNeuralFitBase.DisableOpenCL, 'DisableOpenCL');
    //RegisterMethod(@TNeuralFitBase.EnableOpenCL, 'EnableOpenCL');
    RegisterPropertyHelper(@TNeuralFitBaseAvgWeightEpochCount_R,@TNeuralFitBaseAvgWeightEpochCount_W,'AvgWeightEpochCount');
    RegisterPropertyHelper(@TNeuralFitBaseAvgNN_R,nil,'AvgNN');
    RegisterPropertyHelper(@TNeuralFitBaseClipDelta_R,@TNeuralFitBaseClipDelta_W,'ClipDelta');
    RegisterPropertyHelper(@TNeuralFitBaseCurrentEpoch_R,nil,'CurrentEpoch');
    RegisterPropertyHelper(@TNeuralFitBaseCurrentStep_R,nil,'CurrentStep');
    RegisterPropertyHelper(@TNeuralFitBaseCurrentLearningRate_R,nil,'CurrentLearningRate');
    RegisterPropertyHelper(@TNeuralFitBaseCustomLearningRateScheduleFn_R,@TNeuralFitBaseCustomLearningRateScheduleFn_W,'CustomLearningRateScheduleFn');
    RegisterPropertyHelper(@TNeuralFitBaseCustomLearningRateScheduleObjFn_R,@TNeuralFitBaseCustomLearningRateScheduleObjFn_W,'CustomLearningRateScheduleObjFn');
    RegisterPropertyHelper(@TNeuralFitBaseCyclicalLearningRateLen_R,@TNeuralFitBaseCyclicalLearningRateLen_W,'CyclicalLearningRateLen');
    RegisterPropertyHelper(@TNeuralFitBaseFileNameBase_R,@TNeuralFitBaseFileNameBase_W,'FileNameBase');
    RegisterPropertyHelper(@TNeuralFitBaseInertia_R,@TNeuralFitBaseInertia_W,'Inertia');
    RegisterPropertyHelper(@TNeuralFitBaseInitialEpoch_R,@TNeuralFitBaseInitialEpoch_W,'InitialEpoch');
    RegisterPropertyHelper(@TNeuralFitBaseInitialLearningRate_R,@TNeuralFitBaseInitialLearningRate_W,'InitialLearningRate');
    RegisterPropertyHelper(@TNeuralFitBaseLearningRateDecay_R,@TNeuralFitBaseLearningRateDecay_W,'LearningRateDecay');
    RegisterPropertyHelper(@TNeuralFitBaseL2Decay_R,@TNeuralFitBaseL2Decay_W,'L2Decay');
    RegisterPropertyHelper(@TNeuralFitBaseMaxThreadNum_R,@TNeuralFitBaseMaxThreadNum_W,'MaxThreadNum');
    RegisterPropertyHelper(@TNeuralFitBaseMomentum_R,@TNeuralFitBaseMomentum_W,'Momentum');
    RegisterPropertyHelper(@TNeuralFitBaseMultipleSamplesAtValidation_R,@TNeuralFitBaseMultipleSamplesAtValidation_W,'MultipleSamplesAtValidation');
    RegisterPropertyHelper(@TNeuralFitBaseNN_R,nil,'NN');
    RegisterPropertyHelper(@TNeuralFitBaseOnAfterStep_R,@TNeuralFitBaseOnAfterStep_W,'OnAfterStep');
    RegisterPropertyHelper(@TNeuralFitBaseOnAfterEpoch_R,@TNeuralFitBaseOnAfterEpoch_W,'OnAfterEpoch');
    RegisterPropertyHelper(@TNeuralFitBaseOnStart_R,@TNeuralFitBaseOnStart_W,'OnStart');
    RegisterPropertyHelper(@TNeuralFitBaseStaircaseEpochs_R,@TNeuralFitBaseStaircaseEpochs_W,'StaircaseEpochs');
    RegisterPropertyHelper(@TNeuralFitBaseTargetAccuracy_R,@TNeuralFitBaseTargetAccuracy_W,'TargetAccuracy');
    RegisterPropertyHelper(@TNeuralFitBaseValidationAccuracy_R,nil,'ValidationAccuracy');
    RegisterPropertyHelper(@TNeuralFitBaseVerbose_R,@TNeuralFitBaseVerbose_W,'Verbose');
    RegisterPropertyHelper(@TNeuralFitBaseTestAccuracy_R,nil,'TestAccuracy');
    RegisterPropertyHelper(@TNeuralFitBaseThreadNN_R,nil,'ThreadNN');
    RegisterPropertyHelper(@TNeuralFitBaseTrainingAccuracy_R,nil,'TrainingAccuracy');
    RegisterPropertyHelper(@TNeuralFitBaseRunning_R,nil,'Running');
    RegisterPropertyHelper(@TNeuralFitBaseShouldQuit_R,@TNeuralFitBaseShouldQuit_W,'ShouldQuit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralfit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNeuralFitBase(CL);
  RIRegister_TNeuralFitWithImageBase(CL);
  RIRegister_TNeuralDataLoadingFit(CL);
  RIRegister_TNeuralFit(CL);
  RIRegister_TNeuralImageLoadingFit(CL);
  RIRegister_TNeuralImageFit(CL);
end;

 
 
{ TPSImport_neuralfit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralfit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralfit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralfit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralfit(ri);
  RIRegister_neuralfit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
