unit uPSI_qsFoundation;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_qsFoundation = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TExtVector(CL: TPSPascalCompiler);
procedure SIRegister_TRealVector(CL: TPSPascalCompiler);
procedure SIRegister_TLongintVector(CL: TPSPascalCompiler);
procedure SIRegister_TIntVector(CL: TPSPascalCompiler);
procedure SIRegister_TLogicVector(CL: TPSPascalCompiler);
procedure SIRegister_qsFoundation(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_qsFoundation_Routines(S: TPSExec);
procedure RIRegister_TExtVector(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRealVector(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLongintVector(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIntVector(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLogicVector(CL: TPSRuntimeClassImporter);
procedure RIRegister_qsFoundation(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Math
  ,qsFoundation
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_qsFoundation]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtVector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExtVector') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExtVector') do
  begin
    RegisterProperty('data', 'TExtVector_data', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure InitZero( length : longint)');
    RegisterMethod('Procedure InitOne( length : longint)');
    RegisterMethod('Function getlength : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRealVector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRealVector') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRealVector') do
  begin
    RegisterProperty('data', 'TRealvector_data', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure InitZero( length : longint)');
    RegisterMethod('Procedure InitOne( length : longint)');
    RegisterMethod('Function getlength : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLongintVector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLongintVector') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLongintVector') do
  begin
    RegisterProperty('data', 'TLongintvector_data', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure InitZero( length : longint)');
    RegisterMethod('Procedure InitOne( length : longint)');
    RegisterMethod('Function getlength : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIntVector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIntVector') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIntVector') do
  begin
    RegisterProperty('data', 'TIntVector_data', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure InitZero( length : longint)');
    RegisterMethod('Procedure InitOne( length : longint)');
    RegisterMethod('Function getlength : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLogicVector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLogicVector') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLogicVector') do
  begin
    RegisterProperty('data', 'TLogicVector_data', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure InitFalse( length : longint)');
    RegisterMethod('Procedure InitTrue( length : longint)');
    RegisterMethod('Function getlength : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_qsFoundation(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('QS_major','LongInt').SetInt( 1);
 CL.AddConstantN('QS_minor','LongInt').SetInt( 0);
 CL.AddConstantN('QS_release','LongInt').SetInt( 0);
 CL.AddConstantN('QS_patch','LongInt').SetInt( 0);
 CL.AddConstantN('QS_version','String').SetString( '1.0.0.0');
 CL.AddConstantN('QS_internalversion','String').SetString( '');
  CL.AddTypeS('TLogicvector_data', 'array of boolean');
  CL.AddTypeS('TIntvector_data', 'array of integer');
  CL.AddTypeS('TLongintvector_data', 'array of longint');
  CL.AddTypeS('TRealvector_data', 'array of real');
  CL.AddTypeS('TExtvector_data', 'array of extended');
  CL.AddTypeS('TLogicmatrix_data', 'array of Tlogicvector_data');
  CL.AddTypeS('TIntmatrix_data', 'array of Tintvector_data');
  CL.AddTypeS('TLongintmatrix_data', 'array of Tlongintvector_data');
  CL.AddTypeS('TRealmatrix_data', 'array of Trealvector_data');
  CL.AddTypeS('TExtmatrix_data', 'array of Textvector_data');
  SIRegister_TLogicVector(CL);
  SIRegister_TIntVector(CL);
  SIRegister_TLongintVector(CL);
  SIRegister_TRealVector(CL);
  SIRegister_TExtVector(CL);
 CL.AddDelphiFunction('Function add( const vec1 : TIntVector; const vec2 : TIntVector) : TIntVector');
 CL.AddDelphiFunction('Function add( const vec1 : TLongintVector; const vec2 : TLongintVector) : TLongintVector');
 CL.AddDelphiFunction('Function add( const vec1 : TRealVector; const vec2 : TRealVector) : TRealVector');
 CL.AddDelphiFunction('Function add( const vec1 : TExtVector; const vec2 : TExtVector) : TExtVector');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TExtVectordata_W(Self: TExtVector; const T: TExtVector_data);
Begin Self.data := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtVectordata_R(Self: TExtVector; var T: TExtVector_data);
Begin T := Self.data; end;

(*----------------------------------------------------------------------------*)
procedure TRealVectordata_W(Self: TRealVector; const T: TRealvector_data);
Begin Self.data := T; end;

(*----------------------------------------------------------------------------*)
procedure TRealVectordata_R(Self: TRealVector; var T: TRealvector_data);
Begin T := Self.data; end;

(*----------------------------------------------------------------------------*)
procedure TLongintVectordata_W(Self: TLongintVector; const T: TLongintvector_data);
Begin Self.data := T; end;

(*----------------------------------------------------------------------------*)
procedure TLongintVectordata_R(Self: TLongintVector; var T: TLongintvector_data);
Begin T := Self.data; end;

(*----------------------------------------------------------------------------*)
procedure TIntVectordata_W(Self: TIntVector; const T: TIntVector_data);
Begin Self.data := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntVectordata_R(Self: TIntVector; var T: TIntVector_data);
Begin T := Self.data; end;

(*----------------------------------------------------------------------------*)
procedure TLogicVectordata_W(Self: TLogicVector; const T: TLogicVector_data);
Begin Self.data := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogicVectordata_R(Self: TLogicVector; var T: TLogicVector_data);
Begin T := Self.data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_qsFoundation_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@add, 'add', cdRegister);
 S.RegisterDelphiFunction(@add, 'add', cdRegister);
 S.RegisterDelphiFunction(@add, 'add', cdRegister);
 S.RegisterDelphiFunction(@add, 'add', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtVector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtVector) do
  begin
    RegisterPropertyHelper(@TExtVectordata_R,@TExtVectordata_W,'data');
    RegisterConstructor(@TExtVector.Create, 'Create');
    RegisterMethod(@TExtVector.InitZero, 'InitZero');
    RegisterMethod(@TExtVector.InitOne, 'InitOne');
    RegisterMethod(@TExtVector.getlength, 'getlength');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRealVector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRealVector) do
  begin
    RegisterPropertyHelper(@TRealVectordata_R,@TRealVectordata_W,'data');
    RegisterConstructor(@TRealVector.Create, 'Create');
    RegisterMethod(@TRealVector.InitZero, 'InitZero');
    RegisterMethod(@TRealVector.InitOne, 'InitOne');
    RegisterMethod(@TRealVector.getlength, 'getlength');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLongintVector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLongintVector) do
  begin
    RegisterPropertyHelper(@TLongintVectordata_R,@TLongintVectordata_W,'data');
    RegisterConstructor(@TLongintVector.Create, 'Create');
    RegisterMethod(@TLongintVector.InitZero, 'InitZero');
    RegisterMethod(@TLongintVector.InitOne, 'InitOne');
    RegisterMethod(@TLongintVector.getlength, 'getlength');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIntVector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntVector) do
  begin
    RegisterPropertyHelper(@TIntVectordata_R,@TIntVectordata_W,'data');
    RegisterConstructor(@TIntVector.Create, 'Create');
    RegisterMethod(@TIntVector.InitZero, 'InitZero');
    RegisterMethod(@TIntVector.InitOne, 'InitOne');
    RegisterMethod(@TIntVector.getlength, 'getlength');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLogicVector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLogicVector) do
  begin
    RegisterPropertyHelper(@TLogicVectordata_R,@TLogicVectordata_W,'data');
    RegisterConstructor(@TLogicVector.Create, 'Create');
    RegisterMethod(@TLogicVector.InitFalse, 'InitFalse');
    RegisterMethod(@TLogicVector.InitTrue, 'InitTrue');
    RegisterMethod(@TLogicVector.getlength, 'getlength');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_qsFoundation(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLogicVector(CL);
  RIRegister_TIntVector(CL);
  RIRegister_TLongintVector(CL);
  RIRegister_TRealVector(CL);
  RIRegister_TExtVector(CL);
end;

 
 
{ TPSImport_qsFoundation }
(*----------------------------------------------------------------------------*)
procedure TPSImport_qsFoundation.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_qsFoundation(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_qsFoundation.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_qsFoundation(ri);
  RIRegister_qsFoundation_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
