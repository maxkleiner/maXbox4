unit uPSI_HTTPUtil;
{

for webservice by max
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
  TPSImport_HTTPUtil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IStreamLoader(CL: TPSPascalCompiler);
procedure SIRegister_IStringTokenizer(CL: TPSPascalCompiler);
procedure SIRegister_HTTPUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HTTPUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ,HTTPUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HTTPUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IStreamLoader(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IStreamLoader') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IStreamLoader, 'IStreamLoader') do
  begin
    RegisterMethod('Procedure Load( const WSDLFileName : WideString; Stream : TMemoryStream)', cdRegister);
    RegisterMethod('Function GetProxy : string', cdRegister);
    RegisterMethod('Procedure SetProxy( const Proxy : string)', cdRegister);
    RegisterMethod('Function GetUserName : string', cdRegister);
    RegisterMethod('Procedure SetUserName( const UserName : string)', cdRegister);
    RegisterMethod('Function GetPassword : string', cdRegister);
    RegisterMethod('Procedure SetPassword( const Password : string)', cdRegister);
    RegisterMethod('Function GetTimeout : Integer', cdRegister);
    RegisterMethod('Procedure SetTimeout( ATimeOut : Integer)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IStringTokenizer(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IStringTokenizer') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IStringTokenizer, 'IStringTokenizer') do
  begin
    RegisterMethod('Function getTokenCounts : integer', cdRegister);
    RegisterMethod('Function hasMoreTokens : boolean', cdRegister);
    RegisterMethod('Function nextToken : WideString', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HTTPUtil(CL: TPSPascalCompiler);
begin
  SIRegister_IStringTokenizer(CL);
  SIRegister_IStreamLoader(CL);
  //  TStringDynArray       = array of string;
  CL.AddTypeS('TStringDynArray', 'array of string');

 CL.AddDelphiFunction('Function StartsWith( const str : string; const sub : string) : Boolean');
 CL.AddDelphiFunction('Function FirstDelimiter( const delimiters : string; const Str : String) : integer;');
 CL.AddDelphiFunction('Function FirstDelimiter1( const delimiters : WideString; const Str : WideString) : integer;');
 CL.AddDelphiFunction('Function StringTokenizer( const str : string; const delim : string) : IStringTokenizer');
 CL.AddDelphiFunction('Function StringToStringArray( const str : string; const delim : string) : TStringDynArray');
 CL.AddDelphiFunction('Function HTMLEscape( const Str : string) : string');
 CL.AddDelphiFunction('Function GetDefaultStreamLoader : IStreamLoader');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FirstDelimiter1_P( const delimiters : WideString; const Str : WideString) : integer;
Begin Result := HTTPUtil.FirstDelimiter(delimiters, Str); END;

(*----------------------------------------------------------------------------*)
Function FirstDelimiter_P( const delimiters : string; const Str : String) : integer;
Begin Result := HTTPUtil.FirstDelimiter(delimiters, Str); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HTTPUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StartsWith, 'StartsWith', cdRegister);
 S.RegisterDelphiFunction(@FirstDelimiter1_P, 'FirstDelimiter', cdRegister);
 S.RegisterDelphiFunction(@FirstDelimiter_P, 'FirstDelimiter1', cdRegister);
 S.RegisterDelphiFunction(@StringTokenizer, 'StringTokenizer', cdRegister);
 S.RegisterDelphiFunction(@StringToStringArray, 'StringToStringArray', cdRegister);
 S.RegisterDelphiFunction(@HTMLEscape, 'HTMLEscape', cdRegister);
 S.RegisterDelphiFunction(@GetDefaultStreamLoader, 'GetDefaultStreamLoader', cdRegister);
end;

 
 
{ TPSImport_HTTPUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HTTPUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HTTPUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
