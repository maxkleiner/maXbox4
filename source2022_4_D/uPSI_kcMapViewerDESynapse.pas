unit uPSI_kcMapViewerDESynapse;
{
   downloader  httpsend
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
  TPSImport_kcMapViewerDESynapse = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMVDESynapse(CL: TPSPascalCompiler);
procedure SIRegister_kcMapViewerDESynapse(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMVDESynapse(CL: TPSRuntimeClassImporter);
procedure RIRegister_kcMapViewerDESynapse(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   kcMapViewer
  ,httpsend
  ,kcMapViewerDESynapse
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_kcMapViewerDESynapse]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMVDESynapse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDownloadEngine', 'TMVDESynapse') do
  with CL.AddClassN(CL.FindClass('TCustomDownloadEngine'),'TMVDESynapse') do begin
    RegisterMethod('Procedure DoDownloadFile( const Url : string; str : TStream)');
    RegisterProperty('UseProxy', 'Boolean', iptrw);
    RegisterProperty('ProxyHost', 'string', iptrw);
    RegisterProperty('ProxyPort', 'Integer', iptrw);
    RegisterProperty('ProxyUsername', 'string', iptrw);
    RegisterProperty('ProxyPassword', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_kcMapViewerDESynapse(CL: TPSPascalCompiler);
begin
  SIRegister_TMVDESynapse(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyPassword_W(Self: TMVDESynapse; const T: string);
begin Self.ProxyPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyPassword_R(Self: TMVDESynapse; var T: string);
begin T := Self.ProxyPassword; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyUsername_W(Self: TMVDESynapse; const T: string);
begin Self.ProxyUsername := T; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyUsername_R(Self: TMVDESynapse; var T: string);
begin T := Self.ProxyUsername; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyPort_W(Self: TMVDESynapse; const T: Integer);
begin Self.ProxyPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyPort_R(Self: TMVDESynapse; var T: Integer);
begin T := Self.ProxyPort; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyHost_W(Self: TMVDESynapse; const T: string);
begin Self.ProxyHost := T; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseProxyHost_R(Self: TMVDESynapse; var T: string);
begin T := Self.ProxyHost; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseUseProxy_W(Self: TMVDESynapse; const T: Boolean);
begin Self.UseProxy := T; end;

(*----------------------------------------------------------------------------*)
procedure TMVDESynapseUseProxy_R(Self: TMVDESynapse; var T: Boolean);
begin T := Self.UseProxy; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMVDESynapse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMVDESynapse) do begin
    RegisterMethod(@TMVDESynapse.DoDownloadFile, 'DoDownloadFile');
    RegisterPropertyHelper(@TMVDESynapseUseProxy_R,@TMVDESynapseUseProxy_W,'UseProxy');
    RegisterPropertyHelper(@TMVDESynapseProxyHost_R,@TMVDESynapseProxyHost_W,'ProxyHost');
    RegisterPropertyHelper(@TMVDESynapseProxyPort_R,@TMVDESynapseProxyPort_W,'ProxyPort');
    RegisterPropertyHelper(@TMVDESynapseProxyUsername_R,@TMVDESynapseProxyUsername_W,'ProxyUsername');
    RegisterPropertyHelper(@TMVDESynapseProxyPassword_R,@TMVDESynapseProxyPassword_W,'ProxyPassword');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_kcMapViewerDESynapse(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMVDESynapse(CL);
end;

 
 
{ TPSImport_kcMapViewerDESynapse }
(*----------------------------------------------------------------------------*)
procedure TPSImport_kcMapViewerDESynapse.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_kcMapViewerDESynapse(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_kcMapViewerDESynapse.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_kcMapViewerDESynapse(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
