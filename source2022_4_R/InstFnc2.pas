unit InstFnc2;

{
  Inno Setup
  Copyright (C) 1997-2010 Jordan Russell
  Portions by Martijn Laan
  For conditions of distribution and use, see LICENSE.TXT.

  OLE-related installation functions
}

interface

{$I VERSION.INC}

function CreateShellLink(const Filename, Description, ShortcutTo, Parameters,
  WorkingDir: String; IconFilename: String; const IconIndex, ShowCmd: Integer;
  const HotKey: Word; FolderShortcut: Boolean; const AppUserModelID: String;
  const ExcludeFromShowInNewInstall, PreventPinning: Boolean): String;
procedure RegisterTypeLibrary(const Filename: String);
procedure UnregisterTypeLibrary(const Filename: String);
function UnpinShellLink(const Filename: String): Boolean;

implementation

uses
  Windows, SysUtils, PathFunc, CmnFunc2, InstFunc, {Main,} Msgs, MsgIDs,
  {$IFNDEF Delphi3orHigher} OLE2, {$ELSE} ActiveX, ComObj, {$ENDIF}
  {$IFDEF IS_D14} PropSys, {$ENDIF}
  ShellAPI, ShlObj;


{function ReadReg(Base: HKEY; KeyName, ValueName: string): string;
begin
  with TRegistry.Create do begin
    RootKey := Base;
    OpenKey(KeyName, False);
    try
      if ValueExists(ValueName) then
        Result := ReadString(ValueName)
      else
        Result := '';
    except
      Result := '';
    end;
    Free;
  end;
end;

function GetOSNumber: string;
begin
  Result:= ReadReg(HKEY_LOCAL_MACHINE, cOSCurrentKey[IsNT], 'VersionNumber');
end;}

function GetOsVersionInfo: TOSVersionInfo;
var
  verInfo: TOSVersionInfo;
begin
  verinfo.dwOSVersionInfoSize:= sizeof(verinfo);
  GetVersionEx(Verinfo);
  result:= Verinfo;
end;

function IsWin64: Boolean;
{Returns true if the current process is executing as a 32 bit process under
WOW64 on 64 bit Windows. s gives status message}
type
  TIsWow64Process = function(// Type of IsWow64Process API fn
      Handle: Windows.THandle; var Res: Windows.BOOL): Windows.BOOL; stdcall;
var
  IsWow64Result: Windows.BOOL; // Result from IsWow64Process
  IsWow64Process: TIsWow64Process; // IsWow64Process fn reference
begin
  Result:= False;
// Try to load required function from kernel32
  IsWow64Process:= Windows.GetProcAddress(Windows.GetModuleHandle('kernel32'), 'IsWow64Process');
if Assigned(IsWow64Process) then
  if IsWow64Process(Windows.GetCurrentProcess, IsWow64Result) then
    Result:= IsWow64Result;
{if Result then s := 'Process is running on Wow64'
else s := 'Process is NOT running on Wow64';
end else s := 'IsWow64 call failed';
end else s := 'IsWow64Process not present in kernel32.dll';}
end;




function IsWindowsXP: Boolean;
{ Returns True if running Windows XP or later }
begin
  Result := (getOSVersionInfo.dwMajorVersion >= Cardinal($05010000));
end;

function IsWindowsVista: Boolean;
{ Returns True if running Windows Vista or later }
begin
  Result := (getOSVersionInfo.dwMajorVersion >= Cardinal($06000000));
end;

function IsWindows7: Boolean;
{ Returns True if running Windows 7 or later }
begin
  Result := (getOSVersionInfo.dwMajorVersion >= Cardinal($06010000));
end;

function IsWindows8: Boolean;
{ Returns True if running Windows 8 or later }
begin
  Result := (getOSVersionInfo.dwMajorVersion >= Cardinal($06020000));
end;



(*function ExpandIndividualConst(const Cnst: String;
  const CustomConsts: array of String): String;
{ Cnst must be the name of a single constant, without the braces.
For example: app
IsPath is set to True if the result is a path which needs special trailing-
backslash handling. }

  procedure NoUninstallConstError(const C: String);
  begin
    InternalError(Format('Cannot evaluate "%s" constant during Uninstall', [C]));
  end;

  function ExpandEnvConst(C: String): String;
  var
    I: Integer;
    VarName, Default: String;
  begin
    Delete(C, 1, 1);
    I := ConstPos('|', C); { check for 'default' value }
    if I = 0 then
      I := Length(C)+1;
    VarName := Copy(C, 1, I-1);
    Default := Copy(C, I+1, Maxint);
    Result := '';
    if ConvertConstPercentStr(VarName) and ConvertConstPercentStr(Default) then begin
      Result := GetEnv(ExpandConstEx(VarName, CustomConsts));
      if Result = '' then
        Result := ExpandConstEx(Default, CustomConsts);
    end;
  end;

  function ExpandRegConst(C: String): String;
  { Expands a registry-value constant in the form:
reg:HKxx\SubkeyName,ValueName|DefaultValue }
  type
    TKeyNameConst = packed record
      KeyName: String;
      KeyConst: HKEY;
    end;
  const
    KeyNameConsts: array[0..4] of TKeyNameConst = (
      (KeyName: 'HKCR'; KeyConst: HKEY_CLASSES_ROOT),
      (KeyName: 'HKCU'; KeyConst: HKEY_CURRENT_USER),
      (KeyName: 'HKLM'; KeyConst: HKEY_LOCAL_MACHINE),
      (KeyName: 'HKU'; KeyConst: HKEY_USERS),
      (KeyName: 'HKCC'; KeyConst: HKEY_CURRENT_CONFIG));
  var
    Z, Subkey, Value, Default: String;
    I, J, L: Integer;
    RegView: TRegView;
    RootKey: HKEY;
    K: HKEY;
  begin
    Delete(C, 1, 4); { skip past 'reg:' }
    I := ConstPos('\', C);
    if I <> 0 then begin
      Z := Copy(C, 1, I-1);
      if Z <> '' then begin
        RegView := InstallDefaultRegView;
        L := Length(Z);
        if L >= 2 then begin
          { Check for '32' or '64' suffix }
          if (Z[L-1] = '3') and (Z[L] = '2') then begin
            RegView := rv32Bit;
            SetLength(Z, L-2);
          end
          else if (Z[L-1] = '6') and (Z[L] = '4') then begin
            if not IsWin64 then
              InternalError('Cannot access a 64-bit key in a "reg" constant on this version of Windows');
            RegView := rv64Bit;
            SetLength(Z, L-2);
          end;
        end;
        RootKey := 0;
        for J := Low(KeyNameConsts) to High(KeyNameConsts) do
          if CompareText(KeyNameConsts[J].KeyName, Z) = 0 then begin
            RootKey := KeyNameConsts[J].KeyConst;
            Break;
          end;
        if RootKey <> 0 then begin
          Z := Copy(C, I+1, Maxint);
          I := ConstPos('|', Z); { check for a 'default' data }
          if I = 0 then
            I := Length(Z)+1;
          Default := Copy(Z, I+1, Maxint);
          SetLength(Z, I-1);
          I := ConstPos(',', Z); { comma separates subkey and value }
          if I <> 0 then begin
            Subkey := Copy(Z, 1, I-1);
            Value := Copy(Z, I+1, Maxint);
            if ConvertConstPercentStr(Subkey) and ConvertConstPercentStr(Value) and
               ConvertConstPercentStr(Default) then begin
              Result := ExpandConstEx(Default, CustomConsts);
              if RegOpenKeyExView(RegView, RootKey,
                 PChar(ExpandConstEx(Subkey, CustomConsts)),
                 0, KEY_QUERY_VALUE, K) = ERROR_SUCCESS then begin
                RegQueryStringValue(K, PChar(ExpandConstEx(Value, CustomConsts)),
                  Result);
                RegCloseKey(K);
              end;
              Exit;
            end;
          end;
        end;
      end;
    end;
    { it will only reach here if there was a parsing error }
    InternalError('Failed to parse "reg" constant');
  end;

  function ExpandIniConst(C: String): String;
  { Expands an INI-value constant in the form:
filename,section,key|defaultvalue }
  var
    Z, Filename, Section, Key, Default: String;
    I: Integer;
  begin
    Delete(C, 1, 4); { skip past 'ini:' }
    I := ConstPos(',', C);
    if I <> 0 then begin
      Z := Copy(C, 1, I-1);
      if Z <> '' then begin
        Filename := Z;
        Z := Copy(C, I+1, Maxint);
        I := ConstPos('|', Z); { check for a 'default' data }
        if I = 0 then
          I := Length(Z)+1;
        Default := Copy(Z, I+1, Maxint);
        SetLength(Z, I-1);
        I := ConstPos(',', Z); { comma separates section and key }
        if I <> 0 then begin
          Section := Copy(Z, 1, I-1);
          Key := Copy(Z, I+1, Maxint);
          if ConvertConstPercentStr(Filename) and ConvertConstPercentStr(Section) and ConvertConstPercentStr(Key) and
             ConvertConstPercentStr(Default) then begin
            Filename := ExpandConstEx(Filename, CustomConsts);
            Section := ExpandConstEx(Section, CustomConsts);
            Key := ExpandConstEx(Key, CustomConsts);
            Default := ExpandConstEx(Default, CustomConsts);
            Result := GetIniString(Section, Key, Default, Filename);
            Exit;
          end;
        end;
      end;
    end;
    { it will only reach here if there was a parsing error }
    InternalError('Failed to parse "ini" constant');
  end;

  function ExpandParamConst(C: String): String;
  { Expands an commandline-parameter-value constant in the form:
parametername|defaultvalue }

    function GetParamString(const Param, Default: String): String;
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
    Z, Param, Default: String;
    I: Integer;
  begin
    Delete(C, 1, 6); { skip past 'param:' }
    Z := C;
    I := ConstPos('|', Z); { check for a 'default' data }
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
        if I = 0 then { unclosed constant? }
          InternalError('Unclosed constant');
        Dec(I); { 'I' now points to the closing brace }

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


function ExpandConst(const S: String; const CustomConsts: array of String): String;
begin
  Result := ExpandConstEx2(S, CustomConsts, True);
end;


procedure AssignWorkingDir(const SL: IShellLink; const WorkingDir: String);
{ Assigns the specified working directory to SL. If WorkingDir is empty then
  we select one ourself as best we can. (Leaving the working directory field
  empty is a security risk.) Note: SL.SetPath must be called first. }
var
  Dir: String;
  Buf: array[0..1023] of Char;
begin
  { Try any caller-supplied WorkingDir first }
  if WorkingDir <> '' then
    { SetWorkingDirectory *shouldn't* fail, but we might as well check }
    if SL.SetWorkingDirectory(PChar(WorkingDir)) = S_OK then
      Exit;

  { Otherwise, try to extract a directory name from the shortcut's target
    filename. We use GetPath to retrieve the filename as it will expand any
    environment strings. }
  if SL.GetPath(Buf, SizeOf(Buf) div SizeOf(Buf[0]), TWin32FindData(nil^), 0) = S_OK then begin
    Dir := PathExtractDir(PathExpand(Buf));
    if SL.SetWorkingDirectory(PChar(Dir)) = S_OK then
      Exit;
  end;

  { As a last resort, use the system directory }
  Dir := GetSystemDir;
  SL.SetWorkingDirectory(PChar(Dir));
end;

function GetResultingFilename(const PF: IPersistFile;
  const OriginalFilename: String): String;
{ Determines the actual resulting filename. IPersistFile::Save doesn't always
  save to the specified filename; it may rename the extension to .pif if the
  shortcut points to an MS-DOS application. }
var
  CurFilename: PWideChar;
  OleResult: HRESULT;
begin
  Result := '';
  CurFilename := nil;
  OleResult := PF.GetCurFile(CurFilename);
  { Note: Prior to Windows 2000/Me, GetCurFile succeeds but returns a NULL
    pointer }
  if SUCCEEDED(OleResult) and Assigned(CurFilename) then begin
    if OleResult = S_OK then
      Result := WideCharToString(CurFilename);
    CoTaskMemFree(CurFilename);
  end;
  { If GetCurFile didn't work (e.g. not running Windows 2000/Me or later), we
    have no choice but to try to guess the filename }
  if Result = '' then begin
    if NewFileExists(OriginalFilename) then
      Result := OriginalFilename
    else if NewFileExists(PathChangeExt(OriginalFilename, '.pif')) then
      Result := PathChangeExt(OriginalFilename, '.pif')
    else begin
      { Neither exist? Shouldn't happen, but return something anyway }
      Result := OriginalFilename;
    end;
  end;
end;

{$IFNDEF UNICODE}
type
  TPropertyKey = packed record
    fmtid: TGUID;
    pid: DWORD;
  end;

{$IFNDEF IS_D4}
  TPropVariant = TVariantArg;
{$ENDIF}

{$IFNDEF Delphi3orHigher}
const
  IID_IPropertyStore: TGUID = (
    D1:$886d8eeb; D2:$8cf2; D3:$4446; D4:($8d,$02,$cd,$ba,$1d,$bd,$cf,$99));

type
  IPropertyStore = class(IUnknown)
    function GetCount(var cProps: DWORD): HResult; virtual; stdcall; abstract;
    function GetAt(iProp: DWORD; var pkey: TPropertyKey): HResult; virtual; stdcall; abstract;
    function GetValue(const key: TPropertyKey; var pv: TPropVariant): HResult; virtual; stdcall; abstract;
    function SetValue(const key: TPropertyKey; const propvar: TPropVariant): HResult; virtual; stdcall; abstract;
    function Commit: HResult; virtual; stdcall; abstract;
  end;
{$ELSE}
{$IFNDEF IS_D14}
type
  IPropertyStore = interface(IUnknown)
    ['{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}']
    function GetCount(var cProps: DWORD): HResult; stdcall;
    function GetAt(iProp: DWORD; var pkey: TPropertyKey): HResult; stdcall;
    function GetValue(const key: TPropertyKey; var pv: TPropVariant): HResult; stdcall;
    function SetValue(const key: TPropertyKey; const propvar: TPropVariant): HResult; stdcall;
    function Commit: HResult; stdcall;
  end;
{$ENDIF}
{$ENDIF}
{$ENDIF}

function CreateShellLink(const Filename, Description, ShortcutTo, Parameters,
  WorkingDir: String; IconFilename: String; const IconIndex, ShowCmd: Integer;
  const HotKey: Word; FolderShortcut: Boolean; const AppUserModelID: String;
  const ExcludeFromShowInNewInstall, PreventPinning: Boolean): String;
{ Creates a lnk file named Filename, with a description of Description, with a
  HotKey hotkey, which points to ShortcutTo. Filename should be a full path.
  NOTE! If you want to copy this procedure for use in your own application
  be sure to call CoInitialize at application startup and CoUninitialize at
  application shutdown. See the bottom of this unit for an example. But this
  is not necessary if you are using Delphi 3 and your project already 'uses'
  the ComObj RTL unit. }
const
  CLSID_FolderShortcut: TGUID = (
    D1:$0AFACED1; D2:$E828; D3:$11D1; D4:($91,$87,$B5,$32,$F1,$E9,$57,$5D));
  PKEY_AppUserModel_ID: TPropertyKey = (
    fmtid: (D1:$9F4C2855; D2:$9F79; D3:$4B39; D4:($A8,$D0,$E1,$D4,$2D,$E1,$D5,$F3));
    pid: 5);
  PKEY_AppUserModel_ExcludeFromShowInNewInstall: TPropertyKey = (
    fmtid: (D1:$9F4C2855; D2:$9F79; D3:$4B39; D4:($A8,$D0,$E1,$D4,$2D,$E1,$D5,$F3));
    pid: 8);
  PKEY_AppUserModel_PreventPinning: TPropertyKey = (
    fmtid: (D1:$9F4C2855; D2:$9F79; D3:$4B39; D4:($A8,$D0,$E1,$D4,$2D,$E1,$D5,$F3));
    pid: 9);
  PKEY_AppUserModel_StartPinOption: TPropertyKey = (
    fmtid: (D1:$9F4C2855; D2:$9F79; D3:$4B39; D4:($A8,$D0,$E1,$D4,$2D,$E1,$D5,$F3));
    pid: 12);
  APPUSERMODEL_STARTPINOPTION_NOPINONINSTALL = 1;

{$IFNDEF Delphi3OrHigher}
var
  OleResult: HRESULT;
  SL: IShellLink;
  PS: IPropertyStore;
  PV: TPropVariant;
  PF: IPersistFile;
  WideFilename: PWideChar;
begin
  if FolderShortcut then
    OleResult := CoCreateInstance(CLSID_FolderShortcut, nil, CLSCTX_INPROC_SERVER,
      IID_IShellLink, SL)
  else
    OleResult := E_FAIL;
  { If a folder shortcut wasn't requested, or if CoCreateInstance failed
    because the user isn't running Windows 2000/Me or later, create a normal
    shell link instead }
  if OleResult <> S_OK then begin
    FolderShortcut := False;
    OleResult := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
       IID_IShellLink, SL);
    if OleResult <> S_OK then
      RaiseOleError('CoCreateInstance', OleResult);
  end;
  PF := nil;
  PS := nil;
  WideFilename := nil;
  try
    SL.SetPath(PChar(ShortcutTo));
    SL.SetArguments(PChar(Parameters));
    if not FolderShortcut then
      AssignWorkingDir(SL, WorkingDir);
    if IconFilename <> '' then begin
      { Work around a 64-bit Windows bug. It replaces pf32 with %ProgramFiles%
      which is wrong. This causes an error when the user tries to change the
      icon of the installed shortcut. Note that the icon does actually display
      fine because it *also* stores the original 'non replaced' path in the
      shortcut. } 
      if IsWin64 then
        StringChangeEx(IconFileName, ExpandConst('{pf32}\'), '%ProgramFiles(x86)%\', True);
      SL.SetIconLocation(PChar(IconFilename), IconIndex);
    end;
    SL.SetShowCmd(ShowCmd);
    if Description <> '' then
      SL.SetDescription(PChar(Description));
    if HotKey <> 0 then
      SL.SetHotKey(HotKey);

    { Note: Vista and newer support IPropertyStore but Vista errors if you try to
      commit a PKEY_AppUserModel_ID, so avoid setting the property on Vista. }
    if IsWindows7 and ((AppUserModelID <> '') or ExcludeFromShowInNewInstall or PreventPinning) then begin
      OleResult := SL.QueryInterface(IID_IPropertyStore, PS);
      if OleResult <> S_OK then
        RaiseOleError('IShellLink::QueryInterface(IID_IPropertyStore)', OleResult);
      { According to MSDN the PreventPinning property should be set before the ID property. In practice
        this doesn't seem to matter - at least not for shortcuts - but do it first anyway. }
      if PreventPinning then begin
        PV.vt := VT_BOOL;
        Smallint(PV.vbool) := -1;
        OleResult := PS.SetValue(PKEY_AppUserModel_PreventPinning, PV);
        if OleResult <> S_OK then
          RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_PreventPinning)', OleResult);
      end;
      if (AppUserModelID <> '') then begin
        PV.vt := VT_BSTR;
        PV.bstrVal := StringToOleStr(AppUserModelID);
        if PV.bstrVal = nil then
          OutOfMemoryError;
        try
          OleResult := PS.SetValue(PKEY_AppUserModel_ID, PV);
          if OleResult <> S_OK then
            RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_ID)', OleResult);
        finally
          SysFreeString(PV.bstrVal);
        end;
      end;
      if ExcludeFromShowInNewInstall then begin
        PV.vt := VT_BOOL;
        Smallint(PV.vbool) := -1;
        OleResult := PS.SetValue(PKEY_AppUserModel_ExcludeFromShowInNewInstall, PV);
        if OleResult <> S_OK then
          RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_ExcludeFromShowInNewInstall)', OleResult);
        if IsWindows8 then begin
          PV.vt := VT_UI4;
          PV.lVal := APPUSERMODEL_STARTPINOPTION_NOPINONINSTALL;
          OleResult := PS.SetValue(PKEY_AppUserModel_StartPinOption, PV);
          if OleResult <> S_OK then
            RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_StartPinOption)', OleResult);
        end;
      end;
      OleResult := PS.Commit;
      if OleResult <> S_OK then
        RaiseOleError('IPropertyStore::Commit', OleResult);
    end;

    OleResult := SL.QueryInterface(IID_IPersistFile, PF);
    if OleResult <> S_OK then
      RaiseOleError('IShellLink::QueryInterface(IID_IPersistFile)', OleResult);
    { When creating a folder shortcut on 2000/Me, IPersistFile::Save will strip
      off everything past the last '.' in the filename, so we keep the .lnk
      extension on to give it something harmless to strip off. XP doesn't do
      that, so we must remove the .lnk extension ourself. }
    if FolderShortcut and IsWindowsXP then
      WideFilename := StringToOleStr(PathChangeExt(Filename, ''))
    else
      WideFilename := StringToOleStr(Filename);
    if WideFilename = nil then
      OutOfMemoryError;
    OleResult := PF.Save(WideFilename, True);
    if OleResult <> S_OK then
      RaiseOleError('IPersistFile::Save', OleResult);

    Result := GetResultingFilename(PF, Filename);
  finally
    if Assigned(WideFilename) then
      SysFreeString(WideFilename);
    if Assigned(PS) then
      PS.Release;
    if Assigned(PF) then
      PF.Release;
    SL.Release;
  end;
{$ELSE}
var
  OleResult: HRESULT;
  Obj: IUnknown;
  SL: IShellLink;
  PS: {$IFDEF IS_D14}PropSys.{$ENDIF}IPropertyStore;
  PV: TPropVariant;
  PF: IPersistFile;
  WideAppUserModelID, WideFilename: WideString;
begin
  if FolderShortcut then begin
    try
      Obj := CreateComObject(CLSID_FolderShortcut);
    except
      { Folder shortcuts aren't supported prior to Windows 2000/Me. Fall back
        to creating a normal shell link. }
      Obj := nil;
    end;
  end;
  if Obj = nil then begin
    FolderShortcut := False;
    Obj := CreateComObject(CLSID_ShellLink);
  end;
  SL := Obj as IShellLink;
  SL.SetPath(PChar(ShortcutTo));
  SL.SetArguments(PChar(Parameters));
  if not FolderShortcut then
    AssignWorkingDir(SL, WorkingDir);
  if IconFilename <> '' then begin
    { Work around a 64-bit Windows bug. It replaces pf32 with %ProgramFiles%
      which is wrong. This causes an error when the user tries to change the
      icon of the installed shortcut. Note that the icon does actually display
      fine because it *also* stores the original 'non replaced' path in the
      shortcut. } 
    //if IsWin64 then
      //StringChangeEx(IconFileName, ExpandConst('{pf32}\'), ['%ProgramFiles(x86)%\']);
    SL.SetIconLocation(PChar(IconFilename), IconIndex);
  end;
  SL.SetShowCmd(ShowCmd);
  if Description <> '' then
    SL.SetDescription(PChar(Description));
  if HotKey <> 0 then
    SL.SetHotKey(HotKey);

  { Note: Vista and newer support IPropertyStore but Vista errors if you try to
    commit a PKEY_AppUserModel_ID, so avoid setting the property on Vista. }
  if IsWindows7 and ((AppUserModelID <> '') or ExcludeFromShowInNewInstall or PreventPinning) then begin
    PS := Obj as {$IFDEF IS_D14}PropSys.{$ENDIF}IPropertyStore;
    { According to MSDN the PreventPinning property should be set before the ID property. In practice
      this doesn't seem to matter - at least not for shortcuts - but do it first anyway. }
    if PreventPinning then begin
      PV.vt := VT_BOOL;
      PV.boolVal := True;
      OleResult := PS.SetValue(PKEY_AppUserModel_PreventPinning, PV);
      if OleResult <> S_OK then
        RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_PreventPinning)', OleResult);
    end;
    if AppUserModelID <> '' then begin
      WideAppUserModelID := AppUserModelID;
      PV.vt := VT_BSTR;
      PV.bstrVal := PWideChar(WideAppUserModelID);
      OleResult := PS.SetValue(PKEY_AppUserModel_ID, PV);
      if OleResult <> S_OK then
        RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_ID)', OleResult);
    end;
    if ExcludeFromShowInNewInstall then begin
      PV.vt := VT_BOOL;
      PV.boolVal := True;
      OleResult := PS.SetValue(PKEY_AppUserModel_ExcludeFromShowInNewInstall, PV);
      if OleResult <> S_OK then
        RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_ExcludeFromShowInNewInstall)', OleResult);
      if IsWindows8 then begin
        PV.vt := VT_UI4;
        PV.ulVal := APPUSERMODEL_STARTPINOPTION_NOPINONINSTALL;
        OleResult := PS.SetValue(PKEY_AppUserModel_StartPinOption, PV);
        if OleResult <> S_OK then
          RaiseOleError('IPropertyStore::SetValue(PKEY_AppUserModel_StartPinOption)', OleResult);
      end;
    end;
    OleResult := PS.Commit;
    if OleResult <> S_OK then
      RaiseOleError('IPropertyStore::Commit', OleResult);
  end;

  PF := SL as IPersistFile;
  { When creating a folder shortcut on 2000/Me, IPersistFile::Save will strip
    off everything past the last '.' in the filename, so we keep the .lnk
    extension on to give it something harmless to strip off. XP doesn't do
    that, so we must remove the .lnk extension ourself. }
  if FolderShortcut and IsWindowsXP then
    WideFilename := PathChangeExt(Filename, '')
  else
    WideFilename := Filename;
  OleResult := PF.Save(PWideChar(WideFilename), True);
  if OleResult <> S_OK then
    RaiseOleError('IPersistFile::Save', OleResult);

  Result := GetResultingFilename(PF, Filename);
  { Delphi 3 automatically releases COM objects when they go out of scope }
{$ENDIF}
end;

procedure RegisterTypeLibrary(const Filename: String);
{$IFNDEF Delphi3OrHigher}
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
      TypeLib.Release;
    end;
  finally
    SysFreeString(WideFilename);
  end;
end;
{$ELSE}
var
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
    //null;
end;
{$ENDIF}

procedure UnregisterTypeLibrary(const Filename: String);
type
  TUnRegTlbProc = function(const libID: TGUID; wVerMajor, wVerMinor: Word;
    lcid: TLCID; syskind: TSysKind): HResult; stdcall;
{$IFNDEF Delphi3OrHigher}
var
  UnRegTlbProc: TUnRegTlbProc;
  WideFilename: PWideChar;
  OleResult: HRESULT;
  TypeLib: ITypeLib;
  LibAttr: PTLibAttr;
begin
  { Dynamically import UnRegisterTypeLib since older OLEAUT32.DLL versions
    don't have this function }
  @UnRegTlbProc := GetProcAddress(GetModuleHandle('OLEAUT32.DLL'),
    'UnRegisterTypeLib');
  if @UnRegTlbProc = nil then
    Win32ErrorMsg('GetProcAddress');
  WideFilename := StringToOleStr(PathExpand(Filename));
  if WideFilename = nil then
    OutOfMemoryError;
  try
    OleResult := LoadTypeLib(WideFilename, TypeLib);
    if OleResult <> S_OK then
      RaiseOleError('LoadTypeLib', OleResult);
    try
      OleResult := TypeLib.GetLibAttr(LibAttr);
      if OleResult <> S_OK then
        RaiseOleError('ITypeLib::GetLibAttr', OleResult);
      try
        with LibAttr^ do
          OleResult := UnRegTlbProc(Guid, wMajorVerNum, wMinorVerNum, LCID, SysKind);
        if OleResult <> S_OK then
          RaiseOleError('UnRegisterTypeLib', OleResult);
      finally
        TypeLib.ReleaseTLibAttr(LibAttr);
      end;
    finally
      TypeLib.Release;
    end;
  finally
    SysFreeString(WideFilename);
  end;
end;
{$ELSE}
var
  UnRegTlbProc: TUnRegTlbProc;
  WideFilename: WideString;
  OleResult: HRESULT;
  TypeLib: ITypeLib;
  LibAttr: PTLibAttr;
begin
  { Dynamically import UnRegisterTypeLib since older OLEAUT32.DLL versions
    don't have this function }
  @UnRegTlbProc := GetProcAddress(GetModuleHandle('OLEAUT32.DLL'),
    'UnRegisterTypeLib');
  if @UnRegTlbProc = nil then
    Win32ErrorMsg('GetProcAddress');
  WideFilename := PathExpand(Filename);
  OleResult := LoadTypeLib(PWideChar(WideFilename), TypeLib);
  if OleResult <> S_OK then
    RaiseOleError('LoadTypeLib', OleResult);
  OleResult := TypeLib.GetLibAttr(LibAttr);
  if OleResult <> S_OK then
    RaiseOleError('ITypeLib::GetLibAttr', OleResult);
  try
    with LibAttr^ do
      OleResult := UnRegTlbProc(Guid, wMajorVerNum, wMinorVerNum, LCID, SysKind);
    if OleResult <> S_OK then
      RaiseOleError('UnRegisterTypeLib', OleResult);
  finally
    TypeLib.ReleaseTLibAttr(LibAttr);
  end;
end;
{$ENDIF}

const
  CLSID_StartMenuPin: TGUID = (
    D1:$a2a9545d; D2:$a0c2; D3:$42b4; D4:($97,$08,$a0,$b2,$ba,$dd,$77,$c8));

  IID_StartMenuPinnedList: TGUID = (
    D1:$4CD19ADA; D2:$25A5; D3:$4A32; D4:($B3,$B7,$34,$7B,$EE,$5B,$E3,$6B));

  IID_ShellItem: TGUID = (
    D1:$43826D1E; D2:$E718; D3:$42EE; D4:($BC,$55,$A1,$E2,$61,$C3,$7B,$FE));

{$IFNDEF Delphi3OrHigher}
type
  IShellItem = class(IUnknown)
    function BindToHandler(const pbc: IBindCtx; const bhid: TGUID;
      const riid: TIID; var ppv): HResult; virtual; stdcall; abstract;
    function GetParent(var ppsi: IShellItem): HResult; virtual; stdcall; abstract;
    function GetDisplayName(sigdnName: DWORD; var ppszName: LPWSTR): HResult; virtual; stdcall; abstract;
    function GetAttributes(sfgaoMask: DWORD; var psfgaoAttribs: DWORD): HResult; virtual; stdcall; abstract;
    function Compare(const psi: IShellItem; hint: DWORD;
      var piOrder: Integer): HResult; virtual; stdcall; abstract;
  end;

  IStartMenuPinnedList = class(IUnknown)
    function RemoveFromList(const pitem: IShellItem): HRESULT; virtual; stdcall; abstract;
  end;
{$ELSE}
type
  IStartMenuPinnedList = interface(IUnknown)
    ['{4CD19ADA-25A5-4A32-B3B7-347BEE5BE36B}']
    function RemoveFromList(const pitem: IShellItem): HRESULT; stdcall;
  end;
{$ENDIF}

var
  SHCreateItemFromParsingNameFunc: function(pszPath: LPCWSTR; const pbc: IBindCtx;
    const riid: TIID; var ppv): HResult; stdcall;

{ Attempt to unpin a shortcut. Returns True if the shortcut was successfully
  removed from the list of pinned items and/or the taskbar, or if the shortcut
  was not pinned at all. http://msdn.microsoft.com/en-us/library/bb774817.aspx }
function UnpinShellLink(const Filename: String): Boolean;
var
{$IFNDEF Delphi3OrHigher}
  WideFileName: PWideChar;
{$ELSE}
  WideFileName: WideString;
{$ENDIF}
  ShellItem: IShellItem;
  StartMenuPinnedList: IStartMenuPinnedList;
begin
{$IFNDEF Delphi3OrHigher}
  ShellItem := nil;
  StartMenuPinnedList := nil;
  WideFilename := StringToOleStr(PathExpand(Filename));
  if WideFilename = nil then
    OutOfMemoryError;
  try
{$ELSE}
  WideFilename := PathExpand(Filename);
{$ENDIF}
  if IsWindowsVista and //only attempt on Windows Vista and newer just to be sure
     Assigned(SHCreateItemFromParsingNameFunc) and
     SUCCEEDED(SHCreateItemFromParsingNameFunc(PWideChar(WideFilename), nil, IID_ShellItem, ShellItem)) and
     SUCCEEDED(CoCreateInstance(CLSID_StartMenuPin, nil, CLSCTX_INPROC_SERVER, IID_StartMenuPinnedList, StartMenuPinnedList)) then
    Result := StartMenuPinnedList.RemoveFromList(ShellItem) = S_OK
  else
    Result := True;
{$IFNDEF Delphi3OrHigher}
  finally
    SysFreeString(WideFilename);
    if StartMenuPinnedList <> nil then
      StartMenuPinnedList.Release;
    if ShellItem <> nil then
      ShellItem.Release;
  end;
{$ENDIF}
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

initialization
  InitOle;
  SHCreateItemFromParsingNameFunc := GetProcAddress(SafeLoadLibrary(shell32,
    SEM_NOOPENFILEERRORBOX), 'SHCreateItemFromParsingName');

finalization
  CoUninitialize;
end.
