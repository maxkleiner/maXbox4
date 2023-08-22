unit uPSI_ALPOP3Client;
{
   POP and SMS with XML on UML to FTP
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
  TPSImport_ALPOP3Client = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAlPOP3Client(CL: TPSPascalCompiler);
procedure SIRegister_ALPOP3Client(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAlPOP3Client(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALPOP3Client(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinSock2
  WinSock
  ,ALStringList
  ,ALInternetMessageCommon
  ,ALPOP3Client
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALPOP3Client]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlPOP3Client(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAlPOP3Client') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAlPOP3Client') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Connect( const aHost : AnsiString; const APort : integer) : AnsiString');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function User( UserName : AnsiString) : AnsiString');
    RegisterMethod('Function Pass( Password : AnsiString) : AnsiString');
    RegisterMethod('Function List : AnsiString;');
    RegisterMethod('Procedure List1( ALst : TALStrings);');
    RegisterMethod('Function List2( aMsgNumber : integer) : AnsiString;');
    RegisterMethod('Function Uidl : AnsiString;');
    RegisterMethod('Procedure Uidl1( ALst : TALStrings);');
    RegisterMethod('Function Uidl2( aMsgNumber : Integer) : AnsiString;');
    RegisterMethod('Procedure Uidl3( aMsgNumber : Integer; var aUniqueIDListing : AnsiString);');
    RegisterMethod('Function Quit : AnsiString');
    RegisterMethod('Function Rset : AnsiString');
    RegisterMethod('Function Stat : AnsiString;');
    RegisterMethod('Procedure Stat1( var ANumberofMsgInthemaildrop : Integer; var aSizeofthemaildrop : integer);');
    RegisterMethod('Function Retr( aMsgNumber : Integer) : AnsiString;');
    RegisterMethod('Procedure Retr1( aMsgNumber : Integer; var aMsgBodyContent : AnsiString; aMsgHeaderContent : TALEMailHeader);');
    RegisterMethod('Function Top( aMsgNumber : Integer; aNumberOfLines : integer) : AnsiString');
    RegisterMethod('Function Dele( aMsgNumber : Integer) : AnsiString');
    RegisterMethod('Function Noop : AnsiString');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('TcpNoDelay', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALPOP3Client(CL: TPSPascalCompiler);
begin
  SIRegister_TAlPOP3Client(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientTcpNoDelay_W(Self: TAlPOP3Client; const T: Boolean);
begin Self.TcpNoDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientTcpNoDelay_R(Self: TAlPOP3Client; var T: Boolean);
begin T := Self.TcpNoDelay; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientKeepAlive_W(Self: TAlPOP3Client; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientKeepAlive_R(Self: TAlPOP3Client; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientReceiveTimeout_W(Self: TAlPOP3Client; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientReceiveTimeout_R(Self: TAlPOP3Client; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientSendTimeout_W(Self: TAlPOP3Client; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientSendTimeout_R(Self: TAlPOP3Client; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlPOP3ClientConnected_R(Self: TAlPOP3Client; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Procedure TAlPOP3ClientRetr1_P(Self: TAlPOP3Client;  aMsgNumber : Integer; var aMsgBodyContent : AnsiString; aMsgHeaderContent : TALEMailHeader);
Begin Self.Retr(aMsgNumber, aMsgBodyContent, aMsgHeaderContent); END;

(*----------------------------------------------------------------------------*)
Function TAlPOP3ClientRetr_P(Self: TAlPOP3Client;  aMsgNumber : Integer) : AnsiString;
Begin Result := Self.Retr(aMsgNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlPOP3ClientStat1_P(Self: TAlPOP3Client;  var ANumberofMsgInthemaildrop : Integer; var aSizeofthemaildrop : integer);
Begin Self.Stat(ANumberofMsgInthemaildrop, aSizeofthemaildrop); END;

(*----------------------------------------------------------------------------*)
Function TAlPOP3ClientStat_P(Self: TAlPOP3Client) : AnsiString;
Begin Result := Self.Stat; END;

(*----------------------------------------------------------------------------*)
Procedure TAlPOP3ClientUidl3_P(Self: TAlPOP3Client;  aMsgNumber : Integer; var aUniqueIDListing : AnsiString);
Begin Self.Uidl(aMsgNumber, aUniqueIDListing); END;

(*----------------------------------------------------------------------------*)
Function TAlPOP3ClientUidl2_P(Self: TAlPOP3Client;  aMsgNumber : Integer) : AnsiString;
Begin Result := Self.Uidl(aMsgNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlPOP3ClientUidl1_P(Self: TAlPOP3Client;  ALst : TALStrings);
Begin Self.Uidl(ALst); END;

(*----------------------------------------------------------------------------*)
Function TAlPOP3ClientUidl_P(Self: TAlPOP3Client) : AnsiString;
Begin Result := Self.Uidl; END;

(*----------------------------------------------------------------------------*)
Function TAlPOP3ClientList2_P(Self: TAlPOP3Client;  aMsgNumber : integer) : AnsiString;
Begin Result := Self.List(aMsgNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlPOP3ClientList1_P(Self: TAlPOP3Client;  ALst : TALStrings);
Begin Self.List(ALst); END;

(*----------------------------------------------------------------------------*)
Function TAlPOP3ClientList_P(Self: TAlPOP3Client) : AnsiString;
Begin Result := Self.List; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlPOP3Client(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlPOP3Client) do begin
    RegisterConstructor(@TAlPOP3Client.Create, 'Create');
     RegisterMethod(@TAlPOP3Client.Destroy,'Free');
    RegisterVirtualMethod(@TAlPOP3Client.Connect, 'Connect');
    RegisterVirtualMethod(@TAlPOP3Client.Disconnect, 'Disconnect');
    RegisterVirtualMethod(@TAlPOP3Client.User, 'User');
    RegisterVirtualMethod(@TAlPOP3Client.Pass, 'Pass');
    RegisterVirtualMethod(@TAlPOP3ClientList_P, 'List');
    RegisterVirtualMethod(@TAlPOP3ClientList1_P, 'List1');
    RegisterVirtualMethod(@TAlPOP3ClientList2_P, 'List2');
    RegisterVirtualMethod(@TAlPOP3ClientUidl_P, 'Uidl');
    RegisterVirtualMethod(@TAlPOP3ClientUidl1_P, 'Uidl1');
    RegisterVirtualMethod(@TAlPOP3ClientUidl2_P, 'Uidl2');
    RegisterVirtualMethod(@TAlPOP3ClientUidl3_P, 'Uidl3');
    RegisterVirtualMethod(@TAlPOP3Client.Quit, 'Quit');
    RegisterVirtualMethod(@TAlPOP3Client.Rset, 'Rset');
    RegisterVirtualMethod(@TAlPOP3ClientStat_P, 'Stat');
    RegisterVirtualMethod(@TAlPOP3ClientStat1_P, 'Stat1');
    RegisterVirtualMethod(@TAlPOP3ClientRetr_P, 'Retr');
    RegisterVirtualMethod(@TAlPOP3ClientRetr1_P, 'Retr1');
    RegisterVirtualMethod(@TAlPOP3Client.Top, 'Top');
    RegisterVirtualMethod(@TAlPOP3Client.Dele, 'Dele');
    RegisterVirtualMethod(@TAlPOP3Client.Noop, 'Noop');
    RegisterPropertyHelper(@TAlPOP3ClientConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TAlPOP3ClientSendTimeout_R,@TAlPOP3ClientSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TAlPOP3ClientReceiveTimeout_R,@TAlPOP3ClientReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TAlPOP3ClientKeepAlive_R,@TAlPOP3ClientKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@TAlPOP3ClientTcpNoDelay_R,@TAlPOP3ClientTcpNoDelay_W,'TcpNoDelay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALPOP3Client(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAlPOP3Client(CL);
end;

 
 
{ TPSImport_ALPOP3Client }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALPOP3Client.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALPOP3Client(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALPOP3Client.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALPOP3Client(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
