unit uPSI_cWindows;
{
Tanother wway in hell   - add functions from cstrings and cinternetutils2   playstreamsound

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
  TPSImport_cWindows = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TfndTimerHandle(CL: TPSPascalCompiler);
procedure SIRegister_TTimerHandle(CL: TPSPascalCompiler);
procedure SIRegister_TfndWindowHandle(CL: TPSPascalCompiler);
procedure SIRegister_TWindowHandle(CL: TPSPascalCompiler);
procedure SIRegister_cWindows(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TfndTimerHandle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTimerHandle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TfndWindowHandle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWindowHandle(CL: TPSRuntimeClassImporter);
procedure RIRegister_cWindows_Routines(S: TPSExec);
procedure RIRegister_cWindows(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,cfundamentUtils
  ,cWindows
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cWindows]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TfndTimerHandle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTimerHandle', 'TfndTimerHandle') do
  with CL.AddClassN(CL.FindClass('TTimerHandle'),'TfndTimerHandle') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTimerHandle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWindowHandle', 'TTimerHandle') do
  with CL.AddClassN(CL.FindClass('TWindowHandle'),'TTimerHandle') do begin
   RegisterMethod('Procedure DestroyWindowHandle');
     RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterProperty('TimerInterval', 'Integer', iptrw);
    RegisterProperty('TimerActive', 'Boolean', iptrw);
    RegisterProperty('OnTimer', 'TTimerEventflc', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TfndWindowHandle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWindowHandle', 'TfndWindowHandle') do
  with CL.AddClassN(CL.FindClass('TWindowHandle'),'TfndWindowHandle') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWindowHandle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TWindowHandle') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TWindowHandle') do begin
    RegisterMethod('Procedure DestroyWindowHandle');
     RegisterMethod('Procedure Free;');
    RegisterProperty('WindowHandle', 'HWND', iptr);
    RegisterMethod('Function GetWindowHandle : HWND');
    RegisterMethod('Function ProcessMessage : Boolean');
    RegisterMethod('Procedure ProcessMessages');
    RegisterMethod('Function HandleMessage : Boolean');
    RegisterMethod('Procedure MessageLoop');
    RegisterProperty('OnMessage', 'TWindowHandleMessageEvent', iptrw);
    RegisterProperty('OnException', 'TWindowHandleErrorEvent', iptrw);
    RegisterProperty('OnBeforeMessage', 'TWindowHandleEvent', iptrw);
    RegisterProperty('OnAfterMessage', 'TWindowHandleEvent', iptrw);
    RegisterProperty('Terminated', 'Boolean', iptr);
    RegisterMethod('Procedure Terminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cWindows(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TWindowsVersionflc', '( Win16_31, Win32_95, Win32_95R2, Win32_98, W'
   +'in32_98SE, Win32_ME, Win32_Future, WinNT_31, WinNT_35, WinNT_351, WinNT_40'
   +', WinNT5_2000, WinNT5_XP, WinNT5_2003, WinNT5_Future, WinNT_Future, Win_Future )');
  CL.AddTypeS('TWindowsVersions', 'set of TWindowsVersionflc');
 CL.AddDelphiFunction('Function flcGetWindowsVersion : TWindowsVersionflc');
 CL.AddDelphiFunction('Function flcIsWinPlatform95 : Boolean');
 CL.AddDelphiFunction('Function flcIsWinPlatformNT : Boolean');
 CL.AddDelphiFunction('Function flcGetWindowsProductID : String');
 CL.AddDelphiFunction('Function flcGetWindowsTemporaryPath : String');
 CL.AddDelphiFunction('Function flcGetWindowsPath : String');
 CL.AddDelphiFunction('Function flcGetWindowsSystemPath : String');
 CL.AddDelphiFunction('Function flcGetProgramFilesPath : String');
 CL.AddDelphiFunction('Function flcGetCommonFilesPath : String');
 CL.AddDelphiFunction('Function flcGetApplicationPath : String');
 CL.AddDelphiFunction('Function flcGetUserName : String');
 CL.AddDelphiFunction('Function flcGetLocalComputerName : String');
 CL.AddDelphiFunction('Function flcGetLocalHostName : String');
  CL.AddTypeS('TVersionInfoflc', '( viFileVersion, viFileDescription, viLegalCopyr'
   +'ight,viComments, viCompanyName,viInternalName,viLegalTrademarks, viOriginalFilename,viProductName,viProductVersion )');
 CL.AddDelphiFunction('Function flcGetAppVersionInfo( const VersionInfo : TVersionInfoflc) : String');
 CL.AddDelphiFunction('Function flcWinExecute( const ExeName, Params : String; const ShowWin: Word; const Wait:Boolean): Boolean');
 CL.AddDelphiFunction('Function flcGetEnvironmentStrings : TStringArray');
 CL.AddDelphiFunction('Function flcContentTypeFromExtention( Extention : String) : String');
 CL.AddDelphiFunction('Function flcIsApplicationAutoRun( const Name : String) : Boolean');
 CL.AddDelphiFunction('Procedure flcSetApplicationAutoRun( const Name : String; const AutoRun : Boolean)');
 CL.AddDelphiFunction('Function flcGetWinPortNames : TStringArray');
 CL.AddDelphiFunction('Function flcGetKeyPressed( const VKeyCode : Integer) : Boolean');
 CL.AddDelphiFunction('Function flcGetHardDiskSerialNumber( const DriveLetter : Char) : String');
 CL.AddDelphiFunction('Function flcReboot : Boolean');
 //CL.AddDelphiFunction('Function ConvertThreadToFiber( lpParameter : Pointer) : Pointer');
 //CL.AddDelphiFunction('Function CreateFiber( dwStackSize : DWORD; lpStartAddress : TFNFiberStartRoutine; lpParameter : Pointer) : Pointer');
  CL.AddTypeS('TIEProxy', '( iepHTTP, iepHTTPS, iepFTP, iepGOPHER, iepSOCKS )');
 CL.AddDelphiFunction('Function GetIEProxy( const Protocol : TIEProxy) : String');
  CL.AddTypeS('TWindowHandleMessageEvent','Function (const Msg:Cardinal;const wParam,lParam:Integer;var Handled:Boolean):Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TWindowHandle');
  CL.AddTypeS('TWindowHandleEvent', 'Procedure ( const Sender : TWindowHandle)');
  CL.AddTypeS('TWindowHandleErrorEvent', 'Procedure ( const Sender : TWindowHandle; const E : Exception)');
  SIRegister_TWindowHandle(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWindowHandle');
  SIRegister_TfndWindowHandle(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTimerHandle');
  CL.AddTypeS('TTimerEventflc', 'Procedure ( const Sender : TTimerHandle)');
  SIRegister_TTimerHandle(CL);
  SIRegister_TfndTimerHandle(CL);
 CL.AddDelphiFunction('Procedure flcRaiseLastOSError');
 CL.AddDelphiFunction('Function flcStrEqualNoCase( const A, B : String; const AsciiCaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function flcStrMatchNoAsciiCase( const S, M : String; const Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function flcStrMatchLeft( const S, M : String; const AsciiCaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function flcStrMatchRight( const S, M : String; const AsciiCaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function flcPosChar( const F : Char; const S : String; const Index : Integer) : Integer');
 CL.AddDelphiFunction('Function flcPosStr( const F, S : String; const Index : Integer; const AsciiCaseSensitive : Boolean) : Integer');
 CL.AddDelphiFunction('Function flcStrMatch( const S, M : String; const Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function flcStrPMatch( const A, B : PChar; const Len : Integer) : Boolean');
 CL.AddDelphiFunction('Function flcflcCopyFrom( const S : String; const Index : Integer) : String');
 CL.AddDelphiFunction('Function flcCopyRange( const S : String; const StartIndex, StopIndex : Integer) : String');
 CL.AddDelphiFunction('Function flcCopyLeft( const S : String; const Count : Integer) : String');
 CL.AddDelphiFunction('Function flcCopyRight( const S : String; const Count : Integer) : String');
 CL.AddDelphiFunction('Function flcStrIsNumeric( const S : String) : Boolean');
 CL.AddDelphiFunction('Function flcStrMatchChar( const S : String; const M : TSYsCharSet) : Boolean');
 CL.AddDelphiFunction('Function flcStrSplitAtChar( const S : String; const C : Char; var Left, Right : String; const Optional : Boolean) : Boolean');
 CL.AddDelphiFunction('Function flcStrReplaceChar( const Find, Replace : Char; const S : String) : String');
 CL.AddDelphiFunction('Function flcStrInclSuffix( const S : String; const Suffix : String; const AsciiCaseSensitive : Boolean) : String');
 CL.AddDelphiFunction('Function flcStrRemoveCharDelimited( var S : String; const FirstDelim, SecondDelim : Char) : String');
 CL.AddDelphiFunction('Function flcStrSplit( const S, D : String) : TStringArray');
 CL.AddDelphiFunction('Procedure flcTrimInPlace( var S : String; const C : TSYsCharSet)');
 CL.AddDelphiFunction('Function flcTrimIn( S : String; const C : TSYsCharSet) : String');
 CL.AddDelphiFunction('Function flcStrAfterCharSet( const S : String; const D : TSYsCharSet) : String');
 CL.AddDelphiFunction('procedure StrSplit(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;');
 CL.AddDelphiFunction('function StrSplitF(Delimiter: Char; Str: string): TStringlist;');
 CL.AddDelphiFunction('function Int32toBytes(const Cint: Integer): TBytes;');
 CL.AddDelphiFunction('procedure FGPlayASound(const AResName: string);');
 CL.AddDelphiFunction('procedure FGPlayASound2(const AResName: string; atype: string);');
 CL.AddDelphiFunction('procedure PlayResWav(const AResName: string; atype: string);');
  CL.AddDelphiFunction('procedure PlayResWav2(const AResName: string; atype: string);');
  CL.AddDelphiFunction('procedure PlaySoundStreamSync(const AName: TMemoryStream; atype: string);');
  CL.AddDelphiFunction('procedure PlaySoundStreamAsync(const AName: TMemoryStream; atype: string);');
  CL.AddDelphiFunction('procedure PlaySoundStreamAsyncNoStop(const AName: TMemoryStream; atype: string);');
 CL.AddDelphiFunction('function AddQuantumToDateTime(const dt: TDateTime): TDateTime;');

 CL.AddDelphiFunction('Function IsIntResource( const ResID : PChar) : Boolean');
 CL.AddDelphiFunction('Function IsEqualResID2( const R1, R2 : PChar) : Boolean');
 CL.AddDelphiFunction('Function ResIDToStr( const ResID : PChar) : string');
 CL.AddDelphiFunction('Function GetRTFtext(Const RichEdit: TRichEdit): String;');
CL.AddDelphiFunction('function StrRemoveCharSet(const S: String; const C: TsysCharSet): String;');
CL.AddDelphiFunction('function GetTextBetween(const Start, Stop: String; var S, Between: String): Boolean;');


//end;

 //S.RegisterDelphiFunction(@StrAfterChar, 'flcStrAfterChar', cdRegister);

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTimerHandleOnTimer_W(Self: TTimerHandle; const T: TTimerEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TTimerHandleOnTimer_R(Self: TTimerHandle; var T: TTimerEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TTimerHandleTimerActive_W(Self: TTimerHandle; const T: Boolean);
begin Self.TimerActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TTimerHandleTimerActive_R(Self: TTimerHandle; var T: Boolean);
begin T := Self.TimerActive; end;

(*----------------------------------------------------------------------------*)
procedure TTimerHandleTimerInterval_W(Self: TTimerHandle; const T: Integer);
begin Self.TimerInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TTimerHandleTimerInterval_R(Self: TTimerHandle; var T: Integer);
begin T := Self.TimerInterval; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleTerminated_R(Self: TWindowHandle; var T: Boolean);
begin T := Self.Terminated; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnAfterMessage_W(Self: TWindowHandle; const T: TWindowHandleEvent);
begin Self.OnAfterMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnAfterMessage_R(Self: TWindowHandle; var T: TWindowHandleEvent);
begin T := Self.OnAfterMessage; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnBeforeMessage_W(Self: TWindowHandle; const T: TWindowHandleEvent);
begin Self.OnBeforeMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnBeforeMessage_R(Self: TWindowHandle; var T: TWindowHandleEvent);
begin T := Self.OnBeforeMessage; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnException_W(Self: TWindowHandle; const T: TWindowHandleErrorEvent);
begin Self.OnException := T; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnException_R(Self: TWindowHandle; var T: TWindowHandleErrorEvent);
begin T := Self.OnException; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnMessage_W(Self: TWindowHandle; const T: TWindowHandleMessageEvent);
begin Self.OnMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleOnMessage_R(Self: TWindowHandle; var T: TWindowHandleMessageEvent);
begin T := Self.OnMessage; end;

(*----------------------------------------------------------------------------*)
procedure TWindowHandleWindowHandle_R(Self: TWindowHandle; var T: HWND);
begin T := Self.WindowHandle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TfndTimerHandle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfndTimerHandle) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTimerHandle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTimerHandle) do begin
  //RegisterMethod('Procedure DestroyWindowHandle');
    // RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterConstructor(@TTimerHandle.Create, 'Create');
    RegisterMethod(@TTimerHandle.DestroyWindowHandle, 'DestroyWindowHandle');
    RegisterPropertyHelper(@TTimerHandleTimerInterval_R,@TTimerHandleTimerInterval_W,'TimerInterval');
    RegisterPropertyHelper(@TTimerHandleTimerActive_R,@TTimerHandleTimerActive_W,'TimerActive');
    RegisterPropertyHelper(@TTimerHandleOnTimer_R,@TTimerHandleOnTimer_W,'OnTimer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TfndWindowHandle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfndWindowHandle) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWindowHandle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWindowHandle) do begin
    RegisterVirtualMethod(@TWindowHandle.DestroyWindowHandle, 'DestroyWindowHandle');
     RegisterMethod(@TWindowHandle.Destroy, 'Free');
    RegisterPropertyHelper(@TWindowHandleWindowHandle_R,nil,'WindowHandle');
    RegisterMethod(@TWindowHandle.GetWindowHandle, 'GetWindowHandle');
    RegisterMethod(@TWindowHandle.ProcessMessage, 'ProcessMessage');
    RegisterMethod(@TWindowHandle.ProcessMessages, 'ProcessMessages');
    RegisterMethod(@TWindowHandle.HandleMessage, 'HandleMessage');
    RegisterMethod(@TWindowHandle.MessageLoop, 'MessageLoop');
    RegisterPropertyHelper(@TWindowHandleOnMessage_R,@TWindowHandleOnMessage_W,'OnMessage');
    RegisterPropertyHelper(@TWindowHandleOnException_R,@TWindowHandleOnException_W,'OnException');
    RegisterPropertyHelper(@TWindowHandleOnBeforeMessage_R,@TWindowHandleOnBeforeMessage_W,'OnBeforeMessage');
    RegisterPropertyHelper(@TWindowHandleOnAfterMessage_R,@TWindowHandleOnAfterMessage_W,'OnAfterMessage');
    RegisterPropertyHelper(@TWindowHandleTerminated_R,nil,'Terminated');
    RegisterVirtualMethod(@TWindowHandle.Terminate, 'Terminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cWindows_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@GetWindowsVersion, 'GetWindowsVersion', cdRegister);
 S.RegisterDelphiFunction(@IsWinPlatform95, 'flcIsWinPlatform95', cdRegister);
 S.RegisterDelphiFunction(@IsWinPlatformNT, 'flcIsWinPlatformNT', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsProductID, 'flcGetWindowsProductID', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsTemporaryPath, 'flcGetWindowsTemporaryPath', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsPath, 'flcGetWindowsPath', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsSystemPath, 'flcGetWindowsSystemPath', cdRegister);
 S.RegisterDelphiFunction(@GetProgramFilesPath, 'flcGetProgramFilesPath', cdRegister);
 S.RegisterDelphiFunction(@GetCommonFilesPath, 'flcGetCommonFilesPath', cdRegister);
 S.RegisterDelphiFunction(@GetApplicationPath, 'flcGetApplicationPath', cdRegister);
 S.RegisterDelphiFunction(@GetUserName, 'flcGetUserName', cdRegister);
 S.RegisterDelphiFunction(@GetLocalComputerName, 'flcGetLocalComputerName', cdRegister);
 S.RegisterDelphiFunction(@GetLocalHostName, 'flcGetLocalHostName', cdRegister);
 S.RegisterDelphiFunction(@GetAppVersionInfo, 'flcGetAppVersionInfo', cdRegister);
 S.RegisterDelphiFunction(@WinExecute, 'flcWinExecute', cdRegister);
 S.RegisterDelphiFunction(@GetEnvironmentStrings, 'flcGetEnvironmentStrings', cdRegister);
 S.RegisterDelphiFunction(@ContentTypeFromExtention, 'flcContentTypeFromExtention', cdRegister);
 S.RegisterDelphiFunction(@IsApplicationAutoRun, 'flcIsApplicationAutoRun', cdRegister);
 S.RegisterDelphiFunction(@SetApplicationAutoRun, 'flcSetApplicationAutoRun', cdRegister);
 S.RegisterDelphiFunction(@GetWinPortNames, 'flcGetWinPortNames', cdRegister);
 S.RegisterDelphiFunction(@GetKeyPressed, 'flcGetKeyPressed', cdRegister);
 S.RegisterDelphiFunction(@GetHardDiskSerialNumber, 'flcGetHardDiskSerialNumber', cdRegister);
 S.RegisterDelphiFunction(@Reboot, 'flcReboot', cdRegister);
 S.RegisterDelphiFunction(@ConvertThreadToFiber, 'flcConvertThreadToFiber', CdStdCall);
 S.RegisterDelphiFunction(@CreateFiber, 'flcCreateFiber', CdStdCall);
 S.RegisterDelphiFunction(@GetIEProxy, 'flcGetIEProxy', cdRegister);
 S.RegisterDelphiFunction(@StrEqualNoCase, 'flcStrEqualNoCase', cdRegister);
 S.RegisterDelphiFunction(@StrMatchNoAsciiCase, 'flcStrMatchNoAsciiCase', cdRegister);
 S.RegisterDelphiFunction(@StrMatchLeft, 'flcStrMatchLeft', cdRegister);
 S.RegisterDelphiFunction(@StrMatchRight, 'flcStrMatchRight', cdRegister);
 S.RegisterDelphiFunction(@PosChar, 'flcPosChar', cdRegister);
 S.RegisterDelphiFunction(@PosStr, 'flcPosStr', cdRegister);
 S.RegisterDelphiFunction(@StrMatch, 'flcStrMatch', cdRegister);
 S.RegisterDelphiFunction(@StrPMatch, 'flcStrPMatch', cdRegister);
 S.RegisterDelphiFunction(@CopyFrom, 'flcflcCopyFrom', cdRegister);
 S.RegisterDelphiFunction(@CopyRange, 'flcCopyRange', cdRegister);
 S.RegisterDelphiFunction(@CopyLeft, 'flcCopyLeft', cdRegister);
 S.RegisterDelphiFunction(@CopyRight, 'flcCopyRight', cdRegister);
 S.RegisterDelphiFunction(@StrIsNumeric, 'flcStrIsNumeric', cdRegister);
 S.RegisterDelphiFunction(@StrMatchChar, 'flcStrMatchChar', cdRegister);
 S.RegisterDelphiFunction(@StrSplitAtChar, 'flcStrSplitAtChar', cdRegister);
 S.RegisterDelphiFunction(@StrReplaceChar, 'flcStrReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@StrInclSuffix, 'flcStrInclSuffix', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveCharDelimited, 'flcStrRemoveCharDelimited', cdRegister);
 S.RegisterDelphiFunction(@StrSplit, 'flcStrSplit', cdRegister);
 S.RegisterDelphiFunction(@TrimInPlace, 'flcTrimInPlace', cdRegister);
 S.RegisterDelphiFunction(@TrimIn, 'flcTrimIn', cdRegister);
 S.RegisterDelphiFunction(@StrAfterCharSet, 'flcStrAfterCharSet', cdRegister);
 S.RegisterDelphiFunction(@StrAfterChar, 'flcStrAfterChar', cdRegister);
 S.RegisterDelphiFunction(@StrSplit4, 'StrSplit', cdRegister);
 S.RegisterDelphiFunction(@StrSplit4F, 'StrSplitF', cdRegister);
 S.RegisterDelphiFunction(@int32tobytes, 'int32tobytes', cdRegister);
 S.RegisterDelphiFunction(@FGPlayASound, 'FGPlayASound', cdRegister);
 S.RegisterDelphiFunction(@FGPlayASound2, 'FGPlayASound2', cdRegister);
 S.RegisterDelphiFunction(@FGPlayASound2, 'PlayResWav', cdRegister);
 S.RegisterDelphiFunction(@FGPlayASound2sync, 'PlayResWav2', cdRegister);
 S.RegisterDelphiFunction(@AddQuantumToDateTime, 'AddQuantumToDateTime', cdRegister);
 S.RegisterDelphiFunction(@IsIntResource, 'IsIntResource', cdRegister);
 S.RegisterDelphiFunction(@IsEqualResID, 'IsEqualResID2', cdRegister);
 S.RegisterDelphiFunction(@ResIDToStr, 'ResIDToStr', cdRegister);
 S.RegisterDelphiFunction(@GetRTFtext, 'GetRTFtext', cdRegister);
 S.RegisterDelphiFunction(@StrRemoveCharSet, 'StrRemoveCharSet', cdRegister);
 S.RegisterDelphiFunction(@GetTextBetween, 'GetTextBetween', cdRegister);
 S.RegisterDelphiFunction(@FGPlayASound3Stream, 'PlaySoundStreamSync', cdRegister);
 S.RegisterDelphiFunction(@FGPlayASound4Stream, 'PlaySoundStreamAsync', cdRegister);
 S.RegisterDelphiFunction(@FGPlayASound5Stream, 'PlaySoundStreamAsyncNoStop', cdRegister);

  //CL.AddDelphiFunction('procedure PlaySoundStreamSync(const AName: TMemoryStream; atype: string);');
  //CL.AddDelphiFunction('procedure PlaySoundStreamAsync(const AName: TMemoryStream; atype: string);');

 //CL.AddDelphiFunction('function StrSplit4F(Delimiter: Char; Str: string): TStrings;');
 
 S.RegisterDelphiFunction(@RaiseLastOSError, 'flcRaiseLastOSError', cdRegister);
end;

procedure RIRegister_cWindows(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWindowHandle) do
  RIRegister_TWindowHandle(CL);
  with CL.Add(EWindowHandle) do
  RIRegister_TfndWindowHandle(CL);
  with CL.Add(TTimerHandle) do
  RIRegister_TTimerHandle(CL);
  RIRegister_TfndTimerHandle(CL);
end;

 
 
{ TPSImport_cWindows }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cWindows.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cWindows(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cWindows.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cWindows_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
