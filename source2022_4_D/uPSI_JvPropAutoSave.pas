unit uPSI_JvPropAutoSave;
{
   automax
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
  TPSImport_JvPropAutoSave = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvAutoSave(CL: TPSPascalCompiler);
procedure SIRegister_TJvRegAutoSave(CL: TPSPascalCompiler);
procedure SIRegister_JvPropAutoSave(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAutoSave(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvRegAutoSave(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvPropAutoSave(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Registry
  ,JvPropAutoSave
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvPropAutoSave]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAutoSave(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvAutoSave') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvAutoSave') do begin
    RegisterMethod('Constructor Create( Parent : TComponent)');
    RegisterMethod('Procedure SaveValue( Value : Integer);');
    RegisterMethod('Procedure SaveValue1( Value : Double);');
    RegisterMethod('Procedure SaveValue2( Value : Boolean);');
    RegisterMethod('Procedure SaveValue3( Value : string);');
    RegisterMethod('Function LoadValue( var Default : Integer) : Boolean;');
    RegisterMethod('Function LoadValue1( var Default : Double) : Boolean;');
    RegisterMethod('Function LoadValue2( var Default : Boolean) : Boolean;');
    RegisterMethod('Function LoadValue3( var Default : string) : Boolean;');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Registry', 'TJvRegAutoSave', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvRegAutoSave(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvRegAutoSave') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvRegAutoSave') do begin
    RegisterProperty('Key', 'string', iptrw);
    RegisterProperty('Path', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvPropAutoSave(CL: TPSPascalCompiler);
begin
  SIRegister_TJvRegAutoSave(CL);
  SIRegister_TJvAutoSave(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAutoSaveRegistry_W(Self: TJvAutoSave; const T: TJvRegAutoSave);
begin Self.Registry := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAutoSaveRegistry_R(Self: TJvAutoSave; var T: TJvRegAutoSave);
begin T := Self.Registry; end;

(*----------------------------------------------------------------------------*)
procedure TJvAutoSaveActive_W(Self: TJvAutoSave; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAutoSaveActive_R(Self: TJvAutoSave; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
Function TJvAutoSaveLoadValue7_P(Self: TJvAutoSave;  var Default : string) : Boolean;
Begin Result := Self.LoadValue(Default); END;

(*----------------------------------------------------------------------------*)
Function TJvAutoSaveLoadValue6_P(Self: TJvAutoSave;  var Default : Boolean) : Boolean;
Begin Result := Self.LoadValue(Default); END;

(*----------------------------------------------------------------------------*)
Function TJvAutoSaveLoadValue5_P(Self: TJvAutoSave;  var Default : Double) : Boolean;
Begin Result := Self.LoadValue(Default); END;

(*----------------------------------------------------------------------------*)
Function TJvAutoSaveLoadValue4_P(Self: TJvAutoSave;  var Default : Integer) : Boolean;
Begin Result := Self.LoadValue(Default); END;

(*----------------------------------------------------------------------------*)
Procedure TJvAutoSaveSaveValue3_P(Self: TJvAutoSave;  Value : string);
Begin Self.SaveValue(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJvAutoSaveSaveValue2_P(Self: TJvAutoSave;  Value : Boolean);
Begin Self.SaveValue(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJvAutoSaveSaveValue1_P(Self: TJvAutoSave;  Value : Double);
Begin Self.SaveValue(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJvAutoSaveSaveValue_P(Self: TJvAutoSave;  Value : Integer);
Begin Self.SaveValue(Value); END;

(*----------------------------------------------------------------------------*)
procedure TJvRegAutoSavePath_W(Self: TJvRegAutoSave; const T: string);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRegAutoSavePath_R(Self: TJvRegAutoSave; var T: string);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TJvRegAutoSaveKey_W(Self: TJvRegAutoSave; const T: string);
begin Self.Key := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRegAutoSaveKey_R(Self: TJvRegAutoSave; var T: string);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAutoSave(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAutoSave) do begin
    RegisterConstructor(@TJvAutoSave.Create, 'Create');
    RegisterMethod(@TJvAutoSaveSaveValue_P, 'SaveValue');
    RegisterMethod(@TJvAutoSaveSaveValue1_P, 'SaveValue1');
    RegisterMethod(@TJvAutoSaveSaveValue2_P, 'SaveValue2');
    RegisterMethod(@TJvAutoSaveSaveValue3_P, 'SaveValue3');
    RegisterMethod(@TJvAutoSaveLoadValue4_P, 'LoadValue');
    RegisterMethod(@TJvAutoSaveLoadValue5_P, 'LoadValue1');
    RegisterMethod(@TJvAutoSaveLoadValue6_P, 'LoadValue2');
    RegisterMethod(@TJvAutoSaveLoadValue7_P, 'LoadValue3');
    RegisterPropertyHelper(@TJvAutoSaveActive_R,@TJvAutoSaveActive_W,'Active');
    RegisterPropertyHelper(@TJvAutoSaveRegistry_R,@TJvAutoSaveRegistry_W,'Registry');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvRegAutoSave(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvRegAutoSave) do
  begin
    RegisterPropertyHelper(@TJvRegAutoSaveKey_R,@TJvRegAutoSaveKey_W,'Key');
    RegisterPropertyHelper(@TJvRegAutoSavePath_R,@TJvRegAutoSavePath_W,'Path');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPropAutoSave(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvRegAutoSave(CL);
  RIRegister_TJvAutoSave(CL);
end;

 
 
{ TPSImport_JvPropAutoSave }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPropAutoSave.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvPropAutoSave(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPropAutoSave.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvPropAutoSave(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
