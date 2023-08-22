unit uPSI_ovcBidi;
{
    lay out shout
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
  TPSImport_ovcBidi = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ovcBidi(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ovcBidi_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,ovcBidi
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcBidi]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcBidi(CL: TPSPascalCompiler);
begin

{ _OSVERSIONINFOA = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar; { Maintenance AnsiString for PSS usage }
  {end;
  tagHW_PROFILE_INFOA = packed record
    dwDockInfo: DWORD;
    szHwProfileGuid: packed array[0..39-1] of AnsiChar;
    szHwProfileName: packed array[0..80-1] of AnsiChar;
  end;}

  CL.AddTypeS('_OSVERSIONINFOA', 'record dwOSVersionInfoSize: DWORD; dwMajorVersion: DWORD; dwMinorVersion: DWORD; dwBuildNumber: DWORD; '+
              'dwPlatformId: DWORD; szCSDVersion: array[0..127] of Char; end');

  CL.AddTypeS('tagHW_PROFILE_INFOA', 'record dwDockInfo: DWORD; szHwProfileGuid: array[0..39-1] of Char; '+
              'szHwProfileName: array[0..80-1] of Char; end');

  CL.AddTypeS('tagHW_PROFILE_INFO', 'tagHW_PROFILE_INFOA');
  CL.AddTypeS('THWProfileInfoA', 'tagHW_PROFILE_INFOA');
  CL.AddTypeS('THWProfileInfo', 'THWProfileInfoA');
  CL.AddTypeS('HW_PROFILE_INFOA', 'tagHW_PROFILE_INFOA');
  CL.AddTypeS('HW_PROFILE_INFO', 'HW_PROFILE_INFOA');

  CL.AddTypeS('TOSVersionInfoA', '_OSVERSIONINFOA');
  CL.AddTypeS('TOSVersionInfo', 'TOSVersionInfoA');

 CL.AddConstantN('WS_EX_RIGHT','LongWord').SetUInt( $00001000);
 CL.AddConstantN('WS_EX_LEFT','LongWord').SetUInt( $00000000);
 CL.AddConstantN('WS_EX_RTLREADING','LongWord').SetUInt( $00002000);
 CL.AddConstantN('WS_EX_LTRREADING','LongWord').SetUInt( $00000000);
 CL.AddConstantN('WS_EX_LEFTSCROLLBAR','LongWord').SetUInt( $00004000);
 CL.AddConstantN('WS_EX_RIGHTSCROLLBAR','LongWord').SetUInt( $00000000);
 CL.AddDelphiFunction('Function SetProcessDefaultLayout( dwDefaultLayout : DWORD) : BOOL');
 CL.AddConstantN('LAYOUT_RTL','LongWord').SetUInt( $00000001);
 CL.AddConstantN('LAYOUT_BTT','LongWord').SetUInt( $00000002);
 CL.AddConstantN('LAYOUT_VBH','LongWord').SetUInt( $00000004);
 CL.AddConstantN('LAYOUT_BITMAPORIENTATIONPRESERVED','LongWord').SetUInt( $00000008);
 CL.AddConstantN('NOMIRRORBITMAP','LongWord').SetUInt( DWORD ( $80000000 ));
 CL.AddDelphiFunction('Function SetLayout( dc : HDC; dwLayout : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GetLayout( dc : hdc) : DWORD');
 CL.AddDelphiFunction('Function IsBidi : Boolean');
 CL.AddDelphiFunction('Function GetCurrentHwProfile( var lpHwProfileInfo : THWProfileInfo) : BOOL');
 CL.AddDelphiFunction('Function GetVersionEx( var lpVersionInformation : TOSVersionInfo) : BOOL');
 CL.AddDelphiFunction('Function SetPriorityClass( hProcess : THandle; dwPriorityClass : DWORD) : BOOL');
 CL.AddDelphiFunction('Function GetPriorityClass( hProcess : THandle) : DWORD');

  CL.AddDelphiFunction('Function OpenClipboard( hWndNewOwner : HWND) : BOOL');
 CL.AddDelphiFunction('Function CloseClipboard : BOOL');
 CL.AddDelphiFunction('Function GetClipboardSequenceNumber : DWORD');
 CL.AddDelphiFunction('Function GetClipboardOwner : HWND');
 CL.AddDelphiFunction('Function SetClipboardViewer( hWndNewViewer : HWND) : HWND');
 CL.AddDelphiFunction('Function GetClipboardViewer : HWND');
 CL.AddDelphiFunction('Function ChangeClipboardChain( hWndRemove, hWndNewNext : HWND) : BOOL');
 CL.AddDelphiFunction('Function SetClipboardData( uFormat : UINT; hMem : THandle) : THandle');
 CL.AddDelphiFunction('Function GetClipboardData( uFormat : UINT) : THandle');
 CL.AddDelphiFunction('Function RegisterClipboardFormat( lpszFormat : PChar) : UINT');
 CL.AddDelphiFunction('Function CountClipboardFormats : Integer');
 CL.AddDelphiFunction('Function EnumClipboardFormats( format : UINT) : UINT');
 CL.AddDelphiFunction('Function GetClipboardFormatName( format : UINT; lpszFormatName : PChar; cchMaxCount : Integer) : Integer');
 CL.AddDelphiFunction('Function EmptyClipboard : BOOL');
 CL.AddDelphiFunction('Function IsClipboardFormatAvailable( format : UINT) : BOOL');
  CL.AddDelphiFunction('Function GetPriorityClipboardFormat( var paFormatPriorityList, cFormats : Integer) : Integer');
 CL.AddDelphiFunction('Function GetOpenClipboardWindow : HWND');
 CL.AddDelphiFunction('Function EndDialog( hDlg : HWND; nResult : Integer) : BOOL');
 CL.AddDelphiFunction('Function GetDlgItem( hDlg : HWND; nIDDlgItem : Integer) : HWND');
 CL.AddDelphiFunction('Function SetDlgItemInt( hDlg : HWND; nIDDlgItem : Integer; uValue : UINT; bSigned : BOOL) : BOOL');
 CL.AddDelphiFunction('Function GetDlgItemInt( hDlg : HWND; nIDDlgItem : Integer; var lpTranslated : BOOL; bSigned : BOOL) : UINT');
 CL.AddDelphiFunction('Function SetDlgItemText( hDlg : HWND; nIDDlgItem : Integer; lpString : PChar) : BOOL');
 CL.AddDelphiFunction('Function SendDlgItemMessage( hDlg : HWND; nIDDlgItem : Integer; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : Longint');
 CL.AddDelphiFunction('Function CheckDlgButton( hDlg : HWND; nIDButton : Integer; uCheck : UINT) : BOOL');
 CL.AddDelphiFunction('Function CheckRadioButton( hDlg : HWND; nIDFirstButton, nIDLastButton, nIDCheckButton : Integer) : BOOL');
 CL.AddDelphiFunction('Function IsDlgButtonChecked( hDlg : HWND; nIDButton : Integer) : UINT');
 //CL.AddDelphiFunction('Function DialogBox( hInstance : HINST; lpTemplate : PChar; hWndParent : HWND; lpDialogFunc : TFNDlgProc) : Integer');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcBidi_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetProcessDefaultLayout, 'SetProcessDefaultLayout', CdStdCall);
 S.RegisterDelphiFunction(@SetLayout, 'SetLayout', CdStdCall);
 S.RegisterDelphiFunction(@GetLayout, 'GetLayout', CdStdCall);
 S.RegisterDelphiFunction(@IsBidi, 'IsBidi', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentHwProfile, 'GetCurrentHwProfile', CdStdCall);
 S.RegisterDelphiFunction(@GetVersionEx, 'GetVersionEx', CdStdCall);
  S.RegisterDelphiFunction(@SetPriorityClass, 'SetPriorityClass', CdStdCall);
 S.RegisterDelphiFunction(@GetPriorityClass, 'GetPriorityClass', CdStdCall);
 S.RegisterDelphiFunction(@OpenClipboard, 'OpenClipboard', CdStdCall);
 S.RegisterDelphiFunction(@CloseClipboard, 'CloseClipboard', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardSequenceNumber, 'GetClipboardSequenceNumber', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardOwner, 'GetClipboardOwner', CdStdCall);
 S.RegisterDelphiFunction(@SetClipboardViewer, 'SetClipboardViewer', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardViewer, 'GetClipboardViewer', CdStdCall);
 S.RegisterDelphiFunction(@ChangeClipboardChain, 'ChangeClipboardChain', CdStdCall);
 S.RegisterDelphiFunction(@SetClipboardData, 'SetClipboardData', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardData, 'GetClipboardData', CdStdCall);
 S.RegisterDelphiFunction(@RegisterClipboardFormat, 'RegisterClipboardFormat', CdStdCall);
 S.RegisterDelphiFunction(@RegisterClipboardFormatA, 'RegisterClipboardFormatA', CdStdCall);
 S.RegisterDelphiFunction(@RegisterClipboardFormatW, 'RegisterClipboardFormatW', CdStdCall);
 S.RegisterDelphiFunction(@CountClipboardFormats, 'CountClipboardFormats', CdStdCall);
 S.RegisterDelphiFunction(@EnumClipboardFormats, 'EnumClipboardFormats', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardFormatName, 'GetClipboardFormatName', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardFormatNameA, 'GetClipboardFormatNameA', CdStdCall);
 S.RegisterDelphiFunction(@GetClipboardFormatNameW, 'GetClipboardFormatNameW', CdStdCall);
 S.RegisterDelphiFunction(@EmptyClipboard, 'EmptyClipboard', CdStdCall);
 S.RegisterDelphiFunction(@IsClipboardFormatAvailable, 'IsClipboardFormatAvailable', CdStdCall);
 S.RegisterDelphiFunction(@GetPriorityClipboardFormat, 'GetPriorityClipboardFormat', CdStdCall);
 S.RegisterDelphiFunction(@GetOpenClipboardWindow, 'GetOpenClipboardWindow', CdStdCall);
  S.RegisterDelphiFunction(@EndDialog, 'EndDialog', CdStdCall);
 S.RegisterDelphiFunction(@GetDlgItem, 'GetDlgItem', CdStdCall);
 S.RegisterDelphiFunction(@SetDlgItemInt, 'SetDlgItemInt', CdStdCall);
 S.RegisterDelphiFunction(@GetDlgItemInt, 'GetDlgItemInt', CdStdCall);
 S.RegisterDelphiFunction(@SetDlgItemText, 'SetDlgItemText', CdStdCall);
 S.RegisterDelphiFunction(@GetDlgItemText, 'GetDlgItemText', CdStdCall);
 S.RegisterDelphiFunction(@CheckDlgButton, 'CheckDlgButton', CdStdCall);
 S.RegisterDelphiFunction(@CheckRadioButton, 'CheckRadioButton', CdStdCall);
 S.RegisterDelphiFunction(@IsDlgButtonChecked, 'IsDlgButtonChecked', CdStdCall);
 S.RegisterDelphiFunction(@SendDlgItemMessage, 'SendDlgItemMessage', CdStdCall);


end;

 
 
{ TPSImport_ovcBidi }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcBidi.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcBidi(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcBidi.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ovcBidi(ri);
  RIRegister_ovcBidi_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
