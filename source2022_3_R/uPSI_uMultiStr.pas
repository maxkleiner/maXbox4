unit uPSI_uMultiStr;
{
   jast after multierror
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
  TPSImport_uMultiStr = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMultiStrings(CL: TPSPascalCompiler);
procedure SIRegister_uMultiStr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMultiStrings(CL: TPSRuntimeClassImporter);
procedure RIRegister_uMultiStr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uMultiStr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uMultiStr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMultiStrings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TMultiStrings') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TMultiStrings') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('RowCount', 'integer', iptrw);
    RegisterProperty('ColCount', 'integer', iptrw);
    RegisterProperty('Rows', 'TStrings integer', iptr);
    RegisterProperty('Cols', 'TStrings integer', iptr);
    RegisterProperty('Cells', 'string integer integer', iptrw);
    SetDefaultPropery('Cells');
    RegisterProperty('Objects', 'TObject integer integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uMultiStr(CL: TPSPascalCompiler);
begin
  SIRegister_TMultiStrings(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMultiStringsObjects_W(Self: TMultiStrings; const T: TObject; const t1: integer; const t2: integer);
begin Self.Objects[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsObjects_R(Self: TMultiStrings; var T: TObject; const t1: integer; const t2: integer);
begin T := Self.Objects[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsCells_W(Self: TMultiStrings; const T: string; const t1: integer; const t2: integer);
begin Self.Cells[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsCells_R(Self: TMultiStrings; var T: string; const t1: integer; const t2: integer);
begin T := Self.Cells[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsCols_R(Self: TMultiStrings; var T: TStrings; const t1: integer);
begin T := Self.Cols[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsRows_R(Self: TMultiStrings; var T: TStrings; const t1: integer);
begin T := Self.Rows[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsColCount_W(Self: TMultiStrings; const T: integer);
begin Self.ColCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsColCount_R(Self: TMultiStrings; var T: integer);
begin T := Self.ColCount; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsRowCount_W(Self: TMultiStrings; const T: integer);
begin Self.RowCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiStringsRowCount_R(Self: TMultiStrings; var T: integer);
begin T := Self.RowCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMultiStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMultiStrings) do begin
    RegisterConstructor(@TMultiStrings.Create, 'Create');
    RegisterMethod(@TMultiStrings.Destroy, 'Free');
   RegisterMethod(@TMultiStrings.Assign, 'Assign');
    RegisterMethod(@TMultiStrings.Clear, 'Clear');
    RegisterPropertyHelper(@TMultiStringsRowCount_R,@TMultiStringsRowCount_W,'RowCount');
    RegisterPropertyHelper(@TMultiStringsColCount_R,@TMultiStringsColCount_W,'ColCount');
    RegisterPropertyHelper(@TMultiStringsRows_R,nil,'Rows');
    RegisterPropertyHelper(@TMultiStringsCols_R,nil,'Cols');
    RegisterPropertyHelper(@TMultiStringsCells_R,@TMultiStringsCells_W,'Cells');
    RegisterPropertyHelper(@TMultiStringsObjects_R,@TMultiStringsObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uMultiStr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMultiStrings(CL);
end;

 
 
{ TPSImport_uMultiStr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uMultiStr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uMultiStr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uMultiStr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uMultiStr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
