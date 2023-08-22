unit uPSI_FileStreamW;
{
belongs to widestring or whitequeen unicode with stringutils
  more utils as utilsw   extend to 4.2
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
  TPSImport_FileStreamW = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFileStreamW(CL: TPSPascalCompiler);
procedure SIRegister_FileStreamW(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FileStreamW_Routines(S: TPSExec);
procedure RIRegister_TFileStreamW(CL: TPSRuntimeClassImporter);
procedure RIRegister_FileStreamW(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,FileStreamW , UtilsW, Stringutils, Forms
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileStreamW]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileStreamW(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFileStream', 'TFileStreamW') do
  with CL.AddClassN(CL.FindClass('TFileStream'),'TFileStreamW') do
  begin
    RegisterMethod('Function LoadUnicodeFrom( const FileName : WideString; AsIsAnsi : Boolean) : WideString');
    RegisterMethod('Constructor Create( const FileName : WideString; Mode : Word)');
    RegisterMethod('Constructor CreateCustom( const FileName : WideString; Mode : DWord)');
    RegisterProperty('FileName', 'WideString', iptr);
    RegisterProperty('IsReadOnly', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FileStreamW(CL: TPSPascalCompiler);
begin
  SIRegister_TFileStreamW(CL);

  {TFormFadeSettings = record
    Form: TForm;
    Step: ShortInt;
    DisableBlendOnFinish: Boolean;
    Callback: TNotifyEvent;
    MinAlpha, MaxAlpha: Byte;
  end;}

   CL.AddConstantN('FSCTL_SET_COMPRESSION','LongWord').SetUInt( $9C040);
 CL.AddConstantN('COMPRESSION_FORMAT_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('COMPRESSION_FORMAT_DEFAULT','LongInt').SetInt( 1);
  CL.AddTypeS('TEnvVarResolver', 'Function ( Name : WideString; var Exists : Boolean) : WideString');


CL.AddTypeS('TFormFadeSettings', 'record Form: TForm;Step: ShortInt; DisableBlendOnFinish: Boolean; Callback: TNotifyEvent; MinAlpha, MaxAlpha: Byte; end');
 CL.AddConstantN('fmForcePath','LongWord').SetUInt( $80000000);
 CL.AddDelphiFunction('Function LoadUnicodeFromStream( S : TStream; AsIsAnsi : Boolean) : WideString');
 CL.AddDelphiFunction('function GetClipboardText: WideString;');
 CL.AddDelphiFunction('procedure CopyToClipboard(Str: WideString);');
 CL.AddDelphiFunction('function CurrentWinUser: WideString;');
  CL.AddDelphiFunction('function GetTempPathW: WideString;');
 CL.AddDelphiFunction('function GetTempFileNameW: WideString;');
 CL.AddDelphiFunction('function GetDesktopFolderW: WideString;');
 CL.AddDelphiFunction('function IsWritable(const FileName: WideString): Boolean;');
 CL.AddDelphiFunction('function SysErrorMessageW(ErrorCode: Integer): WideString;');
 CL.AddDelphiFunction('function FormatExceptionInfo: WideString;');
 CL.AddDelphiFunction('procedure ShowExceptionW(Message: WideString);');
 CL.AddDelphiFunction('procedure ChangeWindowStyle(const Form: HWND; Style: DWord; AddIt: Boolean);');

 CL.AddDelphiFunction('function SetNtfsCompressionW(const FileName: WideString; Level: Word): Boolean;');
 CL.AddDelphiFunction('function WriteWS(const Stream: TStream; const Str: WideString): Word;');
 CL.AddDelphiFunction('procedure FormFadeIn(Form: TForm; Step: ShortInt);');
 CL.AddDelphiFunction('procedure FormFadeOut(Form: TForm; Step: ShortInt);');
 CL.AddDelphiFunction('procedure FormFadeOutAndWait(Form: TForm; Step: ShortInt);');
 CL.AddDelphiFunction('function BrowseForFolderw(const Caption, DefaultPath: WideString; const OwnerWindow: HWND): WideString;');
 CL.AddDelphiFunction('procedure FormFade(const Settings: TFormFadeSettings);');
 CL.AddDelphiFunction('function HashOfString(const Str: WideString): DWord;');
 CL.AddDelphiFunction('function ComparePoints(const First, Second: TPoint): ShortInt;');
   CL.AddTypeS('TWideStringArray', 'array of WideString');


  CL.AddDelphiFunction('Procedure AdjustArray( var DWArray : array of DWord; const Delta : Integer; MinValueToAdjust : DWord)');
 CL.AddDelphiFunction('Function GetDroppedFileNames( const DropID : Integer) : TWideStringArray');
 CL.AddDelphiFunction('Function AreBytesEqual( const First, Second : array of Byte) : Boolean;');
 CL.AddDelphiFunction('Function AreBytesEqual1( const First, Second, Length : DWord) : Boolean;');
 CL.AddDelphiFunction('Function MaskForBytes( const NumberOfBytes : Byte) : DWord');
 CL.AddDelphiFunction('Function IntToBinByte( Int : Byte) : String;');
 CL.AddDelphiFunction('Function IntToBinWord( Int : Word) : String;');
 CL.AddDelphiFunction('Function IntToBinDWord( Int : DWord; Digits : Byte; SpaceEach : Byte) : String;');
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
  CL.AddDelphiFunction('Procedure FindMask( Mask : WideString; Result : TStringsW)');
 CL.AddDelphiFunction('Procedure FindAll( BasePath, Mask : WideString; Result : TStringsW)');
 CL.AddDelphiFunction('Procedure FindAllRelative( BasePath, Mask : WideString; Result : TStringsW)');
 CL.AddDelphiFunction('Function IsInvalidPathChar( const Char : WideChar) : Boolean');
  CL.AddDelphiFunction('Function MakeValidFileNameW( const Str : WideString; const SubstitutionChar : WideChar) : WideString');
  CL.AddDelphiFunction('Function ExtractFilePathW( FileName : WideString) : WideString');
 CL.AddDelphiFunction('Function ExtractFileNameW( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExpandFileNameW( FileName : WideString) : WideString;');
 CL.AddDelphiFunction('Function ExpandFileName12( FileName, BasePath : WideString) : WideString;');
 CL.AddDelphiFunction('Function CurrentDirectory : WideString');
 CL.AddDelphiFunction('Function ChDirW( const ToPath : WideString) : Boolean');
 CL.AddDelphiFunction('Function ExtractFileExtW( FileName : WideString) : WideString');
 CL.AddDelphiFunction('Function ChangeFileExtW2( FileName, Extension : WideString) : WideString');
 CL.AddDelphiFunction('Function IncludeTrailingBackslashW( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExcludeTrailingBackslashW( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function IncludeTrailingPathDelimiterW( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExcludeTrailingPathDelimiterW( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function IncludeLeadingPathDelimiter( Path : WideString) : WideString');
 CL.AddDelphiFunction('Function ExcludeLeadingPathDelimiter( Path : WideString) : WideString');
  CL.AddDelphiFunction('Function FileInfo( Path : WideString) : TWin32FindData');
 CL.AddDelphiFunction('Function IsDirectoryW( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function FileAgeW( const FileName : WideString) : Integer');
 CL.AddDelphiFunction('Function FileExistsW( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function FileSizeW( Path : WideString) : DWord');
 CL.AddDelphiFunction('Function FileSize64( Path : WideString) : Int64');
 CL.AddDelphiFunction('Function DeleteFileW( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function CopyDirectoryW( Source, Destination : WideString) : Boolean');
 CL.AddDelphiFunction('Function RemoveDirectoryW( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function ForceDirectoriesW( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function MkDirW( Path : WideString) : Boolean');
 CL.AddDelphiFunction('Function GetEnvironmentVariableW( Name : WideString) : WideString');
 CL.AddDelphiFunction('Function ResolveEnvVars( Path : WideString; Callback : TEnvVarResolver; Unescape : Boolean) : WideString;');
 CL.AddDelphiFunction('Function ResolveEnvVars14( Path : WideString; Unescape : Boolean) : WideString;');
 CL.AddDelphiFunction('Function ReadRegValue( Root : DWord; const Path, Key : WideString) : WideString');
  CL.AddDelphiFunction('Function FadeSettings( Form : TForm; Step : ShortInt; Callback : TNotifyEvent) : TFormFadeSettings;');
 CL.AddDelphiFunction('Function FadeSettings17( Form : TForm; MinAlpha, MaxAlpha : Byte; Step : ShortInt) : TFormFadeSettings;');


  CL.AddTypeS('TMaskMatchInfo', 'record Matched: Boolean; StrPos: Word; MatchLength: Word; end');
 CL.AddTypeS('TGenericFormatLanguage', 'record BasicNumberFormat : String; Num'
   +'berFormat : String; ResultFormat : WideString; Measures : array of record '
   +'Capacity : DWord; Measure : WideString; end ; end');
   CL.AddConstantN('MaxPathLength','LongInt').SetInt( 1000);
  CL.AddTypeS('TUtilsLanguage', 'record ExceptionInfo : WideString; ShowExcepti'
   +'onTitle : WideString; ShowException : WideString; end');
  CL.AddTypeS('TInputBoxesLanguage', 'record OK : WideString; Cancel : WideString; end');


 //  CL.AddTypeS('TWideStringArray', 'array of WideString');
 // CL.AddConstantN('LineBreakers','WideString').SetString('.,!?";:'#10#13#9#$3000#$3001#$3002#$FF0C#$FF0E#$FF1A#$FF1B#$FF1F#$FF01#$2026#$2025#$FF5E);
  CL.AddTypeS('TStringUtilsLanguage', 'record VersionFormat : WideString; Thous'
   +'andsSeparator : WideString; IntervalFormat : TGenericFormatLanguage; SizeF'
   +'ormat : TGenericFormatLanguage; end');
   CL.AddDelphiFunction('function CompareStrW(const S1, S2: WideString; Flags: DWord): Integer;');
 CL.AddDelphiFunction('function CompareTextW(const S1, S2: WideString): Integer;');
 CL.AddDelphiFunction('function MaskMatch(const Str, Mask: WideString): Boolean;');
 CL.AddDelphiFunction('function MaskMatchInfo(const Str, Mask: WideString; StartingPos: Word): TMaskMatchInfo;');
 //Stringutils
  CL.AddDelphiFunction('Function TryStrToIntStrict( const S : String; out Value : Integer; Min : Integer) : Boolean');
 CL.AddDelphiFunction('Function TryStrToFloatStrict( const S : String; out Value : Single; const FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function TryStrToFloatStrict1( const S : String; out Value : Double; const FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function DetectEolnStyleIn( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function DetectEolnStyleInANSI( Stream : TStream) : WideString');
 CL.AddDelphiFunction('Function PascalQuote( const Str : WideString) : WideString');
  CL.AddDelphiFunction('Function StrRepeatW( const Str : WideString; Times : Integer) : WideString');

    CL.AddDelphiFunction('Function EscapeString( const Str : WideString; CharsToEscape : WideString) : WideString');
 CL.AddDelphiFunction('Function UnescapeString( const Str : WideString; CharsToEscape : WideString) : WideString');
 CL.AddDelphiFunction('Function BinToHexW( const Buf : String; Delim : String) : String');
 CL.AddDelphiFunction('Function HexToBinW( Text : String) : String');
 CL.AddDelphiFunction('Function SoftHexToBin( Text : String) : String');
 CL.AddDelphiFunction('Function FormatVersion( Version : Word) : WideString');
 CL.AddDelphiFunction('Function FormatDateW( Date : DWord) : WideString');
 CL.AddDelphiFunction('Function FormatNumber( Number : DWord) : WideString');
 CL.AddDelphiFunction('Function GenericFormat( Number : Single; const Language : TGenericFormatLanguage) : WideString');
 CL.AddDelphiFunction('Function FormatInterval( Millisecs : DWord) : WideString');
 CL.AddDelphiFunction('Function FormatSize( Bytes : DWord) : WideString');
 CL.AddDelphiFunction('Function PosLast( const Substr, Str : String; Start : Word) : Integer');
 CL.AddDelphiFunction('Function PosLastW( const Substr, Str : WideString; Start : Word) : Integer');
   CL.AddDelphiFunction('Function IsDelimiterW( const Delimiters, S : WideString; Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function RemoveNonWordChars( const Str : WideString; DoNotRemove : WideString) : WideString');
 CL.AddDelphiFunction('Function IsQuoteChar( const aChr : Char) : Boolean');
 CL.AddDelphiFunction('Function WrapTextW( const Str : WideString; const Delimiter : WideString; const MaxWidth : Word) : WideString');
 CL.AddDelphiFunction('Function PadText( const Str : WideString; const NewLine, PadStr : WideString; const MaxWidth : Word) : WideString');
 CL.AddDelphiFunction('Function PadTextWithVariableLineLength( const Str : WideString; const NewLine, PadStr : WideString; const LineLengths : array of Integer) : WideString');
 CL.AddDelphiFunction('Function StrPadW( const Str : WideString; ToLength : Integer; PadChar : WideChar) : WideString');
 CL.AddDelphiFunction('Function StrPadLeftW( const Str : WideString; ToLength : Integer; PadChar : WideChar) : WideString');
 //CL.AddDelphiFunction('Function StrRepeat( const Str : WideString; Times : Integer) : WideString');
 CL.AddDelphiFunction('Function StrReverseW( const Str : WideString) : WideString');
  CL.AddDelphiFunction('Function CountSubstr( const Substr, Str : WideString) : Integer');
   CL.AddDelphiFunction('Procedure DeleteArrayItem( var A : TWideStringArray; Index : Integer)');
 CL.AddDelphiFunction('Function TrimStringArray( WSArray : TWideStringArray) : TWideStringArray');
 CL.AddDelphiFunction('Function TrimWS( Str : WideString; const Chars : WideString) : WideString');
 CL.AddDelphiFunction('Function TrimLeftWS( Str : WideString; const Chars : WideString) : WideString');
 //CL.AddDelphiFunction('Function TrimRightWS( Str : WideString; const Chars : WideString) : WideString');
 CL.AddDelphiFunction('Function ConsistsOfChars( const Str, Chars : WideString) : Boolean');
 CL.AddDelphiFunction('Function UpperCaseW( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function LowerCaseW( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function UpperCaseFirst( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function LowerCaseFirst( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function StripAccelChars( const Str : WideString) : WideString');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFileStreamWIsReadOnly_R(Self: TFileStreamW; var T: Boolean);
begin T := Self.IsReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TFileStreamWFileName_R(Self: TFileStreamW; var T: WideString);
begin T := Self.FileName; end;

Function TryStrToFloatStrict1_P( const S : String; out Value : Double; const FormatSettings : TFormatSettings) : Boolean;
Begin Result := StringUtils.TryStrToFloatStrict(S, Value, FormatSettings); END;

(*----------------------------------------------------------------------------*)
Function TryStrToFloatStrict0_P( const S : String; out Value : Single; const FormatSettings : TFormatSettings) : Boolean;
Begin Result := StringUtils.TryStrToFloatStrict(S, Value, FormatSettings); END;

 Function AreBytesEqual1_P( const First, Second, Length : DWord) : Boolean;
Begin Result := UtilsW.AreBytesEqual(First, Second, Length); END;

(*----------------------------------------------------------------------------*)
Function AreBytesEqual_P( const First, Second : array of Byte) : Boolean;
Begin Result := UtilsW.AreBytesEqual(First, Second); END;

(*----------------------------------------------------------------------------*)
Function IntToBin4_P( Int : DWord; Digits : Byte; SpaceEach : Byte) : String;
Begin Result := UtilsW.IntToBin(Int, Digits, SpaceEach); END;

(*----------------------------------------------------------------------------*)
Function IntToBin3_P( Int : Word) : String;
Begin Result := UtilsW.IntToBin(Int); END;

(*----------------------------------------------------------------------------*)
Function IntToBin_P( Int : Byte) : String;
Begin Result := UtilsW.IntToBin(Int); END;

(*----------------------------------------------------------------------------*)
Procedure ReadArray10_P( const Stream : TStream; var DWArray : array of DWord);
Begin UtilsW.ReadArray(Stream, DWArray); END;

(*----------------------------------------------------------------------------*)
Procedure ReadArray_P( const Stream : TStream; var WSArray : array of WideString);
Begin UtilsW.ReadArray(Stream, WSArray); END;

(*----------------------------------------------------------------------------*)
Function ReadWS8_P( const Stream : TStream; out Len : Word) : WideString;
Begin Result := UtilsW.ReadWS(Stream, Len); END;

(*----------------------------------------------------------------------------*)
Function ReadWS_P( const Stream : TStream) : WideString;
Begin Result := UtilsW.ReadWS(Stream); END;

(*----------------------------------------------------------------------------*)
Procedure WriteArray6_P( const Stream : TStream; const DWArray : array of DWord);
Begin UtilsW.WriteArray(Stream, DWArray); END;

(*----------------------------------------------------------------------------*)
Procedure WriteArray_P( const Stream : TStream; const WSArray : array of WideString);
Begin UtilsW.WriteArray(Stream, WSArray); END;

(*----------------------------------------------------------------------------*)
Function ExpandFileName12_P( FileName, BasePath : WideString) : WideString;
Begin Result := UtilsW.ExpandFileName(FileName, BasePath); END;

(*----------------------------------------------------------------------------*)
Function ExpandFileName_P( FileName : WideString) : WideString;
Begin Result := UtilsW.ExpandFileName(FileName); END;

 Function FadeSettings17_P( Form : TForm; MinAlpha, MaxAlpha : Byte; Step : ShortInt) : TFormFadeSettings;
Begin Result := UtilsW.FadeSettings(Form, MinAlpha, MaxAlpha, Step); END;

(*----------------------------------------------------------------------------*)
Function FadeSettings_P( Form : TForm; Step : ShortInt; Callback : TNotifyEvent) : TFormFadeSettings;
Begin Result := UtilsW.FadeSettings(Form, Step, Callback); END;

(*----------------------------------------------------------------------------*)
Function ResolveEnvVars14_P( Path : WideString; Unescape : Boolean) : WideString;
Begin Result := UtilsW.ResolveEnvVars(Path, Unescape); END;

(*----------------------------------------------------------------------------*)
Function ResolveEnvVars_P( Path : WideString; Callback : TEnvVarResolver; Unescape : Boolean) : WideString;
Begin Result := UtilsW.ResolveEnvVars(Path, Callback, Unescape); END;




(*----------------------------------------------------------------------------*)
procedure RIRegister_FileStreamW_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoadUnicodeFromStream, 'LoadUnicodeFromStream', cdRegister);
  S.RegisterDelphiFunction(@GetClipboardText, 'GetClipboardText', cdRegister);
  S.RegisterDelphiFunction(@CopyToClipboard, 'CopyToClipboard', cdRegister);
  S.RegisterDelphiFunction(@CurrentWinUser, 'CurrentWinUser', cdRegister);
 S.RegisterDelphiFunction(@GetTempPath, 'GetTempPathW', cdRegister);
 S.RegisterDelphiFunction(@GetTempFileName, 'GetTempFileNameW', cdRegister);
 S.RegisterDelphiFunction(@GetDesktopFolder, 'GetDesktopFolderW', cdRegister);
 S.RegisterDelphiFunction(@IsWritable, 'IsWritable', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'SysErrorMessageW', cdRegister);
 S.RegisterDelphiFunction(@FormatExceptionInfo, 'FormatExceptionInfo', cdRegister);
 //S.RegisterDelphiFunction(@FormatExceptionInfo, 'FormatExceptionInfo', cdRegister);
 S.RegisterDelphiFunction(@ShowException, 'ShowExceptionW', cdRegister);
 S.RegisterDelphiFunction(@ChangeWindowStyle, 'ChangeWindowStyle', cdRegister);

  S.RegisterDelphiFunction(@AdjustArray, 'AdjustArray', cdRegister);
 S.RegisterDelphiFunction(@GetDroppedFileNames, 'GetDroppedFileNames', cdRegister);
  S.RegisterDelphiFunction(@AreBytesEqual, 'AreBytesEqual', cdRegister);
 S.RegisterDelphiFunction(@AreBytesEqual1_P, 'AreBytesEqual1', cdRegister);
 S.RegisterDelphiFunction(@MaskForBytes, 'MaskForBytes', cdRegister);
 S.RegisterDelphiFunction(@IntToBin_P, 'IntToBinByte', cdRegister);
 S.RegisterDelphiFunction(@IntToBin3_P, 'IntToBinWord', cdRegister);
 S.RegisterDelphiFunction(@IntToBin4_P, 'IntToBinDWord', cdRegister);
 S.RegisterDelphiFunction(@WriteWS, 'WriteWS', cdRegister);
 S.RegisterDelphiFunction(@WriteArray_P, 'WriteArray', cdRegister);
 S.RegisterDelphiFunction(@WriteArray6_P, 'WriteArray6', cdRegister);
 S.RegisterDelphiFunction(@ReadWS, 'ReadWS', cdRegister);
 S.RegisterDelphiFunction(@ReadWS8_P, 'ReadWS8', cdRegister);
 S.RegisterDelphiFunction(@ReadArray_P, 'ReadArray', cdRegister);
 S.RegisterDelphiFunction(@ReadArray10_P, 'ReadArray10', cdRegister);
  S.RegisterDelphiFunction(@ParamStrW, 'ParamStrW', cdRegister);
 S.RegisterDelphiFunction(@ParamStrFrom, 'ParamStrFrom', cdRegister);
 S.RegisterDelphiFunction(@ParamStrEx, 'ParamStrEx', cdRegister);
 S.RegisterDelphiFunction(@FindMask, 'FindMask', cdRegister);
 S.RegisterDelphiFunction(@FindAll, 'FindAll', cdRegister);
 S.RegisterDelphiFunction(@FindAllRelative, 'FindAllRelative', cdRegister);
 S.RegisterDelphiFunction(@IsInvalidPathChar, 'IsInvalidPathChar', cdRegister);
 S.RegisterDelphiFunction(@MakeValidFileName, 'MakeValidFileNameW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath, 'ExtractFilePathW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileName, 'ExtractFileNameW', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName_P, 'ExpandFileNameW', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName12_P, 'ExpandFileName12', cdRegister);
 S.RegisterDelphiFunction(@CurrentDirectory, 'CurrentDirectory', cdRegister);
 S.RegisterDelphiFunction(@ChDir, 'ChDirW', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExt, 'ExtractFileExtW', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt, 'ChangeFileExtW2', cdRegister);
  S.RegisterDelphiFunction(@IncludeTrailingBackslash, 'IncludeTrailingBackslashW', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingBackslash, 'ExcludeTrailingBackslashW', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiter, 'IncludeTrailingPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'ExcludeTrailingPathDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@IncludeLeadingPathDelimiter, 'IncludeLeadingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeLeadingPathDelimiter, 'ExcludeLeadingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@FileInfo, 'FileInfo', cdRegister);
 S.RegisterDelphiFunction(@IsDirectory, 'IsDirectoryW', cdRegister);
 S.RegisterDelphiFunction(@FileAge, 'FileAgeW', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExistsW', cdRegister);
 S.RegisterDelphiFunction(@FileSize, 'FileSizeW', cdRegister);
 S.RegisterDelphiFunction(@FileSize64, 'FileSize64', cdRegister);
 S.RegisterDelphiFunction(@DeleteFile, 'DeleteFileW', cdRegister);
 S.RegisterDelphiFunction(@CopyDirectory, 'CopyDirectoryW', cdRegister);
 S.RegisterDelphiFunction(@RemoveDirectory, 'RemoveDirectoryW', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectoriesW', cdRegister);
 S.RegisterDelphiFunction(@MkDir, 'MkDirW', cdRegister);
 S.RegisterDelphiFunction(@GetEnvironmentVariable, 'GetEnvironmentVariableW', cdRegister);
 S.RegisterDelphiFunction(@ResolveEnvVars_P, 'ResolveEnvVars', cdRegister);
 S.RegisterDelphiFunction(@ResolveEnvVars14_P, 'ResolveEnvVars14', cdRegister);
 S.RegisterDelphiFunction(@ReadRegValue, 'ReadRegValue', cdRegister);
  S.RegisterDelphiFunction(@FadeSettings_P, 'FadeSettings', cdRegister);
 S.RegisterDelphiFunction(@FadeSettings17_P, 'FadeSettings17', cdRegister);

   S.RegisterDelphiFunction(@SetNtfsCompression, 'SetNtfsCompressionW', cdRegister);
 S.RegisterDelphiFunction(@WriteWS, 'WriteWS', cdRegister);
 S.RegisterDelphiFunction(@FormFadeIn, 'FormFadeIn', cdRegister);
 S.RegisterDelphiFunction(@FormFadeOut, 'FormFadeOut', cdRegister);
 S.RegisterDelphiFunction(@FormFadeOutAndWait, 'FormFadeOutAndWait', cdRegister);
 S.RegisterDelphiFunction(@BrowseForFolder, 'BrowseForFolderW', cdRegister);
 S.RegisterDelphiFunction(@FormFade, 'FormFade', cdRegister);
 S.RegisterDelphiFunction(@HashOfString, 'HashOfString', cdRegister);
 S.RegisterDelphiFunction(@ComparePoints, 'ComparePoints', cdRegister);
 S.RegisterDelphiFunction(@CompareStr, 'CompareStrW', cdRegister);
 S.RegisterDelphiFunction(@CompareText, 'CompareTextW', cdRegister);
 S.RegisterDelphiFunction(@MaskMatch, 'MaskMatch', cdRegister);
 S.RegisterDelphiFunction(@MaskMatchInfo, 'MaskMatchInfo', cdRegister);
  S.RegisterDelphiFunction(@TryStrToIntStrict, 'TryStrToIntStrict', cdRegister);
 S.RegisterDelphiFunction(@TryStrToFloatStrict0_P, 'TryStrToFloatStrict', cdRegister);
 S.RegisterDelphiFunction(@TryStrToFloatStrict1_P, 'TryStrToFloatStrict1', cdRegister);
 S.RegisterDelphiFunction(@DetectEolnStyleIn, 'DetectEolnStyleIn', cdRegister);
 S.RegisterDelphiFunction(@DetectEolnStyleInANSI, 'DetectEolnStyleInANSI', cdRegister);

 S.RegisterDelphiFunction(@EscapeString, 'EscapeString', cdRegister);
 S.RegisterDelphiFunction(@UnescapeString, 'UnescapeString', cdRegister);
 S.RegisterDelphiFunction(@BinToHex, 'BinToHexW', cdRegister);
 S.RegisterDelphiFunction(@HexToBin, 'HexToBinW', cdRegister);
 S.RegisterDelphiFunction(@SoftHexToBin, 'SoftHexToBin', cdRegister);
 S.RegisterDelphiFunction(@FormatVersion, 'FormatVersion', cdRegister);
 S.RegisterDelphiFunction(@FormatDate, 'FormatDateW', cdRegister);
 S.RegisterDelphiFunction(@FormatNumber, 'FormatNumber', cdRegister);
 S.RegisterDelphiFunction(@GenericFormat, 'GenericFormat', cdRegister);
 S.RegisterDelphiFunction(@FormatInterval, 'FormatInterval', cdRegister);
 S.RegisterDelphiFunction(@FormatSize, 'FormatSize', cdRegister);
 S.RegisterDelphiFunction(@PosLast, 'PosLast', cdRegister);
 S.RegisterDelphiFunction(@PosLastW, 'PosLastW', cdRegister);
 S.RegisterDelphiFunction(@PosW, 'PosW', cdRegister);
  S.RegisterDelphiFunction(@IsDelimiter, 'IsDelimiterW', cdRegister);
 S.RegisterDelphiFunction(@RemoveNonWordChars, 'RemoveNonWordChars', cdRegister);
 S.RegisterDelphiFunction(@IsQuoteChar, 'IsQuoteChar', cdRegister);
 S.RegisterDelphiFunction(@WrapText, 'WrapTextW', cdRegister);
 S.RegisterDelphiFunction(@PadText, 'PadText', cdRegister);
 S.RegisterDelphiFunction(@PadTextWithVariableLineLength, 'PadTextWithVariableLineLength', cdRegister);
 S.RegisterDelphiFunction(@StrPad, 'StrPadW', cdRegister);
 S.RegisterDelphiFunction(@StrPadLeft, 'StrPadLeftW', cdRegister);
 S.RegisterDelphiFunction(@StrRepeat, 'StrRepeatW', cdRegister);
 S.RegisterDelphiFunction(@StrReverse, 'StrReverseW', cdRegister);
  S.RegisterDelphiFunction(@DeleteArrayItem, 'DeleteArrayItem', cdRegister);
 S.RegisterDelphiFunction(@TrimStringArray, 'TrimStringArray', cdRegister);
 //S.RegisterDelphiFunction(@Trim, 'TrimWS', cdRegister);
 //S.RegisterDelphiFunction(@TrimLeft, 'TrimLeftWS', cdRegister);
 //S.RegisterDelphiFunction(@TrimRight, 'TrimRightWS', cdRegister);
 S.RegisterDelphiFunction(@ConsistsOfChars, 'ConsistsOfChars', cdRegister);
 S.RegisterDelphiFunction(@MaskMatch, 'MaskMatch', cdRegister);
 S.RegisterDelphiFunction(@UpperCase, 'UpperCaseW', cdRegister);
 S.RegisterDelphiFunction(@LowerCase, 'LowerCaseW', cdRegister);
 S.RegisterDelphiFunction(@UpperCaseFirst, 'UpperCaseFirst', cdRegister);
 S.RegisterDelphiFunction(@LowerCaseFirst, 'LowerCaseFirst', cdRegister);
 S.RegisterDelphiFunction(@StripAccelChars, 'StripAccelChars', cdRegister);

  end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileStreamW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileStreamW) do
  begin
    RegisterMethod(@TFileStreamW.LoadUnicodeFrom, 'LoadUnicodeFrom');
    RegisterConstructor(@TFileStreamW.Create, 'Create');
    RegisterConstructor(@TFileStreamW.CreateCustom, 'CreateCustom');
    RegisterPropertyHelper(@TFileStreamWFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TFileStreamWIsReadOnly_R,nil,'IsReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FileStreamW(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFileStreamW(CL);
end;

 
 
{ TPSImport_FileStreamW }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileStreamW.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FileStreamW(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileStreamW.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FileStreamW(ri);
  RIRegister_FileStreamW_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
