unit uPSI_JvFindFiles;
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
  TPSImport_JvFindFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvFindFilesDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvFindFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvFindFiles_Routines(S: TPSExec);
procedure RIRegister_TJvFindFilesDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvFindFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ShlObj
  ,ShellAPI
  ,ActiveX
  ,Dialogs
  ,JvBaseDlg
  ,JvFindFiles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFindFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFindFilesDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvFindFilesDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvFindFilesDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Directory', 'string', iptrw);
    RegisterProperty('SpecialFolder', 'TJvSpecialFolder', iptrw);
    RegisterProperty('UseSpecialFolder', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFindFiles(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvSpecialFolder', '( sfRecycleBin, sfControlPanel, sfDesktop, s'
   +'fDesktopDirectory, sfMyComputer, sfFonts, sfNetHood, sfNetwork, sfPersonal'
   +', sfPrinters, sfPrograms, sfRecent, sfSendTo, sfStartMenu, stStartUp, sfTemplates )');
  SIRegister_TJvFindFilesDialog(CL);
 CL.AddDelphiFunction('Function FindFilesDlg( StartIn : string; SpecialFolder : TJvSpecialFolder; UseFolder : Boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvFindFilesDialogUseSpecialFolder_W(Self: TJvFindFilesDialog; const T: Boolean);
begin Self.UseSpecialFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFindFilesDialogUseSpecialFolder_R(Self: TJvFindFilesDialog; var T: Boolean);
begin T := Self.UseSpecialFolder; end;

(*----------------------------------------------------------------------------*)
procedure TJvFindFilesDialogSpecialFolder_W(Self: TJvFindFilesDialog; const T: TJvSpecialFolder);
begin Self.SpecialFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFindFilesDialogSpecialFolder_R(Self: TJvFindFilesDialog; var T: TJvSpecialFolder);
begin T := Self.SpecialFolder; end;

(*----------------------------------------------------------------------------*)
procedure TJvFindFilesDialogDirectory_W(Self: TJvFindFilesDialog; const T: string);
begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFindFilesDialogDirectory_R(Self: TJvFindFilesDialog; var T: string);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFindFiles_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FindFilesDlg, 'FindFilesDlg', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFindFilesDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFindFilesDialog) do begin
    RegisterConstructor(@TJvFindFilesDialog.Create, 'Create');
    RegisterMethod(@TJvFindFilesDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvFindFilesDialogDirectory_R,@TJvFindFilesDialogDirectory_W,'Directory');
    RegisterPropertyHelper(@TJvFindFilesDialogSpecialFolder_R,@TJvFindFilesDialogSpecialFolder_W,'SpecialFolder');
    RegisterPropertyHelper(@TJvFindFilesDialogUseSpecialFolder_R,@TJvFindFilesDialogUseSpecialFolder_W,'UseSpecialFolder');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFindFiles(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvFindFilesDialog(CL);
end;

 
 
{ TPSImport_JvFindFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFindFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFindFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFindFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvFindFiles(ri);
  RIRegister_JvFindFiles_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
