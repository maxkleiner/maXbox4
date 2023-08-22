unit uPSI_RegUtils;
{
   reg with variants and arrays
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
  TPSImport_RegUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_RegUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_RegUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,registry
  ,RegUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RegUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_RegUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure DefWriteToRegistry( const OtherKeys, ParamNames : array of string; const Values : array of Variant)');
 CL.AddDelphiFunction('Procedure WriteToRegistry( aRootKey : HKEY; const OtherKeys, ParamNames : array of string; const Values : array of Variant)');
 CL.AddDelphiFunction('Function ReadFromRegistry( aRootKey : HKEY; const OtherKeys, ParamNames : array of string) : Variant');
 CL.AddDelphiFunction('Function DefReadFromRegistry( const OtherKeys, ParamNames : array of string) : Variant');
 CL.AddDelphiFunction('Function AllSubKey( aRootKey : HKEY; const ForPath : array of string) : Variant');
 CL.AddDelphiFunction('Function DefAllSubKey( const ForPath : array of string) : Variant');
 CL.AddDelphiFunction('Function SaveRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 CL.AddDelphiFunction('Function LoadRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 CL.AddDelphiFunction('Function AltSaveRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 CL.AddDelphiFunction('Function AltLoadRegKey( const FileName : String; const ForKey : array of string) : Boolean');
 CL.AddDelphiFunction('Function GetKeyForParValue( const aRootKey, ParName, ParValue : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_RegUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DefWriteToRegistry, 'DefWriteToRegistry', cdRegister);
 S.RegisterDelphiFunction(@WriteToRegistry, 'WriteToRegistry', cdRegister);
 S.RegisterDelphiFunction(@ReadFromRegistry, 'ReadFromRegistry', cdRegister);
 S.RegisterDelphiFunction(@DefReadFromRegistry, 'DefReadFromRegistry', cdRegister);
 S.RegisterDelphiFunction(@AllSubKey, 'AllSubKey', cdRegister);
 S.RegisterDelphiFunction(@DefAllSubKey, 'DefAllSubKey', cdRegister);
 S.RegisterDelphiFunction(@SaveRegKey, 'SaveRegKey', cdRegister);
 S.RegisterDelphiFunction(@LoadRegKey, 'LoadRegKey', cdRegister);
 S.RegisterDelphiFunction(@AltSaveRegKey, 'AltSaveRegKey', cdRegister);
 S.RegisterDelphiFunction(@AltLoadRegKey, 'AltLoadRegKey', cdRegister);
 S.RegisterDelphiFunction(@GetKeyForParValue, 'GetKeyForParValue', cdRegister);
end;

 
 
{ TPSImport_RegUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RegUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RegUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RegUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RegUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
