unit uPSI_JvDialogs;
{
   dia log log
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
  TPSImport_JvDialogs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvColorDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvSaveDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvOpenDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvDialogs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvColorDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvSaveDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvOpenDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDialogs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,JVCLVer
  ,JvDialogs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDialogs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvColorDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TColorDialog', 'TJvColorDialog') do
  with CL.AddClassN(CL.FindClass('TColorDialog'),'TJvColorDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SelectColor( Color : TColor)');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('OnQueryColor', 'TJvCDQueryEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSaveDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvOpenDialog', 'TJvSaveDialog') do
  with CL.AddClassN(CL.FindClass('TJvOpenDialog'),'TJvSaveDialog') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvOpenDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenDialog', 'TJvOpenDialog') do
  with CL.AddClassN(CL.FindClass('TOpenDialog'),'TJvOpenDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ParentWnd', 'THandle', iptr);
    RegisterMethod('Procedure SelectFolder( const FolderName : string)');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('ActiveControl', 'TJvOpenDialogAC', iptrw);
    RegisterProperty('ActiveStyle', 'TJvOpenDialogAS', iptrw);
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('DefBtnCaption', 'string', iptrw);
    RegisterProperty('FilterLabelCaption', 'string', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('UseUserSize', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('OnError', 'TDialogErrorEvent', iptrw);
    RegisterProperty('OnShareViolation', 'TCloseQueryEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDialogs(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvOpenDialogAC', '( acEdit, acListView )');
  CL.AddTypeS('TJvOpenDialogAS', '( asSmallIcon, asReport )');
  CL.AddTypeS('TDialogErrorEvent', 'Procedure ( Sender : TObject; ErrorCode : Cardinal)');
  SIRegister_TJvOpenDialog(CL);
  SIRegister_TJvSaveDialog(CL);
  CL.AddTypeS('TJvCDQueryEvent', 'Procedure (Sender : TObject; SelectedColor: TColor; var Accept : Boolean)');
  SIRegister_TJvColorDialog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvColorDialogOnQueryColor_W(Self: TJvColorDialog; const T: TJvCDQueryEvent);
begin Self.OnQueryColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvColorDialogOnQueryColor_R(Self: TJvColorDialog; var T: TJvCDQueryEvent);
begin T := Self.OnQueryColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvColorDialogAboutJVCL_W(Self: TJvColorDialog; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvColorDialogAboutJVCL_R(Self: TJvColorDialog; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogOnShareViolation_W(Self: TJvOpenDialog; const T: TCloseQueryEvent);
begin Self.OnShareViolation := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogOnShareViolation_R(Self: TJvOpenDialog; var T: TCloseQueryEvent);
begin T := Self.OnShareViolation; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogOnError_W(Self: TJvOpenDialog; const T: TDialogErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogOnError_R(Self: TJvOpenDialog; var T: TDialogErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogWidth_W(Self: TJvOpenDialog; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogWidth_R(Self: TJvOpenDialog; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogUseUserSize_W(Self: TJvOpenDialog; const T: Boolean);
begin Self.UseUserSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogUseUserSize_R(Self: TJvOpenDialog; var T: Boolean);
begin T := Self.UseUserSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogHeight_W(Self: TJvOpenDialog; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogHeight_R(Self: TJvOpenDialog; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogFilterLabelCaption_W(Self: TJvOpenDialog; const T: string);
begin Self.FilterLabelCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogFilterLabelCaption_R(Self: TJvOpenDialog; var T: string);
begin T := Self.FilterLabelCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogDefBtnCaption_W(Self: TJvOpenDialog; const T: string);
begin Self.DefBtnCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogDefBtnCaption_R(Self: TJvOpenDialog; var T: string);
begin T := Self.DefBtnCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogAutoSize_W(Self: TJvOpenDialog; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogAutoSize_R(Self: TJvOpenDialog; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogActiveStyle_W(Self: TJvOpenDialog; const T: TJvOpenDialogAS);
begin Self.ActiveStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogActiveStyle_R(Self: TJvOpenDialog; var T: TJvOpenDialogAS);
begin T := Self.ActiveStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogActiveControl_W(Self: TJvOpenDialog; const T: TJvOpenDialogAC);
begin Self.ActiveControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogActiveControl_R(Self: TJvOpenDialog; var T: TJvOpenDialogAC);
begin T := Self.ActiveControl; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogAboutJVCL_W(Self: TJvOpenDialog; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogAboutJVCL_R(Self: TJvOpenDialog; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenDialogParentWnd_R(Self: TJvOpenDialog; var T: THandle);
begin T := Self.ParentWnd; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvColorDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvColorDialog) do
  begin
    RegisterConstructor(@TJvColorDialog.Create, 'Create');
    RegisterMethod(@TJvColorDialog.SelectColor, 'SelectColor');
    RegisterPropertyHelper(@TJvColorDialogAboutJVCL_R,@TJvColorDialogAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvColorDialogOnQueryColor_R,@TJvColorDialogOnQueryColor_W,'OnQueryColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSaveDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSaveDialog) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvOpenDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvOpenDialog) do
  begin
    RegisterConstructor(@TJvOpenDialog.Create, 'Create');
    RegisterPropertyHelper(@TJvOpenDialogParentWnd_R,nil,'ParentWnd');
    RegisterMethod(@TJvOpenDialog.SelectFolder, 'SelectFolder');
    RegisterPropertyHelper(@TJvOpenDialogAboutJVCL_R,@TJvOpenDialogAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvOpenDialogActiveControl_R,@TJvOpenDialogActiveControl_W,'ActiveControl');
    RegisterPropertyHelper(@TJvOpenDialogActiveStyle_R,@TJvOpenDialogActiveStyle_W,'ActiveStyle');
    RegisterPropertyHelper(@TJvOpenDialogAutoSize_R,@TJvOpenDialogAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TJvOpenDialogDefBtnCaption_R,@TJvOpenDialogDefBtnCaption_W,'DefBtnCaption');
    RegisterPropertyHelper(@TJvOpenDialogFilterLabelCaption_R,@TJvOpenDialogFilterLabelCaption_W,'FilterLabelCaption');
    RegisterPropertyHelper(@TJvOpenDialogHeight_R,@TJvOpenDialogHeight_W,'Height');
    RegisterPropertyHelper(@TJvOpenDialogUseUserSize_R,@TJvOpenDialogUseUserSize_W,'UseUserSize');
    RegisterPropertyHelper(@TJvOpenDialogWidth_R,@TJvOpenDialogWidth_W,'Width');
    RegisterPropertyHelper(@TJvOpenDialogOnError_R,@TJvOpenDialogOnError_W,'OnError');
    RegisterPropertyHelper(@TJvOpenDialogOnShareViolation_R,@TJvOpenDialogOnShareViolation_W,'OnShareViolation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDialogs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvOpenDialog(CL);
  RIRegister_TJvSaveDialog(CL);
  RIRegister_TJvColorDialog(CL);
end;

 
 
{ TPSImport_JvDialogs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDialogs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDialogs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDialogs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDialogs(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
