unit uPSI_cyBaseCommRoomConnector;
{
   interpool
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
  TPSImport_cyBaseCommRoomConnector = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyBaseCommRoomConnector(CL: TPSPascalCompiler);
procedure SIRegister_cyBaseCommRoomConnector(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyBaseCommRoomConnector(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyBaseCommRoomConnector(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,cyBaseComm
  ,cyBaseCommRoomConnector
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyBaseCommRoomConnector]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyBaseCommRoomConnector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyBaseCommRoomConnector') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyBaseCommRoomConnector') do
  begin
    RegisterMethod('Function GetRoomInfo : TcyRoomInfo');
    RegisterMethod('Function GetConnexions : TcyConnexions');
    RegisterMethod('Function AddConnexion( ConnexionInfo : TcyConnexionInfo) : Boolean;');
    RegisterMethod('Function AddConnexion1( BaseComHandle : Thandle; NickName : TNickName; ConnexionTag : Integer) : Boolean;');
    RegisterMethod('Function DeleteConnexion( ConnexionInfo : TcyConnexionInfo) : Integer;');
    RegisterMethod('Function DeleteConnexion1( BaseComHandle : THandle) : Integer;');
    RegisterMethod('Function UpdateConnexion( ConnexionInfo : TcyConnexionInfo) : Boolean;');
    RegisterMethod('Function UpdateConnexion1( BaseComHandle : Thandle; withNickName : TNickName; withTag : Integer) : Boolean;');
    RegisterMethod('Function GetConnexion( BaseComHandle : Thandle; var ConnexionInfo : TcyConnexionInfo) : Boolean;');
    RegisterMethod('Function GetConnexion1( WithNickName : TNickName; var ConnexionInfo : TcyConnexionInfo) : Boolean;');
    RegisterMethod('Function GetConnexion2( WithTag : Integer; var ConnexionInfo : TcyConnexionInfo) : Boolean;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyBaseCommRoomConnector(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNickName', 'String');
  CL.AddTypeS('TcyRoomInfo', 'record ConnexionCount : Integer; Tag : Integer; end');
  CL.AddTypeS('TcyConnexionInfo', 'record NickName : TNickName; BaseComHandle :'
   +' THandle; Tag : Integer; end');
  CL.AddTypeS('TcyConnexions', 'array of TcyConnexionInfo');
  SIRegister_TcyBaseCommRoomConnector(CL);
 CL.AddConstantN('sPrefixInstanceID','String').SetString( 'CYCOMMROOM');
 CL.AddConstantN('CmdAddedConnexion','LongInt').SetInt( 0);
 CL.AddConstantN('CmdRemovedConnexion','LongInt').SetInt( 1);
 CL.AddConstantN('CmdUpdatedConnexion','LongInt').SetInt( 2);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorGetConnexion2_P(Self: TcyBaseCommRoomConnector;  WithTag : Integer; var ConnexionInfo : TcyConnexionInfo) : Boolean;
Begin Result := Self.GetConnexion(WithTag, ConnexionInfo); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorGetConnexion1_P(Self: TcyBaseCommRoomConnector;  WithNickName : TNickName; var ConnexionInfo : TcyConnexionInfo) : Boolean;
Begin Result := Self.GetConnexion(WithNickName, ConnexionInfo); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorGetConnexion_P(Self: TcyBaseCommRoomConnector;  BaseComHandle : Thandle; var ConnexionInfo : TcyConnexionInfo) : Boolean;
Begin Result := Self.GetConnexion(BaseComHandle, ConnexionInfo); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorUpdateConnexion1_P(Self: TcyBaseCommRoomConnector;  BaseComHandle : Thandle; withNickName : TNickName; withTag : Integer) : Boolean;
Begin Result := Self.UpdateConnexion(BaseComHandle, withNickName, withTag); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorUpdateConnexion_P(Self: TcyBaseCommRoomConnector;  ConnexionInfo : TcyConnexionInfo) : Boolean;
Begin Result := Self.UpdateConnexion(ConnexionInfo); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorDeleteConnexion1_P(Self: TcyBaseCommRoomConnector;  BaseComHandle : THandle) : Integer;
Begin Result := Self.DeleteConnexion(BaseComHandle); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorDeleteConnexion_P(Self: TcyBaseCommRoomConnector;  ConnexionInfo : TcyConnexionInfo) : Integer;
Begin Result := Self.DeleteConnexion(ConnexionInfo); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorAddConnexion1_P(Self: TcyBaseCommRoomConnector;  BaseComHandle : Thandle; NickName : TNickName; ConnexionTag : Integer) : Boolean;
Begin Result := Self.AddConnexion(BaseComHandle, NickName, ConnexionTag); END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommRoomConnectorAddConnexion_P(Self: TcyBaseCommRoomConnector;  ConnexionInfo : TcyConnexionInfo) : Boolean;
Begin Result := Self.AddConnexion(ConnexionInfo); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyBaseCommRoomConnector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyBaseCommRoomConnector) do
  begin
    RegisterMethod(@TcyBaseCommRoomConnector.GetRoomInfo, 'GetRoomInfo');
    RegisterMethod(@TcyBaseCommRoomConnector.GetConnexions, 'GetConnexions');
    RegisterMethod(@TcyBaseCommRoomConnectorAddConnexion_P, 'AddConnexion');
    RegisterMethod(@TcyBaseCommRoomConnectorAddConnexion1_P, 'AddConnexion1');
    RegisterMethod(@TcyBaseCommRoomConnectorDeleteConnexion_P, 'DeleteConnexion');
    RegisterMethod(@TcyBaseCommRoomConnectorDeleteConnexion1_P, 'DeleteConnexion1');
    RegisterMethod(@TcyBaseCommRoomConnectorUpdateConnexion_P, 'UpdateConnexion');
    RegisterMethod(@TcyBaseCommRoomConnectorUpdateConnexion1_P, 'UpdateConnexion1');
    RegisterMethod(@TcyBaseCommRoomConnectorGetConnexion_P, 'GetConnexion');
    RegisterMethod(@TcyBaseCommRoomConnectorGetConnexion1_P, 'GetConnexion1');
    RegisterMethod(@TcyBaseCommRoomConnectorGetConnexion2_P, 'GetConnexion2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyBaseCommRoomConnector(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyBaseCommRoomConnector(CL);
end;

 
 
{ TPSImport_cyBaseCommRoomConnector }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseCommRoomConnector.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyBaseCommRoomConnector(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseCommRoomConnector.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyBaseCommRoomConnector(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
