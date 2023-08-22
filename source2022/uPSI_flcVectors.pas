unit uPSI_flcVectors;
{
   myvect   on oct2021   with extended array   and TIn64Array class
   retyped type  TInt64Array = TInt64ArrayClass; 
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
  TPSImport_flcVectors = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TExtendedArray(CL: TPSPascalCompiler);
procedure SIRegister_AExtendedArray(CL: TPSPascalCompiler);
procedure SIRegister_AInt64Array(CL: TPSPascalCompiler);
procedure SIRegister_TInt64ArrayClass(CL: TPSPascalCompiler);
procedure SIRegister_TVectorClass(CL: TPSPascalCompiler);
procedure SIRegister_AArray(CL: TPSPascalCompiler);
procedure SIRegister_AType(CL: TPSPascalCompiler);
procedure SIRegister_flcVectors(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcVectors_Routines(S: TPSExec);
procedure RIRegister_TExtendedArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_AExtendedArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_AInt64Array(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInt64ArrayClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVectorClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_AArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_AType(CL: TPSRuntimeClassImporter);
procedure RIRegister_flcVectors(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcFloats
  ,flcMaths
  //,flcDataStructs
  ,flcVectors
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcVectors]);
end;

(*

{                                                                              }
{ TExtendedArray                                                               }
{   AExtendedArray implemented using a dynamic array.                          }
{                                                                              }
type
  TExtendedArray = class(AExtendedArray)
  protected
    FData     : ExtendedArray;
    FCapacity : Integer;
    FCount    : Integer;

    { ACollection                                                              }
   function  GetCount: Integer; override;
    procedure SetCount(const NewCount: Integer); override;

    { AExtendedArray                                                            }
    function  GetItem(const Idx: Integer): Extended; override;
    procedure SetItem(const Idx: Integer; const Value: Extended); override;
    function  GetRange(const LoIdx, HiIdx: Integer): ExtendedArray; override;
    //function  GetRange(const LoIdx, HiIdx: Integer): ExtendedArray;

    procedure SetRange(const LoIdx, HiIdx: Integer; const V: ExtendedArray); override;
    procedure SetData(const AData: ExtendedArray); virtual;

  public
    constructor Create(const V: ExtendedArray = nil); //overload;

    { AType                                                                    }
    procedure Assign(const Source: TObject); overload; //override;

    { AArray                                                                   }
    procedure ExchangeItems(const Idx1, Idx2: Integer); //override;
    function  DuplicateRange(const LoIdx, HiIdx: Integer): AArray; //override;
    procedure Delete(const Idx: Integer; const ACount: Integer = 1); //override;
    procedure Insert(const Idx: Integer; const ACount: Integer = 1); //override;

    { AExtendedArray                                                            }
    procedure Assign(const V: ExtendedArray); //overload;
    procedure Assign(const V: Array of Extended); //overload;
    function  AppendItem(const Value: Extended): Integer; //override;

    { TExtendedArray                                                            }
    property  Data: ExtendedArray read FData write SetData;
    property  Count: Integer read FCount write SetCount;
  end;

  *)

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInt64ArrayClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AInt64Array', 'TInt64ArrayClass') do
  with CL.AddClassN(CL.FindClass('AInt64Array'),'TInt64ArrayClass') do
  begin
    RegisterMethod('Constructor Create( const V : Int64Array)');
    RegisterMethod('Procedure ExchangeItems( const Idx1, Idx2 : Integer)');
    RegisterMethod('Function DuplicateRange( const LoIdx, HiIdx : Integer) : AArray');
    RegisterMethod('Procedure Delete( const Idx : Integer; const ACount : Integer)');
    RegisterMethod('Procedure Insert( const Idx : Integer; const ACount : Integer)');
    RegisterMethod('Procedure Assign1( const V : Int64Array);');
    RegisterMethod('Procedure Assign2( const V : array of Int64);');
    RegisterMethod('Function AppendItem( const Value : Int64) : Integer');
    RegisterProperty('Data', 'Int64Array', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AInt64Array(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AArray', 'AInt64Array') do
  with CL.AddClassN(CL.FindClass('AArray'),'AInt64Array') do
  begin
    RegisterProperty('Item', 'Int64 Integer', iptrw);
    SetDefaultPropery('Item');
    RegisterProperty('Range', 'Int64Array Integer Integer', iptrw);
    RegisterMethod('Procedure Fill( const Idx, ACount : Integer; const Value : Int64)');
    RegisterMethod('Function AppendItem( const Value : Int64) : Integer');
    RegisterMethod('Function AppendArray3( const V : Int64Array) : Integer;');
    RegisterMethod('Function PosNext( const Find : Int64; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_AArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AType', 'AArray') do
  with CL.AddClassN(CL.FindClass('AType'),'AArray') do
  begin
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('ItemAsString', 'String Integer', iptrw);
    RegisterMethod('Function CompareItems( const Idx1, Idx2 : Integer) : TCompareResult');
    RegisterMethod('Procedure ExchangeItems( const Idx1, Idx2 : Integer)');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure ReverseOrder');
    RegisterMethod('Procedure RemoveDuplicates( const IsSortedAscending : Boolean)');
    RegisterMethod('Function DuplicateRange( const LoIdx, HiIdx : Integer) : AArray');
    RegisterMethod('Procedure Delete( const Idx : Integer; const ACount : Integer)');
    RegisterMethod('Procedure Insert( const Idx : Integer; const ACount : Integer)');
    RegisterMethod('Function AppendArray1( const V : AArray) : Integer;');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_AType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'AType') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'AType') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function CreateInstance : AType');
    RegisterMethod('Function Duplicate : TObject');
    RegisterMethod('Procedure Assign0( const Source : TObject);');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Function IsEqual( const V : TObject) : Boolean');
    RegisterMethod('Function Compare( const V : TObject) : TCompareResult');
    RegisterMethod('Function HashValue : Word32');
    RegisterProperty('AsString', 'String', iptrw);
    RegisterProperty('AsUTF8String', 'RawByteString', iptrw);
    RegisterProperty('AsUnicodeString', 'UnicodeString', iptrw);
  end;
end;


 (*----------------------------------------------------------------------------*)
procedure SIRegister_TExtendedArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AExtendedArray', 'TExtendedArray') do
  with CL.AddClassN(CL.FindClass('AExtendedArray'),'TExtendedArray') do
  begin
    RegisterMethod('Constructor Create( const V : ExtendedArray)');
    //RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( const Source : TObject);');
    RegisterMethod('Procedure ExchangeItems( const Idx1, Idx2 : Integer)');
    RegisterMethod('Function DuplicateRange( const LoIdx, HiIdx : Integer) : AArray');
    RegisterMethod('Procedure Delete( const Idx : Integer; const ACount : Integer)');
    RegisterMethod('Procedure Insert( const Idx : Integer; const ACount : Integer)');
    RegisterMethod('Procedure Assign2( const V : ExtendedArray)');
    //RegisterMethod('Procedure Assign( const V : array of Extended)');
    RegisterMethod('Function AppendItem( const Value : Extended) : Integer');
    RegisterProperty('Data', 'ExtendedArray', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AExtendedArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'AArray', 'AExtendedArray') do
  with CL.AddClassN(CL.FindClass('AArray'),'AExtendedArray') do begin
    RegisterProperty('Item', 'Extended Integer', iptrw);
    SetDefaultPropery('Item');
    RegisterProperty('Range', 'ExtendedArray Integer Integer', iptrw);
    RegisterMethod('Procedure Fill( const Idx, ACount : Integer; const Value : Extended)');
    RegisterMethod('Function AppendItem( const Value : Extended) : Integer');
    RegisterMethod('Function AppendArray5( const V : ExtendedArray) : Integer;');
    RegisterMethod('Function PosNext( const Find : Extended; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer');
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVectorClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVectorBaseArray', 'TVectorClass') do
  //with CL.AddClassN(CL.FindClass('TVectorBaseArray'),'TVectorClass') do
  with CL.AddClassN(CL.FindClass('TExtendedArray'),'TVectorClass') do
  begin
    RegisterMethod('Function CreateInstance : AType');
    RegisterMethod('Procedure Add( const V : MFloat);');
    RegisterMethod('Procedure Add1( const V : PMFloat; const Count : Integer);');
    RegisterMethod('Procedure Add2( const V : PInt64; const Count : Integer);');
    RegisterMethod('Procedure Add3( const V : MFloatArray);');
    RegisterMethod('Procedure Add4( const V : Int64Array);');
    RegisterMethod('Procedure Add5( const V : TVectorBaseArray);');
    RegisterMethod('Procedure Add6( const V : TInt64ArrayClass);');
    RegisterMethod('Procedure Add7( const V : TObject);');
    RegisterMethod('Procedure Subtract8( const V : MFloat);');
    RegisterMethod('Procedure Subtract9( const V : PMFloat; const Count : Integer);');
    RegisterMethod('Procedure Subtract10( const V : PInt64; const Count : Integer);');
    RegisterMethod('Procedure Subtract11( const V : MFloatArray);');
    RegisterMethod('Procedure Subtract12( const V : Int64Array);');
    RegisterMethod('Procedure Subtract13( const V : TVectorBaseArray);');
    RegisterMethod('Procedure Subtract14( const V : TInt64ArrayClass);');
    RegisterMethod('Procedure Subtract15( const V : TObject);');
    RegisterMethod('Procedure Multiply16( const V : MFloat);');
    RegisterMethod('Procedure Multiply17( const V : PMFloat; const Count : Integer);');
    RegisterMethod('Procedure Multiply18( const V : PInt64; const Count : Integer);');
    RegisterMethod('Procedure Multiply19( const V : MFloatArray);');
    RegisterMethod('Procedure Multiply20( const V : Int64Array);');
    RegisterMethod('Procedure Multiply21( const V : TVectorBaseArray);');
    RegisterMethod('Procedure Multiply22( const V : TInt64ArrayClass);');
    RegisterMethod('Procedure Multiply23( const V : TObject);');
    RegisterMethod('Function DotProduct24( const V : PMFloat; const Count : Integer) : MFloat;');
    RegisterMethod('Function DotProduct25( const V : PInt64; const Count : Integer) : MFloat;');
    RegisterMethod('Function DotProduct26( const V : MFloatArray) : MFloat;');
    RegisterMethod('Function DotProduct27( const V : Int64Array) : MFloat;');
    RegisterMethod('Function DotProduct28( const V : TVectorBaseArray) : MFloat;');
    RegisterMethod('Function DotProduct29( const V : TInt64ArrayClass) : MFloat;');
    RegisterMethod('Function DotProduct30( const V : TObject) : MFloat;');
    RegisterMethod('Function Norm : MFloat');
    RegisterMethod('Function Min : MFloat');
    RegisterMethod('Function Max : MFloat');
    RegisterMethod('Function Range( var Min, Max : MFloat) : MFloat');
    RegisterMethod('Function IsZero( const CompareDelta : MFloat) : Boolean');
    RegisterMethod('Function HasZero( const CompareDelta : MFloat) : Boolean');
    RegisterMethod('Function HasNegative : Boolean');
    RegisterMethod('Procedure Normalize');
    RegisterMethod('Procedure Negate');
    RegisterMethod('Procedure ValuesInvert');
    RegisterMethod('Procedure ValuesSqr');
    RegisterMethod('Procedure ValuesSqrt');
    RegisterMethod('Function Sum : MFloat');
    RegisterMethod('Function SumOfSquares : MFloat');
    RegisterMethod('Procedure SumAndSquares( out Sum, SumOfSquares : MFloat)');
    RegisterMethod('Procedure SumAndCubes( out Sum, SumOfSquares, SumOfCubes : MFloat)');
    RegisterMethod('Procedure SumAndQuads( out Sum, SumOfSquares, SumOfCubes, SumOfQuads : MFloat)');
    RegisterMethod('Function WeightedSum( const Weights : TVectorClass) : MFloat');
    RegisterMethod('Function Mean : MFloat');
    RegisterMethod('Function HarmonicMean : MFloat');
    RegisterMethod('Function GeometricMean : MFloat');
    RegisterMethod('Function Median : MFloat');
    RegisterMethod('Function Mode : MFloat');
    RegisterMethod('Function Variance : MFloat');
    RegisterMethod('Function StdDev( var Mean : MFloat) : MFloat');
    RegisterMethod('Function PopulationVariance : MFloat');
    RegisterMethod('Function PopulationStdDev : MFloat');
    RegisterMethod('Function M1 : MFloat');
    RegisterMethod('Function M2 : MFloat');
    RegisterMethod('Function M3 : MFloat');
    RegisterMethod('Function M4 : MFloat');
    RegisterMethod('Function Skew : MFloat');
    RegisterMethod('Function Kurtosis : MFloat');
    RegisterMethod('Function Product : MFloat');
    RegisterMethod('Function Angle( const V : TVectorClass) : MFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_flcVectors(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('VectorFloatDelta','').SetString( ExtendedCompareDelta);
 //CL.AddConstantN('VectorFloatDelta','').SetString( DoubleCompareDelta);
  //CL.AddTypeS('TVectorBaseArray', 'TExtendedArray');
  //CL.AddTypeS('TVectorBaseArray', 'TDoubleArray');
  CL.AddTypeS('TCompareResult', '( crLesser, crEqual, crGreater, crInvalid, crundefined )');
  CL.AddTypeS('TCompareResultSet', 'set of TCompareResult');
  SIRegister_AType(CL);
  SIRegister_AArray(CL);
  SIRegister_AExtendedArray(CL);
  SIRegister_TExtendedArray(CL);
  CL.AddTypeS('TVectorBaseArray', 'TExtendedArray');
  //CL.AddTypeS('TVectorBaseArray', 'TExtendedArray');
  //CL.AddTypeS('TVectorBaseArray', 'TDoubleArray');
  CL.AddTypeS('TInt64ArrayVect', 'array of Int64');
   CL.AddTypeS('TIntArrayvect', 'TInt64Array');
   SIRegister_AInt64Array(CL);
   SIRegister_TInt64ArrayClass(CL);
  SIRegister_TVectorClass(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVector');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVectorInvalidSize');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVectorInvalidType');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVectorEmpty');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVectorInvalidValue');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVectorDivisionByZero');
 CL.AddDelphiFunction('Procedure TestVectorClass');
 CL.AddDelphiFunction('Procedure TestVectorClassExtended');
 CL.AddDelphiFunction('Function InverseCompareResult( const C : TCompareResult) : TCompareResult');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TVectorClassDotProduct30_P(Self: TVectorClass;  const V : TObject) : MFloat;
Begin Result := Self.DotProduct(V); END;

(*----------------------------------------------------------------------------*)
Function TVectorClassDotProduct29_P(Self: TVectorClass;  const V : TInt64Array) : MFloat;
Begin Result := Self.DotProduct(V); END;

(*----------------------------------------------------------------------------*)
Function TVectorClassDotProduct28_P(Self: TVectorClass;  const V : TVectorBaseArray) : MFloat;
Begin Result := Self.DotProduct(V); END;

(*----------------------------------------------------------------------------*)
Function TVectorClassDotProduct27_P(Self: TVectorClass;  const V : Int64Array) : MFloat;
Begin Result := Self.DotProduct(V); END;

(*----------------------------------------------------------------------------*)
Function TVectorClassDotProduct26_P(Self: TVectorClass;  const V : MFloatArray) : MFloat;
Begin Result := Self.DotProduct(V); END;

(*----------------------------------------------------------------------------*)
Function TVectorClassDotProduct25_P(Self: TVectorClass;  const V : PInt64; const Count : Integer) : MFloat;
Begin Result := Self.DotProduct(V, Count); END;

(*----------------------------------------------------------------------------*)
Function TVectorClassDotProduct24_P(Self: TVectorClass;  const V : PMFloat; const Count : Integer) : MFloat;
Begin Result := Self.DotProduct(V, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply23_P(Self: TVectorClass;  const V : TObject);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply22_P(Self: TVectorClass;  const V : TInt64Array);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply21_P(Self: TVectorClass;  const V : TVectorBaseArray);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply20_P(Self: TVectorClass;  const V : Int64Array);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply19_P(Self: TVectorClass;  const V : MFloatArray);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply18_P(Self: TVectorClass;  const V : PInt64; const Count : Integer);
Begin Self.Multiply(V, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply17_P(Self: TVectorClass;  const V : PMFloat; const Count : Integer);
Begin Self.Multiply(V, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassMultiply16_P(Self: TVectorClass;  const V : MFloat);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract15_P(Self: TVectorClass;  const V : TObject);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract14_P(Self: TVectorClass;  const V : TInt64Array);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract13_P(Self: TVectorClass;  const V : TVectorBaseArray);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract12_P(Self: TVectorClass;  const V : Int64Array);
Begin //Self.Subtract(V);
END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract11_P(Self: TVectorClass;  const V : MFloatArray);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract10_P(Self: TVectorClass;  const V : PInt64; const Count : Integer);
Begin Self.Subtract(V, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract9_P(Self: TVectorClass;  const V : PMFloat; const Count : Integer);
Begin Self.Subtract(V, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassSubtract8_P(Self: TVectorClass;  const V : MFloat);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd7_P(Self: TVectorClass;  const V : TObject);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd6_P(Self: TVectorClass;  const V : TInt64Array);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd5_P(Self: TVectorClass;  const V : TVectorBaseArray);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd4_P(Self: TVectorClass;  const V : Int64Array);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd3_P(Self: TVectorClass;  const V : MFloatArray);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd2_P(Self: TVectorClass;  const V : PInt64; const Count : Integer);
Begin Self.Add(V, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd1_P(Self: TVectorClass;  const V : PMFloat; const Count : Integer);
Begin Self.Add(V, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorClassAdd0_P(Self: TVectorClass;  const V : MFloat);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcVectors_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Test, 'TestVectorClass', cdRegister);
 S.RegisterDelphiFunction(@TestVectorClass4, 'TestVectorClassExtended', cdRegister);
 {with CL.Add(EVector) do
  with CL.Add(EVectorInvalidSize) do
  with CL.Add(EVectorInvalidType) do
  with CL.Add(EVectorEmpty) do
  with CL.Add(EVectorInvalidValue) do
  with CL.Add(EVectorDivisionByZero) do  }
 S.RegisterDelphiFunction(@InverseCompareResult, 'InverseCompareResult', cdRegister);
end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TInt64ArrayClassCount_W(Self: TInt64ArrayClass; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TInt64ArrayClassCount_R(Self: TInt64ArrayClass; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TInt64ArrayClassData_W(Self: TInt64ArrayClass; const T: Int64Array);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TInt64ArrayClassData_R(Self: TInt64ArrayClass; var T: Int64Array);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
Procedure TInt64ArrayClassAssign2_P(Self: TInt64ArrayClass;  const V : array of Int64);
Begin Self.Assign(V); END;

(*----------------------------------------------------------------------------*)
Procedure TInt64ArrayClassAssign1_P(Self: TInt64ArrayClass;  const V : Int64Array);
Begin Self.Assign(V); END;

(*----------------------------------------------------------------------------*)
Procedure TInt64ArrayClassAssign_P(Self: TInt64ArrayClass;  const Source : TObject);
Begin Self.Assign(Source); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInt64ArrayClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInt64ArrayClass) do
  begin
    RegisterConstructor(@TInt64ArrayClass.Create, 'Create');
    RegisterMethod(@TInt64ArrayClass.ExchangeItems, 'ExchangeItems');
    RegisterMethod(@TInt64ArrayClass.DuplicateRange, 'DuplicateRange');
    RegisterMethod(@TInt64ArrayClass.Delete, 'Delete');
    RegisterMethod(@TInt64ArrayClass.Insert, 'Insert');
    RegisterMethod(@TInt64ArrayClassAssign1_P, 'Assign1');
    RegisterMethod(@TInt64ArrayClassAssign2_P, 'Assign2');
    RegisterMethod(@TInt64ArrayClass.AppendItem, 'AppendItem');
    RegisterPropertyHelper(@TInt64ArrayClassData_R,@TInt64ArrayClassData_W,'Data');
    RegisterPropertyHelper(@TInt64ArrayClassCount_R,@TInt64ArrayClassCount_W,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
Function AInt64ArrayAppendArray3_P(Self: AInt64Array;  const V : Int64Array) : Integer;
Begin Result := Self.AppendArray(V); END;

(*----------------------------------------------------------------------------*)
procedure AInt64ArrayRange_W(Self: AInt64Array; const T: Int64Array; const t1: Integer; const t2: Integer);
begin Self.Range[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure AInt64ArrayRange_R(Self: AInt64Array; var T: Int64Array; const t1: Integer; const t2: Integer);
begin T := Self.Range[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure AInt64ArrayItem_W(Self: AInt64Array; const T: Int64; const t1: Integer);
begin Self.Item[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure AInt64ArrayItem_R(Self: AInt64Array; var T: Int64; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
Function AInt64ArrayAppendArray2_P(Self: AInt64Array;  const V : AArray) : Integer;
Begin Result := Self.AppendArray(V); END;


(*----------------------------------------------------------------------------*)
procedure RIRegister_AInt64Array(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(AInt64Array) do
  begin
    RegisterPropertyHelper(@AInt64ArrayItem_R,@AInt64ArrayItem_W,'Item');
    RegisterPropertyHelper(@AInt64ArrayRange_R,@AInt64ArrayRange_W,'Range');
    RegisterVirtualMethod(@AInt64Array.Fill, 'Fill');
    RegisterVirtualMethod(@AInt64Array.AppendItem, 'AppendItem');
    RegisterVirtualMethod(@AInt64ArrayAppendArray3_P, 'AppendArray3');
    RegisterMethod(@AInt64Array.PosNext, 'PosNext');
  end;
end;


(*----------------------------------------------------------------------------*)
Function AArrayAppendArray1_P(Self: AArray;  const V : AArray) : Integer;
Begin Result := Self.AppendArray(V); END;

(*----------------------------------------------------------------------------*)
procedure AArrayItemAsString_W(Self: AArray; const T: String; const t1: Integer);
begin Self.ItemAsString[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure AArrayItemAsString_R(Self: AArray; var T: String; const t1: Integer);
begin T := Self.ItemAsString[t1]; end;

(*----------------------------------------------------------------------------*)
procedure AArrayCount_W(Self: AArray; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure AArrayCount_R(Self: AArray; var T: Integer);
begin T := Self.Count; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_AArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(AArray) do
  begin
    RegisterPropertyHelper(@AArrayCount_R,@AArrayCount_W,'Count');
    RegisterPropertyHelper(@AArrayItemAsString_R,@AArrayItemAsString_W,'ItemAsString');
    //RegisterVirtualAbstractMethod(@AArray, @!.CompareItems, 'CompareItems');
    //RegisterVirtualAbstractMethod(@AArray, @!.ExchangeItems, 'ExchangeItems');
    RegisterVirtualMethod(@AArray.Sort, 'Sort');
    RegisterVirtualMethod(@AArray.ReverseOrder, 'ReverseOrder');
    RegisterVirtualMethod(@AArray.RemoveDuplicates, 'RemoveDuplicates');
    //RegisterVirtualAbstractMethod(@AArray, @!.DuplicateRange, 'DuplicateRange');
    //RegisterVirtualAbstractMethod(@AArray, @!.Delete, 'Delete');
    //RegisterVirtualAbstractMethod(@AArray, @!.Insert, 'Insert');
    //RegisterVirtualAbstractMethod(@AArray, @!.AppendArray1, 'AppendArray1');
  end;
end;


(*----------------------------------------------------------------------------*)
Function AExtendedArrayAppendArray5_P(Self: AExtendedArray;  const V : ExtendedArray) : Integer;
Begin Result := Self.AppendArray(V); END;

(*----------------------------------------------------------------------------*)
procedure AExtendedArrayRange_W(Self: AExtendedArray; const T: ExtendedArray; const t1: Integer; const t2: Integer);
begin Self.Range[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure AExtendedArrayRange_R(Self: AExtendedArray; var T: ExtendedArray; const t1: Integer; const t2: Integer);
begin T := Self.Range[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure AExtendedArrayItem_W(Self: AExtendedArray; const T: Extended; const t1: Integer);
begin Self.Item[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure AExtendedArrayItem_R(Self: AExtendedArray; var T: Extended; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
Function AExtendedArrayAppendArray4_P(Self: AExtendedArray;  const V : AArray) : Integer;
Begin Result := Self.AppendArray(V); END;



(*----------------------------------------------------------------------------*)
procedure RIRegister_AExtendedArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(AExtendedArray) do
  begin
    RegisterPropertyHelper(@AExtendedArrayItem_R,@AExtendedArrayItem_W,'Item');
    RegisterPropertyHelper(@AExtendedArrayRange_R,@AExtendedArrayRange_W,'Range');
    RegisterVirtualMethod(@AExtendedArray.Fill, 'Fill');
    RegisterVirtualMethod(@AExtendedArray.AppendItem, 'AppendItem');
    RegisterVirtualMethod(@AExtendedArrayAppendArray5_P, 'AppendArray5');
    RegisterMethod(@AExtendedArray.PosNext, 'PosNext');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TVectorClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVectorClass) do
  begin
    RegisterMethod(@TVectorClass.CreateInstance, 'CreateInstance');
    RegisterMethod(@TVectorClassAdd0_P, 'Add');
    RegisterMethod(@TVectorClassAdd1_P, 'Add1');
    RegisterMethod(@TVectorClassAdd2_P, 'Add2');
    RegisterMethod(@TVectorClassAdd3_P, 'Add3');
    RegisterMethod(@TVectorClassAdd4_P, 'Add4');
    RegisterMethod(@TVectorClassAdd5_P, 'Add5');
    RegisterMethod(@TVectorClassAdd6_P, 'Add6');
    RegisterMethod(@TVectorClassAdd7_P, 'Add7');
    RegisterMethod(@TVectorClassSubtract8_P, 'Subtract8');
    RegisterMethod(@TVectorClassSubtract9_P, 'Subtract9');
    RegisterMethod(@TVectorClassSubtract10_P, 'Subtract10');
    RegisterMethod(@TVectorClassSubtract11_P, 'Subtract11');
    RegisterMethod(@TVectorClassSubtract12_P, 'Subtract12');
    RegisterMethod(@TVectorClassSubtract13_P, 'Subtract13');
    RegisterMethod(@TVectorClassSubtract14_P, 'Subtract14');
    RegisterMethod(@TVectorClassSubtract15_P, 'Subtract15');
    RegisterMethod(@TVectorClassMultiply16_P, 'Multiply16');
    RegisterMethod(@TVectorClassMultiply17_P, 'Multiply17');
    RegisterMethod(@TVectorClassMultiply18_P, 'Multiply18');
    RegisterMethod(@TVectorClassMultiply19_P, 'Multiply19');
    RegisterMethod(@TVectorClassMultiply20_P, 'Multiply20');
    RegisterMethod(@TVectorClassMultiply21_P, 'Multiply21');
    RegisterMethod(@TVectorClassMultiply22_P, 'Multiply22');
    RegisterMethod(@TVectorClassMultiply23_P, 'Multiply23');
    RegisterMethod(@TVectorClassDotProduct24_P, 'DotProduct24');
    RegisterMethod(@TVectorClassDotProduct25_P, 'DotProduct25');
    RegisterMethod(@TVectorClassDotProduct26_P, 'DotProduct26');
    RegisterMethod(@TVectorClassDotProduct27_P, 'DotProduct27');
    RegisterMethod(@TVectorClassDotProduct28_P, 'DotProduct28');
    RegisterMethod(@TVectorClassDotProduct29_P, 'DotProduct29');
    RegisterMethod(@TVectorClassDotProduct30_P, 'DotProduct30');
    RegisterMethod(@TVectorClass.Norm, 'Norm');
    RegisterMethod(@TVectorClass.Min, 'Min');
    RegisterMethod(@TVectorClass.Max, 'Max');
    RegisterMethod(@TVectorClass.Range, 'Range');
    RegisterMethod(@TVectorClass.IsZero, 'IsZero');
    RegisterMethod(@TVectorClass.HasZero, 'HasZero');
    RegisterMethod(@TVectorClass.HasNegative, 'HasNegative');
    RegisterMethod(@TVectorClass.Normalize, 'Normalize');
    RegisterMethod(@TVectorClass.Negate, 'Negate');
    RegisterMethod(@TVectorClass.ValuesInvert, 'ValuesInvert');
    RegisterMethod(@TVectorClass.ValuesSqr, 'ValuesSqr');
    RegisterMethod(@TVectorClass.ValuesSqrt, 'ValuesSqrt');
    RegisterMethod(@TVectorClass.Sum, 'Sum');
    RegisterMethod(@TVectorClass.SumOfSquares, 'SumOfSquares');
    RegisterMethod(@TVectorClass.SumAndSquares, 'SumAndSquares');
    RegisterMethod(@TVectorClass.SumAndCubes, 'SumAndCubes');
    RegisterMethod(@TVectorClass.SumAndQuads, 'SumAndQuads');
    RegisterMethod(@TVectorClass.WeightedSum, 'WeightedSum');
    RegisterMethod(@TVectorClass.Mean, 'Mean');
    RegisterMethod(@TVectorClass.HarmonicMean, 'HarmonicMean');
    RegisterMethod(@TVectorClass.GeometricMean, 'GeometricMean');
    RegisterMethod(@TVectorClass.Median, 'Median');
    RegisterMethod(@TVectorClass.Mode, 'Mode');
    RegisterMethod(@TVectorClass.Variance, 'Variance');
    RegisterMethod(@TVectorClass.StdDev, 'StdDev');
    RegisterMethod(@TVectorClass.PopulationVariance, 'PopulationVariance');
    RegisterMethod(@TVectorClass.PopulationStdDev, 'PopulationStdDev');
    RegisterMethod(@TVectorClass.M1, 'M1');
    RegisterMethod(@TVectorClass.M2, 'M2');
    RegisterMethod(@TVectorClass.M3, 'M3');
    RegisterMethod(@TVectorClass.M4, 'M4');
    RegisterMethod(@TVectorClass.Skew, 'Skew');
    RegisterMethod(@TVectorClass.Kurtosis, 'Kurtosis');
    RegisterMethod(@TVectorClass.Product, 'Product');
    RegisterMethod(@TVectorClass.Angle, 'Angle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TExtendedArrayCount_W(Self: TExtendedArray; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtendedArrayCount_R(Self: TExtendedArray; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TExtendedArrayData_W(Self: TExtendedArray; const T: ExtendedArray);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtendedArrayData_R(Self: TExtendedArray; var T: ExtendedArray);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
Procedure TExtendedArrayAssign6_P(Self: TExtendedArray;  const Source : TObject);
Begin Self.Assign(Source); END;

(*----------------------------------------------------------------------------*)
Procedure TExtendedArrayAssign7_P(Self: TExtendedArray;  const Source : ExtendedArray);
Begin Self.Assign(Source); END;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtendedArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtendedArray) do  begin
    RegisterConstructor(@TExtendedArray.Create, 'Create');
    RegisterMethod(@TExtendedArray.Destroy, 'Free');
    RegisterMethod(@TExtendedArrayAssign6_P, 'Assign');
    RegisterMethod(@TExtendedArray.ExchangeItems, 'ExchangeItems');
    RegisterMethod(@TExtendedArray.DuplicateRange, 'DuplicateRange');
    RegisterMethod(@TExtendedArray.Delete, 'Delete');
    RegisterMethod(@TExtendedArray.Insert, 'Insert');
    RegisterMethod(@TExtendedArrayAssign7_P, 'Assign2');
    //RegisterMethod(@TExtendedArray.Assign, 'Assign');
    RegisterMethod(@TExtendedArray.AppendItem, 'AppendItem');
    RegisterPropertyHelper(@TExtendedArrayData_R,@TExtendedArrayData_W,'Data');
    RegisterPropertyHelper(@TExtendedArrayCount_R,@TExtendedArrayCount_W,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure ATypeAsUnicodeString_W(Self: AType; const T: UnicodeString);
begin Self.AsUnicodeString := T; end;

(*----------------------------------------------------------------------------*)
procedure ATypeAsUnicodeString_R(Self: AType; var T: UnicodeString);
begin T := Self.AsUnicodeString; end;

(*----------------------------------------------------------------------------*)
procedure ATypeAsUTF8String_W(Self: AType; const T: RawByteString);
begin Self.AsUTF8String := T; end;

(*----------------------------------------------------------------------------*)
procedure ATypeAsUTF8String_R(Self: AType; var T: RawByteString);
begin T := Self.AsUTF8String; end;

(*----------------------------------------------------------------------------*)
procedure ATypeAsString_W(Self: AType; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure ATypeAsString_R(Self: AType; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
Procedure ATypeAssign0_P(Self: AType;  const Source : TObject);
Begin Self.Assign(Source); END;



(*----------------------------------------------------------------------------*)
procedure RIRegister_AType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(AType) do
  begin
    RegisterConstructor(@AType.Create, 'Create');
    RegisterVirtualMethod(@AType.CreateInstance, 'CreateInstance');
    RegisterVirtualMethod(@AType.Duplicate, 'Duplicate');
    RegisterVirtualMethod(@ATypeAssign0_P, 'Assign0');
    RegisterVirtualMethod(@AType.Clear, 'Clear');
    RegisterVirtualMethod(@AType.IsEmpty, 'IsEmpty');
    RegisterVirtualMethod(@AType.IsEqual, 'IsEqual');
    RegisterVirtualMethod(@AType.Compare, 'Compare');
    RegisterVirtualMethod(@AType.HashValue, 'HashValue');
    RegisterPropertyHelper(@ATypeAsString_R,@ATypeAsString_W,'AsString');
    RegisterPropertyHelper(@ATypeAsUTF8String_R,@ATypeAsUTF8String_W,'AsUTF8String');
    RegisterPropertyHelper(@ATypeAsUnicodeString_R,@ATypeAsUnicodeString_W,'AsUnicodeString');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_flcVectors(CL: TPSRuntimeClassImporter);
begin
  RIRegister_AType(CL);
  RIRegister_AArray(CL);
  with CL.Add(EArray) do
  RIRegister_AInt64Array(CL);
  //with CL.Add(EInt64Array) do
  //RIRegister_AInt64Array(CL);
  with CL.Add(EInt64Array) do
  RIRegister_AExtendedArray(CL);
  with CL.Add(EExtendedArray) do //}
  RIRegister_TInt64ArrayClass(CL);
  RIRegister_TExtendedArray(CL);
  RIRegister_TVectorClass(CL);
  with CL.Add(EVector) do
  with CL.Add(EVectorInvalidSize) do
  with CL.Add(EVectorInvalidType) do
  with CL.Add(EVectorEmpty) do
  with CL.Add(EVectorInvalidValue) do
  with CL.Add(EVectorDivisionByZero) do
end;

 
 
{ TPSImport_flcVectors }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcVectors.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcVectors(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcVectors.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcVectors(ri);
  RIRegister_flcVectors_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
