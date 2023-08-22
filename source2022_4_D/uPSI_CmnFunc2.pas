unit uPSI_CmnFunc2;
{
   inno setup  with uPSI_CmnFunc1
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
  TPSImport_CmnFunc2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOneShotTimer(CL: TPSPascalCompiler);
procedure SIRegister_CmnFunc2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CmnFunc2_Routines(S: TPSExec);
procedure RIRegister_TOneShotTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_CmnFunc2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,CmnFunc2
  ;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CmnFunc2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOneShotTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TOneShotTimer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TOneShotTimer') do begin
    RegisterMethod('Function Expired : Boolean');
    RegisterMethod('Procedure SleepUntilExpired');
    RegisterMethod('Procedure Start( const Timeout : Cardinal)');
    RegisterMethod('Function TimeElapsed : Cardinal');
    RegisterMethod('Function TimeRemaining : Cardinal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CmnFunc2(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('NEWREGSTR_PATH_SETUP','String').SetString( 'Software\Microsoft\Windows\CurrentVersion');
 CL.AddConstantN('NEWREGSTR_PATH_EXPLORER','String').SetString( NEWREGSTR_PATH_SETUP + '\Explorer');
 CL.AddConstantN('NEWREGSTR_PATH_SPECIAL_FOLDERS','String').SetString( NEWREGSTR_PATH_EXPLORER + '\Shell Folders');
 CL.AddConstantN('NEWREGSTR_PATH_UNINSTALL','String').SetString( NEWREGSTR_PATH_SETUP + '\Uninstall');
 CL.AddConstantN('NEWREGSTR_VAL_UNINSTALLER_DISPLAYNAME','String').SetString( 'DisplayName');
 CL.AddConstantN('NEWREGSTR_VAL_UNINSTALLER_COMMANDLINE','String').SetString( 'UninstallString');
 CL.AddConstantN('KEY_WOW64_64KEY','LongWord').SetUInt( $0100);
  //CL.AddTypeS('PLeadByteSet', '^TLeadByteSet // will not work');
  CL.AddTypeS('TLeadByteSet', 'set of Char');
  SIRegister_TOneShotTimer(CL);
  CL.AddTypeS('TRegView', '( rvDefault, rv32Bit, rv64Bit )');
 CL.AddConstantN('RegViews64Bit','LongInt').Value.ts32 := ord(rv64Bit);
 CL.AddDelphiFunction('Function NewFileExists( const Name : String) : Boolean');
 CL.AddDelphiFunction('Function inDirExists( const Name : String) : Boolean');
 CL.AddDelphiFunction('Function FileOrDirExists( const Name : String) : Boolean');
 CL.AddDelphiFunction('Function IsDirectoryAndNotReparsePoint( const Name : String) : Boolean');
 CL.AddDelphiFunction('Function GetIniString( const Section, Key : String; Default : String; const Filename : String) : String');
 CL.AddDelphiFunction('Function GetIniInt( const Section, Key : String; const Default, Min, Max : Longint; const Filename : String) : Longint');
 CL.AddDelphiFunction('Function GetIniBool( const Section, Key : String; const Default : Boolean; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Function IniKeyExists( const Section, Key, Filename : String) : Boolean');
 CL.AddDelphiFunction('Function IsIniSectionEmpty( const Section, Filename : String) : Boolean');
 CL.AddDelphiFunction('Function SetIniString( const Section, Key, Value, Filename : String) : Boolean');
 CL.AddDelphiFunction('Function SetIniInt( const Section, Key : String; const Value : Longint; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Function SetIniBool( const Section, Key : String; const Value : Boolean; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Procedure DeleteIniEntry( const Section, Key, Filename : String)');
 CL.AddDelphiFunction('Procedure DeleteIniSection( const Section, Filename : String)');
 CL.AddDelphiFunction('Function GetEnv( const EnvVar : String) : String');
 CL.AddDelphiFunction('Function GetCmdTail : String');
 CL.AddDelphiFunction('Function GetCmdTailEx( StartIndex : Integer) : String');
 CL.AddDelphiFunction('Function NewParamCount : Integer');
 CL.AddDelphiFunction('Function NewParamStr( Index : Integer) : string');
 CL.AddDelphiFunction('Function AddQuotes( const S : String) : String');
 CL.AddDelphiFunction('Function RemoveQuotes( const S : String) : String');
 CL.AddDelphiFunction('Function inGetShortName( const LongName : String) : String');
 CL.AddDelphiFunction('Function inGetWinDir : String');
 CL.AddDelphiFunction('Function inGetSystemDir : String');
 CL.AddDelphiFunction('Function GetSysWow64Dir : String');
 CL.AddDelphiFunction('Function GetSysNativeDir( const IsWin64 : Boolean) : String');
 CL.AddDelphiFunction('Function inGetTempDir : String');
 CL.AddDelphiFunction('Function StringChange( var S : String; const FromStr, ToStr : String) : Integer');
 CL.AddDelphiFunction('Function StringChangeEx( var S : String; const FromStr, ToStr : String; const SupportDBCS : Boolean) : Integer');
 CL.AddDelphiFunction('Function AdjustLength( var S : String; const Res : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function UsingWinNT : Boolean');
 CL.AddDelphiFunction('Function ConvertConstPercentStr( var S : String) : Boolean');
 CL.AddDelphiFunction('Function ConvertPercentStr( var S : String) : Boolean');
 CL.AddDelphiFunction('Function ConstPos( const Ch : Char; const S : String) : Integer');
 CL.AddDelphiFunction('Function SkipPastConst( const S : String; const Start : Integer) : Integer');
 CL.AddDelphiFunction('Function RegQueryStringValue( H : HKEY; Name : PChar; var ResultStr : String) : Boolean');
 CL.AddDelphiFunction('Function RegQueryMultiStringValue( H : HKEY; Name : PChar; var ResultStr : String) : Boolean');
 CL.AddDelphiFunction('Function RegValueExists( H : HKEY; Name : PChar) : Boolean');
 CL.AddDelphiFunction('Function RegCreateKeyExView( const RegView : TRegView; hKey : HKEY; lpSubKey : PChar; Reserved : DWORD; lpClass : PChar; dwOptions : DWORD; samDesired : REGSAM; lpSecurityAttributes : TObject;'
                         + 'var phkResult : HKEY; lpdwDisposition : DWORD) : Longint');
 CL.AddDelphiFunction('Function RegOpenKeyExView( const RegView : TRegView; hKey : HKEY; lpSubKey : PChar; ulOptions : DWORD; samDesired : REGSAM; var phkResult : HKEY) : Longint');
 CL.AddDelphiFunction('Function RegDeleteKeyView( const RegView : TRegView; const Key : HKEY; const Name : PChar) : Longint');
 CL.AddDelphiFunction('Function RegDeleteKeyIncludingSubkeys( const RegView : TRegView; const Key : HKEY; const Name : PChar) : Longint');
 CL.AddDelphiFunction('Function RegDeleteKeyIfEmpty( const RegView : TRegView; const RootKey : HKEY; const SubkeyName : PChar) : Longint');
 CL.AddDelphiFunction('Function GetShellFolderPath( const FolderID : Integer) : String');
 CL.AddDelphiFunction('Function IsAdminLoggedOn : Boolean');
 CL.AddDelphiFunction('Function IsPowerUserLoggedOn : Boolean');
 CL.AddDelphiFunction('Function IsMultiByteString( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function FontExists( const FaceName : String) : Boolean');
 //CL.AddDelphiFunction('Procedure FreeAndNil( var Obj)');
 CL.AddDelphiFunction('Function SafeLoadLibrary( const Filename : String; ErrorMode : UINT) : HMODULE');
 CL.AddDelphiFunction('Function GetUILanguage : LANGID');
 CL.AddDelphiFunction('Function RemoveAccelChar( const S : String) : String');
 CL.AddDelphiFunction('Function GetTextWidth( const DC : HDC; S : String; const Prefix : Boolean) : Integer');
 CL.AddDelphiFunction('Function AddPeriod( const S : String) : String');
 CL.AddDelphiFunction('Function GetExceptMessage : String');
 CL.AddDelphiFunction('Function GetPreferredUIFont : String');
 CL.AddDelphiFunction('Function IsWildcard( const Pattern : String) : Boolean');
 CL.AddDelphiFunction('Function WildcardMatch( const Text, Pattern : PChar) : Boolean');
 CL.AddDelphiFunction('Function IntMax( const A, B : Integer) : Integer');
 CL.AddDelphiFunction('Function Win32ErrorString( ErrorCode : Integer) : String');
 CL.AddDelphiFunction('Procedure GetLeadBytes( var ALeadBytes : TLeadByteSet)');
 CL.AddDelphiFunction('Function inCompareMem( P1, P2 : TObject; Length : Integer) : Boolean');
 CL.AddDelphiFunction('Function DeleteDirTree( const Dir : String) : Boolean');
 CL.AddDelphiFunction('Function SetNTFSCompression( const FileOrDir : String; Compress : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure AddToWindowMessageFilterEx( const Wnd : HWND; const Msg : UINT)');
 // CL.AddTypeS('TSysCharSet', 'set of AnsiChar');
 CL.AddDelphiFunction('Function inCharInSet( C : Char; const CharSet : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('Function ShutdownBlockReasonCreate( Wnd : HWND; const Reason : String) : Boolean');
 CL.AddDelphiFunction('Function ShutdownBlockReasonDestroy( Wnd : HWND) : Boolean');
 CL.AddDelphiFunction('Function TryStrToBoolean( const S : String; var BoolResult : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure WaitMessageWithTimeout( const Milliseconds : DWORD)');
 CL.AddDelphiFunction('Function MoveFileReplace( const ExistingFileName, NewFileName : String) : Boolean');
 CL.AddDelphiFunction('Procedure TryEnableAutoCompleteFileSystem( Wnd : HWND)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_CmnFunc2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NewFileExists, 'NewFileExists', cdRegister);
 S.RegisterDelphiFunction(@DirExists, 'inDirExists', cdRegister);
 S.RegisterDelphiFunction(@FileOrDirExists, 'FileOrDirExists', cdRegister);
 S.RegisterDelphiFunction(@IsDirectoryAndNotReparsePoint, 'IsDirectoryAndNotReparsePoint', cdRegister);
 S.RegisterDelphiFunction(@GetIniString, 'GetIniString', cdRegister);
 S.RegisterDelphiFunction(@GetIniInt, 'GetIniInt', cdRegister);
 S.RegisterDelphiFunction(@GetIniBool, 'GetIniBool', cdRegister);
 S.RegisterDelphiFunction(@IniKeyExists, 'IniKeyExists', cdRegister);
 S.RegisterDelphiFunction(@IsIniSectionEmpty, 'IsIniSectionEmpty', cdRegister);
 S.RegisterDelphiFunction(@SetIniString, 'SetIniString', cdRegister);
 S.RegisterDelphiFunction(@SetIniInt, 'SetIniInt', cdRegister);
 S.RegisterDelphiFunction(@SetIniBool, 'SetIniBool', cdRegister);
 S.RegisterDelphiFunction(@DeleteIniEntry, 'DeleteIniEntry', cdRegister);
 S.RegisterDelphiFunction(@DeleteIniSection, 'DeleteIniSection', cdRegister);
 S.RegisterDelphiFunction(@GetEnv, 'GetEnv', cdRegister);
 S.RegisterDelphiFunction(@GetCmdTail, 'GetCmdTail', cdRegister);
 S.RegisterDelphiFunction(@GetCmdTailEx, 'GetCmdTailEx', cdRegister);
 S.RegisterDelphiFunction(@NewParamCount, 'NewParamCount', cdRegister);
 S.RegisterDelphiFunction(@NewParamStr, 'NewParamStr', cdRegister);
 S.RegisterDelphiFunction(@AddQuotes, 'AddQuotes', cdRegister);
 S.RegisterDelphiFunction(@RemoveQuotes, 'RemoveQuotes', cdRegister);
 S.RegisterDelphiFunction(@GetShortName, 'inGetShortName', cdRegister);
 S.RegisterDelphiFunction(@GetWinDir, 'inGetWinDir', cdRegister);
 S.RegisterDelphiFunction(@GetSystemDir, 'inGetSystemDir', cdRegister);
 S.RegisterDelphiFunction(@GetSysWow64Dir, 'GetSysWow64Dir', cdRegister);
 S.RegisterDelphiFunction(@GetSysNativeDir, 'GetSysNativeDir', cdRegister);
 S.RegisterDelphiFunction(@GetTempDir, 'inGetTempDir', cdRegister);
 S.RegisterDelphiFunction(@StringChange, 'StringChange', cdRegister);
 S.RegisterDelphiFunction(@StringChangeEx, 'StringChangeEx', cdRegister);
 S.RegisterDelphiFunction(@AdjustLength, 'AdjustLength', cdRegister);
 S.RegisterDelphiFunction(@UsingWinNT, 'UsingWinNT', cdRegister);
 S.RegisterDelphiFunction(@ConvertConstPercentStr, 'ConvertConstPercentStr', cdRegister);
 S.RegisterDelphiFunction(@ConvertPercentStr, 'ConvertPercentStr', cdRegister);
 S.RegisterDelphiFunction(@ConstPos, 'ConstPos', cdRegister);
 S.RegisterDelphiFunction(@SkipPastConst, 'SkipPastConst', cdRegister);
 S.RegisterDelphiFunction(@RegQueryStringValue, 'RegQueryStringValue', cdRegister);
 S.RegisterDelphiFunction(@RegQueryMultiStringValue, 'RegQueryMultiStringValue', cdRegister);
 S.RegisterDelphiFunction(@RegValueExists, 'RegValueExists', cdRegister);
 S.RegisterDelphiFunction(@RegCreateKeyExView, 'RegCreateKeyExView', cdRegister);
 S.RegisterDelphiFunction(@RegOpenKeyExView, 'RegOpenKeyExView', cdRegister);
 S.RegisterDelphiFunction(@RegDeleteKeyView, 'RegDeleteKeyView', cdRegister);
 S.RegisterDelphiFunction(@RegDeleteKeyIncludingSubkeys, 'RegDeleteKeyIncludingSubkeys', cdRegister);
 S.RegisterDelphiFunction(@RegDeleteKeyIfEmpty, 'RegDeleteKeyIfEmpty', cdRegister);
 S.RegisterDelphiFunction(@GetShellFolderPath, 'GetShellFolderPath', cdRegister);
 S.RegisterDelphiFunction(@IsAdminLoggedOn, 'IsAdminLoggedOn', cdRegister);
 S.RegisterDelphiFunction(@IsPowerUserLoggedOn, 'IsPowerUserLoggedOn', cdRegister);
 S.RegisterDelphiFunction(@IsMultiByteString, 'IsMultiByteString', cdRegister);
 S.RegisterDelphiFunction(@FontExists, 'FontExists', cdRegister);
 //S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNil', cdRegister);
 S.RegisterDelphiFunction(@SafeLoadLibrary, 'SafeLoadLibrary', cdRegister);
 S.RegisterDelphiFunction(@GetUILanguage, 'GetUILanguage', cdRegister);
 S.RegisterDelphiFunction(@RemoveAccelChar, 'RemoveAccelChar', cdRegister);
 S.RegisterDelphiFunction(@GetTextWidth, 'GetTextWidth', cdRegister);
 S.RegisterDelphiFunction(@AddPeriod, 'AddPeriod', cdRegister);
 S.RegisterDelphiFunction(@GetExceptMessage, 'GetExceptMessage', cdRegister);
 S.RegisterDelphiFunction(@GetPreferredUIFont, 'GetPreferredUIFont', cdRegister);
 S.RegisterDelphiFunction(@IsWildcard, 'IsWildcard', cdRegister);
 S.RegisterDelphiFunction(@WildcardMatch, 'WildcardMatch', cdRegister);
 S.RegisterDelphiFunction(@IntMax, 'IntMax', cdRegister);
 S.RegisterDelphiFunction(@Win32ErrorString, 'Win32ErrorString', cdRegister);
 S.RegisterDelphiFunction(@GetLeadBytes, 'GetLeadBytes', cdRegister);
 S.RegisterDelphiFunction(@CompareMem, 'inCompareMem', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirTree, 'DeleteDirTree', cdRegister);
 S.RegisterDelphiFunction(@SetNTFSCompression, 'SetNTFSCompression', cdRegister);
 S.RegisterDelphiFunction(@AddToWindowMessageFilterEx, 'AddToWindowMessageFilterEx', cdRegister);
 S.RegisterDelphiFunction(@CharInSet, 'inCharInSet', cdRegister);
 S.RegisterDelphiFunction(@ShutdownBlockReasonCreate, 'ShutdownBlockReasonCreate', cdRegister);
 S.RegisterDelphiFunction(@ShutdownBlockReasonDestroy, 'ShutdownBlockReasonDestroy', cdRegister);
 S.RegisterDelphiFunction(@TryStrToBoolean, 'TryStrToBoolean', cdRegister);
 S.RegisterDelphiFunction(@WaitMessageWithTimeout, 'WaitMessageWithTimeout', cdRegister);
 S.RegisterDelphiFunction(@MoveFileReplace, 'MoveFileReplace', cdRegister);
 S.RegisterDelphiFunction(@TryEnableAutoCompleteFileSystem, 'TryEnableAutoCompleteFileSystem', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOneShotTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOneShotTimer) do begin
    RegisterMethod(@TOneShotTimer.Expired, 'Expired');
    RegisterMethod(@TOneShotTimer.SleepUntilExpired, 'SleepUntilExpired');
    RegisterMethod(@TOneShotTimer.Start, 'Start');
    RegisterMethod(@TOneShotTimer.TimeElapsed, 'TimeElapsed');
    RegisterMethod(@TOneShotTimer.TimeRemaining, 'TimeRemaining');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CmnFunc2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOneShotTimer(CL);
end;

 
 
{ TPSImport_CmnFunc2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CmnFunc2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CmnFunc2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CmnFunc2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CmnFunc2(ri);
  RIRegister_CmnFunc2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
