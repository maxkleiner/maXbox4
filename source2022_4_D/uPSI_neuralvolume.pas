unit uPSI_neuralvolume;
{
TCAI Lazarus    BPMag    fix virtual  CreateTokenizedStringList  registervirtual
  Tneuralfloatarray   - RegisterProperty('FData', 'TNeuralFloatArray', iptrw);
     TNNetVolumePairList add net
     add function GetValueCount(Value: T): integer;
    function GetSmallestIdxInRange(StartPos, Len: integer): integer;   fix neuronforce88
    with CL.AddClassN(CL.FindClass('TList'),'TNNetList') do  begin
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
  TPSImport_neuralvolume = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_TNNetDictionary(CL: TPSPascalCompiler);
procedure SIRegister_TStringListInt(CL: TPSPascalCompiler);
procedure SIRegister_TNNetStringList(CL: TPSPascalCompiler);
procedure SIRegister_TNNetKMeans(CL: TPSPascalCompiler);
procedure SIRegister_TNNetVolumePairList(CL: TPSPascalCompiler);
procedure SIRegister_TNNetVolumeList(CL: TPSPascalCompiler);
procedure SIRegister_TMObject(CL: TPSPascalCompiler);
procedure SIRegister_TNNetVolumePair(CL: TPSPascalCompiler);
procedure SIRegister_TNNetVolume(CL: TPSPascalCompiler);
procedure SIRegister_TVolume(CL: TPSPascalCompiler);
procedure SIRegister_TNNetList(CL: TPSPascalCompiler);
procedure SIRegister_neuralvolume(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralvolume_Routines(S: TPSExec);
procedure RIRegister_TNNetDictionary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringListInt(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetKMeans(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetVolumePairList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetVolumeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetVolumePair(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetVolume(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVolume(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNNetList(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralvolume(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // fgl
  Contnrs
  ,neuralvolume
  ;
 

//type TNeuralFloatArray = array of TNeuralFloat;

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralvolume]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetDictionary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringListInt', 'TNNetDictionary') do
  with CL.AddClassN(CL.FindClass('TStringListInt'),'TNNetDictionary') do
  begin
    RegisterMethod('Constructor Create( pMaxSize : integer)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function AddWordToDictionary( pWord : string) : boolean');
    RegisterMethod('Function AddWordsToDictionary( pString : string) : boolean');
    RegisterMethod('Function WordToIndex( pWord : string) : integer');
    RegisterMethod('Procedure StringToVolume( pString : string; Volume : TNNetVolume)');
    RegisterMethod('Function VolumeToString( Volume : TNNetVolume; Threshold : TNeuralFloat) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringListInt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetStringList', 'TStringListInt') do
  with CL.AddClassN(CL.FindClass('TNNetStringList'),'TStringListInt') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure SortByIntegerAsc');
    RegisterMethod('Procedure SortByIntegerDesc');
    RegisterMethod('Function AddInteger( const S : string; AValue : PtrInt) : integer');
    RegisterProperty('Integers', 'PtrInt Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TNNetStringList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TNNetStringList') do
  begin
    RegisterMethod('Function GetRandomIndex( ) : integer');
    RegisterMethod('Procedure DeleteFirst( Cnt : integer)');
    RegisterMethod('Procedure DeleteLast( Cnt : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetKMeans(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMObject', 'TNNetKMeans') do
  with CL.AddClassN(CL.FindClass('TMObject'),'TNNetKMeans') do
  begin
    RegisterMethod('Constructor Create( pVolNum, pSizeX, pSizeY, pDepth : integer; pManhattan : boolean)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure RunStep( RepositionClusters : boolean)');
    RegisterMethod('Procedure Resize( pVolNum, pSizeX, pSizeY, pDepth : integer)');
    RegisterMethod('Procedure Randomize( )');
    RegisterMethod('Procedure RandomizeEmptyClusters( )');
    RegisterMethod('Procedure AddSample( Original : TNNetVolume)');
    RegisterMethod('Function GetClusterId( Original : TNNetVolume) : integer');
    RegisterMethod('Function GetTotalSize( ) : integer');
    RegisterProperty('Sample', 'TNNetVolumeList', iptr);
    RegisterProperty('Clusters', 'TNNetVolumeList', iptr);
    RegisterProperty('LastStepTime', 'double', iptr);
    RegisterProperty('LastDistance', 'TNeuralFloat', iptr);
    RegisterProperty('ManhattanDistance', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetVolumePairList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetList', 'TNNetVolumePairList') do
  with CL.AddClassN(CL.FindClass('TNNetList'),'TNNetVolumePairList') do
  begin
  RegisterMethod('Function add(avolume: TNNetVolumePair): integer');
    RegisterProperty('Items', 'TNNetVolumePair Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetVolumeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNNetList', 'TNNetVolumeList') do
  with CL.AddClassN(CL.FindClass('TNNetList'),'TNNetVolumeList') do
  begin
    RegisterMethod('Function GetTotalSize( ) : integer');
    RegisterMethod('Function GetSum( ) : TNeuralFloat');
    RegisterMethod('Function GetAvg( ) : TNeuralFloat');
    RegisterMethod('Function GetClosestId( Original : TNNetVolume; var MinDist : TNeuralFloat) : integer');
    RegisterMethod('Function GetManhattanClosestId( Original : TNNetVolume; var MinDist : TNeuralFloat) : integer');
    RegisterMethod('Procedure Fill( c : Single)');
    RegisterMethod('Procedure ClearTag( )');
    RegisterMethod('Procedure ConcatInto( V : TNNetVolume)');
    RegisterMethod('Procedure InterleaveInto( V : TNNetVolume)');
    RegisterMethod('Procedure SplitFrom( V : TNNetVolume)');
    RegisterMethod('Procedure AddVolumes( pVolNum, pSizeX, pSizeY, pDepth : integer; c : TNeuralFloat);');
    RegisterMethod('Procedure AddVolumes84( pVolNum, pSizeX, pSizeY, pDepth : integer; c : TNeuralFloat);');
    RegisterMethod('Procedure AddVolumes85( Origin : TNNetVolumeList);');
    RegisterMethod('Procedure AddCopy( Origin : TNNetVolume)');
    RegisterMethod('Procedure AddInto( Original : TNNetVolume)');
    RegisterMethod('Procedure SortByTagAsc');
    RegisterMethod('Procedure SortByTagDesc');
    //alist: TNNetlist; avolume: TNNetVolume): integer;
    RegisterMethod('Function add(avolume: TNNetVolume): integer');
    RegisterMethod('Function addnetvolume(avolume: TNNetVolume): integer');
    //RegisterMethod(@addnetvolume, 'addnetvolume');
    RegisterMethod('Procedure GetColumn( V : TNNetVolume; colIdx : integer)');
    RegisterMethod('Procedure ResizeImage( NewSizeX, NewSizeY : integer)');
    RegisterProperty('Items', 'TNNetVolume Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMObject') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure DefaultMessageProc( const S : string)');
    RegisterMethod('Procedure DefaultErrorProc( const S : string)');
    RegisterMethod('Procedure DefaultHideMessages( const S : string)');
    RegisterMethod('Procedure HideMessages( )');
    RegisterProperty('MessageProc', 'TGetStrProc', iptrw);
    RegisterProperty('ErrorProc', 'TGetStrProc', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetVolumePair(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TNNetVolumePair') do
  with CL.AddClassN(CL.FindClass('TObject'),'TNNetVolumePair') do
  begin
   RegisterMethod('Constructor Create( );');
   RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create81( );');
    RegisterMethod('Constructor Create82( pA, pB : TNNetVolume);');
    RegisterMethod('Constructor CreateCopying83( pA, pB : TNNetVolume);');
    RegisterProperty('A', 'TNNetVolume', iptr);
    RegisterProperty('B', 'TNNetVolume', iptr);
    RegisterProperty('I', 'TNNetVolume', iptr);
    RegisterProperty('O', 'TNNetVolume', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetVolume(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVolume', 'TNNetVolume') do
  with CL.AddClassN(CL.FindClass('TVolume'),'TNNetVolume') do begin
   RegisterMethod('procedure ReSize(pSizeX, pSizeY, pDepth: integer)'); //override;
    RegisterMethod('Function GetMemSize( ) : integer');
    RegisterMethod('Procedure CalculateLocalResponseFrom2D( Original : TNNetVolume; pSize : integer; alpha, beta : TNeuralFloat)');
    RegisterMethod('Procedure CalculateLocalResponseFromDepth( Original : TNNetVolume; pSize : integer; alpha, beta : TNeuralFloat)');
    RegisterMethod('Procedure InterleavedDotProduct59( InterleavedAs, B : TNNetVolume);');
    RegisterMethod('Procedure InterleavedDotProduct60( InterleavedAs, Bs : TNNetVolume; VectorSize : integer);');
    RegisterMethod('Procedure DotProducts( NumAs, NumBs, VectorSize : integer; VAs, VBs : TNNetVolume)');
    RegisterMethod('Procedure AddArea( DestX, DestY, OriginX, OriginY, LenX, LenY : integer; Original : TNNetVolume)');
    RegisterMethod('Function HasAVX : boolean');
    RegisterMethod('Function HasAVX2 : boolean');
    RegisterMethod('Function HasAVX512 : boolean');
    RegisterMethod('Function PearsonCorrelation( Y : TNNetVolume) : TNeuralFloat');
    RegisterMethod('Procedure AddSumChannel( Original : TNNetVolume)');
    RegisterMethod('Procedure AddSumSqrChannel( Original : TNNetVolume)');
    RegisterMethod('Procedure AddToChannels( Original : TNNetVolume)');
    RegisterMethod('Procedure MulChannels( Original : TNNetVolume)');
    RegisterMethod('Procedure Mul61( Original : TNNetVolume);');
    RegisterMethod('Procedure NormalizeMax( Value : TNeuralFloat)');
    RegisterMethod('Procedure RecurrencePlot( Original : TNNetVolume; Threshold : TNeuralFloat)');
    RegisterMethod('Procedure RecurrencePlotCAI( Original : TNNetVolume)');
    RegisterMethod('Procedure Fill( c : Single)');
    RegisterMethod('Procedure Add62( Original : TNNetVolume);');
    RegisterMethod('Procedure Add( Original : TNNetVolume);');
    RegisterMethod('Procedure Add63( PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer);');
    RegisterMethod('Procedure Sub64( Original : TNNetVolume);');
    RegisterMethod('Function DotProduct65( Original : TNNetVolume) : TNeuralFloat;');
    RegisterMethod('Function DotProduct66( PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer) : Single;');
    RegisterMethod('Procedure Mul67( Value : Single);');
    RegisterMethod('Procedure Mul68( PtrA, PtrB : TNeuralFloatArrPtr; pSize : integer);');
    RegisterMethod('Procedure MulAdd69( Value : TNeuralFloat; Original : TNNetVolume);');
    RegisterMethod('Procedure MulAdd70( Original1, Original2 : TNNetVolume);');
    RegisterMethod('Procedure MulMulAdd71( Value1, Value2 : TNeuralFloat; Original : TNNetVolume);');
    RegisterMethod('Procedure MulAdd72( Value : TNeuralFloat; PtrB : TNeuralFloatArrPtr);');
    RegisterMethod('Procedure MulAdd73( PtrA, PtrB : TNeuralFloatArrPtr; Value : TNeuralFloat; pSize : integer);');
    RegisterMethod('Procedure MulAdd74( PtrA, PtrB, PtrC : TNeuralFloatArrPtr; pSize : integer);');
    RegisterMethod('Procedure Divi75( Value : Single);');
    RegisterMethod('Procedure Copy76( Original : TNNetVolume);');
    RegisterMethod('Procedure Copy( Original : TNNetVolume);');
    RegisterMethod('Procedure CopyRelu77( Original : TNNetVolume);');
    RegisterMethod('Procedure CopyPadding( Original : TNNetVolume; Padding : integer)');
    RegisterMethod('Procedure CopyNoChecks( Original : TNNetVolume)');
    RegisterMethod('Function GetDistanceSqr78( Original : TNNetVolume) : TNeuralFloat;');
    RegisterMethod('Function GetDistance79( Original : TNNetVolume) : TNeuralFloat;');
    RegisterMethod('Function SumDiff80( Original : TNNetVolume) : TNeuralFloat;');
    RegisterMethod('function GetSum(): TNeuralFloat;');
   RegisterMethod('function GetSumSqr(): TNeuralFloat;');

       //function GetSum(): TNeuralFloat; override;
      //function GetSumSqr(): TNeuralFloat; override;
    RegisterProperty('DataPtr', 'TNeuralFloatArrPtr', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVolume(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TVolume') do
  with CL.AddClassN(CL.FindClass('TObject'),'TVolume') do
  begin
    RegisterProperty('FData2', 'array of TNeuralFloat', iptrw);
    RegisterProperty('FData1', 'array of single', iptrw);
    RegisterProperty('FData3', 'TNeuralFloat integer', iptrw);
    RegisterProperty('FData4', 'TNeuralFloatArray integer', iptrw);
    RegisterProperty('FData', 'TNeuralFloatArray', iptrw);
    //RegisterMethod('Constructor Create( pSizeX, pSizeY, pDepth : integer; c : TNeuralFloat);');
    RegisterMethod('Constructor Create0( pSizeX, pSizeY, pDepth : integer; c : TNeuralFloat);');
    RegisterMethod('Constructor Create1( pInput : array of TNeuralFloat);');
    RegisterMethod('Constructor Create2( Original : array of byte);');
    RegisterMethod('Constructor Create3( Original : TVolume);');
    RegisterMethod('Constructor Create4( Original : TBits; pFalse : TNeuralFloat; pTrue : TNeuralFloat);');
    RegisterMethod('Constructor CreateAsBits5( Original : array of byte; pFalse : TNeuralFloat; pTrue : TNeuralFloat);');
    RegisterMethod('Constructor Create6( pSize : integer; c : TNeuralFloat);');
    RegisterMethod('Constructor Create7( );');
    RegisterMethod('Constructor Create( );');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Fill( c : TNeuralFloat)');
    RegisterMethod('Procedure FillForIdx( c : TNeuralFloat; const aIdx : array of integer)');
    RegisterMethod('Procedure FillAtDepth( pDepth : integer; Value : TNeuralFloat)');
    RegisterMethod('Procedure FillForDebug( )');
    RegisterMethod('Procedure Resize8( pSize : integer);');
    RegisterMethod('Procedure ReSize9( pSizeX, pSizeY, pDepth : integer);');
    RegisterMethod('Procedure ReSize10( Original : TVolume);');
    RegisterMethod('Function Get( x, y, d : integer) : TNeuralFloat');
    RegisterMethod('Function GetAsByte( x, y, d : integer) : byte');
    RegisterMethod('Function GetRaw( x : integer) : TNeuralFloat');
    RegisterMethod('Procedure SetRaw( X : integer; Value : TNeuralFloat)');
    RegisterMethod('Procedure Store( x, y, d : integer; Value : TNeuralFloat)');
    RegisterMethod('Procedure Add11( x, y, d : integer; Value : TNeuralFloat);');
    RegisterMethod('Procedure Add12( Original : TVolume);');
    RegisterMethod('Procedure Add13( Value : TNeuralFloat);');
    RegisterMethod('Procedure Add14( PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer);');
    RegisterMethod('Procedure AddAtDepth15( pDepth : integer; Value : TNeuralFloat);');
    RegisterMethod('Procedure AddLayers16( A, B : TVolume);');
    RegisterMethod('Procedure Sub17( x, y, d : integer; Value : TNeuralFloat);');
    RegisterMethod('Procedure Sub18( Original : TVolume);');
    RegisterMethod('Procedure Sub19( Value : TNeuralFloat);');
    RegisterMethod('Procedure Diff20( Original : TVolume);');
    RegisterMethod('Procedure InterleaveWithDepthFrom( Original : TVolume; NewDepth : integer)');
    RegisterMethod('Procedure InterleaveWithXFrom( Original : TVolume; NewX : integer)');
    RegisterMethod('Function IncYSize( ) : integer');
    RegisterMethod('Function IncYSizeBytes( ) : integer');
    RegisterMethod('Procedure DeInterleaveWithXFrom( Original : TVolume; NewX : integer)');
    RegisterMethod('Procedure DeInterleaveWithDepthFrom( Original : TVolume; NewDepth : integer)');
    RegisterMethod('Procedure SetMin21( Value : TNeuralFloat);');
    RegisterMethod('Procedure SetMax22( Value : TNeuralFloat);');
    RegisterMethod('Procedure Mul23( x, y, d : integer; Value : TNeuralFloat);');
    RegisterMethod('Procedure Mul24( Original : TVolume);');
    RegisterMethod('Procedure Mul25( PtrA, PtrB : TNeuralFloatArrPtr; pSize : integer);');
    RegisterMethod('Procedure Mul26( Value : TNeuralFloat);');
    RegisterMethod('Procedure MulAtDepth27( pDepth : integer; Value : TNeuralFloat);');
    RegisterMethod('Procedure Pow28( Value : TNeuralFloat);');
    RegisterMethod('Procedure VSqrt( )');
    RegisterMethod('Procedure MulAdd29( Value : TNeuralFloat; Original : TVolume);');
    RegisterMethod('Procedure MulMulAdd30( Value1, Value2 : TNeuralFloat; Original : TVolume);');
    RegisterMethod('Procedure MulAdd31( Value : TNeuralFloat; PtrB : TNeuralFloatArrPtr);');
    RegisterMethod('Procedure MulAdd32( Original1, Original2 : TVolume);');
    RegisterMethod('Procedure MulAdd33( PtrA, PtrB : TNeuralFloatArrPtr; Value : TNeuralFloat; pSize : integer);');
    RegisterMethod('Procedure MulAdd34( PtrA, PtrB, PtrC : TNeuralFloatArrPtr; pSize : integer);');
    RegisterMethod('Procedure Divi35( x, y, d : integer; Value : TNeuralFloat);');
    RegisterMethod('Procedure Divi36( Original : TVolume);');
    RegisterMethod('Procedure Divi37( Value : TNeuralFloat);');
    RegisterMethod('Procedure ForceMinRange( Value : TNeuralFloat)');
    RegisterMethod('Procedure ForceMaxRange( Value : TNeuralFloat)');
    RegisterMethod('Procedure Randomize( a : integer; b : integer; c : integer)');
    RegisterMethod('Procedure RandomizeGaussian( pMul : TNeuralFloat)');
    RegisterMethod('Procedure AddGaussianNoise( pMul : TNeuralFloat)');
    RegisterMethod('Procedure AddSaltAndPepper( pNum : integer; pSalt : TNeuralFloat; pPepper : TNeuralFloat; pColor : boolean)');
    RegisterMethod('Function RandomGaussianValue( ) : TNeuralFloat');
    RegisterMethod('Procedure Copy38( Original : TVolume);');
    RegisterMethod('Procedure CopyRelu39( Original : TVolume);');
    RegisterMethod('Procedure Copy40( Original : TVolume; Len : integer);');
    RegisterMethod('Procedure Copy41( var Original : array of TNeuralFloat);');
    RegisterMethod('Procedure Copy42( var Original : array of byte);');
    RegisterMethod('Procedure Copy43( Original : TBits; pFlase : TNeuralFloat; pTrue : TNeuralFloat);');
    RegisterMethod('Procedure CopyPadding( Original : TVolume; Padding : integer)');
    RegisterMethod('Procedure CopyCropping( Original : TVolume; StartX, StartY, pSizeX, pSizeY : integer)');
    RegisterMethod('Procedure CopyResizing( Original : TVolume; NewSizeX, NewSizeY : integer)');
    RegisterMethod('Procedure CopyNoChecks( Original : TVolume)');
    RegisterMethod('Procedure CopyChannels( Original : TVolume; aChannels : array of integer)');
    RegisterMethod('Procedure Define( Original : array of TNeuralFloat)');
    RegisterMethod('Function DotProduct44( Original : TVolume) : TNeuralFloat;');
    RegisterMethod('Function DotProduct45( PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer) : Single;');
    RegisterMethod('Function SumDiff( Original : TVolume) : TNeuralFloat');
    RegisterMethod('Procedure SumToPos( Original : TVolume)');
    RegisterMethod('Function GetDistanceSqr46( Original : TVolume) : TNeuralFloat;');
    RegisterMethod('Function GetDistance47( Original : TVolume) : TNeuralFloat;');
    RegisterMethod('Function SumAtDepth( pDepth : integer) : TNeuralFloat');
    RegisterMethod('Function AvgAtDepth( pDepth : integer) : TNeuralFloat');
    RegisterMethod('Function GetRawPos48( x, y, d : integer) : integer;');
    RegisterMethod('Function GetRawPos49( x, y : integer) : integer;');
    RegisterMethod('Function GetRawPtr50( x, y, d : integer) : pointer;');
    RegisterMethod('Function GetRawPtr51( x, y : integer) : pointer;');
    RegisterMethod('Function GetRawPtr52( x : integer) : pointer;');
    RegisterMethod('Function GetRawPtr53( ) : pointer;');
    RegisterMethod('Function GetMin( ) : TNeuralFloat');
    RegisterMethod('Function GetMax( ) : TNeuralFloat');
    RegisterMethod('Function GetNonZero( ) : integer');
    RegisterMethod('Function GetMaxAbs( ) : TNeuralFloat');
    RegisterMethod('Procedure GetMinMaxAtDepth( pDepth : integer; out pMin, pMax : TNeuralFloat)');
    RegisterMethod('Function GetSum( ) : TNeuralFloat');
    RegisterMethod('Function GetSumAbs( ) : TNeuralFloat');
    RegisterMethod('Function GetSumSqr( ) : TNeuralFloat');
    RegisterMethod('Function GetAvg( ) : TNeuralFloat');
    RegisterMethod('Function GetVariance( ) : TNeuralFloat');
    RegisterMethod('Function GetStdDeviation( ) : TNeuralFloat');
    RegisterMethod('Function GetMagnitude( ) : TNeuralFloat');
    RegisterMethod('function GetSmallestIdxInRange(StartPos, Len: integer): integer;');
    RegisterMethod('function GetValueCount(Value: T): integer;');

   //function GetSmallestIdxInRange(StartPos, Len: integer): integer;
    RegisterMethod('Procedure FlipX( )');
    RegisterMethod('Procedure FlipY( )');
    RegisterMethod('Procedure IncTag( )');
    RegisterMethod('Procedure ClearTag( )');
    RegisterMethod('Function NeuralToStr( V : TNeuralFloat) : string');
    RegisterMethod('Procedure RgbImgToNeuronalInput( color_encoding : integer)');
    RegisterMethod('Procedure NeuronalInputToRgbImg( color_encoding : integer)');
    RegisterMethod('Procedure NeuronalWeightToImg54( color_encoding : integer);');
    RegisterMethod('Procedure NeuronalWeightToImg55( MaxW, MinW : TNeuralFloat; color_encoding : integer);');
    RegisterMethod('Procedure NeuronalWeightToImg3Channel( MaxW0, MinW0, MaxW1, MinW1, MaxW2, MinW2 : TNeuralFloat; color_encoding : integer)');
    RegisterMethod('Procedure ZeroCenter( )');
    RegisterMethod('Procedure Print( )');
    RegisterMethod('Procedure PrintWithIndex( )');
    RegisterMethod('Procedure PrintDebug( )');
    RegisterMethod('Procedure PrintDebugChannel( )');
    RegisterMethod('Procedure InitUniform( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitGaussian( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitLeCunUniform( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitHeUniform( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitLeCunGaussian( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitHeGaussian( Value : TNeuralFloat)');
    RegisterMethod('Procedure InitSELU( Value : TNeuralFloat)');
    RegisterMethod('Function SaveToString( ) : string');
    RegisterMethod('Procedure LoadFromString( strData : string)');
    RegisterMethod('Procedure CopyAsBits56( var Original : array of byte; pFlase : TNeuralFloat; pTrue : TNeuralFloat);');
    RegisterMethod('Procedure ReadAsBits( var Dest : array of byte; Threshold : TNeuralFloat)');
    RegisterMethod('Procedure SetClass57( pClass : integer; value : TNeuralFloat);');
    RegisterMethod('Procedure SetClass58( pClass : integer; TrueValue, FalseValue : TNeuralFloat);');
    RegisterMethod('Procedure SetClassForHiperbolicTangent( pClass : integer)');
    RegisterMethod('Procedure SetClassForReLU( pClass : integer)');
    RegisterMethod('Procedure SetClassForSoftMax( pClass : integer)');
    RegisterMethod('Function GetClass( ) : integer');
    RegisterMethod('Function SoftMax( ) : TNeuralFloat');
    RegisterMethod('Procedure RgbToHsv( )');
    RegisterMethod('Procedure HsvToRgb( )');
    RegisterMethod('Procedure RgbToHsl( )');
    RegisterMethod('Procedure HslToRgb( )');
    RegisterMethod('Procedure RgbToLab( )');
    RegisterMethod('Procedure LabToRgb( )');
    RegisterMethod('Procedure RgbToGray( )');
    RegisterMethod('Procedure GetGrayFromRgb( Rgb : TVolume)');
    RegisterMethod('Procedure MakeGray( color_encoding : integer)');
    RegisterMethod('Procedure ShiftRight( Positions : integer)');
    RegisterMethod('Procedure ShiftLeft( )');
    RegisterProperty('Data', 'TNeuralFloat integer integer integer', iptrw);
    SetDefaultPropery('Data');
    RegisterProperty('AsByte', 'byte integer integer integer', iptr);
    RegisterProperty('Raw', 'TNeuralFloat integer', iptrw);
    RegisterProperty('Tag', 'integer', iptrw);
    RegisterProperty('Tags', 'integer integer', iptrw);
    RegisterProperty('Size', 'integer', iptr);
    RegisterProperty('SizeX', 'integer', iptr);
    RegisterProperty('SizeY', 'integer', iptr);
    RegisterProperty('Depth', 'integer', iptr);
  end;
end;

  function addnet(alist: TNNetlist; avolume: TNNetVolume): integer;
  begin
     result:= alist.add(avolume);
  end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNNetList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TNNetList') do
  with CL.AddClassN(CL.FindClass('TList'),'TNNetList') do  begin
    RegisterProperty('FreeObjects', 'boolean', iptrw);
    RegisterMethod('Function Count : integer');
    RegisterMethod('Function Capacity : integer');
    RegisterMethod('function addnet(alist: TNNetlist; avolume: TNNetVolume): integer;');

    RegisterMethod('Procedure Free');
    //function addvolume(avolume: TNNetVolume): integer;
    RegisterMethod('Constructor Create( pFreeObjects : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralvolume(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('csMinAvxSize','LongInt').SetInt( 16);
 CL.AddConstantN('csEncodeRGB','LongInt').SetInt( 0);
 CL.AddConstantN('csEncodeHSV','LongInt').SetInt( 1);
 CL.AddConstantN('csEncodeHSL','LongInt').SetInt( 2);
 CL.AddConstantN('csEncodeLAB','LongInt').SetInt( 3);
 CL.AddConstantN('csEncodeGray','LongInt').SetInt( 4);
  CL.AddTypeS('TNeuralFloat', 'Single');
  //CL.AddTypeS('TNeuralFloatPtr', '^TNeuralFloat // will not work');
  //CL.AddTypeS('TNeuralFloatArrPtr', '^TNeuralFloatArr // will not work');
  CL.AddTypeS('TNeuralIntegerArray', 'array of integer');
  CL.AddTypeS('TNeuralFloatArray', 'array of TNeuralFloat');

  //RegisterProperty('FData', 'array of TNeuralFloat', iptrw);
  //CL.AddTypeS('T', 'TNeuralFloat');
  CL.AddTypeS('PtrInt', 'Integer');
  SIRegister_TNNetList(CL);
  SIRegister_TVolume(CL);
  SIRegister_TNNetVolume(CL);
  SIRegister_TNNetVolumePair(CL);
  SIRegister_TMObject(CL);
  SIRegister_TNNetVolumeList(CL);
  SIRegister_TNNetVolumePairList(CL);
  SIRegister_TNNetKMeans(CL);
  SIRegister_TNNetStringList(CL);
  SIRegister_TStringListInt(CL);
  SIRegister_TNNetDictionary(CL);
 CL.AddDelphiFunction('Function CreateTokenizedStringList86( str : string; c : char) : TStringList;');
 CL.AddDelphiFunction('Function CreateTokenizedStringList87( c : char) : TStringList;');
 CL.AddDelphiFunction('Function CreateTokenizedStringList( str : string; c : char) : TStringList;');
 CL.AddDelphiFunction('Function CreateTokenizedStringList1( c : char) : TStringList;');

 CL.AddDelphiFunction('Function HiperbolicTangent( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function HiperbolicTangentDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function RectifiedLinearUnit( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function RectifiedLinearUnitDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function RectifiedLinearUnitLeaky( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function RectifiedLinearUnitLeakyDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function ReLULeakyBound( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function ReLULeakyBoundDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function Sigmoid( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function SigmoidDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function Identity( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function IdentityDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function SoftmaxDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function DiffAct( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function DiffActDerivative( x : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function NeuronForceMinMax88( x, pMin, pMax : TNeuralFloat) : TNeuralFloat;');
 CL.AddDelphiFunction('Function NeuronForceMinMax89( x, pMin, pMax : integer) : integer;');
 CL.AddDelphiFunction('Function NeuronForceRange( x, range : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Function NeuronForceMinRange( x, range : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Procedure rgb2hsv( r, g, b : TNeuralFloat; var h, s, v : TNeuralFloat)');
 CL.AddDelphiFunction('Procedure hsv2rgb( h, s, v : TNeuralFloat; var r, g, b : TNeuralFloat)');
 CL.AddDelphiFunction('Function hue2rgb( p, q, t : TNeuralFloat) : TNeuralFloat');
 CL.AddDelphiFunction('Procedure rgb2hsl( r, g, b : TNeuralFloat; var h, s, l : TNeuralFloat)');
 CL.AddDelphiFunction('Procedure hsl2rgb( h, s, l : TNeuralFloat; var r, g, b : TNeuralFloat)');
 CL.AddDelphiFunction('Procedure lab2rgb( l, a, b : TNeuralFloat; var r, g, bb : TNeuralFloat)');
 CL.AddDelphiFunction('Procedure rgb2lab( r, g, b : TNeuralFloat; var l, a, bb : TNeuralFloat)');
 CL.AddDelphiFunction('Function RoundAsByte( x : TNeuralFloat) : byte');
 CL.AddDelphiFunction('Function CompareStringListIntegerAsc( List : TStringList; Index1, Index2 : Integer) : Integer');
 CL.AddDelphiFunction('Function CompareStringListIntegerDesc( List : TStringList; Index1, Index2 : Integer) : Integer');
 CL.AddDelphiFunction('Function CompareNNetVolumeListAsc( const Item1, Item2 : TNNetVolume) : Integer');
 CL.AddDelphiFunction('Function CompareNNetVolumeListDesc( const Item1, Item2 : TNNetVolume) : Integer');
 CL.AddDelphiFunction('Function NeuralFloatToStr( V : TNeuralFloat) : string');
 CL.AddDelphiFunction('Function NeuralStrToFloat( V : String) : TNeuralFloat');
 CL.AddDelphiFunction('Procedure TestTNNetVolume( )');
 CL.AddDelphiFunction('Procedure TestKMeans( )');
 CL.AddDelphiFunction('Procedure TestKMeans2( )');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function NeuronForceMinMax89_P( x, pMin, pMax : integer) : integer;
Begin Result := neuralvolume.NeuronForceMinMax(x, pMin, pMax); END;

(*----------------------------------------------------------------------------*)
Function NeuronForceMinMax88_P( x, pMin, pMax : TNeuralFloat) : TNeuralFloat;
Begin Result := neuralvolume.NeuronForceMinMax(x, pMin, pMax); END;

(*----------------------------------------------------------------------------*)
Function CreateTokenizedStringList87_P( c : char) : TStringList;
Begin Result := neuralvolume.CreateTokenizedStringList(c); END;

(*----------------------------------------------------------------------------*)
Function CreateTokenizedStringList86_P( str : string; c : char) : TStringList;
Begin Result := neuralvolume.CreateTokenizedStringList(str, c); END;

(*----------------------------------------------------------------------------*)
procedure TStringListIntIntegers_W(Self: TStringListInt; const T: PtrInt; const t1: Integer);
begin Self.Integers[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringListIntIntegers_R(Self: TStringListInt; var T: PtrInt; const t1: Integer);
begin T := Self.Integers[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNNetKMeansManhattanDistance_W(Self: TNNetKMeans; const T: boolean);
begin Self.ManhattanDistance := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetKMeansManhattanDistance_R(Self: TNNetKMeans; var T: boolean);
begin T := Self.ManhattanDistance; end;

(*----------------------------------------------------------------------------*)
procedure TNNetKMeansLastDistance_R(Self: TNNetKMeans; var T: TNeuralFloat);
begin T := Self.LastDistance; end;

(*----------------------------------------------------------------------------*)
procedure TNNetKMeansLastStepTime_R(Self: TNNetKMeans; var T: double);
begin T := Self.LastStepTime; end;

(*----------------------------------------------------------------------------*)
procedure TNNetKMeansClusters_R(Self: TNNetKMeans; var T: TNNetVolumeList);
begin T := Self.Clusters; end;

(*----------------------------------------------------------------------------*)
procedure TNNetKMeansSample_R(Self: TNNetKMeans; var T: TNNetVolumeList);
begin T := Self.Sample; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumePairListItems_W(Self: TNNetVolumePairList; const T: TNNetVolumePair; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumePairListItems_R(Self: TNNetVolumePairList; var T: TNNetVolumePair; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumeListItems_W(Self: TNNetVolumeList; const T: TNNetVolume; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumeListItems_R(Self: TNNetVolumeList; var T: TNNetVolume; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeListAddVolumes85_P(Self: TNNetVolumeList;  Origin : TNNetVolumeList);
Begin Self.AddVolumes(Origin); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeListAddVolumes84_P(Self: TNNetVolumeList;  pVolNum, pSizeX, pSizeY, pDepth : integer; c : TNeuralFloat);
Begin Self.AddVolumes(pVolNum, pSizeX, pSizeY, pDepth, c); END;

(*----------------------------------------------------------------------------*)
procedure TMObjectErrorProc_W(Self: TMObject; const T: TGetStrProc);
begin Self.ErrorProc := T; end;

(*----------------------------------------------------------------------------*)
procedure TMObjectErrorProc_R(Self: TMObject; var T: TGetStrProc);
begin T := Self.ErrorProc; end;

(*----------------------------------------------------------------------------*)
procedure TMObjectMessageProc_W(Self: TMObject; const T: TGetStrProc);
begin Self.MessageProc := T; end;

(*----------------------------------------------------------------------------*)
procedure TMObjectMessageProc_R(Self: TMObject; var T: TGetStrProc);
begin T := Self.MessageProc; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumePairO_R(Self: TNNetVolumePair; var T: TNNetVolume);
begin T := Self.O; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumePairI_R(Self: TNNetVolumePair; var T: TNNetVolume);
begin T := Self.I; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumePairB_R(Self: TNNetVolumePair; var T: TNNetVolume);
begin T := Self.B; end;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumePairA_R(Self: TNNetVolumePair; var T: TNNetVolume);
begin T := Self.A; end;

(*----------------------------------------------------------------------------*)
Function TNNetVolumePairCreateCopying83_P(Self: TClass; CreateNewInstance: Boolean;  pA, pB : TNNetVolume):TObject;
Begin Result := TNNetVolumePair.CreateCopying(pA, pB); END;

(*----------------------------------------------------------------------------*)
Function TNNetVolumePairCreate82_P(Self: TClass; CreateNewInstance: Boolean;  pA, pB : TNNetVolume):TObject;
Begin Result := TNNetVolumePair.Create(pA, pB); END;

(*----------------------------------------------------------------------------*)
Function TNNetVolumePairCreate81_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TNNetVolumePair.Create; END;

(*----------------------------------------------------------------------------*)
procedure TNNetVolumeDataPtr_R(Self: TNNetVolume; var T: TNeuralFloatArrPtr);
begin T := Self.DataPtr; end;

(*----------------------------------------------------------------------------*)
Function TNNetVolumeSumDiff80_P(Self: TNNetVolume;  Original : TNNetVolume) : TNeuralFloat;
Begin Result := Self.SumDiff(Original); END;

(*----------------------------------------------------------------------------*)
Function TNNetVolumeGetDistance79_P(Self: TNNetVolume;  Original : TNNetVolume) : TNeuralFloat;
Begin Result := Self.GetDistance(Original); END;

(*----------------------------------------------------------------------------*)
Function TNNetVolumeGetDistanceSqr78_P(Self: TNNetVolume;  Original : TNNetVolume) : TNeuralFloat;
Begin Result := Self.GetDistanceSqr(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeCopyRelu77_P(Self: TNNetVolume;  Original : TNNetVolume);
Begin Self.CopyRelu(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeCopy76_P(Self: TNNetVolume;  Original : TNNetVolume);
Begin Self.Copy(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeDivi75_P(Self: TNNetVolume;  Value : Single);
Begin Self.Divi(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMulAdd74_P(Self: TNNetVolume;  PtrA, PtrB, PtrC : TNeuralFloatArrPtr; pSize : integer);
Begin Self.MulAdd(PtrA, PtrB, PtrC, pSize); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMulAdd73_P(Self: TNNetVolume;  PtrA, PtrB : TNeuralFloatArrPtr; Value : TNeuralFloat; pSize : integer);
Begin Self.MulAdd(PtrA, PtrB, Value, pSize); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMulAdd72_P(Self: TNNetVolume;  Value : TNeuralFloat; PtrB : TNeuralFloatArrPtr);
Begin Self.MulAdd(Value, PtrB); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMulMulAdd71_P(Self: TNNetVolume;  Value1, Value2 : TNeuralFloat; Original : TNNetVolume);
Begin Self.MulMulAdd(Value1, Value2, Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMulAdd70_P(Self: TNNetVolume;  Original1, Original2 : TNNetVolume);
Begin Self.MulAdd(Original1, Original2); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMulAdd69_P(Self: TNNetVolume;  Value : TNeuralFloat; Original : TNNetVolume);
Begin Self.MulAdd(Value, Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMul68_P(Self: TNNetVolume;  PtrA, PtrB : TNeuralFloatArrPtr; pSize : integer);
Begin Self.Mul(PtrA, PtrB, pSize); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMul67_P(Self: TNNetVolume;  Value : Single);
Begin Self.Mul(Value); END;

(*----------------------------------------------------------------------------*)
Function TNNetVolumeDotProduct66_P(Self: TNNetVolume;  PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer) : Single;
Begin Result := Self.DotProduct(PtrA, PtrB, NumElements); END;

(*----------------------------------------------------------------------------*)
Function TNNetVolumeDotProduct65_P(Self: TNNetVolume;  Original : TNNetVolume) : TNeuralFloat;
Begin Result := Self.DotProduct(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeSub64_P(Self: TNNetVolume;  Original : TNNetVolume);
Begin Self.Sub(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeAdd63_P(Self: TNNetVolume;  PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer);
Begin Self.Add(PtrA, PtrB, NumElements); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeAdd62_P(Self: TNNetVolume;  Original : TNNetVolume);
Begin Self.Add(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeMul61_P(Self: TNNetVolume;  Original : TNNetVolume);
Begin Self.Mul(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeInterleavedDotProduct60_P(Self: TNNetVolume;  InterleavedAs, Bs : TNNetVolume; VectorSize : integer);
Begin Self.InterleavedDotProduct(InterleavedAs, Bs, VectorSize); END;

(*----------------------------------------------------------------------------*)
Procedure TNNetVolumeInterleavedDotProduct59_P(Self: TNNetVolume;  InterleavedAs, B : TNNetVolume);
Begin Self.InterleavedDotProduct(InterleavedAs, B); END;

(*----------------------------------------------------------------------------*)
procedure TVolumeDepth_R(Self: TVolume; var T: integer);
begin T := Self.Depth; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeSizeY_R(Self: TVolume; var T: integer);
begin T := Self.SizeY; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeSizeX_R(Self: TVolume; var T: integer);
begin T := Self.SizeX; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeSize_R(Self: TVolume; var T: integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeTags_W(Self: TVolume; const T: integer; const t1: integer);
begin Self.Tags[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeTags_R(Self: TVolume; var T: integer; const t1: integer);
begin T := Self.Tags[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeTag_W(Self: TVolume; const T: integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeTag_R(Self: TVolume; var T: integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeRaw_W(Self: TVolume; const T: T; const t1: integer);
begin Self.Raw[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeRaw_R(Self: TVolume; var T: T; const t1: integer);
begin T := Self.Raw[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeAsByte_R(Self: TVolume; var T: byte; const t1: integer; const t2: integer; const t3: integer);
begin T := Self.AsByte[t1, t2, t3]; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeData_W(Self: TVolume; const T: T; const t1: integer; const t2: integer; const t3: integer);
begin Self.Data[t1, t2, t3] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeData_R(Self: TVolume; var T: T; const t1: integer; const t2: integer; const t3: integer);
begin T := Self.Data[t1, t2, t3]; end;

(*----------------------------------------------------------------------------*)
Procedure TVolumeSetClass58_P(Self: TVolume;  pClass : integer; TrueValue, FalseValue : T);
Begin Self.SetClass(pClass, TrueValue, FalseValue); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeSetClass57_P(Self: TVolume;  pClass : integer; value : T);
Begin Self.SetClass(pClass, value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeCopyAsBits56_P(Self: TVolume;  var Original : array of byte; pFlase : T; pTrue : T);
Begin Self.CopyAsBits(Original, pFlase, pTrue); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeNeuronalWeightToImg55_P(Self: TVolume;  MaxW, MinW : TNeuralFloat; color_encoding : integer);
Begin Self.NeuronalWeightToImg(MaxW, MinW, color_encoding); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeNeuronalWeightToImg54_P(Self: TVolume;  color_encoding : integer);
Begin Self.NeuronalWeightToImg(color_encoding); END;

(*----------------------------------------------------------------------------*)
//Function TVolumeGetRawPtr53_P(Self: TVolume;  ) : pointer;
//Begin Result := Self.GetRawPtr; END;

(*----------------------------------------------------------------------------*)
Function TVolumeGetRawPtr52_P(Self: TVolume;  x : integer) : pointer;
Begin Result := Self.GetRawPtr(x); END;

(*----------------------------------------------------------------------------*)
Function TVolumeGetRawPtr51_P(Self: TVolume;  x, y : integer) : pointer;
Begin Result := Self.GetRawPtr(x, y); END;

(*----------------------------------------------------------------------------*)
Function TVolumeGetRawPtr50_P(Self: TVolume;  x, y, d : integer) : pointer;
Begin Result := Self.GetRawPtr(x, y, d); END;

(*----------------------------------------------------------------------------*)
Function TVolumeGetRawPos49_P(Self: TVolume;  x, y : integer) : integer;
Begin Result := Self.GetRawPos(x, y); END;

(*----------------------------------------------------------------------------*)
Function TVolumeGetRawPos48_P(Self: TVolume;  x, y, d : integer) : integer;
Begin Result := Self.GetRawPos(x, y, d); END;

(*----------------------------------------------------------------------------*)
Function TVolumeGetDistance47_P(Self: TVolume;  Original : TVolume) : T;
Begin Result := Self.GetDistance(Original); END;

(*----------------------------------------------------------------------------*)
Function TVolumeGetDistanceSqr46_P(Self: TVolume;  Original : TVolume) : T;
Begin Result := Self.GetDistanceSqr(Original); END;

(*----------------------------------------------------------------------------*)
Function TVolumeDotProduct45_P(Self: TVolume;  PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer) : Single;
Begin Result := Self.DotProduct(PtrA, PtrB, NumElements); END;

(*----------------------------------------------------------------------------*)
Function TVolumeDotProduct44_P(Self: TVolume;  Original : TVolume) : T;
Begin Result := Self.DotProduct(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeCopy43_P(Self: TVolume;  Original : TBits; pFlase : T; pTrue : T);
Begin Self.Copy(Original, pFlase, pTrue); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeCopy42_P(Self: TVolume;  var Original : array of byte);
Begin Self.Copy(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeCopy41_P(Self: TVolume;  var Original : array of TNeuralFloat);
Begin Self.Copy(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeCopy40_P(Self: TVolume;  Original : TVolume; Len : integer);
Begin Self.Copy(Original, Len); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeCopyRelu39_P(Self: TVolume;  Original : TVolume);
Begin Self.CopyRelu(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeCopy38_P(Self: TVolume;  Original : TVolume);
Begin Self.Copy(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeDivi37_P(Self: TVolume;  Value : T);
Begin Self.Divi(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeDivi36_P(Self: TVolume;  Original : TVolume);
Begin Self.Divi(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeDivi35_P(Self: TVolume;  x, y, d : integer; Value : T);
Begin Self.Divi(x, y, d, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMulAdd34_P(Self: TVolume;  PtrA, PtrB, PtrC : TNeuralFloatArrPtr; pSize : integer);
Begin Self.MulAdd(PtrA, PtrB, PtrC, pSize); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMulAdd33_P(Self: TVolume;  PtrA, PtrB : TNeuralFloatArrPtr; Value : T; pSize : integer);
Begin Self.MulAdd(PtrA, PtrB, Value, pSize); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMulAdd32_P(Self: TVolume;  Original1, Original2 : TVolume);
Begin Self.MulAdd(Original1, Original2); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMulAdd31_P(Self: TVolume;  Value : T; PtrB : TNeuralFloatArrPtr);
Begin Self.MulAdd(Value, PtrB); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMulMulAdd30_P(Self: TVolume;  Value1, Value2 : T; Original : TVolume);
Begin Self.MulMulAdd(Value1, Value2, Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMulAdd29_P(Self: TVolume;  Value : T; Original : TVolume);
Begin Self.MulAdd(Value, Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumePow28_P(Self: TVolume;  Value : T);
Begin Self.Pow(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMulAtDepth27_P(Self: TVolume;  pDepth : integer; Value : T);
Begin Self.MulAtDepth(pDepth, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMul26_P(Self: TVolume;  Value : T);
Begin Self.Mul(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMul25_P(Self: TVolume;  PtrA, PtrB : TNeuralFloatArrPtr; pSize : integer);
Begin Self.Mul(PtrA, PtrB, pSize); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMul24_P(Self: TVolume;  Original : TVolume);
Begin Self.Mul(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeMul23_P(Self: TVolume;  x, y, d : integer; Value : T);
Begin Self.Mul(x, y, d, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeSetMax22_P(Self: TVolume;  Value : TNeuralFloat);
Begin Self.SetMax(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeSetMin21_P(Self: TVolume;  Value : TNeuralFloat);
Begin Self.SetMin(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeDiff20_P(Self: TVolume;  Original : TVolume);
Begin Self.Diff(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeSub19_P(Self: TVolume;  Value : T);
Begin Self.Sub(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeSub18_P(Self: TVolume;  Original : TVolume);
Begin Self.Sub(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeSub17_P(Self: TVolume;  x, y, d : integer; Value : T);
Begin Self.Sub(x, y, d, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeAddLayers16_P(Self: TVolume;  A, B : TVolume);
Begin Self.AddLayers(A, B); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeAddAtDepth15_P(Self: TVolume;  pDepth : integer; Value : T);
Begin Self.AddAtDepth(pDepth, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeAdd14_P(Self: TVolume;  PtrA, PtrB : TNeuralFloatArrPtr; NumElements : integer);
Begin Self.Add(PtrA, PtrB, NumElements); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeAdd13_P(Self: TVolume;  Value : T);
Begin Self.Add(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeAdd12_P(Self: TVolume;  Original : TVolume);
Begin Self.Add(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeAdd11_P(Self: TVolume;  x, y, d : integer; Value : T);
Begin Self.Add(x, y, d, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeReSize10_P(Self: TVolume;  Original : TVolume);
Begin Self.ReSize(Original); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeReSize9_P(Self: TVolume;  pSizeX, pSizeY, pDepth : integer);
Begin Self.ReSize(pSizeX, pSizeY, pDepth); END;

(*----------------------------------------------------------------------------*)
Procedure TVolumeResize8_P(Self: TVolume;  pSize : integer);
Begin Self.Resize(pSize); END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreate7_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TVolume.Create; END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreate6_P(Self: TClass; CreateNewInstance: Boolean;  pSize : integer; c : T):TObject;
Begin Result := TVolume.Create(pSize, c); END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreateAsBits5_P(Self: TClass; CreateNewInstance: Boolean;  Original : array of byte; pFalse : T; pTrue : T):TObject;
Begin Result := TVolume.CreateAsBits(Original, pFalse, pTrue); END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreate4_P(Self: TClass; CreateNewInstance: Boolean;  Original : TBits; pFalse : T; pTrue : T):TObject;
Begin Result := TVolume.Create(Original, pFalse, pTrue); END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreate3_P(Self: TClass; CreateNewInstance: Boolean;  Original : TVolume):TObject;
Begin Result := TVolume.Create(Original); END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreate2_P(Self: TClass; CreateNewInstance: Boolean;  Original : array of byte):TObject;
Begin Result := TVolume.Create(Original); END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreate1_P(Self: TClass; CreateNewInstance: Boolean;  pInput : array of T):TObject;
Begin Result := TVolume.Create(pInput); END;

(*----------------------------------------------------------------------------*)
Function TVolumeCreate0_P(Self: TClass; CreateNewInstance: Boolean;  pSizeX, pSizeY, pDepth : integer; c : T):TObject;
Begin Result := TVolume.Create(pSizeX, pSizeY, pDepth, c); END;

(*----------------------------------------------------------------------------*)
procedure TVolumeFData_W(Self: TVolume; const T: TNeuralFloatArray);
Begin Self.FData:= T; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeFData_R(Self: TVolume;  var T: TNeuralFloatArray);
Begin T := Self.FData; end;

{
(*----------------------------------------------------------------------------*)
procedure TVolumeFData_W1(Self: TVolume; idx: integer; const T: array of single);
Begin Self.FData := T; end;

(*----------------------------------------------------------------------------*)
procedure TVolumeFData_R1(Self: TVolume; idx: integer; var T: TNeuralFloat);
Begin T := Self.FData[idx]; end; }


(*----------------------------------------------------------------------------*)
procedure TNNetListFreeObjects_W(Self: TNNetList; const T: boolean);
Begin Self.FreeObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TNNetListFreeObjects_R(Self: TNNetList; var T: boolean);
Begin T := Self.FreeObjects; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralvolume_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateTokenizedStringList86_P, 'CreateTokenizedStringList86', cdRegister);
 S.RegisterDelphiFunction(@CreateTokenizedStringList87_P, 'CreateTokenizedStringList87', cdRegister);
 S.RegisterDelphiFunction(@CreateTokenizedStringList86_P, 'CreateTokenizedStringList', cdRegister);
 S.RegisterDelphiFunction(@CreateTokenizedStringList87_P, 'CreateTokenizedStringList1', cdRegister);

 S.RegisterDelphiFunction(@HiperbolicTangent, 'HiperbolicTangent', cdRegister);
 S.RegisterDelphiFunction(@HiperbolicTangentDerivative, 'HiperbolicTangentDerivative', cdRegister);
 S.RegisterDelphiFunction(@RectifiedLinearUnit, 'RectifiedLinearUnit', cdRegister);
 S.RegisterDelphiFunction(@RectifiedLinearUnitDerivative, 'RectifiedLinearUnitDerivative', cdRegister);
 S.RegisterDelphiFunction(@RectifiedLinearUnitLeaky, 'RectifiedLinearUnitLeaky', cdRegister);
 S.RegisterDelphiFunction(@RectifiedLinearUnitLeakyDerivative, 'RectifiedLinearUnitLeakyDerivative', cdRegister);
 S.RegisterDelphiFunction(@ReLULeakyBound, 'ReLULeakyBound', cdRegister);
 S.RegisterDelphiFunction(@ReLULeakyBoundDerivative, 'ReLULeakyBoundDerivative', cdRegister);
 S.RegisterDelphiFunction(@Sigmoid, 'Sigmoid', cdRegister);
 S.RegisterDelphiFunction(@SigmoidDerivative, 'SigmoidDerivative', cdRegister);
 S.RegisterDelphiFunction(@Identity, 'Identity', cdRegister);
 S.RegisterDelphiFunction(@IdentityDerivative, 'IdentityDerivative', cdRegister);
 S.RegisterDelphiFunction(@SoftmaxDerivative, 'SoftmaxDerivative', cdRegister);
 S.RegisterDelphiFunction(@DiffAct, 'DiffAct', cdRegister);
 S.RegisterDelphiFunction(@DiffActDerivative, 'DiffActDerivative', cdRegister);
 S.RegisterDelphiFunction(@NeuronForceMinMax88_P, 'NeuronForceMinMax88', cdRegister);
 S.RegisterDelphiFunction(@NeuronForceMinMax89_P, 'NeuronForceMinMax89', cdRegister);
 S.RegisterDelphiFunction(@NeuronForceRange, 'NeuronForceRange', cdRegister);
 S.RegisterDelphiFunction(@NeuronForceMinRange, 'NeuronForceMinRange', cdRegister);
 S.RegisterDelphiFunction(@rgb2hsv, 'rgb2hsv', cdRegister);
 S.RegisterDelphiFunction(@hsv2rgb, 'hsv2rgb', cdRegister);
 S.RegisterDelphiFunction(@hue2rgb, 'hue2rgb', cdRegister);
 S.RegisterDelphiFunction(@rgb2hsl, 'rgb2hsl', cdRegister);
 S.RegisterDelphiFunction(@hsl2rgb, 'hsl2rgb', cdRegister);
 S.RegisterDelphiFunction(@lab2rgb, 'lab2rgb', cdRegister);
 S.RegisterDelphiFunction(@rgb2lab, 'rgb2lab', cdRegister);
 S.RegisterDelphiFunction(@RoundAsByte, 'RoundAsByte', cdRegister);
 S.RegisterDelphiFunction(@CompareStringListIntegerAsc, 'CompareStringListIntegerAsc', cdRegister);
 S.RegisterDelphiFunction(@CompareStringListIntegerDesc, 'CompareStringListIntegerDesc', cdRegister);
 S.RegisterDelphiFunction(@CompareNNetVolumeListAsc, 'CompareNNetVolumeListAsc', cdRegister);
 S.RegisterDelphiFunction(@CompareNNetVolumeListDesc, 'CompareNNetVolumeListDesc', cdRegister);
 S.RegisterDelphiFunction(@NeuralFloatToStr, 'NeuralFloatToStr', cdRegister);
 S.RegisterDelphiFunction(@NeuralStrToFloat, 'NeuralStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@TestTNNetVolume, 'TestTNNetVolume', cdRegister);
 S.RegisterDelphiFunction(@TestKMeans, 'TestKMeans', cdRegister);
 S.RegisterDelphiFunction(@TestKMeans2, 'TestKMeans2', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetDictionary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetDictionary) do
  begin
    RegisterConstructor(@TNNetDictionary.Create, 'Create');
    RegisterMethod(@TNNetDictionary.Destroy, 'Free');
    RegisterMethod(@TNNetDictionary.AddWordToDictionary, 'AddWordToDictionary');
    RegisterMethod(@TNNetDictionary.AddWordsToDictionary, 'AddWordsToDictionary');
    RegisterMethod(@TNNetDictionary.WordToIndex, 'WordToIndex');
    RegisterMethod(@TNNetDictionary.StringToVolume, 'StringToVolume');
    RegisterMethod(@TNNetDictionary.VolumeToString, 'VolumeToString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringListInt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringListInt) do
  begin
    RegisterConstructor(@TStringListInt.Create, 'Create');
    RegisterMethod(@TStringListInt.SortByIntegerAsc, 'SortByIntegerAsc');
    RegisterMethod(@TStringListInt.SortByIntegerDesc, 'SortByIntegerDesc');
    RegisterMethod(@TStringListInt.AddInteger, 'AddInteger');
    RegisterPropertyHelper(@TStringListIntIntegers_R,@TStringListIntIntegers_W,'Integers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetStringList) do
  begin
    RegisterMethod(@TNNetStringList.GetRandomIndex, 'GetRandomIndex');
    RegisterMethod(@TNNetStringList.DeleteFirst, 'DeleteFirst');
    RegisterMethod(@TNNetStringList.DeleteLast, 'DeleteLast');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetKMeans(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetKMeans) do
  begin
    RegisterConstructor(@TNNetKMeans.Create, 'Create');
    RegisterMethod(@TNNetKMeans.Destroy, 'Free');
    RegisterMethod(@TNNetKMeans.RunStep, 'RunStep');
    RegisterMethod(@TNNetKMeans.Resize, 'Resize');
    RegisterMethod(@TNNetKMeans.Randomize, 'Randomize');
    RegisterMethod(@TNNetKMeans.RandomizeEmptyClusters, 'RandomizeEmptyClusters');
    RegisterMethod(@TNNetKMeans.AddSample, 'AddSample');
    RegisterMethod(@TNNetKMeans.GetClusterId, 'GetClusterId');
    RegisterMethod(@TNNetKMeans.GetTotalSize, 'GetTotalSize');
    RegisterPropertyHelper(@TNNetKMeansSample_R,nil,'Sample');
    RegisterPropertyHelper(@TNNetKMeansClusters_R,nil,'Clusters');
    RegisterPropertyHelper(@TNNetKMeansLastStepTime_R,nil,'LastStepTime');
    RegisterPropertyHelper(@TNNetKMeansLastDistance_R,nil,'LastDistance');
    RegisterPropertyHelper(@TNNetKMeansManhattanDistance_R,@TNNetKMeansManhattanDistance_W,'ManhattanDistance');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetVolumePairList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetVolumePairList) do
  begin
    RegisterPropertyHelper(@TNNetVolumePairListItems_R,@TNNetVolumePairListItems_W,'Items');
    RegisterMethod(@TNNetVolumePairList.addnetvolumepair, 'add');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetVolumeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetVolumeList) do
  begin
    RegisterMethod(@TNNetVolumeList.GetTotalSize, 'GetTotalSize');
    RegisterMethod(@TNNetVolumeList.GetSum, 'GetSum');
    RegisterMethod(@TNNetVolumeList.GetAvg, 'GetAvg');
    RegisterMethod(@TNNetVolumeList.GetClosestId, 'GetClosestId');
    RegisterMethod(@TNNetVolumeList.GetManhattanClosestId, 'GetManhattanClosestId');
    RegisterMethod(@TNNetVolumeList.Fill, 'Fill');
    RegisterMethod(@TNNetVolumeList.ClearTag, 'ClearTag');
    RegisterMethod(@TNNetVolumeList.ConcatInto, 'ConcatInto');
    RegisterMethod(@TNNetVolumeList.InterleaveInto, 'InterleaveInto');
    RegisterMethod(@TNNetVolumeList.SplitFrom, 'SplitFrom');
    RegisterMethod(@TNNetVolumeListAddVolumes84_P, 'AddVolumes');   //alias
    RegisterMethod(@TNNetVolumeListAddVolumes84_P, 'AddVolumes84');
    RegisterMethod(@TNNetVolumeListAddVolumes85_P, 'AddVolumes85');
    RegisterMethod(@TNNetVolumeList.AddCopy, 'AddCopy');
    RegisterMethod(@TNNetVolumeList.AddInto, 'AddInto');
    RegisterMethod(@TNNetVolumeList.SortByTagAsc, 'SortByTagAsc');
    RegisterMethod(@TNNetVolumeList.SortByTagDesc, 'SortByTagDesc');
    RegisterMethod(@TNNetVolumeList.GetColumn, 'GetColumn');
    RegisterMethod(@TNNetVolumeList.ResizeImage, 'ResizeImage');
    RegisterMethod(@TNNetVolumeList.addnetvolume, 'addnetvolume');
    RegisterMethod(@TNNetVolumeList.addnetvolume, 'add');
    RegisterPropertyHelper(@TNNetVolumeListItems_R,@TNNetVolumeListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMObject) do
  begin
    RegisterConstructor(@TMObject.Create, 'Create');
    RegisterMethod(@TMObject.Destroy, 'Free');
    RegisterMethod(@TMObject.DefaultMessageProc, 'DefaultMessageProc');
    RegisterMethod(@TMObject.DefaultErrorProc, 'DefaultErrorProc');
    RegisterMethod(@TMObject.DefaultHideMessages, 'DefaultHideMessages');
    RegisterMethod(@TMObject.HideMessages, 'HideMessages');
    RegisterPropertyHelper(@TMObjectMessageProc_R,@TMObjectMessageProc_W,'MessageProc');
    RegisterPropertyHelper(@TMObjectErrorProc_R,@TMObjectErrorProc_W,'ErrorProc');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetVolumePair(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetVolumePair) do
  begin
   RegisterConstructor(@TNNetVolumePairCreate81_P, 'Create');   //alias
    RegisterConstructor(@TNNetVolumePairCreate81_P, 'Create81');
    RegisterConstructor(@TNNetVolumePairCreate82_P, 'Create82');
    RegisterConstructor(@TNNetVolumePairCreateCopying83_P, 'CreateCopying83');
    RegisterMethod(@TNNetVolumePair.Destroy, 'Free');
    RegisterPropertyHelper(@TNNetVolumePairA_R,nil,'A');
    RegisterPropertyHelper(@TNNetVolumePairB_R,nil,'B');
    RegisterPropertyHelper(@TNNetVolumePairI_R,nil,'I');
    RegisterPropertyHelper(@TNNetVolumePairO_R,nil,'O');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetVolume(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetVolume) do begin
    RegisterMethod(@TNNetVolume.GetMemSize, 'GetMemSize');
    RegisterMethod(@TNNetVolume.Resize, 'Resize');
    RegisterMethod(@TNNetVolume.CalculateLocalResponseFrom2D, 'CalculateLocalResponseFrom2D');
    RegisterMethod(@TNNetVolume.CalculateLocalResponseFromDepth, 'CalculateLocalResponseFromDepth');
    RegisterMethod(@TNNetVolumeInterleavedDotProduct59_P, 'InterleavedDotProduct59');
    RegisterMethod(@TNNetVolumeInterleavedDotProduct60_P, 'InterleavedDotProduct60');
    RegisterMethod(@TNNetVolume.DotProducts, 'DotProducts');
    RegisterMethod(@TNNetVolume.AddArea, 'AddArea');
    RegisterMethod(@TNNetVolume.HasAVX, 'HasAVX');
    RegisterMethod(@TNNetVolume.HasAVX2, 'HasAVX2');
    RegisterMethod(@TNNetVolume.HasAVX512, 'HasAVX512');
    RegisterMethod(@TNNetVolume.PearsonCorrelation, 'PearsonCorrelation');
    RegisterMethod(@TNNetVolume.AddSumChannel, 'AddSumChannel');
    RegisterMethod(@TNNetVolume.AddSumSqrChannel, 'AddSumSqrChannel');
    RegisterMethod(@TNNetVolume.AddToChannels, 'AddToChannels');
    RegisterMethod(@TNNetVolume.MulChannels, 'MulChannels');
    RegisterMethod(@TNNetVolumeMul61_P, 'Mul61');
    RegisterMethod(@TNNetVolume.NormalizeMax, 'NormalizeMax');
    RegisterMethod(@TNNetVolume.RecurrencePlot, 'RecurrencePlot');
    RegisterMethod(@TNNetVolume.RecurrencePlotCAI, 'RecurrencePlotCAI');
    RegisterMethod(@TNNetVolume.Fill, 'Fill');
    RegisterMethod(@TNNetVolumeAdd62_P, 'Add');   //alias
    RegisterMethod(@TNNetVolumeAdd62_P, 'Add62');
    RegisterMethod(@TNNetVolumeAdd63_P, 'Add63');
    RegisterMethod(@TNNetVolumeSub64_P, 'Sub64');
    RegisterMethod(@TNNetVolumeDotProduct65_P, 'DotProduct65');
    RegisterMethod(@TNNetVolumeDotProduct66_P, 'DotProduct66');
    RegisterMethod(@TNNetVolumeMul67_P, 'Mul67');
    RegisterMethod(@TNNetVolumeMul68_P, 'Mul68');
    RegisterMethod(@TNNetVolumeMulAdd69_P, 'MulAdd69');
    RegisterMethod(@TNNetVolumeMulAdd70_P, 'MulAdd70');
    RegisterMethod(@TNNetVolumeMulMulAdd71_P, 'MulMulAdd71');
    RegisterMethod(@TNNetVolumeMulAdd72_P, 'MulAdd72');
    RegisterMethod(@TNNetVolumeMulAdd73_P, 'MulAdd73');
    RegisterMethod(@TNNetVolumeMulAdd74_P, 'MulAdd74');
    RegisterMethod(@TNNetVolumeDivi75_P, 'Divi75');
    RegisterMethod(@TNNetVolumeCopy76_P, 'Copy76');
    RegisterMethod(@TNNetVolumeCopy76_P, 'Copy');       //alias

    RegisterMethod(@TNNetVolumeCopyRelu77_P, 'CopyRelu77');
    RegisterMethod(@TNNetVolume.CopyPadding, 'CopyPadding');
    RegisterMethod(@TNNetVolume.CopyNoChecks, 'CopyNoChecks');
    RegisterMethod(@TNNetVolumeGetDistanceSqr78_P, 'GetDistanceSqr78');
    RegisterMethod(@TNNetVolumeGetDistance79_P, 'GetDistance79');
    RegisterMethod(@TNNetVolumeSumDiff80_P, 'SumDiff80');
    RegisterPropertyHelper(@TNNetVolumeDataPtr_R,nil,'DataPtr');
     RegisterMethod(@TNNetVolume.GetSum, 'GetSum');
    RegisterMethod(@TNNetVolume.GetSumSqr, 'GetSumSqr');

     //function GetSum(): TNeuralFloat; override;
      //function GetSumSqr(): TNeuralFloat; override;

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVolume(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVolume) do
  begin
    RegisterPropertyHelper(@TVolumeFData_R,@TVolumeFData_W,'FData');
    RegisterConstructor(@TVolumeCreate0_P, 'Create0');
    RegisterConstructor(@TVolumeCreate1_P, 'Create1');
    RegisterConstructor(@TVolumeCreate2_P, 'Create2');
    RegisterConstructor(@TVolumeCreate3_P, 'Create3');
    RegisterConstructor(@TVolumeCreate4_P, 'Create4');
    RegisterConstructor(@TVolumeCreateAsBits5_P, 'CreateAsBits5');
    RegisterConstructor(@TVolumeCreate6_P, 'Create6');
    RegisterConstructor(@TVolumeCreate7_P, 'Create7');
    RegisterConstructor(@TVolumeCreate7_P, 'Create');
    RegisterMethod(@TVolume.Destroy, 'Free');
    RegisterMethod(@TVolume.Fill, 'Fill');
    RegisterMethod(@TVolume.FillForIdx, 'FillForIdx');
    RegisterMethod(@TVolume.FillAtDepth, 'FillAtDepth');
    RegisterMethod(@TVolume.FillForDebug, 'FillForDebug');
    RegisterMethod(@TVolumeResize8_P, 'Resize8');
    RegisterMethod(@TVolumeReSize9_P, 'ReSize9');
    RegisterMethod(@TVolumeReSize10_P, 'ReSize10');
    RegisterMethod(@TVolume.Get, 'Get');
    RegisterMethod(@TVolume.GetAsByte, 'GetAsByte');
    RegisterMethod(@TVolume.GetRaw, 'GetRaw');
    RegisterMethod(@TVolume.SetRaw, 'SetRaw');
    RegisterMethod(@TVolume.Store, 'Store');
    RegisterMethod(@TVolumeAdd11_P, 'Add11');
    RegisterMethod(@TVolumeAdd12_P, 'Add12');
    RegisterMethod(@TVolumeAdd13_P, 'Add13');
    RegisterMethod(@TVolumeAdd14_P, 'Add14');
    RegisterMethod(@TVolumeAddAtDepth15_P, 'AddAtDepth15');
    RegisterMethod(@TVolumeAddLayers16_P, 'AddLayers16');
    RegisterMethod(@TVolumeSub17_P, 'Sub17');
    RegisterMethod(@TVolumeSub18_P, 'Sub18');
    RegisterMethod(@TVolumeSub19_P, 'Sub19');
    RegisterMethod(@TVolumeDiff20_P, 'Diff20');
    RegisterMethod(@TVolume.InterleaveWithDepthFrom, 'InterleaveWithDepthFrom');
    RegisterMethod(@TVolume.InterleaveWithXFrom, 'InterleaveWithXFrom');
    RegisterMethod(@TVolume.IncYSize, 'IncYSize');
    RegisterMethod(@TVolume.IncYSizeBytes, 'IncYSizeBytes');
    RegisterMethod(@TVolume.DeInterleaveWithXFrom, 'DeInterleaveWithXFrom');
    RegisterMethod(@TVolume.DeInterleaveWithDepthFrom, 'DeInterleaveWithDepthFrom');
    RegisterMethod(@TVolumeSetMin21_P, 'SetMin21');
    RegisterMethod(@TVolumeSetMax22_P, 'SetMax22');
    RegisterMethod(@TVolumeMul23_P, 'Mul23');
    RegisterMethod(@TVolumeMul24_P, 'Mul24');
    RegisterMethod(@TVolumeMul25_P, 'Mul25');
    RegisterMethod(@TVolumeMul26_P, 'Mul26');
    RegisterMethod(@TVolumeMulAtDepth27_P, 'MulAtDepth27');
    RegisterMethod(@TVolumePow28_P, 'Pow28');
    RegisterMethod(@TVolume.VSqrt, 'VSqrt');
    RegisterMethod(@TVolumeMulAdd29_P, 'MulAdd29');
    RegisterMethod(@TVolumeMulMulAdd30_P, 'MulMulAdd30');
    RegisterMethod(@TVolumeMulAdd31_P, 'MulAdd31');
    RegisterMethod(@TVolumeMulAdd32_P, 'MulAdd32');
    RegisterMethod(@TVolumeMulAdd33_P, 'MulAdd33');
    RegisterMethod(@TVolumeMulAdd34_P, 'MulAdd34');
    RegisterMethod(@TVolumeDivi35_P, 'Divi35');
    RegisterMethod(@TVolumeDivi36_P, 'Divi36');
    RegisterMethod(@TVolumeDivi37_P, 'Divi37');
    RegisterMethod(@TVolume.ForceMinRange, 'ForceMinRange');
    RegisterMethod(@TVolume.ForceMaxRange, 'ForceMaxRange');
    RegisterMethod(@TVolume.Randomize, 'Randomize');
    RegisterMethod(@TVolume.RandomizeGaussian, 'RandomizeGaussian');
    RegisterMethod(@TVolume.AddGaussianNoise, 'AddGaussianNoise');
    RegisterMethod(@TVolume.AddSaltAndPepper, 'AddSaltAndPepper');
    RegisterMethod(@TVolume.RandomGaussianValue, 'RandomGaussianValue');
    RegisterMethod(@TVolumeCopy38_P, 'Copy38');
    RegisterMethod(@TVolumeCopyRelu39_P, 'CopyRelu39');
    RegisterMethod(@TVolumeCopy40_P, 'Copy40');
    RegisterMethod(@TVolumeCopy41_P, 'Copy41');
    RegisterMethod(@TVolumeCopy42_P, 'Copy42');
    RegisterMethod(@TVolumeCopy43_P, 'Copy43');
    RegisterMethod(@TVolume.CopyPadding, 'CopyPadding');
    RegisterMethod(@TVolume.CopyCropping, 'CopyCropping');
    RegisterMethod(@TVolume.CopyResizing, 'CopyResizing');
    RegisterMethod(@TVolume.CopyNoChecks, 'CopyNoChecks');
    RegisterMethod(@TVolume.CopyChannels, 'CopyChannels');
    RegisterMethod(@TVolume.Define, 'Define');
    RegisterMethod(@TVolumeDotProduct44_P, 'DotProduct44');
    RegisterMethod(@TVolumeDotProduct45_P, 'DotProduct45');
    RegisterMethod(@TVolume.SumDiff, 'SumDiff');
    RegisterMethod(@TVolume.SumToPos, 'SumToPos');
    RegisterMethod(@TVolumeGetDistanceSqr46_P, 'GetDistanceSqr46');
    RegisterMethod(@TVolumeGetDistance47_P, 'GetDistance47');
    RegisterMethod(@TVolume.SumAtDepth, 'SumAtDepth');
    RegisterMethod(@TVolume.AvgAtDepth, 'AvgAtDepth');
    RegisterMethod(@TVolumeGetRawPos48_P, 'GetRawPos48');
    RegisterMethod(@TVolumeGetRawPos49_P, 'GetRawPos49');
    RegisterMethod(@TVolumeGetRawPtr50_P, 'GetRawPtr50');
    RegisterMethod(@TVolumeGetRawPtr51_P, 'GetRawPtr51');
    RegisterMethod(@TVolumeGetRawPtr52_P, 'GetRawPtr52');
    //RegisterMethod(@TVolumeGetRawPtr53_P, 'GetRawPtr53');
    RegisterMethod(@TVolume.GetMin, 'GetMin');
    RegisterMethod(@TVolume.GetMax, 'GetMax');
    RegisterMethod(@TVolume.GetNonZero, 'GetNonZero');
    RegisterMethod(@TVolume.GetMaxAbs, 'GetMaxAbs');
    RegisterMethod(@TVolume.GetMinMaxAtDepth, 'GetMinMaxAtDepth');
    RegisterMethod(@TVolume.GetSum, 'GetSum');
    RegisterMethod(@TVolume.GetSumAbs, 'GetSumAbs');
    RegisterMethod(@TVolume.GetSumSqr, 'GetSumSqr');
    RegisterMethod(@TVolume.GetAvg, 'GetAvg');
    RegisterMethod(@TVolume.GetVariance, 'GetVariance');
    RegisterMethod(@TVolume.GetStdDeviation, 'GetStdDeviation');
    RegisterMethod(@TVolume.GetSmallestIdxInRange, 'GetSmallestIdxInRange');
    RegisterMethod(@TVolume.GetValueCount, 'GetValueCount');

    RegisterMethod(@TVolume.GetMagnitude, 'GetMagnitude');
    RegisterMethod(@TVolume.FlipX, 'FlipX');
    RegisterMethod(@TVolume.FlipY, 'FlipY');
    RegisterMethod(@TVolume.IncTag, 'IncTag');
    RegisterMethod(@TVolume.ClearTag, 'ClearTag');
    RegisterMethod(@TVolume.NeuralToStr, 'NeuralToStr');
    RegisterMethod(@TVolume.RgbImgToNeuronalInput, 'RgbImgToNeuronalInput');
    RegisterMethod(@TVolume.NeuronalInputToRgbImg, 'NeuronalInputToRgbImg');
    RegisterMethod(@TVolumeNeuronalWeightToImg54_P, 'NeuronalWeightToImg54');
    RegisterMethod(@TVolumeNeuronalWeightToImg55_P, 'NeuronalWeightToImg55');
    RegisterMethod(@TVolume.NeuronalWeightToImg3Channel, 'NeuronalWeightToImg3Channel');
    RegisterMethod(@TVolume.ZeroCenter, 'ZeroCenter');
    RegisterMethod(@TVolume.Print, 'Print');
    RegisterMethod(@TVolume.PrintWithIndex, 'PrintWithIndex');
    RegisterMethod(@TVolume.PrintDebug, 'PrintDebug');
    RegisterMethod(@TVolume.PrintDebugChannel, 'PrintDebugChannel');
    RegisterMethod(@TVolume.InitUniform, 'InitUniform');
    RegisterMethod(@TVolume.InitGaussian, 'InitGaussian');
    RegisterMethod(@TVolume.InitLeCunUniform, 'InitLeCunUniform');
    RegisterMethod(@TVolume.InitHeUniform, 'InitHeUniform');
    RegisterMethod(@TVolume.InitLeCunGaussian, 'InitLeCunGaussian');
    RegisterMethod(@TVolume.InitHeGaussian, 'InitHeGaussian');
    RegisterMethod(@TVolume.InitSELU, 'InitSELU');
    RegisterMethod(@TVolume.SaveToString, 'SaveToString');
    RegisterMethod(@TVolume.LoadFromString, 'LoadFromString');
    RegisterMethod(@TVolumeCopyAsBits56_P, 'CopyAsBits56');
    RegisterMethod(@TVolume.ReadAsBits, 'ReadAsBits');
    RegisterMethod(@TVolumeSetClass57_P, 'SetClass57');
    RegisterMethod(@TVolumeSetClass58_P, 'SetClass58');
    RegisterMethod(@TVolume.SetClassForHiperbolicTangent, 'SetClassForHiperbolicTangent');
    RegisterMethod(@TVolume.SetClassForReLU, 'SetClassForReLU');
    RegisterMethod(@TVolume.SetClassForSoftMax, 'SetClassForSoftMax');
    RegisterMethod(@TVolume.GetClass, 'GetClass');
    RegisterMethod(@TVolume.SoftMax, 'SoftMax');
    RegisterMethod(@TVolume.RgbToHsv, 'RgbToHsv');
    RegisterMethod(@TVolume.HsvToRgb, 'HsvToRgb');
    RegisterMethod(@TVolume.RgbToHsl, 'RgbToHsl');
    RegisterMethod(@TVolume.HslToRgb, 'HslToRgb');
    RegisterMethod(@TVolume.RgbToLab, 'RgbToLab');
    RegisterMethod(@TVolume.LabToRgb, 'LabToRgb');
    RegisterMethod(@TVolume.RgbToGray, 'RgbToGray');
    RegisterMethod(@TVolume.GetGrayFromRgb, 'GetGrayFromRgb');
    RegisterMethod(@TVolume.MakeGray, 'MakeGray');
    RegisterMethod(@TVolume.ShiftRight, 'ShiftRight');
    RegisterMethod(@TVolume.ShiftLeft, 'ShiftLeft');
    RegisterPropertyHelper(@TVolumeData_R,@TVolumeData_W,'Data');
    RegisterPropertyHelper(@TVolumeAsByte_R,nil,'AsByte');
    RegisterPropertyHelper(@TVolumeRaw_R,@TVolumeRaw_W,'Raw');
    RegisterPropertyHelper(@TVolumeTag_R,@TVolumeTag_W,'Tag');
    RegisterPropertyHelper(@TVolumeTags_R,@TVolumeTags_W,'Tags');
    RegisterPropertyHelper(@TVolumeSize_R,nil,'Size');
    RegisterPropertyHelper(@TVolumeSizeX_R,nil,'SizeX');
    RegisterPropertyHelper(@TVolumeSizeY_R,nil,'SizeY');
    RegisterPropertyHelper(@TVolumeDepth_R,nil,'Depth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNNetList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNNetList) do begin
    RegisterPropertyHelper(@TNNetListFreeObjects_R,@TNNetListFreeObjects_W,'FreeObjects');
    RegisterMethod(@TNNetList.Count, 'Count');
     RegisterMethod(@TNNetList.Capacity, 'Capacity');
    RegisterMethod(@addnet, 'addnet');
    RegisterConstructor(@TNNetList.Create, 'Create');
    RegisterMethod(@TNNetList.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralvolume(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNNetList(CL);
  RIRegister_TVolume(CL);
  RIRegister_TNNetVolume(CL);
  RIRegister_TNNetVolumePair(CL);
  RIRegister_TMObject(CL);
  RIRegister_TNNetVolumeList(CL);
  RIRegister_TNNetVolumePairList(CL);
  RIRegister_TNNetKMeans(CL);
  RIRegister_TNNetStringList(CL);
  RIRegister_TStringListInt(CL);
  RIRegister_TNNetDictionary(CL);
end;

 
 
{ TPSImport_neuralvolume }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralvolume.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralvolume(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralvolume.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralvolume(ri);
  RIRegister_neuralvolume_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
