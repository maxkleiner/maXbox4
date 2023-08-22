unit uPSI_IdComponent;
{
   for tcpconnencttion onwork events
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
  TPSImport_IdComponent = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdComponent(CL: TPSPascalCompiler);
procedure SIRegister_IdComponent(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdComponent(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdComponent(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAntiFreezeBase
  ,IdBaseComponent
  ,IdGlobal
  ,IdStack
  ,IdResourceStrings
  ,IdComponent
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdComponent]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdComponent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdComponent') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdComponent') do begin
    RegisterMethod('Procedure BeginWork( AWorkMode : TWorkMode; const ASize : Integer)');
    RegisterMethod('Constructor Create( axOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure DoWork( AWorkMode : TWorkMode; const ACount : Integer)');
    RegisterMethod('Procedure EndWork( AWorkMode : TWorkMode)');
    RegisterProperty('LocalName', 'string', iptr);
    RegisterProperty('OnStatus', 'TIdStatusEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdComponent(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdStatus', '( hsResolving, hsConnecting, hsConnected, hsDisconn'
   +'ecting, hsDisconnected, hsStatusText, ftpTransfer, ftpReady, ftpAborted )');
  CL.AddTypeS('TIdStatusEvent', 'Procedure ( ASender : TObject; const AStatus :'
   +' TIdStatus; const AStatusText : string)');
  CL.AddTypeS('TWorkMode', '( wmRead, wmWrite )');
  CL.AddTypeS('TWorkInfo', 'record Current : Integer; Max : Integer; Level : Integer; end');
  CL.AddTypeS('TWorkBeginEvent', 'Procedure ( Sender : TObject; AWorkMode : TWorkMode; const AWorkCountMax : Integer)');
  CL.AddTypeS('TWorkEndEvent', 'Procedure ( Sender : TObject; AWorkMode : TWorkMode)');
  CL.AddTypeS('TWorkEvent', 'Procedure ( Sender : TObject; AWorkMode : TWorkMode; const AWorkCount : Integer)');
  SIRegister_TIdComponent(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdComponentOnStatus_W(Self: TIdComponent; const T: TIdStatusEvent);
begin Self.OnStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdComponentOnStatus_R(Self: TIdComponent; var T: TIdStatusEvent);
begin T := Self.OnStatus; end;

(*----------------------------------------------------------------------------*)
procedure TIdComponentLocalName_R(Self: TIdComponent; var T: string);
begin T := Self.LocalName; end;

(*----------------------------------------------------------------------------*)
Procedure TIdComponentDoStatus1_P(Self: TIdComponent;  AStatus : TIdStatus; const aaArgs : array of const);
Begin //Self.DoStatus(AStatus, aaArgs);
END;

(*----------------------------------------------------------------------------*)
Procedure TIdComponentDoStatus_P(Self: TIdComponent;  AStatus : TIdStatus);
Begin //Self.DoStatus(AStatus);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdComponent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdComponent) do begin
    RegisterVirtualMethod(@TIdComponent.BeginWork, 'BeginWork');
    RegisterConstructor(@TIdComponent.Create, 'Create');
        RegisterMethod(@TIdComponent.Destroy, 'Free');
      RegisterVirtualMethod(@TIdComponent.DoWork, 'DoWork');
    RegisterVirtualMethod(@TIdComponent.EndWork, 'EndWork');
    RegisterPropertyHelper(@TIdComponentLocalName_R,nil,'LocalName');
    RegisterPropertyHelper(@TIdComponentOnStatus_R,@TIdComponentOnStatus_W,'OnStatus');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdComponent(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdComponent(CL);
end;

 
 
{ TPSImport_IdComponent }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdComponent.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdComponent(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdComponent.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdComponent(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
