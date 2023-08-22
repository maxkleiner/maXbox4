unit uPSI_IdStack;
{
  the base to test and trace
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
  TPSImport_IdStack = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdStack(CL: TPSPascalCompiler);
procedure SIRegister_TIdSocketList(CL: TPSPascalCompiler);
procedure SIRegister_IdStack(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdStack(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSocketList(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdStack(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdStackConsts
  ,IdGlobal_max
  ,IdStack
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdStack]);
end;

function CreateIDStack: TIdStack;
begin
  Result:= GStackClass.Create;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdStack(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIdStack') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIdStack') do begin
    RegisterMethod('Function HostToNetwork( AValue : Word) : Word');
    RegisterMethod('Function NetworkToHost( AValue : Word) : Word');
    RegisterMethod('Function CheckForSocketError( const AResult : integer) : boolean;');
    RegisterMethod('Function CheckForSocketError1( const AResult : integer; const AIgnore : array of integer) : boolean;');
    RegisterMethod('Constructor Create');
    RegisterMethod('Function CreateStack : TIdStack');
    RegisterMethod('Function CreateSocketHandle( const ASocketType : Integer; const AProtocol : Integer) : TIdStackSocketHandle');
    RegisterMethod('Function GetIPInfo( const AIP : string; VB1 : PByte; VB2 : PByte; VB3 : PByte; VB4 : PByte; VType : PIdIPType; VClass : PIdIPClass) : Boolean');
    RegisterMethod('Function GetIPType( const AIP : string) : TIdIPType');
    RegisterMethod('Function GetIPClass( const AIP : string) : TIdIPClass');
    RegisterMethod('Function IsIP( const AIP : string) : boolean');
    RegisterMethod('Function IPIsType( const AIP : string; const AType : TIdIPType) : boolean;');
    RegisterMethod('Function IPIsType1( const AIP : string; const ATypes : array of TIdIPType) : boolean;');
    RegisterMethod('Function IPIsClass( const AIP : string; const AClass : TIdIPClass) : boolean;');
    RegisterMethod('Function IPIsClass1( const AIP : string; const AClasses : array of TIdIPClass) : boolean;');
    RegisterMethod('Function IsDottedIP( const AIP : string) : boolean');
    RegisterMethod('Function IsNumericIP( const AIP : string) : boolean');
    RegisterMethod('Procedure RaiseSocketError( const AErr : integer)');
    RegisterMethod('Function ResolveHost( const AHost : string) : string');
    RegisterMethod('Function WSAccept( ASocket : TIdStackSocketHandle; var VIP : string; var VPort : Integer) : TIdStackSocketHandle');
    RegisterMethod('Function WSBind( ASocket : TIdStackSocketHandle; const AFamily : Integer; const AIP : string; const APort : Integer) : Integer');
    RegisterMethod('Function WSCloseSocket( ASocket : TIdStackSocketHandle) : Integer');
    RegisterMethod('Function WSConnect( const ASocket : TIdStackSocketHandle; const AFamily : Integer; const AIP : string; const APort : Integer) : Integer');
    RegisterMethod('Function WSGetHostByName( const AHostName : string) : string');
    RegisterMethod('Function WSGetHostName : string');
    RegisterMethod('Function WSGetHostByAddr( const AAddress : string) : string');
    RegisterMethod('Function WSGetServByName( const AServiceName : string) : Integer');
    RegisterMethod('Function WSGetServByPort( const APortNumber : Integer) : TStrings');
    RegisterMethod('Function WSHToNs( AHostShort : Word) : Word');
    RegisterMethod('Function WSListen( ASocket : TIdStackSocketHandle; ABackLog : Integer) : Integer');
    RegisterMethod('Function WSNToHs( ANetShort : Word) : Word');
    RegisterMethod('Function WSHToNL( AHostLong : LongWord) : LongWord');
    RegisterMethod('Function WSNToHL( ANetLong : LongWord) : LongWord');
    RegisterMethod('Function WSRecv( ASocket : TIdStackSocketHandle; var ABuffer : string; const ABufferLength, AFlags : Integer) : Integer');
    RegisterMethod('Function WSRecvFrom( const ASocket : TIdStackSocketHandle; var ABuffer : string; const ALength, AFlags : Integer; var VIP : string; var VPort : Integer) : Integer');
    RegisterMethod('Function WSSelect( ARead, AWrite, AErrors : TList; ATimeout : Integer) : Integer');
    RegisterMethod('Function WSSend( ASocket : TIdStackSocketHandle; var ABuffer : string; const ABufferLength, AFlags : Integer) : Integer');
    RegisterMethod('Function WSSendTo( ASocket : TIdStackSocketHandle; var ABuffer : string; const ABufferLength, AFlags : Integer; const AIP : string; const APort : integer) : Integer');
    RegisterMethod('Function WSSetSockOpt( ASocket : TIdStackSocketHandle; ALevel, AOptName : Integer; AOptVal : PChar; AOptLen : Integer) : Integer');
    RegisterMethod('Function WSSocket( AFamily, AStruct, AProtocol : Integer) : TIdStackSocketHandle');
    RegisterMethod('Function WSShutdown( ASocket : TIdStackSocketHandle; AHow : Integer) : Integer');
    RegisterMethod('Function WSTranslateSocketErrorMsg( const AErr : integer) : string');
    RegisterMethod('Function WSGetLastError : Integer');
    RegisterMethod('Procedure WSGetPeerName( ASocket : TIdStackSocketHandle; var AFamily : Integer; var AIP : string; var APort : Integer)');
    RegisterMethod('Procedure WSGetSockName( ASocket : TIdStackSocketHandle; var AFamily : Integer; var AIP : string; var APort : Integer)');
    RegisterMethod('Function WSGetSockOpt( ASocket : TIdStackSocketHandle; Alevel, AOptname : Integer; AOptval : PChar; var AOptlen : Integer) : Integer');
    RegisterMethod('Function StringToTInAddr( AIP : string) : TIdInAddr');
    RegisterMethod('Function TInAddrToString( var AInAddr) : string');
    RegisterMethod('Procedure TranslateStringToTInAddr( AIP : string; var AInAddr)');
    RegisterProperty('LastError', 'Integer', iptr);
    RegisterProperty('LocalAddress', 'string', iptr);
    RegisterProperty('LocalAddresses', 'TStrings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSocketList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIdSocketList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIdSocketList') do begin
    RegisterMethod('Procedure Add( AHandle : TIdStackSocketHandle)');
    RegisterMethod('Function CreateSocketList : TIdSocketList');
    RegisterMethod('Procedure Remove( AHandle : TIdStackSocketHandle)');
    RegisterMethod('Function Count : Integer');
    RegisterProperty('Items', 'TIdStackSocketHandle Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdStack(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PIdInAddr', '^TIdInAddr // will not work');
  CL.AddTypeS('TIdInAddr', 'record S_addr: longword; end');    //from socks

  //  TSocket = u_int;
   CL.AddTypeS('TSocket', 'Integer');    //from socks
   CL.AddTypeS('TIdStackSocketHandle', 'TSocket');    //from socks
  //type
  //TIdStackSocketHandle = TSocket;

  CL.AddTypeS('TIdIPType', '( Id_IPInvalid, Id_IPDotted, Id_IPNumeric )');
  //CL.AddTypeS('PIdIPType', '^TIdIPType // will not work');
  CL.AddTypeS('TIdIPClass', '( Id_IPClassUnkn, Id_IPClassA, Id_IPClassB, Id_IPC'
   +'lassC, Id_IPClassD, Id_IPClassE )');
  //CL.AddTypeS('PIdIPClass', '^TIdIPClass // will not work');
  //CL.AddTypeS('TIdSocketListClass', 'class of TIdSocketList');
  SIRegister_TIdSocketList(CL);
  SIRegister_TIdStack(CL);
  //CL.AddTypeS('TIdStackClass', 'class of TIdStack');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdStackError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdStackInitializationFailed');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdStackSetSizeExceeded');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdInvalidIPAddress');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdStackLocalAddresses_R(Self: TIdStack; var T: TStrings);
begin T := Self.LocalAddresses; end;

(*----------------------------------------------------------------------------*)
procedure TIdStackLocalAddress_R(Self: TIdStack; var T: string);
begin T := Self.LocalAddress; end;

(*----------------------------------------------------------------------------*)
procedure TIdStackLastError_R(Self: TIdStack; var T: Integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
Function TIdStackIPIsClass1_P(Self: TIdStack;  const AIP : string; const AClasses : array of TIdIPClass) : boolean;
Begin Result := Self.IPIsClass(AIP, AClasses); END;

(*----------------------------------------------------------------------------*)
Function TIdStackIPIsClass_P(Self: TIdStack;  const AIP : string; const AClass : TIdIPClass) : boolean;
Begin Result := Self.IPIsClass(AIP, AClass); END;

(*----------------------------------------------------------------------------*)
Function TIdStackIPIsType1_P(Self: TIdStack;  const AIP : string; const ATypes : array of TIdIPType) : boolean;
Begin Result := Self.IPIsType(AIP, ATypes); END;

(*----------------------------------------------------------------------------*)
Function TIdStackIPIsType_P(Self: TIdStack;  const AIP : string; const AType : TIdIPType) : boolean;
Begin Result := Self.IPIsType(AIP, AType); END;

(*----------------------------------------------------------------------------*)
Function TIdStackCheckForSocketError1_P(Self: TIdStack;  const AResult : integer; const AIgnore : array of integer) : boolean;
Begin Result := Self.CheckForSocketError(AResult, AIgnore); END;

(*----------------------------------------------------------------------------*)
Function TIdStackCheckForSocketError_P(Self: TIdStack;  const AResult : integer) : boolean;
Begin Result := Self.CheckForSocketError(AResult); END;

(*----------------------------------------------------------------------------*)
procedure TIdSocketListItems_R(Self: TIdSocketList; var T: TIdStackSocketHandle; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdStack(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdStack) do begin
    RegisterMethod(@TIdStack.HostToNetwork, 'HostToNetwork');
    RegisterMethod(@TIdStack.NetworkToHost, 'NetworkToHost');
    RegisterMethod(@TIdStackCheckForSocketError_P, 'CheckForSocketError');
    RegisterMethod(@TIdStackCheckForSocketError1_P, 'CheckForSocketError1');
    RegisterVirtualConstructor(@TIdStack.Create, 'Create');
    RegisterMethod(@TIdStack.CreateStack, 'CreateStack');
    RegisterMethod(@TIdStack.CreateSocketHandle, 'CreateSocketHandle');
    RegisterMethod(@TIdStack.GetIPInfo, 'GetIPInfo');
    RegisterMethod(@TIdStack.GetIPType, 'GetIPType');
    RegisterMethod(@TIdStack.GetIPClass, 'GetIPClass');
    RegisterMethod(@TIdStack.IsIP, 'IsIP');
    RegisterMethod(@TIdStackIPIsType_P, 'IPIsType');
    RegisterMethod(@TIdStackIPIsType1_P, 'IPIsType1');
    RegisterMethod(@TIdStackIPIsClass_P, 'IPIsClass');
    RegisterMethod(@TIdStackIPIsClass1_P, 'IPIsClass1');
    RegisterMethod(@TIdStack.IsDottedIP, 'IsDottedIP');
    RegisterMethod(@TIdStack.IsNumericIP, 'IsNumericIP');
    RegisterMethod(@TIdStack.RaiseSocketError, 'RaiseSocketError');
    RegisterMethod(@TIdStack.ResolveHost, 'ResolveHost');
   { RegisterVirtualAbstractMethod(@TIdStack, @!.WSAccept, 'WSAccept');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSBind, 'WSBind');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSCloseSocket, 'WSCloseSocket');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSConnect, 'WSConnect');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetHostByName, 'WSGetHostByName');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetHostName, 'WSGetHostName');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetHostByAddr, 'WSGetHostByAddr');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetServByName, 'WSGetServByName');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetServByPort, 'WSGetServByPort');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSHToNs, 'WSHToNs');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSListen, 'WSListen');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSNToHs, 'WSNToHs');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSHToNL, 'WSHToNL');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSNToHL, 'WSNToHL');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSRecv, 'WSRecv');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSRecvFrom, 'WSRecvFrom');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSSelect, 'WSSelect');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSSend, 'WSSend');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSSendTo, 'WSSendTo');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSSetSockOpt, 'WSSetSockOpt');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSSocket, 'WSSocket');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSShutdown, 'WSShutdown');  }
    RegisterVirtualMethod(@TIdStack.WSTranslateSocketErrorMsg, 'WSTranslateSocketErrorMsg');
    {RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetLastError, 'WSGetLastError');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetPeerName, 'WSGetPeerName');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetSockName, 'WSGetSockName');
    RegisterVirtualAbstractMethod(@TIdStack, @!.WSGetSockOpt, 'WSGetSockOpt');$}
    RegisterMethod(@TIdStack.StringToTInAddr, 'StringToTInAddr');
    //RegisterVirtualAbstractMethod(@TIdStack, @!.TInAddrToString, 'TInAddrToString');
    //RegisterVirtualAbstractMethod(@TIdStack, @!.TranslateStringToTInAddr, 'TranslateStringToTInAddr');
    RegisterPropertyHelper(@TIdStackLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TIdStackLocalAddress_R,nil,'LocalAddress');
    RegisterPropertyHelper(@TIdStackLocalAddresses_R,nil,'LocalAddresses');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSocketList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSocketList) do begin
    //RegisterVirtualAbstractMethod(@TIdSocketList, @!.Add, 'Add');
    RegisterMethod(@TIdSocketList.CreateSocketList, 'CreateSocketList');
    //RegisterVirtualAbstractMethod(@TIdSocketList, @!.Remove, 'Remove');
    //RegisterVirtualAbstractMethod(@TIdSocketList, @!.Count, 'Count');
    RegisterPropertyHelper(@TIdSocketListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdStack(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdSocketList(CL);
  RIRegister_TIdStack(CL);
  with CL.Add(EIdStackError) do
  with CL.Add(EIdStackInitializationFailed) do
  with CL.Add(EIdStackSetSizeExceeded) do
  with CL.Add(EIdInvalidIPAddress) do
end;

 
 
{ TPSImport_IdStack }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdStack.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdStack(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdStack.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdStack(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
