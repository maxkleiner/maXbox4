unit uPSI_cPEM;
{
  for X509  ,  with selftest CL.AddDelphiFunction('Procedure SelfTestPEM');
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
  TPSImport_cPEM = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPEMFile(CL: TPSPascalCompiler);
procedure SIRegister_cPEM(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cPEM_Routines(S: TPSExec);
procedure RIRegister_TPEMFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_cPEM(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cPEM;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cPEM]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPEMFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPEMFile') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPEMFile') do begin
    RegisterMethod('Procedure LoadFromText( const Txt : AnsiString)');
    RegisterMethod('Procedure LoadFromFile( const FileName : String)');
    RegisterProperty('CertificateCount', 'Integer', iptr);
    RegisterProperty('Certificate', 'AnsiString Integer', iptr);
    RegisterProperty('RSAPrivateKey', 'AnsiString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cPEM(CL: TPSPascalCompiler);
begin
  SIRegister_TPEMFile(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPEMFile');
 CL.AddDelphiFunction('Procedure SelfTestPEM');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPEMFileRSAPrivateKey_R(Self: TPEMFile; var T: AnsiString);
begin T := Self.RSAPrivateKey; end;

(*----------------------------------------------------------------------------*)
procedure TPEMFileCertificate_R(Self: TPEMFile; var T: AnsiString; const t1: Integer);
begin T := Self.Certificate[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPEMFileCertificateCount_R(Self: TPEMFile; var T: Integer);
begin T := Self.CertificateCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cPEM_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestPEM', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPEMFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPEMFile) do begin
    RegisterMethod(@TPEMFile.LoadFromText, 'LoadFromText');
    RegisterMethod(@TPEMFile.LoadFromFile, 'LoadFromFile');
    RegisterPropertyHelper(@TPEMFileCertificateCount_R,nil,'CertificateCount');
    RegisterPropertyHelper(@TPEMFileCertificate_R,nil,'Certificate');
    RegisterPropertyHelper(@TPEMFileRSAPrivateKey_R,nil,'RSAPrivateKey');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cPEM(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPEMFile(CL);
  with CL.Add(EPEMFile) do
end;

 
 
{ TPSImport_cPEM }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cPEM.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cPEM(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cPEM.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cPEM(ri);
  RIRegister_cPEM_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
