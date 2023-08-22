unit uPSI_IdSocks;
{
   socks and tcp base
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
  TPSImport_IdSocks = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdSocksInfo(CL: TPSPascalCompiler);
procedure SIRegister_IdSocks(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdSocksInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdSocks(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdIOHandler
  ,IdComponent
  ,IdStack
  ,IdSocks
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdSocks]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSocksInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdSocksInfo') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdSocksInfo') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure MakeSocksConnection( const AHost : string; const APort : Integer)');
    RegisterMethod('Procedure MakeSocks4Connection( const AHost : string; const APort : Integer)');
    RegisterMethod('Procedure MakeSocks5Connection( const AHost : string; const APort : Integer)');
    RegisterProperty('IOHandler', 'TIdIOHandler', iptw);
    RegisterProperty('Authentication', 'TSocksAuthentication', iptrw);
    RegisterProperty('Host', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('Username', 'string', iptrw);
    RegisterProperty('Version', 'TSocksVersion', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdSocks(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSocksVersion', '( svNoSocks, svSocks4, svSocks4A, svSocks5 )');
  CL.AddTypeS('TSocksAuthentication', '( saNoAuthentication, saUsernamePassword)');
  //CL.AddConstantN('ID_SOCKS_AUTH','TSocksVersion').SetSet(saNoAuthentication);
 //CL.AddConstantN('ID_SOCKS_VER','').SetString( svNoSocks);

 //CL.AddTypeS('TIdInAddr', 'record S_addr: longword; end');

  { TIdInAddr = record
    case integer of
      0: (S_un_b: TIdSunB);
      1: (S_un_w: TIdSunW);
      2: (S_addr: longword);
  end;}

  CL.AddTypeS('TIdSocksRequest', 'record Version : Byte; OpCode : Byte; Port : '
   +'Word; IpAddr : TIdInAddr; UserName : String; end');
  CL.AddTypeS('TIdSocksResponse', 'record Version : Byte; OpCode : Byte; Port :'
   +' Word; IpAddr : TIdInAddr; end');
  SIRegister_TIdSocksInfo(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoVersion_W(Self: TIdSocksInfo; const T: TSocksVersion);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoVersion_R(Self: TIdSocksInfo; var T: TSocksVersion);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoUsername_W(Self: TIdSocksInfo; const T: string);
begin Self.Username := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoUsername_R(Self: TIdSocksInfo; var T: string);
begin T := Self.Username; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoPort_W(Self: TIdSocksInfo; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoPort_R(Self: TIdSocksInfo; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoPassword_W(Self: TIdSocksInfo; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoPassword_R(Self: TIdSocksInfo; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoHost_W(Self: TIdSocksInfo; const T: string);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoHost_R(Self: TIdSocksInfo; var T: string);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoAuthentication_W(Self: TIdSocksInfo; const T: TSocksAuthentication);
begin Self.Authentication := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoAuthentication_R(Self: TIdSocksInfo; var T: TSocksAuthentication);
begin T := Self.Authentication; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocksInfoIOHandler_W(Self: TIdSocksInfo; const T: TIdIOHandler);
begin Self.IOHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSocksInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSocksInfo) do
  begin
    RegisterConstructor(@TIdSocksInfo.Create, 'Create');
    RegisterMethod(@TIdSocksInfo.MakeSocksConnection, 'MakeSocksConnection');
    RegisterMethod(@TIdSocksInfo.MakeSocks4Connection, 'MakeSocks4Connection');
    RegisterMethod(@TIdSocksInfo.MakeSocks5Connection, 'MakeSocks5Connection');
    RegisterPropertyHelper(nil,@TIdSocksInfoIOHandler_W,'IOHandler');
    RegisterPropertyHelper(@TIdSocksInfoAuthentication_R,@TIdSocksInfoAuthentication_W,'Authentication');
    RegisterPropertyHelper(@TIdSocksInfoHost_R,@TIdSocksInfoHost_W,'Host');
    RegisterPropertyHelper(@TIdSocksInfoPassword_R,@TIdSocksInfoPassword_W,'Password');
    RegisterPropertyHelper(@TIdSocksInfoPort_R,@TIdSocksInfoPort_W,'Port');
    RegisterPropertyHelper(@TIdSocksInfoUsername_R,@TIdSocksInfoUsername_W,'Username');
    RegisterPropertyHelper(@TIdSocksInfoVersion_R,@TIdSocksInfoVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSocks(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdSocksInfo(CL);
end;

 
 
{ TPSImport_IdSocks }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSocks.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdSocks(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSocks.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdSocks(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
