unit uPSI_ssl_openssl;
{
   my openssl by synapse
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
  TPSImport_ssl_openssl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSSLOpenSSL(CL: TPSPascalCompiler);
procedure SIRegister_ssl_openssl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSSLOpenSSL(CL: TPSRuntimeClassImporter);
procedure RIRegister_ssl_openssl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synsock
  ,synautil
  ,ssl_openssl_lib
  ,ssl_openssl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ssl_openssl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSSLOpenSSL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSSL', 'TSSLOpenSSL') do
  with CL.AddClassN(CL.FindClass('TCustomSSL'),'TSSLOpenSSL') do begin
    RegisterMethod('Constructor Create( const Value : TTCPBlockSocket)');
        RegisterMethod('Procedure Free');
     RegisterMethod('Function LibVersion : String');
    RegisterMethod('Function LibName : String');
    RegisterMethod('Function Connect : boolean');
    RegisterMethod('Function Accept : boolean');
    RegisterMethod('Function Shutdown : boolean');
    RegisterMethod('Function BiShutdown : boolean');
    RegisterMethod('Function SendBuffer( Buffer : TMemory; Len : Integer) : Integer');
    RegisterMethod('Function RecvBuffer( Buffer : TMemory; Len : Integer) : Integer');
    RegisterMethod('Function WaitingData : Integer');
    RegisterMethod('Function GetSSLVersion : string');
    RegisterMethod('Function GetPeerSubject : string');
    RegisterMethod('Function GetPeerSerialNo : integer');
    RegisterMethod('Function GetPeerIssuer : string');
    RegisterMethod('Function GetPeerName : string');
    RegisterMethod('Function GetPeerNameHash : cardinal');
    RegisterMethod('Function GetPeerFingerprint : string');
    RegisterMethod('Function GetCertInfo : string');
    RegisterMethod('Function GetCipherName : string');
    RegisterMethod('Function GetCipherBits : integer');
    RegisterMethod('Function GetCipherAlgBits : integer');
    RegisterMethod('Function GetVerifyCert : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ssl_openssl(CL: TPSPascalCompiler);
begin
  SIRegister_TSSLOpenSSL(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSSLOpenSSL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSSLOpenSSL) do begin
    RegisterConstructor(@TSSLOpenSSL.Create, 'Create');
          RegisterMethod(@TSSLOpenSSL.Destroy, 'Free');
        RegisterMethod(@TSSLOpenSSL.LibVersion, 'LibVersion');
    RegisterMethod(@TSSLOpenSSL.LibName, 'LibName');
    RegisterMethod(@TSSLOpenSSL.Connect, 'Connect');
    RegisterMethod(@TSSLOpenSSL.Accept, 'Accept');
    RegisterMethod(@TSSLOpenSSL.Shutdown, 'Shutdown');
    RegisterMethod(@TSSLOpenSSL.BiShutdown, 'BiShutdown');
    RegisterMethod(@TSSLOpenSSL.SendBuffer, 'SendBuffer');
    RegisterMethod(@TSSLOpenSSL.RecvBuffer, 'RecvBuffer');
    RegisterMethod(@TSSLOpenSSL.WaitingData, 'WaitingData');
    RegisterMethod(@TSSLOpenSSL.GetSSLVersion, 'GetSSLVersion');
    RegisterMethod(@TSSLOpenSSL.GetPeerSubject, 'GetPeerSubject');
    RegisterMethod(@TSSLOpenSSL.GetPeerSerialNo, 'GetPeerSerialNo');
    RegisterMethod(@TSSLOpenSSL.GetPeerIssuer, 'GetPeerIssuer');
    RegisterMethod(@TSSLOpenSSL.GetPeerName, 'GetPeerName');
    RegisterMethod(@TSSLOpenSSL.GetPeerNameHash, 'GetPeerNameHash');
    RegisterMethod(@TSSLOpenSSL.GetPeerFingerprint, 'GetPeerFingerprint');
    RegisterMethod(@TSSLOpenSSL.GetCertInfo, 'GetCertInfo');
    RegisterMethod(@TSSLOpenSSL.GetCipherName, 'GetCipherName');
    RegisterMethod(@TSSLOpenSSL.GetCipherBits, 'GetCipherBits');
    RegisterMethod(@TSSLOpenSSL.GetCipherAlgBits, 'GetCipherAlgBits');
    RegisterMethod(@TSSLOpenSSL.GetVerifyCert, 'GetVerifyCert');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ssl_openssl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSSLOpenSSL(CL);
end;

 
 
{ TPSImport_ssl_openssl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ssl_openssl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ssl_openssl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ssl_openssl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ssl_openssl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
