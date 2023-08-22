unit uPSI_JvDirectories;
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
  TPSImport_JvDirectories = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDirectories(CL: TPSPascalCompiler);
procedure SIRegister_JvDirectories(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDirectories(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDirectories(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Registry
  ,JvComponent
  ,JvDirectories
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDirectories]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDirectories(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvDirectories') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvDirectories') do begin
    RegisterProperty('CurrentDirectory', 'string', iptrw);
    RegisterProperty('WindowsDirectory', 'string', iptrw);
    RegisterProperty('SystemDirectory', 'string', iptrw);
    RegisterProperty('TempPath', 'string', iptrw);
    RegisterProperty('ApplicationData', 'string', iptrw);
    RegisterProperty('Cache', 'string', iptrw);
    RegisterProperty('Cookies', 'string', iptrw);
    RegisterProperty('Desktop', 'string', iptrw);
    RegisterProperty('Favorites', 'string', iptrw);
    RegisterProperty('Fonts', 'string', iptrw);
    RegisterProperty('History', 'string', iptrw);
    RegisterProperty('NetHood', 'string', iptrw);
    RegisterProperty('Personal', 'string', iptrw);
    RegisterProperty('Programs', 'string', iptrw);
    RegisterProperty('ProgramFiles', 'string', iptrw);
    RegisterProperty('Recent', 'string', iptrw);
    RegisterProperty('SendTo', 'string', iptrw);
    RegisterProperty('StartMenu', 'string', iptrw);
    RegisterProperty('Startup', 'string', iptrw);
    RegisterProperty('Templates', 'string', iptrw);
    RegisterProperty('CommonAdminTools', 'string', iptrw);
    RegisterProperty('CommonAppData', 'string', iptrw);
    RegisterProperty('CommonDesktop', 'string', iptrw);
    RegisterProperty('CommonDocuments', 'string', iptrw);
    RegisterProperty('CommonPrograms', 'string', iptrw);
    RegisterProperty('CommonStartMenu', 'string', iptrw);
    RegisterProperty('CommonStartup', 'string', iptrw);
    RegisterProperty('CommonTemplates', 'string', iptrw);
    RegisterProperty('CommonPersonal', 'string', iptrw);
    RegisterProperty('AllUsersAppData', 'string', iptrw);
    RegisterProperty('AllUsersDesktop', 'string', iptrw);
    RegisterProperty('AllUsersDocuments', 'string', iptrw);
    RegisterProperty('AllUsersPrograms', 'string', iptrw);
    RegisterProperty('AllUsersStartMenu', 'string', iptrw);
    RegisterProperty('AllUsersStartup', 'string', iptrw);
    RegisterProperty('AllUsersTemplates', 'string', iptrw);
    RegisterProperty('AllUsersFavorites', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDirectories(CL: TPSPascalCompiler);
begin
  SIRegister_TJvDirectories(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersFavorites_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersFavorites := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersFavorites_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersFavorites; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersTemplates_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersTemplates := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersTemplates_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersTemplates; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersStartup_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersStartup := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersStartup_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersStartup; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersStartMenu_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersStartMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersStartMenu_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersStartMenu; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersPrograms_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersPrograms := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersPrograms_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersPrograms; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersDocuments_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersDocuments := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersDocuments_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersDocuments; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersDesktop_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersDesktop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersDesktop_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersDesktop; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersAppData_W(Self: TJvDirectories; const T: string);
begin Self.AllUsersAppData := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesAllUsersAppData_R(Self: TJvDirectories; var T: string);
begin T := Self.AllUsersAppData; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonPersonal_W(Self: TJvDirectories; const T: string);
begin Self.CommonPersonal := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonPersonal_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonPersonal; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonTemplates_W(Self: TJvDirectories; const T: string);
begin Self.CommonTemplates := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonTemplates_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonTemplates; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonStartup_W(Self: TJvDirectories; const T: string);
begin Self.CommonStartup := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonStartup_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonStartup; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonStartMenu_W(Self: TJvDirectories; const T: string);
begin Self.CommonStartMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonStartMenu_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonStartMenu; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonPrograms_W(Self: TJvDirectories; const T: string);
begin Self.CommonPrograms := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonPrograms_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonPrograms; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonDocuments_W(Self: TJvDirectories; const T: string);
begin Self.CommonDocuments := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonDocuments_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonDocuments; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonDesktop_W(Self: TJvDirectories; const T: string);
begin Self.CommonDesktop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonDesktop_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonDesktop; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonAppData_W(Self: TJvDirectories; const T: string);
begin Self.CommonAppData := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonAppData_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonAppData; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonAdminTools_W(Self: TJvDirectories; const T: string);
begin Self.CommonAdminTools := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCommonAdminTools_R(Self: TJvDirectories; var T: string);
begin T := Self.CommonAdminTools; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesTemplates_W(Self: TJvDirectories; const T: string);
begin Self.Templates := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesTemplates_R(Self: TJvDirectories; var T: string);
begin T := Self.Templates; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesStartup_W(Self: TJvDirectories; const T: string);
begin Self.Startup := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesStartup_R(Self: TJvDirectories; var T: string);
begin T := Self.Startup; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesStartMenu_W(Self: TJvDirectories; const T: string);
begin Self.StartMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesStartMenu_R(Self: TJvDirectories; var T: string);
begin T := Self.StartMenu; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesSendTo_W(Self: TJvDirectories; const T: string);
begin Self.SendTo := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesSendTo_R(Self: TJvDirectories; var T: string);
begin T := Self.SendTo; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesRecent_W(Self: TJvDirectories; const T: string);
begin Self.Recent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesRecent_R(Self: TJvDirectories; var T: string);
begin T := Self.Recent; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesProgramFiles_W(Self: TJvDirectories; const T: string);
begin Self.ProgramFiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesProgramFiles_R(Self: TJvDirectories; var T: string);
begin T := Self.ProgramFiles; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesPrograms_W(Self: TJvDirectories; const T: string);
begin Self.Programs := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesPrograms_R(Self: TJvDirectories; var T: string);
begin T := Self.Programs; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesPersonal_W(Self: TJvDirectories; const T: string);
begin Self.Personal := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesPersonal_R(Self: TJvDirectories; var T: string);
begin T := Self.Personal; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesNetHood_W(Self: TJvDirectories; const T: string);
begin Self.NetHood := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesNetHood_R(Self: TJvDirectories; var T: string);
begin T := Self.NetHood; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesHistory_W(Self: TJvDirectories; const T: string);
begin Self.History := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesHistory_R(Self: TJvDirectories; var T: string);
begin T := Self.History; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesFonts_W(Self: TJvDirectories; const T: string);
begin Self.Fonts := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesFonts_R(Self: TJvDirectories; var T: string);
begin T := Self.Fonts; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesFavorites_W(Self: TJvDirectories; const T: string);
begin Self.Favorites := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesFavorites_R(Self: TJvDirectories; var T: string);
begin T := Self.Favorites; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesDesktop_W(Self: TJvDirectories; const T: string);
begin Self.Desktop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesDesktop_R(Self: TJvDirectories; var T: string);
begin T := Self.Desktop; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCookies_W(Self: TJvDirectories; const T: string);
begin Self.Cookies := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCookies_R(Self: TJvDirectories; var T: string);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCache_W(Self: TJvDirectories; const T: string);
begin Self.Cache := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCache_R(Self: TJvDirectories; var T: string);
begin T := Self.Cache; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesApplicationData_W(Self: TJvDirectories; const T: string);
begin Self.ApplicationData := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesApplicationData_R(Self: TJvDirectories; var T: string);
begin T := Self.ApplicationData; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesTempPath_W(Self: TJvDirectories; const T: string);
begin Self.TempPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesTempPath_R(Self: TJvDirectories; var T: string);
begin T := Self.TempPath; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesSystemDirectory_W(Self: TJvDirectories; const T: string);
begin Self.SystemDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesSystemDirectory_R(Self: TJvDirectories; var T: string);
begin T := Self.SystemDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesWindowsDirectory_W(Self: TJvDirectories; const T: string);
begin Self.WindowsDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesWindowsDirectory_R(Self: TJvDirectories; var T: string);
begin T := Self.WindowsDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCurrentDirectory_W(Self: TJvDirectories; const T: string);
begin Self.CurrentDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDirectoriesCurrentDirectory_R(Self: TJvDirectories; var T: string);
begin T := Self.CurrentDirectory; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDirectories(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDirectories) do begin
    RegisterPropertyHelper(@TJvDirectoriesCurrentDirectory_R,@TJvDirectoriesCurrentDirectory_W,'CurrentDirectory');
    RegisterPropertyHelper(@TJvDirectoriesWindowsDirectory_R,@TJvDirectoriesWindowsDirectory_W,'WindowsDirectory');
    RegisterPropertyHelper(@TJvDirectoriesSystemDirectory_R,@TJvDirectoriesSystemDirectory_W,'SystemDirectory');
    RegisterPropertyHelper(@TJvDirectoriesTempPath_R,@TJvDirectoriesTempPath_W,'TempPath');
    RegisterPropertyHelper(@TJvDirectoriesApplicationData_R,@TJvDirectoriesApplicationData_W,'ApplicationData');
    RegisterPropertyHelper(@TJvDirectoriesCache_R,@TJvDirectoriesCache_W,'Cache');
    RegisterPropertyHelper(@TJvDirectoriesCookies_R,@TJvDirectoriesCookies_W,'Cookies');
    RegisterPropertyHelper(@TJvDirectoriesDesktop_R,@TJvDirectoriesDesktop_W,'Desktop');
    RegisterPropertyHelper(@TJvDirectoriesFavorites_R,@TJvDirectoriesFavorites_W,'Favorites');
    RegisterPropertyHelper(@TJvDirectoriesFonts_R,@TJvDirectoriesFonts_W,'Fonts');
    RegisterPropertyHelper(@TJvDirectoriesHistory_R,@TJvDirectoriesHistory_W,'History');
    RegisterPropertyHelper(@TJvDirectoriesNetHood_R,@TJvDirectoriesNetHood_W,'NetHood');
    RegisterPropertyHelper(@TJvDirectoriesPersonal_R,@TJvDirectoriesPersonal_W,'Personal');
    RegisterPropertyHelper(@TJvDirectoriesPrograms_R,@TJvDirectoriesPrograms_W,'Programs');
    RegisterPropertyHelper(@TJvDirectoriesProgramFiles_R,@TJvDirectoriesProgramFiles_W,'ProgramFiles');
    RegisterPropertyHelper(@TJvDirectoriesRecent_R,@TJvDirectoriesRecent_W,'Recent');
    RegisterPropertyHelper(@TJvDirectoriesSendTo_R,@TJvDirectoriesSendTo_W,'SendTo');
    RegisterPropertyHelper(@TJvDirectoriesStartMenu_R,@TJvDirectoriesStartMenu_W,'StartMenu');
    RegisterPropertyHelper(@TJvDirectoriesStartup_R,@TJvDirectoriesStartup_W,'Startup');
    RegisterPropertyHelper(@TJvDirectoriesTemplates_R,@TJvDirectoriesTemplates_W,'Templates');
    RegisterPropertyHelper(@TJvDirectoriesCommonAdminTools_R,@TJvDirectoriesCommonAdminTools_W,'CommonAdminTools');
    RegisterPropertyHelper(@TJvDirectoriesCommonAppData_R,@TJvDirectoriesCommonAppData_W,'CommonAppData');
    RegisterPropertyHelper(@TJvDirectoriesCommonDesktop_R,@TJvDirectoriesCommonDesktop_W,'CommonDesktop');
    RegisterPropertyHelper(@TJvDirectoriesCommonDocuments_R,@TJvDirectoriesCommonDocuments_W,'CommonDocuments');
    RegisterPropertyHelper(@TJvDirectoriesCommonPrograms_R,@TJvDirectoriesCommonPrograms_W,'CommonPrograms');
    RegisterPropertyHelper(@TJvDirectoriesCommonStartMenu_R,@TJvDirectoriesCommonStartMenu_W,'CommonStartMenu');
    RegisterPropertyHelper(@TJvDirectoriesCommonStartup_R,@TJvDirectoriesCommonStartup_W,'CommonStartup');
    RegisterPropertyHelper(@TJvDirectoriesCommonTemplates_R,@TJvDirectoriesCommonTemplates_W,'CommonTemplates');
    RegisterPropertyHelper(@TJvDirectoriesCommonPersonal_R,@TJvDirectoriesCommonPersonal_W,'CommonPersonal');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersAppData_R,@TJvDirectoriesAllUsersAppData_W,'AllUsersAppData');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersDesktop_R,@TJvDirectoriesAllUsersDesktop_W,'AllUsersDesktop');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersDocuments_R,@TJvDirectoriesAllUsersDocuments_W,'AllUsersDocuments');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersPrograms_R,@TJvDirectoriesAllUsersPrograms_W,'AllUsersPrograms');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersStartMenu_R,@TJvDirectoriesAllUsersStartMenu_W,'AllUsersStartMenu');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersStartup_R,@TJvDirectoriesAllUsersStartup_W,'AllUsersStartup');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersTemplates_R,@TJvDirectoriesAllUsersTemplates_W,'AllUsersTemplates');
    RegisterPropertyHelper(@TJvDirectoriesAllUsersFavorites_R,@TJvDirectoriesAllUsersFavorites_W,'AllUsersFavorites');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDirectories(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDirectories(CL);
end;

 
 
{ TPSImport_JvDirectories }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDirectories.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDirectories(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDirectories.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDirectories(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
