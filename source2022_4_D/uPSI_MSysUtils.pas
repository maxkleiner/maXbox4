unit uPSI_MSysUtils;
{
  in order to get an bass.dll clone
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
  TPSImport_MSysUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MSysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MSysUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,CommCtrl
  ,ShellApi
  ,ShlObj
  ,MSysUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MSysUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MSysUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure HideTaskBarButton( hWindow : HWND)');
 CL.AddDelphiFunction('Function msLoadStr( ID : Integer) : String');
 CL.AddDelphiFunction('Function msFormat( fmt : String; params : array of const) : String');
 CL.AddDelphiFunction('Function msFileExists( const FileName : String) : Boolean');
 CL.AddDelphiFunction('Function msIntToStr( Int : Int64) : String');
 CL.AddDelphiFunction('Function msStrPas( const Str : PChar) : String');
 CL.AddDelphiFunction('Function msRenameFile( const OldName, NewName : String) : Boolean');
 CL.AddDelphiFunction('Function CutFileName( s : String) : String');
 CL.AddDelphiFunction('Function GetVersionInfo( var VersionString : String) : DWORD');
 CL.AddDelphiFunction('Function FormatTime( t : Cardinal) : String');
 CL.AddDelphiFunction('Function msCreateDir( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function SetAutoRun( NeedAutoRun : Boolean; AppName : String) : Boolean');
 CL.AddDelphiFunction('Function SetTreeViewStyle( const hTV : HWND; dwNewStyle : dword) : DWORD');
 CL.AddDelphiFunction('Function msStrLen( Str : PChar) : Integer');
 CL.AddDelphiFunction('Function msDirectoryExists( const Directory : String) : Boolean');
 CL.AddDelphiFunction('Function GetFolder( hWnd : hWnd; RootDir : Integer; Caption : String) : String');
 CL.AddDelphiFunction('Function SetBlendWindow( hWnd : HWND; AlphaBlend : Byte) : LongBool');
 CL.AddDelphiFunction('Function EditWindowProc( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Procedure SetEditWndProc( hWnd : HWND; ptr : TObject)');
 CL.AddDelphiFunction('Function GetTextFromFile( Filename : String) : string');
 CL.AddDelphiFunction('Function IsTopMost( hWnd : HWND) : Bool');
 CL.AddDelphiFunction('Function msStrToIntDef( const s : String; const i : Integer) : Integer');
 CL.AddDelphiFunction('Function msStrToInt( s : String) : Integer');
 CL.AddDelphiFunction('Function GetItemText( hDlg : THandle; ID : DWORD) : String');
 CL.AddConstantN('LWA_ALPHA','LongWord').SetUInt( $00000002);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_MSysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HideTaskBarButton, 'HideTaskBarButton', cdRegister);
 S.RegisterDelphiFunction(@LoadStr, 'msLoadStr', cdRegister);
 S.RegisterDelphiFunction(@Format, 'msFormat', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'msFileExists', cdRegister);
 S.RegisterDelphiFunction(@IntToStr, 'msIntToStr', cdRegister);
 S.RegisterDelphiFunction(@StrPas, 'msStrPas', cdRegister);
 S.RegisterDelphiFunction(@RenameFile, 'msRenameFile', cdRegister);
 S.RegisterDelphiFunction(@CutFileName, 'CutFileName', cdRegister);
 S.RegisterDelphiFunction(@GetVersionInfo, 'GetVersionInfo', cdRegister);
 S.RegisterDelphiFunction(@FormatTime, 'FormatTime', cdRegister);
 S.RegisterDelphiFunction(@CreateDir, 'msCreateDir', cdRegister);
 S.RegisterDelphiFunction(@SetAutoRun, 'SetAutoRun', cdRegister);
 S.RegisterDelphiFunction(@SetTreeViewStyle, 'SetTreeViewStyle', cdRegister);
 S.RegisterDelphiFunction(@StrLen, 'msStrLen', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'msDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@GetFolder, 'GetFolder', cdRegister);
 S.RegisterDelphiFunction(@SetBlendWindow, 'SetBlendWindow', cdRegister);
 S.RegisterDelphiFunction(@EditWindowProc, 'EditWindowProc', CdStdCall);
 S.RegisterDelphiFunction(@SetEditWndProc, 'SetEditWndProc', cdRegister);
 S.RegisterDelphiFunction(@GetTextFromFile, 'GetTextFromFile', cdRegister);
 S.RegisterDelphiFunction(@IsTopMost, 'IsTopMost', cdRegister);
 S.RegisterDelphiFunction(@StrToIntDef, 'msStrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@StrToInt, 'msStrToInt', cdRegister);
 S.RegisterDelphiFunction(@GetItemText, 'GetItemText', cdRegister);
end;

 
 
{ TPSImport_MSysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MSysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MSysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MSysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_MSysUtils(ri);
  RIRegister_MSysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
