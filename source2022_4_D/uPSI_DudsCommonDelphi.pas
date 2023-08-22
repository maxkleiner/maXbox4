unit uPSI_DudsCommonDelphi;
{
from dude

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
  TPSImport_DudsCommonDelphi = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DudsCommonDelphi(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DudsCommonDelphi_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Registry
  ,DudsCommonDelphi
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DudsCommonDelphi]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DudsCommonDelphi(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function DelphiIDERunning : Boolean');
 CL.AddDelphiFunction('Function GetDelphiVersionRegistryKey( Version : Integer) : String');
 CL.AddDelphiFunction('Function GetDelphiRootDirectory( Version : Integer) : String');
 CL.AddDelphiFunction('Function IsDelphiVersionInstalled( Version : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetDelphiEnvironmentVariables( Version : Integer; const EnvironmentVariables : TStrings) : Boolean');
 CL.AddDelphiFunction('Function GetDelphiLibraryPaths( Version : Integer; const LibraryPaths : TStrings; EvaluateMacros : Boolean; CheckPaths : Boolean) : Boolean');
 CL.AddDelphiFunction('function StrConcat(ArrS:array of string;Space:string):string;');
 CL.AddDelphiFunction('function StrDelSpc(s:string):string;');
 CL.AddDelphiFunction('function StrSplit2(S:string;Ch:char):TStringDynArray;');

 CL.AddDelphiFunction('procedure StrReplaceFirst(var S:string;olds,news:string);');
 CL.AddDelphiFunction('procedure StrReplaceLast(var S:string;OldS,NewS:string);');
CL.AddDelphiFunction('procedure ConvertV3ToS(X,Y,Z:extended;var r,a,b:extended);');
 CL.AddDelphiFunction('procedure ConvertSToV3(R,A,B:extended;var X,Y,Z:extended);');
CL.AddDelphiFunction('procedure InterpolateColor(Color0,Color1:TColor;Count:integer;var TempColor:array of TColor);');
CL.AddDelphiFunction('function TryStrToextended(const S: string; out Value: extended): Boolean;');

  //Other

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_DudsCommonDelphi_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DelphiIDERunning, 'DelphiIDERunning', cdRegister);
 S.RegisterDelphiFunction(@GetDelphiVersionRegistryKey, 'GetDelphiVersionRegistryKey', cdRegister);
 S.RegisterDelphiFunction(@GetDelphiRootDirectory, 'GetDelphiRootDirectory', cdRegister);
 S.RegisterDelphiFunction(@IsDelphiVersionInstalled, 'IsDelphiVersionInstalled', cdRegister);
 S.RegisterDelphiFunction(@GetDelphiEnvironmentVariables, 'GetDelphiEnvironmentVariables', cdRegister);
 S.RegisterDelphiFunction(@GetDelphiLibraryPaths, 'GetDelphiLibraryPaths', cdRegister);
 S.RegisterDelphiFunction(@StrConcat, 'StrConcat', cdRegister);
 S.RegisterDelphiFunction(@StrDelSpc, 'StrDelSpc', cdRegister);
 S.RegisterDelphiFunction(@StrSplit2, 'StrSplit2', cdRegister);

 S.RegisterDelphiFunction(@StrReplaceFirst, 'StrReplaceFirst', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceLast, 'StrReplaceLast', cdRegister);
 S.RegisterDelphiFunction(@ConvertV3ToS, 'ConvertV3ToS', cdRegister);
 S.RegisterDelphiFunction(@ConvertSToV3, 'ConvertSToV3', cdRegister);
 S.RegisterDelphiFunction(@InterpolateColor, 'InterpolateColor', cdRegister);
 S.RegisterDelphiFunction(@TryStrToextended, 'TryStrToextended', cdRegister);

end;

 
 
{ TPSImport_DudsCommonDelphi }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DudsCommonDelphi.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DudsCommonDelphi(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DudsCommonDelphi.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DudsCommonDelphi_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
