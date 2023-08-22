unit uPSI_HTMLUtil;
{
   for cgi
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
  TPSImport_HTMLUtil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_HTMLUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HTMLUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   pwHTMtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HTMLUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_HTMLUtil(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function GetVal( const tag, attribname_ci : string) : string');
 CL.AddDelphiFunction('Function GetTagName( const Tag : string) : string');
 CL.AddDelphiFunction('Function GetUpTagName( const tag : string) : string');
 CL.AddDelphiFunction('Function GetNameValPair( const tag, attribname_ci : string) : string');
 CL.AddDelphiFunction('Function GetValFromNameVal( const namevalpair : string) : string');
 CL.AddDelphiFunction('Function GetNameValPair_cs( const tag, attribname : string) : string');
 CL.AddDelphiFunction('Function GetVal_JAMES( const tag, attribname_ci : string) : string');
 CL.AddDelphiFunction('Function GetNameValPair_JAMES( const tag, attribname_ci : string) : string');
 CL.AddDelphiFunction('Function CopyBuffer( StartIndex : PChar; Len : integer) : string');
 CL.AddDelphiFunction('Function Ucase( s : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_HTMLUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetVal, 'GetVal', cdRegister);
 S.RegisterDelphiFunction(@GetTagName, 'GetTagName', cdRegister);
 S.RegisterDelphiFunction(@GetUpTagName, 'GetUpTagName', cdRegister);
 S.RegisterDelphiFunction(@GetNameValPair, 'GetNameValPair', cdRegister);
 S.RegisterDelphiFunction(@GetValFromNameVal, 'GetValFromNameVal', cdRegister);
 S.RegisterDelphiFunction(@GetNameValPair_cs, 'GetNameValPair_cs', cdRegister);
 S.RegisterDelphiFunction(@GetVal_JAMES, 'GetVal_JAMES', cdRegister);
 S.RegisterDelphiFunction(@GetNameValPair_JAMES, 'GetNameValPair_JAMES', cdRegister);
 S.RegisterDelphiFunction(@CopyBuffer, 'CopyBuffer', cdRegister);
 S.RegisterDelphiFunction(@Ucase, 'Ucase', cdRegister);
end;

 
 
{ TPSImport_HTMLUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTMLUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HTMLUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTMLUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_HTMLUtil(ri);
  RIRegister_HTMLUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
