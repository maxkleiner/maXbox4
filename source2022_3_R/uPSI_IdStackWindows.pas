unit uPSI_IdStackWindows;
{
   extract from idstack pull up
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
  TPSImport_IdStackWindows = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdStackWindows(CL: TPSPascalCompiler);
procedure SIRegister_TIdSocketListWindows(CL: TPSPascalCompiler);
procedure SIRegister_IdStackWindows(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdStackWindows(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSocketListWindows(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdStackWindows(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdStack
  ,IdStackConsts
  ,IdWinsock2
  ,Windows
  ,IdStackWindows
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdStackWindows]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdStackWindows(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdStack', 'TIdStackWindows') do
  with CL.AddClassN(CL.FindClass('TIdStack'),'TIdStackWindows') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function TInAddrToString( var AInAddr) : string');
    RegisterMethod('Procedure TranslateStringToTInAddr( AIP : string; var AInAddr)');
    RegisterMethod('Function WSAccept( ASocket : TIdStackSocketHandle; var VIP : string; var VPort : Integer) : TIdStackSocketHandle');
    RegisterMethod('Function WSBind( ASocket : TIdStackSocketHandle; const AFamily : Integer; const AIP : string; const APort : Integer) : Integer');
    RegisterMethod('Function WSCloseSocket( ASocket : TIdStackSocketHandle) : Integer');
    RegisterMethod('Function WSConnect( const ASocket : TIdStackSocketHandle; const AFamily : Integer; const AIP : string; const APort : Integer) : Integer');
    RegisterMethod('Function WSGetHostByAddr( const AAddress : string) : string');
    RegisterMethod('Function WSGetHostByName( const AHostName : string) : string');
    RegisterMethod('Function WSGetHostName : string');
    RegisterMethod('Function WSGetServByName( const AServiceName : string) : Integer');
    RegisterMethod('Function WSGetServByPort( const APortNumber : Integer) : TStrings');
    RegisterMethod('Procedure WSGetPeerName( ASocket : TIdStackSocketHandle; var VFamily : Integer; var VIP : string; var VPort : Integer)');
    RegisterMethod('Procedure WSGetSockName( ASocket : TIdStackSocketHandle; var VFamily : Integer; var VIP : string; var VPort : Integer)');
    RegisterMethod('Function WSHToNs( AHostShort : Word) : Word');
    RegisterMethod('Function WSListen( ASocket : TIdStackSocketHandle; ABackLog : Integer) : Integer');
    RegisterMethod('Function WSNToHs( ANetShort : Word) : Word');
    RegisterMethod('Function WSHToNL( AHostLong : LongWord) : LongWord');
    RegisterMethod('Function WSNToHL( ANetLong : LongWord) : LongWord');
    RegisterMethod('Function WSRecv( ASocket : TIdStackSocketHandle; var ABuffer : string; const ABufferLength, AFlags : Integer) : integer');
    RegisterMethod('Function WSRecvFrom( const ASocket : TIdStackSocketHandle; var ABuffer : string; const ALength, AFlags : Integer; var VIP : string; var VPort : Integer) : Integer');
    RegisterMethod('Function WSSelect( ARead, AWrite, AErrors : TList; ATimeout : Integer) : Integer');
    RegisterMethod('Function WSSend( ASocket : TIdStackSocketHandle; var ABuffer : string; const ABufferLength, AFlags : Integer) : Integer');
    RegisterMethod('Function WSSendTo( ASocket : TIdStackSocketHandle; var ABuffer : string; const ABufferLength, AFlags : Integer; const AIP : string; const APort : integer) : Integer');
    RegisterMethod('Function WSSetSockOpt( ASocket : TIdStackSocketHandle; ALevel, AOptName : Integer; AOptVal : PChar; AOptLen : Integer) : Integer');
    RegisterMethod('Function WSSocket( AFamily, AStruct, AProtocol : Integer) : TIdStackSocketHandle');
    RegisterMethod('Function WSShutdown( ASocket : TIdStackSocketHandle; AHow : Integer) : Integer');
    RegisterMethod('Function WSTranslateSocketErrorMsg( const AErr : integer) : string');
    RegisterMethod('Function WSGetLastError : Integer');
    RegisterMethod('Function WSGetSockOpt( ASocket : TIdStackSocketHandle; Alevel, AOptname : Integer; AOptval : PChar; var AOptlen : Integer) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSocketListWindows(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdSocketList', 'TIdSocketListWindows') do
  with CL.AddClassN(CL.FindClass('TIdSocketList'),'TIdSocketListWindows') do
  begin
    RegisterMethod('Procedure Add( AHandle : TIdStackSocketHandle)');
    RegisterMethod('Procedure Remove( AHandle : TIdStackSocketHandle)');
    RegisterMethod('Function Count : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdStackWindows(CL: TPSPascalCompiler);
begin
  SIRegister_TIdSocketListWindows(CL);
  SIRegister_TIdStackWindows(CL);
  CL.AddTypeS('TLinger', 'record l_onoff : Word; l_linger : Word; end');
  CL.AddTypeS('TIdLinger', 'TLinger');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdStackWindows(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdStackWindows) do begin
    RegisterConstructor(@TIdStackWindows.Create, 'Create');
      RegisterMethod(@TIdStackWindows.Destroy, 'Free');
      RegisterMethod(@TIdStackWindows.TInAddrToString, 'TInAddrToString');
    RegisterMethod(@TIdStackWindows.TranslateStringToTInAddr, 'TranslateStringToTInAddr');
    RegisterMethod(@TIdStackWindows.WSAccept, 'WSAccept');
    RegisterMethod(@TIdStackWindows.WSBind, 'WSBind');
    RegisterMethod(@TIdStackWindows.WSCloseSocket, 'WSCloseSocket');
    RegisterMethod(@TIdStackWindows.WSConnect, 'WSConnect');
    RegisterMethod(@TIdStackWindows.WSGetHostByAddr, 'WSGetHostByAddr');
    RegisterMethod(@TIdStackWindows.WSGetHostByName, 'WSGetHostByName');
    RegisterMethod(@TIdStackWindows.WSGetHostName, 'WSGetHostName');
    RegisterMethod(@TIdStackWindows.WSGetServByName, 'WSGetServByName');
    RegisterMethod(@TIdStackWindows.WSGetServByPort, 'WSGetServByPort');
    RegisterMethod(@TIdStackWindows.WSGetPeerName, 'WSGetPeerName');
    RegisterMethod(@TIdStackWindows.WSGetSockName, 'WSGetSockName');
    RegisterMethod(@TIdStackWindows.WSHToNs, 'WSHToNs');
    RegisterMethod(@TIdStackWindows.WSListen, 'WSListen');
    RegisterMethod(@TIdStackWindows.WSNToHs, 'WSNToHs');
    RegisterMethod(@TIdStackWindows.WSHToNL, 'WSHToNL');
    RegisterMethod(@TIdStackWindows.WSNToHL, 'WSNToHL');
    RegisterMethod(@TIdStackWindows.WSRecv, 'WSRecv');
    RegisterMethod(@TIdStackWindows.WSRecvFrom, 'WSRecvFrom');
    RegisterMethod(@TIdStackWindows.WSSelect, 'WSSelect');
    RegisterMethod(@TIdStackWindows.WSSend, 'WSSend');
    RegisterMethod(@TIdStackWindows.WSSendTo, 'WSSendTo');
    RegisterMethod(@TIdStackWindows.WSSetSockOpt, 'WSSetSockOpt');
    RegisterMethod(@TIdStackWindows.WSSocket, 'WSSocket');
    RegisterMethod(@TIdStackWindows.WSShutdown, 'WSShutdown');
    RegisterMethod(@TIdStackWindows.WSTranslateSocketErrorMsg, 'WSTranslateSocketErrorMsg');
    RegisterMethod(@TIdStackWindows.WSGetLastError, 'WSGetLastError');
    RegisterMethod(@TIdStackWindows.WSGetSockOpt, 'WSGetSockOpt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSocketListWindows(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSocketListWindows) do
  begin
    RegisterMethod(@TIdSocketListWindows.Add, 'Add');
    RegisterMethod(@TIdSocketListWindows.Remove, 'Remove');
    RegisterMethod(@TIdSocketListWindows.Count, 'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdStackWindows(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdSocketListWindows(CL);
  RIRegister_TIdStackWindows(CL);
end;

 
 
{ TPSImport_IdStackWindows }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdStackWindows.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdStackWindows(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdStackWindows.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdStackWindows(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
