unit xrtl_util_CPUUtils;

//{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils;

type
  TXRTLBitIndex = 0 .. 31;

  PDWORDArray = ^TDWORDArray;
  TDWORDArray = array[0 .. $0FFFFFFF] of DWORD;

  PCardinalArray = ^TCardinalArray;
  TCardinalArray = array[0 .. $0FFFFFFF] of Cardinal;

  PInt64Array = ^TInt64Array;
  TInt64Array = array[0 .. $08FFFFFF] of Int64;

  PCardinalBytes = ^TCardinalBytes;
  TCardinalBytes = packed record
    Bytes: array[0 .. 3] of Byte;
  end;

  PCardinalWords = ^TCardinalWords;
  TCardinalWords = packed record
    Words: array[0 .. 1] of Word;
  end;

  PInt64Bytes = ^TInt64Bytes;
  TInt64Bytes = packed record
    Bytes: array[0 .. 7] of Byte;
  end;

  PInt64Words = ^TInt64Words;
  TInt64Words = packed record
    Words: array[0 .. 4] of Word;
  end;

  PInt64DWords = ^TInt64DWords;
  TInt64DWords = packed record
    DWords: array[0 .. 1] of DWord;
  end;

function  XRTLSwapBits(Data: Cardinal; Bit1Index, Bit2Index: TXRTLBitIndex): Cardinal; stdcall;
function  XRTLBitTest(Data: Cardinal; BitIndex: TXRTLBitIndex): Boolean; stdcall;
function  XRTLBitSet(Data: Cardinal; BitIndex: TXRTLBitIndex): Cardinal; stdcall;
function  XRTLBitReset(Data: Cardinal; BitIndex: TXRTLBitIndex): Cardinal; stdcall;
function  XRTLBitComplement(Data: Cardinal; BitIndex: TXRTLBitIndex): Cardinal; stdcall;

function  XRTLSwapHiLo16(X: Word): Word; register;
function  XRTLSwapHiLo32(X: Cardinal): Cardinal; register;
function  XRTLSwapHiLo64(X: Int64): Int64;

function  XRTLROL32(A, S: Cardinal): Cardinal; register;
function  XRTLROR32(A, S: Cardinal): Cardinal; register;
function  XRTLROL16(A: Word; S: Cardinal): Word; register;
function  XRTLROR16(A: Word; S: Cardinal): Word; register;
function  XRTLROL8(A: Byte; S: Cardinal): Byte; register;
function  XRTLROR8(A: Byte; S: Cardinal): Byte; register;

procedure XRTLXorBlock(I1, I2, O1: PByteArray; Len: integer);
procedure XRTLIncBlock(P: PByteArray; Len: integer);

procedure XRTLUMul64(const A, B: Integer; var MulL, MulH: Integer); stdcall;

function  XRTLPointerAdd(Base: Pointer; Offset: Integer): Pointer; register;
function  XRTLPointerDist(P1, P2: Pointer): Integer; register;
function  XRTLPopulation(A: Cardinal): Cardinal;

implementation

function  XRTLSwapBits(Data: Cardinal; Bit1Index, Bit2Index: TXRTLBitIndex): Cardinal; stdcall;
asm
        PUSH    EBX
        PUSH    EDI
        MOV     EAX,Data
        MOVZX   EBX,Bit1Index
        MOVZX   ECX,Bit2Index
        XOR     EDX,EDX
        BTR     EAX,EBX
        SETC    DL
        SHL     EDX,CL
        MOV     EDI,EDX
        XOR     EDX,EDX
        BTR     EAX,ECX
        SETC    DL
        MOV     CL,BL
        SHL     EDX,CL
        OR      EAX,EDX
        OR      EAX,EDI
        POP     EDI
        POP     EBX
end;

function  XRTLBitTest(Data: Cardinal; BitIndex: TXRTLBitIndex): Boolean; stdcall;
asm
        MOV     EAX,Data
        MOVZX   ECX,BitIndex
        BT      EAX,ECX
        SETC    AL
end;

function  XRTLBitSet(Data: Cardinal; BitIndex: TXRTLBitIndex): Cardinal; stdcall;
asm
        MOV     EAX,Data
        MOVZX   ECX,BitIndex
        BTS     EAX,ECX
end;

function  XRTLBitReset(Data: Cardinal; BitIndex: TXRTLBitIndex): Cardinal; stdcall;
asm
        MOV     EAX,Data
        MOVZX   ECX,BitIndex
        BTR     EAX,ECX
end;

function  XRTLBitComplement(Data: Cardinal; BitIndex: TXRTLBitIndex): Cardinal; stdcall;
asm
        MOV     EAX,Data
        MOVZX   ECX,BitIndex
        BTC     EAX,ECX
end;

function XRTLSwapHiLo16(X: Word): Word; register;
asm
        XCHG    AH,AL
end;

function XRTLSwapHiLo32(X: Cardinal): Cardinal; register;
asm
        BSWAP   EAX
end;

function XRTLSwapHiLo64(X: Int64): Int64;
asm
        MOV     EDX,[DWORD PTR EBP + 12]
        MOV     EAX,[DWORD PTR EBP + 8]
        BSWAP   EAX
        XCHG    EAX,EDX
        BSWAP   EAX
end;

function XRTLROL32(A, S: Cardinal): Cardinal; register;
asm
        MOV     ECX,S
        ROL     EAX,CL
end;

function XRTLROR32(A, S: Cardinal): Cardinal; register;
asm
        MOV     ECX,S
        ROR     EAX,CL
end;

function XRTLROL16(A: Word; S: Cardinal): Word; register;
asm
        MOV     ECX,S
        ROL     AX,CL
end;

function XRTLROR16(A: Word; S: Cardinal): Word; register;
asm
        MOV     ECX,S
        ROR     AX,CL
end;

function XRTLROL8(A: Byte; S: Cardinal): Byte; register;
asm
        MOV     ECX,S
        ROL     AL,CL
end;

function XRTLROR8(A: Byte; S: Cardinal): Byte; register;
asm
        MOV     ECX,S
        ROR     AL,CL
end;

procedure XRTLXorBlock(I1, I2, O1: PByteArray; Len: integer);
var
  I: Integer;
begin
  for I:= 0 to Len - 1 do
    O1[I]:= I1[I] xor I2[I];
end;

procedure XRTLIncBlock(P: PByteArray; Len: integer);
begin
  Inc(P[Len - 1]);
  if (P[Len - 1]= 0) and (Len > 1) then
    XRTLIncBlock(P, Len - 1);
end;

procedure XRTLUMul64(const A, B: Integer; var MulL, MulH: Integer); stdcall;
asm
        MOV     EAX,A
        MOV     ECX,B
        MUL     ECX
        MOV     ECX,MulL
        MOV     [ECX],EAX
        MOV     ECX,MulH
        MOV     [ECX],EDX
end;

function XRTLPointerAdd(Base: Pointer; Offset: Integer): Pointer; register;
//begin
//  Result:= Pointer(Integer(Base) + Offset);
asm
        ADD     EAX,EDX
end;

function  XRTLPointerDist(P1, P2: Pointer): Integer; register;
//begin
//  Result:= Integer(P2) - Integer(P1);
asm
        XCHG    EAX,EDX
        SUB     EAX,EDX
end;

function  XRTLPopulation(A: Cardinal): Cardinal;
begin
  Result:= A;
  Result:= (Result and $55555555) + ((Result shr  1) and $55555555);
  Result:= (Result and $33333333) + ((Result shr  2) and $33333333);
  Result:= (Result and $0F0F0F0F) + ((Result shr  4) and $0F0F0F0F);
  Result:= (Result and $00FF00FF) + ((Result shr  8) and $00FF00FF);
  Result:= (Result and $0000FFFF) + ((Result shr 16) and $0000FFFF);
end;

end.
