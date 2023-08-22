unit uPSI_PJEnvVars;
{
   new version
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
  TPSImport_PJEnvVars = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPJEnvVars(CL: TPSPascalCompiler);
procedure SIRegister_TPJEnvVarsEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TPJEnvironmentVars(CL: TPSPascalCompiler);
procedure SIRegister_PJEnvVars(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPJEnvVars(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPJEnvVarsEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPJEnvironmentVars(CL: TPSRuntimeClassImporter);
procedure RIRegister_PJEnvVars_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ,PJEnvVars
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PJEnvVars]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJEnvVars(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TPJEnvVars') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TPJEnvVars') do
  begin
    RegisterMethod('Procedure EnumNames( Callback : TPJEnvVarsEnum; Data : ___Pointer)');
    RegisterMethod('Function GetEnumerator : TPJEnvVarsEnumerator');
    RegisterMethod('Procedure DeleteVar( const Name : string)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Values', 'string string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJEnvVarsEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPJEnvVarsEnumerator') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPJEnvVarsEnumerator') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetCurrent : string');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJEnvironmentVars(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPJEnvironmentVars') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPJEnvironmentVars') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Function Exists( const VarName : string) : Boolean');
    RegisterMethod('Function GetValue( const VarName : string) : string');
    RegisterMethod('Function SetValue( const VarName, VarValue : string) : Integer');
    RegisterMethod('Function Delete( const VarName : string) : Integer');
    RegisterMethod('Function CreateBlock( const NewEnv : TStrings; const IncludeCurrent : Boolean; const Buffer : Pointer; const BufSize : Integer) : Integer');
    RegisterMethod('Function BlockSize : Integer');
    RegisterMethod('Function Expand( const Str : string) : string');
    RegisterMethod('Function GetAll( const Vars : TStrings) : Integer;');
    RegisterMethod('Function GetAll1 : TPJEnvironmentVarArray;');
    RegisterMethod('Procedure GetAllNames( const Names : TStrings);');
    RegisterMethod('Function GetAllNames1 : TStringDynArray;');
    RegisterMethod('Procedure EnumNames( Callback : TPJEnvVarsEnum; Data : ___Pointer)');
    RegisterMethod('Procedure EnumVars( Callback : TPJEnvVarsEnumEx; Data : ___Pointer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PJEnvVars(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('TStringDynArray', 'array of string');
 CL.AddDelphiFunction('Function GetEnvVarValue( const VarName : string) : string');
 CL.AddDelphiFunction('Function SetEnvVarValue( const VarName, VarValue : string) : Integer');
 CL.AddDelphiFunction('Function DeleteEnvVar( const VarName : string) : Integer');
 CL.AddDelphiFunction('Function CreateEnvBlock( const NewEnv : TStrings; const IncludeCurrent : Boolean; const Buffer : string; const BufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function ExpandEnvVars( const Str : string) : string');
 CL.AddDelphiFunction('Function GetAllEnvVars( const Vars : TStrings) : Integer');
 CL.AddDelphiFunction('Procedure GetAllEnvVarNames( const Names : TStrings);');
 CL.AddDelphiFunction('Function GetAllEnvVarNames1 : TStringDynArray;');
 CL.AddDelphiFunction('Function EnvBlockSize : Integer');
  CL.AddTypeS('TPJEnvironmentVar', 'record Name : string; Value : string; end');
  CL.AddTypeS('TPJEnvironmentVarArray', 'array of TPJEnvironmentVar');
  CL.AddTypeS('TPJEnvVarsEnum', 'Procedure ( const VarName : string; Data : TObject)');
  CL.AddTypeS('TPJEnvVarsEnumEx', 'Procedure ( const EnvVar : TPJEnvironmentVar; Data : TObject)');
  SIRegister_TPJEnvironmentVars(CL);
  SIRegister_TPJEnvVarsEnumerator(CL);
  SIRegister_TPJEnvVars(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPJEnvVarsValues_W(Self: TPJEnvVars; const T: string; const t1: string);
begin Self.Values[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJEnvVarsValues_R(Self: TPJEnvVars; var T: string; const t1: string);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPJEnvVarsCount_R(Self: TPJEnvVars; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TPJEnvVarsEnumeratorCurrent_R(Self: TPJEnvVarsEnumerator; var T: string);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
Function TPJEnvironmentVarsGetAllNames1_P(Self: TPJEnvironmentVars) : TStringDynArray;
Begin Result := Self.GetAllNames; END;

(*----------------------------------------------------------------------------*)
Procedure TPJEnvironmentVarsGetAllNames_P(Self: TPJEnvironmentVars;  const Names : TStrings);
Begin Self.GetAllNames(Names); END;

(*----------------------------------------------------------------------------*)
Function TPJEnvironmentVarsGetAll1_P(Self: TPJEnvironmentVars) : TPJEnvironmentVarArray;
Begin Result := Self.GetAll; END;

(*----------------------------------------------------------------------------*)
Function TPJEnvironmentVarsGetAll_P(Self: TPJEnvironmentVars;  const Vars : TStrings) : Integer;
Begin Result := Self.GetAll(Vars); END;

(*----------------------------------------------------------------------------*)
Function GetAllEnvVarNames1_P : TStringDynArray;
Begin Result := PJEnvVars.GetAllEnvVarNames; END;

(*----------------------------------------------------------------------------*)
Procedure GetAllEnvVarNames_P( const Names : TStrings);
Begin PJEnvVars.GetAllEnvVarNames(Names); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJEnvVars(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJEnvVars) do
  begin
    RegisterMethod(@TPJEnvVars.EnumNames, 'EnumNames');
    RegisterMethod(@TPJEnvVars.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TPJEnvVars.DeleteVar, 'DeleteVar');
    RegisterPropertyHelper(@TPJEnvVarsCount_R,nil,'Count');
    RegisterPropertyHelper(@TPJEnvVarsValues_R,@TPJEnvVarsValues_W,'Values');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJEnvVarsEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJEnvVarsEnumerator) do
  begin
    RegisterConstructor(@TPJEnvVarsEnumerator.Create, 'Create');
     RegisterMethod(@TPJEnvVarsEnumerator.Destroy, 'Free');
    RegisterMethod(@TPJEnvVarsEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TPJEnvVarsEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TPJEnvVarsEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJEnvironmentVars(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJEnvironmentVars) do begin
    RegisterConstructor(@TPJEnvironmentVars.Create, 'Create');
    RegisterMethod(@TPJEnvironmentVars.Count, 'Count');
    RegisterMethod(@TPJEnvironmentVars.Exists, 'Exists');
    RegisterMethod(@TPJEnvironmentVars.GetValue, 'GetValue');
    RegisterMethod(@TPJEnvironmentVars.SetValue, 'SetValue');
    RegisterMethod(@TPJEnvironmentVars.Delete, 'Delete');
    RegisterMethod(@TPJEnvironmentVars.CreateBlock, 'CreateBlock');
    RegisterMethod(@TPJEnvironmentVars.BlockSize, 'BlockSize');
    RegisterMethod(@TPJEnvironmentVars.Expand, 'Expand');
    RegisterMethod(@TPJEnvironmentVarsGetAll_P, 'GetAll');
    RegisterMethod(@TPJEnvironmentVarsGetAll1_P, 'GetAll1');
    RegisterMethod(@TPJEnvironmentVarsGetAllNames_P, 'GetAllNames');
    RegisterMethod(@TPJEnvironmentVarsGetAllNames1_P, 'GetAllNames1');
    RegisterMethod(@TPJEnvironmentVars.EnumNames, 'EnumNames');
    RegisterMethod(@TPJEnvironmentVars.EnumVars, 'EnumVars');
  end;
   RIRegister_TPJEnvironmentVars(CL);
  RIRegister_TPJEnvVarsEnumerator(CL);
  RIRegister_TPJEnvVars(CL);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PJEnvVars_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetEnvVarValue, 'GetEnvVarValue', cdRegister);
 S.RegisterDelphiFunction(@SetEnvVarValue, 'SetEnvVarValue', cdRegister);
 S.RegisterDelphiFunction(@DeleteEnvVar, 'DeleteEnvVar', cdRegister);
 S.RegisterDelphiFunction(@CreateEnvBlock, 'CreateEnvBlock', cdRegister);
 S.RegisterDelphiFunction(@ExpandEnvVars, 'ExpandEnvVars', cdRegister);
 S.RegisterDelphiFunction(@GetAllEnvVars, 'GetAllEnvVars', cdRegister);
 S.RegisterDelphiFunction(@GetAllEnvVarNames, 'GetAllEnvVarNames', cdRegister);
 S.RegisterDelphiFunction(@GetAllEnvVarNames1_P, 'GetAllEnvVarNames1', cdRegister);
 S.RegisterDelphiFunction(@EnvBlockSize, 'EnvBlockSize', cdRegister);
 { RIRegister_TPJEnvironmentVars(CL);
  RIRegister_TPJEnvVarsEnumerator(CL);
  RIRegister_TPJEnvVars(CL);}
end;

 
 
{ TPSImport_PJEnvVars }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJEnvVars.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PJEnvVars(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJEnvVars.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_PJEnvVars(ri);
  RIRegister_PJEnvVars_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
