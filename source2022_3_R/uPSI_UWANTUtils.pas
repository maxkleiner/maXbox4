unit uPSI_UWANTUtils;
{
may last in the past

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
  TPSImport_UWANTUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_UWANTUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UWANTUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   MaxDOM
  ,UWANTUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UWANTUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_UWANTUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TErrorSeverity', '( errwantNone, errwantInfo, errwantHint, errwantWarning, errwantError, errwantFatal )');
 CL.AddDelphiFunction('Function ErrTag( Sev : TErrorSeverity) : String');
 CL.AddDelphiFunction('Function MakeInt64( LowInt32, HiInt32 : Cardinal) : Int64');
 CL.AddDelphiFunction('Function FolderContent( const APath : String) : INode');
 CL.AddDelphiFunction('Function FindFiles2( const AFolder, AMask : String; Attrs : Integer; AList : TStrings; ASearchSubdirs : Boolean) : Boolean');
 CL.AddDelphiFunction('Function ErrorSeverityStr( ASeverity : TErrorSeverity) : String');
 CL.AddDelphiFunction('Function IsParameterOptional( AParamDef : INode) : Boolean');
 CL.AddDelphiFunction('Function ExtractMethodName( const S : String) : String');
 CL.AddDelphiFunction('Function LineNoOf( ANode : INode) : Integer');
 CL.AddDelphiFunction('Function ColNoOf( ANode : INode) : Integer');
 CL.AddDelphiFunction('Function WANTBoolToStr( AValue : Boolean) : String');
 CL.AddDelphiFunction('Function WANTStrToBool( const AValue : String; dEFAULT : bOOLEAN) : Boolean');
 CL.AddDelphiFunction('Function StrDefault( const S, Default : String) : String');
 CL.AddDelphiFunction('Function PluralNoun( Count : Integer; const S : String) : String');
 CL.AddDelphiFunction('Function IsUnqualifiedName( const AName : String) : Boolean');
 CL.AddDelphiFunction('Function IsModuleTag( const ATag : String) : Boolean');
 CL.AddDelphiFunction('Function IsCallableTag( const ATag : String) : Boolean');
 CL.AddDelphiFunction('Function IsConditionalTag( const ATag : String) : Boolean');
 CL.AddDelphiFunction('Function IsMethodTag( const ATag : String) : Boolean');
 CL.AddDelphiFunction('Function StripDriveFromPath( const AFileName : String) : String');
 CL.AddDelphiFunction('Function TotalTime( NumTicks : Int64) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_UWANTUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ErrTag, 'ErrTag', cdRegister);
 S.RegisterDelphiFunction(@MakeInt64, 'MakeInt64', cdRegister);
 S.RegisterDelphiFunction(@FolderContent, 'FolderContent', cdRegister);
 S.RegisterDelphiFunction(@FindFiles, 'FindFiles2', cdRegister);
 S.RegisterDelphiFunction(@ErrorSeverityStr, 'ErrorSeverityStr', cdRegister);
 S.RegisterDelphiFunction(@IsParameterOptional, 'IsParameterOptional', cdRegister);
 S.RegisterDelphiFunction(@ExtractMethodName, 'ExtractMethodName', cdRegister);
 S.RegisterDelphiFunction(@LineNoOf, 'LineNoOf', cdRegister);
 S.RegisterDelphiFunction(@ColNoOf, 'ColNoOf', cdRegister);
 S.RegisterDelphiFunction(@WANTBoolToStr, 'WANTBoolToStr', cdRegister);
 S.RegisterDelphiFunction(@WANTStrToBool, 'WANTStrToBool', cdRegister);
 S.RegisterDelphiFunction(@StrDefault, 'StrDefault', cdRegister);
 S.RegisterDelphiFunction(@PluralNoun, 'PluralNoun', cdRegister);
 S.RegisterDelphiFunction(@IsUnqualifiedName, 'IsUnqualifiedName', cdRegister);
 S.RegisterDelphiFunction(@IsModuleTag, 'IsModuleTag', cdRegister);
 S.RegisterDelphiFunction(@IsCallableTag, 'IsCallableTag', cdRegister);
 S.RegisterDelphiFunction(@IsConditionalTag, 'IsConditionalTag', cdRegister);
 S.RegisterDelphiFunction(@IsMethodTag, 'IsMethodTag', cdRegister);
 S.RegisterDelphiFunction(@StripDriveFromPath, 'StripDriveFromPath', cdRegister);
 S.RegisterDelphiFunction(@TotalTime, 'TotalTime', cdRegister);
end;

 
 
{ TPSImport_UWANTUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UWANTUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UWANTUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UWANTUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UWANTUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
