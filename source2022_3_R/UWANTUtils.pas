unit UWANTUtils;

interface

uses
  Classes,
  MaxDOM;

type TErrorSeverity = (errNone, errInfo, errHint, errWarning, errError, errFatal);

function ErrTag(Sev: TErrorSeverity): String;
function MakeInt64(LowInt32, HiInt32: Cardinal): Int64;
function FolderContent(const APath: String): INode;
function FindFiles(const AFolder, AMask: String; Attrs: Integer;
  AList: TStrings; ASearchSubdirs: Boolean = True): Boolean;

function ErrorSeverityStr(ASeverity: TErrorSeverity): String;

function IsParameterOptional(AParamDef: INode): Boolean;
function ExtractMethodName(const S: String): String;

function LineNoOf(ANode: INode): Integer;
function ColNoOf(ANode: INode): Integer;

function WANTBoolToStr(AValue: Boolean): String;
function WANTStrToBool(const AValue: String; dEFAULT: bOOLEAN = fALSE): Boolean;

function StrDefault(const S, Default: String): String;
function PluralNoun(Count: Integer; const S: String): String;

function IsUnqualifiedName(const AName: String): Boolean;
function IsModuleTag(const ATag: String): Boolean;
function IsCallableTag(const ATag: String): Boolean;
function IsConditionalTag(const ATag: String): Boolean;
function IsMethodTag(const ATag: String): Boolean;

function StripDriveFromPath(const AFileName: String): String;


function TotalTime(NumTicks: Int64): String;


implementation

uses
  //UWANTConstants,
  Windows,
  SysUtils;


function TotalTime(NumTicks: Int64): String;
var
  H, M, S, Z: Integer;
begin
  H := NumTicks div (1000*60*60);
  NumTicks := NumTicks - H*1000*60*60;
  M := NumTicks div (1000*60);
  NumTicks := NumTicks - M*1000*60;
  S := NumTicks div 1000;
  NumTicks := NumTicks - S*1000;
  Z := NumTicks;
  Result := '';
  if H > 0 then
    Result := Format('%s %dh',[Result,H]);
  if M > 0 then
    Result := Format('%s %dm',[Result,M]);
  if S > 0 then
    Result := Format('%s %ds',[Result,S]);
  Result := Format('%s %dms',[Result,Z]);
end;



function IsModuleTag(const ATag: String): Boolean;
begin
  Result := False;
  if ATag = '' then
    Exit;
  case UpCase(ATag[1]) of
    'C': if SameText(ATag,'class') then
           Result := True
         else if SameText(ATag,'constructor') then
           Result := True;
    'F': if SameText(ATag,'function') then
           Result := True;
    'L': if SameText(ATag,'library') then
           Result := True;
    'M': if SameText(ATag,'module') then
           Result := True;
    'P': if SameText(ATag,'procedure') then
           Result := True
         else if SameText(ATag,'project') then
           Result := True
         else if SameText(ATag,'program') then
           Result := True;
    'T': if SameText(ATag,'target') then
           Result := True;
    'U': if SameText(ATag,'unit') then
           Result := True;
  end;
end;


function IsCallableTag(const ATag: String): Boolean;
begin
  Result := IsModuleTag(ATag);
end;


function IsUnqualifiedName(const AName: String): Boolean;
begin
  Result := Pos('.',AName) = 0;
end;

 const  Tag_Branch         = 'if-branch';
        Tag_MethodCall     = 'method-call';
         Tag_Messages       = 'messages';
        Tag_Calls          = 'calls';



function IsConditionalTag(const ATag: String): Boolean;
begin
  Result := False;
  if ATag = '' then
    Exit;
  case UpCase(ATag[1]) of
    'I': if SameText(ATag,TAG_BRANCH) then
           Result := True;
  end;
end;



function IsMethodTag(const ATag: String): Boolean;
begin
  Result := SameText(ATag,TAG_MethodCall);
end;





function WANTBoolToStr(AValue: Boolean): String;
begin
  if AValue then
    Result := 'True'
  else
    Result := 'False';
end;



function WANTStrToBool(const AValue: String; Default: Boolean = False): Boolean;
begin
  if AValue = '' then
    Result := Default
  else if SameText(AValue,'true')
  or SameText(AValue,'yes')
  or SameText(AValue,'on')
  or (StrToIntDef(AValue,0) <> 0) then
    Result := True
  else
    Result := False;
end;



function StrDefault(const S, Default: String): String;
begin
  if S = '' then
    Result := Default
  else
    Result := S;
end;


function PluralNoun(Count: Integer; const S: String): String;
begin
  if Count = 1 then
    Result := S
  else
    Result := S + 's';
end;


function ExtractMethodName(const S: String): String;
var
  LPos: Integer;
begin
  LPos := Pos('.',S);
  Result := Copy(S,LPos+1,MaxInt)
end;


function IsParameterOptional(AParamDef: INode): Boolean;
begin
  Result := StrToBoolDef(AParamDef['Attr_Optional'],False);
end;



function LineNoOf(ANode: INode): Integer;
begin
  if Assigned(ANode) then
    Result := StrToIntDef(ANode['Attr_LineNo'],0)
  else
    Result := 0;
end;


function ColNoOf(ANode: INode): Integer;
begin
  if Assigned(ANode) then
    Result := StrToIntDef(ANode['Attr_ColNo'],0)
  else
    Result := 0;
end;


function ErrorSeverityStr(ASeverity: TErrorSeverity): String;
begin
  case ASeverity of
    errNone:    Result := '';
    errInfo:    Result := '';
    errHint:    Result := 'HINT';
    errWarning: Result := 'WARNING';
    errError:   Result := 'ERROR';
    errFatal:   Result := 'ERROR';
  end;
end;


function MakeInt64(LowInt32, HiInt32: Cardinal): Int64;
begin
  Result := (HiInt32 shl 16) or LowInt32;
end;



function FindFiles(const AFolder, AMask: String; Attrs: Integer;
  AList: TStrings; ASearchSubdirs: Boolean = True): Boolean;
//Returns True if any files found
var
  LSearchMask: String;
  LPath: String;
  LFileMask: String;
  LSearchSubdirs: Boolean;
  SR: TSearchRec;
begin
  if AFolder <> '' then
    LSearchMask := IncludeTrailingPathDelimiter(AFolder)+AMask
  else
    LSearchMask := AMask;
  LPath := ExtractFilePath(LSearchMask);
  LFileMask := ExtractFileName(LSearchMask);
  LSearchMask := LPath+LFileMask;
  // Find files
  if FindFirst(LSearchMask,Attrs,SR) = 0 then
    try
      repeat
        if ((SR.Attr and faDirectory) = 0) then
          AList.Add(LPath+SR.Name);
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  Result := AList.Count > 0;
  if not ASearchSubdirs then
    Exit;
  // Traverse folders
  LSearchMask := LPath + '*';
  if ASearchSubdirs then begin
    if FindFirst(LSearchMask,faDirectory,SR) = 0 then begin
      try
        repeat
          if ((SR.Attr and faDirectory) <> 0) and (SR.Name <> '.') and (SR.Name <> '..') then
            FindFiles( LPath + SR.Name,
              LFileMask, Attrs, AList, ASearchSubdirs);
        until FindNext(SR) <> 0;
      finally
        FindClose(SR);
      end;
    end;
  end;
  Result := AList.Count > 0;
end;



function FolderContent(const APath: String): INode;
var
  LPath: String;
  LList: INode;
  LNode: INode;
  SR: TSearchRec;
begin
  Result := NewNode('folder');
  Result['Path'] := APath;
  LPath := IncludeTrailingPathDelimiter(APath) + '*';
  //Find files
  FillChar(SR,SizeOf(SR),0);
  if FindFirst(LPath,faAnyFile and not (faVolumeID or faDirectory),SR) = 0 then begin
    try
      LList := Result.Children.EnsureElement('files');
      repeat
        LNode := LList.Children.AddNew('file');
        LNode['Name'] := SR.Name;
        LNode['FileTime'] := IntToStr(SR.Time);
        LNode['Size'] := IntToStr(SR.Size);
        LNode['Attr'] := IntToStr(SR.Attr);
        LNode['FullName'] := IncludeTrailingPathDelimiter(APath) + SR.Name;
        LNode['Attributes'] := IntToStr(SR.FindData.dwFileAttributes);
        LNode['CreationTime'] := IntToStr(Int64(SR.FindData.ftCreationTime));
        LNode['LastAccessTime'] := IntToStr(Int64(SR.FindData.ftLastAccessTime));
        LNode['LastWriteTime'] := IntToStr(Int64(SR.FindData.ftLastWriteTime));
        LNode['FileSize'] := IntToStr(MakeInt64(SR.FindData.nFileSizeLow,SR.FindData.nFileSizeHigh));
      until FindNext(SR) <> 0;
    finally
      FindClose(sr);
    end;
  end;
  //Find folders
  FillChar(SR,SizeOf(SR),0);
  if FindFirst(LPath,faDirectory,SR) = 0 then begin
    try
      LList := Result.Children.EnsureElement('folders');
      repeat
        if SR.Name[1] = '.' then
          Continue;
        if (SR.Attr and faDirectory) = 0 then
          Continue;  
        LNode := LList.Children.AddNew('folder');
        LNode['Name'] := SR.Name;
        LNode['FileTime'] := IntToStr(SR.Time);
        LNode['Size'] := IntToStr(SR.Size);
        LNode['Attr'] := IntToStr(SR.Attr);
        LNode['FullName'] := IncludeTrailingPathDelimiter(APath) + SR.Name;
        LNode['Attributes'] := IntToStr(SR.FindData.dwFileAttributes);
        LNode['CreationTime'] := IntToStr(Int64(SR.FindData.ftCreationTime));
        LNode['LastAccessTime'] := IntToStr(Int64(SR.FindData.ftLastAccessTime));
        LNode['LastWriteTime'] := IntToStr(Int64(SR.FindData.ftLastWriteTime));
        LNode['FileSize'] := IntToStr(MakeInt64(SR.FindData.nFileSizeLow,SR.FindData.nFileSizeHigh));
      until FindNext(SR) <> 0;
    finally
      FindClose(sr);
    end;
  end;
end;



function ErrTag(Sev: TErrorSeverity): String;
begin
  case Sev of
    errNone:    Result := 'Tag_Message';
    errInfo:    Result := 'Tag_Info';
    errWarning: Result := 'Tag_Warning';
    errError:   Result := 'Tag_Error';
    errFatal:   Result := 'Tag_Error';
  end;
end;



function StripDriveFromPath(const AFileName: String): String;
var
  P: Integer;
begin
  P := Pos(':',AFileName);
  Result := Copy(AFileName,P+1,MaxInt);
end;


end.
