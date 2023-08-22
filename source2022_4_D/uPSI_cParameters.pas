unit uPSI_cParameters;
{
from pyscripter ctools
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
  TPSImport_cParameters = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TParameterList(CL: TPSPascalCompiler);
procedure SIRegister_cParameters(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cParameters_Routines(S: TPSExec);
procedure RIRegister_TParameterList(CL: TPSRuntimeClassImporter);
procedure RIRegister_cParameters(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,UITypes
  ,Dialogs
  ,Controls
  ,cParameters
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cParameters]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TParameterList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TParameterList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TParameterList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure RegisterParameter( const AName, AValue : string; GetProc : TGetParameterProc)');
    RegisterMethod('Procedure UnRegisterParameter( const AName : string)');
    RegisterMethod('Procedure ChangeParameter( const AName, AValue : string; GetProc : TGetParameterProc; CanAdd : Boolean)');
    RegisterProperty('OnUnknownParameter', 'TUnknownParameterFunction', iptrw);
    RegisterMethod('Procedure RegisterModifier( const AName, Comment : string; AFunc : TParameterFunction)');
    RegisterMethod('Procedure UnRegisterModifier( const AName : string)');
    RegisterProperty('Modifiers', 'TStrings', iptrw);
    RegisterProperty('OnUnknownModifier', 'TUnknownParameterFunction', iptrw);
    RegisterMethod('Procedure RegisterObject( const AName : string; AObject : TObject)');
    RegisterMethod('Procedure UnRegisterObject( const AName : string)');
    RegisterMethod('Procedure RegisterProperty( const AObjectName, APropertyName : string; GetProc : TObjectPropertyFunction)');
    RegisterMethod('Procedure UnRegisterProperty( const AObjectName, APropertyName : string)');
    RegisterProperty('ObjectNames', 'TStrings', iptrw);
    RegisterProperty('Properties', 'TStrings', iptrw);
    RegisterProperty('OnUnknownObject', 'TUnknownObjectFunction', iptrw);
    RegisterProperty('OnUnknownProperty', 'TUnknownPropertyFunction', iptrw);
    RegisterMethod('Function ReplaceInText( const AText : string) : string');
    RegisterMethod('Function ReplaceInTextEx( const AText, AStartMask, AStopMask : string) : string');
    RegisterMethod('Function EvaluteCondition( const ACondition : string) : Boolean');
    RegisterMethod('Function CalcValue( const AParams : string) : string');
    RegisterMethod('Function FindValue( const AName : string; var AValue : string) : Boolean');
    RegisterMethod('Procedure ExtractParameters( const AText : string; AParams : TStrings)');
    RegisterMethod('Procedure Split( AIndex : Integer; var AName, AValue : string; DoCalc : Boolean)');
    RegisterMethod('Function MakeParameter( const AName : string) : string');
    RegisterProperty('StartMask', 'string', iptrw);
    RegisterProperty('StopMask', 'string', iptrw);
    RegisterProperty('Values', 'string string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cParameters(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TUnknownParameterFunction', 'Function ( Sender : TObject; const '
   +'AName : string; var AValue : string) : Boolean');
  CL.AddTypeS('TUnknownObjectFunction', 'Function ( Sender : TObject; const ANa'
   +'me : string; var AObject : TObject) : Boolean');
  CL.AddTypeS('TUnknownPropertyFunction', 'Function ( Sender, AObject : TObject'
   +'; const AObjectName, APropertyName : string; var AValue : string) : Boolean');
  SIRegister_TParameterList(CL);
 CL.AddDelphiFunction('Function GetPropertyValue( AObject : TObject; const AObjectName, APropertyName : string) : string');
 CL.AddDelphiFunction('Function SetMarkers( const AParameters : string) : string');
 CL.AddDelphiFunction('Function FindMarkers( var AText : string; out Start, Stop : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure ClearMarkers( var AText : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TParameterListValues_R(Self: TParameterList; var T: string; const t1: string);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListStopMask_W(Self: TParameterList; const T: string);
begin Self.StopMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListStopMask_R(Self: TParameterList; var T: string);
begin T := Self.StopMask; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListStartMask_W(Self: TParameterList; const T: string);
begin Self.StartMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListStartMask_R(Self: TParameterList; var T: string);
begin T := Self.StartMask; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownProperty_W(Self: TParameterList; const T: TUnknownPropertyFunction);
begin Self.OnUnknownProperty := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownProperty_R(Self: TParameterList; var T: TUnknownPropertyFunction);
begin T := Self.OnUnknownProperty; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownObject_W(Self: TParameterList; const T: TUnknownObjectFunction);
begin Self.OnUnknownObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownObject_R(Self: TParameterList; var T: TUnknownObjectFunction);
begin T := Self.OnUnknownObject; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListProperties_W(Self: TParameterList; const T: TStrings);
begin Self.Properties := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListProperties_R(Self: TParameterList; var T: TStrings);
begin T := Self.Properties; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListObjectNames_W(Self: TParameterList; const T: TStrings);
begin Self.ObjectNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListObjectNames_R(Self: TParameterList; var T: TStrings);
begin T := Self.ObjectNames; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownModifier_W(Self: TParameterList; const T: TUnknownParameterFunction);
begin Self.OnUnknownModifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownModifier_R(Self: TParameterList; var T: TUnknownParameterFunction);
begin T := Self.OnUnknownModifier; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListModifiers_W(Self: TParameterList; const T: TStrings);
begin Self.Modifiers := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListModifiers_R(Self: TParameterList; var T: TStrings);
begin T := Self.Modifiers; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownParameter_W(Self: TParameterList; const T: TUnknownParameterFunction);
begin Self.OnUnknownParameter := T; end;

(*----------------------------------------------------------------------------*)
procedure TParameterListOnUnknownParameter_R(Self: TParameterList; var T: TUnknownParameterFunction);
begin T := Self.OnUnknownParameter; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cParameters_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetPropertyValue, 'GetPropertyValue', cdRegister);
 S.RegisterDelphiFunction(@SetMarkers, 'SetMarkers', cdRegister);
 S.RegisterDelphiFunction(@FindMarkers, 'FindMarkers', cdRegister);
 S.RegisterDelphiFunction(@ClearMarkers, 'ClearMarkers', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParameterList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParameterList) do
  begin
    RegisterConstructor(@TParameterList.Create, 'Create');
    RegisterMethod(@TParameterList.Assign, 'Assign');
    RegisterMethod(@TParameterList.RegisterParameter, 'RegisterParameter');
    RegisterMethod(@TParameterList.UnRegisterParameter, 'UnRegisterParameter');
    RegisterMethod(@TParameterList.ChangeParameter, 'ChangeParameter');
    RegisterPropertyHelper(@TParameterListOnUnknownParameter_R,@TParameterListOnUnknownParameter_W,'OnUnknownParameter');
    RegisterMethod(@TParameterList.RegisterModifier, 'RegisterModifier');
    RegisterMethod(@TParameterList.UnRegisterModifier, 'UnRegisterModifier');
    RegisterPropertyHelper(@TParameterListModifiers_R,@TParameterListModifiers_W,'Modifiers');
    RegisterPropertyHelper(@TParameterListOnUnknownModifier_R,@TParameterListOnUnknownModifier_W,'OnUnknownModifier');
    RegisterMethod(@TParameterList.RegisterObject, 'RegisterObject');
    RegisterMethod(@TParameterList.UnRegisterObject, 'UnRegisterObject');
    RegisterMethod(@TParameterList.RegisterProperty, 'RegisterProperty');
    RegisterMethod(@TParameterList.UnRegisterProperty, 'UnRegisterProperty');
    RegisterPropertyHelper(@TParameterListObjectNames_R,@TParameterListObjectNames_W,'ObjectNames');
    RegisterPropertyHelper(@TParameterListProperties_R,@TParameterListProperties_W,'Properties');
    RegisterPropertyHelper(@TParameterListOnUnknownObject_R,@TParameterListOnUnknownObject_W,'OnUnknownObject');
    RegisterPropertyHelper(@TParameterListOnUnknownProperty_R,@TParameterListOnUnknownProperty_W,'OnUnknownProperty');
    RegisterMethod(@TParameterList.ReplaceInText, 'ReplaceInText');
    RegisterMethod(@TParameterList.ReplaceInTextEx, 'ReplaceInTextEx');
    RegisterMethod(@TParameterList.EvaluteCondition, 'EvaluteCondition');
    RegisterMethod(@TParameterList.CalcValue, 'CalcValue');
    RegisterMethod(@TParameterList.FindValue, 'FindValue');
    RegisterMethod(@TParameterList.ExtractParameters, 'ExtractParameters');
    RegisterMethod(@TParameterList.Split, 'Split');
    RegisterMethod(@TParameterList.MakeParameter, 'MakeParameter');
    RegisterPropertyHelper(@TParameterListStartMask_R,@TParameterListStartMask_W,'StartMask');
    RegisterPropertyHelper(@TParameterListStopMask_R,@TParameterListStopMask_W,'StopMask');
    RegisterPropertyHelper(@TParameterListValues_R,nil,'Values');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cParameters(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TParameterList(CL);
end;

 
 
{ TPSImport_cParameters }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cParameters.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cParameters(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cParameters.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cParameters(ri);
  RIRegister_cParameters_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
