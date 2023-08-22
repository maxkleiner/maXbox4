unit uPSI_JclLogic;
{
 for arduino ATMega MicroController
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
  TPSImport_JclLogic = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclLogic(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclLogic_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JclLogic
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclLogic]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclLogic(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function OrdToBinary( const Value : Byte) : string;');
 CL.AddDelphiFunction('Function OrdToBinary1( const Value : Shortint) : string;');
 CL.AddDelphiFunction('Function OrdToBinary2( const Value : Smallint) : string;');
 CL.AddDelphiFunction('Function OrdToBinary3( const Value : Word) : string;');
 CL.AddDelphiFunction('Function OrdToBinary4( const Value : Integer) : string;');
 CL.AddDelphiFunction('Function OrdToBinary5( const Value : Cardinal) : string;');
 CL.AddDelphiFunction('Function OrdToBinary6( const Value : Int64) : string;');
  CL.AddTypeS('TBitRange', 'Byte');
  CL.AddTypeS('TBooleanArray', 'array of Boolean');
 CL.AddDelphiFunction('Function BitsHighest( X : Byte) : Integer;');
 CL.AddDelphiFunction('Function BitsHighest1( X : ShortInt) : Integer;');
 CL.AddDelphiFunction('Function BitsHighest2( X : SmallInt) : Integer;');
 CL.AddDelphiFunction('Function BitsHighest3( X : Word) : Integer;');
 CL.AddDelphiFunction('Function BitsHighest4( X : Integer) : Integer;');
 CL.AddDelphiFunction('Function BitsHighest5( X : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function BitsHighest6( X : Int64) : Integer;');
 CL.AddDelphiFunction('Function BitsLowest( X : Byte) : Integer;');
 CL.AddDelphiFunction('Function BitsLowest1( X : Shortint) : Integer;');
 CL.AddDelphiFunction('Function BitsLowest2( X : Smallint) : Integer;');
 CL.AddDelphiFunction('Function BitsLowest3( X : Word) : Integer;');
 CL.AddDelphiFunction('Function BitsLowest4( X : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function BitsLowest5( X : Integer) : Integer;');
 CL.AddDelphiFunction('Function BitsLowest6( X : Int64) : Integer;');
 CL.AddDelphiFunction('Function ClearBit( const Value : Byte; const Bit : TBitRange) : Byte;');
 CL.AddDelphiFunction('Function ClearBit1( const Value : Shortint; const Bit : TBitRange) : Shortint;');
 CL.AddDelphiFunction('Function ClearBit2( const Value : Smallint; const Bit : TBitRange) : Smallint;');
 CL.AddDelphiFunction('Function ClearBit3( const Value : Word; const Bit : TBitRange) : Word;');
 CL.AddDelphiFunction('Function ClearBit4( const Value : Integer; const Bit : TBitRange) : Integer;');
 CL.AddDelphiFunction('Function ClearBit5( const Value : Cardinal; const Bit : TBitRange) : Cardinal;');
 CL.AddDelphiFunction('Function ClearBit6( const Value : Int64; const Bit : TBitRange) : Int64;');
 CL.AddDelphiFunction('Function CountBitsSet( X : Byte) : Integer;');
 CL.AddDelphiFunction('Function CountBitsSet1( X : Word) : Integer;');
 CL.AddDelphiFunction('Function CountBitsSet2( X : Smallint) : Integer;');
 CL.AddDelphiFunction('Function CountBitsSet3( X : ShortInt) : Integer;');
 CL.AddDelphiFunction('Function CountBitsSet4( X : Integer) : Integer;');
 CL.AddDelphiFunction('Function CountBitsSet5( X : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function CountBitsSet6( X : Int64) : Integer;');
 CL.AddDelphiFunction('Function CountBitsCleared( X : Byte) : Integer;');
 CL.AddDelphiFunction('Function CountBitsCleared1( X : Shortint) : Integer;');
 CL.AddDelphiFunction('Function CountBitsCleared2( X : Smallint) : Integer;');
 CL.AddDelphiFunction('Function CountBitsCleared3( X : Word) : Integer;');
 CL.AddDelphiFunction('Function CountBitsCleared4( X : Integer) : Integer;');
 CL.AddDelphiFunction('Function CountBitsCleared5( X : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function CountBitsCleared6( X : Int64) : Integer;');
 CL.AddDelphiFunction('Function LRot( const Value : Byte; const Count : TBitRange) : Byte;');
 CL.AddDelphiFunction('Function LRot1( const Value : Word; const Count : TBitRange) : Word;');
 CL.AddDelphiFunction('Function LRot2( const Value : Integer; const Count : TBitRange) : Integer;');
 CL.AddDelphiFunction('Function ReverseBits( Value : Byte) : Byte;');
 CL.AddDelphiFunction('Function ReverseBits1( Value : Shortint) : Shortint;');
 CL.AddDelphiFunction('Function ReverseBits2( Value : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function ReverseBits3( Value : Word) : Word;');
 CL.AddDelphiFunction('Function ReverseBits4( Value : Integer) : Integer;');
 CL.AddDelphiFunction('Function ReverseBits4( Value : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function ReverseBits5( Value : Int64) : Int64;');
 //CL.AddDelphiFunction('Function ReverseBits6( P : Pointer; Count : Integer) : Pointer;');
 CL.AddDelphiFunction('Function RRot( const Value : Byte; const Count : TBitRange) : Byte;');
 CL.AddDelphiFunction('Function RRot1( const Value : Word; const Count : TBitRange) : Word;');
 CL.AddDelphiFunction('Function RRot2( const Value : Integer; const Count : TBitRange) : Integer;');
 CL.AddDelphiFunction('Function Sar( const Value : Shortint; const Count : TBitRange) : Shortint;');
 CL.AddDelphiFunction('Function Sar1( const Value : Smallint; const Count : TBitRange) : Smallint;');
 CL.AddDelphiFunction('Function Sar2( const Value : Integer; const Count : TBitRange) : Integer;');
 CL.AddDelphiFunction('Function SetBit( const Value : Byte; const Bit : TBitRange) : Byte;');
 CL.AddDelphiFunction('Function SetBit1( const Value : Shortint; const Bit : TBitRange) : Shortint;');
 CL.AddDelphiFunction('Function SetBit2( const Value : Smallint; const Bit : TBitRange) : Smallint;');
 CL.AddDelphiFunction('Function SetBit3( const Value : Word; const Bit : TBitRange) : Word;');
 CL.AddDelphiFunction('Function SetBit4( const Value : Cardinal; const Bit : TBitRange) : Cardinal;');
 CL.AddDelphiFunction('Function SetBit4( const Value : Integer; const Bit : TBitRange) : Integer;');
 CL.AddDelphiFunction('Function SetBit5( const Value : Int64; const Bit : TBitRange) : Int64;');
 CL.AddDelphiFunction('Function TestBit( const Value : Byte; const Bit : TBitRange) : Boolean;');
 CL.AddDelphiFunction('Function TestBit2( const Value : Shortint; const Bit : TBitRange) : Boolean;');
 CL.AddDelphiFunction('Function TestBit3( const Value : Smallint; const Bit : TBitRange) : Boolean;');
 CL.AddDelphiFunction('Function TestBit4( const Value : Word; const Bit : TBitRange) : Boolean;');
 CL.AddDelphiFunction('Function TestBit5( const Value : Cardinal; const Bit : TBitRange) : Boolean;');
 CL.AddDelphiFunction('Function TestBit6( const Value : Integer; const Bit : TBitRange) : Boolean;');
 CL.AddDelphiFunction('Function TestBit7( const Value : Int64; const Bit : TBitRange) : Boolean;');
 CL.AddDelphiFunction('Function TestBits( const Value, Mask : Byte) : Boolean;');
 CL.AddDelphiFunction('Function TestBits1( const Value, Mask : Shortint) : Boolean;');
 CL.AddDelphiFunction('Function TestBits2( const Value, Mask : Smallint) : Boolean;');
 CL.AddDelphiFunction('Function TestBits3( const Value, Mask : Word) : Boolean;');
 CL.AddDelphiFunction('Function TestBits4( const Value, Mask : Cardinal) : Boolean;');
 CL.AddDelphiFunction('Function TestBits5( const Value, Mask : Integer) : Boolean;');
 CL.AddDelphiFunction('Function TestBits6( const Value, Mask : Int64) : Boolean;');
 CL.AddDelphiFunction('Function ToggleBit( const Value : Byte; const Bit : TBitRange) : Byte;');
 CL.AddDelphiFunction('Function ToggleBit1( const Value : Shortint; const Bit : TBitRange) : Shortint;');
 CL.AddDelphiFunction('Function ToggleBit2( const Value : Smallint; const Bit : TBitRange) : Smallint;');
 CL.AddDelphiFunction('Function ToggleBit3( const Value : Word; const Bit : TBitRange) : Word;');
 CL.AddDelphiFunction('Function ToggleBit4( const Value : Cardinal; const Bit : TBitRange) : Cardinal;');
 CL.AddDelphiFunction('Function ToggleBit5( const Value : Integer; const Bit : TBitRange) : Integer;');
 CL.AddDelphiFunction('Function ToggleBit6( const Value : Int64; const Bit : TBitRange) : Int64;');
 CL.AddDelphiFunction('Procedure BooleansToBits( var Dest : Byte; const B : TBooleanArray);');
 CL.AddDelphiFunction('Procedure BooleansToBits1( var Dest : Word; const B : TBooleanArray);');
 CL.AddDelphiFunction('Procedure BooleansToBits2( var Dest : Integer; const B : TBooleanArray);');
 CL.AddDelphiFunction('Procedure BooleansToBits3( var Dest : Int64; const B : TBooleanArray);');
 CL.AddDelphiFunction('Procedure BitsToBooleans( const Bits : Byte; var B : TBooleanArray; AllBits : Boolean);');
 CL.AddDelphiFunction('Procedure BitsToBooleans1( const Bits : Word; var B : TBooleanArray; AllBits : Boolean);');
 CL.AddDelphiFunction('Procedure BitsToBooleans2( const Bits : Integer; var B : TBooleanArray; AllBits : Boolean);');
 CL.AddDelphiFunction('Procedure BitsToBooleans3( const Bits : Int64; var B : TBooleanArray; AllBits : Boolean);');
 CL.AddDelphiFunction('Function BitsNeeded( const X : Byte) : Integer;');
 CL.AddDelphiFunction('Function BitsNeeded1( const X : Word) : Integer;');
 CL.AddDelphiFunction('Function BitsNeeded2( const X : Integer) : Integer;');
 CL.AddDelphiFunction('Function BitsNeeded3( const X : Int64) : Integer;');
 CL.AddDelphiFunction('Function Digits( const X : Cardinal) : Integer');
 CL.AddDelphiFunction('Function ReverseBytes( Value : Word) : Word;');
 CL.AddDelphiFunction('Function ReverseBytes1( Value : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function ReverseBytes2( Value : Integer) : Integer;');
 CL.AddDelphiFunction('Function ReverseBytes3( Value : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function ReverseBytes4( Value : Int64) : Int64;');
 //CL.AddDelphiFunction('Function ReverseBytes5( P : Pointer; Count : Integer) : Pointer;');
 CL.AddDelphiFunction('Procedure SwapOrd( var I, J : Byte);');
 CL.AddDelphiFunction('Procedure SwapOrd1( var I, J : Shortint);');
 CL.AddDelphiFunction('Procedure SwapOrd2( var I, J : Smallint);');
 CL.AddDelphiFunction('Procedure SwapOrd3( var I, J : Word);');
 CL.AddDelphiFunction('Procedure SwapOrd4( var I, J : Integer);');
 CL.AddDelphiFunction('Procedure SwapOrd5( var I, J : Cardinal);');
 CL.AddDelphiFunction('Procedure SwapOrd6( var I, J : Int64);');
 CL.AddDelphiFunction('Function IncLimit( var B : Byte; const Limit : Byte; const Incr : Byte) : Byte;');
 CL.AddDelphiFunction('Function IncLimit1( var B : Shortint; const Limit : Shortint; const Incr : Shortint) : Shortint;');
 CL.AddDelphiFunction('Function IncLimit2( var B : Smallint; const Limit : Smallint; const Incr : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function IncLimit3( var B : Word; const Limit : Word; const Incr : Word) : Word;');
 CL.AddDelphiFunction('Function IncLimit4( var B : Integer; const Limit : Integer; const Incr : Integer) : Integer;');
 CL.AddDelphiFunction('Function IncLimit5( var B : Cardinal; const Limit : Cardinal; const Incr : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function IncLimit6( var B : Int64; const Limit : Int64; const Incr : Int64) : Int64;');
 CL.AddDelphiFunction('Function DecLimit( var B : Byte; const Limit : Byte; const Decr : Byte) : Byte;');
 CL.AddDelphiFunction('Function DecLimit1( var B : Shortint; const Limit : Shortint; const Decr : Shortint) : Shortint;');
 CL.AddDelphiFunction('Function DecLimit2( var B : Smallint; const Limit : Smallint; const Decr : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function DecLimit3( var B : Word; const Limit : Word; const Decr : Word) : Word;');
 CL.AddDelphiFunction('Function DecLimit4( var B : Integer; const Limit : Integer; const Decr : Integer) : Integer;');
 CL.AddDelphiFunction('Function DecLimit5( var B : Cardinal; const Limit : Cardinal; const Decr : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function DecLimit6( var B : Int64; const Limit : Int64; const Decr : Int64) : Int64;');
 CL.AddDelphiFunction('Function IncLimitClamp( var B : Byte; const Limit : Byte; const Incr : Byte) : Byte;');
 CL.AddDelphiFunction('Function IncLimitClamp1( var B : Shortint; const Limit : Shortint; const Incr : Shortint) : Shortint;');
 CL.AddDelphiFunction('Function IncLimitClamp2( var B : Smallint; const Limit : Smallint; const Incr : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function IncLimitClamp3( var B : Word; const Limit : Word; const Incr : Word) : Word;');
 CL.AddDelphiFunction('Function IncLimitClamp4( var B : Integer; const Limit : Integer; const Incr : Integer) : Integer;');
 CL.AddDelphiFunction('Function IncLimitClamp5( var B : Cardinal; const Limit : Cardinal; const Incr : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function IncLimitClamp6( var B : Int64; const Limit : Int64; const Incr : Int64) : Int64;');
 CL.AddDelphiFunction('Function DecLimitClamp( var B : Byte; const Limit : Byte; const Decr : Byte) : Byte;');
 CL.AddDelphiFunction('Function DecLimitClamp1( var B : Shortint; const Limit : Shortint; const Decr : Shortint) : Shortint;');
 CL.AddDelphiFunction('Function DecLimitClamp2( var B : Smallint; const Limit : Smallint; const Decr : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function DecLimitClamp3( var B : Word; const Limit : Word; const Decr : Word) : Word;');
 CL.AddDelphiFunction('Function DecLimitClamp4( var B : Integer; const Limit : Integer; const Decr : Integer) : Integer;');
 CL.AddDelphiFunction('Function DecLimitClamp5( var B : Cardinal; const Limit : Cardinal; const Decr : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function DecLimitClamp6( var B : Int64; const Limit : Int64; const Decr : Int64) : Int64;');
 CL.AddDelphiFunction('Function MaxJ( const B1, B2 : Byte) : Byte;');
 CL.AddDelphiFunction('Function Max1( const B1, B2 : Shortint) : Shortint;');
 CL.AddDelphiFunction('Function Max2( const B1, B2 : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function Max3( const B1, B2 : Word) : Word;');
 CL.AddDelphiFunction('Function Max4( const B1, B2 : Integer) : Integer;');
 CL.AddDelphiFunction('Function Max5( const B1, B2 : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function Max6( const B1, B2 : Int64) : Int64;');
 CL.AddDelphiFunction('Function MinJ( const B1, B2 : Byte) : Byte;');
 CL.AddDelphiFunction('Function Min1( const B1, B2 : Shortint) : Shortint;');
 CL.AddDelphiFunction('Function Min2( const B1, B2 : Smallint) : Smallint;');
 CL.AddDelphiFunction('Function Min3( const B1, B2 : Word) : Word;');
 CL.AddDelphiFunction('Function Min4( const B1, B2 : Integer) : Integer;');
 CL.AddDelphiFunction('Function Min5( const B1, B2 : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function Min6( const B1, B2 : Int64) : Int64;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function Min6_P( const B1, B2 : Int64) : Int64;
Begin Result := JclLogic.Min(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Min5_P( const B1, B2 : Cardinal) : Cardinal;
Begin Result := JclLogic.Min(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Min4_P( const B1, B2 : Integer) : Integer;
Begin Result := JclLogic.Min(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Min3_P( const B1, B2 : Word) : Word;
Begin Result := JclLogic.Min(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Min2_P( const B1, B2 : Smallint) : Smallint;
Begin Result := JclLogic.Min(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Min1_P( const B1, B2 : Shortint) : Shortint;
Begin Result := JclLogic.Min(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Min_P( const B1, B2 : Byte) : Byte;
Begin Result := JclLogic.Min(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Max6_P( const B1, B2 : Int64) : Int64;
Begin Result := JclLogic.Max(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Max5_P( const B1, B2 : Cardinal) : Cardinal;
Begin Result := JclLogic.Max(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Max4_P( const B1, B2 : Integer) : Integer;
Begin Result := JclLogic.Max(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Max3_P( const B1, B2 : Word) : Word;
Begin Result := JclLogic.Max(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Max2_P( const B1, B2 : Smallint) : Smallint;
Begin Result := JclLogic.Max(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Max1_P( const B1, B2 : Shortint) : Shortint;
Begin Result := JclLogic.Max(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function Max_P( const B1, B2 : Byte) : Byte;
Begin Result := JclLogic.Max(B1, B2); END;

(*----------------------------------------------------------------------------*)
Function DecLimitClamp6_P( var B : Int64; const Limit : Int64; const Decr : Int64) : Int64;
Begin Result := JclLogic.DecLimitClamp(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimitClamp5_P( var B : Cardinal; const Limit : Cardinal; const Decr : Cardinal) : Cardinal;
Begin Result := JclLogic.DecLimitClamp(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimitClamp4_P( var B : Integer; const Limit : Integer; const Decr : Integer) : Integer;
Begin Result := JclLogic.DecLimitClamp(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimitClamp3_P( var B : Word; const Limit : Word; const Decr : Word) : Word;
Begin Result := JclLogic.DecLimitClamp(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimitClamp2_P( var B : Smallint; const Limit : Smallint; const Decr : Smallint) : Smallint;
Begin Result := JclLogic.DecLimitClamp(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimitClamp1_P( var B : Shortint; const Limit : Shortint; const Decr : Shortint) : Shortint;
Begin Result := JclLogic.DecLimitClamp(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimitClamp_P( var B : Byte; const Limit : Byte; const Decr : Byte) : Byte;
Begin Result := JclLogic.DecLimitClamp(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function IncLimitClamp6_P( var B : Int64; const Limit : Int64; const Incr : Int64) : Int64;
Begin Result := JclLogic.IncLimitClamp(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimitClamp5_P( var B : Cardinal; const Limit : Cardinal; const Incr : Cardinal) : Cardinal;
Begin Result := JclLogic.IncLimitClamp(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimitClamp4_P( var B : Integer; const Limit : Integer; const Incr : Integer) : Integer;
Begin Result := JclLogic.IncLimitClamp(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimitClamp3_P( var B : Word; const Limit : Word; const Incr : Word) : Word;
Begin Result := JclLogic.IncLimitClamp(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimitClamp2_P( var B : Smallint; const Limit : Smallint; const Incr : Smallint) : Smallint;
Begin Result := JclLogic.IncLimitClamp(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimitClamp1_P( var B : Shortint; const Limit : Shortint; const Incr : Shortint) : Shortint;
Begin Result := JclLogic.IncLimitClamp(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimitClamp_P( var B : Byte; const Limit : Byte; const Incr : Byte) : Byte;
Begin Result := JclLogic.IncLimitClamp(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function DecLimit6_P( var B : Int64; const Limit : Int64; const Decr : Int64) : Int64;
Begin Result := JclLogic.DecLimit(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimit5_P( var B : Cardinal; const Limit : Cardinal; const Decr : Cardinal) : Cardinal;
Begin Result := JclLogic.DecLimit(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimit4_P( var B : Integer; const Limit : Integer; const Decr : Integer) : Integer;
Begin Result := JclLogic.DecLimit(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimit3_P( var B : Word; const Limit : Word; const Decr : Word) : Word;
Begin Result := JclLogic.DecLimit(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimit2_P( var B : Smallint; const Limit : Smallint; const Decr : Smallint) : Smallint;
Begin Result := JclLogic.DecLimit(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimit1_P( var B : Shortint; const Limit : Shortint; const Decr : Shortint) : Shortint;
Begin Result := JclLogic.DecLimit(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function DecLimit_P( var B : Byte; const Limit : Byte; const Decr : Byte) : Byte;
Begin Result := JclLogic.DecLimit(B, Limit, Decr); END;

(*----------------------------------------------------------------------------*)
Function IncLimit6_P( var B : Int64; const Limit : Int64; const Incr : Int64) : Int64;
Begin Result := JclLogic.IncLimit(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimit5_P( var B : Cardinal; const Limit : Cardinal; const Incr : Cardinal) : Cardinal;
Begin Result := JclLogic.IncLimit(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimit4_P( var B : Integer; const Limit : Integer; const Incr : Integer) : Integer;
Begin Result := JclLogic.IncLimit(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimit3_P( var B : Word; const Limit : Word; const Incr : Word) : Word;
Begin Result := JclLogic.IncLimit(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimit2_P( var B : Smallint; const Limit : Smallint; const Incr : Smallint) : Smallint;
Begin Result := JclLogic.IncLimit(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimit1_P( var B : Shortint; const Limit : Shortint; const Incr : Shortint) : Shortint;
Begin Result := JclLogic.IncLimit(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Function IncLimit_P( var B : Byte; const Limit : Byte; const Incr : Byte) : Byte;
Begin Result := JclLogic.IncLimit(B, Limit, Incr); END;

(*----------------------------------------------------------------------------*)
Procedure SwapOrd6_P( var I, J : Int64);
Begin JclLogic.SwapOrd(I, J); END;

(*----------------------------------------------------------------------------*)
Procedure SwapOrd5_P( var I, J : Cardinal);
Begin JclLogic.SwapOrd(I, J); END;

(*----------------------------------------------------------------------------*)
Procedure SwapOrd4_P( var I, J : Integer);
Begin JclLogic.SwapOrd(I, J); END;

(*----------------------------------------------------------------------------*)
Procedure SwapOrd3_P( var I, J : Word);
Begin JclLogic.SwapOrd(I, J); END;

(*----------------------------------------------------------------------------*)
Procedure SwapOrd2_P( var I, J : Smallint);
Begin JclLogic.SwapOrd(I, J); END;

(*----------------------------------------------------------------------------*)
Procedure SwapOrd1_P( var I, J : Shortint);
Begin JclLogic.SwapOrd(I, J); END;

(*----------------------------------------------------------------------------*)
Procedure SwapOrd_P( var I, J : Byte);
Begin JclLogic.SwapOrd(I, J); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes5_P( P : Pointer; Count : Integer) : Pointer;
Begin Result := JclLogic.ReverseBytes(P, Count); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes4_P( Value : Int64) : Int64;
Begin Result := JclLogic.ReverseBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes3_P( Value : Cardinal) : Cardinal;
Begin Result := JclLogic.ReverseBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes2_P( Value : Integer) : Integer;
Begin Result := JclLogic.ReverseBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes1_P( Value : Smallint) : Smallint;
Begin Result := JclLogic.ReverseBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes_P( Value : Word) : Word;
Begin Result := JclLogic.ReverseBytes(Value); END;

(*----------------------------------------------------------------------------*)
Function BitsNeeded3_P( const X : Int64) : Integer;
Begin Result := JclLogic.BitsNeeded(X); END;

(*----------------------------------------------------------------------------*)
Function BitsNeeded2_P( const X : Integer) : Integer;
Begin Result := JclLogic.BitsNeeded(X); END;

(*----------------------------------------------------------------------------*)
Function BitsNeeded1_P( const X : Word) : Integer;
Begin Result := JclLogic.BitsNeeded(X); END;

(*----------------------------------------------------------------------------*)
Function BitsNeeded_P( const X : Byte) : Integer;
Begin Result := JclLogic.BitsNeeded(X); END;

(*----------------------------------------------------------------------------*)
Procedure BitsToBooleans3_P( const Bits : Int64; var B : TBooleanArray; AllBits : Boolean);
Begin JclLogic.BitsToBooleans(Bits, B, AllBits); END;

(*----------------------------------------------------------------------------*)
Procedure BitsToBooleans2_P( const Bits : Integer; var B : TBooleanArray; AllBits : Boolean);
Begin JclLogic.BitsToBooleans(Bits, B, AllBits); END;

(*----------------------------------------------------------------------------*)
Procedure BitsToBooleans1_P( const Bits : Word; var B : TBooleanArray; AllBits : Boolean);
Begin JclLogic.BitsToBooleans(Bits, B, AllBits); END;

(*----------------------------------------------------------------------------*)
Procedure BitsToBooleans_P( const Bits : Byte; var B : TBooleanArray; AllBits : Boolean);
Begin JclLogic.BitsToBooleans(Bits, B, AllBits); END;

(*----------------------------------------------------------------------------*)
Procedure BooleansToBits3_P( var Dest : Int64; const B : TBooleanArray);
Begin JclLogic.BooleansToBits(Dest, B); END;

(*----------------------------------------------------------------------------*)
Procedure BooleansToBits2_P( var Dest : Integer; const B : TBooleanArray);
Begin JclLogic.BooleansToBits(Dest, B); END;

(*----------------------------------------------------------------------------*)
Procedure BooleansToBits1_P( var Dest : Word; const B : TBooleanArray);
Begin JclLogic.BooleansToBits(Dest, B); END;

(*----------------------------------------------------------------------------*)
Procedure BooleansToBits_P( var Dest : Byte; const B : TBooleanArray);
Begin JclLogic.BooleansToBits(Dest, B); END;

(*----------------------------------------------------------------------------*)
Function ToggleBit6_P( const Value : Int64; const Bit : TBitRange) : Int64;
Begin Result := JclLogic.ToggleBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ToggleBit5_P( const Value : Integer; const Bit : TBitRange) : Integer;
Begin Result := JclLogic.ToggleBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ToggleBit4_P( const Value : Cardinal; const Bit : TBitRange) : Cardinal;
Begin Result := JclLogic.ToggleBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ToggleBit3_P( const Value : Word; const Bit : TBitRange) : Word;
Begin Result := JclLogic.ToggleBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ToggleBit2_P( const Value : Smallint; const Bit : TBitRange) : Smallint;
Begin Result := JclLogic.ToggleBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ToggleBit1_P( const Value : Shortint; const Bit : TBitRange) : Shortint;
Begin Result := JclLogic.ToggleBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ToggleBit_P( const Value : Byte; const Bit : TBitRange) : Byte;
Begin Result := JclLogic.ToggleBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function TestBits6_P( const Value, Mask : Int64) : Boolean;
Begin Result := JclLogic.TestBits(Value, Mask); END;

(*----------------------------------------------------------------------------*)
Function TestBits5_P( const Value, Mask : Integer) : Boolean;
Begin Result := JclLogic.TestBits(Value, Mask); END;

(*----------------------------------------------------------------------------*)
Function TestBits4_P( const Value, Mask : Cardinal) : Boolean;
Begin Result := JclLogic.TestBits(Value, Mask); END;

(*----------------------------------------------------------------------------*)
Function TestBits3_P( const Value, Mask : Word) : Boolean;
Begin Result := JclLogic.TestBits(Value, Mask); END;

(*----------------------------------------------------------------------------*)
Function TestBits2_P( const Value, Mask : Smallint) : Boolean;
Begin Result := JclLogic.TestBits(Value, Mask); END;

(*----------------------------------------------------------------------------*)
Function TestBits1_P( const Value, Mask : Shortint) : Boolean;
Begin Result := JclLogic.TestBits(Value, Mask); END;

(*----------------------------------------------------------------------------*)
Function TestBits_P( const Value, Mask : Byte) : Boolean;
Begin Result := JclLogic.TestBits(Value, Mask); END;

(*----------------------------------------------------------------------------*)
Function TestBit7_P( const Value : Int64; const Bit : TBitRange) : Boolean;
Begin Result := JclLogic.TestBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function TestBit6_P( const Value : Integer; const Bit : TBitRange) : Boolean;
Begin Result := JclLogic.TestBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function TestBit5_P( const Value : Cardinal; const Bit : TBitRange) : Boolean;
Begin Result := JclLogic.TestBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function TestBit4_P( const Value : Word; const Bit : TBitRange) : Boolean;
Begin Result := JclLogic.TestBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function TestBit3_P( const Value : Smallint; const Bit : TBitRange) : Boolean;
Begin Result := JclLogic.TestBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function TestBit2_P( const Value : Shortint; const Bit : TBitRange) : Boolean;
Begin Result := JclLogic.TestBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function TestBit_P( const Value : Byte; const Bit : TBitRange) : Boolean;
Begin Result := JclLogic.TestBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function SetBit6_P( const Value : Int64; const Bit : TBitRange) : Int64;
Begin Result := JclLogic.SetBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function SetBit5_P( const Value : Integer; const Bit : TBitRange) : Integer;
Begin Result := JclLogic.SetBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function SetBit4_P( const Value : Cardinal; const Bit : TBitRange) : Cardinal;
Begin Result := JclLogic.SetBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function SetBit3_P( const Value : Word; const Bit : TBitRange) : Word;
Begin Result := JclLogic.SetBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function SetBit2_P( const Value : Smallint; const Bit : TBitRange) : Smallint;
Begin Result := JclLogic.SetBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function SetBit1_P( const Value : Shortint; const Bit : TBitRange) : Shortint;
Begin Result := JclLogic.SetBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function SetBit_P( const Value : Byte; const Bit : TBitRange) : Byte;
Begin Result := JclLogic.SetBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function Sar2_P( const Value : Integer; const Count : TBitRange) : Integer;
Begin Result := JclLogic.Sar(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function Sar1_P( const Value : Smallint; const Count : TBitRange) : Smallint;
Begin Result := JclLogic.Sar(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function Sar_P( const Value : Shortint; const Count : TBitRange) : Shortint;
Begin Result := JclLogic.Sar(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function RRot2_P( const Value : Integer; const Count : TBitRange) : Integer;
Begin Result := JclLogic.RRot(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function RRot1_P( const Value : Word; const Count : TBitRange) : Word;
Begin Result := JclLogic.RRot(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function RRot_P( const Value : Byte; const Count : TBitRange) : Byte;
Begin Result := JclLogic.RRot(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits7_P( P : Pointer; Count : Integer) : Pointer;
Begin Result := JclLogic.ReverseBits(P, Count); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits6_P( Value : Int64) : Int64;
Begin Result := JclLogic.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits5_P( Value : Cardinal) : Cardinal;
Begin Result := JclLogic.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits4_P( Value : Integer) : Integer;
Begin Result := JclLogic.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits3_P( Value : Word) : Word;
Begin Result := JclLogic.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits2_P( Value : Smallint) : Smallint;
Begin Result := JclLogic.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits1_P( Value : Shortint) : Shortint;
Begin Result := JclLogic.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits_P( Value : Byte) : Byte;
Begin Result := JclLogic.ReverseBits(Value); END;

(*----------------------------------------------------------------------------*)
Function LRot2_P( const Value : Integer; const Count : TBitRange) : Integer;
Begin Result := JclLogic.LRot(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function LRot1_P( const Value : Word; const Count : TBitRange) : Word;
Begin Result := JclLogic.LRot(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function LRot_P( const Value : Byte; const Count : TBitRange) : Byte;
Begin Result := JclLogic.LRot(Value, Count); END;

(*----------------------------------------------------------------------------*)
Function CountBitsCleared6_P( X : Int64) : Integer;
Begin Result := JclLogic.CountBitsCleared(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsCleared5_P( X : Cardinal) : Integer;
Begin Result := JclLogic.CountBitsCleared(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsCleared4_P( X : Integer) : Integer;
Begin Result := JclLogic.CountBitsCleared(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsCleared3_P( X : Word) : Integer;
Begin Result := JclLogic.CountBitsCleared(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsCleared2_P( X : Smallint) : Integer;
Begin Result := JclLogic.CountBitsCleared(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsCleared1_P( X : Shortint) : Integer;
Begin Result := JclLogic.CountBitsCleared(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsCleared_P( X : Byte) : Integer;
Begin Result := JclLogic.CountBitsCleared(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsSet6_P( X : Int64) : Integer;
Begin Result := JclLogic.CountBitsSet(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsSet5_P( X : Cardinal) : Integer;
Begin Result := JclLogic.CountBitsSet(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsSet4_P( X : Integer) : Integer;
Begin Result := JclLogic.CountBitsSet(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsSet3_P( X : ShortInt) : Integer;
Begin Result := JclLogic.CountBitsSet(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsSet2_P( X : Smallint) : Integer;
Begin Result := JclLogic.CountBitsSet(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsSet1_P( X : Word) : Integer;
Begin Result := JclLogic.CountBitsSet(X); END;

(*----------------------------------------------------------------------------*)
Function CountBitsSet_P( X : Byte) : Integer;
Begin Result := JclLogic.CountBitsSet(X); END;

(*----------------------------------------------------------------------------*)
Function ClearBit6_P( const Value : Int64; const Bit : TBitRange) : Int64;
Begin Result := JclLogic.ClearBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ClearBit5_P( const Value : Cardinal; const Bit : TBitRange) : Cardinal;
Begin Result := JclLogic.ClearBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ClearBit4_P( const Value : Integer; const Bit : TBitRange) : Integer;
Begin Result := JclLogic.ClearBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ClearBit3_P( const Value : Word; const Bit : TBitRange) : Word;
Begin Result := JclLogic.ClearBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ClearBit2_P( const Value : Smallint; const Bit : TBitRange) : Smallint;
Begin Result := JclLogic.ClearBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ClearBit1_P( const Value : Shortint; const Bit : TBitRange) : Shortint;
Begin Result := JclLogic.ClearBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function ClearBit_P( const Value : Byte; const Bit : TBitRange) : Byte;
Begin Result := JclLogic.ClearBit(Value, Bit); END;

(*----------------------------------------------------------------------------*)
Function BitsLowest6_P( X : Int64) : Integer;
Begin Result := JclLogic.BitsLowest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsLowest5_P( X : Integer) : Integer;
Begin Result := JclLogic.BitsLowest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsLowest4_P( X : Cardinal) : Integer;
Begin Result := JclLogic.BitsLowest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsLowest3_P( X : Word) : Integer;
Begin Result := JclLogic.BitsLowest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsLowest2_P( X : Smallint) : Integer;
Begin Result := JclLogic.BitsLowest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsLowest1_P( X : Shortint) : Integer;
Begin Result := JclLogic.BitsLowest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsLowest_P( X : Byte) : Integer;
Begin Result := JclLogic.BitsLowest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsHighest6_P( X : Int64) : Integer;
Begin Result := JclLogic.BitsHighest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsHighest5_P( X : Cardinal) : Integer;
Begin Result := JclLogic.BitsHighest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsHighest4_P( X : Integer) : Integer;
Begin Result := JclLogic.BitsHighest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsHighest3_P( X : Word) : Integer;
Begin Result := JclLogic.BitsHighest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsHighest2_P( X : SmallInt) : Integer;
Begin Result := JclLogic.BitsHighest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsHighest1_P( X : ShortInt) : Integer;
Begin Result := JclLogic.BitsHighest(X); END;

(*----------------------------------------------------------------------------*)
Function BitsHighest_P( X : Byte) : Integer;
Begin Result := JclLogic.BitsHighest(X); END;

(*----------------------------------------------------------------------------*)
Function OrdToBinary6_P( const Value : Int64) : string;
Begin Result := JclLogic.OrdToBinary(Value); END;

(*----------------------------------------------------------------------------*)
Function OrdToBinary5_P( const Value : Cardinal) : string;
Begin Result := JclLogic.OrdToBinary(Value); END;

(*----------------------------------------------------------------------------*)
Function OrdToBinary4_P( const Value : Integer) : string;
Begin Result := JclLogic.OrdToBinary(Value); END;

(*----------------------------------------------------------------------------*)
Function OrdToBinary3_P( const Value : Word) : string;
Begin Result := JclLogic.OrdToBinary(Value); END;

(*----------------------------------------------------------------------------*)
Function OrdToBinary2_P( const Value : Smallint) : string;
Begin Result := JclLogic.OrdToBinary(Value); END;

(*----------------------------------------------------------------------------*)
Function OrdToBinary1_P( const Value : Shortint) : string;
Begin Result := JclLogic.OrdToBinary(Value); END;

(*----------------------------------------------------------------------------*)
Function OrdToBinary_P( const Value : Byte) : string;
Begin Result := JclLogic.OrdToBinary(Value); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclLogic_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@OrdToBinary, 'OrdToBinary', cdRegister);
 S.RegisterDelphiFunction(@OrdToBinary1_P, 'OrdToBinary1', cdRegister);
 S.RegisterDelphiFunction(@OrdToBinary2_P, 'OrdToBinary2', cdRegister);
 S.RegisterDelphiFunction(@OrdToBinary3_P, 'OrdToBinary3', cdRegister);
 S.RegisterDelphiFunction(@OrdToBinary4_P, 'OrdToBinary4', cdRegister);
 S.RegisterDelphiFunction(@OrdToBinary5_P, 'OrdToBinary5', cdRegister);
 S.RegisterDelphiFunction(@OrdToBinary6_P, 'OrdToBinary6', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest, 'BitsHighest', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest1_P, 'BitsHighest1', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest2_P, 'BitsHighest2', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest3_P, 'BitsHighest3', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest4_P, 'BitsHighest4', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest5_P, 'BitsHighest5', cdRegister);
 S.RegisterDelphiFunction(@BitsHighest6_P, 'BitsHighest6', cdRegister);
 S.RegisterDelphiFunction(@BitsLowest, 'BitsLowest', cdRegister);
 S.RegisterDelphiFunction(@BitsLowest1_P, 'BitsLowest1', cdRegister);
 S.RegisterDelphiFunction(@BitsLowest2_P, 'BitsLowest2', cdRegister);
 S.RegisterDelphiFunction(@BitsLowest3_P, 'BitsLowest3', cdRegister);
 S.RegisterDelphiFunction(@BitsLowest4_P, 'BitsLowest4', cdRegister);
 S.RegisterDelphiFunction(@BitsLowest5_P, 'BitsLowest5', cdRegister);
 S.RegisterDelphiFunction(@BitsLowest6_P, 'BitsLowest6', cdRegister);
 S.RegisterDelphiFunction(@ClearBit, 'ClearBit', cdRegister);
 S.RegisterDelphiFunction(@ClearBit1_P, 'ClearBit1', cdRegister);
 S.RegisterDelphiFunction(@ClearBit2_P, 'ClearBit2', cdRegister);
 S.RegisterDelphiFunction(@ClearBit3_P, 'ClearBit3', cdRegister);
 S.RegisterDelphiFunction(@ClearBit4_P, 'ClearBit4', cdRegister);
 S.RegisterDelphiFunction(@ClearBit5_P, 'ClearBit5', cdRegister);
 S.RegisterDelphiFunction(@ClearBit6_P, 'ClearBit6', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet, 'CountBitsSet', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet1_P, 'CountBitsSet1', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet2_P, 'CountBitsSet2', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet3_P, 'CountBitsSet3', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet4_P, 'CountBitsSet4', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet5_P, 'CountBitsSet5', cdRegister);
 S.RegisterDelphiFunction(@CountBitsSet6_P, 'CountBitsSet6', cdRegister);
 S.RegisterDelphiFunction(@CountBitsCleared, 'CountBitsCleared', cdRegister);
 S.RegisterDelphiFunction(@CountBitsCleared1_P, 'CountBitsCleared1', cdRegister);
 S.RegisterDelphiFunction(@CountBitsCleared2_p, 'CountBitsCleared2', cdRegister);
 S.RegisterDelphiFunction(@CountBitsCleared3_P, 'CountBitsCleared3', cdRegister);
 S.RegisterDelphiFunction(@CountBitsCleared4_P, 'CountBitsCleared4', cdRegister);
 S.RegisterDelphiFunction(@CountBitsCleared5_p, 'CountBitsCleared5', cdRegister);
 S.RegisterDelphiFunction(@CountBitsCleared6_P, 'CountBitsCleared6', cdRegister);
 S.RegisterDelphiFunction(@LRot, 'LRot', cdRegister);
 S.RegisterDelphiFunction(@LRot1_P, 'LRot1', cdRegister);
 S.RegisterDelphiFunction(@LRot2_P, 'LRot2', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits, 'ReverseBits', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits1_p, 'ReverseBits1', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits2_P, 'ReverseBits2', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits3_p, 'ReverseBits3', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits4_p, 'ReverseBits4', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits4_p, 'ReverseBits4', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits5_p, 'ReverseBits5', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits6_p, 'ReverseBits6', cdRegister);
 S.RegisterDelphiFunction(@RRot, 'RRot', cdRegister);
 S.RegisterDelphiFunction(@RRot1_p, 'RRot1', cdRegister);
 S.RegisterDelphiFunction(@RRot2_p, 'RRot2', cdRegister);
 S.RegisterDelphiFunction(@Sar, 'Sar', cdRegister);
 S.RegisterDelphiFunction(@Sar1_p, 'Sar1', cdRegister);
 S.RegisterDelphiFunction(@Sar2_p, 'Sar2', cdRegister);
 S.RegisterDelphiFunction(@SetBit, 'SetBit', cdRegister);
 S.RegisterDelphiFunction(@SetBit1_p, 'SetBit1', cdRegister);
 S.RegisterDelphiFunction(@SetBit2_p, 'SetBit2', cdRegister);
 S.RegisterDelphiFunction(@SetBit3_p, 'SetBit3', cdRegister);
 S.RegisterDelphiFunction(@SetBit4_p, 'SetBit4', cdRegister);
 S.RegisterDelphiFunction(@SetBit4_p, 'SetBit4', cdRegister);
 S.RegisterDelphiFunction(@SetBit5_p, 'SetBit5', cdRegister);
 S.RegisterDelphiFunction(@TestBit, 'TestBit', cdRegister);
 S.RegisterDelphiFunction(@TestBit2_p, 'TestBit2', cdRegister);
 S.RegisterDelphiFunction(@TestBit3_p, 'TestBit3', cdRegister);
 S.RegisterDelphiFunction(@TestBit4_p, 'TestBit4', cdRegister);
 S.RegisterDelphiFunction(@TestBit5_p, 'TestBit5', cdRegister);
 S.RegisterDelphiFunction(@TestBit6_p, 'TestBit6', cdRegister);
 S.RegisterDelphiFunction(@TestBit7_p, 'TestBit7', cdRegister);
 S.RegisterDelphiFunction(@TestBits, 'TestBits', cdRegister);
 S.RegisterDelphiFunction(@TestBits1_p, 'TestBits1', cdRegister);
 S.RegisterDelphiFunction(@TestBits2_p, 'TestBits2', cdRegister);
 S.RegisterDelphiFunction(@TestBits3_p, 'TestBits3', cdRegister);
 S.RegisterDelphiFunction(@TestBits4_p, 'TestBits4', cdRegister);
 S.RegisterDelphiFunction(@TestBits5_p, 'TestBits5', cdRegister);
 S.RegisterDelphiFunction(@TestBits6_p, 'TestBits6', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit, 'ToggleBit', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit1_p, 'ToggleBit1', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit2_p, 'ToggleBit2', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit3_p, 'ToggleBit3', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit4_p, 'ToggleBit4', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit5_p, 'ToggleBit5', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit6_p, 'ToggleBit6', cdRegister);
 S.RegisterDelphiFunction(@BooleansToBits, 'BooleansToBits', cdRegister);
 S.RegisterDelphiFunction(@BooleansToBits1_p, 'BooleansToBits1', cdRegister);
 S.RegisterDelphiFunction(@BooleansToBits2_p, 'BooleansToBits2', cdRegister);
 S.RegisterDelphiFunction(@BooleansToBits3_p, 'BooleansToBits3', cdRegister);
 S.RegisterDelphiFunction(@BitsToBooleans, 'BitsToBooleans', cdRegister);
 S.RegisterDelphiFunction(@BitsToBooleans1_p, 'BitsToBooleans1', cdRegister);
 S.RegisterDelphiFunction(@BitsToBooleans2_p, 'BitsToBooleans2', cdRegister);
 S.RegisterDelphiFunction(@BitsToBooleans3_p, 'BitsToBooleans3', cdRegister);
 S.RegisterDelphiFunction(@BitsNeeded, 'BitsNeeded', cdRegister);
 S.RegisterDelphiFunction(@BitsNeeded1_p, 'BitsNeeded1', cdRegister);
 S.RegisterDelphiFunction(@BitsNeeded2_p, 'BitsNeeded2', cdRegister);
 S.RegisterDelphiFunction(@BitsNeeded3_p, 'BitsNeeded3', cdRegister);
 S.RegisterDelphiFunction(@Digits, 'Digits', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes, 'ReverseBytes', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes1_p, 'ReverseBytes1', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes2_p, 'ReverseBytes2', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes3_p, 'ReverseBytes3', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes4_p, 'ReverseBytes4', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes5_p, 'ReverseBytes5', cdRegister);
 S.RegisterDelphiFunction(@SwapOrd, 'SwapOrd', cdRegister);
 S.RegisterDelphiFunction(@SwapOrd1_p, 'SwapOrd1', cdRegister);
 S.RegisterDelphiFunction(@SwapOrd2_p, 'SwapOrd2', cdRegister);
 S.RegisterDelphiFunction(@SwapOrd3_p, 'SwapOrd3', cdRegister);
 S.RegisterDelphiFunction(@SwapOrd4_p, 'SwapOrd4', cdRegister);
 S.RegisterDelphiFunction(@SwapOrd5_p, 'SwapOrd5', cdRegister);
 S.RegisterDelphiFunction(@SwapOrd6_p, 'SwapOrd6', cdRegister);
 S.RegisterDelphiFunction(@IncLimit, 'IncLimit', cdRegister);
 S.RegisterDelphiFunction(@IncLimit1_p, 'IncLimit1', cdRegister);
 S.RegisterDelphiFunction(@IncLimit2_p, 'IncLimit2', cdRegister);
 S.RegisterDelphiFunction(@IncLimit3_p, 'IncLimit3', cdRegister);
 S.RegisterDelphiFunction(@IncLimit4_p, 'IncLimit4', cdRegister);
 S.RegisterDelphiFunction(@IncLimit5_p, 'IncLimit5', cdRegister);
 S.RegisterDelphiFunction(@IncLimit6_p, 'IncLimit6', cdRegister);
 S.RegisterDelphiFunction(@DecLimit, 'DecLimit', cdRegister);
 S.RegisterDelphiFunction(@DecLimit1_p, 'DecLimit1', cdRegister);
 S.RegisterDelphiFunction(@DecLimit2_p, 'DecLimit2', cdRegister);
 S.RegisterDelphiFunction(@DecLimit3_p, 'DecLimit3', cdRegister);
 S.RegisterDelphiFunction(@DecLimit4_p, 'DecLimit4', cdRegister);
 S.RegisterDelphiFunction(@DecLimit5_p, 'DecLimit5', cdRegister);
 S.RegisterDelphiFunction(@DecLimit6_p, 'DecLimit6', cdRegister);
 S.RegisterDelphiFunction(@IncLimitClamp, 'IncLimitClamp', cdRegister);
 S.RegisterDelphiFunction(@IncLimitClamp1_p, 'IncLimitClamp1', cdRegister);
 S.RegisterDelphiFunction(@IncLimitClamp2_P, 'IncLimitClamp2', cdRegister);
 S.RegisterDelphiFunction(@IncLimitClamp3_p, 'IncLimitClamp3', cdRegister);
 S.RegisterDelphiFunction(@IncLimitClamp4_p, 'IncLimitClamp4', cdRegister);
 S.RegisterDelphiFunction(@IncLimitClamp5_p, 'IncLimitClamp5', cdRegister);
 S.RegisterDelphiFunction(@IncLimitClamp6_p, 'IncLimitClamp6', cdRegister);
 S.RegisterDelphiFunction(@DecLimitClamp, 'DecLimitClamp', cdRegister);
 S.RegisterDelphiFunction(@DecLimitClamp1_p, 'DecLimitClamp1', cdRegister);
 S.RegisterDelphiFunction(@DecLimitClamp2_p, 'DecLimitClamp2', cdRegister);
 S.RegisterDelphiFunction(@DecLimitClamp3_p, 'DecLimitClamp3', cdRegister);
 S.RegisterDelphiFunction(@DecLimitClamp4_p, 'DecLimitClamp4', cdRegister);
 S.RegisterDelphiFunction(@DecLimitClamp5_p, 'DecLimitClamp5', cdRegister);
 S.RegisterDelphiFunction(@DecLimitClamp6_p, 'DecLimitClamp6', cdRegister);
 S.RegisterDelphiFunction(@Max, 'MaxJ', cdRegister);
 S.RegisterDelphiFunction(@Max1_p, 'Max1', cdRegister);
 S.RegisterDelphiFunction(@Max2_p, 'Max2', cdRegister);
 S.RegisterDelphiFunction(@Max3_p, 'Max3', cdRegister);
 S.RegisterDelphiFunction(@Max4_p, 'Max4', cdRegister);
 S.RegisterDelphiFunction(@Max5_p, 'Max5', cdRegister);
 S.RegisterDelphiFunction(@Max6_p, 'Max6', cdRegister);
 S.RegisterDelphiFunction(@Min, 'MinJ', cdRegister);
 S.RegisterDelphiFunction(@Min1_p, 'Min1', cdRegister);
 S.RegisterDelphiFunction(@Min2_p, 'Min2', cdRegister);
 S.RegisterDelphiFunction(@Min3_p, 'Min3', cdRegister);
 S.RegisterDelphiFunction(@Min4_p, 'Min4', cdRegister);
 S.RegisterDelphiFunction(@Min5_p, 'Min5', cdRegister);
 S.RegisterDelphiFunction(@Min6_p, 'Min6', cdRegister);
end;



{ TPSImport_JclLogic }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclLogic.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclLogic(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclLogic.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclLogic(ri);
  RIRegister_JclLogic_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
