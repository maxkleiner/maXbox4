unit xrtl_util_PackageUtils;

{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils,
  xrtl_util_Compat;

type
  TXRTLForEachPackageProc = procedure(PackageName: string; ModuleHandle: THandle);
  TXRTLForEachPackageMethod = procedure(PackageName: string; ModuleHandle: THandle) of object;

procedure XRTLLoadPackage(const PackagePath: string;
                          CallRegisterProc: Boolean = False;
                          const RegisterProcName: string = 'Register');
procedure XRTLUnLoadPackage(const PackagePath: string;
                            CallUnRegisterProc: Boolean = False;
                            const UnRegisterProcName: string = 'UnRegister');
procedure XRTLForEachPackage(ForEachPackageProc: TXRTLForEachPackageProc); overload;
procedure XRTLForEachPackage(ForEachPackageMethod: TXRTLForEachPackageMethod); overload;

implementation

uses
  xrtl_util_Value, xrtl_util_Map, xrtl_util_Lock, xrtl_util_Type;

var
  FPackageList: TXRTLArrayMap;
  FLock: IXRTLReadWriteLock;

type
  PXRTLInfoProcParam = ^TXRTLInfoProcParam;
  TXRTLInfoProcParam = record
    Handle: THandle;
    ProcName: string;
  end;

procedure XRTLInfoProc(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
var
  RegisterProc: procedure;
  QualifiedProcName: string;
  UnitName: string;
  InfoProcParam: PXRTLInfoProcParam;
begin
  InfoProcParam:= PXRTLInfoProcParam(Param);
  if NameType = ntContainsUnit then
  begin
    UnitName:= AnsiUpperCase(Name[1]) + AnsiLowerCase(Copy(Name, 2, Length(Name)));
    QualifiedProcName:= Format('@%s@%s$qqrv', [UnitName, InfoProcParam.ProcName]);
    RegisterProc:= GetProcAddress(Integer(InfoProcParam.Handle), PChar(QualifiedProcName));
    if @RegisterProc <> nil then
      RegisterProc;
  end;
end;

procedure XRTLCallProc(FHandle: THandle; const ProcName: string);
var
  Flags: Integer;
  InfoProcParam: TXRTLInfoProcParam;
begin
  ZeroMemory(@InfoProcParam, SizeOf(TXRTLInfoProcParam));
  InfoProcParam.Handle:= FHandle;
  InfoProcParam.ProcName:= ProcName;
  GetPackageInfo(FHandle, @InfoProcParam, Flags, XRTLInfoProc);
end;

procedure XRTLLoadPackage(const PackagePath: string;
                          CallRegisterProc: Boolean = False;
                          const RegisterProcName: string = 'Register');
var
  LHandle: THandle;
  LPackageName: WideString;
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginWriteLock(FLock);
  LPackageName:= ExtractFileName(PackagePath);
  LHandle:= SysUtils.LoadPackage(PackagePath);
  if LHandle = 0 then
    Exit;
  if CallRegisterProc and IsValidIdent(RegisterProcName) then
    XRTLCallProc(LHandle, RegisterProcName);
  FPackageList.SetValue(XRTLValue(LPackageName), XRTLValue(LHandle));
end;

procedure XRTLUnLoadPackage(const PackagePath: string;
                            CallUnRegisterProc: Boolean = False;
                            const UnRegisterProcName: string = 'UnRegister');
var
  LHandle: THandle;
  LPackageName: WideString;
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginWriteLock(FLock);
  LPackageName:= ExtractFileName(PackagePath);
  LHandle:= XRTLGetAsCardinal(FPackageList.GetValue(XRTLValue(LPackageName)));
  if LHandle = 0 then
    Exit;
  if CallUnRegisterProc and IsValidIdent(UnRegisterProcName) then
    XRTLCallProc(LHandle, UnRegisterProcName);
  SysUtils.UnloadPackage(LHandle);
  FPackageList.Remove(XRTLValue(LPackageName));
end;

procedure XRTLForEachPackage(ForEachPackageProc: TXRTLForEachPackageProc);
var
  LHandle: THandle;
  LPackageNames: TXRTLValueArray;
  LPackageName: WideString;
  I: Integer;
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginReadLock(FLock);
  SetLength(LPackageNames, 0);
  LPackageNames:= FPackageList.GetKeys;
  for I:= 0 to Length(LPackageNames) - 1 do
  begin
    LPackageName:= XRTLGetAsWideString(LPackageNames[I]);
    LHandle:= XRTLGetAsCardinal(FPackageList.GetValue(LPackageNames[I]));
    ForEachPackageProc(LPackageName, LHandle);
  end;
end;

procedure XRTLForEachPackage(ForEachPackageMethod: TXRTLForEachPackageMethod);
var
  LHandle: THandle;
  LPackageNames: TXRTLValueArray;
  LPackageName: WideString;
  I: Integer;
  FAutoLock: IInterface;
begin
  FAutoLock:= XRTLBeginReadLock(FLock);
  SetLength(LPackageNames, 0);
  LPackageNames:= FPackageList.GetKeys;
  for I:= 0 to Length(LPackageNames) - 1 do
  begin
    LPackageName:= XRTLGetAsWideString(LPackageNames[I]);
    LHandle:= XRTLGetAsCardinal(FPackageList.GetValue(LPackageNames[I]));
    ForEachPackageMethod(LPackageName, LHandle);
  end;
end;

initialization
begin
  FLock:= XRTLCreateReadWriteLock;
  FPackageList:= TXRTLArrayMap.Create;
end;

finalization
begin
  FreeAndNil(FPackageList);
end;

end.
