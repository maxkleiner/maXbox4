unit uPSI_JvGenetic;
{
  genalgo
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
  TPSImport_JvGenetic = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvGenetic(CL: TPSPascalCompiler);
procedure SIRegister_JvGenetic(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvGenetic(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvGenetic(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,JvTypes
  ,JvComponent
  ,JvGenetic
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvGenetic]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvGenetic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvGenetic') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvGenetic') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure NewGeneration');
    RegisterMethod('Procedure NextGeneration');
    RegisterMethod('Function GetMember( Index : Integer) : PByte');
    RegisterMethod('Function GetAverage : Real');
    RegisterProperty('Generation', 'Integer', iptr);
    RegisterProperty('MemberSize', 'Integer', iptrw);
    RegisterProperty('Numbers', 'Integer', iptrw);
    RegisterProperty('OnTestMember', 'TOnTest', iptrw);
    RegisterProperty('CrossoverProbability', 'Real', iptrw);
    RegisterProperty('MutateProbability', 'Real', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvGenetic(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TOnTest', 'Function ( Sender : TObject; Index : Integer; Member '
   //+': PByte) : Byte');
  SIRegister_TJvGenetic(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvGeneticMutateProbability_W(Self: TJvGenetic; const T: Real);
begin Self.MutateProbability := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticMutateProbability_R(Self: TJvGenetic; var T: Real);
begin T := Self.MutateProbability; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticCrossoverProbability_W(Self: TJvGenetic; const T: Real);
begin Self.CrossoverProbability := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticCrossoverProbability_R(Self: TJvGenetic; var T: Real);
begin T := Self.CrossoverProbability; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticOnTestMember_W(Self: TJvGenetic; const T: TOnTest);
begin Self.OnTestMember := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticOnTestMember_R(Self: TJvGenetic; var T: TOnTest);
begin T := Self.OnTestMember; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticNumbers_W(Self: TJvGenetic; const T: Integer);
begin Self.Numbers := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticNumbers_R(Self: TJvGenetic; var T: Integer);
begin T := Self.Numbers; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticMemberSize_W(Self: TJvGenetic; const T: Integer);
begin Self.MemberSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticMemberSize_R(Self: TJvGenetic; var T: Integer);
begin T := Self.MemberSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvGeneticGeneration_R(Self: TJvGenetic; var T: Integer);
begin T := Self.Generation; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvGenetic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvGenetic) do begin
    RegisterConstructor(@TJvGenetic.Create, 'Create');
    RegisterMethod(@TJvGenetic.Destroy, 'Free');
    RegisterMethod(@TJvGenetic.NewGeneration, 'NewGeneration');
    RegisterMethod(@TJvGenetic.NextGeneration, 'NextGeneration');
    RegisterMethod(@TJvGenetic.GetMember, 'GetMember');
    RegisterMethod(@TJvGenetic.GetAverage, 'GetAverage');
    RegisterPropertyHelper(@TJvGeneticGeneration_R,nil,'Generation');
    RegisterPropertyHelper(@TJvGeneticMemberSize_R,@TJvGeneticMemberSize_W,'MemberSize');
    RegisterPropertyHelper(@TJvGeneticNumbers_R,@TJvGeneticNumbers_W,'Numbers');
    RegisterPropertyHelper(@TJvGeneticOnTestMember_R,@TJvGeneticOnTestMember_W,'OnTestMember');
    RegisterPropertyHelper(@TJvGeneticCrossoverProbability_R,@TJvGeneticCrossoverProbability_W,'CrossoverProbability');
    RegisterPropertyHelper(@TJvGeneticMutateProbability_R,@TJvGeneticMutateProbability_W,'MutateProbability');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvGenetic(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvGenetic(CL);
end;

 
 
{ TPSImport_JvGenetic }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvGenetic.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvGenetic(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvGenetic.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvGenetic(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
