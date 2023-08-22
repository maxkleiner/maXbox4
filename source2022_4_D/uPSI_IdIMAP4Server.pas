unit uPSI_IdIMAP4Server;
{
   just server
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
  TPSImport_IdIMAP4Server = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIMAP4Server(CL: TPSPascalCompiler);
procedure SIRegister_IdIMAP4Server(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIMAP4Server(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIMAP4Server(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdIMAP4Server
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIMAP4Server]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIMAP4Server(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdIMAP4Server') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdIMAP4Server') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free)');
      RegisterProperty('ONCommandCAPABILITY', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandNOOP', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandLOGOUT', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandAUTHENTICATE', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandLOGIN', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandSELECT', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandEXAMINE', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandCREATE', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandDELETE', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandRENAME', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandSUBSCRIBE', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandUNSUBSCRIBE', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandLIST', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandLSUB', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandSTATUS', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandAPPEND', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandCHECK', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandCLOSE', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandEXPUNGE', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandSEARCH', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandFETCH', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandSTORE', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandCOPY', 'TCommandEvent', iptrw);
    RegisterProperty('ONCommandUID', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandX', 'TCommandEvent', iptrw);
    RegisterProperty('OnCommandError', 'TCommandEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIMAP4Server(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCommandEvent', 'Procedure ( Thread : TIdPeerThread; const Tag, '
   +'CmdStr : String; var Handled : Boolean)');
  SIRegister_TIdIMAP4Server(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandError_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandError_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandError; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandX_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandX := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandX_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandX; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandUID_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandUID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandUID_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandUID; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandCOPY_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandCOPY := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandCOPY_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandCOPY; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandSTORE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandSTORE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandSTORE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandSTORE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandFETCH_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandFETCH := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandFETCH_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandFETCH; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandSEARCH_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandSEARCH := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandSEARCH_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandSEARCH; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandEXPUNGE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandEXPUNGE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandEXPUNGE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandEXPUNGE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandCLOSE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandCLOSE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandCLOSE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandCLOSE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandCHECK_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandCHECK := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandCHECK_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandCHECK; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandAPPEND_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandAPPEND := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandAPPEND_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandAPPEND; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandSTATUS_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandSTATUS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandSTATUS_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandSTATUS; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandLSUB_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandLSUB := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandLSUB_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandLSUB; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandLIST_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandLIST := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandLIST_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandLIST; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandUNSUBSCRIBE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandUNSUBSCRIBE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandUNSUBSCRIBE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandUNSUBSCRIBE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandSUBSCRIBE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandSUBSCRIBE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandSUBSCRIBE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandSUBSCRIBE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandRENAME_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandRENAME := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandRENAME_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandRENAME; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandDELETE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandDELETE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandDELETE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandDELETE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandCREATE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandCREATE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandCREATE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandCREATE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandEXAMINE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.OnCommandEXAMINE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerOnCommandEXAMINE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.OnCommandEXAMINE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandSELECT_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandSELECT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandSELECT_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandSELECT; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandLOGIN_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandLOGIN := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandLOGIN_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandLOGIN; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandAUTHENTICATE_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandAUTHENTICATE := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandAUTHENTICATE_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandAUTHENTICATE; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandLOGOUT_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandLOGOUT := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandLOGOUT_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandLOGOUT; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandNOOP_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandNOOP := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandNOOP_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandNOOP; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandCAPABILITY_W(Self: TIdIMAP4Server; const T: TCommandEvent);
begin Self.ONCommandCAPABILITY := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIMAP4ServerONCommandCAPABILITY_R(Self: TIdIMAP4Server; var T: TCommandEvent);
begin T := Self.ONCommandCAPABILITY; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIMAP4Server(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIMAP4Server) do begin
    RegisterConstructor(@TIdIMAP4Server.Create, 'Create');
        RegisterMethod(@TIdIMAP4Server.Destroy, 'Free');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandCAPABILITY_R,@TIdIMAP4ServerONCommandCAPABILITY_W,'ONCommandCAPABILITY');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandNOOP_R,@TIdIMAP4ServerONCommandNOOP_W,'ONCommandNOOP');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandLOGOUT_R,@TIdIMAP4ServerONCommandLOGOUT_W,'ONCommandLOGOUT');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandAUTHENTICATE_R,@TIdIMAP4ServerONCommandAUTHENTICATE_W,'ONCommandAUTHENTICATE');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandLOGIN_R,@TIdIMAP4ServerONCommandLOGIN_W,'ONCommandLOGIN');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandSELECT_R,@TIdIMAP4ServerONCommandSELECT_W,'ONCommandSELECT');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandEXAMINE_R,@TIdIMAP4ServerOnCommandEXAMINE_W,'OnCommandEXAMINE');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandCREATE_R,@TIdIMAP4ServerONCommandCREATE_W,'ONCommandCREATE');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandDELETE_R,@TIdIMAP4ServerONCommandDELETE_W,'ONCommandDELETE');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandRENAME_R,@TIdIMAP4ServerOnCommandRENAME_W,'OnCommandRENAME');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandSUBSCRIBE_R,@TIdIMAP4ServerONCommandSUBSCRIBE_W,'ONCommandSUBSCRIBE');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandUNSUBSCRIBE_R,@TIdIMAP4ServerONCommandUNSUBSCRIBE_W,'ONCommandUNSUBSCRIBE');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandLIST_R,@TIdIMAP4ServerONCommandLIST_W,'ONCommandLIST');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandLSUB_R,@TIdIMAP4ServerOnCommandLSUB_W,'OnCommandLSUB');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandSTATUS_R,@TIdIMAP4ServerONCommandSTATUS_W,'ONCommandSTATUS');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandAPPEND_R,@TIdIMAP4ServerOnCommandAPPEND_W,'OnCommandAPPEND');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandCHECK_R,@TIdIMAP4ServerONCommandCHECK_W,'ONCommandCHECK');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandCLOSE_R,@TIdIMAP4ServerOnCommandCLOSE_W,'OnCommandCLOSE');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandEXPUNGE_R,@TIdIMAP4ServerONCommandEXPUNGE_W,'ONCommandEXPUNGE');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandSEARCH_R,@TIdIMAP4ServerOnCommandSEARCH_W,'OnCommandSEARCH');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandFETCH_R,@TIdIMAP4ServerONCommandFETCH_W,'ONCommandFETCH');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandSTORE_R,@TIdIMAP4ServerOnCommandSTORE_W,'OnCommandSTORE');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandCOPY_R,@TIdIMAP4ServerOnCommandCOPY_W,'OnCommandCOPY');
    RegisterEventPropertyHelper(@TIdIMAP4ServerONCommandUID_R,@TIdIMAP4ServerONCommandUID_W,'ONCommandUID');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandX_R,@TIdIMAP4ServerOnCommandX_W,'OnCommandX');
    RegisterPropertyHelper(@TIdIMAP4ServerOnCommandError_R,@TIdIMAP4ServerOnCommandError_W,'OnCommandError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIMAP4Server(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIMAP4Server(CL);
end;

 
 
{ TPSImport_IdIMAP4Server }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIMAP4Server.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIMAP4Server(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIMAP4Server.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIMAP4Server(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
