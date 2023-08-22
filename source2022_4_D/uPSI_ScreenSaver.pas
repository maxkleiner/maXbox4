unit uPSI_ScreenSaver;
{
   screen dream
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
  TPSImport_ScreenSaver = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TScreenSaver(CL: TPSPascalCompiler);
procedure SIRegister_ScreenSaver(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ScreenSaver_Routines(S: TPSExec);
procedure RIRegister_TScreenSaver(CL: TPSRuntimeClassImporter);
procedure RIRegister_ScreenSaver(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Forms
  ,Extctrls
  ,ScreenSaver
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ScreenSaver]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TScreenSaver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TScreenSaver') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TScreenSaver') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
          RegisterMethod('Procedure Free');
    RegisterMethod('Procedure SetPassword');
    RegisterMethod('Function CloseSaver : Boolean');
    RegisterProperty('InPreviewMode', 'Boolean', iptr);
    RegisterProperty('Options', 'TScreenSaverOptions', iptrw);
    RegisterProperty('HonourWindowsPassword', 'Boolean', iptrw);
    RegisterProperty('AboutString', 'String', iptrw);
    RegisterProperty('OnPropertiesRequested', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExecute', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPreview', 'TScreenSaverPreviewEvent', iptrw);
    RegisterProperty('OnCloseQuery', 'TCloseQueryEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ScreenSaver(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TScreenSaverOption', '( ssoAutoAdjustFormProperties, ssoAutoHook'
   +'KeyboardEvents, ssoAutoHookMouseEvents, ssoEnhancedMouseMoveDetection )');
  CL.AddTypeS('TScreenSaverOptions', 'set of TScreenSaverOption');
 CL.AddConstantN('cDefaultScreenSaverOptions','LongInt').Value.ts32:= ord(ssoAutoAdjustFormProperties) or ord(ssoAutoHookKeyboardEvents) or ord(ssoEnhancedMouseMoveDetection);
  CL.AddTypeS('TScreenSaverPreviewEvent', 'Procedure ( Sender : TObject; previewHwnd: HWND)');
  SIRegister_TScreenSaver(CL);
 //CL.AddDelphiFunction('Procedure Register');
 CL.AddDelphiFunction('Procedure SetScreenSaverPassword');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnCloseQuery_W(Self: TScreenSaver; const T: TCloseQueryEvent);
begin Self.OnCloseQuery := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnCloseQuery_R(Self: TScreenSaver; var T: TCloseQueryEvent);
begin T := Self.OnCloseQuery; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnPreview_W(Self: TScreenSaver; const T: TScreenSaverPreviewEvent);
begin Self.OnPreview := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnPreview_R(Self: TScreenSaver; var T: TScreenSaverPreviewEvent);
begin T := Self.OnPreview; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnExecute_W(Self: TScreenSaver; const T: TNotifyEvent);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnExecute_R(Self: TScreenSaver; var T: TNotifyEvent);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnPropertiesRequested_W(Self: TScreenSaver; const T: TNotifyEvent);
begin Self.OnPropertiesRequested := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOnPropertiesRequested_R(Self: TScreenSaver; var T: TNotifyEvent);
begin T := Self.OnPropertiesRequested; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverAboutString_W(Self: TScreenSaver; const T: String);
begin Self.AboutString := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverAboutString_R(Self: TScreenSaver; var T: String);
begin T := Self.AboutString; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverHonourWindowsPassword_W(Self: TScreenSaver; const T: Boolean);
begin Self.HonourWindowsPassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverHonourWindowsPassword_R(Self: TScreenSaver; var T: Boolean);
begin T := Self.HonourWindowsPassword; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOptions_W(Self: TScreenSaver; const T: TScreenSaverOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverOptions_R(Self: TScreenSaver; var T: TScreenSaverOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaverInPreviewMode_R(Self: TScreenSaver; var T: Boolean);
begin T := Self.InPreviewMode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ScreenSaver_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
 S.RegisterDelphiFunction(@SetScreenSaverPassword, 'SetScreenSaverPassword', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TScreenSaver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TScreenSaver) do begin
    RegisterConstructor(@TScreenSaver.Create, 'Create');
    RegisterMethod(@TScreenSaver.SetPassword, 'SetPassword');
    RegisterMethod(@TScreenSaver.CloseSaver, 'CloseSaver');
      RegisterMethod(@TScreenSaver.Destroy, 'Free');
    RegisterPropertyHelper(@TScreenSaverInPreviewMode_R,nil,'InPreviewMode');
    RegisterPropertyHelper(@TScreenSaverOptions_R,@TScreenSaverOptions_W,'Options');
    RegisterPropertyHelper(@TScreenSaverHonourWindowsPassword_R,@TScreenSaverHonourWindowsPassword_W,'HonourWindowsPassword');
    RegisterPropertyHelper(@TScreenSaverAboutString_R,@TScreenSaverAboutString_W,'AboutString');
    RegisterPropertyHelper(@TScreenSaverOnPropertiesRequested_R,@TScreenSaverOnPropertiesRequested_W,'OnPropertiesRequested');
    RegisterPropertyHelper(@TScreenSaverOnExecute_R,@TScreenSaverOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TScreenSaverOnPreview_R,@TScreenSaverOnPreview_W,'OnPreview');
    RegisterPropertyHelper(@TScreenSaverOnCloseQuery_R,@TScreenSaverOnCloseQuery_W,'OnCloseQuery');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ScreenSaver(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TScreenSaver(CL);
end;

 
 
{ TPSImport_ScreenSaver }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScreenSaver.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ScreenSaver(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScreenSaver.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ScreenSaver(ri);
  RIRegister_ScreenSaver_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
