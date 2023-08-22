unit uPSI_SMScript;
{
   beta for a script executor
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
  TPSImport_SMScript = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TSMScriptExecutor(CL: TPSPascalCompiler);
procedure SIRegister_TSMSEModules(CL: TPSPascalCompiler);
procedure SIRegister_TSMSEModule(CL: TPSPascalCompiler);
procedure SIRegister_TSMSEProcedures(CL: TPSPascalCompiler);
procedure SIRegister_TSMSEProcedure(CL: TPSPascalCompiler);
procedure SIRegister_TSMSEError(CL: TPSPascalCompiler);
procedure SIRegister_SMScript(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SMScript_Routines(S: TPSExec);
procedure RIRegister_TSMScriptExecutor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSMSEModules(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSMSEModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSMSEProcedures(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSMSEProcedure(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSMSEError(CL: TPSRuntimeClassImporter);
procedure RIRegister_SMScript(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ActiveX
  ,SMScript
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SMScript]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSMScriptExecutor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSMScriptExecutor') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSMScriptExecutor') do begin
    RegisterProperty('ScriptControl', 'Variant', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
     RegisterMethod('Procedure LoadScriptFunctions( const ScriptLib : string; list : TStrings; ClearList : Boolean)');
    RegisterMethod('Procedure LoadMacro( const FileName : string)');
    RegisterMethod('Procedure Prepare');
    RegisterMethod('Procedure ParseModules');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure AddCode( const Code : string)');
    RegisterMethod('Function Eval( const Expression : string) : Variant');
    RegisterMethod('Procedure ExecuteStatement( const Statement : string)');
    RegisterMethod('Function Run( const ProcedureName : string; Parameters : OLEVariant) : OLEVariant');
    RegisterMethod('Procedure AddObject( const Name : WideString; const Obj : IDispatch; AddMembers : WordBool)');
    RegisterProperty('LastError', 'TSMSEError', iptr);
    RegisterProperty('AllowUI', 'Boolean', iptrw);
    RegisterProperty('Language', 'TSMScriptLanguage', iptrw);
    RegisterProperty('LanguageStr', 'string', iptrw);
    RegisterProperty('Modules', 'TSMSEModules', iptrw);
    RegisterProperty('TimeOut', 'Integer', iptrw);
    RegisterProperty('UseSafeSubset', 'Boolean', iptrw);
    RegisterProperty('ScriptBody', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSMSEModules(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TSMSEModules') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TSMSEModules') do
  begin
    RegisterMethod('Constructor Create( AScriptExecutor : TSMScriptExecutor)');
    RegisterMethod('Function GetModuleByName( const Value : string) : TSMSEModule');
    RegisterProperty('Items', 'TSMSEModule Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSMSEModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TSMSEModule') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TSMSEModule') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AddCode( const Code : string)');
    RegisterMethod('Function Eval( const Expression : string) : Variant');
    RegisterMethod('Procedure ExecuteStatement( const Statement : string)');
    RegisterMethod('Function Run( const ProcedureName : string; Parameters : OLEVariant) : OLEVariant');
    RegisterProperty('ModuleName', 'string', iptrw);
    RegisterProperty('Procedures', 'TSMSEProcedures', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSMSEProcedures(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TSMSEProcedures') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TSMSEProcedures') do
  begin
    RegisterMethod('Constructor Create( AModule : TSMSEModule)');
    RegisterProperty('Items', 'TSMSEProcedure Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSMSEProcedure(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TSMSEProcedure') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TSMSEProcedure') do
  begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('ProcName', 'string', iptrw);
    RegisterProperty('NumArg', 'Integer', iptrw);
    RegisterProperty('ProcedureType', 'TSMSEProcedureType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSMSEError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSMSEError') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSMSEError') do
  begin
    RegisterMethod('Constructor Create( AScriptExecutor : TSMScriptExecutor)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Number', 'string', iptrw);
    RegisterProperty('Source', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Line', 'Integer', iptrw);
    RegisterProperty('Column', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SMScript(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSMScriptExecutor');
  SIRegister_TSMSEError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSMSEModule');
  CL.AddTypeS('TSMSEProcedureType', '( ptProcedure, ptFunction )');
  SIRegister_TSMSEProcedure(CL);
  SIRegister_TSMSEProcedures(CL);
  SIRegister_TSMSEModule(CL);
  SIRegister_TSMSEModules(CL);
  CL.AddTypeS('TSMScriptLanguage', '( slCustom, slVBScript, slJavaScript )');
  SIRegister_TSMScriptExecutor(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorScriptBody_W(Self: TSMScriptExecutor; const T: TStrings);
begin Self.ScriptBody := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorScriptBody_R(Self: TSMScriptExecutor; var T: TStrings);
begin T := Self.ScriptBody; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorUseSafeSubset_W(Self: TSMScriptExecutor; const T: Boolean);
begin Self.UseSafeSubset := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorUseSafeSubset_R(Self: TSMScriptExecutor; var T: Boolean);
begin T := Self.UseSafeSubset; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorTimeOut_W(Self: TSMScriptExecutor; const T: Integer);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorTimeOut_R(Self: TSMScriptExecutor; var T: Integer);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorModules_W(Self: TSMScriptExecutor; const T: TSMSEModules);
begin Self.Modules := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorModules_R(Self: TSMScriptExecutor; var T: TSMSEModules);
begin T := Self.Modules; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorLanguageStr_W(Self: TSMScriptExecutor; const T: string);
begin Self.LanguageStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorLanguageStr_R(Self: TSMScriptExecutor; var T: string);
begin T := Self.LanguageStr; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorLanguage_W(Self: TSMScriptExecutor; const T: TSMScriptLanguage);
begin Self.Language := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorLanguage_R(Self: TSMScriptExecutor; var T: TSMScriptLanguage);
begin T := Self.Language; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorAllowUI_W(Self: TSMScriptExecutor; const T: Boolean);
begin Self.AllowUI := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorAllowUI_R(Self: TSMScriptExecutor; var T: Boolean);
begin T := Self.AllowUI; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorLastError_R(Self: TSMScriptExecutor; var T: TSMSEError);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorScriptControl_W(Self: TSMScriptExecutor; const T: Variant);
Begin Self.ScriptControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMScriptExecutorScriptControl_R(Self: TSMScriptExecutor; var T: Variant);
Begin T := Self.ScriptControl; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEModulesItems_W(Self: TSMSEModules; const T: TSMSEModule; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEModulesItems_R(Self: TSMSEModules; var T: TSMSEModule; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEModuleProcedures_W(Self: TSMSEModule; const T: TSMSEProcedures);
begin Self.Procedures := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEModuleProcedures_R(Self: TSMSEModule; var T: TSMSEProcedures);
begin T := Self.Procedures; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEModuleModuleName_W(Self: TSMSEModule; const T: string);
begin Self.ModuleName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEModuleModuleName_R(Self: TSMSEModule; var T: string);
begin T := Self.ModuleName; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProceduresItems_W(Self: TSMSEProcedures; const T: TSMSEProcedure; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProceduresItems_R(Self: TSMSEProcedures; var T: TSMSEProcedure; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProcedureProcedureType_W(Self: TSMSEProcedure; const T: TSMSEProcedureType);
begin Self.ProcedureType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProcedureProcedureType_R(Self: TSMSEProcedure; var T: TSMSEProcedureType);
begin T := Self.ProcedureType; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProcedureNumArg_W(Self: TSMSEProcedure; const T: Integer);
begin Self.NumArg := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProcedureNumArg_R(Self: TSMSEProcedure; var T: Integer);
begin T := Self.NumArg; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProcedureProcName_W(Self: TSMSEProcedure; const T: string);
begin Self.ProcName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEProcedureProcName_R(Self: TSMSEProcedure; var T: string);
begin T := Self.ProcName; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorColumn_W(Self: TSMSEError; const T: Integer);
begin Self.Column := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorColumn_R(Self: TSMSEError; var T: Integer);
begin T := Self.Column; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorLine_W(Self: TSMSEError; const T: Integer);
begin Self.Line := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorLine_R(Self: TSMSEError; var T: Integer);
begin T := Self.Line; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorText_W(Self: TSMSEError; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorText_R(Self: TSMSEError; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorDescription_W(Self: TSMSEError; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorDescription_R(Self: TSMSEError; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorSource_W(Self: TSMSEError; const T: string);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorSource_R(Self: TSMSEError; var T: string);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorNumber_W(Self: TSMSEError; const T: string);
begin Self.Number := T; end;

(*----------------------------------------------------------------------------*)
procedure TSMSEErrorNumber_R(Self: TSMSEError; var T: string);
begin T := Self.Number; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SMScript_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSMScriptExecutor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMScriptExecutor) do begin
    RegisterPropertyHelper(@TSMScriptExecutorScriptControl_R,@TSMScriptExecutorScriptControl_W,'ScriptControl');
    RegisterConstructor(@TSMScriptExecutor.Create, 'Create');
        RegisterMethod(@TSMScriptExecutor.Destroy, 'Free');
     RegisterMethod(@TSMScriptExecutor.LoadScriptFunctions, 'LoadScriptFunctions');
    RegisterMethod(@TSMScriptExecutor.LoadMacro, 'LoadMacro');
    RegisterMethod(@TSMScriptExecutor.Prepare, 'Prepare');
    RegisterMethod(@TSMScriptExecutor.ParseModules, 'ParseModules');
    RegisterMethod(@TSMScriptExecutor.Reset, 'Reset');
    RegisterMethod(@TSMScriptExecutor.AddCode, 'AddCode');
    RegisterMethod(@TSMScriptExecutor.Eval, 'Eval');
    RegisterMethod(@TSMScriptExecutor.ExecuteStatement, 'ExecuteStatement');
    RegisterMethod(@TSMScriptExecutor.Run, 'Run');
    RegisterMethod(@TSMScriptExecutor.AddObject, 'AddObject');
    RegisterPropertyHelper(@TSMScriptExecutorLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TSMScriptExecutorAllowUI_R,@TSMScriptExecutorAllowUI_W,'AllowUI');
    RegisterPropertyHelper(@TSMScriptExecutorLanguage_R,@TSMScriptExecutorLanguage_W,'Language');
    RegisterPropertyHelper(@TSMScriptExecutorLanguageStr_R,@TSMScriptExecutorLanguageStr_W,'LanguageStr');
    RegisterPropertyHelper(@TSMScriptExecutorModules_R,@TSMScriptExecutorModules_W,'Modules');
    RegisterPropertyHelper(@TSMScriptExecutorTimeOut_R,@TSMScriptExecutorTimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TSMScriptExecutorUseSafeSubset_R,@TSMScriptExecutorUseSafeSubset_W,'UseSafeSubset');
    RegisterPropertyHelper(@TSMScriptExecutorScriptBody_R,@TSMScriptExecutorScriptBody_W,'ScriptBody');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSMSEModules(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMSEModules) do
  begin
    RegisterConstructor(@TSMSEModules.Create, 'Create');
    RegisterMethod(@TSMSEModules.GetModuleByName, 'GetModuleByName');
    RegisterPropertyHelper(@TSMSEModulesItems_R,@TSMSEModulesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSMSEModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMSEModule) do
  begin
    RegisterConstructor(@TSMSEModule.Create, 'Create');
    RegisterMethod(@TSMSEModule.Assign, 'Assign');
    RegisterMethod(@TSMSEModule.AddCode, 'AddCode');
    RegisterMethod(@TSMSEModule.Eval, 'Eval');
    RegisterMethod(@TSMSEModule.ExecuteStatement, 'ExecuteStatement');
    RegisterMethod(@TSMSEModule.Run, 'Run');
    RegisterPropertyHelper(@TSMSEModuleModuleName_R,@TSMSEModuleModuleName_W,'ModuleName');
    RegisterPropertyHelper(@TSMSEModuleProcedures_R,@TSMSEModuleProcedures_W,'Procedures');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSMSEProcedures(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMSEProcedures) do
  begin
    RegisterConstructor(@TSMSEProcedures.Create, 'Create');
    RegisterPropertyHelper(@TSMSEProceduresItems_R,@TSMSEProceduresItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSMSEProcedure(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMSEProcedure) do
  begin
    RegisterMethod(@TSMSEProcedure.Assign, 'Assign');
    RegisterPropertyHelper(@TSMSEProcedureProcName_R,@TSMSEProcedureProcName_W,'ProcName');
    RegisterPropertyHelper(@TSMSEProcedureNumArg_R,@TSMSEProcedureNumArg_W,'NumArg');
    RegisterPropertyHelper(@TSMSEProcedureProcedureType_R,@TSMSEProcedureProcedureType_W,'ProcedureType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSMSEError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMSEError) do
  begin
    RegisterConstructor(@TSMSEError.Create, 'Create');
    RegisterMethod(@TSMSEError.Clear, 'Clear');
    RegisterPropertyHelper(@TSMSEErrorNumber_R,@TSMSEErrorNumber_W,'Number');
    RegisterPropertyHelper(@TSMSEErrorSource_R,@TSMSEErrorSource_W,'Source');
    RegisterPropertyHelper(@TSMSEErrorDescription_R,@TSMSEErrorDescription_W,'Description');
    RegisterPropertyHelper(@TSMSEErrorText_R,@TSMSEErrorText_W,'Text');
    RegisterPropertyHelper(@TSMSEErrorLine_R,@TSMSEErrorLine_W,'Line');
    RegisterPropertyHelper(@TSMSEErrorColumn_R,@TSMSEErrorColumn_W,'Column');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SMScript(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSMScriptExecutor) do
  RIRegister_TSMSEError(CL);
  with CL.Add(TSMSEModule) do
  RIRegister_TSMSEProcedure(CL);
  RIRegister_TSMSEProcedures(CL);
  RIRegister_TSMSEModule(CL);
  RIRegister_TSMSEModules(CL);
  RIRegister_TSMScriptExecutor(CL);
end;

 
 
{ TPSImport_SMScript }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SMScript.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SMScript(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SMScript.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SMScript(ri);
  RIRegister_SMScript_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
