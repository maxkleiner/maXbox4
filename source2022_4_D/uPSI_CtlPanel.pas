unit uPSI_CtlPanel;
{
   applet
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
  TPSImport_CtlPanel = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAppletApplication(CL: TPSPascalCompiler);
procedure SIRegister_TAppletModule(CL: TPSPascalCompiler);
procedure SIRegister_CtlPanel(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CtlPanel_Routines(S: TPSExec);
procedure RIRegister_TAppletApplication(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAppletModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_CtlPanel(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Cpl
  ,CtlPanel
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CtlPanel]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAppletApplication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAppletApplication') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAppletApplication') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure CreateForm( InstanceClass : TComponentClass; var Reference)');
    RegisterMethod('Procedure HandleException( Sender : TObject)');
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Procedure Run');
    RegisterProperty('Modules', 'TAppletModule Integer', iptrw);
    RegisterProperty('ModuleCount', 'Integer', iptrw);
    RegisterProperty('ControlPanelHandle', 'THandle', iptr);
    RegisterProperty('OnInit', 'TInitEvent', iptrw);
    RegisterProperty('OnCount', 'TCountEvent', iptrw);
    RegisterProperty('OnException', 'TOnAppletExceptionEvent', iptrw);
    RegisterProperty('OnExit', 'TExitEvent', iptrw);
    RegisterProperty('OnSetup', 'TSetupEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAppletModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataModule', 'TAppletModule') do
  with CL.AddClassN(CL.FindClass('TDataModule'),'TAppletModule') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Data', 'LongInt', iptrw);
    RegisterProperty('OnStop', 'TStopEvent', iptrw);
    RegisterProperty('OnActivate', 'TActivateEvent', iptrw);
    RegisterProperty('OnInquire', 'TInquireEvent', iptrw);
    RegisterProperty('OnNewInquire', 'TNewInquireEvent', iptrw);
    RegisterProperty('OnStartWParms', 'TStartWParmsEvent', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('AppletIcon', 'TIcon', iptrw);
    RegisterProperty('Help', 'string', iptrw);
    RegisterProperty('ResidIcon', 'Integer', iptrw);
    RegisterProperty('ResidName', 'Integer', iptrw);
    RegisterProperty('ResidInfo', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CtlPanel(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAppletException');
  CL.AddTypeS('TInitEvent', 'Procedure ( Sender : TObject; var AppInitOK : Boolean)');
  CL.AddTypeS('TCountEvent', 'Procedure ( Sender : TObject; var AppCount : Integer)');
  CL.AddTypeS('TExitEvent', 'TNotifyEvent');
  CL.AddTypeS('TSetupEvent', 'TNotifyEvent');
  CL.AddTypeS('TActivateEvent', 'Procedure ( Sender : TObject; Data : LongInt)');
  CL.AddTypeS('TStopEvent', 'Procedure ( Sender : TObject; Data : LongInt)');
  CL.AddTypeS('TInquireEvent', 'Procedure ( Sender : TObject; var idIcon : Inte'
   +'ger; var idName : Integer; var idInfo : Integer; var lData : Integer)');
  CL.AddTypeS('TNewInquireEvent', 'Procedure ( Sender : TObject; var lData : In'
   +'teger; var hIcon : HICON; var AppletName : string; var AppletInfo : string)');
  CL.AddTypeS('TStartWParmsEvent', 'Procedure ( Sender : TObject; Params : string)');
  SIRegister_TAppletModule(CL);
  //CL.AddTypeS('TAppletModuleClass', 'class of TAppletModule');
  //CL.AddTypeS('TCPLAppletClass', 'class of TAppletModule');
  //CL.AddTypeS('TDataModuleClass', 'class of TDataModule');
  CL.AddTypeS('TOnAppletExceptionEvent', 'Procedure ( Sender : TObject; E : Exception)');
  SIRegister_TAppletApplication(CL);
 CL.AddDelphiFunction('Function CPlApplet( hwndCPl : THandle; uMsg : DWORD; lParam1, lParam2 : Longint) : Longint');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnSetup_W(Self: TAppletApplication; const T: TSetupEvent);
begin Self.OnSetup := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnSetup_R(Self: TAppletApplication; var T: TSetupEvent);
begin T := Self.OnSetup; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnExit_W(Self: TAppletApplication; const T: TExitEvent);
begin Self.OnExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnExit_R(Self: TAppletApplication; var T: TExitEvent);
begin T := Self.OnExit; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnException_W(Self: TAppletApplication; const T: TOnAppletExceptionEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnException_R(Self: TAppletApplication; var T: TOnAppletExceptionEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnCount_W(Self: TAppletApplication; const T: TCountEvent);
begin Self.OnCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnCount_R(Self: TAppletApplication; var T: TCountEvent);
begin T := Self.OnCount; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnInit_W(Self: TAppletApplication; const T: TInitEvent);
begin Self.OnInit := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationOnInit_R(Self: TAppletApplication; var T: TInitEvent);
begin T := Self.OnInit; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationControlPanelHandle_R(Self: TAppletApplication; var T: THandle);
begin T := Self.ControlPanelHandle; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationModuleCount_W(Self: TAppletApplication; const T: Integer);
begin Self.ModuleCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationModuleCount_R(Self: TAppletApplication; var T: Integer);
begin T := Self.ModuleCount; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationModules_W(Self: TAppletApplication; const T: TAppletModule; const t1: Integer);
begin Self.Modules[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletApplicationModules_R(Self: TAppletApplication; var T: TAppletModule; const t1: Integer);
begin T := Self.Modules[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleResidInfo_W(Self: TAppletModule; const T: Integer);
begin Self.ResidInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleResidInfo_R(Self: TAppletModule; var T: Integer);
begin T := Self.ResidInfo; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleResidName_W(Self: TAppletModule; const T: Integer);
begin Self.ResidName := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleResidName_R(Self: TAppletModule; var T: Integer);
begin T := Self.ResidName; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleResidIcon_W(Self: TAppletModule; const T: Integer);
begin Self.ResidIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleResidIcon_R(Self: TAppletModule; var T: Integer);
begin T := Self.ResidIcon; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleHelp_W(Self: TAppletModule; const T: string);
begin Self.Help := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleHelp_R(Self: TAppletModule; var T: string);
begin T := Self.Help; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleAppletIcon_W(Self: TAppletModule; const T: TIcon);
begin Self.AppletIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleAppletIcon_R(Self: TAppletModule; var T: TIcon);
begin T := Self.AppletIcon; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleCaption_W(Self: TAppletModule; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleCaption_R(Self: TAppletModule; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnStartWParms_W(Self: TAppletModule; const T: TStartWParmsEvent);
begin Self.OnStartWParms := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnStartWParms_R(Self: TAppletModule; var T: TStartWParmsEvent);
begin T := Self.OnStartWParms; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnNewInquire_W(Self: TAppletModule; const T: TNewInquireEvent);
begin Self.OnNewInquire := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnNewInquire_R(Self: TAppletModule; var T: TNewInquireEvent);
begin T := Self.OnNewInquire; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnInquire_W(Self: TAppletModule; const T: TInquireEvent);
begin Self.OnInquire := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnInquire_R(Self: TAppletModule; var T: TInquireEvent);
begin T := Self.OnInquire; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnActivate_W(Self: TAppletModule; const T: TActivateEvent);
begin Self.OnActivate := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnActivate_R(Self: TAppletModule; var T: TActivateEvent);
begin T := Self.OnActivate; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnStop_W(Self: TAppletModule; const T: TStopEvent);
begin Self.OnStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleOnStop_R(Self: TAppletModule; var T: TStopEvent);
begin T := Self.OnStop; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleData_W(Self: TAppletModule; const T: LongInt);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TAppletModuleData_R(Self: TAppletModule; var T: LongInt);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CtlPanel_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CPlApplet, 'CPlApplet', CdStdCall);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAppletApplication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAppletApplication) do begin
    RegisterConstructor(@TAppletApplication.Create, 'Create');
    RegisterVirtualMethod(@TAppletApplication.CreateForm, 'CreateForm');
    RegisterMethod(@TAppletApplication.HandleException, 'HandleException');
    RegisterVirtualMethod(@TAppletApplication.Initialize, 'Initialize');
    RegisterVirtualMethod(@TAppletApplication.Run, 'Run');
    RegisterPropertyHelper(@TAppletApplicationModules_R,@TAppletApplicationModules_W,'Modules');
    RegisterPropertyHelper(@TAppletApplicationModuleCount_R,@TAppletApplicationModuleCount_W,'ModuleCount');
    RegisterPropertyHelper(@TAppletApplicationControlPanelHandle_R,nil,'ControlPanelHandle');
    RegisterPropertyHelper(@TAppletApplicationOnInit_R,@TAppletApplicationOnInit_W,'OnInit');
    RegisterPropertyHelper(@TAppletApplicationOnCount_R,@TAppletApplicationOnCount_W,'OnCount');
    RegisterPropertyHelper(@TAppletApplicationOnException_R,@TAppletApplicationOnException_W,'OnException');
    RegisterPropertyHelper(@TAppletApplicationOnExit_R,@TAppletApplicationOnExit_W,'OnExit');
    RegisterPropertyHelper(@TAppletApplicationOnSetup_R,@TAppletApplicationOnSetup_W,'OnSetup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAppletModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAppletModule) do begin
    RegisterConstructor(@TAppletModule.Create, 'Create');
    RegisterPropertyHelper(@TAppletModuleData_R,@TAppletModuleData_W,'Data');
    RegisterPropertyHelper(@TAppletModuleOnStop_R,@TAppletModuleOnStop_W,'OnStop');
    RegisterPropertyHelper(@TAppletModuleOnActivate_R,@TAppletModuleOnActivate_W,'OnActivate');
    RegisterPropertyHelper(@TAppletModuleOnInquire_R,@TAppletModuleOnInquire_W,'OnInquire');
    RegisterPropertyHelper(@TAppletModuleOnNewInquire_R,@TAppletModuleOnNewInquire_W,'OnNewInquire');
    RegisterPropertyHelper(@TAppletModuleOnStartWParms_R,@TAppletModuleOnStartWParms_W,'OnStartWParms');
    RegisterPropertyHelper(@TAppletModuleCaption_R,@TAppletModuleCaption_W,'Caption');
    RegisterPropertyHelper(@TAppletModuleAppletIcon_R,@TAppletModuleAppletIcon_W,'AppletIcon');
    RegisterPropertyHelper(@TAppletModuleHelp_R,@TAppletModuleHelp_W,'Help');
    RegisterPropertyHelper(@TAppletModuleResidIcon_R,@TAppletModuleResidIcon_W,'ResidIcon');
    RegisterPropertyHelper(@TAppletModuleResidName_R,@TAppletModuleResidName_W,'ResidName');
    RegisterPropertyHelper(@TAppletModuleResidInfo_R,@TAppletModuleResidInfo_W,'ResidInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CtlPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EAppletException) do
  RIRegister_TAppletModule(CL);
  RIRegister_TAppletApplication(CL);
end;

 
 
{ TPSImport_CtlPanel }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CtlPanel.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CtlPanel(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CtlPanel.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CtlPanel(ri);
  RIRegister_CtlPanel_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
