unit uPSI_ALSMTPClient;
{
   another amail
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
  TPSImport_ALSMTPClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAlSmtpClient(CL: TPSPascalCompiler);
procedure SIRegister_ALSMTPClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAlSmtpClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALSMTPClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinSock2
  WinSock
  ,ALStringList
  ,ALInternetMessageCommon
  ,ALMultiPartMixedParser
  ,ALSMTPClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALSMTPClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlSmtpClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAlSmtpClient') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAlSmtpClient') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
    RegisterMethod('Function Connect( const aHost : AnsiString; const APort : integer) : AnsiString');
    RegisterMethod('Function Helo : AnsiString');
    RegisterMethod('Function Ehlo : AnsiString');
    RegisterMethod('Function Auth( AUserName, APassword : AnsiString; aAuthType : TalSmtpClientAuthType) : AnsiString');
    RegisterMethod('Function Vrfy( aUserName : AnsiString) : AnsiString');
    RegisterMethod('Function MailFrom( aSenderEmail : AnsiString) : AnsiString');
    RegisterMethod('Function RcptTo( aRcptNameLst : TALStrings) : AnsiString');
    RegisterMethod('Function Data( aMailData : AnsiString) : AnsiString;');
    RegisterMethod('Function Data1( aHeader, aBody : AnsiString) : AnsiString;');
    RegisterMethod('Function Data2( aHeader : TALEmailHeader; aBody : AnsiString) : AnsiString;');
    RegisterMethod('Function DataMultipartMixed( aHeader : TALEmailHeader; aInlineText, aInlineTextContentType : AnsiString; aAttachments : TALMultiPartMixedContents) : AnsiString');
    RegisterMethod('Function Quit : AnsiString');
    RegisterMethod('Function Rset : AnsiString');
    RegisterMethod('Procedure SendMail( aHost : AnsiString; APort : integer; aSenderEmail : AnsiString; aRcptNameLst : TALStrings; AUserName, APassword : AnsiString; aAuthType : TalSmtpClientAuthType; aMailData : AnsiString);');
    RegisterMethod('Procedure SendMail1( aHost : AnsiString; APort : integer; aSenderEmail : AnsiString; aRcptNameLst : TALStrings; AUserName, APassword : AnsiString; aAuthType : TalSmtpClientAuthType; aHeader, aBody : AnsiString);');
    RegisterMethod('Procedure SendMailMultipartMixed( aHost : AnsiString; APort : integer; aSenderEmail : AnsiString; aRcptNameLst : TALStrings; AUserName, APassword : AnsiString; aAuthType : TalSmtpClientAuthType; aHeader : TALEmailHeader;'
    +'aInlineText, aInlineTextContentType : AnsiString; aAttachments : TALMultiPartMixedContents)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function GetAuthTypeFromEhloResponse( EhloResponse : AnsiString) : TAlSmtpClientAuthTypeSet');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('TcpNoDelay', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALSMTPClient(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAlSmtpClientAuthType', '( AlsmtpClientAuthNone, alsmtpClientAut'
   +'hPlain, AlsmtpClientAuthLogin, AlsmtpClientAuthCramMD5, AlsmtpClientAuthCr'
   +'amSha1, AlsmtpClientAuthAutoSelect )');
  CL.AddTypeS('TAlSmtpClientAuthTypeSet', 'set of TAlSmtpClientAuthType');
  SIRegister_TAlSmtpClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientTcpNoDelay_W(Self: TAlSmtpClient; const T: Boolean);
begin Self.TcpNoDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientTcpNoDelay_R(Self: TAlSmtpClient; var T: Boolean);
begin T := Self.TcpNoDelay; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientKeepAlive_W(Self: TAlSmtpClient; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientKeepAlive_R(Self: TAlSmtpClient; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientReceiveTimeout_W(Self: TAlSmtpClient; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientReceiveTimeout_R(Self: TAlSmtpClient; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientSendTimeout_W(Self: TAlSmtpClient; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientSendTimeout_R(Self: TAlSmtpClient; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlSmtpClientConnected_R(Self: TAlSmtpClient; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Procedure TAlSmtpClientSendMail1_P(Self: TAlSmtpClient;  aHost : AnsiString; APort : integer; aSenderEmail : AnsiString; aRcptNameLst : TALStrings; AUserName, APassword : AnsiString; aAuthType : TalSmtpClientAuthType; aHeader, aBody : AnsiString);
Begin Self.SendMail(aHost, APort, aSenderEmail, aRcptNameLst, AUserName, APassword, aAuthType, aHeader, aBody); END;

(*----------------------------------------------------------------------------*)
Procedure TAlSmtpClientSendMail_P(Self: TAlSmtpClient;  aHost : AnsiString; APort : integer; aSenderEmail : AnsiString; aRcptNameLst : TALStrings; AUserName, APassword : AnsiString; aAuthType : TalSmtpClientAuthType; aMailData : AnsiString);
Begin Self.SendMail(aHost, APort, aSenderEmail, aRcptNameLst, AUserName, APassword, aAuthType, aMailData); END;

(*----------------------------------------------------------------------------*)
Function TAlSmtpClientData2_P(Self: TAlSmtpClient;  aHeader : TALEmailHeader; aBody : AnsiString) : AnsiString;
Begin Result := Self.Data(aHeader, aBody); END;

(*----------------------------------------------------------------------------*)
Function TAlSmtpClientData1_P(Self: TAlSmtpClient;  aHeader, aBody : AnsiString) : AnsiString;
Begin Result := Self.Data(aHeader, aBody); END;

(*----------------------------------------------------------------------------*)
Function TAlSmtpClientData_P(Self: TAlSmtpClient;  aMailData : AnsiString) : AnsiString;
Begin Result := Self.Data(aMailData); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlSmtpClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlSmtpClient) do begin
    RegisterVirtualConstructor(@TAlSmtpClient.Create, 'Create');
    RegisterVirtualMethod(@TAlSmtpClient.Connect, 'Connect');
    RegisterMethod(@TALSmtpClient.Destroy, 'Free');
     RegisterVirtualMethod(@TAlSmtpClient.Helo, 'Helo');
    RegisterVirtualMethod(@TAlSmtpClient.Ehlo, 'Ehlo');
    RegisterVirtualMethod(@TAlSmtpClient.Auth, 'Auth');
    RegisterVirtualMethod(@TAlSmtpClient.Vrfy, 'Vrfy');
    RegisterVirtualMethod(@TAlSmtpClient.MailFrom, 'MailFrom');
    RegisterVirtualMethod(@TAlSmtpClient.RcptTo, 'RcptTo');
    RegisterVirtualMethod(@TAlSmtpClientData_P, 'Data');
    RegisterVirtualMethod(@TAlSmtpClientData1_P, 'Data1');
    RegisterVirtualMethod(@TAlSmtpClientData2_P, 'Data2');
    RegisterVirtualMethod(@TAlSmtpClient.DataMultipartMixed, 'DataMultipartMixed');
    RegisterVirtualMethod(@TAlSmtpClient.Quit, 'Quit');
    RegisterVirtualMethod(@TAlSmtpClient.Rset, 'Rset');
    RegisterVirtualMethod(@TAlSmtpClientSendMail_P, 'SendMail');
    RegisterVirtualMethod(@TAlSmtpClientSendMail1_P, 'SendMail1');
    RegisterVirtualMethod(@TAlSmtpClient.SendMailMultipartMixed, 'SendMailMultipartMixed');
    RegisterVirtualMethod(@TAlSmtpClient.Disconnect, 'Disconnect');
    RegisterVirtualMethod(@TAlSmtpClient.GetAuthTypeFromEhloResponse, 'GetAuthTypeFromEhloResponse');
    RegisterPropertyHelper(@TAlSmtpClientConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TAlSmtpClientSendTimeout_R,@TAlSmtpClientSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TAlSmtpClientReceiveTimeout_R,@TAlSmtpClientReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TAlSmtpClientKeepAlive_R,@TAlSmtpClientKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@TAlSmtpClientTcpNoDelay_R,@TAlSmtpClientTcpNoDelay_W,'TcpNoDelay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALSMTPClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAlSmtpClient(CL);
end;

 
 
{ TPSImport_ALSMTPClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALSMTPClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALSMTPClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALSMTPClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALSMTPClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
