unit uPSI_neuralbit;
{
neuromancer for https://sourceforge.net/projects/cai/

change array of byte to TBytes

array of extended TDynExtendedArray

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
  TPSImport_neuralbit = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_neuralbit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralbit_Routines(S: TPSExec);

procedure Register;

implementation


uses
   neuralbit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralbit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralbit(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TArrOf2BytesPtr', '^TArrOf2Bytes // will not work');
  //CL.AddTypeS('TArrOf3BytesPtr', '^TArrOf3Bytes // will not work');
  //CL.AddTypeS('TArrOf4BytesPtr', '^TArrOf4Bytes // will not work');
  //CL.AddTypeS('TArrBytePtr', '^TLongByteArray // will not work');
 CL.AddDelphiFunction('Function POT( numero, elevado : extended) : extended');
 CL.AddDelphiFunction('Function LongintBitTest( Data : longint; P : longint) : boolean');
 CL.AddDelphiFunction('Function LongintBitFlip( Data : longint; P : longint) : longint');
 CL.AddDelphiFunction('Procedure BAClear( var VARS : TBytes)');
 CL.AddDelphiFunction('Procedure BAMake1( var VARS : TBytes)');
 CL.AddDelphiFunction('Function BARead( var A : TBytes; P : longint) : byte');
 CL.AddDelphiFunction('Procedure BAFlip( var A : TBytes; P : longint)');
 CL.AddDelphiFunction('Procedure BAWrite( var A : TBytes; P : longint; Data : byte)');
 CL.AddDelphiFunction('Function BATest( var A : TBytes; P : longint) : boolean');
 CL.AddDelphiFunction('Procedure BASum( var x, y : TBytes)');
 CL.AddDelphiFunction('Procedure BASub( var x, y : TBytes)');
 CL.AddDelphiFunction('Procedure BAIncPos( var x : TBytes; POS : longint)');
 CL.AddDelphiFunction('Procedure BADecPos( var x : TBytes; POS : longint)');
 CL.AddDelphiFunction('Procedure BAInc( var x : TBytes)');
 CL.AddDelphiFunction('Procedure BADec( var x : TBytes)');
 CL.AddDelphiFunction('Function BAToString( VARS : TBytes) : string');
 CL.AddDelphiFunction('Function BAToFloat( var VARS : TBytes) : extended');
 CL.AddDelphiFunction('Procedure PFloatToBA( var VARS : TBytes; Valor : extended)');
 CL.AddDelphiFunction('Procedure BANot( var VARS : TBytes)');
 CL.AddDelphiFunction('Procedure BAAnd( var r, x, y : TBytes)');
 CL.AddDelphiFunction('Procedure BAOr( var r, x, y : TBytes)');
 CL.AddDelphiFunction('Procedure BAXOr( var r, x, y : TBytes)');
 CL.AddDelphiFunction('Function BAGrater( var x, y : TBytes) : boolean');
 CL.AddDelphiFunction('Function BALower( var x, y : TBytes) : boolean');
 CL.AddDelphiFunction('Function BAEqual( var x, y : TBytes) : boolean');
 CL.AddDelphiFunction('Procedure BAPMul( var r, x, y : TBytes)');
 CL.AddDelphiFunction('Function nnRAnd( A, B : extended) : extended');
 CL.AddDelphiFunction('Function nnROr( A, B : extended) : extended');
 CL.AddDelphiFunction('Function nnRNot( A : extended) : extended');
 CL.AddDelphiFunction('Function nnRXor( A, B : extended) : extended');
 CL.AddDelphiFunction('Function REqual( A, B : extended) : extended');
 CL.AddDelphiFunction('Procedure RSum( x, y, z : extended; var R, C : extended)');
 CL.AddDelphiFunction('Procedure RegSum( var x, y : TDynExtendedArray)');
 CL.AddDelphiFunction('Function RegEqual( var x, y : TDynExtendedArray) : extended');
 CL.AddDelphiFunction('Function RegOrdEqual( var x, y : TDynExtendedArray) : extended');
 CL.AddDelphiFunction('Function RegToString( var VARS : TDynExtendedArray) : string');
 CL.AddDelphiFunction('Function ROrer( var VARS : TDynExtendedArray) : extended');
 CL.AddDelphiFunction('Function RAnder( var VARS : TDynExtendedArray) : extended');
 CL.AddDelphiFunction('Function RCNot( X : extended; var VARS : TDynExtendedArray) : extended');
 CL.AddDelphiFunction('Function ROrMaxTerm( var VARS : TDynExtendedArray; NumMaxTerm : longint) : extended');
 CL.AddDelphiFunction('Function ROrMaxTermStr( NumVars : longint; NumMaxTerm : longint) : string');
 CL.AddDelphiFunction('Function RSatFunc( var VARS : TDynExtendedArray; NumFunc : longint) : extended');
 CL.AddDelphiFunction('Function RSatFuncStr( NumVars : longint; NumFunc : longint) : string');
 CL.AddDelphiFunction('Procedure RRegen( var VARS : TDynExtendedArray)');
 CL.AddDelphiFunction('Procedure RDegen( var VARS : TDynExtendedArray)');
 CL.AddDelphiFunction('Procedure RDegenP( var VARS : TDynExtendedArray; P : extended)');
 CL.AddDelphiFunction('Procedure nnClear( var VARS : TDynExtendedArray)');
 CL.AddDelphiFunction('Procedure BARAnd( var R, A, B : TBytes)');
 CL.AddDelphiFunction('Procedure BAROr( var R, AUX, A, B : TBytes)');
 CL.AddDelphiFunction('Procedure BARNot( var R, A : TBytes)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralbit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@POT, 'POT', cdRegister);
 S.RegisterDelphiFunction(@LongintBitTest, 'LongintBitTest', cdRegister);
 S.RegisterDelphiFunction(@LongintBitFlip, 'LongintBitFlip', cdRegister);
 S.RegisterDelphiFunction(@BAClear, 'BAClear', cdRegister);
 S.RegisterDelphiFunction(@BAMake1, 'BAMake1', cdRegister);
 S.RegisterDelphiFunction(@BARead, 'BARead', cdRegister);
 S.RegisterDelphiFunction(@BAFlip, 'BAFlip', cdRegister);
 S.RegisterDelphiFunction(@BAWrite, 'BAWrite', cdRegister);
 S.RegisterDelphiFunction(@BATest, 'BATest', cdRegister);
 S.RegisterDelphiFunction(@BASum, 'BASum', cdRegister);
 S.RegisterDelphiFunction(@BASub, 'BASub', cdRegister);
 S.RegisterDelphiFunction(@BAIncPos, 'BAIncPos', cdRegister);
 S.RegisterDelphiFunction(@BADecPos, 'BADecPos', cdRegister);
 S.RegisterDelphiFunction(@BAInc, 'BAInc', cdRegister);
 S.RegisterDelphiFunction(@BADec, 'BADec', cdRegister);
 S.RegisterDelphiFunction(@BAToString, 'BAToString', cdRegister);
 S.RegisterDelphiFunction(@BAToFloat, 'BAToFloat', cdRegister);
 S.RegisterDelphiFunction(@PFloatToBA, 'PFloatToBA', cdRegister);
 S.RegisterDelphiFunction(@BANot, 'BANot', cdRegister);
 S.RegisterDelphiFunction(@BAAnd, 'BAAnd', cdRegister);
 S.RegisterDelphiFunction(@BAOr, 'BAOr', cdRegister);
 S.RegisterDelphiFunction(@BAXOr, 'BAXOr', cdRegister);
 S.RegisterDelphiFunction(@BAGrater, 'BAGrater', cdRegister);
 S.RegisterDelphiFunction(@BALower, 'BALower', cdRegister);
 S.RegisterDelphiFunction(@BAEqual, 'BAEqual', cdRegister);
 S.RegisterDelphiFunction(@BAPMul, 'BAPMul', cdRegister);
 S.RegisterDelphiFunction(@RAnd, 'nnRAnd', cdRegister);
 S.RegisterDelphiFunction(@ROr, 'nnROr', cdRegister);
 S.RegisterDelphiFunction(@RNot, 'nnRNot', cdRegister);
 S.RegisterDelphiFunction(@RXor, 'nnRXor', cdRegister);
 S.RegisterDelphiFunction(@REqual, 'REqual', cdRegister);
 S.RegisterDelphiFunction(@RSum, 'RSum', cdRegister);
 S.RegisterDelphiFunction(@RegSum, 'RegSum', cdRegister);
 S.RegisterDelphiFunction(@RegEqual, 'RegEqual', cdRegister);
 S.RegisterDelphiFunction(@RegOrdEqual, 'RegOrdEqual', cdRegister);
 S.RegisterDelphiFunction(@RegToString, 'RegToString', cdRegister);
 S.RegisterDelphiFunction(@ROrer, 'ROrer', cdRegister);
 S.RegisterDelphiFunction(@RAnder, 'RAnder', cdRegister);
 S.RegisterDelphiFunction(@RCNot, 'RCNot', cdRegister);
 S.RegisterDelphiFunction(@ROrMaxTerm, 'ROrMaxTerm', cdRegister);
 S.RegisterDelphiFunction(@ROrMaxTermStr, 'ROrMaxTermStr', cdRegister);
 S.RegisterDelphiFunction(@RSatFunc, 'RSatFunc', cdRegister);
 S.RegisterDelphiFunction(@RSatFuncStr, 'RSatFuncStr', cdRegister);
 S.RegisterDelphiFunction(@RRegen, 'RRegen', cdRegister);
 S.RegisterDelphiFunction(@RDegen, 'RDegen', cdRegister);
 S.RegisterDelphiFunction(@RDegenP, 'RDegenP', cdRegister);
 S.RegisterDelphiFunction(@Clear, 'nnClear', cdRegister);
 S.RegisterDelphiFunction(@BARAnd, 'BARAnd', cdRegister);
 S.RegisterDelphiFunction(@BAROr, 'BAROr', cdRegister);
 S.RegisterDelphiFunction(@BARNot, 'BARNot', cdRegister);
end;

 
 
{ TPSImport_neuralbit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralbit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralbit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralbit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralbit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
