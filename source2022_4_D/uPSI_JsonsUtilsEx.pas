unit uPSI_JsonsUtilsEx;
{
Tjason seconds
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_JsonsUtilsEx = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JsonsUtilsEx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JsonsUtilsEx_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JsonsUtilsEx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JsonsUtilsEx]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JsonsUtilsEx(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function FixedFloatToStr( const Value : Extended) : string');
 CL.AddDelphiFunction('Function FixedTryStrToFloat( const S : string; out Value : Extended) : Boolean');
 CL.AddDelphiFunction('Function FixedStrToFloat( const S : string) : Extended');
 CL.AddDelphiFunction('Function __ObjectToJson( aObject : TObject) : String');
 CL.AddDelphiFunction('Procedure __jsonToObject( const aJSONString : String; var aObject : TObject)');
  CL.AddTypeS('TObjectDynArray', 'array of TObject');
  CL.AddTypeS('TStringDynArray2', 'array of string');
  CL.AddTypeS('TIntegerDynArray2', 'array of Integer');
 CL.AddConstantN('GLB_JSON_STD_DECIMALSEPARATOR','String').SetString( '.');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JsonsUtilsEx_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FixedFloatToStr, 'FixedFloatToStr', cdRegister);
 S.RegisterDelphiFunction(@FixedTryStrToFloat, 'FixedTryStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@FixedStrToFloat, 'FixedStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@__ObjectToJson, '__ObjectToJson', cdRegister);
 S.RegisterDelphiFunction(@__jsonToObject, '__jsonToObject', cdRegister);
end;

 
 
{ TPSImport_JsonsUtilsEx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JsonsUtilsEx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JsonsUtilsEx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JsonsUtilsEx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JsonsUtilsEx_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
