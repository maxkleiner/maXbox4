unit uPSI_flcBits32;
{
another one bits the byte

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
  TPSImport_flcBits32 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcBits32(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcBits32_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcBits32
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcBits32]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcBits32(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ClearBit32( const Value, BitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function SetBit32( const Value, BitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function IsBitSet32( const Value, BitIndex : Word32) : Boolean');
 CL.AddDelphiFunction('Function ToggleBit32( const Value, BitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function IsHighBitSet32( const Value : Word32) : Boolean');
 CL.AddDelphiFunction('Function SetBitScanForward320( const Value : Word32) : Integer;');
 CL.AddDelphiFunction('Function SetBitScanForward321( const Value, BitIndex : Word32) : Integer;');
 CL.AddDelphiFunction('Function SetBitScanReverse322( const Value : Word32) : Integer;');
 CL.AddDelphiFunction('Function SetBitScanReverse323( const Value, BitIndex : Word32) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanForward324( const Value : Word32) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanForward325( const Value, BitIndex : Word32) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanReverse326( const Value : Word32) : Integer;');
 CL.AddDelphiFunction('Function ClearBitScanReverse327( const Value, BitIndex : Word32) : Integer;');
 CL.AddDelphiFunction('Function ReverseBits328( const Value : Word32) : Word32;');
 CL.AddDelphiFunction('Function ReverseBits329( const Value : Word32; const BitCount : Integer) : Word32;');
 CL.AddDelphiFunction('Function SwapEndian32( const Value : Word32) : Word32');
 CL.AddDelphiFunction('Procedure SwapEndianBuf32( var Buf : string; const Count : Integer)');
 CL.AddDelphiFunction('Function TwosComplement32( const Value : Word32) : Word32');
 CL.AddDelphiFunction('Function flcRotateLeftBits16( const Value : Word; const Bits : Byte) : Word');
 CL.AddDelphiFunction('Function flcRotateLeftBits32( const Value : Word32; const Bits : Byte) : Word32');
 CL.AddDelphiFunction('Function flcRotateRightBits16( const Value : Word; const Bits : Byte) : Word');
 CL.AddDelphiFunction('Function flcRotateRightBits32( const Value : Word32; const Bits : Byte) : Word32');
 CL.AddDelphiFunction('Function BitCount32( const Value : Word32) : Word32');
 CL.AddDelphiFunction('Function IsPowerOfTwo32( const Value : Word32) : Boolean');
 CL.AddDelphiFunction('Function LowBitMask32( const HighBitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function HighBitMask32( const LowBitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function RangeBitMask32( const LowBitIndex, HighBitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function SetBitRange32( const Value : Word32; const LowBitIndex, HighBitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function ClearBitRange32( const Value : Word32; const LowBitIndex, HighBitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function ToggleBitRange32( const Value : Word32; const LowBitIndex, HighBitIndex : Word32) : Word32');
 CL.AddDelphiFunction('Function IsBitRangeSet32( const Value : Word32; const LowBitIndex, HighBitIndex : Word32) : Boolean');
 CL.AddDelphiFunction('Function IsBitRangeClear32( const Value : Word32; const LowBitIndex, HighBitIndex : Word32) : Boolean');
 CL.AddDelphiFunction('Procedure TestBitClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ReverseBits329_P( const Value : Word32; const BitCount : Integer) : Word32;
Begin Result := flcBits32.ReverseBits32(Value, BitCount); END;

(*----------------------------------------------------------------------------*)
Function ReverseBits328_P( const Value : Word32) : Word32;
Begin Result := flcBits32.ReverseBits32(Value); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanReverse327_P( const Value, BitIndex : Word32) : Integer;
Begin Result := flcBits32.ClearBitScanReverse32(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanReverse326_P( const Value : Word32) : Integer;
Begin Result := flcBits32.ClearBitScanReverse32(Value); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanForward325_P( const Value, BitIndex : Word32) : Integer;
Begin Result := flcBits32.ClearBitScanForward32(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function ClearBitScanForward324_P( const Value : Word32) : Integer;
Begin Result := flcBits32.ClearBitScanForward32(Value); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanReverse323_P( const Value, BitIndex : Word32) : Integer;
Begin Result := flcBits32.SetBitScanReverse32(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanReverse322_P( const Value : Word32) : Integer;
Begin Result := flcBits32.SetBitScanReverse32(Value); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanForward321_P( const Value, BitIndex : Word32) : Integer;
Begin Result := flcBits32.SetBitScanForward32(Value, BitIndex); END;

(*----------------------------------------------------------------------------*)
Function SetBitScanForward320_P( const Value : Word32) : Integer;
Begin Result := flcBits32.SetBitScanForward32(Value); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcBits32_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ClearBit32, 'ClearBit32', cdRegister);
 S.RegisterDelphiFunction(@SetBit32, 'SetBit32', cdRegister);
 S.RegisterDelphiFunction(@IsBitSet32, 'IsBitSet32', cdRegister);
 S.RegisterDelphiFunction(@ToggleBit32, 'ToggleBit32', cdRegister);
 S.RegisterDelphiFunction(@IsHighBitSet32, 'IsHighBitSet32', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanForward320_P, 'SetBitScanForward320', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanForward321_P, 'SetBitScanForward321', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanReverse322_P, 'SetBitScanReverse322', cdRegister);
 S.RegisterDelphiFunction(@SetBitScanReverse323_P, 'SetBitScanReverse323', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanForward324_P, 'ClearBitScanForward324', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanForward325_P, 'ClearBitScanForward325', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanReverse326_P, 'ClearBitScanReverse326', cdRegister);
 S.RegisterDelphiFunction(@ClearBitScanReverse327_P, 'ClearBitScanReverse327', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits328_P, 'ReverseBits328', cdRegister);
 S.RegisterDelphiFunction(@ReverseBits329_P, 'ReverseBits329', cdRegister);
 S.RegisterDelphiFunction(@SwapEndian32, 'SwapEndian32', cdRegister);
 S.RegisterDelphiFunction(@SwapEndianBuf32, 'SwapEndianBuf32', cdRegister);
 S.RegisterDelphiFunction(@TwosComplement32, 'TwosComplement32', cdRegister);
 S.RegisterDelphiFunction(@RotateLeftBits16, 'flcRotateLeftBits16', cdRegister);
 S.RegisterDelphiFunction(@RotateLeftBits32, 'flcRotateLeftBits32', cdRegister);
 S.RegisterDelphiFunction(@RotateRightBits16, 'flcRotateRightBits16', cdRegister);
 S.RegisterDelphiFunction(@RotateRightBits32, 'flcRotateRightBits32', cdRegister);
 S.RegisterDelphiFunction(@BitCount32, 'BitCount32', cdRegister);
 S.RegisterDelphiFunction(@IsPowerOfTwo32, 'IsPowerOfTwo32', cdRegister);
 S.RegisterDelphiFunction(@LowBitMask32, 'LowBitMask32', cdRegister);
 S.RegisterDelphiFunction(@HighBitMask32, 'HighBitMask32', cdRegister);
 S.RegisterDelphiFunction(@RangeBitMask32, 'RangeBitMask32', cdRegister);
 S.RegisterDelphiFunction(@SetBitRange32, 'SetBitRange32', cdRegister);
 S.RegisterDelphiFunction(@ClearBitRange32, 'ClearBitRange32', cdRegister);
 S.RegisterDelphiFunction(@ToggleBitRange32, 'ToggleBitRange32', cdRegister);
 S.RegisterDelphiFunction(@IsBitRangeSet32, 'IsBitRangeSet32', cdRegister);
 S.RegisterDelphiFunction(@IsBitRangeClear32, 'IsBitRangeClear32', cdRegister);
 S.RegisterDelphiFunction(@Test, 'TestBitClass', cdRegister);
end;

 
 
{ TPSImport_flcBits32 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcBits32.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcBits32(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcBits32.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcBits32_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
