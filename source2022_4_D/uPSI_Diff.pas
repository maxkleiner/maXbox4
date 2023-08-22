unit uPSI_Diff;
{
  for forensic
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
  TPSImport_Diff = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDiff(CL: TPSPascalCompiler);
procedure SIRegister_Diff(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Diff_Routines(S: TPSExec);
procedure RIRegister_TDiff(CL: TPSRuntimeClassImporter);
procedure RIRegister_Diff(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Math
  ,Forms
  ,Diff
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Diff]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDiff(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDiff') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDiff') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
    RegisterMethod('Function Execute( pints1, pints2 : PInteger; len1, len2 : integer) : boolean;');
    RegisterMethod('Function Execute1( pchrs1, pchrs2 : PChar; len1, len2 : integer) : boolean;');
    RegisterMethod('Procedure Cancel');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Cancelled', 'boolean', iptr);
    RegisterProperty('Count', 'integer', iptr);
    RegisterProperty('Compares', 'TCompareRec integer', iptr);
    SetDefaultPropery('Compares');
    RegisterProperty('DiffStats', 'TDiffStats', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Diff(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAX_DIAGONAL','LongWord').SetUInt( $FFFFFF);
  //CL.AddTypeS('P8Bits', 'PByte');
  //CL.AddTypeS('P8Bits', 'PAnsiChar');
  //CL.AddTypeS('PDiags', '^TDiags // will not work');
  //CL.AddTypeS('PIntArray', '^TIntArray // will not work');
  CL.AddTypeS('TChangeKind', '( ckNone, ckAdd, ckDelete, ckModify )');
  //CL.AddTypeS('PCompareRec', '^TCompareRec // will not work');
  CL.AddTypeS('TCompareRec', 'record Kind : TChangeKind; oldIndex1 : integer; o'
   +'ldIndex2 : integer; chr1 : char; chr2 : Char; end');
  CL.AddTypeS('TDiffStats', 'record matches : integer; adds : integer; deletes '
   +': integer; modifies : integer; end');
  SIRegister_TDiff(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDiffDiffStats_R(Self: TDiff; var T: TDiffStats);
begin T := Self.DiffStats; end;

(*----------------------------------------------------------------------------*)
procedure TDiffCompares_R(Self: TDiff; var T: TCompareRec; const t1: integer);
begin T := Self.Compares[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TDiffCount_R(Self: TDiff; var T: integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TDiffCancelled_R(Self: TDiff; var T: boolean);
begin T := Self.Cancelled; end;

(*----------------------------------------------------------------------------*)
Function TDiffExecute1_P(Self: TDiff;  pchrs1, pchrs2 : PChar; len1, len2 : integer) : boolean;
Begin Result := Self.Execute(pchrs1, pchrs2, len1, len2); END;

(*----------------------------------------------------------------------------*)
Function TDiffExecute_P(Self: TDiff;  pints1, pints2 : PInteger; len1, len2 : integer) : boolean;
Begin Result := Self.Execute(pints1, pints2, len1, len2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Diff_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDiff(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDiff) do begin
    RegisterConstructor(@TDiff.Create, 'Create');
    RegisterMethod(@TDiffExecute_P, 'Execute');
    RegisterMethod(@TDiffExecute1_P, 'Execute1');
    RegisterMethod(@TDiff.Cancel, 'Cancel');
    RegisterMethod(@TDiff.Clear, 'Clear');
    RegisterPropertyHelper(@TDiffCancelled_R,nil,'Cancelled');
    RegisterPropertyHelper(@TDiffCount_R,nil,'Count');
    RegisterPropertyHelper(@TDiffCompares_R,nil,'Compares');
    RegisterPropertyHelper(@TDiffDiffStats_R,nil,'DiffStats');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Diff(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDiff(CL);
end;

 
 
{ TPSImport_Diff }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Diff.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Diff(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Diff.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Diff(ri);
  RIRegister_Diff_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
