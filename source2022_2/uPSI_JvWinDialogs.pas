unit uPSI_JvWinDialogs;
{
  admin dialogs , more create and free
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
  TPSImport_JvWinDialogs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSaveDialog2000(CL: TPSPascalCompiler);
procedure SIRegister_TJvOpenDialog2000(CL: TPSPascalCompiler);
procedure SIRegister_TJvExitWindowsDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvDiskFullDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvOpenWithDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvAddHardwareDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvNewLinkDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvObjectPropertiesDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvRunDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvShellAboutDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvChangeIconDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvOutOfMemoryDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvBrowseFolderDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvComputerNameDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvAppletDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvControlPanelDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvOrganizeFavoritesDialog(CL: TPSPascalCompiler);
procedure SIRegister_TJvFormatDriveDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvWinDialogs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvWinDialogs_Routines(S: TPSExec);
procedure RIRegister_TJvSaveDialog2000(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvOpenDialog2000(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvExitWindowsDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDiskFullDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvOpenWithDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvAddHardwareDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvNewLinkDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvObjectPropertiesDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvRunDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvShellAboutDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvChangeIconDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvOutOfMemoryDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvBrowseFolderDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvComputerNameDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvAppletDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvControlPanelDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvOrganizeFavoritesDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvFormatDriveDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvWinDialogs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //ShellAPI
  //,Windows
  //,Forms
  Graphics
  //,Dialogs
  //,Controls
  //,ShlObj
  //,ComObj
  //,ActiveX
  //,CommDlg
  //,JvBaseDlg
  //,JvTypes
  //,JvComponent
  //,JvFunctions_max
  ,JvWinDialogs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvWinDialogs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSaveDialog2000(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSaveDialog', 'TJvSaveDialog2000') do
  with CL.AddClassN(CL.FindClass('TSaveDialog'),'TJvSaveDialog2000') do begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvOpenDialog2000(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenDialog', 'TJvOpenDialog2000') do
  with CL.AddClassN(CL.FindClass('TOpenDialog'),'TJvOpenDialog2000') do begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvExitWindowsDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogP', 'TJvExitWindowsDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogP'),'TJvExitWindowsDialog') do
  begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Execute');
     RegisterMethod('Procedure Free');
 end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDiskFullDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvDiskFullDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvDiskFullDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('DriveChar', 'Char', iptrw);
    RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvOpenWithDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogP', 'TJvOpenWithDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogP'),'TJvOpenWithDialog') do begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Execute');
    RegisterProperty('FileName', 'string', iptrw);
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAddHardwareDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogP', 'TJvAddHardwareDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogP'),'TJvAddHardwareDialog') do begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Execute');
   RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvNewLinkDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogP', 'TJvNewLinkDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogP'),'TJvNewLinkDialog') do begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Execute');
    RegisterProperty('DestinationFolder', 'string', iptrw);
   RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvObjectPropertiesDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvObjectPropertiesDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvObjectPropertiesDialog') do
  begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('ObjectName', 'TFileName', iptrw);
    RegisterProperty('ObjectType', 'TShellObjectType', iptrw);
    RegisterProperty('InitialTab', 'string', iptrw);
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvRunDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogP', 'TJvRunDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogP'),'TJvRunDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Execute');
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('Icon', 'TIcon', iptrw);
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvShellAboutDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvShellAboutDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialog'),'TJvShellAboutDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Icon', 'TIcon', iptrw);
    RegisterProperty('OtherText', 'string', iptrw);
    RegisterProperty('Product', 'string', iptrw);
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvChangeIconDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvChangeIconDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvChangeIconDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Function Execute : Boolean');
    RegisterProperty('IconIndex', 'Integer', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvOutOfMemoryDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvOutOfMemoryDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialog'),'TJvOutOfMemoryDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Caption', 'string', iptrw);
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvBrowseFolderDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvBrowseFolderDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialog'),'TJvBrowseFolderDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('FolderName', 'string', iptr);
    RegisterProperty('Caption', 'string', iptrw);
        RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvComputerNameDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvComputerNameDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialog'),'TJvComputerNameDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('ComputerName', 'string', iptr);
    RegisterProperty('Caption', 'string', iptrw);
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAppletDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvAppletDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvAppletDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('AppletInfo', 'TJvCplInfo Integer', iptr);
    RegisterProperty('AppletName', 'string', iptrw);
    RegisterProperty('AppletIndex', 'Integer', iptrw);
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvControlPanelDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogP', 'TJvControlPanelDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogP'),'TJvControlPanelDialog') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvOrganizeFavoritesDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvOrganizeFavoritesDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialog'),'TJvOrganizeFavoritesDialog') do
  begin
      RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFormatDriveDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialogF', 'TJvFormatDriveDialog') do
  with CL.AddClassN(CL.FindClass('TJvCommonDialogF'),'TJvFormatDriveDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Drive', 'Char', iptrw);
    RegisterProperty('FormatType', 'TJvFormatDriveKind', iptrw);
    RegisterProperty('Capacity', 'TJvDriveCapacity', iptrw);
    RegisterProperty('OnError', 'TJvFormatDriveErrorEvent', iptrw);
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvWinDialogs(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EShellOleError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWinDialogError');
  CL.AddTypeS('TShellLinkInfo', 'record PathName : string; Arguments : string; '
   +'Description : string; WorkingDirectory : string; IconLocation : string; Ic'
   +'onIndex : Integer; ShowCmd : Integer; HotKey : Word; end');
  CL.AddTypeS('TSpecialFolderInfo', 'record Name : string; ID : Integer; end');
 CL.AddConstantN('OFN_EX_NOPLACESBAR','LongInt').SetInt( 1);
 CL.AddConstantN('OPF_PRINTERNAME','LongWord').SetUInt( $01);
 CL.AddConstantN('OPF_PATHNAME','LongWord').SetUInt( $02);
  {CL.AddTypeS('TOpenFileNameEx', 'record lStructSize : DWORD; hWndOwner : HWND;'
   +' hInstance : HINST; lpstrFilter : PAnsiChar; lpstrCustomFilter : PAnsiChar'
   +'; nMaxCustFilter : DWORD; nFilterIndex : DWORD; lpstrFile : PAnsiChar; nMa'
   +'xFile : DWORD; lpstrFileTitle : PAnsiChar; nMaxFileTitle : DWORD; lpstrIni'
   +'tialDir : PAnsiChar; lpstrTitle : PAnsiChar; Flags : DWORD; nFileOffset : '
   +'Word; nFileExtension : Word; lpstrDefExt : PAnsiChar; lCustData : LPARAM; '
   +'lpTemplateName : PAnsiChar; pvReserved : Pointer; dwReserved : DWORD; FlagsEx : DWORD; end');}
  CL.AddTypeS('TShellObjectType', '( sdPathObject, sdPrinterObject )');
  CL.AddTypeS('TShellObjectTypes', 'set of TShellObjectType');
  CL.AddTypeS('TJvFormatDriveKind', '( ftQuick, ftStandard, ftBootable )');
  CL.AddTypeS('TJvDriveCapacity', '( dcDefault, dcSize360kB, dcSize720kB )');
  CL.AddTypeS('TJvFormatDriveError', '( errParams, errSysError, errAborted, err'
   +'CannotFormat, errOther )');
  CL.AddTypeS('TJvFormatDriveErrorEvent', 'Procedure ( Sender : TObject; Error '
   +': TJvFormatDriveError)');
  SIRegister_TJvFormatDriveDialog(CL);
  SIRegister_TJvOrganizeFavoritesDialog(CL);
  SIRegister_TJvControlPanelDialog(CL);
  CL.AddTypeS('TJvCplInfo', 'record Icon : TIcon; Name : string; Info : string; lData : Longint; end');
  SIRegister_TJvAppletDialog(CL);
  SIRegister_TJvComputerNameDialog(CL);
  SIRegister_TJvBrowseFolderDialog(CL);
  SIRegister_TJvOutOfMemoryDialog(CL);
  SIRegister_TJvChangeIconDialog(CL);
  SIRegister_TJvShellAboutDialog(CL);
  SIRegister_TJvRunDialog(CL);
  SIRegister_TJvObjectPropertiesDialog(CL);
  SIRegister_TJvNewLinkDialog(CL);
  SIRegister_TJvAddHardwareDialog(CL);
  SIRegister_TJvOpenWithDialog(CL);
  SIRegister_TJvDiskFullDialog(CL);
  SIRegister_TJvExitWindowsDialog(CL);
  SIRegister_TJvOpenDialog2000(CL);
  SIRegister_TJvSaveDialog2000(CL);
 CL.AddDelphiFunction('Function GetSpecialFolderPath( const FolderName : string; CanCreate : Boolean) : string');
 CL.AddDelphiFunction('Procedure JAddToRecentDocs( const Filename : string)');
 CL.AddDelphiFunction('Procedure ClearRecentDocs');
 CL.AddDelphiFunction('Function ExtractIconFromFile( FileName : string; Index : Integer) : HICON');
 CL.AddDelphiFunction('Function CreateShellLink( const AppName, Desc : string; Dest : string) : string');
 CL.AddDelphiFunction('Procedure GetShellLinkInfo( const LinkFile : WideString; var SLI : TShellLinkInfo)');
 CL.AddDelphiFunction('Procedure SetShellLinkInfo( const LinkFile : WideString; const SLI : TShellLinkInfo)');
 CL.AddDelphiFunction('Function RecycleFile( FileToRecycle : string) : Boolean');
 CL.AddDelphiFunction('Function JCopyFile( FromFile, ToDir : string) : Boolean');
 CL.AddDelphiFunction('Function ShellObjectTypeEnumToConst( ShellObjectType : TShellObjectType) : UINT');
 CL.AddDelphiFunction('Function ShellObjectTypeConstToEnum( ShellObjectType : UINT) : TShellObjectType');
 //CL.AddDelphiFunction('Function ShellMessageBox( Instance : THandle; Owner : HWND; Text : PChar; Caption : PChar; Style : UINT; Parameters : array of ___Pointer) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDiskFullDialogDriveChar_W(Self: TJvDiskFullDialog; const T: Char);
begin Self.DriveChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDiskFullDialogDriveChar_R(Self: TJvDiskFullDialog; var T: Char);
begin T := Self.DriveChar; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenWithDialogFileName_W(Self: TJvOpenWithDialog; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOpenWithDialogFileName_R(Self: TJvOpenWithDialog; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvNewLinkDialogDestinationFolder_W(Self: TJvNewLinkDialog; const T: string);
begin Self.DestinationFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNewLinkDialogDestinationFolder_R(Self: TJvNewLinkDialog; var T: string);
begin T := Self.DestinationFolder; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectPropertiesDialogInitialTab_W(Self: TJvObjectPropertiesDialog; const T: string);
begin Self.InitialTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectPropertiesDialogInitialTab_R(Self: TJvObjectPropertiesDialog; var T: string);
begin T := Self.InitialTab; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectPropertiesDialogObjectType_W(Self: TJvObjectPropertiesDialog; const T: TShellObjectType);
begin Self.ObjectType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectPropertiesDialogObjectType_R(Self: TJvObjectPropertiesDialog; var T: TShellObjectType);
begin T := Self.ObjectType; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectPropertiesDialogObjectName_W(Self: TJvObjectPropertiesDialog; const T: TFileName);
begin Self.ObjectName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectPropertiesDialogObjectName_R(Self: TJvObjectPropertiesDialog; var T: TFileName);
begin T := Self.ObjectName; end;

(*----------------------------------------------------------------------------*)
procedure TJvRunDialogIcon_W(Self: TJvRunDialog; const T: TIcon);
begin Self.Icon := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRunDialogIcon_R(Self: TJvRunDialog; var T: TIcon);
begin T := Self.Icon; end;

(*----------------------------------------------------------------------------*)
procedure TJvRunDialogDescription_W(Self: TJvRunDialog; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRunDialogDescription_R(Self: TJvRunDialog; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJvRunDialogCaption_W(Self: TJvRunDialog; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRunDialogCaption_R(Self: TJvRunDialog; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogProduct_W(Self: TJvShellAboutDialog; const T: string);
begin Self.Product := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogProduct_R(Self: TJvShellAboutDialog; var T: string);
begin T := Self.Product; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogOtherText_W(Self: TJvShellAboutDialog; const T: string);
begin Self.OtherText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogOtherText_R(Self: TJvShellAboutDialog; var T: string);
begin T := Self.OtherText; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogIcon_W(Self: TJvShellAboutDialog; const T: TIcon);
begin Self.Icon := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogIcon_R(Self: TJvShellAboutDialog; var T: TIcon);
begin T := Self.Icon; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogCaption_W(Self: TJvShellAboutDialog; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvShellAboutDialogCaption_R(Self: TJvShellAboutDialog; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvChangeIconDialogFileName_W(Self: TJvChangeIconDialog; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChangeIconDialogFileName_R(Self: TJvChangeIconDialog; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvChangeIconDialogIconIndex_W(Self: TJvChangeIconDialog; const T: Integer);
begin Self.IconIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvChangeIconDialogIconIndex_R(Self: TJvChangeIconDialog; var T: Integer);
begin T := Self.IconIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvOutOfMemoryDialogCaption_W(Self: TJvOutOfMemoryDialog; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvOutOfMemoryDialogCaption_R(Self: TJvOutOfMemoryDialog; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseFolderDialogCaption_W(Self: TJvBrowseFolderDialog; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseFolderDialogCaption_R(Self: TJvBrowseFolderDialog; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvBrowseFolderDialogFolderName_R(Self: TJvBrowseFolderDialog; var T: string);
begin T := Self.FolderName; end;

(*----------------------------------------------------------------------------*)
procedure TJvComputerNameDialogCaption_W(Self: TJvComputerNameDialog; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvComputerNameDialogCaption_R(Self: TJvComputerNameDialog; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvComputerNameDialogComputerName_R(Self: TJvComputerNameDialog; var T: string);
begin T := Self.ComputerName; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppletDialogAppletIndex_W(Self: TJvAppletDialog; const T: Integer);
begin Self.AppletIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppletDialogAppletIndex_R(Self: TJvAppletDialog; var T: Integer);
begin T := Self.AppletIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppletDialogAppletName_W(Self: TJvAppletDialog; const T: string);
begin Self.AppletName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppletDialogAppletName_R(Self: TJvAppletDialog; var T: string);
begin T := Self.AppletName; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppletDialogAppletInfo_R(Self: TJvAppletDialog; var T: TJvCplInfo; const t1: Integer);
begin T := Self.AppletInfo[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvAppletDialogCount_R(Self: TJvAppletDialog; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogOnError_W(Self: TJvFormatDriveDialog; const T: TJvFormatDriveErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogOnError_R(Self: TJvFormatDriveDialog; var T: TJvFormatDriveErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogCapacity_W(Self: TJvFormatDriveDialog; const T: TJvDriveCapacity);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogCapacity_R(Self: TJvFormatDriveDialog; var T: TJvDriveCapacity);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogFormatType_W(Self: TJvFormatDriveDialog; const T: TJvFormatDriveKind);
begin Self.FormatType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogFormatType_R(Self: TJvFormatDriveDialog; var T: TJvFormatDriveKind);
begin T := Self.FormatType; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogDrive_W(Self: TJvFormatDriveDialog; const T: Char);
begin Self.Drive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormatDriveDialogDrive_R(Self: TJvFormatDriveDialog; var T: Char);
begin T := Self.Drive; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvWinDialogs_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetSpecialFolderPath, 'GetSpecialFolderPath', cdRegister);
 S.RegisterDelphiFunction(@AddToRecentDocs, 'JAddToRecentDocs', cdRegister);
 S.RegisterDelphiFunction(@ClearRecentDocs, 'ClearRecentDocs', cdRegister);
 S.RegisterDelphiFunction(@ExtractIconFromFile, 'ExtractIconFromFile', cdRegister);
 S.RegisterDelphiFunction(@CreateShellLink, 'CreateShellLink', cdRegister);
 S.RegisterDelphiFunction(@GetShellLinkInfo, 'GetShellLinkInfo', cdRegister);
 S.RegisterDelphiFunction(@SetShellLinkInfo, 'SetShellLinkInfo', cdRegister);
 S.RegisterDelphiFunction(@RecycleFile, 'RecycleFile', cdRegister);
 S.RegisterDelphiFunction(@CopyFile, 'JCopyFile', cdRegister);
 S.RegisterDelphiFunction(@ShellObjectTypeEnumToConst, 'ShellObjectTypeEnumToConst', cdRegister);
 S.RegisterDelphiFunction(@ShellObjectTypeConstToEnum, 'ShellObjectTypeConstToEnum', cdRegister);
 S.RegisterDelphiFunction(@ShellMessageBox, 'ShellMessageBox', CdCdecl);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSaveDialog2000(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSaveDialog2000) do begin
    RegisterConstructor(@TJvSaveDialog2000.Create, 'Create');
    RegisterMethod(@TJvSaveDialog2000.Execute, 'Execute');
     RegisterMethod(@TJvSaveDialog2000.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvOpenDialog2000(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvOpenDialog2000) do begin
    RegisterConstructor(@TJvOpenDialog2000.Create, 'Create');
    RegisterMethod(@TJvOpenDialog2000.Execute, 'Execute');
    RegisterMethod(@TJvOpenDialog2000.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvExitWindowsDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvExitWindowsDialog) do begin
     RegisterConstructor(@TJvExitWindowsDialog.Create, 'Create');
    RegisterMethod(@TJvExitWindowsDialog.Execute, 'Execute');
    RegisterMethod(@TJvExitWindowsDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDiskFullDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDiskFullDialog) do begin
    RegisterConstructor(@TJvDiskFullDialog.Create, 'Create');
    RegisterMethod(@TJvDiskFullDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvDiskFullDialogDriveChar_R,@TJvDiskFullDialogDriveChar_W,'DriveChar');
    RegisterMethod(@TJvDiskFullDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvOpenWithDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvOpenWithDialog) do begin
    RegisterConstructor(@TJvOpenWithDialog.Create, 'Create');
    RegisterMethod(@TJvOpenWithDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvOpenWithDialogFileName_R,@TJvOpenWithDialogFileName_W,'FileName');
    RegisterMethod(@TJvOpenWithDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAddHardwareDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAddHardwareDialog) do begin
    RegisterConstructor(@TJvAddHardwareDialog.Create, 'Create');
    RegisterMethod(@TJvAddHardwareDialog.Execute, 'Execute');
    RegisterMethod(@TJvAddHardwareDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvNewLinkDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvNewLinkDialog) do begin
    RegisterConstructor(@TJvNewLinkDialog.Create, 'Create');
    RegisterMethod(@TJvNewLinkDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvNewLinkDialogDestinationFolder_R,@TJvNewLinkDialogDestinationFolder_W,'DestinationFolder');
    RegisterMethod(@TJvNewLinkDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvObjectPropertiesDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvObjectPropertiesDialog) do begin
    RegisterConstructor(@TJvObjectPropertiesDialog.Create, 'Create');
    RegisterMethod(@TJvObjectPropertiesDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvObjectPropertiesDialogObjectName_R,@TJvObjectPropertiesDialogObjectName_W,'ObjectName');
    RegisterPropertyHelper(@TJvObjectPropertiesDialogObjectType_R,@TJvObjectPropertiesDialogObjectType_W,'ObjectType');
    RegisterPropertyHelper(@TJvObjectPropertiesDialogInitialTab_R,@TJvObjectPropertiesDialogInitialTab_W,'InitialTab');
    RegisterMethod(@TJvObjectPropertiesDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvRunDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvRunDialog) do begin
    RegisterConstructor(@TJvRunDialog.Create, 'Create');
    RegisterMethod(@TJvRunDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvRunDialogCaption_R,@TJvRunDialogCaption_W,'Caption');
    RegisterPropertyHelper(@TJvRunDialogDescription_R,@TJvRunDialogDescription_W,'Description');
    RegisterPropertyHelper(@TJvRunDialogIcon_R,@TJvRunDialogIcon_W,'Icon');
    RegisterMethod(@TJvRunDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvShellAboutDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvShellAboutDialog) do begin
    RegisterConstructor(@TJvShellAboutDialog.Create, 'Create');
    RegisterMethod(@TJvShellAboutDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvShellAboutDialogCaption_R,@TJvShellAboutDialogCaption_W,'Caption');
    RegisterPropertyHelper(@TJvShellAboutDialogIcon_R,@TJvShellAboutDialogIcon_W,'Icon');
    RegisterPropertyHelper(@TJvShellAboutDialogOtherText_R,@TJvShellAboutDialogOtherText_W,'OtherText');
    RegisterPropertyHelper(@TJvShellAboutDialogProduct_R,@TJvShellAboutDialogProduct_W,'Product');
    RegisterMethod(@TJvShellAboutDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvChangeIconDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvChangeIconDialog) do begin
    RegisterConstructor(@TJvChangeIconDialog.Create, 'Create');
    RegisterMethod(@TJvChangeIconDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvChangeIconDialogIconIndex_R,@TJvChangeIconDialogIconIndex_W,'IconIndex');
    RegisterPropertyHelper(@TJvChangeIconDialogFileName_R,@TJvChangeIconDialogFileName_W,'FileName');
    RegisterMethod(@TJvChangeIconDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvOutOfMemoryDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvOutOfMemoryDialog) do begin
    RegisterConstructor(@TJvOutOfMemoryDialog.Create, 'Create');
    RegisterMethod(@TJvOutOfMemoryDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvOutOfMemoryDialogCaption_R,@TJvOutOfMemoryDialogCaption_W,'Caption');
    RegisterMethod(@TJvOutOfMemoryDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvBrowseFolderDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvBrowseFolderDialog) do begin
    RegisterConstructor(@TJvBrowseFolderDialog.Create, 'Create');
    RegisterMethod(@TJvBrowseFolderDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvBrowseFolderDialogFolderName_R,nil,'FolderName');
    RegisterPropertyHelper(@TJvBrowseFolderDialogCaption_R,@TJvBrowseFolderDialogCaption_W,'Caption');
    RegisterMethod(@TJvBrowseFolderDialog.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvComputerNameDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvComputerNameDialog) do begin
    RegisterConstructor(@TJvComputerNameDialog.Create, 'Create');
    RegisterMethod(@TJvComputerNameDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvComputerNameDialogComputerName_R,nil,'ComputerName');
    RegisterPropertyHelper(@TJvComputerNameDialogCaption_R,@TJvComputerNameDialogCaption_W,'Caption');
        RegisterMethod(@TJvComputerNameDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAppletDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAppletDialog) do begin
    RegisterConstructor(@TJvAppletDialog.Create, 'Create');
    RegisterMethod(@TJvAppletDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvAppletDialogCount_R,nil,'Count');
    RegisterPropertyHelper(@TJvAppletDialogAppletInfo_R,nil,'AppletInfo');
    RegisterPropertyHelper(@TJvAppletDialogAppletName_R,@TJvAppletDialogAppletName_W,'AppletName');
    RegisterPropertyHelper(@TJvAppletDialogAppletIndex_R,@TJvAppletDialogAppletIndex_W,'AppletIndex');
    RegisterMethod(@TJvAppletDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvControlPanelDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvControlPanelDialog) do begin
    RegisterConstructor(@TJvControlPanelDialog.Create, 'Create');
    RegisterMethod(@TJvControlPanelDialog.Execute, 'Execute');
    RegisterMethod(@TJvControlPanelDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvOrganizeFavoritesDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvOrganizeFavoritesDialog) do begin
    RegisterConstructor(@TJvOrganizeFavoritesDialog.Create, 'Create');
    RegisterMethod(@TJvOrganizeFavoritesDialog.Execute, 'Execute');
    RegisterMethod(@TJvOrganizeFavoritesDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFormatDriveDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFormatDriveDialog) do begin
    RegisterConstructor(@TJvFormatDriveDialog.Create, 'Create');
    RegisterMethod(@TJvFormatDriveDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvFormatDriveDialogDrive_R,@TJvFormatDriveDialogDrive_W,'Drive');
    RegisterPropertyHelper(@TJvFormatDriveDialogFormatType_R,@TJvFormatDriveDialogFormatType_W,'FormatType');
    RegisterPropertyHelper(@TJvFormatDriveDialogCapacity_R,@TJvFormatDriveDialogCapacity_W,'Capacity');
    RegisterPropertyHelper(@TJvFormatDriveDialogOnError_R,@TJvFormatDriveDialogOnError_W,'OnError');
    RegisterMethod(@TJvFormatDriveDialog.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvWinDialogs(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EShellOleError) do
  with CL.Add(EWinDialogError) do
  RIRegister_TJvFormatDriveDialog(CL);
  RIRegister_TJvOrganizeFavoritesDialog(CL);
  RIRegister_TJvControlPanelDialog(CL);
  RIRegister_TJvAppletDialog(CL);
  RIRegister_TJvComputerNameDialog(CL);
  RIRegister_TJvBrowseFolderDialog(CL);
  RIRegister_TJvOutOfMemoryDialog(CL);
  RIRegister_TJvChangeIconDialog(CL);
  RIRegister_TJvShellAboutDialog(CL);
  RIRegister_TJvRunDialog(CL);
  RIRegister_TJvObjectPropertiesDialog(CL);
  RIRegister_TJvNewLinkDialog(CL);
  RIRegister_TJvAddHardwareDialog(CL);
  RIRegister_TJvOpenWithDialog(CL);
  RIRegister_TJvDiskFullDialog(CL);
  RIRegister_TJvExitWindowsDialog(CL);
  RIRegister_TJvOpenDialog2000(CL);
  RIRegister_TJvSaveDialog2000(CL);
end;



{ TPSImport_JvWinDialogs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWinDialogs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvWinDialogs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvWinDialogs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvWinDialogs(ri);
  RIRegister_JvWinDialogs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
