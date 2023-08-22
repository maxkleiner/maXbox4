unit uPSI_dnssend;
{
   synapse  to DNS
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
  TPSImport_dnssend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDNSSend(CL: TPSPascalCompiler);
procedure SIRegister_dnssend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_dnssend_Routines(S: TPSExec);
procedure RIRegister_TDNSSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_dnssend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,synaip
  ,synsock
  ,dnssend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dnssend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDNSSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TDNSSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TDNSSend') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function DNSQuery( Name : AnsiString; QType : Integer; const Reply : TStrings) : Boolean');
    RegisterProperty('Sock', 'TUDPBlockSocket', iptr);
    RegisterProperty('TCPSock', 'TTCPBlockSocket', iptr);
    RegisterProperty('UseTCP', 'Boolean', iptrw);
    RegisterProperty('RCode', 'Integer', iptr);
    RegisterProperty('Authoritative', 'Boolean', iptr);
    RegisterProperty('Truncated', 'Boolean', iptr);
    RegisterProperty('AnswerInfo', 'TStringList', iptr);
    RegisterProperty('NameserverInfo', 'TStringList', iptr);
    RegisterProperty('AdditionalInfo', 'TStringList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_dnssend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cDnsProtocol','String').SetString( '53');
 CL.AddConstantN('QTYPE_A','LongInt').SetInt( 1);
 CL.AddConstantN('QTYPE_NS','LongInt').SetInt( 2);
 CL.AddConstantN('QTYPE_MD','LongInt').SetInt( 3);
 CL.AddConstantN('QTYPE_MF','LongInt').SetInt( 4);
 CL.AddConstantN('QTYPE_CNAME','LongInt').SetInt( 5);
 CL.AddConstantN('QTYPE_SOA','LongInt').SetInt( 6);
 CL.AddConstantN('QTYPE_MB','LongInt').SetInt( 7);
 CL.AddConstantN('QTYPE_MG','LongInt').SetInt( 8);
 CL.AddConstantN('QTYPE_MR','LongInt').SetInt( 9);
 CL.AddConstantN('QTYPE_NULL','LongInt').SetInt( 10);
 CL.AddConstantN('QTYPE_WKS','LongInt').SetInt( 11);
 CL.AddConstantN('QTYPE_PTR','LongInt').SetInt( 12);
 CL.AddConstantN('QTYPE_HINFO','LongInt').SetInt( 13);
 CL.AddConstantN('QTYPE_MINFO','LongInt').SetInt( 14);
 CL.AddConstantN('QTYPE_MX','LongInt').SetInt( 15);
 CL.AddConstantN('QTYPE_TXT','LongInt').SetInt( 16);
 CL.AddConstantN('QTYPE_RP','LongInt').SetInt( 17);
 CL.AddConstantN('QTYPE_AFSDB','LongInt').SetInt( 18);
 CL.AddConstantN('QTYPE_X25','LongInt').SetInt( 19);
 CL.AddConstantN('QTYPE_ISDN','LongInt').SetInt( 20);
 CL.AddConstantN('QTYPE_RT','LongInt').SetInt( 21);
 CL.AddConstantN('QTYPE_NSAP','LongInt').SetInt( 22);
 CL.AddConstantN('QTYPE_NSAPPTR','LongInt').SetInt( 23);
 CL.AddConstantN('QTYPE_SIG','LongInt').SetInt( 24);
 CL.AddConstantN('QTYPE_KEY','LongInt').SetInt( 25);
 CL.AddConstantN('QTYPE_PX','LongInt').SetInt( 26);
 CL.AddConstantN('QTYPE_GPOS','LongInt').SetInt( 27);
 CL.AddConstantN('QTYPE_AAAA','LongInt').SetInt( 28);
 CL.AddConstantN('QTYPE_LOC','LongInt').SetInt( 29);
 CL.AddConstantN('QTYPE_NXT','LongInt').SetInt( 30);
 CL.AddConstantN('QTYPE_SRV','LongInt').SetInt( 33);
 CL.AddConstantN('QTYPE_NAPTR','LongInt').SetInt( 35);
 CL.AddConstantN('QTYPE_KX','LongInt').SetInt( 36);
 CL.AddConstantN('QTYPE_SPF','LongInt').SetInt( 99);
 CL.AddConstantN('QTYPE_AXFR','LongInt').SetInt( 252);
 CL.AddConstantN('QTYPE_MAILB','LongInt').SetInt( 253);
 CL.AddConstantN('QTYPE_MAILA','LongInt').SetInt( 254);
 CL.AddConstantN('QTYPE_ALL','LongInt').SetInt( 255);
  SIRegister_TDNSSend(CL);
 CL.AddDelphiFunction('Function GetMailServers( const DNSHost, Domain : AnsiString; const Servers : TStrings) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDNSSendAdditionalInfo_R(Self: TDNSSend; var T: TStringList);
begin T := Self.AdditionalInfo; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendNameserverInfo_R(Self: TDNSSend; var T: TStringList);
begin T := Self.NameserverInfo; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendAnswerInfo_R(Self: TDNSSend; var T: TStringList);
begin T := Self.AnswerInfo; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendTruncated_R(Self: TDNSSend; var T: Boolean);
begin T := Self.Truncated; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendAuthoritative_R(Self: TDNSSend; var T: Boolean);
begin T := Self.Authoritative; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendRCode_R(Self: TDNSSend; var T: Integer);
begin T := Self.RCode; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendUseTCP_W(Self: TDNSSend; const T: Boolean);
begin Self.UseTCP := T; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendUseTCP_R(Self: TDNSSend; var T: Boolean);
begin T := Self.UseTCP; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendTCPSock_R(Self: TDNSSend; var T: TTCPBlockSocket);
begin T := Self.TCPSock; end;

(*----------------------------------------------------------------------------*)
procedure TDNSSendSock_R(Self: TDNSSend; var T: TUDPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dnssend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetMailServers, 'GetMailServers', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDNSSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDNSSend) do begin
    RegisterConstructor(@TDNSSend.Create, 'Create');
      RegisterMethod(@TDNSSend.Destroy, 'Free');
     RegisterMethod(@TDNSSend.DNSQuery, 'DNSQuery');
    RegisterPropertyHelper(@TDNSSendSock_R,nil,'Sock');
    RegisterPropertyHelper(@TDNSSendTCPSock_R,nil,'TCPSock');
    RegisterPropertyHelper(@TDNSSendUseTCP_R,@TDNSSendUseTCP_W,'UseTCP');
    RegisterPropertyHelper(@TDNSSendRCode_R,nil,'RCode');
    RegisterPropertyHelper(@TDNSSendAuthoritative_R,nil,'Authoritative');
    RegisterPropertyHelper(@TDNSSendTruncated_R,nil,'Truncated');
    RegisterPropertyHelper(@TDNSSendAnswerInfo_R,nil,'AnswerInfo');
    RegisterPropertyHelper(@TDNSSendNameserverInfo_R,nil,'NameserverInfo');
    RegisterPropertyHelper(@TDNSSendAdditionalInfo_R,nil,'AdditionalInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dnssend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDNSSend(CL);
end;

 
 
{ TPSImport_dnssend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dnssend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dnssend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dnssend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dnssend(ri);
  RIRegister_dnssend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
