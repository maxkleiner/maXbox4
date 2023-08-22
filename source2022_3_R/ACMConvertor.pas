unit ACMConvertor;

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: ACMConvertor.pas, released August 28, 2000.

The Initial Developer of the Original Code is Peter Morris (pete@stuckindoors.com),
Portions created by Peter Morris are Copyright (C) 2000 Peter Morris.
All Rights Reserved.

Purpose of file:
Allows you to specify formats required for ACMIn and ACMOut, also allows you
to convert the data rather than just play / record it.

Contributor(s):
None as yet


Last Modified: September 14, 2000
Current Version: 1.10

You may retrieve the latest version of this file at http://www.stuckindoors.com/dib

Known Issues:
TrueSpeech doesn't work for some reason.
-----------------------------------------------------------------------------}

interface

uses
  Classes, Messages, Windows, Forms, SysUtils, Controls, MSACM, MMSystem;

type
  EACMConvertor = class(Exception);

//  TMandatorySetting = (msFormatTag, msChannels, msSamplesPerSec, msBitsPerSample);
//  TMandatorySettings = set of TMandatorySetting;

  TACMWaveFormat = packed record
    case integer of
      0 : (Format : TWaveFormatEx);
      1 : (RawData : Array[0..128] of byte);
  end;

  TACMConvertor = Class(TComponent)
  private
    FChooseData               : TACMFORMATCHOOSEA;
    FActive                   : Boolean;
    FBufferIn                 : Pointer;
    FBufferOut                : Pointer;
    FInputBufferSize          : DWord;
    FOutputBufferSize         : DWord;
    FStartOfStream            : Boolean;
    FStreamHandle             : HACMStream;
    FStreamHeader             : TACMStreamHeader;

    procedure ReadFormatIn(Stream : TStream);
    procedure ReadFormatOut(Stream : TStream);
    procedure WriteFormatIn(Stream : TStream);
    procedure WriteFormatOut(Stream : TStream);
    procedure SetActive(const Value: Boolean);
    procedure SetInputBufferSize(const Value: DWord);
  protected
    procedure CloseStream;
    procedure DefineProperties(Filer : TFiler); override;
    procedure OpenStream;
    procedure ReadFormat(var Format : TACMWaveFormat; Stream : TStream);
    procedure WriteFormat(var Format : TACMWaveFormat; Stream : TStream);
  public
    FormatIn,
    FormatOut                 : TACMWaveFormat;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    function  ChooseFormat(var Format : TACMWaveFormat; const UseDefault : Boolean) : Boolean;
    function  ChooseFormatIn(const UseDefault : Boolean) : Boolean;
    function  ChooseFormatOut(const UseDefault : Boolean) : Boolean;
    function  Convert : DWord;
    procedure RaiseException(aMessage : String; Result : MMResult);
    function  SuggestFormat(aFormat : TACMWaveFormat{; MandatorySettings : TMandatorySettings}) : TACMWaveFormat;

    property Active           : Boolean
      read FActive
      write SetActive;
    property BufferIn         : Pointer
      read FBufferIn;
    property BufferOut        : Pointer
      read FBufferOut;
    property OutputBufferSize : DWord
      read FOutputBufferSize;
  published
    property InputBufferSize  : DWord
      read FInputBufferSize
      write SetInputBufferSize;
  end;

implementation
{ TACMConvertor }

function TACMConvertor.ChooseFormat(var Format: TACMWaveFormat; const UseDefault : Boolean) : Boolean;
var
  OrigFormat                  : PWaveFormatEX;
  Res                         : Longint;
begin
  Result := False;
  GetMem(OrigFormat,Sizeof(TACMWaveFormat));

  try
    if UseDefault then
      Move(Format,OrigFormat^, SizeOf(TACMWaveFormat))
    else with OrigFormat^ do begin
      wFormatTag := 49;   // Default to GSM6.10
      nChannels := 1;     // Mono
      nSamplesPerSec := 8000; //Low enough to strean
      nAvgBytesPerSec:= 8000;
      nBlockAlign:=1;
      wbitspersample := 8;
      cbSize := SizeOf(TACMWaveFormat);
    end;

    with FChooseData do begin
      pwfx := OrigFormat;
      cbStruct := SizeOf(FChooseData);  //Size of this structure
      cbwfx := SizeOf(TACMWaveFormat);  //Size of our WaveFormat

      fdwStyle := ACMFORMATCHOOSE_STYLEF_INITTOWFXSTRUCT //use our default when choosing
    end;

    Res := acmFormatChoose(FChooseData);

    if Res = MMSYSERR_NoError then begin
      Move(FChooseData.pwfx^,Format, SizeOf(TACMWaveFormat));
      Result := True;
    end else
      if Res <> ACMErr_Canceled then RaiseException('Choose format', Res);
  finally
    FreeMem(OrigFormat);
  end;
end;

function TACMConvertor.ChooseFormatIn(const UseDefault : Boolean) : Boolean;
begin
  Result := ChooseFormat(FormatIn, UseDefault);
end;

function TACMConvertor.ChooseFormatOut( const UseDefault : Boolean): Boolean;
begin
  Result := ChooseFormat(FormatOut, UseDefault);
end;

procedure TACMConvertor.CloseStream;
var
  Result : MMResult;
begin
  Result := acmStreamUnPrepareHeader(FStreamHandle, FStreamHeader, 0);
  RaiseException('acmStreamUnPrepareHeader:',Result);

  Result := acmStreamClose(FStreamHandle, 0);
  RaiseException('acmStreamClose:',Result);

  FreeMem(FBufferIn);
  FreeMem(FBufferOut);
  FActive := False;
  FStartOfStream := False;
end;

function TACMConvertor.Convert: DWord;
var
  Res : MMResult;
  IsTheStart : DWord;
begin
  if FStartOfStream then
    IsTheStart := ACM_STREAMCONVERTF_BLOCKALIGN
  else
    IsTheStart := 0;

  FillChar(BufferOut^,OutputBufferSize,#0);
  Res := acmStreamConvert(FStreamHandle,FStreamHeader,
    ACM_STREAMCONVERTF_BLOCKALIGN or IsTheStart);
  RaiseException('acmStreamConvert:',Res);

  Res := acmStreamReset(FStreamHandle,0);
  RaiseException('acmStreamReset',Res);

  Result := FStreamHeader.cbDstLengthUsed;

  FStartOfStream := False;
end;

constructor TACMConvertor.Create(AOwner: TComponent);
begin
  inherited;
  FStreamHandle := 0;
  InputBufferSize := 2048;
  with FormatIn.Format do begin
    wFormatTag := 1;
    nChannels := 1;
    nSamplesPerSec := 22050;
    nAvgBytesPerSec:= 22050;
    nBlockAlign:=1;
    wbitspersample := 8;
    cbSize := SizeOf(TACMWaveFormat);
  end;
  with FormatOut.Format do begin
    wFormatTag := 1;
    nChannels := 1;
    nSamplesPerSec := 22050;
    nAvgBytesPerSec:= 22050;
    nBlockAlign:=1;
    wbitspersample := 8;
    cbSize := SizeOf(TACMWaveFormat);
  end;

end;

procedure TACMConvertor.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('ACMFormatIn',ReadFormatIn,WriteFormatIn,True);
  Filer.DefineBinaryProperty('ACMFormatOut',ReadFormatOut,WriteFormatOut,True);
end;

destructor TACMConvertor.Destroy;
begin
  Active := False;
  inherited;
end;

procedure TACMConvertor.OpenStream;
  procedure BuildHeader;
  begin
    with FStreamHeader do begin
      cbStruct := SizeOf(TACMStreamHeader);
      fdwStatus := 0;
      dwUser := 0;
      pbSrc := FBufferIn;
      cbSrcLength := InputBufferSize;
      cbSrcLengthUsed := 0;
      dwSrcUser := 0;
      pbDst := FBufferOut;
      cbDstLength := OutputBufferSize;
      cbDstLengthUsed := 0;
      dwDstUser := 0;
    end;
  end;


var
  Result : MMResult;
begin
  FStartOfStream := True;

  Result := acmStreamOpen(FStreamhandle,0, FormatIn.Format, FormatOut.Format, nil, 0, 0, 0);
  RaiseException('acmStreamOpen:',Result);

  Result := acmStreamSize(FStreamHandle, InputBufferSize, FOutputBufferSize, ACM_STREAMSIZEF_SOURCE);
  RaiseException('acmStreamSize:',Result);

  GetMem(FBufferIn, InputBufferSize);
  Getmem(FBufferOut, OutputBufferSize);
  try
    BuildHeader;
    Result := acmStreamPrepareHeader(FStreamHandle, FStreamHeader, 0);
    RaiseException('acmStreamPrepareHeader:',Result);
  except
    Freemem(FBufferIn);
    Freemem(FBufferOut);
    raise;
  end;

  FActive := True;
end;

procedure TACMConvertor.RaiseException(aMessage : String; Result: MMResult);
begin
  case Result of
    ACMERR_NotPossible : Raise EACMConvertor.Create(aMessage + ' The requested operation cannot be performed.');
    ACMERR_BUSY : Raise EACMConvertor.Create(aMessage + ' The conversion stream is already in use.');
    ACMERR_UNPREPARED : Raise EACMConvertor.Create(aMessage + ' Cannot perform this action on a header that has not been prepared.');
    MMSYSERR_InvalFlag : Raise EACMConvertor.Create(aMessage + ' At least one flag is invalid.');
    MMSYSERR_InvalHandle : Raise EACMConvertor.Create(aMessage + ' The specified handle is invalid.');
    MMSYSERR_InvalParam : Raise EACMConvertor.Create(aMessage + ' At least one parameter is invalid.');
    MMSYSERR_NoMem : Raise EACMConvertor.Create(aMessage + ' The system is unable to allocate resources.');
    MMSYSERR_NoDriver : Raise EACmConvertor.Create(aMessage + ' A suitable driver is not available to provide valid format selections.');
  else
    if Result <> 0 then
      Raise EACMConvertor.Create(Format('%s raised an unknown error (code #%d)',[aMessage,Result]));
  end;
end;

procedure TACMConvertor.ReadFormat(var Format: TACMWaveFormat;
  Stream: TStream);
var
  TheSize                     : Integer;
begin
  Stream.Read(TheSize,SizeOf(Integer));
  Stream.Read(Format,TheSize);
end;

procedure TACMConvertor.ReadFormatIn(Stream: TStream);
begin
  ReadFormat(FormatIn, Stream);
end;

procedure TACMConvertor.ReadFormatOut(Stream: TStream);
begin
  ReadFormat(FormatOut, Stream);
end;

procedure TACMConvertor.SetActive(const Value: Boolean);
begin
  if Value = FActive then exit;
  if Value then
    OpenStream
  else
    CloseStream;
end;

procedure TACMConvertor.SetInputBufferSize(const Value: DWord);
begin
  if Active then
    raise EACMConvertor.Create('You cannot change the buffer size while active.');
  FInputBufferSize := Value;
end;

function TACMConvertor.SuggestFormat(aFormat : TACMWaveFormat{; MandatorySettings : TMandatorySettings}): TACMWaveFormat;
var
  R : MMResult;
  Temp : TWaveFormatEx;
  ValidItems : DWord;
begin
  ValidItems := 0;

  (*
  if msFormatTag in MandatorySettings then
    ValidItems := ValidItems or ACM_FORMATSUGGESTF_WFORMATTAG;
  if msChannels in MandatorySettings then
    ValidItems := ValidItems or ACM_FORMATSUGGESTF_NCHANNELS;
  if msBitsPerSample in MandatorySettings then
    ValidItems := ValidItems or ACM_FORMATSUGGESTF_WBITSPERSAMPLE;
  if msSamplesPerSec in MandatorySettings then
    ValidItems := ValidItems or ACM_FORMATSUGGESTF_NSAMPLESPERSEC;*)

  R := acmFormatSuggest(0,aFormat.Format, Temp, SizeOf(TACMWaveFormat), ValidItems);
  if R <> 0 then RaiseException('SuggestFormat',R);
  move(Temp,Result,SizeOf(TACMWaveFormat));
//  Result.Format.cbSize := SizeOf(TACMWaveFormat);

end;

procedure TACMConvertor.WriteFormat(var Format: TACMWaveFormat;
  Stream: TStream);
var
  TheSize                     : Integer;
begin
  TheSize := SizeOf(Format);
  Stream.Write(TheSize, SizeOf(Integer));
  Stream.Write(Format,TheSize);
end;

procedure TACMConvertor.WriteFormatIn(Stream: TStream);
begin
  WriteFormat(FormatIn, Stream);
end;

procedure TACMConvertor.WriteFormatOut(Stream: TStream);
begin
  WriteFormat(FormatOut, Stream);
end;

end.
