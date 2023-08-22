unit uPSI_SortUtils;
{
   a sort mode
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
  TPSImport_SortUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_SortUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SortUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,MemUtils
  ,SortUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SortUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SortUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('SortType1', 'Byte');
  CL.AddTypeS('SortType2', 'Double');
  CL.AddTypeS('SortType3', 'DWord');
  //CL.AddTypeS('PDWordArray', '^DWordArray // will not work');
  CL.AddTypeS('TDataRecord4', 'record Value : Integer; Data : Integer; end');
 CL.AddDelphiFunction('Procedure QuickSort( var List : array of SortType1; Min, Max : Integer)');
 CL.AddDelphiFunction('Procedure QuickSortDWord( var List : array of SortType3; Min, Max : Integer)');
 CL.AddDelphiFunction('Procedure QuickSortDataRecord4( var List : array of TDataRecord4; Count : Integer)');
 CL.AddDelphiFunction('Procedure HeapSort( var List : array of SortType1; Count : DWord; FirstNeeded : DWord)');
 CL.AddDelphiFunction('Function QuickSelect( var List : array of SortType1; Min, Max, Wanted : Integer) : SortType1');
 CL.AddDelphiFunction('Function QuickSelectDouble( var List : array of SortType2; Min, Max, Wanted : Integer) : SortType2');
 CL.AddDelphiFunction('Function QuickSelectDWord( var List : array of SortType3; Min, Max, Wanted : Integer) : SortType3');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SortUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@QuickSort, 'QuickSort', cdRegister);
 S.RegisterDelphiFunction(@QuickSortDWord, 'QuickSortDWord', cdRegister);
 S.RegisterDelphiFunction(@QuickSortDataRecord4, 'QuickSortDataRecord4', cdRegister);
 S.RegisterDelphiFunction(@HeapSort, 'HeapSort', cdRegister);
 S.RegisterDelphiFunction(@QuickSelect, 'QuickSelect', cdRegister);
 S.RegisterDelphiFunction(@QuickSelectDouble, 'QuickSelectDouble', cdRegister);
 S.RegisterDelphiFunction(@QuickSelectDWord, 'QuickSelectDWord', cdRegister);
end;



{ TPSImport_SortUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SortUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SortUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SortUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_SortUtils(ri);
  RIRegister_SortUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
