unit uPSI_cyWinUtils;
{
   win sin
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
  TPSImport_cyWinUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyWinUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyWinUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Messages
  ,WinSpool
  ,ShellAPI
  ,ShlObj
  ,ComObj
  ,ActiveX
  ,cyStrUtils
  ,cySysUtils
  ,cyWinUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyWinUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyWinUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TWindowsVersion', '( wvUnknown, wvWin31, wvWin95, wvWin98, wvWin'
   +'Me, wvWinNt3, wvWinNt4, wvWin2000, wvWinXP, wvWinVista, wvWin7, wvWin8, wvWin8_Or_Upper )');
 CL.AddDelphiFunction('Function ShellGetExtensionName( FileName : String) : String');
 CL.AddDelphiFunction('Function ShellGetIconIndex( FileName : String) : Integer');
 CL.AddDelphiFunction('Function ShellGetIconHandle( FileName : String) : HIcon');
 CL.AddDelphiFunction('Procedure ShellThreadCopy( App_Handle : THandle; fromFile : string; toFile : string)');
 CL.AddDelphiFunction('Procedure ShellThreadMove( App_Handle : THandle; fromFile : string; toFile : string)');
 CL.AddDelphiFunction('Procedure ShellRenameDir( DirFrom, DirTo : string)');
 CL.AddDelphiFunction('Function cyShellExecute( Operation, FileName, Parameters, Directory : String; ShowCmd : Integer) : Cardinal;');
 CL.AddDelphiFunction('Function ShellExecuteX( Operation, FileName, Parameters, Directory : String; ShowCmd : Integer) : Cardinal;');

 CL.AddDelphiFunction('Procedure cyShellExecute1( ExeFilename, Parameters, ApplicationName, ApplicationClass : String; Restore : Boolean);');
 CL.AddDelphiFunction('Procedure ShellExecuteAsModal( ExeFilename, ApplicationName, Directory : String)');
 CL.AddDelphiFunction('Procedure ShellExecuteExAsAdmin( hWnd : HWND; Filename : string; Parameters : string)');
 CL.AddDelphiFunction('Procedure RunasAdmin2( hWnd : HWND; Filename : string; Parameters : string)');

 CL.AddDelphiFunction('Function ShellExecuteEx( aFileName : string; const Parameters : string; const Directory : string; const WaitCloseCompletion : boolean) : Boolean');
 CL.AddDelphiFunction('Procedure RestoreAndSetForegroundWindow( Hnd : Integer)');
 CL.AddDelphiFunction('Function RemoveDuplicatedPathDelimiter( Str : String) : String');
 CL.AddDelphiFunction('Function cyFileTimeToDateTime( _FT : TFileTime) : TDateTime');
 CL.AddDelphiFunction('Function GetModificationDate( Filename : String) : TDateTime');
 CL.AddDelphiFunction('Function GetCreationDate( Filename : String) : TDateTime');
 CL.AddDelphiFunction('Function GetLastAccessDate( Filename : String) : TDateTime');
 CL.AddDelphiFunction('Function FileDelete( Filename : String) : Boolean');
 CL.AddDelphiFunction('Function FileIsOpen( Filename : string) : boolean');
 CL.AddDelphiFunction('Procedure FilesDelete( FromDirectory : String; Filter : ShortString)');
 CL.AddDelphiFunction('Function DirectoryDelete( Directory : String) : Boolean');
 CL.AddDelphiFunction('Function GetPrinters( PrintersList : TStrings) : Integer');
 CL.AddDelphiFunction('Procedure SetDefaultPrinter( PrinterName : String)');
 CL.AddDelphiFunction('Procedure ShowDefaultPrinterWindowProperties( FormParent_Handle : Integer)');
 CL.AddDelphiFunction('Function WinToDosPath( WinPathName : String) : String');
 CL.AddDelphiFunction('Function DosToWinPath( DosPathName : String) : String');
 CL.AddDelphiFunction('Function cyGetWindowsVersion : TWindowsVersion');
 CL.AddDelphiFunction('Function NTSetPrivilege( sPrivilege : string; bEnabled : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure WindowsShutDown( Restart : boolean)');
 CL.AddDelphiFunction('Procedure CreateShortCut( FileSrc, Parametres, FileLnk, Description, DossierDeTravail, FileIcon : string; NumIcone : integer)');
 CL.AddDelphiFunction('Procedure GetWindowsFonts( FontsList : TStrings)');
 CL.AddDelphiFunction('Function GetAvailableFilename( DesiredFileName : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure ShellExecute1_P( ExeFilename, Parameters, ApplicationName, ApplicationClass : String; Restore : Boolean);
Begin cyWinUtils.ShellExecute(ExeFilename, Parameters, ApplicationName, ApplicationClass, Restore); END;

(*----------------------------------------------------------------------------*)
Function ShellExecute_P( Operation, FileName, Parameters, Directory : String; ShowCmd : Integer) : Cardinal;
Begin Result := cyWinUtils.ShellExecute(Operation, FileName, Parameters, Directory, ShowCmd); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyWinUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ShellGetExtensionName, 'ShellGetExtensionName', cdRegister);
 S.RegisterDelphiFunction(@ShellGetIconIndex, 'ShellGetIconIndex', cdRegister);
 S.RegisterDelphiFunction(@ShellGetIconHandle, 'ShellGetIconHandle', cdRegister);
 S.RegisterDelphiFunction(@ShellThreadCopy, 'ShellThreadCopy', cdRegister);
 S.RegisterDelphiFunction(@ShellThreadMove, 'ShellThreadMove', cdRegister);
 S.RegisterDelphiFunction(@ShellRenameDir, 'ShellRenameDir', cdRegister);
 S.RegisterDelphiFunction(@ShellExecute, 'cyShellExecute', cdRegister);
 S.RegisterDelphiFunction(@ShellExecute1_P, 'cyShellExecute1', cdRegister);
 S.RegisterDelphiFunction(@ShellExecuteAsModal, 'ShellExecuteAsModal', cdRegister);
 S.RegisterDelphiFunction(@ShellExecuteExAsAdmin, 'ShellExecuteExAsAdmin', cdRegister);
 S.RegisterDelphiFunction(@ShellExecuteExAsAdmin, 'RunAsAdmin2', cdRegister);
 S.RegisterDelphiFunction(@ShellExecute, 'ShellExecuteX', cdRegister);

 S.RegisterDelphiFunction(@ShellExecuteEx, 'ShellExecuteEx', cdRegister);
 S.RegisterDelphiFunction(@RestoreAndSetForegroundWindow, 'RestoreAndSetForegroundWindow', cdRegister);
 S.RegisterDelphiFunction(@RemoveDuplicatedPathDelimiter, 'RemoveDuplicatedPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToDateTime, 'cyFileTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@GetModificationDate, 'GetModificationDate', cdRegister);
 S.RegisterDelphiFunction(@GetCreationDate, 'GetCreationDate', cdRegister);
 S.RegisterDelphiFunction(@GetLastAccessDate, 'GetLastAccessDate', cdRegister);
 S.RegisterDelphiFunction(@FileDelete, 'FileDelete', cdRegister);
 S.RegisterDelphiFunction(@FileIsOpen, 'FileIsOpen', cdRegister);
 S.RegisterDelphiFunction(@FilesDelete, 'FilesDelete', cdRegister);
 S.RegisterDelphiFunction(@DirectoryDelete, 'DirectoryDelete', cdRegister);
 S.RegisterDelphiFunction(@GetPrinters, 'GetPrinters', cdRegister);
 S.RegisterDelphiFunction(@SetDefaultPrinter, 'SetDefaultPrinter', cdRegister);
 S.RegisterDelphiFunction(@ShowDefaultPrinterWindowProperties, 'ShowDefaultPrinterWindowProperties', cdRegister);
 S.RegisterDelphiFunction(@WinToDosPath, 'WinToDosPath', cdRegister);
 S.RegisterDelphiFunction(@DosToWinPath, 'DosToWinPath', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsVersion, 'cyGetWindowsVersion', cdRegister);
 S.RegisterDelphiFunction(@NTSetPrivilege, 'NTSetPrivilege', cdRegister);
 S.RegisterDelphiFunction(@WindowsShutDown, 'WindowsShutDown', cdRegister);
 S.RegisterDelphiFunction(@CreateShortCut, 'CreateShortCut', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsFonts, 'GetWindowsFonts', cdRegister);
 S.RegisterDelphiFunction(@GetAvailableFilename, 'GetAvailableFilename', cdRegister);
end;



{ TPSImport_cyWinUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyWinUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyWinUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyWinUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyWinUtils(ri);
  RIRegister_cyWinUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
