unit uPSI_MyBigInt;
{
and updated by max.

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
  TPSImport_MyBigInt = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMyBigInt(CL: TPSPascalCompiler);
procedure SIRegister_MyBigInt(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMyBigInt(CL: TPSRuntimeClassImporter);
procedure RIRegister_MyBigInt(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Math
  ,MyBigInt
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MyBigInt]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyBigInt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMyBigInt') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMyBigInt') do begin
    RegisterMethod('Constructor Create( iValue : Integer)');
    RegisterMethod('Procedure Add( Addend1, Addend2 : TMyBigInt)');
    RegisterMethod('Procedure Multiply( Multiplier1, Multiplier2 : TMyBigInt);');
    RegisterMethod('Procedure Multiply1( Multiplier1 : TMyBigInt; Multiplier2 : Integer);');
    RegisterMethod('Function ToString : string');
    RegisterMethod('Procedure CopyFrom( mbCopy : TMyBigInt)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MyBigInt(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('Base','LongInt').SetInt( 10);
  SIRegister_TMyBigInt(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TMyBigIntMultiply1_P(Self: TMyBigInt;  Multiplier1 : TMyBigInt; Multiplier2 : Integer);
Begin Self.Multiply(Multiplier1, Multiplier2); END;

(*----------------------------------------------------------------------------*)
Procedure TMyBigIntMultiply_P(Self: TMyBigInt;  Multiplier1, Multiplier2 : TMyBigInt);
Begin Self.Multiply(Multiplier1, Multiplier2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyBigInt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyBigInt) do begin
    RegisterConstructor(@TMyBigInt.Create, 'Create');
    RegisterMethod(@TMyBigInt.Add, 'Add');
    RegisterMethod(@TMyBigIntMultiply_P, 'Multiply');
    RegisterMethod(@TMyBigIntMultiply1_P, 'Multiply1');
    RegisterMethod(@TMyBigInt.ToString, 'ToString');
    RegisterMethod(@TMyBigInt.CopyFrom, 'CopyFrom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MyBigInt(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMyBigInt(CL);
end;

 
 
{ TPSImport_MyBigInt }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MyBigInt.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MyBigInt(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MyBigInt.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MyBigInt(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
