unit uPSI_mimeinln;
{
   synapse functions
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
  TPSImport_mimeinln = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_mimeinln(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_mimeinln_Routines(S: TPSExec);

procedure Register;

implementation


uses
   synachar
  ,synacode
  ,synautil
  ,mimeinln
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_mimeinln]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_mimeinln(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function InlineDecode( const Value : string; CP : TMimeChar) : string');
 CL.AddDelphiFunction('Function InlineEncode( const Value : string; CP, MimeP : TMimeChar) : string');
 CL.AddDelphiFunction('Function NeedInline( const Value : AnsiString) : boolean');
 CL.AddDelphiFunction('Function InlineCodeEx( const Value : string; FromCP : TMimeChar) : string');
 CL.AddDelphiFunction('Function InlineCode( const Value : string) : string');
 CL.AddDelphiFunction('Function InlineEmailEx( const Value : string; FromCP : TMimeChar) : string');
 CL.AddDelphiFunction('Function InlineEmail( const Value : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_mimeinln_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InlineDecode, 'InlineDecode', cdRegister);
 S.RegisterDelphiFunction(@InlineEncode, 'InlineEncode', cdRegister);
 S.RegisterDelphiFunction(@NeedInline, 'NeedInline', cdRegister);
 S.RegisterDelphiFunction(@InlineCodeEx, 'InlineCodeEx', cdRegister);
 S.RegisterDelphiFunction(@InlineCode, 'InlineCode', cdRegister);
 S.RegisterDelphiFunction(@InlineEmailEx, 'InlineEmailEx', cdRegister);
 S.RegisterDelphiFunction(@InlineEmail, 'InlineEmail', cdRegister);
end;

 
 
{ TPSImport_mimeinln }
(*----------------------------------------------------------------------------*)
procedure TPSImport_mimeinln.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_mimeinln(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_mimeinln.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_mimeinln(ri);
  RIRegister_mimeinln_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
