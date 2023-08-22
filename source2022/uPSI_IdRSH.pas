unit uPSI_IdRSH;
{

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
  TPSImport_IdRSH = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdRSH(CL: TPSPascalCompiler);
procedure SIRegister_IdRSH(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdRSH(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdRSH(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdRemoteCMDClient
  ,IdTCPClient
  ,SyncObjs
  ,IdRSH
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRSH]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRSH(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdRemoteCMDClient', 'TIdRSH') do
  with CL.AddClassN(CL.FindClass('TIdRemoteCMDClient'),'TIdRSH') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute( ACommand : String) : String');
    RegisterProperty('ClientUserName', 'String', iptrw);
    RegisterProperty('HostUserName', 'String', iptrw);
    RegisterProperty('UseReservedPorts', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRSH(CL: TPSPascalCompiler);
begin
  SIRegister_TIdRSH(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdRSHUseReservedPorts_W(Self: TIdRSH; const T: Boolean);
begin Self.UseReservedPorts := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHUseReservedPorts_R(Self: TIdRSH; var T: Boolean);
begin T := Self.UseReservedPorts; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHHostUserName_W(Self: TIdRSH; const T: String);
begin Self.HostUserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHHostUserName_R(Self: TIdRSH; var T: String);
begin T := Self.HostUserName; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHClientUserName_W(Self: TIdRSH; const T: String);
begin Self.ClientUserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRSHClientUserName_R(Self: TIdRSH; var T: String);
begin T := Self.ClientUserName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRSH(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRSH) do
  begin
    RegisterConstructor(@TIdRSH.Create, 'Create');
    RegisterMethod(@TIdRSH.Execute, 'Execute');
    RegisterPropertyHelper(@TIdRSHClientUserName_R,@TIdRSHClientUserName_W,'ClientUserName');
    RegisterPropertyHelper(@TIdRSHHostUserName_R,@TIdRSHHostUserName_W,'HostUserName');
    RegisterPropertyHelper(@TIdRSHUseReservedPorts_R,@TIdRSHUseReservedPorts_W,'UseReservedPorts');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRSH(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdRSH(CL);
end;

 
 
{ TPSImport_IdRSH }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRSH.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRSH(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRSH.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdRSH(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
