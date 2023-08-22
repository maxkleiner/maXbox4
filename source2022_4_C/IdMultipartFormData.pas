{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10267: IdMultipartFormData.pas 
{
{   Rev 1.7    7/16/04 12:02:54 PM  RLebeau
{ Reverted FileName fields to not strip off folder paths anymore.
}
{
{   Rev 1.6    7/5/04 1:18:18 PM  RLebeau
{ Updated Read() to check the calculated byte count before copying data into
{ the caller's buffer.
}
{
{   Rev 1.5    5/31/04 9:29:30 PM  RLebeau
{ Updated FileName fields to strip off folder paths.
{ 
{ Added "Content-Transfer-Encoding" header to file fields
{ 
{ Updated "Content-Type" headers to be the appropriate media types when
{ applicable
}
{
{   Rev 1.3    3/1/04 8:53:46 PM  RLebeau
{ Format() fixes for TIdMultiPartFormDataStream.FormatField() and
{ TIdFormDataField.GetFieldSize().
}
{
{   Rev 1.2    9/10/2003 02:58:38 AM  JPMugaas
{ Format() fixes for TIdMultiPartFormDataStream.FormatField() and
{ TIdFormDataField.GetFieldSize().  Checked in on behalf of Remy Lebeau
}
{
{   Rev 1.1    01.2.2003 ã. 12:00:00  DBondzhev
}
{
{   Rev 1.0    2002.11.12 10:46:56 PM  czhower
}
unit IdMultipartFormData;

{
  Implementation of the Multipart From data

  Author: Shiv Kumar
  Copyright: (c) Chad Z. Hower and The Winshoes Working Group.

Details of implementation
-------------------------
2001-Nov Doychin Bondzhev
 - Now it descends from TStream and does not do buffering.
 - Changes in the way the form parts are added to the stream.

 2001-Nov-23
  - changed spelling error from XxxDataFiled to XxxDataField
}


interface

uses
  SysUtils, Classes, IdGlobal, IdException, IdResourceStrings;

const
  sContentTypeFormData = 'multipart/form-data; boundary=';
  sContentTypeOctetStream = 'application/octet-stream';
  crlf = #13#10;
  sContentDisposition = 'Content-Disposition: form-data; name="%s"';
  sFileNamePlaceHolder = '; filename="%s"';
  sContentTypePlaceHolder = 'Content-Type: %s';
  sContentTransferEncoding = 'Content-Transfer-Encoding: binary';

type
  TIdMultiPartFormDataStream = class;

  TIdFormDataField = class(TCollectionItem)
  protected
    FFieldValue: string;
    FFileName: string;
    FContentType: string;
    FFieldName: string;
    FFieldObject: TObject;
    FCanFreeFieldObject: Boolean;

    function GetFieldSize: LongInt;
    function GetFieldStream: TStream;
    function GetFieldStrings: TStrings;
    procedure SetContentType(const Value: string);
    procedure SetFieldName(const Value: string);
    procedure SetFieldStream(const Value: TStream);
    procedure SetFieldStrings(const Value: TStrings);
    procedure SetFieldValue(const Value: string);
    procedure SetFieldObject(const Value: TObject);
    procedure SetFileName(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    // procedure Assign(Source: TPersistent); override;
    function FormatField: string;
    property ContentType: string read FContentType write SetContentType;
    property FieldName: string read FFieldName write SetFieldName;
    property FieldStream: TStream read GetFieldStream write SetFieldStream;
    property FieldStrings: TStrings read GetFieldStrings write SetFieldStrings;
    property FieldObject: TObject read FFieldObject write SetFieldObject;
    property FileName: string read FFileName write SetFileName;
    property FieldValue: string read FFieldValue write SetFieldValue;
    property FieldSize: LongInt read GetFieldSize;
  end;

  TIdFormDataFields = class(TCollection)
  protected
    FParentStream: TIdMultiPartFormDataStream;
    function GetFormDataField(AIndex: Integer): TIdFormDataField;
  public
    constructor Create(AMPStream: TIdMultiPartFormDataStream);
    function Add: TIdFormDataField;
    property MultipartFormDataStream: TIdMultiPartFormDataStream read FParentStream;
    property Items[AIndex: Integer]: TIdFormDataField read GetFormDataField;
  end;

  TIdMultiPartFormDataStream = class(TStream)
  protected
    FInputStream: TStream;
    FBoundary: string;
    FRequestContentType: string;
    FCurrentItem: integer;
    FInitialized: Boolean;
    FInternalBuffer: string;

    FPosition: Int64;
    FSize: Int64;

    FFields: TIdFormDataFields;

    function GenerateUniqueBoundary: string;
    function PrepareStreamForDispatch: string;
  public
    constructor Create;
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;

    procedure AddFormField(const AFieldName, AFieldValue: string);
    procedure AddObject(const AFieldName, AContentType: string; AFileData: TObject; const AFileName: string = '');
    procedure AddFile(const AFieldName, AFileName, AContentType: string);

    property Boundary: string read FBoundary;
    property RequestContentType: string read FRequestContentType;
  end;

  EIdInvalidObjectType = class(EIdException);

implementation

{ TIdMultiPartFormDataStream }

constructor TIdMultiPartFormDataStream.Create;
begin
  inherited Create;
  FSize := 0;
  FInitialized := False;
  FBoundary := GenerateUniqueBoundary;
  FRequestContentType := sContentTypeFormData + FBoundary;
  FFields := TIdFormDataFields.Create(Self);
end;

destructor TIdMultiPartFormDataStream.Destroy;
begin
  FreeAndNil(FFields);
  inherited Destroy;
end;

procedure TIdMultiPartFormDataStream.AddObject(const AFieldName,
  AContentType: string; AFileData: TObject; const AFileName: string = '');
var
  LItem: TIdFormDataField;
begin
  LItem := FFields.Add;

  with LItem do begin
  	FFieldName := AFieldName;
	  FFileName := AFileName;
  	FFieldObject := AFileData;
    if Length(AContentType) > 0 then begin
  	  FContentType := AContentType;
    end else begin
      if Length(FFileName) > 0 then begin
        FContentType := GetMIMETypeFromFile(FFileName);
      end else begin
        FContentType := sContentTypeOctetStream;
      end;
    end;
  end;

  FSize := FSize + LItem.FieldSize;
end;

procedure TIdMultiPartFormDataStream.AddFile(const AFieldName, AFileName,
  AContentType: string);
var
  LStream: TFileStream;
  LItem: TIdFormDataField;
begin
  LStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
  	LItem := FFields.Add;
  except
	  FreeAndNil(LStream);
  	raise;
  end;

  with LItem do begin
  	FFieldName := AFieldName;
	  FFileName := AFileName;
  	FFieldObject := LStream;
  	FCanFreeFieldObject := True;
    if Length(AContentType) > 0 then begin
  	  FContentType := AContentType;
    end else begin
      FContentType := GetMIMETypeFromFile(AFileName);
    end;
  end;

  FSize := FSize + LItem.FieldSize;
end;

procedure TIdMultiPartFormDataStream.AddFormField(const AFieldName,
  AFieldValue: string);
var
  LItem: TIdFormDataField;
begin
  LItem := FFields.Add;

  with LItem do begin
  	FFieldName := AFieldName;
	  FFieldValue := AFieldValue;
  end;

  FSize := FSize + LItem.FieldSize;
end;

function TIdMultiPartFormDataStream.GenerateUniqueBoundary: string;
begin
  Result := '--------' + FormatDateTime('mmddyyhhnnsszzz', Now);
end;

function TIdMultiPartFormDataStream.PrepareStreamForDispatch: string;
begin
  Result := {crlf +} '--' + Boundary + '--' + crlf;
end;

// RLebeau - Read() should wrap multiple files using a single
// "multipart/mixed" MIME part, as recommended by RFC 1867

function TIdMultiPartFormDataStream.Read(var Buffer;
  Count: Integer): Longint;
type
  PByteArray = ^TByteArray;
  TByteArray = array[0..High(Integer) - 1] of Byte; // 2GB size
var
  LTotalRead: Integer;
  LCount: Integer;
  LBufferCount: Integer;
  LItem: TIdFormDataField;
begin
  if not FInitialized then begin
    FInitialized := True;
    FCurrentItem := 0;
    SetLength(FInternalBuffer, 0);
  end;

  LTotalRead := 0;
  LBufferCount := 0;

  while (LTotalRead < Count) and ((FCurrentItem < FFields.Count) or (Length(FInternalBuffer) > 0)) do begin
    if (Length(FInternalBuffer) = 0) and not Assigned(FInputStream) then begin
      LItem := FFields.Items[FCurrentItem];
      FInternalBuffer := LItem.FormatField;

      if Assigned(LItem.FieldObject) then begin
        if (LItem.FieldObject is TStream) then begin
          FInputStream := TStream(LItem.FieldObject);
          FInputStream.Seek(0, soFromBeginning);
        end else begin
          if (LItem.FieldObject is TStrings) then begin
            FInternalBuffer := FInternalBuffer + TStrings(LItem.FieldObject).Text;
            Inc(FCurrentItem);
          end;
        end;
      end else begin
        Inc(FCurrentItem);
      end;
    end;

    if Length(FInternalBuffer) > 0 then begin
      if Length(FInternalBuffer) > (Count - LBufferCount) then begin
        LCount := Count - LBufferCount;
      end else begin
        LCount := Length(FInternalBuffer);
      end;

      if LCount > 0 then begin
        Move(FInternalBuffer[1], TByteArray(Buffer)[LBufferCount], LCount);
        Delete(FInternalBuffer, 1, LCount);
        LBufferCount := LBufferCount + LCount;
        FPosition := FPosition + LCount;
        LTotalRead := LTotalRead + LCount;
      end;
    end;

    if Assigned(FInputStream) and (LTotalRead < Count) then begin
      LCount := FInputStream.Read(TByteArray(Buffer)[LBufferCount], Count - LTotalRead);
      if LCount < (Count - LTotalRead) then begin
        FInputStream.Seek(0, soFromBeginning);
        FInputStream := nil;
        Inc(FCurrentItem);
        FInternalBuffer := #13#10;
      end;

      LBufferCount := LBufferCount + LCount;
      LTotalRead := LTotalRead + LCount;
      FPosition := FPosition + LCount;
    end;

    if FCurrentItem = FFields.Count then begin
      FInternalBuffer := FInternalBuffer + PrepareStreamForDispatch;
      Inc(FCurrentItem);
    end;
  end;
  Result := LTotalRead;
end;

function TIdMultiPartFormDataStream.Seek(Offset: Integer;
  Origin: Word): Longint;
begin
  Result := 0;
  case Origin of
    soFromBeginning: begin
        if (Offset = 0) then begin
          FInitialized := False;
          FPosition := 0;
          Result := 0;
        end else begin
          Result := FPosition;
        end;
      end;
    soFromCurrent: begin
        Result := FPosition;
      end;
    soFromEnd: begin
        Result := FSize + Length(PrepareStreamForDispatch);
      end;
  end;
end;

function TIdMultiPartFormDataStream.Write(const Buffer;
  Count: Integer): Longint;
begin
  raise Exception.Create('Unsupported operation.');
end;

{ TIdFormDataFields }

function TIdFormDataFields.Add: TIdFormDataField;
begin
  Result := TIdFormDataField(inherited Add);
end;

constructor TIdFormDataFields.Create(AMPStream: TIdMultiPartFormDataStream);
begin
  inherited Create(TIdFormDataField);
  FParentStream := AMPStream;
end;

function TIdFormDataFields.GetFormDataField(
  AIndex: Integer): TIdFormDataField;
begin
  Result := TIdFormDataField(inherited Items[AIndex]);
end;

{ TIdFormDataField }

constructor TIdFormDataField.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFieldObject := nil;
  FFileName := '';
  FFieldName := '';
  FContentType := '';
  FCanFreeFieldObject := False;
end;

destructor TIdFormDataField.Destroy;
begin
  if Assigned(FFieldObject) then begin
    if FCanFreeFieldObject then begin
      FreeAndNil(FFieldObject);
    end;
  end;
  inherited Destroy;
end;

function TIdFormDataField.FormatField: string;
var
  LBoundary: string;
begin
  LBoundary := TIdFormDataFields(Collection).MultipartFormDataStream.Boundary;

  if Assigned(FieldObject) then begin
    if Length(FileName) > 0 then begin
      Result := Format('--%s' + crlf + sContentDisposition +
        sFileNamePlaceHolder + crlf + sContentTypePlaceHolder +
        crlf + sContentTransferEncoding + crlf + crlf,
        [LBoundary, FieldName, FileName, ContentType]);
      Exit;
    end;
  end;

  Result := Format('--%s' + crlf + sContentDisposition + crlf + crlf +
        '%s' + crlf, [LBoundary, FieldName, FieldValue]);
end;

function TIdFormDataField.GetFieldSize: LongInt;
begin
  Result := Length(FormatField);
  if Assigned(FFieldObject) then begin
    if FieldObject is TStrings then begin
      Result := Result + Length(TStrings(FieldObject).Text) + 2;
    end else begin
      if FieldObject is TStream then begin
        Result := Result + TStream(FieldObject).Size + 2;
      end;
    end;
  end;
end;

function TIdFormDataField.GetFieldStream: TStream;
begin
  Result := nil;
  if Assigned(FFieldObject) then begin
    if (FFieldObject is TStream) then begin
      Result := TStream(FFieldObject);
    end else begin
      raise EIdInvalidObjectType.Create(RSMFDIvalidObjectType);
    end;
  end;
end;

function TIdFormDataField.GetFieldStrings: TStrings;
begin
  Result := nil;
  if Assigned(FFieldObject) then begin
    if (FFieldObject is TStrings) then begin
      Result := TStrings(FFieldObject);
    end else begin
      raise EIdInvalidObjectType.Create(RSMFDIvalidObjectType);
    end;
  end;
end;

procedure TIdFormDataField.SetContentType(const Value: string);
begin
  if Length(Value) > 0 then begin
    FContentType := Value;
  end else begin
    if Length(FFileName) > 0 then begin
      FContentType := GetMIMETypeFromFile(FFileName);
    end else begin;
      FContentType := sContentTypeOctetStream;
    end;
  end;
  GetFieldSize;
end;

procedure TIdFormDataField.SetFieldName(const Value: string);
begin
  FFieldName := Value;
  GetFieldSize;
end;

procedure TIdFormDataField.SetFieldObject(const Value: TObject);
begin
  if Assigned(Value) then begin
    if not ((Value is TStream) or (Value is TStrings)) then begin
      raise EIdInvalidObjectType.Create(RSMFDIvalidObjectType);
    end;
  end;

  if Assigned(FFieldObject) then begin
    if FCanFreeFieldObject then begin
      FreeAndNil(FFieldObject);
    end;
  end;

  FFieldObject := Value;
  FCanFreeFieldObject := False;
  GetFieldSize;
end;

procedure TIdFormDataField.SetFieldStream(const Value: TStream);
begin
  FieldObject := Value;
end;

procedure TIdFormDataField.SetFieldStrings(const Value: TStrings);
begin
  FieldObject := Value;
end;

procedure TIdFormDataField.SetFieldValue(const Value: string);
begin
  FFieldValue := Value;
  GetFieldSize;
end;

procedure TIdFormDataField.SetFileName(const Value: string);
begin
  FFileName := Value;
  GetFieldSize;
end;

end.

