unit uPSI_ssl_cryptlib;
{
   myssl synapse    - without eldos blackbox
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
  TPSImport_ssl_cryptlib = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSSLCryptLib(CL: TPSPascalCompiler);
procedure SIRegister_ssl_cryptlib(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSSLCryptLib(CL: TPSRuntimeClassImporter);
procedure RIRegister_ssl_cryptlib(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,blcksock
  ,synsock
  ,synautil
  ,synacode
  //,cryptlib
  ,ssl_cryptlib
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ssl_cryptlib]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSSLCryptLib(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSSL', 'TSSLCryptLib') do
  with CL.AddClassN(CL.FindClass('TCustomSSL'),'TSSLCryptLib') do
  begin
    RegisterProperty('PrivateKeyLabel', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ssl_cryptlib(CL: TPSPascalCompiler);
begin
  SIRegister_TSSLCryptLib(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSSLCryptLibPrivateKeyLabel_W(Self: TSSLCryptLib; const T: string);
begin Self.PrivateKeyLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TSSLCryptLibPrivateKeyLabel_R(Self: TSSLCryptLib; var T: string);
begin T := Self.PrivateKeyLabel; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSSLCryptLib(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSSLCryptLib) do
  begin
    RegisterPropertyHelper(@TSSLCryptLibPrivateKeyLabel_R,@TSSLCryptLibPrivateKeyLabel_W,'PrivateKeyLabel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ssl_cryptlib(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSSLCryptLib(CL);
end;

 
 
{ TPSImport_ssl_cryptlib }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ssl_cryptlib.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ssl_cryptlib(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ssl_cryptlib.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ssl_cryptlib(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
