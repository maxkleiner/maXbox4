unit uPSI_StatsClasses;
{
  helper class for jvchart and stat 
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
  TPSImport_StatsClasses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStatArray(CL: TPSPascalCompiler);
procedure SIRegister_StatsClasses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStatArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_StatsClasses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StatsClasses
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StatsClasses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStatArray') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStatArray') do begin
    RegisterMethod('Procedure AddValue( aValue : Double)');
    RegisterMethod('Function Average : Double');
    RegisterMethod('Function StandardDeviation : Double');
    RegisterProperty('Grows', 'Boolean', iptrw);
    RegisterProperty('Length', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterMethod('Procedure Reset');
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( initialLength : Integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StatsClasses(CL: TPSPascalCompiler);
begin
  SIRegister_TStatArray(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TStatArrayCreate1_P(Self: TClass; CreateNewInstance: Boolean;  initialLength : Integer):TObject;
Begin Result := TStatArray.Create(initialLength); END;

(*----------------------------------------------------------------------------*)
Function TStatArrayCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TStatArray.Create; END;

(*----------------------------------------------------------------------------*)
procedure TStatArrayCount_R(Self: TStatArray; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStatArrayLength_W(Self: TStatArray; const T: Integer);
begin Self.Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatArrayLength_R(Self: TStatArray; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TStatArrayGrows_W(Self: TStatArray; const T: Boolean);
begin Self.Grows := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatArrayGrows_R(Self: TStatArray; var T: Boolean);
begin T := Self.Grows; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatArray) do begin
    RegisterMethod(@TStatArray.AddValue, 'AddValue');
    RegisterMethod(@TStatArray.Average, 'Average');
    RegisterMethod(@TStatArray.StandardDeviation, 'StandardDeviation');
    RegisterPropertyHelper(@TStatArrayGrows_R,@TStatArrayGrows_W,'Grows');
    RegisterPropertyHelper(@TStatArrayLength_R,@TStatArrayLength_W,'Length');
    RegisterPropertyHelper(@TStatArrayCount_R,nil,'Count');
    RegisterMethod(@TStatArray.Reset, 'Reset');
    RegisterConstructor(@TStatArrayCreate_P, 'Create');
    RegisterConstructor(@TStatArrayCreate1_P, 'Create1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StatsClasses(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStatArray(CL);
end;

 
 
{ TPSImport_StatsClasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StatsClasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StatsClasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StatsClasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StatsClasses(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
