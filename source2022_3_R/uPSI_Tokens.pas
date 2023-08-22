unit uPSI_Tokens;
{
Tfrom C++
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
  TPSImport_Tokens = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTokens(CL: TPSPascalCompiler);
procedure SIRegister_Tokens(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTokens(CL: TPSRuntimeClassImporter);
procedure RIRegister_Tokens(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Tokens
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Tokens]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTokens(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTokens') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTokens') do begin
    RegisterMethod('Constructor Create( const OriginalString : STRING; const separators : STRING; const LeftMark : CHAR; const RightMark : CHAR; const Escape : CHAR; const SingleSeparatorBetweenTokens : BOOLEAN)');
        RegisterMethod('Procedure Free');
        RegisterMethod('Function Token( const index : WORD) : STRING');
    RegisterMethod('Function TokenCount : WORD');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Tokens(CL: TPSPascalCompiler);
begin
  SIRegister_TTokens(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TTokens(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTokens) do begin
    RegisterConstructor(@TTokens.Create, 'Create');
        RegisterMethod(@TTokens.Destroy, 'Free');
     RegisterMethod(@TTokens.Token, 'Token');
    RegisterMethod(@TTokens.TokenCount, 'TokenCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Tokens(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTokens(CL);
end;

 
 
{ TPSImport_Tokens }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Tokens.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Tokens(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Tokens.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Tokens(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
