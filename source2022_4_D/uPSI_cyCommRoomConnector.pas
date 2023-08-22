unit uPSI_cyCommRoomConnector;
{
   needs base com
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
  TPSImport_cyCommRoomConnector = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyCommRoomConnector(CL: TPSPascalCompiler);
procedure SIRegister_cyCommRoomConnector(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyCommRoomConnector(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyCommRoomConnector(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,cyBaseComm
  ,cyBaseCommRoomConnector
  ,cyCommRoomConnector
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyCommRoomConnector]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyCommRoomConnector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TcyBaseCommRoomConnector', 'TcyCommRoomConnector') do
  with CL.AddClassN(CL.FindClass('TcyBaseCommRoomConnector'),'TcyCommRoomConnector') do begin
      RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetInfo( var ConnectorInfo : TcyConnexionInfo) : Boolean');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('CommComponent', 'TcyBaseComm', iptrw);
    RegisterProperty('ConnexionTag', 'Integer', iptrw);
    RegisterProperty('NickName', 'TNickName', iptrw);
    RegisterProperty('RoomID', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyCommRoomConnector(CL: TPSPascalCompiler);
begin
  SIRegister_TcyCommRoomConnector(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorRoomID_W(Self: TcyCommRoomConnector; const T: String);
begin Self.RoomID := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorRoomID_R(Self: TcyCommRoomConnector; var T: String);
begin T := Self.RoomID; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorNickName_W(Self: TcyCommRoomConnector; const T: TNickName);
begin Self.NickName := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorNickName_R(Self: TcyCommRoomConnector; var T: TNickName);
begin T := Self.NickName; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorConnexionTag_W(Self: TcyCommRoomConnector; const T: Integer);
begin Self.ConnexionTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorConnexionTag_R(Self: TcyCommRoomConnector; var T: Integer);
begin T := Self.ConnexionTag; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorCommComponent_W(Self: TcyCommRoomConnector; const T: TcyBaseComm);
begin Self.CommComponent := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorCommComponent_R(Self: TcyCommRoomConnector; var T: TcyBaseComm);
begin T := Self.CommComponent; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorActive_W(Self: TcyCommRoomConnector; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyCommRoomConnectorActive_R(Self: TcyCommRoomConnector; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyCommRoomConnector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyCommRoomConnector) do begin
    RegisterConstructor(@TcyCommRoomConnector.Create, 'Create');
    RegisterMethod(@TcyCommRoomConnector.Destroy, 'Free');
    RegisterMethod(@TcyCommRoomConnector.GetInfo, 'GetInfo');
    RegisterPropertyHelper(@TcyCommRoomConnectorActive_R,@TcyCommRoomConnectorActive_W,'Active');
    RegisterPropertyHelper(@TcyCommRoomConnectorCommComponent_R,@TcyCommRoomConnectorCommComponent_W,'CommComponent');
    RegisterPropertyHelper(@TcyCommRoomConnectorConnexionTag_R,@TcyCommRoomConnectorConnexionTag_W,'ConnexionTag');
    RegisterPropertyHelper(@TcyCommRoomConnectorNickName_R,@TcyCommRoomConnectorNickName_W,'NickName');
    RegisterPropertyHelper(@TcyCommRoomConnectorRoomID_R,@TcyCommRoomConnectorRoomID_W,'RoomID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyCommRoomConnector(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyCommRoomConnector(CL);
end;

 
 
{ TPSImport_cyCommRoomConnector }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyCommRoomConnector.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyCommRoomConnector(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyCommRoomConnector.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyCommRoomConnector(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
