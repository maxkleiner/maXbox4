unit uPSI_JclParseUses;
{
  parse the unit code
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
  TPSImport_JclParseUses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TUnitGoal(CL: TPSPascalCompiler);
procedure SIRegister_TLibraryGoal(CL: TPSPascalCompiler);
procedure SIRegister_TProgramGoal(CL: TPSPascalCompiler);
procedure SIRegister_TCustomGoal(CL: TPSPascalCompiler);
procedure SIRegister_TUsesList(CL: TPSPascalCompiler);
procedure SIRegister_JclParseUses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclParseUses_Routines(S: TPSExec);
procedure RIRegister_TUnitGoal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLibraryGoal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProgramGoal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomGoal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TUsesList(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclParseUses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,JclParseUses
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclParseUses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TUnitGoal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGoal', 'TUnitGoal') do
  with CL.AddClassN(CL.FindClass('TCustomGoal'),'TUnitGoal') do
  begin
    RegisterMethod('Constructor Create( Text : PChar)');
    RegisterProperty('TextAfterImpl', 'string', iptr);
    RegisterProperty('TextAfterIntf', 'string', iptr);
    RegisterProperty('TextBeforeIntf', 'string', iptr);
    RegisterProperty('UsesImpl', 'TUsesList', iptr);
    RegisterProperty('UsesIntf', 'TUsesList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLibraryGoal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGoal', 'TLibraryGoal') do
  with CL.AddClassN(CL.FindClass('TCustomGoal'),'TLibraryGoal') do
  begin
    RegisterMethod('Constructor Create( Text : PChar)');
    RegisterProperty('TextAfterUses', 'string', iptr);
    RegisterProperty('TextBeforeUses', 'string', iptr);
    RegisterProperty('UsesList', 'TUsesList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProgramGoal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGoal', 'TProgramGoal') do
  with CL.AddClassN(CL.FindClass('TCustomGoal'),'TProgramGoal') do
  begin
    RegisterMethod('Constructor Create( Text : PChar)');
    RegisterProperty('TextAfterUses', 'string', iptr);
    RegisterProperty('TextBeforeUses', 'string', iptr);
    RegisterProperty('UsesList', 'TUsesList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomGoal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCustomGoal') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomGoal') do
  begin
    RegisterMethod('Constructor Create( Text : PChar)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TUsesList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TUsesList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TUsesList') do begin
    RegisterMethod('Constructor Create( const AText : PChar)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Add( const UnitName : string) : Integer');
    RegisterMethod('Function IndexOf( const UnitName : string) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const UnitName : string)');
    RegisterMethod('Procedure Remove( Index : Integer)');
    RegisterProperty('Text', 'string', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'string Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclParseUses(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EUsesListError');
  SIRegister_TUsesList(CL);
  SIRegister_TCustomGoal(CL);
  SIRegister_TProgramGoal(CL);
  SIRegister_TLibraryGoal(CL);
  SIRegister_TUnitGoal(CL);
 CL.AddDelphiFunction('Function CreateGoal( Text : PChar) : TCustomGoal');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TUnitGoalUsesIntf_R(Self: TUnitGoal; var T: TUsesList);
begin T := Self.UsesIntf; end;

(*----------------------------------------------------------------------------*)
procedure TUnitGoalUsesImpl_R(Self: TUnitGoal; var T: TUsesList);
begin T := Self.UsesImpl; end;

(*----------------------------------------------------------------------------*)
procedure TUnitGoalTextBeforeIntf_R(Self: TUnitGoal; var T: string);
begin T := Self.TextBeforeIntf; end;

(*----------------------------------------------------------------------------*)
procedure TUnitGoalTextAfterIntf_R(Self: TUnitGoal; var T: string);
begin T := Self.TextAfterIntf; end;

(*----------------------------------------------------------------------------*)
procedure TUnitGoalTextAfterImpl_R(Self: TUnitGoal; var T: string);
begin T := Self.TextAfterImpl; end;

(*----------------------------------------------------------------------------*)
procedure TLibraryGoalUsesList_R(Self: TLibraryGoal; var T: TUsesList);
begin T := Self.UsesList; end;

(*----------------------------------------------------------------------------*)
procedure TLibraryGoalTextBeforeUses_R(Self: TLibraryGoal; var T: string);
begin T := Self.TextBeforeUses; end;

(*----------------------------------------------------------------------------*)
procedure TLibraryGoalTextAfterUses_R(Self: TLibraryGoal; var T: string);
begin T := Self.TextAfterUses; end;

(*----------------------------------------------------------------------------*)
procedure TProgramGoalUsesList_R(Self: TProgramGoal; var T: TUsesList);
begin T := Self.UsesList; end;

(*----------------------------------------------------------------------------*)
procedure TProgramGoalTextBeforeUses_R(Self: TProgramGoal; var T: string);
begin T := Self.TextBeforeUses; end;

(*----------------------------------------------------------------------------*)
procedure TProgramGoalTextAfterUses_R(Self: TProgramGoal; var T: string);
begin T := Self.TextAfterUses; end;

(*----------------------------------------------------------------------------*)
procedure TUsesListItems_R(Self: TUsesList; var T: string; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TUsesListCount_R(Self: TUsesList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TUsesListText_R(Self: TUsesList; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclParseUses_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateGoal, 'CreateGoal', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUnitGoal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUnitGoal) do
  begin
    RegisterConstructor(@TUnitGoal.Create, 'Create');
    RegisterPropertyHelper(@TUnitGoalTextAfterImpl_R,nil,'TextAfterImpl');
    RegisterPropertyHelper(@TUnitGoalTextAfterIntf_R,nil,'TextAfterIntf');
    RegisterPropertyHelper(@TUnitGoalTextBeforeIntf_R,nil,'TextBeforeIntf');
    RegisterPropertyHelper(@TUnitGoalUsesImpl_R,nil,'UsesImpl');
    RegisterPropertyHelper(@TUnitGoalUsesIntf_R,nil,'UsesIntf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLibraryGoal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLibraryGoal) do
  begin
    RegisterConstructor(@TLibraryGoal.Create, 'Create');
    RegisterPropertyHelper(@TLibraryGoalTextAfterUses_R,nil,'TextAfterUses');
    RegisterPropertyHelper(@TLibraryGoalTextBeforeUses_R,nil,'TextBeforeUses');
    RegisterPropertyHelper(@TLibraryGoalUsesList_R,nil,'UsesList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProgramGoal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProgramGoal) do
  begin
    RegisterConstructor(@TProgramGoal.Create, 'Create');
    RegisterPropertyHelper(@TProgramGoalTextAfterUses_R,nil,'TextAfterUses');
    RegisterPropertyHelper(@TProgramGoalTextBeforeUses_R,nil,'TextBeforeUses');
    RegisterPropertyHelper(@TProgramGoalUsesList_R,nil,'UsesList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomGoal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomGoal) do
  begin
    RegisterVirtualConstructor(@TCustomGoal.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUsesList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUsesList) do begin
    RegisterConstructor(@TUsesList.Create, 'Create');
    RegisterMethod(@TUsesList.Destroy, 'Free');
    RegisterMethod(@TUsesList.Add, 'Add');
    RegisterMethod(@TUsesList.IndexOf, 'IndexOf');
    RegisterMethod(@TUsesList.Insert, 'Insert');
    RegisterMethod(@TUsesList.Remove, 'Remove');
    RegisterPropertyHelper(@TUsesListText_R,nil,'Text');
    RegisterPropertyHelper(@TUsesListCount_R,nil,'Count');
    RegisterPropertyHelper(@TUsesListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclParseUses(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EUsesListError) do
  RIRegister_TUsesList(CL);
  RIRegister_TCustomGoal(CL);
  RIRegister_TProgramGoal(CL);
  RIRegister_TLibraryGoal(CL);
  RIRegister_TUnitGoal(CL);
end;

 
 
{ TPSImport_JclParseUses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclParseUses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclParseUses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclParseUses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclParseUses(ri);
  RIRegister_JclParseUses_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
