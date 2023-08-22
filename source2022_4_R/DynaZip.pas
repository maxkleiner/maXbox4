unit DynaZip;

interface

uses
  WinTypes, WinProcs, Classes, SysUtils, Consts, Dialogs;

const

  ZIPINFO_DATETIME_SIZE = 18;
  ZIPINFO_FNAME_SIZE    = 260;

{ -- message callback defines }
  MSGID_DISK            = 0;
  MSGID_DISKOFDISK      = 1;
  MSGID_ZOPEN           = 2;
  MSGID_ZREAD           = 3;
  MSGID_ZWRITE          = 4;
  MSGID_NOREMOVE        = 5;
  MSGID_SAMEVOL         = 6;
  MSGID_ZFORMAT         = 7;
  MSGID_OVERWRT         = 8;
  MSGID_CODEERR         = 9;
  MSGID_MVBADFIRSTDISK  = 10;
  MSGID_ERROR           = 11;
  MSGID_WARN            = 12;
  MSGID_CHANGE          = 13;

type
  TLPStr = class(TPersistent)
  private
    FCharPtr: PChar;
    FBufSize: word;
    FBufFixed: boolean;
{FJK981101 not used
    FUpdateCount: Integer;
}
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(Size: word);
    destructor Destroy; override;
    procedure Clear; virtual;
    function GetBufSize: word;
    function GetPtr: pchar;
    function GetText(var Dest: PChar): PChar; virtual;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SetBufSize(Size: word);
    procedure SetText(Text: PChar); virtual;
  end;



  PDZRename = ^DZRename;
  DZRename =
    record
      Name : Array[0..ZIPINFO_FNAME_SIZE - 1] of Char;
      Date : Integer;
      Time : Integer;
      Attr : LongInt;
      OrigName: Array[0..ZIPINFO_FNAME_SIZE - 1] of Char;
    end;

  TStatusCallback = procedure(szItem: PChar; Percent: longint;
                              var DoCancel: Boolean) of object;

  TMessageCallback = procedure(MsgID, mbType: word; p1, p2: integer;
                               lpsz1, lpsz2: PChar;
                               var RtnResult: integer) of object;

  TRenameCallback = procedure(dzr: PDZRename) of object;

{-- TDynaZip --}

  TDynaZip = class(TComponent)
     private
        FOnMajor       : TStatusCallback;
        FOnMinor       : TStatusCallback;
        FOnMessage     : TMessageCallback;
        FOnRename      : TRenameCallback;
     public
        procedure DoOnMajor(szItem: PChar; Percent: longint;
                              var DoCancel: Boolean);
        procedure DoOnMinor(szItem: PChar; Percent: longint;
                              var DoCancel: Boolean);
        procedure DoOnMessage(MsgID, mbType: word; p1, p2: integer;
                              lpsz1, lpsz2: PChar; var RtnResult: integer);
        procedure DoOnRename(dzr: PDZRename);

        procedure NoCanDo(Value: TLPStr);
     published
        property OnMajorCallback: TStatusCallback read FOnMajor write FOnMajor;
        property OnMinorCallback: TStatusCallback read FOnMinor write FOnMinor;
        property OnMessageCallback: TMessageCallback read FOnMessage write FOnMessage;
        property OnRenameCallback: TRenameCallback read FOnRename write FOnRename;
  end;

{$IFDEF WIN32}
function MajorCallBack(szItem    : Pchar;
                       percent   : LongInt;
                       majorData : Pointer): bool; StdCall;
function MinorCallBack(szItem    : Pchar;
                       percent   : LongInt;
                       minorData : Pointer): bool; StdCall;
function MessageCallback(MsgID, mbType: word; p1, p2: integer;
                         lpsz1, lpsz2: PChar;
                         MessageData: Pointer): integer; StdCall;
function RenameCallback(dzr: PDZRename; RenameData: pointer): integer; StdCall;
{$ELSE}
function MajorCallBack(szItem    : Pchar;
                       percent   : LongInt;
                       majorData : Pointer): bool; export;
function MinorCallBack(szItem    : Pchar;
                       percent   : LongInt;
                       minorData : Pointer): bool; export;
function MessageCallback(MsgID, mbType: word; p1, p2: integer;
                         lpsz1, lpsz2: PChar;
                         MessageData: Pointer): integer; export;
function RenameCallback(dzr: PDZRename; RenameData: pointer): integer; export;
{$ENDIF}

implementation

constructor TLPStr.Create(Size: word);
begin
   inherited Create;
   FBufSize := 0;
   FCharPtr := nil;
   FBufFixed := Size > 0;
   if FBufFixed then
      SetBufSize(Size);
end;

destructor TLPStr.Destroy;
begin
   StrDispose(FCharPtr);
   FCharPtr := nil;
   inherited Destroy;
end;

procedure TLPStr.Clear;
begin
   if not FBufFixed then
   begin
      StrDispose(FCharPtr);
      FCharPtr := nil;
   end
   else
      FCharPtr[0] := #0;
end;

procedure TLPStr.DefineProperties(Filer: TFiler);
var
   i: integer;
begin
  i := 0;
  if FCharPtr <> nil then i := StrLen(FCharPtr);
  Filer.DefineProperty('PChar', ReadData, WriteData, i > 0);
end;

function TLPStr.GetPtr: PChar;
begin
   Result := FCharPtr;
end;

function TLPStr.GetBufSize: word;
begin
   Result := FBufSize;
end;

function TLPStr.GetText(var Dest: PChar): PChar;
begin
   if FCharPtr = nil then
   begin
      if Dest = nil then
         Dest := StrAlloc(2);
      Dest[0] := #0
   end
   else
   begin
      if Dest = nil then
         Dest := StrNew(FCharPtr)
      else
         StrCopy(Dest, FCharPtr);
   end;
   Result := Dest;
end;

procedure TLPStr.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TLPStr.LoadFromStream(Stream: TStream);
const
  DefSize = 32768;
var
  BSize: word;
  Count: longint;
  Buffer, BufEnd: PChar;
begin
    if FBufFixed then
       BSize := FBufSize
    else
       BSize := DefSize;
    GetMem(Buffer, BSize);
    try
      BufEnd := Buffer;
      Count := Stream.Read(Buffer[0], BSize);
      BufEnd := BufEnd + Count;
      if Count < BSize then BufEnd[0] := #0 else
      begin
         {raise EStreamError.Create(LoadStr(SLineTooLong));}
      end;
      SetText(Buffer);
    finally
      FreeMem(Buffer, BSize);
    end;
end;

procedure TLPStr.ReadData(Reader: TReader);
var
   ReadLen: longint;
   va     : TValueType;
   ps     : pchar;
begin
  Clear;
  Reader.Read(va, SizeOf(TValueType));
  ReadLen := 0;
  Reader.Read(ReadLen,SizeOf(ReadLen));
  if ReadLen > 0 then         {ReadLen contains string length + null char}
  begin
     ps := StrAlloc(ReadLen);
     try
        Reader.Read(ps[0],ReadLen);
        SetText(ps);
     finally
        StrDispose(ps);
     end;
  end;
end;

procedure TLPStr.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TLPStr.SaveToStream(Stream: TStream);
begin
   if FCharPtr <> nil then
      Stream.WriteBuffer(FCharPtr[0], StrLen(FCharPtr));
end;

procedure TLPStr.SetBufSize(Size: word);
var
   ps: PChar;
begin
   if FBufSize = Size then
   begin
      FBufFixed := true;
      exit;
   end;
   if Size = 0 then
   begin
      FBufFixed := false;
      exit;
   end;
   try
      ps := StrAlloc(Size);
      ps[0] := #0;
   except
      ps := nil;
   end;
   if ps <> nil then
   begin
      FBufFixed := true;
      if FCharPtr <> nil then
      begin
         StrLCopy(ps,FCharPtr, pred(Size));
         StrDispose(FCharPtr);
      end;
      FCharPtr := ps;
      FBufSize := Size;
   end;
end;

procedure TLPStr.SetText(Text: PChar);
begin
   Clear;
   if Text = nil then exit;
   if FCharPtr = nil then
   begin
      FCharPtr := StrNew(Text);
      FBufSize := succ(StrLen(FCharPtr));
   end
   else
      StrLCopy(FCharPtr, Text, pred(FBufSize));
end;

procedure TLPStr.WriteData(Writer: TWriter);
var
  I: longint;
  va : TValueType;
begin
   va := vaBinary;
   Writer.Write(va,SizeOf(TValueType));
   I := succ(StrLen(FCharPtr));
   Writer.Write(I,SizeOf(I));
   Writer.Write(FCharPtr[0],I);
end;

{-------------------------------------------------------------------}

function MajorCallBack(szItem    : Pchar;
                       percent   : LongInt;
                       majorData : Pointer): bool;
var
   DoCancel: boolean;
begin
   DoCancel := false;
   TDynaZip(majordata).DoOnMajor(szItem, percent, DoCancel);
   MajorCallBack := DoCancel;
end;

function MinorCallBack(szItem    : Pchar;
                       percent   : LongInt;
                       minorData : Pointer): bool;
var
   DoCancel: boolean;
begin
   DoCancel := false;
   TDynaZip(minordata).DoOnMinor(szItem, percent, DoCancel);
   MinorCallBack := DoCancel;
end;

function MessageCallback(MsgID, mbType: word; p1, p2: integer;
                         lpsz1, lpsz2: PChar;
                         MessageData: Pointer): integer;
var
   RtnResult: integer;
begin
   RtnResult := 0;
   TDynaZip(MessageData).DoOnMessage(MsgID,mbType,p1,p2,lpsz1,lpsz2,RtnResult);
   MessageCallback := RtnResult;
end;

function RenameCallback(dzr: PDZRename; RenameData: pointer): integer; 
begin
   TDynaZip(RenameData).DoOnRename(dzr);
   RenameCallback := 0;
end;


{-------------------------------------------------------------------}

procedure TDynaZip.NoCanDo(Value: TLPStr);
begin
   MessageDlg('Cannot Directly assign a value to type LPSTR.  Use SetText',
                mtInformation,[mbOk], 0);
end;

procedure TDynaZip.DoOnMajor(szItem: PChar; Percent: longint;
                              var DoCancel: Boolean);
begin
   if assigned(FOnMajor) then
      FOnMajor(szItem, Percent, DoCancel);
end;

procedure TDynaZip.DoOnMinor(szItem: PChar; Percent: longint;
                              var DoCancel: Boolean);
begin
   if assigned(FOnMinor) then
      FOnMinor(szItem, Percent, DoCancel);
end;

procedure TDynaZip.DoOnMessage(MsgID, mbType: word; p1, p2: integer;
                               lpsz1, lpsz2: PChar; var RtnResult: integer);
begin
   if assigned(FOnMessage) then
      FOnMessage(MsgID,mbType,p1,p2,lpsz1,lpsz2,RtnResult);
end;

procedure TDynaZip.DoOnRename(dzr: PDZRename);
begin
   if assigned(FOnRename) then
      FOnRename(dzr);
end;

end.


