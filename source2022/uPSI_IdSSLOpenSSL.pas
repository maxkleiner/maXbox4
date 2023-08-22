unit uPSI_IdSSLOpenSSL;
{
  for the firs it needs the libeay32, but it depends on the version!
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
  TPSImport_IdSSLOpenSSL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdSSLCipher(CL: TPSPascalCompiler);
procedure SIRegister_TIdX509(CL: TPSPascalCompiler);
procedure SIRegister_TIdX509Name(CL: TPSPascalCompiler);
procedure SIRegister_TIdServerIOHandlerSSL(CL: TPSPascalCompiler);
procedure SIRegister_TIdSSLIOHandlerSocket(CL: TPSPascalCompiler);
procedure SIRegister_TIdSSLSocket(CL: TPSPascalCompiler);
procedure SIRegister_TIdSSLContext(CL: TPSPascalCompiler);
procedure SIRegister_TIdSSLOptions(CL: TPSPascalCompiler);
procedure SIRegister_IdSSLOpenSSL(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdSSLOpenSSL_Routines(S: TPSExec);
procedure RIRegister_TIdSSLCipher(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdX509(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdX509Name(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdServerIOHandlerSSL(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSSLIOHandlerSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSSLSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSSLContext(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSSLOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdSSLOpenSSL(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  //,IdStackConsts
  //,IdSocketHandle
  ,IdSSLOpenSSLHeaders
  //,IdComponent
  //,IdIOHandler
  //,IdGlobal
  //,IdTCPServer
  //,IdThread
  //,IdTCPConnection
  //,IdIntercept
  //,IdIOHandlerSocket
  //,IdServerIOHandler
  //,IdSocks
  ,IdSSLOpenSSL
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdSSLOpenSSL]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSSLCipher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdSSLCipher') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdSSLCipher') do begin
    RegisterMethod('Constructor Create( AOwner : TIdSSLSocket)');
    RegisterProperty('Description', 'String', iptr);
    RegisterProperty('Name', 'String', iptr);
    RegisterProperty('Bits', 'Integer', iptr);
    RegisterProperty('Version', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdX509(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdX509') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdX509') do begin
    RegisterMethod('Constructor Create( aX509 : PX509)');
    RegisterProperty('Fingerprint', 'TEVP_MD', iptr);
    RegisterProperty('FingerprintAsString', 'String', iptr);
    RegisterProperty('Subject', 'TIdX509Name', iptr);
    RegisterProperty('Issuer', 'TIdX509Name', iptr);
    RegisterProperty('notBefore', 'TDateTime', iptr);
    RegisterProperty('notAfter', 'TDateTime', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdX509Name(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdX509Name') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdX509Name') do begin
    RegisterMethod('Constructor Create( aX509Name : PX509_NAME)');
    RegisterProperty('Hash', 'TULong', iptr);
    RegisterProperty('HashAsString', 'string', iptr);
    RegisterProperty('OneLine', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdServerIOHandlerSSL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdServerIOHandler', 'TIdServerIOHandlerSSL') do
  with CL.AddClassN(CL.FindClass('TIdServerIOHandler'),'TIdServerIOHandlerSSL') do begin
    RegisterMethod('Procedure Init');
    RegisterMethod('Function Accept( ASocket : TIdStackSocketHandle; AThread : TIdThread) : TIdIOHandler');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('SSLOptions', 'TIdSSLOptions', iptrw);
    RegisterProperty('OnStatusInfo', 'TCallbackEvent', iptrw);
    RegisterProperty('OnGetPassword', 'TPasswordEvent', iptrw);
    RegisterProperty('OnVerifyPeer', 'TVerifyPeerEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSSLIOHandlerSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdIOHandlerSocket', 'TIdSSLIOHandlerSocket') do
  with CL.AddClassN(CL.FindClass('TIdIOHandlerSocket'),'TIdSSLIOHandlerSocket') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('SSLSocket', 'TIdSSLSocket', iptrw);
    RegisterProperty('PassThrough', 'Boolean', iptrw);
    RegisterProperty('OnBeforeConnect', 'TIOHandlerNotify', iptrw);
    RegisterProperty('SSLOptions', 'TIdSSLOptions', iptrw);
    RegisterProperty('OnStatusInfo', 'TCallbackEvent', iptrw);
    RegisterProperty('OnGetPassword', 'TPasswordEvent', iptrw);
    RegisterProperty('OnVerifyPeer', 'TVerifyPeerEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSSLSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdSSLSocket') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdSSLSocket') do begin
    RegisterProperty('fSSL', 'PSSL', iptrw);
    RegisterMethod('Constructor Create( Parent : TObject)');
    RegisterMethod('Procedure Accept( const pHandle : TIdStackSocketHandle; fSSLContext : TIdSSLContext)');
    RegisterMethod('Procedure Connect( const pHandle : TIdStackSocketHandle; fSSLContext : TIdSSLContext)');
    RegisterMethod('Function Send( var ABuf, ALen : integer) : integer');
    RegisterMethod('Function Recv( var ABuf, ALen : integer) : integer');
    RegisterMethod('Function GetSessionID : TByteArrayR');
    RegisterMethod('Function GetSessionIDAsString : String');
    RegisterMethod('Procedure SetCipherList( CipherList : String)');
    RegisterProperty('PeerCert', 'TIdX509', iptr);
    RegisterProperty('Cipher', 'TIdSSLCipher', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSSLContext(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdSSLContext') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdSSLContext') do begin
    RegisterProperty('Parent', 'TObject', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Function LoadRootCert : Boolean');
    RegisterMethod('Function LoadCert : Boolean');
    RegisterMethod('Function LoadKey : Boolean');
    RegisterProperty('StatusInfoOn', 'Boolean', iptrw);
    RegisterProperty('VerifyOn', 'Boolean', iptrw);
    RegisterProperty('Method', 'TIdSSLVersion', iptrw);
    RegisterProperty('Mode', 'TIdSSLMode', iptrw);
    RegisterProperty('RootCertFile', 'String', iptrw);
    RegisterProperty('CertFile', 'String', iptrw);
    RegisterProperty('KeyFile', 'String', iptrw);
    RegisterProperty('VerifyMode', 'TIdSSLVerifyModeSet', iptrw);
    RegisterProperty('VerifyDepth', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSSLOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdSSLOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdSSLOptions') do begin
    RegisterProperty('RootCertFile', 'TFileName', iptrw);
    RegisterProperty('CertFile', 'TFileName', iptrw);
    RegisterProperty('KeyFile', 'TFileName', iptrw);
    RegisterProperty('Method', 'TIdSSLVersion', iptrw);
    RegisterProperty('Mode', 'TIdSSLMode', iptrw);
    RegisterProperty('VerifyMode', 'TIdSSLVerifyModeSet', iptrw);
    RegisterProperty('VerifyDepth', 'Integer', iptrw);
    RegisterProperty('VerifyDirs', 'String', iptrw);
    RegisterProperty('CipherList', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdSSLOpenSSL(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdX509');
  CL.AddTypeS('TIdSSLVersion', '( sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1 )');
  CL.AddTypeS('TIdSSLMode', '( sslmUnassigned, sslmClient, sslmServer, sslmBoth)');
  CL.AddTypeS('TIdSSLVerifyMode', '( sslvrfPeer, sslvrfFailIfNoPeerCert, sslvrfClientOnce )');
  CL.AddTypeS('TIdSSLVerifyModeSet', 'set of TIdSSLVerifyMode');
  CL.AddTypeS('TIdSSLCtxMode', '( sslCtxClient, sslCtxServer )');
  CL.AddTypeS('TIdSSLAction', '( sslRead, sslWrite )');
  CL.AddTypeS('TByteArrayR', 'record Length : Integer; Data : PChar; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdSSLIOHandlerSocket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdSSLCipher');
  CL.AddTypeS('TCallbackEvent', 'Procedure ( Msg : String)');
  CL.AddTypeS('TPasswordEvent', 'Procedure ( var Password : String)');
  CL.AddTypeS('TVerifyPeerEvent', 'Function ( Certificate : TIdX509) : Boolean of object');
 //   TVerifyPeerEvent  = function(Certificate: TIdX509): Boolean of object;
   CL.AddTypeS('TIOHandlerNotify', 'Procedure ( ASender : TIdSSLIOHandlerSocket)');
  SIRegister_TIdSSLOptions(CL);
  SIRegister_TIdSSLContext(CL);
  SIRegister_TIdSSLSocket(CL);
  SIRegister_TIdSSLIOHandlerSocket(CL);
  SIRegister_TIdServerIOHandlerSSL(CL);
  SIRegister_TIdX509Name(CL);
  SIRegister_TIdX509(CL);
  SIRegister_TIdSSLCipher(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOpenSSLError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOpenSSLLoadError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLCouldNotLoadSSLLibrary');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLModeNotSet');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLGetMethodError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLCreatingContextError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLLoadingRootCertError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLLoadingCertError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLLoadingKeyError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLSettingCipherError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLDataBindingError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLAcceptError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdOSSLConnectError');
// CL.AddDelphiFunction('Function LogicalAnd( A, B : Integer) : Boolean');
 //CL.AddDelphiFunction('Procedure InfoCallback( sslSocket : PSSL; where : Integer; ret : Integer)');
 //CL.AddDelphiFunction('Function PasswordCallback( buf : PChar; size : Integer; rwflag : Integer; userdata : Pointer) : Integer');
 //CL.AddDelphiFunction('Function VerifyCallback( Ok : Integer; ctx : PX509_STORE_CTX) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdSSLCipherVersion_R(Self: TIdSSLCipher; var T: String);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLCipherBits_R(Self: TIdSSLCipher; var T: Integer);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLCipherName_R(Self: TIdSSLCipher; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLCipherDescription_R(Self: TIdSSLCipher; var T: String);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509notAfter_R(Self: TIdX509; var T: TDateTime);
begin T := Self.notAfter; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509notBefore_R(Self: TIdX509; var T: TDateTime);
begin T := Self.notBefore; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509Issuer_R(Self: TIdX509; var T: TIdX509Name);
begin T := Self.Issuer; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509Subject_R(Self: TIdX509; var T: TIdX509Name);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509FingerprintAsString_R(Self: TIdX509; var T: String);
begin T := Self.FingerprintAsString; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509Fingerprint_R(Self: TIdX509; var T: TEVP_MD);
begin T := Self.Fingerprint; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509NameOneLine_R(Self: TIdX509Name; var T: string);
begin T := Self.OneLine; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509NameHashAsString_R(Self: TIdX509Name; var T: string);
begin T := Self.HashAsString; end;

(*----------------------------------------------------------------------------*)
procedure TIdX509NameHash_R(Self: TIdX509Name; var T: TULong);
begin T := Self.Hash; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLOnVerifyPeer_W(Self: TIdServerIOHandlerSSL; const T: TVerifyPeerEvent);
begin Self.OnVerifyPeer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLOnVerifyPeer_R(Self: TIdServerIOHandlerSSL; var T: TVerifyPeerEvent);
begin T := Self.OnVerifyPeer; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLOnGetPassword_W(Self: TIdServerIOHandlerSSL; const T: TPasswordEvent);
begin Self.OnGetPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLOnGetPassword_R(Self: TIdServerIOHandlerSSL; var T: TPasswordEvent);
begin T := Self.OnGetPassword; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLOnStatusInfo_W(Self: TIdServerIOHandlerSSL; const T: TCallbackEvent);
begin Self.OnStatusInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLOnStatusInfo_R(Self: TIdServerIOHandlerSSL; var T: TCallbackEvent);
begin T := Self.OnStatusInfo; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLSSLOptions_W(Self: TIdServerIOHandlerSSL; const T: TIdSSLOptions);
begin Self.SSLOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdServerIOHandlerSSLSSLOptions_R(Self: TIdServerIOHandlerSSL; var T: TIdSSLOptions);
begin T := Self.SSLOptions; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnVerifyPeer_W(Self: TIdSSLIOHandlerSocket; const T: TVerifyPeerEvent);
begin Self.OnVerifyPeer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnVerifyPeer_R(Self: TIdSSLIOHandlerSocket; var T: TVerifyPeerEvent);
begin T := Self.OnVerifyPeer; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnGetPassword_W(Self: TIdSSLIOHandlerSocket; const T: TPasswordEvent);
begin Self.OnGetPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnGetPassword_R(Self: TIdSSLIOHandlerSocket; var T: TPasswordEvent);
begin T := Self.OnGetPassword; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnStatusInfo_W(Self: TIdSSLIOHandlerSocket; const T: TCallbackEvent);
begin Self.OnStatusInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnStatusInfo_R(Self: TIdSSLIOHandlerSocket; var T: TCallbackEvent);
begin T := Self.OnStatusInfo; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketSSLOptions_W(Self: TIdSSLIOHandlerSocket; const T: TIdSSLOptions);
begin Self.SSLOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketSSLOptions_R(Self: TIdSSLIOHandlerSocket; var T: TIdSSLOptions);
begin T := Self.SSLOptions; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnBeforeConnect_W(Self: TIdSSLIOHandlerSocket; const T: TIOHandlerNotify);
begin Self.OnBeforeConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketOnBeforeConnect_R(Self: TIdSSLIOHandlerSocket; var T: TIOHandlerNotify);
begin T := Self.OnBeforeConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketPassThrough_W(Self: TIdSSLIOHandlerSocket; const T: Boolean);
begin Self.PassThrough := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketPassThrough_R(Self: TIdSSLIOHandlerSocket; var T: Boolean);
begin T := Self.PassThrough; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketSSLSocket_W(Self: TIdSSLIOHandlerSocket; const T: TIdSSLSocket);
begin Self.SSLSocket := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLIOHandlerSocketSSLSocket_R(Self: TIdSSLIOHandlerSocket; var T: TIdSSLSocket);
begin T := Self.SSLSocket; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLSocketCipher_R(Self: TIdSSLSocket; var T: TIdSSLCipher);
begin T := Self.Cipher; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLSocketPeerCert_R(Self: TIdSSLSocket; var T: TIdX509);
begin T := Self.PeerCert; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLSocketfSSL_W(Self: TIdSSLSocket; const T: PSSL);
Begin Self.fSSL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLSocketfSSL_R(Self: TIdSSLSocket; var T: PSSL);
Begin T := Self.fSSL; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextVerifyDepth_W(Self: TIdSSLContext; const T: Integer);
begin Self.VerifyDepth := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextVerifyDepth_R(Self: TIdSSLContext; var T: Integer);
begin T := Self.VerifyDepth; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextVerifyMode_W(Self: TIdSSLContext; const T: TIdSSLVerifyModeSet);
begin Self.VerifyMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextVerifyMode_R(Self: TIdSSLContext; var T: TIdSSLVerifyModeSet);
begin T := Self.VerifyMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextKeyFile_W(Self: TIdSSLContext; const T: String);
begin Self.KeyFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextKeyFile_R(Self: TIdSSLContext; var T: String);
begin T := Self.KeyFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextCertFile_W(Self: TIdSSLContext; const T: String);
begin Self.CertFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextCertFile_R(Self: TIdSSLContext; var T: String);
begin T := Self.CertFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextRootCertFile_W(Self: TIdSSLContext; const T: String);
begin Self.RootCertFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextRootCertFile_R(Self: TIdSSLContext; var T: String);
begin T := Self.RootCertFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextMode_W(Self: TIdSSLContext; const T: TIdSSLMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextMode_R(Self: TIdSSLContext; var T: TIdSSLMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextMethod_W(Self: TIdSSLContext; const T: TIdSSLVersion);
begin Self.Method := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextMethod_R(Self: TIdSSLContext; var T: TIdSSLVersion);
begin T := Self.Method; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextVerifyOn_W(Self: TIdSSLContext; const T: Boolean);
begin Self.VerifyOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextVerifyOn_R(Self: TIdSSLContext; var T: Boolean);
begin T := Self.VerifyOn; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextStatusInfoOn_W(Self: TIdSSLContext; const T: Boolean);
begin Self.StatusInfoOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextStatusInfoOn_R(Self: TIdSSLContext; var T: Boolean);
begin T := Self.StatusInfoOn; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextParent_W(Self: TIdSSLContext; const T: TObject);
Begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLContextParent_R(Self: TIdSSLContext; var T: TObject);
Begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsCipherList_W(Self: TIdSSLOptions; const T: String);
begin Self.CipherList := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsCipherList_R(Self: TIdSSLOptions; var T: String);
begin T := Self.CipherList; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsVerifyDirs_W(Self: TIdSSLOptions; const T: String);
begin Self.VerifyDirs := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsVerifyDirs_R(Self: TIdSSLOptions; var T: String);
begin T := Self.VerifyDirs; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsVerifyDepth_W(Self: TIdSSLOptions; const T: Integer);
begin Self.VerifyDepth := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsVerifyDepth_R(Self: TIdSSLOptions; var T: Integer);
begin T := Self.VerifyDepth; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsVerifyMode_W(Self: TIdSSLOptions; const T: TIdSSLVerifyModeSet);
begin Self.VerifyMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsVerifyMode_R(Self: TIdSSLOptions; var T: TIdSSLVerifyModeSet);
begin T := Self.VerifyMode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsMode_W(Self: TIdSSLOptions; const T: TIdSSLMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsMode_R(Self: TIdSSLOptions; var T: TIdSSLMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsMethod_W(Self: TIdSSLOptions; const T: TIdSSLVersion);
begin Self.Method := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsMethod_R(Self: TIdSSLOptions; var T: TIdSSLVersion);
begin T := Self.Method; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsKeyFile_W(Self: TIdSSLOptions; const T: TFileName);
begin Self.KeyFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsKeyFile_R(Self: TIdSSLOptions; var T: TFileName);
begin T := Self.KeyFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsCertFile_W(Self: TIdSSLOptions; const T: TFileName);
begin Self.CertFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsCertFile_R(Self: TIdSSLOptions; var T: TFileName);
begin T := Self.CertFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsRootCertFile_W(Self: TIdSSLOptions; const T: TFileName);
begin Self.RootCertFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSSLOptionsRootCertFile_R(Self: TIdSSLOptions; var T: TFileName);
begin T := Self.RootCertFile; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSSLOpenSSL_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LogicalAnd, 'LogicalAnd', cdRegister);
 S.RegisterDelphiFunction(@InfoCallback, 'InfoCallback', CdCdecl);
 S.RegisterDelphiFunction(@PasswordCallback, 'PasswordCallback', CdCdecl);
 S.RegisterDelphiFunction(@VerifyCallback, 'VerifyCallback', CdCdecl);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSSLCipher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSSLCipher) do begin
    RegisterConstructor(@TIdSSLCipher.Create, 'Create');
    RegisterPropertyHelper(@TIdSSLCipherDescription_R,nil,'Description');
    RegisterPropertyHelper(@TIdSSLCipherName_R,nil,'Name');
    RegisterPropertyHelper(@TIdSSLCipherBits_R,nil,'Bits');
    RegisterPropertyHelper(@TIdSSLCipherVersion_R,nil,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdX509(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdX509) do begin
    RegisterVirtualConstructor(@TIdX509.Create, 'Create');
    RegisterPropertyHelper(@TIdX509Fingerprint_R,nil,'Fingerprint');
    RegisterPropertyHelper(@TIdX509FingerprintAsString_R,nil,'FingerprintAsString');
    RegisterPropertyHelper(@TIdX509Subject_R,nil,'Subject');
    RegisterPropertyHelper(@TIdX509Issuer_R,nil,'Issuer');
    RegisterPropertyHelper(@TIdX509notBefore_R,nil,'notBefore');
    RegisterPropertyHelper(@TIdX509notAfter_R,nil,'notAfter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdX509Name(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdX509Name) do begin
    RegisterConstructor(@TIdX509Name.Create, 'Create');
    RegisterPropertyHelper(@TIdX509NameHash_R,nil,'Hash');
    RegisterPropertyHelper(@TIdX509NameHashAsString_R,nil,'HashAsString');
    RegisterPropertyHelper(@TIdX509NameOneLine_R,nil,'OneLine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdServerIOHandlerSSL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdServerIOHandlerSSL) do begin
    RegisterMethod(@TIdServerIOHandlerSSL.Init, 'Init');
    RegisterMethod(@TIdServerIOHandlerSSL.Accept, 'Accept');
    RegisterConstructor(@TIdServerIOHandlerSSL.Create, 'Create');
    RegisterPropertyHelper(@TIdServerIOHandlerSSLSSLOptions_R,@TIdServerIOHandlerSSLSSLOptions_W,'SSLOptions');
    RegisterPropertyHelper(@TIdServerIOHandlerSSLOnStatusInfo_R,@TIdServerIOHandlerSSLOnStatusInfo_W,'OnStatusInfo');
    RegisterPropertyHelper(@TIdServerIOHandlerSSLOnGetPassword_R,@TIdServerIOHandlerSSLOnGetPassword_W,'OnGetPassword');
    RegisterPropertyHelper(@TIdServerIOHandlerSSLOnVerifyPeer_R,@TIdServerIOHandlerSSLOnVerifyPeer_W,'OnVerifyPeer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSSLIOHandlerSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSSLIOHandlerSocket) do begin
    RegisterConstructor(@TIdSSLIOHandlerSocket.Create, 'Create');
    RegisterPropertyHelper(@TIdSSLIOHandlerSocketSSLSocket_R,@TIdSSLIOHandlerSocketSSLSocket_W,'SSLSocket');
    RegisterPropertyHelper(@TIdSSLIOHandlerSocketPassThrough_R,@TIdSSLIOHandlerSocketPassThrough_W,'PassThrough');
    RegisterPropertyHelper(@TIdSSLIOHandlerSocketOnBeforeConnect_R,@TIdSSLIOHandlerSocketOnBeforeConnect_W,'OnBeforeConnect');
    RegisterPropertyHelper(@TIdSSLIOHandlerSocketSSLOptions_R,@TIdSSLIOHandlerSocketSSLOptions_W,'SSLOptions');
    RegisterPropertyHelper(@TIdSSLIOHandlerSocketOnStatusInfo_R,@TIdSSLIOHandlerSocketOnStatusInfo_W,'OnStatusInfo');
    RegisterPropertyHelper(@TIdSSLIOHandlerSocketOnGetPassword_R,@TIdSSLIOHandlerSocketOnGetPassword_W,'OnGetPassword');
    RegisterPropertyHelper(@TIdSSLIOHandlerSocketOnVerifyPeer_R,@TIdSSLIOHandlerSocketOnVerifyPeer_W,'OnVerifyPeer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSSLSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSSLSocket) do begin
    RegisterPropertyHelper(@TIdSSLSocketfSSL_R,@TIdSSLSocketfSSL_W,'fSSL');
    RegisterConstructor(@TIdSSLSocket.Create, 'Create');
    RegisterMethod(@TIdSSLSocket.Accept, 'Accept');
    RegisterMethod(@TIdSSLSocket.Connect, 'Connect');
    RegisterMethod(@TIdSSLSocket.Send, 'Send');
    RegisterMethod(@TIdSSLSocket.Recv, 'Recv');
    RegisterMethod(@TIdSSLSocket.GetSessionID, 'GetSessionID');
    RegisterMethod(@TIdSSLSocket.GetSessionIDAsString, 'GetSessionIDAsString');
    RegisterMethod(@TIdSSLSocket.SetCipherList, 'SetCipherList');
    RegisterPropertyHelper(@TIdSSLSocketPeerCert_R,nil,'PeerCert');
    RegisterPropertyHelper(@TIdSSLSocketCipher_R,nil,'Cipher');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSSLContext(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSSLContext) do begin
    RegisterPropertyHelper(@TIdSSLContextParent_R,@TIdSSLContextParent_W,'Parent');
    RegisterConstructor(@TIdSSLContext.Create, 'Create');
    RegisterMethod(@TIdSSLContext.LoadRootCert, 'LoadRootCert');
    RegisterMethod(@TIdSSLContext.LoadCert, 'LoadCert');
    RegisterMethod(@TIdSSLContext.LoadKey, 'LoadKey');
    RegisterPropertyHelper(@TIdSSLContextStatusInfoOn_R,@TIdSSLContextStatusInfoOn_W,'StatusInfoOn');
    RegisterPropertyHelper(@TIdSSLContextVerifyOn_R,@TIdSSLContextVerifyOn_W,'VerifyOn');
    RegisterPropertyHelper(@TIdSSLContextMethod_R,@TIdSSLContextMethod_W,'Method');
    RegisterPropertyHelper(@TIdSSLContextMode_R,@TIdSSLContextMode_W,'Mode');
    RegisterPropertyHelper(@TIdSSLContextRootCertFile_R,@TIdSSLContextRootCertFile_W,'RootCertFile');
    RegisterPropertyHelper(@TIdSSLContextCertFile_R,@TIdSSLContextCertFile_W,'CertFile');
    RegisterPropertyHelper(@TIdSSLContextKeyFile_R,@TIdSSLContextKeyFile_W,'KeyFile');
    RegisterPropertyHelper(@TIdSSLContextVerifyMode_R,@TIdSSLContextVerifyMode_W,'VerifyMode');
    RegisterPropertyHelper(@TIdSSLContextVerifyDepth_R,@TIdSSLContextVerifyDepth_W,'VerifyDepth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSSLOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSSLOptions) do begin
    RegisterPropertyHelper(@TIdSSLOptionsRootCertFile_R,@TIdSSLOptionsRootCertFile_W,'RootCertFile');
    RegisterPropertyHelper(@TIdSSLOptionsCertFile_R,@TIdSSLOptionsCertFile_W,'CertFile');
    RegisterPropertyHelper(@TIdSSLOptionsKeyFile_R,@TIdSSLOptionsKeyFile_W,'KeyFile');
    RegisterPropertyHelper(@TIdSSLOptionsMethod_R,@TIdSSLOptionsMethod_W,'Method');
    RegisterPropertyHelper(@TIdSSLOptionsMode_R,@TIdSSLOptionsMode_W,'Mode');
    RegisterPropertyHelper(@TIdSSLOptionsVerifyMode_R,@TIdSSLOptionsVerifyMode_W,'VerifyMode');
    RegisterPropertyHelper(@TIdSSLOptionsVerifyDepth_R,@TIdSSLOptionsVerifyDepth_W,'VerifyDepth');
    RegisterPropertyHelper(@TIdSSLOptionsVerifyDirs_R,@TIdSSLOptionsVerifyDirs_W,'VerifyDirs');
    RegisterPropertyHelper(@TIdSSLOptionsCipherList_R,@TIdSSLOptionsCipherList_W,'CipherList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSSLOpenSSL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdX509) do
  with CL.Add(TIdSSLIOHandlerSocket) do
  with CL.Add(TIdSSLCipher) do
  RIRegister_TIdSSLOptions(CL);
  RIRegister_TIdSSLContext(CL);
  RIRegister_TIdSSLSocket(CL);
  RIRegister_TIdSSLIOHandlerSocket(CL);
  RIRegister_TIdServerIOHandlerSSL(CL);
  RIRegister_TIdX509Name(CL);
  RIRegister_TIdX509(CL);
  RIRegister_TIdSSLCipher(CL);
  with CL.Add(EIdOpenSSLError) do
  with CL.Add(EIdOpenSSLLoadError) do
  with CL.Add(EIdOSSLCouldNotLoadSSLLibrary) do
  with CL.Add(EIdOSSLModeNotSet) do
  with CL.Add(EIdOSSLGetMethodError) do
  with CL.Add(EIdOSSLCreatingContextError) do
  with CL.Add(EIdOSSLLoadingRootCertError) do
  with CL.Add(EIdOSSLLoadingCertError) do
  with CL.Add(EIdOSSLLoadingKeyError) do
  with CL.Add(EIdOSSLSettingCipherError) do
  with CL.Add(EIdOSSLDataBindingError) do
  with CL.Add(EIdOSSLAcceptError) do
  with CL.Add(EIdOSSLConnectError) do
end;

 
 
{ TPSImport_IdSSLOpenSSL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSSLOpenSSL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdSSLOpenSSL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSSLOpenSSL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdSSLOpenSSL(ri);
  RIRegister_IdSSLOpenSSL_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
