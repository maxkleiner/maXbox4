unit uPSI_JvBrowseFolder;
{
  just for  BrowseForFolder!
  add consts too
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
  TPSImport_JvBrowseFolder = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvBrowseForFolderDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvBrowseFolder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvBrowseFolder_Routines(S: TPSExec);
procedure RIRegister_TJvBrowseForFolderDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvBrowseFolder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Messages
  ,ShlObj
  ,JvBaseDlg
  ,JvBrowseFolder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvBrowseFolder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvBrowseForFolderDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvBrowseForFolderDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvBrowseForFolderDialog') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure DefaultHandler( var Msg)');
    RegisterMethod('Procedure SetSelection( const APath : string);');
    //RegisterMethod('Procedure SetSelection1( IDList : PItemIDList);');
    RegisterMethod('Procedure SetStatusText( const AText : string)');
    RegisterMethod('Procedure SetStatusTextW( const AText : WideString)');
    RegisterMethod('Procedure SetOKEnabled( const Value : Boolean)');
    RegisterMethod('Procedure SetOKText( const AText : string)');
    RegisterMethod('Procedure SetOKTextW( const AText : WideString)');
    RegisterMethod('Procedure SetExpanded( const APath : string);');
    RegisterMethod('Procedure SetExpandedW( const APath : WideString)');
    RegisterMethod('Procedure SetExpanded1( IDList : PItemIDList);');
    RegisterProperty('Pidl', 'PItemIDList', iptr);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('Directory', 'string', iptrw);
    RegisterProperty('DisplayName', 'string', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('Options', 'TOptionsDir', iptrw);
    RegisterProperty('Position', 'TJvFolderPos', iptrw);
    RegisterProperty('RootDirectory', 'TFromDirectory', iptrw);
    RegisterProperty('RootDirectoryPath', 'string', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('StatusText', 'string', iptrw);
    RegisterProperty('OnAcceptChange', 'TJvBrowseAcceptChange', iptrw);
    RegisterProperty('OnChange', 'TJvDirChange', iptrw);
    RegisterProperty('OnGetEnumFlags', 'TJvGetEnumFlagsEvent', iptrw);
    RegisterProperty('OnInitialized', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShouldShow', 'TJvShouldShowEvent', iptrw);
    RegisterProperty('OnValidateFailed', 'TJvValidateFailedEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvBrowseFolder(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('IID_IFolderFilterSite','TGUID').SetString( '{C0A651F5-B48B-11d2-B5ED-006097C686F6}');
 CL.AddConstantN('BIF_RETURNFSANCESTORS','LongWord').SetUInt( $0008);
 CL.AddConstantN('BIF_EDITBOX','LongWord').SetUInt( $0010);
 CL.AddConstantN('BIF_VALIDATE','LongWord').SetUInt( $0020);
 CL.AddConstantN('BIF_NEWDIALOGSTYLE','LongWord').SetUInt( $0040);
 CL.AddConstantN('BIF_BROWSEINCLUDEURLS','LongWord').SetUInt( $0080);
 CL.AddConstantN('BIF_UAHINT','LongWord').SetUInt( $0100);
 CL.AddConstantN('BIF_NONEWFOLDERBUTTON','LongWord').SetUInt( $0200);
 CL.AddConstantN('BIF_BROWSEINCLUDEFILES','LongWord').SetUInt( $4000);
 CL.AddConstantN('BIF_SHAREABLE','LongWord').SetUInt( $8000);
 CL.AddConstantN('SHCONTF_INIT_ON_FIRST_NEXT','LongWord').SetUInt( $0100);
 CL.AddConstantN('SHCONTF_NETPRINTERSRCH','LongWord').SetUInt( $0200);
 CL.AddConstantN('SHCONTF_SHAREABLE','LongWord').SetUInt( $0400);
 CL.AddConstantN('SHCONTF_STORAGE','LongWord').SetUInt( $0800);
 CL.AddConstantN('CSIDL_MYDOCUMENTS','LongWord').SetUInt( $000C);
 CL.AddConstantN('CSIDL_MYMUSIC','LongWord').SetUInt( $000D);
 CL.AddConstantN('CSIDL_MYVIDEO','LongWord').SetUInt( $000E);
 CL.AddConstantN('CSIDL_LOCAL_APPDATA','LongWord').SetUInt( $001C);
 CL.AddConstantN('CSIDL_COMMON_APPDATA','LongWord').SetUInt( $0023);
 CL.AddConstantN('CSIDL_WINDOWS','LongWord').SetUInt( $0024);
 CL.AddConstantN('CSIDL_SYSTEM','LongWord').SetUInt( $0025);
 CL.AddConstantN('CSIDL_PROGRAM_FILES','LongWord').SetUInt( $0026);
 CL.AddConstantN('CSIDL_MYPICTURES','LongWord').SetUInt( $0027);
 CL.AddConstantN('CSIDL_PROFILE','LongWord').SetUInt( $0028);
 CL.AddConstantN('CSIDL_PROGRAM_FILES_COMMON','LongWord').SetUInt( $002B);
 CL.AddConstantN('CSIDL_COMMON_TEMPLATES','LongWord').SetUInt( $002D);
 CL.AddConstantN('CSIDL_COMMON_DOCUMENTS','LongWord').SetUInt( $002E);
 CL.AddConstantN('CSIDL_COMMON_ADMINTOOLS','LongWord').SetUInt( $002F);
 CL.AddConstantN('CSIDL_ADMINTOOLS','LongWord').SetUInt( $0030);
 CL.AddConstantN('CSIDL_CONNECTIONS','LongWord').SetUInt( $0031);
 CL.AddConstantN('CSIDL_COMMON_MUSIC','LongWord').SetUInt( $0035);
 CL.AddConstantN('CSIDL_COMMON_PICTURES','LongWord').SetUInt( $0036);
 CL.AddConstantN('CSIDL_COMMON_VIDEO','LongWord').SetUInt( $0037);
 CL.AddConstantN('CSIDL_RESOURCES','LongWord').SetUInt( $0038);
 CL.AddConstantN('CSIDL_RESOURCES_LOCALIZED','LongWord').SetUInt( $0039);
 CL.AddConstantN('CSIDL_COMMON_OEM_LINKS','LongWord').SetUInt( $003A);
 CL.AddConstantN('CSIDL_CDBURN_AREA','LongWord').SetUInt( $003B);
 CL.AddConstantN('CSIDL_COMPUTERSNEARME','LongWord').SetUInt( $003D);
 CL.AddConstantN('CSIDL_DESKTOPDIRECTORY','LongWord').SetUInt($0010);



 CL.AddConstantN('CSIDL_PROFILES','LongWord').SetUInt( $003E);
 CL.AddConstantN('SID_IFolderFilterSite','String').SetString( '{C0A651F5-B48B-11d2-B5ED-006097C686F6}');
 //CL.AddConstantN('IID_IFolderFilter','TGUID').SetString( '{9CC22886-DC8E-11d2-B1D0-00C04F8EEB3E}');
 CL.AddConstantN('SID_IFolderFilter','String').SetString( '{9CC22886-DC8E-11d2-B1D0-00C04F8EEB3E}');
  CL.AddTypeS('TJvBrowsableObjectClass', '( ocFolders, ocNonFolders, ocIncludeH'
   +'idden, ocInitOnFirstNext, ocNetPrinterSrch, ocSharable, ocStorage )');
  CL.AddTypeS('TJvBrowsableObjectClasses', 'set of TJvBrowsableObjectClass');
  CL.AddTypeS('TJvBrowseAcceptChange', 'Procedure ( Sender : TObject; const New'
   +'Folder : string; var Accept : Boolean)');
  CL.AddTypeS('TJvShouldShowEvent', 'Procedure(Sender: TObject; const Item: string; var DoShow : Boolean)');
  CL.AddTypeS('TJvGetEnumFlagsEvent', 'Procedure ( Sender : TObject; const AFol'
   +'der : string; var Flags : TJvBrowsableObjectClasses)');
  CL.AddTypeS('TJvDirChange', 'Procedure ( Sender : TObject; const Directory:string)');
  CL.AddTypeS('TJvValidateFailedEvent', 'Procedure ( Sender : TObject; const AE'
   +'ditText : string; var CanCloseDialog : Boolean)');
  CL.AddTypeS('TFromDirectory', '( fdNoSpecialFolder, fdRootFolder, fdRecycleBi'
   +'n, fdControlPanel, fdDesktop, fdDesktopDirectory, fdMyComputer, fdFonts, f'
   +'dNetHood, fdNetwork, fdPersonal, fdPrinters, fdPrograms, fdRecent, fdSendT'
   +'o, fdStartMenu, fdStartup, fdTemplates, fdStartUpNonLocalized, fdCommonSta'
   +'rtUpNonLocalized, fdCommonDocuments, fdCommonFavorites, fdCommonPrograms, '
   +'fdCommonStartUp, fdCommonTemplates, fdCookies, fdFavorites, fdHistory, fdI'
   +'nternet, fdMyMusic, fdPrinthood, fdConnections, fdAppData, fdInternetCache'
   +', fdAdminTools, fdCommonAdminTools, fdCommonAppData, fdLocalAppData, fdMyP'
   +'ictures, fdProfile, fdProgramFiles, fdProgramFilesCommon, fdSystem, fdWind'
   +'ows, fdCDBurnArea, fdCommonMusic, fdCommonPictures, fdCommonVideo, fdMyDoc'
   +'uments, fdMyVideo, fdProfiles, fdResources, fdResourcesLocalized, fdCommon'
   +'OEMLinks, fdComputersNearMe )');
  CL.AddTypeS('TJvFolderPos', '( fpDefault, fpScreenCenter, fpFormCenter, fpTop'
   +'Left, fpTopRight, fpBottomLeft, fpBottomRight )');
  CL.AddTypeS('TOptionsDirectory', '( odBrowseForComputer, odOnlyDirectory, odO'
   +'nlyPrinters, odNoBelowDomain, odSystemAncestorsOnly, odFileSystemDirectory'
   +'Only, odStatusAvailable, odIncludeFiles, odIncludeUrls, odEditBox, odNewDi'
   +'alogStyle, odShareable, odUsageHint, odNoNewButtonFolder, odValidate )');
  CL.AddTypeS('TOptionsDir', 'set of TOptionsDirectory');
 CL.AddConstantN('DefaultJvBrowseFolderDialogOptions','LongInt').Value.ts32 := ord(odStatusAvailable) or ord(odNewDialogStyle);
  SIRegister_TJvBrowseForFolderDialog(CL);
 CL.AddDelphiFunction('Function BrowseForFolder( const ATitle : string; AllowCreate : Boolean; var ADirectory : string; AHelpContext : THelpContext) : Boolean');
 CL.AddDelphiFunction('Function BrowseForComputer( const ATitle : string; AllowCreate : Boolean; var ADirectory : string; AHelpContext : THelpContext) : Boolean');
 CL.AddDelphiFunction('Function BrowseDirectory( var AFolderName : string; const DlgText : string; AHelpContext : THelpContext) : Boolean');
 CL.AddDelphiFunction('Function BrowseComputer( var AComputerName : string; const DlgText : string; AHelpContext : THelpContext) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogOnValidateFailed_W(Self: TJvBrowseForFolderDialog; const T: TJvValidateFailedEvent);
//begin Self.OnValidateFailed := T; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogOnValidateFailed_R(Self: TJvBrowseForFolderDialog; var T: TJvValidateFailedEvent);
//begin T := Self.OnValidateFailed; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogOnShouldShow_W(Self: TJvBrowseForFolderDialog; const T: TJvShouldShowEvent);
//begin Self.OnShouldShow := T; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogOnShouldShow_R(Self: TJvBrowseForFolderDialog; var T: TJvShouldShowEvent);
//begin T := Self.OnShouldShow; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogOnInitialized_W(Self: TJvBrowseForFolderDialog; const T: TNotifyEvent);
//begin Self.OnInitialized := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogOnInitialized_R(Self: TJvBrowseForFolderDialog; var T: TNotifyEvent);
begin T := Self.OnInitialized; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogOnGetEnumFlags_W(Self: TJvBrowseForFolderDialog; const T: TJvGetEnumFlagsEvent);
//begin Self.OnGetEnumFlags := T; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogOnGetEnumFlags_R(Self: TJvBrowseForFolderDialog; var T: TJvGetEnumFlagsEvent);
//begin T := Self.OnGetEnumFlags; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogOnChange_W(Self: TJvBrowseForFolderDialog; const T: TJvDirChange);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogOnChange_R(Self: TJvBrowseForFolderDialog; var T: TJvDirChange);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogOnAcceptChange_W(Self: TJvBrowseForFolderDialog; const T: TJvBrowseAcceptChange);
begin Self.OnAcceptChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogOnAcceptChange_R(Self: TJvBrowseForFolderDialog; var T: TJvBrowseAcceptChange);
begin T := Self.OnAcceptChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogStatusText_W(Self: TJvBrowseForFolderDialog; const T: string);
begin Self.StatusText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogStatusText_R(Self: TJvBrowseForFolderDialog; var T: string);
begin T := Self.StatusText; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogTitle_W(Self: TJvBrowseForFolderDialog; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogTitle_R(Self: TJvBrowseForFolderDialog; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogRootDirectoryPath_W(Self: TJvBrowseForFolderDialog; const T: string);
//begin Self.RootDirectoryPath := T; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogRootDirectoryPath_R(Self: TJvBrowseForFolderDialog; var T: string);
//begin T := Self.RootDirectoryPath; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogRootDirectory_W(Self: TJvBrowseForFolderDialog; const T: TFromDirectory);
begin Self.RootDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogRootDirectory_R(Self: TJvBrowseForFolderDialog; var T: TFromDirectory);
begin T := Self.RootDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogPosition_W(Self: TJvBrowseForFolderDialog; const T: TJvFolderPos);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogPosition_R(Self: TJvBrowseForFolderDialog; var T: TJvFolderPos);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogOptions_W(Self: TJvBrowseForFolderDialog; const T: TOptionsDir);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogOptions_R(Self: TJvBrowseForFolderDialog; var T: TOptionsDir);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogHelpContext_W(Self: TJvBrowseForFolderDialog; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogHelpContext_R(Self: TJvBrowseForFolderDialog; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogDisplayName_W(Self: TJvBrowseForFolderDialog; const T: string);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogDisplayName_R(Self: TJvBrowseForFolderDialog; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogDirectory_W(Self: TJvBrowseForFolderDialog; const T: string);
begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogDirectory_R(Self: TJvBrowseForFolderDialog; var T: string);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseForFolderDialogHandle_R(Self: TJvBrowseForFolderDialog; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
//procedure TJvBrowseForFolderDialogPidl_R(Self: TJvBrowseForFolderDialog; var T: PItemIDList);
//begin T := Self.Pidl; end;

(*----------------------------------------------------------------------------*)
//Procedure TJvBrowseForFolderDialogSetExpanded1_P(Self: TJvBrowseForFolderDialog;  IDList : PItemIDList);
//Begin Self.SetExpanded(IDList); END;

(*----------------------------------------------------------------------------*)
//Procedure TJvBrowseForFolderDialogSetExpanded_P(Self: TJvBrowseForFolderDialog;  const APath : string);
//Begin Self.SetExpanded(APath); END;

(*----------------------------------------------------------------------------*)
//Procedure TJvBrowseForFolderDialogSetSelection1_P(Self: TJvBrowseForFolderDialog;  IDList : PItemIDList);
//Begin Self.SetSelection(IDList); END;

(*----------------------------------------------------------------------------*)
//Procedure TJvBrowseForFolderDialogSetSelection_P(Self: TJvBrowseForFolderDialog;  const APath : string);
//Begin Self.SetSelection(APath); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvBrowseFolder_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BrowseForFolder, 'BrowseForFolder', cdRegister);
 S.RegisterDelphiFunction(@BrowseForComputer, 'BrowseForComputer', cdRegister);
 S.RegisterDelphiFunction(@BrowseDirectory, 'BrowseDirectory', cdRegister);
 S.RegisterDelphiFunction(@BrowseComputer, 'BrowseComputer', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvBrowseForFolderDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvBrowseForFolderDialog) do begin
    RegisterConstructor(@TJvBrowseForFolderDialog.Create, 'Create');
    RegisterMethod(@TJvBrowseForFolderDialog.DefaultHandler, 'DefaultHandler');
    //RegisterMethod(@TJvBrowseForFolderDialogSetSelection_P, 'SetSelection');
    //RegisterMethod(@TJvBrowseForFolderDialogSetSelection1_P, 'SetSelection1');
    RegisterMethod(@TJvBrowseForFolderDialog.SetStatusText, 'SetStatusText');
    //RegisterMethod(@TJvBrowseForFolderDialog.SetStatusTextW, 'SetStatusTextW');
    RegisterMethod(@TJvBrowseForFolderDialog.SetOKEnabled, 'SetOKEnabled');
    //RegisterMethod(@TJvBrowseForFolderDialog.SetOKText, 'SetOKText');
    //RegisterMethod(@TJvBrowseForFolderDialog.SetOKTextW, 'SetOKTextW');
    //RegisterMethod(@TJvBrowseForFolderDialogSetExpanded_P, 'SetExpanded');
    //RegisterMethod(@TJvBrowseForFolderDialog.SetExpandedW, 'SetExpandedW');
    //RegisterMethod(@TJvBrowseForFolderDialogSetExpanded1_P, 'SetExpanded1');
    //RegisterPropertyHelper(@TJvBrowseForFolderDialogPidl_R,nil,'Pidl');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogDirectory_R,@TJvBrowseForFolderDialogDirectory_W,'Directory');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogDisplayName_R,@TJvBrowseForFolderDialogDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogHelpContext_R,@TJvBrowseForFolderDialogHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogOptions_R,@TJvBrowseForFolderDialogOptions_W,'Options');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogPosition_R,@TJvBrowseForFolderDialogPosition_W,'Position');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogRootDirectory_R,@TJvBrowseForFolderDialogRootDirectory_W,'RootDirectory');
   // RegisterPropertyHelper(@TJvBrowseForFolderDialogRootDirectoryPath_R,@TJvBrowseForFolderDialogRootDirectoryPath_W,'RootDirectoryPath');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogTitle_R,@TJvBrowseForFolderDialogTitle_W,'Title');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogStatusText_R,@TJvBrowseForFolderDialogStatusText_W,'StatusText');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogOnAcceptChange_R,@TJvBrowseForFolderDialogOnAcceptChange_W,'OnAcceptChange');
    RegisterPropertyHelper(@TJvBrowseForFolderDialogOnChange_R,@TJvBrowseForFolderDialogOnChange_W,'OnChange');
    //RegisterPropertyHelper(@TJvBrowseForFolderDialogOnGetEnumFlags_R,@TJvBrowseForFolderDialogOnGetEnumFlags_W,'OnGetEnumFlags');
    //RegisterPropertyHelper(@TJvBrowseForFolderDialogOnInitialized_R,@TJvBrowseForFolderDialogOnInitialized_W,'OnInitialized');
    //RegisterPropertyHelper(@TJvBrowseForFolderDialogOnShouldShow_R,@TJvBrowseForFolderDialogOnShouldShow_W,'OnShouldShow');
   // RegisterPropertyHelper(@TJvBrowseForFolderDialogOnValidateFailed_R,@TJvBrowseForFolderDialogOnValidateFailed_W,'OnValidateFailed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvBrowseFolder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvBrowseForFolderDialog(CL);
end;

 
 
{ TPSImport_JvBrowseFolder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBrowseFolder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvBrowseFolder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBrowseFolder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvBrowseFolder(ri);
  RIRegister_JvBrowseFolder_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
