unit uPSI_StUtils;
{
   Systools4
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
  TPSImport_StUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StDate
  ,StStrL
  ,StUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function SignL( L : LongInt) : Integer');
 CL.AddDelphiFunction('Function SignF( F : Extended) : Integer');
 CL.AddDelphiFunction('Function MinWord( A, B : Word) : Word');
 CL.AddDelphiFunction('Function MidWord( W1, W2, W3 : Word) : Word');
 CL.AddDelphiFunction('Function MaxWord( A, B : Word) : Word');
 CL.AddDelphiFunction('Function MinLong( A, B : LongInt) : LongInt');
 CL.AddDelphiFunction('Function MidLong( L1, L2, L3 : LongInt) : LongInt');
 CL.AddDelphiFunction('Function MaxLong( A, B : LongInt) : LongInt');
 CL.AddDelphiFunction('Function MinFloat( F1, F2 : Extended) : Extended');
 CL.AddDelphiFunction('Function MidFloat( F1, F2, F3 : Extended) : Extended');
 CL.AddDelphiFunction('Function MaxFloat( F1, F2 : Extended) : Extended');
 CL.AddDelphiFunction('Function MakeInteger16( H, L : Byte) : SmallInt');
 CL.AddDelphiFunction('Function MakeWordS( H, L : Byte) : Word');
 CL.AddDelphiFunction('Function SwapNibble( B : Byte) : Byte');
 CL.AddDelphiFunction('Function SwapWord( L : LongInt) : LongInt');
 CL.AddDelphiFunction('Procedure SetFlag( var Flags : Word; FlagMask : Word)');
 CL.AddDelphiFunction('Procedure ClearFlag( var Flags : Word; FlagMask : Word)');
 CL.AddDelphiFunction('Function FlagIsSet( Flags, FlagMask : Word) : Boolean');
 CL.AddDelphiFunction('Procedure SetByteFlag( var Flags : Byte; FlagMask : Byte)');
 CL.AddDelphiFunction('Procedure ClearByteFlag( var Flags : Byte; FlagMask : Byte)');
 CL.AddDelphiFunction('Function ByteFlagIsSet( Flags, FlagMask : Byte) : Boolean');
 CL.AddDelphiFunction('Procedure SetLongFlag( var Flags : LongInt; FlagMask : LongInt)');
 CL.AddDelphiFunction('Procedure ClearLongFlag( var Flags : LongInt; FlagMask : LongInt)');
 CL.AddDelphiFunction('Function LongFlagIsSet( Flags, FlagMask : LongInt) : Boolean');
 CL.AddDelphiFunction('Procedure ExchangeBytes( var I, J : Byte)');
 CL.AddDelphiFunction('Procedure ExchangeWords( var I, J : Word)');
 CL.AddDelphiFunction('Procedure ExchangeLongInts( var I, J : LongInt)');
 CL.AddDelphiFunction('Procedure ExchangeStructs( var I, J, Size : Cardinal)');
 CL.AddDelphiFunction('Procedure FillWord( var Dest, Count : Cardinal; Filler : Word)');
 CL.AddDelphiFunction('Procedure FillStruct( var Dest, Count : Cardinal; var Filler, FillerSize : Cardinal)');
 CL.AddDelphiFunction('Function AddWordToPtr( P : ___Pointer; W : Word) : ___Pointer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SignL, 'SignL', cdRegister);
 S.RegisterDelphiFunction(@SignF, 'SignF', cdRegister);
 S.RegisterDelphiFunction(@MinWord, 'MinWord', cdRegister);
 S.RegisterDelphiFunction(@MidWord, 'MidWord', cdRegister);
 S.RegisterDelphiFunction(@MaxWord, 'MaxWord', cdRegister);
 S.RegisterDelphiFunction(@MinLong, 'MinLong', cdRegister);
 S.RegisterDelphiFunction(@MidLong, 'MidLong', cdRegister);
 S.RegisterDelphiFunction(@MaxLong, 'MaxLong', cdRegister);
 S.RegisterDelphiFunction(@MinFloat, 'MinFloat', cdRegister);
 S.RegisterDelphiFunction(@MidFloat, 'MidFloat', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat, 'MaxFloat', cdRegister);
 S.RegisterDelphiFunction(@MakeInteger16, 'MakeInteger16', cdRegister);
 S.RegisterDelphiFunction(@MakeWord, 'MakeWordS', cdRegister);
 S.RegisterDelphiFunction(@SwapNibble, 'SwapNibble', cdRegister);
 S.RegisterDelphiFunction(@SwapWord, 'SwapWord', cdRegister);
 S.RegisterDelphiFunction(@SetFlag, 'SetFlag', cdRegister);
 S.RegisterDelphiFunction(@ClearFlag, 'ClearFlag', cdRegister);
 S.RegisterDelphiFunction(@FlagIsSet, 'FlagIsSet', cdRegister);
 S.RegisterDelphiFunction(@SetByteFlag, 'SetByteFlag', cdRegister);
 S.RegisterDelphiFunction(@ClearByteFlag, 'ClearByteFlag', cdRegister);
 S.RegisterDelphiFunction(@ByteFlagIsSet, 'ByteFlagIsSet', cdRegister);
 S.RegisterDelphiFunction(@SetLongFlag, 'SetLongFlag', cdRegister);
 S.RegisterDelphiFunction(@ClearLongFlag, 'ClearLongFlag', cdRegister);
 S.RegisterDelphiFunction(@LongFlagIsSet, 'LongFlagIsSet', cdRegister);
 S.RegisterDelphiFunction(@ExchangeBytes, 'ExchangeBytes', cdRegister);
 S.RegisterDelphiFunction(@ExchangeWords, 'ExchangeWords', cdRegister);
 S.RegisterDelphiFunction(@ExchangeLongInts, 'ExchangeLongInts', cdRegister);
 S.RegisterDelphiFunction(@ExchangeStructs, 'ExchangeStructs', cdRegister);
 S.RegisterDelphiFunction(@FillWord, 'FillWord', cdRegister);
 S.RegisterDelphiFunction(@FillStruct, 'FillStruct', cdRegister);
 S.RegisterDelphiFunction(@AddWordToPtr, 'AddWordToPtr', cdRegister);
end;

 
 
{ TPSImport_StUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StUtils(ri);
  RIRegister_StUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
