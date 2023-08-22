unit uPSI_Utils;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_Utils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Utils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Utils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   StringsW
  ,Windows
  ,Graphics
  ,StringUtils
  ,PsAPI
  ,TlHelp32
  ,Forms
  ,Utils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Utils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Utils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('FSCTL_SET_COMPRESSION','LongWord').SetUInt( $9C040);
 CL.AddConstantN('COMPRESSION_FORMAT_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('COMPRESSION_FORMAT_DEFAULT','LongInt').SetInt( 1);
  CL.AddTypeS('TEnvVarResolver', 'Function ( Name : WideString; var Exists : Bo'
   +'olean) : WideString');
  CL.AddTypeS('PFormFadeSettings', '^TFormFadeSettings // will not work');
  CL.AddTypeS('TFormFadeSettings', 'record Form : TForm; Step : ShortInt; Disab'
   +'leBlendOnFinish : Boolean; Callback : TNotifyEvent; MinAlpha : byte; MaxAl'
   +'pha : Byte; end');
 CL.AddDelphiFunction('Procedure AdjustArray( var DWArray : array of DWord; const Delta : Integer; MinValueToAdjust : DWord)');
 CL.AddDelphiFunction('Function ComparePoints( const First, Second : TPoint) : ShortInt');
 CL.AddDelphiFunction('Function HashOfString( const Str : WideString) : DWord');
 CL.AddDelphiFunction('Procedure CopyToClipboard( Str : WideString)');
 CL.AddDelphiFunction('Function GetClipboardText : WideString');
 CL.AddDelphiFunction('Function GetDroppedFileNames( const DropID : Integer) : TWideStringArray');
 CL.AddDelphiFunction('Function AreBytesEqual( const First, Second : array of Byte) : Boolean;');
 CL.AddDelphiFunction('Function AreBytesEqual1( const First, Second, Length : DWord) : Boolean;');
 CL.AddDelphiFunction('Function MaskForBytes( const NumberOfBytes : Byte) : DWord');
 CL.AddDelphiFunction('Function CurrentWinUser : WideString');
 CL.AddDelphiFunction('Function GetTempPath : WideString');
 CL.AddDelphiFunction('Function GetTempFileName : WideString');
 CL.AddDelphiFunction('Function GetDesktopFolder : WideString');
 CL.AddDelphiFunction('Function IsWritable( const FileName : WideString) : Boolean');
 CL.AddDelphiFunction('Function SysErrorMessage( ErrorCode : Integer) : WideString');
 CL.AddDelphiFunction('Function FormatExceptionInfo : WideString');
 CL.AddDelphiFunction('Procedure ShowException( Message : WideString)');
 CL.AddDelphiFunction('Procedure ChangeWindowStyle( const Form : HWND; Style : DWord; AddIt : Boolean)');
 CL.AddDelphiFunction('Function IntToBin( Int : Byte) : String;');
 CL.AddDelphiFunction('Function IntToBin3( Int : Word) : String;');
 CL.AddDelphiFunction('Function IntToBin4( Int : DWord; Digits : Byte; SpaceEach : Byte) : String;');
 CL.AddDelphiFunction('Function WriteWS( const Stream : TStream; const Str : WideString) : Word');
 CL.AddDelphiFunction('Procedure WriteArray( const Stream : TStream; const WSArray : array of WideString);');
 CL.AddDelphiFunction('Procedure WriteArray6( const Stream : TStream; const DWArray : array of DWord);');
 CL.AddDelphiFunction('Function ReadWS( const Stream : TStream) : WideString;');
 CL.AddDelphiFunction('Function ReadWS8( const Stream : TStream; out Len : Word) : WideString;');
 CL.AddDelphiFunction('Procedure ReadArray( const Stream : TStream; var WSArray : array of WideString);');
 CL.AddDelphiFunction('Procedure ReadArray10( const Stream : TStream; var DWArray : array of DWord);');
 CL.AddDelphiFunction('Function ParamStrW( Index : Integer) : WideString');
 CL.AddDelphiFunction('Function ParamStrFrom( CmdLine : WideString; Index : Integer) : WideString');
 CL.AddDelphiFunction('Function ParamStrEx( CmdLine : WideString; Index : Integer; out Pos : Integer) : WideString');
 CL.AddDelphiFunction('Function ApplicationPath : WideString');
 CL.AddDelphiFunction('Procedure FindMask( Mask : WideString; Result : TStringsW)');
 CL.AddDelphiFunction('Procedure FindAll( BasePath, Mask : WideString; Result : TStringsW)');
 CL.AddDelphiFunction('Procedure FindAllRelative( BasePath, Mask : WideString; Result : TStringsW)');
 CL.AddDelphiFunction('Function IsInvalidPathChar( const Char : WideChar) : Boolean');
 CL.AddDelphiFunction('Function MakeValidFileName( const Str : WideString; const SubstitutionChar : WideChar) : WideString');
 CL.AddDelphiFunction('Function ExtractFilePath( FileName : WideString) : WideString');
 CL.AddDelphiFunction('Function ExtractFileName( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExpandFileName( FileName : WideString) : WideString;');
 CL.AddDelphiFunction('Function ExpandFileName12( FileName, BasePath : WideString) : WideString;');
 CL.AddDelphiFunction('Function CurrentDirectory : WideString');
 CL.AddDelphiFunction('Function ChDir( const ToPath : WideString) : Boolean');
 CL.AddDelphiFunction('Function ExtractFileExt( FileName : WideString) : WideString');
 CL.AddDelphiFunction('Function ChangeFileExt( FileName, Extension : WideString) : WideString');
 CL.AddDelphiFunction('Function IncludeTrailingBackslash( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExcludeTrailingBackslash( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function IncludeTrailingPathDelimiter( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExcludeTrailingPathDelimiter( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function IncludeLeadingPathDelimiter( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExcludeLeadingPathDelimiter( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function FileInfo( Path : WideString) : TWin32FindDataW');
 CL.AddDelphiFunction('Function IsDirectory( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function FileAge( const FileName : WideString) : Integer');
 CL.AddDelphiFunction('Function FileExists( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function FileSize( Path : WideString) : DWord');
 CL.AddDelphiFunction('Function FileSize64( Path : WideString) : Int64');
 CL.AddDelphiFunction('Function DeleteFile( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function SetNtfsCompression( const FileName : WideString; Level : Word) : Boolean');
 CL.AddDelphiFunction('Function CopyDirectory( Source, Destination : WideString) : Boolean');
 CL.AddDelphiFunction('Function RemoveDirectory( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function ForceDirectories( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function MkDir( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function GetEnvironmentVariable( Name : WideString) : WideString');
 CL.AddDelphiFunction('Function ResolveEnvVars( Path : WideString; Callback : TEnvVarResolver; Unescape : Boolean) : WideString;');
 CL.AddDelphiFunction('Function ResolveEnvVars14( Path : WideString; Unescape : Boolean) : WideString;');
 CL.AddDelphiFunction('Function ReadRegValue( Root : DWord; const Path, Key : WideString) : WideString');
 CL.AddDelphiFunction('Procedure FormFadeIn( Form : TForm; Step : ShortInt)');
 CL.AddDelphiFunction('Procedure FormFadeOut( Form : TForm; Step : ShortInt)');
 CL.AddDelphiFunction('Procedure FormFadeOutAndWait( Form : TForm; Step : ShortInt);');
 CL.AddDelphiFunction('Function FadeSettings( Form : TForm; Step : ShortInt; Callback : TNotifyEvent) : TFormFadeSettings;');
 CL.AddDelphiFunction('Function FadeSettings17( Form : TForm; MinAlpha, MaxAlpha : Byte; Step : ShortInt) : TFormFadeSettings;');
 CL.AddDelphiFunction('Procedure FormFade( const Settings : TFormFadeSettings)');
 CL.AddDelphiFunction('Function BrowseForFolder( const Caption, DefaultPath : WideString; const OwnerWindow : HWND) : WideString');
 CL.AddConstantN('MaxPathLength','LongInt').SetInt( 1000);
  CL.AddTypeS('TUtilsLanguage', 'record ExceptionInfo : WideString; ShowExcepti'
   +'onTitle : WideString; ShowException : WideString; end');
  CL.AddTypeS('TInputBoxesLanguage', 'record OK : WideString; Cancel : WideStri'
   +'ng; end');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FadeSettings17_P( Form : TForm; MinAlpha, MaxAlpha : Byte; Step : ShortInt) : TFormFadeSettings;
Begin Result := Utils.FadeSettings(Form, MinAlpha, MaxAlpha, Step); END;

(*----------------------------------------------------------------------------*)
Function FadeSettings_P( Form : TForm; Step : ShortInt; Callback : TNotifyEvent) : TFormFadeSettings;
Begin Result := Utils.FadeSettings(Form, Step, Callback); END;

(*----------------------------------------------------------------------------*)
Procedure FormFadeOutAndWait_P( Form : TForm; Step : ShortInt);
Begin Utils.FormFadeOutAndWait(Form, Step); END;

(*----------------------------------------------------------------------------*)
Function ResolveEnvVars14_P( Path : WideString; Unescape : Boolean) : WideString;
Begin Result := Utils.ResolveEnvVars(Path, Unescape); END;

(*----------------------------------------------------------------------------*)
Function ResolveEnvVars_P( Path : WideString; Callback : TEnvVarResolver; Unescape : Boolean) : WideString;
Begin Result := Utils.ResolveEnvVars(Path, Callback, Unescape); END;

(*----------------------------------------------------------------------------*)
Function ExpandFileName12_P( FileName, BasePath : WideString) : WideString;
Begin Result := Utils.ExpandFileName(FileName, BasePath); END;

(*----------------------------------------------------------------------------*)
Function ExpandFileName_P( FileName : WideString) : WideString;
Begin Result := Utils.ExpandFileName(FileName); END;

(*----------------------------------------------------------------------------*)
Procedure ReadArray10_P( const Stream : TStream; var DWArray : array of DWord);
Begin Utils.ReadArray(Stream, DWArray); END;

(*----------------------------------------------------------------------------*)
Procedure ReadArray_P( const Stream : TStream; var WSArray : array of WideString);
Begin Utils.ReadArray(Stream, WSArray); END;

(*----------------------------------------------------------------------------*)
Function ReadWS8_P( const Stream : TStream; out Len : Word) : WideString;
Begin Result := Utils.ReadWS(Stream, Len); END;

(*----------------------------------------------------------------------------*)
Function ReadWS_P( const Stream : TStream) : WideString;
Begin Result := Utils.ReadWS(Stream); END;

(*----------------------------------------------------------------------------*)
Procedure WriteArray6_P( const Stream : TStream; const DWArray : array of DWord);
Begin Utils.WriteArray(Stream, DWArray); END;

(*----------------------------------------------------------------------------*)
Procedure WriteArray_P( const Stream : TStream; const WSArray : array of WideString);
Begin Utils.WriteArray(Stream, WSArray); END;

(*----------------------------------------------------------------------------*)
Function IntToBin4_P( Int : DWord; Digits : Byte; SpaceEach : Byte) : String;
Begin Result := Utils.IntToBin(Int, Digits, SpaceEach); END;

(*----------------------------------------------------------------------------*)
Function IntToBin3_P( Int : Word) : String;
Begin Result := Utils.IntToBin(Int); END;

(*----------------------------------------------------------------------------*)
Function IntToBin_P( Int : Byte) : String;
Begin Result := Utils.IntToBin(Int); END;

(*----------------------------------------------------------------------------*)
Function AreBytesEqual1_P( const First, Second, Length : DWord) : Boolean;
Begin Result := Utils.AreBytesEqual(First, Second, Length); END;

(*----------------------------------------------------------------------------*)
Function AreBytesEqual_P( const First, Second : array of Byte) : Boolean;
Begin Result := Utils.AreBytesEqual(First, Second); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Utils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AdjustArray, 'AdjustArray', cdRegister);
 S.RegisterDelphiFunction(@ComparePoints, 'ComparePoints', cdRegister);
 S.RegisterDelphiFunction(@HashOfString, 'HashOfString', cdRegister);
 S.RegisterDelphiFunction(@CopyToClipboard, 'CopyToClipboard', cdRegister);
 S.RegisterDelphiFunction(@GetClipboardText, 'GetClipboardText', cdRegister);
 S.RegisterDelphiFunction(@GetDroppedFileNames, 'GetDroppedFileNames', cdRegister);
 S.RegisterDelphiFunction(@AreBytesEqual, 'AreBytesEqual', cdRegister);
 S.RegisterDelphiFunction(@AreBytesEqual1, 'AreBytesEqual1', cdRegister);
 S.RegisterDelphiFunction(@MaskForBytes, 'MaskForBytes', cdRegister);
 S.RegisterDelphiFunction(@CurrentWinUser, 'CurrentWinUser', cdRegister);
 S.RegisterDelphiFunction(@GetTempPath, 'GetTempPath', cdRegister);
 S.RegisterDelphiFunction(@GetTempFileName, 'GetTempFileName', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolder, 'GetDesktopFolder', cdRegister);
 S.RegisterDelphiFunction(@IsWritable, 'IsWritable', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'SysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@FormatExceptionInfo, 'FormatExceptionInfo', cdRegister);
 S.RegisterDelphiFunction(@ShowException, 'ShowException', cdRegister);
 S.RegisterDelphiFunction(@ChangeWindowStyle, 'ChangeWindowStyle', cdRegister);
 S.RegisterDelphiFunction(@IntToBin, 'IntToBin', cdRegister);
 S.RegisterDelphiFunction(@IntToBin3, 'IntToBin3', cdRegister);
 S.RegisterDelphiFunction(@IntToBin4, 'IntToBin4', cdRegister);
 S.RegisterDelphiFunction(@WriteWS, 'WriteWS', cdRegister);
 S.RegisterDelphiFunction(@WriteArray, 'WriteArray', cdRegister);
 S.RegisterDelphiFunction(@WriteArray6, 'WriteArray6', cdRegister);
 S.RegisterDelphiFunction(@ReadWS, 'ReadWS', cdRegister);
 S.RegisterDelphiFunction(@ReadWS8, 'ReadWS8', cdRegister);
 S.RegisterDelphiFunction(@ReadArray, 'ReadArray', cdRegister);
 S.RegisterDelphiFunction(@ReadArray10, 'ReadArray10', cdRegister);
 S.RegisterDelphiFunction(@ParamStrW, 'ParamStrW', cdRegister);
 S.RegisterDelphiFunction(@ParamStrFrom, 'ParamStrFrom', cdRegister);
 S.RegisterDelphiFunction(@ParamStrEx, 'ParamStrEx', cdRegister);
 S.RegisterDelphiFunction(@ApplicationPath, 'ApplicationPath', cdRegister);
 S.RegisterDelphiFunction(@FindMask, 'FindMask', cdRegister);
 S.RegisterDelphiFunction(@FindAll, 'FindAll', cdRegister);
 S.RegisterDelphiFunction(@FindAllRelative, 'FindAllRelative', cdRegister);
 S.RegisterDelphiFunction(@IsInvalidPathChar, 'IsInvalidPathChar', cdRegister);
 S.RegisterDelphiFunction(@MakeValidFileName, 'MakeValidFileName', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath, 'ExtractFilePath', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileName, 'ExtractFileName', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName, 'ExpandFileName', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName12, 'ExpandFileName12', cdRegister);
 S.RegisterDelphiFunction(@CurrentDirectory, 'CurrentDirectory', cdRegister);
 S.RegisterDelphiFunction(@ChDir, 'ChDir', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExt, 'ExtractFileExt', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt, 'ChangeFileExt', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingBackslash, 'IncludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingBackslash, 'ExcludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiter, 'IncludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'ExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IncludeLeadingPathDelimiter, 'IncludeLeadingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeLeadingPathDelimiter, 'ExcludeLeadingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@FileInfo, 'FileInfo', cdRegister);
 S.RegisterDelphiFunction(@IsDirectory, 'IsDirectory', cdRegister);
 S.RegisterDelphiFunction(@FileAge, 'FileAge', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExists', cdRegister);
 S.RegisterDelphiFunction(@FileSize, 'FileSize', cdRegister);
 S.RegisterDelphiFunction(@FileSize64, 'FileSize64', cdRegister);
 S.RegisterDelphiFunction(@DeleteFile, 'DeleteFile', cdRegister);
 S.RegisterDelphiFunction(@SetNtfsCompression, 'SetNtfsCompression', cdRegister);
 S.RegisterDelphiFunction(@CopyDirectory, 'CopyDirectory', cdRegister);
 S.RegisterDelphiFunction(@RemoveDirectory, 'RemoveDirectory', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectories', cdRegister);
 S.RegisterDelphiFunction(@MkDir, 'MkDir', cdRegister);
 S.RegisterDelphiFunction(@GetEnvironmentVariable, 'GetEnvironmentVariable', cdRegister);
 S.RegisterDelphiFunction(@ResolveEnvVars, 'ResolveEnvVars', cdRegister);
 S.RegisterDelphiFunction(@ResolveEnvVars14, 'ResolveEnvVars14', cdRegister);
 S.RegisterDelphiFunction(@ReadRegValue, 'ReadRegValue', cdRegister);
 S.RegisterDelphiFunction(@FormFadeIn, 'FormFadeIn', cdRegister);
 S.RegisterDelphiFunction(@FormFadeOut, 'FormFadeOut', cdRegister);
 S.RegisterDelphiFunction(@FormFadeOutAndWait, 'FormFadeOutAndWait', cdRegister);
 S.RegisterDelphiFunction(@FadeSettings, 'FadeSettings', cdRegister);
 S.RegisterDelphiFunction(@FadeSettings17, 'FadeSettings17', cdRegister);
 S.RegisterDelphiFunction(@FormFade, 'FormFade', cdRegister);
 S.RegisterDelphiFunction(@BrowseForFolder, 'BrowseForFolder', cdRegister);
end;

 
 
{ TPSImport_Utils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Utils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Utils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Utils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Utils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.