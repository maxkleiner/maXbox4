unit xrtl_util_COMCat;

{$INCLUDE xrtl.inc}

interface

uses
  Windows, SysUtils, Classes, ActiveX, COMObj;

function   XRTLDefaultCategoryManager: IUnknown;
function   XRTLIsCategoryEmpty(CatID: TGUID; const CategoryManager: IUnknown = nil): Boolean;
// ICatRegister helper functions
function   XRTLCreateComponentCategory(CatID: TGUID; CatDescription: WideString;
                                       LocaleID: TLCID = LOCALE_USER_DEFAULT;
                                       const CategoryManager: IUnknown = nil): HResult;
function   XRTLRemoveComponentCategory(CatID: TGUID; CatDescription: WideString;
                                       LocaleID: TLCID = LOCALE_USER_DEFAULT;
                                       const CategoryManager: IUnknown = nil): HResult;
function   XRTLRegisterCLSIDInCategory(ClassID: TGUID; CatID: TGUID;
                                       const CategoryManager: IUnknown = nil): HResult;
function   XRTLUnRegisterCLSIDInCategory(ClassID: TGUID; CatID: TGUID;
                                         const CategoryManager: IUnknown = nil): HResult;

// ICatInformation helper functions
function   XRTLGetCategoryDescription(CatID: TGUID; var CatDescription: WideString;
                                      LocaleID: TLCID = LOCALE_USER_DEFAULT;
                                      const CategoryManager: IUnknown = nil): HResult;
function   XRTLGetCategoryList(Strings: TStrings; LocaleID: TLCID = LOCALE_USER_DEFAULT;
                               const CategoryManager: IUnknown = nil): HResult;
function   XRTLGetCategoryCLSIDList(CatID: TGUID; Strings: TStrings;
                                    const CategoryManager: IUnknown = nil): HResult;
function   XRTLGetCategoryProgIDList(CatID: TGUID; Strings: TStrings;
                                     const CategoryManager: IUnknown = nil): HResult;

implementation

uses
  xrtl_util_COMUtils,
  xrtl_util_Lock, xrtl_util_MemoryUtils;

const
  MAX_LEN = 127;

var
  CategoryManagerObject: IUnknown = nil;
  Sync: IXRTLReadWriteLock = nil;

function XRTLGetCategoryManager(const CategoryManager: IUnknown): IUnknown;
begin
  Result:= CategoryManager;
  if not Assigned(Result) then
    Result:= XRTLDefaultCategoryManager;
end;

function XRTLDefaultCategoryManager: IUnknown;
begin
  try
    Sync.BeginRead;
    if not Assigned(CategoryManagerObject) then
    begin
      try
        Sync.BeginWrite;
        CategoryManagerObject:= CreateComObject(CLSID_StdComponentCategoryMgr);
      finally
        Sync.EndWrite;
      end;
    end;
  finally
    Sync.EndRead;
    Result:= CategoryManagerObject;
  end;
end;

function XRTLIsCategoryEmpty(CatID: TGUID; const CategoryManager: IUnknown = nil): Boolean;
var
  ClassIDs: TStrings;
begin
  Result:= False;
  ClassIDs:= nil;
  try
    try
      ClassIDs:= TStringList.Create;
      OLECheck(XRTLGetCategoryCLSIDList(CatID, ClassIDs, CategoryManager));
      Result:= ClassIDs.Count = 0;
    finally
      FreeAndNil(ClassIDs);
    end;
  except
  end;
end;

procedure XRTLProcessCategoryDescription(CatDescription: WideString; Buffer: PWideChar);
begin
  if Length(CatDescription) > MAX_LEN then
    SetLength(CatDescription, MAX_LEN);
//  put string and NULL character
  XRTLMoveMemory(PWideChar(CatDescription), Buffer, (Length(CatDescription) + 1) * SizeOf(WideChar));
end;

function XRTLCreateComponentCategory(CatID: TGUID; CatDescription: WideString;
  LocaleID: TLCID = LOCALE_USER_DEFAULT; const CategoryManager: IUnknown = nil): HResult;
var
  CatRegObject: ICatRegister;
  CatInfo: PCATEGORYINFO;
begin
  try
    CatRegObject:= XRTLGetCategoryManager(CategoryManager) as ICatRegister;
    CatInfo:= nil;
    try
      GetMem(CatInfo, SizeOf(TCATEGORYINFO));
      if not Assigned(CatInfo) then
        OLEError(E_OUTOFMEMORY);
      CatInfo.CatID:= CatID;
      CatInfo.LCID:= ConvertDefaultLocale(LocaleID);
      XRTLProcessCategoryDescription(CatDescription, @CatInfo.szDescription);
      Result:= CatRegObject.RegisterCategories(1, CatInfo);
    finally
      if Assigned(CatInfo) then
        FreeMem(CatInfo);
    end;
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLRemoveComponentCategory(CatID: TGUID; CatDescription: WideString;
  LocaleID: TLCID = LOCALE_USER_DEFAULT; const CategoryManager: IUnknown = nil): HResult;
var
  CatRegObject: ICatRegister;
  CatInfo: PCATEGORYINFO;
begin
  try
    CatRegObject:= XRTLGetCategoryManager(CategoryManager) as ICatRegister;
    CatInfo:= nil;
    try
      GetMem(CatInfo, SizeOf(TCATEGORYINFO));
      if not Assigned(CatInfo) then
        OLEError(E_OUTOFMEMORY);
      CatInfo.CatID:= CatID;
      CatInfo.LCID:= ConvertDefaultLocale(LocaleID);
      XRTLProcessCategoryDescription(CatDescription, @CatInfo.szDescription);
      Result:= CatRegObject.UnRegisterCategories(1, CatInfo);
    finally
      if Assigned(CatInfo) then
        FreeMem(CatInfo);
    end;
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLRegisterCLSIDInCategory(ClassID: TGUID; CatID: TGUID;
  const CategoryManager: IUnknown = nil): HResult;
var
  CatRegObject: ICatRegister;
begin
  try
    CatRegObject:= XRTLGetCategoryManager(CategoryManager) as ICatRegister;
    Result:= CatRegObject.RegisterClassImplCategories(ClassID, 1, @CatID);
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLUnRegisterCLSIDInCategory(ClassID: TGUID; CatID: TGUID;
  const CategoryManager: IUnknown = nil): HResult;
var
  CatRegObject: ICatRegister;
begin
  try
    CatRegObject:= XRTLGetCategoryManager(CategoryManager) as ICatRegister;
    Result:= CatRegObject.UnRegisterClassImplCategories(ClassID, 1, @CatID);
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLGetCategoryDescription(CatID: TGUID; var CatDescription: WideString;
  LocaleID: TLCID = LOCALE_USER_DEFAULT; const CategoryManager: IUnknown = nil): HResult;
var
  CatInfoObject: ICatInformation;
  pszDescription: PWideChar;
begin
  try
    try
      Result:= S_OK;
      pszDescription:= nil;
      CatDescription:= '';
      CatInfoObject:= XRTLGetCategoryManager(CategoryManager) as ICatInformation;
      OLECheck(CatInfoObject.GetCategoryDesc(CatID, ConvertDefaultLocale(LocaleID), pszDescription));
      CatDescription:= pszDescription;
    finally
      if Assigned(pszDescription) then
        CoTaskMemFree(pszDescription);
      pszDescription:= nil;
    end;
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLGetCategoryList(Strings: TStrings; LocaleID: TLCID = LOCALE_USER_DEFAULT;
  const CategoryManager: IUnknown = nil): HResult;
var
  CatInfoObject: ICatInformation;
  CatInfoEnum: IEnumCATEGORYINFO;
  Fetched: UINT;
  Catinfo: TCATEGORYINFO;
begin
  try
    Result:= S_OK;
    CatInfoObject:= XRTLGetCategoryManager(CategoryManager) as ICatInformation;
    OLECheck(CatInfoObject.EnumCategories(ConvertDefaultLocale(LocaleID), CatInfoEnum));
    while CatInfoEnum.Next(1, CatInfo, Fetched) = S_OK do
      Strings.Add(WideCharToString(CatInfo.szDescription));
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLGetCategoryCLSIDList(CatID: TGUID; Strings: TStrings;
  const CategoryManager: IUnknown = nil): HResult;
var
  CatInfoObject: ICatInformation;
  GUIDEnum: IEnumGUID;
  Fetched: UINT;
  GUID: TGUID;
begin
  try
    Result:= S_OK;
    CatInfoObject:= XRTLGetCategoryManager(CategoryManager) as ICatInformation;
    OLECheck(CatInfoObject.EnumClassesOfCategories(1, @CatID, UINT(-1), nil, GUIDEnum));
    while GUIDEnum.Next(1, GUID, Fetched) = S_OK do
      Strings.Add(GUIDToString(GUID));
  except
    Result:= XRTLHandleCOMException;
  end;
end;

function XRTLGetCategoryProgIDList(CatID: TGUID; Strings: TStrings;
  const CategoryManager: IUnknown = nil): HResult;
var
  CatInfoObject: ICatInformation;
  GUIDEnum: IEnumGUID;
  Fetched: UINT;
  GUID: TGUID;
begin
  try
    Result:= S_OK;
    CatInfoObject:= XRTLDefaultCategoryManager as ICatInformation;
    OLECheck(CatInfoObject.EnumClassesOfCategories(1, @CatID, UINT(-1), nil, GUIDEnum));
    while GUIDEnum.Next(1, GUID, Fetched) = S_OK do
      Strings.Add(ClassIDToProgID(GUID));
  except
    Result:= XRTLHandleCOMException;
  end;
end;

initialization
begin
  Sync:= XRTLCreateReadWriteLock;
end;

end.
