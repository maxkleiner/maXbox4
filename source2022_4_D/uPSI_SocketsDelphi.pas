unit uPSI_SocketsDelphi;
{
  from extpascal framework
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
  TPSImport_SocketsDelphi = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_SocketsDelphi(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SocketsDelphi_Routines(S: TPSExec);

procedure Register;

implementation


uses
   WinSockDelphi
  ,SocketsDelphi
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SocketsDelphi]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SocketsDelphi(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('cint8', 'shortint');
  CL.AddTypeS('cuint8', 'byte');
  CL.AddTypeS('cchar', 'cint8');
  CL.AddTypeS('cschar', 'cint8');
  CL.AddTypeS('cuchar', 'cuint8');
  CL.AddTypeS('cint16', 'smallint');
  CL.AddTypeS('cuint16', 'word');
  CL.AddTypeS('cshort', 'cint16');
  CL.AddTypeS('csshort', 'cint16');
  CL.AddTypeS('cushort', 'cuint16');
  CL.AddTypeS('cint32', 'longint');
  CL.AddTypeS('cuint32', 'longword');
  CL.AddTypeS('cint', 'cint32');
  CL.AddTypeS('csint', 'cint32');
  CL.AddTypeS('cuint', 'cuint32');
  CL.AddTypeS('csigned', 'cint');
  CL.AddTypeS('cunsigned', 'cuint');
  CL.AddTypeS('cint64', 'int64');
  CL.AddTypeS('clonglong', 'cint64');
  CL.AddTypeS('cslonglong', 'cint64');
  CL.AddTypeS('cbool', 'longbool');
  CL.AddTypeS('cfloat', 'single');
  CL.AddTypeS('cdouble', 'double');
  CL.AddTypeS('clongdouble', 'extended');
  CL.AddTypeS('size_t', 'cuint32');
  CL.AddTypeS('ssize_t', 'cint32');
  CL.AddTypeS('tsocklen', 'cint');
  CL.AddTypeS('sa_family_t', 'cuchar');
  CL.AddTypeS('sa_family_t', 'cushort');
 CL.AddConstantN('SOCK_STREAM','LongInt').SetInt( 1);
 CL.AddConstantN('SOCK_DGRAM','LongInt').SetInt( 2);
 CL.AddConstantN('SOCK_RAW','LongInt').SetInt( 3);
 CL.AddConstantN('SOCK_RDM','LongInt').SetInt( 4);
 CL.AddConstantN('SOCK_SEQPACKET','LongInt').SetInt( 5);
 CL.AddConstantN('INADDR_ANY','LongInt').SetInt( CARDINAL ( 0 ));
 CL.AddConstantN('INADDR_NONE','LongWord').SetUInt( CARDINAL ( $FFFFFFFF ));
 CL.AddConstantN('S_IN','LongInt').SetInt( 0);
 CL.AddConstantN('S_OUT','LongInt').SetInt( 1);
  CL.AddTypeS('in_addr', 'record s_bytes: array[1..4] of byte; end');
  CL.AddTypeS('TIn_addr', 'in_addr');
  CL.AddTypeS('TInAddr', 'in_addr');
  //CL.AddTypeS('PInAddr', 'pin_addr');
  //CL.AddTypeS('TInetSockAddr', 'sockaddr_in');
  //CL.AddTypeS('PInetSockAddr', 'psockaddr_in');
  //CL.AddTypeS('TLinger', 'linger');
  CL.AddTypeS('Tsocket', 'longint');
 CL.AddDelphiFunction('Function socketerror : cint');
 CL.AddDelphiFunction('Function fpsocket( domain : cint; xtype : cint; protocol : cint) : cint');
 CL.AddDelphiFunction('Function fprecv( s : cint; buf : ___pointer; len : size_t; flags : cint) : ssize_t');
 CL.AddDelphiFunction('Function fpsend( s : cint; msg : ___pointer; len : size_t; flags : cint) : ssize_t');
 //CL.AddDelphiFunction('Function fpbind( s : cint; addrx : psockaddr; addrlen : tsocklen) : cint');
 CL.AddDelphiFunction('Function fplisten( s : cint; backlog : cint) : cint');
 //CL.AddDelphiFunction('Function fpaccept( s : cint; addrx : psockaddr; addrlen : plongint) : cint');
 //CL.AddDelphiFunction('Function fpconnect( s : cint; name : psockaddr; namelen : tsocklen) : cint');
 //CL.AddDelphiFunction('Function fpgetsockname( s : cint; name : psockaddr; namelen : psocklen) : cint');
 CL.AddDelphiFunction('Function NetAddrToStr( Entry : in_addr) : String');
 CL.AddDelphiFunction('Function HostAddrToStr( Entry : in_addr) : String');
 CL.AddDelphiFunction('Function StrToHostAddr( IP : String) : in_addr');
 CL.AddDelphiFunction('Function StrToNetAddr( IP : String) : in_addr');
 CL.AddConstantN('SOL_SOCKET','LongWord').SetUInt( $ffff);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SocketsDelphi_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@socketerror, 'socketerror', cdRegister);
 S.RegisterDelphiFunction(@fpsocket, 'fpsocket', cdRegister);
 S.RegisterDelphiFunction(@fprecv, 'fprecv', cdRegister);
 S.RegisterDelphiFunction(@fpsend, 'fpsend', cdRegister);
 S.RegisterDelphiFunction(@fpbind, 'fpbind', cdRegister);
 S.RegisterDelphiFunction(@fplisten, 'fplisten', cdRegister);
 S.RegisterDelphiFunction(@fpaccept, 'fpaccept', cdRegister);
 S.RegisterDelphiFunction(@fpconnect, 'fpconnect', cdRegister);
 S.RegisterDelphiFunction(@fpgetsockname, 'fpgetsockname', cdRegister);
 S.RegisterDelphiFunction(@NetAddrToStr, 'NetAddrToStr', cdRegister);
 S.RegisterDelphiFunction(@HostAddrToStr, 'HostAddrToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToHostAddr, 'StrToHostAddr', cdRegister);
 S.RegisterDelphiFunction(@StrToNetAddr, 'StrToNetAddr', cdRegister);
end;

 
 
{ TPSImport_SocketsDelphi }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SocketsDelphi.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SocketsDelphi(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SocketsDelphi.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_SocketsDelphi(ri);
  RIRegister_SocketsDelphi_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
