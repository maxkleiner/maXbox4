unit uPSI_SimpleRSSUtils;
{
to simple parser rss  - TEncodingTypeRSS with simpleRSS

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
  TPSImport_SimpleRSSUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_SimpleRSSUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SimpleRSSUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   XMLIntf
  ,SimpleRSSTypes
  ,SimpleRSS
  ,SimpleRSSUtils
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleRSSUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleRSSUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function StringToLanguage( Language : string) : TLanguages');
 CL.AddDelphiFunction('Function LanguageToString( Language : TLanguages) : String');
 CL.AddDelphiFunction('Function DecodeStringRSS( Encoding : TEncodingTypeRSS; Data : string) : string');
 CL.AddDelphiFunction('Procedure GetSkipHours( RootNode : IXMLNode; var aSimpleRSS : TSimpleRSS)');
 CL.AddDelphiFunction('Procedure GetSkipDays( RootNode : IXMLNode; var aSimpleRSS : TSimpleRSS)');
 CL.AddDelphiFunction('function GetPageByURL(URL: string): string;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleRSSUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StringToLanguage, 'StringToLanguage', cdRegister);
 S.RegisterDelphiFunction(@LanguageToString, 'LanguageToString', cdRegister);
 S.RegisterDelphiFunction(@DecodeString, 'DecodeStringRSS', cdRegister);
 S.RegisterDelphiFunction(@GetSkipHours, 'GetSkipHours', cdRegister);
 S.RegisterDelphiFunction(@GetSkipDays, 'GetSkipDays', cdRegister);
 S.RegisterDelphiFunction(@GetPageByURL, 'GetPageByURL', cdRegister);
end;

 
 
{ TPSImport_SimpleRSSUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleRSSUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleRSSUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleRSSUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleRSSUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
