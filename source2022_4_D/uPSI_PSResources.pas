unit uPSI_PSResources;
{
Tfrom lity    https://github.com/fabriciocolombo/PascalScriptEx/tree/master/src

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
  TPSImport_PSResources = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPSUtils(CL: TPSPascalCompiler);
procedure SIRegister_PSResources(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPSUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_PSResources(CL: TPSRuntimeClassImporter);
procedure RIRegister_PSResources_Routines(S: TPSExec);


procedure Register;

implementation


uses
   Variants
  ,Types
  ,TypInfo
  ,uPSUtils
  ,PSResources, process
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PSResources]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSUtils(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPSUtils') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPSUtils') do begin
    RegisterMethod('Function GetValue( AValue : PIfRVariant) : Variant');
    RegisterMethod('Function GetAsString( APsScript : TPSScript; AValue : PIfRVariant) : UnicodeString');
    RegisterMethod('Function GetPSTypeName( APsScript : TPSScript; APSType : TPSType) : TbtString');
    RegisterMethod('Function GetMethodDeclaration( AMethodName : TbtString; APSParametersDecl : TPSParametersDecl) : TbtString');
    RegisterMethod('Function GetMethodParametersDeclaration( APSParametersDecl : TPSParametersDecl) : TbtString');
    RegisterMethod('Function GetEnumBounds( APsScript : TPSScript; AType : TPSType; out ALow, AHigh : TbtString) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PSResources(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('_sBeginCompile','String').SetString( 'Compiling');
 CL.AddConstantN('_sSuccessfullyCompiled','String').SetString( 'Succesfully compiled');
 CL.AddConstantN('_sSuccessfullyExecuted','String').SetString( 'Succesfully executed');
 CL.AddConstantN('_sRuntimeError','String').SetString( '[Runtime error] %s(%d:%d), bytecode(%d:%d): %s');
 CL.AddConstantN('_sTextNotFound','String').SetString( 'Text not found');
 CL.AddConstantN('_sUnnamed','String').SetString( 'Unnamed');
 CL.AddConstantN('_sEditorTitle','String').SetString( 'Editor');
 CL.AddConstantN('_sEditorTitleRunning','String').SetString( 'Editor - Running');
 CL.AddConstantN('_sEditorTitlePaused','String').SetString( 'Editor - Paused');
 CL.AddConstantN('_sEditorTitleStopped','String').SetString( 'Editor - Stopped');
 CL.AddConstantN('_sInputBoxTiyle','String').SetString( 'Script');
 CL.AddConstantN('_sFileNotSaved','String').SetString( 'File has not been saved, save now?');
 CL.AddConstantN('_isRunningOrPaused','LongInt').Value.ts32 := ord(isRunning) or ord(isPaused);
  SIRegister_TPSUtils(CL);
  //https://github.com/fabriciocolombo/PascalScriptEx/tree/master/src
  CL.AddDelphiFunction('function list_functions: TStringlist;');
   CL.AddDelphiFunction('function list_functions2: TStringlist;');
  CL.AddDelphiFunction('procedure InternalRaiseException(E: Exception);');
  CL.AddDelphiFunction('function ListFiles(ADirectory, AFilter: String; AList: TStrings) : Boolean;');
  CL.AddDelphiFunction('Procedure CommandToList(S : String; List : TStrings);');
   CL.AddDelphiFunction('Function list_functions3: TStringlist;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSUtils) do begin
    RegisterMethod(@TPSUtils.GetValue, 'GetValue');
    RegisterMethod(@TPSUtils.GetAsString, 'GetAsString');
    RegisterMethod(@TPSUtils.GetPSTypeName, 'GetPSTypeName');
    RegisterMethod(@TPSUtils.GetMethodDeclaration, 'GetMethodDeclaration');
    RegisterMethod(@TPSUtils.GetMethodParametersDeclaration, 'GetMethodParametersDeclaration');
    RegisterMethod(@TPSUtils.GetEnumBounds, 'GetEnumBounds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PSResources(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPSUtils(CL);
end;

procedure RIRegister_PSResources_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@list_functions, 'list_functions', cdRegister);
 S.RegisterDelphiFunction(@list_functions2, 'list_functions2', cdRegister);
 S.RegisterDelphiFunction(@list_functions3, 'list_functions3', cdRegister);
 S.RegisterDelphiFunction(@InternalRaiseException, 'InternalRaiseException', cdRegister);
 //S.RegisterDelphiFunction(@RegisterTeeSeries1_P, 'RegisterTeeSeries1', cdRegister);
 //S.RegisterDelphiFunction(@RegisterTeeFunction, 'RegisterTeeFunction', cdRegister);
 S.RegisterDelphiFunction(@ListFiles, 'ListFiles', cdRegister);
 S.RegisterDelphiFunction(@CommandToList, 'CommandToList', cdRegister);

end;


{ TPSImport_PSResources }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PSResources.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PSResources(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PSResources.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PSResources(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
