unit uPSI_UIntegerpartition;
{
TCallbackint

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
  TPSImport_UIntegerpartition = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIntPartition(CL: TPSPascalCompiler);
procedure SIRegister_UIntegerpartition(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIntPartition(CL: TPSRuntimeClassImporter);
procedure RIRegister_UIntegerpartition(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   UIntegerpartition
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UIntegerpartition]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIntPartition(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TIntPartition') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TIntPartition') do
  begin
    //RegisterProperty('P', 'array of integer', iptrw);
    RegisterProperty('P', 'TIntegerArray', iptrw);

    RegisterProperty('Partsize', 'integer', iptrw);
    RegisterProperty('PCount', 'int64', iptrw);
    RegisterMethod('Function NPart_Table( const N, Npart : integer) : int64;');
    RegisterMethod('Function NPart_Table1( N, Npart : integer; var p : NTableArray) : int64;');
    RegisterMethod('Function Part_Table( const N : integer) : int64');
    RegisterMethod('Procedure PartitionInit( newInteger, NewPartsize : integer; NewCallback : TCallbackint)');
    RegisterMethod('Function PartitionMaxval( FirstN, k : integer; target : int64; newcallback : TCallbackint) : boolean');
    RegisterMethod('Function partitioncount( n, m : integer) : int64');
    RegisterMethod('Function Unrank( N, NPart, Rank : Integer) : boolean');
  end;
end;

//type  TIntegerArray = array of integer;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UIntegerpartition(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCallbackint', 'Function  : boolean');
  CL.AddTypeS('Tpartition', 'array of int64');
  CL.AddTypeS('TIntegerArray', 'array of integer');
  CL.AddTypeS('NTableArray', 'array of array of int64');
  SIRegister_TIntPartition(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TIntPartitionNPart_Table1_P(Self: TIntPartition;  N, Npart : integer; var p : NTableArray) : int64;
Begin Result := Self.NPart_Table(N, Npart, p); END;

(*----------------------------------------------------------------------------*)
Function TIntPartitionNPart_Table_P(Self: TIntPartition;  const N, Npart : integer) : int64;
Begin Result := Self.NPart_Table(N, Npart); END;

(*----------------------------------------------------------------------------*)
procedure TIntPartitionPCount_W(Self: TIntPartition; const T: int64);
Begin Self.PCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntPartitionPCount_R(Self: TIntPartition; var T: int64);
Begin T := Self.PCount; end;

(*----------------------------------------------------------------------------*)
procedure TIntPartitionPartsize_W(Self: TIntPartition; const T: integer);
Begin Self.Partsize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntPartitionPartsize_R(Self: TIntPartition; var T: integer);
Begin T := Self.Partsize; end;
 {
(*----------------------------------------------------------------------------*)
procedure TIntPartitionP_W(Self: TIntPartition; const T: integer; idx: integer);
Begin Self.P[idx] := T;
end;

(*----------------------------------------------------------------------------*)
procedure TIntPartitionP_R(Self: TIntPartition; var T: integer; idx: integer);
Begin T := Self.P[idx];
end;  }

procedure TIntPartitionP_W(Self: TIntPartition; const T: TIntegerArray);
Begin Self.P := T;
end;

(*----------------------------------------------------------------------------*)
procedure TIntPartitionP_R(Self: TIntPartition; var T: TIntegerArray);
Begin T := Self.P;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TIntPartition(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntPartition) do
  begin
    RegisterPropertyHelper(@TIntPartitionP_R,@TIntPartitionP_W,'P');
    RegisterPropertyHelper(@TIntPartitionPartsize_R,@TIntPartitionPartsize_W,'Partsize');
    RegisterPropertyHelper(@TIntPartitionPCount_R,@TIntPartitionPCount_W,'PCount');
    RegisterMethod(@TIntPartitionNPart_Table_P, 'NPart_Table');
    RegisterMethod(@TIntPartitionNPart_Table1_P, 'NPart_Table1');
    RegisterMethod(@TIntPartition.Part_Table, 'Part_Table');
    RegisterMethod(@TIntPartition.PartitionInit, 'PartitionInit');
    RegisterMethod(@TIntPartition.PartitionMaxval, 'PartitionMaxval');
    RegisterMethod(@TIntPartition.partitioncount, 'partitioncount');
    RegisterMethod(@TIntPartition.Unrank, 'Unrank');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UIntegerpartition(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIntPartition(CL);
end;

 
 
{ TPSImport_UIntegerpartition }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UIntegerpartition.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UIntegerpartition(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UIntegerpartition.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UIntegerpartition(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
