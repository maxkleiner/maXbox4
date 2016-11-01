{ $HDR$   on progress...}
{**********************************************************************}
{ #head:Max: MAXBOX10: 23/05/2016 14:33:47 C:\maXbox\maxbox3\maxbox3\maXbox3\examples\700_new_function_snippets.pas 
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.softwareschule.ch                                         }
{**********************************************************************}
{}
{ $Log:  10063: IdAntiFreeze.pas #sign:Max: MAXBOX10: 23/05/2016 14:33:47 
{
{   Rev 1.0    2002.11.12 10:29:54 PM  czhower
        1.1    2016 tester for maXbox
        1.2    2016 add classes 
        1.3.   2016 code snippets database
}
unit CodeSnippetsDB_Freeze;

{$DEFINE MSWINDOWS}

{
NOTE - This unit must NOT appear in any Indy uses clauses. This is a ONE way relationship
and is linked in IF the user uses this component. This is done to preserve the isolation from the
massive FORMS unit.
}

interface

{uses
  Classes,
  IdAntiFreezeBase,
  IdBaseComponent;    }
{Directive needed for C++Builder HPP and OBJ files for this that will force it
to be statically compiled into the code}

//{$I IdCompilerDefines.inc}

{$IFDEF MSWINDOWS}

//{$HPPEMIT '#pragma link "IdAntiFreeze.obj"'}    {Do not Localize}

{$ENDIF}

{$IFDEF LINUX}

//{$HPPEMIT '#pragma link "IdAntiFreeze.o"'}    {Do not Localize}

{$ENDIF}
//type
  //TIdAntiFreeze = class(TIdAntiFreezeBase)
  //public
    procedure Process; //override;
  //end;

  var ApplicationHasPriority: boolean;
      GAntiFreeze: TIdAntiFreezeBase; // = nil;

implementation

(*uses
{$IFDEF LINUX}
  QForms;
{$ENDIF}
{$IFDEF MSWINDOWS}
  Forms,
  Messages,
  Windows;
{$ENDIF}
  *)
{$IFDEF LINUX}
procedure TIdAntiFreeze.Process;
begin
  //TODO: Handle ApplicationHasPriority
  Application.ProcessMessages;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure Process;
var
  Msg: TMsg;
begin
  if ApplicationHasPriority then begin
    Application.ProcessMessages;
  end else begin
    // This guarantees it will not ever call Application.Idle
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then begin
      Application.HandleMessage;
    end;
  end;
end;

{class} function TIdAntiFreezeBase_ShouldUse: boolean;
begin
  // InMainThread - Only process if calling client is in the main thread
  Result := (GAntiFreeze <> nil) and InMainThread;
  if Result then begin
    Result := GAntiFreeze.Active;
  end;
end;

function VariantIsObject(const V: Variant): Boolean;
begin
  Result := {Variants.}VarIsType(V, varDispatch)
    or {Variants.}VarIsType(V, varUnknown);
end;

function IsUnicodeStream(const Stm: TStream): Boolean;
var
  StmPos: LongInt;      // current position in stream
  BOM: Word;            // Unicode byte order mark
begin
  // Record current location in stream
  StmPos := Stm.Position;
  // Check if stream large enough to contain BOM (empty text file contains only
  // the BOM)
  if StmPos <= Stm.Size - SizeOf(BOM) then
  begin
    // Read first word and check if it is the unicode marker
    //Stm.ReadBuffer(BOM, SizeOf(BOM));
    Result := (BOM = $FEFF);
    // Restore stream positions
    Stm.Position := StmPos;
  end
  else
    // Stream too small: can't be unicode
    Result := False;
end;

function UnicodeFileToWideString(const FileName: string): WideString;
var
  FS: {Classes.}TFileStream;  // Stream onto file
begin
  FS := TFileStream.Create(
    FileName, fmOpenRead or fmShareDenyNone);
  try
    //Result := UnicodeStreamToWideString(FS);
  finally
    FS.Free;
  end;
end;

function TaskbarHandle: THandle;
begin
  Result := FindWindow('Shell_TrayWnd', 'nil');
end;

function TrayHandle: THandle;
begin
  Result := FindWindowEx(TaskbarHandle, 0, 'TrayNotifyWnd', 'nil');
end;

const
  cWdwCurrentVer = '\Software\Microsoft\Windows\CurrentVersion';

function GetCurrentVersionRegStr(const ValName: string): string;
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE,
    cWdwCurrentVer,
    ValName
  );
end;

function ProgramFilesFolder: string;
begin
  Result := GetCurrentVersionRegStr('ProgramFilesDir');
end;

function GetRegistryString2(const RootKey: HKEY;
  const SubKey, Name: string): string;
var
  Reg: TRegistry;          // registry access object
  ValueInfo: TRegDataInfo; // info about registry value
begin
  Result := '';
  // Open registry at required root key
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    // Open registry key and check value exists
    if Reg.OpenKeyReadOnly(SubKey)
      and Reg.ValueExists(Name) then begin
      // Check if registry value is string or integer
      Reg.GetDataInfo(Name, ValueInfo);
      case ValueInfo.RegData of
        rdString, rdExpandString:
          // string value: just return it
          Result := Reg.ReadString(Name);
        rdInteger:
          // integer value: convert to string
          Result := {SysUtils.}IntToStr(Reg.ReadInteger(Name));
        else
          // unsupported value: raise exception
          raise; //Exception.Create(
            //'Unsupported registry type'
          //);
      end;
    end;
  finally
    // Close registry
    Reg.Free;
  end;
end;


//const
  //WS_EX_LAYERED = $00080000;  // layered window style

function WindowSupportsLayers(const HWnd: HWND): Boolean;
begin
  Result := IsFlagSet(
    {Windows.}GetWindowLong(HWnd, GWL_EXSTYLE), WS_EX_LAYERED
  );
end;

function IsIntResource(const ResID: PChar): Boolean;
begin
  //Result := (HiWord(DWORD(ResID)) = 0);
  Result := (HiWord(strtoint(ResID)) = 0);

end;

function ResourceIDToStr(const ResID: PChar): string;
begin
  if IsIntResource(ResID) then
    Result := '#' + IntToStr(strtoint(ResID))
  else
    Result := string(ResID);
end;

function ResourceExists(const Module: HMODULE;
  const ResName, ResType: PChar): Boolean;
begin
  Result := {Windows.}FindResource(Module, ResName, ResType) <> 0;
end;

function TreeNodeChildCount(ParentNode: TTreeNode): Integer;
var
  ChildNode: {ComCtrls.}TTreeNode;  // references each child node
begin
  Result := 0;
  if ParentNode = nil then
    Exit;
  ChildNode := ParentNode.GetFirstChild;
  while (ChildNode <> nil) do begin
    Inc(Result);
    ChildNode := ChildNode.GetNextSibling;
  end;
end;


const
  // Registry keys for Win 9x/NT
  {cRegKey: array[Boolean] of string = (
    'Software\Microsoft\Windows\CurrentVersion',
    'Software\Microsoft\Windows NT\CurrentVersion'
  );}
  // Registry key name
  cName = 'ProductID';
  //cRegKey = 'Software\Microsoft\Windows\CurrentVersion';
  cRegKey = 'Software\Microsoft\Windows NT\CurrentVersion';

function WindowsProductID: string;
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE, cRegKey{[IsWinNT]}, cName
  );
end;

function IsIEInstalled: Boolean;
begin
  Result := ProgIDInstalled('InternetExplorer.Application');
end;

function GetFileTypeX(const FilePath: string): string;
var
  aInfo: {ShellAPI.}TSHFileInfo;
begin
  if {ShellAPI.}SHGetFileInfo(
      PChar(FilePath),
      0,
      aInfo,
      SizeOf(aInfo),
      {ShellAPI.}SHGFI_TYPENAME
    ) <> 0 then
    Result := aInfo.szTypeName[1]
  else
    Result := ''; // result if file or folder does not exist
end;

procedure RemoveDuplicateStrings(const Strings: TStrings);
var
  TempStrings: TStringList;
  Cnt: Integer;
begin
  if Strings.Count <= 1 then
    Exit;
  TempStrings := TStringList.Create;
  try
    TempStrings.Sorted := True;
    TempStrings.Duplicates := dupIgnore;
    for Cnt := 0 to Strings.Count - 1 do
      TempStrings.Add(Strings[Cnt]);
    Strings.Assign(TempStrings);
  finally
    TempStrings.Free;
  end;
end;

function EllipsifyText(const AsPath: Boolean; const Text: string;
  const Canvas: TCanvas; const MaxWidth: Integer ): string;
var
  TempPChar: PChar; // temp buffer to hold text
  TempRect: TRect;  // temp rectangle hold max width of text
  Params: UINT;     // flags passed to DrawTextEx API function
begin
  // Alocate mem for PChar
  //GetMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  try
    // Copy Text into PChar
    TempPChar := StrPCopy(TempPChar, Text);
    // Create Rectangle to Store PChar
    TempRect := Rect(0, 0, MaxWidth, High(params));
    // Set Params depending wether it's a path or not
    if AsPath then
      Params := {Windows.}DT_PATH_ELLIPSIS
    else
      Params := {Windows.}DT_END_ELLIPSIS;
    // Tell it to Modify the PChar, and do not draw to the canvas
    Params := Params + DT_MODIFYSTRING + DT_CALCRECT;
    // Ellipsify the string based on availble space to draw in
    DrawTextEx(Canvas.Handle, TempPChar, -1, TempRect, Params, 0);
    // Copy the modified PChar into the result
    Result := StrPas(TempPChar);
  finally
    // Free Memory from PChar
    //FreeMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  end;
end;

function CloneByteArray(const B: array of Byte): TBytes;
begin
  SetLength(Result, Length(B));
  if Length(B) > 0 then
    //Move(B[0], Result[0], Length(B));
end;

function IndexOfByte(const B: Byte; const A: array of Byte): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(Length(A)) do begin
    if A[I] = B then begin
      Result := I;
      Exit;
    end;
  end;
end;

function IsUTF7Stream(const Stm: TStream): Boolean;
begin
  Result := StreamHasWatermark(Stm, [$2B, $2F, $76, $38])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $39])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $2B])
    or StreamHasWatermark(Stm, [$2B, $2F, $76, $2F]);
end;

function IsUTF16Stream(const Stm: TStream): Boolean;
begin
  Result := StreamHasWatermark(Stm, [$FF, $FE])  // UTF-16 LE
    or StreamHasWatermark(Stm, [$FE, $FF])       // UTF-16 BE
end;

const
  RFC1123Pattern = 'ddd, dd mmm yyyy HH'':''nn'':''ss ''GMT''';

function RFC1123DateGMT(const DT: TDateTime): string;
//const
  //RFC1123Pattern = 'ddd, dd mmm yyyy HH'':''nn'':''ss ''GMT''';
begin
  Result := {SysUtils.}FormatDateTime(RFC1123Pattern, DT);
end;

function CreateDisplayDC: HDC;
begin
  //Result := {Windows.}CreateDC('DISPLAY', 0, 0, 0);
end;

procedure GraphicToBitmap(const Src: TGraphic;
  const Dest: TBitmap; const TransparentColor: TColor);
begin
  // Do nothing if either source or destination are nil
  if not Assigned(Src) or not Assigned(Dest) then
    Exit;
  // Size the bitmap
  Dest.Width := Src.Width;
  Dest.Height := Src.Height;
  if Src.Transparent then
  begin
    // Source graphic is transparent, make bitmap behave transparently
    Dest.Transparent := True;
    if (TransparentColor <> clNone) then
    begin
      // Set destination as transparent using required colour key
      Dest.TransparentColor := TransparentColor;
      Dest.TransparentMode := {Graphics.}tmFixed;
      // Set background colour of bitmap to transparent colour
      Dest.Canvas.Brush.Color := TransparentColor;
    end
    else
      // No transparent colour: set transparency to automatic
      Dest.TransparentMode := {Graphics.}tmAuto;
  end;
  // Clear bitmap to required background colour and draw bitmap
  Dest.Canvas.FillRect(Rect(0, 0, Dest.Width, Dest.Height));
  Dest.Canvas.Draw(0, 0, Src);
end;


(*function SetTransparencyLevel(const HWnd: Windows.HWND;
  const Level: Byte): Boolean;
const
  LWA_ALPHA = $00000002;  // flag for API call
type
  // prototype for Windows SetLayeredWindowAttributes API function
  TSetLayeredWindowAttributes = function(HWnd: Windows.HWND;
    crKey: Windows.COLORREF; bAlpha: Byte; dwFlags: Windows.DWORD
  ): Boolean; stdcall;
var
  SetLayeredWindowAttributes:
    TSetLayeredWindowAttributes;  // reference to function in user32.dll
  User32: Windows.HMODULE;        // handle of user32.dll
begin
  Result := False;
  if (HWnd = 0) or not WindowSupportsLayers(HWnd) then
    Exit;
  User32 := Windows.GetModuleHandle('User32.dll');
  if User32 <> 0 then
  begin
    @SetLayeredWindowAttributes := GetProcAddress(
      User32, 'SetLayeredWindowAttributes'
    );
    if Assigned(SetLayeredWindowAttributes) then
      Result := SetLayeredWindowAttributes(HWnd, 0, Level, LWA_ALPHA);
  end;
end;*)


(*function IsEqualResID(const R1, R2: PChar): Boolean;
begin
  if IsIntResource(R1) then
    // R1 is ordinal: R2 must also be ordinal with same value in lo word
    Result := IsIntResource(R2) and
      (Windows.LoWord(Windows.DWORD(R1)) = Windows.LoWord(Windows.DWORD(R2)))
  else
    // R1 is string pointer: R2 must be same string (ignoring case)
    Result := not IsIntResource(R2) and (SysUtils.StrIComp(R1, R2) = 0);
end;*)

(*function GetGenericFileType(const FileNameOrExt: string): string;
var
  Info: ShellAPI.TSHFileInfo;
begin
  if ShellAPI.SHGetFileInfo(
      PChar(FileNameOrExt),
      Windows.FILE_ATTRIBUTE_NORMAL,
      Info,
      SizeOf(Info),
      ShellAPI.SHGFI_TYPENAME or ShellAPI.SHGFI_USEFILEATTRIBUTES
    ) <> 0 then
    Result := Info.szTypeName
  else
    Result := ''; // should never be reached
end;*)

(*function GetFileType2(const FilePath: string): string;
var
  Info: ShellAPI.TSHFileInfo;
begin
  if ShellAPI.SHGetFileInfo(
      PChar(FilePath),
      0,
      Info,
      SizeOf(Info),
      ShellAPI.SHGFI_TYPENAME
    ) <> 0 then
    Result := Info.szTypeName
  else
    Result := ''; // result if file or folder does not exist
end;*)


(*procedure ShowShellPropertiesDlg(const APath: string);
var
  AExecInfo: ShellAPI.TShellExecuteinfo;  // info passed to ShellExecuteEx
begin
  FillChar(AExecInfo, SizeOf(AExecInfo), 0);
  AExecInfo.cbSize := SizeOf(AExecInfo);
  AExecInfo.lpFile := PChar(APath);
  AExecInfo.lpVerb := 'properties';
  AExecInfo.fMask := ShellAPI.SEE_MASK_INVOKEIDLIST;
  ShellAPI.ShellExecuteEx(@AExecInfo);
end;*)


(*function EllipsifyText(const AsPath: Boolean; const Text: string;
  const Canvas: Graphics.TCanvas; const MaxWidth: Integer ): string;
var
  TempPChar: PChar; // temp buffer to hold text
  TempRect: TRect;  // temp rectangle hold max width of text
  Params: UINT;     // flags passed to DrawTextEx API function
begin
  // Alocate mem for PChar
  GetMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  try
    // Copy Text into PChar
    TempPChar := SysUtils.StrPCopy(TempPChar, Text);
    // Create Rectangle to Store PChar
    TempRect := Classes.Rect(0, 0, MaxWidth, High(Integer));
    // Set Params depending wether it's a path or not
    if AsPath then
      Params := Windows.DT_PATH_ELLIPSIS
    else
      Params := Windows.DT_END_ELLIPSIS;
    // Tell it to Modify the PChar, and do not draw to the canvas
    Params := Params + Windows.DT_MODIFYSTRING + Windows.DT_CALCRECT;
    // Ellipsify the string based on availble space to draw in
    Windows.DrawTextEx(Canvas.Handle, TempPChar, -1, TempRect, Params, nil);
    // Copy the modified PChar into the result
    Result := SysUtils.StrPas(TempPChar);
  finally
    // Free Memory from PChar
    FreeMem(TempPChar, (Length(Text) + 1) * SizeOf(Char));
  end;
end;*)

(*function CloneByteArray(const B: array of Byte): TBytes;
begin
  SetLength(Result, Length(B));
  if Length(B) > 0 then
    Move(B[0], Result[0], Length(B));
end;

procedure AppendByteArray(var B1: TBytes; const B2: array of Byte);
var
  OldB1Len: Integer;
begin
  if Length(B2) = 0 then
    Exit;
  OldB1Len := Length(B1);
  SetLength(B1, OldB1Len + Length(B2));
  Move(B2[0], B1[OldB1Len], Length(B2));
end;*)

(*function IsUnicodeStream(const Stm: Classes.TStream): Boolean;
var
  StmPos: LongInt;      // current position in stream
  BOM: Word;            // Unicode byte order mark
begin
  // Record current location in stream
  StmPos := Stm.Position;
  // Check if stream large enough to contain BOM (empty text file contains only
  // the BOM)
  if StmPos <= Stm.Size - SizeOf(BOM) then
  begin
    // Read first word and check if it is the unicode marker
    Stm.ReadBuffer(BOM, SizeOf(BOM));
    Result := (BOM = $FEFF);
    // Restore stream positions
    Stm.Position := StmPos;
  end
  else
    // Stream too small: can't be unicode
    Result := False;
end;

function FileHasWatermark(const FileName: string;
  const Watermark: array of Byte; const Offset: Integer = 0): Boolean;
  overload;
var
  FS: Classes.TFileStream;
begin
  FS := Classes.TFileStream.Create(
    FileName, SysUtils.fmOpenRead or SysUtils.fmShareDenyNone
  );
  try
    FS.Position := Offset;
    Result := StreamHasWatermark(FS, Watermark);
  finally
    FS.Free;
  end;
end;

function FileHasWatermarkAnsi(const FileName: string;
  const Watermark: AnsiString; const Offset: Integer = 0): Boolean;
  overload;
var
  Bytes: array of Byte;
  I: Integer;
begin
  SetLength(Bytes, Length(Watermark));
  for I := 1 to Length(Watermark) do
    Bytes[I - 1] := Ord(Watermark[I]);
  Result := FileHasWatermark(FileName, Bytes, Offset);
end;

function IsASCIIStream(const Stm: Classes.TStream; Count: Int64 = 0;
  BufSize: Integer = 8*1024): Boolean;
var
  StmPos: Int64;        // original stream position
  Buf: array of Byte;   // stream read buffer
  BytesRead: Integer;   // number of bytes read from stream in each chunk
  I: Integer;           // loops thru each byte in read buffer
begin
  Result := False;
  StmPos := Stm.Position;
  try
    if BufSize < 1024 then
      BufSize := 1024;
    SetLength(Buf, BufSize);
    if (Count = 0) or (Count > Stm.Size) then
      Count := Stm.Size;
    while Count > 0 do
    begin
      BytesRead := Stm.Read(Pointer(Buf)^, Math.Min(Count, Length(Buf)));
      if BytesRead = 0 then
        Exit;
      Dec(Count, BytesRead);
      for I := 0 to Pred(BytesRead) do
        if Buf[I] > $7F then
          Exit;
    end;
    Result := True;
  finally
    Stm.Position := StmPos;
  end;
end;

function IsASCIIFile(const FileName: string; BytesToCheck: Int64 = 0;
  BufSize: Integer = 8*1024): Boolean;
var
  Stm: Classes.TStream;
begin
  Stm := Classes.TFileStream.Create(
    FileName, SysUtils.fmOpenRead or SysUtils.fmShareDenyNone
  );
  try
    Result := IsASCIIStream(Stm, BytesToCheck, BufSize);
  finally
    Stm.Free;
  end;
end;

 function BytesToAnsiString(const Bytes: SysUtils.TBytes; const CodePage: Word):
  RawByteString;
begin
  SetLength(Result, Length(Bytes));
  if Length(Bytes) > 0 then
  begin
    Move(Bytes[0], Result[1], Length(Bytes));
    SetCodePage(Result, CodePage, False);
  end;
end;

function UnicodeStreamToWideString(const Stm: Classes.TStream): WideString;
var
  DataSize: LongInt;  // size of Unicode text in stream in bytes
begin
  if IsUnicodeStream(Stm) then
  begin
    // Data on stream is Unicode with BOM
    // Check remaining stream, less BOM, contains whole number of wide chars
    DataSize := Stm.Size - Stm.Position - SizeOf(Word);
    if DataSize mod SizeOf(WideChar) <> 0 then
      Classes.EStreamError.CreateFmt(
        'Remaining data in stream must be a mulitple of %d bytes',
        [SizeOf(WideChar)]
      );
    // Skip over BOM
    Stm.Position := Stm.Position + SizeOf(Word);
    // Read stream into result
    SetLength(Result, DataSize div SizeOf(WideChar));
    Stm.ReadBuffer(Windows.PByte(PWideChar(Result))^, DataSize);
  end
  else
    // Data on stream is assumed to be ANSI
    Result := StreamToString(Stm);  // automatically cast to WideString
end;

procedure WideStringToUnicodeStream(const Str: WideString;
  const Stm: Classes.TStream);
var
  BOM: Word;  // Unicode byte order mark
begin
  BOM := $FEFF;
  Stm.WriteBuffer(BOM, SizeOf(BOM));
  Stm.WriteBuffer(Pointer(Str)^, SizeOf(WideChar) * Length(Str));
end;

procedure GraphicToBitmap(const Src: Graphics.TGraphic;
  const Dest: Graphics.TBitmap; const TransparentColor: Graphics.TColor);
begin
  // Do nothing if either source or destination are nil
  if not Assigned(Src) or not Assigned(Dest) then
    Exit;
  // Size the bitmap
  Dest.Width := Src.Width;
  Dest.Height := Src.Height;
  if Src.Transparent then
  begin
    // Source graphic is transparent, make bitmap behave transparently
    Dest.Transparent := True;
    if (TransparentColor <> Graphics.clNone) then
    begin
      // Set destination as transparent using required colour key
      Dest.TransparentColor := TransparentColor;
      Dest.TransparentMode := Graphics.tmFixed;
      // Set background colour of bitmap to transparent colour
      Dest.Canvas.Brush.Color := TransparentColor;
    end
    else
      // No transparent colour: set transparency to automatic
      Dest.TransparentMode := Graphics.tmAuto;
  end;
  // Clear bitmap to required background colour and draw bitmap
  Dest.Canvas.FillRect(Classes.Rect(0, 0, Dest.Width, Dest.Height));
  Dest.Canvas.Draw(0, 0, Src);
end;

*)


{$ENDIF}

  var aday:TStDayType; 
      akd: TKEditKey;
      akcommand: TKEditCommand;
      acommass: TKEditCommandAssignment;
      idbase: TIdBaseComponent;
      aspstack: TKMemoSparseStack;

begin  //main
  ApplicationHasPriority:= true;
  Process;
  //class procedure DoProcess(const AIdle: boolean = true; const AOverride: boolean = false);
  with TIdAntiFreeze.create(self) do begin
    writeln(botostr(shoulduse));
    //DoProcess(true, false)
    active:= false;
    writeln('id vers: '+version)
    Free;
    //TIdBaseComponent().Free
  end; 
  
  with TIdThreadSafeStringList.create(true) do begin
    Add('coolcode!')
    lock;
    unlock;
    Free
  end;  
  
  //TIdBaseComponent missing
  { with TIdCustomThreadComponent.create(self) do begin
    Add('coolcode!')
    lock;
    unlock;
    Free
  end;    }
  
  with TIdThreadMgr.create(self) do begin
    //getthread
    free
  end;  
 
  with TIdBasicAuthentication.create do begin
    //Add('coolcode!§')
    writeln('Authentication: '+Authentication)
    //lock;
    //unlock;
    writeln(version)
    Free
  end;   
 
  
  with TKEditKeyMapping.create do begin
    try
    EmptyMap;
    except
      writeln('Except: out of stack!')
    end  
    //Assign(TStringlist.create)
    //FindCommand  §
    //TKEditCommand(self).AddKey
   //&&key;
   //map;
  free
  end;
  
  with TKMemoDictionary.create do begin
    //EmptyMap;
    //Assign
    //FindCommand
    //TKEditCommand(self).AddKey
   //key;
   //map;
   AddItem(12,1234567{'coolcode!§})
   FindItem(12);
   writeln(itoa(items[0].value))
  free
  end;
  
  aday:= monday;   
  aday:= Wednesday;
  writeln(itoa(ord(aday)))  
  
  writeln(ProgramFilesFolder)
  writeln(itoa(hinstance))
  writeln(itoa(application.handle))
  
  writeln('WindowSupportsLayers: '+botostr(WindowSupportsLayers(hinstance)))
  
  writeln(ResourceIDToStr('3780'))
  writeln(WindowsProductID)
  writeln('IsIEInstalled '+botostr(IsIEInstalled))
  
  writeln(GetFileType2(exepath+'maxbox4.exe'))
  //TypeS('TUnitType', '( utSrc, utHead, utRes, utPrj, utOther )
  writeln(itoa(ord(GetFileTyp(exepath+'maxbox4.exe'))))
  
        //URIDecode
         //URIEncode
       //URLDecode2  
        //URLEncode2 
        
    //SetTransparencyLevel(const HWnd: HWND;
      //     const Level: Byte): Boolean;
   //IsEqualResID(const R1, R2: PChar): Boolean;         //55
   //GetGenericFileType(const FileNameOrExt: string): string;
   //GetFileType2(const FilePath: string): string;
   //ShowShellPropertiesDlg(const APath: string);
   //EllipsifyText(const AsPath: Boolean; const Text: string;
     //      const Canvas: TCanvas; const MaxWidth: Integer ): string;
   //CloneByteArray(const B: array of Byte): TBytes;       //60
   //AppendByteArray(var B1: TBytes; const B2: array of Byte);
   //IsUnicodeStream(const Stm: TStream): Boolean;
   //FileHasWatermark(const FileName: string;
     //       const Watermark: array of Byte; const Offset: Integer): Boolean;
   //FileHasWatermarkAnsi(const FileName: string;
     //        const Watermark: AnsiString; const Offset: Integer): Boolean;
   //IsASCIIStream(const Stm: TStream; Count: Int64 = 0;
     //                            BufSize: Integer = 8*1024): Boolean;
   //IsASCIIFile(const FileName: string; BytesToCheck: Int64 = 0;
     //                          BufSize: Integer = 8*1024): Boolean;      //66
    //BytesToAnsiString(const Bytes: TBytes; const CodePage: Word):
                          //            RawByteString;
   //UnicodeStreamToWideString(const Stm: TStream): WideString;
  //WideStringToUnicodeStream(const Str: WideString;
                                            ///const Stm: TStream);
   //GraphicToBitmap(const Src: TGraphic;
     //         const Dest: TBitmap; const TransparentColor: TColor);  //70

   //URIDecode(S: string; const IsQueryString: Boolean): string;
   //URIEncode(const S: string; const InQueryString: Boolean): string;
 //  URLDecode2(const S: string): string;
   //URLEncode2(const S: string; const InQueryString: Boolean): string;
   writeln('AllDigitsSame '+botostr(AllDigitsSame(777)));                                       //75
   // BytestoString
   
     ShowShellPropertiesDlg(exepath+'maxbox4.exe') 
   
End.

//http://www.softwareschule.ch/download/maxbox_starter44.pdf

//https://www.metadefender.com/#!/results/file/d18f22811efc40c2825bd49d18783bce/regular

{An introduction in coding with maXbox the script engine. The tool is build on a precompiled object based scripting library.
The tool is also based on an educational program with examples and exercises (from biorhythm, form builder to how encryption and network works). Units are precompiled and objects invokable!}

{1.1 Command with Macros 
1.2 Extend with DLL
1.3 Alias Naming 
1.4 Console Capture DOS 
1.5 Byte Code Performance 
1.6 Exception Handling 
1.7 Config Ini File
1.8 The Log Files 
1.9 Use Case Model
1.10 Open Tool API
                  }