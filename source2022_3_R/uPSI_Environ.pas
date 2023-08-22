unit uPSI_Environ;
{
fist steps to RTTI+

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
  TPSImport_Environ = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
//procedure SIRegister_TKeyProperty(CL: TPSPascalCompiler);
//procedure SIRegister_TValueProperty(CL: TPSPascalCompiler);
procedure SIRegister_TEnvironment(CL: TPSPascalCompiler);
procedure SIRegister_Environ(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_Environ_Routines(S: TPSExec);
//procedure RIRegister_TKeyProperty(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TValueProperty(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEnvironment(CL: TPSRuntimeClassImporter);
procedure RIRegister_Environ(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinProcs
  //,DsgnIntf
  ,TypInfo
  ,Environ
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Environ]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
{procedure SIRegister_TKeyProperty(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIntegerProperty', 'TKeyProperty') do
  with CL.AddClassN(CL.FindClass('TIntegerProperty'),'TKeyProperty') do
  begin
    RegisterMethod('Function GetAttributes : TPropertyAttributes');
    RegisterMethod('Procedure GetValues( Proc : TGetStrProc)');
    RegisterMethod('Function GetValue : string');
    RegisterMethod('Procedure SetValue( const Value : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TValueProperty(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringProperty', 'TValueProperty') do
  with CL.AddClassN(CL.FindClass('TStringProperty'),'TValueProperty') do
  begin
    RegisterMethod('Function GetAttributes : TPropertyAttributes');
  end;
end; }

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEnvironment(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TEnvironment') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TEnvironment') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function GetKeyName( I : Integer) : string');
    RegisterProperty('Count', 'integer', iptr);
    RegisterProperty('Values', 'string string', iptr);
    RegisterProperty('Value', 'string', iptrw);
    RegisterProperty('Key', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Environ(CL: TPSPascalCompiler);
begin
  SIRegister_TEnvironment(CL);
  //SIRegister_TValueProperty(CL);
  //SIRegister_TKeyProperty(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TEnvironmentKey_W(Self: TEnvironment; const T: integer);
begin Self.Key := T; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentKey_R(Self: TEnvironment; var T: integer);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentValue_W(Self: TEnvironment; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentValue_R(Self: TEnvironment; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentValues_R(Self: TEnvironment; var T: string; const t1: string);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentCount_R(Self: TEnvironment; var T: integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Environ_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
{procedure RIRegister_TKeyProperty(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKeyProperty) do
  begin
    RegisterMethod(@TKeyProperty.GetAttributes, 'GetAttributes');
    RegisterMethod(@TKeyProperty.GetValues, 'GetValues');
    RegisterMethod(@TKeyProperty.GetValue, 'GetValue');
    RegisterMethod(@TKeyProperty.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TValueProperty(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TValueProperty) do
  begin
    RegisterMethod(@TValueProperty.GetAttributes, 'GetAttributes');
  end;
end; }

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEnvironment(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEnvironment) do begin
    RegisterConstructor(@TEnvironment.Create, 'Create');
     RegisterMethod(@TEnvironment.Destroy, 'Free');
    RegisterMethod(@TEnvironment.GetKeyName, 'GetKeyName');
    RegisterPropertyHelper(@TEnvironmentCount_R,nil,'Count');
    RegisterPropertyHelper(@TEnvironmentValues_R,nil,'Values');
    RegisterPropertyHelper(@TEnvironmentValue_R,@TEnvironmentValue_W,'Value');
    RegisterPropertyHelper(@TEnvironmentKey_R,@TEnvironmentKey_W,'Key');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Environ(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TEnvironment(CL);
  //RIRegister_TValueProperty(CL);
  //RIRegister_TKeyProperty(CL);
end;

 
 
{ TPSImport_Environ }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Environ.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Environ(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Environ.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Environ(ri);
  RIRegister_Environ_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
