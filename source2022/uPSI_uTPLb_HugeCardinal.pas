unit uPSI_uTPLb_HugeCardinal;
{
   TurboPower Crypto   add free
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
  TPSImport_uTPLb_HugeCardinal = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THugeCardinal(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_HugeCardinal(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THugeCardinal(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_HugeCardinal(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_IntegerUtils
  ,uTPLb_MemoryStreamPool
  ,uTPLb_HugeCardinal
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_HugeCardinal]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THugeCardinal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THugeCardinal') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THugeCardinal') do begin
    RegisterProperty('FValue', 'TMemoryStream', iptrw);
    RegisterProperty('FPool', 'TMemoryStreamPool', iptrw);
    RegisterMethod('Constructor CreateSimple( Value : uint64)');
    RegisterMethod('Constructor CreateZero( MaxBits1 : integer; Pool1 : TMemoryStreamPool)');
    RegisterMethod('Constructor CreateRandom( Bits1, MaxBits1 : integer; ExactBitLength : boolean; Pool1 : TMemoryStreamPool)');
    RegisterMethod('Constructor CreateSmall( Value : uint64; MaxBits1 : integer; Pool1 : TMemoryStreamPool)');
    RegisterMethod('Constructor CreateAsClone( Master : THugeCardinal; Pool1 : TMemoryStreamPool)');
    RegisterMethod('Constructor CreateAsSizedClone( MaxBits1 : integer; Master : THugeCardinal; Pool1 : TMemoryStreamPool)');
    RegisterMethod('Constructor CreateFromStreamIn( MaxBits1 : integer; ByteOrder : TByteOrder; Stream : TStream; Pool1 : TMemoryStreamPool)');
    RegisterMethod('Function Clone : THugeCardinal');
    RegisterMethod('Function CloneSized( MaxBits1 : integer) : THugeCardinal');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Resize( NewMaxBit1 : integer)');
    RegisterMethod('Procedure Burn');
    RegisterMethod('Function BitLength : integer');
    RegisterMethod('Function MaxBits : integer');
    RegisterMethod('Function CapacityInBits : integer');
    RegisterMethod('Procedure Assign( Source : THugeCardinal)');
    RegisterMethod('Procedure AssignFromStreamIn( ByteOrder : TByteOrder; Stream : TStream)');
    RegisterMethod('Procedure AssignSmall( Value : uint64)');
    RegisterMethod('Procedure Swap( Peer : THugeCardinal)');
    RegisterMethod('Procedure Random( UpperBound : THugeCardinal)');
    RegisterMethod('Procedure RandomBits( BitsOfRandom : integer; ExactBitLength : boolean)');
    RegisterMethod('Function Compare( Reference : THugeCardinal) : TCompareResult');
    RegisterMethod('Function CompareSmall( Reference : uint64) : TCompareResult');
    RegisterMethod('Function isZero : boolean');
    RegisterMethod('Function isOdd : boolean');
    RegisterMethod('Procedure Zeroise');
    RegisterMethod('Function isSmall : boolean');
    RegisterMethod('Function ExtractSmall : uint64');
    RegisterMethod('Function ModSmall( Modulus : uint64) : uint64');
    RegisterMethod('Procedure Add( Addend : THugeCardinal)');
    RegisterMethod('Procedure Increment( Addend : int64)');
    RegisterMethod('Procedure Subtract( Subtractend : THugeCardinal)');
    RegisterMethod('Procedure AddMod( Addend, Modulus : THugeCardinal)');
    RegisterMethod('Procedure MulSmall( Factor : uint32)');
    RegisterMethod('Function Multiply( Factor : THugeCardinal) : THugeCardinal');
    RegisterMethod('Procedure MultiplyMod( Factor, Modulus : THugeCardinal)');
    RegisterMethod('Procedure SquareMod( Modulus : THugeCardinal)');
    RegisterMethod('Procedure MulPower2( ShiftAmnt : integer)');
    RegisterMethod('Function Modulo( Modulus : THugeCardinal) : THugeCardinal');
    RegisterMethod('Procedure Divide( Divisor : THugeCardinal; var Quotient, Remainder : THugeCardinal)');
    RegisterMethod('Function PowerMod( Exponent, Modulus : THugeCardinal; OnProgress : TProgress) : boolean');
    RegisterMethod('Procedure SmallExponent_PowerMod( Exponent : uint64; Modulus : THugeCardinal)');
    RegisterMethod('Procedure SmallExponent_Power( Exponent : uint32)');
    RegisterMethod('Procedure StreamOut( ByteOrder : TByteOrder; Stream : TStream; SizeToOutput : integer)');
    RegisterProperty('AsBase10', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_HugeCardinal(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCompareResult', '( rGreaterThan, rEqualTo, rLessThan )');
  CL.AddTypeS('TByteOrder', '( LittleEndien, BigEndien )');
  CL.AddTypeS('TProgress', 'Procedure ( Sender : TObject; BitsProcessed, TotalBits : int64; var doAbort : boolean)');
  SIRegister_THugeCardinal(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THugeCardinalFPool_W(Self: THugeCardinal; const T: TMemoryStreamPool);
Begin Self.FPool := T; end;

(*----------------------------------------------------------------------------*)
procedure THugeCardinalFPool_R(Self: THugeCardinal; var T: TMemoryStreamPool);
Begin T := Self.FPool; end;

(*----------------------------------------------------------------------------*)
procedure THugeCardinalFValue_W(Self: THugeCardinal; const T: TMemoryStream);
Begin //Self.FValue := T;
 end;

(*----------------------------------------------------------------------------*)
procedure THugeCardinalFValue_R(Self: THugeCardinal; var T: TMemoryStream);
Begin //T := Self.FValue;
end;

procedure THugeCardinal_RAsbase10(Self: THugeCardinal; var T: string);
Begin T := Self.AsBase10; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THugeCardinal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THugeCardinal) do begin
    RegisterPropertyHelper(@THugeCardinalFValue_R,@THugeCardinalFValue_W,'FValue');
    RegisterPropertyHelper(@THugeCardinalFPool_R,@THugeCardinalFPool_W,'FPool');
    RegisterConstructor(@THugeCardinal.CreateSimple, 'CreateSimple');
    RegisterConstructor(@THugeCardinal.CreateZero, 'CreateZero');
    RegisterConstructor(@THugeCardinal.CreateRandom, 'CreateRandom');
    RegisterConstructor(@THugeCardinal.CreateSmall, 'CreateSmall');
    RegisterConstructor(@THugeCardinal.CreateAsClone, 'CreateAsClone');
    RegisterConstructor(@THugeCardinal.CreateAsSizedClone, 'CreateAsSizedClone');
    RegisterConstructor(@THugeCardinal.CreateFromStreamIn, 'CreateFromStreamIn');
    RegisterMethod(@THugeCardinal.Destroy, 'Free');
    RegisterMethod(@THugeCardinal.Clone, 'Clone');
    RegisterMethod(@THugeCardinal.CloneSized, 'CloneSized');
    RegisterMethod(@THugeCardinal.Resize, 'Resize');
    RegisterMethod(@THugeCardinal.Burn, 'Burn');
    RegisterMethod(@THugeCardinal.BitLength, 'BitLength');
    RegisterMethod(@THugeCardinal.MaxBits, 'MaxBits');
    RegisterMethod(@THugeCardinal.CapacityInBits, 'CapacityInBits');
    RegisterMethod(@THugeCardinal.Assign, 'Assign');
    RegisterMethod(@THugeCardinal.AssignFromStreamIn, 'AssignFromStreamIn');
    RegisterMethod(@THugeCardinal.AssignSmall, 'AssignSmall');
    RegisterMethod(@THugeCardinal.Swap, 'Swap');
    RegisterMethod(@THugeCardinal.Random, 'Random');
    RegisterMethod(@THugeCardinal.RandomBits, 'RandomBits');
    RegisterMethod(@THugeCardinal.Compare, 'Compare');
    RegisterMethod(@THugeCardinal.CompareSmall, 'CompareSmall');
    RegisterMethod(@THugeCardinal.isZero, 'isZero');
    RegisterMethod(@THugeCardinal.isOdd, 'isOdd');
    RegisterMethod(@THugeCardinal.Zeroise, 'Zeroise');
    RegisterMethod(@THugeCardinal.isSmall, 'isSmall');
    RegisterMethod(@THugeCardinal.ExtractSmall, 'ExtractSmall');
    RegisterMethod(@THugeCardinal.ModSmall, 'ModSmall');
    RegisterMethod(@THugeCardinal.Add, 'Add');
    RegisterMethod(@THugeCardinal.Increment, 'Increment');
    RegisterMethod(@THugeCardinal.Subtract, 'Subtract');
    RegisterMethod(@THugeCardinal.AddMod, 'AddMod');
    RegisterMethod(@THugeCardinal.MulSmall, 'MulSmall');
    RegisterMethod(@THugeCardinal.Multiply, 'Multiply');
    RegisterMethod(@THugeCardinal.MultiplyMod, 'MultiplyMod');
    RegisterMethod(@THugeCardinal.SquareMod, 'SquareMod');
    RegisterMethod(@THugeCardinal.MulPower2, 'MulPower2');
    RegisterMethod(@THugeCardinal.Modulo, 'Modulo');
    RegisterMethod(@THugeCardinal.Divide, 'Divide');
    RegisterMethod(@THugeCardinal.PowerMod, 'PowerMod');
    RegisterMethod(@THugeCardinal.SmallExponent_PowerMod, 'SmallExponent_PowerMod');
    RegisterMethod(@THugeCardinal.SmallExponent_Power, 'SmallExponent_Power');
    RegisterMethod(@THugeCardinal.StreamOut, 'StreamOut');
    RegisterPropertyHelper(@THugeCardinal_RAsbase10,Nil, 'AsBase10');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_HugeCardinal(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THugeCardinal(CL);
end;

 
 
{ TPSImport_uTPLb_HugeCardinal }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HugeCardinal.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_HugeCardinal(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HugeCardinal.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_HugeCardinal(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
