unit uPSI_RegSvrUtils;
{
   as it was the cloud serv  to cloud atlas maxlas

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
  TPSImport_RegSvrUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ERegistryException(CL: TPSPascalCompiler);
procedure SIRegister_RegSvrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_RegSvrUtils_Routines(S: TPSExec);
procedure RIRegister_ERegistryException(CL: TPSRuntimeClassImporter);
procedure RIRegister_RegSvrUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ActiveX
  ,Windows
  ,RegSvrUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RegSvrUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ERegistryException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ERegistryException') do
  with CL.AddClassN(CL.FindClass('Exception'),'ERegistryException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RegSvrUtils(CL: TPSPascalCompiler);
begin
  SIRegister_ERegistryException(CL);
 CL.AddDelphiFunction('Function RegOpenKey2( Key : HKey; const SubKey : string) : HKey');
 CL.AddDelphiFunction('Function RegGetKey( Key : HKey; const SubKey : string) : string');
 CL.AddDelphiFunction('Function RegCanOpenKey( Key : HKey; const SubKey : string; var OutKey : HKey) : Boolean');
 CL.AddDelphiFunction('Function RegKeyExists2( Key : HKey; const SubKey : string) : Boolean');
 CL.AddDelphiFunction('Function RegCloseAndNilKey( var Key : HKey) : Boolean');
 CL.AddDelphiFunction('Function RegQuerySubKeyCount( Key : HKey) : Integer');
 CL.AddDelphiFunction('Function RegEnumKey2( Key : HKey; Index : Integer; var Value : string) : Boolean');
 CL.AddDelphiFunction('Function RegQueryKey( Key : HKey; const SubKey : string; var Value : string) : Boolean');
 CL.AddDelphiFunction('Function RegGetDefaultValue( Key : HKey) : string');
 CL.AddDelphiFunction('Function RegGetValueEx( Key : HKey; const ValName : string) : string');
 CL.AddDelphiFunction('Procedure ErrorFmt( const Ident : string; const Args : array of const)');
  CL.AddDelphiFunction('Procedure FmtError( const Ident : string; const Args : array of const)');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_RegSvrUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegOpenKey, 'RegOpenKey2', cdRegister);
 S.RegisterDelphiFunction(@RegGetKey, 'RegGetKey', cdRegister);
 S.RegisterDelphiFunction(@RegCanOpenKey, 'RegCanOpenKey', cdRegister);
 S.RegisterDelphiFunction(@RegKeyExists, 'RegKeyExists2', cdRegister);
 S.RegisterDelphiFunction(@RegCloseAndNilKey, 'RegCloseAndNilKey', cdRegister);
 S.RegisterDelphiFunction(@RegQuerySubKeyCount, 'RegQuerySubKeyCount', cdRegister);
 S.RegisterDelphiFunction(@RegEnumKey, 'RegEnumKey2', cdRegister);
 S.RegisterDelphiFunction(@RegQueryKey, 'RegQueryKey', cdRegister);
 S.RegisterDelphiFunction(@RegGetDefaultValue, 'RegGetDefaultValue', cdRegister);
 S.RegisterDelphiFunction(@RegGetValueEx, 'RegGetValueEx', cdRegister);
 S.RegisterDelphiFunction(@ErrorFmt, 'ErrorFmt', cdRegister);
  S.RegisterDelphiFunction(@ErrorFmt, 'FmtError', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ERegistryException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ERegistryException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RegSvrUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_ERegistryException(CL);
end;

 
 
{ TPSImport_RegSvrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RegSvrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RegSvrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RegSvrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RegSvrUtils(ri);
  RIRegister_RegSvrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
