unit uPSI_ExtPascalUtils;
{
  prepare for JS and REST
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
  TPSImport_ExtPascalUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ExtPascalUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ExtPascalUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   TypInfo
  ,ExtPascalUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ExtPascalUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ExtPascalUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ExtPascalVersion','String').SetString( '0.9.8');
  CL.AddTypeS('TBrowser', '( brUnknown, brIE, brFirefox, brChrome, brSafari, br'
   +'Opera, brKonqueror, brMobileSafari )');
  CL.AddTypeS('TCSSUnit','(cssPX, cssPerc, cssEM, cssEX, cssIN, cssCM, cssMM, cssPT, cssPC, cssnone )');
  CL.AddTypeS('TExtProcedure', 'Procedure');
 CL.AddDelphiFunction('Function DetermineBrowser( const UserAgentStr : string) : TBrowser');
 CL.AddDelphiFunction('Function ExtExtract( const Delims : array of string; var S : string; var Matches : TStringList; Remove : boolean) : boolean');
 CL.AddDelphiFunction('Function ExtExplode( Delim : char; const S : string; Separator : char) : TStringList');
 CL.AddDelphiFunction('Function FirstDelimiter( const Delimiters, S : string; Offset : integer) : integer');
 CL.AddDelphiFunction('Function RPosEx( const Substr, Str : string; Offset : integer) : integer');
 CL.AddDelphiFunction('Function CountStr( const Substr, Str : string; UntilStr : string) : integer');
 CL.AddDelphiFunction('Function StrToJS( const S : string; UseBR : boolean) : string');
 CL.AddDelphiFunction('Function CaseOf( const S : string; const Cases : array of string) : integer');
 CL.AddDelphiFunction('Function RCaseOf( const S : string; const Cases : array of string) : integer');
 //CL.AddDelphiFunction('Function EnumToJSString( TypeInfo : PTypeInfo; Value : integer) : string');
 CL.AddDelphiFunction('Function SetPaddings( Top : integer; Right : integer; Bottom : integer; Left : integer; CSSUnit : TCSSUnit; Header : boolean) : string');
 CL.AddDelphiFunction('Function SetMargins( Top : integer; Right : integer; Bottom : integer; Left : integer; CSSUnit : TCSSUnit; Header : boolean) : string');
 CL.AddDelphiFunction('Function ExtBefore( const BeforeS, AfterS, S : string) : boolean');
 CL.AddDelphiFunction('Function IsUpperCase( S : string) : boolean');
 CL.AddDelphiFunction('Function BeautifyJS( const AScript : string; const StartingLevel : integer; SplitHTMLNewLine : boolean) : string');
 CL.AddDelphiFunction('Function BeautifyCSS( const AStyle : string) : string');
 CL.AddDelphiFunction('Function LengthRegExp( Rex : string; CountAll : Boolean) : integer');
 CL.AddDelphiFunction('Function JSDateToDateTime( JSDate : string) : TDateTime');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ExtPascalUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DetermineBrowser, 'DetermineBrowser', cdRegister);
 S.RegisterDelphiFunction(@Extract, 'ExtExtract', cdRegister);
 S.RegisterDelphiFunction(@Explode, 'ExtExplode', cdRegister);
 S.RegisterDelphiFunction(@FirstDelimiter, 'FirstDelimiter', cdRegister);
 S.RegisterDelphiFunction(@RPosEx, 'RPosEx', cdRegister);
 S.RegisterDelphiFunction(@CountStr, 'CountStr', cdRegister);
 S.RegisterDelphiFunction(@StrToJS, 'StrToJS', cdRegister);
 S.RegisterDelphiFunction(@CaseOf, 'CaseOf', cdRegister);
 S.RegisterDelphiFunction(@RCaseOf, 'RCaseOf', cdRegister);
 S.RegisterDelphiFunction(@EnumToJSString, 'EnumToJSString', cdRegister);
 S.RegisterDelphiFunction(@SetPaddings, 'SetPaddings', cdRegister);
 S.RegisterDelphiFunction(@SetMargins, 'SetMargins', cdRegister);
 S.RegisterDelphiFunction(@Before, 'ExtBefore', cdRegister);
 S.RegisterDelphiFunction(@IsUpperCase, 'IsUpperCase', cdRegister);
 S.RegisterDelphiFunction(@BeautifyJS, 'BeautifyJS', cdRegister);
 S.RegisterDelphiFunction(@BeautifyCSS, 'BeautifyCSS', cdRegister);
 S.RegisterDelphiFunction(@LengthRegExp, 'LengthRegExp', cdRegister);
 S.RegisterDelphiFunction(@JSDateToDateTime, 'JSDateToDateTime', cdRegister);
end;

 
 
{ TPSImport_ExtPascalUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtPascalUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExtPascalUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtPascalUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ExtPascalUtils(ri);
  RIRegister_ExtPascalUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
