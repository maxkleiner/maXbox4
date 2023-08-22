unit uPSI_JvFunctions;
{
   JEDI The Original Code is: JvFunctions.PAS, released on 2001-02-28.
   procedure ConvertImage(source, destination: string);  by max


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
  TPSImport_JvFunctions = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvFunctions(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvFunctions_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // Windows
  Graphics,
  //,Messages
  //,Controls
  //,ComCtrls
  //,ShellApi
  //,ImgList
  Types,
  JvFunctions_max
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFunctions]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFunctions(CL: TPSPascalCompiler);
begin
   CL.AddTypeS('HICON','LongWord');
   CL.AddTypeS('HRGN','LongWord');

 CL.AddDelphiFunction('Function IconToBitmap( Ico : HICON) : TBitmap');
 CL.AddDelphiFunction('Function IconToBitmap2( Ico : HICON; Size : Integer; TransparentColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Function IconToBitmap3( Ico : HICON; Size : Integer; TransparentColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Function OpenObject( Value : PChar) : Boolean;');
 CL.AddDelphiFunction('Function OpenObject1( Value : string) : Boolean;');
 CL.AddDelphiFunction('Procedure RaiseLastWin32;');
 CL.AddDelphiFunction('Procedure RaiseLastWin321( Text : string);');
 CL.AddDelphiFunction('Procedure PError( Text : string)');
 CL.AddDelphiFunction('Procedure RGBToHSV( r, g, b : Integer; var h, s, v : Integer)');
 CL.AddDelphiFunction('Function GetFileVersion( const AFilename : string) : Cardinal');
 CL.AddDelphiFunction('Function GetShellVersion : Cardinal');
 CL.AddDelphiFunction('Procedure SetWallpaper( Path : string);');
 CL.AddDelphiFunction('Function CaptureScreen : TBitmap;');
 CL.AddDelphiFunction('Function CaptureScreen1( Rec : TRect) : TBitmap;');
 CL.AddDelphiFunction('procedure CaptureScreenPNG(vname: string);');
 CL.AddDelphiFunction('procedure CaptureScreenFormat(vname: string; vextension: string);');
 CL.AddDelphiFunction('Procedure OpenCdDrive');
 CL.AddDelphiFunction('Procedure CloseCdDrive');
 CL.AddDelphiFunction('Function GetRBitmap( Value : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Function GetGBitmap( Value : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Function GetBBitmap( Value : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Function GetMonochromeBitmap( Value : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Function GetHueBitmap( Value : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Function GetSaturationBitmap( Value : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Function GetValueBitmap( Value : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Procedure HideFormCaption( FormHandle : THandle; Hide : Boolean)');
 CL.AddDelphiFunction('Procedure LaunchCpl( FileName : string)');
 //CL.AddDelphiFunction('Function GetControlPanelApplets( const APath, AMask : string; Strings : TStrings; Images : TImageList) : Boolean');
 //CL.AddDelphiFunction('Function GetControlPanelApplet( const AFilename : string; Strings : TStrings; Images : TImageList) : Boolean');
 CL.AddDelphiFunction('Procedure Exec( FileName, Parameters, Directory : string)');
 CL.AddDelphiFunction('Procedure ExecuteAndWait( FileName : string; Visibility : Integer)');
 CL.AddDelphiFunction('Function DiskInDrive( Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function FirstInstance( const ATitle : string) : Boolean');
 CL.AddDelphiFunction('Procedure RestoreOtherInstance( MainFormClassName, MainFormCaption : string)');
 CL.AddDelphiFunction('Procedure HideTraybar');
 CL.AddDelphiFunction('Procedure ShowTraybar');
 CL.AddDelphiFunction('Procedure ShowStartButton');
 CL.AddDelphiFunction('Procedure HideStartButton');
 CL.AddDelphiFunction('Procedure MonitorOn');
 CL.AddDelphiFunction('Procedure MonitorOff');
 CL.AddDelphiFunction('Procedure LowPower');
 CL.AddDelphiFunction('Procedure ConvertImage(source, destination: string)');
 CL.AddDelphiFunction('Procedure ConvertBitmap(source, destination: string)');
 CL.AddDelphiFunction('function getBitMapObject(const bitmappath: string): TBitmap');

 CL.AddDelphiFunction('Function SendKey( AppName : string; Key : Char) : Boolean');
 CL.AddDelphiFunction('Procedure AssociateExtension( IconPath, ProgramName, Path, Extension : string)');
 CL.AddDelphiFunction('Function GetRecentDocs : TStringList');
 CL.AddDelphiFunction('Procedure AddToRecentDocs( const Filename : string)');
 CL.AddDelphiFunction('Function RegionFromBitmap( const Image : TBitmap) : HRGN');
 CL.AddDelphiFunction('Procedure GetVisibleWindows( List : Tstrings)');
 CL.AddDelphiFunction('Function GetChangedText( const Text : string; SelStart, SelLength : Integer; Key : Char) : string');
 CL.AddDelphiFunction('Function MakeYear4Digit( Year, Pivot : Integer) : Integer');
 CL.AddDelphiFunction('Function StrIsInteger( const S : string) : Boolean');
 CL.AddDelphiFunction('Function StrIsFloatMoney( const Ps : string) : Boolean');
 CL.AddDelphiFunction('Function StrIsDateTime( const Ps : string) : Boolean');
 CL.AddDelphiFunction('Function PreformatDateString( Ps : string) : string');
 CL.AddDelphiFunction('Function BooleanToInteger( const Pb : Boolean) : Integer');
 CL.AddDelphiFunction('Function StringToBoolean( const Ps : string) : Boolean');
 CL.AddDelphiFunction('Function ToRightOf( const pc : TControl; piSpace : Integer) : Integer');
 CL.AddDelphiFunction('Procedure CenterHeight( const pc, pcParent : TControl)');
 //CL.AddDelphiFunction('Function TimeOnly( pcValue : TDateTime) : TTime');
 //CL.AddDelphiFunction('Function DateOnly( pcValue : TDateTime) : TDate');
  CL.AddTypeS('TdtKind', '( dtkDateOnly, dtkTimeOnly, dtkDateTime )');

 CL.AddDelphiFunction('Function DateIsNull( const pdtValue : TDateTime; const pdtKind : TdtKind) : Boolean');
 CL.AddDelphiFunction('Function OSCheck( RetVal : Boolean) : Boolean');
 CL.AddDelphiFunction('Function MinimizeName( const Filename : string; Canvas : TCanvas; MaxLen : Integer) : string');
 CL.AddDelphiFunction('Function RunDLL32( const ModuleName, FuncName, CmdLine : string; WaitForCompletion : Boolean; CmdShow : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure RunDll32Internal( Wnd : HWnd; const DLLName, FuncName, CmdLine : string; CmdShow : Integer)');
 CL.AddDelphiFunction('Function GetDLLVersion( const DLLName : string; var pdwMajor, pdwMinor : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure RaiseLastOSError');
 CL.AddDelphiFunction('Function IncludeTrailingPathDelimiter( const APath : string) : string');
 CL.AddDelphiFunction('Function ExcludeTrailingPathDelimiter( const APath : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CaptureScreen1_P( Rec : TRect) : TBitmap;
Begin Result := JvFunctions_max.CaptureScreen(Rec); END;

(*----------------------------------------------------------------------------*)
Function CaptureScreen_P : TBitmap;
Begin Result := JvFunctions_max.CaptureScreen; END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
Procedure SetWallpaper_P( Path : string);
Begin JvFunctions_max.SetWallpaper(Path); END;

(*----------------------------------------------------------------------------*)
Procedure RaiseLastWin321_P( Text : string);
Begin JvFunctions_max.RaiseLastWin32(Text); END;

(*----------------------------------------------------------------------------*)
Procedure RaiseLastWin32_P;
Begin JvFunctions_max.RaiseLastWin32; END;

(*----------------------------------------------------------------------------*)
Function OpenObject1_P( Value : string) : Boolean;
Begin Result := JvFunctions_max.OpenObject(Value); END;

(*----------------------------------------------------------------------------*)
Function OpenObject_P( Value : PChar) : Boolean;
Begin Result := JvFunctions_max.OpenObject(Value); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFunctions_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IconToBitmap, 'IconToBitmap', cdRegister);
 S.RegisterDelphiFunction(@IconToBitmap2, 'IconToBitmap2', cdRegister);
 S.RegisterDelphiFunction(@IconToBitmap3, 'IconToBitmap3', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastWin32, 'RaiseLastWin32', cdRegister);
 S.RegisterDelphiFunction(@PError, 'PError', cdRegister);
 S.RegisterDelphiFunction(@RGBToHSV, 'RGBToHSV', cdRegister);
 S.RegisterDelphiFunction(@GetFileVersion, 'GetFileVersion', cdRegister);
 S.RegisterDelphiFunction(@GetShellVersion, 'GetShellVersion', cdRegister);
 S.RegisterDelphiFunction(@SetWallpaper, 'SetWallpaper', cdRegister);
 S.RegisterDelphiFunction(@CaptureScreen_P, 'CaptureScreen', cdRegister);
 S.RegisterDelphiFunction(@CaptureScreen1_P, 'CaptureScreen1', cdRegister);
 S.RegisterDelphiFunction(@CaptureScreenPNG, 'CaptureScreenPNG', cdRegister);
 S.RegisterDelphiFunction(@CaptureScreenFormat, 'CaptureScreenFormat',cdRegister);
 S.RegisterDelphiFunction(@ConvertImage, 'ConvertImage',cdRegister);
 S.RegisterDelphiFunction(@ConvertImage, 'ConvertBitmap',cdRegister);
 S.RegisterDelphiFunction(@OpenCdDrive, 'OpenCdDrive', cdRegister);
 S.RegisterDelphiFunction(@CloseCdDrive, 'CloseCdDrive', cdRegister);
 S.RegisterDelphiFunction(@GetRBitmap, 'GetRBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetGBitmap, 'GetGBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetBBitmap, 'GetBBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetBitmapObject, 'GetBitmapObject', cdRegister);


 //S.RegisterDelphiFunction(@RegionFromBitmap, 'RegionFromBitmap', cdRegister);

  S.RegisterDelphiFunction(@GetMonochromeBitmap, 'GetMonochromeBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetHueBitmap, 'GetHueBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetSaturationBitmap, 'GetSaturationBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetValueBitmap, 'GetValueBitmap', cdRegister);
 S.RegisterDelphiFunction(@HideFormCaption, 'HideFormCaption', cdRegister);
 S.RegisterDelphiFunction(@LaunchCpl, 'LaunchCpl', cdRegister);
 S.RegisterDelphiFunction(@Exec, 'Exec', cdRegister);
 S.RegisterDelphiFunction(@ExecuteAndWait, 'ExecuteAndWait', cdRegister);
 S.RegisterDelphiFunction(@DiskInDrive, 'DiskInDrive', cdRegister);
 S.RegisterDelphiFunction(@FirstInstance, 'FirstInstance', cdRegister);
 S.RegisterDelphiFunction(@RestoreOtherInstance, 'RestoreOtherInstance', cdRegister);
 S.RegisterDelphiFunction(@HideTraybar, 'HideTraybar', cdRegister);
 S.RegisterDelphiFunction(@ShowTraybar, 'ShowTraybar', cdRegister);
 S.RegisterDelphiFunction(@ShowStartButton, 'ShowStartButton', cdRegister);
 S.RegisterDelphiFunction(@HideStartButton, 'HideStartButton', cdRegister);
 S.RegisterDelphiFunction(@MonitorOn, 'MonitorOn', cdRegister);
 S.RegisterDelphiFunction(@MonitorOff, 'MonitorOff', cdRegister);
 S.RegisterDelphiFunction(@LowPower, 'LowPower', cdRegister);
 S.RegisterDelphiFunction(@SendKey, 'SendKey', cdRegister);
 S.RegisterDelphiFunction(@AssociateExtension, 'AssociateExtension', cdRegister);
 S.RegisterDelphiFunction(@AddToRecentDocs, 'AddToRecentDocs', cdRegister);
 S.RegisterDelphiFunction(@GetVisibleWindows, 'GetVisibleWindows', cdRegister);
 S.RegisterDelphiFunction(@GetChangedText, 'GetChangedText', cdRegister);
 S.RegisterDelphiFunction(@MakeYear4Digit, 'MakeYear4Digit', cdRegister);
 S.RegisterDelphiFunction(@BooleanToInteger, 'BooleanToInteger', cdRegister);
 S.RegisterDelphiFunction(@StringToBoolean, 'StringToBoolean', cdRegister);
 S.RegisterDelphiFunction(@SafeStrToTime, 'SafeStrToTime', cdRegister);
 S.RegisterDelphiFunction(@ToRightOf, 'ToRightOf', cdRegister);
 S.RegisterDelphiFunction(@CenterHeight, 'CenterHeight', cdRegister);
 //S.RegisterDelphiFunction(@TimeOnly, 'TimeOnly', cdRegister);
 //S.RegisterDelphiFunction(@DateOnly, 'DateOnly', cdRegister);
 S.RegisterDelphiFunction(@DateIsNull, 'DateIsNull', cdRegister);
 S.RegisterDelphiFunction(@OSCheck, 'OSCheck', cdRegister);
 S.RegisterDelphiFunction(@MinimizeName, 'MinimizeName', cdRegister);
 S.RegisterDelphiFunction(@RunDLL32, 'RunDLL32', cdRegister);
 S.RegisterDelphiFunction(@RunDll32Internal, 'RunDll32Internal', cdRegister);
 S.RegisterDelphiFunction(@GetDLLVersion, 'GetDLLVersion', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastOSError, 'RaiseLastOSError', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiter, 'IncludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'ExcludeTrailingPathDelimiter', cdRegister);
end;

 
 
{ TPSImport_JvFunctions }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFunctions.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFunctions(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFunctions.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvFunctions(ri);
  RIRegister_JvFunctions_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
