unit uPSI_InstFunc;
{
  by inno included func2
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
  TPSImport_InstFunc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 //function ExitSetupMsgBox: Boolean;
function ExpandConst(const S: String): String;
function ExpandConstEx(const S: String; const CustomConsts: array of String): String;
function ExpandConstEx2(const S: String; const CustomConsts: array of String;
  const DoExpandIndividualConst: Boolean): String;
function ExpandConstIfPrefixed(const S: String): String;
//function GetCustomMessageValue(const AName: String; var AValue: String): Boolean;
function EvalCheck(const Expression: String): Boolean;



{ compile-time registration functions }
procedure SIRegister_TSimpleStringList(CL: TPSPascalCompiler);
procedure SIRegister_InstFunc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_InstFunc_Routines(S: TPSExec);
procedure RIRegister_TSimpleStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_InstFunc(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Struct
  ,Int64Em
  ,MD5
  ,SHA1
  ,CmnFunc2
  ,InstFunc,ActiveX, ComObj, PathFunc, SimpleExpression  {InstFnc2};

var  DisableCodeConsts: Integer;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_InstFunc]);
end;

procedure RegisterTypeLibrary(const Filename: String);
var
  WideFilename: PWideChar;
  OleResult: HRESULT;
  TypeLib: ITypeLib;
begin
  WideFilename := StringToOleStr(PathExpand(Filename));
  if WideFilename = nil then
    OutOfMemoryError;
  try
    OleResult := LoadTypeLib(WideFilename, TypeLib);
    if OleResult <> S_OK then
      RaiseOleError('LoadTypeLib', OleResult);
    try
      OleResult := RegisterTypeLib(TypeLib, WideFilename, nil);
      if OleResult <> S_OK then
        RaiseOleError('RegisterTypeLib', OleResult);
    finally
      //TypeLib.Release;
    end;
  finally
    SysFreeString(WideFilename);
  end;
end;


procedure InitOle;
var
  OleResult: HRESULT;
begin
  OleResult := CoInitialize(nil);
  if FAILED(OleResult) then
    raise Exception.CreateFmt('CoInitialize failed (0x%.8x)', [OleResult]);
    { ^ doesn't use a SetupMessage since messages probably aren't loaded
      during 'initialization' section below, which calls this procedure }
end;


function ExpandConst(const S: String): String;
begin
  Result := ExpandConstEx2(S, [''], True);
end;

function ExpandConstEx(const S: String; const CustomConsts: array of String): String;
begin
  Result := ExpandConstEx2(S, CustomConsts, True);
end;

function ExpandConstEx2(const S: String; const CustomConsts: array of String;
  const DoExpandIndividualConst: Boolean): String;
var
  I, Start: Integer;
  Cnst, ReplaceWith: String;
begin
  Result := S;
  I := 1;
  while I <= Length(Result) do begin
    if Result[I] = '{' then begin
      if (I < Length(Result)) and (Result[I+1] = '{') then begin
        { Change '{{' to '{' if not in an embedded constant }
        Inc(I);
        Delete(Result, I, 1);
      end
      else begin
        Start := I;
        { Find the closing brace, skipping over any embedded constants }
        I := SkipPastConst(Result, I);
        if I = 0 then  { unclosed constant? }
          InternalError('Unclosed constant');
        Dec(I);  { 'I' now points to the closing brace }

        if DoExpandIndividualConst then begin
          { Now translate the constant }
          Cnst := Copy(Result, Start+1, I-(Start+1));
          //ReplaceWith := ExpandIndividualConst(Cnst, CustomConsts);
          Delete(Result, Start, (I+1)-Start);
          Insert(ReplaceWith, Result, Start);
          I := Start + Length(ReplaceWith);
          if (ReplaceWith <> '') and (PathLastChar(ReplaceWith)^ = '\') and
             (I <= Length(Result)) and (Result[I] = '\') then
            Delete(Result, I, 1);
        end else
          Inc(I); { Skip closing brace }
      end;
    end
    else begin
{$IFNDEF UNICODE}
      if Result[I] in ConstLeadBytes^ then
        Inc(I);
{$ENDIF}
      Inc(I);
    end;
  end;
end;

function ExpandConstIfPrefixed(const S: String): String;
const
  ExpandPrefix = 'expand:';
begin
  if Pos(ExpandPrefix, S) = 1 then begin
    Inc(DisableCodeConsts);
    try
      Result := ExpandConst(Copy(S, Length(ExpandPrefix)+1, Maxint));
    finally
      Dec(DisableCodeConsts);
    end;
  end
  else
    Result := S;
end;


type
  TDummyClass = class
    public
      {class function ExpandCheckOrInstallConstant(Sender: TSimpleExpression;
        const Constant: String): String;
      class function EvalInstallIdentifier(Sender: TSimpleExpression;
        const Name: String; const Parameters: array of const): Boolean;
      class function EvalComponentOrTaskIdentifier(Sender: TSimpleExpression;
        const Name: String; const Parameters: array of const): Boolean;
      class function EvalLanguageIdentifier(Sender: TSimpleExpression;
        const Name: String; const Parameters: array of const): Boolean;
      class function EvalCheckIdentifier(Sender: TSimpleExpression;
        const Name: String; const Parameters: array of const): Boolean;}
  end;


function EvalCheck(const Expression: String): Boolean;
var
  SimpleExpression: TSimpleExpression;
begin
  try
    SimpleExpression := TSimpleExpression.Create;
    try
      SimpleExpression.Lazy := True;
      SimpleExpression.Expression := Expression;
      //SimpleExpression.OnEvalIdentifier := TDummyClass.EvalCheckIdentifier;
      //SimpleExpression.OnExpandConstant := TDummyClass.ExpandCheckOrInstallConstant;
      SimpleExpression.ParametersAllowed := True;
      SimpleExpression.SilentOrAllowed := False;
      SimpleExpression.SingleIdentifierMode := False;
      Result := SimpleExpression.Eval;
    finally
      SimpleExpression.Free;
    end;
  except
    InternalError(Format('Expression error ''%s''', [GetExceptMessage]));
    Result := False;
  end;
end;

(*procedure LogWindowsVersion;
var
  SP: String;
begin
  if NTServicePackLevel <> 0 then begin
    SP := ' SP' + IntToStr(Hi(NTServicePackLevel));
    if Lo(NTServicePackLevel) <> 0 then
      SP := SP + '.' + IntToStr(Lo(NTServicePackLevel));
  end;
  LogFmt('Windows version: %u.%u.%u%s  (NT platform: %s)', [WindowsVersion shr 24,
    (WindowsVersion shr 16) and $FF, WindowsVersion and $FFFF, SP, SYesNo[IsNT]]);
  LogFmt('64-bit Windows: %s', [SYesNo[IsWin64]]);
  LogFmt('Processor architecture: %s', [SetupProcessorArchitectureNames[ProcessorArchitecture]]);

  if IsNT then begin
    if IsAdmin then
      Log('User privileges: Administrative')
    else if IsPowerUserOrAdmin then
      Log('User privileges: Power User')
    else
      Log('User privileges: None');
  end;
end;*)

function GetMessageBoxResultText(const AResult: Integer): String;
const
  IDTRYAGAIN = 10;
  IDCONTINUE = 11;
begin
  case AResult of
    IDOK: Result := 'OK';
    IDCANCEL: Result := 'Cancel';
    IDABORT: Result := 'Abort';
    IDRETRY: Result := 'Retry';
    IDIGNORE: Result := 'Ignore';
    IDYES: Result := 'Yes';
    IDNO: Result := 'No';
    IDTRYAGAIN: Result := 'Try Again';
    IDCONTINUE: Result := 'Continue';
  else
    Result := IntToStr(AResult);
  end;
end;

function GetButtonsText(const Buttons: Cardinal): String;
const
  { We don't use this type, but end users are liable to in [Code] }
  MB_CANCELTRYCONTINUE = $00000006;
begin
  case Buttons and MB_TYPEMASK of
    MB_OK: Result := 'OK';
    MB_OKCANCEL: Result := 'OK/Cancel';
    MB_ABORTRETRYIGNORE: Result := 'Abort/Retry/Ignore';
    MB_YESNOCANCEL: Result := 'Yes/No/Cancel';
    MB_YESNO: Result := 'Yes/No';
    MB_RETRYCANCEL: Result := 'Retry/Cancel';
    MB_CANCELTRYCONTINUE: Result := 'Cancel/Try Again/Continue';
  else
    Result := IntToStr(Buttons and MB_TYPEMASK);
  end;
end;




   (* function GetParamString(const Param, Default: String): String;
    var
      I, PCount: Integer;
      Z: String;
    begin
      PCount := NewParamCount();
      for I := 1 to PCount do begin
        Z := NewParamStr(I);
        if StrLIComp(PChar(Z), PChar('/'+Param+'='), Length(Param)+2) = 0 then begin
          Delete(Z, 1, Length(Param)+2);
          Result := Z;
          Exit;
        end;
      end;

      Result := Default;
    end;

  var
    Z, Param, Default, C: String;
    I: Integer;
  begin
    Delete(C, 1, 6);  { skip past 'param:' }
    Z := C;
    I := ConstPos('|', Z);  { check for a 'default' data }
    if I = 0 then
      I := Length(Z)+1;
    Default := Copy(Z, I+1, Maxint);
    SetLength(Z, I-1);
    Param := Z;
    if ConvertConstPercentStr(Param) and ConvertConstPercentStr(Default) then begin
      Param := ExpandConstEx(Param, CustomConsts);
      Default := ExpandConstEx(Default, CustomConsts);
      Result := GetParamString(Param, Default);
      Exit;
    end;
    { it will only reach here if there was a parsing error }
    InternalError('Failed to parse "param" constant');
  end; *)



{var
  WideFilename: WideString;
  OleResult: HRESULT;
  TypeLib: ITypeLib;
begin
  WideFilename := PathExpand(Filename);
  OleResult := LoadTypeLib(PWideChar(WideFilename), TypeLib);
  if OleResult <> S_OK then
    RaiseOleError('LoadTypeLib', OleResult);
  OleResult := RegisterTypeLib(TypeLib, PWideChar(WideFilename), nil);
  if OleResult <> S_OK then
    RaiseOleError('RegisterTypeLib', OleResult);
    //null;  }
//end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSimpleStringList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpleStringList') do begin
    RegisterMethod('Procedure Add( const S : String)');
    RegisterMethod('Procedure AddIfDoesntExist( const S : String)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IndexOf( const S : String) : Integer');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'String Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_InstFunc(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PSimpleStringListArray', '^TSimpleStringListArray // will not work');
  SIRegister_TSimpleStringList(CL);
  CL.AddTypeS('TExecWait', '( ewNoWait, ewWaitUntilTerminated, ewWaitUntilIdle)');
  CL.AddTypeS('TDetermineDefaultLanguageResult', '( ddNoMatch, ddMatch, ddMatchLangParameter )');
  CL.AddTypeS('TMD5Digest', 'array[0..15] of Byte;');
  CL.AddTypeS('TSHA1Digest', 'array[0..19] of Byte;');

   // TMD5Digest = array[0..15] of Byte;
  //     TSHA1Digest = array[0..19] of Byte;

 CL.AddDelphiFunction('Function CheckForMutexes( Mutexes : String) : Boolean');
 CL.AddDelphiFunction('Function CreateTempDir : String');
 CL.AddDelphiFunction('Function DecrementSharedCount( const RegView : TRegView; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Procedure DelayDeleteFile( const DisableFsRedir : Boolean; const Filename : String; const MaxTries, FirstRetryDelayMS, SubsequentRetryDelayMS : Integer)');
 //CL.AddDelphiFunction('Function DelTree( const DisableFsRedir : Boolean; const Path : String; const IsDir, DeleteFiles, DeleteSubdirsAlso, BreakOnError : Boolean; const DeleteDirProc : TDeleteDirProc; const DeleteFileProc : TDeleteFileProc; const Param : Pointer) : Boolean');
 //CL.AddDelphiFunction('Function DetermineDefaultLanguage( const GetLanguageEntryProc : TGetLanguageEntryProc; const Method : TSetupLanguageDetectionMethod; const LangParameter : String; var ResultIndex : Integer) : TDetermineDefaultLanguageResult');
 //CL.AddDelphiFunction('Procedure EnumFileReplaceOperationsFilenames( const EnumFunc : TEnumFROFilenamesProc; Param : Pointer)');
 CL.AddDelphiFunction('Function GenerateNonRandomUniqueFilename( Path : String; var Filename : String) : Boolean');
 CL.AddDelphiFunction('Function GenerateUniqueName( const DisableFsRedir : Boolean; Path : String; const Extension : String) : String');
 CL.AddDelphiFunction('Function GetComputerNameString : String');
 CL.AddDelphiFunction('Function GetFileDateTime( const DisableFsRedir : Boolean; const Filename : String; var DateTime : TFileTime) : Boolean');
 CL.AddDelphiFunction('Function GetMD5OfFile( const DisableFsRedir : Boolean; const Filename : String) : TMD5Digest');
 CL.AddDelphiFunction('Function GetMD5OfAnsiString( const S : AnsiString) : TMD5Digest');
// CL.AddDelphiFunction('Function GetMD5OfUnicodeString( const S : UnicodeString) : TMD5Digest');
 CL.AddDelphiFunction('Function GetSHA1OfFile( const DisableFsRedir : Boolean; const Filename : String) : TSHA1Digest');
 CL.AddDelphiFunction('Function GetSHA1OfAnsiString( const S : AnsiString) : TSHA1Digest');
// CL.AddDelphiFunction('Function GetSHA1OfUnicodeString( const S : UnicodeString) : TSHA1Digest');
 CL.AddDelphiFunction('Function GetRegRootKeyName( const RootKey : HKEY) : String');
 CL.AddDelphiFunction('Function GetSpaceOnDisk( const DisableFsRedir : Boolean; const DriveRoot : String; var FreeBytes, TotalBytes : Integer64) : Boolean');
 CL.AddDelphiFunction('Function GetSpaceOnNearestMountPoint( const DisableFsRedir : Boolean; const StartDir : String; var FreeBytes, TotalBytes : Integer64) : Boolean');
 CL.AddDelphiFunction('Function GetUserNameString : String');
 CL.AddDelphiFunction('Procedure IncrementSharedCount( const RegView : TRegView; const Filename : String; const AlreadyExisted : Boolean)');
 //CL.AddDelphiFunction('Function InstExec( const DisableFsRedir : Boolean; const Filename, Params : String; WorkingDir : String; const Wait : TExecWait; const ShowCmd : Integer; const ProcessMessagesProc : TProcedure; var ResultCode : Integer) : Boolean');
// CL.AddDelphiFunction('Function InstShellExec( const Verb, Filename, Params : String; WorkingDir : String; const Wait : TExecWait; const ShowCmd : Integer; const ProcessMessagesProc : TProcedure; var ResultCode : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure InternalError( const Id : String)');
 CL.AddDelphiFunction('Procedure InternalErrorFmt( const S : String; const Args : array of const)');
 CL.AddDelphiFunction('Function IsDirEmpty( const DisableFsRedir : Boolean; const Dir : String) : Boolean');
 CL.AddDelphiFunction('Function IsProtectedSystemFile( const DisableFsRedir : Boolean; const Filename : String) : Boolean');
 CL.AddDelphiFunction('Function MakePendingFileRenameOperationsChecksum : TMD5Digest');
 CL.AddDelphiFunction('Function ModifyPifFile( const Filename : String; const CloseOnExit : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure RaiseFunctionFailedError( const FunctionName : String)');
 CL.AddDelphiFunction('Procedure RaiseOleError( const FunctionName : String; const ResultCode : HRESULT)');
 CL.AddDelphiFunction('Procedure RefreshEnvironment');
 CL.AddDelphiFunction('Function ReplaceSystemDirWithSysWow64( const Path : String) : String');
 CL.AddDelphiFunction('Function ReplaceSystemDirWithSysNative( Path : String; const IsWin64 : Boolean) : String');
 CL.AddDelphiFunction('Procedure UnregisterFont( const FontName, FontFilename : String)');
 CL.AddDelphiFunction('Function RestartComputer : Boolean');
 CL.AddDelphiFunction('Procedure RestartReplace( const DisableFsRedir : Boolean; TempFile, DestFile : String)');
 CL.AddDelphiFunction('Procedure SplitNewParamStr( const Index : Integer; var AName, AValue : String)');
 CL.AddDelphiFunction('Procedure Win32ErrorMsg( const FunctionName : String)');
 CL.AddDelphiFunction('Procedure Win32ErrorMsgEx( const FunctionName : String; const ErrorCode : DWORD)');
 CL.AddDelphiFunction('Function inForceDirectories( const DisableFsRedir : Boolean; Dir : String) : Boolean');
 //Func2
 //CL.AddDelphiFunction('Function inCreateShellLink( const Filename, Description, ShortcutTo, Parameters, WorkingDir : String; IconFilename : String; const IconIndex, ShowCmd : Integer; const HotKey : Word; FolderShortcut : Boolean; '
   //         +' const AppUserModelID : String; const ExcludeFromShowInNewInstall, PreventPinning : Boolean) : String');
 //CL.AddDelphiFunction('Procedure RegisterTypeLibrary( const Filename : String)');
 //CL.AddDelphiFunction('Procedure UnregisterTypeLibrary( const Filename : String)');
 //CL.AddDelphiFunction('Function UnpinShellLink( const Filename : String) : Boolean');}
 CL.AddDelphiFunction('procedure InitOle;');
 // of inno main
 CL.AddDelphiFunction('Function ExpandConst( const S : String) : String');
 CL.AddDelphiFunction('Function ExpandConstEx( const S : String; const CustomConsts : array of String) : String');
 CL.AddDelphiFunction('Function ExpandConstEx2( const S : String; const CustomConsts : array of String; const DoExpandIndividualConst : Boolean) : String');
 CL.AddDelphiFunction('Function ExpandConstIfPrefixed( const S : String) : String');
 //CL.AddDelphiFunction('Procedure LogWindowsVersion');
 CL.AddDelphiFunction('Function EvalCheck( const Expression : String) : Boolean');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSimpleStringListItems_R(Self: TSimpleStringList; var T: String; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleStringListCount_R(Self: TSimpleStringList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_InstFunc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CheckForMutexes, 'CheckForMutexes', cdRegister);
 S.RegisterDelphiFunction(@CreateTempDir, 'CreateTempDir', cdRegister);
 S.RegisterDelphiFunction(@DecrementSharedCount, 'DecrementSharedCount', cdRegister);
 S.RegisterDelphiFunction(@DelayDeleteFile, 'DelayDeleteFile', cdRegister);
 S.RegisterDelphiFunction(@DelTree, 'DelTree', cdRegister);
 //S.RegisterDelphiFunction(@DetermineDefaultLanguage, 'DetermineDefaultLanguage', cdRegister);
 //S.RegisterDelphiFunction(@EnumFileReplaceOperationsFilenames, 'EnumFileReplaceOperationsFilenames', cdRegister);
 S.RegisterDelphiFunction(@GenerateNonRandomUniqueFilename, 'GenerateNonRandomUniqueFilename', cdRegister);
 S.RegisterDelphiFunction(@GenerateUniqueName, 'GenerateUniqueName', cdRegister);
 S.RegisterDelphiFunction(@GetComputerNameString, 'GetComputerNameString', cdRegister);
 S.RegisterDelphiFunction(@GetFileDateTime, 'GetFileDateTime', cdRegister);
 S.RegisterDelphiFunction(@GetMD5OfFile, 'GetMD5OfFile', cdRegister);
 S.RegisterDelphiFunction(@GetMD5OfAnsiString, 'GetMD5OfAnsiString', cdRegister);
 //S.RegisterDelphiFunction(@GetMD5OfUnicodeString, 'GetMD5OfUnicodeString', cdRegister);
 S.RegisterDelphiFunction(@GetSHA1OfFile, 'GetSHA1OfFile', cdRegister);
 S.RegisterDelphiFunction(@GetSHA1OfAnsiString, 'GetSHA1OfAnsiString', cdRegister);
 //S.RegisterDelphiFunction(@GetSHA1OfUnicodeString, 'GetSHA1OfUnicodeString', cdRegister);
 S.RegisterDelphiFunction(@GetRegRootKeyName, 'GetRegRootKeyName', cdRegister);
 S.RegisterDelphiFunction(@GetSpaceOnDisk, 'GetSpaceOnDisk', cdRegister);
 S.RegisterDelphiFunction(@GetSpaceOnNearestMountPoint, 'GetSpaceOnNearestMountPoint', cdRegister);
 S.RegisterDelphiFunction(@GetUserNameString, 'GetUserNameString', cdRegister);
 S.RegisterDelphiFunction(@IncrementSharedCount, 'IncrementSharedCount', cdRegister);
 //S.RegisterDelphiFunction(@InstExec, 'InstExec', cdRegister);
 //S.RegisterDelphiFunction(@InstShellExec, 'InstShellExec', cdRegister);
 S.RegisterDelphiFunction(@InternalError, 'InternalError', cdRegister);
 S.RegisterDelphiFunction(@InternalErrorFmt, 'InternalErrorFmt', cdRegister);
 S.RegisterDelphiFunction(@IsDirEmpty, 'IsDirEmpty', cdRegister);
 S.RegisterDelphiFunction(@IsProtectedSystemFile, 'IsProtectedSystemFile', cdRegister);
 S.RegisterDelphiFunction(@MakePendingFileRenameOperationsChecksum, 'MakePendingFileRenameOperationsChecksum', cdRegister);
 S.RegisterDelphiFunction(@ModifyPifFile, 'ModifyPifFile', cdRegister);
 S.RegisterDelphiFunction(@RaiseFunctionFailedError, 'RaiseFunctionFailedError', cdRegister);
 S.RegisterDelphiFunction(@RaiseOleError, 'RaiseOleError', cdRegister);
 S.RegisterDelphiFunction(@RefreshEnvironment, 'RefreshEnvironment', cdRegister);
 S.RegisterDelphiFunction(@ReplaceSystemDirWithSysWow64, 'ReplaceSystemDirWithSysWow64', cdRegister);
 S.RegisterDelphiFunction(@ReplaceSystemDirWithSysNative, 'ReplaceSystemDirWithSysNative', cdRegister);
 S.RegisterDelphiFunction(@UnregisterFont, 'UnregisterFont', cdRegister);
 S.RegisterDelphiFunction(@RestartComputer, 'RestartComputer', cdRegister);
 S.RegisterDelphiFunction(@RestartReplace, 'RestartReplace', cdRegister);
 S.RegisterDelphiFunction(@SplitNewParamStr, 'SplitNewParamStr', cdRegister);
 S.RegisterDelphiFunction(@Win32ErrorMsg, 'Win32ErrorMsg', cdRegister);
 S.RegisterDelphiFunction(@Win32ErrorMsgEx, 'Win32ErrorMsgEx', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'inForceDirectories', cdRegister);
 // S.RegisterDelphiFunction(@CreateShellLink, 'inCreateShellLink', cdRegister);
 //S.RegisterDelphiFunction(@RegisterTypeLibrary, 'RegisterTypeLibrary', cdRegister);
 //S.RegisterDelphiFunction(@UnregisterTypeLibrary, 'UnregisterTypeLibrary', cdRegister);
 //S.RegisterDelphiFunction(@UnpinShellLink, 'UnpinShellLink', cdRegister);}
 S.RegisterDelphiFunction(@InitOle, 'InitOLE', cdRegister);
 S.RegisterDelphiFunction(@ExpandConst, 'ExpandConst', cdRegister);
 S.RegisterDelphiFunction(@ExpandConstEx, 'ExpandConstEx', cdRegister);
 S.RegisterDelphiFunction(@ExpandConstEx2, 'ExpandConstEx2', cdRegister);
 S.RegisterDelphiFunction(@ExpandConstIfPrefixed, 'ExpandConstIfPrefixed', cdRegister);
 //S.RegisterDelphiFunction(@LogWindowsVersion, 'LogWindowsVersion', cdRegister);
 S.RegisterDelphiFunction(@EvalCheck, 'EvalCheck', cdRegister);


end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleStringList) do
  begin
    RegisterMethod(@TSimpleStringList.Add, 'Add');
    RegisterMethod(@TSimpleStringList.AddIfDoesntExist, 'AddIfDoesntExist');
    RegisterMethod(@TSimpleStringList.Clear, 'Clear');
    RegisterMethod(@TSimpleStringList.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TSimpleStringListCount_R,nil,'Count');
    RegisterPropertyHelper(@TSimpleStringListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_InstFunc(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSimpleStringList(CL);
end;

 
 
{ TPSImport_InstFunc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_InstFunc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_InstFunc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_InstFunc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_InstFunc(ri);
  RIRegister_InstFunc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
